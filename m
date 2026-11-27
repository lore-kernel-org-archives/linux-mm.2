Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527BC606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=WpohgH3S
Received: by kanga.kvack.org (Postfix)
	id 6F4346B05B5; Fri, 27 Nov 2026 03:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4096B05B6; Fri, 27 Nov 2026 03:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593136B05B8; Fri, 27 Nov 2026 03:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF0D6B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:28:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 670121C0B52
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:08 +0000 (UTC)
X-FDA: 85480221456.15.4EA881B
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 250FFC0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=WpohgH3S;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf28.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795768086;
	b=EYyrC7GzZWATeot2HCZLG99rNvSxTEPLpZpMSQh/j4hfPYkPV6Uz7Th00hiMJPDvQ8p607
	iDER+U7xFLAUR3JNFjBZc1934C8+GsfrBYhebvOmW5N9pJULqfp9E/95k/hTdzWboAFgja
	F/+ONaamfl/J1gK7xhLV5aPZHpUvq4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795768086;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqNLEUfWhmOMSL23MOtwNVURYUmPLn8/4sm98DvyXcM=;
	b=SyvAER3JpLuJc3jBzHJGLNNKe64oPvNJE0v6QPkfIhxjRrZ/tgi6xAp2JIAe0bd9mcSndR
	GTuzNyaIaEms+TbFynDzID2bi8QRuyDDy7l/qOGxZZOq1dIpaJ+neKpyea2Gu730hYCyd7
	KqTNx+SXyQw+3Sg9rkZJ1gIYweM1VNQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=WpohgH3S;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf28.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=iq
	NLEUfWhmOMSL23MOtwNVURYUmPLn8/4sm98DvyXcM=; b=WpohgH3S/haZ3aKn/R
	Geq+08eDOGjhRJ3okZ33fPuxeTvb017d/H/tEglI8MeA2dh330MvSanbz6VIjvYq
	A2+b2hVbPZd/4hJHIpPuwbObxFZdZmLPErxCXaYPDehGsrtjMRKmXtFMCXSwD3JM
	IefMcfBCsBVtvbj5u9mR9OCvs=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F6fFPglrbVuREA--.44951S2;
	Fri, 27 Nov 2026 16:26:47 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-pages
Date: Fri, 27 Nov 2026 16:26:41 +0800
Message-ID: <20261127082645.3623843-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216089@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-3-zhaonanzhe@xiaomi.com> <sashiko-outbox-216089@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F6fFPglrbVuREA--.44951S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtrWUCrW3Kw4DurWrKF18uFg_yoW7AF1kpF
	4Ut390y3yrJrW8Cr17CFn3ur1Sy3ykCayUAFWxGw1Yqr93tF9Y9FyvyFy7CFnrGr1xCa9a
	vrZ8A345XF1YvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U9XocUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsQfdrWsJPsdFgQAA3Z
X-Stat-Signature: qw16eg4pcwm1u3ndbpg8jc4co57acz3a
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 250FFC0007
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspam: Yes
X-HE-Tag: 1795768084-353739
X-HE-Meta: U2FsdGVkX1+Fnh+QjTqnF9Srase3LsSN/sUxuKdbOxQTnJgVkKZWFy2K8xHzT4p27YjTMRSy5QHTu/5qC7UOJEsSTxtAyVdjPo+MJBwpk7kQdvqeTQjiqCiBTTHh1M+hSSiH6u6t0s0yeqx7bczeXDd11BwSi23IL+t4Aorrv0jMNqmlFnL/ugEGtwYbpHffYRqeyDQs2mmi4zgquHTRL/i4JGdzxinRdiv+kJ3m+WNraOnF9O2Knh3/nRLk5xCnJc1ZlsLnm+c+vzz9fsXGzqDX1eOs7xDwDmuUlfw3un/FaOh4ojG1ktQ0Em0Iww0HuMR/240bF2Thtf5ev5q5qmou+C70txXKLxmQYQkKTbu8ZBgMLh67FdyYYZ8AePYd/08mTHRfI4IWgzOjr0Z6Ih6h12+9suDaXcZdLweUdSyB7+VsnIBLZYliJL75cbcJghV4j3RUOPR1gipme1fobzoVbsW24V9pdTjCaHoaP9ueoKPIIqgCB1x9asMxbSJ3OsB1RkewVPT9EWsW6EqaxW58UY5K6YgagOM6fquCqTDZSIWj5AttUDd2nuiYrIlEHpgKL/juIrtsLfDfzxf6OKsFtBNFYQI0GJEAnMrjinZ7PeWgQAvHH5XMZQzO57Z2vncZto6J0v05BTqWDhUC3LpeVnqXvM2hkqoW5lwdTFkb3ZLNcb0RC8PwMWzXIl55bRaKmpOLWlRYCvd3KRDIf+4YF512cC+Qk0aAvVkNbzo9iZrP7AB6+K0qNB4OLNDQI/QfcxY1s+Z5nYkGXJTt8OjM7oyrMVy1m16SD2Vv/Q4+i9pXjNMqG6wPVevOIkgezP0UnHVnuV7luLRj4icfNQr0T/QMVIKGcaB6ViZnaqWWfMjGqd69EWRA/crYJiNo5+22ZJeaRUxUbLJourRxF0/YptSwAcxIpbADafUlsuV+P16F4jd9nerwHiKabKf6SiFv4xh32ICtMFhoH/H
 gksp2Y3K
 eIsnNBimrWeNrbZ//6zQHlJda4P3Na+IEppdSnuGlTh8tBlKEjB/SqFrXn6P5XJ2BNnrAhXZEsVeNekegPAYhbkCv4x4kXWMe1MqRRg37YWSrsbNF0EiKWSjjgGoeEngXH0PjCtjovo5qPQG5GS/I2/bEUa9EZnqI6XldFSuW/ibwcIiZyGZ7w4khWyJNLBfwSk8UUsTb4U6pQRDV0jId8gR+KmE06nm+3fIorbk/gVWinb2QbHGAgw3TQhBgIv1gm83gJM6dFvTZUFMcyKAzU2G5fSTlO3cb3Ji8JRVSqOoDHrPG4PqUXt4IGenJOPrwPOTVjp+Q5Z90PbGJ4bqOvXfVkFyWi7UXvlmeIVZBIajKi6w6IbzPAwbVJoB1PAG/1zpU/16VHNjcA9H+WqaRt9ZU8Csli0wfrXmDWVAeUHy2kq4uS6gBf6HSEH8y1mFxDK76Q3AlNcJvmVB/N8i61hL1E3OH5dQ1umrs1nHBsrffD+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> If an unaligned write bio with bv_len >= ZCOMP_MULTI_PAGES_SIZE or a multi-bvec
> bio enters the multi-page path

In __swap_writeout(), folios are added via bvec_set_folio(&sio->bvecs[...],
folio, folio_size(folio), 0), which always starts at the folio-aligned base
(offset 0) and covers the entire folio. Therefore, there are no unaligned
writes, nor can a single folio be split across multiple bvecs.

> and lands on a head slot that holds a single-page (PAGE_SIZE) object

Swap cluster allocation for large folios (__swap_cluster_alloc_entries())
only allocates naturally order-aligned slots from high-order clusters, so a
large folio swapout cannot land unaligned on a single-page slot.

> When a single-page bio (bv_len == PAGE_SIZE) writes a subpage belonging to
> a large folio

Swap always writes a whole folio at once, so a bv_len == PAGE_SIZE bio can
only be a whole order-0 folio, never a subpage of a large folio.

> [Severity: Critical]
> Does zram_read_partial_from_zspool() ignore bvec->bv_len and
> bvec->bv_offset?
>
> zram_bvec_read_multi_pages_partial() passes only bvec->bv_page and the
> slot offset to zram_read_partial_from_zspool(), and all three branches
> above always write PAGE_SIZE bytes to offset 0 of page.  When a partial
> multi-page read has bv.bv_len > PAGE_SIZE (for example, 2 or 3 pages) or a
> non-zero bvec->bv_offset, zram_bio_read_multi_pages() still advances the
> bio iterator by bv.bv_len, writing to the wrong offset of bv_page or
> leaving the remaining pages of the read uninitialized.

