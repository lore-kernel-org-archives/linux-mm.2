Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC1CAFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DA06B0093; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF0D6B0096; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5E46B0098; Wed, 29 Apr 2026 17:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F36E56B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:22:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD721877E2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:33 +0000 (UTC)
X-FDA: 84712867386.20.0E4D0B4
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE17540014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLakYIJ8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497752; a=rsa-sha256;
	cv=none;
	b=26iMgXsOx0LojzT0lqr9VC9PQr8pPeajcOfha/vw7eARW7lA6rr1yXy5p/zKvTVA2GsO47
	UA62AqYNGx8FmMJO8TXqQmLdvPdiR6XxbPlY3jwNkqJvJZ6a1qpK4gAn3qiM4PIkwOxqzX
	lLiFvXqOl4IZHTp5u9fHCstKo9MNf1s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLakYIJ8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xc2oiP7pp0P8+LSVJw9z98TCpWpEve1jI7g9J2HlvNI=;
	b=s9qUtgv3R9EeBMw/tqlQcs8As4fbce68a6PVpVZKjhUW8xN+1RujbZ6D29DEZVyHvuKbZ+
	+9/yPSqhkDUIWGLTfg/bMxrmuotKM38+DDR7vSr7/+P4YWL8Ty+CjVZsWVbSwnjC6ojsBN
	0O28z+G2ecIJcqJDKH15xDZzffd5wTk=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48896199cbaso1836935e9.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497750; x=1778102550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xc2oiP7pp0P8+LSVJw9z98TCpWpEve1jI7g9J2HlvNI=;
        b=jLakYIJ8rclmfskOywIhuD5sIgILoFJfOvLMLuRgbpiEpiaGeHFCGnVOpiEfqy1d/N
         wT5HsI6D57cP5l+tgYm/IHK7BdkrW3vvNMIz175NC3ener+4f7QrE4YCAi4wZkTCxgGj
         NwjQ0YRXo8hxuEdIcmahx9qi/jr8hdAoErXWt1wK2zlqCQke+q2fegNmxy26qLTygVtS
         bfu/+bQ3IS32sCsOa1yelV7H8ykHW7Ve2+mS6ZjOXPMECFsIOa+wjpCciLm00dBrjRsJ
         xaVmSbftDW93ExLoHRcYnYN3pz8e7XSAOFiavBCVv0qkYoTHGA94ICBUln2eVOpmGSFV
         1r3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497750; x=1778102550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xc2oiP7pp0P8+LSVJw9z98TCpWpEve1jI7g9J2HlvNI=;
        b=gSDwkQ/RaLo8tjUiyMeOw+00PjwmF2uV2HribXx+facqYgQYZ/X9IM/+qEUpZ1GsYy
         etyMFO+PbasK3v7maJUw2P5UklIdwFgtqpK+8YqCcET42JbUuQbGvKE+kJQ1J9PTS0zK
         /TlIBWRKci3OYMkMrxhDWEbLEmBEahXgsAZfpZqSG5dKNuw3GvJnx+/FXYkkNzQGtPST
         Qq88leOwvPMbX6fQ5a7/dfxdlQnh3ciGYGbOIAuGANiSS771Yeq47ipePf00S/DZ8Uxv
         CmPPQnYf5CFnUStWnEY2I5DSrALy1/UAgJpUvSCh8nNlzug10UnTzPUIWGhfZqkN4Wjv
         Ykiw==
X-Gm-Message-State: AOJu0YzQVAzhehx4elv7KDocaao2z0j/MYqoKzGezYkUZkL7K/YlE2zJ
	fldesfyPFEqxlLJULig4xRpo6YFOZ5wZ0/p0oI60fyKgapJg48VmlXU5
X-Gm-Gg: AeBDiet8k+P8JQh1DR0Nde3/wS3AErgKk3YUNdq60fA81s6KsQvQcwexFFE8IRGyHFd
	NFlcqjg2lASMGXkOFlmsRUhNQcnwg6KygtGnD5F5bknKrVLi2/9qQ63jBhBsQ2kQulImbr2hIo+
	XDNb9xTl3DtGBUwQYjGoHwQMyiD/IJNV2yxLwIBhKLB7xxEWqHFhj0bCYyHGOskUQDiYg3j8N0o
	tUjt0MJI4NFqCfwHSyqj0UUFj/xLxkUkc4ErSraVn6kh8V/PVUazHvkAKlNBsmFs8UyzfwHcPay
	U/xGiPwfBxWevFaLxWfQadmEK/XJlVVJUG6+J9F5FCqWGZ2nT+nZg1PI7S74VFTzDxjMMoMxEva
	s+E6EqwEUcZWkZfA9LWD7x64yHpGFNNhFPfXBFUnrMXu1Ll4OVwnxzPaCLAj6WlmNpZ64dagvX+
	75iFMMviSmrH0OolTS0UrqCKanSwt3+6OkgV4brrQ=
X-Received: by 2002:a05:600c:19c9:b0:48a:7a10:4f17 with SMTP id 5b1f17b1804b1-48a83d66b9emr4530045e9.6.1777497750288;
        Wed, 29 Apr 2026 14:22:30 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:8fc7:44bf:8aca:ebae])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a822d4b57sm45365325e9.15.2026.04.29.14.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:22:29 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v11 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Wed, 29 Apr 2026 22:21:16 +0100
