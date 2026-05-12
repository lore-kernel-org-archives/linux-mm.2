Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD963CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEDB6B00CE; Tue, 12 May 2026 17:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6466B00D0; Tue, 12 May 2026 17:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC926B00D1; Tue, 12 May 2026 17:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7B56B00CE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C40B81205E3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:46 +0000 (UTC)
X-FDA: 84760004532.15.7E03956
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 843951C0010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KTQ5XNwM;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/8VBBw0J+b0eTIG6c4Ba4jQebQb6vF38rsggt16jgI=;
	b=mohIZgFQ4AeG+nPsJ9GKjHzQLM1IgR4t84Zb2ILZ5a4He/IaBwv1Bh+bPD3DZl7NCD7Qe4
	pqpRbWZ9+ym0cHzGgmtxPlq4sseh3uPfPkWhIaMYA83+NgGGvuBTgpyc486cwFincFpaz4
	YeCOq1k/UC/K10tjlz8sqTrxJ8dx9Xo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KTQ5XNwM;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620064; a=rsa-sha256;
	cv=none;
	b=HcZlJpPRstAD8qSwoXOo6iSjhpdlKfCqJ026hEC3SH3/D52/0p9x0BFexG9mM7Xr6XIrwf
	CCf8fuEW1kQaZSLTVwpW5cPzbg2wejvOHZ1VhG2doQrK7pxIYQ2yW7yapzEf9+vQOLo9J+
	DuxkeL8Mbqjtnm6Nr6NOSySzF8eerO0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/8VBBw0J+b0eTIG6c4Ba4jQebQb6vF38rsggt16jgI=;
	b=KTQ5XNwMYLmUam/mN4T5PgbibK+quo7PLvLBSawvmL6zUMMGeiG712HUx8RsS6qwDyPqZn
	T8p4Fm3e0FsCr8XZ+3ASsRpb1lvS1mNoVhipjH7aXOTtDAuFQjEIaeIDje5pSr5olW3hG/
	7Nzq7jDtS/Eqw7VmPHrihw5HrGStpcc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-fSZKgJWzMamvD5HyWCT3SQ-1; Tue, 12 May 2026 17:07:42 -0400
X-MC-Unique: fSZKgJWzMamvD5HyWCT3SQ-1
X-Mimecast-MFC-AGG-ID: fSZKgJWzMamvD5HyWCT3SQ_1778620061
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43ff19e54beso4180696f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620061; x=1779224861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/8VBBw0J+b0eTIG6c4Ba4jQebQb6vF38rsggt16jgI=;
        b=Mf2OncX0J/scBD9EO7Do/zAN7PWyRARRhkG+2PgJ5PaHZyvXbhKEtr40tiXKpGjnwm
         M2K49zR7qgt3qG0wxCVdkJADLrBbRqqr9NhhotTRCsokTvGhMo2oZfFF9YjzW7ijZjRb
         Qqw8s4m1cU2myl97ArsOr6RiRosLcAXv1XMUXXhrzpf8qIINqYtXh8p8lt01fOr0/Vm2
         1vi8Pa+y0BDN4Y594Amap+Eg34+uQ2N1+9D3Lx/QXKjNFvPTnmnvLQeqRRgV09IHIkOW
         f9LSwomWL/xD1wmGL5ybykKYWA7E220Kfhjhs2fqI5kSYPkGKXm8pasBK+ybCM8ssBsi
         RmEA==
X-Forwarded-Encrypted: i=1; AFNElJ+ruRukzflYyLqO2uTJp6QMJRgrNqYlJIq5VYsZBZJL8hKMnur9vHqleV5/rMdjxOfWnSpmK2UGxg==@kvack.org
X-Gm-Message-State: AOJu0YyQzrGLHlZQDrPFpaAJpHeXSJa/9cPQGW771juGubM7MAuPmpAk
	9G5jUpYDguiD5r4R+xTnNCgmLHasOw590jQVEJZpGSx2NAPMjkVINOsCOUfaorHcsiBTzJjjdx0
	yD/lb99tKsWtIgLWAXZRzitc7zJOFRx1utjvVgyHsiKe+s/3Kc95t
X-Gm-Gg: Acq92OGLFTxV3AzTem/BKgulY0s+dYaYavelmFhU+u44BakYre6rWAUf2QcPNCqi7nt
	OJr8lYWKKDsTwuedIrEpQKnqXk4XolC1A6f9+vop2vvcq9gvs5koJE8qgkIWU4/7Q3A1mw7gGv0
	LBIr8jiCW/SKzuxggJrCt1X8r1tSjUjMY83RmhA2eCsarv98fo2HTzCCOkV0rv7mFOowIh6tcgL
	QNPXkL83qVpr2C1clXDFUUTVjMCW38Q/qdc3bdZ/6nqQzHstunJ3vHcIPTt2LtjCV05yX9PjbmY
	frZi2bYNSc2gKpqWAwf13OZNkzT6gEr2su0jP/vxbwOC3ciXJtL28H3hspQvbbBGW8St5rODHpy
	7pTdN+rqUnxN8yF+HXYZ+w0avReeEqpHAj9AJH+Jy
