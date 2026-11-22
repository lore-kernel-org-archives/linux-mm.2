Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C12606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Lh82JeeL
Received: by kanga.kvack.org (Postfix)
	id CB7786B00EF; Sun, 22 Nov 2026 17:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D876B05B0; Sun, 22 Nov 2026 17:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB146B05B1; Sun, 22 Nov 2026 17:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9276E6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:20:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7154780718
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:20:50 +0000 (UTC)
X-FDA: 85464175860.27.0887DA8
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3964420003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:20:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lh82JeeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795386048;
	b=6+JmavtDn7MFdyEY5mdEnxxZVxccXUT6ctCZ34lYtlGFEHq7w/ry+D+V1ALAs05EztWhO8
	lCY9e6gXrec+h7TVF/Y4tmkxcRQlxIGJzLAOSjU1rmqeJbQXgRv1irz6pP6P+NE9v3fw8C
	+pBwleLranb663m1RFXqGr/fsI9CNlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795386048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lc6fUtsCWmeV+5/+DCrLem52MZY6l2sSFs8DDA0bUS0=;
	b=Vh0Cj+K/fEHBB72rgc+gOAU79h21xomqDVjoOHhaxxXtfTcQcC43qgVOlZvje6p2KWP/ar
	yZmtnx3Uo6QZH/CF0szM987ujVSIyZCONH9MJYXR3LNup9gsxdpmHPZNsCwgql8jaIasbd
	5uZFdYIezV43U80TOGze1KZN4LE71tY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lh82JeeL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UYOxhiiES+py02IgKFMURgWV6dfWF2tHLsN1Lp7J5FQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795386046; v=1; x=1795990846;
 b=Lh82JeeLemmM0UYjtA/NFJZxNWK91MVjMZukChWSlaMtTjaOHk8l6ryx7EDFzvlyQGT28vWe
 PXneeVJXf5ZIjVIXIGfceD/XJTnEknxqiVWmJT0GbImwalz4TlQA1ZFx5pPQN0zBaFGaU9mi4LS
 mPG5F6wMZjn7M1pUKAVOu5uU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f9332ef0a593abfd;
	Sun, 22 Nov 2026 22:20:46 +0000
X-Mizu-Trace-ID: f9332ef0a593abfd
X-Migadu-Flow: FLOW_OUT
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Sun, 22 Nov 2026 15:20:27 -0700
Subject: [PATCH v3] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNQQ6CMBBFr0JmbU07YiOuvIchhtJBRgVMCw2G9
 O4WXJvM5uX//2YBT47JwzlbwFFgz0Of4LDLoG6r/k6CbWJAiVpJPAqTi6fvbg3PAQWaRmqkAot
 cQ5q8HaVg013LH/vJPKgeV8faaNmPg/ts/wKuvT/qdFKcjFaVlXmhGnV5cT/Ne0sByhjjFywnx
 0m6AAAA
X-Change-ID: 20261025-b4-ksm_fixv2-2bf062e92946
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, 
 aarcange@redhat.com, "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mailer: b4 0.17-dev
X-Stat-Signature: dw9xd97ig7upwd3zebammq4nn8bu9p4o
X-Rspamd-Queue-Id: 3964420003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795386048-811509
X-HE-Meta: U2FsdGVkX19adczse0+1DByu6vkLxwZRTIInrTe3TtNgX1F9J9oABAXfgpB83Zrh+Jj76ADqyxlW6Mcsxx/ETeK/MUEa6GVwIiBBdye35fpwOA+uWRUujYTr7DIi2BZKEEFiJCd06CYk0KvpfJQPrZZHWZHSYRx8ll7ITEzq8zIN45eYM1cIYzi6apJHubgA/VeMErR8rjF37+cb+dWP0Klp6jTYs6FgRWzmZXHvU61Ys65Psv8zZ6geze5/we37AIq1Pjugwmovyae2Sdkq675atwccHuJANhygv6xazAK6f0WBAl13eKz3NGEAZLd/iuAurylt7zjEgJlxmsEeYpIL7wXAcAkuuznuyiE+LYpbcDEaj39h24lkBKPKHMbmnr/t2gp/BRbhV3K1qDVbhZ3knVDkYP1jDSHc0lSqqqDyOxVYgLIgi4+s5C0EefLN8nr/E1EXRgyFOPVCkutOGXlCim0YnaRNDODLu1yY9PMgERE4XqQYoFXKFWMlf4wDuJll5u0M++/bK/po1jolsGX2X4inPZ7Dt5NvApvHaiuFpqI2IcERbH7fLtpwBHPXozyObtBWi5YWFE/aXp7HMT1/OqpvF8PQ0TzpzeTaqNrKkPTqfKyDBzNltF0jnDjahEEu3vqq/jjJ25DE8tOiEWYrXmfA2BaKgqtwkVEVs5hDIlDJsR+mEx/kMt0IWnlBgbycHSm/OyJTMTsB6ZDG5x54kEjplQ0mOXPVmtQd5TSjd6LR8w0HhCkBJmLSXCfidFK7s1wfpmn2cGoBpntfyIkcfBU9OJDdfqNvd2WIbLWLWN2JHg+jRU0Z5ey9T9qLo0OAj/HVWqM9Qxuxqv62w5oTLgqpL/JeVI43ahONh0aQOQlixI9LsWmqXf4C0RLIWnvoknRlur6mPhLvDWHe1HWSkoAck+LJqikfhSuQT7vzlAGaWHeXfNGtvEjqfWxkHoJ9/B0ZDLPZf/VDDrI
 2cSfOOkm
 EFNkYTx8HDqQb/K7mYg4NoYivEYDRTzXf7rqjMJhuEMfe8O6Wn1+uayNQqqX17uOlbNFw689Vu4r/xwM4yUjU36+pknfVElH6PVW/DgCK/UYZR4x+nAxg00r3MN+1z0Hm5LW4pqQ8o3BDFFDgTJ0/0mXwb7WqTkkVUG38BPyTtcrp5Vdy26f7BdQN1MIgHbbJafPPNFtir+aQMebVPByDM+2rm0WfVAV7duOgiDjxsJjyMHi+FrVmx2zXIEa4lYV2uYJGmu/721czjC+iFlH9P5eLhL1T34BBWcXvvpWqmk/OWM3/sg5waPaRpbNItCpDbpHPl5YdMfga01uAIPP1745J9H456XqLBQBUsubJBiuLHFyZwrfQUa3XzyO7HPl8s8s5goQpsY5aCyecZdz8VH/ZI8YLQfS2NE6t30qYNDFlMYoeIELPBuhpEhNr6Cq7xRZMdXbOOq528uKO1brq227k7z+4e/ILr0xuC8/S0vuER2lTmN9aI4QMIgIP/eHW2LoGjGjrFpG42QJ2jMTdPpM84amrOSURL877wMgQzM5fNUh0pSBOKgMbK89qvm/uCOXg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), splitting an anonymous THP remaps all
zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
This flag is set unconditionally for every anonymous folio split,
including splits triggered by KSM.

When KSM is enabled with THP=always, this causes two regressions:

1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
   split_huge_page(). The split remaps all 512 zero-filled subpages to
   the shared zeropage at once, freeing the entire 2MB THP when KSM only
   intended to process a single 4KB page. This bypasses KSM's
   pages_to_scan rate limiting, causing ~1GB to be freed almost
   instantly.

2. use_zero_pages=0: The same split side-effect occurs through the
   stable/unstable tree merge paths. Each pages_to_scan iteration
   triggers an expensive split_huge_page() that silently frees 2MB,
   while the scanner wastes cycles on tree searches for zero-filled
   pages that were already freed as a side-effect.

Introduce current_is_ksmd(), to check if the current task is the KSM
thread. Use it in try_to_map_unused_to_zeropage() to skip zero-page
remapping when the split is triggered by ksmd. Allow remapping during
reclaim running in ksmd's context.

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
This patch fixes a bug in KSM where the pages_to_scan limit is
bypassed and the policy (use_zero_pages) is ignored.

Commit b1f202060afe ("mm: remap unused subpages to shared zeropage when
splitting isolated thp") added zero-page remapping when an anonymous
folio is split, including splits triggered by KSM.

Skip zero-page remapping when ksmd triggers the split, while allowing
remapping during reclaim running in ksmd's context.

Changes in v3:
- Drop the patch gating zero-page remapping on shrink_underused.
- Allow zero-page remapping during reclaim running in ksmd's context
- Add a comment explaining the ksmd check (David Hildenbrand).

V2: https://lore.kernel.org/all/20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev
V1: https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/
RFC: https://lore.kernel.org/all/20260508170509.640851-1-npache@redhat.com/
---
 include/linux/ksm.h | 6 ++++++
 mm/ksm.c            | 5 +++++
 mm/migrate.c        | 8 ++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index a0d358a1feb6..23c8e9f60118 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, vm_flags_t *vm_flags);
+bool current_is_ksmd(void);
 vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			  vma_flags_t vma_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
@@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 	return 0;
 }
 
+static inline bool current_is_ksmd(void)
+{
+	return false;
+}
+
 static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
 		struct page *page, struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index d24b129932bf..60656b05419a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2873,6 +2873,11 @@ static int ksm_scan_thread(void *nothing)
 	return 0;
 }
 
+bool current_is_ksmd(void)
+{
+	return kthread_func(current) == ksm_scan_thread;
+}
+
 static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
 {
 	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
diff --git a/mm/migrate.c b/mm/migrate.c
index 65869b8acec5..b0949f43ed5c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -305,6 +305,14 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (PageCompound(page) || PageHWPoison(page))
 		return false;
 
+	/*
+	 * When a split is triggered by KSM, let KSM take care of scanning for
+	 * and deduplicating the shared zeropage. Reclaim in the ksmd context
+	 * should still be able to reclaim zero-filled pages.
+	 */
+	if (current_is_ksmd() && !current->reclaim_state)
+		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);

---
base-commit: 2dc60bd9975fc8666a13d58410499e06e6799ba9
change-id: 20261025-b4-ksm_fixv2-2bf062e92946

Best regards,
--  
Nico Pache (Red Hat) <nico.pache@linux.dev>


