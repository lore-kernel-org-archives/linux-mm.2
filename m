Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAF1C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 22:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C906B0095; Fri, 21 Aug 2026 18:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CF16B009B; Fri, 21 Aug 2026 18:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862876B009D; Fri, 21 Aug 2026 18:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 545496B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:42:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8FC4A02C1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:42:23 +0000 (UTC)
X-FDA: 85126751766.17.450C549
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E41BF20003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:42:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QIlV85+q;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787352142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9CQyOmf/Rybu90TEulvLrigp83ODa7p0QZ6bIv+E0w=;
	b=1h412UnxaSx93TnXLpUG05p9ckb8xbDXhyv06zAHaJ6StKvwTgVplmO1Yg/VIT19eICyJd
	xouQpS0L6uj2xISmRrDN0mA8ChTGnRBx4QeVzz+bhVwp26WeMRQ1u34PtSwdawJGZOdocP
	ENUtfPD2vvD4mr0Y+4H6NA4cZ1tdN34=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QIlV85+q;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787352142;
	b=sQLGCfXwmEOaJyNHobxD5GIcNWZU22YztYaUATpiyAKSBdBqbpxe/oNtooKuHp4tmNyR41
	aQJ5T0RM18O8xI6jbe8yfLKbN7yijc5UJ5s0nACtaFnVO+YGJiGknuGaw/q3DWKkhL+/94
	RFixoNqrLp1lcWxXPZSkpfmopAwBK74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C598A42BB8;
	Fri, 21 Aug 2026 22:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0FE1F000E9;
	Fri, 21 Aug 2026 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352140;
	bh=f9CQyOmf/Rybu90TEulvLrigp83ODa7p0QZ6bIv+E0w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QIlV85+qcpx3Sm9C2JgqyK01FpRBw+qcJQBLJQrChFe4pHPST3G7pUUMn1IMN9iSR
	 FMMVKDSZA6G8mOqDLWzCKPcNDzUMtgNle8mVfZFDwHoZMf+UnsfSNK7KNDe4/WN3e4
	 ZaxUqJEw4waw2JcA6FxDXsNs+Aq/xOnKYQkeIOrw=
Date: Fri, 21 Aug 2026 15:42:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org
Subject: Re: [PATCH v3 00/19] maple_tree: lock checking and clean ups
Message-Id: <20260821154220.dfba955a79df3449c6e7dd76@linux-foundation.org>
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E41BF20003
X-Stat-Signature: awsdn59dxzn74g8nykau4grad6nkpq1t
X-Rspam-User: 
X-HE-Tag: 1787352141-769878
X-HE-Meta: U2FsdGVkX19ds4OisERlp6Ayd0cAAw+ldO8a1JInFo6y6FnARlkFllWuWktApWeR5HNvggPv9EDFLgq1DnX+ImIaIhxEjqyoDdkIz6kPfs9kkvHToTlrDfNpZbomPiuFHlg3gnL5olvf5xcoXeiqn8sxFmJTMbXKDP7RggpuC+JBGYoJSWGp38FsTz/IqcpXAXhNNd9WVYFKgeOf6UIWaXXqU4ocjXprRTETfyaDP9rPdIvrBxUy29EuFYR3QDnOY/wTI2wvOW2rcTDCBUVSwEQK8NZFkofBO/9KRkZkkaQHVUBr5S/EBGxCpL0NINxKVt7Q0eztdz8U7avP3fvtJqeuMMezH8fq6+iDF6rXypjDvHG6MR/2Aos2yyEMf7PK89E9Etj59+3E6qHhS6YZNWv2+IylvZRlN3UnsREP7VArkyFWQCSAlUgMEBBMTt6dazTJQ/0CMfg9w4wWmqlasNnwfBqpErZcDfiuHq/mVKQHnGNBUzT4tSUXcI8Mj3IVbohM3HSQ+Oow7mS5GHN49D8K2Mi+zXI5azNH3uKUFk84RE2WWOr9KrjsPiZQoOcjcReQGSt3/gtKjv9ZcfhATTE+KyAOUZA5sVyX7uxgOawjd0lXVFwnJ33UzqZKyI7VaDSoLas4WQYwXbH6yDKlWzfqg2r8T5+DP/G+cOW6D7G0BHRV0j/WoVPgQUMyc4xhYM6kOSkhWc8IwadEzH6PcQuyfcUGGIQJjUncVqQbPYOFG2ggRh9wY+jmhdR/CzfOs0o9wEgNYoccLjrQfkIohqboP54iMhHu8dJitxcBs6U2nMENxABtXyrjX7FOK0WU3m4zEuWcaoB2zvrPpV0O1xD1S1yftqOiLJ+G2m93FXMxE1vosUG9vOGPm5OI0q9fmUV+VIbCcAEBd/VRMZYIijCKYnGVgDBwptNZsHQw5qZlWYKUywxTtNOEOA9wiB2sv3DWwTfS8LDS+dBJCyA
 O/GYEyXP
 LyDLFQ/ie+rjXjs0Z7GGrJTNqo5fCOI0h3hCsayzY3B9Jtbkd/CRsFRt/Rl5vYSXMo7h6AI2mJsna2oO6Mq9ZKbIkJqbNa0iiIrLD8pQ3FjJTpTbsbs/5CmWqMBGcHe/zn5uUcIRJCYUmFkFliTs5f0pdzrPXZTugoqn7Dcb7lLfzTwM7e9GRzkHuWN4YkiP5AM9Oya2CichXd9y1D9dmYdIvt+Cwll+QCAEMHOrcjCPMGAzQb18R3nkTFXqdtK7LhyeumlLocwdI5ODmAH84MKNY7q70tY1mcSBoji9ZfFKhzD2b3Op4MB+zZVcd4O5IDLDL80mZTlVTBeKIA8acAa0ZPF5CDZ4ex+OK+XZ7Rs3lHOBCha2smdtWAYEoscOeAV5b1WaY5o8ubm8PqeS62LSrJrAqmiZVhCAk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 15:26:08 -0400 "Liam R. Howlett (Oracle)" <liam@infradead.org> wrote:

