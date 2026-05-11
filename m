Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3BECD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E856B00D7; Mon, 11 May 2026 05:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5D56B00D8; Mon, 11 May 2026 05:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC516B00D9; Mon, 11 May 2026 05:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4176B00D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0BB7A0592
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:18 +0000 (UTC)
X-FDA: 84754547556.18.0F18CB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C62741C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggzYbS77;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
	b=4SsHebhiiJVGfMyOP5rfRv6G5Fb3zHp8o2aD4fxOAzOY71UzOQ5if7YZspIxSO2l+IbqiR
	U0Aha2YR0Uoj+FkIQsD80s1ttQTZpgy9tbaCWEWu54gr1o6H351Srm+OKpVp3yJlPX1bAq
	lWB+CyiRDmaeVQBIm26V1uCVrphRBQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490136; a=rsa-sha256;
	cv=none;
	b=ywe3LPjMlhloHzJREKwUigF/pOkCv5AqTiU7HFtw8gVCmsLkkq91nG3cAoBC3UoE5Cwo0U
	HaqvyU8wDXHyd2Qc9me7SEXvAWZya/hXzdfe9STuia/81C6IwbGVAFo7LH1s0pCGE2HxyW
	X1L3zZlhlWJcSVAXOWs3i91h43PkfP0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggzYbS77;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
	b=ggzYbS77R7NMdRsdBQcTxVQZ5nG0Sxdz1bOjiAfjM7jh9K3YALZA53i6gUcwSlk7XAOG57
	LY9TKJ55RMhSh4zRBqMEBMb9RBfrKfUOsmG6BDWzqOpaxalEIPOf+082VQzi395dmuwKD0
	Vjv/7stxV1qe09r70FSphdudrqVmewM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-44FlQruTOaumA5dfbnnFgg-1; Mon, 11 May 2026 05:02:15 -0400
X-MC-Unique: 44FlQruTOaumA5dfbnnFgg-1
X-Mimecast-MFC-AGG-ID: 44FlQruTOaumA5dfbnnFgg_1778490134
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d103e46c3so2461805f8f.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490134; x=1779094934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
        b=NBl90UTNo8VNYMWVQ1NR3vHwQhygvxK931/IS33i7CcRGfARmvpOOPJS1MQNNw25Rq
         S1FQs8M7LwTwN3lhSs7/31fEB8TnIQLH4BRvrnyPH9leLANdizaZo155VxZxmCdUWHfA
         9kyfrbIsD02HtuvlpKBVxrWD1cznjagPoii+B2BAge2Pw7jBoMxDxgizxNoIQWjMYqOh
         LrdX8fjCJBczzn33x3qHbt4rb6okiUp7E4KLVT8EB6YE5r+jMo8YBEbdunK0a+hBL747
         6WlKAwk569RM/rVtG3lxvBEIKPEbyjBIy6jD3K1ldE4MH2sSC+yFO9sFAgrlxfskHa5S
         qQaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+B/7CNUhHEPn7ZPvqNRs2WoevMWI+/PH6zralBFeUa3HDeYX4HKqrzJ7u60JprkHhR6DrBRH1h4Q==@kvack.org
X-Gm-Message-State: AOJu0YwxKQUIDN3MsoJd/+DyRAC3xxJ+BNyoOgJ9e2ZCk+NPM/HyMMot
	JX0WSS7slfP7X/p/FKbs+8QvHV7XgKCjIKLyoWK65QItCn0SctDfJBbFu5V9Iq7Hixkje5YAcZ7
	AzfzdV/w/RaFuHM2DNBVbSt/zHQFTCIsspfHXwr1IqdAaQONdezKF
X-Gm-Gg: Acq92OH1DdmZu6IrWbUnlmtVzuigcQZMVrw7jzdnK9w2sWJwu/UoJLk3j4nEJpuUE+2
	MtVODxsqZzQa9cMABTb8vPgwmDHsMOnSm5y7bvCJqDCVCZ6qx02PyitAke1SasVR1gh8/6k/8zj
	RIml5Lf9tKmZbokTe6BKWBVJMn1tac7962OZW+CIbyQauQwJ2R2in92k6QYH8Ex92HuHG7s5FkA
	s2vwmEKXOOdrsZqgjBuU96XTcZ/eOFw6WTwS+mxEsSxX2pWM0WIW9CGzsmQbBGfbF2tKmPFDD6d
	kzKZ4oLfoMavyJ2FWUAQHLuGSBDlMO6jpUNKEW02jUc9RyH8Anwg4vTU0RX3y/Gn4BvANIgzAGL
	7MzhI9eM/+aWyWswGb431cBWr9APAjImdUa9zRwc1
