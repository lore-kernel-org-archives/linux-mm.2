Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E8CFD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDC46B0088; Wed, 25 Feb 2026 22:18:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BD46B0089; Wed, 25 Feb 2026 22:18:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52876B008A; Wed, 25 Feb 2026 22:18:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0E586B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:18:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36D321CA82
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:18:20 +0000 (UTC)
X-FDA: 84485149560.23.5EE3ACB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BF8020014
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:18:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BZL4s/CU";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AdHHTY7CyDceWfPWsB5CSfrTBfVDaC7fAfLMxgiRZ/0=;
	b=yQBSuR/K4mD9W2kCVg53jyVSDAEE/FlX/I2lgtG4e2xi+H7zxsE//J9Jag0jghGUnNa0w6
	X2UQzXNu9DBrMPct0hRhCoUwCjgbEROtnoTg2EaYH89jq3IZ1dkG5q54dDfe97yveWux5u
	CPPTOFqlhCLX+SMkJ3Ur2vQJu1Sefes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772075898; a=rsa-sha256;
	cv=none;
	b=OLSfbORDiRF84MuhoqKDkbpuYvO0grtICC9lEUcDb4qKEr2ILX+cogJElv56Yu2qOxBaR1
	nYEPWZfx9YHePzTYWTWiRV+AIju4SWqD2XFUJEHyhG4RKZzV1ztcHT/Keq9xvQfFlbGZdG
	MwxJpXWMg7iCWvW/xXfDRW/G+KMBA8o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BZL4s/CU";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772075897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AdHHTY7CyDceWfPWsB5CSfrTBfVDaC7fAfLMxgiRZ/0=;
	b=BZL4s/CU7vbAUNoXQkm4f8G1jSY9N3ciBWICv1BIW0IJRi8xdE7RFKrMk2oOXoDD88o+zH
	NHx9hxNhfFMMJYXFJnkGlpk4r+fX9JChvBx8TmRYYkwN+aswisgh+XyzTDNZrKKxjuak27
	uS5ujEmnUu/uAB/DZ3pizotyBz5i0fo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-95ASqQjJNQa-QM7HwsZbzA-1; Wed,
 25 Feb 2026 22:18:14 -0500
X-MC-Unique: 95ASqQjJNQa-QM7HwsZbzA-1
X-Mimecast-MFC-AGG-ID: 95ASqQjJNQa-QM7HwsZbzA_1772075890
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BB9E18004A9;
	Thu, 26 Feb 2026 03:18:07 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04A4F19560B6;
	Thu, 26 Feb 2026 03:17:53 +0000 (UTC)
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
Subject: [PATCH mm-unstable v15 00/13] khugepaged: mTHP support
Date: Wed, 25 Feb 2026 20:17:28 -0700
Message-ID: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6_BJdH8SCUZehuiJpI64prCwWNfvW6OMwvs72xGLEyg_1772075890
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: shr851tf5zyrcm81o5do1pjkwhxftt7e
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1BF8020014
X-HE-Tag: 1772075897-793073
X-HE-Meta: U2FsdGVkX18eCUek8p7ka5viB/wOCmlGl2M1mUECjASjHM/+ccmniOSTKm/jxwtMghqJtAjjV7Fl4qqCHyLmD5HZn7N/zYXy2TNSYEPo0uxpplH/kLUv/3ECrKqLdWcId0nDmZgBRFA8By1MViBG5L1Vc6jRoNzBHtdynLCfT0CBCwUDKGqJtHvwWms4r1hhv0GfjotKRChD6UmKzOMwRWyiUA0Ux67topogpXauqs+tD1EyfqELlctAdfj+mDacaRug60M9Ww5pN5fynCo2bfxA+kfv0z2Ndm4ESHuGJ2NxxG5yIdFIYlsr2TFJkdc/OhljD/T2AZru/tE7YuoyMQOiCJ6QqM023fvI2aJDuYFFgmCWBm+Nz0XW8nSVZ0HcAAIf5Grji2KU6kod/uPBpZm+UBEDQlw4nDmQlc4Rui4l6X3Jp5VBfqNsyU/3uVY6AsNuSDa/vuycI9P0Ps+FmgD1CDgk9Auat/MdLB4v1Q+dRKqHNfnYlHeRDYTmhyLKKE0eRSewQlJGrzMprm9YI+G+xFj8iCUse7pRIm5bBZy5h22aw33okzoWlDDThNQxVKPoCaBEN23iPsMFc/Eii217JGOrO3Hdjmvf8+vwEr7+52ZLuWIh1VMGJ3JevdPeixZWMoQhSGsvVRjSfldaJ/e4Pjq6ajWHo7OD4wg2fdy5qEc1526/pPLpMnXHTYtltkL3Gjkw6B1JmZqpYxGmWbLiymbwZHYI0Gkono2qA0HM0sy6DLUbZTzdxFUCMYlUyEan2rgd5O7L0xPZDNBLiEdwnM1XzFU7uYbsKPmWojSKegQw+9/0i/H/7AvhQYxkLsxI5gm8AJfuJwQ+S2/+U5NpVKXAB5YuupFYRAd7atTZpUqNmPOs9HVqt7w6oSJp8PitE5N7vyyp/7tGtqFUK7eNALmyyR/hWw5ALVfmJscPDvRpwz0LTC/R6ddqKkHLffo2zaeEIBaFeufsFzj
 chh+3pt7
 9VXUZMdxSb9vGrwuG8yrU0X3T5CJ3NV8t/qsKBJnxt7lGNp6HdNXNfxKxBcjZvL9XoKdHtdIEX27zyBF2A3J7RhDf8uhUBIW7b1uHP4OrVR3OY6uC0TWiNGaBdBQc2Nyv+CQhgzvX067jC9NcKwbPOuBrjnt51+kNe6aIWlnNy2SIUp2BXfj6hWb627iGETNlHQrHgVyagnFTjwj/8yqU0TAlQ+NR+lykX5rg9aciVDtX7oX7LdRLMoFduI74xnFKqKZzev39hBIDapLdbtbtxxPHygEcdnfcW7DCaZkvGaV1RGWvUzT5Awm2rpfhGTSOLGy0HSP1GQHQblTkireyzSEhl/4tyXqFlUsq0G0lr3qsT/hvdX4nkFI9KUhenh20KSVMRyvohWWPB6+2TMdAQj9PDcXvR6V1+96lqlws41UKQJYPULi8Vj+iNnkEp8BljAZdO6iQJB32080=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series depends on [1], which provides some cleanup and prereqs.
