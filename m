Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20961C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B96D6B0088; Sun, 30 Aug 2026 00:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290C66B0095; Sun, 30 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6366B00AB; Sun, 30 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4FA6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:29:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B11E140255
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:31 +0000 (UTC)
X-FDA: 85156656942.17.CFE1BBA
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B05740002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tg8S9J47;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7Xlgh6vQbD4bTs7SCk5VD/YGUSfPcjuafvIL7aXc420=;
	b=Goib7ULb+yOQET5KE2YPUlKustpttYc+gvHV+rs1bc5nHziBDzUDeqibay5+y/pvhcQRQP
	oHhFAN33ZyCbVMdnxmfaT6fO9QtiyypQQnJM4MMfMqe3LkZkCY2DH9H3cL971vNvLAqNEo
	B3cujkUDqzuksamxSK5GMwmnTrBLM88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064169;
	b=T8Ya0di5zkXZe59PjVNp+ujDceGakbszSmvUpr282Y1KRBwDA698tVMaiYnNzaCicorZzh
	T57AfeEhWE12Lmyb4kRJxRG2pX7rNlxteok35hlPrYZL6VPYsL36G8XBcR2mSFMKmTopbk
	awIsA871A4XvOT9YtXD9oNWFu+ARni0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tg8S9J47;
	spf=pass (imf17.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d30c22b1eeso2837085ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064168; x=1788668968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Xlgh6vQbD4bTs7SCk5VD/YGUSfPcjuafvIL7aXc420=;
        b=Tg8S9J47V5I0yC83DaUo4afmjWJWHb6A6yCFR74dk8lVoo90VSSrqqhID+HH/CS/Lm
         z39WtUWTfFPS+JYiChZAhQKPQt+liPybO8bNZNm4C98oi1gZ7ogC6gbY37lTsmuVlfms
         yf05eEvW+M7fvRIxmmFx5op9NiPqxypG1HqmDAXxMwGAq3G1W1ATXadzPtCaCkB4RFn1
         ZKX7RuSaynl7ALfBQxGY0MfWpH3halU/VmiWYJb/8w1njrrgdT+aSV/5ieU7cL8RM+HY
         a5A2f3aeeDT1IBpC8AF5brPxFo4ScElXKDdYmOydk+ospIkGkexnVninwBgRuxFfMG47
         mWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064168; x=1788668968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Xlgh6vQbD4bTs7SCk5VD/YGUSfPcjuafvIL7aXc420=;
        b=srB5L6efUIZk+35T+hyFTSNfb1l9Yxv0LZhTDTlt+CjNjTp4ke3oi+fqNmHsryTj7s
         8/io3QM1sT95rQv4UMQ5+qpN0Gg2ZkHpRxLkstTwW8b0qD/IhZ7tQ4vuZwHInwTuFjqe
         JVotoxguGZcRNK0qGoHq/pJFE0xKue57e5h6ilOsSpzOLpf/BLR99/+6TcPS+NKr79u0
         NcnzA7NGHE3R9CejBJrtqTSTtpbeCzhqGvbtjiunBLlk7Mpm/tPrnzgq7c2Gj4EYk5TS
         A44abY4PV6//ITbFpvUyWQy5tEYVOHW/LVNy+ixHzCGxoAZ5hcsvfW8veiRGaHPYSxLd
         l2HQ==
X-Forwarded-Encrypted: i=1; AKwUvBzEUVdKPuVH96wxfK389Zu+5MLcZ7V1Uky4WYVSu+B2Qtg/gYZFscOEmZZnUsUArBKC+apJnEnxFA==@kvack.org
X-Gm-Message-State: AFuF++lDCHGrV3HVtkV+TjWBsmOOVUkZ+2MJ628yRTQfFYwvwa0gW5tW
	W8670Xidgx7f46Ym0JaOsLTdHG8mQ0VPcSmNYr9gDw8EdXb48GHt0b9w
X-Gm-Gg: AYBFou0lPvc2oaAliFBMpGaAfg9etw6hRJOuT8muCZof/i/Qaz1ro2EhEz6KbLUt3F7
	DUir+X6lu0l9oXEZqTQtS+ThQxd0aFwHTdR6iX3QB0V7AEx2J5oARyaUF0+H7ItueZTwb8UsXgc
	TcdJMTnC4W1E/cpRLDwZhltNL9miRd3mm2WcLjYZwlWGFhHzgy12Af4FFDvd0QYfEz9KUnvTQkt
	yz9l0vE/0ZkX/I9WuCDE7NXZLWtWCouZmTH03QO622ahQXh3otRT50hsLymUEeWfBO62UO+lPMr
	APKfAVkOpODyz4s9lu1BSRg4ay6/GcUs1LKQFF/Xz8F9bCfmtHm2e5xNKcddYwI/yU0uoOPkhrv
	fHhdlctLgYw55UBEtiYrDx5mQNVdCsIFDCvd9ePyOYv2VHLNzbGisn9GR+YAv8wXZ773C9OW/1P
	EUy1OtN2J4HYjSbv8YpsjvgP3wElkYvrgKp1KKT6wqfJjMWRBk0O1TYNb0leqXhhZxyvpgnMOL7
	/BXPhe11tjgRntpd72C6Atc7rMyTAVSsiXCHJ0xNkuXmpsfT6o=
X-Received: by 2002:a17:903:3093:b0:2d8:d29b:c1e5 with SMTP id d9443c01a7336-2d8d29bcb42mr73839805ad.0.1788064168222;
        Sat, 29 Aug 2026 21:29:28 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:27 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 0/4] mm: avoid large folio splits when swap is unavailable
