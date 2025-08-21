Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29635CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA7D8E002C; Thu, 21 Aug 2025 16:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A932C8E0027; Thu, 21 Aug 2025 16:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BD58E002C; Thu, 21 Aug 2025 16:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 799408E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A69A835AE
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:31 +0000 (UTC)
X-FDA: 83801849502.28.D12C707
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B68B3A0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UgRWh3MO;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saIpwl0G6zoDDZA6kqzaAKGDHCkLp/ivw/dNNi90asQ=;
	b=Qaq2wsSXStob0ojTmTcm/0A4cfJmIrVLKMd3gAsLQOshZwwgfMoyizRXlgr8ys8qMffuCy
	FUpPyZmVxlpOEuHjT9jSWriMq+IGMSNVuIYzQnRSgJZocBU+YOD3PVtMOfR/FOrUuQ2n/F
	gouvd9HHF3xVajb1KPj1nvyqHLferNw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UgRWh3MO;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806848; a=rsa-sha256;
	cv=none;
	b=pQ2567FqffCRyhaDp87fgShTlZDaiBzUZTN3k5bDmnQvxne88q3QKD+eLlZ6ONolldw5Ff
	fYot/WpSUlriJZYE12Ni7G4jYSQMnWeUJVocV5KOGrip5NmgIwkPbxYCCVXvpz5ha/Y/uz
	dQkb53Ipe0xX8YhV4wQ71ZmhdQVNnXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=saIpwl0G6zoDDZA6kqzaAKGDHCkLp/ivw/dNNi90asQ=;
	b=UgRWh3MOvhG1iVREoH4GBA9ZpFMBK/3AS5BGkgGvEsjj94wNUdi+Yzda9564LLAvkoPX45
	49b1iA94i/+UHf+Fo417AAoYAxgSJSVLX1PUDPaCSgXRTwb/ZlAtQEV+aGgswQTdOtfce9
	ySE6Vq7tk20U0A/5Tsd3f9HHXtVwsrY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-nlK1apb5OQmYG4UrCKREiw-1; Thu, 21 Aug 2025 16:07:25 -0400
X-MC-Unique: nlK1apb5OQmYG4UrCKREiw-1
X-Mimecast-MFC-AGG-ID: nlK1apb5OQmYG4UrCKREiw_1755806845
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso7094435e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806844; x=1756411644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saIpwl0G6zoDDZA6kqzaAKGDHCkLp/ivw/dNNi90asQ=;
        b=kANna77yl0mm2HZeiDOp2AqQdWpkJjPZFASTrFmDaDn3IvXAvqrgsxE5TtfziLXB8j
         3/cNr55okRP67O+zxaRc84I5J6J/0FjjHZLpUVFpokdm+BSR2x6V5/gXpClTir1gQO0w
         6q4jiBdrvf8azkARBpoymD26NNUWV0Q0K+1CSakE/8BBA0zbT33EtdMzISxAt3Oq4rJm
         NaTbz7TYiAoFYX2JbRIvmiiXUUK2BkUQav7ae5TZnmX6P3FJ482CHCD5JtNkemnRaQLq
         eWXYgPqDIrsHwcAjbcfAY81220w9gSnfVzUjfvM1Moz4qWWgQA4UhWLrJNRJgkE1TtBp
         Vtzw==
X-Forwarded-Encrypted: i=1; AJvYcCVt5qwkNmWO0+6JRGSDiMSwgHrMrHHPzdbAGODeDuB7vo4NaL8KzuFJ3LRi2uTimUNGftmqisLDQQ==@kvack.org
X-Gm-Message-State: AOJu0Ywqc4rg4KtLFFVniW5Ms+HbimPvltmFJHlZXsVBBU5viJ3NVz6V
	gXP0ciSk81uBxxXR/T5HjHGu3IBDZHeU+19bCZV6mbRpmZZO3qY5I7DazDAPKtzwZ9nQJS6ko00
	6bR9PJEz0Tl0cyUdozoyWNO6twOABXfsTKipiUGXzBNsT3W9vD3tQ
X-Gm-Gg: ASbGnct4zzsgdsEJ+SdyYIJAv4/2hrrOrRfsByb5gHenkvrFjPn9rUf+KGiUfqd4dNb
	1iyXzXX01FReWoJlPIMQXTw7OOUOJsZQOccF7aTO7rZeYC8cyOITQUSfY0IQfXt2Elwk5stYqp5
	VK/IgL3kY2k3Hqr9VcZlY9+fyUPIw9trvfwS0dMD3fBlE+vhWoVBQHhEX/glGhaLIZVYDUtI/7s
	ykA9pPwxX7O5JqQiwhupX32edthTV1nNRk34E6YCA6yVv87zP3xGdWIo8H9vZvNNgoWY0g+ULwS
	qmJEcQ3vMAjkMXFUEX7HadodAsOiZ3+MKdQ0e2cyEAPKjFKLPW862G/jxcnpokeGpfrcPayVCFP
	Gls8TnJC0d/XcxCDnxW9GkQ==
X-Received: by 2002:a05:600c:35c3:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-45b5178e768mr3050015e9.3.1755806844533;
        Thu, 21 Aug 2025 13:07:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwjTyvRglWWHHllkR7aRLdEFYS2lmKXV2DYH9bn4L7+YG6UNdB0HbBuiJbZZ1vy18QyYWFNg==
