Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABE1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27046B00BC; Fri, 22 May 2026 11:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE0A6B00BD; Fri, 22 May 2026 11:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13E26B00BE; Fri, 22 May 2026 11:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B07416B00BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:04:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7177C8ED92
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:04:34 +0000 (UTC)
X-FDA: 84795377268.16.58F3948
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 543ED16000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:04:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiTrCzc7;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRTkjpkauHwfwAo+4suHQMOLQU0VOSuYx2Ddd1TK9Yk=;
	b=urzzgDJvTSTvJEkfDtq/AHd89dhkU6+NGBvV8WW4vYqr6Qc3yreLk5xxq9JqPy6bIJPulW
	64selJtDYeisRo2nU2BGek0VyNoTBoKHMTGVcY+PuVRsMjLgMkHtW7/MwKCNw7KGB/eLGi
	KcFrAFiK5fBlFFWc4r2TDa3PSTbYnj0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiTrCzc7;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462272; a=rsa-sha256;
	cv=none;
	b=Y4NfLLbbxounERDVv3iTFxfqDRzaS/Tl/BeshWZnTbm2M7oN4qazu5Te79zzLCuRIZMgVK
	M1jumS/c8TPHnTrVgLDER1tzygxeMyjqEwW8B5I5F2V3ZH9jOzkM9xN2SdSagc28fVulXj
	ZiDp9mto8lhsNqBbBrj1i6a4+qH60zs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uRTkjpkauHwfwAo+4suHQMOLQU0VOSuYx2Ddd1TK9Yk=;
	b=EiTrCzc7UfrnOPKo5fF6PRgMslT4VWc74+oqdVtOoIYjU6X8RKh+xR2NzX/VnqydJQKcm+
	uc1XYqe7JpjUgrRNRvf7AL7LdUAP3fYBcFbK4wClV2Xj+WnaurCJSgLQgSstoTj+EUsStb
	N8ITylGaGyYnLQBDlagmLiAIaGZu58k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-CHy_EBF7OaOnOa5AfIX6nQ-1; Fri,
 22 May 2026 11:04:27 -0400
X-MC-Unique: CHy_EBF7OaOnOa5AfIX6nQ-1
X-Mimecast-MFC-AGG-ID: CHy_EBF7OaOnOa5AfIX6nQ_1779462262
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFE21956096;
	Fri, 22 May 2026 15:04:22 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87782180034E;
	Fri, 22 May 2026 15:04:03 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 14/14] Documentation: mm: update the admin guide for mTHP collapse
Date: Fri, 22 May 2026 09:00:09 -0600
Message-ID: <20260522150009.121603-15-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hYkpHO8s6i2F4Cv6kCmZi8YdsBgB30qBv9_m_8pVkYg_1779462262
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 543ED16000B
X-Stat-Signature: mufa9bcnyiw41gr5kbcnjz1jh1y4burn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779462272-247561
X-HE-Meta: U2FsdGVkX18MKPBWsw8O7p4dKja8KOMSWOCLd0Q+Ew/K3fSTTE4kPyMRcImu7KY0wWhxAxSPHwX0qRDkU7LUfLYa2jSHkbAakxayFu6U8bvjpfcxHaBkuJ1LcIqsBdeCY3hxEPjbgrwLSvmiYcMZU2vRaKXzBSl65wd7CeNLfcvY7NyEXQu+DcBI7tKS5DKdCg0LfDAC92VhcWctIFZEBnTfcqNASoZkxJ0ZglQJU+Tey0btsbwt7fCjsU543xkf3AT+qfJpCcgQ+/0MkNZCKpSGMW/gjc/MkygbTTrxAbmrpenRrtX9pT3J08ZUSYHbrOqIP+w3UneaEdmE7g5hHi9oqQU3flYmEmymi+EmaxV9uKshrmJedqyGzzypfhdPKBhtUovHGr7p74fLFEgBeQ34t1nW7W2y0Es4cJXKxNtSoggCGlvyBZsOJR2vjSPYVbpk7kmZYjfYtcVMA6uqlmIVJtMXb4MRaw7jnVzL2wpC2GX9EfPqFnmRe9AnwWUBPGH+cl5gg3OTDDOI/SKy6aSOpCvJNnMtUaWOrwlWif/cul2EFQ/hPiB2cD215TxYvmBnS/zXXrEkviApm9byngEoe4t2iQ3db8t0czIWFSc2bn25OYt4E3qqiCr1T2iLpFFYTiE7Q5bYIKEKBj6GdxwIqS7gV1ZO7Na3eRHVUjBKZ8f9H1e8JB9Xx0OlC2Dh0fg8XPDhanSwwLyQVocXC1OxN+apVXlSaGyBVnO/ZPlD+faefIAp3J1KuDrEPocGV9/jAiNDDW1JfWOQlCiXahu5hkovq2+s73KMAUsOPbIHWKV0d1wn+LIr+gkyvON4w4YVtvnk4yL1MQafZN2dFqTkmagS3HmbdXHfW5T9BrTFJaRpphwnGfJbAQNShLZx7Gz73guRB3o/TuOJrb77mvvib1W7gtwpjgy9DjR7VrYEgkJYnAHe3j5djJeT5SZzVZ79L2ISnThebhhYDNQ
 nIpIA5UH
 XqyC0vo7yNauRj7Ekf90yCl4s23fevTytz2/9kcx/1CM8zDAclUm47kut6T7H8wKzXlRbCplZ2YJ5POsRGvlDskYgGXaarSLk4XgONguf/J8BSGPEdYC8JEmeu9F9ujbMCUCJnuwpYJdjMHFSIRox8cE+npjW7bbvjvn4rqIBMZbEdiPJG3VHKUBrHwb9KK0t0swwONrRaOctOo7x5lbE8gxwHJ8lMXyfHoSSbwGU5PoJ9sbk36zH4Lyk+oUnknGQY4tn8kxqL3oB+Ey7V4T5Ja274KWBn7Lhrguqvd8pYy+XiF1jZ8w0DRiViLl/n4Cn7biZB4G2gZNZVGig93Pco4lBZCm3CXuA8ZnaPdnzpafkdArH7+zlvUfmGVcJFCCujXT8D3ZSiPPXnSaq6WWbeyllUlwv7dmsv6uhxberprZGQEuMN/0VgruRZ+ywkebBFZKR0bFa4ptobzk=
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
 Documentation/admin-guide/mm/transhuge.rst | 50 +++++++++++++---------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 80a4d0bed70b..644869d3adfd 100644
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
 
@@ -308,16 +304,21 @@ for each pass::
 
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
+For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. At
+HPAGE_PMD_NR - 1, we collapse to the highest possible order. Any intermediate
+value will emit a warning and mTHP collapse will default to max_ptes_none=0.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +338,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
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


