Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B447C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51E06B00A5; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29076B00AD; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15016B00A5; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 685096B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7D4A40690
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:50 +0000 (UTC)
X-FDA: 85186285380.13.1414D2D
Received: from mail-m82143.xmail.ntesmail.com (mail-m82143.xmail.ntesmail.com [156.224.82.143])
	by imf20.hostedemail.com (Postfix) with ESMTP id 44A3B1C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WDqB6BJDNAL3evFb4fn8mnX+VjrrTQC8BtFXEwA9Xz8=;
	b=WE0zfQfxSzLLiNtSo+era27ZWaGGMz7juSWjH7h8alTkor46M8RXxP6Exdrerllnd+MPD1
	VHeshqcT0dO7hPl+gK9HWmFIjENZIdXEAAFDVvENwD0yr7iHs2pnZA3vc27tg5rASpDIB+
	dAv/bniQKePbwPzzW03YhM7oCE+xl6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769609;
	b=rc/2Az98icCqL28MG4tiHxo/9jTN6YUYPlsfbFDXFCciCodKL3h21vtQnI0at4VPULvFud
	lwbHEWtBdCpLAHP+cJ9L3GJnOw4Z8wBnYqrQ0DHhnTPYt2O4SeHUwRLDryy0Buu5+/wFdu
	LV5nyQrh0xaJn1h7ClbxdWq4i8vuoaI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa08f;
	Mon, 7 Sep 2026 16:26:44 +0800 (GMT+08:00)
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
Subject: [PATCH v3 3/8] mm/page_owner: Add COMM filtering with wildcard support
Date: Mon,  7 Sep 2026 16:26:15 +0800
Message-Id: <20260907082620.2083838-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa11a70229kunm225d16da162cfb
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGktMVh9OShlDSh8dT0hOHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44A3B1C0006
X-Stat-Signature: rhbgqj3pees9kuuwqknwsbebjg8zteir
X-HE-Tag: 1788769607-812088
X-HE-Meta: U2FsdGVkX19lNKh/azsR8axwhXjgnTP6boDO3y8RxerGOBvYGrORg3xk4KblIwF6VpjDoiuMeMhDl90RMyisHJNfA6VQhWHTLWx7JjBS1IUdqxhGH/rVj78r0B4LeEVFzZtE9OYYxSJZQxrENet+Ktyw6vOjII/HozZM7hBYVPi67YFhDR7IpmFAPrkkVRr7vdmAfX/hFIWB0M9Bk9Zo6VzSmw9nuq3tmPh/N+YKLE3pyD4HaE3x10S93ZLm4DjU9G4iirjn0x/FcaZY3m2nQmngGni94CI/+e9IjTX5H/yN+r6QjzyS6gMs36b1ZblYvxaavhSZ9SIw5sFvxhAGPXea/YFvCIGPyuYkpf0pyLLkzcXx6UHEFjwIB9qld0xHYWBHJ7AdrW+Q8NyyjWZJCYEuThERKbqePCtdauypC2xYEo7NbEgMg6rldJAW8BUZvTGu9MICjtqItHOhT/rDH1En+p0pmWVC2NVFKIR3hopDLq07HDNtqhIavdFZJG2beOrvxVMmt2Nrhw277wsss2CZ0APg8YO/58hxy1jBhIDllFVQh9qN/QdiyIxWibec/QcuSy67L+S5W1XuEiOXVhuCYpA+RJYhDGBSUh3wqUK+s/TDlf/UL84NzajZDpT0uei1hG+F6nuHoxAe3SEbkbomv87f0IGvoUrU0ScNJdi076W1PTNclEaNVusZBmqr0Nc2ux2gSgmF/t/q4ggPW36s4Fm+Ga4QXB+UoZnoorIVnBUl4MNqJOITKrWucTfxu/NwOyiRLga0v+Y4ihf9+BoGy7qJ/mgiJL/XjdB9J5o/N9AHJaru5NDmCQKT/+xqH4mWNiq2a4Um+goutMu4gkRvH2TIj2TsCcofMeQGh7DP1qx8Qr4+c3mUN4kJxDAI2Ze2Ay9iMDoW+lXsUQuO/H2ZHX38xLQKyrRWMZNjzK2a0TuIo6EHmpJVvh+WJ0Z7Og8xYMW5CqcOO7Qxbim
 dxoHjS7w
 v65Sbihic5ywCQXenWo7KNV/7GJJwPnGcFYv31NDbwjaTVxyndtt3U4adxPeuMl9zqRmoeRe1xvaqxxyORsEiPKMM6uw31/cXEIvAkB6PNM0zxitrxByAvVRTfbwDrfhSMkjoYLlU/TJLcxZzFBCxlD3RB7lPrkRqdTYxhR6lPETwb9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add process name (COMM) filtering to page_owner with glob-style wildcard
