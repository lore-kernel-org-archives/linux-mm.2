Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B795CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 16:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43076B008A; Thu, 28 May 2026 12:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A096B008C; Thu, 28 May 2026 12:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57496B0092; Thu, 28 May 2026 12:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA24B6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:56:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E8F61A062D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:56:57 +0000 (UTC)
X-FDA: 84817433274.16.2B2E500
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id A75732000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:56:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RtxHGihu;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779987415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODVkNxNqhWTJOtKAdxjrGaooJs+N26LEMo3Jm83wAZk=;
	b=Ag9B9zkh8JoZmUvDkrLdeN6audRP5w8webyMB2APbkDAhZxQvj+qlucVos5xsZkboIpZ6+
	uy33ES3tD/rbeQzBYx13fizpiND1ZVYwaMbIdiCBwlttFiGal2jNXJxPE4bXmX1ZnpELv8
	VprLZt8aGKFMi+Y99h9qgbAyuAPPJ7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779987415; a=rsa-sha256;
	cv=none;
	b=DvuGczbYg7rjGkSiOyAjR1zhN393LHfcj5a5w30Z30VZ7dXkuC78OHx+Vi4iG5qGyEeYX7
	+ABm6OyylFTGHp6El9SUVVme4ib8rirZV4pVsKvdij77i8sP2PN0/hR4XFwm4v2s7WkyD2
	rPn6go6CPLZ2ntF1/nKyxmS/XFI0kec=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RtxHGihu;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779987413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODVkNxNqhWTJOtKAdxjrGaooJs+N26LEMo3Jm83wAZk=;
	b=RtxHGihuDflh4ac8Bae6kMhwJa9BvxP/Jh+0u/dFzZDYk+edYYoavV2mvjkuya5R0K6zcv
	lW0HhTgfQ9mJMowmgn2+H16hdpHyaBmJp6WfvZz9s3ybjlOAIHleG1FVI6h8CZz9PVORtg
	DDMAiJOC18RySHWHtTghSsEOWVd3dQY=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 1/2] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Thu, 28 May 2026 09:55:19 -0700
Message-ID: <20260528165635.2068012-2-usama.arif@linux.dev>
In-Reply-To: <20260528165635.2068012-1-usama.arif@linux.dev>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: bmfa1ogpc8efa553hxzuhrf54gcu4otf
X-Rspamd-Queue-Id: A75732000C
X-Rspam-User: 
X-HE-Tag: 1779987415-587762
X-HE-Meta: U2FsdGVkX1+8tsaa8plfcvp+XOfCoEj6cl6WehhnS5C+q57iQUR7B4sT9NAVty0l7Jid0d0tLNDgpY/Yeyo1ZtGI1dTePTVQOdLG4AHfpeQh6jtumc53rP3SlCfb2i/wurrtElTfGvAtBKJNtxlIfZoo621rsy4BuXTdBHr73BPdxRTRqDZECZO6JkmGig5V5h/qU3KMILftea/vKMgAheDf6wpnIwOp25su11n/2zdIXz+3vljIRr70uD3TtzGg/MvygVUmiqCssNmk/4yjaI5TDSVZnRLLdhq4/C6IB/uI91WBSne41BRhZ4CRvL8Yud1KQPR4Wr2U0lzy2WbEvLklJ06acYt5WRaVapALeJfaB6D8kBfpv2GrCraErz+20jdV1GUNIwff39PkQlseMe8/Ia9oqJvsbUXP5wbamBiERLGgOwtxiO6dFseMhsvP8Zr/p2M+ZZ+/VA2jumR7gk/TVzDuFhXxH7ML8yUEwrfYnsureHNYL9Maw9sdLy2wghs81cbyGj4vyLZX/ouPrY84oLuOXnuIHgTbFmtFmcWo+s2bC/55tvEZJMZwC4Oc9CDq+WmQ8SxV3LldenrM7MVZW5kR34bJL1M9hKYljA74wcLN9RZmbCTT2R6s8ls7wkorRnrDIRCzBfJkQPO8xgErXNZosXoHHM+6bB9SvjGCtgSIJEazn7RJnClU75IPk0aBI0W9euCIbvwEIlaEzFgW3Z4eVtYULKETJCW9QCzDnvmYQXhlUIix2o8FFWUKto2KLPoUA+Dq0BK+rtKUrNmZ3+ggIL1K/hrDLvWp4yzN81gFjrbdPdkzQ1tD8F10zSVaNhsw0pYOj0VpjQHwH8E+We0PybKrYqL/NTpqbjFM6IMJsEPdOsWzrgV+3NRZAF9f9Iv6ztQWmx08EC4TN0u1AkOnk9RNXJsnnGSnYC8+9YW5hpdHBehUbDENXo7/k2GERptvYRdt7+3j+nj
 7CyXk4YR
 TycrcZstg4AUqhLP4Khlil0TS/OhwCUmnRhOm4rzdIZNjZASFM0SBWFuFUuTgge1jSEEL7JvQwpz6gajEafxfQzcciDTEik6LP7BWAPhXNqSqJAaEFh2K5IZyjERFgjDYAY8rAlfmo6q4a5U50ugp6K42pQ7u6khHT7yJ/+B5YpS459Bnc6XMg5U3Z9Z6Kx18VAo+SOeVM/QqmKnJV+GeROtdzl56qrccgiSLNUg+wDes+lZMciPwI7VFvgPocVlBKuvbXR6CuJQlL/bztO043oriDIdu0hMTUpOE9h2QkaG58wf7S/oyz0LjiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_miss heuristic is intended to stop speculative mmap readahead
when a file looks like a random-access workload. That does not fit the
VM_EXEC path very well.

VM_EXEC readahead is already constrained differently from ordinary mmap
read-around: it is bounded by the VMA, uses exec_folio_order() to choose
an order useful for executable mappings, and sets async_size to 0 so it
does not create follow-on readahead. When VM_HUGEPAGE is also present,
the larger readahead is an explicit userspace opt-in.

The mmap_miss counter is decremented from cache-hit paths in
do_async_mmap_readahead() and filemap_map_pages(). Those paths are not
always enough to balance the synchronous miss increments for executable
mappings. In particular, when fault-around is effectively disabled, such
as configurations where fault_around_pages is 1, filemap_map_pages() is
not reached from the fault path. The counter can then become a stale
throttle for VM_EXEC mappings and suppress the readahead behavior that
the executable-specific path is trying to provide.

Skip both mmap_miss increments and decrements for VM_EXEC mappings,
matching the existing VM_SEQ_READ treatment and keeping the counter
accounting symmetric.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index cca20e350c95..a16b33e0fc71 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3339,7 +3339,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3434,12 +3434,12 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
 	 *
-	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
 	 * do_sync_mmap_readahead(), so skip the decrement here as well to
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
+	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3941,14 +3941,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
 		 *
-		 * VM_SEQ_READ mappings skip the mmap_miss increment in
-		 * do_sync_mmap_readahead(), so skip the decrement here as
-		 * well to keep the counter symmetric.
+		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
+		 * increment in do_sync_mmap_readahead(), so skip the
+		 * decrement here as well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & VM_SEQ_READ)) {
+		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-- 
2.52.0


