Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629C8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B273A6B027F; Mon,  1 Jun 2026 02:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFA46B0282; Mon,  1 Jun 2026 02:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922F56B0280; Mon,  1 Jun 2026 02:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 787E86B027D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:20:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AE01C1EFB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:33 +0000 (UTC)
X-FDA: 84830344746.09.F6D52B2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F32A4000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:20:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294831; a=rsa-sha256;
	cv=none;
	b=N0Y2ffiFZAqxazfYW9p0QbTlvAmIwazAgFwJGB5ZTg9CXkat9wQhEkV8IkzoHfV4rOMGMc
	3onnTytlmYb2E7SVP0fZGq1YqG//VJhQ8CBgp2t55CzY7L6ayJ5MR9N7cVuCGd4AKpR/jS
	q36mMy6ZS/vgrFiw9Z3LkbQYvSf6YFc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtF6MFG4WawdFDhKVvwXIQnILy0gSepHm1wfHUmrvoA=;
	b=ullkND0FQDe+1Hatkzj0cIrp01MSCPGiJqnZf7VPk3yUqwyrdnMshFrZ+tefUO9tOEm9VO
	ggSfNcv320CkNRA/4yjwSaNNjaEbbSSPcoZ9D8t0zBxMHeHmUT12rE6pj0sAJlcoGiUgFa
	2ELNRUvlIsApWI/+JXFwZkXq8TjyaPY=
X-UUID: f736b9145d8111f1aa26b74ffac11d73-20260601
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e133df0b-ba28-4f8f-9909-bbd779363c9e,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:e133df0b-ba28-4f8f-9909-bbd779363c9e,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:a7a41673f932672f957e96d7bd7b50d5,BulkI
	D:260601142021N1AJ17V5,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f736b9145d8111f1aa26b74ffac11d73-20260601
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 66077499; Mon, 01 Jun 2026 14:20:20 +0800
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
Subject: [PATCH v5 1/4] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Mon,  1 Jun 2026 14:19:50 +0800
Message-Id: <20260601061953.696844-2-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260601061953.696844-1-lihongfu@kylinos.cn>
References: <20260601061953.696844-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F32A4000E
X-Stat-Signature: j7qarodguzaicammjbjkyaf99okc1q1n
X-HE-Tag: 1780294830-13474
X-HE-Meta: U2FsdGVkX184M+XmiMUdjgP/gFLIAme/rkyEK0jWVrUR8Jq0wXBo0eZdeFtKF+IPQfRnIdD/+q/mkDi1nNCmxDoYklOgKfqhLBuwBCyBjm/5ckfqTveLrOa8UL+8wLrfKSOYe9tZZjaZyICLyfAOGkOlXrmN1HmS+RHRqBcFW9Kr0qw4U4IXrf2shAdddcPgYvyf3OiJG6Vx2bxO6P6uMQyJEEV/IIw4mBCdUlJKBiTHXdr6JbeB9e2lq6/jCRaXDRNAi+JWq+WQrFdCv2f54ndIKbqNp5uZa7Tum08C55dRydbIGjHoYXGGfO3E+q8o7yOa2dll+peii74fUTzlCKtj9HY6ZddjCVBknRQspsUPOOr63nreRLW1Xhtqti+didmp3Hs7JqHWKcyUXg3y1elobxXw32wTxF88DVGNdQQXJJ6bRi/+3uVY5IMQeCk8FwLa4CiAambie7719inLNsz9y68zEtQGjK1kVhSt/CZGUnZ04UmeQcDZcgF0eKpOYwr2JhLP3QytIeSIL4QMWtG6iS+KQ5/BuHeNDKo8tl7DuWJaxIGyDMKgSVEpeIO5GCa4ch8++UXza0hVUA4Y2ZULsZQSCfh1DS548Sz47i2VWXuviazy5ZnXAtDQEQbO+cPoaq5fIfN84lU01YoXuAQBrwSALSx/ByQ2yyo7Ks3LXHFK/HBGEqDvhZqJ0WnCfwBMKZGOnSb3CQJQwyTpkEOS23snGGTQSGp1NCmIifpZxMFXST615A6ROnbN7vS5vrPDyUlgaFcBNv9y10MAflIq0A/oqT114JvrAFYQd0BNwx4awmSgah9i4u4ZqgCHejyt12SBWtAsgXoa9dsX9YfMvTgy7blIQCXMjt0FcXwRdx9YvYGyThmrlW1UW8XjL1/J7EXUt9RA29sdSLMCY5IXhJJ3L0QZvmIP4kPg6uHU5I8xvlVV7AoS2bIdaV7zIhoR01lkDfHyq9Jl74v
 kuYsIEF9
 WchWy6QBYZKmMtNOtOC80xwhPSI03a9ktIHihMoiifkg/XmMFF+fQqPV6+w==
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
2.50.1


