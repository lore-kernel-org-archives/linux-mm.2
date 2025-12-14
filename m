Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABA9D3E787
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 06:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0556B0005; Sun, 14 Dec 2025 01:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69306B0007; Sun, 14 Dec 2025 01:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909906B0008; Sun, 14 Dec 2025 01:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76BFE6B0005
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 01:56:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D10F45BC58
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 06:56:13 +0000 (UTC)
X-FDA: 84217167426.10.9246014
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 458C740004
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 06:56:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ROIjs9qu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of alexs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alexs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765695372; a=rsa-sha256;
	cv=none;
	b=e+/S4Y510lXh2oRHkuYadXC9KefPWtt2eT2nbyrCs5LIOgXl7BobnRbaXiqfow3nLQNxX/
	FiADMyUX+ZaSj0y1YCZmO4kuy0pLZW9YtMfb8P9V973rZ8S5KkTci+zQO5ikNNixfc2v3J
	mHeGUgTk1cU9RrrIjkjJTrWMCfMK/oo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ROIjs9qu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of alexs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alexs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765695372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cp/dw4IQXDPolyDcMd7d3wHYF+iUcd5titFFJTQcVnU=;
	b=4nNBODTK0SQM8iGsPprHT8kbcdTg/ubWfMvTF6CrT/H9KzyjYdjWrTM1hEiurNWRRyD0ii
	/MYjqXhARxS5pwL8M7c/4bKIcszXXumMU+zlsH38XGJXdO8HjOYGoqNS/QfEEdnXju2Tsx
	tPLzmI0U2MaC6G4r1xd/peRLwE4gCYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F21D46016D;
	Sun, 14 Dec 2025 06:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B442C4CEF1;
	Sun, 14 Dec 2025 06:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765695370;
	bh=bw5B5LZunN+LD9V0kxZG0WgGS7BNiOM403s4yqcOcrY=;
	h=From:To:Cc:Subject:Date:From;
	b=ROIjs9quRzpkNc9eKLOQOrTmJASd5NEf0YjO6XxcxPSXuDjg3p+rNHRYrfCILrIbg
	 ddr6PGzYcD+qMG3uRh7qDlPjDi9SSZq0yGV05Hc4RNbmg22R0srpU6ys2bFvBcXIJh
	 5cTLEiOuxyzS+BGT+yGDTtmlAOY9MIJi+MAeR+s4bFnbttwG45rywrz5gGBwLZ6NUu
	 nFNcwBcFqTfSOfl055USsn4aYE14lRrPVOjrYMIdULDqKAbjXdzXWFmop1j4eNp6ly
	 Ye02mdr313RqD4cuo0sUKuKTz1j52MgF4G/rSWbAcxgnh0Yq56gakWvkGXyeYkPM4b
	 +zJNIrVW3XWKw==