> In this series:
> 1. Try to detect lock issues
>   A number of syzbot reports are incorrectly pointing to the mm exit as
>   a source of the locking error.  The first three patches attempt to
>   help users detect errors in their locking - but they still have to use
>   LOCKDEP.  I guess it's still down to hope and prayers.
> 
> 2. Documentation fixes
>   The documentation was lacking clarity, there are updates to try and
>   help the users, especially around the erase() cases.
> 
> 3. Two benign issues
>   The cyclic allocator may have a race, although no in-kernel user can
>   hit it.
>   The erase functions may cause allocation issues if used with the
>   incorrect locking type, but none are present in-tree.
> 
> 4. The erase gfp uses
>   mas_erase() and mtree_erase() do not take a gfp argument.  To improve
>   reliability of the erase, the first attempt to allocate will be
>   GFP_NOWAIT, followed by a retry (if necessary of GFP_KERNEL |
>   GFP_NOFAIL.  This will ensure the data is gone.  I've updated the
>   documentation to make it more clear as well.  mas_store() is not
>   addressed in the same way, but may need to be updated at a later date,
>   but that may require changing callers so it is out of scope here.
> 
> Beyond these goals there are some test fixes, some general speed-up
> patches targeting extra work and cycles, and dropping dead code.

Thanks, I updated mm.git's mm-unstable branch to this version.

I added a -fix for [13/19], per your discussion with Jason:

--- a/Documentation/core-api/maple_tree.rst~maple_tree-document-erase-and-allocations-better-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -75,7 +75,8 @@ given index.  You can use mtree_erase()
 knowing one value within that range, or mtree_store() call with an entry of
 NULL may be used to partially erase a range or many ranges at once.  Note that
 mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
-fail, but may need to sleep - do not use mtree_erase() from a blocking context.
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
_


Sashiko said a few things which I think are new since v2.

	https://sashiko.dev/#/patchset/20260821192627.4085470-1-liam@infradead.org

> Changes since v2:
>  - Added a mas_nomem_nofail() function for mas_erase() - Thanks Jason,
>    Vlastimil, and Pedro.
>  - Dropped the WARN_ON() that was triggered by syzbot and questioned by
>    Andrew - Thanks Andrew (and the syzbot)

Here's how v3 altered mm.git:


 Documentation/core-api/maple_tree.rst |    9 ++-
 include/linux/maple_tree.h            |    2 
 lib/maple_tree.c                      |   65 ++++++++++++++++--------
 3 files changed, 53 insertions(+), 23 deletions(-)

--- a/Documentation/core-api/maple_tree.rst~b
+++ a/Documentation/core-api/maple_tree.rst
@@ -74,7 +74,9 @@ but takes a range.  mtree_load() is used
 given index.  You can use mtree_erase() to erase an entire range by only
 knowing one value within that range, or mtree_store() call with an entry of
 NULL may be used to partially erase a range or many ranges at once.  Note that
-mtree_erase() may use GFP_KERNEL on allocations.
+mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
@@ -174,8 +176,9 @@ You can use mas_erase() to erase an enti
 last of the maple state to the desired range to erase.  This will erase
 the first range that is found in that range, set the maple state index
 and last as the range that was erased and return the entry that existed
-at that location.  Note that mas_erase() may allocate with the GFP_KERNEL flag.
-If this is not okay, consider using mas_store_gfp() and pass it a ``NULL``,
+at that location.  Note that mas_erase() may allocate with the GFP_KERNEL
+__GFP_NOFAIL and cannot fail, but may sleep.  If this is not okay, consider
+using mas_store_gfp() and pass it a ``NULL``,
 after setting up the correct range by walking to the entry.
 
 You can walk each entry within a range by using mas_for_each().  If you want
--- a/include/linux/maple_tree.h~b
+++ a/include/linux/maple_tree.h
@@ -570,6 +570,8 @@ int mas_alloc_cyclic(struct ma_state *ma
 		unsigned long *next, gfp_t gfp);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		      unsigned long last);
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
--- a/lib/maple_tree.c~b
+++ a/lib/maple_tree.c
@@ -5669,9 +5669,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.  An externally locked tree must be protected by a lock that
+ * allows blocking for this API.
  *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
