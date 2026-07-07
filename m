Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E869C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919EA6B0005; Tue,  7 Jul 2026 08:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3666B008A; Tue,  7 Jul 2026 08:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B8A6B0088; Tue,  7 Jul 2026 08:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4891D6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:59:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5776A0422
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:59:44 +0000 (UTC)
X-FDA: 84961987488.03.14BD4CF
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC81B4000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:59:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g8XVdsic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bqawGs/D2kwMuaBURT3A7nHx9bziQ0g0fHDee9Yijoc=;
	b=HTSxCGsjsMGcYAXpgDzv73/+FBjCiorUvcdiabQc8vb+wc6GH3ED0ZZTpZziMtGg0tzPtx
	EMn5TgtqgJxJAxzDy2szVgHN5rN0qUPV27ZTf/oouZsWNiqn/uKIep5QtqVj6ed5hvXav+
	mOMMHzNsH+4voVoWK1c/d82e2VU/TvA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g8XVdsic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429182;
	b=pMS/C7Q+H6gEhekhjltXImqsgFEyFW7opNElntkCIm4S+6gMftrdFNNOQgRJRbj5ffNlWi
	jYhcE0yyqHvpZ4WutknVgDLDwPa8wrn4y8nposwV8ScyP6qOWUArbu8r07yRQZcHIPJiQg
	y0dvdMvU5nOqLLPqpMFBKjTTJFoYqrE=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca696c4b152so31482a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 05:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783429182; x=1784033982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bqawGs/D2kwMuaBURT3A7nHx9bziQ0g0fHDee9Yijoc=;
        b=g8XVdsic7IJGVsv9POC23sNjtEQlVjSUWelSWYuNAYafTGFOC6eNw1eHUCajmyqjvI
         +st3duMPrHYYStNmSqbG7nUNGL5J4rzlf/PkuQyS2PnJKCnSHCy61h6RhFfEZaui22f0
         P/GBCcb4jcl7CqbcFk67o/I8lYc+8DcnwE+aOplRWJXXA1eHl1UiGy/zsXq3UtaJfJLx
         PmcJdPbnwaPvzQhBrCNJR7bW/seY1i49CV8WqgDkGlRxCyGJTRoVtI2UAjr8ubuBr5Px
         +bigoXrHDiWDkRjklETuuZ4KwP7g+BBDGxC3ybSx7drCZrgCGd/y5PeRHKOzK6xQ9s6B
         ODRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429182; x=1784033982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bqawGs/D2kwMuaBURT3A7nHx9bziQ0g0fHDee9Yijoc=;
        b=V128Sm+eqMWklvMBEV1TRzvgydQe4x2Tu663UlPRZ3G8KotoxJY/hgMp78T6uzyHsZ
         GEJqUMHZ1vlUHoyoCKm2XP83fNNHl+A7yVaC8DUChE9EDX3xTJfUIAnOkVDhytY54fDS
         eaIzv4kFsfB5RGCQqTAtf5FVkNU8y319YV++u8kCMpkTrOcw+4GUS1rN3UHy2dZACfoP
         CPFjg21pLOFepkAySAX9U1Y3MXTba+CGXQzo2XNOUXDDJkJc3XAo2uvv2B8zcMJF47vQ
         Qwwar1S7FJLpozUlyuKK4hDGx4WQv6BrGbRuz7Xqnt4+K6lvuy0kpNKzn2pX0PX7zIn5
         BtQA==
X-Forwarded-Encrypted: i=1; AHgh+Rpu5m2/CaAVEadYdhT+NN2GHz87zK4fuYgb3r5zj4TA3dE0jXNCDAZTWvz4HmdqBrdl9VrqiYhcmQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6Hy2ZNsqZVE4k8mZzZHJ2zGVCqcBldscgN30kwpNQGy2ogr/r
	QuJgLIdq83D4Gf1tScjKAjjQwWzDWyR6RgrygqXVY9ogSjWx0Z1s3Q1D
