Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 560C9CD13D3
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6386B0098; Wed, 29 Apr 2026 17:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577546B0099; Wed, 29 Apr 2026 17:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C8D6B009B; Wed, 29 Apr 2026 17:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36F106B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:22:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0FE61A01A9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:34 +0000 (UTC)
X-FDA: 84712867428.28.0B6D946
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A5DA1C0006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEJTStE6;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtld5SUkIp01JJT6a8E7AwwCws3CqpUZMHCHkcwnTLU=;
	b=P5OasspsSYTSm58BWyGL+U1wa/SgdF9Sda0zPD6T2f43+58YkS2Z4gX/hY0GedTtz68Ve+
	07okPjeRgpZddwdwxUtmlDsfG2xW+MwMFR7Z4fKTsGLtVE+3z3+z4FCS6S8z5WHRH/zgc2
	SO15GnSWQppVY2b2X2Sc1BIlvL5rkq0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497753; a=rsa-sha256;
	cv=none;
	b=dTZwyRk3tNhov+wa8DyyVMggNkK4pqg0Whr3Eaj4YB3LPbNKI64AXugmxk7pz17sP3ehIU
	u+7zF3SPBIL3bQ7LfbpZoXBfwGu6QSsz3g84zijYUxgHSh0O98mDjoid0ejY30VM8LKJUT
	rFcaVbUfvs2Im9KX6iQ2sebEyyHGTAo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEJTStE6;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d75312379so852773f8f.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497752; x=1778102552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtld5SUkIp01JJT6a8E7AwwCws3CqpUZMHCHkcwnTLU=;
        b=MEJTStE6UXMm9luti37vfHjD903aHBa9bVPc9HU4gWpEYPc5IG6ZRxiXu8WnSkZhBf
         3HjcesOo5mxsleeY8pzzX72dcuHRHrstF7RmwyUhuacpRyGbwVdqEX8KXO1jOhewbJjb
         OWl9keAKMmu9CSR5/WBEPd3tLYyRYlRN15qlPqChHhYDuK8ZbOKtoGJ/V109ffbqwJFU
         9UKtUgMDnc4QPfjjOIVmIPdOGC3/FTStVY1NKdq5PJUj6W18Q2Q7Or3+JIlyuXMHDGUY
         Wnoin4a86cgzo+Ts/ZZOO2bxA0nuNlgyVu1xK0eVDtLO6pxioyCAheA3RUkAMMNg8s9J
         TFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497752; x=1778102552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gtld5SUkIp01JJT6a8E7AwwCws3CqpUZMHCHkcwnTLU=;
        b=LiDRbDF+TYAByO70lU2QQ9Dg7hEDtLu4BS1QkgO2s1wCi3GRQ1kZyzjsmsqHFP7PO0
         PlXHuGKCMEOduLxby+5jV8XKau6TOU+8iIjDWwucRZTb/P9R3VNIrl9vCdHFOcGwr2Ox
         fuieFF0a7xdex4WmO+A/lu9eZ10kCALIVVsIIRTQY0sAMgyI68TSFjcT3xkWnWdnkfvS
         5yEMqQMMaQKe2mpEAQFDvhhqd5uvb6BPFliI5hCUioOT+xVi8hWayvkdPpVW96enwq6i
         H7G8HgrhzGARQGD0yn9pM3JWFolLCBID2baUFreYyohMQtjGX+ryWmGnUfGAgl+jKz4t
         WySg==
X-Gm-Message-State: AOJu0Yxz/e5VCQHXSovYBmNS0AX95o1hr2LPkJJ9TdxxwVn+60BJ0H8J
	ugl02e+mln6qvA2dlpFGC3tQ3mXms3M49+yKuWesDbkl3LnFGUUe+bSx
X-Gm-Gg: AeBDieuvHqKZVAmngi80o76x/U47IJTKYED0/mY2DeHbywjTtZsW50h9qghDJ8V+fjn
	xvb1hFvDo/xH0qGXJyM+mn4q2nLmSalPYAv9fuHcx7ys6juN5wKCPjbR6hVhePD9lt0StOr38WC
	1aeu4WjSrbHTwt+yl3EJHNSXdChAfeT1IKmfD5zzuupEHhkjJKrwlKEf9/xZUJMwEB1am2r7GLo
	7cpBbY+6bfhEpv83dou6DAuAc4IS7rS0Xic44YwqiFe/0xY1Gi+769kWOBUAK4c6+Prskeq/rNC
	BnY+eSNlHdlT09ATb5BbufsXZ7nl/r2vuzmGy5oPj1jzu2RMeOhw4ZDKQ0/7y9/3CttfLy3kS9X
	CvVqZ8jSh3RoXyLrM/08qbiRCx9OKrZQ9CHQBAlXyH9RK4uIX670jp0WZl2HxVv3JgUyha5PF0U
	yjKSXikekpPGpExfV6gU5BZ0oRMgWd424xwnSbetc=
