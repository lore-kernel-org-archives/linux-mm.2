Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C76CA0FE4
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E1F8E0044; Thu, 21 Aug 2025 16:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8718E0043; Thu, 21 Aug 2025 16:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CB18E0044; Thu, 21 Aug 2025 16:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 933E28E0043
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 655CD140536
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:41 +0000 (UTC)
X-FDA: 83801852442.10.3FF2DA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 210BCC0017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OeQ3Jku7;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CqHI+s+zbpAzQhGC/xWDVPQsQNUZt86Ikrf9EwImgM=;
	b=7jClMb34jy3ylJ48Fd/FJHvicK6X5b696a/vLo9lSyssVARc7gSGDTxTotc0/OQXvRTQiu
	kwDUpG0qhSs2HUXYhrPlOfReFymuM1VFn2s1IBK/j7Z4t5V0Xpkb9sUc4PgqB5pk+4j+nK
	NOXuS/fRSoZa1I2mN14j7MAwL6d4R/w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OeQ3Jku7;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806919; a=rsa-sha256;
	cv=none;
	b=f93tW23YUZHPDVdGvshuvjaxkNANuCUCMdt72x0wLhZ2Zmv32XF4rvQaFligw5BOugCQXi
	C5cn4OGlRrpwrOD22tvzXYa62S+mjh7aEOUn3TNtvl3hcNKsGKRHD/WJVZy5+4EBUhbf06
	7UOGYkZXji0hOUL7K/VNfP3jcKC9LSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3CqHI+s+zbpAzQhGC/xWDVPQsQNUZt86Ikrf9EwImgM=;
	b=OeQ3Jku75acxbQhAfB/mF5BgJn7mrgOTAQm4SiEJ8viArJ6npiYV1dFU8PYc45mp29fexQ
	42lR0aqojrn9BA8FP4d7FX6ZD6iV6k+KeByfTyk9ZlOtfVOm1gfsNuSi44Szwl0gjaNZlF
	T8V6hQCDrkjYnwJuqJgXprSzUuSJUXU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-GRIcMiAbMcij_RWbISUNlQ-1; Thu, 21 Aug 2025 16:08:36 -0400
X-MC-Unique: GRIcMiAbMcij_RWbISUNlQ-1
X-Mimecast-MFC-AGG-ID: GRIcMiAbMcij_RWbISUNlQ_1755806915
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10525465e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806915; x=1756411715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3CqHI+s+zbpAzQhGC/xWDVPQsQNUZt86Ikrf9EwImgM=;
        b=AoJVkHTMwdCMrg/47M7WEbQz8ZvM30fmAaalKVVnTTwlIq2CtJ4OwTlwcYU3afHn7z
         nvp5sD7/6AXOMnVRl9ybdz07iOQ6TIdid3POC8P/XyS3yyVsRqWWantROfUfMAWCNh/u
         4c+1XyJIabaweFv2MihtRAGmUkTQejouRXof3VFw+2FC1SCp1K7Yu3/34iAnx3cGGMxV
         uqNUmpMVyWgEqIhIkr19+ygQ3/7HC9rGyCe6yOPV2SELLoDElLEu69ayOpHOj8OR941u
         ewv9d/pRJ4QJiFP1ACcxTMtgK+oRxXopsS9r7/YPBcvjbtDiCg14jBbgVew/RRzFD8QK
         hM5g==
X-Forwarded-Encrypted: i=1; AJvYcCXjtN9DUcAa1RRxjk16FBY4u54WukwqLiCA15xkLcV9wSv5TlNOhP7rcCIzSF6QK8rj8g8WfHS85w==@kvack.org
X-Gm-Message-State: AOJu0Yw7m9bOvRsA2gz3yibYU8OeMcL/BAr/Um/A8oaeu8UboIEABd2r
	PgAZ96MBinGgF+Qoo4zjvAm9S3HBxfxg2W36rrVHZUO3fYDuHOWcEFOcmEvoJsgglMp6q/GX2ph
	CGv/BfrlemfTJkyF+wtGCCoq+ZoawEkZ1mMfnRFjhqy9MqkMkDNgl
X-Gm-Gg: ASbGnctAF1P9h79RK3RPSiIkD1NiJjj60phxjZzvkjR6vXUegb4AG8Ln8Ht7c8Jf2Ia
	yOK5mDWQUtm/chYlRCcEVTtLahT6iOyBbIKZoLCXD7i3oFvIKqTZyBjO4hVKVO0bmZkjq7Ayuni
	M7g1Yu157gzKB5ZlUQe4tUtECSS6zDk7G68Wzh64ikHeA4qz0u+2uKA+AnY0csgu0wAovP70muL
	GCxRvYHsojHAQdPSYfCzVo4ASlrnKOrKMGKj7+sspCbVOU5wK70kdmzR4Rbqzp7poDnb59aYFVw
	O5p3cErWxP69LVVt4vM8brVaOfgOrxdSiDWbUfX26RzZIBIEx94pajWA0DmblltH9geHrlZK/gn
	RbQW3YrNZZI+KCCr3k8Wq/g==
X-Received: by 2002:a05:600c:1e85:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45b5179f0d8mr2711115e9.13.1755806915079;
        Thu, 21 Aug 2025 13:08:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNGUbCcltH4em232KOd7NJpwM5baGf2Rerwczj+dvqvR7jiogPR9NbFTOrLGPDkQDJL8nGzQ==
