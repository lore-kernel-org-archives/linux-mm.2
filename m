Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1075606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yugjn+pB
Received: by kanga.kvack.org (Postfix)
	id A60DD6B05DA; Sat, 31 Oct 2026 05:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10AD6B05DB; Sat, 31 Oct 2026 05:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903056B05DC; Sat, 31 Oct 2026 05:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5616B05DA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:46:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCDD01408C9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:31 +0000 (UTC)
X-FDA: 85382441382.19.907E097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BCB8140004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yugjn+pB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rdFsSanvdSasr5hp2c+zM3yMNq0teCos7F9FeyTNnc=;
	b=f8L9FtTxtkc+8N1OvH28lOr7T6ARtAoAsyxYamfozni8YFD5hrP/toXmz2JWW+C11tNMxK
	j80UBXNTMa8gxw9zo0mOJdKtM48J7N9WSGUNGF5zxnFKgt/hcsO9P2yKHoL8pLBqvJflW+
	lvlrLZ6UxhAIZXi6cuHrg8SO6TWK2+M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yugjn+pB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439990;
	b=gVrR7T8n8Bi1Y1mcM3C5iytnCJ7Xpf6KHgg+HXt/MiPQJD/1t91rGRd8Al7UVT6qvKsr0d
	iuazZbreen0ONmKtLjHt42FHLP10wFXFxsC2YTBoN/R3zQFOMPBiZ4hs47efT0cTiXoodN
	WG4XzzfVvC5mu6gzvy+jmKnvLexD1PY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD570600DA;
	Sat, 31 Oct 2026 09:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC641F00919;
	Sat, 31 Oct 2026 09:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439989;
	bh=6rdFsSanvdSasr5hp2c+zM3yMNq0teCos7F9FeyTNnc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yugjn+pBYLqLBNC3xTiCz5oiW74vhvC7wFkycvRquO3PnYkqqxvJdBjpVVLOOf9a3
	 GMY5NPMvyim4j6zvtGkobuJQM6LHuop5J9jeU838zTWLADf6gS9mENKHqyeQ3U/cE2
	 tJ3QNIKkVHGA8XgYw0iQQ87Mz2ixJeN+SwIvqwqJfyG5NckD6CXkcAUg8jOqrL4xfa
	 4j3O2xRowLdRQSBYvwRe96Lht4Bnym9ZIAj/D5fzhJgLn932plRC2akFWJdgu9efrr
	 PFVFdC6cmtsSCVrw0oaNlN0Ha4j0Xykq9Zmdvyk6cfI3okiXdYyvJvgkiQPI3PQ4x/
	 B7Mx6SnjXL73w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:53 +0100
Subject: [PATCH v3 24/47] mm/userfaultfd: wake all waiters on unregister
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-24-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2433; i=david@kernel.org;
 h=from:subject:message-id; bh=jQmdKlit53in6eLyB5lf4macOO/l2TcVDsIv/EBmrGQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+QuqZh0vyitqWjpyf93yWBKxsFeRNZrt5UZ0/01
 uPyqfjQUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwESW2TH8lXjDYm1v2hI/s91y
 7fU857DG/g2ne3flZlXO0qn8+vyaKCPD/kUxxXONRZa5rZX00Vw4Oe9ZxN3rE9xft8fcOiRdJvG
 cEwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 2BCB8140004
