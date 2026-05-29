Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604EACD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 01:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E646B0005; Thu, 28 May 2026 21:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD166B0088; Thu, 28 May 2026 21:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913396B008A; Thu, 28 May 2026 21:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 820556B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:42:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 384841C0CFD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:42:13 +0000 (UTC)
X-FDA: 84818756946.20.765B2F9
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C7421C0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:42:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgztwgLt;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780018931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ziMz6HVoieYrDjrV2NAuiQxTv94f1tu4Knq7c+x4ci4=;
	b=uL1St6jpyXmK9hjQzgSn48bWJviC3A7cUrTexK3qnbR2NVbfiCOYLj1BlBGSzw/Cw9dfn/
	7Ks+AGlCBKrz7xeUKCLUxGSK+y0OzcW9F++7BQzjdGcNnUi2+k/YsTYxdNohk/GEqE+NeI
	c9izFtgNA7fAT5PiJjFSI5Nlc42BKHc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgztwgLt;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780018931; a=rsa-sha256;
	cv=none;
	b=oFSwuP+ucN3YPRdHYc3nnon+Tl+OjJbo/YS5jB/WUUZXNi+X6GlvkH4pZEL4FHmCMENjhZ
	wghaQ/9KMcQ+KDZiDijKNEIygV00+ic/k1406ndEuEEzPz+EBtt7/4tYv7sTWHo2SOLJiC
	FoeTc9YFiz2qjOa+bmOqhz15e4UCh3Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780018926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ziMz6HVoieYrDjrV2NAuiQxTv94f1tu4Knq7c+x4ci4=;
	b=YgztwgLtIHL1/MEG/04MmSqxTZ3CdCeEWT1HE0UiN/6o852nNWi2yOiGVMiGDP9wdUrY9b
	ceRtFCXWzvWGVDf6R2bfQ9Kg4I7eYnb6aqnHAeCGyDkhpfnaU2F+y8hknZ+BFyLdk23umF
	lG5EH0PG2hahyXDX8pwamp/aig62Nmw=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] vmalloc: Fix NULL pointer dereference in is_vm_area_hugepages()
Date: Fri, 29 May 2026 09:41:30 +0800
Message-ID: <20260529014130.671291-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C7421C0005
X-Stat-Signature: uj1qbj97iusn4ecig933ygeajr3scttc
X-HE-Tag: 1780018931-246881
X-HE-Meta: U2FsdGVkX18JA6K+Td6g6xthAvvQxPtWreB5yt/eaKq07RF6oCDti62nhBfHL2fsb2dgcxylC2qgXXj00Z36ByH12VMugsL0vIyM17j9A3UNED6vCFGV6dHLrLlXEjFqVZYmr6IhRgEssBHfx8FDmskNVAgaZEQkED/gI2TMy8v6Bi72zxwCU72rGWadxrVhJ6ftFNHiPQYyvtfV+2l8EDUG4GUlWWlmoT60oxhO1yjUlS1v2o8MaUQHceWuKgYzk+E8pIeLZR8RjjDoo4xv0i9zPIapd0EhG+v019qIlfr/Puj+jsozxZYj506M9pvfMGbj/W2r/Tv+KmqLKgaX2Zun56HW8f4hus4w+SCUEtrNZK6+v1PE9E8nRkOz0ALSA9d0oPtTMORANIUfGdau++Dr99IbO54uCqr+axVJFXyjkafI/fYdANF9txT1sf/ZPLwccScYb+vf6Tt3FxW3D/VdggSg7YL3gfXZvckmhVh0pKsv8RWP7GwsrH/bowzJi0fNcAkiRN0EmpwcW0knC9XDXzy/x0UipgVHeYjk2xnwSXZY9E+4GoQZNvC8P2N4rTYLG0UPAWXRmV5wG7Shrb/su4qaKHLTFRKtXAmDkgPezIBPf6DTQgPJ+5hNjHoS9Sbz1xr03kYeLcfRFSxYZ3MsCamk6qzuQyn71/0XTXgKYmktZmY3urv2X4jNPFnCHmLD98YQ5M8YXSpRDpoqhFnWeLs0RUW31Nl72dVA/XHsUUZF9/60yGAJ4wrNqIJPW31TDdc5C77k3FNwof1QYC2cCz57T/Oc9lmu74FqKw42ZdOjIfQLDdt6TBpN0tdvuvWrSJWYPmLnG9nPShfqfgJ3u+XljJ/u1Jd7+o/q8gYGmYKDCw7/d3zodnNpxr6HDiOpsYPEYks64dEPuy6iEthMlTEZpOIFWyfdReE3Sl5ew/CFagkOl/I2KPh2vbyMqGe5BhDS2WL5698J/Gw
 DCW5UGs6
 2/3lUyjPxtex6YzWZHXRMsh2h7+bpSKmF3y3p0t3/jBRRBhzdjlF7QPWiOtU7pulFNvnUzXCxrtKhMUujMXAMiBf0V36uOX3HBR+iNq7tO92aMRZ0qsdLLcu2/SwR+3EHVqaNFhInjlIZeN1nGvGfSnld670SJM1Lp0wb41HSEI5pjJM7K4HJU7/geGn1rxF6Pq8iyO+/MpYoorfo8+zmueA5KWPvmTTgYoLm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

find_vm_area() can return NULL if the given address is not a valid
vmalloc area. Check the return value before dereferencing it to avoid
a kernel crash.

Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/vmalloc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..d87dc7f77f4e 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -265,7 +265,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
-- 
2.43.0


