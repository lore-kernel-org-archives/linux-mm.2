Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E517BF8DFE9
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 17:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00236B012E; Fri, 17 Apr 2026 13:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0DD6B012F; Fri, 17 Apr 2026 13:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FC56B0130; Fri, 17 Apr 2026 13:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAB46B012E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:24:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 328F31602CB
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:24:57 +0000 (UTC)
X-FDA: 84668723034.11.22E8424
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2FB401C0014
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:24:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e06uecD3;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776446695; a=rsa-sha256;
	cv=none;
	b=nZCAFRuDDYM4BtGd++8UaZaP+xzCaSAfcMlQ7bCxhZYtvHcgBguptmf5Vyv/Tx4TuMpYu8
	EGosovQdm+y/WuuVXCX9GnAJi+UZSTvQ2XINy8bWVMfyPta+L3P86XAu7aqH/J3RNmHv5d
	sxU+mNHsAwYS+LYXG7XFcFLpaeQA6aU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e06uecD3;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776446695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyFiZOhvljUSTmlMAtWIZh4RtLHlCzqCjHl9pwEGxDs=;
	b=EUnB1xUL7VCRjXEE36n2Q6hj8dXw810Gv40b0J62sL/EiVGFvs4eMkF2DwKyibKiM8QrjW
	O5nkt3JfJPUhM6WimkmIShcEFp2nVjHVeDU8MYYRmo+BDdx6z2xAXLsFtN6EtaaQRcf9za
	KYCznePQwgTsg0uJt3xS4whnP+mD9XU=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38e68e4389cso9756921fa.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776446693; x=1777051493; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wyFiZOhvljUSTmlMAtWIZh4RtLHlCzqCjHl9pwEGxDs=;
        b=e06uecD3j4xVfKvpLvrU/qISKL9eAK2vgpccy5JOkdq9Lnc7nLNsIGtkkQd3+wP2zy
         3VXTWTQhQsgKE9lzj7zcDevwtPnr+GkRAC1vfh2UGj0FcosPE9rR36WYcX2PkUfIXFtn
         pcnQL5IvgGzF7cyIK5qrrLUiA0OfNQHeyLS5py2vTRCHKhvmX828OI9lgWxEEdgkezop
         8/NCmqgasqrtPJxOAYR+ciFrneKFS+0W9O7EyF+GOXewGLejzQcoXeOCjU1sv9snbrB5
         kiH4P2d0ImaHY4uwPFH9Vsf9hUNWc+CuvwwbnSjc1LcmyuKh1d29ts/AdD1uxqN/Zwbk
         /mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776446693; x=1777051493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyFiZOhvljUSTmlMAtWIZh4RtLHlCzqCjHl9pwEGxDs=;
        b=pYcOLsPXxw2RezTahV8HZiaFh+cty3IeUgXavwLL0a/AxzLaWtRO7QxOk9K1S512R/
         ONUv84a3QFiQCB+vtytWWG4Dj4NGlsw2h6WjJ2bVvEvZa8S6LcIXbGJf2zRQLCl2HVyq
         QDbphOkTf/rSwmGDRY8tZmwitFOGhzPkxq+GJ0OwqUSgeg/TcQDULhl5mjAZgw/tGn4Q
         1pcBUSKvxfTzT+0cjhLqPgKklhG2jsHSfG7xz5bDPAFm71KCGvBfmDe/jw3+keEenbRj
         u8rSPxTMJ+H1JXvj9skAEiINuhINtNPIByDTyWRAEi8O9aGrv51oLXs8lC0UPZ6QK9Gv
         0QBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mJkQK+Fq2WlL5XUybccgH8Fr8UnDW4xBUZihqkIQ0JF8rzFEwcfwDRvE9oInxlcSKM+LW6XXa5A==@kvack.org
X-Gm-Message-State: AOJu0YzF3iUHF1ZU+q62q3e+4jcMyDgI8FPAXHbvpImvxPocQLEJJ1JY
	DJbI17V/sRJ5TVMc57ZU76lJUEGnhWSoedaHk8KZgE8Q+n+udMlzS4CW
X-Gm-Gg: AeBDiev9uhFz9kMJFXlxCX7GAl4amrLZYifUNOqBRtx3w25q3qwAMhu7sNkhl9XzKY1
	V4Sl/+ZZA+I+C8pj3BYMAXP4v+tayhoTrE6GJL6snGN9CR3Ha3BxP37IDzKqFwCepahA9wNk7VF
	VnXyfyPtq9ftMOK23iNgrowB+398mMDPic0YfHP2ZSoW01m4cbdGpaR0EleuuIuHoSWYsXLd+68
	zTFdKEvaiqU9g31HTFaEtJuLovXB7tRo3Rp9PqzRWSd0hkHWuDAsOJooFbsOl5NLFIxzNTWqVWA
	W8wi8QdHnfIp7YQNrAO1MC5X6yYA35bklHwEUa7alIAvM7JIY2czsMjjhBZdRgQGD135pI2ZuUk
	RurnowRVpBtdFubOoLiIkUW1b4RYqmMpNqR3KfaAWbvb0a6wHuCW5ZKrPTo72SYJTfh4XlrgHHj
	M=
