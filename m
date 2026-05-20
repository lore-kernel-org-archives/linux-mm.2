Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791B1CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5236B009D; Wed, 20 May 2026 18:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C096B00CC; Wed, 20 May 2026 18:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91B76B00CD; Wed, 20 May 2026 18:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAE5D6B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52D1FC195B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:14 +0000 (UTC)
X-FDA: 84789225108.17.BABB7F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 217771A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XrC6ilrs;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
	b=aVfOspqjjXfrWWNxICuU4KW+03O4cTzdWAAiR/R2NrDUZFurd+4W9Off5J3jogrS502alP
	8uN0N2fnskJmxqAStvFB1pyLAzHfKy2NqPcRAbZ7mOWpKqO3kCTwP5fA0zIyaRs78jWyjS
	/x145NzYFeIghSdlIGeDeaJ9xmE7eOY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XrC6ilrs;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315792; a=rsa-sha256;
	cv=none;
	b=XoiKJQSHaev/xavmzFc0VO5pLm1Botqy+zF+mcRn+LZmokHjUGdAwAc+qvtWJPqp8qAiVt
	ovmYZdcNqmm+kTB4whU9kRS6H8gzQasYeTTVi0ks4F2k6H3VVAqZMgGononmYr6be44h8R
	uXAOepePZZYQOQ6b9tPJ66OZmvkVYdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
	b=XrC6ilrs/xio5OzIeuXmic0SrHw2NYcD5RQNU5IGaU7BWUSWDQzr/es5ZwQfsss5kLw3Z0
	FS7tAPQ9IleuqyqJUwkjsEnZjtf8s68w8EUxRnzbJvhLydYsdCxlIPNAYT1FS0aF5C54/2
	3IkR3WFRKJLwmOuWp51ZVobCg4X2CkA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-3MafisD0NHK7jnio9wdCtQ-1; Wed, 20 May 2026 18:23:09 -0400
X-MC-Unique: 3MafisD0NHK7jnio9wdCtQ-1
X-Mimecast-MFC-AGG-ID: 3MafisD0NHK7jnio9wdCtQ_1779315788
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44a71109b94so4016892f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315788; x=1779920588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuucL8pRyKGlavgC043yPLfH9MArN/0/T/V0zfd6qpo=;
        b=YVMtX52B6UxHHrybg+8lPM6WMO902aUBGmXd6bsTvY6Fipyn35qM9KSpqBg8UYqBuH
         qe2xBiLaUvXQrqz9oV3/qhuvAY1Gjrv2o2+29M/Y6LWGub87VBBnJU+bfxvLm/CM5MyT
         X3mfckJNLg5ps+PzvcLlJUhrXV4b1zDktMEcjrS2zxc9NPRgDHuFuoXTqp9vzKgZK8bn
         bk/geiTQ5HqIdbdioBySs9DWjmCOLVuXfyuTdX3v0BzySiKv5cuN9rEBESsaJ91c2oJA
         KixP4GrEgS/Ku5WDgSMeK2V1eZD51n6RZj/ofqChOUYxL0ZMU7Dw/qt4Ia3SGuJtkPNs
         iYQw==
X-Forwarded-Encrypted: i=1; AFNElJ+k0lHSw+qLqPiI9KKlx+P7QRRxalKl73V+V4lv3ly0OrOfLXHsvacMjbrJoNMgl0mjY9B5cOx4DQ==@kvack.org
X-Gm-Message-State: AOJu0YyQtmb5oXo44wsfZTxGpDPKLj8BeM+ZaxzxFzRkyVQL7YvNIFu5
	JWJsgg6OdtXYicEF2V4QkhHF/ua/n0QoWXz8/o/yNAQG4HWiAleSkp5G4yNysO06a4w/Gk1ZGnL
	G17C6HtqJjzYh1rD65iYD6eaCgUIerTWNnzW1Kt7hr1T6VO7+yuw+
X-Gm-Gg: Acq92OG4EViLKWFghPk6hdpSy9UYdzWyMOW93Y7n/oHI3BWIl9jS71TRHWDXswb1X/I
	EP2jW8ZQroRI18l6FSstGUgwRwdAYVOQ5v+DRzQYIWYwUWJSpSpAyMRMfs7MDo0/X6jGg9dT7yf
	KfXS9lzmXvgAHBgH9tPCoPd9B0apbCkdnNVcVwOFPzOVhnQQyyPSSHxpxaiadcJ7g19W24uq7H6
	JRFi8b35RxD2en0rsTR++wkMskF8q4oLGE+0KSw1e13j7Yy47d9xWZcuwqXjql2G8cEzR0Sgd5o
	mFTpd0418L2b9rZ/fMPv85fDA3wEvWS7m163CuIW9gLTPNX7uGBv+dpBqJDZglM2m89OqrnuveW
	kmiJ/30J+Uu/+kGM2PqPppoSgG1scA67oS8fMtlG8UhY=
