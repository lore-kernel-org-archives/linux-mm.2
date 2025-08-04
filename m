Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A385C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC2C6B0089; Mon,  4 Aug 2025 08:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3E96B008C; Mon,  4 Aug 2025 08:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA0F6B0092; Mon,  4 Aug 2025 08:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDFD6B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:14:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53F8456E49
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:14 +0000 (UTC)
X-FDA: 83738967228.14.604B3E6
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8692EC0012
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="PTbn/7XK";
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf28.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309652; a=rsa-sha256;
	cv=none;
	b=H3EeRRdBhiJvr6pcx6oiOKqtTT9LQ6oFI6D2/+Vk/RrVUPMNgP4WZUO6DKezPaoAXOdEF7
	sUa543Je2PdlHScP9cWCGFoXzs4lHJS0/SLz7yKEmGRDnETiWHKlVBtKdLdUT8tpBONoD+
	0buzHIsmTGt4mz2FBDbn7EXATzNO2C0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="PTbn/7XK";
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf28.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=80SiyYCvOTGynbWdEDIlGpTbPo36gMMHdma7I3Bjcno=;
	b=X/Y1xql02KWwQhRrOrPkO1mj3aiRheAWidlJrP2lhkSfG1svcDF4m6TdpRO1I33YrqkpuP
	uzFyL7UKPnwQg9TzBRbuYkJkKy9ETAmo9Jn5m6l95khwth2UD32sDktbNNUHOXrYV/QH8X
	sPRsnrQnp8nVgpo2cs8b1s8v6eS1VvI=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bwb7z3hgkz9tFL;
	Mon,  4 Aug 2025 14:14:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754309647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80SiyYCvOTGynbWdEDIlGpTbPo36gMMHdma7I3Bjcno=;
	b=PTbn/7XKLbSA21l+wNOWj6V3OW0uE7tX20T4O5uEpLTpYrYZxVUcwfyVvfhjaA7Gx7bFSI
	N6WRTKoknHFtmw/C9D2eoMOakgvFcsn6pHbFbrLGnBHBRJ6WVFVwqqPdCXfrUE+ZcBuTvn
	7zNBdPZFcLXLkmAAOUdNVLdfD1Z4XPgesg0OY2Dfga57zZ53Xb1lo3vw+HhYFu7llqmYkl
	uoJuMm7IxQbfmTyJXZ2vp90OCENuqF8FjBA6A9tlY0qDe2pEbS94T5LZKmV4udcfGrQ3j6
	IyYAIRRVc8JVzf8BtNBhk5XrXbd1W1WlMRQZ05mHKTFm7SULsO6H/nwP1GXDuA==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
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
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 0/5] add static huge zero folio support
Date: Mon,  4 Aug 2025 14:13:51 +0200
Message-ID: <20250804121356.572917-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8692EC0012
X-Stat-Signature: 9hihs8inx63aks9d4r7ntfq95a8s6a8e
X-Rspam-User: 
X-HE-Tag: 1754309652-21704
X-HE-Meta: U2FsdGVkX1/q6cj6ETMrTUVDCbKk0j5Pf64326SNZ4pOVOCp0G3NSP2MFfCEcvS4RCwTrfJn9ZIUvLEkheG9th/p0ZiO5Y9rg0jvDrMbUg3l5+4joxsd5aoKFZDB+OG/Nghy+KDqlngD0Zbw/38HXSgo7Jd46S+e7A36Vp/d1zV3BEX5diyV74tzioQJNm7O+YtJAXWFFvH9x8cAUbIcTKmldlLGc3YIHzH12QFySEloykQWwJuvULM/GDoVo+BApMwGvD8kQux9N9nA6NXqiB2QCXDc9ZJPCp76gRU7+wEBqru0k7JuiV4N1xX/wS4hH2peERVylQhG0QtdcjpIvm3CdzbL9r0Woi0BP+loR0O9lOMpbp1SQL8WBMuHv8x5N/yoJwY0MptvItqArCaC3Ymwjl7Uj6x3esp4CdmcwtSsRMcfClVjXTyKlHI28uawtb1P4hXjLh/ayodZFQB/tT1iRrcOhXEsE3WDDhPnOxGV4TQbSBihN17oHXShCEuQXwgh0tvVjzpLxwxobFpkve87vtq6uSP+NN8ABhxoROoa4wry8MyZzuuHRiMW7REBSQ9ffYCzKU9y6IAywnoMsDys8fqGpVFDSJbOsdN2zHEJV9ROt3+Pt18H3dJ8MMFsQgUKJxRVULzrHMgup9NMQa4QbC56Tl77cRohskGjxq9MlOPPVwkFoekuQT28xACY55mDq7z3NLMQQvJg8bJ4ZMjXAA1F7SxtR6du5RZSMMVMKgAIG23M1jFbzZx2kUr7M6/nZAsJH5qc7rApgvAC053HczbtrLwKJhH4eeZ5s3elJYViKVT+uHAy3/owTn9i5Jchjew+o33Lm2WdkTTLrxxE974NOKZrpS24qExANoYTxX7OFBvJpMV5iz4HLk9Ib6yFaLTNH0g7xQqE4zz0yLeZ4eGOF8WPTrGNm6JQutROzDR3agPEI000PYodXSIj1zw2zIOQoLcdhin3ygP
 JCEk9gfB
 vNrSZi0dioK9uX9do1/qQOs36AVTrnTn6bUaWYxLiUdU9FlNW9LeZKB0DELy+koIf9r58CQ0SQ3qrMmGSELzB9QXVXR7PhylLhdlWzZulPpWRkJy5e21ZXsk7Zh1VASyMxXv09tF9shhO3XfP3j9APlUUleuYfvqOY3aJ1BA0UC4mphKF117OzpKIMIJ/gDZwrP42vcbLjnp90PLelvTwVtrG2vV8njylH7xzqgbYNDy/0SHdF2V6BB3EgrgBNZYTv1no3v++ltwE8k4DLKDySYPhvEZ54Lk64y0LPklVtCyd8P8GI69PYq8C7WwFDOEtCnTBJcOg0Nr1I+Us/j1DGaQS+KzPkxKJopo2H24kCWzG5gyaP4pG1n3KOgRXyo8/fG5ZC2rxxCZdLveY7wEn3BmoOXMu5VS4pbUzAIfEF8SU3hVF6Pu0w7wlw8u62SaWHClPg3bAN1jE2vCMVuPRlUgD9+SqCTq6Wh6n3h76ElcuSgO5fEgjfJfeuPoxSLV9gNzUwqLQQoKanXsTyLZ8WNpNZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