X-Received: by 2002:a05:600c:35c3:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-45b5178e768mr3049835e9.3.1755806844048;
        Thu, 21 Aug 2025 13:07:24 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12980909f8f.27.2025.08.21.13.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:23 -0700 (PDT)
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
Subject: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Thu, 21 Aug 2025 22:06:32 +0200
Message-ID: <20250821200701.1329277-7-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VNc80z3aE7nZ_EswaXamjSiblpUi055fOwSndkPU2fc_1755806845
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B68B3A0013
X-Rspam-User: 
X-Stat-Signature: keczh1qqtej1adfw6b9orsxtmxm37ys9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755806848-706488
X-HE-Meta: U2FsdGVkX1+1gONe2EEC6cseckRgyd9cd4CKCvZIcoozed4qGHFMxxhBVQoxEyNGtoEU8hlk8ygyu6VunDlYlOCRkGjQq87DdiprHX2FQFtbkm7HPOBz7+bO8JvKmwT51WWmLJ5FtcZTg01YIq7wd7S21n44c8lUB/zPMHYretWGcjuDtn8wtMY5iJsFkTrX5DmKonhrbncOi5jw/z4e1zCmapKDdfO9Oq5uPddlSObytmkRNzwTX99h/RbtUDZSodzGfQ5jF5toyTfLwmbtNISnO6rCByY7zJyip4+DZDlMNcUsVvKpDH5kuTvkiSpRqMbYxRtKBxjS2EBINCdMc15/hGaNGrJnUpY16UEdHfbtKWae3RPjlSS5tfP4CzET3QMVI6YtGc99In239kIQUc9Sw0MBQy3psbS9wvfV20/7ntWV2AHPzILByE8XUcWjAVPGf/WKGEBPkBqYxeWYyBL19um+ZmXQGWlSDFWaJ1tCB2O0FGbFiA/SmKIbrUjKwDyAuUeOl+FaNpAbNQdEie4tf52Co6TrCYMM05dyVcwEnhXFrJgJpGhovSL37QsFGwjrEV9oQ2HStQKcAXTReap9jC8hS3bj3qJu8Wg8OuVMgMV2uGXCihvCY9VO08hT6hNQEBExJgzilEWzZiaJ8WLbQT6mvxv1MDi/1m/YMe4leI8INpx10PxD1mdvDMdQ5DivD4r1nYiKMwBQ+W5JS4hMgj6jhh8XWXn7/2Qcq+m+k2+gL3exjfbYJ3U029KVLfJSCoT6++Teh3pdl2UUga4JDoqVAoEeFIwxDjQgMLTQztDkFlM+x6FSWqfUHx78mxLPHhZWhwr7AjNgqXmUQ5E7XZKY4loLT+FyzQ5cXyQuzeclCuNotg9CP2C8lB5ansEJoPC9zEfApHRkXY6j+gpYGz8BjNccGpKZl6HAhtfNakoSqo7YdoIeTYwEu03pmKnGUiqko7CHDmYcd8K
 77uKYsLr
 2MERnP0Tf0GJV+WRsk8lF14pJmPnJx2tLbJvHgMDOfbmVt7pAwXSa6B81Y41YQFbWJ+HGDCcNU7LWauaLtCBMN6SQkp3G9l38DS3jQUQeTwpBRM5mTDaWd7rvgxOETCeOe0Fig6CzeGAzxHCPDiwI39GB5UNmWll1AJylPVni/wG0xvj8ezVOpQGf/JGPsKZGM8ffe5qnNc/wvHnn5VrZnzpB6j5TYVngTPyDao44bsHvDYEFYN9Cc70tQ3M57eQPdqMz7lEt3sV6UoHRcaRYMndApBVYQWwbcobBfEGnXPcP/o9WlrChelCr7IVelcYaeD7u+y309wXySD9Fhj9Lni09ybDXF9myKV27+62LaweYYRbwO2bn0sXaBsMDIsLa+ohmKS83DyN52R/k5ScSukTpGa0Onb9PNA+dht+Y+rgPKnf/e6K5VORh3uJuqVAyu6CeRC8YKSKxVb1csBqT8khqWfqZLgazRB7KItFlsjtEoxlh0DP/TQQYmnfOGnjjGo74n/ZPzlK8xoeOp9Dq8q5ZuzvrVx5FODas7jN5zcFZqwLP0domZgT+aemoztLtskHNZWjZDT8tGOVMl4JwKwMWdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's reject them early, which in turn makes folio_alloc_gigantic() reject
them properly.

To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
and calculate MAX_FOLIO_NR_PAGES based on that.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 6 ++++--
 mm/page_alloc.c    | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d37..77737cbf2216a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #else
-#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
 #endif
 
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca9e6b9633f79..1e6ae4c395b30 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
+	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
 	int ret = 0;
 
@@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 					    PB_ISOLATE_MODE_CMA_ALLOC :
 					    PB_ISOLATE_MODE_OTHER;
 
+	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
+		return -EINVAL;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
@@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			free_contig_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
-		int order = ilog2(end - start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-- 
2.50.1


