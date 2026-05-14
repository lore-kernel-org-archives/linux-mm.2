Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A89CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3836B009B; Thu, 14 May 2026 18:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B006B009D; Thu, 14 May 2026 18:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BD16B009E; Thu, 14 May 2026 18:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E302D6B009B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3CF8140707
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:48 +0000 (UTC)
X-FDA: 84767461296.18.AFEF291
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6C7340008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H3lb/bif";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14TtfdaLNy/StuYSb6NEiZW+KT+gZJT0aVK824S/d4k=;
	b=TC7JNrr7u0bYkbhVbZbYg0uZSndWi0zpyYeaA4yaA0kTY9bNsC7s3jFN+5iY5/Oi5AB3Hv
	Uaw9vVRlL05qy9Z9hmJ3+lCmxzKM6kswhBNgju67/pArjliCrERzM35jALTQ0PrY4hMvWN
	+wMRUGyXHurDLgszZwaqpSgdWhonKQs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H3lb/bif";
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797606; a=rsa-sha256;
	cv=none;
	b=EEdYf7wuY76uWUy5hzflPOTa+kdgujbO2UiSjWvJog9O0fWuT90Kr3AckMR+iEjN+5pUYX
	NDrDgaHK3ceDs2d+Eg+KgliojruwDmR+WEUCaMN0qEUVPB49KpeKakTyIdL5qrD6KVbMwO
	guk3q1yktr8WfZ5KlA3oWkgG05eS7W4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-514ae601df2so27945611cf.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797606; x=1779402406; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14TtfdaLNy/StuYSb6NEiZW+KT+gZJT0aVK824S/d4k=;
        b=H3lb/bifvceXppbhnPlzHAAu20rhtXSLIS90b30slMe/5OG3Vw3kohFzXZ38zkm0C3
         p03fz0aeNHIJwJAs3JfSgZc9HYQUeQ4HJ7WJvLjN6HsTemuxyboaqi9FS6WBvTA7wku+
         I4IzJ4P+SFL98Ktyi3SaeG/NBDj1NQjr6+cPPsnKgniw8EB3WNqfhsmbrvpxHlzsu0Ym
         28ZBsvKHnHOFUGTPLoIz0jJdqAljlEbmehY4fn3uIFBZAFxd4v9jh81ufjQBxr29aFOw
         3aado6ANCgV31C24fvVLoL2qqFDHj5hAQ9jA8/puyd847Jf+t2dcRNTVfMO0U2mdNAXc
         41tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797606; x=1779402406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=14TtfdaLNy/StuYSb6NEiZW+KT+gZJT0aVK824S/d4k=;
        b=c0kcb7W4YtfnFany1i2RpjfFAP7c4WtJLGElFvGB90xWt1Hq+r7sf4LGpyFVpYC/KE
         vPVcpSl8fkPWjnT1RXXLsHoUQeaRE9kgftlnK6r9c08pPjgmsjH+FV/JSuXtjNxUOPjA
         LZDFxVHrfNU8wUpoWOv1y85MbxCDSpExWu0klt+nBgj6wmhCiSwQsWJDAlzThsUIQvvR
         2Il/1ozS0ujL8FqR7f9FeC1fRXp+6HlJ9CRkELBP6YKpJJ0vumePVjIHoscy1WkaCP9s
         Zz1VXjhEL/L3K8nSaf5UEIlNOIb7s2y1X4+jCvb595XN+mNitV6RGSgtI9ydbYX8w6XK
         LFBg==
X-Forwarded-Encrypted: i=1; AFNElJ9zTndNBVwuQ6jqLtof88Yt77qYAJsCdW94bviK7uvK8zdqAICBM1YsWfujyA554tIScj4XWfJvnQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6HBATHz8IIpCR0QuyPgMdkEVQvb7SuRaErC8DqOu0IXTpRf+e
	PeM27pbH9sm4jkfVEUM8xv+mpMT5QHlMvEs70jCY8dD82Udm8CmIxw0qRzJxNSMBQs8=