X-Received: by 2002:a5d:5c81:0:b0:43c:f3ef:ee36 with SMTP id ffacd0b85a97d-45ea3ff957amr218712f8f.33.1779315788379;
        Wed, 20 May 2026 15:23:08 -0700 (PDT)
X-Received: by 2002:a5d:5c81:0:b0:43c:f3ef:ee36 with SMTP id ffacd0b85a97d-45ea3ff957amr218690f8f.33.1779315787876;
        Wed, 20 May 2026 15:23:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe1a41sm61756873f8f.31.2026.05.20.15.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:07 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:02 -0400
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
Subject: [PATCH v8 30/37] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <ba7b9fea071176c81dad6d0b8823ac1b75ec3d4f.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9D283UzxN2sCyJ-LJgLfTBfhJgn7LZsfl6VKyCXDLSk_1779315788
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: j39484f37rnitg9hpetkckpyjapuncba
X-Rspamd-Queue-Id: 217771A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779315791-962529
X-HE-Meta: U2FsdGVkX19VlM8bqixIFAGt8SAS9T5tKtrbCXgQiEQJG+m6Rlva/WnwHgFUtpM6bPOfeYbSDOqUq3Es3zBgoQ6h6gRcDAbpKH9FnAelyejFFLqo8tbKd3hwoCf9l29h6KxsK2JH/v7Fm6s1lvbf1RwTYSH7b30vVZeEF8s46bfW3XHs+E70V86qbzwLAQkg02bWUUjzomMuvGSCya4WrFptEETx+tN6niwKaZzcnAoCg7YsNDdGPizk3OEuMklWOLPs6n6SkrehaeHUagAlaMJ19mUCIpBS8hw12NtC+/6H66kovbSh+tPXzYEcd3AZH2oOtqmfjkaiwHJx4lhyZUDpy/yCe27/VtI48YdjHIykCdbknUZC+gx5PEDvTaH070Fm8Yp4vXasTJrJDxEI/KFyYYzFpfi2JEr3mBjY8snrA1WtgdnsSm+TTClYudABlsPf+V2mwhJk/6qwO1klDSJevNghGir2+it9k929bDNyN13HqlLIriGiibw9/Df6DOu3l6mqczCcj65yvnFSxesPRP/NU8SByXPxbMmaoIuHygdcc1wCr68Imyzq/U3T2uDmN3PzJd32BAPJgWxc1jcJ4ZvNfqq8gP6VeNGo65ZdDNr1LPBHrbSXjDh4CIh7qEdKXgiWifxIV3g0ITd95HDhEKoY71625Sa2pBWt3qqUyRhOo64DyTjdMVFRmBMHIKOv2mmwSYQ+uT/10Qj7+m8VdHKKUFYjTW1MHSh700sibt0Xo/IdmRseVYzwmh/AOSbg+ekFDyWJ4a0bZNuAYD7lSH6WeqBIacBl4B9GEHa98JZiiB/CaVHKaiVVCN4xR/kw9ti1SBQvHdceLrOOqUDjT13yTs9xLEtIh7c1o06W7N6a8GJjdAfqBtXGu/2E3NqS20Ee4F2dJkUNsA36PBmex1AVyjuSLdIuvDJuXjiPOKh0itG/+1a/ZFb/5MBLQOYV2Py2JLU9OgKyrNv
 8qlj+6Mz
 NaIMj55yzXFD/QCR9g7agtcWPYblYv0j3p3TMRI9yK1O3YYv+EQkQgx30KoWlF6VfxJUL63RauQQAt+vA6fJ3Ui6O5kXMDjy2VKSbMVLlPn5hg3EijgiBlFUWnf5yboOydl5O2iI5W+FOZkfCyq+FMW3CVSRwDs2+W0j9pNSRwuPZSosnP6EzgAX9De8l597qMxSryAcGB4EFLGahyEuRugnMFgb0OzXOZ8ZqBofjgYd0lLAQzJ9uPySFyVi9sZ261Y97WgzJ2JrcXgTJDOevmvsqRL/7r73gVLeYCJorA9goHcHPqTssAphUiK1ZRYq4fqmneNRCI3QlIjzR5AvhnwMhP0XN551cEVK6KCfb87oswRMmLrj1ObJvgC39Jl1COeZs2Y3KW4U5as1tOfcsARn/RcTA8QIDoZ3xi0bD2aoMphBbnfUbE/He7TU9d+oAAMMxOL+OfbdeNnO5fh/m1HiTqlaOSZknyeaQJqZSQGEw8cHHmv8faWFSpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large buddy page, propagate the PG_zeroed flag
to each sub-page before freeing it.  __free_pages_prepare clears
all flags (including PG_zeroed), so the flag must be re-set on
each fragment after the split.  This ensures that the buddy merge
logic can see PG_zeroed on pages that were part of a larger
zeroed block.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 72e52f049cf0..702fa2ced1e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1524,6 +1524,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 {
 	unsigned long end = pfn + (1 << order);
 	bool reported = PageReported(page);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1537,6 +1538,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 
 		if (reported)
 			__SetPageReported(page);
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
-- 
MST


