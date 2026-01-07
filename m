Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9D5CF6BED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573236B0092; Wed,  7 Jan 2026 00:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E876B0093; Wed,  7 Jan 2026 00:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4543B6B0095; Wed,  7 Jan 2026 00:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31A3F6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:24:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D12071A00FB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:24:13 +0000 (UTC)
X-FDA: 84304026786.27.FDB82BC
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id F22C0180003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:24:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bWc3kDOO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763452; a=rsa-sha256;
	cv=none;
	b=2MFTC3PnzF9AmCB8AaVshWMZCvuEWNbFwnhcr9XAt1aiDckFkCKfTvjIm9BvGwrNHUzLWx
	wRZsifz6zSLb9vts0ct0OhWUNmBysCN7OEnf8aZs6IhSrojYgv2X44W2MiLrATVncYG60Y
	EXngL+SUzstG388WWYd6sjIgKBo2AmA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bWc3kDOO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv3rzlPh+Sxzun7Up48as/ut3i6iXooXQR6hvJ48eOU=;
	b=Il2phezhom0JMsduOMFcj8RrzGzXNlh/Q2+PZdRSQTlP/wN3fPD021aCy7++zSAdho+vsL
	4Tyw24+pj8wvIKbdyO+SONmv2A2ggrD3EiVQgbcj62K5caxOW2RJAfAnDeFWRxtl1qMbtT
	Ufxv8K+tcnfvBIXy2SJ6a/wO0uUCh3c=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0bae9aca3so14785495ad.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 21:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767763451; x=1768368251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sv3rzlPh+Sxzun7Up48as/ut3i6iXooXQR6hvJ48eOU=;
        b=bWc3kDOOVKRO/9Wsg4XdWPt/dGKi3XknL4VOnqwNPv+UUD2cKVn5l3Oq0XmMsE5yM2
         1S3j3ADDz8kRtg7Fx4Vp3+XCAAg0dOl4l/jhpUsBXkQQ79ghpJD40WxIAPYie36ajonW
         37GBZab0DHQ0bXPZ+ZtAf0I8Xj2UiPGZfX6qo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767763451; x=1768368251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sv3rzlPh+Sxzun7Up48as/ut3i6iXooXQR6hvJ48eOU=;
        b=sDMXNWU7x4DdQTtRlDQDbcF4B6CMHEstDUdFp8ShUKKKNC7bk8kQwK4CCiLnVnmVVP
         YGoWckAAcizPHULb1NVp6PGlwZimJSwkJm13cxnz4+qgGb0XMz8nmPBMMZW9nsba9bZH
         GWMK5cY7q4kEPexkFbAxrhkNr1VlLw9nu7DVTvzvjVwqWKE4CRFrlv4MPGprAJswR1YP
         xwnHpmF+as0IGhsjKIv1abIa6sMevCrqKmGDolqtXo32zlCjvilQLOxh5wMdrSDKgShC
         0kg3fMHL/exz79sRsWN5njLWCTWayv7rz2vQrqZEkGVEaVo+x84xuPT4Jh5xc4hxRB1r
         9ing==
X-Forwarded-Encrypted: i=1; AJvYcCW76qKaaoSNiy+E7MmUipJaoFvLR9OlD8bwhL8HJ5bg6iYPtQ4K59tkUfmrDoVhjE5CaVD3QF81Iw==@kvack.org
X-Gm-Message-State: AOJu0YxUuGGfD6YiELlAB0rjVvVnS2bsWJ4Y428oVtqfo43Z56f6+vab
	kT6m8xp8PGeq9/8dLr1s9nq36x3MDh0YodpR5NyTjF/UYaldjZ6QPifrUZZiURn2jA==
X-Gm-Gg: AY/fxX709LGPZHAimmlGoKh582O3OH9M9o5ae/gcaBIR1uhuLsZYDZBO/ZC6j1d2azN
	5JGXHXh0yei9sRoBCuKMi6FiQaAHBelOdK1Jf5N9xuqgN2j9DsfkQqcGLV6ALZhGMecejU+fPnk
	WE0f14Xa96L+fNmXiDEmRFoPtTBGrXOsSZJoML59cwRXMARuWenZ5JBZZgYF6S5PmH3qQRMINfM
	VJGhiRka1taPQPFNGsJEBOgT5HftfF7CucQ+s5RT5LiFwTEQ6Je/l2+WSfRv9U0Okjg+ER9L6t9
	7lgmmakSFJJdyiLO9cy8znFraAW/yy06eBYRsc+9riS6NMOBRkAs/hzLOWayx44Xt2Bpa2XF3Lt
	Jq3+0hRvlQYerk7wrhz0fg6CI75Plv4uZN4s4TmsU0RaVS5G1FfeHrzkWFuTQWBd2CWZRnxrHbK
	+qyfzkP6uH9gfp0S6bLj7BA9P9D+aXN0QDq39djnYOLwXVuTTSp9TAxDrPEZEmeYD1r029ydPNg
	A==