Message-ID: <20260429212221.814107-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429212221.814107-1-luca.boccassi@gmail.com>
References: <20260429212221.814107-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g64w99txfuh6tw6bunrbb8qh48qhksjp
X-Rspam-User: 
X-Rspamd-Queue-Id: DE17540014
X-Rspamd-Server: rspam07
X-HE-Tag: 1777497751-683235
X-HE-Meta: U2FsdGVkX1/JBEO5jiAi6987f+AR9Ff4UfMDLezKNRrGGwIGQaG+0bmbeclkVIIs6Zvi9gbcQ5CNuFY+yyiGVo8zY2XgwCtF9BWhYtjwP2PuqUTmpk6xob5PrXhY+xgH1fOjoopv1BoePN31ydI3POne8aYRq6H7cqIQlftiZURaOQRrDYiCmxD4TZDi0jP75vfCBnKpbvADob9NYxeRiJ/d0H5x3vEGkQgJ/YhmDf3yiPgEOXzms9rnerM6YUsVzw1bRVAbO5VCJnWUbqVkMhLDV8ISejhnogk5pr0CfJiBGfn/+LRUBSTSwfdOz37X6jYnKgQqpS1ZhiEXzAQCxbdtqYCe9Rg0ttNeFuvbim0ddBLKyamhLM/bq9nOQMUFW+YIIum0KgSgrN5ruUuTxGjUscRhApFZFd7TxVKnYTM7h4LpfNVHrBDAOeJIwnLZTK0LL2fAzCubUUtH9a/Ek6zNQF3XAXdIT10yudY2pcJAM2HgtXw2x9tUARoppRvqa+pLxoENdn9LX3pOobtKAa/oX8fn9KFIMiayVGLcXztZdUGF7L4OdeyoLjBm4B2P+N+usgwWI6NJTmiW3f7g0rSDAu+fJL1+bdJ5O2OIiAxlx39ASx4dgijXTDwnNRDaKfGmTRID7Rcanc1CsqooL1QDBLakeN9DnqKDb5NUZHDuuDIgysvHYmT1ma5/xTQsmuFJFqX+PGptu/n3Y8hwTENxNj0j693MwjEePuyF4c04oJleO2FyOH2zeTA/qsa26Pg7dFBAXv42sZKAah+wYqMONMx1w5QkwpAEnc41A2nh9MhjuuLaVES3TVTpOH+0mIt6mnygwzPkCjTRfDAx8B6x3PwO1JEu9VSUqpfceqHDKt3xv/6I9vqx0ZhWkG0dSPRwIMErippIc3DFy7AhSrvj5+xIWmIyk9hN0ntuBdRr++F0Ftw5GSEJJ8d55KfWfsH/6DV4XRzAZQqplS7
 PUXBUvSd
 sSco7q04WTPZ47IeojBCXQEZ5ARx7qp3W2pWYEiVOBnTxKDdT00YRr56GA2AvnAOqXkzLq5YelpwJ5Vf21YazLzc+5I9l0DV/rVdeUx96yEeFMTwnQp9ajqlP2NvYDr3/iAK0xi4l1sBljWyZVucQu1/+muKSE0W5gQGgOUoUO+pULfAYxqimtnHCrKFuWL2F/7erG0PB+RqyYBYxppx8mkARiY4Qbjy1h/2TlH2xl/roairlMtxugkpuuvczpRKESVxaHxYA+I4E3J6qzbKPbCKXDEM6ZyRys3ks+Nz1j0SdQKbh5LG+vdjSAUiMkEttKAN0uqCpDjZn8ULnyGty1B7i+ywVah4TVWsN8L5+XZ4ci6/G9LK1ajaQrZaRpdudr1iGvyQIwHStpIvZOFpBMP0NML3eSrmOpayhsG8GR6fogJeCF6OZpYjklS6A9OTr2C/VbVaSejInyv5DhP5n86E0bSlYVxkW360UaOYBhfKLHuJe8NlvzDfx/QrVmtoJTqWCAl5i3QMj5PFeJPAwmXaZVskGV0F/eIsUeHSQb5edIlVWmrsu7y8lR6h/jujxMMV3SHOFEUNB9OyBg7ezYvtRv1jcvXZvqehBwzlivahSvV3e4TMYYKgWXIYYME6zy3jfX9llO+cwaPT3Ku6Z/O8d7hgDxzJ0+tJ7KDGr5QNJQmmQiEzIRAEHQ+Rn6N/IzyFqx83XX1d8Uz+pXTCiMzdAtEX1BWtKw3pmnwDiBr2Sq4A=
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/uapi/linux/liveupdate.h | 21 +++++++++++++++++++++
 kernel/liveupdate/luo_session.c | 16 ++++++++++++++++
 2 files changed, 37 insertions(+)

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
index 24b4f381d3c8..1caaa7886ec6 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -289,10 +289,24 @@ static int luo_session_finish(struct luo_session *session,
 	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
+static int luo_session_get_name(struct luo_session *session,
+				struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_get_name *argp = ucmd->cmd;
+
+	if (argp->reserved != 0)
+		return -EINVAL;
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
@@ -319,6 +333,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_preserve_fd, token),
 	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
 		 struct liveupdate_session_retrieve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
+		 struct liveupdate_session_get_name, name),
 };
 
 static long luo_session_ioctl(struct file *filep, unsigned int cmd,
-- 
2.47.3


