Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10872CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D14E8E000C; Thu,  4 Sep 2025 02:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681F98E0002; Thu,  4 Sep 2025 02:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEAB8E000C; Thu,  4 Sep 2025 02:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8988E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:31:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0402C0A42
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:31:54 +0000 (UTC)
X-FDA: 83850597348.16.A21A379
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id E32081C0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:31:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=rV3Xie5byfnGSl1a5MCMsVLTCCu0ZrqrKCOqITDcdac=;
	b=7dQMYMN1e3ytMH4N3ujFqvAnWvKgDIHjgunnZ6lbWwNSKBDSKMeD4haHWBXseO8mTISbys
	5ToMOpr9QVA7NNri5TTAsS5gGz2mL32ZDdJYnpOuQX6a4dNfeteGbxygGBxw/La+0yxsMm
	7d4yZxvUXlz+BN6sO/O+KxW3XE59Yek=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967513; a=rsa-sha256;
	cv=none;
	b=wRXvMNsYNYT35hQgsRD7PWA4FVjdomrlvMJyMdPqICTnm4wJdyeUZLp1j9OQkdsWlr/N+u
	qoyl3RUCVSYKe2jm5eZQ4++vYfZ+iryz45aB895r0bDqoKQLOv2vE1WMUNxbSezeeqoz+T
	sGEdfIpyXoqDX0KulCXfDfvd8S/HmLk=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cHV5z3SB2z2wBDt;
	Thu,  4 Sep 2025 14:32:55 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 72CCF140118;
	Thu,  4 Sep 2025 14:31:47 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 14:31:47 +0800
Received: from huawei.com (10.173.125.236) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 14:31:46 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.com>, <david@redhat.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: [PATCH] mm/hwpoison: decouple hwpoison_filter from mm/memory-failure.c
Date: Thu, 4 Sep 2025 14:22:58 +0800
Message-ID: <20250904062258.3336092-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: g3gj8ammahmqi9nmk7esgmajppaxpcif
X-Rspam-User: 
X-Rspamd-Queue-Id: E32081C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756967511-738276
X-HE-Meta: U2FsdGVkX18JG2pjlQrl3EeUztQvqWyBt3iB0HhKvcv5/8k4pih2RGqU88Ku9GYI8yLE1UGXSRtebnQ83dB3qDa8agcPtXl+/3i8dMqGeWkoeAubgdSPcD42RGvOI7kl5EuyXKG1tab2XR1wNeFKznr/IMWM6NyyigSTohuzt/ZnbBy+avi1wCZRv84h6wUV3/7AzjJgSxxz5zyEVZ3BouiArPSEAvv8ReRZv629uJxdKWfHqV2Iys0eYMVmU2tz8VZAUYzKMwW3oeQiNROs+djncZkFoLFzfRU6jLseJGGqGbnLPJ1huwWu/9XrFMU3gribe7rnia3r9NYf4xQSuR2ji2Vl3oOE7ho47dfpfapO5hxwymZ7HcqFBExCDYYztqJNriJZpWdnqH5JiyzLZpV2e4AMq6gCTM7vBr+wWC4OlzkivN2fuRm7r1u+H7xRZZo1E3dZnMv2JXbih6Wdhc5VMsdjtO5eKwmdLOQecTskyksU6hPor7PGDjDpCxMtnKGYnwbijKkboHk34oEjL+cvWzgrpRfueuj9F0oHIg2oFNXwEB60G8PyxAau/CdzWASySxT3Ro/eGHeoNBVj6Ad+3dcUbCM3veAIz31aIKeFiudaCm5rBxQU0TBXYDoko+nphjoowqamqxsoADO5Vs8sZFKVV0S7XjzVoH3txekAXIVzhbvlJ0xmRobA/Sdw9Zy7iRHXNQ63M2VQd9KVV3sZElOUKYMQiV8TTcBs5oswzy3RqGzeFHl8hTVnCdO3Z5F1Bhdy0dmVOv3dsQ5YSAlGAki7fnSsVBRMNU6zdN5sSIO2ciOS/5sosJPjJPcF0Tkp5SnUuul1RGsMpWICKAwEtPd3tYqCvbQ/ECS3Ktp2dkFGqdhOEl2Tzuz2PVpARFmXC+CqTYlX6cnHh0/qXuHkvqIreAtZ0+1dL+aGEtLGzGEeSogOK6USDNKzae+WloLkj5AVFqHejlUbOSr
 xd05lKeZ
 weFn+kAB6t84YkeW+/GH4PyiK1GmgJGO6VRXb2gEc9Yhy7MdRMNzQspsPxyqoA+j7DVeHFavlC6Av4AJx8b6lYhu3q/+vnH8m+ypDBvENT12lE2eSxVNPFbjwco9O9Yroa07/0FRQE0nEjUyL82NIgj4tD6eeD3waLhJ4prd7LNjEaDqQY8PA8liJt5L1qWR7D5t4iUDVSTWOmfuSFsDRyjlyDCBujaIF25ImhLV8jsEVrzhDA1A76sdAR6lnh9TY94Ner6vt0uHvrx7RxCx/nKSwFhZ2PphWeJnn5MgasUWi0hAWRpyCnQmKLX59UYIYd4eWKMHFl7UHAqwhyZaxoyDFA48K5jetT1sW2a0Us4gptZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/memory-failure.c defines and uses hwpoison_filter_* parameters but the
