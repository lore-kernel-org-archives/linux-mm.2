Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B32606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L8PB1mZW
Received: by kanga.kvack.org (Postfix)
	id CD97A6B05B3; Thu,  5 Nov 2026 22:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89DD6B05B4; Thu,  5 Nov 2026 22:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC78D6B05B5; Thu,  5 Nov 2026 22:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC326B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:43:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 534D9C0C80
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:43:39 +0000 (UTC)
X-FDA: 85403299758.19.DA0F664
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf08.hostedemail.com (Postfix) with ESMTP id 09227160005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:43:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8PB1mZW;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793936617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JQAg5RHkJoANhMG92M9Mgy2coDcnt7Ko3EBsxYqcnSY=;
	b=XX48QiplQP17IPzIkvKaEnyUsrQ1d3ibv5eWGz0k4Cnd+TVDlRAjC1prBcD85ymx7bT/8q
	uoDTueZiwPsprIWrBtDuRR/ovJWvutwRW+rD0VAGYmNp3p3+IM+wYxFtlk8P8wBwyy0h5A
	R1c/1cCmCerOFRQ0kedIPA8irFKfqg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793936617;
	b=OOppnxP0eYGd9ITGi46oZftdFU0HeK/bpkKBfIlY9kXL2ackj9HEa3OYN6ePnsp0amUqGr
	Vcgv98poY0xr3kvMUQN8ODaXvnCoHQzjNITn0YkRptc2q6Auj/DJgfEF3br7uPZsHmSJ2J
	gJZeq9uO2VISEmWIzXhpDN+Nw2R3noU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8PB1mZW;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e+UAVA/LhE49Kt9vT3PU3TfPUWWDUeAp4ghXNdKq4Gk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793936615; v=1; x=1794541415;
 b=L8PB1mZWk4/sBqODYjrNN/fI+1N5AUO5+fPUl2zGSRT/m6n/w2bC9SLsulDtlkhNc9EHoyuq
 Oe1jldp9ZcukVkifsXUa1kmxG2tO/ps1QEkvpL27fy84avm+ZLqoZtIYu0GGYRRbP/e1CXOSUMW
 MAC+o+b4RJItUoTPfdz22fRk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 70031cc14879d107;
	Fri, 06 Nov 2026 03:43:35 +0000
X-Mizu-Trace-ID: 70031cc14879d107
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] ksm: add merge_only_zero_pages to merge only empty anonymous pages
Date: Fri,  6 Nov 2026 11:43:04 +0800
Message-Id: <20261106034304.231809-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 09227160005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p4dpsu7nga9thzwz8qw5jiwc9ystypet
X-Rspam-User: 
X-HE-Tag: 1793936616-851336
X-HE-Meta: U2FsdGVkX186qRRQZLtOLl/lGL+U+cQmCToGtPwRxzJ7Dbe/ngToa0DuJvRzbmjqSqqYGJG+T1FpP5SCMSJVK31BhFccSj77YVTi01rPuNL4X+kVimQZOVySwA2TjjsPj/+ZBosaUAc3Fp5SVuZv/YGOxzxf1g9VxnXp0ihWyRaCfqibnHE8XGre2Da3+V2uucx7a8XW2GEcx8TUrokvHnV4dJIZtN2JshB1cqeJ8FxqUXUoK/nAb5MTXeQYi9/wicPHrLKOA/skVQwNmUY+se3RCzWtOVZyV6zeGffl31oO83k6oloPqYhEyvupxbY+nnykfWDTGhQjja15Kj7jEyN/LH6S/LixT83yVzkVhWrUQ1UEREDZ2CvzBteBFdpBrJ1etYOFuADrbJcWR7M3xq5Zte/cY8y4C2Q2s78Qsx6EJqqyRsODMnM7ZLmRY/H/mRmxsmb3tFoMN6tCYEjF0c2CU8wrptURy/CLMNuCu323Nedu1/uOpC1XvXiZStO6a3/Tl0HUO0/8LcjWIz5mh6TGTtuU3uw3NNqmNAhk/uKS0fdy6NTRQmB2KbRBPxpkvM0xZYaKLOWrl2vgyy6XyRJP/SXskUyUD4o8hgk3UPA94dFKKmBHq1yuTv8/1A8h9qIRwLJFSXHTVMXFlKcDrHnUaEkLv2IMvrEAQQETttOF0/c4mbPgouCbXBXI0XBuCn5tU/fKkHFdvm/FDJjoDpERoYubwKgLg5n9W6f4FxCtW5y9lSITj1k32S8iGeQttZQVSyaeXNmem0gnzjGij8XWVpmAlWkN13HF4SoMlRvsUItm1+LXhNc5y4gTZRvNMVU/wVTE9Iy61nESId7u4Bnq4SZ818WmkCOZVPyia/CIYtWmDM2gzGk/QdfBz3F0NCVGpbwh+t1TCJii/zQwiM8r3Vg1TSQCYRwgdPfn460Fk1AAKrqGz4wlq6sUkYvVBo43nNMeJKh4g7uKmcn
 ahzR4j5J
 G91IAQuTyW2ykm51HG6adQ0HUS0vE41FbCn+lREg07x4G7BYbm9eFKyAWsS+B1w63yHfPyN6pHhq2YSvFTpApNAFlxa/idbML6Z0x3GnlaNIHTEuyMVzsE6Hzfzb2WkynV2pZfLBLxu/LWoovaN16bGN/bsB05tTfuuit6rC8hhyPE+PIwU7wc5hChW2t4prnyiOmMeuT1fHBKHOTGD+eu5SL+u1W9s3gtNyRLqi8D3DTKDQsZbybcSc6CHmAxtfTkOmSy0M4acYmeRWG48zvm+3xWc2z+BpwJo49nsDqoTmmGEhghsqweMSfy9c6+SgFqFyKWxfB5FZ5uvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Xu Xin (vivo)" <xu.xin@linux.dev>

Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
which, when enabled, makes ksmd merge only empty (zeroed) anonymous
pages with the kernel zero page and skip the stable and unstable trees
entirely for pages that carry data.

