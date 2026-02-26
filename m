Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0540FD45FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77C36B0088; Wed, 25 Feb 2026 20:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25336B0089; Wed, 25 Feb 2026 20:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD306B008A; Wed, 25 Feb 2026 20:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA5C36B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:30:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E8761C4A2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:30:34 +0000 (UTC)
X-FDA: 84484877988.28.FF0701A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3671FA0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:30:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYPmhPYl;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M0YEBPy3Jmhtqggio/qwqreiYc/B8zsRq7a21Upohf8=;
	b=nlyrj1ZnPDeBW/CQR1c0rwToBoxV5MpvC2NdBDaRKiNq1ia4HNtU/JDYQDZT1Gnue/LOdW
	5TKl4CloX4UWD6qDm3RBYPwJ+LH1D7lHQhFoCMH9Mu4e58S2xsXEYeYzANoeZLuOn0dIvB
	BRWuNoC9MOteUlvKzGC7W+ihJXqO4Gk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYPmhPYl;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069432; a=rsa-sha256;
	cv=none;
	b=7MCVDQclXWMkCE35q36iTUt6n/Uh1/G7zcbt3hFqgOTsqvGb6MQ7Nhh12x8Emm+lIb/M0B
	7PHijzg/v9EfNqZu8BqyrZtw2oMpp0XCPDWqr9PDej2mKcCV80V8+ASDS4psdZt2GzqfVP
	mcd/iEc7nJVa0UwoEVDZFl+Ed3o13s8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=M0YEBPy3Jmhtqggio/qwqreiYc/B8zsRq7a21Upohf8=;
	b=HYPmhPYlXteFpSaay2tTuaWqFOAhAstxdmpa8wfvx5ApaH1hDsJKmF+JZtcOKGpuUAsCWn
	4Bsd2n1pHEITK7crsUkKnbLdO9UUin5NYDcwXw1UYv+o/FmjaOifX9GrbNwLVM+eNGkEyc
	yAcXz7NPemDXZXxh8pQiwOHIUKsl3mA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-QU2Ptz3OMlywVs9V1NyPvg-1; Wed,
 25 Feb 2026 20:30:27 -0500
X-MC-Unique: QU2Ptz3OMlywVs9V1NyPvg-1
X-Mimecast-MFC-AGG-ID: QU2Ptz3OMlywVs9V1NyPvg_1772069421
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1B15180025E;
	Thu, 26 Feb 2026 01:30:18 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFDB33003D88;
	Thu, 26 Feb 2026 01:30:02 +0000 (UTC)
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
Subject: [PATCH mm-unstable v2 0/5] mm: khugepaged cleanups and mTHP prerequisites
Date: Wed, 25 Feb 2026 18:29:24 -0700
Message-ID: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 16u1ekqDQT9ma2St44LCkfgck5X3KO9jBPHBrmUnD7c_1772069421
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 3671FA0011
X-Rspamd-Server: rspam02
X-Stat-Signature: 5s3fzgdmn66r5411ju4hyby1gt7h6gze
X-HE-Tag: 1772069432-699739
X-HE-Meta: U2FsdGVkX19EogOYHEoNwsJYPHe41yhVMYbgHRnMqC3KHmC06u3gGVsJk+flQXvwz9SN0PLuSWKFZdEKEwkR3+FvITx6GSuISVMR2p+5zV+0nbQ3bdqjdXDQBUNjMG9212LFaqpAm+Ldf7EAY6Jhs2UoBTd45eJbgmtyIkNs2tCwzK2M92aXR1fpOhypiX2wPsIrDU8ajUoPCX1VFJv53RfGTyDB+8kRGZOZIyo5QqLqQe9HxbhzyqCraotLzf93GRF6jia6+fUt7OnqR/aCiLXdSj8ZY1TzMf+1K6ctySkvaP/rwSCrRBEXluEGtWkhHCGd423mVMqOUgk14nnxIeMLL248G+OwVFVazJ7MHMVow/EOjq+KtJ6UqwA7jdPqyhB+IFH4qw2ZNNqRIBDpNcQuN1UsyrgyENRcCnWaZmdbzU0vR7kgdbJSUoYc6C76/g8fYEY8ouL6+6+mA3vB+2Q2TH0MoTvSGmw/ghehGxMlzTsc1mWxHJrgoW7sGPAbfq85+R0G1R+1d8wVdhU0P1mamX2Jd7aSlUNERJxcyhsJvBBOUYfGlWtBWot7dvgphiFK6I1+hRIlnizweNAuIbkn0g+ObIjrEaQ7O7oprckZbx4gfB5ieQsTdcwPa5Hsy2VRKYpXluL8wI6KRa8RGmJ5H3ql8i6MaViAfg2Xi4mHRmC1VK08LumuEGwSkyIDgYgk+zys3m0Q8coCLhUPjoNSCqYyHwNgY8tFGsmhnoikP9vginJHM3lHThpEUx8dF/gbLexn5JE71lzrZTqao/fvwunCwohCsSDN+ugopXWFa/rLvIcWTgxiefUrqZmedtJuZ0ShDZLZv48MNX161FcUOkKzz4nsX3QXw0WcUacXkVWJuEahy46iLxQndqi9fcMXhR+yWu7WJIL70xcnkGo0Hx+sOBMoEw132j0gOoWNaLLSnDUv9ObMKb2Mf9c2tVL1SrKuMBZ88RssbGQ
 eLsxuau+
 /iBcklEss9p+5N8xQY07zu9Oi09IYcHycs9qUlQQ8Mq6Lub5/AzfgF1UX2fnqMhcGA+8RtnsmukYk4fQJ5ithhbUhdC6AfJjNlVT70BwqUipwfA/o84Am81JrOLNAm6cJDJncR+i+mBG0XQOf3w5S+8lffWtRtS+QNyJF2ThRktilYHmEhi1VfJ7LdAcLziBSxhUY8Y/huqfX8rosgjUKKe6beovGmvf2IW6In4G6ymtJ8EwD3AqXjwVUIzNNLRqBEc4KoxHgFiMW3dL0ql/0UUCJQxIm2MtFTNh5bVSMx4y94VJ+IdJcvOaW/LtIhL4gcoIf+oVeYQ3bj13sui7pK8U+NLw3vPs5kBsZsoU5Y7+2aUg9n3F0c3twqiug44A7sD2GkHMv7nXvMiflsLIwvYYQi+qnXOVB5XglQesUKBUTOtcGLg6anT52BC9fw4jguX8XNPp6xaKusPk=
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

