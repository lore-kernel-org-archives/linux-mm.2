Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7B5606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TE1y0ZbL
Received: by kanga.kvack.org (Postfix)
	id 4E5166B05E0; Thu, 29 Oct 2026 16:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC516B05E1; Thu, 29 Oct 2026 16:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC116B05E2; Thu, 29 Oct 2026 16:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14AC86B05E0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:41:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 993631C3BF6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:09 +0000 (UTC)
X-FDA: 85376833458.15.169DE33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC2A440003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE1y0ZbL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTwOe2rhygBTqbimADjsD30DCMGB2E0StBtyrsEknSA=;
	b=N6ynI+QsD7uJXLmPBGS92x31+/SeOPYAV46gnG40Kx57Cli8g/14raKO1slMUMRGhZJ/N9
	8P5/x6ELuVUpz/wi0xVlrl9fskuLMaMs3cOKdTX3EDsjiT0Jcy10IO/18aKXwY2RYI9ZZj
	kMyyelpMNVBYfQtj2oz52oNGWl8n+tA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE1y0ZbL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306467;
	b=iOfkDMijRlr4teA9WYrFnbU6hHrFuE/6vLdbCAHtF1k3njx6t4KrHTRlwzDZkhMqOf92Wz
	RuZt3cRvIvL4qfUaaB/ZQohDj9N5KikbQgjEfoaKD1M3FSLMJDNKu519bgQzpwGZq7RadS
	8Fxk5oIBIi4v+CQ0qqmM8rZ5swJnLZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B3516062C;
	Thu, 29 Oct 2026 20:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265891F01816;
	Thu, 29 Oct 2026 20:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306467;
	bh=zTwOe2rhygBTqbimADjsD30DCMGB2E0StBtyrsEknSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TE1y0ZbL3VVf4eb0u189422pKiAjJR66N2I9oRbQQKW9568wfoomQtdaN6haewvQ/
	 QvLKMTWJGEIpLmu872vicnNj8EMylIE6cimSkE7cVVxhve4jg0GGIRmlhdB4EW+Rfs
	 bx4v2727E0rc3ijNbosG45F77CfN2c9fJw31CpRuioX3BtcKRyuofi5KCM412z8Yis
	 b+xHStb8Zv+yfOsQ8t+1K8J/VWSvKbzlyPs3a1VrzphHv9cZ7fI88mgneYvJjxzOHJ
	 v8ViB9WkGVew7svI82MfmrAzh9Hrk1i0lS0t6SRranladPVqdFUN08fQx4ZQ8MBeuv
	 AEoxd+/ch8j5g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:26 +0100
Subject: [PATCH v2 31/47] mm/mremap: recheck PUDs under the page table lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-31-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2380; i=david@kernel.org;
 h=from:subject:message-id; bh=+B9w/NrDyjyp/nHRZsfFIxa7vmKtKobl06e6HnkArmM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+24/V3GfMO74vTaKbNNWy5eXLrUfJ6mT+ijWK8PH
 W4s/RsTO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIXx3D/zzBwL2X6+arx9qJ
 nJHpi56T+PWSp2qJUN7ShvrtW9ett2H4HzPRY6fWRadVIoXiKeVO3i4zbr8QeZnw4P6WpzOSJZS
 leQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: EC2A440003
