Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23790CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746D58E00B2; Thu,  9 Oct 2025 21:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E5A8E0002; Thu,  9 Oct 2025 21:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634B18E00B2; Thu,  9 Oct 2025 21:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5101E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:19:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC6EA55EAB
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:19:58 +0000 (UTC)
X-FDA: 83980448076.03.536865D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B05C40002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:19:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tKUEJYDc;
	spf=pass (imf12.hostedemail.com: domain of 3O1_oaAYKCOgcebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3O1_oaAYKCOgcebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Umr72UDM+ef/eu/5GGg59+M3j2MSWUMKK6kjEtNqzt4=;
	b=hRNO325wizxFLuBgVFAGv2lIbK2Kq6iM4hWw+Unyi9gify+qBQMuNH8/Dgd3erhgkuGDeq
	n0NlnQQo/Sx/YIAKRNYXibxSoTJcDl+62FE+WpVu1pMWylfkt5MpQUi7Za6X/7ihgfBALg
	1mPIhtTYEJR7qeLF1k221SyLo/R/P9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059197; a=rsa-sha256;
	cv=none;
	b=TaRlJNx5IzzHSq7QjA96OokYvELZTsf4tFA0+Yh0MX08wM+gpSb5Z6qxaPDnTf0f3CSPUe
	y7WZPyzPSozTKaTLuZtqn0CFpct0GOi2v2Y8B4iYgxbd2cd1mVb+OZiAMrdvyDCoMYY0AR
	moQdIxRG4c96tL00KMPtLeDA8Nhtyq0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tKUEJYDc;
	spf=pass (imf12.hostedemail.com: domain of 3O1_oaAYKCOgcebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3O1_oaAYKCOgcebOXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so4936689a91.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059196; x=1760663996; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Umr72UDM+ef/eu/5GGg59+M3j2MSWUMKK6kjEtNqzt4=;
        b=tKUEJYDcAfJQsZyI6U6ZlV2jfbHki8gIUSGFnIwOGu4Q1diZXdoMpVSuyNKPUDWJuX
         OTVDHMxegz2Dr6QXJw/8VoDpIkA9OPLRhpJMGuaVnKrndoSVJOJvs0EByP1xMWqGDzjC
         d851yYYBVMvOveF1RR1psV9ZP1HCVt27pNOEtFD3pelQo0bPT/C3rAPj8ZPT0TotsXXG
         T4lKe2m06w4nkUMP6qiKkizKkGgYd4TdxB4i0GoDzRQSZSKWcNrmVsupFFz3Hog3rUsM
         0tpenAaoodapESvqOWKpqWJoiBz0EbwjM8eu/t5S3J2IQrdEVRCfjO5WwXHTi8GDfQwr
         dOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059196; x=1760663996;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Umr72UDM+ef/eu/5GGg59+M3j2MSWUMKK6kjEtNqzt4=;
        b=G+TtQGYz2OSKZjz8VqRq726BBKz8c/90yizm4kVhJmHxCTnkF5aZpUVtmuMtstZXgq
         QrsS25OwrcVmNCNXe9Uj1ZLlrWHG3+KRgWbSwMjUolvkM3kIRd6untbuyOu2stFA3s+0
         lhZTphqbiRXRClqcyCHTc7pxoQwKc0iyohJF+YdcMR7G9s4UqWaXt1b02p2t8Qpv2JET
         HDrW9T5+/v5sQ21v47tFXy7CUMOE4oKzkPxRz0+T8Y7y54uKNcdEaLqV/lC3NHmmEwX1
         aQ+b5L+s2+WTa46L5e9Y+AuFfolRdMfqY515SFfTbYLumfIIGXYCGPyz33EBSoZgaqVz
         AaXA==
X-Forwarded-Encrypted: i=1; AJvYcCVRWI+RhPuRYc1o24919g0fVnQ+a27T3VgK34/QMvl0GQQnCflN2P0z5drhTqS554iQ2xHLMuDYrg==@kvack.org
X-Gm-Message-State: AOJu0YxcKw9JsbL3vDzSJfRniaLQSnsiZueOGie40ZgKTmSNoK5CN9qt
	6wjMqg4+MamEG6pcuZSMCUkPY/h4eBGQIF3wJ3WRA/2OjU/pLJI5hHMlROA8URuDPzPeRGjGYQ3
	lb/PNpg==
X-Google-Smtp-Source: AGHT+IE27KyVOHtRVs+A0lEatoDCera078aKUGcBNIuc3h+4WOD0YdO+2yFbdCIN2uDuSh9GKzfzUmBfEEw=
X-Received: from plbml5.prod.google.com ([2002:a17:903:34c5:b0:28e:7f4e:dd17])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec83:b0:267:d2f9:2327
 with SMTP id d9443c01a7336-2902739b36dmr131881235ad.27.1760059195894; Thu, 09
 Oct 2025 18:19:55 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-1-surenb@google.com>
Subject: [PATCH 0/8] Guaranteed CMA
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: nas9u7mbm5crreb5umznm3hgyqxqxzbw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B05C40002
X-HE-Tag: 1760059197-340611
X-HE-Meta: U2FsdGVkX1+IOoPfJWe/uTCmN2laTZgMYgd0eBK/mJx8djTJki2oJOjupHYvW8MXSZTiAacn6l79ZWcSILRKf4IoYlio0nGcqoLVFjQ0/GR1H0BX7FJHtOiUBZ0NXj44MM2CGVU+3aiyk5YmJ+D2EtiDaGb3/fbqW8StYxUE9JkauoJ3QDYBOg7+UhT6OrcyTlQFzT3/eCRAB67HmLooCUgTkgMdyzPLF42bpudW/ISRJQBU9pJC65v+Onher5L/PVqPaPbqqG12BSJa1KalL/Cn2TkPGI14fGmJe39//+rgFiNOEce4ARH1lwq1aPgznuWzYP8AZmiT3N1BRtIG7L58lQYGDJ+p5+MvTIWTROhQd7VNiRSStF/b1t5ow1i2bvjvvdpNaIWqkN6A85FlE4+c8BwJutzYfPDBnqZDbimXxhjf0iOBf7uvJEyxLeoPIbCBwTEkjfaJUjEVfi7CBIVetXgtNNt6ewwVxsjZtxpxug3VSWjrfPKeTKdxaiBvVZzMSgNWz264WoLTCeu4+G+iPrYxquw24H0GwoknEd/Vrwy3uiXJSSFPScE/Gi27P0vYIMdv6uBb0pGyZOx/JPU56eZlexMl0xIoY07CcBt5s2AA4UJkabcd05xc6PmyGxmUbRA5AlzA+xu7uRhOo+OSRAd748rRt4hkAXAtcU0WC04Ao8bqcBGyEBuHEwJi0eSZl1ua9to9GUl5oDOR541JXBM7szoOr28UGGo5nRVIFiYYkorJnNEj/92gLB03Ph+5xGajaSxM96E5pRwWioc6Prq20e3Gj64A+Z34aJNLor6CGZwj2MkE8ZcQaclHKZQR6Ov4hgQPZFm8F8IdaZDNbRYBehmmvoGGnoP2KXnGahSe+AqruSQGBVrn6gUTAgzoEovSB7kgnu5zDCBNH2zC3Axy7NSGHtUzfliTCYWeM+gMWAPdR+Y23jrLXzwb7quRovOvzWggu4Gzdpb
 riCi+m4f
 6bBc1aOuKYWRl1bMeM8lPzTxpDxZw1s3ia4FQNYI2+ltROzhF2uXEyk1GIS5WkQu9RaHZbL2QIfWZRC0GBR3Zy8CZSyzxbJPaXZ2cBUpLic6bFQYrW/6821KSMCCg9t7spKVM7AJzGRpIMgaOYnEOFUMf9m/xyDKavLD5Jj5QKBR/aHpVDrwno9Qlrxhz97K52QpWYORU1S/sRfy8znWTBfle3unIfY4jIs50bP6y9NzSQdRFhVq85ONdgK37wjguK2T7SO/UFZPXbc2JJlWGcChGLWhOqbnT/I17++LxERoX9A18MXCVOYFyoTFbtlYPUM2NOBpSyvXF/Nd2OOXWdVABdoxmFwBf7n0yvSlJIsnwFSwxWrZHy55ipNlDZrzL/zt/L/VFt3XBRkPLcIpDJjOTkElNe0ut7I8EWAq2uRqW4awIByzavyy7xylJO0xbeOSkp2vneRCG7y/gG+J/0HEcwoOZ+gm0H7ILo0V9MtQgBB9QTYota9agREFIFGcDjoJrMeXtS44LqmQJFAXZf/c76lvnKp8TfShU/OfwluyfkDMG0cyBs3wG//2Y9zbIB2Xjo8iKamiV8DW4HaLXvShuJB5giHyNWNFgoVIJ4lenqteT6A9XkpmbuLAKZ9u6yq1Qk+5rNW3G3F25GRbElRE67eTm8L0DvIwyQPbZBlKU3SILfq4xTvLgEtZZv7vw6hTa5juXLQ9KZdGsdftb3mIrXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guaranteed CMA (GCMA) is designed to improve utilization of reserved
memory carveouts without compromising their advantages of:
1. Guaranteed success of allocation (as long as total allocation size is
below the size of the reservation.
2. Low allocation latency.
The idea is that carved out memory when not used for its primary purpose
can be donated and used as an extension of the pagecache and any donated
folio can be taken back at any moment with minimal latency and guaranteed
success.

To achieve this, GCMA needs to use memory that is not addressable by the
kernel (can't be pinned) and that contains content that can be discarded.
To provide such memory we reintroduce cleancache idea [1] with two major
changes. New implementation:
1. Avoids intrusive hooks into filesystem code, limiting them to two hooks
for filesystem mount/unmount events and a hook for bdev invalidation.
2. Manages inode to folio association and handles pools of donated folios
inside cleancache itself, freeing backends of this burden.

Cleancache provides a simple interface to its backends which lets them
donate folios to cleancache, take a folio back for own use and return the
folio back to cleancache when not needed.

With cleancache in place, GCMA becomes a thin layer linking CMA allocator
to cleancache, which allows existing CMA API to be used for continuous
memory allocations with additional guarantees listed above.
The limitation of GCMA is that its donated memory can be used only to
extend file-backed pagecache. Note that both CMA and GCMA can be used
at the same time.

Accounting for folios allocated from GCMA is implemented the same way as
for CMA. The reasoning is that both CMA and GCMA use reserved memory for
contiguous allocations with the only difference in how that memory gets
donated while not in use. CMA donates its memory to the system for movable
allocations with expectation that it will be returned when it is needed.
GCMA donatest its memory to cleancache with the same expectation. Once CMA
or GCMA use that memory for contiguous allocation, the difference between
them disappears, therefore accounting at that point should not differ.

The patchset borrows some ideas and code from previous implementations of
the cleancache and GCMA [2] as well as Android's reference patchset [3]
implemented by Minchan Kim and used by many Android vendors.

[1] https://elixir.bootlin.com/linux/v5.16.20/source/Documentation/vm/cleancache.rst
[2] https://lore.kernel.org/lkml/1424721263-25314-1-git-send-email-sj38.park@gmail.com/
[3] https://android-review.googlesource.com/q/topic:%22gcma_6.12%22

Patchset is based on mm-new.

Minchan Kim (1):
  mm: introduce GCMA

Suren Baghdasaryan (7):
  mm: implement cleancache
  mm/cleancache: add cleancache LRU for folio aging
  mm/cleancache: readahead support
  mm/cleancache: add sysfs interface
  mm/tests: add cleancache kunit test
  add cleancache documentation
  mm: integrate GCMA with CMA using dt-bindings

 Documentation/mm/cleancache.rst |  112 +++
 MAINTAINERS                     |   13 +
 block/bdev.c                    |    6 +
 fs/super.c                      |    3 +
 include/linux/cleancache.h      |   84 +++
 include/linux/cma.h             |   11 +-
 include/linux/fs.h              |    6 +
 include/linux/gcma.h            |   36 +
 include/linux/pagemap.h         |    1 +
 kernel/dma/contiguous.c         |   11 +-
 mm/Kconfig                      |   40 ++
 mm/Kconfig.debug                |   13 +
 mm/Makefile                     |    4 +
 mm/cleancache.c                 | 1144 +++++++++++++++++++++++++++++++
 mm/cleancache_sysfs.c           |  209 ++++++
 mm/cleancache_sysfs.h           |   58 ++
 mm/cma.c                        |   37 +-
 mm/cma.h                        |    1 +
 mm/cma_sysfs.c                  |   10 +
 mm/filemap.c                    |   26 +
 mm/gcma.c                       |  231 +++++++
 mm/readahead.c                  |   55 ++
 mm/tests/Makefile               |    6 +
 mm/tests/cleancache_kunit.c     |  425 ++++++++++++
 mm/truncate.c                   |    4 +
 mm/vmscan.c                     |    1 +
 26 files changed, 2534 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/mm/cleancache.rst
 create mode 100644 include/linux/cleancache.h
 create mode 100644 include/linux/gcma.h
 create mode 100644 mm/cleancache.c
 create mode 100644 mm/cleancache_sysfs.c
 create mode 100644 mm/cleancache_sysfs.h
 create mode 100644 mm/gcma.c
 create mode 100644 mm/tests/Makefile
 create mode 100644 mm/tests/cleancache_kunit.c


base-commit: 70478cb9da6fc4e7b987219173ba1681d5f7dd3d
-- 
2.51.0.740.g6adb054d12-goog


