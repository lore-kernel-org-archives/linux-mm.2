Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF42C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817B26B0095; Fri,  8 Aug 2025 08:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF306B0096; Fri,  8 Aug 2025 08:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704C26B0098; Fri,  8 Aug 2025 08:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 607F36B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC576135547
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:05 +0000 (UTC)
X-FDA: 83753477010.07.7B376AC
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id E019A10000B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=agCmlyBq;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gq0OeZwDaL5z5Xu6wgwBz9txTnznNgka8W43C8hPZ/U=;
	b=YnJrnj3MuJs0iJT3VJfFwPtlFn5E+Lrj3RxLBuPk3l1tPA6/QSkZhpKJERzRnVlp2VimzN
	9QAh3QT56+AOGsf0hfe241/xZPh0N6TCw7RNgqQhhM/IN5tex2nPT2u7/Luo3i1EedStJu
	NDLWZb4lEJsCBUF7tWX2LzUJ5JZlhqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655124; a=rsa-sha256;
	cv=none;
	b=QqXKxjdiN+Ji12hhxy38FZv7nUnVyAGvBbvkNYa6nWrNlCKMyRAOjJOD6IiufxPCRZeB4K
	LkJJLRNZKFkz8EJq1ZjwpGJ2odgwu5N0a9PTBkMa7yQz7HPZ5paSu5deUvATbGTh3dNc8p
	3/mKhHXaefVNShb9PDSUn2YdKTQQzV0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=agCmlyBq;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bz2vg0pGGz9t1l;
	Fri,  8 Aug 2025 14:11:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gq0OeZwDaL5z5Xu6wgwBz9txTnznNgka8W43C8hPZ/U=;
	b=agCmlyBqWDI8uXws05wegBw8VNYZvzogW5ivaAEBs3xIwAlLVJ6L/os842wAkcEWfawc9N
	2pnXTagI7x0qBMbN2Ah3ELpQXd/gukSnRNzFJTAYT83in01gDtHxJhq0HUrL58I4fU6JIn
	YzMBuS7ykB/sEQo4GbjN6h+fausqFyd/yBCWUnhRqCLtde14cWFBBaN4O/W11fqmFqBHs5
	jrxJk7bM7ljUqjmib/b4ddOG8/exmYXkUaIf3jcAW8AMBUKkx1fkz9dZpW7Wd7KNjOB2IM
	EuNTFPA3vV0TGX90DW4wDGkT+ioP8wwn0HwgHaX1VPQn22HzG//DLnKet/IkTw==
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
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 0/5] add persistent huge zero folio support
Date: Fri,  8 Aug 2025 14:11:36 +0200
Message-ID: <20250808121141.624469-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E019A10000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: u1z7bdn8581f7chkgmquk3o8pjnnb1ya
X-HE-Tag: 1754655123-215001
X-HE-Meta: U2FsdGVkX1+drLmWhy7jSvVtClbfIxQXF56/oJnrQj4lsFQEfntGczitu2qQKifgs7ZM0R/rmKhVnkq42kjO/LeaAtANVY9J6Y7QSTZVEOrXtF6kuubJZChqJSR9H2JPnTE3Q9USSz4N234wRWWr7pGu4mmGjTBL6J9uwGooFPE46Mi0XflNcN9Hv5pzghHcRXzrG1hy+zXMxcQSJ37BfEbIXWfNREIu7xb2jBjIPmd4wIdtuD+LH0STD2j/eGxH61l40dk/2KEaFq2BRXK22hhEB/9Mwn1r8W31TtEcMLr9qbmjhDnivNMmtfZ7CLWH58ggFAvvBxgzVFeYLyWUU11vzx6Q7tIf0E5mqKY+tlLSHckRpEX0P99L4cC3DG5lUVsVt2Mb2fcHrrmL4q49cIW1gWbrcj1ox/qrdDwvCw5AkigJ5VlQUuXfh40UwRW/QjnrtZdrYdRGPa8nnFrmZhDdET8KwlpwRJmmHDmKWrhVlM4BUUggACI6N50tf7sZhc8YrD0XeLJjFAw0s+uoWHH8cdCPNEqdrdTiaX6oL0YNFNDTXwi5oXVmb9Dcg0aaW/GUHX+s8cH/SseKR96YAjPr3flWPgXnORbg6eEjcMZOmNiHNajLqpYhrQwHihy2Sryr86WAQGYZ4hKFVOkYwiW0n41RrkPYgDYPCuw0ISqi+Y0z55X1HLPC2Xpof6cV7onqzmrjw4mQX5yGpW2N8NQgo1qtah1ZqJCQhrWFwBKG3rbKPWVw+dvpagmRw9EXpPvsJV6e7DiMnVDVcvjYkWCVVh4LGhAFul5zlbha2GjmW8T7NFucc1udX6cNxfLNUkLVUHhyNEorhGH2mKCS7u3jR3KpGSuOq21arXE7sUM4swRUu+vv7PqAlDjXR4bs6Rtb+NWwB7U9pQEF5padmPfN1/Zj88dTJMgdwyWMoUfIKmwM9HlXjrP3d2qhaLuzYh3zb1lcUEreko69skD
 I6tbfB0x
 wCMP1hUBqk9Ms9RvqoW3TuBHhg57wnxsvq9d7auOFHx8PYvBVKbCxSPNt5qbXKRQ10tMG6JKCM0hbtDs0ZhmzYB3aJgnrJXMpVIkGd9BOqbD0mVcqGmlGZp34sxpTG9zdC9ShHchaL80wLzEyoBLn162FzlOQ9jBE2DCX/NgT7F7coGCW2keZvDGa7vDzGdaLvimcItATlAc3nz13rjs7+flxhPyKPhgcVqdveG2N9lGR4CbBi8yyhyzw9Hb4koyl7thNyS+P1ccVxTjnzhsIxpEHUwgm6e3VUXSNjeiZK88/dpWFoE/v6ba3dp82KjkSZuKNpjrH/cMzEbM/Lo25gTW4wDTLkj47emTJRm8gynRkybbIv9iYN1pW4XUEMQqLa72QOcq5CcsMNzZce5/XgmdrbIFWBp5Xika/pr1FmoLzuTCQ54VDLNnaiyjHFsSISjVNRnbJvzkhcKx+7aqPjbf641XVwBucFmnY5lZb4Ws7sqpYeb9J86xrjSjVmgDD6/d6
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


