Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A391606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ilkeA7U1
Received: by kanga.kvack.org (Postfix)
	id 5FA0D6B05CD; Thu,  5 Nov 2026 13:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D20B6B05CE; Thu,  5 Nov 2026 13:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FAE6B05CF; Thu,  5 Nov 2026 13:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1B06B05CD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B89901A07EB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:34 +0000 (UTC)
X-FDA: 85401933708.20.D35D534
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id C593C140009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ilkeA7U1;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IfXtGijlPQD8Q0olBFqZfgP2IyMiim3PIewkzSs/rc=;
	b=RoSBfVS/ziib2qBVJhuT6AOMOJqrKj23+c+3Tr071htQvIRgOe4NG2IsQqP5D+gusMoini
	VQZA0VzG8hb72TkUJ3jk31M04/zygajIUERQqzuouozA5p42IhdiOyzP/voSGkQF1xSy/9
	/Oaykb7LemhDnOfgOVaHWlIXRVHggrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904093;
	b=zJFMPNPBaMRSbsrH6kWSvuJJAz9dlal71yaUywOuROxupMtsP61V7VGbKIfwvQLH4Rq99n
	TDWXo0aZk2syL42NmOl/risDYDQ7BuDP4lgDakJGYyBDJ03M4svnPrMz0/nxY81fEdtvVW
	I/kSwRbWYYo7o8z1YRU1XcntIgxibHk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ilkeA7U1;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.198 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w4pj5tbxz1eLMMGB1xD6rdBw8N4Lh5gRXiLGv2nZsEQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904091; v=1; x=1794508891;
 b=ilkeA7U1BdPAPgyJAFZ+4tUuZL+39gVX1YgEIL9fjQ5J1DVGSALOYJb+v0HVUzWaT2rnJ0Rn
 qUh3DTdX8ZLKFQCzi8yoT8hMr2+W9/w6LLu/aOUGbdxbpObeEwRs2v/93iSXIXdy7diihat3G09
 OnuGlcUSLHe+YGsR6uJYkJx4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a1a1b608434a8a7d;
	Thu, 05 Nov 2026 18:41:31 +0000
X-Mizu-Trace-ID: a1a1b608434a8a7d
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 16/32] mm: zswap: reject high-order swap cache allocations backed by zswap
Date: Thu,  5 Nov 2026 10:39:00 -0800
Message-ID: <20261105183940.2236717-17-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: axaxwg15s7dh7gsekc8q55u9kbityzzz
X-Rspamd-Queue-Id: C593C140009
X-Rspam-User: 
X-HE-Tag: 1793904092-849463
X-HE-Meta: U2FsdGVkX1+QLqqMXw8KgAKFbsys9u4T3ir5/62RRqFI3Pgk8T4/WCTlJI/p8XYcXh8deQ+Wd/ozUqeDDyZyV2ZPdJCECmx37WUv3xI3SShry8mOSsL2J/cV4NrE2Xs8jcO2zXc0uL2ul1KfXmJ4qFr8zWaG+qQK6uo9o9pUcRD7FsixueBF5UyOR5H3VPWdWItNiEDLnUHcW9dponINY17Bo3OtQWesajxj14idZTTVceR7lvQjXYAZ/ljm9WDFHh2mO/FWiEPv7nTYDKjt6qGZp0rVr+deNBMZENECHnprULf+lvd15H2hsnWa98Wuf7UZI8512IicAgqH+LkLRA8V6JTZ8l2gc79UvNGqJGAZe2JDscv1fc9sOOYTgYzAprdRIr4GIkgqcOG4UdzYmdL5PcvfaV4AMwXpPrS8K4LhGEWgKpiDrL6E4WR5Dx7hhUgmFIOL6HFiuJxZaBMEXeljMRwYdoZpFAb9Ga9gEwU3qC/xB9JFu+FCEa2hlq6l+sVZaVCCnAkSsbp3w9+vtBCRLaBTda8scFhJFWU8OpXKZ221Nz2DF4c6o30Y/W6OGchAalswIn9Mj89H/a7NUrhEaeUXZgR+FgkJhBwwsn9FbivI+++YqVnbQdjSYRxgSW8aOwZlC0aBuHv5WhxVBcYvFBaduXqQriiYVSK99SRLNrDjeucKXKgjEh2qIrqutA7wUd7PX9xgmZLNkFzdnXeYDNO8RznR9rMpyK4U0EDQA5YDe4vJDIHmm0gS71ReO0OrqKI/txxsOjUKN18YcMMak/z69+MtqOP3x3Jiy5rDanCKgm5CjxdTnPjSNmZ7Oqe0/I7VxOVxw38zWZBnAtdjJ1BL+DWO2sGortOypQMepSgwVRtxanJ9eM/siToJMm2Lw8XltRY8V5pa1Xhe7BQmVcBM59B41LgDKq+4Kx/r9Sz5G0jYTmRx7k2KHA+yA35VqOC8XrXA614Y8Fx
 h5Yx/xOx
 YVY1DruzxJ0jrnhFRPfYzGdvrBuReRGfId93DzsJmJbKEsnTNdUwJejmzzRQSVMQnq1t42ibm0pZ+W/VmoOffoPqSTFDB55AOfjRieRtQXGHzMBgXFF7AxchjIJgKXwaio7qvJQCZxpKyIyBIGZ49tfAPBwjjLNm6ThXttbtbVoO7ULQTY7/LRhBPpJjRvnL0yAPGjHfWCw09gvubbea3/VvQBguIlWXAqaHn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap stores swapped-out pages one at a time, so a range of swap slots can
be split between zswap entries and the backing device. A high-order
swap-cache folio over such a range cannot be read back in one go: the disk
read would return stale or zero data for every slot zswap owns.

Reject that in __swap_cache_alloc(). Do the check after the folio is in the
swap cache: from that point zswap can neither start storing nor start
writing back any slot in the range, so the answer is stable. Callers
already fall back to order-0, which zswap_load() handles per page.

Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap_state.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index a8a486b0403ab..f41e740a91b87 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,6 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
+#include <linux/zswap.h>
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -482,6 +483,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__swap_cache_do_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
+	/*
+	 * Now that the folio is in the swap cache, zswap can no longer start
+	 * storing or writing back any slot in the range, so this is a stable
+	 * answer. Reject a high-order allocation over a range that already
+	 * has per-page zswap entries.
+	 */
+	if (order && zswap_is_present(entry, nr_pages)) {
+		err = -EBUSY;
+		goto delete_folio;
+	}
+
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
 		err = -ENOMEM;
-- 
2.53.0-Meta


