Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00907CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F148E0048; Tue, 19 Aug 2025 09:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916808E0007; Tue, 19 Aug 2025 09:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805B38E0048; Tue, 19 Aug 2025 09:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9558E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:45:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8B07C06F8
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:53 +0000 (UTC)
X-FDA: 83793630186.28.4F3C960
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20280180011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:45:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NyKVvVza;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENywRgeFkaGbdbIXNdDIup+iQujNfOziwpxb6S+KNKI=;
	b=oP0TpcjPqYZ//1545NWsq1THHWejJsLHXbuZeJVHj/wjE0mObJHyWjEjRAuKv7HVnaag8b
	IfGZU2qj453TrUwfphk/X54BMWeoVUrFrQcvp282tyvgDbAiTSiqEmRUz8gfrTTHLKxOTH
	1wdWle4daRe4ygq1O9uuzHVEum5jPno=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NyKVvVza;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611152; a=rsa-sha256;
	cv=none;
	b=yCmzaoKOnDVqqAwpQNQn+UFZX0MbN3m4OhP8lygc6IIwlM/yOBb7OVRNHrOr8aV0lfh3qZ
	gsrYxqDvpmBa2xnYbJp0pL1YABss7Qp/e4tkh9OEMvGg+V8PZh8jkBAdc/JNz6c/ZClDZS
	lbCtFkldK4WLvelywXB1pxA8yh997+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ENywRgeFkaGbdbIXNdDIup+iQujNfOziwpxb6S+KNKI=;
	b=NyKVvVza9fkiXUKAPVVA7Jtp9IIXniR3ZVb5K3BuGQZKK3lNvWg+nMx2xXVdr2nvDiOYJ/
	AupMYQcAMH+HlDl+KOUgnE3baxxKKJnW+qnM/BrGaethssxIaylB3AULf7lSTqLPkbn01h
	TockI+zZE12szMHEFe7CecwviiYh6cg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-PodVLyjuPvO85QIsdcVHrg-1; Tue,
 19 Aug 2025 09:45:49 -0400
X-MC-Unique: PodVLyjuPvO85QIsdcVHrg-1
X-Mimecast-MFC-AGG-ID: PodVLyjuPvO85QIsdcVHrg_1755611145
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 044EC19775E2;
	Tue, 19 Aug 2025 13:45:45 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4934119560AB;
	Tue, 19 Aug 2025 13:45:26 +0000 (UTC)
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
	hughd@google.com
Subject: [PATCH v10 09/13] khugepaged: enable collapsing mTHPs even when PMD THPs are disabled
Date: Tue, 19 Aug 2025 07:42:01 -0600
Message-ID: <20250819134205.622806-10-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20280180011
X-Stat-Signature: g9dprkm7j6tfag7c35zkhtgqeydc4wjr
X-Rspam-User: 
X-HE-Tag: 1755611151-595457
X-HE-Meta: U2FsdGVkX188SQcxsARtynKYzV/FV3YGIHvXEQTg/74GeNwV4LVuq8dXtJImk9KiNxzaQNtC+ZQRgEiXo/s41x/trvxTC3pJ3GewYdWnxnwJp8D+80GScfobObHgJu2X3zs/8e++KSnD9JVyvQeBUfP3pnO9hXvNPSytnjzq0If3cm9VIB4+efJ8H9VTAKkppOl1uclWGyao8P0jXOg8bIoyKc5q0GmkdkiGKxFsONp63gscvuwxRiwEuVs0OGrD48xsiBZji1tT882QyiujFclk3u+AS0stK6kZ15qqArHw19mJV9ycFAIxWQSiEp/sEeea4aSV3tIFTTRDV+EaGTAxIbbffBB5vWjjTRdN8IsjqkNzldngLPAjHblLqk1R6LA82n9wjSilWHaAUqer0h3ZMohZ71yItA9eSDx0DGPhYVuqLS7PPC/tA3aFp6HI7rs/2lI+/7KR4naE3/4FDazGsVbEnTf5fJRiv6znlEKnByHxZtOG5orHF8sORHJKTTgYISyGTlwN1+M6qWui8IY9IIPqaavSzFEW8000HPh4ijA+hZDU/i7oisYQ6QekX00kXXXGsBY3epdXX0xO3kiWRq0An4gvFHte+BT6k2a+ZDE77+sEf+37DRUxHmYD2V32Cb4mDBHoAX4N3ervOZ5w8cHkf6CNXO3+oKTNS6mYCc++7OdCguNPAIg8l2Cz64z+/U6yBX/461NgxSc2yvUDxBin0Gln6ez/XGc91uakKrwZuKDJJBjAmtb7W+S9utCIdbqwINi4eXOvvKj8LVJOIJDulBvQG/PMqPNDFop+wyt3JiPv18igr1TsQOw06BpD7eLg5574kZQtb94bKHXuyylobZXnvwDfwBhbokXAVTQogwiT/YVzba2CghmNjf55ej7SaZr+dmVb39A5HBwrqEvDJxQuW7UGoufpGIG46swIFU43NAVNDKbwv40mKt47rG9Nhy1LbrRcziq
 zEyczoHS
 avzE2a5Jpsq5ogYephTTr5kO5p/l/KHy2s44nVqeF6BAbppDXzk8npXni3EUcyUzQajZJNLdFAPMcw9FxOp3s2YdYHArZ/fzZdCn4T24lAd6pGtaPPPNOgd344iwSnHM6T3fCIl5Hx5wrLj6ZFiWemcidBZ6wrQxoeU+1z3solh+4oJSKdG5jVnmWQuOotw3UK9ydG6crAe1uRsc9xTOdXo+Lv810qnp2GGvzwGmQ4eTZ4oFeO+cRVxczSmS55lTJk4ZH5zwzGGl6hVzv/8Q49RviZOVlCeYBJw9KcQN6oJnRORApJidOtN9kWzC4TSALS/+39glufz1Fp6gWWWF4DVa0YDtvvCKvDGHdWCXWBbAGmo8TMtbaOmpAGKLdP4EqfmKRw0j6lbIsaM12oiZywqDW9mq4sDIdS12NqG8iolDey9o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baolin Wang <baolin.wang@linux.alibaba.com>

We have now allowed mTHP collapse, but thp_vma_allowable_order() still only
checks if the PMD-sized mTHP is allowed to collapse. This prevents scanning
and collapsing of 64K mTHP when only 64K mTHP is enabled. Thus, we should
modify the checks to allow all large orders of anonymous mTHP.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d9b5100bea1..2cadd07341de 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -491,7 +491,11 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		unsigned long orders = vma_is_anonymous(vma) ?
+					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
+
+		if (thp_vma_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED,
+					    orders))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2671,6 +2675,8 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
+		unsigned long orders = vma_is_anonymous(vma) ?
+					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
 		unsigned long hstart, hend;
 
 		cond_resched();
@@ -2678,7 +2684,8 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_orders(vma, vma->vm_flags,
+			TVA_KHUGEPAGED, orders)) {
 skip:
 			progress++;
 			continue;
-- 
2.50.1


