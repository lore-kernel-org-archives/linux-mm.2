Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D0FF4213B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76316B0096; Wed, 15 Apr 2026 14:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26C06B0099; Wed, 15 Apr 2026 14:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C6F6B009B; Wed, 15 Apr 2026 14:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C25AD6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:46:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 611C6C2045
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:46:55 +0000 (UTC)
X-FDA: 84661671990.25.CFF1F8C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CA271C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:46:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q5S/5fYQ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278813; a=rsa-sha256;
	cv=none;
	b=BDT8UODZXWjeaKT4jbjIpCQFismPWoEnqExDSiUEpIKgzGJ1RJmTCIpgZkBfeWu2v/p/iQ
	Pf98c+tvMDuPa+CjlH7w8JxqQ5NJWZIR+67CLRhfvJHEMet88DGUjKUjQgt6QBeuajKDgL
	QvJF9d50A8YRBjQ4hN7RvvJjCz+UsLs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q5S/5fYQ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BphYppqYDh7wB5j90/jJR2V0IBmnVZp6cAEOzQX6UH8=;
	b=OzNZ5EBWKYbINB92KmN4YeTkXXKC8EY6uPYw+YfvI28EdSlM3nZ7gEVl8kxmzyxwu3b8ND
	Fn1YEbYNLn1GA3m386xi1s6hI/GhqRa6Ga8ZDwyvqD81zMnBDwMvjSiQdpwvKSZ1dBv0kR
	hYbesuc5sKGye5Fos/jpXecuNN+18Ik=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d6fbd0954so3154722f8f.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278812; x=1776883612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BphYppqYDh7wB5j90/jJR2V0IBmnVZp6cAEOzQX6UH8=;
        b=q5S/5fYQYLN7Pv/9NDFmJhWDSPaKCoVMmfG49LQoMPCBLnKxrladySbW9f5OTM/jql
         zopa7N61/tAt5CiL/jeN/mSwlqXgqKI1Y/N8Beeo08o55dq1WP/ebZInO/snLy9STy0m
         akCXvLV4eWKSGpAaFQbvQTrtLg6plX+LwmChBGqlv8PhApgGjKyhyk9hQLv5tiZF2GKu
         Ci5vPEKvcIhZh3osqj77ziMNyhDFIZYrkU7VAJF2jNJycNB9mBdMdVs9Yri1C3RYYUjc
         ybEhl4Sxg0rs0M/mA9g5aTh0ErOjdD5QR5LefMBCIGyR9/uYG84AeQHO0tVfH319whJa
         0gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278812; x=1776883612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BphYppqYDh7wB5j90/jJR2V0IBmnVZp6cAEOzQX6UH8=;
        b=S6zGbUgqYEPgPDnSjTzTD3D7u9hi3a+z85a5tQmufdwTzU31tE8l0rQZlZgepftdbe
         PIMloC0neFPrPEBuoUc3GqOinpM8GkQyZKD2X6QPOReRg+pJO7uNnR3HFuulLAVgQwAV
         dL1JLT7hsFjjEkDwsC7PwVycqLSechvugkl3N7KpvimL0EKekePJzCn3O+nWlvfZip2C
         Hk71O8EtEfi6wzqEXHJsbSXBGNjuQSGjQBQuGnfZQlE8yl6OIf0NomYEjgaYDoDI7Xia
         I2nGdzSkfIpXWebSpsmsDJJ/bX7dpgAcDFla376rE5qt86CydYClQy/fdJUOus1fRlf9
         Ak+w==
X-Gm-Message-State: AOJu0YyQvb4GTICIeqe+Q/rIMznpCMFMn6vtkExMH0rDY2pBrzvJfqAE
	iPEY3Z5EFQDFhkTjztiWXIbyv0uNZIrECy1DdxFwjjEi5P+Mrnbpn8elKk/CyUvC
