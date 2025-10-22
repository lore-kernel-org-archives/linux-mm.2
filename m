Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E18CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F9F8E0021; Wed, 22 Oct 2025 14:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0458E0010; Wed, 22 Oct 2025 14:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8118E0021; Wed, 22 Oct 2025 14:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 294C88E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:41:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D247311B09F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:41:00 +0000 (UTC)
X-FDA: 84026617080.01.536FF4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B4F44001B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YzcgMnB4;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZLhkE0tfvLtP0azQsjBMMtMMpcq+a++94oUT8h+PFI=;
	b=M4mu5faicMPJJzVSa0GmTFpc/rpACiRRJw5E29j00obUx3dagJ//YmYshn8LKnWG1Ozhu5
	qMkqZnPCEQwa1NGLTMWtUFFu6tWW886lD0kItrPLUzqaZbM7quCz3/jtsWOSxdZnkLIBe0
	SLenQ53wfgteAiBUtZBGxCtflRYcP7c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YzcgMnB4;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158459; a=rsa-sha256;
	cv=none;
	b=R+sCFWFPnt7gDKJobkkx41eAowCARylzce8BvMgNN29tRvBLmEFyewpHKvdd0TelC5tPeE
	64tmCRf2JWntlf+RxepYfCzxTx3oxmpQnJ4HLKzlMpAjI4PDVaa6tITEOwkyjeNKA0iupV
	33UNMELkkP37xeY0O+UfrwLnWgS/Uws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZLhkE0tfvLtP0azQsjBMMtMMpcq+a++94oUT8h+PFI=;
	b=YzcgMnB48hrCLa00MKVbrxgQ2sQOH8ONIDrsgvQgcvtefuq9BF3IhyOKUf9fow3MD5Agqg
	ZJPe+YKv0MNzbd2zwv+RBzxYhXI75Yd0+wiYwwA18/7Zh7y/1yXzHNqFsQ6ECIwCLxYFlQ
	ujXjlSH/dMYqJsMU0deaAkQOa9nOQIg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-6_gU97YVOxOADa4ba5YPVA-1; Wed,
 22 Oct 2025 14:40:54 -0400
X-MC-Unique: 6_gU97YVOxOADa4ba5YPVA-1
X-Mimecast-MFC-AGG-ID: 6_gU97YVOxOADa4ba5YPVA_1761158450
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC4A41956067;
	Wed, 22 Oct 2025 18:40:49 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C55119560B4;
	Wed, 22 Oct 2025 18:40:40 +0000 (UTC)
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
	pfalcato@suse.de,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin guide for mTHP collapse
Date: Wed, 22 Oct 2025 12:37:17 -0600
Message-ID: <20251022183717.70829-16-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 1B4F44001B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4rh6d3mk84wrea3yjhgxmr9qg6zc8tut
X-HE-Tag: 1761158458-71294
X-HE-Meta: U2FsdGVkX1+uWuzkFRZk4AmGFTyIr/dS2OmZSKcJ+IR2See602+uEWCiEXWYHdNCBFCTwa/yFyq7hYd8b2sS+8CDBqj4dj3Iie/WOK842HtxX+QA1pa90E2ixLKJDQIvY3OJeYTjdb+O7g7fdrZasJmmRu/AbAjkR4mbPSsOyA+FuZHkRZP/kit31jZvY7jSiA7S/gIq4EbBEDRkVoekjbARDpmCHUrl7JVh6GjuWZdKs9maEdxkxSy2dUb1Y4XPc7RrxLdBGh1LKhvMONG8liJ77dReEuAVXzsjm/4NGIpu7zT02ANk75n7OwZv+eD4QAzcN45Rj+PcmaSbasIMEg3QXudyYYsFhZVU6z1iqDgWRrt9TcJwYhrz73Y8mqLQJvw4f20WNoWj1UBdaf3nfxdDWz4s7swsgmEN07aS17ifV0dV8AB3S3d4FifpRnC6Iz42dINRhb2az5PH/sbHf/AAHgawNqwTIPgR5LZAPVPBFHEsmeJktwvG/GRpJcBETftOmLnqfRthwLFUEdEc2c9NHcUkYiOAL7zWDD7GOoh1rRtrKT+Z9EN8GjrrOCSugjQ0ShHCK/2ajHbOM+OzFurn1n5+uwHQWoCduNL35iwe8JbDKast8F0Vrk1bpyDd8KFMp1waL8JZyJTMoXM1U7JAsAH9Z4RAZS0F0Z8+DQJFJkKsBzg9L0e4TJ6O4klTaG56D+mj+5ILNeNfBgclV03HqcDJEfowmP67RC0zuQB0HiCzCUr+bfD5G8b5TfucwMtS5cL2yAbXif17OIKpSAGGQoe5Jpwfnm2Ff01gnKoyZd9eS2sjv8dXorBm5x1mzMMtay5yDsNdafzuNcYskd23+zOHfr7lFlD+BK7vbZizjKUS6jfo+TGoZmHb4oLz/BWE8Rve2dA990r1xp0GnlSaYpaIU40itMfbLZ8A+fMQ9JgoIkjsj6Q9wdKRhvws2u2DAosFvYapDIZPqlz
 xAWknIqo
 EhwYfSl+opBewzgsVLgM1iT3NIeh/rRdvPgulJI1FT5pvPTld1rwcH6/FQ+aOLm/LZTdYdDMJ6hXmQER8lxsntAHAB48EiEiBKDO2uqcQ/qxeJX5AU4Tlk+p7ZXSIPZsIkLfBEmRvVDncnGVsFJ4YeGN6612nKzMZ2vWy7PlkNiYWrkJkzgumd6yqI8DzGZMs1mlCO9tHidqmFMvmbHfeAgsRC4DtL44ZtWSb6xSMMf0tss4i8+KJ4ray3qa2UPa5KNordm5JKJOmydpr52KXEH/AJHxDC8XV5zdkzfRbYV8bNgiAsW8crKcHjes+J8TlRh81J9yhsZagJs/+Y8qX4WZGmvVibtM4EuGJYzpvR3tKkkL4qJyLkwvpWWmWODsI38efS1gCGyrb6Ac3rBL2icOSkay7RM0kKhuNxWPz3miTyOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we can collapse to mTHPs lets update the admin guide to
reflect these changes and provide proper guidence on how to utilize it.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 53 ++++++++++++----------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 7c71cda8aea1..2569a92fd96c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,8 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages of either PMD size
+or mTHP sizes, if the system is configured to do so
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -212,17 +213,17 @@ PMD-mappable transparent hugepage::
 All THPs at fault and collapse time will be added to _deferred_list,
 and will therefore be split under memory presure if they are considered
 "underused". A THP is underused if the number of zero-filled pages in
-the THP is above max_ptes_none (see below). It is possible to disable
-this behaviour by writing 0 to shrink_underused, and enable it by writing
-1 to it::
+the THP is above max_ptes_none (see below) scaled by the THP order. It is
+possible to disable this behaviour by writing 0 to shrink_underused, and enable
+it by writing 1 to it::
 
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
 
@@ -308,16 +304,18 @@ for each pass::
 
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
+allowed in the 2MB region. For mTHP collapse, the kernel might use a more
+conservative value when determining eligibility.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +335,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
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
2.51.0


