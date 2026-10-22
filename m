Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25574606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=N0IFdzR5
Received: by kanga.kvack.org (Postfix)
	id 923186B0A10; Thu, 22 Oct 2026 18:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882256B0A12; Thu, 22 Oct 2026 18:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BFDA6B0A13; Thu, 22 Oct 2026 18:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 574E86B0A10
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEFAAC02F8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:47 +0000 (UTC)
X-FDA: 85351758534.01.5EA351D
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C39840005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N0IFdzR5;
	spf=pass (imf11.hostedemail.com: domain of 3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709446;
	b=DtqkQMxuRK0VqC4Rd+/7yb6r2+WSr/QPOBnOqNU92KXC4ddHH4w95ICyLjTUclcEWLOmtH
	xzjQ4jTi+lj5Tymoqzcz02aqm/fec2AAT0u913huo94EcYZ87D+n8W+pbD/DKPwbGDX5bT
	mUZe03/Wy2QqcDzTzeJHJHn55DedneQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N0IFdzR5;
	spf=pass (imf11.hostedemail.com: domain of 3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hb6F/Gq2Qdu71NqEP5pvDxejRfCT+lDCwtB3sS5Hqw=;
	b=sXekC0b5htAFwZIw4rHi+Fp4mk3lY3bWcGB4dNmrBXQEY+kcdpCbrf7MwECF095piiXDLB
	ixloid0YurF5Ak5eyxUFSIbjKEfHUn/xscb2Yu5RLmWEEAPtCRWYMB48fgUMQaGHZuMt/l
	IN45N6zuSd3RK5A6hsV/u0Xf1SEuZPA=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3adbc9a47fbso262852a91.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709445; x=1793314245; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/hb6F/Gq2Qdu71NqEP5pvDxejRfCT+lDCwtB3sS5Hqw=;
        b=N0IFdzR5QcsQ6K4hC6lTO+RujerUcv8Sy/JqylDC3qhhv0pTdrEKzbW0p2mDEu4wbF
         gU4bVWJQz89rv0pIeytG6lj8e6/GLQhA9Mhj0ccPwD62NC9bIfwNwtRYtbY6hiP7rD7m
         rMtUPGc65zhSE1V1MWl8oxPg+KxcRl8gLv7eLPIMNCik/gByglD94IWmOv3J/UNzKNHL
         ZLUoFA7JOH0OWiSNCoxtiC7OJe+s3x4f+0FubBIKBYzrtYb5+tTd+6HIV2gpToq1iHp9
         qCoK7NDCCmWMdhnDkrJUILHJtkr0vRPRp0MjTPT+tQi9HrSSop59rGtKzRh0vcsGETW+
         L4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709445; x=1793314245;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/hb6F/Gq2Qdu71NqEP5pvDxejRfCT+lDCwtB3sS5Hqw=;
        b=khoi+7xFS3OWgFIVUtKMduZAfeH4sixfhMUHQ5StnuqTKCsyBn6jw4mcitQp5zDHm0
         pvbrQ+vA9u4w9SuL0P815s6zATrifVnDKBhVpVzSZLA+W8p8qd42HSOkI6n7QMY2J2fA
         P7ZTkEbzcnNJgtAvCB8GXBA5ikTyv1EiiiDdwEM4T0y6GIzA6e6jM8f4Mxh0DJxKH3m+
         zdONuIN1fqbhJqqX5X8TwFY1A1m+Hzjp0mxtz7RIE8jvp9lFyCcFFriwcPHKeKGzTF4C
         6csUqsCvaaIhkrQpnutQ/QZngKBgyaO+cJDNyoDQ6CQnjAr9ZDmn34bE0Wc7TqRaPmjn
         nOMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAfP5FKZbqE7VMFTGKBhW9Ycyoa7QkUs8a6d9y7EYA0JXR1ZexEz5DXpuax1kBd5w9gyZQEtl4mQ==@kvack.org
X-Gm-Message-State: AFq9FYLU/hsUyv1LA51oAohb352Fa5dvlN+8j5uudE6C2ligJqmUq79I
	WUaHOkleY/Ofnjr9/pirqw/pbj+Weujyw03UtKCEmans+IMtSlS6ZMOCrDLwTmldoz15GzFXxgC
	arPrp9ccsiu9DYQ==
X-Received: from pgbm22-n2.prod.google.com ([2002:a05:6a02:6196:20b0:cd6:a6ae:1ba0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:538f:b0:3ac:97bc:4c98 with SMTP id 98e67ed59e1d1-3adce7e67bcmr237048a91.64.1792709440118;
 Thu, 22 Oct 2026 15:50:40 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:27 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-3-dmatlack@google.com>
Subject: [PATCH v2 02/10] selftests: liveupdate: Add tests for preserve and
 retrieve user argument
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: srpxsas4kthpgifms6a1shmpd83fekar
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C39840005
X-Rspam-User: 
X-HE-Tag: 1792709445-299682
X-HE-Meta: U2FsdGVkX187O1tQrvrsbI3x1pHh7A2IaXK0LX6nVOLTPsLQ8lYXHUHEfXktpuPrIRpoYsJ0ZpGGj1mEMjjjd1XwQ4N855m8sTgw1N8OcIOjEwPxm85f8a7afTZF95Q7ToC8beonT3fo4h81Ohw0+In24CAg3L0vF7GnhZWNQV9rA/McEsuh+UrNp8gU47KNjm65SiEkkhvCCwQmeGh7uyqSeic3oTVhrzk3rz/yNDggWyaTLOSdEbAlwCafQnxVUFnQItBtZy/GG68qslUX87tnqqpMhkX4Zfny1CW0qpAtO72mGhT+EizU1C0ekdujsRUfEx6U3t7HYoECWzS7EorFezKBwZIsC2PQUBnskVCkQcAsGsIfAms1/vqQy2qDs+MLDR04ofjIQ82XzcYfJ11zJfjpdfr5XF3NKozan2cYAfThJhxpcjvNdaHnlGLWoCPuG/TS7O0St3KMof6YeerKRYPa0FOlCuTzGdoxdztHV+V2dVEpRRj3yYQsiwrbmDP/nERGI6qRpVjxUCN1Q9gOVwF+P1LvNmrvuFeXMIBWpV7waP17hD90mnw/lw7yjlHTo8eORxWmsC+1N57QtzQsS6i7UWS1bMzooPO5iqnFqfOrgx+tAiqNlcU9JJtVx0Hjytga/MRtqC/qizKpXjmKBA/8eTZ+A07M4M0j/d2iVXk0YBUC7Fwh/dN0lce2GOLrnWWoBsb/UJfaroewDr7tGrdTehqXY74IrEWkmRe1dVoUzyhhc6UwNTcqcse/BW7oanIPaaDTDaqYwIe7SgjhZ6UOh0lyucINMmAU8L1HFI9SsGy1orCYesqWcePjjHSlDX7dPZRTKZTVDQmtq+iKb+iv2sbFfYsJ2FxgeOwhao2dDzwHb5AiAgOt8lrBScc979xi63ykxfDm1mOYueOVftuHcgq+7CkzskE+AXO43MzTAfmVDjDj5YjGqt2H1DSDC58Ee5PEGrK3dEE
 r/OBq1Mk
 r20JhygJXz0QBmNLQBnKABu+eGourBRn3ofo/6llfzAEARh6ZxmavRW5LwfhNvBmdfkVI86BeLBI3reZGrCrMLpfhvO0VAkAKorAX1za8+lqxz/e5vJthp20bNX4qeHQo+SQ5yx8S4TmxX+4JPsKyHZuISVCyoCVhQQXQAx+zjblypycrh6DPnn0Pxlz7MepTASAMGq38+CBIuV4aWjBuRwY+xZgRPQTDtS4Dym1bI+ReEL/UYNfjSS9hgPDP2EX+GvgOk8iQN2kltMoa4X/qa43sK986fijvV9r04PIA2X7K1MXVp3aZZWzKSmiD3toGpKdcF1n1xNQ30WrP+qWt8fTHYCyu+3h8bIQmzUnbiA11KO4m/AdkHLexbjnzcBBy5RFRwJxQcYe+QGXzJiHgwHCVKputNVL6b7cUd7jPgwTLmQzu+MpB7s6HbW4ZbyRT3L/yBwWlln7oXUT1fvgJx1YIJrPgFMzhfrFS/4KYL4e9qzEzdITYA6UMDG1zKBZ5MRgTTL7a/0bNcyIgnJEqwKj8ekRBrP1ogR4diRaCJNEsMFkkb0Ak4m5i0XkmKqPQ9rllDLDUzuuE7jhFBq/mxmLAbmFIizGwmoVszdH7NLieYIbgLI+Vob1iIUN+buwhajbTtF6eWIoWiZlGn4YNI/JANw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
a handler-specific argument.

Add a preserve_memfd_with_arg test case to verify that memfd
preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
explicit zero argument, and remains compatible with callers passing the
legacy struct size up to the token field.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 17 ++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 44 +++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..cd1d843a0d3d 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -29,7 +29,10 @@ int luo_get_session_name(int session_fd, char *name, size_t name_len);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..db7a90b002cb 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -79,12 +79,14 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
-int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg)
 {
 	struct liveupdate_session_preserve_fd arg = {
 		.size = sizeof(arg),
 		.fd = fd,
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
@@ -93,11 +95,17 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
-int luo_session_retrieve_fd(int session_fd, __u64 token)
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	return luo_session_preserve_fd_arg(session_fd, fd, token, 0);
+}
+
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg)
 {
 	struct liveupdate_session_retrieve_fd arg = {
 		.size = sizeof(arg),
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
@@ -106,6 +114,11 @@ int luo_session_retrieve_fd(int session_fd, __u64 token)
 	return arg.fd;
 }
 
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token, 0);
+}
+
 /* Helper function to get a session name via ioctl. */
 int luo_get_session_name(int session_fd, char *name, size_t name_len)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..4c4272167635 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -20,6 +20,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
@@ -530,4 +531,47 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Preserve MemFD with User Argument
+ *
+ * Verifies that passing a non-zero user argument to memfd preservation fails
+ * with -EOPNOTSUPP, while passing a zero argument or using the minimum struct
+ * size without the arg field succeeds.
+ */
+TEST_F(liveupdate_device, preserve_memfd_with_arg)
+{
+	struct liveupdate_session_preserve_fd min_arg = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "preserve-arg-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("arg-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+
+	/* Non-zero arg is not supported by memfd handler */
+	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
+		  -EOPNOTSUPP);
+
+	/* Legacy struct size (up to token) should zero-fill arg and succeed */
+	min_arg.size = offsetof(struct liveupdate_session_preserve_fd, arg);
+	min_arg.fd = mem_fd1;
+	min_arg.token = 0x1111;
+	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), 0);
+
+	/* Explicit zero arg with full struct size should also succeed */
+	mem_fd2 = memfd_create("arg-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	ASSERT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd2, 0x2222, 0), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0.257.gf7497c7d27-goog


