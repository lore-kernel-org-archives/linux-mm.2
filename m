Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D827103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6766B0005; Wed, 25 Mar 2026 07:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9571B6B0098; Wed, 25 Mar 2026 07:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846156B0099; Wed, 25 Mar 2026 07:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 724006B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:41:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 461D116088D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:07 +0000 (UTC)
X-FDA: 84584394174.15.B74E741
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 429581C0004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EWd9Q70X;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EWd9Q70X;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438865; a=rsa-sha256;
	cv=none;
	b=Cg8NgFLiF3U8TN4gUSk2lo40/C8BtVvijUm4iM5yapRrWyfqbtB9H1/hFTG/DnvSz4UBFv
	69FHN4sjLqWTi+UaP2BDfazQoWNGliXeKF8QOTR89Nyt12yS/6efUndOJVvL3H9VNeS45N
	f6jKwbQ7mwf/E0jbLdbzFTqORLwZ/Jo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kzcgqLyjOg++pZ/FvEDyW08QVmt9FqdUpi4H5GvDw9s=;
	b=BFeoQjt8wHPp2ONicTWfJnBW0dev6r7mHWKTIHhKhSLQXYMPV65CdCxtPSLri9nmPEgG4w
	r059Wnw50RBaeG+T2KyH3a3uXro9AhKnvAmS4MR9B47JRlmYl/yZ++tSXUBhB6PDuXX2JG
	GiOqdRdjmeEE2D/l6nEUd1wvwCSt6Xo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kzcgqLyjOg++pZ/FvEDyW08QVmt9FqdUpi4H5GvDw9s=;
	b=EWd9Q70XyWbYCP62DkSWysI0qMee0kshn72BpKAfo4ijiYWyUiJbbgSFy7dI4qV5OjOkLF
	lq23RFfAfY8Ipi1bIujXu6efdlToqdmDTZO6Vg6/46jyTdSTSKWzUN70e/rqH18KZaamC4
	+6rSQxBS8Go4+0OOMeCrnv7QmQBZ4Fg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-LM9yc_BaNmq8bdpLdgQviQ-1; Wed,
 25 Mar 2026 07:41:00 -0400
