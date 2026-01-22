Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55441D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4CB6B0340; Thu, 22 Jan 2026 14:32:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FEE6B0342; Thu, 22 Jan 2026 14:32:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CBD6B0343; Thu, 22 Jan 2026 14:32:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF0A6B0340
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DF628CE6F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:49 +0000 (UTC)
X-FDA: 84360597258.04.0021BA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60E2C1C0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CED6yTcR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110367; a=rsa-sha256;
	cv=none;
	b=BIaT5T+Mndo+pa5nvHjCN7jY35zN1PdcstQbbKCzRWjZ9qCLl38ny4utz1Yd5H9RCpJ3SP
	tU9owNdbwCCoi64IslCraferZTXPod/dQ8k/cz2AQZCBZGhgWd7XRpQRab/CVlxh1idpR+
	5s0m6tO7u5kVmmw37vUcC8gxYTxf4BE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CED6yTcR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0STx4tkQ9bStzN9UXzB6G1L78sa7AJG1Aqo4I2ghBIY=;
	b=NFyYb3cl4RPl2Fp4W25Dxgj/WpieoavEPnAGVkj2/2IRh+b3K7t7Q8oLSH5DFqF4LxSC3P
	XjmtZJIvtW02K3r/fYny9I9989dAvl+867rw2qqZbYbRi68do9vwdL8Z3K07PjXZIDHLbh
	JdFCe8KEPyW400WJXYPKlzXAgI9pv7o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0STx4tkQ9bStzN9UXzB6G1L78sa7AJG1Aqo4I2ghBIY=;
	b=CED6yTcREr+SAuTAUq76dcgCnXc8K00BxthZRvHABWMxSVojPch3zYD5y38XzPkceMtaOP
	m8m8ZF7L6mqIeIkCNYtW9sG1PzeGqEWuNSp8qzTDBzVSGqS79w2rOVux/RwFaMVddjxTre
	IP9Ui1PZCk4tYTFmRezBGMEKOu9zROI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-mRqfZt6oOAqgKqYrx25Lfw-1; Thu,
 22 Jan 2026 14:32:45 -0500
X-MC-Unique: mRqfZt6oOAqgKqYrx25Lfw-1
X-Mimecast-MFC-AGG-ID: mRqfZt6oOAqgKqYrx25Lfw_1769110360
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7308318002F0;
	Thu, 22 Jan 2026 19:32:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EFDE81958DC1;
	Thu, 22 Jan 2026 19:32:29 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH mm-unstable v14 16/16] Documentation: mm: update the admin guide for mTHP collapse
Date: Thu, 22 Jan 2026 12:28:41 -0700
Message-ID: <20260122192841.128719-17-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MMImgZkLhuNz9ejeyZJDdhi7PW5WfX33J7jaCh4S6sY_1769110360
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60E2C1C0009
X-Stat-Signature: 9swjtwwits4ifi5qzkzm1r3kekymy5j5
X-HE-Tag: 1769110367-579313
X-HE-Meta: U2FsdGVkX1+rFUmDqJyVjqcqbtAPd5YyY+Ri3G9oCut4msCKxf71BeHLSLrkiz7pbfByPPyBc5Xl/7TLmCFO62e1UYdHDxutB8wgu5yxr+x3Q1jTx+MeAxUMT44hL9qV1MlYiD0WQyOzQpRjxH+JM+SZdj7m8seRwDlQQ0cCiDZ4BTPz3rG3yWfbe6TO0f/1N398V6BFvrj78eYH0Z+/vGhBkI7iJQ8HM/yWnDBW4OyopFFMpnzGicCR5+hj8q8NYlmoJn2/JfKgMAGDGZFBInBN01Wrvpweel3fGy0uugDT01a5nv458vH5nGxYJ2J9jZeIZSN4NBMZuwhQ5m52j5FpQD58eyw+vueHqoxn7PUc+qgmVXQ5eLOR9sIH3Snv/IQdQwsIqokutNJfw732b2tgetuQS06bBAzUwRg10LajYXlU/HExbJev8rFD4pnxdJDngIbYEXy5ZOipKLU6PJDLJNe9RmXjCWyhL1OfrM5J4M+bi2+3sOvK+DJHOoynPB0AllPW88aAdC+SnvW1YrKpVmdf1x23Dz2cqtZMvExTjNjNwtNiCVNEAxU/qy4qPaCagz4dDO04KA8UvhcOwIu86FC9Ztz4AxyBQCvZFUsPaK8HDxgRuMPzojGCmG2lN4RJFp20ZZ7GWOTt4I9ojxK2Ah4C01ujQrXSqn6t2T12IAX/xySfRsy7DHToxQ4eB/ETvRrJ6b9MWYy9iu3pXLNu7AJu+6Deu4XNWOxM9SaqhN5mImS0Cl/OCWj0ZlYCSczsxcot4lLGPVX9WY/LSXlGd6fpSfeFIIcOQYQugXwP6By1qQcxfZgSo58ROi3T4sr7vVulkXcIlmGx+wFOJ4e64SMlUaJto1i8Y2hy/BqczNIAhsC9f1O8FhrTQVWbrpq+q6plY1ouP5T8BBBIgEP9rZewJ+lqpbj83HhZqcBZi/YChCHxzkQ6HfwcyWMw9S0wHdJBLNYIb+nlBbK
 OXNMdfP+
 OAQLYbcr9Za4vZiSaOPWENhFPD4xtlod+PFDsIgomGHw3pLxZWosOK229d1UVL8xnZeU3pFqhlCr9twszcGOt2dePc0yYXZfctrfFT9r1ZCzC3plOZeAGTMJ3pF8G/AE/c1dVblph59cqEAvN0BO575CZkcRZqSVleIvh8fvC4Z9/eSI2xPNWjfqbGRxCunQdkkZb6rF0gFVh9ZXshZ47CHcoaZObqfuEDyZ/9Cyfouwea3RK4a8Zmrw8wmoTT/q9Xw4zlqlRR1JwDoIMOBPOzPqw1g1gZoT6guvSAIN+z97Y/pLJ4Pi+jMv381FYJoc2pVB8LJTST1S4XMzea5wIOUS/TT4sFWXCVM/rXyFetY2wzye2wWd+hy5EWGAv/3ii0BW8ZDmln247NZO1WOkpCGKdosLoQPlJC3DYcG177IGBN8Hnnt/yVAMBFQ==
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
index eebb1f6bbc6c..67836c683e8d 100644
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
2.52.0


