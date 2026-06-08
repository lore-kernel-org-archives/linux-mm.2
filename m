Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9477CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392AA6B00C6; Mon,  8 Jun 2026 04:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342F06B00C8; Mon,  8 Jun 2026 04:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B756B00C9; Mon,  8 Jun 2026 04:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBF86B00C6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C678D1409E1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:33 +0000 (UTC)
X-FDA: 84856096626.17.762A090
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CD1BC0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPgegDEn;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907971;
	b=Qzenr+IiWCV2JRuxBJ3UWfYypTSWGhuCmrzu34M24rNCKqOLFbn9yZemq6BvlPdxbavqVE
	pzH40Zl8Dsbm2lRtg9cPFrOZ9lDJjGc9E81okVeI+aZF3o2BUxTbFxBa77CB+nQ5rfv66Y
	/DXXW6mQySqqTdAhflYH7EWGn+LIbK0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BPgegDEn;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfQ8iRnJTK4n0bEkv49q5EiiPzQx8wAqaRkFNFNqcuU=;
	b=KzS7IYJbEig9tI3VjPrQNpXloPvNhBrAXvnThRilGKs9i+l9SAMl7PbP1xjEqspL3uzRTR
	NDFqXdEf7eKrapq9t9il7WLabHm20syy5U+AWqEoeFfDa+CFfWL/9d/gJVBMfjzCZrX0PH
	JYkQBjQNDOGJ9aDiB+mx+8U0PXeYnjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jfQ8iRnJTK4n0bEkv49q5EiiPzQx8wAqaRkFNFNqcuU=;
	b=BPgegDEnqrdgwgmDof7VAe1xhSIp3MwnnKOq7AsY+FsYd6HjE7hPbVdN+0TOcER4JD5mrM
	dBdp/BySIU0XgKaGsZL+294p44ZOtjlWB/Uuyy9sZsbcj+8EptgRSE5W4sQDEYJt5J5w2i
	G38u5VyBYqDbLyjyiOD9DCmJj+UXN/0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-ui-hp8LmMsWYBlAG_8QRNg-1; Mon, 08 Jun 2026 04:39:27 -0400
X-MC-Unique: ui-hp8LmMsWYBlAG_8QRNg-1
X-Mimecast-MFC-AGG-ID: ui-hp8LmMsWYBlAG_8QRNg_1780907966
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-46016bedbaaso1388041f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907966; x=1781512766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfQ8iRnJTK4n0bEkv49q5EiiPzQx8wAqaRkFNFNqcuU=;
        b=q4CJFAaRoUH4GDUhHFlXY9ZiZLR+r1pxdMzY++1AimlypcAgViwW55EbZvhWMGr08H
         4sXyi58y1OidObyPlFaFaxOSV6LoUixYcoUQiO+nImxt8y0921SfYOrLbuSEmZE2hYaf
         BBDG+YdR2/484pvc5XwwZroM84oQlUoKSClFhkW8zEzLeOyb+ujhLF3j6Ly9drEbDSNq
         QfbAM2VWCUpXc2cBDEtyLYeShJDpraY2CLE85j1Yj3cii6PVtTpv99Y3waU8l0gtCsTg
         1zLTk1iyX6pfp/Md50dzAmWFWn5L7bYSLd1meySpXXFBcuTEiEykGtrmPAQaQtk5RZj4
         L40w==
X-Forwarded-Encrypted: i=1; AFNElJ/drXonhwxkDZQbc5m71segTxil2DwEcipxbhy60ASVatW0DZGAoxoZYipMdBCd0WAqlu86UW+6EQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+9+Yv/z0eJf6FzeDugTEY05MttdQqMguDzKpaD+dwbVIFroZb
	CMkznUXGXUzVBdiMxbo6TMy5hbaleTAgERF87UvlGVBer1q6y6JmBWjB3d2b2RDXQPBXHRXo7yf
	RZ1cFBz6CEw1FoxLextW6HtLFP8PJTUezMTbwXz3xAbmYIJNWfIYa
X-Gm-Gg: Acq92OFX4cGqHxGvCKkSeOWW2gUCaEpH025Yfp9pwWVaeJP5rfhTcn5COHEdhwDfiGC
	MLPRaLHqHmSdcdjO0F1IeE7WObh7KdLEYjZU0qPWBElpt7Fup8ILHVDBRLZfpre8zgb148jbYXq
	5RbU3BhOdFK+MGVvakasOpXKjMbkE/PVeYlSHdGztNRbhJsN0wK3I3z2zRdc6kFmTPy5hoD0xxF
	kjrQFIKWJ74VMSYCVcvq/rpQPUu86yJ8ZrIg1jBOVVoVmu8gDOqE69KB5XQEbxa2bEfCcyaq4kL
	dvE+gNFSL/VIdqk8wJewGII1fK5SjR/IgIN+wwSTrQ9/K8hellHUwFZNENx357NQt7jQXwYLliQ
	tY/HYEze8OVR9pEvVrpMRWzQ=
X-Received: by 2002:a05:600c:8b70:b0:490:ae94:a7e6 with SMTP id 5b1f17b1804b1-490c25c20e0mr225777185e9.24.1780907966202;
        Mon, 08 Jun 2026 01:39:26 -0700 (PDT)
