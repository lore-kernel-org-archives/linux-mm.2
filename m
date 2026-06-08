Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FAF8CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BE26B00A0; Mon,  8 Jun 2026 04:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C2B6B00A1; Mon,  8 Jun 2026 04:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFA26B00A2; Mon,  8 Jun 2026 04:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74E46B00A0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:37:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77FFCA0A3A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:56 +0000 (UTC)
X-FDA: 84856092552.17.46D5BCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E176C0004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:37:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cD2bV1DT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zy4rtaIprLz/f2YXF/2fwOOOF4wr4AdMW87y/Btd5qo=;
	b=uifx6Rtm4KHkJNVuJeybXzeDRRgeB8hY9EEfdaYTfLm3m+ZHVUunTkUA0kLPAwyOmDj/4W
	HSxeowJwXpoiJk6KbDuiIdIMffu/Hew2DrAp/OzqBIHsEtWhJKRKEClsMfQ7LTsZXHldj0
	JzSYOOvfU5H9m88mVL7n3ahapeIh580=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cD2bV1DT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907874;
	b=5mFKdf0Yclwsx5t55Yrxx4TdnQEwSW89Mk6vQeQxQFFRuL9AYOGwLKxGsTr7onCmf9HuNF
	ucdjfYbAb+WwL4336Qh3r77o0dU/6kljzaaoZ+P33At2EGbMujiA/uyP5grVVSS+R38mt6
	9sSSWpMYqOHP7QoxiTft82asDTII5KE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zy4rtaIprLz/f2YXF/2fwOOOF4wr4AdMW87y/Btd5qo=;
	b=cD2bV1DT71XRlLqmDFAHP/q35pjD1eLqBpr/+qk58pbZ4pw1zt+rUErOVJlB4igVUYbvHx
	rgs3kqcd0/fPZcv5jS6lwiLJWtOukS7gJqJRFYkFCE7/n3rNvx7YeocRdxzAfUHR/n9rMA
	qWsHju3/rVy5tCLcMziVBsCTq/pRfqs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-cuWx40RoO76Ni98VI_hyTQ-1; Mon, 08 Jun 2026 04:37:50 -0400
X-MC-Unique: cuWx40RoO76Ni98VI_hyTQ-1
X-Mimecast-MFC-AGG-ID: cuWx40RoO76Ni98VI_hyTQ_1780907869
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b3ec3f7fso27074395e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907869; x=1781512669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zy4rtaIprLz/f2YXF/2fwOOOF4wr4AdMW87y/Btd5qo=;
        b=ODEEUCT6KiY6gj0ZD66H5JePvO7lvoM72WLPR+LYGuhcng6ZMyDYIZlWZdRHfKANrq
         IGazV3oHzEZJWgS4s5xz+Fcevei4TBIHfyFYEia10XTg04pO37GhldJ7+ffmDL4zAzd/
         Y9iEGhNPe3Bw8rUn4VLH+eujMHyC3MVMHuyZfF/FSaGbsZHeKcSmUKTYF8DHoiOIEir3
         DNzz+uxlAUGWlV0mfF7JNNEZwBxMEhPHCiEyORrsyVXXTXPW/PRhhyDGXcQG99P0haBB
         bl+EEvLEYkDCGBTmHXX+ECUvagxC7SUeeCQlBgpfFQUdfXFDeVmymE4bf2N2yco+2Y1r
         hFYA==
X-Forwarded-Encrypted: i=1; AFNElJ+IhUGH74Egvwjf3p+CzVg/mh1NqYSHTlG/XJcY2jKtl9ZQDpxtMgTXfQnbe3F7eNOdSst4vYJYKg==@kvack.org
X-Gm-Message-State: AOJu0Yyb3bW3BALARYCFBdjMKliyAy38WBC4KKS6OMwqXbGbufjXZilL
	8olHw4KdfDOw++xcvM2AuqwXYvTAe/UgkOgGzuzfsDtfR69DbBdYOBcYNdVUt9HRDUMSeIEkxB7
	MGdIt4K+eFT/JaDGpUBMxGFtKggrKdB/KNQXh/IRi9WP/2LWBkpYn
X-Gm-Gg: Acq92OGCa7LCvt+FORFLhyaPnpkiCvHbsNlZcN0Cxcev4RdCnHyiT3+V9iingwJO0tm
	QuAt3cd7iabEErL1rLozSSbkPigtTthuFUYWrBowbMaLDemvVhKSvOR04z3ua5k6/EJ4kRAC70f
	cm6Zlc+gLo9nt7ixc/GyjcDKZrUYLoK2zlwkZ+mIL28YOwp9/0/NMFbVzhfsM9eyBQMWhuqPaB2
	BezZ5J65y7Fh8eK4R+1Vs7ZThaWEK2hh3T8NpwLKluVSqFgkPYFoTd2UmtQdfdgkGSVNCj7jyEV
	sHRnKrPkzP1ux9UXPTVJGuLpcn0xgLAEkiBP+dfiN4mD8zuxIl6ok2io6pqcJA+qycSNcEMm2WR
	pNwVpr7zIj0whVR3xT+lIW2A=
