Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAD160711C4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RelAKPru
Received: by kanga.kvack.org (Postfix)
	id B38106B05B8; Tue, 10 Nov 2026 02:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FBC6B05BA; Tue, 10 Nov 2026 02:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C586B05BB; Tue, 10 Nov 2026 02:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD7E6B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEC7F4082E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:10 +0000 (UTC)
X-FDA: 85418423580.27.ACB561A
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id B333B14000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RelAKPru;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794296709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dI0t/SwdqvYchxdAM18dF6Ej68UZ7/5g2MyxsU/FwM=;
	b=MK1dlbecH90w/Ghi7yagQSA8BsT7FbmApewWO/JmRG4tW/2C+BxNGwu3hM/zJnV6ybYuQD
	4ndoYW7AYoLqGyL2wbtakXXS7h05MczUiNg9aT1Adx/u6DgU70Sjtc5wdAMAFHP+hJuKvO
	tY+qZ/N9ZhgfKx/bUZh3cK8rLVwC4I4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RelAKPru;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794296709;
	b=ZSUnOuEGMecQz1EIDgkRSluBBJfn4jZeFRtMK8qm8nYZHoSAsUq+7uHl6kattcX1gpwrvX
	clOBGzE6Fm7KB/7hsVGYEXbRgLVv16x2gWOVRFPoc7JRxf2H87FC6d6Cr5DeipxsLlmAvn
	osxfy4bJ0B0v7HivfE0Iy7EQU8p0Djs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4FYYcIMsWui5FEtbJc216IVCEEljsCSq2dMO0ldq0m0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794296707; v=1; x=1794901507;
 b=RelAKPruwzUF0dmqfLH7UcqhLAHJBe4St9VpbqdmnCc+DYgKLU4RMGWOyVIbsVjDgG4G2OVb
 VfQQHxevQ0ZlZjAmk2Fd30hEHJEkcHfFKzBe+fGwHqlqKEe6F6+Z0VD4NqJ53KFlwtWkgANbt2P
 e5YK62pI/ktysaItN4T5S29s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0f38bc380dfc5c8d;
	Tue, 10 Nov 2026 07:45:05 +0000
X-Mizu-Trace-ID: 0f38bc380dfc5c8d
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	david@kernel.org,
	link@vivo.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	odys.yuan@gmail.com,
	rppt@kernel.org,
	surenb@google.com,
	tujinjiang@huawei.com,
	vbabka@kernel.org,
	xiao.wang@vivo.com
Subject: [PATCH 1/4] ksm: add only_merge_zero_pages to merge only empty anonymous pages
Date: Tue, 10 Nov 2026 15:44:48 +0800
Message-Id: <20261110074451.220524-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110074312.219847-1-xu.xin@linux.dev>
References: <20261110074312.219847-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rfy4modeyo8opkmuiwkq57mqo57ryidw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B333B14000D
X-HE-Tag: 1794296708-448551
X-HE-Meta: U2FsdGVkX1/4H3+rnMjuvjc+p2IEWPlUbJAI7UxGsfx+SLvAs6d1KPsLmTrZIF9D4sdMj7ENWRqUU1/xj7zBiICmLhC5pGyIUbTrL9DkTkQ+dQtT0L2e7lnKh37W+H4WyGPXeorhH+O6OZL5rNpdkoq85Fk0QsEoKRe5YmlpSip1XWGUY64zyQK5z8ZNxjwgd4d/XZyqas9pXmStqTt7+K4XSTDNhL+DfL7TYTtBeaFu0Du9d5CmuzORoyOmijCwb4Vx4umfa2l6sMJgkf09EaKsh89tpN88N3vrnP+A6naKlc4JJYW8rxLfxzjJBil5W8C3pbe9msYHFCCYeGr8ByzIYHgDBn845yJPT23bDHjEqAaNbtHNarFVvsEyoHvYdxAOOPrVIsRMevb9jMRCznaG2tRG/DsWbcmYw461nu4B4+ISW6erjsLkiP0LnX5RXdM5N9DxXGX1i5hyNmPJUwBiuNeLr4kZhUZOYdZ9xr95WyMOFnk842Q7DqZZSV3kW8mvuGyCuts7Yv0ITK/LgGmdbvKeGa8Wkdtc8L91YEjT3j9hhmWfX8seE9CZOJx/4EZNFd7RIyML8lKkcVsgCDpQtigEMPGAqb9nYlf+Hs2oyhGNACihWfzE2gEsz1DYBNfPyeM6sgv4czpwUISwHl0wgrOv7gv/zqpKBuBMo3JEgyN650L6+u0LbS8KSERgrGjSeO6g8ofIb7q4MFVwl+lAtav/y8GWW6Mms2oV/NpHY6qWpnYctUdpGGe1wUsAXU196St0hAr5tb+b/Pjxj5fRWpuWMQ+pWgu5DP6+mbMhp6ZbdLhGa7VMW5Kvq3Mk/c1I/VSrCvt38bVfhuDUG9Ya4LzTI13bi/RMvDKlY1KeYjNzDH/YbaWgdNL9svG/KEdprUC/me43ZCxVEIINlrUAD4SQFgKaFcpXfJu+WCrM8n+EBVl7QxTyuTg6av2EQQwJ++jJWFkXuolhfXf
 dCPLo+bT
 QiDLAyTVHyf02FJbk2HdR9XtZemE55xOd9c+BcL+x5ObgrAVdtGdxTzr5s0FJY/qhXny8BhwrYGpLPL0ECSmW6ZKgL9G5gVsgzDJVz/3XINfJe5+ta26QJJdWLfWrjI5peEsNacYeFNxfYnoeuxxm9XBfVm5L7zw9zUeGhn7tl3x7B5EdXEP0poDogetM5a542nRwYH4bYxrfuMU5ah797aB2DrcM01/Er6cgov1mKBQy7+olfPrPxu2goFnqHI826r5y+lPaFPOUclDr5bZaV5OZX6KXXSU3EzwuKuZqYk0LzEGimj3hGuo/3aBIlzkNnZFXLvJA/FxBQqw2TJW340llwpvqRaUDEFWP5OJz1XnzigiTI4kr0Z3z4l84psCrgtHiAighpj/aTa1GTWMMHWyJHPJasioPXZBU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new sysfs attribute, /sys/kernel/mm/ksm/only_merge_zero_pages,
