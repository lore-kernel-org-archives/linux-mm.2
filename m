Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F15C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866D46B008C; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E156B0099; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B496B0095; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38DF16B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3F6F1603E6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:40 +0000 (UTC)
X-FDA: 85171144800.17.138095C
Received: from mail-m93246.xmail.ntesmail.com (mail-m93246.xmail.ntesmail.com [103.126.93.246])
	by imf19.hostedemail.com (Postfix) with ESMTP id E77851A0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.246 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLCc4VClc/Se2nv+gLXaXDpGV5bq9YlFJ072vd8oasA=;
	b=ZTmLxepHYbqj7LuQVKB28xVl8ujnuFJyHfRJLhn9R8vi8lQnFqqutibIQPMZteM3u4hFFY
	X5c6iuh29fsnXD6GDAQ+51g+hS7NHcFSXDlyoIkwb1S7+P0JPvw4SpzkNwLQsA7iceqrIz
	Yx9IZIcnhMHFHYL+vBc2xCh+F6QBsaA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.246 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409119;
	b=Ed2v5wBTURjoPWqpgGKz+0us74Erhh7ccJIspLRiswVhMnoUEwwHwHMeSKjdrfeg5GLX2U
	oWL24q4rwLRbJwfW2OnDbzD26fbuaGBlUv0uqPhCnB/Kj+J0WCixu+0aq7XH26QXOXnt3c
	odEFh96LkkFy2ZZXZEj689ej9MJ/8As=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3af;
	Thu, 3 Sep 2026 12:18:32 +0800 (GMT+08:00)
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
Subject: [PATCH v2 2/8] mm/page_owner: Add TGID filtering support
Date: Thu,  3 Sep 2026 12:18:13 +0800
Message-Id: <20260903041819.1776630-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d69820229kunm7336907a330a6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSE0ZVkoaSUpNSUtOGkNOGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E77851A0006
X-Stat-Signature: 4yub51ma13jnhrmjrkoiibe3iegktmgz
X-Rspam-User: 
X-HE-Tag: 1788409117-982017
X-HE-Meta: U2FsdGVkX1+DpWZe4xmm7PtwIJja1cx3rKHBlABXSKQfbavy2DeAp41BmuXiXoB84R1wbHB6XTlGBswidM8JRuvc5klwcJ9CVZ70Ms98EYzBuBUfv/q6O5J4J6F7LWyOQKfDhdd+1k0qh5munqxVCelg95xCjJ6jh+DRHzq8xwCe0OMaOyZw3dYaZsfwIiBOhY+UlPZLj7suXdt7eqwdmTJCntCb46lM9WX6WasRwdVQ3k+hRTUM4K6iMtTwCW8dY4nx0l0Je6tn8c7JFwkKYz0G8gSsUs7CFyRREcmn3cx6ryz4fiNQB8vyvXEXkWw4UhcU8pkNQmH4ugC7cW50LJVsawr9J8k0OP0FAnNlv2d/mIaFcOysh/vrCvAkBFOh1ETMZeRDB+9VnH8q75Oomlf1yM34HPcXPioYF8NOp0IEFnBwiRxP+qM696/AKTe/e0dDD1SCeNBdw4pLJLN1MUs08/nQuUtwH5lt3+j7Qn5ME8gbebvdr5/5f5uaVM35+ZKfHIbmOvr/IY0K5uJsQCWn2Bu81Q3h4rC/S8sEzVwsRQcIGCrE45fvfFVZV1phemPzupuOStjKFHOFyIG60ATjxv+sGnT5V8tCZWUW/Z570qQ2DUT52w0s68z0eoa0k4rP+9YHHUfeNRjFKF6iOKecQCG+JFW79qbki3iP/iwDd8VvpJvZ+e41XiIwbWA/p9yEpSxisl2fk47SN4UfBHDemBJu1iuCazuKBOVT7InRDdXkKzp0KwTRYkIJcebQW5AZDi2OzlZfHVV24Cn2B+x/N8AYK933Lb1aNhzII2Xcvjf8P/eQJmxJSpPZMKR4FBjkVkmDxXn8XVOdOEL/eshOcBdMSQE4/gTqLoSQ/bd2IL/T++jC1R4zuA0oSUrXPWhGJDWra6aBKjDISvYtfhLL9Tk8lAP2MfTaICrkW2NQUXZyozWUjWC0Tmh+Y5+cmMlfp91ZrizG1/TSPPT
 U6kwv0la
 HXdCjOoIrLblmIEsw+Xsybcjz3I2331y4+mZVoXd9N424ZO8CfYqA89BAoNuduuZHTqAOm6hgmyVy9+r4PMyfQ2s2RpiqtiQC7jy6n0eucJ/tTN+ZW2+eZBP/9k8GF9zM+Q3HxQpbc6Wrm6gFdKzMbyj1wwcfDonWW8Ts1/p9fKmQtvmFJM6V4SzFpYPvpvPakkAPdoHOO4pskdlipy0iR9tQ+BW0sFeNIbnPET/YAW2ScInutvIXPR9LcaylHgwsNVk8hYf5fBHPKks=
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
Changes in v2:
- No change.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-3-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 0ef081e443f9..e046e61eb98a 100644
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
@@ -1000,7 +1011,9 @@ static ssize_t page_owner_write(struct file *file,
 	bool new_nid_filter_enabled;
 	bool new_proc_filter_enabled;
 	pid_t new_pid_list[MAX_FILTER_PIDS];
+	pid_t new_tgid_list[MAX_FILTER_TGIDS];
 	int new_pid_count = 0;
+	int new_tgid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -1011,7 +1024,8 @@ static ssize_t page_owner_write(struct file *file,
 	 * - For list filters: (digit+comma) * count + prefix
 	 */
 	if (count > 32 + 6 * MAX_NUMNODES +
-			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4)
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_PIDS + 4 +
+			(PID_MAX_DIGITS + 1) * MAX_FILTER_TGIDS + 5)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -1028,6 +1042,10 @@ static ssize_t page_owner_write(struct file *file,
 		memcpy(new_pid_list, state->pid_list, sizeof(state->pid_list));
 		new_pid_count = state->pid_count;
 	}
+	if (state->tgid_count > 0) {
+		memcpy(new_tgid_list, state->tgid_list, sizeof(state->tgid_list));
+		new_tgid_count = state->tgid_count;
+	}
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -1063,6 +1081,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1073,7 +1095,7 @@ static ssize_t page_owner_write(struct file *file,
 	state->print_mode = new_print_mode;
 	state->nid_filter = new_nid_filter;
 	state->nid_filter_enabled = new_nid_filter_enabled;
-	state->proc_filter_enabled = new_pid_count > 0;
+	state->proc_filter_enabled = new_pid_count > 0 || new_tgid_count > 0;
 	if (new_pid_count > 0) {
 		memcpy(state->pid_list, new_pid_list, sizeof(state->pid_list));
 		state->pid_count = new_pid_count;
@@ -1081,6 +1103,13 @@ static ssize_t page_owner_write(struct file *file,
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


