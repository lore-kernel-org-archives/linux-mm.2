Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B20CCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF878E001D; Wed, 22 Oct 2025 14:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F5D8E0010; Wed, 22 Oct 2025 14:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47CE8E001D; Wed, 22 Oct 2025 14:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A343A8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 437AE88D7C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:23 +0000 (UTC)
X-FDA: 84026615526.29.E494F71
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8EB58C0014
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrzyTi6B;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+awKOlXZyNwNg3iwPKxrBfFIIAcNqXGCwKOh5pWhi7U=;
	b=kAgezOUE3zHM9+crkf130M2potSYaxcSAwf/4gsdbuuMDsNI+SyROqMAuw3Tk/gX4+1P1C
	VT1qJJPUurb5kPeazR7vJ/7UvnzhbBYXyBJHGp03h35zk/Ari5w0Ga5CKjWs43uR4Q4h+n
	ZVh0ylFXCl8tkJWVGmlBqableXLgt8o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrzyTi6B;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158421; a=rsa-sha256;
	cv=none;
	b=dCw2C5bsuVnj7A2ku4GvA+sLsPSizlBmZ5xnkIS4uJtr6ozRp/qun6f6CzHZCKAmWCdUS6
	SSZdBaS4fEsBaG8BtKuBouhkKlcPwSnSjIsmdIlwZQblqBHw0uvn9LeouES+zbyoGX9m60
	hxKfJj8XSzKdqgSoUFsAKTQEEiX70jM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+awKOlXZyNwNg3iwPKxrBfFIIAcNqXGCwKOh5pWhi7U=;
	b=RrzyTi6BrROWAFhyQEVtOXL1F4XbkX3NHhDAqN+lzJZcpmvDO9aVb69uuo/f3E9eTFdhpD
	EhuuQbKpb2kwaQejSQacTspacTDIaY6+Pa3s8jeoDzVTr0YDDkhbxb2hvvD4J7NypSzIi/
	yEJth6cRFvJpfw1fsJhk/4L2l4ru1DU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-W1wJH0wKOiOlLRE0GzOY0Q-1; Wed,
 22 Oct 2025 14:40:16 -0400
X-MC-Unique: W1wJH0wKOiOlLRE0GzOY0Q-1
X-Mimecast-MFC-AGG-ID: W1wJH0wKOiOlLRE0GzOY0Q_1761158411
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36C641800BC1;
	Wed, 22 Oct 2025 18:40:11 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB98119560A2;
	Wed, 22 Oct 2025 18:40:01 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
	pfalcato@suse.de
Subject: [PATCH v12 mm-new 11/15] khugepaged: introduce collapse_allowable_orders helper function
Date: Wed, 22 Oct 2025 12:37:13 -0600
Message-ID: <20251022183717.70829-12-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: wz19ayrdhiwq1y36fa1ofo3n7p8ihmkf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8EB58C0014
X-HE-Tag: 1761158421-477298
X-HE-Meta: U2FsdGVkX1/W267wLahMf1I8rTUwGAau0pzFuCeiP14Us7elA4i9WmIeyWxTiS1cCvVHq3MCQhHfnzAfoQzig1ML71Hqsckc7U4KCN5/BmWoNWm8cMAXy3bJVT6IwCpQrVlMt2EbFgLGJIT2KHAnNuYv4lsh4sb/kIPkl0ffO3PpPThq/utBFwUVjfCjI9Q2x/jDkTnrCBYAMjiJZUQogFKUznTPOQ6NxypbhaVEXgJsOPZrFavXbSoLVmlpALxh8aALJfKuaRA1/uv6gPT3QOMRtWJ0JH34hRbVV30ZNd8ycJgOYZXn37dJhnMhyRG8fb89hejZGOGqaVCcq5F3sCHC+n4jg7LOruwM27in3MeptG8z4TxpUyxNYbcVRAXCSa+kF6uqkJrWWP9y/JlHMPZpImrxEpwNI9wSug7DBYeBCMZPyyPEf95FQ3dP+Kq83aEEueswueE78b++aUN7mXRNQ/5rzXdpM+5Eqs6+DKWTiR8ApJKv7iqa6p9QiFl0tm5yQlW1EtI1IWjejD/SZdQjN1aJ9kvwRDk+bM07HJAiU0tA3/j1bqoH+Xb7Ep7o4knk8dEuVvf37/ZHWOvPkVEBbX9aqcGOEKd2GZh58qUVMyYz7PJyWJiWl6Z4shnh8zuNom2j6l4KtFdOSo+57s8zbE2SZi4FB+QSQJ/oRhgOWtJO9BKoM8WKlyTgeCAXOWh7pgJYz/h5ZyBGs0Grs3Fu8N8qW/b1JGd3jVC/gMIleGXObUxsR29QVTczUvJyN0ryq83Q1kXdYGoO3SdnWWSur5wJa6+06L7nO6kS1OCXA2JJ0BlJuKdo5cUTMSnM9vntmaU1CcgOy0Nth2CkAXgjV6GD0stP1Hnv+e0Arv8Im1IueKwZUWs3OUpVNzxEbad4XpiNyD82L2+jfSbIbOqsTnohkYmBwEyETp75k2biuz+1VGCHA8KrKcQQSy4b/irskT8tKOPOjSrcIP6
 3zlL3Jib
 wwRh2glWp6nEpSVlk4BL1Rkzp1AK6bW255JCdWIQQsEwam7cmrT65PBEdOyZO/G3J/wvlNolb4U9vrEkpWPw44k0zwkMvhkTa3uJ0A4nOlNMPM3VgE6XqqGLuHF3/fAInCmELJkWsLKEDwL/EVEuqgk5E3YrD5QQlNJfmDQ3E8xlYnOUZ6ENm4zPl7921aC7aQBwxlMMhEUjW2qzNwQ6N6iF6JCyZo6ga8Ai4dVQi+KM2YW7KvXUnRQ3eJh8KNyns/7VJAYs6vBu3WzV7cERKKkrvjKnMojHqAKgrerdhLwpFLdpufSPcNXyFzH/XqfowGpLiYE8fzzXhleSRuRIRHGUg//M5pfBBlplyD01jAoEAmxC7ixt+KFdJN8l4gs9ZasnlSv4TdRk5xzkwzMNKMoi/Hs5yxc664r5AQPA0OMYzCI7aYsyL5LENd+c4YFIO9qwbqGwqTBRCoShnP3hGtglKjiu2xwh6yoAB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add collapse_allowable_orders() to generalize THP order eligibility. The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse).

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0dbbe04c31fe..89a105124790 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -489,7 +489,16 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
 	max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
 
 	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
+}
+
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+			vm_flags_t vm_flags, bool is_khugepaged)
+{
+	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
 
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
 void khugepaged_enter_vma(struct vm_area_struct *vma,
@@ -497,7 +506,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, vm_flags, true))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2567,7 +2576,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, true)) {
 skip:
 			progress++;
 			continue;
@@ -2873,7 +2882,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, false))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-- 
2.51.0


