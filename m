Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AADCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4C76B00B0; Fri,  5 Jun 2026 12:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585A16B00B1; Fri,  5 Jun 2026 12:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425EC6B00B2; Fri,  5 Jun 2026 12:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 328236B00B0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:18:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F09271A01DB
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:18:25 +0000 (UTC)
X-FDA: 84846366570.11.88DA17C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0706E18000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:18:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MdC1YzDY;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bBQWaXR8oRLz4Hk62HvwsKqlzdG1BUydAb8xounnNo=;
	b=LvyzD3mLIi158S8V6j1i3c3IVRMdRNH2MfwhvdBiMZqKOCxyCFiBo5/kfQ1GucGv60FPJl
	KcCfB9Ez9UAAFYWubS6ONlBjrVoL6FsbGvJ9YnW7dCcdHiWkwxrYhPE6XCb1HcP9XNBlEW
	+xYGoxZMN1uoTkHdz0pZM/P/UXqDfvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676304;
	b=tfjrTMl1Fmhm2lrnDFD3zpGoMVLh1I6Rq/fLknQbg417e0aR0chG2Dw0uoIZDhNYEvnzxd
	GNbAOnXUfBWORrNmAep+AvtFnWrWU7ORiYQJoO6YF2RUlmItgDH3XuZUitDmEBYyLX7LFE
	6Tr2o17jW5Qg4FANzsfPuPSwhab57CI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MdC1YzDY;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bBQWaXR8oRLz4Hk62HvwsKqlzdG1BUydAb8xounnNo=;
	b=MdC1YzDY6bzMsiqXCHSzXjZOmuxkqN373ojA6VpopSDtKz5Lr1kpJ8fQ7z5UHQZ4S3bExN
	wzAt1HlLb5LaUutFfUji8OV18rkv5Lonpt9H13BYaGmx/JH0GYwI/boSDBQNFzWadqdVsM
	K/RN6kHiB2CaZNFq1GJGPQrvtSrf0k4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-JWfnN4gWNYOluJxhfkitRw-1; Fri,
 05 Jun 2026 12:18:20 -0400
X-MC-Unique: JWfnN4gWNYOluJxhfkitRw-1
X-Mimecast-MFC-AGG-ID: JWfnN4gWNYOluJxhfkitRw_1780676290
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98A32195608E;
	Fri,  5 Jun 2026 16:18:10 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B35A918005AE;
	Fri,  5 Jun 2026 16:17:50 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 14/14] Documentation: mm: update the admin guide for mTHP collapse
Date: Fri,  5 Jun 2026 10:14:21 -0600
Message-ID: <20260605161422.213817-15-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kgcoa3uBq3X72wz8VeJxtHXpcosrVs4F-XZTVD6lBRY_1780676290
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0706E18000F
X-Rspam-User: 
X-Stat-Signature: x8zta9btj9c8tretoc7cgnirsfu9newz
X-Rspamd-Server: rspam08
X-HE-Tag: 1780676303-449611
X-HE-Meta: U2FsdGVkX1+ZThYaRKtPDqA1EfZZPy/BHcUKWvH8QfUXvxjVbcR4wZzi/lMOC3aZVF8hcnQ2x1CBRe7mY9oOFAY50tsfo98cX1SfoZFr7fbLyN23XEUSxflm2huaOUDri37HBATdojXa4Mdvp3Cb26SB32sRiWYqdkgSkMMTKi2u9WecnrLAebgkv6h943MXJR5sbtk+guX2yrnkgTppjwJ3I0z9kjhhzmT8Z+dVorr1lJ76VwmS6UDruafd+FbEtwYqlSTNk+QhfPAM7C4N8qXHJ9YyF9IjfOz5pOOKb7CIP+xYd2OfCIiuFBm0IAJ9AiVxoXqF5XESX0IsUEWu33EKbrzfmLGUaOHL7JEg3C9tQNoUxLZGhjUKt8HmzEDh45a0ne3oiaErk8JY/p7DGZP7B69jxZpkAOto/8csskks6cUf6d/+6t8jyMxmzsrAlIKN+0zTqUAML6vm0IaQbJ9ruYEsfttMEvMDP17UhRcL50A3cmp4lhOw0qsiwTpJHjSMgcVffgh55FHuY/xqnwTpxMNtBXIRRJBQ/Rc2cUWOJuW55lN8kL76hXVj4LdxoUsq4xHiAuRtAaLTnIbtaZcb77nsD7vOWXQv2PwvubA15RUG387FAqcnRDsuIlBb/nIqQxvXyWPwl4RD3zP2EnldQYK6zuhFRyMwgEWlUsuu5s/5BLeuKcxjfddh+Yc2SkbLt4HwJ+slA14wzLuBJJ7lB5abh+9f6Uye67pQZVN7jLtcWQFgsvaNcSPgNHeBMSu1O3eEMIJ5HztEpR5y40bLusVsOm2bUKYeCYG2X2wY1wQ5pDHDweOGzB/AlKO770f18RgFsBHC6vp6rJmdWTR0zgd/xHoi8Hn3qco2w4qAKN38H52MVH672USHhwWp9DDXsNEt1uwCE8c40oZBpmDXDwoNyYzo5xospBA7gIOJol7Ke9Pq0FhM8WuvzTJtGkFsncne7olWg25EnMy
 B04bQNXC
 gU+6tjmHUbTAs6GCXLAvBjrQi2jQG12Wg9umWKZwAoTfAA5ZDf6NOqnc+swtssb0RdzQqnR5Xu7CPx+wRctRMrZPjgKPX3GInSDJvoH9CZeMUICwJTRDT/KHdKmh8RQEDs++Y1skHYaHcQypj+Qni3KxvT0KBRvMukJxxELUP5Mlee8lZStZx5QgX6nTVt9+k/b51h2RjBK+a2GTtOXbzkcT87XGeY+g5i8Fkrf/+ZoygejsSq59In6jfJcl623Ueb8TsRyx6y0/z4DcqLYwUvKXswQQ4uqVGctjaqf5wUzXgsGg2xHjyJ302piGx4mbMYEGQB0LRqdLv4Lp8VYifPAnvEypNNCHu/5Uj99VnZy0mhH3JWL/aEhOVy/xInhicmPG+hVNg6aug1a1vTxrD9Kw0X9gOLQ3AQ1esGpmEX83w1BfRVhDNn1uX8Q92JG6J7BhrlfQr4hVW3ksiMQHd9EvdYw==
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
 Documentation/admin-guide/mm/transhuge.rst | 49 ++++++++++++++--------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b98e18c80185..23f8d13c2629 100644
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
@@ -265,8 +266,8 @@ Khugepaged controls
 -------------------
 
 .. note::
-   khugepaged currently only searches for opportunities to collapse to
-   PMD-sized THP and no attempt is made to collapse to other THP
+   khugepaged currently only searches for opportunities to collapse file/shmem
+   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
    sizes.
 
 khugepaged runs usually at low frequency so while one may not want to
@@ -296,11 +297,11 @@ allocation failure to throttle the next allocation attempt::
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
 
@@ -308,16 +309,21 @@ for each pass::
 
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
@@ -337,6 +343,15 @@ that THP is shared. Exceeding the number would block the collapse::
 
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


