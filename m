Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C704CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB578E017E; Sun, 26 Oct 2025 16:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB748E0120; Sun, 26 Oct 2025 16:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A968E017E; Sun, 26 Oct 2025 16:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0BF18E0120
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E5071A03F0
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:18 +0000 (UTC)
X-FDA: 84041422836.24.91412A1
Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id E4BDD180003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MSgR2qFl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3P4b-aAYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=3P4b-aAYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oIYNgmwaiZev52ielsOny0g8kp/qW6C19JMGXvUOw8g=;
	b=DoEaI4fAe2AbXW/2oCBkzJgfWd/YLCpaghEWWpeYXxydXr5hXCsFN7J08y6zRAAcR3B7Sa
	xKlabsCXrfZmot7k7brAexZDee9HOytNm1EN1Yyc9ahrQHwulTJBBSwYG7aCuSZSAGKEY1
	vIPmywPDr5NoGTyGyuXQSlaspaKaDpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510977; a=rsa-sha256;
	cv=none;
	b=fUGBJH2G5+QJO0X4z5o8ZvfBvi7M3K1vR0fJIZUSqJDi8FMsWNnRMdL/Cq9OkNJ7/dqCX7
	qjavubLYo9k46j6nCH8X2XXvJfc7EWI+cnobIvPbVCJILIPKzMwwHEsi8Ws8IbKdrNfARX
	32BzC0NSjQ5I/RMK3hE1zn6BPuy2+qA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MSgR2qFl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3P4b-aAYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=3P4b-aAYKCJQGIF2Bz4CC492.0CA96BIL-AA8Jy08.CF4@flex--surenb.bounces.google.com
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-63ba1a12aebso4647847d50.0
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510976; x=1762115776; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oIYNgmwaiZev52ielsOny0g8kp/qW6C19JMGXvUOw8g=;
        b=MSgR2qFlg0OdZTQgEyu0FEwEoSPwhZBw9WvnfYmvXkvpTrQNSWh/5E9Po9xkcA2SI+
         326/PtRTe1XGGe13RErSlUEr5kJ4mrjBtcCZdkyxogTn6spi75mEM01m/A9mJDSdibPa
         y+tfPn8OMXMNmKBHSyv6lzuw/0ZXTuMyQFk0NDO41AZ3NKRfq5ViOpCnowpbauxNie84
         4ESrE3J98hQvWxRiAtksLRfMDgcbe/XniD+lcyvWIKZrZK5SPJVa9vcGZ9YXw4SSOvdW
         xY+1bIkyIlfl/iVv5eeYXuC7KbsYvRn//lryB8+eB43lpTGUD4G9GM+oVdAd4XnIv39D
         5hyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510976; x=1762115776;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oIYNgmwaiZev52ielsOny0g8kp/qW6C19JMGXvUOw8g=;
        b=Lr73i878S1vT4bx7P7wJJYR77HtY4+MrOEnGC3oLa6fC4SXD1fBvNv++16EQGkSWZV
         cPb6RJa8K5wD8tXM/cutRiMpq6ywj9GqdNR+hbvqRVJYZdk6rJIIopgzF1FoQMegV9eS
         vtDtWXGyYZDbXcEmOnF6H2LnY/AU2QmBiton0mi+XM8b+d6pBrmxbqcvLMTOPHs4WE4H
         QsXn9lIPUZK5zGqjEzk1DwNBRi/KnIKXppSwbVw0u6r+fhWju299/QDOZCUw3dDus0eb
         ocTkFOm1iR10TP+A/Oc+4bbxkjrtU7soGNOQgv+gnTWicYKpM92gFEycbh0oIjoC87Mf
         8Jew==
X-Forwarded-Encrypted: i=1; AJvYcCWJ/OUqbxH/E1s9tcrd+4wYiXy0ULHXfY2wnsKgt2HMwndfInha/idAQusbFsdBbgDcnYmuuI5P9g==@kvack.org
X-Gm-Message-State: AOJu0Yzjt+rIBNoO1k+/J6AUp10pnkhqVBOu4aS9ZAlTuEQlFEpFE+lp
	ouf4tzpBZ1Pw8hXSkcw00aEu2TyGL4vy9NVkWRb0+IunTohoD+ZNfWtc0XWRyunFrtKH3UTDgVO
	l8gkA6Q==