X-Gm-Gg: AeBDievkYAjqNsBezs4EetF2P25wOpw24RLf8lg7FWeuBBpDR3MDvHTSWQnOND06QQF
	qk6WDinHGrhbsJgQmbjHAr4LSaGVCrd3EuIVmycf8FmBmkE1qHusljn4LO4PhAE5Y3KxFnOdP6a
	Dy5ikBm4wm3WhNb6YvXZIpDwCEYVedvUdMO8QOB4UsrlujfX6wFoUhYaJO7TPVhA2HinOlc8dda
	rmZLfivzIEQrzuTfkr4y4LRRuubsJwlzhW7EwuvlhK+Gm/YFIv915jDOejyr7vBtqpaSlQz47SY
	6oF0BPEHh+hsxt2MGJ5SxKrMABjgdGVk/D2XOXIpJ8xRbOBbVBjaU3Yp7WDQyQ/p28hU62ibiJV
	/psKNQjvRsa2OGC26yu05Mf2gv2FiCRoo2FV9oNzzGiTDUy+meP2gtQf5vpxQTZvrHD4K4V9Ecp
	9BtIHq5+VPgUIrTjkj3evZ3iBcT0a2
X-Received: by 2002:a05:6000:1a8b:b0:43d:7e6f:37fa with SMTP id ffacd0b85a97d-43d7e6f38cemr14920036f8f.19.1776278811888;
        Wed, 15 Apr 2026 11:46:51 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:1648:8c4d:e867:9ebb])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43ead356616sm7204165f8f.13.2026.04.15.11.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 11:46:51 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v2] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Wed, 15 Apr 2026 19:46:14 +0100
Message-ID: <20260415184644.1155360-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CA271C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 19k9qr4gocckduq38wugz1apo73kowhd
X-Rspam-User: 
X-HE-Tag: 1776278813-929690
X-HE-Meta: U2FsdGVkX1/UcgTXVx4SF9bB79yJ0bVQ+UTGsgPspAbBPGylcHGz6nb11W+4BCg5vgFFKq0DM4qdCE6e2vzxUllBQyzuLrnfTHxTVSlN99e9dT2ydnuNnN/pagPP0s6gB1sv3IrrDuRQW6xLrGRcexx+TKqFn3K2D1D8T2RTA+tuI7RPNoYTRDzkmwIC0KeiNLN8+Jk2hWZBFMrYocPRG1BMpSi69JNOFVg2DwTJecaYW29U1Zdw19f1RV0uQXN9pel+h8dV+7AkPOb8OpipC1tDQ8qAsyFFqQd6yxwL/b2b8qT2hmTpIfjkFep6C3C3MOG5Uh4wknA+H/IQQeSFqErkOXNMvfyMeOz7Az8RDHUtilUzMmptjfS8P5mvGDi+w3ZxWQh8DulTGOspVrfKAK8wTLCwnzsgC4o3D4s42q7POh+PWegNJMwwv/2CfIsrulWaM+OhZXkEJjIeEEIIW+4xIsGKTPYEadaRpLl5O+liV2fap+YLr8ANZ1flXC3ffVc3ZBdUjNk9W69Ds2Z1GqQwOKcT3U17ByAm6bSvZgmXf/q3lVma6E0AuryBWvCm4vZApNZcPCpY13S0+JEbJsWIQBFwcJjtsoRihAMMzNwZUfUaxtUbvbFoF1Bx9HADR5PkpIkM1TuEQXGl1d+La8/wjVZu9NCN1g2ume3MQDZOC2lcKAVOREGQ0ZFOtpGiJuic/ZwGZlTX0JNSWOkJWDmlFsvhhLsl6d1VaiT6gRT2McdM+k2YV4A3f5Quu5iuHPbZHbcCVqhtzG6kSx2GyNHABetEBGIdmDZ6kVl+WvBDcB6NLL2H7tvDAqTn91BVTsag8vEdXxRo0FpwVbZOpIhYvNWLzgp3Fi0KK57zQNwZWgGV795PzbRak+/sK410CqbTpKSCIie0lN0M9JYZUwPUc2z8iWoQ54UHHAYj0t4dt3pk79g1N7O7oy31x2eoEKLoEmnWwSh/uJvntdE
 PiDXbb0W
 8JFHUtmLWAWj+O8g1/lHkkI+O31RFedEf3y5YMvqcCEi57uv70DzqH+tWM9Kjo6VgaGIF5hSVcHsUEQtWa9gvx8s8pkyUrHS6ACgzImaJomQvFjnFl0U73xqxInggNVlAT2Guo6n24jli8FrIjnA8LbNA85YZ3LpWTKtuOYnolBagf0d9brV8rvg2nBv2Lfr6PQRZAeBF53/VEVUYP/2eqL7XVWNSLDKVgl5UNa8qJuYnuZsdDcru8hNkbbjkU7FkRbpFrzxddLlzfhGTi4sSEpAYjZvtlsFDh1wF6mlEgQrEB0C31WaBlFZI/J9IxVk2QXZfZmR0AeK3MCoy+JNqA9fF6s3pNNpoqrdHSq8sl4lyRqa4tpEYP0bggD1AItn0ra3nozoKOn/B0b2ec/uTIUOQYaLXPiSZwMpp1Qf4ojWNtGtsa+1hOBOeWrhrEZhI0Q9wB9My/rbpNT2l4AjwtWR6QrXwQ7KBS739XdmD9CHCUe1oXHJnRHkSZvb/rcuAS0V2OXLhz+XDMxn8ZtWjn1eZmbwtUVdLX617UuljGL8Ws6tjKQCNQDpDKjabIL0ZJkGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Userspace when requesting a session via the ioctl specifies a name and
