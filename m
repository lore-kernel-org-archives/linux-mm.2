Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E17C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5196B00A5; Sat, 18 Jul 2026 05:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CC86B00A7; Sat, 18 Jul 2026 05:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C1A6B00A9; Sat, 18 Jul 2026 05:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65BCB6B00A5
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:57:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3FE1A0342
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:06 +0000 (UTC)
X-FDA: 85001444052.03.B6D9475
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0FB9520004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:57:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N2p/3oSU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
	b=TDrpJoYRpOX5ytscCOlXPl6lSlfHjQR8tWLqOAFnCEUrroZwxvcGuV1Yrwp/1ln6sYtcJ5
	TFtYoZca+qpby9Af5Nk7L/1SrJCkyKhsFJE0HrCJUCVZW5+sdoMaH9pu56sgaLAI7ra6Vy
	Yc8ud6RlifYby4cpmrSy7sWFjax8gGk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N2p/3oSU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368625;
	b=57Fk09imZoU6NAIlunN/2ula2c+txXSMxF/fQh+6sLQAzkTpx3irlvhWifHk/E+hG+LJaC
	UVyS0gP0EmMfUf8Sn+I5qlpejTS5Fu5FOL+ZY5YmQFD0r/XP2lwi3PTJ4XwL148ajIINRD
	VxK7em9FsW5VCJDTqvm+o6Rht2d6b0s=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84a6f026675so491204b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784368624; x=1784973424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
        b=N2p/3oSUEbqQNZpwU/+LZxwRB1DR9y/9RJhzB2naAW4aPnvMHJ+Y90TFKu2BZKAxk8
         AWRKeFqMP5TwuSOcYHum8X3B+g3zRQm6reMsiSq9SWaf9LRmtsBOv6rGcYiuTjKIFw1v
         C+v3J0cKz7/weI722KIaiHL847OA7hI4yigOHd6IrWVnRISIhynrL4YXxSaTuCxX6nPu
         6hTmJO5m0M/N4nZHELC8nMErMXqytHBS9f5EbbGu0/HHcAIjsKAlc4d3A8q1NPZwFLhv
         4RRIsKoAGDQcH2d49IRExD0JfRhPnk29hl+ygyWlSUnv9tl0r4EfQ52JdHSruVSu7NCz
         F8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784368624; x=1784973424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
        b=YxjBreEA28va3t/I9emNxOKOQ24oBTrv9+yaxBYbVzcvt2FpxZTkthxFSQx/rC2yWg
         jpgZhkNoEgKjZcpP/+eOdI2EGOAjBRKHXe4B+XVH+ZfMpjXY6XE//GV4fvEP8Ouuk6mo
         Y1a1oB/AidwKwtDmQ3mHwfzF1+UkRYMDUl61Ki8/9jSegGqjVVp1H3ENYy8/IRXczMZm
         89kHhxtgWtpuPW3oVYriplFEqtadnh34DGfXSoRNIge3jYLNsBPXWUyrWXx+o3+3T6a7
         Hixn3NXGEIgIF7/6ZF+2oWlAARNZSaJ97KPs24WnE3q/gTHKThbD0e1srlzAgCyu1fsT
         t55w==
X-Gm-Message-State: AOJu0YznjlT+CjtcpIuSFnJWfpy78MEmDqya70FrngQXY4U60czDK7kA
	VwMu/de/Cu5hpeonkcG7Hj+gpQjHsvEaU9VBRxB9tD8l/dqf3zwNlx7aappSojKvs0EaeA==
X-Gm-Gg: AfdE7ckOiXWPpdgnffHLBHTMKWPHlRKNWMIyGScELaQpwLdqKMWEBsfSTvZVEpPQ7DU
	jzOh+4MtfZoK/4Yk9K6Rtz2f57CFMLKibQqZId+9KWcisgWQegPVCOAQOkEFTmcgGfd0JP50bQS
	M8FKoLunPnVWgyRahaVAinEJiLqmoSfGd531O/R2ycHD6avjLmIWZyBJnpKBNFLlkWA6o3kmPtJ
	Rfh7AbRL0e/KwqdCigiq01MrMMWqjv2aSvsXOtwK3plHKGBfLmVRbD5sDB/SCDjj65I709hEBxU
	X6Wpikp3pkrkG2CTg82Ebk9+ZTczIVbHK4CB2d1xxkHoe4xc4iPlSObKte5Y5eMUb424yq83/aa
	kBrp4yY5w2cQccGhHt8ih240F1lTjTSpmf2k4W6x54istoIIF88Xr965vWwZl/uYzkaXb32u2Vd
	v0QA70Vme6/qwCjQ7Wwcdz0DATR1TOKV5esudq0PYijmyA
X-Received: by 2002:a05:6a00:7287:b0:847:88aa:4f4f with SMTP id d2e1a72fcca58-84c29510c82mr3438599b3a.7.1784368623754;
        Sat, 18 Jul 2026 02:57:03 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af317c8sm2417248b3a.30.2026.07.18.02.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 02:57:03 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 1/3] mm: make persistent huge zero folio read-only
