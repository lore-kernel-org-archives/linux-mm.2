Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94476CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E336B00A9; Fri, 22 May 2026 11:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076686B00AB; Fri, 22 May 2026 11:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE006B00AC; Fri, 22 May 2026 11:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC6BE6B00A9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:01:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABDB2A088B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:01:41 +0000 (UTC)
X-FDA: 84795370002.21.32A23E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A8C9120017
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:01:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aYktqyjO;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pia5vAhdnA8k2uXezPgUQnHnDwGPV3uT2rtXkjH/NFU=;
	b=gXDJDjkPPQE0WSONXubwkDCtYJaffHqlDJrinaSSBBWgyhg4EzAtD/rl3UPDprelz82ZpW
	a/cSaTblFEd5+ym30QDWPDdI7VQ1f3G1x8zhpuVVuZtNL+WPUHqxJ6j9jfH/ELcKmQoRtP
	n9hRkA1uTHxNksNnuxDjZkW05zMhfbs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aYktqyjO;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462099; a=rsa-sha256;
	cv=none;
	b=Y4px8KL2b03bcCbTbMIpz1qzwyR+NP/h4uh0tAXX4FJ33A+sD/NbvL3V/ALOelderXbAVe
	EqMBb+DL1xiXJFsM/Q2vTxhO6bx1VSz+ULAlm8Jt95rfs3gCQRkCsq3Lf7S85deJ/iJH4L
	ivRV1jLEl+VIYjUbGli0wyJwEdSiWv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pia5vAhdnA8k2uXezPgUQnHnDwGPV3uT2rtXkjH/NFU=;
	b=aYktqyjOGx6alOy5ft8hwiiU3ThrKhaQ2lT78qZkHP+ozSP8ZvLQzGxbLH0cuF7O8GGHIV
	jh1f2cIx0e2Quu0s6kVuNiIqqXwB0P+pQX2JtrZKUyC16tYuQxCmEsv/lmrs5PwqoomdgD
	NOlzZ2mr6oIFyUoff7pmsBpIe9elqpA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-6BvBKP19Oo6jkKUrsBXb7Q-1; Fri,
 22 May 2026 11:01:37 -0400
X-MC-Unique: 6BvBKP19Oo6jkKUrsBXb7Q-1
X-Mimecast-MFC-AGG-ID: 6BvBKP19Oo6jkKUrsBXb7Q_1779462091
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC63B18005B5;
	Fri, 22 May 2026 15:01:30 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC4971800576;
	Fri, 22 May 2026 15:01:10 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 05/14] mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Fri, 22 May 2026 09:00:00 -0600
Message-ID: <20260522150009.121603-6-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bXacKr3W1C55bYHYyLd15InNGeHwVACkkJZDR6XdGS4_1779462091
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A8C9120017
X-Rspam-User: 
X-Stat-Signature: oouudxiu4xty4179j3zkbgq5bppx7tgr
X-HE-Tag: 1779462099-989074
X-HE-Meta: U2FsdGVkX1+O8qW46ip86CP8yHlAExxR7ki48w8pL0xirAJQNPaLTgVp7186WVjktdCf9z5Nhl9Ss43WNI2QxX6WSEVXg5+DgFtY7dvAp83lpNcLSTc+VaAmjJdu0z6JR78KaXgA30+4T5mxUbmNrMhW+Pt67qkivNnrQX41xS0l0q0lYNclwvEBx7IUKkH6NW9rD+kk2MiiRb+wct0iPj8WqQs9F05Dx0P45vlIj5fTN1Ak/Pd0PJGSRBERrBulUiOMDgEdtZmdrIoqpfAqe66Z7SiGybeT3i0SeOGqQ5N8oKdHwn/nXwr+ul40/ZM3G5qoep4LTRWvvCInPlqSvKZ/gTnQt/AYzh3iFCCbY5N5hO76Dkbuv5dcQ/T+qFTd1zaenkrfzq2G+ZGcRUmBR16yLhl+G0Bct0fwkuYEB/5LJsNJTQ+RjdEcSBURNcAJ6CYf378uSQAvtcBWFJH8WAmBcHwDCHUDNwtLsvF4kcpjA/mWz7qkBM5oKFnZU3snDW9fC4efIR3tHl/FcFS8nvuAph4664qR1bCFsx22W4BhmoxkfV/6i05GQb9OCfAy8kUESuSQY8hNGWXBBVGTtn53OczB5+L01w/e6fjx4zFzzqxOqfcHb7uVh2XpEsk5n57+OLuyGBrB43S/Eyc9pMgwDFhp6omIDig3Vw2kaVCWzvjiAz8JHkIAZVK6FKYKIoq9DHkDkFZAn0pvMCQiPDUCbRjNBnDAL7KgB91PTbbNY4qd7/k091BLE2FpieBlSah4Cfs7FHLYjqH9neBDfdDYblEfkSKFHeAH6O5j4pK/Loabi/IITdu06qKDLdeHbKItBWPRFMifCnXZcBjUlVoN73OlSJ48jKvDcyUirK2gcLvgPHs3SuTYUB8KnRmpNjKYKAXl76lUkmjqfiixBulK4oqiucKDdOIVyi9un6CID+Kfq6S6O5d3pa+XwmNv85Dxfz3SRsxQ4r7mBmL
 XqielORA
 F1p5EoQ58y4YAHKx1ObOjfLv55VC9K6k8qJ66/qpimTq+zVxJBwvgL7fF3sTeR4NeizfYvrmjGPMU7kroAxuKVJo7rWsYCxsQD9EPiCaROXxpBilnOSSOl852DDIbKM3Nl/+RNtFKbZqM0GUw4M9+Eb37fbR4UJnUbKp1H456CYssCicRAOPy5ZZDIQx1t81HU7foVyEfeqWPuuZxQu8Ral6DLov5WfbTvYiFxPAp9ydqJwpH7RhTC4HghVqUvGg+1WQNExhdnbS4ZnkTjzVeLiJ8bITw6ad63W+Nd9szt9QjO+X1KKZEHiqBfAv2W69P8AC8SaGNelF+ShQso6T9hFRXTbDclIKHMhKTKIBsDn1WTVg2PR4h891AsplEpPBc3wowdjesE+QZkGVRIdWz+mkpg8NfTT+K+rKYwI7oJZeyTd9nwIMQbAKGpwxNAqzfKU/SjZwbp5pey8QrXB4D4mAAxOJn55Py4sFa
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e98ba5b15163..fab35d318641 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1208,6 +1208,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
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
@@ -1223,14 +1229,6 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
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
@@ -1535,6 +1533,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


