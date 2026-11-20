Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C8B606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UvNTY5TO
Received: by kanga.kvack.org (Postfix)
	id B4D396B072D; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6A96B072E; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9774F6B072F; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 570D06B072D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D08D71C4811
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:21 +0000 (UTC)
X-FDA: 85453709082.07.2E5E1FD
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 148B980004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UvNTY5TO;
	spf=pass (imf02.hostedemail.com: domain of 3Rp3_agYKCN0KQHYYNFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3Rp3_agYKCN0KQHYYNFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136840;
	b=2LY7WtlkpZNZEqcHRoDbuF6xQ/U5BDsRbeoJl/nEq7i5CwLDvx73hh30+bpTyGkf4yXxMz
	moblRe+hUQ8drW8c4p2WNnL4sGs1mCVi0jMfOqNEPa98AvTtJMXiYsP8vSTjIAOn9yfLYX
	1aI0xLgU6eZPR+FHmw4ETOQmJ3PMXrM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzrMN2QHo1wM8b1xkq+afm/weU8crmKqNrU7yK2Mx0Q=;
	b=pIVIRi2KbcHfOVJpgS3wlv9KQ9K7KsiKkkcEjYDdKwbOkmC0kob0/SJeinNwwjlk+9TDMB
	di33cTFkEuoEgk72pVakqmQ/NOTFsvc96RoQuN+awCt+tbZZ6x5LNY0UqeAVfvW3WnIcfR
	JCGu2Gwhdx6InE0Tp8Wh+9tXYqAJBeo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UvNTY5TO;
	spf=pass (imf02.hostedemail.com: domain of 3Rp3_agYKCN0KQHYYNFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3Rp3_agYKCN0KQHYYNFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c5095dd1514so31875966b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136839; x=1795741639; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mzrMN2QHo1wM8b1xkq+afm/weU8crmKqNrU7yK2Mx0Q=;
        b=UvNTY5TOLsj5CAhon4Tlh9msWhPU3+OZDMVIIXSQWEFD6yrP5iOY6TU1Ns2P5OYOOC
         aENC07+Qi6iNUKA8bYqQD8zY1telrYss0aMTgmOrSrium8YMjfoIwJSoUQMtjOuxlTO9
         iAMozmTeonlewtmrdJgnxyeXo8j5Z4zCSbq4/VZ5riC/RHNCzMUnMk9WRXRxS/0u0nd2
         YpJc3r7MlZM3y7cr439VRXLMAV/r+luM05eKSePwEeEbQE5N0VBDG+PPEBQ0vzLNqTbu
         V3OnsbRTFiuoDF1ettHXzLSrh/vQv9rF+FqT4PLkkOfr6Un+dMfDz4/XFsyerIZWselw
         uj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136839; x=1795741639;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mzrMN2QHo1wM8b1xkq+afm/weU8crmKqNrU7yK2Mx0Q=;
        b=nHpQoUONCzJjTDLWBKtZz+Hv9GTq3DNRkEsJ2fPFNWWlRXwm8kgAl6B4X4V9JUoWXX
         bp7JutPBsoCy3bCSJ3aK6ScqNK3X6SEa1yQIQZVww8WsAitbL1enE5lNPK/vq8GiyEd7
         iEegW6Se53TTICeenr926YCY6J/EZRmR1ZevNbli5mGql4fo83Mou5u9Ko16ZIrzUypn
         uwkDfAFVmOu+RBJKAUVPJTHvFIgQ9HA2EjRUGYlfiafXwf7UGKaJCWdrjNCIpQeTQnef
         L7hU/h/BJknRlhZD1OlfZajfsDrHfG446WBESF3FilX9XtMfJRxp7Dq1nHfOH7ujObNl
         UuqQ==
X-Forwarded-Encrypted: i=1; AL+hErHmylJJRcOLf/G4o4TNPoKZN3S+pJhLwUeSo1F2GdWh8aVmGH1h4Q4loG0PNJR1z9jAYw95Wvw3sA==@kvack.org
X-Gm-Message-State: APuU4Z+cpZe2Deq814c/ZiFeS/KN/mnOZIozbI1AllP5cepBSMVCE6VV
	QmIMyiURdYxqycArrUgrJrZqHvweDHigz18OphWQRZNw8dPRfy8OAkrBpFdLKg1dCP2OS6QjyG9
	shOsq7A==
X-Received: from ejdr23.prod.google.com ([2002:a17:906:38d7:b0:c50:94e5:4db1])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:6690:b0:c50:55ad:ee74
 with SMTP id a640c23a62f3a-c513a847118mr117021966b.26.1795136838228; Thu, 19
 Nov 2026 17:07:18 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:46 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-17-lrizzo@google.com>
Subject: [RFC PATCH v3 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed
 slab caches
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 148B980004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fx8s5hfjug4kjqbbt7ypfnstdfakc5p8
X-HE-Tag: 1795136839-844353
X-HE-Meta: U2FsdGVkX1/UGTWwxQ4KsoZMmemTowqD5vhj1qD1MTnSKYPVxaLw7I98h1mxATvdCSsBsLSBp96XlpTKfNZEwFC6VE64Shmv4V03W8kNyHSnQ0HyGyYj+MkU35Om5un0FBi9o+6HIuIwD/PJJ+2cXne+SSpYLfNH01GKe6WL3gz1vrq/yn14prSG1Wsf29puyvbrY2KPBJ9ATARE2L0jlgYJntDYRyRta+dKnDfX0WynqQiGIFpuiJnddcXBuwHCvcPYiYFOBsCpOtX0VBA0vv0LMJFNTyDx5mWDG0ck3a+gzo0ybIyHfgmKS3ShG+j+AlwKx6Dr3bPIvaa1CovOOxxm4TfZOdegRGTIzI/Z0quWTfLSgeof949BwuX7amDe7/UWgqcssJceQELaZHNxIsduSupktk6L6mGjxbiuawyPIm+SvLkDbYHyJXlLBERDJMZAVuO5D3BDHX3sjFB1JTq8NgvXI4gRIkuQ3eHNRsew7Ze3WolUvG2nGkPih/gTbqJpVdeEZfW6q3k9Uso0ako5PlUaTVS9WD6VRoRLWISWxZ4PFkCTbtAQPT4gCRI7nig5tEbcwa8bxr8yl8IT05oXz3Sc9fdU8tQiiOKotkCX0LO9zu+r4k40PF7s/E0FnImmsvR4c1MxbYD8XSlHHVGZqhRXoKUjVRfWO7dgqAb+5ABxZjn/LxwRksHaycj9KG8SeIuyVrfCLxAfbfj598jAvR2iO2//elq5HeDlQ8aM+KH54w3j5fnMSrG7CDuLXAHnl5VzvQMgXQQhBfy7Kp+BfhEXGrQYwNo+jGyzYc/VcdUev4nJlt4knSZQ+PC3JrxLlGthROPE9rQOCfzbIoDnXDtjTw0jDcqoiCXcXARZzltIUpyyBbIlexKPxaayyeamS0AFcNcbQwo+p3/ffiEdRo8GYylHFpUxHpHfm/tuT9dYGblKpW1Xr3+hGcw55Rw2kdc4ct2dVnWN/vt
 TPx+s351
 os4Vy7G9JJRhtjmkromfHDmyl9Dy61KM8WSAK6exefkSeI6e+jmNyu781Yu9dRrJV34EsW8/URxB36rT9V4cXT1C3O66CWYEPUnswcpLDAjM48uA049HbQNhy0E/2Qu7geyax07ASZFu1Zah3Mr87Gt9WMKWdDZNFCXBbc09Fdqohd1x6LGmZ5MjCB+1Bk+tT/XW5usSv8r3gftd4BFr5R2Q73l3C7+jEsBv6maeONYLvdhWTOLsGZgJixyNZGUaVJtteFB9adsKIraERhSc1EgU7Ck70rY/rr8vQzHzIe2pmVHB4/Z19NBET7rH+pwX5AYRsm4YDFCi7suzcUlVDulzJ09MYFfl15o/vi6RQ/spGDD66JR63Rn0jyEIF1WQ2fkYgSJZWEbEjcaKhhtNnqReieVEmqDa0g/SvF1Mf2RprRy3l+Sc5pj0UeTfd6r+vmnOQ3xPasxJQpKTUBq4vC3MBImzSmu/p/OvTIabqwn+2GEzW1A3dZLrSjCb8cUXey4zhksZNMrHlq1K/vlPUyuuBdLLjOVV8svxlJw3uGzc+f4SEkQMvIY5T9wWIuoLKsKqwlQVV8mTPlnLNWwo1llXmAuLVAqYM0WbIKH+JpOr9Koc4SwZdfABPgV1rX5YW1PwIVp3ZwA0Kfy7xC2U+49d0nyuKcFqTMhQIKIaA7ywyUNS1i5RRaMvtl+NblH6C2Ohr936OHApb/VLa6hv/fO+97H4Whkon8Dw4Yz3i89Tb35DzSFZkojQ1SXfotGL4G7MiBC3LSbde0fuiGhlizB7zyuYPmhNgmVlJFE80l4NLC9CwI8HtZ+N/vfvtdqhuur6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

skb heads are provided by a slab allocator that is fed by alloc_pages().

Add SLAB_CACHE_PISA_RO so that a slab cache can back its slabs with
zeroed, read-only PISA folios (__GFP_PISA | __GFP_ZERO) via
pisa_alloc_folio().
Slabs are still released with free_frozen_pages(), so pages from PISA
return to their allocator via __free_pages_prepare(). Caches with
SLAB_CACHE_PISA_RO skip KFENCE and are never merged.

Existing caches are unaffected.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa-mm.h | 20 ++++++++++++++
 include/linux/slab.h    | 10 +++++++
 mm/pisa-alloc.c         | 60 +++++++++++++++++++++++++++++++++++++++++
 mm/pisa-kunit.c         | 22 +++++++++++++++
 mm/pisa-priv.h          |  1 +
 mm/slab.h               |  3 ++-
 mm/slab_common.c        |  2 +-
 mm/slub.c               | 23 ++++++++++++++--
 8 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
index 8caa2afded6ff..fd5e7234e9423 100644
--- a/include/linux/pisa-mm.h
+++ b/include/linux/pisa-mm.h
@@ -14,6 +14,8 @@ struct folio_batch;
 unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 				      int preferred_nid, int nr_pages,
 				      struct page **page_array, bool frozen);
+struct folio *__pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid);
+int pisa_slab_cache_init(unsigned int order);
 bool __pisa_free_page(struct page *page, unsigned int order);
 bool __pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter,
 			      enum dma_data_direction dir);
