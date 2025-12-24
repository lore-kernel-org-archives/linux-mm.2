Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC08CE75454
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB396B0088; Wed, 24 Dec 2025 07:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154A46B008A; Wed, 24 Dec 2025 07:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081C06B008C; Wed, 24 Dec 2025 07:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC9F76B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:44:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82C6F137B91
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:44:23 +0000 (UTC)
X-FDA: 84254332806.12.9671B4A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id B086C100003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:44:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EwKGOGF1;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766580261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BKYQvQ6NReD5wn+v/jU8gptz8GYN9a8ubrCMIsRMan0=;
	b=WzcVfS28MrT7FqxXPGrDaXE7ayScLmNUCH/e0/eqYRa9vRBwLBFi8vbdz+J5mKkZ/BiDdc
	UBRi6MvFLhbzW3YZ2E4/9OYkG3DQbXrbbChOQdwhDthMDg8wofwIVFpgxTKgu2ocrHqga1
	YKiVLfaCW5zYq3adY+0Khg0cBux894k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EwKGOGF1;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766580261; a=rsa-sha256;
	cv=none;
	b=qggqF96XuPz67nMos39kkUmY2xw/8bgkvrRkh2oSkwJlyZBYD59IndJvWCPb8Xf1j0JFXB
	xh0ckc1ssgPzPwgTvhtPfi8sP6tppNcY5QaB3W5/Ift7D40wAtt9pPLh0tnaqdrTmIvGnA
	Eot5sgBPlcO7MAaYjqt9TEYnFNl9XQc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a09d981507so42469345ad.1
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766580260; x=1767185060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BKYQvQ6NReD5wn+v/jU8gptz8GYN9a8ubrCMIsRMan0=;
        b=EwKGOGF1RqI+jGXfYenQ3Moo0uaDsIRfm0l2p1eSsFl92qgK++RYVMAkAuPTz1igxu
         Q2MIDpTpWL3kq3WS+z0AZyK2iHz/NUmxA2f+J3zPRhVp2Jkxeq1EGAf3Ol5Ay/2Q11GA
         UArpPnqFobuDuXa+qoAXed76yidcdT07546gyggJeUZXHoc3asnsSK6jMgnrnWQqX+FU
         QEb5eICc3d6cxd86BVde0cwKxxbMjPwnukot5lo1IxAqQAE76kjaSb9GaW1HQ/R/HUX2
         PWmByphU0rSgZI8cTBAM+qRjG9rDRyMfT4sZ8bpL7ziqq0ubfCifKE4Wd5Pmed2PosKH
         VMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766580260; x=1767185060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKYQvQ6NReD5wn+v/jU8gptz8GYN9a8ubrCMIsRMan0=;
        b=FaswgJ+09s4Y1thvJf1HjxMSlXNfDAtGO5jTm42OIBu/8H0Fc7wMgdGKr1Vi+Hl6kG
         94zvXrmvY70F98vAyJlhi3iaJzhzb684EA0D0U2ludXPlsyJ9Bk9qyq4jwajWLvNO3N5
         0KGUVh8u3hCuwvUxkwyu0C3tQKX8hT2wlIJjlCVI7JKH4Cqa03wLM2X+2W3kDUv3t8cR
         CkbgdekHzgvhKlKMdxgxuEGD6g6EdiZgWLL0tdpjDwBCbt6UsGFW/rzHceIVSn2oxrCY
         Njvst8PJvgM71fCNSGy5oTUB4CUH68KC4Cdlavxbeky8B2s/pV1xWRghTmi/+UdjO+8f
         UkjA==
X-Forwarded-Encrypted: i=1; AJvYcCXomhEQg36o8fUrECoA9m0aaEFIfhbsEUCFCaS4xTAFYa1VANSl6zY2YHNVsUxy9+LJ7MGuZdv4Gg==@kvack.org
X-Gm-Message-State: AOJu0YxU4or3d6YU0/1rZIjiDxOarBnfJxfsvh6UmX1+xUMAyBwcahJ6
	GBU9UGCOqgkTDhF4tlKgI8EqGAe0knsm+1HePpMmstVQEzoMwgtptecK
