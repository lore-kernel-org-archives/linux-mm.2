Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F96CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8DA6B011D; Tue, 19 Aug 2025 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80E16B011E; Tue, 19 Aug 2025 09:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996D96B011F; Tue, 19 Aug 2025 09:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 892766B011D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:49:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CDD1C07F7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:49:31 +0000 (UTC)
X-FDA: 83793639342.14.C2313B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79F7912001A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:49:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZ85hNU6;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ5SyoE/MYPNZDWioj0kryq2voWpDfBzmzGzBWhm6as=;
	b=kqlYkM/LY1QRSK2Qx9/fuEYdHTuNtWILpispj148b5KKRBaFUFCn+IaRdQuiKPY1QiSluF
	HpyjrzEcDJMCj60c5NeMNq9RN7Vq32txqpzgFoh+NdVV+rFm9harW5/piCIdsc+SRefGpI
	oU8idwZSRMH2ad2NWYz18ks/fhW6fnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZ85hNU6;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611369; a=rsa-sha256;
	cv=none;
	b=CW381oykBI+NJyRR+jbzt0FBVys/Qpy/a+x9XNbRZNhRdjTEmeqBtIFDbhi5c+gl18Cshx
	nJCLDdfFBstUOPG5uE+NG2TR04w8fDf8F2Auu3m9YZ5ujE6m/gcU+VaPvVz2778dUKMu5+
	SeVrG+xEip2cAR/R8P9o60QOupfIoak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQ5SyoE/MYPNZDWioj0kryq2voWpDfBzmzGzBWhm6as=;
	b=hZ85hNU6+h8jhUVdeg8/NJkIT4u45o6560CuPYaaF7xTmdPyEYLblGb2ENmFA9vJ9ejuqu
	L7iYNWpwY+BIGwo6RjOThJJG6dNRatm3INGURfedKriX/DxDs3zxJ0bLikaurgMrSWlVxU
	3U29VgABXQ03aMcOQTWRpdC+LXC2Pnw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-uSjnhtN9NuKn8IW582EbqA-1; Tue,
 19 Aug 2025 09:49:25 -0400
