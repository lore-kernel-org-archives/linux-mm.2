Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829ECCA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2DF6B008C; Wed, 30 Sep 2026 11:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB096B0095; Wed, 30 Sep 2026 11:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C08B6B0096; Wed, 30 Sep 2026 11:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18FC46B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:38:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC098A3EA0
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:38:05 +0000 (UTC)
X-FDA: 85270834530.16.9D50C43
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23336C000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:38:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O751n0KF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blz14Kryy333MwsAfcVeWnCS/9nOHGV6aMGIkIjuVtM=;
	b=I7R1t8f+9durQ8/JiZMxXMX63Nv28OZruBxtzRZ67n6rJS0d6IgInnOOEdx2oqrjfZ2vSN
	YItKQLhYtcaLdlJbEKnwnolGa0F48iAphF816KFxF6x2YKTq+26wVuVnkZ0eg5NkuLCKcs
	BL2Y+1K+3aq1koUcG2vEO5rT4chAIU4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O751n0KF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790782684;
	b=Q1ucp6NxAr5fPIDPcPsQGfwyT37Q3UywJkMvM02ODyrsRtk04scgKpix456FGL23dWX354
	fTpMAYpIHsw3SWJLpRwIcuo+e7tpjzHubQ+Ylg1AUN7zlXz9xLwpgUbGy76+RubZ+t9Ndv
	YPvtOzXXi+39uBoCfdkCQdIekk0nKMQ=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2e17363b97so162356766b.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790782683; x=1791387483; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=blz14Kryy333MwsAfcVeWnCS/9nOHGV6aMGIkIjuVtM=;
        b=O751n0KFDqh06FIKNwDaDEeFGpzV41687ydt5bu4Kqm8bRW8jfYh+04cRJc2L3UVK7
         hhHEbOfq79apR/xu5Cx7GepjH+S792nFcIxjUIuOviZpi+JeA3EjFTjfmnGB20stiG0Y
         zkP23RyptxKtTgkvieEVm1Kw5UZLAcmtJ/LzT+EbtjTvCgcZTmZfy35dcGem1VCxVx8s
         wATuwk5Rk75K8re1VLSsX8d0pe4JbwoihvknNZKDSCjXGmgNn2ShN6F0UI/Sv0qnoQj4
         P9LHBcwagQa+xyPDeOW9jcL9l5fwu7ZQW6SeBYf0V2zd0XyCsvfI308N+pI4p49X7L16
         C2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782683; x=1791387483;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=blz14Kryy333MwsAfcVeWnCS/9nOHGV6aMGIkIjuVtM=;
        b=vBZtNF3ODYNQVisFYkm5i5EIJe+fG/v5kag0ueVdguwlga8wty+PMIW922HcLLFFX0
         ps50o8FB56htZSwDF4eRAaSq9MdEvKbanw0RyIVGsN6PpLJ1H1wn+dAxKgiwkB+Pb4/5
         y5qAConl4eDwfoOK7jaszOcZVrPbzUXl/pl7k8tOXNInxyiPFtcA9PQtmOVzBysWgYbD
         nC7j54yJHq9VSZ6qLKBMuH8VfgmAzcXYho5Tq31/xdToltbwNE1axlqzF89HOMct7yrO
         mgOwL/G6wn132ZjcIEdgf2DMt1Qh/QUQcNR8SpvcYuQi/sPfDVG3ONBqtNWCF0QVLOtA
         4sDA==
X-Forwarded-Encrypted: i=1; AKwUvBwvUYHCwM+SPh93+Lx7VvyEENv6W6bFFWuFyou0dLimOJtSfHd1epA6mgTtjJFlqftc3lkXKU6Hcg==@kvack.org
X-Gm-Message-State: AFuF++mPcNaoG7Xxo3kR2Fb9So/o6k6DvVlZHma98sArBtXZvJ0DBUYL
	vj1jdS2QmDOf8oWABSEel/l9IXZKLCTZEWfAT26bBaziJT7QStqkRPI/
X-Gm-Gg: AYBFou2d/IHpbUEOimtlWKBo+Ry5/DoE8tgUy5CLL6CNsaTrz9oRm0xQevABIGmG4+9
	Crzohv/Vlr6A8K6VcsdSmzkN77ZeyrmSj3cPTOQtDR2r9oQNd+msqxTAZfnoz80PM7iIpNE95/X
	nD3D7shIE2DPa3HriiZtYxIz1P0rZSeM0fVDa/W6OqI3TRcl4moQbwWZ14/NKiJ6vlO6GW3GiRQ
	g1pnEp1k9DSSJvipqkseCBrEocXJImipllTbkIgBnkaD4fi4aaiWbE+gbA5PGYSJBIfNl3Hq+b4
	1mlDUlO5iZAtl5Hco2T86C6qE/t0RKy0/cL5/hPY7H77+b42Vz/ku0ns8zLfkohPQnsJZVM6bLR
	FdtCTtx8WneatHYGlgWln6b9Mo9cLD2YEEXTtxAxSnRgqSDizGMBQRhBG30cXXzG36EjBLcqs3A
	P6qtXyvSlR+v410V1dZ6fZvKskPK2X6/l3UqzO
