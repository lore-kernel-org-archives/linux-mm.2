Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D977FEE4E9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 11:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E03C6B0005; Sat, 28 Feb 2026 06:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E3D6B0088; Sat, 28 Feb 2026 06:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AD66B0089; Sat, 28 Feb 2026 06:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E99716B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 06:18:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91FFA8CAD1
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:18:00 +0000 (UTC)
X-FDA: 84493615920.15.1396288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A45EA0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:17:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q5i3/kOm";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772277479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pew039JfZAlJjaElxpgJRZ+nNgjTgGGbktRpJh5x1cI=;
	b=O6dhyKOmuYimiCt9RYYGqMPxlReNfo5aeAF/2DM6XymrFGGZiYMssAXRSoRJ/gYcesSiC7
	/17fcNM4hPNJsLrlInLt7D9u8+qAqIW7QC1xkZc0ec1VXgXN34kwkiHzdwpHH42vQ6cHR6
	0PB2n8cZDxNZLDS4unnqutIWDJtYqDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772277479; a=rsa-sha256;
	cv=none;
	b=GW3zSzmNF52qMVxOSDn8C9zykYg8RzyVJ5Qj55fz8HDsxE7vhthFJMDy5/UqpUxij9fgiM
	9NAVDkkr3SP84FmgLUiHpEZzufp/GrfU4peEwYD9b83uI3F0nrkE+FwYaRZHEwgf7aK/wv
	PNOIC7aCMjrsdyYavFUhwxJkOxrNwHI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q5i3/kOm";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40C926001D;
	Sat, 28 Feb 2026 11:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22147C116D0;
	Sat, 28 Feb 2026 11:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772277477;
	bh=jZWXF3FSqtf+aARQ2Sqm5G5WYHMhSQtLomtx/zb4iPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5i3/kOmW/i0sUqzxJ3FKLi2yeBskmRPGb6DY6Ec1H+TYDc/Qrhdr5WHM/I2q1WO0
	 Z7YdJeXtqkKmjW15QmTb1pbAicnNyXc8qgKFxFJ2v0wCr/p31kOfMGmtsw+MTJXnT7
	 50phJM1WxA+FvNNnksGF0NXwd2PY0vuPXebF0YEuH8ZqG3CQW4tDVyWQOmDc4/ZFcJ
	 MuaQHxrEtdTAE/GH/Xgm1Wy0nwf1+pP6K30ZENYjDjJKyWJckKf6wLEneM6BOgg7mz
	 6O4loYJhwm23/jqut/hEvS3Q6xIXrMak9UDUMMkfq1ux7Ca6bAz7EVS1XaedQg4Snz
	 irg8fkIn0Ezuw==
