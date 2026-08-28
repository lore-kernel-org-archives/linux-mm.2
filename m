Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D654AC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941BD6B0096; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA6E6B0098; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792EE6B0099; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9136B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B69EBC0338
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:02 +0000 (UTC)
X-FDA: 85149209124.16.FF722D0
Received: from mail-m609.netease.com (mail-m609.netease.com [210.79.60.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C2DA180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:13:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886840;
	b=1CjoDxyXR5t+Kp3Fxufvp2x/yBMSKvE9OQ7n/cmjtXB1B018lsaAtzavQdUXzPnVtb8/1y
	M602pRgErQ3FkOA1s2qCz/Kegf6MBIAHiWO8YA46R74VlJoviASbd+x9s00ivh8y/9Ubfx
	7r5JP9xpaoGgpPffgwYqvigbnCRDPWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bTMguYzUSOaCW3pohkzfD3nqsuOJzK91ZOhTlskV408=;
	b=PpnJpcfYVhgckCaXcRQsEUE+/2IRhCS0dR7wfGPSDtvySbP325z277efYdEAW7cYaMwwFJ
	jq8zv7zRo4IOnIni1ZgLrU5EwXvmeYS63NCQCWU1uCJZeAfaCL2N4uC0bOycS6AkrdxXvK
	Xzm79VBwxHdmH9SjJwogKC0ATleKIio=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20d97;
	Fri, 28 Aug 2026 11:13:54 +0800 (GMT+08:00)
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
Subject: [PATCH 2/8] mm/page_owner: Add TGID filtering support
Date: Fri, 28 Aug 2026 11:13:33 +0800
Message-Id: <20260828031339.1270699-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c12fe0229kunma81ef96712a32f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQ0MdVhofS0NMTRoaTRpDS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C2DA180006
X-Stat-Signature: bsphtgegdfu1rf4j7g7yhh8z4ygob8jx
X-HE-Tag: 1787886838-686297
X-HE-Meta: U2FsdGVkX18I2PTAKy6qDwc5+l3USruhadDB7pPeVaYAPiIT3gn0Rgj+OynVaqBW8KV/F+78lWyBbJw3zjjvpjiFqPr1XXAhSgZMDRg2YHs9PpjL34sf0Qs87/a7pfD687S/N0nCv73/1FObT+J/2Z3OZiUHhJPvWPwLRWd92g5ix9B5WI9Vutr88ZXTYYLTa7sYwL2vgFCq7Md1cEwYiOgHkpxwy1Z4KHMjHKbReisJaT1JjZheErwBuPOKSBSXfPQeHioG5pfXwOyE5Nha4zUYw+X/WX/lhXJoA5+LJKsvUENFqn5yi8Y8IZZs57m0GL2Ej2fyCIKjAN90UsXmcQCOgn+uiP/CEkO8S6FtgKtSf8oZzV8l+sUwqs1ooxp7yUypMQKLVTxO89YWPbL15xvQbvShXJ2qLMHuct2wMQ2vHCMsvZnZD6bc0WXID//3Dst2/8QvMQUnZEoBu0M3uWp/8JbWGhFMSCArNjwGM1wwMH9q6qVn9n1G3IM/ZQxaxQAW3R22OZfa5UeLV3QGB0QM9zk3z6L0Y1z1DV//h7FEMORE+kWGP8yqkr+SvGCRUYQysxWH4LaR/w1aU6EIOBoz/Zi8ASLcfKfBWr3mD0K4IWq9z/pgD9RN2b3uwUlt8xYMXb4CbXiJgGGIig1XcfLZBKGMKt0Axb9Cx/lN3s+zMFZWAt8eKxxYFtob8UVLsTbNkA+yzRXSbnX/ohgueIqNgt2Htmkim1t4tPoMWE9SMBW8I+XvMEhagiNaIFVen2WPojQJ2BS2kcN0xI/Bobb89C5PAMEwgEtmeYk4iHKv9IMNgmuq8t+na7sQcl1tVeTK4rEUm2bOvYq8FvhCUmSjJDV7OSyCaLuqVAhY6gtUDa95kYA001Tc+K+fBt7BRithE3bEEorfDsmkHEZTB7GT0cC6zPfijnKmb9vpNpZqnrBLojyeQMY0cekMn04yjzcE4Dz2QUqlmLbS5I9
 L1+c+J4S
 vgOj+sjMY2J6XnpFNCy1B1ePKG/pfw9+S+yGJRNlZ/v2AL1oO/Q72oTyxK1b9D1faIw7268Ctph7TwFzFa1sITAz+HdtNqRyXAsS2Au7gfYBY8iHGXolwFEWCEjudVB3p2CO/cgcFdPwCQpdD6P1Lnh4ufL6KWEI+gIDZWjAvtDbJIx+pyQvrKdC9AvfNGkyvHj7upXrnDZw6MILfhAUbf/R8VLFu0lRt0IrEgYjqWFZtLmQ=
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
 mm/page_owner.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 33b9e12a019b..077867e9e572 100644
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
@@ -1010,7 +1021,9 @@ static ssize_t page_owner_write(struct file *file,
 	bool new_nid_filter_enabled;
 	bool new_proc_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
+	pid_t new_tgid_list[MAX_FILTER_TGIDS];
 	int new_pid_count = 0;
+	int new_tgid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1021,7 +1034,8 @@ static ssize_t page_owner_write(struct file *file,
 	 * - For list filters: (digit+comma) * count + prefix
 	 */
 	if (count > 32 + 6 * MAX_NUMNODES +
-			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4)
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4 +
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -1038,6 +1052,10 @@ static ssize_t page_owner_write(struct file *file,
 		memcpy(new_pid_list, state->pid_list, sizeof(state->pid_list));
 		new_pid_count = state->pid_count;
 	}
+	if (state->tgid_count > 0) {
+		memcpy(new_tgid_list, state->tgid_list, sizeof(state->tgid_list));
+		new_tgid_count = state->tgid_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1073,6 +1091,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1083,7 +1105,7 @@ static ssize_t page_owner_write(struct file *file,
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
 	state->nid_filter_enabled = new_nid_filter_enabled;
-	state->proc_filter_enabled = new_pid_count > 0;
+	state->proc_filter_enabled = new_pid_count > 0 || new_tgid_count > 0;
 	if (new_pid_count > 0) {
 		memcpy(state->pid_list, new_pid_list, sizeof(state->pid_list));
 		state->pid_count = new_pid_count;
@@ -1091,6 +1113,13 @@ static ssize_t page_owner_write(struct file *file,
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


