Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41791606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnzSr6DK
Received: by kanga.kvack.org (Postfix)
	id 4C8726B05E0; Mon,  9 Nov 2026 05:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4795A6B05E1; Mon,  9 Nov 2026 05:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368ED6B05E2; Mon,  9 Nov 2026 05:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108F96B05E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:08:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC32BA8295
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:08:55 +0000 (UTC)
X-FDA: 85415157030.11.F94C9A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F12121C0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:08:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnzSr6DK;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218934;
	b=WqjpDT3BMBuemjAlACrnz2dblGEM+3PDuPNvyn5f3kh6bpuqaCIP1bKaMFA6Io6wdPsxcJ
	38ouIrLjl8LBnWw3Z/Ghet/sQcS6bfzueh0Z4jIrnrTeVdDZM9qsbODgyKlDMeCRx5Y4cQ
	uPeMr5v8Mx8a2SlT5MzrdDCha5wMQKI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnzSr6DK;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkrTTfoabgAYGq+zadUuV0iR7WSnU+RqLdkrgA2Z5oQ=;
	b=Vk8aJP5ILW81BIwlatkUe6A4tweudFN/Md1GQYxS4YjmLKVj3Ghfh3eqHQ+n1Cr3FGfiAs
	iDnC8VduVwiJClWzgzjc1/FtRKiqzQPu3WDLKqtGGEmoW7F2Y3skhHbpY5gwO3LfgSFOoo
	0bsvm7tGPiTzZxse9yks4zge4uyAH1A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D8662D22;
	Mon,  9 Nov 2026 10:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E951F0089F;
	Mon,  9 Nov 2026 10:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794218932;
	bh=rkrTTfoabgAYGq+zadUuV0iR7WSnU+RqLdkrgA2Z5oQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=UnzSr6DKpbYpBTm8GMIeiqXbOIYx8t2wFSODP1sc1KTLAa6Mvz4KxLoHdNJdGMLml
	 EnsdMByNo8K0+Denet2LOXcvG60Zsb6ow0YCZPvLzVv6jxEjMq7iYvPqSuvhVywfmp
	 JMz9nRrsKb8fdwcYlrm0/PtZCY3A+TEI0iULX4CKWNa7AXwHKTXtpCTGT6C9OLURLP
	 nCeyh232CnzbE/T+i75A8na0nXJeUHVlX67jUkGNt58RAkYoSyzVc6myKWSJ8M6VBs
	 jvl8+MI+zL0duukiEGqiaPwy4MQlQN0a3L+784LIH69Pv9Mb2g1YL/gbWFoZZyaaez
	 mCUpL0caeNXfQ==
Message-ID: <aa6ea9df-f767-4092-ad8f-f10305e27c3e@kernel.org>
Date: Mon, 9 Nov 2026 11:08:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
 <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
 <8d23b1eb-72aa-479d-9486-dbfd86d8414c@kernel.org>
 <43fc45ff-8636-4961-a80a-29844c15d7a1@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <43fc45ff-8636-4961-a80a-29844c15d7a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9xb8njd31pfpbwnspn5tknaankd5qyhz
