Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A75C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE446B0088; Fri, 10 Jul 2026 09:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F9C6B008A; Fri, 10 Jul 2026 09:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4AF6B008C; Fri, 10 Jul 2026 09:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3896B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:29:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB22AC3033
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:29:38 +0000 (UTC)
X-FDA: 84972949236.12.E3B9F19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0D38A20004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:29:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQg8+2jI;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783690177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kcYVIiskpfne6Z9qwfXmo8J9FegSGRAbeyuNySWrJRQ=;
	b=faPkotbIc4QXIy74sKzE7jVI7mXUe8P641RG1UStk3b79te7NiD40woImX8zoFHJChmQkk
	B+s9NTvhW5WpobNbAucWUfvws9cy6+Zi+ErBfMcwNaTayXDcXPfF1d3B8KZa7RqOnysgrZ
	NLuBplRJMqC1cAI0TOsn+N5COqZGPPU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQg8+2jI;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783690177;
	b=z11z8GLxzNzwZAx4iEl4Lx8A3Sv4PU42Myot5JZsW9AIMsDYdKovMJp4lXYUGZ5tn4s6wj
	pWPVG15UVbWMc//XxilIbHqZp1ifR1ElMV/GOXkixE6uLy3rhuUqKFojdWSNIvmA3ZoLdW
	1k6SQI5VYz/K8AJoyctFaPKqdnm5Tho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC22242AA3;
	Fri, 10 Jul 2026 13:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398761F000E9;
	Fri, 10 Jul 2026 13:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690175;
	bh=kcYVIiskpfne6Z9qwfXmo8J9FegSGRAbeyuNySWrJRQ=;
	h=From:Date:Subject:To:Cc;
	b=fQg8+2jI+DZhHyrmCjhaf+XXo3+Dey6mmIsYXWahDztTlHY4efdHpEdxnGSms1m1p
	 ESAV/+FQMAxXRpCaK3rAOc2FlQEaO3NTtzMBcjptfTZ0urNw8K1SpGo3WdluebnYPt
	 yGJib7lxN5Y052I8znAi4whgIWh9+P3asFtsDViKhtpZHaPjle4dEQUXCUr07mkgKV
	 jNKQdrqlM00J/7Hx1Z7Y0qfftrojwoa53xj1KGlq4x/D7JOh2HakJ+a3gZiu0tcG7m
	 XuPs00VU3RdVnNCWVXEblnbKXrIxmUEDmEGS3C932iCpK39TY/Z9E7MF56I1Hrsy1R
	 P6UqsXUbHfSXg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 14:29:21 +0100
Subject: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
X-B4-Tracking: v=1; b=H4sIALDzUGoC/yXMUQqDMBBF0a3IfDuQhJJKtyKlJDptp5AxJFEK4
 t6N+nngvbtCpsSU4dGskGjhzJNU6LaB4evkQ8hjNRhlrLprhf6Gb/6jTIIsXF4hYCzjHCIqbX3
 XkXHGWaj/mKguz3b/vJxn/6OhHEHYth1d9m/cfQAAAA==
X-Change-ID: 20260710-b4-fix-non-init_mm-ptdump-016b88e2a2a6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Will Deacon <will@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, ljs@kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2446; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VzRMeEZwR/QyRzaOWZ5WDpsIG/pAI9hskscf2ZRld7I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICPm8qsutP+HlMPtWn5S/3I/l0k5Dnzw7m75idUS3oO
 OWVZFx9RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZiGMbwv+aPW2eDfPSKFX+e
 za5M8ElZdP3SukO3itN/C3JJpXtsXc7IcGj/jQ/vPXbePimxrfLQvof31k3QO2ozl1Pn8n6LJVu
 Pm/ADAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D38A20004
