Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF68DC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C028E008C; Thu, 24 Jul 2025 10:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B188E007C; Thu, 24 Jul 2025 10:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213EA8E008C; Thu, 24 Jul 2025 10:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08E228E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:50:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C867B112F31
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:20 +0000 (UTC)
X-FDA: 83699443800.13.5098B94
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5AA21A0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=G3hkixuG;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fS9OWyJbPpEsH/fW6OQdDGwdjRp2ObSHOn87Irzwk8I=;
	b=phFPVXooC8QVh9P8CH9ur1wdU28emoT+D85UjftMiZ299HTde0JeBjG+WSzDS4Y2/zvH4u
	qQ/UwgjVsWnrVopQFBBZ7zp2T/6dWrL3iJ0JqghlH600zNebjUMkA4G/1lVkpO3azCDKFG
	9KNGc8JgGFOn1ACAwO7/6shj5RBFg+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368619; a=rsa-sha256;
	cv=none;
	b=xNRHf5Vt9lMhgr9Vv36CgQkxQauOUCrSKjaOj+RLhK/CnY6A9Whw8DEJsYS6cS2YG54N/N
	gK9mLyUY/hxXt8k/wQafD6BpfSnLKyqu/zbEY2HiSEGzAjaB4PI6CpuA/xSPkIWP93riMn
	tr0joV8HqeBSGiIHZJTzNTFgrRWX5WM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=G3hkixuG;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4bnv7B1KYMz9stm;
	Thu, 24 Jul 2025 16:50:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753368614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fS9OWyJbPpEsH/fW6OQdDGwdjRp2ObSHOn87Irzwk8I=;
	b=G3hkixuGy2iT9/rMJjPGsiha3G3CnlYQ258SFcF29XSWTolRbz4jZV4wDtULRnnf8ZVv6d
	MXbkidVbRoD/enAOcF/p3E4FHBdMQa+LPl+XBTzAeX9f1D9ec2+09c9p7QSlJ0c7vYOAAn
	Ykc9ybxvcjQHOD/4a/txSNSF1BlT26NHSh+XhGLWyKR1JpCTHIolM3+rDxZQdy011QkfHG
	zWOSodQymc01EluSuGV54XQ0edTElbJH5iXfgiaXkdsS0sg8U4bwqUdnm/hEHdugHMkutS
	Ut0q/B5aP79SLLyeiBZ/SVdcbtIqsfvvTt9DtCIgwktXeawVwV7760597jeDqA==
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
	willy@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 0/4] add static huge zero folio support
Date: Thu, 24 Jul 2025 16:49:57 +0200
Message-ID: <20250724145001.487878-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5AA21A0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mmzr37zd93d7c4rx6q71qtm59rdn37kj
X-HE-Tag: 1753368618-919986
X-HE-Meta: U2FsdGVkX1/I5IyHExqQe+AYKbOt3q/0VDzqgSPwdu6oBdxQGyVypdDZGzFxJ5gOclHRhtld/9A4JB3BOfNubeJ42cORK5lca3TAqRGeHWioo7Viffy8UjWrZUCtpRtQwy4qvoeNsU7MjM7YBvr+OE6pIagFYJWweTrI6Ok4pbXYcFh5pOt97wwfShD9rnJgAB+MDyfaAZaBJYdSpcmQJcFk8zIIdcsJuGfuLrkhdpTDemCoT513S81B6vYelfZzyTBP5VUWL2EttZBE3Boc2955pOtSU1d6/yaMFGIqvcD2ohTLjLrnaW1u3WhWnyo6dZTLMxLE4YH9uE7nhDOsET5j8m5dxz4SMXxieXyXiTSXq/jVPTPnYu2sAL0PghYYbybqADJJS1TUGDXElVwGDiD9DE8Wc7ioZBArKmNbvvUP9BG+Wdhjb5Z+fldnXbgvlSjz2jXCqMPLHo5Tue9La6cFt0IW2rnNoEU8ka1gs0chG3YunyFhi51IDmQ0v9RnEYmdLzwx3w/RJItT+74Gkdo35+afKJS0goEDJrAi2eA1qULqKuLe/c1k55yLRvidYrWPdewWLeDyYW/2ftnk9JtVJkd7o36A3mxuMBFRM8VsWAX8vMKFaLOY5OJfUoK18b8rhOUxhyqnWhY5Rw4vUBCjhtXjPT/CA4VRtsIx6Ma1JQGOdrBzS+TTRCD8dl9XkxBCVeJuyxM89pXJ7sstbn2kgyEmr60hpVtjNHTwADBIOpE/KUXmZralwqFvMQmM0Bs/3dvrSk6WhyekQhu9A4XwLYj9pDtcDsbckm06UxrTY0B71nydfw4uPiyoKrV7n9+QbjpWkSPi8MzNvwmtNFgCihRIbONd1JA/+F78n7BFeJYEVtiSTn089yRsETtdwKwVdkyELwOAm1nlwYJUYARt3Ro+EbKBkmriZhDXylyd6hkCSkiXXpUV1SXJfGVtdQMjGH/8rnJ/aeI1oqz
 /ZX6UfME
 888DiIVP2z6PDXRedLIiiQ7GoFyRP9f+PJX3s7ygOdyxiKpeteeZV8OR5nOHs3eQJC1f9iyVfyP6OmJGxmC452lWnAzqTkMwdFfiM9nJFAndekzeQt0NHdvYADlytF6own7RNnzvTQ7kZAyHhxe1KISgtA5xpoLbTWO5M7Wld5ZizcRkalRDGMK+y4HyiQBByOLnJdB4b6b3z5kSd7GTiSb6h6UCF60iW3HS2eHnUiVRWwttGZ3zlErJjR0IAIyXAqOAZ2NO22pinae53xsI0Fxhhsf0yLTFn/61et+JnkxSi1h0qnXH7PfVjG7KJ/SCKFuBMZYGAuGVwpHIWOMo07nmdt1URz9jSNqNc8KXPOUg9WyD9h0JWU+59ipGpBvShAGJi48gHytHi3tKiSXar86gvO4Aj598bTYrMAPtw8N7l1pdUTBdx1zM85u6hu9+gGa0K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

NOTE: I am resending as an RFC again based on Lorenzo's feedback. The
old series can be found here [1].

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

Changes since v1:
- Fixed all warnings.
- Added a retry feature after a particular time.
- Added Acked-by and Signed-off-by from David.

Changes since last series[1]:
- Instead of allocating a new page through memblock, use the same
  infrastructure as huge_zero_folio but raise the reference and never
  drop it. (David)
- And some minor cleanups based on Lorenzo's feedback.

Pankaj Raghav (4):
  mm: rename huge_zero_page_shrinker to huge_zero_folio_shrinker
  mm: add static huge zero folio
  mm: add largest_zero_folio() routine
  block: use largest_zero_folio in __blkdev_issue_zero_pages()

 arch/x86/Kconfig        |  1 +
 block/blk-lib.c         | 15 +++++-----
 include/linux/huge_mm.h | 35 ++++++++++++++++++++++
 mm/Kconfig              | 21 +++++++++++++
 mm/huge_memory.c        | 66 +++++++++++++++++++++++++++++++++--------
 5 files changed, 119 insertions(+), 19 deletions(-)


base-commit: 4c831e7a4b72b7ac16b84e4317dee635b170a663
-- 
2.49.0


