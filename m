Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C934C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682046B0098; Thu, 27 Aug 2026 23:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6330D6B0099; Thu, 27 Aug 2026 23:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA926B009B; Thu, 27 Aug 2026 23:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25FC56B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A17B214030B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:03 +0000 (UTC)
X-FDA: 85149209166.07.33B91D1
Received: from mail-m605.netease.com (mail-m605.netease.com [210.79.60.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1083B180004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Phu3u3kMcSb71yztK9IXfciHKbfUkuFWwZDQas6bPTs=;
	b=b5JbnEjGyF7Fq2qW+uJSL/XRbUu1SeFns6S5cHVf4yl8HQiTCSw+O1RYH0fbczg1S334H9
	5ZkI+TE/rWy40rCtTqb56FGa2kwIFECQYKTV7XInwtEH6ZJmEWZqifdK8wEkDV8GEBSNyb
	YswBQmOSWx0NXzY55Buw3Vm4vRwIExM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886842;
	b=fQxuoz45I8VSlg2vEn5c4sBIbKMsXOJc9UToSIeSd9KwH6GQffe8hJNZGbl+GyEOJ89Sot
	nLS8lJpHT4nPUBNh+BJwTYYl4P7yeqHUw8XgAcELGsUqVU60vEPxicupCXBzYgPEpiiAOZ
	KyQPltLStg15qNPz6LdTi505CCI20Nc=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20da8;
	Fri, 28 Aug 2026 11:13:56 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 4/8] mm/page_owner: Refactor memcg handling for cgroup filter support
Date: Fri, 28 Aug 2026 11:13:35 +0800
Message-Id: <20260828031339.1270699-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c1cf80229kunma81ef96712a344
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHh4YVhlPSh9OT05JHh9PHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: 4ghocfd1r9c5hbnxcb8whdq4u5sicesq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1083B180004
X-Rspam-User: 
X-HE-Tag: 1787886840-927503
X-HE-Meta: U2FsdGVkX19rEemkNoE9hSadTSyyFHKxWFngMP/RQesk8vUJqp5Sm+OIkNKIeg7nlYNGe6MLlPT/nJjBO595U1rKFXRro2Kc8jKEt7nCTjKGVTnS0U9u+peQEbA7W+aEsvTGruhUyj9Sv8iIl+OSU78u1/9dSKKPJDSOynM3aEdj+WEByVJFTxmvmhDDI9Q6wyvvgJyiJpSFJ2R4mcHVv6v/BA6KTVUEkcLhwYEaerlLcPfXA81IdNIH9gAjcga5Ud/05SqqtVNrPut0t46TOMMHGbVZH3rF7Ohr0cptG4277FlsYEquaQHsTAU0Z3wtC4WwzU6dinpgAM7ewETXVIMIZ5No69S8xyeYnG/CDCVyo7iTG3ripYY2/+mFCKYIyUXVY12vVB4GmfHDzCIcl30GClrXyQW9k/yumz6+F9ChUA2OgIFmgbIzFsx+3wZqwzkxSemPq+ABlb9x4ohx+PD3B7ofzAKAU/CcunzignkICxY2EgLcvUL7ZZlkftG4JSgoJnduIqumz/mq5uV6FnQm02z71/JgJ1WtX/eVUQolrkFRt6mhDmYIQu5+ucu9K3Dx+zzklAavjZm3iOqpE1uuoj8zoVdFLnh+OThbi3gDWPOr8BeeQ4jcsWPUI9iEXqR8BbWcSlmKBEJtAWFoex2oHySrVkfnbTsTTxczuv9R394JpIbFmcP0iK7B59aSpOu1HS88i/DRE74m0n6BzKGrE1CI0H3eEbJWa1AV3hVebZDejy3nFWL/PYKQ02duduL00i2wEN9XdqoNvK2Hlf9F9Ovt7CAZzRXLjR9g/Ey1FMKWwRr/fuJi4pe45QHEhnTFtvglexvy1Rc5l4FAl9fzVGBC9kR2XixuXifpzLUrq3MH3EEUkho9+udOTlqILsx1HSj+KDcz1AzsYwDbIhkfpYuwTVa2A40Oh0jz6wI0CiLKxTyJYliaXRawyXY5UROCCOIIhUTx0NHjnyE
 +4QL/iHk
 0kHgxfOVfFqZGUXQLmM+0BtzgKAjcExeuKM2BQcXRGI5GdgFF/sJtY8NLz86C2EidXD6wzjeyDBorXhYNBmOid8IzB/j277GMWAZC69tzkfSL5quJaeqxX0RPO1UwPMnCVzhgRzCHcdjOROwV5TCrgusTdd/oHe557s0AgttEyIrZFOfZ00VUNmt/iwacICto5nCNFDQQQ01/Jk3UcxmWAsDlTdftcNenmkZ8bqpFKpjVY0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract memcg information retrieval from printing logic to prepare for
cgroup filtering support. Introduce struct memcg_info to hold cgroup
data that can be reused for both display output and filtering
decisions.

No functional change - output behavior unchanged.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 62 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7cd533682054..09cfad10a7df 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -69,6 +69,13 @@ static const char * const page_owner_print_mode_strings[] = {
 	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
 };
 
+struct memcg_info {
+	char name[80];
+	bool is_slab;
+	bool is_objcg;
+	bool is_online;
+};
+
 /* PID_MAX_LIMIT = 4,194,304 (7 decimal digits) */
 #define PID_MAX_DIGITS  	7
 #define MAX_FILTER_PIDS 	16
@@ -573,16 +580,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 
 #ifdef CONFIG_MEMCG
 /*
- * Looking for memcg information and print it out
+ * Get memcg information from page
  */
-static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+static void get_page_memcg_info(struct page *page, struct memcg_info *info)
 {
 	unsigned long memcg_data;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
-	bool online;
-	char name[80];
 
 	rcu_read_lock();
 	memcg_data = READ_ONCE(page->memcg_data);
@@ -590,8 +594,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 		goto out_unlock;
 
 	if (memcg_data & MEMCG_DATA_OBJEXTS) {
-		ret += scnprintf(kbuf + ret, count - ret,
-				"Slab cache page\n");
+		info->is_slab = true;
 		goto out_unlock;
 	}
 
@@ -600,21 +603,38 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg)
 		goto out_unlock;
 
-	online = css_is_online(&memcg->css);
-	cgroup_name(memcg->css.cgroup, name, sizeof(name));
-	ret += scnprintf(kbuf + ret, count - ret,
-			"Charged %sto %smemcg %s\n",
-			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
-			online ? "" : "offline ",
-			name);
+	info->is_objcg = (memcg_data & MEMCG_DATA_KMEM) != 0;
+	info->is_online = css_is_online(&memcg->css);
+	cgroup_name(memcg->css.cgroup, info->name, sizeof(info->name));
 out_unlock:
 	rcu_read_unlock();
+}
+
+/*
+ * Print memcg information from memcg_info
+ */
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 const struct memcg_info *info)
+{
+	if (!info)
+		return ret;
+
+	if (info->is_slab)
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Slab cache page\n");
+
+	if (info->name[0])
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Charged %sto %smemcg %s\n",
+				info->is_objcg ? "(via objcg) " : "",
+				info->is_online ? "" : "offline ",
+				info->name);
 
 	return ret;
 }
 #else
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+					 const struct memcg_info *info)
 {
 	return ret;
 }
@@ -624,7 +644,8 @@ static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
 		depot_stack_handle_t handle,
-		struct page_owner_filter_state *state)
+		struct page_owner_filter_state *state,
+		const struct memcg_info *memcg_info)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
@@ -674,7 +695,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
-	ret = print_page_owner_memcg(kbuf, count, ret, page);
+	ret = print_page_owner_memcg(kbuf, count, ret, memcg_info);
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
@@ -777,6 +798,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 * user through copy_to_user() or GFP_KERNEL allocations.
 		 */
 		struct page_owner page_owner_tmp;
+		struct memcg_info memcg_info = {};
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -876,13 +898,17 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				goto ext_put_continue;
 		}
 
+#ifdef CONFIG_MEMCG
+		get_page_memcg_info(page, &memcg_info);
+#endif
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle, state);
+				&page_owner_tmp, handle, state, &memcg_info);
 ext_put_continue:
 		page_ext_put(page_ext);
 		cond_resched();
-- 
2.20.1


