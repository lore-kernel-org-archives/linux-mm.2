Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570CBEEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1976B0089; Wed, 31 Dec 2025 20:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87A46B008A; Wed, 31 Dec 2025 20:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4E16B008C; Wed, 31 Dec 2025 20:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8366B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:39:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 440F4CDAB5
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:10 +0000 (UTC)
X-FDA: 84281686860.12.48574BB
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66FE740003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T7EkqIhk;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.194 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767231548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQVtUjq7yi/csf5YGOCbwCTLu50+fSiJzUhtLd7d3nM=;
	b=7CSVi2Y4I7eurVUjljjClLuXiDl6BKF0GHgWIFAz3h4cGn4e7JXOgsCMNiL7Xcbi6sxFx2
	fkqXpk5NSHbK3CaDcfVQG6BJVKO2I1KWcIzd847bUKLeWO3i68IXqgaJE6LknDDeDlXaJz
	rregB4FXm/281JBIEos18Bb8+i3iGT0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T7EkqIhk;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.194 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767231548; a=rsa-sha256;
	cv=none;
	b=u9gXaYwXzkFJgIcSP7eB4XogxM1fRHCIT3TMB5FbDfguPH6rlOD1IuDxBnRT9zRvHM964B
	QCbgSKGOeWKe7vOURASD+xyYrVQ6vzBfH+/WvH5U2+KvXzAEsp9p04VYAeKoZL/If7r1JQ
	FBP9L+Jh7qoSOFM1N8EMRy7HAOkdIdw=
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so11230195b3a.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767231547; x=1767836347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQVtUjq7yi/csf5YGOCbwCTLu50+fSiJzUhtLd7d3nM=;
        b=T7EkqIhkI4Fb54DZbKgon9UUSirmYUgyfwtpC8wm0YcxOiUeS3wqD8m2T7O7eVZE5P
         O5f6HovSyIx0/4Kzqvd2tuwbRE+KTVCVPbvHDV2L8xclzUthsEyoQEG1NvwapPwTtHEI
         qExZ4oXihQ+m8I5Gsi+Tgw/DYNDk3g2CsRt2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767231547; x=1767836347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQVtUjq7yi/csf5YGOCbwCTLu50+fSiJzUhtLd7d3nM=;
        b=nlzRd3gXBpQIw5MzzxrDXdg4QnUuVayrOLFhMavkFt7ePFtMh1DsyjGNflWSCAxb6Y
         EuzZhAKHtXfF9Yk5N6NXWNClFy8ZR+YDMjYDyH0Sx/T066Gt/ZjuD/PMafvmrsEi4iq+
         DqlxoXmKGVcV9j+1PULmlNEBFPEzxkeC1tYZP/NowZlIz2EdE6vKY6RA/C4+RlFNUKZx
         AOQ8x7uKuvfmjeCgHQWc8WHlFFKaoAolihMDXBllhFPYU6N3jzJnk8gY+2K5cvYyTo3p
         1mCVhJoUsY2TOGgeWPFB9AdLMXJdBkbIhITNPrA+BNkh6irR+W8MFcBVZrAOh63KrHdl
         TQiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVarS4Syb9IyV6h3ZzLCZzuBFAdAETFhXFkjKPtzJLpevJgzhSZCtPV+VN1105KlU0oulkubwf7tw==@kvack.org
X-Gm-Message-State: AOJu0YzfiVbav3prDexuxlPhek/5ktcHSjyGv7Yfthmk/h9mwL44JUcw
	p9PCMsOJztd/2IcEeQpwlKoAVwRoVvBVkO+bFSolFtPDFkMJCKm2xi7HVmMfdTQ2GNGfYyq1h2w
	5eYPz6YNqTfx0Ag==
