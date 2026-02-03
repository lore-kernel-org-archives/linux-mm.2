Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC78E8B367
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 22:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC94F6B0005; Tue,  3 Feb 2026 17:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76E36B0088; Tue,  3 Feb 2026 17:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B7A6B0089; Tue,  3 Feb 2026 17:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A34726B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:07:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08D581B1BF2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:07:31 +0000 (UTC)
X-FDA: 84404532702.22.8FFF35D
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E195140011
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:07:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgBFra7d;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770156449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOxus6Q+k+UFCDyHcbF/F78h7JC9Gdvh77//dMnEmMI=;
	b=WVN8j6LadO6BrIbbr1AnjirtDxXnlwJqRYOKLozO9UZ7dDJ1aMP7KSL4/a6RERIhc6Quga
	XX4Q/gGf7CLcwkYkXqDUwj4y0bZGRRQPkwgaMyIb7b++a9Ri38DKbj//xllHuhiIqMJ7Bd
	X/+Kg0Uj0p0Uy+uBtwNTspF4wtHiAGk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgBFra7d;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770156449; a=rsa-sha256;
	cv=none;
	b=Fve19GJaUBYZm3YHxKyQhXmoRo7qmINUsA/zqu5jEUVu8rS8OYv1dcgDNsz+4ghFvFcMMK
	11jrtAuiJjRYJ/iiXMVM/UcJyEv3RKQpR3leAIXY6NXZlqpFS2Z/UVALhK/1XazN5g60Up
	Z3ST9ZL9oPNpmHHtdClIKRJTItDgICg=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-124a95e592fso632095c88.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 14:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770156448; x=1770761248; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AOxus6Q+k+UFCDyHcbF/F78h7JC9Gdvh77//dMnEmMI=;
        b=KgBFra7dadN8jfvvTmj3PmZdbOgExEDdLB40r6Tgdbqf1v7j5wWqcA7eQ46DITnFzj
         +XSLuKSJCW4+a2sPu/TfbwOTuDxg8n8gcmxRDgkcDVAn5/JMgamifgWNzyWP0vzgNPIf
         7NTgepVv5meilNyJR4n/3RFGpubWQ6R/6tvlr5Ct8TeamHOCScuC32bKERvv+iOPj0N5
         lXVYgZaiGbGMfTCqwmDMwUWEijutn9g6ih3DVy6n2YPVt/fKUzGxoKZejSiYP5SKLfu6
         KIiSAoPw2cemKBdOfrfdpxZH5GHtjfEtIh2QmZX/0dh7vRdv3t0NikpKhRPKiXIIfjd4
         Nzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156448; x=1770761248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AOxus6Q+k+UFCDyHcbF/F78h7JC9Gdvh77//dMnEmMI=;
        b=B9NPQUfpHPe9dVu4d0jUOf5bYt00/QLBWTGNkoba8wS2nHx/pzPGXlqhw1lJ/bUbgo
         WX/Y3sjSw54/fKH4rpmf+2p4niCyXTJtElfiMszrSHy6i9Kx/AaqjJQgOKvNH9InUT36
         IEpoCZd/xxEB7mgywhE0owG5L0ZSa2tApujh61pRpUjLx89eGSdO/5jq91YoJvXGbEgC
         hn3rh4ogvSFiWCNnabMtWrqAzDBetgpTTWHEzntvuRAhYtcFtUTrItHXPE79M+8MJj4/
         rUS72+mlpWFRXjYnk247LEqQLecnADYDzEJLetDs/YqZNo6kBPkTlKtZ7rmJjQ/iGj0W
         au0g==
X-Forwarded-Encrypted: i=1; AJvYcCW/7H++gZZv49GmnqZg0UhmDdpD0d8KYULjTAiezrXQVeCvU0glOFqRDEfr64KsaSMpge2xsgvOTw==@kvack.org
X-Gm-Message-State: AOJu0Ywr9HRdA3CMRZjjpUG+heCGDpCslok58okEY3OgKm5QPoD3/kRc
	Qq9GjXzGQ7gjCpxEjhxkAEBjVXktGjFuBWmAATGk2g7/98MRmnj8PXAR
