Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0CED609B7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0A76B0088; Tue, 16 Dec 2025 10:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156996B008A; Tue, 16 Dec 2025 10:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063186B008C; Tue, 16 Dec 2025 10:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9A8A6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:55:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC208C0744
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:55:01 +0000 (UTC)
X-FDA: 84225782802.23.E992DE0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A77F100019
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:54:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=stZyuU0g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0zVztx15;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=stZyuU0g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0zVztx15;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765900499; a=rsa-sha256;
	cv=none;
	b=6w+pGhUNxM0wdsQgxFiUlNnj0+qRu86Kpgb2vEpLbgS6otPjVNxyUeLhlBDe3rY3I3rRU+
	K14ppAKRPTXzzSYVXI5QJD0IzFRPIu4OVizP83Ot8PFruXaiCoUbchGYuHttjGTDHQfzLQ
	8h7u2OwVCs5wHd+gclf5jccfsEWhz2I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=stZyuU0g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0zVztx15;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=stZyuU0g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0zVztx15;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765900499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR3ffO4xrLecxa1eKRT0t3GVFusO+oJc5aPAffkAlAA=;
	b=Y1zSscgN2eDWY2N+W0JMdFD8g2iqZSkNCQKIJj6BxB+4jS/DnDZQ18fNGSEGee0QbZa/3G
	OU8KV7edlXTOAA3LzJYrXXLNeJFlC7v3ff76WxRJJzEqHCNn3rt7jsRo1j2l7kBJA0IaBu
	wiYzhZPBvhL+YGFK3ilqxoWb31/Z0pA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 43AB65BD55;
	Tue, 16 Dec 2025 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR3ffO4xrLecxa1eKRT0t3GVFusO+oJc5aPAffkAlAA=;
	b=stZyuU0gwxnGvgWXFpl7LuhBB1voWsNTTkvPT+WswZNSV2gPyG9jPGycXsTNNxQhMe3TAG
	Y856XMs1aBUyfvSUtgShR2TbiUeSplax174+Dp1QHSvTqu8nHkq1wmfHpF0UcaLVRJQJ5b
	ODVuvs/OO5uC1TYWZJXHi7jTZVrcCOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR3ffO4xrLecxa1eKRT0t3GVFusO+oJc5aPAffkAlAA=;
	b=0zVztx15yRHE1z9NiZqleDonMvOAGODkKq0/ZEaVDvVEukvTb7pmFKYVhXSUpT0ZOF+2sr
	vP3Nw3WCMczRNWDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR3ffO4xrLecxa1eKRT0t3GVFusO+oJc5aPAffkAlAA=;
	b=stZyuU0gwxnGvgWXFpl7LuhBB1voWsNTTkvPT+WswZNSV2gPyG9jPGycXsTNNxQhMe3TAG
	Y856XMs1aBUyfvSUtgShR2TbiUeSplax174+Dp1QHSvTqu8nHkq1wmfHpF0UcaLVRJQJ5b
	ODVuvs/OO5uC1TYWZJXHi7jTZVrcCOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR3ffO4xrLecxa1eKRT0t3GVFusO+oJc5aPAffkAlAA=;
	b=0zVztx15yRHE1z9NiZqleDonMvOAGODkKq0/ZEaVDvVEukvTb7pmFKYVhXSUpT0ZOF+2sr
	vP3Nw3WCMczRNWDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 178D43EA65;
	Tue, 16 Dec 2025 15:54:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SIhwBcqAQWkSGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Dec 2025 15:54:50 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 16 Dec 2025 16:54:21 +0100
