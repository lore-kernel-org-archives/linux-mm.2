Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99093CD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD246B00C5; Mon, 11 May 2026 10:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5476B00C6; Mon, 11 May 2026 10:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11DE6B00C7; Mon, 11 May 2026 10:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1C626B00C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:05:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C529C0426
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:51 +0000 (UTC)
X-FDA: 84755312502.22.E147658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A8E431C0016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOgjHA25;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qI0Uz/9XXXc8IlcXlbD3ad0VmEZHBkxihS3lSDL524Y=;
	b=3uB3XzRco7bz0S9pwmf7AxkKJF7pRzE23bCE2bQDRkev8fNw4KUTnDiqndoNfmdZ8FFZpU
	JTMXyGqFpEU4Wyn+d/6z+XOigrSbHHA3KxO1//aThSp17G7zt00/v53sVFEXJ42bs8IVqN
	hXIjyTr9LvR007b3BfMTp1E3yrQGXZY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOgjHA25;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508349; a=rsa-sha256;
	cv=none;
	b=IpLUiKYEq3HjD57krHnYavuXyq48H2RLEXMueaH0F9A3APmB1LNPvMOkyNiin0fva8uERM
	edW9yC2qm6MPjUCbP4k0RKvbZ3xLCzxeJrY32kEeumSLNNuYWu9tki+yjZtDeYMQ+Jqmq5
	jfmoDIM7qvdr9ZyGkTCCnjdD2zi+i2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8D5E42DA3;
	Mon, 11 May 2026 14:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3921EC2BCF7;
	Mon, 11 May 2026 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508348;
	bh=VMme4hNP/eM+ancPCzgwcEMKJqVdjI2yHAw5rPRUmE8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hOgjHA251N+AuGQAcHY49+GihQZEWt/kPQGVzFkJ1DoPGaWOYf2DJxFRf0DdPUImS
	 7AIus401fPM2QGs3iwxv6jpqlJe4Ake+N9+d++Dh5t+N4IfV/drPMm1XsSzGr6sec7
	 kSweIR6wwM/Gp0bdaj9g9Trvk2DFZELNPRVBiNsZDa4Tw5gNDgJzIg2l7Jq735fDrr
	 voxt/4ejanfokwg4xolHAwo6eqyi5y95IaMOZ2YO15ilj5nVYqFpZJdXg+FKQzzJv8
	 tCFCjZjobllgHLhyqv2zRnfJ30612QxGV6mbMINrfWztiOi5qzTmqUoCZbQO7mC6Ih
	 oNuEdbrf0mpjg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:30 +0200
Subject: [PATCH 2/8] mm/bootmem_info: drop initialization of page->lru
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: igjkubwx4dw1kgakpbmri39qxm8xp9hm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8E431C0016
X-Rspam-User: 
X-HE-Tag: 1778508349-603180
X-HE-Meta: U2FsdGVkX1+yfqn753+GSGrta47rZKbh7Y43NFFwK73JsAuKZBdMXj9ThIx/j+j9m5ZNpidUPC8KL4ppES7Yd2m4JDwHBIs7MDq6L8FUvFGVbWWzKlj4f9wb8YgXJIjh/afEtPI117Rzu+fi13d39cHRPiIB9lftecs3lJInK2aBDXqGHOCLfwfu08ZRT1UMaYNw1NmL3ugqjJO0rVUFQyAtK/OY5mNakOUzNN8Zhd6iXI1L3w2PdbvGGccLaU3H0HsillVRtxUZsBWGGo30p5a+ylGWb6VXQVEveWrMLtn3RPFc88vKR41QYJRPgqfoFrdFu9JaC9mqtQtT1qeJQs0oY8zUd/mRlbzb2dPkq29QZEbwjxKmFHj6SieaLmNKaxHSzph89khZqCBB9Yk/ksVeUtbZWGyx4neoAxJJPtvcEOEX21kX7ONaAhXlyyiBjg3vbm/sJvzJuTOP2zumKly+7M4PfKx+kycrW6xUC8CQLZusi+xDDCyLH4p6y8t0i4Sts9rTqPn2wa+RQv/eInmUmA9OgUqWZFzzi25/v0GRVbo4CXtUcBtnQH5BsAVbkAiLzR6RBqXIug0j7MdDYK55IQW3IQGGArogeMdOk3kNXvROd/jkO3kUxTxcgc0z1YF9EpEyGlkiPTB6cZnlNnlzMYNx11IpgooQJfXJxs45rhLTxUtIcf3t3O4V9q4RbgScdtYO2skP00zTwuiQ9rwH83P6BD4EZ/tNCJgBRtVDGw6I6Qfo0tcR9l2Yi75IvuB609g0mbf9pEGIKw6AMQQtRDAwu6mZcVQ/dhFWHwjll3PahMZ3jXKdbhLt6XvOUz3zmERFEc1Pik4WmfaKwLxnOWFLdOADSDcDKFD0dSYyPGkVfWMWKlwvgVRev+WYkHhyxHyY7mddDybjDXzzAQrnd4TTMuV1iXzN4gWcExPrpkp5hvnNWq7gAUqQ5phuWGyg8WVbFOlUURCHUtk
 YAuzSnRT
 H14IhIppLGPj5Vg0lu0WIeedITZnEkVdzAGQOk0qf69t6Z8myjhi816dxx6mg2Xb53R6iTdfCHioJAsocUXLZxnCtMEyx6xcerWOzcOq5Y4sWidIMUFXSI7cmh8maJ7fpQj1OaIZtouiyNggg4QNbX+BFBhT9KRV9qLUr3hmrPdQIL/vVH1LiGgisqqNIjhzZl98bqJuZGRjL1Mtj8E4N7djwL+Apkjm2PlFPCdIiZfSg1cl3c+AyzW7RiM1K0RZNJu7iTVPdjUsXIOPYKOo8qug0+xeVHB9rppS5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, we used to store the type in page->lru.next, introduced by
commit 5f24ce5fd34c ("thp: remove PG_buddy"). The location changed over
the years; ever since commit 0386aaa6e9c8 ("bootmem: stop using
page->index"), we store it alongside the info in page->private.

Consequently, there is no need to reset page->lru anymore.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index 3d7675a3ae04..a0a1ecdec8d0 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -34,7 +34,6 @@ void put_page_bootmem(struct page *page)
 	if (page_ref_dec_return(page) == 1) {
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
-		INIT_LIST_HEAD(&page->lru);
 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}

-- 
2.43.0


