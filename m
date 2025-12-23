Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FD8E6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 17:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF24C6B0005; Tue, 23 Dec 2025 12:38:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA036B0089; Tue, 23 Dec 2025 12:38:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00516B008A; Tue, 23 Dec 2025 12:38:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C24DF6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:38:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6263B60301
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:38:15 +0000 (UTC)
X-FDA: 84251444550.16.078250B
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 782B44000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:38:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="kzXPMga/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766511493; a=rsa-sha256;
	cv=none;
	b=ZZoidEU6EuMbyOeiIXA6p6VkxTgfLcj/uBx5Hz8v30b5TfUApqWjUhHIfuCCZHtB1qhnNm
	jQn6wkcnSH3YdKSRKgP9WBngOXmgalfcBYb+XJ0YL7CWDpE4UqqTNPbkczcfPzjo89/PxB
	ZtLwICPNzACjqeXP5hfy5JZ8W14ftNY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="kzXPMga/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766511493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTLC7OEVGIoEXEyvllrnolAl7aW+wPLOmIrEw4xjfLQ=;
	b=YF+pKpRq8S0ndk4Huvbx2KQKQPbczpC1xq1b9lZA3KoL2ugeymWgguYUd0iMLnMfbwlv7A
	GexhPeTy7SCBj4m7EL/rlJ2fJt+zw/s0463p/gPQHn4xVik/BqA0q06Wwhgsu2h0+LDxzr
	YvtccMoynLgKpmzZJfa7tG2zwEyolj4=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64d02c01865so4823591a12.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766511492; x=1767116292; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TTLC7OEVGIoEXEyvllrnolAl7aW+wPLOmIrEw4xjfLQ=;
        b=kzXPMga/9dHodI/Zt5U8uW9D7d7PV//l8sNWSThoNAaP8fLXHzN0beqZ/+Up27s1HB
         JQYrjZ331IghWkIUT9hxzyiVObico+7450KATSxPL4dLUMioG7fGhpCHsoOilm6kwPZO
         ZCoKP/xSyWezWCH5cpg4PBG3B+Vy3TxHnwGmOGiokP3lEJu7ytwQdXEc4+mDujhzzJbj
         eYItTy1nRoGRg+0YXQ/U5K9+WB2k3NR5bYAs/YLuQg0bM41kgJyGCKugsu1Kc7eIhAa4
         KgnR1EweXsd6wQz1zNlIe/4t8qhupIIqx0YT2/XeQTLjmivd4nfZ4h7nmn9LISS5sJib
         iKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766511492; x=1767116292;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTLC7OEVGIoEXEyvllrnolAl7aW+wPLOmIrEw4xjfLQ=;
        b=oTkyIQGfFRD4sLrE+P5w0E82aTud6MAz03h6eprHxAqdFa70zB5OkK5VrkrKSto0ai
         fMibnSeZyFwpDp4MQRYTdiXLmXZ90B47kAaLy+Qb6vkI+02b6dMYF0x4uDYC0sYSBvz/
         Mr20t7fb6CwTaPW6PkkDr6ZEumAtXvD0PqocYvRNjA92JqxvlCRWBcJ3SVppqvFuCfU9
         Aaqwe83fQjsyHc2Ac7/717whrFpOdjIF+mdGnf7TD3hpYDPZ41wVbJJ4ZlTWc4AU+f8q
         kmXTwFFb2M+FPTTSKYjG4NkxcsNKjHcJZFObKqCGwbrqIFn0+GWPKNZ1C7xF5Wvc/WYe
         cMtg==
X-Forwarded-Encrypted: i=1; AJvYcCU2sADRApHKC2MKUBg9SJZDd+a44uqae3JBC3OfH6/D6aT1A6vvpWOmgZX4ICb5pRAILLzKis/uzA==@kvack.org
X-Gm-Message-State: AOJu0YwIp+GCwpUkpC45+vgj5ydu2eGJlA1azE5HabiCjlTjQLXTjXaR
	Vx7pikamU0OUxqDZ3hlgHN5EtlFUBsDvkAnnGSziUYdOua8dvgilPaVs94G2XlGDaAapETkBMpw
	EiIc8MobJ7cnkjrelm5Y+JwV2Y0fTmZ81njbwtwtxuA==
