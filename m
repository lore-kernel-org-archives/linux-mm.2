Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C1DFED9E9
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B047E6B00A7; Tue, 17 Mar 2026 19:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DC66B00A9; Tue, 17 Mar 2026 19:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4756B00AA; Tue, 17 Mar 2026 19:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 671C26B00A7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:07:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06A0D58C3F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:30 +0000 (UTC)
X-FDA: 84557093460.29.7C3CD46
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7BAD8100016
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cCoBewV4;
	spf=pass (imf05.hostedemail.com: domain of 3rt65aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rt65aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773788848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sLkrHizaGZBp890B7+nzygesvVkoY/tFf4Qx2iHrc0=;
	b=AD8cnxlC38f9bLK1BZmT7jBl5LUiaqSSBeaxsHLhM696uhwkoulsaOl3L16QzyWJGf0K35
	b/gppT1KMOBheOVQoh2l/pkmK6nCk03mMWjkNZVofv1/2dZpONiEtqj7ka7S/t9kRoBT10
	BoShYSKNqNDVcIF4KE3oatLXVYThQvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cCoBewV4;
	spf=pass (imf05.hostedemail.com: domain of 3rt65aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rt65aQgKCKcIPUNQPHVNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773788848; a=rsa-sha256;
	cv=none;
	b=jlneCRrL80HHiQu0Jy+a7HquKjhBOjP4FoUDmOHw8b3F7F5VqatN1is/T8mTzyx64KnI2k
	V6Daz5g6TCnLFBtbewdN7NHsDn4xXR0EZrnHVNl7pPMZKBdJahQlKmxIG83X6rQUz/Y3Xn
	WhA9+bGa0BxEj6qo0uSqMt2/pRK1htk=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-128d59030d0so2037839c88.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773788847; x=1774393647; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2sLkrHizaGZBp890B7+nzygesvVkoY/tFf4Qx2iHrc0=;
        b=cCoBewV4uIcJ3yda3PsqdsvtXCKu8lJICafF2Qk6N7CjeB0dUVXX7dSze/Q2X1NAZr
         YcFb08Nsu84P7gKuZ627lxj8nc/WKzIVdBViHgmwHp0LViHDVq55mZuXDKU55NEKTegF
         kJT/rV23wMU0Cb5VYl2cV/raS1E5fWZ9uwpZfgf78DBru1Z2XjznVM3/ZSXES9r/8qob
         Fbm99Wku8sGgJmMt7ajy65yoIltCtBZ+QgdjGu3dieO8v8kDWFXoOmRJcXqobjE62QAJ
         FDHqzkRiQEAfavZk6onXTcZH9mnfpCmnIXCGKMaAsWjbSBPE6pQsiBih/NA3b1HWOsGK
         RuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788847; x=1774393647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sLkrHizaGZBp890B7+nzygesvVkoY/tFf4Qx2iHrc0=;
        b=id9W2FJdeAdqB4RWzNX37/gCsdqrgy4UixW28CjpUrbLCF4Uli+w11o0xIwGVeDvSZ
         D1EfIcfxY2JprmJ7IpJQoTEA41CUC8dkY5ZXhAfhChjC8N2R/XVyuHxP6zwmLArW/XeV
         Vv41djm9eoF0KALwmWYxCMsAIWWvnXJXFZjfj3a5JOx2cAg9Orck825Ou/ez/cTlxjkr
         B3qVG9jBakTrGTEiPnjejDDNg100hb/wjJyuo/7MLSNnBjq7zh9vyySjNSjcWI5TbHa3
         BqvgUBHFEEg0w317JhtafdyflM7ogfXLwPeSLaQACuElvoJoSHAfGvn3OrRqVZFlSZtY
         qh1A==
X-Gm-Message-State: AOJu0YwFu/suHPJ9xdfZVVywNaPKf3FShjNmDsJ8YHncYA1Oz3FqPG0u
	QDucSPwqqdtPOnR9VlXLb34S5Zg0Mos7XaSZcJsT4OB/7t6dLXUeyqeTlsCr/xtH234VFVvq1RA
	/GE7hD7fq0/bqjO0mgCkGcZQ4f0mFOVZwpKYiUtypbaQjE/V+Bi7JDptcTgCLp+mqiZimC3V3eR
	PovDpgiB9bxJVWw4182Gs362RCTwd+0fL5f3veg1Xqaw==
X-Received: from dlbrn2.prod.google.com ([2002:a05:7022:1502:b0:128:d185:c6ff])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2218:b0:119:e569:fb9b with SMTP id a92af1059eb24-129a7111483mr694227c88.10.1773788846767;
 Tue, 17 Mar 2026 16:07:26 -0700 (PDT)
Date: Tue, 17 Mar 2026 23:07:02 +0000
In-Reply-To: <20260317230720.990329-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260317230720.990329-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317230720.990329-4-bingjiao@google.com>
Subject: [PATCH 3/3] mm/vmscan: add demote= option to proactive reclaim
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
X-Rspamd-Queue-Id: 7BAD8100016
X-Rspamd-Server: rspam07
X-Stat-Signature: mnewdntmg8bip6wpag7rh7pokhfca8ms
X-Rspam-User: 
X-HE-Tag: 1773788848-828517
X-HE-Meta: U2FsdGVkX1/fe8QreS1xr/hUxd+DUdPwU54X0aclBW5EPXJvyEZnllL355eXw8NIe54PQBGxQmqw69xZCbomL+J9MMaDiiOIMsojy7/o5kaFVQd3uXmWqGLpvN7Mci7IsW/XFuRiYbeyIJZrouYkHUR+3DhR5GSBUYnOOvdpuKfSDBiGTu9Syq1iSd2lKGe9aL5Jdc13idT8B8tVD4BDlksd6xoV5pneYzMfQryXLlxqGzeCm3oE1NPzyhsR5iF1KfgQKct0r3q7c1XVOuE6IEbhuamegx5i7wvc/nFyfVWpRmn3aZlbZLeHQRLYJvvj1Y6iQZKe2B/YhotvshCXAv7sivwtnDC3xHx6EEhRnj91+x6KcodeRcIFeIM1RGf2pGwnxLjzeFdkmrVwDGn7Uvv2OKec4BAIvPw1hacNDjthK0sGKlM9CsGwHne0Q+w63XRdTulgbcU5uq9v8RE0d3K5avA4pWci8durQ4Ce5YtR1YbPaLN71jozI+uOS9oQiGWzaIT3wYKkaBiU53sjTwQLsN8GoGLAe3S4o3MBzPQmHB0FaBFgy/EGPKurNyWU/2bgKeuNReFLOi+kuUM9tgrdRfmPInlAWfVY85QWmi8hm7W0xNyC/67JpxkvMipiy8Xe0HU7WOfONOH2A1jo5SKqqo3G5tKw7W2VJ/dbYU7EPJixgn76IdURclilNAVBNf1P8X59rX0LHT1jD5MGs85aJb/fMeU8Dz2ycQO2pRXJcBU2duAOIsLW8ScTiAMQpffeVGtweiYGsUbEs3kgwPngY707zoLyh5DwU1gd/9PBzN1SpDetLhVHKMPYsvXaK6VGY4Zpb4ekGn/diU8HrgQ1XZodJYZVfhfwqmtD/kQ1anZ9wYDKyr/5dnrTwGTbodkukmbuvEWOh0mlYYxEzfC5oa6oAWN+wc4+jgxJgd4rn2CcKp9Sls2n+nVq3pz15/q945q6Xo8SYiS/QYm
 eOJ0x+OU
 QRcREwNANLDBnCXPuNeivTyy/US4ox80alGrP6MYdFLL+rHq+xGENf5BLOzdeCkTYYcmqZQp8920iFuk9lD+DWS88vhe+UdyoXO62M1V9O+jUupwLvI4azoDc4YGIWOjYVxieDcq2zj5TxYKJ+sYAdCdnoHk9B6DEK6MReJQ3stAkK2zhanXw24RTgSVSg9GNKEILP79AD/uRBbYYjQNZQllpJhdEpI15JBJ4QjxBm8bha4AhAkCNPXIRf2cavUufTHo81AK70P2Sf5nx8jZLdDcWEjaj0Idf7PRYMujvzSM46sgl8xPGAjzOJnh0HNvQntri77K+ZwcHrOXznfZJB9dVG+Lr9Srd7TpJvD3vmygxG717vRUDJ6oS5nywyDiz1Mw3LMxR8nDpBeNt83XUvilCIMXFKQTWvGpjZvtUxJC7GCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In tiered-memory systems, proactive memory reclaim (via the cgroup
memory.reclaim interface) can demote pages to a lower memory tier
before eventually reclaiming them to swap.

Add a 'demote=%u' option to memory.reclaim to allow users to control
this behavior. Setting 'demote=1' enables demotion, while 'demote=0'
disables it. By default, demote is disabled (0).

This change ensures that proactive reclaim behaves consistently with
cgroup limit-based reclaim (e.g., memory.high), where the goal is
typically to reduce the overall memory footprint rather than migrating
it to slower tiers.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7a8617ba1748..80194270fa2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7878,11 +7878,13 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_ALLOW_DEMOTION,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_ALLOW_DEMOTION, "demote=%u"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };

@@ -7890,6 +7892,7 @@ int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat)
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned int allow_demotion = 0;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
 	char *old_buf, *start;
@@ -7922,6 +7925,10 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_ALLOW_DEMOTION:
+			if (match_uint(&args[0], &allow_demotion))
+				return -EINVAL;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -7947,6 +7954,8 @@ int user_proactive_reclaim(char *buf,

 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
+			if (!allow_demotion)
+				reclaim_options |= MEMCG_RECLAIM_NO_DEMOTION;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
@@ -7962,6 +7971,7 @@ int user_proactive_reclaim(char *buf,
 				.may_unmap = 1,
 				.may_swap = 1,
 				.proactive = 1,
+				.no_demotion = !(allow_demotion),
 			};

 			if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED,
--
2.53.0.851.ga537e3e6e9-goog


