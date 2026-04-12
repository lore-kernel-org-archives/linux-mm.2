Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7B4E93804
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E146B0099; Sun, 12 Apr 2026 18:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE456B009B; Sun, 12 Apr 2026 18:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314936B009D; Sun, 12 Apr 2026 18:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0FE6B0099
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E03AD5B9B1
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:06 +0000 (UTC)
X-FDA: 84651400932.01.87854A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id A86D140009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DE85ZUCr;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeiS9llWPPLpjQcwO7WKyNbjSAhoiU1ctMTrblj5iUo=;
	b=ydOnXjKchcgxNPovY7EASb1kJMiskOXdqzGxPuPfBUKdFLsAoGovLf7bQ9WxM1asBS4Lgl
	eEzl5muItds0aG08eFoSOjOQVPZqaqrRk3DtIqmNF57xTyJnXBWxerN++cJ3ZpzrvxC0c9
	JAVDOlDTGc2oUGuyg7bHx2ln3DZHtbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034264; a=rsa-sha256;
	cv=none;
	b=YY8gyySbaS97lQkdDG3RurwGjT34yNczzvZuZmWuhIqwNbLKJCi2sdP8CnU0ZJDxKv/Kvc
	mNvbnQxoCr4FmTWP60mg3oJ7FWaooCxrmRycKozF2iJeIq7pGPm4nzOYtJhz2Bb5AhLCCV
	9s62W+QPra1QcNsZ1wVScxMUCY6M+O8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DE85ZUCr;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KeiS9llWPPLpjQcwO7WKyNbjSAhoiU1ctMTrblj5iUo=;
	b=DE85ZUCrcdLWkSpLQklLTNQtqTF4+D3HsDiuQ7hf0AncU62kIk1g818GjwjENtDOOVOY7D
	y4ZqRPhYyf3QRsnUDZsIyPbNnQh5yW+mOTG9/FE2lBPTv2vSLkD58O8aqkrcSmgEa3a4jk
	9c3+Cir/asOyA0I0AcxEs0CNuhtnlg4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-dr5JRBOeO0W1PRZemdesYw-1; Sun, 12 Apr 2026 18:51:02 -0400
X-MC-Unique: dr5JRBOeO0W1PRZemdesYw-1
X-Mimecast-MFC-AGG-ID: dr5JRBOeO0W1PRZemdesYw_1776034261
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43cff5ef652so2274632f8f.2
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034261; x=1776639061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeiS9llWPPLpjQcwO7WKyNbjSAhoiU1ctMTrblj5iUo=;
        b=gztuPcJu5b6QX5R/4gq6ep8bpk2E7hgInSmxMJsskuukm8CZfYUtmbQkbqojWpUBTW
         uvJdWZ3m+e+9svB49DENbyb93aVdvNzRWW6Dc4L+3xfgku1J9dhwSkCAcMUowpj4xREz
         Lyqsn3g6mzDOZOviBr5fjWv1dO9xVNzCb2FCZn9fh0cLbch2ugq/aPSfTBrcjN7Akg3T
         JONtdiaFM1w9kyKN7zeaE0By8p+TikY2kCojbfLVPut9LMBuqqJWt7eFjb7PrDwdVQMI
         Em4CjM2s1pa1tQf38LU7aN6WcTo5XEATEJChPxdEiWqEIom7zcbSY3FdxZa3WD2WNbwr
         Wc3Q==
X-Forwarded-Encrypted: i=1; AFNElJ+p5DN101g3fA4YSBaiBsbom7qHsnKmBd0HnX3rsU2trdz39NuBMExMZWEpNRxPU/vtp+rNSaYbVQ==@kvack.org
X-Gm-Message-State: AOJu0YxbH4ncaa9nEgqEELdgVQw4k8HaVea80ZUSgbfAGbKsLRJYGaRq
	ArZ8Gx/SquscuPNkDcu+QHnHX60NPxeUO6jyX42Zkb2fx8jUR7X2yo1ljuzEJQqweeuQEHl/egw
	aGAysEiZv31ZIQQorfOwR2XZ0RO5SZTprBS/j6Lf+pklt6BdsjfQdOwFSgEf1
X-Gm-Gg: AeBDievfUT30LLpqlzrmJ5NPAMeCowoZKyov6VBsfo18gjweZdk/LrZlwn3apFo8tld
	BuwWMAtDeMDRbxco5nL2neLeC81ygG65+EJWa3vWN3zh6EDGZkRQdYqBHk2EpBIRn9ZqC5d52Xu
	O4EHucBoN1nl9AQJvbX/7OAXkUVuaNeMmqsIDNRHT/8v/iKGf+6fZQp6GkqJa6crtb1S0B9azpK
	8CAaCdR+jKvt7iUBsZnqmNhIyxkRAFodfkS4Rji6U/gcPPDBn1/AGXrfDLX7/I1RoAMRi9Hlkz9
	FMMuo/NDlyTDa2lbWyuiBDwCsMqa9ORWFVWi6OC4pI0XfrSfzASFcKeOCzAxm6kOCSBwZ1mKvXH
	AB8PbrQuMTvdjtjJYxEygm44tv175sluV3EEy9v9bsZQ=
