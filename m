Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD02606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xl9PIEzi
Received: by kanga.kvack.org (Postfix)
	id 8038E6B05B8; Mon, 16 Nov 2026 02:14:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAA46B05B9; Mon, 16 Nov 2026 02:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0DA6B05BA; Mon, 16 Nov 2026 02:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 565766B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6F73A05F1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:10 +0000 (UTC)
X-FDA: 85440118260.02.DEEABD2
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id EAA87A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xl9PIEzi;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813249;
	b=E/hZOyijbR60S8ZDgHLYVtBL1QoqiCWiN9pr3CFqy9mwLQGGU80gf7mhZzcXoAC+eGpDB9
	Q/0N7riQ7aGEtvOygIXZGD9ntSQCVY1kbpMWbpowyu5MpGAIYIBqTPA/3l3SUG8/FRuxlw
	1hz7ZozitZqBFT/lMKzsQ/DqQJp227M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xl9PIEzi;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGjQzFT7VU9SxHj3qvvDunZHrMSIb/1khNf+vVXHuZU=;
	b=RPK7sTU3IHfDJhYXrvRofwFW1CxgXO3w0LO4936ZvPNahcRXdSp7nSyx3V09aWEjeS7jEk
	y11wgrjqP7/iXb8tkiG3Ds30f6QJdM729lQzvcqLBSkvNpbKsftH+R3jUM6Q5X3O2YaCfz
	2EaIOTQw19JMW2IT4Y0YwfOBsEk99LE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ohj0Q0QgPbLqG15axHAo7Ym3eVCB3YLiih+Cx6SPRpc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813247; v=1; x=1795418047;
 b=Xl9PIEziSToTgPfkrHuc1CeGEyGSWUqpioezmOLQIxRRv3kaubXUp5G8izZTL2NgSaxhvaRs
 ZRNYhoUKgBWSDFDUHXMXiqL6ADP3qQtQRbdpHgq8Oea8ST9LQyuFSWuIEnsba7eBXPPmMI8lpGn
 xOtjeaU/Ip51VExOuWp0WoY0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e45f4b823b1f79ee;
	Mon, 16 Nov 2026 07:14:07 +0000
X-Mizu-Trace-ID: e45f4b823b1f79ee
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 05/11] mm/vmalloc: only flush the cache after the vmap succeeded
Date: Mon, 16 Nov 2026 15:13:19 +0800
Message-Id: <20261116071325.263682-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygjz5wanqfw3dna8sr7m1a54sh8uxd8i
X-Rspamd-Queue-Id: EAA87A0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813248-30182
X-HE-Meta: U2FsdGVkX1/hgkRJqEeRpo7/shqMcJGBqSWchGQydJ54qzdm2H1tzHt0GVOxBm8qQEMepPJ1enB4t39rnIXLLanRGUYNyEn3zcELpI9TyQI0UbsgDLcjC2gVYegAlI+m3bRzmVJiiCTyem+oLzH5YBAtNSKso5fPL/5wDtTjHf66lNzN0LZUE24lIW93/p+xtByTJ7TImPc883LSavZPlHvAorW1ekHEVqpX3VtriRr6tR7NvnEOBJZ6tG18LmfvA5xxGDi6Fh5NzsUKgaRve6Rk0+lONvtCY2t0FyY8MEFsXRmYXo8My1RM7YTUmbc4OWBhNTWyLsyK9XNToa7NpGdm41JkrTC2JHfBAo/M+ND+WjrT80yKkogO3x2MfJIvBCeeO9Rm2d6q/8tJCFtlW2KRawKXJPCsv8S2zt75wmBMp0y2jT+A+kAHNL0rWe0ctS1hPTlGHyOIJIM4hAJ8DBKXC2lqmOsZzOSewxTsMJRgOURZlluqgYWaNi3wkqfgfXG8DGFuSlkyJ1CBJ90CIgxFNd9hM4CZQNozwt7rdA0whJSrXf4TTO3oGjNkxL1nWA+woW0I4GEvt8GQXzkmwE1KBD+/C4/mTawVajeN/TGx/+pbKRFuFGEodsmhCYyWI3Lvy/VNJL+Y3W6KUZnNt43KwvZOQoJ7zLFBJij2LGNLAAoRzc4tD6vSxc//lmkh5KMABDQKFmlhf6m4Qs/Uy4Xur6sN/lX/r3hMUU9/gvhE4xrgS1l9RFYu4P5f6kjlabi+Jh6BRtYTJk3aB45xfI1fe7Y1m+JAneFiHVfm0Sd9nQQGslfqsGGXY58UghaYSm1NzjrgA0swu74/1BfU1rFtp49KKL0QSu9SUdI9ElAxiAxS6XglRXFDz2PWy9oF2lvj71N8H+WgPowNZhp1tL2KlhyOvmuQMAnoyrxcQwHE01qT6cmTJsphfbNjaeJ+W/lTb8PVlIvAa27b9GK
 fg7C4UYN
 G63MAQKm3qVXbKhFZCo3ifbId/lDJKk6CD6RXOtfmvH5GiOeU9Dxyo49dAg3MGxqjOcq/sSQQkBlVhqzGaSBZLRJS0G1k4N8FUY67uiQaMGrSjP3R3eKzNKcWfxJu66oFo4ZBQGndiMLwwBhJ2bNbrfLh1jeSsUvtrp0ygpjKIgvy9AIhWK9BXB4s9N3EhSc3t71jrV8MTL0H3ST5znlU9iUaH55cQdPY0o1Pe+ilP61UK+oJXP3k1IH980BxpEjsgsbU06BcEVKLl/beJ0kqvd0ao4/3I4tEurykHazeHDb6evlzSdlbwXT6zJIw/IH60t9HyMvQ2QMcIrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_page_range(), __vmap_pages_range() and vmap_pages_range_batched()
call flush_cache_vmap() before they even look at the error code. A
failed mapping is never used, so the flush is pointless at best.

According to the Sashiko review it is worse than pointless on UML:
flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
PTEs into the host OS. Flushing a half-installed mapping therefore
leaves host mappings behind for a range that was just freed again.

Only flush when the mapping, and for vmap_page_range() also the KMSAN
metadata, is fully set up.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e2b63cb1592b..d99d7710e1ba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -371,10 +371,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
-	flush_cache_vmap(addr, end);
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
+	if (!err)
+		flush_cache_vmap(addr, end);
+
 	return err;
 }
 
@@ -763,7 +765,9 @@ static int __vmap_pages_range(unsigned long addr, unsigned long end,
 	int err;
 
 	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
-	flush_cache_vmap(addr, end);
+	if (!err)
+		flush_cache_vmap(addr, end);
+
 	return err;
 }
 
@@ -3729,7 +3733,8 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 				pages + batch_idx, prev_shift);
 
 out:
-	flush_cache_vmap(addr, end);
+	if (!err)
+		flush_cache_vmap(addr, end);
 	return err;
 }
 
-- 
2.25.1


