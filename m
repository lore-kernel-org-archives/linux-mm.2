Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D59CCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4368E001A; Wed, 27 Aug 2025 18:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64AA8E0001; Wed, 27 Aug 2025 18:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C6A8E001A; Wed, 27 Aug 2025 18:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2458E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:11:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 489BA1A0879
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:30 +0000 (UTC)
X-FDA: 83823934740.04.F7A9772
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FDCF140002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:11:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N115Q9Nu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332688; a=rsa-sha256;
	cv=none;
	b=U3MFH2pcHY9UQnwRBMNYciCQFXx21NYSet0Q+yUsIadWCGds1DqwMgFzLiETO3skDJKwmw
	zBSwNFkxx20xtNlEq3lZldPfwEVg4oKJEDxNht/qN973x88p+B4RVJJdhaKsYQ6AKq/6m2
	/X/KJxlWU2ZLpKfvTo34kdesA8l3BFo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N115Q9Nu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOaasCb4pmSrDWTZ4dnyfdi01+ddZ5bW0CVKvkbWo5U=;
	b=KsBWmg2FnfmeTmnKEtDnmwW5BskUjtFcm6DA0Z2TfxFifeM6Ux3HrtBsCJ7YgyGzx6NSH/
	iMftlB1SbTnTmXxrtyhA5Yjk9KcgUbnAnRex4JlsNToPeuLDIjxbJWGrXGiQ74UkYH62/f
	Ve/SQzMGtAyUBZGlQuJKvqYXCxYEMTc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOaasCb4pmSrDWTZ4dnyfdi01+ddZ5bW0CVKvkbWo5U=;
	b=N115Q9Nu9E965gfofQRNTvfBXhn5gFpQZFihcvi0SVB3GRWOKpyIoPfp/NqaZnSvc6TEIq
	ZfxVMhi4R+xgvu9CJB1VxP1hhC3e5bIjjPYiqhv6Nwye1hmJsb+nCBQ8eMC70gF/J1u6c9
	oydd1JBQbM+uE6XnSrvZkz4eS/bpsDc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-Y03DoB7kMGejm_4jhOvFCg-1; Wed,
 27 Aug 2025 18:11:23 -0400
X-MC-Unique: Y03DoB7kMGejm_4jhOvFCg-1
X-Mimecast-MFC-AGG-ID: Y03DoB7kMGejm_4jhOvFCg_1756332676
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F89C195419F;
	Wed, 27 Aug 2025 22:11:16 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 61BFE30001A5;
	Wed, 27 Aug 2025 22:10:59 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v1 32/36] crypto: remove nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:36 +0200
Message-ID: <20250827220141.262669-33-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 5FDCF140002
X-Stat-Signature: ukin6tc85pw681ogf5xmpt79qgjeuef1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332688-635728
X-HE-Meta: U2FsdGVkX18mnrMlgjZBfRqS43mna5hJJNVEMKeIXctsnHgUzjQFO7NGFQ8XTG3bVD/cKOrwNfKnq3z2ybs6CbwP3wGOebx6LIKIJJvDfdtroDi/ogO82lMg2viqAcxecG/ZOR9NCMKGh0bPIWIkib+xB7WJp6KQsJm9N8kIzyImOatAOnt8AQt9MnsbQptLVy2zgvsjFIZemts263yGeoB9gwD3toIXVYPPZgWX3fFfY8sTpnAFWbfqiXqJRj+aE4J1N7JGRlCbe9tuw+kzNoxG+hfF9lLb/nVta8yvuHtIC5k0dby0fDYnbVt7+A3vYEvofQdZmt0B5yzGbyl6dpUodZg183EXkBY92fQfuFEHp+XWI3hyOzviIW7Z4M4a67v5gw6HsBU6N60qoveZ3C0qQqVgMmBK2jHu9PBonhXvmNTmcsBAraGut7lQxRIEWF/a6eeyv2Qi11sHkKhe7Ivl+X6s1NXPdB0pZ1p9IkqCEn5l8uP/ITjS+U6Dh7RS02Ez+QX/aKf7UKr2paTK2uCrGyFioGIR+2gImcTvbfOL9pagULRvySrP5aigxb8jQp3ic5P+/fY+kfLuctKSTZnmjSMc5tWuAJcmXQ02WWhxVAq1AVMM2BRyFAe+JmYAL55cD4Z6HhaxV7ZyQd6XSdLn4MCqW3zjRwER6xVF4KqW2nwDOsKoj8y7SI27r7aEfROee4E+OoJ4K2MGDE4GvmG2dRHfNjAVTxiVpLfsEaO2aUjksF6D+CoV3GM4lBLnYAaaBAnAbpBs9AKmXifih1aqTGzqbKmAQgkCGWdfaByZ38SnKviuZeLaqBsok3gNctdEzzptFxhJOXzRvyaUS+KRtPzHSyeIrF2xM5XXFEEKSQeLx1ZDe7S5XavAf9pKtQjUT/gghSEbqGdXbFCARtxUKrNG7/LiISjLuAatP+9n4TVKCRwxbxd2VcAAD6THOEOM7rUVOCPVZr6PB7X
 D5ursRjp
 N+YmwV53TbylglVr5cPhey1jyYbMpxeeCNEB2Lmn3MedqNO5lBOzernsvXnsBu6IJM3r6b1D0uTXdaq+D40FZdVZrqKXh1H/BI8Y191dSuckpLKhB3PgWKbcz3x+gfL4td73OTRuMnK8Jc0fFkKzvWgpAmb78Szr+R819O43JX3WcjKPXJef9GmBDAO0Ut+152/cHW/DT6hBdisvwPeZOL91BTr/wJBiED3slBf4IBUjtQ7GXEQbflNgQiasbLx1O3P3cCKLMxR26kv6Jv1KkvMNDOyDf4IX+2npj1WzCj/ClpG2qrw18luocO971/4j8kzxV6+n8n/1CLAsI+SMzhFWSJPzm9j6AYWfzkWVD6aPGueUy2VQExQpV8aBL7S3B0lKGAxTvXAXcEHEFNjnePe9WoVqG8DbyeOGFf/uylyVXFoYmAkBNSv7SeeSQhJTbVi+2YKKmYb6/WsE7SnjBA1Dfc7U3DYAhpr870VEUYvS3wmQLFcIrbCqgNSeQcO08ZBSKXIE5njqyJzU4devqcQMN+h8vyMBgh1dDdvOwV5sqv/iyTaGpqTN67CQcYMDukA0bggZWqovZY980JIaQf5yj/Umy8B+1R3LBAsQ7Yq/p510=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
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


