Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDFBCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDA56B0093; Fri, 15 May 2026 09:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466E66B0096; Fri, 15 May 2026 09:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F506B0098; Fri, 15 May 2026 09:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5B26B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:14:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9F541C07B4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:14:45 +0000 (UTC)
X-FDA: 84769698930.26.856FE69
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD20614000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:14:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YO6HHuhT;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778850884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pmx2rneBBjmIsZbvqyQI5Qj38w0M3wSqScjqM675SPE=;
	b=wLh6uv+Dy/+YSzKsvWM/bz9q0Tsk7ql6eACR+qnBX8Ik2MVVlhnHCjcFuj82ZhXt7NwInD
	nHV2ggq664SnjtW7LLkUfycLnXgiz00aYgND94MVgJ8mpr66pROdf3itB9HQeQ0gVJFpcP
	3eSFIURGEW8DqHP1voGaY30AzYfdZsE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YO6HHuhT;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778850884; a=rsa-sha256;
	cv=none;
	b=YaLyIzCCywnVOQcWP2rwq3PnRrXZL2b4lIk5FymS2gQpNrfNBHotYkFJKdMP2I+ydUkJja
	+jt3OO/b+nQ8EZeAAnHXKeC9rtTvkzr92HneWfoYZgO3b7lvEjLzOkYbjN8u6qxgNRZQqi
	VjN+LCY8HbAMCiUkOYWjh6r8MPdGVag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=Pmx2rneBBjmIsZbvqyQI5Qj38w0M3wSqScjqM675SPE=; b=YO6HHuhTFg9PhNc1fOrsmCg0l2
	coFCfL/HXWdkEJQ/NNKVRj19rXWjjJl5HBw6M88KuaCjeYzYEPxkD/PkxEoOUOEpDSXao2gSZ5fNV
	y2r2DTZTvmnVMIM7EDLOTJKm80si4Z51/LIYtXbCGrLWy68gBkSfDd3begZfr1Tl9UpTgOTCJY8k3
	larcZFhBbwn6Ob9lxog2bbdoGpydWJoRKteQBRuuG59KTjRkgsoB1omyQ2EO0LFmGAFwi8y4O91SP
	UuCvmx/NcPNmSfXVwpJq08KpkIpKycDMtaozxfkO3MZka5q8HtenV+xPq1+8eNV+rO49xWD9L4NcB
	YfFZfRSg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNsMf-004kzr-03;
	Fri, 15 May 2026 13:14:05 +0000
Date: Fri, 15 May 2026 06:13:58 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, nao.horiguchi@gmail.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, liam@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v7 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <agcbfLHT5ZWnNeN0@gmail.com>
References: <agXcPleVC9LGVCmj@gmail.com>
 <20260515070353.87244-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515070353.87244-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: CD20614000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 43xig1jjxebcn4jpn6o7rjgxfydwb6q1