X-Received: by 2002:a05:651c:f11:b0:38e:13eb:f0a2 with SMTP id 38308e7fff4ca-38ec7830e30mr13004751fa.8.1776446692888;
        Fri, 17 Apr 2026 10:24:52 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb4f54ffsm5246531fa.1.2026.04.17.10.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 10:24:52 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 17 Apr 2026 19:24:50 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-ID: <aeJs4jmco7BGCNHq@milan>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com>
 <ad_cpqx38LtQPlX8@milan>
 <85a9f419-7f1e-41a0-9e8e-67aae7a1b0fe@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85a9f419-7f1e-41a0-9e8e-67aae7a1b0fe@zohomail.in>
X-Rspamd-Queue-Id: 2FB401C0014
X-Stat-Signature: mtaickkgktrgnpp6kgzienzrt4shfaie
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776446694-971674
X-HE-Meta: U2FsdGVkX1+caXQGnSs7dW/TPZ5+yYQIy9OZRSnPhgDYjglcus37RE7kuiNM1mCqem2xMXkC0EDczfhN5N2i3pkFEEXrfcFHgHazMrHUmbGayLubHKJugd0blLq5PDI6ZrIHmp34XszKA+L3htTKxOkzfoQzqzzglHF/INiCzeOE+qetaBSl0DLbfWMCmwxQDbyoCTApx8aVSSgZ2as/mTWAM54igKu2KZCB7S6gGErowseIkhDFtYRwROQNBimP6caWYOIPAAa8ECtWvg4o4NXlEW1W0THEV/npfM9MwleiLqdMypbdZqkGnOoNCGG06a8Ufwsh8jrXvlzbFQdJ1BvQrT3d9NR+WCZNzinMrFoLgn9Evn1yPHmQNLA1qsXnc1CCTClHiFtM8MNkYfmZnnizLk85xInSIjuJDP6xksNpgxH5ANMo4DpRjEitsYpVc5EqIDE9IBlPDi4MSfo98yi1mLRXX2Jf7ZEbkF+Qwyq4gSVuFLEO/xD2dcfgqrZkhmOnK8LZddH6/HS5wauemzfeEDSbYGR3WxNMiW47rdsyZpFqdyicgRfTOmArFaDN9dFznI94x04MnqK0OND7KL3igMBKoNwzk6gMNRFDWQBaDYEBq/8EsPFV+i6UCWB7P7o0el1ujNk1TRbb6g+Jn3PUnM8gS76LRVKedOM9joyCAEwop9Al5eBG87jF5vfIaySSsC/QGMs3EBFYpFGHikx+WWvb5tC1xHvoAYRCclN9A0T3N3y6DFoPh5OII9962/ljkRUjCRUJXhgsp9PJ6jN5yhvuk5qHv+dFTK4el3vviUuggV93lrV67CJvT1PoQmPIlcAI0lffxrMrpLqf1Y9Acb2/kZ5edaVtKgBvuYolGHg9za8xAOg7VSE38tq5Az8Wxxctshvp8Wtw/iEQWwV5EYgn7kSc3I4gR6brQSCRIHqDSbeqn3gEdGCcK5XAEQ+WMzaOiFZ3NH4FRsP
 vxBaUfWm
 PObtOuLIOB1BNO6T264vm4nx9E7XVIIY9IhTg86Cm1rUS8n1vMFqO2K66Vnhdkt47pbn6xEYutdY0f2slCJU1jOscDJidRVjVELlH7zl43q0z3f32Hbu/3anLP6FUUhrWSDJyZf+gRgkmy1vMeLRS48p7pVMDv4s/fBDuz43cRonvUAgkb+64GHQYJokqChwcuZzw9QcGr5dEYYbFWARVBWu249ScEcEER8nji0pooKQAQg3PuVq79eJDj+8TqL5D2J8E+wYs4CNYC+m5Q5BysYzzJaR89q1pjvbel+przKW1RTyPbr8I8vxeF6HkajEiMY+PzdaCFTNEQRmpOUQ0utdz4UdxqOpfUhdrno++ZCb+2x5xhNN/vPuLjSfayL3dquE4H0IS/gx4RNyas39GuzzN/t/6TsBxPKgo5NtjNeIGuWN/wIC0N01VrMxjwPiCKeJdXVcMuVq18bLxZyhvEbsnPbp7g0o/Y9Et
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 07:05:09PM +0530, Shivam Kalra wrote:
> On 16/04/26 00:14, Uladzislau Rezki wrote:
> > Yep, the problem reported by Sashiko regarding area->size and vread_iter()
> > is correct. V10 does not address this.
> > 
> > I am not sure that reducing vma size is a good approach here. It is
> > widely used and we might end up with fixing even more corner cases.
> > 
> > vread_iter() and vm-size calculation there should be fixed.
> > 
> > --
> > Uladzislau Rezki
> Proposed Change for v11:
> 
> long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
> {
> 	struct vmap_node *vn;
> 	struct vmap_area *va;
> 	struct vm_struct *vm;
> 	char *vaddr;
> <snip>
>  		vaddr = (char *) va->va_start;
>  		size = vm ? get_vm_area_size(vm) : va_size(va);
> 		
> 		if (vm && vm->nr_pages)
> 	            size = min(size, (size_t)vm->nr_pages << PAGE_SHIFT);
> 
> <snip>
>
I have some questions to clarify.

Why should we use min()?
Checking vm->nr_pages, can it be 0?

Can we just do:

if (vm)
  /* Can not use get_vm_area_size() because of realloc(). */
  size = vm->nr_pages << PAGE_SHIFT;
else
  size = va_size(va);

or i am missing something?

Thanks!

--
Uladzislau Rezki