X-Gm-Gg: AY/fxX4Ezre0g5rGauJJQskit9M6vC+BS5lkTt8+GFVWEi2hTIyhN/FBSKwMGLYLTjk
	UFsxhh+tpJ21EFwU1KgWjvrqdUxi4PCHnedH5jMYjDf7lFbm5Fs25b+WGj8NDuNkq2M5obqmb+f
	awPb6ja89tjQM4X62ET4by5S3+KEEGsBg7nZxFgAFPd3GgOhJMZCeG7eW0D9y2+ik9isw8vVugp
	YtjfPafrVVaa5FyItgJxfJ+tB3Va5azuiuTPNUJfPuA3u2+n5HK94yz7hxKzw2/7KNE7KJ/nBZt
	jPSOkHyMzV2NqNYAnSxMAy5bUlQaE863nhuRlG5NebznS474vJ5RfuBCc1/3K1TiYX4bKGHW1zb
	psqonPBcPK3HNbp299Mhc5mLHkN4o2NJP/L/LVCJy/13IsXjV/o0xPhBWoVV8rY5b2J6kVRMuX7
	8Rrj0T7hEqwTaO
X-Google-Smtp-Source: AGHT+IGaFz5m5x5yWwSs6Wyputwoz09+EBgCA1HOBett09MOFwgLX12SwSxMG9G9A+65lYQFeOLZsA==
X-Received: by 2002:a17:903:32c5:b0:2a0:97ea:b1bd with SMTP id d9443c01a7336-2a2ca8f6621mr237053685ad.0.1766580260481;
        Wed, 24 Dec 2025 04:44:20 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d5f5dasm154014665ad.82.2025.12.24.04.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 04:44:20 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Wed, 24 Dec 2025 21:43:54 +0900
Message-ID: <20251224124355.31667-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fhr6qz6n7ny31hnaacitfbexciixowtq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B086C100003
X-HE-Tag: 1766580261-637474
X-HE-Meta: U2FsdGVkX19Q76P26US+vGB3oYuyAonsEdq2pfK2WobtQHxhQ1MMGTLTNwG7BwMdAIFL1OtlCt7Fp1gM0Kxx8OsdfRrnRmPlf0shRHhIUxyBDPFrIZ3lmMGYEluCRoY+TstkKSutt5T58iWAMvSRlDYYKJrp9WQqAnFPWIt/AuDvsTRfUmDHkvVpeACPr4rX3v5VjvLUoXGUSlY5oGU40n3+EiJzWes1O//l4cExnGj2E5ORvEA6Xb43kqH9Vsg1x4xkWg9gWuLtLL2zTwBNxtIzLTncD5DoplhiZWCZQm9KD3+JiEuOK2r+KFYVGHay6uF6IiPTlfYta7xCfthJQu4DZ1rih4PwYAE6uqV/XTPZhr3XVEoF1IXj7JLB1tr5KBetP6RiUX92xJZepkgPpsRvrB1MBjyKZPFhy9ce85hr4oIgMtwd2EX1x0eyAgkoe10ViClpCKZ8czOEMl14SNeZfnFfMC30xF+2HL5QHc6ljr+Fs28PbG1GlfFYSjMifIR1a69CFbLImatrIX+i6rbFJidCW6ICm3/A+EZxurd3Y3HZW+c59ODkwhazH1hTeDVMr8YHaxX3CPvjowQ5yro9KAfw+u7IgibiKnyOmUaFhFyqaHsNQ9abMPWC0d9PbJRCWhPlvrZnyidc9Vv85yJn2BrzigAjqfaA+IPW2cvV+lrgFuFVWJhRiQwnOWzdt9vb21y9h0cPx2ETCrr+X6asEneEzRYhWp4hGATNCTcIaOl9Ii8bQao60kv0L7SScup/nB/lO+4UF9aCDpy16PEgz41kMHu/JdMhROpWJJt9NoOm8N473/GTbOYwgWDHN9cXv47DBmJ7NGFG2dwBOpjwnIIJxjwB4QD1rFZ1pMbwF8/+0VfQpXucnDGB4rKbkg1zvVdb1Chyan16j7rrZqLal0aeBgFRbgZVieSjPPA83JPpsQLrdb7QM/gqPUkMrBnowrdUgBKjuWHyYF0
 qz4qcW4l
 g0r3d1JXuXmBIyYNmr+flF8gUjqWGk3lS/5Jq6clsOtUcDWEChGAtdyRDWWIJgAWMzaTIeFpLQjbeMV+2g+0rsC58KfywsEm6ZEDaS+3B9lpkkiF/B6jCIZ/zIPTe5wbTCvtXZjE9xZtT5Cftvmu9WeWZP1L/i1PrhdC/UlU+BpEctx1ycrmO/fHu9022jtEq7alok8EsDjARLX1zsKz/9yTj5OkrFHI04I2BBuNKiDso1d01ccU+AMAOJajTcOqXsAeDLtrKDhG6AYFC/gUC2fkz8LhQMEcIsbNTfxAJ06ZmNSxjLXbb4Yj8pyvZubYe7kvGUvvyxZ9LsGcAAneCEIMwYJnVvFPPI+y4WwxEKw9Wp7CiROLwshC7bMAC88NL/57dqHiMeDe9gDsvUjXtaAiE6E/MKYo46dflHH+ozN+dfMXZTFJnhz5U/ti2lBqroqKu7ysrzwbIL6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kdamond_call() function is executed repeatedly in the kdamond_fn()