X-Gm-Gg: AfdE7clJ+NF97ZFu5LWn0vk9PwsOqxAUGe+xlXhWE9R5lwkGWW/eCZPGTvYVDs9SJRK
	IAHnJzu7FjN5hsjI5g5JmtT1sTowLZXlHc8kNcpQs8W8bplAWXv3ggXAx1gP2ec5USCtHl3eQFb
	QkcozKyUbqW0arEyb71zWdpSS7/3tAY7ALLmve5xqalvV3BVLh3Xzmj5bCTi/LBTuUmge4ft78+
	UPaKL202eC5mWWlA1ykV2XxfB0k9IEuxtgrdszDLNNNwf76r6+ziwm/e6pMALNeQXIAeYLOcRg6
	o4Ikchsz7T+8MAnLboliOL0/HDRXCcAERQThieWlsUuwl91LeYMqBN15Hu9xB1+7HhjHV1wyniu
	Efjl6ljneq0l2T5+a9t8VL7Kf2u7SDB5Xh/D8zxpOrkhcD/CgkneHyoRql6R8CO5Gk0LXV21Ijd
	bUTcTtg2EQapWtLhw4LuyBhxmAxQ==
X-Received: by 2002:a05:6a00:859b:b0:848:32f5:4999 with SMTP id d2e1a72fcca58-84832f56f1dmr1523190b3a.30.1783429181654;
        Tue, 07 Jul 2026 05:59:41 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5415983b3a.3.2026.07.07.05.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:59:40 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: vbabka@kernel.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	Alexander.Krabler@kuka.com,
	hughd@google.com,
	fvdl@google.com,
	bigeasy@linutronix.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	pfalcato@suse.de
Subject: [PATCH v2 0/4] mm: honour compact_unevictable_allowed in mlock and CMA paths
Date: Tue,  7 Jul 2026 20:59:21 +0800
Message-ID: <20260707125925.3725177-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC81B4000C
X-Stat-Signature: mp9ykgf5b89sr91te6z4sgnkenzcfgyi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783429182-282608
X-HE-Meta: U2FsdGVkX1/9D2C4+ySsztSAQJnQ8XEijAyGpA9JzbJkUxzTjhwTToG9AZ8GuBFadTgsVkxa5OxVXQ5s84msOEVAgvs4Nl2Wyt+5MfsB72w1flwyCNOMAgyLCQrjNsiMT3uUKH2Yi04axXrBejZ7KL02Xb1LT9ZTRuaEmdEp7y9F7Lr5EfVbaEG9Q7Ij4GC5GIHBJz7mBzEatH2U5BiDqRGjo1YGfUaDXTA7GQvjqqVoLqzEFEw1judA8YKMbZkSvqJk0ywLp8TJHUyzOKks/zbkRn8jp0r/dPoT7JpyhQPjwK2Lym6DN0bZyg7iv6XqBiU64GZzp24rBPKmD/qRLPT0DYrRNF0yWAgHUUUF+3SnYhKKBWfUaxg8YEfk+EvXJyzuv88axDCB3Jt5fK9VCi/1j3TrT/rC2cnljdMpTKeA3edytFEPHbrCdpL443cv/hEcYNA5hqSlwIg2bGnGkvm7m9D/z2w4DoyduIK+gXTVpQsvYiBzYP+zcl88pR1pjSkHw+iYYGaXxOkyoV+uDvpzc1uamFi7rWhNrfhQTKL/fUIvc94AS+rfFK8F21VH5PeFngFIWlmPydghrZzowp2hVBpJNapEQ7s//Z+wjUK1or71uGChbI5jwN0mcvrgChfeZY9dZNDpHmNPgcdP/BAUC/xuCUTM0xmKA/hAnqtb4X86PCj4TeRtkdQ/BhhwmJza6crRbEhlc8sRZh/BSckla2sCtlc+uysHBLXq+dgCeFS++qxpY4GW7rxWrJdHIUTxHeXtrdp0/NckBV7YnM8IPvElnxDviYTGoHrr/y/xlwm7qoLTTB5Rmlm8STlqu/vuM2IF7sRhRu99OVU8giwaF2wKe6WfqM64r0c6OW4sWNEg6JfMLTLFbA/Hvkk/KbfKlgQRWGX3CxXLtQTnon0h0lNIrt62IwdGt2ueZ3zAU7/tN1h2pa575C9qCQZoqelxYvZ3ZUPvZIQ/GaJ
 geqQlLJT
 OY5cfqSz/fpX1d0oU7osACRO3eX79eKriROqq/bJIimjdvee1MWFiojiJqLVDKMwRIVahvrl6XQhJE39MAIpiXpb0bV5/FPV9HYLk74Y4RcDVeuqaJeJd5QRLdQwjqB2r7nANsiJCeYzURPTZN0YrYsVdxihgsF5ZInIvxMKS4Xzd6CbkoqI2m8LifUB/K5fuDwR4HT3XswWEabAMKKsBtkakR8D/73/N81/ErceI41qzQRzx1NYsG+rsmUevhmMgCsIHB2mZgzSWfvvIkzy0sVCvcPH49n+jq4eIKg6wgs0G9wd0PD6mPE/uqrZs3ViUZcNshHYMRJjiO1t9H/mAsfB6jfLQsy7AbK7fqgG9tMkqJKV525iQcUTzkGeBiT2D9HUEUwU2o4k7S/K3oJ/uDrdL3gbO/r2cPQ/sf/5XwkwEbHZz7yB/BLhI3P3eUqmh2kya73V8r+rgCcctX7zb9wEjIUybyBJisgMDRTtSotpHqPwIeeczb3CbWWQ0qS5UqX6EvP0jW8PVPs901kL5A4ktp+FGjLnBQZeZs4URU48S/89klag4eeon+xXk3Dbif2H7wHBBt5Fy8ezVmKRFgtKJ1r5HNlRBtZE0duQVyjYveuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

