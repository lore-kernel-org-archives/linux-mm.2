Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C20CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BED6B00A1; Fri, 22 May 2026 11:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074266B00A2; Fri, 22 May 2026 11:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4CE6B00A3; Fri, 22 May 2026 11:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB6F46B00A1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:00:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F3341A0AA5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:21 +0000 (UTC)
X-FDA: 84795366642.08.1B60DC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BD65100022
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:00:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HsGX1MIE;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AytMvLoyg44Km4mhocUjtz04jW9nMxClvrZzXGubYQ8=;
	b=Q9raQgXdwKuE0Sf4WOuhiaOQTbKVIxIl949x7eXDHvKLYwcYYhtK5vMrSi+8j1Mjoa+cwF
	bbuG1vuEjcvWPc0IwL2G4ELakEyPKnjSUMTMYu9XDcdwvlAH0dScHdk0FrpafB4bplTinj
	kTrt+7J6TjFk6fqT1fS2EW+tyA9Ftfs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HsGX1MIE;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462019; a=rsa-sha256;
	cv=none;
	b=HJaaGD8aBBR8lOLGo5OFCJnRxPWE1oHdeo6u81diny5G6c29hFvm/uFgOFoysMZHxr02JZ
	bP7E2RalVk04wZns1HPrwnI7Q8hThwzA17sYrmGqw/DSKngxHFkBkzeqvvHARGuVWJaNKM
	J9hlz1oPVM8FL9S+nsYbBxXclI0rpYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AytMvLoyg44Km4mhocUjtz04jW9nMxClvrZzXGubYQ8=;
	b=HsGX1MIEhMQ2lolwEHKUnrBIoQEcVpDEeoXXw8em7ad94UzeXcyd3iEh7F4ZuafIacCO/C
	Y1BcUS14hpExWw7iRynpoTbZUm7zy1r9EnGvSqb3y6IOfuL35e99R8IsHnTnT4FV2yaRwu
	jpqU5XCQnHC5x2EJFHxMqEw5z0wqZII=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-zeJXZeYRMymsL0olokOnIg-1; Fri,
 22 May 2026 11:00:16 -0400
X-MC-Unique: zeJXZeYRMymsL0olokOnIg-1
X-Mimecast-MFC-AGG-ID: zeJXZeYRMymsL0olokOnIg_1779462011
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9250195608B;
	Fri, 22 May 2026 15:00:09 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B8CF91800576;
	Fri, 22 May 2026 14:59:47 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 01/14] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Fri, 22 May 2026 08:59:56 -0600
Message-ID: <20260522150009.121603-2-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sjxIk29YowLywrCbm1pDoAVp6wfM6kw8c-jiXm0QPy0_1779462011
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BD65100022
X-Stat-Signature: 7xmf4p1gf1hmos7i9mkezi3e53ct7hje
X-HE-Tag: 1779462019-749376
X-HE-Meta: U2FsdGVkX18LQ7HkFifP2Zbc34fSmrgV1FQUafH23/5HR03+8Q5Mb8Mn2PAjJUCeUMub6bN0HkFuLsqzy9iyg2+cjLE4EGAK/ukAIfIZuPvrvPcX98Y4uup61RWsoZQDoYwmpvfnoMSflboeRF8PilZnJqhpar81zqQaTYaKub/Dg7zexJoqrnDX2jVgvMW5HGdD+b23Y1CJNqXWznWdsKEYAgU0U0VhUPqbGTBkwP99HDXdRErWGgLMhECE2xha9tIGwWFhj1GGkYDLj3tqFle/0n29esFd2/02onmsH9OQ+7MoouRl/hWyGM+Pv++e7SQEmh8u30p550ADtlnTGtASHT5gOOD4XbjEO9lT5errpFUqk38bcv4cw6VPH2jdvbSvLwCxvG+UxE++Y36zwBrJfwTUs4mEmX/EHHPvrfh5yTvHxT9ELft0iT3JoACLvb8pkiLwQJHTgrpBoQYF0Tkq2EExlGYDRsJv36nHo03EwHwkYIf9sr89NLAIUPvoQLeV2/UhbAEDGBGlnwnXcyzPaA3OvWTebdok/nRV0cFnE/WQHxzYFohGMKLPaCAA8AjNgflxV70QsLDZQIWiBE6nn3Ew9Jqis/cYCbnr9/aL/bx9wmmBsj63vhjH/os1/K57Qr810A/cejk+xwrBfqL0f7x3rsEmUplt56wbt6USeho3/e0NwWzaK/Xbu6IU/aCOz5DL18HTcYEBbdO5tCnrEhgy+z7nnXQzJi/ZhGpHQp2XV8a3WqwxI4isP3Kz8EFqVTrJG0dL37kLqt7iywZ9CaDHGTzSmJVPcjFUFl3xwCqN7IzTEyuwrCZHxQFAWKecdIBKSx+zIrpXR/wFl6PNAhOOYuX9SWvbxrNDBp9cJ2OQy+6JRUmFqlBkcSevnFPNHwdesPaLQldQJ5kDRqaYksD218Amfl57NvLhsVHUso+r7awcXmnD+fFYUmv4iU/D5MNKeFfzyEvz3b1
 X7SB4gKm
 xfJ8EV2kKeiakrPQ5tdDPYCuO/hE2uZfNfF3br5azeXQPYomRkS7n6WV7BxLYuHCEjMK+8HMUNe3NvyurSM76Q2vTYJWCGpNvol6JJQ84wARHBm8mVxpZ/pJ7gNtF2w6LFhyrzjlqs4S2bMKZ945EJex05KEDMebPgNZ0ERnEQbKPIkJ49D7i1HyW9Ax40J4CNj5y8l2Yn4eSPvYLrsoGQ4ocFNJtT2ri/ANTVll8dJZAQC8cnEu3vc47BaIAwZvzfXCaE3zKT4kPhdftwHuvRUSZO16INgraVqeYM1d/jMih01jN5aeWBN06jkpYxpY7PsT9KYx88EbyxZMn37/dpFoYeBYsofVPTDfVeMcf07wRIM6lBf9m7Ww2SqX0F3NPo/GHAYA/+oumCfAl633mBgRRwUPDrb7tYEjk7hrgpjRUzQBcdJU/U2LSJ+YWQ9O4tAKsrmhq8Jjy+9AFswkhNjCHBxW2ljAuzCSV1qsZQSaWD4TWlHKK1NmS32V2320yQLru6KstBLNrgQJRtH286DJAQT7gNkdYxXhEEf6INgSKQPT7TCivLNu4NtkSqzbOFhGUXRj98dRYNZwZ+tJj7EASc9R5ZZcUc0ysIPteTV5RMC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

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
 mm/khugepaged.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..53e7e4be172d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -902,12 +902,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
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
@@ -920,15 +921,16 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/* Always check the PMD order to ensure its not shared by another VMA */
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
@@ -1121,7 +1123,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1155,7 +1158,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2857,8 +2861,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


