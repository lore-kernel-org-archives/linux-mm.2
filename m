Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB79C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8446B00AD; Mon,  7 Sep 2026 04:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499316B00B2; Mon,  7 Sep 2026 04:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D62A6B00B3; Mon,  7 Sep 2026 04:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15B846B00AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3081A06AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:53 +0000 (UTC)
X-FDA: 85186285506.23.22AA4A5
Received: from mail-m82135.xmail.ntesmail.com (mail-m82135.xmail.ntesmail.com [156.224.82.135])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26E4BA0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6TGt3mzwxJWnj47BkPnyHAL895xL2QNHWrAc0VHtmVA=;
	b=ZqV638fowPZMPPx79rxVECR2ITmPY5njsgQ7fugdHjSgs+Ojh7jyi64ljFHS45XfTGyAMz
	4WivA4yZscWCNtol5onLKXeeFRf4CE9i77ubblM4hNM/BGkaL7w7UJidlEz6zrfiU6FdAi
	+BL3EI8HKun+wk/I/tKA8+GcUsQvTfQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769611;
	b=7wLUgQFkUv64XkqAnPvVFC7qrFQSJ6v4jFPe35J4eRvwJS/XhbLKZ8z58pZDbxcwc6P/Gc
	d3dqqFjXD9LmriN7KqqVtQjIe4beSZ3pjibjiy8GhWNK/qBVTAgSTNbhQ6oJMnBRuSUBcv
	wbyUE82lzmla6MfpaJYbmD6iP+IxpIY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa09d;
	Mon, 7 Sep 2026 16:26:46 +0800 (GMT+08:00)
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
Subject: [PATCH v3 5/8] mm/page_owner: Add memcg filter support
Date: Mon,  7 Sep 2026 16:26:17 +0800
Message-Id: <20260907082620.2083838-6-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa1bf20229kunm225d16da162d12
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSUJLVk5CT09CHxgfTBhKS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: 4s5tx1u3ioqwxgwh56tcw9s6ms6soshy
X-Rspamd-Queue-Id: 26E4BA0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788769610-227520
X-HE-Meta: U2FsdGVkX18AEaH1no54iccLjzwcCC7yLTInbEL+Dgv9b3mDiPzpFd1vFmQvcfueOqac8bHetpY3dn4tNuJWvlBigo91Ik3mX2QKXxWJ2gu477gmTp+mXTuUUgbRpUWP7KxWaGKq91FxE60ZqvYY5tAGYEajMMUL+23Obwpzwge12yaq92TXpcXKqgWWXXYMv4jHWEsoWEus7SRP9b1X9/iv+mmOWAfO4sblxxsewFO8XSO/7YhVt1VIdGLUrXjwWFMXBKZFaDAI59t3TCTVRr0SyjW50fwOlQimPdx1IH9aZC6t6YUL8DbgtmgTUJC9vmBIIjkJO7/J+d7sf9TZgMVdFfi8968n1jBdcduaN7BbJ0QYxIbiNP0Nq15pSz8tbSa04e0+AHPc62DDWjJKtoR5iYD1grHJmVgOVmoe6Qinej+/or6NmPmcXq0LTXiw4FUbDdEzJBSIyK7Tbo/4J0YT/LLN5PvDZ0f2QW3ZGSsHbxVU1K5XYQ5yaPgMWm4Fp5owNIcrkp3xvmAu6Owf6Jo/FU8hM+NPfNpESBRK0kfRvgGHlT/DIfAeSp2U9dvaooPcsVWDGM+cfVjxiSiWaoKx5OsSDaEEeAd4yFabCHu8TYBeObzm7kl/2kjNd6ZhlT7jectEd+KOrozELOzGVf5SePTHXmpwLYO50iEEHXsMeL+ORqLcpk2NsGwV8oG2mGxClF5gZVo/eRFq6rsPFE+sAuq7AID9gshIjifdRxGpmCpwClKKXFel/INHkrMMGI5aFP8yBpQy87SLS3pJKskO/STdpAeO+WbqKy11+2yY1Am0XRUztDbAkPp20FFCCKmhMbVWp66RGrGZP5aUJCV4QXpNlu65LeZhIyjMWgC4zvMCzxpRbwhxD0bwt+Vtdj4TA/9/+y2Z/ulv1FKNmWvAgFuESaBRSoT/MKrJDzm+dZJT+tS1DmEBYDORjXXpF3YryX0KI8yTHPLwRcT
 bl98OO1s
 pnlKc3tdIP5Y4QghoEhYC8Rc9aJR+Pl6UqGmxrXx0oTBFKQrQ8W/bUZFRpZJsipMbJ4l05YtJU8a3VKkCiBnnAs5UTsEDJ6bwbAdNIUjITUjxXEpm8fR7pdCCDffxxB4akCDvyUnOH7sLW9aclRpavlUOm6y88J05EkFegN4CEUvqqUs=
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
Changes in v3:
- Add a NULL guard for state->memcg_path before strcmp()

