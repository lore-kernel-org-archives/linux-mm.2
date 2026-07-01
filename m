Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BBFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCD56B00B7; Wed,  1 Jul 2026 10:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D2C6B00BA; Wed,  1 Jul 2026 10:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936566B00BB; Wed,  1 Jul 2026 10:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661E06B00B7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:07:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E087F1A03D3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:07:32 +0000 (UTC)
X-FDA: 84940385544.03.AA47F65
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id B8A9520010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:07:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=xqg9FDvO;
	dmarc=pass (policy=none) header.from=snu.ac.kr;
	spf=pass (imf13.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.214.174 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914851;
	b=pLEkGm3WU6KIEAIymO21bXsAyBun7lbFVL1fUUnCX0WeVX2UxM/ufvRIexk1HMoYvVk5X2
	PeVLMlitf7Da3aSkcnsQadR5wQ3ga6lNtdp4fjlYAEJw9xENT7ur9OFy1o/4PWMSiVeYGA
	wjI9aiy4ydQvNzRfq508KXHE7oO0x1Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZxgN1oUx6Pz7v7TGz+X3A2giflOx86wktdE36WmTNHU=;
	b=IVLx497TrH3UKoeqREkHw7934QFwXdM339X8LtlUe4qBbGipSF2IsFXoDIsPZ8yJP186OG
	us451z8ldXv7QUiDOHmZaAAkAe8LdMzYNecg1SBPu6DOOrcVF20yG8WA3MU/EqbfwLSLV3
	nGvUUHz+y+B/NpR9Vkq0Y8FlgT5HTV8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=xqg9FDvO;
	dmarc=pass (policy=none) header.from=snu.ac.kr;
	spf=pass (imf13.hostedemail.com: domain of hsj0512@snu.ac.kr designates 209.85.214.174 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c9f44ddf26so3132505ad.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1782914848; x=1783519648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxgN1oUx6Pz7v7TGz+X3A2giflOx86wktdE36WmTNHU=;
        b=xqg9FDvOW56D2hsWu2YURxEfPL/YkyX/F5wpnrygjRsqjqM3eV6It1yYKkp+LtC4QL
         65qPn18+cPNJBFY9BdFWAu5+Vy3awohFnRvbBrtm5HtLsNGTuQmHZNN/r9AXARImltb2
         12n+SSn58G+E9loAoMPC+psWBdd2B05EDNsmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782914848; x=1783519648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxgN1oUx6Pz7v7TGz+X3A2giflOx86wktdE36WmTNHU=;
        b=SuWeYvy/5uGgptrfs7HE8TLamIyKvH4K6agdl4AOhcPam+RyPU0TMkUodoji7U+4bG
         4YVe/RmpvTPmqhHsnpVH6u7zS/l7szaJI/DxJ5N+6ikl+jrn4iuBi3VUA5BEGYujaueS
         H+RA1c5Ugpn/bNPf8MerZoZafpAAzaq7krDH5Y3kkTqh3UJVX0gXAt4jAeBWxXq2kIRt
         Q/cmUVZUE3hrrkH5yH0cfOT3EbQG2txXH1OfP/GGc1nnaOvljCJ8y/I8AtLb+LX40RHH
         W3lDLlAH7UczbYNtakEA6CeCma+nd+cx8P9jds+A2r05ktodqhnsoovMVs6einyoxHUQ
         b/tg==
X-Forwarded-Encrypted: i=1; AHgh+Rrepr+Ntohnu4/h4hzU7yTmw763yKvxOFvVjNTEnJQhSNgmCn7Us4TqMAOY0OYwKrV7BQ9N9++blw==@kvack.org
X-Gm-Message-State: AOJu0YxwQKRBORPRkQ1tzAyi0rCrnR7BEmRcs8mpotomboesgU0CAqAQ
	bpDgD8IQNg2zWe1nRZerg/I/ri85Yg0g0BxqkX5Lxo8IC2hKfXP63oioDwY/J1BOVCc=
X-Gm-Gg: AfdE7cn0M27/V6m+42mEpI1F+K76vaDgbHfW8G+KjL9/3DAtfk3tHB+jEk/r97kn0q2
	+wVA9CP6G5sBuzPvhI3lL9Zdd33nPm+ZwqQ54ufaaJF+Oaf9P4dX8EFZO6X9VUDy404fsnx1DRZ
	5RAoRUi6qVgGos8FacvGwstG5Ma55/YUGsBVLDWwJZg+7KgDP3Ty9nGEUkvXMb7/MkQLyKs6cZ9
	tjMlA56kNBewumm3+xdgZdr063BXBX3bnUseIJ5pgJNgeSlgoFS5iVUldV1KEk8w+xL800CkH2U
	M23N7YG7V4nCYD9BFGj5/FC7dKFyRQmi9CBjIb+7h58tLRPIELhxvNw/xLKdhTZ4nOKqCbqHfUz
	zIbiYZywW8D/T51h98eRYmUubpeXfDJp2HR9JvVYJAd4pX4NtltGoXIgJ5OHdYc/MnjT2I9Wb4A
	V2Id3S55IEoz4QSAHGsYm7a6zVwuShcRYJsUE=
X-Received: by 2002:a17:903:286:b0:2c9:97a7:b1ea with SMTP id d9443c01a7336-2ca7e924ae6mr19926615ad.41.1782914847937;
        Wed, 01 Jul 2026 07:07:27 -0700 (PDT)
Received: from localhost.localdomain ([59.29.41.108])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca382a3863sm32525705ad.57.2026.07.01.07.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:07:27 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] slab: remove unused SL_CPU slab_stat_type
Date: Wed,  1 Jul 2026 14:06:33 +0000
Message-ID: <20260701140634.71608-1-hsj0512@snu.ac.kr>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8A9520010
X-Rspam-User: 
X-Stat-Signature: 3wmpz7ihgmgk1e8yrzz6t7p6sbu5hgqp
X-HE-Tag: 1782914849-911927
X-HE-Meta: U2FsdGVkX1/hiCRdlTsln5N/cMjRf3sydfe1HI3O46DsXqLFKRIclJw/FAlkQhYuWbzd0x68WO8y4uNwyyk9cZatnjRijVN0sBLKNyqBBN0dYjHNpdtc1aRaY0h2xDChmwlbgMkZt/RrXDhAuTnWV+xhanSdD7Xd8zqZq6t5T68smUQJWwOuwPofppb2j5S2UChULby+vPh6uhiGBj5KD1R8wUgaw+BloOgGpjje4q3VsMWwEqAyaNzo14BMxZGbb9h87X8vxmLMjmJNoVzP6YO2LmowIBwEUqFSvmS8R6vcLq0un9b1QcTvKUS6JrOGNCs0FE0SJgu/w4mThEG8mAZdxQxIpwXgbUf278dUHaufVFulCLCsqsuf9Pa3xDrEBdgxp8XxQZ7AIcWFQOADqmkheBgdLH4CqTICphBKyNVgRGZf1baqWCcYYvkzfu9BXy/UX/VwLtRfZUc9spVvUhzdlpHCLr8ooctPCiuC8mLI4XG9FtJSbGa/QNleDg7tGptFSb30vkER3X76WJGQoTPVvYVgAhfuogy54Ur7ZXyi8Re7yz9LXoj5zBDvY66GD1lm69IPyGofE81EbE1CXFL61kc+j7BM87AaWdCdER5lrQD50ec4goI/bE9nmQlx3huLqc3K1KEIVtRKFUFHqurkoYjL+1KRVshPHMy0iVX20sEyKF/VfQ80ccW/xQ+7FT860bGB+NAe/QcKWHbflVEFyJsvoitNVdw1t05AH1g6/SkQXk6hLJI7Wc1jQhLv+ISqTwFtzF9+PcTANoen/ITA2MODfY1jKSW4itfFgfoim8lb2LiZE7+rwfrPw0FNb0H7Nyz2yXakeVhRHYetU4TOj2o4FNAQey5NIfWzxYW1JC1Cjyq3pZowslxgRBnz7n5+EyAYAyWqw9kqs3UTSxAxeAwsyQFHpRajqDRLmFNlUsi+1uayQ6dP0PvfclkGhUwUo+LMIrRVSPdOCDM
 gopS18se
 GhkQZ/aPStY1rTuccwROTMANO/tA05aW+NljEkkPQKqcG5inrfyY1DTcSzPBNuUviVlQOdIzgRLAcdqioobLrCQ0okWCPhQs9yd6BqDdnTRewCWgPnu9CkFE+mvgdRvblV1jrsatvrEB0s+oUJq+O4NcqSGlzFwim4XnMsiGVNXDqFzs0zNFk1/5WWgEXu7YyW8q1iTeOaK7OscEwjnTVHrjOZt4EmtMHhh3YgVEF91zKrTc1LdfPtxw135j77SfuuBe50AVTIYCF61q3g+F/d9jhkMGJIibQpfDiwFM8l7sRN0BjlPRrwJU8sqWa2r68vzHFhxofPvBPkIoU5WAoNtX/0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the removal of the per-cpu slab in commit 32c894c7274b ("slab:
remove struct kmem_cache_cpu"), show_slab_objects() no longer has a
branch handling SO_CPU, so cpu_slabs_show() always produces "0".

Emit "0\n" directly instead, matching the sibling cpu_partial and
slabs_cpu_partial stubs, and remove the now-unused SO_CPU macro and
SL_CPU enum value.

No functional change intended; the cpu_slabs sysfs attribute continues
to read 0.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..f2eb60ce0d23 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8992,14 +8992,12 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
 enum slab_stat_type {
 	SL_ALL,			/* All slabs */
 	SL_PARTIAL,		/* Only partially allocated slabs */
-	SL_CPU,			/* Only slabs used for cpu caches */
 	SL_OBJECTS,		/* Determine allocated objects not slabs */
 	SL_TOTAL		/* Determine object capacity not slabs */
 };
 
 #define SO_ALL		(1 << SL_ALL)
 #define SO_PARTIAL	(1 << SL_PARTIAL)
-#define SO_CPU		(1 << SL_CPU)
 #define SO_OBJECTS	(1 << SL_OBJECTS)
 #define SO_TOTAL	(1 << SL_TOTAL)
 
@@ -9188,7 +9186,7 @@ SLAB_ATTR_RO(partial);
 
 static ssize_t cpu_slabs_show(struct kmem_cache *s, char *buf)
 {
-	return show_slab_objects(s, buf, SO_CPU);
+	return sysfs_emit(buf, "0\n");
 }
 SLAB_ATTR_RO(cpu_slabs);
 
-- 
2.43.0


