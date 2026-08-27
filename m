Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91991C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A41C6B0095; Thu, 27 Aug 2026 19:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B4D6B0096; Thu, 27 Aug 2026 19:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490326B0098; Thu, 27 Aug 2026 19:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B3D6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 875FA8021E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:26 +0000 (UTC)
X-FDA: 85148648172.21.DFE4BBB
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id BABCF4000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=dama-to.20251104.gappssmtp.com header.s=20251104 header.b=Rcvc3aPn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dyiy2y/avbYOe0BnQSrLgYOVHtwCGX72+qfVpLstJvk=;
	b=N6cG8oTK10WKfZRtR4NUvUVUG6bBFOobetqgCKNiRPRRd9mhBhD6SfZPYfISqJD8r7TqNs
	PLXWRURfe4nB8OoYxdieGS2CuGdwhoVJ1QeVeje0KI4Uw+Ds3EIDQOgM04qNTh05AwCTAd
	ei75lJ5sK2bNdSJnmrQ/afFaKWqm7Ss=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=dama-to.20251104.gappssmtp.com header.s=20251104 header.b=Rcvc3aPn;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of joe@dama.to has no SPF policy when checking 209.85.216.47) smtp.mailfrom=joe@dama.to
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873484;
	b=NzarKfAhXt5RJIFGyububvC84q3ldMfOx2j7wOXAiny858DkCWsY3NB8pJRR9NJS9e21mn
	Yx4ToF1n+ax0FjER/rgbT1CxIU/rNLXQ3qR0HaXj8hLArhzuBfDvrOs6TUzSwCT/iIzaf/
	Z5/QPrJiU/5bDiDnpQFKiruGOutuVqY=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3965d3d9ab8so227774a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20251104.gappssmtp.com; s=20251104; t=1787873483; x=1788478283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyiy2y/avbYOe0BnQSrLgYOVHtwCGX72+qfVpLstJvk=;
        b=Rcvc3aPnO415AfeHPLKPcZs2PiJN69hdqDn5ZUa7YTQYPWuBqYhNFjug1/7+RiIKai
         uoUql8bFWLyqN1CG8XHDushbSakNbx0PGUu91bXshlLf9sQxP7z7mRdbLMU9MO/MZtkO
         mTEg2rJYcgVaDP4nRV5skCnmdHQjqiY3phTR1QO3gGGSDaKyhx7l0zmdFGrJNQQHC5vr
         PvmbxeaLjs0y1mLKKR65K56DHYULdt95/UvseMO9u3eac5gno4TqZIdgbFJfNOLpaIs4
         m0rBbaYT3Ya9jTn/S2TiXGA8NG9wlkBkBZ+a4Qatt/G4MrBCaBJBavPqGj+xglkNx4Qx
         Yz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873483; x=1788478283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyiy2y/avbYOe0BnQSrLgYOVHtwCGX72+qfVpLstJvk=;
        b=R0yOVloJS+GfqcnK3paXnUD1bH8McIT9paqs9QKs4xwZEmLW5oME+WyRJEcOB9OSq0
         hE/XUYRhYN1TSZWdez1RkHJaxuSBg8snGmOid6sssGwJ/WcQ4FgH6NzfAOvKkp6RjsMY
         8QIR7Raf0ic6JLdDhcbVVVkR00ElXmeS/c3wFAuujIYaDWMHjTzPVrAIKUY4HmhAR8ws
         UgW28HFqUzdop7UhKLVX+BJIceTOyiZUFCMwjK9kU4UNge0M0lMWZ9qCYUcu36HnsZgB
         Av9pJxrJ9pzKcpKKHUZEFi62DiJloNDENaSPANfF15C30FtJl4Kyp2rap/rQu+2LUbxa
         yQAw==
X-Forwarded-Encrypted: i=1; AHgh+RrncBMzxXs3OqVpzkOJMBqutOyx1kdWre9X45QKnba4lh57gkAnRzCMXUhGp/ZjSnQrl4nCvKA0FQ==@kvack.org
X-Gm-Message-State: AFuF++k6BWZFIq41K/aF2lIfX3m/N3XOsvIOkWsQaQ8c4001gpeovxTb
	6u7xRTHjavs1Lzbekiil6pi4IM0jaeXRz22UgMLIpwZ/lGWenOMZGjIaFVGdzwClVGo=
X-Gm-Gg: AR+sD11IpSOLqUlUaU8rGrQya3bnWpakxvWjSn2StWH3XOGuwn6kMl7gGL5NjmRN/UX
	a5KDr3Fv8/b6+FT+0K4ZTED/x2IKJoVfOU0kGv39yzjpmIVkFKQPESZQ8Na8JGxZ2v9qudVvgpB
	KZkYIF9rjCQRxDjH6s50wIVrdAEeioAvYGfdWmgd6alm+B3/8NKw8vzS6H7JrSkQhevmeWL3yX6
	eUXYWxGPBHZGQaGHp8xtkaZXq4kZ3Dos1QpW0h09dkR98XQEGJxgLX5x1l0tL4jaateJKY5MA0j
	R5+fgLF9Y2Oq2UigxTyDra58k7em+0LycBSEXeI8EiqW0UkLxlgkbbCHSAolDwwKX9bxpONRM8u
	GMY9lL0BSOzMf4c73LrotvQ0ZCEn9jy5GvgMXnF586eywOH0/fWdSCB6lPs3ajiWpfgoxegg1Iv
	4w+bh2cq0f0E5phRH6fbpV7a4A9FVMGMhlW/MTZvxuAw==
