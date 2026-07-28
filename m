Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B288EC54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDFC6B0093; Tue, 28 Jul 2026 15:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DC66B0096; Tue, 28 Jul 2026 15:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FFB6B0098; Tue, 28 Jul 2026 15:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 497596B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:47:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC50B80452
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:23 +0000 (UTC)
X-FDA: 85039219566.22.0C206FA
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28A71A0012
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UpLwd1wg;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268042;
	b=pRXWL4JC6DevPsQUI6SG818WeNNZ4RGGEfDEd1ilbbZhp89fZ6EMFVzeaLFxGZ6260kjhJ
	yR4xj2F9ldkgKPniOw438qavBt1xI2dL1Ro9/wwkD3Oi4F5jxtSEdlUPm2ndv69+B2JiDu
	SY4icwOqn4XENmTgXxqi6YGr4dDMkIg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UpLwd1wg;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kyqcd3FBVuM2mNP4trmIDwWU9GQiAMQYkdXDbyMf08Y=;
	b=LetY3JlhKrX3XaCn5d/h+hvhKtwvdodUFY+wHyRMQ/HuI7cpknwwXKEcxChBgfseQIz6ga
	HJ50ut19OU4a63kmnxQr6y3aFgnMpZYRLSeVK+Hob5c2+AA0K8Fh806rlsJ/aLWSn41CtT
	6MnNVXoqbuhFBpJAdG2oC/BXQ/kQmTo=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90327237340so1546106d6.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268041; x=1785872841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kyqcd3FBVuM2mNP4trmIDwWU9GQiAMQYkdXDbyMf08Y=;
        b=UpLwd1wgFHeRlTIY5cUd41+p8NZxrb2wbyWGJRakRAE72kF1KDBXi2azTDDbyKePuI
         BVhl4RuRiMkZrtkYfkWmfUrlVjWG3UACmn1UktesOicCynRn/X/YWi+2dySpJ1VCsqvY
         ddDUq0jUW1vcN5qi/QTK14gYRhDT8JuBimImYcJUYSVeVdU3mdG6V734hGfbtMX3paIL
         ZIaDQZUh67jmd9RtKdYwrzGQ5foRw9NKEN42unEjRW3snhTND5bMRmrRNMuezyRbH1iv
         0tTcP//Ww5fYxo/9fQupNFf6CGxhpAzoNa8fXbv1sXZCFUePvF6J8XKuDug+it8HYqST
         1jZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268041; x=1785872841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kyqcd3FBVuM2mNP4trmIDwWU9GQiAMQYkdXDbyMf08Y=;
        b=e+JdGSCjew0R2KbjEn3Jrt+1r3/tBRpVv6BABCXeoMcaHUiusfcgpubrYwgdEmAPC/
         p7RU2ENa9jQF5X6vbA+t/1urtM5WlCr26892zmV3J+HJRiEcfMTG8t23TzE3zSwEV7FY
         nixNzZh4dLPqLsAO/Mk9tBDFmI6oGAjMLEpqc7Zg3bpxkLrVCJulP6XJ3wZx/px7jeZN
         +ZfCHRaXSjQ6p//9mBwOprxaVtGZ0+AHsAPwXe7v/0doeg7iO5skKdOqeFbUVKWleuNH
         HXP2dYtBn5PAUjX8ojHbKryYr+OgNxuieTxI5xCime8xW8fhiItlB3/NMLebO6/0xi/s
         nUtw==
X-Gm-Message-State: AOJu0YzYBov7Dx9W2vP3qSzqombIxesmAUuumqsN4/CmN0MMz1GhSnyy
	yTFZK7ua7+wbfm9PRHf3U50P5cuaXNTUss2w97Hy7O8wp/9W3TIMKGWp+PhslU7z48rImiczmM1
	OYVoK
X-Gm-Gg: AR+sD10kLOg/LA6a2C1s0quNvnTj9punAom2R355aoYNwdKVasNtvKeKkq3iMtb6h5o
	fl7FwWY9XVRqYA4b9GZeMQTcQDh4jAdzy3K4AAh54P9AsQ83H1GfyiP+JwUYnvzOEgJRPdguR3p
	YSx4NdjBsFBOnL7xUCW3ePrg6XYZsSROyS4o3yAi7rhjj0grVUkegqyBJAfIwpQ9/a5RkWO0/Z5
	PwuqiahaMI36kwjjfKfJ6HwfdDB9B4AKdtzBB79pMPlYvbbpdlqLfKJTDisMbivNPYeLicpQQQ7
	MOENgNVMaExxA8rUhhx14g+jSp6Y/ofvEqfFS6cPa8nYVc+7GtBKEGRhrmCfKlWDcyUKQpWD9WD
	3PnenHkvYVrM1xpeNgW6USip284sy2kZ5KPOxHyRrjdR9m7/cYkOJUdZufbtgW7PpL50pO4skqw
	+YIP1CrhfkwIHoH1/bCkX9DyS5LS5xsuv2ER80yG++pGBA58+LTifqZpPCOihgKiMSjv4mTlNs6
	Y5btJO6dZl4+59tE0vPSOZAOcU/vy+5lSLF1uiAlvBd7iPl7A==
X-Received: by 2002:a05:6214:2dc4:b0:8f1:4bff:24dd with SMTP id 6a1803df08f44-90816fe5139mr44135256d6.5.1785268041215;
        Tue, 28 Jul 2026 12:47:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6b539sm6700176d6.41.2026.07.28.12.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:47:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 0/4] mm: reject zone device folios in more folio walkers
