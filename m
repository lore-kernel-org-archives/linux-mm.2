Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6958CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED5F6B00A0; Thu, 14 May 2026 10:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4596B00C3; Thu, 14 May 2026 10:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302586B00C4; Thu, 14 May 2026 10:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21F466B00A0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:38:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD010C098C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:38:01 +0000 (UTC)
X-FDA: 84766279962.26.3C36C0F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id C707414000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:37:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eWNCk7mE;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778769480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooEeB1JEjvZHDYLPx2r/tMVM+A1Ro3YEzIkX/3MTpcI=;
	b=rXFa65//jzwbUe8cm2CHJ8/Yu76rgMOT5utQAQvI602s2xR5A1uXxnYNz6/6SiWXVgbyWz
	lncLYbmhqhNqU7x4ZafLKPYqJErKB27gPHNb3RdGosTkdfmFtThI3vaJGxClSNs2LFhjOp
	wmLtU/DOFbbQgY76OV5UN1OJkoLGfos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eWNCk7mE;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778769480; a=rsa-sha256;
	cv=none;
	b=6F7qGWKOoETCSG+XZZmFXWbcnUy5zc6EVqp0RvWh45jrBZQPFiBM+EATj271DalSfjg36A
	5Kkv60VLOiogGMN1QxBLGdBWenfxaHurzuxoJ1urgKRM8wNZNJcFxnc5xqx9sw/BOWZmB6
	LneA/EqDB22KOqfv7iQap+M/EwjPJ34=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=ooEeB1JEjvZHDYLPx2r/tMVM+A1Ro3YEzIkX/3MTpcI=; b=eWNCk7mEeueoc/qlWYm2CtsNSp
	e9ixqbIP3UGcVD8XXg+KLsajvk3gwBxUAw0WRae/WqTeh1R7HwofikWBRsMF9ibNKTE43oDhMkK2n
	W93XSKq2J0EyCRaFjdrWi5Aaao3bqV7zpHAo4YNe7sTZSd2YBdbUqWf39Z57l8uJYqR6nCTQ8U7EP
	+AQLwVtjplJ0IzeZWmc7q7DxMG7HqR5Z5UYd5hgCVSBe6DB+kLhS2ppGBOP5HKMogGn4CCO66NMAZ
	PL2z7dOlWxBX373QY4FckVVBzcW6KqZOmUXEpOf1S05p5etYrDKUfcfiCR6AwqYxagXX0vnBc7EgL
	ERp0APyw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNXBi-0040e9-2w;
	Thu, 14 May 2026 14:37:23 +0000
Date: Thu, 14 May 2026 07:37:14 -0700
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
Message-ID: <agXcPleVC9LGVCmj@gmail.com>
References: <20260513-ecc_panic-v7-2-be2e578e61da@debian.org>
 <20260514132830.25622-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514132830.25622-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Stat-Signature: zb6cm1jiqud5x3qdu9g7jcy7hzahrrap
