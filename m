Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11A8E67A9B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497326B00C3; Tue,  3 Mar 2026 05:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440F96B00C4; Tue,  3 Mar 2026 05:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3263C6B00C7; Tue,  3 Mar 2026 05:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5EF6B00C3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF6541603F9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:40 +0000 (UTC)
X-FDA: 84504340200.16.849A4E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 05D2A1A0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ig/bQomu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8g7JbldFQCfCJPV8shJXXeHq3RIT644jJrFb8sBqRQ=;
	b=VhilQ5+hNoRJYoiA/pjNB7qiaxKXrJSmR9Mb0rGatIng6/HAIpc6BHEd42G3C8+oPG+ZK0
	cS+eqzw5FGWoJ0CAklTBUtFEd0Gdrrgpb2UmgMM86/o2mn3Q4LRNIgzPS49xdPOrwFm0E2
	soXvtBhZXgUdLHoh7Ft7/4A+jO/cZj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532819; a=rsa-sha256;
	cv=none;
	b=q4klOTgsDr/seHRdGVXzjQ9DCGzW19LEskG283zhM5yeNpO61epZ0meBHJTZiJE7kBQhYf
	vTA1NcbMr7qau4/9RiUwgL+MjzmTvckaOSoQplvGO87OFTms5oQZRyY2vold15yJeYjmSc
	cJfH5phVjBcmwbXHx9697XOlM2TVcQI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ig/bQomu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CD5C446C7;
	Tue,  3 Mar 2026 10:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FCFC2BC87;
	Tue,  3 Mar 2026 10:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532818;
	bh=lO+1PMKRSkJNghp2Ly48vsH4KqRxHWKQohidvl/pe2Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ig/bQomueXUc216uzemyo2U7Bbfzhcnc5nCEskK/mHG1BNSkp3GNVKQcUoQF5QbIs
	 3Ql14c7EzyAwIOLpNgE4RVLoyqF/JkOXcKr/QFwizysU/w7EMn4z9bPzaPwAzstxwA
	 qMrhWoIKGCrBkZJD+FuOR1K3Y02+jGyn13qfMo5Xb2VgJnvXinZWmgj4b++CO37Pgh
	 yo548YffVMv7oJbhtPYd/f+5y5R8sQgYxKJtoIuANg+MX9pwblSdpNvzWQ3qUhezm3
	 9yu90bIGAySB/Mh5tSVxPLc+Lt5oM+5mpj/Opk08gXnc1NdLEqAbSjMbSCRoX8FJ1R
	 TwqT6cZiYZ5oA==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:10 +0100