Date: Tue, 28 Jul 2026 15:47:10 -0400
Message-ID: <20260728194714.3713735-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 28A71A0012
X-Stat-Signature: 1z7ufzky1hipj139tqxikmht44ik69wj
X-Rspam-User: 
X-HE-Tag: 1785268041-306346
X-HE-Meta: U2FsdGVkX18+e3KzRQzLbVYXSmdKM9eQBm/tJ+/SHGVo3nrDnw6g8L8uMeFZjS/XD7NrRQmHTcV1eyCAQABZJSM/JsBbsle55t1v3mJ4qgLOpcfawLJ3ru8KIbzliNd2YwaDRvp11sugxLPUwD4FH+Ml+CSYVadNbiW5pOaBvlMXO5MPpTHgqDUtdjQZJAhIUj8dg8zkKd7xn7eePRJegRFjp07w4ptTIpVEkK7d0nDyVr5X3CAH0nxXeF086i3tZwwcik1Jb+MWxtBC6gaGkVMc0ficAjImvEANoeq07rz5nDmgQf0whNA9CJgF1mMfNOu0YoE7RSiz3tX68jaOzNA/1PyDEouHkmA7eFt1RXAd2TwLxG3cgALG1Y+sGvTkYvBJO3w3LoFqZ6VMiO6RjZ9DQQ6ag52OpZhQvS3sQt7VE+CbzylvXMur3xvzwG4KGA4n0W2laO8lQ4pe3+fEDlJeKHFjoYFBf+kwagifISXq9JSXKXPt94suDvgZVYT8qH+mZftc80vLJm4kdl2po7XLlek1JBW+nh4K6tRRcYAGlm/93N0AjGy8WWM6/wawrbkp65t45wfBeUUBRBIT+XfICTEEk4mf1kUTSZIbvRIn44HtWEFHdgSfIuutbYp6ZS3h5cArS38d2bqgyQN5BHCvfRVy0AXCQZrPPIQooDtlYFYBrp1Ba4NXs4UBkdvj0fIbCLoJHtw8iyXyhsrmoOu9PV2p8U7T+Tz+QLwqpPJoASy8sVyiX+Dy8KZiGljPTTBQJKThXHHUo9jjzZ+PvkHaxG7fqLVe1XrLaS/Ilc7zURWXsFLBWqop6jrF08ioDnP4JBMYR/zGU4NYjzKN95cNgDkg3Smm92jG718Ddbl7DE+GzyvfyIjG8hEJXQmtiXRFBxsTsfWomj0eYj2durmjJsTgbq2aE70D6DDMrXBX0hiRf30Rmzao6oHa7QkOYLmEc59g6NuSHvtmxCw
 wrteFjGG
 SdH1bBGFsNSQH4kPi1IvN5IsQznsIcOb0NdfyHot7gC3K6yqL+2ndOgdYQHd/O4ZZsUIqLNz3z8AfUKuADpHBAwANsrgZcH+7h3Cl5jirjMjaz3sAoXyjCKSxUadhu4/uNFczluCiDkadoHAtEfbp8sg7P0apld78Q+dw7nveSlxsOF9WhH0nMjwaXWmPitS5hu+wjkKTHHEn/lzgc1r5m3s0PvxQRlCw6arTLzVzkp+4Tnx0Ig19Wy1mPcJ/ZE2bAMDJc0TfywjOBkhHJ07iomxCJte3cJwk3McW9qdh1KvcerUg0PrRsW4ZuIya0dk1jFz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several LRU-oriented mm walkers resolve the folio backing a PMD/hugetlb
entry (or a physical pfn) and then reclaim, age, migrate, or lazyfree it
without ever checking for ZONE_DEVICE memory.

This series adds missing folio_is_zone_device() rejections, matching
the checks that comparable walkers already perform.

The changes fall into two groups:

1) Genuine gaps:

 - mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
   only filters device-private entries (which are non-present).

   A present zone device PMD (e.g. device-coherent) would still reach the
   folio and be lazyfreed / aged / paged out. Add an explicit check.

 - mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
   (e.g. device-coherent) and queue it for migration.


2) Defensive / consistency:

 - mm/damon: damon_get_folio() already excludes zone device memory
   implicitly (pfn_to_online_page(), lru checks).  The explicit check
   is added in the single damon_get_folio() chokepoint so every DAMON
   caller is covered uniformly and the guarantee is stated explicitly.

 - mm/mempolicy: queue_folios_hugetlb() cannot see zone device memory
   (hugetlb folios are never ZONE_DEVICE).  We add the check to keep
   all three mempolicy walkers consistent.

No crash reproducer - this is a correctness/hardening cleanup found by
inspection. All checks are placed after the folio is resolved and before
it is acted upon, on paths that already hold the relevant page-table lock,
so no locking or refcount changes are involved.

Gregory Price (4):
  mm/damon: defensively skip zone device folios in damon_get_folio()
  mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
  mm/madvise: skip zone device folios in cold/pageout PMD range
  mm/mempolicy: skip zone device folios when queueing folios

 mm/damon/ops-common.c | 3 ++-
 mm/huge_memory.c      | 4 ++++
 mm/madvise.c          | 3 +++
 mm/mempolicy.c        | 4 ++++
 4 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.55.0


