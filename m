Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AA6F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC69B6B02A9; Sat, 18 Apr 2026 07:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76F66B02AA; Sat, 18 Apr 2026 07:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9B66B02AB; Sat, 18 Apr 2026 07:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99E296B02A9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:40:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 568201A049C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:05 +0000 (UTC)
X-FDA: 84671482770.03.CEEADCF
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7878840010
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIr0sZtn;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776512403; a=rsa-sha256;
	cv=none;
	b=5KIuVnkpI30OKoR9FXIp9AsV419gfZlbypZiXnphJjSzD8GpLAdR1K+p5yz0clw7sbzAsZ
	jFWCZnbqBJ1qXkzcAT9Th4iN0ToO7SReIK4QfZJxNgstzhLGY0PTy4XrFgdvaair2Duu25
	25xqLFb6lC3dLYz1WcY6XB1FuAglp0c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hIr0sZtn;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776512403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8MUkPJrjfaH5SQStq4fKwYr2c2K0aYaSEhKyKxHML8=;
	b=XKaSO5qBBvnFCq206Gx3el8r0zwmwPNwU4oBwdWHiaI1xeQejFdRCYfD3B0rLRaypv3YzX
	g7zKD7gNzV5rkW7bb6KJPWuAS6R4LO4+rsRmW1R1leDw6bpUUjn12oYkuhGOTRFJxYRjSb
	8/ICfK8N55I1YY42LVIrtTn/wG64R3M=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b0046078so14336575e9.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776512402; x=1777117202; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8MUkPJrjfaH5SQStq4fKwYr2c2K0aYaSEhKyKxHML8=;
        b=hIr0sZtnTphWLfDS32k5q4I5757YBkEy3+2JiGcKS1ElBfcjcx754VGEcw+0nrikYO
         J70vu1cC9aU6LHVTpZSCtycqaWrCA30R+o9qVA9kmFfCrSSu2Lmq3/p/oZrocA0Xbt9v
         jdPMaZ+AenIE3vV2Ultvq/xu/YP/o0jS6m+12EEyOPFIxNDv+KUn+bMBbpTU++/BASo1
         K+/XpwMXKlUQhvGqehSYttotE9PDtHb+OAF9e2/jWp9O+FHZs+sy4bQwsQfwEBmcsdjx
         XMrMZANMcX3UOgJRSXUA9Eg4WGu3uVw1RTsok3E/1zHyHDU9iOEkAgDcISr1FrJQ9FIX
         1ZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776512402; x=1777117202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A8MUkPJrjfaH5SQStq4fKwYr2c2K0aYaSEhKyKxHML8=;
        b=Jvce1QWkN0kapPRXV/3QkGxi4atweRER3Z5n8/rIA4Gtnx31wYyiVxqEQJdqFEOiaz
         KXIgQ2AS7Pmfkg8qCgTGQz3j7y9dw2msSZJKEsFyeFSssTt3I2yyL1zETSUTjSfc+g5d
         sYSm/FFn2OmzMlfUbYUVi0xNGNa3P/AXAlB9I2X/wMmDYGc4pDsYSKwnQNqcsz7WDYM/
         5r1J8oWxpHz9PEh+d5aifGbIHDs1iQ6Mue5Qe5eW7hdH79i7eVaYE82PURfHNiG9gPFS
         LdEKyi7Puk+de3P7DbXQD77at2VPaQXxJcbVzUN3A3hjpUJp8JJ/ZWsJWdxGO7CyIx9G
         dIUg==
X-Gm-Message-State: AOJu0YxhnLUR/QrS0RDgAZHS/reS+xnxd7Be9LFOJ7tUn+Vg5lPeJYIM
	vsRzPvUIxeGzsRO1VY0HYO8Xqq6Ue86pzjgVslKgp8j0w1WJSmfIEelm64Ghnw==
X-Gm-Gg: AeBDieu/IK4pZwO6AYhYjUhEPw8gqCYOQ7v2k14W3LcI/ZYbLXqt1XVjIXqOZbqh7D7
	ee6lDJBmZRnRmq0urjm/Au/+byXxR4MdtK10piw8XMTtDkw0BLQVIZ5NDimp3E6WiP0LiFh1o6l
	/MLxUKsZ3c3/lDdkNj55/RAvJvW695UeojohN8ZYCyOsKFOner7bOfMvdnhEmLFevvzTKucGTCV
	ifbGayV6ni+Iof6MXWxYcE+MJU79Gi934eABH74wqMdtO1trUvvJRkpJFnZT6oppCpFHJgwmp5y
	nnL3ZG5JmjkGD8PUSFBQ0j/h+zctv1R6qFXtsuPgJl7+nOnMeQ/y7U9ohoMnUEiflpdPNR4BG41
	RA/W39h/xmde67irXQfKHQfaMzOjiI91V3VUFFo6NMGtoiUCL66ZPMoE9ZX8Scgovss/UVW5Xks
	xEjQkaOFM18Mh9sfp7bW7GRV6VTI/qKWFJWIpHarE=
