Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C3260A3806
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YlbvZw5M
Received: by kanga.kvack.org (Postfix)
	id D96AE6B06DA; Thu, 19 Nov 2026 20:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47BA6B06DB; Thu, 19 Nov 2026 20:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36706B0717; Thu, 19 Nov 2026 20:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91C8B6B06DA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1EED1A0D0B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:04 +0000 (UTC)
X-FDA: 85453708368.01.A9F1CA4
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BAF440009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YlbvZw5M;
	spf=pass (imf12.hostedemail.com: domain of 3NJ3_agYKCMs28zGG5x55x2v.t532z4BE-331Crt1.58x@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3NJ3_agYKCMs28zGG5x55x2v.t532z4BE-331Crt1.58x@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136822;
	b=dOro8jBO3PZBhDBq7lLPlKBEsxQ68ujt28gtNQ5MJBQNUFinE1p43juWtcAjknxl4V6WkD
	UsruP1nfNdxU5L8PYRQaufaLTI/b6iGuI9dY4rUQN045wtvJxEHQVhfRXdlrAtcXJPWFsY
	yPfPMOOLitWF+8ZhAeFisNb5kogWpRs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
	b=i+qirRrtPiVPMRcr51qXECgkVMufUXgR0uqAuFdwyYznUJdi1ae4Sr9e7DASs7SsUx+dk8
	nLDXKvfbLRJcfpl7iXPFIjEvSjXuT3uB/cfz5RT8GJhZ9Y9IFuGl+PPx/NeonlUxdjtnR8
	jn+WGCh18ncmQCx670+CA5xyDawZGKw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YlbvZw5M;
	spf=pass (imf12.hostedemail.com: domain of 3NJ3_agYKCMs28zGG5x55x2v.t532z4BE-331Crt1.58x@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3NJ3_agYKCMs28zGG5x55x2v.t532z4BE-331Crt1.58x@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c50715e8328so26446666b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136821; x=1795741621; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
        b=YlbvZw5Ml1QRZRc/VIFjT0+wxlLR5wES4VZT+n+B9mF4Spvhk6jn1TxGhMotKUkx1A
         VAkS3GgIFX+QjUNZQLkxRrTpwM0Q5coEMBiOnbq7VBkLORHVoYTONLnyXj1XKt11Mo0X
         d2x5wlKUxTCCO3sMMmEQzycjHTQHUsKDDhsQOYmVPuaHifOrLfqcpNhOiiZ2nPKEm3eh
         +vqRtz7cWbh3zky4Gzr+mo3nc/wDguTDJYH0IyjcBCvZ65iRaGWhdSYvA5SBvGX6fbPj
         5vrX53/fpe9QRoGcd9uiRhADobnEHoDXks3IwwyShWNG1litEYKT7BOV6TJGbvD/3ehb
         /CKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136821; x=1795741621;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vRgEV73buW9GBPSCDuFlhibk7fFdXhSeJd+kw3YQM8A=;
        b=lJ3oSOqj3OamAGsCejoVdCmWz1BqUZHXuFqrpE4YDrJ7bFRY+yTlZzeC8OVrGyKeiG
         q6BAe7DmPBXKV7vEUxth4mmez6tBegwxNjOCNFHVqxMBdYCfy/f0s7AS3jgasng9L+MZ
         hXyWAQEjlLVMmVg27GXwOEfl0eYyffn4Gbd1iiLmUQbckLl51AVbHjgJRNXLApb6ItcI
         svOgyTcXKA0IRA/Lr5JggCMZd9HqNlcs+pXCHatJks0NeBKdPj0vzRmrxX2ISDMPZdrN
         0ZFSfiVtyggAySZ5oWF5Bu0sM4N5Epu6o0H24t4q/i0d8DNWgwYZPeO4GBf3Antdkn4W
         stsQ==
X-Forwarded-Encrypted: i=1; AL+hErEzuwsRAPcIsgzRBvR+JkmZ9sUlH6dX0TsHY8mo7uKTsOER8QvxtTpqgpBlYvFesBE7LritBt3y1Q==@kvack.org
X-Gm-Message-State: APuU4Z+VlJX4p1pBs5pPJQQS64jVLh5RuJ7xgzdtM5SK5IiKTQWd9XJd
	tTNWuhbNdxXlCbBxP5M+S27x+RKOYVf8WWMBKM14KVUw6Ezll3tz9Vw62UFlpqpDkxyxrwzJHwN
	YT2ORdA==
X-Received: from edj9-n2.prod.google.com ([2002:a05:6402:3249:20b0:6b7:e5f7:4663])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:3b94:b0:c26:1649:47ad
 with SMTP id a640c23a62f3a-c513ab209f4mr107142966b.35.1795136820223; Thu, 19
 Nov 2026 17:07:00 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:30 +0000
In-Reply-To: <20261109182533.3594984-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-1-lrizzo@google.com>
Subject: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator for
 DMA and CoCo
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BAF440009
X-Rspam-User:
X-Stat-Signature: 6twkmth3m5ff88fnkf67pekn7sq66hbu
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795136822-913895
X-HE-Meta: U2FsdGVkX1/YkPZUoTi1yzVA2WpErPd/wpmbL/bkBi83wl3j39bhES2L0pnEFCJVnyOS0soYvnDFSvMy0U2F9kOpXbWlHxn41iBtV/8G2gv1WgOszUjAvrQc1d9vV8kQY4rRPSItewwJtq9sKKxIU1/fuN0HvICDn8Hsze2P0rJTKVzlBQH7CNK2W9e+kbxVU2/ihQiPBae1bd34BiEo383cydfG7bPW2mgC22/chXljf23r8gPULGRuFXrriW+3307zQS/Ew0l4JbGDimRnfUXdczG2mFNhfix04gLxI0d26YwYNbxz/6dfiF1aD56Loa9lWsj/6HOdMrcLTCO7Qao7wBSZSzAMWYjDAYKaLbRGErJgPBylE1BcpFWHJErenkMTKDm2uWhDiFKCzja42evLdg1zCI9aZztmnKGUHcTxtNyj30lrrUjCCZD06VLo0lnSlHimbQqNrASBoKLqeKmk8FWDPeLPR68pYfpvU046ifHbbOE3pOxpnJZNdgLMGXzZ1JSzglE8INAq+Ziu6JnFJp1yLORpjkzTDMWF5YgTQ+vVfUmZbmdRog693F6/hNYvkLy9S7z45RwpIV8dqvZGyjG4PuvYLdqUQrxg42zTFiIMzRvWoPnn7y6oim23GaDdA9aWsEYIvsW4CfT+nIpQ0By+XsDiCAkYSHL//Azev8EtwmnEoKEyWwTqD5Rh4Dre/t/pU57enCMfWPSPPZcjS6XbcpEwev9WHGjwE6WW+tYEzi3ZLbLvUvaHv6FjAu0/ffh9nv/6YPK2MqGH2bz7P1YR0MzASKAxEsxCe1stsvBQXidNWD7RbP+WgNLWn1+A6FzXolBUyFB3J3xISaArTv+s7tzJRmKMFb+nMrn+ddRTd8MVFLzTUiv546Znlt3l1BCbUOWK9pGGeQ0n5YL/xIXoOPRetuyYnKnWenkgSWGXiXz0wcjSD9Tzijkj3tXUR4CRSJQS3V9H0jx
 CrFL3HBl
 /UN9aQZpqTr1jQSjUH04o+rPUWFFYcHCgY0H+Ao01GsO/5Ck7WgJJAOGs1fSW0qMWEVWQLcrSS5FWDQ9nRGLl21DZSGqQ7N7Uj9dGvc4uMDtGIlxhhLaI1YRdAkdIqTHh+gYa14tj4a99XFwhCG9LUrKiscQjXlW36JyjJdLCNpXr+bQWiOiXGZkrVaRmdCrh3MFvcnCn2iFz875IArnZQSWcWAo7I3q+jaAtweKcTYdk8gBdU9bz1p31NRcq7b9WZ95tsYHADKGvE3ZnD9n5IsmW/K/EweULQHjf2Qi6bg9QBxxoJqEY1Y12UPCCT5plpKSpZKJzSwPOZGKorJysFj+jOJ5P03PHP39+RRnK5GI0r71qN8zbtrTbbgAzchp3GxNRur/GFznOqF+EMj+BR7Urm5mkX8j/7YJvMj778+BkQm2UmTqhs4XrFMf9dwsnjjcHAQvZl4iMV4tpyKHGQYusZpp5HI0luHbiM58Dk8+aKIqxy4uZHod9qG/SZNyTbeQe4+Ic2tQfv8kLdFneeY4L8TOt6f2pq9A5BNSncX8wmP8FArfV9z3wu0iNpW34cU9JG+mugAPUrRIf3ULlpAH3aRwxTJ/CVwH2xS2ULZlH9llFbEr75kun+EOiTsyMKcqgly/byKb4wMQBIrPRPmzSOPA7PXRLp4oWi6mimABv6/98lhDctJd8wgdMiIbZOQLnskVlT8JrnnXPIiG3eH5oeL05LBiI3oNxxly6IimNQgTgbByt+iGKfcu/QStuW7wCk2L/dB+zMFfSq2SFJQqo4l29Z1rcJn70M9oy5cyKnBX5W00VGLr8+iC2VlnP/L7/w6Dt9IPRb/pb/q2WtTi5Y1fbqmOB2dIBOG+gPC7hnVPQ0SGZNRFxqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is v3 of the RFC previously posted as DMA_PMD [0], now renamed PISA
("Pre-mapped IOVA Superpage Allocator"). The text below follows
Documentation/core-api/pisa.rst (patch 25/25), which has the details.

=== OVERVIEW

PISA is an extension to the page allocator: requests with __GFP_PISA
return memory that makes I/O-related operations cheaper when using DMA-FQ,
DMA, or Confidential Computing swiotlb. I/O devices can individually opt
in to use PISA for specific buffer classes (e.g. read or write data,
headers, zerocopy, ...). Relevant kernel subsystems (mm, iommu, dma, disk
I/O, page cache, the network stack) are modified to make use of PISA
memory for opt-in devices.

The design and implementation have the following main goals:

- no changes to individual device drivers (or minimal changes for NIC
  drivers that use custom RX page allocators)
- minimize changes to base code: in most cases one or a few lines of code
- safety: PISA memory is only used for devices that opt in, and it is
  returned to the buddy allocator only after IOMMU mappings and IOTLB
  entries have been flushed
- no dependency on struct page or struct folio
- compile-time option to disable or enable PISA
- zero runtime overhead when no devices opt in (static keys and inline
  hooks)
- minimal overhead when in use (direct PFN lookup in a flat metadata
  table)
- keep memory overhead as low as possible (adaptive shrinking and
  compaction of memory)

=== MECHANISMS

PISA returns order-N blocks backed by 2MB physically contiguous pages, so
it can use 2MB IOMMU leaves and reduce the IOTLB pressure by up to 512x.
PISA maps memory in pre-allocated per-domain IOVA ranges, and recycles
blocks and mappings until the 2MB page is returned to the buddy allocator.
This makes most of dma map/unmap a no-op, also avoiding related VM exits
in overcommitted VMs. In Confidential Computing VMs, PISA pages are also
decrypted, removing the need for bounce buffers.

The kernel identifies devices and sockets that use an IOMMU or
Confidential Computing and have opted into PISA, and allocates (or
migrates) I/O buffers using PISA memory so that DMA mapping and unmapping
are mostly no-ops. All the above makes performance comparable to identity
mode, with isolation better than DMA-FQ and comparable to DMA.

Devices that do not opt in continue to use their native DMA/DMA-FQ mode.

=== PERFORMANCE

Your mileage may vary. Enabling the IOMMU will increase load on various
system components (CPU, IOTLB, bus latency, increased locking
serialization) but the impact on throughput will only show up when one or
more of these resources become fully congested.

Some anecdotal data:

NVMe: fio throughput in IOPS, 4KB random reads, O_DIRECT, on an x86 system
with 8 NVMe disks capable of 1.7M IOPS each

    drives      DMA     PISA    identity
    1           380K    1.7M    1.7M
    8           1.3M    13.5M   13.5M

Network: throughput in Gbps on a Confidential Computing VM, 200G NIC

    flows/mtu   swiotlb PISA
    1/1460      36      65
    1/4148      45      65
    16/1460     130     170
    16/4148     130     182
    256/1460    140     170
    256/4148    140     182

Network: throughput and SMMU performance counters on a large ARM64 system
with 2x200G NICs running bidirectional traffic (this shows the effect of
IOTLB thrashing)

    === DMA-FQ (total throughput ~440Gbps)
    25,757,488      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
    16,634,941      smmuv3_pmcg_*/event=0x81/   IOTLB misses

    === PISA on top of strict DMA (total throughput ~745Gbps)
    22,693,218      smmuv3_pmcg_*/event=0x80/   IOTLB lookups
        30,536      smmuv3_pmcg_*/event=0x81/   IOTLB misses

=== COMPARISON WITH STANDARD DMA MODES

PISA layered on top of strict DMA, compared with identity, DMA-FQ and
strict DMA ( > means PISA is better ):

                                      identity   DMA-FQ    DMA
  dma_map cost                          ~=         >>       >>
  dma_unmap cost                        ==         >>       >>
  IOTLB friendliness                    na         >>       >>
  Buffer shared across domains          na         <=       <=
  Memory remains accessible to device   >>         >>       <=
  Needs bounce buffers                  >>         >>       >>
  Page alloc/free cost                  >=         >=       >=

- dma_map/dma_unmap cost: once a 2MB PISA page is mapped in a domain's
  reserved IOVA window, dma_map_*() is an offset lookup and dma_unmap_*()
  is a no-op, avoiding IOVA tree allocation, page-table walks, and
  synchronous IOTLB shootdowns.
- IOTLB friendliness: 2MB IOMMU leaves reduce IOTLB pressure by up to 512x
- Buffer shared across domains: even in DMA-FQ and DMA, sub-page buffers
  from task_frag or skb head slabs can cause the underlying page to be
  mapped across multiple domains. PISA exhibits the same behavior, just at
  2MB granularity.
- Memory remains accessible to device: in identity mode all of RAM is
  always accessible. In DMA-FQ, pages returned to the buddy allocator
  remain accessible until the flush queue drains. PISA and DMA both unmap
  the page and perform a synchronous IOTLB flush before returning memory
  to the buddy allocator. In all modes, pagepool keeps receive buffers
  mapped and accessible to the device while queued in the rx socket
  buffer. PISA expands this visibility also to page cache and O_DIRECT
  pages.
- Needs bounce buffers: in Confidential Computing VMs, PISA allocators
  pre-decrypt 2MB pages in place, avoiding swiotlb bounce-buffer copies.

=== BACKGROUND

Enabling the IOMMU costs CPU to install and remove PTEs on dma_map/unmap,
CPU and latency to flush the IOTLB, and higher DMA latency from IOMMU page
walks when the working set exceeds the IOTLB size. The last one is among
the biggest bottlenecks for high speed devices: network devices have very
little IOVA locality, which makes the IOTLB almost completely ineffective.

The known mitigations are recycling buffers and mappings (common for
queues and RX buffers, but not for network TX buffers), lazy IOTLB flush
(DMA-FQ, which recycles memory without waiting for the flush), and larger
mappings (not currently pursued by the kernel). PISA combines them:

- intercept the small set of functions used to allocate, map, unmap, and
  free device-accessible memory (rings and buffers)
- return memory backed by physically contiguous 2MB pages and 2MB IOMMU
  mappings
- heavily recycle memory and mappings
- wait until the IOTLB has been flushed before returning unused PISA pages
  to the system

=== IMPLEMENTATION AND CODE LAYOUT

PISA is implemented by a few groups of commits:

- mm: infrastructure for per-page metadata (no dependency on struct page),
  hook into alloc_pages(), PISA optimizations (per-cpu caches, shrinker,
  background zeroing)
- driver core: per-device sysfs entries to opt in
- iommu/dma: manage PISA IOVA ranges and intercept map/unmap
- block, mm, net: transparently upgrade pages to PISA for disk I/O and
  network tx zerocopy
- net: identify sockets that need PISA pages, hook PISA into page frags,
  skb heads, page_pool

The code layout now matches the "allocator" nature of PISA: most of the
code is in mm/, and iommu and net only carry subsystem-specific changes.

  mm/pisa-*.c                            metadata, allocators, per-node
                                         reservoir, user and page-cache
                                         pages (~5100 lines)
  drivers/iommu/pisa-map.c               IOVA ranges, map/unmap
                                         (~500 lines)
  net/core/pisa-net.c, include/net/pisa.h
                                         socket and skb glue (~450 lines)
  include/linux/pisa*.h                  public API and inline hooks

The functions that need to be intercepted are few:

- page_pool_dev_alloc*(), socket TX page frags, __free_pages()
- dma_alloc_attrs(), dma_map_*(), dma_unmap_*()
- __filemap_get_folio_mpol(), ractl_alloc_folio(), writeback_get_folio(),
  __bio_iov_iter_get_pages(), madvise()

and most devices automatically inherit the benefits. Fast-path hooks are
guarded by static keys: pisa_key remains disabled (a single NOP) until the
first device opts in via sysfs. NIC drivers that do not use page_pool need
a few lines to pass __GFP_PISA_RW when allocating RX buffers; gve is
converted as an example.

=== INTERNAL MECHANISMS

- PISA metadata: each 2MB page used for PISA memory is identified by a
  compact index (slot). Two flat arrays in virtual address space, with
  holes mapped read-only to a zero page:

  1. pisa_pfn2slot[pfn >> PISA_ORDER] (4 bytes per 2MB physical frame)
     packs the status flags and the slot. It is populated for system RAM
     at boot or on hotplug, and grows by 4KB for each 2GB of physical RAM
     regardless of RAM layout.

  2. pisa_meta_array[slot] (256 bytes per 2MB PISA page) holds struct
     pisa_meta: base PFN, flags, free/clean/dirty subpage bitmaps, the
     bitmap of IOMMU domains with an active 2MB mapping, and list/RCU
     linkage. Backing pages are allocated on demand up to pisa.max_pages
     (default 1/8th of RAM).

- Per-domain reserved IOVA ranges: PISA reserves on each domain an IOVA
  range covering the slot table, and a page is mapped on demand at offset
  slot * PISA_SIZE in each domain that requires it. This makes PA-IOVA
  translation just an addition, uniquely identifies PISA IOVAs, and does
  not expose physical addresses.

- alloc_pages() compatible allocator: a pisa_alloc object serves
  fixed-order allocations, returning objects fully compatible with those
  of the page allocator. alloc_pages() and related requests are routed to
  PISA via __GFP_PISA, which makes it easy to select PISA pages where
  needed (two lines in page_pool, similar small changes in page frag
  refill and disk I/O buffers).

- Safe release of memory: freed blocks return to PISA with mappings still
  active. When all blocks of a 2MB page are unused the page becomes idle;
  idle pages above pisa.max_idle are released after pisa.idle_ms, or by
  the shrinker: mappings are removed, a synchronous IOTLB flush is issued,
  and after an RCU grace period (and re-encryption if needed) the page is
  returned to the buddy allocator.

- Memory compaction: partially allocated 2MB pages are classified as dense
  (preferred for new allocations) or sparse (left to drain). For user
  pages, pisa.scrub_migrate also migrates live 4KB pages out of old sparse
  2MB pages in the background.

=== MODIFIED KERNEL APIS AND CONTROLS

Opt-in is per device, through
/sys/devices/.../pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads,tx_zerocopy}.

- Streaming DMA map and unmap: a buffer belonging to a PISA page is mapped
  via the domain's reserved window with a simple addition, typically
  reusing existing mappings; unmap is a range check and a no-op. Under
  dma-direct, decrypted PISA pages are mapped without swiotlb bounce.
- Coherent DMA (pisa_coherent): sleepable allocations up to 2MB are carved
  out of the per-node order-0 allocator.
- Network receive buffers (pisa_rx_bufs): a two-line change in page_pool
  adds __GFP_PISA_RW, falling back to the buddy allocator on exhaustion.
- Socket TX page fragments (pisa_tx_bufs): fragments come from PISA pages
  mapped DMA_TO_DEVICE, only for data routed to an opt-in device with a
  DMA parent. Loopback, virtual devices, kTLS, sockmap, KCM and MPTCP use
  ordinary pages.
- Small skb heads (pisa_tx_skb_heads): served by an
  skbuff_small_head_pisa slab cache backed by PISA memory mapped
  DMA_TO_DEVICE. Never used in Confidential Computing, where it would
  expose kernel pointers; tx-copybreak avoids the swiotlb cost there.
- Zerocopy receive: RX buffers from PISA pages can be mapped into user
  space by TCP_ZEROCOPY_RECEIVE.
- Zerocopy transmit (pisa_tx_zerocopy): MSG_ZEROCOPY sends migrate
  eligible user pages into DMA_TO_DEVICE PISA blocks on a best-effort
  basis. With pisa_tx_bufs also set, TCP copies the pages that could not
  be migrated.
- User and disk I/O pages: madvise(MADV_PISA) migrates private anonymous
  pages into PISA and MADV_NOPISA migrates them back. For block devices
  with pisa_rx_bufs (reads) or pisa_tx_bufs (writes) on a parent device,
  new order-0 page-cache folios are allocated from PISA, and writeback and
  direct-I/O bio preparation migrate eligible folios.

Global controls are pisa.* parameters: max_pages, reservoir_max, max_idle,
idle_ms, pcp_batch, compact, target_usage_percent, old_ms, scrub_max,
scrub_migrate, user_max_pages. Counters are in
/sys/kernel/debug/pisa/allocs.

=== LIMITATIONS

- Not compatible with PREEMPT_RT (enforced at compile time).
- Only DMA-coherent devices can use PISA (enforced at runtime).
- IOMMU mappings follow the direction the allocator was created with:
  descriptor queues and receive buffers are DMA_BIDIRECTIONAL, disk and
  network write buffers and socket TX fragments are DMA_TO_DEVICE.

=== CHANGES SINCE v2 [1]

The changes are too many to list in detail; at a high level:

- Code layout: the allocator moved from drivers/iommu/pisa-*.c to
  mm/pisa-*.c (and CONFIG_PISA to mm/Kconfig). Only the IOVA window and
  map/unmap code is left in drivers/iommu/pisa-map.c, and the network
  hooks moved from include/net/sock.h to include/net/pisa.h and
  net/core/pisa-net.c. See CODE LAYOUT.
- Flags renamed to __GFP_PISA and __GFP_PISA_RW
- Reworked metadata: a flat pfn-indexed table plus compact per-page
  slots, with the per-domain IOVA window indexed by slot.
  Saves one load access in the hot paths, and
  removes several tuning knobs while allowing 57bit address space
  with negligible memory overhead
- Net: the opt-in flags of the leaf devices are cached on struct
  net_device, and MSG_ZEROCOPY migration has its own per-device knob,
  pisa_tx_zerocopy.
- Confidential Computing: added arm64 Realms support.
- Compaction is driven by a target usage (pisa.target_usage_percent)
  instead of pisa.wasted_pct.
- Series reorganized (mm first, then iommu/dma, block, net, drivers), with
  the three IOVA window patches merged into one.
- Fixes for the issues reported on v2 by the automated review.
- Added NVMe and Confidential Computing results.

=== CHANGES SINCE v1 [0]

v1 presented DMA_PMD as a set of pools and an arena under drivers/iommu,
called explicitly by page_pool, the socket code and four NIC drivers.

- Renamed DMA_PMD to PISA.
- Restructured as an extension to the page allocator: callers pass
  __GFP_PISA / __GFP_PISA_RW to alloc_pages() instead of calling a
  dma_pmd_pool, and the code moved from drivers/iommu/ to mm/ (see CODE
  LAYOUT).
- Per-NUMA-node allocators with per-CPU caches replace the per-CPU and
  per-queue pools; the dma_pmd_arena for dma_alloc_attrs() is merged into
  the per-node order-0 allocator.
- The per-driver TX header bounce buffers (gve, mlx5, idpf, bnxt) are gone,
  replaced by a PISA-backed slab cache for small skb heads.
- New: user pages (MADV_PISA, MSG_ZEROCOPY) and disk I/O (O_DIRECT and
  page cache), with compaction and background migration.
- Opt-in is through per-device pisa_* attributes and pisa.* parameters;
  metadata and static keys are activated on the first opt-in.


[1] v2 (PISA)
    https://lore.kernel.org/all/20261109182533.3594984-1-lrizzo@google.com/
[0] v1 (DMA_PMD):
    https://lore.kernel.org/all/20261003212241.3432303-1-lrizzo@google.com/

Luigi Rizzo (25):
  mm: Introduce CONFIG_PISA and metadata table
  mm: Add PISA allocator lifecycle and page recycle hook
  mm: Add per-NUMA-node PISA page reservoir
  mm/page_alloc: Extend alloc_pages() to __GFP_PISA and PISA block
    allocation
  mm: Add global cap and shrinker for PISA pages
  iommu/dma: Map PISA memory in a per-domain IOVA window
  driver core: Add per-device pisa_* sysfs attributes for PISA optin
  iommu/dma: Use PISA for coherent DMA allocations
  mm: Add per-CPU block caches to PISA allocators
  mm: Add background page scrubber for PISA allocators
  mm: Migrate user pages into PISA
  block, mm: Support PISA for disk I/O and scrub migration
  net: Cache leaf PISA TX flags on struct net_device
  net: Use per-node PISA allocators for skb_page_frag_refill()
  net: Use PISA for page_pool memory
  mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches
  net: Allocate small skb heads from PISA
  net: Migrate user pages into PISA for MSG_ZEROCOPY
  mm, iommu/dma: Support decrypted PISA pages
  arm64/mm, mm: Support decrypted PISA pages in Realms
  mm: Add PISA statistics and debugfs
  net/libeth: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use GFP_KERNEL when pre-filling RX rings
  net/gve: Use PISA memory for RX buffers
  Documentation: Add PISA architecture documentation

 .../admin-guide/kernel-parameters.txt         |    7 +
 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/pisa.rst               |  485 +++++
 arch/arm64/include/asm/pgtable.h              |   28 +-
 block/bio.c                                   |    9 +
 drivers/base/core.c                           |   78 +
 drivers/iommu/Makefile                        |    3 +
 drivers/iommu/dma-iommu.c                     |   49 +-
 drivers/iommu/iommu.c                         |    7 +-
 drivers/iommu/pisa-map.c                      |  488 +++++
 .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |    8 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |   40 +-
 include/linux/device.h                        |   32 +
 include/linux/gfp_types.h                     |   14 +-
 include/linux/huge_mm.h                       |    7 +
 include/linux/netdevice.h                     |    4 +
 include/linux/pisa-iommu.h                    |  141 ++
 include/linux/pisa-mm.h                       |  205 ++
 include/linux/pisa.h                          |  356 ++++
 include/linux/sched.h                         |    4 +
 include/linux/slab.h                          |   10 +
 include/linux/swap.h                          |    1 +
 include/net/libeth/rx.h                       |   11 +-
 include/net/pisa.h                            |  204 ++
 include/trace/events/mmflags.h                |   11 +-
 include/uapi/asm-generic/mman-common.h        |    2 +
 kernel/dma/direct.c                           |   11 +
 kernel/exit.c                                 |    2 +
 kernel/fork.c                                 |    2 +
 mm/Kconfig                                    |   35 +
 mm/Makefile                                   |    3 +
 mm/filemap.c                                  |   12 +-
 mm/huge_memory.c                              |   36 +-
 mm/ksm.c                                      |    3 +-
 mm/madvise.c                                  |   19 +
 mm/memory.c                                   |    8 +-
 mm/migrate.c                                  |    3 +-
 mm/page-writeback.c                           |    9 +
 mm/page_alloc.c                               |   10 +
 mm/pisa-alloc.c                               | 1758 +++++++++++++++++
 mm/pisa-kunit.c                               |  778 ++++++++
 mm/pisa-meta.c                                |  834 ++++++++
 mm/pisa-node.c                                |  567 ++++++
 mm/pisa-priv.h                                |  319 +++
 mm/pisa-user.c                                |  898 +++++++++
 mm/readahead.c                                |    3 +-
 mm/slab.h                                     |    3 +-
 mm/slab_common.c                              |    2 +-
 mm/slub.c                                     |   23 +-
 mm/swapfile.c                                 |    3 +-
 mm/userfaultfd.c                              |    7 +-
 net/core/Makefile                             |    1 +
 net/core/datagram.c                           |   17 +-
 net/core/page_pool.c                          |    3 +
 net/core/pisa-net.c                           |  264 +++
 net/core/skbuff.c                             |   33 +-
 net/core/sock.c                               |   31 +-
 net/ipv4/esp4.c                               |    7 +-
 net/ipv4/ip_output.c                          |   20 +-
 net/ipv4/raw.c                                |    6 +-
 net/ipv4/tcp.c                                |   17 +-
 net/ipv4/tcp_output.c                         |   14 +-
 net/ipv6/esp6.c                               |    7 +-
 net/ipv6/ip6_output.c                         |   20 +-
 net/ipv6/raw.c                                |    6 +-
 65 files changed, 7907 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/core-api/pisa.rst
 create mode 100644 drivers/iommu/pisa-map.c
 create mode 100644 include/linux/pisa-iommu.h
 create mode 100644 include/linux/pisa-mm.h
 create mode 100644 include/linux/pisa.h
 create mode 100644 include/net/pisa.h
 create mode 100644 mm/pisa-alloc.c
 create mode 100644 mm/pisa-kunit.c
 create mode 100644 mm/pisa-meta.c
 create mode 100644 mm/pisa-node.c
 create mode 100644 mm/pisa-priv.h
 create mode 100644 mm/pisa-user.c
 create mode 100644 net/core/pisa-net.c


base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
-- 
2.56.1.809.ga0b61035b5-goog