X-Gm-Gg: AY/fxX4llN1fdshsTLQwvA9fFmA5sA/VP5QBkV2I7W1OmBePGAxvfJJ+OPBexrMMX85
	Q7pDcYi0tfWuc3dw6va1zg8+ts7E3ToCYBrKRvUMIj59mGy6tf9IoyCI1HV7maggM0NFpiq2xRH
	QfvFM2Y2EffX2bVyCUdUzUY35cX9oipcVzbrUDIry7b16qPJVY25NVZUSUU0RIjmdoTf7HQDmud
	50JIMB9XAvONaVVWiDShFPYJj+Y3C6cGR5pwC89jeaRJQDNDJ1ZmtUNwjPXqVKAyD+BjzCTWmvQ
	PAREZncRU3Wdk1X2KGNPbiagqm6gmONNnKeY+os4QzbK+7d+fxj+01FZc9ytnKIPuSiKAUlUmH8
	zASfJCPm435lUPHKK5Ev/iy7sTg8+kDCwIqoLMJJ7NioTPzKSbV+Yseu6CLSu+pQeW8Zb8gVJBf
	ohlrMjkBB/UOPtxELgJQxGMGq8imPBlzgD/3q0brw04wFPD3Ym41cUOeSHOOkF7KNCvA7+JIqu5
	kzbZF8TvB2+
X-Google-Smtp-Source: AGHT+IEGw6exOTPDLT3/rzrL0WFsQ6OADGkHMZoSF0WHFVEv8HPtnm5uwhWLJ/CletratlvXAHw6tA==
X-Received: by 2002:a05:6a21:339a:b0:366:14ac:e1ff with SMTP id adf61e73a8af0-376aa4fbef7mr34486816637.61.1767231547301;
        Wed, 31 Dec 2025 17:39:07 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8d7c:8fc4:6773:1d38])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c14747csm30972091a12.27.2025.12.31.17.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 17:39:06 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH 1/2] zsmalloc: drop hard limit on the number of size classes
Date: Thu,  1 Jan 2026 10:38:13 +0900
Message-ID: <20260101013814.2312147-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260101013814.2312147-1-senozhatsky@chromium.org>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66FE740003
X-Stat-Signature: i5yi17nczrqy3fyqzdkzt36gohgk87js
X-HE-Tag: 1767231548-345856
X-HE-Meta: U2FsdGVkX1/u94gBLL3LioJINU/u9CpNk+g8gJZR3v9BegZgL2vTzteHAvKj6/aKUgKaiGZ8Vzq8TFWRtPjRMlGKDOIDyeMKKZqXt+OjsKFVLJCOcd4eTzRlT32C+jCQcMnX5XlMJNKqYptHfXouN10GilKeyq2DFiIBI9z7QL8JDZJ4UZZu7ay1n5sDnMhI9WZpzAmFI+v1NFhxhKdW5okMR8UDxayr4i1WagQj8A0mG7uIxLaL5ZFbl3bqX7K2NXYBXluE2aPiDQ3wpXiqAkVbr25ez8emHcc0Y0Yq299wwU9xAHIyq3uwzW7M9d9Kbm81cHCB3WnqYnoBeIe1LNtLl6y5h1TYLwfZfC+10/Gazd+XdSTD+7haWwGPeDXIAaFnmot0r7YxmGkDcsLotzHkct5xKayXO0a/f0fsTzQCRxALWzFjN055jJa2cLIIF6IRWsgO/to8GmZREDV2EK8Cqd+oHS4TZgp+0xbSVt4LXOsSryNfGksUmaP9HrE79f1+R+o9Uu1gu6DqFhe/E8QBW1AsnqrUcbf5Hr20aMbVAVTxT7wO30DgxwVneu0YZcMWXP/qG+YkSCywOe/BMYMUKUemM8rI+3XeBxLfX81MztkkHixVXxXchWS8AAa53ZsejBpKWbd2zCX50sIASQDGfSo7odCCNz9IiauIzwul7t6I64PbxQqQdBmULOfZb9aSfI/SwlOejZfNZ8vbE8XVg93+DDa/Sfy97Uw+yCzFXk2xGN7ZiFYBVKIZ+hDpZq8ksUD/hNS5YYSRancZEdgwgrEDM/HQTIJ3TdfsAWvHRR7a4Pq6DmbwFcV28aLaLIHfXSKi/hLe4zS5PpObUeQtGFQea7yL6fFcKfYB1VeA5Fn8cnTpCI6sdaMH51ZKR9lkmD2ZULUyfhPiPEe3x2zDEbLC9hbee8ARJMP2iDTEOxpXP2HsWabI/ehLLD6BGAWU/YyOQVIIJVj/eyo
 U5SI0mf2
 rM/84B4MDURLIXFg2yeMRcGT3KCjrABzNaJqAbuOe9c4HUPV5qyoX02vrGIN7XYnXLqkVuIWTT9HSg65JrT+WHi9DztvvytcnQ10lyhciiLOCN1Y0NPsPps7ty2Ba5mr1+3QOnWX3LbOPBlo03dW1QcSdfUH86VBTVNdoEgL0LGWBDN14C4yldsUe/sDFChkX+E31tH4PRi2o57RGV0ua+x+MFdWhfWGI3ODOb2CpkKbtGJ3HCKXMSSMUlh4EpecdL2zkcO2t+86eCTKBNepztq5sgMK9/Ts3oYGS+9x0fy1IznJ7DzH1Ah6VDxkc0IfeGAQs0l+KUWrsdMzWoDLc4FAQhuix4tuR0rpgRVRsAqAE9QvzsGc3ruTJone7s4NfN53suOe+JCKQrtPFy0l8cDal6MC6+dTy/6hOCTATLwEPLLbofyc2/EjqF+o8rt1xBmFY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the reasons unknown, zsmalloc limits the number of size-classes
