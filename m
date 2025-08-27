Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F30DCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D737D8E001B; Wed, 27 Aug 2025 18:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24FF8E0001; Wed, 27 Aug 2025 18:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC108E001B; Wed, 27 Aug 2025 18:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAF748E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:11:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FA6913A279
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:42 +0000 (UTC)
X-FDA: 83823935244.06.D04E05E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB7D5140008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hRk7UZ0j;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4GDJdCQl51NuSKZxl+9iTiOXWhrOYbM3n+02Irtvfk=;
	b=UIFcmeJ6RwRp0rbXVeZX5k6QpiLoxGPBd5r1X4qIwmIKyjUeKxxN0bpzdeOpUORqmkAP5B
	6h9ld4uCziIrj5ph8j4V21ICRSmM0kCFLSzigQv6Uc27Q2Tn3Qfkg7tlNxyU2YttgppBLs
	s0VLWpKk/3EBQuELvJ2kg1mH0q/3uSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hRk7UZ0j;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332700; a=rsa-sha256;
	cv=none;
	b=CQAFx2I/875fzkSK7IxHI+WaMrAlwv5/KGwinkSKa041WfLtJugO8VQLmd7C6P+kbJNR1A
	8EiYToHIOUvyBInvjsq6+RxXICsAF/R4vOgs5kWjnYX8Pj8f0MGXtKGIl4ApSu+0ELfqmV
	F6h50waji6QO+CvMDVqDgfEMkXZhSf0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4GDJdCQl51NuSKZxl+9iTiOXWhrOYbM3n+02Irtvfk=;
	b=hRk7UZ0jPcMlFIXNh72+z7xjIYD79DhnoeA0WRydEkRWrr39ZCFP34cMn/gXfGpSarSH2Z
	DCBb6vY2ORxvclWpjMlUQLaRduELuKsmsMygXrvDmnzUUAzohGgaQaFqqt5ODrSZjfO0eO
	Y2rzcFsguHOsHKEJgy3ayRA72qByu0I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-9TdTk-QAOCyo3sfI9-0djQ-1; Wed,
 27 Aug 2025 18:11:36 -0400
X-MC-Unique: 9TdTk-QAOCyo3sfI9-0djQ-1
X-Mimecast-MFC-AGG-ID: 9TdTk-QAOCyo3sfI9-0djQ_1756332692
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1280180028E;
	Wed, 27 Aug 2025 22:11:31 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 78E0330001A1;
	Wed, 27 Aug 2025 22:11:16 +0000 (UTC)
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
Subject: [PATCH v1 33/36] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
Date: Thu, 28 Aug 2025 00:01:37 +0200
Message-ID: <20250827220141.262669-34-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: CB7D5140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ptcfeqyigpb7bhhptr7wscnmapcoppok
X-HE-Tag: 1756332700-347236
X-HE-Meta: U2FsdGVkX1+N7WArkdB/Mk8AvW+birYbfG+5InIIcaufZgj5GrCxAgbDdcEwfukyhCv9hQv8sxnEHsaUFHpigeX9YCVubrogjCdaCfPzHP7N9Z478yfkQuIlyB1BCesxim4rt6urmEq5NfZ2uPM5SxHVYftxY1zJBpCM4zB9BwnKwAi9ZghU7F2JPCTtUIgJHsTFSo9hYxpjK1cgUJaTZsezwO12i5qAoGJ3kFgKN8lmn72bk+w7HjjLEfpulFCqVbi4oie+LCrRBTX2/2xrQ57NQGWyFrKn1LTNSU6ILoHoqQcYZ3WWVNMNyy25VdWjt78SkrB5QsxDXu7hBYAgtWml91s11AoI8tvMeYK5OYEXvWgRh+hmAHhKeldvWu6XJlNv9PIxqCZzlRxiIe4Ma054jWBmWPlo9LfpHjYt/ZLKEpSPThIbspKqdBZBabllizmVC4V+O5sUEcFSKr7edKPjrvo2IB14XMTZiBHdtroHOH7IPfEkZKX0tYYxhlzXmg4f+cb1a9nzA3uS/t84n0r5FEUhkEozUjoeQVfYkXNL8MpODS2vRCAVbod8LaWh8RgqbJoktiiMa2x/pQ94UVjThEy1pV+j/4G4EA1GSTJJb4JujyPW/LpRtMG1TCOo1+yC30jiD4TLrkCqsqVQlBOfqPnd0gA5khZvsTEHaOeoBkxZ9e2jM9LbZ79v3Rq5gSLvC3fDY55LWQxdL7+Rsd8kxUQaGptsCggFMZ1VN+HUkiRvFUptTCp1+IDmNH+PBFP/kEzCQUVpOQRi3DCRh3y62fnCNooGIUen4kkdn7e482ocBzvQh83SPYIi8Awzx1xfBunptHbO4U+WnRTEmI/6B1S1WyvYPwUKovZNjY5vl0Y5i1h6ZK2ikh1gsqEJMEe6K4tuoXpt82/OpeuPaqd9F0hLpTP7m5HXd1u1lU4l4secIZLb2DWnIAsjGEXCS6lHgCwmiVms+7XTPTE
 vlecOHte
 fSGI6ijWhjQWfLgumqVBfTfJuyoH57LAPVpi0/F2aCu60Nv2team1onDDiEEwiqkvg1sdUNHtligjc0uv3PkuJR3+7YCReTIPHU+BmKQmO/ttdwpnuqXs1uOJ5d31TV2+qBOkJH+qVbsmtULLIbY4iaqyzb/5KwRidTDqzn8irCnCzvjKwLgp44OxIY90wcRB4yHl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is the concern that unpin_user_page_range_dirty_lock() might do
some weird merging of PFN ranges -- either now or in the future -- such
that PFN range is contiguous but the page range might not be.

Let's sanity-check for that and drop the nth_page() usage.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 89ca0813791ab..c24f6009a7a44 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
 static inline struct folio *gup_folio_range_next(struct page *start,
 		unsigned long npages, unsigned long i, unsigned int *ntails)
 {
-	struct page *next = nth_page(start, i);
+	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
 	unsigned int nr = 1;
 
@@ -342,6 +342,9 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
  * "gup-pinned page range" refers to a range of pages that has had one of the
  * pin_user_pages() variants called on that page.
  *
+ * The page range must be truly contiguous: the page range corresponds
+ * to a contiguous PFN range and all pages can be iterated naturally.
+ *
  * For the page ranges defined by [page .. page+npages], make that range (or
  * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
  * page range was previously listed as clean.
@@ -359,6 +362,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 	struct folio *folio;
 	unsigned int nr;
 
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
+
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
 		if (make_dirty && !folio_test_dirty(folio)) {
-- 
2.50.1


