Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18904D1D86A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658D36B0023; Thu,  4 Dec 2025 01:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630E26B0024; Thu,  4 Dec 2025 01:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C0C6B0026; Thu,  4 Dec 2025 01:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41D826B0023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:16:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF1DB1A08E9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:16:47 +0000 (UTC)
X-FDA: 84180780054.21.344C8BA
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id A9B24C0009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:16:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L6HEg+2i;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764829006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZTOMerwnRYptdV0Wvx+zUyAlYgjFfNvwhibhMd/zKs=;
	b=vdI/xyVZLx6xBlqS18zET8/xcUmnRvL80b0xN/2X3mpnN+FS3H+5xyZ4D3YzL5e12g3rlk
	TrH22fteTjyZOTe5SqqOJf+qdhrdaB0dE4U/ITdMpGa9wCsq3J7BnDznCVIEQbbakUG20I
	l3TGmigxDL5XlzaXtgNA/LuRFK65SHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764829006; a=rsa-sha256;
	cv=none;
	b=gwf8AUILrD9L8Ir/JhBcPadw28B4fjzrSq2ESQdAQmPbpc84r1OCfd5xPb/YOHDTM/ihm0
	EMzwifiMrDQQrLunqTDVveYYC5Zm+WfXdL1LP8L504JSz7wm9IqvvhPpa0OU6mHTgr2YhI
	4CjKsYp5/TIE7gl7XZ/3xXEKFZGWRvs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L6HEg+2i;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 4 Dec 2025 06:16:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764829003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uZTOMerwnRYptdV0Wvx+zUyAlYgjFfNvwhibhMd/zKs=;
	b=L6HEg+2i5kIZ4wOwr1byMEe4ajf0HQWa70M2D5DsP1r8MxYGoNYHV51E1/jDWgsJByL/oy
	IR6o/W4VpSiJmHYK1A+fGuHbpLdIB3OncUQeMrWMcsUWAJOFt0qS5MkTIXN65noA//v1Hx
	IzHlr7Ny87X+g3hIQiYVNTI+V0ynbJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <cxxoqqalrna65kafcpig65kt5gziwe66cep3luf736lp3hmqtu@2yqkilusmmdj>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
 <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A9B24C0009
X-Stat-Signature: musmhc7h46abje6txf6qexneefwuqzb9
X-HE-Tag: 1764829005-768005
X-HE-Meta: U2FsdGVkX1+S+Osat7nq3MXtDr/eV7GHcFHSDE0wDuZrh9yJkgA+X/A03sYUllCqPpj4u/6Yn6CbBxs3hnVEpmLNqW2PezzcM3KBCVYGTzlg4BDk/ABiWJmyFjSt3pUqdi8GHqvWgAfTUPqoF3gIdPigHZR8EOdcGGVzIc14AwZ2t2L8xx949+Kn3M/NhRh303hMU6V/tXpXYlo4xs6byKvhHcCHUyk+oqJHfOud0aGSotfhU6YyRezszBO9WAJKf9Hd6vUg3IwccUGlhszDF91ndoyU1XjGgZMeQCWDLl645QfpidrcpYD2bPxNIrq8Ltw9htQL/CJv13BNByFimyKMgX6yoa6JuwyfZJzAxcRkrlpoG9ixuzs87WwwljwFr1l7esCSBuWoZw0kBaWRMi9WGO4WljO8PYy/H2j5sw+t11nyDD2SH7x0RNca+m/NkXX18DnkuoxmE8v1wA4pFsCNBXHeSsz7z7sniyd4K/rwrDyE0xPh1oWFnoJsHAclJvnd9VV5/qBQn7kjLCQ4sZDQUQ3xZbEkkzpjhffOyDR3zUT9aDPEZIglMz4+J5uKO75Rpb4UN7zSqUIyXWE9h75JRc5tmYAYOHi+3uKxSzY8oPX4HqZwNBVk0GWIo8pYItvBM2++FMCunEOD47wLzt2lLLFO4IjrJB3OGAVo30wGzCIQR2Xhrz09o+giN7nrBQDAzQdztSr06mNgDSyKlatzYyMSzyaWeHPwRSsmPFlIv5LlksGWf09JZR79UfpQV6zbjl41e2F7Lvp0ozq7QGWDjZxLkUV3ft/VxG46KV4q5Bjg598UawMRs2e1U3kYMEpfyI2AItUS2soKwSCaMwDugtVM61SW05T+MQgWA4tt3qZvSQD7sH/H9G08LcPCilAWxGwtEbawuDuJJ3Y8TV6uxy8dC7L38jbKBZ+z8o9HPQolU7Mgfh+cT/uRWoNSXU5bDqcM2lQ/T0YOMo3
 TTkl+ycM
 6lHZEg/FWmFUzCSllz0ZG9O8rB5G/PmUHd1I/xnHBJdA+8uLHwFK15CbHwVLONjtMgoOR1ZAN2X4kY9WVFDQS8NMZ5g729FahzyRLEWFa9A1ZUi3ryuC0Ym3lt7Tl7JAY9EAnDS/A6vy4F8RMWieMyupDPfbvJ9hGrWYPRTu3Br+Fb3ixBqGNed+XVM+NFJqFAceCGAU2ZnyzRirtCEz7GYr4XSsUBYrLoo5aT+8ev3yKUi0MAjh9PrAunH6wW6hGHEFd2ufzs+wxbVV8YUVoVQ6nAsTk++BgjRu2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..] 
