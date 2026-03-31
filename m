Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2B51061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7AB6B009F; Tue, 31 Mar 2026 06:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE896B00A0; Tue, 31 Mar 2026 06:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB956B00A1; Tue, 31 Mar 2026 06:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 201276B009F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB5E1160BF6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:41 +0000 (UTC)
X-FDA: 84605913882.15.92F3042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09D4520013
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T4btGymv;
	spf=pass (imf03.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T4btGymv;
	spf=pass (imf03.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951240; a=rsa-sha256;
	cv=none;
	b=agetash2fX0tgb8cuf9cXCzEIFq1DSJDL4MMlbvwJndDz2UT+nZ1e4OHR3PoyrPn+5xpZX
	Ad+zCnEHBUqKzh0bp5phLGbtuVeIQ9plCOYZOajktf1EUktr11FSdHJMPGLTjxs5J2x/qo
	OLpQ8ljrWkZ8QmF6UR/gmE3j3k2jkbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59noAXpH6473ChzVPWVCaW5/Ounf9VZcy2bUBgpx5Js=;
	b=b6P5tRcsfT49plfZZaGn2wejx+9cvZJ8+PqV+BgYDFZ01D9pKmTChqYTxUGQvKwkNgk+xx
	fbZVxW4PD7wSJAsJKocdNOx39637UGNzs6x53enutUoeF2f4wdoCw8MaXXgaPKD5YFBhlE
	pHWc59csaD5y7gMrYrwYkyUQmd96e9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21943405B6;
	Tue, 31 Mar 2026 10:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0542C19423;
	Tue, 31 Mar 2026 10:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951239;
	bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=T4btGymvet3fwK87izBY1umkLJypnus3myzupVvCPOwlMa9dLMbqmG/kq9UplVDxP
	 1F0ebNEQo5/XnSIn250vpq3AIyMIkzP1bRg0vwAVeblCzSIQBJ55rS1XvOPQ1XVMWO
	 //jU/RL+d6DdIhMhL8T3UUgHaFjHlHcCkkLBCarvJP7dWPu4bPQnDWKKCw2c19AaVP
	 +pSXNyJMPbPQkFzQMs9IOr5upt0oM5SNGtIC4JCdcRIiKZHMYZUBDSnDdSGXdkBd8M
	 jbUPlt5tRo0Bsp7Bwng3BJIzTBB5RTZVVDIOiem2eYS+2pKTJPGc1tZkGkSFZac5ac
	 TUdQuER1obGlA==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:15 +0200
Subject: [PATCH v4 6/8] dma-buf: heaps: Export mem_accounting parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-6-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114; i=mripard@kernel.org;
 h=from:subject:message-id; bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZxtyeG59tObuKquHuc8qry5fYc3JV8d8JJWvsO395
 6xnHT9/dUxlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJTJnB2PAstjN7VnvEugXN
 jXdyvD68/7X30jTHKQde6hy+yPic3ZBpmoDUpoh9pUmPH/sWZgQ3KTNWMtZyRJ0VXhId8Xup0ZL
 Tsu2LznCl3L19d4fYP0bTu8/6N8Svu32vidc8xOGjRmS1lqgpAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09D4520013
X-Stat-Signature: biw8djf315bd7br18c73hw81bzdceniu
X-Rspam-User: 
X-HE-Tag: 1774951239-898690
X-HE-Meta: U2FsdGVkX1/qk0Yd0yzDxSMwz0R9ZBh9XJbSrZCS8+3MBDCZhGyNfLin2geGTaTkegmLpVMUM90bCrsSmmhAXe7jMj7HWj4arrfNzKh4YAlwFp4I5OazYF2tVbDbp5XCGQaAB7RP8mTh8/Z/tchHaL14Izr87OBdlN/m69E4BD0Q1mb7z+jg/OImNcqBidnJ2cMDWn4ayZtOxck4RMe8dlCWeWuJLfwf3df1NUUhsO4mr0ZZidhsNhK0cv89tAabxyZSmtSdAvvGHh4ZD4AXUj4mbl3EQKl4mWzLu2N0MVCyw1y9Ia7JDFO+/PBpMYdGURn6BU7t/28bl0iAGX6vi4GKNK8JNRj69IyMQsRuXAqhmb0k/PkcFFgrqhyXSCfOkKTQydM/6PChK2kKQbGHl3Q5Hk9z+conD5tXsYvU8IL7N8Q0JrFUAG5PK9Cn+CMmoui4uzP7z+xJJsko8oYhIV60YcZMKEPocRZM8rWI7Tcx2pdF/xNT6Q8Mu//QmBr0rG1Abegiwi09bcDvM594cwHuJqYrn1773Oe8Pq6FJVzF72dlfQ5Ym+L2zFJbonEWEro/d09pUW+xue8egFiIGPS9BQ8PxCy8Ts+Yi6IR+oJsxFGcgHENd+96P/SkW9n/bE4XAecW2eYdMxKyjDaRbIe7D54W2fQX6l3cGciM84+oM3Ys81p3E8CZNf1UjjkR6OBUlOgba1N91ZR/kVgeLQ8ol04EGK+VQSTxi8Oxh+HdIISApVdH5afTJbDyhDjAKXj8tjoy6PNysC9i5ZiRDuti1ZKkb9Vm0WDvdls2sNwlxbE+44605ckradxsB0Do+8R9N/8vvVPB7QbiNSMcNFZvKovrcPmtqQLwOF2wnE4vHo96Jlrw8+a1wEcQ8u4piy8YYNsybItnTQI6cZ97DfpsYygz6PtJcLtPPwBIPPp6nPZuvv1dfSLsSDvhq6UOhH6qP4SiMuIEVjZ43cG
 i+477lut
 aKbdBBLrD+nuiyYO+p/sCBPGceuACEaf5Cnze+f18QIN3FN0KD141DJ3fbCMUaE4Ohp8rDc8P+wpS2tyqZplpZwgAJm924TQq8r0xnZIkqD46C8EMnrWJxwgcGjblh9OwDS38oHMufLHAog4wswh80y9xMB5pFpQSgN2ciTXSq08G6k+0gNFhBDkyYrQaSXKTchEfcoLR9tPheAU81oP9nW8/wy5MUOsoSVubDw2r2VuA4yzOI1ftD5jX4IRp87lh13T/4Vaj0D9rutRgVEf20z/tj8lkon/YkKtSVLskVTKJwr1sXXCbAzXfPuzYDFwmZl2l
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

Reviewed-by: T.J. Mercier <tjmercier@google.com>
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


