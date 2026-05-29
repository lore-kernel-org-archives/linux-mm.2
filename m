Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425EBCD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A177F6B00E0; Fri, 29 May 2026 11:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEB16B00E2; Fri, 29 May 2026 11:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDFD6B00E3; Fri, 29 May 2026 11:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA9A6B00E0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4987B1C0C3E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:42 +0000 (UTC)
X-FDA: 84820827084.01.F4F4932
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1719A4000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HbT+FGQ4;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
	b=ySBHRnrwJYUija9aQ1rOlvvk29WyRjqwCrI8ptyiiNAubW0T4q3fDZfuup5wwLFusk5bR5
	4sB45MncSL55yGo/n8BjvZDqJUx3PU2TLqQ6Zco3hapIIwpeDi/T1SOuI1361rDLW4/ZHp
	L5GAkLt0S3/oLpTubmcCnKrbWzzAK/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068220; a=rsa-sha256;
	cv=none;
	b=E2UML+uvx/db+2zdUexxH5rgvnOE8Mqj4dyjSV5fQDGBuoNn1zTmjo4TgYPUjJenwCEHZq
	B6S4TovxBK16Lt22wv0bBkaWFOP3x8RuQSP+UqUONpYTAwO5NVLXVLaozaf9uc3UEgE21u
	r9nY5BDaNFQL4E8kQNPQ14jyr8AjZp0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HbT+FGQ4;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
	b=HbT+FGQ4KMBLy2PEPv2GWqQobGU5w9cBBQeczN270Tz8jE3GXAfk4W79zXx9z/WqPCacee
	1j1om3OjMiGUYaetELa4/3QXSxCQCIhViE+coLyenSfy0t1eBPr5Qk5CHKAhB3IMLkf6/y
	WTKPEV36F5LLeNbXGjjGsCMaNE/Auq0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-jyzsHyfWPhePah0dDqDQxg-1; Fri, 29 May 2026 11:23:37 -0400
X-MC-Unique: jyzsHyfWPhePah0dDqDQxg-1
X-Mimecast-MFC-AGG-ID: jyzsHyfWPhePah0dDqDQxg_1780068216
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49049100a40so49222755e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068216; x=1780673016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxMX/pzMUOtdSR/DFO8X8z+nr68xKXZK5hfRbiRHySU=;
        b=Hd+32Lx5Nbar/5up0VLLRFxhq6i5+L/jEynwsDRfNpdlCHZp4zvcWdCXTkCsjS1TeO
         FWl64a/uwX/HDT5xQflzc960NEDUYGdC03QKpfBe9Yfk/1Bk2b2x4LHDmWhIpxwn96VQ
         6V5XhsL1xXLHkqBs06lWbxD+RhFaXb3QxfklYBzgaf88n3UJ7vkRGYjWkeCBW3bg2+SH
         4jR2yi2ASXwW1fIcQLXkCxj54OGU2C9jlkV/C5KklqpI9jDwhWzf4U8zTmmm5guFv1xp
         MHNPFL4JCeQvWWb8gA1HrLoxVsarGvd+/CyaPo42ylpCwbqu1cbbtRm5m0SMObQnWAZc
         9ROA==
X-Forwarded-Encrypted: i=1; AFNElJ/kKeWpWd9/iG5DqePIi/sHmXmbY+YnM2PFE7vTkY6iLr+l+hYAoXn5FkbGIXqGfZxX+5GZqIIWog==@kvack.org
X-Gm-Message-State: AOJu0YzgzbG0UISFd945YaZeA7do2ZdYYRBFLh8xt8rZpkeyTnMSbAgB
	RiPboGZ2pQOLhmgn7PWUkW3wxkrOMBuKsYntar9V0yBNQnYQZ2bITviogWm10sdOHhMwPClDzdV
	Lk6I/tOkcMwKcbO5ZeMjN76l36cklfRY658MaZsJ/TnEVTFrA6Eal
X-Gm-Gg: Acq92OH/F80Emc4yBz0U/jRygJakUrDwxkzjwto0fY5xYnmsxV8dVMrZ+gaENrppoov
	2nJpYfuCYMo4RSUfcOCFw8xvNO4+uqit5sVNq8JEkzCaIxAUcN24wEKVLEoN6/oiumJvGuw5q+j
	88dgcTLe+GFfh1AYp3lnSYTxypbNQ9nYqWAA39irmzTVMwSXQH23g+7Ch1RVyoHBsQUdd5WVG6C
	fpk277LfZYWVbsNWeVu/lcf6e7sCrh+8i/Sm2itNOu7A0miqKJzO1Er9A/N8H4nHk9PxuzyOabX
	AciHfD7DWC9OdhmjqXUp8SVhGGSbtRbisewWX4np3Dj4vM5wNJrtRQgIVYQdSnYKTFQWLm0ThfO
	XI+iBq4AwGQYZZb7Skd+QaeGpIcpTz786n7GQ4iuMKELh40Ona0DCGg==
X-Received: by 2002:a05:600c:3587:b0:48a:75b9:b0bc with SMTP id 5b1f17b1804b1-490a2941425mr1584545e9.29.1780068216235;
        Fri, 29 May 2026 08:23:36 -0700 (PDT)
X-Received: by 2002:a05:600c:3587:b0:48a:75b9:b0bc with SMTP id 5b1f17b1804b1-490a2941425mr1583165e9.29.1780068215553;
        Fri, 29 May 2026 08:23:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909dff2a80sm52414665e9.3.2026.05.29.08.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:35 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:30 -0400
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
Subject: [PATCH v9 17/37] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <b2e1b8ea0c076e0a94a31d0a50f192f6c85e8ff9.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V96PA6Gxz2KeqRdy-kKUVHoyKTJeopVj1LZiTZgTI4Y_1780068216
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 1719A4000D
X-Stat-Signature: 1s5gzc5c1fafxc8ks95jg4r3yyhh4fsj
X-Rspamd-Server: rspam06
X-HE-Tag: 1780068219-80496
X-HE-Meta: U2FsdGVkX18FpJdiQD6J91jr3P8gW51wv13f8OWBmb32ZnBWNfqc7fUq5Y5faE1HHxKYZNJ7BtJsdb5KoluF2xE0hTp6ANngaj/65yEBISFaO8KnGu64lbpg1NFVtRmrh1t2HyYwOrTw8MlOF/3nXYlP/9ODPOdgnxdGOd2TkAuudYgEdOtLPS7l7t5PFd5vVAAdR0tBI1TLKI4lrBS5fOFn0VpBbt8ipIR/anXQ9VQhjU34WH5LqHqWwsax+oxNiqkSu7Z3hg+8S5lm2IHtP08ii8RydDNa5jh8CtHgDg/tuP6FHtDKgNkfEeOESCnYEFg4J3Dp5VT6JLphmvQJCvxANSWl4ZQWsJBkgbCytoU89Pv+9vJ+YZ+eXuc4gPcujmxAnp0qmj4midwj/UrQKk2qiw80Gm2oQD5STahnvCCOHAfnXMtvn6skE3YtrtZQ8toO/cNLXAJsSSEkGlYYV1n7XZGv0HOlNzb58prJtTh9EcMKjx0YSbzm1P3Nbfs4TR4DVwqAmOC/nE2mjN7UFmhYzp1gHg3SnxarSRp5/I3qbMBBKOqxYbuTRN9VG7EbmRujKDmK8QOX4sj01V89io/HlNZVvGSmyCzikOLa+P2XO4Yfcgh+5T8zObRLhu/B/l1B/JfUigFJwPsLZi/BzIB/XshXT+Cb+PDUu1DpRHzcyO50Lqu+7JYWoYuDOEF9kBFax5r932GNJry39EPTWpHU/FP8WOjPL+ry5naElsSnnwbF7ok3asHSHDdv+V/lN3HQ5EifH8DKbYI1hanEvogBE03ZsJRRK/vJTERGXWl6yK/6apuU42rIOgmgGQl9gCm0LbU/32KBtpPi0XjCadTPkMmWGXTYNzeV35xLZDy7rlfSUPoxgaeV8GpaclVi9QOVuOnkNuSnSukUXT8trVVW9l4ZrlZyyxPumWiif1cM0g8hEiOn2H6hHSv6FqzDnOQYeNhpZfpNmWYlM1X
 ucMu5RV9
 c6jAVDeWM56nIYNbGOS5oottIhMqUQbWLTMC4auWl7mN+eupZKFAyFUVcazScRHvffAogiIkQ1XBnNnE/FKhjXeKfjy9lfjOWTpoJevsIWsYuzohTjHrYbnIx8JL0zgdCUWcXir4aaK1YGavn8fQlbProCAngmeH/WpjYIYB2wysH4wGM7m8Ic2498yd5y+KiNwq1ow7NfIEuGaSqpQnOj98GhQTCkNjJ+W2ot2lABPKhXIfhmZ/gaxlrRivIOio8kxiJQepIlLAgs2Td85YYIMVt8fxNi1OvInaZ82ixjP8cFgrkGFVO9kUqOV1eCu2fhXthuom4oGxEbMLDZHk83eHrzvvwbpgI+R7nfoQTmBpHGMffZjGx468KS8dlAOezYkRz3N+QNmRiHZSkwN0BHlAZGams/wtdBcp/Z1ATjVBX/9OOQt1UDwZ163ojWDOyB7Wxpuv1DMlTUvUwFKygOCemAXMq78h4rcth7+uRVYprSyipDYl0HtR6UAbGerFXTNw/FxHySz8EPRtCTGMI4IK8L1mvLBtPBcnQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index adc228fe3578..895ac72121fe 100644
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