> > Third, Chris, please stop trying to force this into a company vs company
> > situation. You keep mentioning personal attacks, but you are making this
> > personal more than anyone in this thread by taking this approach.
> 
> Let me clarify, it is absolutely not my intention to make it company
> vs company, that does not fit the description either. Please accept my
> apology for that. My original intention is that it is a group of
> people sharing the same idea. More like I am against a whole group
> (team VS). It is not about which company at all. Round robin N -> 1
> intense arguing put me in an uncomfortable situation, feeling
> excluded.
> 
> On one hand I wish there was someone representing  the group as the
> main speaker, that would make the discussion feel more equal, more
> inclusive. On the other hand, any perspective is important, it is hard
> to require the voice to route through the main speaker. It is hard to
> execute in practice. So I give up suggesting that.  I am open for
> suggestions on how to make the discussion more inclusive for newcomers
> to the existing established group.

Every person is expressing their own opinion, I don't think there's a
way to change that or have a "representative" of each opinion. In fact,
changing that would be the opposite of inclusive.  

> 
> > Now with all of that out of the way, I want to try to salvage the
> > technical discussion here. Taking several steps back, and
> 
> Thank you for driving the discussion back to the technical side. I
> really appreciate it.
> 
> > oversimplifying a bit: Chris mentioned having a frontend and backend and
> > an optional redirection when a page is moved between swap backends. This
> > is conceptually the same as the virtual swap proposal.
> 
> In my perspective, it is not the same as a virtual swap proposal.
> There is some overlap, they both can do redirection.
> 
> But they originally aim to solve two different problems. One of the
> important goals of the swap table is  to allow continuing mTHP swap
> entry when all the space left is not continues. For the rest of the
> discusion we call it "continuous mTHP allocator". It allocate
> continuous swap entry out of non continues file location.
> 
> Let's say you have a 1G swapfile, all full not available slots.
> 1) free 4 pages at swap offset 1, 3, 5, 7. All discontiguous spaces
> add up to 16K.
> 2) Now allocate one mTHP order 2, 16K in size.
> Previous allocator can not be satisfied with this requirement. Because
> the 4 empty slots are not contiguous.
> Here the redirection and growth of the front swap entry comes in, it
> is all part of the consideration all alone, not an afterthought.
> This following step will allow allocating 16K continuous swap entries
> out of offset [1,3,5,7]
> 3) We grow the front end part of the swapfile, effectively bump up the
> max size and add a new cluster of order 2, with a swap table.
> That is where the front end of the swap and back end file store comes in.

