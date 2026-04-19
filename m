Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB279EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176F06B034E; Sun, 19 Apr 2026 15:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150296B0350; Sun, 19 Apr 2026 15:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B2F6B034E; Sun, 19 Apr 2026 15:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB63B6B034E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:02:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD5FD1B8A09
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:02:29 +0000 (UTC)
X-FDA: 84676226418.04.7FD5EF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF25BC0009
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:02:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GcCavZwW;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbaolfbnRxGZaI+LbysHzTSE/a3XUQ1Jm7g+xQscRIs=;
	b=FVKZ/QYNC+j9CkQL4EA1vjFrJLRC6N8FIDLMydd5yBA4tsD+fJcZNThDO8BOdtZel4hFjy
	JnJpfN1OKqk4U9oBVQ5qgLzAzJLmP4+Oi73fn1EHQp1PDSuzptYK4huuZ0Pe/8OjsdzhIG
	0/vDbmyBCK5TDgnZ/mM80J4+5W1aIQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625347; a=rsa-sha256;
	cv=none;
	b=J1iozkn41XBWIWjcCWW52p/ajnucnuPwyPWdpOzVjDtcU4TTMFBeDei1pLjiQ1Sucmsxxe
	TlrMA1IwfpoUH9LqnXaannaGnxorKOczd+NpkPbqIgQVfFzp80WB060inc45OJmJ7oDgM+
	ex/sTb+45Zfm72XBlgVLI0W4Tf4dp54=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GcCavZwW;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WbaolfbnRxGZaI+LbysHzTSE/a3XUQ1Jm7g+xQscRIs=;
	b=GcCavZwWuaixIlffAETiFsRwJng4lUvy55zvARHG2bg1wZS+B4flWRlwAVJNdghzJNvLV6
	sworiXtp7UVM8Tu6sOnhfEzoTvkmAKpmtwOq/jdj8V03mYmNk7z8DtXnBr4oY9zly9D6uj
	DSW846C0Oxy54mGZ6oLsLJf+niNjUS0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-UGMnA-zLMWSLuwTxBNSd0w-1; Sun,
 19 Apr 2026 15:02:23 -0400
X-MC-Unique: UGMnA-zLMWSLuwTxBNSd0w-1
X-Mimecast-MFC-AGG-ID: UGMnA-zLMWSLuwTxBNSd0w_1776625338
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D016B19560A2;
	Sun, 19 Apr 2026 19:02:17 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5E2CC195608E;
	Sun, 19 Apr 2026 19:02:02 +0000 (UTC)
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
	zokeefe@google.com,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 7.2 v16 13/13] Documentation: mm: update the admin guide for mTHP collapse
Date: Sun, 19 Apr 2026 12:57:50 -0600
Message-ID: <20260419185750.260784-14-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDDgfzOwdwnSPqbml-9mG-cgJ7OQquZrOpIWrNNY11Y_1776625338
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: fnrek6nfoitdxy4pnjary3nytit97ngr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF25BC0009
X-Rspam-User: 
X-HE-Tag: 1776625347-425868
X-HE-Meta: U2FsdGVkX18mlKH5IsIAZBX5mgW++dVPBfh6hOcNp5M4dp/TnKi0lNGLKcXUb7d3IgPE1+D0ztn3Jzhu6JTJ+8uYhoi+CyZPTQEOm7VqJ4tkm1a2K6awJgnC1QpKrLT92WzGnHs4KYyGvjN9I/V/G8BB5vyOvCykcWoBCmLx9+goalsyPw9uVQu/rVeutz/RSGO2CicYmSJL/ykBjmO31euRjJcebrynxurTg3IgxyVxDZ2XgI8ph16b0HhK7plD36Q0VFD2IZTeGBnpZim4j3wmJsQPzMLD5MFLIxdR6XS1VfM9OOkMWLvDS2qlRKlE8yczFdPp1nV9TdSx6keqYBpw7gnpn73gponDr2SzbA5tUHpB1+3Ux7e26ZXoZR5bKcwkemD9n0MwmvrjlFEtWyvPv8O5dK/tCR6Z8QK3+2Nc4uXNPPXv9CD0kgMrLPzeLtPHGk/cj5XcLgtqzcCuH53ld2jlzW5L18ZJoFeXFsAshGo7sZ54KRDYry+JcqohTxNTIKoBhLKGIPgRRvJD4iM5rtoVIFrLw659+qYLhoC1UNGIxzS1rH5yR99L1bup82Lnk4RGCPFnXviswpYqXjgy7Ci2XfYkVoOTDdWnPAVjZNbsgPDA8AH7ezdSHVDkUyZRz9WKyVQB8kC0WH0XJM3qRPtexV7gCvgzSkFzMvZ/qdHa/4NxjSkpfA7AZv1fT/ITVuEvUpyuho3xrYmz8yFFhuE2vRYDY4uWMnAbaCRTtF6s5Q7ZkCCVQ6GEPIlM4FPLgcmORHu46r3L60rGlx5yZ/j9A7UIGC3Q/zqblbg+/Kn1aXNLaIHxtEwrYtt4eJ60Hlr4UQcPid5uD27CK7qNVhPsj+wOSnVq9FssClvZyNY2u9V4PDsVYe1CF8DV8ZcMSAAbl0DG+G67cUE/iR4aCfQOB5Acxmcty6rag8Y+MmgQ9dDX7hFO89GrdmLXoDbPiJNPc617NsieYby
 5F5jI+6O
 lHwgZjVh1C2VBufxI8FmAW26MY49/c/r/C3Y/O5QceLyG4xm1H/R2EtOTvMKPDC3pfRiQeLIl1WMvQls7+q3OxWbKt/gKBgrzOmtAxOm2D17GpBKQuLvpRSYGHxQZfA5ZaZOjwxKzV29V1z5hh0tUoJW8kwK+xEf4agM8s4p1rXcgBOLomPhbnd1JLVOpAosl0Qc04mCLgO5UMxrOZKHTsp3YrkWf9e05M2O3BzCqU5YLjRcE1AKoTY7CKChftaI9S0a2zFNArh3vdKMowTKelJAKumvMf0QOR6Ha5jYUVf0kpuI0gUtwD56xxwSS7mpiPTlwa4LbJ/YpKLO3n9UIXVdcU21fyWG3TgRliQ7Wxd2MijiaT6BZDmFQ3/dpcNp5nfpZG5fBW5n478PrMFdKb6OwO3qNHmxq7ItBuWWLKwFfIg8V2bUsKFMbcy72nWiXAzeaf9VATyxMUD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we can collapse to mTHPs lets update the admin guide to
