Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84BAC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485D66B0095; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FB16B0096; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BBB6B0098; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01CEC6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92DFE4031E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:02 +0000 (UTC)
X-FDA: 85149209124.10.38CC954
Received: from mail-m82132.xmail.ntesmail.com (mail-m82132.xmail.ntesmail.com [156.224.82.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C748100002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:13:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/73O/DebCdEj7mf2t4BTKuj1WxJO/jCXygYEgnOHog=;
	b=hFtA02EbNeOB7jKa9WsJrTgFPNmF0gK6z2do25UDXScUguq1541Nq0zGeb7tw4iCo/ANX8
	Nr67RuedLjWNzu4PhSi7pJqJEUsmBrDAekbYvyKNhauWmyZBFTL39WsrWDI1eo5OC94X5Y
	v2W1gfuLeKHOxRP5Nb6n3Nkws23dfto=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886840;
	b=oyQnY8MELEjRONZevcZzvySIaugbVMXACh81KbTkVRKzkLTtb0HoAMOA57f0JE8FIladE4
	DQuNcnv3sRrofzuP/NETsyMefUjN235r31/EK0z6P4/HKCmoYOLco5XHjAi+IN/xF+wCzT
	ZKUU2+HPxqjxqhf7F6vsSXz7Y3Lmuc4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20da3;
	Fri, 28 Aug 2026 11:13:55 +0800 (GMT+08:00)
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
Subject: [PATCH 3/8] mm/page_owner: Add COMM filtering with wildcard support
Date: Fri, 28 Aug 2026 11:13:34 +0800
Message-Id: <20260828031339.1270699-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c18480229kunma81ef96712a33b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZT0JOVkJMSRkeH04dTENPGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C748100002
X-Stat-Signature: 37dgbhactpmwhpmeg7a5ew5ouo611diz
X-HE-Tag: 1787886839-732801
X-HE-Meta: U2FsdGVkX19tX/ZCdMFPXse06yn2uBjpiNQwira4vxjqoYMdpAovAbFzSCA4Pd0Vz7v/x8I1yw5JgVz7wOmo68gnpmx5gS5Rc2t2SkyIriDOzoizyQlRrlzApRNfO9KGCtm+Q5fscITCxzekS2wlTu0brH6hPxiG7mC3THVMVAw0xtLPBGg8NYkXNh32mjg1sFOa2/fGdr2rJY3gf0s2PJSKOhXH2LlT8xJY3wj2vMLwPVhYvQpeSIBcEtsRo5DfmGSWKwLJ8VBpjP9jza8Ohg/CYPV/ci9prUlj9cYYWpWAZp6M1vzynVcMCQ+gVDADcGDbY0xbQXf7Hm5D0G22qBDIEOTwZI+ftcq2nAH+ARjVEtilAkd9YzmLOvyrycsqf7B7JoFafNaryTLPJdAahHdrDYf8ufuP0NIO7GYKFnIawdIkJCbEkk7Kh9Ks7eW/+oisNAJgcZEQMn/wmwbakarG62UCDyGhkMCnIQ7npBfrsoD3HJBvCCoxZuSMLSjDt2+97SNyPVjDyc7eW2uFGQAGBMW/C/h9l0o76VrxKNcQgKGBfO1zxQMEp+YZCaCzqyfmldBZS/9LDr6TjNUmTioOlhXSK1v1YZV4mkweHo4OwslGz+G1BFCLTWnGLIoIWP41MoxGTvRwyS9Z3N2XDPuBgTrctalUMqAX1RMvQc7HPujaHz48t/u8mpWmxXcWR/CubQc5mvr614n4URWUnJF8ZiHSvCG5b96nMRXcbhjDjlytKaV1YSb/Jocnb5lE9F1QYv1Ffb9eJkFBzScoh1hJSnihjJN0j4b/KyefwN5DE3Pv9ex/SF7hc8hX3kJCAZmf8bhI2Vkm2pRiKa1tfqG5qjvB8wjJRhd5Px/LyAFmtVtG1hcc+lRwoGoc2i6hwd6JMBRZy5LRjBDbQgqjNwSdkuzgac1K8FNCDsfGDO2rf+dupEdgiXWjD1zGAxiWQNfgwzeZ4f4Qjz6OKNv
 4RtmRBn7
 +yE84fUoVrG2Bvx7MF4LbYf5xT9fLXeUsvZ3tRIHORAT4y4wgFCMdWL+vvso4I2lEvmz+pVASkmB4bA1O9d12Onis3GCGNqY/kbwz/OytCZPgCT0sLLWgJngW7lVdCEWrJenZFDFnVZ9x60Mv9aeKp/M0Fg==
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
  comm=python*  : matches python, python3, python3.9, etc.
  comm=*sh      : matches bash, zsh, dash, etc.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 077867e9e572..7cd533682054 100644
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
@@ -1007,6 +1025,38 @@ static int parse_pid_t_list(const char *str, pid_t *list, int *count)
 	return ret;
 }
 
+static int parse_comm_list(const char *str, char (*list)[TASK_COMM_LEN], int *count)
+{
+	char *str_copy, *token;
+	int i = 0;
+	int ret = 0;
+
+	str_copy = kstrdup(str, GFP_KERNEL);
+	if (!str_copy)
+		return -ENOMEM;
+
+	while ((token = strsep(&str_copy, ",")) != NULL) {
+		token = strstrip(token);
+		if (*token == '\0')
+			continue;
+		if (i >= MAX_FILTER_COMMS) {
+			ret = -E2BIG;
+			goto out_free;
+		}
+		strscpy(list[i], token, TASK_COMM_LEN);
+		i++;
+	}
+
+	*count = i;
+
+	if (i == 0)
+		ret = -EINVAL;
+
+out_free:
+	kfree(str_copy);
+	return ret;
+}
+
 static ssize_t page_owner_write(struct file *file,
 				 const char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -1022,8 +1072,10 @@ static ssize_t page_owner_write(struct file *file,
 	bool new_proc_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
 	pid_t new_tgid_list[MAX_FILTER_TGIDS];
+	char (*new_comm_list)[TASK_COMM_LEN] = NULL;
 	int new_pid_count = 0;
 	int new_tgid_count = 0;
+	int new_comm_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1035,12 +1087,19 @@ static ssize_t page_owner_write(struct file *file,
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
 
@@ -1056,6 +1115,11 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1095,6 +1159,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1105,7 +1173,9 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1120,10 +1190,16 @@ static ssize_t page_owner_write(struct file *file,
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


