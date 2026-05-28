Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDAFCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048516B00A9; Wed, 27 May 2026 20:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11696B00AA; Wed, 27 May 2026 20:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9B56B00AB; Wed, 27 May 2026 20:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2E7F6B00A9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6080291968
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:38 +0000 (UTC)
X-FDA: 84814977996.13.DA4D1F4
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6E28C0004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FHsBi+OY;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yKWet6irofp6Dygz5hKnYjBExq95hNouOEHl1lcaYA=;
	b=57mO7bQox5nWSj8UHkL2kRbOiERx7R8p6zgnvJu0VRK3uY+b75I99Zcu/q+IyU2jiaj/Ai
	qluh+25XV6ZqP0wiiPr44jBIr6OmtjQQhw4NDM3L9vktdWEm4hRl/fUWvt7I5wAzhlsUCc
	ImAMTWq6G3ydewqJHjdNkuzLuHaUuws=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=FHsBi+OY;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928956; a=rsa-sha256;
	cv=none;
	b=nctjFPnHNi12x53kkTa20rqgmt5hLGT+7+e5Q9MQSC1Xn8vT6UOqBTx3REpWdfoUSf2FC6
	KdsgFltUm77dGXB9eOK+veo94jaX/aOFflEhWoWixe101Did0ubivB585mwRgqtmxrkI7Y
	IbjZhvKcUK7/p9gGxRJ+IfMdzJTDyjs=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id C2BE920B7186; Wed, 27 May 2026 17:42:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C2BE920B7186
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928945;
	bh=0yKWet6irofp6Dygz5hKnYjBExq95hNouOEHl1lcaYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHsBi+OYZ9jOcAKcU2N4XgtTRa3DLo/5xpdPQ0VrR5ozMbaqTHr4GszSWV4T/H9ki
	 7ytnnjuF1mEcG+QD8rrmG5BehOPAJhT0V5AyAw2dJe45d31pNsyjIl5QyHdtmMrzf8
	 FP7l0XKJtLFJkM48S1NZyz3bc1EfsdeGKLqW7j4U=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 18/20] mshv: Exclude Hyper-V donated pages from crash dump collection
Date: Wed, 27 May 2026 17:42:00 -0700
Message-ID: <20260528004204.1484584-19-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8oxxy6aj1m65jpmi1ew3dfgred9m6omj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6E28C0004
X-HE-Tag: 1779928956-194779
X-HE-Meta: U2FsdGVkX19hSR79G7QU0pADcDbZsR7ABuEorXlGwDKiNYRb5uOeZsdIMu6IJr4xbZFq0gh8PnjY0ZfXBd/WWD6UoohsBNyqOtJdp88km7BaqZUfHIPYJqhrDW1xYkHa8OHhrPmh4p0oIP3NMjnr/9KDzWPZK6QIQS5rng/QJVhz7BchYfysEy8s74+rrKZvIOmoAN6A/9YlvePBlsfS1wHaMfeIKPIpKiO7Plljrfa4qmyW6k1x73+Cg52QyfLOI8Vbw9vaOyx8WbshReUvZZjtUVfZBNZ7bTbiysQKZwiVeQSeKs+I1rwQXzffw6PtMf+q0gbTw9VyDCzRA0uSLRQyk/bhvWX/fVARWgf/QYBxrpHXyVWP8lX6CCev67IOMcFgIiCpIcA2LRkxRWG+GbHjeoFs5lANO9wpGwrRrqq6c2LrOe+K5VG0h7X2U/EGQqeMReedAvzie0qD4S1ScuhfWNpiHIonUfv9byJngi+TVuBQGBYQJQ1r+7J8hNBmdWpVlzW/t2ze8J9tvGgcl8bz0zzqSOfpRDjzpLR9s5Y+0nIB3o1gGuPGEndhpXuOBEKbDCkTnquf/K0A56+HPbvBiudisT9whgeji20qKdWdaQzb0f4CdQJ8qxmwU/268eT3ieMe7x8mp3Qlx8xXeW4ykvp+CVPFFEB+mV8/hu2oXl55g153Uk8uEr2wTaaLAS0PInRo7RrS+fKzRFCywUvhm8sPooB7zO/u4Bl+Y57/0y2DcAt8kY+mw8JZa250ZGHAXI+YG1dqyI8M/TX/qwq1StZ/wc6JDlDuZu2aRR9LBiH2mI9ZQ0YYkwPCbZx6nfXYBpfXk0fABbOUYJ9kRXV2RkG0slkMIzU6tl/YEd2YFSCggvzMlxNuvMsisCupEsB3VMkyRMwOzN/19XSd966qCUM5GyZjlwOctdckpkWi1DFbYkeaNPMp9auY8/HxPSgCmpD/ZY5jfowa6k1
 xiXbFOKw
 b5jg/7X4/BnNjm8ygbUeVaNFsI1oYv1fvVh/CHCGR5XvfPkgEN1UXTI6CIPl+sCuAmtcZvhGJwQuT3BX02AYzdsgeVMQ61Pq1BKqvEzx78xG1AUi6w2uyvuUsvgutg+BMvAYUSoyG9WHxsez+XMJQ/MNd7pj4b6VD+wW0v9Rt9iftAIXvxyK8wvdoa0O6Il5dMjqXHqVvnRvBoO1LEJV59ncUNbVpUDWVGoGnq0buI2ztBC9wCKhTOIhSLIiM1pI008MHIhoE+QjDYA8BCQ0zBCQlWE3bLLk++YJHlwVQCq4cw/cs672Ta444eSNbM5j0O/bp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages donated to Hyper-V must not be read during crash dump collection.