@@ -63,6 +65,13 @@ pisa_alloc_pages(gfp_t *gfp, unsigned int order, int preferred_nid,
 	return page;
 }
 
+/* Hook for SLAB_CACHE_PISA_RO in alloc_slab_page() (guarded by @pisa_key). */
+static inline struct folio *
+pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
+{
+	return pisa_enabled() ? __pisa_alloc_folio(gfp, order, nid) : NULL;
+}
+
 /* Hook for __free_pages_prepare() (guarded by @pisa_key). */
 static inline bool pisa_free_page(struct page *page, unsigned int order)
 {
@@ -129,6 +138,17 @@ pisa_alloc_pages(gfp_t *gfp, unsigned int order, int preferred_nid,
 	return NULL;
 }
 
+static inline struct folio *
+pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
+{
+	return NULL;
+}
+
+static inline int pisa_slab_cache_init(unsigned int order)
+{
+	return 0;
+}
+
 static inline bool pisa_free_page(struct page *page, unsigned int order)
 {
 	return false;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67af..4b6205540279d 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -66,6 +66,9 @@ enum _slab_flag_bits {
 #endif
 #endif
 	_SLAB_NO_SHEAVES,
+#ifdef CONFIG_PISA
+	_SLAB_CACHE_PISA_RO,
+#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -260,6 +263,13 @@ enum _slab_flag_bits {
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
+/* Back slabs with zeroed read-only PISA folios (__GFP_PISA | __GFP_ZERO) */
+#ifdef CONFIG_PISA
+#define SLAB_CACHE_PISA_RO	__SLAB_FLAG_BIT(_SLAB_CACHE_PISA_RO)
+#else
+#define SLAB_CACHE_PISA_RO	__SLAB_FLAG_UNUSED
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index 8c4c0f1f1cf50..4fc3b4d29de67 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -42,6 +42,8 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 
+#include "internal.h"
+#include "page_alloc.h"
 #include "pisa-priv.h"
 
 /* Idle PISA pages over the allocator watermark queued locklessly for release. */
@@ -710,6 +712,64 @@ unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 	return pisa_alloc_bulk(pa, gfp & ~__GFP_PISA_RW, nr_pages, page_array, frozen);
 }
 
+static struct pisa_alloc *pisa_slab_pa_ensure(int nid, unsigned int order)
+{
+	return pisa_alloc_ensure(&pisa_nodes[nid].slab_pa[order], nid, order,
+				 DMA_TO_DEVICE, false, "pisa_slab_o%u_n%d", order, nid);
+}
+
+/**
+ * pisa_slab_cache_init - Create the allocators behind a SLAB_CACHE_PISA_RO cache
+ * @order: Slab page order of the cache
+ *
+ * Called at cache creation, so that the first allocations, which may be atomic
+ * or node-bound, find the allocator of every memory node.
+ *
+ * Return: 0, -EINVAL for an unsupported @order, or -ENOMEM.
+ */
+int pisa_slab_cache_init(unsigned int order)
+{
+	int nid;
+
+	if (order > PISA_MAX_ALLOC_ORDER)
+		return -EINVAL;
+	for_each_node_state(nid, N_MEMORY) {
+		if (!pisa_slab_pa_ensure(nid, order))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+/* Allocate a zeroed read-only PISA folio for SLAB_CACHE_PISA_RO. */
+struct folio *__pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
+{
+	int target_nid = pisa_sanitize_nid(nid);
+	struct page *page = NULL;
+	struct pisa_alloc *pa;
+
+	if (order > PISA_MAX_ALLOC_ORDER)
+		return NULL;
+	/* Pairs with smp_store_release() in pisa_alloc_ensure(). */
+	pa = smp_load_acquire(&pisa_nodes[target_nid].slab_pa[order]);
+	if (unlikely(!pa)) {
+		gfp_t ctx = current_gfp_context(gfp);
+
+		/* Only for a node that got memory after pisa_slab_cache_init(). */
+		if (!gfpflags_allow_blocking(ctx) ||
+		    (ctx & (__GFP_FS | __GFP_IO)) != (__GFP_FS | __GFP_IO))
+			return NULL;
+		pa = pisa_slab_pa_ensure(target_nid, order);
+	}
+	pisa_alloc_bulk(pa, gfp & ~__GFP_THISNODE, 1, &page, true);
+	if (page && (gfp & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+	    page_to_nid(page) != nid) {
+		/* @page is frozen (refcount 0): __free_pages() would underflow it. */
+		free_frozen_pages(page, order);
+		return NULL;
+	}
+	return page ? page_folio(page) : NULL;
+}
+
 /**
  * __pisa_has_free_blocks_rx - Check if per-node RX allocator of @order on @nid has free blocks
  * @order: Block order
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index d7670c76e98c5..ec7af4313915a 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <linux/swiotlb.h>
 #include <net/sock.h>
 
@@ -716,6 +717,26 @@ static void test_reservoir_and_scrubber(struct kunit *test)
 	WRITE_ONCE(pisa_scrub_max, old_scrub);
 }
 
+static void test_slub_page_alloc(struct kunit *test)
+{
+	struct kmem_cache *s;
+	void *obj;
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	s = kmem_cache_create("pisa_kunit_slab", 1024, NULL,
+			      SLAB_NO_MERGE | SLAB_CACHE_PISA_RO);
+	KUNIT_ASSERT_NOT_NULL(test, s);
+
+	obj = kmem_cache_alloc(s, GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, obj);
+	if (obj) {
+		KUNIT_EXPECT_NOT_NULL(test, pisa_virt_to_page(obj));
+		kmem_cache_free(s, obj);
+	}
+
+	kmem_cache_destroy(s);
+}
+
 static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
@@ -731,6 +752,7 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_pcp_cache),
 	KUNIT_CASE(test_gfp_pisa),
 	KUNIT_CASE(test_reservoir_and_scrubber),
+	KUNIT_CASE(test_slub_page_alloc),
 	{}
 };
 
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index c7f4e30579070..08bf1b64bcf2c 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -134,6 +134,7 @@ static inline long pisa_alloc_held_pages(const struct pisa_alloc *pa)
 struct pisa_node {
 	unsigned long		next_alloc;	/* atomic alloc backoff jiffies */
 	struct pisa_alloc	*pa[2][PISA_MAX_ALLOC_ORDER + 1]; /* [0]=RW, [1]=RO */
+	struct pisa_alloc	*slab_pa[PISA_MAX_ALLOC_ORDER + 1]; /* SLAB_CACHE_PISA_RO */
 	struct pisa_alloc	*user_pa[3];	/* user/page-cache allocators by dir */
 
 	spinlock_t		lock;		/* protects @pages and @nr_pages */
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc0..53620e40b216b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -473,7 +473,8 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
+			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE | \
+			 SLAB_CACHE_PISA_RO)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2befd24b4d099..5dae3aa524221 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -49,7 +49,7 @@ struct kmem_cache *kmem_cache;
  */
 #define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
 		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
-		SLAB_OBJ_EXT_IN_OBJ)
+		SLAB_OBJ_EXT_IN_OBJ | SLAB_CACHE_PISA_RO)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
diff --git a/mm/slub.c b/mm/slub.c
index cd671b9347191..0380869fb3301 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -46,6 +46,7 @@
 #include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <linux/pisa-mm.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
@@ -2112,7 +2113,8 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
  */
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
 				__GFP_ACCOUNT | __GFP_NOFAIL | \
-				__GFP_THISNODE | __GFP_COMP)
+				__GFP_THISNODE | __GFP_COMP | \
+				__GFP_PISA_RW)
 
 #ifdef CONFIG_SLAB_OBJ_EXT
 
