Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE032F531CE
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 23:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC996B0088; Mon, 13 Apr 2026 19:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4176B008A; Mon, 13 Apr 2026 19:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3676B0092; Mon, 13 Apr 2026 19:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A90C76B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:43:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D84B1393C3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:43:25 +0000 (UTC)
X-FDA: 84655161570.03.4697C1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB14CC0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:43:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DySP4msY;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776123803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rrHBMwIcyGP1TDqJaHFpo+4dVRRUvWP/FDyIB9iTZ0=;
	b=XdgbQq0tNtkrbht/Ug4JPAOeexyWHO158UR+2+nkbQQ0vcMYE55F0JB6EX13txK4htn3dw
	uufwaJXe67uxw5d8rw37yBfraDlvTTFsL4DHf3fGig25mZSFSe+AYwHaDuqUdMA/EOJe+C
	uLiSO0va/ZGZI19HU7n/JAMIZQMI5DI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DySP4msY;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776123803; a=rsa-sha256;
	cv=none;
	b=L3qGuzDgslj3VrylL6PMaEd1/HHb/bHz993A4oRcZj1dudYiDa6r907r3D8PG+4irjXF9N
	rAVfxnm6E+TprwLD6zyA3KBp5exnfjdAhw/Fydv4xlqaC+b3VSk6CDeeZFc+5LW+lFeibH
	WIQebsg0qfKYcT3CizkzOuv/XDRCSdU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776123802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rrHBMwIcyGP1TDqJaHFpo+4dVRRUvWP/FDyIB9iTZ0=;
	b=DySP4msYHMqf7XejrAUaaOThTMDfLdFlkwMVaqgsVSXDY4G54EScMOYRqJOnts6rsMhkYa
	kY9N5DYjQBn60jzAYDuy8TWur7sS3Yj66IeBIpLjv1+fi/NKAmsrwE8RwzT/N5HwfR/d5w
	ZvSE0THR84XYWScl/I7TCPSBTFuVnEA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-73dVz_TePxOyOYFXGuavjw-1; Mon, 13 Apr 2026 19:43:21 -0400
X-MC-Unique: 73dVz_TePxOyOYFXGuavjw-1
X-Mimecast-MFC-AGG-ID: 73dVz_TePxOyOYFXGuavjw_1776123800
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-483786a09b1so52906815e9.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776123800; x=1776728600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rrHBMwIcyGP1TDqJaHFpo+4dVRRUvWP/FDyIB9iTZ0=;
        b=iD8Fwvh4se/HKHPExdbztkJZaa8RBm8Pw4GKvZv57XpQxif6Bq/VS8VYmClhvdi0Px
         KTcMlD/+3et4d7CYB36i4xhWnPFo+Lt+XLLEOD0tZQxry0mrFn2UckVqSBhS6S4c+GEP
         SZFERHVpWy53q0039xZYKJTpF0NnEa7dS/wWt38FgZNxf1vfxgw/MMg70Gsli6B/gnmR
         rxFkExq0ZYl7dRx5kyZgoCDpFibi7b1bMOVwCXAUf0MoBxOpiAeNB7WJxGzNc0tTDnZC
         Kae543M5av/Qs4idNyR3FMR3RfAJ05OLuVgW+jK9AvOEn8s1Cr7aB51nnUTVhyCGWYwB
         esrg==
X-Forwarded-Encrypted: i=1; AFNElJ9nc+Hh+VyVyPKr9UnXvqfddheJPgem64B7NPDj2cmhzPLiC+1C/cn5Vp+r1yTty+jF0XKlRzobRA==@kvack.org
X-Gm-Message-State: AOJu0Yw3jKFoqtUEJIJvGrMWH+eirumhx7DIakruPGhe8MpBVoj9x0Zo
	k71GXjZq4bHZMtcbY1KnF52uXFUmhtrBLDpQNQ8aXENzkAuE+kZjrg2uwURjzlpGXvUekxntVjK
	F2vvm7Udg1jzl05nrEEm57lF9eiDrVQMPpvOlMZu7M8weJMmECKfj
