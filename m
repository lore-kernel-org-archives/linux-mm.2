Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA07FCAC592
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6518E000B; Tue, 16 Sep 2025 22:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6F08E0001; Tue, 16 Sep 2025 22:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE44A8E000B; Tue, 16 Sep 2025 22:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD1698E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:50:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82A2B866B1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:38 +0000 (UTC)
X-FDA: 83897214156.19.2E19B8D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id B319E1C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aZphLv+z;
	spf=pass (imf21.hostedemail.com: domain of 3-yHKaAgKCLQdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-yHKaAgKCLQdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758077436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wAnisGajbcYa8IELNM7cwb6nACj53AhyM2UU/05uLE=;
	b=gRepX3CrnomnIkTx8nAlsbLwwgVx+6uNLjtd3DGJN8MIoQQCgOkIZTiHw4l2C1k/4ZBUV0
	5abyy8yv1RMngaWM/QBs7iQWZ+UncK+ijO0jBp69P9aPmyMDOLoSKLLFmZ6ZjidFYqYgkt
	fPfzV32f2tazZq0+Nro3mDgf/lIMWXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758077436; a=rsa-sha256;
	cv=none;
	b=oi7LniX1clm2Oqps54abYBq31uZqDMyjtKMy3T77vsmVZBE3lwpT0aqU2MzDpD+T9GM4cJ
	SPauQj7JAVCf5PsqrvAzjob4ROB2U3PNy19nGMZ+DqZLNIDgOEkvy5fNpBQP/zv8l87zNc
	cIcF4vbM7+6GSixN2uEKhO9YUHY1fg8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aZphLv+z;
	spf=pass (imf21.hostedemail.com: domain of 3-yHKaAgKCLQdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-yHKaAgKCLQdUmihgcoaiiafY.Wigfchor-ggepUWe.ila@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2659a7488a2so57838455ad.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758077435; x=1758682235; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wAnisGajbcYa8IELNM7cwb6nACj53AhyM2UU/05uLE=;
        b=aZphLv+zMV9llofWcyfYO3USwB38b13JJmI159s7m4DfndAssYAiTiR/dbpwPQQ+ep
         FjR1LnH5Ov82KdsFt/P3b4o7hiA9DFFeQJ5MUPG8LaXqCthtI4sJU4HfcItO0/CxeECv
         0Ug7Q9zH1XC2tfOh/qRy3ee96cqYFQTjDIr+kw2nBTnuw78h9AtOnM/8D/fYl323Py3h
         L+qUiozsXF/x8SebuTbBUmW9dhm/yFEfaLN56Lw9BCc/SUlVuCuy10FjD8H4pqABsQa2
         f12B2e4yE6cOLykeluh3u1ml9tFaUUkJjimnq3VExykMaw4jaMRIOrQVzwDx0BPALGRJ
         FQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758077436; x=1758682236;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wAnisGajbcYa8IELNM7cwb6nACj53AhyM2UU/05uLE=;
        b=XTbDg9TaviT63ppZ/z1YBEBTTGEd4nj3tS020VXxz/ZMTxcPec+yFQn97Pvihu1dcQ
         j7o8Lskn61v8mCPRYtRONnXynLsPpUYpa5Md4tgOAgRmBoQmjCAIkxgUo21XAiuBIxMh
         qMbwKRHd3reyhX6YGyWT2QZAmmB7fLv1UGYb4bs6vAGmPy2QncYfF803RPDvFiPBIHSj
         MVnArRSg5ffWvUEZLMHY+b8R3PCwle1rqH5fZxVmzxz/9PHYZkpSYiiBBtCURfzkN0uA
         pciMuFj7XRNgYy18ffLtc5LOLoS2lqUDgejriXC0Dxa+bZGqGJ0B3NTL0B90UiZFicik
         yvdA==
X-Forwarded-Encrypted: i=1; AJvYcCUH/E6wIn1ZcNsuQNG83Isn1LdEaG7V1h2OYZtm1KASBrW1IxLEaunC4NA7uz722/zom86OA5ho4A==@kvack.org
X-Gm-Message-State: AOJu0YyMm04BzT5fpsKnNVkbhlYdyrHmtA7kZyiFkmI3jqw2Qn1zsm0e
	IpvgCAAZcngkjv5h4NvfVFM9wNBWdHc6koqBkXgkH9pS2hTl0U+X538N85E0XTHow8X2KOS1zze
	nFCVeKfjuEHAjtg==
X-Google-Smtp-Source: AGHT+IEpg0QQAP6xJjBpVWMcX87q/1xHOaFPzqUck3HzcEwQKjUg13HBNsgVlIXij2DbclZb+DlqACShaMT9mQ==
X-Received: from pluq14.prod.google.com ([2002:a17:903:4b4e:b0:267:b6b7:9ac3])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b24:b0:24d:4d8b:a17 with SMTP id d9443c01a7336-26813cf391amr6167545ad.56.1758077435641;
 Tue, 16 Sep 2025 19:50:35 -0700 (PDT)
Date: Tue, 16 Sep 2025 19:50:16 -0700
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917025019.1585041-2-jasonmiu@google.com>
Subject: [RFC v1 1/4] kho: Introduce KHO page table data structures
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B319E1C0004
X-Stat-Signature: uc7aa7n5nsp3jsxhdma8dnctd7ctc6yr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758077436-908675
X-HE-Meta: U2FsdGVkX180Mk/blK9EkqVTIvPpXi5SoCNZYqIzz52osl77t/RHY4pDsf8u4KlVGas0U2wX3RXD9CoF90mxDPokrGauUzIYTbxFp0utpo0lMiLMM4liPjdt0i2xD7UBQXirTBmbZlp0h2M0k8HVwLO8oM/qI9S0hf2wRz5f8kg19dpnk1qM0t9CQ38Vjw4rqqqLGPil8MQbrG2venn7C1wPXY1syK7WEqQb9M56EZQ91IMP/TOpWwjmoJw9MqDuwxn3e9MA2ZFPHiUtQvF5xELD1rrWBCs336QfccYqOarG+um+eaCyyQILYTSFy8Ln2FZxWuohO5Qv7l3udskxcINCSZGy3lNPOs15WR1nWQN5qmw1TDvQ0ZWufzM+82/AZEc8glPnuwsrJjDF9pvi0p7IWgcxLrCc+bxTig8/3ao26F4vC6bExgJL+SwiBGWcTeNOORzIOSM4goO63QQPPIx1BYJa65sEA9xKlzDYtDEjUw6dD58ROmEBFPBY9ZGm6bdWUZT//NkA9dN+RxKKKQQuxfNiJ+vieigFyxVmYH4qNZEXbqLdyql6BI1wsRNU8ZTgJcTiPvLmywHoFI/9AdbYU2+bqagKq+AltSGkqruAStpCOe/b/Vq3htDZvJ3X0809I5+PztlmNiHuWcfd/erXwuVoeYFJ5itndcvPYxc5J28tJ2o1DcLC1EAsECBkTVwEiUceKvXB0YcmClXTVNqIcXqTE9DKw3S8+7Uyv78Fnmgc+K/hkCp/vm5Pcr7GX1aHXdBOSglehZcLLVZ3C6YBlELWRqPTNoT2BQ4Lp+FLG2S94HTt+JjO1rceOdcpBh0Khp7QLXmdatgh+DkoBWQKFZwzQbN/JpteSp0pTjh2Jh1//wlvqNOmT/d7o3TwFNoZpIPu31AAuF4WdMVUNcldi9Nn5ldYhUxwMXTKvegFS9m3wZ89QOCny5vjXluNpPpIYu0Jo/Z/g6OVr0M
 BksXz3jL
 o2t+Q0sQtDsPM6BzayJXcuxcGRvmnJzPp3/D+YPbTT81TuFHDD7khEcxbjSMbx//Ltj2ju3DuUmzYW/4W/JzvSVlPiAB+4UtHiyqpdk11P7+yCYs82GsrqFE/C/zB4eq7IPfc/YhpkfY3ujvqTkZsZXr/ouhkhhAz7g25/ZKFvIoqFhGVTZOYm2Ehoch0gfprNWiF5CvLcnV/eEw5jpA8VLUd9FBJXLZiVhnS/5lHq9rNaDV2TFC27NmqaHRyjrTqlKpS5ho700mE4gmRDlU6dNOG5g99hf6m9+4hMEk+bWtPM1MpummhBVJ4QJqN070iICUSucMIFLAw0htMK8cicxSyLsGSO/AJCK1xyn0fi+0KxXyuNwArVV05kvMGqRHhcqYH8Rvz6ywnDfpJLqGaV6xNEMDnK6QFt3xXlI7EfO7G9isZK7HLgDb7Mz4vgjw8T55aj5u3T1sOUT87NLL/iIeNb1D3UKGb2/AvdQfgpRLd9dC0+0bQBH7hixVmyW+hwGYM4V5wMfmO2Bra/SiaL82ODWooCpNZkQiHatNaekjTJO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a page-table-like data structure for tracking preserved
memory pages, which will replace the current xarray-based
implementation.

The primary motivation for this change is to eliminate the need for
serialization. By marking preserved pages directly in these new tables
and passing them to the next kernel, the entire serialization process
can be removed. This ultimately allows for the removal of the KHO
finalize and abort states, simplifying the overall design.

The new KHO page table is a hierarchical structure that maps physical
addresses to preservation metadata. It begins with a root
`kho_order_table` that contains an entry for each page order. Each
entry points to a separate, multi-level tree of `kho_page_table`s that
splits a physical address into indices. The traversal terminates at a
`kho_bitmap_table`, where each bit represents a single preserved page.

This commit adds the core data structures for this hierarchy:
  - kho_order_table: The root table, indexed by page order.
  - kho_page_table: Intermediate-level tables.
  - kho_bitmap_table: The lowest-level table where individual pages
are marked.

The new functions are not yet integrated with the public
`kho_preserve_*` APIs and are marked `__maybe_unused`. The full
integration and the removal of the old xarray code will follow in a
subsequent commit.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 kernel/kexec_handover.c | 344 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 344 insertions(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd..0daed51c8fb7 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -46,6 +46,350 @@ static int __init kho_parse_enable(char *p)
 }
 early_param("kho", kho_parse_enable);
 
+/*
+ * KHO page tables provide a page-table-like data structure for tracking
+ * preserved memory pages. It is a hierarchical structure that starts with a
+ * `struct kho_order_table`. Each entry in this table points to the root of a
+ * `struct kho_page_table` tree, which tracks the preserved memory pages for a
+ * specific page order.
+ *
+ * Each entry in a `struct kho_page_table` points to the next level page table,
+ * until level 2, which points to a `struct kho_bitmap_table`. The lowest level
+ * (level 1) is a bitmap table where each bit represents a preserved page.
+ *
+ * The table hierarchy is shown as below.
+ *
+ * kho_order_table
+ * +-------------------------------+--------------------+
+ * | 0 order| 1 order| 2 order ... | HUGETLB_PAGE_ORDER |
+ * ++------------------------------+--------------------+
+ *  |
+ *  |
+ *  v
+ * ++------+
+ * |  Lv6  | kho_page_table
+ * ++------+
+ *  |
+ *  |
+ *  |   +-------+
+ *  +-> |  Lv5  | kho_page_table
+ *      ++------+
+ *       |
+ *       |
+ *       |   +-------+
+ *       +-> |  Lv4  | kho_page_table
+ *           ++------+
+ *            |
+ *            |
+ *            |   +-------+
+ *            +-> |  Lv3  | kho_page_table
+ *                ++------+
+ *                 |
+ *                 |
+ *                 |  +-------+
+ *                 +> |  Lv2  | kho_page_table
+ *                    ++------+
+ *                     |
+ *                     |
+ *                     |   +-------+
+ *                     +-> |  Lv1  | kho_bitmap_table
+ *                         +-------+
+ *
+ * The depth of the KHO page tables depends on the system's page size and the
+ * page order. Both larger page sizes and higher page orders result in
+ * shallower KHO page tables. For example, on a system with a 4KB native
+ * page size, 0-order tables have a depth of 6 levels.
+ *
+ * The following diagram illustrates how a physical address is split into
+ * indices for the different KHO page table levels and the final bitmap.
+ *
+ *      63      62:54    53:45    44:36    35:27        26:0
+ * +--------+--------+--------+--------+--------+-----------------+
+ * |  Lv 6  |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1 (bitmap)  |
+ * +--------+--------+--------+--------+--------+-----------------+
+ *
+ * For higher order pages, the bit fields for each level shift to the left by
+ * the page order.
+ *
+ * Each KHO page table and bitmap table is PAGE_SIZE in size. For 0-order
+ * pages, the bitmap table contains (PAGE_SIZE * 8) bits, covering a
+ * (PAGE_SIZE * 8 * PAGE_SIZE) memory range. For example, on a system with a
+ * 4KB native page size, the bitmap table contains 32768 bits and covers a
+ * 128MB memory range.
+ *
+ * Each KHO page table contains (PAGE_SIZE / 8) entries, where each entry is a
+ * descriptor (a physical address) pointing to the next level table.
+ * For example, with a 4KB page size, each page table holds 512 entries.
+ * The level 2 KHO page table is an exception, where each entry points to a
+ * KHO bitmap table instead.
+ *
+ * An entry of a KHO page table of a 4KB page system is shown as below as an
+ * example.
+ *
+ *         63:12                       11:0
+ * +------------------------------+--------------+
+ * | descriptor to next table     |    zeros     |
+ * +------------------------------+--------------+
+ */
+
+#define BITMAP_TABLE_SHIFT(_order) (PAGE_SHIFT + PAGE_SHIFT + 3 + (_order))
+#define BITMAP_TABLE_MASK(_order) ((1ULL << BITMAP_TABLE_SHIFT(_order)) - 1)
+#define PRESERVED_PAGE_OFFSET_SHIFT(_order) (PAGE_SHIFT + (_order))
+#define PAGE_TABLE_SHIFT_PER_LEVEL (ilog2(PAGE_SIZE / sizeof(unsigned long)))
+#define PAGE_TABLE_LEVEL_MASK ((1ULL << PAGE_TABLE_SHIFT_PER_LEVEL) - 1)
+#define PTR_PER_LEVEL (PAGE_SIZE / sizeof(unsigned long))
+
+typedef int (*kho_walk_callback_t)(phys_addr_t pa, int order);
+
+struct kho_bitmap_table {
+	unsigned long bitmaps[PAGE_SIZE / sizeof(unsigned long)];
+};
+
+struct kho_page_table {
+	unsigned long tables[PTR_PER_LEVEL];
+};
+
+struct kho_order_table {
+	unsigned long orders[HUGETLB_PAGE_ORDER + 1];
+};
+
+/*
+ * `kho_order_table` points to a page that serves as the root of the KHO page
+ * table hierarchy. This page is allocated during KHO module initialization.
+ * Its physical address is written to the FDT and passed to the next kernel
+ * during kexec.
+ */
+static struct kho_order_table *kho_order_table;
+
+static unsigned long kho_page_table_level_shift(int level, int order)
+{
+	/*
+	 * Calculate the cumulative bit shift required to extract the page table
+	 * index for a given physical address at a specific `level` and `order`.
+	 *
+	 * - Level 1 is the bitmap table, which has its own indexing logic, so
+	 *   the shift is 0.
+	 * - Level 2 and above: The base shift is `BITMAP_TABLE_SHIFT(order)`,
+	 *   which corresponds to the entire address space covered by a single
+	 *   level 1 bitmap table.
+	 * - Each subsequent level adds `PAGE_TABLE_SHIFT_PER_LEVEL` to the
+	 *   total shift amount.
+	 */
+	return level <= 1 ? 0 :
+		BITMAP_TABLE_SHIFT(order) + PAGE_TABLE_SHIFT_PER_LEVEL * (level - 2);
+}
+
+static int kho_get_bitmap_table_index(unsigned long pa, int order)
+{
+	/* 4KB (12bits of addr) + 8B per entries (6bits of addr) + order bits */
+	unsigned long idx = pa >> (PAGE_SHIFT + 6 + order);
+
+	return idx;
+}
+
+static int kho_get_page_table_index(unsigned long pa, int order, int level)
+{
+	unsigned long high_addr;
+	unsigned long page_table_offset;
+	unsigned long shift;
+
+	if (level == 1)
+		return kho_get_bitmap_table_index(pa, order);
+
+	shift = kho_page_table_level_shift(level, order);
+	high_addr = pa >> shift;
+
+	page_table_offset = high_addr & PAGE_TABLE_LEVEL_MASK;
+	return page_table_offset;
+}
+
+static int kho_table_level(int order)
+{
+	unsigned long bits_to_resolve;
+	int page_table_num;
+
+	/* We just need 1 bitmap table to cover all addresses */
+	if (BITMAP_TABLE_SHIFT(order) >= 64)
+		return 1;
+
+	bits_to_resolve = 64 - BITMAP_TABLE_SHIFT(order);
+
+	/*
+	 * The level we need is the bits to resolve over the bits a page tabel
+	 * can resolve. Get the ceiling as ceil(a/b) = (a + b - 1) / b.
+	 * Total level is the all table levels plus the buttom
+	 * bitmap level.
+	 */
+	page_table_num = (bits_to_resolve + PAGE_TABLE_SHIFT_PER_LEVEL - 1)
+		/ PAGE_TABLE_SHIFT_PER_LEVEL;
+	return page_table_num + 1;
+}
+
+static struct kho_page_table *kho_alloc_page_table(void)
+{
+	return (struct kho_page_table *)get_zeroed_page(GFP_KERNEL);
+}
+
+static void kho_set_preserved_page_bit(struct kho_bitmap_table *bitmap_table,
+				       unsigned long pa, int order)
+{
+	int bitmap_table_index = kho_get_bitmap_table_index(pa, order);
+	int offset;
+
+	/* Get the bit offset in a 64bits bitmap entry */
+	offset = (pa >> PRESERVED_PAGE_OFFSET_SHIFT(order)) & 0x3f;
+
+	set_bit(offset,
+		(unsigned long *)&bitmap_table->bitmaps[bitmap_table_index]);
+}
+
+static unsigned long kho_pgt_desc(struct kho_page_table *va)
+{
+	return (unsigned long)virt_to_phys(va);
+}
+
+static struct kho_page_table *kho_page_table(unsigned long desc)
+{
+	return (struct kho_page_table *)phys_to_virt(desc);
+}
+
+static int __kho_preserve_page_table(unsigned long pa, int order)
+{
+	int num_table_level = kho_table_level(order);
+	struct kho_page_table *cur;
+	struct kho_page_table *next;
+	struct kho_bitmap_table *bitmap_table;
+	int i, page_table_index;
+	unsigned long page_table_desc;
+
+	if (!kho_order_table->orders[order]) {
+		cur = kho_alloc_page_table();
+		if (!cur)
+			return -ENOMEM;
+		page_table_desc = kho_pgt_desc(cur);
+		kho_order_table->orders[order] = page_table_desc;
+	}
+
+	cur = kho_page_table(kho_order_table->orders[order]);
+
+	/* Go from high level tables to low level tables */
+	for (i = num_table_level; i > 1; i--) {
+		page_table_index = kho_get_page_table_index(pa, order, i);
+
+		if (!cur->tables[page_table_index]) {
+			next = kho_alloc_page_table();
+			if (!next)
+				return -ENOMEM;
+			cur->tables[page_table_index] = kho_pgt_desc(next);
+		} else {
+			next = kho_page_table(cur->tables[page_table_index]);
+		}
+
+		cur = next;
+	}
+
+	/* Cur is now pointing to the level 1 bitmap table */
+	bitmap_table = (struct kho_bitmap_table *)cur;
+	kho_set_preserved_page_bit(bitmap_table,
+				   pa & BITMAP_TABLE_MASK(order),
+				   order);
+
+	return 0;
+}
+
+/*
+ * TODO: __maybe_unused is added to the functions:
+ * kho_preserve_page_table()
+ * kho_walk_tables()
+ * kho_memblock_reserve()
+ * since they are not actually being called in this change.
+ * __maybe_unused will be removed in the next patch.
+ */
+static __maybe_unused int kho_preserve_page_table(unsigned long pfn, int order)
+{
+	unsigned long pa = PFN_PHYS(pfn);
+
+	might_sleep();
+
+	return __kho_preserve_page_table(pa, order);
+}
+
+static int __kho_walk_bitmap_table(int order,
+				   struct kho_bitmap_table *bitmap_table,
+				   unsigned long pa,
+				   kho_walk_callback_t cb)
+{
+	int i;
+	unsigned long offset;
+	int ret = 0;
+	int order_factor = 1 << order;
+	unsigned long *bitmap = (unsigned long *)bitmap_table;
+
+	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
+		offset = (unsigned long)PAGE_SIZE * order_factor * i;
+		ret = cb(offset + pa, order);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int __kho_walk_page_tables(int order, int level,
+				  struct kho_page_table *cur, unsigned long pa,
+				  kho_walk_callback_t cb)
+{
+	struct kho_page_table *next;
+	struct kho_bitmap_table *bitmap_table;
+	int i;
+	unsigned long offset;
+	int ret = 0;
+
+	if (level == 1) {
+		bitmap_table = (struct kho_bitmap_table *)cur;
+		return __kho_walk_bitmap_table(order, bitmap_table, pa, cb);
+	}
+
+	for (i = 0; i < PTR_PER_LEVEL; i++) {
+		if (cur->tables[i]) {
+			next = kho_page_table(cur->tables[i]);
+			offset = i;
+			offset <<= kho_page_table_level_shift(level, order);
+			ret = __kho_walk_page_tables(order, level - 1,
+						     next, offset + pa, cb);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static __maybe_unused int kho_walk_page_tables(struct kho_page_table *top, int order,
+					       kho_walk_callback_t cb)
+{
+	int num_table_level;
+
+	if (top) {
+		num_table_level = kho_table_level(order);
+		return __kho_walk_page_tables(order, num_table_level, top, 0, cb);
+	}
+
+	return 0;
+}
+
+static __maybe_unused int kho_memblock_reserve(phys_addr_t pa, int order)
+{
+	int sz = 1 << (order + PAGE_SHIFT);
+	struct page *page = phys_to_page(pa);
+
+	memblock_reserve(pa, sz);
+	memblock_reserved_mark_noinit(pa, sz);
+	page->private = order;
+
+	return 0;
+}
+
 /*
  * Keep track of memory that is to be preserved across KHO.
  *
-- 
2.51.0.384.g4c02a37b29-goog


