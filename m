Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D940CCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B3E8E000F; Thu, 11 Sep 2025 23:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412F38E0001; Thu, 11 Sep 2025 23:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329348E000F; Thu, 11 Sep 2025 23:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 214818E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF94E140660
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:37 +0000 (UTC)
X-FDA: 83879173434.05.FCB1969
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 547D680003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QG5VL8aD;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WkSS2x1APmP4WSa/KdkdNQb+giopwv0nFFtO61rokc=;
	b=BXWZBH8nj49bi3FR8xBOj9tNS/97eBLM1MAvyBLSN6yx1AxfamP2PanjQ6zhKIc8UYhdmm
	/NRzCDJE/AlWlJGyJDnhwByAUzUyTFokaziddNPC0b7FnnHWLBgUSROpP8NoOs4rCjtsz7
	+1i9ejI05tm+HaxA8Px+SczeiXTNgoA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QG5VL8aD;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647896; a=rsa-sha256;
	cv=none;
	b=riqIHf6sdmZy1/4s6+9DmzhE5m+ZSoDyD+dWDwMdnLAFrIuuNOShpgvI+HwAFCmdM4qCPW
	f5UwbCeX5XcL40zyADJEP2zqabHXFVgpCvR2HBWczC4t8kdmoouXIZ6NkppU9yY2H6ELC9
	T7I2BDHemeBljmVIkVqGtd2mAbETpa0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WkSS2x1APmP4WSa/KdkdNQb+giopwv0nFFtO61rokc=;
	b=QG5VL8aDvjXb+lWdXmuMxlu52CiUl9XUdOoCeKczsH4LZsV6laN/7Dfh06VBivPiINNFJS
	tjAu3mohmKaGPtmlbxkcN7ErXw1z5dYIXCZTAvbQMpUrtJHl6v+SIsyT4ZSvoVLS1L1Fui
	fZtl71QOnWXmlbKxDl6G7jvbz3wHRT4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-8MqFEGeOPS2NV-lcySUhFw-1; Thu,
 11 Sep 2025 23:31:32 -0400
X-MC-Unique: 8MqFEGeOPS2NV-lcySUhFw-1
X-Mimecast-MFC-AGG-ID: 8MqFEGeOPS2NV-lcySUhFw_1757647887
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C9471956086;
	Fri, 12 Sep 2025 03:31:27 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68CC81800451;
	Fri, 12 Sep 2025 03:31:18 +0000 (UTC)
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
Subject: [PATCH v11 13/15] khugepaged: avoid unnecessary mTHP collapse attempts
Date: Thu, 11 Sep 2025 21:28:08 -0600
Message-ID: <20250912032810.197475-14-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 547D680003
X-Stat-Signature: qnjozqd1w4apd1ykajsz4ewttnapbfrs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757647896-341555
X-HE-Meta: U2FsdGVkX1+oEcGPlpUPLlTt3PtFbBymwnu9JSVdbFRJtRkl1LFf+5sHsSzfvcT7IstKyGshaFVZy/ahFjph7Rp31peBRs7AFTmpj8AO/vFZ7c9HEXYqT/99hHXYWbQU/ueZxB2WQ9ulOG4TRzJ5AtVIT6eztoPpZ6iq4HyqFCoGx/8Ud+uh56xjBqWfBN50DWZdLWPxdLpVESvpLzFBULNAES5VTS6rpKpcQopSAA7RGWmMzdfmP8G0vu3e6e4pOfXLBKAQUXmW2k27fzeCNduBTlVgKYelCENb4885fY2D7nSZkSbqawG6DrfQwullPilayIBlyV7vrzECHJ1prN0qpwmZ4Obp/HGe+F902BQYf41Vo0E33IpCg2N54SMUf/sYdXFHJ1ypnV2Qt78Qdm18dAVE0wxHgJSmYPLU8CKz+rGkRbSFxbG8L7rL//0AlaQYuuMtrTLtQvV5pPcfL1YKffdZbXCO/M8xgt1ch+gPWdRdObY71MsKCwvYkMnbPrzAkAmYHI4e5ukrkoh+I5DDFnhK9WCuYQrefT3yLxOILzIE71uIKMSa0AfcFn2BTF1rWSE6y+s0jOfYk1w/HnZz/GPrrtlcVx89Lmsb1x1BeXmLcDa1n+1sxXAEookE17UoUdxvf/r7EPyLvShPti+yUIMEQ/Fk6D5dP00ZKNhFkTnRp3jxtow8qK4xnP+scAE1nQxv+r1b5ax6fI5wzKFbny6e8T9UJv3smdKxKE+O75/r3Xf8B+HNWEgoQ5CRfOveZZG9lG3edcgzk0AauA0AnLho+CvNmR4ZZUsDmRJS6NdJAyBHPyjlckHbhVEBuzw0HUlP27cUkz6Jdb/e4vaMU3zOAXVYAi/p5+zBRq+vBvo860ohvQ9Yrg67nmm8VP4I1op20q8AsPVIDtjV9hv6Jv1ejKv5IwaCLaofhktRbnD3lrMNdjJPlJUeVrZSHlqPoeYV39YnlZN5YNR
 9XUstEZL
 iDXDIZZh1tp/R64gis0GXxlXj3GJ+fXJJvDDweN/FN0f29M6O+P7kyzsFiVT3GwuIS3TfUf5ohtu/5qF2avSfFDY1IW4l83wNIp0qQubcdML4s1YBZcyiYuZFgseExF9I6lr7
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
index 8455a02dc3d6..ead07ccac351 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1435,10 +1435,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
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


