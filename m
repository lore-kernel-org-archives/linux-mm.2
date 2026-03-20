Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BBB1099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6AF76B0142; Fri, 20 Mar 2026 15:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B776B0143; Fri, 20 Mar 2026 15:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931A36B0144; Fri, 20 Mar 2026 15:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 813D16B0142
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:20:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1545416033C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:20:29 +0000 (UTC)
X-FDA: 84567407778.13.A67857B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C0BDC0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:20:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hMLNLWa5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LEQ9U7PnM7Nnhyw/uhPtGyUN+wAdVE54fMETFryOco=;
	b=HS49OLk9gVn/Rm7aMQtJ2j2cfxn6rVaFsyzX4gU9H6oskF2+JyVTTm/VPCOGAAxEFytkJb
	UOAkP6JUk3iO1ZeJSF3JsLFhQyR4kKDmG0hqDBrWIWiOFXf3IyzW94Em2gPzM8nmN70v+8
	gdfApcpiS6K4k0x8ddq39WKBGInecgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034427; a=rsa-sha256;
	cv=none;
	b=Xs/iZYlCab/No9/9eTlhlJIrHqSxyqZV3/8qXbXb3E6i6K9QSihPr3pW4hmGBgPNB4Bg0j
	0qP4g473zBXzwZ0k732v7oDEkmmGWKwxp6Xk714IrE8S4vhMeaqWNnBNg2Of/24OGLV/ny
	xjXJJsOWp1DlymSCcMLPAh8DqOf6ptg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hMLNLWa5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b06c43e6a7so5218705ad.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034426; x=1774639226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LEQ9U7PnM7Nnhyw/uhPtGyUN+wAdVE54fMETFryOco=;
        b=hMLNLWa5yLzV8OJW0W4I6HhkB8kp6l1kPNpZ2CH4HTCFRZ5k2hNajcBJC5yqUqhAQs
         k2xgSMyXFBySr/cVMSVp/ZXWhyHNIDOjnoid6ryPssAnRi4EW4zD88RnZ4QRp7I93FHm
         R6OzzFYTQKcO0lHs9FO2UHIVaAp3Pa9ko35lAlSgVb2YM5e0CTJei8jS75JtF8xyloim
         Xfjy9gST00S9oXmrGmUmOQ66jJ4ipu5pdjWY3Atxny06lEZHB8s7wcG6puL48CVgmWwL
         X8MfKdqRWYjpQuhj8CGqhNoBBdDCdt7GnoljVzV4cqoF5+faFEfBZJ7N17vPqo1Gd+KH
         5QHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034426; x=1774639226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8LEQ9U7PnM7Nnhyw/uhPtGyUN+wAdVE54fMETFryOco=;
        b=S4aIFlAk+cXJy9hEIjrJRT2WnIa8LMOnlsrnsLkWzavkTqGRn4vBG0D+7aJEpVMtiU
         8k+Phr0jIE0whO1YpDygw2vMCzv+gKOJOcyy2vF935+pCkTnTJNztPTbNNll6S8/EnYr
         bg1HXiu86CmdpZezj4KUGKEuxGXi22oU+IvyJ7pHonXy46tBHCpY3ld22E5BwmiL9uGu
         M3szj26pFki+CcAoktvW6d211Z1dI10DXSoWWl6fzsiexm3yr18FaRdNed1p/GQ1M/xb
         mLx6aj5eEhYCxbuOvWoUKeT94e7nA771mBBUWTJXtz7XtdZAn1snfCNu4yfTEG8iZApa
         6JUw==
X-Forwarded-Encrypted: i=1; AJvYcCUcJ/2XW+K98lBIjYOIeHbM9AqNYQk59p+MlYoJaYUGUgxfQRBU2FyZzdicnHzfkzGQYvFZXC9itw==@kvack.org
X-Gm-Message-State: AOJu0YwhhQdFXngCZu8UiSs9t5hFgBxCl7aENUUrV1f4chYZuqNpCX+o
	rzc5l2V+PkTU/BuQX/o7nsxcWRdH2lIj7/vc6rqtB2pj+r6uJ6/sV/G51GTEVA==
X-Gm-Gg: ATEYQzw9PHRajV/F/qSvUZPJTTKgPHqsEF3++IWy5ehAqNhSMAckNxNVflnwsh0DSqo
	wOB7NaW82qdjEeJzZzrcu1RevlhrrGcA0iCGa4DubyKJWGeM9RcsO3U71qF7RMwDDcsX3Scm+OS
	PexsPVuG7pRMdrK/rdv56mOQlBuhzzaRxgWb+FQax7Ud0LI3oQiRzl7JZTBlxAY3ePEfB1OOZcj
	jU+AoVBUlfxj1kxD15TRNwCge2jruzoq+M0K2IzNQPh/FOQJrjyAB5sGuU96FEVbS7rmBaJL+tk
	Wz9Gzuqu4k/N+/STaAJLSi50j9hgG6hw2Bs7q9au62wVOAr1wI7TjBsHKvo6smosVJIN+2IpSXQ
	INtWDyJ5qGB0rFX7kJ2OHY23iGRUekh0QFBJOTXxIL5C748tlYssSwUBUourcHmTxchl3D5JqKp
	Gz6L4cPEk3MasRvcMQmmR1j8A8ogDi0D7cTGu/PzKFgliRDIEiRvQ=
