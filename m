Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14C5C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9166B009D; Thu,  3 Sep 2026 00:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAF06B009F; Thu,  3 Sep 2026 00:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E68B6B00A1; Thu,  3 Sep 2026 00:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36BB46B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C17F7A044B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:42 +0000 (UTC)
X-FDA: 85171144884.17.40B2364
Received: from mail-m82108.xmail.ntesmail.com (mail-m82108.xmail.ntesmail.com [156.224.82.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4271440002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409121;
	b=OhLP1ALavybNxutek6jA3hQag4EFhbj7sOPz2U1ePDXPX15zJtu1SGAf/VAVsSB+raMsVL
	KJ1TNz3V/JXx8PYx+//OvBIe9rycjQ9Nxdh1zrQt/1XHA75I7aQSPASnjcnBylyKHk8/GW
	kC2MnpadpqvYyjBMCCVsRgkgMs9o7xE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oGy4jY0VSQjL8REJCi18xh/SwSpxVAxLtWa7paHqoVo=;
	b=WHlSd7kqUrRzx0LqjWsdAYcbJtADkTxriIdp1qgOz4CAo2Ej+YIQlPp/4WxJON9WmbF2Q4
	MXV4RlEMHA44B0TmMERKlAzLh7dfmqQ+sd+igyje50w6DMdIsk8CjagrukJFvzqWemtIOb
	VCmMI8rCJvWfNd52WrBp1tU3Llm0Pzk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3b4;
	Thu, 3 Sep 2026 12:18:35 +0800 (GMT+08:00)
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
Subject: [PATCH v2 4/8] mm/page_owner: Refactor memcg handling for cgroup filter support
Date: Thu,  3 Sep 2026 12:18:15 +0800
Message-Id: <20260903041819.1776630-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d74aa0229kunm7336907a330b5
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTENKVkpCQ0JIQk9DGkwYGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4271440002
X-Stat-Signature: 33eo5idqhe33fg5h8ok6g1e9dcdcnysa
X-HE-Tag: 1788409119-344817
X-HE-Meta: U2FsdGVkX18WSFN/e+AmppAmnNxzQ8zSvZapzaZPMSpREKtZgTj1P87mHp5nFR9+aV+sI6mOwvHSgo1XSlBZCFlX0sDeRDkHI4qzFwAAwWbMbeJXFnjD9hRs8Nn7rytrVhW7pshLbmKDHonoYJLw/AghGMk4G4qB3GcJE3PWBTl7tHf68Bly5loWPxfi6afwe7nLwZPoFoc6x+VCTLNS+OgoQSNXamhsUn72pWly7DmH9H5cfZR4QSzsqgtAZpmSinPXhwKRp/N3+Noe1Ce5YRLuIdxFHp+OX3AUsEw77SONb9RbEgpDSQyWOmpAYcWZe0ic44rK7g55Fd20WhNYMHgKHEQgjl3IQbjteOtAQ7lQl6DbTZjKaS55gijPhonXhvFM7wIE9ppLe5yhcXEPa1PmKP8dNGiK9Pgv+GXciOGzjf7F5s9g0NEbFDhm+vXHA+L/0+riWh30CPhy4EsHg/sucoIrwgJZPpNLvAeeDz0QARRwZ1IzgRoarYrzXk/W2D5r5T7sGCiViIwMnJ4eDiWVoW03FDXEa0UHil/1H9+EIugQyEJ1FEg6jHH5Bckxt7WwNdNDibYmOJWz6wtqYfccNKQpifrRMXY0CxxuUi0MrGC6xvKdPm++ZAspou58yTD8p+ZS0rj8pwMZkcSYLNJn5dSCOKCtNdVHZsaha1/M6Si6dSIBrdB8LCVRVbebgxq6wM3Fkn4GedxykyectsEY4CRA3YNSGM9c6MR2CQqu54KbJ+DuNIwI6J/rH7Y/cwfzCkXNIw5U0/p3Q77DLGTeYsNxVs+rV/w1+pfZRV/WeyY+fA12yRi3cLCGS/OW7ro12VJtXHhslI45IKjYX/lugJoJv4mvJEnkjahKRankC/VUZkK6eVaOH8eI6DEaG36j3Nnt1htQaXOwVhTy6+KL66NdxtDceLXgMCgp/h8knbX3R9rOK/vvav7Qr3lY0bQVzqHyO9keMa38WSC
 rC72OnC3
 BATEFuitT4npDeeCQ7prSwZf5qyJHsrHRJYH1NDShT7uRl7WObaGsupnXt7mXQNHCb3xLt1LsyPusFQygs/WYzDPiaU+51rHoKRxGhYosTnETDOUxF96sXhQ0XvY568cMjmZ+RlkoRnnq7XWyrTRKqFRyWwVQLkUxyUS4NL9xN2XcjEA=
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
Changes in v2:
- No change.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-5-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 62 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index b8319bc3a368..ca9dd8ed9f77 100644
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