vm.compact_unevictable_allowed=0 (the default on RT) is meant to keep
compaction from touching unevictable folios. Several paths still migrate
folios that are about to become unevictable, or in CMA regions,
installing migration entries that a later access must wait on, then
causing latency spikes on RT kernels.

This series fixes those paths and adds a tracepoint for diagnosis. It is
a rework of the RFC [1] per review feedback, mainly from Vlastimil.

RFC --> v2:
1. On top of the isolate-path filtering, also filter by VM_LOCKED
   during the migration unmap step.

2. Make mlock/mlockall wait for in-flight migration entries, ensuring
   the folio is on the unevictable LRU before mlock[all] returns.

3. Dropped letting CMA migration take unevictable folios; instead
   migrate CMA folios out during mlock[all], avoiding migration at
   cma_alloc time.

4. Moved the tracepoint to the migration unmap path.

[1] https://lore.kernel.org/lkml/20260604023812.3700316-1-chenwandun1@gmail.com/

Wandun Chen (4):
  mm/migrate: do not migrate folios mapped into VM_LOCKED VMAs under
    compaction
  mm/mlock: wait for migration to finish when mlocking a folio
  mm/migrate: add tracepoint for folios unmapped during migration
  mm/mlock: migrate folios out of CMA when mlocking a range

 include/linux/compaction.h     |   6 ++
 include/linux/rmap.h           |   3 +
 include/trace/events/migrate.h |  29 +++++++
 mm/compaction.c                |   8 +-
 mm/migrate.c                   |  23 +++++-
 mm/mlock.c                     | 142 ++++++++++++++++++++++++++++++++-
 mm/rmap.c                      |  16 +++-
 7 files changed, 216 insertions(+), 11 deletions(-)

-- 
2.43.0


