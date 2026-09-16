Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C89C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE3B6B0098; Wed, 16 Sep 2026 18:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6804F6B0099; Wed, 16 Sep 2026 18:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56EF26B009B; Wed, 16 Sep 2026 18:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0236B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:55:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBC7F160195
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:55:53 +0000 (UTC)
X-FDA: 85221134586.01.CBD3AA6
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1F60CA0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:55:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TgEXbY8M;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789599352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2eUVOCI5+eWirt1vw7IRjVEOaV+AYfQdFXP1BlZzklc=;
	b=SkulzXktTer6hwgJhHhmPokgQj132PuykAOQq422mjpxN5cnTjAmXJdSOrBS1gxcW+pnsy
	d/0a4qLJ50/DacAaaCfncy3EBsNPppKGzadwwgwTepbKkfH5NIHkReg0hvmOs1LcIDQSiO
	G2evy5C8Df7frMJXe3jtMn0GAYOEM1E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TgEXbY8M;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789599352;
	b=zcDavWhKaVJ6k4odzkSVtqP5cQjRhplbWD9WPFRkQR9jy0JOi6X7QCAi/eurV5E1UnDl4L
	RFh4iJwon4grWxu9M7va4taTUcnsFXymMq9C+nuQI5W7xPzx+hmAmkMCEk+ng9byTFSd0S
	pS1x04pTE1cJsmEQsFzYd/ZGzL59mps=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530e2f50d01so1760781cf.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789599351; x=1790204151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2eUVOCI5+eWirt1vw7IRjVEOaV+AYfQdFXP1BlZzklc=;
        b=TgEXbY8Myje1jvwEvKbX9Encyjh6cTQUPXBr+w/D8xnRzlbsmR4J0JcXBuSzv5kOh9
         mZn5UIcDFQFcwPe3iJPA077HVizuC4acKfH7yukAPr0Opqbm2VTHCi/6DmubsUkP5wG3
         uVdFkmVSq0QODjdZoryyChoL6TlN03GvCC4fDods7CE9BW4UgK46HiVys+DqKw8Mw2hM
         13to7kSIEKk8LFH5zZULOY600gw8VbAXOcmQLsjkVUQe99kBXCgmn0StMN30cbRLikqe
         gfQ40vghOmBbeMNESVnJrQUnxbJGyAAzTMuHSe9ZgcQUwtb4FX6gE+FtuyQO2zv0Z5xR
         iWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789599351; x=1790204151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2eUVOCI5+eWirt1vw7IRjVEOaV+AYfQdFXP1BlZzklc=;
        b=mgOH6p9QXNJk8vefunmeT/ZkguJT+mqbuqAXjZW/QTtM2cBEKxszaBEmAKymjmlFdE
         w7ZLbtDrnHvZAUo1tZrqRIdsRAvBYJK+Uk3qEwMwHDA6medf63MOrEho7sE2jgs4XGkv
         XkZ7oU1ctsu3ZMyiBtbJ8cdYMsYLtImdZh6chQ47XJHDwHah/h/a3p6pZGo+XqMv8lDW
         9GQyhxSuuvG9BfXMLE//Uv2x22ojIYTWOBwgvLccvgr2FUmnnHnoqGROlGmLA9rL8Vax
         JQtlhMkySswHJKJQTuNdHmNdyJ1WE94RO7qaJXBz6A39vj+eBC6TN7VMmmMNDwg4i9Mv
         kMvA==
X-Forwarded-Encrypted: i=1; AKwUvBxprUwyLSKniXiqwp6TNbR7Eizri4BjDroQ9Yiy9A/ivDKpRxZYHkSpqNJyiuIT8oXjrkm/zWzSQQ==@kvack.org
X-Gm-Message-State: AFuF++ka+hNAxEdEJitNxV9LKNXhwOb7XX8oGMwnkz2C+hp2o8qr6ND7
	RKPmC1HN21bw5PcvA/wuSztVxMucNmFrV44Yif1xGYTlJNddVtuOU+zj/lL7vw==
