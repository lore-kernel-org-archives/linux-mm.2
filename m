Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A44CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E0E8E0085; Mon,  1 Sep 2025 11:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997828E0084; Mon,  1 Sep 2025 11:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837D68E0085; Mon,  1 Sep 2025 11:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 695518E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:10:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10FCDC08D5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:44 +0000 (UTC)
X-FDA: 83841018408.14.E164706
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 37AA21C0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NlvaKFNT;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIzsdHZ3fBP51ER2numDMmmgvS6jLZjlCpLLEi+lFJs=;
	b=C/takYK83PW2u5gHfcTIjcC+grmM5XXLnoXSy0Wm3EXRRY7IefUKBmOTSIWJiqYrvC4MrI
	cCbuWie8NDLNuomdc6xyHWJcJ0anMRmsXXpkaXb5viUOXee1dTpsX0kUPmYxQSMGrElVuP
	HlN0wow81dyXEVfFw4iyid6LJRcvDVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739442; a=rsa-sha256;
	cv=none;
	b=WYhc+7/1CVWB2khMfqKcjDeIi91aUL7SdBpaQ9rfG/oJIkEoBfVPzWl8uTbollEupdprjQ
	z8XLE82xX5+oN6fk04KmQrvmwNjuFCFnbTnfuaXKGYa4dgwYjO0nyQXOx7Hk8WhwjwXDHu
	UIZghoTkSp2MWdHF99kc2JaIw1ljHrQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NlvaKFNT;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIzsdHZ3fBP51ER2numDMmmgvS6jLZjlCpLLEi+lFJs=;
	b=NlvaKFNTkc034UYI235Aw3j/FpdiwIdzLrgbFd8mf09oLb0yk0RZ1lOppjiV1leEgS++u/
	GhOXwD0q/gA7yPVe3bqWAsnj/rRX71GtObSKuECrpg6IZdlH3KP7AigqUxsW1zWG7PNMiE
	nuKGDiVblc2Hr4YmyfLo/ObbqDV9bpU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-b49aMdn1OuiZpoH1EqfeVQ-1; Mon,
 01 Sep 2025 11:10:36 -0400
X-MC-Unique: b49aMdn1OuiZpoH1EqfeVQ-1
X-Mimecast-MFC-AGG-ID: b49aMdn1OuiZpoH1EqfeVQ_1756739429
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9D7819560BF;
	Mon,  1 Sep 2025 15:10:28 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F426180028F;
	Mon,  1 Sep 2025 15:10:14 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 23/37] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Mon,  1 Sep 2025 17:03:44 +0200
Message-ID: <20250901150359.867252-24-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37AA21C0016
X-Stat-Signature: rr6f34wzmzd8zn7za81pebmas3ksd3or
X-HE-Tag: 1756739442-533931
X-HE-Meta: U2FsdGVkX18Nge9+kB8B8yTuDMHM1aB11wVYk4d1LLsaXs3PGWPh9l+SHv/pNMRzUas+LkavJEWPPo5l6M4GmB1H+jMKhMumW120KLtd1up35TuWmnbX/GtQ3h1B7v0xklSAX9cGDX7ym9xDs66xBugoKZI81vpi9ItflSBX6MoCpELGhrprhirJxqoraQX27XTYd2tYaboT7RRy1x71EGZ/l3fSS7bAWED202l4jXJWmbrfY4iVxEArVjxC9Y3xgWuBRApexMxoyWarZhWVc40Q3CdzkwMuyOsLWi0sj3IFQ0fariuGPkvaTmrUp1VmDr0L/YMERSvgJFE8o486mR6eAIlaz0EbKxO8TXIjOMz/oIzBd/fOKUdHcd/m/QnYJTnvMYrWeh9GPhjG9GygWJoVorFXI2+mvBApfHp46Ib6jVjF9mhiP75NVl9vm4mzp1E5lYW8lfUx2XUNiX0mIer7IovfB973iyvK8QSzzxalAWW/dqeAjKppVe88kOPyguDBV4SIGiLTZk/Wr6/A04CwAwRGXjohyju9id5/VDR9t2Mm4f3JhSPMCVWMIWHIB4FWZBOMFzSNquQQZIQMZ+R//0F7MSiZPiDdyFGYtsNPE1H/6ttpnD/I1RkIua4MOay97wXhY0bmsA0fUC7ducBxJ7wF7XVJQUTMhV8gsMVHlZhOJmKcDD1UAtk91GBuQ304iNPmfnz9hepj0VTodvNwUn/n3dIE2c09QWOyoF647/aDZTGUcOd2IL3vuRd2tdi6rzpdfdWtV0wigEgXqBGoohTZUHyqh0UyuURFlXPKrqELXrvLPgOTwvfouCWLcAc0VOaasyUD3wzp4p38BUw1aJV0jrySnLsXGaE+/2xk0ea4jF8Ln7knw4br9w3n3x+Zvu2WhO4ydAUD+Mu3qSMk9wOUJs6wKaOgXm9lNZp1soV6YgV7xzW14CuMIPfSIUpd0w4t4O+9fzs7i4p
 0KSMZtlN
 eCtW57hBbM4lUTJzGmvRscJKW3GvQD2Y3iqg+AxEDZUXzfmzMgDNh2AAGNEg2vi2f8VaYnqy1nognuV0UkEj6ja7ZZo/kUSq8SHWINsCmVCXFvoCZP1iWM3uHyUZ/p3TjbbkvReAxwhO6e8g1OON1IW7ERDIbZBvRFGC1+TpY3WXojD89ydJLCVdTWNrGWc7W3WDph8Pap7+8iplVprmVhthJjG9p4yNZk6URZTMWg8h9raEIBPxh/fzTR74+mtAdgPmgoS+ECxxVmQFRCqOrvm45InEzWL2oNS9A2c9N9ATuCX/LBcWHas7XJT+28Jb+bEPKFbLI6xiyRbVgsCPHB/Poze9a/m2ccrO2suPbl+UUI0JiwDQGaG1i7nBR8IFDi9WlB2/jJrvzre6SMmYrDWqwzSqWlSGxBf3nVy/QgKyeOaGLKAz+4vIle8OXN3VVfiFaaEbru0GHBjNavZz49cAVbbk2UjsGkpVwh7srot+VvFIIfwc/hRlk/gSdbBVBLbKvY7vk6r0zbRgqEWORXgQCFHZ8Zo2dtMzCMTdhl4LT/jNEZzhNFCB7sA==
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


