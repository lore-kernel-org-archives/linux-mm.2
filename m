Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA578F588DF
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E146B0096; Mon, 20 Apr 2026 10:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6172B6B0098; Mon, 20 Apr 2026 10:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CD36B0099; Mon, 20 Apr 2026 10:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAF56B0096
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:18:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0104C14095B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:18:05 +0000 (UTC)
X-FDA: 84679138572.02.88C3154
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1578B40015
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:18:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBCHYNcQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694684; a=rsa-sha256;
	cv=none;
	b=sTXcGEsoQWqNDwRC+UoWD2SGERbaLPDM54HFKgRymPnZ35GheqLVATmvpoNBP/Eb8UMJIG
	R5u7P7QFxk6RYEd9AxVDljQcxQ3NzNO5oW6CnSv8bDyA1KroFygK7SANFNT5sQFoMoVyAS
	f92fGMyK9pf58FD0mdM+N16u1UJf5Rg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBCHYNcQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfZFpqwj1elMjnLHCUJlwJVYjCsTNOTD+bgkX23g2Wg=;
	b=VjLyw4yw0iusdDZXNWTMLsPx1dsxaCmsMax4L+FJUAC6bl+tYna1Nbkm30fgSRi4SRPbFe
	CH2U9Maro/aXKZui1Z4n+51rnuWCPOUhWk/qWCTDvdfuy+AcqjXHISEQXyFc5lzkeQCsS3
	8SYedpIAATQKFdTA3BFa7vMybMebvrQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48896199cbaso32936235e9.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694683; x=1777299483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfZFpqwj1elMjnLHCUJlwJVYjCsTNOTD+bgkX23g2Wg=;
        b=TBCHYNcQGqQvEtfAgYn8T/LH3HcZw/vZftQ/ZBXv39FA4TbfQAZRnh6HsfkGskb9VX
         0HR0uJ+mIuIAGMYhuy58gxF2stnbBNi6DX4KxAhUIPc/hYYfCVOsU4+Lp5iIRG4MVvOe
         WbN6WH3mtPAM7+mV0H2+zVXGYb+qLh+/+ullyu/5FUfd+2oIl5IzlnOCnbJrJlPX4/RD
         LRpzpPT6AIiElCfHpAaiz8E2BLxeI89OPlIddTAGGgn+XXJx9ck6aUo3UyK2VVV5oaG2
         Mn2OxP7fmsWv4Muaytl7rnrIIjA18q+0vu7HQyPIYE4zpU01O4704TbZM9mHsL68eN56
         XyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694683; x=1777299483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vfZFpqwj1elMjnLHCUJlwJVYjCsTNOTD+bgkX23g2Wg=;
        b=HeiN+/GnHyeROjBS1F5KL5UX3n4BoAtnwQNlUizvfkJOYUKSqrTiTQOZ4KWFAkzqLG
         2jabGnE8Un/d7UJDOX72lpgIExw67R3asbOrPL6ZRhpBPF4nxeVgImLNoy2ms/6/cOgF
         x7FlOZOILi6lGmLJ0g7zaTxMrk7gnPz1UMPvmTHqBTJOnynNTwilKmV4qS7/T5CV8hgR
         Ii2FI1jXidTaABmqdktf49fpQ3rRbUVaepXkJdHw0tY5JqNut7MxX3WFGWBrpe6lX8Lo
         +QykTxI9gKxBUGItkFS7+9Mg/WEuunUPtCuFQi85lpWBaiXyprP36m1lteX15g5Lke8i
         2DpQ==
X-Gm-Message-State: AOJu0Yx7T6XYSWWWSgDJ/Z3cAYXZFt4mpOiHOXlTxAJZ4IIQAYiY+XZP
	gdSg4oWktoKiD25rI5eEAN43d22DxR0YRObRTDQy65ZwLnGg3fpSSDvs
X-Gm-Gg: AeBDies7hIfMwbVP/6Hbn/NgYeRqs1wg4XDnrRVwDLjxX9UGkWshADxChGkjW0jIBMI
	7JMmYELK6AnjMUdU35HOD83NjhNOVxwyOdLKz1stgymt0HKZ9nHt0MzBr25KuRlJhafXF052JUY
	pDrcaK2ay0ulP3/9GUGDi58gDA6TbiLNubSs+9J28tnaihsZ2brY0PRorRPahxG1htte07kwHpt
	t+zY87MOtIT3IigJepTXqtvxhKufSAF0OlAqleE9egGNJ/PWVfKMcj5Nuy3D52qLpjn72s4QPm5
	ke1HflGWuVdnR6U4I0uwOOhrj91AavamAPi3Ykgi7z7P830mLOXYutZFpPLvmtsEML2pNtSVRUA
	vOC4aZLx1GSvT8z25ij/4N7NpqmH7k821wy8ybnbCBalxYBxqWZWnINfg/3ckBoxyKCThrpKCpn
	BEKzjWImozi+l+/T7CLywOLbXDBA59mreNeZtPbHYHKB7mksmIuA==
