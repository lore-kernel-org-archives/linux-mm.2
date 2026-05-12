Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5136CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6276B00AE; Tue, 12 May 2026 17:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77076B00B0; Tue, 12 May 2026 17:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C956B00B1; Tue, 12 May 2026 17:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95C266B00AE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 645541405ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:27 +0000 (UTC)
X-FDA: 84760001214.26.A5D6D8E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31F1F160004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cEyZ+Qmq;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj9nBXTM7Pn45uNvAdcesuQTFKdusMRl11qP0Ml19S0=;
	b=i//BP0UtWjEctnbGNaH0+Vaw0aA0DmZSj9g7vCE7EOdNsPG+784vyk5rLMnpD5ZB4QEzED
	h9QTMVYAzkfHGRNCfB2aJwryeGvPb9uws/L4nkHgT6NmEz090D3lbfuZZWhS2pIw6iWP2U
	/nggIT3fOZRawv+LLNgoryax6BIT3fE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cEyZ+Qmq;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619985; a=rsa-sha256;
	cv=none;
	b=77FEOXjah5AmLuBLbP9bPvKTv+JBshM+1aFQbyFPpkuBROmKtPFcFUBhzustWYUGDrjbn0
	8vJEBPqUhiKBcJTNQJnQaojUdZcq3k3Uf5V3QtydWut1zJhE7mcldseKhV760aQvesKt0l
	1YmIc8QZxB/DKYNmE9NFcu8DN0zOuyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cj9nBXTM7Pn45uNvAdcesuQTFKdusMRl11qP0Ml19S0=;
	b=cEyZ+QmqJYb/t9Tj8saIDx2LtHwIfOc7Tm7xtHGNyd4L4Fx42AqDTfmLbInfdJ1FtPFtvD
	OuJOmXAa6DQ/SDhGbPOa/QWqlzNxQ7kOZTD7GCkR5dCWlXyS+pSqiBJ7kH0nsskCVl6MtY
	JaW2xXiMp1UbTPx3xwPXOcDZTn5aaRM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-r7e63PdqPCibumB88foI0g-1; Tue, 12 May 2026 17:06:19 -0400
X-MC-Unique: r7e63PdqPCibumB88foI0g-1
X-Mimecast-MFC-AGG-ID: r7e63PdqPCibumB88foI0g_1778619977
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fc9084562so3478255e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619977; x=1779224777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cj9nBXTM7Pn45uNvAdcesuQTFKdusMRl11qP0Ml19S0=;
        b=AqPsFewf6fa5lI0gVhYNxvEu5+5uSHCHyoNoOguCGwB6SYSq9G/hVYYWk529wx7T1b
         9cgdLrN5AZRl9vftRTdQ7M62z5MfjJJfEX7CxcjqRMVca7wLrH98QRRDMZJ+fmM7JEGN
         CqDPtfJoWCtWVdcK9yi1itbo5qLa/3Eu8YSHPpazor7+ZoKqQv7YVtalqHNq84LDf0Vy
         wC2xzMQnK6WXnUZ2gdOK7S/CFL6d8mBCkEgTsqryD7lzMFZxthJfAcJ+wcquEmfq+/gW
         KVCwezlvZGdG76DeCLeXqAzPXL4Gw1oCVmX4KOscAPsFosLO9+YqVemgtcf7TZQlSMV3
         HPjw==
X-Forwarded-Encrypted: i=1; AFNElJ+Miq7f0gnL3NynWfn7LUwb4m8EV3I9tS1GLoKxc+4pXMzhrb9CFNcZgCo7uVj9PX+2bE0VWOJgnA==@kvack.org
X-Gm-Message-State: AOJu0YxZYElMF35px5OWH3lsUABabwEFr9ogL0+8HTRWxnG9SIDMUlvY
	nu5v5M8xt9LJ4R6tHYRQQ9DIafc7w9f4wh8gt1tZMFUTha3tBpI4YR4P2LodLHaiX71ccylVtnB
	6h1HQtf62yCM7vD0nQYoaQoXQM26rrdmXKC+3c7G5SnvqvLamU1e7
X-Gm-Gg: Acq92OE8T4SHtooz/WcVDR20AigDBLii31bnAnQKZ+37wvP/rjXHxankLOgrcKQ8bQF
	FxtaDbmZ09j1D8alPZOyWfGKJW4OS/9dx47u0NcNM50hX+AxXCHquXV69/QCLWi4Ra/yaNNbpHQ
	mGI8vGktl4PwKKMovAK+12DsiRBRX/J9RMvgu+RCIkO+jEWUi5ZAwrM2kfe1jbuEifhA6dv5Ic3
	yeBZfL0IhTRLGW5JTmc8aoamblby/Id649AiPxyQMzIZXh5GbobhqSg3MTi/sPKnpd9Ae+NFwnW
	T/x2fKpORdvimyjQ2pFTIkc8kRhAk5fcL1LBGYyZeStRaa5tY1JMJUosGAjZyWz07eeIKSyCu2G
	dENrnZGGH7R6QnZ/S3D+ia8TnKEYwvuLy6l7WtL41