Date: Sun, 30 Aug 2026 12:29:16 +0800
Message-ID: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5g7yuz73bg8z9x7edo9s8o8jd5zgisgu
X-Rspamd-Queue-Id: 9B05740002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788064169-185167
X-HE-Meta: U2FsdGVkX1+WNWa1Bu6icQw0iThNFFPzuHBVqEek5QQbXBQNTBCMpozyJJ1Zc6h7oTBU/SwP8WGBGTGxyVCwgnXNPw9ETmenfa//Gftd24CgDm/LTUmEE4UWVa8MDwhdVWQO99BI8mEWkoswUf7cq2qsEHjtaYfM0BZuZwQuKk3ObL5qrIti6jdjL6gztpU+bPfIvFNOZtZZrF53Tkx6G4PCWpe8JMj1vpNdoW4yul1fqnqPNx/AlARryjy4eDuj/OL/8+Q8Fa7GC5HRHcppOsRwcAzdg3kXpYGS5q+oGwNhdjb39bkywmvP6X8bK94bj+NXNc1Ey0/iyz6oBqfWiLP2dywZVLsm8ie/LgWuEau88/YApHzZlXHfMRXmS932+CTLsdeUIcs2GBNT4gM/VavVk6PINncLa1ftZVWLjxm2H0R0hPzbE7CSlgTZ2jP3qITvaZNsmxaFTSp6wAe1t0KHiVgx3XvZCg9okyBxqD9HVkT2P3kfyRUw6aQNIwjJ79wxahCViyKlOfGPHOekggM0biz6ijwbe63k1VhdK250mKo9rZAYe2zj4h+9X4BGSk43o1ySxY/xdfi7ITvhLJw/Dnjwe5+HIC3nyU/BReAR72YeEbRRNbusb33W2DBQCiuAUovvmwVZcmY8gPxraiiX1uEkZCzqGuQ6Ijv64lxA5GCjXO77hcJoMCY2/QrLuyoPHAifFGApVAh6GHyGUfitlSmad3YiIupMtUxf7W92ezOnHRDVWWZaoC/wmbiy7TubTh2fW5al3Jg9sUJujJsm2GsDPcs7WLt+eHZitpgOguw/J0C0Ge2IB6EPjS0cEmfBYP9+wv7R6H0A2Yfn1esVTODiU8OCxID4Q1e/nOJMcf4rF7SkyGN6AbY5+TZUn0QCY+camQuUVoyiCvt4sFQtEDnKzwqu5lHCOYN22cikW3znorocxSqYSG/DeMlj+uUYF+juqvZ1AckC9/1
 gbqXNdBv
 Io3WHzEYawcdNJSFglp3vyqtmknTGWtqfEH4HtSoo2syP+WXSnCQvA/hjwhqhojiuIRP20PWwP6N8AvjuY2+Dt9coRinMRloCs9ueRQY1ynFXvbuqb8Da7M+dntP0KnuiaSg2yB8y0VP34fDQgseAlkJlhMDmZ+tB6e2al8G0qmH0qgZolsfkvprolJkOjWJqbF/pIWdKuGw5twyuI4a4ll0lbcQ4IkRCjh53WbwBsJX1IYdLj166qVLxRdKSy6N1Xpn5ggnY5SvjY72I088w7k7esiN434McIXFYGvuCrfe5Sy1P/h9vFexOWKMFzYIq99KPTlusOTt21i03GB/1/VjjBREqjQYR2cfn0ECWIrktRN8Au5Pc+gpqJXikJB5jMsbrwa4Fm4EfIcGo1jm/v9gZ3OhLdzvKCkfKYbsoAbeuvD2W/xbmKVj7n2lxBmSSK3p8M8JE9iW3SRrBxR57FWF4++JvgjjuUm1+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v7 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This series makes folio_alloc_swap() classify failures according to