values of those parameters can only be modified via mm/hwpoison-inject.c
from userspace. They have a potentially different life time. Decouple
those parameters from mm/memory-failure.c to fix this broken layering.

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 fs/proc/page.c       |   1 +
 mm/hwpoison-inject.c |  91 +++++++++++++++++++++++++++++++++++++
 mm/internal.h        |  12 ++---
 mm/memcontrol.c      |   1 +
 mm/memory-failure.c  | 106 +++++++------------------------------------
 5 files changed, 114 insertions(+), 97 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 46be207c5a02..8a3280810397 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -257,6 +257,7 @@ u64 stable_page_flags(const struct page *page)
 
 	return u;
 }
+EXPORT_SYMBOL_GPL(stable_page_flags);
 
 /* /proc/kpageflags - an array exposing page flags
  *
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 7ecaa1900137..a11222572f97 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -7,8 +7,96 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
+#include <linux/page-flags.h>
+#include <linux/memcontrol.h>
 #include "internal.h"
 
+static u32 hwpoison_filter_enable;
+static u32 hwpoison_filter_dev_major = ~0U;
+static u32 hwpoison_filter_dev_minor = ~0U;
+static u64 hwpoison_filter_flags_mask;
+static u64 hwpoison_filter_flags_value;
+
+static int hwpoison_filter_dev(struct page *p)
+{
+	struct folio *folio = page_folio(p);
+	struct address_space *mapping;
+	dev_t dev;
+
+	if (hwpoison_filter_dev_major == ~0U &&
+	    hwpoison_filter_dev_minor == ~0U)
+		return 0;
+
+	mapping = folio_mapping(folio);
+	if (mapping == NULL || mapping->host == NULL)
+		return -EINVAL;
+
+	dev = mapping->host->i_sb->s_dev;
+	if (hwpoison_filter_dev_major != ~0U &&
+	    hwpoison_filter_dev_major != MAJOR(dev))
+		return -EINVAL;
+	if (hwpoison_filter_dev_minor != ~0U &&
+	    hwpoison_filter_dev_minor != MINOR(dev))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int hwpoison_filter_flags(struct page *p)
+{
+	if (!hwpoison_filter_flags_mask)
+		return 0;
+
+	if ((stable_page_flags(p) & hwpoison_filter_flags_mask) ==
+				    hwpoison_filter_flags_value)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+/*
+ * This allows stress tests to limit test scope to a collection of tasks
+ * by putting them under some memcg. This prevents killing unrelated/important
+ * processes such as /sbin/init. Note that the target task may share clean
+ * pages with init (eg. libc text), which is harmless. If the target task
+ * share _dirty_ pages with another task B, the test scheme must make sure B
+ * is also included in the memcg. At last, due to race conditions this filter
+ * can only guarantee that the page either belongs to the memcg tasks, or is
+ * a freed page.
+ */
+#ifdef CONFIG_MEMCG
+static u64 hwpoison_filter_memcg;
+static int hwpoison_filter_task(struct page *p)
+{
+	if (!hwpoison_filter_memcg)
+		return 0;
+
+	if (page_cgroup_ino(p) != hwpoison_filter_memcg)
+		return -EINVAL;
+
+	return 0;
+}
+#else
+static int hwpoison_filter_task(struct page *p) { return 0; }
+#endif
+
+static int hwpoison_filter(struct page *p)
+{
+	if (!hwpoison_filter_enable)
+		return 0;
+
+	if (hwpoison_filter_dev(p))
+		return -EINVAL;
+
+	if (hwpoison_filter_flags(p))
+		return -EINVAL;
+
+	if (hwpoison_filter_task(p))
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct dentry *hwpoison_dir;
 
 static int hwpoison_inject(void *data, u64 val)
@@ -67,6 +155,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(unpoison_fops, NULL, hwpoison_unpoison, "%lli\n");
 static void __exit pfn_inject_exit(void)
 {
 	hwpoison_filter_enable = 0;
+	hwpoison_filter_unregister();
 	debugfs_remove_recursive(hwpoison_dir);
 }
 
@@ -105,6 +194,8 @@ static int __init pfn_inject_init(void)
 			   &hwpoison_filter_memcg);
 #endif
 
