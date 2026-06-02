Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE7BCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33CE6B03F4; Tue,  2 Jun 2026 03:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9826B03F6; Tue,  2 Jun 2026 03:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9866B03F7; Tue,  2 Jun 2026 03:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFF86B03F4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:01:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26125162BDF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:30 +0000 (UTC)
X-FDA: 84834076740.25.BB60A0A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3CF5C0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:01:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780383688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fFWSxtWYXR1E9Kr2NlivDJw3wRKF9NEaUjUFj9JBvRs=;
	b=OiI49G67A7t+oufKrqUaw1yC8vGdRgzvqzDt7fkCVfP+g44StMfSXj4amqa7O4Kprc7fJ7
	gQpj4f78tPh340CdYgmI3FSUxFWtzq0CxNd8gV8Cu3g3r0FJdK8DR1wuEZoY1W40qddXsm
	76/2IctslXuhL+hwMmhoCD01Efz6HJY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780383688;
	b=gxrV9rr7U0agliGSSAo7b9r7PFD7GXuW8btU3W9ycrGGxf1Y8qM68ULWnlFvTOL8lrR8S1
	TguIUA075Ps6Cf8LRFAeF4Dhtqm9bq+Rvv6xc/+I6Xxu5AXu/6QodiczJ9KXTB45aLrumD
	Ftu60cGFEao5qp/bztI1UC+TRfFCwn4=
X-UUID: da4f904e5e5011f1aa26b74ffac11d73-20260602
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d5a4c8b9-6a30-4d72-b040-093531834cc6,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:d5a4c8b9-6a30-4d72-b040-093531834cc6,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:24db0df43dd10e4fb91783abea05d070,BulkI
	D:260602150118PWS8MVPW,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: da4f904e5e5011f1aa26b74ffac11d73-20260602
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 185888861; Tue, 02 Jun 2026 15:01:17 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v6 1/5] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Tue,  2 Jun 2026 15:01:15 +0800
Message-Id: <20260602070119.1452308-2-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260602070119.1452308-1-lihongfu@kylinos.cn>
References: <20260602070119.1452308-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3CF5C0005
X-Stat-Signature: m144mydxhf76nqjddf54o549ix4ndp71
X-Rspam-User: 
X-HE-Tag: 1780383683-859963
X-HE-Meta: U2FsdGVkX1+RUGeJ4I4kFsurzG1o54fnuDx7QbSq5srdKpSzvNijdDxS68mXAx1yXMlH5TulFpxy4bVaXXJdHUtZRyNt2+4E3QA/Lj8ZHLh43dcaaFxHhZ+LsXOyYVfDcy5JQeB/HqwwX+B3+rZloZikknXLlWuF8wvUviU9mva/lrJU9gludoUfTUFiGu2GMXOGAV7CBoPJfXVVxXQa7VN8KkG2aeHsmlgdQFqeqAOnkrbKkDhyZc12VWkaK6j4jrX+T2B+spggSgXQymFyjkeHn6vIeXprOnrToDq/fr2a28i/iv7vkcPNFffnxNHZlU5JkTIPvKBw8N7X+L+M8vnVJ+9xw41coKSH+ediO7kcNc6PlGmGxQoqKTFa85Q0jV50brWDmr8wA+xbY+DZgfFa2EF7pNSzmTH3al/EFd92OpsgXogfjlOAfu5HRCoE467ZOLDkz/i09XUF9r5hO2thThXjx2NBXt/0BAV8siP+/NOuRuU/y55qkk4MKGNuJGWVSI8HZCxojgGiziplPktravsqSINTT1ge82ib5ylSwHxisP7BKuU2RXnBgpHEIys9GBeLiOLdAWUpcha0GmBhNnCD/YF3vM09d3UcKBFu8nAOOKvVRQ1C98CvskLrvMqOlmrO8JSM9wOWUYV7SiZ+yd6HUbw3HqAyLykb2Of4PBKfdfxgtp+FJBWGZ+p20yFKC6RvUPMoOXGdOZueI2Ur5O2gs5p+5Gc5WaxGtwH7eYyFEVu9GBe63TkO9LglA9bznvWsS26dmq5/qYjNbjGNst1GdVvm6CrWL1fsrPu75GH+wJtnQ/eCIzUXBqYS9l2e8Fy5z7I0CrMRVZXRSlhKyNULmHO3yGWTRAaQamGt8YxHY26CkFxaShmIUhqE7scsDaAIhpgis3WErjic0zGK3EM28yWBhNZv0GdShVV1ce23CROq3T2oK2yknWzyIdCb1/wAKyEtngySavd
 Rnv4ZsQD
 ozOJnyNf9vPlFHT1OU0jiMKVUSzZanfXXgp6UUlgOTl+blthvnF3YnODMHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move pkey selftest debugging helpers into shared code so both pkey
selftests can use the same tracing and abort-hook logic.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pkey-helpers.h    |  4 +-
 tools/testing/selftests/mm/pkey_util.c       | 86 ++++++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c | 83 -------------------
 3 files changed, 89 insertions(+), 84 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 2c377f4e9df1..46a8a1878dc1 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -68,7 +68,9 @@ static inline void sigsafe_printf(const char *format, ...)
 #define dprintf3(args...) dprintf_level(3, args)
 #define dprintf4(args...) dprintf_level(4, args)
 
