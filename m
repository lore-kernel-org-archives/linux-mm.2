Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4273AF99C80
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 14:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96D26B02BC; Sat, 18 Apr 2026 10:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70166B02BE; Sat, 18 Apr 2026 10:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B981F6B02BF; Sat, 18 Apr 2026 10:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99C066B02BC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:11:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5035313A8CF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:32 +0000 (UTC)
X-FDA: 84671864424.01.C9DEEDF
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7174418000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:11:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VpHh1Kvx;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776521490; a=rsa-sha256;
	cv=none;
	b=hlM5X3Qg2knO25A1RedNe4bNv6rDHUK9RQvAekliAMypjX2fKCsWOOia93CAjxA4mZO09N
	wD0nnEq5ITFFxiBNdtEYrqoY1i+vXVbdsKXUwTtJQaTYtHWe+x92yfbrQKjTAhkN+AyXwh
	vYX+oeaUKEjN1k4pyh5Z5t2hNbjKW4o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VpHh1Kvx;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776521490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rza78hFhc1kSDmkYveBJcp2jbvxMYnAbG9peR+TlDI=;
	b=D8SMBJWIfZjXqs5pyJrVMHAl8rXogShBPT9ROlwuLccM48Gz2WaiSml9OjxNfYdeYb6hYS
	UOPsvYz6OxMO5iSoJaa2sKhtzyrLc43UoIOd6L4+oATqO0a3NmLWhDzJBYtDoJn898k9s5
	6PMYHSPLQOP0Yd8AM6vxzNiEK6V9F6s=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso15294975e9.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776521489; x=1777126289; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rza78hFhc1kSDmkYveBJcp2jbvxMYnAbG9peR+TlDI=;
        b=VpHh1KvxGJFxe4odF83J8w7vJlSGoSFnYaQ6vHwB30zVf2RHcFB45/rO8UbVm8DaKE
         v0gJBa/RFjC0743k7EucIClUB0infedRlBgEaR2DhFZXCQVy2jqKexM9tBOOkoXEnzLC
         zW4he1xFA8ngVnFmJb0WEN7NOMY1zxl9KCKulpgF+pMAni+mCH98qaNt5gExX2Qs8Ohf
         ohEaEMcNswCIefjMRywS2uRw+2KVshG9ZOB2hDO33zzjVJvbDT48v3sgTnTZC8WIVPAk
         xMcjIoa+iN7Bs6Gv8+9i/R6LysGkkAeGsWraaldSKU35bwFKM8lI8EQcbEK+qBKYUzeO
         HMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776521489; x=1777126289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6rza78hFhc1kSDmkYveBJcp2jbvxMYnAbG9peR+TlDI=;
        b=UrqYDAb8b02pD8CqmN1UO6HfPVnXTZlsbTcSwyd2aqTJuQYb+YiCFqDzzom3ZbYk1b
         S3EgpUtA2qVtKoCYA446EHnfbuHu4cthc1zBwIu3jUCE4mwDOkxiktavWlmzDFwZamWe
         9ZnE0omWJVgR+mopYdmPUxXO7KhIdpoJzYicYUuxrqRSekQcJj/AkvqW6CX/CyN5DcvP
         UO7uKJ+MJx5d4T7j3YJxhSf46sbbkhdkyAzCZBXWIPE5YQG7QhqKnik/y9mn0dvN3Awo
         UDGvaI/o+XyujJbnLP1x1E++Znuc+KIeRthe1fhdAloT8Xts3MSPwvSjZA91qMM/OmHI
         KTZA==
X-Gm-Message-State: AOJu0YzleqLYEQE15+7qtmw1B4VH5SQnathZ2zOq2Zr3QvLht72A8uX/
	hV3wBixI+HCHJwAvMkMRDf++PsVXVACtHn4L58coBOkeArcq+eJ/y75W
X-Gm-Gg: AeBDietey8Zcbo4Yw4E8UrKCKmuNVAUCOIjIO6CfqUjjylMT2o0Bt+p1eyGPiRT+jE0
	Zl7Nz8FGtcZamv9g+3hFs/Hq/1YOgYtpNupg4yGG5tk2wnJemv+Je/EBWKXCBTRJ3rYGXNy8bqm
	N9Qw0263RRrz15ZICBTVFLiXngFA4MIPJWUgaEeJRABNMAMgtaNPU6JRwq3lt74QonxOlMAVEkx
	JIsV/coem6YuVv54Q2Pin9hW85wo0AEUjc9yHdRoVv5jB6oOnU0WWCy4+FLB8fpaIhLv8so6g/V
	zYvbdLkYnHoKo1xx2GITK4EAWTWXsWaoySVSIEdtHIu/rhi0MSzSjt4ofHlRYRs5P5cjdpP3X1N
	FQ5jQ6pbHubwD5O0CiZevoWVxcYZ4boiS7gN6ex8hlhZNqhrVZTQ39rSD9zr1P5/ru7WVivJfa5
	DEQjkuHrmZ3brevF3zVncraosrKf6smBR9O+9qjcU=
