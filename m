Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7B2F483FB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B42D6B008A; Mon, 23 Mar 2026 16:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D776B008C; Mon, 23 Mar 2026 16:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579F46B0092; Mon, 23 Mar 2026 16:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8446B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:31:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14DA01A0CFE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:52 +0000 (UTC)
X-FDA: 84578474064.19.5C16877
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45813C0003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XCmQLkfI;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
	b=HwLvut5ym/y0+qKGSnHntWOw1baAIDcLQqu/zOQA3Uh0crQgO0NRo3krPimyeWUvHRPIAn
	DomrIR3GrGiKOWeiHnDef7f9eYEg4Evc8i/fQjRqtUseH5vm/EPzXsnjtx6d2Ok6IHsjcF
	MkwsAuSMd4/bG1DJYYGQB3Y/pOGskkY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XCmQLkfI;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774297910; a=rsa-sha256;
	cv=none;
	b=tBRTKJQhlBz67W2CrPBu2Ma7ULphnjdtlsmCn3WbCDCCVWm7lMMld1fjkx4Av8kSuF/w/r
	6ybyLkdTt4H8R+2WMkkLPgH7Hls9wjyihW8XmlHC42OBhIgahT3ginq8cbvZG7AsVv+7VG
	vLj/3bBQ4qlFajF+IlvIE4HnaPHBEtI=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cfc40e4158so60819885a.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774297909; x=1774902709; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
        b=XCmQLkfIaQoFSQbIYPzkM161VYbkW/lAxBKGULBeeG4s5ak5Y3DzwBY57s7HvQixvi
         KZIwuGkrImgXsdVru0shJjYIbDIlDUZ6YoazMNAO/eOgqQo6H8yXGplU3Qra6SpozAbA
         pi/HYcRnN+5+EaeuMR1BPg+SyZg6jjxIXwjtVwtgvQ+q+/HHKvBILxxyu5f/cWa1RYD0
         fnWXaLxfgWwvLB1w2InOG8aCQVA3qWdl11MvvLW34oXmAumoXi1Y7KMH9Z3woi187sjK
         3aqRAJenI+Zxt+xAJ6HmrK7GntAVkKXRYT/suUXjG4Fc3BTds30mmdLQxwMZAOhiXaCB
         8mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774297909; x=1774902709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
        b=TXr8ELwGn+Zzvg46bslx1Ar3vmGKNJeAao8HF4wXc9C/YzpguMMoc9ZoWafko8ZDkv
         z68vRqGyQ75wkzrTr7bV9vrC+fdAizs/p4i2BDBaIw+u/nZp1qV5sNrNa70nx1TpAiIq
         uqjTvc6f4ur9pmBQ96x8HksUKYoeaIjUw/OJoYSa7nzf3/EEql6N+r5mW8K0rgF87K2h
         IfwU3TrG0HdngPY0Z2PVFiGyuh/GdGhitkwrwG79ZzLXN8saEzQ9PuFl7v7lR7C9W1Je
         MKKQArYQ2IFLaaqjVXdK/4VN2xD4w42XAdE6SuIl2f4/fc4Sx0acyfY0noHQTrUGwMvA
         UPpg==
X-Forwarded-Encrypted: i=1; AJvYcCXJl3XF3z75t6CC6JkhboxiwFAi9dCIyXipGwUFAIUhQ3qL4QAzq6cTudBC4hedSAS7/412YpPJKQ==@kvack.org
X-Gm-Message-State: AOJu0YzRQHc1yF7Bv8nIXQ33qcYa1F+WsuyT0NLaTWpT0npISz00f/BP
	JWDqu5DtANlt7HH6ZAyHjtrrc6ZRRHD2hDK4aCWJFopRC6CpJSoOcWzbqPDsn7PSY9c=
X-Gm-Gg: ATEYQzzNRrnBYmAEyveTGiOG8+y8MwHZJb1n1mglvxZ57Pqf96EdVjKW5iksfklpdTn
	fr5bRqmGzfvspV+6K1SiF378N1YW/fOWR780ubVPZKQA5OmVcVRdifDRQBcXS8Ixz1tSnwSXN5z
	QC5YtgN3+ATz/n7O+9it7VTzUcDagVHeA2aQCebSNjbtMvaCHPNjw0vRYdtGTB5iFNY5ag7Nsj5
	wurZqQXwXeTbXN8/BLOO2/4fTwAbqJVN/cf5S+6QRBzJNUCrNjuY0ISVdQebh74vu1wqtujZLLc
	OTUkQIFywU6uYRbu7C4KiSh8jrLuO+Xeb9TKh9GTUaa0WEsDUbs97eugxEtFyVUmEAPMnjLSHy9
	+tmVjmh6m0aRkvnc/YbkvpeYcCS4IQtxpr80aVX6eZEtRdtE0SpRviwLYhegxmZLy1ov+73cohc
	449wdkH+/kkCc1VpWsxikKfbRUQQsyNgDA54aGY3Tyjgons4Rq4ixhcU8QWXZZ/ErUw4ns0j94l
	LBD