X-MC-Unique: LM9yc_BaNmq8bdpLdgQviQ-1
X-Mimecast-MFC-AGG-ID: LM9yc_BaNmq8bdpLdgQviQ_1774438855
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06D5819560BB;
	Wed, 25 Mar 2026 11:40:53 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD3F01800576;
	Wed, 25 Mar 2026 11:40:30 +0000 (UTC)
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
Subject: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP prerequisites
Date: Wed, 25 Mar 2026 05:40:17 -0600
Message-ID: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sHqlhBh4R2qwq3z7icWgfxeCb7YLQud0abIbbcDgyTE_1774438855
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 429581C0004
X-Stat-Signature: c83r5bmp5gcocoeo4hbrpk8daneux7qh
X-Rspam-User: 
X-HE-Tag: 1774438865-208693
X-HE-Meta: U2FsdGVkX19jkvhVY7K+WwzsQ6An9kJA8I0uTnbBEKGJ/apPvF7W0iarw6yUufVqVBudl47Zh76uW5ZbVuu+D6OTFngPH1JI1lFZvEAp7UBGazjm59WrAF5vg6j0CYyGPNthbfgjTfCald2O/5mSDri3uSY58PaoGA5oVsGlL8d0MfdcXFgqybjNNJ6tvWOJJ2LYvjX7rPjnm+oNekBHdVII4Joe0stXMhh4pNklqFn+WzihpaOx7ePIcsBb50HcQyOtFaikHkHk+A98K21CUzokkF1S/97lFuvXbAuvpB5q9EdUdvDVFeUF9ePuWdyZk9XeoSnP9Yo4wBTeYIbvHZHvsEu6FamsEg+bY+G4oatOwNk8q0IkPqbKQYXO5lm+IGWUbTfgbOkazzm0rHwoDnDe7HD63fFc6n7s7gnURS+Qq3HfBNc7LvMqrujSVJMApaE0QiH8BR+6WVP9trkjZUDB4ww5FQV5pUP0Xe42i2XXUsNE+5upUJM2hRPhlsOw6VM3OEZksaxckLCGoezDs13z3beJ3fDFTbL49qo/iyHBKLXRDOtjSuP9HKQ6Mo6k5JBA8unJSxM3fCOre5Ri7UbTD2IUCAXYQrfBOtzYKiWtUT7JwOb46IZgXCei8YTBaJo9dpSV5FkCVlFrcDdfHaxdUm0JUT3N2hTMFIW072aXyMfjMmK4SirLiN5NRomZINMzMDdtX09c1K8P99LFOqKIxQcmSD/b8zbLmINADnY1yQoiBkRsbQ/KSPd+1OqCaxNYj/SOXjOf8uglt55Xjtt8y08p/sPHVk9bBOVG4rv1fwxspn7/SkNGm/Vd4/4klpPEflSDpDxetm3Jaf7Hne5/t7o2loL2QqVJWCpn7EOgEeX2XcpfShYZ9fFB/Mh1reBgyRI/FJPWPPzyBsoXwITnBMaSva3Joaijj8ix/qyOu8Vk/eoAYfiSoitMYp1f7CaXkSupN1Jlh8VE3sz
 dyxaxvoT
 zn4dkendFoKETrNpYlqzoPLRcNiO9LaAb5I/suutayzZMe/2LNLoxYGnEc8c3oskeevPm1jzJHlORK2aoYOPV3enKlsQDa4uGmLEi/LOFNpknhemdrT29pJ7kzedRtFjuYW0hER8NfogSaOYjS1bNAR/4wj0bR+wxFcT1LVAEcQfGOdOWFdnZknQLabWIva+gLoRKXESau4xDtmvNDCM3ZHH6+NNdDVHD6NjuQRPwoa8aftx2mXjCA/wQgbOpEtt1GoYIMub0E+w0zLQ3d8kt21a0ScQYphH/BKYTmNifBIMvW0LUfFd+Tg396k/StIhoh6qfyWxfVsoJLczGGQKAR2xB/s7vzePWiJg75sNmpheyXhuN4u25dqpd6oi5EwfYrn7f+aJ+8kNluw/njA2Ar6GVivD9Fh8/gLlo6N4qtMxwilu3d60oZ3wXrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MAINTAINER NOTE: This is based on mm-unstable with the coresponding
patches reverted then reapplied.

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

V4 Changes:
 - added RB and SB tags
 - Patch1: commit message cleanup/additions
 - Patch1: constify two variables, and change 1<<order to 1L<<..
 - Patch1: change zero-page read path to use update_mmu_cache varient
 - Patch5: remove dead code switch statement (SCAN_PTE_MAPPED_HUGEPAGE)
 - Patch5: remove local mmap_locked from madvise_collapse()
 - Patch5: rename mmap_locked to lock_dropped in ..scan_mm_slot() and
   invert the logic. the madvise|khugepaged code now share the same 
   naming convention across both functions.
 - Patch5: add assertion to collapse_single_pmd() so both madvise_collapse
   and khugepaged assert the lock.
 - Patch5: Convert one of the VM_BUG_ON's to VM_WARN_ON

V3 - https://lore.kernel.org/all/20260311211315.450947-1-npache@redhat.com
V2 - https://lore.kernel.org/all/20260226012929.169479-1-npache@redhat.com
V1 - https://lore.kernel.org/all/20260212021835.17755-1-npache@redhat.com

A big thanks to everyone that has reviewed, tested, and participated in
the development process.

[1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com
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

 include/linux/huge_mm.h |   5 +
 include/linux/mm.h      |   4 +
 mm/huge_memory.c        |   2 +-
 mm/khugepaged.c         | 207 ++++++++++++++++++++--------------------
 mm/memory.c             |  63 ++++++++----
 mm/mempolicy.c          |   2 +-
 mm/mremap.c             |   2 +-
 mm/page_alloc.c         |   4 +-
 mm/shmem.c              |   3 +-
 9 files changed, 161 insertions(+), 131 deletions(-)

-- 
2.53.0


