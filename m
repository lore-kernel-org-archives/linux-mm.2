Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56DD606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CKYV6iZD
Received: by kanga.kvack.org (Postfix)
	id D54206B05B4; Thu, 12 Nov 2026 02:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDA86B05B6; Thu, 12 Nov 2026 02:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4916B05B7; Thu, 12 Nov 2026 02:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E3D6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:58:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 000D9A8057
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:58:36 +0000 (UTC)
X-FDA: 85425715032.10.E532575
Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13E41100005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:58:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CKYV6iZD;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mm0f6ZegSc/kIAJAFcHf5HKPATgqgEdOu78KRVCwkOM=;
	b=IaQT82EGuZfvJBIYRv++A/VcvuPJ0UCRjiORJmm1yqzt8R77Riv+7XbVELmwfW0yTiNcUj
	P0H1J5eLBbH1L0G5seNrXb4RB0C+d/Gr+EtQbEzKDEaJf7d0l0YGYxh2VgIxi33D6AXtwy
	BWYCreDaflyATtqrnP3Kwzd3r1dyThs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470315;
	b=gfKqO/sHBwOJcvMUohBvgUHxICrL2zgjPxM8H4JJW98dg6G0RR0K0ZGVk/t2DONgMlVkuw
	s5uP87dw8CtJ2MNQvRgDs0eA/ANUZZyKh+r0rPDpKjLGAJXkeyznhUNboyo99t1NQrOkWo
	Un6DOgSHXr5D8M7N4oSd6Q6IRhpb4yA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CKYV6iZD;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j8LBCrptwcQ++/fqbiB9fY3r4o3bk6mYIL5BmRBs9Dw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794470313; v=1; x=1795075113;
 b=CKYV6iZDRoBsw376ojOHDen9rUUse+0D+4uUQjPzhXoFJ7aSK57sIrW69WOFLaxIFI/TciDF
 hX5u/z+wBOOVHSLDq0HkU4nb3sWYMnTJqXIun1H9htaE5z+dXeCtn51/aOwZbpWzzdkhafEfP6o
 8gtEC0I3Z+EpyPFCfmSdxZaY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 818ae350442c464e;
	Thu, 12 Nov 2026 07:58:33 +0000
X-Mizu-Trace-ID: 818ae350442c464e
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
Date: Thu, 12 Nov 2026 15:58:27 +0800
Message-ID: <20261112075827.255602-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oou9nzotmobd1569mzm9biirur9gmsmj
X-Rspamd-Queue-Id: 13E41100005
X-Rspam-User: 
X-HE-Tag: 1794470314-852244
X-HE-Meta: U2FsdGVkX19al5Bo8U7g8LyH8fN9/x0yMqHcsEEAVGair42/PRAvSplYi1nhLoDNg/Z2BNWfwgHb4Tap8tpGPGmtg5rPn5m/IBunVIvG4WTxWLpHwsTbnnhZEC2xhXDBaUkT7kHSH5JrtuaHoulPe4D28AcAHAWby99Lx2ezgPjhsHM0DwmTCEwwTp+7gyWxPycIYre+bxiPiU4mZlVJzwEPCd6+cZQAdxITZg5woiFTMHFWh5wtxcvxMeMI05VjVvOOPWwDwJiVfMyGfFgKgyik0ZiOJqHlkT092OY3ch2lJy3WGxBl37V8y3uWhRe4rVM+OHiM0i358Snx/zsSm1q10powPmneiZLeVBxfoCQd72NxwtXS4+MERujG4QkutO41V9b8CysH2JruuoWye5JKJ7I4ZIkf636RiFUoCNBxZyvXYb0q6bJK9IHSOSO2KYNzKOpcUDJOmoVulsCBpxQHJEreCzDr/3FnOXL8TiLoOD22qLYkBDfrBXvOeTSKCmWpLdXvjl3iwS7mWhVSGFaMkqRY+6I8+qMrYhFA6+UmBV0IF3kIYEL1uIo1pPUo4mhEmVGqUoR1JyZ3Hmd7tS+z7nF0AJ9Iu9O7g6mu1rAPPRzZ2lAsOgXJs6LHOFjv5yBon8mBErCIZl+tEp0No4Bv/2IKC3OdqG/9J+VWbCV24Mod0lhkW86JAiPBL/Qtx3Stsjm6GoT0n5oxb69hjnUiuw142p6+9a8Rx0bcFBl4Z2QOJJvOUZKfXXb6IPXEkYYIVfa+1lTbHzIQWQn9ftPW8iI+H4GwDeOrRduVN2TCZjwlIkXjh08SAAI/3Jv9WFsgWOXnhpw+MmnvvDlE8vVpx/AqwbdqLdQXz9zLNxQxjJ6UGL82UcFi5fNu8b95oIQIdGKMw506wpNlGk+T+9B6mgOLlaWwG6FoujemQdw/vFWilhmUpl1Uf32IP3Osrz98G6ZZ2/OjTLLbJ+L
 lVKaGi+3
 1S5CJxdWk1db+0VvbVpG7Z/2xlIAHEeb2zS4oT0vKjgu/zF1UlDlnFAH+kn6Sa9AyaUrex/3wms5gT6AJVpKKr9sDoUrXRvQ8o+3z0sY5Doz1Cfb0rY5YT5TVHjYShTSXTWdDnFTU8M8c5iFnVnNKAtjH1f6g48aAKVFQl3TZvN6GuRUW23pDT7TQThn51qE747xPY3KDx2oPNJlTlHdmQMLUxHonmwQY8WeaGh+m3Bh9XSX0B75MBgNZTm7zegWKv+ZZi2V4eid6hYByildMXTdEGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

lru_gen_change_state() migrates folios in batches of up to
MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
keeps local interrupts off for up to about a millisecond, and CPUs
contending for the same lru_lock spin with interrupts disabled for
that long.

The caller already reschedules between batches, but a batch itself
only ends after 4096 folios.  Stop it early when a resched is
pending; the caller restarts the migration where it left off.  A
remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
thread_info, so the flag can still be set with interrupts off.

This follows walk_pud_range(), which already pairs need_resched()
with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
smaller batch for reclaim").

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..47f2cb25eb46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruvec)
 			success = lru_gen_add_folio(lruvec, folio, !active);
 			VM_WARN_ON_ONCE(!success);
 
-			if (!--remaining)
+			/* stop early to shorten the irq-off section */
+			if (!--remaining || need_resched())
 				return false;
 		}
 	}
@@ -5562,7 +5563,8 @@ static bool drain_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE(!success);
 			lruvec_add_folio(lruvec, folio);
 
-			if (!--remaining)
+			/* stop early to shorten the irq-off section */
+			if (!--remaining || need_resched())
 				return false;
 		}
 	}
-- 
2.53.0


