Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAAFCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328ED6B00AC; Mon, 11 May 2026 04:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3009C6B00AE; Mon, 11 May 2026 04:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216016B00AF; Mon, 11 May 2026 04:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1304C6B00AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D46D81C13FA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:08 +0000 (UTC)
X-FDA: 84754526976.28.EBB0533
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A318F1A0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPDCr3AG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=OMnY1auO4ST5ae5NEznixzk1NCR+PG5dCre3sPNNMy0XaFoXmW9X0AhF9WJ6agM9hGlyzZ
	S99DnxITK08gUlbphScMwoXyF4RdP2ib/LZvCQZZfk0YQ7Y4+8O9jefMJMbRDtXD1PIGHB
	bCOjm+X+KJ3m4p8Lrn2wpzawsjspAG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489646; a=rsa-sha256;
	cv=none;
	b=c35vCvl/Rgs6Nxj24sPo5azpP67GUzKI3ynY964Q2xQ4/d7StkSiJSCf3KIbxhOTpxGikb
	UyTiD2gxcMAFjy41Wr0LKkgCl/nxpPsdzPTgXkkM/niGnX44VJubalkZoJmTUgY4tx7mBM
	h2ifMIaslkINgMBaCckD0qWzoYiu8Sg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPDCr3AG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
	b=hPDCr3AGiw+3TO8MCauNbWx3CzDak5ca+Kfk4RVYH4x/db4MK20ykpnGYSJ4xqGGlKc6ew
	mZQM4ipqskuFifz4PAIGVBPTUrpSmriitFTRWKoa+eUthgatsItmE/OQ2R+e4NOkN7nPf2
	olX+qVtiT4XKj4GJMJYrnviy7H/Vk6k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-RLS64GD6PNug6pQVVyUARw-1; Mon, 11 May 2026 04:54:04 -0400
X-MC-Unique: RLS64GD6PNug6pQVVyUARw-1
X-Mimecast-MFC-AGG-ID: RLS64GD6PNug6pQVVyUARw_1778489643
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d1b294dfeso37932885e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489643; x=1779094443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eYp/q7ILAhscET8EXyPBKCW0KNcPEmiVquSYEOS+Yg=;
        b=C/nOKocbNUMceYdHx0IZk5FrEA038IPDilC5da59Y1n1Upww8rHGJGbgw9XhQScQQB
         0e49/f/hZI2ktaNxhCOW0NKmjxVyzA1dqq7zZNt++h/TzzeyEKtgv234P36w1BLaAEcj
         Y1Py2O8dxgL0j6zIW32Io6wNL8d4MdadRqF4yH3+B4pKYQron+dLUu5RgCZCqYi0LzrO
         BpUZol/PoQdYr0Z47dvcftje969HoJTsQwpISVQ5RHz/1Wr6wQgsViqqoksGKgGtoTxI
         xMF544QYsSlFlUq31t0ZKPtPWvNQgLGw/HMbKw8k6+j5iPufOOL3aQ6qiOkxXsBXQVuW
         Bo3A==
X-Forwarded-Encrypted: i=1; AFNElJ+uwOM/isXcVv63xBqa1R9iPtgwT2/JW9wx8ZGq1tBioTag8y8oJYgad5KCYMi83lQbZUxyR+usnw==@kvack.org
X-Gm-Message-State: AOJu0Ywk+VPTtGDrkopuu+OZ+7f1mX3pyiz4XwQ6jqe4jcxQjLvu8LGR
	yTotg1E4d3wnilkkjs91zG/GE4y3jLtqlQcwMlXMltO7oTSCJw7cxzESoPY9aHmtvnnxnWeegVj
	jWKN7tpOMozbmi76oA/YxtAqOllwEIpcJ8krjAVgXYvXJT/pZc27A
X-Gm-Gg: Acq92OEcVe573K2manfQ0di3EQ7y8JVsWtauqCJZ7AtK7PZbXpMlwQr8KFulBN9HnEX
	ip7Fu0QBXVELj8oPgCSeQAtADzSKy4V6MBKuRgajuu1EVT3lM7xTX6bmGsMk7YwC1xmOb7T5Wnc
	9ulR/E7nhKadgPotL27GPAjobnO8I0iNBuaqZFZo+hQvZ5KF9eJ53oHXkqG259IHJ1GsPJO/613
	NHAuyeDB7x8efwqL1tWXlkiqUtPr9Rg0OHECBfzpMugz39OluLFr5CkU97FHqjUio1BxrDkZo6O
	BRFPDXmY8XOjN6FTIj1BFr01jStSxNUsQIPgpDwHmb2hBMu07In0bdwP4qD6OiyvCFXIa+8zSA9
	NRO3B2fnB0iVFL5GFJ9JGJKt6aBSxEJ8+go+Z4spv
X-Received: by 2002:a05:600c:a02:b0:489:1c1f:35f1 with SMTP id 5b1f17b1804b1-48e706ad0damr139910405e9.4.1778489642423;
        Mon, 11 May 2026 01:54:02 -0700 (PDT)
X-Received: by 2002:a05:600c:a02:b0:489:1c1f:35f1 with SMTP id 5b1f17b1804b1-48e706ad0damr139909775e9.4.1778489641820;
        Mon, 11 May 2026 01:54:01 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702f407asm172879455e9.13.2026.05.11.01.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:01 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:56 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 11/30] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <99c79224ca94e63dfcbe8523cedb2a8d658bdce1.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 46kJ4FmFtfSbYJ887yuaRA35m1NmtTfiaDB25vE_PiM_1778489643
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A318F1A0007
X-Stat-Signature: yn3ayrasc91imrd758jq1iiqs7sje6zn
X-Rspam-User: 
X-HE-Tag: 1778489646-634236
X-HE-Meta: U2FsdGVkX18JlytfaZDhvwWsWDYRgrc+y4xpk89DPpXNJL0FhPEjIvsbW3L0EeOgkapbMon8KizgOLSzA6qwKoxSVHLRgQs32jY5Xmv0tx1xHW0guD7wweEVhPj/JQnbrZ4Jj1xKxSSduUn2OFDNv4hUFpOBJdmZ2NW6mmo2rTFmFzWF9MqkGIqW5EpEb112kbaxQenhv+KLpn+HyHLxnQ15LXD+VUcs5LY9UicHSvAgRatl2EreH6T+f7pvGnq/8L0yROOrYRg1QLGoRhKvXLqrA8NM6B0TdmtpXbbVfYmhfehQk0DjTCebqJyWw84AaZCIFPlMIALz9JcOn/mNz0b/tE8Vqer/J6Quc3Q2fVUKH63lnFXAgeORBa3kkDcHO8cQ06z+Y7ApUYV2Y//X4r5VckZXUFKTncj7MVAigBnSv/qMj6GL2yfB2SuhUO7ltp1CyahbUgJ3yl5/LlW54jLDbsrE0hNMAGywM0dlYZMUGmE1ZSlcG8QLzMpblf9aM/ZsYBZVPjx2EydRLtcvi9b3TIE0YDPvuV4fDCKKp9pJEZBVWiWTKnQ0cFiFRfLjASuh/9CTXOPF4SKZ5omMZZnRjn3DE/gxS8UJwJQGe8pKxr7mY0mplB2+EAFDXPqHvfbxpfQZ1ohcgwPQ6L9OI2J1I8djl73/AkMYx/2pARaVI3gre0MoxBGgx4tzzemMyQPr5Ie4qmoMvjLJYSWw6LXAiMRpoDvXKfipkSjDk/5jEOu5BUHXXFTElF1RgzzeBoaBxaRtdobCvJ27uFYt2yzzGL9+IIqj4YqlDwGMkT8Ga6Da+dJS3PwP9LW+A7Bv1Inyy1nZYRa0JSgFMCdP/+jOKVA9KRBPgvKPh2rMbiCoYdCxH8Ylb1reG+byuL9UpjxQZrGl7OtCRYQlZmY87IbxkJXQjDFIIyjNVu4nd1hWiqPluzW+C4gSRdiyTGEaJcRtY94ho3s9vt2s14i
 ZHQAcDV8
 eV2ODXytVP6GmQFrfDOgIHEHy/FPsWjQ3GQjRuF0ui9HDo8kY629YMvb6Mo7TUJxLHkMmNiOX2zss0IxUPHjQpoomlBiKZxB6I4zYs779lVADKRCX3chQpKLaCaoLxEq1WAgkr/3+Gx5jVAslrby9IcEuB/guGP/KmKcF8LW4FDi7PRJUNQp4kQ3D8zw2JgD46ct6qaD0dl7ea8j33zk1arxIBgZ//Unvkhi26t2x/GgRumym3CG1eQdSaQ5TNyC9U1dfYpU9RhIeu3ChvT+9+297o9+xe9DNiBI1GNGsiYo0ZOqjKZ/Un+uUtkwue01kqWm05LuvvHxh2KGg124LFCO4dOfBxh05VTd3kL2ZnjrhmZ6M3qklCxvBHXYl2qReDSSVyZ5jMHi2juKVfrt1GZccbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 74523bc00d8a..f3f1bc66366d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5249,7 +5249,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
@@ -5259,15 +5259,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


