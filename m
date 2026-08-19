Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33587C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F63E6B0093; Tue, 18 Aug 2026 22:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEAD6B0095; Tue, 18 Aug 2026 22:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4976B0096; Tue, 18 Aug 2026 22:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF9AA6B0093
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:16:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79BD61A03D3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:28 +0000 (UTC)
X-FDA: 85116404856.17.B580570
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8EDF8A0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vk0cPz9L;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105786;
	b=DpCjgPWxjxtmhDqfpOQBa7dqRlCAErj/6150bgckvStBAwVcCNvZW8hbkKteHdammX1ruM
	VQl2kGFQZPRDNRMguBmzSc9TiFbzXbwd2O/Izk5oDsH31SsZv54xHcL92v/iR3WZwi5Sc8
	Dlmy6C0B/YX4+cCQ2hKRHjteE3d6ky0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vk0cPz9L;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+TPKF0uT0/YiKzIDSldEtxTUcyCmHTPH9ZfzWh/uTw=;
	b=HwUGPaUfu/JL4tIPKunWWqu2EAAu3wtuTRcxHqNrOIykzWWw2+jM2HbHeOA8ErM+3qmwBI
	1B4UDWYxlQR5a5FWTSZhHi+hqKkomnfB7y50avikr2STdsIjWceqiHNu0R7A3nBdnZShu5
	6gSUw9hIm15HPqxM1Fr+U4pFyxD5gRY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RZyED8qsQHeaTSRsSMoV3uSW0cbtMADvVzLfTmphjzc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105785; v=1; x=1787710585;
 b=vk0cPz9LQ4Gt4HESfkk+XswIUduul1n/pgQbdxk3kxzAZ4Rybs0A5CsC6vD2SH6cw8yoCbfE
 Pmmqmgnmuu2HXtAEpvDQevMJiHzzvLKyrvN3prgwV/qepgul1lYq0zmdTWhpIyWW9IddaD5kblk
 J58dCMRRBMiJI0Km8RMAK9P0=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 3fdb967ffecafa8f;
	Wed, 19 Aug 2026 02:16:25 +0000
X-Migadu-Flow: FLOW_OUT
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
Subject: [PATCH v3 2/3] tools/mm/page_owner_sort: add module name sort/cull/filter support
Date: Wed, 19 Aug 2026 10:16:10 +0800
Message-Id: <20260819021611.2910835-3-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819021611.2910835-1-ye.liu@linux.dev>
References: <20260819021611.2910835-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EDF8A0004
X-Rspam-User: 
X-Stat-Signature: cj1sidhfs3ku1f3wyz7kmj5y1oboufdp
X-Rspamd-Server: rspam06
X-HE-Tag: 1787105786-902542
X-HE-Meta: U2FsdGVkX18Hj4ZErF0IW4vPjRXx1qBfH9sQLGSwyoYJ4QW3C0ufS96F7Vi9Vndunj8Yhxzra41AE8PVt0nxkEHgYw2eQtbTA8pRwAtsLRXgO3A0vkVNTDNJ43Oi+6Yj6EatN2zh7uhRVQo0WaA3/dhhdxigQZQWOCgC6lWCBXxnZV8k+JTQOmF5KH/a3eajlqMBtANUmC2GiNtnudZSuFsuzYYeCN80Yj30JEinP2mw9BztSHzxTKBvauRPu/lyTYj2G1nfoohVqB0HydTlEe3fsRD/k5t3zDAHNlfC13XAbLwkjicCG1dpCBkkHAC8IENHRSxGpd77mQYSkAvmeMb82oz5D5yVuvjIOkiQpFvhC7qNeBQxvEE6TAsDQE8YG/6w8Y1iC/Wl7RDlmRGAwD2h4N5BE6FbcA5Kq5pym1tM2v/6W3j0rxtSlQyKsRamReJGJvaQtZW9B8JIdeU//fDo2suqsRwZ65FN7ShBVkQMKwE2F+plF6qEqTCXQYRBUJfnZD7GHsW3W81VzE+3CEkmpMz9YWmg/3Zv1+3a47mN0OKjDMaH76TVw7U5Do1hNApdSTpEBGKB61sHgdLthxZTQ90sg/c0QQZgSrbqaQOeDfDWQn6zg8lGOYMPYIpsS+NjxMm5fBJiE3yVY2zhzP6p9tfCkSOhUqzETTt+sYFdKKMROixVhwJHwAXF0RjbVSFl4nk7GQKkvqg1LbMiRCc3lKNS86hiCDsTzaE4J5eEXR5g0aDgsSxpZ1GxyzoDv4quXlkz9xFufgDcHZs9P2zgifCiKRS87m4u6ptvpRFM3GwyUP9YbajgZrqoY8XqhOaMvOJ2PAufMLkIvVVXfH+lOsB54qHmjPCc0gVP5EsAaL/0S8skKHcNBAI1Fhb44nemYIJ8yyGDKa1uDHr37W3oW7HOY5zJgI5huiSUSvp4YK643YuKnll4DmzYiAnPJQkb55bCgMLSIljSG6d
 RQZZWnkK
 lbjFvqWFGrAZrTlrsnp8z9hnM8nrM1zCUmTkIHeEzjpbwMREZoFngD216DFVjzpnfM1Uy7ePzsc+Q45jvbq2aeuvFHvd/NjRiBoLoTrS2GA4BiVGlEZd6lpqn7+r54JQwqZSMXltW6gCXyisUwI8OshP9uma1Imlx0PP+CTIUBNgGXAN6jNHsnT4xKCoGYQcx0801M8M5oG49bkMT0RXxN+qv1q7aWPE9H1qTK8IvPtaJ0fzG7Se5VZzjd5dd/nv8GXs4NMPXdTo8uSIwDha0wI2alt8S55Us0dNXC/SqTOXlL4w=
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
 tools/mm/page_owner_sort.c      | 122 +++++++++++++++++++++++++++-----
 2 files changed, 110 insertions(+), 20 deletions(-)

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
index 3b957b654f00..10a814ba5301 100644
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
@@ -411,9 +429,33 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static char *get_module(char *buf)
+{
+	char *module_str = malloc(MODULE_NAME_LEN);
+	regmatch_t pmatch[2];
+	int val_len;
+
+	if (!module_str)
+		return NULL;
+	memset(module_str, 0, MODULE_NAME_LEN);
+	if (regexec(&module_pattern, buf, 2, pmatch, REG_NOTBOL) != 0 || pmatch[1].rm_so == -1) {
+		strcpy(module_str, "vmlinux");
+		return module_str;
+	}
+
+	val_len = pmatch[1].rm_eo - pmatch[1].rm_so;
+	if ((size_t)val_len >= MODULE_NAME_LEN)
+		val_len = MODULE_NAME_LEN - 1;
+	memcpy(module_str, buf + pmatch[1].rm_so, val_len);
+	module_str[val_len] = '\0';
+
+	return module_str;
+}
+
 static void free_block_list(struct block_list *block)
 {
 	free(block->comm);
+	free(block->module);
 	free(block->txt);
 }
 
