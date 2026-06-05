Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBD4CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39EB6B00A1; Fri,  5 Jun 2026 12:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAA86B00A2; Fri,  5 Jun 2026 12:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2826B00A3; Fri,  5 Jun 2026 12:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 961AE6B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:16:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69E8C1A01D0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:16 +0000 (UTC)
X-FDA: 84846361152.20.5966A81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 376BC10000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9JvD1P9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyZARYAQdS2v/9DKdV4yV9thBDI4Aut4joTjAdzEV0M=;
	b=ZBchGG9wTNPMzFtJ3+AHl0nUWWgD0CSXTZ6GpxHZXZMJOvvLHSOValHQifvCaMZXXJCCLb
	cbcqoW0/Z25d4oPVXqWNSC5Dzhd9itJ/egDlzLnRr9uVAu9x66JAadrbnrJiQvlNsIarkP
	5T8obTcQT6JLhOXFdooZl7zZk9WMHmc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9JvD1P9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676174;
	b=Hlz/b+nlPU/CVJJ90nwKE1tGSWOHq6FMt6OCbNVRRd0teFy1+aFhP8Xe7V0RSD9rp4TcDA
	0ZL8WcMrl6y3yKlMVG5BLNYoHtth8iLcP9GZzipLK1mFq6zF9UhmI9Lau0WdeSpaqFFfaZ
	Oo/rGfIQK7Px0z9Lwu2pLto5uQDhdVY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TyZARYAQdS2v/9DKdV4yV9thBDI4Aut4joTjAdzEV0M=;
	b=b9JvD1P9TvmfnQwezLSbePixLPkWIJqm5IZUWKRWhMQwAvvH8a9p6fSfi/cB3/P5rw1oko
	lhJLgeRSyNffHlRHxjnrdzrmlUrvB8Cy4R36G7oPKq/grh2n/fTTwWwKyDCUxX67haJwgB
	NU8ZXN4Fpws3EKYh69Dz/P8UXg+Mq8w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-Cl-FJL_QNSOx_RtBIPgE0Q-1; Fri,
 05 Jun 2026 12:16:07 -0400
X-MC-Unique: Cl-FJL_QNSOx_RtBIPgE0Q-1
X-Mimecast-MFC-AGG-ID: Cl-FJL_QNSOx_RtBIPgE0Q_1780676157
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FD35195608D;
	Fri,  5 Jun 2026 16:15:57 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11B64180049F;
	Fri,  5 Jun 2026 16:15:38 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 07/14] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Fri,  5 Jun 2026 10:14:14 -0600
Message-ID: <20260605161422.213817-8-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -GZa4fudABeuzyJcvkIHpoB73fgAoVd0zMuKwhscnFg_1780676157
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: y4s8dmaiam53m3xn439b8zdp57zx9mps
X-Rspamd-Queue-Id: 376BC10000C
X-HE-Tag: 1780676174-354278
X-HE-Meta: U2FsdGVkX19RJx6QIBiXnljLRNwbodvMDnqcPCQ6t0/RT7Ie2jvUUaqvJxvSZtwnQ31r+bPvJJYK0K2dGxQ1TRzWRZ4U24O+bQyyyjtQ0I8tPn45HWZMJXIqNP5hwIs/tGcg8XGY+MY6x3z8T6cVhunl6Maoa4wdA5Mu3lcuD49UDrvq2OVMCOIMv3L7N+F8qMR8ybCP5tsKHfFhuoyb9C4L9GMMF0d+lMIBSIENe7UU/TGCQa5fRJNodyzd9t+J+i98sqOtm4dgsV9cTydwWJQT1+VxAwVqNJnwpvZ7XzPmpjdT2eK47CLRChwSr4ATKVUQGxt9ERIzlckIPLUlnDpVqv014EZDVx/9rxkCcVshQtNEh/vYipCUo5eKiN7vXM2Vo7EzIkDjy9nuMhJ5AFtlc/RxzAxALpC9lrYpobOnE5qzr6tbbKCIIZp9bVGcW/V3CdjUSa9iShAp4uq3OKSK8dBi4jxJ2Mu5NirzXRfW87J+kKkvNHnkJCJ9EipeuHDzOo0gNSQEKCITR3V2M6B85Pu6d5uZHPtzGEOvR/kqvqzFOuBEuPVJYq4/2OQxtt2k2Ma1ORlFLDJxhz8YnpUGljecndn7qlYkBleJmsx2ZieNZd7OiBlD5CMXWFoKkNkRpuG63dPmKesxQ9wEiYL1cjngwH+5dF/TqUK31sGqxwGTdhUL3I4JF4/M4WX7X4wzFXT4NIu2JO2FvRtWjcvzhoZj0synfnTQ+H7F1tnFSF29iUvJpztxQXscb6egBU7U1c/bSjIHaE3IGlk0S7MmF8HZFEtESAvrSt8r5kK5jPB0hqfA9Tm4OH2Lnbh6IlnqNDgwwBqIUns6eK3wktgJL8vGs8Uz4XNfyLpkfedhAJse5WYK5A2LUhKJjGG+q+3OFaFQm7Db30yfQMxfPJVL6bG84NIcimcXEXMIp6tKjkL3y/Yqmkiwfsn+99Y7r8aSmiSTUzMesgNv7vh
 3gymgjE6
 xo9iNBatsItMv3QaCEGrS+TixSboqBGBKtl5eZUNC7AmUtTYHsEMqt3lP2kTQHObZHb2S0WNGn8xJcGbKKOX6gITAaf7V+HxUJ6z1wvebJw9n/DbEmM7Z5rCavn91i3Ebw+nWADuPxflebU9islr3SkFaOjhocEl4t/sa695vyvNDmHOLKZJMkqO/9BMQPOt+uSlWRYIh9mcB/kglgbQN4Sin30H/ay0oJQGwUll9g2oq5lW2lO5qNNG93jKB8TZUWR//NNg2pzNV2kXWQFwze2sIqEZJj0Gb6UyrVKRHdV5t+DH7pXspv2hMw160GCkHB8BVph5xvedm1B5aMJgF8n7WCzwgMFwkccd7I1JpTcIpCHMKfQQzKhKF6lGHKlXJCkq9nsS4nX5H0lOlNTUZAJZHK3LpNDRymZevtAYvp542E3BvYs/qRiuj0H268vZkJL2fmKTN4bhXHKgBaU3uY3XwG1IqD0dKDseteS/tb3T9PhzXGJOCCEWlqUT6TRqen0ieuiwl1IrD4cw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a folio of equal or smaller size,
possibly resulting in a partially mapped source folio, which is undesired.
Skip these cases until we have a way to check if its ok to collapse to a
smaller mTHP size (like in the case of a partially mapped folio). This
check is not done during the scan phase as the current collapse order is
unknown at that time.

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c2769d82a719..191e529c185c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -697,6 +697,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.54.0


