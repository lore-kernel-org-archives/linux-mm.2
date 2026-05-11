Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC8A9CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2A66B00DF; Mon, 11 May 2026 15:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A94C6B00E0; Mon, 11 May 2026 15:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFAA6B00E1; Mon, 11 May 2026 15:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED7216B00DF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:00:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E6BF40264
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:00 +0000 (UTC)
X-FDA: 84756053760.08.431734D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99CD3A0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:59:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TCsw5so4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVpNWhE7VBVo0N9l7XrAz43ZB8IVoxkWPZ1WSgC2EWs=;
	b=cNpvMZC1oQ+SUI5/OiYiD62onFuXewmmkaJbCVRQqoPPo0DPdiBv4uciVfqMpghorz9ytM
	FPLseymfsdoXCzLzW3+KFBdKKKuas7/nkFSx18zw1B/4zZTMMJNAVzxLVVSsC5dWvKKy/8
	j/B7BdgLv4/LZV6n47qgJVEZIXO8AAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525998; a=rsa-sha256;
	cv=none;
	b=jcpsFY3FLWGQpBYYvc6pnMepqOy8qEdcKqO2bs3Cg9+Ry0pH/cmlV3j1asbL55AXSag76b
	C8hlBSzVtPIuTfcYgSvUue62zXfHCiWkCYg8ZM767zSrAEpUITm1dTWNeLQvdw89zMoQoF
	vxfvkjBWK5VErST3R8XsS5anOXBxyt8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TCsw5so4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778525997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OVpNWhE7VBVo0N9l7XrAz43ZB8IVoxkWPZ1WSgC2EWs=;
	b=TCsw5so4icAmDVoo+pqoEuDgNO/qJYqqavDourR64dxd1lchVmpkqzMdKhQ0EkGjD0ft2k
	O1lmiLhPOV6CogiRr5+xToA514bMEUL5Fhue5Z9BFUJLQaLP47grqLkV9CcikCHJNArYiY
	N9hP8WeW0+f3+coJpjqg4IEs5wt/IoA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-m0Mp44_WPq-dFRC23qmLOg-1; Mon,
 11 May 2026 14:59:54 -0400
X-MC-Unique: m0Mp44_WPq-dFRC23qmLOg-1
X-Mimecast-MFC-AGG-ID: m0Mp44_WPq-dFRC23qmLOg_1778525989
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AC0619560BB;
	Mon, 11 May 2026 18:59:48 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DA3CB30001BE;
	Mon, 11 May 2026 18:59:29 +0000 (UTC)
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
	zokeefe@google.com
