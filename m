Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BE0CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7246B0088; Wed, 30 Sep 2026 07:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378556B008A; Wed, 30 Sep 2026 07:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2668E6B0093; Wed, 30 Sep 2026 07:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0EF46B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:58:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 889621C26FA
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:58:25 +0000 (UTC)
X-FDA: 85270280970.01.ADE3C1F
Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5F20160008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:58:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cE4NCztm;
	spf=pass (imf08.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.73 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790769503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HhTlHttBfOfSCYbgzOBqnm1PlGqLGY0jClNl8O2m0Co=;
	b=feRC7yAX80qcp0RLEUGIf+mvhcf5w6LtLAqOiXVrJSlEKvPoC7hExDAnajmWuAmtmINRTD
	YDnKNpAQmy5MqgZctvc303aGTBui/EyiP/NOzfQvjJ3uZBdj8qW+nkL239XpJW2UARYIFQ
	+31PwKl4x6nvP5bPNavhvrVBSdE40ic=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cE4NCztm;
	spf=pass (imf08.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.73 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790769503;
	b=UU9+iRRi1Vck/7c1vZX8B62404V58YDDIDHy1X9PAZMFNHT+f8MOXwh+bkS0nRAyJYwxnG
	5LZH9A6TcROcyu7awkwgScrLlocf4FXYG5kDYyEuInX+Ercmfzq+02PxCVHoe1SDWHpIpu
	+OdJo7f70wIuGKr6o1XTbdYNKzKJA1U=
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-48afbc2b18bso488139f8f.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790769502; x=1791374302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HhTlHttBfOfSCYbgzOBqnm1PlGqLGY0jClNl8O2m0Co=;
        b=cE4NCztm0utn26ISVDLhuTQOrpdyJo00CHhdWW+e8LpjH+DIg+eXoWVdpMybyAzy2z
         InNr1ygKYMsq/pXzgDiE3Z/kMMczuSfep+RQympCK9i5gB4zU0+MGkvjhPV5GU0K34rl
         h5QU8uViUssoCZKxMvnxz+q15DpuK5h98KW2MEjP5xKl3z2yvD1hnylGkYpGG2dOZezK
         DTmEtHKmGaZYDsZa2VMFmoBcSv59XdhKPCsSYymtkhmqt51t50pSxAowt/xYw9+vMhcj
         3UNM+iDM7LhJHblRNOYFxWtvzNQcnBL5QGXomDLFM0pRiR78QCeQOnzmwbVjuKVesu8n
         AHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790769502; x=1791374302;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HhTlHttBfOfSCYbgzOBqnm1PlGqLGY0jClNl8O2m0Co=;
        b=g5kCTXnfsDxST4gz4eHaa7yOhjKzWKKwxY6mu7x4Q+rLkZvwLCXBM1N0EFnxCDGecK
         LCT7+okGElcOs3jewW4/r5Yf1JHuqiN5RDPJIw82H8PPf3L6XhknhD+wfShLtjQVkq6c
         Q5F5hImvyws3EqTHBsBG1lOuDQuqvJlljxGHCo6DbUTNtlOI9h3jcnaIbGTPrjA+Ourr
         Sqtc5YuMMU0pIBmSahMaDysgG4CGdwZpuwwErxLj5J/e18Jr3SLmeW8L7jvVmdNiw5QP
         PBGw94/mYl3W6EAu22LOcyRU5SSUpxm31byI+sR/FDX+62P10MY8/f2EXOJqH3KtTmxv
         JiLw==
X-Forwarded-Encrypted: i=1; AKwUvBwuLiNF8ajZL2LkeOSY1h0ttvO+MYmWmj6o+RO//WKMCUYp7hQY0zlz4IixGxQMwxpY70Xyf0vLEw==@kvack.org
X-Gm-Message-State: AFq9FYJDldknFFuaSgzpRHWUhW/qtaPafI+06P+TxGA3B3uQKzq2OJLj
	NwCNVnwNcs80Dwatx9cQUDW1cqWq57nGqMRezxN0m9rYnTvbGEpfaCNJ
X-Gm-Gg: AYBFou0hFNrgvTxw3oKaQeXhjfsd8MKZcwNzaOIqo15kO7t71ECVhNxo1vMLfeAwyS6
	hUyZ2dgJ57h9LMYmv0r6HGX719wd/jjEtz7jcCnvnPCAtPPE5Bnlg/MTHtJj5zr9tAVucV1e5ce
	ngMM1pk5bLx3NcWzwh7vqBR0K9VmughBVLIfKL/f6k9w1kBaTn9/e7p+NavRpZQBuHw/oIqXxyc
	KJRMdD5Yf2ARF/UCGlTR3MFZyZaJLFEbNG9uiLBlSCong8laxzZghCbAzt4r9umfbn2ryUzMXI6
	hhOBU4/FHME33o6EYX/l6wO6RYrmSJ4x5YUpQo1PS1Zy7OCMGiATCR4YbZSCVCiYMwJP95qV+CZ
	3IK4q9iH8aOonP+2OdMAFxv0AooN8Bx4AuF4zCpFsARZJVwOLsDf00RrUEBn9E33kQppaWRxbPu
	mwgk0UQlO5Y+it+WQn9qMjaO6ONtHdX+4/htNYRDsPjmz8Wi/uJ2TrUw+ZeiS10I/suJq2H8dfh
	MY7onYDLMaWbpSNadjLME1obKsgn/3TfvkE9k2PA1nHfsYcLBUSj2DsTs4zF6oOqzB42/Zz+Cwz
	KABDh9iOWZxirZ2JjupXrIT5WnZEcWboAg==
X-Received: by 2002:a05:6000:2888:b0:48a:f486:2f4b with SMTP id ffacd0b85a97d-48b024ea6dbmr2815254f8f.19.1790769502098;
        Wed, 30 Sep 2026 04:58:22 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-220-212.cable.dynamic.surfer.at. [84.115.220.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b028b237esm3334148f8f.0.2026.09.30.04.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:58:21 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH] mm/damon/ops-common: fix age_in_sec overflow on 32-bit
Date: Wed, 30 Sep 2026 13:58:12 +0200
Message-ID: <20260930115812.138864-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5F20160008
X-Stat-Signature: 5u9rj7sgfeugsqszpnfxyi3wyyrbxpqa
X-Rspam-User: 
X-HE-Tag: 1790769503-527914
X-HE-Meta: U2FsdGVkX19Ya9q/7Q5GS/LUIPZEes/sk56s+fl+tPMKjN/amHyzg7SgM5nYihkF11ZUT1BXvKp1CbxRAkAIoxpmX47d7QF2q47EHFGP7MzVl7QI/ZY9Vc7hzEgRpufevAxj0iviM5PiJadaen2EER9lKjAFrpKdmpFuiQb22scJpZuxXBwBxJvS402h4M1rdgRUYYPxAddKLGKVIAMUdcCbQsWmXaHh1IgpYhuuYLg7aupCLSO5l8bZZvyUY+8DKKDK2K1B6FykYHezAaqQmfZk0vWNLyj2Mgzn+mvOk54MXQ/AVFZi5+Zw6D5ytDmDcG/resdSlhH3pif6GIPeGGuIYchNqy5P4hQQtj4uZwOy79TkGo3AulHNhuOTmtW9YxVPK0HTDPtojl4aKZnGvWtoJipd8u5OA3VA0Afjz+zzQIoQs/V/xeD/3Q5lnGcqQDKVpd7fk208zSXfcdzNoQjMQfDmPHAEC0uKgrb/8SKgZ297kWQNNtofZNi5xXZxV1waSod8z28QmVdSJAX3YbRD7Mr29Yd9W3A3z8rLdr681/LaQF9uhY1pWXYWyFC7Aa1PljPhhyuQqQ6xrg4fDIOcyUq5joVWxs+MVyWDEbkW68HMrdUu2s5i70w2TOcMxJmYR7HtPLpjUmOCbetzesv+tQOBF4jMuxz6Ia3FIg9atphZH/Zw2wKd6v0Vu4I3E1sWXYkUQbqYLD8GH5MEkhkgArL301EI4EXMaS/pLKGR6S9mv9sRsLkGJO8RfIGYjRGFi7NevA+U7hudj3ej72FNDd1LpxsqBHXgR5FGdlV5lw9xwUsn2wbb2gCkBDHbU1h5ELQY2ffhPTDx8p4IXwLyFp+9XpcTPwXYTaQgbRkl6bYGlUeKlvpNfhaEjvk0AhPBIlr3PCs9iEboKm5Cyl5muzKkoUm+oUG1TaO4bQukKP2zQpBq8fmzfb+2IKD8c2pOCf2jdZBYStyVgAd
 H3fFEEoJ
 O0jh7cJb8gZXj/ynzSbzMTV57K5lK6UT8eQNP1dMLrDRIPvVWIqC/JwcOgUPfpMqp5LfL+V3bqRnzbqFnRid+qSrgbqGVN/NO5/zVSHE+9MQWWbZpYUKpYJ0I4KHR/5+adt4Yesp7FvU2wu9p2D3PnwQaOsLeTM3KFfsdd/3EHSa8AWaek5m7S6uWwD4kGaBjHCRply3ZdjGMorqs8JEhoSeOK7TkjGEdVyEwfjtR7dIqHmJDRGiPId9pT+T3Lu8ANUOd/Qcg0ONhyWtFNk8X4JUtSjRc6XH1RKyt/5OUeIcXwhWTDV9wSz01c2MAXXxMFYd2Ecbf5CK8yt0i2i1L01k1R8z7xjMpfSpAzATAivxSWAh7ZZnzELhZK82di95o37BBTQR3VnnWglCGRMi6GR3GsRKenxY7raV0l43b6egOorH5RGJdrEBzYwYXIZy1V7nTJVG1s5vDU0EwB/qxtliObHZrfTZxE+aNkwu12h7lCR9Qc4shdwv9MHvL0nofQGRgHw4wHEJiQUCskC46yUdBNe5Y9XATuWuK5UAZOOG2fAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_hot_score() calculates the age of a region by multiplying r->age
and the aggregation interval.  On 32-bit architectures, unsigned long
is 32 bits, so the multiplication overflows once the age exceeds about
4295 seconds.  Then old regions are scored as if they were young.

Fix it by doing the calculation in 64-bit arithmetic using div_u64().
Also make age_in_sec u64, so the result is not truncated back to 32
bits.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 77366f42b3e5..7a7429359dc8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -164,7 +164,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
 	int freq_subscore;
-	unsigned int age_in_sec;
+	u64 age_in_sec;
 	int age_in_log, age_subscore;
 	unsigned int freq_weight = s->quota.weight_nr_accesses;
 	unsigned int age_weight = s->quota.weight_age;
@@ -174,7 +174,8 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			DAMON_MAX_SUBSCORE,
 			damon_nr_samples_per_aggr(&c->attrs));
 
-	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
+	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
+			     USEC_PER_SEC);
 	if (age_in_sec)
 		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
 				DAMON_MAX_AGE_IN_LOG);
-- 
2.43.0