X-Received: by 2002:a17:903:283:b0:2ad:ba04:40ca with SMTP id d9443c01a7336-2b0827a4dbamr35798805ad.25.1774034426024;
        Fri, 20 Mar 2026 12:20:26 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0835161a0sm37085675ad.10.2026.03.20.12.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:20:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Sat, 21 Mar 2026 03:20:20 +0800
Message-ID: <20260320192020.33004-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320150536.98893-1-sj@kernel.org>
References: <20260320150536.98893-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C0BDC0004
X-Stat-Signature: g9sz4q45i1i5p5hp79u168tbp5nihscx
X-Rspam-User: 
X-HE-Tag: 1774034426-214637
X-HE-Meta: U2FsdGVkX1/7jUZ12+Cihw1l977Px4iOz1knXBcYS7LQ+kkYuKS8/Evlgos/VMc+s7VLoQqmB4l6GcqxwSldEqGYKdmYkBdboM+w4fjbhW9FgFRWAVnfl7lvWR7pUsaCihvzHIBlB/XNZdwPGYPGLwANy6FO0+ZxpsHET8/jt/CSQ8NksWPxeAzSSMelx9RA3iAfq97tFPk8mjgUOmCGZwJLGNimzNCg76DV7bB7KJI9Q49ot96ciguH1s82W3YpTUsxIaz/LiFIqoq2kvgfHUXw2N1cftNJBpJArwF+o1D0YOVtatfQGpSyib3FircOVe0MCTWGSJihevAAKJncsOjv0JV2pwqA3hhq6FTISPhNTDfFH2gG5FBDkaojXD8R3fYr5eoPY6Jw/Sj6M4J14CsJmoM3ForQkHuLP9+L9kf0mnnAsESZEqJqU4/lYb6NdDXH3+UGgIxZW+3vCz7xy/oDsNGw5284ffsE8xZaSupoqJBwhR9P+YMC+UA7sd/XKjUlowUCtqAyF6BSmLSoih08VXsWBzGaZnFpOXeYjmYHPApt5biXJ+ODvwchZQ8Kde1jc0GD+Vb5WcXC5zUbncspoZ1VTY/fhxlkMp+AoxuSjPXTEBbbg12AAsRwG9iKZhXRFK5VjrS0dj3e2eAeYBTxfbnup4OQ90U5AxRxoDZKU6H7h1xQUUyQOtaAdeAbrQIeokZRuwjTdWbquGPw43VQL/KVmhvWa6V809c4VPyh1AZlM20F4lGPqmzM4vJWsuf9jH5LH0FA7mVAMJMCU35kLxZKIFnV55B038Sd+WmVrHlaZEkx+ru6Qsa+XaY74Oio/Dgtf3MMB71taJ/4MOzmz365A5aJaiQ4wq/euCuLZQpibRR3egCO4XuxhryL5Ez4VkhgVj15yu1fpsx9tblsS5Q1RHc5UXT029fXyw9uQ/peUpg/08Y1h6mSS3YfcdlYqsDfS+tBk4h+TFh
 6HAqvOEK
 0Nsl1BVlZXu3uYj7P3Wp7nT6pTSZYjA+or9UvkXtnALyyqgbe73TtBhwsL0yedbbKyMz935B52LizfskcJ0w5PVOlPGykyUOHWZOsailicZeJt4Uk0PV0O2wVeLFFNAVnB0UGatKmsBu9eJndTbn1pQo8V+Mgu+dfehHaQYetliitA45L+3NOqpnxaWRaBTI7TGYNusleS7uW0KWzofpgSwnmb7qflsWpeFfrOQyIoMoBgeZh1j6uc2Jsgr1w0uMpzJcAahYMiBgHObkEJnWPISsHJC6fpFPbxOS3u70P3tdoOYyMmccrZWCiXg7VKh9RaGgJSsf1XOxMhlJfc1a06wjuGp7RAUuy1CCDF/OqAmuT8yJVLXx27gBtrh8J865bl7gpfLRLVvUt6Iaz0Z1mjEKa0KfeY73rnPeUeg536tJ6kAN5kxwsEzDlVj4ernWrFiuGusRgHfdV5MALGjb9wXEnjx09KSJHPcGlbZMsslQC3yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of damon_hot_score() uses a manual for-loop
to calculate the value of 'age_in_log'. This can be efficiently replaced
by ilog2(), which is semantically more appropriate for calculating the
logarithmic value of age.

In a simulated-kernel-module performance test with 10,000,000 iterations,
this optimization showed a significant reduction in latency (average
latency reduced from ~12ns to ~1ns).

Test results from the simulated-kernel-module:
- ilog2:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 1 ns
     P95 Latency      : 41 ns
     P99 Latency      : 41 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 2625000      |     26%
     40-59           | 7374000      |     73%
     60-79           | 0            |      0%
     80-99           | 0            |      0%
     100+            | 1000         |      0%
    =============================================

- for-loop:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 12 ns
     P95 Latency      : 51 ns
     P99 Latency      : 60 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 0            |      0%
     40-59           | 9862000      |     98%
     60-79           | 135000       |      1%
     80-99           | 1000         |      0%
     100+            | 2000         |      0%
    =============================================

Full raw benchmark results can be found at [1].

[1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
Changes from v1:
- Replace fls() with ilog2() per SeongJae Park's suggestion for better
  semantic clarity.
- Move performance benchmark results into the commit message and add 
  comparison between for-loop and ilog2.
 mm/damon/ops-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index a218d9922234..ac604fb7b409 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
+	if (age_in_sec)
+		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
+				DAMON_MAX_AGE_IN_LOG);
+	else
+		age_in_log = 0;
+
 
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
-- 
2.53.0


