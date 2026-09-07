Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA18C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D546B009D; Mon,  7 Sep 2026 04:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E656B009E; Mon,  7 Sep 2026 04:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956756B00A5; Mon,  7 Sep 2026 04:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3E76B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04BE81C26AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:48 +0000 (UTC)
X-FDA: 85186285338.16.F06698B
Received: from mail-m82143.xmail.ntesmail.com (mail-m82143.xmail.ntesmail.com [156.224.82.143])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06277A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769607;
	b=Zaswy5IpFh5dYCs3+8rT7xx2NU8U1XM5fhoBAcG4GtfaCHAhBlARmA5pnLgZbAiv8DuwuV
	Oyl7UTu661HHAGMZf/GIDrBJn4qMWGNpTpCSnzEsBugNTzusdPXyIJKB8WbmyOge9RA94N
	0eclc6K74UeM8X0Azex//4zxVDZw07E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBaQAENlxtEudH56Y6g6cYUACFGJ5nWd0UDOdocGTGY=;
	b=PNF1zHwNqq8Ect6FyaBUkAt9MGyK4hb8/Q8gwDVH9haefcHdEo8/e5o2BDDRj9mU2rT29L
	6ceHu8LtxvFEXJZruD5iEaSJ6uo7A8hYo+97hJNgXYjmrbm4b5h/rcXflXw1yaDGZz9SvU
	EjiCM3Q0Tg4lvroLzQN6bPyOzGvKelg=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa083;
	Mon, 7 Sep 2026 16:26:41 +0800 (GMT+08:00)
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
Subject: [PATCH v3 1/8] mm/page_owner: Add PID filtering support
Date: Mon,  7 Sep 2026 16:26:13 +0800
Message-Id: <20260907082620.2083838-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa076e0229kunm225d16da162ce9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZT09PVk5KSU5NSUJJQxhLT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06277A0007
X-Stat-Signature: miuxei8ewbu7jbprhp31wkrxz4urudtc
X-HE-Tag: 1788769605-828745
X-HE-Meta: U2FsdGVkX1+8nZK39Gs+3zHQnS7GdCVnIrZGT5pevd/zUJ8+X5FruLksteHx26PUC6GpwAsfRCyZ89mqN71e1Y8QME6PEqDt0CB9gcXxU64Vu0B5wJRzWlLxQ75kptaUL+8tlYqYit702MSgWOFDmO+08dhKUNgnBzIot9xM9ou52HtegtrYU3Aduq8p3J9185x9kUoZIUpY5PqSeJbm4EB14X1iLzXMzwKAsyzjhWBBttdWLotpUjPwb+fRs9geQ34yC+eZm7pSEnrlp8ZJHalyDWehXkedi37o/VRq7Gs1W1vRq4uNVQRmGKDhK4QE6VJyU8mvMOYraWVESJh+Q0hIfWfz4q9dEpEyrMummlfIJbwnA/5HeljO7G8hMRd3Z1r/aPh1cRDQBuqUz1x4VIOMialpP22tfy/T4tESi+lCvn61GPTOnBn19jc9s9WITNs9OmmBfwq3ibPP9zVreWchAZy3cZ8OSlSRleNPtQuT17tv3xv2XZUnghhNLGcSdvxHVw2h9uzK46/E+LkuqKkN6IdppBvMUZDr6vvHWPQMxZgKTSCbuD9z41EBFgPJBafo1TGZZTSd9gCO77Lhi+Dco1jtd0FB3YTS+Ge3YkH+rt5S1m/8D0qPxYFcnsjSAYMxtJkwfBJG7pJVWNl1UJOZlmUOv4+rqni346VUMDhJT+pLUo1UO000ebl0sHUxRSlj8oxmIM0s0e4fxyW/S/zK7smiKv2zx/Ctb3r/l2qomiSQM3pw8xAUzOJNodQ6btQAQ0Aj4AG2E53OTXPzjAXsNrPvTRXhrnmEF90JXvwSbUk0UoJOPRLEYMLAn8o1iN1wC7x1px4wCUxppZauo/G5+qD6h1/+BbRqAJpJRsuYBCSKJLwuPhg62NeIyx777dODmCVPfMNiS/vZAvy98a9XE5vuVsJacDbMBrYTCh1RpcektMFHxjtGNnHa6E43f5PiDAOSnNCi0b5J4UK
 uiCcYdmY
 bM0cQmPk9IWoXcaEuE3PmkVfIH0KR0MD8ZHmCt5+n8kFR3P3j+NFn/f0Wl4FkzuuQR4x9jxmbkn9a3ogYepE/rs4HGbauRi9uLNc9ZvV8xGy1eJRDjFz45WRuZo1yANNoax6PXpoRuTVVCG11LVvMGMD92e8Zcd4Jex4P/5x1IC8xr6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add PID filtering support. Users can filter page_owner output by process
