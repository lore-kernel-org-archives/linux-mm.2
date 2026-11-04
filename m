Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41994606D831
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S/AMpaE0
Received: by kanga.kvack.org (Postfix)
	id 680346B05CB; Wed,  4 Nov 2026 11:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630E76B05CC; Wed,  4 Nov 2026 11:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB606B05CD; Wed,  4 Nov 2026 11:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8D76B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:49:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8070BA0725
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:41 +0000 (UTC)
X-FDA: 85398022962.16.C2E8CA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D042C4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/AMpaE0";
	spf=pass (imf12.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810979;
	b=A9y8ePJ60tOGdmL/IFU1kzPLGYP/zAWo5eRqjHOp89VtPK8TjETYaezVsUmQLyYEA2GZsm
	W4vSNeyEieOyTtmbPlAbAP/gkl0LnzP1a4kA7QjTxNdUE33WVdc+/6QFLUdDbquS5sEe3e
	r8G0kQy4QA/he7NVaP1+bbHQikF+mII=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/AMpaE0";
	spf=pass (imf12.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	b=CNvfbfe81MQalTmnxRsM5P3VNOYipW/f8rkrsCcSWNEmcMD3aqmjm/KbD+O0NctPka6l2y
	QV2Sndhrshv0p1dhUhIbrXcRt4vt+/2sQDEerHjxpo2XjpgZcBTdIYJlMd9vfnrrj1r5pW
	h6sAsYirzncbLRNaa+iPNAlcEEOtHWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68D3A60A9B;
	Wed,  4 Nov 2026 16:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582901F00A02;
	Wed,  4 Nov 2026 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810979;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/AMpaE00fvvNCHGl97WBk8zSr2Z+LGjVk4URN9z8aKZMRN5JAerN3vmWJlI5rxkx
	 qZqY02ZGMboQuXsqOOKwAeBf0IaIgR4HqZls5fR6h96A4T5Ch52OXvcemUeAl9V7de
	 zzcvqatJ0Qtz/NAghg0z9oZ5n4WFpDnlVmvGXKlDvLzPJruBt6w0goOl3/TJMAcSmK
	 n/QFxR4RJoYREDyKOE7PRo0pd1NFdYcJaT03hhcFDyDzeTdAJqBeZQ3EjiybtejP23
	 TW855K1qXgLsFcjIRFrt3vNSNC/8OB+imIeXz6VNmRT/mZg9x7E8shFo83Pk9mJSF1
	 3h37ZBLS/x1+g==
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
Subject: [PATCH v9 10/14] dma-buf: system_heap: Limit scatterlist entries to the buffer size
Date: Wed,  4 Nov 2026 22:15:51 +0530
Message-ID: <20261104164555.3555725-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3gqf5zeg5dk6qx8hr4isdjoqtz44uxt3
X-Rspamd-Queue-Id: D042C4000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793810979-898512
X-HE-Meta: U2FsdGVkX19RXXEFS+2d8YqgL/iyENdJQUWtg0nsFhGyOpaWlIoxYV0qjt16Qx39RxHpA23xddOoW9IY9y072Fjcjhlq5CuiQWO88vXli7dx+cgdd58TjBL+EaZTu5/CJHQLZ9CIWquSm/0VtJWHpwhxH7B1g1ib3/3tbJA5gyKjZdqKTVctyJnwBw1xU5PrqdXmGZ/Ts8E0FIa1g4aeXOcXpNPG8mAcsp1jgKnBX0/UxwT/hpy7hv5lBuQEGLaIb4oemeQI5RyfWP+bgqtx8AL7fx8FdFGPUacS6KkySH2Yc3nYbtVE7rDc+pLmsR2ZgBjYUHKMPfuqNgOE5RpQtR6uQS22l+mZSfHyrI4wb14igOS+VvxkNuZuFSLUhOOEet70iVkJWNRfMmTDYzKxAm6SmKTcB7IrCRSyLlIRSrV5lv5KtF/5/WzXMXtEXoMrFt/Xd0npvNsRPcYbJFCP0wlxtTv+mUO1S//bqTYMNAByC48ZMWfEJsbUCZeYcJPupgbbaWt2b7EEmBCjYcLJUQ0bjxMNGxIx/b+Hra6EHKDN3hZyH9vrcNh/kl2o9r6rlicnJRU9nZO9wGqtPg3eYefAUI50RYzuAEqtFf/2iqJ1RBFtUV7BUzIOynKGYqwTVOEKimtn/wjbp0QIroVHcYO0W7fkPnaKcAPmFoRpuyMutZYk5MQFHO57fZiM1L5ev+DU04WeTKiMZyYED+yH7XCHXkbDpC/zwOKFVkX0kLGIwf098l8A1+fsqIRN+N6qkLJ654hlG80p/s1mow2ox6hMnParN/MY8nndJnHOSpXVaWDN0tVMkzfPtSd8jvX77i31gptq0X+eFETxBxmTqIe7ix23KvN14Aj14w5yOESRPs2ucNVmgEkXUpMSkWTJg6yFWtIsm+mSoplMLGFMdDjgrVw+0wml2Q2KESU073AqJDMx3W+NqIVdDt2DQEhcXY0RJBkJ7TjvetLhmpF
 kNW/3HFI
 vR113jIqVQOFRSrLfLp4zaIZ9HtLz8OpUktck31WbxNEIPHu3tPt93t43q/4nNoQRBSJgrUyzbWnoXIPmc9K5kqUr3NX05hmB19RQLylzIjZm7PdPfzxIlu94rh43pfRqyYzllvK9MNR1Lyz2cpqMzhu3uDg+5YI/yI1aNXjEy7Yrm9qUlF3FjKw6xRCBOnlWsHs0wqvpiNveUL6HUlWeLpYh90/Ydm4fIcQ+W45zswDSMlQJwgU8r4uSARbT+2vvjJ76E6IDwx0tV6KUAjXtIuqZ2LXZZY57HBwhQ6hYH1rZWregr5sHV0NF4zFjDqEsTXo58uJlX+0KxzIR9ZVRMc14W7CDEr2jh5yQstZ+l6g9ZwH+E+q9MwsPri4mMLOVLfbokOOyFuYhGYF4KMN1ecijnzzZfKtoBtA+shbUoBMfvgO082+9qGPW96m7aESQLyc/tgsbHj3COwtx+9jyEWtYBLN0U0yve/v8Hg/Oj+I51vR8v0F9OdgSwk+mS++6rPWLUh9a213cHpqw2q6xKMkPTWOl3X/rtBBKtjb7LlHNTzS1YbHeAhbbYk9eEYV5rfMmyj8TeIxDWhUzHeN127MaBmDq2fVt+4ZgkcF/kIjVMTo=
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


