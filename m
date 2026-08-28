Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A8BC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B396B009B; Thu, 27 Aug 2026 23:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B52B6B009E; Thu, 27 Aug 2026 23:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4436B009B; Thu, 27 Aug 2026 23:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD61D6B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CE11A3C02
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:06 +0000 (UTC)
X-FDA: 85149209292.22.74D46F1
Received: from mail-m607.netease.com (mail-m607.netease.com [210.79.60.7])
	by imf27.hostedemail.com (Postfix) with ESMTP id D755C4000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+sAdbIvumWMpnRHtFD9CeVnyJ3AcvOw+uljsgxJDkw=;
	b=2IPOHXKzcHsVtL01DVXjV0NpcGa8nR9bY0F19rQNVTAIcCx/1innN+IwDEirPzO28s63ub
	/utyslWj9tctoaWPPeKvEUSUcOwzyB9bsctcZyJQqeNlVJEEyxBLQtE5h3bqze/cWMA3ws
	L8XnInZbF1kDF8DtfHfvvCwE+i8GqMo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886844;
	b=O1g8/BnXD7Q0k6jsE6XdLQTnZ76EwRrGgQ0/6qTnW5BcofhuqoeudEMN2SGFJjLDOhhMHr
	PbPSKcTAbggcYOGPdjEXRWXy+b+cC17fzfaYnfKHMBl6f9PlNmDYect71UiTTGQbV0Kakf
	4xK+PHZreYSobt8i05F46ixOaqjgqRI=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20db2;
	Fri, 28 Aug 2026 11:13:59 +0800 (GMT+08:00)
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
Subject: [PATCH 6/8] tools/mm: Add PID/TGID/COMM filtering support to page_owner_filter
Date: Fri, 28 Aug 2026 11:13:37 +0800
Message-Id: <20260828031339.1270699-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c26f60229kunma81ef96712a352
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSxlPVkMaTxhITBkeShkZTVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 77on7nkmyu87dd5hy9zm6fway4mtno6c
X-Rspamd-Queue-Id: D755C4000C
X-HE-Tag: 1787886843-716118
X-HE-Meta: U2FsdGVkX19c/dHLO9Vmv0kDZM2E8l7J/xAsBHk2fCqSrBGaokUP59UVno2tDZYI3Nx7HWnH6eL927ujvHNUsQFL3hszE6bKKzmfHm5bQkyCeKVsA8NusfRtbMlZTzZO7S0xW7iULykAuzCb6JItIFpUYK8SlLaT+M6owk8T5RdsaOx+MhuHox6ei7BzFkUyxhfHKWVnZQ+5ciyVS7RMUbpUntOEkfXdeMVYvL+GhAF/8j8Q7J3Aez3RxvtW16BNRbsgXa1Jr5L5rlttMyLf0w/HaTv+1DTFRqozL4cq6cyZLedX4DPTNmtbCSZ+2KtRYvSACsAjfHqo/oI9xZe4vB6C/zo6f9dVeahi4ZPEUjkc1khRQmL0yHywNXQiM76s3kxW/52A0mnhoE1pAF30kxtmPo7joQjDEFiItS+eSV+0Lg4A7h/fjig8DyPF7pqQQdCPXGvzjvfAbeGy+9Fs2i578hTADEduIbKuUHETKC8nC9dFCv8scAGz93KdZRzGoRA5bXGAK1A4ZrMxoVvYMO+qlPZzQTilfTCat0j+NQ9t/lKMNXCjY5EdOCjgBY4/D+di1IfRvTua6bXdnlaJFLb7GUNx8e4UJhkhOIrcC9MV3fgyS0zipJtLG0VXYgjX8kVwplMvGp8k6BLD4AL7EM/uN4QxwvOvuIkzqrzGG/RmZKHjp5XxcMnNJ2FY9QRKT/gcp5Y3Bw+Yoy4+ZfQdCG7hbz6DVG5Iq+dzkgc2W2OWJPCKO8Jvg3NbgTM02zXeJGDsy7b5JLJdc1UNPH5mJ4eU0DXuQtqI9XvytZIR9QmKSwQzRJp6Bs4vrI1FRNN30aV5rGwCqA2R8KVfYf99qPbRuY9uolFsJHqBxomrIcRfrZQZddunv6vQbajlOLIvXw9+2g2WmgnN9+M9vw4VKl3Jr7ZmTQC7Cant97oROAnMAHnJdd/NOS7NhxEDemeRs7I+N9X6/V8HEYp9R5h
 bVA5DnTm
 tWTfd3WO9PNV/dbZPPIvikicGVWmdGzAMH9y2g5iv8ZXCvpkX7RgOEhonkF/uSzJb9Hs3Wkap1x2B6/fxFgL5fF98jfi80EKqwgWMXSdvpqbcbuTl9pnyc57ZRl6P0Khhdfe+pnWII9rMpY1v0Dx7oxRT44JBspzKyfHIjtTJM1Ugt97Y0ZK4fXKPAVfeeJ0iXRXTxiOH1RzrLq7kDCfAnOkQ2OUvB+KboDMVC2SATPTu5fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add command-line options for filtering by process ID (PID), thread group