X-Received: by 2002:a05:6000:208a:b0:43b:3be3:9a16 with SMTP id ffacd0b85a97d-43d642c1484mr16295642f8f.38.1776034261117;
        Sun, 12 Apr 2026 15:51:01 -0700 (PDT)
X-Received: by 2002:a05:6000:208a:b0:43b:3be3:9a16 with SMTP id ffacd0b85a97d-43d642c1484mr16295620f8f.38.1776034260688;
        Sun, 12 Apr 2026 15:51:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d6f4bf2b4sm12414218f8f.20.2026.04.12.15.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:51:00 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC 6/9] mm: skip zeroing in vma_alloc_anon_folio_pmd for
 pre-zeroed pages
Message-ID: <7287019f2665c85a7a7fb5ffc25d7203bdfa9a9c.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c4SJT684gTcNJNdR8caQ1dtHyTOoAg8Hd_SFJA06Hak_1776034261
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A86D140009
X-Stat-Signature: fd5sxszhes77dxypbibpxf66xyuo8r66
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776034264-231860
X-HE-Meta: U2FsdGVkX19oCU6fPrV+FA5BV5zJbCATWz0tClgK82lJpKEqa6XL2ALLtrZnqwD66FXx3ONrZrbvdVGmCLWmVxa5QmSW2DZKorCy0aKQZ27j0+RWURbfdbqIBZJtcM9I97OnFIDg0IGyFhEC9kOPjX5RtDFvUaX9ctiQDwG11+ghVvSnhGOaGfaDBQs/OEhsCr1fGhEFPlhCD2A0tiIe9YlmJ+/2+ACR4qwin3E9DftI2tfnB7qxJ/4jX0Hwr1vfvXi+zkL/JpqroEBf0YMcnrtCp6AIuUwmECtiShBkZrtQpJhg2sBpL6cNdSui+kfy8Bo0CLUg/K/bnla+QievSKAOlkybDyu/YfUt8UZ5HeyMD+izElUS5mXEyF9fV/TmkyCvYZIi2E0UQLeLt08B54dQKOuA1HewGAfuXVaHyVGf2AKle6PZE3a/g0/1HbVaH9XZzRoxY2J0r2uVpmEq1o26Ss/pTVnsz+mW3pFoJ1f866GDp1L9BVQIwemyiWf8Fj2F/pp+iuRLLyQ9R+3mssgwe4Hu22CzyNYHDNRuNKIUuzJEa3x8HMPuHoDedJ8WPRCAluolsqLo0PHZ8UDzfKv2vzjMJlQIic7IxfhSxCWcfUeeKKTR3rGNdzxEtvQdcr+gu868NZJ51HKznthGZri9fyxrGArfxYIUvlMbj4e6DxGQyzviE4zCT+EFcLAtula1Od6i7/cq16DN/KFYcaLxtzD793t4ata7M9w7X33k6N/BsNrJ3ysKmYIsHe1wBmmUW+6BOtJyb7fia57bl6MxzgwZ+qInSL7iTuDMaltZfqjkOzsaPUwE2tveB6VovMbIaTbts99mktBe+EdhDxJ53Vji3t3aJzBPh+CS+VpMf07uQVbhNYtFjd1yET512suDHX2i8ZlRo/1n4BVAi5xI7oNo71XtbHcieqgB+mKQUjUVrZo1GUekr3QMYn79vXzW+47VFMv/MhxjdIx
 5B5zqBzl
 ubldAaVeklbRtrctsVB/YObatBbgD67drQ00lI+vFkqizTWdk7jQUwGta9Q2yvfOMLlZ4rzF8VEkpK8WJsdiBKqgmAIT0xvh3NLQjmdwGnyB75UzHy/OMx4jVXGYKS2Rq3vIhlZrTSw2WPXULYihYk0l10gDEvwfZvt5NzXyjBh0o05Fdjcugd9l2mXys5BhadW1rhPNDVrDKhITKuVzIxtc0WVFqrmRuQ4EQXnETGeiHPCOWTeTW4/5qkyTpqCZT3purTmB+EkJHL7xc14C1tHUN5NRcIb+hOreKyFIoge+Mo6cYCLtSQCY8NbSLkFuj5yqkvZMMjozVSLY4RPnkyL+OhmSytNdKkHkGSK1BhNQvrsQYXDJB8raTlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __GFP_PREZEROED and folio_test_clear_prezeroed() to skip
folio_zero_user() in the PMD THP anonymous page allocation path
when the page is already zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..3b9b53fad0f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1256,7 +1256,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_PREZEROED;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1285,7 +1285,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	* make sure that the page corresponding to the faulting address will be
 	* hot in the cache after zeroing.
 	*/
-	if (user_alloc_needs_zeroing())
+	if (user_alloc_needs_zeroing() && !folio_test_clear_prezeroed(folio))
 		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-- 
MST


