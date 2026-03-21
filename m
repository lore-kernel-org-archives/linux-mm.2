Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968D61094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D4C6B00F6; Sat, 21 Mar 2026 13:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE53D6B00F8; Sat, 21 Mar 2026 13:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACD36B00F9; Sat, 21 Mar 2026 13:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885926B00F6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:58:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24E3E16059D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:16 +0000 (UTC)
X-FDA: 84570829392.15.0D5EDA9
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5671A1C0003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DcMLeuh1;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
	b=rm53nYPP/kiP/UR1xcSotKtNaUU2qvD29X301XUAfITfHCHo5REiOwKwDEQbMdK1wCv7PF
	ON9Ow738KfVJocIBFXgC+hKzkqAQHybLtg0b0QcOhgExpBk3haQ6xkEtfbYPUQzY8vD1kX
	0uWSrX3NdVt5wE1977qBvv79ErIikSs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DcMLeuh1;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115894; a=rsa-sha256;
	cv=none;
	b=ShtOsw+RZBMLN9NeAKiiF21UXfJud6IUenQA32p9c+BkIU64wFMhLb3u5+k9+7ZFUa0nzf
	8kdZZy9jBcej0NFehxn81rJXbvP5WNflPZGm+D6Tkyo+nUbpp+ndoDy0utx5RRZ17dc4nK
	hImwiB+1/m48NBGqU6tmh9E4s2rkxxo=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cb38e86cf2so276266085a.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774115893; x=1774720693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
        b=DcMLeuh1YW3uG5C5m/11U64bjXYOKomr8a3kEiqmViF2UGmbZStt1dpgU2eRSxwQLk
         vBjQDZnZ9Cv5J2jRAMLiC8jyf/CvVzCI4m8sGSbfxbUC2uzl07MGzPx0JGIrZQ0Nxent
         9CCoydsUiEhLyOQdoxa22OAVd9GR98WF2VjGLLC8vZnfaWc1PYBlLJR3fpzS7Rq1GdZg
         9PXv3rGl0GgtGh9EFRWB7vt/WSCALZJ08BfrSdIZwkmo5fWBS8nwSGkaK2mp/Y244oAI
         cYm6VKyBrHk6J/kJKQEEaXgcg2Pv3pwnzO/if/aFEZX17BGtykHcY2WgOXaFx9u2K98I
         tuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774115893; x=1774720693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ob8Y//wo6MRj/M0Dz67mgrBX7aDHTN1F2suUDWyFSyU=;
        b=sGPyLlge4vSatyl0LbXi3468JeyMFCjOuOQ4XBWP2ygQWdyuaWov5R8mcNnyG0lov6
         71N4nhwE929dbXnVsYAQyHxgxRuJ1cbPwfsts4o01tTErLhM5eq6OJ+96k4aWrPMiUxW
         j+1gCsH90JokJK9I5VwVG/JCOiQ0tVJUCmMvcelYRfSUGMZKruSN8yn7S3wQ1caW/Z3u
         l9c5kLmqe1PcxWqVc+swpcyI5tles6hflPf0PQobEu1YH3eBipe2ZDHHU6fdHJQ+eVjb
         BkaxYUqVLYku2FtzoUiD8aOl8WBf+iRDflL6WgWroK7MJRTjitZe7gJxOSDZ1biiPGd6
         HKtg==
X-Forwarded-Encrypted: i=1; AJvYcCWiOALjaadm1zRUFdsj3yRsKbwgPZFo5Q1K2kJUTJaVy/pSBjH6O2Jh4fo028l7dviEaiHfKgGnJQ==@kvack.org
X-Gm-Message-State: AOJu0YzNP0ItUzlZctHbaILAm6J9SBSiqdW3XRDwh1dWFRxH3+KmF4P8
	JT18TzQS7Gh14L7u+O9bsLvtdhcfvZZrNLgLoLmFK20Tf5EwkGVSrgTaaXgv1N88hx8=
X-Gm-Gg: ATEYQzyDW9cm4mOVMTDyV8KVBfCC5MpcUBpFyDpnrG8zMGB568hfjOtPjamgNQrJEaW
	bexITVd4bKolz3fkXtgNZTUP8WLqOvXwuIoDGAZnS9IPF1Q2+C12Z/XRzSDhfvFCjzp2BEGWlJn
	FPopycGOG3F2D599yhn5SuYsr67lNH3MSpCa0vpuVpmoWsi15qI3KffRmre9m7Aue2ZfNgJIa7f
	KB7VK7WY/qf/4hjlQOqIe62Pd7VAGYCIX+7f0W4pY7Ichlq1W4z2CGT5ZyVqAFRQYeAM0gpW9zE
	oDKiHyOqfs/7c0F7jqxRMDKxLlMdgs2Gd1Cj0sTQYJXRz1Z04Y/2A9Aqa34WZW1P2ILQAxUK/iU
	aw028aeXRa9IXZfkwjHeSsPuwhl2aQXV4Efw3bsS/8A9kXsRQLiAFLJOOry6GETvJ+c5nfp0l6q
	hMdH/WiKARlNvG+MhCvRLULgQShzc3C73g4Cdmbd4SKH6aB4WkWfB1WC+yHffUtOu0Uw==
