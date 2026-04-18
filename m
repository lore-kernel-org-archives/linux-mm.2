Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87074F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6CA6B02A6; Sat, 18 Apr 2026 07:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87B06B02A9; Sat, 18 Apr 2026 07:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D5D6B02A6; Sat, 18 Apr 2026 07:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD3FD6B02A6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:40:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 599548BA46
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:04 +0000 (UTC)
X-FDA: 84671482728.28.BA2E248
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 68E7EA000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZN9mF5wS;
	spf=pass (imf15.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776512402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
	b=D+sK9SpRxMeXRjk6OTNJ5yQ10L+fa6cC0d7AxWWfWbBquhvZO4Nht4w2exHCV9YAooBtsY
	3mzD8YiDCw0XJOeT22wMNA7EC9IC5xNYgpZHdcpRDjyLg0DvwHgPYX1bu2gVywaxS8deUp
	8wAAaB3E1V0mNOnpJ4KkjFcUQmsxAkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776512402; a=rsa-sha256;
	cv=none;
	b=ONmasr5CsOWN6YOktIDgH5xjNIt250uOc5Bm54S6+uhA2pxnYk68TbbZD4wLeHKK/W67n3
	wIvzUx7H9zxPka8IJzqRpDsz0BaLcUAeMU0o3PxEAu4h5FKimoPmHo79Kk/zgr9Vp1DFjd
	5vrF+3RREk+WIbjhWCTe+IpGMpW/KfA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZN9mF5wS;
	spf=pass (imf15.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d70c30767so1446838f8f.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776512401; x=1777117201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
        b=ZN9mF5wSIxh6QUnvMOUnCpwIy7sLQCDDxjo4/NOxCfYot04sJuiX61t9za75IDNccl
         qDeZLL70FLNGCtW+5u9WHBx45BR5Pw+8C4TAXLUG0oqrmRkS9mpZ9kOQi52YxHkSajN1
         xHKeKob3f+I+z40MAQ188vmJY8e7/ESI+wvYoN16Zwz2jc2dBI8uV2xVx5ZtYWr18v0A
         HfPybtEOWluxS1Zy6Q2NXgZgrX4InFtU1W9oKhOLDvvMDkKgJw+SH4OkJD5reNqFeotA
         h1Ruer81RzytvOe8pc4QM2LaZPfV96/Qyo5/7EBlPB7/MN4XXjQXmgZr5pscOfqzE9q6
         nusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776512401; x=1777117201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nU6HvtcNtHHWFQt+EraQcL0A++PbqBB9SJ1Rgi6YBJE=;
        b=IoomwaO+jEMYu7Co0mFd/RWCOdNHcF9OfImDGxHHrV/XtFvTI1n4loYBMSEBEh9Eno
         ksZ1RdMYaaocf7uJVdNsojf9Czi8p5xyJZsj6o1Koj+7O6axrckqk3xqQzLROAEQ0ySr
         RvVtqfMvkbmS3z3H0uJmWrT4Rx8OC0tyxcjXNH49DsJ3DSMtGxuSRKNAlDU107RhJLIn
         2f1kEEyLCpwmB3Jb+4kqz9JRVCpVrseq4PUp1sxXdvTLp7GMDG/IK61PDPBAcUi56jEF
         CvuavAmPVr5NWS6h1dNkGP0VNOgfzwR6ooxyeJzZgVryxVDXwzaOR7aY6mdHfgKaCxBg
         i/Ng==
X-Gm-Message-State: AOJu0YyT8kFw2oYJjy7+5lrf/1/p8tYA8+vN7xS0xr3QIOdhnps22f31
	FVi+p7GFE4z+g8invVs5IuVj9Qvl84C8eKm9A9Sm70lrik1l4GYpj+dtauRqVQ==
X-Gm-Gg: AeBDies9SPF54lU4wIRndaOroSxJdiRNMWkgZoJCScSYR6A2gQt9/eTmuzL2Nn2sL3k
	IDLMVCqFvZmDiiOPFzSfsU8ulTfixzDfXPjAU1S7JBUoJ50U/WiLabpXGhtCTJskK9y4epZfamj
	zQhvmW2H5F3cNTk3jjpAlvesi9fgKnZs/pTcbggiiX/AtKVYYKE/geZmn4HflsP/IsEobNN8Jxc
	ZsFIn3YQR97L4XCdgk2jwqN2T/+h7Xbaso0VAqKb6lWxQNMAPx46JkLgL7jeZIGQ2KTPTXNtvMJ
	k5OXB1N/FmgR4hBORrNSzTOROTawuXo+cc+voPPriY1+HuDfcDeHJ9CwLMENFfc9iZ3MeyEwXF4
	8g6FA/K5EGKhhmv64YwmVbIOFxmhaKa+05EsqpNfO9XpiZAuwWhPTpHSTZlfiKjgz+3lzdwfVn1
	yU10aImttjOUDbXUPVPSwjHtgCb6vevIc9osZoVXk=
X-Received: by 2002:a5d:6f14:0:b0:43d:7086:b03 with SMTP id ffacd0b85a97d-43fe4032b76mr8292587f8f.1.1776512400771;
        Sat, 18 Apr 2026 04:40:00 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:3ab1:89ce:8d93:ae6c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e59f97sm13278846f8f.37.2026.04.18.04.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 04:40:00 -0700 (PDT)
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
Subject: [PATCH v6 2/4] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Sat, 18 Apr 2026 12:38:39 +0100
Message-ID: <20260418113956.2146648-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418113956.2146648-1-luca.boccassi@gmail.com>
References: <20260418113956.2146648-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s5hpocr4c8gs5yefzabtj18nusw4zycn
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68E7EA000F
X-Rspam-User: 
X-HE-Tag: 1776512402-341623
X-HE-Meta: U2FsdGVkX18Ga1qCP1VAI/iLwGou1kT9fMRYSlSHdN9sVrmusvT27fyxfyMQY93NCKSvORNJZ9qQRwU/75ezwJWlPE3//Swu37w9anpseIjWIuEF3PfAXRD9niSqdhgEhi1zjS4cSNei51K3atUInjZNScWJdnTnu1Oq26WJz6hy2ej+R5FQPNHsmLveAx5Q/0RmAGZcL4/OOvL9/S3OTrqxX7c7F5u2AhgPWe3VCetzbZeetHftoFtjxAGI7oR3p3rxOSRUXratI4WlVxYx9OizkDVxgIy4mTyqm/Ku9DqPRR0icDeHNTe3MQWVixWgSsAiCWmPlxzxr+qu8OuatHA4fuEIgscvaj6HIiK/cCs6U1OJbzByrM1NlalrSlV/kFZDoGLdgZs0C5cgAW2iJ54BUmZADw8TOvx5tADpsWw5LtT9+a/EGaMqgBHTusphgWrRvmrX7yTuQnI1znVTBB739I/4jF+pp9oxmtzCn40Rge03db+LX2N4waGSYmrsF2srPiYUFKA2jZbM5F8ZavmElNjHDf38rr1l07dPz+pyc/60WDrtC9etCrra9c/woxUj0kLZvQEh4wzSFLSukxBa8W/ssDoicwWPbm5+3rIG/JA4Mr5mhgMQBj2OxOrc7k429NBvdFXLkQk5q4IvlzrTLRU+V5t0UwBBrQDDGBGmgo6lOFImRyBGJ0ZMYA1gJOl0m42J4kIJ/eQlt3vCJ8thZTgBgMU7U/s5ntjKrTX36/c///w8+WMZsju8arzDav8MCA8AoP5Hja4gNddJ3HxKkgUt4lqryTYhLZtSOVM8TfmjXqlhYcnezO13IZk7FADM+adrMz3NOO3YK+0+uVqnbTFLFH3IMEx67OuVrDbgOQX8R/cf4VYM5MInRnMtOH6RmoiqFwzSD4gD+bM6YlZu6uJZ2bhHBtvRbKvCFn1r5mzrLz/TKMAf2sWSGVoQSKv7K3RU9SnxfTPMrKM
 /l/2kM/L
 HKtT/Jp/tWB5PYgMhxXVV/hmhB2thP47FBuS3WbHvYKB+CXxv+tMsrHTUGle8CksBCA5Sd8H/JzGXf4CvvX+Vy8CqngrxzikZ7oJnObhghcoibOt1VXkYqmS83TCe6RCFwAPuQWP1njR+c+C5gzWC255ZGRfYserdp3H8Aoi0cZKCJlQWz2rlrwbtFWW7uAGuqDYJTjwnpE/e8fIcEZ5xr1BcmBMAY24FqS6gHd066jytZlGkBtwlVR+r5k9JTW7JU+aX4o33mwrYNCKYbTXbMo2I9wcuBPKxLviXrzN/rEiGHUCRc9PNSfoNrc7pIwLglBoSouPCz6mApRkER8yL4peMUwczbRFAxfWX5oYl4m2TgbPAtanYoxVJIaovayUQ209nt6MowiC2EMnhUQICfYAjI8aeaHgawDFw1E+x+mJAh0s9OtWh/4uLzzKh2d3nTxXotJdOU/1a6t91EXqf6DyHMm/3DGK0epcQVPaecw0Ee/RE5BEoew1HUr8xWgsMTs8xRqk37UjwI4pGdxQD5Ccg6L5SvWxVACUmiTwSQgjhb6vZXuS4sA/eMeVAJLHR5Q1Moioh9fwOZWnqf+LEXz5ii2eKxRfyX8qjN1Auh4rqh7+JnWT/nHqTOVHLF64IhKW5
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


