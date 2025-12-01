Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B5DD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FF96B0030; Mon,  1 Dec 2025 12:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D10D6B0032; Mon,  1 Dec 2025 12:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF566B0062; Mon,  1 Dec 2025 12:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 668426B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:47:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DBF4C035B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:32 +0000 (UTC)
X-FDA: 84171634344.16.42FE3B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66592C0016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:47:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D+nack9i;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K7EblCrPHmPeGpU4jKxy0TCLMZyCEXvxixVXeFlcSRE=;
	b=tAnxwh9Hy/ZS/sjfK3ONvT8MGSDrg0+CR6OQ07WzRUIp+qpYffElLuwgamzouUbsoFw+az
	9btQ9mmiWPvP1IsLcJZN5XqTrvUMNyZHvN95LrK3KxL8sEghMwmKbZL/s+x1+IYBJn937J
	B5TyE3eC6NUgOqTj5pdxkUiVexTOI8E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D+nack9i;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611250; a=rsa-sha256;
	cv=none;
	b=LeTtYcLI6t4t15iRP+TbUckngYggQrI7p7O+pqmJznxHPO9gzM3OOflZv0tL50vvsaxdsY
	rmQ1VNWmrqpAJ/oo37LzDf/5y3HWMEP8TY+BAwES6BSY3SBDjb24218vFblqdY8ISwnKVN
	+PW8S1SJdNGS0lT4Rfg179sRE+5Qj+4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K7EblCrPHmPeGpU4jKxy0TCLMZyCEXvxixVXeFlcSRE=;
	b=D+nack9i5yk4SEE1lOkGdtX3cp2STMvDLxkG7Ko2LqCuMtUYXjGDxsKF/t+CHhjPMZ28DX
	YddSNeWShTxFFm5QMNbyRuT8ejm1AxzNBO8M1/x5lXQdBW1Stp4LgiA7zL8hBN4WxQLs6w
	DH9Tt69ZsjLdYk/BGMFEoI420WbxyQs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-p7dA_RP7MS2HhAqYrjA5-w-1; Mon,
 01 Dec 2025 12:47:28 -0500
X-MC-Unique: p7dA_RP7MS2HhAqYrjA5-w-1
X-Mimecast-MFC-AGG-ID: p7dA_RP7MS2HhAqYrjA5-w_1764611243
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E843018007F2;
	Mon,  1 Dec 2025 17:47:21 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9A251800361;
	Mon,  1 Dec 2025 17:47:09 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
Date: Mon,  1 Dec 2025 10:46:11 -0700
Message-ID: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Stat-Signature: sxwds4i4a8rupbc71oxe8pqdkqu9y3fu
X-Rspamd-Queue-Id: 66592C0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1764611250-86062
X-HE-Meta: U2FsdGVkX18/FRfGEspBP9AMh0dMOTtdVML+ypbhx2CdzrT73sg5EEkjSAI8HuzQ84tUOmaiyLO54Py2O9gOSDpMazC5NaA1u9XyQKct22a/BrFHlbZx5I+2//8c+ZN82wPv8FqrAs3jBd2R0efUQjZ08bMkdH1bRiTm4hNKxG4ZIY7n35opk5f7tenpCicVZJoyjzzFMIKG4IpI2a3DJ5WVviIaR/3Jk2VMcDVmEQBNrfu6nVgvM5jfWqT43MI4ATbdvh9GEcwtN+DehyqGu0aRwK8HXl2/afOHtnIYd3REMzF/sqC8gn+rlkNW47f0pom3rvthCxNUA8c+bsogZFCwhF6uCdep4ROBH/suQypiCfFvbHBvPxF3HDub4J6EPS+09ahW6MXTO4Lr0EsGMp2Z3k4njnT/lIbP8Qnqxq9MlOmnfJINhhb9+ibxrfX+Obu23AOlqbJuG4kWPJrv1NdNDm1LU5Bl45PBO5RwNrJmhfTf0ttNHtM/l6+MRjNf7hq3n8Dmq1RmIDkmIVvvSRLqHftOaEBYuWlMsisHuQtPcPwe3NxXCyYC55aQK9NEdRv74GlDof8GTYm9CaArpyIL9tenUswh3YZHuvTFwi9CFxqW9cD18lYMDdr4ZfxIyX0ev8yaV+xKSlMlCBITrGSEM5xTEmtCKzjFEKirbD94KPmJThaWHvIxO6UjChZsn4G5ZOmb7DhuybyYg9bPQs+awMo0wvIbcVUV9ddS/sUegiDBDtxUh6eXAd3BIh4XjfT4SwwiKtsxanp2Q/1wKUkafwzjWu6UxJAjeVM8raaS+MzuFmu2YjM2mVFLy13y1Gx5NarJb9fphMkxwe27bkWT1bDoIopPHaG3YrU+s7cOxrdqmHtG1Vjnhuzmh09t4OhmqrjINttPbjGNQFLPUuc86PSXuF4RiEuUFOXnYm+IYjpCGOdZUB+B00LkzkZs97Tna0ZUpKmQ2Um3v7P
 9Ki+sE2C
 FKlSMgH9Kxtt//erkN1XHlxZCL1PIpqLmNlZXIhRfUZBASUAeJCqnh7X/oGzHvNkue0o50R+3qsPmjwiK206VxQelqedJ/x3/DgCcGeBscefQvPPf5Ses+II9EAUVxK+Zi1BO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
