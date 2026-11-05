Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CE5606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nCBJ4Wja
Received: by kanga.kvack.org (Postfix)
	id D34186B05B8; Thu,  5 Nov 2026 12:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECC56B05BA; Thu,  5 Nov 2026 12:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3C76B05BC; Thu,  5 Nov 2026 12:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9313C6B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:07:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E15E80B8E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:07:04 +0000 (UTC)
X-FDA: 85401695568.23.8D3251D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9286180004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:07:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCBJ4Wja;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BKEtapVg9ZvVExUrrwjchlBg9HiJLaq+cPGzmG6490=;
	b=PEvrRn7VwomOuNZri6IRcwS1JQVjxpa/aT027S0F8G5rkgr5VDcYTEZfIoG19iH8JH8HVO
	KFniNorwcii0jOSG8HIc+v13LdJVCmF5Ytx02JTrz7Loa4WWgCuo8zbD20uBfNfs9o/JIe
	aRGwwUwJtbyn2nEWGf69dXDiSm4sbbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898422;
	b=8HiTn0tFYiMerC1kEcaVG0G5qG4P692E568r8wRfgZzN6AfZjP0BEwjBHNcM8Y3Ta+Mh3R
	QrkD9g1Ft5DAH9dC6q6REKX0F99NL/Wl1rl0PGjhVPMleukTyLBD/quXitDFds63Xo6GJM
	+AfHQ7vJLmoU8Bz67yHRL11We24urbs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCBJ4Wja;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E2A860145;
	Thu,  5 Nov 2026 17:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36961F000C1;
	Thu,  5 Nov 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898420;
	bh=+BKEtapVg9ZvVExUrrwjchlBg9HiJLaq+cPGzmG6490=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nCBJ4WjaV9h7VqVSkn+QKi1XYE0fRlYAYNMppPShoj71GS4tfxkkkZwdzDtxKAKKl
	 r0jtdIYZA2tq51uKkJAA13EqrgdCxvdUluOASXfXnfu1CRG2qZr5IuDwogdQzQNzQA
	 y6zVuI1EE+wXeR4KVNis97tkbm05Kqpcp0c0e0xgJKQp9WypE2FyKaaISltCHvtAMI
	 DJvnfFo2MpFIgEuBmbVBX/x0EEgTAANTpwoQC+6dN5AQS7FlQ6udIY0JtXubxV//jH
	 E13rtGeBQqTBb5vbueganPKWeP54WeJDqCuNi19/YwwAadmoojigQ0slNYvhOOnCwB
	 B/Y4ZkDZEcZyw==
Message-ID: <60c4f0a0-e3c9-42dc-b2e0-0860ab6e30f0@kernel.org>
Date: Thu, 5 Nov 2026 18:06:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] mm/mprotect: keep writable entries writable on
 permission upgrades
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
 <20261105165004.2663799-9-clopez@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105165004.2663799-9-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ik1aum7iah6hegudg1ofd1rqpnxy1kcg
