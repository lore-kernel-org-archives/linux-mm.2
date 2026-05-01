Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F37FF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 07:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5225B6B0088; Fri,  1 May 2026 03:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D37B6B008A; Fri,  1 May 2026 03:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9176B008C; Fri,  1 May 2026 03:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7576B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:58:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA8E88A6F2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:58:14 +0000 (UTC)
X-FDA: 84718098108.26.64066F1
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 19A74120002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:58:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lPQlJNof;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777622293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kyAk8NA2J8YQgw/gGqBaVOWUHWOA6WWmvSiQgKxkb6M=;
	b=RXPHbF2Ox3dPNV5jiVQhTBdn3AfylUanKm8+h5358cLnYem7NGr1Vl9KKa5QdXsJtJZfly
	uHFyziGINT230M/fhzhdRnGyaAdRwLrV097aHPnT6qMp8s0vyVodOyrC5rPsVjXkEU5kYE
	uqolUb/vuYNUeLdDzghzupeGbk1olSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777622293; a=rsa-sha256;
	cv=none;
	b=pkNwhiyZHlyMbSsgE3I57vrfkIu32MzBF8w8C6DwmD8hav+z4wRKWrmaeLNKLLgqbqKG0F
	3IchuVIfZWiaUcFoWoxFdQXhjPhMXwlRXBmZHUsNItE8EBbywAmU1Nxb2uqB8vfjSAkj4U
	zkU9h8pSFct1ku4by2dIv40g0lBbuiM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lPQlJNof;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777622251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kyAk8NA2J8YQgw/gGqBaVOWUHWOA6WWmvSiQgKxkb6M=;
	b=lPQlJNofp7eLTUX3eNkcXz9TPqr+ahTmftjh5QsREqS0S2al9UrBTHMVb/Z0shGSMIRX40
	4KGc2Fz54IwH7pt0+UvqdG6n31XxJkVdF27ly2VC0Em2A1d8opzTh/GXu+mT6pOP0EHFat
	xC7Gxe3IU10Uf5VxmAcoqg21T9MdDQg=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Fri,  1 May 2026 15:57:07 +0800
Message-ID: <20260501075708.327217-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19A74120002
X-Stat-Signature: j1g1i8r4zkscwh8sazat1d3orb5qgnho
X-Rspam-User: 
X-HE-Tag: 1777622292-410768
X-HE-Meta: U2FsdGVkX19/I2MPQ0axZIEL8Al5w6NusggiUYLLFkp3GibDhKoC97GsrsaXvVB1ooa8Go6JXpzodUp0xnCBGRl5GKDXyqKrr/afd2pAxK07TKLwLdMGWdyOjksi64GxV//SS8B9b+MbwQVWZoFSFQvg+D/tTDgTXV3T3zAgnwyVmjXQ+37TX2pOdTik9/wbGFlzOVldi9pdMthQn28uIHGCmxM/xmOYbjXSYsQyl3kPqhcmUhSWumNmg3Iuw/dEMGuMw3BJV2Jt6inqdORi1zyaRmxfYktmJoC4GDmwOftcTpEFQhOgR7Kjgi6F+jyx5yvjpqhIqI+XAkt+B5/EFMpC2wwsjyfqpHSl05ndUF1mhFmRfb3qjyNwM4RwdcYdluSp2uF8m0lzX5iIATrAaqp4aYCsLF8yAWEzKwvOAkaVJrrOTOPJo7R09wSvEgyQYeY4P/ESYoU/j/3THU5JJtJh/IwyTIWXxKlwPH0TSe5bvu9REAuiGPlGIbqW/maoVTCd3/mQFBVTp9unSY9hrAHpk3JtECbAUei2exfs9erWiVC1CDFaU0+v2mYuE/ySRDwi8vV1j8mvmyyT1ggqbmLrQ7/vLbc6cjKOWUS36eed4RsoVwrxc1s2QDa0L4W0USfQtsDTIfUhcaJe61EeJUwYupfisKz4cdiUxFkvBD/Vwx/SmSJCUWBJ9+dJOIw0UGOrt4X8xMOvaHj3I5qe6PQwJIi6T3Ns+fbtyAIbcA7/MKtqXF9+F8/fVrlycfzxLxeklevE9XNAxARWT4qDE8V2l6o0Ftsy2pEpRKsGvopB6mHRjJQh9wBIUfbY2euEUyurq3Cs79j42AEeV0T31TstZF+ZO3kIktYaU7pdmXoCw84OYMhNlP9zTjtyPMop7BroKKMhGmvd0RKaWLMgzGpgY1pItQRWniha6fECb8qDvkQhdnJdhCtXuPnbznNBDXgClLkTy/zxnNNnKIT
 jW1FpACr
 fGnKs2/wYkH9srQq5gVIpcFLuv/8A/tsIZyencOT8Hmp+rRgF3Yrv8p9atUCQJsSp4vfn41M6ld63vObOOsu6OTxU/naXt5Eit3njcpZ7pByUmahZAgWz9lKlKbj911idAYe2P37eTAuYnNs8PyRn9ZvUWpyq4fqPVDSpcvxth02Wg/cos61d1vsHYtq/qU0HODX3TcnIsNS5ItNE9RsMyIW4wm7kVouARcv5COYnPLM5+gzR+ItmutDEiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
corresponding mm_slot.  If mm_slot_alloc() fails, the function
returns with the flag set but without inserting the mm into the
khugepaged tracking structures.

This leaves the mm in an inconsistent state: it is marked as
registered (MMF_VM_HUGEPAGE set), but will never be scanned by
khugepaged.  Future attempts to register the mm are skipped since
khugepaged_enter_vma() checks the flag and returns early.

Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
restoring the ability to retry registration later.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d48d4fbd5f3..60ab7c1b61dd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
 		return;
 
 	slot = mm_slot_alloc(mm_slot_cache);
-	if (!slot)
+	if (!slot) {
+		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		return;
+	}
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
-- 
2.43.0


