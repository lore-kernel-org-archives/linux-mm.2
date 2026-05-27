Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DA4CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D7C6B0005; Wed, 27 May 2026 04:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834776B008A; Wed, 27 May 2026 04:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74AC76B008C; Wed, 27 May 2026 04:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6477B6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:37:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC5691C1B99
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:37:25 +0000 (UTC)
X-FDA: 84812545650.14.4B13D23
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id E90871C0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:37:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=phGCpgCw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eraFftGzlHIcWWtP0S7CHyvFuivRxOgkzUrYiSBlxFU=;
	b=WH7xmv3+aMQHFXEzW95NNKNDv9tKrq9nkvoUICNTZHKehOk18XgMHCGynvWxD6nEQq8zT0
	tz/mURtrmZpckpI0tdGYxqQEpXXO5+ocvnQrOqmonEEdNTidL9rD6v7APZgk/PfSCKdRcd
	Ckk6u4c6iAXs+8jFvD4FdlUxiNLgunA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=phGCpgCw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871044; a=rsa-sha256;
	cv=none;
	b=owTveke8V0eQMJDaCnhJMkSfEwT2SQQwJyZ6c3M9/fpIh/EzbJz/QCKDQx3Nbk3i2+roNV
	kQlVhps4+w9bkrVPiIu2NAbHdlClubfO+piIApGW7IL+IVvZDknXJL8KupvBgAEpwEKOXH
	jOx/61CCSte94Vjkmq9E/nCIp8DW23U=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-44e1860558fso7245947f8f.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 01:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779871042; x=1780475842; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eraFftGzlHIcWWtP0S7CHyvFuivRxOgkzUrYiSBlxFU=;
        b=phGCpgCw5Z/gSbjCjBUmS0FV+i1ugjPw2H/SMPzHFdOQKHidg+ZumiNmz2vARoyy+B
         rypgwPzKoY3SYVTVvBBwlHCJsdGbTeS7anpfWJQAsLjYDoY98IWnaLaK73gx4Pa1OQiC
         tsPXl1FoDIMlXkcI6jEkvG3L9eulNBjUJ9QA+8ry1V06/ZoaKoR2hooGYf+8lkX5YVKq
         xahaDVWroQ9DUI2xX6ihuNze7+i20RXQgSci12cqGxAqTf4QJSDJAf5f2LbmXQtI19F/
         YrwF5eEng0TejAGKInuLIC6tqwMjpocOpZ9x2PHw2QHmZ+HBFwkFbAXTzGZ39MmG+wrF
         7YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871042; x=1780475842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eraFftGzlHIcWWtP0S7CHyvFuivRxOgkzUrYiSBlxFU=;
        b=YgHmlWI8EK1hlrc43Ck2lb/61BhAuq1ArJWapS80MmFctALFcidSE4rN+IopBraBep
         WFg3EJ9H2r8X/PMm5OcistY24VaCAamE4rNqR+J8KbCwztokuIvctoGakDuTcj0t3eEe
         VJO9eDRuR74z3fh96qiJXeuKTH9kxjWCYUraDTyWknrq21dV5NNBDD5V3LQID52vncwS
         Am1dMJK9FXEEO/9d1KFo8NoWj0+AJ3YkThfjDQM+In1xDpTx6KqxTXHFf1OSQDNRk4Gr
         JjuisxdTAfkVcuKAPUGQgiw2rw4JWVf9ymmHbY+aFbOa/t2B2sL9q7Oc3MCWmWNyay1N
         zwkQ==
X-Forwarded-Encrypted: i=1; AFNElJ8rV89CsUgKn31RCbraH1dJFcmasw6jBFiEkq02C3DyxAOA0UUZ6tLpsZVOzWaU9WgCna9xPuvyMg==@kvack.org
X-Gm-Message-State: AOJu0YyGQzB15HUheII6MM6qyYuEihrgOnn+FdCKWWviSUShZxVecg2Y
	FsPN73kxaUOcKJ8usJELKUaEwvd25t9+3gLrCL5y4FSurkS5N7XkjjVI
