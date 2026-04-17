Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E7FF99C69
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 22:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F736B0151; Fri, 17 Apr 2026 18:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B526B0153; Fri, 17 Apr 2026 18:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB166B0154; Fri, 17 Apr 2026 18:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A89666B0151
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 18:08:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68790140196
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:42 +0000 (UTC)
X-FDA: 84669438084.22.F89B916
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8AE4A1C0006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SVaksVVc;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2i4D/SGjYjFaWAJjDug3MPpVtGFnh3UTQlFTWuy5SY8=;
	b=7qwlIt7FoxTdqKki5PO70VqOtCL6Z99FRyVl7vx6l2vK5OXLRZ5HDxgIkBKsH/LA7VotFD
	hEMbOb0/FS1uQcrwwZo1cjqss6jpNy3Ww2dkBk34MbP8cMOefNHbcvOlC1w07Q797kRgbF
	9XeEuKMiYPXabDAXwWiZu/EMnu4H9yE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776463720; a=rsa-sha256;
	cv=none;
	b=8SvTsR/Ty5+07PMPU6lyyLqIvwmHIZCCdX3D58TGdy2HnTPK1riVrJFqw2TsFEHbiA/iSr
	91W/DU5/Kto0X2Ig+sh3GafLQ/NRKTZB8LGz0qgIrX3JJMyKP/WKds+XIN7toP7it1RuOC
	8BP6DqMh7RQY8OR9/C8NAft334E7Tf8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SVaksVVc;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so17280475e9.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776463719; x=1777068519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2i4D/SGjYjFaWAJjDug3MPpVtGFnh3UTQlFTWuy5SY8=;
        b=SVaksVVcrSGtUOWvdWD1o0pywNdGSMpGXAOHTjaT/dBnD9Pn741uUZw3ptBUxG85ga
         hAo+jF740LmzyCwaHaAHzeNBgwOOiOaLyzDFkU7l5Q8H8acqhk7TTf+6NClyhTVEBS2A
         BURCor9QGOVhdO37nXkYzUiLfzp9AjAuczbokGgMDueHScVQay84VdGsgl3iTr/SgSI/
         c9imeoeiGvnG6Q/hn1W1bzP4plkFEN9a5BspCF3g9l4PDLbGDk2P/3QFqKsuBlSIixPw
         +NOFSr7y0C+o4dreP8jOa8ByGuKmcmtgpV87KfFf+9+q1N2punctZHGlFNZouIwV3vB5
         cPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776463719; x=1777068519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2i4D/SGjYjFaWAJjDug3MPpVtGFnh3UTQlFTWuy5SY8=;
        b=tJk8qIjKMuyn4KzB3Gbgn5IQ8OsSRDL4kmPTXN5E6zbV/wm17dfdiApVLVGQg2yQFS
         ZddAJ2a+g/ohSZBLk7mXIjs2t8HP/GHLfq8EHFvyzJBXqZ6B4DKNSiqnFmuxa33gEXT7
         SFyLouqwVXvVMeC+P3K44j1dYfx0hRTKqK2Ujv9jJIfMXpePlaykinA1KP5II28qMYmj
         jd2Dha4TjkdDS6EM4NvAo3ebM+PQb9qek3YitTKKIohk2DS9MF8DDBOeVcpMaSMGkDVS
         nJ2IqKrTkwZA2C0+mgxtRQ7w3Wxx+VrHUtTRxIktmp9i1T+7ZIux+7pgMcpEB4X3u2I0
         EOJg==
X-Gm-Message-State: AOJu0Yxh5zfnjCQSUay/myvTJZMUqhUpPRG3BVA/z2qCOL+pX03sI/E6
	NJoHsZ2XukwZDo6CjpIMNVlyC8SAI7eh4kvixTEpH4GrymaHrClxCk7F
X-Gm-Gg: AeBDieu17CEuIi1rp9GHjorBY5JkvdCjp8xeFHTJdj9G9qGpk39F+jE8rWlJXmjeTnI
	ftN/A1sbVAn/ztYqbEQnx+ySF+d9Zsy0QUFwh/X2qqja5u+/Aw16aP2vOwtOoTaaekBR4IhBEWN
	O1BUqAByGGsD1iJyI5xcSEIrMWQyJlF3SHbe+h9QVlF5YrLYzeNAZVkDUFceWP353Bt6H+4h9SI
	PcCoWP7ayXcVwqSM7t8ZsqMDnVql1eMRuw1MPMrTL3nfG3RHhB1lFMAc+E9iMyHhTJIZzF4d7FM
	bTjSVqKyNXOtrC93FURvSHKJblzeOzkxoylpYBGEXTo0jfeWX9jwKEuP9wN9cS+9ybZcHImjwcI
	XqL1KeFnyxZGNhQ5C625WiWjpD2wbwzzCbFHzUQ+bZ2iAqN/lQWx0UX3Xxy8dXiJiWarF6Q0vNT
	ajWu8F9gsKbiVTGQP0Q3SzMbiceB+pvNyamTjf1lo=