X-Received: by 2002:a05:600c:3553:b0:48a:52f2:a0f1 with SMTP id 5b1f17b1804b1-48a52f2a5f0mr17660055e9.18.1776694682523;
        Mon, 20 Apr 2026 07:18:02 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc0f82bbsm474198035e9.3.2026.04.20.07.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:18:01 -0700 (PDT)
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
Subject: [PATCH v9 6/6] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Mon, 20 Apr 2026 15:15:14 +0100
Message-ID: <20260420141741.2688371-7-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: ppyeiqdmwcf1358m6gcnogi76ffqbt1f
X-Rspam-User: 
X-Rspamd-Queue-Id: 1578B40015
X-HE-Tag: 1776694683-59666
X-HE-Meta: U2FsdGVkX18SmAscTy4fjmwjoNFzr0c2Oa3mEfuxRhUwRGLQ+7QlpSt5qevJjgBwqmdNiQtr6/q5VdDP93OgUCsiLd24PXrz/VXoiINIuJ6Ae1ku6x0CVyfF7XGMNFAOD2Lg2Y/6/Xg/2MJDy+TUz1zvQ9MEmaNXW/ynPiZDonEmMkg3IMe79GCYkGCoEY3vL9l83J4z69xxDyz2WbQiq17Vrj25d30F4Vk1dFlAcCJ62gXSvmBYNY6SGllgCukjeM7Re5yGWSSMvJoMqtDVpwtAj7W3rd17FJgPx306MBBZcTgtnKpwbrQk+78xKRGGkRZfLrgp08qfSjLG6aZ8NsIT16ZbPB9/swjHdZEROQRlFVPk46Epl0nYFP1dxLA559R0Ic7GgmJUp3UUHVpqAuxnP3PX1vBsNp5jKVxg/tT4EEnTqZFSN69mnUewFkzDimdJKBIg0DtUfH80KxE1t6oFFYz1llzwn5EvoZhf/d1DGGfAHHwxbyVHx4E4M5i5y5383T1K7bGnplr7n5ed6Yg0RBV1Svmz4ygevLQahASoXJw3EHisMEzEjjrsD9nKuk3ukMBY8KncF4SMXdPWfNbRJdzcnh6TH9nzyjCYKrFvze0GuADd0j6A6fNR5NUQ9ojsOnscgnxy72ZSi3Yg1N4GfoiAlPUAUDuvXhG0oo08pjLerjB2/Yy/UkbxRZyIQ76pWsWj96wGYuSSrQgvPe5WLgNZWCx2LY0eyh9X1JoDM1cYZz41X5ddFUPsNbtYdsVFVhPttlQcDmOdz1GjbZWHIZZyVG392yv+nEhaXhXFNACE/aWytjK7jWRNq8li50B70DUjpOTWskW2Ah/Ps9Xdj3QCi1t1JgqPJF48JPdmp9LgT/Xy31y83h2dCP+VfvqEFIrJ+n3aY1fm8twIDsJAzUaSAPcC53qPqGnf2NxX+Ytn54BK0OD1HSFdJ22NTha+rpi9x14lnep34QD
 qktWwctE
 Nnq8PU6OtMMEblHU/V6ZIUbC7X3dl4t1zciBi2LFypoa1pvmxqzphocZ0Tj8yJEYlxdzv/FALG44GAD1Sg2lnxwM26evy+7VACkWls2WTsZK87R35UNYiaYllNsxBxv0J27OknaRBK6F7W6Lv1/VvheRHic58qinUigP4uk6P5ja4PYm8oEPWfgzxq1Ol/ovLLCtt4ggqsKcRbxLpaDWkd09OdwbNY86h5fk9HbK7QiZkTaEC/A2N6D+MiSZkIH+Y1+/h6yUU/uzwDz3jvk0ZYUo6n6NRdJaRMT37kj/Scm665za43rKl0KtWaoqdzdnqkEy9Hjm4Gk7QXBbipviOJ3MsE2wUH4p2j5cYekZsC4chfXKM71WJ7xU5sxWt0mgCl0DQWja5Akiif7Pj1w22+BvLh0Eavlgz44P6kbuIkQeWRrfhb1BVUE/WStPtlJ4bxD1350TzYip4KxOyrYhDUydq+VA5h42kWJjJD6JdYli7zMKfELba5eZOjcJran2cO/ghfOWI+N/nIzr2clj0CZB9nQ4s3FkWYFwYrbt06HhRJ3iBMoArZ08yK5CeBWpYscKerOmZosiO+Znk2RAXfsZNgxiPkD8nSAC1nQVfJ0j7OnH4oj3feHm2MASyVk2aEntTj5DhXcMep4XVxwj8aGoTXIYW0iEayFbGr5LRicEO5vxiQejdij8r/w4+di6wlksTSea5NRGz5iGHZXcF7hdXAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
as expected via new test cases in the existing liveupdate selftest.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 5e99af0cc6e9..c21354dc9b93 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -105,6 +105,22 @@ static int create_session(int lu_fd, const char *name)
 	return args.fd;
 }
 
+/* Helper function to get a session name via ioctl. */
+static int get_session_name(int session_fd, char *name, size_t name_len)
+{
+	struct liveupdate_session_get_name args = {};
+
+	args.size = sizeof(args);
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
+		return -errno;
+
+	strncpy(name, (char *)args.name, name_len - 1);
+	name[name_len - 1] = '\0';
+
+	return 0;
+}
+
 /*
  * Test Case: Create Duplicate Session
  *
@@ -427,4 +443,59 @@ TEST_F(liveupdate_device, session_fstat)
 	ASSERT_EQ(close(session_fd2), 0);
 }
 
+/*
+ * Test Case: Get Session Name
+ *
+ * Verifies that the full session name can be retrieved from a session file
+ * descriptor via ioctl.
+ */
+TEST_F(liveupdate_device, get_session_name)
+{
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	const char *session_name = "get-name-test-session";
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, session_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, session_name);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+/*
+ * Test Case: Get Session Name at Maximum Length
+ *
+ * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_LENGTH
+ * (minus the null terminator) can be correctly retrieved.
+ */
+TEST_F(liveupdate_device, get_session_name_max_length)
+{
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	int session_fd;
+
+	memset(long_name, 'A', sizeof(long_name) - 1);
+	long_name[sizeof(long_name) - 1] = '\0';
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, long_name);
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, long_name);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


