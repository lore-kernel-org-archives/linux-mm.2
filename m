Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A21C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4506B0099; Thu, 27 Aug 2026 23:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E496B009B; Thu, 27 Aug 2026 23:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CB96B009D; Thu, 27 Aug 2026 23:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06C0D6B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FABCC0341
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:05 +0000 (UTC)
X-FDA: 85149209250.19.B769D25
Received: from mail-m606.netease.com (mail-m606.netease.com [210.79.60.6])
	by imf27.hostedemail.com (Postfix) with ESMTP id 022464000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886843;
	b=Tqm//UO4bCTXrVKT1SwYEgfneWAU1zBh03RaCNXp1NX0Lxfhr19ySqvVNTuB/b/SaWy73e
	6d8LOPC2YWriEEPI87pAWawARcL9sbf5ikfi4DGmZFnlJ23zTcqyjWozKcwc2Ia0pDbLLn
	QF6KMPFC+gKoBvJcFCh+bLaDqAgEdEw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IFXkY3nNaxx9T82FHIoVoI/FRTs21/2YnKFz1E4hA2k=;
	b=7cl+QA91mZRc5A1jY72JSpFQIavRqlXskrhSPg9VW04lxZncGV25jYq4kfHcZvRBbb509n
	84k0yME+a8xKP0VyGqzevrbapWZ4yF7WBDUnAKFvJuD0XBRyi1xUWhv5UXQtthKrkF97UU
	O2oSOij3aNtiJxhc5lhP7fdIi8+1zpk=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20dae;
	Fri, 28 Aug 2026 11:13:58 +0800 (GMT+08:00)
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
Subject: [PATCH 5/8] mm/page_owner: Add memcg filter support
Date: Fri, 28 Aug 2026 11:13:36 +0800
Message-Id: <20260828031339.1270699-6-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c21b00229kunma81ef96712a34c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGhofVhgeH01JSEgfSkNMGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 022464000A
X-Stat-Signature: mtzsy8cp7z8jb8tidcap1mpd7sa8twqn
X-HE-Tag: 1787886842-680974
X-HE-Meta: U2FsdGVkX1+rv653MOlvSkyDpqzQw0ZZ3EMaW+Ayvf2ZU7M+1WjgFU0HFiKlY/xPpeRLf0oAOyumqLafOSb/DiMOpRqQunsaBnfEfnuXVXTRH1DiRPHxhDT4rWAUIWgTfBl8A2tX1wGBH5i1CMpTQTYekyvuLpt19pB/agfIYFmRcIKfGoA9tNt9CO/zfUt4vX0h70F/00i5zXo97pgCG9KCDI2Hz4/p+0FsbO/kuyUjn9r+tNyTvWWXEs6qLJZPKufXkskOd+4BMfc//lPLMpQoGjJ44zbs6FvlKobviKeMD0uhuO/pB9WMykhXQX4JaR5+1g/DRds4elcw37Hy6a2iIT3U2LkJlHGDNjDRPpKl3Qht6UHFhYXkAcD89NN4ayzk+NywuCuzma4pg1TL8FJ8hj7LR1Dp8vTGSlnAd/a1yWJXNxnlV5ZnKhoWt3TzwrYIzvmJdBRujKFW+054pLvS7wgxE1L+rLRYViVF4GE8PUB61GiEI1ncr4SrtlHU+YfqAwzLDTsyO42RMvvjqCy/ECm+3DNwsF9iESB8ctLxHpHimp/bvK8AW/x5ubis3IBHZYEYl+dMMRD9VLIYGN2R3/Go9qO+WapYYU3gFPFVMcDqigfoS8ytR44M8DF+PyNtSc5LE7TGZ68HUTZfafuBt+6jSxAlv8YT38CMFXA7N5LM3pVX2D78tRlTPARtdgUmGIsqlF1G1s6+0sBHdXSK9HN4hqZnjSLfQJv07LxBwtq859PRVOYFRCpRDagBGt4F9okU0Cli6MDIb5M1/KEgQprw0NIK57D5+IlpM8aSmISfDtEw132wWQ52N95FA4wqSVqUUX2CjDoxzD1ivpeN3NlSJGU6VsjLPUH5k8ZLIu8V3AK0z+V/vaNpgkbhCuqk1N/E0oVxzk4qTkVCO/4bVhyLHOHa2fIYuTBgOf3JxRpl1kjfu2A6CXDSQKH6PFmIHqDymp9zBPK1Glm
 kIKSBzqc
 t1c/wtzgwxXCoUNburYD2XZqoyZLorm3Z/Njh0tEWDgr5iG752NQdowgCKZnj7UtO+Xoajg20zNQFez6r8n20qeEoOeLg8rSP24SsGdY9ZwYylSZ3CAsy0hb6UmZ1pxW48O3yHThrshEFKRHdFCpVvIET4hgdh3zXMhjyupR3aEnSoY9ssaZcHj7WN5zHuVemqZccfVPuwM6bnC9CGdmRPe5EFI1Jrwd4pVbflHB9H4Tprl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add memory cgroup filtering to page_owner to allow filtering pages by