X-Received: by 2002:a05:600d:8449:b0:485:445a:87d1 with SMTP id 5b1f17b1804b1-488fb74a66cmr79170875e9.8.1776512401940;
        Sat, 18 Apr 2026 04:40:01 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:3ab1:89ce:8d93:ae6c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb74c789sm39341825e9.5.2026.04.18.04.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 04:40:01 -0700 (PDT)
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
Subject: [PATCH v6 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Sat, 18 Apr 2026 12:38:40 +0100
Message-ID: <20260418113956.2146648-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418113956.2146648-1-luca.boccassi@gmail.com>
References: <20260418113956.2146648-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7878840010
X-Stat-Signature: xs9kqs1tpmk4r9p34qrrpg41jfaebx14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776512403-156428
X-HE-Meta: U2FsdGVkX18QVq+e7PjoXRraCGGSXPL8tR14xwpAYuCcHsWcYT8n7Cigpyy9XOlD3vBKRPSrHN/D5HU/Zrsf1RoDah1a2WOlVrOMgoHu53d8mCr67J+UhopWk6bnQolsCxL32mJ6SqadTzYbmG82nJDTk7swSdo2KCAdxXJiExMyKyrjr5QxQnR4W3Fh1Wpzx7w76tbxLsEGZT0VAL8peItMEFHAX7MlEDB5eBb8948B2B7yARqC856yRUL6u4+lXt8XJzEX9ODuPbZnuAzyI4UPuDxPdXFn/GPtIbqV2UxE0qqMOj+2WUnaphPoIFP6pdq24Kg2PmdVVaOqLhkMehFb8L9G50HPP7yF51KKt0d6yLl2kmb3DK0J3h6FgXhqyLbeuSA7kJ/JNCS89clo3Vl4g3uBBgIvW8m48xU0jiT1gKIq4K5ZIj7p/f82N9mIZ2XT9KIMgul65DuNqjjqA/MO9taWYstuy5XDz2YqyHW5yfsYChec51mICQBxscpgVihNwuzJeN6VQSgCJty/ZFd/Ie+P1A1oIXNxtog7HHeypEfo3X0E9CEYtpvWMzjngokWOQ17jAMJBylE4J19krx5z9H4sQJkatBLT7yv0x2+CQCIU1bp2ANSc4KBzFgLbBFqQkdcmm1HKjIJkBUN6D2QGLCglDPBMRWyImNehKYIc9n+xdINOLBW3i4ZwCOhhyef2riNi/zjILZYhaBNobtXTCVJJESMyXPkj0zQPLcsm0YgaLfO0fifHlb4E71jrLTnY/L+YmLkfBPpUnjb0pU4GZkKnshtvXKHHEngCEySZBFPNP+84EOzuScmo3vyndoa9VWwhlethP+WKO3WjN7tDHcv0U3ErRYLjq/Ax8L49PsPHaCmBbnFjAfaJeTsDxUGxA6OLACahtYu/oklTgXKg8leswd3a3pbqAyiIRtRyXWk6X05abqbdnrNrmvQOL4QPsldBwsvrLNW9xp
 JiHpJRom
 UdXMqi6wm77VO85VUYXmPztB3N1mip8wXC3Cr2jLd+cobA2sbeCGfJvs69lLnBl6ek2zFfo68a3kuuy7uYPufJNjHos+dfOCRlk8rN92f2hRwncj0pOWWQ6h0Rziplbl+urmQCqJf1/iPjOZoKwEOOEUz8XfZ7IL7KCc3YGuYda9S3C7yTqRen2Vi89xm1l/UY7Rj6Aw6JOYPtR5XFWm4d+ALmSse1NWDKQiDRihmkGkKmc0qYEjiXmG/fE60dFy7z/zRr5gQYqC/hDe9tZpZfch/EOu3HOhfXYpJ4YVKFO3rChxSoHVzcaLHaJ3un0XTdA9/P1UYIjIPWrPkKxx4DnliJjJ5/SHVFJKxxaxDoW6l0do98yY2JdIid/yR1Q2zT9U3RE6OxxtnhTUV0bLVJ4zSas6e0tzGjbqmtH64vVZnAp2j5JXFShxumPoryeGPHMMcSCgSEBPlUbGZnY4Ln0FGydCBG6W0fh9FnyY6XrYher4Pli/Is/w3hoCUuGifFGuSH/j8F5mfAFGaxCW8HUelZ0ksKT+PNYZFK7/I9pXotF1wUXYKyr1s0gixdw4s1njmel4zU9QhncXtfH0A9CI/XAk9W2c92tFeEGO5fCh9sRyy4Dwnf2wVp3oiGeYr0Zc1vlF3Z6/2bHWzBnFT4nI3ElboRQ0NwVKH
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
v5: merge with LUO_SESSION_MAGIC series as they both change the same
    unit test file, to avoid merge conflicts
    add '__u32 reserved' to the UAPI struct
v6: fix docstring

 include/uapi/linux/liveupdate.h | 21 +++++++++++++++++++++
 kernel/liveupdate/luo_session.c | 13 +++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 30bc66ee9436..3a9ff53b02e0 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -59,6 +59,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
+	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
 };
 
 /**
@@ -213,4 +214,24 @@ struct liveupdate_session_finish {
 #define LIVEUPDATE_SESSION_FINISH					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
 
+/**
+ * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
+ * @size:  Input; sizeof(struct liveupdate_session_get_name)
+ * @reserved: Input; Must be zero. Reserved for future use.
+ * @name:  Output; A null-terminated string with the full session name.
+ *
+ * Retrieves the full name of the session associated with this file descriptor.
+ * This is useful because the kernel may truncate the name shown in /proc.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_get_name {
+	__u32		size;
+	__u32		reserved;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_SESSION_GET_NAME					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5e315cc0dfd5..f30151c37bd4 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -291,10 +291,21 @@ static int luo_session_finish(struct luo_session *session,
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
@@ -321,6 +332,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_preserve_fd, token),
 	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
 		 struct liveupdate_session_retrieve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
+		 struct liveupdate_session_get_name, name),
 };
 
 static long luo_session_ioctl(struct file *filep, unsigned int cmd,
-- 
2.47.3