@@ -3378,6 +3380,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	if (unlikely(!allow_spin))
 		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
 								  node, order);
+	else if (unlikely(flags & __GFP_PISA))
+		page = (struct page *)pisa_alloc_folio(flags, order, node);
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
@@ -3484,7 +3488,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 	gfp_t alloc_gfp;
 	void *start;
 
-	flags &= gfp_allowed_mask;
+	flags &= gfp_allowed_mask & ~__GFP_PISA_RW;
 
 	flags |= s->allocflags;
 
@@ -3495,9 +3499,13 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_RECLAIM;
+	if (unlikely(s->flags & SLAB_CACHE_PISA_RO))
+		alloc_gfp = (flags | __GFP_NOWARN) & ~__GFP_NOFAIL;
 
 	slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
 	if (unlikely(!slab)) {
+		if (s->flags & SLAB_CACHE_PISA_RO)
+			return NULL;
 		oo = s->min;
 		alloc_gfp = flags;
 		/*
@@ -8182,6 +8190,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	if (s->flags & SLAB_CACHE_PISA_RO) {
+		s->flags |= SLAB_SKIP_KFENCE;
+		s->allocflags |= __GFP_PISA | __GFP_ZERO;
+	}
+
 	/*
 	 * For kmalloc caches we enable sheaves later by
 	 * bootstrap_kmalloc_sheaves() to avoid recursion.
@@ -8914,6 +8927,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	if (err)
 		goto out;
 
+	if (s->flags & SLAB_CACHE_PISA_RO) {
+		err = pisa_slab_cache_init(oo_order(s->oo));
+		if (err)
+			goto out;
+	}
+
 	err = 0;
 
 	/* Mutex is not taken during early boot */
-- 
2.56.1.809.ga0b61035b5-goog


