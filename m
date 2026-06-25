Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2701ACDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622A16B00A2; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF3E6B00A1; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471946B00A2; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEDB16B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:50:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AE3F167630
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:50:03 +0000 (UTC)
X-FDA: 84917359086.30.7F1C48A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id 009E780003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:49:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366601;
	b=NG5GLfOArsggboitFPoDL3LLfiL5siX//VDBctukq+doa0MYGrx7GaPEq3MK6lUmu1Ix8j
	ZxYg9loaT2UOYtvPf72wJBLWz2TX8/qSd3SLefRXEPhHN4cTbC5FZ6AJi+JsLUbUZYbSSd
	mq0Idpp5oiaSI32fu2WKhmUG0HILF6w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVCHEXgX9KdKoxaO4oXTD3YwJcFooeRtrXkXUKJAlWg=;
	b=hoJlsWMRIHJcnRhxI9UFlQVv0x4ozh2G5eqycKSY/1JcU17v5IibVmt0rqtEyjWTJx8z9q
	iscuf+dtfh/9Ia1JgfJ8giS1FZS7373rscKmkp1BqQwLFcmAO6SqKR8kd8bXDEHOnhOlw+
	qhhCUY4D9zuzG38wgBO2JxEZjSJKiK0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: aef9f1bc705911f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f2e0c2af-0b9f-498c-8781-0762bfd59877,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:f2e0c2af-0b9f-498c-8781-0762bfd59877,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:99ab6c67cec03f0d7d286831c98c0fee,BulkI
	D:260625134952RUV7V4LY,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,R
	T:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aef9f1bc705911f1aa26b74ffac11d73-20260625
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 648558986; Thu, 25 Jun 2026 13:49:51 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	pratyush@kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 2/2] selftests: liveupdate: Add selftest for eventfd LUO
Date: Thu, 25 Jun 2026 13:49:46 +0800
Message-Id: <20260625054946.73445-3-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625054946.73445-1-duanchenghao@kylinos.cn>
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 009E780003
X-Stat-Signature: q6b6fqijzbu8c9uwdn57mbmejxfprmq5
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782366598-991327
X-HE-Meta: U2FsdGVkX1+BhPzHvbVUdnTnWAPILf2+LOf2gv8FU1Mh5kaAAFW5hTNIzv9Mr0wgjYNKH4uWZFS6Agd3W06TGXG3qajrSU7zucNUQma9I14oRM5DYjvfck9sGqnfinHQMNFSKnLUgQim9m/Xy6fDmhTdFYywhd+mjsOm2aySt6iXDMSQOLWxjryn2A09hEgO9/G8k5pxiiPlA75sLo3kudXVNuG0W32u/pvG5JitKoo7oJs03YdKy2/aN955rrhO6B62MOJiM4fyWuvTsu1ezNh9qTX5xg1/1tYiFQfA6IIfcJsdbsO/NZE9YmcVl/g1bZ2dmKtrR+UExMRfQxMtHi9LO2Fgh1M3OxGNbn9QnxvGRdOh1X6pAipMKwwl9RQvSxoLM4CbKOlpaxW1pBEkcMnippQaUqP5Eu/CoTjmxP9291JJ405AheYuMVw2B4UPcRstW6ZmGUSBUAXtnQpGZvUmU5bPGybRzmS+vGU9/bfCp4w6zYlM7ppohPfxAKLGaFPAtmwATPIO0+4MCdD/fdJ49RLl8no18ZmeGbnhesr6yCIocImCIWS3gBv2oH+e9kCsdfMLgMF1HxX8dWx/Tw0Lh9lTB45fjdxz1KWYM1TWCesLVsyGPW+vejG9MtwN/9EFQeMVMZdAUHXZGeQX7NZ/OEuw+yhAjhsy3pLO5JJ6TJYNAAIcdR1wkZ+Jm6mCXG2wPmFAX6G+aJj9avfI3/3qB0zJCFD9cmEK/SPEwYqwuITL2DsFcu37ki9LBKjx+7rE/Cci46tJRqVNlnIRLdjoCXKrX5bfQ89LzGQw/Ghm9+P50s278fpaGk0ajiVytQdfDg/IxIp35+Etl7G1QlLRI9irM+QriwSxI+ptEmaVYd3SvUqHkxGxQSDPi3ILDH98UKz/j3cfJGyzuGx4ASM4FeW4bXfcZP0Y+LFPoaz6ypjbeD0w9qmfAhSNnE/1Bh0SUgtPHIUYjZz6FwL
 Hlmtd/u+
 L53TE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test verifies the Live Update Orchestrator (LUO) support for
preserving eventfd file descriptors across kexec. It creates multiple
LUO sessions, each preserving different eventfd types, and verifies
their state after kexec.

