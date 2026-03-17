Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA582FB5EA1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 01:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1486B0089; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EF86B008C; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E3C6B0089; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA4E6B0089
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A1751403F4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:23 +0000 (UTC)
X-FDA: 84553870086.09.A7C3C2C
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E94C120010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhSd2oEY;
	spf=pass (imf29.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773712101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woq8g++l5pYTnrwN/CGFOIvueDbJv5G2Fq6vUnhRrQA=;
	b=PW/JdTUig2lLcFCNMAtekR0UQHzAbSrtmRZi7QRDFkXQq4Q5zLwy2LAoLu1ReBtrSlDjnR
	QZv08iLHGrgpkcvQtT6vOt0R8VBts4OvmWZ5NA+WfJ3NQZ3Zaol2PEq3m8ywQLmQIJn9a+
	Wfc575VN7RiHVpeSSkppn+uN4ra8x50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773712101; a=rsa-sha256;
	cv=none;
	b=h59NCZIt+KuD+FuS/XCDZkAHGZlqZ66mduop8RiI0cBSUmI0qvnfxHQH89F5mAV7mZud5D
	Y/yEDepX/cPg5KEQ93+p4qOoB6umkgeK1GFtD3tV4gsBF5HNkD2m6ADurJf+oFjfxz472L
	9+8GqiEnfLoSSoLb7gEscvXpprpNH2E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhSd2oEY;
	spf=pass (imf29.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c0c955a481so2412227eec.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773712100; x=1774316900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woq8g++l5pYTnrwN/CGFOIvueDbJv5G2Fq6vUnhRrQA=;
        b=PhSd2oEYdCoLzXaZkp9IGGuqCTpSgS1FxkqvW701rWd+Ne580086hf2jYobIue1bgn
         YsdXlBuzkQ+9lZNzmnx0j0+ZlmGP5IXCQexUtGgWuqBm+70q0/pnUliTh07SrpgBGoBv
         cN7wi0SCoYCt61KTK1LNVlOtLOaN/8wYiMG2xWPePz9ADzQWdyazTCFmFVHW8GpC5QeA
         +JGyjyURI5SwHUufXFwudIpvK4Hu4Wm7nFFqDSRZZNyJoL5McEBzd/pQabwN5vx7huo3
         VKmKlI85m7PjCQ/PSa/TE1KcON6S6bSe3tRdE2tek+yTNXFTCKC4075AwNbsF0+9Kwvp
         zmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773712100; x=1774316900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=woq8g++l5pYTnrwN/CGFOIvueDbJv5G2Fq6vUnhRrQA=;
        b=iDKVi8Qt6Lr5uefuTp7Dk5tlb+wVqzzBnKw4s7B5Ib8YlocwiQNseKEczf5/fQZ9aF
         goHibdRUenTGWdGb0IOpubykklxzRbOKhIv+7JyC9JW116QXpw0XwPH9UJPf9C3F+rgP
         I0jJOI++kE+maiil9xnnWiwUBgTHZNrgLadGE2kVKHNyM8snL4Bu0s05zuP3y/m2hf3C
         R5nklhjGo2cDVRux299m+jdkhSQ//LQxS46PfSGHMucOZcFVfoRgnCy5w0ILRCfAdxXD
         Ob5zZZNQYI/O2rW+eXbmLfUxyW48d8FZj0AZxYxUVi5FbxrzIpEa1y4n0Ef1ilGp5Uhn
         dAkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyw1mDXbqrsLF9/So91nQq4jYSjwooU2bzLZ+17rk/L5SIi8XqcZVMT3fIh3EPxRSvc6AugXAU2g==@kvack.org
X-Gm-Message-State: AOJu0YyxH6Uv+syCtwbg1gcAVeSB/YHSUJNxd/kisOAtCIAbEeh/beMk
	IMz3edixqn06GEJ1rOCU0E6WHULi52+uoIPIe1ifVNxFhLVpXp/OYkBA
X-Gm-Gg: ATEYQzxtE+7GG5qccaQ1e5tnTt0nOX5O6bIjQ1yz0B8/8n7syHHYb/Fn3DDcY9+HYbt
	JIDSX8usyVSXht+25mq5PcEte+7r/MgVu1aB9u8vbECef5VZEsRr17080n+SaeIO2yZ370BjpHA
	VlsZrri9dRHEdAHSYgYL9qTvVbO/4VWif7NdyhzJbAKU5rHdV92x1Lylb4VVkLn/rT/pdNS+GYJ
	Iwl2pzwl6Dr9bx+T0QR19xgx7BD/557z3BIxqx3aKVkR4nPpKpQQx5KnhjF6ogL6gk4GW9xAXgJ
	LdQvhDy8g5EFF/Q1uAcBjdhZbsUssLbtlJHiEWTWTN30n6KStq9FEmjNhoQI0z3EQpL4DqEzfkv
	giB1QmiRQA9C74zkOkZevtd3NSdiCHPDZGFHZfhUzRvnzyAncY3Ih2C+zo9SvQ09Rg0BXYOG4e+
	IvHRCt05z1TNiOMKTuxAzgNM4JgqIE1NYmfnolMQ==
X-Received: by 2002:a05:7300:fd02:b0:2be:8216:57db with SMTP id 5a478bee46e88-2bea5418f42mr7112556eec.3.1773712099946;
        Mon, 16 Mar 2026 18:48:19 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a12e2sm17931130eec.2.2026.03.16.18.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 18:48:19 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH v2 1/2] mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
Date: Mon, 16 Mar 2026 18:48:01 -0700
Message-Id: <20260317014802.27591-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E94C120010
X-Stat-Signature: scjzeiu5ywy4kr5bj68y6i6npgwucwps
X-HE-Tag: 1773712100-541648
X-HE-Meta: U2FsdGVkX19twxPZ7Wo+eaGicbyTYtYphvj0Mt5g4D8z0203/RIbV0rzXTq8JZCcq/aTm+L6UKD2gMneD7Mw2whgw1hh1TuYf1Ag1edIQqMpgrHjlhOnvLFJbnV/vfGKp3PwSpbHmap1cu6+jL7N+Px8Vq/tLS0rKU869Chj0v3i7zs3xDtFFy0PiFmFzsG0tSN6CxPwALyg0i69yCdE4PuXG1z2FmnL4ZgX1QJvMl7e7DPkyn4eoa8nKnAqtWcNyqxpGF7ltGNT7VR+aeQz//Rkh3TqMNAAcQW8TMYQtq9KA5AGz//lpyTeAcVBZHXIWQxD8/NoCg1N0FteCDBn6UHcgKkFvmIzRBHCtJLchtjVc5QRV+K/ee/flRNIX9ffh5769P+phna+1iwr1XTaYnmjiiNKpPdGCKRkaY/VjkuW/NZ+OBuNxKdEJu83ifSiyd5TYEc3N+wyh9CteZDQm2YNfby0G+eXGCGhoOUxsrY9wy8+VUfKfpw6CJUmCCJe/ipoL4t4YoRxBtl6fSsImGE0BTey0BhO2S4VpaF45l8iDML6DLWK/mPhL7vY+VGMZ75DJw5buHw1RcMVDnhIHns0VsKTbuhcDvUnVZ7TmzZF+zIhF77rW0MBa9pQkRfvAL6jI7ySVanzzQ2tcTfLYItWHPh29ejGro1WgG+3lwPlDdk6gs6s5r5ZGzzjERCGERBMJynebHWBZuylTkC2M5269fZfTBE4zqpgipMKtCbRWJh6epyxbkeYcIXaJkmZb6vQr8ppA/aEjKToWTO+JlPVIEGO18zG2s+NPtgkSxqPPyweKL8hdQgnPnhMDFcR+HdSzNwmAKIcx+FKQgv0EFA/Dq5Md3gouAs3qpIXPYUoxx70i7QpHEVzitKR+UsO1W5zmeGARctPaKazsp8WNQGz7TEqXMxCGkcn2OPql6mRpx4TpMcNkpo5HboUbI53+BeUs8j8QYTkk+4ab4O
 rU9M1sPL
 qacS4SeSrGjXHjaUoIhl162tGdvkdPzGw0LaN6UvRnjEYgBxVuPVlyt3abp4RwuFABkLZEbAB7xnx7aJQNYD7n5lvLjii+WRwTeVa+Ft40gWyDs0Z08TtLcVo4b6a8PkyDPgckBhmgEqEDzE3bGPYqXjgw4xXmFnnE5wIiK8R3l7FBiYKsxK+a5i4DpkecQZkRlKt7psqXyeJi3v4Z3wKnW/CBNxu8qXNW6jk0dDbsFoOKMYeAaUEnKHNeyIp1alwNXsWbJ2LVYR3c3m3MbjoMv9OA6rNNo3NzA33b3q3kRWGF+uaXcerA7zBoOIgQbGcO4uJ/pU3DPATC3mFOwuGNvV8zZgjmeOyDEvHiWyBukgeWDnc2qrWJEpewBbcEYOo7IrPbbtwm46R6HCMj1cANmOYC9oz8pmCbRdGFukdOGrVkD8nefuHiMDPnqYp+uauxByDpA7q5SUruWMEQT5C8J8rmb9OO9mGQcOfM+TVhmz2RI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are presently redundant checks on the per-CPU acomp_ctx and it's
"req" member in zswap_cpu_comp_dead(): redundant because they are
inconsistent with zswap_pool_create() handling of failure in allocating
the acomp_ctx, and with the expected NULL return value from the
acomp_request_alloc() API when it fails to allocate an acomp_req.

Fix these by converting to them to be NULL checks.

Add comments in zswap_cpu_comp_prepare() clarifying the expected return
values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index bdd24430f6ff..8ac38f1d0469 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,6 +749,10 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * In case of an error, crypto_alloc_acomp_node() returns an
+	 * error pointer, never NULL.
+	 */
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
@@ -757,6 +761,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/* acomp_request_alloc() returns NULL in case of an error. */
 	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -802,7 +807,7 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	struct crypto_acomp *acomp;
 	u8 *buffer;
 
-	if (IS_ERR_OR_NULL(acomp_ctx))
+	if (!acomp_ctx)
 		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
@@ -817,8 +822,11 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	/*
 	 * Do the actual freeing after releasing the mutex to avoid subtle
 	 * locking dependencies causing deadlocks.
+	 *
+	 * If there was an error in allocating @acomp_ctx->req, it
+	 * would be set to NULL.
 	 */
-	if (!IS_ERR_OR_NULL(req))
+	if (req)
 		acomp_request_free(req);
 	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
-- 
2.39.5


