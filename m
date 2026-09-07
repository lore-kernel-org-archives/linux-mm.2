Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B9EC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537F06B00A2; Mon,  7 Sep 2026 11:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F3E6B00A3; Mon,  7 Sep 2026 11:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424956B00A4; Mon,  7 Sep 2026 11:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14A1B6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:48:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9367A1601CB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:48:26 +0000 (UTC)
X-FDA: 85187398212.30.97C8852
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB77340006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:48:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lvRgPSgW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wudceGLt62w3o+e3x4RUDMN4HluyPL4Ts+Eyk51ebws=;
	b=Zx1y5+8kdFU6RLSqrVlmA7PaZKy1S9BTjqoVxrOfLKTlSH7mfZSwTpO71DUzaFZ1KKnzIu
	m7+0z361r7dFPqsZfhTqqOxi5ygZc6LJRQgHaffac672kPdOJfp4o/faDHLPdChGprjYau
	9kNvyiyR6AIVIBPCPiE1J6ElAhBRS1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796104;
	b=cwwkj7wTIBUlvR2qz55UHigMcRPj8BjjS9BAwwkkKxKvqfq4kejdVqJLtuIO5r7BJFAIgE
	3AAP/EyhH4/nH8a7Qxuk3ayvr+2js51IlZP/upHW/8mC977N0YIQDHpwmtxK900PvDbUHl
	MeNd9gkqh6MpVk8d+eW8uFDNCUzSYqg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lvRgPSgW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDB9E42E7C;
	Mon,  7 Sep 2026 15:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49511F00A3A;
	Mon,  7 Sep 2026 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788796103;
	bh=wudceGLt62w3o+e3x4RUDMN4HluyPL4Ts+Eyk51ebws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lvRgPSgWAAdN4XQw3S2/yhtgm0ggA1Q019dIjUOymiLlfLatsBScYcJK0x4hRnETH
	 /X8BeaWqBDCvY6Ng491iOaK7eJxS59eif9JSxCiMe/1sgAwo1jFVyGgKzFOPPHhXOu
	 9i6WyIW7f38b0Ddk67DZf7k+ECYL56wURose3Z6R5rjbSXl8qiCjTz0TpTKWdxOQZZ
	 0YTgIoHyvDcO5QgY447FEjSFduoYtWOExqC8LN9WmgoqcEUbNO4o+LTQyT690uejUV
	 WzhTf/ZzWSJkdbOIH0xq131qlWB8m3G9ePzyg/RuD1N8DMbxrFuNLZI62jZbrOUvHP
	 V7d5MRGyYWJJQ==
Message-ID: <a70e45cc-dbf7-40da-81e8-ee6055f2692f@kernel.org>
Date: Mon, 7 Sep 2026 17:48:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] arm64/mm: Move __check_safe_pte_update()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260901065454.1906343-1-anshuman.khandual@arm.com>
 <20260901065454.1906343-2-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260901065454.1906343-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB77340006
