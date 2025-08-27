Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6D6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EADA6B002D; Wed, 27 Aug 2025 18:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1DB6B002E; Wed, 27 Aug 2025 18:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19A56B0032; Wed, 27 Aug 2025 18:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE4976B002D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:08:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A749FC0890
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:35 +0000 (UTC)
X-FDA: 83823927390.21.E07732F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id ADAB5A0009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q+WfCGch;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332513; a=rsa-sha256;
	cv=none;
	b=IyWlvBtZcNM+1PTB6C5lmvYX25tsTPkLPBcJILMT2PG+uQX+mb71iD5Cie9hjnGP2/s4gj
	pjLlvET79G6XjvwbHIov5LPoc68uT/2qCHGiilF69knX9v2et9ATMxe/0V6sjibcZLD3WA
	zRJYM79+HJPhceHBuCLKWn7mafpSEUc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q+WfCGch;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyTIiGqaihmq+uYsd9xO3vzeYLCbCBgmjSTF8jMJzDI=;
	b=Z+MGzTdUnTIZ28mvJboEtNU2rMLoVKjEyMVOMFkFAZ7a2t2HYbknAo8XKtmV1DZ2E/hUXL
	Bbo7oHlCceULy0z2GdOrbVQLZTNAFJZM1zn2qHrhuPdzB41mYN15m+KOQYXLIZVRFfGV23
	wk0JF1OOSYSd53nYP1AzqOuJwfGaXHQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GyTIiGqaihmq+uYsd9xO3vzeYLCbCBgmjSTF8jMJzDI=;
	b=Q+WfCGchr69h7EZ3Pt178WV9nydfF64bO1Q8gv3+8WhyMmxcGIytmwhKSM491We/68/mFJ
	uJ4bNQAON4gMCefryCe87ltfKK9ywFPRFxBxku5MErSVfmioBYy407Vyvy19wp2fLS2r16
	XYsezrjDzeqslICXOjsCxLFfBp6pqz0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-SKfpSwPANCeD7Iv3DGve7Q-1; Wed,
 27 Aug 2025 18:08:28 -0400
X-MC-Unique: SKfpSwPANCeD7Iv3DGve7Q-1
X-Mimecast-MFC-AGG-ID: SKfpSwPANCeD7Iv3DGve7Q_1756332504
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A45A7195608F;
	Wed, 27 Aug 2025 22:08:23 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE0A330001A1;
	Wed, 27 Aug 2025 22:08:07 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 22/36] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Thu, 28 Aug 2025 00:01:26 +0200
Message-ID: <20250827220141.262669-23-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: ADAB5A0009
X-Stat-Signature: wqofd8phhnhfw43dpnpa4obw4k6drpsj
X-HE-Tag: 1756332513-842230
X-HE-Meta: U2FsdGVkX1+T72oXCZNLFyAJ2Ss5aej7STEFdgHrBqEb1SrrPc2TD6O0lRab6smyFmU63FqviLrSSA/PEPSy5oOX1rF3mc9y70MWjA9BDKl4SvcE/AfrUbrQ3p8m8fk0Dw53HNJuvXxHknog6MX2vIOEkGU5E0eA7CrjUU8GmnxKYjkXjt3Z65YNIR7cGsZF2YMQZiqAQBQTWGduvgCJomtibR8oEVHuBas6NmlxI/ij8bDM/EpuWg4foNLO38tolL5eBaiMSMcWVyXW0YwCUgLyRMs3FEXw3dQrmjlQNNg+glMQ3sPPhLwpDos42JBxyV4gu4wcZK6+4ai8nnnuYQE+39sC9e3PF5iKdv/4q0/SomUGDT9D6lJz3MsvQCE0N3eyqOPvcXM3m3jnRVfkCHQHSHwjogq6qnQVZ43XV1pPiXM1Z1OXFRyrr5vKOdSe8IbdH8oC8TmebYhjAULa7MzRX1qPhWJ3gjqhtv+VDpSkFpO6lOiI6G2ee3LyC5bO54vZ0ZJ0IPx21KpSUCnerFrgpqbMBS4V+6ZqgNljNIC2TRP222dXHDaBdNC+FrZD4CjDCNPyoOxgPyhrsJIywdyUm8IHpzj/YiNPLcECDwN3wXFaX+SCITXIt+NULgp4CQOhpiI2rjAj0TMb7G3fuqU7QA9LQ94RWNlXyYGG/vgCxuP+cESP7e3PtQdt01AZRixZ2pEpaJhi3+vTe4jfB1QDlHM01NfL0VRQ1uOCFwHR+2LtdLqt+DHzoOH5fJBa5uBB/SNeXsDCgV6HIarXj8G/+LVMQRQ93ZOAwcijRv9+ZPsvZIaQZ7475bI0e67TnRW2EX8rzbRSgMPipvlLypnlfcE7IMoaLIGitpYNlXW1TyoxvTdrDGEHM9Z4e3hxMR4NgFdvUNidrz6trugxwGso3SnqjkhS4NTEGDPuQsDABQP2KM1dwXE7Uy0z7JV4G+bi/pE/TZXJeK+aLo3
 R69J+Mte
 XpXogkuKfte1T0/aXsNjoYDMsga7xBiFn0n1R7VPOHw68nK/Oa8n7EY1zBHeub93JKeqxWT0+f8C0N/Eidso02oIQc8DXDflCjUQG3/kxT0ISelSZa/+pMajHeCQ41FKcxw+aeJs8+EincClSn+wZpYYo/agAM0NnrslpFWih65kG73Ik/ptjTZdsPfm3kDVxbQ1zFY2JPYflgPVxhiN+EkdmT3vhercN0iYfjC/cgXjl3ndEDIdRWyyDK+RUKdQJZXojNe3YHL29yxRrRj0TKnqMwBUhzz2H8+q/W3tUNp4jZ8H3+cG61VDlDHMPmDOY+voFSomvdVE+/yIk30PGIW8CnGGF7YKk7Vpg5cr91aDHQruPEUbGczHng8rO01i3+bWnZnmiScdlHqWd4MTdM4BQbPunF/XWHYf39aYvdewaIInJzA7OcGg9sCbwJ2b4kcRsvFiacvgyddg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region". Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/dma/remap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 9e2afad1c6152..b7c1c0c92d0c8 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
-- 
2.50.1


