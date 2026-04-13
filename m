Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADD8F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4074E6B009D; Mon, 13 Apr 2026 14:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7A66B009F; Mon, 13 Apr 2026 14:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0F06B009D; Mon, 13 Apr 2026 14:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04D946B009D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B576A14028A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:34 +0000 (UTC)
X-FDA: 84654426108.15.C1BE4A6
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA0312000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W8wZ8OCI;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5pBgT0tZYU/wHSJl6Q7z5nPOqIISujBps3y+cjKycw=;
	b=1L44oJZsu1fsdDZweWLzswO1W46d/nr4qijTjsQ7yGH3oLxHvNs1iejgnbguZyrAxnNW4Y
	sp7sbxexcwncboN2W0mGPIJKlbTAE+AmuiZx+ldHJsQ/tjipSUJDUNBYzQ1JWvVRhEcZl2
	2hSb6sPnqq5RWl4QR+JCu+0aGLOD9mQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W8wZ8OCI;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106293; a=rsa-sha256;
	cv=none;
	b=0dFR/nYEfHS7MOEDQRodZi+Q+gB8O/aMtH1aFBZSnpFximU3vE3Lv9X5Lqe+qLikc6Vzok
	Mln9Pj9nr3G71HkK8TpleR5YIFbvLrjQSND3QuGHmRiQYtBPzGSl8iThCjRcowomiImBT0
	Jq5AMFRFUZCut8M1sI8Pi6CVljxn5Zg=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8dbbc6c16b2so608652785a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106292; x=1776711092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O5pBgT0tZYU/wHSJl6Q7z5nPOqIISujBps3y+cjKycw=;
        b=W8wZ8OCIz1hU9XgG68SbcpwxR8izO6BlwDe02xP4f35cHYq0lCo15/4orYqPvv5Aq7
         Kuwm4d+4Ozg4KNHpHtmqDd5fImnGICcS9EJTF/0VwAA0ENS/FdPeYRgbzh6fcerQzV9D
         b93y0dW16zyao+l1v7JbPmic2+xHsDRQXuQ1uvHtjGj4aEOk3mKl146ueZy09GWrhHp9
         2b+NxffnuGiUPeKHGSE3qN4V58sWOnjdhQ1fYqZk2RyF/FQpwNKkVO9ivbvXF50IarJ5
         rDLAcw1YRnLIggB0/ml4qj7SKfPxW3/v+YPqbUG3gooAKyW3/yqGe3PG8c98bZrb2HfX
         o2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106292; x=1776711092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O5pBgT0tZYU/wHSJl6Q7z5nPOqIISujBps3y+cjKycw=;
        b=Ylm8o2gly744z0JPpUTbYtGfsHCaUVaBWolQhjqNCwFAUhV72yGquVnzqZsPMRtrS9
         uqecFOcAyhLejrOCSVppUAtERRRb8MuAKD/RvOa4I7CE57qiJ1FD8sXscW6CTFqFuyO4
         z2drKHte6zBvh98n1gbyF9AhfljWAvGq9qOk05wBT706qparNPirQ34AAl4tMP+5Ea5p
         WFjqxQ69eJlZ/z6vQmB7DjrtPDmKDjNtpEIsq0rVVQU3QnErmYzvrk3qg55aP4iyzoWR
         N6MH+OfdFbZm/66qsR0w/HusgHwCCNRduJMB8pblkEplPNujw0IAxuANPaJktpTeLrPp
         kxgA==
X-Forwarded-Encrypted: i=1; AFNElJ9GQ1/82I6evEYH1wWQD1mhj6v3Igq3mW0nBbMdO4dzx3otucI85rwHMkAokWnrce5ssL2wzMzA3Q==@kvack.org
X-Gm-Message-State: AOJu0YxDo94IipIjmle5nDfClfW/ejv6sUPlvwrZ3JXrvMLVL9vt+XyR
	v7LyU+n0h0AZonKwYk96c42vwid/vOzSR/fENK6QZXDIHQ0ZV58zK31qtgFk5TqP7Tw=
X-Gm-Gg: AeBDietr1mm5hSTIKLo075QhFQz+bSuhORP5FbSoMtbKnMjN8neC168xsG/jT3ZUitb
	O8XZtZ9ylgDzM6tzjW/YULyZTv1XMmy8Hbvav70DKlu2nzzWM1iEbSU9OgNfegMGhogHUBijMLv
	SDNPde16sWY3kBDNfVxqfGiXyO8Oda9U86ZS9ZYFtOEG4XteB/HEKa7YouDhzvysxt+FRCA2l2p
	VIuvyAw8ZwxSNepsEkeYedW+olvBAtzoSfMrRy0GJiODXPTluevtuAmVkl4Ckm75B5EevFLK3If
	E0RmbRngWKXRr3Fe6EPGoTr9CRBWDqgYMGwf9rWkt5THPPsmZ6SYh0L0Ghs7p8mD7ZFreCW2l1t
	Kzjtdm+92vaEMtXMympUmwjP01IAvcYQDiF/yZPjF0j0Zrj20Nzt9KmzU8qjzmR9LtSuiIqtFjh
	idU7m6DEH+NiYecdxIIyHCAikMxN3kR/8ac6q2uKOrmdcKSgBdO7ICm/lJA0dDaS3AuQ==
