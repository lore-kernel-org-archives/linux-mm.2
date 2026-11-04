Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B7E606A324
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MEz0+BIH
Received: by kanga.kvack.org (Postfix)
	id 7EF8E6B05B1; Tue,  3 Nov 2026 19:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1DD6B05B3; Tue,  3 Nov 2026 19:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B67A6B05B4; Tue,  3 Nov 2026 19:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 336B26B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:24:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9D0E12055B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:24:34 +0000 (UTC)
X-FDA: 85395540468.30.1BE0BF6
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0161D140008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:24:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MEz0+BIH;
	spf=pass (imf23.hostedemail.com: domain of 3PnvqaggKCD0ahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3PnvqaggKCD0ahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793751873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=twBYW96D/454ufOiYalNWpWEiQb6CO3slFCMac5mtJ4=;
	b=Rk/toA7A+hrtL7nVfyj/lCpEPUBSc+C9eTd7xkbLs10Ni7AE2ozvGpWV+kWVpEE+I4lm6Y
	ROOua0RLCr6uxd10T7eOju9e5LlNu5H9m0C5jrvzJT5PvOBVwIj4lY32KMmTwLZQNawlsE
	JLhFhXbwK3unsX66rWVdE0FmUEY2C1A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MEz0+BIH;
	spf=pass (imf23.hostedemail.com: domain of 3PnvqaggKCD0ahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3PnvqaggKCD0ahmfihZnfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793751873;
	b=viLbalPj405zajlvu7yj+hJ06NrhugJvcrMizC/bHXAUUSt5547jhy3xf7ZMCSzTqLHMnD
	CrYTMsGWbl55XMwAl5q1MqZ3YYwgxjS6sALl9yKbqi2tDb7mVUULrRPH1M7LDmKyQH9P92
	I30KPh5wi0EnmBPonz/rYgwZw94DDRM=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso559801eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793751871; x=1794356671; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=twBYW96D/454ufOiYalNWpWEiQb6CO3slFCMac5mtJ4=;
        b=MEz0+BIH9KZjd2EKUaalc0dIyPgu4HPcGyZXhs2GTQmtBBeg+cJB8t4uF7TUQs27LF
         cYsNfNNC9L6BV6B271Yr3+3x/uckVPfRnlTCytW+nEBz71lA6sPuLIFWl12GqMla9bsk
         wgjCbMg97CTC18QdVt6ki1B0DJT79bSgikvwc/OhpP0iVmV+cVZuxkdNYdFK0/Pvg5SB
         Jdd6pVj3Q5M35YfusTstR+mpL+i7yEKAQDGMCas/12U40ighpK9S6AlXDwPw97dzQJgD
         QwG4wXoK/kA41+EMkJ1dihxrzi1Ts4dPhuUFEaSqt8eeUiH8iHWQTOSG1+FXwmDHyzcP
         Ugsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793751871; x=1794356671;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=twBYW96D/454ufOiYalNWpWEiQb6CO3slFCMac5mtJ4=;
        b=yhdmx4Ap/b9RIaPV2CdLbL+kD6mUtFQ4ksEM6t+H+X4jyA18pLbxh4gLe6+vg8zP/J
         91GARozWgMQz4CthNr5OxsSGP7sfXdT0C0U8MoFx/Sai/9LE9m+iBcEHnDPSfpDmRVIY
         U6p6X9w9aJFSyRkCT8AqFzPhsi9UkRtjnRyasFaTNk+c0V72H+Fl+jf2pz+iIx6GXbYv
         rtIavhXCHtPFplnRs52K5DzfzzsP83TzXHhJOBrVVvsAIDWvYC2j5rOkIWshqpg8Jvj+
         eCf27loGBnK8h6K1AjjQWYu/9I5mtXS6CjXVTFEwW2/9adLc7Xvn68ydhdEh9J3uaN3m
         yCBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxt/kgg/Ejl9geEzoZnwDv6qVyC1zk3ioBwStfKTvON7TxSRnZgboX/LFkso3dD964PhAT06dBgWA==@kvack.org
X-Gm-Message-State: APuU4Z/ON6vBXKrDo5KoXPQKu83wl15rw1OqVWYY08z7UUUkPAPjLRQT
	f3NZQcFeH/eOnBTchmWJJ+MGZ3mUq9VWyKajkrR1SuUinD62OrhccMJuKnRXhUFPxJSVVEMhAG8
	8wPTPjncnVwlA/A==
X-Received: from dli22-n2.prod.google.com ([2002:a05:7022:296:20b0:15e:bc16:429a])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3717:b0:166:af48:a2ba with SMTP id a92af1059eb24-1ac4fd0136dmr21174886c88.0.1793751870929;
 Tue, 03 Nov 2026 16:24:30 -0800 (PST)
Date: Wed,  4 Nov 2026 00:24:20 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104002420.433876-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: skip lazyfree folios when demoting in shrink_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bing Jiao <bingjiao@google.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Oscar Salvador <osalvador@suse.de>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Yang Shi <shy828301@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i5sducscib4jqiht3jezffzajgptnius
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0161D140008
X-HE-Tag: 1793751872-879904
X-HE-Meta: U2FsdGVkX18nZx1475ojEve+DdHX8SknLI85mih63tQbAsB4U6qt89WmuAd+fdCMd5EqJ2GzbjEC6hO+U/dWLwg5hqq9q/YssGKoCe8vHrYwDdMMQXAYpHTH+AdM9kZLGJVsheplcvCy5FBHw+wFxWNJfWaEeVtljdJuBuSpsbofn+LzmB+Rx+71Y6/3vbYSOwl5WzmerYO8+59WTEnjB3GvL0DbZccqMCB1enxxSorEOmaeJUBcBTcNOw7JYE+PtMdIY4An0oOacPUTyHkh+fXAo2PxKqXEJolJlHPaSFwG8jbBOueQgwNW4UHL9+wRY/XDh4uVVglqcZK5jMG3sbDvZaSMAIoOdvjG9Hdpz2KCaxYzSnRiTrC1h0SzT9wpFGHk7K5LrsC0U5QKsCeXdLGikYNDtCFpZpUf7NDI3aSTCBtSsd5WJa0GQ4gD23h8WRbrpIExdTRqveV00hSwlJdRh6hri7GeObkBBcLZQ8DXTcJfxGZjqHahqvExZyf+EyjG7RL6U6gJwQ+KTbw0qFKR60v8Z0wgjEcvDY+EBYKLOq+ierFTzsK5T8gdb5Kj+SYjQ91MyabbeMN5Kq7bGLYL4NEDHtz8tP7ElTTxmB85Wyduhgt8k7PH/TvVvG/1yUL3u56mqfi7KJD8n0QdTtGwDkwuBnXpy+mR77gOpqV9av/5PNsu7rLTlZ6+Eu5G6U8t6+ez0SqMDA6pE9sdYG6NoVEVpM6FfOU9wir6GyvtxcbvhMOOR8Lf9iiOo6r7hs9kkJY2m9+AeFyCrTLIv2CZ2EZvvveki6/nq0g1xkqiWKGWDRZBOxtdgAhElvPcqUkDdlMp+diBLfcdp9VAt81e1nkcboB3yKTb6x9U8mARM0cbnjgQBYXOkVSj7ZEkZj/3KA6B1waMq10MKFdv8qN/l8GdjSBV6k5pCSG4k86Cv67hGOqREvQP9FLcwKxTWXwg5aETawEca9rskmW
 TZCYNTZM
 G2rhOjWJAlKeXw+/uaxaAYaK2cspUz5FYDTha3hnngH1IeR7rOEPxQTeKTZRz2YJkVBBzvGRL2TvkU+s92PctV69eBvyFPYntIAABVFienqoUHOYjkAuSt9aSSAl0dyQUBV6BfKmj3ijtlf8AVNsNFKf9Ke2kvlxUY0TaST3Y4l7fr/azlYHVl+rl8pK1gB4uUTGtBRJ65wxtT9xAYWwxH6ejkd/e7HCKSfAaL5UAYjCzsiKBEKVxIn8LtIiVqI5Qvg4VaUFA6ymlZWRkSdWX8wLGSc7xWBJQwZUJ8yYs0Ap1UR/OirramRG1cZNJ3bJynx3H5dsn1NTwLs1xcLBbTKf0Jic0ACLUYB43rIr9rkC9AxlMgzMDsx31lTanhX3ybCpQ1NQCqE59slFS7bnrthXsSoYMZ5PaljtbQ0Na8HQwyX+LnDuAl6CEaKozDQY7jOBU3cD2GOdrEK0pbuMAFXEPFJlKkz+KXPo+KiD6nlZJolbefrlgKMalD3r1Ul+x2RKCZ/8wjqLWH7sBC+xNncGopZ7X6U0P1+sg8yP5eyviUO5oDoMXSfAAxZZ9qH7as/Z3RwIt/8yftpjYJVcM6RPRTydo3eaOvpmBVYpWF2hqjl2PMjbV5BvvFoJrSC4luGkiOVvyk0w42ivvfi8vh4XxxgUUlirMivAcqmtt20QQro4d/NIItWO/EUmUJ4GzGis4HC6HN8YR0rs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shrink_folio_list() currently demotes lazyfree (MADV_FREE) folios to
lower-tier memory instead of discarding them. In the earlier patch
series [1] that commit 26aa2d199d6f ("mm/migrate: demote pages during
reclaim") was based on, demotion was inside the PageAnon(page) &&
PageSwapBacked(page) block with a comment to skip MADV_FREE pages. When
that commit moved do_demote_pass above the block to also demote file
pages, the PageSwapBacked check excluding lazyfree pages was dropped.

Demoting lazyfree folios during reclaim does not make sense. Userspace
already marked the contents as discardable under memory pressure. Even
if MADV_FREE is treated as a cache to avoid page allocation and zeroing,
folios in shrink_folio_list() have already aged to the tail of the
inactive LRU, and demoting them still allocates a new page on the lower
tier, copies stale data, and unmaps the PTE.

Skip folio_test_lazyfree(folio) in the do_demote_pass check so lazyfree
folios proceed to the normal reclaim path in shrink_folio_list().

Link: https://lore.kernel.org/r/1560468577-101178-6-git-send-email-yang.shi@linux.alibaba.com [1]
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
Note: An earlier RFC ("mm: Discard lazily freed pages when migrating",
https://lore.kernel.org/r/20200228033819.3857058-1-ying.huang@intel.com)
proposed discarding clean MADV_FREE pages inside try_to_unmap_one() for
all migrate_pages() callers. Reviewers pushed back there because
non-reclaim migrations (compaction, move_pages(), NUMA balancing) happen
without memory pressure, when MADV_FREE pages are expected to stay
around for reuse. This patch leaves migrate_pages() alone and only skips
demotion in shrink_folio_list(), where the folio is already being
evicted.

 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7db6be53f3a9..47448c47fc04 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1347,8 +1347,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		/*
 		 * Before reclaiming the folio, try to relocate
 		 * its contents to another node.
+		 * Skip lazyfree folios so they can be reclaimed directly.
 		 */
-		if (do_demote_pass &&
+		if (do_demote_pass && !folio_test_lazyfree(folio) &&
 		    (thp_migration_supported() || !folio_test_large(folio))) {
 			list_add(&folio->lru, &demote_folios);
 			folio_unlock(folio);
-- 
2.56.0.455.g6c5a503b38-goog


