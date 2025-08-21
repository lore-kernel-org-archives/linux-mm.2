Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3DDCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392C48E003A; Thu, 21 Aug 2025 16:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4BB8E0037; Thu, 21 Aug 2025 16:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148C78E003A; Thu, 21 Aug 2025 16:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F28648E0037
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9A61DB8D1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:11 +0000 (UTC)
X-FDA: 83801851182.17.71AD907
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9FABC40011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdF3uDSm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlD9YGSFbsAaeSHrs+lmfmp3eNVZAqkWDWaUN3GbxpI=;
	b=JsSaEgZKedSGz4YRuctswGjzsZgAnlHj8RP7IZW/3e4j51/3O71gWKmfJJXGT0+4+Ohfvk
	OH0VD+TvM4UYglSdLd0YhFd2phAz2OAlT9R/An8vOAk5327LF+6hMGCRkB1WrepTVneNm+
	i/cRvVm3IcYRul8phSu9OYkeEy/0xRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdF3uDSm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806889; a=rsa-sha256;
	cv=none;
	b=ZKXICzQ3WaMZcaIo2+LX8+desB8FTDbYxKsScad8ISWDmZBmetb5IBC9Vinbv4thvwHzdm
	Kzo7Mgtegl9lziohM6gTdTJg7q7Oc+Rb4EgDH1Qt8J+0jpuhMEhbZ0MirRooYwDkQM5wG/
	OlciOur9RNcMT5joHkdifLheUmpzcYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OlD9YGSFbsAaeSHrs+lmfmp3eNVZAqkWDWaUN3GbxpI=;
	b=QdF3uDSmlDg5QdQZGZ9+FMiHiVECkcS0bxyCLBWMo0RIWeitQqQK4dklA281sp6zYeB53q
	RAaz3N0jUACJcLhxQwOi61SHX379onkDiNJoLu7hN0WVuN73HzUzqMQJ4hkQ+H5ACbNzfW
	7A1iT+CabGKeYidtMnHzfLl39UGWxvk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-luZUcp8mP3q6Jsrj44Csiw-1; Thu, 21 Aug 2025 16:08:07 -0400
X-MC-Unique: luZUcp8mP3q6Jsrj44Csiw-1
X-Mimecast-MFC-AGG-ID: luZUcp8mP3q6Jsrj44Csiw_1755806886
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9d41bd50aso995811f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806886; x=1756411686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OlD9YGSFbsAaeSHrs+lmfmp3eNVZAqkWDWaUN3GbxpI=;
        b=RzNQzMU3U/HY2CuPzf2LFs8sTXMkX42Wz/TtG6JvRUZuUwLALDAYFMtnJ5E2Y08ub0
         S/mY0ezHYiV7YRsgrQi3RlNGPV+yzjr59qJ3xiUDrLc2AEo+c+zKs2/GI0H/w6ynC0Xj
         cwoXiwlHYqvrjbVqlA8fYlrikwTMvJNFSSzNrmDy547yH+Zsuk1EX8arNcIpqr8rEGOI
         a76JZQmy7hCSlfHcPr2Uzd3nyUx/Bz2dBZHvmtJq+ReRmDfjwqm5RQUtbPNzKllrkE4C
         H1IgFrQsRRjB5CyGW2Fpv3WyQ8HC/rIq8ObxGbSw20r/xHVYDhfiIpYMiMFl4lm97NJL
         RnKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdkp9Htu5McjJn5+oeYjK5kyA78MEA3fEBMvmCrR1NpLl7re75nP8DZwkLh+rEkN8pUS1uAcEh+Q==@kvack.org
X-Gm-Message-State: AOJu0YzibJpBl3bBGfX5UKkcA9KelV9u80xS4r0Eir9FRlKw+cGP/WyA
	03MMXj3UfXIcOeWVra9uU15PDMMXzru1J8PuYIhIzqA67sAozZjosDp6Ym3DR/Uz7ByIgDceNvy
	jMlxA26spN/C6QU/GjqeonVsbseT8BfOP2xpn69ddZi0qW9qqffdY