their memcg path. This helps debug memory usage patterns for specific
cgroups. Users can now filter page_owner output to show only pages
belonging to a particular memory cgroup.

Collect cgroup path in memcg_info using cgroup_path() and store the
filter state in page_owner_filter_state. When the user sets memcg filter
via "memcg=<path>" command, compare each page's cgroup path against
the specified path and skip non-matching pages using strcmp.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 79 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 5 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 09cfad10a7df..21b82e927eaf 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -71,6 +71,7 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct memcg_info {
 	char name[80];
+	char *path;
 	bool is_slab;
 	bool is_objcg;
 	bool is_online;
@@ -86,6 +87,7 @@ struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
 	bool nid_filter_enabled;
 	bool proc_filter_enabled;
+	bool memcg_filter_enabled;
 	nodemask_t nid_filter;
 	int pid_count;
 	int tgid_count;
@@ -93,6 +95,7 @@ struct page_owner_filter_state {
 	pid_t pid_list[MAX_FILTER_PIDS];
 	pid_t tgid_list[MAX_FILTER_TGIDS];
 	char comm_list[MAX_FILTER_COMMS][TASK_COMM_LEN];
+	char *memcg_path;
 };
 
 static int cmp_pid_t(const void *a, const void *b)
@@ -582,12 +585,21 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 /*
  * Get memcg information from page
  */
-static void get_page_memcg_info(struct page *page, struct memcg_info *info)
+static void get_page_memcg_info(struct page *page, struct memcg_info *info,
+				 bool need_path)
 {
 	unsigned long memcg_data;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
+	if (need_path) {
+		info->path = kzalloc(PATH_MAX, GFP_KERNEL);
+		if (!info->path)
+			return;
+	} else {
+		info->path = NULL;
+	}
+
 	rcu_read_lock();
 	memcg_data = READ_ONCE(page->memcg_data);
 	if (!memcg_data || PageTail(page))
@@ -606,8 +618,14 @@ static void get_page_memcg_info(struct page *page, struct memcg_info *info)
 	info->is_objcg = (memcg_data & MEMCG_DATA_KMEM) != 0;
 	info->is_online = css_is_online(&memcg->css);
 	cgroup_name(memcg->css.cgroup, info->name, sizeof(info->name));
+	if (need_path)
+		cgroup_path(memcg->css.cgroup, info->path, PATH_MAX);
 out_unlock:
 	rcu_read_unlock();
+	if (info->path && !info->path[0]) {
+		kfree(info->path);
+		info->path = NULL;
+	}
 }
 
 /*
@@ -776,6 +794,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	ssize_t ret;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -899,7 +918,12 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		}
 
 #ifdef CONFIG_MEMCG
-		get_page_memcg_info(page, &memcg_info);
+		get_page_memcg_info(page, &memcg_info,
+				    state->memcg_filter_enabled);
+		if (state->memcg_filter_enabled)
+			if (!memcg_info.path ||
+			    strcmp(memcg_info.path, state->memcg_path) != 0)
+				goto ext_put_continue;
 #endif
 
 		/* Record the next PFN to read in the file offset */
@@ -907,9 +931,12 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
-		return print_page_owner(buf, count, pfn, page,
+		ret = print_page_owner(buf, count, pfn, page,
 				&page_owner_tmp, handle, state, &memcg_info);
+		kfree(memcg_info.path);
+		return ret;
 ext_put_continue:
+		kfree(memcg_info.path);
 		page_ext_put(page_ext);
 		cond_resched();
 	}
@@ -1016,7 +1043,10 @@ static int page_owner_open(struct inode *inode, struct file *file)
 
 static int page_owner_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct page_owner_filter_state *state = file->private_data;
+
+	kfree(state->memcg_path);
+	kfree(state);
 	return 0;
 }
 
