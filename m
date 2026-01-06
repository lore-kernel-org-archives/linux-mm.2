Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D0CCDC167
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E666B0098; Tue,  6 Jan 2026 06:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C7E6B00A8; Tue,  6 Jan 2026 06:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B626B00A9; Tue,  6 Jan 2026 06:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5EA16B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:52:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8026C8BF60
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:50 +0000 (UTC)
X-FDA: 84301377300.26.AFD6580
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3DEB81A000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FlhGfaBz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8EtBhI+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FlhGfaBz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8EtBhI+;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700368; a=rsa-sha256;
	cv=none;
	b=7fbYCmEWqDP2PGuglJ3vW89luTzOwmXwvRz/MV+GBQHgn6GRYrIDV63K9+nGK+GiPK0F3c
	wRR6R+MlPkwL8O3uba8zck/nDk9DsKK9CkJ01diSm9ziqDcM5CHSx+5D4BMY5F1M82tiGS
	8N75XXpgbfE6DaZDVVh1Gp6mk9YZRfU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FlhGfaBz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8EtBhI+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FlhGfaBz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z8EtBhI+;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaSHlvLRbEa+D8dhJvUczkpVUEn7xfSA0sZfubvINqI=;
	b=waQUgOVIhw+FscjYAh6oe8dUgNEdXUj1RG1TdnxrU5dB4QF06yoknoaNYKDV+0/R33DFKy
	wvJ3IkFbFpVzCetcgXHq2ZiG5daXM2jwmExZQ6uBHc8bYXCGhlkyw3mr0SxiB08t57kpsP
	ofZOk1cxQtIlBwua9gjgM/Y6R2dOm6w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 118D5339E6;
	Tue,  6 Jan 2026 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaSHlvLRbEa+D8dhJvUczkpVUEn7xfSA0sZfubvINqI=;
	b=FlhGfaBzEx21fCCO4WNjZF+weLO7Amms+ev27Z8agBq1ehIpDOqQC+itIK+EFYLUJqHUGR
	tcNrd2t37TDyE/fy2fXP86qdOaE9u2gG1Ar8pRaea9QN2tJfHEl8MFKLzMnwM6KYVFd8AT
	w/uyFmLDwdQMj0WOJHaM8i9GUtrJX5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaSHlvLRbEa+D8dhJvUczkpVUEn7xfSA0sZfubvINqI=;
	b=z8EtBhI+SNiZF2LFXAb7g1V53UlZ7Ajfg6XTcTz6xyEhG7IeTIKp3eMosRBPiBxs6Q4669
	ClnCmrMzjspdE/Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaSHlvLRbEa+D8dhJvUczkpVUEn7xfSA0sZfubvINqI=;
	b=FlhGfaBzEx21fCCO4WNjZF+weLO7Amms+ev27Z8agBq1ehIpDOqQC+itIK+EFYLUJqHUGR
	tcNrd2t37TDyE/fy2fXP86qdOaE9u2gG1Ar8pRaea9QN2tJfHEl8MFKLzMnwM6KYVFd8AT
	w/uyFmLDwdQMj0WOJHaM8i9GUtrJX5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaSHlvLRbEa+D8dhJvUczkpVUEn7xfSA0sZfubvINqI=;
	b=z8EtBhI+SNiZF2LFXAb7g1V53UlZ7Ajfg6XTcTz6xyEhG7IeTIKp3eMosRBPiBxs6Q4669
	ClnCmrMzjspdE/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6C6C3EA65;
	Tue,  6 Jan 2026 11:52:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OOAOOIj3XGnsZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 11:52:40 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 06 Jan 2026 12:52:36 +0100
Subject: [PATCH mm-unstable v3 1/3] mm/page_alloc: ignore the exact initial
 compaction result
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260106-thp-thisnode-tweak-v3-1-f5d67c21a193@suse.cz>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
In-Reply-To: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DEB81A000A
X-Rspamd-Server: rspam10
X-Stat-Signature: i6n1sci9u9x9f54ekfpoukrzsa6fwaq8
X-HE-Tag: 1767700367-612583
X-HE-Meta: U2FsdGVkX19zs3807bhvpVnCz2NgdULQnbBSYY0wMRZK1ej1LuwfYndY18cnGDGpchb5gs8+2E3gedR8z28i7ao+z+wIulkGZN0hI+PGVZm7eBrR/8VAw011XLBx9SYV7EFyQMNicPmjEWVTfauk5xTnu/ElvvpFQ06x2O9tJR0jq6QGBdsbIYB23IDVdQb1L4oxIqOuPVOcrhUA2hWB42XvGI0LQyrOvWU1IoJYmPiebbUUbS5o2Aaqg+A+BZnaXTT2IHQkutFk3ce7EvdeTycLh9D36nCnMRe5oHFOpuRkJCBJkQAIN7MquelBr0Qbkp9JuAVCaiRhuUU+RZfhiUQSbihnl9d87mD7U7B0QYpQpTiHyIQBmZsxY1oGQojuIyBA4pTCtOqj2+dCjt88Rl2Iq3pmEgxbDRZqP++YG3P7+senvrrOTeFkyk9Rh6qIJDIpdD0aRZ6vT+C7nnolcbVjgu9PG5OHnPCPvdpKGG1I1fMtFi9Fs0NIDPi6ymVjoJidK68ug08BOClaJUlp6BuVvcCCM/0LIAkxliogBg2pUDCVIY7bkLLjpsMQiMz/kw8bJxavpbJ1Dd0C1rT0M1oK6Z8WdZPfOZ6EFo+iiTWt8Jgmnjm4DgbB1EWvAIR+ovVcBU9iow4Blf4YsG5zPEFHt3jaHh0Z4cEadICYyrax7NdH7Aq/APbkYXhDg6xrvs8PhKlS20pHS0QtFYZbBUZfu2TpegLcyTY6mb4uJyhI20NVdsCOt/iVod5rlXg62VJG5wE+UccoWIplhX9MiTk7aIX1Myhc1uzNOWB7g723sCHlkBi86Z6Vgo5oo0auvSaDp9NHHyrv613n5dE3D1P9/nBctuC07pTYypPgz1zV+SJ981aWjxb5VgSAPfWy76QZKxxtcw76dsu0qlhdnpEW/wwM2yn0+/72CzHUJjNpmNfAhj4bFy2QOR/moKL5BiKk4kVm6VbEKXRl5en
 TBl2lCLJ
 nlqZwtslDaPg01BtzFpAkUw/0Szuut6YvCOA/RfUzleW35TMklXIGZon40eOQ3mleVq6JnIdTRW7Zwy9Hym4DHiboqTOR7K0iEvw16tLNKxvvXR0/qqMXf7YHLSLRsOz4prTQClbyyoeBo6qxqSO1FSHWplqBAOVSYxkV4We8MJbHpgniwwRhrJrHe5vpsVCUksA6eHLpj0F9ceLAoD3Rk7lRaVYM1z4tASJap0YFBtA1ITtVaYCe0hcnPyDVWS88bq5uu/EMQKJtUG4uSB3692VxnF54pWIJYbKrIN3bCmkP78yyDN90+Xv2jlUKWCLo5Y7zeXe5dEq9WfstvoNWLt41tr2UaU0zAjDHPqg8B2axt7fg1j3XbW5h5A==
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
index ac8a12076b00..b06b1cb01e0e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4805,44 +4805,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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


