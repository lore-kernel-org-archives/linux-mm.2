Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96455C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991786B00AA; Sat, 27 Jun 2026 03:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941E76B00AB; Sat, 27 Jun 2026 03:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831826B00AC; Sat, 27 Jun 2026 03:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 568466B00AA
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:25:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFD9E1C2368
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:01 +0000 (UTC)
X-FDA: 84924856002.12.9DB122C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3861F140006
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:24:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n180m1cN;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545099;
	b=GhMV/bDCW5wi60R/aXyvhAuC8QLv3F7xSP28VaTQ3ynGki5Yw9UxejBkNYIpdeVuXzZGGP
	1DsBlKxS6bWxZ5KaRwh4uvwY0N85fDSLkgw0uma6CrdqvyguUonj/tPEiHA8oGZLkx7TFb
	J6jBiNXv5/BS7bvdo3BVZhzCmTLmIbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORtH7YK4iyUhs5dxgme0LiitoRZN8JXtAAU3PmygRuo=;
	b=Gpg8CsJucDyfoC+xmw2Hv1Vs7m+3X55Mm7qFD+w0rowUU/gySQIOkhRMgChpDzycjIgBNv
	Xvz2Zr3TdaXChK0N9gdrqh8VgipR7vTcjHo0AURPvtcNCT6bX5IPrShADC15ZNRcMOnGMj
	nnZyJpwSl8TKzdqTlE+RMNqYjQ/ScM4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n180m1cN;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORtH7YK4iyUhs5dxgme0LiitoRZN8JXtAAU3PmygRuo=;
	b=n180m1cN5hOlfXr0LkjpaRc2Qw14eJE7TB9eMVwnn3Sv0nZiIiuGTzPCvYCMaaiKZbfLeR
	LC1BdTKkpC70oTANxgtumEQz0WJ/S2jV0VsTx0EiaKCA1izXWVdnoH2haqZciCx6G+cL8V
	czQhkjCZNvG0lQ1rs7XGX9nwRZ/OSDA=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 2/8] mm: add boot-time reserved THP pageblock capacity
Date: Sat, 27 Jun 2026 15:21:50 +0800
Message-ID: <5f81d7460eb2382bbda25d40afae2609bebc1fae.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3861F140006
X-Stat-Signature: xberxq4y6o6gae6gac6yceq9d4tozzi8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782545099-894420
X-HE-Meta: U2FsdGVkX1/AaKMomLsKilqNVdLr/EX03iBIyMeIRd+NRoyFCR7Q8kG66xv3j0XvVmTd7v0J1P+gz0riiVlAf+4maRFEF/fXEg7XipdxmlzE8F9ldyjzjgjrIl5GrpV3m8cJjWhHJXDZfE97yuvyystw9PLCiORu7FktY2GV0l3pPugiL7QjpyjLfeCPw0gkizGYISkkZI07myOSGJZjC3IKu6MRdmiVO3mOzZOdW5vSyPIn3SWFNu3VzG618WoUvqSHkG6xHJ1m8DaMF7Qb8N8lp2jZsuJJAYeA9qusle2UFcAZ2J9Aq6gPeTVN3Kje0HgD+tJ49Hxm8iXO+wj3f0YwweTtlv6jqWWMJK3yIyfVlPl/biQFW8EQ7gaN8kIZOEP/4CwP+LhrjSrnpFcoN+deT5PWRtxUO7YR+m9gU3sl1eL92CJ7Mws0nkTrPgONv/o8snd+cDCPK57ZcBzQRLqtZok2N1s3s+Rd3lPTkxVvaxEQNO1MFU50QjiGa82cHXzK7zxSmmefdwALo3nEfBgi721jZ5jpUA0kqO2eGjXDHLUD2h74jjAZYc0o1kJYy2Sf1eyrSqMn1Gq81pjwpFIeRTWg06D3+2FZVUAxi8PDSZdGo98uKwsZUbp96Zr0nrwJ7tEXd4aCPbGPu8Z+bLCS8XvnRdgg4BJHIF6eg53HitFb4HEU0HMhvPUgLM2K6Xlk/01hdorcff25GZem/BnfIm28tnYoJRAZpHIsp/R9FrxSp4aQScJMCtTw9zrLV5gSbHWiVLQ8LVoP5LlgT+6qOVLjZqe9JLep/kPYuxuEr9J/oPsLoGulPZ7BZXTgSOf017kudFrmsuoSVq4x/5vJ3FupSTKGyQuKCl8wbRwCb7cL4TQIi9lsXMsFK2WPLTVCZ64b5ym2uuMRn56tx0hHpimUX0K6XgonibarHcNKiE/8VkjDKuGNN/58SLOnzheAHlf4wzeyW8w8Sdm
 yIqBgXmH
 4iy4zvN6hdBVDPCghfCjVGaTc7/vFh3aNXVS8g4FTIYt/d8YFxtA91QIxiqudnjroIP9vDDNnVRCQSYvlnsr0P7UkHQMGZvqt/z1AnWD8yIyUqHXOtagU0/Zape/aRZqFgpZT6uzAdBwx/4llJcZjjcuhpZypQR0dbFvWN2WBXKIDMcOc2bLHqDIjUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Add kernel boot parameters "thp_reserved_size" and "thp_reserved_nr" to
allow reserving a specified number of THP pageblocks during system boot.
These reserved pageblocks are marked as MIGRATE_RESERVED_THP.

