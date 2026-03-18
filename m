Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB551088E43
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627A96B0347; Wed, 18 Mar 2026 18:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFFB6B0348; Wed, 18 Mar 2026 18:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CD36B0349; Wed, 18 Mar 2026 18:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 425B56B0347
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:20:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD7A61401DA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:20:15 +0000 (UTC)
X-FDA: 84560603190.05.2C67D8E
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B6811C000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:20:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CIMcGVEy;
	spf=pass (imf21.hostedemail.com: domain of 3HCW7aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3HCW7aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773872414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XjdRK+apGY2bi7TFVCOUhj0XNVIb0zT+0LrkX1AC80=;
	b=8TOIh2UsWVlx9MOxzjtLgBcjWBgV8uG4a/Ka7e8TlcDboLm6bNRD+kt7S+OEJ6UkC5TaNx
	XbcPdAXAKhU4r9clNpkq4KDk52RqRtJdbIjvHKuBF+Ft7i3QB5M4YSSR7BHBq/GzGvBOq/
	NUzDDGyD6grb03+DdxMyhwFg2dAO+ns=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CIMcGVEy;
	spf=pass (imf21.hostedemail.com: domain of 3HCW7aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3HCW7aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773872414; a=rsa-sha256;
	cv=none;
	b=MSNllxI3jEPvRgkjhe/qgCUgjOZVmppjzA+f7dw5CGg8rv5m36QDFM22brVB40U6hYNUrO
	lCRvetcDtif/kDMJQImcGK8qSfXbLEFxv5X6QQmBY1q6lXV0MFc3i2tPwVlswiq8UygbLV
	dp+4Damw0oJw46aNkS1t0DIa/KQhOeo=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bdd327d970so185887eec.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773872413; x=1774477213; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8XjdRK+apGY2bi7TFVCOUhj0XNVIb0zT+0LrkX1AC80=;
        b=CIMcGVEyt7fG1e+2bwKLrEILUaBzwxs3Xxl4VHyCckxe9YhAdkg7hMBIys6jmvYigC
         aUw7PKvM5leVCwVvjjMl7zcJun+57EcKgx81TPyI0kgIX3GOuV8x4hYMFk57G3oQ2zBl
         NgREHhpYlnwQbFKGBFjd4fnyd5QzUyQp7XiYKW3D/paufpXnf1M1KD58v59LgMBw8kRA
         avzOwa3SPS2rADY3oVshQyA1ezf8zb1a0hQLfu/0IvjS/LVLIn8LMzAx8jMJkvdBW9jN
         Lzog8MiVeo59Z+BDqXWOxRWXYmjy9yFsTGQ7jD7ofSJZMhmBTwDBRQlqDDIpzvVemt8J
         Tpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773872413; x=1774477213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8XjdRK+apGY2bi7TFVCOUhj0XNVIb0zT+0LrkX1AC80=;
        b=eRVgao+ENhzXje+dH1gpLmu8DGqThpz1DIBGJxiL65V8W6tbij6uE5tj2Ur7i5dITS
         DTbYkBnXnv7M5p9A5CWVtaf0SRBScXznTJvQ01NXUN1NZbsv+wR/Fh/aqjgiZvA9CfzV
         qWH+MckgaAtV49n+sfqUjHEwSZkcIlgRV5g8mkQ88Jx65tnPfpGld607laCplyIaIJtm
         hdrJ4R/MLbDBUCRsUiXBzk3CiRFNWzRJx6KizrZYa0A+DsQawxiMr66R0GNszI/0BLMV
         mpIznVIWQizMeyLZ5Y3QMHGYWC3AbG6myF8xLggDAW7QFPOgaV5j0P7WARTCRg1XmbGi
         qLAg==
X-Forwarded-Encrypted: i=1; AJvYcCXlP7tgvuDJ60iM9sILZxiYKHJyv+q9d0fdj2jpq55EQa58v/pAHlPOr1/BT7LUSHT1jwdDETMynQ==@kvack.org
X-Gm-Message-State: AOJu0YyB1eh3lbqa/+XFBOEnXV4dntm/op+VX0olUIguBWJOP2gMNdk+
	ZliH7ZONkGYxZ86SXFRlRr3+6be02tWD7ofhY2/5B3Ycf1Ei2MHuzqVXeXyrgKDkCl4P0+cjUMp
	skqMO3/1XF7fBfA==
X-Received: from dybmn16.prod.google.com ([2002:a05:7300:d210:b0:2c0:d899:d1a2])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:e82c:b0:2be:1a8e:10bb with SMTP id 5a478bee46e88-2c0f3c333d0mr528958eec.12.1773872412419;
 Wed, 18 Mar 2026 15:20:12 -0700 (PDT)
Date: Wed, 18 Mar 2026 22:19:46 +0000
In-Reply-To: <20260318215629.2849052-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260318215629.2849052-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260318221957.2979346-1-bingjiao@google.com>
Subject: [PATCH v3] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	rientjes@google.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2B6811C000D
X-Stat-Signature: orx1xtetwzegy6fgejc5w31bfcxkojjk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773872413-944083
X-HE-Meta: U2FsdGVkX198Q9hBdmio7ZJdZKooxzoT05PL37GYPF8pkANwSQEYgxgiKfBJE37cwwWW+fl3jrXG0U3eangP+EbPudVKczhknkNMdvcAIcv/h6ghinp6sqn9mHYkWxY9No6RcjIKgXcgZeYPEdmKGofqu2vH9UCmtsoHbtS94R2PaZJOB5NV9fvL07O5cXwRcbVLxBD2xL9BeE5JjtMM8iZXdS12o+cJhIiPe4ikjGh1sq4E6Eeq+nERXhtKtoDZxiJ2yb5q4R4WB4lPaxDgDcdGFepzTdH8rlqOuYqbvYS5qBK4E5qcb0hQW3flbUGwk9T0uDhhYjtu332uSG1JP0uBUVqcBMelgkZRlULig6DakeBT94VV0Q5Tg6iN3cRBLXHCXgl0nDMMSmW/uQWIQLrAbOrOf6f0dWSWSjsfBPgC80G9bHte+InO913N8NgvyQVnGQSyrwGQYRQh6oEyVQOQqqNyb2oXp9lz4Zc3vsUgDsCA21i2DCSI3onBbz95hSjLr8sVcG81sidnPHEx5E+JafLApZebv1iycpE+CcgqywjAVmxXT3lhPNxpeVuX3HPa6Em0/S1cAh0rCovRKHJ3lmVkOCF2ZD6DRQlb8BwG8XKFvwt8nLyAs+0ra4SEEHAHTjiKqhIl1mw9XU1UkHskJ5cV0eTaxqTkbEf0wWd/NjoSppJFYpWdsr8Yn1EeUUyPLb63E97zciPgBD+tvayTGIjhnjpzVRZ8yvBzTddPI0ZB/eeNB8XrhMeX9/XlJVCIve50CF6/57IgK008swLoyFljEvaUECKVcjhCSvRQ+XsszAZGQ7QvlXPPl5pQ3OnCEdRKYa1mS9ZBHRjEsaea0Yzj+V1yM8uMZ2siN7e4/sHXEBj++RTsaqDkMi4WZ4q5wysnZ8orbwqZWEook9w6MGvdVn0tl57PyHgniuFWUOD/ynTkeJ1qfTIbaNmRHajRXD3lxuwuhsK46f9
 zG9+Z2IZ
 pRDNlYVidrQvlr2No5CVTb1MRoNxhY1a2/eqP0zHKRr3T/oAZaytTEqezW1rPIe547EURNSjezXrzpXLlFN2OHb0geAFywske7v6wruHQtWYkcObRKjwGNPMreOs/K9lkeGZC/NJAeNitwkzS8zBdfD/dI5Ilz+2SH5X1Vlq6D5VE8OJSLoXJiH8UURdaQu7q9VhkqgM/LYO6iVpqjbjEIpjpwSXJQccpiB68ipKuC75jDmY7QAnYEfEjzJ+j6aUFW78ytZF3H0vuT5J5AkUR7cmOUeRrtRNcihjrzn/6gm/2HCQDeReh+425fAyiDyoFwXto8oiMFlkvhAPtoOuV2f9bUdDU6Xkm8lDEmfrhTZY1IejW3KCk5mlheq+DVS6Jz9GERyvBbxTRaUE0UWB9tDT/r4QpeKKGoLOiGSK2uQR30PSfiAPzJdRmU6UsYMdDpugmTJhP6L3dkcNWeg8GDN4HqQ4P9NOtuPhltaT+GOFHF0sECjeGMqKLtxRnHsr+9wNtX9LONMt0fbubYb+Kybhq8b3+EHLC4Sz9fXuhzRJFLnu0kp6cf1AKFtqpgWlELgzcCQVrpGR2C2aM2GHLpCtR6HzU7ratjxnfIp8qXwWOH2CnlnMuZog/+tDy8i0b1+xtYuHoWZ2C4qoAhN9m3W9MXUZTNgfe/Wt5PjFBzbe8g3Pv3wVoY5yBtzDYTo+oQeSVoUoU3pDVBuCJJLg7/l9YlKeDfG6lNPQj7osHPfG7P1cIhoa/ypChNPFs/l+vZUZSyTW8xI3+Pxz1tp0UdMHZfw==
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

This leads to incorrect reclaim behavior. Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
is reached. After reclaimation attemps, a subsequent retry may
successfully charge memcg->memsw but fail on the memcg->memory charge.
In this case, swapping should be permitted, but the carried-over state
prevents it.

Fix by moving the initialization of 'reclaim_options' inside the
retry loop, ensuring a clean state for every reclaim attempt.

Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
---
v3:
- Corrected the Fixes tag (Yosry).

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


