Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB50E674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D842E6B0005; Mon, 22 Dec 2025 10:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52006B0089; Mon, 22 Dec 2025 10:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30656B008A; Mon, 22 Dec 2025 10:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3626B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:56:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D7681A0259
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:56:15 +0000 (UTC)
X-FDA: 84247558710.03.D7913D4
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 503E4A000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:56:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WIiVKjSJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766418973; a=rsa-sha256;
	cv=none;
	b=oKOHn4qyQ7d8Y1m24tGImq6P/nDkr2a+QKkCoOkn4aTRptD0SPiYmypd8HMYgeyt8ji7CF
	M0/eXbq8S1dSmsZkHyh3IrxuGJrD3tpSL9Lr+LleQ2YP3hT/oVlAclvcxoxMr7lguCTV4Z
	WCCU6ORHUdLawUYTQKGrdZtsyofkPaQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WIiVKjSJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766418973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmNs3UwGZr7nK6ylT0yHv/l8DmNd4tuOSujZj63Dqws=;
	b=k4TnwjZrdtCJEKzTE4zxIM27kt17ZUIgVZVdYxntZM+/V0houf5P10NWcIRHG2jtWRpci0
	v/BzR35OUITFVgrukfwCx1InHTv5ri5GfzJtLFSvHo9CX8+9ibOhe1PKJDzVWDZuJr0IHp
	OTfqTyge8Ov148fnPUO1YfJSGruMRdM=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64d80a47491so1593864a12.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766418971; x=1767023771; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nmNs3UwGZr7nK6ylT0yHv/l8DmNd4tuOSujZj63Dqws=;
        b=WIiVKjSJp/AFLyr0DvJOQtSPFkqnU9ejwieq2r1t5li6I4WnQBmcdW7rZ5Gnbr/YCR
         F5rZlIZnRNvp6t3qnXmgVp1lU5C2lNvINwXN63wIP35bNI1I75Im+5Qi9qmdfz55E4c3
         umXyqpcRLB/akDeoRdypV0HEllikmPeFuEDB4uuvK7jsmuDCRt/GhyLJjOCSKPhaZDY2
         0YUFvQK8k6vR5TBRFbo114UvJr1P5Z6+5ZlbAEO1hwujr6khYwNQbWtD+xvKzDxM2zHH
         WEMuUWoyowP20M6hSApkZJr6MyrYVZ1qW6mS/6+Fr7byQhVZDX0OUiEbbvfthqU1XA/h
         /TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766418971; x=1767023771;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmNs3UwGZr7nK6ylT0yHv/l8DmNd4tuOSujZj63Dqws=;
        b=L1Ykhxb1+LgxIFjuM3gAGkOFqpm0EFJhyI/goFC/FzxL5Ob2LilVncQWoH1vah+VzP
         ugP0FIDYarWGLrzFx3Vz1Yu7FDsaBCkpOmvOw2djv6fJ6FkKvi6ENUtv1t0lTM8QgiPO
         SYNKnlHtDKvRzniNxzdZI8ySmsT+7DjRhwvOVcRCJYMgYGfWJhu+GiydLCzyv8kvUtOe
         I6vVVWgAMtGMBVcoxd48Cn/ox8TCqovyKbuF3bT8RLH8BuJSiLPbosORhWOdtqqdKJFj
         4SXpz2ExMvSToPbRw3K/K8ZDV7lA2jkyJzKgPgbzC54R6jZVd3iZHrO5Np9fkEK0PsUM
         gr5g==
X-Forwarded-Encrypted: i=1; AJvYcCXYoB3qeIkDnlV5MWjcwBobOHwWiFKBE8+VftiSmV66zOCK61E3szyQZbCVLZ72WNIEs1ZqIYcu4Q==@kvack.org
X-Gm-Message-State: AOJu0YxBTpaFCT6nyHdhvwiNISmnWomKQ+de75TRMkmRh0RBafeoOnTb
	7b5T96VwWToKlrVjPv4iPfr5aolplhlvWJ+LUDNf0w0ur0e+7JuObcZxGng5y7iUBFQ/LO9zHn5
	oDLdTEoJaVfwCyBicaghSHh5XSDutrFghKNFuqQA9gg==
