Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67BBC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 12:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4446B008C; Fri, 31 Jul 2026 08:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95776B0092; Fri, 31 Jul 2026 08:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9E76B0093; Fri, 31 Jul 2026 08:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 814486B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:41:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1425DA042C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:41:05 +0000 (UTC)
X-FDA: 85049031690.04.2246692
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51C20140004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:41:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IM4AZFnV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785501663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZPfhyB157sYFTxtHnA680hCbQsHrYYadtzGHcFgiAo=;
	b=y6Lt14trRTEReU3nDvxI4uxUdvVbKtbaTuw5kCxr0ueJ67PDkpmYtOXaSAdIydHT3BySqz
	4wt0OC5nzoT+YxTGXP4YnCXppcfcDjdBhlxzIF7ZWGK6z23KTYuO+r/aHXDn4YV1lNddVx
	aMwPm9GkQNIMqfTEI3kap5VJrfmbdQQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IM4AZFnV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785501663;
	b=jg1cItwdts21dLrHvsNIETqG5fihAlJOfmX47S2bUoiMUbOTR3pxVUXcAq14W22ky80QfM
	s8rk5IiH3ZaTXR5ICpseLV7meUTl2x9K+bqZ8b1BM7U2y/8tuMT10FyQ3j5xQSWAsMAXU0
	cy32juC/Ctl6Uv1RAXNfByxkJQYB57Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D546434A2;
	Fri, 31 Jul 2026 12:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90701F00A3A;
	Fri, 31 Jul 2026 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501661;
	bh=TZPfhyB157sYFTxtHnA680hCbQsHrYYadtzGHcFgiAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IM4AZFnV306rXJOM4LXDy2ZvXhstyAnjiYFpjDWxYqTug/LZLnqLnmky1778nlqiH
	 wxIH/4wL+FQx3rOyvUAR/LEUSwxiJyciBfxhAPI87AAwLxuB4kQaeop440NYuq7skS
	 zm+Ahpuea/3Bn+iQegcrpyRjwsODrO/y2KnnXvFpvjMkPAQALPoaiTZtAhe5C+1DU4
	 tRhq48w8QbueyUvxBTw1Dko0vqmy6psjlKoqU2O5PXKftImdgz7G/vYPhU2unue6GB
	 R2Rufv/4TtkLhYPWpBh2UoTF++bPyDWCea35hFjU4Ai30lgz93wPT8PM9KmQRFtmeH
	 zqNwLTJ/JymYg==
Date: Fri, 31 Jul 2026 13:40:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
Message-ID: <amyWt8XYlQJRJXmg@lucifer>
References: <20260723074854.1013941-1-jyescas@google.com>
 <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
X-Rspamd-Queue-Id: 51C20140004
X-Rspam-User: 
X-Stat-Signature: 5c3sxq174cwtx1df8ng8emu65hmfarow
X-Rspamd-Server: rspam04
X-HE-Tag: 1785501663-890842
X-HE-Meta: U2FsdGVkX1/3E4BYMh4kfbyPVO/X1+1sK8c5g+bhM8RAf57dazDxxCozCKyxnkaZX8/eQi70mOUCG5ug+zJleDQSw+3vI4MNwGQWpNOsxL5vNZ5HBJTUXEW8tAg7Cur2fao3xgRu+uulehXAtRttryERhn9+gS7RDwtJPGl6gQjYYtAvDYcD496CL2oIKKi4Pj25Do2A2qrM+71LMnplGmazsX2nwVYslX56Zv1EQh+i1FsRtUXRu5EcCNGIVtXdcShxUT7zalj7CK5+szLk8lvlKJyZv/m0uA099BIdVsdJuTkJrAPkhCL+0LSjZ7hgB4st5vn+ZOUCkG7+zHM9zj/Qap6K4L1n4eBaCo2zuJrCqtGrAY/SEt2lIPMawjtEBf499rotBhhnShcge3gBA69tCxtC3Y3hdqLEwzBNoyuxRNMVU1sa9dPdj2ol4QM0d0u1JuS1BZU6tUf+k0BllDVs+l9D6BWmYvzy3E3J5MUNNY+xYB4AKl2MKti6hqk9A2OYTWt+PZAnQap/h09576LvIl7WC5SL8nGjceeINmwI0Miq5jtJckc8OoT6seP8T69zlMn7N4uy4Wo73cQ4LQdNV1CXYSfXsK0dc/0H/iDdONMiof1/R8kt0cPKuIiMKmy1PzbuttzzFvzCR699NnsJmsp4gTyotcjeqAmijawr+aUKSgpK5rQlzcTXu0W3cuQH9J7Nmd8UpjDjJ1giUvPc9dkOhllVVy8p4cQV38blwyXY7C3aMwgi9les/eA6LGocqEcdW7ztVfd2Ho5kyN14Rd8xuZgGJykKX7aoLP3lcLXzs+imdSZ/lmOUIEBXgx6f8CFiN6tRcKZ5SV/zldfoQFEwAFm18e8p7bqAMu1thywBuEUFDGJalpx5GxsKUYkWy7/P9/VQNl3ki3vdVGpEVL4wVqptfI+yL6eXbvmc9kvcqZ4IRclMqNU/uDfmf839OvMRMOpdintkN5I
 CwMCEB/G
 tZuJUDV4bAkWSvUXDiBEOjyXI1TbZOEgu3++cJq7JO3G1iQ+EjoMuxOUSj0aTuVzMMK3styNRAPCdHZ5VsNdXnkA3k9ZBxIqe/gpV1ipomMa1e6NZyiX29bp9fuxevqxrmTtMJVumo1Llrz50Tk2C8oFmWTCQyl/bPcd6HCr5JVMLonJUQMHzHkWFfWZ7adF7q3TL5dpnWPmPlGAAsICqqTg7KJ+U9o/z3bAHDVY6MZzBwNt2qBMACzO0oRysMkWfyisUGxr96jkQBl46JLN3T3SkHubocfv2Pko5wMhtNCvpA5uIeIegndtqR0kdvcFV5MGZKmuE6YPPXWOVQBVXY1es/NmikvrV0Ulp20lrxcTzUP9iK/1ybKMMWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> On Tue, Jul 28, 2026 at 12:29 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 7/23/26 09:47, Juan Yescas wrote:
> > > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> > > allows you to allocate memory pages from specific nodes, zones, migration
> > > types, and orders directly via debugfs. This provides key benefits for
> > > testing and debugging:
> >
> > Would it be feasible to carry this as an OOT debugging module? Would a lot of
> > symbols be missing to achieve that?
> >
>
> Thanks David for the comment.
>
> The only symbol that would be needed to have this module as OOT is
> "migratetype_names".

Hmm I could have sworn I replied to this :)

Anyway, I don't think there's any need to export this. It's not like we're going
to radically rename them, and you'd probably have to update your module anyway
if we added a new migratetype.

So this being wholly contained in a module with no core changes seems the best
way?

Cheers, Lorenzo

>
> However, although this module was originally designed to debug CMA
> issues, it can be
> easily used to debug issues in kswapd, direct reclaims, OOM killer,
> etc. We could even
> use this module to add kunit test cases.
>
> Let's take for example this case. We want to allocate Unmovable memory and check
> that the allocation came from Movable, as per the buddy allocator
> fallback mechanism.
> How can we do that in user space?
>
> $ cat /proc/pagetypeinfo
> Page block order: 9
> Pages per block:  512
>
> Free pages count per migrate type at order 0  1  2  3  4  5  6  7  8  9   10
> Node 0, zone    DMA, type   Unmovable      0  0  0  0  0  0  0  0  0  0    0
> Node 0, zone    DMA, type     Movable      1  1  1  0  1  1  2  2  1  3  732
> Node 0, zone    DMA, type Reclaimable      0  0  0  0  0  0  0  0  0  0    0
> Node 0, zone    DMA, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
> Node 0, zone    DMA, type         CMA      0  0  0  0  0  0  0  0  0  1    7
> Node 0, zone    DMA, type     Isolate      0  0  0  0  0  0  0  0  0  0    0
> Node 0, zone Normal, type   Unmovable     13  7  0  1  0  0  1  0  1  0    0
> Node 0, zone Normal, type     Movable      1  1  1  1  1  1  1  0  1  1 1221
> Node 0, zone Normal, type Reclaimable      1  0  0  0  0  0  1  0  0  1    0
> Node 0, zone Normal, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    0
> Node 0, zone Normal, type         CMA      0  0  0  0  0  0  0  0  0  1    7
> Node 0, zone Normal, type     Isolate      0  0  0  0  0  0  0  0  0  0    0
>
> // Allocate Unmovable memory (note that there are NO Unmovable pages,
> so the allocation will fall back from Movable)
> $ echo 1221 > /sys/kernel/debug/mm/node-0/zone-Normal/order-10/migrate-Unmovable/nr_pages_allocs
>
> $ cat /proc/pagetypeinfo
> Page block order: 9
> Pages per block:  512
>
> Free pages count per migrate type at order       0      1      2
> 3      4      5      6      7      8      9     10
> Node    0, zone      DMA, type    Unmovable      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone      DMA, type      Movable      1      1      1
> 0      1      1      2      2      1      3    701
> Node    0, zone      DMA, type  Reclaimable      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone      DMA, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone      DMA, type          CMA      0      0      0
> 0      0      0      0      0      0      1     31
> Node    0, zone      DMA, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type    Unmovable      1      0      0
> 1      1      1      1      1      1      0      0
> Node    0, zone   Normal, type      Movable      1      0      1
> 1      1      1      1      1      1      1      7
> Node    0, zone   Normal, type  Reclaimable      0      1      0
> 0      1      0      0      0      1      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type          CMA      0      0      0
> 0      0      0      0      0      0      1      7
> Node    0, zone   Normal, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
>
> Number of blocks type     Unmovable      Movable  Reclaimable
> HighAtomic          CMA      Isolate
> Node 0, zone      DMA           14         1458            0
>  0           64            0
> Node 0, zone   Normal         2440          102            2
>  0           16            0
>
> // Now we want to test that Reclaimable memory allocations fall back
> from ZONE_DMA and Migrate Movable
>
> $ echo 600 > /sys/kernel/debug/mm/node-0/zone-Normal/order-10/migrate-Reclaimable/nr_pages_allocs
> # cat /proc/pagetypeinfo
> Page block order: 9
> Pages per block:  512
>
> Free pages count per migrate type at order       0      1      2
> 3      4      5      6      7      8      9     10
> Node    0, zone      DMA, type    Unmovable      0      0      0
> 0      0      1      1      0      0      1      0
> Node    0, zone      DMA, type      Movable      1      1      1
> 0      1      1      2      2      1      3     99
> Node    0, zone      DMA, type  Reclaimable      1      0      0
> 1      0      0      1      0      1      1      0
> Node    0, zone      DMA, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone      DMA, type          CMA      0      0      0
> 0      0      0      0      0      0      1     31
> Node    0, zone      DMA, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type    Unmovable      1      0      0
> 1      1      1      1      1      1      0      0
> Node    0, zone   Normal, type      Movable      0      0      0
> 1      0      0      1      0      1      0      7
> Node    0, zone   Normal, type  Reclaimable      0      1      0
> 0      1      0      0      0      1      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type          CMA      0      0      0
> 0      0      0      0      0      0      1      7
> Node    0, zone   Normal, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
>
> Number of blocks type     Unmovable      Movable  Reclaimable
> HighAtomic          CMA      Isolate
> Node 0, zone      DMA           16          254         1202
>  0           64            0
> Node 0, zone   Normal         2440          102            2
>  0           16            0
>
> // Now, we want to free all the MIGRATE_UNMOVABLE allocations and
> sleep 1 second for every
> // allocation and see how the pages return to the MIGRATE_UNMOVABLE bucket:
>
> for i in `seq 1 1221`; do echo $i > /sys/kernel/debug/mm/free; sleep 10; done
>
> // in another console
>
> watch cat /proc/pagetypeinfo
>                             2026-07-29 00:28:49
>
> Page block order: 9
> Pages per block:  512
>
> Free pages count per migrate type at order       0      1      2
> 3      4      5      6      7      8      9     10
> Node    0, zone      DMA, type    Unmovable      0      0      0
> 0      0      1      1      0      0      1      0
> Node    0, zone      DMA, type      Movable      1      1      1
> 0      1      1      2      2      1      3     99
> Node    0, zone      DMA, type  Reclaimable      1      0      0
> 1      0      0      1      0      1      1      0
> Node    0, zone      DMA, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone      DMA, type          CMA      0      0      0
> 0      0      0      0      0      0      1     31
> Node    0, zone      DMA, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type    Unmovable      1      0      0
> 1      1      1      1      1      1      0    698
> Node    0, zone   Normal, type      Movable      1      0      0
> 1      0      0      0      0      1      0      7
> Node    0, zone   Normal, type  Reclaimable      0      1      0
> 0      1      0      0      0      1      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0
> 0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type          CMA      0      0      0
> 0      0      0      0      0      0      1      7
> Node    0, zone   Normal, type      Isolate      0      0      0
> 0      0      0      0      0      0      0      0
>
> Number of blocks type     Unmovable      Movable  Reclaimable
> HighAtomic          CMA      Isolate
> Node 0, zone      DMA           16          254         1202
>  0           64            0
> Node 0, zone   Normal         2440          102            2
>  0           16            0
>
> Achieving the same result in a user program is not as straightforward.
>
> The Page Alloc Hogger gives us the flexibility to allocate from any
> valid memory we desire.
>
> As I mentioned before, it allows us to test/check/analyze/generate:
>
> - kwapd triggers
> - direct reclaims
> - OOM killer
> - generate page fragmentation using simple scripts instead of complex programs
>
> Greetigns
>
> Juan
>
>
> > --
> > Cheers,
> >
> > David

--
Cheers, Lorenzo

