Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F313FDEE57
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4356B0093; Thu, 23 Apr 2026 19:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E386B0095; Thu, 23 Apr 2026 19:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8316B0096; Thu, 23 Apr 2026 19:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE296B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:49:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB4671B83CA
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:04 +0000 (UTC)
X-FDA: 84691463808.25.B4AD3E0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id E62BDC000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eSTsRquS;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988143; a=rsa-sha256;
	cv=none;
	b=0RyrwzqMPGti8YZ1M9tQtOGUpS82HvYXbyD4SgIWZ+8vRyXkqFeu6Y03rVRzPoqXTIS2IH
	FG8qn9tHVQ8lLbnRiaIKDQl5+ZqL8GkDx95/cIn4AAzWWdlF8AWmrBV6Lq4kw/DAzGWcwq
	vT+aUzO7o0uUxXzja+K1ML5hcc+GEDI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eSTsRquS;
	spf=pass (imf22.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lDwu8Gbb329Ho7MTScUMWrS/rbRC2QHTMwbPQ3a3YM=;
	b=4VFlIYalCTd3grDBOqDsAKdhsvx90cbVDk2u1m7rNCSvDe80DMQOEwPfA9q0fCpYH2mt8l
	G9KYBr760bQMJDaewUTc2U+mlzPe5NrD6uPZweQnPA8jIKVd7AaT7FKsp7jJ/1sqhhl8kd
	LlBK0O5wskZWa+fAnkkceicTuRS2UN0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso53098995e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776988141; x=1777592941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lDwu8Gbb329Ho7MTScUMWrS/rbRC2QHTMwbPQ3a3YM=;
        b=eSTsRquSLFyTKJKT2UaQTuG7TY4mVLfFFw1Btij3PfAPgxi+GLWz1PPJjpPfhmkxjB
         W0dit8+yMzQozbGP+dTqc0WZYaRlLvfwdB/5Pkhjgm1KFGfcnQNX0TU5p8WRH7WZw5Gm
         Lw6of5f2530oHVeyMDxPPQhB7mvWYTrFMYTtffqZo8CNWX1BugGbjPTpYyr13g2Ko4Sn
         055ss9TN37NjTN1PngzRPcz1xibjiWSd+wGBdGZMd9dwVGDWO1LA/8ou9mnp4qrvjRnd
         sfpNsWlRwpH6TeKtMzATocL4M+3UDZSrsfY+CoKGieO6d3wcAwRy5aU3Lp4bqdwuUawU
         vtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776988141; x=1777592941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3lDwu8Gbb329Ho7MTScUMWrS/rbRC2QHTMwbPQ3a3YM=;
        b=f33IjzhWtjifP2osPsFbFkBGXZQILg84CnODdM8ZGnYQiame/K4Fuv2PU6lfJo/UIs
         OoeF9C7UL0tBRbMhi5Y5YSWMqHUrUUlPxXRIh7G/9lnBF4mVaqphcizQ0bCRwfeiXX+q
         t4r7btiqBG0xrpVu9P6iWrlgAnkYen5yG4ExS0kkmqFCJxuxENXKGhyv36DJfsddFI6q
         pq+17uzJ7xZVbc0ZO+yXvhZ5lx9DXkgTIHprrCUtu23Ui8gYykR4y8c6dcEqCcYs9kDI
         njDp853Ntk5cxTKhHzBXDNDy8VwMLBC+JIHwKVVAsnfhD+3C6FfVOaiaeSu4+DASId+x
         ct7Q==
X-Gm-Message-State: AOJu0YwpUWNL+K5p0JaC1/jN01P0FfhGv7NU91zq7j/cDGJB7s8QvDxT
	+tm9w9gSaEY4ALWrfDYNAwEJPL8+Mn0BwQz9rYxXrO+WJQHhog6ITze8
X-Gm-Gg: AeBDievqgcdtA8HJW7VvMc1DSlxomYd6wjmEaF7XIhEibj8fTTEwHuSjLq1C2G+7yfG
	rMvUP9R4nBZavCn2rYGbVtANq8Ma3Qh0ORj9vnDSJJ7+C95EdXorlvpTP3kOb9VNkGrU8PvAUWE
	obPybXVXq76lACs5kty//OZ7rQWtmz1aRx9irqSgfUVqDIgQlfS1K4A42uIVaii68FRFfPpYLnC
	WRIB85gpG/bUvTrsvPWpo+NEvtVUpOu2riHsHZ3YyV3fbiiiJsChKyzFcT3mBvOtzF49paBwLir
	xQ1ld+fOo+Foxa981ZwwAJnfTYqooz7a/kN6x1QZxgV5SSQGa3kweiBJJRC+PHza/EGXksNf4Ze
	qWUhuQ3dAjb2FvB67ShUiHR/7DZSkRb7s6Y9Z8E7J1BVy37Pj4Vo//8leF79wJAG3IcEK13guJp
	SNXlei8QMZTUtdf0miR3QrSjmAKUQhJnW2OVuf76GKxX6LM3RAgQ==
X-Received: by 2002:a05:600c:3b14:b0:48a:52d9:54ab with SMTP id 5b1f17b1804b1-48a52d95604mr251358915e9.30.1776988141226;
        Thu, 23 Apr 2026 16:49:01 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e8d7:434e:1f34:2cb6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb75c695sm164971395e9.14.2026.04.23.16.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:49:00 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v10 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
Date: Fri, 24 Apr 2026 00:44:23 +0100
Message-ID: <20260423234753.3873095-5-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423234753.3873095-1-luca.boccassi@gmail.com>
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E62BDC000A
X-Stat-Signature: 8jpz9hgd9r6n1m5j5t36b55tbh5ey6yi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776988142-391496
X-HE-Meta: U2FsdGVkX19g7V4eFA0S3JtFNXmsnL+bdNVaxzHBgW8R9fxLKUUvrQ7jtENm5qRi6rBDnl9CZME9Sti75wooHU6MvcJqaGH+3qZ//RJGTiBrQwwscBjxImvN0oGI3KRfrZeWCD7sNAiI4l46FZ/AOZkJnkOJscDiKYxfKb0X/0+gZ5c2YLgTfZKCamxMfvlQATJZREwvnuHDXD3FFkZGwKYzLHmU24Ds+0nYrEkM9/YF1mWn4GlBhJWykq3v1O+wlGoiOfrHBi1wNY6V26RCuoD65qKtYnoYXNkOIxSFpKqdUW1YxE/ZfK7PdMDyek8eTuHRzoKo7e9He/07yyYUQcs3EJSN/GQzEfiQHTYQJRKuHlch1V5V0kUep7WLySUtBqEJBfBrrZdsruvl/YDKL8/o6sov/sxhlhL+3Xou51+u4DEGzWOLZ3OtPfDtGtjI9wSOuIx/MEQj7ejRA0B7rHM5w4piLDkD9ZeukkxLVAysrfx/HTu5KuQHuiEUq658htOYv7/tdEE6eY6YxXCURnqCfvjxmppwL+PXHvMlfwlvLcviTuiOyqXLHeHJ5fq0t5K7sXzOMaK9/BDo4veMgSJ5Iu4xpgpLxgHUYoLfnUsOtrRXx5h3OQgtXdHH+tjVcPVb28tKVWSFKBv79JWWBzRA+Jk9lePQEGa5/2wQvkz7YiZGR3F7fVQODZ6BzzwaZaa2BKR+HSFy6iGqQpQDce5YavYb6XVS04HEElVqj1Tqpm+12o4lIzJ1JYk88OIRTbd6S3uiid6Fb45ZdZP8x2QxASQpxnqOJu52irNHK3F55bMR1feG82o3oWrN3Vw0gDajSgrnp/aRwxeCYMd4Mh4OvPK4VG/u1AbBKSAQIg+4+MaGoAhraH+8xtHTaMTYG1AzM18fuKOn0eKnmGqMzwkFzkxeQxnYMouikyq8LngHP9YV6clIQoY++N8BgxY2ECCgHIPYx9sKykiNTWq
 8evYLAGu
 olU4brwQzUonwJsGsSdBaZZFHFf6pUE72Doox3ZzCtgwEjK9yxc8zCk86lFxwkboxSEc2s8tvmFDWixu9IVypiOWJln0RkbzbhkOSRLg3uCBUCWrkA9nZIi5ctMlsmDvYV1KFGvH9JkwKZQnl0G7wWCnLkpSrPTemmfcJUlfZP1u5wlwuZtG62VtQmWT8MlAhJTat5ysQ9g3z/3p4lsq3anU8v0WdKV/X4EvRbfigMIFCWaot2W5cnTwSsmP6uep582wh8mNv74C0rjgx/oX6YXzhXj1W3p2Lj7nU1NfuXX7WBrUOYdVH+MndZZWbMlvXd92g7ntlJ0yorkePYRPKHugAcam21XqbvQ1hAOo0no4mV3jlaIVUV9jLTMLofpeszhwVKt53WTOEYQrdRuLRw1FJLYgAfgLRWb2L71HNHORvJtZFJgR4SoT9LE1z4GhujDCAIMIQuabEtQtH09Bj3T58oTI7ALDlWRIdCoQTGE107bNssDu8rXtSYgD1Q6hxlswQIZa7aNFNdT9w6dNwGqL98LaFPcTXm5rh85eE2f0tz0huqqcvFGHJtJ0HCPofZfbauM0/QeCPreSky/NK9Jwb6cpGK/kUtIr2W0lOR2ClEO6MkbqbXHVOspHEnp2GSmOKTgY/I0njqgbsw99886Gujw==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index f0a8e600c154..eda832125809 100644
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
@@ -387,4 +403,59 @@ TEST_F(liveupdate_device, create_session_empty_name)
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


