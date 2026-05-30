Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01892CD6E54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6FA6B00C0; Sat, 30 May 2026 18:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE6E6B00C2; Sat, 30 May 2026 18:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D466B00C3; Sat, 30 May 2026 18:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0EC06B00C0
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84C938DC2E
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:04 +0000 (UTC)
X-FDA: 84825505128.22.741A117
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB455100013
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hMBQptdy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
	b=rUAzTeDzG+MsXBhDrsLvdvVRC29rvlg3dB8aJmihLAuUljpb4+IdXINb8zEC2TxjoEXwku
	HeQth6vog3jrqajMaXAeV+ri+mVkchvqSm1W2bKIPl5QSxnF+hQSNIOYAz1h+ZiDXzG9+e
	eTO4QD/cdQfY/nYCUpleju5pnBYB1DA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hMBQptdy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179602; a=rsa-sha256;
	cv=none;
	b=qnNiQWh/a91IQeVncBYodIK4OhLPOcPWiN3rvivXrkH8yX7fl1BCGOjtYyJ59Bkuh2gjeI
	DgnIHPVyBk24+AyvYajgOqmhoMuaAhiPN33sX2fyiVsJsr3b8Mly7C3ViD0H4bYM9jXTUR
	OzO5QjnraJkzU7RVj4v0HWXKUH3mL5s=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-91550dda53cso32287385a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179602; x=1780784402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
        b=hMBQptdyhxrSOMSHjpybP6IPXniSJq0iAP8cLGGywtV/qS4gWlcQKRRpZLZ8LIj0Dk
         2pKBsY3ypXE0Ma0A1l8D1P+TfOS7GnBYE721fQ/ZtkcA2mjRwHWQbXKqf3haq5RwIRcI
         Ix3VRO5+rLCF/Acegh70dfaFaCpkX64JDKxrTnLQmdjmJSi0utTJmS9yab6FHIgYooG+
         xW3JCXTJCrCRlAs9UiBlH1MyHQoR0GJ93KhBBPXFP3CSs0LMRKXBekqLohHE9623is8X
         4D5W9UP29+xLZvZglPlP2QWd3y67JgDlmlm60NkdyFFtr49zHiuQITxzLadWTHrgtmyh
         Om1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179602; x=1780784402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
        b=H+xC1jooSz91TtgEqXScEyMm9hQCfOfxcbLafGT4hjLtYugv4NxzkgZs3P6s3A82IE
         MHFOVdMAvbylqoMA5yplw+KBRvE+6+yir4bxfldNmrU40Wno005TkuDai/LTGyp0rQBN
         yJiXGRwLthE+JbvA2+4LzVraKA9zZsuclM0v16z5tfL/gR0LBocH0H/YtMizTGqnhqw7
         MOcv8+N+zSodxLpBHULZf9r3QQAKZ+oZic2utkG3WVhwPIgkqmJO96g7FoPqlyUUXL7H
         nm0FYt6tt6XuGI2jVxg600ZyLFi0F3ujqZfw4Ch0rb6SbHGesKAXqaxfXtAOZ5Md7gyq
         U0YQ==
X-Forwarded-Encrypted: i=1; AFNElJ+R+n707y+V/so247b3xhJ+b6VcEW70jBrqw5K5L+OFQKlJFa4cqaSJ3OWLFhnVaX5RdkaL2EdF2Q==@kvack.org
X-Gm-Message-State: AOJu0YynoCgiY6/pi/r+PzXsmtgZlz40ViQlkrj9fda37DP2Q+Hm5jId
	o/GO9C6QFrspq8IFTWJ6m4WAWA+RVZVMvJKCK4ikr1mVjUtdE0QYB9AJgreAS4SWBH8=
X-Gm-Gg: Acq92OHUOSUKsuvNBuFTwwy+czRA3na70OQqvFDK91gbo7SFLRNIxFnNl0NhtvRos0j
	exjWWXOwPQ8sDy82vXkPwxGjAtxMIaZ2v1O3wqQXh9eYWbHzhM79CpJ5xopFVHDFSUacvyqO72S
	KJXxQM85A2i5/fksn4i9QQsZGQDf/4yt75GV58KNU3iRP6Z0B57lsi9UMXrjq856z0+6UsVF/Ed
	+oKaJctZL+T0rTZpekhVyWGioWcT9f5YgVkRxf/5Tah6wC4e2eOt1Q1h8y6EqO4muiyWY8/HlSx
	pY4mdl1IIwOrQk9ZVFGRFPNdgt/JTwN/O2MWyyxgk+ykxiPnZDj9jAc+kHXsdBFoQlabhS1QLL+
	GGuUOs4xsm73NYocJMMwhIBPeR+7ycAnOFy6LGQcjQERuuvfC+r2nriKmnHG6zAYM5wf8fmPF/q
	j2CY+SyFQd7xfWrOFdokz/S6ppbkdD8XH0jHcaarABVQgbzAXPXTzzrwN3n74n5VLH9AsK1HFn
