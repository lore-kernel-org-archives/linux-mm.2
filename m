Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C65CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 09:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F27E6B0088; Sun, 11 Oct 2026 05:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2E26B008A; Sun, 11 Oct 2026 05:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391996B008C; Sun, 11 Oct 2026 05:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1293E6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 05:45:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ED9D80737
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:45:24 +0000 (UTC)
X-FDA: 85309862568.24.45982C7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABDC920007
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:45:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WuPFZGRj;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791711921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMWKtk6aRSbfvQLUR3KyOPOC0cuhIr7sFz+mSYCpkyE=;
	b=oJ53mRq4SzvxB6qdvFwAXiDDzFqJ5kLuZFID2SJGVTCDTBzqBh0fEvdy8BQKXeceTmeH4Q
	OOskShksHsPhqk5eINr4LxYCGQfDlXBt04J+GiQBr0/MHIXfLGgLGMwmG8aATv+aolqEoS
	cIOLG0/DEpcAJLhcLRXoEWLIrU8Avz0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WuPFZGRj;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791711921;
	b=E4rlJ8uNgU3Sof9ehXtzbTTIT0TwSctiwb/E/UPH/V14B5S0IHSOiJ0gNKmSUfXLNsiwaO
	3VN/Q8JMXuKsTJY9Ytl+JnhbkamsRh5+Zq2i/oSsIxR8E3ZIvk/CSC01m1LY15nmu8jjsI
	UthCLvMqQIMdrfcMHhL14WcLM+X6gR0=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2dc8cb0decso108457666b.2
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791711920; x=1792316720; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kMWKtk6aRSbfvQLUR3KyOPOC0cuhIr7sFz+mSYCpkyE=;
        b=WuPFZGRjwMqMhkgD7HCZp0PXBFlDY3tdEiiU5FQh6UAdGT3vw9k6sEsxl54T8wfOLO
         F0YWug5sEPPZ2wfBsSjzQ/bnIsdVV+JzZWfqD/E7Mp4DfztM38Yfu+SuqOazkrE7Cz0T
         bFe4q1hy4iO9ZLY/NPgT2+QsrMrnOLE71bN1gZBeDoOPsKcw5jWPRANka46DKJbHmv0y
         kPxKtXML5EK0rclYhDO+Rfn2h4Pz9qJ58/iG3ym5QX/WUC+0omC/+1HRRKm9aSmvxF9T
         LkMSLjqt4oQK8CKek9ZFYL2R/AgUb3HK1PUn8TmFLU7Xl24M77RZS30Rkgki+67j96Nt
         ZGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791711920; x=1792316720;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kMWKtk6aRSbfvQLUR3KyOPOC0cuhIr7sFz+mSYCpkyE=;
        b=D7WZZI2066gMR/vUnOGf+4mt+t1IWzSMrGEQSMdE2lrrYEAP+yzpRZw30tN4p55mBk
         lqiFg1Q8FOONgfuMqxkpekdz4R3B2kCoZ6nT4fCwiaTawQKTkgSvoLVeRuEssXV5LWbr
         H4X70yJGtmNldegnf36rxwh6oC3FfOo8xDkEmE0dGYfLYhx/4GZFf1hS3ozRuYX8xup/
         GU/wSNntw72B5EXGYjT3JiwcIwdI0yLKWqeRQI1t9h4qEbpKdbp4+mnjD8e7dbj5CaCj
         dy7yPtPUzi2qgA1HsQLQwv9E4E/kLKyBO3hnFC7UOK0qXRseNq4rkZ3ZWhMukXz21l/Y
         fuYg==
X-Forwarded-Encrypted: i=1; AKwUvBxjeNVsT93vOsxWymTXuTltlz9/AKhFKJVS3xmxYFuzs2+HZ3m7emYu24oCh0ZSnxhPeBW9zjgE0A==@kvack.org
X-Gm-Message-State: AFq9FYIxAQ5xVVgpzryo/7FbPlWFG/EDdv69ma+VDgxdmn4uRYd3svz5
	EL+VeFefByUAw+XhgygQoIys92raARiKVnxKPJ0y7tYcGRlnbjr2wUab
X-Gm-Gg: AYBFou1p3w3GdkP6P9oS2pg6RmQIlBDs216ktqjMgJqO1yjAx4jHBjtKs8TVQ/4+0jj
	l6TNUF/T8EJOWwON/4nj7BvXAPezlQlVwmVgk8DhPlO7cZMfSm1mO1ckkGA/CGjetBl/RIQZM9s
	8xLge7qpmdT+eV/gUqu5YZJnj8vpzq337b3v8T8TLFCRgWZdTr7PlEhyPKDQS13U0zSdkXpfi6j
	i8+cIqUsQq1HeE6YIm71l9ZhsUtEYMNmjLBBc6ebE656oyshytKOVtiQG+YCelGy0FRI/GZXOUQ
	VGi8Ip321SctOrId/f89Np9hXj4qt5SrZKya45PtwlHJMpvY4AM61YkwQe/ysqjhWwdkrCiJJsv
	Rt+3JICY8J6MdXyiXhDCSyPrM5ZKcClT0+pqVIGjAfV5/GQ8t9ws8bE+XrdrI89xFFF+wHydXdn
	S7FEeUnmo1zM9PwPkxaLo0F0UrYbH1HbEEkFQJ0wqt+x2a8w==
X-Received: by 2002:a17:907:8687:b0:c16:4e5:944a with SMTP id a640c23a62f3a-c31aa02a1ebmr650442866b.21.1791711919938;
        Sun, 11 Oct 2026 02:45:19 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ad0ad1sm347200666b.77.2026.10.11.02.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 02:45:19 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 11 Oct 2026 11:45:16 +0200
