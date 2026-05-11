Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A52CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901AD6B00EE; Mon, 11 May 2026 15:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9AD6B00F1; Mon, 11 May 2026 15:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFEF6B00F2; Mon, 11 May 2026 15:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4AC6B00EE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:02:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 329B114028A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:57 +0000 (UTC)
X-FDA: 84756061194.18.FFFC625
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36D7018000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4NSkCoW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiYMb/Q8JH8Ku6Q4bq1jt2nAQ4D1SLX699iRvvNPHyw=;
	b=Ci9ubHJgmye8hCwDZBwfj3rRzD/DEg/479cTFV4XXzs7/FNior3GL+FhE+JAOKxa4of5W2
	KaGS7UUK36ZRAkiqRohOciSHFVJ24KftdyqjVhnC4EnrOx+R55g+T3tY70zxHOyq/bZU3P
	kYt+kxDDWVEeHnr27IVWfRHQ4K3smEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526175; a=rsa-sha256;
	cv=none;
	b=e6JFFxNlb/SBspfsA86HxbBcRe0XAUzzbxKNL0cO0OEocd6NIDxIdmvKaK0v3A7fxQ0RFg
	Po0hHi3V+H8t3W1XxNApdntqtB71fhmdfa7caaRIj+5Ez4hSv5YvzWWStADZbCg5MJ2bSR
	SiX6deHWXwa7TNxssfuzey+XdKnUSzw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4NSkCoW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GiYMb/Q8JH8Ku6Q4bq1jt2nAQ4D1SLX699iRvvNPHyw=;
	b=H4NSkCoWLANR5YDMhnrJI59TnaSJz3XoQa2NIJFM7nmuT+kWRY4S62NZWj8QGR5cK3dn+I
	E4l3ECSJm9jt4Qm5nyziJE80hHhmqKowqJl0B6vEkg9CASAB3j7G+lB3j4MsW8bJI5ytzd
	JxjgDLvQgpgdpzFBCr/DEfZKWmXcPzs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-zQUe3-3OM0WIeyTqEeMjlQ-1; Mon,
 11 May 2026 15:02:51 -0400
X-MC-Unique: zQUe3-3OM0WIeyTqEeMjlQ-1
X-Mimecast-MFC-AGG-ID: zQUe3-3OM0WIeyTqEeMjlQ_1778526166
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CF931956095;
	Mon, 11 May 2026 19:02:46 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE1EC30001BE;
	Mon, 11 May 2026 19:02:25 +0000 (UTC)
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
	zokeefe@google.com,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH mm-unstable v17 14/14] Documentation: mm: update the admin guide for mTHP collapse
Date: Mon, 11 May 2026 12:58:14 -0600
Message-ID: <20260511185817.686831-15-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hWmPZDF4lUBVIqAkrq1r0yaFBVTVh3QfAy5PRE5eKIw_1778526166
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36D7018000F
X-Stat-Signature: bb4a3bqtp5nfbp1rtjntbomhmx6atm3e
X-Rspam-User: 
X-HE-Tag: 1778526175-952347
X-HE-Meta: U2FsdGVkX18PwLmqG8gQbS2r0ujm4JVyVbrZqCLvHJXo8AUPr0xLGN2c8eC0u/rSsjFC6Q6cy7QYlZcLDaYKHGcUaOXppi7wmwz5H4SRUcT8eG6sPOhXJ1LXJ8Ewxl3+vNVx/5GdBW7E6WZLduMsQMIiFxdkbVl6jjmV92eLKXwXFdL1cUu9Y7kcHQu4Wyx9vteLyrwDx3CxxGqBLJ0p76+QgELfeM7zuJAJx4yDOjislQJS+XWdJbh93c1xydgHuGidvt2lBNRzhj0cxA3AsigFwnGym65s4rSeH3uXR856XKQJ80NUfbvVRyoLFAyfGqdG/oDHFz6/aVfjnuQ1DCunlmLgFNaVw1G9GscrzAc0kjumSoa/fD2xpb+m3j39eXR10cKAR+j8F3t1QsisU8H96O7JUIXW0i4XySF1apQmtgmDfwmUZFoG8XKPJqYRs0Zu0j2567B7kDf4X7mWKftUni6D9mT2Tk9Y35O1kwMZh2CBqstD9Q+7/Db3XKlHbwaJQEsSwrtAhmeyllsVFclbbH2kFkIlHuuGTCCqGRXxH2nJMVumUwsy7+61R59knEKyQPxuvozMrtGlrEl+qGFZQngQx3PCoEVryAbmA2MucL30eN64rX6WSii8g2OELJYMYu8nrGXZ5laflD40RJLe4cXSeKoquTo1UXaU+pcEZSie8p964FveYr1nfloM3Z8mxRarTMB4pLNFAU/MIkuf90seyTtPfsWJIIbGjuinQ1FxO2Qt4awjVh/A8nfd/ezfg6fWi306gpZl1pDu6V2iWXadU+odHh7jLFu3sr9OIaWP6XYuGeqciaYt4u0MEv3ld3NWGW2jPtmxRwr06Aiwj4onr+tN1K3txsagZ4yVDjhHS4fpC3ZV9tkxM7RQr7zkgOc0I7YKTuiyxDLfTY2Mryc8OaqRa2N7mRY729DkS8v/zEY4SyFT0oqCnZQKvByjlbLoxT4sEIbmVsS
 5TYOXgTX
 0XMo0e1IEvDTaf5WrvSRWn6HCWShlN7lPAgXswVEoihiD1lFQQJJa+b6apQF7LJax6aUmSpV0R/D5oB4gpTufCxLx+xFFTq30Jg+udA3Q46B/QO8NlR4UsyP2zNXpSItpevlf7yNdiVibuJpyaynPUb38K7jN5RuIb2jdQiKXWIeMO794YWpjFVNLfkYhBoxPxRfaqCiDeThI5Wz/hLa6+jnbXiUwme/rOJSik8zrq4kHpwsLqAeOHr6OreSVCC4J8Vh1WyE63MDaJbgwuMGe8saNbOkJTtUr/pOhWAQVajbsZe+edzgGYqvgNUuyaMnSNIl24rcOQpnBuJrXmjQ1uJswf4iCsu0qR4JmRnnWgpAYrMV8BNrDBl33KaXyBudePLZ6pT4iPwDmzWAs+iwVIbatkULHx5qyR67j8TyBzL16z2rupl799L0pMFfTY6U3ttZK14ePSoBcJ+U=
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
index 80a4d0bed70b..fc0127a36ef6 100644
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
2.54.0


