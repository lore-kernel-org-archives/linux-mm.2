Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86581E6748C
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105696B008C; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9CE6B008A; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB466B0092; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2CCC6B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62F45160991
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
X-FDA: 84245072856.24.05F3300
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id C9BC140002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cnc5f6qK;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bggeet/K7f/LykaY9i5CXV4NsffNnOWo1S/CrVN1N6M=;
	b=0UmW9QGW3c6OVyOjt03IrbWMjnoyYuefHiwivm1p/nkTmeFumau0Lx9TISt86Ls0+rn1Lq
	yrRr01iO30T51ixbKSnPHdIXef7Q4eHEWBC4ydiv0Y5Os8/RbV9V50lO6CtxwY4ecTac3u
	3+kHNJY6JJEoxupj3IKVCrkzqchXMeQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=cnc5f6qK;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359786; a=rsa-sha256;
	cv=none;
	b=a9eqfEShlGCaU88RcuTcpPe6QI+SNi1zuIoqdykjp43fB3X5QGGi20Wc2IAMQy766aDgaS
	TgOf/f7O6rItGrAm+8A2IQ1z/aU3mM3YJmxI77b2lM+1WzevdHW055rUXkG4Rkn1UXQGjl
	4Ec+WDFGp/aJvJ8kPHugtmdX99+D34g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=bggeet/K7f/LykaY9i5CXV4NsffNnOWo1S/CrVN1N6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnc5f6qKjNWTp5CYe3FtMEqXjaEtwaL5KnWMM06i0PVH+WPEPspj9cYDBTvZjbAPl
	 LzhO4ykoMqjew6uDzSWYAvjT8sxTLGeysoAT8/VuHK8OtbbJhFcglGCLLqg6OM/ZkN
	 tvdwIJRnC5/3tsUuE7EGMICCVIIMcQ9G/qN7IPcE3YGzNsCiCPLx2qF4E8Udx0p2A+
	 PweF6eTwZbqfCL1RTbXB3X3iGZMNYbMtwpkC5bWW1IvClcXM2Hm6U9NyHK/jREt4e+
	 up7IXK3+ZoobM0LaQmmelFCWFxr5h46TnAOOrWVS5lDZTwNHt8mgMKVRphjb1MvLTe
	 JYWkOBKaZF2aA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYQ1VJHzdCd;
	Sun, 21 Dec 2025 18:29:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH v1 2/5] mm: Rename cpu_bitmap field to flexible_array
Date: Sun, 21 Dec 2025 18:29:23 -0500
Message-Id: <20251221232926.450602-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9BC140002
X-Stat-Signature: hs6pfunhathdkkf7tb7qbeuxte9sgouo
X-HE-Tag: 1766359786-220135
X-HE-Meta: U2FsdGVkX18jleILM54WYQR7g6Qaf2vdsnvnmtVyhSbps4l0FDYcUIv7/QHwSIcn58HeyjOW3gOfjJ5Enm8oyy4OP1w+dMlbjrkbhypKwotXQyzuCS0oi7YBtLeZR7DjCAHfvGkMFs3dvUalYC6+GQkRTwq/IQAuEZy041TGJ/VTIVUj3fLgIv5p2JxVAQs0G3erFfk9VJ3sifIPMCvUYrlpgbtBc6bCjCzPN6QISbdGAuRiiT8pGSD/g8nBP2uvHNjNrEQLTSX3FUkoGf/rQ+pXnhfKC+xciLrIyOucJvKRccukX2v/SkpYp9cOo+TcpxEdJnCIE+FXixIX/LUYm+ZQ/UJOXM/hSx5UBdSdpB9Krt0Fyrb9PJZmsZVkkqgusR/KgwWyQEAPvWN4rnYgPtzCavbinUs5fJcJ+YK200KSIogGHmzGGLwB0rT2wg7uOpogVoBpyBQ4MsXEFa251Bn5w/Zg/Dr3nYtMrAdnH04yL29cClgMhCraDXIsPxnGbGIWTq9I1qupkgo0PjdQoe+9e5REY7mFCPjc+jBhvCgoArRWbte1zMGoLKfSzSU3HPFpnIpSXTZ4gVmL8SLNHuZaBAC1w24DOEQwYDmcV2QuhUge6aErsjeEyewcc/qH8XQqjGVTu7lxdXq9ffypPW6+kCio1eXXrL2hKcp4BC13amrToGnpCOBKGKh3H7J0S/Y2lv6G40ocL/E9n1VthUwV56F786N/uSPb8eCFsJLB7cug0dORLtLQf+d60BO/cz7IV0O+hOQwVBidQ+ScRzY4iMGMVJcSD4a3+OQ/sAA1jUiCDoojvS7Nhn4EZQF6UHN3KdRJ9FzsjfL/KZ47irpbdW1TDd5lqmeTzzQxlW8tuTi7foRICZiDtQ3kVbL2ExayOpGlqHfAlgUQjtzb5PSRBLVcSA+obOm5ur3CDCU4VhnLolwnOVEmgvYUujwW5Qtl3vax2c5OQBoVbO9
 GKaFMuQN
 w7dLoFeJ4LqAItLVNeh6QGpgGUH2une/zzqUQyRadrL/v2JYAUhJ48T2iTaaCTJFkgmvZpkZQl6NqvG+2EfJTQPAFKIOzSYdKq6LdXPMHvqLwFaGQAY89b82bGSX0sZCJ3C0lJXbgb4k0JLICg0aBVc/TpRbXSt9YpjE2dw6oWI2nnAqejFVLH5d+1FWLKdr5TDGEkZz6I7Y2aGdPbVCUcsJv1zlWgn4wXTtaaQw1da0O8pmj+HlzmHtLU9JOYIhlVszkKnU78oeW4yOXsxkcVxEvNpLUP8OwX1FBzqYqy1b8M+8A3N2/eXz8R6RQYLVtyoz8M5V3pb4r2IVlj+bGINqjjCqVR2TxrJhl8RbHAyG8dqDz/TmvoQnmkAQkfUBg0PB7k0cB8VzH0HC9gRmhGbLRZzceKa+QDCW5M9hXywrtzZxHsVYQRC4CPR2gofqcIqvqP2rNyqdZuP1aRNswksXM9tx18zuys5KnOUsUUAKoz5j+hoWQ4LNV7EIpW3SJxg61H0epMg3cq1EVStzhOzENTD8HUT8NrYAThtr2tFKzxAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cpu_bitmap flexible array now contains more than just the