X-Gm-Gg: AY/fxX5XX7BP9Vb7+SxYwx7SticAVtIiNaxrafX85ZWtJcr5Yyiih9FkJEV6D9h6GEv
	n6AL73YEdfI82Wz9WtMiIjkjmAmA8jY7N+p059R+F/jZy6xjXZ/AEfp5iaqs4Wqp1EQ0fsLOS/w
	517UXuUCS2HzxfFNKPP7bDnd2dDYu9hiuwdA3CX5skq9ttHi/e3KlljLRBmC3MMSU6GTL62P97d
	NFi0w77BvMAEVh8Ie64vB4RfOVXfUzpclOMed5H9li6mh/d2SpXn62fjk4qERAAPJvWDUUsffCp
	+gDUo3GBI9mwqPxGFHsUp8UOEw==
X-Google-Smtp-Source: AGHT+IE124uBCZCPJySJNjN/QHQdpyXa77YXFpY55orIImpDxYcMb4oh90L3OIkReSgyrytjfimRLEMoj5BCtx1k5Zs=
X-Received: by 2002:a05:6402:34cc:b0:64d:498b:aee7 with SMTP id
 4fb4d7f45d1cf-64d498bb3ccmr7158286a12.9.1766511491347; Tue, 23 Dec 2025
 09:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org> <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org>
In-Reply-To: <863452cwns.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 12:37:34 -0500
X-Gm-Features: AQt7F2qaH0m0VJoMuoVXVcmA15RsVJHyeu9_tkkVe-fDVNFSdl7k8MrpDozG4X8
Message-ID: <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 782B44000F
X-Stat-Signature: iqo5n4dyd3yiogbbekes3x1fohbn8ex1
X-Rspam-User: 
X-HE-Tag: 1766511493-43848
X-HE-Meta: U2FsdGVkX1+498lc6kemaEjiQ7F97Orag4A2jLuUUnSfF7oWrkNY/qaphfgak+gBe6sIsIK5/i/w4A5J4MsxTIN1LTOITrlw4mVoy9Uh3U119PMsEj0joTwb1SBXjYhb1SjIa0G++zyteE39I6lxMa8a665YVW9BHklDeKiZUjapTI6ycA3xLus0P/lDrwpsypDF16UDWvOHUFmeb2pp9QyyfOaMd015q9siF3ekqTdeEDXsB7uhHHzPFkWWakZUYIMtXQ5HXGu4HmFpk4wBoeJh43hpDPkDDKC0Ky/13c2f1RIk8TeN4qBBhpPmA6EP2z+viSmFmAvTBSkQfFR90kFo2kwU4YaVajEwutX2KoBa38PkzNI55OK453BigrebLDYCJA2l0ZGBjVn6Yi1zNtZzZFprHdwPtqYlT820kAdt4w2aSlM+08YVfw3vrVIYTIAHZ+F+peNFfie4KDzcfJh/1gK4G33gl6dWzCxkbizgtZ54AEnzTAlIkbP37hVBKBk0i1Oem4LPtIA4YvaEpobMY2dn2AkjVuXNe76YJQPVNHBepaFK6SROxrtgdssJJm7M6J2U4s1sJGimtspVrnzFZvdap9G/FXa9zx7pf17W63j8pAlTL/aLUN9DtCA31V5AMFukAkKUNeeDZfptg7/Swq+OszdJYsJ/yxet6Oh1yFXUl8qugGvyT2OWR7ec1J73doT3YcRHf0uNcY66E7ycvpPooliCOQ1TtcnAg3shGgFeCvOIjJIRZIcZaxs9mXTorMGs/7FfEPuTI3TvijVB0rs6QJTOdboxfVP43GmYSgrEIL1goDnaJITgT0SUrc74ActAYQL+xp5i0CrgKmVreznmJlCSk/M7pREoHH+GmML+mtyiTZgn/b63O/oElevsZitYyKufjHUp6qvFmFmbZvx9QluB5bOgUah2WPwOmE1sy9037k0xZg5dzBu0To3UaypbqAQVFf92G/u
 WtjtrA5V
 k/qhpoG8DHZclJ4iAu1DH+1KYF8Q2ZW4+FYFUlGPGFGVhuezOT1hMSBbwtVOf9+rEVpph3UwDIcB8Xb88dHr0uusrlNGfWbTsM5KmAFBc/OZ3hzz4nZAtdd1xQThzKqri57ki8nPgjDQTKyJLbNZgM2L3xyViZqzo//7OxhXFVF7YAflkc//Y35kT4j/ynFOkxngO/fAwPOX7150XIsCmrRzzhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
