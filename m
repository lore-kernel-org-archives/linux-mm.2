Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98EDF99C6B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 22:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423856B0153; Fri, 17 Apr 2026 18:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD096B0155; Fri, 17 Apr 2026 18:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF666B0156; Fri, 17 Apr 2026 18:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF5F16B0153
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 18:08:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5AA3160384
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:43 +0000 (UTC)
X-FDA: 84669438126.11.17367A6
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D340120006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:08:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e5Fa5dXQ;
	spf=pass (imf03.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfVXq5XnN78PoGksRH9ezngJ4gBemo0ZzDaOi04WyAo=;
	b=wH0rMwNdeZ27x14219it8gCOgZ+y7TUTZ+Ra/spgLHywWW5YqPQITbxE4oxWug11G9Ie97
	F2Alo7qaLIQgxr7iTF+hWgBllUYVWXkcuIhxRslD1uDs/a+AtznrG2zvzBsCcTf798kDG7
	YhUB/fYDpe767U/QJnLHUnXLl7HK6nI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776463721; a=rsa-sha256;
	cv=none;
	b=fcbnZH1vsS+cB49/J3Z1NCSwFQcrYjN+fV5x5JoBpNAwsf4DO4g0wr5b5QFAE95sG6qtn7
	6omwBqlv46x9ZvG57nGEN3B7GMZmp/eOxxaLncXlil2i6GTTETxXFTdIf2L7xDLDLYqvnv
	dFVcSqRnKmSB6dyCFQ4hHdy910HJODM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e5Fa5dXQ;
	spf=pass (imf03.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488afb0427eso14104895e9.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776463720; x=1777068520; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfVXq5XnN78PoGksRH9ezngJ4gBemo0ZzDaOi04WyAo=;
        b=e5Fa5dXQIr8aqihesjJALkSQV/VA3Rf97yKFkSJP5f39ySuQjj1lBwnN3vFMCn+vDN
         addKt7JeGp77yAO4/ZIn79wUx/GzjeeGOFzspLi0Y892CyQqKTHWPO9uULrkOvoblZKj
         0R04qsMUAlBWQqp3E9xNAcAUVRn+3HWQPrvl5/vBRndu8HzYzsx/ArNGNxWlDZ95XcwC
         kKnev9WMssSgoT3gfZFN4wg70iUhKCXqCwy96pc06uBXShhCue9vzihurMIv2lkTzAPI
         AclerKh7XMd63klPHD5n7A8ExCjNLtmxyYY78vfnsORW4uj2kInhCaNcJpW6UKFfOCg5
         FQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776463720; x=1777068520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rfVXq5XnN78PoGksRH9ezngJ4gBemo0ZzDaOi04WyAo=;
        b=clzCL5k2giVs5Wk8DhN+u/wFOTELIgoFUXORjwoOjgjy+PrYJe4sVUOmvn2iiqss9d
         21cDpdF3MxUf91Wq+yyEnFsKTJa2sgqAxL7aAsJYEPV9pWrUxzRGeG6Bi1ssHcDvKeXk
         Ro8YRhXtubu6xgACRsOTEfXVsChb+rkmNOae07RFjAceOD/9t6tVnzQ6dRrRqDE4lxuF
         5FKiA6cVtd/t7VY1nbSr9OLu/r8sMSiYoK2GRaO+C+hShpHeSErQcz/LXBUvClfpI2zR
         lADdPRm6rK5YUfvtlFy2qepaDyKD9NKv+oRU9Vh+FC+BQafOtxXPQJJKSoGUgWBCQtWo
         ZFEQ==
X-Gm-Message-State: AOJu0YwZF5pXDUHCppucWE4QfMHV/Jl+sjsg9/I/tqC7jD7WxZQ4O81v
	/O2KPf8dsjltWijlM/OH9x7e8dJ7fvOQbb88XwNoF7WWJxdP/BBJZjLl
X-Gm-Gg: AeBDieteL0ehLvK69DhZXrUsraXP1LT07P4W0LzAyXCC5C61SR96qBI1VKNq9k2DIGi
	HGktwPj2Cm2lhoTV1v7J4BMEwEegjzGT3jKNE8CHQdku1LQWrbU9UPje7kwTNyEo7OtKqCeoOJ7
	yFHCWzeh6w51MDvqrUvT2iGmIF7Z+bTA7KsViBULrkXyZmM5kG8S6t38QG+Mz/kI5DxzHL2hmv7
	ZUKYO388PX3KbJMbaLINWXZbsPx0/JOAUa5db0MpYHSB/iFZULsDjD/EfOVyOPuEwL9NwBhuvEV
	g1yw+JP/0top4tjxQZYYaDREyLvoLKRaURq1nPt/c5aytr/RvnzYmlPt70j2lwlN6l06cegUbGr
	N0Jg0+I2hfiFty9UhPkUG/uw3Kns9lNXIAj6rG/kZzVV/ERzvEb1DVQ4nXp/35jKDZM0JWil4U5
	IugvcpGtx+ueWp+hF+UUjqRmyke40peBk6MbS/I0Y=
X-Received: by 2002:a05:600c:3483:b0:486:fba7:b150 with SMTP id 5b1f17b1804b1-488fb7787d7mr59688365e9.15.1776463720169;
        Fri, 17 Apr 2026 15:08:40 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:9586:30a1:a0a6:f076])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb75c695sm25728145e9.14.2026.04.17.15.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 15:08:39 -0700 (PDT)
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
Subject: [PATCH v5 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Fri, 17 Apr 2026 23:05:44 +0100
Message-ID: <20260417220831.1934945-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417220831.1934945-1-luca.boccassi@gmail.com>
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D340120006
X-Rspamd-Server: rspam07
X-Stat-Signature: hhc9eue6k3khfb853t4pf6eqj9k77rq6
X-Rspam-User: 
X-HE-Tag: 1776463721-644399
X-HE-Meta: U2FsdGVkX1+nn05sESyeLMaXuDHQg8u0HgGJCs/braptYWrRdDksBCR4CM9/27BEQNQThHoHHZPVijrCN0S/WLXacn/F9uBpmJkeNNUx1tHlmSYlWPw+f/FU8C5l7ncYb5aGshSaucHAf3pJsq9RNzwjOnL918y5vki9JEpYVfanLKpPC2cL4dgI09xk7l0uYQu76ppIFvT61guVlFcxL3bcmii3ATgJ62ELJISnixlzFX/eI3JiS4tKyOOs5epz3fvM1tWQUgIdPrKsngZPEneQNuZIItd0bc5RjLDxIA3FQOWT3VLi5fDDWeZiAJ4Ffcm2hAyNxZ+7WaKy9A4picUlJZ1ywrp9Aq8IuS+xzraWUUpMxzqwh3crxZqP23E8bB+UTRxm9et03qIEr4V0tRkpLGpiV1CtjRENLBzLS4119QgG61+7IthLBroGbk2jsggwuraWZ7yDDQn/q+wL8o6rB2EeGUqL2RRaz8A5YDmGCeTtINHshAy4JUvXZFKRs5vSR5XS9lumnjFEiutNyG09IUQEEZmeenogk8gDTD9MBbKB7pcFqzGuepkcqZ5LvzTvJho02o5oxb6nHtOwfIT6oxqXwtWSUj7EFF8Xsh+QIy+QC5WeaVwFZV1/VyhiZihAer0coV4pn6G4yOX6JSpXaUDuBJCfPjeIRYIuiVwO2MheKZQFHh6DOca+Ue1J7iv84+LkcY7VUlq6vO2bPtvyuJonksQkT/6lJHhyfp25URf9aeTkKzjzx5ODgja3diFreOFTqU9qbZkm4KZrTUwL3S8by1C4P+psC0itqsRlnKQOjc1jpKOlPAbGZb/TDInS7E4ScqVn3xAgjr/XDL3G3pw7klZD5WVmq6j++132rV1ECx4l9b8DAYnekGoVCLcpR81OM/zz9aKh5yDYVHHxdSpOd17MndbinLAjsNnDlKDzbnZUni/jSyYCk7BFu6FbKnG9pOLwwmOLS1T
 6f0Vm3oX
 b+vQV0L9Q0aWZD21SQmXXHbzvJm+yxxedH4WYhD9wBsSWh5k+gdUxo0eLUPClph6TMLwAEcTFk5jQ3fBhEyyAWmVImNfp9usR3FrwOaFOWojO3AMSwZIZ8wS3z5R73o2/JAT7gLvQS4bHoWQy8IgSySh0u4/fneGtEOS+tCa0cEDlAlPQ2TuALeojE0lO1RSdc3FCo/Y3qGZqaowDBfb7BbioeZ3wgboa0Q+mBGC/nBxVBm/D4l4TJDJ/fkRQ880GgergVKaGOUL/93Zlje60kWFgG8FzW95yQTaU/aPCByHD29lTWEzPjxcIvkp1FdknIq7FjisgmvNTM/2+IVEUxdzS79blYsmCRgCji6LMrkak+C1/BLEXJ/wRxHpuKUoGSVdJDS0AG3GDaQgM7qTcxEgJJCf4jJvzhOBRATW9iSgLlioxOgmKiaGtBFdF/2W8owBMvIhNxamyuMBxXiNzmOR4tvyYFGNJpJTAPoN7FXBwSaP/0Sp80Y/fTzS13KV4RDhyxe1WFRDS3Oo+tjHG4Yuy3NvSAw58lvA2gU1sJAkj1xOCkrRq4kuXDAAJiZ8eWNZ4
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

 include/uapi/linux/liveupdate.h | 20 ++++++++++++++++++++
 kernel/liveupdate/luo_session.c | 13 +++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 30bc66ee9436a..079ee6afb15a7 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -59,6 +59,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
+	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
 };
 
 /**
@@ -213,4 +214,23 @@ struct liveupdate_session_finish {
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
+	__u32		reserved;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_SESSION_GET_NAME					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5e315cc0dfd52..f30151c37bd43 100644
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


