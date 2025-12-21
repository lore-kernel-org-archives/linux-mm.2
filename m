Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E4FE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B076B0088; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D50A6B0096; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDF86B0088; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E84466B0096
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96BE55AC95
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
X-FDA: 84245072856.18.AA9BFEB
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36BB1120012
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=OOTm0N9Q;
	spf=pass (imf29.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7Y9Jpp91tliTBnX3yTO+/rJorulikI8K3gXOhRJ/5I=;
	b=xktbCKQZ/f2F9uJvnKn/2uHJjIEVRbtamXECuR+8wmKMnZClzd7Re1jeO1oD6fvEulkeus
	c2E3b6C18WzUgsF4Uys+JbcJTU4lUcCAp0N+prhhjI2UBhA0uetzASiZQ0UPz5m1ougVBx
	VF3fyfijsQFtQLwbP4lD5jBrLve6PLc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=OOTm0N9Q;
	spf=pass (imf29.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359787; a=rsa-sha256;
	cv=none;
	b=cQUwn6b5Pk5JOCCYBI3O0qPa/K7bE66dvyvZy7xl3NJqOdsgx1g8gw6z7xyneIEi+TcyVw
	nx6tp6EvH35bzXkxVXCyGKDsps1rt3To7+s+ljVswe4UzmxT0Gawsp2FHyAx1yIxh0YjZb
	17QofiVKfHHU4PE8b2fvYgrrDteRVOI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=v7Y9Jpp91tliTBnX3yTO+/rJorulikI8K3gXOhRJ/5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOTm0N9QKa8v9m4VWiu2o+fqq181KmnELB4psxxqAEB0zXvuFUJZZxE7KUFKys2pd
	 h/bjuWvBGwIRsw6ca+9e4wPohsv9V7yQdW5dzufgdSzzCH/L0mHE9PVJX6Bpyte10e
	 713DTDSOs8Np0TN/AkGttfNNpC+v60uU0oD/9mb7uveuup16nvMMhjniwyGtb9df6q
	 ucdPJDnzKZpBbX+BrdCHdUub5uMr1/uatB1vdpag54wmnalERafvRUVVFHT/q1plez
	 3T6CsujturCb8OwUzGZbDBqpLClrB3ynH6chxMKkPbXoB61BV4UJIAHcRvrP1+eGPF
	 aD8rKkZeUpxjg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYQ3CMRzdCf;
	Sun, 21 Dec 2025 18:29:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH v1 4/5] mm: Take into account hierarchical percpu tree items for static mm_struct definitions
Date: Sun, 21 Dec 2025 18:29:25 -0500
Message-Id: <20251221232926.450602-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36BB1120012
X-Stat-Signature: 6crdgjnszor85xe9igdqk9au87ce75i3
X-HE-Tag: 1766359787-338803
X-HE-Meta: U2FsdGVkX1/0EzDlW284++PmCLS3kDGQkn3+N7Kli7OZ6XPOkfGCF3tF29fXrLKLgR4TJZpSBvo8ngLeVDjFcKX8/oRcTFf6QU8Z9SpnUHdZuizobkeuJZdtppcV3Kmf9HL06673rRrfAUZTC3zjZ+ApwxydVhCcqi7qIthdFwxRKD0SWzT3+HKFx+Q8UBSoddyH3NZcxefxwTeqNvC8ouaTmS8+q1LkLk6im8hkrII6xnAZajosiH1fKm+mjTVcei5jF58fTqwwZYnS0woakRVlVm5L8kxPesfSD06f716hNSDurfbGp1X5oEiuYi+fXaj3hqQIgiznwFPfjYjwnL/EWp+ke5eMaX9DtnuJ5K4oY3OPNitglB5LM0bTsFYh1D5PxE/1xcoU1+gwM4o5BXM25HLDASoxUZFR42V1c9/sAgH4oraDVoC5lQW0Z1HekOFiQbF266gsYKOru3asV1I7Ej+Het2FDj/t5v4T8ertGcFZ0WM6aqoZ6AxtQQG9WklVNxrr0WPU58+MYCTGF8IZEQDWO+YYzA7pQfw40Of/DINAvS6i/A9oT7XzdbQFzBX2USzRGWnmgFsiuMQIAlxx2uLoXH8rBrG29YNWxY/vxOA+tIPuUJfxosa3AkUhHu2khsPrXZgxts37K3Vcm5nTuzsG+ktTcOU4tCfrwBq56cIzJTroJztVi0RCWY0oQkGzljIW5VvRB4LfDXk9hCNDTPxHO9WXQMP1Rn00kpvyqM6/gOykF+bTO/Tiw4PY5jKPDTY/kcba5BmP5Y4IHt56odvmhuzmcT9W1EwuF+mm9ea0PiiTH7j1qjobmVTyviDLaKhqPGSeiv5JOfPCNOismp8zrDZUwOzqOREg0W4uvZOzxST2bbZoHiJYPFHBc9wV86DFawnxIZzkAbLEFolwCHSWFMHGbQiOc/wuqTPcljsWUtdDbEtzdNfpfygil3J/UquHAbFjxi2qYHB
 uKRRkVt6
 ZOzMx+xawnWsZzMgDjZ9S+CgYq35eHQWIPdpD4EYvzSJINn2LDv6YgGPCf5Cnp3CbCLN+6QV1Kn0WWEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both init_mm and efi_mm static definitions need to make room for the
hierarchical percpu counters items.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org
---
 include/linux/mm_types.h            |  6 ++--
 include/linux/percpu_counter_tree.h | 51 +++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index aefa64db3499..234374c46b71 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1366,9 +1366,9 @@ static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
-#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
-{								\
-	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
+{													\
+	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE - 1] = 0	\
 }
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 0daf09e08111..2e8b1ce5cd13 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -10,6 +10,52 @@
 
 #ifdef CONFIG_SMP
 
+#if NR_CPUS == (1U << 0)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	0
+#elif NR_CPUS <= (1U << 1)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1
+#elif NR_CPUS <= (1U << 2)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	3
+#elif NR_CPUS <= (1U << 3)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 4)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 5)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	11
+#elif NR_CPUS <= (1U << 6)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 7)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 8)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	37
+#elif NR_CPUS <= (1U << 9)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	73
+#elif NR_CPUS <= (1U << 10)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	149
+#elif NR_CPUS <= (1U << 11)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	293
+#elif NR_CPUS <= (1U << 12)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	585
+#elif NR_CPUS <= (1U << 13)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1173
+#elif NR_CPUS <= (1U << 14)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	2341
+#elif NR_CPUS <= (1U << 15)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 16)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 17)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	8777
+#elif NR_CPUS <= (1U << 18)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	17481
+#elif NR_CPUS <= (1U << 19)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	34953
+#elif NR_CPUS <= (1U << 20)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	69905
+#else
+# error "Unsupported number of CPUs."
+#endif
+
 struct percpu_counter_tree_level_item {
 	atomic_t count;			/*
 					 * Count the number of carry fort this tree item.
@@ -18,6 +64,9 @@ struct percpu_counter_tree_level_item {
 					 */
 } ____cacheline_aligned_in_smp;
 
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	\
+	(PERCPU_COUNTER_TREE_STATIC_NR_ITEMS * sizeof(struct percpu_counter_tree_level_item))
+
 struct percpu_counter_tree {
 	/* Fast-path fields. */
 	unsigned int __percpu *level0;	/* Pointer to per-CPU split counters (tree level 0). */
@@ -92,6 +141,8 @@ int percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
 
 #else	/* !CONFIG_SMP */
 
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	0
+
 struct percpu_counter_tree_level_item;
 
 struct percpu_counter_tree {
-- 
2.39.5


