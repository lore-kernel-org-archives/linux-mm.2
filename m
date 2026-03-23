Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C3BEC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B67B6B0095; Mon, 23 Mar 2026 06:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E186B0096; Mon, 23 Mar 2026 06:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAF76B0098; Mon, 23 Mar 2026 06:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C73D6B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:01:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AABB8140AAD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:01:36 +0000 (UTC)
X-FDA: 84576885792.17.451014C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB081160007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:01:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Fg2B7PIE;
	spf=pass (imf08.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PopT/7zarkgfUDqfkGIlFWmXtxsepW94GZLQJo5wPA4=;
	b=1UytDRKTd8+wpdFQLg3spw/Kgoag/gGTlPe5nHIwavAgZ+Q9jDWTVVMByTfXkrklDgUtfQ
	0BgeogRPrnSkUUhOCIfqQ0Vrdj3cM6meXso4+jdsu8uvMDZZ6/jGo9x0MvH/ZA6SA1Yx89
	2TZQnPc1FTmvPGhD4NYWM+wlb5oYBec=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Fg2B7PIE;
	spf=pass (imf08.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260095; a=rsa-sha256;
	cv=none;
	b=2EpLjZQc0c16CUqCwvM5Sbsze/bxg6V+2z3d16vQrQshiIWtvh7c8mUZ9X7cEfL6gG1RUQ
	yJcuvZiYPCUZCpnCrUki97KZXebT5VSQsWaBEPoEA5o6OmCzUY0HVdEzRMG3/b7WM66JV9
	DQzoxEjZt2H1kYzSBlTCJfcQfY6EXXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Po
	pT/7zarkgfUDqfkGIlFWmXtxsepW94GZLQJo5wPA4=; b=Fg2B7PIE1bhCpegXzA
	Mt5Ur29dF4rOEVsUj5M9bp+OgKBWEPYRJmjgpEXOkdhD7iCmVE0jrlPGTKuXH/RR
	e+vxWMN4zZyYjp2st6o2xzN11lROoo/82srKHybuwxYscvYSd8PO2ccU2RI+goAP
	zCww8W8ljeJgg91Dt7VBXlXxo=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAnRXddD8FpLM3LTg--.143S2;
	Mon, 23 Mar 2026 18:01:04 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: tglx@linutronix.de,
	peterz@infradead.org,
	akpm@linux-foundation.org,
	bigeasy@linutronix.de
Cc: linux-mm@kvack.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	jackzxcui1989@163.com
Subject: [PATCH] mm/fault, arch: faulthandler_disabled() also check irqs_disabled()
Date: Mon, 23 Mar 2026 18:01:00 +0800
Message-Id: <20260323100100.1031582-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAnRXddD8FpLM3LTg--.143S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1UXryfur47Cr18ZFWUArb_yoWkXrX_Wa
	y8Ja1DCF45ZrZ7Ar12qFn2yrySg340qF48XFn5Ww13Kr9xJws8Kws3JrZ5ur43XF1IvF4f
	Ww4DGryfWr4SgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCzuW3UUUUU==
X-Originating-IP: [124.77.188.51]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCvwCmsGnBD2BhIQAA3u
X-Stat-Signature: i35x3yuq85nrqocx9dp8z8z8hxubnbcc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DB081160007
X-HE-Tag: 1774260093-853115
X-HE-Meta: U2FsdGVkX1/OXOKqdsmU4F8pw+/AD3JgUFglbHv0f9ilC/aMs7c/XXlmD4ccUkdtBn5GujVsk+LE8DKbX9vZynBh56zQDKBMPODbscIygy+yE02cYmHF3G4ggkweS2Ru7GEsPeccRrHC79u63CcQpTqn+Dq98FJd8/ibbH+naen2Y44KK95XcmtHpZN0R1/lpaGAE4IkwbYwvSrV+GhXGdVL+bWhn3A1YxpN1WFNvYLKx+eVr9bzPExrvNzP+sQ5WQYG2Hgvo2usg3iv6WlIJ5H/loybcihHDFehez5yzxF8IaovqQ9J7Bap2HZ4p/WVRarw+WlDsfyZh0pE6CLU3PgKb2ExftRt1h3eYIaOPy0SThRxpdBLT70CyhzLFZOl5dTaza493tHPI+mmPhWd5t5y8SaBHSGMjHzdMP3ZTZcT6J8O4H+m6RDEfPyWri4I50xjuYMsL7YUNj2IvVUo0O2H/dqNqBM8u0vsfQy12xm71b6x3HbSKnYMc4ma83konhgzhZm+QNntCigImfm+J6uTDGkghMlxtQ1jIPenJOTFwl7+xObEW9JbrWsHPnloAmFGWTfRvySt8InAJrBXs0fFE4VD9+rkIQdae2SkTNZrHknwqZF5KQGmGQmUrnf2j3xycqlAlbhntE7NquvHh5Yl7T4MDqmpNcZWXolri8lCap9RNHY+dbHDjGW/QH8GkNcWCY1dP1Yxp8EcpZk4Xy8vFb9S3pO7uimuUlCC3YKOCzL17MvdQKLWS9bmrCIsV/4OJTmjrMEDo3REYHnK8G5GU0LK2g71yNwgYfYx3efDDvntROPHOaR3m9WsEeFOiZsucbV8XkdHfV2QyhKr/DvfE+eRko601gZgIJiAz4h76Ldq6jysvzVTJHWgiuAgAWqShIuuyDDga5mjDJcM8FxDK9l0H2iN9/kgFgLnKdbtPLjShsD9lQYuJGcNgLO7C7ATwkozCkM33AFf6lj
 r43pt2qC
 XSrK+MQTzETQ8norz1xBlrbwgihURIRFRe41X7ziL2PvswFE2JpFsoNtBg4xEQvWW/+fVc37CjM42xYkZJiaA1qRUjYuVDB+RGiU8Vg+i8UcKUYh1mFvRuLHy+U+tkrDjLHQAw42badlY75U9VoyWFS+NcJK4cIETXNvqQfzO/QEVJ/R6YgA+QlZJO1o/OCnnUqAxyXEURdf1PhAoonyl4s+ug4RKUuxE88Aes7A4J1bTO43wJoWOx/A5yyNY4SuD95m21AGMxMM9f/Po+ltl04d9FkHaqDm8WracWpA477PobNuBay9QWMqfUczfPOAnEWUY+DxvVAuy6KfzpGxXfZt9qbCty3ASefZ1UKcUMYEZst65+VHKehr/+JA5UEfvqY+DEQ4IvG9qrQvIHJ95yzp8iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

in_atomic() cannot determine whether it is in a context where interrupts
are disabled. In a context with interrupts disabled, sleeping is not
allowed. Page fault handling may lead to sleeping, which can cause issues.
faulthandler_disabled() checks irqs_disabled() to avoid this situation.

Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
---
 include/linux/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 1f3804245..71fea4497 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -305,7 +305,7 @@ static inline bool pagefault_disabled(void)
  * !CONFIG_PREEMPT_COUNT, this is like a NOP. So the handler won't be disabled.
  * in_atomic() will report different values based on !CONFIG_PREEMPT_COUNT.
  */
-#define faulthandler_disabled() (pagefault_disabled() || in_atomic())
+#define faulthandler_disabled() (pagefault_disabled() || in_atomic() || irqs_disabled())
 
 DEFINE_LOCK_GUARD_0(pagefault, pagefault_disable(), pagefault_enable())
 
-- 
2.34.1


