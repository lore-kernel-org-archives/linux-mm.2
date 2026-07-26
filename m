Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BBFC531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4806B0095; Sat, 25 Jul 2026 21:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165EA6B0096; Sat, 25 Jul 2026 21:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C5A6B0098; Sat, 25 Jul 2026 21:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50026B0095
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:30:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0380D40435
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:30:08 +0000 (UTC)
X-FDA: 85029196896.02.5EF4DAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 69AC6C0004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:30:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXdkc6lP;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785029406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXIx3P88i0Okhl/aQZNUW0Onovm4EG94bR2fuQhD3Gw=;
	b=IQytyhgOXrdEQwQrHxHwhJNz3DIukH6FcrrfRX8JUW/cM8aU8mSoKwfao4QCDPvU3dbzkV
	gTvffEfKlGJTqdqcqB2gWA/ebtMfaj5I00zjGYczzIcynjxr3WNRr3faNpJ1ycFY0a4okd
	hpUENq4WtP0S+SV5r5/GdqJIPvI5XWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785029406;
	b=xPHAzgybC6cy/rI7Ff7c2VCH712s18JkAhBsjlz4VY6KsRqrE5YS/+cMmuUHfuD6ukFwwC
	jrVvlvm3DvD6OSqUEoQ+yC604ZkBTvzWQiFziHU6mpy63YvErmd8TDnFJ2VrChQmVgsTAQ
	JWm/F3C60MkcWxtmMcdj+55BLAYRyW8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YXdkc6lP;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B45C941339;
	Sun, 26 Jul 2026 01:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11A71F00A3A;
	Sun, 26 Jul 2026 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785029405;
	bh=eXIx3P88i0Okhl/aQZNUW0Onovm4EG94bR2fuQhD3Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXdkc6lPsHAcUyrmPZhC/0X0W5QT1dmTqwaUDJuXB/kWO9tl+RQc1lg83tjvQuOOl
	 bT8KzbipZVPX87RcM72BYVMjgjW1yUPgTuK3F0BOS7FBsGALFctio4ZU9HIrfMamNh
	 qXLI8JcqGVjMeyC2H8ueb8Ga+3fEvCNJVM1pHeRVAE1ZBl+k0KjFHKyv5DO8wo1ChQ
	 KTmIPnB0vpGe4/1tAb3iAZbQ8kPWI2adXKLif6OtbtXtsbZYFvqHqEFFbuMLTqxEi9
	 WP4iSqM0jDMtuSgvZ9f6X7n7tLlaiSHyCnsznYia0a5Xl9GjcqUeKWaeefwxwMXM+Y
	 WrOwZ7mrseBvg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 4/4] mm: mglru: run aging if the preferred type has no folios in reclaimable gens
Date: Sun, 26 Jul 2026 09:29:46 +0800
Message-Id: <20260726012946.18684-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726012946.18684-1-baohua@kernel.org>
References: <20260726012946.18684-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a9mtkmns5hdrxcqgnynqt4yifw6q31qe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69AC6C0004
X-HE-Tag: 1785029406-656334
X-HE-Meta: U2FsdGVkX19gKtjBHbHj7pxvc3ljbe3CcrS4+X/eBGj/FXAgvUdrv3Z3EreO4aj1lyq1+giiTqngupShnv3t8svIk2mEyHiViL99DMPgWVODnInsdc/sWEV+R9+LFhR5NI7SRe8JbP/SYdqozAva1Iw1bnJM+lpTDzn62MbjGQWfupnS85NP+OL0pBbcXcuNPPuhSubhVvLwbJJUxc9JL8nYX4KKfSJdNsqURlDtWQlKQnzvXAnuz1M0W0EtONMYFhLxi8CJu3kLX+Oy9XUGQ4QQPMB/VRmNoP0d4aqt3zThEyNaucFfT5JsHVfeZeNDjP628x5YfuUw81R5J6PSSLNTPVyw4hJaT0bTtK+lM+D4/a/lTa0oYT151CeVXaZz0ajRft3goJxeslp8zedJHdJh5RXVCRrmURfxgFmHBAqreJd2VggXvIcZaVDHMVkgv80jS53fHuKKcjnUIVtBGddCzgBLKPAY6+HEZfH3ZqgR8uQVsz4eEYHqybASomPd/HG3kfGgR12PDlOWQm7PTT97yYjXxgvrI/k60I3UM7jPiqw2HQeE4EjgDtnKS8HSoc5nW1jRMLIcIeamPPpmrWRv2qrUOoRrAfsZ150SyMGlXsJkpnHr+aatEIFNsZAgh5/TpB4re5jjBE1vyJ1cUkBz8KApFaz0Hu69yy2p+u+VwLLd7cfzanqdri1pe2m8E5qeSVRIE6lgQPyUHcxHF9AwEGpYiIVLsw/lf+FVTXmIlRYQXyxIRdT2nWIh6vIUk3BpsGh3N/nM0TQHBPLHJbsutAX9+hc26P8i4qgu3TF1GZCl0jQIHIN60N9GZDGRUZAnenwTvGxPeJPWErgVfZ3k2E76LCB0pY3U9DOBNrCJ2HLo3Y+kAubFKepSKcFDIZWYGlSDThYr0vVZc/i0evnXc5W5BmAB8fmWqvDFyipVBgKRkUezTBkBePoGM2ek0fqtP78B+Vfca2X64J6
 5ESHS2Xc
 9O9H0zGqTfI0c1qwNKjuTreq+RuS0aR5CLNv1fKwGQTd8DFjIlyTJyDPjFB8+RojlydVrjJECG1qcxSK00qSYtQRhOP9VNaMwz98SmGtXlA1ObWxDpr8LKjp37TNqc32tqMDB0sW6kwnIDZJYXmz/NX3uHPf+Zas4VDpMGWgJpLGCLoQKjz0zyH/6WPb4F1Oz6+OxuMSn8khccN0CXCJ3lVgeeV7GzYL9pCjwItJdjo3s88ZZ5E2fyUFGNNhl+u1vdfxo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Respect the type selected by positive_ctrl_err(). If there are no
reclaimable gens left for that type, run aging.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9aac4febc206..be34b8b946ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5000,6 +5000,10 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging if the preferred type is exhausted */
+	if (min_seq[type] + MIN_NR_GENS > max_seq)
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
-- 
2.39.3 (Apple Git-146)