X-Stat-Signature: 7cjqun8bjwd8wn3ty6nixncyzkaqnk5m
X-HE-Tag: 1783690176-126024
X-HE-Meta: U2FsdGVkX18M614yM05Et7FL9a/A3ixduIxzpDNbfgAIUf+m5his69vElmy6oC1KFjCS7bu193OW8OUFnBM/BGqL4pAjyho+UZqocvbfFWz7SbYtskLPmtym5W4tVSthzJuZPYyFExDFkcZQZZJCQNYqUi+qGaMmF9uYM0ZtrF78MXaSHVzGCXEB7wwiVqJGiPi3fjqD0fe30z3lc1FH3WO1PmWc/VAR2JUesLJccqmNLdafsfQc1y+E/Bhfd3a2F3nOVEIwWdNcyCVoluqd7d/TKiFVlUz3IbxII++Yxo4o/ohiiy+TxMtgI66afXo0IjBPPVPsra/On0cPrG+vwZOxIC82RL0dmfUs+dL+/75ufwWh2ycyuIzEGk/xLnPSBAh93FD5Nvc8PzSRasiuIe0ZpKFLGDTTPy2W/0CbOylX/zN+RWKgx/sSVrwX59EInw+sVDvquZokqlvdmnbRXy+mybSbqdpGHMFj7kSvLjkjjGOOA/ZUwZtKnHaPzzU2yPKIQCKw+IXO1brfbJEfmbBlZv5edwytvOb+D3zDbivKIwNYqZJxWtOZHHLHiWCb0syGKbmnhGc3BUvG1g4tZTwaYuwvMuGHXUEiybtgbUXlJz6/eIS1muhOMb5wym/ElFeg3m9UZDi05q31MYPPN55sRsODNKWnqE0fn4GDVS4GaJ8e+Y0kCxaH93aNZINTZiL6crWym6lgl7NcwgTuD3ZAycy/IYgTkM6FhiRy60iW9KY6MlNMIPOTmqN0SWnqP17a8hja0CvzouI28J5WI98M8QYrOeFaMxK6qUVwNo33xBVRqc40DnKMCAr8BSjGc38yczALQ69GRTDr5xXTpxSF3aI+tH8KcC8bXjeWfDJQQgdXzF8BrH6XPwQBoSxk5cz+2uZ2Rrt37JGWj7LbN6z3xaNHZ1uW/TUCSGCOm5iJ0Txw96sYNl/EL0Zd+1nSjovyinbuyNYKfjqwlU9
 3Z7T2wU3
 waO46D9AHdfsvY4PFqaCikr64rZS0K/0VwBLnLtwAafTNQsitVJ/3CFL8IK7ZscSNQ/nsBi713ugzDCITsBJvQj8upHWBI+95MXCi8uZ4lgp0PSwk1U/i5IKcuR3E9umRfqFGS4yptJk7UPOTfhDqkIzIgLTCYYZRlBN2xK1gAgCxCH/ED66LeaQKKdz8slY9LzPfD7rFTFRmhU2JuojwOgtCA26brbWzNe/IXqBIn4wGfRvf0mRFvox3mbKB9U/ar4cVlmZL09oi2/JfBVESb4WWKYOemivZ0S/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still
walking kernel page table ranges.

For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
first passing current->mm, and the second passing efi_mm (we reach kernel
mappings that init_mm protects for current->mm due to x86 cloning shared
kernel page tables for arbitrary mm's).

arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
for efi ranges against efi_mm.

The init_mm mmap lock is used to stabilise page table freeing against
ptdump, so take a nested lock on init_mm to ensure that we are correctly
stabilised.

We take this after mmap write locking the non-init_mm mm. Nothing acquires
the init_mm lock first before locking an arbitrary mm, so no deadlock is
possible.

Other fixes have been sent which update the two cases which can cause races
with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
and x86 CPA huge page promotion.

For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
already provides exclusion against init_mm for the vmap case, which this
patch also pairs with.

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/ptdump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/ptdump.c b/mm/ptdump.c
index 973020000096..6bef47b1a073 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 

---
base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
change-id: 20260710-b4-fix-non-init_mm-ptdump-016b88e2a2a6

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