ID (TGID), and process name (COMM) to the page_owner_filter userspace tool.

New options:
  -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
  -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
  -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                         Supports wildcards: * ? [a-z]

Usage examples:
  page_owner_filter -p 1234,5678
  page_owner_filter -c "python*"
  page_owner_filter -n 0 -c kworker* -o output.txt

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 tools/mm/page_owner_filter.c | 168 ++++++++++++++++++++++++++++++-----
 1 file changed, 147 insertions(+), 21 deletions(-)

diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
index 1d1f0a38678a..9256ffad4939 100644
--- a/tools/mm/page_owner_filter.c
+++ b/tools/mm/page_owner_filter.c
@@ -21,22 +21,24 @@
 #include <signal.h>
 
 #define MAX_CMD_LEN	512
+#define TASK_COMM_LEN	16
 
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage: %s [OPTIONS]\n", prog);
 	fprintf(stderr, "\nOptions:\n");
-	fprintf(stderr, "  -m, --mode MODE      : print_mode (stack, handle, or stack_handle)\n");
-	fprintf(stderr, "  -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)\n");
-	fprintf(stderr, "  -o, --output FILE    : output file (default: stdout)\n");
-	fprintf(stderr, "  -h, --help           : show this help message\n");
+	fprintf(stderr, "  -m, --mode MODE       : print_mode (stack, handle, stack_handle)\n");
+	fprintf(stderr, "  -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)\n");
+	fprintf(stderr, "  -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)\n");
+	fprintf(stderr, "  -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)\n");
+	fprintf(stderr, "  -c, --comm COMM_LIST  : Process names (comma-separated, max 8)\n");
+	fprintf(stderr, "                          Supports wildcards: * ? [a-z]\n");
+	fprintf(stderr, "  -o, --output FILE     : output file (default: stdout)\n");
+	fprintf(stderr, "  -h, --help            : show this help message\n");
 	fprintf(stderr, "\nExamples:\n");
-	fprintf(stderr, "  %s -m stack\n", prog);
-	fprintf(stderr, "  %s -m handle\n", prog);
-	fprintf(stderr, "  %s -m stack_handle\n", prog);
-	fprintf(stderr, "  %s -m stack -o output.txt\n", prog);
-	fprintf(stderr, "  %s -n 0,1,2\n", prog);
-	fprintf(stderr, "  %s -m stack -n 0\n", prog);
+	fprintf(stderr, "  %s -m handle -o output.txt\n", prog);
+	fprintf(stderr, "  %s -n 0,1 -c bash\n", prog);
+	fprintf(stderr, "  %s -c \"python*\" -t 1\n", prog);
 }
 
 static int validate_mode(const char *mode)
@@ -132,6 +134,93 @@ static int validate_nid_list(const char *nid_list)
 	return 0;
 }
 
