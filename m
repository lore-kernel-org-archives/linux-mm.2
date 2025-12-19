Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762B6D7497F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70BB6B00C0; Fri, 19 Dec 2025 11:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E6F6B00C6; Fri, 19 Dec 2025 11:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20F66B00CA; Fri, 19 Dec 2025 11:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B37536B00C0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:32:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67FE41602B5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:32:06 +0000 (UTC)
X-FDA: 84236762652.06.C14A00B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id E3E2C40013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:32:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LKRdhTKu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1HLpZJUJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LKRdhTKu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1HLpZJUJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CAudHSrpXh3CU5YL5KL2UurZrIC4rTsxcgP4TMaVjYQ=;
	b=2N/LiA3vPDj+osU91NEbi9pqrRPyq44ak3+pnLuVcVWAgupmKgjsuQf69mvG1ZyqalCt1g
	OIoUc8jTHayt5XZF49QWP/uhdAkrqwGrGvvHmNCFcytga4X+YQWnJwpjHPnj7Csyxv2q2B
	7e6CqGOGvWYtxqd2WXwpUNomv4sodTY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LKRdhTKu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1HLpZJUJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LKRdhTKu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1HLpZJUJ;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161924; a=rsa-sha256;
	cv=none;
	b=fK/OAxq+eXeYLCZc4E/TmomWE9RayLQoeUBZaJa56ISj41sdpkRStt/fp2SDv/7g245zMV
	uEmvAe2ogk7G0vqxorWC9NJKDiQePDL6ldRWEeNo7RJwpZ0dlevJcATH2Vd4DZz3Z+vLCn
	eAY8QewpfwtYj6NIPYmrb+9hne1XOMU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 588E533787;
	Fri, 19 Dec 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766161922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CAudHSrpXh3CU5YL5KL2UurZrIC4rTsxcgP4TMaVjYQ=;
	b=LKRdhTKuRb36r7DlkmSOZ0t461ktkSzspWuTKU7oC+J+C8B5CS1LdWZObT6qA6Sf+nYtD8
	b9svTf6AHrkQX1T+nMmGf1Klv899+Jom5rAzwul/sNuDn+izA3rj0+EcZfy28uVDK75zvF
	suTMHJTeuWZovTG3EZDW3qcuiC6uUAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766161922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CAudHSrpXh3CU5YL5KL2UurZrIC4rTsxcgP4TMaVjYQ=;
	b=1HLpZJUJj46uTMQ3UZh94kYA4qraEcX+DL0Rag8x6zygORU2DHwVWMnniOmLGSMjJASE07
	1DlHY8tFQoeXTgAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766161922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CAudHSrpXh3CU5YL5KL2UurZrIC4rTsxcgP4TMaVjYQ=;
	b=LKRdhTKuRb36r7DlkmSOZ0t461ktkSzspWuTKU7oC+J+C8B5CS1LdWZObT6qA6Sf+nYtD8
	b9svTf6AHrkQX1T+nMmGf1Klv899+Jom5rAzwul/sNuDn+izA3rj0+EcZfy28uVDK75zvF
	suTMHJTeuWZovTG3EZDW3qcuiC6uUAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766161922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CAudHSrpXh3CU5YL5KL2UurZrIC4rTsxcgP4TMaVjYQ=;
	b=1HLpZJUJj46uTMQ3UZh94kYA4qraEcX+DL0Rag8x6zygORU2DHwVWMnniOmLGSMjJASE07
	1DlHY8tFQoeXTgAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DF993EA63;
	Fri, 19 Dec 2025 16:32:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KH3NDgJ+RWlZUwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 16:32:02 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 19 Dec 2025 17:31:57 +0100
Subject: [PATCH] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
 THP allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
X-B4-Tracking: v=1; b=H4sIAPx9RWkC/x3MMQqAMAxA0atIZgO2qKBXEQdbowaklaSIIt7d4
 vj+8B9QEiaFvnhA6GTlGDJMWYDfprAS8pwNtrKNsaZDHzXtN4YolOTGtLGGOBMufKHryNeta60
 3DvLhEMr5vw/j+34VQI3kbQAAAA==
X-Change-ID: 20251219-costly-noretry-thisnode-fix-b9ec46b62c1b
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3594; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=yLlNUr4e/3dDam3E+ZJYlER9nygC67QpoFJSvoL4vy8=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpRX3/c+5SwcVpTW7/4beFgKEE6NWT0yP5IsL7Y
 YPtR1rbQhGJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaUV9/xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJrGHQf/WNkFaa2BcbmYkpqHjiiEYv81gJ61jAW
 80/mq9Ny0FmmRQB1SCKWCqeuwjSUECiD/z30Jt+otEr0xUGx5nJP75WVki+LCWGKkvurHOPy8zB
 7BTRRFRj1yUyJ7cmI/PGOPNb4ueV1/3EtYq7mkHXhiWWNb8+c7fVmcwc8/m4y1xdZKv8EzAvalg
 a/yVeKDjdZvUSBSOGqeSl6WT8qzWKMjIKQd5g/HOzHQFCU+wQUyrdt4/feB7Oc9M/OckCTVllbI
 btL8VrU0KWrBmNGT1yJaSi8rRX2comflr1XrIH2lyyB3p9haher9rWz8t312V5MbkaUFiKjeY+M
 I40Hb0xqTXg==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam02
X-Stat-Signature: x96kakgjhhkdhqzr7qtujrnt7en9zmgc
X-Rspam-User: 
X-Rspamd-Queue-Id: E3E2C40013
X-HE-Tag: 1766161923-310462
X-HE-Meta: U2FsdGVkX1+HB75Ucf8dhpOl/LNFKjzwl+OzmzYMipMlHhN8Xf38el9dEIbSB1ECt+uW4u2ZUhuirYZ5I8DSHHHb8GKRxLKZFugnleCsXrU5mk0YvK0SJ/DjhNWkaSx/d+OsfVfhw77f3GkeTl6KaMc8swnfom0n5wQ1CDxzC3kxuAEHdRnWXYkiWH3MgCDb9AaFWOBYRGj1SkiGO8gmurpVhIv4Do4TY6cXudS7JGrYFTDuRfOUPaXbLRhJglypzYoqIotD9jTRKNHn7Qw/N7UwRALc6blHO1122L/Ic6MjgIOLpIp+q5wIa+5c3uelXYdHAt+1uu/2W+T0KcnnLMMKxywnd0GpseIpLNlPOmuCGXzkeNLE5Pb5WkOAhWBTY0un8dCe4oCm/ERvK53H6eZLQX7BxdSCHhMXbAWqeQ4g15ItMEe3cK+SOo6g6cUT63apkdYF4xpqX+FUKftF/xOGxyKgWSktVZ3JRTHQE6HHP2SV44VcYhC/zeyV0ACG0Dqy3kn46JHtj4beVPXXsT9PHRrcyUj3EOLA0hEbuoGAEf+Ak5hC18dbnKiR7ZGzXG8krg0mCr+E8g51pGfy2N3Et2oc3DjUGBoBUk2H310KWT6GUfV+LSjaLBY3bagYRKP0F40ajGAdiHh1dkV3o7bJlLNnZ631zL0V7AMH2f4ruZPQpuMsR4cF/NgdLsaUTwbI0nmVA3I7eoTLjzVQ2HvTonwaLXiEZFwRQeBokkS+VB+EZVz1oOGjqobwiuhijRVYK2s/yxYXi6No/guNdhK9mO8Gk3au0HtBFLL6hlNTYVnEW5vEH5SJWBpxHv0pH1Pxi0a1Y38S9az6rFAlWvcEuhOU0gWxLFFl992fjD6lLjaDJDDZf87GcKMgNfpCXE2uQkn/MZvZJMyloEUZtOB9YktvvN4xkZR5ouwBZN5/GZpJ9yEsFUjsegXNvd0dFBsEcE22UuX7Wg8tNz+
 5DJ2nZPH
 gdwZ3VieS+nVi/I16YDGzMw4YV05pJwN2/aJ5P8FeoEbNhD1qQrtRJS6br4SsUSf9V86MZZrIpgXQDHG4YIZh5dDe305Iak22BxfHYmwucoWoOxoYv3y2u1LhZZoOqTK+qWVqwAR/2pKoQFNvM/9RReELeRfj7hFJXYov/ajTYGmqcCp/SoJtDQCx77RExbbFCnnOoZKJMMF0FBu5tUiDj/MuF/wjFo8ygu6BHqUnbVSddJmDvibD/x4jn/G73YeM5f1IK0wsF/UX1onAPH25mBjtltT5WGhpA/n1XyuQDPxzlFoDSJGo3943txHieDGcrODDFxOSK+m+MY91IZBi/bAj4YhzLYgjKd2W2uxgVe0m3LUe8pNjcOE6sot+WKUUOVxeqcgQamq4alfrHmgbQ3mG/B7DRK56LJ1zt9FOvInEQpMfDnFlvXCFViJpJFn/lFY0vvTZ7TldiC2dllIN1ZwChXSF9rkw4KJgwfYk2Sp1aqL3jRzext4Mrks8lPghtCtk
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
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
This is the patch 1 taken from the RFC [1] with review tags applied, and
should be ready for exposing in linux-next.

The rest of [1] will be another cleanup RFC with changes according to
feedback and likely to result in more discussions, delayed by holidays
etc. So will be posted separately so the fix is not held up.

[1] https://lore.kernel.org/all/20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz/
---
 mm/page_alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..6f5e1b902999 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4788,6 +4788,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			    compact_result == COMPACT_DEFERRED)
 				goto nopage;
 
+			/*
+			 * THP page faults may attempt local node only first,
+			 * but are then allowed to only compact, not reclaim,
+			 * see alloc_pages_mpol().
+			 *
+			 * Compaction can fail for other reasons than those
+			 * checked above and we don't want such THP allocations
+			 * to put reclaim pressure on a single node in a
+			 * situation where other nodes might have plenty of
+			 * available memory.
+			 */
+			if (gfp_mask & __GFP_THISNODE)
+				goto nopage;
+
 			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251219-costly-noretry-thisnode-fix-b9ec46b62c1b

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


