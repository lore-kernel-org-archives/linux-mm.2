Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6249FCD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 04:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BC66B0092; Sat, 23 May 2026 00:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5AE6B0095; Sat, 23 May 2026 00:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4A26B0096; Sat, 23 May 2026 00:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84C546B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:00:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25DD91A09AD
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:00:35 +0000 (UTC)
X-FDA: 84797332830.26.9635BCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A1F420003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:00:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d5rQFnOt;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779508833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYfwlBoIkTxQjX6100mlVLUtbaP2TS53vxqnbDjhphY=;
	b=oBSwA+3TRSV2USBtl3ztG7UKayWhyYX7Esrfsqrl7ZCBVhPaHVneUENPNOgtMcN2ViQoJm
	MYOb6W2ZFmMngmvQtAriSTbx6oeyGas1bugzmOpad/tlmk262R/hUrfU0/PartdC1lRBUD
	FZkYCU095VIOEmtrjAVGledoMFWTvlw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d5rQFnOt;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779508833; a=rsa-sha256;
	cv=none;
	b=tjDe5PwfEkxwuKvY+/fvAtvNJoi8Ym/ojm8TP6KJDFAny5ygi77bu0zfxoDJoJhB7+8hVi
	lg+4bLfakeX7AvrCJFWG89sY2RjogL2NlHnnudKaac7HS/Caf7YXTncYcF4apP0LIldvld
	NFdPWJwwTus6JhQvR0EEVa8iIEqWACE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8CCD60103;
	Sat, 23 May 2026 04:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0BC1F000E9;
	Sat, 23 May 2026 04:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779508832;
	bh=SYfwlBoIkTxQjX6100mlVLUtbaP2TS53vxqnbDjhphY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d5rQFnOt2PYBgehQp1D+DGRsxE2mUjtNAGKuoMDItY0hFrfkpoTt1ESyftEqFaZlu
	 V43rgjDi9XRHoxPOx4eqWq+ypyojU4p+HepHhYGlz8qSeiZVTTl/mMOupYC2S333H2
	 D38MBJN0SNuuf8BRQaEwN3T414GnXFADbKVH0b+s=
Date: Fri, 22 May 2026 21:00:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/7 v2] mm/memcontrol, page_counter: move stock from
 mem_cgroup to page_counter
Message-Id: <20260522210031.6d5e0debd687b39b87c87501@linux-foundation.org>
In-Reply-To: <20260523025051.170871-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
	<20260523025051.170871-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A1F420003
X-Stat-Signature: g3rp4kkc37xsjkjeptya4nqxmohjeb58
X-Rspam-User: 
X-HE-Tag: 1779508833-875005
X-HE-Meta: U2FsdGVkX18kyzPKfwPoIRaNVss9zE7VPQIsmqY4Iu+n1wCjJL6TFZ+0JuEOijBrEoDhUxIbD65RVIdvfGTpJSC0mFFvYjTnX8FznZd27SwQQu8TuG1m0BaDADp/yriUg1IM3oAJRNWZjtGFjk2qQMgsvRRMuRawE7wp5PEm2MN/hTMwwzWc1v8beFq7forJMIm9otTxnzKClHfU4bjetzOzRFYQ0STHXAxfz5dAPVPjXg+bmqgAIM2C6htOiB4LRY8KTiMKbVyn0ZnvxnK4jLNbC3rn4l+vc62XjDiF/A7s9UlmsxcvN0+QqvuURpHWigvEApwwHIF+F+M8JSEkfLvdHbNiod/RE/bxzQpOudfo7p1FL6RkeX39cYxE6uesPnMN+oZ4fUyl+fSCAsLfWlBztot+a59sEgxve9CRhKpcp1J4TEIEe8yF/eIKXVz2iDbJEJ8CGvlYfSjd8eT3k9M2HcrWnWH3XXAHyhVVdc2usLFJ5NRxGzr4V/ds8PQdxA++TaFKPQ49iXTDZONPqPIO44VJDl+N/trm2mTBaTRTDfIY2an2QwcoYLAW4ECVwpG6qAsP0LV5jVe4Bm8SyeLWCGPXSJZQhexASaQEJGsm+DOrQFoLpC8H0Jg3WUWfnh4F2EtaU3SbRPnAf2kumq38SltXQaWwaTBoZfwsqIe6wUK5MF/izuv8+YPNPxy/38YZJQ/AD4IT38IieApW7AtViqLMHN5sZxC3LuuXyNUe9LDNFGBchmOfypqrQ8NXraIyap51JmTTmTlr6RPy5InvTXKlbc/xBZo37S7lvPu8y/SZNSHIcI5zfo54Efa138AVEGAQ3/vGlGESm48lhoNwF51GPXRvdlc7ljQ5v1v6hUVKlDjb34FugnPBxrLlWG8z9Bz0dd/ii3/8ykA9J1BlzeiETJsBZP3ktKXu1AJSGmh9llRlPKi7oi6Hy7GBwvGK/o3KUSlxHQiFRar
 jm1C3hbC
 u8ariVmlrdVsoz5QBPhHL0nULZQeWaNXWomgxWslcE2qlb+2S79EY2afTm7DINu7AV6nnqxjvVNxbgu46dnMJC9t3CjtA9CMnV9sxEeNsiSjQgOcOftarZZ65SzvDvfv2InYjUQSWBTt8TVerM0/BtD0IkR1WOV+aCTly4b+IxrU4wLaNH9f9r49+YgAUoAv29lGW/lYhVGjDGA43PINjy+BjJ+hV7OixMvFPAKrz4aOwpqI06rxWO6ph6EveBbYglSZbemMAS12IGYJXhjfEy8eiADesOTOzA+/2+rrHUGM3EBQu+m91O3OYgySTHaM1GoKt8P5kSSSfQLfiVev6THRb7Wtr+3r3gNGoGjb0KhV7fNxkLCYDIScqD7j9UHPyCWn4xBj0wueYrm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 19:50:50 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Fri, 22 May 2026 15:06:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> > allocations, allowing small allocations to avoid walking the expensive
> > mem_cgroup hierarchy traversal and atomic operations on each charge.
> > This design introduces a fastpath, but there is room for improvement:
> 
> This iteration was developed and tested on top of mm-stable.
> I'm seeing now that Sashiko cannot apply this patch, and I think it expects
> it to have been built on top of mm-new.
> 
> Reviewers -- would it make sense to rebase this on top of mm-new and
> re-send this as a v3, or should I wait for feedback on this cycle
> before sending out a new version?
> 
> In any case, this could have been avoided if I just developed on top of
> mm-new. I'll be mindful to do that in the future.

Sashiko does attempt various branches, including mm-stable so I'm not
sure what went wrong here.

It's a bit of a crapshoot at this time, as mm-new is still growing like
a weed (19 patches yesterday, 24 so far today).  Slowing way down soon!
I'll be pushing mm-new later this evening and after that it shouldn't change
much for several days because we all take weekends off, don't we?

Convention appears to say "wait a week before resending" but IMO
there's value in parallelizing Sashiko review with human review.  And
it's understandable if some humans aren't very motivated to review
until the AI thing has had a shot at it, because that might result in
alterations.  So I'd say that a resend-for-Sashiko is appropriate.

