Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18139606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kck3KUj7
Received: by kanga.kvack.org (Postfix)
	id 16FAE6B0B19; Wed, 25 Nov 2026 17:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146B26B0B1B; Wed, 25 Nov 2026 17:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E766B0B1C; Wed, 25 Nov 2026 17:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE1526B0B19
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:38:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E5191A014D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:50 +0000 (UTC)
X-FDA: 85475107620.15.29D2110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD913160007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kck3KUj7;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646328;
	b=FKkCm67bhRvA5OsbTBRyQ6hhV2jMOZ0jJRloOcGt+iKTHNZlkKVP7T4EG0fdrA8F6nfeDx
	AHToE0ra3EhQoug5tYzIFwMgkwEIT6yDqMR1CX1Tsb9RE6488kri7cuTKODFKtzAVF/ZQu
	VRTyiMCK/2e4+4b0ncYB38WOls8XmUg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmPaow3aRP/mBzNF7NAqWx/in1rPd5GnDvZIz10/EGU=;
	b=eNCLPNv2UqVyOJSHLon4c2zDAdF8tdYbmFS/1vbjJDWphzhdtZ9bIgxs7+RXxXnLcz6WAd
	95P4qPVQJX9GQRg3/liDkhpm7NA0m0PDcHPDUFk/BOM6kp/ljFs8cRy/zuT2E1f2uBOwqz
	HzNVt9soUhe4vRMQqFgMay0ZD6iigGw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kck3KUj7;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB01845D40;
	Wed, 25 Nov 2026 22:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E8C1F000D3;
	Wed, 25 Nov 2026 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646327;
	bh=ZmPaow3aRP/mBzNF7NAqWx/in1rPd5GnDvZIz10/EGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kck3KUj7vJS4ZeVNP5dth6KmT6gHDA25j5pi/Mlm4lHVub4QENyWtu123HUcGJWaD
	 Rl6cPbRSDWHJCcycyuMKnF4PaRpPvlsIUUhXGf/Gh90zai+FSgpndNMnhJP2fTLqCV
	 30XnFvrgW6Smdi/oGKIwqz3HFc7kYoNdReVHbuczICq1mspWkfyZTYRfpXxKPB1Ab3
	 gpitjL32298LymauPpHqMHGOH/zRByjab2cGejKPvzWIEsQO5lr0Wk2Oyy4SaVoJoB
	 6h4XMJpK6crskYi7uiSaVNQOctaPhIZt/qfokW4aMQtFSwY+1C8qE0ckCGwkMuUbb4
	 KVOy3psWBLEuw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:18 +0100
Subject: [PATCH 20/21] mm/hugetlb: resolve protnone faults without a uffd
 bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-20-db27fd2f71a8@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3028; i=david@kernel.org;
 h=from:subject:message-id; bh=/N0SQCShJZSXpsEEatww5OmscpGwDY5DnTCpFLl2oKQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1QN963jEHB2n7Sa7WjQu0+lOg1aGf3GChsnFpWzW
 ry68OxMRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABN5LMvwh/cbf+TE7e+lM5Mb
 OBaW36+NmLE8cUPd9RlJ2wN+rtdoK2P4ZxqRv/iiWtJuQ5GsuSZnLs51Xmv5o+DE9qJ7C4NPJdn
 M4QYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD913160007