cpu_bitmap. In preparation for changing the static mm_struct
definitions to cover for the additional space required, change the
cpu_bitmap type from "unsigned long" to "char", require an unsigned long
alignment of the flexible array, and rename the field from "cpu_bitmap"
to "flexible_array".

Introduce the MM_STRUCT_FLEXIBLE_ARRAY_INIT macro to statically
initialize the flexible array. This covers the init_mm and efi_mm
static definitions.

This is a preparation step for fixing the missing mm_cid size for static
mm_struct definitions.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org
---
 drivers/firmware/efi/efi.c |  2 +-
 include/linux/mm.h         |  2 +-
 include/linux/mm_types.h   | 13 +++++++++----
 mm/init-mm.c               |  2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a9070d00b833..3f5c2ae50024 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -73,10 +73,10 @@ struct mm_struct efi_mm = {
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-	.cpu_bitmap		= { [BITS_TO_LONGS(NR_CPUS)] = 0},
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock		= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.mm_cid.lock),
 #endif
+	.flexible_array		= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 };
 
 struct workqueue_struct *efi_rts_wq;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 890dab720f75..8d9e3239d2cc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2853,7 +2853,7 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
 {
 	unsigned long ptr = (unsigned long)mm;
 
-	ptr += offsetof(struct mm_struct, cpu_bitmap);
+	ptr += offsetof(struct mm_struct, flexible_array);
 	/* Skip cpu_bitmap */
 	ptr += cpumask_size();
 	/* Skip mm_cidmask */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a6287d07efb7..1531df8cda52 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1329,7 +1329,7 @@ struct mm_struct {
 	 * The mm_cpumask needs to be at the end of mm_struct, because it
 	 * is dynamically sized based on nr_cpu_ids.
 	 */
-	unsigned long cpu_bitmap[];
+	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
 /* Copy value to the first system word of mm flags, non-atomically. */
@@ -1366,19 +1366,24 @@ static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
+{								\
+	[0 ... sizeof(cpumask_t)-1] = 0				\
+}
+
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 	unsigned long cpu_bitmap = (unsigned long)mm;
 
-	cpu_bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	cpu_bitmap += offsetof(struct mm_struct, flexible_array);
 	cpumask_clear((struct cpumask *)cpu_bitmap);
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	return (struct cpumask *)&mm->cpu_bitmap;
+	return (struct cpumask *)&mm->flexible_array;
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -1469,7 +1474,7 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 {
 	unsigned long bitmap = (unsigned long)mm;
 
-	bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	bitmap += offsetof(struct mm_struct, flexible_array);
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
diff --git a/mm/init-mm.c b/mm/init-mm.c
index a514f8ce47e3..c5556bb9d5f0 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -47,7 +47,7 @@ struct mm_struct init_mm = {
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
 #endif
-	.cpu_bitmap	= CPU_BITS_NONE,
+	.flexible_array	= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 	INIT_MM_CONTEXT(init_mm)
 };
 
-- 
2.39.5