X-Gm-Gg: AeBDieu3/RNfnoSIcgrpDJuxEH2JaJcBGOGpe57ITgvO969AAHsAavATUq+XoC2awHt
	4nIyqU4VCFTC6whkyu8ZrhirSB6cjy9ecAD9eGFNvny6235Sp6MhSfPI91EJONHk2Y2SHnWsT1H
	iEz2xfdv8gbFE3e7ZiAHYrNkUK2+L+4lvt3VDPlym1k+1XF88DaAzIVRYimBjSicw2NljatDQSe
	MixtxUJYdgJkDiHL21yk49kjayHUld/9PcWmWTVxWDp3Haa7pz0tyFdlNs2LFtQ69qvTVB3ysQf
	9Axm/JbXdXrVVUvFi4ij7/P0hQYPjriA9GDX3SR7c/6BOt3+WwrzYrEx2oabPieGH1nsQddA59K
	D7nBIODYaoOT7v8+OSiJSTJZ/kgYAPPLlAlGuOvSaobo=
X-Received: by 2002:a05:6000:22c3:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-43d642979f4mr20761424f8f.8.1776123799387;
        Mon, 13 Apr 2026 16:43:19 -0700 (PDT)
X-Received: by 2002:a05:6000:22c3:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-43d642979f4mr20761400f8f.8.1776123798818;
        Mon, 13 Apr 2026 16:43:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d73e36e7csm16689036f8f.10.2026.04.13.16.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 16:43:18 -0700 (PDT)
Date: Mon, 13 Apr 2026 19:43:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260413184022-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413180303-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260413180303-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XSScSWKXKPlFxArqtvigtsUUuezDqOr5ojdZ9Z82Bi4_1776123800
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: DB14CC0008
X-Stat-Signature: 89jr6bgsgpnc4e5yxbwq9sfio9ftjzis
X-Rspamd-Server: rspam06
X-HE-Tag: 1776123802-249165
X-HE-Meta: U2FsdGVkX1/bl9iFbXNxmnw79xIB++uZNOB6utqe1J8b4wffCLyjdpYtmkQPEHqfU0rwHRTyNnXQXSVjIzq8soNGZXo85qH4AS0v7Zx/ytYZrfh7XG+yt1oouJm/+P/gHn0AjjuLKjBS7S61Fu4b2qkyB85GTeAPS07g6fEKK0mJPO+cYueZn5DhpvFOd1Am8NekH6YNKWDovtlUEjGh4PwF6dhWGbkj45Sioa4j+FKdPB+Qjz+NO+7lY2fR19CavU/DcLp4Us7D5+ZAABIouTky1rVG4+4oUKPmHgb2cMs+DnO9Ll+M6lN7LacbZnB2BZTBUwlqJRaqDYW/YoduZWIx/3LH9udq601KYcE6jeISatVUbSmylOCveB/vtPCGARdo7VU3dn6NrLnKH8rD29RcUC4E6Lyx7v6liy4K8Nbj/ya9kUzAjtaoJps3YMO7HftfIz+5EshDwauDZCBy9YEN5Xe/5XCrlJRhg3eu/wevRrfHBbcJc7I+YwuPr7qk7w76TfMG8H1Bt/293iiRLdGmIpEacLFAiHVX2d4cEWm0+uIfvHdxMfviAsuh2Z2MBUTliLXkScuSYXfxs7Aly6WOnxKPoy+aiQLcofXrFk6+XfPs4G4kBmDHUFux5YW7YG7EnLOF5Fd20uZe7RYYCpDo4Zv28qhgyS5Fosg8trzBP3v+FU6lgWneCEQvoXcOvY2g13370tdeJ8btd5GbFZA1maD1X0TXFu+Y4P870iv6dKVv+Ree4y4+IyGad6Nt9Vdk4PNbfGSFvYLJxmZuRJQGQkdU2LRwkNvzsF1qZf4Fuy+rh5k3JZ9yMDH/jWFJqvJ7noEnxtWQVrslrcY4cqyWahtZKnm/63Go/qn3ZYpTwkOUnFnw4VrXpBUpOMPm+LZt64vwdyg3OFLFyN5bDoIbfwhVUvtkn1OB+SFbpEXZ/AdAQiKbyr1+5j0mcBG0U2nb1jwX846T6fEwn91
 pHTfjeBl
 wNE8Wy6gsK4alyKOxtpbNqFIMT7JA/ciZOs5I4tdvy4LcCFcE6WI2DesIZ4QY2uOp1iH8OgKhcwAaq54o5Lo5wckXgwnc5dqY+bcOyHYtnyoj8fbjZaoYn7+oxdVd+0H9dLChJ/mx3n86puu8e6r0pimb+eXB/GmQekJ0CNJhWeEWjGfYK18CfFq0bpe2q7sgNXVEJCJ2OWtU02pPDVrrt2rcRwUm7IGJQkKzEVri80D6hMnEDIP4IAT5Rv4X70AK2lyL0TFEqs18Q4Gp+ZPMisgm4El0NPcqb/5tKeERV8/w3FJy2MyUItX15rMSv9ICliCfsRDl3ljbKfNNPokM9/rj+7riC6Q3mUbGC9ZDwsp8mb9v6LChFXNP2QTp5RKC+U1M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:06:14PM -0400, Michael S. Tsirkin wrote:
> On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
> 
> ...
> 
> > (2) Use a dedicated allocation interface for user pages in the buddy.
> > 
> > I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
> > 
> > It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
> > all that.
> > 
> > 
> > For example, vma_alloc_folio() already gets passed the address in.
> >
> > Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
> > folio_alloc_noprof() use a buddy interface that can handle it.
> > 
> > Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
> > do what folio_zero_user() does, and only if really required.
> > 
> > The whole user_alloc_needs_zeroing() could go away and you could just handle the
> > pre-zeroed optimization internally.
> 
> I looked at this a bit, and I think the issue is that the buddy
> allocator doesn't do the arch-specific cache handling.
> So allocating it is a fundamentally different thing from GFP_ZERO which
> is "zero a kernel address range".
> 
> So I don't get how you want to do it.

Oh, wait, do you mean we thread the userspace address through all the allocation calls?
Like the below? This is on top of my patches, on top of mm it will be
a tiny bit smaller.  I can rebase no problem.

But: isn't it a bit overkill for something that is, in the end, virtualization specific?
It's all mechanical threading through of user_addr, but should we miss
one place, and suddenly you get weird corruption on esoteric arches
since we will get memset instead of folio_zero_user.

Worth it?

Let me know.





diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 301567ad160f..3b444a7b11cd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -828,8 +828,6 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		if (!folio_test_clear_prezeroed(folio))
-			folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..06b71beed0a7 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -227,11 +227,11 @@ static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned long user_addr);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned long user_addr);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
 
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
@@ -286,7 +286,7 @@ __alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, 0);
 }
 
 #define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
@@ -297,7 +297,7 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp);
 
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
+	return __folio_alloc_noprof(gfp, order, nid, NULL, 0);
 }
 
 #define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
@@ -322,7 +322,8 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid);
+		struct mempolicy *mpol, pgoff_t ilx, int nid,
+		unsigned long user_addr);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr);
 #else
@@ -335,14 +336,17 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
 }
 static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *mpol, pgoff_t ilx, int nid)
+		struct mempolicy *mpol, pgoff_t ilx, int nid,
+		unsigned long user_addr)
 {
-	return folio_alloc_noprof(gfp, order);
+	return __folio_alloc_noprof(gfp | __GFP_COMP, order, numa_node_id(),
+				   NULL, user_addr);
 }
 static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	return folio_alloc_noprof(gfp, order);
+	return folio_alloc_mpol_noprof(gfp, order, NULL, 0, numa_node_id(),
+				      addr);
 }
 #endif
 
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index b9c5bdbb0e7b..6c75df30a281 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -56,7 +56,6 @@ enum {
 	___GFP_NOLOCKDEP_BIT,
 #endif
 	___GFP_NO_OBJ_EXT_BIT,
-	___GFP_PREZEROED_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -98,7 +97,6 @@ enum {
 #define ___GFP_NOLOCKDEP	0
 #endif
 #define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
-#define ___GFP_PREZEROED	BIT(___GFP_PREZEROED_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -294,9 +292,6 @@ enum {
 #define __GFP_SKIP_ZERO ((__force gfp_t)___GFP_SKIP_ZERO)
 #define __GFP_SKIP_KASAN ((__force gfp_t)___GFP_SKIP_KASAN)
 
-/* Caller handles pre-zeroed pages; preserve PagePrezeroed */
-#define __GFP_PREZEROED ((__force gfp_t)___GFP_PREZEROED)
-
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index b649e7e315f4..ffa683f64f1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,15 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_PREZEROED,
-			       0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing() &&
-	    !folio_test_clear_prezeroed(folio))
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 07e3ef8c0418..e05d14536329 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -937,7 +937,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	gfp_t gfp = __GFP_COMP | __GFP_NOWARN | __GFP_PREZEROED;
+	gfp_t gfp = __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 
 	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 342f9baf2206..851ebf1c9902 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -682,9 +682,8 @@ FOLIO_FLAG_FALSE(idle)
 #endif
 
 /*
- * PagePrezeroed() tracks pages known to be zero. The
- * allocator may preserve this bit for __GFP_PREZEROED callers so they can
- * skip redundant zeroing after allocation.
+ * PagePrezeroed() tracks pages known to be zero.  The allocator
+ * uses this to skip redundant zeroing in post_alloc_hook().
  */
 __PAGEFLAG(Prezeroed, prezeroed, PF_NO_COMPOUND)
 
diff --git a/mm/compaction.c b/mm/compaction.c
index d3c024c5a88b..9c61fa61941b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE, false);
+	post_alloc_hook(page, order, __GFP_MOVABLE, false, 0);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1833,7 +1833,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	}
 	dst = (struct folio *)freepage;
 
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, 0);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..867bfe0c1d37 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -998,7 +998,7 @@ struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 
 	if (policy)
 		return folio_alloc_mpol_noprof(gfp, order, policy,
-				NO_INTERLEAVE_INDEX, numa_node_id());
+				NO_INTERLEAVE_INDEX, numa_node_id(), 0);
 
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3b9b53fad0f1..ffad77f95ec2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1256,7 +1256,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_PREZEROED;
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1279,14 +1279,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing() && !folio_test_clear_prezeroed(folio))
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5b23b006c37c..8bd450fac6cb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1842,7 +1842,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 }
 
 static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
