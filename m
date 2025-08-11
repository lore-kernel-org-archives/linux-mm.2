Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3F2C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148166B0131; Mon, 11 Aug 2025 04:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F91A6B0132; Mon, 11 Aug 2025 04:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E346B0133; Mon, 11 Aug 2025 04:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E00666B0131
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:41:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9330316073A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:29 +0000 (UTC)
X-FDA: 83763832698.13.4C77C0F
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf05.hostedemail.com (Postfix) with ESMTP id B3454100007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=0uHcpPOA;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901688; a=rsa-sha256;
	cv=none;
	b=plcbFF4iXFBwZy5At5vCEsmGPnRrZQyBHvOqy/+wQmEIrXgXg1sf7rmEp3lbWBpVv6wg3Z
	f4JcnellkrV44phYLaqBKeV43YX/jelZ1wyjSR7tvioVXckn5l86rEhqviKCNgDSjKzGWj
	YFsZofSxgctT6K7Y8llDpIw0r38hG+A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=0uHcpPOA;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eqFGyknN2UA223blsyE9lPSzdzYime/KN+7g1ZDehew=;
	b=jyocpifWHn3fCqy4FrpwjF8NP0xy0LTzWdCxGSgL+VCT/3PScv/4MsOoMU9a25/AZcguCR
	CupZBkbshzfxwFZe+LPwgtH4pwrXwTCqoMoyU0hH8H5ExTuZ2jnZw+Fo/x/cCefv4RA/Ap
	mDaeYjbFDRHTy2CMgvWlfWg8ufK5V2E=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4c0p5H3gJKz9tWP;
	Mon, 11 Aug 2025 10:41:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eqFGyknN2UA223blsyE9lPSzdzYime/KN+7g1ZDehew=;
	b=0uHcpPOAl94dCRA/8o3A3PeYhCLdXaAVP6t54RIBNY9rjaH6ZH9/G/P61TB6a4DoQLb6tA
	U0nLgf2w5tYZg4qxpZlE28r1S1C0xaZHmHdIULCJ099tRqkUg+7q/53GzPHI40dz3wbpst
	Kzy/jUkXbEgaj+CxELxmv4PYKpgFyo1SE4wjqFrl46oeVa3ewUmybS6tv1zbJVkOodcUZJ
	AjOsQBrPY59/KBg0nBwrativfkIyABaMLeH18bK95r355NkNjKPhDdxkW2KqmTSYOHVzEI
	2DQUKjXDV/CNr2FI2ndKh0DOpe7Dk3vm3wFJVVO91oFQZyPHBc1PFOmevxdz6g==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 0/5] add persistent huge zero folio support
Date: Mon, 11 Aug 2025 10:41:08 +0200
Message-ID: <20250811084113.647267-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3454100007
X-Stat-Signature: rsy56npxzk49qsbkgke8ng1b156hdin8
X-HE-Tag: 1754901687-514093
X-HE-Meta: U2FsdGVkX1/vmC8zQvrEAnjIhUsRdpdra4qUGoTS+8n+wN0YaBjZHFJotyM0QK+Rn/ExaEClHTOYGbwXeYunz7y/Kgte9lg4LvAtKgKgztPsWGSGoyQMFm4Du8FnjhWuDplkLqv9tlw61NIjttyTTUZGM28HpZ9fZLUeKdgSz4LQiW3mSMpF4/uwzYgASZ6gj9OG3g7LTEeLayLxzIMMtzeVIp+dPslREMbNXCPI9OVKl82CikObNJ7LREdNwjVBBCKMegzaXETCWlDJasofmKFP5NWPNi4Fwjo4kNBYxjqE4FqustUqCi+oBuEvxTbfz0TCfYajKVQiZMZkwozBmJ/q2Xao8xZtVl6r9kWalLNbyPJX5TZxw6DdJmukw+eoCiIxLQdphPjJgMQH/tn4ZOjl7TWnmplgeb0aQf9DeUswlc2+iyhEed+7mLYcs/VZFj+C2iWXkZ6/MtmXaW3bMZ5C2zXVUIYQLYNkc2sI9KVE7fBlqUNvxyPIWneF7y3EwzAYo+0lAPMBeWc7A+AeJ85UVevh2uagrRcIvKDKbjx1A4IoRAGYhC1WtDRGjiaqbS7gyI0biqJIR+OOY0gPiiP+ZP7V27WFru+7tPg7w7z72JsUXgf5BlR1M/71urFno6GhnsKk5EKRddnZPyD+ZHLtWBFcC9/62EjAIqu2uOZSRUVYKwU9+2slFn0/gI94uocEhrWAWxua5ts2Io3B1UHCirZZHRT1Dajp4k10LacD21oCeOseTPagYW654ZYYWOy/aWlGayZrHzwe49mxuXek4LJ4+EkCyQ0tRhmZy+uA3Nu4zWRNPiniVxGpAP9jPDpny8C7hJuF6FLAqP1mJDvyHIpy0deffYsDIn4cfcRUByqTCtNDQxPJ2X5eLK6Tl2CFcrBahvJOOp1lilsOIoayeJf+MS393brOM9/Fk2XKLqJshOJpEZ8PurhtwBo9g2qUgqQOSYzwLTXoYzs
 epJaj2CI
 3Je0Ifw2yDfnBh6khHEYDDt9FA0QmtFsfuUwxbvCYPSdrqp5RRwgOfkehodqbz41jUvBewNZemnH26b72wnuUG+ZV3F1NOvJRi4IoIKuweq2MlnC27LWZMRCCU6ibsOhy1er25UrYz2BRrrpOQpy8o0plToJ9d++J+XcC0qmeiCKRbJTMG4SrXbBq4R8u/Lpu2uN7+UmS9bQgw9oQQRy9CX2sACOGuKnvJAorhPenx41q4S1w0n4CZDwMXXDZ9Xf8JzulFi4vDRl2s/zZtqUzpHQVEt8nqTqseKJO6mc38GnaCXqExylPxD/qBfe+2ml9ubPgCSWPU4eiXlQ1d3Q+krmwh701GK/Cu0d26f/NUqhChplFS2atFFukH8h0XzfUqvKdtMfT2TdWPdfy7ZNBJyHwfZh6ZAGrVEd6y9hva9u5QvMVSxCkTKVmUL7ma1frsMLtiu0ZdnOLwR/+tHj0K4aAM52dZPJ35Xp+9irliZrBXE0qtIIMM27u0KDfuv4DFXjl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Many places in the kernel need to zero out larger chunks, but the
