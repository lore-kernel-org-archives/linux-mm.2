Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B61C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 03:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5866B0088; Sat, 18 Jul 2026 23:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E756B008A; Sat, 18 Jul 2026 23:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F320A6B008C; Sat, 18 Jul 2026 23:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC1F26B0088
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 23:42:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E9AA1C06C0
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:42:50 +0000 (UTC)
X-FDA: 85004129700.22.F92FDC0
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id BEC50A0005
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:42:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=fVrKn7CN;
	spf=pass (imf15.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 83.166.143.170 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784432568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9suQfKZXU1SGKWXutPuadB/Zx3K97f3IsQ57BUgKD8=;
	b=bQPWKCazqw0rOoi/9oy8+fNMN/Vqgjt4Kexgow7gEDgEWFg6rR/FU9mZpXGgY/2jhxPTcT
	liPJJs/q+bLQ+ZV93qPKZnvSJM+D44KWkRVH6SCKnHAI2gNhf022aY/hGhb3QCjmQnUpWI
	qfx1xmorJ/yxqsHpJ2aSaVUwxHgXTQ8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=fVrKn7CN;
	spf=pass (imf15.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 83.166.143.170 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784432568;
	b=TDfMAi+BbodhpYVU1K6TDslCdoOtK/J5uXapSSr3ZO3KIz9MpvkCMumMbbnOwfty3sCkUZ
	UwfTj50r4cExhejyhRG+6DhUS5fsQUQ9yEoEzW/2VTt7TNbWRat5U/cmuCHUtUStpPWFw3
	xPmcWPPRv/ncXjhPnbZl4PzukCx5vdI=
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h2qGs3tQ3zkyV;
	Sun, 19 Jul 2026 05:42:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784432565; bh=+9suQfKZXU1SGKWXutPuadB/Zx3K97f3IsQ57BUgKD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fVrKn7CN+ZTwg7Ey0pzukY94QJ1WIIf4RyEHdQSoIdv+E86K/E+VmD9DxNCbbAdis
	 3FtQdPhYDHIahqHUS8bj+HYlkT32kP9RRAIcSUr0ym4N7xsiZZTySPMDmALuresDKL
	 Lu1tkTH1hCrJNRXmEY3ADcrPonoZ4QFw51OwI8pU=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h2qGn55MHzx3p;
	Sun, 19 Jul 2026 05:42:41 +0200 (CEST)
Date: Sun, 19 Jul 2026 05:42:39 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <alw7RLxxmeT-moTk@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
Feedback-ID: :3834f243f7d785d:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BEC50A0005
X-Stat-Signature: 9gbhycn88kg3ok3h6pe4ac7qojcarw6g
X-HE-Tag: 1784432567-738190
X-HE-Meta: U2FsdGVkX1/RAoayKEcpRuxX6Hl7CIEE8oaVWivPFkZOPllkrbqoHI+InIIORmAgQ5k9K9bhl+BEzOFbe0EPzRGU12DiTrBipaww3xzTS1uwuGEpyjPrAkXEBxsFN4TMnOVQGy+KwEsNw+XZkPeQsUVcIosrpjqvLlbhC5uaRWPpw6VkOeqM04qwfWKvcF/Rp2pzJnO8Nqtb9LD16fESwlQA5WAMACw5Px9EAKGb9QMXkQbTlG7I5T0jq2Dl7pq/yQyQazMyFWQdjff/DzBuNdHfvUG0F2L4aSwcbGpPsfR6df25FP19bxGVquf5tnnI7AK2PdMW7HthXis4LptnsOYMlKhp+6K+cvtgvkOdAH7QEit7UlvGe+6HwdPWPSW4LdjsslLJqUJl8adN7OnqcyxRGrLmviuiXJDpuj3G8Q+ickyC26CVTMuNXHSBUC/YfoNkvnRzDKHj68Tvy+yztfuHbIZBlDfqr/bK/ZK5ECcVD2Q1V+Y2EIFNjjyTsR3YPLOYSWuYHjJQlUWcQOpp/tnZnZ301T3iXyJSIpwpG+/WB53wr/Si3FDYb9s2bj4B1Zq4shWf/7dnuGMvXWXqN77GBTAg0LTnhfVYp5lVrOTxJWP4eehYlBUtYN/yRc/RF4/b1Dnh06TFljFktHrWxFYbQR0xqx6zhbnce0sgQz5rxp50lDLC8dtPyaIah9d0CcYqTp2MMQZ/B2jaPQ0/3X5cc+n01j8VOqwziXTVGASrFaMswT+Z191vJ7iKYf1pdK5GKy+EezxanV/qAZ/MWr29I+NDWOeDwfEylrh8YX9+1c1I/hQm961fPdnnKIoBKCOtIf1Ux7OpOr3/TkMqPqzglnmVCYJaAGF7nt0TICCneldfTAThR4RtyN7YxiN1/CefR/AuwlF768RJgFMdT/2galOHdTRuGKT6qHNS3PLEPGenJsPUobCbptoXO9Ob5z54+5cIJFyWEC9OjeN
 SZbFQ4av
 w7RxiMd20o+QuRHWjQpVgLy6Xr15CGWXgqg5AHhQr/ap6e4pEoQnbMfxjOlFG75AClm4PmWRifbXA/9Vm4onkzk4iAk771BtNVzo2C9T6DYll5u+uGQsXDL8CHQrm02LBSUBeHhmTxRLJReDOJD1YVosagA+sR7DApFkMzjfHeY8lrkf9+aEI/TzYSC/Sa+miq69TP2urRmbSmeilqH3kL90ne/MoPLpUkthNWVe3W7/odtDvdOFlFA8R9ExxzTcu7+QByE2jhB3jebRtHOAKLjiDDi5rTru2qHfIqPJZ3ENjlkTyWsf4/ssjcdoI3Fqwi86Z7eYa5/S1TLzIvRD+t7SQrEdeQEm4S1wA3kWoN67GJDsHRMvADoUS9F3xQc7gYiCgrlrGYh/6cxRcaPnJfQVybP5RxENnoN2kqHgLZnu6yiZdLhEna9L8MLjYEFx43E1uXebdi8zMZ60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> First of all, this looks like fun. Nice work! I'm not opposed at all in
> concept to cleaning up things and doing the logical separation you
> described to split buddy granularity and mapping granularity. That seems
> like a worthy endeavor and some of the union/#define tricks look like a
> likely viable way to do it incrementally.

My 2003 pgcl code was the funnest kernel hacking I've ever done. You
were there (or at least involved; I don't remember in enough detail to
even be sure if we were together in person) when it got the first public
boot on 32-bit x86 with 64 GiB RAM, and even noted that my earlier work
on shrinking the size of struct page had got things booting with
ridiculously little lowmem left over after mem_map when you were
flagging me down for 16 nodes being available to be glued together.


On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> But I don't think there's going to be a lot of memory savings in the
> end. Maybe this would bring the mem= hyperscalers back into the fold and
> have them actually start using 'struct page' again for their VM memory.
> Dunno.

For 32-bit it was only really an issue because it was lowmem. From day
one back in 2003 it was always a matter of trading off internal for
external fragmentation, and there was even some worry about losses from
internal fragmentation potentially exhausting lowmem under load. It's in
a way like being able to adjust the frontier between internal and
external fragmentation more than really saving memory at all. Apart from
lowmem exhaustion on 32-bit and maybe being so large and heavily used
that it competes with userspace for cache and TLB, the struct page
array's memory consumption is mostly irrelevant.

strictly speaking, struct page as presently conceived isn't necessary at
all. There are mostly microkernels out there that do no per-page memory
bookkeeping. The basic pattern is that the commitment to what kind of
bookkeeping to do is mostly deferred until it gets allocated and put in
use, at which point things like slab memory, pagecache memory,
pagetables and such all have different ways of tracking everything. The
basic allocators can do a variety of things, too. In-band metadata IOW
using the memory the allocator is saying is technically free to hold
metadata is one of the tricks, adaptively switching between radix tree
or bitmapped things, using address calculation to only need things like
a pair of bits for each radix tree node's entries, and maybe even bit
twiddling lockfree code etc. all start getting in the mix like LLFree:

https://www.usenix.org/conference/atc23/presentation/wrenger
https://www.sra.uni-hannover.de/Publications/2023/llfree-atc23/
https://github.com/luhsra/llfree-c

You still get a couple of bits per page, but the delayed metadata
allocation getting less internal fragmentation(!) from forcing too many
disparate metadata types into a union isn't saving anywhere near as much
as the disappearance of the centralised, readily-identifiable struct
page array might suggest, so there's more than enough left over to
swamp those bits. Having slab, pagecache, pagetable etc. metadata all
unmixed with each other still means they have significant metadata
footprints that are significant fractions of what a struct page array
would be. The real advantage for memory hyperscalars is that splitting
them those ways enables more locality of reference.


On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> But, let's look at my kernel directory and round the file sizes up to
> 4k, 16k and 64k:
> find .  -printf '%s\n' | while read size; do echo	\
> 		$(((size + 0x0fff) & 0xfffff000))	\
> 		$(((size + 0x3fff) & 0xffffc000))	\
> 		$(((size + 0xffff) & 0xffff0000));
> done
> ... and add them all up:
> 11,297,648 KB - on disk
> 11,297,712 KB - in a 4k page cache
> 12,223,488 KB - in a 16k page cache
> 16,623,296 KB - in a 64k page cache

4 KiB being so close to disc is surprising esp. since disc is usually
doing tail packing atop 512 B blocks. The rest is unsurprising.


On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> So a 64k page cache eats ~5GB of extra memory for a kernel tree (well,
> _my_ kernel tree). In other words, if you are looking for memory savings
> on my laptop, you'll need ~300GB of RAM before 'struct page' overhead
> overwhelms the page cache bloat from a single kernel tree.
> The whole kernel obviously isn't in the page cache all at the same time.
> The page cache across the system is also obviously different than a
> kernel tree, but you get the point.
> That's not to diminish how useful something like this might be,
> especially for folks that are sensitive to 'struct page' overhead or
> allocator performance.
> But, it will mostly be getting better performance at the _cost_ of
> consuming more RAM, not saving RAM.

Given that you don't remember the project at all, I can assume the
IBM-internal whitepaper where I described doing tail packing for small
files in the pagecache as part of an array of strategies to mitigate
internal fragmentation and latency issues expected to arise for large
values of PAGE_MMUSHIFT is also forgotten. I wrote some things I thought
worthwhile there and I was hoping you'd be able to at least corroborate
the one-time, now-former existence of the thing and maybe some
smatterings of its contents since it's no longer extant.

Or please do let me know if I've jogged your memory or whatever.


-- nyc