X-Received: by 2002:a05:6000:2384:b0:43d:71f4:7ed5 with SMTP id ffacd0b85a97d-45c58698080mr544112f8f.17.1778620061383;
        Tue, 12 May 2026 14:07:41 -0700 (PDT)
X-Received: by 2002:a05:6000:2384:b0:43d:71f4:7ed5 with SMTP id ffacd0b85a97d-45c58698080mr544054f8f.17.1778620060883;
        Tue, 12 May 2026 14:07:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a66bfsm30848344f8f.4.2026.05.12.14.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:40 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:36 -0400
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
Subject: [PATCH v7 28/31] mm: add free_frozen_pages_zeroed
Message-ID: <df9554006e7db532d9b246cc3059a52626ad5829.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kigXRFIbCt89QpJPOG8ynlYH3SD3p3e1LIDWznXbzwU_1778620061
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 843951C0010
X-Stat-Signature: rugxggbjngmn8hh3auingh99hjb1otkx
X-HE-Tag: 1778620064-695455
X-HE-Meta: U2FsdGVkX1+IFR0tMBFIV1MuF/YNKS9nidPyFHb+Q2zLdGVvqA3U2/6jQv6Bc/XEUGGoXG3VBrp5WX7VsxBKArHf+bV2IgIxnTuh9y7PsTdKX0gYJKBdntI2sSB51TPoL1pl8Gr60UWqFk32FK9A4eKOU/uguOZ5YeTjM5zmEYs8GD3M5EWWB5Y48zm3u7wCRQWPgC/22uJuSzWBuFSsRhDWoWA4ZHMOoQK7YVcKBWIsPDYGSXrIWoAL+oGHPbKNulLdfPM1jp1fX2W7F9n8IUpxDfjH+zBGEMNcHy9mF1EtFjJtVjz3aiAT0+JFLgiGUPBzY1SL6+ECZ3lyq8WTX7K4YMDWVwte8UAG9M2T1oz7WI5SnBPD41P3wfKsnbu0msIGrlY6w4ARRaUS+mjHwYaesvRmH1HZ8HFQr2bAuM1uXUT/r2T+qYwsPJ+6p7XbPxvOV7xXbUi1OFBQ6SZbp9vsr4v7DJUCogMnDMTuWkg+Ui2PLLwB3ixmfoH2jK66B91UvUJlnxBztl139r//ehAAXneDnuoe5c3UJs04MBof3VvzXZWkaQKC9SRDXjZYoHKYOP5cfzWumitkVP2VJoYBlWilPTPGCdxIbvK0iVvXdAEOSyl4wHVHWyxdVgNtSjii1KMtRywFo6xmZ/mQ5LtJy82EBg+NIJyBP9XrRpihgWe5SLXHBrmZxydWzWoWl1fLHuReue1uh/DbWGZwyhJ8FAAt1/9VU/L7cUtMveCcfb3Tl1fKxJiRNdHQRAwKfnwZQhcjeLztGsOU/lrpIC7vRv4NYH3YyRziClDFIiAjadjoWQEYLIcviCghAoSydKYdZf57F8z2ZBNpdHPWWoXB8DHZSUkhJKX28OyEzFvS0XsWXOopnLuumjrEwdGXaN+AWv/XSoHWafQxqVt7SazsKpYTqJiA76ctlHAqfKWD5eq3youU9nKNGi6F4EBhMZLUX+A9fcYdAicVfhc
 1Wbf/Eb8
 j0EJBLRBDrgO7L930YWmsZ4yWFSfhLrDt12gfHaUeAfUP8VAGQYcTaDiw8QKKg7J1BgkxA2Kxts5nTpNxpOo/VFo6hMkARtCGJi//2zNZXjs27yuxjiMBcvun0JBHj2FEQfOBmaRN8AoXvLeQ8gpV5oLx8CWk/cheaF+W8Y0VfTXI29y8zxSaqHxLDoTxil802JWHy2buarPNpc1UelWR3g1WLOnoFOASU3dal+PcXkfLy45G01XeJKwEvb8ZS6Jstajk2ATBEZqkKyyWNMsXdjIIQT4HGBvbqXPTs6ItYputSLq4VMC5hJoBuqi+YSCk30UbfWxl+kHSuo3tkMhJURv6RPd3388katxFoGUVhqQ6cO1kk4BTokexle8RjO1cgUOF6pxpuKMp+mET6LyIM+nE64/js9KaODEHCwjleoiWDqtZAbzwXgCfk0yle4ETYq7s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 -
 mm/page_alloc.c     | 21 ++++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..e0d5743de68d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index fd910743ddc3..4af5e72742ba 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -938,7 +938,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ce43f5a3dbaa..8eebe01cda80 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1596,8 +1603,11 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (fpi_flags & FPI_ZEROED)
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3000,6 +3010,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3038,6 +3051,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST


