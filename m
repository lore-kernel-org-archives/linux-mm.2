Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0D7CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117476B00A1; Tue, 12 May 2026 17:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFB16B00A2; Tue, 12 May 2026 17:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1F96B00A3; Tue, 12 May 2026 17:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB61E6B00A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A9FF1205DE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:05 +0000 (UTC)
X-FDA: 84760000290.08.7A6BC1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F2CD20005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cq0adFRK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHWjppoupYJq6gg1bmhomqZmsJDzmE/Zol9ZNgufzks=;
	b=c9xRchctlnO2eJwq6TwdKS+sYHYvKAbocsuEq9VAMZeKsKf/86ccUrY9M/9DucbexrDEEQ
	zEhH380/YI7ga97Pn0mC66pQx3rXSO2FgjPLG85zwrpdjv8qq6wedUu2YFerwDMzhmrCO9
	JDp+GP22xgBuh9X5d4ED8dmPdLwo/Ag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619963; a=rsa-sha256;
	cv=none;
	b=lnZC2BJnW4hIUt8NULOp8qbLFLxioMLLFNDFh7traovxBWa0LI6CDlbrOGWYMvk0mfNOHr
	yzfv2J8Rc+RN2Y+Wqszdx4nM6OwD9cYxWGoyK7Tu9AFet1m5grqXhCC/rIBvfs0InwmfcT
	7QjUWxi3N12dCYzdL+l0Rf6tdYcFGrw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cq0adFRK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fHWjppoupYJq6gg1bmhomqZmsJDzmE/Zol9ZNgufzks=;
	b=cq0adFRKwNqko977fAM2S/+sM1MWR9nlJcfEZlRpKmgaEGvbt4SIFoDrcw37A3z5OjEdME
	NUuNElx73TZo3ALK1/zGM4Z49ORk3HxeAN5+1+3Ty7QbM6avcXQdXd+BGzJhlSDjoSJYg2
	65OWoyUb168qI17MJ8yimRGjf5PsGA8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-jDKUXXS1MDCKzuQ6rwu7NQ-1; Tue, 12 May 2026 17:06:01 -0400
X-MC-Unique: jDKUXXS1MDCKzuQ6rwu7NQ-1
X-Mimecast-MFC-AGG-ID: jDKUXXS1MDCKzuQ6rwu7NQ_1778619960
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d0677b5f7so34061135e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619960; x=1779224760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHWjppoupYJq6gg1bmhomqZmsJDzmE/Zol9ZNgufzks=;
        b=KwvryLp56aUpzOFO9T3QaFtCqVuGTmXongmML25Ao2BzIkzICZr8kJ7ASEKlZn1o1C
         hfy3fCClQix/7TZZWUaHh3Xzi21dkCzyvqfaR5D4BzyqG09LXXaeb0f9oWL20xQivvEj
         /F5WYTiwz8SC1LJz0VOigiwUazN7tzDRTPcc1yDGHLWyXdPr6EXZhVcGOUbR5egk1A5X
         93JweeH09TXrJpKHcaxeEnHih3nns7Cq8pn93rnrU7eYN1pFxWrif0pWYpZsx7JdVLhp
         rXlP47nIRoI9se3hzQ6KFIbdI/07MMiiwFxDM3r2u3aAsgWv1UcOqUPWfrKkLh0/LvKK
         uGYg==
X-Forwarded-Encrypted: i=1; AFNElJ8WLF+PhYMHvwPFv4ohTCavMJsSIK2OUTL7hCxVrz/hn9kBfJ/v709nrNjfforfPdT1dTe5uZzJUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5ODT/mvDNJUNgNE9kD7LMyqH9QpAO5kA5e5S0/xJ0jeHdsTeu
	GImWoHkLSO/kHw41vLV/sp1IyKiJWvrSq0Ve7ln4nT5Q0aRUlpWq2kjbN5Ox9trf0DddfbcZ5x6
	eLU7ssSO99lz7O6uL4E72S8628ntLg6A5cACoJ8v5+83pD4SyGRtw
X-Gm-Gg: Acq92OEMkbX0pFp0S8xabtN4hHCH5mFwI6t9uLbCzdWNticC4hjVJcGzlvUA2z2yloE
	2Z0oWNuCB0JlnAEgZPg4NhgU9NKJzjoywLGL4QiuCcffEatkUq6u8j5Su3FogUG5+PjHD1X+Mxz
	p8MdftAaB7VSWhptfOrs3wgwWRLgmNdtKNqXULjKGKAoeYFQfGaTtGyCF4ZG8NcdC2r1uCUuxHu
	jsziKD8BsA1hGgSinZlx58P77ziC7yjUINpWQZXnz6s6yw6UfRp6tFpwcIF3TyL0ZRr0SOK35LT
	3bmxxZzcjZp5kX3wWC+tpgTr/m3G3z+TnnhkBgFGhCyDbXUJckNcyjxjLgzeI0RkCkAf+0adMLY
	ZZv++BT+sASxvU0GaTErR5Xx12R8f8sn8pGbFCr9H
