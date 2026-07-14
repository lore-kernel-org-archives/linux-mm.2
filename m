Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489F0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8935A6B0098; Tue, 14 Jul 2026 05:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86ADF6B0099; Tue, 14 Jul 2026 05:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7330F6B009B; Tue, 14 Jul 2026 05:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4189C6B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:32:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0C8A1A0338
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:21 +0000 (UTC)
X-FDA: 84986866482.16.85C610F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A47F14000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o9CZqbR2;
	spf=pass (imf09.hostedemail.com: domain of 3IgJWaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3IgJWaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzKR252Snnew5WaAvQzSvTHfEGNrnKkZ6pkR9ltqCAo=;
	b=dMYKmHWMB1cHFY51DYHKB9xfRCHCW5PHEHf58D8P1IHNtEWpXWL1v2TJBhsOxh2oIpKrt0
	OZiNLOsWFn6biPaOjswgnCSQv4HjglzjwUd35P1THD5491xtqoYegHbt8xh1PxyGnsjcGx
	HXf37uf83uPvqPafqs8rp70sQd/ID3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021540;
	b=mC1f0pJW+xU/rznP7Mes/M/crCdodaMU6w2R0xaRQKcnb/LsS68SECf2BVedOuQTeutyJt
	/PN2f+NdXnZsQaAska142G7lWb4LT94USgYPMJtDZ2Yd8xV3YOiTLYQDb7zOFrLRkvYKxc
	LNC3vvSWRmn7BQmUO6Wntyz6LCYceNY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o9CZqbR2;
	spf=pass (imf09.hostedemail.com: domain of 3IgJWaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3IgJWaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bd52dae6so27102815e9.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021539; x=1784626339; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WzKR252Snnew5WaAvQzSvTHfEGNrnKkZ6pkR9ltqCAo=;
        b=o9CZqbR29uZSb6QpfB1U0t6dDSO8V+JkJZJA3xGTwB5Cr8+NH4SnS9learTnhN3Xi8
         I0YoVT2qCt/MqeuGCM4iUo9J756w0bFMH5UEVYbRQc4GRKJZpnxJLATkwzKo3BR3kUyN
         fbx/fGzsH07Z3PPa75QhpO3sn0E2mZ+rbKk+AbiIEQP9VwutXzwsNW9LYcMmoGqPhty+
         2B69smgTcDQIcpXPlSE0PMRU9YFAUXXT7n7DgziBZYrI61YTVbaNn2x5OJipmxk00v/H
         5+fXZiJ/EHP2Qd2DVFT7JDsB0J70qEmn4N/P4a1QSSHnQI5/82kpZm2v6p9+GpsGfxHs
         rH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021539; x=1784626339;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WzKR252Snnew5WaAvQzSvTHfEGNrnKkZ6pkR9ltqCAo=;
        b=RWPXJVw6s7AnObd5sG771pAdEZWqj+CqGaoeYEzmtrQgXV1sIjJ60QvTr9gE/5q/Q4
         dsDZ4576AIY0J9ZdvIlJutmaerJ0iHUBuvQ5fkCCRa1hMltWEIkEwx5dE6ZOUZ3ZOu4Y
         Z4zV6W5SSiAZbvae70g+cordu2zNV3fKALT0cac0fA6RJuPPE1DD0BK/m1JdjGjn/o3m
         YGe/vXslBT7VcRYJ9lg9UAep0X+6AlclQRCSXzOi4819I2c4fbaKA4Ii+3LJqkIrjgff
         0XnoVRjTFeMQeNSK6/8CKmHlmjyOoqWbhocKIjVC+ArJ/0KdZkjFDD0yRc28hTJy0+wG
         /lTw==
X-Gm-Message-State: AOJu0YxGKqLMhV4NvlJ0yAVSGNBJmON1YT8AykA+B2ypYExhi5pZh9W7
	5U+mAhoJhwgrxeiHGM7lEw5JhcHZYmOuX9Snca9pyHhWPcsh1/k++jIVevF2Lg5W983VAeWPsF3
	3S8ZbQ6U/rxVhOw==
X-Received: from wmo8.prod.google.com ([2002:a05:600c:2308:b0:493:bc2d:fea8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8119:b0:493:b6e4:fb2b with SMTP id 5b1f17b1804b1-493f882cc20mr115137745e9.25.1784021538718;
 Tue, 14 Jul 2026 02:32:18 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:32:02 +0000
In-Reply-To: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Mime-Version: 1.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-4-3c20ed032b14@google.com>
Subject: [PATCH v2 4/4] mm/page_alloc: remove a VM_BUG_ON()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A47F14000C
X-Stat-Signature: 3ni1gqyufn9sb458q83e4hkg5bne3dxz
X-HE-Tag: 1784021540-812315
X-HE-Meta: U2FsdGVkX1/0UdmgC/yCzQzrEEF55yC2lZCquILVA75zIoqF2kCgBXQOItend0yUKlpmcyhaP+ymg9CPucZagweV3ZnG3jcyWQ/wk19MQQWOOUXvgenO0E/WtAOZda1An06iZsZL/s6W/TLuXqHyYNXur3gE4xeqlmbMtM86vBB7uSKnYXhlhEnIHvse2lU1TYHRQbGFTLSLXaWa9qNxlT8MKR+eirWNZD/eFXShIDDfe/FUcM15ZAOyZJ+Sg40r2kSr9alXXSOmE+M/z0ScRQYu9kBZWceUCRGKRP60GFVsUHOfNJ36AU/Qr0lbAv/TST8i8pXLoAOtDSNGyl6EJK6QC6uuD1HD3N9p2ggVJyPmiu1k3a8r4dqRhh45nZeMTXjQglXRISu1AHDq459LVIh8iG0cCcqLtC6vrNwv9hJqPRhjdSGB1/m6Ydf/9SXPuZmp8zYChUh+GkY0STrQwEZKhfipJfIDigaobW6evYYGWXvMM4fsCdFyzMOI3qPdwWN0PCStMv3VUAKhQf1tz+U0OQBCzndeI9IeEBaQXAcVzdpAthrmKfDnrDfxDk8QuIQFsSzmPO3ybD68Q/a8Z3yxtgnlzKfjHbgACiAxEXRAYlXkQEQ9DJRldK6K8q4ArNGjrbEVL7ltarEZR5qlZjmf1X0wlibnsMdP9SmIhuTXiTiiVb1x+4VEpSWimpn2HM+vvBQbN84QYwBbtTjTluh502Y1vLPSVYfOHs6a78EAj0Ml/+zEcnHEw6XLUrIeTOmW/K9oauWftPvDxm+OhxJZtLCyTeCjbAsoHCgJIkCK75u1YlsX/2l6Z8BSyfT6RG2jAAPTbg7lg0EISzBh0+dFDQ+03ELa7CdP3908bHs499sb7cdsYGUlbcVuEhk95YpL0RGeYR6uNlqmXJIgiOzR94lpXaOy4fvHJgedZy6CjM56MPowK/zRlwrIAu69VbJZQE+Gcs3MdWeR3Aj
 tM3mwp5o
 nnEQ4iKGk6QGtfhMwKj9apBZbCwcIvpt1cAe0ACSrX5hN2wWN7z/Gv7xcGMY6ml0jGIJwRa+/Z0QFN3tX0RICRN8vBWnXc/4MXaP7FqiMitg0z3QFYTwwpW2B8PYrEawNDv/JD/X4BWNAQzhO+WH8b9MUMDYrAV8Qawk6xMFOigGFKeMOGp9VnwopW2G2qX6kwsyAEaGyQvsrmo1/fx3Jnu3F0efbVNXIDeIeZgelLFrm+0a7r5zPL4iSLtm0a3bQvrvuPR6H2gj6s9tap7OIvePIrQqiWtq8bomU0ii5BXGwO1lnUaJXXE5hMYTLXwT/dHozdLOZu7LfpsTgu3u/s6sT+l7n0xnogkMjjHzNz9VhhP4JGO9ihZ4WEUBJ5xyIzDeo8pQ0vGqGc7MAJKUW1hg8iLhZKDL2ziEtnZhEw1x3bGg0Y5UwoqyUBRBIslJ6UqMa0GPPpewOd0tZzgp0+MTVNhaOaiAbQ8f+6YFNiQFrxcoz+8TVKQiTOh1rnqoMhNsYyODHaLhiPuO8Ep3lr4bDeObCjR832F8DaBIHyOiHjFa2oodm3LRGLUPkyNTeSTYZf6ZP9AWH01OvEph+c5G4YgfjZNXqeiHJlkg+0kDiJTivvDoNfhknnSRkeik7PgzboS5DKNAydVIk7tDZtHwvMfwrPtbIvu+UsK6VHoTeNKphavAS+k7qlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched this code I am removing this invocation. If this precondition is
violated, the system will soon crash anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d53f858e518f7..0db1a7281fc33 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5438,7 +5438,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);

-- 
2.54.0


