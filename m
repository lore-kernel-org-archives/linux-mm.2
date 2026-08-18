Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B80C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E512E6B018D; Tue, 18 Aug 2026 13:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27EE6B018E; Tue, 18 Aug 2026 13:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E746B018F; Tue, 18 Aug 2026 13:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A40EB6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:54:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EE41A2912
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:54:02 +0000 (UTC)
X-FDA: 85115138724.12.5D6989D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A1B680002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:54:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RN4Re/NH";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787075640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzLc+SgSrDwanlsIiH61oiwQSTL3CBqvRLkA4XxeRiE=;
	b=mH40bd42zzeLqxLbhR6hydtrUNUP2+ZeZI9/BcFFQhOc8cn7+VsXw18uX+jXvAqgCrCGee
	0iHjOo8RQ6wmjijFw4PeLdWW0C8wS8x87pr7vcBkrDFtRLyIc0neb2nFdrZsgWUBJa8a6s
	G0JjB0/h9LkpXqozG5QXtM5DcD4r3lE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787075640;
	b=Qhl4MmmUMgcBR+Cn6xRF6dFUv7fjnlCSFhi7HS+8XXCCvvoLOVFc6rLHh7Z2qTF9kyUTOw
	eve+MqlfU6sEs3D1qHyXLPt1aKG9JsDwO9eQ/DHHky4irfcOpEqYynT3SiqrvUmz2rYdSA
	Ss4IY/9UJiJJ+lNThHEhT/xNw5M8kBc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RN4Re/NH";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B1AA60204;
	Tue, 18 Aug 2026 17:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DDF1F000E9;
	Tue, 18 Aug 2026 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787075639;
	bh=lzLc+SgSrDwanlsIiH61oiwQSTL3CBqvRLkA4XxeRiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RN4Re/NHVv2E/E3x9qkdmHKOxcriA/ngvaff5mFAca3uHQQdnXZ3KFz8ig6E4qG8Z
	 fuGQ2/p3yPM7IKylCzVrIIXqLjtSj3j7ojAReEjpcbPEi5lXOX6F6yjOszTu/77Wp8
	 nYOK+idzU04CHUr6rYMopFvtTdqqP7LFCDJqc27eSE5nXlX0hE1STMVzrhLAg8j3V6
	 TN7JKM3sjAmuxXv4kfghW02vPY1ONgq49Zu4CWBF6D9xTLePW6a+jAB/kC0R0YomTb
	 owauZ4QlssR8+Rx8rQAzOlbBC5w2HJnhmb6ydZ5Zt3ztXWWcFjCy7UHNvtZD7BdpVa
	 SVeQkyL720tsw==