There's no reason why we cannot do the same with virtual swap, even if
it wasn't the main motivaiton, I don't see why we can't achieve the same
result.

> 
> BTW, Please don't accuse me copy cat the name "virtual swapfile". I
> introduce it here 1/8/2025 before Nhat does:

I don't think anyone cares about the actual names, or accused anyone of
copycatting anything.

> https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3uv9asuArpoYLw@mail.gmail.com/
> ==============quote==============
> I think we need to have a separation of the swap cache and the backing
> of IO of the swap file. I call it the "virtual swapfile".
> It is virtual in two aspect:
> 1) There is an up front size at swap on, but no up front allocation of
> the vmalloc array. The array grows as needed.
> 2) There is a virtual to physical swap entry mapping. The cost is 4
> bytes per swap entry. But it will solve a lot of problems all
> together.
> ==============quote ends =========
> Side story:
> I want to pass the "virtual swapfile"  for Kairui to propose as LSF
> topic. Coincidentally  Nhat proposes the virtual swap as a LSF topic
> at 1/16/2025, a few days after I mention "virtual swapfile" in the lsf
> topic related discussion. It is right before Kairui purpose "virtual
> swapfile". Kairui renamed our version as "swap table". That is the
> history behind the name of "swap table".
> https://lore.kernel.org/linux-mm/20250116092254.204549-1-nphamcs@gmail.com/
> 
> I am sure Nhat did not see that email and come up with it
> independently, coincidentally. I just want to establish that I have
> prior art introducing the name "virtual swapfile" before Nhat's LSF
> "virtual swap" topic. After all, it is just a name. I am just as happy
> using "swap table".
> 
> To avoid confuse the reader I will call my version of "virtual swap"
> the "front end".
> 
> The front end owns the cluster and swap table (swap cache). 8 bytes.
> The back end only contain file position pointer. 4 bytes.
> 
> 4) The back end will need different allocate because the allocating
> assumption is different, it does not have alignment requirement. It
> just need to track which block location is available.
> It will need to have a back end specific allocator.  It only manage
> the location of the swapfile cannot allocate from fronted. e.g.
> redirection entry create a hole. or the new cluster added from step 3.
> 
> 5) the backend location pointer is optional of the cluster. For the
> cluster new allocated from step, It must have location pointer,
> because its offset is out of the backing file range.
> That is a 4 byte just like a swap entry.
> This backend location pointer can be used by solution like VS as well.
> That is part of the consideration as well, so not a after thought.
> The allocator mention here is more like a file system design rather
> than pure memory location, because it need to consider block location
> for combining block level IO.
> 
> So the mTHP allocator can do swapfile location redirection. But that
> is a side benefit of a different design goal (mTHP allocation). This
> physical location pointer description match my 2024 LSF pony talk
> slide. I just did not put text in the slide there. So it is not some
> thing after thought, it pre-dates back to 2024 talks.
> 
> > I think the key difference here is:
> > - In Chris's proposal, we start with a swap entry that represents a swap
> >   slot in swapfile A. If we do writeback (or swap tiering), we create
> >   another swap entry in swapfile B, and have the first swap entry point
> 
> Correction. Instead of swapfile B, Backend location in swapfile B. in
> step 5). It only 4 byte. The back end does not have swap cache. The
> swap cache belong to front end A (8 bytes).

Ack.

> 
> >   to it instead of the slot in swapfile A. If we want to reuse the swap
> >   slot in swapfile A, we create a new swap entry that points to it.
> >
> >   So we start with a swap entry that directly maps to a swap slot, and
> 
> Again, in my description swap slot A has a file backend location
> pointer points to swapfile B.
> It is only the bottom half the swap slot B, not the full swap slot. It
> does not have 8 byte swap entry overhead of B.

Ack.

> 
> >   optionally put a redirection there to point to another swap slot for
> >   writeback/tiering.
> 
> Point to another swapfile location backend, not swap entry.(4 bytes)

Ack.