X-Gm-Gg: AZuq6aIs+kVEx1wIGq9p+ioMBwqeudRmEBa/Uyf16vm0EMcjmuHoDyTGhK6CrehKCYH
	tHFZBAQrnZxwBDxYtDOEZ8Boq4643pkdkBLBajKYsAKYJWzegrC7JcdnqXcf8A8PtwNTZiz2PwW
	8Ext2G0t0oYNmd6NHJN65SrnAt4R+6QiumbBFN92VfW6OYXdyRTZal5IhBGhYJA6jSzPB2rgXXO
	fBndLzx9kVEfLc7X6K+rhKQH9xfdpfz0VrFav0cEZAs2hmVqIhS/ybkEW8NRIasp+sEGjK0zgnT
	o+Co7sFJwfS/1jRSL+jVD921rlNgiLYSYvzGlTy2616PHyVQDejdwByZOEyKocGAEbuTYa7fxJW
	JfokN6YKQKBhhN6GxFCf6aDsEfzme5RDn0KBL3lfrhhiNAQ9nO/xKivx89cAP2Y29/fs0OC6Iru
	4nNOkFBmMlH85MQvVRp9Cytfz1U6vXF2214ml9QJ4RzsALWJZUaFH8uMgwLHg8U18=
X-Received: by 2002:a05:7022:6b9b:b0:119:e569:fbb2 with SMTP id a92af1059eb24-126f47cfbe2mr536040c88.33.1770156447603;
        Tue, 03 Feb 2026 14:07:27 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::21b0])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503d0fbsm454159c88.13.2026.02.03.14.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 14:07:27 -0800 (PST)
