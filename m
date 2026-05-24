Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE87FCD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2B26B0095; Sun, 24 May 2026 18:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9FC6B0096; Sun, 24 May 2026 18:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E69B6B0098; Sun, 24 May 2026 18:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58B516B0096
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9FA0A0CF3
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:05 +0000 (UTC)
X-FDA: 84803782770.25.7A2F2DE
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB3F740006
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=P3ky81wA;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jA0jwO8NqAbbwvetC+CA7ZxVTwLGbB+JAjjbDxxkNIo=;
	b=Xint2c9IKQlDgl1snFPx7p4PBLPQM/QAvcWn/F+An5cJqWAOOuZMTXHuqC/jzrpYD5Juk+
	Ixu7O/+rGNSf1MiVZ6GF6/cV3k8/drGKlrNDwSQwWMLR5S/cNbsdstelXGM7Phfu6H6Blo
	5zVO5vZa0YIX1jvLv0DLAxuumaG11AY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=P3ky81wA;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662404; a=rsa-sha256;
	cv=none;
	b=zZctHOaeqF0/wA7u2FuIN+YgL2v7Z25cF6dMfaPh3jfvUynetTETt0nacK7Pc0XstuKsb7
	abzqD8yyen+McfrSvPezUhOST4foH8obXqZ8BbLrByUzyYYEECrev5trcLy1g0cxlWUpnd
	B75hVu/sfFR2rChnAZC5q9U9/ygs6mI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jA0jwO8NqAbbwvetC+CA7ZxVTwLGbB+JAjjbDxxkNIo=; b=P3ky81wAo8B7O3cTVu6wf0JyN/
	l9o27mQ36tO2akMmIg2Mhz4ZKJUhDmhqwJLqKmCWGStSyWyFQ8+10Xs3AGWq9o9hTRts5TUdlAdKP
	hU+KO4zsujgCtvOec9f6qORXLS5CKXC/z0FtMT6nkWjpCNJ4+DJDdVOFZuM1xEcWRF5hp7lSI15T5
	Qxl/xixT0sqRASw3k6YibT7iFCKhqcgcYvomH64N7D+Wsf3oJ9egz5rcg7TnydONr8j8T3wbc2teq
	XenIlSa451Pi6jKJkdwVVDodTB2aUlJF1dhvDEAuIWmj1pyxaYL39f0/5rEc2UCkT3Dcd96A5qU5Q
	tBYlCn3g==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHU2-007fJn-B6; Mon, 25 May 2026 00:39:46 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 24 May 2026 19:38:51 -0300
Subject: [PATCH v2 1/6] sched: Update get_task_comm() comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260524-tonyk-long_name-v2-1-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
In-Reply-To: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB3F740006
X-Rspam-User: 
X-Stat-Signature: zjqjz6uqrfb79w14fjryw6ownfysmp3m
X-HE-Tag: 1779662403-610936
X-HE-Meta: U2FsdGVkX187F13nZZs7E/3GjTIDT4yc9UJaxzrWc4uTjaViLQPby1uRL/kN2Amjtic+tbzKYJH46uIMiTQsP7Wot3u4vQSuM4TZreD+9Zgg+12JbD0xj+SSfUmf8PJqmnRC8BBWMcmUNnNi6iNIkcal4+K6C6rFgmnmcPiyTm7NtPnEhjYuxP4n4knmJaTClBbiusLjFZQQutd7EHMB2tLG9+f1nx9MUJx73Z5lnrNKWOb91hHuXBGBeIgC2iDgbweiuneawPJLBX1Xe8Nf1Podh2xQKiqMxVeZOXqRDFt3bYMeL5v1/4jSn9ZYFLA5SVVVF6vHtSFg/5YV5o47NPObVOV2TjQA4LHCK99B3zp8ffo5s1PmPnFitdx8F+9oidLNfsPjdk/eFR9W0IcEodNKFe0+8vhcAC3cnhpR6Y8F2VjOdq0OmOVW7/3+gwsKKG2vkh/teJdaL63n1azfRW1AmWI9LyD+idM4GDgmclpkbYz1VMOx80NaLKWdXxceeilWEUeBfcCycqllupE+ra2vqNPFygF7lryALdUBUorV8a+1STExC4XQ+nEuJfnSpyFVShJXK2fIlfsKwFg5GpZq+VXfEc98kYtZTM9cCct2qnZi2c1t3eaUtl+2+PEvgqRnTUO2Id11T5OETXyFOCKiThS2IyOw0H335RurQZJyC5DgKD88wYBwg6Guiz5b5EoEKjIy9PI4J/QdNdMZaNizx1WxYIMs0pCd8v2q/EwzhLXEnlRgDSrJmdB50cX8KgendSSo63b6P55UO7LWNSVevmATLnBzf3IlNlpPPKgKyIh7uNIemCf16PeiWC5T4uqg5/LZoJXx8Rkcr5OLK+DUkLwPLwTMzOO/i9l5bqA0GdIAeqpeCUoW48XI/vzki6sV6evELtKtVndtAgHsuHfWJa63d6IUg8jvk7+mHJa9Gaxzng0ttpZjhUqKVJ6B26tWzoUmiitqITBrLYp
 TOuXr5O2
 c4DqE2jqD/2u5qQzpO80oMaB7fpcoQpac8iUJvnxgWeXR4QzDTIMOO6tAtS2fhRUdn5LVYDx05E+uIDhvWHY9Hf1PPqsH2NYHBgM+5Zrv5u5B8WmOHWVnNbaIz672MNaENN9fHInF9EU0WyRhZCrl6qh31i38tCF06Mi6K4qrEJe2R4SMAtfZ9amWnArtGiqnyCm83jl7/7csWu3/+jw9E75IXju7i2qOdhePOfw96AoANR1anc72ebUfcKqfoj0r7tu88yHYWpmq6a+HaIa7vyWbwckYi5Dh10mo4H5lrhf45cdFeDvSEHD9OE7bixpsrFoOGiUH/qhX/nZDyZX+/qokFaBFmJ6OYbR3DOgRuRo55Lv0sPEy7Cv9UVy2Vtg1y7YH/TSAEU+N6mvYk4BHjuw92toEeuUwAP7w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 3a3f61ce5e0b ("exec: Make sure task->comm is always
NUL-terminated"), __set_task_comm() no longer uses strscpy_pad(). Update
the stale comment accordingly.

Co-developed-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 368c7b4d7cb5..60d004a49a27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2005,7 +2005,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
  *   User space can randomly change their names anyway, so locking for readers
  *   doesn't make sense. For writers, locking is probably necessary, as a race
  *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   The logic inside __set_task_comm() ensures that the task comm is
  *   always NUL-terminated and zero-padded. Therefore the race condition between
  *   reader and writer is not an issue.
  *

-- 
2.54.0


