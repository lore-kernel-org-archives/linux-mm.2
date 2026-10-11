Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1D8CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 13:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D1F6B0088; Sun, 11 Oct 2026 09:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4E16B008A; Sun, 11 Oct 2026 09:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331DD6B008C; Sun, 11 Oct 2026 09:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 187076B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:37:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FCAC409B5
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:37:15 +0000 (UTC)
X-FDA: 85310446830.10.F4BC92B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8DCA180004
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:37:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwSpjj5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791725833;
	b=PSKZ84QMCpFjHc7UAtZwGWpicr0Xq1fhWg6wEJc931Fk0JmYWIyTrObAi3cWeGaE5amevC
	nspU2Cmw3l+wrMW4gY0EYXTAjVjdGOoKEegXZTPA/imOMIcJlIeF6e2q9j7HcrR+mJLALK
	XxOD0S+5NNJnBOYVzRP14IcAmXJUOao=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwSpjj5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791725833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X8y55PrXkGOudIsFCasLzIDfqrrSmuwJHtcshJbz80=;
	b=IJxXFRs8HJFFHhhm4IvJvLSlUkVmt+/jk7RVzabwuJc2scLG4frGlI/QCAqvng+RWQVxTD
	SvQ4DOyaFup4Hc08SazwsIjDFMZWQRCuU7s6pIE45nFiRSd68j3mvdVsj2u+6uPh10sQV1
	Du4SbzzujbIVx206Xc8uuceVsmmnu44=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso124391066b.3
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 06:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791725832; x=1792330632; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4X8y55PrXkGOudIsFCasLzIDfqrrSmuwJHtcshJbz80=;
        b=bwSpjj5UkYlMzlXBWvqPMX56W4IH350dXQMJ5gQMJH7XLHzZO+S9hN2CObiIdcg49a
         hcy+j+LejtKThmv17ISJ87v0hQkaDq20rQvVws5AryOOiG8wFnJOuF2hFF9lyU8Rzb6V
         CiYZWrgQIANY8LHlNzhS2yVog7RMCdNZ2eVtKMpjsVsINdwYEwpSfrwGnmzfml7ewqvY
         L4Y2SnnnnJGbdw5t4P63yd0yfbz+7FRLrXE6v9sjD7GP1GEAKL45opib516sKvA933Hq
         JVeWVcJjypHsnJ5+N6HVMkP8OSVMU4nYWSbzRZ2vG51jSMDOTkXevhoofhHuodL+ubzM
         HqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791725832; x=1792330632;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4X8y55PrXkGOudIsFCasLzIDfqrrSmuwJHtcshJbz80=;
        b=SRSfPhKlOJs6IxxpGDYrBJW6HFiRO+EaRvVZGHMooZtwbPa0V3F8sZ0BI3JE1jE7mF
         KoqEXHgFnE2V/ym4SGju1+Q6k2/AMO7kpjztnMZFN+WpZU+S/RRCKqjsRnuH/48BIQ/D
         2JUTLzHKAWk5qz0DZgDxHSpniW7JhhBN/FbeBdGCDTN5atGaP6TtB/8k/NccdLsQdEhH
         jW2DDuuL5rCuwWjjGvZuYVgBZYzt3yCkFQDVCzHJdmsTUMFTuoQAz6bh9uVN0j0DaJ9F
         zFZq7+f9hJVQ7u/pFWbE8ZfHLQAfNcvuCvmLj/4TzmZ6igFbn60RLZ5PHHPFlpHxa9m3
         sJ7A==
X-Forwarded-Encrypted: i=1; AKwUvByLsXk+Lqf3PXcsQDBJeB/juc4p36lso+Nfs1Co9SSPKvY27uzTRy+ygL0j8H/nEY6uLU0gt4LATQ==@kvack.org
X-Gm-Message-State: AFq9FYKghUBHehDNobn2O5LZKRe2nJcNVf6yJu3TWZDGmRLzvtEMZUy9
	BHA9qqmWjRnUCRd2LMHmV9565UFbM9qL3N0kzyJ3alfTx/671if3HsOe
X-Gm-Gg: AYBFou2pqIqgq5tfb9ksgh4T3TUfPgW8iZ/C0VzrhSSl/ddR+foldsCviBglkM0xH3i
	zOM1Y/CCzP3YHPqWf4QnsLRziyGzPgPRfQL+Mnb2fHRfQ7fGm5Enf2JtFgw4YdcF6WckimzS0yE
	j8Yc3juN8ekY6kvulU23x/D03lza047jllAYX6+pPmFfec+VIOOUJPrNw0s3dvYNwzPdq1OSeWp
	1MTsqvJyfg9v9mzMmP/U6cD/51yzrLRHGdbWKR8jD4MWFnc+ZK9ttgp0IcMHAnn3Ym5Pnt+xea6
	PDwiNdqrBhHsWiYhm9HmKAoq5n2FrSvb+MSF1tKRRD4oZwwI0pgzq3cwYFy+pc/7jXJfvempjqS
	qYJMkJTWX+uUAy6gZI7tV/wnsSjreq7rYnNlu4ZfbONdrOTCctE0nEHwTbP/UJZw8aFUykQ4aRh
	pvHa+AhD8t1bDiXchUs6uP9MkqPjkxnnQ3W0Q=
