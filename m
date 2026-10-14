Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA67C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A8A6B008A; Wed, 14 Oct 2026 14:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751D26B0099; Wed, 14 Oct 2026 14:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668326B009B; Wed, 14 Oct 2026 14:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47C996B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D420E120284
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:29 +0000 (UTC)
X-FDA: 85322072178.17.C052C29
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26443100014
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oTHDoOqq;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P7xbCPpW/zsnuJwej69E4oG2AFvFJ1oiZH52zWEjges=;
	b=n8Z0h54OI2KerScjAtguvZZnjyWRGvv4l4EUTLa87pxg1ICBgQ2b8gN5y5d0faRR8SO54A
	i8KR+mcUr/oj9t8m7lVOuPueZrxhKFkI+vjKkAJSpi6PkKx3wffMfEjDQhT0y6JK315SaZ
	WWgYAjs8XkdEMNB0gScw0Ti2g6ksmNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002628;
	b=8S1bxhy/G0fdDHija3ShUNL5JcqbLyraOwP/4CY2i89Z/keNH3RfBk72Gdc9o/QCavqZG3
	CSO/db9ZxT3aPDEiP8NhY2DrlmqVECt+sDOzOcgS+YejqhcCzWTqGoqrnxioSNtZ78EJSf
	vWZz9CpyXB5fP9y+Rgx3M1OdwBh9ZvM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oTHDoOqq;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92ed3993c1eso52962385a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002627; x=1792607427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P7xbCPpW/zsnuJwej69E4oG2AFvFJ1oiZH52zWEjges=;
        b=oTHDoOqqOkBc6BPmR0eDerkC3/eKihvQecG/uvtxH4/nQn8QOcd6pLLJegYI3icGUl
         EmQ4m0vI+JAZgRbkkRdzE4lnyLCE+w1vYxwMED72NtAdBzUSokj7HEZrjtPIR8km0UkC
         Q4ULlZtI+NKK00HQ4Bc8lJ34+mfwqFR7yaIcyUt/gOvVBJsXqneXEyFS2KxVXpe3QnG3
         u7VnmQBu57CbG5fpOEsdIahxZ9t99kezT2uzppK/qGYkBM2k2s9rhxWmVhnXy6OY1HiC
         vf8RRPmFHpQhp+Eh/Ysalv1JuMvDcLVwTiNeDhEV05QUja+M/ZLvOHsCCulrb8uZIBPK
         TVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002627; x=1792607427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7xbCPpW/zsnuJwej69E4oG2AFvFJ1oiZH52zWEjges=;
        b=fyJwdUUgiwbxkPG5vkIPEnnhvjDcstGfd4nG5KzoVhVDUjBcXCbzCLgFvsvKS6yx9H
         LyRc10pkmGAgL4Ptq3kA9XEoox+m+lm7rub1844jsri82aYm1Zb8kBEloHnzi+upYxZk
         bKMqxJwFtdwE006A2ZYXkpgC0sojVuMN1GccPyHdRERO3BAMSALKUcJBDdjxt/Vqhw79
         XG9tpZnXXYDPoi9Vj4YAGYG2J6uTLU2UEVlnoJUsGjlV+0dUVIaNtEX41GYyq/xn3eqr
         RhjOfuRI0UKUhyKsr01hsdyfwlt6WextZqk6xAqjQRQGhmSy1n4xrevn25Gx5DHRwuGG
         WxZQ==
X-Gm-Message-State: AFq9FYJjH1D/0EIC8AcL08dsp6J+f9cS9ESaexwxVvhpj8hCHtYNSA8g
	fUTf+gacqzdqklal2RsrFiqtx+a12svtjeykzdmN+LrGKbhyHt0H8m3qs0Dv9dYp853tlz9QkRc
	2MjLjV6I=
X-Gm-Gg: AYBFou1PL/9PHsFRI6S+7LCYDsodfsn6sXUfGGd3AEAXSpht6B3atFgmZ8Hqpa4uvOf
	O63JTAKVb72HEE7SN6MT0mG5oIIooFzSboH+qvV0o7qbR6H2KjcuakqzeQJooYlbnu1WOl8lGth
	oulj8SB4qBVyrfdeDnjhzrpi1LnGCE5j7d587h1dVMCrUkhjC9XzCzXs7vardvZ/jsQRaY7/OvZ
	LJtX0PYUUBEXsQH8mNpFliniu0Nt97YotsLOsN0J3Cv0ZcGrOAWJjHM5H5+e1Ccm75Y/eizsgoS
	bP/XbvIBLr2uSi1HFwp+TJjYCDcYN3/liymceiio0NZgzqVV03gcGv52f1rl5hjLMpB5TTCPSDW
	uu9LRIYWw2A+7P4iaqBymcJ//VLuex0Bsr3WfZ7riaZy6ZInFlQznwq+lM5eG3TKXLcFofqcSEe
	bvW1T45WRCaVAsVWjgjah9PNDEhP+o6MuMWPvDZ43sNu7XR1XZxDbiyPyBKVwZVSuS4OIin36yR
	y6c0vMiV41qdQDnO6SLCvtA3YWyCE672HObxsYrgRVdKSm0wnqH3M1eWdWt3g==
X-Received: by 2002:a05:620a:bd5:b0:93c:76ca:4260 with SMTP id af79cd13be357-93ebd275afcmr2760169785a.52.1792002627012;
        Wed, 14 Oct 2026 11:30:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:26 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 00/10] mm/madvise: refactor cold and pageout page table walks
