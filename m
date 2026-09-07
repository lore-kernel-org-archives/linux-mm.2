Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEEBC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B146B00B3; Mon,  7 Sep 2026 04:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BEE6B00B4; Mon,  7 Sep 2026 04:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731476B00B5; Mon,  7 Sep 2026 04:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51B5D6B00B3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D56361206EC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:55 +0000 (UTC)
X-FDA: 85186285590.06.BB581F5
Received: from mail-m82130.xmail.ntesmail.com (mail-m82130.xmail.ntesmail.com [156.224.82.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E2C114000D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769614;
	b=R4bVu4TBuBYYLyNTEC8en7/u2av6w3XTzcFkAA9L8GDm/yMYVLeW70iytgk6WnjZc9jWQH
	Am8x+vZEhfYgThw/u85gYLc53MHe3MaM/0tnRRXv3x07pNaQtZETOmo3KJa5f9pODRHHBW
	sZT8kLytPaDb2KhrLQ15y8c7Ijxg8Fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cIXApTwnHFO1+n7FdV7lkUohyjD7s10qpNVaQ1bykcQ=;
	b=jsp7mcY8TyqwBzmqy836SjGN37GcYzLngrAMHfHaUQKvRw328kPHyptGN2q7ae8iRGoFkC
	5kLPeBRjkvpe1bGcleBKTJvPtKdElyL4/dWWKsMsvbi/RefdaHZmCMUuLcHO0x1Rw099k7
	BYGUB98pX6/dGy1EXrGuvoHUhq/c2ZA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa0a3;
	Mon, 7 Sep 2026 16:26:49 +0800 (GMT+08:00)
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
Subject: [PATCH v3 7/8] tools/mm: Add memory cgroup filtering support to page_owner_filter
Date: Mon,  7 Sep 2026 16:26:19 +0800
Message-Id: <20260907082620.2083838-8-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa263d0229kunm225d16da162d22
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaS05CVh4fThkeT0IZSUNCTFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E2C114000D
X-Stat-Signature: hhaz1dqm3f4jxeb63nezik1cnabsj6k9
X-HE-Tag: 1788769613-957498
X-HE-Meta: U2FsdGVkX19SbUfq/JOmO98BZctc4/eBVlUIOsCYXw6TPll95x3GVf+VRxX4GzxMxLGaPktsH5nbJIID/S+tQsdd1COFdxWKh7agcxeahIvoKmexqyYhM9qHUYpbO7lziUBKsOyjVogLVKV5//NXHEU2Iwb/H7ZFhABpAdcceeoHFJia3sL4d6RdhTOLiMmf9PdQ8njct1fCsR11XGQONPZhjWcQj1H0lgH9ZfLWswGy5Mn1qcqQg16oFNdNUVV0ue9q4h/A9ibEFjMJYRXjca0+6qdK9cbWCVooajerJ24SGH66pxVgezB+D7OYlTphNfRxc3/ALF9NhkOFZBdvh9qsr3PVWw6kQXGfqyHSoQky16tyGgzAiHIOYd/B9AOeBTCtK09/Z8+OiyKLKa04RR8efLnjQsyJ9pBLG9q880nopVAdyEWwbah97PC0JPfg9tA6l0AIIAreijj7ihlEKc4SQFcn/w/17tcE5IEYZDHSCO0cQbxkpTKI2H2SJhd0aCBCWU4ont42R7kssnaOkViQGtu/Sy33XdZ7v9lWNNbXEPcJzY1uVTPoqy/0VIVyuGMFlVr+lm4PIA8b6lOz0N2R9mdiRSxmHTXhR2HMnvmT4y3xDskH/3Neu02FdK7VO/scdSa9/AXBpESbEoU44ehC25tZNx+GK3zQNlxXj6z2BKB9Slc6Akkw8q2rwux4ROglOGCfP0LIjPRP2aepbpnHxdaFUJqaET/T9c6RJNPkrcqp9HdSVVwabqrB2oCR4l0uQclr3bAN2kB1o+tf4Nhr43zAlBU+JUGkWXzc/RSJ9jR608DXr3s+KJEH7+GcuKVV3AapjDXLbN+DsmLw8PpaM0SggCvIq2sgu0WsjzCJNhVNfaSktJJezum5QXiGNsYzT4y055Kk6iQxGe6u3hn+RAxwFsvCQa0IHyXScYERIhrVK7HXUeGlKlbI71FIPelmA4yGA4imbTTWTe+
 Yltz4G39
 kvEn2qIzfXUcwfI0ZwrIRoRdMYd2j7BM/J74yzAdUm/9Uiae+anv1qR4V3SC789+fSnG+0QQyNwI76oZTPUgNrXaxWB03r4QqvetTXm1VDz99nPomw8TU0qf2qHwivQ8MG2QvYqtolWNtKD2NZovVvKivqMmI4vj/FrT4kXX0Xu8VD0mcfG84e2i1fS2s7ifqB+lrzW+ywItQat4=
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
Changes in v3:
- Replace the v1/v2 classification.

Changes in v2:
- Print an error message for an empty -g argument.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-8-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-8-zhen.ni@easystack.cn/
---
 tools/mm/page_owner_filter.c | 52 +++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
index 516c2d109a6a..ede39a1704de 100644
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
@@ -225,6 +226,34 @@ static int validate_comm_list(const char *comm_list)
 	return 0;
 }
 
+static int validate_cgroup_path(const char *path)
+{
+	char cgroup_path[512];
+	const char *input_path = path;
+
+	if (!path || strlen(path) == 0) {
+		fprintf(stderr, "Error: Empty cgroup path\n");
+		return -1;
+	}
+
+	if (path[0] == '/')
+		input_path++;
+
+	snprintf(cgroup_path, sizeof(cgroup_path),
+		"/sys/fs/cgroup/%s/memory.stat", input_path);
+	if (access(cgroup_path, F_OK) == 0)
+		return 0;
+
+	snprintf(cgroup_path, sizeof(cgroup_path),
+		"/sys/fs/cgroup/memory/%s/memory.stat", input_path);
+	if (access(cgroup_path, F_OK) == 0)
+		return 0;
+
+	fprintf(stderr, "Error: Cgroup path '%s': "
+		"not found or no memory controller\n", path);
+	return -1;
+}
+
 int main(int argc, char *argv[])
 {
 	const char *output_file = NULL;
@@ -244,6 +273,7 @@ int main(int argc, char *argv[])
 		{"pid",		required_argument, 0, 'p'},
 		{"tgid",	required_argument, 0, 't'},
 		{"comm",	required_argument, 0, 'c'},
+		{"cgroup",	required_argument, 0, 'g'},
 		{"output",	required_argument, 0, 'o'},
 		{"help",	no_argument,	   0, 'h'},
 		{0, 0, 0, 0}
@@ -270,7 +300,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:o:h", long_options, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "m:n:p:t:c:g:o:h", long_options, NULL)) != -1) {
 		int len;
 
 		switch (opt) {
@@ -344,6 +374,22 @@ int main(int argc, char *argv[])
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