From: alexs@kernel.org
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org
Cc: Alex Shi <alexs@kernel.org>
Subject: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
Date: Sun, 14 Dec 2025 14:55:45 +0800
Message-ID: <20251214065546.156209-1-alexs@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 458C740004
X-Rspamd-Server: rspam03
X-Stat-Signature: beq7bjnib45iqtpo4pdme17uf7hi1ap6
X-Rspam-User: 
X-HE-Tag: 1765695372-31692
X-HE-Meta: U2FsdGVkX18n9+SNmJldcWnpDvEjxJgnmAaAXndFpwWXm23Ht0kyVc9RpHZ3ccbirBZ6gJUOYZfhhm/un30ZMkxQvQS1FpqLpZsMP3qsYba9wj8acY9L29lfM6/4neKfIypxhPU2bNjPBqsuppFdsZabdoYLpV+fgzpzrAU7uz76XeF57hvCgnT6s6Dl1Top86q1jfLc/zIgrI9ECjx6hinThV5AwLq5bdEQh8cGW4cGZbBoIUH547aWmdwTlY62iR1eyczkC0SRXuZVgMeGaTjb4w498xTZDAV/C/nm4mZK5uZb+w7ChBVTIPAfPuL3nWcvBLeqQE6vOFPVbNmM9fjAH8SqmTPAPLdZXaA9a26P1C0mTItRLK5p/XVQnJ3EeJfVZNJHAOHa3m7FPZ09ORz9pM3+/aQpkz5TG3vlcvEYJx+aWOZ/uuRF7tVBdjxrqyWD/6ri5rJkY1eUKG4KEGqFVnfiZPvO3Vct6Wj2ugYxmlGC4XS6lULqDQKerCROHojX1qUvf8+wyEDWj/i3Phhqqcskb34gKd1z0aZjR1N8nL67DoCiq4kWjefnoFIovy1mZq5iHa3gJ2sT1ap3gIy+OwfzXK6Bv9n6Mn6WqnYSxW6XYwsO8Zn0pLQQTSBh3P5cn9FpTIYscNwMui7xIrqHeFyqNtS/m31mf95O81RaVckpkoJ39AjA2gwHCpQ4jZtKWHkYW2n0tzbJ6OVwoBedlBFsCHHnEX32tjqE5dSZjIHC47vxFf0Tzvq8T9w/8GlU6pz41cTX78yBoZ1GUJ7khBZoRobCzV1KZlcB28lTcSshZsMKGFSeVuu1DlxS1rVfAs+n84ogpnBMGee7KURqcfKCDSGAksZEyg1VpdL3+MIH+omY0RuL4/gP4Y6ytLr72OI8wCaztjX0TzYdARu3Tz5SOh++sfqVzdfTsNE2lob0h3oY5YNbUHU5NtSShn1NvyPQydtmjiNSIJD
 Fi3+W/I/
 ynjqhTVuXfGsupkjcL+bEkV0pj3bXFR02AuOMlqSxsrcECSr2xjEKBzPPyQfzDyR9CFotZnrhPfazmRreAzotNS/6zsk6Q5Sc/VQDLlxEuRh91pcvCa5vf6UFqn/mbsmN0t8yj9PmrBOrSQwWkuGfmqZUchYp+AVSfrmCcK/DxouqWjann+MY64KXRBz4hqfB91qrXSxAIQTW2F9/ZFtQuHpEF9xw0asJt0hgR5q5e8wDVxtETIcdkx7tRipMadbBitzGvjyzrqjkGEPIxZaVzJ2fw6DUF851vSHMpykdQBXtzgzODN81Qc/wU6wromwG2pRBhvsJo/U4tM93Gl724H1p+hHxPvuUoMeF52H8fVj0PalKsAWgMzpIFn6jefq0t8X109y89oPRLzc16C+gA9zGelD1TE1P02HwsDySxA/kv9LCEg/GTo8IMLsUHnoZp+sJa05B776yli9zZ3/DsfuOb8Po8N7gRQdrleckTadcUiOijFybKEF+BCy0UrDuzt5n+dn9WS0pHV7jFaIXQVD8UKJxfHl3ecz6zfEk4zmrlkGyZeXeGPK8YABdSKGz6SDgyio6E0n8OCI/zz+A0mXu2bDq0BfZgSerP1Oif6/J1SmFmd0+pIoltVHEAQLdVECeDu9MXo/HFLUEValdgTHfLnjVq7l3pdO6OWgdKSh3SQinZo1mOYXfDeLYJVtOGMyoem5C9sX/Ji3xs6v0peIe7mm0FqxoWSwpONb74VO/RKFpfWN1T08zufaJY6vbW2UlN12OXI8fv4H76zIFNLvrIAjSrdnQia8eCjwr74H+hKWaJqTKVkcxNkkIoVITek8P/dNKB/vqiiCcK55kTt46a19KYcxeLNHZv6GpfhCYhA2qnckHUqR50eGmzn0dw4LzIgpYlSV5asT9oLHhzbry6u23QwwgunFTZdd2ccOj7tCw+kIQpjHK3otvSzFJy3MLpJvP4UpvLfML4NppHl7u3m8F
 BnHD3CRV
 5h69t5vXx5Yvxv//LnBoKbh/P9tViWqxIvM7G++q6z8Od7ovvwTQw90BUfTH3CAKHyNdebp5Dnm53BBcBDEV2VrUeFKLb1UCCPSDXfKj0MQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alex Shi <alexs@kernel.org>