X-Google-Smtp-Source: AGHT+IF5uENaBzAN2dwZYfZfxOQq2eGV5qh+qQg+WmoHQYfJuiGyFCQGA9VqkVlzEcQWJqj5TIepbQ==
X-Received: by 2002:a17:903:3204:b0:298:1422:510d with SMTP id d9443c01a7336-2a3ee4db71dmr10638565ad.48.1767763450833;
        Tue, 06 Jan 2026 21:24:10 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c47390sm37069545ad.25.2026.01.06.21.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:24:10 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCHv2 2/2] zsmalloc: simplify read begin/end logic
Date: Wed,  7 Jan 2026 14:21:45 +0900
Message-ID: <20260107052145.3586917-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260107052145.3586917-1-senozhatsky@chromium.org>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F22C0180003
X-Stat-Signature: u6pcsseuu16t8hj1me78fteos1fmci9g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767763451-718178
X-HE-Meta: U2FsdGVkX18rJ3iW9Z4eereT283SyDlGVN7Js96Q/UnAhBdB65DKwgJL+VAkFu49bv8M9ERHRgT8AKJQM2uPso0yLN6N6lXYKqsB++Z9MgGdJ3Yy9fWfNnC0vT2KD35kra4NDDWI4quytOBhTezSFYqh7q4pgCBbEjl4bWHP1V8XoNQ3VtDSJcWJGLlg2wqHGPc4P20tbWlWpT0S9nRJsIqgK29Zme8LsXtc9oXItOhohuD05tR3cad6UIQdPts54r7Dvp9YluY2WcdHdvvanMro57A/k5byC6EP5mZlrF/J6ZW1IqaavV/RTo1FhZEuNMUMU4rAzeoR73Y/OV7yhFHuANJSLu8jMwqoyEvqREtC8tMibNIJW09lhOJDabaVljYCwpMD2kNlT/nHR8oRofrcghA0Ax8iO+ue5X6X9hSQKEJdf5cRxjkhSuGf7Fpcch+mFb5MvM4zxbVlcVrEkNEmXnA7xdH2WVx6n7idEV/UmYH6I0sHpPZtGGECqaQTVnk2vvAax96c18K78EG++F6y8p3yWthfYt8NTv7dLson4zDPHLgK5r72dk5DcdAzPQ/T1lqI9uRh86bqQ+y4dHAh45Y1L5RqIFg5zETBE0O9vwCQkmrrPRygBZ48z/doSvRCRx1LsmyKwI2+hkkuwFZ8ocTHYDx3hHvH3PEYsGAh/KpfKI7CUVlPNh1SHqU9tTw7PrhDCmtp6EatmAjzmmUfv4olErgZ76MOsM5XFYcxGka5jDLVvfAghqJQQtIHS6fWTnaPunkhSoFRszijbpi2UAI2YeOiTNXmfmrey0hkuXhSGy/DpC6i4ycMTWFaUlVQAy2Oy6SsrjtwickpRq/rbhx0cZFYEErsUftizCU5us+27mvPsI5p6187XRjhsGV7w5o5Z/X9cm2e3OYkT7QDulvl/QQREW6a7NsZg/lJhcKBPjdmqkzDhbvz17sJYwzG5XbVvfBOxzEKLa8
 2nCYe78J
 OZ+lSx4TA4GK3j5oCUyg6ruXa9TYIuYNW3CVNble+UVKHkBx1f1/1xKdXY41iBc+daTSW/TRFREDGZ+1MchQWWg3nBV1xtv766/qXRXm7PdP/8vWe6cITe51/3mJZxtSa4PD4tq9PHKHY/PjBvpErL0+MjS/jiiRnK8FYjyYX5Wtil6t0uuNqi0G7xTvIunAJb03ec8EFDuCtsq1MYSXNClaHxnhEFYXJ2mo0YO6o2HG5uIZdLUPWGc25jda4oUovDUhgxcQau1MI5IXY4/lEkzAhvdJhXk4y3zBSjyVQr4MMDtPeUEiaLGgo84MPeQMS3URdt+kxTDGHrFeAsFLfdqa9D7K+T/8AV2tI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yosry Ahmed <yosry.ahmed@linux.dev>

When we switched from using class->size (for spans detection)
to actual compressed object size, we had to compensate for
the fact that class->size implicitly took inlined handle
into consideration.  In fact, instead of adjusting the size
of compressed object (adding handle offset for non-huge size
classes), we can move some lines around and simplify the
code: there are already paths in read_begin/end that compensate
for inlined object handle offset.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/zsmalloc.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 119c196a287a..cc3d9501ae21 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1088,7 +1088,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
@@ -1110,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 				 0, sizes[1]);
 	}
 
-	if (!ZsHugePage(zspage))
-		addr += ZS_HANDLE_SIZE;
-
 	return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
@@ -1133,11 +1130,9 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
 		kunmap_local(handle_mem);
 	}
-- 
2.52.0.351.gbe84eed79e-goog