X-Rspamd-Queue-Id: E9286180004
X-Rspam-User: 
X-HE-Tag: 1793898421-995520
X-HE-Meta: U2FsdGVkX19HG/zOLa+6/KWMt43RXjk+b6ULhVWq3IEsyoYX/NzKE7S5+WAb1X4ZQBr+nXtO12jGZIh3ZHL7deKYh3FvNOhpkFMaEb8MZzdZ75UJH2dBADyw17Ok2dpA6i72b9GA94tJJ7iEHUG9YSWYTTOb7Lya0oC2wWfrgYJI0ktR+mfVl711IViVBhBwdW0advSXTlpedN0pZd0neWn2GLD10gjRjt7EAJeA0+C29aVb5AIYE9yfSufNJKjslSFt6+88cWEOYm2M4YMHcMFZ45aJxZn3v8NXKu5U50Qy7Sd3l/TGSaR9IYzdYvU9xE4tDhhf70lwYiClWXar0pkscsHZp9NajEk3Np/H4ErZNIrZnIW14S+GkbEsEuB3PqgqCzAtG1jUeK4mHaBcVZrJyj152OLG+YXIZ/N6pu/dz5yCcJWJ309fGm6ATySdlhCKzzeyFbd3sfayYfVsJhU/XQnev1S/iRc7CXPGSn7A3Ly6Q7lx/OKhLxfyd2or4E9tAHG35ZOjzqevxUTXNTZRnYKz6lOO4jSepHy3TZzqar2pdL9rjR/kwszzPhDwLw6By6vutkNoMN9OhOyXSlSoh9Ds3+xnTHMJY2EHc7AyHghTKK73UaKpNlZH+Oo6G2Ib45HjJaDP0I+Zkgroo6qs/6+CDuuNqSA30DuVPcs83QeZfMZLh5pLyXmHvNACvYzD0qizFMqcP+Rip4JVBM0xKxBwRyu9KMM212KbsbQ3Be5qFl89NQSYxit2KaL5aheGOP03VX7sG0ibRp1R36uN2qsM4p7ZSPHPNOTgy9gpEpPhdW8a1r2iHNBmFJRqMYFEB8pz09kUp1AlHbuYDqOT7NaxngM41n5q0Igvt3Wuh4S3xut9emLZW7T+Q6XzXrHlBlKtDrkUkOzKqraN+mFjw3AkhwMYMiiU9RLIOzDglqmIWqd4eN5zaMF5vj9qBHF9Sv+slsp1bS6jm8O
 VybSQrNs
 xIOFjTuKQZEBggB1kJtSYNp6OHBWq4+pEmwtXquK731YUzQOPWCAf8BBssJi3bHmlztHKOPE9l75JQfhvMk8rUhSTZCrPZLC4xXjNrodgMhekX8suWgLCSwVaSqx40N66nNofeKszPT0WL/VNLommWS6wcBcjIsKa+63l0qf5MJQmS12MPHbQxtlhIMC+iQlOF/xvDgXKY2w13FMW5y2aEQWbgWJSw35rjbVgn1IpT5OdbLL+PlUTH7Ccf+eGBkrfu53TQYnXpVSTVGMfcDzIKMM8HfjaRXCZV2ps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 17:50, Carlos López wrote:
> change_protection() applies vma->vm_page_prot, which lacks the write bit
> for CoW and write-notified mappings, so it write-protects every entry
> in them. When an entry would simply be made writable on fault without
> further checks (e.g. dirty PTEs in shared mappings, exclusive anonymous
> pages), MM_CP_TRY_CHANGE_WRITABLE makes the entry writable again to
> avoid the future fault.
> 
> However, writable entries in shared mappings that are not dirty still
> become read-only. For example, a uffd-wp unprotect makes clean shmem
> PTEs read-only even if they were never write-protected, e.g. when they
> were mapped by a read fault before uffd-wp was registered. The next
> write to each of them causes a fault that only restores the write bit.
> 
> Now that MM_CP_PERM_UPGRADE indicates whether mprotect() only adds
> permissions, change_protection() can tell, together with the
> userfaultfd unprotect flags, when a change revokes no access. Keep
> writable entries writable in these cases, at the PTE, PMD and PUD
> levels. This is consistent with the write fault handler, as an entry
> that is already writable needs no write fault.
> 
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
>  mm/huge_memory.c | 7 +++++++
>  mm/internal.h    | 7 +++++++
>  mm/mprotect.c    | 4 ++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 506e1e61c0fd..6e23d0e4ae66 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2809,6 +2809,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
>  		entry = pmd_modify(entry, PAGE_NONE);
>  
> +	/* See change_present_ptes(). */
> +	if (mm_cp_is_perm_upgrade(cp_flags) && pmd_write(oldpmd))
> +		entry = pmd_mkwrite(entry, vma);
> +
>  	/* See change_pte_range(). */
>  	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
>  	    can_change_pmd_writable(vma, addr, entry))
> @@ -2885,6 +2889,9 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	 */
>  	oldpud = pudp_invalidate(vma, addr, pudp);
>  	entry = pud_modify(oldpud, newprot);
> +	/* See change_present_ptes(). */
> +	if (mm_cp_is_perm_upgrade(cp_flags) && pud_write(oldpud))
> +		entry = pud_mkwrite(entry);

That looks completely hacked on. We do have can_change_pud_writable() below to
make such decisions.

Whaatever you propose here is either wrong or way too shaky, sorry.

-- 
Cheers,

David