X-Google-Smtp-Source: AGHT+IEQ9Pwyyd7kjVHYsKEBM6jXV+KGbNmmj3ZfQc3rnB2XqZ4bQZDKRwRIjK4vvzIoUgZwP2mnd9XDO/0=
X-Received: from yxdd3.prod.google.com ([2002:a05:690e:2443:b0:63f:2d9a:656b])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:9a07:b0:784:8620:1c49
 with SMTP id 00721157ae682-78486201eacmr444866607b3.30.1761510975632; Sun, 26
 Oct 2025 13:36:15 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-1-surenb@google.com>
Subject: [PATCH v2 0/8] Guaranteed CMA
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
X-Rspam-User: 
X-Rspamd-Queue-Id: E4BDD180003
X-Rspamd-Server: rspam02
X-Stat-Signature: efqy5jn7re3sis8b81ghbrzk7dctghnp
X-HE-Tag: 1761510976-100138
X-HE-Meta: U2FsdGVkX1/ej6jEkj1U2/1a5vv1exocRcbsQOfbboQ+zKWzT4LcDXq2xJwspzoyYF5ZWR61jEadIJTT3xLNR9jkaUF5/hws1RLnkR8QO9Gj/65guIYDqhAI1P/7bI/tU5eJKkKhk4CdvDI9Jbi4jA2mF3LtsuMe8MI7kzUmpWbb2qCWdUdhatb+D5hJwFVX1jMIQOzJkQhtp0iEcyQaNYKHxodrdAZEy85SeadIZURIZcllKK5k/ZTvkbKrsbLxQsj2lXrk8UJfWsnBDE4Om30foPw35OWOLMh/cH8jTXXLXNA3coc1vFL+K9lL3ei6WDK6S/OADiWqoJfiBblYtMasJmffvTQfj5I6JywqJJHQk1lGOqRlsQfMAbcr7M8BCl9VSluVBX1aE28yOjiPNhXrJVMUgQmWgSDQIItdek8n3usU4mTfJDvy7X/mMgETAHK2+somv/jPTG1mznEHz7ISyQOGGzsGD4XswzFb+ybtLni9Dv4pEpJRy9/da+K8noLljb5dOqcHEbAfa6dHJvGH6aIdx/XPai+hKauishrUQSsYnDFqqHEr3wxjlI9BKhtePT3ZMslq5HW8bOa010hujF9+ByZj+IMDmtCb//uwjBDkpKVrm6+j30L1Wv8g+af9huYAM+KmBNpeSv/eN31Mj+Rz+pDsMVI80e0rrREDxWEN5NocTZvQkrSAof3ttUNS0sUoNf+amEgavARLxnLV4lAi9om2EquHzWDqxFr/Ii65DpcNc7cNM9t+oRU2eteiIgl7wqT+/sM42a4gq+iSHc6rn6p98PIvgVtdRLRoezuGoICnEZ7lODkUlJlJFM6uMmkLRC1BKO5h9mFrrA99vr/mo1LtVtlXdi4K2YE8OmFMPZy1gFMtMwbnm9x3PR6KEJAue7HlMgpnm1M4u+gUvdfAbH8t8ynRBx7zGLFvcnUbGea7J4nqZjxIhlnKOnvTDziqdGZf80urX2r
 LJqOoYzc
 LhyWD2YAZBC9t1b1YEzwddUGbYkSMzylkGHnyGRC7fpEQr0BFm8xVcNL0CWJRRvwZoLBIzKqQc9VsRe3lcDDSOUHPUusn07JJ3YH9hvx+2So6zqcKIL8Ffj3JeEZskYfbuCz05r8CoqMYwbp2/Wem6kAhQ2yq6STAVqcWHKapkiSLQcrDKPPvQfSKZ/0Zzt0yI/AFs5dR2negij68EIYJFFjjMnRUJq6CCv4nK/70rvozcuhmMkTAXWV84amC7j91YBj9b6uzOq/ZWKw87T7aJwtkpZ0GwhYaPQ7Q4CHyOQjWTjfXG30xmhQ/QhUyLYKfooLg6Q5K66FkZoLvI/hfqKysvg/Bdo9nky5b4M7jU1SHsE0+tooI5cdSOJ5a68OPL5aLsSqxy598CCSBVTXKYpmSqiOLd9UkxsrZBLPC27Sk6WrdE1i+j0UeFEr2U+QeVhge8xdDPJuBvXgzu+LVQnHEyyDQc0PM9hDQbEogR9S6Peu8E/jIUi56aVI3HrVvt7YxG7zASc0/3C2kZwHNHFsx95FQpmAUGorGKqHDgydUtw3pfodYQDyUBZsNZ6Bl0GSsQ7eQ0MwKB2XJIrI/vF3MUMwTtCrVVRtPir3Vlv1VjYvjW1xrgduYXbDKf842N0dQrLmm55Yt6yisC2upSDK0lQTEv5/CIsS/0xjr+2bZyeRPrdJ/XBLlpI+eU2+4ysWVDbzdPDf4ihDmPy4tYhojDA==
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