X-Received: by 2002:a05:600c:4e14:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48fc9a0eaf0mr6501645e9.9.1778619976797;
        Tue, 12 May 2026 14:06:16 -0700 (PDT)
X-Received: by 2002:a05:600c:4e14:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48fc9a0eaf0mr6500975e9.9.1778619976278;
        Tue, 12 May 2026 14:06:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d29c56sm22449935e9.11.2026.05.12.14.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:15 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:11 -0400
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
Subject: [PATCH v7 12/31] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <865e54aad878ac6627ba6633f35ab57a5e2d3c73.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B9fl5a9aYeWFQ_AMvyPklacL9_Ee0749DgLwfcWyVZk_1778619977
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31F1F160004
X-Stat-Signature: kh3xnki379kmhrw58rw9iwqnrjt8wnti
X-HE-Tag: 1778619985-358217
X-HE-Meta: U2FsdGVkX18sXSjAaZ0wrZGv7Vxf2sC3diCUy9ovi5m/uG/R6Yp5ndgsCBL4c0q78IuMXQrPtBGSENxkmA1zvmH2eVAa9EARQTskhWLUVhTlauBqhlYG2tzoaR/uJAFroOv2b6NvhSi8PFOKP+/D5hotNuQN5Fzp8KKml+hZQ9H0M3qr9wLQ2WLpZdl9CWm1YKozAfN9gBlYcWMJlyWVL1WV3lT2leXyiFF7RMQOq92PGnH9JCvhhPTo4ZMuvibbpkM7tEbQPLY1OEgo1dMZzMQSes7BLB8b1yzSDOj/XxJpsNULbQEohqjkLgAnSOzGAXaWKB+ksY2ECND+0S2RQBzvFfH7u6J2Mnukc57kAEgfH7piGxYFtNmmdx/OP3WS6k7sFVZV3mhIX9EgmhZR2D2D6NV1qWDDk3/4dfrrx4xWkQzlBJTvCnbppU2O7acgqfm4nSiMfqNhUKRsuk87nk7k1KSja/HvBHpGOKIZBNkiVQDRcaPOc1zeH7BvOKZspCWtz3KvDAbfyA/xKoSdBOkKmeaMzsoPVs1lIYKF/Sn88fgPLd63dRq4pvOM81gySDe5EG3o7QZ9IY3U5ppO/boP4y7KqjEyShxTSWd6kzaxdFuKWPkOP5VlF8oSTsE8e+ltpmHTFeW9EjvtLKSQRKVc+TChUqep/pviK1WmwkUFwT263utIK5spsAyFcKiw5ialhhKh2IGOi9i409QARf7PqeHWL3E/eR4hfu97MIWF6Fe1Okj+bR2m41QNUlkgTHiP5341TMh+tXeQMGyciQrD9x//Vo0AD+Chs/jmCiYbN+P3j0ecazEwlda39xVas8vaGRxpM69LtYMTf6OIe/ImCwXSG4SqSoQdrEnv/6wYONFp9wmgG/l+msjhCZV52ITtrXtUpiJUtAqukxmkjG8F1N03K2wklwacM5rJzF/LsnC42YJqYGV0pIH3As658aC/53dxy07a/QEclqo
 1KbnQnwO
 lZg7Nh4P8ho3xQs2rSQF/xE/GJXNCrivYYWMZ/08XSzg4Eg8JI+V6qSnlEgZoAdrEDrRvATvxtuNsJGt1xmSGEHIHFY1rv8/JktV1X6GiTD3VVCcybBP4cQMDpsTAja10EmIGByyvycOF515G+tHO3NkDdPTdXFe9ilvVO6EIJRXiPXVVLYgBIAQI6upMEICLcnfCZWQU3ZQaee7bxIpqZ9Cl4bP7rbAwZcdxZ0Cc46mLQZlPrXRPD7L2yqL6gEGtmn/Inn0b9s1DvrFE6+7CuqGw/LjG1cDQuWWd0wJU47udKI1ldgiLcplUDRF2uV9CJhrktHwmnRasO31PG4e/nFufSjYACAnI/Y+NnURtL0WkNoog1d1q42vtPY8HeiPPJ8/n7F6FuYnEeGLJCuHwmtB3V6YTVpOV4K+c+qy7g5zGY6oGV19+aYa+hofoCcVKt93pkrWnDNBFA4Ly36Rhj187azP+uOSo+Q65yTzDQK/2okYsUC9oDhpnsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
vma_alloc_folio_noprof now aligns internally for NUMA interleave,
and post_alloc_hook will use the raw address for cache-friendly
zeroing via folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..0824441a6ba1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5252,8 +5252,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
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