To: ryan.roberts@arm.com, dev.jain@arm.com
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v10 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Message-ID: <astarANeoldvqBxc@milan>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-6-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002090947.869220-6-jiangwen6@xiaomi.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ABDC920007
X-Rspam-User: 
X-Stat-Signature: q5moro9zm44dmywdsu376nwq94cu5idn
X-HE-Tag: 1791711921-616556
X-HE-Meta: U2FsdGVkX1//t/o+/hmtFiv+QCXr712iLKjGIizLeeQur6xwapgQH228kwQriQA6kQRc8ahz/9eSrxY+jb6ychUaivAVB9uafto4ftNufFZAirvdNLvCkHzl/Xf5CeGO6wMn6GL2ujqT6AJKSSdiM8fP+8JQbJ+z9tFmHWz7SUby1VU4pSRMcGowNr3vtdouaJJRfgDmASFZRk82GLWO1IGK1M0OUPlDEpOv4vp6zC/pOl7kApy+4zEFFSnXpaaK1TwUYeWBdj1KQEV2gV9qBsulyymwmcWuDQ0N+aoa8vaVgjoeHSaeR6onz4wYhsnpdcFV54dn+dv4R+hU4LU6dibD5US9+gpZTWBnQdI6UlFxaigIVx2uoF/QQ3LffofPLM2oQlJ/CgFRE934joyI45igbpkgeQB/+fvyAGGiEWXo7pACPkN8jwpx3L5DcA5WWpM26LiP8IHoVyVwoGpsf3eyRaaVgQZLhL3yTs9eEVXtWC4gpzTbY4Z+m7aQPruDsqeBuYsE2yKJtPV6h1duKEUix74ikBeRyVrz9nE2srW/LrSrArOTIzxqLni2RnGERXbP2slNkJteD07Eus7aTw8V/zxT7fjHGngvlVwK6YTGLLsULYtyBlb8sZfNgo8lDX8cF+mmljOZ8HK3i6yDGRL8PXs0PrCdKNdZCC/zeXWwE/OBnhew/qu8Tj+JxKANcFTCS538LFV4BU5toYVS1Be3noFvVrGO3nMxgeQ/Hecy+5SW9mD2T2MxRS/wBe3VZIRKDk7qUpNfYKD6MCNFJk4LATZrb/e6PAnFHpuEZtJlfpLH5Bp6b1fOPdV0d7zxADL3h3cFYWgw0Ky3r8/R591xCGHC6w3SSSCqQhHbn1qtQ1YhLtJoDJ/j0Nsgb2EhGYdcGyJHANo1dKrInBKbWTBK7e7zCpXkWCKduEG2UZ3AeRIkJscBQ1DqoH7i6iYd1zvbl+GYWf6qdidssmR
 0MfR70vV
 SXmDDFzF9zQShdeJvqNkrvTJ2l1mBAxV5R9IdiXnUx5Zw7jHxDjgVPERE3IrmW+3OpO5i+fGeX6NONyWSSSn6A2rqlJkKDqzEGCz3Hn3zwTMKlWcUqAp2jEjuZ7Sf2qNkYNaOsIRYrMRNnq+0guqxDG3jfGsgJD2ZDGL2Z0lQ6dfP8rm9/0DVxp18ihJSDdeLwxjMvLuY86XDyefimHmx9oQteOl3bmlKPy/flnInFWLueQNRR0ThhoZ+tyh7nUirYYNbp3aAnDGECc3j3jXm/Q7a2JM0wlUN/LIV6mPNAWOwZWyU7vavimCGMfGU8wMmd3wbvvUasB3mFzdz0OUWnJODoOJ79zjE4dQG6byHg6I86ZGgKxNLxUIYGo+zDbAQeDtoBUDtWuANNSyIe4pAwkWUSQVLDaVo88ql53YaTxwR0TinM/vQ34tseOia8Ty9soBl254RfIEIB7dSSFb2AkfSQaxuSjqhCNUQiBBPxWVyBBR2sgBRp+zgdYs8NiHmCJgrMqWVNsC9ZYs3GOR/Ps+W8/axDe/z8YGUu7KMAPrX61F3jcRpPln/7cb79FUNxt0mOgmMqeU9KdjtV8p5hXMA4jvg61eZd8jq27Rqaa3qQdmDTCOBb8OhH74baVyW0MMlGIv1FTdiWKXFZTIQQrUnbtqO4jHse+DA2TnmaNUJag5tQo5KKLyFcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:09:42PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.
> 
> Previously the function returned a single CONT_PTE_SIZE for an aligned
> range, so the caller mapped one CONT_PTE block per iteration. Now, for a
> CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
> that fits within both the remaining range and the caller's max_page_shift,
> so a single pte_set_huge() call installs several CONT_PTE blocks at once.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..c29704a19e276 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
> -	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
> -	 * aligned in both virtual and physical space, then we can pte-map the
> -	 * block using the PTE_CONT bit for more efficient use of the TLB.
> +	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
> +	 * virtual and physical space, return the largest CONT_PTE-aligned size
> +	 * that fits, for more efficient use of the TLB.
>  	 */
>  	if (max_page_shift < CONT_PTE_SHIFT)
>  		return PAGE_SIZE;
> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
>  
> -	return CONT_PTE_SIZE;
> +	size = min(end - addr, 1UL << max_page_shift);
> +	size = round_down(size, CONT_PTE_SIZE);
> +	return size;
>  }
>  
>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
> -- 
> 2.34.1
> 
This is arch/arm64 code. Can you, Jain or Ryan from ARM folk review this change?

Thank you!

--
Uladzislau Rezki

