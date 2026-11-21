Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992D9606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ci1nCDLb
Received: by kanga.kvack.org (Postfix)
	id 9EC3B6B00EF; Sat, 21 Nov 2026 11:31:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D1F6B05B0; Sat, 21 Nov 2026 11:31:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3096B05B1; Sat, 21 Nov 2026 11:31:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67E0C6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:31:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 718FA12055A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:31:21 +0000 (UTC)
X-FDA: 85459666362.26.9C0BC97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A3F740005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:31:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ci1nCDLb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795278679;
	b=UWYMgSbDb51JvXHTn1F9l0lpKzXzyOgxEAYC99wlaA7/658LKUuVBbc5V0HMuO8OKGtrRM
	9RRiHpt/yHnUDdtQ+77AHn5UU9IscfkhaBJ6uT0weCErqWJc41yoDj+YePrhtuSGncyPUT
	d5kAgLLGmUywy7Uj9cB5llC6ApEkgAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795278679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sR6QPyx+giVlSIsrP0rAUCqjCOFMn8GyMcoo1Q8rOMo=;
	b=1btAxneSd8pnFnbmMHOrA6EKH+qcyQu1XIvDDhCwz9Q4+7V6F8Yk3D3Z6MZXKTqxGLTOaP
	S5YNrWNN7s4G6R44ASvzfgSatuWyQsgru2+Wg41urRMMwB1ecAplyfLrrqAzWN+mw+rwQw
	dPqZkewbdRPI+VugpZ/WxMMZc6qXE/E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ci1nCDLb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0DBE412F1;
	Sat, 21 Nov 2026 16:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AA31F000C4;
	Sat, 21 Nov 2026 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795278678;
	bh=sR6QPyx+giVlSIsrP0rAUCqjCOFMn8GyMcoo1Q8rOMo=;
	h=From:Date:Subject:To:Cc;
	b=Ci1nCDLb4QsTU+ygIpzi/qZBizX+p/B79lbsD56wzdazPr1JpUdAHsxIiUclTHRKj
	 AboDeU/pYN/1eGVK+Kz8CzraOK9Q/KpxnQq3qyuwWL4VyP/9Txj6H2T+X5CVUsDmFD
	 9WrP048cSyPNq5LbWrjvLq3stsozs8vfyi+9QbaZhJ+3f0S5bXH/TH9gH+pbBxuniU
	 j5Qe5/UWb23V6jGys6hQViuslR4bjcj7yjbWalw7GKmk3VwWRVnR/1aTkoYp7a+HBZ
	 iNDOHcWgbrBOEAZMNSsYWGigAFFEVqb5Lzw7mdK9GMtWz5bL9rTP3VXgh9ecaRnT6b
	 F0buFGQUNC+CQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:31:13 +0000
Subject: [PATCH] mm/rmap: correct VMA write lock position in lock ordering
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-fix-rmap-lock-ordering-vma-locks-v1-1-952c0dd5bc3a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqEMAxFryJZT8BWLXSuMsyi2qhhxlZSEEF6d
 4PL9+G9f0EhYSrwbi4QOrhwTgrm1cC0hrQQclQG21pnjDU484myhR3/efphlqh+WvDYwrMUdHb
 wXe/8OA8eNLMLqfNcfL613p4DxaxyAAAA
X-Change-ID: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59
To: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, ljs@kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2338; i=ljs@kernel.org;
 h=from:subject:message-id; bh=cjUnhG00/eTRNWAADWxXScAyfEKtHgAHVjsYnlQ0K0U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZjweXKfKxr5rMJ/7j1bJrnU7T0lL6QixWptyWfbU4X
 eaLnVZkRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbCvI6R4dFx7oVz+94F3mYQ
 WPvlWuSeyd4cxtd6UpraCqbXetcq6zP8M9RatvCF7wGmt8kJatxrw4I5jSJZczSqy2V0b3+aXzW
 VGwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A3F740005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: yd1djngo6k8r93mmproifc8pzz5ukrkq
