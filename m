Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A09CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E2D6B0132; Mon, 19 Oct 2026 01:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF386B0134; Mon, 19 Oct 2026 01:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815E96B0135; Mon, 19 Oct 2026 01:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55AB96B0132
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6769805F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:44 +0000 (UTC)
X-FDA: 85338286488.18.43263EB
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05F9140002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXMQysiY;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388683;
	b=PzqcPbojv9ROTKsXzWpF38KkaxAq7YcWoY6SFsbkSY6+Jm/JXueNPHGQxnfIw9z0/ZzCaN
	FHum8hUc0vXvdmFrQrU/9W506a2oxg7Fnl4T0dZTl6k1sdGoxV+/UJJDv1dZltBYVvSUWw
	InFrHxNF6Ly3dZ4QKBzO8awwDt4x6vM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXMQysiY;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+9Qd1EiOisPixLhutF5jakBYAwkW++rsmcsp3LsZmM=;
	b=SKfFMjy918vUCmbrRnUQkWHD81ygpW9ejmBjDjkUWQ1ffFq/f2ZCEiLgWnS7F9TXGSwbop
	hr/GvtfrEisXyNXmdH1s7q2WMPqxLZaRu7VoH4pmVngZ16dxEp9RtEHdulEl3VmMPxW/Gb
	63POf87OPhhob621LjWAQ1zBy7pdY0g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jI5S7DnMABKHgHPyx67JhTXtEoMrV2Dra+q2YxZKaQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388681; v=1; x=1792993481;
 b=LXMQysiYPWO3HNSd53mGDPCBeb7wxM+DE/QZnDjN9xDBrQd4jqK9zLAkXwrrpWtuuZqGTGDJ
 t0/I6/j/BMdpu/oSnujBbSL8nU50XnQWXM3bewCeU0sOZGh8g+eXLub7dsq83fSiCtISOOmN9ln
 FuDA2ysFe5JVIzH50/c8f584=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e942bbcb9cfd9b02;
	Mon, 19 Oct 2026 05:44:41 +0000
X-Mizu-Trace-ID: e942bbcb9cfd9b02
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
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
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the mapping functions
Date: Mon, 19 Oct 2026 13:45:28 +0800
Message-Id: <20261019054531.87652-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019054531.87652-1-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05F9140002
X-Rspam-User: 
X-Stat-Signature: tn3wcbmaake8gcmh9w5maqc1isifg3jh
X-HE-Tag: 1792388682-174686
X-HE-Meta: U2FsdGVkX1+xyV1mLWTRGDu9mxLxPdzKMFPJJ959YVu/STgjEsiOI/1n0+pt9OZWDMfXl3Jxan98la9GjbUKPVgjIUgRB/eO1uxtAXmcshsCeKw0GayQ9xPM6S/PWgGDldGonFOjJZfdnDAFVn3Ve40uQ1WpEoJB1P6SFH5JA1IkWJ9LC6YyyYM+KQt5bHHiRSdJsC/c04NukoreK1WSAoElV7QdIAn/xGNOf0YlNcJVQfcnQNTS2ozbNRt30P43HGosfpoMd8lxBhjyURRY/Kse42oRTQtrVSKQ3nVU+3Baos+0FJxpd59w8ojK4yGF8+HutnURrL7y4dA4Wh3nwN8yqeCrO+Qtfgf6cn4YeB9A1HSkOVQnt7x1c2hZdH8JnYLsY14xh4tGvYB0n1inZkW5DxFJZYMAqxiOhbG+bAzLR1pAcvOCZ5MjhNu+wcN9x3vK0cNw02u9qXpqloh5iMkX/RMyHDztDFqDe2XQLfKOcbsoVlvaLwqoMdRkVsVQyEk2Ab0WAEDDwjxM1O5fAf3ywE7ASc4NIbRwx/9NnriBJwCNTvYg7J9FJM8vKeAak4FeKCqRysfd6PiBIzUhsBJoWr1j1Q32wIMbaILSiNRD6HIaTkwZsvIyzNv6xD/yL2Ki852ysbfqG4Q+idiIYx2/0FYfDCqZe5Y7iTjksqnG2xOf817awf9yNivT5nvZKjy3Vg+Q5OBrosE8X/QE98+hoP3gwI+o/ZBw9PfvY7C16L1Uq01U4W5sfMP/QZ4/UYHJAOepXBz8N/rxP2yJgKeS81TVH0M2xuNbikBIP7OAHqyDLo7CcY8BdGWVmVgX/wUGa7v3MYHa8ihh5ETGpmBJmwHpwoNTluoL3vf8DFmtX4vFio+f4af2B1TBUOwy6UPX4tVtKfF0/y4r7kL7BUz6JW3/57RSgWR18gk7w8kOjL0IjTmcrGl7z2utQgUNc1XEcZ4GekLPTaCipsw
 f+NJO9wP
 xo3tGljGPd8FNqm7z7ooqlQgOmyqK5Cira9ohecdwsXK9/Bv5t2gQDcxcievwlRdv06LtHvvBTqwhpOULTV2qRqeY+gYixI3OD3S6/sks+xiXDQawiSr58uofxybAuHOCCgXPISGkWa0lZwGvuLDd6umOHPbBhukIlSyeNJCtTmEFPmxKpyzHFod1n3A8V9ZdO7JYXbI5Rrf7vyTYFNWzwXyBCM7xiU7pM3i8qO979OcMlDIvwbbdAXkeCZ1kre76TxYr+xgsiZ/IcR5VlTu70I4LPxkm6kpV+uF7QyJsKiRGfShItSOTGOwdDmO6T3c38Zlxye1xGNKjRplek/5syEfslgBg7vichtGl
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
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 44e0eb32708f..75aa5acf5566 100644
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


