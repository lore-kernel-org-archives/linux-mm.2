Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD3ACA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C816B00A0; Fri,  9 Oct 2026 03:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5026B00A1; Fri,  9 Oct 2026 03:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B52E6B00A2; Fri,  9 Oct 2026 03:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7DAA6B00A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54819120253
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:38 +0000 (UTC)
X-FDA: 85302219996.20.1738960
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F06E180004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VqH9i1qN;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529956;
	b=IR0etg/VPj1mFF6Lk9LluRv7A31Ak6hEXF+RL4CwNo9rQyScbYuzQZZWv5e9enfZafFdw0
	vsD6Jscses4LfKVWSXy04FrKvgZOtnIimmVcPogGvDPEfCzAeCCqb821FFOqZ/ApHS8KRc
	rYc/drd5MaIF6Mzc1TCg7DK3OheItbo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VqH9i1qN;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
	b=Unc/qeY9QFNoMqJShPAmRG9p55JpNNb4Dewq3gd/VVv3td7nTOEdjBrXvZucPMyu+rBaKq
	vYuEOXppvYxokRBFL7W2OB0QXNDGRZOBAAV4dPCmILwGA1jJQiASa3deBC4yllmDsY1chZ
	piyTbVCKDSAgenD3aPi70ffnEq39L0E=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd3310348d2so407510a12.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529955; x=1792134755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
        b=VqH9i1qNnqkFtY9RWBL5/KqXbLKO+1t9hFH3kIZrEoDZPMfvvvA6Ni06XVUt4zAT0B
         eMn7tf2nU0je5ehkxzwBfTqAons2OSOg/nSM+UFPr88YmWT6uD5g9Ybm5peHsAxkwmoa
         SkkRM05OGlzo4bxMuZLOktW4+Iz85t5PtjNdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529955; x=1792134755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFX4FeTrLTacTalFto0lbFyZ1pMwSeqR4eMyIxwMMBg=;
        b=Re90Cnk4C0ajh/QX0Z/PyDZOI7bJbuDFjNqxFVMAE3XXhZgMKEq+woW3dFJO6rBYqz
         BSp6AIaBXkp9LHsoC+eIqsRHAj526pUHBkhfeUFDokyZiShvwEQB7onbxlbbms2qZv5u
         mXLX4BgyHELR1aoziXZJrmVXBbx77UZ0C8LcRW5fIE6Rl0gU9vsOH7SET/GAP0d9foW/
         NhV7BqrPL6upruroQlTpRqZQ0g1eN8S1H06zIydONbc9fM5Yf6rG3Orh98knGW3ncASA
         hvZRGHiXwQwEihkusH73tpEzCdegH0o2hUZ68qKnUHGS8HUfso6PFqYM/5thZLzbJzwI
         zyOA==
X-Forwarded-Encrypted: i=1; AKwUvBwMoxnxiR8fc7UlOVuCSxHSGDoDpnUxQHRXty0P7HQtHTM4RJ3S1wOtjCk2R78WjjtF6x0Qz0GaLA==@kvack.org
X-Gm-Message-State: AFq9FYI0ssJUXlLERIseFnjfOMzyapdbuU8vd2WGICCLvgZxLCUyGoWx
	QidU0lLJZ3MWSC2BmNRnBKX9mDIjtyNjeMb9icYIW83wtiHK6hOL47h+/7xTIiz0Eg==
X-Gm-Gg: AYBFou1xmfnpu5oFd6VgrLsQG0KOaNb+c90xamooFH4cb9KNoHL9i6byMXQbJDW8wsf
	VkqS/TfPXYLnOw+gpbtNDNfT7SohtcRVyQ/+Q+0gNrgA+hX4SbrrMWXKlBuM+T97IUp0Dfa25Wn
	dj4/WQfXAmjXWYgkGhRFinl2uxdlElR0D/gYsKzbWnKR8Tz8CwTCXF0nl50a6ayeqXg0ppc+cD2
	nmHJloB4wpIeuTDxYKrs5LGNleXvGvgrk4l7BDqfNrtsdPYxXwrOucPy0iDrpvujbO0wSG28DxM
	U3W2W82QETbhQmvawQJy87V19GVHIHT4juXc3YAOul5bpLM/tqIDMAHF/PCnzS7zCg21gfj0hKN
	zWty37cyzosc3CjxXdx4Y3u/veIQ/vT8xmK2h2YO1TltC3V9ndrhx+3POO0LxjF4fRXVf3k3qAk
	qx4ZQr8tnjb0bXNd1Fw6yltao41BKLjps36N5C8UReOHJ3YiMLDkn0d+9eTNuZCLvM6xVyOgY9M
	HlcaJcjY81I2j0ob5Jj2dS9/XXJYxF6ttr9slinIkhuYBewRGq2XK24Bw3hLa8=
