Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB413FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD416B0096; Wed, 25 Feb 2026 11:42:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5814C6B0098; Wed, 25 Feb 2026 11:42:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466F96B0099; Wed, 25 Feb 2026 11:42:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 336356B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC433C259A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:14 +0000 (UTC)
X-FDA: 84483546588.29.4344CFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BDCFC0012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gaWdSdqJ;
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037733; a=rsa-sha256;
	cv=none;
	b=EnxAKgCSUfatnx9wsR2ZpMduQVhkZtHt/BkpS3YWM4BDJFOLmrcSCcZLYLx4JgFjnS74rc
	QE6Z/FTDfNW7XmVeJ1upnF4XyFEG4UO7kcZ73q+CSzVqo546oQUXAWnKFd1iYrITxTP9w0
	YRAYGOHRoLACkMxZYuUmX6WqmEEnP00=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gaWdSdqJ;
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIhr3uHJlQefCPCcH2/aKU4ZRDZNHhdONE+tXJ7gqak=;
	b=SNYNJuvWLeXRZ77ndOd2LmPIs5u9SD6qcwVtJf4Lr7aP9blRsFb6CbmWkXuNQNTx/Olga4
	/L5nWRSDx4uHqe0cqTxQeftpwn403FvUuERCKxwraome3HA5VX7xWUecs5Ra6eXpIHMUg2
	ntRkVqKkx+sTrs3wJUlHaZE91MGUt48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3951A44540;
	Wed, 25 Feb 2026 16:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909BEC2BC87;
	Wed, 25 Feb 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037732;
	bh=5eRES9IJzrhq6zmZepgudykCny//SFXm37BLxrFr738=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gaWdSdqJyk2rfO6R2i/Rq4sZfKC56WS1WM40M314C2+MoUqCykXKONzIZmhjmX93J
	 A+uAsrfN1mLpl+PeVLbATaGnWena2lmfuRS9bevZN1n8GBXvtWxNX68KGx7XqJUXSj
	 kVPdOYauJvjgcRHZvyJp7m4nobJIz1i7KmEo3BBCda4nKwi0Txy5KB5966/jVKVV3C
	 pNGpsdPDFU/kbF+RG7FhZmFiu85dNOMRrGowNJU5+totaLK3gA1KjJo9Ikg/rA0eHx
	 451KMUgszIHvYsQoByint44EISSPFCrbWNXQs3e1Fu+2RUhYE9lYMvJcZ2XAaRrZ/Z
	 MZqdN5+gmhVEg==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:53 +0100
Subject: [PATCH 5/7] dma-buf: heaps: Export mem_accounting parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-5-2109225a090d@kernel.org>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
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
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1064; i=mripard@kernel.org;
 h=from:subject:message-id; bh=5eRES9IJzrhq6zmZepgudykCny//SFXm37BLxrFr738=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1QJa+s1ijMu9+XLnvVgTuiJkztL1Ez9dZDkl5cDWk
 uK4bEZ2x1QWBmFOBlkxRZYnMmGnl7cvrnKwX/kDZg4rE8gQBi5OAZhIsC9jw67djtzh+g/PW7+c
 7bqE8dPDGKW25vm1uY+33phvn1UoHTSLfwWr0ad4br1M7cmxDRrOjHW2j3pqNeyurbWr/6Sy6zj
 r29och4ufjLuCl1QyX7+l6Tb7rCHTsYlpSt+sIisF3lQdygMA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: 0BDCFC0012
X-Stat-Signature: xi1ffxz1a8x3rreqrwkictfubtx9afjg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772037732-815811
X-HE-Meta: U2FsdGVkX1/DpSvPMJO4iXtS1xSaiWxjKh28rHMrYxy0gLkhTavYUugFYA6rDgOivry/L1Qfmt+Ie5WuhwVoa6uaFsEKNLLpoWc7szJsyzBxjJw8tJkNJEn6JpEabZqZwBq60AhQnb5WPXKV29MCbuQsvltZM0RvvSlIV9HNW2qZvgKA343ybg1E2vue9YDz9XaIinlGwKpkjV3K2TjMMtS5VghVQvD0ArRZygnrY+VlsUPCQ1dmGce8sygK6k7/QWFWW7Qk8g/PNYidrajvzHHaVbCBWNtd9/absLXDpdo/MdqQv++2o4EUuyhr6nbEO36phn9bKI0BcRIrU6Y2YCJvRSueakzBWoUI2w0T+6xz55GHfmb4a9+LUhhxERxFhCqeZD+qnWEendZ/47b+X7F8AcyBJlyURQqKyUjBu6GRVNqqzuJKvaasVRZCORA8rwnFBWFSiyhTYm+8TYtH8myYnpGVTfzHTvdZug3BrfYR7qdMzIvGspQ/jarzyTcest6EwnEEw9fMfNtfo4r8M+9rppGUmuKHXPz8qiLMyJiTYt9O0jpAMfPEGuS9gHEOaRF6DbnHbc0JOfpna7RNS4LXoXE35RqozpMmqsNDjpLCKsG3liaTLzbQjOynHNs+RcF8Qorpq2R13HCpw2nt0aJ49u83qL7ICUyt3xWy+y2BLwM1NLYXdm9HasjsBfYHIyiZe19PulHq5EhMBpnyDyoza6VCRYa917jEs+w2WnV6dwhVQlk0MiReu9IY/MA93/fkGq8GWqLwXaObapr6WrfgVwZUPMQvMrMTyjwjX0bb2WWZFTDXXCG5tT/S7erYhzR1CJ13GYQmdiKn1hujv32mQHjpMhemn2yuKOBVbw1tlghIE5HhleoC/E6tfeNVGJZx2EKqpRW8cU9TY7FBohiBvU27k1Dl/iUJiA+icXSKcs3HKyFQi9ZdbMWQ0vZygWqO6ICuTokFThG35lx
 OGbctR+d
 23Ck0MiEblbMMhMKzRVT0+0CfkJALjrzJVxLdvdNicqySTWaPXvcGRPnGLWHgzDlkwmTJP1j50VFmOeguhcsjFtPhQt2Dv42465+YYSEe02YxWoMEia5BIflPLddmzRkQIX+WOp3fWPWdQz2e5s11c2kQG8ieLAfOJ9cl9VRep4EHVPH6TtgL+ZHQpKsO+AiHkU287AG7+o7bVwlrtOA4+N7/P5i0kISCKL/+mt67jax1bdOn/i2tBcIIWUfrmOSWPO5QU8dg9hK9HiZlw2QaWZ7CogZj4ruWuPTb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mem_accounting kernel parameter is used by heaps to know if they
should account allocations in their respective cgroup controllers.

Since we're going to allow heaps to compile as modules, we need to
export that variable.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/dma-heap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index ac5f8685a649496c0e1c6decbf263b63fa472d04..a76bf3f8b071a3d5bf39a8513f31e9e8aa16e02f 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -51,10 +51,11 @@ static DEFINE_XARRAY_ALLOC(dma_heap_minors);
 
 bool __read_mostly mem_accounting;
 module_param(mem_accounting, bool, 0444);
 MODULE_PARM_DESC(mem_accounting,
 		 "Enable cgroup-based memory accounting for dma-buf heap allocations (default=false).");
+EXPORT_SYMBOL_NS_GPL(mem_accounting, "DMA_BUF_HEAP");
 
 static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
 				 u32 fd_flags,
 				 u64 heap_flags)
 {

-- 
2.53.0


