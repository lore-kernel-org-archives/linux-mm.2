Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E0FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A205E6B00B4; Wed,  3 Jun 2026 11:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8776B00B6; Wed,  3 Jun 2026 11:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E246B00B7; Wed,  3 Jun 2026 11:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB266B00B4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:46:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A4C11C13B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:17 +0000 (UTC)
X-FDA: 84839027994.25.6F5B1A0
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 638334000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NAHs4zfD;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501575;
	b=xrNdyijz3chHOhPGi36buik0ZULlQx1+mWQq8eW/i7nrabcldC8Jh3G3Xd21hz3efXrp2e
	qMNQJgFGmpBMak/DdXAyjAFTXod/1H8Sg1I7kOW0Fd8EtkCNyTMmI9O4UIGH05R5UAvUqo
	MrmdOsAFCc5k2VaszrBiBeu7j2M+Dvc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NAHs4zfD;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
	b=LwDKt4AR+EgiWrDrOLl118I6bGi5utPvBLV64c2Rw/AaoJe9BOPW745tYxdiHwIndGEz6D
	bYgh8wMOh7inKHq5sZVkTPuqI6xOmNegpW9vCCZ3Ih6ncIPAxLV/718YGxGA7CdcLInLSI
	//kQgKcGLNoQCfNyq4Ku/9iHf6N2ozU=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9157d3f2098so246493685a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501574; x=1781106374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=NAHs4zfDuniANPH+YYUm7SovuGRImP/NJCxpXPt7AXb7L1drP1qgt5y2ik5obA6JWY
         ai/xuvOZi4DkDWSbYNjqKnygP1lJdyNOma5r8/bV23T4N5PDM69iwF0ZikQ7L65bNiOP
         +zvYgvXLty2S0OUCH0D1+D3AMqxuw3/k40P+wPm9TzkQ9Nb8DC4w6RkN/iQSB5B0lsqK
         lGe0QWSGr2Ju+SpUjRryf2Jv2j94apXb16Gij42BsNkLDPjLnfYgChWeoRSXBsuChXNm
         1Z6i5IMpzOSsPHgODl2IR/t6sAYabXtFg5aEpEZDxBEfGum/rho727BX18HeoD8ualNX
         bcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501574; x=1781106374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SdAegEf5u3em8MUzB4xyEunyt/xoJrJRQD9FIOINoRs=;
        b=iYjv5gmasZ7Qft7wPQOf7YLc39MUeIcCMhxJKlRe00t30R3VXyHkQ2I2KfFb5wKjrH
         iS4KhaL+nk32BkySGakoPhSxTz2jLauDA//nvvBkrqYBqgumpJz3W3bajbF3B0yVoyEi
         Yjs4FRBmzZsV0CT4OU3ZYbHjvvJt0AF8NGSntykTMEo1ZtFCTp4GaSz/WX2f+rTapaS4
         ifqpkJ8EGjp9Kjhaz/zro8EK472v3JrENziRyWzrKzbjT0vQlBZkHrH7znS/RUjdSykf
         F026pBKEArgVLZsn25HXDiDXzyBDDQgBPgFRSegFvb3c0jEz68I+FbdFNJhwmRfGs45c
         6ECQ==
X-Forwarded-Encrypted: i=1; AFNElJ92BAZ+TkFyQGF8WLlXKPdxA8jqKecotDA923kKnPvkvXPjogRRxLOBi8aBNOBW49Cz85SDs0AAig==@kvack.org
X-Gm-Message-State: AOJu0YwUroKfWwyJFK3miR9pAp6D845XSZWPllK7bTESCuEZDzMfzt3K
	MeiE1D0DM5lMJ8ct+kcV1rcrDOMQd0Pi1DGDnOxg49vuZkRq+q3rFJ9SaObup7fkbZs=
