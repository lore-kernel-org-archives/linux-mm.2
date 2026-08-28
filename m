Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA176C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4006B009D; Thu, 27 Aug 2026 23:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485666B009E; Thu, 27 Aug 2026 23:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375846B009F; Thu, 27 Aug 2026 23:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4976B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:14:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8304DC033C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:07 +0000 (UTC)
X-FDA: 85149209334.02.1B620F8
Received: from mail-m6010.netease.com (mail-m6010.netease.com [210.79.60.10])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2B21B1C0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:14:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.10 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886845;
	b=LnXuFpTuYiwym5j+m3o5YiwriiB/mKB+7zaALEaXRJStvXmV3D348CvRluPfGRZJfKUHtN
	EoUbpfqsop09Cpn01HW7triD9mpL9/4paDDXpTjJeMcwIuI0wj4dR57AtzJBCVWpLO++DL
	8k3szbE0SNgdGGNpL/D24VWJyAnALR8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.10 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5QIwOQG+9zjcdKB3bcsVaiupq9x+FsFnYJGhWMWJpk=;
	b=JtAyMGwp9WVcig4TuTai/cv6NysZJ6XSEOrEVGfqF1a77rfnXhGyh/tCUxyfSyMoryJiHC
	Ak8bXTOm2ggDCT3P68BCUtSMhXVnz9XXi3PTpYMTKUyunvi1j+nIkRQDKL5Bm9OO2VmjBn
	k4CVMKMPqSDQarU+GvsphDgRPT7Ca0Q=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e6a20db8;
	Fri, 28 Aug 2026 11:14:00 +0800 (GMT+08:00)
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
Subject: [PATCH 7/8] tools/mm: Add memory cgroup filtering support to page_owner_filter
Date: Fri, 28 Aug 2026 11:13:38 +0800
Message-Id: <20260828031339.1270699-8-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0465c2c190229kunma81ef96712a35a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGR8eVkxNHh8YHR5IQkxKGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B21B1C0004
X-Stat-Signature: ycd15qswjf37d93t84ijtm1rekc1mgm7
X-Rspam-User: 
X-HE-Tag: 1787886844-317606
X-HE-Meta: U2FsdGVkX19hiT3lJjRpwPy1HeY1zfFxarJXV75lb6MSwUNxftyTmpYc68wE5kU1KjblJ4E1mncAIwJces0GDnRZ7ED+ad985QfYFKJds9HU1Bv2iso/gYebU+Jj24j/5SHcCDlCYCMG/8XrgX6e+tlRjvlgcOXDSXkOhNdVGKk6e37YCuvdFdnobxTbK+QA+Rz357G2nF8ZUcAm0MHe+fhlMz2nkvK8ojTBRddqyS0YXRhEKu/5VX9R0eC77EsApWpGKeL8y6V6HZqePtPWJ2p7zZ4RdQ+7XN+IzfgNy+B7/tNIokd3AT4TK06VC95NZpGyarhb3iLhAN3f0HD89kuyprk9x0IJZKVVHBGVlbIy8QHvCU9AeJ/VILj+969jnLArkZN9gGnAo3wEJMYqyC6E3sMR2gEGU3daJ1aOYJbYnrAFgPKU+Pw4fHRUEi2qrrDBh4z5dJpWykzLnSzhd31tfnkjI/pIRRZpDWtmJ6GB+eze9vxIQotgsfcrcywMCLJxksCTMrVa8E0dJxONSQ2PHQ0jSjs4oJqId7em02Et74UJHtguRYpHYDxCjYrLpRpR2WxTGwnecUUvMfPTWQAidafJ6KWKyPFky75sEdfWLs1MbPMALOaP6bIBVYB9eENN0U3OLmEFpp6EtQo+a7+QlZgYBsL/pyiQgg9oAk4zb535cl9HDgK8OnNG32EsEVXk1n3P+2GVMwStNn1iibgFtz9lF/Fs5Wku3kMCmA2Aseo2fP471+RP1r9VB0IedXqkxsy1TmohAWWCTua81b4GItfFd7ex2Ep7xhOVrOTwwNoVdvIgCNYcvY64BKMPVgU9pQvRFlba1W8GBJce46rLeqLC82zhI+DPK4UmKk9XdOkxdLd8y9fMYOVDY/8qVvEF4ShJZSK055hBx1LXF9x9JYFar+G3a0JXL6fSvvSgLRAvkpMzzPml9eat0mVEic243w+M9Z2Gxii60Fa
 lLQS3uYp
 Arn2VzZ6mLbbRb6R/4A7y8p/kd3t6zK0l79att4tLOO+ERL7kzm3xgclOBtNu4v1W9KWG1QfkkvYVToKTeSBSl3/3INz/MXaPPjPLrnjHeJZ/kXnzXbTrVfeWiciaRYvUPvBX1opnqTWszOQ+JO8zKhNvlS41TxlFy6lH04YBwYHei0j1WtAkwEG6ijDocVU/4QaUziIFyBpuWsbnV01nefbU8Rpus4wZ3TmcqfMxVbo/a4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add filtering capability for page_owner to allow filtering by