'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
functions, That's a bit weird.

So let's convert the pgtable_t to precise 'struct ptdesc *' for
ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
pgtable_trans_huge_deposit() to use correct ptdesc.

This convertion works for most of arch, but failed on s390/sparc/powerpc
since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
archs? If we could have a solution, we may remove the pgtable_t for other
archs.

Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: linux-mm@kvack.org
Cc: sparclinux@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matthew Wilcox  <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christophe Leroy  <chleroy@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
 arch/s390/include/asm/pgtable.h              |  2 +-
 arch/s390/mm/pgtable.c                       |  2 +-
 arch/sparc/include/asm/pgtable_64.h          |  2 +-
 arch/sparc/mm/tlb.c                          |  2 +-
 include/linux/mm_types.h                     |  4 ++--
 include/linux/pgtable.h                      |  2 +-
 mm/debug_vm_pgtable.c                        |  3 ++-
 mm/huge_memory.c                             | 16 +++++++++-------
 mm/khugepaged.c                              |  2 +-
 mm/memory.c                                  |  3 ++-
 mm/migrate_device.c                          |  2 +-
 mm/pgtable-generic.c                         | 16 ++++++++--------
 13 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index aac8ce30cd3b..f10736af296d 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1320,11 +1320,11 @@ pud_t pudp_huge_get_and_clear_full(struct vm_area_struct *vma,
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 static inline void pgtable_trans_huge_deposit(struct mm_struct *mm,
-					      pmd_t *pmdp, pgtable_t pgtable)
+					      pmd_t *pmdp, struct ptdesc *pgtable)
 {
 	if (radix_enabled())
-		return radix__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
-	return hash__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
+		return radix__pgtable_trans_huge_deposit(mm, pmdp, page_ptdesc(pgtable));
+	return hash__pgtable_trans_huge_deposit(mm, pmdp, page_ptdesc(pgtable));
 }
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index bca9b29778c3..e45cb52a923a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1751,7 +1751,7 @@ pud_t pudp_xchg_direct(struct mm_struct *, unsigned long, pud_t *, pud_t);
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				pgtable_t pgtable);
+				struct ptdesc *pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 666adcd681ab..c301af71b3ec 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -520,7 +520,7 @@ EXPORT_SYMBOL(pudp_xchg_direct);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				pgtable_t pgtable)
+				struct ptdesc *pgtable)
 {
 	struct list_head *lh = (struct list_head *) pgtable;
 
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 615f460c50af..4b7f7113a1b3 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -992,7 +992,7 @@ extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				pgtable_t pgtable);
+				struct ptdesc *pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index a35ddcca5e76..5dfee57d2440 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -270,7 +270,7 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 }
 
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				pgtable_t pgtable)
+				struct ptdesc *pgtable)
 {
 	struct list_head *lh = (struct list_head *) pgtable;
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9f6de068295d..674e5fd4cf0d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -577,7 +577,7 @@ struct ptdesc {
 		struct list_head pt_list;
 		struct {
 			unsigned long _pt_pad_1;
-			pgtable_t pmd_huge_pte;
+			struct ptdesc *pmd_huge_pte;
 		};
 	};
 	unsigned long __page_mapping;
@@ -1249,7 +1249,7 @@ struct mm_struct {
 		struct mmu_notifier_subscriptions *notifier_subscriptions;
 #endif
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !defined(CONFIG_SPLIT_PMD_PTLOCKS)
-		pgtable_t pmd_huge_pte; /* protected by page_table_lock */
+		struct ptdesc *pmd_huge_pte; /* protected by page_table_lock */
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 		/*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..a5b1e3f7452a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1017,7 +1017,7 @@ static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				       pgtable_t pgtable);
+				       struct ptdesc *pgtable);
 #endif
 
 #ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index ae9b9310d96f..26ff92705558 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -240,7 +240,8 @@ static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 	/* Align the address wrt HPAGE_PMD_SIZE */
 	vaddr &= HPAGE_PMD_MASK;
 
-	pgtable_trans_huge_deposit(args->mm, args->pmdp, args->start_ptep);
+	pgtable_trans_huge_deposit(args->mm, args->pmdp,
+					page_ptdesc(args->start_ptep));
 
 	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f7c565f11a98..ff74bd70690d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1352,7 +1352,8 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
 		}
-		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
+		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
+						page_ptdesc(pgtable));
 		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
