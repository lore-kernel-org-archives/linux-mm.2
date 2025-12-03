Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEA4D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39C66B002A; Wed,  3 Dec 2025 03:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F117F6B002B; Wed,  3 Dec 2025 03:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27D56B002C; Wed,  3 Dec 2025 03:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D080F6B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:37:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53EAD1A04CA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:37:13 +0000 (UTC)
X-FDA: 84177505146.01.14CE678
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id C7BFF1A000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:37:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNxlQ9EF;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764751031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxYE8UeBr+yZpsgsbYSj0jp5OruJ42SVkGftyYWINWU=;
	b=QmakxnrYRqQmuovOXdmZgF6OCyplvxwvUAjobI+u10vo2P67iE65BUwUZjCTeHSX0SHnCo
	GOqHmB33wnSeoeD8IhdJ0YGWdxTHj/KA/Hf1DTjyP2Xkeq1FuOC3QqNjqI+FaVV/Mq+TTW
	zWSpEAjTGSIsqUYuEIzxc29m8NdKKns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764751031; a=rsa-sha256;
	cv=none;
	b=G9t0+uwAk3GXoJ8dPrcqxuCcATv1c3KOEW072LfrkVjKbc1sTvlzI82GziXtOtT/4Xim1w
	yROuC5U8j664G+Rah8j2cmpj6SiShK7Jr/zYZf5OR/ltwwcwh0Qx8iJMa6PTlC82gDL1q0
	3l99icyTj3g1XTlFUPLzxp4m5YAMUxU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNxlQ9EF;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 3 Dec 2025 08:37:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764751027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UxYE8UeBr+yZpsgsbYSj0jp5OruJ42SVkGftyYWINWU=;
	b=oNxlQ9EFUkBCo+ThHwzCwWvtz1fAnbr6zht3rzIsg6Ayzy1IWHyUopGli+jZElCByenHE3
	exYkX/bZs/UDY8hYPVXpgsx+j5eFJFJWZBxOLB23GbEVSSwiFQEmvCGqw/XLuw/Az403R/
	WZyi3UQtSZZlyBmHp/3gXDKyWSrHp00=
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
Message-ID: <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7BFF1A000E
X-Stat-Signature: qc59spswpgg8son4gieynjgex1x9erad
X-HE-Tag: 1764751029-2885
X-HE-Meta: U2FsdGVkX1/KkLAH9S8lTGMHkN91TchFegPniWiWY82Luhj9KA5FlJgs7pgQZZ+qAy4LSEg0GcTpoVrfVyqg6MFPWpVDvKC3iS1GZ6/9Pu04BzxPrhn0gDOl+OpQjQ2ux/8UCydiDAqWe6H1lvPcg0xATVEW2XrPwxmbFTMJv/frrEOiFLerlHEMdplm0TgWxlyEPFyCA/d3+VQN1X9/b7MQUjDn9pQV3PiM6CLCLEHSSwWdr68NWLTn3QE8BKuRurgB7DrlY0Z9X5dN2Hrj7v6fjJz6LjK7AapP1kbGgqzUT/z08A3El5TDDFr2vuhIVHyG4A20uiNRZ7aGo+pJcPNEcwJYHnyOr6SCvtNlSffBccN2KmNOVdUh6GoFIxMWJ8J+Zp75B7/8JkRAEtFSWfs47M/PI4ltPy7viFyD1m8uVXlygVw0adwZPjXYnaW99hg+qkrcSJWbMYX93+lD88PEGjTy0WlGfvxNlI9wBf1+/43C/y/vQDikfsPEiKBWE0aOhy9H2Rq64Z+T6Eo+b01ZKbuvcbklD+Rvf8FVI8+bUrQ7/CwHkPD2TA2MIhkfjPFE7Zyc/GDWi8ZnALP0LaVfcwfgX+EPoenKyDnNIfsU8UFodzlO6sMQWpytvMiTi1S5djsWwtPKiuMOnn8n2dWJYfyZpKcXxXuNu7tadK4jm+bxgozASpbX4CEBrCb1bKxdNs/XifVITcCfG3yRXIrBWqvRb2MoyTmcT1bznCPtHBB1kWd+un1ZAy191DWivgyQKe8zSVjSPQt8UpNPIfTn2MgHqrRZOgpHNuRdqY+COTtzjY6KI0UAiivIGc6ZGajzXM/AGUOiAK/FuSJcXa/uLIw5f5I7GT6iPzABNDl8jblwASIG63+8CAYzemK8JoO7EMotixf6VEeS85WmkJqBe2wRBypBLJugRvCY6vRoJFX/QOt8c1SLcY3wa6C+PfRSJjASvINcxTMh4u9
 UG74TptW
 wJsZy8UUn6Kuml6uA9VM6woiAIe1VvXTY3vt5DXgb7y0cfxHADnm8zuNO9ppwGb3L4t29RO5IQLEyaFRnkYHrI0n9NrZSLIUNIRvewLhEEfzONEJ7djq8E0Nq1o/eSvmoeTybCT7lDAM9HGnvMJQtLU/Wyoaq/vZaebIX3Ob8Ea73tYiNcwxtTuWmpiMnj/ufea4zFaFFHORXDZLCo98NsX1hI+9aZI6BHD3+DWoEtjLT2io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile. That waste swapfile
