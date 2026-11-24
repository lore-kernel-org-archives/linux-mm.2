Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAB9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCWQ43Vl
Received: by kanga.kvack.org (Postfix)
	id 82D3C6B061C; Tue, 24 Nov 2026 02:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8066A6B061D; Tue, 24 Nov 2026 02:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742096B061E; Tue, 24 Nov 2026 02:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45C976B061C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:57:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EF73120AA7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:57:07 +0000 (UTC)
X-FDA: 85469256894.13.A2EB806
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53659A0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:57:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCWQ43Vl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507025;
	b=vK4it4IU80hlMcrFc+dkz27qCetKtl2ThBTOl0LB0DQHvYA2aRtAKTna9Fc5mriogvgv5C
	JG3Nn62RqVPaFegzZR9yvoBIo4RAWVDVe1oUL46B9MGPzWEOD7h3eMsltgWHanH9rgyLRb
	Of5NKH9XnRqHHqUYqyexT9bjfOaUe+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWC/0IiDWu/WZWqTxX3lta5UTbGrGNqTUaVbZk3NCrQ=;
	b=4K9fSazECDozrzMN2ru016z2mhgHgWowp9CPPZJDQqhnYl0EWvfTB9G5vey0OUUNF4M4Xz
	aQDiILt+AC1SVXSD9cMc61jKozteN3vmJeGW+mv0mwqBJmFogiMbGcmLoHEXppKM39F4yW
	sVgMLQfezjpNSd7czrvXkzlRcz63tWc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCWQ43Vl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 893E4432C1;
	Tue, 24 Nov 2026 07:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7350D1F00A3E;
	Tue, 24 Nov 2026 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507024;
	bh=sWC/0IiDWu/WZWqTxX3lta5UTbGrGNqTUaVbZk3NCrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jCWQ43Vl/X6+1imSMYtmfu4epf84/AtQZBQ6EatnOqP1uWNH9LlQWD/ckRAYttVDt
	 vEGl7Ia+4MQBC+O95ewenwYL7rIH6gTId7V12t2PM9Kj3xu1cj5bRCPeSZhtdSdrTI
	 N3QeKoOzNp2+bWguvzS7GD3MQyVACNSfG9WfwFl9vXCUk+0u2kgEozI73TMQBGUpL2
	 o5M8jAknsqG5lgMwmCmtJIqtlWohLUjKuJ6q0M885aXAvih5QE2Vy6JEbK44zheNDF
	 MVqZFcRVkTNCZT5dqiys16EBCtUzw0W7QcjvXPEtMoA8WrvIMOtwOb7bVn3ZqMN9Ef
	 TudVim5GcFjAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 24 Nov 2026 08:56:43 +0100
