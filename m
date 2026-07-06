Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF0EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684F36B00CD; Mon,  6 Jul 2026 04:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60EDA6B00CE; Mon,  6 Jul 2026 04:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD456B00CF; Mon,  6 Jul 2026 04:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAAE6B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:17:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86E4414030A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:11 +0000 (UTC)
X-FDA: 84957646662.09.BFF86D4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9777920005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:17:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XVY6d6Rk99Nnk/xCcH5op+s03+gz9ZCyp1qwVZplDvY=;
	b=bDEvW48HShnXflWtjJxGv9Wm65zHK5JOSV25wewUf2vBqXnqaphdRBsKGpadFc6VvO3ffR
	3g+sBXYxI7Dgw4bLhf19KNkJ2lCufzAdpwbD5j1fs2ObNG6u/HtNt6cNuO7PmChXJcXymI
	RZr4+WCrK56Qgc0d2tcA2E3NagMExyk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325828;
	b=cr7YsfFELAQAgFQxvoDVqspTtSZHnxljf8RUxvry9zQUqNG4eLXCpfuy/Py0EyWRy/PWhP
	Lx5eQnNySBymeZUuipc77Ow1x1HVDgslSpnXAOzsEtBP0gqyd7zmADctBq9J+JZkgcNBxr
	wgULskKOq9QwYuUnIOrEd52/jrF6Edc=
X-UUID: 0fa26b5e791311f1aa26b74ffac11d73-20260706
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6581c2c1-238e-4af1-b4a3-26e22edff284,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:6581c2c1-238e-4af1-b4a3-26e22edff284,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:59a0451f674ba0e9c7ee4404c51fcdc5,BulkI
	D:260702142428GHQ5OG4Z,BulkQuantity:1,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0fa26b5e791311f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2061271907; Mon, 06 Jul 2026 16:16:59 +0800
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
Cc: jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	usama.anjum@collabora.com,
	yury.khrustalev@arm.com,
	zwisler@google.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v10 1/6] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Mon,  6 Jul 2026 16:15:55 +0800
Message-Id: <20260706081600.3570203-2-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706081600.3570203-1-lihongfu@kylinos.cn>
References: <20260706081600.3570203-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9777920005
X-Stat-Signature: 533mgjeaqn5puh83t1zxma54ouc5ysc6
X-Rspam-User: 
X-HE-Tag: 1783325827-204206
X-HE-Meta: U2FsdGVkX1+aIUq9VZe1UEr1D1XaZFvWQMrcE9VNIkqcEqyaIe/o0x8BI3gXPlcVjM+2uR/GnXVH3E+wZefHGhXJPsqNwf5kKCiT4wJHXV5YnZOXuYnsRkpOkzJ77u5803xDlrbjP3/Lsh0S7WM12HfMalwiN3YH84oVgNbNOzawyRaRS+MmI9FPlIOt+GtsOO3z/Cw5pQ0IHIoABLHplz05oIIrjLU7hIrrMLJ0AjV3rCZ29ytjMNtXpxF/YHW5wvoWpJ4VJ6Y/0n0BlyZraN18XrLCODCJLrVTy5WVD+ooHxjmAEMxUEYuCQuuwtjlPpaVbfrSZf/XWlh1BzZTH5Zu1zO21MWT0YiTtdq4KKuZFozdaiOVB4p1PvKMlygp9XEFxjCvgVvPbbKJSSvL3RoHYgxfZWezmLhA30EBrnGffGL3q3fSPkp+pwgPB6rmR0sk5q4zBRQrruWG6ru3VV+FqXV8ZFOhBt6rXYUHBTbGXDLfT5Mue/gR8F9UiKw+1FYWfEQj4QSfOSqKX1byhqbq6CMmGd4mHAEM0+LtYa70YXb0mrCxyqx0mGw6h/unoIya97xgLhdKR92kUdAewRXKBMDqfHHR+SZfjnndTeDHTLL2CVIgvjVgdToVEkW0uvb2thbk1L5+GOIp+BDIcwh27UVKDh0X6g+6WmXiNSET6SiQYevcdS4fyI6KAbp16NSATy2pc3bsHzvvJ8jyh8MMvHCfEWyIviBDE2fUYUsM119Gzt6nEd2yNterZQESZ4YuShZ7Z37rocvdVKHfTzz89LmfVBOPWjGMVelSG+jLNMjO5L2cW8rThXMn7yB58Ogi43bPWtaaLDBVVlINdWD5vaPOUX3nk3MIu+vWBgHFKZsuMudweWQ/IrVKz6ac83qsGztatbI8gcXpO5n8F6UnFtPtIPL+w7T3j+yB1Kdic9KP6U9g4aSeZ1ViEvfpBDvWqpnH5INhpWBcl5R
 NqHyS5K3
 vhUhkw9Rooj+ItY1pl3hRaR0iBHkP46ObASoQXGYJJc9KYOc0MKF6IZwnrWdGedLRZsCdIjsbPVyjrI5RafgiukTq/8wnH+J9KMeyAZPu9WbUx+2MuJhOmWVnA3yom516oiWAjXV8XL1PrpurCkwnQmgymaraoshcm89iHG2CNsfTH27olvdfXOac+ymi0k6+gkQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move pkey selftest debugging helpers into shared code so both pkey
selftests can use the same tracing and abort-hook logic. Also fix
cat_into_file() to print file, not str, in the open() failure message.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pkey-helpers.h    |  4 +-
 tools/testing/selftests/mm/pkey_util.c       | 90 ++++++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c | 87 -------------------
 3 files changed, 93 insertions(+), 88 deletions(-)

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
index 255b332f7a08..fbef3cd45447 100644
--- a/tools/testing/selftests/mm/pkey_util.c
+++ b/tools/testing/selftests/mm/pkey_util.c
@@ -2,9 +2,99 @@
 #define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "pkey-helpers.h"
 
+int iteration_nr = 1;
+int test_nr;
+int dprint_in_signal;
+
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
+		fprintf(stderr, "error opening '%s'\n", file);
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
index 9a6d954ee371..be4a0470cc61 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -49,11 +49,7 @@
 #include "hugepage_settings.h"
 #include "pkey-helpers.h"
 
-int iteration_nr = 1;
-int test_nr;
-
 u64 shadow_pkey_reg;
-int dprint_in_signal;
 
 noinline int read_ptr(int *ptr)
 {
@@ -62,89 +58,6 @@ noinline int read_ptr(int *ptr)
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


