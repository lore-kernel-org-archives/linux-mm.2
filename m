Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB331C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DAA6B0093; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDF66B0096; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3B46B0098; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 536976B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C584DA0291
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
X-FDA: 85037054676.15.700D474
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B9041A0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drfJ2nh6;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	b=TeF1l6Xj0t2yboBgPS+r6kIeQ6kphATJU8ojtwhKP4nQXUvj1zAzy5zTE5BeW6KJ+8vpE9
	rfx9s+RWvJbEo+iEtmdNFcUgJaH83yTJiV+CPo5b+Dv2FKk72F19XIJA9nz7C1vmGRPpzQ
	rJOfVWbaPWIh3wlTR/A8Ucjyc/Gq/ws=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drfJ2nh6;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216497;
	b=5/xWZjsk4KLAiIAxqJAbaPxCriTGRAQS4xrPGqgeonBBxKEkhqhPm88sD7ah/roOrBCRPK
	/LOK/YHtW7nDodO7nnVP4YZt7qUYirpfB3ZI8rLRwSjMrm6pD/FxHgApKwIVQlM3zP69L6
	Xs7eXsig81fQYuZPZ49BLqNY8hpH3is=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D75ED60A64;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E6F1F00A3F;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216496;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drfJ2nh6PTAFZ7CdJ/do6A7rzEFEqyv4+aSYwk29P7sOohY0EPTokRJE9PJDWyDcU
	 sUcLYIXcfPvc2rq8BIHlg47myx4J+Bsll/NFBMvhKRmdp18Dd+P73pkIi2DIKJfSbd
	 g5sSfJ1rkyHFW+AJEnDgUaT348onUpaDl5eknL50ZJS/gslBjt78RlKufUIqY8Imcd
	 V28czKZGCG7780LCT8B9GQK1qJcROVX9SKfRzBOMfL5lrx1onkiNYq4lrcI+FZfFD9
	 c+ygtxJqvQXU3L+N85zbqjrYS9g61J+XawaM+Owf+muCGVlUjGscq8WubEJyyBfH8c
	 c407avxFTWyMw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/10] mm/damon/core: remove debug messages
Date: Mon, 27 Jul 2026 22:28:01 -0700
Message-ID: <20260728052811.192712-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B9041A0002
X-Rspam-User: 
X-Stat-Signature: 5xs4ypz6ag1w4fp4kzdth9s87fpim4xu
X-Rspamd-Server: rspam04
X-HE-Tag: 1785216497-476627
X-HE-Meta: U2FsdGVkX1/WTeu44OEaUfZsGFtt1Czk3h+4CAyacJVv0Z5lQgav5eoLjVhwc0rYOQmisQ5TJZZYu1ryKDaRyMx60u9lHKrvG/xt+SJ2zoAZzQw0CoJ0sz7xg6nbI9ponCiPJxEBbsNwtxZM6nGp3BXWdD6X+U27NdfdvUjByu9yZ+E8Q/i5+Orh19NXa9ug4pmOpc5+ODS679epaTSU2mRH/i5YZvWLFGed26K4FGxP+7nYT+gkdCwsgFGQNSLKWo/+2clmXXkkJ0UUbj2j9jzQwKE0JIkOshOaYI/fTndlfCBjnFF/Dz70NKj85Oih0be5RE1kEUARYtj5IjYqB5wnIZX6NIOdN8Icsz5XeKp7xvlvMFXs/PVlNaWb43ejyzrjA0nDgSHZUxHBP2QhQrUa8qQXi88nfZBP/aFtecJyNk9fSGtf6W413b2jkjs5A0IBn7LWIl8uPxPxDBUCW7hVLknNkLamZrWNtyilmufbYTsXDapjP/f6x3z3Cd3sZywzf1z8xBQbAWUnt3IY2vQ6oIt6zsRUegs6i9zEEkyxVrxoP+LQ2J2TEj85o4LfkIX/fQnwxIRsQb2p3qAgVEf/D36vY8Xm5qa6OLL71dbMAJOireT+pUQLXyQuUtUiSx8bIBQL3+yuA9xWP4oSxgn+meTEquoE+oXvg03zLk4vXufRmALestAlTuQOCK4t2C22PlUGQNh2DDp9FqpLXcjD/CaNSPrn8l9xFgAjb02Ao1xl7wzygOut5+nP4EpCobB5rpEtMCvrHPuUkJDGPEUOz6a4xIbInkH3LoUFR5vshijkqWIe9CWiCNnQTGVi7uwavZUbgx+IlPC5ImHvEPmMyuj/4Vs1sUnVjAgZnkzTVcLvUMxH35/mIY0WQ7xeW769aVN1qypn1uaNRxVPahASFfMKHwt6QIbftFkoP/9PWa2bIKL+Djs6tG19gNJJBlgPBbR2wBw8+SooFF6
 vSUMEPTt
 Kcc9EwEAqEp9FIhkOKGUrgokqRX067pQl6mayxVYZ2lxZgiLt4RI/UqkcDrBhg9nC+hOJgndwiAnStuUr7JzYagVQ/jMGX2yCNRajiPy6BMJVchhWXEm7VEhukhG6MSSdO/f9+2u/tsmB3JF9mSCVFQyMQKbkIUuRC9TqnDZ++Pw/MdgrAi2Pfzn4/XuqYs61GgYsdjZW981zd7Y/u1KZZi1dpQhYD73yX06gkZaZm9D3tC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a few debug messages in DAMON core.  Those have not really
been used in a meaningful way for the last few years, though.  Remove
those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4169268d94416..1b0f12d17de3a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3693,10 +3693,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
-		if (scheme->wmarks.activated)
-			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-				 scheme->action,
-				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
@@ -3706,8 +3702,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 			!scheme->wmarks.activated)
 		return scheme->wmarks.interval;
 
-	if (!scheme->wmarks.activated)
-		pr_debug("activate a scheme (%d)\n", scheme->action);
 	scheme->wmarks.activated = true;
 	return 0;
 }
@@ -3850,8 +3844,6 @@ static int kdamond_fn(void *data)
 	struct damon_ctx *ctx = data;
 	unsigned long sz_limit = 0;
 
-	pr_debug("kdamond (%d) starts\n", current->pid);
-
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
@@ -4005,7 +3997,6 @@ static int kdamond_fn(void *data)
 	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
-- 
2.47.3

