Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C8DC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 19:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930996B0088; Sun, 27 Sep 2026 15:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0F36B008A; Sun, 27 Sep 2026 15:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F78C6B008C; Sun, 27 Sep 2026 15:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5824D6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:54:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5BEB140AA8
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:54:56 +0000 (UTC)
X-FDA: 85260595392.12.95FA25E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9124140006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:54:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yX64huLr;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790538895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syrXrC34qOwYKtXT+0y34VtSNtk9nNOuE8xaaaEO4v8=;
	b=HEWKK1Cq7WAorn0Gx8/bnjIwsEIlvMA7UuaJofXZJnaHXH4pLlh3qVMxta+R7Ad9Kp4seW
	cfslzAplSptR51gOgPBM4qiXhiWtwNJGogw41LOamqbFjlU6p8g5pvDEGE7cBTbjRqyvht
	ReiLz+K3g+LO/QE+JYTJvuj1t2yQ9uc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790538895;
	b=CdF3uQH2GTbDY1CpSkjRw3AfuDe/DXXFd4RLKVxD/aRUDMYNIT0NIy7uBXM9Qu9GTq/IIy
	jFVGjng9MOxQjg6l/6bTAtnqdPFkcJ49BpJGC5Kb0iFt+qMjf5GWRYChVCx5ftX22yLDNw
	6MGhVHpZ7V/I93O8eLyPd5CFHw76cOQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yX64huLr;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A246140F00;
	Sun, 27 Sep 2026 19:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAEC1F000FF;
	Sun, 27 Sep 2026 19:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790538893;
	bh=syrXrC34qOwYKtXT+0y34VtSNtk9nNOuE8xaaaEO4v8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yX64huLrYBvawjHjNMziGPcDF408jVy97eCQhDGEdK9ruUIWtHuIYsE+mhNMfqt18
	 Nqxac4sU4f16KAf+zoUW04JYqXg33sc2tfOTTb0EWu8wdgVWka3mOOBCFT22odBp06
	 Fd3pMy/8/YX3DJSXlv/le88Lqf3alNmdUMlUep3Y=
Date: Sun, 27 Sep 2026 12:54:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, David Hildenbrand
 <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Jonathan
 Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy
 <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Lance Yang
 <lance.yang@linux.dev>
Subject: Re: [PATCH v5 00/12] mm: Switch device DAX to section-based vmemmap
 optimization
Message-Id: <20260927125452.0c1ec382905482841a4faef7@linux-foundation.org>
In-Reply-To: <FB00943F-8DB1-4BEE-BF37-701785DE2DDE@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
	<20260926225105.a56f29d76b2f496c8dc2dac0@linux-foundation.org>
	<FB00943F-8DB1-4BEE-BF37-701785DE2DDE@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8utwuhxorwa1hnd6g8zs8jz81b8bcrsi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E9124140006
