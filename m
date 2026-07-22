Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21CAC4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 02:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815B36B00BA; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E96E6B00BD; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689B56B00BE; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5796B00BA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:38:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AC97A0CF1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:15 +0000 (UTC)
X-FDA: 85014853350.11.59C95E1
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id D708820008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ca5fZ019;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784687893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbSjMB9d6L3kJjEZ8uUFrAMKcoIHCWwN/bDs4qAKnZE=;
	b=BeHh96dAi+EAVulzsnHi1JtLob77y2hDIaG7OQU8tDyPxqKmmO1m/18XIbL13foOBYaUST
	Synv8lMQPWa/nnHq77jFkMEi7uU+/duigDeKu1vSWni60CKzDrChSxQaLOvb1viu/O4mgJ
	8GA50/z6XZtWWJX7Dd46Kf/D/6s757Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ca5fZ019;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784687893;
	b=1K1y03ngQ9mNcRWL++56bHDPjRH4RvjKbp2Vww6QK3iCjWkmNjjRGUGrqldFABpoNzHRTa
	9raAG9vOMb1WGf5IKwcM+6/tYgqjgEqDs7SABuP2lO2k3bZmC5J/rATh0AqQlWI/11t40P
	3ViEyEGwP3Z7zfJIsjx86GSqoKBpGlo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784687888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RbSjMB9d6L3kJjEZ8uUFrAMKcoIHCWwN/bDs4qAKnZE=;
	b=Ca5fZ019OJbww4vS9WWOn292aHDC3oV82SPwWlcvce9bQrxdsw4bGBVx/R4MKtXhhgZA+T
	/m+PXvgjCtcOTMI94PB8QoDU4CHOdLfk5Lek1Z6VvbWf88h3epS9My4Vi6b652k0xAtiet
	109sacLNXyy4EycZoDhVZ+wl/h2EbEo=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tools/mm/page_owner_sort: add module name sort/cull/filter support
Date: Wed, 22 Jul 2026 10:37:25 +0800
Message-Id: <20260722023726.600200-3-ye.liu@linux.dev>
In-Reply-To: <20260722023726.600200-1-ye.liu@linux.dev>
References: <20260722023726.600200-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D708820008
X-Rspam-User: 
X-Stat-Signature: udhapy7ejku84uxfpu1ahx1y45bfpa3w
X-HE-Tag: 1784687891-741367
X-HE-Meta: U2FsdGVkX18c/RqK1FkCmnPdggEit44ZVaJxOg49T2c5s2jaFDgDtiZ7ScUB4v7l+VVc4HfFI2pMrBroZn8cKOla5OVUNDdpG6pq9D7FTu6DrPTOyXcs8UNVEm738GmR7V8xB+ziX2MuqicTL2mjbQObwP30XljUS8gOPCR6cXNtlRM+tksiUOaTnQnWpTwDoAMk+HJmuKi6aQUixcey9vNFF5EPEIYbEp9/ll9q1F/8BMm4cf0EdpxvjB3F5TL04eNr3O5S26zXvSzTfM3m8WlIQg0sDlzgKR474AD2cOCIlW2vAQ1NQ/wN+r+NBHKLsD4Qcy7mxFvOqrmRDkdN3ve23kc2t7DH5L0Wk+MFVIeMfzXfCO7pabXsXmLge8qaKDsTqGtpS29XN+1EwS7uI6gD1YPI31OS0rPxHHbdzFlyiiK4nhTT/KTdC5nLHhGhjYl/nJKvsiGfswbToRH4U8qgJ7CF2x+j+O2Z0ivGRIRa9YLQLgse+bUnIdghWSwk3f/WmJQT7AzZg1hTyUo6mvm4gI7bmn3U+Fi61aZvDd/Ykg0zRq4lqCAs4uZeXkDjZsQ6OgXeWmaGseZ98bYYx9FR42I6PoFdOr48LTtqBMUHNm83+2PGSPR9o5HWjENTXo+6TIpvrY+YeMxBg90I7zvsSjHdkpNCNo0/ajRZ04GrH9TeBiCBsQYum9xO1qguR/Fe7eCnCNJjoesCYy5YY66rIrAtGt+i+ijaIBMwfzVB2N//jon/KlfA6lxjoJhfUJKAlOGC4q3ulBxSJEWAUFcHoMVVQhC9Wu26Dl0rtEh7b1GNr19DYcgZ/dHnslzxf/P6TWoTLovTKptTDg38FulvN+QMMoCwj5vX1HD9ibrHx6Fkz83MbOA6g57Ycyy04d9zL1DCLYK9dZw4Ll6dv9DRTRiykmAQ7hoh87ipRs+r7rQE/F9bEKvS/cg3IaLVV7z2FTX3mYnJg/ne22R
 zBjy27Uh
 W/0zb16CPEPyun0MUgqtgC91XOJtUZi59nuLWLgYWDiEtAwAdIby5MuKiTb49hFCvTZ2gA55d9jlSCtDFXoDMc67cywiirwLlp2nQA/EqjEEGI0ZH4XKPbrPnBERzZ7z3Ce19B57SaeXjsj6OZvSbn/bVsEUCx0JVpy+PtxvjjJiLVQk7MTi3AHXW2eR8FZxrK6e7MLpFx1sCMcaqG3jlpVecsVEos+NTW4rir7lMXSGeTpx1tRVyHJOuJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Page owner stack traces already contain kernel module names in the