X-Received: by 2002:a17:907:3f8d:b0:c2c:d06f:cf87 with SMTP id a640c23a62f3a-c31aa0d3106mr668410766b.46.1791725832001;
        Sun, 11 Oct 2026 06:37:12 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a7b976sm361047966b.36.2026.10.11.06.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 06:37:11 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 11 Oct 2026 15:37:09 +0200
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
Subject: Re: [PATCH v10 04/10] arm64/hugetlb: drop the init_mm special case
 in clear_flush()
Message-ID: <asuRBRZS9KzC7Y8q@milan>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-5-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002090947.869220-5-jiangwen6@xiaomi.com>
X-Stat-Signature: k1xnas87qzx6gnzsouj7dkp9u1rnbab1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B8DCA180004
X-HE-Tag: 1791725833-865128
X-HE-Meta: U2FsdGVkX19JKucJvc60TTj8Xwa8UFUjd2LjJvwsjVcid6GnkQ5DyBrpu8wqgb22lTjFDgr3nWmXWVDoPkG692ammV5jlVffAjrcd6rpKWy09/vv4o8aW+xhpeOUxsGr21N1k/L+OLmarhrGbHuVDRm8/6E9xfUTykqVf/lLIzywj3E080qbXChSib/w2bJnLNoJUTLsGPQYgytAcesXErIMzPM5a875+3z22nNrTxYlrBVt+Z1aFBhDfcwSU2/aL+RgkmC1dZP0FV010MPjPUJqBP1y79fCCXlkV7ZTgC+QEbiPVXlLa89EdPw7s97XX8bH2ICwkTAhBCkErWuUi6hq+IkSXkrIQrdVtlJFtkBi97vWvgYXiSWiAFsbhkQbPmFdtpeMwy1mn3n9Hly67x1724grNqQhI5XjSPYUpL3l298gLBvLYRibzRrDibU4bhQSsUt12S+BxF3Rn8K/hpLpQniRiJJzpHYMxk/W6UExhFKk1e1EczntZLacP24F/ifE/7Yb408uKVitV5PYbPLp+8JEWtaQXy0ifdaAM5ossZRPjdubpnV4L1F4/m5b1YNiK8OFrZpUU4LHn2o1xCOIcH72g11/e7ZERO82ZUgYS01zvnmXlIVsNE1bIMna4TkWdioLxjFRSmdc3+VIb9OhCw739XpFyL7g0+lT5NQQO0MNO31zv1HsvKAbF4znm/++Xj13wxV7JmK28MfnmU0o8Q2MXacPvo2+lWhRTklcsJwqxiui45OvtICQoKzELpMiKY6RSgz6BRKE1mYZe0M4kRQ8eAC0vE/5kIJCrusIGHBkR4PNmF6yAHY2OmKue3svxINmAoBS+mEwefVRNYNDax4Wxowx/JDWuOsfvwXVMW9xldXNMZuuOWf4cS13BlWdODWcr9TTytpXM+U2hGh0fyQUYTjkQ+KERhOz/pG5r3/ngeBKkVICj3DxLpen9mL5wbFNOxt3kc7Ll7o
 olKT9FMa
 oR/C1f0GZwSefju+tjzorVmfMuxMjwh14SdLvkp+ZsjPLVbHFI/Cg0vO+b7DbT6a9HcE6JSM2aRUXAT37sj2Q+TJodj45Bdlgbo45uPikDFO1fJQ++hYDni6KSC+bcpOKK6Zrt7oquedgppslFcB0dLnjWt6pEandydVzcMV3ccoJMdYNAwHq4U6J+Wno2b8Do225XT8nDiQYBLYOB/cUQT9uHQ6XjBfgt1tsYBkRvTb0uT7p2kQoEMTtL/38ENAl7BobHMxL4H2EGeSWr6i0V3RNfPgTut3Ppvw6fcxd9ROLW9nG4lAlm8PwNaWSf+ClIcNZCKwqJ0U/lLPQ6v861Kg3PypvxkhxAPgSi4kezpcNm4uhD4l3PGRVVDulqfUM74qebCO/FbBsOoRuFxdcR6U+wvOPTn3AgRYWzqiXEzDHtG8VGOYU2J3SppSX1GoEyDijND5DO0g4K+sHhrGrra6V9f3isShhcT0XtTaA0OisUdWsbBfPkgvPf69Ie6e9mUe4PHVZoeQ5O7yZwN6bKalFsvaKqC+HSSC7Ed7NvsONFQNCp9rWce/7SO7er6ApWUIdDqd5L6S7hzecF3xBjSf4n3k+go77SMPoV8bETyyCGTvPjg6hFQEdWV5gtYiDjpXa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:09:41PM +0800, Wen Jiang wrote:
> clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
> was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
> pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).
> 
> Now that vmap uses pte_set_huge()/pte_clear_huge(), mm/vmalloc.c is no
> longer a caller of set_huge_pte_at() on arm64. The only remaining
> callers passing &init_mm are in arch/powerpc, which uses its own
> implementation. Remove the dead branch.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  arch/arm64/mm/hugetlbpage.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa6..ce247b06fe03d 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct *mm,
>  	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
>  		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
>  
> -	if (mm == &init_mm)
> -		flush_tlb_kernel_range(saddr, addr);
> -	else
> -		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
> +	__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
>  }
>  
>  void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
> -- 
> 2.34.1
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