X-Stat-Signature: 1rcfx5icp5ic9s79uwaansq7jc9akhc6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793439990-306079
X-HE-Meta: U2FsdGVkX18GxEM/TvhXjlS8aRQ/T2zJTZs0ZlXV4xcWUEjTm4AU/bof+rDnL0EE99fqgu+FfNUWCJyR7x5afviMT+1+us/WHH7eOapZFRHCdHpZdXE6NRJGNn2m0ZflZW/JhtuhYjMW5Nwx37O50OntH54ewHr33Wnu4yR5pRvxA9l2lx5CK1pHKfAZLBvZdTAIwRjDVZJttyzx+BdWjmVWhJR82VNDhuPDBS+dtfetHg1+5x+AgR59z2o+l0BhripMGh9UPgHDPIZimDoLBJJRuCNlL8AfySwwdHrbGlTcLa8x/FDae/F9WsLAHJZ+CjQm2zziSO+okKIXi/gFgKXifqGLZhar69xUzuxNZMzb2H8Km5bd4BMWwVxjygIWvZ2iZAPLyKLV0/xfEGFtzR0kELUiT7Mdya4dbOr3XxxtheQABKYc2o1XcmAAIhZ+JBnZ4StMWw5GhfLObGh8JRFeqors6AkEqA61EfHH1GuCi0DxCAPQtQ3bLbmvOz/hzaYmqWUCnTgqeY4V/sIYJbYPbpxsN9TB5waRFR+U29p3c6jI2CAiP6IGExPE4dAsN+vqRqOTkVf8xq1JdKXceWiiY8kROEX0mgEHxoTKhBiI/rWGtz7IhQsKfN5/wb3IgM3Uzp5HzxkiTmuG7TDDbor+p6R69DatGHEuP4O2IYULDJCNb+5zEmkrtVSoWzuAo3MWbyzlDv4FQYfIsCe7rLqqzwecT6XQ3Seq1m01pYDTl5yNMHYZampxJ5bQv8ZoSF0iQVlk9CWpzTPZ6r+8+CKfqrOIxsrtdYBPOBr4s/S5dNqiKVtFCbOb0xZMAnrWBVZmhoOTzRwWpA7SPESOvhKMQBxDKxJ3KLwurSWHvO53PxyJnTb/Z4RpXwh1bOMoI3k/8dECClR4FkMXHbS2yHJfo3xJ/qSYYrNTLbWrL4f16MCFUFR3wRhfkODcAEdxH9O00jsGsnrrnIWGfTM
 G9OIJ2b2
 IBImiu+eVo+jzsofqE18QUafTdAM/JlzdGBrqXYpxiDcQBw47RyV4QNkVyec9YhxG8n2kosVdV6jqInESERclhNqiwqjbF+5aqOXuagntDOuO+vjXLhz/FEkdM2036hDkPV0rBeX4mS6LsfvXNkK1312ma+slDJyyf0CUkEzo+wZfoX3AZ4qMnLzaObkcs3tzyVLVRDB360Tp82DXNlCSNEofRkxXoansk/+x6W2sRRWuibGLDxFUzz+dk7qMib7WTfeVZ4ipb8NyKhd9ugXDJtMLQs6Z3ZByLCPGe5vXafDFFGHaHzlLi2dskqLTMxWJOzA0X0nQ1S/WfDGPd1XggFPY80mk423KtzQjSJew2g9+9p/S7LZD/XVv76+4JBpJzhtIc03Nskjf3yxZ9D9KJdSAS7qobb3aVvmUVtd8qTVKfqdPSPFykkYFdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

UFFDIO_UNREGISTER only wakes pending faults if VM_UFFD_MISSING is set.
Threads waiting on write-protect, minor or RWP faults can therefore remain
asleep after unregistering a range that does not track missing faults.

Wake pending faults regardless of the registration mode so they can retry
without an explicit UFFDIO_WAKE or closing the userfaultfd. This matches
the existing behavior for missing faults, including removing unread fault
messages for the woken waiters.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: rebase; simplify description ]
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3ca04b582329f..be630674fda9b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3977,6 +3977,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	for_each_vma_range(vmi, vma, end) {
+		struct userfaultfd_wake_range range;
+
 		cond_resched();
 
 		/* VMA not registered with userfaultfd. */
@@ -3994,18 +3996,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		/* Prevent new userfaults from being queued after the wakeup. */
 		vma_start_write(vma);
 
-		if (userfaultfd_missing(vma)) {
-			/*
-			 * Wake any concurrent pending userfault while
-			 * we unregister, so they will not hang
-			 * permanently and it avoids userland to call
-			 * UFFDIO_WAKE explicitly.
-			 */
-			struct userfaultfd_wake_range range;
-			range.start = start;
-			range.len = vma_end - start;
-			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
-		}
+		/*
+		 * Wake any concurrent pending userfault while we unregister,
+		 * so they will not hang permanently and it avoids userland to
+		 * call UFFDIO_WAKE explicitly.
+		 */
+		range.start = start;
+		range.len = vma_end - start;
+		wake_userfault(ctx, &range);
 
 		vma = userfaultfd_clear_vma(&vmi, prev, vma,
 					    start, vma_end);

-- 
2.43.0


