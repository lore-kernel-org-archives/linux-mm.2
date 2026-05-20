Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D73CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2A96B0005; Wed, 20 May 2026 08:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B076B0088; Wed, 20 May 2026 08:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7CF6B008A; Wed, 20 May 2026 08:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB1A26B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:22:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 644B2160194
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:22:48 +0000 (UTC)
X-FDA: 84787712016.21.681EE0B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6F7DA0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:22:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=e2h+4wDt;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779279767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4z0oVpabtVbiM82/tqdgqkFnCkglhDgJPoHBNxJz1XA=;
	b=qGabLL7gjsWgU6rIxqMhihYoPvrlP0tdXLapduq4u4C+RVxyzoPeI+8LT91g5XPXvs+YFs
	UWcEE6rE7H/R5hTpQuTWiCmlVNMedlgwNvFM24RnWb7xnWPJuZ+R1a2NCs0DEvRYzU8jhP
	2lo3zW1fEg0j4TbVmjrQUpDYV29jqzU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=e2h+4wDt;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779279767; a=rsa-sha256;
	cv=none;
	b=CywzHzeJKoIIKN1vS6pD23VAjSKIbtiCOE+jnAf0B5vuUTEdTYIrvuAfWeu32xOAqWdAGA
	DPHA9JoCOYWfVNtWZyAFc1SkySVISjucjwDLnGoTHMkcd/8EiNpD64VWzWjh3L3FHuOztC
	15Qj/HOtlwwaAPTPNyfumSvS9Kox11o=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 3BD33D08AA;
	Wed, 20 May 2026 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779279765;
	bh=4z0oVpabtVbiM82/tqdgqkFnCkglhDgJPoHBNxJz1XA=;
	h=From:To:Cc:Subject:Date;
	b=e2h+4wDtxKs46ySDdWrvJEh41J4vnSBBeCgr1O4RlbOZgO02Q1r0wAaykhNhdUtIg
	 bzcCtQmgtLAcEH5E1mIMrIuFFuEGqrCPCZlOWABr26ShPr/GX9K/wcqC34iHH54N9y
	 N1GYYFT9OHYxQ1LFaPBBFvlfMNPBxO9YJ20nAkZY=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable allocations
Date: Wed, 20 May 2026 12:22:28 +0000
Message-ID: <20260520122228.201550-1-d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6F7DA0002
X-Stat-Signature: gyqpnudcsw4kct6qtyh5oeg39pcx7ssu
X-HE-Tag: 1779279766-620978
X-HE-Meta: U2FsdGVkX1/WXWSq5YPDTJrLxE+nfBWvQ5SObsyJLR7qLY6T3tO89iBvLekOzMR2+xClNcyBW/jDawSEDhaYbHbYvrL/Vb8jUdVjlpmuXwXFhQhZpy9n+6DGT8BFK2fgGXMNH71C5VJmUUB2U1Hopdvr1+JA1fAhazbGjwAz+R4KqwhnPWcP4I4Lrp7sDPB0IPwXwobVFXJbtYcqYEPUrO+ZRPfn6OKPgVDYcUJQGWgDyTAHJKhI8ofwghHr1bE3glwpge6dYENN/wnv+7OJCiAoYRf6WDOPiqAgK0S0kCHd9Tuvf0W/7M0ndy0VxHTqu06tqdZj7F5TK1MnM7LhPgv8XSHZIOLjCYZRGWH100G+3U2FJtZ/6L9zrLRyGVzFaC3Bz+onK7aVxJMRnLFSUYw7lasDwVSnZHig7V/H+FNhcGG5Oig0N15oXxvvFHYMK1la0N7z7KmzO0tMDy2RXo6+STzmpUom+jw/tFZcOxGhkVwjyLr3l3tM31DmrNP2GK5iTRDy+zm4mO9dFUrt1gj3Z+YRRqYjkFLAAG/BoUh5mATINELKaeY9qiAg3mzjgLaAbwtClsJux3vRyNZQsi2RhwvO/gAaaQl1ZBK6Zp03lm5C/kEBbM+nNtCUwg+cw2pW/jd3hnMLr2IWW09WDnCfrISArhed/v8E8VuzkCfIQVAp1x1C9O8gyFUahR4yXQrPUNrupzw22/5X/c3iGQgp4DkxxS7hRyT17/u7PoZ59i9rviPWiMHUX/kjPL2LsKzCbntbKG419j0c/sOUHi5Qs78FMSWSX4FjYaeGiB9uXVdSEEMoHYtE/0dhR1I5+szJ91TrNcsG1+I9Fzi8jLt7ngPytz1M4AC9FUBctRg5qTo11xWyup2r48Yo1BNu/RE8PiWbsy8VI1ZPbTQUaBhcfIgrYQ8zymgn1uQCHFstxn1H3SnW7ulXL72aeqMsgZha9yEjOEK2p79TefB
 Tjgh7PNM
 cXPlXE6DP4kbF85cDgfjEDngghQNMBay+DUoOT7Tgfwmd5lMVStetsyqiW1cTbbli/8ebCKccikytCnupbDmHb95r5DydkuvoAuAVdes+XH8QMH/ynDDDkQU0KCYzZvE/D4X/YlN1OzfDjj0klXPN4HIiiucPngjULrF38OAzx+mBtifwAfGF+Egl01Xb+YgBP7tb4q+V6581dcHvddwf1qGOnvUfOe7FMlqFVcq3TViW2j8gnCajkpy5WrpNlvKMN6FHQmh/Wvw9ySTEMcyivQnB41ItcToWMeaAsloWgUED+0X/3VFsR/fgGICa/2ts2UtzrcSgyIkwi1Izs+rp3Q/TH+7lx4+BKGArXru6xbLJtL/VoXl/S/Ao7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
migratetype fallbacks and keep pageblocks clean. The allocator relies on
reclaim and compaction to free pages of the correct type before allowing
fallback as a last resort.

However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
direct reclaim or compaction. With defrag_mode=1, these allocations hit
the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.

This causes a large number of SLUB allocation failures for
skbuff_head_cache under network-heavy workloads, despite free memory
being available in other migratetype freelists.

Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
__GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
fallbacks and should not cause fragmentation.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
Changes in v2:

- Add check for __GFP_KSWAPD_RECLAIM.
- Picked up Johannes acked-by tag.

v1: https://lore.kernel.org/all/20260518163736.173910-1-d@ilvokhin.com/

 mm/page_alloc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..c5a077de1be0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4811,8 +4811,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
-	if (!can_direct_reclaim)
+	if (!can_direct_reclaim) {
+		/*
+		 * Reclaim/compaction cannot run, so defrag_mode's strategy
+		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
+		 * fallbacks rather than failing the allocation outright.
+		 */
+		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
+			alloc_flags &= ~ALLOC_NOFRAGMENT;
+			goto retry;
+		}
 		goto nopage;
+	}
 
 	/* Avoid recursion of direct reclaim */
 	if (current->flags & PF_MEMALLOC)
-- 
2.53.0-Meta