+static int validate_pid_list(const char *pid_list)
+{
+	const char *p;
+	int count = 0;
+
+	if (!pid_list || strlen(pid_list) == 0)
+		return -1;
+
+	for (p = pid_list; *p; p++) {
+		if (*p == ',') {
+			count++;
+			continue;
+		}
+		if (!isdigit((unsigned char)*p)) {
+			fprintf(stderr,
+				"Error: Invalid character '%c' in pid_list (only digits allowed)\n",
+				*p);
+			return -1;
+		}
+	}
+
+	if (++count > 16) {
+		fprintf(stderr, "Error: Too many PIDs (max 16)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int validate_tgid_list(const char *tgid_list)
+{
+	return validate_pid_list(tgid_list);
+}
+
+static int validate_comm_list(const char *comm_list)
+{
+	const char *p;
+	const char *comm_start;
+	int count = 0;
+	int comm_len = 0;
+
+	if (!comm_list || strlen(comm_list) == 0)
+		return -1;
+
+	comm_start = comm_list;
+	for (p = comm_list; *p; p++) {
+		if (*p == ',') {
+			/* Check COMM length before separator */
+			if (comm_len == 0) {
+				fprintf(stderr, "Error: Empty COMM in list\n");
+				return -1;
+			}
+			if (comm_len >= TASK_COMM_LEN) {
+				fprintf(stderr,
+					"Error: COMM too long (max %d chars)\n",
+					TASK_COMM_LEN - 1);
+				fprintf(stderr, "  Near: %.15s...\n", comm_start);
+				return -1;
+			}
+			count++;
+			comm_len = 0;
+			comm_start = p + 1;
+			continue;
+		}
+		comm_len++;
+	}
+
+	/* Check last COMM */
+	if (comm_len == 0) {
+		fprintf(stderr, "Error: Empty COMM at end of list\n");
+		return -1;
+	}
+	if (comm_len >= TASK_COMM_LEN) {
+		fprintf(stderr, "Error: COMM too long (max %d chars)\n",
+			TASK_COMM_LEN - 1);
+		fprintf(stderr, "  Near: %.15s...\n", comm_start);
+		return -1;
+	}
+
+	if (++count > 8) {
+		fprintf(stderr, "Error: Too many COMMs (max 8)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	const char *output_file = NULL;
@@ -148,6 +237,9 @@ int main(int argc, char *argv[])
 	static struct option long_options[] = {
 		{"mode",	required_argument, 0, 'm'},
 		{"nid",		required_argument, 0, 'n'},
+		{"pid",		required_argument, 0, 'p'},
+		{"tgid",	required_argument, 0, 't'},
+		{"comm",	required_argument, 0, 'c'},
 		{"output",	required_argument, 0, 'o'},
 		{"help",	no_argument,	   0, 'h'},
 		{0, 0, 0, 0}
@@ -174,7 +266,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt_long(argc, argv, "m:n:o:h", long_options, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:o:h", long_options, NULL)) != -1) {
 		int len;
 
 		switch (opt) {
@@ -206,6 +298,48 @@ int main(int argc, char *argv[])
 			cmd_len += len;
 			break;
 		}
+		case 'p': {
+			const char *pid_list = optarg;
+
+			if (validate_pid_list(pid_list) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%spid=%s", cmd_len > 0 ? " " : "", pid_list);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
+		case 't': {
+			const char *tgid_list = optarg;
+
+			if (validate_tgid_list(tgid_list) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%stgid=%s", cmd_len > 0 ? " " : "", tgid_list);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
+		case 'c': {
+			const char *comm_list = optarg;
+
+			if (validate_comm_list(comm_list) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%scomm=%s", cmd_len > 0 ? " " : "", comm_list);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
 		case 'o':
 			output_file = optarg;
 			break;
@@ -220,7 +354,7 @@ int main(int argc, char *argv[])
 
 	/* At least one filter must be specified */
 	if (cmd_len == 0) {
-		fprintf(stderr, "Error: At least one filter (-m or -n) must be specified\n\n");
+		fprintf(stderr, "Error: At least one filter must be specified\n\n");
 		usage(argv[0]);
 		return 1;
 	}
@@ -255,15 +389,7 @@ int main(int argc, char *argv[])
 	ret = write(fd, filter_cmd, strlen(filter_cmd));
 
 	if (ret < 0) {
-		if (errno == EINVAL) {
-			fprintf(stderr, "Error: Kernel rejected the filter command.\n");
-			fprintf(stderr, "Possible causes:\n");
-			fprintf(stderr, "  - Kernel does not support per-fd filtering\n");
-			fprintf(stderr, "  - NUMA node has no memory\n");
-			fprintf(stderr, "  - Unknown reason\n");
-		} else {
-			perror("write filter command");
-		}
+		perror("write filter command");
 		goto out;
 	}
 
-- 
2.20.1


