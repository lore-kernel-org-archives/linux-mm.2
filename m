Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B84FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272D66B0092; Wed, 25 Feb 2026 11:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AABB6B0093; Wed, 25 Feb 2026 11:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A206B0095; Wed, 25 Feb 2026 11:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E31EE6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9212C13B464
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:05 +0000 (UTC)
X-FDA: 84483546210.11.D4D654D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D82C0C000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=csGKWkXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037723; a=rsa-sha256;
	cv=none;
	b=JK7p4ch7tke7v9AuXsWVOsXlPAo9g3aBnzRi1pNZFe1hail3NTbxerzZYiqSqvRrJm7voc
	pXQau7GGpFTJt8fVLnVCquLplKfEHa1znj6uPDaTFcChzKsz5ZJvmbD1ZBcsgToc8fpjd9
	we020NInLbq0b1P/8q/q9oW4xyBgOrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=csGKWkXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqMXwWF1PSl0oG41JdQ6BGCGrRACleMUP5VdrlwJO1U=;
	b=HapHHoTA2z5b3RzqSjiXaj3/TrnlYYlXDYLaVVnGGJSJvBnsfnBZZoBTNYCJ+6e62nc1LG
	mUUUroRxZYw+9oE2Ud2a2/ns7s/pl3uLNxVKVl47cWW/MB+xTQwryZ/n7N41P/+eLupHzU
	c4qoAqaDu51QFyG8L0PZKOI6AjYV8Bo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B8FE60126;
	Wed, 25 Feb 2026 16:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83989C116D0;
	Wed, 25 Feb 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037723;
	bh=rfgqTaniyFcFynC/obpaUFFlyjqqthgGha52ltIUlUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=csGKWkXeguSQ37zJjf0IB2wvQOQl3/WLcW4dmFDzDbdcBjbHPT1zkBKm6J29MSeg6
	 xhGvtq3bNTlGh6/EGDE2aTQtaxs4VsiOO8ohZ2uB4qEil0ou0qeDg8Zr7kAe8TBQWh
	 /ZNRi1fKctGSLW4gpZYseuHiM9psy8MQJNSqh/2n2F066mlBVd0PXwhBTZTDlLzCCd
	 6cO4rjPG9kIAF8nlnZMXKsmji5AT5/nOSZdCE576FJIIzyETNCdF3hir5mY3Hafts+
	 qB6j6M+QC+Pyc8JmQdhe60ULJfAb5mmiK2sCdYE4YEMtxEM9uE86j2SXH3mADgDoZA
	 frH/OyTpRyjqQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:50 +0100
Subject: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1196; i=mripard@kernel.org;
 h=from:subject:message-id; bh=rfgqTaniyFcFynC/obpaUFFlyjqqthgGha52ltIUlUY=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1fxfHNsUEn3B2H5a+v+PEQp7p6W9/xnC8syK+dSd1
 jP7uFa1dUxlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJ+OQyNrwRDNz268/LgH9P
 9faUbHvhyCZb/z7vtFLTNmaVGbExClx7qz9r8xUdaLklcuJigejvLYwNfdXrtpw+nXW/t5v7yV3
 1jSov2r2+t+V/2ejWE/CpN/ax103GSc5iU9vnm62Im7lg1bpvAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: pikogenrs7eof17k869pug4mewmgqrwx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D82C0C000E
X-HE-Tag: 1772037723-172416
X-HE-Meta: U2FsdGVkX1/pCKSGgwuXqBh9XpM5RNKsXfTBdhAqMKW/z8flg6uHsa11C924gm301vlDm32kfyaxHnezgPp71JzF6CmAu2fUeh0pPPXUdYXMEl2qbk8dYGAlud5UNx0Y6QWU9aPSmuuL80ijo5Kbbu6d9heX4tQCnggFZmpoK4q/waWbwMH8Y3ZRdGzG0+P4CPWnJI4lrOb/DCPi/L5MP9DbBoyEgJpLwZURBLFVb5JmynCUUEGdSRsU/ydcCj0ZLiNliAgZt++fZfl3DOAmX7igK66sYb7/xuaOEMEtjHITWlSGiOt6JmhROak96+pkeKZHYzDNN9hb91bQKBI7WLNhZBhyu7qixJXI4k6C32Vv/nlimh8c6irfQesqv0q3U9QtMz5fM9CpgGhAxLd6zkmnKIMhx4vPmP2Qu8CvyBVSAQJzg/vb8n796UjrRQ3F2rEm51pTuXXWzuS/O1/2D/4G4D8Kmjs1NVW4OPwWSCeg/NwFfZ7rjRz7w8PPGVNXWzIvwPW5UN6DZXcO2jWt1mUoKtcrN5bVxPw1XVNWyKeXxujXvSG5A6oxeYpmXSjjmvSnITEpcdxvAWb+A7y9/yowBC2gSl49D3WOPhOCWJXQZ4vqofbnjsmC7mQVDf/WJiPoUa7YpZIpjlH58pmzd4sTmfovVGkHDe6dRc0Q6FMvbLc3we40i/W+xeswC0UYsmfOafI55X0vmAT5sTUV9mud7SjgRxBXwNAvcPQl6ERJxuangN+tNSspcWqdNsVa+PeMM27bAeQsqc7lKX7ODB2hZ4bSFDZpV9xZfKhNY0odS+hG0Ypq8s4J/4aZX0k97rFWDtKG9s0GGZu1gwqQcRDmWUDwvEl0fm4Qqwtapqcpf5iu87bMQPGFpQ1CD4Fz/qyLvOSi1L52cwNfTEm1HiGDSwDvYnLkNULndrPlwWQ6/nyecHjJ6Qb/svaBrodbs2hm8ayJOaVpUclsDVv
 rbM8+MSK
 sCxDXOnOPIz+fNt98TugTqf+YwWBF25YUftV1z1i/PmL/TQTyAvEAQLWczQu03YyhsM8+c69BVBSEhaiZKP2fe7oPxqdcqrRYOPjNuO11uY6L51R7AbWAYR0mSnqjmWrLKwaY7zpKs9evH8EXm6Lvt5PvAKyFQFnJEpEpr14lGrjCWa9bN4L28GTccpXnUmk9QmhU2szxQTbKXzVGSosohr8bjSGMDw4T0OL6AGA2xtRaQrjxHDIiQTLxRLoXIFqF4hmwgqw9Uhu6GaAyqVHx8W3m1KzkP0R+5KpR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
free, respectively, its CMA buffers.

However, these functions are not exported. Since we want to turn the CMA
heap into a module, let's export them both.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba4397f018f6993d962 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	if (page)
 		set_pages_refcounted(page, count);
 
 	return page;
 }
+EXPORT_SYMBOL_GPL(cma_alloc);
 
 static struct cma_memrange *find_cma_memrange(struct cma *cma,
 		const struct page *pages, unsigned long count)
 {
 	struct cma_memrange *cmr = NULL;
@@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(cma_release);
 
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count)
 {
 	struct cma_memrange *cmr;

-- 
2.53.0


