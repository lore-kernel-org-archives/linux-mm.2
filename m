Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AE5C624DA
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C996B00E4; Wed,  2 Sep 2026 13:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0241B6B00E6; Wed,  2 Sep 2026 13:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4BE6B00E7; Wed,  2 Sep 2026 13:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C923E6B00E4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:01:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED0E01402C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:01:05 +0000 (UTC)
X-FDA: 85169437290.14.BAEF82A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CC584001C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:01:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byKryE9L;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21zjI9Xcw32ih4YadF8IlNWvz6bQgsRvY/kqV5dVaMA=;
	b=ThcfDxHHsoKAnqdqaZZXvxJUiqYOKv1pSJhP5UCpRF1lcnYyd2bipYKqWsH6Z6SqS9VdrV
	VredVq8/Uh4pC9goy/Gs0Yx42URNXQ/TvcnL2AJFlZ4gXzVPi43Di7rRq8RrJrKuUKL+Q1
	XXULtPYLgczYm6lkOLKUTjIpyfRL3Rc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368464;
	b=13y+kLVvcpL1zHN9wfYepthDRdfoULKnk7tX06KZczedTtJjBt5Eekqgc9qLt6nT0ec4O4
	RIP4GJpVZ+GwpaxnUc/s7F9Y3tHbA8oJDAx1FhQ2Dnb6wtWbMDyeOuvaiKb3DP0BUub5/U
	Z8pnMWUOiJKqZZq1udfzkqjvwQ8n3fQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byKryE9L;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDF3A6022E;
	Wed,  2 Sep 2026 17:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AC21F00A3A;
	Wed,  2 Sep 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368463;
	bh=21zjI9Xcw32ih4YadF8IlNWvz6bQgsRvY/kqV5dVaMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=byKryE9Lv5s3K+JQGJImtjfD0byGnvsScT87swdhpJeCwEPWHG+owbO+qreV2oMQq
	 4StXz9oJXoTMiM0g2daA4nVTRZFaC+1gJ6a2ZRFb7amP30a7Ta2uBGTqXK11tujQgn
	 whuBbEpxT+A22/Tvbics4ozFKBw28z0t7Cd4mQ6cbq+fzpMhPl87TpLFzQV4CFkKut
	 URsVju/ZM4vZyGFjLu4YRxSeyA2deg6ZSakhk+aKZ/QMiVsaEZVZbQAczjFaUExjNa
	 NTqepT8RK/JQeDTHQyqksTP5r4jCOmmTiyGYdcJEcnSJwLJSyASUCg7/BTS0m65g+r
	 f+cXQcDlwN4Pw==