Agreed. zram_read_partial_from_zspool() should respect bvec->bv_len and
bvec->bv_offset instead of hardcoding PAGE_SIZE and offset 0. I will
pass struct bio_vec *bvec and use its length and offset:

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2872,8 +2872,8 @@ static inline bool is_multi_pages_partial_io(struct bio_vec *bvec)
 	return bvec->bv_len != ZCOMP_MULTI_PAGES_SIZE;
 }
 
-static int zram_read_partial_from_zspool(struct zram *zram, struct page *page,
-					unsigned long index, int offset)
+static int zram_read_partial_from_zspool(struct zram *zram, struct bio_vec *bvec,
+					unsigned long index, int offset)
 {
 	struct zs_handle *handle = &zram->table[index].handle;
 	struct zcomp_dstrm *zstrm;
@@ -2889,7 +2889,8 @@ static int zram_read_partial_from_zspool(struct zram *zram, struct page *page,
 		void *mem;
 
-		mem = kmap_local_page(page);
-		zram_fill_page(mem, PAGE_SIZE, zram->table[index].element);
+		mem = kmap_local_page(bvec->bv_page);
+		zram_fill_page(mem + bvec->bv_offset, bvec->bv_len,
+			       zram->table[index].element);
 		kunmap_local(mem);
 		return 0;
 	}
@@ -2900,8 +2901,8 @@ static int zram_read_partial_from_zspool(struct zram *zram, struct page *page,
 	if (size == page_size) {
 		src = kmap_local_page(sg_page(sg));
-		dst = kmap_local_page(page);
-		memcpy(dst, src + offset, PAGE_SIZE);
+		dst = kmap_local_page(bvec->bv_page);
+		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
 		kunmap_local(dst);
 		kunmap_local(src);
 		ret = 0;
@@ -2917,8 +2918,8 @@ static int zram_read_partial_from_zspool(struct zram *zram, struct page *page,
 				       zstrm->decomp_buf, page_size);
 		if (!ret) {
-			dst = kmap_local_page(page);
-			memcpy(dst, zstrm->decomp_buf + offset, PAGE_SIZE);
+			dst = kmap_local_page(bvec->bv_page);
+			memcpy(dst + bvec->bv_offset, zstrm->decomp_buf + offset,
+			       bvec->bv_len);
 			kunmap_local(dst);
 		}
@@ -2937,8 +2938,8 @@ static int zram_bvec_read_multi_pages_partial(struct zram *zram,
 	slot_lock(zram, index);
 	if (!test_slot_flag(zram, index, ZRAM_WB)) {
-		ret = zram_read_partial_from_zspool(zram, bvec->bv_page,
+		ret = zram_read_partial_from_zspool(zram, bvec,
 						    index, offset);
 		slot_unlock(zram, index);

> [Severity: Critical]
> Does using mp_bvec_iter_page() in multi_pages_bvec_iter_bvec() keep
> .bv_page stuck at the first page of a large folio across iterations?
>
> Unlike bvec_iter_page(), mp_bvec_iter_page(bvec, iter) always returns
> bvec[iter.bi_idx].bv_page without adding mp_bvec_iter_page_idx(bvec,
> iter), while multi_pages_bvec_iter_offset() wraps .bv_offset modulo
> ZCOMP_MULTI_PAGES_SIZE.  When a folio larger than ZCOMP_MULTI_PAGES_SIZE
> (such as a 64KiB or 128KiB folio in a single multi-page bvec) is read or
> written, every iteration of zram_bio_write_multi_pages() and
> zram_bio_read_multi_pages() accesses subpage 0 of the folio, repeatedly
> compressing or overwriting the first ZCOMP_MULTI_PAGES_SIZE bytes and
> leaving the rest of the folio unread or unwritten.

Agreed. For multi-page bvecs spanning multiple compression windows,
multi_pages_bvec_iter_bvec() needs to advance the subpage and offset.
I will switch to bvec_iter_page() and bvec_iter_offset():

--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -194,5 +194,5 @@
 #define multi_pages_bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {							\
-	.bv_page	= mp_bvec_iter_page((bvec), (iter)),		\
+	.bv_page	= bvec_iter_page((bvec), (iter)),		\
 	.bv_len		= multi_pages_bvec_iter_len((bvec), (iter)),	\
-	.bv_offset	= multi_pages_bvec_iter_offset((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),		\
 })


