Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3B4EC049D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF4B6B00C0; Tue,  3 Mar 2026 05:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0B96B00C1; Tue,  3 Mar 2026 05:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED536B00C2; Tue,  3 Mar 2026 05:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5AC6B00C0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6B28B8D4A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:31 +0000 (UTC)
X-FDA: 84504339822.24.D0E4B22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D0A040008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhiXIqIF;
	spf=pass (imf27.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pkuGcBWjKYGnL15zvTI1bqoJdpIBzUVwGOccdbxQMI=;
	b=fREuGiGd7J8abpNPOWT8yHBp/JHFAIY0eim2Y4kfmCygwyWEwrwmqytko5r0X3CFoowPFX
	FMSaBX8KPW4IH8QpwIIoNy2aVmAlR6Yiw+LsdeLH6ScXdyRese5TA5j4D+e/jbM5SE6+Y+
	zdB4f4h0pdfDvZTA87qTt1qhPO75uVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532810; a=rsa-sha256;
	cv=none;
	b=mn9ohIHnIHLf222CYp9IPCMseePz2qWs7D87yfCKZa1oGRwTmggmJRTEySIWdoTmKCs1K7
	RhOSuskgiXnEZQeooyMCuneAYGWNpFJaAc2fcaxtm6VzdTcT6ow4DjDBMeSpaHuPnCMSK/
	7CR5/c4aoftGZHDXo27q+ZkanIApEPs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhiXIqIF;
	spf=pass (imf27.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9710A60123;
	Tue,  3 Mar 2026 10:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E906FC116C6;
	Tue,  3 Mar 2026 10:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532809;
	bh=0cHZ5LTDrjAloaUBF1Lu8YxebKzlQ2YWzvzsPNmbff4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GhiXIqIFH0pFdYOVF4v4vn3elAc684typ5RQw/1l4WLHgkKnANNAhTHgTa3ZCshI3
	 IrWaY8DZnVM0Oimi0CVwPTFymDhv2Yy4FSm4OiqnjTt6tanBc4J/pHsTGVGjtlhPkj
	 gnM2J+eS8+Ekvz4itIaa27OozlW4J+QHuGWCq1oRv+S/c1vI/k3uMlyGh6CSQLFtNI
	 LfHn5u2j7yXmci2q+10ex5iIsC4GlWch4cZ9SL/aK0jiLFQEv2ODRZgl/BP8XCsR8q
	 Oo7ncNQwHpA2Yqi0w5i2xVC8aU/v0Z7+pp2C25p48QE1sOZsJyhEn8FGVBD+4J8jw0
	 QAY9Syplot4RQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:07 +0100
Subject: [PATCH v3 4/8] dma: contiguous: Export dev_get_cma_area()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-4-24344812c707@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=mripard@kernel.org;
 h=from:subject:message-id; bh=0cHZ5LTDrjAloaUBF1Lu8YxebKzlQ2YWzvzsPNmbff4=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtpj+rwkN3X/RpsuSU2dZw8NGZodEu44ndV5bp/3o/
 35Koc+hYyoLgzAng6yYIssTmbDTy9sXVznYr/wBM4eVCWQIAxenAEzkpDxjw9e/Pz8anKhvkrF8
 sNnTxsdyWoBDzfXAqfzWaRYfNtt5fPuXZFtreMhjzyq+ULZqxaZ7jA0TT9p3q2TbaX26JehvL3n
 nmvPl+QkR19KKX7fc8uiSFT6342m2tU9zoP2FdxcjxXo3SAEA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: zpasu11iej8zmk5ifr17dqttpurwea8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D0A040008
X-Rspamd-Server: rspam12
X-HE-Tag: 1772532809-378155
X-HE-Meta: U2FsdGVkX1/vXILyOPhktCf3XUFeENYBL+s2mT8dTULrCzjLvpeWFeIfO8WgGTTUwn8ZkcRRFUqCYluTRu/IKZXFbLl2EI+0IEwlMCjvPQIGtm556NzK9oAYfSkLEVA9lJXLMOarerbkKQnZuZbBYnRoNOyVHG2MKGtGhsWuhEpaxGvWY7gr2CMPgo9MH0kZRJjTjkQ/tQWVymZ/GMXemn50IzxyMz6BO5om9cq6dOvFVCti6O2HnngqEQlT2O0yIlal9UN5oynxnu7tthxKCsywjFUYXXIVXBXQq/aYUNNn7BaMCRVVPpx4lje7BJER+exsMrpGTiGuBsnPkPwxKQQWkHNVTCx11fSiwwvW4QVMasOaFDw/d4AbtFEZqgWQG8RLQbLxdj1wPhGHnRICs2vS/+qmxPn4NkG7WsSVd9YOfryVMjiWN1C2P2NiCR5boEERodOHayg5IWZ0kUDp7UXSSSaEDZ6YeIg0kodzcsb3Q9vqtavioNNC5iB2zCFupmUh9Vcooqg90m5BOl+DxJ2N9UlS2QLF6/BU4nnJV9a1OL9Zsfgc4tzl2+K2n3jiN5J0J+t2I/+6eCLzwlkHUEBlOu9lloYFSjBsNgyQcVUNJ6rtmlSs72dEAreIccrzNGW0N6ZEVg2y6xRro8iDRipHdfqcE6f7Nf+79xrbU/JlwFRO1rsDIIt5IcgybYo+TXg6A47DnrNf3jPePcyIjZHjq6BV/sDVSXZCzLNVWcIycojvYqR3KhNKiwstEvefzcKvL/m0HHEzYPPfBVPvDH+vf2zjVJHWBQ1Ts9ylIPNxXbfDAAYUNb+NEoTR0UD2AbXvEq9fKTCIlAF/QOlxBGT09yAG6Ce+QnY21Ve1+gwVzIybRved4O2XOTs5HAgqWVNI/4llDu7YIQJ0/U+ROcKEhbD2IKR/ToPBpMmcOGneayfWC03EvpxCpQwB84X2eTDgO6RW2+M1lcHMXFU
 hPQA2TJR
 CGSkzekcUhXt1dkiLIpC9+HVHqlCw1AW4+T0G/0wCYTzhf874LKm+pEBylJvSHUJkRMrSUlyyQVZX779vnO8OQH7tFKqMmLxRT45KOrF3w6IIb/wfFpJUD8p+Sihue3wRDzQNY8x2GEScDxUeMruAgOfRTwhAd4lXGfvE9uLgOE5j5fRUCMRXqLTzsfvBzka2/tfQH3xDWisdFpV0nHNHkUL9sxYI3/ENRqTUUrEFsDuxsDLNQTPYiOEUchjNpQO2yTSS0r19+pVLvg3ghbIrN+wGiTXxSzVSZg6aCn5b5iFvihtqMR47++tSAtOEIhSDT1fWcbIqVIKY0pNyoG69JhkMV/Bprll1ExF+l4y+ZGiHyWOk5D91DExQLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses the dev_get_cma_area() function to retrieve
the default contiguous area.

Now that this function is no longer inlined, and since we want to turn
the CMA heap into a module, let's export it.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 kernel/dma/contiguous.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index a4279d800d4658bf1c33b9b1da100eee1367d42f..ad50512d71d3088a73e4b1ac02d6e6122374888e 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -106,10 +106,11 @@ struct cma *dev_get_cma_area(struct device *dev)
 	if (dev && dev->cma_area)
 		return dev->cma_area;
 
 	return dma_contiguous_default_area;
 }
+EXPORT_SYMBOL_GPL(dev_get_cma_area);
 
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;

-- 
2.53.0