Message-ID: <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
Date: Tue, 3 Feb 2026 14:07:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 lorenzo.stoakes@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E195140011
X-Stat-Signature: qjf6ea9ba43u6fz3iw9c7snzu8oqmz5o
X-Rspam-User: 
X-HE-Tag: 1770156448-604660
X-HE-Meta: U2FsdGVkX1/H+DaBs/FJA5Qz8sTHnT449s0YYTa+8H+f277D1p0uT2RFlO+ArBEU81264WPQPE6chaa0F8U7XGgd24bIc0707NMEHCvDtYTDZOvNmYm9Si6g/ptAlnjXo9ZxONpl7VrBvmzYMXOOhIFzqBlWEpkos7kkQ2ZWxdXGaXMbm92Wq8dqTZ007PFF/SsOnOmf7yAF0isjFDoQcOvKE3i3nX95M+Rr5GMLWZR8i/bNiEy6g1g52xnTOCTqFiEW4LHHPzGRTVLOnH8umUAsg2pAsGA/ULBqci4OiJYD0E1woo0K7qydzSS4GN2LI+Ty7xiwtz8Zjgc9KBvrPG/VcmhvFBH9v7mnyZ2focRM5A+nTNlmEtTxDsJmbaaRT0AfR3+TIX9ac34LyOOUvRbap0vRfco2S+OThIufrSapZNrgS/PULHhrv9g/Q7wwcR5JNHdJD/K+E2i52yHR4VNWtX5J5DuefeaSj2UObL2yXj4Mmq7O50bk2yTGXjpdEz+qhnHchpnm+F5P/9crKKttqfXs1c9dYT4x75AAvmN8WdpDUR9Ywfy5C0FTzvazNyEYSRsTwpnf+0wKw80sjX5Bbu6aYjPw0GygUPa9hCMEno3LliRbQ8YHkI2BRKG54hkghAxLJhy5NBNjQnfU8CkrrBvJRgj5GGJ4QX1RPp+pw19ytmGt3TBeFUff7/Xelte99Pniy710XGwkSH4G93K5Qnvtqx3eSatTiMGhMYjBjoYLLBppyfMks+vwkfFfzZRxN3yR5yZnetVm2ujgq/9jBta237RbW6nNtEQQYDiqEDipL+4pzmyRS5gWwkt+TuqcDYI8PyrjNpJIiC4PLOFN+jdRqv3dVmoFtWNMyw4tfy1fIkFcUD7X/8QKq5glgKuYfEO6Uv313xpVIcD+ic6Zv82/AIYKXCtDuccuKjxa6/DhPiKZ1jiFpJgBuDurtkR/Y2X53658Y/ACGpW
 Cs8NT4Jm
 MNRJs14rEyqi6IGkyvFA7VknpAIRab5J31IbgWMBGwUR5ea3aO0sPBVMG/TSfHP1jV4bGHgh4moukaNYEFGp52hXMzL1Sd7t+RqnQBbdJldT1i/YkKLD7zijPMzNeBFMrrlfJIJ+m4W1/vi273BURstn5E0QKMpX1n1khD72aLtuFOgAk5DE5V8FJDJyDK7FopprNxLTVJvFTiKj067dtf3sA8MIx6jkDZsqD+h91LwhWlYrahlRoJyA9Mvp4MWQc+lBkNUOVg9o/ctg4XRf4+fEaIPkh+vBQUrCoeHRR01FxerhQko+fNC0fFG8aaeN+08Vz2nWYnr0P8BgDFNZ8XxPkrUQLtLGOgfnyb9smlZazQ8dXVpKwq8x0JjFdfNaLox5ORPL19BRaUbWBXtR6sjDWk72XO8vnbc5L4mNLqvx9wmSXSrJyo2qEwsAGTSliRaOZGa5Cz8Pk7kolDmLEbOGIEInKB4trINgPNDXt4CoP+gg2ByAaxPqLQHSYFO3U33AkJAfE186rEC3o5q6uORr+udlRdbfRhPOIfvBAijav1lM+cM8TAECx1AJLq719lu/mhFj/dv4nW8WHEvIq2A3/OC27raRLkkJcKnxbx1/ZgKTRyIs68+wblCG6piSyjHa7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 08:01, Zi Yan wrote:
> On 2 Feb 2026, at 5:44, Kiryl Shutsemau wrote:
> 
>> On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
>>> For page table management, PUD THPs need to pre-deposit page tables
>>> that will be used when the huge page is later split. When a PUD THP
>>> is allocated, we cannot know in advance when or why it might need to
>>> be split (COW, partial unmap, reclaim), but we need page tables ready
>>> for that eventuality. Similar to how PMD THPs deposit a single PTE
>>> table, PUD THPs deposit a PMD table which itself contains deposited
>>> PTE tables - a two-level deposit. This commit adds the deposit/withdraw
>>> infrastructure and a new pud_huge_pmd field in ptdesc to store the
>>> deposited PMD.
>>>
>>> The deposited PMD tables are stored as a singly-linked stack using only
>>> page->lru.next as the link pointer. A doubly-linked list using the
>>> standard list_head mechanism would cause memory corruption: list_del()
>>> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
>>> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
>>> tables have their own deposited PTE tables stored in pmd_huge_pte,
>>> poisoning lru.prev would corrupt the PTE table list and cause crashes
>>> when withdrawing PTE tables during split. PMD THPs don't have this
>>> problem because their deposited PTE tables don't have sub-deposits.
>>> Using only lru.next avoids the overlap entirely.
>>>
>>> For reverse mapping, PUD THPs need the same rmap support that PMD THPs
>>> have. The page_vma_mapped_walk() function is extended to recognize and
>>> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
>>> flag tells the unmap path to split PUD THPs before proceeding, since
>>> there is no PUD-level migration entry format - the split converts the
>>> single PUD mapping into individual PTE mappings that can be migrated
>>> or swapped normally.
>>>
>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>> ---
>>>  include/linux/huge_mm.h  |  5 +++
>>>  include/linux/mm.h       | 19 ++++++++
>>>  include/linux/mm_types.h |  5 ++-
>>>  include/linux/pgtable.h  |  8 ++++
>>>  include/linux/rmap.h     |  7 ++-
>>>  mm/huge_memory.c         |  8 ++++
>>>  mm/internal.h            |  3 ++
>>>  mm/page_vma_mapped.c     | 35 +++++++++++++++
>>>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
>>>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
>>>  10 files changed, 260 insertions(+), 9 deletions(-)
>>>
> 
> <snip>
> 
>>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>>> index d3aec7a9926ad..2047558ddcd79 100644
>>> --- a/mm/pgtable-generic.c
>>> +++ b/mm/pgtable-generic.c
>>> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
>>>  }
>>>  #endif
>>>
>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>> +/*
>>> + * Deposit page tables for PUD THP.
>>> + * Called with PUD lock held. Stores PMD tables in a singly-linked stack
>>> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
>>> + *
>>> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
>>> + * list_head. This is because lru.prev (offset 16) overlaps with
>>> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
>>> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.
>>
>> This is ugly.
>>
>> Sounds like you want to use llist_node/head instead of list_head for this.
>>
>> You might able to avoid taking the lock in some cases. Note that
>> pud_lockptr() is mm->page_table_lock as of now.
> 
> I agree. I used llist_node/head in my implementation[1] and it works.
> I have an illustration at[2] to show the concept. Feel free to reuse the code.
> 
> 
> [1] https://lore.kernel.org/all/20200928193428.GB30994@casper.infradead.org/
> [2] https://normal.zone/blog/2021-01-04-linux-1gb-thp-2/#new-mechanism
> 
> Best Regards,
> Yan, Zi



Ah I should have looked at your patches more! I started working by just using lru
and was using list_add/list_del which was ofcourse corrupting the list and took me
way more time than I would like to admit to debug what was going on! The diagrams
in your 2nd link are really useful. I ended up drawing by hand those to debug
the corruption issue. I will point to that link in the next series :) 

How about something like the below diff over this patch? (Not included the comment
changes that I will make everywhere)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 26a38490ae2e1..3653e24ce97d7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -99,6 +99,9 @@ struct page {
                                struct list_head buddy_list;
                                struct list_head pcp_list;
                                struct llist_node pcp_llist;
+
+                               /* PMD pagetable deposit head */
+                               struct llist_node pgtable_deposit_head;
                        };
                        struct address_space *mapping;
                        union {
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 2047558ddcd79..764f14d0afcbb 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -215,9 +215,7 @@ void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
 
        assert_spin_locked(pud_lockptr(mm, pudp));
 
-       /* Push onto stack using only lru.next as the link */
-       pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);
-       pud_huge_pmd(pudp) = pmd_page;
+       llist_add(&pmd_page->pgtable_deposit_head, (struct llist_head *)&pud_huge_pmd(pudp));
 }
 
 /*
@@ -227,16 +225,16 @@ void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
  */
 pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
 {
+       struct llist_node *node;
        pgtable_t pmd_page;
 
        assert_spin_locked(pud_lockptr(mm, pudp));
 
-       pmd_page = pud_huge_pmd(pudp);
-       if (!pmd_page)
+       node = llist_del_first((struct llist_head *)&pud_huge_pmd(pudp));
+       if (!node)
                return NULL;
 
-       /* Pop from stack - lru.next points to next PMD page (or NULL) */
-       pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;
+       pmd_page = llist_entry(node, struct page, pgtable_deposit_head);
 
        return page_address(pmd_page);
 }

 Also, Zi is it ok if I add your Co-developed by on this patch in future revisions?
 I didn't want to do that without your explicit approval.


