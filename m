Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8555ACD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEDF6B00BE; Thu,  7 May 2026 18:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6F36B00C0; Thu,  7 May 2026 18:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC246B00C1; Thu,  7 May 2026 18:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7DFA6B00BE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A3C7A0640
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:56 +0000 (UTC)
X-FDA: 84742049952.12.63DF109
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B7F5C0004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKvHNyVI;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cHnxMdJPiaftqs6T9PdnHyPobnKwxYX/QlPeFWMLsg=;
	b=o2bMXD1c2d0EH6DyGpSkDdGsOaIND0+T9fSkscRuaNR3Jwjv00YOnx5x9tkYz4SJB6f2jL
	r65yK7t6TFNNGzIR03nK7xP+Es7rSBAzc33+kI5G9orx/NGQOsQEyT+429zU34J5jsYnWd
	pj8QMlj2m+mLNIGiYzRBdqHvtG3ZQug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKvHNyVI;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192574; a=rsa-sha256;
	cv=none;
	b=BN1HvedAV235UAS4CEHpI+i1ui9yfxUevYIXtdswW5njvsEWQBI5RFBw5DxN9b2XWuLHR4
	FOIW5VHXQ9YkOjWHv2f3fIrz5I7axmU1trIdkeXUiFAjwbi3l38vtlK+u33Gy57S9fIaG5
	ecQcpMTrJvxwNw18GHlMkrlDhFZmHes=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0cHnxMdJPiaftqs6T9PdnHyPobnKwxYX/QlPeFWMLsg=;
	b=EKvHNyVIKhaEFPPt6yl9oUkhkALBpIkXriAyZTnVRgrcXguc4M0AoFtslUkocmTEJbBXb3
	FuS3FurujbgFzQrNeNtlb96eFltQeBrFbVoQMmiT3TRUtN2P4Jb4+CIoXSsgdmu+K2ailR
	t2M2rK2PmzA5oB8QvOuFTiEvxO21DtM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-kzCjvZlBMbOR4M9UhnI0FQ-1; Thu, 07 May 2026 18:22:52 -0400
X-MC-Unique: kzCjvZlBMbOR4M9UhnI0FQ-1
X-Mimecast-MFC-AGG-ID: kzCjvZlBMbOR4M9UhnI0FQ_1778192571
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d035e8593so7762065e9.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192571; x=1778797371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cHnxMdJPiaftqs6T9PdnHyPobnKwxYX/QlPeFWMLsg=;
        b=dD2AR5AZ/tZvQRUsfFq2iQt06YZ/eOsiYwIZhf4mR2GPmsQSyu/oqDnvxxR3PChRq3
         ljPxY2zgrrw9NarKE/IFTkW/dXtHvfNXSQoyTXU99FrQSsLLxQ8AYhXoPGGGHI4a7rHV
         K18VpGR/S4GTtkkzYv4iMC9VV1XFLkCp/A/PPfvtzUDfw46eqZalTbpDPuoVsNoBmrmN
         OPlEQHZuYT7icJrHynjWDIoi+bVyJnQTJOOjFTJGTc1x2WPAmR3JcUPtTOaTYMfyO1M4
         3b4fggPe2Qp4exLvrs2OdUseJEX0mkmCGJs1chKrC8W6uUTm2TkqxFCOz+unzECEfVqk
         J2JQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Ir9CtW3Siu0yAB+ZQptip2Y0cHtv9xIoPhENx4kq24ci6DLcSECEG60ftU5co2xXtJLTilbZyoA==@kvack.org
X-Gm-Message-State: AOJu0YwQXUfK3xmfLOY6V0NbO826zZPZGZnVvTmA0U1eZiFYAyMADWVP
	KNyrA7ZKxwM6TnTAoqUKjCma/57FjmXVeciwbwXVLUA+nFA3m2fyjLgxd11FvWFA3lbK6K4ZWEZ
	ZwGj4sXJsY1eTRiYu9Ce6PO84h63VFYiuR2jGhvy2H5FnAu4glqax
X-Gm-Gg: AeBDieu09W5fDQDTO2kvyET82BtnKRRxjTTOudz34RK22JR06Evv98vQi3P2b+/ygA2
	ORQxvR8/wtmzmL9kjtSG3m8TVmqBqrGy8TUmJAZwPG0fXAAW3kdX4LYh4zIb11wAMl96QrXkZBR
	tsAQivRbKvpZVtIed+h3rW2T9p4tJ+voW/3gQq0qzXxNqGWuWQ7Xspe1D+M0JD/1WAq5CZZMNVL
	owHjoUWU0DJzeaLRHtqPnxXCCpf3f2D1h402LSeCTqUY8u4W7QaR8mTbTIRkDHi1OgQGPWq40fZ
	CRUbMNm1GHvfwi0DoKWfRqTM3wvefwu8p0LJGptRSLlHgLUwcI6wQv2f65+suMCgF+uzMX3zRI6
	jEPxY6gG2X5IVkF2n0mmWV+KWES/U4x6DvpvixWxh
