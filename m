Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C64C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF4D6B0092; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486BE6B0096; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3280D6B0095; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D27F6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73029120417
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:40 +0000 (UTC)
X-FDA: 85171144800.30.4E821C4
Received: from mail-m93250.xmail.ntesmail.com (mail-m93250.xmail.ntesmail.com [103.126.93.250])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3E2AC0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.250 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9it2GyED78VQfgxN4NHt4A57q2qS7m8tYQrIRtJvHY=;
	b=e+Xs/y8eEr5pWHHxUwgKMjLflmEhwHp7+ZuGXAb5ma5AGgU1Uoac4qBKzPjO6ZKo0hT4gb
	gwCLTpOSH/NvqzbLw9TEXbYhxUILGM1CjZkJJ8gdK4CpAlrUclP8KTNXnI+ijsmMtftGis
	OkM7+wl69v4yhozBdx+CiTWoKbxIIsE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.250 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409118;
	b=DJSzBOj1qZnUdSUlK1eKNs1yTRD+WnN+wtlkOijYijnCdAQ6LLnPQc4d3cj5ZGMcUHNCQ2
	LJxBJar6ny6K34+EFiF1+e9kaSr4O5/j4PF8x1iwO6HXs152zO3HxRrCvZEmWbo0ih9XnS
	ggi2EQ1sbAPi2YKnxUZCeyl2eMbqmC4=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3ac;
	Thu, 3 Sep 2026 12:18:31 +0800 (GMT+08:00)
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
Subject: [PATCH v2 1/8] mm/page_owner: Add PID filtering support
Date: Thu,  3 Sep 2026 12:18:12 +0800
Message-Id: <20260903041819.1776630-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d642c0229kunm7336907a330a0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSU1IVkgZSRpNSEMYSEIYTFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: norxtp75mq5bn1kg6bj9g8csdpg4xqb9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3E2AC0008
X-Rspam-User: 
X-HE-Tag: 1788409117-932266
X-HE-Meta: U2FsdGVkX1/B1TGbbKGOFU+Rc24K84nmDzHWaWnQ3F2MOfdsT38nuf2QgKNISSzY6U5ekysZ4udNujFL+WQrblUKeyfoDe/X+h4mjfcftzXJ2bLKqzU6DNWs9blMheoIsMfajJpTrtxygGGsEnQFrzH21UsJuUWohdKeGrhuMPSwJypXS18mC8LqKiFhnyO6bXuCTU5zd7CzLBR07K0/jqEa2EaOwylf59/kKxijge+/0764pWAjpllM8MzuhyvJPmRUbX888Yl0am6fiJUB9D98HcuQpsolnxntcRflMCa6tOUWzHdxhppT+RHXye7y3KHpz/74+1582LMMIhjUeSUrgNDtCiVWAm+xrDRBNX9iOIHeZYSarARLnt1/QIhX1Mz01SRHaAcgH2zWwlCiFBiTFtvprsuoHu0u+ZakJXhQUHIYAZCMRXFJ536silsIiHHre5cVvYjErwGVlHo/VBSDoQmFVQbZo+VV8tL00CNBbTJCfBUZKPC84x554R/STYwpjbP6crQvci+7SkAN22EmI57mJRrkPixZiLYu4MoM80zkESHe+GOYZsRM7faPf75VEDHNhk4lGxCmY6SSX08lEOd3EiyIsfPpCnymVrxtBnxGrToZePFZIAjXwfYZrs9Sx7XYmNbq/NHI1zVMAfISAYO8Gz9RzCw5PqEN3Ji6mOm5F5ILLiJSS72kspoPxN08yGIrp027qz6rNPwaE302PQHUBpsDCCSrQEwTiO6K4gbHsy1YtSNFwEE3s7+zniETljUB2HJtSlEE+DnhgDBuBiDKzJhTJLSP7WwHXB6LwwQVONHrRv9/feUsLA6AB+FTBCXldaAAH2MCHoB3zZTdWEr/J7j/I6UQVhzkTk93CtYsgaDKHulnPeOWWEiIC4P//HYNbmMwP3NU1ChzNqXUDayxcM+I4ls+5Knt5kRP2I5CTTimRf998C/NENcFJfUUvncowNnC5S/PlXm
 QHloMH5m
 2vZQZGemeFAYUN18Ifh6EGwLTYbg6MuEja7kII+rw7XsItB2ApcUQVeoAEKpPZDv1oZ5sNKIPnSS7lgLep+kjOOfLH/6jMX4x2x3fiT4wePsKuzvysPrUOhIfQfXegn6jmHvC4ItUcKi4iyU1Wn1oVEhHQ6sGqy2q9H7QqZDAC3jh+R6mjxr45wGoZ72ReOZBrlDJp5Qf5PXo94MtWI3MBeNUIkTUYE9g1gIQdvIsuLVgl4CWpr7u/+nEbIWDEZe7fZPlYFYzFOKYTlw=
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
Changes in v2:
- Drop the kstrdup() copy in parse_pid_t_list(); parse the token in
  place. This also fixes a leak on success and a kfree() of an advanced
  pointer on error in v1.
- Use cmp_int() in cmp_pid_t() to avoid overflow on subtraction.
- Reject pids exceeding PID_MAX_LIMIT.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-2-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..0ef081e443f9 100644
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
@@ -949,6 +998,9 @@ static ssize_t page_owner_write(struct file *file,
 	enum page_owner_print_mode new_print_mode;
 	nodemask_t new_nid_filter;
 	bool new_nid_filter_enabled;
+	bool new_proc_filter_enabled;
+	pid_t new_pid_list[MAX_FILTER_PIDS];
+	int new_pid_count = 0;
 
 	/*
 	 * Maximum input length for filter commands:
@@ -956,8 +1008,10 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -969,6 +1023,11 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -1000,6 +1059,10 @@ static ssize_t page_owner_write(struct file *file,
 			}
 
 			new_nid_filter_enabled = true;
+		} else if (!strncmp(token, "pid=", 4)) {
+			ret = parse_pid_t_list(token + 4, new_pid_list, &new_pid_count);
+			if (ret < 0)
+				goto out_free;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
@@ -1010,6 +1073,14 @@ static ssize_t page_owner_write(struct file *file,
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


