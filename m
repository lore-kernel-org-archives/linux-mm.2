Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A123CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7616B008C; Thu,  1 Oct 2026 11:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930136B0095; Thu,  1 Oct 2026 11:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822056B0096; Thu,  1 Oct 2026 11:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 552426B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:56:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3DE580428
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:56:16 +0000 (UTC)
X-FDA: 85274509152.16.2CA5EE0
Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id F01A340004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:56:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s++k3vf8;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790870174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZXyBZOxPP9aVP1iLcONa2ADo5uyWcMjFEkbOU3Yh9w=;
	b=ORTKfBw9/SZEGyrV9lPWcMBxeqj55zaYNRSCY7tqOv8LsKj5gajoowv8+5KOI8wZC1dJtW
	91TthdTITXxFJNrsx7YFdj2IMeIJP6ByvcjxlxFUn/mEOnqMSrZRfdLO1aUiftEmD3eLsh
	kk/uHT8W4GKCT9Oeie60BadQHV62lho=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s++k3vf8;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790870174;
	b=4ea3CuSKd0f4JXrgCV5y/PC73xdHzEz8kAbFAMJ5njTmnFFUj48jhG4aXQSWjUMYGDFidG
	iGuwq4z3VLDkF1emB91Vz28as6eGZTyh5m5AEFw1RqGd5/VDUN8n7vo/ZlQ8WQQ5zFrevc
	eFt9ABEJLXtI6LY6YlFGzqx4y/gC9vs=
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e1195040aso385399066b.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790870174; x=1791474974; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mZXyBZOxPP9aVP1iLcONa2ADo5uyWcMjFEkbOU3Yh9w=;
        b=s++k3vf8gIum0M49TG+V9E69tXwunlz34DbjrdfATOH8j/wW+JRhG26ZGqkf2xJwMo
         /mmLtuIPpYPn2+OJ/QxCH9mJuHSyszfCxpv9pi6k/wrB545yDLg2m95MggjkjvHqKg2z
         /339YPrCD8hyb1PN6iqeuJjgvLgftqG9EKb4cZ2o5ZkVfgsLQW1gbYqQ7Dy72zAAY7mr
         ISA5ietTmfC7uqbVj7Lhr7tUP7Las+83ZS3r0XC5O3SsNmytgqgwpibrkYvDcGeU66is
         95faBSOM8pjgnDKybU8V9KPLklxcFU/DgaifprsDUCfzk+Dgo3Q81KSlo7Grv0ArzejJ
         ZuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790870174; x=1791474974;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mZXyBZOxPP9aVP1iLcONa2ADo5uyWcMjFEkbOU3Yh9w=;
        b=etgAnCLMGFUdX40VFs3IuTDn6v1T5nfvcQzIj7m7o5KbEBmbomAq9SeV4etNNBZ4aP
         OGMCXSONmZLmH5eoSYy1bcyF8ExnHqCGiOZIs6bbkIFWkM/EMCeFZKt6pLle+Gw2GamJ
         vHbYW0qWDTSVPJR9EnRkaRifCAVw8kh4E00G35iECe2FkJ8fFFTtV159lvOCfgAJxTc6
         6CxQfj6vIQVvpBbhl216O6YIPlFKfTvsTFzU7UDbq94PYKpyJC/cQnY3JY2d4U9Nysdy
         yfcR0FqySVxkc707YhVOBU85Zf9PaVkLDyx6EGqAzUvcBtSS2Gdo2DK+yaLAKNLaDFVJ
         0LQA==
X-Forwarded-Encrypted: i=1; AKwUvByKP7lXRD4/bM/ULZ3DD9g56OcnJGi0W00ZUw5TZm6fu4jd4Q63jhkn5C704vn3BVaIVnnpmxj/eg==@kvack.org
X-Gm-Message-State: AFuF++mo9kziYSvBH4n/EXG0QszUp9hdZgA52ikYCWmUxRChsVQgH0K9
	M6P/S9eGPmyjalkyBVzbVj9BduiH8CNFiSZt4Ai+Z95f7rZfH+nmPnwN
