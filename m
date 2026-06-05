Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAB8CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4208E6B0088; Fri,  5 Jun 2026 12:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8236B008C; Fri,  5 Jun 2026 12:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E556B0093; Fri,  5 Jun 2026 12:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 240E26B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:14:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C17A7161424
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:13 +0000 (UTC)
X-FDA: 84846355986.06.05FD0D4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id A76E8180002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:14:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DINE+G/S";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W10LZnS31yePGPe4mtnmYpxQr94H9xJjZCEKApsJr5Q=;
	b=wKyL73DSwpBPieXaGa4WrWAz0aTi4Zmh/gFFVfPmTPmjI+ZnDkEyo2swfkcI2zUwa0H8II
	H43N4hXcEpHFWKWAN3ePFGRHEmrbzXZjV91RkP6HpTqCthb07A1m4NAXVMi6CycLEXw7/q
	39ow/hFue4fDvPDzsKAGHTZJCbez1o8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DINE+G/S";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676051;
	b=OIjskvCYDueUkWj2y8CT8n0KIubwrtiimKiXpJH9OqI2G5APm7tkdK6T56KYyql6936aje
	K+ILrzoc07Sl7sXiK2vgJy1cXnijkzjCPRwbZhiXvc+sGThcIVVf99BJMFCBLTcGVlWmcZ
	C8uqfQMGOJO6eEAB6RRfxWmOL+GngIU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W10LZnS31yePGPe4mtnmYpxQr94H9xJjZCEKApsJr5Q=;
	b=DINE+G/SBccQfjC8g/JYWHIvqvQaF+iSKeP+faKJttodxsnKIqvu19QhMHihDv4KDIAysj
	qrnKDPYy98DMNz27x64cqiPuci9TnRytlMoC7cRhRU5B1+X1SfFhQJMIgUBVP7EdnYa0tM
	tcjIqIWyi7UPNZOeo/vEvnkD+IWh484=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-jyt8I1IMMJuX-vM5bdXH5A-1; Fri,
 05 Jun 2026 12:14:09 -0400