X-Received: by 2002:a05:622a:213:b0:50b:4bb6:d9b6 with SMTP id d75a77b69052e-50b4bb6e880mr132565441cf.32.1774297909339;
        Mon, 23 Mar 2026 13:31:49 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc8fb9c10sm1014271785a.19.2026.03.23.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 13:31:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v2 2/2] selftests: liveupdate: add test for double preservation
Date: Mon, 23 Mar 2026 20:31:45 +0000
Message-ID: <20260323203145.148057-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323203145.148057-1-pasha.tatashin@soleen.com>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45813C0003
X-Stat-Signature: sh7s8or37aptqxka5yhrhqf3uwgbciwb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774297910-516057
X-HE-Meta: U2FsdGVkX1/q2x1vIOzgsJdfM5cPCP2y02GzcRlNamguMlV8HtHCwt3jny0EAYbHqp2K5T2SJUzmm/W7Rt9noinDAKuFHclpZEB/CetqWs4APwmZ/s6VHCiimkjwUvg7s2JkoCLHEqW4TQrfQ0751kbMnaXCESs6xj5cTbLCMwxTYGOMgChok2FzNkzTLH5E4o42gzbmpr1mmcmXnCZ5BlpygCrIBu6yzlypkpFJWeIpR/89E6TAZemwDQxJtBOQz0U6Q8oc3aUcn2qnVEMngXPti6VjqNjF3qvkihdfSWfLKbbL1M+6KFPvjuvlAcsVp3zjLGcuP20WgjotHdPykKoCJbknAXTb+Lie/Fnjp9DSQRRixgk0vaJ7QamY6Zz1pIn1Ibb0lFgM3GhdNOtzcJkC24ilqclzah7xDM8IzTLmK7sRZGngtHwEhHMo2W44rqG5fuGQau2pFZy4Dw8exPMJ2zKJ0SGBVqp/1FALzoik0FDYaxz18buC6yD8G21+ePopIVoWJ5yAUsj3uZQbb1UpocR23cw7N3NaQtQbWIBm3wz6w5i9eNDhvSkrjfnWofcpyhSnO5c2SihuXI16mA+Ql2DU++W2XUziA0snkr50AtrLKIAAQL7WjF9+QrULBX6vYnmI1kkfsq4vXPMpTPDiqs8esZ/CFU9UAGjFWdr+g5QSD6Xx/ntNf7ogxrJQlTfDAXtQNt55R497XClSuU3ffLsiF1sM2SPaJJvc9LwpSvR87P1oDmkBuYecVCzg0YvTXp57oKPQfS//BPRgdGQqoUFqhk726fFOBakK0XDhcHjXjLr/mZoEkAMUrnhyKhqBmsy0/2+bApAekyTfH/pKe2wIga4hfbPf8ah+SX1EoCgfalHXnVj7rKjanhG/eK7soTkty0S55HVqPVyVJB5xY6xNDo7Cgqv1KEOLPRxrlFkjweW1n4idp2k0o/g+I7nPxuhgUyIv29crYn6
 BsM0OfnP
 Q15xUcLynJ+eT63H8u4cgC8Bm/O9PWQ6yICyZ1IaZPCez5VqX3b/iQw+nDn+XMUEjI/V0k4FJ6ZNnN3Cza8EZH4DOKKNRJAySgbEVCYawNoLo0hJPA1cq8dWIz5RhH9T2fFjKqOEq/AQyWzD3N/c5oQqL7DOeTBddNgmg0jtgiEe997OF31oYbAfni+2Swp5dH3cXRAqWj/A/SgKuvPX0W+9XiLBRVxutvfQR/HRS3CJSatvTILxWf8pyJEgPCn3f6iQTSrO39dGJ0YXhZNrIzUTLZk9tTJvwnZagNyMM60kMiqQi0fjPdYT6LE4Br5EIbBaUd/uYxS1ZMHAGdLylurGi2As2L9upRy1J7XDfSXwoYAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that a file can only be preserved once across all active
sessions. Attempting to preserve it a second time, whether in the same
or a different session, should fail with EBUSY.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c2878e3d5ef9..37c808fbe1e9 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -345,4 +345,45 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Prevent Double Preservation
+ *
+ * Verifies that a file (memfd) can only be preserved once across all active
+ * sessions. Attempting to preserve it a second time, whether in the same or
+ * a different session, should fail with EBUSY.
+ */
+TEST_F(liveupdate_device, prevent_double_preservation)
+{
+	int session_fd1, session_fd2, mem_fd;
+	int ret;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "double-preserve-session-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = create_session(self->fd1, "double-preserve-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	mem_fd = memfd_create("test-memfd", 0);
+	ASSERT_GE(mem_fd, 0);
+
+	/* First preservation should succeed */
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd, 0x1111), 0);
+
+	/* Second preservation in a different session should fail with EBUSY */
+	ret = preserve_fd(session_fd2, mem_fd, 0x2222);
+	EXPECT_EQ(ret, -EBUSY);
+
+	/* Second preservation in the same session (different token) should fail with EBUSY */
+	ret = preserve_fd(session_fd1, mem_fd, 0x3333);
+	EXPECT_EQ(ret, -EBUSY);
+
+	ASSERT_EQ(close(mem_fd), 0);
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.43.0


