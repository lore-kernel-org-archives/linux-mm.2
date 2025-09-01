Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2387CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8438E0051; Mon,  1 Sep 2025 11:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FC28E0079; Mon,  1 Sep 2025 11:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994FA8E0051; Mon,  1 Sep 2025 11:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 850E58E0051
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:07:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A8F7BC053
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:12 +0000 (UTC)
X-FDA: 83841009504.27.5D4231C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90DD318000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:07:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AU9tzPJX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4lKJy8SBWSrsm7Vh+zb8hrnJCJALrpbQ5NruWVxUgs=;
	b=bq18siDq85uDQKrtqeOPBAEZdxkl6/0mEJ2JuroZStTjtyN2M7g3C6ph5eBAh/ENqFOfHo
	lElYffiVI9cwVNNgHW2+0vQbXtXT+dYjFL/hQmSp/38vnNl/ZFJAvWdwgvVK29HgfT3J2j
	zcqHDxEiBJO1YDtmHw8aamS0kRptCmk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AU9tzPJX;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739230; a=rsa-sha256;
	cv=none;
	b=a+NOgp0lLPlE/P4ZNUbPdhJ0iPev3DdiYWqXMQolRA9scALVmY7aFIreMmLmxv1Ztkbg9I
	tmTwoaBuugIHZ5LZ7gUdYFydyMrHqgoj+Q9B+TIxJ6QiZPmIj9xyQFN9UqtGldefroYNmd
	4ClfTPI6nZ/OrUpfooIq4jWUFiPKYZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R4lKJy8SBWSrsm7Vh+zb8hrnJCJALrpbQ5NruWVxUgs=;
	b=AU9tzPJXdgNCIIfppgrMETzLajXQE0w2rX1YW6Is4YP2tfFid2r3kQzst/hBMp4mwGtshy
	02HwiptxUDTDc7ITw2iMa1vVArwZ7rrbp8oMFw/aoIfGSu+WJTA9JaAJqghTGIlLfmXfev
	9t69KYka+Ms4HbZjqGzuQzXUTjZwkFA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-6C4RCufwPEqzyZW8T0eORg-1; Mon,
 01 Sep 2025 11:07:06 -0400
X-MC-Unique: 6C4RCufwPEqzyZW8T0eORg-1
X-Mimecast-MFC-AGG-ID: 6C4RCufwPEqzyZW8T0eORg_1756739221
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 331CF195C27E;
	Mon,  1 Sep 2025 15:07:01 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B7921800447;
	Mon,  1 Sep 2025 15:06:47 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
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
Subject: [PATCH v2 09/37] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Mon,  1 Sep 2025 17:03:30 +0200
Message-ID: <20250901150359.867252-10-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90DD318000A
X-Stat-Signature: 8ajobnnrf3ohnr9qgdp35m3dqki9wu4s
X-Rspam-User: 
X-HE-Tag: 1756739230-804910
X-HE-Meta: U2FsdGVkX18h+PlGjvswcmPu/tDKUr7v08HjZSMAD+oyk0fWiaj99lONVC3MQYexaVRQIV1ptCKjaTPdeDgBb8Ipoe969cC8SN3GCyNMuRaE8jRs4ZOvndDjapb0pKrK2cftQ7XTbnJxWGtrJKWbAP+5CygsqmlkkBfvMdJfa59DfNesl3gQ8nCzYjvE6th1YZ8t+9WrxuI2x48L1cKFpwi26z+8XGUP/Gq9GjGeG9HyYDLOKP43AmR8P5uqegAk4xK6YU56KzF1RZupS1eDJZMsSXdQBiUu18CXfLxcr0Dcghr/ajafT9iyk19y82+TgycCtjGeme/PXYH2dXmQXzLRmPZwT5P8OKcz4nLsiJ1v2jLZ1W5VVSRBB6fPeMxnEw5wqCNZIxgUfX9DwyCj9grU9a0VAcshwwSePqIz9DbzvkgprMSWcQF/gNrtFMy5ro+HIVUmPyhS9pjBCABMzjTcOCrtY2XdQitnYS963x+6ZwCPIw5I6kHzfiaHYewWlmGF0LsSBDmngzGnQ3x1LvM9N2jR+5hNyJ70p8AjtsxQjhCZ3RBmrLCHy51mIhvnC9Yvzzuv3PBy0YYmnXXmb0r4HEZL+ivZK9B2Ik1wJybZTUf3vYOdYuREcPcsoS+U3Ap8ufJtyA10TeUKpySuvxx8LoyP0tGpHiApG5fO+Bt6XqBzVfRU3azBlR+/bH4PHFD/64pZ99IbCnB8p5P5VP/59J4whjsrjPulsXA4MlHnxaDpwfqlPzrL6chYIdsu3i/jE9cr2+4+UJNeSElJOS6DOjDON5XHGazBY0AlKK9LIwMBQk9k9KBQGvQeSuOexqcxjrb5dNjYYJC6cJXhTLBP855QjflSORFMGHE/KYgK5oYrEnA/vU6QffM6WB71OTlZJCc/963qyz7ETtCwoYhiWdBgepM7PYDzmpsyP8q+LImnIl+az0e80IvO1eKXQWft+fsjoN5SDEfQ8og
 hEJ+s+/g
 zzChCybH8puRUeum68Gjg+srnOd47QwblDCr3+eUB4LjfLVAYUaInbP8iG4Wbgd+oaZwDjYtxtMeZsYRNOxLIosmxtmDW2xwNOtwkDxC4DuKPYOb62UjdW7QKHBrWivX2rFDpbJ8paLhRN40IHwyG8/yAZE4/rBag1oJf6XCWN8lb1KR0bSzguxlPQ4P6n4vDOKM+9/itzXLSf4Dl0c0++KaglS9aNhHbZwjzWApTwqMqaBhsEuRyINr71Nn3ez/9UrMvYhs7kmB2euzYmVfszrQeJECVtnO7RUudv7WiORTRrizocqOv7uBRxHxL9puKNXZQvwh6rxQ771SUFYEDraNKk1dFuqBleQB/cMKOAYC0YthvwMWXl0kQ9ZqfeLQ5LgtsX6T79ujhUXkklV/VXyy/MFub/3AUJZnjPpTqigO5R5zFQQp+EjopKZEgC3O0HXXVhSdaDpE0tAyC9jQn4FnHu2+/8sV+GUT1n8UKZ8NMOTQ3TW1eO+O7938kRRAR+S/yQfFvJutLPwQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Grepping for "prep_compound_page" leaves on clueless how devdax gets its
compound pages initialized.

Let's add a comment that might help finding this open-coded
prep_compound_page() initialization more easily.

Further, let's be less smart about the ordering of initialization and just
perform the prep_compound_head() call after all tail pages were
initialized: just like prep_compound_page() does.

No need for a comment to describe the initialization order: again,
just like prep_compound_page().

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/mm_init.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..df614556741a4 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1091,6 +1091,12 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 
+	/*
+	 * We have to initialize the pages, including setting up page links.
+	 * prep_compound_page() does not take care of that, so instead we
+	 * open-code prep_compound_page() so we can take care of initializing
+	 * the pages in the same go.
+	 */
 	__SetPageHead(head);
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -1098,15 +1104,8 @@ static void __ref memmap_init_compound(struct page *head,
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
-
-		/*
-		 * The first tail page stores important compound page info.
-		 * Call prep_compound_head() after the first tail page has
-		 * been initialized, to not have the data overwritten.
-		 */
-		if (pfn == head_pfn + 1)
-			prep_compound_head(head, order);
 	}
+	prep_compound_head(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
-- 
2.50.1


