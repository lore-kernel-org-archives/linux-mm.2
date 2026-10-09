Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B95CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8676B009E; Fri,  9 Oct 2026 02:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FCC6B009F; Fri,  9 Oct 2026 02:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95346B00A0; Fri,  9 Oct 2026 02:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B44C6B009E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:36:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16F761C27CF
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:09 +0000 (UTC)
X-FDA: 85302128058.05.5CAF8B7
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05D4140005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=namjizhP;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYR9hmmlunLwlcPkfdlYex/YxbhhYAayQiuZbtPkf/E=;
	b=h1YlLKCHNn+ihunyVQ/0PkOA3h29H2Mra1f/igk+OklYEzWdX8r9/cRo5fR8f3YLIU+C/z
	dCxA2Wr40QEg4pVbrVOaCYgpwGSoU4U9xWc+rkNsHdpUI1ioq4nz+//15rZh7jFSf1Hl9P
	iebCP8iJ+DzCwdxt0Cvr2o+/nIJ3vUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527767;
	b=TYbozOaTZa3WMpWuXDsHUWAiiazTrQ4BH5lLBCimwo9lp56bcOSm+5xFjH67ZXcinQCp37
	F88M2iKOgiswm5CCp/hrIeoXq1INP0HdKtD4CEyhncdOkBKcd3V7Pel13TqzY4wnoBzroI
	NctpagsxReOj7RTSAf/DqhlBZI0SO5I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=namjizhP;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Lh2LMrtSYDDnCgnAv7ysw9EHYWIC+fUbykvCTSebHms=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527765; v=1; x=1792132565;
 b=namjizhPyYvj8AmyunUzLnhmSOznkMMx52v0vH2cDMD2zl2bZvwPfDlzgTyXP7aHZH6x2TkB
 84qSrfZMOBc/hCzdQ12u3E7O98vYj1Uo+lOiKHBN2N2CZh91eLR/grg1ukE2aN3fYFL83ReEsYz
 vxUJP3sVSl5kKK3kO9sXCh+E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bf8d544524139af5;
	Fri, 09 Oct 2026 06:36:05 +0000