> 
> >   Everything is a swapfile, even zswap will need to be represented by a
> >   separate (ghost) swapfile.
> 
> Allow ghost swapfile. I wouldn't go as far saying ban the current
> zswap writeback, that part is TBD. My description is enable memory
> swap tiers without actual physical file backing. Enable ghost
> swapfile.
> 
> >
> > - In the virtual swap proposal, swap entries are in a completely
> >   different space than swap slots. A swap entry points to an arbitrary
> >   swap slot (or zswap entry) from the beginning, and writeback (or
> >   tiering) does not change that, it only changes what is being pointed
> >   to.
> >
> > Regarding memory overhead (assuming x86_64), Chris's proposal has 8
> > bytes per entry in the swap table that is used to hold both the swap
> > count as well as the swapcache or shadow entry. Nhat's RFC for virtual
> Ack
> 
> > swap had 48 bytes of overhead, but that's a PoC of a specific
> > implementaiton.
> 
> Ack.
> 
> > Disregarding any specific implementation, any space optimizations that
> > can be applied to the swap table (e.g. combining swap count and
> > swapcache in an 8 byte field) can also be applied to virtual swap. The
> > only *real* difference is that with virtual swap we need to store the
> > swap slot (or zswap entry), while for the current swap table proposal it
> > is implied by the index of the entry. That's an additional 8 bytes.
> 
> No, the VS has a smaller design scope. VS does not enable "continous
> mTHP allocation" . At least that is not mention in any previous VS
> material.

Why not? Even if it wasn't specifically called out as part of the
motivation, it still achieves that. What we need for the mTHP swap is to
have a redirection layer. Both virtual swap or the front-end/back-end
design achieve that.

> 
> > So I think a fully optimized implementation of virtual swap could end up
> > with an overhead of 16 bytes per-entry. Everything else (locks,
> > rcu_head, etc) can probably be optimized away by using similar
> > optimizations as the swap table (e.g. do locking and alloc/freeing in
> 
> With the continues mTHP allocator mention above, it already has the
> all things VS needed.
> I am not sure we still need VS if we have "continues mTHP allocator",
> that is TBD.

As I mentioned above, I think the front-end/back-end swap tables and
virtual swap are conceptually very similar. The more we discuss this the
more I am convinced about this tbh. In both cases we provide an
indirection layer such that we can change the backend or backing
swapfile without updating the page tables, and allow thing like mTHP
swap without having contiguous slots in the swapfile.

> 
> Yes, VS can reuse the physical location pointer by "continues mTHP allocator".
> 
> The overhead is for above swap table of redirection is 12 bytes not 16 bytes.

Honeslty if it boils down to 4 bytes per page, I think that's a really
small difference. Especially that it doesn't apply to all cases (e.g.
not the zswap-only case that Google currently uses).

> 
> > batches). In fact, I think we can use the swap table as the allocator in
> > the virtual swap space, reusing all the locking and allocation
> 
> That is my feel all alone. Let swap table manage that.
> 
> > optimizations. The difference would be that the swap table is indexed by
> > the virtual swap ID rather than the swap slot index.
> 
>  In the "continous mTHP allocator" it is just physical location pointer,
> 
> > Another important aspect here, in the simple case the swap table does
> > have lower overhead than virtual swap (8 bytes vs 16 bytes). Although
> > the difference isn't large to begin with, I don't think it's always the
> > case. I think this is only true for the simple case of having a swapped
> > out page on a disk swapfile or in a zswap (ghost) swapfile.
> 
> Please redo your evaluation after reading the above "continuous mTHP alloctor".

I did, and if anything I am more convinced that the designs are
conceptually close. The main difference is that the virtual swap
approach is more flexible in my opinion because the backend doesn't have
to be a swapfile, and we don't need "ghost" to use zswap and manage it
like a swapfile.