whether splitting a large folio might allow swapout to make progress.
Callers can then avoid destroying the large folio when neither global
swap availability nor the folio's memcg swap hierarchy has capacity for
even a smaller folio.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 establishes the folio_alloc_swap() return-value contract:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including when the
    folio's memcg swap hierarchy has no remaining capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which currently
splits a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

Testing:

With a 1GB anonymous mapping backed by 16KB mTHPs and
memory.swap.max=0, the patch reduced the median latency of 30
process_madvise(MADV_PAGEOUT) runs from 743.8 ms to 181.7 ms, while the
number of large-folio splits per run dropped from 65536 to 0. Neither
kernel swapped out any pages.

I also ran DaCapo h2 under swap pressure and found no statistically
significant change in wall time or CPU time. The overall benefit appears
minor and workload-dependent.

v6 -> v7:
- Add test results and clarify that the overall benefit is minor. No code
  changes.
- https://lore.kernel.org/r/20260813075025.1406585-1-xueyuan.chen21@gmail.com

RFC v5 -> v6:
- Simplify Patch #2's failure handling following Kairui Song's review,
  avoiding additional plumbing through the memcg charge path.
- https://lore.kernel.org/r/20260730122304.2496440-1-xueyuan.chen21@gmail.com

RFC v4 -> RFC v5:
- Fix Patch #3 to jump to activate_locked, not activate_locked_split, when
  folio_alloc_swap() fails with an error other than -E2BIG. The folio has
  not been split in that case, so activate_locked_split would incorrectly
  adjust nr_scanned and nr_pages as if tail pages had been split out.
- https://lore.kernel.org/r/20260730021630.2235914-1-xueyuan.chen21@gmail.com

RFC v3 -> RFC v4:
- Keep global swap availability and memcg swap margin separate, following
  feedback from Barry Song, Johannes Weiner, and Youngjun Park.
- Handle early rejections and memcg charge failures with the refined
  folio_alloc_swap() return-value contract.
- Apply the requested vmscan and shmem condition layout changes.
- https://lore.kernel.org/r/20260717122514.51514-1-xueyuan.chen21@gmail.com

RFC v2 -> RFC v3:
- Use Johannes Weiner's original page_counter_margin() patch and preserve
  his authorship. Move the mem_cgroup_get_nr_swap_pages() conversion into
  Patch #1 so the helper addition remains a pure refactoring.
- Add Patch #4 to make shmem_writeout() split large folios only on -E2BIG,
  as suggested by Baolin Wang.
- https://lore.kernel.org/r/20260709145124.764807-1-xueyuan.chen21@gmail.com

RFC v1 -> RFC v2:
- Split the RFC into helper, swap allocation, and vmscan patches.
- Add page_counter_margin() and use it for hierarchical memcg swap
  capacity checks.
- Make folio_alloc_swap() return -E2BIG only when a smaller folio may
  still be swapped out.
- Return -ENOSPC for no global swap space and -ENOMEM when splitting is
  not expected to help, including memcg swap exhaustion.
- Make vmscan split large folios only on -E2BIG from folio_alloc_swap().

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Johannes Weiner (1):
  mm: add page_counter_margin()

Xueyuan Chen (2):
  mm: distinguish large folio swap allocation failures
  mm/shmem: split large folios only on -E2BIG

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         |  6 ++++++
 mm/memcontrol.c              | 32 ++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 mm/shmem.c                   |  7 ++++---
 mm/swapfile.c                | 26 +++++++++++++++++++-------
 mm/vmscan.c                  |  7 ++++++-
 7 files changed, 82 insertions(+), 17 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3