X-Received: by 2002:a05:620a:aa03:b0:8cf:cf2c:e021 with SMTP id af79cd13be357-8cfcf2ce4d1mr751287185a.7.1774115893390;
        Sat, 21 Mar 2026 10:58:13 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089ca9sm426515985a.24.2026.03.21.10.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 10:58:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: brauner@kernel.org,
	linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH 2/2] selftests: liveupdate: add test for double preservation
Date: Sat, 21 Mar 2026 17:58:08 +0000
Message-ID: <20260321175808.57942-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321175808.57942-1-pasha.tatashin@soleen.com>
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5671A1C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: t1eatguz6cscz1txddtz5ndrsrs8m4jd
X-Rspam-User: 
X-HE-Tag: 1774115894-577324
X-HE-Meta: U2FsdGVkX1/PYHxIUuwf+NYKybCDL+nH4s7HconBR1zCno+SfZWoK4zAFYM6mVZVrJFFkXQuide80kHdkvZsJbh5vDnxUstZgXwVuN0aEbsfxTSQ4UfX4Z2FKwhfStVMnT8SPdEE47/7dyrQN7TlypJx7pck6l6rFSP2G8CdV0emrYqk1WtWcK4yxvD9nSK1r81BeC4s62iT0tW854tUykyVYvZ9b8Bwsy7w0S2sv2+i8jdjgdieYM4Mv/xKq6ZEjrM4j8bJo3uAMPt/vSoWvWWdy0pXf5rpW7DvMCdbaOBEhxSeb3VkFU9dBhvbLwuuuq0tTq/XvhBO3VsNCVI+c5n/1n2sFCplIfacfTfl8FOgm7604h24TXvFpju88GuPC/N/AQlR12sUN2JWeuu+J1g2GPtjdIKm25Oqn06G51WG4mM2IngCYmgxzhtqmZsy+A0otUHUtV5mnfywMCvbddoYtn80puDDQxDFw8Ba/WIN8QUqaWyaygs+K0OyQRKFb8AV0ZpUwIKxPRdd7J2gN7O6S/undTX3wd0h29PwDhaIlF83gyfNf1iegcGQwdG9ra1P/QMz57EXL7SIyZFTCFL7n8mp7XJaB+tz7Fbc7JF+Hp0YqcNLzVb0WDozYEPgxymFwilFloj0Ri8XomneWZ9kKZE68sEcrduXCRAbjpsviiSdtVqQXW4NEbJwzWhWvsLAwyVcJkDOiXfgltZf80nGN4Qw7nr+JSXeDTdvs9KK8z1GLbFFIHxBz09IOraIz7qwvXNvZnOsMJqDaKWVzebywfqmhSB2Dt1cRuOLj9yjGG9xKRGJYt8Dc2bczSlIPXcDJYROaZ80UlHBDXdLSRduULGLLhkx+kKrwJZgmdbc3a70RubiK6kjqfFF1vKF798gkoqAxA9EvuLAZ9DEHTwCP3m/yWOz9iKZNZDM8u/OBZgoMliA71aTwAam4VfO8c13+PaDmYWgnfE3QFt
 NHLYqwr7
 s1x3dZnjfVSCNY8xaYlgsEM7Ro32TZy0rcSG5CdFHxcc3ORWTdnq5qJjyX4dsYcBq1SynDaBGrRH2YZcAPPwBp4HzHMcQYCaL28NPu4EL8nVcmPRyIW+y1o5CWqutcTrWUP3ovoPA9ut15ZEm1x6lrF7aPB8Ig3Kqdq+axVL4N7mwq2rpS2Dno+iWkqOJiM9jaAK7DRbAuEmyc5OTYK7sOOcA0d70KphtxrWBekRmVKldRWReKNfNu/lBrot7XehjB+rATbeM9GBcrFLFsbbqOEAiFF6hY4UNATCKFh9sSMVT4joKhrn8KeDyvUpqhBiaOBjO2xedkstqVZC5nOZiCD4TkhIaoogcFkPx+QhSffIe7ng=
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