X-Rspamd-Queue-Id: F12121C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794218933-366883
X-HE-Meta: U2FsdGVkX18DOowGyHqMJ9itBiLgeUwNo9J/mviI6xoqXn/GKxQT+801hJVQMy9h3voOpKQe5Iq3KviHOZ5arzbk/NqlbR7OF9g1p2erb9e1/TIMbIE0YBgT3FHDHC0RpjeuJRKxmq2CC7070OmS0BSjBxbNud27PF6uUCDRSHlz9y9HQFjiPnN5hQxEH9xF888izYV8kgn6zplXRb43NFEuxhvkdEK/9MEgKBjWQwNT1Mo4QqoHHJ2KLDQh6/ziUKHVCkXKV/8wHsp6PMCY2Oy9dhP5uVnVHfVYUEO7tIc3Lj0h5H5LsSbmvfmht//a7gFgsI1rOXyEUdY7KmOCd6B//T+mvMfNt5JBcnYTb7nonF7llDLLZFKx4wBWpgB9OC01tz8Omj0R9crphSXvMqfop5UO+CrhRoV32l6ZEs897qHRrpaLbNWg2JOo+KkDoMIUNnP548tKDI54Gya+8XaazGfBOYT3OHW4AhXdXavGc2Bba1G/Gtsq8K/78Hkz3haDRl+/+dEvJYhnNjesez8pv7Q6a1iGYpcPCOZmVlHQ5vYcRYdwCecMOOuT0LAunQPk4tOLZJv7f3HlqFNUxiBRneehtYeKMv0+xG+ApRHPC2gXG2l46kj1PnOArYBg6T9HeYAeDm6yspO1FcrUaiVdfxl2LRn+h4dV6rwtycicFNPSMNYkvZng42TCUeZwct+EEt2Z/ngivaZS9QCXaO3pdmB+yWtAw6yKDqLpN4SWl4EnqQUGOT578vUDkktiA8AMAT0vfL6XhV0ujVSgdEnrAIhrz7fHw0OpvHuav11mZTyHUyj5gHUlQHp+V4L/vYNTryiTD5bSVVEyKZuo3WSoJqBe5vrDXqy0x3XV9XxVxJudiM/B/raDBXroEmWGz98apnUVcbww2TXl8WhcKYQvHTXNijWxZLhYWvPJeE0E2ayPdGUHFnBy936nWosCFNweEMyMx+Hlerg9gTk
 LRFYjatZ
 nSaE1X11Zv9CJZVdrUwAkJhYANMqqaNc/BAL2VIOI44p39za0LS8EIFK2qFrp9Ajrm2hiOFL81UuBTukcQ9I/UUEkRGkKrGQSV5fDeyR4ELvmOCYMy00B/0UZWrFmN462W0g1ySw50io8b79A2U7baomshpdcWxjhVZWBcZP39ooblIL5LUMm/REgqwIOR1rxbW0m7HB9B3uhOvtX570Sn8bnjHh60HfwFoI5nYD5titestpnuHvB9S/l1fly71fYAlNcYXeWH24nhjcjqsLfk+LR1a+kuZc3GjhmLHs9cgl4WslrEWDPrUpgN2Geq0dEN2YT6UiN40OrIm2R/IduuOqgFUzU2dDUroedC6JTxV6wjSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 10:49, David Hildenbrand (Arm) wrote:
> On 11/9/26 10:30, David Hildenbrand (Arm) wrote:
>> On 11/9/26 09:57, Jose A. Perez de Azpillaga wrote:
>>>
>>> here it can't tell where the -EOVERFLOW came from, if another file
>>> returns -EOVERFLOW (i.e. tty_fops uses copy_splice_read, and
>>> n_hdlc_tty_read() returns -EOVERFLOW after dropping the frame), it now
>>> gets a second read.
>>
>>
>> That's what claude told me during review, and when asked whether that actually
>> happened in practice it said no ;)
>>
>> So is that actually a problem?
> 
> Double checked, claude managed to confuse itself.
> 
> n_hdlc_tty_read() can indeed return -EOVERFLOW.
> 
> I should just have let splice keep failing, dealing with copy fallback starts to
> get annoying.
> 
> I guess switching to -ETOOMANYREFS should work (and might be a better fitting error)

Yeah, the following should do I think, please double check:

From 7ce030711737e8c26fb5500f2705940e93da0d44 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 4 Nov 2026 19:02:48 +0100
Subject: [PATCH] mm: limit pagecache folio refcount when splicing into pipes

Similar to mapping pagecache folios into page tables, let's reject
additional references when splicing folios into a pipe if the refcount
is at its limit, similar to how we handle it during GUP.

This will prevent more cases of possible folio refcount overflows with
large pagecache folios.