X-Gm-Gg: Acq92OE+I9hveAGVD0qdnJJYDEpPqVggvi6Lc51zf7scQtOe81Qf4GJznt190ykSNQD
	dDsJUHHx4yeXLyWFooxdejctd10CZTf9jDF6RBcPSdFEU4J909rdnhQuQglSEmkNssc0dlRcRwd
	C/qLLIeoJyJLt3UIjui7jIB2sy+DgI9BPCGQ2qFZsMPGoAsWBriWl/MWEBJe6/5727XgCPpQXMX
	YRIisy11J+CTwLaVAIlDBHBYyORswTEz77t3G3K+Ip07xYQakZR0z4m/ziVsgls8SD6QYl6uqaQ
	UMpC3JGesuiCBhPhrJYqso9isp3SNdeM1F3K+0uruLW7L1fvb17LaUvQ4Lh/e6knDm2ViT/4kAX
	MYzgyUjBvsNxzdoC+gBGEPoYdZucp1Rpjk7bd6YJVnBOAJLXKKreOX3HdB2GbHOA+J8o1TsdjDF
	0Crlg0+6ZQDdYeC7luRO7qkuknjb9vWLdRmJx5zHcDPgaefSmST4FJGz/vVb82Dg==
X-Received: by 2002:a05:622a:59cc:b0:50d:7406:8f05 with SMTP id d75a77b69052e-5165a0010a3mr18527381cf.9.1778797605925;
        Thu, 14 May 2026 15:26:45 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:45 -0700 (PDT)
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
Subject: [PATCH v2 08/10] selftests/liveupdate: Test session and file limit removal
Date: Thu, 14 May 2026 22:26:26 +0000
Message-ID: <20260514222628.931312-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6C7340008
X-Stat-Signature: 6jiz7co5dxyw5zogwx4ipbe7e7wtaj7f
X-HE-Tag: 1778797606-584415
X-HE-Meta: U2FsdGVkX18f6IGM+1zSvrpeqiKKmBH0/hjiPg5tR2hVGHB+JLFzxnYkqrQN/3TYg8Wlc7FRnBtUROI58mp0PCtaAQFwteos3d36MqGLtgDH3bsJAw97KkvOPzwFHt8dIwaBcLl+FN5cD3SUMDGFY9HOP2dJ+YoVdTnpV+5ZxWM2H6jpeZjFw4yBZSeL+Go4Bt2PMgSz8r38yilszevzKUBMy0n6x0OkmcxhfuPW3RHan1m4uAZq9ZtHnc1sLvkxyqP/V/a1j8Gd5YB+sEmZNJ3mV8f5ShdTlOZo+8Vz1BlVUcdRdikKKvMZZjzeLg8vwPvoK1rBKMSq1nGjrib7M3pgLPsmSFW6F0wLjwMklhxlNjzwdIlVgCyyVQnkFGNi7wvFv2WwGM9g6nkZ9F5rRBOURiBjqjKGNr8l1A+GuIip1YpH8cuHv6Frqpguql9si1BSpGd1B1DnakOnlqi08j1rRVg5Mk/3CMrEWGJK8VBD+we82DlOQ125bS5ugY8FOJqKAQouvU4PbkgAvrFEV0j5sPCcslNwigKJYlLdu/sfWoESkQpxvlNCGn/8fid9E7FLWPNFL/QInCDpe4olrgSjP6hA9ZwP5/MwNWNtMVxc7OkQaUjXr+4nPPlIjvqEP9RmwLfBM+gapxxPOEcyhzCI/VAdTveWdt/kiRGtOl/Cj+3KADmNMPqyUSTF2s0wNvp6piwQzqh+yXGoY0muJuumWu3k8rylTnUjeizswOfQ0aknn8tdniS/sqGMnnxSEbQWhHzenbOq+jIP7Pb+xlbQl+/aYA2V/GKBFiFJAnMyymRvQ4UaNU8SZdBxZKaVKxLZk2Dqw6D4hf2uCdxdoBIMc5GDMP5DXdjrjJNGjZttHppc+xdhyWXREpfC7LRDfLi+M/5sf6Cjjn9wC6Y5CnKP9JukBKWxNIhMZN7UEjlTX+5Jih4vy6EOEhcMtwfGBWKke5v/h9gfRY7fK//
 Fp6blP2Z
 czQobKIvlCuJv5UmROL8gEblqHfxwaT4mEBndGFpJFWSgAEyI4K3yN0BVVRP7tKoMOm9bFL5qjofDEVwX0Ay3SH001m9y1Jl7fK1WmlWm9+k3S5roVHiHyN3HXjaHAx0TN6gFsks2UrWw9T86gPiwyaoa41BPY76m6I/kELXF2kculqEGX3RzbFkmiO8OjkTJcwJN5QwCbXn80JvcCppOmjjLOehaMhCQN8JTGHDjwZwpWT4YtYtJRNOwuoooX59spyxES0BzON/wNLA22phqZz7dW6g0puW7m4YOFXfKckdO9nW4KBvAMQwW+KY4ozRxTezKZNKaG2luXI0=
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