pattern matching support. Users can now filter page_owner output by
process names using flexible patterns.

Supported wildcards:
  *    : matches any sequence of characters
  ?    : matches any single character
  [abc]: matches any character in the set
  [a-z]: matches any character in the range

Examples:
  comm="python*"  : matches python, python3, python3.9, etc.
  comm="*sh"      : matches bash, zsh, dash, etc.

Also select GLOB from PAGE_OWNER. glob_match() is provided by
lib/glob.c, which is only built when CONFIG_GLOB is set, and
CONFIG_GLOB is a hidden option without a prompt. A config that enables
PAGE_OWNER but has no other GLOB selector would fail to link with an
undefined reference to glob_match().

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- No change.

Changes in v2:
- Select GLOB from PAGE_OWNER so that glob_match() is always linked in
  when the feature is enabled.
- Drop the kstrdup() copy in parse_comm_list(); parse the token in
  place, matching patch 1.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-4-zhen.ni@easystack.cn/
---
 mm/Kconfig.debug |  1 +
 mm/page_owner.c  | 71 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 5737a504efbb..c94c30a60cd5 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -106,6 +106,7 @@ config PAGE_OWNER
 	bool "Track page owner"
 	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
 	select DEBUG_FS
+	select GLOB
 	select STACKTRACE
 	select STACKDEPOT
 	select PAGE_EXTENSION
diff --git a/mm/page_owner.c b/mm/page_owner.c
index b27a96aba482..792eefdd419d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -14,6 +14,7 @@
 #include <linux/sched/clock.h>
 #include <linux/bsearch.h>
 #include <linux/sort.h>
+#include <linux/glob.h>
 
 #include "page_alloc.h"
 
@@ -72,6 +73,7 @@ static const char * const page_owner_print_mode_strings[] = {
 #define PID_MAX_DIGITS  	7
 #define MAX_FILTER_PIDS 	16
 #define MAX_FILTER_TGIDS	16
+#define MAX_FILTER_COMMS	8
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
@@ -80,8 +82,10 @@ struct page_owner_filter_state {
 	nodemask_t nid_filter;
 	int pid_count;
 	int tgid_count;
+	int comm_count;
 	pid_t pid_list[MAX_FILTER_PIDS];
 	pid_t tgid_list[MAX_FILTER_TGIDS];
+	char comm_list[MAX_FILTER_COMMS][TASK_COMM_LEN];
 };
 
 static int cmp_pid_t(const void *a, const void *b)
@@ -854,6 +858,20 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 						    sizeof(pid_t),
 						    cmp_pid_t) != NULL;
 
+			if (!proc_match && state->comm_count > 0) {
+				bool comm_match = false;
+				int i;
+
+				for (i = 0; i < state->comm_count; i++) {
+					if (glob_match(state->comm_list[i],
+						       page_owner->comm)) {
+						comm_match = true;
+						break;
+					}
+				}
+				proc_match = comm_match;
+			}
+
 			if (!proc_match)
 				goto ext_put_continue;
 		}