X-Gm-Gg: AY/fxX5cTM8Vi81EU8UyCc/Hed0y/BL4U87OqlXI/buV52fWqc+xNUvsf6FfLqItQBU
	jx0T+Dx+XCsLKovjh46905za9AUD9mfkUOJD7a80r8HaK+1uDCJ6jWb1sAg29d202JB6Wbr99bC
	cJ7A+Ddu5YkpNYVBo2W5TsRTjG+Jx4vuHrpwOzSvVKmFYph5uOGM44Q+x0m3mu3x1AC7IzSN+hB
	cNsYgJcSBc+3vU22wmVVoki+nNTkkk55hknFdYJ9qCHdVdhvqWJHU0/UV+SpZ713fjc/PLdEZlA
	jDjlG03Dq7RqqL9OGheTm6n1
X-Google-Smtp-Source: AGHT+IFEBAeFCtUhSPTbc4A/9WLyV7z0M2uSHjsZD2E0OEjezgIA0DyueqQgo6GKqcyBRi3/5gblK0XZObEH+LeqhO8=
X-Received: by 2002:aa7:d0ce:0:b0:641:7cf4:552d with SMTP id
 4fb4d7f45d1cf-64b5833c86dmr10687656a12.0.1766418971102; Mon, 22 Dec 2025
 07:56:11 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org>
In-Reply-To: <86jyyecyzh.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Dec 2025 10:55:34 -0500
X-Gm-Features: AQt7F2rPWh34v3gLfcQrWbQB0eZHj1dwNG_vdzmClZfskwU3PjPqxiYRCVmv4Uo
Message-ID: <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 503E4A000C
X-Stat-Signature: dgfoyojj1pzggfuh8pmmrxpyrjo9qao7
X-Rspam-User: 
X-HE-Tag: 1766418973-762090
X-HE-Meta: U2FsdGVkX188fHmMVL8gXGvCKbsMhN/6UdtgCNSXaszqVMNu/Zc/DpoMssvkJr9MvoGTXSElVtLakbk9v3QV0eWQ/Vq1I2X8bVw6eQVnFQbyRhgbNkVAf6Ilt2xJHZ4YFDqaDaugh6Oj7W0sbSlx0V9qolkAodgk7X9wdmfsMCqKfAYu1tc+68li4PQoC87KaEFJ90D5SKmDu0oykUdJckOoBtL4w04odRyK2cWYiOByF9zY9h56Cw2P/LDePSxnQJbPwmHBnBb88ty2zU3DauJgPggOqM7bZrOPpfbDTLEyvVKKIWDC546hSJOpiFNCtMscfDorXXHZqiRfIEG/0ILdJEmBZzzQpaTjY316y/OJJCf7tZ3+bnwLjIRye4OiaeP+bTT9OakCo9XSGR1vOmvD2cJbj4PHYpAAI732AcvP30NmgcYjqd0TZf5bG4GY4dvetN+NwiQANHKV92BGFs85bHRS8FAGV/MRpD+mxUtp62CEWrcg6/9R/upPH4o8ZCOuCw8cHlauhlpfbHCP7CS++8PRc3xZ6a7e1QHvTt860KKBIgS5l+sR7JF1tqeM0GN4E0pWWnJC0tS8f/XkVLQDX4GfHxTDo1P6nVoQahES962uF7jwGpGaF5rbLPsYCoklT7MFKP/10z3CztNBU/gHpwG3YAz9V+bqe2PAcC391IpbrGFu9Zh3TFHa3gWVrwZwv8r2cn6qBOAec8joqEhVJmP9rRIZLoli7LpyBOPFInyigsouoDw6+oB08FomupltwRZKthUFE8oJcwih8Idx6iKNpAzgoISgPpHD6rqNv9DO7E160dIDmg2TGk5By05ad/yP8LBngBXM0HhKygAJppQik6PGYYOzA1Z1hRkBdo6l8SLJ8zveMFxrgpEm1RAg8jRlOERZM4K/tdInOiGOEApkUI00HfvEVmDRNTXJeNF0RR1dqNs0bfvmQqIN9SNYyP3pjJWPgrvaGJZ
 OOxHWe4Y
 mVT8PsEYfqgelcZbxd+4+u1Q2s47mXK9ZOdsVDrwPQcv/tqdej/uamH0l8ImIvbm78Bqo1pLMZAgHMD0atF0WZxkp2xme0LIc2um6T2OTBf/9EmQAtJjfP9WV7whggKtAI1QLnicByCA4eIsD5zvfcVYwBZCvC/M7a4uMpgSu6yvKGiMeCKjwboxID2akXjVeq1PK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > NUMA node boundaries are SECTION_SIZE aligned. Since SECTION_SIZE is