There are many places in the kernel where we need to zeroout larger
chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
is limited by PAGE_SIZE.

This concern was raised during the review of adding Large Block Size support
to XFS[2][3].

This is especially annoying in block devices and filesystems where we
attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
bvec support in block layer, it is much more efficient to send out
larger zero pages as a part of a single bvec.

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

Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
the huge_zero_folio, and it will never drop the reference. This makes
using the huge_zero_folio without having to pass any mm struct and does
not tie the lifetime of the zero folio to anything, making it a drop-in
replacement for ZERO_PAGE.

I have converted blkdev_issue_zero_pages() as an example as a part of
this series. I also noticed close to 4% performance improvement just by
replacing ZERO_PAGE with static huge_zero_folio.

I will send patches to individual subsystems using the huge_zero_folio
once this gets upstreamed.

Looking forward to some feedback.

[1] https://lore.kernel.org/linux-mm/20250707142319.319642-1-kernel@pankajraghav.com/
[2] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
[3] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/

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
  mm: add static huge zero folio
  mm: add largest_zero_folio() routine
  block: use largest_zero_folio in __blkdev_issue_zero_pages()

 arch/x86/Kconfig         |  1 +
 block/blk-lib.c          | 15 +++----
 include/linux/huge_mm.h  | 35 ++++++++++++++++
 include/linux/mm_types.h |  2 +-
 mm/Kconfig               | 21 ++++++++++
 mm/huge_memory.c         | 86 ++++++++++++++++++++++++++++++----------
 6 files changed, 131 insertions(+), 29 deletions(-)


base-commit: df01d1162a83194a036f0d648ae41e6ad8adbe1a
-- 
2.49.0