The test covers six different eventfd configurations:
1. **Empty eventfd** - Zero count, default flags
   - Verifies flag preservation without behavioral testing
2. **Default eventfd** - Initial count + write, verifies count preservation
   - Tests basic counter value retention across kexec
3. **Semaphore eventfd** - EFD_SEMAPHORE flag, multiple reads
   - Verifies semaphore behavior (returns 1 per read)
4. **Non-blocking eventfd** - EFD_NONBLOCK flag
   - Tests O_NONBLOCK flag preservation
5. **Large-count eventfd** - UINT_MAX count value
   - Tests handling of maximum counter values
6. **Modified-after-preserve** - Count changed during handover
   - Verifies freeze callback captures final state

The test validates the following sequence:

Stage 1 (pre-kexec):
- Creates state file for inter-stage communication
- Creates multiple LUO sessions
- Preserves eventfds with different configurations
- Trigger kexec reboot

Stage 2 (post-kexec):
- Retrieves preserved eventfd sessions
- Verifies flags and counter values for each type
- Tests semaphore read behavior
- Finalizes all sessions

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 tools/testing/selftests/liveupdate/config     |   2 +
 .../selftests/liveupdate/luo_test_eventfd.c   | 376 ++++++++++++++++++
 3 files changed, 379 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_eventfd.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 30689d22cb02..e092e38fa6f6 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -8,6 +8,7 @@ TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 TEST_GEN_PROGS_EXTENDED += luo_stress_files
+TEST_GEN_PROGS_EXTENDED += luo_test_eventfd
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 91d03f9a6a39..d388bd755245 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -9,3 +9,5 @@ CONFIG_LIVEUPDATE_TEST=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
 CONFIG_SHMEM=y
