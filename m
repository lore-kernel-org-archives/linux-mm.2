Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BEFF99C80
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 14:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62EF6B02BA; Sat, 18 Apr 2026 10:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBDC6B02BC; Sat, 18 Apr 2026 10:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C266B02BD; Sat, 18 Apr 2026 10:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8536B02BA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:11:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B4D6160553
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:31 +0000 (UTC)
X-FDA: 84671864382.22.7AAD92E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3F0AE4000A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gin3YgNi;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776521489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
	b=pGGsWPuJE+tAj8+s5k9pvV9BDJbi/MEZ4Pj6fvjj9YNm8wPq2EsTF+ig1xqS7uN5fyDzFN
	iUJr5RzeGLuqqnTfjEjhw3ok4wQekiqC822fPyKvIozYO6wSKOpE8hmOT5/tM+z7zjSH7K
	F7pi7UgSp0/ym6ZBrOe/I2swfh5wfCg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gin3YgNi;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776521489; a=rsa-sha256;
	cv=none;
	b=v921Dpk14nqzcUe6RVMxvBLq9V+VFXsJQ6tM0Th6AeS+eNY0aLlp++3aXR9F3TpEQOgzng
	d0MgZD/jHpJlpBCH27tbcOPNZqbAFN/y2SAmv5JxbZz2z7fTAj1MoWzRcSl7zqvzhWSzcQ
	/JOSJCf8lzrwo1pdBwBMtgqygDQRE9E=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so7667145e9.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776521488; x=1777126288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
        b=gin3YgNikZOQDVUQrXJKsBMmTrLbkHzDDk6+DfZ4j2taKTUOvRub0FPVKLG+inxg7M
         /zxrs61zT0BoYyIyHWKPnMD06BzAP2nFEgte7eycy1IGx9m97al8ymaUJoKvl8ZrXjBg
         fF10RPQHBIWGhhP3JJ23VDXFJyYX1rzvMxNiJEkNOamQkLrH2MbzoGWzZJeh83ckI9nu
         CvP+MFuadjOSPn0ZNufLeHKLkCs9qvnUAGomdwI/5dkI8CmxbaGuHZgI1z7xI/YMq7V8
         02L00Tuqc8cdQNMsJD3Bo0Pu+e9lJ70QaS8EyZ7rAA+pZnNYXLdmJwdMU//ViQKxgkBa
         HqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776521488; x=1777126288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
        b=MN+WCGEDYV4mSBkdS5YP1fvrgi4Mkuf3+cIYFTcJ+iwJ5OYHU3U7BRmSQ+i810X7NG
         wUOliW8+gxIV0EEjeFWlGE+pO76dpaADVpdu3KVWDNen/iflc7H6DN8y8fSIB3Rx+8hW
         G9Cs5kgiu3KO/SUtldCg3ud+uyxnHKeVBa9/FDgu/jHNxwX1XKn0s8q3pc0iE8j46VBj
         Snbcba4GyLQ5E2cumohNmKlZACLOuhHKZk2kldh9bDudajhgd7/koK3y03NAH0p7bjJ7
         CX4krTu/e8cE2BvbZ7otPk/PAd03gsQVKSm3+pVNScm3yPD03/8z78LOwuobJvI9C+N2
         LfPA==
X-Gm-Message-State: AOJu0YzQlQsOFWsC2vboLG36o3jW1ncpEJNQuqk9tuw7eRuqNnZsWAzE
	Y7dov8lINXjH9LK5vnS055K8SC6i/p+Pd1qNUuzu02senUCUfbSt8nep
X-Gm-Gg: AeBDiesvFtUZdhhZcP8a/+0FZ673AxWYyg/xbCurOsTukWOFyIwQYrDfUsNJTaSeScd
	H0UgkfJ9o8XtFIq5dBT0I5YaS2kRbiZrobHXBeiTEgwMOoTNtocChcqT3o/5tXlWhLJzQVZG71p
	cnNtGd+TNNCDJSeLUHhJ5eSNTmqJd/MjWrDdEWVRb8MoLJBbKDTNq09nczuiNzo+/kZc0zqsbA6
	wQQttpje850uT7YWw1OBHK127pcuAyMA2sB2rmWf31etcZyw6j7JnVBCaQwWwu5WgZC85UHYO/O
	3XaXYroQOmvJ4ZYkUXo2v0u61vRrTLy49CKZ4W2tkUy5aQ93J81wdNduOa8C5idMVwqXlDGYjvu
	/fFKVro359cHso9nAEKsLsJibIwD/CsVN6NW2RCxpdX83ia9jXedKhp+KwZU4E9s5EkhIN71q0I
	Ke7YXZOGRlfLfxWA6d7jB5fRbfH298GhHWw3yk7go=
X-Received: by 2002:a05:600c:c082:b0:488:b043:5efd with SMTP id 5b1f17b1804b1-488fb75f7a6mr76884295e9.13.1776521487683;
        Sat, 18 Apr 2026 07:11:27 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:4429:3762:47dc:91a3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb74c7dcsm43152365e9.4.2026.04.18.07.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:11:27 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v7 2/4] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Sat, 18 Apr 2026 15:09:38 +0100
