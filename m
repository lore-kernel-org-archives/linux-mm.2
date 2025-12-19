Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D3DE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1553D6B00AD; Fri, 19 Dec 2025 12:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EDC6B00AE; Fri, 19 Dec 2025 12:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93456B00B0; Fri, 19 Dec 2025 12:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D416B6B00AD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:39:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A73C4136FBC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:39:02 +0000 (UTC)
X-FDA: 84236931324.24.D71CA3C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72D56A000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:39:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g8aD8C2Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cRlyLSpK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g8aD8C2Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cRlyLSpK;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hf/lTUEyOjdHhftVcSDJEw6iqCRUvPqKZktw5YaALJc=;
	b=mVpac/qxF28uSrnYBM/3w/HOYvzWpV31Uy3Zk3m4+rbOS9iqxyVfZH2ZXX5gLg72RSv5Af
	d7rEnWNY/o8rdnooKyFL5avvRq+rIFy+Ch9s/8i69ghlvK97iAEe/sN593bDtGocZ7ue2h
	+O+OGAPuQlcsfTTHxBR3zqmFPU6RFnM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g8aD8C2Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cRlyLSpK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g8aD8C2Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cRlyLSpK;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165940; a=rsa-sha256;
	cv=none;
	b=FtHQmnLKl62sxAwesC7ntS2S8wifMKvWa9PQRyir4jPlB/GdzZjZp3TiQYY8kbu4Zhyzyz
	gN9vGaxNLwWhsXYue3UboXNBNQdhGjTGPJ5DDPYe4uVI9bMmqyceTG9NXh6jOaE8l+KZV5
	thbfu/hB6vPCHjzvjt7egmnAxI0d5J4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B16B333709;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766165932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hf/lTUEyOjdHhftVcSDJEw6iqCRUvPqKZktw5YaALJc=;
	b=g8aD8C2Qq9/HN0LP+kKMlcwtSmgKSd2bwrn4RtFtpIdFzCiV1dY7iOcOJRybyqWjY/QJKQ
	NoiN8ce0JFxexFNZPwlf3WCGmlzKig31HL3qo6Cdqj0+O06rMswEZs/wYP/E3ruZXk8mj3
	t5nSKSxl4PRGEKoYiFZBWvcjGLu0gfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766165932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hf/lTUEyOjdHhftVcSDJEw6iqCRUvPqKZktw5YaALJc=;
	b=cRlyLSpKrAeVr6z9T+03boUkXlSazvkJRLNvf1lpRB8+jnMNwCitgP2206LmOAe/uIyzPW
	RtxsLfyVrVZqBFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766165932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hf/lTUEyOjdHhftVcSDJEw6iqCRUvPqKZktw5YaALJc=;
	b=g8aD8C2Qq9/HN0LP+kKMlcwtSmgKSd2bwrn4RtFtpIdFzCiV1dY7iOcOJRybyqWjY/QJKQ
	NoiN8ce0JFxexFNZPwlf3WCGmlzKig31HL3qo6Cdqj0+O06rMswEZs/wYP/E3ruZXk8mj3
	t5nSKSxl4PRGEKoYiFZBWvcjGLu0gfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766165932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hf/lTUEyOjdHhftVcSDJEw6iqCRUvPqKZktw5YaALJc=;
	b=cRlyLSpKrAeVr6z9T+03boUkXlSazvkJRLNvf1lpRB8+jnMNwCitgP2206LmOAe/uIyzPW
	RtxsLfyVrVZqBFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91CFE3EA65;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aExQI6yNRWlTYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 17:38:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 19 Dec 2025 18:38:51 +0100
Subject: [PATCH RFC v2 1/3] mm/page_alloc: ignore the exact initial
 compaction result
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-thp-thisnode-tweak-v2-1-0c01f231fd1c@suse.cz>
References: <20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz>
In-Reply-To: <20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Stat-Signature: jdgx1fsfqjuzjk5nwzpf8izswbobafu9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 72D56A000F
X-HE-Tag: 1766165940-727971
X-HE-Meta: U2FsdGVkX18EgsOgBpGlYikFn6ApczGUDoIxi+LcYEl4/p6xNpLEfOir8soyesBvyd2E2un47GTSxmwWWmnRuG4LW5doUsKQ+8e2wOUqv3q7piEvfrOqpt6h3mbBO+AdNfiAyCqpMNszIlnNbxywTWuvdTV17Wdoio793ynTmkpNpUwo6FVbaiOWHQgMDaok7d4kG2DKeqOUe77xeFHUTncHfI+z1gzLz6WgTObbRq1XU9OImsmbq0DNxUSi/Mj14IOofkgTCPzZPezzWXJQl7GAkxpkwmnn9x5VSpmrfjikst57FkHZLD4CdDI2cc1ZcV5C68sXTVu74PlWf+7OBkOVCZwtZrYqndibBkkF8uWq2fOHCBV4rIXGFZnIrD/mqf/z3SqQ0CErPuJY1j2VtBcj25IX7IApGB9ICqXxc/qYuxKWgY9pmVLhosOchHKiDx0kxJv2nSz2LGUokVwPsDPSOc2T8RGPAse+XlqSbXbqOgbfs9AsVrMzZv68Ky0UJGiZXJmHKHMwpSfjHqMIUMfA/8CmelVjXJ5sbcYg4LLSBbOLKKG5PidQHRPUcF2DSndDDuYVPrBqAMrqGNTTNSgLQsOjGlghs5bWL5kKBh6mpydTR9+tZXrY4MZDt2k2SArvM4+LpUOhH3Qrt0SEEhcvpAYfz1qPqGHG2bY5pDuWEprDAMPFxEtcajXmoUBAjhsPbjv6ATJy0vyW8jDxJ/WdP2u/7palkYN2j2ttF6qjKjl6drK1rvSuOJ65UbkN/LeIsb37O5mmcAwrQiFk7xtaLyaPRvAjasTh0R13VKbol7KRGxDSNXtOMLf/hl3l0FGPPNgp4yJI1Nz0NK1eYegBDqghgmEsdUjXyX45n+smJXQHnI0U6HrwH7YUut9Q55RXOzUVVUke0z86+GcSJ3WcgboVM6tCUr62+t+W2WDpnraa55Gn4zBk6W4HNaYbC9Xg5K517UV/1iSNmIP
 MtBKabdz
 3RYqXGIHH+xEmsrsk4gIMMOgsLry2yqEeiJ/jkn5aHOsMqPGlfaSqeyJIrCXO0YTbSobcvlkW+9t4+nRSC3YJlhIz43cTtF5lfB2Q8nP7zONisme93RGZ8w6uKfIJ2WwrAJhYN9D8szXGKRIbEA9ujzGmRbDcFnJunMX1R5ioUoM3P3eNlDRZ56ZRvgyn9XlYt2a2ctf2krgAtNgxvJd7ZyIIIGFPPSl7NWPQTgtQxXmBgFYxg305jexLtdqWGhcKpQH5pRgGSWiyNlz2845iuMrIUwik5m6os37ZAq0VVR/YJT1ipmn31q5aWmw4UlWltVeX8p7YpheNkr/A5ujD3UQeDcQGgEpf3N4p8DR/PZyhKIRDn57Wpsljtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For allocations that are of costly order and __GFP_NORETRY (and can
perform compaction) we attempt direct compaction first. If that fails,
we continue with a single round of direct reclaim+compaction (as for
other __GFP_NORETRY allocations, except the compaction is of lower
priority), with two exceptions that fail immediately:

- __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
  behavior for e.g. THP page faults

- compaction failed because it was deferred (i.e. has been failing
  recently so further attempts are not done for a while) or skipped,
  which means there are insufficient free base pages to defragment to
  begin with

Upon closer inspection, the second condition has a somewhat flawed
reasoning. If there are not enough base pages and reclaim could create
them, we instead fail. When there are enough base pages and compaction
has already ran and failed, we proceed and hope that reclaim and the
subsequent compaction attempt will succeed. But it's unclear why they
should and whether it will be as inexpensive as intended.

It might make therefore more sense to just fail unconditionally after
the initial compaction attempt. However that would change the semantics
of __GFP_NORETRY to attempt reclaim at least once.

Alternatively we can remove the compaction result checks and proceed
with the single reclaim and (lower priority) compaction attempt, leaving
only the __GFP_THISNODE exception for failing immediately.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6f5e1b902999..9e7b0967f1b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4767,44 +4767,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		 * includes some THP page fault allocations
 		 */
 		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
-			/*
-			 * If allocating entire pageblock(s) and compaction
-			 * failed because all zones are below low watermarks
-			 * or is prohibited because it recently failed at this
-			 * order, fail immediately unless the allocator has
-			 * requested compaction and reclaim retry.
-			 *
-			 * Reclaim is
-			 *  - potentially very expensive because zones are far
-			 *    below their low watermarks or this is part of very
-			 *    bursty high order allocations,
-			 *  - not guaranteed to help because isolate_freepages()
-			 *    may not iterate over freed pages as part of its
-			 *    linear scan, and
-			 *  - unlikely to make entire pageblocks free on its
-			 *    own.
-			 */
-			if (compact_result == COMPACT_SKIPPED ||
-			    compact_result == COMPACT_DEFERRED)
-				goto nopage;
-
 			/*
 			 * THP page faults may attempt local node only first,
 			 * but are then allowed to only compact, not reclaim,
 			 * see alloc_pages_mpol().
 			 *
-			 * Compaction can fail for other reasons than those
-			 * checked above and we don't want such THP allocations
-			 * to put reclaim pressure on a single node in a
-			 * situation where other nodes might have plenty of
-			 * available memory.
+			 * Compaction has failed above and we don't want such
+			 * THP allocations to put reclaim pressure on a single
+			 * node in a situation where other nodes might have
+			 * plenty of available memory.
 			 */
 			if (gfp_mask & __GFP_THISNODE)
 				goto nopage;
 
 			/*
-			 * Looks like reclaim/compaction is worth trying, but
-			 * sync compaction could be very expensive, so keep
+			 * Proceed with single round of reclaim/compaction, but
+			 * since sync compaction could be very expensive, keep
 			 * using async compaction.
 			 */
 			compact_priority = INIT_COMPACT_PRIORITY;

-- 
2.52.0


