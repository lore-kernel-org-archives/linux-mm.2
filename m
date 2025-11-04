Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8081FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 11:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B433F8E0133; Tue,  4 Nov 2025 06:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B878E0124; Tue,  4 Nov 2025 06:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30B18E0133; Tue,  4 Nov 2025 06:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB638E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:54:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23DF81404AF
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:54:05 +0000 (UTC)
X-FDA: 84072766050.14.E50D657
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C520C000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:54:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M4eUQRTL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762257243; a=rsa-sha256;
	cv=none;
	b=zt0YbzdpAdxqYTBfykiJ3r3sQEU1RM4I/5UqXYGtm9gEZHUTA27tEuoQPEu6sOECXLjQP7
	R0MPmuSVXt/G0wQp9e5Z6rOmQvhapYT/aDSmFHpJ2cNfthCiviEGhy9QNg6wpjaoXlChiS
	X8TFWTT27ngaZOlAMMTLNjOyYndP6tw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M4eUQRTL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762257243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gcR9x9yjnH5mbm0Y42BtMv0Ob7csNznvvqxMnGrFks=;
	b=kb7quzDm7/t9lq+V8HqIIhJJso7vkfyLq2zBG0ZLBQP4s3Qyip/BtTMVXhX8LBgExVH202
	sI6U2Lq/IxXeJAuEaSNNiaNMawZJJmTmPZY2RQQmCtUg4Kp8oyNTKiDXvlt/Afdw11PKtb
	FLzQhaX5kTfqRQSxf4Ax+VEnlJGvRUs=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso2044562b3a.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762257242; x=1762862042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gcR9x9yjnH5mbm0Y42BtMv0Ob7csNznvvqxMnGrFks=;
        b=M4eUQRTLAMsCgYFQCXYZhpODLW2/HO6ANsm+6iVTZuMsDEt8wesWzN8u1Zxf3+ZH4j
         Qp93OXPpPfrxR5lCLmel3+9/qlspSK+eLx0+oPp8yUf/wQjBUlcsTbiW6gtGJsMbTCF5
         yEyaMNvb2xLnJGZ7aRbL0vH1K8nuPRh2AmAzPNnWin+2qOdPk0AcVWOhP5wzXmRdmqCj
         zP4lq9+iM1hu5+laLWEzbypg5LtpWSInGHtOBYm3CbVX4jPMndwvPhcejwwlLzQi+KVa
         bf2MdHfY/HgKt2YMwoFuFSHRLXFxhulRIg57XL5dY5+PIIIQZDduICkUjcmj3pban15E
         u6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762257242; x=1762862042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6gcR9x9yjnH5mbm0Y42BtMv0Ob7csNznvvqxMnGrFks=;
        b=CN5UtXEg9/H8E7TrK51eJ2yuTFRHAVeUZS12x8pOCvEhr3u9dgFZaDlR+JkslYAh92
         BECcXN6s22k0z8f81BT1PlGjIU+StFqR9hQnrsnAisEtnB49iTad8jeiKWdj9f8wogI/
         tLiQMntRrM+x3txGStWksbOYa6vik2k/GlL1hedBQy0C/8NAlb8sdqrM3fC+HoNXNLi8
         L3Sqci8lTdMtg6/voTMEHVtQ3J6OmIWJeLxZ/e4KYqy6ALQI+n6hDTSGrYc3/pxd1JtR
         NdFNXaQcxt75F4oCC0vRrzbWg+1d03ENWxIEy6p/uUo3NxW1nsGtFHkxPqmE51AMvq7q
         Sj7A==
X-Forwarded-Encrypted: i=1; AJvYcCXPrWYqtl2u7CwgjAzcbF3dWC2OUIeqH/l0Zg95AXieTaIZAmNSgCFr0x7W5n3F/MmeI2lt92IDug==@kvack.org
X-Gm-Message-State: AOJu0YwReJwAUq5kkc757BH/8M6wGwLbv0aZdbQ2yh0VUJq/8aM/gAJO
	SOTvNgvlwAKNRuL8nAEOhYsw/XWPTVchTnt/5rFHucUL/NyF8+59PTqS