X-Received: by 2002:a05:600c:19ce:b0:48e:7f1c:8778 with SMTP id 5b1f17b1804b1-48fc9a34577mr5572035e9.17.1778619959999;
        Tue, 12 May 2026 14:05:59 -0700 (PDT)
X-Received: by 2002:a05:600c:19ce:b0:48e:7f1c:8778 with SMTP id 5b1f17b1804b1-48fc9a34577mr5571635e9.17.1778619959429;
        Tue, 12 May 2026 14:05:59 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fcdf63f05sm95345e9.1.2026.05.12.14.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:59 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v7 09/31] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5lTfYLu8DGMnwvZjSj4L9iP8vaUHxqdX2hOs8uNJxec_1778619960
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F2CD20005
X-Rspamd-Server: rspam04
X-Stat-Signature: uikoysxq738ttg7a57ectm1ebi3xypbs
X-HE-Tag: 1778619963-398592
X-HE-Meta: U2FsdGVkX18a1+KRoWOmcBWlHbgqzFfgf+Rv0d+KdPHIfY5Q9Okc6GyESq/bfeykFVhrxhIl3tWtg8WRE3dfE/ZYKKHlvYjbfSP/FNeFLwNz/uKi1LWKhHgqmBMEgtvAyx2+OakLA6Sf+yyuUzo8gdfsKml2LqvVxih6cUq2yb5CE1L8LENaMYfIRYOPLF/z1EPYr5yV5fl6rPC8y3tchQhc5ejSF7+zyCHM/rkWTsaA6iUHhZANtf/t4ECxzPlCi2sJPiNHJmn/BCpe81TYca+JPvYp9rUz+rDZpvt5rSFZ3fR0XAz9v4OawwRimBCSPVcjbqRASLlSQaL0WjKdxluMRKl8QS5MfMmSc19BOKdBwtHJ2vsI1sXoJdxsakkcZVH1XZdaNBdszO0R7kgPT5JLrPLPzJXPY1tIc3dl/BC6yiDNBKMquCFPC9AxJuZQ4mSa9oEElhToZCgrY+xNWLUef8ckqYqcOCFgdR+wAK5D6HEw1Z0o/BuY+4wgUFyIEqC8qtbAIwmyX5FAg5Xt7RaIhkln9eAnCWIjV5tIM/Ge3S/VxUvXewZleUIIF2xTTYa06Sp30PFffSGt+8YVt/mTLKx2ou2UYveqgTLLOH5452CWwikgc36ILBKAeg9Jt9eYfZeRD3FqgkDkDKt9a2ssdiidgyUmCDM0+VqZm+nHy3s+Ish4LjCMBdGMgGPXReWT9ry+QTvwjpI+h2nblpQYq1+2n9qwKt9YyFngZXy+SmSvIrQLONeuKlweV9FG9woTU9kNDHDB3d/PDTY2WoxoW2XZX982cCgXZzEyemomBsPO3RfW3twYj4bdys6ZobSrlf+/3DlwvxOwz43scj/1uTdpsVaIY5xZlht6qC+otDbcQaagq1jEIM5nA2lhqnruXLykDBgJLDy7nouhG4JnyR0WC3b9ylECwkmCsb9L8gyrVt3obS3xRjLodD2cv++GkTmB1rzOJVqEkmF
 V2FUIhw9
 DKMQ/SiOL6/6VkgAIL3BoYdpz0k5QGXaxqFO+067kkUTCGriRactMld/4XSd12Z45PXw3s24PJ+U1FfO0wuTPeBXvPR55s5KjortBRo3Pm417rn6uqjX8yQxvhBeIYGSZJ1Ltc0oDdaMgK2Fv5mQUvblhsuQQxkUgPoYZ+9+CCQiQrD9dOdTe+0YFBQ1aUWUVGo5S6qsA0w8Xrljy1ypbHKJvYLpfWJqRzagAYykUiv+YH3JPtZh5xbynkQCbIOXMygyv/1g13RbNOvB+eSUK2DHwNndb+W2tTo38yrNN+fy7HjFe8FQo1nOPPqqq8J7koHmBOYLmaB8Yvcd4b9vz1xL4PUD+kb+U7bSaBQU0+633cNb1vRxFCodv7rjyvaLMy5+nvZfiAvN2ctvP7fSfYlYxtQGap4yAMgZTRbWOvhK9Xnm/uMOLdX3tDYJ1SrTZKHDo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index db387dd6b813..76f39dd026ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1861,9 +1861,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


