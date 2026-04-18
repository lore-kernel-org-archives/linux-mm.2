Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF451F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7C96B02AA; Sat, 18 Apr 2026 07:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1706B02AC; Sat, 18 Apr 2026 07:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F258C6B02AD; Sat, 18 Apr 2026 07:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAD7B6B02AA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:40:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D30458FAD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:06 +0000 (UTC)
X-FDA: 84671482812.24.54989B4
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id AEA41C0012
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cz7bt159;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776512404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
	b=Q33k2hIrIiX/PGHfcg4OgVStBm6/0NrgJbKukvpa53SaiWQwFheqPHAR/TK76MPUP1zNKG
	Pd6S2PgXsuy1z3QwlsMjPb5m8rZ2pmGYLM76dyxUlzxvRXokAX/u6VBZSFH7lFMYMjS70b
	n/koUpfpnC8v/1CLaHWzR0FGsOpuzS0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cz7bt159;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776512404; a=rsa-sha256;
	cv=none;
	b=l6j+6aFjG1Tl3LznwPcrgzXFchtkMspQxI7qbsuSvRgZSR4WkErjSvwknTdTohTupmIyas
	9sx8JgxPGog9Q3ZC9useCM80vmXMsTHdKejevOPKcziGeBGP5pqz5zr96kHESta3QuLPDH
	Q7UF79UCNIiDQBr0NjIR4jZGA22n2fc=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d43e09de5so799697f8f.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776512403; x=1777117203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
        b=Cz7bt1599pLiHt4acQP6OvyK/r99MgQkxIB6duEe0bjflEAamITFn5PiclmpW9IBI5
         qmBQazG1nz4KMWGPoRlYgjT76oVDbH8ljEsPoYyki17k9WPYkyx3xCJD+qC7aSuP+0R/
         4wGXW2PzOaAhtIdnNQc8XNXXe2ukQ/oy9guKySuVQW41hx58lJHKME702YKSYi6w+s8x
         jSM4BJDrxw6aOWViDKs3f3DPEeSKsApl/m7vhkw6FmejH7D4SXaupqCx5EuI9Bl3iOKH
         JlxxfhfAM9BMqXE8xOhczMJ+PMLpk5hEmkP0FgWHhBi62wvKj5imMxaNtS/Q0Pi52Yqi
         kk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776512403; x=1777117203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
        b=p1dcHf5iEfimuhP/S/je66l/O3zWzcQklJ5Ebx3gGpStvBeKqM8xhMnfZWAsxFXZBu
         ync2d4X8gUsM9/h9wg3OBtsoThbRicwa/g5d3hAUNJu/Jpe/nY9zfQ8+ddbQQ64TT5Q/
         jjY7eAKuhdu/ufaOn7vuKwAfnOsFJSdKx0bmwSxUPpE/7klO0PHCRjQCkrt7sofUXWnz
         YL3LhoGKsup4XOEymh7UNEzNe2/uEQmgb+8D7zTccMO6QpPjPjgpDeYuGoDcHuRJG4+b
         LjdbgFZIVt8E2XWPhWCGttHUEkJLpVIbpPQG2VOFr71wTL6Z919/nZM4Ius0CliA1NIM
         Yzxg==
X-Gm-Message-State: AOJu0YyjUlmFNtWD1xWY3O35WcXhTgQRgP7OqpWS4K035UliHRkIMHR+
	11cxbp2ckn7ZsX3SUsnIZsD6LrRsOiq9lvLpi/zlajRoTejl9dtnoc7A
X-Gm-Gg: AeBDies4ZLYaMfHqGNs0rscPfVe6TkF7tYNLPIt0pSnFfpWDmvRimAMbO7vpGhSC+hk
	YkloI7Ob61EoLerpNATZeQmdtshcvj8fnYByW8olsyLyjcy5AFXXXqTXYVtWrUom8rduPqs8BTd
	gjU9cHrhPheQ8i4uXyL66fXALmfBFnS/73VeT+xjkdbv5l+VJNKlMl0cKa1VcfsaHxRhqMEQFdo
	DQzSxQnag4cJ2FG5A1ncTPkg+z37F67oPq29RDQAcf3CXk853PbOr7mWy5MmQMXZgEN3jPwAh36
	F6VNK7O/O9BHldKGs4QpEsIefz+g9/A4T2rrGxFtKY/zJDkXgP+7zs3x/OEI7pgu1JVoWZss19/
	j0rhupxGIjrV6xdd+2Vq+/KuDCPRmU+otcm9NyjAaRmIpj5e+KXcZXuvEwQCesuIr4vvmqJNmRz
	5v4KrCWCVF+81dnk2ibYU+ZF7JuEL9EnmxPuBDdc8=