Some of those patches used to belong to the V14 of this series.

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

Patch 1-5:   Generalize khugepaged functions for arbitrary orders and
             introduce some helper functions
Patch 6:     Skip collapsing mTHP to smaller orders
Patch 7-8:   Add per-order mTHP statistics and tracepoints
Patch 9:     Introduce collapse_allowable_orders
Patch 10-12: Introduce bitmap and mTHP collapse support, fully enabled
Patch 13:    Documentation

Testing:
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- internal testing suites: functional testing and performance testing
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[2] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I did some testing with these changes along with my defer
  changes (see followup [4] post for more details). We've decided to get
  the mTHP changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.

V15 changes:
- Split the series into two [1] to ease review, and keep this series
  fully khugepaged related (David, Lorenzo)
- Refactored collapse_max_ptes_none to remove the full_scan boolean arg
  moving the logic to the caller (Lorenzo)
- added /*bool=*/ comments to ambiguous function arguments (Lorenzo)
- A few changes that were requested in v14 were done in [1], such as
  introducing map_anon_folio_pte_(no)pf, defining the
  COLLAPSE_MAX_PTES_LIMIT macro, and the fixup of the writeback retry
  logic. These changes were noted in the v1 of the cleanup series [1].
  Some of these requested changes are leveraged in this series
  (is_pmd_order, DEFINE usage, and map_anon_folio_pte_(no)pf).

V14: https://lore.kernel.org/lkml/20260122192841.128719-1-npache@redhat.com/
V13: https://lore.kernel.org/lkml/20251201174627.23295-1-npache@redhat.com/
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

[1] - https://lore.kernel.org/lkml/20260226012929.169479-1-npache@redhat.com/
[2] - https://gitlab.com/npache/khugepaged_mthp_test
[3] - https://lore.kernel.org/lkml/20260212021835.17755-1-npache@redhat.com/
[4] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/

Baolin Wang (1):
  mm/khugepaged: run khugepaged for all orders

Dev Jain (1):
  mm/khugepaged: generalize alloc_charge_folio()

Nico Pache (11):
  mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
  mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
  mm/khugepaged: introduce collapse_max_ptes_none helper function
  mm/khugepaged: generalize collapse_huge_page for mTHP collapse
  mm/khugepaged: skip collapsing mTHP to smaller orders
  mm/khugepaged: add per-order mTHP collapse failure statistics
  mm/khugepaged: improve tracepoints for mTHP orders
  mm/khugepaged: introduce collapse_allowable_orders helper function
  mm/khugepaged: Introduce mTHP collapse support
  mm/khugepaged: avoid unnecessary mTHP collapse attempts
  Documentation: mm: update the admin guide for mTHP collapse

 Documentation/admin-guide/mm/transhuge.rst |  80 +++-
 include/linux/huge_mm.h                    |   5 +
 include/trace/events/huge_memory.h         |  34 +-
 mm/huge_memory.c                           |  11 +
 mm/khugepaged.c                            | 519 +++++++++++++++++----
 5 files changed, 522 insertions(+), 127 deletions(-)

-- 
2.53.0


