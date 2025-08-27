Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A0FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C116B6B00A7; Wed, 27 Aug 2025 18:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8896B00A8; Wed, 27 Aug 2025 18:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF7C6B00A9; Wed, 27 Aug 2025 18:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA026B00A7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:10:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 726115B84A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:19 +0000 (UTC)
X-FDA: 83823931758.13.6747D4A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49EF2A0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfFPylQg;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAsuOXpZW6+ZRpVYsSsl6meZaoXTi6zM/YFmOyHNi6k=;
	b=O5FPBOgAqFwwrh4pZ5/QVffbnnaxcdG5u28550P7XI882o9kbT4+y2CNmZUAK8e7fFXkcg
	WBLAGE5ZnMbA5xgegdFpFFTlyygdInEnfTjlA4R9p7pOKx2DCHGjG2svL/+mtOo393rjIG
	hxBrIWkQmKs1dfwTW2tc+W6UT4RmejY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfFPylQg;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332617; a=rsa-sha256;
	cv=none;
	b=F8HUqufUp+jkjJqcDCVrW3VLKJyq3bADSDcP5YvB5Ye5jZ4rD+bWyOvLA+NdIUJsnYUxk3
	FBZELaRUAhNimJDwEZxNd5Wy12f5xD2TwwbfjUZ/F6M3q/6pyrt6n6Xx9ESHo8BnBXz/Wa
	C0zxrSS9mURN5TPu4H70uCDi7Z/hW6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rAsuOXpZW6+ZRpVYsSsl6meZaoXTi6zM/YFmOyHNi6k=;
	b=bfFPylQgA6cK7ZpLYtCT/tzGLb8mjqPd5yZugxvVTOzcisuyEIoooUn0AfRmBuCBatvsjr
	oyup2fshq1RP5OKOk6AODMq5RPFMZL0yPX73d42s9Pfs3ELdMvsHROYdtSSySiqvv9zlUG
	DULapq/opRx6HjcKdyIYKP/DlJ6prqE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-dHJEc5UDOjeaJ0EVKtmuGQ-1; Wed,
 27 Aug 2025 18:10:12 -0400
X-MC-Unique: dHJEc5UDOjeaJ0EVKtmuGQ-1
X-Mimecast-MFC-AGG-ID: dHJEc5UDOjeaJ0EVKtmuGQ_1756332607
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A9AE1800352;
	Wed, 27 Aug 2025 22:10:07 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8ECC630001A1;
	Wed, 27 Aug 2025 22:09:50 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Alex Dubov <oakad@yahoo.com>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
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
Subject: [PATCH v1 28/36] mmc: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:32 +0200
Message-ID: <20250827220141.262669-29-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: o119assgyy561bpn3hdqmw1m9yd97km4
X-Rspam-User: 
X-Rspamd-Queue-Id: 49EF2A0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1756332617-701683
X-HE-Meta: U2FsdGVkX1/KqOqMF/MpalHHAWnv5C2N6+zmf4PUXxcONNKTU99HvyamasJ8K6smAorMxwtbaIKuVwXRqYIsrO1EgaP5ZaOkEPeBCC8WFIXVy//sJ0fwZuA2pQWwhSDRMVAcwVFcTge+xOQixeAmYuWI0XM6Ns9vUKGva0V78GXCByKsadDP22Tmm2ifte0roJ/NQ8CiFpxhwzFveobRG54oZt/t0ee/KBZwuXu75FCzU8T/9mBdzwDAZUh6kyFwtb0n6ij+a1nowwjhBQIsgJ+LaF+hoUTm9ED7IFKMvyOxbFJSaedgk+ANwuQbtWYrMsnd3kBnVdDcg8svjK0Jxs3DoKbI/eXUdqeldjIKl3KWAZYG3mKHHaLqwisKJ5Y2ki0zv8kul/TZxaun09GOellX8CKe1W73tgXdVPYh0+0sGkjch7w3IS1kaANf9LK47YfFUfqac4vpHzW7RMyBpbrGhhrIabomZ1R0udweb2qPD86RwSbialC82NBC9g7xSEDl5C7u/bj56dUdK1UGI1pcVicPYikevBGZJk9p7Dd+vAAb9zDkhJ5bgYpgkwerXzDswpoN48Os33qD0Cb3XSR2jbXW14tYCKOfMLMYw3Ek5R04mPI9IuGLLT1DjStrnmP1UGBrEzEgUIv+J3dd8N5CkLPo5KWdGrrdcZJFSF1pOaSlOYPPPeBQBV4pzSVPUOZjYXFwsWJx6TZdSt4qzyo6D6GeoPmycYpClZXE2IDjtlo8ntkrJgYj1xE0Lw0Q9sJpOmscT7ewDxD7tOKWnHdOwPbdBJFxuz/0KatqbnL0slgofBfQsJmZsGBkkN/jroVBAO7Oao4j9Ri8qitCbgqhy4RZyacCNcqrzAaHRuYZZfr1kyec6EzT+yO4ox5Jj/2W3MAFfFbWVtrNnEr1gP/M/r8orC1xsODhneVsRU5u+FpUii1epuz4WU56FWptmM11l9kT4aFBVSpa3/f
 G6z01qj8
 DAsIJeuKZmly1GQzof7pgy8R1LIxF5VnfnL5EVX9227tWClYH5GxEqlyWnMNIIregLA9eK/tXclmVcnrF6+/IIiGZDQosZAhPDMLsNy3CkIJGnZ8k6Fr/X0m+Ah9fOGH6/6sGqmRvUVaylVd2qhnBFNuYjQNn/tpJe1jV0ft4a6I63VHGmd8oqwbpM3tPbBtVb64jH+QGElQLWzXwRXR+ZM9a4oookH+Xwi/TPGD75NNWUAKYQBycwKg5MV69mR1rBz6RriOJarRl9a6uyIJI4XxW/5bYslcWQmOIkDvCXo+KP1w+lBowrhdJS8b1M9fwH+NVIRqgMpkHJhEjApHGAdFiYZFkxeJQEAUGPQ4WQ1FriENE4EUr78eVxOHgvvBnjsGxQJDCgEhWZ0M78O9jWk5WH6/sd2MykU8DpGJLuF833A75tOZQuIYN2IOrn4jedp5uB3jRYfs6rVvIiHZKBk57/esZUa6f6ibrZ/eVtbkGe/oE+Ypc1GHUZpHvm1IfleVUPS+Lles8zi22GyeSMhEudgFE38lfKmYalLiAHsQPTSRGpR/YlkrLs5rJ3pq628gzITsrHKaSP2pfk9vJBtEKUrXScqE7zJhbapZO9J41MTvwJBR11fhRiDZ0MC2WCBlk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/mmc/host/tifm_sd.c    | 4 ++--
 drivers/mmc/host/usdhi6rol0.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index ac636efd911d3..2cd69c9e9571b 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index 85b49c07918b3..3bccf800339ba 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
 
 	host->head_pg.page	= host->pg.page;
 	host->head_pg.mapped	= host->pg.mapped;
-	host->pg.page		= nth_page(host->pg.page, 1);
+	host->pg.page		= host->pg.page + 1;
 	host->pg.mapped		= kmap(host->pg.page);
 
 	host->blk_page = host->bounce_buf;
@@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
 	/* We cannot get here after crossing a page border */
 
 	/* Next page in the same SG */
-	host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
+	host->pg.page = sg_page(host->sg) + host->page_idx;
 	host->pg.mapped = kmap(host->pg.page);
 	host->blk_page = host->pg.mapped;
 
-- 
2.50.1