X-HE-Tag: 1778850883-713026
X-HE-Meta: U2FsdGVkX1+o3+DWoOX1S9GMDZnrOp4iLvqkNxwe6FMRuOy58qTPsV4H8sIAN1eiWCbv62EE5otwuIGLae8+eBLVxH4VQtJWVL3+zNmpbsMCt8rD7EuGrGBEV3nKWzl0Sd0B4DllI2XK3AxVgg3pUTiC1AgNlYpQ5E/8CobO17wptZ2VLmrxO2qKnE4hZYkskeRZqthQ2z/8purRde9N0yd3dULvhwWq9p/9ftMga21RbTg1pg+jalKK7rzvWUo7rQc8cAqJi23YJO5B4G1Y9wwZ0BtUqu0qpM8TdhERamE/Mi+wUO8gyIIwQrJ6Swxkysx1hIFSPaH6Z4M1/VQlPlhALWRTOhZik0VZy0/tSMo9ZmKXgwj+HJ8U9nMRgWphDx1KEziqHdx9rTNgVW9aeE1iv6ou5NIGk1bTI1ovMoXlcI+ertqiKHZdWpldtAmgf+/VJwg1B8gJmXT0rVQWuzW4cdC6xrsxzbCJ94UqaEJwshy/n0IHLIoHCO30UVcTelku9/Aa3gP9K5C4ArrTCUn/cF5kfLUV70ekqxLkuMdWqxxqUsXIVfAIin67Vg5koav9ItjMf3+W631VNUeoRVyCDsrLmM54FQU5h1d7fkx1oYL2xfpk1VjAZ9zkmhTN1GVP+RNs2vxj1/q6MZpeDv1FsazYlEV4AYx6GQ+LVg6nh9iOB1rbQ8lt/1kd3bBBV7ADp4KiS2zQHt9nQl8VHxDZT49d7nm7Mg/lC8v4BKBLDTGI1a/ZtuJkwBF9CCljU2sbRgKAdFNSXJyOCziFM84mGi+GFrFM4A/4fyd+1PH2UO8qrjTD4GM0sNQkUm4ey8itqNLPcx4rZ+4+ZNzrdh3JmnvRhi7ItEGcLeCl8oO597yRzes8SyruJ6jExgw9l1V7RnMESuZcLdSoDd/UXT6/1Sin8uNklP+m2/qeIdh2E33MDgvb/VUdBYhFuk2TrgxisV6vxmos6qfXEPK
 UQIH9+6l
 Esl2pD9wVmMRXRwL979ztG24oP7U1S2NFgyuNkPMBmu/lPfewv5IlHbTmZ87zzH/3X7D6Yb1z1SLRdUIEXYOGmeRQFuIZgLC2gJk8exBDqGb4JCxftuoytxLDs8oSw1Eg3qX86ht9N/Ad+ar+RIOifmJrSQE2AqrQv+I9CLEXWLPfZFOgNgrOw7uHoxaBbkPEg63TaD8os6uyMjQVRKTGci0dr7UDwK1sos5jWf57+EfZMcD8z9JHHPDiSAmzkEvBz76Z9k51fcyrOKgJ11pJhTWSgE+xb9p3fyPnGJ/HIzMZ0UidTF+Es9phVTOAYG1Vj23SQmqAAmQOCoQT/QTEdOHw14cnERxvTQKoSwKSBgkmvHBCdSCgrZcMtwyhuYnP0GrC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 03:03:53PM +0800, Lance Yang wrote:
> 
> On Thu, May 14, 2026 at 07:37:14AM -0700, Breno Leitao wrote:
> >On Thu, May 14, 2026 at 09:28:30PM +0800, Lance Yang wrote:
> >> 
> >> On Wed, May 13, 2026 at 08:39:33AM -0700, Breno Leitao wrote:
> >> >get_any_page() collapses three different failure modes into a single
> >> >-EIO return:
> >> >
> >> >  * the put_page race in the !count_increased path;
> >> >  * the HWPoisonHandlable() rejection that bounces out of
> >> >    __get_hwpoison_page() with -EBUSY and exhausts shake_page() retries;
> >> >  * the HWPoisonHandlable() rejection that goes through the
> >> >    count_increased / put_page / shake_page retry loop.
> >> >
> >> >The first is transient (the page is racing with the allocator).  The
> >> >second can be either transient (a userspace folio briefly off LRU
> >> >during migration/compaction) or stable (slab/vmalloc/page-table/
> >> >kernel-stack pages).  The third describes a stable kernel-owned page
> >> >that the count_increased=true caller already held a reference on.
> >> >
> >> >Distinguish them on the return path: keep -EIO for both the put_page
> >> >race and the -EBUSY-after-retries branch (shake_page() cannot drag a
> >> >folio back from active migration, so we cannot prove the page is
> >> >permanently kernel-owned from there), keep -EBUSY for the allocation
> >> >race (unchanged), and return -ENOTRECOVERABLE only from the
> >> >count_increased-true HWPoisonHandlable() rejection that exhausts its
> >> >retries -- the caller's reference is structural evidence that the
> >> >page is owned by the kernel.
> >> >
> >> >Extend the unhandlable-page pr_err() to fire for either errno and
> >> >update the get_hwpoison_page() kerneldoc.
> >> >
> >> >memory_failure() still folds every negative return into
> >> >MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
> >> >this patch is a no-op for users of memory_failure() and only changes
> >> >the errno that soft_offline_page() can propagate to its callers.  A
> >> >follow-up wires the new return code through memory_failure() and
> >> >reports MF_MSG_KERNEL for the unrecoverable cases.
> >> >
> >> >Suggested-by: David Hildenbrand <david@kernel.org>
> >> >Signed-off-by: Breno Leitao <leitao@debian.org>
> >> >---
> >> > mm/memory-failure.c | 18 +++++++++++++++---
> >> > 1 file changed, 15 insertions(+), 3 deletions(-)
> >> >
> >> >diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >> >index 49bcfbd04d213..bae883df3ccb2 100644
> >> >--- a/mm/memory-failure.c
> >> >+++ b/mm/memory-failure.c
> >> >@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
> >> > 				shake_page(p);
> >> > 				goto try_again;
> >> > 			}
> >> >+			/*
> >> >+			 * Return -EIO rather than -ENOTRECOVERABLE: this
> >> >+			 * branch is also reached for pages that are merely
> >> >+			 * off-LRU transiently (e.g. a folio in the middle
> >> >+			 * of migration or compaction), which shake_page()
> >> >+			 * cannot drag back.  The caller cannot prove the
> >> >+			 * page is permanently kernel-owned from here, so
> >> >+			 * keep it on the recoverable errno.
> >> >+			 */
> >> > 			ret = -EIO;
> >> > 			goto out;
> >> > 		}
> >> >@@ -1427,10 +1436,10 @@ static int get_any_page(struct page *p, unsigned long flags)
> >> > 			goto try_again;
> >> > 		}
> >> > 		put_page(p);
> >> >-		ret = -EIO;
> >> >+		ret = -ENOTRECOVERABLE;
> >> > 	}
> >> > out:
> >> >-	if (ret == -EIO)
> >> >+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
> >> > 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
> >> > 
> >> > 	return ret;
> >> >@@ -1487,7 +1496,10 @@ static int __get_unpoison_page(struct page *page)
> >> >  *         -EIO for pages on which we can not handle memory errors,
> >> >  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
> >> >  *         operations like allocation and free,
> >> >- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
> >> >+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
> >> >+ *         -ENOTRECOVERABLE for stable kernel-owned pages the handler
> >> >+ *         cannot recover (PG_reserved, slab, vmalloc, page tables,
> >> >+ *         kernel stacks, and similar non-LRU/non-buddy pages).
> >> 
> >> Did you test this patch series? I don't see how we ever get to
> >> -ENOTRECOVERABLE there ...
> >
> >Yes, I did. I am using the following test case:
> 
> Okay.
> 
> >https://github.com/leitao/linux/commit/cfebe84ddeab5ac34ed456331db980d57e7025dc
> >
> >	# RUN_DESTRUCTIVE=1 tools/testing/selftests/mm/hwpoison-panic.sh
> >	# enabling /proc/sys/vm/panic_on_unrecoverable_memory_failure
> >	# injecting hwpoison at phys 0x2a00000 (Kernel rodata)
> >	# expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> >	[  501.113256] Memory failure: 0x2a00: recovery action for reserved kernel page: Ignored
> >	[  501.113956] Kernel panic - not syncing: Memory failure: 0x2a00: unrecoverable page
> >
> >
> >> Even with MF_COUNT_INCREASED, the first pass does:
> >> 
> >> 	if (flags & MF_COUNT_INCREASED)
> >> 		count_increased = true;
> >> 
> >> 	[...]
> >> 
> >> 	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
> >> 		ret = 1;
> >> 	} else {
> >> 		if (pass++ < GET_PAGE_MAX_RETRY_NUM) { <-
> >> 			put_page(p);
> >> 			shake_page(p);
> >> 			count_increased = false;
> >> 			goto try_again; <-
> >> 		}
> >> 		put_page(p);
> >> 		ret = -ENOTRECOVERABLE;
> >> 	}
> >> 
> >> Then we come back with count_increased=false:
> >> 
> >> try_again:
> >> 	if (!count_increased) {
> >> 		ret = __get_hwpoison_page(p, flags); <-
> >> 		if (!ret) {
> >> 		[...]
> >> 		} else if (ret == -EBUSY) { <-
> >> 		[...]
> >> 			ret = -EIO;
> >> 			goto out; <-
> >> 		}
> >> 	}
> >> 
> >> For slab/vmalloc/page-table pages, __get_hwpoison_page() returns -EBUSY:
> >> 
> >> 	if (!HWPoisonHandlable(&folio->page, flags))
> >> 		return -EBUSY;
> >> 
> >> so they still seem to end up as -EIO ... Am I missing something?
> >
> >You are not, and thanks for catching this. I traced it again and the
> >-ENOTRECOVERABLE branch is unreachable for slab/vmalloc/page-table pages
> >exactly as you described. The __get_hwpoison_page() → -EBUSY → shake → retry
> >loop catches them first and they exit as -EIO.
> 
> Wonder if it would be simpler to just do a positive check near the top
> of get_any_page() instead. Something like:
> 
> static bool hwpoison_unrecoverable_kernel_page(struct page *page,
> 						unsigned long flags)

Ack. We probably want to call it something like HWPoisonKernelOwned() to
follow the same naming sematics of these helpers, such as HWPoisonHandlable()

By the way, I will re-include the self test back to this patch series,
In case they are not useful, we do not merge it.

Thanks for the review,
--breno

