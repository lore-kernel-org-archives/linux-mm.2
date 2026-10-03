Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF9FCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF096B009B; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2376B009D; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1936B009E; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3166B009B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDD8C1A0395
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
X-FDA: 85281310842.21.A285B77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E589C180005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpTJpzZY;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkQv2TPdeipL8t4cgv3a+/1unMsv7uh293yr0UUxJ2o=;
	b=VDXQstXHCloYblL94ABPSTzxTixn0kgz5dlMWds9Bvlgb6ddxQBrc6x0gKTgebc/sc43Vy
	bwT+PATlQ6+9Q83d8ev5FeSg/qd+J2bxkNXhrLLmMgrFMTZS0tL3DhCzBLweVtRXhcrt7z
	6XRAes6yeOaa9eSxkNNhfNtyZt5mc0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032119;
	b=D8CeT2wGxjIaNq5Yc5cT3cqPyIg53bo/ABjQSX1MJxbPh2f125Mpiu8H7lpQAjdl/xBE2G
	VB6WMGVOJCoip/o2VYl397UXeEDPebneR18Ar+ZZ/p3aLVjlT1rx+QNRelMouk3wVXLUWl
	FaQUSawf9yMSL2TK35BDX2SaQcrVPPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpTJpzZY;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F29D60D8D;
	Sat,  3 Oct 2026 12:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC7EAC2BCB9;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=IPogQoGTg2Xwqc3n6mc2GqluI33lLudTifJvvpPhlpw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GpTJpzZYnON+/dpmqdiy80NiIEElL8y0VJLPC/McG+lm7PNZRK1TPmlkZS90i7esz
	 P9BfqJEaFxQap5pCAv1Th0wWp61j6GB72CGKpZEdcde7vU8QLINAZNK8l77xbwVxaK
	 wbuax8Pl1d/Y4UcvysSNbGqRgFHU5pPdlpOfyX7vpgwx7mZL2CBhVUvnUEMLOy2qk4
	 IG6MB1f5WcUsLTBBt3+YghwcfXIfdu54i5QLjixlgqNc5De9UgKkdE7SSmelAuTtaI
	 pqWQzV8ezMVwCHUW6vx4CYyOvEEYzCH/56bUZUxVvT8+fxhNCIdpjrvjd6+iRJ5ZDX
	 /8T8wY7fkfZeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97073CA5FED;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:27 +0800
Subject: [PATCH RFC v3 16/17] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-16-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=5993;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0UKPioOHWojVarJEQFJShU55Y1qVkRI23X5MnhRd4eE=;
 b=neXes4moJ7Eui1l3feEYxn8CVM5V6KsutIso83WMYFlrcGy8zOg81T0UQ2k5gTQC6RkuwIpgR
 RubQN6qlf5uD6eAOeivvYyb9cLzlnyz2/z6eakf+mInZhePecTUw+2T
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E589C180005
X-Stat-Signature: 5ocr86mbhbax6suyuc9e5ss3egt15k41
X-Rspam-User: 
X-HE-Tag: 1791032119-373793
X-HE-Meta: U2FsdGVkX19JlDgcd63+tY1NCqMTDFb/bHR0YIoMmTI5VyJG9wEHoFOVQVoZQAYUh2qwkIQLGr2cNesB3Zd0VudosI2l95QbOfqfWSSsynFVy4VDUFe+ZKyl7BrQm+tpSIT0R/HysjuGQGdHzIKT9yxZIIAlrUIw630c7fPnF2enrhyOhyaEkTfX8LOj517umWGo7BER0hfMc2ZACgADqMFJRqiawXX9Z1WNOgMIeNuzDl6eXhfJ3V75u95jrhgGwEUnBPO1unwIMxL+zHR36rtUe6TqUdmd1v27YduLGvuPaNWL3nbvxZePGp9iGslQAyglQjCTu0cXKws8ebW7FKfPxqelLly81oBcl9iXhE9rd1N3cKZ7H3/6Hst3VZl1TPlnBK31cxbKaf2NUUdwX8Pndb8ck6zFQGh05uQTo+zXqOJvOIAUN5pwO1WUYViuX7bLYVO2MabjxiZHlJTXMi6OJf1UdEdHEUUS/gZ9qHMQdEtD2EdRyEbKCvYzKd/REEWSg7gtbpv1XsMbLhVKXZVSj0bKGX+VJNCwa/Gx/WvNFGNbnqog8qm0Bktxw8W0CrJ0dgXX8ZIlXUGHLMHCvqHP9lIC6AQWdYsf6hHK3FHpfaJT1YgvpZTAzHB7dEdj/sckpFnx9im+NzD/jcgHFvifs7Yl9N1RgZlJpgXdlSfGaNBG9ikjfmf9BysILystNxXeZQUstABeMiMa+4erY4HNN7TcjHRNsu5i+1TXmaQ6DMDUxwVEnaPiiCQ4K5mxMAXRdTuuxRNgPuxwQ1KKfa8CS80urtNPUeej/q9sTYvGQDg8T8kvHt4kOiCsm0C8v2xaHfVPLOywCi8C3lbaZDsbK6h4ij3vTsAmjEaDNmnhgAvlBlLXzaOroy0UjI+Fp90eVrxcdAavCYpMhZr3dWyJ2hHkBE/258kMl4BdKNP23KiGENUJVdMG07h9XJ4Isr7LZ53/JjFH/sNHMLp
 FFkkegc9
 oSCw+kgcFrQ4zA55Og40NoJ85HkJyO4ykgQPTYSyXooSw0tB8uQmmVB6HZFUiHO4+Bc4i9KMB+tMCtbspMZQGaTZfpK8IbJ2lfgoym56MVpA/7GnHv2rCPnbS62XHVd/b2uoIWTbtdvxL3zDZXWI4UmNZu0X+Y0GJQ9erldyjrXYAKOryR7ZMJFDLwAiLrRiQBDaTJ1JPxwggGgFDtiSv8Hj/ZgpXu2aygAhcAnUz7oxprRFjw1BgP30VEQBLWtZ64FVaLmDc0uHZxUHqyS8WIYaHkvgQ+pX2ScJ0Enf7dvEqVGgDxlJol+sDJmhetAIVx+ApQYeF9eZmW5lHWn48bieRkC0CmI+LJw6EqdzinRZ6vVaWWQFx6VeYAwc8PW6a2ou0vV/1aWnL3cgd+CY7cW3zNb0xG36vXyUq4MS/kHwh4V1ccCVvaDXVLTIvevDHu4xW+z75b3VD8Ru5Df0ZEeneyfT0gWCvTtiD9z1NxeKuvi8X0SG+FSHd1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_test_workingset() currently tests the PG_workingset bit, which
