Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF63CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643A46B0005; Thu, 14 May 2026 09:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F46B6B008A; Thu, 14 May 2026 09:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AD06B008C; Thu, 14 May 2026 09:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 419626B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:28:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB6CC1C0413
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:28:57 +0000 (UTC)
X-FDA: 84766105914.06.82B8DC2
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6452C000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:28:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gy4rLQF3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778765336; a=rsa-sha256;
	cv=none;
	b=fuyAcwwpvALHkD4qZTmgqoExz9hhbcp9p+PirdrGAjO/UQhzqRvLngMAne8ZM1MqQb2lH/
	+jPxrw0IZsqYri1WboGhns+abRPOnxoT4rHtXH5WTNIa2xm8YcCvVWqOa8tiOiQ6Uordq2
	ykWQeBqPEhwnfXlyRjiXJTbo7KIOAmc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gy4rLQF3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778765336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHsQvgnGni5VzgHRfyddSYqk4CVVONQEgEqMCt8cdnY=;
	b=vqMGORRGBWxlQrNvdzFl42cjWn8AVDHPk8Gld9o36x7JQfU3dnMusc76082SR2V6dl/6jm
	o0eTzz1r1CAM4WCs1d0fVCm+awws7cFfuDccYw3AQj5PLdJfgLvfULQ7FoXJ57prbIHYos
	FLVgP9K129HLmr8eN291EVrheoSEHtA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778765333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CHsQvgnGni5VzgHRfyddSYqk4CVVONQEgEqMCt8cdnY=;
	b=Gy4rLQF3LbRi2vNN5nxzWcmxA0rj1izyKV4hVle7D6TZWBOFHaO+fDNE1T6lfPxCtV+ZWm
	C6dXs4GRA6SUMk/uccaOIKQE0nAtepkm5OPEDqz31U98o9qMsRRc0r5+v4EDmY4BHXN5K9
	jXcavJKzAVTla4wEJjC++MsqneecnGs=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: linmiaohe@huawei.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	nao.horiguchi@gmail.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	liam@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v7 2/6] mm/memory-failure: surface unhandlable kernel pages as -ENOTRECOVERABLE
Date: Thu, 14 May 2026 21:28:30 +0800
Message-Id: <20260514132830.25622-1-lance.yang@linux.dev>
In-Reply-To: <20260513-ecc_panic-v7-2-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-2-be2e578e61da@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x4jqoqk63w7c45f9wkhieg6r4zpi5ajm
X-Rspam-User: 
X-Rspamd-Queue-Id: D6452C000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778765335-974490
X-HE-Meta: U2FsdGVkX1+KcicxO1YYf586cLhGGV+y7yME6x1fICReeS47mKRQE9wZslku0StZqGq3VTkxJV1+z+fC/Td7HrXKNw/+ZMtyqfH8YG+eW/i9gCPu66hGZkajhw97ok9eU9pdQ3zHHvHdwNjTWgOzAArzasqvlLdFlge5xE5ldHBC5+RPWTnGLPCNhwPwPLQ5rmHFkCH+Cv+gyyMONh+6aHwT70mOt16JE8ITaA5QuAl4/nLC8CQIKUnkbQGTuTJC51TpKnziSDH1leAGXUEEn6n9/QMMkeNxaCSdxfU9clX1Vaz9csJuNhpcxWSJnnlJMXyq0JR3b6rI3ricxiXeWyoZ4GR5JKLnXywAV0W7wCJOD6X171vcNwMk1TFfa5QpuFd5zqJF7+8LVeQiMRMCLJGak797hqEJ4zmhfS8pd6xNAeO8pRdpSEQ5mTX8x/nqzfcAuu9Fbny8kkeUq5aTVvxUOYLR+wsQ4MeVqxI/27JoQpyOHXnKpMoywa4yIjHGs2Wp/U5vK66dmb0JMSLW9rJltNh1pYOXzhtc/KyaEdTTT+7rDkKJIqY2SQGO7SvL9J7b/w6zLX1BCZaJiN7nTix3FOYbr7r9fyfhpKQzpHGvEOOE8jQz9ZioI8bzdiE4gGW1qeymn5Hr9xDf2r4jHbCAu2IBS3Zf2e05nXlt73vZlaFIOK2i9Q/+bkqDsb5344QRP0tx8t/TZaLS2qLRjKybJlBq+pCZ7unF2cYXAlpM1x7hv5Ug/MsGlhnZLzpP8SywKrBn2MpgJ/QvzCiE8FNNjAoZY9G8aa0XrCh53g2oJz951LksimZc3OREBu5gByG3/+7mX+rKXElryCKzHJuHJ4mEWIW22mQXhZ7SbjmCC6BVRt3yunIw0Q5FUDSYgXJKaaSw7sUc4DMUekZlA8HHkrPuNe7ou1gryjzJURijMfGM9//qWRgJlTmTxHHm9WGoS6YpiMeZZwpjdry
 kB8xnYK4
 EemfWsKMb0RIqMoRLWC3ecduHFNyUHvSt/Q+HrvDpHCuKeqqX/Ng08XZgoON9kDsSyzBMMjSsqp7Anoe+QqjpCoqOf5QeyhHAUh3PpxVugQNMYVkPaVfdqlUpH4QiMmrpv5JHX+oQgie8XqRpQAEvoJ3Mgu9omZQWKr5dlNaHrfwD5H8DCp6iVTtrN3xmeh7xo1056vyEBLnxP3k/4j/4lCeKkjn4X063nl/NmM6k/CcT/cY8O1Y976uuxMLrbJKSfSyiWj4P4o9G/FFyRUwJnT1KxenmyQs43V3NBQJg8mnB+jcHayTbvhlmGi2uSH20mgepaCePUhfdtWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 13, 2026 at 08:39:33AM -0700, Breno Leitao wrote:
