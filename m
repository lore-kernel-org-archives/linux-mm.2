Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B08FDEE53
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC086B0092; Thu, 23 Apr 2026 19:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994BA6B0093; Thu, 23 Apr 2026 19:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883106B0095; Thu, 23 Apr 2026 19:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7819F6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:49:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 536741B84C4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:03 +0000 (UTC)
X-FDA: 84691463766.24.685B82A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8852480009
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:49:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UnlXfSn5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otwtwCMsuSRZKjyxndrTmRFvCENq1yZJOmlAXqb99W8=;
	b=6Ge3SN7MQBhB2erMOGKKYveJO/1nO28V8BYGnDYwcaQ2U0v7S7ay3GKpWJ0eftdrptCT/S
	x1FDFwJflF/+P5eRRUZ8VzPhC7IfoDizAB83XhsxldgJlJu0COXTTRh2gyU9/jthLL3gnE
	BBxCXwGk67beTM7+4Rzla4kjC8IdDnc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UnlXfSn5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988141; a=rsa-sha256;
	cv=none;
	b=pYkDyK2knBBmujXqKtOyVM93DvNYyrnxfK1hXyy6zYH6cuPz89HuDrZsg4smByMnP9RRmQ
	Bb8ZLnpYTfgMG9ujeqopd3Too/hbkeTtS9QMCgQGsOgTzFqJTGPEPXWatVevep1o4g11Uw
	XFDQFbM8Utd2+r4tKNq0Ko0mQ4599UU=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b0046078so65054775e9.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776988140; x=1777592940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otwtwCMsuSRZKjyxndrTmRFvCENq1yZJOmlAXqb99W8=;
        b=UnlXfSn5jgdCPZxmqESrE1f7I+ZkEZ4fI5Gk7oQX5KiOWfkqedJ2mAvj1s7waLkeS5
         UcwtT9joDzd4g9T0287dBX89N0hYvti8MLR2WmqKqI/DQUCU6U2Qj99PieaaU93J8IhF
         b2ob0Cn/N8Zbmd5NAyYkrKUvKg9O1PxAOCLZR5Aluej1QIAKcknKTb/Zgb+rpR5iQQ54
         iHr2CgFbWwJHm7WLB6s8Zmzvrxay17Q5I2OYX5X9xZk9vCp7JkPI9pFD+E6iNUhzVstZ
         fnMIpl0asX1BCPop0nB9Xcq108qpdydxcSTTGKNTgdLG82GvV72VhBHMP0vKxeBBG2gp
         CSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776988140; x=1777592940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otwtwCMsuSRZKjyxndrTmRFvCENq1yZJOmlAXqb99W8=;
        b=Fo/4+HD0PIECJGtnJMOJsDVkH7TtOANl4UdJyOjRdxtSJsPShKVDrmT8TL1rS4ALAD
         mX3hDxtzirQ/0T0tlHozYKQrQRnvwNCuslgEuRqj3Y9VEbFaKHmsldp0YvCH0G9ym1rx
         gxxm/3vhjTIDjJKLkVJx6OCetbj6JVbXBsd8hBhwNV8+jRFj1Go9DWnXmNu7VVOARG7o
         MLk1O025vIS/KNhQ3k96f8ATq5if4NRzHD7GEgoU6YPbhYFjYLd0rz3kuXij3p3UkkF1
         eU102XjvB9Rp/wMow+VlUv1xr8j5f/ai2SHUbG80gLeoUnQtL9nGEmsYvZ3Ba5kd6lt9
         6EMQ==
X-Gm-Message-State: AOJu0YxC1sTiEDkshrYbPUwxB6Yeh414ZprZx6fAwXYES2/vwZ3qAVnu
	deilLdsg4rC0FGkmjfMTMnT2O1Fl4SCqi6dLe0vXmGLbbIwTwNU1g6JMrhKVRQ==
X-Gm-Gg: AeBDiesLdm0Y+s//T1b9wCspjUlg3rMRE5yl/SoeYX/ZsT/fV96g2dbt5Gy4SWCUN2k
	+YWcKRWEjMPV19TSwEwZqX2WAV+kKrI4U5Hu7gkmVCySAEedu8R/FyPlHbPOXxkm9n9vyzekYfR
	Ljg8pZ5XBFiOa8CV32SgaPihy29eG01UWJS9zWDXglPfIXlObjKX7ssDZxaJHKV8pLmBqbkFDTW
	BkR4fX/EKmcxroGDs+AwIFyVB3VDXH8lLhdZYa0JuC+863RMdaPbB7hehcRH2PvYWvUqJE3Ar4t
	+oVUR1if4r1+61Iw035bCKvW2C0Hm7hrzdjrKREHXI4J46CuFyriZbIvivb87wSjq2T8MkXt78Y
	PvwHx71ihauFrsbMDvRjMnxKFUQJ+z7EglalBhcio3EWStxsObIevfQSYB00YbAogMNjxP9r6Cc
	3kl7W3wBCQ3SA+9WE3JPeNu+6QsKcmCnclP7d8ZvM=