V2 Changes:
- patch1: add missing pte_sw_mkyoung [2]
- patch1: the switch to maybe_mkwrite introduced a functional change
  causing pte_mkdirty to no longer run conditionally. switch back to the
  original call format [2]
- patch1: fix minor formatting issues [3]
- patch2: found/added more open-coded is_pmd_order() checks
- patch3: only use the define for cases referring to the khugepaged
  limits. [4]
- patch5: Move the last bits of the new writeback retry logic into
  collapse_single_pmd. My previous version had this logic split across
  madvise_collapse and collapse_single_pmd. [5](Thanks David!)
- did not add review/ack's on patch 1 or 5 due to the above changes.

V1 - https://lore.kernel.org/lkml/20260212021835.17755-1-npache@redhat.com/

A big thanks to everyone that has reviewed, tested, and participated in
the development process.

[1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com/
[2] - https://lore.kernel.org/lkml/CAA1CXcC7SPkehNLT8FUnnUf6m0vm3GbhZuDZyMMW4X0DHDs6Mg@mail.gmail.com/
[3] - https://lore.kernel.org/lkml/20260212155539.2083102-1-joshua.hahnjy@gmail.com/
[4] - https://lore.kernel.org/lkml/493d7898-c959-42ee-ad09-35ffc631ec21@kernel.org/
[5] - https://lore.kernel.org/lkml/92e9d637-988a-4201-8c8b-c29987b727bb@kernel.org/

Nico Pache (5):
  mm: consolidate anonymous folio PTE mapping into helpers
  mm: introduce is_pmd_order helper
  mm/khugepaged: define COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
  mm/khugepaged: rename hpage_collapse_* to collapse_*
  mm/khugepaged: unify khugepaged and madv_collapse with
    collapse_single_pmd()

 include/linux/huge_mm.h |   5 +
 include/linux/mm.h      |   4 +
 mm/huge_memory.c        |   2 +-
 mm/khugepaged.c         | 206 +++++++++++++++++++++-------------------
 mm/memory.c             |  61 ++++++++----
 mm/mempolicy.c          |   2 +-
 mm/mremap.c             |   2 +-
 mm/page_alloc.c         |   4 +-
 mm/shmem.c              |   3 +-
 9 files changed, 163 insertions(+), 126 deletions(-)

-- 
2.53.0