X-Gm-Gg: AYBFou0q9gn7l8oNrqrrvc3Q2IMJlFaC8a07+oLCBvrUVXCiV3T+dO5TW+6i33uUtv4
	0MdRqCIGo4SHA7l2j6SYPwYJ3ET1jW3pMIHkz+ics+3+HeQvy94BbfEjqSMmONYlhN6EsImC3Ca
	rmOZDAW/NLGvEHApk0/ZTQJbvT6hMklnLCgBhLAa81T92EkPCixTiicEdtNxcF1nIO63ZimERan
	N+arDKWCz8qPX9Zxdxjhto5+GSYBISXwjUJMzvuVJgbzOZNCClbFKUfPq4wWCJoUFzSagqcG/rp
	f9wEFfr36Y+GCuDvYIktIZpH9VHuEMfxj14blJVkttNKuo2kjhfxlW77wNTg1tytrWYjXb1+tWX
	q9Bmu6CbvZIHwCiH+/k8JZbTF4+WX7aB6X33XURhZRKAiTNiOJKOh8SISzbtkRFmEtNPczu9H0S
	OKy5wQt/bH18/aIUekLH5Pz1Vg4F2Vtz8DqWw=
X-Received: by 2002:a17:907:96a0:b0:c26:3566:5b47 with SMTP id a640c23a62f3a-c2e4ad55c07mr1700466b.12.1790870173588;
        Thu, 01 Oct 2026 08:56:13 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d96628sm181851866b.62.2026.10.01.08.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:56:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 1 Oct 2026 17:56:10 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	catalin.marinas@arm.com, linux-mm@kvack.org, will@kernel.org,
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org,
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com,
	leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	rppt@kernel.org, ryan.roberts@arm.com
