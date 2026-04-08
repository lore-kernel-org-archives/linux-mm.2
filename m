Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6818FF513A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223D96B0099; Tue,  7 Apr 2026 22:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4EF6B009B; Tue,  7 Apr 2026 22:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111E16B009D; Tue,  7 Apr 2026 22:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 031376B0099
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B34F7E2951
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:57 +0000 (UTC)
X-FDA: 84633863874.19.F609902
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 039A340006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKK4jkTJ;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616716; a=rsa-sha256;
	cv=none;
	b=Wip+RXRJRslKmWCOW0Sha2VlKc91CMkeyTWtnc9+nWuJ1Tp6qfSRcy7UrgB6iEGMzB8+kJ
	/yBONq6xGEZiD5/IUsXSyaPwUEb2I7uq5Giw1UrIoVv8N28HHjepwZAJPSy9zoXZ5+JKd6
	34e4lqFCmmPpzJ+EZeA/ZG9bcnEuTSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLbtxbUymos2pxVfR8TH2Kd+TzQQJNnqZCKsRYVQLgo=;
	b=Db6LjLG0cwS35kngsdd/ATK6QexLFxu/1tR5P8diinPBGr6Jmxcngb+DfbsxgadousMAWl
	tFRTEtbiXQSd/pUBSjS+u1+hbhRlqK8uHxi7inDi3nCaEOwg2bugp08jsI07bHN1Wp4956
	BXgenk/K6nQdEVma2ND5biq2/iQRoCU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKK4jkTJ;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CA624450D;
	Wed,  8 Apr 2026 02:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE7EC19421;
	Wed,  8 Apr 2026 02:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616715;
	bh=zaZ8iI84M3gZDm1hFnDFMcUBYZoPlyljQ9RYRlcP8K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKK4jkTJ5pywEdQAoHMXFLD7R7Mhv5Fnty4Vg5GxCHuMhVafbgKxAzllimIrmfxVz
	 k1L/3VDHClK8mu07LOtpbPbjoWCRs94wrnmP0v3vjSgBSk4dKGJxmq6GZ+4RiXf5Dv
	 ezwuHP0DNCVYdCLaWPBR6CI5rzkzA4fXL0f4ql25HHBqmX3Bfk+9nCWJzmRnuaoFET
	 I1fRFIrfVxkyGP5oWkJc0xIXD2ijRTNoV7RyahVXzArx7n+PTOrf7sKnCQxgOUf0dW
	 1TEHNCYbfGT0eEbzT7ZkcdMF7XDAbWYwl/ASDIGj1w56XtQsqOVKIMnnNRCUmoXLHN
	 A21hs6OW851Rw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 7/8] mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtable zigzag
Date: Wed,  8 Apr 2026 10:51:14 +0800
Message-Id: <20260408025115.27368-8-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 039A340006
X-Stat-Signature: 7bac9ue81i4ze54944t6yn1rayia4ns9
X-HE-Tag: 1775616715-417418
X-HE-Meta: U2FsdGVkX19e930Y5Axo8CkxgH99jnUGXTs+DlK1lYOp3sca8yyzhjEEsjVhVdvhreZU9jpaURJcxt42ajk3P/VqAglkre3ZSpRDyk+lnTlZTFZ0C2W9kkTwIHvSnky1zjArHlx9jN8728wSFLCvVDN3eNWRShStCUZBSrN1MrmZ0mg0NeMss1u0uk7jZYsvuTQirrKbCRu355lsbwsmgAw5QILfy+cFqwEWUJ+mQqnxdMem6wf40+0vnjN4+CcxdKLLjnCSuQ0g9R1C2nWNnn8tVFzEI6LVNVJbssO42402engppx/0+zg/ZYKi59GA9jvV7uBgsnwoSagyQhpdcLI/gsv3ZnB8lV6Ik6HYcv+6zToQ0eHmpxcRQlnP+JqkxRMbb6CRo2LQwOT9D3cY2NTnEW9hGveasgTGAyuvtHr1TtiIIOIPOc0ZHdf7PlzmeC0BySeAosi6QRWSFUaOyFmYT7TLIuf6V6F8fB7b+z1n0xzKrlpQZjNDtuWZ6SSgqBigYVBl3w7vnqLvA+YIvQ1wFI5iJ6NAQNi15BEPMaLzPtOtnQs0atGLukaqnQfNrLKKwXVmJGAn1eOQLGWzPqWI2DvnEyVohcph73+cRwYoKWVVec3cAsxGMVGjKBu4Y7YMQXEetUoo79YCT3xZNUu6zaEIK0MElmgqgAm8P1pcZ1TPtboJ5hEckkdibhHmuSeCbyhWnZlAxQzypL9lIcHVBd5xM5afjE0Fuzvrou0YM397B1+awLFzfcVljbhGo5yiqDONO9hzXvZnQxZ3w9NaAAQgLSxConH5YnaoKRgaBOpxPZ7/1biCMiO1SQ/GB7CFKnNVv0araxLnggaxx9E0UF5yBMVCIyL2bkwmdCI/guwYkMDi7yt5WwS2NxM8c+WMjs0R/ZKEOIuiLmITCpuxoymSgSuNdxaJqiVPXZmgDcNhfbOhfF3vzCxwPKZVRxqAGjhVIRXdb3YNQvQ
 jp/hXFui
 RSk1ILu0VN0+MkHz6ofVnFdVXsCm5HFHhBFSeNbObYY+OU+DKGPoiJNXwQIZKen3CzncBUN2BID+dVY4KkRXo27ZYfHAkInWJ0ld39GH4zyubmfB3WuUdtpqB6eU3BQcKkiDD4pHyP5e4+8e8xD8YI+1WYqkLd0LCZBfJjUJSgMAa6u5l6FOjz6fSkPhC16XScsf5HmPlw+G7R8QQl/AYorv4luPlarne65IjDCtWzj3GefF0yGymuITQPcL9cSpApgMLZbfUvYoEm/7XEzIaAc43fYyVC5Wt65cIo9dtORGFUd2B08aNDpPd03RR4frEdjeL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmap(), detect pages with the same page_shift and map them in
batches, avoiding the pgtable zigzag caused by per-page mapping.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6643ec0288cd..3c3b7217693a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3551,6 +3551,8 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages)
 {
 	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long map_addr = addr;
 	int err;
 
 	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
@@ -3562,15 +3564,29 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
 		unsigned int shift = PAGE_SHIFT +
 			get_vmap_batch_order(pages, count - i, i);
 
-		err = vmap_range_noflush(addr, addr + (1UL << shift),
-				page_to_phys(pages[i]), prot, shift);
-		if (err)
-			goto out;
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_small_pages_range_noflush(map_addr, addr,
+					prot, pages + idx,
+					min(prev_shift, PMD_SHIFT));
+			if (err)
+				goto out;
+			prev_shift = shift;
+			map_addr = addr;
+			idx = i;
+		}
 
 		addr += 1UL << shift;
 		i += 1U << (shift - PAGE_SHIFT);
 	}
 
+	/* Remaining */
+	if (map_addr < end)
+		err = vmap_small_pages_range_noflush(map_addr, end,
+				prot, pages + idx, min(prev_shift, PMD_SHIFT));
+
 out:
 	flush_cache_vmap(addr, end);
 	return err;
-- 
2.39.3 (Apple Git-146)