+	hwpoison_filter_register(hwpoison_filter);
+
 	return 0;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 45da9ff5694f..0bb0f4471673 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1227,14 +1227,10 @@ static inline bool node_reclaim_enabled(void)
 #ifdef CONFIG_MEMORY_FAILURE
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
 void shake_folio(struct folio *folio);
-extern int hwpoison_filter(struct page *p);
-
-extern u32 hwpoison_filter_dev_major;
-extern u32 hwpoison_filter_dev_minor;
-extern u64 hwpoison_filter_flags_mask;
-extern u64 hwpoison_filter_flags_value;
-extern u64 hwpoison_filter_memcg;
-extern u32 hwpoison_filter_enable;
+typedef int hwpoison_filter_func_t(struct page *p);
+void hwpoison_filter_register(hwpoison_filter_func_t *filter);
+void hwpoison_filter_unregister(void);
+
 #define MAGIC_HWPOISON	0x48575053U	/* HWPS */
 void SetPageHWPoisonTakenOff(struct page *page);
 void ClearPageHWPoisonTakenOff(struct page *page);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9712a751690f..8dc470aa6c3c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -287,6 +287,7 @@ ino_t page_cgroup_ino(struct page *page)
 	rcu_read_unlock();
 	return ino;
 }
+EXPORT_SYMBOL_GPL(page_cgroup_ino);
 
 /* Subset of node_stat_item for memcg stats */
 static const unsigned int memcg_node_stat_items[] = {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4af8875b07b6..cebec87d9fa3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -212,106 +212,34 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
 	return true;
 }
 
-#if IS_ENABLED(CONFIG_HWPOISON_INJECT)
+static hwpoison_filter_func_t __rcu *hwpoison_filter_func __read_mostly;
 
