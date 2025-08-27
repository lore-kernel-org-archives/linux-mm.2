Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014B0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDA98E0012; Wed, 27 Aug 2025 18:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4E48E0001; Wed, 27 Aug 2025 18:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB548E0012; Wed, 27 Aug 2025 18:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC048E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:06:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8101BA042
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:41 +0000 (UTC)
X-FDA: 83823922602.29.3813F6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A167912001A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eYYLK3IB;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjZeFWjCbDhCMUqSkeYcKpAMeyN7QE5gKijkCrCFfpU=;
	b=ShDI7Ci3I/QDIMNq6Po95VOo0DgjjwXKS22dgX0xppEUYo8NYMIUERKSz6z4HRCj/oO4Cw
	DfxYGt9HGDFz7yOMCqvPfzH4HO6QO2qNxaVqpsf8z5UJgYvBou/wXLqXpYTuhWmSJAZzsV
	aNQllvVzc2Dnc9IrJGbEANTJs81te2U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eYYLK3IB;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332400; a=rsa-sha256;
	cv=none;
	b=wALupfuKtUCqGQmLrN+B0qCB25BTr/goYRRNS773VcbIEysfhnz1elN9f5KbR+lApvCdcx
	BNcWthe931d5Hc8DRGVNkX55y69/swB9pJ2zN9aBG5qwt4siCasFwA2qePyf6Up32I2ojP
	RPEoCm7QsqiZF/z2j9C8n7MRZw34Yb4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rjZeFWjCbDhCMUqSkeYcKpAMeyN7QE5gKijkCrCFfpU=;
	b=eYYLK3IB8uFx/89P4gC16vVZZaR2xKA3QEbS0Iq+SCAFB60JZVoi2lJcifFmPfPgPupMIZ
	PWH+BfzAhOsVVlST56+55fOFjL2S9x5IyDZiD6yP+sWynEaMivIDtUwXFkhvkSReQomunP
	Flcq2G5s/XGG9JZTyzZIH1NrWtHPQyU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-lA8LiC6sONKppwkqSITe_w-1; Wed,
 27 Aug 2025 18:06:37 -0400
X-MC-Unique: lA8LiC6sONKppwkqSITe_w-1
X-Mimecast-MFC-AGG-ID: lA8LiC6sONKppwkqSITe_w_1756332389
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F080119541A4;
	Wed, 27 Aug 2025 22:06:28 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB5F630001A1;
	Wed, 27 Aug 2025 22:06:13 +0000 (UTC)
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
Subject: [PATCH v1 15/36] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Thu, 28 Aug 2025 00:01:19 +0200
Message-ID: <20250827220141.262669-16-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: fwwkbziufrddsqd6fpoiqq8qrojejoqx
X-Rspam-User: 
X-Rspamd-Queue-Id: A167912001A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756332399-886283
X-HE-Meta: U2FsdGVkX19JTNd+gb9paYKgzLPi8vTmaCIkEOxti+4msZkQtHAux7sIzsNt2p1MjnzVw++ncXqGUdFjq8cGW/LnniRen0pZgoyQ3gwCU4x36LvE5z4n/fWYFo1pMbL5nz3zbTYjYeko4QaSADDUvh08E9E3TyL00anxrnHRurP00uxC6JGy1O7g3UsaiefOYO4WzAlgo+O3ewSH20yaqQhzTb85oMs8sdAjfGXlxdY7CCxzvAktKU5tN1UKUV2BnsipBNJwsKYguyPlkLeT/dLSW+TRR+vHUNHhD4iKzZvK1esQvDBX3KzZ8hnVMlMF+tn2yhwxtQeedNieRsErU4NBT98bqhJgNhcD86gYhfrMsGKR6qGn/1Tj+FxMRW3cBj+zPh2TIyptdPUjER89y5LnjubLEoic7imwjUVMPEGJV4JEohO3nvdYt37YhrXIN32dyNeoTgroPDzC9x5S0qKQH476wwF0qWvWhFs3TBZY+likrDFmxGbsav5P7PBeuSm6EYI0L4/qt9UoEBGi8LV2oU+cWc6e6exr5zUjyNkLnqhadb6fDNnEasoHqShSaW+B0sl18D+WCMDTmRyCcMKt5S2LNwqlNQfgj4K9eCW300yRkahg8QCiVi/wSf1yGyZY2/DtjV9KVZHTr60M0g+nKbSAKkSbr3Pu3WnXPeSgboffs/rlmQAs9evJlBh6+7XCIzLCZ+kdCkZPFdFiGV8RC5BF3jlwelQwFjBYXX9W+lVivxFR7RCBuGkZXnu+U4AT9NLpVCzlpYfs9YALQoTgToFFLULGMmq5vOCHyDWNIIyxJlk8AVWjBBko2JVdE7DD04eYpweDxID+RABaJDLQEdZ//TljDZhWN0/m6gX0ZZ1q0hW2uG7od6oaxdzQ0joZu18ass/jTC3cvgzps4AWxNAQ5/9S8wWUqOggwrsVc9+ObhZWiT1hEQgPYZAthMels1OMHs6W7zPksMv
 Gc+UDfXq
 5UURF4unqjF60Uaeu5hNM/h2ZKjMAfFDfRkgCGNA6gCjvFyF4qEDcj9/8l40KGqn51Giw9HBQxeaAn8ss/FUrV4ou+cv7s32BZt+HaB4m6aaceax+MsCStj2Y5rRg4x0RHyfXLS7KMbGU13sMp3lM3uYGCvgWwTLfIZhGmKvl2DILHUnH163FfeS/WdfArin7JdBeQQrgDB/MRohCQ8nzIOotKp+bWLJZ6O/7xEuWHjMOLir0h2DZ6tEZALDot4XNrElg8Zc16gEWX9VbZLJe703d64AgXsp+CMLVLBrjZkuB+Jl0r1bPVDPVT1aWGif/JUJbVaYnDR+SWspOUo6Er5eeN2WXxF9Yft2/TM0+kD3zhYnzSq74pvL6huIvbnDgWKTE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nth_page() is not really required anymore, so let's remove it.
While at it, cleanup and simplify the code a bit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34d496a2b7de6..c5a46d10afaa0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -217,7 +217,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 			break;
 		offset += n;
 		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
+			page++;
 			offset = 0;
 		}
 	}
-- 
2.50.1


