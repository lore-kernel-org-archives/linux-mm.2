Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16183CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1700B6B00A4; Fri,  9 Oct 2026 02:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA4B6B00A5; Fri,  9 Oct 2026 02:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036DD6B00A6; Fri,  9 Oct 2026 02:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D171D6B00A4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:36:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33DC114018C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:26 +0000 (UTC)
X-FDA: 85302128772.15.5DED8F3
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C04FA0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq5jaOpF;
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uh2O0hPc7+AfgiciCPNYS5qtLSlalh9WpPtHIZy4QUM=;
	b=XhBgLW/ETjV3czEta5kHytAw9umny3RIxK8o7M7sh5HfdOtzF3DAOdM48hUGWskoxQPFKU
	o97CFZ7j7TaqbNkj+KSwtJg9G3tTgJwDJZoGvwmFtLqASId9CGSgJlnvt+ZS4rLx1IVF2v
	kj0innsXdJCbioeGFUG8X+wXuPQVDxw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq5jaOpF;
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527784;
	b=2JQzyHZt1WajIxpFJktx95/Wf1KDWmW2/WAscNj/5u5K0Pju9VH1tG981MGLybdA8dGJsl
	Pif83smum+XUdAxcFKPRIdxtZTqzhKQgTZAnivGV7ygiIGL5Br/trM1sqDvk34Ir9LBU1+
	YTsJJo9Hc86559vDJbNbOUKeAif3Uog=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XX490udm4Ta6ALheN6Xuua3sT0ZXTpdEDmRJNuiAJBs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527782; v=1; x=1792132582;
 b=Tq5jaOpF3DaN/KjM1sTJ9Kt+qtUR74OOFPzsUK5mu/rJy7iP8nwLZ/U5qbYT1NJrDtUpI0m4
 Pr3i264mbDoSlhbZEgkdKDC4I4tpufbBOvXapzekMxm/smgT4vG8u5GvDFPRUlx8gN8+xMFt9tz
 I0h43YIcNzUzCi+1GNSf+5t4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a2f462b3a15301f0;
	Fri, 09 Oct 2026 06:36:22 +0000
X-Mizu-Trace-ID: a2f462b3a15301f0
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
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] mm/percpu: stop unmapping the CPU that failed to map
Date: Fri,  9 Oct 2026 14:36:19 +0800
Message-Id: <20261009063619.112313-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261009063619.112313-1-hao.ge@linux.dev>
References: <20261009063619.112313-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C04FA0006
X-Stat-Signature: qnh9x31mafemz6otu18dfsanyybbsxha
X-HE-Tag: 1791527784-309733
X-HE-Meta: U2FsdGVkX190EYE7rfoGIwP/aJlLuBSvfzZzh2CXrLmics9SxHyAF9wOgIPQRkPOjsiEfyd71YS+tPSLd0KdVq9GkXMTGmQPZPrl39H47hyNUPkDvCNkEmEThIwCG+V697BmtxNhFc7ZpmQ1g4k1gYgYCLFBI/Kl+pQiBbDaiVtVekMUpxNEXafxtKIeQi9Zpr2A2TZ7GuBARcXMkIz3d1Kzk8tVRgSyXuyytSkos93kVPZkI4vxCqPxfTUEDEghkLnPXvlNu1cDtvfsV+UgHqa0vDGnl5NjXougfgInt2IcXNDn6p1lDR7q4nlP7wbg8tQylLXY1BM5LE4vdK1uftkoXemflx+E7JQJqEIGuRJkh/7qKHXuV1EUwQZFmAnpZBQtuJoJ2KtR2OBJHKCCih4QZJykr6FBhnffKyBGqAjKWpOcsaKxra5P8yCQLbTRnOgXMg7igqQlSZWMKUdJfvbNpoHSWJMLrgUGVIBDGmM7SygfWS0VoHpHlqqiV9Hf9XDJCmCDPb+abLhpQtGP+5FUgAon5yfc/BUEUFJQ9ooxa7Q8s8ESaAJMJAJLWcFxxwysZoVMJLD4kiXBPImvSaiP1vQ4kzwWfBS20fPIGQBXODfkxMZVYbFD/ZaFLpFzwe9o3PaMu4f11SkpKe9JXr9dhzROIebO240tqNJiE2O3f54YObAuA+XONUpPOQCAHP7mYko+ONbKLRPP2aHqBD2okGBXVMixui5v4W478/x1TdtRkqcszhBrs6XQkSziQAS5h7KSr+CgrxYS/fFyo+IzSobOHYw0MkEZPj55uqHPMYJIpRjrujsGvyU6G5t3DpUPfUJJzr5pLBYxI0XLlKUAzIFmxLMnaZ4aIK73l6akgMYKcINOYjCMLseVJCWVyvJlmfI4UcMVm4NFVcHq4o9fxt/JhuINcqqYKYJz5dddwIMnmj/tqs1jTsdZ7ry4zfBw4kvgZzt15hXhlg1
 0OfrGMHd
 VFNR3OU4Kxr7bL2GlQkkn+/jSBBYVheke2fKGU7J6BH9UFvqCDiggNV5xaGrx8Z3Ce1kNYtGgKZGoaCIpA4nDDI9xjsicEuPf2+71A/+hPvt4ojq07gHy++MzVo2aZ3fekScY94V6gFQ9ta4eBDrIJ/B+AIN4vMTldb4qXFlSnx6ua50916MBIw0eeYwtT2gr9aYrlWwV5XUKUe8SojBf6Q4t2OeDifcda+4sa+Ua+nxenA/FKrwqu1BLpGA55SrbtVJZrkN56rTcnQ8qy9X4ayDSprAezHO0Sh42tYHCPX3Bxjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__pcpu_map_pages() clears the PTEs it installed when it fails, so
pcpu_map_pages() only has to tear down the CPUs it mapped before
the failing one.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/percpu-vm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 509d8901835c..59d3a336a6bd 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -252,10 +252,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
-				   page_end - page_start);
+		/* The failing CPU's partial mapping undoes itself */
 		if (tcpu == cpu)
 			break;
+		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
+				   page_end - page_start);
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
-- 
2.25.1


