Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD10CC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF27B6B0095; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D6B6B0096; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943E06B0098; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7EC6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DECE51C2422
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:19 +0000 (UTC)
X-FDA: 85327358718.26.AFEEACA
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf08.hostedemail.com (Postfix) with ESMTP id 33935160005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WtzEXJJn;
	spf=pass (imf08.hostedemail.com: domain of 38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ma7gRnhklfq3RjMbrjvxO/tJj3AQPjFTVpV8/fRuCwc=;
	b=dtyfMIGz5izYvZIL70YRabCtIk5McBvWE2OlnnEJjCXFMF1wiFViS5zZ7bT4HKUUHBlrkD
	umKslZES1kPlg2s4aMXsZy9AQ8+SAKyUFxMtuhm3QdVpFCvFCg/PRezE3+WuMRmdghUFRo
	Hx7z1pP32Fa0r7ScEoHsj8SJusioPJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128498;
	b=2P2Ytm/U8GRGx2VsQ1cXYxMwfoQi53rYEQrYLlHduG6moPnW2Pr4lQJmVMYj6V/OUSB65/
	tErkRRL32bojjAov4JsIkGa0S8VMb1WJ/mEiCOS4wfsJFdf5akqABGofj+unMrs1yauJAe
	Ws7VVV7iu/JeupUtNO8zBOdA06N4WOk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WtzEXJJn;
	spf=pass (imf08.hostedemail.com: domain of 38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e832c03576so98782045ad.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128497; x=1792733297; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ma7gRnhklfq3RjMbrjvxO/tJj3AQPjFTVpV8/fRuCwc=;
        b=WtzEXJJni+WPEB5MIzS9njnDiCs0b2NE9YWN9NkxeEj3XBi33ptBUW5CBc+PQNaPJ3
         SBAVbOG7fnrTf83DQxGhs4oFoQ1yeG2toFNndGa0jpf/IAnzUOxP2QT3DjOqLifhpi7V
         QMYoVLCn9nxhGfyJ8YHGiohWwCCjj7MZQfL812Nk/1Dii4Sx4enBCmirD8ddqmeDvMkZ
         +6qBVTlJwDVBTy70gZSVwtt+tr0Ia6wGhC8bfmlVtPR2cLoR4XthFdooePoYRVHzxFwd
         dMr15UqualkzLNCYHGFHMRaupip30qYH4YT4ICwH62mAUxsVm9yqtG+9n+kvx7SVyEbU
         2iDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128497; x=1792733297;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ma7gRnhklfq3RjMbrjvxO/tJj3AQPjFTVpV8/fRuCwc=;
        b=s4MPPaV+tCKPGkuOicoBM9wHwf1hjN8/+kkiKaseiXnXTXXjtn0CgynEHRYhTaSoyX
         wL9FJ1VJ8VHDr8/CMO97uyDTLJkHCKam/pR4zbBnpSQZ98nNiS4OzFMuz+Nqn++x1M8M
         NIhP7sROVZtbEHUwCT9eKkoLntg/aXeC7q+HubpjLSepNQiLAbVmOYPdXlq1tL8Nnehb
         vW+1xEr7oWt0eAk0HXe0CwQTIzzwR69sRYYLfP/Bz/udynXyPKFLOcGtiPVgbBN14QxJ
         yvcx57K6rUuDm6FnGbXkzPoXm4kJBacqBn7cp6GhZRWCHy7BGCKeWPG0Y1OI4Ez1SQak
         BeSQ==
X-Forwarded-Encrypted: i=1; AKwUvByByeOhEVhKiFjO/FXV28rtRFZOgDc5Zmzz4+rZVPahBmri4un+JfKTWfhkyYpRWKfp3lgT6cN3uQ==@kvack.org
X-Gm-Message-State: AFq9FYJtdMCAAQYWEGQYOynzDykzRYl28ENiHislhwqF/5Cs1nnsWi97
	1CZA7x3AJtaM3Qli9kAFzEiyu3EqN8dkO4r821KO8ShHMHokf3MxfLLgTcIPZe30ZRJnfWemSbK
	ZPTh0iA==
X-Received: from plou8.prod.google.com ([2002:a17:903:1ae8:b0:2e8:486b:aed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64f:b0:2e9:7b4f:b994
 with SMTP id d9443c01a7336-2e97b4fbb2amr19450185ad.33.1792128496943; Thu, 15
 Oct 2026 22:28:16 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:47 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-4-kuniyu@google.com>
Subject: [PATCH 3/5] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 33935160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uc56qa6uzcijz1nimbjh19qu6sctweq4
X-HE-Tag: 1792128498-860152
X-HE-Meta: U2FsdGVkX1/yHTeuSu5vGqhcCe93zdezjf9+tc8PlDPil99k+YZJeDY88n5YYcyuvXqOXU3XTluJYakFWaIFtZ5IdaCppAmziHqYM40QE1AtjCLkJBwklP8fF/J1n30ob2y6nVIt78wtdQB5XRQ28EloUnGEdkPnTB5q82bKVIT4axK29SVLv0942UBlVTix6e1bse1qVJ4goT6hWdxeb4dg5FOeiiBSUa54rKZOTzO2e9N1mgMazL8HDumYlJ3s87VlFnLSWxj6qIHlx6IF/Ih2gniuNr4bsa4/9czEftA6XQyb9zP5VnMDNbMjbEb0CpXbrZTnusuEcrSD16l2UbT/73mnGOa6ztReffX38hv+xybdakVptT0jhDjmD4Ghu8TPn5YurLLUQBe40aEwxvqRO/4nETbHiOGBPqPd2UO7HKdB/DNwG1psAakk1JsLXT+8c69QHuWwo/QuJPWuc3332tSWB6tkRU70A9myHBQuCuzUP8iC5DTR7K0ftlz85hIOaSP7uTrbchpc53oTZTMuL5eb0el90MDCNJXIqZDIzQtCYsobXL5pMhFytqlBrJHvDGZaFkZEYoarwLwQ2P07CRGghoeyp7mPoGa1NDyFY7/Y5W4HEwALq1y8OacZ/Zcxr3/cfyRa1TAzCmNWmDIc/Yq+WR+he5dA/IKfnSqYxf3wDJKqd2dNFZNfBAUxdMlZ9AEQ+ImrWfaZAaf30r+mslr7GBHRG9x/3f/Ce/uybt+4iitBvhyRkQ3TnfBwcBeZqo2+1ZcvlOMR1NFJZ76yUxRvOzOUYXeM17qJyfciozC1v0BrSPTSOjV2o2n6NcSSGBCfPpzQ0dJWRx0dm3yA0giPgqqvUuBGYSqhZ0dxfInhinpN8pHpA/gNqxP8Q/5M0oYcpGdE+mMBSaReAXbk0rzXELYO1KVOawaQMyIH/3US7OCPcyBQ/vEplW49/vKVwG2dJ3SkZjFFT4u
 mHRjBMNl
 NnqIr4+06Cy1dyy6q2mXyhQVggvq62iIryIq7ji7487OnDUBuEpUJQwwDj0kYLCAfJ/B0oZS6/GwKtp7cwfmMMwbvanfvAZVrO9BXQddq8XFAkXNdAisel7VsXb4ohxTZ0XXdGIhqguMWEQOFhh9tZrzUJLAroJw68/DtNJlJR3pQ/ufx9GmTjPJuV6Do911pPjwKy8LgYE0esTRZP0lRHRrE+iwqMFLtBJhshkNHUwTM4gXagPrnidQIVebOGeeEb/jFOvQJaYj6fc3rchEohjFBsk1F08VazJgfxxSKuwJRLhrSEBS1J6frj0uh+BE8KpMc/5zN+591Y3Ntn0+e14BSKsXYDldSg8nPiRtWzABhhKcE73MfV21dEy9aX9eKRE+Sv5myyFMHPctec5+Cgz37Jva2bjMB4O53n/H3uKRk0RNwvUGlOxczPsKdQld3JiKh3yBYQnwzymxKeGoQ15kIruzsr3mTrU4jrcUMwWKE03n6By+fl+ABwWvhVHBfrd3UoyI0xnW0pbXXY2NiyCghBQNfbFKSSBI3uMM2KJKqbq6XhZ89rbeLNhpqYnmpzHPi2RscHGb2xnrnxD0udPF8DovnOVxHfpksACnaRvQlDC0f2bMyrSJsrPSKGJLwtR1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_CHARGE_BATCH (64) pages, so depleting a slot
in consume_stock() (!stock_pages) or overflowing a slot in
refill_stock() (stock_pages > MEMCG_CHARGE_BATCH) happens at most
once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages) are
all slow paths.

Without unlikely() annotations (when building without FDO, or when
an FDO profile does not cover a caller), the compiler treats these
branches as likely and inlines css_put() in consume_stock() and
drain_stock() in refill_stock() right into the middle of the hot path.

Consequently, the fast path has to jump over the inlined slow path
and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
drain_stock() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   b242: 43 02 74 3c 01          addb    0x1(%r12,%r15), %sil
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   b247: 43 88 74 3c 01          movb    %sil, 0x1(%r12,%r15)
  if (stock_pages > MEMCG_CHARGE_BATCH)
   b24c: 40 80 fe 41             cmpb    $0x41, %sil
   b250: 72 4f                   jb      0xb2a1 <refill_stock+0x2a1>
  struct mem_cgroup *old = stock->cached[i];   # drain_stock() inlined
   b252: 4b 8b 5c fc 08          movq    0x8(%r12,%r15,8), %rbx
   ...
   b276: e8 00 00 00 00          callq   <page_counter_uncharge>
   ...
  local_unlock(&memcg_stock.lock);
   b2a1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   b2a9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   b2b0: e9 93 fd ff ff          jmp     0xb048 <refill_stock+0x48>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   b278: 40 02 74 03 01          addb    0x1(%rbx,%rax), %sil
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   b27d: 40 88 74 03 01          movb    %sil, 0x1(%rbx,%rax)
  if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
   b282: 40 80 fe 41             cmpb    $0x41, %sil
   b286: 73 23                   jae     0xb2ab <refill_stock+0x27b>
  local_unlock(&memcg_stock.lock);
   b288: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   b290: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   b297: 48 83 c4 08             addq    $0x8, %rsp
   b29b: 5b                      popq    %rbx
   b29c: 41 5c                   popq    %r12
   b29e: 41 5d                   popq    %r13
   b2a0: 41 5e                   popq    %r14
   b2a2: 41 5f                   popq    %r15
   b2a4: 5d                      popq    %rbp
   b2a5: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  drain_stock(stock, i);
   b2ab: 48 89 df                movq    %rbx, %rdi
   b2ae: 89 c6                   movl    %eax, %esi
   b2b0: e8 2b 16 00 00          callq   0xc8e0 <drain_stock>
   b2b5: eb d1                   jmp     0xb288 <refill_stock+0x258>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7c722a593cb5..cc3d78938b34 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2128,8 +2128,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2139,12 +2139,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			css_put(&memcg->css);
 			WRITE_ONCE(stock->cached[i], NULL);
 		}
@@ -2243,8 +2243,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2264,7 +2264,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (stock_pages > MEMCG_CHARGE_BATCH)
+		if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
 			drain_stock(stock, i);
 
 		local_unlock(&memcg_stock.lock);
-- 
2.56.0.212.g129ede20d9-goog


