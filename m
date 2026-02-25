Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2698FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455326B0098; Wed, 25 Feb 2026 11:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429606B0099; Wed, 25 Feb 2026 11:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2526B009B; Wed, 25 Feb 2026 11:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17A846B0098
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D54C98C1C7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:17 +0000 (UTC)
X-FDA: 84483546714.09.19F6D15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E71B0120010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJjXalcp;
	spf=pass (imf29.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ygc72kGVmd8ZQpsIyk4lkVVEcc03lOMYv5NZ35NviHY=;
	b=sQQpsUegq5/w1c1ujzZ/KZOb+VHSdX2SfT25l6RUYaA7cIpAzRCdOIHG/HpU87czRvlaND
	HqsVSWDrvtD5yIRvRMzcdT/GCSDGdDf6h+hZmZTHiiMYZitsLFwspIl+5nuBFwKFo7BNvW
	Hvsm6Vmfg/LF4kT7udCmr+QzUCgwRzI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037736; a=rsa-sha256;
	cv=none;
	b=YyJ1hsZ5fLCkwt7vSygfaEnCHbmBVu9zRUxbscg5+15zNo6Uxyqx8LE6XfHOeX2VpHEiIG
	VysY6NrPzZVbNySTsBDM+d8N0nOBji56nOdSD8Y1+SVvv5fWutBdFecoDnEQYMXGoXY/Yj
	9wDbPHxrw6He+/FgIDQKlkWEo3YQ0TE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJjXalcp;
	spf=pass (imf29.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 173894453E;
	Wed, 25 Feb 2026 16:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA1C4AF09;
	Wed, 25 Feb 2026 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037735;
	bh=3ZfbgvU0bLE1CVEwtquKpm5fJ/GAe/ZRFRUG6VZuG1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JJjXalcpzSXkoB8Ni6wXiA74nEozWfroeKtL3vmqR4UqYOo/GcDZDki+80Li66fYn
	 eVW7TpKCNM4iPWL2SI1WaqFEI4SwYL3ysjpyCDfevFNH1iInAX9H0TLdwE2ndJTOD6
	 +Jkt42XG9qMd9WbqYVRZBzGFroRI69Dg0lBUpXfNLu3WUa1rNdAeFwU54cjsIs6cSd
	 mY4DQyX3STn0GSOGy8mzvoCTEN+0PdeVY/IFhh/amLXAnUhN71S5sAp6kYUEPbv5Se
	 fRM9FhO8Vne2ZvCdJSwPq03WOtZLXoTicIHabtEZO6+3kdhxJnq/tZOd35mKRSQ+W1
	 8e59vjrE4dMBw==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:54 +0100
Subject: [PATCH 6/7] dma-buf: heaps: cma: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-6-2109225a090d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=mripard@kernel.org;
 h=from:subject:message-id; bh=3ZfbgvU0bLE1CVEwtquKpm5fJ/GAe/ZRFRUG6VZuG1I=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1QIO/V0Qvq7+gY3Smi9WgS+77V5drTja5fcquX264
 6WP/+4v6pjKwiDMySArpsjyRCbs9PL2xVUO9it/wMxhZQIZwsDFKQATsdnJ2PCBec+iTTaurZdr
 pxmZLRZ0bc2a2vjh6BruogWL59UqHHxRNL90xZrM6OUBz0U5n1tqZzDW8MdcrC8XZLjRI5E8Pe7
 bRnXnRdumapw5Xmj0P36JqsoGlYK2u9UFipMWTjHtM3+3Y3sRAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: E71B0120010
X-Stat-Signature: wn8mzcn78ozk6jdifnqfe5xkfihj1kdy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772037735-646308
X-HE-Meta: U2FsdGVkX19v4DRcopFqthxBULF82jqX1TO3AVizrnpFKu3Wf1yFTXWI4Ia1eAtFdIarJiGuGQjzDDLmZ2CssgTuuCUN0wxH3lNqJqxzYzGB79nPGJw7xv/smShO6pzXi6NanppudkAiQV0tKIwUNoMOxf4cZpnbE1h6cc4KHK+61kgiiXhB4KbRHA5lggil2sFMtXyfX0R+arYkU9HaWiDxDtYcQN+3cobhOhNvaUzhDSvFfAt4ngMV9T8zWdqa/ROyLc7zgu1Ly4GvfHVdJkpoDMrohFO7NG00DZDJ7EnT7FozezmjkLosTizws7poPTns8uVVf72xgv3DPpTrfC2gtvAyatr/+LaNF5Y0rw6Xtuy2Nlc0bXcOjNGmBEM/Zu8M6IC9l5vnNh5PwW+ucreZWjuS0FZvqLUkbjWGuWcWo/QMBepdbC0Jy2STKiIaTvXmLahUuwyQXYt1cI+x6J8HiMNxza0yORRmR1o9BowWA30EeE07RlwODghT0GY0xSaK1TuHWAP37/Xi5ChbmRJASeHmTZJT5Oe9dA/Hnxg4hOguvcgSFwMoYOaAMdVeL9Q9neQmVOg02Q0YimXoLyvDE2pP0gc9xqCsfz3yQ4TovzEnWNpKb+rvrwuzIRsO00YCHxPgDLfCjKLHPbMNCwlfeHCYLi174jZKknfgXkDahQbfTFWoE0hV8nZ+U0If8np6tsMPVI8Ddbg1aXpx8fwsAHhvVv9ibQcaO45c/17KPTyd8UF+BWJrlNB/DjSulBvRgGrNOdkhfVdq9qG4Q0LsSJ4RMOKRu+r4WQHV3JY4GkTc9gSPpr3ltysYMbxfMm9Gwe4Q78Zcmo9Bw1yqxXbbrBsITZVTNUJbVm77FYcB8LIS90X4mAsHxOIP5QnMMHOSaQjRLuOk8BGWng1lyP9MBsTWDBtXS1GXFTuDR4mgKGBWq07DOB4M9wNG0KcdcDjZnsc9Pv0bv8vKhUv
 NTkhWlOV
 WY2jG9HbLIJNQ6S14vKhYZbgx+ui/JzvJRweoTVCOdG6w8UWv1Q3KLa0Tiu3me6XVYdZ/Qgx0xg10WNCq+JgaYzs4dw749BYSBWQdi2QxSsx8n1uWH3UB+uCW17voH0aihakQwcD05kBmZSTD3YBi7YTL0VXBaAQ0+NonVxfyuI2Q/fPbZqSJ8MqntZDeOxALRvnxiK0gD+SuzmPfRCrGUOuDCLfD3saLft/Isn9Q3bOe+fOntNdIXgBt5A==
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


