Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B75E2F8E498
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 00:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32CB6B0088; Thu, 16 Apr 2026 20:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3EE6B0089; Thu, 16 Apr 2026 20:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF96F6B008A; Thu, 16 Apr 2026 20:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B08D76B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:39:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5381B1B8F5B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:39:03 +0000 (UTC)
X-FDA: 84666188166.19.9FC0AC9
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85CC21C0008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:39:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EyoxDuHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776386341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wonoc5490QuGHhln27veolm76wdYSRsus2wubp5nw+8=;
	b=4U33PDVtjjtPCd4DCiYTZe557H76gANtshIH9MV4NhLxdO+keQKtAadREvvOpPDYDaiw2B
	Qxlo9/i6ahZzOp4U00sbHZq/BxRkO4CB9twJkmA5J92mm13EKdDKbToq6poOH5XTdeLHc+
	qwFFT0oIFFkfkRGeBjWK3tm1fzfNjS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EyoxDuHR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776386341; a=rsa-sha256;
	cv=none;
	b=wkY+VrdCXeHe7jZvmOT0fu0eECV8r2HWfe3oV75x86i9uUrW3bpi1zLrk9knA0WDy+MgBH
	RIazozeNI7vL12ESlgiYpsVTkAxLO0jh1a0vMkcG8q+1QxKXjV3BOEStUAmw5OH3AStwY9
	UK5L75atxLjkq6tE7xVmqethDIp/NIM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4887ca8e529so944515e9.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776386340; x=1776991140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wonoc5490QuGHhln27veolm76wdYSRsus2wubp5nw+8=;
        b=EyoxDuHRKnG8Wvyhd250WjM0pzHRZGIPKIbOTLxTcvCM5Mkb5zUJYzu9S3GaDVIX6l
         /M9eKQCfNi1NpeshVDut6m/CBR0pa5T3pJJK7rGYWcYWulf9egiK6o+HqMzzCfxXW1UX
         Ir/q0a+PXOfi3MZPZQA6AXCnNkVvq3Cvwz2q8I75YAbXINXr10pRM1OqlA8ThSBM4fsi
         KUZlxQnU6IWscCQI3XE43VzNK8nXfi3efe95HQVatqPFneLHhbDgKCfZz5jl+a0h1knN
         7WeDUqS9Y3tUV+FkiGL73ryrREKzGflkqJcXZ42+mWbaiUKGRNbQtjvAW/h5WfdlnjAL
         f23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776386340; x=1776991140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wonoc5490QuGHhln27veolm76wdYSRsus2wubp5nw+8=;
        b=a1OwxAcl59ZBJMYlSEwZDKSV/k9WDXfLpfJADyDhQvNTqBoHWYnkF3dSh8iC4emsEs
         37jvDN3oSgtddOoKYnZzFwpdOGJcNQjvqe/X5x+goR4IMNIk0Qz7a4pOU113nuj8e8rs
         dfEm9PrwC3C/oWZ751/wBfpMG8kou9PVEBY9UUD2vSbsQlH0tGHyoW8EML6QWmSLn0cO
         ++IE1wZ5ilyMxfi2Acc/J2pBdqkQkPBUHwO24nTpjuV6wt5owKCZrdKyAAvzKgDS3vwt
         vLGMVGbXZ+HYycC+EyeFbFMnYKXQLK+yEjzEjxCNu7L3qdlnx4z0abE6gYqiQHwsoixX
         MV0w==
X-Gm-Message-State: AOJu0YzWwkrKRbPAwSYx0047aFXcCmdBa19uQGirqS+JSbW2UKjxCILq
	KGtxFJejUg4JOiah/opxr29k3Yik2IpTqcO3jL7tW7Os7hUl7us40518
X-Gm-Gg: AeBDietPDyMdIxBsHxnc9xxfqVyjF0xDF6apAAz4UhiKG9eNiHMIbFWoCpfI5vQjvul
	oj4iDJu6e9GE1SlJ4CvCcfU8oNmAWUoIyJBsXcaQARUKiJllG4czG7e3yy8X90nhMjcwVibTzye
	Usbjnmv+J8jIcapXA+gbTlisQJuiLfyN/T5yhypHp+tqssJzF1ZJJx7ssJbWBaZr+69rAoBZ3o2
	cl4s+3+zoWKQEhzI6nhPl4iCoirFa9TjjKRDoUkywbG537r4fvziKb/8DOfxbC1zz6UwipEjgyM
	UliNPSD+LcnBfVtOjoH2FKl9GMHO8AsiQdKRJT5VKZDDGk2TvJThtQ0ahdldErqo4uQh72Xmrca
	/SE8y3YyjyQNuySQ3/UETogqZhAFE4UPa/IXujcND9kQtr0tfH5VG/85w6Q88UgYV8xTe776nkJ
	+jTa3zAaCvnnaJo9rvzZNG3dm6Y0+Ke2C7t1Ra02U=