Additionally, expose the "total_hpages", "free_hpages", and "used_hpages"
nodes in sysfs (/sys/kernel/mm/reserved_thp/) to allow userspace to
monitor the usage of the reserved capacity.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/Makefile       |  2 +-
 mm/internal.h     |  2 +
 mm/page_alloc.c   | 29 ++++++++++++++
 mm/reserved_thp.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100644 mm/reserved_thp.c

diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061c..fd74a7392e346 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
-obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o reserved_thp.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a20..a76a1fad2a7fd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1951,4 +1951,6 @@ static inline int get_sysctl_max_map_count(void)
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+unsigned long reserved_thp_pageblocks(unsigned long nr_hpages);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 613a711305072..23dbbef444f18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3568,6 +3568,35 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 	return false;
 }
 
+unsigned long reserved_thp_pageblocks(unsigned long nr_hpages)
+{
+	unsigned int order = max_t(unsigned int, HPAGE_PMD_ORDER,
+				   pageblock_order);
+	unsigned long hpages_per_block = 1UL << (order - HPAGE_PMD_ORDER);
+	unsigned long reserved = 0;
+	gfp_t gfp = (GFP_HIGHUSER | __GFP_COMP | __GFP_NOMEMALLOC |
+		     __GFP_NOWARN | __GFP_NORETRY);
+
+	while (reserved < nr_hpages) {
+		struct page *page;
+		struct zone *zone;
+		unsigned long flags;
+
+		page = alloc_pages(gfp, order);
+		if (!page)
+			break;
+
+		zone = page_zone(page);
+		spin_lock_irqsave(&zone->lock, flags);
+		change_pageblock_range(page, order, MIGRATE_RESERVED_THP);
+		zone->nr_reserved_thp += 1UL << order;
+		spin_unlock_irqrestore(&zone->lock, flags);
+		__free_pages(page, order);
+		reserved += hpages_per_block;
+	}
+	return reserved;
+}
+
 static inline long __zone_watermark_unusable_free(struct zone *z,
 				unsigned int order, unsigned int alloc_flags)
 {
diff --git a/mm/reserved_thp.c b/mm/reserved_thp.c
new file mode 100644
index 0000000000000..1eee4f39b9d69
--- /dev/null
+++ b/mm/reserved_thp.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/mm.h>
+#include "internal.h"
+
+static DEFINE_SPINLOCK(reserved_thp_lock);
+
+static unsigned long reserved_thp_cmdline_size __initdata = HPAGE_PMD_SIZE;
+static bool reserved_thp_cmdline_size_valid __initdata = true;
+static unsigned long reserved_thp_requested __initdata;
+static unsigned long reserved_thp_total;
+static unsigned long reserved_thp_used;
+
+static int __init setup_reserved_thp_size(char *str)
+{
+	unsigned long size;
+	size = memparse(str, NULL);
+	if (size != HPAGE_PMD_SIZE) {
+		pr_warn("unsupported thp_reserved_size=%s, only %lu is supported\n",
+			str, HPAGE_PMD_SIZE);
+		reserved_thp_cmdline_size_valid = false;
+		return -EINVAL;
+	}
+	reserved_thp_cmdline_size = size;
+	reserved_thp_cmdline_size_valid = true;
+	return 0;
+}
+early_param("thp_reserved_size", setup_reserved_thp_size);
+static int __init setup_reserved_thp_nr(char *str)
+{
+	int count;
+	if (sscanf(str, "%lu%n", &reserved_thp_requested, &count) != 1 ||
+	    str[count]) {
+		pr_warn("invalid thp_reserved_nr=%s\n", str);
+		reserved_thp_requested = 0;
+		return -EINVAL;
+	}
+	return 0;
+}
+early_param("thp_reserved_nr", setup_reserved_thp_nr);
+
+static ssize_t total_hpages_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", READ_ONCE(reserved_thp_total));
+}
+static ssize_t free_hpages_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	unsigned long free_hpages;
+
+	spin_lock(&reserved_thp_lock);
+	free_hpages = reserved_thp_total - reserved_thp_used;
+	spin_unlock(&reserved_thp_lock);
+
+	return sysfs_emit(buf, "%lu\n", free_hpages);
+}
+static ssize_t used_hpages_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", READ_ONCE(reserved_thp_used));
+}
+
+static struct kobj_attribute total_hpages_attr = __ATTR_RO(total_hpages);
+static struct kobj_attribute free_hpages_attr = __ATTR_RO(free_hpages);
+static struct kobj_attribute used_hpages_attr = __ATTR_RO(used_hpages);
+
+static struct attribute *reserved_thp_attrs[] = {
+	&total_hpages_attr.attr,
+	&free_hpages_attr.attr,
+	&used_hpages_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group reserved_thp_attr_group = {
+	.attrs = reserved_thp_attrs,
+};
+
+static int __init reserved_thp_init(void)
+{
+	struct kobject *kobj;
+	int ret;
+
+	if (reserved_thp_requested && reserved_thp_cmdline_size_valid) {
+		reserved_thp_total = reserved_thp_pageblocks(reserved_thp_requested);
+		pr_info("reserved %lu/%lu PMD THP pageblocks (%lu bytes each)\n",
+			reserved_thp_total, reserved_thp_requested,
+			reserved_thp_cmdline_size);
+	}
+	kobj = kobject_create_and_add("reserved_thp", mm_kobj);
+	if (!kobj)
+		return -ENOMEM;
+	ret = sysfs_create_group(kobj, &reserved_thp_attr_group);
+	if (ret)
+		kobject_put(kobj);
+	return ret;
+}
+subsys_initcall(reserved_thp_init);
\ No newline at end of file
-- 
2.54.0


