Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97C3C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3916B0095; Mon, 21 Sep 2026 04:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA6D6B00DF; Mon, 21 Sep 2026 04:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7D26B00E1; Mon, 21 Sep 2026 04:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACFB06B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:29:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 421A0140582
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:29:33 +0000 (UTC)
X-FDA: 85237095426.19.0399689
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 824191C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:29:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qRXpyMvL;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789979371;
	b=5+TsHXoucPnztubZc/Y3YDz4u8pd6lEoKNjHH3pc2uwWgxrxBN37hl+/YHmS/mG1yvnQ1W
	7HPwFPTCVNISYpazgglZE15R7+zQHgvjiB+DvHLZesk8LigjH+1h/zgPXfJ1XgQOI6O49y
	zBcybrhgkhrm8jMyeZ0yC8ohe6dMJZk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qRXpyMvL;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789979371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqOON1OGtH9eqaUM+IszsMChXNMEIUJ4mlTleQ1FuQ8=;
	b=n1OrzJTB8nEoywG1ql/h9k/qhK19ZieD+FclF90vfbRwHZp3ZpiTMzMyFUBgAOtNbSC94A
	qi0QCuICWyT3pC8qJpkjksK/Om3+dSr7FpKwLTD2y128n5X5rfYZpGAJu0NFFw9BrtOKOG
	l4AoFwzhNdoLchPfsvFWKhG3z5GYPl0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EA8E175A;
	Mon, 21 Sep 2026 01:29:27 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1ECEC3F86C;
	Mon, 21 Sep 2026 01:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789979370; bh=Ad+6LLybI3uKKc7JJri+UgLlmCgPg2pPlm7qhk4O64g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qRXpyMvLHNueHE/qqmGi8wywc91oBqnC1xt/cQExQtagrEoU13hb8I0V89H6Lao7G
	 3OHXj+U/lHUmAJ/1SxkKWWapIqk0qrE9EAGWElpxtagB8APekzbYKUgqjO/U1aCgBH
	 42zSHCFhDH+OJ9duPe2mk552i7cOLu0tCTw7I4I0=
Message-ID: <f790350a-02eb-46b2-b079-fc3db66f2b03@arm.com>
Date: Mon, 21 Sep 2026 09:29:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 824191C0005
X-Stat-Signature: p4fsk58omso41zjcb3uoj3qc48a1ad98
X-Rspam-User: 
X-HE-Tag: 1789979371-644835
X-HE-Meta: U2FsdGVkX1/dN4VgPRxfskYhoimaGOfGNG22iLbWwUqiXn5JP1Jtg/nMp0u3P4Pf2bt+LDOODCOWD52WkcqeAB6EyqH6uGv5eX0pcoawbtAYXenT4VsAFneUKEnwogCmWxcwU45WK9MvOoEP471wNTgOBj6O7AZYrXwJ+cOrHgSyPT45Lh1uzCja02zpVPFS9hhuWFc5+vMFx8e6E6v72WgAi0oEUawBsUVODdILsbkU7dieAVRrB+j77QjlooNfyrV+gmUDUd9UwOG5XAZEHrW7KNsIY2QJ/TXJBlIG4nZYNhM1yNOn9Ur3t6WRK60rwcrBo5z3Ra+wC6NX7DwicLqO/aOVfs7/Cp0IWpy5e1jb83xUoSJ5bpUxBhpju5lB91OSk2Z6+TLjpDMk+W6DdDPchtmkMlAsd23Bw3uH1HuxL0p5LN7JmOPmapOAMXI7KXx1+LCAY5f5lLyuM6eHVMEmxJE4kpujLqoiPLMGCQ0+8GDjkPK1Uq0K8GRO5KIbD6gJSzeT+Gt6U207Ju3IpgQXGfA83OPyjNtQc3DqnBvzDAyJtKQdtzZmNYTSpRRYyHKA1L0LP1e9qc1IfMfIRKABPa4Wf0ok5WwZEipsjTRB3JQIFHV7paKOuBdakqb63bP9UAzxURy4NnZHPDDKRm1RPdsOcmFQq/RGlgWTGX0mVH6a+sbJOIwUoIAXfXLAVGiTJLSGPwXQt40mGU85+LFVCjEcLZo6PAhudTNVk78Eb9qdp737OMUNWb3Nr8NgJuSEPiJeqQbOMRSQIOMxYhbRJUJ+vW+T3SI9roul0v4dRTlEC1b8jdY0r07N6pW+aSaX8LsiJ250xAPN+Qd+zN4ErCbM826SHyVNW7Ds7c+VSZ4+n8JIwcEWBf+lWDkG3pMj4QD/SvyNrpH83PCxujIX0iVjlQykgY+zZF7w9j6i4WzqdpYyBwZXOdFuhPBsCbzwL55Sgh/eRnWTXx9
 Tulk+uf8
 uWCf5UNgb+Fr9l9F5f9Q7qhi0lMamqH0YLV7pzBbpRp+7VeFeUpDEk/L2cXfFm7QN39PcnllOfKY1bzSYBvicvsRp1xWiJQ6DeNK6cs4VneIit2tI4IA5U4iRTJbd9ngaH5LR/LphjeWfURShOVOZEDr6lf7mt4uqkXNynmTrUmBdGeV+x+UZ73SLB3PEVjWavTAjdpEfg0IWf5nDAUvejZS8iCvDRENwfrJy/F7STZk740+6mj0QBSpNXWqxA8BzMRyRH3SumruitijKgsm5ARlmDBW2Ds/DLGtTgy8DXLxTQctx+MV+w1UUU8q87tLznO6Wb16TvWqiKobaicfdVBY1hBz8MzarVkJ+KNwmLfS/TSqKKuGK6VzduHrZ11z6+h/N3emtJ6B5CKQZc1mtexR/Q4U4WblxnJbW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
> installs those arrays as page tables. Their elements are therefore
> HW PTEs.
> 
> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
> pointers returned and passed to the accessors. This is needed before
> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
> array dimensions and placement are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/mm/fixmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index 237a9136bc73b..709a97fe327d8 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>  
>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>  
> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> 

Ahh, so my previous comment that I thought this would break the build is wrong
because you haven't enabled ARCH_HAS_HW_PTE_T at that point.

Thanks,
Ryan

