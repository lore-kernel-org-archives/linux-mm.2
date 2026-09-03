Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3837BC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4622A6B00A6; Thu,  3 Sep 2026 00:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436696B00AC; Thu,  3 Sep 2026 00:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3279C6B00AD; Thu,  3 Sep 2026 00:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE5216B00A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C3EC1A0413
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:45 +0000 (UTC)
X-FDA: 85171145010.05.3B27B96
Received: from mail-m93248.xmail.ntesmail.com (mail-m93248.xmail.ntesmail.com [103.126.93.248])
	by imf01.hostedemail.com (Postfix) with ESMTP id 160634000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf01.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409123;
	b=qzXUUFuWSH+ivvM+4o6UbFDftc96spQkyC8zQ7X6gbN8GzmORohVLcDJKVR9Fgs6q7Mez8
	5ooVtlumog3fsftufnk5xlSMn9aI1QmcaAr3RFCgvr7T6j/hQSy53bsx6ILDcujR4SvkhV
	xxCSLArWUu8pwojTw9+vmZNi9KvUMrE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7M9ym2FiWYh5ToBU+uDTghV+oI8XYn8m7cguut78S9k=;
	b=FFBdMY0piV/bI+5eOBQra/IIz3U5Khlae6eCLrvdZ/mZr6ZHyIKZ9UHRqSSBXBi5/QV22G
	+kWpvGIe5KR1X+iM4bwX7L35A82VLuBpTC3p1+aVyftf+eYdbEFbW8Zbl+wjy2bczoxEFu
	X3yF5uHo9pIrJabf2grO8yNeN4Fi/x0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf01.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3b7;
	Thu, 3 Sep 2026 12:18:38 +0800 (GMT+08:00)
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
Subject: [PATCH v2 6/8] tools/mm: Add PID/TGID/COMM filtering support to page_owner_filter
Date: Thu,  3 Sep 2026 12:18:17 +0800
Message-Id: <20260903041819.1776630-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d7fa00229kunm7336907a330c0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQkIdVhhMTBhPGUlLS0pNTVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 160634000C
X-Stat-Signature: ijnht7y74hd3ijpkfwp997fbt8w4igdp
X-HE-Tag: 1788409122-198355
X-HE-Meta: U2FsdGVkX19R65nWumpwdpREJg6hpaQcFZvA7Qua077Xvn1oDEE9yiZ6lYhEUuRAWVocKlANzoTuOM3G2N7lhb12pSfuAgrRHmsaJKjtPLl5Q+ktaTH0WPXYYDkEECRps7jzPsPltBP4qFUYDjM35W13STEMU9J59nw7LEDt/T5YB+I1PV/fg8yqEAAS2tR6i3bSYQHejtmAKt5S5W29h+nvR4P1vQw+BXoTXTJ2nD8b3/RDrVippCT6dA8gJr/qsM1Ze/R5BQDd1eLVlWXvUfsvWvEpAatW8DJ1s9l3DmJNUDmtYtcO3VpRJTlXx608FDdeyo3Mn4pGegtT5RQc/6nHvPyfwztzJAxurLAFAx5iXVNC+E3iniW/ztg92ApePlp+nYvMR06YVgefxnO1rizbDvpvfFdmWGZ3qoLSWUIExOg9FUakqt/pstfAyYDguDikgwXidZXgVuCu3ub2CIl19tflWrwkZQP7LpzvByxNt4h8GvQ7uiY4S/eaHhQtIZBRrSXlE3+1oHBnjzXOkKPEUiGV96TgOP5nVRwZeCa05B5H2xibWHyyNc/6+/9GHCWwLcecllpLzl43lTW08ZjMapwAlZuOp11x2dlsQAzO6u/wdMC6TOBKDf1555LhikrLorQqAozNXYQjcLdprcf4szm3HrSOdLZsGVKoELJ9mdzKnqus6ldEYwMpCr0+cxAthQthfAIkbGO4xhdV0+P8Y9V3+KsSNHw1F924oMVO8PL+KiV4Pa1hWiBr498kP9Sf99/rH918lcgm5sLOZLvwHhD+7C2Xo6wXlLUof6/LmOpIzqySc/ntGtpR0noua3qVEezMH16AZ/UE98PfmuFxmX2vUKStnjaY0DX7viKNmQeuXUY2UInzaEpuP/Of7k4XQP7PPoXYjPR1/71zER4FiaXoNoWC3uWMtKYlhZi6ME7FbgpdP8IxRK6Ybmi13z+2KneEm3edNLfvlF5
 WYntWirl
 Y+8C/spaQXFB3ZuyrfNm/cOLn8QD+SHCUBdsyGmLjARqHxNbGkShbnsAIPEu+1QcrRcFmFrB0Ln3UNE9gUpy0z3lOHWj+ybJePaVfsZqEce33nhXveF6TYjkzyq95tup3X61On84vKWA2lWk9Uc5KHC3Dj8lG1nmuA75bvlL+uuatT5hwA2WZ7/KuSYcmeWQLVZxLhgZY3SwgoZz+rAQXgAwhbGNYdLmZQpahU74QverOKX9PGglmTBMK23qMvdve4/5CfePmc6rm08g=
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
Changes in v2:
- Print error messages for empty -p/-t and -c arguments.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-7-zhen.ni@easystack.cn/
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


