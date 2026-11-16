Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEC2606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nW0D0jtq
Received: by kanga.kvack.org (Postfix)
	id 5DFD16B05B2; Mon, 16 Nov 2026 02:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6FC6B05B3; Mon, 16 Nov 2026 02:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F41F6B05B4; Mon, 16 Nov 2026 02:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 311AA6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:13:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AD44A86AC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:44 +0000 (UTC)
X-FDA: 85440117168.12.949B5B3
Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D8D2A000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nW0D0jtq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813222;
	b=tnzi3vMy114l+NOKXJB/yp1Ua1v7ZKhtMm1x9lAwVpLPlmUVWBaIjY3UO95VqKbMIpGTVY
	a11UDSEfJA8L+2q8e1sUdEPuGm23uDLFzkoqwRLHqhfP07L0apnlyrQtqX9L04dZIyjmMK
	wFqvScFq+DoEBvFZdHrUxE04cYYCL/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOtJc8ArX8+ToyaiTRWaxycd35R3Jnx2kTE6b07ZdMU=;
	b=2GJbmmx8qREql+t+lEXHEgT00y1UZueGWYVrFGZSENv+7O3ChDoaeg6VY4xB7PFG4d4OGZ
	WBbc5N4/jU5aQVH4RjS5mmUKjKfhtz8GvdoL7npBydm87gX8UMkSv0O+7cR++DYvd1XfWJ
	Ik14sHB0PQXG2YQsrOj/BNzOogwjx4c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nW0D0jtq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7/JYJzeyd+b/iRPmzXRLtiBy/A7aQtupMKn/EdxvRIU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813221; v=1; x=1795418021;
 b=nW0D0jtqi6IQbHFRngaT2zyRdXassmaeVQlNRx4TiqLyjQ8Y2vz17pMg4BjgFljgUXl4meIE
 N5IXqCpfY69OSpwUq+ZvebtoPlDTTPyDSEoXvCIR8d3Uz7XyaZ4OXg+ebyqLSrfCn9l8zY8jpHN
 lcltd8kejcBirorUAS+J6bLA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2e79e42b6b187866;
	Mon, 16 Nov 2026 07:13:40 +0000
X-Mizu-Trace-ID: 2e79e42b6b187866
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/11] mm/vmalloc: skip cond_resched() in the vmap unmap paths when atomic
Date: Mon, 16 Nov 2026 15:13:15 +0800
Message-Id: <20261116071325.263682-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D8D2A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: jkaj6pnkiisbwj74ofq6kdraqp5irwx7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813222-485109
X-HE-Meta: U2FsdGVkX18B+iC8ewBHmFx+MGXNR7KQfPcxazbDbnNXaUhEgMcIKgryeuIRm3iPNm2KZXqiaJTMeWTROOaIgeljufTXBtjUTkoeVZS/BpDdtaaxP2x09BfuyitIwwHI6E28xw0jFzhLoXi1hrm2s++/gdUE7OhSwPNLkv7z38rtGO8fbFYbJqb3oQ5G3V9662kUPCcYCJnB4x2rARryVzKe2Y3NADTPlxSqXJcdpwY1ITmeF/TFAwwCiQq+RE6a1ta2LLqoOryPb5vzG9LiEAe49DCdi5iJk8neVxyP0g9r1Lw/pcMRiNUieGs4xTjuuyFuVS0Y8xvfZbF3cTMXGQhLqU7EOMJe+qPqUI4SHz0djOtt0zoDA8sWrhD0CEnL5jpSUQPjf5Zh6l2LucxgfIpHJYXmMoUnZ3eKQEHD0tgXql7fjcyS611KmAHx82uNqQONxWbfOxcjytp5Bkje+gnu/mS+38YfcJ2Ad+hGMskHBCkq8FSSvQB12IWRSb/pn9RG/gNeAoLqGliKVDoLEUlDLExNoBCcQVah3cLc+xBsip2M3shjjvV7Bwev8tmed002BH/aQW9IW7KzK8gi7bwwc1CfLsYD4s6GopCYOHSBlz3TSQL2p2QxjoiHrk4xI/lSzPLlR3SS8D3UALfVJc/nYVJR/XqGJsj27tABuJoCYHzi6psVR0323O2Nqk4by2xGTa2OPfRLQF1R07z+eWanK2mZ0OqLT70CaUkudyQdbYJXvGDndsnbyGcLHpXqkjvH5xPHrruc3HRXXOf/D7Gz38MLGYCFvMOkXKoWZ73dlzbvQXs8FQUP/A+dTQrXZEC8E7Czw+pebP1y90np1E/JPnCzaIae9y67+MBlygvpNcuza0+FBCBGZe+Ag25jw4itShNisFs0G3lm4Nj8L3v1JTHTdXIHe6ds7nP4uDDrp855kBYcciSCWkZ9NClJ4i/S+hkmWHKziXLi/6U
 zsoAUk3p
 8Cu1jonbch20LSys/6vZVcXcJFmlmZS63H+qNJtWtN/f6GAsL8gLMi62sndewMpnkFHOZzGXYgLcTpA9uUv3SpZDdGEDb8arwlN/GOcjSV5aYlg56liZY0DZPj0iHUdcVAd/NHRl7kvUCJPnm3H3HiLAS78uDN7x2xgHoXB05hSA1Y2BPW8NRYbXnBYUoslgTwhmzi/dgb5pz0rP2mNRce/0sdPwUK4BXH+0VmJN97Rnvmc5jUIjnr641UOBNKvB8ZbOgkiMSiSv+jk8S+Dc4x9wHaXBWkc7qH/REq+eNJPOZjWmuAiCv6spNISS8A9QuE3taZbBMmhKP2Vic9Luhi5K716gFXrPDd/nfa29Cl1s/2SLId/FHOd6UdWN5z6pTItaZBS46qQ1QWHNdVpINPg9TE8rxI6hZ0dbHL1D5RjQraCxwku09jdf9bQ7ac3YCJPr4YiEdVstiMsx+4vqevCXrIb1cV9v53msnxF8w1QNYeCtxp91XHgruYg6ZeAjviNNvx6kCNd7VHGJtDoqgVuGnAhogRx1rteK75djC3v4U2D0BQLPje1uTq+vVHe+nTwnEjLafAnbRFzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The vmap failure paths can be reached with GFP_ATOMIC or GFP_NOWAIT
