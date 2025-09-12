Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8615DCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26EA8E0011; Thu, 11 Sep 2025 23:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE4E8E0001; Thu, 11 Sep 2025 23:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED9C8E0011; Thu, 11 Sep 2025 23:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA3258E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 560F5BA691
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:59 +0000 (UTC)
X-FDA: 83879174358.29.0FC12C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 892E31C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWYn0FV3;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12fmvtjbt9fuwT7NzQSsNvpS+gFolguWIorcWNt0KzA=;
	b=Ut9FuOaQMkilmp4eJjb5ts8mXYYUIbtoY+MS7xeGMmm4/Bbt9h0Yum9TAoinXeihBxX9pD
	2kwhcKVyxhrdBhoB33q50Nnp6GtYTLOjPMLBhMkmVdtC7FQEXTgw5p4Lj7pgE+OlAWTfl7
	qEpCQrvGLSS6BCLBe0hp/fUrfZ4xgSQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWYn0FV3;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647917; a=rsa-sha256;
	cv=none;
	b=w6kQYTae49p5ce6UQu8HY3bdMK3F0wRsDuzOlNyztHjfNBxCbi+5PeL6DtcagH+7wtaw+Q
	NMYyxItRhog7l9FkH9G7tf3Xr1fkZp8llrNI9eSv5vyFAxCMP/w/8a+nKuwst39pj5IzYf
	CP0ktC3B2v4f8fVa+ecesWF4atITZ/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=12fmvtjbt9fuwT7NzQSsNvpS+gFolguWIorcWNt0KzA=;
	b=SWYn0FV3tMnar+wA/4gN1sMi49sDVG+Zu/NmBP/501YMKJvUBUVayWrSkj6ko9PjOfj5di
	o63IW4UYbA1+3HU5dTazZ6guPDOvv8/y1yw0brY/9Kh/yEpvU+m+VegJzoLe8qCpj40S7h
	ATZSjqhGUMFrpd8O4oqTX7b8rcajKgU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-MDUdFEIgOUqx22hE6Lj6_w-1; Thu,
 11 Sep 2025 23:31:52 -0400
X-MC-Unique: MDUdFEIgOUqx22hE6Lj6_w-1
X-Mimecast-MFC-AGG-ID: MDUdFEIgOUqx22hE6Lj6_w_1757647907
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F6C11800365;
	Fri, 12 Sep 2025 03:31:47 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B446F1800451;
	Fri, 12 Sep 2025 03:31:37 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
Subject: [PATCH v11 15/15] Documentation: mm: update the admin guide for mTHP collapse
Date: Thu, 11 Sep 2025 21:28:10 -0600
Message-ID: <20250912032810.197475-16-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 892E31C0006
X-Stat-Signature: uwuuigutyfmjwpsmrnutwact6ag8kapt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757647917-407030
X-HE-Meta: U2FsdGVkX18GI4ae/F0Q0mMDh5RU15KO/NdWQFgIixlVyy/YzxWnPWCEovVR/gRuDL9ZXUGi2KCvlm69MkIkop3YCg6HRR8Y2d6Dl88k1bm5wfxppNIbkKop16ytYo5tbPnoy5MT4Q6qwgLcgdP9DT4uhLUpozCNiF7dXUzRQYWxLEn2h97pozg/J1ctK4sHztWWbsAejuyQmTVt3XBE7MOLEjupmbrQOz1xAjVFYVZQjr9hJuokvO+Jm7gtIVY+mpi/ZxgNG4giCRS46RlbY4GZ4ntP7R0J86AA42KCdNk8nABkvaiUXQ5tU+ZVzKy1m8+mNSGMfdQV4TWnfnT/P7MRFkO7yG6rfOYkz5re6IWVUCCvtO7FzS2ssw0tl/GhaZQucse0lVzR4UxfzMMnfWSx0iAPvw/hY+hwmeaICQR3ycLztnqhZCMpGNaN9EbX/YxOo34l0WBxset5/Lcfr+rDYznpiIEKTfKrDinUcSaDtR9RoWZ8ICDBne+XC0bdGfCvk+DhkpIKx1T+f+9XJ2QOy3PoLq4lqe53K/GO6iWc+tut5hEHgqYcDvEPASa+5gdI4Bju5ulf1o0laueH/vQcbLP1HzXXaA1I4Hgop4l9/zxpTUfrYRhsTGl1N5jNGapAdnv+hVK3Np9lLu32jBDY46ZA45teeKPZIzOJKPqv7JfWdYvUDeX6bJmZGKAL/vU6rWpOPbM+fkw5wpCg6FFDacsT3Er3CxYhTYVm5KqGc+REAq5WU+/AWiaP3uKlT81afYS/VFrYn/jKIKj3AKetdKLS9En5NSiByuXk/69SHYMmyFQnqcJfMznu8Lz0wU+QWyFBZ5kFeHV9Q2XiGbs8tkOlUFhOCDk7XJg7xRXooYF4ttEnkgky02FGJV05PmJ81H1DrqfZqk4cG9RZDzEnqetscHURMHzryDKcWyEo7V/zKAaHb5PyXGXp+a18beNSjUTLuPp5A54iqMz
 VK1yOqrZ
 GTI+XpQk+6uJQzsmdb0FGuMbBvNKg/CgQ/pUX3l8N8fZ4ACWhPw5pHtZi0y1uHHS69junFv1NmC/H984PYv9LEeX6Kn1Tj6NPDzgkKP3F50pIoQhWEQaslpd2eNcmOApEis/PgF9nWTfTfsCTD01QHA6KYujGK2n41wZEsOs+fSoX9u3YtC91NeuWHZ5+RbZBIW4b/lpo3YBbgDO3VTAjw+k8YOp6cKcLy1DzQ1KXmwPSwSkK7aoSe5rMCwpPGBTof1aE4+y1PxruF5PO80Qf30P6T44pr8Z7J91MkDnG+7NzGchJ2F6GDO1W7+aI1f4uJgbJbcOx80r+bXy4aTTk2Sgw2aXCCCQME+T7mimmhmhUG5noYUYuvWpgoRpDoh8+SphvJdleTFrbLuOAV9RxOfkynxxVK4W+3NsX22c4mHTIJqo=
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
 Documentation/admin-guide/mm/transhuge.rst | 60 +++++++++++++---------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 7c71cda8aea1..b3da713f7837 100644
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
 
@@ -308,16 +304,25 @@ for each pass::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
 
-``max_ptes_none`` specifies how many extra small pages (that are
-not already mapped) can be allocated when collapsing a group
-of small pages into one large page::
+``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
+when collapsing a group of small pages into one large page. This parameter
+is scaled by the page order of the attempted collapse to determine eligibility::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
 
-A higher value leads to use additional memory for programs.
-A lower value leads to gain less thp performance. Value of
-max_ptes_none can waste cpu time very little, you can
-ignore it.
+For PMD-sized THP collapse, this directly limits the number of empty pages
+allowed in the 2MB region. For mTHP collapse, the threshold is scaled by
+the order (e.g., for 64K mTHP, the threshold is max_ptes_none >> 4).
+
+To prevent "creeping" behavior where collapses continuously promote to larger
+orders, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on 4K page size), it is
+capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fact
+that introducing more than half of the pages to be non-zero it will always
+satisfy the eligibility check on the next scan and the region will be collapse.
+
+A higher value allows more empty pages, potentially leading to more memory
+usage but better THP performance. A lower value is more conservative and
+may result in fewer THP collapses.
 
 ``max_ptes_swap`` specifies how many pages can be brought in from
 swap when collapsing a group of pages into a transparent huge page::
@@ -337,6 +342,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
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


