Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 491C51049518
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DDB6B0005; Wed, 11 Mar 2026 05:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E49F6B0089; Wed, 11 Mar 2026 05:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0446B008A; Wed, 11 Mar 2026 05:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14FBA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:36:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87EAB8C2FF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:36:31 +0000 (UTC)
X-FDA: 84533276982.24.0150EE0
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB9C318000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:36:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EjjkLkA6;
	spf=pass (imf16.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yyDGZmMomOHesfPo9XrMzUnXt0EI+izxgF0flTBDkq0=;
	b=3ELVMgSrW7cp5Ieg5OFQHC/5rqTzFfxjL+AD3bf66PPQ3Q0ntgsDrkZhWyV0ieRWB1cjds
	nltrZLCtt2kG6/twtuk5lbhk5EcOZ5I3itK3WwC37UxMlzB+jWZc/KxuobjVb//3eW2+u8
	RRe78KAwUsGHVepfbQ92BrmZODDGeaA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EjjkLkA6;
	spf=pass (imf16.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773221789; a=rsa-sha256;
	cv=none;
	b=nX8gpwjUfQ399fTywCIIaD1aGwQ4Bc0PJVCCSUlAFDBE/7tZTPmcUOrODKUppmJjhyQqu0
	TUQtI70weExJOhcROzYEmbxIErr2Jlp0Jhp6Cju5q+tXTmPJPNihuYawR/IyL7T2LfUzNu
	ZZ7sfWkskwpX3CQzcqTxIoQTw3VtqaI=
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-35983877dc5so4706746a91.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773221789; x=1773826589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yyDGZmMomOHesfPo9XrMzUnXt0EI+izxgF0flTBDkq0=;
        b=EjjkLkA6V7kjfZrhCxDmtyzHPS0bsT1ByPwnEntbk0dN+8ZtSoLjHgC9B7zqFg0rtI
         D1or5IFSD5o0xpotvBeBu+AccaUa/WMGrneTBpkW0mSi/wiLXsST4mke53gvo+JwPbAI
         8lye58bR1hnqyZ1xVde5d91WhGS+xvxwOPFTKaQi+5fveq+WFhjtNhwj7vyQ3nmgPm6y
         pqQGvaOJJnWNrFj5VeUbcbRnCQ9RxkQzi4/iEnIf51qyrmZUBZClnyI0TE9GbDMVS8R0
         zQSe3Q95ayB0altmQbb0EInTeIOJn+76Ee4P7OpZVQW4Jxc3kvGbA/nEngQ2K6jEvwVh
         OAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221789; x=1773826589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyDGZmMomOHesfPo9XrMzUnXt0EI+izxgF0flTBDkq0=;
        b=oFbHWEPznbMWkBUUtBrGz227Jzn2flunIMgKHfc+bVfxiQzjiFJQGvcC1/lnSZbxih
         sDFo8mREFrgO7+Xw1h07KNwrl0MN3Yf4e+eM9s9H99/xy+C9plHsBaQHngln0swSmCiu
         5gW3Nbg/l1mJ00aLyCKmf4zHW1feano+BmQ1VFlTWNvCCUQdnwZT7OVZVubRyWhYXGSy
         +C2wLpYvrQJHjb9O7PKor1cOQqS7D+fh4QZo5sZC6dfl/8+19bQK9fIkbSMEK1QUvITL
         1xABidmZp7DGJFlgzSH+NDUba7c4LZFedK4s49naICLRotGqPP/ucFJUvG4+NP934C/w
         LPoA==
X-Gm-Message-State: AOJu0Yz9jrb4OZKP3/DRqhhu80FSMgIFWFfonCXQ89JHCifOip5HxF7g
	iaYb5UMw6SVjmwra/YlfY8N+Ak+DdPCkjiqwUdiTgMCO2/K21OHJByJU
X-Gm-Gg: ATEYQzxHoU7my2zHPN0zcDd2PxBZ+iWe4Pi+vmnHgb0T5zaAT03E8YVtEmq+Vix1RQJ
	J1HTdQGPHdOH9hYchsBZ5JQBLqLBj2umPUT636ayz4sDmHklF49Kev/P4ugAaxgBCbPCQo/bAPi
	VCscWrICOJmqbZnw53Uq/TiPxk0U0G1Fc0GR5zKOyRwRubESqNkCDdYmRIPjeeyrSznvVSs9qYX
	ydfVjppuk7XdxiRiWzvpLMuxcVCncbVmh//PluQAmC8EGiCk1j/w8WtL0KgeRSdwKLw+k3tbvMP
	HvXHmX/iGbz7MOtBK1kpum9Ylo7s6YOISuzOoFN41g1s8Xs/9QP6Sk/WLcezN0xTbXEKxts1FVj
	o+aeU3EccYQbvYbn2cMb6kplVNS0txFgZoySVGaSbO1JP0gFVaC/MiRUtOe9siHb/YGgJx1Tf3a
	WqY3SoyqpYtckWh27SDPcc3hge47Y1M5aUn8QjVYwE/iHtvrVPZQ==
X-Received: by 2002:a17:90b:1b4a:b0:359:1063:6aed with SMTP id 98e67ed59e1d1-35a0138144bmr1861802a91.22.1773221788643;
        Wed, 11 Mar 2026 02:36:28 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02191f97sm915489a91.3.2026.03.11.02.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 02:36:27 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qing Wang <wangqing7171@gmail.com>
Subject: [PATCH] slab: fix memory leak when refill_sheaf() fails
Date: Wed, 11 Mar 2026 17:36:17 +0800
Message-Id: <20260311093617.4155965-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB9C318000B
X-Stat-Signature: 8z1c51nqy79u17qwb4bk19nua4epyp3h
X-Rspam-User: 
X-HE-Tag: 1773221789-884944
X-HE-Meta: U2FsdGVkX1+vlyXgwGgoTMKWTj2FUl9zac9CLl2gOWVxEyjf5wMD6QS89ClArp6TC3lesioyl9nS6ZsDXfsG/qHfq8ZsN9i/k+MQvVgIKwr34m73/irrYw2mI6coF5yZQ2cgeYPxJdTKaRHdgEVXcytjmX2pC1gsNJBme6Fxfslb71PWV/9R2Fo9O4Fxs4JloA3oZYMFs7p5ddygP/l6jrG5RO0WmuIvIzrpO8xvUP4CwxNFbc7NSD9RpU4fUeCRc5NwCX51J3VNWWwd8pC4DVBT6nqQIoVlPPnEDlvOTsUSGL5VYuoHXtLrP9OywygjVMtUCEkaiCKMp5Ofc99YdZsOBG+7iQTnYvfyjWBRQloT/Ll7Tw8aEnKInIVoqbM4ONZ5EkIs+T6q4HA4lPnuiBC3CYvEs5kkanGXlT76NfsqoP8IanBCJG5DJYJ1oaU3QDSq9wmUxAmNpQjDm+6ErzPWi1WFq1wG5gUldwTVpLNlF+oNAcVcAqfsa/X2xlKUFqDKXZ3zRr2X6aN/BSQwwnZECBRxpDGm5Gcve898Y9kfZ5oa8SqvLelwwc993RtabXpDLw1V1qGTNGwr8rdwoPNNZ9Db5jA5znoozefq07qsdpTZmB9KZV7E2/nHLY+oDOMEqrwbfLPj09WHZBDBi/oO4qGyCbR7Ff6sN2yaUv+e3uMS/QRB7sz5EO+2Ejykw9hN90tBYMWkYnbaAGJ2JZtN0towu5Zm438KOk5xG/LY4cfNiPEOFZPGzqP8XyOjAVUhB6tDMTWFfCu6cqNmw0m0i2hl/peHSL/sPreC7L/brHN2Y/K3yf6LiBXZy+6WhZ2B/yoZrF2iRbK8O7e66zn/INgCJHTyeFoV8iSpOVRS4cMaiIfwcI8xV1JogRpH8f7lBWatcs8VGG9EtvNgtVwVAHereb/mFMRFqJr5um+Hi3YaDekN5vAUlniUUhzk4yMrUJCpDoipWvtmQpJ
 ISK5GpdE
 4+x4UOySIBVn8ShEr0FCF5ZD36w6BDV2elutC1bpdIKs9itiNhq7Cb9je38nJOrBIvcCERG2nseKICMmOUXb+byzN09xPOxeOsxhjpJH0hBouOBEFOwhumVNoeC+E3F+e4NAWIljBXB7id91q6aZ5EPT7EvdgELIgrqYSqJJKt9SZYxwZbsExZBQ47yNjr/g/mPLUx7C3hQdkvBhEmiAlo1OI8tAPa1sTi6P5x15w0P2iElPTUm4X+V7fu1e4TGpdBdAnD8ob8yn0SlH4Nl5C1ia/y65lhAQTxc7dYWinJmtX8T9So7wR9UhUZkHm5AcTTi1MlHJMxMJXnX6uZ8oLmxrqFXhM5ipA80hb8V26w9QJhANmCj17SIeLHfaHeAQ6BZX204YQC651TzcQD3DqjT0ARte2S3cKOseRim21tR0GKd0xcPL4h/r7RlJZfCKE2+NphAsghEZoqzlylxH/s1K4qTfgD2xeAMmR+Uo0GMbPZJed9Nqs2wmAlfzCVmWTXGTAGdAWKvRl4kz8Kqf5ApVtEV5R/IRmFIf6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
but need to fill 10), it will update sheaf->size and return -ENOMEM.
However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
causing the partially allocated objects memory in sheaf->objects[] leaked.

Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
free objects of sheaf->objects[]. And also add a WARN_ON() in
free_empty_sheaf() to catch any future cases where a non-empty sheaf is
being freed.

Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..73b2cfd0e123 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	if (s->flags & SLAB_KMALLOC)
 		mark_obj_codetag_empty(sheaf);
 
+	WARN_ON(sheaf->size > 0);
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);
@@ -2828,6 +2829,7 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	return 0;
 }
 
+static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf);
 
 static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 {
@@ -2837,6 +2839,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 		return NULL;
 
 	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -4623,6 +4626,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			 * we must be very low on memory so don't bother
 			 * with the barn
 			 */
+			sheaf_flush_unused(s, empty);
 			free_empty_sheaf(s, empty);
 		}
 	} else {
-- 
2.34.1


