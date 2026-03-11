Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FF6103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2766B0005; Wed, 11 Mar 2026 17:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190F86B008A; Wed, 11 Mar 2026 17:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3AE6B0005; Wed, 11 Mar 2026 17:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA3336B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:15:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D1031603FA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:15:39 +0000 (UTC)
X-FDA: 84535038798.11.B65CA3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E46940015
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:15:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eL10D54F;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yOEFOtNoyJvnv+ypQm62swZPdPqWAjqNcltCueE8x/w=;
	b=aEG7biw6ElIDFsqFnUgwD3dHYQ6gcPcRS2/VfZn2eiy18EeMcUD9KhfWcnydZM8HJ23g8u
	+1tO/YYEIRpDNikpxlWRkY61lTY6m3Lll/OoxROhW5UHlYdzLD7eEmf8b4TbC9yFK6Sdx+
	cYmObQSkrDN3/pytMag9V2NLCekvIU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eL10D54F;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263737; a=rsa-sha256;
	cv=none;
	b=B+QSmcAfqAaf5wPEimd2QnBJfRWFyVvMiRIgmszOyJp48EsX8wO0mexHJxDoBr99XfS0LZ
	s1lMmI1Wjet+ZeM1YTT/pkfNvCR+fTpLnE9IZzyhMddi/iL6mbOBYi1U+IQCFNq1kZcO09
	ow0RC0IE4LSC7eoppUO/ZprNDxjZz6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yOEFOtNoyJvnv+ypQm62swZPdPqWAjqNcltCueE8x/w=;
	b=eL10D54FjlDDc2la2tHzpj5iyHbn2S/gDsMLxwqwejseAe4m6tRt+LL2dmA8yu2lBcMwHJ
	PGds0JXcBVm9z0arzS88g0OQ1tLoyVQeEswMNMSqENgge14NMtDBXhbSMaVmM9iEKhr/lw
	lXWY2ygUJ8ZjRw/0BQ+5Z0Y3hI22LcU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-PO0vbtmoMt6CjKGN50MpqA-1; Wed,
 11 Mar 2026 17:15:33 -0400
X-MC-Unique: PO0vbtmoMt6CjKGN50MpqA-1
X-Mimecast-MFC-AGG-ID: PO0vbtmoMt6CjKGN50MpqA_1773263727
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD3311956096;
	Wed, 11 Mar 2026 21:15:23 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B9DE230002D2;
	Wed, 11 Mar 2026 21:15:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v3 0/5] mm: khugepaged cleanups and mTHP prerequisites
Date: Wed, 11 Mar 2026 15:13:10 -0600
Message-ID: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mJX-Etu-L8HQiZbOV5XtMcjoY32UDR6crNsyWpuyQ70_1773263727
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E46940015
X-Rspamd-Server: rspam08
X-Stat-Signature: xm9p1ekiw3sc37n5i1dy3s7pudyfzfcj
X-HE-Tag: 1773263737-532834
X-HE-Meta: U2FsdGVkX1+LzOSU7Hv9yd6+IpYuw4Sq9/dY7K1NLw5Vg1iYg+clghSmxO7ThQUgMZ9gjhL6AYOLM+qwFz3FCyCS/+NNw4V0cRPaa2PnDhZhy5GjqZVKjG76cQH3J1gSXmR/m75jfNZlxl8D08DoFPIn+iJQNj9U2S4794kyB7W8SseredkyiNhKOHBhzyOmTU46fwTpIU2p5+V2aIc8hezGYaFUKbrgg8NgazpWqvLadmie5m/KGJArhiELatpE6GRDDuLs1d0Ukl6Ft7Kt9pNLUN4izmKoU1+rf19+kllf812l65Jsaa1yRocqBlawNvLRHr+OYtIn5OzSdhcVKrz+rMgxpuaR+LVcRWsIc13Ic4lhNmvXYuAUCi8L7A2eMoTHDhAHQu0ZoDYCl/BgAm5YRcYQlpp4VGR3LFBnkV9qbv8kOh5RYFonEgE7Du+phlZT9f/XPAg/7nFaYvNPmSWApyAQLjqjMzUzXkYrlrqvFZoKDQ+LXbNPBs4luPeXiLcj0g3UxL+I++0sT7CuY9d7tz1vthIedA9VZkmhZ4gHI3lakxpgsKvxHC2w+vdoJ83i8o9osqPMleMTztoYEOXdTQNxSHmBqw/xIXLyg51CPaKB4iDc9xoQHs+wpzGCZwNBu5wu0xVFy70503wrDMlQeOWFQDaBAT9zeAAbxkRf527MX4cI3uXCAbFSgK7QR2qBeW8vo8LfiU/Yfm6s3/k3YlVj9fsXNxjC7XUtTjb461lC4WVYUYKqa3Qh23dbPZGVfe9m38v+rRXWfi6Tq9ulhQtH5kw+sfiA5HnRl/alXkLXff6ZgbRcaMgWnUVDq73BqQNZeyr3Zz+BsCSXEdoOPhnA008yY9fM+NlUXAve15z96+0GvqKkSl1DEl2Fxu4QAdqmt00gn/nrif/AomOocgu8O9Ih4H+iuwGMnS3IzYE5/Po1acIkm8yqyBwqg8pNkAdyg79q5fAr2W0
 ceDJwgto
 6BLiSbc6MEY5XuulJayzsXulcZl3lp1wSe1FGoFRIhlSwqb4xMbSpiC+/xooz//zuxSV2sc5nK79d/SBIYvCDMcmKWakFTTam5GE1cxXuOFMBcTw2+jtg7nSFs5BldAVFCvxKegm0T/0THeafAqi/yW93cGaZpU2l5L4tH45eu7KR1K0YRrpnFMTvHD/pRqxbse6JKFHeCWeo5dPYKouClQ0T86Va7TToE59jl9kZggNv+fYK0o7SdPtiInGj05AKiHkyEv087hDIQQkx/g3TLk7ZN4w7k1KtErN/6HZVxE21Q4hW7kPkEWOzodCjYoXqlz4LIW5yVZduI0A60C/wvIJ1dbGrkJGe5B9xtGf3lYrdFgiQZIYnARCy9e6ZfPO4Bu0WHF4aGPg6fBwG6db9Odq7+Ui+oXVfeiQzBwL4z/1GeNpx10IZ91C78A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following series contains cleanups and prerequisites for my work on