X-Rspamd-Queue-Id: C707414000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778769479-380175
X-HE-Meta: U2FsdGVkX185iyoI4P/yJcfk5xo0eEVaANgil0NsaQUzLtmhwZtmmxdKCl86x/oGkerZ0GiQeJfQh+kM1Ou+oEvz6qUJfLHELn5R2JY3QECM/CualFZjq0mg+3xvSdhlsJzeCXgwQ0GivdiH0uplnUlXHG9dXkk2CXNDs4AZ0duJbNEq2iZ3pErZC1QxIKLCqzr5V5QAVjU9yUIEQ55C6uDGGTlTJ6xaIOErDmzW94H1V0rH3zOZ2caZ4Wfisom5SDRn0fZ8VMYNgLDk9hU2WP5FLKRssGihW2TD4RVy59cnS82iYNBGOyGeqVJ1a37S4EdbXdGzsipJ/modyNEiAHOqWVexdGuftwm4+pskgtor+CgbQNuHenu6Mp31psRj0tNI5eUGdtCYIh4ey00CdjPU78FjCr5F2xSFYKwiPzRwS5Cd/+ihBwHX7nk9keSYAe/0Twmj+qOi1lsqbLXc0o3vHNs3Wr/MTFX5WIqcftQEpw7SEi3RSWNCzitI+e6yFgyIJaIcMDjeHK+86G2kweQNex5NU6Pro0mLj4qEzbI0jt16jL8hPH+xKOM3bhvUFM8cfE2r4b0DaeiI2z0ZYzXv3XyX6Qft6WjwucZmJEtlH5iWe7YL7gYtFnWEw6EkU04qlFbe766sGfne8KJomRNFBnSM1Q5GUDXoHceQiVjs/WxJ8VcXUZuLTZA7sNZCl5vA9Eg0aSkBgTs72083AonojIeCRZpacNXGeS0hnQRKJKRPf14isPn2DIJg55//xb3zeqkm5A1eii76O4AHvxRn6F/ZNvC0H4Wkb0vFGPdDC0bwjDFk8RmHiTuusIH1JwreLCG5WLFIKIoEEO96wPZ/rYLlBWO2HHQi2NMZiTNnAWLccgigCDkF0fvOlhXU/3PKeZbrFJf2zRddU8Q+WDHK34U2R0D9gYDEYd6ClEzJVq/Bl2M18xTnyuJltSRkhZ9vpv0H+MjDepp0XfS
 L6N1/0TY
 y3RzOPoFfw35JZZi5KWUrD3SWV3cVtDsJ/iJrisFiifcGRUr1zo7HavQCea1a9NEecDpgLCMCTTUMZHfLMzNpoSvMW0QSGN03A8CmTOSedswL+AfNGnfzZCgpiUieW9xql/a+LXPKWqsAH0XVtQsgmQrkCsli1LP9PrGWD+JkmswpE+lueBOdIdS9eEJpdMvkCm8AoSRB59uE6L0nZ/ylQbDmN+P4s4b6ORGrh10ylqIQ6lOCcvNybFpxv/hjDwA9WWsv3C2Qz8dtzNCbiYeII2KAz5k/dcUGSkWucluti1o2jl60F7cQgnUpnfM32qE74sfI1zsMGg7L2uey4nXqFwWS8lnVoMLGTJFE1za8efNCfBTUK2ZrWlgIEY+E2dOZxBKz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 09:28:30PM +0800, Lance Yang wrote:
> 
> On Wed, May 13, 2026 at 08:39:33AM -0700, Breno Leitao wrote:
> >get_any_page() collapses three different failure modes into a single
> >-EIO return:
> >
> >  * the put_page race in the !count_increased path;
> >  * the HWPoisonHandlable() rejection that bounces out of
> >    __get_hwpoison_page() with -EBUSY and exhausts shake_page() retries;
> >  * the HWPoisonHandlable() rejection that goes through the
> >    count_increased / put_page / shake_page retry loop.
> >
> >The first is transient (the page is racing with the allocator).  The
> >second can be either transient (a userspace folio briefly off LRU
> >during migration/compaction) or stable (slab/vmalloc/page-table/
> >kernel-stack pages).  The third describes a stable kernel-owned page
> >that the count_increased=true caller already held a reference on.
> >
> >Distinguish them on the return path: keep -EIO for both the put_page
> >race and the -EBUSY-after-retries branch (shake_page() cannot drag a
> >folio back from active migration, so we cannot prove the page is
> >permanently kernel-owned from there), keep -EBUSY for the allocation
> >race (unchanged), and return -ENOTRECOVERABLE only from the
> >count_increased-true HWPoisonHandlable() rejection that exhausts its
> >retries -- the caller's reference is structural evidence that the
> >page is owned by the kernel.
> >
> >Extend the unhandlable-page pr_err() to fire for either errno and
> >update the get_hwpoison_page() kerneldoc.
> >
> >memory_failure() still folds every negative return into
> >MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
> >this patch is a no-op for users of memory_failure() and only changes
> >the errno that soft_offline_page() can propagate to its callers.  A
> >follow-up wires the new return code through memory_failure() and
> >reports MF_MSG_KERNEL for the unrecoverable cases.
> >
> >Suggested-by: David Hildenbrand <david@kernel.org>
> >Signed-off-by: Breno Leitao <leitao@debian.org>
> >---
> > mm/memory-failure.c | 18 +++++++++++++++---
> > 1 file changed, 15 insertions(+), 3 deletions(-)
> >
> >diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >index 49bcfbd04d213..bae883df3ccb2 100644
> >--- a/mm/memory-failure.c
> >+++ b/mm/memory-failure.c
> >@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
> > 				shake_page(p);
> > 				goto try_again;
> > 			}
> >+			/*
> >+			 * Return -EIO rather than -ENOTRECOVERABLE: this
> >+			 * branch is also reached for pages that are merely
> >+			 * off-LRU transiently (e.g. a folio in the middle
> >+			 * of migration or compaction), which shake_page()
> >+			 * cannot drag back.  The caller cannot prove the
> >+			 * page is permanently kernel-owned from here, so
> >+			 * keep it on the recoverable errno.
> >+			 */
> > 			ret = -EIO;
> > 			goto out;
> > 		}
> >@@ -1427,10 +1436,10 @@ static int get_any_page(struct page *p, unsigned long flags)
> > 			goto try_again;
> > 		}
> > 		put_page(p);
> >-		ret = -EIO;
> >+		ret = -ENOTRECOVERABLE;
> > 	}
> > out:
> >-	if (ret == -EIO)
> >+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
> > 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
> > 
> > 	return ret;
> >@@ -1487,7 +1496,10 @@ static int __get_unpoison_page(struct page *page)
> >  *         -EIO for pages on which we can not handle memory errors,
> >  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
> >  *         operations like allocation and free,
> >- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
> >+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
> >+ *         -ENOTRECOVERABLE for stable kernel-owned pages the handler
> >+ *         cannot recover (PG_reserved, slab, vmalloc, page tables,
> >+ *         kernel stacks, and similar non-LRU/non-buddy pages).
> 
> Did you test this patch series? I don't see how we ever get to
> -ENOTRECOVERABLE there ...