The attribute requires use_zero_pages to be 1, and the two are kept
consistent by symmetric constraints: it cannot be enabled while
use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
off while it is active (-EBUSY). The new attribute can be changed at
any time and is only effective for pages merged after the change.

Benefits in three aspects
=========================
- Memory saving:
  On memory-constrained systems such as Android and embedded devices,
  zero-filled anonymous pages are the largest source of duplicate
  anonymous memory. They are produced by userspace allocators: the
  zeroing of freshly allocated Java objects and buffers in the ART heap
  (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
  preallocated media buffers. Merging them with the kernel zero page
  frees a significant amount of physical memory, which matters as DRAM
  costs keep rising. With this enabled, we measured 100MB–300MB saving
  tested with several popular applications on aarch64 (Android).

- CPU overhead reduction:
  Merging only zero pages also reduces the overhead of ksmd. A page that
  is not merged with the zero page carries data and can never be merged
  with the zero page, so there is no point in searching the stable tree
  or inserting it into the unstable tree for it. Skipping those tree
  operations for data-bearing pages reduces both the CPU time and the
  rhashtable memory footprint of ksmd, which makes zero page merging
  practical on low-resource devices where full KSM scanning would be too
  expensive.

- Security:
  Finally, this shrinks the KSM side-channel attack surface: only zero
  pages are ever merged, so the sharing status of data-bearing pages is
  no longer observable through KSM timing side channels.

Note
=====
- Suitable for Android, embedded and low-memory devices, where zero-page
  deduplication is wanted but full KSM scanning is too costly, and reduced
  KSM side-channel exposure is desired. Many handset vendors may prefer
  this knob, which can be used as a default fallback policy.

- Not suitable for server and virtualization workloads containing many
  non-zero duplicate pages, where vanilla KSM provides better memory
  savings.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
#Reviewed-by: Huan Yang <link@vivo.com>
#Cc: Wang Xiao <xiao.wang@vivo.com>
---
 Documentation/admin-guide/mm/ksm.rst | 40 ++++++++++++++++++++-
 mm/ksm.c                             | 53 ++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index c329ca747b8c..dd8ef2e4fdc2 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -128,10 +128,48 @@ use_zero_pages
         KSM for some workloads, for example if the checksums of pages
         candidate for merging match the checksum of an empty
         page. This setting can be changed at any time, it is only
-        effective for pages merged after the change.
+        effective for pages merged after the change. Turning this off
+        while ``merge_only_zero_pages`` is enabled fails with EBUSY;
+        clear ``merge_only_zero_pages`` first.
 
         Default: 0 (normal KSM behaviour as in earlier releases)
 
+merge_only_zero_pages
+        specifies whether ksmd should only merge empty (zeroed)
+        anonymous pages, with the kernel zero page, and skip the stable
+        and unstable trees entirely for pages that carry data. This
+        requires ``use_zero_pages`` to be 1; it cannot be enabled while
+        ``use_zero_pages`` is 0, and ``use_zero_pages`` cannot be turned
+        off while it is enabled (the write fails with EBUSY).
+
+        This is useful on memory-constrained systems (e.g. Android and
+        embedded devices) where the main source of duplicate anonymous
+        memory is zero-filled pages produced by userspace allocators
+        (for example the zeroing of freshly allocated Java objects and
+        buffers in the ART heap, ``calloc``/``memset`` in native code,
+        and pre-allocated media buffers). Merging only those pages
+        avoids the per-page cost of searching and inserting into the
+        stable and unstable trees for data-bearing pages, which reduces
+        the CPU and memory overhead of ksmd. It also shrinks the KSM
+        side-channel attack surface, since only zero pages are ever
+        merged and the sharing state of data-bearing pages is no longer
+        observable through KSM.
+
+        - Suitable for: Android, embedded and low-memory devices, where
+          zero-page deduplication is wanted but full KSM scanning is
+          too costly, and reduced KSM side-channel exposure is desired.
+          Many handset vendors may prefer this knob, which can be used
+          as a default fallback policy.
+
+        - Not suitable for: Server and virtualization workloads containing
+          many non-zero duplicate pages, where vanilla KSM provides better
+          memory savings.
+
+        This setting can be changed at any time, it is only effective
+        for pages merged after the change.
+
+        Default: 0 (normal KSM behaviour)
+
 max_page_sharing
         Maximum sharing allowed for each KSM page. This enforces a
         deduplication limit to avoid high latency for virtual memory
diff --git a/mm/ksm.c b/mm/ksm.c
index 64f9e803b99e..a89b0f1c1065 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -297,6 +297,13 @@ static unsigned int zero_checksum __read_mostly;
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
+/*
+ * When set, ksmd only merges empty (zeroed) anonymous pages with the kernel
+ * zero page and skips the stable/unstable tree entirely for pages that carry
+ * data. This requires ksm_use_zero_pages to be enabled.
+ */
+static bool ksm_merge_only_zero_pages __read_mostly;
+
 /* Skip pages that couldn't be de-duplicated previously */
 /* Default to true at least temporarily, for testing */
 static bool ksm_smart_scan = true;
@@ -2369,6 +2376,15 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 
 		if (!try_to_merge_with_zero_page(rmap_item, page))
 			return;
+
+		/*
+		 * merge_only_zero_pages: only empty (zeroed) pages are merged,
+		 * with the kernel zero page. A page that reached here was not
+		 * merged with the zero page, so it carries data; skip the
+		 * stable and unstable trees for it.
+		 */
+		if (ksm_merge_only_zero_pages)
+			return;
 	}
 
 	/* Start by searching for the folio in the stable tree */
