Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5033FD0040
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7D36B0005; Sat, 28 Feb 2026 17:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55AB6B0089; Sat, 28 Feb 2026 17:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9548E6B008A; Sat, 28 Feb 2026 17:19:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851D16B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:19:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A049160299
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:19:46 +0000 (UTC)
X-FDA: 84495283572.25.54B411C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B61840004
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:19:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rIqz5ShT;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772317184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BA/FIEvEU0sAc36S/99JxbcKLn/0/PFvWeRcl/wkqXY=;
	b=D9aIeHgsZ+vw7o+nhm3ibEjWkyk3MicWog9cOMX2xmSzTvMcdEQ90thCwH8J78yiI9NBba
	79D/HDfwEzMIrayS0fOZ+Ticm6OUw/Y/V2YvLphdQzfEEsXEUauNANAI1pyNil5zvfNfzi
	LIuIYOga/5KUvSqfTuAY42P5Z5z2LXs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rIqz5ShT;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772317184; a=rsa-sha256;
	cv=none;
	b=Dke6vUfU3iJLVtTa5mM052fyKPl7nQNQdgv3GBNuQP24pCL7xyRZjGI+uT2vVxi2Z7XQc2
	dk0VfNSarkH1H2hc60/VT1e5oc4O+FPMNrvQfeEfU+xNN9Cn0Z+UadR4HdfCyS519R/B1p
	rl5lzn3nHTYfqAxkHfhkq5KrV4m+ZQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 046F142B75;
	Sat, 28 Feb 2026 22:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EE5C116D0;
	Sat, 28 Feb 2026 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772317182;
	bh=zX1byOKjSF4JhKlVfHUkqD05bQhCNjXH2UlADrhDMH0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rIqz5ShTq20WVpTXI83q3TCVnqthrm4kSdibv2q/2Uhaby3mt+Tbhm58MEhqZkJK5
	 FIa6KALIcbB0nIGEUBQs0IZ2oWQZgkTcwliHha8XYq0Ihvh4z+KIV9eZ5zBjEBSE5I
	 MZM8tW9Yoir1mdevrFSmfNGuA3AGTzI53DGYUlIE=
Date: Sat, 28 Feb 2026 14:19:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
 <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, Matthew Wilcox
 <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song
 <muchun.song@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>,
 Dave Chinner <david@fromorbit.com>, Linus Torvalds
 <torvalds@linuxfoundation.org>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
Message-Id: <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
In-Reply-To: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B61840004
X-Rspamd-Server: rspam08
X-Stat-Signature: u7nimccehyjbrbb7zuhpz91ec1sy3htt
X-HE-Tag: 1772317184-594005
X-HE-Meta: U2FsdGVkX19/1lNqw2CwpED9KulzDXdKPxZEG/rO7zYLDnFQsYp+UdD3tXDJNRbxpYjo9T1loyO9ceyOHAIFWAl/yA2+rP/9Ku80JvN3xWLGpB6rK3L6XE/VHvHYkvBi0hjBA2SD8mcvYrjcPR8FbR5vRfhBCybp/Bgex/e8I4nlkQHqRU630JNwMavjrKv1n9YwuFYQGoGT+PAu1pIhiEdKpDj7Otd+pclg106MycAljaQSgq5bDYy5atrA+J65kkMsngu7Bols2y967e8X/I4Wq9oQqg3q8azni/9F5xaL6VZQ+qcIFp3+yLWz00W0dOZOcNUenGfaeUmhWN5ebGbiCi19FpLd+qVapkG+DX5A/0y7QZNVCbcYQCfq1gDJ7Nxjjj8naNeVbzgXK1xTDMFa3WDVp1VCB1NHM43Jt+Ax+MtRHi754DOaG/z6xg4YZTuJuUr9L0jYBPdL26NEsddJQg1AVGFVG6b/tJYmQQht0d47RNcQyR4/VQ6xlFR90tnaqqJn755sjCtquGonkcECMh9KjPvuhVrqUltnG/08pwbvuu0NNX78mMhmpDVI2dG1zbsqZTlnvQHnfWBtIj1+uxiqnM2x7Wlc0e1DIG0iJh+zSvw86X2AEo7T5pgkQxkFMKY/lZlF03tW6qTm1AUxo2mtiVnvsrDumg1DSfS+wdjXDZWt6zZbTHceiXz8DTBVA+m/8WC467VIidcN5+JuQQg8FRWYPuZdiX886HEA9ArubpnpBG2UcitdKs5OzqzwENZBLtUKVlti8JNoCUNvsN5QzUxmy4WuLNPqAebt8GIpMQWN7iMTazgoYryz4hvcG9/mROCISS+4Dn+BZmj8VQIz3KGb58ZXsxuqq8P17RRqXCneDf9EZzbEaiewrXaGDhEcSCLbmoyjw3jeIY+sdXWViavlXpU2R2CQidw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 16:27:22 +0000 Gladyshev Ilya <gladyshev.ilya1@h-partners.com> wrote:

> This patch was previously posted as an RFC and received positive, but
> little, feedback. So I decided to fix remaining drawbacks and repost it
> as non-RFC patch. Overall logic, as well as performance, remained the
> same.
> 
> Intro
> =====
> This patch optimizes small file read performance and overall folio refcount
> scalability by refactoring page_ref_add_unless [core of folio_try_get].
> This is alternative approach to previous attempts to fix small read
> performance by avoiding refcount bumps [1][2].
> 
> Overview
> ========
> Current refcount implementation is using zero counter as locked (dead/frozen)
> state, which required CAS loop for increments to avoid temporary unlocks in
> try_get functions. These CAS loops became a serialization point for otherwise
> scalable and fast read side.
> 
> Proposed implementation separates "locked" logic from the counting, allowing
> the use of optimistic fetch_add() instead of CAS. For more details, please
> refer to the commit message of the patch itself.
> 
> Proposed logic maintains the same public API as before, including all existing
> memory barrier guarantees.
> 
> Performance
> ===========
> Performance was measured using a simple custom benchmark based on
> will-it-scale[3]. This benchmark spawns N pinned threads/processes that
> execute the following loop:
> ``
> char buf[]
> fd = open(/* same file in tmpfs */);
> 
> while (true) {
>     pread(fd, buf, /* read size = */ 64, /* offset = */0)
> }
> ``
> While this is a synthetic load, it does highlight existing issue and
> doesn't differ a lot from benchmarking in [2] patch.

Well it's nice to see the performance benefits from Kiryl's ill-fated
patch
(https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/)

And this approach looks far simpler.

I'll paste the single patch below for others - I think it's not
desirable to prepare a [0/N] for a single-patch "series"!

Thanks, I'll await reviewer feedback for a couple of days then I'll
look at adding this to linux-next for some runtime testing.

> This benchmark measures operations per second in the inner loop and the
> results across all workers. Performance was tested on top of v6.15 kernel[4]
> on two platforms. Since threads and processes showed similar performance on
> both systems, only the thread results are provided below. The performance
> improvement scales linearly between the CPU counts shown.
> 
> Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]
> 
> #threads | vanilla | patched | boost (%)
>        1 | 1343381 | 1344401 |  +0.1
>        2 | 2186160 | 2455837 | +12.3
>        5 | 5277092 | 6108030 | +15.7
>       10 | 5858123 | 7506328 | +28.1
>       12 | 6484445 | 8137706 | +25.5
>          /* Cross socket NUMA */
>       14 | 3145860 | 4247391 | +35.0
>       16 | 2350840 | 4262707 | +81.3
>       18 | 2378825 | 4121415 | +73.2
>       20 | 2438475 | 4683548 | +92.1
>       24 | 2325998 | 4529737 | +94.7
> 
> Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]
> 
> #threads | vanilla | patched | boost (%)
>        1 | 1077276 | 1081653 |  +0.4
>        5 | 4286838 | 4682513 |  +9.2
>       10 | 1698095 | 1902753 | +12.1
>       20 | 1662266 | 1921603 | +15.6
>       49 | 1486745 | 1828926 | +23.0
>       97 | 1617365 | 2052635 | +26.9
>          /* Cross socket NUMA */
>      105 | 1368319 | 1798862 | +31.5
>      136 | 1008071 | 1393055 | +38.2
>      168 |  879332 | 1245210 | +41.6
>                /* SMT */
>      193 |  905432 | 1294833 | +43.0
>      289 |  851988 | 1313110 | +54.1
>      353 |  771288 | 1347165 | +74.7
> 
> [1] https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
> [3] https://github.com/antonblanchard/will-it-scale
> [4] There were no changes to page_ref.h between v6.15 and v6.18 or any
>     significant performance changes on the read side in mm/filemap.c
> 


