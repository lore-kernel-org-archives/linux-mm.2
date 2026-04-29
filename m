Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7BDCD13D9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E916B0096; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836726B0098; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74ADC6B0099; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 657836B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D52E1C03E7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:32 +0000 (UTC)
X-FDA: 84712867344.09.29FE8E9
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5334140004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GhrNFlgj;
	spf=pass (imf26.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykJFzTkCkC0C2lj+ZZ4uY5vhivTKu7ETItTHYfKS1Gw=;
	b=DCwo1+UxSZ/JFUg3Zr+m6z4ga2Q++AwfbJ2J/Os6IWYXJdkY+JIJ9SNGfxNV3VwKkSwLHH
	5Ok/H12hLcxfPLU371m/DDFRwQFpkyJh/0bnW7V9dGAmA7bLI5ttoT7NucTGe8mEU7Y5t6
	5Y8cb0JZHad32WPQzQE4DQEGwR1WZtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GhrNFlgj;
	spf=pass (imf26.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497750; a=rsa-sha256;
	cv=none;
	b=idiBj0Gj1LkgsZQzhk2gIklUQ8FmyEy+o9OOc9C0NZV33XgU0Ffp+l4WpULcmKQY7sPXP1
	UC2dq/fH/l2ssrr69wAn2W2abc7X5KmLqREee9W56GXI8G41geWhGwL03hf2kLFFhrlIMF
	LIBQRBUlIiICqwoK0EbqHiSB+SO1PFk=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso2083245e9.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497749; x=1778102549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykJFzTkCkC0C2lj+ZZ4uY5vhivTKu7ETItTHYfKS1Gw=;
        b=GhrNFlgjLG8U35m+l81NahPGJSY5PCD0tyD2D9sn0Oea2/YpQlS4T3vbRyfbfnhUKa
         4sarefGxqtxIpfwnN9HjSZpvz22i6Zu6p1cYubntoe0CF1uHGoh8Ew/rBJj/HWJfu+kD
         iRMGofVlhtaAXTnpEPdxzkE/JFZksC0XXK5bW3+axrDIUdZ2hmxd+8eRb+gWvqfy3W3C
         SipIBXY4xuw/jPthmppmcLo5B+1/0XytbuzgIqmDTBfrxIMqxyilTDwnrKGxhA0pjJM9
         GZPmAJ4MKD6HthoLyatGtugfpc0+zSsZH0YkQfiL5EasMhRpatK4/3noOhWgH8BWWQ1K
         eN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497749; x=1778102549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ykJFzTkCkC0C2lj+ZZ4uY5vhivTKu7ETItTHYfKS1Gw=;
        b=T75uxq16LcA2cIYEBMHEhDydgnBb1LlYWKKX21lUcyUjhYwhqJlb2MvvnehmA8m9x4
         cIn5ctZ7fb/t0GJuSZItZ5vMcUb6zseZyHIqxSoKbdiNqvgMSrZ4A3OxFJwhROElTqgh
         wd4YvOJgnyAT9tpnjY9nMle+Kvbdb55U84nhrloyCbP+NKLjN/mV2QUIqiGqpDfvAWA+
         cuILjgMZnKQoMhre2wdlM2cARqT6JQLwZeWtD5deG6jqk1HzMtACfRJuh6bRz8MaIQtB
         T1HATqINHiWa7SodZVLa9SFZMrFllCyRwBqeLI6bPmwq6bdhkZGGsQID93NnQrboSlKv
         TAoQ==
X-Gm-Message-State: AOJu0YyMiJw5gIp6mTzu3ys2PCh+r8YLGlq6kG3kpEB3wqh5pTqw725J
	iCiXgnspsdDjKGOKS8AYjgq224/4DnFq7eltkqQpo9xF6Y0GQlQblSwd
X-Gm-Gg: AeBDievv9tMtFQTu/TU6IL74o6UCf7yAoZr3QNh3qiDQg8WVrVplQ3m1Fr0ljCceY+n
	GRu10OvMt3OcwSm5Z0luRcPqbLWw9viydOcwCpYfeUtRChubgKFuaq5xGnlMRXjt9p0zdZHqpdU
	MxFU6UuV/DOJy+vgu3xlVb644ZwzL/B6EV9sKgca+11vVrfmathruErwneZvJ6sJMyRoDbLELEK
	u5j1qvBpoagc/wTNNwAAaDwfaqe0VwCWdW6tgbUpA/an86lyrZGPwQhCO7Oexwrr2+J6WRVcpdR
	YCb3JWX0KfxD1L0O3vX2lYCkOXnkfsFI/lLuvcecQlhTTUtV3KGSXps7D+y6x7aiBfzhHsVWDa7
	3Bfm/Hn9G1+Uhqu5lY8J4XYU9Nt9DYl5M+V94fwJcZVLi+tjdF+3dFHjlKlCZU0Kb6/ogVMTWK4
	S4FYyIpIYMvGKCwmm5/9nhlc/52dcYQkT+8irvU7Q=
X-Received: by 2002:a05:600c:8b22:b0:485:3a03:ceca with SMTP id 5b1f17b1804b1-48a844582c3mr4663845e9.23.1777497749079;
        Wed, 29 Apr 2026 14:22:29 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:8fc7:44bf:8aca:ebae])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a7c3057f8sm26200425e9.14.2026.04.29.14.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:22:27 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v11 2/4] selftests/liveupdate: add test cases for LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Date: Wed, 29 Apr 2026 22:21:15 +0100
