Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96678F99C88
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8324F6B02C9; Sat, 18 Apr 2026 12:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC226B02CC; Sat, 18 Apr 2026 12:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABA26B02CD; Sat, 18 Apr 2026 12:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 568866B02C9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA586590D8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:12 +0000 (UTC)
X-FDA: 84672223944.05.54AC6E3
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 168F8100006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOtxkTd1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776530051; a=rsa-sha256;
	cv=none;
	b=iCRf3iypyqp0fRez7nbupnTubG5+/Y9avQKURkLnXYq6/3Dq/nnejGB+lQr+qSg96NsmR1
	y/PqbMw5C1RwWsIFEorDUWu7okxfMMCxtvje3V+5dfYSOaI00RcZLjlHmlM/lTtuyZBsAa
	l8OwHb8K48AkpUfnTZYnqfAVRrfGEDQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOtxkTd1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEJxdjNDjgQ6mPqk8mreYxDf7pruksf/jntCs9G0iUM=;
	b=4Y2uCaIyQiH9xhsf+DSZv12PaL0tdZn6sbaj+OiuHU+AJMdVIv7pMNnTWbbMCaoveUBjCF
	puULGoJLvMOJFZaJL5ajn5BRTUG/Ba/CEWKA7KxCSx1fpRbM8ehN+JoP4KBxYAdTJODwqg
	gIURo+LLSQJV55jORLB+/x5ZDbEMFs8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488c2690057so16105535e9.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530049; x=1777134849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEJxdjNDjgQ6mPqk8mreYxDf7pruksf/jntCs9G0iUM=;
        b=SOtxkTd1IrfHhEik7jzDsOVhmFgMs2ngSmneWON31C32o6xc3zmvJZBwcYjmRzLzAs
         UryFpP9BLS3vpansMucQno6jWoCRcEvtUs5TwUWgH8dVAR3xnt9M/0MY51NxHp65la2+
         YzIaXspy7ym8dAnb/ry34MO7kwXy9GzVWHdk8z0UBZr7wCoA5UTDNwRE+jP4RtFBAh5w
         gGwFwCQdjRSjEU1mDnxE+dn3mtyyvE4VDWbuQSd3LoUf95RU54cS1R0sWUGxRFN2YSKa
         xro6yYr1eywRrJEYlWTJp+bYSlr9OJWV6SsXnc5cLz+pfIVQS0ZfQ8V0v7ldNp+BMLQ8
         UGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530049; x=1777134849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TEJxdjNDjgQ6mPqk8mreYxDf7pruksf/jntCs9G0iUM=;
        b=CIjN4Bhz1kmEYfd7bKln+wnapyNhcFbJavSzpY03inMtOh8Ay3poIwDkOBgg+eSX11
         bOm0p038og0uchdU2ajszblyRzh3Hj3jeaghmlH7yHB4TsHWW4cnjNWGawkxAzTv6pV8
         O8zMeiDEcq+LNdFHOmV9RhY5XocsqpE7+dYsiBuaPDL+7ovz1xmDQmCaX+89nLEiOvsv
         EIoOOqOPKaaB8CV9b1IFwfWlUCqke58NpSn+bTU/vOFCSYExR0BqzE5203CFLlldWzkV
         DBHGgsHZPOz7pY3LcW+At/ZMimJ4MkJC3y3y6p5qRqUaYRQwfLMau/FLVxh2bab+rVQc
         Jmsw==
X-Gm-Message-State: AOJu0Ywxk+bkkSlJLboasdAD16DTHW+PH/eyRYOlBMJ4Y/a44Ns+pJEm
	Arz1Fb2RU2xkAc9PvI8zPMi2wfQd2zeHVjmFt/ZoYyk8aLNk2iHYZno0
X-Gm-Gg: AeBDieuFrpqRO/RUrAs/vhHMYQofncvFqBkG7J6dSdPFgwvdAvLQiXp+xIh0cH+qW47
	CIWksfK2wZpMBh8GZ5iBzPJUnWQJERL4x8/Eg0ReE6hnyeg40NZQ9my1FjQt2BiB5LvGGoSS3Qt
	KZkjs1xXMMDifBn70vj/bqZvT90/Q9/9kGbGHQUoOmHmk+36+m+8K+W3tSOXfOXqe9fRoAtSPD9
	3bPv4s9jt2WMN+UjaS+nfFFRRzWMqceiYUmij0OCqVzWF8HhjPp16w9tJlvUK7W6cG1Ia/3fI3+
	n8SH826sXuzze6oOn6GP5vTSh0zNjUw61cQT/MuOYkyRrh+qTs6zYuKbEqByf24M30xWe+SF+vK
	mYte9O0lBcI3WQLSkzlrUd0BS5gqT/oT3sGSEAhJ6O8t3kXC7oSu2Um3kXMYu592ISwJMmVsjwu
	tgeJKAr2Uywu1phqD9JmZKGb+tKw3RyHL02j6FLyOAho5hpZ02qA==