Date: Wed, 14 Oct 2026 14:30:14 -0400
Message-ID: <20261014183024.2075709-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26443100014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6e3dp3nni6pp48goattzxy7a1p7he194
X-HE-Tag: 1792002627-446490
X-HE-Meta: U2FsdGVkX1+nRdJlqKfjxug3ZzCCJVaxoEK6g3F382F930TJWCjgX3eB5LpYdwILdB0tS7cFjGulPuKbMfj836EaUFa2Dr42tZgTGrp24cLz8tjMu06LHzXq5HqPksCEQO/sz2ulJPNqorAYgzNd7ebHoviv8lyCksJVuiwDmT8EHZ2IBAVky7NQIh+yt/m4/F3dMRomkycRVq/9nzvSovhZjw5AvVaR2Rgj9b7cGON5K9dHqsHziIQuhMTolGtW8VQg2+0Z3/maGZgCq6lU39W0WMqbWquegebyb13+aHPkAXUPV2QJv5nk59AiKQMERayLeVR+Rr8ULt5fofT8FKSIvG0rKhqPPBcDPHuMiH1/PQ27JF+OyuB8x579yZRB+1ZEc8G/Z/ZcKxPIQCX/PAzK2ATeXvnJQk5BwrY9d5aoK/ttTcJza0P8czgqS7t5tRWna7NmKxTtvM1P9J5bp7S63cDgn7rmbjTRt+KAhJQ9RlXV+n4MzCNgWQ0nEQ1wTZVKq6tbxsFUT3aByUmCV6z2miKKBd/1SVJJE2a9PpB9HUeFQFMqQdf8Oo07OPKTc3R9+4qALYevJWThBFN74VFvSC6MHcjpRnffyajXe+78qWaF/g13Oc0p0AhKXVj18vXQMxtH/RIElfa4aFgeWGZ19uF+H+OcUf79dgQBverLGrYqdZD8uRAbvynucWom3u/L892vWyRR5Ls9CxwQ1vOsnUXwP0njfIDF55mE+wd37xrZUzVGlJwxg6BKqHvP2NrZo2c4f5zGS/ZzZqna+wtLZx4WQoOVUWc0Q4/h9spJ20YXOzfI15lMPmRx9leNgY9RSN6E8LwwOB3WLZqI3T4rutcqYrNtA6fFRGiHIImCMZdBAVlG47dJTqFsVF1cMQ/HH8q9frpc1vcnNPvto/vyJ2o3Hui9e5QifvXPHMQPOwp3BDrqNTcqy5PGMfGEg/ninh0SkQuYnthwqF5
 Ci/UcTH1
 Oszq9o+YhoAb0XjcT/XEsKFPIkHtG/LQugR2QOlCFP+pu7tA/R74Z7FdwBgQEtVTr7Nj56Lz+D4r2AhdXYMtrwFmpWULtNm2lmqFR9EaEVVU38/tUtck16nEcYNHh/HKns0L0jWgJhmUoz9F1DMiZHFvHW8lCPU4P5dP6U4GujeISFKrzw5bVgEOs2E+JPFcDP70T9EG80C+nuxGwCl0mcj4F9Zw8NnjBh7F/JbNQQBduRwJ8iOagImSL3cR3FtNUy3Ug8+HKZqQmkpuKAkCQsa6sP3lwjB2pZAPAygTwyxF7NWobtkXjlkZEzcbFoIyxDUj6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLD and MADV_PAGEOUT share one page-walk callback that handles
huge PMDs, PTE-mapped large folios, ordinary PTEs, folio splitting and
deferred PAGEOUT reclaim. Its control flow makes page-table lock
ownership and split retries hard to audit.

This series splits the callback along what each part owns, with no
intended change in behavior:

  1-3   rename the callback, share the folio filter and LRU handling,
        and use pmd_is_valid_softleaf()
  4     factor the folio split and release used by both paths
  5-6   separate the huge-PMD path
  7-9   separate PTE-batch processing, the scan under the PTE lock, and
        PTE lock ownership
  10    share the mmu_gather and page-walk setup between madvise_cold()
        and madvise_pageout()

Helpers used only by MADV_COLD and MADV_PAGEOUT take the madvise_lru_
prefix.

Testing was done in a virtme-ng guest with 4 CPUs, two NUMA nodes, a 2G
swap disk, 16 hugetlb pages, THP set to always, CONFIG_DEBUG_VM and
CONFIG_PROVE_LOCKING. Each suite ran three times on the base kernel and
with this series applied, with no warnings in dmesg:

Changes since v1:
- Moved the selftests to their own series.
- rebased on top of latest madvise fixes in mm-new
- Split out patch 4 to simplify a few things.
- Reworked patch 5 (Lorenzo)
   - split now happens in madvise_lru_huge_pmd()
   - patch 5 only factors out the folio lookup and young-bit clears
- Patch 2 has style-only changes:
   - madvise_lru_folio() is no longer inline
   - madvise_lru_folio_is_filtered() gained a comment
   - some minor formatting changes.

v1: https://lore.kernel.org/r/20260922235830.2350770-1-gourry@gourry.net/

Tests:
[0] https://lore.kernel.org/linux-mm/20261014175756.2035176-1-gourry@gourry.net/
[1] https://lore.kernel.org/linux-mm/20260922235830.2350770-2-gourry@gourry.net/

Gregory Price (Meta) (10):
  mm/madvise: name the shared LRU PMD callback
  mm/madvise: factor shared LRU folio handling
  mm/madvise: use the PMD softleaf validity helper
  mm/madvise: factor the cold and pageout folio split
  mm/madvise: factor huge-PMD folio processing
  mm/madvise: separate huge PMDs from the PTE walk
  mm/madvise: separate PTE-batch folio processing
  mm/madvise: separate the PTL-held PTE scan
  mm/madvise: make cold and pageout PTE lock ownership explicit
  mm/madvise: share cold and pageout walk setup

 mm/madvise.c | 473 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 264 insertions(+), 209 deletions(-)

-- 
2.56.0


