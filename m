Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14F2C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C6B6B00A9; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C447F6B00B2; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80966B00B3; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECF26B00B2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B8401C074B
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
X-FDA: 84955188990.18.D2B5CFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E7DC80009
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vrfb3/eS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0kxycSRSEvbxy9pEgGpchLNtgv4/AHk+YSOYT0eb7k=;
	b=D5T2jY8JuKExnjTUcwWeWWubooh3SHAHczk9FrqjS4olvdkCruOmPs+HtFMDe7FGOq1VKO
	e+RHHMVXSz9WHl0I4v0688MVpoVz4zG4hojN0J+P9GZP9IUgSow9XRmpPfYHPbpqRr2xHZ
	CNZ7Ax1Pw1gXEoMbnFicjGG1VMuIl+Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vrfb3/eS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267313;
	b=ppwCOyeFfWJ7ZX8Fc/yhidQPZZ0lfxjRPkhVNL/8qBZKCuxatR+mQdbEUSBz3xRrzRxQxH
	qAI0LU3SA6dApjAvserpyXS5ubv0QvGHBSSnW14cN/Fs6fTR0cYQJShT8oqOIZvjMUD+iW
	iR4VI21N5fX/5wbTokoz6DRqnMILbMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41F686138C;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40F11F00A3F;
	Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267313;
	bh=r0kxycSRSEvbxy9pEgGpchLNtgv4/AHk+YSOYT0eb7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vrfb3/eS3oTXaSESOFoXF2cvTgmNRmWdXTl44HgQ6d5akAmtgV80fNkhnD0UXaE18
	 lKls7LK4EcG1GPDF1h7BS9myKgqIw5JIhRvY03V6x6PERU6bfvThcS4B/L2lPWVXrh
	 +G2suOdU+4yoPIT0rZHGtS/3bi0r3NZ//OYWZl7rNeTpSQKmUDo2ajIzpN+xuzIsll
	 Qys4sPtOrpKD9YwRC8gCEEpI0WCvrIn1f7h/1qnfnuq10gaPvKLSirHcUq3q6KE7/j
	 gYrXOEFmDsQ2Zek+gDPo52IVyVnDqBRIwe9f+w2AoRMt+c7J/sQ5hDJWBEGw/x1mZH
	 F6h4SSt589bGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/11] mm/damon/core: make damon_stop() never fails
Date: Sun,  5 Jul 2026 09:01:30 -0700
Message-ID: <20260705160142.97308-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E7DC80009
X-Stat-Signature: xh8wetgxt934eckznxfmr67qmrz8esga
X-HE-Tag: 1783267313-321050
X-HE-Meta: U2FsdGVkX1+1kFjz+Eaw/fjXgWEQ+mOgkeoOUpx6ivdh47mDT+aZxvOFC/i/fMPZlmNR8e/g+F6MW08yrj/WbqbjdQDK6YfP7bWN+rEwUSHAecvy9KoTwy2oyh6k1ITsuec/f+C6ulPNknu9Lsyq1sowcLdj3BWbsGC03q7/x449AwfCUa0/x/ddXU1ExE46e+0H11ky70zQ59gqqZiK3ed0Mu841tiJDetD+gG/T+sT2U63YBKxltnGWYjwR8Z2Tlkuv+m0vHP8JFmRtxlWykGyFrt1WoDJO0sqR5vppdXOuCRC3kQYbqXq+sk5FfTpVjbS56WfUcFg53MqxyOu1NIWIfjXbfoDGXSspXqi/4o4cH7vo9fCC8Od6VmMe7h6p+DcGrIsigDCwMshrk4PvT8hV7fqYV9f5kKi8de7qC0r7NcOFbdcvscg9zA+hl5pWcDrF/q2g3Zx15ENcUzVRmW0MO/q/H13M8kEi2Pg9IjigEvkVZsi1BX/3Hzug+vE0LyuH6XcNZdAHPyc/ZzproJpVCv/J4JyudrgA2WIHI7sgH0qJwAXblacYhc15n3kn9JYqmoYNvVENKheFmGAr1vZaQnQ+1nQJdRWVCdXCXKGmaiQ8wsGPTCjCek/ODnLGM63zEJbUerLslmbRGuoL5lObp6nu06T2yictQj8BZ8ILTaoiNReVTO+nBpG8Y87FT7vOLvyC6TwWLf/xWYbGTn+SLgKaNSqbU2jKUVaoQu1AWq+liHmgV3YwDMA7pkwBkL0v77FQOlRkMek+OdPp5Kur5iq52WVtGZpSOrzSn+h5LiCxn+6FUJfnoumx6GRWk3qeUjkrFVt35BvDLBkA5vguPf/UnOo0COVMq9Girxw7bI0ALn+QInEyrbJ4I0cRJLH0pB3QGHAFNEbRc2OBmWwjEzEznIKBCdictTpx+HA3n0LfLCx15y79/nZsAC0HOCBlRqxpRDOmDkuh0l
 hhg1gBte
 VJUKYI82essm4/z16uDRBZXdSGGqIpitFnPqu2GVcgNRjwo1ZFbgeYOwZ33vs/RAHAJbA6bg7D5Zbyr+/n4GAMvoPPG3Wl5KmO9mhwXtiLgxcAkBZMX73RPVow/ids4S4zEDoCYnoOn+Ux1ZAWiTRhZsmfn5fFUL0lPmsfOqqw1iZbh2ZO0I8rVNXjuZXcP6oFeS4fgbjSGlPidQFJC8rUCJC1XfNyul9HHGjnrAMX1DBOlqU0IKc/oNYCK+UCYTUJZ1qqK/HP1Akxba3NH6innwHtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() has no reason to fail.  It returns an error code only for
possible future changes that can make it fail.  Such a change has not
been made yet, and this only makes the error handling complicated and
confusing.  Ensure it returns no error.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d89a7f2faf350..84e400aa4e823 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1926,10 +1926,8 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 /*
  * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
- *
- * Return: 0 on success, negative error code otherwise.
  */
-static int __damon_stop(struct damon_ctx *ctx)
+static void __damon_stop(struct damon_ctx *ctx)
 {
 	struct task_struct *tsk;
 
@@ -1939,31 +1937,24 @@ static int __damon_stop(struct damon_ctx *ctx)
 		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
 		kthread_stop_put(tsk);
-		return 0;
+		return;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
-
-	return -EPERM;
 }
 
 /**
  * damon_stop() - Stops the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
- *
- * Return: 0 on success, negative error code otherwise.
  */
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
-	int i, err = 0;
+	int i;
 
-	for (i = 0; i < nr_ctxs; i++) {
+	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
-		err = __damon_stop(ctxs[i]);
-		if (err)
-			break;
-	}
-	return err;
+		__damon_stop(ctxs[i]);
+	return 0;
 }
 
 /**
-- 
2.47.3

