Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7DECD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30EE6B00A8; Wed, 20 May 2026 18:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2856B00AA; Wed, 20 May 2026 18:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8496B00AB; Wed, 20 May 2026 18:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7976B00A8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E55081A0451
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:39 +0000 (UTC)
X-FDA: 84789221118.14.6375AE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 922FD1C0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LsRKgfP6;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
	b=z3rfCnq4cSanPVSEo4Th92bEWKKL9592Q12IwhFsL3hRINnJt9P2RQRCr4Q75XYGt3UYSG
	3zkzTxSnm6RUhSvNN/qD5fQXqo1G21ZJUOgJc/6XlFeQW/mGhNu0wJ0Y1Jcs8bSDgUh5Kd
	pYl9OIZC3Uq1JKY3qp718QmNisCc88Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LsRKgfP6;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315697; a=rsa-sha256;
	cv=none;
	b=mQuiUut4pgahVDOAHmw2fA/3VUPvRo9dMU4AMtFvheMueKm1uwJIxFYO8+zonUiOwBT2l9
	6TR9KJOonak7FgXrvRUIzqlPvnCpARdKpBo40aDqlTDbH5ZhiCCn2VOVIpbVttRWqzQ89w
	mcRsOur7POZOcezzm7hWSU8cKrRkxC4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
	b=LsRKgfP65J1Gd4QwwTjG7pngG2208o8urC1jFdiLReF48/RZviSbNWVe/xVAQUokCPmUCP
	yjeQ9d6taqTtCXT4F7EHfvkIBAINo43k5qSLkfMZsZ94+9/xsya6DmKA2PcDhCt6zGNhTv
	VJYUJ7o41iXjMjhCek81oyi2btzyobY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-18N0CwywNH6Gm3Q6AJ4k3g-1; Wed, 20 May 2026 18:21:35 -0400
X-MC-Unique: 18N0CwywNH6Gm3Q6AJ4k3g-1
X-Mimecast-MFC-AGG-ID: 18N0CwywNH6Gm3Q6AJ4k3g_1779315694
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e89faa62eso32665005e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315694; x=1779920494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xr0Wq/tgum3c1wWvimcTvl9O1enHA5UssViDpRUdduM=;
        b=RkaqJbSv/YHj5TQ/VqsVMjJ10Mnfbl+VK2vH+17GMd8Q++VY2QSVV3stHg7YRoeR97
         E8s7mB+mWVyL8Qeu+RpOhzHTGiaXIL9gv4A2NI1Cq1pk0p/L7HjFHEB+QV4hvSlmlt7y
         o3677SxNWaM3vyubIa/McT34bHwGDJZhGup8+d/I/VzwsgfldQrWmI8RzB95XakHsYfe
         sFNn1moHzSKuUHjIC55ebfo1Gp2JS0FkU7S4M+uNfTezLA8u844To1N/N3801bI98JuW
         gyWYoEILwkDoaqvQJHds3uAhqGfevw50CcjlG+VW4AbiWuvdgQLDL0Jo7S8tnijj2urr
         bb2A==
X-Forwarded-Encrypted: i=1; AFNElJ8W5HjESkpuEfioI+/I9gGirn8xz0giieeLaI1BC1lEfLNYxU5+w7McU5+chCBdSbj5FRgL1hO1wg==@kvack.org
X-Gm-Message-State: AOJu0YwdVUlhSKr69KKUl4pdNY13J/sL6gOwLNClzg597dSWylr+atbQ
	emcqdkmYrm13G+GJ4NLQ0I4+JVCZkmhrqGf1QFlG4EABmWcKrMsqbelEPlu5g6ibUGsYNqP2hXy
	soJfXv8+TBoUTseOFQcReVrVIqkH6NOgzvBYtr205tN9yd+sTvTYr
X-Gm-Gg: Acq92OFzxFkPROT+1oCUFa+uErWwKTtDa9VGzQxEZrrO5XW60zyzDMdxxP8gVDpXEtP
	aZN7NGpAc0fjXL/oSCpVjFTdzX9cJoJ1CcH6NS9xG9uswvx4TXoICyO/JBp/wtLsal/tH9PFm2E
	xxaLuCXNbOwr6ECDS/u0JxDTloJS1Ct2Bm4w4v/0zVzLmHAIXAp1ivZ0Srl404V7/c85Hji8QHu
	SAFUKTQGVMEfNKdbEy5hIZUzqujVKp9tPA2HRKVxQTTz0UKXGyoYupHPViub6cKvgIf07OuyYVP
	ORhEBWhkFwHm9/ZeC79cywV0yrnfXG8aocf6QYQTZrUskOHlpfECKDZ2D6pQZMOViL/qYkUCCo5
	Sj19I1FUB4Sg10QDyn5fg5jiz++ifZ4uY7dBeT32/10k=
X-Received: by 2002:a05:600c:1f89:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-49036068fb7mr2635395e9.12.1779315694160;
        Wed, 20 May 2026 15:21:34 -0700 (PDT)
