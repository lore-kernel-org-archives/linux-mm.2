Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0127CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804D78E0053; Mon,  1 Sep 2025 11:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B50C8E001F; Mon,  1 Sep 2025 11:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D178E0053; Mon,  1 Sep 2025 11:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9698E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:05:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F22DF13B280
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:06 +0000 (UTC)
X-FDA: 83841004212.04.04C783C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F0CB4000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JBtzxbio;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLi4fM0QNdibiBA1k/MTnIMFu1+uGtd+Ar5TgdqnEIc=;
	b=z3kQMFIXZFL/OUFRqmrIybnMc8UdMBx4+qM7ILPBHFLCKphSgy4TpduPAkCHIAskn1o8z/
	xTqAaqpABWal9dqCHElf/68444+PKxdE1h3Vsg5RVMBHA2O3us5J40iBuHb5FUQbXtYoR3
	0UbVamMgSC9jNHVZCsk7Xh1QoA/lrRQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JBtzxbio;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739105; a=rsa-sha256;
	cv=none;
	b=bvJFS8kc4DPvWRwbiWfQ/andONKOyj7aqhp8XbUeugmZj5bOOhZH0hL+bWINo4voAbhspa
	XJ3uNu3nlcY5DI63XiAo9Nc1ogqpBNJWFcnGsp7Fu8pfr0nz1OZG6pTso2jJJyoZyia6K9
	2Pxbhf/hroghiht7cn9sCzkE/H7jflQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLi4fM0QNdibiBA1k/MTnIMFu1+uGtd+Ar5TgdqnEIc=;
	b=JBtzxbioDzwDm5Uv/+yP44L1euP/Bb1Uhjr01L8EUDmm2BW4NvD8nFumfgcvnK2PP2XFut
	KiN3OCs0lemQaQpqhWIoKJspq0Cq3afPDIeTH5FPYcU9INk5lzKiFLLQ72pWbZfxtK9hZ4
	7g8xnamuBV2j7FOasZfSGDu8ANe21Ik=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-SnJjvg_JMVyx55RP_RE7oQ-1; Mon,
 01 Sep 2025 11:05:02 -0400
X-MC-Unique: SnJjvg_JMVyx55RP_RE7oQ-1
X-Mimecast-MFC-AGG-ID: SnJjvg_JMVyx55RP_RE7oQ_1756739097
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEDFD19560B1;
	Mon,  1 Sep 2025 15:04:55 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1702E1800297;
	Mon,  1 Sep 2025 15:04:35 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
	x86@kernel.org
Subject: [PATCH v2 01/37] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Mon,  1 Sep 2025 17:03:22 +0200
Message-ID: <20250901150359.867252-2-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: hrunahfpok81tbzc5pe35nywdusoring
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F0CB4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756739104-992312
X-HE-Meta: U2FsdGVkX1/P0jAcDcd9uOzKQYf0drcqAeAhePqWuxcIkRLOn/sbJ3Gf6/8GdW7B+Xd+BxUt/JMiKhakvJaWQCoVw0y6aOEEsGedjjmWzKqE34VLLGP96KRsItGT45qs6y4pW6W1dsnyld4HDVzURZ+P7nfsJMBOAnk8gcelmpVh+dGxnl8Z9YPuOjf3DZlegv+5wSAKqC115v6LKPQ9IR+JjjTK08ecA4FAKbSPCNwqm5lqQJemz08fdCmH+30mJv+kH60jxW0PTn2al3oIOEh4MknrjSndMJkHctR7ONxC1BNHRWqSQmq5qCHVr9m9QhC89fz9vuVPZ0v5BF9kvm8W2lCMcfN+YJDj+HHMwhTENIJ8ejFS7dlzSDV0DngdcJwwxEGUWEYHM33iUuSg3wyvt9PkIFSTbvPj3TGKxeD2o5nUsj0I0NCBZoURmqwfPnT+HHS50sJSGTjf0s4VZOuKjVxVC6vldB0WLl0NObCTKOe8gCo5ELbyRjEezDtPt52Bj8TVfYZAGoCIBHRU32Mo5U9L4AjWbtxBWMWRESwY1aChY8sFHUKXW3li/ki6ImbM0VTzgfxVr+mEPDaGrqWGWS/tY8LXe3JZztYiNqTIhN9pqTZm/TCT2F9pykpmFpJEXX1O4UuEGzu/sJ/wA6jRn9y8BLWVETPmucXwXyT6nCENs8lduw4Y9rO2RE6eaO6Xswqx1X63jJ/d9TivwTH0oJb2QJn+9jpZ2fmjnuGzkmmy0pUaXQsLBHXQnzutqtZ81f/U1b4+zYNpc3JE0DKMTnULleSxOhu/ZLjkHWrUXdOokMBYbY2QMQocc2PKhRH5nd0jsBZBcZeTeZ/34ZyU++O2KGVos+7vUUMW/brIncwf4GIo5vKv6vbLj06aNSdrQThMDZXA1s3vbOkUs/t1weg8AsBfEKKX7r72uSdRIGD+Und90lcMHLccd8Yipjaxbmp4EVyCogVcjHh
 TDvH6Q9K
 AbluBZ+gWpcalq7M9gu/q2fC2WbolHohuw2dOvRDiGGM28uzRgR2wlWKYCqf4aVjk/6Ehp0idRicLN03GCGKs2j1WTdu1JGdtrqzRykRAMk52Gt+Fsi60rYxLXn+3bnCd75v3gXC4p4yDmmi9xbuNU5EJnlFaKL4Q/MzdJ5iws481z8RNDBEAanv/+Qheycq6+wmeFr67QDTmc2RRMts3dySawG3sINaYwMB0uA6jBhOcDqJKHJPGHhplECrZMbLPIgjVuVd8OuCX3olaZyHc09yDfUWMvaO+3V+9Wv590MiNahut+bjR3pujLicQOurYSFFLllw+97eJWMQKMnmUKdqa5LiPOw2TT7vWYpZ2iAN5VBGz1mZGyNDjM2RCrfRGvpVArp8rf7iNT1Ra8kB17F4itagHqdOaesEs4u5diTjLAsJ4asl7qscXMzKLGA7xj9B98gKx7YOGpwRteHD5yuFy0QnWugFuqf6QpBjDxycO6crWwkLJlmbbvaETJ4gNYdmi3L5KbKcv7zrPq93UdPSnfrLbaxGUK9C79mAq3plvooA2O4n1x6pat9p8ASZEUAXV5c56e58+N2/REymiRSWDnZ6W0cnilUFWn/wRdlDFRG8h5yypqRRyN9LehgdqJMlW/zWr1szcESywhZX1fxOnp3yaeVtKz8f3tbQhq2ydk9wF4vRTIZUpT95ybF7hB795akjiFIaB6BON2NiGKHoR1JdrJPQciiy1lQcIHYaj6iswAsf5SOTyhnJ+U8scL9znKona2lcaopXN3qtTnK6CHla+JiGug78JEq0LVOSvaHwIbAvce6OLbfpj3EndNasdgSvNkeL+Cmrie6m6G3E8P1O5eMXLq3tZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with
SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
like we already do for arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be
gone for loongarch, powerpc, riscv and sparc. All architectures only
enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
be a big downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section
(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
want to limit possible impact as much as possible (e.g., gigantic hugetlb
page allocations suddenly fails).

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd967848..330d0e698ef96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
-- 
2.50.1