X-Received: by 2002:a17:90a:c106:b0:3a7:ada8:c18f with SMTP id 98e67ed59e1d1-3ab36d57457mr889295a91.24.1791529955221;
        Fri, 09 Oct 2026 00:12:35 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:33 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 07/11] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Fri,  9 Oct 2026 16:11:30 +0900
Message-ID: <20261009071157.3730698-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cpt5xkhe3tw3ie16uzb8qn4dseirkx3z
X-Rspamd-Queue-Id: 7F06E180004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791529956-337786
X-HE-Meta: U2FsdGVkX19EPGsPgFW/Ebyjxjs2pQCdN8QEj8jrUjxhZcr0AyGIfShWuwxWtpFo42QBcaQvpk5I+YS/goe82S5luxEuP6RZXivuxEmV4/Phl4laVzVMvm06HiOv5DFD2v9/IT/+cO4/H64Pmiw9WVRbYiLU0tAggEgEYVjli2YlgVyHfOBnDsjF5Wt9EZwfpy4Wpkd5dM0tPz7NDWE749YVxBYNTmqdHo7F1CGi6mRMetWrdsAWSfIvVbrxNeY1iC10rS/EovBhNMG3zrUnt1IRpQHQmhDOkJbleZojCT3od6dZBaRuM81tW0iqYdipQP7GYodkjBILYfcmsWxoQ0EZo8r0xwqCuP5Rq1ZJ6y7i3H5aqh/mm9GqfALrGGxZ8C0F7p69dm/z3CWlYR2d/Y5ugymFh/FyrEz45ZAdnUhMKyHGEUl12Jw8FUSCp9wGtPo7g4Ycx+d1OtSe2U3p5g8LJQlwaY0jOQmKA0tVaR8TIDZTaIoa3PwoLHczM+61T+XF7AqvkezExhwzWMFAVaG8xxfByoTzXGKG2urn7BNEXSa48ejNpjKsxOUFupdgBQPdtx03huWNz8oOsypdszfXCUohZSTqOk/yH6rVg97N/zXWVUN20AdyTkBbdYsoh6LDyZhVep4Pbk8T680tS199DciGKlsiVlMm+aq4iJKGIX6Y8E3YM5r/DNaf71aMX6TT5OK5Z6b//DwD2ltzTsZ1dyGyyW2zcDfNCCNJaNkHrvnKqnMHgpucgW4hsI3AfR5QiOlQA8Klz0vRbhhRwUVQsDx0NIMSsUiKsSWfS78F612NO4l+ZhEvvEK53DPq0SftFImPQvkCUrjnWttZIawO/IAi/GJ2IaQkrb7FBarIiEEjQtNe3iQEVhtuh8HyGtbIJaR6U6aZPeZSrBOuRePImST8JivoIi96clBtiDCsbtR2pkX7njeCyFXieG1r0IKvLqemebImme746Ve
 n6YYxjVR
 EqXxwsOteI8X5+IJGYIEplwD1eaYcEegDnD5FN7Vu+d90VDr7G1SxAuVhRm/8x/yfIxZbdyIBx77qa0z2rKdStKRqXbuS+zi0pUHRsoq6mwd6JiknWTBEA5CA8k9014THOoZYtnr3GeploP+j1USJQuxHQZMf+IgvBZ0wvn8u6o32o9nQiEYPy2gwA6EVZjx9xh9l5eu6cYSRoIYg4qLTK2KTvqSxO4NuF3Z9wg17I8Vo+hc6XAbe4iRPK47H/ozV4hUxAotGbVxoTBl3q8kkxoGCze2LNbk5hDDYZdI5UUVLcqDEEwY720T308Z9y0hssIVe/8wdJ05CqhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index b367049f131d..7a8b5ff186f2 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
-- 
2.56.0.385.gd3acb90ef8-goog