X-Stat-Signature: 1c4zhjkspd5pr3w9gmhuy4qic3sgwr3m
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646328-196738
X-HE-Meta: U2FsdGVkX1/m/Mo5RlpD/01+kHRVpIrLEDcA5w9VyT7hLyi4nrDmBMd9wURUdBrzQ9p7sUbxnZUrw19ke2F/Mv6qbdQjsYmrnCmq8QUN7mBTkZAmKIu2c5JGKXbzXeAc0Oi6h7viGQFULkiS6071Eh0pGHqG0Eo62mjR/bPNOdEXcVQI+ulQ7obYiNC6v6X3yu6yy+/OokLLwYb5b8mBnG9mQGNuOOVrgKtGuv4S9JmeSZ1BJN9gaGw0hwcLarv8/O/SNMIQKyLe+UGZKtKCGb5bE+5fv0lIy3v53IsEkHMbxZWqMvgaNOhIRXyU6av43K8DqViC5YBQjyfzrz+uUeOM0/nlByZskFhflzTo8y0HXVZnAu1KAqklRrdlNcg4WyXyloAq+i+BbC/9TT0f4NUXiHzIjRTrve+L2g0G85r34IUQH3+LVMYN2mC16MruzTZRAE+dscVGvkfwV45sNKNuEA5qYS6EegwnC/xRZ19k/9qhUrV7rdm0JYWfbtagV/nIe7P42N1/hW7zAifLw5IbiwOWDwdYk4lES2BU2k2IKShZKgc/9z/43AEL1lPtTPgEzLlQ7V43fKiy6B2hzSUaM4QDI7Z/0l94Y9V2nri3C7nmBIoJp653hnQSibxNuGBSf/82AuFxePtkHVa0pNFQR/fiTAeHw5QZnoe7GA25B75Oi1ve5wmszI6zsrfb3qxUPXQBesjnGt3WDhQh7G1e9zSNJkBJ2Q+9DH2m6yZaeFesblHvlifegDBO1BReBEfB870xClpC58Clw4cqyG2KeuWK1Wo8YgybvlKWmHMYshengY++TElKXQbHPDz1DOC71pru33wmX/RrAe5QdQcbZEGvXFaVV1dmKeqdAow8IL1T5eWEOwXB146UjRJ8fKLaosGLNPsVK8DnvuLJzlXzXFD2Ro0eLCEJb63NQTVRTCXJvC1ulrEUfpYygDKlyZhUEv0wyJPKt3cTs4B
 BA14SD2S
 RDdyjyDejRmsoPBfm7rZlc8IbDcMihm4etg44cDaPigfh211xIwe+8hyKc/u0xHaphTa09+B4CVokEIxaK9SnoAqcQaiJb1mzoXEE5F5WjCxeSLuwD6WXWZfq0neY95U2mwKxwZj+BS2KnJk1Mnu54vHo2o/+fEpnx5idyM9ymoGqyy0BlYHRmpRyXrx8HB3KIpzcqobG0s9YUF+dAEy1+b/fzKqd52Dj061Wv9JroYfoH+UzD+64JUbIbqcaqJPoMpICRUPasf33CF0tj0f56exFkDpXkaaMbz/iBOIJHQ/sKbNYoc8EynrQbqGYksxc7pskhH1k/I8IcxkayjMMAg8Tq/3osU4BtwMJvioDYi50895cBwkcXhvgYhJuZk0322mIN/tB6jthDWPuptp7iSaScKq9lLx81333BVj+nB+PwyMYE7m8YZkbHQ418vGx5nOwCdpelhU2uXmoMZavSMVJ1XotzA2yReSWhLMy8cbEeGNaEy/rjtYwCDOzfIytc+lWWUxOCkRXi9S8zEDhkjiOvmjKs+HVWuERTBmsRXpp4pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

hugetlb_fault() only restores the protection of protnone entries that
have the uffd bit set, assuming that accessible VMAs cannot have other
protnone entries. If such an entry existed nevertheless, any access to
it would result in an endless fault loop.

We are not aware of a way to trigger this: paths that drop the uffd bit
(fork(), mremap(), unregistering) restore the protection, and
remove_migration_pte() only drops the uffd bit for writable migration
entries, which cannot be created from protnone entries.

Let's be defensive and make any protnone entry in an accessible VMA
accessible again, unless it is an RWP fault that has to be reported to
user space, like do_numa_page() does for small folios.

Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comments and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 62ed8d9aeeadd..438263c2ba3d9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6355,32 +6355,33 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/*
-	 * Protnone hugetlb PTEs with the uffd bit are used by
-	 * userfaultfd RWP for access tracking. Plain PROT_NONE (without the
-	 * marker) is not an RWP fault and is not expected on hugetlb (no
-	 * NUMA hinting), so let normal hugetlb fault handling proceed.
+	 * Protnone hugetlb PTEs with the uffd bit are used by userfaultfd RWP
+	 * for access tracking. Without the bit there is nothing to report, so
+	 * just make the PTE accessible.
 	 */
-	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
-	    huge_pte_uffd(vmf.orig_pte)) {
+	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma)) {
 		spinlock_t *ptl;
 		pte_t pte;
 
 		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
-		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
+		if (huge_pte_uffd(vmf.orig_pte) && userfaultfd_rwp(vma) &&
+		    !userfaultfd_rwp_async(vma))
 			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
 
 		ptl = huge_pte_lock(h, mm, vmf.pte);
 		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
-		/*
-		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
-		 * are no longer registered with uffd.
-		 */
-		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+		if (pte_same(pte, vmf.orig_pte)) {
 			unsigned int shift = huge_page_shift(h);
 
 			pte = huge_pte_modify(pte, vma->vm_page_prot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			/*
+			 * huge_pte_modify() preserves _PAGE_UFFD; drop it on
+			 * resolution.
+			 *
+			 * TODO: fix all cases where uffd PTE bits remain in VMAs
+			 * that are no longer registered with uffd.
+			 */
 			pte = huge_pte_clear_uffd(pte);
 			pte = pte_mkyoung(pte);
 			/*

-- 
2.56.1


