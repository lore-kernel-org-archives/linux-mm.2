Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C828CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713A06B00B6; Wed, 20 May 2026 18:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB656B00B8; Wed, 20 May 2026 18:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600EF6B00B9; Wed, 20 May 2026 18:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4A76B00B6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D4A58D89F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:18 +0000 (UTC)
X-FDA: 84789222756.26.B2CA865
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2EBDD2000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="inElit/D";
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwGlO3yG5EtH2T+AQMoYdXPNyVEDsUWFS+ozJXrj1vA=;
	b=UNHD9aQtNMFPQ3ILmONOytb8uq6jzaN9f/Ik3gmbHVVBmmn2VVBm5MSI6cqsTuT2ffwu07
	m9GIqzd7D5Y8iS7T7o396V9vWTel0RQSu8wQHioQxYWRjZ2E2sg3B5jmzPLM3P8y0oMsJX
	en2jxokxiEGfxvoS639QwJfccmrPr/Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="inElit/D";
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315736; a=rsa-sha256;
	cv=none;
	b=sa4RDiUNjE8EWP/S/wrSqdFBdawLrnV+W5GUjn22fUgXXiCGRgsZzD8CeGIOlhHTLhy8UC
	AVlF9FzObjsFgPk8cCs3zqMKyv3TSY8fwAsDZ4eO0utleUiWghBniE/reM4Mi+V6Fd0e+L
	tg+F8JwsIyejO6K9VenwmjIMAma1uTs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dwGlO3yG5EtH2T+AQMoYdXPNyVEDsUWFS+ozJXrj1vA=;
	b=inElit/DOoITEQjsJXOQQnDSV1DI1XOXh/EQS7Bpb4D5sgiotAijkkCcqUgpP/H3Ew3CXs
	px+5DBLd2nwmG+B5QqQ53wcCmqcyeaK9OFby7WlqxPGiqnRGulK4/nzEQT0q11j9Sqvi7h
	f8xIojZJa542GGssJi/i2F5cD4owTDg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-didmrcPHNj2OVR5j6i21eQ-1; Wed, 20 May 2026 18:22:13 -0400
X-MC-Unique: didmrcPHNj2OVR5j6i21eQ-1
X-Mimecast-MFC-AGG-ID: didmrcPHNj2OVR5j6i21eQ_1779315732
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43fe791a398so4315457f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315732; x=1779920532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwGlO3yG5EtH2T+AQMoYdXPNyVEDsUWFS+ozJXrj1vA=;
        b=LJfqdrESSLLyrohqiUZJPZGniAotyuTI/9TIQsk91BeGyVcGCD1a+kwO42/Xbc/Ves
         qnAWqFStGJ1mr4+vjnPdPkAIIEmHcW9mep21jLIRVXJbgGS6qAkp4LjmgAR+yf65urhQ
         rRaWBxiD6ScqzHm0iSfmmLAzinZJoADtDkoRV34dOBtpj0oLd08QhMESlf4Skgg/m3xo
         sgUbdyQMe65cRQwoDSbu+gFstaHsg2v5PT+OaO1eAyJlbC6sWTDiBVZ+37gNwu+AeYQJ
         gBgpDCpmwRrtabfSWXcTUQgnax02By1F54lEPdxU9o7KD98IFA4pgV78WHOARmBosSbP
         Yp+w==
X-Forwarded-Encrypted: i=1; AFNElJ85vX0SFoOvqJEQnidnTe1ovj5TlAS4eqOpiYyxI267F6T0yCp7yvlq2qc6eOHD5X7xMFBzGpaFng==@kvack.org
X-Gm-Message-State: AOJu0YxRkcClwGjeuHlOgMTaJKZqx7izuSqhYFu8gOqpGyxjsdgEb7X4
	jQWosIHepOdQhqDKx5QDN0gqVz6GEn9EGEQLkHw1//mNI5YDRzFS8YbSxRTQlbmqn64yz4bqjQi
	o+GXDplNliuPwK1g+EcDgfv0ZPnf80lz8vQ0hoI/fjAEBz6wjtsy/
X-Gm-Gg: Acq92OGDsE6WFgSVmrOftMsAbbyKiZ5Ah/DNvivRhWSBFZI5fR00iXP11NnLKOcvmpR
	8G+KxOVcl76IqgQy3aKYFKmkiSBcsxIWPi+7JhTBiixUk3eTkOkzGMgi+sgiuhLP+p0llCkO22F
	toLtayNXSfxu1/PA9HaO8azAICJfwD5XmHhWSMRFTiI9tkTo+0Ye1iMuQP8WIfLeNeLAnFF53h4
	yrjCNb2XCKOT/sTWYHyPOP6YwzTEAdpTS6dLARk/U8BK9vk2js59E5bOXomQokaqxOXfDC8Ts2R
	Jkvc01dHRAfJDyB+4c6iMdbdjGi6p4Fip/NNuUOfaP31U3GspyE4gTN/YgCLKhVaIbHvPEmIWhx
	jZSpxdFbPUP+5i4IUEXJJOoW16iQu4aUGqSqhS5trCzw=