Let's keep it simple and check in the two callers of
splice_folio_into_pipe(). Return -ETOOMANYREFS if the limit prevents any
progress, so do_splice_read() can fall back to copy_splice_read() when
read_iter is available. This keeps sendfile() and other splice users
working when ordinary reads would still succeed.

Also fall back to copying in FUSE when taking another reference through
fuse_ref_folio() would exceed the limit.

Also check in try_get_page() to cover pipe-buffer duplication by tee()
and partial pipe-to-pipe splicing.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/fuse/dev.c      |  5 +++--
 fs/splice.c        |  8 +++++++-
 include/linux/mm.h |  9 ++++++---
 mm/filemap.c       | 11 ++++++++---
 mm/shmem.c         |  4 ++++
 5 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3641abb90d6bb..4f6b7b42bfd3e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 		if (cs->write && cs->pipebufs && folio) {
 			/*
 			 * Can't control lifetime of pipe buffers, so always
-			 * copy user pages.
+			 * copy user pages. Also copy folios at their refcount limit.
 			 */
-			if (cs->req->args->user_pages) {
+			if (cs->req->args->user_pages ||
+			    unlikely(folio_ref_count_over_limit(folio))) {
 				err = fuse_copy_fill(cs);
 				if (err)
 					return err;
diff --git a/fs/splice.c b/fs/splice.c
index e6d43329ed3f0..2fc1279628af5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -956,6 +956,7 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
 			      unsigned int flags)
 {
 	unsigned int p_space;
+	ssize_t ret;
 
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
@@ -977,7 +978,12 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
 	 */
 	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
 		return copy_splice_read(in, ppos, pipe, len, flags);
-	return in->f_op->splice_read(in, ppos, pipe, len, flags);
+	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
+
+	/* Fallback to copying when hitting folio refcount limits. */
+	if (unlikely(ret == -ETOOMANYREFS) && in->f_op->read_iter)
+		ret = copy_splice_read(in, ppos, pipe, len, flags);
+	return ret;
 }
 
 /**
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3356f7a670d1e..dd50262a70758 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2288,10 +2288,13 @@ static inline void get_page(struct page *page)
 
 static inline __must_check bool try_get_page(struct page *page)
 {
-	page = compound_head(page);
-	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+	struct folio *folio = page_folio(page);
+
+	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return false;
-	page_ref_inc(page);
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return false;
+	folio_ref_inc(folio);
 	return true;
 }
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 920bbf86dfdff..44b23c51ea45f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3094,9 +3094,10 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
  * Return: On success, the number of bytes read will be returned and *@ppos
  * will be updated if appropriate; 0 will be returned if there is no more data
  * to be read; -EAGAIN will be returned if the pipe had no space, and some
- * other negative error code will be returned on error.  A short read may occur
- * if the pipe has insufficient space, we reach the end of the data or we hit a
- * hole.
+ * other negative error code will be returned on error; -ETOOMANYREFS will be
+ * returned if the folio's refcount is too high and the caller can fall back to
+ * copying.  A short read may occur if the pipe has insufficient space, we reach
+ * the end of the data or we hit a hole.
  */
 ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 			    struct pipe_inode_info *pipe,
@@ -3168,6 +3169,10 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
+			if (unlikely(folio_ref_count_over_limit(folio))) {
+				error = -ETOOMANYREFS;
+				goto out;
+			}
 			n = min_t(loff_t, len, isize - *ppos);
 			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
 			if (!n)
diff --git a/mm/shmem.c b/mm/shmem.c
index be4ab228cf67c..0b30b1de81a7c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3830,6 +3830,10 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 			 * Ok, we have the page, and it's up-to-date, so we can
 			 * now splice it into the pipe.
 			 */
+			if (unlikely(folio_ref_count_over_limit(folio))) {
+				error = -ETOOMANYREFS;
+				break;
+			}
 			n = splice_folio_into_pipe(pipe, folio, *ppos, part);
 			folio_put(folio);
 			folio = NULL;
-- 
2.56.0


-- 
Cheers,

David