+CONFIG_EVENTFD=y
+CONFIG_LIVEUPDATE_EVENTFD=y
diff --git a/tools/testing/selftests/liveupdate/luo_test_eventfd.c b/tools/testing/selftests/liveupdate/luo_test_eventfd.c
new file mode 100644
index 000000000000..94ef3bc66ad9
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test_eventfd.c
@@ -0,0 +1,376 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 KylinSoft Corporation.
+ * Author: Chenghao Duan <duanchenghao@kylinos.cn>
+ */
+
+/*
+ * Multi-session kexec selftest for eventfd LUO support.
+ *
+ * Modeled after luo_multi_session.c.
+ * It creates multiple LUO sessions, each preserving different eventfd types,
+ * and verifies them after kexec.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/eventfd.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include "luo_test_utils.h"
+
+/* Session names */
+#define SESSION_EMPTY     "eventfd-empty"
+#define SESSION_DEFAULT   "eventfd-default"
+#define SESSION_SEM       "eventfd-sem"
+#define SESSION_NONBLOCK  "eventfd-nonblock"
+#define SESSION_LARGE     "eventfd-large"
+#define SESSION_MODIFIED  "eventfd-modified-after-preserve"
+
+/* Tokens */
+#define TOKEN_DEFAULT       0xCAFEBABE
+#define TOKEN_SEM           0xDEADBEEF
+#define TOKEN_NONBLOCK      0xFEEDBEEF
+#define TOKEN_LARGE         0xBEEFCAFE
+#define TOKEN_MODIFIED      0xABCD1234
+
+/* Counts */
+#define COUNT_INITIAL   42
+#define COUNT_WRITE     10
+#define COUNT_EXPECTED  (COUNT_INITIAL + COUNT_WRITE) /* 52 */
+#define COUNT_SEM       5
+#define COUNT_NONBLOCK  100
+#define COUNT_LARGE     ((unsigned int)-1) /* UINT_MAX */
+#define COUNT_MODIFIED  25
+#define COUNT_MODIFY_DELTA  99
+
+/* State tracking */
+#define STATE_SESSION_NAME "eventfd_multi_state"
+#define STATE_TOKEN        997
+
+/* Eventfd verification modes */
+enum verify_mode {
+	VERIFY_FLAGS,        /* Only verify flags, no behavior testing */
+	VERIFY_ONCE,         /* Read once and verify count */
+	VERIFY_SEMAPHORE,    /* Read multiple times, verify returns 1 each time */
+	VERIFY_NONBLOCK,     /* Read once in nonblock mode */
+	VERIFY_LARGE         /* Read once, verify large count */
+};
+
+/* Test session configuration */
+struct test_session_config {
+	const char *session_name;
+	unsigned long token;
+	unsigned int count;
+	unsigned int flags;
+	enum verify_mode verify_mode;
+	const char *desc;
+};
+
+/* Test session configurations */
+static const struct test_session_config test_configs[] = {
+	{SESSION_EMPTY, 0, 0, 0, VERIFY_FLAGS, "Empty"},
+	{SESSION_DEFAULT, TOKEN_DEFAULT, COUNT_EXPECTED, 0, VERIFY_ONCE, "Default"},
+	{SESSION_SEM, TOKEN_SEM, COUNT_SEM, EFD_SEMAPHORE, VERIFY_SEMAPHORE, "Semaphore"},
+	{SESSION_NONBLOCK, TOKEN_NONBLOCK, COUNT_NONBLOCK, EFD_NONBLOCK, VERIFY_NONBLOCK, "Nonblock"},
+	{SESSION_LARGE, TOKEN_LARGE, COUNT_LARGE, 0, VERIFY_LARGE, "Large-count"},
+	{SESSION_MODIFIED, TOKEN_MODIFIED, COUNT_MODIFIED + COUNT_MODIFY_DELTA, 0, VERIFY_ONCE, "Modified after preserve (kexec handover)"},
+};
+#define NUM_TEST_SESSIONS ARRAY_SIZE(test_configs)
+
+static int verify_eventfd_flags(int efd, unsigned int expected_flags, const char *desc)
+{
+	int actual_flags = fcntl(efd, F_GETFL);
+
+	if (actual_flags < 0)
+		return -errno;
+
+	int expected_fd_flags = expected_flags & (EFD_NONBLOCK | EFD_CLOEXEC);
+	int actual_fd_flags = actual_flags & (O_NONBLOCK | O_CLOEXEC);
+
+	if (actual_fd_flags != expected_fd_flags) {
+		ksft_print_msg("%s: flag mismatch - expected 0x%x, got 0x%x\n",
+			       desc, expected_fd_flags, actual_fd_flags);
+		return -EINVAL;
+	}
+
+	ksft_print_msg("  %s eventfd flags OK (0x%x)\n", desc, expected_fd_flags);
+	return actual_flags; /* Return actual flags for further use */
+}
+
+static int ensure_nonblock(int efd, int current_flags)
+{
+	return fcntl(efd, F_SETFL, current_flags | O_NONBLOCK);
+}
+
+static int verify_count_once(int efd, unsigned int expected_count, const char *desc)
+{
+	uint64_t val;
+
+	if (read(efd, &val, sizeof(val)) != sizeof(val))
+		return -errno;
+
+	if (val != (uint64_t)expected_count) {
+		ksft_print_msg("%s: expected %u got %llu\n",
+			       desc, expected_count, (unsigned long long)val);
+		return -EINVAL;
+	}
+
+	ksft_print_msg("  %s eventfd OK: %u\n", desc, expected_count);
+	return 0;
+}
+
+static int verify_semaphore_behavior(int efd, unsigned int expected_count, const char *desc)
+{
+	uint64_t val;
+
+	/* Read expected_count times, each should return 1 */
+	for (unsigned int i = 0; i < expected_count; i++) {
+		if (read(efd, &val, sizeof(val)) != sizeof(val))
+			return -errno;
+
+		if (val != 1) {
+			ksft_print_msg("%s: expected 1, got %llu at read %u\n",
+				       desc, (unsigned long long)val, i + 1);
+			return -EINVAL;
+		}
+		ksft_print_msg("  %s eventfd OK: %u at read %u\n", desc, (unsigned int)val, i + 1);
+	}
+
+	/* Next read should return EAGAIN (no more events) */
+	if (read(efd, &val, sizeof(val)) >= 0 || errno != EAGAIN) {
+		ksft_print_msg("%s: expected EAGAIN after %u reads\n",
+			       desc, expected_count);
+		return -EINVAL;
+	}
+
+	ksft_print_msg("  %s eventfd OK (%u reads)\n", desc, expected_count);
+	return 0;
+}
+
+static int restore_and_verify_eventfd_generic(int session_fd,
+					      unsigned long token,
+					      unsigned int expected_count,
+					      unsigned int expected_flags,
+					      enum verify_mode mode,
+					      const char *desc)
+{
+	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
+	int efd, ret = 0, actual_flags;
+
+	arg.token = token;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
+		return -errno;
+	efd = arg.fd;
+
+	switch (mode) {
+	case VERIFY_FLAGS:
+		/* Only verify flags, no behavior testing */
+		ret = verify_eventfd_flags(efd, expected_flags, desc);
+		if (ret < 0)
+			close(efd);
+		return ret < 0 ? ret : 0;
+
+	case VERIFY_SEMAPHORE:
+		/* Verify flags + semaphore behavior */
+		actual_flags = verify_eventfd_flags(efd, expected_flags, desc);
+		if (actual_flags < 0) {
+			ret = actual_flags;
+			goto out;
+		}
+
+		if (ensure_nonblock(efd, actual_flags) < 0) {
+			ret = -errno;
+			goto out;
+		}
+
+		ret = verify_semaphore_behavior(efd, expected_count, desc);
+		break;
+
+	case VERIFY_ONCE:
+	case VERIFY_NONBLOCK:
+	case VERIFY_LARGE:
+		/* Verify flags + count behavior */
+		actual_flags = verify_eventfd_flags(efd, expected_flags, desc);
+		if (actual_flags < 0) {
+			ret = actual_flags;
+			goto out;
+		}
+
+		ret = verify_count_once(efd, expected_count, desc);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	close(efd);
+	return ret;
+}
+
+static int create_and_preserve_eventfd_keep_fd(int session_fd,
+					       unsigned long token,
+					       unsigned int count,
+					       unsigned int flags,
+					       const char *desc,
+					       int *efd_out)
+{
+	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
+	int efd = eventfd(count, flags);
+
+	if (efd < 0)
+		return -errno;
+
+	arg.fd = efd;
+	arg.token = token;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0) {
+		int ret = -errno;
+
+		close(efd);
+		return ret;
+	}
+
+	if (efd_out)
+		*efd_out = efd;
+	else
+		close(efd);
+	return 0;
+}
+
+static int create_and_preserve_eventfd(int session_fd,
+				       unsigned long token,
+				       unsigned int count,
+				       unsigned int flags,
+				       const char *desc)
+{
+	return create_and_preserve_eventfd_keep_fd(session_fd, token, count,
+						   flags, desc, NULL);
+}
+
+static int create_session_checked(int luo_fd, const char *session_name)
+{
+	int session_fd = luo_create_session(luo_fd, session_name);
+
+	if (session_fd < 0)
+		fail_exit("luo_create_session for '%s'", session_name);
+	return session_fd;
+}
+
+static int retrieve_session_checked(int luo_fd, const char *session_name)
+{
+	int session_fd = luo_retrieve_session(luo_fd, session_name);
+
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", session_name);
+	return session_fd;
+}
+
+static void finish_session_checked(int session_fd, const char *session_name)
+{
+	if (luo_session_finish(session_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", session_name);
+	close(session_fd);
+}
+
+static int verify_eventfd_config(int session_fd, const struct test_session_config *config)
+{
+	return restore_and_verify_eventfd_generic(session_fd, config->token,
+						 config->count, config->flags,
+						 config->verify_mode, config->desc);
+}
+
+
+static void run_stage_1(int luo_fd)
+{
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-eventfd test...\n");
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_TOKEN, 2);
+
+	/* Create all test sessions */
+	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++) {
+		const struct test_session_config *config = &test_configs[i];
+
+		ksft_print_msg("[STAGE 1] Creating session '%s'...\n", config->session_name);
+		int session_fd = create_session_checked(luo_fd, config->session_name);
+
+		/* Special handling for modified session (preserve then modify) */
+		if (config->token == TOKEN_MODIFIED) {
+			int preserved_efd;
+
+			if (create_and_preserve_eventfd_keep_fd(session_fd,
+								config->token,
+								COUNT_MODIFIED,
+								config->flags,
+								"modified-after-preserve",
+								&preserved_efd) < 0)
+				fail_exit("create_and_preserve_eventfd_keep_fd modified");
+
+			/* Now modify the preserved eventfd's count */
+			uint64_t modify_value = COUNT_MODIFY_DELTA;
+
+			if (write(preserved_efd, &modify_value,
+			    sizeof(modify_value)) != sizeof(modify_value))
+				fail_exit("write to preserved eventfd after preserve");
+
+			close(preserved_efd);
+		} else {
+			/* Standard session creation */
+			if (create_and_preserve_eventfd(session_fd, config->token,
+							config->count, config->flags,
+							config->desc) < 0)
+				fail_exit("create_and_preserve_eventfd %s", config->desc);
+		}
+	}
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int session_fds[NUM_TEST_SESSIONS];
+	int stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d", stage);
+
+	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
+	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++)
+		session_fds[i] = retrieve_session_checked(luo_fd, test_configs[i].session_name);
+
+	ksft_print_msg("[STAGE 2] Verifying eventfds...\n");
+	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++) {
+		if (verify_eventfd_config(session_fds[i], &test_configs[i]) < 0)
+			fail_exit("verify %s eventfd", test_configs[i].desc);
+	}
+
+	ksft_print_msg("[STAGE 2] All eventfd sessions verified successfully.\n");
+
+	ksft_print_msg("[STAGE 2] Finalizing all sessions...\n");
+	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++)
+		finish_session_checked(session_fds[i], test_configs[i].session_name);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- EVENTFD_LUO TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
-- 
2.25.1