Yes, I did. I am using the following test case:

https://github.com/leitao/linux/commit/cfebe84ddeab5ac34ed456331db980d57e7025dc

	# RUN_DESTRUCTIVE=1 tools/testing/selftests/mm/hwpoison-panic.sh
	# enabling /proc/sys/vm/panic_on_unrecoverable_memory_failure
	# injecting hwpoison at phys 0x2a00000 (Kernel rodata)
	# expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
	[  501.113256] Memory failure: 0x2a00: recovery action for reserved kernel page: Ignored
	[  501.113956] Kernel panic - not syncing: Memory failure: 0x2a00: unrecoverable page


> Even with MF_COUNT_INCREASED, the first pass does:
> 
> 	if (flags & MF_COUNT_INCREASED)
> 		count_increased = true;
> 
> 	[...]
> 
> 	if (PageHuge(p) || HWPoisonHandlable(p, flags)) {
> 		ret = 1;
> 	} else {
> 		if (pass++ < GET_PAGE_MAX_RETRY_NUM) { <-
> 			put_page(p);
> 			shake_page(p);
> 			count_increased = false;
> 			goto try_again; <-
> 		}
> 		put_page(p);
> 		ret = -ENOTRECOVERABLE;
> 	}
> 
> Then we come back with count_increased=false:
> 
> try_again:
> 	if (!count_increased) {
> 		ret = __get_hwpoison_page(p, flags); <-
> 		if (!ret) {
> 		[...]
> 		} else if (ret == -EBUSY) { <-
> 		[...]
> 			ret = -EIO;
> 			goto out; <-
> 		}
> 	}
> 
> For slab/vmalloc/page-table pages, __get_hwpoison_page() returns -EBUSY:
> 
> 	if (!HWPoisonHandlable(&folio->page, flags))
> 		return -EBUSY;
> 
> so they still seem to end up as -EIO ... Am I missing something?

You are not, and thanks for catching this. I traced it again and the
-ENOTRECOVERABLE branch is unreachable for slab/vmalloc/page-table pages
exactly as you described. The __get_hwpoison_page() → -EBUSY → shake → retry
loop catches them first and they exit as -EIO.

The selftest I am using (link above) only validated the PageReserved
short-circuit added in patch 3, which lives in memory_failure() and never
reaches get_any_page().

I even thought about this code path, and I was not convinced we should return
-ENOTRECOVERABLE, thus I documented the following (as in this current patch)

	@@ -1408,6 +1408,15 @@ static int get_any_page(struct page *p, unsigned long flags)
			shake_page(p);
			goto try_again;
		}
	+            /*
	+             * Return -EIO rather than -ENOTRECOVERABLE: this
	+             * branch is also reached for pages that are merely
	+             * off-LRU transiently (e.g. a folio in the middle
	+             * of migration or compaction), which shake_page()
	+             * cannot drag back.  The caller cannot prove the
	+             * page is permanently kernel-owned from here, so
	+             * keep it on the recoverable errno.
	+             */
		ret = -EIO;