IDs using the "pid=<pid_list>" command format. The filter supports up to
16 PIDs specified as a comma-separated list. PIDs are stored in sorted
order for efficient binary search matching during page owner iteration.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Remove the unused new_proc_filter_enabled staging variable.

Changes in v2:
- Drop the kstrdup() copy in parse_pid_t_list(); parse the token in
  place. This also fixes a leak on success and a kfree() of an advanced
  pointer on error in v1.
- Use cmp_int() in cmp_pid_t() to avoid overflow on subtraction.
- Reject pids exceeding PID_MAX_LIMIT.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-2-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-2-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..8c704f1916ff 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -12,6 +12,8 @@
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 
 #include "page_alloc.h"
 
@@ -66,12 +68,24 @@ static const char * const page_owner_print_mode_strings[] = {
 	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
 };
 
+/* PID_MAX_LIMIT = 4,194,304 (7 decimal digits) */
+#define PID_MAX_DIGITS  	7
+#define MAX_FILTER_PIDS 	16
+
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
-	nodemask_t nid_filter;
 	bool nid_filter_enabled;
+	bool proc_filter_enabled;
+	nodemask_t nid_filter;
+	int pid_count;
+	pid_t pid_list[MAX_FILTER_PIDS];
 };
 
+static int cmp_pid_t(const void *a, const void *b)
+{
+	return cmp_int(*(pid_t *)a, *(pid_t *)b);
+}
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -820,6 +834,19 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				goto ext_put_continue;
 		}
 
+		if (state->proc_filter_enabled) {
+			bool proc_match = false;
+
+			proc_match = bsearch(&page_owner->pid,
+					    state->pid_list,
+					    state->pid_count,
+					    sizeof(pid_t),
+					    cmp_pid_t) != NULL;
+
+			if (!proc_match)
+				goto ext_put_continue;
+		}
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -927,6 +954,7 @@ static int page_owner_open(struct inode *inode, struct file *file)
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
 	nodes_clear(state->nid_filter);
 	state->nid_filter_enabled = false;
+	state->proc_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -937,6 +965,27 @@ static int page_owner_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int parse_pid_t_list(char *str, pid_t *list, int *count)
+{
+	char *token;
+	int i = 0;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		unsigned int pid;
+
+		if (*token == '\0')
+			continue;
+		if (i >= MAX_FILTER_PIDS)
+			return -E2BIG;
+		if (kstrtouint(token, 10, &pid) != 0 || pid > PID_MAX_LIMIT)
+			return -EINVAL;
+		list[i++] = (pid_t)pid;
+	}
+
+	*count = i;
+	return 0;
+}
+
 static ssize_t page_owner_write(struct file *file,
 				 const char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -949,6 +998,8 @@ static ssize_t page_owner_write(struct file *file,
 	enum page_owner_print_mode new_print_mode;
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
+	pid_t new_pid_list[MAX_FILTER_PIDS];
+	int new_pid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -956,8 +1007,10 @@ static ssize_t page_owner_write(struct file *file,
 	 *        with sufficient buffer
 	 * - 6 * MAX_NUMNODES: worst case for nid list
 	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
+	 * - For list filters: (digit+comma) * count + prefix
 	 */
-	if (count > 32 + 6 * MAX_NUMNODES)
+	if (count > 32 + 6 * MAX_NUMNODES +
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -969,6 +1022,10 @@ static ssize_t page_owner_write(struct file *file,
 	new_print_mode = state->print_mode;
 	new_nid_filter = state->nid_filter;
 	new_nid_filter_enabled = state->nid_filter_enabled;
+	if (state->pid_count > 0) {
+		memcpy(new_pid_list, state->pid_list, sizeof(state->pid_list));
+		new_pid_count = state->pid_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1000,6 +1057,10 @@ static ssize_t page_owner_write(struct file *file,
 			}
 
 			new_nid_filter_enabled = true;
+		} else if (!strncmp(token, "pid=", 4)) {
+			ret = parse_pid_t_list(token + 4, new_pid_list, &new_pid_count);
+			if (ret < 0)
+				goto out_free;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
@@ -1010,6 +1071,14 @@ static ssize_t page_owner_write(struct file *file,
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
 	state->nid_filter_enabled = new_nid_filter_enabled;
+	state->proc_filter_enabled = new_pid_count > 0;
+	if (new_pid_count > 0) {
+		memcpy(state->pid_list, new_pid_list, sizeof(state->pid_list));
+		state->pid_count = new_pid_count;
+	}
+	if (state->pid_count > 1)
+		sort(state->pid_list, state->pid_count, sizeof(pid_t),
+		     cmp_pid_t, NULL);
 
 	ret = count;
 
-- 
2.20.1