X-Received: by 2002:a05:6000:2892:b0:43d:2d34:8963 with SMTP id ffacd0b85a97d-447aab56f7cmr8979841f8f.17.1777497751434;
        Wed, 29 Apr 2026 14:22:31 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:8fc7:44bf:8aca:ebae])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-447b76e5afesm7092080f8f.30.2026.04.29.14.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:22:30 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v11 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Wed, 29 Apr 2026 22:21:17 +0100
Message-ID: <20260429212221.814107-5-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429212221.814107-1-luca.boccassi@gmail.com>
References: <20260429212221.814107-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A5DA1C0006
X-Stat-Signature: qcb1jytyp9bo9cr1ntya5b4c4wce4x5x
X-Rspam-User: 
X-HE-Tag: 1777497752-224460
X-HE-Meta: U2FsdGVkX1+uCHykyGyAHY3wWrq3YdAYG4+LvQx9po7esiR3XfAUVMK6wKmN6z1uJozuUMs/Ey+G5h2lu5jZjKPM87lWSkT7G6l1p91ohC1nel2rNcISqtOPsigV7J47WzxjD15U8paR235vtCxIfVo8ce4p6xbI0qithTFkzrf7KbCkWcSB6/Atlez5yMx/HVlSmhXMkPmzZmBIHXfNN1VW3f7/SWcTBWLdYG2/VDedFQ5kcO14gCfjG+H0UeJR1Hr3voIqXtf6pf1B3zauwU668L30P7GCL365Ot39gxyHvNtNOFFN049i6zZT0w8b1s/JaGF/Pf8eUMfrvgc214pvHDJkF5YjWF66hpM/qMB+ieKqpT8xrVWJnfeFKwKgqFFJC2SjgDeb77v8xIUao5lkle5JG4li7bz6c6SPzQGbTASNnzqQ8vcBRh5aLjAJ4jvfsWAvRqK3i9OcHBw3PNFYeQa7bnjpJpNHg4/tUWTiXpeX8KNyVCLqIgAd+DuJabK22lW580Xvl2aLg0QrBSi6CcEVzI+DhVXXzQjii3rDanQ8CWUSeznQGqf5GZHH7qIYKBhZbVncztoDYBUnmwv6RVrZ7cJahL5aTewK8D1yoC+ZqSFgcLI4F2qIwHdkOfoloQn2qXATJHHJCqzfzOKgbkRLYJN1S5OHYEcUdSPJ7QbeNsfEHaR5qh0ZB8AZEqe1gTDA2qfaGNAoHr05aYCvoPWsUG2Z8K5tlEIW2YtrXCU6fhiLvCgYODayVxyxFT3rfb/UtqDpVLVBA1bnhCEVWkP0YU1P8RF7lgUtf6DPa/ovInOn6QTifF/3dZbhu7SpciD7oJnh/+d4EMSXt2Ddq2Am4ZGstK7+fAq7WcC3eifjmmXwnUxy64wWFgIXFDGzP2s+R667FsJxtACxeKkDS7KrjxryW9BIpO604wKZnHFKcQFQJO9Q2dfwaDPyCO+rDfK/9JW3DLjxLNY
 ZyB640Dj
 eEY38C+Q91j0oTr+Ah04UYwq3b6VqP4zMHBhXV+sW6bbFq3dqgeckmCgEVZwpGJ2BbvGoo9pPdbSRzKs5MW2UPEusslWXbrgVm2DFh9UYIdwKbS/QgP7fEnI4CyeK/MIFVh2boYPbJTOojikP6zNb6ndElujT52JfhIyVztmOO5cBTJOv900VQsey5eK58zZiEEp926R+4/+upjNLBfYx/ZBl0v5LWc0qhkfixVdZKcnlLQguiL1ZFD14uThzuMta2dVdovP+KffzgzUvNVu4f7NzhX3UYecuntsreblGh5MCv2K9d5F0Jc8D1FSuuyI2s36hv9wrrHmarSBHTsxZqhqI14k/9OY1BkL8JfL9Ghw7UusrDeTWkvsgnMr1JhF37z/VHK/+r1VAI32kpHIp/lwhreECqQOltyVDpEFPDQocdCMBuJZqSblQ9LK+Ml0L0ZtR9Fvri32rL/OoOcS+Bd0B0jwVxmr3NuLsHIq0y/pLSLeF60zyIjbNfr6tESYG+6jjY0D2nyqmfZaJLY1AuJ6MdBI4OqQbIB1Kz48LM0rBhmITZ9YgRRZWWOQViaIihBp2eWaXDeCXGw4Q6UpGwMpEZWSYc17BMbDdr92UiN26YgPj9ZBqA5r8O6/S/AsjOUNVrKTRp6qddNLK1J/7Wz0d6Q==
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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 90268d86684f..c7d94b9181e1 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -102,6 +102,22 @@ static int create_session(int lu_fd, const char *name)
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
@@ -428,4 +444,59 @@ TEST_F(liveupdate_device, create_session_empty_name)
 	EXPECT_EQ(session_fd, -EINVAL);
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


