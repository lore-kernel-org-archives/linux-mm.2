Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20050FF6E9F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF5F6B00A3; Tue, 17 Mar 2026 19:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7802C6B00A5; Tue, 17 Mar 2026 19:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6485B6B00A6; Tue, 17 Mar 2026 19:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6076B00A3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:07:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03565160427
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:26 +0000 (UTC)
X-FDA: 84557093334.07.DDA755A
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4766A1A0012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AMcaL05W;
	spf=pass (imf19.hostedemail.com: domain of 3q965aQgKCKQFMRKNMESKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3q965aQgKCKQFMRKNMESKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773788845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrgwEjKu+QJdHEXo5hFZmjJR7NuvkUAEBDxhWygoT50=;
	b=ntKTHCEvACKAZas2QEw5z+V9hIGG9FmUpzQXkxe+/HEDErw6J7KS7iAfzHi+zyhNGNjTi/
	6GIgREoIsF4bh1vvlmMhNmL4d7hdg3w5zG+N/ovbuKI5CCSDA2NrTi1wAhG/fGP5Wb0i94
	OKGfPr5KYgPAmjQUMcIMzTXrS86rcGo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AMcaL05W;
	spf=pass (imf19.hostedemail.com: domain of 3q965aQgKCKQFMRKNMESKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3q965aQgKCKQFMRKNMESKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773788845; a=rsa-sha256;
	cv=none;
	b=0jsINwrY/yTXEFNxDowN6I9o2Ja9fo48zl2uUP3O2fNqTVc98/WwzOcPH8lzaPdXBhxtTa
	mwUv+lpByCQNE1Zb3i0Uoc+Q9xqzfP30zJrZFn16ECa+hJ5jupo8rzyLDEody2jsh9Bpxd
	j2XvZxJPSAEfWE5f7Zqpv3yXf2dZxCc=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12776bebeb3so22070986c88.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773788844; x=1774393644; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HrgwEjKu+QJdHEXo5hFZmjJR7NuvkUAEBDxhWygoT50=;
        b=AMcaL05WYYvnu0rU8BKpAxLwlQS0Zr3FNlbp2PW8LbYvOPYhAgqXpkfDJm6q/jDvAS
         4/vpcyPWrvV5bPdmfgNuZOZ6l1bkGPV7kXDQMBFZHBk15C/GprciHkGMxgVqv4TtSlSx
         jW7I+P3LKc8s/aUQMw46LPgc8xxV9Ck2o9thIm7059VMCUlAEhyeiKLOuN+P/PIWqECG
         VqAN7bD3b6AZS+C/+gG8Pc4REw9R7lFmjhZYOtxibs7UEN64PVLGbbmPaFgyPN5AYVEo
         mDDCQP36JOxLlTBUEOht3U36jc/40EOZTXCm4NJQlpJBuUtooB2J6q5JhrhtkAQpZrYF
         /Ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788844; x=1774393644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HrgwEjKu+QJdHEXo5hFZmjJR7NuvkUAEBDxhWygoT50=;
        b=Sd+a78Ok8mGPbM2JeN6FIArcjGKfFx5WIiieT5g2czHjXM5hebBZBi+5tfo/Dhnu4p
         VYa0NTjh+IRCR/89ApglL1WyE6V0HVjl27vEwO6gW9SuKl+Ht9CqX/YOLKsfDS9FP/Ys
         W4UDrztrBrE0z/z29szSkf6MWNViUjG/4Xf/wSMDLc26V0ETZUOvnXl/wQHukl7sSiGM
         4cgMPlOESfYsvCr7KcUWcku8mmJDter7kGR8Z3OsVOUinbVd6o94gtdH2owKclkx2Wj7
         ufQabIbW6TOC2gZePVXUIhNpnFJx3tOoQDamiAa+vL4tmhqvcAku8ZK0KESGYtoRA0ky
         2L1w==
X-Gm-Message-State: AOJu0YzGUYAanB3xNPbDJAAtwJ024KIJOcGY8l2KFFbHbGRM7khX5AHk
	RqJ7TYwx92pNPf/5pAFVPZtZCqg/ECrefnbc9uiDk82s43flcpKxIBOrL0mDrSmYPuq90dz2CRQ
	jpl0Mz6Kv0lnycsJGJQf/LxNG153BVIheLi9CoFG5CqJMqk7fyaXYGpVt4fLLQbjPgfaI0UbfDe
	CqNJsFEMWnIblcEfvJ828svAMKzopaxzLJPvnfypSusg==
X-Received: from dlbep9.prod.google.com ([2002:a05:7022:1089:b0:128:e027:28aa])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:619c:b0:127:3915:76b2 with SMTP id a92af1059eb24-129a71795ccmr770593c88.27.1773788843379;
 Tue, 17 Mar 2026 16:07:23 -0700 (PDT)
Date: Tue, 17 Mar 2026 23:07:00 +0000
In-Reply-To: <20260317230720.990329-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260317230720.990329-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317230720.990329-2-bingjiao@google.com>
Subject: [PATCH 1/3] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4766A1A0012
X-Stat-Signature: mop8nd3iu5n5rjogehswdqr987wt5txq
X-Rspam-User: 
X-HE-Tag: 1773788845-138346
X-HE-Meta: U2FsdGVkX18j84iEHwiMV7dQ02fbpxl0IScHy5cPQPiuJyezutZ8yDH0aJ1g2LAHydhF/zd+RoNlduXSdNqdCJCeBuGJGmsjWdS6RzRnabURudzVx9ZFpiot30O/ceQxbPOcOozh2XunabjAPxSxqU4D5KUEYxAuKMorkd21uWJbcIqjuJ230/Wc9KHl62EXPoaEsaxAtFYmCPSu2gU9KSBgwyWg8R1hTqRm8lEjFWOi+y6vxErw+uY3ynBmR6sX5xjNZZOGe62D8U1i1V98T6des+l1y5RiCSdaqZ4W67X5ePifrQgIgYKQVmf+49eNAj2CTJUjSLk82TidkN2kBh6k5x0dWGGviq2tj+BseqOH7vFZ1O3RpGl/c6Tfgr+aA5nLEF83jB1YqQ0X3Z20sBSH/dVtrDDgyvwWuWaZ8kmEdclWtzTGzqKZXXSht7T7HB1svz8GrRPGrRBm/oZMGMnhHGyaAGTpm7EiDL1b/7Q/9XNsT4ZAzOHPxelteHCWTyoEFw5/gpFTESx7qXH7YNYgHOY6MNbRpkrB7EjBuVYiQJJHbXLaVHGEeRZNa0MnY/xZ8TyF3oZdlE6FCchgQKwXsUBLNtxTTG32JkutBdS72qTtzOHge28RO9skPpgMdSS2uCAXljpfl/wwx75AgCHNQU1KUDgJJecj++oKWd4e5MuRyV8sn4iJ7kN/9YUiU2sTaZ8HsWK1GueynKOAEmVRJBfInKYtjH6BAZZezU2ppEfrLDo3hMD0w6hQu+aeWsi3klfQQZHN+gpBSS/d8xVISWL5e5CxmoAmPxOn1xM+wWuBaRWk13cRZjYY+FjVGavmQ4QG0JtNOngnzRBBBJJT3VfKKpt0sy5QgdQbyhH4z91YOcy9WmQXixz8kqaFJlKsjeG/a+AopsiAoLijlTFdxlmpwfx3Umhp8cZhN7lZfka+1N0cnMJGhcEXVopMMrgk5Yavl90ll6rfwTL
 BAQx8+rz
 ESt6S8Sun7JOH46dIphc/b8rYGkzEhuo3BlRex5rad2z6PBCoAE1t5rWqUMLAMgOOw5wbp2Dt6ItjJ+NmQZ0SdVFLqy57ixEAOknxLO7rYaYXDel1WsXy3RWJrMgKDeVI0HD2fC5y4302TbIvr6cnJyqbQautTJrXdB1VaXUBg7EaGKyHyA5b84VKrxNdFxHRNcnE/cYO4ceHbqDqd5e9pxEsqEUgAKdkWgSOBfgaqmjUt8ZpOf4c0HdhzYaiuMN7CP6PNkvhuRxHltFz0C4WVYS3rsiEp4LLfuecKhoj6mYFryr2AB1f1qfBmLf4j69ImDwk0N68Xsbdg5bLFzmSlt00cNxvILE56dkEvjMvxPPERgaHO0cEoThaD5Wnjke6ESy1vYl/qbvpqzQTYJOeIiWmnpPNBPCdPhAew/xyTDqRg9I2jOIx2NvCKMmL64/MCO49vXVo4bYhOMAkUzogqcPltOTezA1ucn/Bin7qzt27n83Tkj+Ef1/2YvxiBvREnlLk/+g2xQ82FPnZVokSdVQGoBmu2Rnw872zYqRV7vhcIM8Fpmkf9psI84g8R62xGqKWJBQUxe8SM0sPs6dFsPTDP91qmSmyAgeSzbHqzAPEm5CsP/B/3npS4JU8rfHCXbMU5I7JHdIBK1iYqYYW57fkUmOp5O7+tICKJeanVrpIT1cx+GIWonuY1oplFRn4ydLdYfNoczqvO4MFcclw6umJQFFwLP4E90/JENTgoB6QcqfYKlcvokMwzvDHFKIyvzhk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_charge_memcg(), the 'reclaim_options' variable is initialized
once at the start of the function. However, the function contains a
retry loop. If reclaim_options were modified during an iteration
(e.g., by encountering a memsw limit), the modified state would
persist into subsequent retries.

This could lead to incorrect reclaim behavior, such as anon pages
cannot be reclaimed if memsw has quotas after retries.

Fix by moving the initialization of 'reclaim_options' inside the
retry loop, ensuring a clean state for every reclaim attempt.

Fixes: 73b73bac90d9 ("mm: vmpressure: don't count proactive reclaim in vmpressure")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..303ac622d22d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;

+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
--
2.53.0.851.ga537e3e6e9-goog


