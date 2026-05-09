Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C15CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 02:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58A46B02F0; Fri,  8 May 2026 22:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A086E6B02F1; Fri,  8 May 2026 22:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E676B02F2; Fri,  8 May 2026 22:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83CB56B02F0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:44:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 117CA14042D
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:44:33 +0000 (UTC)
X-FDA: 84746338026.12.22B6E04
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D334A0007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:44:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xUy4vFAb;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778294671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BSqgWkTmMoRLkACDGwlR4gKjDv1T//Aj7QnUSlLg2Eo=;
	b=BFMgelcJ9GqabMV2nw2CIuEiVkZrq0p+5GyYJivmcS7IZAuzsgySZTKglWmZejWyXn8UEj
	3TRck+QF4trXwg6JyJWMxtaKrQJW2nWxKDJlNcCqe19OdUBkutDbVlWXGCvM1MYSotJQV/
	szluYex8KOyDCK8sbjlGbVsgtoGwbJE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xUy4vFAb;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778294671; a=rsa-sha256;
	cv=none;
	b=JeXSBzoNsgacB8hkpABTrwLMWkUACAVrH8JmfpPdUP3INBwhrBat79MtdsoWRDo2VQgv/2
	+MTcxcnOSFFIXiVPACoSsS6Mu9mdzRWKfHMCVOE4kP4wQzQWbCXDWzTFWn/1a+EF6p6zIm
	pgSTJiEeUWP4YJaH8psoHkxPmLN3uBE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778294666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BSqgWkTmMoRLkACDGwlR4gKjDv1T//Aj7QnUSlLg2Eo=;
	b=xUy4vFAbixh6ccBvc6N06p7dohIqY2K7iV+vh3HUhAT2hWxpCgRlv4Iy47g55bZFi9epqe
	C7hA+6vCLgFacE91u3oytN6xvrON8TEUclrnHMdMZazOYPWPsFqgyh3PsxtC9KirihkLMI
	CIphWMPNKh2s0gvqu8N8BsoCzUR8pu8=
From: George Guo <dongtai.guo@linux.dev>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org
Cc: graf@amazon.com,
	jasonmiu@google.com,
	ran.xiaokai@zte.com.cn,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Date: Sat,  9 May 2026 10:44:15 +0800
Message-Id: <20260509024415.33190-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D334A0007
X-Stat-Signature: ixcfys5g11hikskg94cob565rmczuw5y
X-HE-Tag: 1778294668-452394
X-HE-Meta: U2FsdGVkX1/21VdZtPxLJnq8rgZqyt6qF+G7dsBvygRFi4DEwo6SepCqQ5UXkRzNWHKIikOKsry1D3qYLLWI8hDDuezE+9fwjBmKZgIHurhfa0v75XeU+s4cs/ejBY0PSNMtgQrJc6EzYbMt8rKnEiXzjagegqtchbFCT0nWchX9VewMrg54ZolV2yGJIQ/b4nI+aa5rx5Ez9DQeGYu6ZO/lSglCZUEmpBD+3/0dqpmbcplYWs87EVuIczup07Xjl0HLWfEz4Y+CQVUWnDPzOsuKcqAQWrc6tj3j67GuHy5FkTWHCBY9KoHOxeoJnHc2VOaeJdJlHPAa/dsMDg+U62v5rwtRgrBiNeDma9PKGodvjFTlt98xZ1WUDB96Hzfd0JdrTVdW2eyfBpk+qDP9lDYa6mtC15igvLj2SIP8coF34+b9pgN0cNaaIQOMIOYfH4Y0T3CHJk8i7iYV/Xa30jOL+Dlmm/fSTe1yHln7Hn8xCZdZbeUHxiIwz71YsQCbBlFm5c3JQtvFEx0YaL4oEJpNu1He12vXIC8A9tWTOPaVsuYJAyG4lioK5mz43bMO324HS4sbOOyZhcdPPyNnWhIHQCD8WLP6RwvrlAWq/sWVEaYzd6tc4xa+IpheigRtBwvdm5yqdd1CJbBqYIXWCbIL5txgYF/Ca26JvQ593xRQsPkSg4yT3+YPiIlTSsVy0dFLjdoQwp1Gno6mw3Xo9JDJuQJBDvTbHNePoRf77F3Li/jwDUtBuvkQUmSZerbMSxP7ULcc/TR/0nBKgLkPyzq1QGUqeKCrXFsgxMmDrwacE70IWfJBiQPqpagZgeIZsZD4eBT2H98TRCFV7apGEohVVc4v2N4GWztA3Oc6MI2x8ZUuIA/7RObQYk7ZFU1ynAeDiUQxPXlxmcoyeiXuWJKQZzB2V+pwtS7Te/QNjCjUK87TQNcj2l8l+CPwi3yvPXmykTcCoJTXhQvx9Jo
 puU1hhVB
 rZRHywZlNtgPFIQNykA/4Fn9zMVafK6W25pGhYav+YSG0cou1Mo7jAAWcTBl9PVD544jfWNn/63ZDA9uUGW4hCZeDfjdDpWwkmdKUPxU+yh0FSHoIfzGqROcM3NhVGy/bpHjxrctHFhq+2iVXbY8H89fLyHc1ee6/6EDOkOE4PL+nKOzUY8LQ3podHiP+q/dbsFCN5K5fxUfGbCSdVSepz3b3S4naLzqFQUFGVyKc/AHkgeBplb1AcbqMP7QTVLV73bpIfkOl/S2TkIdZKwDjEMFVEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

KHO_TREE_MAX_DEPTH is calculated as:

  DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
               KHO_TABLE_SIZE_LOG2) + 1

For systems with 16KB pages (e.g. LoongArch), this gives a depth of 4,
with the top-level shift at bit 39.  The order-0 bit sits at bit 50
(KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT = 50).  When inserting or reading
a key, the index extracted at the top level is:

  (1 << 50) >> 39 = 2048

2048 is exactly the table size (PAGE_SIZE / sizeof(phys_addr_t) = 2048
for 16KB pages), so it wraps to 0, aliasing the order bit to index 0
and losing it silently.

On the second kernel, kho_radix_decode_key() sees a key without the
order bit, calls fls64() on the wrong bit, computes a wrong order and
thus a garbage physical address. phys_to_page() of that address faults
in kho_preserved_memory_reserve(), causing a kernel panic early in boot.

Fix by adding +1 to the DIV_ROUND_UP numerator so the formula accounts
for the order bit itself, giving depth 5 for 16KB pages. The top-level
shift becomes 50, and (1 << 50) >> 50 = 1, which is nonzero and
unambiguous. For 4KB and 64KB page sizes the depth is unchanged.

Fixes: 3f2ad90060f6 ("kho: adopt radix tree for preserved memory tracking")

Tested-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/linux/kho/abi/kexec_handover.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 7e847a2339b0..db9bda6dd310 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -274,7 +274,7 @@ enum kho_radix_consts {
 	 * and 1 bitmap level.
 	 */
 	KHO_TREE_MAX_DEPTH =
-		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
+		DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1,
 			     KHO_TABLE_SIZE_LOG2) + 1,
 };
 
-- 
2.25.1