X-HE-Tag: 1790538894-960188
X-HE-Meta: U2FsdGVkX19Azlw1SIU1CEs6qPLe7BPS6auzI25NAuLoQ2+JeWkR+zSZFaLrI8QYZBizsYL3zRA4pcbiL+in/PoQG7z5tYrhC4JO3XZCFSIbdp2zr03UIefgjEg72HzdmDqD+wDCqjnUoMTKCBDL+u7lMmzfO34mIvl1iH7szYRU9rLiMUlklt0QLEEidopUbgQhZqVgTu/0DO+yDdelHRaExkaG9bmGmidpz1V+aIAtbuCiUZHmlmP0ZeJH3uUMy2gMy7z72h3v2E8H+UVdtCSNnnbuJNvjvXGu6el0pL7khHA1hd4J7X9BZyKA5uuVwimo8VgM3FV31oBbx4JOvp9fvxJ9Xaj56E+4vksVWLFvsuhuwzqAbRef90vCVZ1Svj849qD3I6dy+imKHeZieoR5URNzQVzHuZzcisw59nCaoFcLvXWzubJ2yaJK9AQUVlZIb+kFRretl5WfNbPJWAJl3kYgmxj3PsEsjML7aVw0W6VfB8nTLYDtpdf+Ep0I+031B0NQC8NMtbo6hqsoQtFUjr8Dv++DlFSvTQLBO/bxIo/6SHR3DwMwek1suMUIvW9l792tEnXW98cLJx54rvgqpTkPS4K/ucf804c8j2npGRglAwHdns9d5CPMC8E75btSpMJXcmMYOG9zipy2p35nBr9D5tFjr1av+Sr4X0+cyN5fiZS7mkjD1vjnWdSG+AIddeAxeboAXfcDGPz3uQl5LgZZaEac957j77sJbMxeueWBsvrXMrqYqT1E2aWUybCeZjUuddEhVojOrHuAz66/zKVG48zR3Ua4/6bCf/JCm/YljFZX/WU7c/oyFYWS6NVCWnX8MaUThJMInolfh5/ipLp2mo9DnJ6NVqpWyxC4tnYOqXGMGut+rT6LCo5z26KPNQ+WadLX5eMs04y0XuJbKx+b3QKwobiZjvKhIrUvAamEto1LliM1F/Qvu90WgxV650H/CtTieQChyak
 QXoVwPho
 B3KtpyykFo4LXhsOvjHprj/ZzYkd3fDR9lm1kTQC6eSCjV/mPh5xzGEuHfsHsg6QxiZhekH6ZiENetNrDrhpdMQ9ds17zYOwpXCkCIqnzWjckkEOdfFMdgReoQl+KSi0u2VAhTTj6I41t1bEixWeioL8wziyi1GfWAJLXQJIkw6tzTdNQhzEjFLkO8rAxzn56G6G/CcOjCwfb/mSKY4X6c2C51w/BpE1W687MmDmAYjwZkGF41uyzSJ5VeriZTCEyWrQ6lTzYZAJklbkPFB0o/G5RgAqtOfzohkenyDNpeavGSGxuokGv37v4+lRxkR938Bl+tB2vTrH7oKP7+JmVoW1BwXaSAZaDS2ce1lV64BvgCGcBZ9FKf1ys7kIg1TAMM07UGSv24B8fcY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 18:51:15 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> 
> > On Sep 27, 2026, at 13:51, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Sun, 27 Sep 2026 10:54:29 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
> > 
> >> After the HugeTLB conversion, optimized vmemmap state is described by
> >> the memory section and the sparse-vmemmap population path can allocate or
> >> reuse shared tail vmemmap pages based on that metadata. Device DAX still
> >> uses the older DAX-specific population model, including a separate tail
> >> vmemmap page reservation and architecture-specific logic to locate or
> >> populate reusable tail pages.
> >> 
> >> This series makes device DAX use the same section-based model. Device DAX
> >> records the compound page order from pgmap->vmemmap_shift in section
> >> metadata before vmemmap population, uses the common per-zone shared tail
> >> vmemmap page, and drops the extra reserved tail page. The powerpc radix
> >> path is updated to use the same shared tail-page helper, so the generic
> >> and powerpc DAX paths follow the same reservation model.
> > 
> > Thanks, I've updated mm-unstable to this version.
> 
> Thanks.
> 
> > 
> > Sashiko asked a thing:
> > https://sashiko.dev/#/patchset/20260927025441.741633-1-songmuchun@bytedance.com
> 
> Sashiko said page->refcount can overflow by incrementing it over 2.14 billion
> times when mapping more than **524 TB** of DEV-DAX memory on a single NUMA
> node, where the pages share the same node, order, and zone.
> 
> I am not aware of any practical hardware configuration approaching this
> topology today.
> 
> Handling that theoretical limit would add non-trivial lifetime or
> architecture-specific teardown complexity. Without a concrete hardware
> requirement, I prefer not to over-engineer the current series. We can revisit
> it when such a system or use case becomes realistic.

OK.  Presumably it would be cheap to add a check for this craziness and
return ENOSOMETHING?

