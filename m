Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE600CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C829D6B0098; Fri, 22 May 2026 11:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59DE6B00A0; Fri, 22 May 2026 11:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B704C6B00A1; Fri, 22 May 2026 11:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A64A26B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:00:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68941161A47
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:00 +0000 (UTC)
X-FDA: 84795365760.24.CF6604B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82C70180008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:59:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQT9GuRv;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779461998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cn0k/bwO5Qt8M+McWZ0EtdCuzV+0iQUlQzn/rjlgN8M=;
	b=GyalAL8hxiyQT8GomGiO6Mz6kB+Xu0ziOeWWsu3VzmhEWiXMq5hfFBZ0VybEWlUQPxHG1C
	M3q9YdrOKgHz+eDMCAYRdFV+mpv3nmOeoSJMeFAkkHGLRQcuyIjZhLDRkVmzWXH/7AozEv
	R+qZY0LvXorGuJoJ/zRRWp/2p2/NJNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQT9GuRv;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779461998; a=rsa-sha256;
	cv=none;
	b=twirIni9JuEYtzFYtB4dW3Y2S84vZAmt5Z86OV6KwFRH725nacaaVlZ0EioBcygajqrMxY
	UrCUOkwT7k4miQ4I6ohApsmbTWePFYHS5gOIBawhenUbWBtdacixs+cFu0pVmyTtx+20md
	VCn75z7WjnCjDjItSGP5CW11JpcqNhQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779461997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cn0k/bwO5Qt8M+McWZ0EtdCuzV+0iQUlQzn/rjlgN8M=;
	b=NQT9GuRvBQ+2W1qYJq4M/nJtQ88fcCG9FURFSdt6sBRAw1jE41RjxnmJzCEyWrmryDai8M
	1WI4AAv9gQxIoKDV35xJ4cIKE+mJp3i7KwmTnPnXawmpjEbbcV5ij81JlmYl2LXCgsDH9h
	Xo4Y7q6WZSv6cJIxq36tNiScRkPhaww=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-zG7KMpcWMzOPhMaJOjkOwg-1; Fri,
 22 May 2026 10:59:55 -0400
