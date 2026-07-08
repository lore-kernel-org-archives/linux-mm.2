Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4540FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0196B0088; Wed,  8 Jul 2026 19:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60BF6B008A; Wed,  8 Jul 2026 19:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F696B008C; Wed,  8 Jul 2026 19:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC566B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:48:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C73C1C3355
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:58 +0000 (UTC)
X-FDA: 84967252356.30.B24FC38
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5882080002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bxyZfFzb;
	spf=pass (imf02.hostedemail.com: domain of 35uFOaggKCD8tlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35uFOaggKCD8tlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554536;
	b=l6OxjwEKSawE4RAXH958TaT8J95qTQZb7en6tm/j3fNfcRqisfwcAYfRNE3OMnk0yapYUB
	WO8JvK/cWezKMj7zQWHPE0BqNHHZI4RXOyzQQHqX/WZP9JJN7ZGdmS7EOnOJELZAhWkupJ
	Xf1z0j2+tsVPDVK0CydZIdjM69L0fU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bxyZfFzb;
	spf=pass (imf02.hostedemail.com: domain of 35uFOaggKCD8tlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35uFOaggKCD8tlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CKctKavL+T1fCBJtVjfwPQ5K5bQzru9zHJrkxaBJCqQ=;
	b=uHF4kmIVNKHBIzOd5jM68IUL5of17jEsW9jjck9ohh5/j1JcvQux0jUgg82uA86D7EmADN
	nB5HpNOmDsNw94RET5EbqBsEMqs4I32iQo+AQosmdHL1H2dWpGww+a7fU1BRX/ludAfsmQ
	t7g/kCsDk9STxSF//d7ZSabF8e72Vaw=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8478423e020so644165b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554535; x=1784159335; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CKctKavL+T1fCBJtVjfwPQ5K5bQzru9zHJrkxaBJCqQ=;
        b=bxyZfFzbm5S7VN8XzIxBiNpV8XCnDl0iirZsb1zpSF8o1qGG7ScnfW1akzFDiLIAen
         x0vpTbJ1rdXxkAMlkz5fPSpzOeG8da3xO5FFV5G4y0656iT4ckG2Sk0zLxCbqL5jLWR0
         lv2tu4GejctfQq/D0AxTKPKEb8KjHAysktdw6D5vLZWCAvC3BJeICmmouHjwqQzIMTho
         C1p5KEHtbQbryT5mlbtpEJVj7e3SKcCheFfJapNFuSVsingUAYfCsJLCCHjRXosDbYIq
         55J1OuMfwPd/rKDGd1hSKdaB31Dx0Gocv9YqMs3KehvRazQuwhBr2SU+QMdg105rseMa
         y6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554535; x=1784159335;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CKctKavL+T1fCBJtVjfwPQ5K5bQzru9zHJrkxaBJCqQ=;
        b=mv4nZFLi6m7n1nFnKVTbXgwAr2oulhP7LcJH2GhigwjrOTPHau3RUskRU1NTPOg3we
         r6WlFET6trHQ0ubLlkZ/q60wvCGe+qzp547p6YkCeFzVGHd5J/x+lrXj7Gs5sBgEVG9N
         lXeaAmGy7gcBUXbGjzoqj7+zeGuyRRs4AyPHWAI00J9UsP9Ux4uMU8D6ERyiXdeaP1kr
         u/XDwJsUApGBfk0Hr39LY7A+DCvT4VbyZ8FimTWgrnff06AEpX+s/tWUcNP0oYV3K0Lw
         4tUt0v8XparKIk9kjYMxAjpIxnwoAlOtketw7hkZhDEYZX4FNZLnpJi2piGc+en8NJAJ
         yXbg==
X-Forwarded-Encrypted: i=1; AHgh+RrmuAsCTIQufM5AB2oq5qy4YwRZ7pAELk3Wm6Yh04q1nJ0GV0jEQer1GPyj1v7mnZ4xyqMgptzF/A==@kvack.org
X-Gm-Message-State: AOJu0YzHhvLSbG54NSIgkSuZHlUNLSL9Q1bACRH4WsPnueyf2sBZS+Yr
	lSYAQgkCjHfM8476lzragkEatvBAoI+icG+4kb6gTesr/6rWN/4Y7zP+KUI5zQVv9Dbbije+bvU
	+dqt3ZhQdzloiug==
X-Received: from pfblh15.prod.google.com ([2002:a05:6a00:710f:b0:845:eada:32d2])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9513:b0:845:db8d:f631 with SMTP id d2e1a72fcca58-84842ec1f1dmr4624788b3a.7.1783554534952;
 Wed, 08 Jul 2026 16:48:54 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-1-skhawaja@google.com>
Subject: [RFC PATCH v2 00/10] dma-mapping: Add preservation of direct allocations
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5882080002
X-Stat-Signature: 6e5hqxuck3444mkgptfp7xx7ug7tk19k
X-HE-Tag: 1783554536-184924
X-HE-Meta: U2FsdGVkX1+bQubQTCpytjEASVEWBxOHoHp9sSni/Pm7bZNL8kjjUUCnBzLE1iEmJt2utpMuR9YrksZGUnv00yJL8B68jMhLW3OJBJ/9KqdK8spxkfKEZvVE9XKEaH0TmPDFVddmN/0aI4pDCLJsdJTn/IlSGlxWClkGza42GeHIYNFK/swFJu3sSS8bqXENol6goHkc3IUKmQ1ChneO7PQymbF4UjBmc6w8w23CQF5kNjEE9mqz6nKnrs+CH7ZqT7Jl1Tp2N7dfYR1Ct3qm+iOg5QfHgVzS50+mquYJGpnF1omDf3oAC8aLkkgCbBe7YHbJbhduZ6Qub+KBGR34+rFIafF39gQLD9YeAaoouL1wTmJG8+zCjc1MGaHhMn50CyTI7M2DZpJbwhS7aZHxSrpUshggCQ9kzxNQAIpRl95ygD7qeUreRPpESo0XLvRJHgmh07Y1oeqwIcOfZ+ov4hMP2PvbvEk43qwMxGTm40Auj0D4eF1Y5McxjJiQm4EpQqhpA71Z8o/NI/7Q8wktH67pcyctOXRaSEi0upV3XXDcglNYZSYsebbNdJpWpoygLpvZKa/Hm0KzliKr+NXfuPIkrLimlNY1ML0Yx/qbI+AbkcfpBs3nVN8EZWpzzOVWPegaNBxCTybScA0uUG7NAKmrTSu25myJQ8RrHn0rcEsnG3kNIILfFgtOgrdk/TJ5UEe5NSgUVHHJ6eI0d8wcPbMSl4QtuJgh/9rabaDHCWdiz9Y8/i7B9hTFBrpMR2s7UhEsmPKXgXORw5cyYEWTxPdR6iAxOyz4XPYA12zsbIMmspG67KRkmlfQFPr9GI5baFFz6KjjnFlA7eBjxGIa93/FSy/G6RqrwP3wKCSp2K2MlGRO15IMtyX930++778KRGBGDS55XYFCdCpMd3ZKRKquBR7vRUcBAWFV/hCc/NsJEY4WxqVS14HsPBlVO0LovDFHMqEuzl+jk2SrfE0
 vWmlvjUS
 ltqkBnv74c4bMJq+Lggl8PaENzz7sx+T5DRAEZDThwmsjtbfVulvTQ9qpxz6M/if9FvDVCmvF2BGpgvmrzkNsgMaX8/L9bKhrpAJX4jzKKHMof4Q0QiILUYUGU9rq10El9uNpBVPlSrDG5xAeBeMxGr43FSBdaZEDd6xRFdqTFSDCcOx8VWmdNfCojO8R0EqtTKfQ01pgwhIOyYVp+lxbAQnrV7NF3Y6LExIA8V+lphPqp/x/anuHvaurprEa1XTfnwocAH1Ui+chCR1+Ezss+ghyJUoGkxqhDywwZAq5YvdsRVghC1Za/4o5H0c0WeBC/tis2fC7TNCtp47w8mA/uElcTKiTIRnbo7iNWlEzBclZGww9YLzMIBs0AJIg8kJiJ1WYUOBdnaH6Z/UhAHpQqz8wHeTRLQAcVJ8z8+Y04ro0Ybvjinu5NdUTQR6q6nwXK69TseEHEHqrB/U3xp+a4Cqzivc7B1I/VyBoWPULdBZtIJ9JC49KPdn/kedzfGTo/NeDQtsmKAKUY0UU/DZBgmCKhbCWQ5BcN7DpW+TCRjohVGJi5y6Rd9bB74lptN6yS8ZjpTH/x1PkoKHx+MnYV9eBL4KgDhe588OySU0pLIvDOsBIjFISK3EU09EJd6mzxDO/USL1T6Ua/QU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC v2 to discuss the preservation of DMA allocations for
devices that are using direct allocation mode. Note preservation here
means preservation of physical memory using KHO only. IOVAs and IOMMU
mappings are out of scope.

The complexity and need of this was discussed in the thread mentioned
below. It was proposed to allow preservation of only a subset of
allocations with minimum support. Offline discussion with Will Deacon
concluded that this series is still needed, because we still want to use
coherent allocations for Arm sMMUv3 ste/cds, so sending this v2.

https://lore.kernel.org/all/aepfYzkI7NsVGCF0@google.com/
https://lore.kernel.org/all/aepRy7Gp7Ng85Zr7@willie-the-truck/

Note DMA allocation allows memory allocation from various allocators in
various configurations. This RFC supports preservation with,

- Direct Allocation Only.
- Pages allocated through alloc_page (Buddy allocator).
- No CMA support.
- No DMA pools.
- No device coherent memory regions.

Note that this series does not include/use the page-split and page
refcount fixes during KHO restore, that are in review here:
https://lore.kernel.org/all/20260703020832.1731864-1-praan@google.com/

The changes are also pushed here:
https://github.com/samikhawaja/linux/tree/dma-alloc-preserve-direct-v2

Testing:

This patch series includes a Kunit test, for testing dma allocation
preservation, by using the KHO stubs added in a separate patch series:
https://lore.kernel.org/all/20260521193202.746810-1-skhawaja@google.com/

The following test runs are executed in qemu.

Run on x86:

   KTAP version 1
   1..1
       KTAP version 1
       # Subtest: dma_direct_liveupdate
       # module: direct_test
       1..5
           KTAP version 1
           # Subtest: test_dma_direct_coherent
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_coherent: pass:5 fail:0 skip:0 total:5
       ok 1 test_dma_direct_coherent
           KTAP version 1
           # Subtest: test_dma_direct_non_coherent
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_non_coherent: pass:5 fail:0 skip:0 total:5
       ok 2 test_dma_direct_non_coherent
           KTAP version 1
           # Subtest: test_dma_direct_coherent_atomic
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_coherent_atomic: pass:5 fail:0 skip:0 total:5
       ok 3 test_dma_direct_coherent_atomic
           KTAP version 1
           # Subtest: test_dma_direct_non_coherent_atomic
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_non_coherent_atomic: pass:5 fail:0 skip:0 total:5
       ok 4 test_dma_direct_non_coherent_atomic
       ok 5 test_dmam_preservation
   # dma_direct_liveupdate: pass:5 fail:0 skip:0 total:5
   # Totals: pass:21 fail:0 skip:0 total:21
   ok 1 dma_direct_liveupdate

Run on arm64:

   KTAP version 1
   1..1
       KTAP version 1
       # Subtest: dma_direct_liveupdate
       # module: direct_test
       1..5
           KTAP version 1
           # Subtest: test_dma_direct_coherent
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_coherent: pass:5 fail:0 skip:0 total:5
       ok 1 test_dma_direct_coherent
           KTAP version 1
           # Subtest: test_dma_direct_non_coherent
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_non_coherent: pass:5 fail:0 skip:0 total:5
       ok 2 test_dma_direct_non_coherent
           KTAP version 1
           # Subtest: test_dma_direct_coherent_atomic
           ok 1 size=128
           ok 2 size=4096
           ok 3 size=8192
           ok 4 size=12288
           ok 5 size=32768
       # test_dma_direct_coherent_atomic: pass:5 fail:0 skip:0 total:5
       ok 3 test_dma_direct_coherent_atomic
           KTAP version 1
           # Subtest: test_dma_direct_non_coherent_atomic
       # test_dma_direct_non_coherent_atomic: DMA allocation using pool, expecting -EOPNOTSUPP
           ok 1 size=128
       # test_dma_direct_non_coherent_atomic: DMA allocation using pool, expecting -EOPNOTSUPP
           ok 2 size=4096
       # test_dma_direct_non_coherent_atomic: DMA allocation using pool, expecting -EOPNOTSUPP
           ok 3 size=8192
       # test_dma_direct_non_coherent_atomic: DMA allocation using pool, expecting -EOPNOTSUPP
           ok 4 size=12288
       # test_dma_direct_non_coherent_atomic: DMA allocation using pool, expecting -EOPNOTSUPP
           ok 5 size=32768
       # test_dma_direct_non_coherent_atomic: pass:5 fail:0 skip:0 total:5
       ok 4 test_dma_direct_non_coherent_atomic
       ok 5 test_dmam_preservation
   # dma_direct_liveupdate: pass:5 fail:0 skip:0 total:5
   # Totals: pass:21 fail:0 skip:0 total:21
   ok 1 dma_direct_liveupdate

Looking forward to your feedback on this.

Changelog:

rfc v2:

  - Add dma_is_from_cma() to check if an allocation is from CMA.
  - Add dma_is_from_dev_coherent() to check if an allocation is from a device coherent region.
  - Add support for preserving device-managed DMA allocations (dmam_alloc_*).
  - Add KUnit test suite for dma-direct liveupdate preservation.

Samiullah Khawaja (10):
  dma: Add DMA allocation preservation KHO ABI
  dma/pool: Add an API to check if DMA allocation is from pool
  dma: contiguous: Add API to check if an allocation is from CMA
  dma-coherent: Allow checking if allocation is from dev coherent region
  dma-direct: Add API to preserve/restore allocations
  dma-mapping: Add API to preserve/restore DMA allocation
  dma-mapping: Add support of preserving dmam allocations
  dma: contiguous: Export is_from_cma helper for kunit
  dma: pool: Export the is_from_pool helper for kunit
  dma-direct: Add KUnit test for liveupdate preservation

 include/linux/dma-direct.h        |  29 +++++
 include/linux/dma-map-ops.h       |  10 ++
 include/linux/dma-mapping.h       | 100 ++++++++++++++
 include/linux/kho/abi/dma_alloc.h |  32 +++++
 kernel/dma/Kconfig                |  12 ++
 kernel/dma/Makefile               |   1 +
 kernel/dma/coherent.c             |  11 ++
 kernel/dma/contiguous.c           |  27 ++++
 kernel/dma/direct.c               | 189 +++++++++++++++++++++++++++
 kernel/dma/direct_test.c          | 208 ++++++++++++++++++++++++++++++
 kernel/dma/mapping.c              | 132 +++++++++++++++++++
 kernel/dma/pool.c                 |  17 +++
 12 files changed, 768 insertions(+)
 create mode 100644 include/linux/kho/abi/dma_alloc.h
 create mode 100644 kernel/dma/direct_test.c


base-commit: ec4084bc445027a52f600e30a976928be1ba1950
-- 
2.55.0.795.g602f6c329a-goog