X-Received: by 2002:a05:620a:648d:b0:914:db82:f791 with SMTP id af79cd13be357-9153dc29a52mr727746685a.49.1780179601868;
        Sat, 30 May 2026 15:20:01 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:20:01 -0700 (PDT)
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
Subject: [PATCH v4 11/13] selftests/liveupdate: Test session and file limit removal
Date: Sat, 30 May 2026 22:19:36 +0000
Message-ID: <20260530221938.115978-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4y7fut1zicudo4fujbminmeesp7rmnok
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB455100013
X-Rspam-User: 
X-HE-Tag: 1780179602-478499
X-HE-Meta: U2FsdGVkX1+wFbBCvPfTqjwdnvYK4LMOvOOPMnTEAmJIvtBj+GgWnd2qPenOjFImfQ94TzCJIVFa6tE12h1E7hGSEmFfqxWtgQJH1HUzlDK5pZI/VyxJT0mtBNdN2GCXCF/vm1FggSMVmoA8gG1Zlq0kNxFVCs3ko6ZadFs05vIVpHHmh2CmilCv/mlIRA06lA6k9PavNQx7zB5uRg8xcsLBJRnwTsOmqZBO1VMid4/pJjdeMxiMRmOF6PeENPdJc10phtHuLQZqWcaji0262mhk0BJh4rpsFwPvcoYJh9TwtLLXcnpxkyuKG0b3bRrYnA5if0GY7NURlfIOQblTzS3M9fzRQWQrQ4atMTYtmysdLDfMHRAF4X86apYJF3D+b5BplWU8NXMdcjyaSsPFF+HGe0DZxg+z5Jf9b8ZVmvWLnJ8h7u1kzIJGk01JGy64eSmVXK60RA7E1uyUgKzX/g0os6oBQm+icBVxECt5eQjoRAHv5mx4zTIrOAx8efz9ysbDVkhXvxrSHz8PRN/uEuY0GKmk01v+xq/h2xy4Lbg54NprcAFIkBAaB4x4NHQ1WhIT6IZabrBkC5yxoJPBLcucDTtDcEIwp17aJgspOtpQWpW5n9SDVNEu/T+YXqeobt8nflwwlJOnENQf1vyso19nqIDnNQyzLx/Br9HoaxBE07kkhBcWpyDdlW1Rh4gYKndaOXenj3PdaX0QoLNX+d+mdtSN16+CqdXBn+xrtqEHhjuo/vYuNNluDk1pu6vKwGMLbdqge3LGMERMvK/Dgrys3eU9KhCO9NPwTa65Ompo5EI6NE4i+EyxSNuz/OWkrOSRIrHyrYGYCuEM23MwXtw2Q2VkPw7N8KlYmQ291+HpJnqRvqu8dx3JL0pql6hHhIk+lbP89w0eiJgVSAsykGrK7iE8V/LjKWW+1Qxn/DmSDDYNKUaqaUkqUqd/EyvEWVYvMpqs9WAObXY+EDa
 R2gD4sbi
 d9wcB9j57O3VRjafu8DpaAhgi02V5LaUlJjm/rQ5xgH9wW+sVa2Ue/H6hpZmRjSUPleerrfW25v99YnRUxWNv6s3lauCZ/KYVaQ9rup9D0q5tC1D5pht6zZaAG45LiDgQsy/+BdBKkH31lhmXdYZhzoXZsdTW07aXvZOYMKs8QHMu34EGhezByo1C71FNZa7k3g5QEid8rJrDZmoTU5WQeM6JKip8kySfetQPH9X/WZp+k8YHInaAYlQazQ+HyioHsoVdvlgfkGgRb/9T58RxRVraHis7w1fKGMXYqGkN2WdXqkx14apRnYAQVW1Hg1MVHBrUkGraSq7f85xDYzCO69b9UsV4xbN4UWao
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