Subject: [PATCH mm-unstable v17 05/14] mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Mon, 11 May 2026 12:58:05 -0600
Message-ID: <20260511185817.686831-6-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3GBgsmcUrVR4E7GCuI4FzBf--b_XHdglJtYbmi8G8gw_1778525989
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 99CD3A0009
X-Rspamd-Server: rspam04
X-Stat-Signature: iqccpqdjuipy6x94ai1mn5ca791aa4ht
X-HE-Tag: 1778525998-124279
X-HE-Meta: U2FsdGVkX1/CzqgZf5xewdtnYSYwrcoI4OYuyzYM42Oc94ePlqlBh8Zawky250In1LTZMfppcbbFi7ewOjyGrMY2DLqePX8a1j7E5bNoxsBru31iLUoBEKH+IY79BCqrtQxuWodUbQmiwcR9q6ouBh6VYtQoDzDalm2YabTVGwmpUZWxvCJao/WucX9XMj+L/cPy07G3GnvwoE+Z03ukkq3P/rCfFaE0sGaNGDjEfXaG+qhYz0KmPOkkLUmJKjxnXDwoOrjXwIlu7J4aUT6OjK9f/XfVFGNcBy1kEeDVf1EffUHI4FIUZ6pefhrlqxPHK+7ZWathJ2NmcARDYAL+r5OQjNzYM+fBGfsEqLDamfRIfFiZ+X4WdRvkFZxOewTVI7NOoXS1GO+JXxQG3raycGmjHytSZ3BRaID4QR0iPDDCFlmVLzgcZOL2hPJruVOtwQp2EW9A796fdeYsPkiSCHFgKfLjmzmpkOt+w4yi7HjKEnPDqdjuQ+LAfX31cyNUd2c1TF+RlQS3eTSvY1+QJ0JiXBIhBwVuB9T+AzkmIRKmJ4bG0XMwsRioGqpzF5BOkK1Lxakc9Wie63IiBMDrroE4SY25Z6ipv8J+bNFdrYkCNn53o/6VAyoJ/5wegKRv7T3JWCdv8fgpdTpGIvT0oKZtXjndC2WBYLUWk7Gpbyd7v05xAxLywDb4SC1P0Aki+xu0bUUkLCRVTMOkCdO4bW5bmgi2W5k2DaImdLAIBj5ym5/FPId6NW8ckXmuHxkxBa2iQiRzI/DSH5bgFwMvoY4ydk9b//bLP4BqmLzI3qsEBYwWWs2R2u02usSU1N7MC+GkTnwEQHYCUNCw4WQtWAMJHuB53XI3Ajb1w0dtOgFMPQr5wGCnNgY5C67CeGQ8Rzhi/9vrkoxMY8e3ZLibC5WoipSXijvH99nFmxDToBjqZ4RS9jEGgqVwmi00hOd6OzcwcFXtr4XJiklmUMw
 8yH2UlMM
 kbSB/6sa3zNe6H/OX1ArsZXvUSYzO4Dn6QarV2zqn8/mty3x3v4HI41L3L5QX1E0HYJ8vCQp/CvkzaxCIPDpLH/ERuQAayVOp7ao+vlD1rF3W6yQfMj8ENKZjOUiLXnVCiOJ53P86kIaIbMcebUj+TpNwsZAhB1QQKorrbAYHKTM5/TteAQmQ9AununSoxuMLQMWGyA0D8GlekxKgYBTw3t01r7mVxBkNoUz09fiK8viKNxA8bVcz+T3N9D2Us7ouVHihyYJ/RIh9fpYaiVNuSRNK2HXErp+oI3S8GWzgDo2cPyQizSUPDMIM7yFfatROiR6ZrrzBMEWCp8OH7pxgFCYkxPgIN0q4uE9rX/xWe0WLcs7C3BP1ioz7zBW9OVVIQ+0Ax89LJZgYQpvKq7+wTgBGNeVm46A8/ivyBg9MP6lv8lh2g+mTCAYquoCNJ2c0jxuMdOH5/fI2g3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the collapse_huge_page function requires the mmap_read_lock to
enter with it held, and exit with it dropped. This function moves the
unlock into its parent caller, and changes this semantic to requiring it
to enter/exit with it always unlocked.

In future patches, we need this expectation, as for in mTHP collapse, we
may have already have dropped the lock, and do not want to conditionally
check for this by passing through the lock_dropped variable.

No functional change is expected as one of the first things the
collapse_huge_page function does is drop this lock before allocating the
hugepage.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27465161fa6d..37a5f6791816 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1199,6 +1199,14 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
+/*
+ * collapse_huge_page expects the mmap_read_lock to be dropped before
+ * entering this function. The function will also always return with the lock
+ * dropped. The function starts by allocation a folio, which can potentially
+ * take a long time if it involves sync compaction, and we do not need to hold
+ * the mmap_lock during that. We must recheck the vma after taking it again in
+ * write mode.
+ */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		int referenced, int unmapped, struct collapse_control *cc)
 {
@@ -1214,14 +1222,6 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	/*
-	 * Before allocating the hugepage, release the mmap_lock read lock.
-	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_lock during
-	 * that. We will recheck the vma after taking it again in write mode.
-	 */
-	mmap_read_unlock(mm);
-
 	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
@@ -1526,6 +1526,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
+		/* collapse_huge_page expects the lock to be dropped before calling */
+		mmap_read_unlock(mm);
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-- 
2.54.0