X-MC-Unique: zG7KMpcWMzOPhMaJOjkOwg-1
X-Mimecast-MFC-AGG-ID: zG7KMpcWMzOPhMaJOjkOwg_1779461990
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A77C18002D7;
	Fri, 22 May 2026 14:59:47 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 699FF180034E;
	Fri, 22 May 2026 14:59:24 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
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
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
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
Subject: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP collapse support
Date: Fri, 22 May 2026 08:59:55 -0600
Message-ID: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eZgXbPn3LYnRv5dR_YR1VW3x_lECZN6alvlqWcKIq98_1779461990
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 6yhwe8xiojd1rwqm6qgc3x48uf7wb6dq
X-Rspamd-Queue-Id: 82C70180008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779461998-9806
X-HE-Meta: U2FsdGVkX18KDmU6yOUNkKrmHhm+l42RbJ+GXmDe15SlGIkeDYt/RSZOosrwDGlLPgcd8q8lKuGUJBNByiljTrhY7ziq50LY0FwkBDy3Viz8yJDxW42AwOBeIc37YTtuHmi2Ja7wpKdmelx9mf2mJz/t2Nat/qO/WmsmdKz8pLzdiwKidlzkDhDNlVpALkkB8rcL9jBn4dLR0H7AvjUvDqKgG5G/Zm6fuwpXZKZkoVXWbbYDBTyleAdK7ka/JhkSZ3OI6Cj5qv1rh/xZPxbWd6idUsslbdyjzDjOGxIAjJsAWYlNi3rfii9N4HfFqWumrSNFhl+1Fz4lZ9PCjJvrhqpyc4iywXSm6//Xqo5xoIGv38xdmFAq7ydYiBEnUxGcibtkTnakmoVmGPs8bvT62VovfkpDFiyO3YKA7iW8mFUMrMWzqsidwkbbNk9R+n6HePeeIMl6QwfrIadRGnn780O88FmHecYFQfUEWkbiMpcfP5vLFuXV0tKBiG4YrQEfZBimjiUMmP/7G6tEpAQqtoHMCZISa2ooNV1PPDjoMg9A5bkSKpXeqaIysOCDH9Rn9xw7FGJ9vO5uI1YkyX3QuqnSh7Y569igUNntEHFXD+pIxZVy6OFzUYmJaLPxj/q3k2GNbN/SJTrNPpDm9m+lvGGugWkpoFjJ+DCy26QBqBIOhOcvHi5GfhFGO707yT3u0Duij3lHqzXvtp5H5ixPyvIVQUpcrP98I0tIZ8oUDQOXeO7xptqYj+74GdKp24GyHuB6L/tOWdTL+6vqw5535TRLCQGE28f34H0lrpGGCaaX7O97L3km0pa/70e040U72uWJMJTPcAtkKw4LnfAXVvCjyOt33f4AmOk3XTJkddGVpuLmV4p3boRsnnHm2Nj7xjWqld5Hp3IYIWEX8cAYh3LKAjEZdkw/gvtCwQDXKeX+u64Re6DTLuXXMoD2kBsoDMRfBL+dsGCzVVrOSVY
 83vf44Qa
 LrW+1c4aMSPI3rLrdXxD1DOvya9k+1+UwqI66FiglVF0Cay2e9cxCfK9B3oI8MLCd1bczbSxKlH8DsrFMXKz1eUEV6G/CIZIzeFBR/ZkBYhJE6G7V62vhdgN/PhbZza43UVaAmjGGQycsV9KqvHkEchTCRgC7JAOwr36c8DpslBNRmhukkmBKQulT6HRy4Z8mGse9SoWBsVlm8Hf7YRIO+5AYPmYqL+MR8ZppHoH001EQUXkSne5l+HLgKgJHaYJe53l4Qp+5KdbXwU/oGky7Jk00iT5WYR4sRXY1vVm9nLBW18RKSmxOkzjLrdXGEPAg5szw7711kqmklu3rPMSbTNN1kA2HNdkBD8wBd4/KYdGum6zs8fGsW9TP0KFMaKOJW3ItLtp+tX7ch0YZvJpQgRKIh9iH1zCYk4PdFtZdNhniR97Jj7CdjRvgp0oo3m8XIhyNysZLug7RRJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following series provides khugepaged with the capability to collapse
anonymous memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
pages that are occupied (!none/zero). After the PMD scan is done, we use
the bitmap to find the optimal mTHP sizes for the PMD range. The
restriction on max_ptes_none is removed during the scan, to make sure we
account for the whole PMD range in the bitmap. When no mTHP size is
enabled, the legacy behavior of khugepaged is maintained.

We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
(ie 511). If any other value is specified, the kernel will emit a warning
and mTHP collapse will default to max_ptes_none=0. If a mTHP collapse is
attempted, but contains swapped out, or shared pages, we don't perform
the collapse.
It is now also possible to collapse to mTHPs without requiring the PMD THP
size to be enabled. These limitations are to prevent collapse "creep"
behavior. This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
             for arbitrary orders.
Patch 3:     Rework max_ptes_* handling into helper functions
Patch 4:     Generalize __collapse_huge_page_* for mTHP support
Patch 5:     Require collapse_huge_page to enter/exit with the lock dropped
Patch 6:     Generalize collapse_huge_page for mTHP collapse
Patch 7:     Skip collapsing mTHP to smaller orders
Patch 8-9:   Add per-order mTHP statistics and tracepoints
Patch 10:    Introduce collapse_allowable_orders helper function
Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
Patch 14:    Documentation

Testing:
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- internal testing suites: functional testing and performance testing
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[1] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I did some testing with these changes along with my defer
  changes (see followup [2] post for more details). We've decided to get
  the mTHP changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