X-HE-Tag: 1795278679-878495
X-HE-Meta: U2FsdGVkX1+aY8Pyo2+3Rt3dTFdF8bpRv3dLqM1jwABjBLfN+bE9GdmlTjArR+QsivI2d+CoJjxXCYP82IARYeRsvHpSpaDbOkFu8ZDhCo98OL6k//OrtuSvJeDRFEUqBHs48qaZdzpdCiIhm+oFAppOPAdWsYluAxLan4/VG1+x3rS7c6sHNE7O8Mg7sLR7m+H858ENfgOdJ2ZTWIdtwtD+m2tXWe2NyduhqI/G4Vz3cdODUwxfcXtP+fWCjrxX0GyTfzS/3XpNbKawK3rJVA4SVIt9I4hcBjW8AXp+5BViYyVpmTVPtFOpxI9cV+1YWOp3eanUv3Bl0eYtOAxZSenT3nKqifb1R8aECl6D7n+iE4f+EmWlAzzean0cC7eZclb/FA7LpYvwHzMMdF4GLJhsaOvSRQ2gwvko970JGZ7MxXVA9mYmEzIzDrabIYXA4PsAfpOgmMriZj88cn63iaD1fW8R7ln9vGN+dn9XA7olhP3xVEhSWp5nkXnpXKINjHw+yZHl4hEh1/sdS9kscNHXswBlgFQ+sYrtrMQa0fSc7buC3UBDUVu3IEeebeyyP2TX8IUViu6hq5L4NpZqjKe0qFGDnGpn/J40LmoeAr4yFrXVh3FxySdDZA9Gqa7ibrIoCL4KcbrFGUKISiGgi/4l68iF81m3uCRPwnIigagg9l7ZligO+kGW7TVBuDpR3z7BV0s9RkBBUrDzTRqx49vOB3DINV5nPpj9DO0M+G//6oEer910rMAsmPjH7TVBIbsogzd3ZsfkrRKEY+PPFqv3hCAe4Z07sFG1RF9rNvukEr5fx0la54rHDNA8cgEBtkAyCVGF7C9oPNYASd2zLfq1xtctYijoXYtRqZJqzc+2316dL9ARKeGAx1d7hjUWcK1YnOR4KHRn6pZx98mkNvJjyVR10SRrBaw322gqnIYK1GuzPlCUuheAD24l8ji6VOu+cy5ylsENYceA9p+
 kHHCtIzB
 OyoAJmPJ9y7z5OIO7hxcs699bZt9RzD35Rey3RYHprWuSHjlMCuwiyjbLgZOFnL2zTcLxx0v8jKltef03XLtZ44bm6D/c08mVtJ/rcbbnaInN6wkc3sxMPh20MPw2B14juKat4wKr5ABLGeOj8yskIh6DIcoH32obg7xUgiSuBdx44SfVcudyUJYpxWR7Ny+EefAVxeTjing3/XUOpdGPFKSKOJ2UJT0/RCha16GoaIBoFn8HE71OiDWc28FfRhROgXa63sblJW1EEN4S3RU4oK157uwRqG2nh/tWB6hB0f8vEGgAp8ucZOog+pyqciWoiZknqyGarfkxSlbCDi41H4od0wIV2O9TzD9QvDXUYqV3ttY/1z7WwrUJqbUSxaqj7Xz2NXluO0LcsEmGFvoSHUmqJT034egOUy3vpIGdc0IQQ7xHSkT/d+4TtdCX9B3bvMpFr5CnFwiCOWDYegQ5B9nQbM1lkTk5VMks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The list at the top of mm/rmap.c is taken to be the canonical order in
which locks must be taken in mm to avoid lock inversion.

However, VMA write locks appear to be misplaced. These were added there by
commit 55fd6fccad31 ("mm/khugepaged: write-lock VMA while collapsing a huge
page"), which was focused on expressing the dependency of locks after VMA
locks in the ordering on them, disregarding those prior to it.

Of course, a VMA write lock requires an mmap write lock to be held, so this
leaves three locks to consider:

mapping->invalidate_lock (in filemap_fault)
folio_lock
hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)

Each of these locks is either downstream of a VMA, or is not able to
acquire a VMA lock at all (e.g. in an rmap operation).

This is because accessing a VMA's file (thus mapping), traversing page
tables to a folio, or interacting with hugetlbfs requires the VMA to be
stabilised in the first instance.

Nothing in the kernel takes any of these 3 locks before a VMA lock, and
indeed in each case that a VMA lock is taken it is taken before - so the
kernel is already violating the ordering as-written.

So fix it. Also add [_killable] to reflect the existence of
vma_start_write_killable().

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/rmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 65646ed6fc45..55367e7d3eec 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -22,10 +22,10 @@
  *
  * inode->i_rwsem	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
- *     mapping->invalidate_lock (in filemap_fault)
- *       folio_lock
- *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
- *           vma_start_write
+ *     vma_start_write[_killable]
+ *       mapping->invalidate_lock (in filemap_fault)
+ *         folio_lock
+ *           hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
  *             mapping->i_mmap_rwsem
  *               anon_vma->rwsem
  *                 mm->page_table_lock or pte_lock

---
base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
change-id: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