X-Gm-Gg: ASbGncs6sVNsGZQjzukDXRVB1GPySW5MBhNanth7P9IFYPbC5IDVsCwzR617fpl2dRB
	173GWu6ETeouDCRS2qO8wxApCI25/+QScw+cIlQbwoLiuc3NgkwJHGZNTGUz0BeYPiYneMWkh5z
	j943HIk6NJiZGbWnr0d4jh+0aPYF8hLvRTGY1xSBJNA3dK3i6g0dG4Q50/eLvw/rGbOoLxtWAYu
	Xcoj+s4bCezwQuTFvCa621HTZ5+1MZivzqVv/VEqgzU+vB/GZcZ7FT/G7jPFlg2N0yRMe1Ymf2P
	O41CTdm1n8tJF95z8kRb8sVzvgKPQNQ5Y/Olp/aEHoGm0Q2kZwukyPA1/SnXgGYUc9xwCqXCGwE
	Dm//2co/xfhSpCa/Qi/dDrg==
X-Received: by 2002:a5d:5849:0:b0:3b7:94c6:7c9 with SMTP id ffacd0b85a97d-3c5db4ca226mr187848f8f.27.1755806886234;
        Thu, 21 Aug 2025 13:08:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEN2zPHDTqkDZIT/HT3QVvSDWvKglll+HTpAUltvzBh+S3AYz2M0rKfptvzXjL7aLPeFpS91Q==
X-Received: by 2002:a5d:5849:0:b0:3b7:94c6:7c9 with SMTP id ffacd0b85a97d-3c5db4ca226mr187788f8f.27.1755806885705;
        Thu, 21 Aug 2025 13:08:05 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789d1dsm12697993f8f.49.2025.08.21.13.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:05 -0700 (PDT)
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
Subject: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page ranges
Date: Thu, 21 Aug 2025 22:06:47 +0200
Message-ID: <20250821200701.1329277-22-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OjVKCQ0XeksV8e2hc1nhU3orb9FQbMOL0goosKyQazQ_1755806886
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9FABC40011
X-Stat-Signature: tuxyyxug7k3pus8zimmp6793badac37b
X-Rspam-User: 
X-HE-Tag: 1755806889-635283
X-HE-Meta: U2FsdGVkX19jmBBSgPJ97fQUIVeC8CKBJH+ooPa/PF+UQizSsfD2UlrbMLec/UxQ1KaeEi5jhtOMsV9u7POi+xN8XxS3VjmCs6fwDeeR+tS93AsuSXd7qMMowt+bUEhL+EW0RCHqt+YnN0zdGHCjNHkJZf8v0JB+nqZ5f/tSbbJJiXJoeVB32u96y/ya/x/fQKkiRN1RO0Q6Mv5RTSpF++dfsOJMNs/BE0cm8nm/P/K0d+B8lcUIJ/zDeSdLYa16O7yhf9Y675NcXHUbE2g3dbiBGFt1Bj3/I67WBfG/HeiaMj2RCQRo9YKWRdE8GZ1F7eA095zmjtDs3QEm/oWT45UYU40p5gWGMBJgcrQW/HZxCyVSAi0t5hYXktFZxvLjAsba3STig5Gh8MpEIAVE6UIUAdVv9clIKsVkH1UP7YwAPIEZYX50HZs48JpMVNVamTPBRE6yK28gaX5ZEv6/d02sHv2LrGb3gEcsNsUKBAqOBZP+8+bJnKRQbpAAKocy6P5u89+GoUcLe/lXetolDSOcxID73fuzxI8xxls7gHQyIRHMhuyTyLebcnVrYVZfh+hvLBPHtWAEqr2KyoDmLHTFIBnc0+34JhRGo2pyXTqfxlcMQH3ebjO/jJELYCX6h6WMxIwYtBCpXqQdSuhbKDHmJRROGZPHvXP6KYDsh9eC+NYWauWeKrxbUoq958+3Eizihy0bztYphtn8SgIEd9nLRUeydEjfzpx6r1W0u49IXvXS/tMsSOEi+JCrAgis6uD7j/b8CCGBrUkPO8u4ooA4csFGyJQJU4R49ogfiiXTXqWIc55ESLDWjk+cFOpCXpUNI1hv2dCn7SsLn7d+xjqt+/Ws+GwMpdshVYimiMK/Zb7HGPjZpnRvzyqajgkac/MjG+hf1AFzDvWCb0N1w2J5AW7WwZ6fNDddny2kXCE2/iUb5HF4ea52jQuK4E652HVfz/yKFHC+5ihX/TE
 s4ywg2Ze
 znHlJDXQTops73QLs/WhRcE1dJECtHD0R0s4DNNtZp6PNR9w3OIHAMgZ6/tjTFJG1I2m0cFlRKklnokxDtsQBIK+gikogLpj+ssw68O8SSj3JqqBMt43uoSYxqx1b88YNAU9Pl0yj2ukG2JW+gTClqWFfWr1fEZFZ7ZWy/wfTX+lsPcZCxxdxG9QHCYfmbxZu7Xe+rX7kVaaQRfh7jGfMkV5RJx8A7w7zHSP73Oo+LfG4hRcIu1kx3wrM0/RYRKGWLV8PXoPuzZQn8wOSDNqWv/s7WQ4QLdxUowJsyX2kkxJkBqGtad/x7SWf5epJn5OSnIzuhKTKzDty4V2X9D/O7xi1B4o2WM1Krs8wLryNvBO2EAbl5Wd0Pn+isn9eZ4t1gZbQxg2hAAblzRsTmDnf/8lGUlAvroqgB/0bCGEbnArKHQIzO32dAgmexHqM99i331hePgJBXhPg/EznExB/engUapq5MKjZPlfV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's disallow handing out PFN ranges with non-contiguous pages, so we
can remove the nth-page usage in __cma_alloc(), and so any callers don't
have to worry about that either when wanting to blindly iterate pages.

This is really only a problem in configs with SPARSEMEM but without
SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
cases.

Will this cause harm? Probably not, because it's mostly 32bit that does
not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
look into allocating the memmap for the memory sections spanned by a
single CMA region in one go from memblock.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  6 ++++++
 mm/cma.c           | 36 +++++++++++++++++++++++-------------
 mm/util.c          | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef360b72cb05c..f59ad1f9fc792 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
 #define nth_page(page,n) ((page) + (n))
+static inline bool page_range_contiguous(const struct page *page,
+		unsigned long nr_pages)
+{
+	return true;
+}
 #endif
 
 /* to align the pointer to the (next) page boundary */
diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99ab..1119fa2830008 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
 				struct page **pagep, gfp_t gfp)
 {
-	unsigned long mask, offset;
-	unsigned long pfn = -1;
-	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
+	unsigned long start, pfn, mask, offset;
 	int ret = -EBUSY;
 	struct page *page = NULL;
 
@@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 	if (bitmap_count > bitmap_maxno)
 		goto out;
 
-	for (;;) {
+	for (start = 0; ; start = bitmap_no + mask + 1) {
 		spin_lock_irq(&cma->lock);
 		/*
 		 * If the request is larger than the available number
@@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 			spin_unlock_irq(&cma->lock);
 			break;
 		}
+
+		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
+		page = pfn_to_page(pfn);
+
+		/*
+		 * Do not hand out page ranges that are not contiguous, so
+		 * callers can just iterate the pages without having to worry
+		 * about these corner cases.
+		 */
+		if (!page_range_contiguous(page, count)) {
+			spin_unlock_irq(&cma->lock);
+			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
+					    __func__, cma->name, pfn, pfn + count - 1);
+			continue;
+		}
+
 		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
 		cma->available_count -= count;
 		/*
@@ -821,29 +835,25 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		 */
 		spin_unlock_irq(&cma->lock);
 
-		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma->alloc_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
-		if (ret == 0) {
-			page = pfn_to_page(pfn);
+		if (!ret)
 			break;
-		}
 
 		cma_clear_bitmap(cma, cmr, pfn, count);
 		if (ret != -EBUSY)
 			break;
 
 		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
-			 __func__, pfn, pfn_to_page(pfn));
+			 __func__, pfn, page);
 
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
-		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
 	}
 out:
-	*pagep = page;
+	if (!ret)
+		*pagep = page;
 	return ret;
 }
 
@@ -882,7 +892,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	 */
 	if (page) {
 		for (i = 0; i < count; i++)
-			page_kasan_tag_reset(nth_page(page, i));
+			page_kasan_tag_reset(page + i);
 	}
 
 	if (ret && !(gfp & __GFP_NOWARN)) {
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff7..0bf349b19b652 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 {
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
 }
+
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/**
+ * page_range_contiguous - test whether the page range is contiguous
+ * @page: the start of the page range.
+ * @nr_pages: the number of pages in the range.
+ *
+ * Test whether the page range is contiguous, such that they can be iterated
+ * naively, corresponding to iterating a contiguous PFN range.
+ *
+ * This function should primarily only be used for debug checks, or when
+ * working with page ranges that are not naturally contiguous (e.g., pages
+ * within a folio are).
+ *
+ * Returns true if contiguous, otherwise false.
+ */
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
+{
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn;
+
+	/*
+	 * The memmap is allocated per memory section. We need to check
+	 * each involved memory section once.
+	 */
+	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
+	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
+		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
+			return false;
+	return true;
+}
+#endif
 #endif /* CONFIG_MMU */
-- 
2.50.1


