Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFE3606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DWdRjL0A
Received: by kanga.kvack.org (Postfix)
	id 4CE346B05B1; Thu,  5 Nov 2026 22:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6916B05B5; Thu,  5 Nov 2026 22:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD3B6B05B6; Thu,  5 Nov 2026 22:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C86D6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:49:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76C8D120C61
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:49:16 +0000 (UTC)
X-FDA: 85403313912.18.EDB33AF
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf25.hostedemail.com (Postfix) with ESMTP id E41C5A0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:49:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DWdRjL0A;
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793936954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gzmTqCFSUU3YnOiqsWsMdvE4YgD8TliJQMwfHUZqHOo=;
	b=pWbdk8mdG1MNKsvagom0m08Yx3IPYIsTtkjn0KmVv+TLzdpOpZQtgryetNIOifY2UzOLcY
	3CIhQiyitaP+6yQrH4TlKPZwGY839pV0slXaH9rbQV9s0L1AUv3CNqNtWxwLU+K/qXIZIJ
	xY1hi/6KgTPa0SqjiM1LDDirDVG7LJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793936954;
	b=j35awzKAbgr4bL2SqqKNKYGuNDyDiBiN7XG7LNXkWoFduAAzETk4hC5T69rHcNJKtaYro1
	bZbuNopaBZCmkAwWuDZQKSQqysh98K/xTXRyGfmglQOV8Rpma17tMM2UAQ9hG14xV3rVUs
	63THeev4Whj0Id4alu0+mNZ306SMSMI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DWdRjL0A;
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=81DNLlC4718c1g3u503W4Y4wryUuoOORedAKYhXuIH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793936948; v=1; x=1794541748;
 b=DWdRjL0Aps7DKZGuiFAmKy70LLvONfLG6F6Tqh0H4KGwmd1nharDCH0B6sXM5D5b4EJ3/B2T
 DAN0mMCYTlarD4QDjiucJpY7Ob6gN3D5Yruk7xUCDbUns/vI9CVH5iOnFERbCnOB6HPib0MN6Jz
 VDqEWnOp3ajBXD4RdQ+wz60M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 10e53f909884d578;
	Fri, 06 Nov 2026 03:49:08 +0000
X-Mizu-Trace-ID: 10e53f909884d578
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
	linux-doc@vger.kernel.org,
	Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty anonymous pages
Date: Fri,  6 Nov 2026 11:48:41 +0800
Message-Id: <20261106034841.233085-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E41C5A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bt89nkxbh1y8bac3sakyoxke3acbakd5
X-Rspam-User: 
X-HE-Tag: 1793936952-453521
X-HE-Meta: U2FsdGVkX19c7AJxK4RFdMJpE0TmWj/folf/GQf/mbFZ0a8ZunDYkOSxlV82IUkc2woJKAqVu9O8Eyvqx4Sse4M+WQcFnTvMwFLI7hcq5qG2ip7itZlP3rD2uEzEK+dog6SAT9BSumHNYXReiR6fXO2B9HtMxbHIFuNzJakQwAVtbmW8DAC2Cdk2FF4ApHMS979majYbws7cb+d3zZOp1nV2h8hbNBRJ5i5aKPcGz0tNmAwcGSjmYhMEuXw2RgCIjha5jazvxL7+sWE8gtUtJvAh54GE6aC9TU8kSbtGs1fVyzb0kGcJjUNDpXkXSVLKjBBaobZS4f3R4/2Fe+RKOZhfz+W63/E+uLyreo9Bz/2eeUb1Ocr5WbdYBxRp/dIpwSAL6upOPq3DFUcQaS2lRXeyKW0+R+zMx7BwEsHJ38DBLDUYYvQkuf9i424EonzkkmIm1NyHMXFHycdeh4vl0FC0BLNWz8cWMiNUqg2j9BjyydPdSgpsWuIjFzZbRyt5wnbCkJmIJBZIyb6dG4xEv7MgpM/MSykJW6cOAaQ4WC/KluUp4xkoCPgkogEXN2Ur+J3R6Eq9p/NRUU4q/7MZCU/PzhFrdYO551zeVQVvxa8KeGGBwcXSPQZ58FXQyOs8Ka1JXRHhsGWq+AmqZzpVmpnH+D5qjOuvoe80wjGqs5ORfO/R2yh3Ql5Z6fU95Z0v9Wo9qvQCrPU8crnUCezJOD6gYJn8DBcd4jJsnPl1Y6x87PI19kMHtVSmbO9HlcVZ1yTJX02mR49xFq2vLzFnxiCrJ82Iavd6wKYXeWoDP7s+CJy51MvsvT/+Dm9siMkYaxAeQ7NGXkX0I+p7btQAaGrDQgwmH/FJuqWZjDhictY7tRyfRUGaaRc9rEfyZ5eRV2lgs0z40UWKJEl98xq6aWC/qMBWRgufZVkUFAlI8Cl6HeESEIyMOSlewFGpcgoQOIyepClvioWTJVsM19U
 eq5lDWvH
 3F/yltDB1wrMOHQP/qxq4UkyLOlhBUnX/ga6tHAAF7LDOSN1wNz0wdkaxWSRvnBT/81HenHDmhYtEy3wdLFuPrM7Vqoqn7nUdwYRX0TQh2pNbPP8fXureFB95+kImrjBVOe72jeDiaLEn/zp/9eoloSun0+BU9R12V7bPdXgBNGUW0BcQ8P/E/dnwG1O749qR9AH1AyfuLkztfi+PEOZGkB27KnaR/UoT2Pvu8YuIGrWhR1j9+peACfhLEHwLQD4fcrb18pDBkTQaTcNdD2yL1MmJYChwakh/2lIPoSE1Zo+ajYTmPocDPspTENzEyIAzuvI8r8z404it22c=
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
Reviewed-by: Huan Yang <link@vivo.com>
Cc: Wang Xiao <xiao.wang@vivo.com>
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


