Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65BACA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A88D8E002F; Thu, 21 Aug 2025 16:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A368E0027; Thu, 21 Aug 2025 16:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16138E002F; Thu, 21 Aug 2025 16:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB2C38E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 999CF1DA034
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:41 +0000 (UTC)
X-FDA: 83801849922.22.8249D04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73F1A140008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="auiIn/wv";
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXj+9vT03G0X8fnCGUCy6hSTWwnZnWm2sdD6cJzGZDI=;
	b=Lom6NUmCOuLnUZ3+dcMzAK1IMiLBLWrqLBwo06d3GEhLBJLEqLqctDzgLM383pyPNBSjFo
	bus4k7iEreJxku5ifejwKdfi7CDscbv7/5lwdQAUVh3sMzynw7qXHmeZPG7PktRLbjUGdl
	1U9cm8jJksgVJ6MiOGcS9m/u/cpEuRE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="auiIn/wv";
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806859; a=rsa-sha256;
	cv=none;
	b=0xN8aX6pBLCRKtZiOhWKq7x6Wh5VUoIthSXhhT4LEH7nM1Z0eD0eg/sf5NYSeIwaBJmZHP
	G7kG23sw0bifYuUiqeBzS3uY04hGWpURWGfmgPdIDKBBr5na7xKAOhVrkVuqgyE8nLxQ5o
	MHrttro8HkvUqVAMgkgykDr5RD9poUw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXj+9vT03G0X8fnCGUCy6hSTWwnZnWm2sdD6cJzGZDI=;
	b=auiIn/wv3GwBRvTmJLMM16sMcV1LPDv+Dhs5gp9eUpKuumB8PMdrGMPQ909HmViHBcHLyK
	lc27aoo9olPCrBQmOCGVnvcv4jBKAGJb/81IG4iJR3h6xL4YpY+cH+TXh+re8rNeGNRofq
	Ylp/SYUiU3/aUtZkt4j1U8ktHG/hi1Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-JvxMAnsHPLSDXIoH7N0rOQ-1; Thu, 21 Aug 2025 16:07:36 -0400
X-MC-Unique: JvxMAnsHPLSDXIoH7N0rOQ-1
X-Mimecast-MFC-AGG-ID: JvxMAnsHPLSDXIoH7N0rOQ_1755806855
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e4146aa2so570449f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806855; x=1756411655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fXj+9vT03G0X8fnCGUCy6hSTWwnZnWm2sdD6cJzGZDI=;
        b=MDc21uXhhFJD5gLkpQrOMhRF5iT0TE4LJK5Op4wASlxGPncgtM+/IMx6nNqQvnU9Wq
         8W66HzLo0+QWMjyVr29hTrDSXmul+xPGS6cZJgLsQd05AgvyOIkttxuW8s5maM9Eofeu
         8Pe/HHiHOuD2bz+Ki1KUcwo3HJVUVdzUblF22MJg4J9PlKwVOuF50rwRJ3Ues3pyCsP2
         y+G9qAvq8us+kpmklpuXB8YWAnoCFsOQ19KTThDL8qlRv2n/CCW3/Pf8KV9ExFJPdyKo
         llAVwJ6YFk15gN5p9aW93Ka/+a5ctLSELeM1zK5sLrEJ64xqvP9j9Nc+Xm04ta6Trgbj
         9msg==
X-Forwarded-Encrypted: i=1; AJvYcCXWu57+PLj6sjgY/TL8fC0PunBLGW90luYq1eCHsoxMni/emJQUaZQ8vgQ1xRAcILk9uQMe4/c6VQ==@kvack.org
X-Gm-Message-State: AOJu0YxqMkA2b2RYwgkrufA6PbG8lajZd6hpPm/zuJEMmu6FyM4hMzJm
	LpXIOiR0eDM/aOm6GT5vrzJ2GZouNyjfIty+VhkfJN+1DiF4Jqri+1+9Wl20EDYBxL8SAJzXHnq
	lBbKtP1nmYDuS9uiZLGKtAM+Y+Gx/f0KnkoOEH3FB8WvWlYalfZRD
X-Gm-Gg: ASbGncv+bWEfuycuDEZzIVOIf6Fr58lDE8IPmaAWy48sTS7c3wAvmSwf0NjQcNb0w94
	id7tg/FYIjiQ/KoSMxGo6lmH9XbKQR8//Sj33wxu3OQSDoulskCOLa7ZrFQ1M1LzwzmP0BCml8c
	StuSTTes5p6KeUHk4yC+IHFxLO/BfY8vd+92an5R33+oSYeCpVMKSrw0JCPALTpbYIGTi5fzyBo
	X9EpyfUYIZxvfyg+TiMACnKCa7+7wvoFnpiMjSHn5LSZooaYP2NS7d1dM612mAIP/E4bbcOgbEP
	l0nsriufgsVmUX4fMXtg7hcptkyBm0/T/LWNFKMDqSaXUEOt6Oqdmt57PXX/kR7HxdZyDUvaEoU
	9DgOFYrV3XfMggKM6IO6TgQ==
X-Received: by 2002:a05:6000:2303:b0:3b8:d893:5230 with SMTP id ffacd0b85a97d-3c5ddd7f36emr169074f8f.47.1755806855273;
        Thu, 21 Aug 2025 13:07:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbzCbSL6MUAhNqtGz96KSex+k6XoYEx77XRmSFhqyAAErvnD4a434thNrJcfmyX2YJjFDsxQ==
X-Received: by 2002:a05:6000:2303:b0:3b8:d893:5230 with SMTP id ffacd0b85a97d-3c5ddd7f36emr169035f8f.47.1755806854709;
        Thu, 21 Aug 2025 13:07:34 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077788b39sm12802789f8f.47.2025.08.21.13.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:34 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