+		unsigned long addr)
 {
 	struct folio *folio;
 	bool alloc_try_hard = true;
@@ -1859,7 +1860,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
@@ -1888,7 +1889,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, unsigned long addr)
 {
 	struct folio *folio;
 	int order = huge_page_order(h);
@@ -1900,7 +1901,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+						 node_alloc_noretry, addr);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
@@ -1914,11 +1915,12 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
  * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask,
+		unsigned long addr)
 {
 	struct folio *folio;
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL, addr);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
@@ -1958,7 +1960,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry, 0);
 		if (folio)
 			return folio;
 	}
@@ -2127,7 +2129,8 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
-				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
+				gfp_t gfp_mask,	int nid, nodemask_t *nmask,
+				unsigned long addr)
 {
 	struct folio *folio = NULL;
 
@@ -2139,7 +2142,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, addr);
 	if (!folio)
 		return NULL;
 
@@ -2182,7 +2185,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 0);
 	if (!folio)
 		return NULL;
 
@@ -2218,14 +2221,14 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask, addr);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
 	if (!folio)
-		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask, addr);
 	mpol_cond_put(mpol);
 	return folio;
 }
@@ -2332,7 +2335,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * down the road to pick the current node if that is the case.
 		 */
 		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-						    NUMA_NO_NODE, &alloc_nodemask);
+						    NUMA_NO_NODE, &alloc_nodemask, 0);
 		if (!folio) {
 			alloc_ok = false;
 			break;
@@ -2738,7 +2741,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+							      nid, NULL, 0);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -3434,13 +3437,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY], NULL, 0);
 			if (!folio && !list_empty(&folio_list) &&
 			    hugetlb_vmemmap_optimizable_size(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-						&node_states[N_MEMORY], NULL);
+						&node_states[N_MEMORY], NULL, 0);
 			}
 			if (!folio)
 				break;
@@ -5809,8 +5812,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		if (!folio_test_clear_prezeroed(folio))
-			folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
diff --git a/mm/internal.h b/mm/internal.h
index ceb0b604c682..b5df7c673ce7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -672,6 +672,7 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	unsigned long user_addr;
 };
 
 /*
@@ -888,13 +889,13 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     bool prezeroed);
+		     bool prezeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+		nodemask_t *, unsigned long user_addr);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610d..3ae80c25a51e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1055,7 +1055,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask, 0);
 	if (!folio) {
 		*foliop = NULL;
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
diff --git a/mm/memory.c b/mm/memory.c
index 2f61321a81fd..beb6ce312dec 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5176,7 +5176,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma) | __GFP_PREZEROED;
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
@@ -5187,16 +5187,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
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
-			if (user_alloc_needs_zeroing() &&
-			    !folio_test_clear_prezeroed(folio))
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..d5fe2da537c9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1454,7 +1454,7 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 	else
 		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
-	return folio_alloc_mpol(gfp, order, pol, ilx, nid);
+	return folio_alloc_mpol(gfp, order, pol, ilx, nid, 0);
 }
 #else
 
@@ -2419,9 +2419,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask, 0);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL, 0);
 
 	return page;
 }
@@ -2437,7 +2437,8 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
  * Return: The page on success or NULL if allocation fails.
  */
 static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned long user_addr)
 {
 	nodemask_t *nodemask;
 	struct page *page;
@@ -2469,7 +2470,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, user_addr);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2481,7 +2482,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, user_addr);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2498,10 +2499,11 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 }
 
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned long user_addr)
 {
 	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
-			ilx, nid);
+			ilx, nid, user_addr);
 	if (!page)
 		return NULL;
 
