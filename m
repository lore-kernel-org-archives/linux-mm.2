Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722F6606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i0Eu/+F3
Received: by kanga.kvack.org (Postfix)
	id 995566B05CA; Wed, 11 Nov 2026 06:39:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945B56B05CB; Wed, 11 Nov 2026 06:39:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834706B05CC; Wed, 11 Nov 2026 06:39:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61B076B05CA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:39:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F08F41A0280
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:19 +0000 (UTC)
X-FDA: 85422642438.18.5A8066A
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F6B44000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i0Eu/+F3";
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sm9PXJr5TIiyZl5zOIT5PuR1aDglg76Y9OqldJz8H9E=;
	b=W2X55peUPGTALz4ZEasdNLEhkAy9ZHkjnunThpasm3bUgLQy1y9tSIpvGMOOeK0kbEp5VA
	DvjDrjBMrqKmPuVT9CIZNTxsmgGMR8ZraMCFDRQFX4hxdukwVqj5luYtNQbaugzPRGBnUL
	VvjBylRW4QwKbvIbWBOgK3eibr5AhLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397158;
	b=RIJVukT0Wg1qpPYjKmHTax+SVcE1Y5n0UUQu5nRY/DILxfFAChe8Scjg595BZtQSuy7FOi
	dwwe3Qo4J0GkxHjRbq6UTw5zDlmLmEZ0oktzGWQnDJtaLBCRPOyqWqhPwus6s8G9H9GIfm
	8+GWeS/WbTRuGzQ0wl75r6yPw98FXcQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i0Eu/+F3";
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4Mq5z6I5/MSe2xUzwOBENm+Vhd7unCO4r5C+7Fe1rDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397151; v=1; x=1795001951;
 b=i0Eu/+F3b/9EIe3orqhl3IDtDiqj4w5mYalWC3I9BI2zzPkKVtmddwZ2out4xDtscItFvv4Z
 zw1nVFvdEnGmaBICuCkqy+b/02u54VlQdV1xPlQBGtCfHJA+z+BLwF0Smp5dKKDBTxDw9iHv6Ua
 wc4mCiMli/81WCRU8/mACUy4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 48df2cab8c88d833;
	Wed, 11 Nov 2026 11:39:11 +0000
X-Mizu-Trace-ID: 48df2cab8c88d833
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/3] mm: fixes for THP migration, swap-in and device-private smaps
Date: Wed, 11 Nov 2026 03:38:28 -0800
Message-ID: <20261111113904.650722-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 41xgd65e7kee4e5uc1ynrgje3mqq739c
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7F6B44000D
X-Rspam-User: 
X-HE-Tag: 1794397156-285249
X-HE-Meta: U2FsdGVkX18ABKnWeRoTIoVdgrsR0TYeN580pH54njfz1mTmJlWd/a9Uri/PTyHy3aq3azCmtT6llpGc4sQ0pEtndhsm19+rnxvBb0pg+trQRBdaiPhhxCDGE5Bb7YCpbImZG34gwX4BliZnVctQd9MeaeBVaCaysrF6WEitjeUACO1fBa93DA4s5O20pjK+if2TrXAfQrsp+4kzKu2yfYhIKiKCAdfmpP2CcD6wIrQaRKbOJmEQYN27PfRil8036MuI6dkjOim1ZrM8snN4jUqmSRxceFVlofZsIDp6K95OewRQdYkIUMw4BHOUm0MH7NO0iuhCgxLzQH9HP4jAp9dupfShgL/RUdaLqGNkrDFU3tpV8kK/i/eaJyF+2gEdletHKWMbb0cd7K+wmnMO1EkhR0VO7MHOnW2N48aLO1Qwwjk3R/CC0I3Dr8I2I/lF2lYboHyMAe7Yhwb96jko1kb/PrNB9vgxUksbcyfX5Xfqkr+lKBSOwaS8i2H3NRUFu516TXHmWzX1NxZxk3v9xPTyK76gOS0OxqiOoIcTlY26YvJ7yyKgX5HfHgV4qAkIT3VYMzT0MsOOkDiryLnjMdcipTtYh1D3+DRffENfdbzk1H3Xs566H+jTSkjLKLSumsp1i47mwJXQ24xEkz50gtjrS7Joqzf9xQQ7VkrNQ93MY8bWxZIF0wh42XECLATRujQAFCuE97rgyVSzF3cgGFDBvoIgoi+CXwWc3tNrCW8JQPx/n13SJ6XAjwOHbGCfO9F1UAm+A8AK28WSYgAZnPys1m0GsRFGxj5mdF8t+Xb0bDLEMVa2ermpy9pyoN8khp9xtxHVW9dSCbvlZYGCS/0v1d62RF0dEINc8suBhuJ4YkAOdZcw7/DuhFFF/VaEHN/mygR+l3zjKrtYfGTIFAmK8dwuGVBCkuctXohqZY2mFgXCgyX+VoavaKm2+71pQKyYz++EDOYcsfSpWt9
 rRykHct0
 0bDNxJ3Bhjn/yCqtX9ueAugkm6ub1cVVsGSfZ9wXlHtmkkYwSe2lk/98HCihmhxQvp3aZGlR3kGfKTXVbd6ot0kxCagjPqmibXxMACqiA9CX65+q3rj9yuKt8FNH9jEZ9RMHXnuqwDfi+nYGBEeYslHTP2ge9+v4D8w/0SNAomlSGRl34GwozMsfRBQ1zNLFANxrKaBsG/BueALQZgeVAy9k+QDZeBrLOEgv8rF4TnbN4d63Evvt+l4qjsrmHWCFPHhxypFJeMrzTw4anmi2pFD1hCRb6jRiu8gFWF5iL4hvDOQ/bXg++pr3ysWMSQpy0raPIfCu02Rpv8zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series contains three fixes for existing THP migration, PTE swap-in
and smaps paths. They were extracted from the work on PMD swap entries
for anonymous THPs [1] and can be merged independently. Sending this
separately as requested by Andrew (should have sent them separately
anyways, my bad).

1. Avoid a folio reference leak when concurrent MADV_DONTNEED clears
   or splits a migration PMD before the device migration split helper
   acquires the PMD lock.

2. Prevent PTE swap-in batching from mapping poisoned subpages of a
   large swap-cache folio. Include the subpage scan helper with this
   fix so it can be applied on its own.

3. Account device-private PMDs using mapcounts in smaps, matching the
   PTE path. Shared mappings get proportional PSS, and exclusive
   mappings are counted as private.

[1] PMD-level swap entries for anonymous THPs:
https://lore.kernel.org/r/20261002095503.3585565-1-usama.arif@linux.dev/

Usama Arif (3):
  mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
  fs/proc/task_mmu: don't read young/dirty from a non-present PMD in
    smaps
  fs/proc/task_mmu: account device-private PMDs as present in smaps

 fs/proc/task_mmu.c | 12 ++++++++----
 mm/internal.h      | 15 +++++++++++++++
 mm/memory.c        |  4 ++++
 3 files changed, 27 insertions(+), 4 deletions(-)

-- 
2.53.0-Meta