khugepaged mTHP support [1]. These have been separated out to ease review.

The first patch in the series refactors the page fault folio to pte mapping
and follows a similar convention as defined by map_anon_folio_pmd_(no)pf().
This not only cleans up the current implementation of do_anonymous_page(),
but will allow for reuse later in the khugepaged mTHP implementation.

The second patch adds a small is_pmd_order() helper to check if an order is
the PMD order. This check is open-coded in a number of places. This patch
aims to clean this up and will be used more in the khugepaged mTHP work.
The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1) which is
used often across the khugepaged code.

The fourth and fifth patch come from the khugepaged mTHP patchset [1].
These two patches include the rename of function prefixes, and the
unification of khugepaged and madvise_collapse via a new
collapse_single_pmd function.

Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
Patch 2:     add is_pmd_order helper
Patch 3:     Add define for (HPAGE_PMD_NR - 1)
Patch 4:     Refactor/rename hpage_collapse
Patch 5:     Refactoring to combine madvise_collapse and khugepaged

Testing:
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- selftests mm

V3 Changes:
- Patch1: leverage folio_order rather than passing nr_pages into
  map_anon_folio_pte_pf [2]
- Patch 2: fixed conflict with is_pmd_order
- Patch 3: Change COLLAPSE_MAX_PTES_LIMIT to KHUGEPAGED_MAX_PTES_LIMIT [3]
- Patch 4: conflict resolution with other khugepaged patches
- Patch 5: Drop lock_dropped unnecessary change, Dropped Lorenzos RB,
  !triggered_wb in if statement rather than triggered_wb, remove
  unnecessary mmap_locked flipping [4]

V2 - https://lore.kernel.org/all/20260226012929.169479-1-npache@redhat.com/
V1 - https://lore.kernel.org/lkml/20260212021835.17755-1-npache@redhat.com/

A big thanks to everyone that has reviewed, tested, and participated in
the development process.

[1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/7334b702-f6a0-4ccf-8ac6-8426a90d1846@kernel.org/
[3] - https://lore.kernel.org/all/25723c0f-c702-44ad-93e9-1056313680cd@kernel.org/
[4] - https://lore.kernel.org/all/81ff9caa-50f2-4951-8d82-2c8dcdf3db91@kernel.org/

Nico Pache (5):
  mm: consolidate anonymous folio PTE mapping into helpers
  mm: introduce is_pmd_order helper
  mm/khugepaged: define KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
  mm/khugepaged: rename hpage_collapse_* to collapse_*
  mm/khugepaged: unify khugepaged and madv_collapse with
    collapse_single_pmd()

 include/linux/huge_mm.h |   5 ++
 include/linux/mm.h      |   4 +
 mm/huge_memory.c        |   2 +-
 mm/khugepaged.c         | 187 +++++++++++++++++++++-------------------
 mm/memory.c             |  62 ++++++++-----
 mm/mempolicy.c          |   2 +-
 mm/mremap.c             |   2 +-
 mm/page_alloc.c         |   4 +-
 mm/shmem.c              |   3 +-
 9 files changed, 153 insertions(+), 118 deletions(-)

-- 
2.53.0


