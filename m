Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152F6C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0896B0099; Thu,  3 Sep 2026 00:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598626B009D; Thu,  3 Sep 2026 00:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF086B009E; Thu,  3 Sep 2026 00:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2132F6B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E12B803FA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:41 +0000 (UTC)
X-FDA: 85171144842.04.E951B33
Received: from mail-m826.xmail.ntesmail.com (mail-m826.xmail.ntesmail.com [156.224.82.6])
	by imf31.hostedemail.com (Postfix) with ESMTP id EF0DE20003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409119;
	b=N1FBwy/nfKAJFbguz1uhsVyaqDBDjz24xyI8ZLnPV+r9u+IbRDNgF8Vjk8PvgRWUGrrXox
	KZ2/u4V09S61J2uksx1gcv7glx3h5jsGci2zV5peCYODXtbjzYwRYrGleJ87//K3LfSc2N
	O/53qyHaWxNy4bD+/bhIxVbzBfpoiiU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PVBcpYYDA25Hox89XHEadxCEMgHpLC0GesAA20379c8=;
	b=WKlgRlzHK0hwwoxl8qXqB+pYzuH5Ot4ynAZSI9i+7gNxC5EdMznKE3VX1AOFDkJpZGH43v
	jf/+IkZOI0igvx3G6QBi4TdTER1rVIj1ZbDqO890OihfWzZ31Od3KteIqRJPa08U+uSC1X
	X/Zx8tR86AMD3XOXzuDHulK5SrF9PFA=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3b0;
	Thu, 3 Sep 2026 12:18:34 +0800 (GMT+08:00)
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
Subject: [PATCH v2 3/8] mm/page_owner: Add COMM filtering with wildcard support
Date: Thu,  3 Sep 2026 12:18:14 +0800
Message-Id: <20260903041819.1776630-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d6ef30229kunm7336907a330ab
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTExDVk5NH08YSkoYTE9DGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF0DE20003
X-Stat-Signature: ebis69674s6zdwtto4i47btgtc85pqfm
X-HE-Tag: 1788409118-557393
X-HE-Meta: U2FsdGVkX18UtmWVCLyZQtMscNZYumr9rmwxaGYDxUJAaIDMKtL35q06Y6tC23tb0d1/Oto36jwnIYz6uD+OlnGErtISUamn5y222U8ivpH9Cuv1daYap3rEUFJcX+UDGhLSVofWi/E0edUkN7bkp/s7RcBDAzaNWI+tQls83AQUy0/mv1Q0rmL9u3SQqeYhkWrdUXd0PLBK8Z9ovB3n1fB7rpLg5oRjMPv+T7y874MARIPHzeQt+fOSTaCSOdGAe86Qk1ZV1H3yV45HAqEfcVIpNrBg5kPs6DWNOBdIVUPnTpMup8D9WN37wb2HOa32jQNtbjIf6PFpbRfN+7Oy//M1Wta0dMy2td28un2HimBn04XnNmGnhInCAyMwvTPQcJ4//k8xTu1Gxa6XJvG6sJ8CX0tqAGS4uXlkV/6GrTtMnHwif60W4CSL9zdZUQuKp34jdK48owLxtUuBWpt6U4Z5NTZeF+kyjzCYQGbhJvn5GNyN6+bSXmL2Bes/BN/mWejPwt2eBevcuAX9KGRaMZm0xv+ELujAPXUfCEs2zX4n3b7baHZrCZ0P4oLiy2jGGeOxuMiGsAiatM6k5noLg4+IrHIKhkjPh9hRi1w9NV5E80OQa/uFcfalkyV0fXAt9imlTuNMNnqn2dvvwPBM+cVmbc0bsMYg7dl+qWRVEQPtd1KmXxOrvf5KPaH33UoHdl/EQOROkIeXNVjjwkFD9Rgziso4+2MxsVO6MBDeE0JJGFzgcujfo6iHrYGnrUJU/QpzJWA6D6ix3ZleOOZLFbhtJKAPV9kCY3qxyu5lUmR5jzmDoJAKtCCR5vpBMzg2HKtYzq2bNAs617ZCYc5UC06VgnH+HfsX6QEnmR8xXp/GFNJRU5vmE8h9/qVVxBuDCuoUjUGMPyCqmqUGtmEtktln9JlJWOGfuH8shQVFkw8sSqYrIstFfLIxpcH4UMI3qkkMSMkdz2TGz2wIai0
 4CIsU7+k
 jwroFuuOV+wSvGkpFbr5O+iTcw7plwEfEazobSD5W1lAVClAl66FGcJzLKl5KUbpspuhSDRc0jUJ+R+Y8CyyZc88vUGenJ2xDcleOjUEn455fneisEtpxl0bmwd8M2Bn3e5BLbTzuyXRYZxn38a1LEFf+WKhRfiI0hcxIm2Bfll6r65k=
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
Changes in v2:
- Select GLOB from PAGE_OWNER so that glob_match() is always linked in
  when the feature is enabled.
- Drop the kstrdup() copy in parse_comm_list(); parse the token in
  place, matching patch 1.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-4-zhen.ni@easystack.cn/
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
index e046e61eb98a..b8319bc3a368 100644
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
@@ -1012,8 +1051,10 @@ static ssize_t page_owner_write(struct file *file,
 	bool new_proc_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
 	pid_t new_tgid_list[MAX_FILTER_TGIDS];
+	char (*new_comm_list)[TASK_COMM_LEN] = NULL;
 	int new_pid_count = 0;
 	int new_tgid_count = 0;
+	int new_comm_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1025,12 +1066,19 @@ static ssize_t page_owner_write(struct file *file,
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
 
@@ -1046,6 +1094,11 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1085,6 +1138,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1095,7 +1152,9 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1110,10 +1169,16 @@ static ssize_t page_owner_write(struct file *file,
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


