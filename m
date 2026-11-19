Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEF0606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=KtNOYfFc
Received: by kanga.kvack.org (Postfix)
	id 16C276B05B2; Wed, 18 Nov 2026 23:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116286B05F7; Wed, 18 Nov 2026 23:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005B16B066A; Wed, 18 Nov 2026 23:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBBE86B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:14:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 355F4A8642
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:14:22 +0000 (UTC)
X-FDA: 85450551564.19.12C1817
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5F5C5A0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:14:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KtNOYfFc;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795061660;
	b=mtEybLC/8HOw1obsavTrVcwVQGWeeUYXas/wFI/9kWLHr0I4oMV9WyjEZcepSNxK9izuBo
	4vmQctXgokLBj1wRZdKOVjH7HwB6K3LFJuROcu2xKIliBy5Q/Ono8UXxjJgf49wz9xM7PW
	oozgaAgBtOkpz3KJL2y4RRFQI5vYe/A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KtNOYfFc;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795061660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiL1NT5qnEnqZDpOhZrlQYA5hzsUwLBbTeQ3CkP6SRs=;
	b=nAY+CmuSV/6tPjG60AQBO1BBOP0DoIaBQO6ffLRqjIAfrsSw0eFLvPNhX40QqTmM/OC+3D
	kQGbsu/zl+P3YjkBVZCZaRBV2OdJE7LqQbYn/egQ4aU5azeoAYtD/VdsMnJ861pkV2jJWr
	xOBtGgjjek4cUFB2IBm6p//4M4Knl0Q=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b094e649d3so1202563a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795061659; x=1795666459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NiL1NT5qnEnqZDpOhZrlQYA5hzsUwLBbTeQ3CkP6SRs=;
        b=KtNOYfFcRtXtyGjvX2dIQ5eXvkPvXINUoRHBXk0rkdieH1bQLiS0LdjXnmT68lYnGQ
         0K1HLuvAofNAJ1813FwCvHazoxdzTKz/70tyrjQvscHcBCxhuCFYGRuWUTlv+tk3Is+p
         NXh7BSuu3BlbUHUnQnSNzCcka4zzFBqwEnReA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795061659; x=1795666459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NiL1NT5qnEnqZDpOhZrlQYA5hzsUwLBbTeQ3CkP6SRs=;
        b=YerCbRvnsMhqT7sYSQheGGAS/IL8FbftC8gNi786ZVS1BEOmL2IugA7Mx7wznGWDKo
         HuxEKfT1L9csNG8ZfVYedRw6LYlaNgoAfiAaQmMP4VaDBvxZQuUJUF04raMBxSvrabVV
         p0MT/P7YbkLntyXG9+5PObhf6zneaCSSDRy5CRmy/bpWoF46LeIklBzzXchotZtEZUgP
         Z5gz0fsTipAyg9jw7XENFcHeLWangUCxbar+ig5N0JVG1M3QaMSRzPWE58f9qJ4t+WYU
         Hbaya7g/k2TRGtlIuYSJXzm38wxfVLgopFXhiogfRbIk715k4Wtp2R7t4i5xpYid5n3g
         TF9g==
X-Forwarded-Encrypted: i=1; AL+hErEEPK56HpYlFTbTs82ynIqxcpmrJiH5AcVq9003mS5U7AS8mfbqV7ksXMu+MOjvuEGTUIBt8EeGOw==@kvack.org
X-Gm-Message-State: APuU4Z9OdtEV1ICuFX762yZx1st61GDvt/AzzJEtoqB7ymPq5sPDgx5u
	HCem6UjdXSFncm5Z1XouUDZfdcc3nh+Z4R/I7p7Ag0q/2nyoy3Tek+t1sVAmD7Cttw==
X-Gm-Gg: AZFdTZf/pgcTLpRGUlqnqG8OOR1mukNbCKbcHgldIiFKjbR80ur564G4nKYlAb444a9
	FFy1s7JzFdJnE7p4r7FxFKK71pt8Txw3MzgrP0f+OUhG2Q4g/WN7PzQ9ieChUbpLEzfkjy+Vax7
	DvzagEJR+U5wNfG0Sc2fBwEVzDadHykhrh++BgMew/bJ6jCa8I+QEYewxAafsVL+Bs6qnlsG1J6
	FSZgwsZ5rkpzfq/OO0MOEt9CoEha+8mvseB+dEu/O3aHJFtI4r+/huoKGFHftsMU3VoYz8nvMkY
	gihjepcADxwBOn4wjpTIO2rIDLB50pvZ4J7QZozUf6LOamViq+4WJzgeSU7tUHL+oSutJWbsLMv
	XV9+e86bSb5ecZMoRwNp45Ubjc8UVoW0lbqhz86TJ7bQCT0fTcpYVfa4UNpaN6lSeW+ux5UfgEV
	M48tYQy8TXQxK4Neip/CEwSzBfI06wp1GxflVt0nfAY35soIFqMbHlCtIbq9ZEw8rdKkKq2wix6
	fUupHjP6ZLTSxB/fCBelLXQejnBV/LIRq7uRteKf+nzFdj1p2BHPuEdVKmWtLlYsLjn5/YH89pM
	jcaSqnI2vsuzy9u2nuOC3A+UvDf/qfqAaTEieKbkPRcfRkK5ar9tlgVqqgtdeU5vPJCCYzY+9pL
	HFXjAcTLzKtzkt0i8pg==
