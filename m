Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA939CA0FFB
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F239A8E001D; Wed, 27 Aug 2025 18:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB378E0001; Wed, 27 Aug 2025 18:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9C18E001D; Wed, 27 Aug 2025 18:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAD838E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:12:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A4B513A251
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:12:32 +0000 (UTC)
X-FDA: 83823937344.04.5F8CE3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 996431A0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:12:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DItkAmGa;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xokvzkSIEpQffuWgfIG7Waj6e5Wn3/nTay4YDrY+vKU=;
	b=RUQLgAZp4Nk5jvbd7piihyBp0ZOMelizPL8XUU/G5t9iAQuj8+sJalD9rpBKCNXdmyRm9M
	KCSBc5v3oiBS2q2aWEffKGJVKNEPx2IDGAOxxZxR9A0Eo/aVesgboZTtmpRt8rFXW9SxiO
	yw/TpnVEwb/DH2cfdFQK+QJpY2q8o54=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DItkAmGa;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332750; a=rsa-sha256;
	cv=none;
	b=EZdfDJ+95KTvojKqfvtjFFewo6dYLI2x2bz0nUzx6Ta0m1Se3q4oFhI5/eapUStrN97vkD
	LUGLuqjNHoNXh3gGCJqq8MnygvnuXQ+4bnR8VJlXGeUhNw9pxrPtmv/ITXs5X1g12gsAAi
	xiqw1LXpfPzhA3zFVlxvbOL7xY6HYWs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xokvzkSIEpQffuWgfIG7Waj6e5Wn3/nTay4YDrY+vKU=;
	b=DItkAmGabgzYv3aLZFCKG7dfTPOnhvW4Q1lWQokUnGR7feX9KhVcvj6C2eBQJePzuq3b/V
	dOIgaMRig2V/qQEhRZ2YSc6szLFg7bU2KrTF13YaFxyrSjaMPt5VyBNDmfu5tVpBkIQcrR
	MFXCRL2FLNAoetUfkMPiEZs46vndKLA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-RQvXUovaMI65FI3R-Bh1mA-1; Wed,
 27 Aug 2025 18:12:26 -0400
X-MC-Unique: RQvXUovaMI65FI3R-Bh1mA-1
X-Mimecast-MFC-AGG-ID: RQvXUovaMI65FI3R-Bh1mA_1756332741
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0A3C19560AA;
	Wed, 27 Aug 2025 22:12:21 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2874830001A5;
	Wed, 27 Aug 2025 22:12:05 +0000 (UTC)
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
Subject: [PATCH v1 36/36] mm: remove nth_page()
Date: Thu, 28 Aug 2025 00:01:40 +0200
Message-ID: <20250827220141.262669-37-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 996431A0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: oyiziyiw18decenr3968t6jy74dkay7z
X-HE-Tag: 1756332750-986538
X-HE-Meta: U2FsdGVkX18LBMGCfMbshdwdGNmNmMnyO05GUFkP19nbhZUzI2mkYajZUWQQbY76qGz9kUrRodCWB7AGKDOIM7h+JOH1NduQNdG9Auhx+xArlnJEiUGXoXKZT51xgFxo/oOktLkafhimB1HN0RQiVfD1buTsIPcFbaYyBdfa5u3HHvKlVIaaYwPNIPLxYilNRZu53cdYd8tlGbAyzQ6C7wL1EUtym57TH84FHFB8O+V7Tj2BUkoBbfosqr4S3VRYudwACRqS68EUE2JSrRsZ18uPiDds2zdEbKIf4L+DkW0Jq2dQCLYUATTVxZTcgv8gjscwA3nfQ9AdTk+uPyYR1PkZ/9QDM0ilJphhP3L+6FPb5U23rwHtQpIowc5m+eBqOegLjKT2Uj5W1309tiQyqIgDu4At43/NG2ufoIwa4OFahgxDqDvefcWzSSiFjyfsRyGA2VOL5tLuV+lIBfozhOg6Oxrp0QY3slNRoyyBrEjAC+5Bi3lYDM6x+yhcD7jLZMoI9XR5UjxMEk0axHZm0XxebGr8mWEvhTuLYqfC3IdM/isGv9+8dHQQ8Mp7yeZFoHOlYXxl8j60K5ldWOLnnsoEfee+u8PTqcCITJVsMmuhafyrs4dnBlr9qk6fB2tIw6rPII3zQoCI8UTt6x2CfQpU2kF9RWDgfcltNY4zkENF9EwaQm/q2wxsyBY8O8sqfqSULHThDUA2YTCV1GilQ1joaYm+GB5aeBF7nCbw3XEUdgdkRxHZyYWIk5VSf0NcfxHnjF30RVQ96YRFWdG9mRfft279RQEAF+3mTORWGlJnW8p0+D6oJtw6q6+QScokbIEJPxhqWsAvviytwbV6lrTzK+qqmzwmL1Jtx3ETnQDhwxT6gmE+/GRqAgjSzUBs5rvQIajO3mP9evz10FjunPDXveB5n9oZeBCwnl7LqLFoM2VI97o2n+6f9r+z5SFmHfEFwlXUyeXFYpHuzjr
 1fk3YklV
 oNlDxp1iJjPC4Gtpv5TZ9YPUqkQxfoX3WhjJJZf3mEStB5vcyA2gSNb0YH0U0Sb562UO3QH8jsXwBt2tPCKD7QaOT5jw+6GlXxiK4Baj/uuM/xbi2ZeVytzA8bQozCvhYsI8EpHxkcccieiXiR+wrJJ0Nu4yvFgLaETilWZplE5EvZAMnDxMIPuZOhb0+DlYWHcAvU2B7TimXJquyTb7bDuVdvjc2b3+tcWWtiQX6OeDBWiKDyRGirFfuhw9FITxBEBAI2WDLfS3oTaWDoCtQaSgbOl/qx5zzUqwj91BCPLgpSma3+oin9QGS1wDI4UjxohUtR87UrvY4F6w9LfNpcPzeWlyHN4iMHT2M9Y7xaZ3mmCSJJzMvrcew/Py0g42oTWN1ND3oKhHtlM2ZRnB2o00H8bSlNUcSawwlxS+hCf7v5seOHnFdVx8cePwuavGCsLBJEaaJxCgSS05Ua3WxF0T+kf02T+fKmgIO6cItVC7KgUyeL+DCR+PI2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all users are gone, let's remove it.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h                   | 2 --
 tools/testing/scatterlist/linux/mm.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2ca1eb2db63ec..b26ca8b2162d9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,9 +210,7 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
-#define nth_page(page,n) ((page) + (n))
 static inline bool page_range_contiguous(const struct page *page,
 		unsigned long nr_pages)
 {
diff --git a/tools/testing/scatterlist/linux/mm.h b/tools/testing/scatterlist/linux/mm.h
index 5bd9e6e806254..121ae78d6e885 100644
--- a/tools/testing/scatterlist/linux/mm.h
+++ b/tools/testing/scatterlist/linux/mm.h
@@ -51,7 +51,6 @@ static inline unsigned long page_to_phys(struct page *page)
 
 #define page_to_pfn(page) ((unsigned long)(page) / PAGE_SIZE)
 #define pfn_to_page(pfn) (void *)((pfn) * PAGE_SIZE)
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 #define __min(t1, t2, min1, min2, x, y) ({              \
 	t1 min1 = (x);                                  \
-- 
2.50.1


