Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A23F433FE
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345F76B0005; Thu, 16 Apr 2026 02:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DD16B0089; Thu, 16 Apr 2026 02:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233D76B008A; Thu, 16 Apr 2026 02:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11D546B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:23:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5C2E592C2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:23:10 +0000 (UTC)
X-FDA: 84663426540.09.DFBBECC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id DBFC140003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:23:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aar6wN2c;
	spf=pass (imf01.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776320588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KnqPahweINxbk1EYagmBtu38zsab8hXqw/H096vvZk8=;
	b=pu7IKvf4Bhx4uNqqLRYIiEuFOQgm0uvrir/dZaZMvn7PgBLBOaBmVfuEHgZmKzGy2oNTJT
	hy83ptMVisYCbrPy2SPTX7Hf7E+4r8H6VOOBKwayqoIMwqQ1P7LSQKmpiOOhtI4qX85/5u
	TbvvxDfFPjWsa0AUobZPKLTKjzCsN4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776320588; a=rsa-sha256;
	cv=none;
	b=fj391bOmqM3sEc/21FvATo5odVRLUktvrXQOulHi0AmWk1EEecRefKAaEyXJNP+7JL6PRy
	K73XZbpR1v1tzNuFU8GlMZGB4WNaOm7QHkuv4gcImkVZdcYyWl0fzGktdRq2CogG2T/xaZ
	yKDs/tJVvWsKpSAi7Ge8RjzHDhniYDE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aar6wN2c;
	spf=pass (imf01.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82748257f5fso169580b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776320588; x=1776925388; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KnqPahweINxbk1EYagmBtu38zsab8hXqw/H096vvZk8=;
        b=aar6wN2cFcyxN6EQ7pjQQkJwLT2XY4HQ697vBkEo58/9lMRSPfOxXgFzmE7UI2Kp6h
         ElG/SITQPUBtyv77rmqVJhgh+E9iqbJeTnYdfp8kesqR7eNyrbzMKmzPyDYrpnvVdVdw
         xMECd0z9EUze3DkkyRzwnF1/AnCxat83aE8Hrn6bcOm1XqirHZcwKUYjeGaijqys0L8D
         QtJgLIk5AxmwLQadMP+rZZjBI6fejUE5lw8eotUnWYjlEzoJsKkIInAI4eZLT51fs3Hr
         T8gP3+q+lAVV86rAZ8pviwL2b8lGKdeOguka68T9iu3nDtKl8dGLMKiKQHPLqSXvMLf/
         Rn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776320588; x=1776925388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KnqPahweINxbk1EYagmBtu38zsab8hXqw/H096vvZk8=;
        b=HLlHQwl6hAufx52t+0BM76lIKrN69t5TVgdjEfp8xmFjxCQc0NigSrxxYVP2L7f2Dr
         Pm9bLwrobI3VeXOiaddtpGePqXRa5obN33HEyWOZcN3b6Kdyi4EKWEZd8du8TYnkLVQ+
         mu/H0NI/BUMKGjWXOX19xzSiCPk5zMQQm1DoaYV1TUNzSzPESEDwMvP9hbf1K+sSzxPo
         8ZcbGxZxbp5m/8zyYItOmjeEpzCVMVGtSy8dHMWB9g7/QCrUJsjIKA+woXoaF446D+fS
         6SB3wEdn5rjAkn5iOHdav6KtzvjR4ulW6/fPYlhKYpVDd5dKTzPodaJgc2PlWwnVMU8D
         m1eQ==
X-Gm-Message-State: AOJu0Yys5kbljD7Lt82P/iOERrbCbDwcTGCIm6pki686M8gDMhx+Uwjd
	jMPPpGf7jVr0u4puuVrDTUzgsLTIuzGaTq634l498uuYmy83+zemhYBZ
X-Gm-Gg: AeBDievleDnD/kMvlGkF0bz/MN9CPhDg0qymIeDICkKm+H3St2XmCSnCjL84JxLjzoP
	DSXO0lH6FF8hSmwR/xSOvOi9A+u2jvH5xlj6hd8gb1IVzalq2c0XdjyNMU9r6kh0XElti2UD2SB
	n7Yg+5OQiG1UTTV67SGlbcQ5TiSPsYtk81rfhSPNuMc1zHez8XJeZ1Tie/6hU6R1o6VeiSNfBs/
	eBDwylq0C18j5u5SSzQ9fKEpM5nwxWx5V3kVJFo1kejdwLWQVSSKAeKkjyTi5sWpRmKDh3OEhvF
	GwxfU4ftyk+9TMS2lE+D+yjbdivN35VQEtMGvNTmWqrIM8PpSnP4k5P74r92pHzKGAnBZmNuh9S
	1jX7mX9etBMhxp9NU69NQgRPCj96jnNI3NtDNW8AumxV6YPit2DraYRx2f68VDvf3/+Tw8j/6Ht
	5E8NPqhQA0p4fUSs/t+DzHP+M02QcDp8BBqdxtb5lu4gU=
X-Received: by 2002:a05:6a00:91e2:b0:82f:6de5:90e1 with SMTP id d2e1a72fcca58-82f7ee48b69mr440878b3a.24.1776320587670;
        Wed, 15 Apr 2026 23:23:07 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f66ea6950sm3905459b3a.0.2026.04.15.23.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 23:23:06 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH v3] mm/vmscan: fix typos in comments
Date: Thu, 16 Apr 2026 14:23:02 +0800
Message-Id: <20260416062302.727468-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DBFC140003
X-Rspamd-Server: rspam07
X-Stat-Signature: a63d4rjth69k9iiqifn46b73iqnninz7
X-Rspam-User: 
X-HE-Tag: 1776320588-597469
X-HE-Meta: U2FsdGVkX19lnS9mOm0+WpyNZYGt6s05M9CxeHaleCGtUv6oGeg7PLrGY13HhQJB524GjxcBS2aI+V9sBGHInqvIJSUWWOIEbz5jcN6flqO0o43SqyKed/kN9X0R2SLOtjIo4wYMj/4zYnyAztKeSTBC8tyETSRgnKTRDNL1Ds91jrtdJdoqpYf6OPdgRMAzSr4nqBMvCOTT6MMpHNNLZmV/wzFtTwGLL42B+aJKDE/dHiAVNUHBAKEk8vbuA1tueDyGEp3gusYTAKCA90CTG8iZtUnDVkh7rcZqU9xBDo6r0rdPzqn8QTGyCcY68dAwvoJ8zREt2sYwWvucEV5UV/32gTccTLNyOcaVQYDLaTDysKAqB9UbhmDHoa6IW+0JqeIKjvNF5fMKV5Qf/Sb4JOR5l6+WVYBskjiBlSUnnvQjmrivu3XQoPurbE/4J10YckgSmFcc0TiXGnHCyh3rSNQ8XCCvSnK23gOnrWskJExBqPg2nTG5oNNqeHvzv7vsur0gsk5gDLQpxIPkK9sc0VPeJQKT60fVjwvVEUhEGJgw0ZCMyWwS4eicv+gyAl77HHcakk/XNtfBIY81ZpvhZSAuTqVRkC6YNJnP8dggfjN3L4zKvq0MeB2jsZFpw1ZhDUdTH7t+TVKw0qdQdddqzmfDDwT0cBszMlk7hGaRFsdFYveRE8oLMD+17cJrL4pkmKBEV55pAh/JCHC0sqenp28pyrGIv+y0NOd7OMY4bOJT9hNqO4eBMaZj8ZW/YWgS/Nt0/lbcR1hHUL1KrPNPiZ3f456rUYqXg4MWv0QVqnH7PSYt9meG6owPZGcwmkwvfj/hMIRQwF5xNPrg0oFPnl5n4yi13oQ+JAhewI8W11Z993bhul4W0zJs9p62UuTlVygxikbig9muVgXQeTSZeMXKdazVQm4tj8+YRuM7mCztQq6S9xSiFpmGJbNOq9NrHlmisww6dyj4917grX1
 CY7RIwYx
 rgTEj6AVAAYgCPIqu75ckPSnbiGHvrK3Aa7Xz9SJhfSW1KQKk5uefqgOIq/4kI7pTzi6SSG6/9hn0mWx08ioWIDqF5OlszNXRpjKPdZZZcefUbQox5tRmZTRifzCzOYxWCaLMui+aiPYlw6ijMA8MOfIgAfnm508Q/ws54KIt9tfEDqvMos4NeUQiLUhtjeQK/APD+DnnJVdPDlOtT19rpO+4VOJaDPlHUuLsZnQ1fT+Zq07f/AFShgeYOyB9fKWzW18hWWfSm/pTNQ/BI7hXvfqw+OPdLKsCIiugdKHxgkKv56M9pBwXgB1OLji7T+LqnD3lCLgzDBDFC0CsJ8WFvOKY1aRrYiPXwTCvPCnK75ra+/tPBMLyrocJ7aaFIWM3hyGjV1hD814mzkC9hGn5MDm/oSf8lGTUhjXb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
- Line 6208: "prioities" -> "priorities"
- Line 7067: "that that high" -> "that the high" (duplicated word)

Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..710fbe1ee151 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,7 +109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
 
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6205,7 +6205,7 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7064,7 +7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &sc))
-- 
2.34.1


