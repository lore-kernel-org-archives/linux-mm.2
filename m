Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75CCCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D336B008A; Mon,  8 Jun 2026 18:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7C66B008C; Mon,  8 Jun 2026 18:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296966B0092; Mon,  8 Jun 2026 18:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140FA6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:22:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45B1DA0331
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:22:39 +0000 (UTC)
X-FDA: 84858170838.02.8DAAA5A
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf31.hostedemail.com (Postfix) with ESMTP id F16E720009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:22:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PWqt6F9C;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780957357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMaWH3U/PUxuaTtJVkRr3vzg+Jb8ytHkTkyCatAiMdE=;
	b=DdRrQ1CH3p7jq/dwqAmUhmXs2Im7rzYynLyO+A0qT8AZwyx8BQuCKJLOSMruG9D7YspTH7
	7oQEMIXlxwQWGbbRDPLY48Owke6fwNFZdll/py+w+54Kt0zv3XOXz4v7Eegzgj+3uzhfnf
	psQAj69HJZmoiiVd6ZrxKaF8CrPBcVQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PWqt6F9C;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780957357;
	b=qzugqc/nyRYZBKoujnZAlBKUEnMSVyBZGyoavoQ/7KmsIISVWFmS3r099UC/aP5PG7vdeG
	OAGim+SrVOQgUzCE7Sj2goJfe7/A3z/N2fWvGAZCwxU6IOE6qP/Mf2jzLE5GnUOy37PeH0
	0No9IkRKUPSO/mDT1xFUWAEVeBW9AoU=
Date: Mon, 8 Jun 2026 15:22:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780957354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMaWH3U/PUxuaTtJVkRr3vzg+Jb8ytHkTkyCatAiMdE=;
	b=PWqt6F9CKEwPgQ//P+2rVaSaqvWcRHhLi/Biw7KvgfDFqSvA49YeL8y+4/aoK+8pIISmWd
	W/NjR3Pz+A+qcCcgQrEnSOWgUpxdAwrhzANRo9RfUy7qD6FF9WpNsecqZ/k9E50d2uCTDP
	rD6zmztQ0AiUQ8YKBbjcgNm+TdNkAHU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aictKA0XWMWbxFdN@linux.dev>
References: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F16E720009
X-Stat-Signature: auurwry9xoe3c8jbozix86pkgq1dyi5q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780957356-462032
X-HE-Meta: U2FsdGVkX1/BQRGXHsJT0PHfpSQnh4tfaxBcAgZ0uI0BlC6ABwnWU1+uIwVReXabNq8zneuJ6KTz5FDVzFcXp/NmieKaggpzMbbZL3QqLzREBXiTXZcnqloWhQ706fmi/zcDXaghWRB7cx5fw5D3QkLVERT82jIYxxd0wwQYFhVHIs2mFHJTH0IxN8K7txEDvLyzdsr7zrv7AuthUzYbfT9xZTMq8Avw7V+oNQfy+jhWGfuoOTurba/AXQIqC9De1dPobx1nriszxv2lRoyQfB8e4orowtc/RCSiT/pMwgaOenxt1TmHM325SLNQLJ1yuzVYL1YGVnmgQV/Jl5hqqcom/R7IjQG0/ZnxtH/g38xX++pBoJLTINZ0dL1n6WoAuICFXo9nXJhzWyxAhGMwBZhtfub5REYFhlb8oq/pu2LCKZ/fWng314C+Y4V51omgBMBI4y04bxffU2BBt9sAondFXPDnuF2GZfygkjFf34W4wIFz/tTq1WTpJoEUgLQOzzWe8ExmEh3Z0j+dyxgY/aOiEFTAnN8uINjY0qAK0isFWJNlHkoHvZRWrURF7pz5dZgvYWUYTnLQ2oqki5LDm9Rp0iOuu3NJ69lRgpLX8UdLQU37EYGW703HJK2cj5t4SrEVRaWId+oikA2mrhcJqbn784atibqKf7Bqmu66kK7St1FSXjEfq36j7WpQR1RObYSWVYaiflD7ssHqWoH2rp+Q5GaWEbZ0Ie3RrhwcHmWHGjS/oa5sRgv1d7eN/3Mg/BhzRLvVHz4LX95obcAjIWXTWIG4GBwmAkOdt6Hzvp8o5SnlOdVseaTYz57/1rv+jvkcdDCz+f8h5X66/rJ6hW3hqpg86+W/icdTmEEh9TzeheJtHFMWy8ByBY33mw5BoXfEkyEYEHdcoHWdjiljjCPWDypNrp96qFtXXOE5cECWDJDcQv6QYQM2VxbViE+0rhUvDM88BAQFZYCwEL+
 L+j53/GS
 kwj/Yo0SlwMsvfafikbZEk0JM+mNFoc1+IZNW3/McBk4SzNuzyMfW0xD1IxpZiMCOtDxaqaACrZKK8wUIk3BGOap2eLty97i5QO+RLi279uUYtLqyH1rWdhm2oKqn6W9JILqXzp9AaBwPJ37v1MBjRgxFiyYzyFOydPV51eBpyTZ1xWofvSFbxeXZHkkkxH2+P0STKDtRpyDsGnemjHD0xPiiEgpI7U03XWT/QejiORzY5lI+xoJfA0fJXMtkGV6YVqRrIFTlcqLdvmxnkWbRpBNPO8kr24tWQls8KMpIAX+gaAi708VfcvCqGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 01:19:32PM -0700, Yosry Ahmed wrote:
> On Mon, Jun 8, 2026 at 12:50 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > +Youngjun
> >
> > On Mon, Jun 08, 2026 at 11:30:30AM -0700, Shakeel Butt wrote:
> > > On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > > > > >> But doesn't it make more sense to specify the compressed size, which is
> > > > > >> ultimately the amount of memory you actually want to reclaim.
> > > > > >>
> > > > > >
> > > > > > I personally prefer compressed size to pre-compressed size. That's
> > > > > > kinda what user cares about, no?
> > > > > >
> > > > > > One thing we can do is let users prescribe a compressed size, but
> > > > > > internally, we can multiply that by the average compression ratio.
> > > > > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > > > > you can follow the rest of your implementation as is (perhaps with
> > > > > > short-circuit when we reach the goal with fewer pages reclaimed).
> > > > >
> > > > > Got it. I will change it to use the compressed size in the next version.
> > > > >
> > > > > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > > > > trigger proactive writeback?
> > > >
> > > > I *really* want the memcg maintainers to chime in here, it's
> > > > ultimately their call.
> > > >
> > > > Michal? Johannes? Shakeel? Roman? Anyone? :D
> > >
> > > Between the options of having an explicit interface (i.e.
> > > memory.zswap.writeback*) or a key (i.e. zswap_writeback_only) to memory.reclaim
> > > interface, I prefer the key option. I have not looked into how much proactively
> > > reclaiming zswap memory or proactively triggering zswap writeback makes sense
> > > but from the perspective of memcg interface, I think the key option would give a
> > > more clean solution if we decide in the future that this whole thing was a bad
> > > idea.
> > >
> > > Next regarding future proofing zswap writeback trigger, do we expect any
> > > potential additions/changes/new-features for this interface? For example do we
> > > expect in future we may want to trigger the zswap writeback only from a specific
> > > node or lowest memory tier?
> 
> The way I see it, zswap writeback is just a "special" type of
> proactive reclaim, but the goal is still proactively freeing cold
> memory. In that regard, I think it makes sense to have things like
> node-specific reclaim. Not sure about other extensions, but Hao
> initially suggested making this age-based, so I think the answer is
> yes.
> 
> For both of these examples (node-specific reclaim, age-based reclaim),
> I think the same semantics could apply to memory.reclaim in general,
> which is why I suggested making it a part of memory.reclaim. I also
> like the idea of having a single proactive reclaim interface in
> general, but maybe we don't want to overload it too much.

IMHO it is fine.

> 
> > Youngjun is working on swap tiers. At the moment he is more interested in
> > allowing a specific swap device to a memcg or not. I can imagine in future there
> > will be use-cases where there will be a need to demote data on higher tier swap
> > to lower tier swap. What would be the appropriate interface?
> >
> > BTW does zswap folks think of zswap as a top swap tier or something different?
> 
> I haven't been following the swap tiers work closely, but personally I
> do think of zswap as a top swap tier.

Same for me though I imagine swap tiers would introduce some duplication i.e.
different way (interface) to set limits for swap tiers for a given memcg.

> Things will probably get more
> blurry with memory tiers and compressed memory nodes though.

I think there will still be distinction between byte addressable and fault on
access devices.

