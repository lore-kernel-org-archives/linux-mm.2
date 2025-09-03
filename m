Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB32CCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67FF8E0006; Wed,  3 Sep 2025 04:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E195B8E0001; Wed,  3 Sep 2025 04:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F208E0006; Wed,  3 Sep 2025 04:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE9A28E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:08:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EC7B85F23
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:08:44 +0000 (UTC)
X-FDA: 83847212568.06.96BCF9E
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5DB41C0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:08:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CwCeOGE9;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756886922;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUJC3Krq7zEXPK+epzbi9xFTpRQGWoixqKJ3ll3WSso=;
	b=Ym0bKTyZcDxJR8gPA2V/h0b4S8fL6UpEilnDPSyWgMoMMPy3IL5lxxXbMRF9/Gu6Ksh+Sl
	UcG0oHGt69fs+nfDap9fqaiQxPSef12orPnKt0V4Bdtj3JjeUfGcIhmT/AB9d/b7OMruY0
	DOpzMM0qGfO3E3XVAuppes2ViNoUncU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CwCeOGE9;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756886922; a=rsa-sha256;
	cv=none;
	b=vwH1XXClcduIZnXQ6+uKi6UBxOQyPI+B4u+M+MDbwGtiUrD1EFhLJLhwIVB6UZ6sfVEoK7
	GFl17n7YxPUi/SqjqvpjRdoHdsABoJtWiYfPnODBM/0/r/yf7MunSA2dX5BjGDW7qQJ7NX
	W6Xz1HdhPzSsytTwYl8P8D/PIjtbSh0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b89147cfbso28627715e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756886921; x=1757491721; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUJC3Krq7zEXPK+epzbi9xFTpRQGWoixqKJ3ll3WSso=;
        b=CwCeOGE9VVyrLX1DZ3hpWM7Zbj+qFZWbXP1BNvbrHUYXs+njsfwFljouCl2NRuMmNp
         alDM5nc5b3ARYC3Fo9UYmBEKlZlDiljC5BT6RWjkC53pLWpbcG5flrYFNs6KVRtGxCJP
         O4ot0GjdmaY2bbVzmIA4OwOTOyOgx1YaA9n4kH4ilIE7tLdra+jeFB8ukrcT4/KsYCQP
         V2O7hgLICoRThAS5ewoqwr2XMcw9nAjlI2AnaYiUDo0rlWj93fAaFgFYhkvLB9Hkvr9a
         JfouyIDnMs61c91foa1vvpWbeD6OKup3SRwbi+Z6ZTowZ0yVUP+7VLc+7acYpvksiVXz
         PEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756886921; x=1757491721;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aUJC3Krq7zEXPK+epzbi9xFTpRQGWoixqKJ3ll3WSso=;
        b=jqzgcrwN3HxGpO8E6yEdmsBdMelmh85EibWS9hJbiXmTmBltexUDCl0eBxBr9fjlGR
         OB3J9n+JSOiROIclls9ptE5VR+O0+j+zqzZ66FN7ba8Rm7IXwWdzQJ4ttT9OJ2VKqozd
         vGdzQTg+sXWonJDxc980t3WQdXTuEbwAGz0D5fa9wMqlnBdT39P3X3WiiOlQni/ENpdT
         1ymAWToChlwOoZc/TQ4x3sclqYl18x4+TpWhFkW4hfrvM7xIJd1IIDSxRKpDhQ96fSwv
         h991ZEp9Nwv5jI+TKXO1K6/4Yspni+il6nJ+HlMsE6upHnsXL8iC60iVvFS7zdG84Zml
         TM2w==
X-Forwarded-Encrypted: i=1; AJvYcCVBFipNtDPFMJyOC+WtLFRB5a5eIEXThMUEXOxr6/A3LxVCwHH6o9iHD9D/Wl8091bIDEuRlJUerQ==@kvack.org
X-Gm-Message-State: AOJu0YxI3hlW35zGMkPqa/Tf1GwZK8qPOsmZiLhKk8lGT9EWwDGag9S7
	gRRKVbOAt5ISgDLeSByyz2AprPODSYt/91V4heFSnyQ21TQKysidhhIt