@@ -5683,8 +5684,8 @@ void *mas_erase(struct ma_state *mas)
 
 	/*
 	 * In low memory situations, the allocation is retried with the gfp flag
-	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
-	 * the external lock is not dropped.
+	 * GFP_KERNEL | __GFP_NOFAIL.  The internal spinlock is dropped in
+	 * mas_nomem_nofail(), however the external lock is not dropped.
 	 */
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
@@ -5698,16 +5699,8 @@ write_retry:
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_preallocate(&wr_mas, NULL);
-	if (mas_nomem(mas, GFP_KERNEL)) {
-		/* in case the range of entry changed when unlocked */
-		mas->index = mas->last = index;
+	if (mas_nomem_nofail(mas, index, index))
 		goto write_retry;
-	}
-
-	if (mas_is_err(mas)) {
-		entry = NULL;
-		goto out;
-	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -5746,16 +5739,48 @@ bool mas_nomem(struct ma_state *mas, gfp
 	 * Return false on zero forward progress.  Partial allocations are kept
 	 * so the retry path will attempt to get the rest.  The failure should
 	 * not happen as we try our best to reclaim.  The user would need an
-	 * external lock with a non-blocking gfp in a low memory situation -
-	 * which would have triggered the first warning in this function.
+	 * external lock with a non-blocking gfp in a low memory situation.
 	 */
-	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas_reset(mas);
 	return true;
 }
 
+/**
+ * mas_nomem_nofail() - Retry allocations with __GFP_NOFAIL, if the maple state
+ * has stored the -ENOMEM error.
+ * @mas: The maple state
+ * @index: The start of the range for the @mas reset
+ * @last: The end of the range for the @mas reset
+ *
+ * Return: false if @mas isn't in an -ENOMEM state.  True if the allocation
+ * happens, the state is reset.  The internal lock will be dropped and external
+ * locks must allow blocking.
+ */
+bool mas_nomem_nofail(struct ma_state *mas, unsigned long index,
+		unsigned long last)
+	__must_hold(mas->tree->ma_lock)
+{
+	gfp_t gfp;
+
+	if (likely(mas->node != MA_ERROR(-ENOMEM)))
+		return false;
+
+	gfp = GFP_KERNEL | __GFP_NOFAIL;
+	if (!mt_external_lock(mas->tree)) {
+		mtree_unlock(mas->tree);
+		mas_alloc_nodes(mas, gfp);
+		mtree_lock(mas->tree);
+	} else {
+		mas_alloc_nodes(mas, gfp);
+	}
+
+	mas_set_range(mas, index, last);
+	return true;
+}
+
 void __init maple_tree_init(void)
 {
 	struct kmem_cache_args args = {
@@ -6042,9 +6067,9 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
- * Note that erase requires allocations and will use GFP_KERNEL to do so if
- * necessary.  If the allocation fails, the internal lock will be dropped to
- * retry.
+ * Note that erase requires allocations and will use GFP_KERNEL | __GFP_NOFAIL
+ * to do so if necessary.  If the allocation fails, the internal lock will be
+ * dropped to retry.
  *
  * Return: The entry stored at the @index or %NULL
  */
_