X-Received: by 2002:a05:600c:c084:b0:485:39d1:b4dd with SMTP id 5b1f17b1804b1-488fb74a495mr74754135e9.10.1776530049189;
        Sat, 18 Apr 2026 09:34:09 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:e054:93f2:97bf:84c6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb78cddcsm60829895e9.4.2026.04.18.09.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:34:08 -0700 (PDT)
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
Subject: [PATCH v8 1/6] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Date: Sat, 18 Apr 2026 17:28:18 +0100
Message-ID: <20260418163358.2304490-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260418163358.2304490-1-luca.boccassi@gmail.com>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: eww4eshwuka4m3xaes1ybymmh4pog4jo
X-Rspam-User: 
X-Rspamd-Queue-Id: 168F8100006
X-HE-Tag: 1776530050-319847
X-HE-Meta: U2FsdGVkX1+EenwhYIyp+d+9VavBuq/upvOtjHSuLlRm5MmtLsQ2oocNtEwuguKyUhZZ8ikrz7a3mgLMzMmyAmFxpYrqiDgWJN1C7r9hJsf8V5KWxWgzYJbI2rpQQACr6rrzMfuEfcGCNMM4heEhMgD5gW5hWxDJs6wT2/0GVQecQF4943UQPJ/lpxTPMDzWj8U+NosyaMfKqX6ethp8J112RR3oPLXHszpUBp4uuSjHKEMsmMJSp60ZWE1VY+cmWM9o+V6UjBeWU1dAud+n1b70unOiwtrSBAhtz3fPoILrMaGiew0yQF/g8jQ+mpdr/Tr9KVLAaFfTdenGc64ZK1/6p9lHnyYvMNTEi7nDMAoaKClm3wkIH4D+J4G7fEWtdN2ajz9d8VrMyWdl31eR//zjUMPRrEtoG5aSUA/6eiKDR7d/X3ELrwYH7k3J5MnwQ4VLJRx/uHqy6Y3lqy5MpVY+Yk9vy1caBU85wmG8rz3VrIq1/16vfuSlVzZFFcqlLbEKIDPNkKZTCiLs+UcEVjoxxtjGFj4eJ13S3PjTuM0/PrKDa4dWkaK0JrKO+AZfrS/UMXgEfSs+1MtM8777UdW99XtBEnYy6tPVGdDIxb9REkfaG53nJPmpGtKcSUnxxTwTjoS/Q1bgFdlXYXg9yutV/t9dDCP7P0n8M51y3Kk9JIglazA/l/mIomvYkua5k/yixrmXxPNX5mIMnmeF3kY+E+AXy06n1avOpkMaW4QcNubqOME/c2E39HkAWSyfyRbfmtUWlIONrElZu19zRySO2LarugxGoHWB+b2yKfUswBu8bdn5mhiBxygOjhw3ixnZ/XqPjmFW5pHQDWzr64DKjbIg7hr/U7+Tjdmu7jodUky9R65Gqf62qMS9RrfdyE5l9hj/sBjo5MMkeVE8dmfKQnoMeOvPMORGYYfnSlRLzSVPFdTsT/Le38c0wZaFlGqwGYPkPs5H6FM7Rz/
 h8UcXjbH
 Do/bpps9htaXKsWrPK/UN0j5ADfCiFdkR4Dr1ypVzKGEKzy612AT9ZbN5ba6DXE1jqH0E3dpLQd+WXxclCa6KvCeoFJOVuUEmRD94dIu4Cg67dM7ef16fuwbq7U6RJx0kSYKFQGaVrxy8WTb1ykg5ZfmSDtCrWkg1Mlh0jJ4/pYlacBOmqvbPYiYgoPNHcoH3onha23ag0NPQmC7ntVMxJ6MCEVV4of8DSXsiIvMrWxP0uQVj5UNeG1khoft67fkaBD8lLeT4NG60WTbUcoBPKuikc409UIUXxB2G00MNvYTKVzIMMcyr6WvrQ5nLRH34rz3RV+GxrYWpkx7jra16AOaiKQNu4A/w44pM35SQ6atgwsKPR/TcZM2Zu6096Ar1zskDG+WHExMEbMuICVraggY+Dlxjq3jCtJoQ6EGwLrkB6hLi3LxnBU3ipGUsrLjLwoKRLgzapEM5lQjwa6w/NaBMpWkAMdBJeS5kkMe7Hpz7QhXpxLbdWR38e+f21XNMYxgras35waOagqVXpr6ICOI0BkCPsJ85JOWIXkdoce2TAZZuGYUO51fv2aCUMMyUyIW0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A session name must not be an empty string, and must not exceed the
maximum size define in the uapi header, including null termination.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
 kernel/liveupdate/luo_session.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d7787..5e316a4c5d71 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -382,9 +382,13 @@ static int luo_session_getfile(struct luo_session *session, struct file **filep)
 
 int luo_session_create(const char *name, struct file **filep)
 {
+	size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
 	struct luo_session *session;
 	int err;
 
+	if (len == 0 || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
+		return -EINVAL;
+
 	session = luo_session_alloc(name);
 	if (IS_ERR(session))
 		return PTR_ERR(session);
-- 
2.47.3


