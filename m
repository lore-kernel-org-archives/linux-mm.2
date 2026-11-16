Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AECF606A8AC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KLMNlCQY
Received: by kanga.kvack.org (Postfix)
	id 9B9E16B05B0; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968076B05B1; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FD36B05B2; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5520A6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCFC0A0873
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:39 +0000 (UTC)
X-FDA: 85440023718.09.4516145
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0CE4140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLMNlCQY;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794810998;
	b=8Ezw4chRKQrzIxnlWeXC1aFvR/qPbC5J+xKED9rxNe12nBm8ZYEvrKcxgLCPcU7rXXckPY
	YKgd4bKtczaUXfhtnxeQ4bORAN58ryg/ASHCsJVZM8gpQcDuOREUkKyUsYk+6JZFfV07F6
	7L5bkb+pViXX6vsN/t1oiSZcGSpX9QY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLMNlCQY;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794810998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGG8fJWiVLN4rBloB6l6LP9fwezC9+FtgrPy8Y99xzo=;
	b=k0P+QAKROEIFqOrwWPxBDOun+c/j/WRd42uxax7VjOmsAFuB6hq6/dj1HYdWkbFYhb/wJo
	kRoxPpp9V24wyoZosifRYoN23TVHfc9hMJu1FT8vgqaf/EftEuLedWbH3+k+fcmj8Yt5i1
	kJe6zIVFtSWnSolAXHVjn6juM5UyXAE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=X9w4h4OFbGo7OVBtANSE6gWeEcgqw70QG2tZixDGK8g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794810996; v=1; x=1795415796;
 b=KLMNlCQYhmLCVnrnszOFfT+rMJ46gPccZaFkEkubwn4U2M+vgPiciINABWPKugWKs14mhBIH
 ij75iSZRLFHNteZ6AlN6T6Is4aXESdL39gkVwAKWZU59oGNVU+OQB1+AW8N7+aEJXFGCTF7u7lQ
 ADpFOIQs50WBkNU46ymyF01A=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c888f79b8281b000;
	Mon, 16 Nov 2026 06:36:36 +0000
X-Mizu-Trace-ID: c888f79b8281b000
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
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/4] mm/migrate_device: avoid leaking folio references during THP splitting
Date: Sun, 15 Nov 2026 22:34:55 -0800
Message-ID: <20261116063624.1382944-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116063624.1382944-1-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0CE4140005
X-Stat-Signature: bq8m5iqtjyqjt5k6f41ce1a7m7418dda
X-Rspam-User: 
X-HE-Tag: 1794810997-672119
X-HE-Meta: U2FsdGVkX18/uKuDd1M5kMiMDhanaKrXmzqTRzk4PwBbBMCQaIGnN7d28M15IsugBdh7tORr7i8IvNSCAcIGjByOHi6jpP0RyQnp11L+rkHv/3aqJteStDPNQe4rNVxmSeV0OgIye9X4HMv5iwcAzZcCBkXG7h6wofBj249lW3kbKUdsWdxt4wWSOjin79lLBjRkp+1UWfRqR9IGRuEGjtnkwcR0UdvVWoLcTGcbWP9QfWnnGUkjOuDlMGQLmzRresjUgCA3c/gAZqELw4n+NfMeCbrbB50w0SW+DEVznoLBWBuQ/05uMhbs6HS+Mxvos9+0JVl12MbJ1StGINPD0UxHgsRaQpukpY4ntMcg6F6jIFtK7xqIzTnNLtZIdtubi/YRNgB8ERq1xG8h60UnvNMuq3+FXeBaMY4z+OO0h29c7XFkqf0C/ctQ7tdrS+PX5UtNmTPUJUjUTIX75f6Yf2b7ZM6mOFlGikVH7y9+tQcXobbeHU9pOUgr2Uk/xpHQ7hwDMnCM1EbNMBwJtbeAwzcv8h5VwgZTQTDOjdre7xVzcxgow8ebZg9ivpIAKOX8UBQFU53JVKb+QKElunwlc5yON4VH3kcqLI2fPtuO5h1URcqke7xQ36fxApsRmubmCMCMRNrQAwSJagvlm7N8r7k2e1LHyGUGibM2x7txrKHrUCERFequaFxwwTsk3buSYxNNT3Czu70tUFuzxYNCP+d7cJWTLBr+IAvYwXl0RvTrHX5uN7PY8nxJ7qBhypxItO7NaTFgFrj6vXaDEObhjpP+gTZWL2wW3uUNG4vW53BrvAkOJ7QfQtbM2Gp/zAJRZrmUNJQPQa8dPthjNdnwmYDy0Ynj9ft8WQOvmpa/CvuxtG5P5yd/dBl2SVzN3Ch6XnAEDd+Tc8kFItY8P7kSHuFVQZsrp2n4ffTkSvZHvGAindxd4XhcnbK6DFCSIE8pIf8VSBr+8OT+VbW+xVo
 HXir0V2V
 IilgNYS3961P+NPTlZjUnycdsglvJzYk4vWWg6k1sp2O1qBxRxsFYvsncGNKi02l4y0hClWcXfsnPAC+Q4SP7xkCdbVlcDZc3LbI0VBgWlUi7MRTwzUvTcPo5DN0z/30SaIkErWxvkUOAQA2yNT7uc2oPqM4Ue2j4ETVgCJujimHzrf8hvb7zKvfcYVwyv9ZOXpplLO1QUYPj5iPZBuHP6zre3zZHgF1UYZPfOuz3h41nFEK8ZkkfHXKNX7BBiZFKjBjo16GFN8xISAe4+lKHaZM3y652O4862cSQf+HnD3vr046UNx55hemuMbalC7tyJJM/tCvv0o8lbunlB1S+rCMD29zt5LZZU2wCA+oOuzdSRXB+Fgk2Xy7zuY/1XdGuyCSvDbGnhieWg1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_vma_split_unmapped_folio() takes an extra folio reference because
split_huge_pmd_address(..., true) drops one when it splits a PMD.

However, migrate_vma only holds mmap_lock for reading. A concurrent
MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
entries, before the split helper takes the PMD lock. The helper then does
nothing and leaves the extra reference behind. folio_split_unmapped()
fails with -EAGAIN due to the unexpected reference, and the reference is
never dropped, so the source THP is leaked.

If a THP is faulted in at the same address inside that window it is
worse: freeze = true replaces the new folio's mappings with migration
entries that nothing will ever remove, and drops a reference the caller
never took.

An existing migration PMD is expanded into PTE migration entries even
with freeze = false. Use that mode and remove the extra folio_get(). The
reference already held by migration keeps the source folio alive whether
or not its PMD migration entry still exists.

Reported-by: Zi Yan <ziy@nvidia.com>
Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c6..3286bb8a4b73e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
-	/*
-	 * take a reference, since split_huge_pmd_address() with freeze = true
-	 * drops a reference at the end.
-	 */
-	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	split_huge_pmd_address(migrate->vma, addr, false);
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
-- 
2.53.1-Meta