X-Gm-Gg: Acq92OGbV68kKumFmN8SqtiiCRNfZR/QK0S/gfYB23bMB4Z9P9rBDLfts+VuNNtqyyM
	vLUMGyk/F1iexjzfpB0TZ3Z0aUARbez9ZNmj4QKC+MG7j8+ScKIWaW6DYHxOZkg755DIiyOdfDO
	q3J+CEdFQJ/N2Q71+ivjj+EsWCCHjBUs7R5WELJUG5As2jEnrvsMhX2Bzmizs8tWK/3abB/NKXa
	lUIBniT3Y954J/1PStp6txxd3HmJsoiLRi054xWawmmacr/fKmCacy/FhwYlBZBtmQ+HUlWSzMQ
	x2efijUgQBSHJcTBwvmFZkWqThzqyEYaCTAHSP5Hm14OGEWUraCBqy94J7YnD3xdUypMiDhtip7
	pIaPzgzpUXHPdmgKOGathjkYv/1vFbs3Km1JGN0W2lT1+NQ6yspwlGw9PtypW9sRaO4uAC6gJsn
	d6J9A2HZFw0dzj947IRtcQQsnlOFn+gFMFjVKuPUNsq+Gr1e/5bS1pOwjUbWQt6g==
X-Received: by 2002:a05:620a:4708:b0:915:3be9:1160 with SMTP id af79cd13be357-9158a6bb43fmr659953785a.21.1780501574350;
        Wed, 03 Jun 2026 08:46:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3bf5f9sm274596385a.35.2026.06.03.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:46:13 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v7 11/13] selftests/liveupdate: Test session and file limit removal
Date: Wed,  3 Jun 2026 15:44:00 +0000
Message-ID: <20260603154402.468928-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 638334000D
X-Rspam-User: 
X-Stat-Signature: om5z8niao47jwgycsnn7d9u4akrtpkeu
X-HE-Tag: 1780501575-709316
X-HE-Meta: U2FsdGVkX19ihlKjRZivUrxgV8WQf7EMhiHl7OlwXiTHJNtanQBRa4yz97Rk4RSbt6QGwlUaRb82WU/qZD5jEPHrjnGTGcS79S6JBBC/TeCvKndHIy/85BYjVsOouNwoAmB4JWlPBrxlWyY45glrodhQ87P1urM5aJJBBqPnJALNYAvdsYbrilGyds7HaSVznvKo2ilZ4YSvWwMt9TUKeUkqFd44/npWJwLcvkR5NU4tK/9prEQTqc0d1NjlItOYUvgQY7u793Gfp1fT/7asWEp/HXHoqJAsONDZRJzejnuqVpRJi7v9XoBDJRc6F/iB2iSXVcYvU36jhQaPrugVmv3U3pVmb2nNryt1+5eQyKBSWaWMRbG3/5kmJONP+PgdUAaRi2Qa0Pgafo6TXxLMF0OOszy2g7Af/W/ViJKsBoUPEW4okCXK5iOM+fhCmNUD7jqwMTsJgglfdmjly2MUW9EEE/vf9D8bqwbL0jYdLrYrnOK/zHvyfEaTCtM41+FF28CYXPN3GUrHzoJiT2oFuQtix1lvXi5R+nTc88KV+QMC+Suugig6AiU2e+AP4ZnomjDdddR6/LMCb007x2Bbjd3iw3uOtxgMQMfy1wIDw5yJov/EJiD1cERSPwg1IHP5ablP8Pt0eLU6jfU0PQDyPjrkibW79IDPAETztQYarecoa79mOoD2dtAp/stu5vZn3qhYAF3MShsde0eLaPQEB+ZO2zZFfKjpjN3kNVtVbHK4Cwl2SctOjEQxCh+QNjMRJwR8J9Z2dfxwlMm5pglB95L4mtE5wyJw0reT8+BauArsK0UQzCoApYU9n3DrXXBXcBHWsNWCFpddGKdHwCyEdUIIlfO5i51bRT2h6tBzeOXjPllhOOpy1qedfMzktK1yhIcAOIx0+KxnoAd33g+59bXV9TyEk/Msq5RzfRt03lasFWDKnBjnA5KSC7j6hWesCvCrClbdQwSLErCABSV
 P+eq3da5
 +MlAM4AUmKglrBRxNKb54z5Q+sW13l/wkrNAjO6VX3xYv8LlD68SebLf7Odb28wafjc4lAzC9ReOHOzjslAAkwE25lr3ygXJIMveD6zFXA4zSYXo+QGAbKXRrTVGaKnR1hvV5c53Ci8Ghigq7mymFSRGKcTu2wQ7MzP79mD0tj93IL/1soXsaSfzyADoYMk8x3EL7TfYMeb0ov9m0DXrczxPlpTIxyH9KZH/M8B51phmxTcOSOGT0lTVtpIYFIn62qfImMsxmYOm9+/w5wbgy6CRr7OzGs9x8wfAlbfYhi6wFiiTJah07KdkCornTv9wnfCLYbTC9WdWdgh8bVPHkcH7wrkOSIMqXTR0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the removal of static limits on the number of sessions and files per
