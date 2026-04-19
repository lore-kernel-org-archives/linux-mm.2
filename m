Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F160EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1F36B0348; Sun, 19 Apr 2026 15:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879C76B034B; Sun, 19 Apr 2026 15:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7905B6B034C; Sun, 19 Apr 2026 15:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3F86B0348
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:01:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3675C160815
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:56 +0000 (UTC)
X-FDA: 84676225032.07.E287037
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FEDB1A000D
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PBu+P/6e";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625314; a=rsa-sha256;
	cv=none;
	b=zFjPB0xYy47yukTD7Vn/+1TNywIcfEuxv70UP8SRtppcpBc4P902MIGNXG6qtjk6gaJ9So
	WIQ4CTFXMVhEOcKhiJpWJbWYXWQxrAKUN/z/FaUW85PO8L+wPZQnoj6EEWesofwqw6zh0P
	mhokQrEd7536501s+30o3U4gxTYIczM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PBu+P/6e";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtPu1R73592OQl/hyf/icZ1+ryewqEPPOJyrb7kPdHM=;
	b=skxqMQezVmzPM/wVsYFUv477fVES4LeuQH0+C6CB5X7YdN9t99hfwoh9uGJ4347JAmQgox
	bNdTa2Tv2RQHgKNRZKCMdZjkp3Z9UUWRzD0/PP2YroQWUrH80C7XnYqNp20GZk99uxDvcJ
	lK6Ky8A0Csy8HFfta0PIQHXGj5R+yBE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dtPu1R73592OQl/hyf/icZ1+ryewqEPPOJyrb7kPdHM=;
	b=PBu+P/6exlA1INkjM9jSBUKk5by3/WtkAL5lYjMGW5IRIWqRS5+tSo76NimdUdJ5XXyYJK
	ITSZRcME6D396gQlfb9C/YpmLnDIiim839Iier//EP+46ULI28CldP+DN2b5/qyYR4F6z+
	Hmk4hQdteN6kzV+g/AKuLDMjzbxtk1M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-ymoYqepwP5KSqITbHGKDPg-1; Sun,
 19 Apr 2026 15:01:51 -0400
X-MC-Unique: ymoYqepwP5KSqITbHGKDPg-1
X-Mimecast-MFC-AGG-ID: ymoYqepwP5KSqITbHGKDPg_1776625306
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF3A8195608B;
	Sun, 19 Apr 2026 19:01:45 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AB5D195608E;
	Sun, 19 Apr 2026 19:01:30 +0000 (UTC)
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
Subject: [PATCH 7.2 v16 11/13] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Sun, 19 Apr 2026 12:57:48 -0600
Message-ID: <20260419185750.260784-12-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vMJpbhXJQymebt6uQT974_hC7aSMhH_NHgQtyqt4Xao_1776625306
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Stat-Signature: guxsgs7zon118m9y9ggueoooci9usrzw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FEDB1A000D
X-HE-Tag: 1776625314-394189
X-HE-Meta: U2FsdGVkX19PRL37pQBY1EKImEqovF1SI2fomNsanGW8GSyntrWFw4XwW7P0DYSpbtYpklHRfidakO5E6Xqi/jYX9mnAftjs6BgtXUUa31OLhtcCRiASovs025XaaueG7vcGwgNNM0dG5Hdeg0wL+7MUIJDIrw7oOhYDqKz/WrkvuYobFteQwEd2JvPmE5PcylO/Gv60T7N9X8z4QpwSkgWgiEv+Kdb9q8SpBSTkQY/WXtUvpH3KHEohw1jJDjmbtX1jnYJT7kG+qOKbRy6za3L0QBCR/2zQaQCBPlAyk3g2xDTeBaar4ZP6JGQOZn9K9UXbTL7Z7Hds4l64waLTYp/foZic2Vr3CShmK/HqFvz+vfVkG8i8HifYJ6DzvoUqMpxMBmQxdUFBT+mDSTYChZL9FdgfvU/NV61PvCEAZyIAmNr2zUpO4yyPuVrUm4L4INfuktOLeZJQjgZMPxulVcS5+Leg4lYTtYawov+gTykziAnZHd4glGXBaAcikiXPsuzcOa8i042DcHKGsBGS61nO3ZaBfI7fp+ymvEZi79nr7RD+KyQXdSPkhBikIE2x/PeWdFfbGHxBaUTAW8i5X0hw6lNnz5ZIYa/wgnpz3K+QvfnRIdgz7p7zqU4g9wnRFQxm0yAvt7s9GOL14Q7DZF0yy5UuDD+iLhd1Dc+sPM8g0jZnhFrvbq1IVQjRMF/q5FKL8+Iz9ofh0lEKLUxya7M7Krimf1nrTVu/YD1sXUr5koK7YOVhUUvmoMfSc4IJPjj2mpmYt/00FKFxn4gEJj7cBo772iCaVaarn+o0mbwGPzjd7QqLzURC1hXkACW8ZEmerYw7ZSYoJAk4qb1cObwEII7Yw6CP4W7+pVvf7RFlHMr2N/6Wpk1xuPHDfbkzwXceQ2Uu/O/kS2uJowrQLRaHf8I0m7sAtBZ21yTK4r8Cc3ch0IcjgP6m4O9GH/qrN3Wmoa6da7BxpPipLCI
 AIWqfMIz
 Xb0mAj8Lb/GjbybhtO2iAsp/QPLBkCdgFTUdyck+/oidLTHscQJLMBbzHc7Az/mNt7xvfDTUMKvpjj67iCkaySZDG5PcasgHE8zWEKuHNM5skIQcbXSnTe3V1umU0PJjCCuA2oGz+alYep4eT+GbDJZseGMUqXRawkuU8P+gqQjqwfLPZhpdqSLIWtAcqcVn2BUthR9JA+pzLffjMoi8DT6l6wcs9OFrKN/7Njjt/w6dwxqp8z8uQ2ZimrMfGowGAl50hKkZmIxgC+VNejPEDEby0lpAaoPdCsGolk7LQykRc9nfXpU7n5+ZyHU9hufyPMz8VosFjNUARo7W7VVXo9mHnQfZUERL0LfHxmQxiFMAWH+sLfCjSLQ7qOLLI5k66q1RPKHw6TB7d/fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 81ea7cbc54b2..13b05bbb08e7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1517,9 +1517,31 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases where lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_LRU:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			default:
+				return collapsed;
 			}
 		}
 
-- 
2.53.0


