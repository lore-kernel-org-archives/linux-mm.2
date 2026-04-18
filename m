Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3A0F99C8D
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBEF6B02D4; Sat, 18 Apr 2026 12:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEE66B02D6; Sat, 18 Apr 2026 12:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B3D6B02D7; Sat, 18 Apr 2026 12:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6D636B02D4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95A1659152
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:28 +0000 (UTC)
X-FDA: 84672224616.08.BEE3E58
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id B9FDA1C000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dJ+ykXvc;
	spf=pass (imf21.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uguiSA9xVG8SCE4+kERAOLrC3CLUPwMeYK7rWWVQ3nI=;
	b=DUtAq9VYBvyGPVTL21Wz+rnqlmILqH7rpI4cuwHKK2Fv/wW7nu5rlK+IFDDAigxSU4DFMd
	WvsSogSAtHNnkf6+plx4rWYheyzFH88BxuBCUx1cb+XpTi/MlJROfMwD9zXjUqY54SV/Xk
	6PE/hOCRqIxQvyigKoOnbvNi+oTn/mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530066; a=rsa-sha256;
	cv=none;
	b=BQbs2e8p1BaD3cSh/KeWqr80Sne99+MKzM26jMBVBATpr1aWmzPGvkpuUSXfNakjwPUE6C
	ELq0eeirbOFD2hlzQap0CGCXW/Sos0Jn0FnQTidaCUMB50pWtYWRNp3jt0xIVY8fixxQUu
	FaxLkmt85XCkW699Iwr4zaEEQECHIjE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dJ+ykXvc;
	spf=pass (imf21.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so24456285e9.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530065; x=1777134865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uguiSA9xVG8SCE4+kERAOLrC3CLUPwMeYK7rWWVQ3nI=;
        b=dJ+ykXvcX6r+N4GWsSLfIJ063aPc0I/Ap5RkQIRNi3Lkr0GaaHt542lwgnPV2WB7Io
         e4jLuFX8KbnLNsHa41DBJZCtSXiSz/BiH3A3/Z/i92ooWoa0BaIGEocIFj61Gi5Ydxyx
         llAsuxbvv3cdBmPWvr5RQY0NdxRRBQH5Oqi65g1QpmaZ3ySL4gBWho5CSIrzvz868iDI
         drKTc/cbqk4Rv8HAP5Qjp+Q8V9GbTI83Ddy6OS8XOHQ8ZdcKZUH7cPNnY+TAVzfALSqi
         dge2P3tkbxhaqbbK/wCxY1C0deiYOyIcG6b7o48vwWwUCdTeaNJpD/B8xQtuZTqbUmSG
         weQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530065; x=1777134865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uguiSA9xVG8SCE4+kERAOLrC3CLUPwMeYK7rWWVQ3nI=;
        b=jBu81DU3pceSJK4MNO967WT3+d2qE3tw1GVkwGOF15NEcP7vMO54W2DZ2O+AYIwlIq
         elZ2bHX0FktoGMqOF8e6bEuL475yyXx/S3dMarhRRZ7eiTMUKHRqQLYRhN+KVEDxJBET
         tXytGwiRoIjLcGFY4bqph6umFbPmUdr6FoNiQtev1QhEBiyr3GwDkKVe9RTHpPzdAfnq
         N+YXIzA08PtR1FIAbLV1LSSqiBQM5HNDun94vQEAHdXEibWGHsygCTRhhONJae58XtBR
         UWxz7KA5ERg8z5zpxGrAoMwFVx0k/6jjgNo7EdsbLUwupQmT/Qgc+SKqECsi6FaC4GX5
         oiTA==
X-Gm-Message-State: AOJu0YwkcOzKzAXoU35YPuY4LxDwoSulZVswo5kmZdSrGdRdQpxe4KAz
	0k+pk/lVeROReH4fNrf29PUCaH71oosGfKunImj1cBO4KoRDXc1i8Hss
X-Gm-Gg: AeBDiesu1PAHhBnJUctQryBtv9RofxI0ngLFtfpX8IFwYPAUTajm6V+G/51TRQRcU2M
	kOkLhUxyNu4lgVFh1s45QirXg3UvrhuLc7Op4blYKTlCWTXDJdgqpODW/Dy9jW+OXdvPnxVlMcV
	nRC8j9EIIaC+hG57dE09sa9CDj8I7rCfKvzv+qnOf8vRPFmpPyu0BU72mOEmpZ62oy7hoS3iZVL
	saawlrc0oRncvSgsHaQTveFVjiwOE/lXgQSiS/6yiuWzQzbzuxD3pkS6DDbBeVwsSInSJYrmV89
	EiObYtDyXj76cH9y9GlOANFlYiXfaPnI6nchpo2x4fmGXoGx3EZb/PTOH/eMGYc6rWRoiLa/GRF
	sLO4LvxROsKkg58acitXcc7bT9jSpjU4lXn9kqK0DRFxP1KGzRWau26wV0P52CYXl5ypTOrIBe6
	s5Xu3zVzJ8vSPxiVgfSqq6fjWyx52bxKigDVWFxA8=
X-Received: by 2002:a05:600c:31a9:b0:489:95:3dd2 with SMTP id 5b1f17b1804b1-48900953e9bmr30685445e9.8.1776530065164;
        Sat, 18 Apr 2026 09:34:25 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e4d5b1sm15836381f8f.30.2026.04.18.09.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:24 -0700 (PDT)
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
Subject: [PATCH v8 6/6] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Sat, 18 Apr 2026 17:28:23 +0100
Message-ID: <20260418163358.2304490-7-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y4ebymjdn1btqqwquwbm9p9eg5nnftnf
X-Rspam-User: 
X-Rspamd-Queue-Id: B9FDA1C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776530066-711335
X-HE-Meta: U2FsdGVkX1+bJNe02umrBPG6eQDtESKF88VQXRxvGQTMblb9rcwv5viKc5LrZ2ehfho112NkynvSfibkmRJx4SK1GU4NAtJqUzc0pDFux7JpMgOrPAYxnD0WBLWhi2L69rYAhDEBNzdy/oTpN28UyV8/AAAzgjWXWOziOV906KX9Q9xxsyPn40lDxkWPhutZvS+VgeaUJ4k1ZighAOSUNCHb6j4lpBdeMVnElB2Mc9JRAKqD2Bekq9SjGOIBfGLlbmZSgXAgb6EguUC+ekEeM3T2nXLNvFaE58AzyUXV4JsgD6xZEXiMxXr7LbPd9uVaQhbUGkBusnjzEQhrBYgXnkL9N7te4YQbyZyu3g3kf3ckHzFArngbz10s/RVvfou4pAK9xsdp7LJqv4NSiCchga7/cfFBpaNbqY5AB00FAXCB915nFtAIsg7xCsCMHtK2qzchVOBkbef/XCfqy00xMomig5K8HYEB/ZUu6REW+pIxzVxdl39IdY4/LcYTKnityNyB3LWm1ogAn2tdX9WM6cm8MLrb2AdXpu479apJzHGgYy4d53Sz7ZUccjhmyQjuk3WhbYve9C7tl31bgrHyoarE00dv6GcKBKnCDX3QtIDXr61pWArho8ypGFhkr5pC3t1an8bHGVtfITKfG6gifo1tWYQHd3LuOg7C+tMF6kprUfmCXa5flUU7pFLAfguwLmkwhKCzeIb9PMWHFdWhvkRvEDSnHbY/U1q95X6Ps7coHRzQXvi4CpDcoELpJxph/3uLLHWAkK9YqfeYMmvZobhVdG9xrL+N+h1UOv4YZ2Kqj8QZAI+HjrbTxJpEbdbT5sbmwLtygZzW9BL6yDRiU7miYg4JkgJlReiulXZTfLU5ZEATLCJmSzAeKUvI4S+a38oD8IQ8UA+P2GmQ59ylm84UKnIyMg3ByS2OqucF/OiGVhzj+o1AuTqzRJ0E4mlu4Ix9kwUE/op0jDOxSC2
 xR7YiNe1
 RpqDYz+qmknd4dq2LVkBeFWvByzwRFl4pfrFaGAC/6N8DxTPjBiR/3XWVs0lhpYVnM4RgUOJ0kUoiUzghG2gpCP7X3vEZOUcPkuIwH+g0M7b+TVh7IWaQvf6c1aMBCAQyiN0Sc66sahTlZfSH8Ym8GiRKFtNEAtgwEJjA9CK0boErmBNsQmEvVu7Sn1PPFdEdpdE2kjlNUCDv2FwBOoK0iiIGruOLvALe3Rv8e7kRKaJ5/sXU6Tjj40GPtnqHSl6e4TPDCPOaMLOHR8rEvR6kMdKeBkHnNd357ZE0l9bQHLPqkkkzOvAiKzWnI9BqtTYOp65nvOz3KLGdFZYG7bT4GcoyphSweyJ5/zUezA2GBjVhjK5JW0DIdtBx/lVEFkZteFUjKg6fj2KWHXeUbksspCSMC2PZuOc+CwsN8fH84VZ1DyA43GBj+Ipo5A6EC67MxbNsQzUwyJArWXsJ8mpOnOE0wzoaJ4Pq4aAJbnr5EgEpv2dWQqHhaZP1YNnUTnPrbMIr5UXYm8v3xGA1S1tc66x9idUJqDwnMY8gavPLk2c0d4Hzze5Wcayy5jJ8S6/UyD2kTwbahq7/Ix62Oe4qzORl1NIE5GyOqK3VQQJDoPcG8QmRF7cRfIJy5tl/ppWtnP30skHiWliaZf3ls3MPAEWk7g8PPtAMSK0rqbi7UAsRlavKOfsEzfB+Ul/G1ijFwc+E
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