X-Received: by 2002:a05:600c:3546:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-488fb7880camr68489975e9.23.1776463718984;
        Fri, 17 Apr 2026 15:08:38 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc1c01c4sm142428545e9.9.2026.04.17.15.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 15:08:38 -0700 (PDT)
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
Subject: [PATCH v5 2/4] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Fri, 17 Apr 2026 23:05:43 +0100
Message-ID: <20260417220831.1934945-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417220831.1934945-1-luca.boccassi@gmail.com>
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8AE4A1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 5w53bxc6u79upgs848zdrz47xzfop8hd
X-Rspam-User: 
X-HE-Tag: 1776463720-723858
X-HE-Meta: U2FsdGVkX18msgFVklDjj9oM72PBEzbEjYCJ2uozljvsOy06zXiVuyMg/s+9hk1ZCu8E/HzxEo+D8S4901YavUKxjpTxLJvvC40EIs7MPlvpmk9s6tTOPpRjhV1zpiqOjEcdPIUSeOTdV/Sa0GmIeW4SJ/71T+MzD1kaLhpMeLOTON0ee3YQ/mU5B5a5aCK+VUnhLXwYJ2FHZB6WACREsRe7P1vsI2wuF/rdD7v4QLCbalv/pIgV/F9MLTlztg6U53WKyb9UgT164F4YB+EuSpHVXJ1GtetX2GO2NvTY3uFR3SaGbbumZKo8P2GvVpfN9p0zUicK/KjByOu84W5vWVFkoRUEAfgq0ElNIoZ1862UYkeOocdWRSSRVlAU1s8zJQnEoK8wJ0QxNEJtmR5yZkSOx7YxYkP860HqAztxNWwSuewXdxS1wB/DiV2B/1CT5QGbxpqUBkuV/rLCVlhJoNcmCnha3YK41tGnh0+4UVRJijl2CJ7SinIyce12p9ugFgRBDlolRvaKPR0l+YyNMUJNqAIE31jP8hNWEHnq0zZxPETHhEYRWDyvzlPaQ+fGgKEAK7ao41PStBRn8HxhGMGeeiNtN+taIbe9vfLKOKY7Qrxi8Of9hbv5n4cY7Z7YRssFGX2rP+CRos05RPWo1RTbXpEq+ki3TkVnGd+MTTQcJ0NWcMAkxgWux1G+G+ru3I60jgavTXC6dgtaso9LGJkkj2cJGLfVj0RL8S7luP/GDBz1qwsx9GYGjVQ8FQ6edrRnB+xyhkkUBjUdhbLs+Yq2/atMvWSpwnzfpdBVbptK8vnYKCLQPam/A7gQFECww1xsf2lOlZVVkKTL10MjqvZAG+9KL8sIdNHP55WFN9+5YtKr3dTyoENGQcAis5XhYwe4wdMqnrP4dIolSaMMGHhMwP/Se/D0B9W3gneuBCT5yzpL8wWAMAUma4V0lKFs+lsQLO6VdGHMMi7sWw0
 kWIc1bud
 l/RZGi25dcnIUjqtPXMbw7vKgHZzMJmOI0kTm/rfJyqADvyqpzMTwZeqCFGU5ij/PuWZdR7sKngQp865vGmVHkwqcYf/A0+nSCJ3i8SpcKH4ovUW/u7Gc2OeM01X5NsRkFKpTDPZ09o5wZ+FdTgTZe2ZFlSr0lZ5FqbMQaHjMhqAa3Gy6HNyPGKnNvPdBFIOZHMNpeMA7CkFFSZ7iaSKgnW/Rqr68v5UwbBCq5uVnxTI4MjnMgKp/8pDlTVSNXTj26veF99tmCtIZ7LDqjuU1mMYcKQmQA4kUKX2BDLzTGjT+LBAo8ZG+9SDrrWi4G1jn6lgLSPhPe+gvPcz9a3CSg1Xw4RiAoW3ovuJcZ4ol6WtQwqipv2Av/M1RAaUgU7hgp4YfT4oR2ffu0zm7fidQ7MVYDoRw0HJizRObi6WHkBMNOMuXZEAkK1EFRmBfm9iGvX+v20ezUuucP2FDbUnUIbS2/TQkfZ7p+KKNbr1Tkzhx+DIFi6OtH7xHjDGcQQfq83Z1pCum04F2QkebKUi8Ha3UbPYCFQexScpxOF0YiReuydYKPE54ImrQ8I4Z2M8cvStPUjbOU5anPGBz6dSbwhxO8wdjJ2SFy6mpq2iBbPnq/twAIExc7LnDSI6siypM0eSW
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
index c2878e3d5ef90..d132b4685f767 100644
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