Subject: [PATCH v3 7/8] dma-buf: heaps: cma: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-7-24344812c707@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1869; i=mripard@kernel.org;
 h=from:subject:message-id; bh=lO+1PMKRSkJNghp2Ly48vsH4KqRxHWKQohidvl/pe2Y=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtphp/tk9K/m380aGhrutlZoh089yhxn5CWXlbGD3E
 ntoFVfbMZWFQZiTQVZMkeWJTNjp5e2LqxzsV/6AmcPKBDKEgYtTACZyYCpjw96X696qrNmY0KzK
 lFh940Fc/q33m61bV6u/3VdYf+pliXaje4peib7Al+5/W58s2c2VyVhn8nfape47nK3J9Qv+sqe
 qN1urnd+w8b5he5eljsLOoJMfZbUsXh+WY/u3tvRlQu/97fsB
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05D2A1A0002
X-Stat-Signature: 81engkcu4kmwfqt34us6x68m8p6aqmwa
X-Rspam-User: 
X-HE-Tag: 1772532818-611369
X-HE-Meta: U2FsdGVkX192KAKq2tNqcPC7b26RY2MYS9r2OB7m3bvcxVYsIl+yhgnQldRaQztRnG1QPX+Df22FT/u+M8UOKG3C6sUxai4pZMx4ziiSIBMHM9imAfkAc1Kkkjcvg6ZXub9gxNPgRi/+yrbNNs00hxX239LdJ89pnZ0wMVqIVbNTlKVnl4RMgtf9czWQlRzl62V4xprtvZOGQ43SS2Pw8lze4doC2czcjuswxXBEjOvrkjE3BBp48raNr2kTSHWembwudIADPkxU6+QKD160twME6AKfVronH2nb8d+EFFEEhRoqM8leDXCPnotKr9njK9it11JKXuoXon2WZrKRe5YHzXrfsN2/lhVXqbBOlBNAwycMTFW43Y0R1nHhjG2CE5b1gh7iIYhrmKpVfYV8Gz7y3Cp6rXGMvRitqOvnZNWoUwP1jbBqboJgL4zyBCa1AZP39yLkgBht0I8TCassUDnjliMpu3DSrPfqIGq9IUCr0wPaB6/Cxi/s2MNNOmbLRave8pEjDzRv300I0eifEjArhCx6YtKNz613NWo6ZMEtowFreogj7pkdyWiU4ya5fTijezx8atFA9T/+tTFiqWbPvWvu+d6OdSc2JPUbsYx+7IQi0hsm5ij1qblW4Y42lFCjJyTDmYudKdNZekYCuhM7TThRP701BfJPTjUvCQ3eqWvIeDdwQTX1Wwh/CzbP5PEZwt3I4f0+Cuv0qRxKc3fHWtL1LVfrCbTpjRZNP6I0YOo5/gBxaCWb5+XhB+tw6iEGhDzEQbLb2WNY5pUnPaQo6r2aTg5mTDzeFTA8EB2WoMDb290s1g/eZBvX9iQVlmZTeSLXKSS+aechjt76wIH3AMAhS8UX9FVkzKHP686w9UHehUOjMBCcPUxZSpoUxm6go7uxKFeavLOK1c3gOkxm4J2VxX1ENRpDHp4IxnDYS001iE+RdCKOzodewJDfNzNFE00f0X7m5tp9o+e
 E2bidm5z
 atmmzVT2e0CwLbxVE/I4oaL+5Imof6/4vPIPraBj0T5wMmWW/9kIA2MXr/K0pETIT/mN7nVYcKA/81YcAWoYZC+3tYAeiqPMkLDBDHPVckAo+y7VAqR84oBB1BQiVN0VVPGwJyIX5650nH6uf3TyxQN5RXRVrP3mqlPRp6E/VmLrW8eCksul+tnvRgJdg38eORIt2HijEQpOLBVXthrLyIY3ESJm1YVGflLj6wDI8C84Rtu9m+AQQmRnBV2KNC7twtp1JZC56bnZYTvD1/Bu8VAJJlG5NJdHLbei3UqcRDOBzKjn852lXhH4mXPe/PiQTen08XqggUYCGSNmP6c4sFHChYOq4LWOqK6exruV1b8lx2iheVo+/jHGwAKjyJb6u30Uj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the symbols used by the CMA heap are exported, turning the
CMA heap into a module becomes pretty easy: we just need to add the
usual MODULE_* macros, import the proper namespaces and change the
Kconfig symbol to a tristate.

This heap won't be able to unload though, since we're missing a lot of
infrastructure to make it safe.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig    | 2 +-
 drivers/dma-buf/heaps/cma_heap.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index a5eef06c422644e8aadaf5aff2bd9a33c49c1ba3..aed0b9b4febf388376cfc41be9843980d010c4e8 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -4,11 +4,11 @@ config DMABUF_HEAPS_SYSTEM
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
 config DMABUF_HEAPS_CMA
-	bool "DMA-BUF CMA Heap"
+	tristate "DMA-BUF CMA Heap"
 	depends on DMABUF_HEAPS && DMA_CMA
 	help
 	  Choose this option to enable dma-buf CMA heap. This heap is backed
 	  by the Contiguous Memory Allocator (CMA). If your system has these
 	  regions, you should say Y here.
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index f8a3d87f3ccee9630383ba28502eb40b10671cc2..7216a14262b04bb6130ddf26b7d009f7d15b03fd 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -422,5 +422,8 @@ static int __init add_cma_heaps(void)
 
 	return 0;
 }
 module_init(add_cma_heaps);
 MODULE_DESCRIPTION("DMA-BUF CMA Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


