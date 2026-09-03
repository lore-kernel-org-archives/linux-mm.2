Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EC9C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D496B00AC; Thu,  3 Sep 2026 00:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634F36B00AE; Thu,  3 Sep 2026 00:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BD26B00AF; Thu,  3 Sep 2026 00:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE406B00AC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF0FD1A0413
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:46 +0000 (UTC)
X-FDA: 85171145052.25.B42B8F4
Received: from mail-m93247.xmail.ntesmail.com (mail-m93247.xmail.ntesmail.com [103.126.93.247])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76F2B40007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409125;
	b=214MRMBwrQ2QKlzNC2eDDDhd2JDCeJHdXXn2LaNlzkCSlJfK9yY4ITxzoWkKAk5QFAtr0j
	qII4glFB7OQ+2Co3xIJwZOlFqZ6aFpBDvwsBkPfucMBEomlo/xOVtCYVmBzg6mS+4aAR0L
	4oVem9q0jmTeID938fiXTZxyET4CsOE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uW3zo/mel7Dm2VE/NVpG3qxnMQydkqs0oFK+GxUx8oQ=;
	b=Js7FA/oh0C/CaPwhnASV2xOcQn3V/Dqxh15gbirQH4k2a4cZUcEZdotn3Z2vONgXVhSbOg
	8jJOk3sPo2FBFAtsPOuqPn+MGzJ1sAlY3APeqWGOFKDlvYNo8ordCHXu2RS52Kbo0M+EmO
	1KlSv4pI6WoghKTNUzMEede9YlqL44k=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3ba;
	Thu, 3 Sep 2026 12:18:40 +0800 (GMT+08:00)
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
Subject: [PATCH v2 7/8] tools/mm: Add memory cgroup filtering support to page_owner_filter
Date: Thu,  3 Sep 2026 12:18:18 +0800
Message-Id: <20260903041819.1776630-8-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d85300229kunm7336907a330c7
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDH0tIVkNNHh0YHR8eTU1MTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76F2B40007
X-Stat-Signature: frtoh7c3qx3cmfp3cwppk7ftywkehi3q
X-Rspam-User: 
X-HE-Tag: 1788409124-458103
X-HE-Meta: U2FsdGVkX19IHZVL2dOvkF9NRcL07KB8h0cFnM8ilcRqJg7J/pFE4XM0gZOeGA28zAIL6xFP730Xb7wnqBJsktFHBwml/2nL5Rn5trR1Dqy2b2SZiIc6AuPQrFqZao0858vg0L2l+CcoT1B3tlnrrlje9UvvLUHdpPPEabIsCnkNJAcUH27B+mOCTEjLkLLrmywjRS0hoYj7ufpxdRmsVB7JwgKlbUFMpn0ZfNAurS3j7Z/GyeyiX5k63BZ+cxB+gjUsjLOQPgJ8KDQpNlxWJWTyOMQkYHGASKgqBFzsOdh0+aL8OPMYhhKkKuTKWCJZM1jHbiquFoQnHJ8OfI5vKqZZLbZxwav4TXm5RBu6dYZNLniNUKs/ZluE3axk01f7PyOwHWo1L/+2Fc0Gna1+GLZnlkajlkiL+Q4J/C72c+1fy/MqqsxNwezqZ/yy3FcLaQs+xtcleBOn4PeRo8Exu3Hx02wmM5HI70Kp+vIP6sRWTaABkfZfAOHfo2Y+Ca32gK6E7zi8QDoCEggM8LhSMi8KzfUSCxnzMIL3qisBcS8V7EIkwVPJ4FvnyoD+zgfpLoVHEjoaAEV4sSSQ3Br4UO6ur/lUhZ3NfRBE870O9+Mv+0oUctA39iwm8VgN7S0uXpYlqb+Dt5zh1XxvIfuUPY0EqeFY4J+L5ySpJxxMKqM30qZt3HtGpcnV7pT+BJFGRgz2ISeuOeEACOteS2jwO2H+YzaWItz81MZXMEJE177j3A0ule1TNHTsMxQ09NGhWdKw43Oi8GQaf90i4/BtndiPxTVbxD1Y1AA3OavwB0ZUsCMIyf+1W0LNbse5aR6mXwhlEMeJ2gG+2Ulc+o46kN8ic26jJJF23SIUlmZ66KK2FC5XCAv1t81jJ3e/1Zv6OlihatdRAEqGF90xORgvtAidXerpGpNw3r7nnVLHV7DuJZ98Ad0YG8vhNioZ0Lvt+sOM8488W7pbVtd973/
 ZdGplXts
 OxAJR/rLhw78/WXw3uQaUFzpzO+emiKyWQDZAzjsIyoS5NMC5misFzFjeOyoKUZ29zEoZhjcuMZSfbWObDv9oO6fe3JcOlEPj7PoEhiIk+BjBiIJNYQQxYIiqnXMD7WGBUm4Ei+vG0iCMucNFTBQaWaMIXquNVXFOLGdj8h4AwN5FHh84swuOZLwfzbXgyKXUwhGRGTUihZZ16QDz7K8XEfV64XO2/sBSdUIJT2MS1rSmorn6DocaaHpmVIMGcebLN16C8R3fxNBmeHLUTY1QBCN7sBpxVdh8YBQ9OaBsozaTE+A=
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
Changes in v2:
- Print an error message for an empty -g argument.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-8-zhen.ni@easystack.cn/
---
 tools/mm/page_owner_filter.c | 58 ++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
index 516c2d109a6a..8aea7df23eef 100644
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
@@ -225,6 +226,40 @@ static int validate_comm_list(const char *comm_list)
 	return 0;
 }
 
+static int validate_cgroup_path(const char *path)
+{
+	char cgroup_path[512];
+	const char *input_path = path;
+	int is_cgroup_v2 = 0;
+
+	if (!path || strlen(path) == 0) {
+		fprintf(stderr, "Error: Empty cgroup path\n");
+		return -1;
+	}
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
@@ -244,6 +279,7 @@ int main(int argc, char *argv[])
 		{"pid",		required_argument, 0, 'p'},
 		{"tgid",	required_argument, 0, 't'},
 		{"comm",	required_argument, 0, 'c'},
+		{"cgroup",	required_argument, 0, 'g'},
 		{"output",	required_argument, 0, 'o'},
 		{"help",	no_argument,	   0, 'h'},
 		{0, 0, 0, 0}
@@ -270,7 +306,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:o:h", long_options, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:g:o:h", long_options, NULL)) != -1) {
 		int len;
 
 		switch (opt) {
@@ -344,6 +380,22 @@ int main(int argc, char *argv[])
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