X-Gm-Gg: AYBFou2mNtYpnYVTe78OxrSZRlG2ZAAqsmWh00kwNgyZpvFGz6peGxaWhCkM1ZoFPEv
	i9UH4VHIhYkNT/gP5fFNBHK0vxK7gLF7ClWTF8EOaoKBTpsyiN+aRiKGBnfJgzNVtebjSsG9MMG
	ew3Qa2VsoiqOMd3q3nhvqFqg/rkb0HyX56SYQZpMJVhxGd+MlAzEEJdCvF4UtzRMGNPsNoqC81r
	V9uUOvctN23SE4qPlsHJzYpNY09wFVIm8yDZ6nq6m8CshwEN8FG95q8C7NIw61G/K18NaXZ40CG
	XeLRfWmR88WrQ6l3rQS20IlqsrYN4B/PdpBez4k0hOHyojbr1qx7myWHkaPJs2m9+TbsD5aJ7UQ
	3WjtAMYhrjvZUm76T8piHQcHx9Ho0meSU4npK4khkHVzq9txFtt6C0x5IdUk/XENPo2WvE8GTLE
	UkMJC2Y0mBSddshdTp7jMDAgzNobAmlwhVMDO9fx2aDYTyPeXwllW2nnf7RGDmaESkeK1RU3AYg
	bYcUKPvDOiVo52DKI6Ix9pgL9UirXJBay2fJoR3cbOfZmB/tjI=
X-Received: by 2002:a05:6808:19a2:b0:4c3:7073:8c4d with SMTP id 5614622812f47-4ca4be646ecmr5210481b6e.20.1789598906677;
        Wed, 16 Sep 2026 15:48:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d16d9f5sm1117571b6e.11.2026.09.16.15.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 15:48:25 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
Date: Wed, 16 Sep 2026 15:44:34 -0700
Message-ID: <20260916224437.1164512-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F60CA0004
X-Stat-Signature: u69363n7ac9uh4bhtptjxu1yjtsh7yo3
X-Rspam-User: 
X-HE-Tag: 1789599351-846545
X-HE-Meta: U2FsdGVkX18MYYWSEauJIz1pgQ2KrKw3xJjrAgZYthiF5RBSRU26/mo9e8pQhOrN+TjvmNBNo2ruo2l7K6aCMh+IWm2cjrkbUKY/0QTp9U/or7P6cHYDLPZ5Wns8UfZwYTrkzelCiVD4NmGG8iaViX5HlXrooUMKkmu31x41Lna4n28myxktu1Mb/X+XfqFqoCjM7nnjzNtuD0fGidg4BRnTaoR+ygdDCmLtsk4GzE3cmYGuEF8cihcYTdTrodNUgoxt6lDmeryJnpeSQB0dffgtTQArGu0jxEF3J4wRI5Jt8fQF0ogj1PaSZlVbczoPwQy1F5bFKykwEeovW2Q6NeTCLAgDONqwaljIscf22APWJxuo8E5xiT0KvrbWml2qMDmAwCbgZRTvjBZMFczTwQboGWi2x0WnsjlSfEBSdcKDKgoQupzfOAQbnn2YcwfAo4nmpOcbfajSv3Qm5XMQzHDAn/TiGSdAIoFUHKkT/IgmDZeUdtvAjJBlUZtE5pH2QUWMihKVoXmGlcgyHevgzUsoL/Z9axdTuvQZ4M4uGEYw50t+CRl4/MeP6w///T9ROzZ4r/mHp/CDmzM1Q9ka95RddfV07Y6pxsdia78E/zbf8uMrLlxTnbWTv7A9KyQ+mso3p3OqOhhA6MPl6igiBsEtY/lFt0HGAtfCZj5o7/3F+PlE/hfo/taBSOPB7HQgkYaDw3qNh/X4z91hTCQdQEZSH4jcbwB++Wd1hiU3Gyh1seq2VMBa5ZfjnBC9fdBcGtIl75TOoWvs3xhB6BAsVOKFGPXaDXRm7CaUzkS0Y8JSfXoYaSPRjQTykSkN9jdazZKNLK0ojlxfRQllHjeXfwT8GJhsrBTnCJrryo8q9AIPAOH3mXPYCv839Fg9yUT0mLhCUXG/rTM9fZyCpL0w17+XSTHC3dLm1XrfXIGhUvIBtAogCN1+tYQYzUAZht4ZiTc6TBKsgsMszkvW2E3
 VfbcZ0Vw
 D41xw0q6J0a9VO7qAqPijb1CklpOs6AVBTNCgypnijeY5xQYuN4L3/dJqsuYOPkjUlKPTuu6lvwxKnKBavLrdaOEP3M270cFDnzE0n4hClrQMmSCJhIjoB+ElQTtFOQ0AeJLZX2OoOm+vEGI9x4c4L0aBJFidN049YK7Et2iy2+KgCkuOvbFDdCr+8j0IYwM15G6+E1gyea6g1Sl+rawymnfsmikjyYlH4mcBUZrzT6VCYFScXbJ0PJunwZKYHhY8NDsFCrah1m8jFkA5QV/E9fgkC7KN7pw2xwlLR0Ve82asztn2PnILjMkL/D8VrWSZjMgtzsp/+n6qEiDvOI7Vw32yTw+fbiEVuThImbm5+NMvX+lI0q431awVF6BSSy1VqIxPr6hwcAnRuvUjdE78iv4MHSpZTbLnvPznqFmMTrH1wMick6eSgnHhqqR5ou8fEJB5MT2XBMKvgMkApGFPqWChpO0p+O4hz/51+njyskBTSKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PMD-sized THPs that are mostly zero-filled are reclaimed under memory
