Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1F4FEFB4F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2786B0098; Fri, 27 Feb 2026 08:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4325E6B009B; Fri, 27 Feb 2026 08:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F116B0098; Fri, 27 Feb 2026 08:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0B86B0098
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 292408C066
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:45 +0000 (UTC)
X-FDA: 84490304010.02.DA56E51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83889C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4LEoRTu;
	spf=pass (imf28.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPRQYmHrVvcJSbAxnJLz6xu1jGb2AmGEWR3nhNOgtpw=;
	b=nlHv/QdSRuqgPHVRReakvTrkdjnIziVKH1Nw9RYkcwkiBOSlSAm3hRRrTpCaD7/FKhpMKp
	pZ5KxqjRQhIP4unY4Yq/T20NGTIRUiTnmJxBvw8VluM24PjkZ9DUkFEcHBWsMpuCK5WJzO
	/24vgpfWZjPAJtcqDfmT3DiHIVXwh4M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4LEoRTu;
	spf=pass (imf28.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198623; a=rsa-sha256;
	cv=none;
	b=5SAVq/yULypFHS0eaPu2pDl22u3rwEQKd25hTFIq8lUvbNDgfx7TdbpAxTnmvlCNpnOTWj
	hKgGKeAn9FOXJg21S+E9I/eUuhxSPhFFvGVRbyjj85kdE5ENv6oS5tx7lQ6SLsa8ByK4GD
	MiBYCHUwb8FdhMjckGxxWJuFTmiOPjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B133F440A7;
	Fri, 27 Feb 2026 13:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B045C19423;
	Fri, 27 Feb 2026 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198622;
	bh=oNUPt44D7xewgXiELSrkzONvN2UIFpJB+B1908QRT5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B4LEoRTuHmJOdNmQe2bAIpTovkzz+vV6SAtOec89drMCy23iGzr9QuUQY90JsnRVD
	 CJdUJ0W1oXTKFOCST58+C6Y56A2ltlrbqlCTPWSlsipO1vvYzkozxDEJXOzh1o9R2z
	 /AY4Mq7O2Zam7wrDbiUhvWz750dLAJo+fONPrFFO2CMrcPSL7inQrR2l7BxOz4Ke/I
	 ybjiA4yI3xDfbKGteRchTz4I3SbHm+g0K+hUy4+GTxBholQEeXptVvlCCv9K7uwiwt
	 ylTfvfnI+QbMYWT26sOSWsAEGV2RcMgHgm1vgp+Mbd5T//NOwKdDU6EDr9q4Nh6Hp8
	 IQZK3YvE2AKBA==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:48 +0100
Subject: [PATCH v2 9/9] dma-buf: heaps: system: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-9-454aee7e06cc@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=mripard@kernel.org;
 h=from:subject:message-id; bh=oNUPt44D7xewgXiELSrkzONvN2UIFpJB+B1908QRT5k=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+0WkkzIaZ7AEu++epl1YJcfp6tA5eeDsQcO/e14P
 5PtauSkjqksDMKcDLJiiixPZMJOL29fXOVgv/IHzBxWJpAhDFycAjCRz88Y6wOci1V2slgKrp6p
 6hWkevoO57LE4/etK8+tNJYXzX/zb+GCrK/q/odu3diy8djjVHvNy4z1TrNqTjNKGR2+x/BUwb2
 9vNPvratzb9V1he5Z+TzTVUotd8rOuj1vU6uDgIeJisi7d58B
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83889C0006
X-Stat-Signature: y4eh1j3on3sxd1y8p6hs5gm5iosp1ace
X-Rspam-User: 
X-HE-Tag: 1772198623-362465
X-HE-Meta: U2FsdGVkX19fYKI9APepf8zwr8+0lNT4KrVvSjXo4rTT9w1WXRcwbcPU8Bo299gXuOzwrcphM/KaZPSLbt4bGI0xIpHV/5K26Js6GooOvvystBsLal74A/hdeMDEQo+PPc2FthyMBsMHeTMSO99M7iRNJPaMLUoUl36wOPhuN1fjqsZ6Mcdclim2RxQy0LXmMJ9rqDS1r+ZG92PK69KVEbPWB1nH5P9hTyvJ6uZZYaTYhWZOKKJ73jywkzIhfN0QXUnXH5toBYuFyZVirjxyHyML0GG8RZ6iqxDdOP3tfi+64g8ikQ1BUEd8Of5aO+MOeHvVzA4PKQUoLnTvb9gUgL5N9qIE6QMuPbLxHlVC5aIqDVsJV0g3zoZVQbqOcQSDYLLCV5DHjN99VYH2No92e4T9IjRsA9dBVNy57KTiFZRTibaC51ISEm6iErwkl3LEz7JcavcbzNa0p6HNnimBmniOXbMBJzHujYvHHvotShVezDHfru16NCaX0TdLCtKHd0wlOS2+mT9738ZX161gB/90JDp2sLSr0mWyD2a1bpp14WNXS0uPytdgPJKiWwCwwMfLh93pjluGhI2mJfSUhCYgWxEYFrL+OSP1e5tC1Zj/5ArEjTg4HxA4v4Do7XP8m0qAGSnkblaTHJsXFFUuTQBGTPCH5KKgf9WIQwyl7Vty4muT0F6R3zHr5y58EUmrO2zTM5IBX6CIzot6+zkTQzjr9EB8cGhxtP65bPIBUbBjVEhd1T2JsNoXh2lq2pCD3IQ9vlvSIzhIdvFKj22tt61EKG1LnWYnc1HjicEfdx++BjMvN7CbLdWiumhnQomOreg+nVcnlxJutkE2BOyepom+QoKAvQHakPKHVXIn/IW/+eNXXx2+lcBUnhy/iwKREuF2e0K03BEl2MJ9BIkYqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The system heap can be easily turned into a module by adding the usual
MODULE_* macros, importing the proper namespaces and changing the
Kconfig symbol to a tristate.

This heap won't be able to unload though, since we're missing a lot of
infrastructure to make it safe.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig       | 2 +-
 drivers/dma-buf/heaps/system_heap.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index aed0b9b4febf388376cfc41be9843980d010c4e8..e273fb18feca091ccd9b406e68f86c12efb339e9 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -1,7 +1,7 @@
 config DMABUF_HEAPS_SYSTEM
-	bool "DMA-BUF System Heap"
+	tristate "DMA-BUF System Heap"
 	depends on DMABUF_HEAPS
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index b3650d8fd6511a4a755612cfe3a9d9fee796f80e..1957403b0f2ae5e82ab39f5945dfe82808e93964 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -442,5 +442,10 @@ static int __init system_heap_create(void)
 		return PTR_ERR(sys_heap);
 
 	return 0;
 }
 module_init(system_heap_create);
+
+MODULE_DESCRIPTION("DMA-BUF System Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


