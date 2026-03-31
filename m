Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198D610F92E6
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4976B008C; Tue, 31 Mar 2026 13:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5658E6B0095; Tue, 31 Mar 2026 13:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BA16B0096; Tue, 31 Mar 2026 13:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3553B6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:56:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56791A0263
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:56:49 +0000 (UTC)
X-FDA: 84607113738.04.6AC8B5C
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id F376E40018
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:56:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KbLY2Y0A;
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774979808; a=rsa-sha256;
	cv=none;
	b=SQZWurS+j8Ta+LxVPLFwmsOIGsJX+0E45WTg83gBJkt81QCKZ213EAmX9yMMPJlddRk3CK
	o1G6g9YwWrEJ3My8Hu02mYVOtTLzQ/qYl7MNo8MFMuJzLRcqg3GcpDm0Uwieuxr37CKscm
	qEy8qC0aCH3MUrZDUugf4QwBT0qpPSc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774979808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7XDnsAD1qoPLE/KiYEdvSZ5yyugeEQjf5/y2C5hQru0=;
	b=7MNRCrqBDZyw4ZyliJkQopVIg+0J/2hwJTRUYoMz1DUnhb+3tdSAbqq2VrzbaaTqFhL0AN
	pIbW9bgoUjd4ll+xNH0REo7SsOru3E999EnyWyhg1dO6uVIcVBMGUP63HV7qWe8OQm/GTY
	5fpxtaaZD7yHXWzNaH/dpcnwMHZNH2c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KbLY2Y0A;
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486ff201041so59297365e9.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979806; x=1775584606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7XDnsAD1qoPLE/KiYEdvSZ5yyugeEQjf5/y2C5hQru0=;
        b=KbLY2Y0AdqoUF7tMNTuUCKRYS/QHEFby4x4vhE7YeCu2Mpkz2NT8xCVC62pWTEs8D2
         KNktVR4w2i5eHypjAVdiqOUjY1LGhMy9KHLBhntHPrUPq8enVARkJLWTyKR3ryOlNrFw
         0b6P/gInr16fcw+1mMM/i9dWr703c9jrGG8rsf/KoNTGt3Zu0IvRduy7FQpFUzdeN6HH
         eFwexCzrCbRMbbTFRbvyEmNGE7WXgGuhSvE2vAEevuw6gxdo2Y7uzDW5Pg7cyV1URNVQ
         Xdez1zoAb8XJkajdaJ0hEGf6gUoB1kM6I97V3B/C952oKMaUhxOdk1BaYoh6sWiJSZq3
         JejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979806; x=1775584606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XDnsAD1qoPLE/KiYEdvSZ5yyugeEQjf5/y2C5hQru0=;
        b=mEAJxg48Yibg40nNyCzp1iOaJy4ZqHqxXWWin3T79mfp62/er0eCPI8K75fAsA+hcz
         gdvJ40B4kncw0K+Q9Wflbm0961XlIhWH/XES4t2erQ0lyh9KMdBALnitjS33qDEsyCED
         5swXIZGjESKu9Yj9Wygt/dVYFL9YiFS0mbi34gz0rGVaEWNjAM+q2Q8JxhSIQFHf3MUi
         l6nR44+YfW9U3x67BA+GTDjHcVCb9WBPrLHrjRAZge4eKVG414DHhXSiQ5HQBaZgT4/+
         aJuZ94rZRLTBGPzwILVG5RG0RR+t7x9C2Nw/wi2Tgp8N93hnJ4R2gs09wavPLB5kdiL+
         zrJg==
X-Gm-Message-State: AOJu0YwI415+L3DX2yvxJahjJqjZxKKbCUtPHCWTS5TY5k/pDrnu4DRQ
	pqNzC+VUKMj8xOKCO6AI/E940zLtBot7KMd0qeSOaTXTEeBTku75B27K
X-Gm-Gg: ATEYQzx0lLlGVjJL+tSX8rbOkiYLIq+ofEz8RrI9MI9+O7g3yq8vTSsguTVsNADNJlq
	Pv5AZnDt3X2I2n9kTEsJIy+1RPnCBrWNi3/McavxQbWC3EG8jJYfKOQXut7/ypP78MU5jh+R1wC
	4Q+OZ+5MlGRMi8bzuWOxcLSlB2PiaH/833PdJFWuuHlStENQBuqykPMxAJ82bzoI1JdyR2bc7U/
	6v6h5P+iE9Brs+cRfzm1C1dUHKS9U30K2U1zSlA5BEqVUygyblevrmxxfps4l9jIUGuTazm5JF4
	E0TWxckQU8GwQhloac390PnaRydyMBgLdUtx1vvkv37nT6FjfQDHxFH54Bs2+Kdr0mt/D6v1bhN
	1BJpo9QqZ38ujINzmx0qQC1WS6BOgKgZ9wXX6HS2UZGN4S1rgPMUicJhPpctkYFbY9r2yzDSv18
	dY1zrYyFDxuwfkV1lUmFbtUTttHV1E
X-Received: by 2002:a05:600c:8b85:b0:485:419c:4eba with SMTP id 5b1f17b1804b1-4888355e6bdmr5982895e9.1.1774979806225;
        Tue, 31 Mar 2026 10:56:46 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:5ed5:ec79:be2b:6da8])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4887e952b0bsm46752035e9.12.2026.03.31.10.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:56:45 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Tue, 31 Mar 2026 18:55:32 +0100
