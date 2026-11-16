Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAB6606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WvMiCb3a
Received: by kanga.kvack.org (Postfix)
	id 67C316B05C3; Mon, 16 Nov 2026 04:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653AA6B05C5; Mon, 16 Nov 2026 04:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FC26B05C3; Mon, 16 Nov 2026 04:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBB16B05C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:15:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D9D414089F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:15:01 +0000 (UTC)
X-FDA: 85440422802.07.8F103C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D1808A000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvMiCb3a;
	spf=pass (imf25.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	b=uN8F2HWva4YcYklzTz6DMKk1Q/Zsu8P16eB3cHXlM3y9Q4USualmYyM1QvId8gjEO989Hr
	96KNU2gfpwhfr4ObZlcWVgkA0dZafexm0xON4N57BvIeleIwpFbmZe84Kf9+AyOad9WIbK
	Wam2osuUVNVimbMdL7q4slzja62SZwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820500;
	b=wqXgdBvbis5lOaRM2G454nljADrp4ckQxqylsUGYdmn1z2BuWuEBXGK8HHz1rDHfNiD8sy
	qKCNhXUou1pMqfbDMbRPJ+sDGzrdSJz+iB4TW7LL+ewvWndiFfW6hP+iaaHtntUtTiMdLY
	1n1esOkP/T3lggUW1T13nQW9paYf+T4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvMiCb3a;
	spf=pass (imf25.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DB596144F;
	Mon, 16 Nov 2026 09:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C91F000C4;
	Mon, 16 Nov 2026 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820499;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvMiCb3a3ulqjdaB22nmgkIQke7QT4O0OvCfYht7wzXALcr4iWzzaR+ZJpkaPOXT1
	 g6Ml89mj4k9Q9E1ps2p9lnFMX/Gj8Zq8+jF/DkQFCOSXHPj+pizSh2BDErS9fpC7SO
	 64dxg2HPIYj2YCyf1j3nim34uk+hl8po4RukSk3hMt60OeXUMp6VWkBKyR864CGpMJ
	 Z5QNDRZshQDNdOjARyuMuuV+7FJMkxEWDxnPO/FtFXKGQ+oYNvDsddHMWQtPlKIJuy
	 gvIvOgY+2iz+x+q4w2x46z11Wt0+/2ncRaQ1Gy6GYLrbtbhWkTG2dgzC8EboiYpYge
	 85eluwdssrZnQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v10 10/13] dma-buf: system_heap: Limit scatterlist entries to the buffer size
Date: Mon, 16 Nov 2026 14:41:33 +0530
Message-ID: <20261116091137.94252-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uoy5qtiatcu8ogswppszrg34m6sddkq6
X-Rspamd-Queue-Id: D1808A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820499-668408
X-HE-Meta: U2FsdGVkX196NIdSP7IvT2czyynpTxQw0F48Rpq14vfN/MBLsZEdfZGaBQxd7ZP1vOIk/JH0nr6lvTbKQZEnTeqxVz340Og/pCV30HsIojFpTMMblew+xgKRx/KkSApKa1xwmNA4us6I/f3CuJOI9jRPj7HjL9hiYb690qdeq/plt+ZUDN3G6aET2WT8JyJzSBiwPu2pT6PChExuYCSnOt3d/2kmWzU5Y1LVBlAOGBTyAvLpA6bwuqrgUeJNTyW3eATVjb79PEIXIhfh7uXPmnKZ2HUcLSGIi11VRoHp8IrbQ2ox5RhMZO0pm+G8fmBYTcyA76UvzfpF2lFOPpZYsRmIWLZiIDQOe9lOCaqWmG3/fRxxHoyg/+MWmKNo+qMVj7Jv/0tITlRCnKfSt7vV4CGBAXgugl3rwknon6TEEsUqlr9ceF9KDbrO+gvj7x/9SVyFcyXRaSYT8xy8RQF9IIx4fY42X3X/t+8pnZQjFQCk8IYzyFYJHDsmp9D8qxxo/NnVm25VrO3KGunkKUG89vIri1VjVYPH0G+MSluFcipmvNA95EslpMCD42MXiVfHJcpv7gG5zJRnQ9jedCm0ivaSFNamDchfrUjRkit/HHoLc0LZxI6qtHOqTfOxxDVN7fVNakXiUT4UJwPUxt/TKms3ijeL3BiSk9eP+wn9F1VcBESVi/vxJHDMAdflSpgYeNiXzohI9uHDAszWzDr2yMHYztb83tGsTSGzDP/2/A15XdXHy6eQQcjqGAiZoM8c/1MctPzdQs+IZDf1Q95xq4m7o9Xu6Z5mreLwZ+Wv1SyFvgG0uCxdPmJ8PwpngHoIeJkN9qtDzPHNXEv0eCzXomKZw/mlBOd1darnlanVRhKqa6vYjZ5wbqzx8uzYg9xAyj7cOq1J4Dk9lUQNdjfYOVi65IIDpAbQfkbcde54kC27zJgYHGnfKP3efdL7HYp69QL4x7pM8LrSUH8zxO4
 GwepnV9S
 A+2wTp0+RharGVA7997TEhPqzFkf0LuW66wHHh/eo5xcKaZuH9qOVdmhmod4xrUmd8VuV1NcuX8jtavpy5NkI8hXUOuPhw9scjgcwuM2pOsANmFSqvYOHLOoNn271eavPnTz9KXywtlLAaCL7lFXlCdncapLek1yC3OrovN4Z54gnnPmZaUVyOXjxkqmv8XYmVyu1qaqsWPiEYJDtQVHHJ6o1PsD+ES11DQWBI25rjfToyNVXUSzHo6YVlSZPSq5FSM9dbMmBx+FrKKm1UnxNsX9E7968XYuQOQq/sg5+pjZLlWyu1MnQPcCFrfOXXvV25Mt8iGrCavNUk1E9HL7O0qv206LVvj7uEzShyGb2XXTKkIkee1+sBzLsORRuzR23d9JIel3705wFm3Ggkt+PsnDtyN76qrhTHsEG3TFjAeleHKzWck5b/iF3vD5MfTBZLazoefqBc2iwpGf7jvLo9PSGk1ZTdIG/R7qs7YgnYP7mfklbcFspKgYxH9cJl0TtmDM6uh2YhzI/D5ok14jboHq1HO0dSA0FgEY6lQ+dxPYK7+2MpvwU4nDot+mlhXaWSfXtbHhFZSHGD6H7hEa75EMJgxKnTVIj6oiXNvvfpLq8jgq6TRbDH0IQpf3j3d6s7VDTLqIBpfJZKOPY0FYmYyTG37WbkCEhWuWyp++EBkFFJl6ZBtDpJ36Olk4qy0/wMVzA+8zRATo9qxJxW3406zwpIOYxIh6ipdGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The system heap currently allocates each backing page no larger than the
remaining dma-buf length. It can therefore use the complete
compound-page size for every scatterlist entry while keeping the total
length equal to the buffer size.

Shared backing allocations may need to be rounded up to an architecture
shared granule size. A backing allocation can then be larger than the
remaining buffer length. Describing the complete allocation in the
scatterlist would incorrectly expose the rounded tail to scatterlist
consumers as part of the dma-buf.

Track the remaining buffer length while constructing the scatterlist and
limit each entry to the smaller of the compound-page size and the
remaining length. The complete backing allocation remains owned by the
heap and is still released normally.

This does not change behavior with the current allocation policy, but
prepares the heap for shared-granule-sized backing allocations.

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: Brian Starkey <Brian.Starkey@arm.com>
Cc: John Stultz <jstultz@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..b5b8cdf65f23 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -406,6 +406,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	unsigned long size_remaining = len;
+	unsigned long sg_remaining = len;
 	unsigned int max_order = orders[0];
 	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
 	bool cc_shared = priv->cc_shared;
@@ -454,7 +455,11 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 
 	sg = table->sgl;
 	list_for_each_entry_safe(page, tmp_page, &pages, lru) {
-		sg_set_page(sg, page, page_size(page), 0);
+		unsigned long sg_len;
+
+		sg_len = min_t(unsigned long, page_size(page), sg_remaining);
+		sg_set_page(sg, page, sg_len, 0);
+		sg_remaining -= sg_len;
 		sg = sg_next(sg);
 		list_del(&page->lru);
 	}
-- 
2.43.0