X-Received: by 2002:a05:600c:1f89:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-49036068fb7mr2634915e9.12.1779315693632;
        Wed, 20 May 2026 15:21:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035c2159esm1982445e9.4.2026.05.20.15.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:33 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:28 -0400
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
Subject: [PATCH v8 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <b2cfe19293b5b4fc644fad344f02785a3b1882e9.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bpmiF2CFv_Vb2CZmMI7--Mu4t0pIE-pzPtGHfj9N4WE_1779315694
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 87ia15aryz4fm1x5rbscni9roida6mnu
X-Rspamd-Queue-Id: 922FD1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315697-930009
X-HE-Meta: U2FsdGVkX1/TnhQPGoHR+EG/sWbLGHEiH/sXj8Hu/5h2+r0dmZ7ot+eZgSUoekyLNGy+M6OKhiBfuZnKW9PsYYDXyIKNRC7AzjZ06Z9/zou42lURGdRDoavbgtEgDfFUtP/CVdJK1I2vje7fcx6cZGqjXXbBjAPACn2AERARgtMmIBrXp+klUUd104srZEfXIBwuJn/Fs2p/GOo7sfJvl/Gcw3H4ORXp+YfnRMOA6FFxv95XKGu+oNdh340xkTYrvzhcLsZ5jAoWc0ZFWW1qV5H0HRTaEyVhj7BIh3MRKeG4mDxRf8y8HECH5wGUE91OAPhxuIb0Mm5Ts4iKR4EMyHSiKzuHCQ3z2L2YxTdMkfoB2RnbAbLHwrzDM7q7U853iYr8osaAxJOMKXTgSGL1Fn6071JvtT1wnlqhenT7E2jD3RHr/PtQ3CohV66QsmX1/VJBnHGBdzhNqYinlYlPeYCmvvXl9OiuAZ567H9ZgilmdyunEuqIa0ht3BzLmGQ6rzcL4z1065gXw7zGsvIMocnmLem3jMEDuxlgwH/RYTI4d8aPi4iiCpT2FN6fUi9+mQOaBpq85gvrWuoV4rU9kdKGuoRddPQM0L8HTYXP+cbEUwS/4ogsjQGd4Z+oHvTgDd3aek4bVPP6iD9lAgxng2rny4hiBNojQUuAe6cQuCTHJz/vh6MXHPQiYbCLx7w26E+e76Lhz3SMYVhxkbc8uI4ZGZrgPUKzeCew77qBzoYR81eMsBTU4/arYv29vHBo1AKIan3XVh30SXN619mk66uXC9rze7gG8KCU64IFUY3djESzgVZaC8Sn0o8xiP1pPDWFeM7/aQXDQT5zAe4truoiAJrgAMlos5gEbkC16qdkvXSL79USie4w7ouzYh5+uZ5r+LQzMbCGDtYu9QRBiJq+8zKi0zXnwY2pIw55uGM+u640FxZ2az6POwOrHYz3UiWveHvS6i2Il88i8Hb
 2U65C3Mt
 6QUvfR+ANjIhqYWoolqQAgv4vmfIz1uvvGIUCw+tLDyz1ASdZwk+EikZ1aocqYB7eeAysyzpvTeGpb8Ai0fzdR8JdRtVSuox1UVB35/a2IFaWefFMvzcabbYaaSPbz3ASkxoN246wlLvU6Nt01TjhbZsMzzveSTVNBxmgtXtBQxeOvQEYmpJtXxYdIURTz7pVxAWhGrGPyHHZ1PLOkDo/3kRb/jIxI0u6rg322xznqFr3VncoSghifgK96gZereh2H9Naq1x6x//afF6YzxBYx/DcL0NzPgeZUCiOMTuonDUX+F2CfacTqTHli/CYrlZoqXly/bBxK4F4ZZrPU3TajsejYZ23Fpchldg/gagOan5xukBKHL77Dcd3JaEm9Yh1teUo4JxGG+mng4GwRhJw/VQzu4z5NUvykvlLnRHG/qlP/S1Qpo19cw/1Z01C/mmFWwwH
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
 mm/page_alloc.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3108ac9061ce..ad0655387e9d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1864,9 +1864,38 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * On architectures with cache aliasing, pages zeroed via the
+	 * kernel direct map (e.g. init_on_free) must be re-zeroed
+	 * through a user-congruent mapping.  Host-zeroed pages
+	 * (zeroed flag) don't need this: physical RAM is clean.
+	 */
+	if (!init && (gfp_flags & __GFP_ZERO) &&
+	    user_addr != USER_ADDR_NONE &&
+	    user_alloc_needs_zeroing())
+		init = true;
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE) {
+			/*
+			 * folio_zero_user relies on folio_nr_pages which
+			 * requires __GFP_COMP for order > 0.  All user folio
+			 * allocations set __GFP_COMP via __folio_alloc.
+			 * user_addr != USER_ADDR_NONE implies sleepable
+			 * context (user page fault).
+			 */
+			VM_WARN_ON_ONCE(order && !(gfp_flags & __GFP_COMP));
+			folio_zero_user(page_folio(page), user_addr);
+		} else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


