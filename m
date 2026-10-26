Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC9606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nBlG95Jj
Received: by kanga.kvack.org (Postfix)
	id 9114B6B05DC; Mon, 26 Oct 2026 19:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9B36B05DD; Mon, 26 Oct 2026 19:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FED16B05DE; Mon, 26 Oct 2026 19:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB856B05DC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:25:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1233A8508
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:24 +0000 (UTC)
X-FDA: 85366360968.10.0F383D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 111DC20002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBlG95Jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wk8fHmHyhf8+gOZCyOM9u2jGkcwPVKHrhCqeaA1oNlE=;
	b=2fRg16Yu/XlRaFiUDECkcsE7RDQsuKB29iy3c+p2PGwDLXIVeejwoKUWLank56MzTibSli
	LpfFM4j0VvC9646A5VecjmqXLknbuUqDMqHyYES50PI9DM/IXB4V2iGqOLxVu4WqfjAGmW
	WWH6E/uTCbXrv+PDagwn/Va5+1DjCFo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBlG95Jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057123;
	b=A0nR1mIytNlOSBb6Nht/XATXty6UW+ul0zhDDQd+BbNDQfsnTU6z32sMlENnqb9Q+dNxqW
	YnmDXKIikk7xj4yrz3XniEfNuZcqal4YL2+EbLEiUWxxw0tkhymANBsoY+zIW4BsdHxdVw
	JhNy3BM5sgmi4MaiiM1RsIARffMO/GM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62E5B43A59;
	Mon, 26 Oct 2026 23:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB9A1F01829;
	Mon, 26 Oct 2026 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057122;
	bh=wk8fHmHyhf8+gOZCyOM9u2jGkcwPVKHrhCqeaA1oNlE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nBlG95JjLTKQS1vsnDjG3NAtGsrJsDj/kWHYnsNPwR/Kc0irpHvaXwIB38KpMmMaH
	 aJUO172YL7skHXpfcdKZZL3xndwdNhmEt2wuFrTZJ/6vzkZFBNrVgwh5j6lHQPqNr8
	 FA2RwtRCOwbPj6WLRe7QN8lDe412PsOUyKPQhJRU8dHjTUhNKSKli/BFSl1+hMJhFc
	 B6E8BVR8WCWG26bqcALXH43Cp89W2ZE2U7vJW/EApfYOtJIoOvx1au8dpIsJblyBbu
	 CQ/IA1Jopa5qol5YYDuCEkY2gLlCoYtmIuFrL7HJ2t1GVIN5bStSPzqSJg/dcuOsUC
	 HfPG3U6ect9TA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:44 +0100
Subject: [PATCH 24/46] mm/userfaultfd: wake all waiters on unregister
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-24-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2267; i=david@kernel.org;
 h=from:subject:message-id; bh=VWyRnUh5UUmddqRoYe/RjEaFtJoCER021E7Zl4sKkh8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/m5/Zf4afPirVSuw4bnlaL3XBgkWdEX+7eJ/nbD
 qi3+js3dJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRDEWG/zUzPd5+511kL8MS
 WSulJCHq8trETpxv7aHmc0vVdIP2ZDAy3BXRPcHVdu+soPf6/ivasxpqVdJX5kcavou8kHhieqA
 YKwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 111DC20002
X-Stat-Signature: ju79mxbb6jrws9yp7h367egkkzzteom9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057122-793815
X-HE-Meta: U2FsdGVkX19CbmDAEVfvtQ22H90vIlw7s9ZjfY/XTO8x0yf8W37y4IxxviDszVWG0/lJ4Tvc4TGaU1oxYPCecqMU52qgcxvdkMGpYHdwbNbdK9AMni9UDSERbhsH8zD1vYHDju8PK2lHsag0O6Pb4FWmyUI4+UVbgEnERWY6HKQYPe69K7zOHfKFEBvLLaLd1a3Gvn2knlkIFG5AFUc2ulAwYFlJvVJ+SwPsl5bkPL2vSolb1IswNXo7uVPXxNLHNYi2oDC95HoHO300e4CsHI5KKcly1LPAOldndXVErQ0XANtgtCMW6v4xw42wgfjghl15GhSQJtHiFZDDPVImJ9YjLJ4Q/8quuJcsIaDzpiaBuKBwKJntlyGfWGWxiFP7shjvPYEnLaxGR6L8UreC7EIz0OOY//Fzx0VX8WiNWQD8Cw+QEhcP2kkOR1fNhdd+EpQ4x+/Iu2TnzetKAiQYlvTOAcQvX4kgiwuOxsu3zgWkNu+mjBU3gcH5dDvH0pxO/g12UjTfygHax26UQbh2JJb8KetuumY/nfYYjRteV97VymSRfvRDd42v8776L0pMFdVqon4P9tB14fE83gBWg3hegZUuCAWcAjKRBtIicQo9EHK9aqVeabGzjYGXYfLbeM08qe8g6g8LpE7Ag2H8SIa0u+VZs7tHWdJdM9+xNPGnbI85PByvODvsB/ABqZRFStVkH+Xyy7BcPpek6pYOXOlh0KcNxSBz4wN9Sw/zqvK3UlI5/dD/i6Jh9Ryd/3SoeKvWnERQbNbGRV4n5Nu1pKN5jYWEHdufYevBCeCp2vy6PQp9/B3dWDZXxVezn6TLpOPREF6um4cyIgTy/eTInGMJlLIJIyNVwzAcsXdSu+FC9NJ+lO6qRcktMuV1AS4X8124a4VKRDjsj2mBp0hfGjhcx4I6soEYs5R0AtrCFXKd8ihTF7/tAePHP/L0tc6fkCDXdbxztpzUBwSsjIC
 mfYL1CoG
 BxTqhSQVweGR9/fCx5D9STI2qd/KLXUWhg7zyd+HOM/RIIZUrBJH02XRHALtOYg271tERXWjaQ5m2IyOFJ6b0d8m1W1ybEKavjoRDab2G1npbpPRe82oyvJ+r8mV7dFobcff29hhTayXwBOV4sAR/czCceodmIcKEnOpjp9Vid0Il4s40QwYrj6Rxx9CMo3oDikoufv+jHUZ06+N/70V6SNVtLXIXU5Y/lxKPcWeUz+g91N79ZspyQkk6IdPJVYkjtHgkno3SqgbTDINLsGo+p/TlcG4wr7dlbkMGbHsMdL6PGZJKMWbZfJ4cLJGxuH+owRMWQz7JfD74v3WpFYgsmdiaSt+xFuN2twNdIy5wp2y9VPnCs1nKVtt/4lpNQOULtSe0
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 7e30b5ff17be1..2122676c4220f 100644
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