@@ -3730,12 +3746,48 @@ static ssize_t use_zero_pages_store(struct kobject *kobj,
 	if (err)
 		return -EINVAL;
 
+	/*
+	 * merge_only_zero_pages depends on use_zero_pages: refuse to turn
+	 * the latter off while the former is active, so the two cannot
+	 * silently diverge.
+	 */
+	if (!value && ksm_merge_only_zero_pages)
+		return -EBUSY;
+
 	ksm_use_zero_pages = value;
 
 	return count;
 }
 KSM_ATTR(use_zero_pages);
 
+static ssize_t merge_only_zero_pages_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", ksm_merge_only_zero_pages);
+}
+static ssize_t merge_only_zero_pages_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int err;
+	bool value;
+
+	err = kstrtobool(buf, &value);
+	if (err)
+		return -EINVAL;
+
+	if (value && !ksm_use_zero_pages) {
+		pr_warn_once("ksm: merge_only_zero_pages can only be enabled "
+			     "when use_zero_pages is 1\n");
+		return -EINVAL;
+	}
+
+	ksm_merge_only_zero_pages = value;
+
+	return count;
+}
+KSM_ATTR(merge_only_zero_pages);
+
 static ssize_t max_page_sharing_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
@@ -4061,6 +4113,7 @@ static struct attribute *ksm_attrs[] = {
 	&stable_node_dups_attr.attr,
 	&stable_node_chains_prune_millisecs_attr.attr,
 	&use_zero_pages_attr.attr,
+	&merge_only_zero_pages_attr.attr,
 	&general_profit_attr.attr,
 	&smart_scan_attr.attr,
 	&advisor_mode_attr.attr,
-- 
2.34.1