X-Received: by 2002:a05:6000:402b:b0:45e:73b3:8118 with SMTP id ffacd0b85a97d-45ea3bee76fmr278664f8f.29.1779315731723;
        Wed, 20 May 2026 15:22:11 -0700 (PDT)
X-Received: by 2002:a05:6000:402b:b0:45e:73b3:8118 with SMTP id ffacd0b85a97d-45ea3bee76fmr278599f8f.29.1779315731226;
        Wed, 20 May 2026 15:22:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a19b1dsm56913999f8f.17.2026.05.20.15.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:10 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:06 -0400
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
Subject: [PATCH v8 19/37] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <0ec029361949c492b10accc8cd787aa0d2fef0df.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wEpxURDPIaETVRoJ_9RlaHc1u5fAGxiBsRFJ6MhnuQc_1779315732
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2EBDD2000F
X-Stat-Signature: cjy8gb4mimxdur9wmu59kbrzqwc5ccxa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315735-19900
X-HE-Meta: U2FsdGVkX1/d9s6rt9yfUp9w7jwLnmX/yHsglvnFwHrEwJArwM/gH0o/C6R+Gb2vHfKzoeFYIc6c6S/7eDJUSoUPeu3m+TGVE0oirCnDI9f+47F6pLT3Hpb9Owggq2xDAjQg1UZhi23yfMWSUhdLNng61m8UZA6RqctP4MPXBE1QMM+HUjF4OCB6K9qDNtAkVhmPYkargzOXTDRCG9SeuRXAlqSF7IvBk3f0eNZBBXnKmIh/7m2BZUG+NxuXJANN29SwjwliheEcUTCKVyVP0ka5yv2I9hi4MYUhWzgY9aY8eJHBeR4sx8ubhptm/iuYV+VocecdAiN91S99jZPN2pm2HIRug8jgMWW7Oz51hBPQI8TpAjJa1sMBI/bBYsprY8IPkjSwl1WPLaGO+rROfsARY/Owb2KJtJzvtyI6SeyaoySvM6jLLQHOGe6pSjeC7P/nqVncxk8DY0aUJRJGZHKI0Zpk8kXND9JqTPWsnHpgxP/xyc8zGxaM7icZQcwgzj9yjEusJakwbOS04Y+EsGC+lHDAEH4wKhZlj/BgZ4xGGQPyZUlho492xcik1wO8em1qD3Wsxcty4P3fiVZ7S62ASCAHhWCPQ7ORV5H2CUGtmEE+Iuuq45VZzzMefR+/OtJ/qIEqnGr2jtlk6uKJvTJ66l3Nev0mVIVkJjrLKUHd1Q40JCl0GjkYACluG3YFliF3y0FCe18CuQlhU87g8hvVY+SVaX+V/BLsO7BecpDBNUzwRFoesv1Jr+cZNGUoKa+b76zs6r2YUlhLSll618rwyrPSjyT+fTwrvqu7C+46LNny1DDGx0Mu1IcB6UBKaDLF0lhDHxcIfHin57OcG5YWRH4T0cOb4RUxADPvdImRPDzhVYS3D71JUu94pPql8tanpHQ5DRtKZxLw25VOMCYf0iInHTUR1rOh+nHDedQl7I/i+IglwRcsuBStU28ozEak3KM23dNJTKUuvrA
 +BgYzMuJ
 V7e8XjJQuqP33pdJSDPvVxpIQ48+KSBzG8h3Et0Wo6bYiuIt2UvupAXgEqF+pB96/kh+6zfX7xRHnzCPbMZLwpjcRtTWONoP4rwWssa+PKV1iwEX4uoDSNn0hbrUrDZMysdM8XJ3bVfQhum9DFlXliiHNn/gnP+aEH4qjZHatnsGegjOYVlJss79eUWroXBWx7ZrxsbfSK7PgjI49qUUk+Kb1FC9yRTJ13PmGShYxlzNjMPhpgGRiqn3SiYNzPDjDVXJLRglPmOB7dE03uwtd4X69tK3u0FF1ViSCxboCm0I9QeYikj5nreuhHH4Le8hhe90p+IGigQCVC3YbywDWsv/OCVcWdUFR5B9jLFH1zRkRN7QgkF4tQmEOSDc0GkagD9vGIsU9PWj294JQP6vLbl8HHsrD5qQ1uJDaZAR7UYjsOD6fvr5M/TIpMDYFC3DRpByqcXdtaH6ND5uI0E/4K2hxOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..9845c920c29c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,14 +1356,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


