Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7DCFF60FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B779D6B0096; Tue, 31 Mar 2026 06:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EEA6B0098; Tue, 31 Mar 2026 06:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BE66B0099; Tue, 31 Mar 2026 06:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98D0B6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:52:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 338C15CC60
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:52:22 +0000 (UTC)
X-FDA: 84606044124.05.89CB277
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66AA1C0011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:52:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qFqar3zI;
	spf=pass (imf22.hostedemail.com: domain of 3YqfLaQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3YqfLaQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wl5LyeV0+eQ04x5EwM2jDgCGaIxGE9I19kcEd8pTzTE=;
	b=S7xYCl7HKSCVW6xVAaRdkqR2JNDmQVj8XyPbo2iXj/lyWnV0xJGAQNAhJLbkW+dyNdrEMX
	D1grb8EcBwIP93jt6bkhszvt/Q6I9l0lgvKjIhwfdQPka/JKDKmAU5QdmUyaDMEqDpLsOf
	jV7xveXe0x/O7fS+r5kLlurs6a7i7SI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954340; a=rsa-sha256;
	cv=none;
	b=gsOiklvOQWygOPPzGf42ys3eDHaUzCu9TmtK9I3LmiJpTp+DGJ0b56HAokm7U+Wjef0FHb
	RD2ic9sY3s+VJEqcgSjQMotVqrCWX938A/xAzAauxMHPGWmk9JG/ZL+QLENqAi9a2PlAM3
	AosUL7iwHceQzH7mKaBxv/52EBlBrVE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qFqar3zI;
	spf=pass (imf22.hostedemail.com: domain of 3YqfLaQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3YqfLaQgKCDUaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4887cade849so3156085e9.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774954339; x=1775559139; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wl5LyeV0+eQ04x5EwM2jDgCGaIxGE9I19kcEd8pTzTE=;
        b=qFqar3zIrorV9gCa+/yYXPVnSXOQsmCZcR8snjzt6MGTvYHucZ1QYIs5IF0gGjAnSP
         yUbGsy6btAir/0gMxuHgdOQXkGoMK7oXwdJrJoijX81rNOmyEWZ0LI3XRgh5zjfTszO0
         g3C4jtkYD98HkcHZqcfyZboNf7VYx2jMHiJ0o/jg8JF/X0yOPQO/pb89RGTHDO8Gxr5L
         2Zj3HWyJMIuxp4NnjQLhDNELl2SVsKCChvBzvHiFUrg7UxKmIfVSitAJyaD2FHw2rb70
         O641MufRvOb33PBCMtoUQgFZpgEUTQrHGLYF+czkuUa9d90zx6ZvaEwQZrEX3aFX4BPV
         yWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774954339; x=1775559139;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wl5LyeV0+eQ04x5EwM2jDgCGaIxGE9I19kcEd8pTzTE=;
        b=UfSN7FosrAJKroF2YhG4si3HT/J6iKYJY2su2oyNAtANsMkXcETT3msLeBt9eiBrxg
         Aral4HLN1GNOoGJ5HQoaKjkkj8SgDFX+25elZWcMNeUS1Zq6184k5/03VJuQ1k/wVk34
         Bz6sIwqEVzpnZ3ISD801KrBP41aypyOJN+H8vwt8OpaQPhsGZPcdQ4VtpW2YJe21/96+
         /VUxA5aWDUdW8KP29jrNEHS1rVi35Ggqg61HhxoTXA+KoorZYeK+4hQXJr9BV1L2r7d1
         wieR2i+Yvmr+oQXav0nsCDxCiN6BYI8V4Uf4Sfc8WO053zYjZzpYHMC6hoq9/+yGaWae
         L22w==
X-Gm-Message-State: AOJu0YxF2hWDiBsAnjh8Cns1YXLJFoY2KScWR4hpoiseXhxUN8BSmQVr
	YIyZ74Az0fo8v8A1vcI4wBsk3h3IzEQvDshW9JJQjjSoQqLmD8eUJoGHDoAhghXe1B4457xHT4d
	8b9QTEv+GZuuqJg==
X-Received: from wmdd14.prod.google.com ([2002:a05:600c:a20e:b0:485:2d79:6c74])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:e:b0:485:5812:bb9e with SMTP id 5b1f17b1804b1-48727d31801mr234219505e9.0.1774954338534;
 Tue, 31 Mar 2026 03:52:18 -0700 (PDT)
Date: Tue, 31 Mar 2026 10:52:13 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFyny2kC/x3M0QrCMAxG4VcZuTaQblPQVxEZ6fxXA2UrDQxh7
 N0tXn5wOAc5qsHp0R1UsZvbtjaES0fzR9cEtncz9dLfZBgCx5FLRdGKSXPe5qlogvOSNTlfY7x rgIwQobZo5WLf//75Os8fE+zz6G4AAAA=
X-Change-Id: 20260331-b4-prepare_alloc_pages-flags-5bb9a1e04e00
X-Mailer: b4 0.14.3
Message-ID: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
Subject: [PATCH] mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: f7mnd14hf7rdz7dir5xdc8y3krqz6ttx
X-Rspamd-Queue-Id: 66AA1C0011
X-Rspam-User: 
X-HE-Tag: 1774954340-624488
X-HE-Meta: U2FsdGVkX1+dPTM13cpNGhMQC3A48q4ysqeN6pOwa3nDf/UPbIQHTJWHktFKJD7WpVynlU4CzUUz37ifvvDDSBeyR0Hp1B6Dpj4xGCvtjZVsBHDIZ1a3f2ubfemSRBrO8oHsZK4wX7Im/tHHtDRKNm7mF6kgjFjVxod/P7vN5CA6HDs9+7qw8syCyKUzW1OGA4upFJ2mPsiYDC20tR9NGjwjF21D6xY0Ug/5froZmCMuOALNWVaF9fZBNrX6NxIC9/JJanO+ZCMbkaQMOYuXP5gOoXOeinZ3GHzcqMdHuGWmHnkCpnFvZUym3WHDFWbzOo4XY1Zv6QZlgjTxK4soA2rJx9iIOV9/ivT14i7H+/i91XUb4DyMigs3F6kEmJJIoSsEoFfON/7LR7/f8YRA5dbsLtYTrDJiBmlhucyDQ0bl9pGsLP/QmjlR9vek1ckJYBRuS+vrwvMnh8O/z4kamTgZHmjBGj8CGOWT3fPuSQqxZekruheumsn12JPJ1sMQuwVVOL83YE6CaDcjFpgW4GPBHx/im7FXBytdnzX/MRZON/ZCsnqKpSKHivpNJQaz7GwFqjpNQ9gRnyxPzmJtAwlPSqn3oBkEL9tCEsPwMONI6vhbSPpb1wYWc1vIByYu2h/PeAOBRHBylExKNYM/J5sHLNQ3Uj0hlHub9HBqaQkOYBVuZygKjWWMBpJu9zgK/mVOFOL7AtdRdZ8djG07qOhXEiovVTQjK+CJZYVYN2ONK1vnWJT3ikPhxJC/ec1E/wOV0PXfY1lJX/WcQyPKaGaf/EsBOXZDrRKLgd2T2o00KN3CJj9FD0si7seURXE6CW1FUMKnnXaWhx/NW+frxp2ETrlTkWEmcBe7uBU5vMxxf7S1FPTTRyJVC2OFSywNjXil8xwRek+lUIJJegwGzYAJxkf+7TC4ZcLmYbZ6SrXaIqIreCoFG3fJtrnyiF8hZuuCLvrH0oakftxmv2f
 4SYesQmo
 U70oDLwjW0Z/9YE8LRQLshTT+xmFR9yzJ3kRgJLuKeQoPHxl6JM3XByFzW4EMC6gdtvs4ENfAczBOd5KPAlot3lH68oNcqZ/K1yLtfkayNC8XNq5IQXWzhD+F3TRSik2w17HCSMIGcQ41DYiqo02tf/doQwCv+5tFYfLOb0I72vbFn/v/OlVb0Hye1OcpUyMY1y8qfGopt4iiaZXUHZSXGZewxp5lR+7DHi2iETxrbo2wnUHKa6z8ptIYECcveFkTcKAW/uGxn8XyEsMLW67xp/M/Y57IbOS0HX2gbEQDewKVxMqctwhDPrJSBgYwZJtOvVqS0pRFelEW8Gs8CWKQKcOIIPf3GWdcCMmW68WgxHJ3KhlCku33Qe9qJkVv4K6OEpMwBe8RvTv4tCyBiPHMS/WDQO4h4nRkrAIk6xnAQN1Mj3LiunRZkLunNp7VAEUWyJIeXdkb9NEndmTNfpfXApfIwEvldubGaB045gdjcZYzgPeM5xQ4enDDqAgEGY6AU1jdlvBAB9NcU9XE3x25mM5Rv43jnMNBYLbWOeuEk1rxj4ACQrpKifzFp8nNq3KqEDqA7n3Ihl/wDiKy/Ndq/mWcxYc5N65naqnSv+Ud2IsoLIlte5qfVDrCfTgjBPLvZkzPsz02GtzXLk60cedMWDUUc7xj7qTZYkD1KjPYiHxQco7yMCBmX3n5DAEBF507/hqK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These two variables are redundant, squash them to align
alloc_pages_bulk_noprof() with the style used in
alloc_frozen_pages_nolock_noprof().

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 111b54df8a3cb..5e280ded6e7ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5051,7 +5051,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
 	struct alloc_context ac;
-	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
@@ -5092,10 +5091,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	alloc_gfp = gfp;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
-	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;

---
base-commit: 57e5b07deacb0a9bd7b8c9b933ff72e902d4f06b
change-id: 20260331-b4-prepare_alloc_pages-flags-5bb9a1e04e00

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