> > return NULL;
>
> See my patch that drops this restriction:
> https://lore.kernel.org/linux-mm/20251206230222.853493-2-pratyush@kernel.org/
>
> I think it was wrong to add it in the first place.

Agree, the restriction can be removed. Indeed, it is wrong as it is
not enforced during preservation.

However, I think we are going to be in a world of pain if we allow
preserving memory from different topologies within the same order. In
kho_preserve_pages(), we have to check if the first and last page are
from the same nid; if not, reduce the order by 1 and repeat until they
are. It is just wrong to intermix different memory into the same
order, so in addition to removing that restriction, I think we should
implement this enforcement.

Also, perhaps we should pass the NID in the Jason's radix tree
together with the order. We could have a single tree that encodes both
order and NID information in the top level, or we can have one tree
per NID. It does not really matter to me, but that should help us with
faster struct page initialization.

> >> To get the nid, you would need to call early_pfn_to_nid(). This takes a
> >> spinlock and searches through all memblock memory regions. I don't think
> >> it is too expensive, but it isn't free either. And all this would be
> >> done serially. With the zone search, you at least have some room for
> >> concurrency.
> >>
> >> I think either approach only makes a difference when we have a large
> >> number of low-order preservations. If we have a handful of high-order
> >> preservations, I suppose the overhead of nid search would be negligible.
> >
> > We should be targeting a situation where the vast majority of the
> > preserved memory is HugeTLB, but I am still worried about lower order
> > preservation efficiency for IOMMU page tables, etc.
>
> Yep. Plus we might get VMMs stashing some of their state in a memfd too.

Yes, that is true, but hopefully those are tiny compared to everything else.

> >> Long term, I think we should hook this into page_alloc_init_late() so
> >> that all the KHO pages also get initalized along with all the other
> >> pages. This will result in better integration of KHO with rest of MM
> >> init, and also have more consistent page restore performance.
> >
> > But we keep KHO as reserved memory, and hooking it up into
> > page_alloc_init_late() would make it very different, since that memory
> > is part of the buddy allocator memory...
>
> The idea I have is to have a separate call in page_alloc_init_late()
> that initalizes KHO pages. It would traverse the radix tree (probably in
> parallel by distributing the address space across multiple threads?) and
> initialize all the pages. Then kho_restore_page() would only have to
> double-check the magic and it can directly return the page.

I kind of do not like relying on magic to decide whether to initialize
the struct page. I would prefer to avoid this magic marker altogether:
i.e. struct page is either initialized or not, not halfway
initialized, etc.

Magic is not reliable. During machine reset in many firmware
implementations, and in every kexec reboot, memory is not zeroed. The
kernel usually allocates vmemmap using exactly the same pages, so
there is just too high a chance of getting magic values accidentally
inherited from the previous boot.

> Radix tree makes parallelism easier than the linked lists we have now.

Agree, radix tree can absolutely help with parallelism.

> >> Jason's radix tree patches will make that a bit easier to do I think.
> >> The zone search will scale better I reckon.
> >
> > It could, perhaps early in boot we should reserve the radix tree, and
> > use it as a source of truth look-ups later in boot?
>
> Yep. I think the radix tree should mark its own pages as preserved too
> so they stick around later in boot.

Unfortunately, this can only be done in the new kernel, not in the old
kernel; otherwise we can end up with a recursive dependency that may
never be satisfied.

Pasha

