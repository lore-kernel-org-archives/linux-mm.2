Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2BEF99C68
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0036B0143; Fri, 17 Apr 2026 16:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4056B0145; Fri, 17 Apr 2026 16:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F096B0146; Fri, 17 Apr 2026 16:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D320A6B0143
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:58:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 880EB8B2B0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:58:30 +0000 (UTC)
X-FDA: 84669261180.02.556C024
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB55518000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:58:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K5IBRajB;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRdHBRUkCqIVpBL949m004BbGluf8mLgg8lWb6+KmHA=;
	b=Y59KSyqfAA3XM6yCTrvCB75FBcS42eg3pPwKeSJis+NGVxslBsS6tifSQOVnpiJ98TiUYe
	4kCqOql9axPJrCy8ZjUm0HiJN/gRKrMVStrGs5hiIrO3HysFYpnXYp+4JP2du5hxVv7hhz
	hQd2pY9Hbtglm0s1lnWZggtSR/UJvzo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K5IBRajB;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776459508; a=rsa-sha256;
	cv=none;
	b=pUzlcV55VmOtzxVQ4WxcjUqDGRzcuVMKaY+pcJcJp/mNoVrbewZAIlEAdSmbxfBvriKdSF
	P2SxW8LeZyzXVGqC5A5I6WcmUJcOUUlwyMQ5npSmkiaNfpo2uYIwHzFNVGNVVPU110/F0B
	qQQAWnaJeSM4x96vJm9XppNUgbe+HVo=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d0deb7ad5so862847f8f.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776459507; x=1777064307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRdHBRUkCqIVpBL949m004BbGluf8mLgg8lWb6+KmHA=;
        b=K5IBRajBeSLz49bQtIXj27knUgBaXDt+adUUmD7llVBhOwlXsPCdrOiD/LUM00Q/14
         /J/++PUod4inKDDJbyRhAdMRcud1srCcfSscmdSKinVpV5HHyL774z8NgVwjSmjC0PUD
         /Nm+RXJWZntmc4+3VH318obdl59W8wQ1A3b13GXQuQNdfmki1X3EiDGw6QSCNeP11Yx2
         75Frjppoo071cialnzw/wBnDMBvwF230tLWfvB29Kp0jb1sBvigDXjaz8ixA2EDfqwiY
         cP4y5mmGvKVOzZIC6+T+wV37DTbVdgatzgiwa/fsUOX9ACuGaWHB6C/wieJq7I7jUHc5
         QfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459507; x=1777064307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CRdHBRUkCqIVpBL949m004BbGluf8mLgg8lWb6+KmHA=;
        b=TkUJSirX7Z5H1SZ2/rxKFeg89Vfb7Uc5b0yYsc3e7lr3Oizo4+60lImCBTA+KdwK/F
         TXutoOmo9/sa4nDodnSIrUzeJR6d+E55z0KFTLxSfRAoEmIxSa1Ku26qm1XlOkzJPwHE
         9PbWP0tvrWekY0uWTFKDk5N62ONXSNJv0dZkhjVqV5xuHqfR5kkdbz0rV1NuHKTN+z5r
         zuAoI1+Y8/OmfexiIt40FDvBH/5NmgdGdHT3pwLACCw/TYx+QRuImYcPSqqNj2FdVCYE
         LVPzC8RVj5ZH4l65HBDxTUHvzq+L4tu/Xe/iE1YDemDZAZnkmOBVmvPLp8pTFB4F56Fc
         VQ2Q==
X-Gm-Message-State: AOJu0YxJeaAmMjGt7I+H+okihXhtmKzA/Evbop8yq70JuGbB/DdSway5
	/roYhRaQYbDqWznseaYCO9MdSLkGAS4nHTTIxoybTkMfQHl/KEkxye6q
X-Gm-Gg: AeBDiet6wNbqRBUmXG/+BSwmFaIiBVgEovuh6L0P+YnKpf2G6LkXFCZZeqr/YV3eihO
	xBYap1jNEJkGTLmi2f4swrF3q4CNb9N7DmQEcMOA7I8PUdMc2uInjCwrQJJpzARR8BfXL0fjH67
	VHSVrBQMQg4Okz4y22ynGcrwAwDU49j9kj7JK3Q+gS/dD8Y5Uq6oQzQCrgXJoXS8vgJ2zZVP1Oq
	Il5KDRXf/bRDu+P2fhLg57ckmkaFzmGZ9w2NDPiQiAnPOariUqOeUVeUoSMtlVDPH9+jS433KWQ
	L5GHELiqXrY2PKJrbAR0Fy7DcpHFCRXHpjPGLvMjSQ8MCDX+qy7i1HLdUgtamRvnZD1sRR1iXWe
	vQlE6iS+AGz9SZ+Z/nC1z+7TFQw7ZUUlS1YuvaBT4Ss7d8vNCZCEayKWWwCtmFC+WKyuxtGj4rn
	fPNESajDuq1xpRjeKIoeRmXUZ53BSni0eAKpvQGWk=