session, the orchestrator now uses dynamic allocation.

Add new test cases to verify that the system can handle a large number of
sessions and files. These tests ensure that the dynamic block allocation
and reuse logic for session metadata and outgoing files work correctly
beyond the previous static limits.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 75 +++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 24 ++++++
 .../selftests/liveupdate/luo_test_utils.h     |  2 +
 3 files changed, 101 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c7d94b9181e1..502fb3567e38 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -26,6 +26,7 @@
 
 #include <linux/liveupdate.h>
 
+#include "luo_test_utils.h"
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
 
@@ -499,4 +500,78 @@ TEST_F(liveupdate_device, get_session_name_max_length)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Manage Many Sessions
+ *
+ * Verifies that a large number of sessions can be created and then
+ * destroyed during normal system operation. This specifically tests the
+ * dynamic block allocation and reuse logic for session metadata management
+ * without preserving any files.
+ */
+TEST_F(liveupdate_device, preserve_many_sessions)
+{
+#define MANY_SESSIONS 2000
+	int session_fds[MANY_SESSIONS];
+	int ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_SESSIONS);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_SESSIONS; i++) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "many-session-%d", i);
+		session_fds[i] = create_session(self->fd1, name);
+		ASSERT_GE(session_fds[i], 0);
+	}
+
+	for (i = 0; i < MANY_SESSIONS; i++)
+		ASSERT_EQ(close(session_fds[i]), 0);
+}
+
+/*
+ * Test Case: Preserve Many Files
+ *
+ * Verifies that a large number of files can be preserved in a single session
+ * and then destroyed during normal system operation. This tests the dynamic
+ * block allocation and management for outgoing files.
+ */
+TEST_F(liveupdate_device, preserve_many_files)
+{
+#define MANY_FILES 500
+	int mem_fds[MANY_FILES];
+	int session_fd, ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "many-files-test");
+	ASSERT_GE(session_fd, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_FILES + 10);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_FILES; i++) {
+		mem_fds[i] = memfd_create("test-memfd", 0);
+		ASSERT_GE(mem_fds[i], 0);
+		ASSERT_EQ(preserve_fd(session_fd, mem_fds[i], i), 0);
+	}
+
+	for (i = 0; i < MANY_FILES; i++)
+		ASSERT_EQ(close(mem_fds[i]), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..333a3530051b 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -17,6 +17,7 @@
 #include <sys/syscall.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
@@ -28,6 +29,29 @@ int luo_open_device(void)
 	return open(LUO_DEVICE, O_RDWR);
 }
 
+int luo_ensure_nofile_limit(long min_limit)
+{
+	struct rlimit hl;
+
+	/* Allow to extra files to be used by test itself */
+	min_limit += 32;
+
+	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	if (hl.rlim_cur >= min_limit)
+		return 0;
+
+	hl.rlim_cur = min_limit;
+	if (hl.rlim_cur > hl.rlim_max)
+		hl.rlim_max = hl.rlim_cur;
+
+	if (setrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	return 0;
+}
+
 int luo_create_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..6a0d85386613 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -26,6 +26,8 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_ensure_nofile_limit(long min_limit);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
-- 
2.53.0