X-Received: by 2002:a05:6000:2502:b0:43f:dd40:bbc8 with SMTP id ffacd0b85a97d-45462c341d9mr21397076f8f.24.1778490133336;
        Mon, 11 May 2026 02:02:13 -0700 (PDT)
X-Received: by 2002:a05:6000:2502:b0:43f:dd40:bbc8 with SMTP id ffacd0b85a97d-45462c341d9mr21396993f8f.24.1778490132555;
        Mon, 11 May 2026 02:02:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a6a64sm25368230f8f.6.2026.05.11.02.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:12 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:06 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH resend v6 05/30] mm: page_alloc: move prep_compound_page
 before post_alloc_hook
Message-ID: <6345727fdfa76157ba0518e2148d1848e0bdbc16.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4mz8Gwoc39E6H-VclLFIMmPn7-foU3G_wS0JJ70XBcI_1778490134
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C62741C0005
X-Stat-Signature: yk95rtnfeqxubdteueik66gyrqxru6om
X-Rspam-User: 
X-HE-Tag: 1778490136-273744
X-HE-Meta: U2FsdGVkX19ot9rkJP/aJ+9GzJkHxziGeElSv7Kgp44mWQyPk+JmXDfT0ra+l6/7Vji9xR17uVio9D/qK1kpFQlWkBicFZ1XA4a29djBvNV0fRjUr9J5XToo6b9aR4fe0OX3G/0tl93efWBQdIrjKajqxHmygCT5rGjvo+LZICpvXSVH8ZoCopyy9/mpAqn0wjK0kkR2V/uTIk31yDNnAkdm1NbtJ5q8Q8knIawGTBqIc/YIvndy596BlWLYluAfxdNGMwQOsOJTXzzTRl4GGnJ2i7niYhTby7n+zzVr6urmDJIc96BKxpWcemJ1ktz1ZY+90amZaxyLb4Pgea55AqUoT2+J0VmCk5xngJ7id+oGwW9lfxxJLsy9YcexjnYEIPrpjMpVdTmcsc6AntgSFqecnh8JXGVTpNt6ovOnFvKuqG3SSFu8LoZ6p7jPSxAlFZuwNPlvN39afSAx0/dvQDC6Hle/qO4DIOiG1C/016sUzD2KqF9Ky7KzOTOjC9Mk2KSB/L3IP0tiRCkLfCXOq7Fb20hySRZ1yeNurmbnLJt9lKv4MP0guwOTedcb29j9N82g/w+giYKaw9MA3YbHnJbMMbuL9jMLRGdGvp8RTEJLFgVcToEiG6jjumHl+IlODQSgK8a7qzrinIidWZTbqkL5rwVBHzuqYqRfZso757liMtuIt5kcHOZX+MSOy+uCYnkmu+KtdzKeNmrohrcalepn3/cDh+L+Jttf62AjPNZOm1LyMTaSPrOWyn6nW9Ql9jEeGzeWtJsSQG/QNToPhXSPWJ+zU6+CZ3fMWiwIsZYw4Mv+fj79W9ArFDehlkxvQENOHUauLY5k4sweOJEO1pZS1XycDvabC9G4wcBXfd12mhQkq64LQ9QQKRVTH2QWWy3oNdgCx8/I/UMPuMMrbYOnT/d/yCfahHEiaB87jkrpmAzeOKt334YZ6yPXyq7PlZDu82JWLLRf3unO+nO
 4vz8nqwW
 VcuEtVuGQIc9alb+3KueGESctLaCfMQTNYuPjMWwAcSU61C1Uxe9A8LAHthQf1v2kEDk0A5iTHX2y8foxYgA2nCb5igob3JEKyJREjH0kejtRoYlO9c2iQSPHeapHaXSli6VLpWfJxXHQOL8mh3thvsdwYUxNo6rWdjcoUS7Um2kQb96hXZPSbDfpYgzygTjaDXNQxLOuBbu5usz3G0BI1PbgLskbueOlwmtfOMwhE9LFfuOa1AhoFOfYgg0OJFkFkYHXizNVlIOvox76VwcVHsoEkjVAiqGW17hBrNiVoSinJ/pK/eGERqVYonhGJJFHW1wpsRIka4u7khSr9fHThrm7mVICFWOPlPBXfe5HEY36EFZXEoIX7JWwoCcep4KMxoIq7F6Wlnt5GxHLO3D7HDEeimXCGCoI12fYkwQZdjIR/ygayNYPXTyeIYgPilGakmML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Note: compaction_alloc_noprof() has the opposite ordering
(post_alloc_hook before prep_compound_page).  This is fine because
compaction always passes USER_ADDR_NONE, so folio_zero_user() is
never called there and folio_nr_pages() is never reached inside
post_alloc_hook().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3c0f4e2baa7..f76d5271b5c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1864,11 +1864,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


