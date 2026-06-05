Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47B8CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AD16B0095; Fri,  5 Jun 2026 12:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13BBA6B009B; Fri,  5 Jun 2026 12:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003316B009D; Fri,  5 Jun 2026 12:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E42916B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:15:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65E77C0C66
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:38 +0000 (UTC)
X-FDA: 84846359556.12.F3B38F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E186180004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:15:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EWis8/1C";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzDHpbqIBXdBWPrEX6e4jd9D7S6Wp53dvbcajiiuilc=;
	b=fJZSDqcIzjHwNBwrg3Ty2CKCinS9bI8f84mHQIbH1R8hauJoGySdoFUpmBV8S6y7q7d/jy
	XQUCo1W+LH7s5UeMfY7UDV3eaeFMYZK/JjFtQsHVJbv4QBc4tGz87jlD9exst2B0QrY8MA
	OSvoOCAIAl0MQwl+1YLc+Fsz8TV6qoA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EWis8/1C";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676136;
	b=oidWDepexxRyxBdfCBiTia8PfMEB3vj08FkFSqeAHG+kT3HgER2JxM/FRCoeDTBG5hKaj4
	MlnQ2LH5LN0s5DBM1dvZkU7d9w7QT91t4RzJ8571STfWk72qnS+vG25dosPaP3YqgLOsA8
	vzPlf1s++3E1m7SlaFmtD6vDartMYvU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fzDHpbqIBXdBWPrEX6e4jd9D7S6Wp53dvbcajiiuilc=;
	b=EWis8/1C+2GAn7t5iyhGCaEGEcn9XCG9jVGs50pVi7mH7JwsOXEwJcv16OQJYxS4cwhnF4
	j/nnibnpW3JLBWvD+QJeJEo3gvSB6Nlhz2U5CitwKJFUV9nXbpxixUqun6gZTN06ZVEyhu
	zB92Ru2eRMexlyDoopcdHH3roudw/b4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-SjRoth4kPiCy3VYg4JJ8_Q-1; Fri,
 05 Jun 2026 12:15:29 -0400
X-MC-Unique: SjRoth4kPiCy3VYg4JJ8_Q-1
X-Mimecast-MFC-AGG-ID: SjRoth4kPiCy3VYg4JJ8_Q_1780676120
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A53991956050;
	Fri,  5 Jun 2026 16:15:19 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 52CF6180049F;
	Fri,  5 Jun 2026 16:15:01 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 05/14] mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Fri,  5 Jun 2026 10:14:12 -0600
Message-ID: <20260605161422.213817-6-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VS6G4WUQcmEVi8n8vtMKGbx592lpg23FBO4ztYa4hO4_1780676120
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E186180004
X-Stat-Signature: gqppsqy8g69prr7nsi3k88rjzjdba4fk
X-Rspam-User: 
X-HE-Tag: 1780676136-221284
X-HE-Meta: U2FsdGVkX18VYqJGIV/7ev0HadxoXB2IBPjFkjPr92YehVRCCCoSXYux2dN2njZASF3KBO7Ub6XQOB7vOQL3xOSDDWG0Xaz5B83bJvgIiwB0kbMH7/zTRE3VR5buDw8Ke6o9JgRyxBgNFdkGUQf3Koa6py1704iIBjamlOC++vOmwD0IBcV8PtQU5e3LjjtCcam/WQ+rBCyohgkBlq6yJ9PrNvXA44LmkEnKke5c7ldfpruT5XkOTYoIysAk3MMVyWb4La3WqExGkBYVP83/T60FvDjoJ3B8vMtsn9jY8aCQ7jiPi54BjxrGJmD3O9lqPRpTWXm8Bq5QO8XrsGMl817jtPLaxT3VhxQUPhiRoJC/3nxlwH3s97p/LU6wDcFRzfqzwoo6Jgv94Ee6zIZNN4Rzghj7dWcvejdZwvD1SUKpYMv0dJKPGp5o9pufvVlQ2gdpo7xuu4J1lOKUG96/Ig7osC/4BrMDIbqxrXfa7pN+78PYTmvxAdL0SgSZSSStVSYtxNyl9oHRce5deA3DAQrP3OFxHARAiBMLEIcQUs4JeKoEozExTfAPlc4sL5XV538gWFn/9CLUF2+77xFgIb+Q/pO4XcLp5xgnGS5TmuuK7JDTTqnW0+aX/tuc62Vl8r/dzqrONklU3BqoCtGiFlqpC3ok0SsHHbcpNXWZLjZ11bsbrWSrTqAnHrHXMQjVE5oQiRWiNLKBE48M6VDKDj5To0Owud6qD7roxQ8BynjEH0YUCnZqtX+RhsHD0lgR+Uk1+QyyYyXXppOqMX3iK4FSYKtSvIGTdOR5apYgkZwTl1NBWwIObiblNw3zU1LDzDbsej/Jn/ZjNkLDbEGJbNyRn8pOeiBnsPxDsREJZLZa1WhLLIrnaSDROZNP+myXwCwtMLvqwxXtvvJnrJeHZYuADsLtLtw2lo4Y21RCVD8A/jLN9hWSG1QXyYCY4AkH2yH2l9XS9/vj0Da8JmD
 ZVsvgHhK
 mG9PW4RMh97qF0uK5SMmVYzPBDtvb4W3IjU4qIGWWLcRWLWIL9v/B8v6aar865yubO1G/HenHp7DlnEc/UlE8g6XEvu5TeidyHKrH5uvZFFe9jHZWYzK55cx/3EZeClcJ0mgyRU+v0lbZYNgf9DMAtRqDxKCWUNQt1+wXs3MG+kK5NcBM8rpXbzLprVIRuyaAsba8eNcYePhWJCXXIjkfFISX0WL/7imEE6D57RWnip2gTguuPmpZxKn0+58vU5WxipNHWjMrRGuk1vB/kSKu0mxn2uIvBtdKib/ZKBy+Qciltn6F/0fTqhMVMpsw4N5fPFD9Y3fozFEj82nzar26V7J3pQW6aKls4ViJLgd60RaQa+iOfDFO6kNu+vCXPFM8r2l+A7Bkp1P2AxKX5sz9wIUOjAWZ04GIjaD/tsjktzmECUBRGlh4mjYPOAfKeMvGG7K4Rwoqu2lTNOPVZXTc/Dciz+3OJwZJ4VKqLDCiPlPFjhc=
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
may have already dropped the lock, and do not want to conditionally
check for this by passing through the lock_dropped variable.

No functional change is expected as one of the first things the
collapse_huge_page function does is drop this lock before allocating the
hugepage.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 474ee97c54ba..e4b2ca77ecf6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1222,6 +1222,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
+/*
+ * collapse_huge_page expects the mmap_lock to be unlocked before entering and
+ * will always return with the lock unlocked, to avoid holding the mmap_lock
+ * while allocating a THP, as that could trigger direct reclaim/compaction.
+ * Note that the VMA must be rechecked after grabbing the mmap_lock again.
+ */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		int referenced, int unmapped, struct collapse_control *cc)
 {
@@ -1237,14 +1243,6 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
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
@@ -1549,6 +1547,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