Message-ID: <20260429212221.814107-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429212221.814107-1-luca.boccassi@gmail.com>
References: <20260429212221.814107-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5334140004
X-Rspam-User: 
X-Stat-Signature: 4e83c3sn4q1k1m8hw7f6dhgagrfdk8in
X-HE-Tag: 1777497750-699248
X-HE-Meta: U2FsdGVkX1/DpRfZRuER6WwdR+EQ/wCeWqcVf+88bOJpgk4D3MXjkNbz1earEUjrmVOGy/7tt72vCXh+bsE7yPaE3NBMU88FheQfT8xT6TA3Nls3ejdE6PCClBtRZguZ1MJgiwjIiSXTzYniO6R8bQE0CTAvfhVeNCf2a5H0haWV0t7vrKsAEXEpytFhWd3GdhN6wgRIZOWIs4wkgMOPPnJQiqbtGS6FzW2ye4wyvBjzWTeHKbMHD4Hu/PhCYIUy9XdxyRQO/J2La8VJsMDDImEiMVpUfH8Nk78I8Ia8mLoTrGhg0Wb/eO0jHmwq5rYf9HZpaRUtgmYkjfKx6M2zP5TYK5DHAMSb8+U42awR6g8CydG0NJ0B0ip8Q6y2kk5c2rCAC2GaGZmlmnIWHPobOgYqq5iPP+VIevpsAjRHLoZ2Ec/Z3b8GTH5iC2xpUfuFzNsw6yYdfUdYhUU5k96awa0cMvJjy4rL8u0kh0BPemIDP0PMM94mHGKPh5zZzFSeO/ri3dB6alFiKOzeKCKf67XdMuoJ/GLyvE5AXI65ashvmtHl3v7ekg++GMOm5ReW+COFMXKqKvE7GzffTg+A1fomcHiGnHUyWPm+bo3pcu3Qj14vDfDnsjIfEUH38CTmg5XH12NyE8fXJgtgVs9eglS/Z7htO2uQGFYB0zeJO97lpWcsxrzQCE1Jc8Cedjg4qqsg0UD3jvRbQBpqVXjNf8VVeMDuAw3BLUTo8HBpVP5T4JiFZK8JD+pv5l3twaAyA0v8/bziQwHhiXJSFvRUtzYCULYraBeOWwuRqozLj05OJqIlRlx0yMYE+dJ29dVHD1SW0j2gmBX7jP/ikK8bFkD9b9MpypvPtc0V4oqYGxAMtq6fmEotkmacAdOdMtH5VNZcpjYaKgFF906cWuhUayknKnDQO1DhVKGX8Bsh8YGrNUwemkRONAoWG0EE5ik+GefLF/1IaRjVNOL5mCE
 RMXtWp/w
 O0Ipu8Z+mRu024s5Eidgrk7mNWo1UuYnnyLCZoGjv0nph4xILJ236O55Hm4QqliCNtEAF7T6NTt1YgRFB73ryknhN/eBaPteB1/3QhB/XEzMY7hw4dZcvicI6RwdeU7L7fh//Ez+0a8Rqyt2LgRSx9Hb7nOBFw/4vgVjPZQzdFJeovWjQEdxGpsOvetO1nsyFlyV8WwGb9n8gQe6UZbp/OBPOqQ5Q0ST+KfUE0uqGmncJITelPk/rRPIuZA9+BrGkHsdqhEO++IUrapqkRKu4841u1tAgPaRE0cClkRkxZBrJ/GcdiMAO/EnUWQq+UZ2tNR0XDoOzvaVdp0MzwygFbr+IDE8cVmMPy1+pBYhb/UtzNTzSyYNojQQKz1Sae6vwInvPY1V1+LeQxJt/y6velZGPn64hYDliNwBM5ZXPz+ATauGzOZ7uR0hV6o9edAR27xPQy2Qx5wZ2qHbcAne7GTyO8xBphigNlt4EStQzA64KKGwEkuTZ9AL+X9xqJ6Pr+nG04RAi7aC4B5d4QpdzbRxjV1Lb/lg7+shoA4l9ZiF2+84+UBDItC5q+V1cAoUFrFV6Od9AvL9qYRU8MzNtQB6gcJeFXJyr+LMTm5WrUjdeOgeJ/RrRbchqpkP3BSQvAd80vQyekvGgYpWfbZ6YyE1jrVnT3X6I5qjh1wNMrQTzlqHE/7abwAfp69LB3TywyLOnNOdlTuaohTmMdUiufE0O2bX5/8RdioiFZ4rbVRrmqJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
that is an empty string or too long are not allowed.

Cc: stable@vger.kernel.org

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/liveupdate.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 37c808fbe1e9..90268d86684f 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -386,4 +386,46 @@ TEST_F(liveupdate_device, prevent_double_preservation)
 	ASSERT_EQ(close(session_fd2), 0);
 }
 
+/*
+ * Test Case: Create Session with No Null Termination
+ *
+ * Verifies that filling the entire 64-byte name field with non-null characters
+ * (no '\0' terminator) is rejected by the kernel with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_no_null_termination)
+{
+	struct liveupdate_ioctl_create_session args = {};
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
+	EXPECT_LT(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
+	EXPECT_EQ(errno, EINVAL);
+}
+
+/*
+ * Test Case: Create Session with Empty Name
+ *
+ * Verifies that creating a session with an empty string name fails
+ * with EINVAL.
+ */
+TEST_F(liveupdate_device, create_session_empty_name)
+{
+	int session_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "");
+	EXPECT_EQ(session_fd, -EINVAL);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