X-Received: by 2002:a05:600c:1e85:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-45b5179f0d8mr2710565e9.13.1755806914568;
        Thu, 21 Aug 2025 13:08:34 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074d43b9asm12707153f8f.24.2025.08.21.13.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:34 -0700 (PDT)
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
Subject: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:57 +0200
Message-ID: <20250821200701.1329277-32-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TQIkODaY6Nk_BffjwN2q9FwyMQYlRDabodtT4OfE9EY_1755806915
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 210BCC0017
X-Stat-Signature: kjqtiurdjy4iw7zr4hnj6ck9dgs55iux
X-Rspam-User: 
X-HE-Tag: 1755806918-974507
X-HE-Meta: U2FsdGVkX18IzRxZGz+sMbqIV6M2zt7LFHD47FJ7Q+L8b5t0yksmKE2uwRonR4IkKZEeKxmbqB2QuymlShSXFX+OEduQ3I3vCz4PzQDN3BVhtznfM2hizDx8cbAUDy+tLgWnQRVtVHXbQ1dr9fGVVLd5Q49cu5pSzno+EmQBo/7gPRQh9Xqm4ernWsRCpUL51cjF+O8bwY3rO4Cr7BxYJ7Kyp0FIzG39FsO0HYlQ+FWqOsLCUwvUa0svty5BjGL6ZIcpQwk8VQApw1JmOnTL5YLfBiCA2+eOb2rA+fOIdf3lF9+DHARIrppSIjbPv4Dmr605O8Twd+nQ1fXwmxs1vNZqHhqFT5WVkswmmSdpP+voUEduO9XYMiMX5wWvpfmgp8Ojo0ez5RsMUuzahDBCJMgepUcD6dkLaN0HVovV6YhdX24TCV5S1Ft5hW8m03esE6INTGLOIhOvMXOaWZeAOCbdzBSfQGfq9LmrF5OtSOR/4wt4PetqGITVXqVzhZjH+lWDKp2MH0t6gpss7O5idLOyNzO6/AAGzcPNKx+lCPorxYJLyzCIz2Lrs2umkO8pgSWbOQpUyttG54ugKZPNpsChl/bf5KVp5euB6ita5KdCBa08P58500nFNDIUrkS5wA/JPEp3IV4juyuS0W9lq4zhJZsufpXRJ8tsK6+GDYPwH0a/Ql8dKv7STVQQ8J4XKT6Z0NpD8KVv4xn7WgrcIJQ9z5BWvGO7xh/w1XPMJR0mGAZIuwojZwRwO4sA3FC8IShWeC+E+7Mqte1M9PE6KPv2oHgO6EuzyRGBqiLTjziiCqkQ1cCHwmqSuRaaksGqLfJUBiY7fk1w6SsPVwzGqgH1CFwQttHFptKkGkS8u5FMkk0rGvoD9ytnukOpnKTdcXc2zASBtNeNklg61j9fQrfNqT4FRDBH8ArmjQPhQ+i9FfiehTD35j/D8DzD3zpKt0KnJi5T1otEE3dBbQ4
 35Crhme4
 UP0rO7nzP4iWEj8E0sgAxpENabJql/nlZG46PN4ewfHp8ykpZqJWtrbzhqY4cXn+fYclaRz0Ad7f32lvvZSwkQYEDkRo6Fw/LiITHPgUcz9SYsEMhrTKW7W1zmxEf7QZsuC8ot3+XUWr7BwtcRSfKRw3I1k7yNOus1N8TFX55Yo1rvAsNWW1rjle0mR9HjNRejnJ1ciYY1lvVcQm40fbcz0kxVD7C8umKLDwC8UYO4As+EHY/wK0yknEk3S0K3pAbrhBD0iZHRpujQxFYzykswcBXn6oEdkf3Zxr7ATDNIT1eYIobs0dWCksKVhBGrn1+c4qqP4tOfb/30KZzL48S8PubivtmFJ7a+aBcXkcA6Tad+7yw+SH8o6cgqXkBOzEBI0mpkoEUtiuLoAdcyt2o5Xqb43Nkt5sJ+mgPmBB3cX3WhMr/0NzLFbY5JOHe3nuHCQQMzLQ4nHS4XlytUyRLrkhTIn2xAbdbyiukzHE6P1cFQtH09pZrAuyQRkLPvjXAgiB4km6VgIC+mDx1iFr0t9a5DHG54O+i+ck9bA1pzLR0b/TO+ocAHD7woGCF+wV8OiFgGnZTxh5rqJjeG8IrBk/Vikpuly+TSc2x7q5FEJZ3lsPy0Ysh9UAWxdNngcRN7mJT9cE6elqiH04563saW5hTIli+qRXTc/qEU4ifsBHXWN18EEi4hzUtcv6iNEnzGEYJajcuRyu6Sbs=
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
index a227793d2c5b5..a9f757224a223 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -88,7 +88,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = nth_page(sg_page(walk->sg), (walk->offset >> PAGE_SHIFT));
+	walk->pg = sg_page(walk->sg) + walk->offset / PAGE_SIZE;
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -226,7 +226,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (!IS_ENABLED(CONFIG_HIGHMEM))
 		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	page = nth_page(page, offset >> PAGE_SHIFT);
+	page += offset / PAGE_SIZE;
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
index 15ab743f68c8f..cdf8497d19d27 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -159,7 +159,7 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
 		struct page *page;
 
-		page = nth_page(base_page, offset >> PAGE_SHIFT);
+		page = base_page + offset / PAGE_SIZE;
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


