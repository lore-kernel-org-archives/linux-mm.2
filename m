Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D28E1125856
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF206B0089; Wed, 11 Mar 2026 13:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54646B008A; Wed, 11 Mar 2026 13:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56E26B008C; Wed, 11 Mar 2026 13:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A70276B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:26:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 624061B7513
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:26:01 +0000 (UTC)
X-FDA: 84534460122.03.4D2DAEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA13540013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:25:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qe3bY2RU;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/dYtKie2EDAH1N6gAamtjbKp+ewYXgV1yjTT1oA0Do=;
	b=PNRJXVCNbMKMZDmZtvu9aWZPkvdC60hzzETZiPVtWnl1mZGA2P2rYOXBoAPgsd2HyYbX/I
	dh0owfa/u4kgTOele9ZjOBKI7BtJGaS0Ok8ByrY4bmkO297xJh+Fro/b1Pws1drgg9g5Fw
	L0vKLjrtSIkK9bAK67ETrbKB2fVH4Xo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249959; a=rsa-sha256;
	cv=none;
	b=Dae2epsS6VxS25z7VwlCdSyF7RcRX7HWx28XCmYQwfa9CtVv0iqP35oSsoxiZi8bMFGvTT
	Qcz+4CdQJNq5t6KEFBgw+/15I8gMl80ph3EhwyhEYdxTxjliBTIWf5YYvZokZCwNCpSbPV
	ExuD7XGg0pmzxuLCkMRz8VHcDW2hMHw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qe3bY2RU;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9198140504;
	Wed, 11 Mar 2026 17:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106F6C4CEF7;
	Wed, 11 Mar 2026 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249958;
	bh=NC89/X0UAtd6MuroNMC9+3geZS5DQaThc4yCOgVtpXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe3bY2RUv/zBO5L9kyWgdabVDnUmRfSKgnDu+VxZsOoTw7XgAl77B0zM+jZbdqD63
	 IAdVUwTVGnR7umyDxUkU5dKsTjQZTGT1JJ3Bq8oQ3JmMmMPGeoQ1W0yCu3he/g7cnn
	 Cpj81nEAPcZRCZmFdKtOiBUqO60tUv0r21EF96FlvYRgvefpxXIiAiM9YBAgXwA901
	 60TCtAc/BZFiFtsXov+c9Vd8obfjDf1MonXvz7CSoKCk1Uc146mbVN3rfzO3Rw9eCw
	 6mpHhgyTrTsgqBw2HuTj5m6Jo6RLsLL8mE7E7NuM6ijtPDIXvJdsFKZsE4FrCfJ/Hh
	 Pg7Sl19O3+Ohw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jianzhou Zhao <luckd0g@163.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 1/3] mm/mremap: correct invalid map count check
Date: Wed, 11 Mar 2026 17:24:36 +0000
Message-ID: <73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773249037.git.ljs@kernel.org>
References: <cover.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA13540013
X-Stat-Signature: sca4fs1uq5riwm9t45c436jmsuz3bohu
X-Rspam-User: 
X-HE-Tag: 1773249959-248912
X-HE-Meta: U2FsdGVkX1/tv0nTlgLaNTuvzv7uuV0OKzPB1etFu7uh5cdIObF5Mn3ne24Um+L7b0dPYoD4rwRrj1tDY5MgeyU0c6RU3rYHouevdCErrn0jMA08FbWvaUrhN850RlEOSVcsG8R47T22g3DTS8Ndel0CHolt6dPbLLjsjqQNQAYxlpPy6t28MUInMHYsm9x1ufhq/RIhJ0KbHDd035S/dldhyYeawAM4JhZYyaO1mWH21CyHOujGMJnGJL/PyWSYKiN1KezUTLF83NzweKq5fXJXhR+pPyKjysCN2B63Eomz4F+XQPTVDEzw6NPWFGBO7IBJk6qxv02bfDzdpgV1VH4PZ6hSADmj2ZPmNor0RgtgxGfXU41bzqpvzx03dvbb+M38gNOCh97Qvh1X7CffwWDH+QhT9oQieGoGUzndyaSeqqpYNZOmvu+mtmr/vTXztgQvq6j/5wQGGXYcbtOWOrNxhcL7/gwZ1nRQgrp/ZQUyROUVRlCrQB1LhSVIdMwrcR45UU4Jx91DzK/H6NVKCe533tneocWOHjJSrF7zM8ENI3dsTnBI70yEUEtG/IKecSIxaJMLjXv2QZrfnWkkMBsr01f/PD73cCRklZIp/RD8Q72tG9LZ4ehLhmMWiXHe0PXzG9lUsCKWXad/uhlc3RKXbrEX1dqLaK4oIVpbgjYxK1WHE2bDZv46D9qU9RDNDhzl53SYn4SS4JTCswE61c6NUEUmm54QMG2qEezbkb8eLF8jIoWJBR3IcizKuf7DjtZU0flG3E4KveeE4Kl4kBRKtqtJdqwyXh3tw0BSiih4Rix5+mrGx58LnKdEP//aI7dxSssEwNSrPtH82cCqIPRlGYRi0SS7Y2E8c4K58dBFK1DYRfmv4y9mXx3WActbG0GMbcAfOVQ5OD2xw12CnyNDUI7p4faExPciMjQZuXTdBY6Q7Q+FGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently check to see, if on moving a VMA when doing mremap(), if it
might violate the sys.vm.max_map_count limit.