Subject: Re: [PATCH v9 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Message-ID: <ar6CmpPkwu1VgZ22@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-6-jiangwen6@xiaomi.com>
 <ar0s14p8KPgmDKmR@milan>
 <CAHKocdEF3RE5FA+LPRf_E0ns02a5akvUDKvSDvERoyTryV1X6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHKocdEF3RE5FA+LPRf_E0ns02a5akvUDKvSDvERoyTryV1X6Q@mail.gmail.com>
X-Stat-Signature: 3by4on1ao5se8543pmuj8qfxyxcxeskj
X-Rspamd-Queue-Id: F01A340004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790870174-733601
X-HE-Meta: U2FsdGVkX1967AiGdqVAmy3Brka/nfleSvOpWpbh0M6l9abISJUrG/CtgMSALPNMqlMCTAiLuJeEw/8JhLFX7rEJ6CPjX48ndZjRuN4Oklahcu/NioitvLGme5zeTagCUhWU/70bP7VX+VQqN5f1bR+YlTPukGo1/aEd7wvVvCLTD/5Xkbtdi1eBemssXrddAqlzdTlFy5pwwyvV2SsCQaGCD13rWHN4jfamK+RnhOlR6kAYLXI3ckz+QAOYqGQB1i322mvoeArN+9mdH4KpMnL75eznzhRTF6cuRyd/STYqbRtzhZ7cwWTncNfPDNLRtz4/AGcQypmSe2XlVFC9bSsOrzhYl3Sy2VWWKWlSVievcOZVXv4+QZ7RmhU7/CZY3OBDlyrSaOsI0JVGdksR2SDuEO21qMc1dwVFTyVIdBk8YFhuTb0tTEDCdfOva2XXO+XzzphTRuLYe5UvnlRCwVNIPFpgTqaIFnAein8PIc0VhelRenHDd8+7A/I+VT/LBHky7cuT3Dsx7OKcYv3qKPtqxV6xVb/oY0B3fHtxuFhN5Pf7H4/x002z8waP2VYpiUzRSuiSyNbAIZDPTcC+VEZGXc/8IegG0xF8e7pp5XolHpzRgnYjPpeMg5bNJVzzNNupj6XXM4slSsoBDUmz4kKjSv/yeXfcnA/4QDe+WqgHW1dP3PF92F6pTjoXnApNZXZ1fzTw5XenwBrGrRwOZzFb6srSJlNTvmFkazFu7DutfM9h+I4XvsDzubnABszdAObu9rDZyGj5iO4l4moPm8ZSXcbQM8Pr2MtZ5j09VEFyiWR5LC8BlzymkjW/KBI75eZx6o2njfyKnuHMvOI71g9Pag2z3R+74nFpY09it2pVKz5HHHQn88TvwVMVjTf4oztm/fG114kWR8Mjrfis5lGXkqjC5aLcsz4FguWVUb3AZYTe3NWP7qw/hpDqJ5U8Hmsw66eElGAmPZCjPrO
 l3XGPxpk
 AwhREt8JKLenWDls78l5L9hlAKxQW13GTwhSnupkESRjcD1lhuD6DzaQVS/LxE215d51/2So306ui7lI7JBmJfoTul3pmJugBYRViEkhdj+JyF7fFhYH92WENcIk6dEEegc1DGGYA39v8wNf341u3hSUV4mirqaG3Z2YYty/wcT9rt/hkQIv8AIWfiWpITIle6CeltumOyjlNWlvxD4T6DEJvzUwPWYv1+dPowlJzgyNCQBTyFExevCra1bOf2LmNZQklTpMySZ7NZueEcZufgDwmINaJAQYs4Za84y0q0HL6NazvUYmZvzmgBgbV3iLXAOun/x0DPfheHt2KJDCRYvdxePQWGZNvQzRUmCRh6ehEiZPe1oMTyAzEKYJ7+2be+Zh1E70+XaGjnYpjTJSeeRAl2qw9KFDmBCPD2wSyVNRaQMSeCS+H/vzZ/mzQLeDviFfrpNSp4PCY5/n8GlFwvUvsFSVZSf7o5bjMkANvBSUKXJl7Skk2iX4cxmHnW4fQS/eNwR8OgsUx2/fb1Mng3oPttnd0oMfIzhW0kvHJRoMJm2Nqxr8TjJ0WL7O87VHldDO9SV9GGmi6+At5VhkYF/iYH/9raJil2su43z8f49kJT8o2B8SH/mjS8prJ7O/eFU/tgC/WIg7qdhFMxGVQB61lhY80yX2vFPgXL+K6rsbTWpU9ZuQwQIoe3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 03:55:44PM +0800, Wen Jiang wrote:
> On Wed, 30 Sept 2026 at 23:38, Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Wed, Sep 23, 2026 at 02:28:27PM +0800, Wen Jiang wrote:
> > > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > >
> > > Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> > > blocks, reducing both PTE setup and TLB flush iterations.
> > >
> > > For CONT_PTE_SIZE-aligned ranges, return a mapping size that may cover
> > > multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes are vmalloc
> > > mapping spans, not HugeTLB hstate sizes.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > ---
> > >  arch/arm64/include/asm/vmalloc.h | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> > > index 4ec1acd3c1b34..4053b1ec1902e 100644
> > > --- a/arch/arm64/include/asm/vmalloc.h
> > > +++ b/arch/arm64/include/asm/vmalloc.h
> > > @@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> > >                                               unsigned long end, u64 pfn,
> > >                                               unsigned int max_page_shift)
> > >  {
> > > +     unsigned long size;
> > > +
> > >       /*
> > >        * If the block is at least CONT_PTE_SIZE in size, and is naturally
> > >        * aligned in both virtual and physical space, then we can pte-map the
> > >        * block using the PTE_CONT bit for more efficient use of the TLB.
> > > +      * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
> > > +      * capped below PMD_SIZE.
> > >        */
> > >       if (max_page_shift < CONT_PTE_SHIFT)
> > >               return PAGE_SIZE;
> > > @@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> > >       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
> > >               return PAGE_SIZE;
> > >
> > > -     return CONT_PTE_SIZE;
> > > +     size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> > >
> > Capped below PMD_SIZE? It is half of PMD_SIZE. Where is that limitation
> > comes from? I think the commit message should be improved in that sense.
> >
> 
> Hi Uladzislau,
> 
> You're right, and the "half" is a leftover that can be dropped entirely.
> 
> Before this series decoupled vmalloc from the HugeTLB, the value
> returned here was fed into ilog2, which reconstructs pagesize as
> 1UL << shift. That forced the size to be a power of two, and PMD_SIZE >> 1
> was then the largest power of two strictly below PMD_SIZE,
> 
> How that pte_set_huge() takes the size directly, the size only needs
> CONT_PTE_SIZE alignment. And this function is only ever called for
> a range that the caller has already confined to a single PMD via
> pmd_addr_end(), so no explicit PMD cap is needed at all. I'll
> simplify it to:
> 
>         size = min2(end -addr, 1UL << max_page_shift);
> 
> and update the commit message accordingly.
> 
Thank you!

--
Uladzislau Rezki