Subject: [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for
 __GFP_THISNODE THP allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
In-Reply-To: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2872; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=++7eyxevsPzdZz3r4oaGv/mi9oN1jPDkXFLxAIjV77w=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpQYDDO9621vlOjfKJDP3he3X3FDlxbK4Z7sw3V
 9mXc8uFKu6JAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaUGAwxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJqilQgAoe5BI5j7ckydfXr0N41i7/T33THXbja
 C1dWnYjnr+HaIFjKCci+iDrHfvHV/rQyL5io3kJmedy+hwFI+4AnS3X4CzotgBbDvD9FkhCIm0r
 GHxfL+5Z4wfUeRSCK+SpGp+IeMqvCUP7Ldwsht2vZr23afldA80K2EAa4GxqCZE0X9wVXwDPT4q
 vCHwfE52c2fL+IVSTp1YaCbmTRgccI+GumBql2M5fXMQ4nv8b1EZ+ZIthCCNEeDtSLjGfrz3w9r
 /0UD80J08Jp/BHi/2/eZSU43Qj5UaUt4tLzgruPdc3AzBQwZ7mRfA0i3TWofqXAUfpQjjlsahcx
 F6VoARvY9rA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A77F100019
X-Stat-Signature: unh8nb6udm675om87x5qwyo635ue9ih4
X-HE-Tag: 1765900499-981568
X-HE-Meta: U2FsdGVkX1+cIxgOMTflqeJfCqG7i0i6a+BKUniDV0Z1mgD36XlXLTRh8rbCFNa90cDZCNY3eRgYob7DHnGnzl0P4iX93OvyGtVtQ22x5rygM0WwWrlGcTptoXsJCBimUqhzIwLzIvPihzeT43/JLDNmuCaAzUtlVgFzNH/AfMtSjFLLNcmkm/U1VbmqNJkiNRze+OMQq3vM1Rjz70/qzQAKi/wLOJf84kEdFsHy3ltTRWL9UVuaox5pCaAxziHKRQFGLL0KL8fJeuWKXsvqezmABFU+fuydgnj+v0CeqUVth/fYiXIuHfD/c9QnNvmLnLTNdf/qr5Nxm0MC6GlOdkgclpwVUuaHcMBV6F+1MeN+93Mz/cwPk0MsATvaQkX6hAsGwuPydynR2+Hywv1jagjTBHb0uoIFqhJEPl6qmXXlZAGl7BI00MYX6mgD6PvfyvhUFOqE8r4lWB+Ehl79BDN8AYy8xxGMvUzmh5v5KWcCrGxa22Yzirm5gZ1WzVp3yJaS5w64UP6aSwwQdc+EIFRXSZ+WZxfl1MvKDSXrYeXDgN7jV9eG8iQ2D60d7CfHL2+yLMuIUMvITvrLCr1JyyYAmKoXwn/AXkecWlI1J2mz6jltsiM+WZnToY55DcTIrAZvyv+UNSVlQfisXTiPlTQjOB4uQEWGze12O9qnjZBbshK22hjdGV1ZKXajN0514gqPLzYBPzNlYBloO+3M0YiM3YYhZ+0DmFHfuN9N79obt09rgbND5effyC7H6crWVEsloWsTVV0QoV0xo1sSnGLkox++zcpgUbFaYk4X0IKC8fwN+ThgH50rJtqH4WJv/PvBSQolrSHX0Jg6eICGDjMQrH91Phhp1clJiTf70IXKOUFZsK45yyCXzKTAaq2ula26fJdB8Eyjh7EjUbVoZwx0iWFHfHbx6T7ftiFcNB7xQNKIKUrok9rFGxQKIWc2oYmMdVfjdiSYJiu1rms
 GvUQRJEJ
 LU3XGSRLxrWfJo1biZzyGTjwnf2WnFzfSrV+THFlqSfX2HH5X6KzF2NF746ysIRPtSFXdgjkw8w3ap4KLYwflRNw0U0xTXcYoiXgQNQg3PFBA2zts6xle5Wcw4eKamY3Kd9UogFtfkqIKHmX62sHBnI5T42gsY0WjBjlYghV7dIrGWI2tAoTT3ZIUZBJ6+v38Y1DkCjufIn6G1tyCq9IYp8xzueFmcrl+s9baJ9tfU5tvW8WrOiUmcfq3p+T8ucW8SegfO1G9b77Qt7wFlTmuVb/3eWvXhxSh+DT/e/5ukWeHhEwJwtmmMRY/xFDS9MvjDFPbP/h1Uxt2DWJ/juzHl4I1qPp79oI5G+vcKjKBm9wLQD5p8iGimzkX9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
local-only and all-node allocations"), THP page fault allocations have
settled on the following scheme (from the commit log):

1. local node only THP allocation with no reclaim, just compaction.
2. for madvised VMA's or when synchronous compaction is enabled always - THP
   allocation from any node with effort determined by global defrag setting
   and VMA madvise
3. fallback to base pages on any node

Recent customer reports however revealed we have a gap in step 1 above.
What we have seen is excessive reclaim due to THP page faults on a NUMA
node that's close to its high watermark, while other nodes have plenty
of free memory.

The problem with step 1 is that it promises no reclaim after the
compaction attempt, however reclaim is only avoided for certain
compaction outcomes (deferred, or skipped due to insufficient free base
pages), and not e.g. when compaction is actually performed but fails (we
did see compact_fail vmstat counter increasing).

THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
which is not the intention.

Thus add a check for __GFP_THISNODE that corresponds to this exact
situation and prevents continuing with reclaim/compaction once the
initial compaction attempt isn't successful in allocating the page.

Note that commit cc638f329ef6 has not introduced this over-reclaim
possibility; it appears to exist in some form since commit 2f0799a0ffc0
("mm, thp: restore node-local hugepage allocations"). Followup commits
b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
may not succeed") and cc638f329ef6 have moved in the right direction,
but left the abovementioned gap.

Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..e6fd1213328b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4788,6 +4788,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			    compact_result == COMPACT_DEFERRED)
 				goto nopage;
 
+			/*
+			 * THP page faults may attempt local node only first,
+			 * but are then allowed to only compact, not reclaim,
+			 * see alloc_pages_mpol()
+			 *
+			 * compaction can fail for other reasons than those
+			 * checked above and we don't want such THP allocations
+			 * to put reclaim pressure on a single node in a
+			 * situation where other nodes might have plenty of
+			 * available memory
+			 */
+			if (gfp_mask & __GFP_THISNODE)
+				goto nopage;
+
 			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep

-- 
2.52.0