Message-ID: <20260331175639.4066033-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F376E40018
X-Stat-Signature: ot39t8zy74d9h6dcddg4ddxetwin57aj
X-HE-Tag: 1774979807-368808
X-HE-Meta: U2FsdGVkX1/1hInIY7DNztTpOZP/uk5pnTXHqUGwhyDihrqS64zV4hzt58KpHIEaicCJ1X5NSW1sDqhotH2iiSL5uga1WakwcbBgvmgAxAWqljWBtf6serPKatfdMrcgTvQLAED31RAZWbd/jSoG6p5ByY8lzbjUialeASBvV5U/qU+dt2vA80ze16/dy6SMbL3Ms2mO5Hx3jgQNyNbV6t/j3FB0m28PBFm5Ey5m5TzlbtJZGO3kVzdSjGZrTTtjFWo/haocO1pJV0a5UigAKnQO/2QtzFtlIp4cXR+5vRV0QgUAVg9UmCBZc5IXVl1uEim/13s4PIciL4kVgYyYdvaNJUvhlOjkoXOoAlWQqpAG803AgUfodxeIkpccjK3GcVFUlazpUjEptkkuvloBAauASGlJnXb7w8ZjETIYmq0/V0Sfs3K/qW3OCQfYvyGb/GI5cVFtXi3GUT9W3N7TFm1XK/13oVoSh9js5NYegEiz/gjnU7QNtl4kFmFiJd3V+kebmUvx4Oc9mLGZaQpqiu2AZzF0CJ1ZGxq2psWF7jgYhJZxKvUE/6NNFirff2drxUm6Phu++ksTYVcKUHqQcs3AEhM+UMaQigYukyF6WjqKob6h2sOhYTQN0iOf4ohgcXdrW8YpHSuqIt0oEBnJk5EayTGKgvDU4iZH2dEozCc8uPBrcYcMzoTIF8p1yGIEOZnzkRt71HAQNwo9AyyMPxgFGWYGtE6iXgqEqrL4S2CC5Ax6A/oqbFZiuTC4ns01ne1WIQGoiVW/9QfSDb+97DX5T2skMcBZqaXFUAzdQBo6TcfnghVhJ1eR9TrvdrbvElcRj4ow1B/m6dgt0/1ILYbifU4csAYbIM/g5Ah9HAR53PxXvWetMB6vn5rJYdkAwPc1kli9Nf/HIs7voEuDNf402Iz04LbnwKlk+xJ64rGOE1PAQHRPY/1Y9bA0UHZIbCUEPpJATx0Ab/Yr0B4
 OKtUbJTW
 J/Cg8Fg/uu5PewA6c/jMeHzt8JS8Y0lhuWsfxXYdh/67pQH/JPvzaL3K8vM9R6AAiLmfoqlfmnhs+FFM5ZDrFabG/6H8mPR2gbjuPsc14hM6cD3MfQA9q7xyza5Em2m3ic3QZDZ5D2xsEWagIkE/9EHcZvuS+d3oUybjDcc4SPgGiDw/+DsltYV3NKrcaOPwPJ/VsTO/olW2VVw4FYZkSqUDDwobcJSzyRQlrxfDxIybrAOiab/VLRqfePELTHuMfmmecied8jpVRtbek+o4b4TUjRt+w22uG8wdeiMHO4jYOMzSnZgUHE2HdHDGwhAuhyBU1d9ypPCl857lUazyjxp/ApNYMnPKKrPy8coUg3zQmLhw0MCY99mQwsDHpj5fCS/0k5yHpXovrkMNrUPgRu7nBg/RndROykeQj9jAuVoYI3JPogcmkULE38I8pHW65QW7YQbh46QDDyK5dDvZC6GQZAsLna1s/9aQ9lpbCjOooNSK8esCc6bKommiKzowmyUFO2Jzidwr8IbLu3ffRD+W+ChDvi8iubg4SUVz5yKeZiQgRqZmpFSols0alPYWbAKBG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Userspace when requesting a session specifies a name and gets a FD,
but then there is no way to go back the other way and get the name
given a LUO session FD. This is problematic especially when there
is a userspace orchestrator that wants to check what FDs it is
handling for clients.

Resolving the /proc/self/fd/X is lossy as that has a hard limit
of characters, so names might be truncated. Also requiring going
through procfs and doing manual string mangling is not a nice
pattern.

Add a ioctl to simply get the name from an FD.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
Need this for integration in systemd, so that I can check what
FDs I get from clients and what they are, and so that I can know
where to hand it back to

 include/uapi/linux/liveupdate.h               | 19 +++++
 kernel/liveupdate/luo_session.c               | 13 ++++
 .../testing/selftests/liveupdate/liveupdate.c | 72 +++++++++++++++++++
 3 files changed, 104 insertions(+)

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
index 4a40c7fdfb44f..819e8864869fd 100644
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
index c2878e3d5ef90..510a583371fac 100644
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
@@ -345,4 +361,60 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Get Session Name
+ *
+ * Verifies that the full session name can be retrieved from a session file
+ * descriptor via ioctl. This is important because /proc may truncate the
+ * anon_inode name.
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


