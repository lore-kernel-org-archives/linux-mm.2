Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BC9606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LsFyja9g
Received: by kanga.kvack.org (Postfix)
	id 75CE56B0B09; Wed, 25 Nov 2026 17:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734A96B0B0B; Wed, 25 Nov 2026 17:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AC36B0B0C; Wed, 25 Nov 2026 17:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF8726B0B09
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:36:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D007C0113
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:40 +0000 (UTC)
X-FDA: 85475102160.09.307C402
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4A72120003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LsFyja9g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646198;
	b=sOnIce66Fq4FhcOFOl0TMf7sTIRwuC6CSE7mYBeb6SeZsIkJzKYk+l0V6b8Fe63zGm08Ii
	y5k4AuqtegLb2EfAOF/zp2pTaCuym/sSf62+N04vS62VRpy9XDncqYZT8G5QvrsNlhg4h9
	ree9yicU7PIqdhCUbg0xAUoM5+vZpE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwSb8ZjkUHuvGDFbXZGeha4mv6LAPnKvJMHgWrsVdx8=;
	b=QghaJH+QMoE6u09NAhp/om0mUFVjb7Y4KWkFOThjQ50hbFLMS9ubC9U9Tc7x03O0A/Hwfe
	fOmOUVeh+6eYkNnyZ9sC5+e08/KAAtPobT9ICSONh7vnh38VUR7G7nW/QT1wRlWgErcs/n
	XIalyHoB+4xYhh8zmimFqRc32wWDeI4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LsFyja9g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F1D362C65;
	Wed, 25 Nov 2026 22:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E3D1F000D0;
	Wed, 25 Nov 2026 22:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646197;
	bh=PwSb8ZjkUHuvGDFbXZGeha4mv6LAPnKvJMHgWrsVdx8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LsFyja9g1bv8H1boRMMuNp6jOzLUv7I/HQCONg6bdcVTXtKXt0hWbPAPCBqq+636f
	 wpmzGssYGYCfNE55PJkegIlE3fZ7S5fgAtVLvV7wUQZSinn/0Dcl8POgWOBvV7Vj8r
	 vfM/39SE3MGC+SIZDTk5lozhHdydCcMpK8JHoG5tt5eav+T6zjCM/IbdYJWM85dt8v
	 Djur3cQavRY9p3Ycg5B3Lv4W2AJepogoix5qNxeNBMFeJw6x9uSfx75WN2ZjdSJ91n
	 2qShv516I7tzJl3OVCx990J+qKJUIKutrCbJsfQmybG/Elnb49/on60NR4yJJ2wipp
	 PDV8noFu7xbvQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:10 +0100
Subject: [PATCH 12/21] mm/hugetlb: don't share page tables of a VMA during
 mprotect()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-12-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3232; i=david@kernel.org;
 h=from:subject:message-id; bh=FAzuahks5m8VCo2oG3BmxZCgGWj6jmiJDPwksv+1liY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1RmHnlsfTaVz/nHkbywYONkmRqG0+3B3SsTs7ZfF
 X2TMjO8o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIm8DWH4nzzR10/y7sveo9JO
 n1ouJs28wfPd62HYHaH7J3/9/Hj7yAyGv5Kzel4ecP7yo/G4SX7DB4dXLx4eXp1k+Z9zpz/L3Pc
 3MlkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4A72120003