X-Gm-Gg: ASbGncu64+eNl8iGQdFrWzdK6LWjieq2Nv76llwdEZdo0CK4ROKU21+RCkoP7QLijeW
	o4/vP3uQ8o/efFY5EvsDccV9MP60PTmUtc00DHzRX2idSC4KXKgALtgcOy/E4cYRQun2H3hcVrG
	65JJXd1jb5lGRKmLmM9wQMJrVIATbfZpaEddD/TPX5z1djSeUns7jPsfNDDstHQzvGAFpdpAyUx
	31qWB/slOAllloMqfqPAyOi2w1uJQYjzg8AnUa+OR8nqlLjfNRQ9hP6PdjVQ8u6dY2pD0f9AMgh
	02jj9Y+8kWKXUIS8aMgLbiJ+pFHpHjrpFxZ2ANoP2pvc7q/nHTFxO12iw6tSF4Aa8OZn2Ox4tM3
	hba4JpX73RUZgtGxIdZ6XQm3j9q0nDUpq7BFB
X-Google-Smtp-Source: AGHT+IEAoZKHZM3kQNHID82SoPVu7/HP6eUC0AqiI51jOtxQMatQKooo7/Z73SID7xfpnH1QOreivw==
X-Received: by 2002:a05:600c:c4ab:b0:45b:47e1:ef6a with SMTP id 5b1f17b1804b1-45b855bec54mr128326785e9.37.1756886920536;
        Wed, 03 Sep 2025 01:08:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb61377a7sm13188495e9.13.2025.09.03.01.08.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Sep 2025 01:08:40 -0700 (PDT)
Date: Wed, 3 Sep 2025 08:08:39 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
	willy@infradead.org, hughd@google.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <20250903080839.wuivg2u7smyuxo5e@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250903054635.19949-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DB41C0004