-extern void abort_hooks(void);
+void tracing_on(void);
+void tracing_off(void);
+void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
 		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
diff --git a/tools/testing/selftests/mm/pkey_util.c b/tools/testing/selftests/mm/pkey_util.c
index 255b332f7a08..abf708d6575e 100644
--- a/tools/testing/selftests/mm/pkey_util.c
+++ b/tools/testing/selftests/mm/pkey_util.c
@@ -2,9 +2,95 @@
 #define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "pkey-helpers.h"
 
+#if CONTROL_TRACING > 0
+static void cat_into_file(char *str, char *file)
+{
+	int fd = open(file, O_RDWR);
+	int ret;
+
+	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
+	/*
+	 * these need to be raw because they are called under
+	 * pkey_assert()
+	 */
+	if (fd < 0) {
+		fprintf(stderr, "error opening '%s'\n", str);
+		perror("error: ");
+		exit(__LINE__);
+	}
+
+	ret = write(fd, str, strlen(str));
+	if (ret != strlen(str)) {
+		perror("write to file failed");
+		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
+		exit(__LINE__);
+	}
+	close(fd);
+}
+
+static int warned_tracing;
+static int tracing_root_ok(void)
+{
+	if (geteuid() != 0) {
+		if (!warned_tracing)
+			fprintf(stderr, "WARNING: not run as root, "
+					"can not do tracing control\n");
+		warned_tracing = 1;
+		return 0;
+	}
+	return 1;
+}
+#endif
+
+void tracing_on(void)
+{
+#if CONTROL_TRACING > 0
+#define TRACEDIR "/sys/kernel/tracing"
+	char pidstr[32];
+
+	if (!tracing_root_ok())
+		return;
+
+	sprintf(pidstr, "%d", getpid());
+	cat_into_file("0", TRACEDIR "/tracing_on");
+	cat_into_file("\n", TRACEDIR "/trace");
+	if (1) {
+		cat_into_file("function_graph", TRACEDIR "/current_tracer");
+		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
+	} else {
+		cat_into_file("nop", TRACEDIR "/current_tracer");
+	}
+	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
+	cat_into_file("1", TRACEDIR "/tracing_on");
+	dprintf1("enabled tracing\n");
+#endif
+}
+
+void tracing_off(void)
+{
+#if CONTROL_TRACING > 0
+	if (!tracing_root_ok())
+		return;
+	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
+#endif
+}
+
+void abort_hooks(void)
+{
+	fflush(stdout);
+	fprintf(stderr, "running %s()...\n", __func__);
+	tracing_off();
+#ifdef SLEEP_ON_ABORT
+	sleep(SLEEP_ON_ABORT);
+#endif
+}
+
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
 {
 	int ret = syscall(SYS_pkey_alloc, flags, init_val);
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 9a6d954ee371..e504544e2197 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -62,89 +62,6 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
-#if CONTROL_TRACING > 0
-static void cat_into_file(char *str, char *file)
-{
-	int fd = open(file, O_RDWR);
-	int ret;
-
-	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
-	/*
-	 * these need to be raw because they are called under
-	 * pkey_assert()
-	 */
-	if (fd < 0) {
-		fprintf(stderr, "error opening '%s'\n", str);
-		perror("error: ");
-		exit(__LINE__);
-	}
-
-	ret = write(fd, str, strlen(str));
-	if (ret != strlen(str)) {
-		perror("write to file failed");
-		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
-		exit(__LINE__);
-	}
-	close(fd);
-}
-
-static int warned_tracing;
-static int tracing_root_ok(void)
-{
-	if (geteuid() != 0) {
-		if (!warned_tracing)
-			fprintf(stderr, "WARNING: not run as root, "
-					"can not do tracing control\n");
-		warned_tracing = 1;
-		return 0;
-	}
-	return 1;
-}
-#endif
-
-static void tracing_on(void)
-{
-#if CONTROL_TRACING > 0
-#define TRACEDIR "/sys/kernel/tracing"
-	char pidstr[32];
-
-	if (!tracing_root_ok())
-		return;
-
-	sprintf(pidstr, "%d", getpid());
-	cat_into_file("0", TRACEDIR "/tracing_on");
-	cat_into_file("\n", TRACEDIR "/trace");
-	if (1) {
-		cat_into_file("function_graph", TRACEDIR "/current_tracer");
-		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
-	} else {
-		cat_into_file("nop", TRACEDIR "/current_tracer");
-	}
-	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
-	cat_into_file("1", TRACEDIR "/tracing_on");
-	dprintf1("enabled tracing\n");
-#endif
-}
-
-static void tracing_off(void)
-{
-#if CONTROL_TRACING > 0
-	if (!tracing_root_ok())
-		return;
-	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
-#endif
-}
-
-void abort_hooks(void)
-{
-	fflush(stdout);
-	fprintf(stderr, "running %s()...\n", __func__);
-	tracing_off();
-#ifdef SLEEP_ON_ABORT
-	sleep(SLEEP_ON_ABORT);
-#endif
-}
-
 /*
  * This attempts to have roughly a page of instructions followed by a few
  * instructions that do a write, and another page of instructions.  That
-- 
2.25.1