> 
> > Once a page is written back from zswap to disk swapfile, in the swap
> > table approach we'll have two swap table entries. One in the ghost
> 
> One one entry with back end location pointer. (12 byte)
> 
> > swapfile (with a redirection), and one in the disk swapfile. That's 16
> > bytes, equal to the overhead of virtual swap.
> 
> Again 12 bytes using "continues mTHP allocator" frame work.

Ack.

> 
> > Now imagine a scenario where we have zswap, SSD, and HDD swapfiles with
> > tiering. If a page goes to zswap, then SSD, then HDD, we'll end up with
> > 3 swap table entries for a single swapped out page. That's 24 bytes. So
> > the memory overhead is not really constant, it scales with the number of
> > tiers (as opposed to virtual swap).
> 
> Nope, Only one front swap entry remain the same, every time it write
> to a different tier, it only update the back end physical location
> pointer.
> It always points to the finial physical location. Only 12 bytes total.

Ack.

> 
> You are paying 24 bytes because you don't have the front end vs back end split.
> Your redirection includes the front end 8 byte as well. Because you
> include the front end, now you need to do the relay forward.
> That is the benefit to have front end and back end split of the swap
> file. Make it more like a file system design.
> 
> > Another scenario is where we have SSD and HDD swapfiles with tiering. If
> > a page starts in SSD and goes to HDD, we'll have to swap table entries
> > for it (as above). The SSD entry would be wasted (has a redirection),
> > but Chris mentioned that we can fix this by allocating another frontend
> > cluster that points at the same SSD slot. How does this fit in the
> 
> No a fix. It is in the design consideration all alone. When the
> redirection happen, that underlying physical block location pointer
> will add to the backend allocator. The backend don't overlap with swap
> entry location can be allocated from front end.
> 
> > 8-byte swap table entry tho? The 8-bytes can only hold the swapcache or
> > shadow (and swapcount), but not the swap slot. For the current
> > implementation, the slot is implied by the swap table index, but if we
> > have separate front end swap tables, then we'll also need to store the
> > actual slot.
> 
> Please read the above description regarding the front end and back end
> split then ask your question again. The "continuous mTHP allocator"
> above should answer your question.

Yeah, the 8 bytes front-end and 4-bytes backend answer this.

> 
> > We can workaround this by having different types of clusters and swap
> > tables, where "virtual" clusters have 16 bytes instead of 8 bytes per
> > entry for that, sure.. but at that point we're at significantly more
> > complexity to end up where virtual swap would have put us.
> 
> No, that further complicating things. Please don't go there. The front
> end and back end location split is design to simplify situation like
> this. It is conceptual much cleaner as well.

Yeah that was mostly hypothetical.

> 
> >
> > Chris, Johannes, Nhat -- please correct me if I am wrong here or if I
> > missed something. I think the current swap table work by Kairui is
> 
> Yes, see the above explanation of the "continuous mTHP allocator".
> 
> > great, and we can reuse it for virtual swap (as I mentioned above). But
> > I don't think forcing everything to use a swapfile and extending swap
> > tables to support indirections and frontend/backend split is the way to
> > go (for the reasons described above).
> 
> IMHO, it is the way to go if consider mTHP allocating. You have
> different assumption than mine in my design, I correct your
> description as much as I can above. I am interested in your opinion
> after read the above description of "continuous mTHP allocator", which
> is match the 2024 LSF talk slide regarding swap cache redirecting
> physical locations.

As I mentioned, I am still very much convinced the designs are
conceptually very similar and the main difference is whether the
"backend" is 4 bytes and points at a slot in a swapfile, or a generic
8-byte pointer.

FWIW, we can use 4 bytes in virtual swap as well if we leave the xarray
in zswap. 4 bytes is plenty of space for an index into the zswap xarray
if we no longer use the swap offset. But if we use 8 bytes we can
actually get rid of the zswap xarray, by merging it with the virtual
swap xarray, or even stop using xarrays completely if we adopt the
current swap table allocator for the virtual swap indexes.

As Nhat mentioned earlier, I suspect we'll end up not using any extra
overhead at all for the zswap-only case, or even reducing the current
overhead.
> 
> Chris