to 256.  On PAGE_SIZE 4K systems this works pretty fine, as those
256 classes are 4096/256 = 16 (known as size class delta) bytes apart.
However, as the PAGE_SIZE grows, e.g. 16K, the hard limit pushes the
size-class delta significantly further (e.g. 16384/256 = 64) leading
to increased internal fragmentation.  For example, on a 16K page system,
an object of size 65 bytes is rounded up to the next 64-byte boundary
(128 bytes), wasting nearly 50% of the allocated space.

Instead of calculating size-class delta based on both PAGE_SIZE and
hard limit of 256 the ZS_SIZE_CLASS_DELTA is set to constant value
of 16 bytes.  This results in a much higher than 256 number of size
classes on systems with PAGE_SIZE larger than 4K.  These extra size
classes split existing cluster into smaller ones.  For example, using
tool [1] 16K PAGE_SIZE, chain size 8:

BASE (delta 64 bytes)
=====================
Log   | Phys  | Chain | Objs/Page | TailWaste  | MergeWaste
[..]
 1072 |  1120 |  8    |  117      |  32        |  5616
 1088 |  1120 |  8    |  117      |  32        |  3744
 1104 |  1120 |  8    |  117      |  32        |  1872
 1120 |  1120 |  8    |  117      |  32        |  0
[..]

PATCHED (delta 16 bytes)
========================
[..]
 1072 |  1072 |  4    |  61       |  144       |  0
 1088 |  1088 |  1    |  15       |  64        |  0
 1104 |  1104 |  6    |  89       |  48        |  0
 1120 |  1120 |  8    |  117      |  32        |  0
[..]

In default configuration (delta 64) size classes 1072 to 1104
are merged into 1120.  Size class 1120 holds 117 objects
per-zspage, so worst case every zspage can lose 5616 bytes
(1120-1072 times 117).  With delta 16 this cluster doesn't
exist, reducing memory waste.

[1] https://github.com/sergey-senozhatsky/simulate-zsmalloc/blob/main/simulate_zsmalloc.c

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5bf832f9c05c..5e7501d36161 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -92,7 +92,7 @@
 
 #define HUGE_BITS	1
 #define FULLNESS_BITS	4
-#define CLASS_BITS	8
+#define CLASS_BITS	12
 #define MAGIC_VAL_BITS	8
 
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
@@ -115,8 +115,13 @@
  *
  *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
  *  (reason above)
+ *
+ * We set ZS_SIZE_CLASS_DELTA to 16 bytes to maintain high granularity
+ * even on systems with large PAGE_SIZE (e.g. 16K, 64K). This prevents
+ * internal fragmentation. CLASS_BITS is increased to 12 to address the
+ * larger number of size classes on such systems (up to 4096 classes on 64K).
  */
-#define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
+#define ZS_SIZE_CLASS_DELTA	16
 #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
 				      ZS_SIZE_CLASS_DELTA) + 1)
 
-- 
2.52.0.351.gbe84eed79e-goog


