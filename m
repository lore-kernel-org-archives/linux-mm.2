Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4864DCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC2A6B00F0; Fri, 29 May 2026 11:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6E86B00F2; Fri, 29 May 2026 11:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C98D6B00F3; Fri, 29 May 2026 11:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9786B00F0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56E8F1C02AA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:41 +0000 (UTC)
X-FDA: 84820829562.24.1B68E8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1FE11A0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hR7WvOqg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
	b=y6dbWU6KLYPYApZycau4bMC2GBX9ad/GZotaD0Z8MDM55I2hvqzRTSMbEoVOpCDKPdVzvC
	/NjbVzU6UveDN3OwFIqf6fygBkOk7nUU7AdXb6rO+YxiZFx0ml7XmWEjluSQoOcJwZ7CNk
	16goiNvcrwvM959NKsNNuh5AkqXlnXM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hR7WvOqg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068279; a=rsa-sha256;
	cv=none;
	b=1PzdIjU19ZLOGiuWCVtFtZb7brlay+jUufgiWL6GWDmrI6sKYa+GYzRSqHuzROmcPivlqH
	L2RFDwytQFGntmhYyo4hPMVApe+v55XZVJrFRT1+VdvvR39yKgQJh1PxxJFZCbo9kVpHie
	QNMifChrYclculGEjId94jmV7B1bK78=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
	b=hR7WvOqgi5SGL+TjT6qYrKrBPlXuYNK/IT+4F6DilSHA56WnNtBG61NZrccBWAFcv9tTni
	gfWYafVP7b9zSM31Wu/GN+DS2l+89nvptXvh7CIhBfmEMbWu+9QSl2jaOKdvjISuRjEQmF
	r+Dm67jLOczrocOnOZj6rjoLUMi7hJQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-nIzQT3m6Ndu4Z8g4kDbqNg-1; Fri, 29 May 2026 11:24:35 -0400
X-MC-Unique: nIzQT3m6Ndu4Z8g4kDbqNg-1
X-Mimecast-MFC-AGG-ID: nIzQT3m6Ndu4Z8g4kDbqNg_1780068274
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4909c0f0ba2so6582845e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068274; x=1780673074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
        b=ZRw6LluZqi9KwOvEhNGjFvZPgdSYpHGpKTPnsiASQAljgrudnV4yAJq1rkDjsaM2dK
         ZkX5sLjkPsOCsSDt7HP/rBH6ZhO6kQyN/ClQh1mogQ8mTgwc04FzMbLyET4zY9+tfQd0
         TubgC/FeSdQNEP8IFwVOPCYQ02jqfCeKQG3tq8aNPJgAxbCgN4jmEoqcfBdQ19OHU7Bl
         iYJ2ro+hkDkHu47F6oS4jyZn/ob6xz4i7URKYjtjNjpk5tOuxNxDvabDcy0saCMuz08g
         cspytolEcnCA90442vE6nne+sY8EJbP7Dq8V1gelfJOyvZxd8nbJag2txwS8xI1cmZvK
         lxOw==
X-Forwarded-Encrypted: i=1; AFNElJ+MXl5sFS7YyJK0ULG/cpxDkUbL6NHAwoqsB+VchUgMED4ZwCbUReVpcQdVUzc4U594wgYLDonAHQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8qk5LKhN/qGirDUJZAqs3U86tX/5VdHDPFlonZgMwxppTTiXL
	OBa8/GzEP5Dvk6yDXMEKo+1AzGAGVu41z+mm4zJuE/rzZYd91fsNdYRthoxTZlIOlZLdwi5BiDt
	BLsxIOB4HG5F6skOBmCr/Fltx1FEfKtbHwP1EjHf2f2p3/lZviZUo
X-Gm-Gg: Acq92OErTmt3ZI7YNu2P2vVsw2IpGGnjd1v84TzYT0+Oab1UFNfPt4PXRO9OEcxg/lA
	haohLSbkneV64WggUv/icFixxKX1ZSoBpeKTPL4NSKOCSDpXxDZnkiA2PSu7Eh4KpTIN4DqbrCb
	e4J/5soNnIewKmI8DIjNcV8wAWfDQw9DHBCGflwKV+ELCAkQoEtFdqtFH6pVyCUSUBctptVbCmf
	XI4hq+blJVuUBuvIp0lRa4N6Fq9xJOiNwnUAn9GE3bNdHIzk4u3aruN+cKWicBK1d9NBoAJ8uy2
	jb1Cd2nP34t02AqL5aPzryZ5gh12ZTgGa1gXi7zZJXCwwSm96Ch1Xv/NYAKMuAQpn+T313OcShE
	HzBpeYBhuE3QKmNytBIyNQvMMuT5hrgidWkXkMV2D47u0Jj7qF29WZw==
X-Received: by 2002:a05:600c:1988:b0:490:845e:3a6 with SMTP id 5b1f17b1804b1-490a295013bmr1065455e9.25.1780068273976;
        Fri, 29 May 2026 08:24:33 -0700 (PDT)