X-Received: by 2002:a05:6000:4201:b0:43e:a72e:ec5a with SMTP id ffacd0b85a97d-43fe3dc62f3mr6566956f8f.20.1776459507049;
        Fri, 17 Apr 2026 13:58:27 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cb135asm7866514f8f.6.2026.04.17.13.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 13:58:26 -0700 (PDT)
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
Subject: [PATCH v4 2/2] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Fri, 17 Apr 2026 21:57:21 +0100
Message-ID: <20260417205810.1831923-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417205810.1831923-1-luca.boccassi@gmail.com>
References: <20260417205810.1831923-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB55518000A
X-Stat-Signature: bd4sgwtqbfceb6efp7hze9hr6ckn3w8p
X-Rspam-User: 
X-HE-Tag: 1776459508-727227
X-HE-Meta: U2FsdGVkX1/+CYpAmK8KrRYiyuP426i/ELsUgNDiFeY4ocimmEqw8wd9bFD4ubQlytqOVsdXijdgN447tkgKZrZgpGD/YU1sJpk3iRdzHh1EYOU7iKP+OP+e3QMomTmwh9z/9iJGbhacPQqSwqVTpPP3HwqDkvEdlDsN5tw5z8+nog+UBlao4LKbT4waaUPN4gHXQWv8D1aRPdIcO5YEQzbTqrss3XKBHqHaxPExZo4ptOC61J25GM3wURQSG38Q4VxHA666RJHiZMqS5+qDAUGHxgSz7FEBMYCIvdnrqXVBgEmVexL7VwjH+cqN3en9HtPgMR7XGqkex4CnXUeLH4e9d8jAwi8r4SJeoo/VM3T7Yx89xpyozlKA6+aDkJri9KI93TFJHVJfuie7rN1m0iYhnaOnNL3BxQfHYbNos1vWN35WCok2Rh/yLf+y7QOmyYwSm/Dp8Rg8ri1X+ps4i3FfKasVKuCV/g0hzftDHKDATwAms7I7g+E25qJF7OPSjhfxjV2W0ijL4JD81ipkOhV6C5QzFCouGozWNBWhBInCMPy7fGzPYkA2wBalkQse+RRPWK59hSpUocwLoCn+iuNHdtuNFbEAOqF1Z1QpqIVPdZFRS4JhyZUy2ywvwtArkH8w4C1Ow/iy11Yda8YZyMkYc2KZ1IkqbRS7dCYuaKjhfKZ8VJCt/tDV0fGVPWsnx6SNBrWDmi6XQiHHy1qq6Ctvk1MeDH3DmyUqrYxEkO3ZzbFGoUev8z6/y1Lw8crj25joIsaauX1n6fAw/FNN23EDR06qxW+2neIV/SeMg0n6zfJzgamASbEblhoH+L+nVBtstapXovo7pA0s87S6mnT3y2+WdwULMQfv3nz0tBZToqVauF2UjKFcGDHY54awMlq4RRhZO1ccWa4gqtMbAY3BIlsatD5vyxDNpbRMcyGSvRhS6kQTU48SZIXdcRn1ItoMVYHvEuVMflEJclN
 tB0VUN3B
 ov31cFjaTPIML2o9URPhvBH9EY0DOKAHF+i8I8ZNQdhtCMnxfy+9yeeJydoXlIfBWEtUUlTy4Zh5mgIDuNWlFcOopNQDYUT+I93DBkOAnndZReJqxyvOSriN4YeJvUycgoIoKS8SlgxZY8wMKKZtmctXSKPg+gy5xO506rtyBGtDJHCrGTMkosImU+hbzTDefoC5wa0gZT6/z2wGo6Qwjq0a90ZlPsRgrCDvmvwi7R9AOwTJg6qbZ13rTjC8f1Ml3PBD7SBqADcrrzLH6e/PAl4u8JU5KfxnFL+xBmJxug1oHpytgv+UlBaScU7n3JH2amlMnvgqFNvgrXgaKbdNaRbo5b8AbqzwQPaQFbRmHhm1ZdHrTuQZJyXPdp7mGH1U3I+wR7Y09MlnrFzTD6rplSimt1WjsZtqzC+6hX2fM5Elj3as5kg9M69jsnNkjWwIeIz6Kcgi9uwW8/uQLekgDbls727tbEkCPRCpo4KMIPFPWdhyC7zl6FfvsI1ArnVKS482QHPFzBBJdMA7hwmGZvMW+RKZ59yt258xl+431EBM9wllK1eWwoFpqser+NiGmkUwpNk0tXNQenkMxrZ5Uhz0SeFoCp6q+vxpmMcZPiQG4TAY=
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
---
v4: split test case in separate patch, reorder variable declarations

 .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index bdc1cedc4f944..3c21352f023a7 100644
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
@@ -416,4 +419,41 @@ TEST_F(liveupdate_device, get_session_name_max_length)
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