maximum segment we can zero out at a time by ZERO_PAGE is limited by
PAGE_SIZE.

This concern was raised during the review of adding Large Block Size support
to XFS[2][3].

This is especially annoying in block devices and filesystems where
multiple ZERO_PAGEs are attached to the bio in different bvecs. With multipage
bvec support in block layer, it is much more efficient to send out
larger zero pages as a part of single bvec.

Some examples of places in the kernel where this could be useful:
- blkdev_issue_zero_pages()
- iomap_dio_zero()
- vmalloc.c:zero_iter()
- rxperf_process_call()
- fscrypt_zeroout_range_inline_crypt()
- bch2_checksum_update()
...

Usually huge_zero_folio is allocated on demand, and it will be
deallocated by the shrinker if there are no users of it left. At the moment,
huge_zero_folio infrastructure refcount is tied to the process lifetime
that created it. This might not work for bio layer as the completions
can be async and the process that created the huge_zero_folio might no
longer be alive. And, one of the main point that came during discussion
is to have something bigger than zero page as a drop-in replacement.

Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
never freed.
This makes using the huge_zero_folio without having to pass any mm struct and does
not tie the lifetime of the zero folio to anything, making it a drop-in
replacement for ZERO_PAGE.

I have converted blkdev_issue_zero_pages() as an example as a part of
this series. I also noticed close to 4% performance improvement just by
replacing ZERO_PAGE with persistent huge_zero_folio.

I will send patches to individual subsystems using the huge_zero_folio
once this gets upstreamed.

Looking forward to some feedback.

[1] https://lore.kernel.org/linux-mm/20250707142319.319642-1-kernel@pankajraghav.com/
[2] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[3] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

Changes since v2:
- Minor wording changes. No functional changes.
- Added RVB by Lorenzo

Changes since v1:
- Simplified the code by allocating in thp_shinrker_init() and disable
  the shrinker when this PERSISTENT_HUGE_ZERO_FOLIO config is enabled.
- Reworked commit messages and config messages based on Dave's feedback
- Added RVB and Acked-by tags.

Changes since RFC v2:
- Convert get_huge_zero_page and put_huge_zero_page to *_folio.
- Convert MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.
- Make the retry for huge_zero_folio from 2 to 1.
- Add an extra sanity check in shrinker scan for static huge_zero_folio
  case.

Changes since v1:
- Fixed all warnings.
- Added a retry feature after a particular time.
- Added Acked-by and Signed-off-by from David.

Changes since last series[1]:
- Instead of allocating a new page through memblock, use the same
  infrastructure as huge_zero_folio but raise the reference and never
  drop it. (David)
- And some minor cleanups based on Lorenzo's feedback.

Pankaj Raghav (5):
  mm: rename huge_zero_page to huge_zero_folio
  mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
  mm: add persistent huge zero folio
  mm: add largest_zero_folio() routine
  block: use largest_zero_folio in __blkdev_issue_zero_pages()

 block/blk-lib.c          | 15 +++++----
 include/linux/huge_mm.h  | 38 ++++++++++++++++++++++
 include/linux/mm_types.h |  2 +-
 mm/Kconfig               | 16 +++++++++
 mm/huge_memory.c         | 70 ++++++++++++++++++++++++++--------------
 5 files changed, 108 insertions(+), 33 deletions(-)


base-commit: 53c448023185717d0ed56b5546dc2be405da92ff
-- 
2.49.0


