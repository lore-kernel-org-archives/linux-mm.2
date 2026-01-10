Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C496DD277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E966B0088; Fri,  9 Jan 2026 22:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D469F6B0089; Fri,  9 Jan 2026 22:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C733B6B008A; Fri,  9 Jan 2026 22:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B77036B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:00:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A31F1611CE
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:00:41 +0000 (UTC)
X-FDA: 84314551482.16.7AF1019
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8848320002
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:00:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zO3psGo8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 31cBhaQgKCDANUZSVUMaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=31cBhaQgKCDANUZSVUMaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768014039; a=rsa-sha256;
	cv=none;
	b=z2fac9+/+d0GGGq+EfzshtXNoPix8e6+iFMy/muGa1+B6xSunrH7BwNhuEYe7miyXdsMKp
	ZmcnWRaUKJhbnd4XH+15TD0+G9IP5vSbfT5cBW1GiiC+nRbarzlIGAw11SMEf09yzEotD9
	1UygsAacG/v1bpGksa1PpzZH56DTj+Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zO3psGo8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 31cBhaQgKCDANUZSVUMaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--bingjiao.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=31cBhaQgKCDANUZSVUMaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768014039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
	b=GgJ/YgIEpVrGV3pXvS8FvwBzcR+672odKoRCRYA+GsD4stCN0Lvj8Pg9ho6IBuqGMVkzyy
	rYVlPT4exRBkzXF/UlgjvHoLC0l+YdkyVRHb43g12fxqz4aqHgWerz3NW03VkAkVkDxDPq
	huuInIRaBSwizFnGwK7BMwF1W4sWu4c=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b0751d8de7so6342373eec.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 19:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768014038; x=1768618838; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
        b=zO3psGo8SD1hHKoLxRyfBq1G+BYOwXbzkzknK/qABbfziEunz49G4ItxghrRGaOEHu
         KnVvhiTbJFIn811e9cPOjqee/GpZsGgVXr+UOjsSe057oAtR3IFgrhC+6zeHZ4ii3aIC
         LYvv7jiOGcORCB+tmeFLZfz/LeM6WzvyfOgb49DzRnPdqaeJWozF+XsRxkYkj16cbDxQ
         cjY19B3npzC+fyJntr6r0Hcs7dJpiSVFtWVXTPZUbsbM33Yemh79yk+IEqUsspRB97gb
         FugXeCkRvWuDiE8C44DwwZvcExi7oYnLxIsNV3IsarAYrgb7e83Wyzi5LJj2DSMkg5Mx
         SztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768014038; x=1768618838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWx5XWplFY3ByCh+tcD17lzi/sG7paYpqmK7A4jiVOY=;
        b=UVRWK38IAu0bUuDVqeJdwGqU+YufIRhyeKhpfWicV7BtUlh6xF2kQfDCorqMV7eifI
         HqHWIB+VkHe0FJCes4TEbsFNx4Wttrtts0NcX2kJfNr40OswrYhEwCwK1DQ/W/wHjdR3
         iHaWsPtVm1fmPq8N41rm8IQnc/W31cA8lB1SVaYU1P3F2knn7GHZdvue4V8wBTSIHQoZ
         UiP2cAyD5wuVxwVbo7IGK77BUUk8vcK07FhloQJuB373lLXSur6eK2RrsWrmrCxRdXKN
         gSguhIMz9QyQZhCkg58k8YDbBMLE6cpM2VZUAAX1wlNFXh7C+E0iQ0Z9ZGxQ8xAyq3XV
         l5AA==
X-Gm-Message-State: AOJu0YwABRLK7tHHi+YCgXSTu9uV/j6nNQCgW5aze9djxn84hB05Hpz0
	efR9tZuRrWHuyGEEQKn1vn9YYMnf/9++9it8SPlHodQScZXYaBSPsCSacdY3lJHP6bU5lDhZOB/
	RKz/OjG9DBFpuJw==
X-Google-Smtp-Source: AGHT+IEAq+bTdjWY/00RB3pcXpnEYNJyZdefPIvbvqf35DjejKkSYr2AiWzw6bJlVAaqKvidRWxC7rfT5XimzQ==
X-Received: from dyjl17.prod.google.com ([2002:a05:7300:2691:b0:2ac:1eee:fda8])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:6505:b0:2ae:5d5e:9b1c with SMTP id 5a478bee46e88-2b17d1fb255mr11488212eec.2.1768014037941;
 Fri, 09 Jan 2026 19:00:37 -0800 (PST)