X-MC-Unique: uSjnhtN9NuKn8IW582EbqA-1
X-Mimecast-MFC-AGG-ID: uSjnhtN9NuKn8IW582EbqA_1755611360
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CB27180029C;
	Tue, 19 Aug 2025 13:49:20 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE3E0195419F;
	Tue, 19 Aug 2025 13:49:01 +0000 (UTC)
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
	kirill.shutemov@linux.intel.com,
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
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v10 13/13] Documentation: mm: update the admin guide for mTHP collapse
Date: Tue, 19 Aug 2025 07:48:24 -0600
Message-ID: <20250819134824.623535-2-npache@redhat.com>
In-Reply-To: <20250819134824.623535-1-npache@redhat.com>
References: <20250819134824.623535-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: 5ph8ftnpbfbm7mjgmb5wx9fyigywbj9y
X-Rspam-User: 
X-Rspamd-Queue-Id: 79F7912001A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755611369-317584
X-HE-Meta: U2FsdGVkX18ct87oOjEvV1n9RBH7KJ5ZniBt1NeORz5bEDNPOFXr0CfVy1cMthQZSCfvdnQ8dpd+nHvr6ONaxqHsbwFiNOXFv7icKqmZuxIvi5o6OwEvvDfZr/y+vzaewZcAfloKdi7r+twdAhLWt9cfVEwLQ+r61FwwrvwIl1xQFshiaXM1F+YjJZuKS5X7+RcTIcFRQOreKLqkt4BXZZ62HiwQ7s7iDYfvQFWms05FOL7I1cLWx47g34J9IOKOBOg5GLrMnZwICaX1ySq7EHROhrLTPSHyL9QCxlNi0ZEIOS6XJRT/lrcoLXOip480nY4T9hkW95dSjufLtEl7aflh/6PV8I+hArWWaQF5eX04sl1p9FxQv5Z4AiTGNcR8C904+7WLbqJXRcmU6alfktg3Mhua9Ilf+pVLq7uiErQpdOJgeoSwA8Fxf3/Xaooc5kwqTNs4XQzrSTJbW45ywDrTv+f2ZrZgqh5TpifAKxUgYQQeUrwvIppUXY6QUPhp9p/UUPAuTpMvywMktef8ZJhiH1aHLdlTEn64khg9haSXiFGOmUgXo3S5RL64Eb+1u1Dn9dFNE8wLSbbsVspi2lHuNkD+SyBxj98bB3Phgp0NE9O/Y+8tPBSHkXX2LxQYbc2rCdkPxRJWkN3mXIqVEpYoXkBybvPkHhot9O7/UPPjYfz7ul5nBIUckBY2rowsji7W30EVz4+q/sAPPDJ4eBDispn1naROzzF2PHUhQayNO8X1CkA5otQXHNMtepqaGjEvDC0v379OdKyjvhGxu5qMJYaT3V8x5eg7VIYFALI0URSsV8dIzMnS9s08K1j+KeEEpBzBmRoqRTNLThIWMFsxCGUNwof84iJrHTbcTLkK4bKjcP3kKJJvpsiOiGKYbpShcL6udvkPWhKPb7cJgoZTMleWFFG4j8HzRf1dKdjDKk73cwQQJcQWkWQtTE2kstlP3EtWnyn6NKPwW+q
 2f3lS3ig
 2eh/lNHDPTHn2ryqgvqYTyL5Ivx41qzSXLr4yfucbvyXGpZMuhBLl8V1NlphE9nzPhS50l54alFx5QftQqGgv+i5tMR73XtMr1Zj4v2spDjD37hOTtQ2owgrtgIm3Wy2RXcYP2nWTEQyRciavg+uu//g/1lmdP/g7Se2IffodYkBZ5gKipQY2cz3d4HTOD2ltofSbccN6eoifa9gdqF0lIUPwi9vJG6tJbSNnna4hbCmND52TgECd+i/VlGdGiOKwC1hhftu3qJ3yNAPeKfjdx3afQZCFaTGsCQBaUwW39ls2VtCaC+BwXJcA0gJi6kYmVp4JZWAPzuODd/nuB5DnxR43g6nDQcwqfXLt5c3csVieTXORQG/V6SlHtzjE22v7Jl4rKdDj7VTyMxrtMnRUtKoYVyPmxvInYeg2TIVKS2kL5s4=
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
 Documentation/admin-guide/mm/transhuge.rst | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b85547ac4fe9..1f9e6a32052c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -63,7 +63,7 @@ often.
 THP can be enabled system wide or restricted to certain tasks or even
 memory ranges inside task's address space. Unless THP is completely
 disabled, there is ``khugepaged`` daemon that scans memory and
-collapses sequences of basic pages into PMD-sized huge pages.
+collapses sequences of basic pages into huge pages.
 
 The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
 interface and using madvise(2) and prctl(2) system calls.
@@ -149,6 +149,18 @@ hugepage sizes have enabled="never". If enabling multiple hugepage
 sizes, the kernel will select the most appropriate enabled size for a
 given allocation.
 
+khugepaged uses max_ptes_none scaled to the order of the enabled mTHP size
+to determine collapses. When using mTHPs it's recommended to set
+max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255 on 4k page
+size). This will prevent undesired "creep" behavior that leads to
+continuously collapsing to the largest mTHP size; when we collapse, we are
+bringing in new non-zero pages that will, on a subsequent scan, cause the
+max_ptes_none check of the +1 order to always be satisfied. By limiting
+this to less than half the current order, we make sure we don't cause this
+feedback loop. max_ptes_shared and max_ptes_swap have no effect when
+collapsing to a mTHP, and mTHP collapse will fail on shared or swapped out
+pages.
+
 It's also possible to limit defrag efforts in the VM to generate
 anonymous hugepages in case they're not immediately free to madvise
 regions or to never try to defrag memory and simply fallback to regular
@@ -264,11 +276,6 @@ support the following arguments::
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
-- 
2.50.1