Date: Sat, 18 Jul 2026 17:56:45 +0800
Message-ID: <20260718095647.182592-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
References: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FB9520004
X-Stat-Signature: kdge1dedn5ofg619ptqhga6pgtjf1bna
X-HE-Tag: 1784368624-942722
X-HE-Meta: U2FsdGVkX18gBEv9gu1l+vLmmKszp3EmvHl1pjslOjOLG25rbwRjBtEPaORohMXTeyNp+GFKQN8pQFO86ftySGpt6movkPOsZJM74iVjALm8EhkK1n6dQwJP00/v+nOS5bCXCnJ8/lCSeV/HR+Din0swS5coCiJX8kgZSS5aFTP8lj/eXELB0eH4maDL5ZVIUwjyV7D16fshaPa8LEzJAoq9jhyJBI/4NNOb5i0gMORxxyoYJgDWO1FTY0QT/pREYRi2kQV/7XnqzvgebF1XZU+08XDyijY+HbEWY2gHuXU+Mf6PMyRUHZNMtQXvKl8AVw3hRVqg8d1ubd/xWTMj2DYoQ962tyA/YuyXMg2pey0E8O/EqQxpyRWiRcwKdJqJADzlHq5Rre9mSHwTUZySBflVefs29BJLRvZ96xxoWXBH98vid6hcSOxe5BL7EjUICtNL2/L4ZeWa07tEMhEggxQbEQ8Xyrtb8cNFce1byrd8/vnZvZDH/6wmmHWn5XCoaMw++2vJ9j6tuzTx2txH9sbzPBOdO+lSLratkhCqn6lOZ1KqSwo5/uHO6YV8Dgy5hOSTjALpMa8De0dzSHT78teGS2PfrelIWyHqiil7ZMq+EaDGzikRu33KDWaoBXaSAVPowoDO30IRi4i2nr8cazT+rYVm4gbIhAW9JPySKMXDMbq7924bdMzF0IbS2zdkEDHWX1trPcRkTYI5y66lg0ZdmmrJmfHYj7FGIegkgYbiHr8vnPtUcvOMJNg/jenbHWIxApq7fmj3KsVyx968WjcHSVjA3JJK6I9P9H7ykeEP71oyuzXuGJG8v74N1m88/YzMWg3+QgoJJF27Uisxg54E1dqZHYE48v+Lzr9xy/Aqpm9EF9Z01QpB/8weJlHc4HE4a+lLz5punsnTudG4Mj1USEQxPocpXa5WWH9+x+fm4nOvluIIBlVpDjb8NkCFgXvDhzS/k3F/F2a7Pqg
 2gMv7Yze
 pUf/bWQwq1qGZA1yYslMujeKRPyqqYNTLoTdhUMi2saPkTpkLjYpIkElAp3iVRi01eXVWwSsyD2vtEfbGH9RLPoeiE6JufvqMN6yGJI2t+kTiGJl0YF1HqytwyN7uVSH29uFgqw4Z+FoD8WNIAYqOkjm1DpFfgpsghNGN6OdnBAhL250BEqaVjcnuT6h26HF5J0RZLQk9OdERDKxkOOQyDxn97LoZqe3G99HcTrmxcHSSHcmajQJctagbZGbiikzOIlCS9C/AIUaWIilMef5g0tsE4FqDQQiKK949Tjku/p3gr9EiLQx1gegPnUFwR2BkBK6UTC6yaZovwKfiewCK5wcAjH9QotFtKo9bapODI3RQC9E8C6ZoYwk54d5K9+JknD6aHg/hZ5tYT+toV/x5NaQSeLkm6GFfU5MI30zacG833w4ww3XHqNA5D21GqDAMKBl6ltiNKA0zZpGVO37cX6wrCrzAc3f+ewOeBWkIuzwQUjxBGzMOR+TyhuXo111O/yr4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the persistent huge zero folio read-only
in the direct map turns such writes into faults instead of silent zero-page
corruption.

Add set_direct_map_ro_noflush() so mm code can make a direct-map range
read-only. Use an address-based signature to match ongoing direct-map
helper work[2], where existing page-based helpers may move the same way.
The helper is direct-map specific and leaves TLB invalidation to its
caller. Architectures without direct-map permission support keep existing
behavior through the generic stub.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Stale writable kernel TLB entries may therefore
exist. Flush the direct-map range immediately after the page-table update
so they cannot bypass the read-only mapping.

Treat the direct-map permission change as best-effort. Architectures that
do not implement the helper keep the existing behavior via the generic
stub.

Inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[3] with Yang Shi.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
[3] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/set_memory.h | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c           | 16 +++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..e83ced6a3827 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -40,6 +40,24 @@ static inline int set_direct_map_valid_noflush(struct page *page,
 	return 0;
 }
 
+/**
+ * set_direct_map_ro_noflush - make a direct-map range read-only
+ * @addr: start address in the direct map
+ * @nr_pages: number of pages starting at @addr
+ *
+ * Make the direct-map range starting at @addr read-only without invalidating
+ * TLBs. Callers must either ensure that no stale writable translations can
+ * be used, or treat the permission change as a best-effort hardening step.
+ *
+ * Return: 0 on success or when direct-map permission changes are unsupported,
+ * or a negative errno on failure.
+ */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
@@ -56,6 +74,17 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+#ifndef set_direct_map_ro_noflush
+/* See the comment above the generic fallback for the _noflush contract. */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..4425ae5560cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,8 +40,10 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/set_memory.h>
 
 #include <asm/tlb.h>
+#include <asm/tlbflush.h>
 #include "internal.h"
 #include "swap.h"
 
@@ -932,6 +934,8 @@ static int __init thp_shrinker_init(void)
 	shrinker_register(deferred_split_shrinker);
 
 	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		unsigned long addr;
+
 		/*
 		 * Bump the reference of the huge_zero_folio and do not
 		 * initialize the shrinker.
@@ -940,8 +944,18 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		addr = (unsigned long)folio_address(huge_zero_folio);
+		/*
+		 * The folio was zeroed through the writable direct map. Flush
+		 * after the page-table update to invalidate stale translations.
+		 */
+		set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);
+		flush_tlb_kernel_range(addr, addr + HPAGE_PMD_SIZE);
 		return 0;
 	}
 
-- 
2.47.3

