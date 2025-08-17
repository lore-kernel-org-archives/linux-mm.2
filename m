Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99797CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290EA8E003B; Sun, 17 Aug 2025 04:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268638E0035; Sun, 17 Aug 2025 04:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E7B8E003B; Sun, 17 Aug 2025 04:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 002D38E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:35:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6BDE118131
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:35:58 +0000 (UTC)
X-FDA: 83785591596.01.FEEFC5D
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C04B100006
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:35:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755419757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0QEU6rxca66gxdaDTX4BKW3w7+p8hrm0o5luvKasAAY=;
	b=dD26257u4Bi7o+YLROCGr1tJz/BZ66deTA2E85rDZiU2jcQh5kC6l07sFINpb27EIivBDW
	7pzE1GgCXH0LpuZax++4aDqf08Oq6tZ5xexS2XSKhqc5kn1Hhe4egMnVGupJfA7CJxwZkH
	cCffyxHkYCVQL0XKQs4S8nSHYbPcCEA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755419757; a=rsa-sha256;
	cv=none;
	b=hXVvwGG4rrcexBqGHmPT9TuyWzDW681NAVe0ndkAltBsCFUVmTETobQdiNXGaTf9oxQQPD
	iBS+SK+ZhtoAPJBgLmT+Nu+UODiUews/Xp+BBP6jlFA2WeKWt2SNYXSq/HJv8cEX7BX9t1
	sg1OnWcmmbHPFSVEKR7qLOiHvOhxS0g=
Received: from loongson.cn (unknown [223.64.69.45])
	by gateway (Coremail) with SMTP id _____8DxzOJnlKFosvFAAQ--.56926S3;
	Sun, 17 Aug 2025 16:35:51 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.45])
	by front1 (Coremail) with SMTP id qMiowJDxscJilKFolzhTAA--.44172S2;
	Sun, 17 Aug 2025 16:35:50 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH V3] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Date: Sun, 17 Aug 2025 16:35:34 +0800
Message-ID: <20250817083534.2398601-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxscJilKFolzhTAA--.44172S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4xGF4kWFWrWF1fAr43Jwc_yoW3Aw4DpF
	48Ar4UGr48JrW7JF17AF1UAry5Wws7uF48Jr9rGw1UZrn8Ww17GFyUtFy7Zr1rWrW5JF17
	JF1Dtw1Ykr4UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URa0PUUUUU=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5C04B100006
X-Stat-Signature: paoqn3hwmmsrdy3fh4d1uo4hturneois
X-Rspam-User: 
X-HE-Tag: 1755419754-756847
X-HE-Meta: U2FsdGVkX1+0Tdi90+LwWekIpbzOMvGVWYq6yNFCPGMPf258LFXccBr936DNuN5WocDIdnIii9zuvLkli5OwdjEtlDqMz5fvYAbVXVtlP5bI3PuRMQcRMhyUxFdSMmUC3aYrrRukPWPyqB1T163uR8RLErV3RqAdA32sRDF9fexCnvx/484LQJ9fOITkeaqknkVWLv9us1MFfYPQwSE+ZDMQ3D7Hnt9yTnraJCp+UvcOK0wTmDKfOxXqW2yHu4N1MaiUQSGs+PQFy5mJhZ62HuKLN5sgp1krXhxX+GRwpPtpZZK8RJtcfmv5YrSsyYgVftpbWVa3TEoGM8B7zJiL82n2BD1WzYgIDslkqUTlgaFKS6aDfq3Tifyp80/OHTcJr0hDPhwnInBcm5y4ci0fnhtPcZB0zNmb6ScOFC1inrWN8y98RgIBN14iWpcVTKwjOKtNmD/sn4tcSIPeKEic73TKaGJ5A3Eazkue0rTLkCcq24VxdzjRrXPUc/5MGEowewNfKZcQVvQ/FdcFVvZ1NTUF19H5pRy73PPtL3sG1HcFSmv6FCDw0RdgNSZP3yq8uXkzXTAbe1BWOEYyDaYoZFb5THcpYezWElZ+eQ7KWunXY30Io7wRKfVBvLZxzmvuNbOQePqdp1+wUC14dOhf8Up0rnEjMOJ5/oSwji9ogdQp39/iYkWkQcbtxgs8HenhSfwYJPCVgDOMB8g5R+S3zF90pK5FvCwUAg10QbwcqkZlylUOXG6llleu0rWjWg3EOOGwjmuIWFVpU2gV4Hb+4jdiHMqC3Uo4PjOiVtoEDXJtEZe+NBvVrTGhkZVMG2gtQ/e9S1LzITiJsSq63IqAmPiUP7/prYUMJ2yZClL6q58vuBk+45OvjSjEFF+WuoBVO7uRtWJ8TzKnwrTa05BvozF9VZ8x+J8CegqHJK6IRBt1pecKe7j4kYv5Mgi8oy4/q8/DSehrtFZmRemhia6
 GzEnFExV
 5TqiKefI3kBL7KBiKk/zlzkcM/Fk6d9Cp1PYxKenP5kXKyeqfCTk94KkXYErv0VnFbrt+xyhUIz/4G9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
