Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196A0FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA8C6B0093; Fri, 27 Feb 2026 08:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4A16B0095; Fri, 27 Feb 2026 08:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676D56B0096; Fri, 27 Feb 2026 08:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED5F6B0093
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 114A91B7AD4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:38 +0000 (UTC)
X-FDA: 84490303716.14.4F729C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 475AC180003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzPAG66Y;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=demZBJYj7DpqU7Do19hw1iqOs4i53pHV3tjU4+MxeeU=;
	b=KfZRNwNqo9BK2zMeVIRpFiDa3DBlvR0MgSvnHMfM95C//Kw8ZIVaQMTW3wSgQQZeQJ/ozp
	m0qkbbYww3T3vWRYg7EjygnSMw3j8iNoMiG+5rkh+9na+z/fskvCJAeajcidlyMRP5pLN7
	JCnb8qh8y47OyOObcUj61FL2ZRd/NX0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzPAG66Y;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198615; a=rsa-sha256;
	cv=none;
	b=KYgHHmXf3PShesj/xWKQTvPN4OWg+3i/R7Hszz3Mpazmjsa4T0GqdUY/zJ3wK3j8+5nJ90
	gFVPCkw8YBcv3ABR8KOXjgMxC6mDSpROFIApcCU0Zqu0LlwcG45ucDQKOgZB/ZG3aD/QER
	jaqety5MmZGMmPxNby1ivzpXOgVPIpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F9BB44468;
	Fri, 27 Feb 2026 13:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F08C116C6;
	Fri, 27 Feb 2026 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198614;
	bh=DVrZa0opFACOmunPNX4g6dx/xvzbq4g8Ca2Z3xTFR0o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VzPAG66Yq1LbChnheWalbgxhOhB2UyDr91D0n07b9ONxD2FRP83YtjXiyOJSCUjoQ
	 z6THRn9HOSPfUmJL50h5oZWcDGSMsVYkhDpuYw5f5OoH9nUBbQ26ViRJriYWa1nDNl
	 LOLQTj9GO7fU6h4gSTxtpmVrSDGxxxwYmOVOg64YiyZJF6/QVDlfvIrIUzDxOsc9UO
	 1QrCsl/Nw/7OhTUnkIcLx92ZvAkn159yrtFx2Sh8CInV7LYXoApmC6CFTE3vZXCshU
	 kUQQMo4tItRZVDObIp4SV9DuVA23SOifYSkP0b84RKR+6St8MY3x1nwQFF61Y+cU4N
	 ARGN/6wMZY7yg==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:45 +0100
Subject: [PATCH v2 6/9] mm: cma: Export cma_get_name
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-6-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=909; i=mripard@kernel.org;
 h=from:subject:message-id; bh=DVrZa0opFACOmunPNX4g6dx/xvzbq4g8Ca2Z3xTFR0o=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+1yVxR4r8SsqfG4YUbymZtxh5QTV5x3FZ5eq2ZdN
 f3spD9cHVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAit9cxNhz99LzjYaOKvtgn
 BfFNfaG/c/jiF8RMjZm0aoP+jrdPo/xu/9/+5un+I8yPNUw9DA4aMjI2vKzz6js8Z9JFB4ksrin
 fJ1neaHy1ZalfqKXhk42yS4qCg2Lm3RPPOvSgeOn+qZ5ZWpaeAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: t8msp9yut53tkzj9qpdznezb9cxeegms
X-Rspam-User: 
X-Rspamd-Queue-Id: 475AC180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1772198615-524352
X-HE-Meta: U2FsdGVkX18t62Gb03uj5OpAjXJ+M2X4Dwh2G2Vnn4H98j1MR/C6MzptsHWWPnRs3UdG63A+zvndgZ6j0dQh36mTeDuF5GlJKzn7WkwOX5sYsjI6Biv2XCLT0ZHGQhDsbNMwpp0ngM6B9lnVqLD8fTR4jQyDtwxZHloBU2fCFOnrMEfxJpmNF15pnTYD4UNM94bA98ZPyJQYqg++hJn3wAYpysjhtRqiOPR2rEGbUQmAB+rJMEonaml4LiwPSGO9xVGQAFdRjOyqQICHSMG9C5wBt2IsgN5g+AAm3PxDhct4YNrQGROKnts12nVZgD7FkAN+wKE/ilAJ/th8zoodYsveHnpKzyvYj4e/7eGNnvtEsjS8jEdQvufQQSSLrhPCdiZWwVE+RdMeZWmZBiRLhZAntF4UTrUpXnI4D/Go49Dv/PvBmU1GF4gjupEC7SBUNJY1a2Cs2iav4/WH3xMorYsmsxrKfe5OG6CUze/ndD0B+soNyCa6hWwX0Was+Zxk6CfcuVmau8xk3y/1laYuUxtoCKXuuxaxc05cNwAssU04a14uLwyIBsirDTsFwoa2nRVxf5DR2C6H2Ui4fBSspq8qCHd0d2cvF5lrHQBGuGEo6cfqJXziVC2zxCwyZYMyeA9hag0l8q8/Yjjil6rPaxGKPtKu45Kbcg6RqP2RE14OQgCYDqYG+Hn2rxIHjiVcSECyhxPR/VNoWfRJSnVLN6fdL26e4nMSzQ1vXdkqUJQhO5BXLqw1ZZbUm9BSO3Sb4PJN88suzMZq7qyxh08L7QcfZTmrz+Adgpx6i8T7AiiVMxjkVbaPKoxg1LrFwrgGkd8Bf88UMMEV6zjL4103ejKtDRrC0GbQPxKqZ5TW9hAXgaNDE4zZWEhqFmwhXy5NxTAqnStJRa1Rv3+614wRrxZarz1AOZ2wi9a+UWzYT4nXwA5jvapmehJ2VjzLdcXYiieDoK3L6WPV6PMg5cv
 +KCt1eGS
 b2DiEGGwbghO4BPRZ3QSUFvKm6zCIIPLGU/RZoBIcjxF+IrQXKLuZUMytuEm8RcuZ9fp8dZ/bFppjfV2LsxI+na6kF2CI/w1ituYh+YU1oZ065MD6t2pKfjBZHLSX3pa12vj4VBZihmIAZJDDw4IAT+KjerOIftKYWaNsNyiiq4zpcI3AEwilK06U0L9U2ZavdoGy4dN9KkdCp+1yHZVQorRhxK1ph8WDcETSCfd3HmE/HnahNI9Scd66OHMPNyRz1NHwHzBhQHBueOb+SNXDN+ODWCU6a0u5nWdYY2bdjqyOV5Yq7Vh0E8ifSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses the cma_get_name() function to get the name of
the heap instance it's going to create.

However, this function is not exported. Since we want to turn the CMA
heap into a module, let's export it.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 mm/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/cma.c b/mm/cma.c
index be142b473f3bd41b9c7d8ba4397f018f6993d962..550effb9c4e01cc488b5744fe61d55a5b70a6d6c 100644
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

-- 
2.53.0


