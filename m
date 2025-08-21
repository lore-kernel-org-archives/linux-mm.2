Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4CDCA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5D08E0032; Thu, 21 Aug 2025 16:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57128E0027; Thu, 21 Aug 2025 16:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAE68E0032; Thu, 21 Aug 2025 16:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9388E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50E80140537
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:49 +0000 (UTC)
X-FDA: 83801850258.01.F89F466
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 213E216000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyYTfZbu;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkrXh5PHMEq3NY5i+0892fbAshOERsmwyMLhbVIa0Cc=;
	b=1BQwNV0SqOthmg57cQCrD+vAe0YBLeXxjV1kAtBgb6mCVEDJIObjZEHOjdbTVDxrbvUBYc
	xM80QhyO/GMHdXj5wdmL7Cv3tk1c/VKKRPkEb03yLvvTQc9qRIplj+F3pkz41MBQc8xNgB
	ZDWT4c5AB4cVmXsqbGWvFHc2ET5qGSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806867; a=rsa-sha256;
	cv=none;
	b=dK+VCegwra3RT4CHGYdHtGyIGUQc3w//LBuZl7BbQ88aqdFFQyq+THJjL9AU2F1WrF3RQw
	vLDusz4A3UEmZYu+HYTjtKBK6e1/JrGVhNCUILrS2jy2x10/ic8pi7MAyTdXgi+lj3cKEg
	ggHnKDynDVWjtWGZNCnd0OuDrVRpYvU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyYTfZbu;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PkrXh5PHMEq3NY5i+0892fbAshOERsmwyMLhbVIa0Cc=;
	b=SyYTfZbuLDjRLeVEASoNNlrJO8iu+FMJsS61MAfef62rsTA54jfinhZ2Ej15mkcMUKY3of
	8OQce9iU41kpATn1T0j8qRkpMTH4parQNIs65gYoYcrgj2R7RBYbWmsw+WSdGtZkvT9hhe
	lvoZhhvzh3D5UPfAOd+aDROv/cVlIFY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-QPNvMFo0PhmhZcUO_PJyRA-1; Thu, 21 Aug 2025 16:07:44 -0400
X-MC-Unique: QPNvMFo0PhmhZcUO_PJyRA-1
X-Mimecast-MFC-AGG-ID: QPNvMFo0PhmhZcUO_PJyRA_1755806864
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0ccb6cso6973625e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806863; x=1756411663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkrXh5PHMEq3NY5i+0892fbAshOERsmwyMLhbVIa0Cc=;
        b=q9AnF/Pb6nu6QstqLbtvknTRNLEprhj7y846EB7dpcXyZj9hxJvwe5k9nfzFvGB58b
         8plzQXGQ2auEXGgtW0nNdqrB10yX/5Xp9vYk2tH8GrN1YNT669MjamVJUXZ/V0sRXH2R
         NWqfRVJk8dMvEwK5Qo5TDJ6lWD5lbkfpEgB/ZLxXjF3M3a6iQ2fnONRD7s4h4kBiJZvv
         lZaPSclSPf7VOglYolmFPe08G2mhewUAdMwP6aHlHgsik6TwUJrxzOeUaHeGqUr7RvZC
         mqG7ang/P5/fmO1V/JUfbbaGFcdqPV8BnS7J8b2JFFu0l2+B2Io2h7HvV0nR8QqtVE1U
         tYIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwg8mKfYlqTN0v2t062lhnT/d5bDWfXankqE+G6XEw3STk3SXGP90H8dndpxwhX19+yhSxAOlLyw==@kvack.org
X-Gm-Message-State: AOJu0YwdWn5s/4iqUjSNphywerMsKPxBmf7tM4SY+P9vlGHkj24eIRSn
	EZkcD4tmNhAHX6fLMEy/MY//fxcYY27v0yxWlewyB1BH8yHYn9pVGpmTzntCkrMGrFUaB+xUnhi
	N/uehaRWN8lC8GS5Nw5rpo2yICOJePoTuHPp52Ubgl/MngsRu8wos
X-Gm-Gg: ASbGncv/cnnzetoaiHyZuIELhFoVN5KKAtnvGQDgJm4qlmcgum2mx0nm6XzukmVbB9i
	M1aReOLRgF9ml9JkQpu8kbVsjWX1XGqmBMYEr08C+RfYwRKw1lVwq9h3HrcjkyO1j00PsC0Q+ck
	JXGwuvLSff3pET359VcY3GOfFFD+UYU+v866oQW5vAX2fe4kZ38Rj5xYqsbzVIJ+WnpSr6usv5V
	Wt/zSpyMDD9avUGnl5cF6hW6tRJmdpyX5SO/fcvwZobg6/l9bCp2nmjPVlNRQjppDu9Ynvp6OW0
	3PMMd/mzdWpYLq871btDrfBmpz6J0ZMMxhg0ISn48tHPGCfwVNfbHjlNn1D7Dw1EfDf1MYwB//1
	DCTgFGdKEZQz8DG7c1z3GXw==
X-Received: by 2002:a5d:5d0a:0:b0:3b9:14f2:7eea with SMTP id ffacd0b85a97d-3c5daefc2a3mr192535f8f.18.1755806863468;
        Thu, 21 Aug 2025 13:07:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFB28V/U3gI+p1afMr2c1HujEN1g59N1A45YIj+RBO5vrtdOMlsNhrN6BtrkE7YShkW7nBB8Q==
X-Received: by 2002:a5d:5d0a:0:b0:3b9:14f2:7eea with SMTP id ffacd0b85a97d-3c5daefc2a3mr192518f8f.18.1755806862961;
        Thu, 21 Aug 2025 13:07:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b51b61256sm1742995e9.3.2025.08.21.13.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:42 -0700 (PDT)
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
Subject: [PATCH RFC 13/35] mm: simplify folio_page() and folio_page_idx()
Date: Thu, 21 Aug 2025 22:06:39 +0200
Message-ID: <20250821200701.1329277-14-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0PP9ekY5nGfeFEtjYzyhIAo9UCFcKjN2zzaeOO0ix10_1755806864
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 213E216000F
X-Stat-Signature: po8fyc74u1yxj8w9ekxg5rhu73ika8j5
X-Rspam-User: 
X-HE-Tag: 1755806866-598584
X-HE-Meta: U2FsdGVkX1+iFRNtzNNAmffCNKMimuqybLU7LYT2tM5sxp8PQnEnNWHUPRxEffuD/6HPmdhDnL+25ntzAHcvPPF6IZ+wWXlADWjAdSAmT5tWlwcO6RgDs3tsP9M/KLpVuawqBecvQvNcaKJabcc8IjT0nkWH+Db8EIzVq1a4pIKA3K0miwn93OL5xxTiF1L+y72KnhWDMrXiV6eONgFc8ArEbXZ+M7T0C7Bg1RsFt95LIeN9zyBmaNqPxpTkOh3Y/RXkDUeeeW/7eWi1lC2+QvnuSxxRtbHavcUCpwTIhKcn/KQNP7tcHzM+yWxPSJ8ecpn3VbeDrnvDl1oe56UFOMqNMV34By0j764iFZf2KRH8SXt70AqOSGPjC+Cudw6HC8PATW/vwLXC5oYZ83x8gNRMOyvd9EZ+r/VlcTjrsGHhI9QUwuNLgjVjk1fcmIap9dl9mHTcQHAnzqw9iw/3lHMVEsNDJjDm5VRD++YV8EALwgDfFGlcmCsTRE1pWIjJLnXvhRxnIk5ibuJXXho5UPCdcOFANEsYKmiBC8mkE/mxxSTkobaseOm3+Dr+yeXReJYPBXc+L4qau+ovHDA23BPHM6ax51yQ4bePdMHAwDwKJJ/kD253IIsE7MS+98icDi61bLzp+TVOI2qULmlWlg5UZp8vkoIVFun7QKlNJ5WtdCMNM8z0LoHmQUAb0F/i+cUUUsH0LxDmKWESuP1K0W8rJlx51CUa9PEa61435Dt35yHa+YBP1V4+Qy8OhiyqnFbBFBcwiAyyIUWEwwzDK5y72Xge93QBM+gYKs8hCYzO+HjtiMOW8x8Ro27cVOW4XIhDQKf3QFoPO8invkwGJQIi8+jRShzk1ddqy/p/7bvYNKBaV25h0OC/hrjB3/TEuLz8xZv3JKlq0pQeacAMBXjWV3IzQwT+fNCIO8zlREFQtintakQ5tw7PTB9u47QoLVLIg2zKgpmJm2G1qNJ
 XeEhe7LY
 0bB9OnRePcLxFE21Rk7xgFwdv62NHlJ6eXW0k7smmkS6HgYQTQ/xHyqkwbG/fhRgd3aarD6bDOfW9njUrg3c50YGVP6YrLCLoXqr2owCj6M9SQJOFtz02gg3uYmYlPGZ0BsJ+4e/LhQCELbRY30aNHKEOJftHPhJWsmh/ludygwN3Gevilf3aMzLwJXIWWTdLhxvInqo9sa5stGGCeeF1fn29aIGqhJ3Sq7sIEmmISEh8WTEOjeXr8swh0LkNya6fWEbmulV5NJuyBfgX0rnugzXsrtVQU2YgSLUBpdzcyGBEEZwiVWE/tTZB5fO8brJ+O/CrC5R9e3j974RofArm5O8lgRtzCNINXdDGziBkRyJyuPqAUE20jnXTvyF1kzzqkHzWfRxGwJe1PAGAYMFD2y66lT1VYQtXvVTsGSJqOfQtv89yjbFqWiQEXVN3FjglVM4JvrOLddsta/8SgFgwAlc6bW6dv6rhFljwt8iphtffiQQRkZxP3Fm78yD2IDPLmL09x7jWosHnTwwTFNB02qlCbGVyooDTFrqw2GAGZpiaskqZWX6+UX5aq4OUGIJe8AUm4RlEGSvhVCfdDjOhMM+Rjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that a single folio/compound page can no longer span memory sections
in problematic kernel configurations, we can stop using nth_page().

While at it, turn both macros into static inline functions and add
kernel doc for folio_page_idx().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h         | 16 ++++++++++++++--
 include/linux/page-flags.h |  5 ++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 48a985e17ef4e..ef360b72cb05c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
-#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
 #else
 #define nth_page(page,n) ((page) + (n))
-#define folio_page_idx(folio, p)	((p) - &(folio)->page)
 #endif
 
 /* to align the pointer to the (next) page boundary */
@@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
 
+/**
+ * folio_page_idx - Return the number of a page in a folio.
+ * @folio: The folio.
+ * @page: The folio page.
+ *
+ * This function expects that the page is actually part of the folio.
+ * The returned number is relative to the start of the folio.
+ */
+static inline unsigned long folio_page_idx(const struct folio *folio,
+		const struct page *page)
+{
+	return page - &folio->page;
+}
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d53a86e68c89b..080ad10c0defc 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
+static inline struct page *folio_page(struct folio *folio, unsigned long nr)
+{
+	return &folio->page + nr;
+}
 
 static __always_inline int PageTail(const struct page *page)
 {
-- 
2.50.1


