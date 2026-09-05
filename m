Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D54C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAF46B0092; Sat,  5 Sep 2026 10:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C986B0095; Sat,  5 Sep 2026 10:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5B76B0096; Sat,  5 Sep 2026 10:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 914756B0092
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11DF3120399
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:17 +0000 (UTC)
X-FDA: 85179873114.15.3BA5524
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	by imf31.hostedemail.com (Postfix) with ESMTP id 467F320013
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwzULKrD;
	spf=pass (imf31.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788616935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1j3T5b2cEL6pgSZfKmDhv9K0ynuzYhpAf3KEcht699E=;
	b=E3NDInM3hI8I7YCnPaXXbnv7FGqyWQOxCnQT9ktDn4bCdQGbhn27usJRo0NKCkQDHte49D
	FECrX1NOMtIIYaWKr1XKEdfYWuf3rWn1g40UHBmwO90MJyOnETNJ/zWkDWO42Vg0cCRVyi
	yjklC3vqkW7XD+qH89p3xcUwAnW/qL0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788616935;
	b=RRovTR0DCbZDppysOWqVnedeYDGOVwplOHBgh5wp/alawRhqFDYRe2PZEHpyBKZatRsNeq
	kutAUE98RDZ3gQRGuLqeW3aadfGTwL5RvFWO0RkY9dQzdgUAOh6lirD2uMhtk0NKvLMk9M
	jeUyJqQHzrIrqWg1YL0M1dXZEAPl2so=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwzULKrD;
	spf=pass (imf31.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49ccea58fe3so4461285e9.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788616934; x=1789221734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1j3T5b2cEL6pgSZfKmDhv9K0ynuzYhpAf3KEcht699E=;
        b=cwzULKrD7/e53GSJilToh9dM93qYob/koV9eTlML5Ef5BiHz0R/v99rtYDzNAGf7yI
         TeJtz+XXzlQb3k0VA/1K+6afYlV5EB0TRCjALqbXVuYOeyUgqG70J2gW4fbahys3T6tl
         ntg+zqs0NWZkVyYZOOA4LIx6Ii7kNy9UymlaU4pct06GAOIutecG2zTpXeCAxlCLSzad
         Nf6sgrOS1PaNYMWnrgRM/wEHno3ILJbi4e1EdeXtgXrKYfPknRhIw/IDkFh5mnLRjDZ7
         3NtIG5r3o7ODyq6YYfOzsA1Pdx76Iv7KZMlyiNayuz+fwCc8tomhrtgTwu9PWtYXurD8
         Q9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788616934; x=1789221734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1j3T5b2cEL6pgSZfKmDhv9K0ynuzYhpAf3KEcht699E=;
        b=ruTlOmHOU4aLNlnmIP75MxfB4B6H30h4Gen+BNbyDBu2AZ10vRyxK6W2SGgnekntbX
         ouT8ivMvlEcZ0+q/0AiEnJaPkpBMo75wdcHZWR4P+Syx1j1RWbxNUDus7COJ6E1+N9ux
         Ri5M5S35gTNOGFr0Id+imz+QefJf3G9KcvoimJynDhUnTKJSapHK6qlCNkjmeD6K1xK+
         6Of4+lC1bqfrBpsRXd8UebvYrtR52bF8nwsBXJueIEr7slJp3uEwjVzQScRYGElxg3cp
         Af/Kw8jCrjXezrc0gqZUMbcSVrxMQOG1d/XPX74SPkl64JnNV09F8GVbN/cY3rZ6KMYL
         7hFA==
X-Forwarded-Encrypted: i=1; AKwUvBzWGl47qLDznpN6dZGfgsAxZXFFjzqjsj7iCtlYG3ucXPdnNUpok7EYUuK052dAIcnXQB7GLQ5/Ng==@kvack.org
X-Gm-Message-State: AFuF++ni2qgQ0YRfmvqEO94Ms9szR50h0IaVQyLMCl0RJ6ljYQVIcvmg
	SRJRMEOViXBxZUjqazrmy+G3noQRbmG8hoz/nTBglPZcn5a/9ZB6cuwi
X-Gm-Gg: AYBFou36RahElLiFX1g09+0vxshYgZHjlF5fnOUYjdgAUZLyzZAu+hh7GJm3bYhC9xa
	doV4Arjs/dN2QoUsHnc4mR2ezG6SoK/FalslbFvf1yPaOd/eyv+vBhIIanqQNPBQ0lIVI09G0Xu
	iRmwtyeoYhfbtCr/ECBHGtMPzVjKAbX5eMFqnCE9bD5f1ehDv6kCZVnyVqFzFS6KRP1MNN9rWIt
	Xw92sLu5C17SuAnjEEz+INIoLuPTqvL7GGX7LJQXheg8SIK8iMHKaiEiBr3XI5fu8b1kQK0JDIa
	asXJbQF861RFKu7254Pq5SZM02eLl0By7MtVkUo3dTbP87scygWGicU5XpZCYH9EhSMqjBGFGMG
	6zm4Vc8S9F2VvIXEEGqpZ4DEnaaS8oLIZFyWZ7i7qsK6qZ+Iffzj8mh61iRxZiiOhNRMZ3QmUfS
	Bnh2NPB7DTgaSH0XnM/8CjEynLKixAFYhuqIHgvyGjkQssgFwSzqamHGEsb+nZ3FmRCnyJsjYwS
	DjaLVHMUHKg8i1z0pRrv+apNBT6Aw==
X-Received: by 2002:a05:600c:c1d7:20b0:49c:ffe3:2b3f with SMTP id 5b1f17b1804b1-49cffe32f58mr50527755e9.3.1788616933800;
        Sat, 05 Sep 2026 07:02:13 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf755c22esm149866765e9.0.2026.09.05.07.02.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 07:02:13 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH 2/3] mm/vamscan: fix various coding style warnings and errors
Date: Sat,  5 Sep 2026 17:01:39 +0300
Message-ID: <20260905140140.60792-4-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 467F320013
X-Stat-Signature: nyq56yhw9fidd33iccz98f3c4nemk3xq
X-HE-Tag: 1788616935-206142
X-HE-Meta: U2FsdGVkX1+y6Fpj1uXYPqpGwtJMmG1NHaPBplmKBNR8sAE9wotDIk+pHHT8EZhWerbu9tR5q3ioTiIx65ho6sH1MVMrThihR8c/TML2mJSQUJdEcTil6sU7FkXIcfn0dN0Bsk+5pefozvk9MBwq0OznCVcU11EH9ZlTeMcOkj6FkvstIrhypsejvTOzCIMgxqAQAvxN0cyySslaalZ6bYUhmrbyl6G2MroJX5AwiemT86xUU86H2y5zKHd3vAEEFtCHt3Gsn9rY630UCKFfjaGoUQaD4wL40hcPytrcFUMCRhgLWEWMuaFbWh+YJUYVqYZ2B5snCgRmCwqMRPYvbKwcjARcn2WltKokNqyd8LAfutUMTHOJ0kAdlpHVYZ3X9vmos03cvf43vmlznxHie5VBfX4xx10QuRHrG/TZOgxZrsBMZbKRpac2UILjBjM/VRrDLiGb9SIYrH8wFSd8cQpU8fIvpbNphSJBuc0/e20Be7bziWxYU5C7YosFTC48e1X9U0pRsNDpZpV/oxrKIRqzJieAnaxK2qvSN+r6/sYu+V+dBwHAg0nDuK+KMqCfCOOCwInvRWlvbErlgWjjvjPyd5LLVgRcxuLfq8/BpGJTAR3jN5Tkpi7nQNaQ68puCqwvg7b3fN2fM1AWlQF/RS0aZBZXe/MQj1PV7LFi+NAqqUNEQFXMTJw/gQYo1JNhT3S4zvqLd1wirZAXbployiwWQGmBWTk+DfSsi5L9oKUDmGX9dA6VNR7fJb9zhedNmqCb5BHOlcz2f8Fp5LIFYPAFUhxdKFNRWdILFPId5eNUrSpKdE6Qo4d3VayzYJmGjLstvAtcNYGVg84GCQyJtzpgvtEyVmnQFqi2dDVg27PyeaNn5KqQIuneJO3XF/tvD2vz1zbY/qc2uDlTRQu/WJ+BCE9+peKe9ImDf7NzxBEeZUOHvK7igzdDfxTf3XLkMTXTy9wlcB1H/pZjsvK
 VaAGF4yq
 kNaIPhI7C/5575TOdfiZVU9QRxMe0CSpmSfbi0xH1XGEU/xhvcwNki2Vy17QzVFUuIvEOMd3ZiUflrVVi6MBUel1ebmEFPbktjsEp9lYA+yAeF2KvEIGmMHoNWCcSaZUyqR+kXyimx1CGpX+oIYQ9Voua/LWAuhOHq3pHCGjy6/8f7ZbGlIHR/342iE92bsaCFUzyBHtBQd6cd4uGqcCL+/vuh+ENmqnFsgsdpwH8bsmPLAFuCLVfaii5t1a40670Al1ip0lZujjJbx6dOlGbGgmEJPP4RSmGY/4WyF3v0VfNYmu7Ca9MwRwE5KCIrO22ePL3pVI4EzKCzlvCMGffs/xAfNdiTsqrk09dxGXQyZunnKY7nbQDNShdH6WShQW0L5+cLR+LSdjdnzPA9CbCMqYBvuejHJc1o07sUML0tM+nwRhfMAx7yACPjH2sapWOtB7P0uJMt8EMjOWd4LR8ghNaQo1gBg95sLrWWc1vdMieCjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by checkpatch.pl script. Specifically:
- Add missing blank lines after variable declarations.
- Replace "unsigned" with "unsigned int".
- Replace spaces with tabs where possible.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/vmscan.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..8637cc0910fa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -535,7 +535,7 @@ void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason)
 	 * writeback to a slow device to excessive referenced folios at the tail
 	 * of the inactive LRU.
 	 */
-	switch(reason) {
+	switch (reason) {
 	case VMSCAN_THROTTLE_WRITEBACK:
 		timeout = HZ/10;
 
@@ -1529,6 +1529,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
 			int type = folio_is_file_lru(folio);
+
 			folio_set_active(folio);
 			stat->nr_activate[type] += nr_pages;
 			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
@@ -2073,8 +2074,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
-	unsigned nr_deactivate, nr_activate;
-	unsigned nr_rotated = 0;
+	unsigned int nr_deactivate, nr_activate;
+	unsigned int nr_rotated = 0;
 	bool file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
@@ -2614,7 +2615,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	/*
 	 * If there is enough inactive page cache, we do not reclaim
 	 * anything from the anonymous working right now to make sure
-         * a streaming file access pattern doesn't cause swapping.
+	 * a streaming file access pattern doesn't cause swapping.
 	 */
 	if (sc->cache_trim_mode) {
 		scan_balance = SCAN_FILE;
@@ -3416,6 +3417,7 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 {
 	unsigned long start = round_up(*vm_end, size);
 	unsigned long end = (start | ~mask) + 1;
+
 	VMA_ITERATOR(vmi, args->mm, start);
 
 	VM_WARN_ON_ONCE(mask & size);
@@ -7748,7 +7750,7 @@ static int __init kswapd_init(void)
 	int nid;
 
 	for_each_node_state(nid, N_MEMORY)
- 		kswapd_run(nid);
+		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;
 }
-- 
2.55.0


