Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6798F99C80
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 14:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AD46B02BF; Sat, 18 Apr 2026 10:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59346B02C0; Sat, 18 Apr 2026 10:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00026B02C1; Sat, 18 Apr 2026 10:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1F766B02BF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:11:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80AD7160553
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:33 +0000 (UTC)
X-FDA: 84671864466.09.5D89482
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1FDFC000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avcmjD+q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776521491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
	b=qNnYa1r4KnvA5K7LAenxGCgyNt50eeVBiNJjx98K/ImMi/Ll6+WlCq4WZF8eyoc56p5dmm
	yGD+F++rbVgfqoZu+WcvrItyN7uHqmkE1FSlEcNmNj/aM/rZIhZ8ZtuOtGQwiFpb8BBYpg
	GkjY0ofoPmNywN2ip+ZERCyVgkvuM1I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avcmjD+q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776521491; a=rsa-sha256;
	cv=none;
	b=NhHS26F3sovv33xh7cifd0h0faIp7S/RldOqfinEtwcij52qeCw14jh42MyYcCj9ySt7rD
	hwRnXRgC08DkJiCINLGKv/3KBwPAVprfC+VC89YGPvYdPvvnUH698CJyX0YSLU5qBht/Hw
	KRbb4q3Zqdng0t+5l/v23sIXeYSniG8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso17165675e9.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776521490; x=1777126290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
        b=avcmjD+qrgqeb3apRbvUiv31blvmMKMajKBvrgNu5oFwsBa82Q7wG3EYzpQiUbUrsI
         zCmhvTLFTJYd64Ccz/bY4/4aIzZkbon4sUxT7Q0EYjXEBD4UYjgW0VSMMRPeL9mVJvwK
         gA+f34yFnioYG2X8gxGII7yBogJjXUf8/tlhXXRcduG4x96zbuex17/r3u8bnvZVQVYA
         gwgU1zsHjNZerZcbDsjvcw81xguNe2tz8ZQidChhlGIM1/aMqQ75U+APx270okqA0Q8w
         o1oF0XYOFBp8tDg/PKdnhWDR7O5AvagjaLyJY3WWaVfcxxaqfkJEnabC8T/d8n2Ce9Lt
         4pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776521490; x=1777126290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F0uV/ApidjU/+Ww0veY0spsvhyr4hvLh1zUt4FfzGYE=;
        b=og2uCcv1lN4W+3zBxs6hQ1w2nWgQtYiROUo98atECxwlniq5Z4iGqIvUo8PkPv7evM
         Hr+lacTN3BJ76p7xjgfreKObl+fVsnq0clPb677+bxfkRG2+N9f6D+5BzTu6iiSZ1drw
         s/qUS3JXhobu2nVzAk1xdWnPK+AdNgwsBbA0QVt6PnicyBK1XQ5Klfl8JqAhY7qZ2b6F
         upk/MFZ6gYKT+XchqD9dUISui2XSt0o04DLFC6OiUBTamqli8qqxeJcYc2oodQdoJuEL
         Rl6iCuNUUU/i0gIDklXMcGizV+NtVDPFevpYngX55P4b56Xtj/KjTXMtFYfxXgIXFsCG
         nZLg==
X-Gm-Message-State: AOJu0Yy1c3O1Z2H2XZ4pax+6eaiYk7AtULwOe7M0cYp6pCWQk5NlqYvT
	+T6WcUAIryvEzP+ZkOyOXGR+dY5HEV5vW1NGZwG3/OMZMjAcUW+/eTjE
X-Gm-Gg: AeBDievP4p8e/jgiXDbD0VuZiOVp5bCjR25+AvjEJWefH4aJuR6OwYocGZnEihVfjfG
	jFmxmd6XX4/70IHF5bjhV5hkVgJBkIHbVy41s+rPGt33m0OpjMW7ahCRiTbEfCzxFNX7+go8dnB
	SbLjewZWP83f/nPivr6af7ydXhMhKv2ibnNMtadgBev9S7wIuloUuf+Af2mPT64MawtD7WUCOaB
	iEdueCE6f9uD99PP5DfBlzRmTEDO6Ud/79yo6Ia9Se2LeWlM440XJJ6l5dzy4UzQSYbvb5EsH2L
	My5l30rVzCELuFGFuLnm1uy5uL99fgLjM3ViDfmRbW320nc6qOSLIJ+cPNEwNXRYhHoQwxElRof
	rR8dZQnZQNkXM7AZJ3K0gJ3JFDq3H1nmrceKOfhpEVUJNLw/ipH6YUVPHpHMpUuX+2uo+kdZoiP
	hH417EHfh6Hob+ivUaVBtoU5sZ8NNMN6WdLFIYK3U=