> space.
> 
> The ghost swapfile is a swapfile that only contains the swapfile header
> for zswap. The swapfile header indicate the size of the swapfile. There
> is no swap data section in the ghost swapfile, therefore, no waste of
> swapfile space.  As such, any write to a ghost swapfile will fail. To
> prevents accidental read or write of ghost swapfile, bdev of
> swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> flag because there is no rotation disk access when using zswap.
> 
> The zswap write back has been disabled if all swapfiles in the system
> are ghost swap files.
> 
> Signed-off-by: Chris Li <chrisl@kernel.org>

I did not know which subthread to reply to at this point, so I am just
replying to the main thread. I have been trying to stay out of this for
various reasons, but I was mentioned a few times and I also think this
is getting out of hand tbh.

First of all, I want to clarify that I am not "representing" any entity
here, I am speaking as an upstream zswap maintainer. Obviously I have
Google's interests in mind, but I am not representing Google here.

Second, Chris keeps bringing up that the community picked and/or
strongly favored the swap table approach over virtual swap back in 2023.
I just want to make it absolutely clear that this was NOT my read of the
room, and I do not think that the community really made a decision or
favored any approach back then.

Third, Chris, please stop trying to force this into a company vs company
situation. You keep mentioning personal attacks, but you are making this
personal more than anyone in this thread by taking this approach.

Now with all of that out of the way, I want to try to salvage the
technical discussion here. Taking several steps back, and
oversimplifying a bit: Chris mentioned having a frontend and backend and
an optional redirection when a page is moved between swap backends. This
is conceptually the same as the virtual swap proposal.

I think the key difference here is:
- In Chris's proposal, we start with a swap entry that represents a swap
  slot in swapfile A. If we do writeback (or swap tiering), we create
  another swap entry in swapfile B, and have the first swap entry point
  to it instead of the slot in swapfile A. If we want to reuse the swap
  slot in swapfile A, we create a new swap entry that points to it.

  So we start with a swap entry that directly maps to a swap slot, and
  optionally put a redirection there to point to another swap slot for
  writeback/tiering.

  Everything is a swapfile, even zswap will need to be represented by a
  separate (ghost) swapfile.

- In the virtual swap proposal, swap entries are in a completely
  different space than swap slots. A swap entry points to an arbitrary
  swap slot (or zswap entry) from the beginning, and writeback (or
  tiering) does not change that, it only changes what is being pointed
  to.

Regarding memory overhead (assuming x86_64), Chris's proposal has 8
bytes per entry in the swap table that is used to hold both the swap
count as well as the swapcache or shadow entry. Nhat's RFC for virtual
swap had 48 bytes of overhead, but that's a PoC of a specific
implementaiton.

Disregarding any specific implementation, any space optimizations that
can be applied to the swap table (e.g. combining swap count and
swapcache in an 8 byte field) can also be applied to virtual swap. The
only *real* difference is that with virtual swap we need to store the
swap slot (or zswap entry), while for the current swap table proposal it
is implied by the index of the entry. That's an additional 8 bytes.

So I think a fully optimized implementation of virtual swap could end up
with an overhead of 16 bytes per-entry. Everything else (locks,
rcu_head, etc) can probably be optimized away by using similar
optimizations as the swap table (e.g. do locking and alloc/freeing in
batches). In fact, I think we can use the swap table as the allocator in
the virtual swap space, reusing all the locking and allocation
optimizations. The difference would be that the swap table is indexed by
the virtual swap ID rather than the swap slot index.

Another important aspect here, in the simple case the swap table does
have lower overhead than virtual swap (8 bytes vs 16 bytes). Although
the difference isn't large to begin with, I don't think it's always the
case. I think this is only true for the simple case of having a swapped
out page on a disk swapfile or in a zswap (ghost) swapfile.

Once a page is written back from zswap to disk swapfile, in the swap
table approach we'll have two swap table entries. One in the ghost
swapfile (with a redirection), and one in the disk swapfile. That's 16
bytes, equal to the overhead of virtual swap.

Now imagine a scenario where we have zswap, SSD, and HDD swapfiles with
tiering. If a page goes to zswap, then SSD, then HDD, we'll end up with
3 swap table entries for a single swapped out page. That's 24 bytes. So
the memory overhead is not really constant, it scales with the number of
tiers (as opposed to virtual swap).

Another scenario is where we have SSD and HDD swapfiles with tiering. If
a page starts in SSD and goes to HDD, we'll have to swap table entries
for it (as above). The SSD entry would be wasted (has a redirection),
but Chris mentioned that we can fix this by allocating another frontend
cluster that points at the same SSD slot. How does this fit in the
8-byte swap table entry tho? The 8-bytes can only hold the swapcache or
shadow (and swapcount), but not the swap slot. For the current
implementation, the slot is implied by the swap table index, but if we
have separate front end swap tables, then we'll also need to store the
actual slot.

We can workaround this by having different types of clusters and swap
tables, where "virtual" clusters have 16 bytes instead of 8 bytes per
entry for that, sure.. but at that point we're at significantly more
complexity to end up where virtual swap would have put us.

Chris, Johannes, Nhat -- please correct me if I am wrong here or if I
missed something. I think the current swap table work by Kairui is
great, and we can reuse it for virtual swap (as I mentioned above). But
I don't think forcing everything to use a swapfile and extending swap
tables to support indirections and frontend/backend split is the way to
go (for the reasons described above).