X-Stat-Signature: dwoxome3naqmuhsbkiuhaenio5e85dr7
X-Rspam-User: 
X-HE-Tag: 1788796104-88236
X-HE-Meta: U2FsdGVkX18U8wJfA1XzeyY9crb6VCOcBHiO/cCrbruJAYEGPn4ppP1WrfcdWZSF6l5ssLyhzn2mviLs/G63jMVfbgN+lJpC6v8gQh61LvcqBouazmeehomxhBKTDoJd/rmCKTEgt0VTLp0BDSn3R/xyPndnhQnPGwuT1KlgwfUEC6nOSOE/TtgtIRL9mUr1TKsHJDFlbsTbqS1wxX7lwMqje/6a4t82NnKG1IlTy9ncW8VjTX2pTlM88t9Piwy43Vc1IkgiMEDc4QboWbYOejnfm/mUiCUfQaymRRnWKHtSRtSSV3/I/XtdfVRBU9aBK3DT2uWl2WK2hYWVNAeFQd8Rr0jkzbc/EgvXHAURJaBTqdzXbrw7BAZuLnnwwcOGEDuEP34lwXFWqxuGGPaiWCe0vW11o7n1rAUaOpQF9YalKJ5leCjFlDR0LfWOnscsScHAelsTnyw8fKNa1hsI/sIylW+7f4B1GVWeVngZvc2Cfp1LnCsIyKDwspTGCXn08mkGLSKxxJJyoKecaoP7nbHgahJsbSekumNC282C/Ck1oFiHVvpJxAofcUrzgdz3JILyW+8E/i8RrH6gLWOblzye34c9fLK5FnKdLGktyNHdxDaZ6TVhpS2xncUg4B41OKx2PezbyIaXEpz9GCIM8nyBJTkMQl2ocK7bMv+4oM+bBB1zxcg5j8/g5//MYDrYKz22yqtDNihM5BKutBlmYnrNynHXtKEFIVTz/2Slm03zxveFf+4AcikzEIdkHD8sl2Vj6Lyq7/px/xifeAP1I1pl5BHHV/EFikK/gpP7ZkNvvLAi8pAYi7IBcRfFunTHEB9d4F3PDNtcPORw8/WPJq+VOumI/TxXdlN6b23JOlT3gprzvbiqp693jTFT9KJAPxV/7vrGd2l+AV/2MKX647TrcnXrf8gIrKb0HXf8Y2p6qj6VoAEtKVQHI2XhDNhNHNBTNiTyWHjHHmYo49j
 pZDI0NVa
 SNSkt04lE4/d4T0E42qRZVRjWO/iHQO2Vt7iHu/At0h6nmOFJZqSZLJMK9+EcGf2n0u/WOAGap4XemmPoazKufecZ8MvkXsieaCrulCHb9lQeQHpNoxgiko3Mao2Vl87rj1FUOuz+eCVYqXGMQgio/KIF1Hhz0PbbzTyzXP1Zhhsi2jMsWugBJkBwFxHtqN+yTRq50QcWNYNlS2KUpyNIAGNsj7DtD03ep3n04V7V0surl+1ttCZvC9+NI38G9bp7ALb2iCeAV/qUSWZD3B2XeAo1hPNR7wZrt2t9PhgXp8Xr19fNsYC0ICS03BLmQDI8RYO/cxYqe18JKgsn2LUuqVgl/xbMJfXqcu0iJbzjC6vjIoHlW5e9hjMrb65lbng8XAPyVc+1l8EdHUGtzdJcBzfBAZQzdQBkr0GvehxzyKqFBUSWWjNsxveAxh58+AMENbAh2yPD+l6IFrIGamyVQ9fRFAOITskOFjxm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 08:54, Anshuman Khandual wrote:
> The page table entry print helpers and related macros which are defined in
> <linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
> is basically caused by cycling dependency.
> 
> Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
> for subsequent usage of the afore mentioned generic MM helpers.
> 
> This does not cause any functional change.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Should __check_safe_pte_update() be wrapped in #ifdef CONFIG_DEBUG_VM
> along with dropping off current IS_ENABLED() test. That would ensure
> the function never gets called when CONFIG_DEBUG_VM is disabled. That
> will preserve current behaviour as the inline function gets dropped
> when CONFIG_DEBUG_VM remains disabled.
> 
>  arch/arm64/include/asm/pgtable.h | 47 +-------------------------------
>  arch/arm64/mm/mmu.c              | 45 ++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e89ec5f4787b..61fbfab3e06e 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -387,52 +387,7 @@ static inline pte_t __ptep_get(pte_t *ptep)
>  extern void __sync_icache_dcache(pte_t pteval);
>  bool pgattr_change_is_safe(pteval_t old, pteval_t new);
>  
> -/*
> - * PTE bits configuration in the presence of hardware Dirty Bit Management
> - * (PTE_WRITE == PTE_DBM):
> - *
> - * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
> - *   0      0      |   1           0          0
> - *   0      1      |   1           1          0
> - *   1      0      |   1           0          1
> - *   1      1      |   0           1          x
> - *
> - * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
> - * the page fault mechanism. Checking the dirty status of a pte becomes:
> - *
> - *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
> - */
> -
> -static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
> -					   pte_t pte)
> -{
> -	pte_t old_pte;
> -
> -	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> -		return;
> -
> -	old_pte = __ptep_get(ptep);
> -
> -	if (!pte_valid(old_pte) || !pte_valid(pte))
> -		return;
> -	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> -		return;
> -
> -	/*
> -	 * Check for potential race with hardware updates of the pte
> -	 * (__ptep_set_access_flags safely changes valid ptes without going
> -	 * through an invalid entry).
> -	 */
> -	VM_WARN_ONCE(!pte_young(pte),
> -		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
> -	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> -		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
> -	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> -		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
> -}
> +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
>  

That implies that any __set_ptes_anysz() will invoke another function call that
will not be optimized out.

You should likely keep most of __check_safe_pte_update() in the header as an
inline function (or at least the CONFIG_DEBUG_VM check), and only move the "slow
path" code.

Alternatively, make the whole thing #ifdef CONFIG_DEBUG_VM and provide an empty
inline helper for !CONFIG_DEBUG_VM.

That's probably the cleanest, because performance with CONFIG_DEBUG_VM is not
really relevant.

-- 
Cheers,

David