gets a FD, but then there is no ioctl to go back the other way and get
the name given a LUO session FD. This is problematic especially when
there is a userspace orchestrator that wants to check what FDs it is
handling for clients without having to do manual string scraping of
procfs, or without procfs at all.

Add a ioctl to simply get the name from an FD.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
v2: adjusted the commit message a bit and rebased on liveupdate/next

 include/uapi/linux/liveupdate.h               | 19 +++++
 kernel/liveupdate/luo_session.c               | 13 ++++
 .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
 3 files changed, 103 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 30bc66ee9436a..41dc44d239dde 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -59,6 +59,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
+	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
 };
 
 /**
@@ -213,4 +214,22 @@ struct liveupdate_session_finish {
 #define LIVEUPDATE_SESSION_FINISH					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
 
+/**
+ * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
+ * @size:  Input; sizeof(struct liveupdate_session_get_name)
+ * @name:  Output; A null-terminated string with the full session name.
+ *
+ * Retrieves the full name of the session associated with this file descriptor.
+ * This is useful because the kernel may truncate the name shown in /proc.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_get_name {
+	__u32		size;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_SESSION_GET_NAME					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d77873..af9e498206d24 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -289,10 +289,21 @@ static int luo_session_finish(struct luo_session *session,
 	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
+static int luo_session_get_name(struct luo_session *session,
+				struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_get_name *argp = ucmd->cmd;
+
+	strscpy((char *)argp->name, session->name, sizeof(argp->name));
+
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
+}
+
 union ucmd_buffer {
 	struct liveupdate_session_finish finish;
 	struct liveupdate_session_preserve_fd preserve;
 	struct liveupdate_session_retrieve_fd retrieve;
+	struct liveupdate_session_get_name get_name;
 };
 
 struct luo_ioctl_op {
@@ -319,6 +330,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_preserve_fd, token),
 	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
 		 struct liveupdate_session_retrieve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
+		 struct liveupdate_session_get_name, name),
 };
 
 static long luo_session_ioctl(struct file *filep, unsigned int cmd,
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c2878e3d5ef90..bdc1cedc4f944 100644
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
@@ -345,4 +361,59 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
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