is only the second lowest access bit of the folio LRU refs count now.
Folios with a higher refs count carry it in the LRU_REFS_MASK field
and no longer have PG_workingset set, so the bit test misses them.

folio_set_workingset() currently sets the PG_workingset bit with a
plain set_bit(), which also over-promotes folios at a higher refs
count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
toward LRU_REFS_MAX and an unintended generation promotion on the
next access.

Move the test into mm_inline.h as an inline helper based on
folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.  The set
stays a plain PG_workingset bit operation reserved for the
classical LRU: under MGLRU the refs count is maintained by
folio_inc_lru_refs(), and now triggers a debug WARN when called
while MGLRU is fully on (the switching window is exempt, as the
classical paths legitimately run alongside MGLRU then).  The one
PageWorkingset() user in erofs is converted to the folio helper.

Under the classical LRU the refs count is not maintained, so the
test falls back to the PG_workingset bit test, which is the old
behavior.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c     |  1 +
 fs/erofs/zdata.c           |  3 ++-
 include/linux/mm_inline.h  | 35 +++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h |  2 --
 mm/filemap.c               |  1 +
 mm/page_io.c               |  1 +
 6 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..57d24413265e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,6 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/mm_inline.h>
 #include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e981e371d6c2..34ee41e1ccdc 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -6,6 +6,7 @@
  */
 #include "compress.h"
 #include <linux/psi.h>
+#include <linux/mm_inline.h>
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
@@ -1713,7 +1714,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 				DBG_BUGON(bvec.bv_len < sb->s_blocksize);
 			}
 
-			if (unlikely(PageWorkingset(bvec.bv_page)) &&
+			if (unlikely(folio_test_workingset(page_folio(bvec.bv_page))) &&
 			    !memstall) {
 				psi_memstall_enter(&pflags);
 				memstall = 1;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b68d68101248..e651f60cb914 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -258,6 +258,24 @@ static inline bool lru_gen_enabled(void)
 }
 #endif
 
+/**
+ * folio_test_workingset - Test if a folio is in the workingset.
+ * @folio: the folio
+ *
+ * A folio is workingset when its LRU refs count reaches
+ * LRU_REFS_WORKINGSET.  Under the classical LRU the refs count never
+ * goes above it, so this is just testing the PG_workingset bit.
+ * NOTE: folio_set_workingset() must not be used under MGLRU, as the
+ * folio refs are tracked by folio_inc_lru_refs(), it triggers a debug
+ * WARN instead for MGLRU.
+ *
+ * Return: true if the folio is workingset.
+ */
+static __always_inline bool folio_test_workingset(const struct folio *folio)
+{
+	return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
+}
+
 static inline bool lru_gen_in_fault(void)
 {
 	return current->in_lru_fault;
@@ -445,6 +463,11 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	return false;
 }
+
+static inline bool folio_test_workingset(const struct folio *folio)
+{
+	return test_bit(PG_workingset, const_folio_flags(folio, FOLIO_HEAD_PAGE));
+}
 #endif /* CONFIG_LRU_GEN */
 
 /**
@@ -473,6 +496,18 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/*
+ * For the classical LRU only: under MGLRU the PG_workingset bit is
+ * part of the folio refs count maintained by folio_inc_lru_refs(),
+ * and a raw set would corrupt it.  The switching window is exempt
+ * because the classical paths legitimately run alongside MGLRU then.
+ */
+static __always_inline void folio_set_workingset(struct folio *folio)
+{
+	VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
+	set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b0ddc652e76c..f6625dc042da 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
-PAGEFLAG(Workingset, workingset, PF_HEAD)
-	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..49e827058e14 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -21,6 +21,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/leafops.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
diff --git a/mm/page_io.c b/mm/page_io.c
index c6824fcd483e..540ae8caa932 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/mm_inline.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
 #include <linux/writeback.h>

-- 
2.55.0



