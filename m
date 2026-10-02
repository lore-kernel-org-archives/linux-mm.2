Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933D7CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47F16B008A; Fri,  2 Oct 2026 15:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F89D6B0092; Fri,  2 Oct 2026 15:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7BB6B0093; Fri,  2 Oct 2026 15:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4C06B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:29:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1CE61607E0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:29:04 +0000 (UTC)
X-FDA: 85278674208.27.0870F40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D214E40008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:29:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ4LUrq2;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKiXHVPNbskbxRmcfJdeYAcs9CbqQ6iFfiXid0l2arE=;
	b=kJLzNqt/L3e6YS/GzLW6bnbWLRI+az4IBpQMJL/F2gC5vz9JMuCIAoswKytBo1gRCI72aM
	3HeaYqOytyiRtdfqDLqSEuWIy8cPoCMUZykphh7CKlJxrSWPOHiiHU1WBDxnIIyu+60XPa
	fM/24WOLmcXB7vrihtM6XawoWIxW2Tg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ4LUrq2;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969342;
	b=h6WS9s/FakEat63Q7tAdI7JK5WtQPvo2Sl6NHClD2htt+YtcWe0bPI6ZzPqtPg4X56bEVp
	u+ZLtUGQ0UmSJLbvL2ZV1dY+xDVVhx7bFzqHgV4EnkTnUz1Qsi4gEniM6lp4++9MtqNrPf
	olRRtQG2d8TeoSa4vREi+VzW2NuaMiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E2C360AAF;
	Fri,  2 Oct 2026 19:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A2A1F000FF;
	Fri,  2 Oct 2026 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969342;
	bh=wKiXHVPNbskbxRmcfJdeYAcs9CbqQ6iFfiXid0l2arE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EJ4LUrq2ySsTcAFWwrouLXGqbGx0gDjPBo1eFRga3iviClLlVxzME6YVWlMjFIPJf
	 AJO0MtJRNMpMl8g5ZZvH9/J/WQVhJjgyiJgLaSOeM848tS3ga/1aRE8W/HGuWIFGOi
	 3w8HlOEnnbAP/tgVZOaS1498d2CkaQefzqB0yL4dFNIUIGTaWCmU2Crmmnj7IP170g
	 N3ZhdXHW7v2IEWsut9D87g+qnfcybe17e4Vqg8V42vemd8hVcHaa66LZD2LNleHRQO
	 6Z4ub+CVvhbbSGTeeligZmbHknC4rVW1eeAqxDv9wYzmoayZuNtgQNeKqA9kUM50Eu
	 zOhAHpX8BuI3g==