page->mapping") we get such an error message if CONFIG_ZSMALLOC=m:

 WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa8/0x1c0
 CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
 pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000100423a60
 a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffffffffffffff
 a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000100423ae0
 t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000000000001
 t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 90000000023fcc70
 t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff00010eb800
 s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000219cc40
 s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 90000000025b4000
    ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
   ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
  PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
 CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
 Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420000
         90000001004236a0 90000001004236a8 0000000000000000 90000001004237e8
         90000001004237e0 90000001004237e0 9000000100423550 0000000000000001
         0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fcc58
         9000000100420000 90000000024c6848 9000000002416848 0000000000000001
         0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb800
         0000000000000000 90000000021fd000 0000000000000000 900000000205cf30
         000000000000008e 0000000000000009 ffffff00010eb800 0000000000000001
         90000000025b4000 0000000000000000 900000000024773c 00007ffff103d748
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<900000000024773c>] show_stack+0x5c/0x190
 [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
 [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
 [<90000000004af408>] compact_zone+0x558/0x1000
 [<90000000004b0068>] compact_node+0xa8/0x1e0
 [<90000000004b0aa4>] kcompactd+0x394/0x410
 [<90000000002b3c98>] kthread+0x128/0x140
 [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
 [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88

The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
CONFIG_ZSMALLOC=y, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
access zsmalloc_mops because zsmalloc_mops is in a module.

To solve this problem, we define a movable_ops[] array in mm/migrate.c,
initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
let the page_movable_ops() function return elements from movable_ops[].

Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mapping")
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V2: Use EXPORT_SYMBOL_GPL_FOR_MODULES instead of EXPORT_SYMBOL and fix build.
V3: Use register interface instead of set array directly (Thank David).

 include/linux/migrate.h |  5 +++++
 mm/balloon_compaction.c |  6 ++++++
 mm/migrate.c            | 38 ++++++++++++++++++++++++++++++--------
 mm/zsmalloc.c           | 10 ++++++++++
 4 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..9009e27b5f44 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -79,6 +79,7 @@ void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
+int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
 
 #else
 
@@ -100,6 +101,10 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 {
 	return -ENOSYS;
 }
+static inline int set_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	return -ENOSYS;
+}
 
 #endif /* CONFIG_MIGRATION */
 
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 2a4a649805c1..03c5dbabb156 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -254,4 +254,10 @@ const struct movable_operations balloon_mops = {
 	.putback_page = balloon_page_putback,
 };
 
+static int __init balloon_init(void)
+{
+	return set_movable_ops(&balloon_mops, PGTY_offline);
+}
+core_initcall(balloon_init);
+
 #endif /* CONFIG_BALLOON_COMPACTION */
diff --git a/mm/migrate.c b/mm/migrate.c
index 425401b2d4e1..9e5ef39ce73a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -43,8 +43,6 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
-#include <linux/balloon_compaction.h>
-#include <linux/zsmalloc.h>
 
 #include <asm/tlbflush.h>
 
@@ -53,6 +51,33 @@
 #include "internal.h"
 #include "swap.h"
 
+static const struct movable_operations *offline_movable_ops;
+static const struct movable_operations *zsmalloc_movable_ops;
+
+int set_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	/*
+	 * We only allow for selected types and don't handle concurrent
+	 * registration attempts yet.
+	 */
+	switch (type) {
+	case PGTY_offline:
+		if (offline_movable_ops && ops)
+			return -EBUSY;
+		offline_movable_ops = ops;
+		break;
+	case PGTY_zsmalloc:
+		if (zsmalloc_movable_ops && ops)
+			return -EBUSY;
+		zsmalloc_movable_ops = ops;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_movable_ops);
+
 static const struct movable_operations *page_movable_ops(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
@@ -62,15 +87,12 @@ static const struct movable_operations *page_movable_ops(struct page *page)
 	 * it as movable, the page type must be sticky until the page gets freed
 	 * back to the buddy.
 	 */
-#ifdef CONFIG_BALLOON_COMPACTION
 	if (PageOffline(page))
 		/* Only balloon compaction sets PageOffline pages movable. */
-		return &balloon_mops;
-#endif /* CONFIG_BALLOON_COMPACTION */
-#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
+		return offline_movable_ops;
 	if (PageZsmalloc(page))
-		return &zsmalloc_mops;
-#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
+		return zsmalloc_movable_ops;
+
 	return NULL;
 }
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c5e56a65354..6c574ab8abff 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2246,8 +2246,15 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static int __init zs_init(void)
 {
+	int rc;
+
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
+#endif
+#ifdef CONFIG_COMPACTION
+	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
+	if (rc)
+		return rc;
 #endif
 	zs_stat_init();
 	return 0;
@@ -2257,6 +2264,9 @@ static void __exit zs_exit(void)
 {
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
+#endif
+#ifdef CONFIG_COMPACTION
+	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
 }
-- 
2.47.3


