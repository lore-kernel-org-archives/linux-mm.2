Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CB5CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766E06B0010; Thu, 21 Aug 2025 16:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710796B0006; Thu, 21 Aug 2025 16:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544326B0026; Thu, 21 Aug 2025 16:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5576B0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13F001DD9FD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:45 +0000 (UTC)
X-FDA: 83801852610.13.9A6AB24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1883C0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbCFXHhb;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wK69Pd9CHZjKZhmlaft7kkJNdToX7IH/S9WvVIRScQg=;
	b=Nlmb0Y+t9RVKQz8htQBj0cNM8wcUGkut/3F1Rx5QqnAhapcRJt4leEPidpPjRxrUIzGzbA
	ZY81QaaLL35BoiEIkPspsPmq1/eYXHsdIaSIkrD5vk694LXvmsK91N04AYKRtNX9QlAm+B
	qcO16GMho2JHO6+ASCvORA/IsCeM45Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbCFXHhb;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806922; a=rsa-sha256;
	cv=none;
	b=PrULuv4s8agv1pYg7fM0aWrAIJWIyaCdTZx6Bl2dOsxytPQbjJRHINIWnDPAvbByRBG6NY
	ZgeXwwS33lMNkK1lnhmuzBWr/FMxrfMDEkm3/rv6guXecwE+XTOm7+Hh0eeQc4DfCN9BtL
	4RxOOWZ+LJFKcTFPuK1bcz/OFDCdMe4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wK69Pd9CHZjKZhmlaft7kkJNdToX7IH/S9WvVIRScQg=;
	b=NbCFXHhbl7F8nCT3qz4reEAUDlamu2nUfuqGTXVMftG8wbwfoRvC1Xakoyq3sQjNR/VLc8
	z67Yu1yr1OMyUOLZQTrera6NL3sUZvOjWFBvfKIQr63IcppAnmeq63Jw8zetE6cELxGQhd
	lj/M7yhBSPu+MCBpvmFqxjz3lV7fyCA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-UC0nOLGbM4CvklfvC2Q4WQ-1; Thu, 21 Aug 2025 16:08:39 -0400
X-MC-Unique: UC0nOLGbM4CvklfvC2Q4WQ-1
X-Mimecast-MFC-AGG-ID: UC0nOLGbM4CvklfvC2Q4WQ_1755806918
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9d41b88ffso838817f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806918; x=1756411718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wK69Pd9CHZjKZhmlaft7kkJNdToX7IH/S9WvVIRScQg=;
        b=S2z15xvG626q6IBLn7/cSbES3s8m34yi4Va/rqVI7EVt3ggxdy8dnkvhJ8jThjv8Uy
         AAQDRAtoTLWkhQ4HL0+DN8kQP1+ZKMchhN6ZkeSM18l/Z2bHX2q3RMtpGKdkkQjRGMJl
         WrBETFZRWLBDbUoUyOxeA2Cbma/BTllrQA6pwb33RX/If68Ywe8KPGqeIaqkXdqBmo0o
         4u5rigBG14j6w0zVUuLvkg2x3aLbJXRFDIRhMkAbqLbFq6ffr4V3Wu70qIXzypqkOans
         Dtp32O0RO4+hUN1fpRvvWocI9PLQ1GpKtlVWMlZI2mQTsasFoUh5/1rdcBGzvy+AL/4g
         jK0g==
X-Forwarded-Encrypted: i=1; AJvYcCUaYCO0I+Cf7Djlt0RaFCY82D5cS5eAagLo42nS81Q9o+sWEVexl2x6crcyq2ot0dbHPIcgIIxuhg==@kvack.org
X-Gm-Message-State: AOJu0YzXydINU3+Xz6hxRq1MkVhK4s/dEBP15lY9end4F7/sEDUUfMFg
	JHx/jtxRyO8jrLwWh5MbEO+ejPhTKHo2dcVTagdgIiUlrfZfCzhe2rnrF0zB3Pu3ATJfTtqaZNb
	/TpgQ0OHMUZ37bnenKQ4TKgAW9xjQsFJ6cX8O4SlfJ67ib9lfCfZr
X-Gm-Gg: ASbGncuGUjOM2MJbtIIukSQz6LUJLu5DFXij6cTi0/7GHQc6DF8HekA5JtKpVOo4Iao
	LYUb5JHFU4wX1Wx6oE441H+GJk9Cp2+blA2Su1oN8Rn0KRb3lM1XYE3Lo751GS+8I0akfMezeS0
	x2OrDTz0bbOA58lC1aHJb5OZk1gBJj4y8ZhZdIzz1uP10msEyMaJzrYEARp5FdOrgck6syfrhnZ
	Wu0gTV5M9KlrA6FKK+v6KuJJ484vSycD9BqARwBQmM7Jr56p+y8cq7F5Bvn4yTZ//gUMDKYEb96
	l6VMuo/EhsUMPlRLEHfY+C/UFCLsSMbjRroOZfxDdal+mF63Hh0fyFAmVXx419qPp7VVbuo9xM9
	3S9t+vQucW67d+WxObA08+A==
X-Received: by 2002:a5d:64e9:0:b0:3b8:d7c7:62d7 with SMTP id ffacd0b85a97d-3c5daefc298mr218305f8f.16.1755806917850;
        Thu, 21 Aug 2025 13:08:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETBfJ8klmP3LMs+G3FmlUfLKA9Qlb/rzelQ5gyETYamNwKefh2PCq6Da3p1XS4Ia+K1NPGrw==
X-Received: by 2002:a5d:64e9:0:b0:3b8:d7c7:62d7 with SMTP id ffacd0b85a97d-3c5daefc298mr218279f8f.16.1755806917364;
        Thu, 21 Aug 2025 13:08:37 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c4ccbf04fasm3355197f8f.7.2025.08.21.13.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:36 -0700 (PDT)
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
Subject: [PATCH RFC 32/35] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
Date: Thu, 21 Aug 2025 22:06:58 +0200
Message-ID: <20250821200701.1329277-33-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 62LZfvDhT3fFX8kvXCLEquFkrqJ-kc44Z1S-X4ZtIRc_1755806918
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: E1883C0013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hzzz3e5i3rjtdoyg61br4699tpyssxf7
X-HE-Tag: 1755806922-797640
X-HE-Meta: U2FsdGVkX18x6SDuuZU7c7SmVmEpnIAItj1Umz9GKcgZb0uxVAegDH8MO5F83n+x4K5Y5G7pUpPVzNCCZBmy7+cn6K9nQqIPF6l8XC4ic4bcRB0iDcGc7GczU8k3GJI+eZ+G+nfL5JAm8iWZs8zlRUq2v/y79DchxcutvuXH0PS9msRvaPfMWH1/DaJHJkW9N0lUz6nw0ZwAD43fmpoAw3ZE9Lv4cdveGRbC/JDADNJlECOoAXXojzaQSiyHq9qQgfOf+fZUakoD06FkhxKpVCwV+ARAmInMeppq7buIg4dN9B0OdS2jyIey1VwiSSlE4vA1BLL0DLaGBaWJcIi6uHFJ1jiqZoj5owny1IVlR+8BkK7y0d7uzaU2Mmb0BW+kO8TuXfXfEN3MLbhixVciSO7dJ9bV7jBjj5niNm7IJ8cBEKGCHFDsFpp11c2uQ0ZX/2JWmQepyOg24QDbjDnF0ohhzxNT7q5lI/imyqFrsr72k6aN8sgiIHdELAIqvfQH1CpqeBxUGBboV29DGSSH7742QjNa6qPAXUHBChqwR6FcFs7DYxstkmxcyWesFyJITHvA3bX97hCCK5wrPc/86n+LAPGgBGvNABE1Zrxq9Jbvc3K8tqXOIxd+70wwOkXvYF7iCpLgtP/zp04v2g9/1dFgEo3fOtMD9B70M80cDLlbNZwzxhr5Da1VsreLZyBObxjx0ITMJ87tFJ2Q+xPouTjqYwQfbLOSqhsXfvi21EGo7EQ3R90L11QmgqQjqkssBABVAfDiPrCLYI7hinhNjsbD7blSszbBRpMzt8xUVP+8bKxPDvAR9CaviPToEiv8H67IeXLH+YFVKZsWvU6suTZ9oLsvASTq5he0taUBhamnQcY43RkKBVyMlqr6tKLB0Gymn06c5+uTFL2OEqIIujZ2UCJ9wefctGMPTEUnSziANMSD/aSJvFvMVOyt97RFvp3BsS8EO0d+qwdSKWI
 yLVRWZ5q
 D41n8YN3h6mNf16ng5+AwAZxpuVxeHraeY3w5067O0ZxP0uhqagrWxwDbNkFF/pBnga+nBM7CAt42PFTas6PRWLDk4ZXxZOc4WU/voxt3aZR8xAi440qy9Ytf3Dc4kvJ9olyivMeEsigW9N0p/8ydiPn6mOI8LgawnWOGy3HW4FsFCoR7CKBlFnEbhcs1x9JXZgZmNRLWO3W0pfSJ5hFTPHpN9Hb28Usws5+ybB8LsscXFeoVcVtZKjSMUpluxCUS9CsI6UMAqPtcBiQpic7APtm98rDpFwWOBm5VVnGr4Risaf98jyEAmEEjBRRC4LmDOIykEcleq0p4DnwBCgMCMil8qfCNJjnUUUTKfNNjj/Il7DR7Wwafdt031O+Ut4af9DyyKyLOglbSEgTljChub5wV8rNdt3TbuYYwGGHJCWV+Xiq92uYDFFC+EAg6yxZguu0vUxikRlTrgaSO7o9JQg0dMmtU6apKE+KJFgLZO0XcPO/h7hSRUuIOMV0cP6ilFeP39coJQ6cZko7WHSV3Y5wAAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is the concern that unpin_user_page_range_dirty_lock() might do
some weird merging of PFN ranges -- either now or in the future -- such
that PFN range is contiguous but the page range might not be.

Let's sanity-check for that and drop the nth_page() usage.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index f017ff6d7d61a..0a669a766204b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -237,7 +237,7 @@ void folio_add_pin(struct folio *folio)
 static inline struct folio *gup_folio_range_next(struct page *start,
 		unsigned long npages, unsigned long i, unsigned int *ntails)
 {
-	struct page *next = nth_page(start, i);
+	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
 	unsigned int nr = 1;
 
@@ -342,6 +342,9 @@ EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
  * "gup-pinned page range" refers to a range of pages that has had one of the
  * pin_user_pages() variants called on that page.
  *
+ * The page range must be truly contiguous: the page range corresponds
+ * to a contiguous PFN range and all pages can be iterated naturally.
+ *
  * For the page ranges defined by [page .. page+npages], make that range (or
  * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
  * page range was previously listed as clean.
@@ -359,6 +362,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 	struct folio *folio;
 	unsigned int nr;
 
+	VM_WARN_ON_ONCE(!page_range_contiguous(page, npages));
+
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
 		if (make_dirty && !folio_test_dirty(folio)) {
-- 
2.50.1


