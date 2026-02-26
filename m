Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA2BFD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FAFF6B00A2; Wed, 25 Feb 2026 22:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4F16B00A3; Wed, 25 Feb 2026 22:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7606B00A4; Wed, 25 Feb 2026 22:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 373A76B00A2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:27:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED8FC1A07D1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:27:30 +0000 (UTC)
X-FDA: 84485172660.22.8415DF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6E18140002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:27:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P6QKliYi;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPCcth/9NO/KdNa5zndRQYH4O7VNwapwZjzve6hdWME=;
	b=WLMbn4MMrwRhtgj3O1GAoJansqQPbKtFZYs7tftCM4ZMiAr8IAKN5JXPJ9dX6mpBbnESWo
	ckwr/hfKYg714Jtg7JVNoDQLgXBD7DEDU70Xs54It8RRH4gxsk5ppYKzdmaFdsIQ8IfXeL
	bczvqluFF9BrE9Vj+pGa54vz40Z9208=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076449; a=rsa-sha256;
	cv=none;
	b=xsLl9TXpGOE9iE4QA9VOizLbMYQK8V/IckxvwbsYCI5g+cagoWaMLV3bkeLlE3PPrZjaww
	sMyDSG+M1iK2cqOfppSUSBDOMXTVOK5WKTTkJABWYxs4tMCuYFBRIsHcPlXfXFQ/tIjsze
	XsomTnXpYsUVKmUYaA4MyknBQyQYGu4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P6QKliYi;
	spf=pass (imf23.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TPCcth/9NO/KdNa5zndRQYH4O7VNwapwZjzve6hdWME=;
	b=P6QKliYirICCg+/4VTNj4VghBDjFJawMIPGHUFI0ch8nAgB6LvgvRwr8Ty+v9jY/AAUKd3
	b7mliiHWg9z0AmaMUM1kYig59IO7rE3rKi2IBVRhkclpcGbeSknIWiunNh6xuhsGNSYDW6
	cxAmAmPPrAEF14z/MzrfktCGlsJInmQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-QLeN2Mm2PNmfIJbNt01q5g-1; Wed,
 25 Feb 2026 22:27:23 -0500
X-MC-Unique: QLeN2Mm2PNmfIJbNt01q5g-1
X-Mimecast-MFC-AGG-ID: QLeN2Mm2PNmfIJbNt01q5g_1772076438
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92B2F195609F;
	Thu, 26 Feb 2026 03:27:18 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D9141800465;
	Thu, 26 Feb 2026 03:27:08 +0000 (UTC)
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
	zokeefe@google.com,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH mm-unstable v15 13/13] Documentation: mm: update the admin guide for mTHP collapse
Date: Wed, 25 Feb 2026 20:27:06 -0700
Message-ID: <20260226032706.234519-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tptD2PyiUtFDScvbBjON6bAxBmQPXNejwPJcQArl_48_1772076438
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: rj3f1wcrgh1qkzjjxa9s67mjtz8u68yw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6E18140002
X-HE-Tag: 1772076448-853603
X-HE-Meta: U2FsdGVkX18mCZXF8OXJbELbuzfGxFCZWnVVGdINpQ1tIXMrdvcBkAdt8mJkfrr5Pf73+RwemkgUr4NSv0sf2moUqJOxhPdGjnn6Rc+LtZiRe+Ssefr8A3ATEPr67RmUuphcaEQW8WsMjsalBLctYi0+fumjJOKGafxgoI94zOvaezzkpH+YX4ldOokCQ7a9LCHd1m+S1gpbo3K+HJnizXDlkun/u1PfoFewDIqM4VyzBYNr+1ASDIUgiwkOXcjdokUhvN0OhjXYQGHQEJtFQIQX+uVZQ1ZATJ0Hd74HaiKnqeUg5LMNgMljFyy7Qb3dck9cal2nGGx7DD4gG5x+TcD+eE4QgB6Vr5s4mpXfsldkD8as1F6Yv7qXp8x8motdiWM+JuQ2z1ku7a4qiP4+Yxw1rPkqc+ZjytlxhBhUAy1Bz+G1NkED0tctjtqM1RJBq0bn+crb0kc9RVv6wsuJZ3BnTz33jhtEHx+2+TXVPBwQhXdksqkgicejowwbAcKalPz6p5rUvflAkuHDp/Ck9q6a6lWPSBMOPtZdtzw6P9FvlzPywgbaE9r1WMyxT/xbewLdf1ojrFzmEN+rbehj8bxqARRDVucAyC9R4Z14JgH708Kpz4RWGgw1nOi7PI4OZVfiIhjdHxY7RomFz5WVAY0msHf4W2UDhYRPPdxI9C2Y50kasggq9LMSoNerXubBsiRaKaa/ooAgyTmzKMn4CgDeVhnLsTIkqT2Ym1nEzG5WPK31o8cGAWG3sZTs2E0ebLYJQFFf8iV7CVNueX6WPotiimD9ERgVC/nm9w9RVxyUoJReUwfmhG7d/ySIAFyGJnNkiZb7U/4a/H/U3AVgIUHG+gwMwp2UoVwzhVBgtxSUldzHbjO0wArDPfBD2MAHsIBatXsxtmaSc1us22H4XEItx6pwsKovDITW2sVTfNplbVhCbvGLRh73dp0/CPfHqulRpxMtovfa5yH1P0g
 y5C7M9Au
 KKClOWQ1tx9dHlrijJvPAXea63tE3EKZVxy/kktg4Ue2m5tv6gkAxvEh2cipxwGSdugHoufgHDFNwcn/rpjc/kPZt03zv9AIVYUT7/YdQ+Lc7BoWF/zZU+tGJFZOzLiwqN3U8hresVv/MtAJ/WdaOa3nDmKo8w8EPhVcDhfa0u+ydNwaq8bRlmSAIlZVJITUlfwZZaTNo+wWfhK5W7eoX/N9shO7gQGJ6XLR3IBy107sPv2en9LUeucJFrTg3XjsT6rCmNgqSlvZjbhcbtkgtBY83UCa+ZCeL79kuIavvlXIRDUzPw9SxHLQDReFoCYOMJ97/OHM1nSH0v+r/4+2Mz7IvC+tWuhiwR5znCs3kJ8R0rIoyNsvrgmwcNC3csGLoV4lhkQlF2DrjDymcZBgRAzMhwPN4f0sns5hmBqhuPf1NyRQsOryeLdVeVw==
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
2.53.0


