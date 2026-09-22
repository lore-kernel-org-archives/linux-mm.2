Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45FBC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9210D6B0095; Tue, 22 Sep 2026 10:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9A76B009B; Tue, 22 Sep 2026 10:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F976B009D; Tue, 22 Sep 2026 10:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3A16B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:46:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2A33A0521
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:46:08 +0000 (UTC)
X-FDA: 85241673216.13.C978831
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1036340016
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:46:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4cgEaXF;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790088367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/VLxv9NKbJXTt3b3nNSK4io2b3mM5NUoxiDUVgGmts=;
	b=fhB/w8T/s3eB3C8fabFw1h6zbrWs/INgwqOR3/geb5Ni/E3yU87yRllshvyubPzlpxpKWj
	jIcQDIJS5LZqmXyLbmI/2ziMh1k/t/XT2NhaKLC5QNIfLpnDk0or0frHqNNJHzivCF36c9
	NO1vYTyu7OOKULD8BIwxdxtyYSPSRcY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790088367;
	b=A7aVhonIS24yUWerE8dGNCCLwPeSgE2KsKncvHDZ8gJqdT3gTDD5JVaPwAwOhN0FEUFdyx
	px77RBsV7xCOXIPPlB7CmJ3cMEIE9yRiFxqvHFIsV8pdDddE5lFcwYgRHd0T54i6Dn34cH
	a3B+rgYwUTtdj6UN3v1lnG+tliIClLA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4cgEaXF;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43CF16020F;
	Tue, 22 Sep 2026 14:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F87F1F000FF;
	Tue, 22 Sep 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790088366;
	bh=s/VLxv9NKbJXTt3b3nNSK4io2b3mM5NUoxiDUVgGmts=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R4cgEaXFbD6AS4kaCKua7Vb3e7Vza69BPqCaKFneNWSJQ+ddLeyxTDXFiVRcb4t6Z
	 CN6YHPE6pQ6CRwNgjNVz02pOs4ie6lCoOSfSTFnCPfOGDjtMZS0I5TdmFw1MfBYoVU
	 T+tYkWMTQsWIbQyxL5qMsti+vHneTm2Ym1e0aTgNENwoMXBLWkVjqoSIjJcubodobW
	 PEPxANCUHf+m7MPFg6/8jLVqz/JMeR3FWoQDNOxwm1Pm8k1Fd0BNTEcmpx41+ZvO9W
	 DUhHRMShYQKEeA5BQSiPEDB90RPaiRRqGKtweokjXF7L1a0vyvpQ9NM99FMlupChK/
	 pGheBDxLJbFTg==
Message-ID: <64b10ef4-428c-47dc-a97c-59ba178a9044@kernel.org>
Date: Tue, 22 Sep 2026 16:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 02/29] arm64: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-3-usama.arif@linux.dev>
 <35e42ccc-df8f-4703-b10d-f7c96b263e98@kernel.org>
 <93e71e27-86d7-4853-bbd2-756ac137a925@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <93e71e27-86d7-4853-bbd2-756ac137a925@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1036340016
