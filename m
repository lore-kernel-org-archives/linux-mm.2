Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29268C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C83C6B008C; Thu, 24 Sep 2026 06:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389F26B00AB; Thu, 24 Sep 2026 06:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E656B00AC; Thu, 24 Sep 2026 06:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E24E56B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:08:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6908112021F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:41 +0000 (UTC)
X-FDA: 85248231642.20.1F619E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AD0D6120009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7vVYIE0;
	spf=pass (imf29.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	b=A8IJhccbrMlNhEkrPamQ6HzyCQssUIjyzO3Jo9RvfGL14p2raIWxxkSP1djGQ4zTt/AFhv
	t99Q4k5gz1E3uN+z3oAF+imu9C5UOyTTVxtBmk3vFsMY/UNhhOuuQWYPLovgqnN50oOIMC
	FvxzA+cWhz+5mBS1G4UbBZdnyw9NNGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244519;
	b=ZjXKt1C8KLoT1nci47RB4UNS2899CmNdW2fc3Elcqkz1MsQdog+7C0c/BZGAxUd0Lt+TTn
	aQWveYpu9Q3Ckt0yNE0v/IfknuR5eghK79z7AjapmtsR1JoaZRZdv+5YtEEv+uYLNpZsKT
	obMxF67UHNjXHOlnVu/XGfK9DRn7kwQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7vVYIE0;
	spf=pass (imf29.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC8A2418D2;
	Thu, 24 Sep 2026 10:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AACF1F000FF;
	Thu, 24 Sep 2026 10:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244518;
	bh=wOq7lOU2FcK7bFNXejlGbOi1XU8BMJcPZcRxtw9e4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7vVYIE0aMAfRYhJEF3IrnQkTPB+l8URFB8a2ES5HlMFPDWYqoftWe2Ff8rVJSgHz
	 //Op1zX/iwMgv9mXBkckDouFTPX0yIsuZxqyC0hSZbgJNOHGHh/SORbTcQbJNWXXo2
	 nUcxq5smZ+bkK8UdPl+zQcHG5xIFmbrqMpdGAiQ26FV2D4kvBW8Su/Mij/C3EDF8gK
	 l4YYQMnmrMqIuikyKNc99VEKE2PCSbB7BLEPIu5WwybWevD7t2nNjyS/K4mLgpcVP/
	 /sv9QW2fUVc4LunoMvqqgAhjOq6/Ihho9u3wzSDnaqja06rEay4I3ZS+EXulKYaZK7
	 HA1XNHuabSvRw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
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
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 10/14] dma-buf: system_heap: Limit scatterlist entries to the buffer size
Date: Thu, 24 Sep 2026 15:35:25 +0530
Message-ID: <20260924100529.1398790-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD0D6120009
X-Stat-Signature: g58xh9yznt8s65oc61ez637ycwmy9oob
X-HE-Tag: 1790244519-579866
X-HE-Meta: U2FsdGVkX180jntGfWbnl3DmMrooqGkg2StsYPmOVE0RSYy9YrJ6W2BN7W2b0pMDF/heGKpMltWGFmCYPnfnOX6ripnOu/UPFokiyjRfEvLDfifrxeQzTcpom7I7ApjH1ACmxBb5v4uNvLERSLWWDvjqZ2++l9pL6AGq0/PYLoBpzE0/5E8SDF++3oXrA0L4qD6MnDZd8pa8zo0JU9Wn3OP+r8qs4D5G87FUR6Reza8E7jiaOhPYXJ9i3Uxd89FsZ3O04EoIL9YxYvPdf/UCh1xYrfhzdb4AlIhpdMjz81klKvP+BTQjXbBA2xNjXoBiMWxiBCw4dPOK/Ma/HvvLKz+8eUCZ43ZZ/HWWX6XJBQ67OcX/7II1oQnPvBrOG2xq5lsj+56NU4D5J2t10Qe97TEwoU4soMFt/Fmo0C9RF7kKe1m+VzdDA4Yk3PhHlIt3o8h1QOcpZWBxh3co5bF2AGHC06c19FDc1a/jOYvYaXgkwDjSmAFilo08G4GW/MWS5EyGjq+lRfoanpBY57td/bSwCd1tI1a+HQi4rC2LzVHiX256I4lf16esqASVPhKieYuoQqEpfwxXT+jmnpaUkMfJIyJTPvPXCna5qV0HlSMlqfnZO+qqiE0rrDN3Nws+wujQogKmYRQA5/joZPVW4oG4eurrLZ6vAcplZZGbg/zKxP4/f+kfgZS0UAmfTvXUuTEmTlKUMLFPXumBh2rSguHPkFQ8sfDfCl5qzm6lx6gKsxXyUPle7/4rb/I2U+squya3y8jiC5oyr08QzDVdDhcrKPgfbL8dTxDIyh9Mnlykij4LX+fAm+UpCBgAvfoItyABbpGTQESoF6Hkslkk9saQpHD/gvwNTOVV50xxD06itxftu2yGpneLQGW0dcd/QNU4oZsWKmmzivc2Abf7YkUw/i68NfxFlTPrv5w5DiqtjRWhJQgkfM6xRU20yuqkrHEDchKNxUIQfvdWVrL
 sRSNh+Z7
 aJk8wiLhfmbu7/EO0bQ74jg9QQSPsuAHJijwhKB/vY2VQHguXIgZpVcaor9J2JqGn4GOBqctxZRm0BYtyxtjeMO19E3aS627AxTm4yOm4WGgKPafJAUQzEXehutKb56/T9rQ+Pt6m/zBg5ykRvZOG+/JVedzgYdO6q0cbQ28jQGfQ4hyf0WrXM/BXN8vfgXHwgYHqCe25rmSAIfR+OJX+WZNCzkgXZVScf81o6usil+0q0NO3JRALMz7Ha2jREnufrRXUF3MEWQjw47sVKCsILu9bmR7nb0HcK/VxLwZQL74eE4G0LwuFNZ/BHjf/VJCR36w0x4ktj3hVdl/9k3n/PRGU4RBnBkFbqXG4txYlFCg1i4IM3hqUGMizXf5X+h0Z5DqdIO67Too4dxVgQaZaedwmRB1/dUsC+pqYEFFdzbEX0uIdqRzEnPhPr37aG4lELnsxFq4TDjvIQdAeHBRUDI76+vvtcGqdEdOcSVVNgoWup7dIzbruClodMrcw/GluC8KT96ZOPiNUsfK/YMHTwvhgBjWuZqUxnf0It/I2OEoT1Y9/7LTnSGzpAvbU5ZXipYkx9wdiZx2ReWE2kS7Pu+OC0A3LokmRuE0VdCQYPoA8Nj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


