Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C783CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0BA8E0091; Mon,  1 Sep 2025 11:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1178E0084; Mon,  1 Sep 2025 11:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669228E0091; Mon,  1 Sep 2025 11:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F24A8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:13:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AE118604C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:30 +0000 (UTC)
X-FDA: 83841025380.24.C15F2A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5027214000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XlcmlKw5;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vm1zVGjW+sGlJ+HurCNe9nDe0XN3JBuCy2WCKHoB7cQ=;
	b=oPJX/X7jDy9sLl/IEDvWY7u27zTt/yIo0xfR3avWSSEe8uBx96JTYg28jL1B2nVEvPQpnq
	3yMMyPtd9fhLVSQiqjUFuSsJYS7kReuZXu06AiNeDV9xRvDdG7V14Tt8bIwAGIKHrLziUG
	GdlpLBQawRMMyRkuF7ujxq67jwgAovo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XlcmlKw5;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739608; a=rsa-sha256;
	cv=none;
	b=YMnOpMYcpnhDDrzwuYHzlOsEEZJzwMDx9NSoiQBI6AefBdgfUQ3sv89KWcckfn7pqT9S4A
	OSVfgmiauHCOVdwdLc7744sEPdkMtlOUwK7yJOV50Wm0ejNc+Kw4ONA70bK3WfWD+ScYFW
	k521XPC4i77BoDWoepxd1uTtuY4bcus=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vm1zVGjW+sGlJ+HurCNe9nDe0XN3JBuCy2WCKHoB7cQ=;
	b=XlcmlKw5NYBk6NxV8gd6qe0bv0kJYUp5WXVu+GVFeKMSKIUPQOZ7gRysX3jpRplmmE2wV/
	FWS6sJLJs/H5dmgkjnWjUSJYiM+ySsCZ2eb/B3D0VZ+Det13gJiJX0HgcWqb8Hcj+fumWu
	aGDNvdp5s6vNjosR8ikNDNb/FO9tVPk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-l0sCqX0_O9e7dNlURLW9hw-1; Mon,
 01 Sep 2025 11:13:20 -0400
X-MC-Unique: l0sCqX0_O9e7dNlURLW9hw-1
X-Mimecast-MFC-AGG-ID: l0sCqX0_O9e7dNlURLW9hw_1756739595
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 054DC195C27B;
	Mon,  1 Sep 2025 15:13:15 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D2821800447;
	Mon,  1 Sep 2025 15:12:59 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH v2 33/37] crypto: remove nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:54 +0200
