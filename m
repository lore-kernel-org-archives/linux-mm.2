Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0DBC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1665B6B009E; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116E16B00A5; Mon,  7 Sep 2026 04:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005796B00AA; Mon,  7 Sep 2026 04:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C41B66B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3757F14068B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:50 +0000 (UTC)
X-FDA: 85186285380.22.23E6EF7
Received: from mail-m82130.xmail.ntesmail.com (mail-m82130.xmail.ntesmail.com [156.224.82.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 722A9C000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZiYWvh/i2J12BDyF9gma+ZZkhF7tARwSy1cG/RuwsU=;
	b=4s6pbpS9Mgi+9Ht2nigGaqNE/fKhbUFkc+EXNSHy8BmO0DOpdlo2sK7CLDiDZUvF4rUb+K
	68lcT5TXW4LZsLctDaUJe9ZHzaP79PI5LasKaR+o6R5fobE1Rs56fMsiIRgoECQC2m/44S
	oXphRk8vo8PRiAVZHFiNQ2gz5dh7UNQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769608;
	b=dUJDExh/11VkyEtMPJi2VvU4uIJJVucDdCS+s3AiTXBuebi2Ql0Sl0MxtEfmZcl0PPD/FH
	5pyWpuGrDRZSqRPhrEUZSFrqUdl2Q2wG1YMPAqRSZO6DpGDRm2vKLTrBEdUvL0tL6QdlRD
	BNv1W6x91hKez5K8hVLx5+g6qeSpkPg=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa088;
	Mon, 7 Sep 2026 16:26:42 +0800 (GMT+08:00)
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
Subject: [PATCH v3 2/8] mm/page_owner: Add TGID filtering support
Date: Mon,  7 Sep 2026 16:26:14 +0800
Message-Id: <20260907082620.2083838-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa0c990229kunm225d16da162cf0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGR9KVklJHh1JQktDGExISlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: w9qsi95iotcpf6fx1yetouibimbk13j4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 722A9C000C
X-Rspam-User: 
X-HE-Tag: 1788769606-795762
X-HE-Meta: U2FsdGVkX18LIL+qGgT8LQVVfwvqFC6Pxskmwn/NDVIIP7bHV5KFw2kK+fXH9bd49fHUNFiiSORvJAJqLl9Ulpd/4Gcyu2Z1IvHBS1DYtIdbYjy6DQqVkSzP0rbIyNE+Ld81NoRKCBBMn2oumcg8sJbZN7pw1Pnc+fp6EHAcOozeDyHbdHZr7tPW/0vMzp8Di0V0ulhkYU0SfskhdtiCO24N2iXyGDmd9DqGQ+6qsAzbR9fG3gOc4iQMbkFkry35iHjFZ7nqzU2P3vsoIJ2JlkBBmC28eG4XhmF8PZBxEQx41pKYYdX++4l6YN1Hj5zg3YjJY0gMz5EsVx5PXg662s1K/mZc5UWoDsaMT1TSimKpqfGlitjpK4A+RqBWzM+hu+0Xmwq7qOIT0jFy6eUfWHGPrHbe2JjQiPGWTrpMHfmNqebypx8ELttuF13O283uAIwLcc5/9FY8ekc5NgBdxywx+E92/3pfXBf2ZVOtGGKLNlBcCk1UbIhv6Xof4C/xxoxG/zQQmdJKRLlGWnt+5Ky5DclaZIKdWlxFJbbst4vcKUHvVW3FBOs9zJsVxfwSnWssHR6sSTNKExdYqzcJgYjCcIaPO3Rc8Ow9hFBupnxxvhPQ4clZmIoHw7bCOkHtT1JmDuKbNyx4W5wrkuJwp+h+TElXgV4MoVxny7FrMBoji7ZtmKLoLWhh2HsbrhAmEwtq9JxtT5pTO4rTbjQa4qAP6CB5l8zKl05NXO1zyDu38rDvUlKMYwyMtFBI7yyV4m3eTwY1fkhSTuguqwO6TsMn5shvn9IWaFj6+S6xqGiFaUe6GBi+daF8cpOyTZF7Pu3NDJQ4peLRenIZGf1lwmvORnETQY5+pSRtJFGit5T9NCW02LvIX8LgK6ZefuUpUwAHEh88cuSylsK2qKJ8d13KBJ+My7hcE5lNyhjO+lpKBrYphi3vTk8F7srFlK8fQMBJsz1m5gybgbqszsC
 kLJ0Ll6T
 xFcvrA31Wh2V72xJmiX0H62GxMqu1y0y9UoVqpoca0rAWSjEo7h/DtmSIdIH2cLeTjHyl8ZLYwZu6LW8ztdmi08zXto80LDBJNA9EmxLtQtHv9A1Mz4cLXjlGw/Gmn9xmPtsvszU8qLDDduSPnIHNEnuYSAGBoHTcVl3tnDiuM3sjPFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend filter to support thread group ID (TGID) filtering alongside
PID filtering. Reuses existing PID parsing and binary search
infrastructure with separate TGID list and count fields.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- No change.

Changes in v2:
- No change.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-3-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-3-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8c704f1916ff..b27a96aba482 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -71,6 +71,7 @@ static const char * const page_owner_print_mode_strings[] = {
 /* PID_MAX_LIMIT = 4,194,304 (7 decimal digits) */
 #define PID_MAX_DIGITS  	7
 #define MAX_FILTER_PIDS 	16
+#define MAX_FILTER_TGIDS	16
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
@@ -78,7 +79,9 @@ struct page_owner_filter_state {
 	bool proc_filter_enabled;
 	nodemask_t nid_filter;
 	int pid_count;
+	int tgid_count;
 	pid_t pid_list[MAX_FILTER_PIDS];
+	pid_t tgid_list[MAX_FILTER_TGIDS];
 };
 
 static int cmp_pid_t(const void *a, const void *b)
@@ -837,11 +840,19 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (state->proc_filter_enabled) {
 			bool proc_match = false;
 
-			proc_match = bsearch(&page_owner->pid,
-					    state->pid_list,
-					    state->pid_count,
-					    sizeof(pid_t),
-					    cmp_pid_t) != NULL;
+			if (state->pid_count > 0)
+				proc_match = bsearch(&page_owner->pid,
+						    state->pid_list,
+						    state->pid_count,
+						    sizeof(pid_t),
+						    cmp_pid_t) != NULL;
+
+			if (!proc_match && state->tgid_count > 0)
+				proc_match = bsearch(&page_owner->tgid,
+						    state->tgid_list,
+						    state->tgid_count,
+						    sizeof(pid_t),
+						    cmp_pid_t) != NULL;
 
 			if (!proc_match)
 				goto ext_put_continue;
@@ -999,7 +1010,9 @@ static ssize_t page_owner_write(struct file *file,
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
+	pid_t new_tgid_list[MAX_FILTER_TGIDS];
 	int new_pid_count = 0;
+	int new_tgid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1010,7 +1023,8 @@ static ssize_t page_owner_write(struct file *file,
 	 * - For list filters: (digit+comma) * count + prefix
 	 */
 	if (count > 32 + 6 * MAX_NUMNODES +
-			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4)
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4 +
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -1026,6 +1040,10 @@ static ssize_t page_owner_write(struct file *file,
 		memcpy(new_pid_list, state->pid_list, sizeof(state->pid_list));
 		new_pid_count = state->pid_count;
 	}
+	if (state->tgid_count > 0) {
+		memcpy(new_tgid_list, state->tgid_list, sizeof(state->tgid_list));
+		new_tgid_count = state->tgid_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1061,6 +1079,10 @@ static ssize_t page_owner_write(struct file *file,
 			ret = parse_pid_t_list(token + 4, new_pid_list, &new_pid_count);
 			if (ret < 0)
 				goto out_free;
+		} else if (!strncmp(token, "tgid=", 5)) {
+			ret = parse_pid_t_list(token + 5, new_tgid_list, &new_tgid_count);
+			if (ret < 0)
+				goto out_free;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
@@ -1071,7 +1093,7 @@ static ssize_t page_owner_write(struct file *file,
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
 	state->nid_filter_enabled = new_nid_filter_enabled;
-	state->proc_filter_enabled = new_pid_count > 0;
+	state->proc_filter_enabled = new_pid_count > 0 || new_tgid_count > 0;
 	if (new_pid_count > 0) {
 		memcpy(state->pid_list, new_pid_list, sizeof(state->pid_list));
 		state->pid_count = new_pid_count;
@@ -1079,6 +1101,13 @@ static ssize_t page_owner_write(struct file *file,
 	if (state->pid_count > 1)
 		sort(state->pid_list, state->pid_count, sizeof(pid_t),
 		     cmp_pid_t, NULL);
+	if (new_tgid_count > 0) {
+		memcpy(state->tgid_list, new_tgid_list, sizeof(state->tgid_list));
+		state->tgid_count = new_tgid_count;
+	}
+	if (state->tgid_count > 1)
+		sort(state->tgid_list, state->tgid_count, sizeof(pid_t),
+		     cmp_pid_t, NULL);
 
 	ret = count;
 
-- 
2.20.1