reflect these changes and provide proper guidance on how to utilize it.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 49 +++++++++++++---------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index eebb1f6bbc6c..0ef13c451ac8 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,8 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages of either PMD size
+or mTHP sizes, if the system is configured to do so.
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_underused, and enable it by writing
 	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
 	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
 
-khugepaged will be automatically started when PMD-sized THP is enabled
+khugepaged will be automatically started when any THP size is enabled
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
-PMD-sized THP is disabled (when both the per-size anon control and the
+all THP sizes are disabled (when both the per-size anon control and the
 top-level control are "never")
 
 process THP controls
@@ -264,11 +265,6 @@ support the following arguments::
 Khugepaged controls
 -------------------
 
-.. note::
-   khugepaged currently only searches for opportunities to collapse to
-   PMD-sized THP and no attempt is made to collapse to other THP
-   sizes.
-
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's
@@ -296,11 +292,11 @@ allocation failure to throttle the next allocation attempt::
 The khugepaged progress can be seen in the number of pages collapsed (note
 that this counter may not be an exact count of the number of pages
 collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
-being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
-one 2M hugepage. Each may happen independently, or together, depending on
-the type of memory and the failures that occur. As such, this value should
-be interpreted roughly as a sign of progress, and counters in /proc/vmstat
-consulted for more accurate accounting)::
+being replaced by a PMD mapping, or (2) physical pages replaced by one
+hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
+or together, depending on the type of memory and the failures that occur.
+As such, this value should be interpreted roughly as a sign of progress,
+and counters in /proc/vmstat consulted for more accurate accounting)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
@@ -308,16 +304,20 @@ for each pass::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
 
-``max_ptes_none`` specifies how many extra small pages (that are
-not already mapped) can be allocated when collapsing a group
-of small pages into one large page::
+``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
+when collapsing a group of small pages into one large page::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
 
-A higher value leads to use additional memory for programs.
-A lower value leads to gain less thp performance. Value of
-max_ptes_none can waste cpu time very little, you can
-ignore it.
+For PMD-sized THP collapse, this directly limits the number of empty pages
+allowed in the 2MB region.
+
+For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. Any other value
+will emit a warning and no mTHP collapse will be attempted.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +337,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
 A higher value may increase memory footprint for some workloads.
 
+.. note::
+   For mTHP collapse, khugepaged does not support collapsing regions that
+   contain shared or swapped out pages, as this could lead to continuous
+   promotion to higher orders. The collapse will fail if any shared or
+   swapped PTEs are encountered during the scan.
+
+   Currently, madvise_collapse only supports collapsing to PMD-sized THPs
+   and does not attempt mTHP collapses.
+
 Boot parameters
 ===============
 
-- 
2.53.0