Changes in v2:
- Allocate the cgroup path buffer once per read() outside the loop
  instead of per page inside get_page_memcg_info(); a GFP_KERNEL
  allocation must not sleep inside the page_ext RCU read-side critical
  section.
- Guard the memcg= parsing branch with CONFIG_MEMCG

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-6-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-6-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 5 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 3bdf4faa8f6b..7f1f2dcc633f 100644
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
@@ -582,7 +585,8 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 /*
  * Get memcg information from page
  */
-static void get_page_memcg_info(struct page *page, struct memcg_info *info)
+static void get_page_memcg_info(struct page *page, struct memcg_info *info,
+				 char *path_buf)
 {
 	unsigned long memcg_data;
 	struct obj_cgroup *objcg;
@@ -606,6 +610,10 @@ static void get_page_memcg_info(struct page *page, struct memcg_info *info)
 	info->is_objcg = (memcg_data & MEMCG_DATA_KMEM) != 0;
 	info->is_online = css_is_online(&memcg->css);
 	cgroup_name(memcg->css.cgroup, info->name, sizeof(info->name));
+	if (path_buf) {
+		info->path = path_buf;
+		cgroup_path(memcg->css.cgroup, info->path, PATH_MAX);
+	}
 out_unlock:
 	rcu_read_unlock();
 }
@@ -775,11 +783,23 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	char *memcg_path_buf = NULL;
 	struct page_owner_filter_state *state = file->private_data;
+	ssize_t ret;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
 
+	/*
+	 * Allocate outside the loop, as GFP_KERNEL allocations may not
+	 * sleep inside the page_ext RCU read-side critical section.
+	 */
+	if (state->memcg_filter_enabled) {
+		memcg_path_buf = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (!memcg_path_buf)
+			return -ENOMEM;
+	}
+
 	page = NULL;
 	if (*ppos == 0)
 		pfn = min_low_pfn;
@@ -899,7 +919,11 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		}
 
 #ifdef CONFIG_MEMCG
-		get_page_memcg_info(page, &memcg_info);
+		get_page_memcg_info(page, &memcg_info, memcg_path_buf);
+		if (state->memcg_filter_enabled)
+			if (!memcg_info.path || !state->memcg_path ||
+			    strcmp(memcg_info.path, state->memcg_path) != 0)
+				goto ext_put_continue;
 #endif
 
 		/* Record the next PFN to read in the file offset */
@@ -907,13 +931,16 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
-		return print_page_owner(buf, count, pfn, page,
+		ret = print_page_owner(buf, count, pfn, page,
 				&page_owner_tmp, handle, state, &memcg_info);
+		kfree(memcg_path_buf);
+		return ret;
 ext_put_continue:
 		page_ext_put(page_ext);
 		cond_resched();
 	}
 
+	kfree(memcg_path_buf);
 	return 0;
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
 
@@ -1074,9 +1104,11 @@ static ssize_t page_owner_write(struct file *file,
 	enum page_owner_print_mode new_print_mode;
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
+	bool new_memcg_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
 	pid_t new_tgid_list[MAX_FILTER_TGIDS];
 	char (*new_comm_list)[TASK_COMM_LEN] = NULL;
+	char *new_memcg_path;
 	int new_pid_count = 0;
 	int new_tgid_count = 0;
 	int new_comm_count = 0;
@@ -1092,16 +1124,24 @@ static ssize_t page_owner_write(struct file *file,
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
 
@@ -1123,6 +1163,9 @@ static ssize_t page_owner_write(struct file *file,
 				state->comm_count * TASK_COMM_LEN);
 		new_comm_count = state->comm_count;
 	}
+	new_memcg_filter_enabled = state->memcg_filter_enabled;
+	if (state->memcg_filter_enabled && state->memcg_path)
+		strscpy(new_memcg_path, state->memcg_path, PATH_MAX);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1166,12 +1209,35 @@ static ssize_t page_owner_write(struct file *file,
 			ret = parse_comm_list(token + 5, new_comm_list, &new_comm_count);
 			if (ret < 0)
 				goto out_free;
+#ifdef CONFIG_MEMCG
+		} else if (!strncmp(token, "memcg=", 6)) {
+			if (token[6] == '\0') {
+				ret = -EINVAL;
+				goto out_free;
+			}
+			ret = strscpy(new_memcg_path, token + 6, PATH_MAX);
+			if (ret < 0)
+				goto out_free;
+			new_memcg_filter_enabled = true;
+#endif
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
@@ -1198,11 +1264,16 @@ static ssize_t page_owner_write(struct file *file,
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