since commit b186a94227b7 ("kmsan: remove hard-coded GFP_KERNEL
flags") and commit 8da89ba18ed4 ("mm/vmalloc: handle non-blocking
GFP in __vmalloc_area_node()"), so an undo of a partially installed
mapping may have to run in atomic context, where the cond_resched()
in vunmap_pmd_range() cannot schedule.

Give __vunmap_range_noflush() and kmsan_vunmap_range_noflush() a
can_resched argument and skip the cond_resched() when it is false.
The existing callers are on sleepable paths and pass true, so nothing
changes for them.

Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/kmsan.h |  8 ++++++--
 mm/kmsan/hooks.c      | 14 +++++++++-----
 mm/vmalloc.c          | 24 ++++++++++++++----------
 mm/vmalloc.h          |  3 ++-
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 7da9fd506b39..0016c032d1e7 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
  * @start: start of vunmapped range.
  * @end:   end of vunmapped range.
+ * @can_resched: whether the unmap walk may call cond_resched(); pass
+ * false from atomic context.
  *
  * KMSAN unmaps the contiguous metadata ranges created by
  * kmsan_map_kernel_range_noflush().
  */
-void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
+void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
+				bool can_resched);
 
 /**
  * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range() call.
@@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range_noflush(
 }
 
 static inline void kmsan_vunmap_range_noflush(unsigned long start,
-					      unsigned long end)
+					      unsigned long end,
+					      bool can_resched)
 {
 }
 
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index a706666db097..69008b085658 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -136,10 +136,13 @@ static unsigned long vmalloc_origin(unsigned long addr)
 						 KMSAN_META_ORIGIN);
 }
 
-void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
+void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
+				bool can_resched)
 {
-	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
-	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
+	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
+			       can_resched);
+	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
+			       can_resched);
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
@@ -168,8 +171,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
 		if (origin)
 			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
 	}
-	__vunmap_range_noflush(shadow_start, shadow_end);
-	__vunmap_range_noflush(origin_start, origin_end);
+	/* ioremap metadata mappings are always GFP_KERNEL, so resched is safe. */
+	__vunmap_range_noflush(shadow_start, shadow_end, true);
+	__vunmap_range_noflush(origin_start, origin_end, true);
 	flush_tlb_kernel_range(shadow_start, shadow_end);
 	flush_tlb_kernel_range(origin_start, origin_end);
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ccaf158c5b7f..3c0d9e69b886 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -429,7 +429,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 }
 
 static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -451,12 +451,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
 
-		cond_resched();
+		/* The undo path may run in atomic context. */
+		if (can_resched)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
 static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -476,12 +478,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		}
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		vunmap_pmd_range(pud, addr, next, mask);
+		vunmap_pmd_range(pud, addr, next, mask, can_resched);
 	} while (pud++, addr = next, addr != end);
 }
 
 static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -496,7 +498,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
-		vunmap_pud_range(p4d, addr, next, mask);
+		vunmap_pud_range(p4d, addr, next, mask, can_resched);
 	} while (p4d++, addr = next, addr != end);
 }
 
@@ -512,7 +514,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
  *
  * This is an internal function only. Do not use outside mm/.
  */
-void __vunmap_range_noflush(unsigned long start, unsigned long end)
+void __vunmap_range_noflush(unsigned long start, unsigned long end,
+			    bool can_resched)
 {
 	unsigned long next;
 	pgd_t *pgd;
@@ -527,7 +530,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 			mask |= PGTBL_PGD_MODIFIED;
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		vunmap_p4d_range(pgd, addr, next, &mask);
+		vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
 	} while (pgd++, addr = next, addr != end);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
@@ -536,8 +539,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 
 void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	kmsan_vunmap_range_noflush(start, end);
-	__vunmap_range_noflush(start, end);
+	/* The unmap paths are sleepable, keep the resched point. */
+	kmsan_vunmap_range_noflush(start, end, true);
+	__vunmap_range_noflush(start, end, true);
 }
 
 /**
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index d8372a4f65c4..4ec114a75f04 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -44,6 +44,7 @@ int __must_check __vmap_pages_range_noflush(unsigned long addr,
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
-void __vunmap_range_noflush(unsigned long start, unsigned long end);
+void __vunmap_range_noflush(unsigned long start, unsigned long end,
+			    bool can_resched);
 
 #endif /* __MM_VMALLOC_H */
-- 
2.25.1