X-Received: by 2002:a05:600c:8b70:b0:490:ae94:a7e6 with SMTP id 5b1f17b1804b1-490c25c20e0mr225776435e9.24.1780907965793;
        Mon, 08 Jun 2026 01:39:25 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d30eeasm239643575e9.1.2026.06.08.01.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:25 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:18 -0400
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
Subject: [PATCH v10 27/37] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <2ee827fed4765a155d2b56bb0e13d7ee5fc6dce8.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t_hyqLmd2bcdtK2yx7k-3yFDO8he6PevZwq43Nz-wiE_1780907966
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5CD1BC0007
X-Rspam-User: 
X-Stat-Signature: o5wibw1sniw33fqwi6c69po55bim64tq
X-HE-Tag: 1780907971-133317
X-HE-Meta: U2FsdGVkX19wR/nMPMgQ2Q5SSul9zyr67vVPvi4hu47RpySxKzQaIzaAbBrV9dhYU5fVIbMUha7hq4T4WOL3Gdn083YSGa/XZDliJgPWBJ9NHb1R0rZud5YjJ9P15KtcaovcE5R5SYqYK4T0ltw41csQ/rS1hUnZnJbJ1Axz8pN1VBtUcHSeEYJVaWxiPqxJcYbuRFV3ygZdUMuSIFYX9AiFMkIb0ItryueJyaSQEhP024W4CmE8sL+53LXpU3ScTPmvtF3olrW5GbmkHiWgL2dErnTmz7kLyx0nadc+CTeNpQ8HgFES9Q5m1uJDRUO0S9IVPyKVnGRpA2nJiCVf6VZEQTGC5XQxBwwMuQO2wwfjnJNkAbWuLP3njZJp6SiyyzhrXJ5NgZij6Zl5Qe0n+cBT3AVUk9LUdAvArFZ3GqYWM3xkvOVVusRzKkRqEu8/BIpNFpo6Y/M1xngoTkO0DBLcRLLJB4xyP06AUuvXFDMha8FioOM94wYfdPgjE6w5BWKzkOUoUwspj+KLa3qmIPXu+S4MkqwIOZg5dKp2eKydIPCtxiiJDsWawAOAEJiQ0Cs7fTDSGPXCmPbnvRKB3DS6Ug01T/d0wPTr2MvroY3xUKRFhCBZzKUGIgdbdduTO3dFXroO7DnTyJxCfwvOhenlTohJVlts4oaNw/GtjKSujVbUG3ZAeyyb2q4NBeNfx/ZFWfNWbTrLXLSTimLTozfeX/VIfD77VMVIDZF36+Pwm2btDgZjSck6eZ+pdZ+6F+Rt1MO+cpsyBIraH4C9duh2RA+/p/09FOqrYhfu/eZxHTEsgs0Q/XBSTl86tRJ9pSznjI6RD7+jRzzjXW73zsR07HKp4tLqXcPq9fe8fYT2LIcJJJRBJavOIQ+clqJLEfxQcbOFaS26VHdqQ9o2STIWp+ngZhL9WtkyygKA2CxUCrlzxLs6hQB0I+EN3aXzyOvHnaaEUIsDH50pdbm
 eqeoyuu+
 gZ2V9iilg9uT3ges6O0v1z3WnTStXV+r4eOVKWTqrIR79tdaVququgHHsT7rltywk2jmuyLatu0jjboKX7dC6TcRVVbYr9Cx3P0j16Rwt35jfz9Lxgrh7pazsiQ7wJBjEfyh3UfplfDRNC7+v/rTk8NhJIDooS/9+DkeN+srwDpaSNDBkouvh13k8lmuS4ceu2kVKtLIRJeoXUFMTEJj9gIppNLXqMhmDWtvfzPllKl5fWwYmYRTHu9QTH6ZVRH28cn6DVWVUuxEC6krXukQAUb5nrJQu3pzOfOjoyi7s1KOUfmIK0XdGuF+W4wDIPdcDEfh+UF5VIzcorz882ugCgT3NFPGOWX+aQmh/i+V5rjfLrh6eUEQakGzddJ/OVX19zeBKVH56caplT/Ae2hrsDQpSG8lTDHGD1ULJ/vS7e5tuduD1daPL7i6EiTdsxYzm55z46TG/jERBE7YkpH54mpRVR3ydJG+oDWX9X+8ppV/MzmEZdhk8i8HPAeppLNcKGQiW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Note: before this series, replacing folio_zero_user() with
__GFP_ZERO was unsafe on cache-aliasing architectures because
__GFP_ZERO uses clear_page() without a dcache flush. With this
series, it is safe if the caller passes a valid user address
(not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
it to post_alloc_hook() for the dcache flush via
folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.

Note: with __GFP_ZERO, the folio is zeroed before
mem_cgroup_charge().  If the charge fails, the zeroing work is
wasted.  Previously zeroing was done after a successful charge.
This is inherent to moving zeroing into the allocator.
Charge failures are rare (only at cgroup limits).

Use folio_put_zeroed() on charge failure so the zeroed hint
propagates to the buddy allocator, avoiding redundant re-zeroing
on the next allocation attempt.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..0dec3c717ff2 100644
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
 
@@ -1347,7 +1347,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 	if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
-		folio_put(folio);
+		folio_put_zeroed(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
@@ -1356,17 +1356,9 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
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
-	 * folio_zero_user writes become visible before the set_pmd_at()
+	 * page zeroing becomes visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-- 
MST