They are not ordinary RAM and accessing them can hang or corrupt the
crash kernel.

Use the KHO radix tree of preserved pages to drive a vmcore pfn_is_ram()
callback. The radix tree root PA is passed to the crash kernel via
Hyper-V crash MSR P2, since the old kernel's KHO FDT is not accessible
from the crash kernel's direct map.

Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 drivers/hv/mshv_page_preserve.c | 80 +++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/hv/mshv_page_preserve.c b/drivers/hv/mshv_page_preserve.c
index bc3a3a688f5b..e16fb946790d 100644
--- a/drivers/hv/mshv_page_preserve.c
+++ b/drivers/hv/mshv_page_preserve.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "mshv: " fmt
 
 #include <asm/mshyperv.h>
+#include <linux/crash_dump.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
@@ -327,6 +328,57 @@ static int __init alloc_tree(void)
 	return 0;
 }
 
+#ifdef CONFIG_CRASH_DUMP
+static struct kho_radix_crash_tree crash_preserved_pages_tree;
+
+/**
+ * restore_crash_tree() - Set up the crash tree for dump-time page exclusion.
+ *
+ * In the crash kernel, the old kernel's memory is not in the direct map.
+ * The old kernel stashes the radix tree root PA in Hyper-V crash MSR P2
+ * so we can retrieve it without touching the old kernel's FDT.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int __init restore_crash_tree(void)
+{
+	phys_addr_t root_pa;
+
+	root_pa = hv_get_msr(HV_MSR_CRASH_P2);
+	if (!root_pa)
+		return -ENOENT;
+
+	/*
+	 * The MSR may contain stale data from a previous
+	 * hyperv_report_panic().  Sanity-check that it looks like a
+	 * page-aligned physical address within the architectural limit.
+	 */
+	if (!PAGE_ALIGNED(root_pa) || root_pa >> MAX_POSSIBLE_PHYSMEM_BITS) {
+		pr_warn("Invalid crash tree root PA: 0x%llx\n",
+			(unsigned long long)root_pa);
+		return -EINVAL;
+	}
+
+	return kho_radix_crash_init(&crash_preserved_pages_tree, root_pa);
+}
+
+static bool mshv_vmcore_pfn_is_ram(struct vmcore_cb *cb, unsigned long pfn)
+{
+	/*
+	 * MSHV-owned pages must not be read during crash dump collection.
+	 * Currently all pages are registered at order 0. If higher-order
+	 * registrations are added, this lookup will need to handle them
+	 * (e.g. by querying multiple orders or using a range-based API).
+	 */
+	return !kho_radix_crash_contains_page(&crash_preserved_pages_tree,
+					      pfn, 0);
+}
+
+static struct vmcore_cb mshv_vmcore_cb = {
+	.pfn_is_ram = mshv_vmcore_pfn_is_ram,
+};
+#endif
+
 static struct notifier_block reboot_notifier = {
 	.notifier_call = reboot_cb,
 	.priority = 0,
@@ -347,6 +399,24 @@ int __init mshv_preserve_init(void)
 {
 	int err;
 
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		/*
+		 * Crash kernel only needs the pfn_is_ram callback to exclude
+		 * MSHV-owned pages from the dump.  No page restoration, no
+		 * reboot notifier — the crash kernel reboots after collection.
+		 */
+		err = restore_crash_tree();
+		if (err) {
+			pr_err("Could not set up crash page tree: %d; MSHV pages may appear in dump\n",
+			       err);
+			return 0;
+		}
+		register_vmcore_cb(&mshv_vmcore_cb);
+		return 0;
+	}
+#endif
+
 	if (!kho_is_enabled()) {
 		pr_err("KHO is disabled; page deposits will fail.\n");
 		return 0;
@@ -383,5 +453,15 @@ int __init mshv_preserve_init(void)
 		 */
 		panic("Could not register reboot notification: %d\n", err);
 
+	/*
+	 * Stash the radix tree root PA in crash MSR P2 so the crash
+	 * kernel can retrieve it without touching the old kernel's FDT
+	 * (which is not in the crash kernel's direct map).  The root
+	 * pointer is stable once the tree is initialized — pages are
+	 * added/removed within the existing tree structure.
+	 */
+	hv_set_msr(HV_MSR_CRASH_P2,
+		   virt_to_phys(preserved_pages_tree.root));
+
 	return 0;
 }
-- 
2.43.0


