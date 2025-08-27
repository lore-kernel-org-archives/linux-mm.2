Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD86CA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0488B8E000F; Wed, 27 Aug 2025 18:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FDE8E0001; Wed, 27 Aug 2025 18:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78008E000F; Wed, 27 Aug 2025 18:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7BEC8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:06:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB0DD1A071E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:11 +0000 (UTC)
X-FDA: 83823921342.01.B0DB868
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 019171C000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RNul/T2n";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jt1gUZzcr2XqEG7AN90PiEkY48hGbYno8tKmbdcHa9Y=;
	b=mSdJQAkyLH9HdcVfcWDffSb2P+UPSd1IdShjMhS5eo9vf16ond5nQrsr+6rHxY5Mxrpmva
	AvH5ZJKoY+u0a0/nZyZZvqFVDsUswHyCpZQiFk4A7oVTedJ5ZJzPRwVkdfvwzXTygvYqZ+
	YraQMDVH9Kk0QrzEbH7u2zBpt3Y0crU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RNul/T2n";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332370; a=rsa-sha256;
	cv=none;
	b=q/EQoDJkKRr+8Q+EKkibm90C4mq9qWiPcV/MOxrJG6Tve/6UV+DJdgxM7AD9SQQIhgwLAm
	lZK3ydT3qkqvIlsGLVVtVvl+x3CwcO6YkKgNZzDNPL2dODhimRhrrzQuL2Diouz9tlqEAS
	4hK7Kc455/s922ByXv0S8FoF2i5jC0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt1gUZzcr2XqEG7AN90PiEkY48hGbYno8tKmbdcHa9Y=;
	b=RNul/T2n8dyVChbU0ULLxg9Qpt0BkTDKQR1zY61jS16RSLixUwu2vJfoOOcqNJvvqn60eL
	I0ZTd1+wSJEHo2Y5QSiG4o7JZFtLfyrw1f9p9YrfpfjNoRGMPIFwsFTh4nl15afiJGHyZq
	ww8UzzroUI/dnBr67FVvRijanJulwdM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-J9sCWjtzNZKv3p8K8yqDNQ-1; Wed,
 27 Aug 2025 18:06:02 -0400
X-MC-Unique: J9sCWjtzNZKv3p8K8yqDNQ-1
X-Mimecast-MFC-AGG-ID: J9sCWjtzNZKv3p8K8yqDNQ_1756332357
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 230CF19560B0;
	Wed, 27 Aug 2025 22:05:57 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5908830001A1;
	Wed, 27 Aug 2025 22:05:42 +0000 (UTC)
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
Subject: [PATCH v1 13/36] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
Date: Thu, 28 Aug 2025 00:01:17 +0200
Message-ID: <20250827220141.262669-14-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 019171C000D
X-Stat-Signature: 8d76ewpm4kc8p5d81rmkuyburs4mz18a
X-Rspam-User: 
X-HE-Tag: 1756332369-956777
X-HE-Meta: U2FsdGVkX19Vgkcr4cwt1wpuqk8gkNeDcv1tFLJcxapmTg9cb0gqEbc1J9LwgKob4rtVwkKc/wbTOQbnR3Ka5T8w+sSe5LJUCxvB4ye8l8q/RSevBraGqtg2vpC36oBiS0fuz/nPriDxjaa34npAI+fcVXGStovQk32qu3pPDgEdAS70wS57FeyRZstg/M3k617j/zsqx63BMI+IFvaFbkuiX94Q4STZz9sq/UEG9/z4sbO+m/GgGz408UCBpiLUdt5oejlmw+RHfljUqz0TC1botbnXBM4fLRM+JIuIkpw3URrzIgS/hKmuv6Bh6X94bCSY1zyNn2mEnNFOV5tAJRHssOIa3reSHofep8hF0HXu+cKyG1sEXDUUsblbNMwop8cSiD4CTuC4yAhFFYc+mT8AV5TnWyQ9XyNca0440wzguyfbmgTVgH21jrIrnC/kLcMOUvF+foJ+yrhzj4r3FGY9DA/nfFriwmbBftdm5kexiLYmstGbtxecZnvwmObaimSSYEpB3ofXeF6ksGWMu26+U9jfWpK5DFvv9LiCC3I10GNL7r3SAPWEPaFL14BAcAy1pbI8SBCnXZBf+sURdl4w3DbrDih7hLCvIBmZQxZLrCqZrytlFXkERFf1f/SHZ/lmng9OlsJGONKO0Idik5nbtg3+gW7HEqSrYWmcZXRSNR2E974IltVH/Sh3XYxNhFjGAvq7jFOb/ta+Pvmn8OPq/yBkAfEt9fPd+p+82tbh1lnEv+t/JIFwVth795nn8wN5VVtejRn90oQlcXnQjDHenRTV5ctx7gQSsQQb2QjMO8NkEOoWEBCYBxFJm1FpvHuMnt+53ErcDWxnAfdYI8QTKMXzZq5zt0wU3VhNwuKCLvrRymX8Nm98hWZVhEPZuXArs9k+mY7xKH49P2EWkTvc++ct3sAMeLTH5sFpCGWDug2McOnnSusMKM1WSPwjubrZUtl0/gE1Az/F+VG
 LdhZEDuv
 OHmVRlcZ2KkLsxjI8UkXfsbJOoWOIn6KQ8zimTSlStT96D688O8avKOJHl9y78pgTS1RwRhq2YOa6r4yboxQliAzHXWksPl2MPV35XTPWqWtZr97KDYRLksCgO/OeAZrfh7+TCXK/I/fcCjftGvi6RP4XtnJSMev3l6s4N6xOiHYtOZ8SY5TgQ4vCCStYZucP0pubPPnoGu4OSGTqci7zwaq+pAWtvTFj5bwkSfCwUI/SIuEqOYa1NFSmQce+K9wx24WpWnEnwb0vSHZeax+OrnUCALYsT70+lHElnMIOaghMvk3whFV5ZnbVFkhE8kGt97w8mlevyWy04afAvrbsBdizZs6x/4HLUe+AqPL+g5iPZAYcObzDblQ4BVvsDnoF2TQH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can now safely iterate over all pages in a folio, so no need for the
pfn_to_page().

Also, as we already force the refcount in __init_single_page() to 1,
we can just set the refcount to 0 and avoid page_ref_freeze() +
VM_BUG_ON. Likely, in the future, we would just want to tell
__init_single_page() to which value to initialize the refcount.

Further, adjust the comments to highlight that we are dealing with an
open-coded prep_compound_page() variant, and add another comment explaining
why we really need the __init_single_page() only on the tail pages.

Note that the current code was likely problematic, but we never ran into
it: prep_compound_tail() would have been called with an offset that might
exceed a memory section, and prep_compound_tail() would have simply
added that offset to the page pointer -- which would not have done the
right thing on sparsemem without vmemmap.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a97e4f14c0dc..1f42186a85ea4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
+	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	int ret;
-
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
+	/*
+	 * We mark all tail pages with memblock_reserved_mark_noinit(),
+	 * so these pages are completely uninitialized.
+	 */
+	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
-		ret = page_ref_freeze(page, 1);
-		VM_BUG_ON(!ret);
+		set_page_count(page, 0);
 	}
 }
 
@@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 {
 	int ret;
 
-	/* Prepare folio head */
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing/preparing+freezing them in the
+	 * same go.
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