X-Received: by 2002:a05:600c:6211:b0:488:afb5:6a21 with SMTP id 5b1f17b1804b1-488fb77d0ccmr90612275e9.15.1776521488827;
        Sat, 18 Apr 2026 07:11:28 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:4429:3762:47dc:91a3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc0f8188sm142663545e9.2.2026.04.18.07.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:11:28 -0700 (PDT)
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
Subject: [PATCH v7 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Sat, 18 Apr 2026 15:09:39 +0100
Message-ID: <20260418141123.2193917-3-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418141123.2193917-1-luca.boccassi@gmail.com>
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7174418000F
X-Stat-Signature: y9qd9aizi36qohmbfho6t5xfqdr1yg1u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776521490-341254
X-HE-Meta: U2FsdGVkX18aghgKb/xmk5SyRQWlnqRIuheKa31AA/ytg9f0HLhFOMGXrIybJDBfxowBQ6SiUdQ89kl4UtwBgtQJMbSDVgrQQw6QqsyFXzeZ0bXf4PQMoGtI9frmucMUFPiokRt9TisHcoR/8tvluJkgoLZwLzdtOHRxygU9fSHyZ9Crb28yO29/qnwb/N7IX7mIunSy1Ne4k7o9PfgNWJm8NZgxQXxVYZkmlQ6+cDQsFWVCZaH2yohRrDG1VXMtpWY2n+Z+yV988MiJ923y2n4tcLwZgsuRAuR6KPrexP83GmLBkSybGWBYaM8cwmQmrvpGnbfoKQR3KPqudRSY22Wmp/lZrrkNbiPKM57Xmacp9x3Wh2fIMzxcCmWveH9ZS9iCubQpLsy9w/ghSAoej7e2rmXJUpBqR+uVjQ670Cdd2yPCetuY4F5uRl5llTamPlEJAa1W3HFC3yEjkx9xce+gWWmnqGmq801RtmJ4QFuid5KNB+2LRtPDxuU+HorcGiBg42YijbnB9pzU0PgNmkbzZDgxVxF/q4foeJWeNtpQ6J01eajTrobPtlz0czKvqPMs24zAMfDYEjaRX9YSRn1h2STU95vr5r7C7H2i6T7yT7HG8IqN7RJHL8Ihmy3BCifSK2pbqE7lIw0SokcBks9ZzJLWWI4bU/GsFTnamO4FFP2kRlegUAHer58xzwHO1uQo67xZ9krGg9Aa/3edvkUonMFulOdRJPx5xJhJDDXvoXGRS20Bs8jWFYlgThkS3UMXdtZTcR+W9P2y1oDQdUjAoSiKq67LFXYcSo+cbh582AwCDkZFTpUFLyfAaPPbDYszPHE7dbSvW6WndbFWpgD7fpkZClCVuYJE922tzitqWHfev1nMFmwIxwxggflbdhQfeTLYbmCf4ZBrjJDU1B4btsaOdg91+zWHzmvzWBLMIgaxmUmeZC/0BtKg0IG15FFtFpwZ9uBcMr+6DxO
 M1CxZYEd
 aPKG8JqM8t4MSabjJg5//JLxRd91c64QgmrbD5i90YevB+FIjxAVW+9HUHJC5tQFZGNrXk7nyHhmJ1GaxbnxQe02Z7sox+9dng4VsvgUD5FsJMhITPvqs/bqv0OHn5zPzru2plbNB372KWsEGbrOH1E8IgXy8zpzp8Jp5YFeW6F/5PUGKXOUcTcD3HkAb6nYnb9059Mo0Ru/JuDP9GPXH6+t7rmrFrWe4N7r6b5onMTDvXtfszNY3hlaxrJFN77MS8eIkUnDS49RDIPVNvJvGfn/ll9oeTE17DXWiz3pg0MjhssnaUrGpSRLggu47MRD81iWIzcUzpNUsDF9EMostkw2oSiNmpc79rvKk1NHGqWQahVYziSEEgG5frH9oz+/HarW8XQgDfglsO4sLN8wOCGD/tlFyaUIfcp04y6AmukEWohwrDwXaEGJsU9/0HekRUjk1EMCLYPJM1z/gda+1S34ZjBCjasNH+/Sf/qbC0gkqaffwb0zvGhD7dAOZ1iPl7G/usymF04xJQQ5S/hcotuBBjMm+oeGiJXM4ZMpf/nrOTrF8zFfj81UBC8MM1V8CusPN
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
index 1d35379e4e52..9b434470982c 100644
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