X-Gm-Gg: ASbGnctOTZ0Pv71e+vHXsfRzxZgrFMBvPu0laGTX93vy6ijWsFMd3QEtdABfhksxJ44
	2QKAMi3yr8jBb94YdOwCm/DtgNPHz5BEMDdeRoKO69I8JICc2Dix9yjfMKGQtmi1Vzfl7H47Cet
	mPEZk7IHNWGMW58sbtt0RJAS5TtlHtRkKSw7jj8M1hs2QGw9pjme5GrSj22q6TkNC0flWbj3RIe
	o8yPlbZuUfU+4S5z/6YFiCVJcxubt3PMmgiOFQDT9CXE09Ciz2xZGLV0yuM7p1vH/73ll6saq8Q
	5XnDtJ026nM/4rkuV5k9crwQKjofTWOS6mpvQYAgZ8lII6uypk9+3nQfhJjI7m3ENkkoL8tzVnT
	dwLVNj/GhF/0+wS5UhoRALUMu3f6MzJmNxuA5NMaERWCqMLsAWkmd9V/DuYSQLTtf2wrbD9eAse
	/SN/UfI1g=
X-Google-Smtp-Source: AGHT+IEEmYPvHXD/1GaBM0T48zfd0bHyE1BQO9tVpVf2qvxRGanElD1UBTD4a/VVOvfsMgw8C8+/5w==
X-Received: by 2002:a05:6300:210f:b0:341:84ee:7597 with SMTP id adf61e73a8af0-348cc2db7afmr20230517637.47.1762257241996;
        Tue, 04 Nov 2025 03:54:01 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba1f765f148sm2215372a12.24.2025.11.04.03.53.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Nov 2025 03:54:01 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: catalin.marinas@arm.com
Cc: Aishwarya.TCV@arm.com,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	david@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	will@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
Date: Tue,  4 Nov 2025 19:53:53 +0800
Message-ID: <20251104115353.98851-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aQi8dA_QpXM8XqrE@arm.com>
References: <aQi8dA_QpXM8XqrE@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C520C000F
X-Stat-Signature: o41s6cwo6n41mttgwhqkw6fxaa5u6jio
X-HE-Tag: 1762257243-136579
X-HE-Meta: U2FsdGVkX18gRoAguaf909ciYrVBOwMmzG3BO3j0XMSBrF/1zidkITxzNI3y+y66wYzkxAZnMrcdngk+097j3zXTIQHadHQC58Pr48xkEmj1pBxwrTsIlxhQAiIWrKI6cPbWotWIf7VP+xR8u2liME9WqdupI8RSzT0+zfrP1lgGQ1J54T4z7BOcOnR/uozbVKUrlXMpPKXCy085goRBLGQWih7o0pCCYLL68WSTKjSLol1/r5ZgReqKTmgB5+4QZrmd3zDqgMIEbLFTsYRqnGtkMRKDPBAHGunZKvOikkQKWpBAYww5ygSD47MubDPgD0rLO4Lblx5wKIFn9eIBsnmPy6DQMly0Ng0B5IiVher30Zqb/TWpnnbM6Cq4Kr2RgjKUX217UhXYq5YY7/z58L2ghIOr3DZPITjouRo3wfMOCLGwz/wf+xvyqGHFD6DlOWHWfHoLPE2xgls5ZQF78mNlKcwJkRV6RVSkHN0lYraZITmWzlPDUYH80ZPj8VFau0UxhqurF1X6faIMdzwBJGBfDY81fNNktgFQTyUF744TNs0NZXgLFTNI6BEiaO3lNiO50gWFZyp6UXQW0neoJPmaVv/tGSruiZuWBPt+JA/SWMbl29BKx4D/KPZBgeOF7VIrmu/2bwwGSu/88KcTE7+Q5jZlkgZL0pGf+v30f7C12bTH0mSHVxV8EquGZkLUOuKednSdhRWCj2Eg3MkHkikVSIAguOB1nKzvtFJ5eZ9CS2+fbNgiSmNZPX0r8YTB0RpoV/+XbMpe8KSaWfdDKYbxrztt3XwRTqF3dctwRd3Eb190u2kjOOwRGy5/YwR7+nzpL4yv0gBCdMcZaSA13nxrlmtT/wG1ddg1p/eRJRzQe1/JP55R0G/RLXWEb3YG7GwsCV+JTJ3pt5N85NA7QY+959QOUT7PsOrqze+7h1pC1p4iaYGfA6hrwQFGJjtLAHFWkX3LmFyXj90q1c7
 IfV5FVO0
 DPJ9xa9QvjVabblyddG25wn4tSO8DXvcfRuTwpnI/6M5hP2R+n0rQGl/xnHJX+MU3bPcUcAZs6cMIwGD84NgS451Ka5+/nzrVugDI95xwAYyhv1Fr3pZA8Nb+Nl5HHpuqaLiH1OCRDKPchh9m4mgvtl5iWVwmaBYUBv7wutd32ucAPRIkdATjibWOC0Ela8sjElbHxVjHBuXWgtbLxeFhdQzwfwk7I5TKUGQDammZ8anIUZF1mzfqbXNk1UKUz1anwsuutAFGH2+bC7XciUEK90oTPKq26BYVE1hOQ8kkYa8dnjbKpEsmFKMW7nSKYKhX0BY/l3p1EQ8YxuhVZnU4MSXQZvy03DhgpysqZnqzLh6cfY9VtmIgnYjpxLrvz1e04I7K78SURNkfx4XF0jdNCbWnBdoaho0jF+7swmhxYHvgIdyi7hJ8lRSPzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Mon, 3 Nov 2025 14:30:12 +0000, Catalin Marinas wrote:
> On Mon, Nov 03, 2025 at 01:32:42PM +0000, Mark Brown wrote:
> > On Fri, Oct 31, 2025 at 04:57:50PM +0000, Catalin Marinas wrote:
> > 
> > > On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
> > > user space will need to have its allocation tags initialised. This is
> > > normally done in the arm64 set_pte_at() after checking the memory
> > > attributes. Such page is also marked with the PG_mte_tagged flag to
> > > avoid subsequent clearing. Since this relies on having a struct page,
> > > pte_special() mappings are ignored.
> > 
> > We are seeing breakage in userspace on a range of arm64 platforms which
> > bisects to this commit in -next.  We see traces like:
> > 
> > [   59.746701] Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
> > 
> > ...
> > 
> > [   59.819007] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   59.826055] pc : mte_zero_clear_page_tags+0x1c/0x40
> > [   59.830980] lr : tag_clear_highpage+0x68/0x118
> > 
> > ...
> > 
> > [   59.911874] Call trace:
> > [   59.914333]  mte_zero_clear_page_tags+0x1c/0x40 (P)
> > [   59.919278]  get_page_from_freelist+0x1a60/0x1c80
> > [   59.924042]  __alloc_frozen_pages_noprof+0x178/0xd20
> > [   59.929068]  alloc_pages_mpol+0xb4/0x1a4
> > [   59.933022]  alloc_frozen_pages_noprof+0x48/0xc0
> > [   59.937683]  folio_alloc_noprof+0x14/0x68
> > [   59.941718]  mm_get_huge_zero_folio+0xf4/0x30c
> > [   59.946200]  do_huge_pmd_anonymous_page+0x278/0x6a0
> > [   59.951119]  __handle_mm_fault+0x700/0x1834
> > [   59.955332]  handle_mm_fault+0x8c/0x2a0
> > [   59.959190]  do_page_fault+0x108/0x75c
> > [   59.962964]  do_translation_fault+0x5c/0x6c
> > [   59.967181]  do_mem_abort+0x40/0x90
> 
> Thanks for the report. I missed the fact that the arch
> mte_zero_clear_page_tags() arch code issues MTE instructions
> irrespective of whether the hardware supports it. We got away with this
> so far since we check the VM_MTE flag and that's only set if the
> hardware supports MTE.
> 
> > Looking at the codes:
> > 
> > > -       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
> > > +       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> > > +                                ~__GFP_MOVABLE,
> > >                         HPAGE_PMD_ORDER);
> > 
> > This adds an unonditional __GFP_ZEROTAGS - from a quick scan it looks
> > like this was previously only enabled by vma_alloc_zeroed_movable_folio()
> > when the VMA has VM_MTE, I think we need a similar test here.
> 
> We can't do this for the huge zero page since this will be shared by
> other vmas and not all would have VM_MTE set. I'll fix it in the arch
> code:
> 
> -----------8<---------------------------------------------
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d816ff44faff..125dfa6c613b 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  
>  void tag_clear_highpage(struct page *page)
>  {
> +	/*
> +	 * Check if MTE is supported and fall back to clear_highpage().
> +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> +	 * post_alloc_hook() will invoke tag_clear_highpage().
> +	 */
> +	if (!system_supports_mte()) {
> +		clear_highpage(page);
> +		return;
> +	}
> +
>  	/* Newly allocated page, shouldn't have been tagged yet */
>  	WARN_ON_ONCE(!try_page_mte_tagging(page));
>  	mte_zero_clear_page_tags(page_address(page));
> ------------------8<------------------------------------------
> 
> Testing now.
> 

Good catch! LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>