memory cgroup path.

Filter page_owner output by cgroup path:
./page_owner_filter -g /
./page_owner_filter -g /user.slice
./page_owner_filter -g /user.slice -c systemd

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 tools/mm/page_owner_filter.c | 56 ++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
index 9256ffad4939..1ffbe4387854 100644
--- a/tools/mm/page_owner_filter.c
+++ b/tools/mm/page_owner_filter.c
@@ -20,7 +20,7 @@
 #include <getopt.h>
 #include <signal.h>
 
-#define MAX_CMD_LEN	512
+#define MAX_CMD_LEN	2048
 #define TASK_COMM_LEN	16
 
 static void usage(const char *prog)
@@ -33,12 +33,13 @@ static void usage(const char *prog)
 	fprintf(stderr, "  -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)\n");
 	fprintf(stderr, "  -c, --comm COMM_LIST  : Process names (comma-separated, max 8)\n");
 	fprintf(stderr, "                          Supports wildcards: * ? [a-z]\n");
+	fprintf(stderr, "  -g, --cgroup PATH     : Memory cgroup path\n");
 	fprintf(stderr, "  -o, --output FILE     : output file (default: stdout)\n");
 	fprintf(stderr, "  -h, --help            : show this help message\n");
 	fprintf(stderr, "\nExamples:\n");
 	fprintf(stderr, "  %s -m handle -o output.txt\n", prog);
 	fprintf(stderr, "  %s -n 0,1 -c bash\n", prog);
-	fprintf(stderr, "  %s -c \"python*\" -t 1\n", prog);
+	fprintf(stderr, "  %s -c \"python*\" -g user.slice\n", prog);
 }
 
 static int validate_mode(const char *mode)
@@ -221,6 +222,38 @@ static int validate_comm_list(const char *comm_list)
 	return 0;
 }
 
+static int validate_cgroup_path(const char *path)
+{
+	char cgroup_path[512];
+	const char *input_path = path;
+	int is_cgroup_v2 = 0;
+
+	if (!path || strlen(path) == 0)
+		return -1;
+
+	if (path[0] == '/')
+		input_path++;
+
+	/* Check if v1 memory controller exists */
+	if (access("/sys/fs/cgroup/memory", F_OK) != 0)
+		is_cgroup_v2 = 1;
+
+	if (is_cgroup_v2)
+		snprintf(cgroup_path, sizeof(cgroup_path),
+			"/sys/fs/cgroup/%s/memory.stat", input_path);
+	else
+		snprintf(cgroup_path, sizeof(cgroup_path),
+			"/sys/fs/cgroup/memory/%s/memory.stat", input_path);
+
+	if (access(cgroup_path, F_OK) != 0) {
+		fprintf(stderr, "Error: Cgroup path '%s': not found or no memory controller\n",
+			path);
+		return -1;
+	}
+
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	const char *output_file = NULL;
@@ -240,6 +273,7 @@ int main(int argc, char *argv[])
 		{"pid",		required_argument, 0, 'p'},
 		{"tgid",	required_argument, 0, 't'},
 		{"comm",	required_argument, 0, 'c'},
+		{"cgroup",	required_argument, 0, 'g'},
 		{"output",	required_argument, 0, 'o'},
 		{"help",	no_argument,	   0, 'h'},
 		{0, 0, 0, 0}
@@ -266,7 +300,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:o:h", long_options, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:g:o:h", long_options, NULL)) != -1) {
 		int len;
 
 		switch (opt) {
@@ -340,6 +374,22 @@ int main(int argc, char *argv[])
 			cmd_len += len;
 			break;
 		}
+		case 'g': {
+			const char *cgroup_path = optarg;
+
+			if (validate_cgroup_path(cgroup_path) < 0)
+				return 1;
+			const char *path = (cgroup_path[0] == '/') ? cgroup_path + 1 : cgroup_path;
+
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%smemcg=/%s", cmd_len > 0 ? " " : "", path);
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
-- 
2.20.1