@@ -1096,9 +1126,11 @@ static ssize_t page_owner_write(struct file *file,
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
 	bool new_proc_filter_enabled;
+	bool new_memcg_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
 	pid_t new_tgid_list[MAX_FILTER_TGIDS];
 	char (*new_comm_list)[TASK_COMM_LEN] = NULL;
+	char *new_memcg_path;
 	int new_pid_count = 0;
 	int new_tgid_count = 0;
 	int new_comm_count = 0;
@@ -1114,16 +1146,24 @@ static ssize_t page_owner_write(struct file *file,
 	if (count > 32 + 6 * MAX_NUMNODES +
 			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4 +
 			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5 +
-			TASK_COMM_LEN * MAX_FILTER_COMMS + 5)
+			TASK_COMM_LEN * MAX_FILTER_COMMS + 5 +
+			PATH_MAX + 6)
 		return -EINVAL;
 
 	new_comm_list = kmalloc_array(MAX_FILTER_COMMS, TASK_COMM_LEN, GFP_KERNEL);
 	if (!new_comm_list)
 		return -ENOMEM;
 
+	new_memcg_path = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!new_memcg_path) {
+		kfree(new_comm_list);
+		return -ENOMEM;
+	}
+
 	kbuf = memdup_user_nul(buf, count);
 	if (IS_ERR(kbuf)) {
 		kfree(new_comm_list);
+		kfree(new_memcg_path);
 		return PTR_ERR(kbuf);
 	}
 
@@ -1146,6 +1186,9 @@ static ssize_t page_owner_write(struct file *file,
 				state->comm_count * TASK_COMM_LEN);
 		new_comm_count = state->comm_count;
 	}
+	new_memcg_filter_enabled = state->memcg_filter_enabled;
+	if (state->memcg_filter_enabled && state->memcg_path)
+		strscpy(new_memcg_path, state->memcg_path, PATH_MAX);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1189,12 +1232,33 @@ static ssize_t page_owner_write(struct file *file,
 			ret = parse_comm_list(token + 5, new_comm_list, &new_comm_count);
 			if (ret < 0)
 				goto out_free;
+		} else if (!strncmp(token, "memcg=", 6)) {
+			if (token[6] == '\0') {
+				ret = -EINVAL;
+				goto out_free;
+			}
+			ret = strscpy(new_memcg_path, token + 6, PATH_MAX);
+			if (ret < 0)
+				goto out_free;
+			new_memcg_filter_enabled = true;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
 		}
 	}
 
+	if (new_memcg_filter_enabled) {
+		if (!state->memcg_path) {
+			state->memcg_path = kzalloc(PATH_MAX, GFP_KERNEL);
+			if (!state->memcg_path) {
+				ret = -ENOMEM;
+				goto out_free;
+			}
+		} else {
+			memset(state->memcg_path, 0, PATH_MAX);
+		}
+	}
+
 	/* Commit all filter changes */
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
@@ -1221,11 +1285,16 @@ static ssize_t page_owner_write(struct file *file,
 				new_comm_count * TASK_COMM_LEN);
 		state->comm_count = new_comm_count;
 	}
+	if (new_memcg_filter_enabled) {
+		strscpy(state->memcg_path, new_memcg_path, PATH_MAX);
+		state->memcg_filter_enabled = true;
+	}
 
 	ret = count;
 
 out_free:
 	kfree(new_comm_list);
+	kfree(new_memcg_path);
 	kfree(orig);
 	return ret;
 }
-- 
2.20.1