@@ -997,6 +1015,27 @@ static int parse_pid_t_list(char *str, pid_t *list, int *count)
 	return 0;
 }
 
+static int parse_comm_list(char *str, char (*list)[TASK_COMM_LEN], int *count)
+{
+	char *token;
+	int i = 0;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		token = strstrip(token);
+		if (*token == '\0')
+			continue;
+		if (i >= MAX_FILTER_COMMS)
+			return -E2BIG;
+		strscpy(list[i++], token, TASK_COMM_LEN);
+	}
+
+	if (i == 0)
+		return -EINVAL;
+
+	*count = i;
+	return 0;
+}
+
 static ssize_t page_owner_write(struct file *file,
 				 const char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -1011,8 +1050,10 @@ static ssize_t page_owner_write(struct file *file,
 	bool new_nid_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
 	pid_t new_tgid_list[MAX_FILTER_TGIDS];
+	char (*new_comm_list)[TASK_COMM_LEN] = NULL;
 	int new_pid_count = 0;
 	int new_tgid_count = 0;
+	int new_comm_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1024,12 +1065,19 @@ static ssize_t page_owner_write(struct file *file,
 	 */
 	if (count > 32 + 6 * MAX_NUMNODES +
 			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4 +
-			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5)
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5 +
+			TASK_COMM_LEN * MAX_FILTER_COMMS + 5)
 		return -EINVAL;
 
+	new_comm_list = kmalloc_array(MAX_FILTER_COMMS, TASK_COMM_LEN, GFP_KERNEL);
+	if (!new_comm_list)
+		return -ENOMEM;
+
 	kbuf = memdup_user_nul(buf, count);
-	if (IS_ERR(kbuf))
+	if (IS_ERR(kbuf)) {
+		kfree(new_comm_list);
 		return PTR_ERR(kbuf);
+	}
 
 	orig = kbuf;
 
@@ -1044,6 +1092,11 @@ static ssize_t page_owner_write(struct file *file,
 		memcpy(new_tgid_list, state->tgid_list, sizeof(state->tgid_list));
 		new_tgid_count = state->tgid_count;
 	}
+	if (state->comm_count > 0) {
+		memcpy(new_comm_list, state->comm_list,
+				state->comm_count * TASK_COMM_LEN);
+		new_comm_count = state->comm_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1083,6 +1136,10 @@ static ssize_t page_owner_write(struct file *file,
 			ret = parse_pid_t_list(token + 5, new_tgid_list, &new_tgid_count);
 			if (ret < 0)
 				goto out_free;
+		} else if (!strncmp(token, "comm=", 5)) {
+			ret = parse_comm_list(token + 5, new_comm_list, &new_comm_count);
+			if (ret < 0)
+				goto out_free;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
@@ -1093,7 +1150,9 @@ static ssize_t page_owner_write(struct file *file,
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
 	state->nid_filter_enabled = new_nid_filter_enabled;
-	state->proc_filter_enabled = new_pid_count > 0 || new_tgid_count > 0;
+	state->proc_filter_enabled = new_pid_count > 0 ||
+				     new_tgid_count > 0 ||
+				     new_comm_count > 0;
 	if (new_pid_count > 0) {
 		memcpy(state->pid_list, new_pid_list, sizeof(state->pid_list));
 		state->pid_count = new_pid_count;
@@ -1108,10 +1167,16 @@ static ssize_t page_owner_write(struct file *file,
 	if (state->tgid_count > 1)
 		sort(state->tgid_list, state->tgid_count, sizeof(pid_t),
 		     cmp_pid_t, NULL);
+	if (new_comm_count > 0) {
+		memcpy(state->comm_list, new_comm_list,
+				new_comm_count * TASK_COMM_LEN);
+		state->comm_count = new_comm_count;
+	}
 
 	ret = count;
 
 out_free:
+	kfree(new_comm_list);
 	kfree(orig);
 	return ret;
 }
-- 
2.20.1


