Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94021CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2588E0095; Mon,  1 Sep 2025 11:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62BB8E0094; Mon,  1 Sep 2025 11:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9521C8E0095; Mon,  1 Sep 2025 11:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81BC48E0094
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:14:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D1B91408F8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:14:26 +0000 (UTC)
X-FDA: 83841027732.06.FBE61F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88093A0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:14:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D4HjlpuC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739664; a=rsa-sha256;
	cv=none;
	b=YeEKgnyZe5Mv5u99OhXFDOIV2veFuroxS4pILYvizwt+orioIJ1XDwP+1ECWNctwDBOgeO
	+kZ5ZvE2sgbkwnj++rSJb/YibEfcE8z++cfS45tCtyj96Dy/gZtw0o9HEGPG+rOUNPsfn9
	kJHVrjAJjUaTJSxVWR5zsUz+uPP6UE8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D4HjlpuC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgq8t08BL7RNfQ5mX4qRFuahvfg5EKXwRMG9Zf68USY=;
	b=YriBGJPtFEBT8mhCzKuFwK8UT0VKgOsis0N7IIzEvBekbylazGO4S8Q8CPsDQJicVWRGkb
	G0xHO1n0KE+tdUEQ7/NNQXZmi/06sceId0YQqhsuQ5HcLIWesArYTcb30li1t0vGBvFYWr
	BJPiespD4FHLONuX3BCDKwiHofvVIrY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wgq8t08BL7RNfQ5mX4qRFuahvfg5EKXwRMG9Zf68USY=;
	b=D4HjlpuCgjLV7L3JDNtms4fVrs4paPOdyjVzNubbG9ElWQXxgv/jXHA6udiScr8nAzPsY1
	XugWGLC0g0+VWyWt8YNBLAF6sdr6iRMIajnrIF1tRhNGfy7r6LnmYBD/M9uZWRB44KWmHm
	LdsY5K1fztTk4ZBeAVQSgSmsuq3/Mj0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-GxSXaOqMOKWCp_wVKjXAog-1; Mon,
 01 Sep 2025 11:14:20 -0400
X-MC-Unique: GxSXaOqMOKWCp_wVKjXAog-1
X-Mimecast-MFC-AGG-ID: GxSXaOqMOKWCp_wVKjXAog_1756739656
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C598B1800366;
	Mon,  1 Sep 2025 15:14:15 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A0B1180044F;
	Mon,  1 Sep 2025 15:14:00 +0000 (UTC)
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
Subject: [PATCH v2 37/37] mm: remove nth_page()
Date: Mon,  1 Sep 2025 17:03:58 +0200
Message-ID: <20250901150359.867252-38-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 88093A0016
X-Stat-Signature: yob6zja19gcfir5xa6h3ti77ya3fbzc7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756739664-912584
X-HE-Meta: U2FsdGVkX195J3jQRchvnJm23YykQXlLYV1OBiwXTFquh73xQFQvLHPKZyK9kmugfpHJoXicvZc1CwNjYXP26Jo2ED6zjFX/8zrI3/CHXs1ii3a7BCThZIzkEBp0vWzJV3pnbpsrvbumkHsnpThaAO6OjRUSGfq45sEFAyZjDq9b/+HEqUQrrq+/R6MXAc47gHlLa8sWcdfVdI5rkyG9V3RYOWeKCWtqQVTF/8TonjTb/l8+g7hRM0CnQfnjTH79HBfrUfCgyFrtQMXvhHXfs48nuRIIeca5RM156/oTRJ+RdVURGDNcY2ikkPa/TYD3JB3QiocP0Mo7lue6A9/nHRuXP+ug3bqxvvxlNTGrQcGHes4PazJL8ei6znK3kXH9pnmHYL/xvYJ77zQ7QGy2bd8h0m45Uip/7OIMrC7jiZjBoUPf2nU9d91QU+DAc1qmpnQm805FC1qRH0MJ/r8QfpDoE7nFO5IzwNZwWnQSyqzRhQEYc8t2z16YAHnyP8B/m/a/Ew3fnDhTcQcbP+oTo8YS4aEJ8j9mZ8lFNhf9vTLT2hBAk8HGR6ujWeXpUbTKtUUHq1q75/9ltRDkgWpl2I+xWwN5FCxQGZwCXE0hWukhmEm1mFw3av25S3I5++P/1D6t1ANrSmEystvnY5M4tUjgpToGGyS6Peh9kR04L4JfgqtbDuL6d/NNcrrjPgHpDKyEQEX8jZQEHBdXSTF29aH7WPeIp19aii+vJSrz7JElzQXrpJPEjDt/OfepbziMoj7WNvLbBsy3MwH00Q8pVUfE3fa+lVT6ytjRlT/D+NVF7KetMkBCymDBAXyowTey/t/yu1aI0+I+o3LxR3qERJUCncICMDRRnV0TTZo2CvY8Ez0VqTdAeNNTcK9LLSWgrqZbCciKD5/YxDr4so0ien2mDLseKJpfnrcxK5iqThADPbwQw47UQS8dZJttPyWI4gfycScdcpUtqhQOk83
 Xk6/ZazL
 xqhBwfa3OLjsflizCibvmcMhF1cMAZxZfk9pE8Bdat+jTk2jHK2axmPPrKolGxOVRd7qjiOY59EexEngR61HxRvyJ/iTwN8ef1cM4Qch5voZEhEjscIFEQEa67fcA8v7jiqEGBV4vAPEkWZq2b533VRtmD2BbFgJGg5jb5Njvx3CUCRynNG7I2Ww28Wneb7LGgjG2GBsd5vRKUtNVVUcxOanWdVu4ZIjxN1hik0w/YiigcCSJtC5gl7KAQxaXO/e0Gs+Lw40s953USPdiyxc5kYFxsibkjuacCRPu5DEuS2VoXEsN6vw/XNiV3djDko5TL+fh/gTUcGEYOMVBJNqlOpqne7osPd2GwPWlg3fuCx5kvGYSSo6JA9iF4jgeaDiGqkvnMnOKvD5IhmheZvp6QBQQFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all users are gone, let's remove it.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