>get_any_page() collapses three different failure modes into a single
>-EIO return:
>
>  * the put_page race in the !count_increased path;
>  * the HWPoisonHandlable() rejection that bounces out of
>    __get_hwpoison_page() with -EBUSY and exhausts shake_page() retries;
>  * the HWPoisonHandlable() rejection that goes through the
>    count_increased / put_page / shake_page retry loop.
>
>The first is transient (the page is racing with the allocator).  The
>second can be either transient (a userspace folio briefly off LRU
>during migration/compaction) or stable (slab/vmalloc/page-table/
>kernel-stack pages).  The third describes a stable kernel-owned page
>that the count_increased=true caller already held a reference on.
>
>Distinguish them on the return path: keep -EIO for both the put_page
>race and the -EBUSY-after-retries branch (shake_page() cannot drag a
>folio back from active migration, so we cannot prove the page is
>permanently kernel-owned from there), keep -EBUSY for the allocation
>race (unchanged), and return -ENOTRECOVERABLE only from the
>count_increased-true HWPoisonHandlable() rejection that exhausts its
>retries -- the caller's reference is structural evidence that the
>page is owned by the kernel.
>
>Extend the unhandlable-page pr_err() to fire for either errno and
>update the get_hwpoison_page() kerneldoc.
>
>memory_failure() still folds every negative return into
>MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
>this patch is a no-op for users of memory_failure() and only changes
>the errno that soft_offline_page() can propagate to its callers.  A
>follow-up wires the new return code through memory_failure() and
>reports MF_MSG_KERNEL for the unrecoverable cases.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>---
> mm/memory-failure.c | 18 +++++++++++++++---
> 1 file changed, 15 insertions(+), 3 deletions(-)
>
>diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>index 49bcfbd04d213..bae883df3ccb2 100644
>--- a/mm/memory-failure.c
>+++ b/mm/memory-failure.c
>@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
> 				shake_page(p);
> 				goto try_again;
> 			}
>+			/*
>+			 * Return -EIO rather than -ENOTRECOVERABLE: this
>+			 * branch is also reached for pages that are merely
>+			 * off-LRU transiently (e.g. a folio in the middle
>+			 * of migration or compaction), which shake_page()
>+			 * cannot drag back.  The caller cannot prove the
>+			 * page is permanently kernel-owned from here, so
>+			 * keep it on the recoverable errno.
>+			 */
> 			ret = -EIO;
> 			goto out;
> 		}
>@@ -1427,10 +1436,10 @@ static int get_any_page(struct page *p, unsigned long flags)
> 			goto try_again;
> 		}
> 		put_page(p);
>-		ret = -EIO;
>+		ret = -ENOTRECOVERABLE;
> 	}
> out:
>-	if (ret == -EIO)
>+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
> 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
> 
> 	return ret;
>@@ -1487,7 +1496,10 @@ static int __get_unpoison_page(struct page *page)
>  *         -EIO for pages on which we can not handle memory errors,
>  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
>  *         operations like allocation and free,
>- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
>+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
>+ *         -ENOTRECOVERABLE for stable kernel-owned pages the handler
>+ *         cannot recover (PG_reserved, slab, vmalloc, page tables,
>+ *         kernel stacks, and similar non-LRU/non-buddy pages).

Did you test this patch series? I don't see how we ever get to
-ENOTRECOVERABLE there ...

Even with MF_COUNT_INCREASED, the first pass does:

	if (flags & MF_COUNT_INCREASED)
		count_increased = true;

	[...]

	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
		ret = 1;
	} else {
		if (pass++ < GET_PAGE_MAX_RETRY_NUM) { <-
			put_page(p);
			shake_page(p);
			count_increased = false;
			goto try_again; <-
		}
		put_page(p);
		ret = -ENOTRECOVERABLE;
	}

Then we come back with count_increased=false:

try_again:
	if (!count_increased) {
		ret = __get_hwpoison_page(p, flags); <-
		if (!ret) {
		[...]
		} else if (ret == -EBUSY) { <-
		[...]
			ret = -EIO;
			goto out; <-
		}
	}

For slab/vmalloc/page-table pages, __get_hwpoison_page() returns -EBUSY:

	if (!HWPoisonHandlable(&folio->page, flags))
		return -EBUSY;

so they still seem to end up as -EIO ... Am I missing something?

>  */
> static int get_hwpoison_page(struct page *p, unsigned long flags)
> {
>
>-- 
>2.53.0-Meta
>
>