X-Gm-Gg: Acq92OHLioxkufq92RDuGCcF70Yyy+M9PYwTyqd1NRevOV1Ei1Za4Uq6N7VyKcu1WhP
	QYAH/0Gfvj9AjGJOAcnYb0vZTpZU+S1VbBmnicNMb3bbkEeG6r5mRGHOCAnzuFUBgtsfIFcC7QS
	uGew/WX5NvTSNcJN8VnS1uO5+omIjDWAK1KkUDml2YsWPWH388Mpx7rhW2t5wuG+3hdamMi+2ZZ
	TgeCovhkUlrlRC07e1QRKkJ89saSvLh7kGxPN98fMWdY7nojKVUbrY+f7XoDr2faAcAImS83az3
	pwXYjZGAVeFT3g8X/wk/1UTjKRnr/vw6uJilVBuN9cYiVRa3vjOcLFDFmp9q0Y+q+gIBITHe57c
	4KpfWOCGqYvXqs2im2JjDMteHYMB8G+Cn484VBDrWyeTDABit8Xxvhx4981JYpo2/07Sin4B2AC
	UV+S85hCg5/9M9pHOtoT9nGdPirOX+dOdoq79etCoVqWHzzLZID34scyCPU/ykHoNw
X-Received: by 2002:a05:6000:1ac7:b0:451:bbe4:b48e with SMTP id ffacd0b85a97d-45eb36b025dmr37371799f8f.5.1779871042009;
        Wed, 27 May 2026 01:37:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5c2323sm4483703f8f.34.2026.05.27.01.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 01:37:21 -0700 (PDT)
Date: Wed, 27 May 2026 09:37:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <20260527093720.1261e697@pumpkin>
In-Reply-To: <ahWwYIOycuWZnETn@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-2-cb3045bef2d8@kernel.org>
	<20260520140657.2b5b5f3b@pumpkin>
	<ahWwYIOycuWZnETn@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E90871C0005
X-Stat-Signature: 55m45ewo5ro1jjnuf1m1qy49tydutncd
X-Rspam-User: 
X-HE-Tag: 1779871043-916580
X-HE-Meta: U2FsdGVkX1/hJuneeWrUZAADIjx3kNYQhidFXpYYKPrVpEf3xbr12ti+w4bofG6U4D/b+GufmUH7YX9+6ka06S59coek7a4aVJku4DpY/YEIiNtuJG+J/9BlPN3ZHQhdRB5sWwUcCjEOpVPS6IQOIVg8YJT0TAhPjJzVWCv51QJfdTBS7hDc32GepleBHpZyBNpcckhrievAO5l9F78op7QxYgOPOZAszoytCdfYHS6Im49he56g66C9XmA2Uya459HX5iAZYPnc+jxt/rHrROTy9B0ijssoafD/FRoHZl1TAC4awtQ6RCveFhwcBax5PEO2fNfbsdUMNVsVSC3zY4Fgn8IyHThgusRR/sxaz3zMR8o4uP0nlCffhnflVawdfI5ZBnKDc8EImfScDxpJSP4G2BJL8FeRaHfeAba3enSW28RfrS5V9YK/zxxpX6TMNgoVPtDsDj2euXCSwszmZkybLQBuBBuAhB1GLIYbVzasQV5oJkzMSnbYkhBeoDXPkU0sLnDF+Xk2eMDoDbHIvmlrVQbFH9H1x3ubRHD/VMLYkA8saJgJ6RpFbvIwZiyLrQyi/pwiC4uBHKOTQLefAqGi5zyho6xzEMU6o5irxrnWaPZFHKCkgpbMXaEasiXVpekSYPYHs4EH83Hwn0vnJfdpzeLuq4pgSTinQAbdfNhEMOm3JU+xe4i+lCr+KtvnHQemSAg0KzLd3DYNQYuAUHaUzDeG9umpR+vZhc1LuV6M66C8dg2Eh/56cO3MVudtIEZEBTNngaEV5EbjtzxU8pmNn7nQ15HlvJWRe+09RWkbYnQ9UpUX0ae5VfHgyJ5J3I/oyTk9770/Wck6mAqiXRS6aIzPzIu9KiFwBDiw0l0EPr7GfphASk86gGuFQklzcHK5WF4nb1I+1Kclug/0K+/+AxwhmBrLk4lZHObaPY7hThysPcJCM0GIZ6KlXXf+n6OOkVNw/d+EoDYmxLv
 gx0OiG9q
 VxRsAgDR1VDKIIu8WOqeVnJfG4MvHxNDWmEEQoGod6Uj8DOSkf9cYcBYOW9AID5jETR2yv9uFKcZf25ONh5HLjNfKp+cZ2zxBfli/lK1EiEFkFbgZpNP/+Fz8PGneErHQxrzrw/M/RBXJQtHm4iYnGImRw4xK0iqHWOVIATxLnE/Wx70N3Uv5QGXil2dlOyGlBWp9ubHh+fmVmOyPnINlO7Yg6HpZusIcQNdsjAEW5CIS426ppTjG/dl7IW+qZXAPZZcvOnAO7UX11OkSRmI++4d+2ESGCkvoCALBjk8s8ze7UtnalaRLhSp4HBAwsM2apUW6qyFdNXqNkqlm+6VX/1WpanNQ6ujF8ttC97dYPTzhxLEU2twYodD9Z2UQ6ORFrKryeowVQRPPwF2Gr+cntkk4r6MwYqFKrvg2jBUdqbQ8N4jDaEPQUqmSZa1uDq3cSodjTiETH57zBfOvjSbLGOeQv8k+3qS/9G/LS1TKzUrzmB2gL+eQ+B3MRzeLrvm4iJEdr9XyQDhcGpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 17:38:24 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> > On Wed, 20 May 2026 11:17:52 +0300
> > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> >   
> > > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > > as a scratch area for selection of the best algorithm.  
> > 
> > Should this code really be using a 4k buffer rather than a PAGE_SIZE one?  
> 
> Why?

Why a PAGE_SIZE buffer at all?
The real data will either be file-system block/fragment or raid stripe sized.
Neither is directly related to the memory system page size.

This actually a valid question for pretty much all of these changes.

Most architectures use 4k pages (probably because 3-level page tables
fit nicely into a 32bit word and it gave a reasonable number of pages
for 1980s systems) but some use much larger pages; I think 64k and 256k
both get used.
(IIRC m68k hardware uses 2k pages, but Linux uses them in pairs.)
Larger pages reduce allocation costs, TLB pressure and memory overhead.
But can waste memory especially for mmap() of small files.

Most of these functions just want 'a reasonable sized buffer'.
Possibly requesting whole pages was originally cheaper.
But I also suspect people have written PAGE_SIZE as a name for 4096.
(Much the same as they forget that some systems have 256 byte cache lines.)

For these changes I think I'd at least add a note in the commit message
when nothing external relies in the size of the buffer and that it could
be changed to 4k.

-- David


>  
> > -- David
> >   
> > > 
> > > For such large allocations kmalloc() would fall back to alloc_pages() but
> > > still kmalloc() is a better API as it does not require unnecessary
> > > castings and may provide more debugging possibilities.
> > > 
> > > Replace __get_free_pages() call with kmalloc().
> > > 
> > > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  lib/raid6/algos.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > > index 799e0e5eac26..89e627c62e30 100644
> > > --- a/lib/raid6/algos.c
> > > +++ b/lib/raid6/algos.c
> > > @@ -12,6 +12,7 @@
> > >   */
> > >  
> > >  #include <linux/raid/pq.h>
> > > +#include <linux/slab.h>
> > >  #ifndef __KERNEL__
> > >  #include <sys/mman.h>
> > >  #include <stdio.h>
> > > @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> > >  #endif
> > >  
> > >  #define RAID6_TEST_DISKS	8
> > > -#define RAID6_TEST_DISKS_ORDER	3
> > >  
> > >  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
> > >  {
> > > @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
> > >  	int i, cycle;
> > >  
> > >  	/* prepare the buffer and fill it circularly with gfmul table */
> > > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > > +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> > >  	if (!disk_ptr) {
> > >  		pr_err("raid6: Yikes!  No memory available.\n");
> > >  		return -ENOMEM;
> > > @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
> > >  	/* select raid recover functions */
> > >  	rec_best = raid6_choose_recov();
> > >  
> > > -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> > > +	kfree(disk_ptr);
> > >  
> > >  	return gen_best && rec_best ? 0 : -EINVAL;
> > >  }
> > >   
> > 
> >   
> 


