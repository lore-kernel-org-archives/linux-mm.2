Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B25F99C91
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0776B02D0; Sat, 18 Apr 2026 12:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CAD6B02D2; Sat, 18 Apr 2026 12:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AD46B02D3; Sat, 18 Apr 2026 12:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6265B6B02D0
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 257B28BDCF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:16 +0000 (UTC)
X-FDA: 84672224112.23.73F654C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 512C440005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cyXsxJji;
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530054; a=rsa-sha256;
	cv=none;
	b=W0f07XYwHkecjSiHvX98Dl0oWKkk9UMgCu+XCKZX01QlN8fVL5LhGuDlsOFZiyaZOk24po
	cylTev176nqPmyZFzA6mT6GNrX/0XwVy5tT4JwbG1bHwdzFIbkGR9RORvjzqF5IsbAnKF8
	U8mGi6kmJ1EiS5lG6Frq5VMdcAQ+0ns=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cyXsxJji;
	spf=pass (imf07.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
	b=BBGhw30etqJGOdDrpRIHn0ba1Hrrh/Aa9EZyEmZGR8xqssbZgmPcJKwuVFNFZ3RJQOAvVt
	x1KiG/nTcm7wQUKFZFyE1i3vPZP6pgnk+yNKYaP7ZXyBYfmALSS3qnbunK2CbQO0WnRb/j
	IV4G6ZYRiN+qjQzLb58x5+lx5xM2H1I=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d73422431so1335084f8f.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530053; x=1777134853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
        b=cyXsxJjisiQw4uYfH8K1OzclB3iQK+U5bZ7uaB2fugLcjnWalS6h/ZxFwTgcZ1X+9/
         HlUxgOhwa5/q1r9UGKXo4jKx2Exsldyyz2GA61dK14cJTqcWBF3wx/J8dXt5qBszJXfZ
         aw6fn1I1VzNGQHoG74f/fH2DlWO3csDSFeWPluNxN3qJtMLrWgqT5hV8EOuCXelaD5pS
         y4OrNhV9QqEybsm+rhb4a4B8an/BGnx/yenD7dwIJwzB+bQNCxyKCSnbDzs/THkJo/p+
         tPzdhE41y0ACBqYlec7lsGnbf6gIiLE6Ug3xZBk4e0MbabsTN1Hv5O4SOpLgcuYspa5K
         Ltvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530053; x=1777134853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
        b=RrfLIJdPZtQu+wIWz4x9gjHZ7srtRQIt0AZsRa5sgc2WWBPbuNvx/K19sbUuHFl9gq
         JimMNKDrPYpKxMvrDWo9aw6R+Pe0qvi+lZVj8Fk/3gV3uP1SSvjRisQjvowDaqowIfDG
         qNLo+8vvFuBUen7z4CBj+YL8U/f2UTw877Mc1TPV4rR5ZwWI4aaspTI6SqgIqrQDyuNj
         2Wdbmk8+ZzUMbDQqbAbFrbjbGUQyxjdncVgE7C81azi3hzdw/t0qWvwdoDhtm9ZXkduE
         oMi3Mph4UX7O9JAa8/Y8SQdsMTg9g23A6whhN9oYGOMwQd0jG7VPoE0sLwYr4tyFToKU
         AEWA==
X-Gm-Message-State: AOJu0YzrCKgr2gpnHpfwDuV1gKIModbR/dOQ9Jop09eKuPSpUPYbcZky
	6N6MLvsERKmMElk5baTBvDGfUPt21p6PHaHAF01q3tsw9iPzPYzAwiZ8simjzQ==
X-Gm-Gg: AeBDieve3Y0mkMBaTl2aaUYiHsE9fLnT6BileCedON52k8KJ8pvb9oLlrbZ+I1XruEr
	uCDZ3ga/s/CyPEewUnB2Ra2XgIaoXEGZgCqaRG8DCHcE/BVl34izRvCC2j7jgEEq4MgzHO1wFmP
	VZEzPxsDNuB02MyUapawbuoXziWcTMaq9sj9zmBtqaykDJP2i1uCKZDKqhbhBZYshVFiWx0RDKo
	GEVEvttqeTJBoI4OyotSYDYPiuIiNlHSrtsoRE7EzSFvnFTDMWjlG9wysz5sbSeE8/1loHd9xgp
	Wje/XqqTJy0Ev5i+OvJOmPJ2MMY3Lg09QgBm5WMJmXp8l5AHChzcFwAAimOPBACejH/7SMo2THd
	ZizXyALFjUXXExOSaB1uY+aUaXsqRvI2ORBjEWhdDv5AaV4lGn7xZPKW6AeWrb9fqXcDIbSIeUi
	xyTX93X4JCWRov3D4+19e6uTY4oDKcxT30IfeADnBtrdiB3G1izQ==
X-Received: by 2002:a05:6000:4283:b0:43d:7ea1:fb53 with SMTP id ffacd0b85a97d-43fe3e15f7emr11405373f8f.33.1776530052685;
        Sat, 18 Apr 2026 09:34:12 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e46898sm14205702f8f.27.2026.04.18.09.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:12 -0700 (PDT)
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
Subject: [PATCH v8 4/6] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Sat, 18 Apr 2026 17:28:21 +0100
Message-ID: <20260418163358.2304490-5-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 512C440005
X-Stat-Signature: nmaqn8qfbzurms6pu13yj8gq9uoeaypw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776530054-172284
X-HE-Meta: U2FsdGVkX1+8IT9c8hlei8XLZsiGkj9Ab3fUIgTpbZ3zQBVJPO3Z86wCrPyG9RN2JQzEst4xlALm5ORJTFfx6ALkxuWZblMjYgvwDZ8yVrD9GBROfmy8v5qW2I7W40cm9DUEk93INk4dvxTc+iFPmrJYXR9yE/2ZDDVgoekQP//NEgb/67wqiVq7ItXiNZr2pR03kFe66CZYjd1y1c6oBGi0ZuJeZwKYx1L+LFkA/dCHxCuLm4v10ROPgJn5KbkATR/i2gTNo841kG1ZDgxtqjdt+5I+fOYBZWj+lMmePOyGMCv3GArqkUI6kdc+DnTERpXTS598amYYdRNeCy2J/U0I8pqJgxQFq8FMiWRn2kWvOyv/SpKoXiVrVs1lbk3CI++BbPPgu+rKWYHv2uxivDvRRQrygRRvO0xKCO4BaeqxsP9Fd25DStb41wER4H5OMOOQs7usBUuDddWg8xhpSVXBzzfUAFCFHDTrY/WSI9Z24zAFNbF6QPGn0iKILkrN1S23rytUvvebO91EXJiDbTz+sVEyUtRNIfPasdc7KlO7Ev/fSiRrv6LTMMi5qsXKUdwivDQpbHRCuqvPmtk7JCygeNbNT42SZ74Jfm/4plVfLSYvGMDrcux64HBsjEPh2KToLDGOfjOagWHNVSRqSljc+yn+vKvuu4djGJUEdH8TReFXlPTaiJV6F5wKPKNOIsVcc2Q+lYHua+O4Gz+QYWeIZa+wKlk5AoWFZPnC/NqDQwBOG07snB+C/4A4pnD3YDAJb4utwOcpAFnhQ35RNvz7Od0UcCpZmvnqKSOp6Wnvy3cCDLb+o586MX+8N9+qCy0EQp/FqqKYfX78AJC/tBdOgYev4FnLnTLWt6LspWnvqQwcTHOxFeUhbMM0i1iqglhI2uUJgK5IyVxhuRMLjoQYqMmqBKBqPoaRKARJvC8IfuVe55u4252ndzoRcuYUe3oyoy4geMWFUwl9Ka/
 zxvdQk8/
 0MHz6iGoW7vQDSbQjFetkoR09sQw5nGz1zO1HUaa6GydiOjSKQ47POI2XGW5n8RSkQcQgTTrTkDfPlAFRCLL3d46A4JnhA75ZbbBzkxJcYB2E5KfMSs2BFA531k7el5xvlWHm/PfqLy2KSv1lsO3ijw12dzgDmxl6gMcfwaYuitZS9LJRxu9tpZOkfoCr90Qb9J7P+IW6m6D0thZTeNzZc8E231Oma97yePipnOQLVz7/FKanGM148AL/HBmFK/hIPDTz3xjZuzVCziyAdWu7+Szybfz7iV3b4qJKQI78Js29mTcLJ91vAXG4PQrAv1zlm1INGk/RI52ckuOMEQ0rcD86SOkRboddzjR8p1l8gitF0XOYgtW5Wh29w12WdybWwWFNgJegQ7erL/NAJ+Ma1LqUmDUpc7yXTi2TIUaSrbnFLJbpw98YXzGbpNbYg276XqnmFn5yso9hfYzDS99xxHbpew1ECsyIeVd3aLbyQirwGNfo9AM6bl/aZO5tBayF2Pqx+Gd9LS0Vek9n2T9ugxruxYiadKIK4YYXJfWmNHoQZkuWSWINTFgUtggjNQw9mlPjksBfytGus0r+6qOzwKX/dLPAo4r+IUbFADXImZDM08z5bJhhT8xAWLXGVLJld7kq
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
 .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index f0a8e600c154..5e99af0cc6e9 100644
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
@@ -387,4 +390,41 @@ TEST_F(liveupdate_device, create_session_empty_name)
 	EXPECT_EQ(session_fd, -EINVAL);
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