X-Received: by 2002:a05:600c:1385:b0:485:4eaf:eb54 with SMTP id 5b1f17b1804b1-488fb78260bmr95376265e9.20.1776521490069;
        Sat, 18 Apr 2026 07:11:30 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:4429:3762:47dc:91a3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb7a0c13sm43557365e9.21.2026.04.18.07.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:11:29 -0700 (PDT)
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
Subject: [PATCH v7 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Sat, 18 Apr 2026 15:09:40 +0100
Message-ID: <20260418141123.2193917-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418141123.2193917-1-luca.boccassi@gmail.com>
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1FDFC000E
X-Stat-Signature: q7ui5jwmesotey8i4aff4udtbjdzpbok
X-Rspam-User: 
X-HE-Tag: 1776521491-933495
X-HE-Meta: U2FsdGVkX1/gTwoYxLif0RWqTFo3UBT2HemvSIYjNpB747t6rppayPVHVzqhhgnko3Ondo64W2S0pDlQjQ3Rvn3PpJ2tZ6eoQQcykp63RFwiB2xyWg5e968IcZ/5s3V9TlORmkd9vS4KY/QG4cb3Ill0REHTmg8tcSGKnotcOF0AbvmuBSz/pbxqmpybRlebjt9IxRi2IF77MML4eziaHqs4GKLOL1vzm6O0m4qz7jZsUgZr9eZeWLWu+ubFu1rWgQNopDbkLZ44kQEg/IQ2J6TUtJxgDDqnOUKVt/wtLjHohw174MOLZIMuGsXzQ1woT2lT/zPEoMCjFFaM14nIhBtCBqR4q60axvZ36PM1EP0kB2J8lvalFR45q99BeFNMuLFZuJBC5MJJzw+t6GYQOTPxfCv6JMQMiIQSrETjzgoHXidG3uhD3aJOmH4QT7174xDRsRU+blZHUFcizZ8SIgWAXwGu1XaLK+5YmDhq55nFGNCqIGFnZRemJn0eAkC3J+Hj8BJ6zC0tpOaaSsoVuiV4aB/zAsPDCcfLkSIx3QCyQtmks+U25/Xu3dM2HmldpVjvBowzGni+AcR8qUIHcx5/eM+y8zsWfNFaVWPNjpu3bWg+vo1o+40zuEFIe3NfM/vUi6SVa6HXf84CAlPEWk1T/xZ2UHdEzyJufJFXLK/1le1s7gWyAdOYYlbSlZI+hO+bP2J2i+fYYsKkrTAPdajzjTWBTovo03y5dAJ5E6wTC2ECwnAcOM+W3mvMjrDPC9NC3se/8sn17273pwEXh54aSjQPoNh6nIZLwqLtx1Bi8OxJInJZuURHokyXC96YzA8Irv+5njkK4wMTs8jFhpNi2dlTiLFhw0WhRRO89bEvvdUB/8eeBw99trwiffgw5MwZEsfQZhC57VcrABvrwEgEbrAY77wM8VU+Zrzy7lgn/3e8L71g/sWCLHppKnbeM+BaeXCOxFF0IfmfVN8
 yLNO6310
 oL+QaMn1OeQuymVhuGRtKBi79WMgrZJyuLpFrvqDiCCtAQzHbLU0aNZ6/WiIl/PJP3vJg3QYUV61dgl+xl70iFmPqd/dOlKbCtAQ1imAmcAI7Ux93RPj78zI6mWf6W+tkR3I1Phl7ulUW+TokH0X/U/ice5v08TiY5gqB7318SL6RouY8mezSluDR/QocbuQDHP2vJilTIhqzAevVww0g09o0hUDdghv0ktfTbS9xbxf+Dj7yJStc/gP+f11GNBPzymTbT8rkB0HTBTFEPlKbJAR/W5brdK+vgO0+wiqrv94eDnlOn0L0R8oGtOjgdNQHoZGi19YfMXM5mArTJ7CD8gzsbPjPMJJxmhwLfGlUrMwEaaNMYYv1e/GBC7LYNp9VurL6ds/4+YWOq2vpDPfXQeuTavHUH+sFZ8VY0w9CeotEEvkNMA826LgDn9tnaDvBAtYLIIuillimLy1a6zhkqKHVOJE25jcqM/8POeQLhycyTwYGekPWjCBCyghMLCi3zQc4/U1FCpAJnZTA64YkUFIHqc3do+kqrzC3FlgZhU8AVA5TLvpB45cdOA1IGmoiRmFssO4tENnpKcegrkWjgz17Uwz/VVj+wFirRZiw/XrdFtmVu3CLj53v6nMyN+cDblDEJjyrITchcVrAaJREYkB87A==
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