@@ -433,6 +475,8 @@ static int get_arg_type(const char *arg)
 		return ARG_ALLOC_TS;
 	else if (!strcmp(arg, "allocator") || !strcmp(arg, "ator"))
 		return ARG_ALLOCATOR;
+	else if (!strcmp(arg, "module") || !strcmp(arg, "mod"))
+		return ARG_MODULE;
 	else {
 		return ARG_UNKNOWN;
 	}
@@ -483,25 +527,36 @@ static bool match_str_list(const char *str, char **list, int list_size)
 
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
 
@@ -547,6 +602,12 @@ static bool add_list(char *buf, int len, char *ext_buf)
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
@@ -573,6 +634,8 @@ static bool parse_cull_args(const char *arg_str)
 			cull |= CULL_STACKTRACE;
 		else if (arg_type == ARG_ALLOCATOR)
 			cull |= CULL_ALLOCATOR;
+		else if (arg_type == ARG_MODULE)
+			cull |= CULL_MODULE;
 		else {
 			free_explode(args, size);
 			return false;
@@ -635,6 +698,8 @@ static bool parse_sort_args(const char *arg_str)
 			sc.cmps[i] = compare_txt;
 		else if (arg_type == ARG_ALLOCATOR)
 			sc.cmps[i] = compare_allocator;
+		else if (arg_type == ARG_MODULE)
+			sc.cmps[i] = compare_module;
 		else {
 			free_explode(args, size);
 			sc.size = 0;
@@ -691,7 +756,8 @@ static void usage(void)
 		"-p\t\t\tSort by pid.\n"
 		"-P\t\t\tSort by tgid.\n"
 		"-s\t\t\tSort by the stacktrace.\n"
-		"-t\t\t\tSort by number of times record is seen (default).\n\n"
+		"-t\t\t\tSort by number of times record is seen (default).\n"
+		"-M\t\t\tSort by module name.\n\n"
 		"--pid <pidlist>\t\tSelect by pid. This selects the information"
 		" of\n\t\t\tblocks whose process ID numbers appear in <pidlist>.\n"
 		"--tgid <tgidlist>\tSelect by tgid. This selects the information"
@@ -700,10 +766,11 @@ static void usage(void)
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
@@ -721,13 +788,14 @@ int main(int argc, char **argv)
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
@@ -753,6 +821,9 @@ int main(int argc, char **argv)
 		case 'n':
 			compare_flag |= COMP_COMM;
 			break;
+		case 'M':
+			compare_flag |= COMP_MODULE;
+			break;
 		case 'h':
 			usage();
 			exit(0);
@@ -792,6 +863,10 @@ int main(int argc, char **argv)
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
@@ -833,6 +908,9 @@ int main(int argc, char **argv)
 	case COMP_COMM:
 		set_single_cmp(compare_comm, SORT_ASC);
 		break;
+	case COMP_MODULE:
+		set_single_cmp(compare_module, SORT_ASC);
+		break;
 	default:
 		usage();
 		exit(1);
@@ -856,6 +934,8 @@ int main(int argc, char **argv)
 		goto out_comm;
 	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns"))
 		goto out_ts;
+	if (!check_regcomp(&module_pattern, "\\+0x[0-9a-f]+/0x[0-9a-f]+\\s*\\[([a-zA-Z0-9_-]+)\\]"))
+		goto out_module;
 
 	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
@@ -914,6 +994,8 @@ int main(int argc, char **argv)
 				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
+			if (cull & CULL_MODULE || filter & FILTER_MODULE)
+				fprintf(fout, ", module: %s", list[i].module);
 			if (cull & CULL_ALLOCATOR) {
 				fprintf(fout, ", ");
 				print_allocator(fout, list[i].allocator);
@@ -934,6 +1016,8 @@ int main(int argc, char **argv)
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