X-Received: by 2002:a17:907:9628:b0:c26:24ed:39e5 with SMTP id a640c23a62f3a-c2e23cd72e3mr159226866b.18.1790782682624;
        Wed, 30 Sep 2026 08:38:02 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31a3eb32sm30808366b.3.2026.09.30.08.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:38:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 17:37:59 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v9 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Message-ID: <ar0s14p8KPgmDKmR@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-6-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923062832.479455-6-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Stat-Signature: xhy7cq53jy7rq41o4jq46tbn181abjuh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23336C000B
X-HE-Tag: 1790782684-700585
X-HE-Meta: U2FsdGVkX19Oqf3cZ6kONJzYv3rsz1tknEbuRqDM2VQun5OQtDdKGQwU6kMxJ1/WHZse897tDAXxr+J272yVIse1/EdYIuKF11SnZ5SHyRTK8ULlKuGx9lCVWm746+qvI6F1zYjWr2R1AURSv2FtNJQkGN6DGJdgKppoR6WxfQA1fTuaCm5t/38UCA/8chmC1HHIlUaoMbVvH53y5/RUhKdFodAq4bYxvdb0bL8zXYijO4rOKqGf1IE3dluL7Yx3Fb+MtOtNrr+EiTsMJalgtG7d0ITQHUkagXe+tyUT7MEIBEEhmcqBDOp+eNe3V+P1t0EpM1aG3HeNCu1gSoeVrCnPF6w9hqRd2YSaCz3Tey1N8QK2tefAjWPIx/RG5Q7+hgZms4Fp7yEfV7Ko3Any39Kwh6oTuvFHavd3W48bmDn3myIvJmwbykB/Wrwalg5nAjle+LHQiGOOfEYwUGLCqQm+Y172Hu44TrynoO4vo2DXJibAe4uym5KRn9/5zNq+3PPtp+XKobJBXGsEDz4WTz+7Eofhwv/8whXTNciMXfbG1KdWs67/xYWnDcUTr+uQ/amahOCTqG/p/RbkQJ9mmzJ20zdtFL+7fRcTY4YHgGLu+HPc/VilVfU0pumHcHHcMUFse9DtJPsGgiuZvjzUpIZgwCCdFgvmWSHPPsmiiPfTvIlYtwYnGN68UIsv5kIAqVnXHDhejzcyKEFsjOsXWgIaxMkvk873I+x/q0Y8ftMbWapTPpWfbWJweU4HDjg4fq8so+fAboDz2vvXlgaEI3wdFBP3xGFITQu8caM7ixpzG8ezLVZQowEJeIPmftm6yoQM18FnXQ0qTn0Z1128GPrkRq1Pp8hHV6mFde55UMzWgJlP8wXouNhVjT0LmRU1ysnw6Rfcmcsq+Vpz4SZAQREG0+Ha0ZC7D6701jimwmmEJbgj81S0B/SyaUk9GiUZuJ2uKPXO0ZnYJS4Atim
 al3wpCv0
 pJjn7wUem5xs+oP5SMmgt+c+1cs4tGh9r9CtCJmk0nIv4pLo6Ko6DKpZ8a0d7Q+aIYuY6kqQ5ahaBjW6m7dXnN8YR8Rxbnb7GoGUm+3gJ3QEo/jWOtErIwenrjFxRhti1+czBwMyJT38UbwXOsiHWYnBF5jiTLav73LOW8VKgbdQB0auN51ZXVjvaLzkh9mTUP7HohYCjANcgVxHOtQYUWBecHAo+nUJoMHNQHHh8OsqFH8BQdB5Ao9CG6F5/MPh4te/K16Ri/4fxhOyDKqspZOH95nhBBPPFyfCuM0jY65tkad+75Ikjr6JrVXwTAfE2MOG64fTA52CfgyqrobLs3Ci8YpxyTyuguiWcNYo4xvOSz2511uZTvt60hGcMdk5Qb7MqFo1tLStVJqMevUEdeucW+e6wH20gPkdZ03mq4PB9xZDABKHg16oy25ypJDz8NFA9+wPk95qCp2o33LHrqy9/Siobf8MotF84Z92CW28jn5883a7sJvvVQh46KbWKDLp9UYUnMonAwCW7ldrqbNJQ/ollqaHXfnOJ5mvw3q6+ynvVCdUDQ5w4odoMPCqqD2+7WQzNYQngoSClaJB4Q0i0xRxcWLgqWXhcsnug1+RRJ2B7O6zpRvABiMzl3pLPzjXNiKWML8gGDsBiCNrUr5KIWCfpnryb9ikopyQ8uj3+HXS126eOAxYZXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:28:27PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.
> 
> For CONT_PTE_SIZE-aligned ranges, return a mapping size that may cover
> multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes are vmalloc
> mapping spans, not HugeTLB hstate sizes.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..4053b1ec1902e 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
>  	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
>  	 * aligned in both virtual and physical space, then we can pte-map the
>  	 * block using the PTE_CONT bit for more efficient use of the TLB.
> +	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
> +	 * capped below PMD_SIZE.
>  	 */
>  	if (max_page_shift < CONT_PTE_SHIFT)
>  		return PAGE_SIZE;
> @@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
>  
> -	return CONT_PTE_SIZE;
> +	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
>
Capped below PMD_SIZE? It is half of PMD_SIZE. Where is that limitation
comes from? I think the commit message should be improved in that sense.

--
Uladzislau Rezki

