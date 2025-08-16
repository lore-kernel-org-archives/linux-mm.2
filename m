Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E626ACA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B1F8E023A; Sat, 16 Aug 2025 03:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3DA8E000B; Sat, 16 Aug 2025 03:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FAE98E023A; Sat, 16 Aug 2025 03:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C18A8E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:22:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEB821A037A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:22:22 +0000 (UTC)
X-FDA: 83781777324.13.327F590
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BCD1140003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:22:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755328941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jzJQlwGyX4KDtsrdfO+7aP0RfBre28IrfjR7QX4Bngg=;
	b=0fJYg39vbdN4dbLgs6cXxPiM8ffHysbRhc6Xq+Gi1D0lvd6tYmQTgLB4jhqgbCy0WsI1mL
	fVhqY0wDI8Y26QLcrhimX9ee5q5jy+rrjYH/pOZSUcvQtRbxUpW0yjZOH4CRY4zNTIoSRw
	eiEOR/LkgApodynt1cSbnMcpkevcH9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755328941; a=rsa-sha256;
	cv=none;
	b=GWEr7AmIoOvRcwwhqwIQCZznK6UZl7vOXLy5k5Ne3SXA24twzu3QYFybJNxY993aLw4/TF
	QEK0GlenboERaR90yZ9ZaB6nW9POvEESBnkCmjCu6Ne4hCjPqb4TlPS6krDFq9OJOxejPn
	MTMg1wBVSKifcxYFe0CnydA8pkx/sCY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
Received: from loongson.cn (unknown [223.64.69.45])
	by gateway (Coremail) with SMTP id _____8AxnOKnMaBoTadAAQ--.21788S3;
	Sat, 16 Aug 2025 15:22:15 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.45])
	by front1 (Coremail) with SMTP id qMiowJCx3sGhMaBotYVQAA--.34096S2;
	Sat, 16 Aug 2025 15:22:14 +0800 (CST)
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
Subject: [PATCH V2] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Date: Sat, 16 Aug 2025 15:21:49 +0800
Message-ID: <20250816072149.1952348-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx3sGhMaBotYVQAA--.34096S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4xGF4kWFWrWF1fAr43Jwc_yoWxZw13pF
	48Jw48Gr48JrWUJr17AF18Ary5WwsruF48J3srGr1UZr1rXw17JFyUtFW7Zrn8Wr1UJF17
	JFnrtw1Yyr4UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8xuctUUUUU==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BCD1140003
X-Stat-Signature: fypgnfx3nhb5oduew6asbfaa1k4hign8
X-Rspam-User: 
X-HE-Tag: 1755328938-158641
X-HE-Meta: U2FsdGVkX1+r0xjmSOIOiUqI6oRDhZM4EmLjrslvOW6OKYpWML5uMRIVBhOF5lNOrKR2AHr2ewQ18HZ7D8mpvPrPpQlIXQqUx/ZD3xd4brATBO8kABZJh5/q95y06s9CCNaXaJyEdeDGJIlbBDMfqZ6MT+Gevtgar+Uw1eWXG1Aj7EyX4IlX/uL1nSgAHcPecO43jQwVTdQDaGulf1jzLByDh0q7R1Yd5rTfepzh75PbvSKr3pgmaUGmty67C1H298+Ry4CochwZzP3V/G42EXqejCnm6wyYnLWqlk5lbNM8kD/ff5rC9okBqUHMGX0/T8FAujerNUZoibVqZRq8lSa4zUketTsNmzB6KZe7dxfJ8zGaxp2hu8FrZmJ3iqyyBkUVW6jkGG18RBY9/BwehoKVUjyqOnuGYY/GQxXiL8JMAPELhdTLUclm/N+qUZJ4Ri0i/Aj5awezsCBo2aud1ZmwAjBCs0yZ3SAoD1vSdn1y4FeOMZxQEWxYOPbCRBHZ5nq7FSP2dkSv9+2taV4UxRZwTO7ZYCXg6+lpqZD1NAs6+cbmQuD3A8cJSnx0SSQU6cSVBgGfo3pGAWo1pNqlWZEMYEJcMLri+6EVyo5WMasAJhmr5gFoD1vDRr2UZ5QddXhCo03ZZIbZauJlYmDnQ/PiMKSjvxi3iA9VRa569ZoLJ6L77M/hZqPfh75cT4qrgPkUpQrk0OWrfJQYjnxJDvXmCKZZM1k6URcx4IugcwhWIK+kHL08xvfgd2Zp/x61msHHnx9AxLKvd84P/+KtLV/9Xdv6Ul+EuAD2PcLFdMDHYgJJuimjL1TbJTP9wYtKFYB91nKgbN1EhLtMOs9aXA8VPSbMofRTiqn2kvm/MuVrG38KFpybX6x4+o8oEfPbjGGqcpjvdCRc8G1fIfwwjiwQh5dkasg5USreIEQ2fGwgjwKC2dBiQAjtRrFLvpXmEv9jPemV1Nku3G90aVm
 Itd18uCm
 VMoQOY3l/9nqYdQ2Gu8z8OlwTxGw+OSePcVbMxMFpA/CndWPXZPW6Rx/y3K6VSrjZ8O8+
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
+EXPORT_SYMBOL_GPL_FOR_MODULES(movable_ops);
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
+#ifdef CONFIG_COMPACTION
+	movable_ops[MOVABLE_ZSMALLOC] = &zsmalloc_mops;
+#endif
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
@@ -2255,6 +2258,9 @@ static int __init zs_init(void)
 
 static void __exit zs_exit(void)
 {
+#ifdef CONFIG_COMPACTION
+	movable_ops[MOVABLE_ZSMALLOC] = NULL;
+#endif
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
 #endif
-- 
2.47.3


