Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DA4C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2C96B00B2; Mon,  7 Sep 2026 04:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73ED6B00B3; Mon,  7 Sep 2026 04:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88BA6B00B4; Mon,  7 Sep 2026 04:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 988F86B00B2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A863A4C5A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:55 +0000 (UTC)
X-FDA: 85186285590.05.E88707E
Received: from mail-m82130.xmail.ntesmail.com (mail-m82130.xmail.ntesmail.com [156.224.82.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C1F740004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7x3kgaftLa8zT1g3YftfnATWPiAB5FVzvbduPI5I1Ms=;
	b=yGDi+kMXUHcvEMYhQvcecf9My6/ElNvEEUVJdnDPf8akDXyueak4rzuHxcMuBunJmKv9Qk
	5XQeUvaPSIvIS4+tNJLlahdnGjoKRPoBbM99KO98fuw1Ggduoy8BW1k4/wBajCO5chRbwj
	JKA+WKXPa8qfvMCdONivcuw5rznCmWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769613;
	b=QsJI4LT9DCXjfcIw4jksOR51uWPBZAfuWTcP7Mgq0V2bldt58s/0Dul8JRklG5Lt8tG1vf
	KB9SCjt5LvPbhplMtgggVXL1qP23etSx0iEgeeRki1wIPfxtAQexPaZz+jOGZWfx0p4pbL
	amk3FxbINfI08O3lZIzLPurOhKknnME=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa0a1;
	Mon, 7 Sep 2026 16:26:47 +0800 (GMT+08:00)
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
Subject: [PATCH v3 6/8] tools/mm: Add PID/TGID/COMM filtering support to page_owner_filter
Date: Mon,  7 Sep 2026 16:26:18 +0800
Message-Id: <20260907082620.2083838-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa20e50229kunm225d16da162d17
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGUpLVk5JQ09CGUxNTR5LQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: quei7hobg3e9ftqte98y4b5ywz6angzk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C1F740004
X-Rspam-User: 
X-HE-Tag: 1788769612-649413
X-HE-Meta: U2FsdGVkX19qI98y51n60IAhePJC5DwCmXy4y2oViTcLdCfCdDAkXSdCJio9CKhnfL6FmkvwcprVtQaHy7vy5+luHNsYtH5/8u/opJWeoFpgx3K3Mpf/Jls6AgKN5+ttLjimm2fjQaW86MCD6hbMUkRzFIOW8WBDF57E4CyO2GRTxUG/rvcxsp2LGkFEMaDkZlAlG56dYaCseaEqutcPNdLhoVCpxmYVJBPQ3q5UVEKpGHSbfoWnueAvO1SF+HQlati4q91azN0saZqGwByK/yqSLJBRaIQi7xKKO5MvCavdH+92ceNuhKPPZ9ZGXjlfQG20lQOB8WNTiu0w+M7WYk+Yq5FhZeu7sA86og2RVE4n9WM5zaKtA8ydcv9hoZUxbBqVrMPz+L/WdwmqKtfnR88XXwaFBVKtY7clzdRxFcBQOFr4DJOnqm76VNRkN5UVeQq20F+zSZI1wia0F1AIZow+30diwbSZ6l1mR3goOU01P2uKEhGM/TPXNPQNCWXSe+yEKpE0iY0qVhPYcRNfFj9U3U1DCvW+p/EjGdUEcklZS6k4IbEPVNm5fRP7OEf3W9DkSkEIkHZrDuOzmDEDLvuktQNG7giEyNOt1AVGhOkmrLmCxxQXRnVvc8+gT8G/hZCfc41NtAKHGmel8CgnkpEN+vpYVWzciTqU74TfCnR7GcUhuKst4n/sH42SJjkZNEFqqHaIaZqpiX9seOrO8mcgbEIJV3lFtscUcRMpZjxv83kmbGb/KEy7wJIVCjMwX5gM7XfPJp9v87tWCqM5QnxwU5e9AQFO5guEAs9ow1AHAH/A/2mqN/hNuIG2cyW1Qbmmcw2+eno+Hl/BggLyYfdykTDIyQqnHGGfN6i/Or9XsWrBxKKDoQ5+cgvF1G4rgVUAX+PYXDy1Y5MU4COglPjiO7j0ucmz6Rvc4noTu1a5tpWuE2HnTD9zcAkf1QoUu9B7gaTZybDSyrMmCGu
 qeoZz2cJ
 v0alXGGS5fGlqF9GNz8Fzzb4DlmruFpldc4jxV/0LhUXtHSQ4F5vIcODaWAnPSi3mDnOQ/XeR3dV5fYM5BkoOwViYmI6zhhCNPFNKkHRIHkw+cLSddmOjLL40SvChlBXu/nftDxHyKO0feX4mShQq/p7mgJvi6VLsJE/Y5nOW04Cd53I=
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
Changes in v3:
- No change.

Changes in v2:
- Print error messages for empty -p/-t and -c arguments.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-7-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-7-zhen.ni@easystack.cn/
---
 tools/mm/page_owner_filter.c | 172 ++++++++++++++++++++++++++++++-----
 1 file changed, 151 insertions(+), 21 deletions(-)

diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
index 1d1f0a38678a..516c2d109a6a 100644
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
@@ -132,6 +134,97 @@ static int validate_nid_list(const char *nid_list)
 	return 0;
 }
 
+static int validate_pid_list(const char *pid_list)
+{
+	const char *p;
+	int count = 0;
+
+	if (!pid_list || strlen(pid_list) == 0) {
+		fprintf(stderr, "Error: Empty pid/tgid list\n");
+		return -1;
+	}
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
+	if (!comm_list || strlen(comm_list) == 0) {
+		fprintf(stderr, "Error: Empty comm list\n");
+		return -1;
+	}
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
@@ -148,6 +241,9 @@ int main(int argc, char *argv[])
 	static struct option long_options[] = {
 		{"mode",	required_argument, 0, 'm'},
 		{"nid",		required_argument, 0, 'n'},
+		{"pid",		required_argument, 0, 'p'},
+		{"tgid",	required_argument, 0, 't'},
+		{"comm",	required_argument, 0, 'c'},
 		{"output",	required_argument, 0, 'o'},
 		{"help",	no_argument,	   0, 'h'},
 		{0, 0, 0, 0}
@@ -174,7 +270,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt_long(argc, argv, "m:n:o:h", long_options, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:o:h", long_options, NULL)) != -1) {
 		int len;
 
 		switch (opt) {
@@ -206,6 +302,48 @@ int main(int argc, char *argv[])
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
@@ -220,7 +358,7 @@ int main(int argc, char *argv[])
 
 	/* At least one filter must be specified */
 	if (cmd_len == 0) {
-		fprintf(stderr, "Error: At least one filter (-m or -n) must be specified\n\n");
+		fprintf(stderr, "Error: At least one filter must be specified\n\n");
 		usage(argv[0]);
 		return 1;
 	}
@@ -255,15 +393,7 @@ int main(int argc, char *argv[])
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


