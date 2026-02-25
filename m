Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3980FD3776
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A226B0093; Wed, 25 Feb 2026 11:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4288B6B0095; Wed, 25 Feb 2026 11:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355B96B0096; Wed, 25 Feb 2026 11:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD696B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4CB3BA74D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:08 +0000 (UTC)
X-FDA: 84483546336.29.65ECCF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0762D100011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ur3A8vqq;
	spf=pass (imf14.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Lz6omm1zf9neDrR0XQl7/sWPc337BLzrKcRUeufyEE=;
	b=qH0aVnxTPzaqpmxMZR0zTvc47U/nbChYhUfsjmCbX6wayQXcUcZh7wVB13dDxsEEjk3qSy
	ZQ/d+ZjLGtt+mvXcgMJ5I24KhPmdlmvghrD/kvzIz7oJc+k3qX4dCKHLndeKHxIkYacqgW
	hgLvDNsFjn6Qat4jQDtaIiG/wWf08mE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ur3A8vqq;
	spf=pass (imf14.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037727; a=rsa-sha256;
	cv=none;
	b=UWsrAYvKRNpBftvFglTv3ASrbGfeXhTxiPcB72uxOiyZ7/ue0ZGPJmjdH6eqxsthzliWmi
	WudzEHES+uUiC+1Hv9zH8DHaWQHF57g2W5Cu9TnkSbXLhz1Ob3bMO+2n8LSsPwFSG8Xq/G
	Pypyo0McYLru5u6r9O0fM77A2WRL3Tk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35AA940573;
	Wed, 25 Feb 2026 16:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA20C19421;
	Wed, 25 Feb 2026 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037726;
	bh=1ksolxmHKnKMAAkcEvTBTRw073bmw9i+dhSGaMAVL9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ur3A8vqqGdciMpqU0VUtudg622/fzXcoMXTJl8MBdRsa8x8pVSrAXd1E9yCTkyXp6
	 iVXrS7SNdy75slH60+tXplIkB6t/1o7nxFWsyWf/4oxul8cFq6YbEGc52bvJAzibxR
	 BvjAMCMLrr3/tiFzUSV00wGbR8t+6DooLQJ5JpnNlHpE3i0UIaRtkNB+rccVdHIWrt
	 XC6A9aksZBx05/izc6qF3cGGmMQBGAb5VbwkipsNYcdeMD23sOXEaYaJtchHNc8GIJ
	 IVW12BkW/qEybgdzq+HbWDDkD9wZBUItYEI5/ngCNGrV0rqIEz3XE307ulKBuLLv5K
	 tUgyzFlBI4Xwg==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:51 +0100
Subject: [PATCH 3/7] mm: cma: Export cma_get_name
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-3-2109225a090d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=859; i=mripard@kernel.org;
 h=from:subject:message-id; bh=1ksolxmHKnKMAAkcEvTBTRw073bmw9i+dhSGaMAVL9Y=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1fwnx849earviNBCCet3bOc1zpe7uW7U3Wz8x/jtU
 kPTxgeBHVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAi/AcY62Nq/RlO7bqgoKgi
 uWX9Eu8FKk0HHSbUvZ1qw2udpZF4WLmCq/pPatK1K8e79n64Xq4az9iwXMwi0n7FB4W7jc/2Pbh
 yIus746Trrs81HTbOqLTs8Ixmir8d+tG94N9f2VizxOz5p9YAAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: c3watnhet9zrkgmbthpife81xis1ugq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0762D100011
X-Rspamd-Server: rspam01
X-HE-Tag: 1772037726-992535
X-HE-Meta: U2FsdGVkX19d5iF2V6rhPHfm2tAp6C6B+/VAE8agNqP5qPBYbqXMyd7/Id6mIR8Qa5ol8fMs0Dk0kQIpjhlpIazbKVKb8Ro29WUadobB1+Bwg30ic6IWrjxGlcOJGMSDNX1G/SlB7+Jtyygj+8iCDpzjYAYTewM3kxH66JWvRAI+85Tc8lifbpbneYGLjVDX9hBBFqpqd6QAcx3OUuC/2eERB2y0DBdfx/F3HgtjyhMkHfvhCSt5AORoVwN3K0rhhTHVSCIHfOEN8UORwj8RgAEG1yv8X+wbNAaT+pVZN031tWcR0k8AhUD6JHaY35IOA14MKFQoxnUg6IKYC1ZqwMULbfVw2LV5XshZTfnc8hjkQYSdvQdDIIEEjw0LnPK7q4QceIGxEjWXg0ExhlYoUBSwLYsxPD7Axl3+xfbh1OgOba1sonrugYQfh8giWNxR70MDsNHz4h2Reng144b1BpAHpRSbTDoOhTg5zLqD/aWD7ZPjSwBLzBSsrftbt4NxyhOh6xhf83f14fKy80weLRQKWOZ56Dc3oHq3X650wfss/E50ID33EchFlTEHpEE1pcHUBPnJtk5dRuDrRcTeBuXn9QP6oAQbQsQh7a6Yfv0qW220HqKXoLE4dAaXnUJ8BT67ovf1NVHrvQPGb85fHA1S8kUAf/jRRFq13cwXThxgcaeKtq5XhCWBObzL5S4Bc5OkfBOZytlDMrUD8/RrJu2kiLdtqIdABnddHqOjnXHUZ/d3gvibNKbGfWfP5s2KsBSyXWJK3lyJuIfxPC2WmZlGV5jCSEEnX/nhccNbbTjv9tlXlhH3MXeHl3PZ2P5QxBnLtwVvmMvX3gd9jvn+KTLKPZOpy4rbToFPSA7k/NQim4O13bQaVBKZs+j190Nrfxvjr2uTkD3yQ9MxWq/E7rN95GOpUuPAAHMSNDlnpO4SyHAE+uNNG4Db6NunqxXIH0VfGPZLYVIw90Sl1Je
 GvruyymH
 boRhC4DgLHAd54EJ1N218MXQK/Y2VBVTNXlsklTGObH6LX0zEjRPlNsm8Di2t7a0UBofnAeNyEIOjpKQ80P0SjK+CzssFEQPc6syrf833oshlXdvfrg0u3vkeXzYK8s4OAzAiDNjxVXzxQc3QFnCvS7Upixl4/Yr5gSIxhLh8M6jjM36hsPuyFZoIBk7OwYsUxM7yCsyyIvM2vEYWJQXmn47ki66uxufOv+Yen6Nt5VrypM/2HC7YzXfKq6QlJy5k11y1qVlgjCw+6SMkUR0TZLoEj83TlB5Mlj8N
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


