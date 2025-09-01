Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF77CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CC78E0080; Mon,  1 Sep 2025 11:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15E48E0024; Mon,  1 Sep 2025 11:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41C68E0080; Mon,  1 Sep 2025 11:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97AF48E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E7405BC1A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:27 +0000 (UTC)
X-FDA: 83841015174.24.1E9EB18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F7A04000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BdDXjGBr;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5i9udlRk4QSJedS+fkFLitKqPgB2ec3GW66dESbqjw=;
	b=Vv5pUZcfiQMMJ2We04F95Ec7+MWhc++i7exSQ5ct7lNmnor0ZnBhxr4n6HZ8+zkD9Rn1F7
	eNqPvBNqYqhaRKfWAnndVNodmWDZZSLN4YBLknJpkNp5qsH0dwahcM6WVe05OQKzmaaCIV
	dOmoTQ0SMqwlRaUCQY2HvArqPlew45E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BdDXjGBr;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739365; a=rsa-sha256;
	cv=none;
	b=bWMiyAYIy7JRmHLNAbXISACloUB8gwNC//2gB6LuXTv0EbUAxZ+a2mxaWWYNsY56UpF5c/
	rosOlZCciC0ahafAiP5NOm5Ffz2f6OqJUy3oeHW+xVHAIMecvQwtE+VO6m8eR2k7tS6osh
	Cw44kpn9xUqku+fHdnP7e2l9g7PTO7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o5i9udlRk4QSJedS+fkFLitKqPgB2ec3GW66dESbqjw=;
	b=BdDXjGBrPmrMX7h37WPyRAh2jGy/cFfl6vwcgFWElAnIOFqiAneblVrZ7tsDNnlE/hLAFb
	ZLW7huL8Tbs389h0D2BuN4fQ/e6HtM3h1tGGlbeD+7fC+ssa1+ILEAJrYLHVungkffskT0
	BlX7P/xo0V44xJD84gF6Lj3OVSD92Pw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-Qi9ByX3gP66LGgSG-c-ffA-1; Mon,
 01 Sep 2025 11:09:18 -0400
X-MC-Unique: Qi9ByX3gP66LGgSG-c-ffA-1
X-Mimecast-MFC-AGG-ID: Qi9ByX3gP66LGgSG-c-ffA_1756739353
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06857195609D;
	Mon,  1 Sep 2025 15:09:13 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BDAE918003FC;
	Mon,  1 Sep 2025 15:08:59 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 18/37] mm/gup: drop nth_page() usage within folio when recording subpages
Date: Mon,  1 Sep 2025 17:03:39 +0200
Message-ID: <20250901150359.867252-19-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F7A04000B
X-Stat-Signature: pzzjb1z33erydoud7afr5bmjidj8c93d
X-Rspam-User: 
X-HE-Tag: 1756739365-510974
X-HE-Meta: U2FsdGVkX18DXA84YFKmnm5QWjF8uzwtQs5nTIYVPl6IOG1p4s+m7AingagQDga6v9D7DjItEQ78N3kVJH5U0X5KEpkNIAWxk84nGBI6f+S0Y9g0gKQEDG4B4UHPYhSLOs080QGGfJfKs2qYXNdvZfRiwcCYhtUPq+LSLavTA45iHlrZ6s8fB2Clx3Wz44PMe3UWfD1P0aY34qwJU6+5KpiAm/G5EG+co0yb/pVIJbsFflNSH3v4Tf0A+Y7yCx1Ycs7NYdCPsTjVp/fV2cKVVtS3Rp7rbfCBdUya9M0+zu0pXxLsPx4/yqQR/ltlrFBk/8kiyRF4iSvuRJdWOmgjBiF+PP9VEE6TcEg5yRgG68sR22InkG7Dzh3BO1fDLnTTyfrTmRd5BpppEEB7/1tolEGwr74efN1VvSRCGMwvkrnBO/9A76xTwodggk5VlVB1HIvVqGWS/FYqJO7DsQl46feCPOQ/1oDI1t5C+nJzMyyw+S7lEZam0eumuCoST9RYGF1pfXZsNRkNROxnV604sf6T+7kMfcHbEo5IPRF99NSrkESCWho+8pxpGFQG9DDMHCSdOuXichkRXw8eW0xQeZp6cVXjYgNB0qRWzccMzkkPJFOt6wPDyRS2TShRIYDNpVk18Ga5/XJRMKRYnRXHLvk2oHDECc/zgLXalQlDYwnLIPrl19O1ukqNFTWUYQdwPnqmF5VP3XD6k3sUsRnqBEi2g1PAbmDrDpv3NjYVDzwcFme8alFeCXAVdqVeQ631TlhNXJfoFaroBBod/XYXXeAJlt6Z/Blrchm1f9bcScG/8nTRnfeCm2Q+WssxXnDxQcD03/5iray8SNCzWt7K7EliKLytghJYcBsx9Pw/pVvRO55silvN8jrbRQQLaCx90BrN7kr0Eo/PMIlNKtpkl+1gbFEHTyFZRByWhXEy77ODPThWe6XJI2M56xXbSX7UsJTH6CKQTLhPt9kV/xp
 qgbqttHs
 4DePdPwHfv283dS4OTXkh9k+rU6kyuyPB7Vk86NyqNiHlPAIvsFxo+8UacqXgb7vgzxF/YnDnO5B0oRu9ggV6i0t8muBzUvcMoolSkXb79DoRsf3yIYHZYjIunYjB/9Sg4x8XRRCeL7+M1XCfwyzrZrDfbg3kF7puuATbYnauoEicFuj6nbQOhCJ27HVM8DkEHYunO46i1r8ELKvp28BlKmINk3uUCIK6tSRe4tF+QZjB6eaUVsUhWJnn484ljRriJGkhjoWW/4yUuicXz5ibrYkM0wHjFSslSmwr63pQ4lWYW05lFQdaEyy6f0elUjTjUlf9rvXpQCg2bqETYaRvUHfTSx4tOJEt0IB+1kmGKSW9fWrI4f3tHIdb1DTeCiLGj0zIU6O7xPKlJBxMD+64QrSBHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nth_page() is no longer required when iterating over pages within a
single folio, so let's just drop it when recording subpages.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8157197a19f77..c10cd969c1a3b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -488,12 +488,11 @@ static int record_subpages(struct page *page, unsigned long sz,
 			   unsigned long addr, unsigned long end,
 			   struct page **pages)
 {
-	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	page += (addr & (sz - 1)) >> PAGE_SHIFT;
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = page++;
 
 	return nr;
 }
@@ -1512,7 +1511,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.50.1