V18 Changes:
- Added RBs/Acks
- [patch 02] Guard count_memcg_folio_events with is_pmd_order() to keep
  THP_COLLAPSE_ALLOC PMD-only (Usama, Lance)
- [patch 03] Convert C++ comments to C-style; fix "none-page" terminology
  to "empty PTEs or PTEs mapping the shared zeropage"; drop unnecessary
  userfaultfd comment; add const to local max_ptes_* variables; fix
  "repect" typo (Lance, David)
- [patch 04] collapse_max_ptes_none() now returns 0 instead of -EINVAL for
  unsupported values; remove SCAN_INVALID_PTES_NONE; change return type
  from int to unsigned int and propagate to all callers; add comment above
  __collapse_huge_page_swapin explaining mTHP swap bail-out (David,
  Lorenzo, Lance, Wei Yang, Usama)
- [patch 05] Rewrite collapse_huge_page lock comment to David's suggested
  wording (David)
- [patch 11] Propagate unsigned int return type for max_ptes_none; remove
  the now-unnecessary negative return check (consequence of patch 04);
  Add optimization to the next_order goto that will prevent unnecessary
  iterations if there are no lower orders enabled (Vernon); update locking
  comment; pass VMA to mthp_collapse to improve uffd-armed detection, and
  prevent unnecessary work. (Wei)
- [patch 14] Update documentation to reflect fallback-to-0 behavior

V17: https://lore.kernel.org/all/20260511185817.686831-1-npache@redhat.com
V16: https://lore.kernel.org/all/20260419185750.260784-1-npache@redhat.com
V15: https://lore.kernel.org/all/20260226031741.230674-1-npache@redhat.com
V14: https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com
V13: https://lore.kernel.org/all/20251201174627.23295-1-npache@redhat.com
V12: https://lore.kernel.org/all/20251022183717.70829-1-npache@redhat.com
V11: https://lore.kernel.org/all/20250912032810.197475-1-npache@redhat.com
V10: https://lore.kernel.org/all/20250819134205.622806-1-npache@redhat.com
V9 : https://lore.kernel.org/all/20250714003207.113275-1-npache@redhat.com
V8 : https://lore.kernel.org/all/20250702055742.102808-1-npache@redhat.com
V7 : https://lore.kernel.org/all/20250515032226.128900-1-npache@redhat.com
V6 : https://lore.kernel.org/all/20250515030312.125567-1-npache@redhat.com
V5 : https://lore.kernel.org/all/20250428181218.85925-1-npache@redhat.com
V4 : https://lore.kernel.org/all/20250417000238.74567-1-npache@redhat.com
V3 : https://lore.kernel.org/all/20250414220557.35388-1-npache@redhat.com
V2 : https://lore.kernel.org/all/20250211003028.213461-1-npache@redhat.com
V1 : https://lore.kernel.org/all/20250108233128.14484-1-npache@redhat.com

Baolin Wang (1):
  mm/khugepaged: run khugepaged for all orders

Dev Jain (1):
  mm/khugepaged: generalize alloc_charge_folio()

Nico Pache (12):
  mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
  mm/khugepaged: rework max_ptes_* handling with helper functions
  mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
  mm/khugepaged: require collapse_huge_page to enter/exit with the lock
    dropped
  mm/khugepaged: generalize collapse_huge_page for mTHP collapse
  mm/khugepaged: skip collapsing mTHP to smaller orders
  mm/khugepaged: add per-order mTHP collapse failure statistics
  mm/khugepaged: improve tracepoints for mTHP orders
  mm/khugepaged: introduce collapse_allowable_orders helper function
  mm/khugepaged: Introduce mTHP collapse support
  mm/khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  72 ++-
 include/linux/huge_mm.h                    |   5 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 634 ++++++++++++++++-----
 5 files changed, 584 insertions(+), 172 deletions(-)


base-commit: 6c8cb505a5634594b3ea159fd1c71bce2acf3346
-- 
2.54.0