Subject: [PATCH v2 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-migrate_reclaim_deadlock-v2-1-03cc147e1e36@kernel.org>
References: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
In-Reply-To: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3933; i=david@kernel.org;
 h=from:subject:message-id; bh=ANBAHYNyZ+2A0JQUk/v0Mas4rhbNOvSUUQKPMwG3HAw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJZne10tX99m/Qt+m3+VdeW0zx7VrXZTt1ynJcvcyPrz
 Ef6lQYPO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIkzEjw9Hfs3t+ByypL3N/
 5Hi7vmGVpqfr7u+nZPbWpj4RqTVboMHIMOFKYfTGQA/VFykrWT/ZOnccvHWgN7PEW/IhQ83jqLn
 9vAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 53659A0007
X-Stat-Signature: k1fb66yi9zukipcx3mw67eqdkiwtsu3a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795507025-572306
X-HE-Meta: U2FsdGVkX19j1iXSPiDcQDV3BXvAj7MTnUHjxEqyCRKKEDCc6d/PcJ0t2MYYdEGEMnUffAH39NsPYeQAqB6fkLSyYWYvx45KGHLYpsu2C2Uyc/RDlAKE5n4JxpEAW2ZZowncAIuZIPY5Ahsvoove95J/LQDg35EOaK8xusFPZfXJuZ+HFn8kbVeTU5/7DiZ6pFrQjnvQHeogqrdK6ccPFeJpZjalTHdkrvmB8Y/i0FN+qd2iz04t4VpQm/HaYwGxJiZW6lX2zxnWpGrOTi3INNGdddjx3MeMPq7nlDRtVYKNh7ugvxiiftP0TB/GOPuLUvd2TH0+n204al8prxbRbyPDGml65NoiGSZQj/wgiezUKHmmSQbT3cCjv5A7uEZL8mqT4CdCyI5Db1TLT316BWFGzhOZY8OoNQBFi1Kp9GPF4zTghYHC3FHrTY9sUUALNEimPWmZOX2hAZCyxjU8WeblMZnsaGq3RSZxbK9Bn1dkvX6sSsOg54LsjRmvesMFDBpJaH6r2iy3rs1HOz//FJMkyyCMAWgzcgFEeSaDHMyHVRjq7ww/Vs+FmPxPqlTJe+nrWE0QpTfFSrVaSE5fFGtXjfpdwDGZjBq0jc4yV4Yc6xcMXePkCeoBqItmEaYYdi9xJsLGRhoK377E5S0MpQqba0GmI6CdT6SiqZu1XKjSx6Arf4uv75MRDebb/zQfHJrqmblb24uDp1A8p0sgXMtvy7wgrOQBN/oshmQaRJ4ykdSCPX6deCwKn1UFZDhy7rtf8fKqOfdEy3u7ZgEKkhwmu6+ml7ILaa3Y536MO9f4YO+QXvYbGyyx0sLJgxW1SfYOLIK18yfN2aOXIKuCsLywXBxnJWTTFqbkrE+XBtfTPXTt1NWwdOU2VhIMKCUCKtpCzzmHyQ+F4teDHyKPT+M7LV7HhPTVyQTn7mIbRwDYfdpFb9LzSZ0bfqRlYwpIbn3ibG2PmOhU5j2iFc/
 N72Ocfwu
 HgZmydsw6yEclKkvugJs2roPrM3jjvZqgXxD9l5+v9v8AVHq1SIeTY+PbamXAUF8lYLuvkYqjAj32lKow22r+aCAT+IQeKN79BDchbRZm4FPHEI28TDGOE1S7KyrXbUxfS5dnGsgD7LQ2y/VDLnGWU5cfM5DbkJDKfbIbgVq7Df9F8tOcRv2y5XgqilzlOKBthvZcGNXoKuBMONI2b0s8LCsfWNeWnAjDo0W0WHTi9bhR11zSeYIOwKqx8fX/pywWJaxk/CW1SaUUrwC1ZBfIuOnQprJv+7hqPY90OP68wjOosxxoegqAwoZ7umah9Xmqdn5+xRdCvJ9FPJNwUtwVls43uDeW3seiR62OnnkV79csEKGesB3mLv1zaA+OMaYg2Rj3aGQpPMJoUYlsmGf7guE4EAfCWGos1zzSMVV7w++TREPwyA7PKVgfdqSkbmEk/FgWTBYoBZZawF+nY8qfUE2z2nIaLbTyYp5QN1MRKgGEuk2s+vOSV97L/mrlt++rxhBV8ETDd+Qw8oWoUJBCxyny81uNw7G8uipdA7FKiLNwNIYamNrFpP7EMiBl7Yh/DgvUgyV1BcS9AMXByOMy4CHnf9mcNesQYSXkS33fB0ALUuHix6EClXrLWyDqrB93OQ+QwP1BCdWOuFwe7+tqMpet+sLykVkEDmYes7W2TwGdRgKlfPJJ6WTDQwCcv75CfdgaUQdw1o4a8ZJu9EW+BsRLi4lqtXDoTd/SVadRYewpg8ZNbNv2rvMX8gBqwGJCv0zjuVZmc8AwRVHEP/XuyI3WDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Splitting a file folio might allocate memory for the xarray and call
filemap_release_folio(). If either ends up in direct reclaim or
compaction with __GFP_FS, we can deadlock on the folio lock.

For example, when reclaim evicts the inode through the dcache shrinker
it can wait in truncate_inode_pages_final() for the folio that we hold
locked:

    try_split_folio()
      folio_lock(A)
      split_folio_to_list(A)
        xas_split_alloc()
          try_to_free_pages()
            super_cache_scan()
              prune_dcache_sb()
                iput_final()
                  evict()
                    truncate_inode_pages_final()
                      folio_lock(A)

This example requires that nothing else holds a reference on the inode,
and can be triggered most easily with FUSE, which evicts inodes on the
last reference.

We really must not allocate with __GFP_FS while holding a folio lock. As
Willy explains [1], direct compaction can also trigger deadlocks.

Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
cgroup v1, memcg reclaim waits for file folios under writeback if
__GFP_FS is set. That can deadlock if writeback waits for a folio lock
that we hold, for example with ext4.

Let's fix it by splitting folios in a NOFS scope, so callers don't have
to care. A NOFS scope also covers allocations that filesystems make with
their own gfp flags, for example in filemap_release_folio().

On NFS, splitting folios with pending writes or ongoing writes to
fscache might now fail slightly more often, until these writes have
completed. On netfs, only folios that are being written to fscache are
affected. All fairly irrelevant.

This has medium urgency.

Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Link: https://lore.kernel.org/r/awSgk1VTUsiVQOAT@casper.infradead.org [1]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e22daf846dbe3..44424af08cdd0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4425,11 +4425,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	unsigned int nofs_flags;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
+	/*
+	 * We might allocate memory while holding the folio lock. Direct
+	 * reclaim or compaction could try evicting the inode, isolating and
+	 * locking our folio, or wait for writeback on cgroup v1, to then
+	 * deadlock on folio locks.
+	 */
+	nofs_flags = memalloc_nofs_save();
+
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
 		goto out;
@@ -4478,6 +4487,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	memalloc_nofs_restore(nofs_flags);
 	return ret;
 }
 

-- 
2.56.1