Date: Wed, 2 Sep 2026 18:00:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aphS2TancJAZLND7@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902162323.GO3004@cmpxchg.org>
X-Stat-Signature: g5mw83akunh7cwi47ycirdpyczy4rcmo
X-Rspamd-Queue-Id: 3CC584001C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788368464-520371
X-HE-Meta: U2FsdGVkX18ct8O38o68oFHWMlk9nUR7FEtUMDSHOj6fMSRzxydOg8UpqOwXn26FFM/AUgWpo8bA9i8qvsOFJyTyJBIM7rSyO4DoYcxw6LrXLWTRST/VU8t0JsH38NTjU99ubdWmhOwPW0R9gGElkkeKvnXpCuaHeMDkrcyU8ossJ2Wb2snyIWzWS8MJDlIVeUlDGinaoerwtjuEkNWSczkY7ObgtLC83Sn+bpx85esbQTve2JQAd88BQummE3dfihtMf3x8ChfxRtANx7k5e8RAizQp+liQRpgtqYDRPsHUWnUZhPEIt65DAXpIv2NRfiC64p1kXU0L5SG5V1prh/Qqi8MHRV57Au2NSN/S9ZF3VlLsG8Q6Q7ep1i1WmuhFeDAXV8vIKjEkzBUk5yoFnB759qU/OLBWC9YUIfcxkXPIXUN0h/6RKJxqiQYdL896tQ+RyKKU9ZEByInoTLSKRRuQS3noAM/tV50g/Zhm4loKTNeX89JlHJkOA8+4jEuKfsB5kkv/3fuB9r1fXMHkROUy47qSsW62giopj0VYXcip2gWwp+GsFCYWWz1QqL/rfvgm2YMkLko6u/NmgaLFIrA9660eTT1t2XHgjXjc4dkf6E3wSym2xcC3l1KUHf5w6m2iyQFu+VrAed/tfyS+TcElSwGKwuOVpgkZotx0zYMVvSABrTfoiqWCDPIO/cjTq0k7RElzxmhi6ufzSZsWSAd1WlUs/f0gPqngL+sgJdot06sYasYxoJoG+312CuhDtNlfil8uoJWQ+HMWojAzqupUCH6MObI68ijwhVRUwaTGPa0eqBxyuO+w59vwU1/+gVWYusWbD2FBYN2uE2V67qQo0G+5D9n8BqczzJ9Wel/U3/dWfr0ukaEOypqJHgQqJPvFKQpIuhXzmzLh/5ivzGugFOLKx7c6J6GUkX1LymNNMTOL1VwNnYyQbhxrmW1mGuNP5MWZGoI5otbiHWX
 xfrwQsfV
 w9R05SoQOqkntwX2dgXloJHHPf8poydrJWI7dgP5kyjCTuckDSp8pyuMNV57Jw84vkyL/Gt5W1/uUhj0HHeH7g5oHzc3SRLBGmWHlpehNWUI5Ayq4SPb+tJmSRvd+iluRSog5JnjUTGI7sK4n5HNbOCAQ0o36oXlGUQQZ3w25eNbn4+Tp2gC/l1EiQoy/b4XbXSCLoBQCdomFuCv3O+Rx4MX2ssey6RGTYeEfnz5W7R+/lJsFm9VaQZsU/R3NYe1OgIdG0qjtU3P/xZz+2z8s0qb955zPi2D5+IeTsLq/+oP2wvD73pL/KbDWTak5cdMA56XKi6VPc+Udbdwgd0/FeEZM7iu5pVkp0tUnQGlc4vkoPik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
> Just to summarize my take from the subthread with Zi: the premise of
> this patch is to roll the regression dice on every THP setup out there
> because certain ARM configurations result in a questionable pageblock size.
>
> I'm not against carefully evaluating and testing out today's need for
> set_recommended_min_free_kbytes() in real world examples. But this is
> not that.
>
> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

Well you don't have to listen to me any more as ex-THP M ;) but my 2
pence...

Isn't every possible change to address this kind of issue subject to
exactly the same kind of constraint?

I'd like to know what not rolling that dice looks like :) or what
constitutes 'careful evaluation'.

It feels like in certain areas we paint ourselves into a corner where
everybody's too scared to change anything until we're sure nobody in the
world is broken*.

And so we continue to ride the merry-go-round of proposals/rejections
indefinitely.

All the while regressions in tip kernel are a regular occurrence (yes we
don't want that, but they happen), and they are resolved as they arise.

I wonder if we aren't limiting ourselves by thinking this way.

Michal's proposal was that the original code was written _long_ before
improvements in the compaction algorithm and fails to account for those.

It seems odd to retain the same constraints given the rest of the kernel
has changed.

Perhaps a compromise would be to put the ability to disable this behind a
config option or maybe a kernel arg? Of course that becomes something of a
uAPI... but at least it gives the option to constrian this for those who
want it.

--
Cheers, Lorenzo

* I think, for instance, about how the hell we can test changes to the
  compaction algorithm in a way that's sane and acceptable to people?

  Though that is something that really _does_ need it, as it's vastly more
  complicated and impactful than the proposed change here.

  I'm not sure what the answer is really :) ideally we'd have some vast
  farm of machines doing representative workloads with software that does
  careful statistically-signficant analysis of how they perform, but that
  seems rather like a pipe dream.