X-Received: by 2002:a17:90b:5307:b0:3ab:884b:65a8 with SMTP id 98e67ed59e1d1-3b3d0761a5cmr4646684a91.26.1795061659189;
        Wed, 18 Nov 2026 20:14:19 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9297:4989:4c44:dad6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40593719esm438795a91.13.2026.11.18.20.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 20:14:18 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] zram: use SPDX license identifier
Date: Thu, 19 Nov 2026 13:13:52 +0900
Message-ID: <80d88d3679dd0b67afe634562e1520aac6686a91.1795061575.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
References: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F5C5A0003
X-Stat-Signature: mq5r7wpcxqirwz9e4yzn3rikjthcudew
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795061660-82542
X-HE-Meta: U2FsdGVkX1+z8aBA1nlrn3y9Ef++9pSfYWfKukV5sGvwOfFc/+C+0bt6ZUm68GUhSROk26zkEFvpt0Mm1ThTps/7Yd4iFf4Uzo1a4xfsBA8JSUzWwf0Fl0jswXsyUu0zxV7LTSO83/59pUdjFY7mzX2+WQxa2Tu4578YhE5bf5MSSCEh+h4HdtRVhwve+CIiuZl/yim0Ygz501rO+TZeyEnGD75/GmMBjoXKHprIowST+lT6+PpLBZK7wpZvvV1BBNcmbfk5lRK0+duBTjCEjEQpTKrURKE0Li2ozbqlzFBfCrXVmSDrVfuxmeo4EiWHhc+Kj2cZ5LD6r15bjHn/FCwZs4hyXWxHa8/+oEY/OSgDcnHrHlwYapQYbV7aJ6MwBU78YwIOWLJI0AU+rVqQmrkgd1Zz5iIWOTram4VBR3mDnw+dUkDkGI5VsdIQwVWWlURJfjBJ7duUdOS2yRa1RYVFvfrc4yMiPMW0stBzuvxjvBSAIt32pfz0I36Rn+C5Qo4jtfRk4DA/mNfkvV2w1P9qxXGkv89cULB8U0zLfTvaKZ8K/6MXgs6VRMEup9beaHIrBJ5qN1xelgIcdEw13luF8h4Ke/oi0z5AvMQ0n9+QzmyLHF8jBgY1xjs/AFJfyUDyICX0ey8jL0DDPzvpW95a7UxCDhe9itu7NDhYhri3rMiimY3z9rvR6IOrOgW1QH7a/yWcHTo/E6hnEaeVM8O0N6bLmScS/MvnCIcnDFW7fp3VIkZm66o+tSCYUXnQKLXHoLNaLpe+CTjgD59zeqicWLIjMHCUPm9aXq1esygBP4LZtv4cQxFhcoTVhnHAg4Rt3PuvoTl63HsERQa+dDYKwW3foU5Sp9vPGKAvD9h/nlOOKIxzHk5e8XtQQcebnKJGMBE8i/xoYdHynh5cjW3qNXC3hOvKKfeEU0s8+JHWzfeEbFJY+uU+7undITCmmxus6jEhY6EOPQihyzT
 Tei4XIPu
 v5i5Jbd+3WaqjRGpsPzi5RCvCv1XsQXQkSPbufUA9pxsuhdEedBiytu+seLfDpjJpRfXvU6sbUbQZwinWms6MIqz4xFlnEDaomcSbSHaI++o4qZ4zhUo1/MHTsWd+Sycy5miwXnJ4iueEndhhgTrxCoWHkUs8FzwvkdCezZr7ScO6HTuwLGlwsgYTSYN4agAYgHxwZrOoG/96y9ybgVXm5V/gxL3zxx/3ABcdOpF42Z+CnBnRTRq9u1gT8dyt3WYuKDP7ZNivn+bp/U8G6a6giuSkwIGo3wUQy0or4+ohT2RRa0mTBD7ZnrYpwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace the license text with the matching SPDX identifier,
(GPL-2.0-only OR BSD-3-Clause).  The copyright notices stay
as they are.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 8 +-------
 drivers/block/zram/zram_drv.h | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 946b625761f8..90f06523bb8b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1,15 +1,9 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 /*
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *               2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the licence that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- *
  */
 
 #define pr_fmt(fmt) "zram: " fmt
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index d64c99b74214..724f8ce6709b 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -1,15 +1,9 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /*
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *               2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the licence that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
- *
  */
 
 #ifndef _ZRAM_DRV_H_
-- 
2.56.1.708.g77570a6a1d-goog


