Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC6B7CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF668E000D; Wed, 27 Aug 2025 18:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6298E0001; Wed, 27 Aug 2025 18:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC6F8E000D; Wed, 27 Aug 2025 18:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9F18E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:05:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B0A65BB03
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:04 +0000 (UTC)
X-FDA: 83823918528.13.54E29E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5F3418000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZO8ARR7i;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdduxfP9sOW11CIIetzrq/g2aOdRCb5eN+kQk0XudUI=;
	b=W1KclHmGwhKU+cdBGvtSS6zq5gBwAbTAD9ZRHCTP2SOz3OGBDQpe3rtzw4dvpy0PgxJ3Se
	Af1+iaHtQFbfvhh1yNmoYYbHDtUrJZRapSQf5SthPFB/NPOhisvOTg3N180rz/qHLHs/N2
	eHtiPSYUa+p93kJdKGCiQ7Yitki4S3A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZO8ARR7i;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332302; a=rsa-sha256;
	cv=none;
	b=KbYw/86BUQcBwqaSdKFMQ/BGXLsxWn2kfs9q3VMVRtYj6UiW/Z3FkEIvB4QkSNSvhrhvC7
	41ek9nkzQGHeH+NxGtEK1H6HnWxflwtTEjiukJi69LNmkQS9Z8BS9/cE+pmgvwRwKXBTXO
	GnwIhNV4COaqd20eoYQ3AUvTy0okLg8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdduxfP9sOW11CIIetzrq/g2aOdRCb5eN+kQk0XudUI=;
	b=ZO8ARR7iZErcRE45NZ7WXVcXe0hoJ/A/nv9Qu1TmfBC4b+7f6ZBRhbxk5OSUT2d6SGT2v0
	CMkmkI/ZVoS7BHcnFiaP84ZrMA3pOhwZFUXSBG23xcutJho4FltYCicwJbsaFMnIZwaEoZ
	LkbMtvmxHGolF4qmepebuGScTcfROGM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-EpEDj_iqOtyJ7pKJWv6ETA-1; Wed,
 27 Aug 2025 18:04:58 -0400
X-MC-Unique: EpEDj_iqOtyJ7pKJWv6ETA-1
X-Mimecast-MFC-AGG-ID: EpEDj_iqOtyJ7pKJWv6ETA_1756332292
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 995B919541AC;
	Wed, 27 Aug 2025 22:04:52 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CAF5B30001A1;
	Wed, 27 Aug 2025 22:04:36 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
Subject: [PATCH v1 09/36] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Thu, 28 Aug 2025 00:01:13 +0200
Message-ID: <20250827220141.262669-10-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: A5F3418000F
X-Rspam-User: 
X-Stat-Signature: 6q1rs4b1a7zjhdqnqk3hkk3e5ygj1p3w
X-Rspamd-Server: rspam09
X-HE-Tag: 1756332302-909129
X-HE-Meta: U2FsdGVkX1/I1fJywQl0sajjr4UTAM6kCR4D4Bs0JjdeX7+2yt2pYoErfib/3L+TrZjVOGzI3KjYKLMO8LqQ0CiJhlK9oZvF8yb6ZDS1AJTlYk9SzfgxB7ThRZyB80B3J7nyZ1HUGPizCUmsIVtMpVb84OzmkcaGV6IApjN60t5enkwi0hc6l+hSIM//oyKc3lkI7yEpr/CAJM9sEFwZPEHRkMBzj7rKXO6p1UA6F00w8OcDwHzncaTEfDBBHC22JTgynOMa6D6atEUR4aK/GJbk9VOypsBN4NQKf1Pj7ccSne0fK+s2p9QLAtFrNMqeDbbfc7IhhvAPvnISMGYVHk2P9kTwVtutswJrw4CA6nqo8kZ0T5xQuoaQUQuR9POmkP21Oos0AJ8FervKjAoPVo3JZ/DG4RewgBqLydSQ8awxeaXh8FCdT39g+QSojPFgrbp12ee2vdWKWXvWRQWtr2GsX4zRkxt4GADaNx/hBhn4feqSdOYVL+oxxN2OeOeDLBvTQN46dslG43x5hMhfue3mW+WIYsbKQNRGd09cqF+eGj3RtRFSvyovh9y88rwRLkqi2F3gVrQGIPDCeVwreFLeWiZlWTZWIvnnJRxj5oK3MNs/l+bUzQHksRCer25Hs+X5wz44gf6M09MicdTAaY1qiB3wWINpJFwo12nHh5XSmA2rd7eszYZC/j4vnwSQHkw7chaQTTXynirnQqqX4QZVBZhhApU7j2Us8TCDxbUJWwZR0aKAbM+g6f18k9owTEY0dHBbtTdYjlV2aPIbKseNjdqaM1lSt38UfwXLLdSpIR+mTBfhE/4D5UDb0Wsqi9NUaWkNIoKV3D1FAhC+dvWS0ntmj+/BpNZC1tai/E2L7fKQ0QIXFd1CjAA35HgsCXRM8jWvYAm2eKW6Kcnx5O+gpbNG/MI2EkgY2+uITPzSqR06ttxpGQhM5xaYIlJ4LjyKIy0dsM9t4ReaMAK
 DOCIyGyu
 4kgSRFZQxnF8/HPM756IkHgpc3kTOf62MOryKYIHUR6cxyZIbFsYBt9ZmHMaHLyhJvsSzmNVL4Tv9Rn0EsRMcJXj4BWbtue18FCPReCEmMPfaDOnTlUZPcH+EHhAXNAfbs629UnYaIKfpQvDxvfw0mcK3Srszz/1ZrLqYEuvjrmYz9qAJdkJX3QMoi2IIz4c7t9r1RaKgTvJiZOJk4UMjVQ/AczZYxHuIAb8cghX5Tmq/HheTGk+ZiJohiSadrUAls1l6uFQGpq6pFnmJ+7+8mX6FwPnfELev4NTtJTJq91910859J4OY4Xpvzi/wH0ZofPX6s0lTFBWmu4xenlpx+UG/QyA5+YVPKtxZwqGLoY/qBKP3+12dMA8vsJ851Kv5ZuEu+XoMloZaNUdW+mo+zcLGpg==
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