X-Received: by 2002:a05:600c:1549:b0:490:c7dd:7cc2 with SMTP id 5b1f17b1804b1-490c7dd7defmr154053085e9.24.1780907869190;
        Mon, 08 Jun 2026 01:37:49 -0700 (PDT)
X-Received: by 2002:a05:600c:1549:b0:490:c7dd:7cc2 with SMTP id 5b1f17b1804b1-490c7dd7defmr154052515e9.24.1780907868720;
        Mon, 08 Jun 2026 01:37:48 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm450465175e9.9.2026.06.08.01.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:37:48 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:37:41 -0400
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
Subject: [PATCH v10 16/37] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <d2be78654e9dcc7cf5b8a542c2c8f331187c80c9.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: swBvIor1l_SE1gqz2OZtmlZ-m7iaaoqlZuhSiHz6PAs_1780907869
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4E176C0004
X-Rspam-User: 
X-Stat-Signature: hzik9yjqwgfbksyerrcgrygub6rtgdpo
X-Rspamd-Server: rspam09
X-HE-Tag: 1780907874-58035
X-HE-Meta: U2FsdGVkX1/nfRtcPUrdIxR92Uu4F6hbxb2KS2HPQiXwysKSyBr70LCi9fnCz9mdbu3UVuN3v1FCwoncDlKn7RZHD0tiK9VQIv5YSRBmZVI42rSkEmRsALtwtad9cfkUaSYOGV0lHUs9MHS1HTzcAyRSWY6Oqi9m5SKb/kRbSOF2UeAKYsAoR9R8NqpLlnXPo22Wp5+BF29iFgbz5ITwjoHW5ZnnYXQNIEbkgI3bH4HDTRMEpxwY29g6US9LbRL4+ZPSBwlxnVWfFt28HWSliPIDjs7i6QRnDueWV29bjh/XaXxtC8TYy0A9+HU1UCf2j+dfyWXhAxxoal6pRsW0pghn2rfBzDEg0VuOgfIgUdxTE5tqLLP/pK8oAJOwzCzDpMcxDYLaOe+1A/1yksmFv2xRtkSmA70F+lDRMyFdxW5f6cDzQ2DSeROvjllkmjbKMdkCU2LIsBgsd+aASFovypPUgF55GQfBExC6JuqyZdpACfZP5Y/FcIMucf29pz+dMGynD2jHsYl8mNGziXYmf3R2KKCokc1Rb0R9V8PEF+quaV/JeSiSU2FrPGCluwh7xQxYczSgMVX5CdUS+SE/qTwwKizPM01Uy7ry5j5saeS+yYQqjut0AtKZYtdjF86zuv36TfDHcujJnIhDu8t4WD3teNZKPrYjkYwU+jWLGhyzqwwo2QUTXMJ3VrvM3/AkCl0UtSnUYMJ1UJmLhjileo9JIuae4Ej/eFqVm2Zm9KhOVJ/v2jaAl26AEcAQC09Pl0VCl1Q0gj13Jt/mwEBfthOmrKA2JKKXbR+toreOnIImBf3AFIJYgQp0prCQdxzAWoJBr8d4iyfYPHrDQw7uCWwtFFiWN9++SbOssV/f5fGPpiPlFnpgbVz3zl8ipAvViJKa7QcS3eErgMc2wk3Fx7eQ7KU1oaUhVPBPA7+VOLO4ptQFtJH+4OeRiyI7XN1LyD7adu+vz228qfi953G
 FAIKhn7Y
 YL4JSHsneRZi1vx3kv4MSe2Muog3zt2NuO2rWiYdqupWTZDKoBO2nym9bfgnPAvCtby+lHIqDhvG36saHBBw46OmL1199TKxArbMTnT3LXvZvTeIsF6WFYsMbn2JjzczcJTrUx1Juk+nBUv5EJzpNs5b7nB4J4QTNVL54cVQ0B9kVrLchK/RyGAAvW/BYcHn75Mcr1ighIryzdSrKjod08WoxksKpDSEHD1FmaCY8d8wjPMCD3JDX6JfQHgQDYt9L0glb6jMi+H8cgkOCHd8Z/tb2rZNpzDEU4QXPJoPeHQ2KhK8JEhD15OhosVn2Ed72aaPLHJPsZ5OMm23bAjbR1Z4W3anZxWRuFIMotmgT5tLe6ZPoX9haRadGarb+2hmJ4je1LEXmZg5v0qdy3RZ81fn0+yBHWJe9BAN947LVhQNK0hz/GAsqyZCb0663lnhYaGvvcCL54aSO5i09jHO1fbKgH6uKcvcwpqUvSbdYvHlVnZrIhW63H4MLFAktgbdm9xRj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same change as the previous patch but for alloc_swap_folio:
pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).

Note: NUMA interleave is not affected by the raw address;
the ilx calculation shifts addr >> PAGE_SHIFT >> order,
dropping sub-page bits regardless of alignment.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 21f640674c4f..6c14b90f558e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4750,8 +4750,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
-- 
MST