Message-ID: <20260418141123.2193917-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418141123.2193917-1-luca.boccassi@gmail.com>
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zspxg4nx7dcdoiuqfsa4nuay1wsxki5s
X-Rspamd-Queue-Id: 3F0AE4000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776521488-412148
X-HE-Meta: U2FsdGVkX1+9mbhHgGtOS/Co6jR+JPS24T1ZaVJvdAKj9LBEfV+D+tbXObsVH+oOqd0xL1mVi5ggdkp5SLS52UWZCg1PRYLvFZc8dSr+AGupq8+RzRU6I4X7fkrndnM7uCPZw9gMRENMT7BCL8vhP+DZfVcjWm8anvMe0a9AsLXSgCZKMIUMDGs9RZfog0GG36eRqBTX/3UIVJTv5eN+nu21Q7IdWLqci369N9SjhfluzKXSUFujEuVxdNOGG4xuyM35Q9q5rdObNBN59l7b9zCEAILzNUWd7XJZaTX6u7kmySDpBepHlJ+4JIusX6tEa6q4XYlTlSqntKyrWeaXfY7QLsFsgrutO71GHUJykIjRZ9bI8xYYT/GfSCJtj/sQsvSLAFcCJBBN0bzwxbW/e8U4Hy1GqUMKnHjer4E5PkNgbeKXOO3PQd8SAjMkK2AYXpbKS9lfyxu693YXEoAS6ZBPvfkt9BTEC5atO7cRdZIYxEz7Cn4t0ru3TjJ3q4g/Ru/JkkN5nAkrk9R31XpdcLsudmDiRiL91mJtOM4SqZoqO+rAVDb93hAggdj7ObmN/gRFCuMkUUOvbAQapZJ6Twiz9g3XnugHlQRPlCb37UEqos8sodx84ZeSnyoJOQvGe/6HC/w3SU1xCK85D8ufxb3et2/qQ3HRu4JUKe1ZcNIMMbICwjJRGxbM5gqLbbk9PLaP0x6NIIkCmZsiKlVr6FpSVqdzGMGYpzXz8m5kZKEkjoeCiQCHp6CYRLCZYd+37Y0hl9Wvj8ed/Yd/M7cbgVXyQjlwoJssPUfzf2cXDqNDfkGKW408X72GDNzaUJOEnZk4Zy6wM80atEbbtu4L/xAM3L/35n0F4sMqe0gME4JQFb/3YEz1dqyyJtOYTDkzHbx1585DpE6V9Nfr9ut4fDz8gzYKn0ANgdnerq5pM0Ud0vmkLpDxF8/K9fACAk3gkP2eAfEYZ7xlsHi4cLB
 cQiIsmaz
 jMCTi5VjmYWYzHZAM3bwpU3iEIoOFLDpUCDKqoOUOB219TAsOQxmz+0mhZEmLNqM1Z5jC3lIIalVUX4MQU654EdNCK5h9liMupqdm6y9dIoxrlv8RRROK/oMSxSc7CGGK6q0xpAWcbAItMndUNdwn9VsgFOPJiaxhVOXZGsCut1auJyG/d//l/S/Mdrm3ebnqxTAk7I16SqIJnGAdsNg5335J6b3zx5scYLFayqauRponComjVHCFPYVjd2aDgHjBt2LdqkzDDd5jeLWYWCufxShHd2f3pfZDFUl8LfWckmVMRFZB0TZD473/fz3RrRW8vb/hPESV5TDjdRc42YN7hJdtKGcwOH0Hg/QSpZGg+lSuY5GLm8cTQg1P0sZl4nD2b4rXK6oGjBB7xT3PfQBRKt4PgwPFgWDdNUy1+wlJbbzG0v/u3s3rtRagqsooqL4oDCf4mblopk3803AWzBQff7R0giuzdzDMbY8Kbl58BXfp0jhJoFo+vZ3MuidVeydP7YK2hNmJGnYnx0ErPKj2zRjt8bNTZ06yUTZX/xaIGM3hEaxWiYV72hSW7JvAJf82MQw7O7hnJlYY8KFbugrDl+EvW4MtqU7ApDBidjunGNl9gc62QFebXuXwzFdYx3sPtRNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Verify that fstat works as expected after the switch from anon_inode
to the new magic number.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
v4: split test case in separate patch, reorder variable declarations
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts

 .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c2878e3d5ef9..d132b4685f76 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -22,9 +22,12 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
 #include <unistd.h>
 
 #include <linux/liveupdate.h>
+#include <linux/magic.h>
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
@@ -345,4 +348,41 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session fstat
+ *
+ * Verifies that fstatfs() on a session file descriptor reports the
+ * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
+ * inode numbers across different sessions (shared singleton inode).
+ */
+TEST_F(liveupdate_device, session_fstat)
+{
+	int session_fd1, session_fd2;
+	struct stat st1, st2;
+	struct statfs sfs;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "fstat-session-1");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "fstat-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	/* Verify the filesystem type is LUO_SESSION_MAGIC */
+	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
+	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
+
+	/* Verify both sessions share the same inode number */
+	ASSERT_EQ(fstat(session_fd1, &st1), 0);
+	ASSERT_EQ(fstat(session_fd2, &st2), 0);
+	EXPECT_EQ(st1.st_ino, st2.st_ino);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