Date: Sat, 10 Jan 2026 03:00:25 +0000
In-Reply-To: <20260108033248.2791579-3-bingjiao@google.com>
Mime-Version: 1.0
References: <20260108033248.2791579-3-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260110030036.430833-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: fix uninitialized variable in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, gourry@gourry.net, longman@redhat.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	joshua.hahnjy@gmail.com, sj@kernel.org, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8848320002
X-Stat-Signature: znowa7wfjbju57e7ggecmaop694ghrnc
X-Rspam-User: 
X-HE-Tag: 1768014039-521168
X-HE-Meta: U2FsdGVkX18KLylXiH7sGLyNUADUT9iAzv1w2CFpC5q3sVW/BFdMh8DDVogjen0jyN6Zy0jk9fjECQ4qy877j2hnWxYaJeNPgwYl3AZPSTX73Ty9pYRe/ERTpRgM++j+eZGvZ6W+mFqQTJXsNJx9xYEbvnf5NN019VjVkftslcdVzosegn0QwNzcKd9m49KYJXWwWs7Dqy3A/4+b28AdOtVJr+qw9vXEWkfdnCtoXCqzYR+8xZ8n5HkLxG58iLwlHYKOrx5j1xxxDb/aj3HTTN8Xw9HlWmxw/mv7WCQ+7r5izb9KjXxYlthuPIoEoEol4LgM5KjNnwKBXjWAPcDgZg0soS+nfdjubn5o8t0vUcHSa2GYkmtPMFD5iIPJvbK58kVxMm4AO57lUw0dqqB6+Tb8eXdR6n0XFaHKjRv+9yGmDMNHUiWxLk1nTkD+R+Wv9actRakOadOOOpE4JQ/JOln0jKMltKOK2PdNOPs9C1HcqksAZ4A43i0LAp/Zdyo41RqzjsnNrdQ+D1IfDHKd7rTOoCvuFcNjdBMd98CeYiABx1GgB91D3SRTTsDvULFwlaF1LuJSMEX2bU9VEl8TrAtXRQPjEqqayZ/Hl6AZ0VFcFi/fXOim7HiH5ozxn9WYCI/CWIGsCaqRVu72XGt7SN5uvo7ViIQOVC0ifKuBoU2MZf//mFuUtD0bh6/Pcq2J/+kaHQ0cAufTaCSgTyJY2p2SBQ2emjJFLA99FJL7wboCRbVgWOWWxdAQ7kAZCSyOJoVuWypuWQOqlQNMW5ThKmdfDo9U74yRivfP8HAxhUR5n5hpmq3CPBvEijYa808ADxLN3RTpY9+NPtHu7jTPt38LWujl+tAdwDeUbfj7ZnO0F2DSK3UNKi/52fFJj+dC/IypwAdITCeDJaZaC4lhpzNScAcHd7ZtsbFSHe4wvWP9ONe07linED5X86dPiW+qKSo9NQn3Z6yWDRWVsIF
 V3n9S/7E
 MYN/gLderQrOpkFpRG73oqVAWb1oV6R6xttLNcJzj8RAua8PTFVffq7I3vtNjrTlTRQZOP1aUkgUPML3WGbJcypx0olwe5z89mI1uZL9oLv+ARpb4Q27p/VCy/DZe4wJu09EpIUnJUUhc7P85iOTWUyS3o1qC1AKMp1lO5FFW9u9LbBIyVMfU2KYtAGt2nwhmPuyIr904XEyZs7Qq5l3RZR30MYozeS0wM2msboOb67Kh7BG8cNupWfQS73oRbKRmzZeJSmC8Ut+XJLX/wslliEDHOsJjjiD5lTuic6Qtoayr5fO/pCJcB+zTvzZfHDV/EbStzWTaCh/lX6bmVzKzOv3hOECOc7wWqPUsSXF87wjWLTbjc9MWmQp/yfX10BYtJtiVLMYNeytUaaSseFCbF9QBSSYZFZmXIluKIsjEAal0wUY2c8HDd+4/0Q42pu635a1NEbao9udhg72VrfN73FRP+FOmydp6OYLT5cr8K3o6HA6qdpReUWwczqTKKnMLseBcoia1Dv+UqflNJwXpcrm+HvSg8Oh+bI8bz4K1WuKS6azdMZ26yj1BbWidW4iq3ulb2JIk30nDeNTlD321tugOf2Rtso9F1JLuQpPd6wpbA55GC0/zs4D8F2kN9SsWSCWfV1U70t2xR6A1vdV6hEzpIpklWix8RL7D/VBhFtV4iDAKj4MAxRnePc7ggq/2gARE+l6wl/K2uwtiKb8dEXgDMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
demote_folio_list()") refactored the selection logic for demotion target
nodes. However, it removed the initial assignment of 'target_nid' while
leaving a premature check for 'NUMA_NO_NODE' in place.

Since 'target_nid' is now assigned further down in the function based on
preferred and allowed node masks, the initial check at line 1046 is
redundant.

Remove the redundant check to resolve the compiler warning.

Link: https://lkml.kernel.org/r/20260109055937.3739860-1-bingjiao@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---

Hi Andrew,

Sorry for bother you again in my patch series.

There is a broken commit in mm-new branch, which is introduced by this
patch series, Commit d92027a5f30a6c ("mm/vmscan: select the closest
preferred node in demote_folio_list()").

As the broken commit is currently only in *mm-new*, could you please
squash the fix into the broken commit before it is pulled into
the mainline?

Thanks for your time!

Best regards,
Bing

---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 213ee75b3306..590ab3ec1998 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1044,10 +1044,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
--
2.52.0.457.g6b5491de43-goog