Date: Thu, 21 Aug 2025 22:06:36 +0200
Message-ID: <20250821200701.1329277-11-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dOKrRTt9tSc_U1QdEWkgx8VPf8NihisKqgmJm9gj29I_1755806855
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73F1A140008
X-Stat-Signature: 4roomyfm3n31hk8m3ogehjnxjzzo9jub
X-Rspam-User: 
X-HE-Tag: 1755806859-917983
X-HE-Meta: U2FsdGVkX1/ZjWU6szukU/qdYr8qw8KpPMSGITnE7dRq3q4mmI7WUy5EtOR5LFfOWSItgm8aO2yVREL/jfYCAXb2dckN7GskdKqp1ZrdkN8QSg3slyN9wMHEK19LzSl7YK67berc8ZnifjBMDwrxQiPYppZYRvdGLZYcDNa7jw25GgMSNhVe3yQVggwxgtvSo6cvb/lE4bqAfn8iSf58t/G43/YPwQpbwORS2iqkyd4wGDzPaF6yA2wD3NBlsg4ysCsLxCnHMZQxnD7F5ONbFr3TXmM78a9Fp7Q5YXAIomrV3Dhr2wfbS/qfr224KNg03Bif9uvmTMfeEfDa/bJHU18BXy3pS9O0QLcu9n6NQdMj82gGtxgX73bBbik2b9uedrxqIERagAUf+HCqUpPyyQ8AFphoshdnD1eoao+igBc4zYj6rqLDTcvLe3C7+2XozZRkeOE/mfk/MAMgm0AcDS4fOmBPjKGvXKICsBva7KLIqpJ2kILmcD7jOY/z6vtUt5slBZOmbjcRsyx15TkStRLIbt2c2DN2piXL8wMC/F5dP4qJMtoFAo0hMZ4ZOKuz5V0i2EKC3md4p01J0SQDtCEzrW5VLjMFbSSq2obTHPcYwTfWdouQuuWGF/Sh0MMvz7V9FBJUNuWL+B8scs5gpiokHGdxEDafukHuXzv+xT9wRzykV5/N2NOosm+uIXNJmFBrbxVOhdzNm3+VBKcRmM81f1nEfF0Khb9tWGxPZir2QgIss2XnI/IIGOx3QzrQS8g1zA46wz1qCY/Ok7yQEhWMluBUPg4HVxs7XoG5p3M7k9AHeV5jIWvb5vwbuHUEm6CMHktyFybaS6CEPrrXfkGxvDUGPC+V5S1dmqQ0cgkmpoYzMU+IqeN6vNA75cZLTdwoNEAaknJ1bxfyI5X3sY6vwaMftmG8iv3IvxMwUjRmWwrInIh0E4p+F5zLVZzCW9fLYpcQII1ZuOqUspw
 siTx+xg7
 uGjC9F+/0XKIrfRIOhfhumVtF4ZwDfqmxE11o7eB+Q+s1BkLbIwPdXPfIKlgE6WUp66HwzoRjhtU6VRJ5PzyWTq7YaO5kX7x/ssk4grwzbGZfACOp3/+sgdBqy8AfEVTdib/Ahx//QHiuz338O4/yXIyP8F2BZeJ4Le9Crnee0eVyOmr2p8hPm76DcR1/4A5hOLqNRkCREbtO/UAxknpAI9KLSl81Go3tfYzs2SgUIiRHO5TeKqHtrK0/wGk1QtDpD9EcG4t3X8Mgb/YKKolXlSpZmL5KONSjdaSeLTt3ZWw7kuri8VpexhW4pNl0VbpzPieLu/ZV7s8AGsr0I7f9bI4Cy3HnJIvQKposFlChNk8uExu/m202tqaRIdIDT9PZPI93YAIEI3RS/e+eotsE9oYM5wYn07NtWw7dhY0vxCXlNU2IF6Y8+d7rDHXIaIN8nNukwHHtWff1jgJeSDFo+Pjf71YyC4fxcNNX1oW011X7Bnps/EWsHgJ8sz/H+Hoy4W90gs5Qv6ovyoJrDp7/KhcaQotY7Ec4FjRJmI2RuB9sFxZZ0FOOsn79zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All pages were already initialized and set to PageReserved() with a
refcount of 1 by MM init code.

In fact, by using __init_single_page(), we will be setting the refcount to
1 just to freeze it again immediately afterwards.

So drop the __init_single_page() and use __ClearPageReserved() instead.
Adjust the comments to highlight that we are dealing with an open-coded
prep_compound_page() variant.

Further, as we can now safely iterate over all pages in a folio, let's
avoid the page-pfn dance and just iterate the pages directly.

Note that the current code was likely problematic, but we never ran into
it: prep_compound_tail() would have been called with an offset that might
exceed a memory section, and prep_compound_tail() would have simply
added that offset to the page pointer -- which would not have done the
right thing on sparsemem without vmemmap.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d12a9d5146af4..ae82a845b14ad 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3235,17 +3235,14 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
-	enum zone_type zone = zone_idx(folio_zone(folio));
-	int nid = folio_nid(folio);
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	struct page *head_page = folio_page(folio, 0);
+	struct page *page = folio_page(folio, start_page_number);
+	unsigned long i;
 	int ret;
 
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
-
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+	for (i = start_page_number; i < end_page_number; i++, page++) {
+		__ClearPageReserved(page);
+		prep_compound_tail(head_page, i);
 		ret = page_ref_freeze(page, 1);
 		VM_BUG_ON(!ret);
 	}
@@ -3257,12 +3254,14 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 {
 	int ret;
 
-	/* Prepare folio head */
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by preparing+freezing them in the same go.
+	 */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
-- 
2.50.1


