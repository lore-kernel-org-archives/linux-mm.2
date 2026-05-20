Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFFEFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AFB6B00A2; Wed, 20 May 2026 18:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402F56B00A4; Wed, 20 May 2026 18:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3195C6B00A5; Wed, 20 May 2026 18:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE0B6B00A2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAD028CCCC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:23 +0000 (UTC)
X-FDA: 84789220446.20.3CE70B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97F27C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SI+GgCCM;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
	b=4hquTyNjCsv2k4d4Eg322X+fCk6S5iJIhuTPx/h18HHHMfhfmbZw4OdoVdUyYficQ3g4XJ
	I69R2EoGRf2hGfSti63eI46cXTsjrT7gNoGjJ8ujAhBCxvEK1mzjYSDIQWsqGYbJHgwUOj
	YeFdU0/UNE4bd4Hju6w/rgCGLmAADIo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SI+GgCCM;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315681; a=rsa-sha256;
	cv=none;
	b=l2RHmzQV9PWMox7yykJ8ZAAczqPrGf04f/NBZanh828m/dRvHUSMrWamkXYQ6zRu3VL8hB
	mTc9K1TrozSrBtj1Q9dN3BCbQn9t95ZdGUi28YFe27vC0us4zaGgenNQJ3Ke/5Z6tM6+gy
	IirRniYx4lQsWDgHMeHzbw4iqfH+y3U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
	b=SI+GgCCMJ1ZXvoS6QBjbSbj1Zcu+oZ4Fq/GOFZvnHKlkyWGgy+ZYPrdgrKhnibLmyvFUzp
	ZSuQKGwjw3hF0BuFTPbfOQJHmeCpXyz2XjL0nnvQqSpgyfAbdejwUcD+S1pfYPxA5blFT2
	9670lKYYFIxvn1NZRpGp2TAFC2TaEaU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-jgrvGJeQNC2jy84OaOKHIQ-1; Wed, 20 May 2026 18:21:20 -0400
X-MC-Unique: jgrvGJeQNC2jy84OaOKHIQ-1
X-Mimecast-MFC-AGG-ID: jgrvGJeQNC2jy84OaOKHIQ_1779315679
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-67c1bea16fdso4740234a12.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315678; x=1779920478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
        b=nB7+XcR8yy5nz8IjuUL/m20pllpSQFJbQjin2LLCKgZtXoHJ7PZb2tr9cRv+Y1aN+X
         lvc1THJiV0ChXlgiMAQpDAVUzI6ZZcCSWtYdZH0LBzW1CvlNNc0pGg5jqTw2v2H8xzg9
         yROmSQffZMLKQ1RURXooKSm/Qwtu60XpSpff4ZV84DUUITk9jL+hCoBma6J3qsFRQfMN
         Ce/vWoQL+yCgibx1RZ3BRwDeuDYsvXWbA8Bsjz567NBj8Uyqr0XBCFA182oUQbIHBW6W
         vPN8L7vQ/QCEVR+IJGsijv1Qh5q9MUhYmkrmUOh3XvMUvoe/ATFKgrSCorIo/pye9LZW
         LiQA==
X-Forwarded-Encrypted: i=1; AFNElJ/v2ZGpBVVRoLr++AiCgLBp0UZgtPiXDfYboTJsUqJMrni7dsj9uM0TGtJ4eDRrV88UbIRD+Bgjzw==@kvack.org
X-Gm-Message-State: AOJu0YzGmBYjYv8qa9vzLB7fvHwHKlE+PMDUIlbs84EeL+c6REuWVyM2
	JrrzQOx+Yabs4HuyzSSAPo0E3YOvK916qTijkukLLjWvhsuvYWKgb5Wl28pFrXlK8L+WhctfTcd
	l1cehtRitdUUXnyx9Dxggh/8BQ+7+Voui+ZY+Tg257gnvZjiKo5Ne
X-Gm-Gg: Acq92OHHYDvSatNzHyu/mvTpBU3dCYP8I2z/MxeKDp3qENuatP2Hye27NP+LXyGgGH/
	po/b9PGlvTBHUrSlqmKQFgSLA1X+rGgTi6u7RheSDb8It8NF3Y0mtfRzEQHx20x4omCtyPZ1xiJ
	dkGJHXKEzvKdr2CZFV/ksTdoDys3hSzXaHNtAMlUJmN+ETVvhYo4ektonLFoZhZ7wJ/LmT9Jg/n
	cfs8bPvQHEssechaSIOt8/1Yaf477YfV//rUablFQ6Pev+rFzXT/2uj/L1E2hRiUZObXYUUFN26
	Fli3BUVheVDoV0uRgak6W/yqiBC/hDpOY1oa/o2yzYRSnOls80DW/dOHEJ1nfQMIwgkcoSQwApO
	PvzfmIzmo2ZGfIhl5DdTX8eFsNcR6SzKOzL8Pbf1xB68=
X-Received: by 2002:a05:6402:388e:b0:67f:d8bc:1c1d with SMTP id 4fb4d7f45d1cf-688367d7471mr20704a12.20.1779315678485;
        Wed, 20 May 2026 15:21:18 -0700 (PDT)
X-Received: by 2002:a05:6402:388e:b0:67f:d8bc:1c1d with SMTP id 4fb4d7f45d1cf-688367d7471mr20674a12.20.1779315678044;
        Wed, 20 May 2026 15:21:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-687393e8e89sm1281214a12.8.2026.05.20.15.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:16 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:11 -0400
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
Subject: [PATCH v8 09/37] mm: hugetlb: thread user_addr through gigantic page
 allocation
Message-ID: <9778009828d334fd4262d60b20d8d25a54e0f133.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pOfrKR-KWQrX-hVRbALhrvQh40tlmYnxEa-vHoSTL6s_1779315679
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6w76qgqgdxyazdeahragqkc9oekbc1ek
X-Rspamd-Queue-Id: 97F27C0006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315681-907800
X-HE-Meta: U2FsdGVkX1+/uqHcLk1GprwyWorH9KaUzsJVRgTXa3gDqxAa/aCDTGH/hB8dKYFF0uHmuj62/h7EpD0u+g86IZvwaHF94egiEUqS/46ZZsuPEWMUvEMvVdvlJGEnITS/0xQN1RLeJq2+HAOTnb7PBTdoNBsqU4/VGtFG1AkIq/p/nSeSEmf+Mahn2+7jB2Npgw+UZQ6tE6F0CjMxDiLA3DE1WcgewQxkIFt7aWlPwDq5a5CdqNEDCQhH9Jp6xnl35s25elq36akiNs9M1vMk/eBucRNKYVrQkTynhrHmJyE3M8WqBlL4aK8RgLu0Mf55zr1PlqYfXuDBABTbdTh78Mu1SDLU8g6DooJ+d0gi+txEuWQxvVY/lfWeHYeuqcKfuYXj+Bf1Lksh/WR1hCbsvqPZVB4QQcALYHNyTU49NF0mVk9jNGdLBTVQ4NLJ0StgHdabnv7tkrd1s1533eME3gieH1dadcP9oq/UDk89UdMKaHbPXRvH2hKmhhsRziFDphrTRrVcwC9RTkX07TTeCLdt/myt0/25YzH/7x2eqFERLHGn0WfnFsmfvCCaaEIfttSx7MohjWemSOl64lL4/EU5cDuS0fXab5fxkbN1jjYCuLDDgbUkgPiVQjBF2c4sbwM71Vw8m7UDRKhrPBIb13mXRX+3xxJIz+uRt+3kQfxNb61UU1le8PAwYzUbzmUlmqYD/kxBpsp5QL0/ZFVZTvsIGT06NTx5S2zkKgbi9iOIkZc2Q/47l14vxLkONGzg3ifa3zSM6Odj/rGORKiv2i3dmlhX1yOyQ1blFBMYVH2jKhOyiGb3pmO7fCIBLFr5oHTG4X/LKKNQHk93gwsM7O+xMFguce7RGlE25BLJ/QOOFxRmBX0YVGTUjWb8l0u7pUV6rcRJUohJg4oBvfyh1iYdUvYnIaNFS0IJnCmwvl0rdAITmUEQcFFdFa+4Dc7K/Wckhwo+pot0hQhhIE7
 7IaID7N0
 LLmHBbNjLTvJqfRDh5yroEDOtQFkt+2fgRwwPwARE61lOnRo0qWy8T/WurDzkjCvZ8ymkm4fIAzqwRhm52m75sJu7F2CYa2JlKKlJETVwlOffGlb3B5FwwPxghifNAOn5krDXzpGwt0epvW7KJffV9OQMm3QBLkYWBx0sGpt4P0McdfkbfXtkLLeaGKa94FRHqS8/AcB9i2XY5pBwsbh/DXVeSLUCvaeGtYfq+IxB8LPCF+DVsWzjhwVaqQ2RMFJQGt331JElV6VjTDmm20e8w5XriByY4yxCksQWwNu9dnX9rM1LO46k49b05rnFt1XBB6v9Wlv+5En/Gp7t+npblJmeEHXW2KTKhoHVdrjoJaf4Q0m9NIDgZ/ItWz8z8foiyyyZN3EXxSjZJMy3P0rsdDDs8PfPEpoYKCY7BpfPhnEIMuWXlIPelUWRM6bIrJLPdxADt38tnke+xXVlRR82reXnc6IunTUAzkm9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread the user_addr parameter through alloc_gigantic_frozen_folio so that
gigantic page allocations can benefit from cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/hugetlb.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a999f3ead852..3a6afbe99116 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1375,7 +1375,7 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+		int nid, nodemask_t *nodemask, unsigned long addr)
 {
 	struct folio *folio;
 
@@ -1386,13 +1386,15 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 	if (hugetlb_cma_exclusive_alloc())
 		return NULL;
 
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
+	folio = (struct folio *)alloc_contig_frozen_pages_user(1 << order,
+							      gfp_mask,
+							      nid, nodemask,
+							      addr);
 	return folio;
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
-					  nodemask_t *nodemask)
+					  nodemask_t *nodemask, unsigned long addr)
 {
 	return NULL;
 }
@@ -1862,7 +1864,8 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nid = numa_mem_id();
 
 	if (order_is_gigantic(order))
-		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
+		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask,
+						    addr);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
 						 node_alloc_noretry, addr);
-- 
MST


