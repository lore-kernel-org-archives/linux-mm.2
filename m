Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD2EF99C88
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78386B02D2; Sat, 18 Apr 2026 12:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C294C6B02D4; Sat, 18 Apr 2026 12:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40336B02D5; Sat, 18 Apr 2026 12:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13886B02D2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C4601605A7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:27 +0000 (UTC)
X-FDA: 84672224574.30.071C868
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 772A9180003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CHrU57V6;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AT+C0FqKOy41gQ9Txc8mmA2gRVUT/8maFYBa2yrLvwY=;
	b=QUekuqyZIEJV3wTojzHDz5mX7l7mWovUqb1Wbt3RsRXJ5lYkKkCij5ySHcM0838mZJ2dll
	C+EnHlomcNFeqYI6Ii1in/6jWUnodWP1yLqR/VTUjkKO1lchfxMssVzLjjmawMkXESF7b7
	64m5r8Un8RuDZFzG+Eeg0sWJgZTwzpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530065; a=rsa-sha256;
	cv=none;
	b=YN7eWolethwKfJtUccIYj3RVhfvX1nI1BZKmE5QZ0k/t/8DtASi9cQpwVRJkwlGODL+YGt
	2INBtFAVzTnsCfjDCuvPC7k8rAQr7ttpsqqWXYv+Z9iBidKBPjWY+4yrXp6d/TlWi0iRnY
	HPY6xyW+0n5M1T2AIvIqRyY1UTcnQ4w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CHrU57V6;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a4bc360bso10127195e9.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530064; x=1777134864; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AT+C0FqKOy41gQ9Txc8mmA2gRVUT/8maFYBa2yrLvwY=;
        b=CHrU57V6JG7qYEwIukuu4EIoJia1J12Frd7VE6qtBB+0Z99L+QN9Ga6NpV2f1VBqqe
         be9NG5NAMWh0gJOfKtYrly15WXIm8pmFehAaZc1jvqqB1rDwJN+vQL1E/f8/vi2PDZzG
         aJMTxtCFDKK9JfThY0vK48GFeIct1golqNEUj8ZI8zxymJKIpimEUhZouDXMrvpRmc+c
         2JhgY05Bx7kej5buexFgMian3CERw5UVAqLoJcj82bNiS5xspvvq6p7n1UYV0u+V6Urg
         9oUEfgWfNI5ANuOt3JRIyt/OlXpQBQ0RygZVw1arud3fqPKplibj8GSoiQ4kf+yaXAqE
         +5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530064; x=1777134864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AT+C0FqKOy41gQ9Txc8mmA2gRVUT/8maFYBa2yrLvwY=;
        b=OKZ0/K8a5ErKiXWjfgkB5u0UOjbgSfA4dTkDYXHBNVUqO3mABe6/6QsFehaMLDjGIN
         ymblX8KU3YZY5uH7F7B07TBeUuwl5wVxs3ujUnvp4zm1kI0dDW+csci9EZTKGFWBX1JR
         wbTDR+X0MkKNHqsqV4YUomkGF2CMtz95H1Dk/E460Ryej5KdF2pUKEmkNjheDb+FmjAH
         FUuPsQ7cj4393zmOG4VGOwsvEe8so8YPTOIUe9tDmW/R+Gx3UrvtlxOXLkIvHIkZrwNz
         /cYc6HCq+sPIKSR9YeaL/JG8rHHOmyH4ECbtHUaqViqH3NfWK9cnKXbTD68LLdad1/Z6
         6j0Q==
X-Gm-Message-State: AOJu0YwLRpbb3qK+czwWRCAl3Kr8hO202cRiqwhvlA76yNrnGLrbJ5GL
	Bq10QhDhTnwikEFU9OVznKujf+jgnVqUgZP3FQnn2jq5WUXMrr6Wg21t
X-Gm-Gg: AeBDiesLILlWQqkMgaEuTlgsOYtcA3UZag1+somJobmAlkSMdmiagrZ70+i7a/GkAm3
	BwS2CQZKSHAGtHd73Uc0N3E5AxFlpYEreEts0jLmjeiT7IOzCVWTjgVgAKRU1CUMHwFxbMLc4gH
	K43DPNVL/FaztagdQRjojslGB3X1OC07qEMiq96EgNPnZn4eRsnDEZFwIXdjbD5b75hLcIXtn24
	Dd3xfi6EPt/iEDBuRJwIz7qkGaWQaleqdZOcYuYxuRqDWF8uBQE+80EKMsP4NOenX41QI1HJL4u
	kadYcnvD5tSJbmjgnC+DCsPnC5MC9Wi0S293xblVbh2H0w/nJp6FiXmmq04giRvCeCU4c6JVgER
	7jgBV6t+SU+9NhcgaO/yzk0uYHbUYefwCj9Pbv74GmAeXtFDWude1FJ0nCHqhPo5EXZUjh+7f/N
	GW8IwU5+pCvqjSSUpui/leARxxlHo0Gj3r/G0SNkU=