X-Received: by 2002:a05:6000:2013:b0:43d:c95c:4259 with SMTP id ffacd0b85a97d-43fe3e07216mr9801586f8f.30.1776512403027;
        Sat, 18 Apr 2026 04:40:03 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:3ab1:89ce:8d93:ae6c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4cc0d51sm12284449f8f.10.2026.04.18.04.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 04:40:02 -0700 (PDT)
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
Subject: [PATCH v6 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Sat, 18 Apr 2026 12:38:41 +0100
Message-ID: <20260418113956.2146648-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418113956.2146648-1-luca.boccassi@gmail.com>
References: <20260418113956.2146648-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEA41C0012
X-Stat-Signature: 7ow1q1d56d3aokihknzqi1qcjrmqw4yp
X-HE-Tag: 1776512404-915700
X-HE-Meta: U2FsdGVkX1/QGjBgYh6qW3ZKWFLXZ9JSmw6k3IGBIzjsrM/F2R3PPXy3ZeW4NZT3VLufMvMPZ63NeSiv2cSN2Uv4DTydC7oRVFURNeCF7XucyYapIRMpwf1lVkRx+bxIkaNr/T60UPifr8bWGkTNGSIZsfZCOK2quzsLYK/BGnetHwxNzOemPa+ZCcZ7P1+MTp8i2kATzq3uRiozx1Evlf3mI5c/p5hPYJOy8S+6em4TTl4y2lvho0uiwdSVJgF1wdYcw34MRzJIJKGTEpPxA+7c8i2xm2i666ARfBy947cMN/wlsLud6Q4MvktdkoBOU08gC8TuwttP88dp/wEe3B2NLGf1WAQtoiPQGrdp2pLsnyL3IEAYHIgPMD9RT0kNsXHszyKM1OZfLaPmI7XcXqo8F36ICNrBOgZ3SUugM6cl9Av2R98lGhtvKA03L2ZOiIvCsUkOMABfKoTgEnbdEQ1yjZfVBNlqv093JzWHY6i+90og8m/IKK52zdpEziuNwQvi57sz/SoZEW+wiZKIc0FOOW0q/3LiUSeX8WIR7SxBKzSbtELeQoI6rJv+Enk90xoTQbXYwZ1IVgx0k8CacVRS7qKtFvRJh+cW7bv1p8PAamwO36HSMLNOuCwbF7dDItyYynehkRvPb2AnD1xE9G5kWe4W3iMzBubfN775GKxEPJ7OCIpAQcbJa70cxeao+PyhFWJgb5DatOBh6Zj2rA5iurfCWh8g1Z0dwE7UB60iSZYeBM0tP0fpZiSn3Y8b55Fj+VJZl6On9efBLmp1X+jbOysthBEAFe903fJZLQEgHWCXShE3CkhbTx0OCB0487P/LUn8PfC/PeGS/f3RE7ZXKSQzGhgNyFpP8+a02JM+YaV/ZRb/X5cZna4UliVjRzCWH4xJrStUP5B9HrHFu8I5YNI51AfquQCTeGLYrM4cqNjwYt6zhf12TLiZpKq/wRvaapZ8WRgsChaYWQl
 V8sq5mgZ
 6oWgr76iQdkIgxi9m7G/JClST6FP027/UHCH35uQ47WlEjzfmuSnm/2zfTm8H1QZo9pAIwwaX/znYnKt4z0c+c0rzutS6HfhkclEezwnWZa9Nl+Kk60tl0mLumzN0tzbOsu3+ChB7NDCvuy3hov5sxfUnr5Xu4m3yDV+oQ2FT2716R2W92pKz4ZKuFT/OSpHiywJ9Ryp1FuQKcRPsWYbIztQPlBKAvoB4Txyje5uw+bF4FG0RB1z/72GQZkW7rgI8c2eUv9QKoOIUmn5H/hinVx97CGuBA93Bi/dLBfb0CFUbC5KKJ1Ejxnf7xl37ZvxjE86972H3V3Wy+ZFvX5Z4n2qgUZa+6Wp2G/Yz1AK8/97n37wFF6cJYE5RkbpSEjTPAmeJqbWv76Qb2S1bo9QXFmntRfL8cIjxZaoQ74bqPepwCkPoKrwuAW8XyHDVht43V7rgaSBvqnZYtFb57mdwuQt+605r/U+w9VW083QS+1PIzaJyW39JziHIOuahVKDFkmEHC5byEGpNtLbrs6ql0O25JZx7kFxbtVYyU/XthKxGR5SsgZSk1lfVopggwo1i2eTh
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
---
v5: merge with LUO_SESSION_MAGIC series as they both change the same
    unit test file, to avoid merge conflicts
    split into separate patch
v6: add more test cases as suggested
    more verbose commit message

 .../testing/selftests/liveupdate/liveupdate.c | 138 ++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index d132b4685f76..ffbcbd465c9b 100644
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
@@ -385,4 +401,126 @@ TEST_F(liveupdate_device, session_fstat)
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
+/*
+ * Test Case: Create Session with No Null Termination
+ *
+ * Verifies that filling the entire 64-byte name field with non-null characters
+ * (no '\0' terminator) is handled safely by the kernel. The kernel's strscpy
+ * truncates to 63 characters, which we verify via get_session_name.
+ */
+TEST_F(liveupdate_device, create_session_no_null_termination)
+{
+	struct liveupdate_ioctl_create_session args = {};
+	char expected_name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	/* Fill entire name field with 'X', no null terminator */
+	args.size = sizeof(args);
+	memset(args.name, 'X', sizeof(args.name));
+
+	ASSERT_EQ(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
+	session_fd = args.fd;
+	ASSERT_GE(session_fd, 0);
+
+	/* Kernel should have truncated to 63 chars + '\0' */
+	memset(expected_name, 'X', sizeof(expected_name) - 1);
+	expected_name[sizeof(expected_name) - 1] = '\0';
+
+	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, expected_name);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+/*
+ * Test Case: Create Session with Empty Name
+ *
+ * Verifies that creating a session with an empty string name succeeds,
+ * and that creating a second session with the same empty name fails
+ * with EEXIST.
+ */
+TEST_F(liveupdate_device, create_session_empty_name)
+{
+	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
+	int session_fd1, session_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "");
+	ASSERT_GE(session_fd1, 0);
+
+	ASSERT_EQ(get_session_name(session_fd1, name_buf, sizeof(name_buf)), 0);
+	ASSERT_STREQ(name_buf, "");
+
+	/* A second empty-name session must fail as duplicate */
+	session_fd2 = create_session(self->fd1, "");
+	EXPECT_EQ(session_fd2, -EEXIST);
+
+	ASSERT_EQ(close(session_fd1), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


