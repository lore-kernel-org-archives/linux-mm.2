Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23560CA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B958E000E; Wed, 27 Aug 2025 18:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECBF8E0001; Wed, 27 Aug 2025 18:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3F68E000E; Wed, 27 Aug 2025 18:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 356418E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:05:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05407BBD12
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:54 +0000 (UTC)
X-FDA: 83823920628.26.BBF8102
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10E901A000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TefR4SCw;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOg+y93CWdttiSRHo5MMFmvDG+rRd/OMag8GX96YAWo=;
	b=uhH0lpzUC5Ad1XAx/4vCnCEEBRc6ON90rAnahdJEEPaoXbracC7ITOJ/c/JnyqkbKJzKzu
	aAa4F8obDYYBxhBHoA+0g9iwUlLy5Ei3KqhnHcUKN+Qx22WTJRyfJE5ZM1Ygk/5VF8xhuZ
	peM8A41nMp3v0JzwO5xTm6JPwH8Jz4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332352; a=rsa-sha256;
	cv=none;
	b=UMJZHZiJr/JuDkwxjG4hqdNRRzATnnCZhOEdDPNgY4bi4OWkVfVyltHKBpe6AlNNp+poCJ
	YYsw+8oyaJuUp8J0ZFv8h9bqpYCoEN7Nc7095gTn6jc6ewnCAv0qV9bXQRBRa/0JB8tv80
	3yIVV2UCYJ5Jx5ua3PJXF2+M62a7/r8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TefR4SCw;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOg+y93CWdttiSRHo5MMFmvDG+rRd/OMag8GX96YAWo=;
	b=TefR4SCwLU95eyGTl4qEexmmI7iO9PjzPm0VYw9Pg8ZbW1gr7mtOtVmvUXuA4/psmmpNJz
	UcnTqnbOa6MLiIkEfIb3Ec+g3la+rGkIjOMOKBWLJWTq3QwtnghX/6dGLcWmvL3CtnaKXA
	z3+xpAyV6KoCG9u1QYqBIFk1i192Tjc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-z4mlROjvMIiLD1GebYFmSQ-1; Wed,
 27 Aug 2025 18:05:47 -0400
X-MC-Unique: z4mlROjvMIiLD1GebYFmSQ-1
X-Mimecast-MFC-AGG-ID: z4mlROjvMIiLD1GebYFmSQ_1756332341
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEADE195419A;
	Wed, 27 Aug 2025 22:05:41 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DDB1430001A5;
	Wed, 27 Aug 2025 22:05:26 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
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
	x86@kernel.org
Subject: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Date: Thu, 28 Aug 2025 00:01:16 +0200
Message-ID: <20250827220141.262669-13-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10E901A000D
X-Stat-Signature: tcu498pk9jwn6eqqfbtuje6tg7ettmi7
X-HE-Tag: 1756332351-88944
X-HE-Meta: U2FsdGVkX18VV/qKVMiY+2sGhS5gIfTIK3HOdOF+p8pRRI3DVOSNc/eapKUdgByCWNvTPwPOi8GBqOHJ6KFkFlQ4nL2IqWLnIvlYAmvjvrE00kAlqkMbPMnAWzUUu948GGlzkzGzGpsE/HJ1yg6+gi14THcSYKBPWaYBNajOkU0Vwd2C0xfe3089q9QXdJ6VvGAwGFfLVnxwF0aF6qFZaXVCihZiuswddD+En6j2mw66EDJSiFrKWhFa4zTa7unak8RD2sDqanh3mHrmR4eyFGKRSART8N79mARD19ILTs3KD+YZFKl5mhIk5UarxK6Hu9+68WtLQ+ikEvgcM5bHy816KjPghzBvAWP4/b5kt0LW7AQr7IWnfmj6M2FPMlpJ4pN1ABo8+Pm6ut6GJLn2BhS3yO9x0uLMuKZFEOkxQwbjALXOgJ/3Kh6sM+nXpXTdBjuELZ8CiBIWUfvh4OufCJVsxLmXEB2SolZEW3hjE/3C0mrsGoX4/NuzujHA/Y7Yd/+tpyDB7vu8wHQ+uoEOOnXeVSJB6VbqvnmKV/CURK5MjdXf0xPpNGUqD5uWSlPlKW6yT/g7ndGNrM7rKWTJvyd1BjIJ5nWWa/+UkNr44djnbQNH5q2tGgF0nP6Qmyk/zGRHJZjUm/7xcax+53K21mKt4ixZAtee+ArX3BE7HjF+MfNu4gxelBW5Gfmndq2XrP3dyDLWkKRnQYN63Oa4zDuWO+e/76ZZipHaXAs4zFWZ60txgV7wewKBNfRg48FniYlgFAlJuwdJ5NzKrXYAfiGVASvv+DIUHkrNQBewQd4iXGU8QC0uXR7Fe8wru0EPr//lqCPKyby9AUDQjkpiL5P+0dG7DC6CpvFPEiZo5FpF3ytUkbDvImsx/8J8LBGQEVBiD8UMfjuhPeVj9XjavP+hJticr+puh/rbzJMyrX1GcY5Qhgf26y9XMNiJkEgZabB57ZD73QOqv+q/el/
 2Fkk8r74
 5YZRgxfD/Ap6R5YEyZVDflyYR/ejUNLvoLbT1b/NFztAkS7UcJqmGduocM+zG+LGdMmlAcL13uqeDERpTB39+1E8f2ar6lpdVJ40UiAQfh8pguNkBvg2wKW3YDvW+3Cg6nlRTt29dn7oa/cb4w4lTyq+zVhtKBlrCxdkYbz0mnpivS3f59QxFyOqoglL1z9mRRcpQpnCH2Gw0VS7IyCaNxiuYUSnKrHi6uAdeKUnA1iA2O1rlCwpUvkj3NwovudMwkwm3Gw9fuy072hs0LGKbp18gcCeMhcxsy7XYUQT9VnYlESv7Y7CJel2JQVyNse4Q/wm05LhkivfDLIHpJ2d8DHNoRI3pHDy20f3qQOXkPMtQE72hFSQBEAaTaBkYTWftUF4iJEkB/mAxFBVmadSsa5H8Xg==
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

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h         | 16 ++++++++++++++--
 include/linux/page-flags.h |  5 ++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2dee79fa2efcf..f6880e3225c5c 100644
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
index 5ee6ffbdbf831..faf17ca211b4f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
+static inline struct page *folio_page(struct folio *folio, unsigned long n)
+{
+	return &folio->page + n;
+}
 
 static __always_inline int PageTail(const struct page *page)
 {
-- 
2.50.1


