Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758FCCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6C16B0029; Wed, 27 Aug 2025 18:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B773C6B002C; Wed, 27 Aug 2025 18:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F486B00AD; Wed, 27 Aug 2025 18:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FEBD6B0029
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:12:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47630C068C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:12:01 +0000 (UTC)
X-FDA: 83823936042.21.184A56B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 906901C000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJ6Ya0Oh;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaPdsETQ5qU/BcrWAtBVOePuWmWOKOsgMpANROeM44s=;
	b=LTlf/8de2RmvGK6dWJtmaGzNEay9iyYyl+slFWuQ6LfAUc5OVyHMeJDrcCRc6Nwl1Afq5W
	lf8f1+cY+VkQYNoCMXOjPzrr5gEyq7BpvpgqEQSiLKyMOQZ2BD+BqbVd0vXsaop09zRk9e
	qopJArr6RyBed0PDZTIIluttE8XF/vs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJ6Ya0Oh;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332719; a=rsa-sha256;
	cv=none;
	b=SN18YrgcwZt8CPlb7KpCnGTwIRfSLy8SMcdBnJDIvCorJuPTBTgUVd5xbjEozSbqFs5Bh6
	3bsS6Uj4aOFiGpRQI2RayUJNLeW53VW6D0pY0EhkxYAsFDJLqmGmm32Zm4mCDnV/fi91W2
	lIaMEdLEOxnisawzURQ8Zv7lqY4w9fs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaPdsETQ5qU/BcrWAtBVOePuWmWOKOsgMpANROeM44s=;
	b=fJ6Ya0OhtlcGjs0AOh5+k1l0po9QJqVFsjNlrj+CefzodB2T2uPkQUekuWyqNLwNgCI33F
	isbRB6kCH0m6zFbd3dH96bz7+qiwDu4XjEp/Nxx3VNdMYi046YRatuy2NpK3DrMnrgytHS
	qHpGMfLvzAkzFAcDz8evvGlz1skzvyc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-Snfm6E4cPnqT__aizlDo0A-1; Wed,
 27 Aug 2025 18:11:53 -0400
X-MC-Unique: Snfm6E4cPnqT__aizlDo0A-1
X-Mimecast-MFC-AGG-ID: Snfm6E4cPnqT__aizlDo0A_1756332708
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAFA8180034A;
	Wed, 27 Aug 2025 22:11:47 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D43430001A1;
	Wed, 27 Aug 2025 22:11:32 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
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
Subject: [PATCH v1 34/36] kfence: drop nth_page() usage
Date: Thu, 28 Aug 2025 00:01:38 +0200
Message-ID: <20250827220141.262669-35-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: 3dswn8itz1eg57137z7n6iqiswhoyku7
X-Rspam-User: 
X-Rspamd-Queue-Id: 906901C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756332719-6307
X-HE-Meta: U2FsdGVkX1/ctSvFMTC/2ltxm8YY6lW78iua9IQ21BnCgXmTQVDr70DrPzQYy8JhIKc/YgOiJORtKktj8Rqpk9R76Bvf1CZ67nfbN6gTtDUeYnlIi7MRkj8emP4pJNdJ7RIGiD/IT5Nv7uM82NRMS6IRq+DDktBRAqFcoaR8IeSwztW3Ugpg8hW7PToFpZXMXYnB9XRGYrE6E0fCTPcOMPTZ+2nkv6IQm0Hs0zrhO/qyXxzjFlWl/xsbLwadF3Eb9r5XGSTEopyCoa+QUqmQFge8nUhBTXKKy4lajRTLGetV8/PAF+xWmbGMJmfU5HD+/x3ujzsZcL+fCo3Xm1lqoVnDRxkmG1CYMfUsZY8GacYJ2nwaVztnOUpFnXtTfc1LWi1auCbj4/TBKDYMSNHp1cTDyui450SR/hgofmHE8QSGsXa/1IsZBNAphxtlt8Dy25abd/gLjth394CtMSO/VPFJqx8q5FDhsUGOQnfWCX3zDq8SsUTh+EEJJltbcQzJwf9YCAIomMIIBlXApYb1/SUdM/UxmciyNfTlxZOMLeCGxRQjM1x5O2NyZ7e4JGUzPKhRanofm5ShtgL21CPYbkXdxaUAm/x+K0ZsQoAxIVhtLNgjuGIeXgLl+xrgEVZkq7AguPna7ZR+xHYBGiM9TKWYJy5bPAvEFTkPcpLTaFgKMb7XdVP9mTvD8mF+fJ36OE9ZF/CRoE8mXq9zxG8DXErsUdQoVDi8lHLH69JcaIilRbwQ1H8hRmnAA7/WtKrmlkA/aRwxywvMjuDujoTL6sirgQlV0xrm56zISroS/MNgY0AmFvf39uowmGDaZryN05sJvqdRpbyUEt3seiturmbLWRPhCe5uNKx2DMGvq8LPk8b11qlOS+M2iM7xoApYk5d02hBHsclBsU6nioWugZWTviemAOnrDjJVr9PgM69OIffgf1y0AkXGxtjw6mlWwsZZqeX3Qqeic4hUidi
 XaCJCrw7
 Lfb3T66IE15G99t2N/ZooQPl/CJKWzbpI9g8sloAKHvVZ8ZtlB9yh3QYOPN0GPEqwHnZlfP+uemIqnFmYETS2O6KRY1F9/hXKn2pL1DEaoYvU/BB7vsN30D3SJuYWDwhdmayLDj+ncxn/f+vEscIQdvxleY6lyjOUfgjdSPBaJpjcrnkl70vVee+kvo2la+yUDFkkNjhLU0NTmgz7Y0S0TZj4GHwIh+llrU6KB4q9VEcAZVgpuAKaeRnfNRuxqU3DjohPOcp4vVcm6HcmExpl6OGJ6YxhaTO8tV5ULe8bdNsoUIQ/UCgVzYB1QjDRV5jqQDiEB9JaBpF3m5fI5z4drvIq1uCDVSLMB6J9F/2NfiggBK1CWQMS1STezaf/p0ySSeaS5OeM31DdckqfsZ9EDRaYWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to get rid of nth_page(), and kfence init code is the last user.

Unfortunately, we might actually walk a PFN range where the pages are
not contiguous, because we might be allocating an area from memblock
that could span memory sections in problematic kernel configs (SPARSEMEM
without SPARSEMEM_VMEMMAP).

We could check whether the page range is contiguous
using page_range_contiguous() and failing kfence init, or making kfence
incompatible these problemtic kernel configs.

Let's keep it simple and simply use pfn_to_page() by iterating PFNs.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/kfence/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 0ed3be100963a..727c20c94ac59 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -594,15 +594,14 @@ static void rcu_guarded_free(struct rcu_head *h)
  */
 static unsigned long kfence_init_pool(void)
 {
-	unsigned long addr;
-	struct page *pages;
+	unsigned long addr, start_pfn;
 	int i;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
 
 	addr = (unsigned long)__kfence_pool;
-	pages = virt_to_page(__kfence_pool);
+	start_pfn = PHYS_PFN(virt_to_phys(__kfence_pool));
 
 	/*
 	 * Set up object pages: they must have PGTY_slab set to avoid freeing
@@ -613,11 +612,12 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
+		slab = page_slab(pfn_to_page(start_pfn + i));
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
@@ -665,10 +665,12 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+
+		slab = page_slab(pfn_to_page(start_pfn + i));
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-- 
2.50.1