X-Received: by 2002:a05:620a:c54:b0:8ca:3715:eea5 with SMTP id af79cd13be357-8dc444a9272mr2315610285a.14.1776106291953;
        Mon, 13 Apr 2026 11:51:31 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:31 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 02/11] liveupdate: Synchronize lazy initialization of FLB private state
Date: Mon, 13 Apr 2026 18:51:18 +0000
Message-ID: <20260413185127.128180-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA0312000F
X-Stat-Signature: krnz46mtqhpbxfujn9i4nt7jbeuhyq4a
X-Rspamd-Server: rspam06
X-HE-Tag: 1776106292-766283
X-HE-Meta: U2FsdGVkX1/1H5hGVo/heR8Wbr1g0v11gdB+Qe4jGaP14EMXPBqzAonCxETnFXWtVzKcZe0nZBxdL49jFhF8NbDelKkt4XQaxqgK0W4uKvdvQ/1tly+I6UVIiD2py14c3/Yb4AuAcvb1EQZo0C/rXCKFnRTIbNg3Wl3lnO1bPGYOTSGK280cOU4V1rWAaRJ5vulIlWMhmpGieM7OYn+ykcXOUKhu380I3DWr2TKMcRUpsj9NiNiP6KT9koauLqyMmHYtyVdcv8FpQ/iK+0M0lOjPQLeWE2/2MUmanUxPNnNdDNz9M6NkySPPxL3JwEjo+izCY6Fk08AiQ82PTogM2Lp/IWwgOiBUgSE//QAyqh3g8aZhEaRzvh0gh0koqT6rLc46H6N7kF8dctyfy61ynXYH4Tm1ql9D0xlyIp0U2L9KTSOR4zAmj8DQbs/5QqtUw7wFrXRCJ/qZBMgx0QX6t9YzI2pRF2FJU5tIKSsrmr1mSV/FIawoaRNI4JzbStpVvAc8RTTB7huMLGzsYiiXLqk/trMiQHEEPjVZotkJMQqBWuSk5XwSBk6QjuxgJ6qOuK7IYjljLoTMVpjGFxP5rn7n3YpzRROfFHMGWbXvfqf8qiGTSexHm4MiyyB0DpnmSqkhVjyycjCbSA2gN0awTvZ31LUGpYJGm8UzZroTWpwStGoe1dseLRXVIlJd2Lyyuidx1wFmiGDI7LE3nLGPtUhZvryQrTNdNFyeng/7oHnB14qsSFcfKSoTnCWjQObUfk3xaKkGxSTE1IfOdouXbwwCQdSFej7Km4Hb2rYMsjm1iqjtof6/NPo7qGg5azhYdI5A1m/AuOt5KHRQpf0UaN7Z6m579wsTsnosYo8VBn/nbTZIr+aAmCFAaUAntcIINxvKTy6IH8yjBKwERMYF8y10k89Lt0PdTENtY1Av8ZljNzl4YtNCrTdMXBsMDeI3zqd4EbTXqyw8atXKJN3
 epKyJc8s
 /m1uVVSSh/yR7XfPubN9Hh86ddgKqbaO9wK61JVLAdDhZvv8ju5d7BiDel8txlZElSuzjA2i41RXiXCQX32HwnKGEqW5m4mFE5ihnyN0QlDsBn9fPjajvTK8yWFdle3041zdnGpuwWjCKd2aDSWRnLhOZ3YskOvPt7hqEN5GaSVpipcyEu5OuW8zKJvLR3GSO6TIE/aCBZB/r/1fpBUiToRR3ZYOt/paPyPWmPPua6sGMqQU7EdjzvAanedoMpspj6cvFT2HAtgcMjPzC1MZmDIR8XfB7i9VQOTJzDNUbLN7n9bKkw47wb1TnM6imLMEXc3k87D08tIDg4GowkaBiyKYcXyrVzsVJo9Iv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The luo_flb_get_private() function, which is responsible for lazily
initializing the private state of FLB objects, can be called
concurrently from multiple threads. This creates a data
race on the 'initialized' flag and can lead to multiple executions of
mutex_init() and INIT_LIST_HEAD() on the same memory.

Introduce a static spinlock (luo_flb_init_lock) local to the function
to synchronize the initialization path. Use smp_load_acquire() and
smp_store_release() for memory ordering between the fast path and the
slow path.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_flb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index f52e8114837e..cf4a8f854c83 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -89,13 +89,18 @@ struct luo_flb_link {
 static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = &ACCESS_PRIVATE(flb, private);
+	static DEFINE_SPINLOCK(luo_flb_init_lock);
 
+	if (smp_load_acquire(&private->initialized))
+		return private;
+
+	guard(spinlock)(&luo_flb_init_lock);
 	if (!private->initialized) {
 		mutex_init(&private->incoming.lock);
 		mutex_init(&private->outgoing.lock);
 		INIT_LIST_HEAD(&private->list);
 		private->users = 0;
-		private->initialized = true;
+		smp_store_release(&private->initialized, true);
 	}
 
 	return private;
-- 
2.43.0