"[module]" format produced by %pS, but page_owner_sort has no way to
sort, cull, or filter by module.

Extract the first module name from each record's stack trace using the
regex \[([a-zA-Z0-9_]+)\].  Records whose stack traces contain no module
frames are assigned "vmlinux".

New options:
  -M                  Sort by module name
  --sort=mod          Sort by module name (supports +/- prefix)
  --cull=mod          Cull (aggregate) by module name
  --module <modlist>  Filter to records matching the given module(s)

The module field is also printed in cull output when relevant.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 Documentation/mm/page_owner.rst |   8 ++-
 tools/mm/page_owner_sort.c      | 112 ++++++++++++++++++++++++++------
 2 files changed, 100 insertions(+), 20 deletions(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index a6bd3fe6423a..bd027377dff6 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -199,6 +199,7 @@ Usage
 		-p		Sort by pid.
 		-P		Sort by tgid.
 		-n		Sort by task command name.
+		-M		Sort by module name.
 		-r		Sort by memory release time.
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
@@ -240,8 +241,10 @@ Usage
 					group ID numbers appear in <tgidlist>.
 		--name <cmdlist>	Select by task command name. This selects the blocks whose
 					task command name appear in <cmdlist>.
+		--module <modlist>	Select by module name. This selects the blocks whose
+					module name appear in <modlist>.
 
-		<pidlist>, <tgidlist>, <cmdlist> are single arguments in the form of a comma-separated list,
+		<pidlist>, <tgidlist>, <cmdlist>, <modlist> are single arguments in the form of a comma-separated list,
 		which offers a way to specify individual selecting rules.
 
 
@@ -249,6 +252,7 @@ Usage
 				./page_owner_sort <input> <output> --pid=1
 				./page_owner_sort <input> <output> --tgid=1,2,3
 				./page_owner_sort <input> <output> --name name1,name2
+				./page_owner_sort <input> <output> --module xfs,ext4
 
 STANDARD FORMAT SPECIFIERS
 ==========================
@@ -265,6 +269,7 @@ STANDARD FORMAT SPECIFIERS
 	ft		free_ts		timestamp of the page when it was released
 	at		alloc_ts	timestamp of the page when it was allocated
 	ator		allocator	memory allocator for pages
+	mod		module		kernel module name
 
   For --cull option:
 
@@ -275,6 +280,7 @@ STANDARD FORMAT SPECIFIERS
 	f		free		whether the page has been released or not
 	st		stacktrace	stack trace of the page allocation
 	ator		allocator	memory allocator for pages
+	mod		module		kernel module name
 
 Filtering page_owner output
 ============================
diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 3c86c8d0618c..22e1761468d4 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -25,11 +25,13 @@
 #include <getopt.h>
 
 #define TASK_COMM_LEN 16
+#define MODULE_NAME_LEN 64
 
 struct block_list {
 	char *txt;
 	char *comm; // task command name
 	char *stacktrace;
+	char *module; // kernel module name
 	__u64 ts_nsec;
 	int len;
 	int num;
@@ -41,7 +43,8 @@ struct block_list {
 enum FILTER_BIT {
 	FILTER_PID = 1<<1,
 	FILTER_TGID = 1<<2,
-	FILTER_COMM = 1<<3
+	FILTER_COMM = 1<<3,
+	FILTER_MODULE = 1<<4
 };
 
 enum FILTER_RESULT {
@@ -55,7 +58,8 @@ enum CULL_BIT {
 	CULL_TGID = 1<<2,
 	CULL_COMM = 1<<3,
 	CULL_STACKTRACE = 1<<4,
-	CULL_ALLOCATOR = 1<<5
+	CULL_ALLOCATOR = 1<<5,
+	CULL_MODULE = 1<<6
 };
 enum ALLOCATOR_BIT {
 	ALLOCATOR_CMA = 1<<1,
@@ -65,7 +69,8 @@ enum ALLOCATOR_BIT {
 };
 enum ARG_TYPE {
 	ARG_TXT, ARG_COMM, ARG_STACKTRACE, ARG_ALLOC_TS, ARG_CULL_TIME,
-	ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_ALLOCATOR
+	ARG_PAGE_NUM, ARG_PID, ARG_TGID, ARG_UNKNOWN, ARG_ALLOCATOR,
+	ARG_MODULE
 };
 enum SORT_ORDER {
 	SORT_ASC = 1,
@@ -79,15 +84,18 @@ enum COMP_FLAG {
 	COMP_STACK = 1<<3,
 	COMP_NUM = 1<<4,
 	COMP_TGID = 1<<5,
-	COMP_COMM = 1<<6
+	COMP_COMM = 1<<6,
+	COMP_MODULE = 1<<7
 };
 struct filter_condition {
 	pid_t *pids;
 	pid_t *tgids;
 	char **comms;
+	char **modules;
 	int pids_size;
 	int tgids_size;
 	int comms_size;
+	int modules_size;
 };
 struct sort_condition {
 	int (**cmps)(const void *, const void *);
@@ -101,6 +109,7 @@ static regex_t pid_pattern;
 static regex_t tgid_pattern;
 static regex_t comm_pattern;
 static regex_t ts_nsec_pattern;
+static regex_t module_pattern;
 static struct block_list *list;
 static int list_size;
 static int max_size;
@@ -184,6 +193,13 @@ static int compare_comm(const void *p1, const void *p2)
 	return strcmp(l1->comm, l2->comm);
 }
 
+static int compare_module(const void *p1, const void *p2)
+{
+	const struct block_list *l1 = p1, *l2 = p2;
+
+	return strcmp(l1->module, l2->module);
+}
+
 static int compare_ts(const void *p1, const void *p2)
 {
 	const struct block_list *l1 = p1, *l2 = p2;
@@ -207,6 +223,8 @@ static int compare_cull_condition(const void *p1, const void *p2)
 		return compare_tgid(p1, p2);
 	if ((cull & CULL_COMM) && compare_comm(p1, p2))
 		return compare_comm(p1, p2);
+	if ((cull & CULL_MODULE) && compare_module(p1, p2))
+		return compare_module(p1, p2);
 	if ((cull & CULL_ALLOCATOR) && compare_allocator(p1, p2))
 		return compare_allocator(p1, p2);
 	return 0;
@@ -411,9 +429,23 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static char *get_module(char *buf)
+{
+	char *module_str = malloc(MODULE_NAME_LEN);
+
+	if (!module_str)
+		return NULL;
+	memset(module_str, 0, MODULE_NAME_LEN);
+	if (search_pattern(&module_pattern, module_str,
+			   MODULE_NAME_LEN, buf) < 0)
+		strcpy(module_str, "vmlinux");
+	return module_str;
+}
+
 static void free_block_list(struct block_list *block)
 {
 	free(block->comm);
+	free(block->module);
 	free(block->txt);
 }
 
@@ -433,6 +465,8 @@ static int get_arg_type(const char *arg)
 		return ARG_ALLOC_TS;
 	else if (!strcmp(arg, "allocator") || !strcmp(arg, "ator"))
 		return ARG_ALLOCATOR;
+	else if (!strcmp(arg, "module") || !strcmp(arg, "mod"))
+		return ARG_MODULE;
 	else {
 		return ARG_UNKNOWN;
 	}
@@ -483,25 +517,36 @@ static bool match_str_list(const char *str, char **list, int list_size)
 
 static enum FILTER_RESULT filter_record(char *buf)
 {
-	char *comm;
+	char *comm, *module;
 
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
 		return FILTER_SKIP;
 	if ((filter & FILTER_TGID) &&
 		!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
 		return FILTER_SKIP;
-	if (!(filter & FILTER_COMM))
+	if (!(filter & (FILTER_COMM | FILTER_MODULE)))
 		return FILTER_MATCH;
 
-	comm = get_comm(buf);
-	if (!comm)
-		return FILTER_ERROR;
-
-	if (!match_str_list(comm, fc.comms, fc.comms_size)) {
+	if (filter & FILTER_COMM) {
+		comm = get_comm(buf);
+		if (!comm)
+			return FILTER_ERROR;
+		if (!match_str_list(comm, fc.comms, fc.comms_size)) {
+			free(comm);
+			return FILTER_SKIP;
+		}
 		free(comm);
-		return FILTER_SKIP;
 	}
-	free(comm);
+	if (filter & FILTER_MODULE) {
+		module = get_module(buf);
+		if (!module)
+			return FILTER_ERROR;
+		if (!match_str_list(module, fc.modules, fc.modules_size)) {
+			free(module);
+			return FILTER_SKIP;
+		}
+		free(module);
+	}
 	return FILTER_MATCH;
 }
 
@@ -547,6 +592,12 @@ static bool add_list(char *buf, int len, char *ext_buf)
 		list[list_size].stacktrace++;
 	list[list_size].ts_nsec = get_ts_nsec(buf);
 	list[list_size].allocator = get_allocator(buf, ext_buf);
+	list[list_size].module = get_module(buf);
+	if (!list[list_size].module) {
+		fprintf(stderr, "Out of memory\n");
+		free_block_list(&list[list_size]);
+		return false;
+	}
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
@@ -573,6 +624,8 @@ static bool parse_cull_args(const char *arg_str)
 			cull |= CULL_STACKTRACE;
 		else if (arg_type == ARG_ALLOCATOR)
 			cull |= CULL_ALLOCATOR;
+		else if (arg_type == ARG_MODULE)
+			cull |= CULL_MODULE;
 		else {
 			free_explode(args, size);
 			return false;
@@ -635,6 +688,8 @@ static bool parse_sort_args(const char *arg_str)
 			sc.cmps[i] = compare_txt;
 		else if (arg_type == ARG_ALLOCATOR)
 			sc.cmps[i] = compare_allocator;
+		else if (arg_type == ARG_MODULE)
+			sc.cmps[i] = compare_module;
 		else {
 			free_explode(args, size);
 			sc.size = 0;
@@ -691,7 +746,8 @@ static void usage(void)
 		"-p\t\t\tSort by pid.\n"
 		"-P\t\t\tSort by tgid.\n"
 		"-s\t\t\tSort by the stacktrace.\n"
-		"-t\t\t\tSort by number of times record is seen (default).\n\n"
+		"-t\t\t\tSort by number of times record is seen (default).\n"
+		"-M\t\t\tSort by module name.\n\n"
 		"--pid <pidlist>\t\tSelect by pid. This selects the information"
 		" of\n\t\t\tblocks whose process ID numbers appear in <pidlist>.\n"
 		"--tgid <tgidlist>\tSelect by tgid. This selects the information"
@@ -700,10 +756,11 @@ static void usage(void)
 		"--name <cmdlist>\tSelect by command name. This selects the"
 		" information\n\t\t\tof blocks whose command name appears in"
 		" <cmdlist>.\n"
-		"--cull <rules>\t\tCull by user-defined rules. <rules> is a "
-		"single\n\t\t\targument in the form of a comma-separated list "
-		"with some\n\t\t\tcommon fields predefined (pid, tgid, comm, "
-		"stacktrace, allocator)\n"
+		"--module <modlist>\tSelect by module name. This selects the information\n"
+		"\t\t\tof blocks whose module name appears in <modlist>.\n"
+		"--cull <rules>\t\tCull by user-defined rules. <rules> is a single\n"
+		"\t\t\targument in the form of a comma-separated list with some\n"
+		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
 	);
 }
@@ -721,13 +778,14 @@ int main(int argc, char **argv)
 		{ "name", required_argument, NULL, 3 },
 		{ "cull", required_argument, NULL, 4 },
 		{ "sort", required_argument, NULL, 5 },
+		{ "module", required_argument, NULL, 6 },
 		{ "help", no_argument, NULL, 'h' },
 		{ 0, 0, 0, 0},
 	};
 
 	compare_flag = COMP_NO_FLAG;
 
-	while ((opt = getopt_long(argc, argv, "admnpstPh", longopts, NULL)) != -1)
+	while ((opt = getopt_long(argc, argv, "admnpstPMh", longopts, NULL)) != -1)
 		switch (opt) {
 		case 'a':
 			compare_flag |= COMP_ALLOC;
@@ -753,6 +811,9 @@ int main(int argc, char **argv)
 		case 'n':
 			compare_flag |= COMP_COMM;
 			break;
+		case 'M':
+			compare_flag |= COMP_MODULE;
+			break;
 		case 'h':
 			usage();
 			exit(0);
@@ -792,6 +853,10 @@ int main(int argc, char **argv)
 				exit(1);
 			}
 			break;
+		case 6:
+			filter = filter | FILTER_MODULE;
+			fc.modules = explode(',', optarg, &fc.modules_size);
+			break;
 		default:
 			usage();
 			exit(1);
@@ -834,6 +899,9 @@ int main(int argc, char **argv)
 	case COMP_COMM:
 		set_single_cmp(compare_comm, SORT_ASC);
 		break;
+	case COMP_MODULE:
+		set_single_cmp(compare_module, SORT_ASC);
+		break;
 	default:
 		usage();
 		exit(1);
@@ -857,6 +925,8 @@ int main(int argc, char **argv)
 		goto out_comm;
 	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns"))
 		goto out_ts;
+	if (!check_regcomp(&module_pattern, "\\[([a-zA-Z0-9_]+)\\]"))
+		goto out_module;
 
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
@@ -915,6 +985,8 @@ int main(int argc, char **argv)
 				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
+			if (cull & CULL_MODULE || filter & FILTER_MODULE)
+				fprintf(fout, ", module: %s", list[i].module);
 			if (cull & CULL_ALLOCATOR) {
 				fprintf(fout, ", ");
 				print_allocator(fout, list[i].allocator);
@@ -935,6 +1007,8 @@ int main(int argc, char **argv)
 			free_block_list(&list[i]);
 		free(list);
 	}
+out_module:
+	regfree(&module_pattern);
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
-- 
2.25.1


