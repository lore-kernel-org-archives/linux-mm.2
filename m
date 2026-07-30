Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35F0C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA0D6B0088; Wed, 29 Jul 2026 22:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44696B008A; Wed, 29 Jul 2026 22:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A332B6B008C; Wed, 29 Jul 2026 22:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 615C06B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:16:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C078280136
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:16:54 +0000 (UTC)
X-FDA: 85043829948.11.22D6324
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12FFD20004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:16:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ha7c8VhE;
	spf=pass (imf03.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785377813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CEvVzpQ7maBnqXzDlrKpFAxRq67Wh1PJdH6/rY1eZq0=;
	b=rVDol+cPVazUEbJGkX2cO3HHNqVq4SdXS8p71y5j+XCEjXLkJGLLCv66XKS7LR0py4oJuc
	EWcmoREKNapy2xBjAnQpYZSLVUR4XSzqzKGaE6DG7uLC4keKp4QD8X4IFQJ3naPlQXfmm4
	UH4KtfmCSO+ktWwDV1TgkgbZEUm4w34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785377813;
	b=Hcp+qNPPtxrJ0QU+9Yn8M6IJ9HawoX6Oeu+a1sWLfZAzYNsy7inpdnadczPkAzrsTnIXyE
	fB/I9Y6BKNsez6SScBoZp1fLql3FpOTwikTQjXlCKN+DNoJsUq3ipTigHwk3bgpUzmQBBy
	bzQeNKZ6DOoOHisUewvImGQmmnXp0Mk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ha7c8VhE;
	spf=pass (imf03.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8485ab7c382so236731b3a.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377812; x=1785982612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEvVzpQ7maBnqXzDlrKpFAxRq67Wh1PJdH6/rY1eZq0=;
        b=Ha7c8VhE5IR6yL+D3eWnevH1f8bmONxu+IfpNCrVxm0veTYvDIqg+a6M+aiJzJBFO+
         8PMeXT3mwQkbOIDAImz2rgIymOYDjBYsQPofymXxmTxTswS/Pf/864qx0QyxFixZbeg/
         FJyByaaLUk6+2ljopX/UYQgbyarVB4WlUkKgHA1il77wD7PeVXy0vh1a6aRyyJ891BMH
         fo/O5Ar89uaf/7mPfZBwvko8sF+qwlY0odoyGZwgNeKRbYFXy1TiCf/UOSEdTUO+xPlC
         Z+syLWFhiOOtqNwBKsxglG4fyiqlHt37LZoIxb6qlO/+fnDcFo+OtPzXFJQm08zTBwdY
         oytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377812; x=1785982612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEvVzpQ7maBnqXzDlrKpFAxRq67Wh1PJdH6/rY1eZq0=;
        b=ZCEnVuYH6iq4CA4Zp6M3HU4FwzbGPBxdkpkg7IMXsKWXFlhotmAmOvvIyJAStSxlhx
         EfDe7gj1VNBMuPRgxYVgRnoWy3Slo9i5he6nuYXMMM9TKXUt4G5bEgZQX7rLXkh+d6+B
         nQGIEbi3AlA781+fGNWYoeOaoXo1zi8VF+D+RdeIUCuedv8Zd80lDjHvpt1G63AkSzPX
         kGukDar8ZbnKmsI81CzJBtMgR72rAOp3rixZvB2s2CrdB3hyliuZBcWYoPPQN3QKrJ08
         S8gA+73u84t0PtBTZ6KLwyru600JVOHqvxBG79rZv7jgn2jZkzKUoTrKK+3/6urRKkSU
         7WhA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1wcPCy1X0GDgHZRHl00++zdCqw8yoZA8YbXvgjlIen0KmUKgqxj3FgtFR4G2lyTfKq00yc5jLDQ==@kvack.org
X-Gm-Message-State: AOJu0YzP2lVMOwUZSqqC6ZFJpj6UB8HLrwdgqPjlOrF+QhLMj64VK9qs
	lwncbdhoyL5SSR1QQfe+CdFGfUzY00DDb7MCfS5Q4N2uLBdxAOKWFTQT
X-Gm-Gg: AR+sD1116zKpMvRHDJwpR0Zbo2kjtp6R5DLX0wiyN6hfLcOERBZuJViw2UPIvMmQDeZ
	QJ1b7B9QqEh5CbidmcdNtWrZGpHzHxfeRk+We43G/MsF9U1WTwrthS1rXdc2mKCKQPFWRksrtBB
	CnEwv2j4MDX5cJdifCdrtZwl4ZtM5vhGtV/udHA/PfJDDGPPZij6JSpFTn1v+A9Q6YxxHE5oW7c
	wAQWjJ1HdJl84bif5CY6zOzJxChdla9Hp/u5tit5JiKcbRG2cmQ4eppM2ekaK+hxg7FDA9YeZ01
	AoFOVPtXyjrud6dWofyScLjnma591rP2aufKZuapsiMnJ5aNX+Pi9MZ8C/DvgUf5Z+iUTvyPWyn
	b2G2/C5JW+NiP/fBNFEPYphnRHQYeNttqkMm7kTjEU7xuxIBs82NLVpjVn/Z+lz4NUCVn90dVw7
	c0FGBUk7Kz5xMQsAWSkwtg0VYM01OeyYxLlERnkua7t5clj4kn1kWUgcY1ih+13t5/FcE4jIEd3
	k69y82wvUZAfS8rfoLhfTUOead1OgpsP4Ei3h/+fcBkglnUh8acxpgGx5E79/U=
X-Received: by 2002:a05:6a00:1887:b0:848:3dbd:5cb0 with SMTP id d2e1a72fcca58-84ebc3d2e0dmr1029530b3a.2.1785377811642;
        Wed, 29 Jul 2026 19:16:51 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:16:51 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 30 Jul 2026 10:16:26 +0800
Message-ID: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12FFD20004
X-Stat-Signature: 3cgxq8njk9ocqj67tq5m47d77e934shk
X-HE-Tag: 1785377812-615965
X-HE-Meta: U2FsdGVkX18D9I58KSRClgspI8AL9TvRGKw2inOjvY93jHEQKEFWb89NvDGPkpbMolSJHpUPVlyDzat70XyNKR7SzPFthctFccWzuEQlSSvfnjTbhXb31qWxFxlWaS5cA33jwRoZvgauziCfOtYfvD3SWdRUR7rGQnD5VXmfzbOmcOFowyV09wJH4ZXT7Der1qPy6B39wgUyUmePurfoBUeMkqG4DiXCLXotxdt89qVvDYf/XI22y6ihmBsGM/SLPEK1d/0xR2mapQwMRD9LP5sWsw/063tbfdwSvqlp3MSAqmCjrLhiPbY8JsrkO1MVamydLZWjJLv9bipz1JZPoY4OVquQLX4IGNsjqmkdRRSxE2ck9qAk++WjKXNPLnf/qeQIIP4yGswRI5pI5/7qf0jQWTC+MqU5mcIJMomhRzeR6bpdIKIlvpfS1JjwdLLUD6ns7ATIL5jzY4J/1uEgOiqYTv8DbwgPn9cZOnEavRm07xADUMq5DR4xDrHasV9pa1jVsjN7l3bvyzqwPJ/qNo78DcdaAKEcJxGlwbK9vJF5bpCqXo4FUuqEXd1o27mH78Za+6Uzc4STqq/AvRRXE6jEBLdxIMYAJwlT+lMeeiNHAdAaYgWB+sBsNTIzkSwOTPNx1XJMBPXBH8mdeocfZluxbrBmXDMIoMecb5k5WjuMgOyuy/dPEO4AQHlSVdJywgKpf1SKyLvWMRcAtfQFL2MNWaCKC5curMgwv7sd2bhHoFeYkuOy3cpPJImLqStyV09zm5ryjnSG8vxEDD11ZtiZiF3LlDDr7t6S0aPpsSr1KvHw02saSdlXcFQpr9hXcepKCY0O11XpW/XO/7mqqOIpbS4DpLj3S6GqbnjK11q6uCoa2DEs1+fWP42ze5AN0jq3VCC53iVcc0ys9+hOLMb8GTSNz985V+1n1+P0+vOcBXQ6Ixh7WQa1Dkti3D6PoauXp9KtM4Ud5aU5vfA
 rO2pLoJh
 6y0uP94a6NNTfy1+z5ZSd0UzKyIer4URrvTZ81VIiPKy1eKdt/0iln362kuDEL2cJ6N3TSfdqEYoQD6MlpCMc3LrN/3pSd62e2fPeWlBoQ5md0P6VxO/wl8xWr72KSE0fYwgBeh03jxQ0Q7zeMJas+h/rV2eT7zA+Cdf7sdUu3IGl7iKbgogLYgrPmzpTj3BEFobHoL0XWpyRE13wHmKNPOvzSDimQBAqqCo8Jz4lCuw+63chAzbThuhtJg+zit6iH4jXkrmeEM5WoKTRrr1P50gf8hG0nIfhG0XbE/qj9hkgsMGXL/FI3lMslC6xb3wUHGmzze/MQN/myBAT7fnk1dQ2jljLat/LQwGZNec8eM0IUfdg1zd/vK7cGgw3jzjHjw5nSnRBoQ/GnjR+W7YbvYdvLZQyZt600Hy5U87mVwOgjbeE4BWiPSoBaUCmefGoq6EdXeQjxTx0asAxeBkpaUlo1j/v16HlpbiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is RFC v4 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This version keeps that behavior, but makes folio_alloc_swap() classify
the failure. The function sees both the swap allocation result and the
memcg swap charge result, so callers only split when a smaller folio
might still be swapped out.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 lets folio_alloc_swap() distinguish large-folio swap allocation
failures:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including memcg swap
    charge failures with no remaining swap capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which previously
split a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

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

Testing:
- make -j16 W=1 mm/page_counter.o mm/memcontrol.o mm/swapfile.o
  mm/vmscan.o mm/shmem.o
- scripts/checkpatch.pl --strict --git akpm/mm-unstable..HEAD
- git diff --check akpm/mm-unstable..HEAD
- scripts/kernel-doc -none mm/page_counter.c mm/memcontrol.c mm/swapfile.c
- Apply-check the exported series against akpm/mm-unstable

Runtime testing is pending.

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Johannes Weiner (1):
  mm: add page_counter_margin()

Xueyuan Chen (2):
  mm: distinguish large folio swap allocation failures
  mm/shmem: split large folios only on -E2BIG

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         | 16 ++++++++++----
 mm/memcontrol.c              | 41 +++++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++
 mm/shmem.c                   |  6 ++++--
 mm/swapfile.c                | 32 +++++++++++++++++++++-------
 mm/vmscan.c                  |  7 +++++-
 7 files changed, 101 insertions(+), 22 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

