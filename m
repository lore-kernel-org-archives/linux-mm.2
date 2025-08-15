Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87B2CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630BD90022E; Fri, 15 Aug 2025 05:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2F18E0002; Fri, 15 Aug 2025 05:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9CF90022E; Fri, 15 Aug 2025 05:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 398798E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:05:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB4B8C0919
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:05:57 +0000 (UTC)
X-FDA: 83778409554.20.2FF73DC
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf03.hostedemail.com (Postfix) with ESMTP id A251C20007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:05:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6En4VU5/0WXeDsLtcf9l/eQWoBiOrr+HcqUwsUpOOww=;
	b=uhonzjE1yzFeupbH41KeSbcAksTXv9b4UB1Ietn1GDd2SV2EtRdvLqaj+svvtkjzD34yU7
	BazbdeH9okOlu0gsNIu835EI+5jqoSt8v5BdvWiVLtWwlFKGiX/pZxpvV2NQjcOfatosYu
	znXT2QCCz3nXT1hHB7iv4w8c/cf4IW0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248756; a=rsa-sha256;
	cv=none;
	b=0PVf88OryWNAiYqUdo3lEw2kpe4jSbLS+YXYtsY85RlGh7H7CLtfz21raUB6Ium/K+w0yr
	lnn8mvTMLTOwBJkyd12gn8VoM7Hry4CP7ySTQWGWlEbLj+2Au5Pe9bOdc/a3pjnp9BpGj7
	SZzQdvPUSq9J74pojSuwO1sb8uQRrRI=
Received: from loongson.cn (unknown [223.64.69.45])
	by gateway (Coremail) with SMTP id _____8BxJHBw+J5ovTpAAQ--.15433S3;
	Fri, 15 Aug 2025 17:05:52 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.45])
	by front1 (Coremail) with SMTP id qMiowJDx7sFs+J5olLdNAA--.32429S2;
	Fri, 15 Aug 2025 17:05:51 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Date: Fri, 15 Aug 2025 17:05:39 +0800
Message-ID: <20250815090539.1578484-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx7sFs+J5olLdNAA--.32429S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4xGF4kWFWrWF1fAr43Jwc_yoWxCFykpF
	48Jr48Gr48JrWUJr17AF1UAry5Wws7uF48Jr9rGr1UZr1rXw17JFyUtFW7Ars8Wr15JF17
	JFnrtw1Yyr4UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UMpBfUUUUU=
X-Stat-Signature: 369y6pjhihgr8yzoxhcu1qtpztduzjkq
X-Rspam-User: 
X-Rspamd-Queue-Id: A251C20007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755248755-906023
X-HE-Meta: U2FsdGVkX1+e/E2vMgrMYOeq+qqRHL+8FjRGdN4tnvcspPSzTmn5llQ5U4sBCFYdu+uhzHHlK45V21OYZQLtvSpUXnM0t6MqcKOYiGFVbyVBczIsnoUijqminoXZQt3psIYexSAup5WtyKABC7y2XOmrNna4TJxvRIxymjFshpNq0G9AKahww4m2NpI/vg/az5ProhPYJaFrXwlgO4YiqWqlp+qrDFUCoHaPC55xaqta3lLMzt1rgPD/X5htfQmC9H4z3v2aYb+OdAKZZxlOk4dR8YjjzGn2edh+l39/uDPiCVPv0qZJNzoU3tosCXqqtZA1BxLTwoF3kYg9DtycUKKjkEdYAxwgljyE668JfxuXDSm23/d0oIBQtqKvQgST+UN+vAlgvKTgogfxMgrDZ3h+cWcGhRmjO2+eGazOH2Nxa0JDiDql2DtZrlxfOP5i1LCH2usYZYJ1g9bknQB8C2bHWtTSjN4DdvtgRZzGxJ2zldZaGOb3Vj+VnmnkhVymyEt5/H+Bctbah+Zcf31s+kIscaAXsG1tTh+IbYTbNJY9R12d99iQdtziRjKjMXTUaoFs0hGleNzrLGFqKKmMIydYXCz3v45NlHkfz0cLR0pc7Sswb1wBpWvG6prqjO5cz64hWdB4YncAJ/9n4PF+q/NzeeQwEn4vqS9f81w4609q85psbZA2ntnF64UFZOOaw3e32/UlF+zXBTLr+JbnM5gWcUoiGQI1msiNyvgu8RAJYThbL8gsGerDxyQ3QZCuZ3TkbTVGhgCnHavzmXJNSFJtoMKyIgXoCZzhYKoIKMh3cszl3p+LqvJZenWXsMko9mgKJGSqdszq/4UMmJeO60HtR8pOpoHCpQ0i/fMVYvIMRWegOllTEvEnVAM8PiJEhdZLwPF3jOVx6ulOqp6KRZc2MIvC/o297UP//jJuK8Sk1iLMVDbMWhWzskZC1vj/7G8D68yMGpyiTKwxYov
 TNJd6gX3
 j/UfIiRVGKxmiRa1h/TeZwiTMFHvX4Ke32ec5VzY+Ffiw4i8=
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
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 include/linux/migrate.h |  6 ++++++
 mm/balloon_compaction.c |  7 +++++++
 mm/migrate.c            | 16 ++++++++++------
 mm/zsmalloc.c           |  6 ++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..58fac171e4d5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -57,6 +57,12 @@ struct movable_operations {
 	void (*putback_page)(struct page *);
 };
 
