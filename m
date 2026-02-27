Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7D4FEFB4D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C196B0095; Fri, 27 Feb 2026 08:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50D66B0096; Fri, 27 Feb 2026 08:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F266B0098; Fri, 27 Feb 2026 08:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5E596B0095
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87C2C1C83C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:39 +0000 (UTC)
X-FDA: 84490303758.20.0C1893C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6B1B140008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ecpMkkuU;
	spf=pass (imf09.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59noAXpH6473ChzVPWVCaW5/Ounf9VZcy2bUBgpx5Js=;
	b=OoEl6pcsTK9fK/klSivY65hxvx+cLyPgPiVTW19jATzjDy2Jjv4uGqTlFNMppbMjEy8cZE
	PRwEMmhAIeip2xZ7rNVi4g5l73B2DBkezbAmWyZRiUb2iql3W3gzxLvg48ddMQvkllZgsG
	iunRch2KjuWxOrUCFLgtDnZLtkNxoY0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ecpMkkuU;
	spf=pass (imf09.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198617; a=rsa-sha256;
	cv=none;
	b=k5ugCXx/ceWqSlLqxTjyCUFbQ8bC47JDV5lwE/WUQ/1q95sJVXCYigTJC2xJZUKtZV6U/e
	IgQUucuMyHAsHmQIe7+a2ylb5eMcOqN9GpR9kv768tNaaF/gFycjJtQ3CEkCH2Jtn+LoLb
	FtaxDDQ3LVumheSYMlolv+MXV8kV8O0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BDCA60126;
	Fri, 27 Feb 2026 13:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C2BC19423;
	Fri, 27 Feb 2026 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198617;
	bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ecpMkkuUspj/gJIru8op3fzbNPWELjGitExJdq/w7/qfHqcC4CNuEzgaZG1stLgsv
	 79jSbCbuKccznKaAR8fVwA+5q18KVaVRgEj/aeOcOdyyLL+NhD6m6mYTCJFWFAQNRo
	 vs+L46uRiOU83XtQHbHdgb9QML4jqT7c6Gmtv/2R+2EOz7Al2pWMMWX+RIZGIaxUBd
	 24FDoKikk7LdLS2jiTvt1niMukJYZND8Tn9IKZwMB/1rlQjAUn43JA/TlZ59izSgwt
	 szKjgxFMFue/OWXvQFcXJDIEgTH/j1TzFqK1uX/VEqrJDchUSR8dr8Ue7EoiQ1NWsh
	 EY5BIZT8ta9jg==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:46 +0100
Subject: [PATCH v2 7/9] dma-buf: heaps: Export mem_accounting parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-7-454aee7e06cc@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114; i=mripard@kernel.org;
 h=from:subject:message-id; bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+2Ki8n9kLHCV18veOuNicIeLwMiOv1Xl98WSn+67
 XbO1WzxjqksDMKcDLJiiixPZMJOL29fXOVgv/IHzBxWJpAhDFycAjCRLSGMDQes1d02GbyXm2tv
 IRfKObu+Z/vdzpO2tZYbUsPeRFvGnJm3MG3Cntl63Fpl+vkr2NafZmz4J25xLKUpJWdzkeDfwk8
 NO842Hvv6WLVwotMLn80bM75ahwjp36jZG2z8xefg4Y8x9x8CAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: wnftnpmfyaxkfzb55xuosn8ztpcj8jgn
X-Rspam-User: 
X-Rspamd-Queue-Id: D6B1B140008
X-Rspamd-Server: rspam04
X-HE-Tag: 1772198617-101805
X-HE-Meta: U2FsdGVkX18lHn/4iVHnIz8yuHltAsI6j8sn333vEnE1oc7wlOoPIaXbyjSNEB3xE9e1yKJ3yj6EDHG00obln6vbhV0h15CCuoySV4f8OWHgxUt6ltqyGKM3xacyGd+BTB5fZHhYhlKe9dSp27tsOxEtF99E6FXTJUawCsgn8PvZ0BpgwpM5PS0sl00jW7Ere3VItzc4NLhs5mbI9LmL2j8qjdx54Ncm6Xjusd2JTiasVgUaknC/1bcEqamBk3zgyOlKQigwe0pnjq1ss1WiBHaEB+ZPP3Lp2oIjpu/HGNWlOqZHXUvJsnzMLhvVM5oMU1oVW25txddAwYkCi1MjFoLizO4GFfu6oOnT4LIVVhu6Z8h8zDj7ExxBByUGTVCwNy5WxOT5K4ySYQD6ZvBJFPTvRzrRyJrXWCvQpByT/cui+X/aBfvu46l0ueRz4uL4TZxBHJQSxXcTEl2HT/ZtERMmJUMLMbR7RHzPeWK1wIse3riUlv0VG/zdcSimOSw72tA6dj1zsz4HtcAtkv9LNL5AHKSiMr3Svs5f6j4bcczB6XPXi/z0kl6SKZFEmGsdpIyOg2qO+9ptHLDg2U+/62ufKfZ1klt8BVLVdmE2l9ckU41KHhaZTlZkd6w/J+eEUwCMQih53DenYgmlIBs/E/VFL2ngvUMzZrPgkCZ2WX8mUqJmakPYfm9f5k+Q1udh/Bbp46MHdNOXFlXRPHqcrUG0KKGaxSqQvOgCAczHI2YYAoPja48K82d2CGhbEqdmEEycxcUa6jRMpKlpzSa35GU99XgB8dqGHevLAKFop3IZ2SLBW2SZx4GesT8mRWxVbBSu6IjV5RKWHl0u2dCXT/QuLu3SkgKH3ntv02wAit99wNE6u+e26WqWaEv8oByVtBYVhbD1bx7NAEXcbwRI0Tlar8zQdvIayktFiWqXoei9WM87nPv+zLAzAODEl+ZtEJxGiQBWMl0UwIoZbrR
 0WdAwQ/4
 Js2uAHA9eXa2jQXlEbZ3GYV1DqRlrwdDwM5rZGe6Wiq7h1/oP5UNG6DEws9rSP0I8B7GulLEYIDnQZhIAbo6aYF/CBB/5EAjYEBXwsQTI6A4YHOwuqFOIw6RtI9XPN4jUsy160LdgntaojiGhouhzulkcP7Dg1unaBe6Vs0Zk8wmP3wIuWKoDaQ4zE8EISU0b1uRdfu0ZjQedN9plC93akM9jxauo2VUyngo0CwxUFlTCM2BOb2f6KhHIysm8HIL1ElUq1liz07cpDiRm3EHHWH/W+i7+f8nC+UHhv55GMO1sFc2MYMdG/oZENHnFtW24dXvG
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