Date: Sat, 28 Feb 2026 13:17:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V1 09/16] arm64/mm: Route all pgtable reads via ptdesc_get()
Message-ID: <aaLO3yOu1ShO2tNz@kernel.org>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-10-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051153.3150613-10-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A45EA0005
X-Stat-Signature: ziskac8o4qatcnszzxfyw7gfj86ch3ya
X-HE-Tag: 1772277478-454317
X-HE-Meta: U2FsdGVkX1/MftDDRMM8vZMBdoS1VPtSEECVgvwnP8U4azoCEzTgEr0M1Gjk/5fNONfn6eTXPsxmP+qhjpLxa2lBudaqKXnUdub33khNE6Ak0r3IUuF2lMunrNgktHjdEZ9E1s+IxYe0zO+Bi/C0vah4zOygyyRBnwTXeS/1YFl34VLRywH7pwg5tSXrA5i5GWHMvceC2j6BI2/x1/FENqb75G/kjgkop23DDQixXYiIwmSob+KfrqXQWe7MwuuWHN95o7lzIcyW+WbJaU9ei6ISpSyU8P5C8wwjWSjrfDR0zEif20lcTDKlJVjFbaTAFW8aUYhtGoflzhPPYCXgpUBc48EP03ygFsD9hibJDGaqErjVswLDfiPTLdn7w1vj/rtE2fvFXYBxpesB1u16ONvZuJoDQCVhNqqRiD6Yk0dKaauEpfwPsxxMKjH/GqWkAAyZ4nYlCJEkyvwxo4g0BdEVm1NlWatWt6Myu5M4aIqHx+o8X2rYy3ayum/Ww4wIrsD3VwVLc6hCzGw9iz9OOQKqISiv8q2rwPUxTNpwT0lFo+xSKefc9I0owALNdwuBVfG7pxAC+Th7IV5HuoleSHn8H4Euac7IbbiQbKGS5UdJI+vSSTun10VjfGgFEqk1ImAYvK16gHmstLTrZKHpA2a1swYd1+3uTth1MpJA1hH9gRD2qzTEoXE27Qxc1EeB12B7cHMglj7QZHM4Gczq9zc/UfK8rXZS5Kk2hSjaGm5tNcv42fqMaNMpuvgzgszTrSoPKhqqdOIWpeCzSuuGhmP2KYzV2A994oVovAeyaDm0xLOX6ZjfjB0TY1LnDmXYvM98yqS2NnaJP20AdpbZ+zW+jm3IEe6bD33ZmEWGoG1MEWYjBrQz8UvBflK0eBFIaOQwz+oGKa5XkJXw/mItuhMAPh8jN+vpqS0wyjv4+Jcbh4I7LzWJO9Qq600X+tB8jVapCiUrSFYqL4MDlUC
 P8gVbGMv
 n29dp/F7nXZHWbfqCZEYkVjHWzhwP8ICRAYYpHok9zy6M3DjH/d6ncpur4EzQZA9fb389Y/ske9ktBh2eEBUJV2215UMxdvJB4KRRQ7TzX0Il957RRvwlBxw22xLYZl9BgiZQ98nqlBlreN4dkX5pTdJbnO4kMU754U4zPx/7X13XDetFSCa9e1TIa0gfuIJou/rLmvQGk6vAcj3CVvH66fLCQg/1GFVNUaKGnJsQu9sndzT1kUpbP2Wokx09kIqp5hzlSJh8ihcCOGNlHf1SJwCLhKkaxnuM4JM4aYnM0K2aJ9g6VLYDyZK9/ORwBbnCV/tJIUaOL9nOVYj13S4vX+RRZABQTkYXUCXPvOrZDrZaevThbzFCUhd1tyHjE7NgN7DJ6OjLdAGF0u4TKF20MSyGgfMPZG5bJR6mRfMObL9pMrXzrEt1QhvO0Zu4ywUnYszS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman,

On Tue, Feb 24, 2026 at 10:41:46AM +0530, Anshuman Khandual wrote:
> Define arm64 platform specific implementations for new pXdp_get() helpers.
> These resolve into READ_ONCE(), thus ensuring required single copy atomic
> semantics for the page table entry reads.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 257af1c3015d..804ef49aea88 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	arch_flush_lazy_mmu_mode();
>  }
>  
> +#define ptdesc_get(x)		READ_ONCE(x)

This will be confusing with 'struct ptdesc' APIs, maybe ptent_get()?

> +#define pmdp_get pmdp_get
> +static inline pmd_t pmdp_get(pmd_t *pmdp)
> +{
> +	return ptdesc_get(*pmdp);
> +}
> +
> +#define pudp_get pudp_get
> +static inline pud_t pudp_get(pud_t *pudp)
> +{
> +	return ptdesc_get(*pudp);
> +}
> +
> +#define p4dp_get p4dp_get
> +static inline p4d_t p4dp_get(p4d_t *p4dp)
> +{
> +	return ptdesc_get(*p4dp);
> +}
> +
> +#define pgdp_get pgdp_get
> +static inline pgd_t pgdp_get(pgd_t *pgdp)
> +{
> +	return ptdesc_get(*pgdp);
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -384,7 +410,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return ptdesc_get(*ptep);
>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