X-Received: by 2002:a17:90b:1c0a:b0:396:54ba:8932 with SMTP id 98e67ed59e1d1-396d104e722mr3685624a91.16.1787873481701;
        Thu, 27 Aug 2026 16:31:21 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4a::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1ab4e12sm4501710a91.16.2026.08.27.16.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 16:31:21 -0700 (PDT)
From: Joe Damato <joe@dama.to>
To: linux-kernel@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Damato <joe@dama.to>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: [PATCH] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Thu, 27 Aug 2026 16:31:18 -0700
Message-ID: <20260827233119.411152-1-joe@dama.to>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: e7wfnwnya6xjpf57nh6ht49rupkjko54
X-Rspamd-Queue-Id: BABCF4000F
X-HE-Tag: 1787873484-277287
X-HE-Meta: U2FsdGVkX1+OTroAumE/Tqh/A5d7VsrFA51cFyMjbUm8S5xrW2NRFcvco+HOybwweqo45MPV7JL3dtRX3wvZjvwpCWiQq4weQW7i1GINfbcrnBWE968U6+Mdi34MyrapMS/SX/Hl+fDyX/JrbqTAXoP1/oClJgkjeJC2FRV5oU+HsEZLm3QGiJ+BPxFgaWp85SOxr1MMsSCW3n4nYVGo5t5tk4XpRhZMmlA5DrCmpBG+lWPdIDc5TDZOEaEg37Ol+Q4iEcQ/tChTEeVA3XjvwrrSmn4cffH6Io97ajy/ykos5JpoGR3lUfsasCOSBT94R2/Vzpeykbnu5qLBW+Kzq+NohNoFOyPsdXLYhFos02elywSNjS4HuaiMK6GZCK2eEkvqktclUAgWNgar4QWyUXzUAxX1m0j7FeOGGD66D3v7/hTn7UKhGaDZ6e8EE0QqYt2oToDauWkcPgbNyGai1ucHUE7as/W+Qd6UhAilgHy7F/fSVPMdtAOQcSok3f8LOQUp1euMZB5DjyDSyj7LjHdPJhKM1WsPt4bUOta/mNyLcU7utmttm6KR9Mgtwj+5vFZII7ht4GWdd5apkAVZ4oiIDqoPTf/V7/i0RJJckpWAVmWgGImHqM9OUp+GvnK+gwytgYldtz314kjyoMLhm6jgcvkibuZuN1bzMQt7M7Su1bBEQFjf833uTd1Iluev4fuPEnD8MPEoV5pMZRLtfgn14IuTl79zRRg0+gTx9NsZRKw+E42ii5Roau3HGsOOAJwkKbxJaUYRs7NhCLXGXTs+0ZZRjaFdrd1uXRvbMlmKnXHEjgaO5SkGMoZJDmU3sewWjUE2QEErPU+fTt298bI7jB44t9d/kTLogJiyqgnHXbkDan24H984GpjeSi1fxGLIA6SyiZjEaMD5Al68qedbN2Nz4sUY7+9+TOsPGCdu94LU4n80DGJya2Vm/xa+t8JqE2GDoc0iw05nPFV
 eYdkRu/1
 21CIn0MotR3b1aFqotvcXYauQLqqrnvgzkHncRoxAuf7om7gWUzLhBNre1s3ozxWyRX3QsInq76VSDNSmGYabKaAttMx9j6gjMBJDRSjOxQU38SGcuNhpMNPOUxHr2ZLwr34aJgSBTPXQfboX2rdOEnilWIljZgobHn67snLIF44GQ6kRzE/kAEDyc4s0JXfKuyJz94GDiR4b9G9HH9powjIBVFj3unPcG/1m2LA3n7u+QGNaRVkpa5qD6s+XT5wzDQ4DOYv3vcHax9jcQMgVODt12VDNx/nq//+IawXJxSGHWWqky7RgwMw4b40nNQKYJbuBp6d4tvJjNGwoXmWL8aHZKA8nJNjxK0SpYWSQEzIVHLBrPNemwK51MCR4sJJhkc0Xg/RKoENOiQ6UWPwC0bKBJJE9+7TUdnKGStrgL8M6ePiz9CgBovMUAwPQDo2n3QOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not
visible in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Move the event so that it is raised as soon as the charge is known not
to fit.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joe Damato <joe@dama.to>
---
 mm/memcontrol.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..3904fe9a7b2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2683,6 +2683,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	if (!raised_max_event) {
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+		raised_max_event = true;
+	}
+
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2711,9 +2716,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
 		goto nomem;
 
-	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
-
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, reclaim_options, NULL);
@@ -2773,13 +2775,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit

base-commit: 3d83758432b5e6ed9507500a57efb0f3af41ee7d
-- 
2.53.0-Meta


