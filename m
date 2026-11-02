Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDDC606A333
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mnLeKo3J
Received: by kanga.kvack.org (Postfix)
	id 6D4BC6B05B6; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65DED6B05B8; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8396B05B7; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 265586B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:06:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2C73A0645
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:06:01 +0000 (UTC)
X-FDA: 85389143322.01.9646CE5
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 79FB420005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:05:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mnLeKo3J;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599559;
	b=mGkLpXzwvLoq37bdFzgmenkT2cx2Y+dp01M0XlnmMo37u8lqWPpHChCz6ylYjl3Q3xiYha
	IQCOpA+pUbE18iH84uXL7uLKQZkvOSsl1tFvEzs3azE7SwVzqclhmyHdjA1Akm669YDIky
	R3IkOhqQmeSyO8DKXni5sfyqiR1qHKk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mnLeKo3J;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yuFDhrhf3kM/PO/AnTTpZJjMtV5tAkK8200L66uGl8=;
	b=Z2QKBIf33I/v14ZYqUMMG0RUnMD6XdgORwDVZ88rS8Vi0l8AEJ5powgmRzh/Gt1Y0/d6zv
	et3ZAJHKAlVKO2FwyCHNEe8c+q128/HtTLSN2mwso2AMz19cVvDLia9SWKyskRCB9Ja9Xj
	/fMlnVH36zMipcr/tLvbkPuKLSIEqms=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ex0bR+wqY48y7Ys0l1lS/C4xyqfg/lqStx93s8K9wXI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793599557; v=1; x=1794204357;
 b=mnLeKo3JIlrjZ0v8csYIXQvs0MqjNYBAaha6FI+GsXgzsTBscKhu47xfdxei1GstkYX55TtU
 s7+ijDrBsSQikbWr4RhQIABec//XfnZQfXcLKbZqgwK2XEUTDJ36HqPkKEIRh6O+ifRMQgl5bW3
 ABiUUGhU4PsBaXEJa27dL80Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 85932c5ab249e449;
	Mon, 02 Nov 2026 06:05:56 +0000
X-Mizu-Trace-ID: 85932c5ab249e449
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 17/47] mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs
Date: Mon,  2 Nov 2026 14:05:47 +0800
Message-ID: <20261102060547.39942-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-17-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-17-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79FB420005
X-Stat-Signature: 6e5biwfeh46upx6ucqxw59a6iu4w4rba
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793599559-539109
X-HE-Meta: U2FsdGVkX1/z3KuFmh1N3zIVQ+oXSHt+NgX9AIQQqTrRIciSfwMUCYhbU77t2JABEYaaJXvWJM3vXtBlIK9obX5MKmqybpM052/ixRNAH8Ya+D4a2H1Irw3M3wu901jjrKiZbJ5q1ZG/9qmjANSFjTR/IIJUSiE2hkTBJU7UNKYHZezbDENX+k2f6eWUn4rrJ0aQJ5amm3EXlnugR3q/p1nptkBgfQU5nqqicM2qxLENE2AlToQzK1VyLrzmzR7wbGzXifiPCygS0ySoNXXpB7nESPLzVp7dXH+5Hp+8+nE+569dXetzCQk90hxtKf0wljDPURQitM1sCI5Iz3Zd4tRL6HarcxKJ3U+NxL7iTchGRts5Y0rdwoj2ARa7zuB22pbNukvh9DkI5Mc9CecdXOOBtBBwafUYV86Xl4SpQ5573udt0pCI3V6/qywUHWkXuAglVJ2lqjGXrIkVSKgL75cNr208hR+9UtlozQ8FF+qTwUPCg/P0oKNqJkY3PNugjD7ZgbCLDRgfQpjesNddMVdojJXaKV9dgGwgM262ZsHby8jPBo6Ck+xDvD9k1f9FsEvNRe3nQ2fF6I4WrQfnmKIRkCwLvra6Ra37wmRKVziNehW5MmDaKXl4JqfJzrhmWLoYenU0JeM31i6+MUWY9nzhmEOcOiVfvL301OlYRRHium17tHaqYLHKNxN7EVGKdZilNOIOGufg5rTBirJTcsLKursXBlAVKSDMqTfLqsjZMFjAIYw7IXLOEEi5/3mxubO0a22PQzHCQq9ZUavmOTkn48Cex05drbD2pWH9ShuPnM3yQBmLkWhfEJbKLkcRkzgIl31u2oJwdRu45pyL3+gx/bwqfXWMy2GSh+8JVsXH0ibansVladEPoGDyAUmwzk//qWcBNc65mU6vAwoMrL0Qmx32GVEhKKj+X85UQ1uft2WVItIwQVBo6xRxAFS5pOvwyrY98l5g2qeqQmU
 Mofm/t36
 E3fdk1+HK15YDfy8yDetwv0+zP8R2lY/i4ZS3Z8GG7e7YpSQjuPSgmpG7cL9iW4SmeUOqtmPKWxVPvTpRpXn83j43+hmK+uwxmnyqIQcnY6WOHnzfOAho/A9dCEVxGxZNz5uVEeV/eAOhzyjMKydWuKJ03VTglaoGuNz7elWaBNsZYZ+SNV5ZKku26R9j2gzMkos9U54tZSYTQTnHikKqRT7MftsottiwXJP1xJVZZcJzt5o/0cUNVl4ofMuhPF9P6kJMPblZBSRMTiKEz69d1pZXf5v5q1NV49mCc1VPA44bhMfacaBa13ZYoL7OffrVoXQHaILRN7OnmVenWayKLdjBO88XrMZIDSWTwdN+z8aZwXtbc00LM4pvLHz0DJ589uWRWoQNWXc04tyDVHaTlidsJRJJdirZg23W+r469KbGQWCeMVHeDWCDIY+JobDIRlxUhZvyS/DHTr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:46AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
>bits to the folio. A shmem read fault can map a clean folio writable, so
>a later store only dirties the PTE. Losing that dirty bit allows reclaim
>to discard modified data.
>
>The assumption that regular files are read-only is also obsolete since
>commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
>for writable files"). In any case, transferring PTE dirty bits to the folio
>when removing mappings (and while the folio is still mapped) is the right
>thing to do.
>
>Use get_and_clear_ptes() to collect the dirty bits and mark the folio
>dirty before unmapping it. Update the comment.
>
>This was reproduced with shmem using MADV_COLLAPSE followed by
>MADV_PAGEOUT.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
>Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: adjust comment; simplify description; cover file-thp as well ]
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/khugepaged.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 34ebb37c862c0..ce794d9760a87 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1995,9 +1995,10 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
> 		/*
> 		 * Must clear entry, or a racing truncate may re-remove it.
> 		 * TLB flush can be left until pmdp_collapse_flush() does it.
>-		 * PTE dirty? Shmem page is already dirty; file is read-only.
> 		 */
>-		clear_ptes(mm, addr, pte, nr_batch_ptes);
>+		ptent = get_and_clear_ptes(mm, addr, pte, nr_batch_ptes);

I went through get_and_clear_ptes() as well. It merges dirty bits across
the batch, so we're covered even when the first PTE is clean and a later
one is dirty.

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>+		if (pte_dirty(ptent))
>+			folio_mark_dirty(folio);
> 		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
> 		nr_mapped_ptes += nr_batch_ptes;
> 	}
>
>-- 
>2.43.0
>
>