X-Rspam-User: 
X-Stat-Signature: 1scipq854xw7kj38i1i3ncdca8f3z3zs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793306467-710882
X-HE-Meta: U2FsdGVkX1807HJDBA+9sfKVt7bQNJO9B75bkxRYl0HUfvnS/q5v7Cg8HtdnfpTBwSEy3wN98TtNfHBr5DaczbwkcovdmAw7M5b3hqAVyQFBjRQ0zp8LdcLEZCS7CiIPT3PyfkZ0iC6w50ehxc2/y9ngyBaGYNkzgJQz6SXC6c2hZy+FcxJFamdb+TBLtYjc6M8rA1upxzRysmp72w3Qvu2gE8B77VNe7hxDL1xAPLntzu8AwYw3FzY8dXzyhK/JyBFa3k4TtN6+Wf1HQS8ESgzfekBl4xxvClVIQWK7sRaNScRxbFh7Hl4pWyoOoiVQ4yKi55gzHEN/Z1NbKMV3iuK/7kPqx/TBE1DW2eVVQRgDjsaIoDWYZS1Usb45K+lOBT3lgrjdmSIAFSu1Y0ZlE6qI0ozSoTnailsgKYEAvveTRQYObyJPbW1qLlH2SXIV/mifYsO4WuDxSbId2ASbxQcBw8LPnew2WrYlkZyslmG0OIZ6zadCTCJ8QYlMMvazokP3Tl2QtMisVfnCCw74G3x0Wr7vIFa1qBblBciPZciD2TJYlk9YvxFnEJbAah3mI+6i0KJq0/DwRCJeF6kQW+XCnAVydjpywoF+kYlrRwnfivD8JjGb3N8gwDgYkl3cb2ah1nZzpN88mWUNxxYOkl+KKJ2xL6QLg8l4ySBYZ3CvsceTjIJteDI/MHQeuPUXWzNdUKkY0rOWd2HrzY5Mz8sKuX2MwR1sPSriM1rTdqBrovP0CjNyopkM0hwflcJ3DgI5rPBXgH+Bq4uePEP39XpRAjNTLrV2fgDYo61CofUDS7Vyy2g/LR/rvy1ri2Z0upcHEqOJB1e48qQxBp6s6D19RMzQxVJvzSN5Egg5fg/CeVMdm03VpFDqdXJzos2hd2QJOBYXMHSkeugb5lMG+oSpaNMAjpEUpMhPqaPTBKM9/0suXknLAAQeh0a9ukWK0A5zUubeu/pUoODhbAd
 QwYepaGH
 qFBHqK5t/aHX6+aXuTvusAkKsoWEuSZ0EBqEo53Xl/ddlF+XGmtGf3g8Ti2lG7LTQsolE6vgl2+ADwCjCnekfHwxCadhhX9Z6xmFNSL/5PfoIMpc7BkkmP+3UDfb5YoBBAkXk1Z22PwTavt3dRM6K/+7rzVYlwDG8YGNZ5aSDFFyQHVh1qoMdOm/xd6dgpNWBKvF4BpF+1epBLta+kf2/bjCFaoAqvtnVJTlxEDdTycOZYDLVv8hxuJSS1vxkYSP7Ux1RLtEd142fS/7nEnDOtFsWHdXaWHnLg3LZrlT9soKYuGtojpRGvnUWt/JvW9ZqGe7Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
clear a leaf between the lookup and the move. Holding mmap_lock in write
mode does not prevent this.

If the zap happens before move_page_tables() tests the entry, an empty
PUD can reach move_normal_pud(), where pud_populate() turns it into a
present page table entry. If it happens after the test, move_huge_pud()
can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
warnings on powerpc.

Recheck the source under the page table lock in both helpers. Treat an
empty source in move_normal_pud() as a completed move, and use
__pud_trans_huge_lock() in move_huge_pud().

In the future we should likely have the code lookup a PUD/PMD lockless
once, instead of multiple times, because one of the problematic bits
here is the:

	pud_trans_huge(*old_pud)

Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 16e736c72d9c..91f0865f6aee 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -461,14 +461,18 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	/* Clear the pud */
 	pud = *old_pud;
+	if (unlikely(pud_none(pud)))
+		goto out_unlock;
+
+	/* Clear the pud */
 	pud_clear(old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
 	pud_populate(mm, new_pud, pud_pgtable(pud));
 	flush_tlb_range(vma, pmc->old_addr, pmc->old_addr + PUD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
@@ -503,7 +507,9 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pud_lock(mm, old_pud);
+	old_ptl = __pud_trans_huge_lock(old_pud, vma);
+	if (unlikely(!old_ptl))
+		return false;
 	new_ptl = pud_lockptr(mm, new_pud);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);

-- 
2.43.0