kernel thread.  The kdamond_call() function is implemented as a while loop.
Therefore, it is important to improve the list processing logic here to
ensure faster execution of control->fn().  For ease of explanation,
the data structure names will be abbreviated as follows:

damon_call_control.list: C.list
ctx->call_controls: CTX.head
repeat_controls: R.head

the execution flow of the while loop of the kdamond_call() function,

Before modification:
Old while loop:

        CTX.head <-----> C.list <-----> C.list <----> C.list
        ^                   |                           |
        |               if (C.repeat)            if (!C.repeat)
   restore: only one        |                           |
   list_add_tail()        list_del()                  list_del()
        |                   |                           |
        +                   |                       complete()
        R.head <------ list_add()

To process C.repeat above, we use an additional list, repeat_controls.
The process of adding C.list to repeat_controls and then restoring it back
to CTX.head is complex and inefficient.  Furthermore, there's the problem
of restoring only a single C.list to CTX.head.

Below, repeat_controls is removed and the existing CTX.head is modified to
loop once(1st rotation).  This simplifies list processing and creates a
more efficient structure.

Modified while loop:
Not used repeat_controls:

        CTX.head <-----> C.list <-----> C.list <----> C.list <-------+
                            |                           |            |
                        if (C.repeat)            if (!C.repeat)      |
                            |                           |            |
                          list_del()                  list_del()     |
                            |                           |            |
                            |                       complete()       |
                            |                                        |
                          first --------> list_add_tail() -----------+

        if (C.list == first) break;

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/damon/core.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 824aa8f22db3..babad37719b6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
-	struct damon_call_control *control;
-	LIST_HEAD(repeat_controls);
-	int ret = 0;
+	struct damon_call_control *control, *first = NULL;
+	unsigned int idx = 0;

 	while (true) {
 		mutex_lock(&ctx->call_controls_lock);
 		control = list_first_entry_or_null(&ctx->call_controls,
 				struct damon_call_control, list);
 		mutex_unlock(&ctx->call_controls_lock);
-		if (!control)
+
+		/* check control empty or 1st rotation */
+		if (!control || control == first)
 			break;
-		if (cancel) {
+
+		if (++idx == 1)
+			first = control;
+
+		if (cancel)
 			control->canceled = true;
-		} else {
-			ret = control->fn(control->data);
-			control->return_code = ret;
-		}
+		else
+			control->return_code = control->fn(control->data);
+
 		mutex_lock(&ctx->call_controls_lock);
 		list_del(&control->list);
 		mutex_unlock(&ctx->call_controls_lock);
+
 		if (!control->repeat) {
+			/* run control->fn() one time */
 			complete(&control->completion);
 		} else if (control->canceled && control->dealloc_on_cancel) {
 			kfree(control);
-			continue;
 		} else {
-			list_add(&control->list, &repeat_controls);
+			/* to repeat next time */
+			mutex_lock(&ctx->call_controls_lock);
+			list_add_tail(&control->list, &ctx->call_controls);
+			mutex_unlock(&ctx->call_controls_lock);
 		}
 	}
-	control = list_first_entry_or_null(&repeat_controls,
-			struct damon_call_control, list);
-	if (!control || cancel)
-		return;
-	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
 }

 /* Returns negative error code if it's not activated but should return */
--
2.43.0