but contains swapped out, or shared pages, we don't perform the collapse.
It is now also possible to collapse to mTHPs without requiring the PMD THP
size to be enabled. These limitiations are to prevent collapse "creep"
behavior. This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1:     Refactor/rename hpage_collapse
Patch 2:     Refactoring to combine madvise_collapse and khugepaged
Patch 3-8:   Generalize khugepaged functions for arbitrary orders and
	     introduce some helper functions
Patch 9:     skip collapsing mTHP to smaller orders
Patch 10-11: Add per-order mTHP statistics and tracepoints
Patch 12:    Introduce collapse_allowable_orders
Patch 13-15: Introduce bitmap and mTHP collapse support, fully enabled
Patch 16:    Documentation

---------
 Testing
---------
- Built for x86_64, aarch64, ppc64le, and s390x
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[1] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I tested these changes along with my defer changes
  (see followup [2] post for more details). We've decided to get the mTHP
  changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

V13 Changes:
- Lots of minor nits, cleanups, comments, and renames
- Bitmap function simplification and more helpers (Wei, Lorenzo)
- Max_ptes_none (0 or 511) restriction
- commit description expansion
- list all reachable enum values in mthp_collapse()
- Fix ppc64 compile error due to using HPAGE_PMD_ORDER (replace with
  ilog2(MAX_PTRS_PER_PTE))

V12: https://lore.kernel.org/lkml/20251022183717.70829-1-npache@redhat.com/
V11: https://lore.kernel.org/lkml/20250912032810.197475-1-npache@redhat.com/
V10: https://lore.kernel.org/lkml/20250819134205.622806-1-npache@redhat.com/
V9 : https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat.com/
V8 : https://lore.kernel.org/lkml/20250702055742.102808-1-npache@redhat.com/
V7 : https://lore.kernel.org/lkml/20250515032226.128900-1-npache@redhat.com/
V6 : https://lore.kernel.org/lkml/20250515030312.125567-1-npache@redhat.com/
V5 : https://lore.kernel.org/lkml/20250428181218.85925-1-npache@redhat.com/
V4 : https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.com/
V3 : https://lore.kernel.org/lkml/20250414220557.35388-1-npache@redhat.com/
V2 : https://lore.kernel.org/lkml/20250211003028.213461-1-npache@redhat.com/
V1 : https://lore.kernel.org/lkml/20250108233128.14484-1-npache@redhat.com/

A big thanks to everyone that has reviewed, tested, and participated in
the development process. Its been a great experience working with all of
you on this endeavour.

[1] - https://gitlab.com/npache/khugepaged_mthp_test
[2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

Baolin Wang (1):
  khugepaged: run khugepaged for all orders

Dev Jain (1):
  khugepaged: generalize alloc_charge_folio()

Nico Pache (14):
  khugepaged: rename hpage_collapse_* to collapse_*
  introduce collapse_single_pmd to unify khugepaged and madvise_collapse
  khugepaged: generalize hugepage_vma_revalidate for mTHP support
  khugepaged: introduce is_mthp_order helper
  khugepaged: generalize __collapse_huge_page_* for mTHP support
  khugepaged: introduce collapse_max_ptes_none helper function
  khugepaged: generalize collapse_huge_page for mTHP collapse
  khugepaged: skip collapsing mTHP to smaller orders
  khugepaged: add per-order mTHP collapse failure statistics
  khugepaged: improve tracepoints for mTHP orders
  khugepaged: introduce collapse_allowable_orders helper function
  khugepaged: Introduce mTHP collapse support
  khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  80 ++-
 include/linux/huge_mm.h                    |   5 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 696 +++++++++++++++------
 mm/mremap.c                                |   2 +-
 6 files changed, 618 insertions(+), 210 deletions(-)

-- 
2.51.1


