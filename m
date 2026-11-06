Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE50606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K70IeZK4
Received: by kanga.kvack.org (Postfix)
	id 85A776B05B2; Fri,  6 Nov 2026 05:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811776B05B4; Fri,  6 Nov 2026 05:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F7B6B05B7; Fri,  6 Nov 2026 05:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6216B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:03:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6F9B120CDB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:03:34 +0000 (UTC)
X-FDA: 85404257148.01.A212721
Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48A66A0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:03:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K70IeZK4;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMheU+EhCPcWnJV6yby7BQW3sus9xoZHDLVucVGtR10=;
	b=T5IeQkY+mMMfAMZo2n0yy/2hm60/UZx7emc0eiQutvaWNIvHaiAviO7J2H1Bi3TeyTzWAC
	rOqru56IaGjf77QSuz7XQvJxIktkL0mAFkCtDhwW+GJcuXgiEiBppetZ2KMILiS+vpfc+I
	tABK4cCJyEGQreB5Gh2cKQhaAADAzEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959413;
	b=cueLjYKIFuMalIOu+KPDbwvei+eyGFI4BxLBydzUM6jCp3OwBf2HW5mCv2ALag35aNIB/O
	3YtV8tPXI3S/h9HIf1hYUs/aEsCsClkJOclU2B/pvi2xfx8LUu2ucBi5izNE30nvRcif2k
	TKuDCYrxZbRRC9a0B3LqgmlMSvTOteY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K70IeZK4;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HebWn3oEvn+Xp5ULYEc4RbMXXdDqctn1MVk/JQNM9Qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959408; v=1; x=1794564208;
 b=K70IeZK4ChyvsIjWjnf+4PyYUZUZL+M7DAGxBjGVRAmkn4E59xs9gXe+dS1tEo52DLU3NhHk
 wXzvG7P/tU2y7zNLQsSQnRMcfXQ4yMM+F2CZjQk+ARRmJKVphNGgrmSLhAxkOKraKZmY/dMWglf
 06tBoeDwOxOfZFLyydTEs3CE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cd637f8f166aebf7;
	Fri, 06 Nov 2026 10:03:28 +0000
X-Mizu-Trace-ID: cd637f8f166aebf7
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	hannes@cmpxchg.org,
	songliubraving@fb.com,
	riel@surriel.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	joro@8bytes.org,
	robin.murphy@arm.com,
	steven.sistare@oracle.com,
	jhubbard@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into pipes
Date: Fri,  6 Nov 2026 18:03:20 +0800
Message-ID: <20261106100320.77084-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jkirruedzrc3zbnnmd6zou7yn4prtiuq
X-Rspamd-Queue-Id: 48A66A0002
X-Rspam-User: 
X-HE-Tag: 1793959411-433883
X-HE-Meta: U2FsdGVkX1+iGGhL3+fAOC9r9I7wG4TN8Agifn9bqLCbXBIBRob3iAxL1FXX+gUwJ2Dk9jkPAW+cquogUSXPXT5yfam/+JWxqb3td/1JS8sq4iVmjv4ZNjaOPhM/Vbn4gTf16kPlALgpIT/e8wQ9QEqnlwsP904WgNG8/C1dwd11o8jGdoaOxxmwyLIGxUKgMPV/SxbyW+5PmWmij6PQGyKJlg6NfETlIg5iI90mqOSpLUZBF8o7Dle+35uRMOU8G0eSkN+IBAKnYtu1fr4MtqpMEMVmsLy0/tVgcZagS4IDuoF0evB6DgCw1014/b4MoEhdPq/9UKfUhDlUvj0knjLsFT0Yg5A8W8Trj9bo7q12ex4aByNWCszBRH3/LCxuEqC1gomYzkziERx/KIz1SCNiXnWcMVCDigD56xIaEb1wD4TUU6dkrUwtVFeOjj3Hest5cSAC2vdKSb6YWbhLJd4re9qnYuB5ZaP4dK8rwhxpOV6D20GPJbPI2WbaKnujOolpNNrnkGDjwCZeNSN93qnI3bEH9woRIaYz+ezNEnc0yqfMEkbGTa54xxrI+gfp9FtWMNo0aFnBGMeWE7SJIEd5AsGrQ1hDjciYFmDusZsN+wz2MmvTiqzXnkvCNKqYa+NhtJhuzL6MHKY228ZOirV7V7vzduKEJM6J2lKbgwJRbLRTggHG6+OUWnzHUKSCk5wMyn8ElUF4DnWHXYnGAh68SvvbbtdPdTZ5SezuW4WY4Ze8nEL4hc0mmXJRhaLrWz6EPDVORfevZ6w5qhwkHNHtPhEvuAnm6wjONR4UdrCtumix0qOWJ15cfjhW1f4NIRdX4fhtUMzFf1wkOHrW+2FAzyvUxrUiDprBbOphh4+oqcYQZGhZ7VSglwCFh5h2ys7YsHZTPlNZyMYZDh7ztZeRGZDHnNVcdVu6zoVNlDbacdUo5cm5HmxcA7cHZc8RSo61uEsYdiyNsfRmW1P
 BfkGKVkA
 a05CsXoxPkyqpZkwkFt9VEUAAP4FEX3iWjJvHv05O6ZtYmaEMouw9ycoL7mnw2OpVwa7d/Rll5msD5fNx4k3gOKyhmXfbLaCqpTqcRmVARX6vDn5mnd/cBT898540iNfw1o7unZGTvJREjRSvX3vmq6VWVrk+8PrC/VGi7muzo38bN1gW+pJqYHLPphPgbqZmyi2A5liRyJmLYNv5cEhfl0vLp5CshAgmDCYp83vMiRZCfzpU+ey2wmMP2zQ9ECXYdWuxSVcIqIYLxLv8yhLzCS2LE5Ombzho2tbZ/Qn2zmmZC1gjYnEXidYOS1sAeANjkTY+sHI7QcV4hx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 02:10:11PM +0100, David Hildenbrand (Arm) wrote:
>Similar to mapping pagecache folios into page tables, let's reject splicing
>folios into a pipe if the refcount is at it's limit, similar to how we
>handle it during GUP.
>
>This will prevent more cases of possible folio refcount overflows with
>large pagecache folios.
>
>Let's keep it simple and check in the two callers of
>splice_folio_into_pipe().
>
>Also check in try_get_page() to cover pipe-buffer duplication by tee()
>and partial pipe-to-pipe splicing.

What about fuse_ref_folio()? Buffered FUSE_WRITE requests can carry
pagecache folios into a pipe through /dev/fuse without going through
splice_folio_into_pipe() or try_get_page() ...

Cheers, Lance

>Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> include/linux/mm.h | 9 ++++++---
> mm/filemap.c       | 4 ++++
> mm/shmem.c         | 4 ++++
> 3 files changed, 14 insertions(+), 3 deletions(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 79ae8fc0d6bb4..a82cfbce18215 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -2287,10 +2287,13 @@ static inline void get_page(struct page *page)
> 
> static inline __must_check bool try_get_page(struct page *page)
> {
>-	page = compound_head(page);
>-	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
>+	struct folio *folio = page_folio(page);
>+
>+	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> 		return false;
>-	page_ref_inc(page);
>+	if (unlikely(folio_ref_count_over_limit(folio)))
>+		return false;
>+	folio_ref_inc(folio);
> 	return true;
> }
> 
>diff --git a/mm/filemap.c b/mm/filemap.c
>index 920bbf86dfdff..0f2ec790a5b65 100644
>--- a/mm/filemap.c
>+++ b/mm/filemap.c
>@@ -3168,6 +3168,10 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
> 			if (writably_mapped)
> 				flush_dcache_folio(folio);
> 
>+			if (unlikely(folio_ref_count_over_limit(folio))) {
>+				error = -ENOMEM;
>+				goto out;
>+			}
> 			n = min_t(loff_t, len, isize - *ppos);
> 			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
> 			if (!n)
>diff --git a/mm/shmem.c b/mm/shmem.c
>index cda1a0f7db99d..1c0f6bceac486 100644
>--- a/mm/shmem.c
>+++ b/mm/shmem.c
>@@ -3819,6 +3819,10 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
> 			 * Ok, we have the page, and it's up-to-date, so we can
> 			 * now splice it into the pipe.
> 			 */
>+			if (unlikely(folio_ref_count_over_limit(folio))) {
>+				error = -ENOMEM;
>+				break;
>+			}
> 			n = splice_folio_into_pipe(pipe, folio, *ppos, part);
> 			folio_put(folio);
> 			folio = NULL;
>
>-- 
>2.43.0
>
>