X-Received: by 2002:a05:600c:5294:b0:486:fa35:aef2 with SMTP id 5b1f17b1804b1-488fb73d53bmr97024485e9.4.1776530063979;
        Sat, 18 Apr 2026 09:34:23 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb7a0b54sm44316065e9.20.2026.04.18.09.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:23 -0700 (PDT)
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
Subject: [PATCH v8 5/6] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Sat, 18 Apr 2026 17:28:22 +0100
Message-ID: <20260418163358.2304490-6-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hce8mkp8t8ax9ch85i6whssdre5fr1nt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 772A9180003
X-Rspam-User: 
X-HE-Tag: 1776530065-449507
X-HE-Meta: U2FsdGVkX18uY9knWzwxBooWUT7mFP7g4rssLjzt79CYcHATejbMTflSCnsNr4Mxssmv9z9ChRKbZ79VEd/s3yByAbtm8ErC+O8EeJxxDiQWBZYHs6OSKzfJ0VZ2AvYTKwliyQNju73xz6QSFfSN5vh4Lmx5uQI/fxeFV0UJwGw+kE35LVVqF91f5GYlvqaUTVgWQhVSO6tTtndhkZeSMavyqCWbLPz35hpj1XUdImh603EpChSs+qf54eGL3+QBf8CjKoJfa5/FszcAdLw8MWo/frQF8wCzKrG/nCtx7fdJ1rBSwrP5UizUoWg0wrRIm6T51dcqvbKYv0JWaWea/NlK86sZ7PgvKX2rpILLltN6MOcLa+GVg5autxHUpZSH9viiCldA4PlTLbObORcJ0OeZ3f3D1OwVYRh6CselAfaikSYnyBIYOUPB1nhl5ME2aOMV53wpTK//uQXL9s2FMtGutGZ6TTBKaySyLLRBUMJjT15BfOdkhOscQEkuQuU9EtyzuhVTbUAcIHMn4/aK14uTwCVYLpMChQqLp8x+0DfLveQl/LEZT9vIUuDZMES85FtjrDVR8eT+Gp14Iskkr+UrlIuGFJ8KNMvWFnkKeV4Q2/5XMm7pCQW0scN6kSVYGRPTI0dwlvTXWPY8gtMzT7fYpT+GSfAq01hmlgukpTi7RFd89ksB7h29u0lf3hRrDUOlBPLOmcI7DcohQv1GMKA3B/89Y+37T9HBLVABTtVBs0odAIL6P5uAdVpdWl18jCexlVB2seKugBuVM1zm0k0X0fb9xGfqucRME+CwwC4lLD28kMQWmyhYh1QJJD6jNkwPT3xTquaqIce8VMPdGoe+ZuBfQxrN2oqpCwVVPlaVzy+6mMjFzSs3s+cVuxyh0p1SRm7TToi0rpLdW4vMqLoV7ntzm+XU9A/TrP1jGl0nCifhbuEhNEGRtyxK/BgHopp2+px0PhZrhsGX7Ug
 xJI29/Q4
 cZ0lA/Fc2Qd0oYb9AjPPgAxWchUj3njEUxGRJarzgwPB/ZmC4GlPikvw8eJQqbMZjsAIs+OMV2l0gaBDfFjg9xlZQhtJV3yBPTI9rphdrLOK27c5VFIshe/+sIb60/toUOwga4OQgGyAeE96js7HGZW9HLkpUtRG5o8BcaAcCXlp5hvDStfQJ9MLRniVLLPfgErtWtEEhAQvzWdOUGWqtpbLYGfLETiwQftaIVinaBeGiM0+IODyHUfaIkHtcsMFpQhC+zTqQ56+1aBoyZQSgHmdTKFy3BnBS08aNPH0RUsafWW80eF3xTuVEuHpofGybH+fY+8EbKIrkQO5nzBfhijp6bM1Ld5dVLya8f/J41JXB7cH7QEwP+vtoKo/0dUCLGVWOPCjOllE4UeNKy1pHgXLfjRtMpc4oAug9nl8x7mya+tgnL/6jaqCG5XF186QiygWX5dsJP+lA14WDo/xjDD7G2mvd8GvzlEuwDKRvdPwWtCNYleh//GqWoD5w4Bn2eR3Us4gNWhNkSP0UgfPrbt+2HJJ6uCVnj6r/Af+SELA1agG1fOjCsueUWfCFjQvjFQEwf0FWY2kkfo02rMzlQhfAlthDJJ6J8cNbzvZWCU6Cuf33KmLGth2Y9quWR6D+x5GM
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
index 21cbe99fc819..ca5e44274dcb 100644
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