X-Stat-Signature: 8yquubwcw3f4y1yi5eqpofqzf4c7rake
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646198-259156
X-HE-Meta: U2FsdGVkX18+VUZY0XdTD3TqlEGdwVrAhvNueiSPXTNs/+xBK0OCA+XHURNycT/Jp/Tb8l6qi79cAEurix/CX8is8rAUq+f42pN+P5hFIt/mVzxFpCy9OF72hzapC49DDU3Ax44kdma5wDZ/rUVGrPKKZ5hnwk140WQiQkuWlrwYu+qn+f98EtCrxJGmDCtfEBPCXfVpg7DqlBm9oPzk+Z6KEmERfX9ZLT9w17ngkTF1oQ2H/L8RBUUcwGUYEIGm2zCagrhqEdQxoliTZNK6ZR9wKQ+YXJqE22EtTc8+8yKAUD++j2fCZ29IVChlc360Oo9WvEs6wDMddid87oVCR49oGbN/iMMC7It49Fb1y2mdRBQq52Pg0xMXotgLbqPM4NN84+u8ryNXgfaOpahwPUtuvJTiX0zOdSMGqO8uqfcVQAejsGJs6NtNjKy3PfSxWIJ2Apy2n+LEwojYUvHbkclyaenalt2hjBVCHcZgSuOFkTxqc0V5VHsDzytaXHfmysCx7mbsAlIgUOUB6OXSxJ5N4I5CQ7ssle0yvc5dsAzjPuFd+IX1PpelzA5tYn66GULJVtkalN7Qkvj70NsUlh1h6hjZTRNGiQUnQZlQJ4cfRmCCUUOfoelMx79D/diOftIA7bQfTpKwg09gJvk3/hns7RbaPi5PY+vQs95DvzWKvonhh1RcXwjmGf+SjS/jCuKxrclcBC0ucGkC2VwMB5AUENItW13xdrmaNVpVor9AFda+lYtFf460Qm0zvrtTqKgelbnBS0d3gIfYC+6Kzq0NB4HNeHh/zpMSwpW8H2k0PFELeUdDmRLw2Ezm8C/gK5HqAog4r6oe+q+S4mT3E40SglU9fOeYreBn4jVzoATWaMw4CjIy6uXT1d9g/c9onp1V+WM16nzqFD3Dbv+I58i45h28oSmG+3Jw1L9NqQiAOoPCqLdL1soeQ3onLo76Ggtkc97BCdJuqQFhY40
 mnVCsD5B
 mzxoHgQ7qHsNm57PrJ4H2WCCWm1D3NohT6DCxS0zyG49azvJkDLWWuoFU0twYZK+ZNqUVK77JfU48stCienOKVXE5ocUs7AlfqqfYLhYhOtkfGkTBZvAAyMZcnSAwqSjoNTTQ+nX4L1Osb7rD7AgzwOLw2R/dQ2AaPIpEsGgaa/4q2oCMbGfWBx8ckJ257fhjSv3QdIQAuPhnPklGWruhve3C6eSHgBoMmpMfbCGEr6D18tPmiUzdv14aeM3QK9GuklZZy44FQRVe3snaN4pVJX09CIOnwiFhWGCJy3OQlUuUYTpqyeeNDJhSKYOhxPpFQfYWHWqWsf355eXo0VfOdIJx3Igmg+5bx+kKFKmY19HEGwkWk/H/0zRgIgW/RGaHnTWvP82M7Zjd5Z1aJSRjT3jsKKi4LAzwHsTb1vhCzV4qAlSs0C5/5Y2fQiM6sFrdvR3OJrkvj8joSBFThngA2NgCE7X00WyUfWYODOPekhfzvbTt3iptn8UM4LLKhIYjX/3z8nTVYlxg8dRdcTB/5NxTSg3Pqt7QOKmY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When mprotect() of a shared hugetlb mapping races with a hugetlb fault
in another process that can share the same PMD table, we can end up with
page table entries that don't match the VMA flags, such as writable ones
in a PROT_READ mapping or PROT_NONE ones in accessible VMAs.

huge_pmd_share() takes i_mmap_rwsem and shares a PMD table if the flags
of the two VMAs match, so while that lock is held the entries in a
table have to match the flags of its VMA.

However, mprotect_fixup() stores the new flags without i_mmap_rwsem, and
only hugetlb_change_protection() takes it. A fault in between shares a
table that still has the old entries, and the walk then unshares the
table instead of changing them:

    process A                        process C
    VMA is RW, entries are RW        VMA is R, PUD is empty
    =========================        ======================
    mprotect_fixup()
      VMA flags = R
                                     huge_pmd_share()
                                       i_mmap_lock_read()
                                       flags match, take A's table
                                       i_mmap_unlock_read()
      hugetlb_change_protection()
        i_mmap_lock_write()
        huge_pmd_unshare()
          clear A's PUD, return 1
        skip the entries
                                     VMA is R, entries are RW

mprotect() changes both the flags and the entries while holding the
mmap lock in write mode.

Let's fix it by only sharing the page tables of another VMA if we can
try-read-lock the mmap lock of its mm. If the trylock fails, we simply
try the next VMA, or allocate our own page table.

A trylock is fine, as we hold i_mmap_rwsem, which is usually taken under
the mmap lock. We should use the VMA lock instead, but we'll do that
separately.

This has medium urgency, as it can result in endless page fault loops if
mprotect() races with PMD table sharing and we end up with PROT_NONE
entries in accessible VMAs. If the kernel accesses such memory, for
example in copy_to_user(), the loop happens in the kernel and the task
cannot be killed.

Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2c13349863bd8..0b0f6e17b8b06 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7264,15 +7264,23 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (svma == vma)
 			continue;
 
+		/*
+		 * Stabilize the svma flags, as mprotect() changes flags
+		 * before adjusting page tables.
+		 */
+		if (!mmap_read_trylock(svma->vm_mm))
+			continue;
+
 		saddr = page_table_shareable(svma, vma, addr, idx);
 		if (saddr) {
 			spte = hugetlb_walk(svma, saddr,
 					    vma_mmu_pagesize(svma));
-			if (spte) {
+			if (spte)
 				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
-				break;
-			}
 		}
+		mmap_read_unlock(svma->vm_mm);
+		if (spte)
+			break;
 	}
 
 	if (!spte)

-- 
2.56.1