+#define MOVABLE_BALLOON		0
+#define MOVABLE_ZSMALLOC	1
+#define MOVABLE_MAX		2
+
+extern const struct movable_operations *movable_ops[MOVABLE_MAX];
+
 /* Defined in mm/debug.c: */
 extern const char *migrate_reason_names[MR_TYPES];
 
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 2a4a649805c1..a1d2625b5c39 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -254,4 +254,11 @@ const struct movable_operations balloon_mops = {
 	.putback_page = balloon_page_putback,
 };
 
+static int __init balloon_init(void)
+{
+	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
+	return 0;
+}
+core_initcall(balloon_init);
+
 #endif /* CONFIG_BALLOON_COMPACTION */
diff --git a/mm/migrate.c b/mm/migrate.c
index 425401b2d4e1..92918fab3e1a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -53,6 +53,10 @@
 #include "internal.h"
 #include "swap.h"
 
+const struct movable_operations *movable_ops[MOVABLE_MAX];
+
+EXPORT_SYMBOL(movable_ops);
+
 static const struct movable_operations *page_movable_ops(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
@@ -62,15 +66,15 @@ static const struct movable_operations *page_movable_ops(struct page *page)
 	 * it as movable, the page type must be sticky until the page gets freed
 	 * back to the buddy.
 	 */
-#ifdef CONFIG_BALLOON_COMPACTION
+#if IS_ENABLED(CONFIG_BALLOON_COMPACTION)
 	if (PageOffline(page))
 		/* Only balloon compaction sets PageOffline pages movable. */
-		return &balloon_mops;
-#endif /* CONFIG_BALLOON_COMPACTION */
-#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
+		return movable_ops[MOVABLE_BALLOON];
+#endif /* IS_ENABLED(CONFIG_BALLOON_COMPACTION) */
+#if IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)
 	if (PageZsmalloc(page))
-		return &zsmalloc_mops;
-#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
+		return movable_ops[MOVABLE_ZSMALLOC];
+#endif /* IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION) */
 	return NULL;
 }
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c5e56a65354..052fcc0d29e5 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2246,6 +2246,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static int __init zs_init(void)
 {
+#ifdef CONFIG_MIGRATION
+	movable_ops[MOVABLE_ZSMALLOC] = &zsmalloc_mops;
+#endif
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
@@ -2255,6 +2258,9 @@ static int __init zs_init(void)
 
 static void __exit zs_exit(void)
 {
+#ifdef CONFIG_MIGRATION
+	movable_ops[MOVABLE_ZSMALLOC] = NULL;
+#endif
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
 #endif
-- 
2.47.3


