Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC79F588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E1B6B0095; Mon, 20 Apr 2026 10:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF4C6B0096; Mon, 20 Apr 2026 10:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BEE6B0098; Mon, 20 Apr 2026 10:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA3C6B0095
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:18:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E18461B8E94
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:18:04 +0000 (UTC)
X-FDA: 84679138488.28.B7477EB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 102A640014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:18:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iHaB+U1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694683; a=rsa-sha256;
	cv=none;
	b=7hUEoiFcCwGIC/lOGwn7KtLs4Yc7Cn6CvvXr+7RTa+PJEdxfpr6mE6p0xa4+szinyx1SKU
	cYTfZP2ShljCH/geLg8oDdXnw8m4ZaTOmtvVCc/2Z0nRnbkqFR4s/GpofR4x342IFhdgWE
	S89/aDRlgShzBhwd15nDHNLx8CRDQuU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iHaB+U1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNDqlHkLA3XwzqBTWyzDtldlB60yiBhHVXXXYk5oIQI=;
	b=7mD6P1YfLZoDxDPkIug13qK4GazdmwXR352Vhaks7LFGzBFL8tFGXiNt/gZq72zp7Sd69p
	PvohQufnX1U9vsKNAmtzN8Mt08nCIosxAXiomecVuf+VZaKkh73uI1elAzwZ8aIQiBZhZD
	QTO4HXgkYxzEVZyLfsPr7e9qEB7zess=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso41700555e9.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694681; x=1777299481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNDqlHkLA3XwzqBTWyzDtldlB60yiBhHVXXXYk5oIQI=;
        b=iHaB+U1Wym9PRkuGM8bFk2ZWk0zd53Y965uS9MlpBdMMyzZbj08sHAjUQkV8rVD3lT
         32QmZVpt+YEsoog7eBJY/vJeG775wDcrRumUbxw1SLIE8QeBT9KWge3HpeFLejpjk+sV
         8MmMFmPDqJnvaaneAUWBdkDynYOwdCqdjzfSzRTOY/jCG9rOpAExaFeEfpHIOshZG/ov
         qGHpl8xocxJZjRcazXSkeUA1n2trg76KbwzoyWaFxHroHcYd+bFMejpAAEHLt+cSl7+I
         QeLduZsWu03IA6nbwEpvW7QqMrlTqpfd91itCcVl0whndAJY9TVgLoqUR9HK3CI5qSxx
         sD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694681; x=1777299481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MNDqlHkLA3XwzqBTWyzDtldlB60yiBhHVXXXYk5oIQI=;
        b=lUF3C8dY5WJ70rTnHS5ggu4qHAFLCKwy8VUaEPS3f6+556U/CvYBgSxAYOIGujeWoe
         cq7XkiCyiP2W8AnEbazKKFyzWXhNMiu+10ESAdJYopZvF7iuZj/fkTN/Wf4/Ll7MLKTT
         oyHUyPjKG3kAq4gzi3xv0tRhYW7lvdzEWzwb6YM7AnCT7CHxnJ7GQL3qUHzteGQMvpLR
         Saq0ktzuo1R9ApzeUljuxpVZGlMonPNyUkJJg8fH7/NQ5lpSoK+aRznywMAZKGUfr0Gy
         NYJF1RZTII6l74MJ4cDcVesYdUWS2AzdsGXnsKra+1e/GQQG4OPrA2opDvsI8AmCC687
         VMjw==
X-Gm-Message-State: AOJu0YzRyMczuBpQw2sA4Q2tB8tX243Vtmqyj7vIV9Igxm+kkZxf61YB
	8k10mdUZbz3K8ZfJvAitOGrtpAV/rpblXV71N7XtPgrzwzVTMy8re7C9
X-Gm-Gg: AeBDieuyZzzVvw3Zp+mS9GRUcWz/fPo5fkmeOC78K70E4qW84sfL7Ce/05U+lAakU33
	11VUfcH0QsoDwuQfE+9dL0HTozxjolgv7gG2GWcgETwujyVaVBvNFmhi8m7cz4qlufzv1qTfmPJ
	7EuV6Xdq3pDqPY8TtX9MR+woWXRXlCh7Pl8V9Rg++Xz5iB/bXEaSek2zzGZ6O59NZb5oOlD0xzf
	AzJH3uIFw3JRV0Wq4p4nLpTPG0Y4AjvZz3lS0/8FavxPDc69/4jszFL+IBZzHRADM/QpGx3tJd+
	BY2Yb1fTBkk3Jpeubn7CubHP7cTt9UKYL5RBo6Uzbfxf6DAT/G7MYV67D+rP8D4vtT015ePw1OM
	nBRLmDMdXhB9th59kBcvojCJY5yEu30upGvYw3Wgs0zL53QhkM5UTQuoctVGHQAo7z7LeNmk03V
	KThbZ745OPBwmca8/StGrycETuU4K2pzJCwSigPls=
X-Received: by 2002:a05:600d:8447:b0:489:1ff5:edda with SMTP id 5b1f17b1804b1-4891ff5efe1mr30879445e9.6.1776694681215;
        Mon, 20 Apr 2026 07:18:01 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a52d232afsm6942375e9.31.2026.04.20.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:18:00 -0700 (PDT)
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
Subject: [PATCH v9 5/6] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Date: Mon, 20 Apr 2026 15:15:13 +0100
Message-ID: <20260420141741.2688371-6-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 102A640014
X-Rspamd-Server: rspam12
X-Stat-Signature: 6ntywooqrqtfrqbfw9p3a95cnewnrbfa
X-Rspam-User: 
X-HE-Tag: 1776694682-565104
X-HE-Meta: U2FsdGVkX19EZYtBpLCBgMziTIovAkAuD8aTEsg8rLpTUOzDieGJTzliOFJWqykfvvwtdK/jGW0W2g9eOvoFCqVwzO2oWOGi47kj9akztjqm+Gs6Q9Et7a7O1UHNLlCJrNqtbDcRwfM3qin1DSWI2ds40m2ze+uY0pKI9AbU/DrG51LpkWm9jtSO4ktjLabjr2vrPEpO+nVOSFFkE9oHbTLCFhxkl9QEzIotriyl2Nf6grdExV32//yyqIpMRLbY6Q21EOSo5iqG0vf81aD5wp9Rr5QjkISQHswUSChLOKTkNqm/Bt6fDqGCQuVjGr8WDv/7kZ9YMHSiZ7pwptQYye9zNmjksBGqAej1CFER/Gu6l7+7etP8mIlGadlUzT1/cKKiS1NfWSpNDAqDt4uR1+wUa4edHMEOopoY9PMIbVPARH1HBx9oaHMeBflsSuvAhBf6JLAY+YJRQqB9SPfuSVeb8dLpA0kAr4m10A95oPurT42IYnlMHaGm2uOVt6WTseeoAObud3SW+2jKeNzJRPU6nHU7/VoTTg7FWS75b4KpUdUiKR/ol7zQR3hqjEtU8yRPcFlDgk1sPSWfnLu697t5TpH8darzF0VpH2y0CH+TxFjm6ALTTeiGo2c5vg0Rx3cVYgnSAI/O5vMaL+LHK+SM1W6K9Heypk9kn+kSEmmJtrcFVfE/o8TQTkp/DDRC9IhxGVEPN/e8Q65uX/6/Rddtc/Uv+BC1/hSVGH6I0VPxXF+2KUmy3I4P+mHMzYqzQoZ+Sqg+GTLGVyTdpP6sE9GCbxqGn5Ls4p0Su6tJCo448I1eKAFFOFYYEkWoi139+v5pExWwMjqDmgWui2qFW5TxTYBNONJY9jtyNF3iCMGzW85zGCU6wiufuWqbbh/Ad5O+YTMGyuBWIywhpGKKP+4xpxpwTdSrxuBrP02p9q8atJE3YY2iqkeDe7H6WsUHPUaPEUxY9ylwSqyGW3b
 9lojf1S7
 E2HYK8DTQ/Crn1oc+ECYeNm6HFhmWM1NkHJWyu2/FDEHEIem8tUAGoYUcgQxcTE5ZyF8Y2wMj80U3jbNlpClBhKb/x68kS5Q4s8DuNaUTb5yBrg9eVto8WQO8TAiyj5Epea5kpdn+09SvB92wc+BKFhfYB7awQFURIqAlF28PYC/exFpnT/s6eHhEIGX+72hXTWitM++r+20YFZ1ZX92FiFa0ap84NHrMGYjs2wPOFWAE0PDgCv2H3zs3fZdOfuV/uHHGNqC35QzGb1NwBLtpuA2Dth9kLiTU9iDFyQmo8idybxVoPYN1hP91yrgW/kFwpSl9MltRbsvRqVBIQuZgYi75MmPhGKviOlKjFKlReL1e7+jZPEalMs1BhlngyRYuOnufX1BJe5wRxLyOiFMJdEqG0NePn5FH96gzYVBJ7B/vk3ilQLVNjEMDfzz8bfByFPLObZACbC0ZaUtbaV1ebBvQh+fVaCSqUc86tyxfFnPN++iApYNt1ZvGPs4Up0N/NHrrBzhp6HLeU4Uq7ZdQeCXjl4c1BGdoW9LO8UTCgS9Kl7qF1RRg2J1pMAc8R2oMss/TrV3YyoUCxbzgBm0lB5PBQtcGwmrxxXxGs0vD/EFS+wX5nnUllgyw2x5u8vqLRHmyZwJaTbVyQtgGUBYRVPK26e67Kj6fGxQtoz8V04uRe3+NaxbbcBJlfAxSV8kYBW4NLYTAc/29sY0IX7OXSTcE+Q==
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
index 9e343b6ce513..885e1f346caa 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -292,10 +292,21 @@ static int luo_session_finish(struct luo_session *session,
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
@@ -322,6 +333,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_preserve_fd, token),
 	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
 		 struct liveupdate_session_retrieve_fd, token),
+	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
+		 struct liveupdate_session_get_name, name),
 };
 
 static long luo_session_ioctl(struct file *filep, unsigned int cmd,
-- 
2.47.3