which, when enabled, makes ksmd merge only empty (zeroed) anonymous
pages with the kernel zero page and skip the stable and unstable trees
entirely for pages that carry data.

The attribute requires use_zero_pages to be 1, and the two are kept
consistent by symmetric constraints: it cannot be enabled while
use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
off while it is active (-EBUSY). Both store handlers take
ksm_thread_mutex around their check-and-set so that a concurrent write
to the two attributes cannot leave use_zero_pages=0 and
only_merge_zero_pages=1, a state in which ksmd would scan and checksum
pages but never merge any. The new attribute can be changed at any time
and is only effective for pages merged after the change.

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
 Documentation/admin-guide/mm/ksm.rst | 40 ++++++++++++++++-
 mm/ksm.c                             | 67 ++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index c329ca747b8c..7c2cbac4b020 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -128,10 +128,48 @@ use_zero_pages
         KSM for some workloads, for example if the checksums of pages
         candidate for merging match the checksum of an empty
         page. This setting can be changed at any time, it is only
-        effective for pages merged after the change.
+        effective for pages merged after the change. Turning this off
+        while ``only_merge_zero_pages`` is enabled fails with EBUSY;
+        clear ``only_merge_zero_pages`` first.
 
         Default: 0 (normal KSM behaviour as in earlier releases)
 
+only_merge_zero_pages
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
index 5e24b5ca8dc8..49f3728a3d03 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -295,6 +295,13 @@ static unsigned int zero_checksum __read_mostly;
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
+/*
+ * When set, ksmd only merges empty (zeroed) anonymous pages with the kernel
+ * zero page and skips the stable/unstable tree entirely for pages that carry
+ * data. This requires ksm_use_zero_pages to be enabled.
+ */
+static bool ksm_only_merge_zero_pages __read_mostly;
+
 /* Skip pages that couldn't be de-duplicated previously */
 /* Default to true at least temporarily, for testing */
 static bool ksm_smart_scan = true;
@@ -2323,6 +2330,14 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 
 		if (!try_to_merge_with_zero_page(rmap_item, page))
 			return;
+
+		/*
+		 * A page that reached here was not merged with the zero page this
+		 * round. Under only_merge_zero_pages we do not insert it into the
+		 * stable/unstable trees.
+		 */
+		if (ksm_only_merge_zero_pages)
+			return;
 	}
 
 	/* Start by searching for the folio in the stable tree */
@@ -3697,12 +3712,63 @@ static ssize_t use_zero_pages_store(struct kobject *kobj,
 	if (err)
 		return -EINVAL;
 
+	/*
+	 * only_merge_zero_pages depends on use_zero_pages: refuse to turn
+	 * the latter off while the former is active, so the two cannot
+	 * silently diverge. Take ksm_thread_mutex so that this check-and-set
+	 * is serialized against only_merge_zero_pages_store(), which reads
+	 * ksm_use_zero_pages under the same lock.
+	 */
+	mutex_lock(&ksm_thread_mutex);
+	if (!value && ksm_only_merge_zero_pages) {
+		mutex_unlock(&ksm_thread_mutex);
+		return -EBUSY;
+	}
 	ksm_use_zero_pages = value;
+	mutex_unlock(&ksm_thread_mutex);
 
 	return count;
 }
 KSM_ATTR(use_zero_pages);
 
+static ssize_t only_merge_zero_pages_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", ksm_only_merge_zero_pages);
+}
+static ssize_t only_merge_zero_pages_store(struct kobject *kobj,
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
+	/*
+	 * Take ksm_thread_mutex so that this check-and-set is serialized
+	 * against use_zero_pages_store(), which reads ksm_only_merge_zero_pages
+	 * under the same lock. Without it, a concurrent write to the two
+	 * attributes could leave use_zero_pages=0 and only_merge_zero_pages=1,
+	 * a state in which ksmd would scan and checksum pages but never merge
+	 * any.
+	 */
+	mutex_lock(&ksm_thread_mutex);
+	if (value && !ksm_use_zero_pages) {
+		mutex_unlock(&ksm_thread_mutex);
+		pr_warn_once("ksm: only_merge_zero_pages can only be enabled "
+			     "when use_zero_pages is 1\n");
+		return -EINVAL;
+	}
+	ksm_only_merge_zero_pages = value;
+	mutex_unlock(&ksm_thread_mutex);
+
+	return count;
+}
+KSM_ATTR(only_merge_zero_pages);
+
 static ssize_t max_page_sharing_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
@@ -4028,6 +4094,7 @@ static struct attribute *ksm_attrs[] = {
 	&stable_node_dups_attr.attr,
 	&stable_node_chains_prune_millisecs_attr.attr,
 	&use_zero_pages_attr.attr,
+	&only_merge_zero_pages_attr.attr,
 	&general_profit_attr.attr,
 	&smart_scan_attr.attr,
 	&advisor_mode_attr.attr,
-- 
2.34.1