X-Received: by 2002:a05:600c:8884:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-488fb88380amr4504715e9.3.1776386339675;
        Thu, 16 Apr 2026 17:38:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:f478:3ca4:c1b8:70d5])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc189f2esm2442535e9.7.2026.04.16.17.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 17:38:59 -0700 (PDT)
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
Date: Fri, 17 Apr 2026 01:36:58 +0100
Message-ID: <20260417003856.1525287-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85CC21C0008
X-Stat-Signature: kgsa7erxua43fpx3m7fcec3x54d3j5z5
X-HE-Tag: 1776386341-408083
X-HE-Meta: U2FsdGVkX1/zP+0N9zl0qPDvMFjKdC5wmQ714aBu+t9p9Ptw7EHxaONkROVE3NwIkd08Vh12W8xOgiRYqG9ABYGHgp1F8Z6g5PIzOOq1UtCpO+dIkdK7IBGAGvPv1wbOThVh8dvdGL2D98p71iklNw/etirfP/s6hJYDINC/J+xCpaROKtfVEKbQeIPvkzrXcXgrsZFrQJerGvGMlHE7CuOcbBZ/AcADZwyoK4BoT0U9vZT9/j85HldXbzYttfp6xppXO1hOK4UpZDSKIVCWg5qqDLWQNeP9RXVVVPiSc6HTAAQs5wB0GB7KoIjkoL+2IrqRzLaVSNJ7qYbHnSh82sFQV7ntS8y1QoBLZz7ueJELYtszysuw5mC381V6HuK8uwhHqwn3ho0PunOjZ0hVynPr7K0Iegc22VebH7XT4jqRh9RQSEV/maXZTUjlh+G9EDsDk2OC5m3nSlwn/koGO/p4b171QowvoQ2nmVISJp8R2EZ1n8juWRjyi6cz5I8XkrKMZw2I1shtsrM5W5mZmnGgba8har2fmkpRITIcRatykyriXQfUZAkOQScg3FV/AaG2Ad2fpH46DG7Py7mPR4m5hGANGu+7t0elb+eZsfJIf9Bu60O5lkEkjwl2DERJzc5jqO3RHy3EuUSKPtYGYhbjraWx1X4PgmibiD1Gw6wSjMf1bChXENrr02Vt6VPhGQq19nDNW66J482VrIoxKG5LApow0ZPXncJ5WR8svdwA3AEzMmEjqAUNZO9d3FuUWBIGo/8KmDsePS4Drd/nmlHPWt2cP0YmqKNTN3tqDXKyX9PJisKRVCo3jS5Tf2o4di1U4oApNXoAver2PA1R2z9MMMESD5qg5KeJtmmmRSSpOpNAxHnL5xNy1JuY33GS8vFprKQwpTK/A9EYMYYVK4W783eX9PBhCnTqGCbXa8yX6CP0gyx+bBo/jRD4Fk0wLf/nHLdqDU47L8hRSn5
 0dA3nUwS
 CGVd06CBjEgrjeY8JJeyjq1jRQJXANja8O1JdOwLstLYV1wdVwRbup1VsIB02wUB3o98Sm5gt1OI+2QiXznvYlrfyLZLsHJiiyC4Fu1zX9YgGfwfi5dpjFYOuXh+WLef9hn0PWpAI5tbiaX5c+I8y1wZhR1LVlxtq/vzWRX7GKMvZz1qKz0EhSd23CZpmKxoTTOsuCtz9xqHwC9z60qVT+y0zWaMWmqZoCYndUtwNs2u4sWmx6EgIvVOWJoDv4yM31EXuIuKdvbie98pJamgnziCQvZMhB1Zoyo+aazwQF91Cvv99MztMpRoVzpcOlje8JCuzgvDgZf7VlxRZwqrhSRXpY9RkMHXdgq6ikKsjxEySSJYs/QWnFnM9DLpTGqGVanichB7qSVEzRoQkNtB+iEwEPyJf7z4XCQt5+AWkZsG6FBGdx2dXYfjVRfpnSKvCbFk/rx6tQPT8yibTXwKsRKWTlfOCaZB7whGy0QzOlFa4SejQzIZdaBVhwRlFaSFmttOojIziGxO0UhEUAswoBU0tSW3Q4DV6yF2L+k4rWogcLNnH0WiPnLZhu0mRgewfWidlilcAMf0jvIgaS8ynJ7t/btVqn3BBEw9t6hzoIMmbqFbBW/ZGNjC1WLljuDNlnTu0
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
This was requested by Lennart and Christian when discussing integration
with systemd for LUO management.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up

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


