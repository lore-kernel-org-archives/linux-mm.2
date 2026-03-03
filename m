Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C910E67A9B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B406B00C1; Tue,  3 Mar 2026 05:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9195D6B00C2; Tue,  3 Mar 2026 05:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8326E6B00C3; Tue,  3 Mar 2026 05:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 744256B00C1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BB0613AC21
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:35 +0000 (UTC)
X-FDA: 84504339990.21.8DDD1BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5375A180008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pPgkx2p7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xW5ABiJuz0SZngodIpjwN+RMsQf+p1fjg8v/uggLew4=;
	b=3bmLn+sVMNNMz4tXTbscvwK0r14A+0DlinHiP/v2RSBy2DGiQUwy7bLbkIoWpbi0gUHFT/
	gISUu00EvlZpq+xr8VjEoTQCT0bL4cxs9m4YryvIkm7HEc6NF8Ek4GCwaelUUqDF5P+bIv
	oEARNAbQC8dtumYt5r2ZNKiSjfpEPSc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pPgkx2p7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532813; a=rsa-sha256;
	cv=none;
	b=bj3Agl6Cju/kDZtYiXacWhWjMyua6rWm/p9OnrlpwlA5wto+y1ewkXyKBddyobWaEi4dhC
	K9a9DtcgOsopnLFmgSTy2m55Ll1yC79KXYi/1LbdGYIR67WTZK482Lu6m5mQysD3LEwqU1
	w9NwfnBEXl9HXh4tRS4lKWDxxrjLY6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C46C4448D;
	Tue,  3 Mar 2026 10:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EA2C2BC87;
	Tue,  3 Mar 2026 10:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532812;
	bh=xA8iRNbldwAg/IWB0t2FyV0TtMeqN3qjpeDuNnBZW50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pPgkx2p7bpzUvd/y0QKqig3ahxphe4kIYCiDTUiIFaRnCdB//a24tY206c+r7nONd
	 KNDWko0Wd/xQ2j8wBPpXsNNFf8VRbFKtp94fJDjouvNCWMQUKouXiJBtSzzkwCQb3M
	 psJ4gGxLizIqeU5/kUS5bma/Cr8MOoIfYs8i6g2T/WJx6plTyDTTUX0dZn8U7WBBVp
	 Gay4CxCD5wDgoChSafPUeZemEbEFRUS0nHGfskZ+7eriqjCXulHApxPzgUNCFG+MaO
	 7wrSTQEm+aAF0//lcx3KJz18HrLaCMy5e08kFc04VKFjchH+k7kYj3f1tj+WgJGEVX
	 UNA2SlT10vImQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:08 +0100
Subject: [PATCH v3 5/8] mm: cma: Export cma_alloc(), cma_release() and
 cma_get_name()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-5-24344812c707@kernel.org>
References: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1725; i=mripard@kernel.org;
 h=from:subject:message-id; bh=xA8iRNbldwAg/IWB0t2FyV0TtMeqN3qjpeDuNnBZW50=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtphd3Lnadr6or7GS8X2FF0azNTvqpdYKHQia9sNbn
 1359PLyjqksDMKcDLJiiixPZMJOL29fXOVgv/IHzBxWJpAhDFycAjCRM4GM9SGui34Wvzd8vOvY
 1bhMG4Y1lTqzb63qZ5eM/ZS3MmtbhNhrK69pM+T4JoXGMamGN7w5y1inYxh0fM3PnfsrF8r+j1u
 35B8Pi2sER1j147/7uzMV3/oU/lNY429dFsQf6FJZ337b6yAA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5375A180008