@@ -1450,7 +1451,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 	pmd_t entry;
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, page_ptdesc(pgtable));
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
 }
@@ -1576,7 +1577,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	}
 
 	if (pgtable) {
-		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		pgtable_trans_huge_deposit(mm, pmd, page_ptdesc(pgtable));
 		mm_inc_nr_ptes(mm);
 		pgtable = NULL;
 	}
@@ -1837,7 +1838,7 @@ static void copy_huge_non_present_pmd(
 
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	pgtable_trans_huge_deposit(dst_mm, dst_pmd, page_ptdesc(pgtable));
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_swp_clear_uffd_wp(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
@@ -1932,7 +1933,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	pgtable_trans_huge_deposit(dst_mm, dst_pmd, page_ptdesc(pgtable));
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_clear_uffd_wp(pmd);
@@ -2493,7 +2494,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
-			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
+			pgtable_trans_huge_deposit(mm, new_pmd,
+							page_ptdesc(pgtable));
 		}
 		pmd = move_soft_dirty_pmd(pmd);
 		if (vma_has_uffd_without_event_remap(vma))
@@ -2799,7 +2801,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
-	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
+	pgtable_trans_huge_deposit(mm, dst_pmd, page_ptdesc(src_pgtable));
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
 	/* unblock rmap walks */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..f9b1f8e75360 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1228,7 +1228,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, page_ptdesc(pgtable));
 	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
 	spin_unlock(pmd_ptl);
 
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..f777de39cede 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5351,7 +5351,8 @@ static void deposit_prealloc_pte(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 
-	pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
+	pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
+					page_ptdesc(vmf->prealloc_pte));
 	/*
 	 * We are going to consume the prealloc table,
 	 * count that as nr_ptes.
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..dd83bfff4f44 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -883,7 +883,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
 		pmdp_invalidate(vma, addr, pmdp);
 	} else {
-		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
+		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, page_ptdesc(pgtable));
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
 	set_pmd_at(vma->vm_mm, addr, pmdp, entry);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d3aec7a9926a..220844a81e38 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -164,15 +164,15 @@ pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				pgtable_t pgtable)
+				struct ptdesc *pgtable)
 {
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	if (!pmd_huge_pte(mm, pmdp))
-		INIT_LIST_HEAD(&pgtable->lru);
+		INIT_LIST_HEAD(&pgtable->pt_list);
 	else
-		list_add(&pgtable->lru, &pmd_huge_pte(mm, pmdp)->lru);
+		list_add(&pgtable->pt_list, &pmd_huge_pte(mm, pmdp)->pt_list);
 	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 #endif
@@ -181,17 +181,17 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 /* no "address" argument so destroys page coloring of some arch */
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
-	pgtable_t pgtable;
+	struct ptdesc *pgtable;
 
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	pgtable = pmd_huge_pte(mm, pmdp);
-	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
-							  struct page, lru);
+	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->pt_list,
+							  struct ptdesc, pt_list);
 	if (pmd_huge_pte(mm, pmdp))
-		list_del(&pgtable->lru);
-	return pgtable;
+		list_del(&pgtable->pt_list);
+	return ptdesc_page(pgtable);
 }
 #endif
 
-- 
2.43.0


