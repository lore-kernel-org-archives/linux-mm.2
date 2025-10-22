Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82536CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB048E001F; Wed, 22 Oct 2025 14:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AF58E0010; Wed, 22 Oct 2025 14:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32E28E001F; Wed, 22 Oct 2025 14:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8648E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A6E7C0912
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:42 +0000 (UTC)
X-FDA: 84026616324.13.ED03212
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DE87C0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3SqrYvR;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158440; a=rsa-sha256;
	cv=none;
	b=ctGR2wiLcp4Qu/ZluziomUMQAq4XXcaBDwho1LmiBtCondeA3O/93GE0tW2nPYF0bVZmdH
	TGmkmkRHNQEleCiCfkI/YEsgkgE2d+HlPE54Lp9RBEsdTm3kGwnAAd6iTmsaJkcst4PR1i
	edCKCHVniMYUqTh9w79fSEZpx6KuG9M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3SqrYvR;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jXNuiQ5bHnX5LcOt47Wp1opTjuPzrwwutPcN/KCqFQ=;
	b=tEbDVT/+AYjoFOeGtei6F+oTH5bAEfMSuKV7A2YXotQuOBwmpRd+uUNS5ktggKpR2Vw2Hh
	eme/Q6Ce6cKN6RlDYOC8iG//gejAHMEHVLSyLuAXbC01OE91ZmAyyzOIGBM0zquzzDtP4y
	KhdAowvZrgaz36jcLJ/ZfAElX28MPJc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jXNuiQ5bHnX5LcOt47Wp1opTjuPzrwwutPcN/KCqFQ=;
	b=C3SqrYvRtl2QnLR/+4sldXQD5rg1eMXwA0zXWz1OtjfUBewMlP2bY4hAWaibu/0Kav1Zk+
	hoDLJBenB5a8HlOj+Bfh2TjCFqlONdXmTPHxFGNrLIayO04QbA2453PSsSxxyUmvVkFUyr
	nGIlqw3MRcdcVOQOobZS93VyI9QxudU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-IY3uYX_EMg2HzlP-YAxfIw-1; Wed,
 22 Oct 2025 14:40:35 -0400
X-MC-Unique: IY3uYX_EMg2HzlP-YAxfIw-1
X-Mimecast-MFC-AGG-ID: IY3uYX_EMg2HzlP-YAxfIw_1761158430
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A54B819560A7;
	Wed, 22 Oct 2025 18:40:30 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79C9F19560B4;
	Wed, 22 Oct 2025 18:40:21 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP collapse attempts
Date: Wed, 22 Oct 2025 12:37:15 -0600
Message-ID: <20251022183717.70829-14-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Stat-Signature: wrn63ig7yd5mxyr6hkzbdac3d5wcw5us
X-Rspamd-Queue-Id: 7DE87C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761158440-251344
X-HE-Meta: U2FsdGVkX19i7B3yjc7lfpqpelbZKQp7BrednSreSvTZIBuwE3e+XL7NnHUB9ogR7nc6H28h/KJz7SMbkeSE12DPlCUQ7R9uK9a5P7nHqPvwneaZ3bq0nddJsi8g2G4Ud8UlX3cUJX0Nm8i4N1f1pMFEe/96A+DqxHETuxJNrkQI5Sb3zwTWCnR/kEnkL0NGrtF7cZrAOiF2EcLkMbgdifP2+vH7GE01a85cmdL7Z8NAVlkkoA+ZakySmDWa/aoKS+CZCpnm2u4Btnx/v7KU8UZjtVwsuKpWtHjDo22WIEnbIELRuoN6l+m13riA+2R4+sO0NM52mfSni4LUVh0Rk7PBM1451bpOvnZkIIRx5mmK02juvZx4kLKzUajG7BP8MJul9TOxAw8zQZ21qdQYyVB6TvXJxNqWMLeUiYtqov37h1/DOov3eWIS37vtnPCNEq+c5dY+o8IBvJal3EV1xqB4kj2vxUjjQYILyyeUXLUbPliit+2nt6jxng1Zo1XtQCv34YD/Ma70z1QlL2hFS5QmdFPqc6Szwx7UiNIPODCRueTtf/GBTmaPUK1+isNSgF9iQwnT2sym/rUwmzTF3El/bvKW4JrPlCiuQqtBcMXfJwxKpvT4aLZE9SJ7KZHFCpE4IrGpJAlU58ubzMI63T57+98lJmGgEDwz2URtlKs6QquWPMYg+1swxklod6vnlkEZL/qQnx6DPf87vsbm3RMR7kg5P+uVvzG1EqU2XR30uweB2utgZo35YXmOpITxifzif2i2qx191+/oaNTD9+v+JWbrfNYZDuES+hcFRYdJlHio4wQdKTKf4IpuyZlFY0G6raRv0ufzFa+ornplL6jxnrxm8lflKrxE93QRCklR2zmK2fyOZLpv7kDeoPbV5ZtdHoNQT3+aer/xd7mTKmkkqhdF9S2B7J5yFPCoEY2GaU6o60p5LQuNGh46ot27xr8bJASYtHJSlQx8IaO
 0v4iD8M7
 GaqxZN4ZAkfJALgz0+r93UHxY9xzD8U3BEcSzF8jqj1kDTSJl9Sh7x78LK2MYDHkqXuzOwZjB47P6RFzTOuiYbUSNf1PQ0apIMgHqcngJ8ymswMeStsB0vQvLQelyE6sSby/2gqLt6UBeMY7nsOio/AvaxzYmlHx5eq3StsWQAvf4vpenYRVf3Y4SzkCE1Qq4nH9+XwpC+G/hFiSuPjPmJDipdCQbD2/tkAGTxPFxozisUZDCfhmM6AeY7s/Y2iNsYdrVOyubVthN6NmsIPlaGkL/EPKqZbvSytpDE4/4hn753+xhlnKRdO2HoHyopBR7KTKlZJn4Kug4FEgr71aDY1vrVLRow6E+f1DyqImUHCvobRkQupmgl4ObLHqxafSu7v4mwF+EL5YErFsRuwbnfAIXTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e2319bfd0065..54f5c7888e46 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
 			ret = collapse_huge_page(mm, address, referenced,
 						 unmapped, cc, mmap_locked,
 						 order, offset);
-			if (ret == SCAN_SUCCEED) {
+
+			/*
+			 * Analyze failure reason to determine next action:
+			 * - goto next_order: try smaller orders in same region
+			 * - continue: try other regions at same order
+			 * - break: stop all attempts (system-wide failure)
+			 */
+			switch (ret) {
+			/* Cases were we should continue to the next region */
+			case SCAN_SUCCEED:
 				collapsed += 1UL << order;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases were lower orders might still succeed */
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
+			/* All other cases should stop collapse attempts */
+			default:
+				break;
 			}
+			break;
 		}
 
 next_order:
-- 
2.51.0


