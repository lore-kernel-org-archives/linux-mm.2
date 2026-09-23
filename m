Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A02C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A816B008A; Wed, 23 Sep 2026 07:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA9C6B008C; Wed, 23 Sep 2026 07:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA246B0092; Wed, 23 Sep 2026 07:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35AC16B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9BA9120752
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:20:36 +0000 (UTC)
X-FDA: 85244784072.27.F47769C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F15C840007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:20:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqUA7PDy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790162435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2qpMYdJaz4fAIUSyChAch/nEGjd4wrkfVeBx+WLlqE=;
	b=TmOIAn1lyixRheBL1p5RmhpQPe7H8l3tOHXiAPYJfu3PWb7IPhRP4QBRWXERxFvE7saiuM
	HAdv3jTyXPoRb3khny788QmjfeZpkgPdNIFN6bvfpHGfuucSJicKnfbF+AVNnESHA73/eC
	V14N0WCe02Pg5SZ3VP+zZxLii7PvPWI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqUA7PDy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790162435;
	b=ruqY8yjex+z+47is+ZVAq9Ry/+fUwTq6nU08VwrqlO1EHYRNpFRjsUBkruAx1aZgQ7IpKZ
	dBX+ggOqYxqhZCURym4uoEFuPlDCtODgCwBJn60g8f78cUcG9a5ReI5vDC90Dy0NlTuKJ1
	FXHiTxrwhfy67b6DDTylPCPPVBMCay8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 782316020F;
	Wed, 23 Sep 2026 11:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753231F00899;
	Wed, 23 Sep 2026 11:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790162434;
	bh=T2qpMYdJaz4fAIUSyChAch/nEGjd4wrkfVeBx+WLlqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eqUA7PDy7+NmO2fWXgUCRHcoL1aj0mu7vVZbrUFneUJJPmUViNaxyE8PJHIGrPZE2
	 9n9iqQHrvoL62Kl/NT0aYPUgPpVaeyliUeCz2vSWumqe/atTO/49JC7WOOJmCFgwHY
	 SuMNbNxXgRR1u1CAXxK9vqVkFSzR2UEekJh+lsaewxP5/wMtTjFJRA4xXTTqp4RAyj
	 x/OeR5zlFZRPdsS2hm+RasuEnMhYgHxzxaUj2mVV+uY1mKxM9kgtVH7VYXWhV7YCTw
	 gXWF7hnk/6+zaIqacb5EF1hM0zzkfQGUmqZ9En+UTSOxscNRAzmk2ySFf05tQGqKsc
	 BusVO1RhbN62g==
Message-ID: <7f6eb404-8139-4208-88eb-03ea8a4bf3a9@kernel.org>
Date: Wed, 23 Sep 2026 13:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
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
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-12-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: bnk6obq9j6buwg9y313uftofi8han7kw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F15C840007
X-HE-Tag: 1790162434-477038
X-HE-Meta: U2FsdGVkX1+jtU859O78Q9fL5j7hIzfbJgmnNnBtn9CUzOvAJyou47peCqYJC9S7gmAOySduPkLz91k2kqkbp9hFOV+Rcf9NZ4JqhQLfRDlKxeSwROA6AsP8drI702wkrK1Gwn4hn79noeciAdL4rKxgJJGTKuGBWIVByFbG7r/luAhmSp4UYS5Yq01o9okkBBcG+TobjCV1T6ICUgVHwdGA8UCKqswWsTO8+LnC+pHXptWMLBwiN5zejrfxDMDT/z8DJAaKSfagy6iR0QyTQU2ZJfpKfdMbXnTLI7zEgF7pagIcGIhuMk38VG/PZTMW2PCkuZe5msPikcEUj2JjC9ENzqPI0A27CTsMmYarg5ooiq4/OCytLJBaur2JwXWXly2WJpedI0ToNHeHGcUgFN2lpt2JVHJ48uFdj+OFc9gh72Ax8sPlGGqVvO3YlfJOxNccMiI2apn7x0D/PK87eTXT3VY08+73ZCJZNvECa1KVkcsHBREGjL7vJ10ozSsepNdWcRWCSNUV9QOzrFdJjUk8lMYJjIF6iLc2asevyG5rKg2hAdkEeT9ThD6gS5iKqHMoJpoyoKSYQtd+V0CikK+oWK3MLAZ9u63n5ebKiODyxuAyU4G67MYTcFHZyIxMX5tL+vnJJe48+IB8cc/sN85jKMg24obVn+aJFYpXCdUJ/H8yZRtoSngeq/BfrW3nQqjILs5yafhjUywfxyORiWnTdzOEPuyCDpK4ly4GPzRz8hTczdHRqCuUI9FtRyv3WIinstRRCdr4cC5dNhq5oa6k5v2tr4WC4JqU0jJaZayCs0GwtSySDThcnv7zMtt5eVDT/U83UmknK2ils1/cmgjQli1bKtWaw7Sb4e5ctWuB9+QooGKrPmjonCDvGC7NBKxtKoDE1YYlbTcq8c60AAcVlN9aSZhsTLo+D4JjK7jOu6GZjHaIr5bkxI6e93kobLUM4X+bbHZQs8EEPnC
 eXXWUmGh
 EAZqUcGr5oFFnB4lU8NfodF4aDIwL5rxgB4rXzlE2sdgEPVWH+y91d1uWNAc7f5wx92z3RM3cvUvCnKNz1FYu1GYud/9R5IWFLVF9oWqr29sFmgb8E+Y170I8xzVcyrL/2Ud9kWc3jF7X1pW6zjwQ/TBxMLgbutU4rv9ALZWxTkA6N9fmkPDelyiaeM+ALHOzTLhAsTPyUxp6ydt3AOuz56tBIjgDmvQ+X8aXJZPinSvy+DHXTmbpwby6+/x32ulOLd/i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:28, Usama Arif wrote:
> Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
> or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
> handler - has to be able to split that entry too, or the callers that rely
> on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.
> 
> No reference counting is needed: a swap entry pins no folio, and swap_map
> is already one per slot, so the PTEs simply take over what the PMD held.
> 
> The migration-only entry point cannot reach the new branch, because
> page_vma_mapped_walk() never hands back a swap PMD for the folio being
> migrated. Warn if that ever changes, and force the regular split anyway,
> since the branch leaves folio and page uninitialised.
> 
> Test the pre-split old_pmd rather than re-reading *pmd in the trailing
> folio_remove_rmap_pmd() gate, so every entry-type test in the function
> interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
> leaves the PMD present as far as software is concerned.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 873887aed0bc2..0e347a545588c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>  						 vma, haddr, rmap_flags);
>  		}
> +	} else if (pmd_is_swap_entry(*pmd)) {
> +		/*
> +		 * A PMD swap entry has no page, so it cannot be turned into
> +		 * PTE migration entries.  page_vma_mapped_walk() never hands
> +		 * one back for the folio being migrated, so this should not
> +		 * happen; warn, but also force the regular split so that a
> +		 * broken invariant cannot make the code below dereference the
> +		 * uninitialised folio and page.

I disagree with the force (and the comment). We cannot make each and every
assertion that never happens (unless someone messes up real bad and would find
this during early testing) have recovery code.

The real bug would be calling split_pmd_to_migration_entries() with something
unexpected. See my reply to #10 where we bail out earlier


> +		 */
> +		VM_WARN_ON_ONCE(use_migration_entries);
> +		use_migration_entries = false;

Can we just have on the beginning of the function a check that
use_migration_entries is only ever set on present PMDs or device-private entries.

> +		old_pmd = *pmd;
> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
> +		uffd_wp = pmd_swp_uffd(old_pmd);
> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>  	} else {
>  		/*
>  		 * Up to this point the pmd is present and huge and userland has
> @@ -3440,6 +3455,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>  			set_pte_at(mm, addr, pte + i, entry);
>  		}
> +	} else if (pmd_is_swap_entry(old_pmd)) {
> +		const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
> +		pte_t pte_swp_entry;
> +		swp_entry_t entry;
> +
> +		for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
> +		     i++, addr += PAGE_SIZE) {

Just squeeze it into one line like the other instances.

> +			entry = swp_entry(swp_type(old_entry),
> +					  swp_offset(old_entry) + i);

Didn't we have a helper to advance by a delta? Ah, yes, pte_move_swp_offset().

I guess one could construct the initial pte and then advance one by one through
pte_move_swp_offset(). Won't remove a lot of code, though, so just a thought.

Apart from that LGTM.

-- 
Cheers,

David