Message-ID: <f54d5d75-5cc1-488b-b640-76163419cf4d@kernel.org>
Date: Fri, 2 Oct 2026 21:28:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] powerpc: move has_transparent_hugepage() out of
 THP guard
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D214E40008
X-Stat-Signature: mmpjfpenssw6ju8p5frp3aqbaqhgop53
X-HE-Tag: 1790969342-231222
X-HE-Meta: U2FsdGVkX1/wM5hkqyafUM5cMSU77iLuk/SFc86HfzA6DVGZguvxoqTl3TUPe+1+4EOPOIQPcHOw4w9xn2GowVd/dLf3UJPDJfVR4Tmps1E+t6wFIM8PWaNK5pdqxHD8MX1HcCye60GEn7SVbUizoplYhsYpzEgtlYdgu7wWt7b1s+lI799bsQJe9C/88RCFFjssZi9sK6zMInvPpT8fVGEQRxjNal2uI2NCJTmUoEkVqxbtwJRt4jhtYphVGeXzaPGpeVxxRi8jI4V0xl46oAmvocNnh5GzqeI9jaj0AyvSjiWqqUiPvTo+8bje+02cJ8in7H3XgJPcI0NdbS77gVL1sohy+x4TMII8kqYVu3Vm9yYppFA63OSTEKguFPTsQ3X24dAsNxfpQwEA8ADRA2LnUwDy/XKODEDzCSLxiwYI31/qvDxE7g3R/p1XwxHsyWjsmqQWv+FFxcIryOKeL53gV4ZWeLcuLua9PzEH4HtHUDn8DLoRGAYk3O8+vhGOWteDuzzObQFTlh5ok6NQvCWizYcH7Ad6oKgIEfafEy7yLVMqU3pPdpdC0MT6uPsUdlIuvhbJhBz+0+WRbm6uGDFC8bqU8SKn9VscZA+0EzIFRdccw1F5x7ahbz5mwlJRv9HazKNla9jsvCsWKiUbDqHJwg9BF5W9TQp4H0WWrvuumQchyqHxd3DkdE+UgbfMs/dkydU5fiTMBdrbo8MYaGvgejWR9iSFWLTbnmR+VT4TDgVkA5CLrTU3omlsSSB33yqZqKtiJ6eykBK8+3XekBqImDY2zsxiMHDsZs2NBMouB90OqZFpzKOunI2/HeZdqwXlB7vGN69zaOXhf2KK9aj9eVARqwRfdtj79BWitkuYfpU87njxqVN9YD3vOYlbq1UcCrHi/VAXVR9L1g0KE2AMNxaYFNWjtvdDyvqT58iDBuavatnafvoYiP3K9nSJ4DE/zDYC+ZQMZA5fnhS
 WGFBtT4P
 7pkFFU9m8rsnPJJI869Eu2BANfhkzdukWEavE4tXxeXwwXuLw2vFzfmhIMHn3kCB1m4MTi175mhxvXvlHbfIF1r6gfkrJ/Ucnozq2B0CEHbpjDw74NOMRpz1fs+WiSbGrKSZ7e0aau1yrmtpPWQ7B6o32yabCGf14bgmJvc+Da+2+G5DKMlzLzxoIWJcF26Ohllzq3EQaJhaYkj+JVVVnd4NhvZ0Se9oj34kQjurB/w19zSY8QCfbBNr0RoYCQ1DXIkhFR/+qkwBM7j/LtoeuG6usjHm/SYZ64NY5oNV6v9Vfb7iRoG/0f1J09xx9PR7/yRGmRWe/ePvzjqWBogQJ/724AjvLYfa6QvnQ9wnOWTfGvE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> A future commit will introduce a kernel API to allow for checking if the
> CPU supports PMD-sized pages. This API will be based on the
> has_transparent_hugepage() implementation but will be orthogonal to THP
> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
> 
> Move its definition out of the THP guard.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
>  arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>  5 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> index 8e5bd9902bed..79511e6abfca 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> @@ -165,9 +165,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>  extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>  extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>  				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);
>  #endif
>  
> +extern int hash__has_transparent_hugepage(void);
>  #endif /* !__ASSEMBLER__ */
>  
>  #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> index 7deb3a66890b..a4a44a112ff9 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> @@ -278,9 +278,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>  extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>  extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>  				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);

Without some of these helpers in place, I assume actually using PMD leafs
without THP would require some more work. (which is not the goal of this series,
just asking).

I do wonder whether the architecture should instead simply say "not supported"
if !CONFIG_TRANSPARENT_HUGEPAGE?

That should still enable your series: using mTHP without PMD support.

[...]

>  
> -static inline int radix__has_transparent_hugepage(void)
> +static inline int radix__has_transparent_pud_hugepage(void)
>  {
> -	/* For radix 2M at PMD level means thp */
> -	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
> +	/* For radix 1G at PUD level means pud hugepage support */
> +	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>  		return 1;
>  	return 0;
>  }
> +#endif
>  
> -static inline int radix__has_transparent_pud_hugepage(void)
> +static inline int radix__has_transparent_hugepage(void)
>  {
> -	/* For radix 1G at PUD level means pud hugepage support */
> -	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
> +	/* For radix 2M at PMD level means thp */
> +	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>  		return 1;
>  	return 0;
>  }

You are swapping both implementations, which might create some unnecessary churn
I think.

-- 
Cheers,

David