This was introduced in the mists of time prior to 2.6.12.

At this point in time, as now, the move_vma() operation would copy the
VMA (+1 mapping if not merged), then potentially split the source VMA upon
unmap.

Prior to commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), a VMA split would check whether
mm->map_count >= sysctl_max_map_count prior to a split before it ran.

On unmap of the source VMA, if we are moving a partial VMA, we might split
the VMA twice.

This would mean, on invocation of split_vma() (as was), we'd check whether
mm->map_count >= sysctl_max_map_count with a map count elevated by one,
then again with a map count elevated by two, ending up with a map count
elevated by three.

At this point we'd reduce the map count on unmap.

At the start of move_vma(), there was a check that has remained throughout
mremap()'s history of mm->map_count >= sysctl_max_map_count - 3 (which
implies mm->mmap_count + 4 > sysctl_max_map_count - that is, we must have
headroom for 4 additional mappings).

After mm->map_count is elevated by 3, it is decremented by one once the
unmap completes. The mmap write lock is held, so nothing else will observe
mm->map_count > sysctl_max_map_count.

It appears this check was always incorrect - it should have either be one
of 'mm->map_count > sysctl_max_map_count - 3' or 'mm->map_count >=
sysctl_max_map_count - 2'.

After commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), the map count check on split is
eliminated in the newly introduced __split_vma(), which the unmap path
uses, and has that path check whether mm->map_count >=
sysctl_max_map_count.

This is valid since, net, an unmap can only cause an increase in map count
of 1 (split both sides, unmap middle).

Since we only copy a VMA and (if MREMAP_DONTUNMAP is not set) unmap
afterwards, the maximum number of additional mappings that will actually be
subject to any check will be 2.

Therefore, update the check to assert this corrected value. Additionally,
update the check introduced by commit ea2c3f6f5545 ("mm,mremap: bail out
earlier in mremap_to under map pressure") to account for this.

While we're here, clean up the comment prior to that.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/mremap.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..e8c3021dd841 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1041,10 +1041,11 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	vm_flags_t dummy = vma->vm_flags;
 
 	/*
-	 * We'd prefer to avoid failure later on in do_munmap:
-	 * which may split one vma into three before unmapping.
+	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
+	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
+	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 2 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,20 +1805,15 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 		return -EINVAL;
 
 	/*
-	 * move_vma() need us to stay 4 maps below the threshold, otherwise
-	 * it will bail out at the very beginning.
-	 * That is a problem if we have already unmapped the regions here
-	 * (new_addr, and old_addr), because userspace will not know the
-	 * state of the vma's after it gets -ENOMEM.
-	 * So, to avoid such scenario we can pre-compute if the whole
-	 * operation has high chances to success map-wise.
-	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
-	 * split in 3 before unmapping it.
-	 * That means 2 more maps (1 for each) to the ones we already hold.
-	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * We may unmap twice before invoking move_vma(), that is if new_len <
+	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
+	 * a VMA located at the destination.
+	 *
+	 * In the worst case, both unmappings will cause splits, resulting in a
+	 * net increased map count of 2. In move_vma() we check for headroom of
+	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 4 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0