Message-ID: <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
Date: Tue, 18 Aug 2026 19:53:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
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
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818131202.494754-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yac7nsm59ptw5z4yqttoe1jyadfcgihm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A1B680002
X-HE-Tag: 1787075640-115557
X-HE-Meta: U2FsdGVkX19PsVv7OwJ2nIxtljw5G1u1Q/DH7JLUfliBW3WNB47/R/T4MnfyAf43PCHNmJ/K7RGXuV4cDEo47XjQLYURZnpaBjlYtuDOGSGFeLK+jyJfQcONidhmV2A773EKhzBXWM9vyjWiP3KNNCpxohD53MdbqWeK+S0HBzqei9VmgTV9m0aHd/s1+ldBkQQbAv80HXZrl9FeSK6DJROdclrTVHtRru+dtZezaBZAQoLfkyKiX7YfEjrBW25czNhnypfdoQRhWC6SP+G0L4o3Qj+T0jlyJ1AePduNlVC+AiRk7Z6n8+PXHmicK52oja/78l1y9OSv9dq+u1n1GDrVRNvfMgeoePWecdYED+cXwynhfRjQUOBFC3J7But2P3sQKII+ClC6AqXnMd3CWxev24VgJYEwHuInI287B+uUNiI4JYSkyX8qDnFETa1DjEsdka15Kc2B20YNp7yLgEI2NhnQ8WhdJKLwmTejAFdRIcZYWuee5COSmHmUz4x9uKQCpowyhI9izv6snGXomb56nWISCTe4kovqqoRkPT68nksWVs/628Dwse8hSdPkvLtpNf8/jBT7Pw57N0yFZ1Eify0jKkj4sDOFiFoJkW9K2jRW/AhjKjaQP1XtEgrDPOyEHAn+gfM9hRKrPC8yoeJWBLMYdNumLjEkxpJet9lyqt6ZGWlsoBI6YM4pdKt11hiOWt86O68redi4sad+4NzYWrBvWevJvUqBNuq4bJjPB8qOtRlOWrrzaI+Q5nEFMpuBwrq0otEzdagFdx1ndT3NvPqF9HKHAH92CUzEVFH+6eC+s1q1D4lxDcPUSrXRHJ8CMD/3sqUroL7C1BJtRb2otvtePFjMcCVI9omnesPEncit43+Clj9G8228MCeHqLhjyI2Be5uqjGKPZkWLsFSu7BwaQCRPZt/bZlGHMpO0lmlsSgGEXkHg3exSWBf0YcHdl/KohhmgCJeDqxo
 ZUx7BHyX
 BayNx5MD4DmHsiS5203MeigOmRzwKPu/UjgAdLQMWIRMBgGtPVI30Pi2GjwUHlX6ZzopIUVlix4UYPLeSj5VaBuMCsINBq1rTZ3W3uCOcqM5AIA4LheMGpPu7B9ABSgjOPhSc3Fn8qnkfmKBDww38qQOPfy8qR+M8blMRXFLJ0V+cXz9cVHEInvn4RFkXFqjH9tCklzC2HvJQurocYQ8lEjlDACNuPOwYHcIvr2VIcsX1Ds1Z98jIyj9qXqYnh0KPen6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:09, Usama Arif wrote:
> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
> entry into 512 PTE swap entries. No folio reference is needed because
> swap entries point to swap slots rather than pages. Each PTE inherits
> the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
> exclusive flags.
> 
> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
> rather than *pmd: for a present THP split, *pmd has already been
> cleared by pmdp_invalidate(), and that invalidated bit pattern can
> decode as a plausible swap entry.
> 
> This branch is reached from the explicit __split_huge_pmd() callers
> that hit a non-present PMD: partial-range mprotect / munmap, the
> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
> added in later patches when the cached folio is no longer PMD-sized.
> page_vma_mapped_walk() does not iterate PMD swap entries, so
> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
> and freeze=true cannot occur in this branch today.  page and folio
> are therefore left uninitialized in the swap branch; a
> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
> invariant before the freeze path dereferences page_to_pfn(page + i)
> or put_page(page).
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b6b0aa2baa3b..a473e85d30f51 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>  						 vma, haddr, rmap_flags);
>  		}
> +	} else if (pmd_is_swap_entry(*pmd)) {
> +		VM_WARN_ON_ONCE(freeze);
> +		/* Swap entries have no page for the migration freeze path. */
> +		freeze = false;

It's odd to VM_WARN_ON_ONCE() and then set freeze=false;

I'd just add the comment above the VM_WARN_ON_ONCE() and drop the =false.

freeze=true really only applies during page migration, where swap entries don't
apply.

I think it's time to clean that up ... that is

a) Expose a helper called split_pmd_to_migration_entries() that is only used by
code that installs migration entries.

b) Hide that "freeze" flag from all other file-external functions

c) Rename the boolean to "use_migration_entries"

Then it's rather clear in this code that this should never happen.



> +		old_pmd = *pmd;
> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
> +		uffd_wp = pmd_swp_uffd(old_pmd);
> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>  	} else {
>  		/*
>  		 * Up to this point the pmd is present and huge and userland has
> @@ -3388,6 +3396,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>  			set_pte_at(mm, addr, pte + i, entry);
>  		}
> +	} else if (pmd_is_swap_entry(old_pmd)) {
> +		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);

No existing code uses "sl_entry". Maybe just call it "pmd_swp_entry"/"swp_entry"
and below "pte_swp_entry".



Apart from that nothing jumped at me :)

-- 
Cheers,

David

