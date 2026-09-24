Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB762C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5AB6B0095; Thu, 24 Sep 2026 08:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56466B0096; Thu, 24 Sep 2026 08:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45236B0098; Thu, 24 Sep 2026 08:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8204C6B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:23:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F2341C1D30
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:23:39 +0000 (UTC)
X-FDA: 85248571758.13.3B27058
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 557E220007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:23:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CjAMiE95;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790252617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDwNrnfrFaJMSFmetFcbsNCjlCJku0TSnZgjADc7tRM=;
	b=qgk6pXBpLYDhovLX0eVz2HERVik/ZZlmwvldc2f1IudfK/ydXlNV/6Vn2X5vkG/yCk2YK4
	lI5qxJGJR5M5t1MnY6LY4271G7EDX3gRGuWwKWJ4w52Ewo9dUFOmvHwbXiCHaCC+WKmkDu
	w/oH4CYLDRGDvXBDLptWEcpUy+nISmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790252617;
	b=rBKOcrwWml6kcSLbJBjWQ2o1wzcBWxIf30dOxEqgF4j3pvBe/dqIi1EAU6CuLmKtAAsgGC
	EZohtr3/mI9o6gQV5nSnSYrSMSJ2FXfXXXJjImkTq3G0KBv88H1BI42Zzln5Pv3ZuTJ7NN
	v67VqN3AunCOrXOs0yG3kBoHNsXXJnM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CjAMiE95;
	spf=pass (imf31.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB5CA152B;
	Thu, 24 Sep 2026 05:23:32 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18B033F86C;
	Thu, 24 Sep 2026 05:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252616; bh=vNFe6jSuDfebOXCmwmWjYhSTK+XatMTN9IVuzrYWanA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CjAMiE950CD1likYhHHG2G4IDbslsFxD3Qsg7M0c/rEsrgq0shMN5wyePSHulDU5w
	 ntAkjL3I4uXuHGdNdSZtQIh7Vvcbnn+grI4a/YnTyOemiulO6PNQz2yAZroktlQqkM
	 rzbMuwv+8zjiPVV8HIZ6jKyW0OBl55PjEDIZxndo=
Message-ID: <27c9b227-9dae-4263-be10-2c6089f8f425@arm.com>
Date: Thu, 24 Sep 2026 13:23:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] arm64: use hw_pte_t for fixmap HW PTEs
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
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
 <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 557E220007
X-Stat-Signature: e6xhuja7ymu5qify5cw4pjnrieb4o4em
X-HE-Tag: 1790252617-615928
X-HE-Meta: U2FsdGVkX1/MQRS4aGBY9kKQb99yhgjMBlq3hmp2xLu+6i6sdIqR1Du5/hTN+HTQZv4slqAn2AFNe1sWk/aC1rqhe4WWzSNZf/oSHbnk7AcQh4AswyHu/zK/tbsBtZFWVNFokScWd/uYh8Utm4pLIh7kZaYQc954/XrMG4BBbY3MNk7+FmTUcHQ8qkElPLTvBF/At/LlCn4/EBQOvxb1E11/xVTjdEn6OxhgPM5oJkfz5cShtLsv9MvT7cOXyQDzpaLytxYiz7LrF5jFUhZT+0rZ7QlOPX4JCosFESVrFx0z42/pmSk2Uf5M7eO73PAGO0KL5WMxqlYKs/plPQnjhxJnKtYcsHoa1k8nHS3v8TN117mUTjGkPURbwqrqZ0UshcnJx/A4zgX+rv7532A16Mb6HOQH3bdgAEdQT3fNQd4Dp+Z+BBnnwoGEp0JUA6ylR+XzJmVFvc29zaebiYcULPZv4FFwGdx+7W9+O+3VJbD++D47HTuSmL8jiXcvXbdXPVVkJbJsoHrATEIDJ4EPP4XwynLKH76903Uos3rysUateKGEKgT6Nqm1SvK3AKFeTPA04b7GfHYhohhCT/UtrunJQwfJGmaWteAHGioVZfj8aXbAfZaFrUGnwetw5jshlM7Nk7SGH9RqcwvygbLmNAcIpz5iOClCFzMNcc4s+27rI4zwJnw2vVpx7qathlgRMJjsM73N/+Zl3g1qGEkQor0W0qZUQOv3Tsxy6z6oGqTxhCIP8fnLvJgO8G63oiZlL+WfIIgnuE2gHgwXfyF0khSL0QXHo2IeDUKGdT0sK/bgumkrjPKs0Q/X9N2QcQm6lzB2QThIxqjlhIPM2xToNF6KF3V891dPUxL7m1EyMe0RLeUiFgIdiG/OwLQgXm9NCBUh0qxrwpaMinzdDR/Ry5+Yr1OB+CDLWoejHZqYKgJjX8NkfCFvzGrqzF7dRsqkoPUXDY8GlmuQ7CFrRab
 qa3mbLgP
 aQlBYnnYQ8TasAUbD+TIIdbMW/dNkXzhwKhlfOJxpyssAXO+ehFmz8dwd3ioLFMx9PYsLtlnHMhbT2llz8T9HmAkcedJxaNXxdOUYJ1SYvGuL+n5piqSUwfLaAEklbp/BUiKcrDy8AuSj+ERu3U8Jq5SZ+5fMuRDu3TLyVS/CQYyv0gCgidbg1V6p8B0WC/k4gd4zJbsGHrXIXxGldAWLzqr9wS7L/iqARYAWkVtEH8LDDVTdM5cMk+d/O70eAD1l0e+il9PnEYJk6qAirBhJgjsJl8D3aMVP/O5Uog6FRhhhpzK0D0qJsdFCCQNmWGQW4qX8EhI2B27Tf128Es16dKsNoihKbo7L1UGJRlr7eIc+Fhc0FDcAkFzyi5wp6NzuOSWyVu5JB3steqNXny2nO2SSyEVvmugA5/8u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
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

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

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