Changes since v1 [1]:
- Removed extra address_space parameter in cleancache hooks,
per Matthew Wilcox
- Updated comments to replace page with folio, per Matthew Wilcox
- Removed unnecessary new abbreviations from Kconfig, changelog and
documentation, per Matthew Wilcox
- Removed unnecessary comment about lock protecting xarray,
per Matthew Wilcox
- Replaced IDR with xarray for storage, per Matthew Wilcox
- Added unions in the folio for aliased fields, per Matthew Wilcox
- Removed an unused variable in the test, per kernel test robot
- Linked the cleancache document in mm/index.rst, per SeongJae Park
- Split cleancache sysfs documenation into cleancache_sysfs.rst and
linked it in Documentation/admin-guide/mm/index.rst, per SeongJae Park
- Cleaned up free_folio_range() code, per SeongJae Park
- Reworked gcma_free_range() to handle failures and properly rollback
refcount changes, per SeongJae Park
- Removed references to transcendent memory, per SeongJae Park
- Other minor documentation fixups, per SeongJae Park
- Added Minchan Kim as cleancache maintainer
- Minor code and documentation cleanups

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

 .../admin-guide/mm/cleancache_sysfs.rst       |   51 +
 Documentation/admin-guide/mm/index.rst        |    1 +
 Documentation/mm/cleancache.rst               |   68 +
 Documentation/mm/index.rst                    |    1 +
 MAINTAINERS                                   |   15 +
 block/bdev.c                                  |    6 +
 fs/super.c                                    |    3 +
 include/linux/cleancache.h                    |   77 ++
 include/linux/cma.h                           |   11 +-
 include/linux/fs.h                            |    6 +
 include/linux/gcma.h                          |   36 +
 include/linux/mm_types.h                      |   12 +-
 include/linux/pagemap.h                       |    1 +
 kernel/dma/contiguous.c                       |   11 +-
 mm/Kconfig                                    |   39 +
 mm/Kconfig.debug                              |   13 +
 mm/Makefile                                   |    4 +
 mm/cleancache.c                               | 1127 +++++++++++++++++
 mm/cleancache_sysfs.c                         |  209 +++
 mm/cleancache_sysfs.h                         |   58 +
 mm/cma.c                                      |   37 +-
 mm/cma.h                                      |    1 +
 mm/cma_sysfs.c                                |   10 +
 mm/filemap.c                                  |   26 +
 mm/gcma.c                                     |  244 ++++
 mm/readahead.c                                |   54 +
 mm/tests/Makefile                             |    6 +
 mm/tests/cleancache_kunit.c                   |  420 ++++++
 mm/truncate.c                                 |    4 +
 mm/vmscan.c                                   |    1 +
 30 files changed, 2537 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/cleancache_sysfs.rst
 create mode 100644 Documentation/mm/cleancache.rst
 create mode 100644 include/linux/cleancache.h
 create mode 100644 include/linux/gcma.h
 create mode 100644 mm/cleancache.c
 create mode 100644 mm/cleancache_sysfs.c
 create mode 100644 mm/cleancache_sysfs.h
 create mode 100644 mm/gcma.c
 create mode 100644 mm/tests/Makefile
 create mode 100644 mm/tests/cleancache_kunit.c


base-commit: 752c460b5865d87117095c915addcce7a68296f2
-- 
2.51.1.851.g4ebd6896fd-goog