> The current atomic-based page refcount implementation treats zero
> counter as dead and requires a compare-and-swap loop in folio_try_get()
> to prevent incrementing a dead refcount. This CAS loop acts as a
> serialization point and can become a significant bottleneck during
> high-frequency file read operations.
> 
> This patch introduces FOLIO_LOCKED_BIT to distinguish between a
> (temporary) zero refcount and a locked (dead/frozen) state. Because now
> incrementing counter doesn't affect it's locked/unlocked state, it is
> possible to use an optimistic atomic_add_return() in
> page_ref_add_unless_zero() that operates independently of the locked bit.
> The locked state is handled after the increment attempt, eliminating the
> need for the CAS loop.
> 
> If locked state is detected after atomic_add(), pageref counter will be
> reset using CAS loop, eliminating theoretical possibility of overflow.
> 
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> ---
>  include/linux/page-flags.h |  5 ++++-
>  include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
>  2 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7c2195baf4c1..f2a9302104eb 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -196,6 +196,9 @@ enum pageflags {
>  
>  #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
>  
> +/* Most significant bit in page refcount */
> +#define PAGEREF_LOCKED_BIT	(1 << 31)
> +
>  #ifndef __GENERATING_BOUNDS_H
>  
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> @@ -257,7 +260,7 @@ static __always_inline bool page_count_writable(const struct page *page)
>  	 * The refcount check also prevents modification attempts to other (r/o)
>  	 * tail pages that are not fake heads.
>  	 */
> -	if (!atomic_read_acquire(&page->_refcount))
> +	if (atomic_read_acquire(&page->_refcount) & PAGEREF_LOCKED_BIT)
>  		return false;
>  
>  	return page_fixed_fake_head(page) == page;
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index b0e3f4a4b4b8..f2f2775af4bb 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -64,7 +64,12 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
>  
>  static inline int page_ref_count(const struct page *page)
>  {
> -	return atomic_read(&page->_refcount);
> +	int val = atomic_read(&page->_refcount);
> +
> +	if (unlikely(val & PAGEREF_LOCKED_BIT))
> +		return 0;
> +
> +	return val;
>  }
>  
>  /**
> @@ -176,6 +181,9 @@ static inline int page_ref_sub_and_test(struct page *page, int nr)
>  {
>  	int ret = atomic_sub_and_test(nr, &page->_refcount);
>  
> +	if (ret)
> +		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
> +
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -nr, ret);
>  	return ret;
> @@ -204,6 +212,9 @@ static inline int page_ref_dec_and_test(struct page *page)
>  {
>  	int ret = atomic_dec_and_test(&page->_refcount);
>  
> +	if (ret)
> +		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
> +
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -1, ret);
>  	return ret;
> @@ -228,14 +239,23 @@ static inline int folio_ref_dec_return(struct folio *folio)
>  	return page_ref_dec_return(&folio->page);
>  }
>  
> +#define _PAGEREF_LOCKED_LIMIT	((1 << 30) | PAGEREF_LOCKED_BIT)
> +
>  static inline bool page_ref_add_unless_zero(struct page *page, int nr)
>  {
>  	bool ret = false;
> +	int val;
>  
>  	rcu_read_lock();
>  	/* avoid writing to the vmemmap area being remapped */
> -	if (page_count_writable(page))
> -		ret = atomic_add_unless(&page->_refcount, nr, 0);
> +	if (page_count_writable(page)) {
> +		val = atomic_add_return(nr, &page->_refcount);
> +		ret = !(val & PAGEREF_LOCKED_BIT);
> +
> +		/* Undo atomic_add() if counter is locked and scary big */
> +		while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
> +			val = atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);
> +	}
>  	rcu_read_unlock();
>  
>  	if (page_ref_tracepoint_active(page_ref_mod_unless))
> @@ -271,7 +291,7 @@ static inline bool folio_ref_try_add(struct folio *folio, int count)
>  
>  static inline int page_ref_freeze(struct page *page, int count)
>  {
> -	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
> +	int ret = likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_LOCKED_BIT) == count);
>  
>  	if (page_ref_tracepoint_active(page_ref_freeze))
>  		__page_ref_freeze(page, count, ret);
> -- 
> 
> 