X-Received: by 2002:a05:600c:8586:b0:489:e49:f766 with SMTP id 5b1f17b1804b1-4890e49f7d8mr213607325e9.17.1776988139971;
        Thu, 23 Apr 2026 16:48:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e8d7:434e:1f34:2cb6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb7a0b60sm161135075e9.17.2026.04.23.16.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 16:48:59 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v10 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Fri, 24 Apr 2026 00:44:22 +0100
Message-ID: <20260423234753.3873095-4-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423234753.3873095-1-luca.boccassi@gmail.com>
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8852480009
X-Stat-Signature: c6ina8jkk6nk7di58fh1nt3a1x31bqai
X-HE-Tag: 1776988141-455790
X-HE-Meta: U2FsdGVkX19JmjZ4J80+ZFQr9HSXmX94N5gR5bxWQY3Kt2agjwo+SJ+/UPvtSU5fQUzMJo0cgX91SCi6FGb08nzEWHaHucZvRApTdeFYQ1b4/ytbcUh4lgZUG/dqZZXmz++j9e6/gDDBrXjr5IlXX/BqYGMEIz+OQX9n+Ta6KEjeEQlVh/CvH+0y9hZSyfCbqqNSegj9UtnV29Y9j4nsNUc7lPFWYg4u1yucjfdiVW914PKPgCzKTtHtxOhzZ5ONET+/HZweqxLLyo2qPE+11+aGSWX5jKKFTSB99fW1tnctcPEJDv3YIaSjCTXxUCi1TTqPkmR9r02bLSTh7ltI23FO7W+3pNKUDzS55R+046ygroBF+nM9wOaDXYNSjLg9eKENjjaAizhbWGZCNt3UuAPWnAMcujfPbkndGhwcqlP/QHVy/NSGtg1ZXyLsUwmVaBXbstTNoGurF4b9h4SikOpSTKbvQuCosuJ3L3I71RazO2GEgkF6PXpZ8nfcyhsAdhga7q4VCI38Hhk5ambFFN3UfOJ1DtrintEHow8zI8d/U6uCf0CmTL4WIwoPRpsYQNIAXUGLRCbJYdY7HC+pBL3g3Tjy83y4LMsn15o5ffjLozZHVk9WLBnT0+vulq6vigvitq+xt7iQjICvVNj5x3p7o9vfFyg11JLyvffqwom58gzQiinnHgOftVUVrNI8+uYpA5s9ptLGLqhHojUgdYj1l8uZ6XX5Ba0lEceQXSoyMVEEA5Gdz5O2l+Gz0z9J8GtFtqGf3TvuxFt9h8eZsfyad2AKTOZUNdsJHM6mvBYj19A3VaslLFQtrg7LmXAi7ylAUY324dXsid0RffGtn4AbpArmCM+wFotaDZkhgMjM5QoshXeoSlVOg0Qcr+UDF1RfE4++pCgPPpsdYq8j7ftJTLNjEjE45oBID/+eahOuLi/VtWeLJUtEC9zMzV1hNqQoR/jWqlyVjZSQBJ9
 9XGrYLku
 UTyjI3eUZeE7soq+tT08KnIV6AaXnqMRCivycqZYWkfOV8HNU7Vy/UT6l0+7XaTVcvWbmOf0pEdz/ENIPyxtmmgNJMNj8Uw0GZrwJQj1J8rLbkKbup8CjmA4MGQljeNVX/8YbHtyyDrZb61g3MvAOwuwMKilplomIu9Dr8+vyXVGKdBWY4mY3YB0t+3L46t2ZcVkxaBWDYwJY81brffVDjxN07GCkAW+qobrYnkmpePIGBtv/GnyCrYOfxUUj6mznB6a3ZzDu0cjGIbPGPV6HYlCvQAYp144DX4tco4euVSMoVHr4TxiuVkhb/8oLfjwXu/ni5a8jYTV5Y4U+GmTSJzOzkyH/G5RVnQyYY71tbGgJK/IIhs5MNxKlNzWg0749saK+lwV1chG6A6Z2fnqpfSY7VBNgsp5ETcSIPjErjP0bk+dZsfAQ4Tm9NS3Ia6hzYdXI39W+qmYstmHsKtvrCthq2Ni/qCUC2yBVquKPfBQuyiyrl1uPCaD4JWWa5z2or9FI1WxJ5AN3trZk4wXdM4sIB8XLoNW0etxO+2eBxSPgjTGP6cHQIx020PK02mK1H68fFjPECbJYyda8OU53S7tc7fBm9jlbuLWFCZg6yzhLrJpEA0hkbeExWQ+M0jpU6LAsNyEsvlTOrUerB2+TV4lLQw==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
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
index 5e316a4c5d71..0bcf2def074e 100644
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
-- 
2.47.3