X-Received: by 2002:a05:600c:45d3:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48e6767dd6bmr1897775e9.7.1778192570935;
        Thu, 07 May 2026 15:22:50 -0700 (PDT)
X-Received: by 2002:a05:600c:45d3:b0:48a:563c:c8d6 with SMTP id 5b1f17b1804b1-48e6767dd6bmr1897445e9.7.1778192570328;
        Thu, 07 May 2026 15:22:50 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45416b5c300sm2083644f8f.18.2026.05.07.15.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:49 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:48 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: [PATCH v5 07/28] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <6d63fef8150c92fcffde0742877fe18ccc3da59a.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZUqebdGKMBu_cY_EFCblsbaMEs1x9WwWbv-67XEYJrg_1778192571
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B7F5C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: a9drcrgcak9smtja4fjp85qr5z7f4ebf
X-HE-Tag: 1778192574-786701
X-HE-Meta: U2FsdGVkX18APTHK3LhJwv0fl0o8Xf5q4ZflO/Nwaaqutv5bzIoNSQ6oPo7QM9YeJqfhEKiN7dyt8FScMW3hFml5at9MXhvXj1oNF/hArBnTL4o0KSi61Y5xbVn7/E1ocDR1KJZOTBZTNts9FyjEHWXuZ+gS+0HIh2D0BKwQyccAXxdTwk7fAWmxon9+Gp6/bCNcv16rc04WqBNPE9/jo7/2JLjnizdfPUvIalfKsk6qYRSKZKbJDM8mgKI38UjOrcequr0Ff6otPwUEiKPDAboNfbLp+Hq6eNi5kXGBHBWLA2MEyJxrLrgNetiaGqilZWiv8Xly8uZQ0Fq0VEBy3834zgnZSb6jn23juvaWQcRZab1hSRV+r9fVZhRQC1weVwoyMKzlGMjZIHxbki1TYou115G9xANRh74sRt6mQkB2GkYrg9n30cbihlGHDsfZuhwowDW+PXpGNnJco2ndwAmINPPktm3W1looqE4MXDeR8XWC4ESRlpTcTppcGmvDObODnKOZL4qoF17XU1WTrzMn9Td5POcMobhQZ74P8KHBMmIXnXmV8nK3StwZVuefkUPyI32y59ds4Mq6/VKLm/9FJp3gmD60ahlfweD2rzFAykWHq8sZ8W/pCBixfInvt2rlNj5BCVY3lk8N1yzrI9py90q9yWeSCScpKb/M4nBmL1F/mAj17ePUd4qIqar/jx98ki8mxDgVjQwtbpO0ckRjwB0mCRNreLfP1EUrgHhFTg/vAWfzrYFQnxoRwCLDdYnMLbnxSGStb0FiF1y2h8gsml/zzxH4euuDNbd48tMDoOMyMP9iHysNWLqaTbvnqncUU1A3s2rwhgNuH4biKw1qIsrm7f7yVzxcPrQsxOeB1kjixHb8rvpEvI5l1R+Wh/oIYflpGiG7kpoB/bl78ZT4THGCp/a/arpJZ7K2HcQ+FhDZ/URojfWQ81KkNhpC57YRGL9ro1zfDBq35hd
 cM3vi8JA
 /HWCjqegFDjZz4aMouslrbP6PtOw0hj2xXtG9rAIK5yCOeEqNP8CqrwFY3vQQvCv1oprE72i/NHPCGC/glMV7wiIM007phkWM23LKhzgG0Mgmq37Zd49KvFK7E6889H1hWMjzIrorjp4h1yWBzbhhUfCmwwAYCpC+ReHKk80O/STNVqJeUSKQ6Kohp1elp6WSrx20y/RqUfNpwudXsU+IxsW0/i53sd4AsHBwrBBzrZQgGu6nSrq4z2P0jEKyHZKjLbGAWfsSd3cyNjUx1/N1OcoDZGcGxdXUhgQOcGdnt8T0v3WuHMqrrLp1gjv9RLD/HpPjpWSxy0kL6PQqGCKO3NuuKjGy8u11mCISGY7aigymKbSs2oaQh3H1Q5nrNwRLpuD9VSS/I79HDqoZjX5AEmUzkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, callers
no longer need to pre-align. Pass vmf->address directly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..70ab8b3e3a29 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4661,8 +4661,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
@@ -5178,8 +5177,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-- 
MST