> > larger than MAX_PAGE_ORDER it is mathematically impossible for a
> > single chunk to span multiple nodes.
>
> For folios, yes. The whole folio should only be in a single node. But we
> also have kho_preserve_pages() (formerly kho_preserve_phys()) which can
> be used to preserve an arbitrary size of memory and _that_ doesn't have
> to be in the same section. And if the memory is properly aligned, then
> it will end up being just one higher-order preservation in KHO.

Both restore pages and folios we use: kho_restore_page() which has the
following:

/*
* deserialize_bitmap() only sets the magic on the head page. This magic
* check also implicitly makes sure phys is order-aligned since for
* non-order-aligned phys addresses, magic will never be set.
*/
if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
return NULL;

My understanding the head page can never be more than MAX_PAGE_ORDER
hence why I am saying it will be less than SECTION_SIZE. With HugeTLB
the order can be more than MAX_PAGE_ORDER, but in that case it still
has to be within a single NID, since a huge page cannot be split
across multiple nodes.

> >> > This approach seems to give us the best of both worlds: It avoids the
> >> > memblock dependency during restoration. It keeps the serial work in
> >> > deserialize_bitmap() to a minimum (O(1)O(1) per region). It allows the
> >> > heavy lifting of tail page initialization to be done later in the boot
> >> > process, potentially in parallel, as you suggested.
> >>
> >> Here's another idea I have been thinking about, but never dug deep
> >> enough to figure out if it actually works.
> >>
> >> __init_page_from_nid() loops through all the zones for the node to find
> >> the zone id for the page. We can flip it the other way round and loop
> >> through all zones (on all nodes) to find out if the PFN spans that zone.
> >> Once we find the zone, we can directly call __init_single_page() on it.
> >> If a contiguous chunk of preserved memory lands in one zone, we can
> >> batch the init to save some time.
> >>
> >> Something like the below (completely untested):
> >>
> >>
> >>         static void kho_init_page(struct page *page)
> >>         {
> >>                 unsigned long pfn = page_to_pfn(page);
> >>                 struct zone *zone;
> >>
> >>                 for_each_zone(zone) {
> >>                         if (zone_spans_pfn(zone, pfn))
> >>                                 break;
> >>                 }
> >>
> >>                 __init_single_page(page, pfn, zone_idx(zone), zone_to_nid(zone));
> >>         }
> >>
> >> It doesn't do the batching I mentioned, but I think it at least gets the
> >> point across. And I think even this simple version would be a good first
> >> step.
> >>
> >> This lets us initialize the page from kho_restore_folio() without having
> >> to rely of memblock being alive, and saves us from doing work during
> >> early boot. We should only have a handful of zones and nodes in
> >> practice, so I think it should perform fairly well too.
> >>
> >> We would of course need to see how it performs in practice. If it works,
> >> I think it would be cleaner and simpler than splitting the
> >> initialization into two separate parts.
> >
> > I think your idea is clever and would work. However, consider the
> > cache efficiency: in deserialize_bitmap(), we must write to the head
> > struct page anyway to preserve the order. Since we are already
> > bringing that 64-byte cacheline in and dirtying it, and since memblock
> > is available and fast at this stage, it makes sense to fully
> > initialize the head page right then.
>
> You will also bring in the cache line and dirty it during
> kho_restore_folio() since you need to write the page refcounts. So I
> don't think the cache efficiency makes any difference between either
> approach.
>
> > If we do that, we get the nid for "free" (cache-wise) and we avoid the
> > overhead of iterating zones during the restore phase. We can then
> > simply inherit the nid from the head page when initializing the tail
> > pages later.
>
> To get the nid, you would need to call early_pfn_to_nid(). This takes a
> spinlock and searches through all memblock memory regions. I don't think
> it is too expensive, but it isn't free either. And all this would be
> done serially. With the zone search, you at least have some room for
> concurrency.
>
> I think either approach only makes a difference when we have a large
> number of low-order preservations. If we have a handful of high-order
> preservations, I suppose the overhead of nid search would be negligible.

We should be targeting a situation where the vast majority of the
preserved memory is HugeTLB, but I am still worried about lower order
preservation efficiency for IOMMU page tables, etc.

> Long term, I think we should hook this into page_alloc_init_late() so
> that all the KHO pages also get initalized along with all the other
> pages. This will result in better integration of KHO with rest of MM
> init, and also have more consistent page restore performance.

But we keep KHO as reserved memory, and hooking it up into
page_alloc_init_late() would make it very different, since that memory
is part of the buddy allocator memory...

> Jason's radix tree patches will make that a bit easier to do I think.
> The zone search will scale better I reckon.

It could, perhaps early in boot we should reserve the radix tree, and
use it as a source of truth look-ups later in boot?