@@ -2535,7 +2537,7 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id(), addr);
 	mpol_cond_put(pol);
 	return folio;
 }
@@ -2553,7 +2555,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 		pol = get_task_policy(current);
 
 	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
-				       numa_node_id());
+				       numa_node_id(), 0);
 }
 
 /**
diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd..e899b0dc2461 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2202,7 +2202,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, 0);
 }
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 57dc5195b29b..65f4f9ebd4a1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1864,19 +1864,14 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags, bool prezeroed)
+				gfp_t gfp_flags, bool prezeroed,
+				unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool preserve_prezeroed = prezeroed && (gfp_flags & __GFP_PREZEROED);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
-	/*
-	 * If the page is pre-zeroed and the caller opted in via
-	 * __GFP_PREZEROED, preserve the marker so the caller can
-	 * skip its own zeroing.
-	 */
 	__ClearPagePrezeroed(page);
 
 	/*
@@ -1923,12 +1918,17 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
-
-	if (preserve_prezeroed)
-		__SetPagePrezeroed(page);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * For user pages, use folio_zero_user() which zeros near the
+	 * faulting address last, keeping those cachelines hot.
+	 */
+	if (init) {
+		if (user_addr)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
@@ -1936,9 +1936,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-			  unsigned int alloc_flags, bool prezeroed)
+			  unsigned int alloc_flags, bool prezeroed,
+			  unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, prezeroed);
+	post_alloc_hook(page, order, gfp_flags, prezeroed, user_addr);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -4010,7 +4011,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 					&prezeroed);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags,
-				      prezeroed);
+				      prezeroed, ac->user_addr);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4245,7 +4246,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags, false);
+		prep_new_page(page, order, gfp_mask, alloc_flags, false, 0);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5239,7 +5240,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, prezeroed);
+		prep_new_page(page, 0, gfp, 0, prezeroed, 0);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5253,7 +5254,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, 0);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
@@ -5264,12 +5265,13 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+		int preferred_nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = { };
+	struct alloc_context ac = { .user_addr = user_addr };
 
 	/*
 	 * There are several places where we assume that the order value is sane
@@ -5329,11 +5331,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+		int preferred_nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask, user_addr);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -5341,10 +5344,10 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 EXPORT_SYMBOL(__alloc_pages_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+		nodemask_t *nodemask, unsigned long user_addr)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask);
+					preferred_nid, nodemask, user_addr);
 	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
@@ -6962,7 +6965,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, false);
+			post_alloc_hook(page, order, gfp_mask, false, 0);
 			if (!order)
 				continue;
 
@@ -7168,7 +7171,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, false);
+		prep_new_page(head, order, gfp_mask, 0, false, 0);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index d2423f30577e..1183e1ad9b4b 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -57,10 +57,10 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
 		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
 	page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
-			     numa_mem_id(), NULL);
+			     numa_mem_id(), NULL, 0);
 #endif
 	if (unlikely(!page)) {
-		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL);
+		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL, 0);
 		order = 0;
 	}
 
diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..367ded4375e5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1927,7 +1927,7 @@ static struct folio *shmem_alloc_folio(gfp_t gfp, int order,
 	struct folio *folio;
 
 	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
-	folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
+	folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id(), 0);
 	mpol_cond_put(mpol);
 
 	return folio;
diff --git a/mm/slub.c b/mm/slub.c
index 0c906fefc31b..a514a3324e8a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3266,7 +3266,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL, 0);
 
 	if (!page)
 		return NULL;
@@ -5178,7 +5178,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, 0);
 
 	if (page) {
 		ptr = page_address(page);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..f7cbe17a881b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -568,7 +568,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 		return NULL;
 
 	/* Allocate a new folio to be added into the swap cache. */
-	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id(), 0);
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */


