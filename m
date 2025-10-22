Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DC5CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 21:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C2D8E0003; Wed, 22 Oct 2025 17:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73FC8E0002; Wed, 22 Oct 2025 17:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D18E0003; Wed, 22 Oct 2025 17:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949368E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:36:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 345AF14092D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:36:09 +0000 (UTC)
X-FDA: 84027058458.27.FF56048
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 425D1160010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:36:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YD/zEhKO";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761168967; a=rsa-sha256;
	cv=none;
	b=6dNhFHGhentEN2Wo0uBnbXJVZtp1lfXcjnLD5KbmMWGhQDnSdIgvm/TKzGAgaZdBdzKKGw
	j8iO38AwA8fTRrZBTW2JWogEFdXmFtILVJnQwMeDIfvpW18NbaWIbEfHtyN1hD1OPIWM0/
	5JrG0tgcufME1s5zH5dStL8ou7Aig6g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YD/zEhKO";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761168967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QS/wDVWg/99dm/YWlTuIw+3X1HjWCfQCG/YUCbH1ck0=;
	b=i/6IQU9vXazE7IyFKacXoBXferBNtY0c8CTn85ff8Al4FibMBPvQ1KJqqnseXjYzAJTYpf
	MGuuXg1u4S5f956zNQn/U6Wow/Btqdkm7KVJZ6UFVI9G5D0Paby/4wFg5RnL6aH1I2yYnA
	5MtP0kO1Xx2k9Exm4KiO5ns5bLU6DPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 010D2402AB;
	Wed, 22 Oct 2025 21:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81401C4CEE7;
	Wed, 22 Oct 2025 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761168965;
	bh=xzJFHS05vq/gzblbNJCK/TcArYaZ4JncDoxITCAkLaY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YD/zEhKOHgEYpglKaPhtMClD31p30giEdTFT17IwmiXfer+aiI+vhBszRJP0giJZJ
	 eG2wyFYkb0Ca9YMP19vLrq8LvCIie8zJLDpkh81fViVa+wJVVggvnJmvqxkvU2mAoL
	 KpvHzFeQSLVqxbnRE+K1StBZGaU930yoNKcxhxQ4=
Date: Wed, 22 Oct 2025 14:36:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>, Alexander Potapenko
 <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov
 <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>, Alexei
 Starovoitov <ast@kernel.org>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots
 are allocated yet
Message-Id: <20251022143604.1ac1fcb18bfaf730097081ab@linux-foundation.org>
In-Reply-To: <20251022030213.GA35717@sol>
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
	<20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
	<335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com>
	<20251022030213.GA35717@sol>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z1qe4pckwwngwayo65ir3oo69b6scq4c
X-Rspamd-Queue-Id: 425D1160010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761168967-590745
X-HE-Meta: U2FsdGVkX1+t5jqDSpMeqc3XQe8sp3lXsHhSxDMt0vl3rC9FnQEuxaCyx4JlmGQK3eFPTzeGrzcPFhW4c1WVUBzdEmmWMUPn2B8Yu2j+vAuQfytddU7j0dN7tbFw4b86amJdWPC2+abZsZEUe+0Khz9ovJnC7N+fP5ZN4gjJcgPm4mA1EbTqH0UoNvIa9Cnnz7sIwhsPxLt8kcVmUjAr8qEDQPLqT2tdbXyCc6g9ihYqOUcgYEYgN2Emyh9DtVYyzWujSN2CmgBzEehonFOZynChs0a166m/apXsIhfnVmsMnunH77WsBLd0W7fcRgaSl21SP7HnMYGPHa66iljjZG2wUY0GYoqDzPE+Tx5X8ZVhmWJJWR8SwpB+6r4mO+FcMOBb4ZzDWWENVwtY8M3LgWHqW7pnkzdq6QhaZeKm36P/Y+JKIjGXLH4epcxB9t8w3FNXL1/6NNaV6H8UP0Cw7B8fdkPsVNZRXLIUkfuoB/g7QJO10od3VObDA0376jhE/eghWAy1CHFUpfSeJum1EcE49/FdLRdCxfRDdeCSQy/+YmJWgNFu/8MmJIkvPPonjMg56CdyF7InSU51wk1ucHUfzE+/SW6yUXGThvGSL8fr7kxlKFIaswkJQYGl0S5fIWXul1Cj+36zehlxZirj2CfnORwEk9sjBdI90TIBWFD2knDvMMMWmU9CrdSdrZoVPpMga5i3nLVifQuQ0gKWTduKHZYj73kOkUKL+xS6SCGrZFT6ngXfNJGmzU46ctumo1dfBHR8IpD7q9AMRrA7sKiSZB/RbZKR7QMEtLi/b5/oFyY36S/baGZozXdiBY293v96jwBH3z9tF+MWPa7WIUiB/S4zHUVIskjxVpFlMotLO5j74jeyz6OmKTMPSQF9zvbPFcmevsg85JN6ij7uxPVayI+RZxd9xIPlykYFU0kEm2jYQkw7EGY9rHuJ2dYZfZq3BQ2/sT+XJt2IpHO
 7P/8R3JZ
 q9XNzCN4A/hgVh+lSz4O/AlsbhdKxj25Lkv4FX70R3xDwc+i4gKWEfMYbnW+Ca08F2N1QFfQEwBhQHr6wNU0MfmPxEd+B3BMNA69XLUzU6tcjCGtc+P5QkYhipY8z/uhUFBKZH+178VrqFYNGwPHrPVTGburz9Zz8degvpwgMNv6reohN359jiEw0by7E5WkXzVm7vQ1pQUFgjTnwwVh/lVcJbzA62x2m8uq4SMNyS63ogxoIqpbv81xjbWJdH9dCM4+uiQTBBpOyQGCUjsHiSnGLzyC6/kX07sTfUb3pUtH69SAh01eLfidaLt21x6a5qPpE68tp6QNm7qCJf/d/jE3QYojQ9QJM6rXrnuMNbmW6jvIFuc5HF6GMJEDiOmQoh3fM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 20:02:13 -0700 Eric Biggers <ebiggers@kernel.org> wrote:

> On Fri, Oct 10, 2025 at 10:07:04AM +0200, Aleksei Nikiforov wrote:
> > On 10/9/25 05:31, Andrew Morton wrote:
> > > On Tue, 30 Sep 2025 13:56:01 +0200 Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com> wrote:
> > > 
> > > > If no stack depot is allocated yet,
> > > > due to masking out __GFP_RECLAIM flags
> > > > kmsan called from kmalloc cannot allocate stack depot.
> > > > kmsan fails to record origin and report issues.
> > > > 
> > > > Reusing flags from kmalloc without modifying them should be safe for kmsan.
> > > > For example, such chain of calls is possible:
> > > > test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> > > > slab_alloc_node -> slab_post_alloc_hook ->
> > > > kmsan_slab_alloc -> kmsan_internal_poison_memory.
> > > > 
> > > > Only when it is called in a context without flags present
> > > > should __GFP_RECLAIM flags be masked.
> > > > 
> > > > With this change all kmsan tests start working reliably.
> > > 
> > > I'm not seeing reports of "hey, kmsan is broken", so I assume this
> > > failure only occurs under special circumstances?
> > 
> > Hi,
> > 
> > kmsan might report less issues than it detects due to not allocating stack
> > depots and not reporting issues without stack depots. Lack of reports may go
> > unnoticed, that's why you don't get reports of kmsan being broken.
> 
> Yes, KMSAN seems to be at least partially broken currently.  Besides the
> fact that the kmsan KUnit test is currently failing (which I reported at
> https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed
> that the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
> applied but does not cause a warning without it.  The warning did get
> reached via syzbot somehow
> (https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/),
> so KMSAN must still work in some cases.  But it didn't work for me.

OK, thanks, I pasted the above para into the changelog to help people
understand the impact of this.

> (That particular warning in the architecture-optimized Poly1305 code is
> actually a false positive due to memory being initialized by assembly
> code.  But that's besides the point.  The point is that I should have
> seen the warning earlier, but I didn't.  And Aleksei's patch seems to
> fix KMSAN to work reliably.  It also fixes the kmsan KUnit test.)
> 
> I don't really know this code, but I can at least give:
> 
> Tested-by: Eric Biggers <ebiggers@kernel.org>
> 
> If you want to add a Fixes commit I think it is either 97769a53f117e2 or
> 8c57b687e8331.  Earlier I had confirmed that reverting those commits
> fixed the kmsan test too
> (https://lore.kernel.org/r/20250911192953.GG1376@sol).

Both commits affect the same kernel version so either should be good
for a Fixes target.

I'll add a cc:stable to this and shall stage it for 6.18-rcX.

The current state is below - if people want to suggest alterations,
please go for it.



From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: mm/kmsan: fix kmsan kmalloc hook when no stack depots are allocated yet
Date: Tue, 30 Sep 2025 13:56:01 +0200

If no stack depot is allocated yet, due to masking out __GFP_RECLAIM
flags kmsan called from kmalloc cannot allocate stack depot.  kmsan
fails to record origin and report issues.  This may result in KMSAN
failing to report issues.

Reusing flags from kmalloc without modifying them should be safe for kmsan.
For example, such chain of calls is possible:
test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
slab_alloc_node -> slab_post_alloc_hook ->
kmsan_slab_alloc -> kmsan_internal_poison_memory.

Only when it is called in a context without flags present should
__GFP_RECLAIM flags be masked.

With this change all kmsan tests start working reliably.

Eric reported:

: Yes, KMSAN seems to be at least partially broken currently.  Besides the
:_fact that the kmsan KUnit test is currently failing (which I reported at
:_https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed that
:_the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
:_applied but does not cause a warning without it.  The warning did get
:_reached via syzbot somehow
:_(https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/),
:_so KMSAN must still work in some cases.  But it didn't work for me.

Link: https://lkml.kernel.org/r/20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com
Link: https://lkml.kernel.org/r/20251022030213.GA35717@sol
Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunistic page allocation")
Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    3 ---
 mm/kmsan/hooks.c  |    6 ++++--
 mm/kmsan/shadow.c |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/kmsan/core.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/core.c
@@ -72,9 +72,6 @@ depot_stack_handle_t kmsan_save_stack_wi
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep. */
-	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
-
 	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
--- a/mm/kmsan/hooks.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/hooks.c
@@ -84,7 +84,8 @@ void kmsan_slab_free(struct kmem_cache *
 	if (s->ctor)
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(object, s->object_size, GFP_KERNEL,
+	kmsan_internal_poison_memory(object, s->object_size,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
@@ -114,7 +115,8 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page),
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
--- a/mm/kmsan/shadow.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depots-are-allocated-yet
+++ a/mm/kmsan/shadow.c
@@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page), page_size(page),
-				     GFP_KERNEL,
+				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
_


