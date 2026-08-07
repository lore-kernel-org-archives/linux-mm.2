Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B469C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA766B007B; Fri,  7 Aug 2026 05:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A12D6B0088; Fri,  7 Aug 2026 05:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEE46B0092; Fri,  7 Aug 2026 05:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54C4F6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:11:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA09C1C0C70
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:11:17 +0000 (UTC)
X-FDA: 85073904594.07.9E1FDE5
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id E60C18000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:11:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iXtfxaG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786093876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLWWlERU4EyhgRGntEHaWI0+q0HSVagA2adXFhHKiXA=;
	b=UJDHv9SXF2NiVEX/Tq1vtzlfnJXCQsXt1B0W2QXRIFVZqwJWrHqVUsE2oC5b6bElOTZ35V
	QGokyeeG+SVct3N96Yexp5qqi1TEGphplcUpJSzgzDUkISqqcadSyE2QNW3EnESm0xeipp
	lzMY6DQu1eyhc/If31kusyHN3e7HQhc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iXtfxaG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786093876;
	b=BBDvhkLkmPLr8QJGtpIvXDb6xYXobA5uA9BDHC8JUMdDvhjyx+mNKTfdtAsOLx9GzOluBL
	GwhwyUy5R+XIaY812ZB+hcpZKc7XjkGriUplBAFoHbq3NjtdpJwN7B7d9d0Z/eQkv6lLvF
	y6quwqJpOC0CScCCzCvlxEq5hNevkfA=
Date: Fri, 7 Aug 2026 17:11:05 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786093872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RLWWlERU4EyhgRGntEHaWI0+q0HSVagA2adXFhHKiXA=;
	b=iXtfxaG2SPCY6xrbj8qSCqXXqFUt3cvmtGL/Bht220P5ajk0P8xgKUsW/IV/8e5bBIBqER
	moIJBWeaX5vXBNUzQS+oIKCqVcEnDBOGy3UgOmUxMpz6Mbhx/agnSFKB0IQVGWib+jzRja
	2D1WAGOBfr7kifZa7cJ4Er5I1Hh79BQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, chrisl@kernel.org, nphamcs@gmail.com,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	yosry@kernel.org, david@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] mm: xswap support for zswap
Message-ID: <anWhKU8NPzosQR8d@MiWiFi-R3L-srv>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
 <20260805075336.3579395-2-baoquan.he@linux.dev>
 <anNGE_FOoupPtOhj@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anNGE_FOoupPtOhj@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E60C18000A
X-Stat-Signature: fjcpcebniws1kp5hmtt1juktyqnig6dw
X-Rspam-User: 
X-HE-Tag: 1786093875-778259
X-HE-Meta: U2FsdGVkX1/DnPElFv0k/TjnfALLkScVqkG1OoGvXcWA3QDbscecYALCf+ZaRdXZPSmNeQnY8CcbYn1OlWeZwbbHpw6cr2Q6GMEPSWkEe3LMGvSXH8C1Zig3RkW1VbNOI3IuOlPlfsKZ0BJDpcjC2ymP8Tya9gIIw1IL0Fqhfgnv6pdIxahlP8gr5jzfKdi5rBryebFr+uY0JMUjGkAuj/JedcuksHJaOyUdb2zs4Dfa06ajvO6ZCoXHZt0ckr1mq3g1BriVbr8Qrlln4WRwbGWseH0kBfFhw85euKrELakdoBYSkeXNK23scObkdn5uNCTcP9w6/b2LsCzAOiLosxvMBm1WBKblYqBcoD4oHv1JnLOxlrSiN1NiIBa55t1RuVzNhh1B3WUN4lKk5SIBe31nYugN1Evpp9xKprDqrxouslmrUH1jjzynz4Rlo8EzqJJsS0U/jp/rAl2x2NlrWHMF6DKrUHQ6AEFiuqxW34IIz3EsPUZcF5YO3NGFv2lSlZg4ekZUstEwYDPuj9ruqJuUOuNZRcDYi7S86hl/zDtse0HvHhPkfCKn1qxTpKjgB/hlibV40umjiLaO4lzIm1NQgsIGABtNypJ6GNgv3oXDVlxG8YJdH68LZ+J1OBkUoXetFJqt1JOgnAkulO4R14MuxZi+RPRw42NBLC0nmI4fowX2KFFqkPL1x3VyFoa/CKqNBK5IOpYjz5DsbqPGyJ59ER4NPgQmPt83LNmN6UJToyThE+TQwF3eyeB16tEK+W8QJoR8P8qXIbq1d9tLaz5jfunWtI2WrT+27btmMeDDIOPkyl2Rqv9zKgJFv6fgM2LrK7EdFGTjLNKg/1GfreP4yl7kbmJAS1/k0LRgMh3+u7cUqHGWI/5Pfp6NNGDRtMlVPB9hbBQ5ALp3r8jYMxAslfgHPtYdhvdahMNE0o5bbYi2nIH5V3WLfdrwTSgd8qv+qbz4NuCGfOOUl+l
 pADJCOHr
 UPEsxT/S+fRsKYwxcijlj5tjaxUoBccDckoPWujyfi7iQ0E3URJ2FY/SxaQyUBM5gdBluQeg45hEEhvVtnoF9kkDCy+j2pFQ/uOmjUkHJ8MYEQ/NeuImqzaXhT7hn8Dd9TRVfJFuZug8mV4e8qleEB+5ehKoo8QCHxI9J6bKudXmiPo3dKiIUzc2B4TrS+sqWSH+yWHtLl9RdhZ+qPlX9yDlRS9CNzAVYYIwU8OoOY+yUaJMVzYTOhvLaHri7u0WnLVc5WsSyW6N0vJvUA2pBD83yOyq5gKXrR02BIeNYDqfSVL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On 08/05/26 at 10:17am, Johannes Weiner wrote:
> On Wed, Aug 05, 2026 at 03:53:24PM +0800, Baoquan He wrote:
> > From: Chris Li <chrisl@kernel.org>
> > 
> > Introduce extendable (virtual) swap device support ??? xswap.
> > 
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile, wasting swapfile
> > space.
> > 
> > An xswap device is a swapfile that only contains the swap header,
> > with the header indicating the size of the virtual swap space. There
> > is no swap data section, therefore no waste of swapfile space. Any
> > write to an xswap device will fail. To prevent accidental read or
> > write, bdev of swap_info_struct is set to NULL. Xswap devices set
> > the SSD flag because there is no rotational disk access when using
> > zswap.
> > 
> > Zswap writeback is disabled if all swapfiles in the system are
> > xswap devices (tracked via nr_real_swapfiles).
> > 
> > How to create an xswap device:
> >   touch swap.1G
> >   truncate -s 1G swap.1G
> >   mkswap swap.1G
> >   dd if=swap.1G of=xswap.1G bs=4096 count=1
> >   # xswap.1G is 4K on disk but reports 1G capacity
> >   swapon xswap.1G
> 
> Sigh.
> 
> Why does the user have to go through this dance?
> 
> Why does the user have to decide in advance what size the space needs
> to be?
> 
> You point out no inherent limit to how much can be compressed, so
> there is no reason to make userspace decide on an arbitrary one.
> 
> There is no reason to tie an address space that can be managed
> transparently inside the kernel to TWO named files on disk.

Thanks for looking into this.

The file-based creation dance is there only because this is RFC —
I wanted to reuse the existing swapon path so the core grow/shrink
machinery could be measured and tested without also designing a new
userspace interface. I agree it's not the right final interface.

The direction I'm thinking for the next revision:

- Drop the file requirement entirely.  An xswap device has no backing
  store, so there is no reason it needs a file.

- Use totalram_pages as the initial per-device size.  Chris suggested
  this, and it's a natural bound: if all anonymous memory is swapped
  out, that is the maximum number of swap entries zswap will ever need,
  assuming a reasonable compression ratio. The hard upper limit could
  be 2 times of system RAM, or the max system RAM memory hotplug can
  add to.

  Doing this because we need consider swap.tier support. A single global
  xswap device in swap.tier would mean all memcgs compress into the
  same device — there is only one swap entry namespace. With per-device
  xswap instances, swap.tier can bind different memcgs to different xswap
  devices, giving each its own swap slot namespace. Total isolation on slot
  usage, no cross-memcg interference.

   -----
   Hi Chris, Joungjun,
   Please correct me if I misunderstood the swap.tier concept and xswap
   use case in there.)
   -----

For creation, something like:

1. 
  echo $((4 * 1024 * 1024 * 1024)) > /sys/kernel/mm/xswap/create

or
2.
  even simpler, with automatic sizing:

  echo 1 > /sys/kernel/mm/xswap/enable

  (use totalram_pages as the default size.)

3. 
swapon -t xswap xswap0

(use totalram_pages as the default size.)

I'm open to other ideas.  If anyone have a preference for the interface,
I'd like to hear it.

> 
> There are plenty of past discussions on this very topic. I don't see
> the point in resubmitting the same thing under different names,
> without even a reference to previous discussions.
> 
> As a side note: if you have to add "(virtual)" after every instance of
> "extendable", then maybe "extendable" is a terrible name and you
> should just call it "virtual".

"extendable (virtual)" wasn't meant to explain one with the other.
Chris prefers "extendable", you prefer "virtual" — I put both in the
cover letter so the community could weigh in. I don't have a strong
preference to either. 

I'll address all of this in RFC v3 — drop the file requirement,
auto-size to totalram_pages (with grow/shrink for dynamic adjustment
on top), and settle the name. The goal of RFC v2 was to get the
core mechanics reviewed; I think that part is in reasonable shape,
and the interface is exactly the kind of thing I was hoping to get
feedback on.  Thanks for providing it.

Thanks
Baoquan