X-Stat-Signature: byhxrt4qoa1ymec66emrmg7endzu4dcs
X-Rspam-User: 
X-HE-Tag: 1790088366-976342
X-HE-Meta: U2FsdGVkX1+9+gDQd2+tLvkrpwS9HvzBp+46MA/5p7D0htOKsyUSnrTLsO3Zg6vt9gRg4Ha0feOKttcTBgfiZ1GAgp1d5D9tmeDZrbkaZAV6VIUvywQ/DoIU4g5HPpIQphaX4K+5ZLSTKWsP4N+t6nlwqvXId/j8htIVmnaFaG8hqF2sRRrWROfWDKfpJq5xagSpfSERjR2q0ubyJbt7sU8Y85mwQnDk/zVrruBNDh2svyzWwhcOVirs1i/ZLWdtlXmr6iOFTaTmGvlJWXp6zgvDzZIrV/uYAmT9XXqAi3wV86L2g1f8fxNc7eFI+hf9Kc68lm/Jeu9Xz3EVwvhQ7ht8sN4smWFlcgXdwe0ar6tcDZouK2TBQwPLG3VKIqIEqzR9x9+CYSjK9qL6Rb1lCL3R4Zgik81pdBfmYgiAGcSwGpolPbsUpq6SnTYiVXTFOneD+uLtqvRckx+pfPv9TkjbF0nMDUdGmPJPN/ux7aZ7tu0zRSTzajq0OaMY0OBOoG4+zcruvNEmr+Lx5A+LbQifXNsFJmU3tLWB0UH1BTd53hGnPB5TTh60N6d63Au/Mdc/PtWwGnuDxsPRTxDHI1U2zYgP0mpyv107HNDy6Tg4v4LJ/He0k28HfMn3e4gdYRVxnZwfvKB05vmckI8ofQ4Eu5ru0MVJc5V+2KrC+5xFqROxl3lzhXst9jbfMVXhXL+IlvjcuSMtsyc3lfnSqrBXtm1Zyd9Zh1qBNdPwY4E5lMZ8/tFIWsD/LO0TD48oGrnH7lL0gOEYvW3xgQvQeDdTtIfJZNX9B0rI/tLvrtVaSCfk06rrM3aKkON0skdD3sejuI/7pfQGG88eNaEbjHMxwT+4X3oEeBGeJfGWbWkfbGAe3J5GOymIK/01+4NO/78ZwptFr/Ncs8/Mg4kxnAJI/Xo31nGmK+DKS9Pa2y4F3QMMSyg4n5nqUXozCcqcPgFFs1YK/at4PUdCBlS
 aM/fOPxR
 p+GQFK5dXu4eKRU16IHNX6e50M0XlbemVQFR/P2M+/5HV8a6Aur29AUKTSTQKvPbn9thz54bUTqz8MLvV1ybf+cad0MqA5zYKjs7sWvyi5IGOM6FtQiveqj7nUIHR83mqpcpIHe6SY+OrCsnj40puWQIG8AD/iWNDrfmqKGuuGzYQoVqCLvX7Ej7NZmyxwS5gNF9Si990L+LTvBLmj3Xj66/lWNZeONsjXy2WkDm11tR6HNmWBDRR4emgGm5leWFGvDMnSGpC1QmcxuWQKgbJ+47RqX7KbuRj6tqWXbZaiqWly5XpUdokD5Kbmk2SrLTeKkppST8khOr+Wf6psEAoHqRIZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 14:34, Usama Arif wrote:
> 
> 
> On 18/09/2026 22:11, David Hildenbrand (Arm) wrote:
>> On 9/14/26 14:27, Usama Arif wrote:
>>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>>> not just in a swap PTE.
>>>
>>> arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
>>> the PTE ones and reuse PTE_SWP_EXCLUSIVE.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index e89ec5f4787b4..d3f53a601aed3 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
>>>  #define pmd_swp_clear_uffd(pmd) \
>>>  				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
>>>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
>>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>>> +#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
>>> +#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
>>> +#define pmd_swp_clear_exclusive(pmd) \
>>> +				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
>>> +#endif
>>
>> Why do we #ifdef that here, but not the uffd-wp swp PMD helper?
>>
> 
> uffd-wp is gated on CONFIG_HAVE_ARCH_USERFAULTFD_WP.
> 
> If I removed the CONFIG_ARCH_HAS_PMD_SOFTLEAVES guards above, when THP=n, arm64
> will use the generic macro which is wrong.
> 
> I tried building uffd-wp swp with just ARCH_HAS_PMD_SOFTLEAVES guard and I got
> the build error 
> 
>   mm/page_table_check.c:232:20: error: implicit declaration of
>   function 'pmd_swp_uffd'
> 
> we will probably need a separate patch like:
> 
>   #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>   static inline bool pmd_softleaf_uffd(pmd_t pmd)
>   {
>           return pmd_swp_uffd(pmd);
>   }
>   #else
>   static inline bool pmd_softleaf_uffd(pmd_t pmd)
>   {
>           return false;
>   }
>   #endif
> 
> 
> to avoid the above build error.

Just to explain where I am coming from: for all these patches I took a look how
the other pmd_swp_* functions where handled (and separated from the pte_swp_*
variants). Nothing earth shattering, was mostly looking for keeping things
consistent within these architecture codes.

-- 
Cheers,

David

