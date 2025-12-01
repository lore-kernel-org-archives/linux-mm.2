Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A150D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21BD6B00B0; Mon,  1 Dec 2025 12:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1B36B00B2; Mon,  1 Dec 2025 12:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0FE6B00B3; Mon,  1 Dec 2025 12:50:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88CEB6B00B0
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:50:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D97FC02DC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:50:17 +0000 (UTC)
X-FDA: 84171641274.01.BE1D975
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70D6820013
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:50:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgmBZerL;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyJvlL+yvZzJWKB3B8x289eHJx+oykT4AdSd8hNpONo=;
	b=q0pg3kQ3emyoRUM5NbpmWEAhNBTJHF8hbhXrJvqtnsiykghfm0hslE2oLQoiqv1Y+lbMEZ
	eFToG4MQiqpqzS3RgdNfJh8n791Rl6ecC7xe+2pXDmDKlcNnYb8yT8bzKIU/MVT9c4FG39
	OiZx3hjDs+PWYswD7eX3StrwO413GAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611415; a=rsa-sha256;
	cv=none;
	b=YCJR1e1thspx6oTgW3OstoFwxZvsgALq9S7qqDVgsYMq1s3yoCToENXntUwnTigOT3d9/z
	Irt5jc9udavA6wA6dqH+iuT+7x+7aGJ1IhdGDRWT0FQyKLIlPDP2ATjgzgcVWnqadbXfgn
	3cr2qSPG1JEyhRiDIuXG0lzdovGWy8E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgmBZerL;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lyJvlL+yvZzJWKB3B8x289eHJx+oykT4AdSd8hNpONo=;
	b=IgmBZerL7PyEsCQNZ1/otfDvo9zQ3aOVqqyyvXir8vgEHlO8nkoYhphXmqCIQpSLWmSdGv
	DdwqmBYtxgcYQdNBQhGac6RrTSq+Jv9hq6m1ZlD12ZGEaZZ2TsQCyNdKX1GgA3uaXHb4rT
	DTLrbU7mo5LyDXPF8tRDZgR8qhGDXnY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-_9hYrk-EPTGF69Lcwl5dfQ-1; Mon,
 01 Dec 2025 12:50:11 -0500
X-MC-Unique: _9hYrk-EPTGF69Lcwl5dfQ-1
X-Mimecast-MFC-AGG-ID: _9hYrk-EPTGF69Lcwl5dfQ_1764611405
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82A54195608F;
	Mon,  1 Dec 2025 17:50:05 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7228B1800451;
	Mon,  1 Dec 2025 17:49:55 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 16/16] Documentation: mm: update the admin guide for mTHP collapse
Date: Mon,  1 Dec 2025 10:46:27 -0700
Message-ID: <20251201174627.23295-17-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 70D6820013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: jkyw5gyo3y5463jax1n87cqh66c46yb6
X-HE-Tag: 1764611415-996068
X-HE-Meta: U2FsdGVkX1851rHUbejs8JpirJ/AwTe3ZDgVCC6SwydvlrvmB1tlT1wdkcOIS7Y9xlm/tPYqDWEH1zyF4QDsMAFbspd0Qvo64vmNcYtksD7Xo0gIernNrlAcbLhEICx+yCyHl7kvNj1tsj/Q7cgPx3Y1vnpS6zP4qsApA5bk6lWdfClj3oqZ8Hjwnk4sLlc0XEgqj0eXfdqZ0nak/xBONE+6AE1jrFRHqUqjVfut+kEAql9qM01/ymgm1mtRj5HjacUaaZcckaTIXG8xLEFZbbVPZgw/pU9qwB2gW6N6WUJgKjJ4Fz80IZnJODL86hxn3R2x32l0uY0WU2u0KlC+wFfaSSGwuvAX7+EFR4TZkAHZrU5nj0qGBFR6b7aNbWgowr5SteOYUCWx0l1fLbIsUcyAsEwqukVWvkDJHnSpMuI7DxQb6wWmZmXsdT1hWJtuMwgl9XQBlnFFuc+8BLNsIRsePhAa6eRxxKqv63BhNHqB0PQMiyUHnSh8KdwvFA9doul3ZhqQsSBRcuv52CRqiU8NRzxdshaCw1BlvYeeSlQ34Hwy70X8keZYrJczcTTgPLpRx/8hU6QmMLXWZZfklFCrQuIBZyImqhAyEMzHeIu2f4KlfyHVZlLUJN8hv9f38BbUpNZi9jFjLkehRnyLr5XeMcl+FAHfQmWJJqa4W33bdZckuyRzVUP007mQ87oR3zIJB316yrafYPuMkbqdCOojmyPoENDf+uZAv3/1jLtdELZuX95Uiz4DP6AMBOeGqKs5gJfdmBrdydJQINcH6QMnFefVz2K69JyQ5Yx8IBjLSW2o7lzytBjGYza7eGy7Q9MtQxURPnPGgJ0pSqCqkVSvcR4aq4TGznqgvlaMBLjTeKD63gXGQkcl60bKZoFWbOq4oS0t7jkI0Ubz8qMwb8vwxr8Qadw8A8axY/3+Tyo29ClqwqyT4r5llZsVEQ5hVLZ2z4ZJiEhxRRANL5V
 3cBHV/EH
 3ts4mufsWBXDi346YmSeKxRF5nfmcUY5zS3lsv/4NSIFLQdwUr3AKEE5OrStzjmjPDoKrcsppwmm2yhJuy5h6mUf/7BDqnMk7coVHgTGL7uyzTKOzj5IPpdk/KbE4zrL0qFqWX4rjcREsShUQaKm6V+rqKqnhSY0VWdmqGKllAIeZ0Nd8CKicW8MaW/Xv0iMUu2fao1tJWJQ5Lq4QmIgA0HMkqVm4m7HToAZYt/op+iI8eFBw7zgGOPoKoObDqGCwFsc5XrQsh8L4M7BuCFL3VtC4r0dWlqkUgQcqxAYkQKOLptKQvDc7ntXk0RgjquXMQ9Le1BCuTk/IiBk8OC1Ni+OeEAj6YPqQjn7gPyy716ENcj9jYq8OR+Y4Am7F2SnZk9p2DBjWn+vaDyKqHZGiXamYca4jwPXZITPJCyz4fgIUCdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we can collapse to mTHPs lets update the admin guide to
reflect these changes and provide proper guidance on how to utilize it.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 48 +++++++++++++---------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index d396d1bfb274..87bcfa80886a 100644
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
 
@@ -308,16 +304,19 @@ for each pass::
 
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
+allowed in the 2MB region. For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1)
+are supported. Any other value will emit a warning and no mTHP collapse
+will be attempted.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +336,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
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
2.51.1