X-Stat-Signature: fyun5f89qap7zj8yidiwp8mabhsicokm
X-Rspam-User: 
X-HE-Tag: 1756886922-852971
X-HE-Meta: U2FsdGVkX1+VLSkz9lxi9DLuYGVrTJNWlGHJy3uN0g0mzINzLayysVxS5SJTvPUazORA42XX4iZNVSZrVmpXXU3gdZrpvvUm3viU9PpeCAtnTu0gTl8Nf/0UH8Bjwb0YAmNGWKbZ55ZJHVYmA7wGH9yu9j5oKrgH9b+Q64DncAXc12kYlRcpcH/sOFA4Fg/BiVqLCG3JpluVs86UW4SMkPkjhA8379eFGs3TKXEkuQ07gwqRl/k/APwv8A0JxG4daeTbaC/gt/0tA7fVvKEbZB5zU3XlDsncW8wZ7AF6a8kSH/9gVQ7QRycnKCFEdOl7FVjEUJODmTBPjpioAaajvmiqhEBPf9TykA0D+NOXonHKnBy3uHt+gHxv2NRwfZinIL1fPbXEgap7D+4zzrkV2XvcP7VAXz1XIS2xcAiW7wVqgGEoL1gtNikNQiNWgxcMJFc85gAPuE7oBc8BWmqVmSOp8pruMi9mPDbAkFvW8x+5gyaf5nMDyUNhqvFb5vLZ1f/Pv/HQE8GbJbfCi8LpBp62Jp9WlAq7Kbl+85FuCf7raA9E+dr47EuD/gm6D/EqewQyA+flOsWiT3n4gcklPjcWst/fRpFVm/aAkoiBYcPC5gRSx+90vXFgQTZg9Qs2cQTB4lofF5ywb7gFQwM12He9r//9BBx0Zy6NIzW+NBaMmBM14WMdaEoWTsT21iBm5V+n5nXSZp07oOpCPZtKGpJLTM9VfBYkBhrbBhwvAMNsbZLd7P6d2jac6Vh/amPtj1Xk9BnGOoZ6Ek+nu+dMb4TRCHftF0rd4EFAkqcSRHPbl59RHvQnp+7Wa2tEYyADKEAqbL6/jj6U+Ls8seP2dCKHEDcMPxMCEw9h66cJb3pMV5NLw2vRIEaVLgDv96JgWvR5jZ+mVjevVbIxZXCyx2TCKZ18q21K1NQvfD0kp0vPyxo7LoaehfWRx7t96hXJnoJ2j1WA/jkBW1hd3bZ
 96+ziPtJ
 nhq2NYWRUCb2xFdT1vFsKcbgkmdO/k9FugUz7M40UbsqdGSrAuIHUa4SrzhY2fv622XprC0M14y5DYEiEZLKkZumYi7cg2MM4loaLXVel8jlX1ECz5Sy4Q9EQ6CTCJVCRBoRFTZWMehHXaX7IUFnLTuXOHC1j3uf7+1DflJ/HpTmcqRUC/cJHLBnCqsdCWwZHIxOd1lwmYZh4LW1wvosMm+5z9QU6EvKPCTc54ijxmx5POnDXqJ1PJllmA0u6QPDVDwUECSpDY18ywxCDQyTcUn+fR9JX7yqGdx5zph+4sxzJRPRhYLP14+b11RQ2z1ndkUxs0qRGWK7nyzZ8RBm28VfGVfoQX/WGUHddwDASfn2yDA51Fe72M6GmBEek4gmNdknay7VoLYVNUDOKnNrtxDJvC9zYZ/9gEs2Txg8Fpb5ykm1epn0TQQTb1+r8TTVTee6Ta3wOvPcs5LG+3AGPvhaNd8ULS/4kT+rXHl27J6zdPs3jX/n/XkTwjFd66nsJTcvpgSmKpbJ2AhsUJjOsVjpXIc57Mcn16malKpbKZ5D7H+tj95lrCDDkU236GDF5Ybv2mxM8Vn2OZs4vOQRZ2PSvyrkUh4c+WKpPxAqUf4aS31qk9O5gAQVcMIDkdVFzxIzg7XAAZPTEMKFy0GCwCIkjx4Qt9mJt/wOgjtePYs3V2IzQyZLY7gSyY/SAIqC9/y84
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>Currently khugepaged does not collapse a region which does not have a
>single writable page. This is wasteful since non-writable VMAs mapped by
>the application won't benefit from THP collapse. Therefore, remove this
>restriction and allow khugepaged to collapse a VMA with arbitrary
>protections.
>
>Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>non-writable VMA, and this restriction is nowhere to be found on the
>manpage - the restriction itself sounds wrong to me since the user knows
>the protection of the memory it has mapped, so collapsing read-only
>memory via madvise() should be a choice of the user which shouldn't
>be overriden by the kernel.
>
>On an arm64 machine, an average of 5% improvement is seen on some mmtests
>benchmarks, particularly hackbench, with a maximum improvement of 12%.
>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---
[...]
> mm/khugepaged.c | 9 ++-------
> 1 file changed, 2 insertions(+), 7 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 4ec324a4c1fe..a0f1df2a7ae6 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> 			writable = true;
> 	}
> 
>-	if (unlikely(!writable)) {
>-		result = SCAN_PAGE_RO;
>-	} else if (unlikely(cc->is_khugepaged && !referenced)) {

Would this cause more memory usage in system?

For example, one application would fork itself many times. It executable area
is read only, so all of them share one copy in memory.

Now we may collapse the range and create one copy for each process.

Ok, we have max_ptes_shared, while if some ptes are none, could it still do
collapse?

Maybe this is not realistic, just curious.

>+	if (unlikely(cc->is_khugepaged && !referenced)) {
> 		result = SCAN_LACK_REFERENCED_PAGE;
> 	} else {
> 		result = SCAN_SUCCEED;
>@@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> 		     mmu_notifier_test_young(vma->vm_mm, _address)))
> 			referenced++;
> 	}
>-	if (!writable) {
>-		result = SCAN_PAGE_RO;
>-	} else if (cc->is_khugepaged &&
>+	if (cc->is_khugepaged &&
> 		   (!referenced ||
> 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
> 		result = SCAN_LACK_REFERENCED_PAGE;
>@@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> 		case SCAN_PMD_NULL:
> 		case SCAN_PTE_NON_PRESENT:
> 		case SCAN_PTE_UFFD_WP:
>-		case SCAN_PAGE_RO:
> 		case SCAN_LACK_REFERENCED_PAGE:
> 		case SCAN_PAGE_NULL:
> 		case SCAN_PAGE_COUNT:
>-- 
>2.30.2
>

-- 
Wei Yang
Help you, Help me