pressure by the deferred split shrinker, but this is not done for mTHP
folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
base pages, as 2M provides the contpte benefits while the PMD size there
(512M) is too big to use. However, 2M THP=always causes memory regressions
unless the unused portions of those folios can be broken down and
reclaimed.

v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
it queued every anonymous mTHP folio. David objected to the scaling since
collapse had already rejected proportional scaling as either letting the memory
footprint creep or being confusing to reason about. David and Barry separately
objected to the queuing, which adds list_lru lock contention on every anonymous
fault, and hurts lower-order use cases such as Android's order-2-only
configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
simply not queuing folios that could never exceed it, which addresses both.

Read as an absolute count, khugepaged_max_ptes_none also implies the
smallest folio that takes part in underused splitting. A 2M folio on 64k
base pages is 32 pages, so the knob has to be set below 32 for those to
be queued at all, and any folio with no more pages than the value stays off
the queue entirely.

Patch 1 makes thp_underused() folio-size aware. Today it only ever sees
PMD-sized folios, so it assumes HPAGE_PMD_NR pages throughout. Patch 3
breaks that assumption, so patch 1 generalizes it first. No functional
changes are introduced.

Patch 2 keeps folios that can never be found underused off the deferred
split queue, as suggested by Johannes. This changes/optimizes existing
behavior. With the default khugepaged/max_ptes_none, PMD folios are queued
today and then dropped again by the first scan without ever having been
splittable. After this patch they are not queued at all.

Patch 3 queues anonymous mTHP folios from map_anon_folio_pte_nopf(),
mirroring what map_anon_folio_pmd_nopf() already does for PMD folios. This
covers both the fault path and the khugepaged mTHP collapse path.

One consequence of keeping the knob absolute is that it is shared with
collapse. A value low enough to be useful for 2M mTHP is a tiny
fraction of a 512M PMD, so khugepaged will only collapse to PMD order
when the region is almost fully populated. That is fine for the deployment
this series targets, which does not use PMD THP on arm64, but anyone wanting
both PMD THP and 2M mTHP on 64k pages should be aware of it.

Thanks,
Joanne

Changelog
---------
v1: https://lore.kernel.org/linux-mm/20260707201735.4113107-1-joannelkoong@gmail.com/

Changes since v1:
* Drop the per-order scaling of khugepaged_max_ptes_none. Keep it
  absolute, matching collapse (David, Johannes)
* New patch 2 (suggested by Johannes): don't queue folios that can never
  be underused, which both bounds what patch 3 adds and stops queuing PMD
  folios under default settings (Johannes, David, Barry)
* Fix the thp_underused() early exit to scale to the folio's own size

Joanne Koong (3):
  mm/huge_memory: make thp_underused() work for mTHP folios
  mm/huge_memory: don't queue folios that can never be underused
  mm/memory: add anonymous mTHP folios to the deferred split list

 mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++++++--------
 mm/memory.c      |  2 ++
 2 files changed, 39 insertions(+), 8 deletions(-)

-- 
2.52.0