X-MC-Unique: jyt8I1IMMJuX-vM5bdXH5A-1
X-Mimecast-MFC-AGG-ID: jyt8I1IMMJuX-vM5bdXH5A_1780676044
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E35A180048E;
	Fri,  5 Jun 2026 16:14:02 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B0531800351;
	Fri,  5 Jun 2026 16:13:42 +0000 (UTC)
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
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v19 01/14] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Fri,  5 Jun 2026 10:14:08 -0600
Message-ID: <20260605161422.213817-2-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9FB2fej9G3TPIYLrbsvtUn2OwjLOIHu6-SW13uHhC6o_1780676044
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bscn4oq78rent35myge53y6m6qczrfpm
X-Rspamd-Queue-Id: A76E8180002
X-HE-Tag: 1780676051-572161
X-HE-Meta: U2FsdGVkX1881yt3aAQbhwYmqIYlRIdKPEJOvgIJ5lYsG0vaW7v/K5bLdTxFe8AxBpxuz5FUICssIhLysOdVLjPqA3OqlFZXtsIEZk+cgCSLCDEqB9h2bMzg0xBJvPkB3JjtiVplR+UeRWycLzBh6hzn0XsQ9AXQXQ9zrXV9TxhMp5JGWMG2vGPxn6VgkTxvkpD58Z34sijJVdPAQkgFxJVo+TDxHfvgE3so929aubfvSW1dzV6dy3vCoynWe/AMvo0u4zCuIT+kUB0JMF//HwgLJq/TmZTmqlg4ZjnKY4vRFGwgiIyBmubP1YuK6FOug4KQDyI551c2MfTS9FCYVNlj/HlfR/CJmaYHsGlQAk4QRwL18ZMnKlHlcOmFP6YYVtPWfxLTAq84BkNYk+DBg4xn52pnoafaFph92KqKf4MS684fLSy1k54SDgo4CBbmFQV5gvTUfiG3GMroANKGG8FyY0Um7ZE4A7ykhpaqrvhyQ20SGqxJXVTr9GbzEiQQNBF3x3zBWomGBhoWEMEacAoyH5oHz+f8KVPQbrmDRG43Usw6wpLgdyN49fwZwqzx5/WZo6FszFIkEjSSmQzy0G5nA2/QFxxzZO6dhnPdRWHS4PJCfiYJ/T3jFVp9ju6/bkpy+P9TZLpFtLcwtn6kvux5Ycjpm8wmNAXE/MhsXKD8mmy1a+JTFQ+A0cDaitEhWDJft7H16tm3LX3yd5pDcng1AM75gv5izAfh9bBH+crsSS+bXCdiPTkfuCy6uoBdN5fKAYhcW3uaQn0J2t4585Cyq5Vxhq4FXOKdGVgso396cHMcYA7LDgp+mSf0lgRYHltN1591ko+rNZW6Bhmy+wAzNtXeeSEJDgjdWxc70ljtdE76ZxGmXqjwz71CXj+YNc+aheEqIdbQ8P7ZPqToGHdNJOPn5P2EYSpsGihjYWX678BKuPi9pehp4YuNH97JGYnc5Knq9QXDIjUyHcI
 JebbPAvs
 PnwfkC3/TSc9AB1YJLmsLqmsmfnG6jywPQ1rub47KU38Q81BCH+dFiWDWZsl+SqeDM+kY2fR+jv5obFO6q1ouAIGSK8F6cymTP9fG5L3TnWnPx0nBLKc5c1+i6zSl5dw+IpzwB2chJ7KfTpQctoxADrpkXu7wOMN+rb7qY1pywh19VKYkZVP3YKyArnAtns9/s2TFCk4PRO9B+pL5y0x5Wuw0g/qs4jYeEeMGV4qtrIVdzx5hdKh6ggmSG+N3Ai6s2TGVVbbRrxB7TbH2UH/1DfJzl/DlR9QYnK7e/EiAzbea8ZkMoy9Xbc5no9XR7Dd04MwmSJkevDGNNWNRD+hSEGMvetn/ItYLv6QMhEu1mlvrBdWdqXS9GFWsKBI2drV9PI6ifX6pnrqwTWVWi+7GAv5Vukb7HzRbZ8ZINxXa/VoMb8fXqEvWt+YOQFYtykyANTFXcb1qd8cRluMl2g/8GQr71gOJitxR8olN92JvmVgIr7kvr3qsxgD3KaUpjrw/3yAUpx4vib/++YxVannkkUcnhSqyFGyRHhTPGauK8CsTAdUPzrv3oEISPtXimDmTaIuUMhM2eIiXM+jG7fDa5VP79gv+nL5mNrkv0zOi6PkLHuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

We cannot collapse VMA regions that do not span the full PMD. This is due
to the potential of the PMD being shared by another VMA which leaves us
vulnerable to race conditions if neighboring VMAs are resized. Always
check the PMD order here to ensure its not shared by another VMA. We'd
need to lock all VMAs in the PMD range to support this which may lead to
increased lock contention and code complexity.

No functional change in this patch. Also correct a comment about the
functionality of the revalidation and fix a double space issues.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a4b97ec8ce56..b3910042bbf7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -905,12 +905,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -923,15 +924,22 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/*
+	 * We cannot collapse VMA regions that do not span the full PMD. This is
+	 * due to the potential of the PMD being shared by another VMA leaving
+	 * us vulnerable to a race condition. Always check the PMD order here to
+	 * ensure its not shared by another VMA. We'd need to lock all VMAs in
+	 * the PMD range to support this.
+	 */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
 	 * remapped to file after khugepaged reaquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_order may return true for qualified file
+	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1124,7 +1132,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1158,7 +1167,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2861,8 +2871,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_unlocked = false;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
-			if (result  != SCAN_SUCCEED) {
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
 			}
-- 
2.54.0


