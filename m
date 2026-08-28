Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DEFEC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857AF6B0092; Thu, 27 Aug 2026 23:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D906B0095; Thu, 27 Aug 2026 23:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5980D6B0096; Thu, 27 Aug 2026 23:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33BA86B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A629D160300
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:00 +0000 (UTC)
X-FDA: 85149209040.09.F559DF3
Received: from mail-m603.netease.com (mail-m603.netease.com [210.79.60.3])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABD2620003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:13:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NSgQWe1n/0FHUj8Qcf6u5eP0/afW9CZoyS3CvyyVdWw=;
	b=XkA8ywwwGtVtc6UepmR1h76JRrxYncH/kZyDy9iTDCrXHCEtfGZfZmA75ukDK/9okuA5YK
	r6K52JAvNA2Yxw1vqBMhnkqfkH6dX+T+/Tgx0EuLLzrLQrUo7kq/874XOMf1nKngMW4FEo
	Or/RXSc8JDALXVzBfKf2xUjZ8gdthuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886839;
	b=cx7qAz+xJdjHfPz5u3v39nD8JNVcrA7NpL7hs5IvLBCyzo1ZKrm68+RO0a4l/N0+Hzr7EZ
	6bJ1mRtM/+a2CistPSfqIwzEO6uwJoqWSLzkG2AHuz4q8HIKzfC3opQDbFdIad65+UGBn2
	TKTZe3fBx7ZWOXvXQ/YSY17QEgDIw30=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20d93;
	Fri, 28 Aug 2026 11:13:53 +0800 (GMT+08:00)
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
Subject: [PATCH 1/8] mm/page_owner: Add PID filtering support
Date: Fri, 28 Aug 2026 11:13:32 +0800
Message-Id: <20260828031339.1270699-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c0d6c0229kunma81ef96712a329
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTRgaVkMfQk8dTkkZTE8aGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABD2620003
X-Stat-Signature: ad1594cyk4xj8pajg848fc51df7deamz
X-HE-Tag: 1787886837-289906
X-HE-Meta: U2FsdGVkX19qIYVOZZDMU0/oZurrQDpdfwhQcd1oOIKxiTrDBKhKQhgdHphMG+9lxvM127hKG2jg+Iydyj++B33+OSsMojhWUMAtzzc3s/mYHeIDJFk2BN3YmK9rv2gaYfSKUbACdRSMDsVWiIwf2PNBqdYSqOadpdFlEM/zeX9ynrxdl5arFn8lVioOIKCvnzY/ULn4jrLwK5kE8OJFRI+0/1oEaAYtx8KxQS1xVl0dDwclM+5qeeHfx1HQtTsHWdwXFqa7wQb0Roa1dzLqoNEhc6Ilo1bIKkUTjW9G7RkA7BL5QBN2h45ZkEeRC65SOLHItP4tr8B2DnMaA21UiTQOPbdsq9rByLiTeJDLhZZ2w7BoBZHWtPxKUcxOKvacu0w5BXkb6Nv7XP4Fh4L9TlStN+zO2VM79hNNAe/Q53y683nhyBF3JkfHNRkb66nVH6wWJWLXZMQ5gAtboywSGQK/PgLQvmgui1tA8LdHCWSXrqTeEPalAcz8mBQy6xuvGmzhMU2UB/FH1NXRs6qxJB+xcSAl7P1vVg90+7UtEYHvicr6YfdyAhYuXu7uQTuvOrqUz5Y+LtQLk1CJsmx24dHxnFQKrMjLaK1UGaP3V1hdhl2qohbuMf7exXVkBqOJoyCX3pzSuHjPZ5NeztO3WbYsSgOf4j/wLOfaByEtFx9hvVSDYABnqjRWjb/yvsZgNjGHFp75kSltnY46Q2smJ+1wdDlGThsr/F7N+BzcMwi5/uHtQf2fdCbz+1EQ1vFqaqu0crqSLk11cESi+ydS53UrmwLsimA2PEjuelssyq7YPhwOj3OzRK4m/Ws0mMAlGafwbpcjL8PCUZc4Mw0kAPsHipkiSHPNsTLg69QpQo++HkkdjoYAzlUGgFbT1uUKYFc7SDu9qKiOYZepCjtb1R4LFrCNlYm1V6WmnG1z7bvTjhYxYVVESlCOnLzjmlyLP73n6ftJxjbOyatYRc5
 Q1HnHWBh
 ZBe7wlF80B0xmXarthIjTGvCkpA6JFrAT9po2zm7jWuSgt6KONbJHOnSp3yhbuKVeIGpy+ZQ6GMaYe+2Ho2rAeyFIDj1y3mKXDMeyjTtvzi75nMP4NbuLxW/1L2AbmggePJSW6tCGqp2cPEVyyY2ypqYwLrxNFoLSr1yW/FKug0VyMm5XsMfKrsC/Y2OuNOJSqTcBoGTvLoGcJuy6+Jqx2uBNpBHC0IlN2nVo5AV8bBGNx8I=
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
 mm/page_owner.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..33b9e12a019b 100644
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
+	return *(pid_t *)a - *(pid_t *)b;
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
@@ -937,6 +965,37 @@ static int page_owner_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int parse_pid_t_list(const char *str, pid_t *list, int *count)
+{
+	char *str_copy, *token;
+	int i = 0;
+	unsigned int pid;
+	int ret = 0;
+
+	str_copy = kstrdup(str, GFP_KERNEL);
+	if (!str_copy)
+		return -ENOMEM;
+
+	while ((token = strsep(&str_copy, ",")) != NULL) {
+		if (*token == '\0')
+			continue;
+		if (i >= MAX_FILTER_PIDS) {
+			ret = -E2BIG;
+			goto out_free;
+		}
+		if (kstrtouint(token, 10, &pid) != 0) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+		list[i++] = (pid_t)pid;
+	}
+
+	*count = i;
+out_free:
+	kfree(str_copy);
+	return ret;
+}
+
 static ssize_t page_owner_write(struct file *file,
 				 const char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -949,6 +1008,9 @@ static ssize_t page_owner_write(struct file *file,
 	enum page_owner_print_mode new_print_mode;
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
+	bool new_proc_filter_enabled;
+	pid_t new_pid_list[MAX_FILTER_PIDS];
+	int new_pid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -956,8 +1018,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -969,6 +1033,11 @@ static ssize_t page_owner_write(struct file *file,
 	new_print_mode = state->print_mode;
 	new_nid_filter = state->nid_filter;
 	new_nid_filter_enabled = state->nid_filter_enabled;
+	new_proc_filter_enabled = state->proc_filter_enabled;
+	if (state->pid_count > 0) {
+		memcpy(new_pid_list, state->pid_list, sizeof(state->pid_list));
+		new_pid_count = state->pid_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1000,6 +1069,10 @@ static ssize_t page_owner_write(struct file *file,
 			}
 
 			new_nid_filter_enabled = true;
+		} else if (!strncmp(token, "pid=", 4)) {
+			ret = parse_pid_t_list(token + 4, new_pid_list, &new_pid_count);
+			if (ret < 0)
+				goto out_free;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
@@ -1010,6 +1083,14 @@ static ssize_t page_owner_write(struct file *file,
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


