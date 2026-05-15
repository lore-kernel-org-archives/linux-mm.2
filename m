Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEDACD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AB56B00B4; Fri, 15 May 2026 03:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1446B00B6; Fri, 15 May 2026 03:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EEF6B00B7; Fri, 15 May 2026 03:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74AFA6B00B4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:04:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F3081408AA
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:04:18 +0000 (UTC)
X-FDA: 84768765396.18.86FF672
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 630D14000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:04:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioF9Qd6I;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvZa42yjJAYAdcdRRX0/uxArNhxHjuKTcYRUXMctwJM=;
	b=yKSjJxazFaEPT8q3p4jIr6Rcsv3exT6Ir3/kR68b4AtlQ+Nidk4EOb8CwkczIVwid52pdY
	Bb08mzlu/ZVO3800/2nfVAGyPGgJRMZBbqIAXQ0IWtH2InWKvTSKlw2OJJzuLMPaVMWBzR
	Mhe6KFX607YkyM37s9cljq0Ppq/6Kgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828656; a=rsa-sha256;
	cv=none;
	b=3dTK8v6DeoD4QpwdKFaLRw3IU0BYOl3IRy2uUMA0j2zQ5wlf85UMHZyaOaOnJEDH21RtJL
	bnraXd+ZEehImpLg+sstibvDTAPMEEF5FwR0/TvvKIPYvcHC7L1V07IBiZ+JTthkhNha7Z
	QaSq6ypsk0aLhYmn+bR8w1XeQu6tbWA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ioF9Qd6I;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778828649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OvZa42yjJAYAdcdRRX0/uxArNhxHjuKTcYRUXMctwJM=;
	b=ioF9Qd6IHOrgMIoGJt1DwvNsewHp6MSqTGxmO9Nd4Q6NWnPTFdjyAH0z5NlsvStc4kUSeX
	sP0BHQqkDrhDp7A/NL6DNwtTu9myS+O0A6Inj6T6z4K3mLQJ6RDJrkdKSLv3aFd0XXPkDM
	zSv8H6XKpLPykJ2+18Q58jAI3S1eANA=
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
Date: Fri, 15 May 2026 15:03:53 +0800
Message-Id: <20260515070353.87244-1-lance.yang@linux.dev>
In-Reply-To: <agXcPleVC9LGVCmj@gmail.com>
References: <agXcPleVC9LGVCmj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 630D14000B
X-Rspam-User: 
X-Stat-Signature: hyztmu1kxi6m1591rih4786nfkt84q13
X-HE-Tag: 1778828654-154526
X-HE-Meta: U2FsdGVkX19hEsETzC1HHIvAG8OOoJiANFF6CAOIYOrUYreWlWnj9HwI8AmLfbVeLZS+a9bXulOMROFGG+VbKqcuJMsRNbkIUwmej6EnkUzp9L2LcbRY41uXNjUw/7HL/Sdz8OgVv6pifaphc7zuiNNtbzRgA87rx+hjBmJFw9H73/41DvSfKp/0rSmEE+Sy13/MlWC/CBaDrLCqkSqJYFUpmgdZzMOdxIy/he66wnNspUqyoLYR8HsXXNKu+5899DgmrNSfTfd+kT47ab63kLJ1WWlzoDAJj9TVeqJvyXHFugP9Hrp8v7pYzNT1soa8UCAuljGUYH0VsUPBiI/3mwi01SG0ozhkEupZmb/n7MoS/Q+52oHwer7jT09sxLwV7kYNNc4yw5+tLD/TcxZYQL6P52vdBq89KR9+PxxAdb0kXu1dDGuZXFtL4Dbr3PZTBLFjpRR8Vq61TLj3UXgCPy86Ybq7HtB2pZSeTuvza0v/7T6KdpQ6qw0NTcTtNFaoigN4Aayf7nBo3quq1aqN/WC68Z7+o2vP/RGgT2L+4tAGUFkOHEpxVMirx3wi341SS6xsePpYsJ9WLia4cBfxFslh0s1TGQ7VI4wBUchqwbwYlZYVdRiVUDE/DWuo6bgXNYfu2+qtD6xkF3sIP6uZtZYV6lwxuAZ6laFZqjaIPIpGLMMYcaKzhGRSVi4iwNs+5/qA8YvL7taa3VyeRL7N23GOv4rTDxbBERgYmfOKlH9sXVKLygNtgvefVTkV21M1voeAO6Ba7tzmJuFMtHimtiLXHIjKzJWpQffsXSGX8S5xO1gsJU0HQ2H6/8iAHM5v+7aoqO52BsXwezuU7N8sL9DtnIPxdabRWSnCJzp2xD16uejl/Kh2pyA3nqPS2+bHMUDSNpPpFWjDpOQkc2a20BKQ/qa+G0aX+dcPGm0w67cEBEinDhn7XFZSIYWgalhCVc5mbpIWu1GX8WoG2yo
 D666VqCn
 AB3wVN7s+I+RSlvv2ScnrTnIA5h0lNBY8Wl52aXGSWJATTPMlRuYOM6s1166xMTa96k/02Q8wos3tYb9UP7cs/uvCwC6E+N/yjGvZ9szFTjAIt1niE5YudCGF9HDNCoT8fNRK4ypP35dE6JCCyi4Qcac0z/sR/wkuldFZ7uTDU4O0yQNYeKKqsZgLNzYRpLKbZK97/Vt8AocAs3Rrb0NvpHwmDQtlTU/1/30CrYuWgrElOdGp1QfHgRF3Jlw1g9V0zqfctNKrytKeRPF/hS2e/CDrF4L9KfZ49YSyIcQjOV0NqIi/qMVRHP3asToVgQ9IJ2LTV+agH7k+nOmWKkkEW9GVpyiNV3j4ky0wmRgSSUt+ft8LeHGl3In01A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, May 14, 2026 at 07:37:14AM -0700, Breno Leitao wrote:
>On Thu, May 14, 2026 at 09:28:30PM +0800, Lance Yang wrote:
>> 
>> On Wed, May 13, 2026 at 08:39:33AM -0700, Breno Leitao wrote:
>> >get_any_page() collapses three different failure modes into a single
>> >-EIO return:
>> >
>> >  * the put_page race in the !count_increased path;
>> >  * the HWPoisonHandlable() rejection that bounces out of
>> >    __get_hwpoison_page() with -EBUSY and exhausts shake_page() retries;
>> >  * the HWPoisonHandlable() rejection that goes through the
>> >    count_increased / put_page / shake_page retry loop.
>> >
>> >The first is transient (the page is racing with the allocator).  The
>> >second can be either transient (a userspace folio briefly off LRU
>> >during migration/compaction) or stable (slab/vmalloc/page-table/
>> >kernel-stack pages).  The third describes a stable kernel-owned page
>> >that the count_increased=true caller already held a reference on.
>> >
>> >Distinguish them on the return path: keep -EIO for both the put_page
>> >race and the -EBUSY-after-retries branch (shake_page() cannot drag a
>> >folio back from active migration, so we cannot prove the page is
>> >permanently kernel-owned from there), keep -EBUSY for the allocation
>> >race (unchanged), and return -ENOTRECOVERABLE only from the
>> >count_increased-true HWPoisonHandlable() rejection that exhausts its
>> >retries -- the caller's reference is structural evidence that the
>> >page is owned by the kernel.
>> >
>> >Extend the unhandlable-page pr_err() to fire for either errno and
>> >update the get_hwpoison_page() kerneldoc.
>> >
>> >memory_failure() still folds every negative return into
>> >MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
>> >this patch is a no-op for users of memory_failure() and only changes
>> >the errno that soft_offline_page() can propagate to its callers.  A
>> >follow-up wires the new return code through memory_failure() and
>> >reports MF_MSG_KERNEL for the unrecoverable cases.
>> >
>> >Suggested-by: David Hildenbrand <david@kernel.org>
>> >Signed-off-by: Breno Leitao <leitao@debian.org>
>> >---
>> > mm/memory-failure.c | 18 +++++++++++++++---
>> > 1 file changed, 15 insertions(+), 3 deletions(-)
>> >
>> >diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> >index 49bcfbd04d213..bae883df3ccb2 100644
>> >--- a/mm/memory-failure.c
>> >+++ b/mm/memory-failure.c
>> >@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
>> > 				shake_page(p);
>> > 				goto try_again;
>> > 			}
>> >+			/*
>> >+			 * Return -EIO rather than -ENOTRECOVERABLE: this
>> >+			 * branch is also reached for pages that are merely
>> >+			 * off-LRU transiently (e.g. a folio in the middle
>> >+			 * of migration or compaction), which shake_page()
>> >+			 * cannot drag back.  The caller cannot prove the
>> >+			 * page is permanently kernel-owned from here, so
>> >+			 * keep it on the recoverable errno.
>> >+			 */
>> > 			ret = -EIO;
>> > 			goto out;
>> > 		}
>> >@@ -1427,10 +1436,10 @@ static int get_any_page(struct page *p, unsigned long flags)
>> > 			goto try_again;
>> > 		}
>> > 		put_page(p);
>> >-		ret = -EIO;
>> >+		ret = -ENOTRECOVERABLE;
>> > 	}
>> > out:
>> >-	if (ret == -EIO)
>> >+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
>> > 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
>> > 
>> > 	return ret;
>> >@@ -1487,7 +1496,10 @@ static int __get_unpoison_page(struct page *page)
>> >  *         -EIO for pages on which we can not handle memory errors,
>> >  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
>> >  *         operations like allocation and free,
>> >- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
>> >+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
>> >+ *         -ENOTRECOVERABLE for stable kernel-owned pages the handler
>> >+ *         cannot recover (PG_reserved, slab, vmalloc, page tables,
>> >+ *         kernel stacks, and similar non-LRU/non-buddy pages).
>> 
>> Did you test this patch series? I don't see how we ever get to
>> -ENOTRECOVERABLE there ...
>
>Yes, I did. I am using the following test case:

Okay.

>https://github.com/leitao/linux/commit/cfebe84ddeab5ac34ed456331db980d57e7025dc
>
>	# RUN_DESTRUCTIVE=1 tools/testing/selftests/mm/hwpoison-panic.sh
>	# enabling /proc/sys/vm/panic_on_unrecoverable_memory_failure
>	# injecting hwpoison at phys 0x2a00000 (Kernel rodata)
>	# expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
>	[  501.113256] Memory failure: 0x2a00: recovery action for reserved kernel page: Ignored
>	[  501.113956] Kernel panic - not syncing: Memory failure: 0x2a00: unrecoverable page
>
>
>> Even with MF_COUNT_INCREASED, the first pass does:
>> 
>> 	if (flags & MF_COUNT_INCREASED)
>> 		count_increased = true;
>> 
>> 	[...]
>> 
>> 	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
>> 		ret = 1;
>> 	} else {
>> 		if (pass++ < GET_PAGE_MAX_RETRY_NUM) { <-
>> 			put_page(p);
>> 			shake_page(p);
>> 			count_increased = false;
>> 			goto try_again; <-
>> 		}
>> 		put_page(p);
>> 		ret = -ENOTRECOVERABLE;
>> 	}
>> 
>> Then we come back with count_increased=false:
>> 
>> try_again:
>> 	if (!count_increased) {
>> 		ret = __get_hwpoison_page(p, flags); <-
>> 		if (!ret) {
>> 		[...]
>> 		} else if (ret == -EBUSY) { <-
>> 		[...]
>> 			ret = -EIO;
>> 			goto out; <-
>> 		}
>> 	}
>> 
>> For slab/vmalloc/page-table pages, __get_hwpoison_page() returns -EBUSY:
>> 
>> 	if (!HWPoisonHandlable(&folio->page, flags))
>> 		return -EBUSY;
>> 
>> so they still seem to end up as -EIO ... Am I missing something?
>
>You are not, and thanks for catching this. I traced it again and the
>-ENOTRECOVERABLE branch is unreachable for slab/vmalloc/page-table pages
>exactly as you described. The __get_hwpoison_page() → -EBUSY → shake → retry
>loop catches them first and they exit as -EIO.

Wonder if it would be simpler to just do a positive check near the top
of get_any_page() instead. Something like:

static bool hwpoison_unrecoverable_kernel_page(struct page *page,
						unsigned long flags)
{
	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
		return false;

	return PageReserved(page) || PageSlab(page) || 
		PageTable(page) || PageLargeKmalloc(page);
}

static int get_any_page(struct page *p, unsigned long flags)
{
	int ret = 0, pass = 0;
	bool count_increased = false;

	if (flags & MF_COUNT_INCREASED)
		count_increased = true;

	if (hwpoison_unrecoverable_kernel_page(p, flags)) {
		if (count_increased)
			put_page(p);
		ret = -ENOTRECOVERABLE;
		goto out;
	}
[...]
}

Then get_any_page() could return -ENOTRECOVERABLE only for page types we
can positively identify as kernel-owned.

These types always fail HWPoisonHandlable(), so retrying does not really
buy us anything for them.

Won't cover everything (vmalloc, kernel stacks, etc. have no page_type
to key off), but that's fine - best effort, right?

Cheers, Lance

>
>The selftest I am using (link above) only validated the PageReserved
>short-circuit added in patch 3, which lives in memory_failure() and never
>reaches get_any_page().
>
>I even thought about this code path, and I was not convinced we should return
>-ENOTRECOVERABLE, thus I documented the following (as in this current patch)
>
>	@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
>			shake_page(p);
>			goto try_again;
>		}
>	+            /*
>	+             * Return -EIO rather than -ENOTRECOVERABLE: this
>	+             * branch is also reached for pages that are merely
>	+             * off-LRU transiently (e.g. a folio in the middle
>	+             * of migration or compaction), which shake_page()
>	+             * cannot drag back.  The caller cannot prove the
>	+             * page is permanently kernel-owned from here, so
>	+             * keep it on the recoverable errno.
>	+             */
>		ret = -EIO;
>

