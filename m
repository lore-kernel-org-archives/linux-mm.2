Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C74CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B9D6B000D; Wed, 27 Aug 2025 18:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB0E6B000E; Wed, 27 Aug 2025 18:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3986B0010; Wed, 27 Aug 2025 18:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B72D36B000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:02:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67F6A1A0886
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:02:54 +0000 (UTC)
X-FDA: 83823913068.09.0A0F811
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9001840019
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:02:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErBvSSOD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332172; a=rsa-sha256;
	cv=none;
	b=EpI8XdvwA/Mo7zv20kBVlPuR9Ij3IO9ITmu689GATOWNoKRwZaPsPCnzi2r34+pavhCOoI
	fJKoTZoV6b+KgNOG0btNP/ehnY1ik52LQUnPFPwCxRR9tLknocrsNQVU3hYEiEaoPibQLC
	q4YNNSoqui1tFqkjuRJ6/kkiuAEY3Rg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErBvSSOD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgMQXV8BYAImHmyQ+Wvnc2XZf0WEI6U3t/6BUO8LjHk=;
	b=EL3Pjf0jkQujO10A62Dx8zuQfoQrJ8gcMalJj6LT6HZ0VT+yWoO8k8PlKpaic1xzfxrnps
	XbccA6ohTwqdY8zvsIMmUIHt5zlXD/3pMis2FLfV0cQp9mhnrrJRNZksD6PsgcW8aJ6Fof
	47hWT9dBWZLPvOofh/1WZ1Fa31G3VIw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sgMQXV8BYAImHmyQ+Wvnc2XZf0WEI6U3t/6BUO8LjHk=;
	b=ErBvSSOD8RbT/f2Iu9aV5wsomKdmep1Z93PgOkutD5YBZPn8JJhyLRq5Uk6xrXs8MPwtDv
	TgL2iVW9hZmajMSEdkc9G7zU6VDehuFSw8Fw23TZTH4ZEBAjrbZeqB3mU3BNiu7V7PjMQD
	ybVUBYSrmAt8Mx9QdSKjFHMF4HSwTvA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-yCgqSrvTOiCyp53LlG6ziA-1; Wed,
 27 Aug 2025 18:02:46 -0400
X-MC-Unique: yCgqSrvTOiCyp53LlG6ziA-1
X-Mimecast-MFC-AGG-ID: yCgqSrvTOiCyp53LlG6ziA_1756332161
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6290D195419F;
	Wed, 27 Aug 2025 22:02:39 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3A0E30001A1;
	Wed, 27 Aug 2025 22:02:18 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
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
	x86@kernel.org
Subject: [PATCH v1 01/36] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Thu, 28 Aug 2025 00:01:05 +0200
Message-ID: <20250827220141.262669-2-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 9001840019
X-Stat-Signature: 9rk5guc56czoz7u7h7fnyn1okaydkyjx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332172-46750
X-HE-Meta: U2FsdGVkX18GrBRsewHKPyYgHyijRvl/jB93qABXJ+TjhIW7dhSqmKKuAR8XLOaROolkrH7f+gn4e5XTH59GP2sVLR5l6k0j+aLKsQ4RIaKFMf2WQVTHlKX1MtTwL4+Wwt5vrkm4sFAJq0EOsyUBxK97Au4XZc0xjybo+y75G7LdXU1PiaRqkU5YSIWBPjfFmJ0Thz83osZXILls2gOK0zB2zKKh0ouygVzCJux995g+yd+oabEhyUeCaW7SzVTR06wbEH9jDJ0Q4NJ3ji//5mWDxHbqpeWJ5zjtxtHUOWGHycTdNEWrAizuoPh3mvMvVvygz6KjbKYrhsshC8XnbqO/3dMzuwTC0GSZUGZPbtOxhm9j1uW+nvs6kzKcqq6mIU7Yeelr1VVqq9RggNb3cmj6Aa6kj3dsWhMak/Pe32zntj/GHoHwAWQdJXRH6Qt+MtIYhHeIcWRddE+z82sWKweu+9FWAIY9zyLS/FU2IQUYpoaoQBoixyaf6fHDI3zOYFRV/6b6d2Og0jrYJAJSCDo9suL8qFhrLnRQTbuyr7MW/UcJSLZLnJ6D1tSZ1jbf8D7eO524KnrAY+XYR4/SwVDS5cqwtOGOp5/uM3XE0lhD5pIhfaORCVQunsIFzmQi2Bg1QksL6STtQp9piqph00xf+OoM5Z7vC4sUgVxpQFJxH9fYgyvkgB8IpHUYLlKKJA3GQtTCETajgyzX+0YPdwrhEr8OfMBM+L8oJS0/lOort589+L5qX9FaxMoKt6d8Mp7krfmvJoAeg211c630gtZxRbbf165QuV3r3/ysvVbJoq0YNEbg0i1h6At05ig2CbPMbdMwsaDD4s9U0ut2LrzQm5V3xCCDNkNrMpqTTr+Kpc2hAQizCUSDSe1fF10TA9SQcaKUGC+CQiSeq8S/bEXRMD7s/Y4wpvAHhgDU3sNqya9wDqwsu9O9wvF7Blm4ftI+g8PPq/mrr4wNbQ4
 OiR/CbOc
 xmahs0WAtCWTO9klYk3lcgJ9NX9rXHIrQY1V0W+tCaZSAAE/0aYVC1cvvp7cVlEYkRQvHD3cD18vAZDq+LF3Gl5Zehw10AxSRyQ3zfE4ShrlxYvkm2sGXR/L+P3XRE+bcm854s8J3cCJpqChlPJrrmiqKYmZaNrqFNuZfLXWa9IpS/vOu9xFEpnfNU7+0ZX5/DKXIIwBCIrzh6k1vc9/3wAT8vbDJI/G3cGmFmSBR5WkiMroLlMUNybYMXWNANjx+XbenCDbDtQoUNgDMBxqP/thuEaUdHs/rRPjYzVhWYMdG8C3PzywxD3TmEbVM42Ji+yi2xCYVdYC0Yc4JXYKcsXLGgppXE5QP8ebnzJTfRatfX4sRPW/md/OaWjc+5p4pvlG1Z5FJHZQ3fAMx5Fin/j+wL1vHJvJhrzuEo3oriU8aLrN6twrOLXyOmFVpBaNC8Yq5oGYLjFeL4U6VZSkk6o8m71W55DH7BlE2VTJEgTF9m5CXcde82Uq9u0ltfLmFDmZPiwgjVKBoeXcY31DikITA6EqIaToztpFD06Kph1ONRiHPHiykpVoDi2KEmfLvLy1ygHgC1RCCiojqpHs7ujSOddkVpMxlqNIOz1KfoVAOmc3isT9Fp/6FnI50sfS6eP8NPqNuhSJI+vBU84ud195dnDyO2e12qlKLbRWeI/6KJH2vxHhkKikz5ndLoHD0Mw8rF4XEOM2NQK8MDZHf2rh3SY8LXiuxUi96fu/tsQeTEyh9vWzycj4/2zXp+ObHhc2XHaOtRPQQGFk=
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