X-Received: by 2002:a05:600c:1988:b0:490:845e:3a6 with SMTP id 5b1f17b1804b1-490a295013bmr1064315e9.25.1780068273271;
        Fri, 29 May 2026 08:24:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34a0674sm3959493f8f.8.2026.05.29.08.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:32 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:28 -0400
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
Subject: [PATCH v9 25/37] mm: page_alloc: clear PG_zeroed on buddy merge if
 not both zero
Message-ID: <c022faf4f5516d8d630bb2801ecf482c09ae5199.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rTyMOoD-jjlx41yvL7jb_TrFmuSmLDdBgaykeD90S-w_1780068274
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FE11A0002
X-Stat-Signature: w5yfnmssrmgtaww6fn64s836z5up55ie
X-Rspam-User: 
X-HE-Tag: 1780068278-847179
X-HE-Meta: U2FsdGVkX1/EiC1xaVFiglNP7LsTEyYeOxBwTuWcUF60+g1/TLw+Qn+2p1adZzFZqZthi5sKFHW5M/ZGTE7BNI04ycmemiXZTevdQkqQu+PPNC29LN4FLwxWYnQF5z6mjUxsxbqB/4xF/eKmXDwxEaz+bo6OR7V09hITj+EvhYCE8s0QpWFea0ifqs/6OZWaQbEIEDDLVDMrvnW3UVBZ8hwK+SvOV4fIHFl2kxJzgoMDYbBi2wUwKXvUZ8ga+t2dcTJaEddGYUMgU2msUTMPS/ROMUNJq5WGaLkkYsEQkO2QUO56bqnvpm5lb2+l4o8ODbjsbpHgHCWqCas9yfsjLCDm5nBq5+bZuf4Ch+JXqtDobCK5Bkp6mGRFq/4DFXD/cil4+RHuJCpSZtDCykqjBYu0pazHHn4iOYHmXUcL9IoQnzpX07xELWMpFLN5LF/hpqbA+PEfN1ypGJCG++hdTdALXTFpUTXLkqEbGu1yDmB1d7fBFPxxovXRPApi9PMW25zeX80YRukITEU89OjpeGjmQBWYc2q5mUdqAo0OXeKVdesv59SRs+3COsOx0VW0dcYGoLjvn7ySGF+jRTrRxCsM2AazuSrXpkYisXJsxqss5uoZy5yvc26NjDU+4M+Kqjuw6SqSl1mp+CgUbQ337E3NIdZpr5ZWI8YWi/tocyWNRYb9Vf5s7BE0Mjz6cVfXSWHWNi2eKykfK3WKCxl0Wrhr6XHQPv9pGca9VJX4DIe+xzG/ZA7AUe0vd5YpEvgV2TiEWOepQ4fnB19Hrxc8W3iSKtPTZbNnKWyKRvWcVapoyiESVteUSjaDPwBcrY+PIpxqFRZJr5QS1Y81eAz9ksF3w3YHkCBEox36TFSupR97nVapGKmU08ueAaLKQ6Ft+SA3VEq9Dv4FPbVY9rbHpJdaIrw+ZO1FSMneY2HTn0rwj07PvQ1aNcDBbpIaWz7nH9FLu8h8+P5n4CrQ4OP
 cTPnu6zV
 BnabiOxyVCpOkcdytgTM16LkIvDYakmwvLU4INYL/zkUIuqSlhcAr0Dp2XHcM8jjHLoWSATGvI6NB3Q1x99mCqoLkeRj4Z8gf4036wvLARsPreBpqHF3dPXWvzve4qL/OenG63Ohsj70+d9Bb9OFIdVdMNXU8yREwJ+xU+DpJDUCYR2T7Lsm1pn7DxFPAz4nqZ+IOSTxYwDCG80v/DckhXV4lMiNXjJAHWDBS0DDg88FpqymXtmonn/PdYXegTLp+9uKR7s0r2POZaZDnVmaH/0M7pJU2WLjfDbrvsFmXjLsiSbaMtlecFB6eHBJ3lqDQTaaUGS/aCJSZdWHw/pWt1vbPrmRP+VPDHeX58lXp8c9jvAD6ABaI5uORmY5h3GfYfOENhj4v7BQ4Aa1GIPz9nSdrSOCG5Yys0ZzfDU+rv7E/CDeP3F73gn4oNFTWPPIhaOPcq/kuMv8z3jOXHmfjTugPeQhnNdVsrWqdElM1wtP/Br5V154adrKjL0rQM9PtX8mHhUYe1XdYRHh+hUWdRlQe1wpS6Oey4R6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

The merged page would inherit PG_zeroed, and a later __GFP_ZERO
allocation would skip zeroing stale data in the non-zero half.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h |  1 +
 mm/page_alloc.c            | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4ee64134acc3..ff0b192b38e5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -680,6 +680,7 @@ FOLIO_FLAG_FALSE(idle)
  * uses this to skip redundant zeroing in post_alloc_hook().
  */
 __PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
 #define __PG_ZEROED (1UL << PG_zeroed)
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4cb7e779a6c5..ff614e422eec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
+	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
+	VM_BUG_ON_PAGE(page->flags.f &
+		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -978,6 +982,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -996,10 +1002,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
-- 
MST