X-Stat-Signature: 44i8nzz6cn7xo1u9q5i1oxwnndymui4g
X-Rspam-User: 
X-HE-Tag: 1772532813-370321
X-HE-Meta: U2FsdGVkX1+TANIX5BKCg29l5KkQy/46ZZlGDj3usG0DKs2u+6jfyqHYJIJljK+/72SYspAYm0xMqmfvULswVMkXtBX8oxdhmgp0QG1wwiR77+uU4aZ35JvJoIBVUbYrYUf088ZeK7z+2zQCQHIAglihKfOf7+UsUe3jVFIhW0kOBZXn0G3CzUQM43GHkvVfuvra1syzxn5GZjN+mvNdPNZ9GCaSE+0RdJyfwcyXbfZSlsulk7qlrZPtIoqkxAnA500CLwSLyepLJQ/41stu3xPE+RCKwehKhVaNyguSQ47k0J9LPkgdWDZfkAAQ6+2cWBg/r52ma8No7TsM9pADv/esYe1Y7p1hH7a2yVE3QyXoA+KOe7l/Mr6GwsCukCJzd3cMlK1rmPv0Au48zgtmujTK95e6xHMYhNC/xfbnY6cxj1Sk+3XCBPWc7EsYeSgq68PUkN2XK2MSF83LoE4kWkm0WR4Sav4gnGJ3O7o6Nr1Qx54gOPq/frTM57BGovCm1pYor0voli1LcNMcsTL3N7Snhi2AqAH9uI3+irNqiwduJ2V1shjfOLsDqr0sZsRsj31b9APC7H6HQykrEzxHkX/nVbmab3MJ8tzvncXSb1iej6CTo3iATCc6i2WYDIKbnFX8ulMEBW96ZdH6pJNYx/yj9gJbSJTkQKJid4q0nCMWdi10n3u6qXr4DxZT5wAuMYhn2qi5QpPK0PkWvTioYN8AMTAnvKq/BeddPhyE95l5IXi8w/L3sjc7KivdZfffXsquD7cQKFWniliLBxj+w4u1yP0ad8yxhV+l3D52lJruPeX0cwsYYMMmPJQKCV5hCOcnO+jwmUrgFuS1T4YhmAib9/7atjjH9+MCmqsuFlsf5Fu1NjheQ40kEkMC3YLlwHolNpBerRHEvygAIJsJxsGe+g6E4/VsWgKcwbaQsdpVMFurFQ9WoEvSTJg1w/eHCxmpQ0THFVv+oQhsl2t
 Wlw1WfbF
 621KKrYU6OHJB6apOKKTuTf6tt+hNLbpjPfvvxZu0lFc1JL4wsB7uOmsclpGWObV3X/9iCWFiBriJ41Wo5Hoah5hXYU2ZJ02CQvrlkjmlcdtzSS6I+h82XYB57Uu8ARByjSGpx0AzI+80NnG8v0ch4pNkBEPwuLxEG/TQf4R/t881FNB6FhY30PNvFDQjlR0D5Pl6//6kyHXMBNi0TgV2ZrgIdFjHTrBVxGu813lMpW/M+edcWyrCoBo+papf/Yw3hdrv7I8GmUVUCbHVM0TSfwmnFG5/Zh3VRXTWZpl/9XnTXznfQjSFcmVf3aNW/EqnKj/D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
free, respectively, its CMA buffers, and cma_get_name() to get the name
of the heap instance it's going to create.

However, these functions are not exported. Since we want to turn the CMA
heap into a module, let's export them both.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 mm/cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..550effb9c4e01cc488b5744fe61d55a5b70a6d6c 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -50,10 +50,11 @@ unsigned long cma_get_size(const struct cma *cma)
 
 const char *cma_get_name(const struct cma *cma)
 {
 	return cma->name;
 }
+EXPORT_SYMBOL_GPL(cma_get_name);
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
 	if (align_order <= cma->order_per_bit)
@@ -949,10 +950,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	if (page)
 		set_pages_refcounted(page, count);
 
 	return page;
 }
+EXPORT_SYMBOL_GPL(cma_alloc);
 
 static struct cma_memrange *find_cma_memrange(struct cma *cma,
 		const struct page *pages, unsigned long count)
 {
 	struct cma_memrange *cmr = NULL;
@@ -1025,10 +1027,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(cma_release);
 
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count)
 {
 	struct cma_memrange *cmr;

-- 
2.53.0