X-Mizu-Trace-ID: bf8d544524139af5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [RFC PATCH 2/4] mm/vmalloc: undo partial mappings inside the mapping functions
Date: Fri,  9 Oct 2026 14:36:17 +0800
Message-Id: <20261009063619.112313-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261009063619.112313-1-hao.ge@linux.dev>
References: <20261009063619.112313-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05D4140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q5rf1dtnywtagt9w9o6pbc11u145kmub
X-HE-Tag: 1791527766-970803
X-HE-Meta: U2FsdGVkX19OQoais2MiQdKB/Fx8AJDwHyecoXHgeJhWWg5zbmFKWOZ1CCxVu1EYIZtZj7x9eEfeb2o0Z2L3isuUocCY+YLm7LFBrZrb3UGMYLYRjrCipAJ5Pe9D+amQtxqPKlvxJ0ngeV4x//zP8+/1Bkp0pBusxW7WBoRRRRenwKApf2UDV74iqSL2naG0rxQNB+VTlEbujC87B8cemiA0HH8foxxEThraJTxEIbwHijayD6rTw8Y9QV3i0/QUesMF1amHXlxCX09fz2Wf7npUV8d0/5ae2vrqT4KdXGpHFxYei2tGRSixTstWfecZVzI2UlEJJdvZZuSjgO3t/qpEYGrgsi6cRNdhxSjBNK95Q9fTvDJBblAb4jLBn7AziznMAa1xMxSmEE2BC24ob/wAuKJdYEnXPffv/u2pyd1FF7hlPrqne2X/l4HqETB5QqNVv+yv8kSS8cAsI95Lg96Rek7Ez8+uCGSkXmkvS1YctTLysZLy0bUpGNQdwx99YJ+ws7ngjNXmtZNPIjDigMTJ368jSzUiaO9MhcVqKey6tNkD3awYc+Y7QHEUMTWwoCM1fuApdvPW7ZpvB053v1VATBU8jbc8fp6FSFA/oaYLqmHA90hijg8QZFR+32BuGVvk7H5gsd1T30unpBo1VmfPXykIYH1ydfCLrI/FeNB+zSYUBXcoRxI1bkos5eNHN+RV2O5jUO7EU/3AhdDc3BvhdtiYgDyNsu3o1WpUPx6pNI3Rj+1l2+xDR3Q9RodhyPBlek2RaV2jvmdnGO98UDUmSL8NUHtTOURtrzlSlOdPJDpOjiLvAtdgIkuLTVxBICm0xhKdSQcBEqrdEaggR+ZAp0rLKsNZb4wCC9Srpzh2PnCS1vVdjNvO6KoF1SgcF+czykzosmqkLyP8ZIZDnfa4WUnp4p0TnK+2IP/fC06DHeby7jZsdZidOOZIgKBtDCM71kxG+7aacClXbi2
 WkkAKDZK
 dGmEsk4VRoe1KgEIgXt9hFhFDg6wjaaQZsXa1WSKmXoCQjaGezjwPLGI+VGYUuWXo7O7X4xzIB7tXPzLoP+wp+30NR9YgRnQUo7WhN1lquDGL0WQ6Vd2qmf8iH++nnHyj3ndNbcxGNhEV3sXLViqnKnMXBUGi3EgV+bDtw8r+2a0L/5nsijDCGS/X28Khz1izV+3MfZJmFY/js99gCdX9PLveSRyWSN6NHv+Z4Q16S1uwDu0h1WinFCUMsDr1p5xeL4Hkz5iBSggY0GeH+v7t6+QpeWaToaVflRumhBoiz3Z5ZRweo2oqrCzg6eaHvRA/i7DcUZHVTLa1bisBoGdb9hXKXE4YClxymQRI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmap_pages_range_noflush() and friends can install some PTEs before
failing and leave them mapped, and the kernel callers do not agree on
who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
roll back what they mapped before the failure, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() rely on the mapping functions cleaning up and
do not call anything like vunmap_range() themselves. When the same
range is mapped again, the attempt hits the leftovers and fails, with
a BUG() in vmap_pte_range() for huge mappings and a warning on the
small-page path.

After discussing with Suren and Ulad, we decided to put the rollback
into the entry points of the vmap API rather than into every low-level
helper. __vmap_pages_range_noflush() undoes the whole range it was
asked to map when it fails, and vmap_page_range() undoes its range
for the ioremap-style mappings.

The rollback is __vunmap_range_noflush(), it only clears the PTEs,
no TLB flush, nothing has touched these mappings.
vmap_pages_range_noflush() drops the KMSAN metadata when the data
mapping fails, and an empty range bails out with -EINVAL now, which
used to BUG_ON() on the small-page path and map nothing at all on
the huge-page one.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Uladyslau Rezki <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index db669103dc66..e1b376f57dd2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
+	if (err)
+		__vunmap_range_noflush(addr, end);
+
 	return err;
 }
 
@@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned long start = addr;
+	int err = 0;
+
+	if (WARN_ON_ONCE(addr >= end))
+		return -EINVAL;
 
 	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
-
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+			page_shift == PAGE_SHIFT) {
+		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
+	} else {
+		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
+			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
 					page_to_phys(pages[i]), prot,
 					page_shift);
-		if (err)
-			return err;
+			if (err)
+				break;
 
-		addr += 1UL << page_shift;
+			addr += 1UL << page_shift;
+		}
 	}
 
-	return 0;
+	/* Undo the PTEs installed before the failure. */
+	if (err)
+		__vunmap_range_noflush(start, end);
+
+	return err;
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+
+	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	/*
+	 * The page tables undo themselves on failure. Tear down the
+	 * metadata that was fully set up before the mapping failed.
+	 */
+	if (ret)
+		kmsan_vunmap_range_noflush(addr, end);
+
+	return ret;
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
-- 
2.25.1