-u32 hwpoison_filter_enable = 0;
-u32 hwpoison_filter_dev_major = ~0U;
-u32 hwpoison_filter_dev_minor = ~0U;
-u64 hwpoison_filter_flags_mask;
-u64 hwpoison_filter_flags_value;
-EXPORT_SYMBOL_GPL(hwpoison_filter_enable);
-EXPORT_SYMBOL_GPL(hwpoison_filter_dev_major);
-EXPORT_SYMBOL_GPL(hwpoison_filter_dev_minor);
-EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
-EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
-
-static int hwpoison_filter_dev(struct page *p)
+void hwpoison_filter_register(hwpoison_filter_func_t *filter)
 {
-	struct folio *folio = page_folio(p);
-	struct address_space *mapping;
-	dev_t dev;
-
-	if (hwpoison_filter_dev_major == ~0U &&
-	    hwpoison_filter_dev_minor == ~0U)
-		return 0;
-
-	mapping = folio_mapping(folio);
-	if (mapping == NULL || mapping->host == NULL)
-		return -EINVAL;
-
-	dev = mapping->host->i_sb->s_dev;
-	if (hwpoison_filter_dev_major != ~0U &&
-	    hwpoison_filter_dev_major != MAJOR(dev))
-		return -EINVAL;
-	if (hwpoison_filter_dev_minor != ~0U &&
-	    hwpoison_filter_dev_minor != MINOR(dev))
-		return -EINVAL;
-
-	return 0;
+	rcu_assign_pointer(hwpoison_filter_func, filter);
 }
+EXPORT_SYMBOL_GPL(hwpoison_filter_register);
 
-static int hwpoison_filter_flags(struct page *p)
-{
-	if (!hwpoison_filter_flags_mask)
-		return 0;
-
-	if ((stable_page_flags(p) & hwpoison_filter_flags_mask) ==
-				    hwpoison_filter_flags_value)
-		return 0;
-	else
-		return -EINVAL;
-}
-
-/*
- * This allows stress tests to limit test scope to a collection of tasks
- * by putting them under some memcg. This prevents killing unrelated/important
- * processes such as /sbin/init. Note that the target task may share clean
- * pages with init (eg. libc text), which is harmless. If the target task
- * share _dirty_ pages with another task B, the test scheme must make sure B
- * is also included in the memcg. At last, due to race conditions this filter
- * can only guarantee that the page either belongs to the memcg tasks, or is
- * a freed page.
- */
-#ifdef CONFIG_MEMCG
-u64 hwpoison_filter_memcg;
-EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
-static int hwpoison_filter_task(struct page *p)
+void hwpoison_filter_unregister(void)
 {
-	if (!hwpoison_filter_memcg)
-		return 0;
-
-	if (page_cgroup_ino(p) != hwpoison_filter_memcg)
-		return -EINVAL;
-
-	return 0;
+	RCU_INIT_POINTER(hwpoison_filter_func, NULL);
+	synchronize_rcu();
 }
-#else
-static int hwpoison_filter_task(struct page *p) { return 0; }
-#endif
+EXPORT_SYMBOL_GPL(hwpoison_filter_unregister);
 
-int hwpoison_filter(struct page *p)
+static int hwpoison_filter(struct page *p)
 {
-	if (!hwpoison_filter_enable)
-		return 0;
-
-	if (hwpoison_filter_dev(p))
-		return -EINVAL;
-
-	if (hwpoison_filter_flags(p))
-		return -EINVAL;
+	int ret = 0;
+	hwpoison_filter_func_t *filter;
 
-	if (hwpoison_filter_task(p))
-		return -EINVAL;
+	rcu_read_lock();
+	filter = rcu_dereference(hwpoison_filter_func);
+	if (filter)
+		ret = filter(p);
+	rcu_read_unlock();
 
-	return 0;
-}
-EXPORT_SYMBOL_GPL(hwpoison_filter);
-#else
-int hwpoison_filter(struct page *p)
-{
-	return 0;
+	return ret;
 }
-#endif
 
 /*
  * Kill all processes that have a poisoned page mapped and then isolate
-- 
2.33.0