Message-ID: <20250901150359.867252-34-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: ui43ijnterwfdnkcre718343aeut7egw
X-Rspam-User: 
X-Rspamd-Queue-Id: 5027214000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756739608-648792
X-HE-Meta: U2FsdGVkX19F66/H/cWx/s7h7Gb5GimvmBf8Kl1yzsIrjjHXI4PBfw40gDO5+ReHRKaRUPS47Aaoc8iB0iWWoknNqOxvCw2FAez3NNDYMy6QZAlXthhYRj7a3ES93GCmqIz4thIprXLFFsiW1OiWpF/IbCVgqY6w/D2WDmhYO7RQ6DIGqpsQjIag1gIMttCey22wlepzdJf3vXtY9pEOprAKasKkiT/mr2OSzqOeghcCN49Atf5SM76VQTiemN0acKSW3qgd/n0WpWuwT44y3/16IcNpv3Ffz5+7hNrvgu38MPQfJcgs9yWT+8oZKZTDB1iPbJdV3bZ4zKKfOieoAtDjSg4yPIzU9YeGw561/xRVVm6ncxGRWsu67OV1WPSgP/bq/9qROxD546OzPMQe5RkBGE3iYPXDzNaianHDRZT0URjxo/NWQDdzawhDHQQljSbX6vIQNkXDfpOS6futPVonVS9F4Z17qHnluG+SQiz+4DaDBu7EDFI8n+oneZYQIlocLEPMdXLiTq6T1teE3MIrocp2lURyO2SmEqLKihhS+vqsb+citzAwtsJCe3JWm/ZaitQtuCfW6zT957QID2KT7+vefYrVHrS7JVe8bF2yek6PxouGJVZj/Jk4El7UMOk50d/HvU1e1BJm/BiZEtFPB3kEdD3j4pIVC5hZmYrqS6kCSjkOnMpQFbj4oBcv3D+1im7v1MLwwXfyK3AE/X5eO+aTG8A3SxugzIkBPYsm19uOwxRWoN2g0b9mxYzQupS60sL3G/PTeFykTCdaH8p2unUxEn2bucWqLKz7sf3zu6jaapgj6t5YDo9ZbeSfKD6NZP9H6R1F1SnsxzZIa5xzs0D1KUzsVzMvhUeBRfdJQSlazVCCJ3QK/zBAAtfLP0mvqDJ7Aj8djvKDWMfc+Xc32ZszE4AXwWi5DLa+hsPBXeYgeOSBFwmFhBt/NIdJYzuegRM/7XUgTw0ZN7T
 ISETRdHt
 d5r+O0bj6hd2InQ10UcFJZmBTiTTOA4vSNM6kPhbn4BtEE7awkGqshVtmm6i8zQllpSrptWjKNZ/IWkfTew+Z+Kr44RnMNR8msRF4zWKyUMF3OwwRQsWxxDnV6q/0w5Ecod9+irmaF4BDw01zRS6XyGrNXT3rzx8bvqoauLrWRj7iQOwaYTNp97DCTfM60Qvdsf63NwpHc3x+Grxsw6JdU4LweBupIG4dWsiQKQJsJ8gR1DgA5YbDTcgDEUTC3p1oziaA4giX3+Gai1xwLeiMywdq8ChQBWscMgO87aug4oWMSdZIKgN6yp2ZQpuZo4FGX/uEIObY1D4+9SeczOEJGaf2oLdjTV/OZQ3vqPjrroQyT0xYegpk/zEU+POHLSOkdUv91tw0PDS9BCi009fc+goM0HhyJZqwA23SNcyvn81uqVQiYxr74THOP6IzOu/cFmoAXBT0ghAYmsZcaOxVyKm8bToWyrzcahSTx4+9lF+eBPoCmFSUo0qkjXTalOZOjqjmE/gX40jRh2g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 crypto/ahash.c               | 4 ++--
 crypto/scompress.c           | 8 ++++----
 include/crypto/scatterwalk.h | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a227793d2c5b5..dfb4f5476428f 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -88,7 +88,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
+	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -226,7 +226,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (!IS_ENABLED(CONFIG_HIGHMEM))
 		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	page = nth_page(page, offset >> PAGE_SHIFT);
+	page += offset >> PAGE_SHIFT;
 	offset = offset_in_page(offset);
 
 	if (nbytes > (unsigned int)PAGE_SIZE - offset)
diff --git a/crypto/scompress.c b/crypto/scompress.c
index c651e7f2197a9..1a7ed8ae65b07 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -198,7 +198,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		} else
 			return -ENOSYS;
 
-		dpage = nth_page(dpage, doff / PAGE_SIZE);
+		dpage += doff / PAGE_SIZE;
 		doff = offset_in_page(doff);
 
 		n = (dlen - 1) / PAGE_SIZE;
@@ -220,12 +220,12 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			} else
 				break;
 
-			spage = nth_page(spage, soff / PAGE_SIZE);
+			spage = spage + soff / PAGE_SIZE;
 			soff = offset_in_page(soff);
 
 			n = (slen - 1) / PAGE_SIZE;
 			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
-			if (PageHighMem(nth_page(spage, n)) &&
+			if (PageHighMem(spage + n) &&
 			    size_add(soff, slen) > PAGE_SIZE)
 				break;
 			src = kmap_local_page(spage) + soff;
@@ -270,7 +270,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			if (dlen <= PAGE_SIZE)
 				break;
 			dlen -= PAGE_SIZE;
-			dpage = nth_page(dpage, 1);
+			dpage++;
 		}
 	}
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 15ab743f68c8f..83d14376ff2bc 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -159,7 +159,7 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
 		struct page *page;
 
-		page = nth_page(base_page, offset >> PAGE_SHIFT);
+		page = base_page + (offset >> PAGE_SHIFT);
 		offset = offset_in_page(offset);
 		addr = kmap_local_page(page) + offset;
 	} else {
@@ -259,7 +259,7 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 		end += (offset_in_page(offset) + offset_in_page(nbytes) +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 		for (i = start; i < end; i++)
-			flush_dcache_page(nth_page(base_page, i));
+			flush_dcache_page(base_page + i);
 	}
 	scatterwalk_advance(walk, nbytes);
 }
-- 
2.50.1


