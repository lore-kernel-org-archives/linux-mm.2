Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB82CC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536DD6B0089; Mon, 28 Jul 2025 05:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514846B0092; Mon, 28 Jul 2025 05:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424686B0093; Mon, 28 Jul 2025 05:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30C7D6B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:16:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D13D612D8E4
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:16:52 +0000 (UTC)
X-FDA: 83713118664.21.28DA392
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 60F8C4000F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:16:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRjYDqIN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ER9dxc2P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRjYDqIN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ER9dxc2P;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753694210; a=rsa-sha256;
	cv=none;
	b=tSYW5U8+XpDs3/yLcYWlrM0vNVbH9ds3zi+ACQCSyV7OYiFUlbjBwhOAe5Tio/LUWf95u6
	1DTIeSz2iFUnOs18C+b2Pm/SytRIZAqX4IbshfjCkJ6r/tZrIifI6KC22gMKZrqFFzwU6r
	tvtFdxcl2VtdsQV+HOjncSXiHmpR7+s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRjYDqIN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ER9dxc2P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dRjYDqIN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ER9dxc2P;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753694210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYLUO9SCf1ieYOdxJxUxSy5fSnkL9djEjNOnTob6B2I=;
	b=zygJOsKtUg+eVDUQsxhFVARGke7tAFj0m1gUszlWA7tUGm4wnaSxisvohTTdvnL34bf6Bn
	VfK3iM1gOmnuTOQxi1wO2lcpLmboVuim8OHqT5sBHMsS9Q0YSoj08uK8PwjWzKbxKSXSTM
	8PNiefkEE0uvuukIm4dZQ82K5FB2ls0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 721281F444;
	Mon, 28 Jul 2025 09:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753694208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYLUO9SCf1ieYOdxJxUxSy5fSnkL9djEjNOnTob6B2I=;
	b=dRjYDqINkB8IfY5WERe3po7VH8WaAY55O4GX3/ntxX8DEtV3gavcVgkbDjZptHr3xyQevy
	pSm6F+ozqD9RHcYpp5DquFwAsnjmUraUVH9sHHUCyt1fRtR5gs2eb52d+WKYa9tI0GpvT7
	atZlMDhhBML5fh0dA+CCwGbxnCLKQ0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753694208;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYLUO9SCf1ieYOdxJxUxSy5fSnkL9djEjNOnTob6B2I=;
	b=ER9dxc2PXA706q2avaItvdjrQFqUQGJQd2IprxgVNlwL4UsB0q2juT07TkOEGBOOy1CTYo
	qtvkf4QAWk5BV0Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753694208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYLUO9SCf1ieYOdxJxUxSy5fSnkL9djEjNOnTob6B2I=;
	b=dRjYDqINkB8IfY5WERe3po7VH8WaAY55O4GX3/ntxX8DEtV3gavcVgkbDjZptHr3xyQevy
	pSm6F+ozqD9RHcYpp5DquFwAsnjmUraUVH9sHHUCyt1fRtR5gs2eb52d+WKYa9tI0GpvT7
	atZlMDhhBML5fh0dA+CCwGbxnCLKQ0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753694208;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wYLUO9SCf1ieYOdxJxUxSy5fSnkL9djEjNOnTob6B2I=;
	b=ER9dxc2PXA706q2avaItvdjrQFqUQGJQd2IprxgVNlwL4UsB0q2juT07TkOEGBOOy1CTYo
	qtvkf4QAWk5BV0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 684E41368A;
	Mon, 28 Jul 2025 09:16:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cSxyGQBAh2hSKgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 28 Jul 2025 09:16:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11615A09BE; Mon, 28 Jul 2025 11:16:40 +0200 (CEST)
Date: Mon, 28 Jul 2025 11:16:40 +0200
From: Jan Kara <jack@suse.cz>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH] mm: consider disabling readahead if there are signs of
 thrashing
Message-ID: <khtydy2lpwip3cysfjiw7sa7effaagpx7tcbvgopqhsdb2h3fc@4xveh6pjxuoq>
References: <20250710195232.124790-1-roman.gushchin@linux.dev>
 <at4ojyziprhhktjgtfmuyzrqwfmomnly6fubkvmbtxkdnx6hpb@5nldc3vipwny>
 <875xffsxj4.fsf@linux.dev>
 <87jz3vdf9e.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz3vdf9e.fsf@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60F8C4000F
X-Stat-Signature: 5d9rgmzyktcp6uheycq97646t3dyr89h
X-Rspam-User: 
X-HE-Tag: 1753694210-290787
X-HE-Meta: U2FsdGVkX1+qJY7Ga28O9IUAAM2DZZ2v8bWoIqa4X8XDk43XZClrbxu4zjuZmUaa9Y/ODbMB/lSToQYw8rvSxK3icFNuDrAEXywNArF7DV4PCTPP4L+MZcQK0zQCBbR4F0aTXgH6aWx6DXBbJ6EtdzGaBI6gWxI7N4VCTk8+mpcPmJVlogtfvQByxYPDLlk4YjOyhwdqORZXV7YAbiTvYuLOp68pRJlkxhFmz5cBZUwMT/QJIGh7rs17N2VCm83Ef9cO2ZkGANq3vBL4qyzYkaDYHtkzuK16G7QiUnbkLPAR59M9nkQ6eBJqIQ3xnbfM32zqL6ELr5UFK/mObDFBB8pImoIa28kaq9xzruktRHgyMwBhkd4KjO8CzzQGTKGBefSljCv9W5K6x0EI+zqJeThcyuN/weCcbQH/wAPeGJVPUP505hDS9O3xDC2x8IzDuyrQgX4ubMluQR4JHq5rQdHgYvYRQvTaYW+VBeN7Sx1d+vqt0K5d9la2ptcp7r3Rh+sVCTirzMGQtzLawgRvLt3eHmtUpNleftkcj4sG0geV6LA3vsCiIzSVQHtxO3WIP6ZEYB6hyOTabMqo4tIUS4C70kwm6wOFSa1pJeTfJTDH2LAUFbfttuWqpUVNpZ3yYrY4YyzO8+to2lr63DQLQcH7q7jptXaZ6d+2FInEmqVi+5BYmy3/hdBpzbxLuieb9JbBIQUF/L0VCxOb/HiwtbdGV0qWrwnenFwBdXv1HsdT4BneoCjshCoKOoOh40peIjF/HTYSjJ8iMvnQK2sDqCz012zWm9JykqmyXb0TA0gI8PD2bWpSjg7q4Z4HLCHUrzDkbmUA3U2whA4Xs+Vc+RLGIor6oQT47D3ANsjZSevcNY8YXjTSWUDDZDOWyRzRkxHk2noHgYIcNqIe8jgaltQyOnZ9P6Gjar8XsuYFUoufaa3RFrsE9weqiierOtjJkkNmeXZTCvseN7DZpWY
 1S+AcM0O
 LYNcquUDo8z2z1OuJS0dAbULkNBt7vrKdICRJmourHArjU5pBlFjCwkH+0pwnVVHxW1v7Z8KurMuxSZW5+tn0E/AumRLWXAtebZMvljjO7j/QnDbogKk2QErOKD6tI4pglzer13bAfWi2BUuNPoSAS+U8TZjYweXJ6e/SFDQSFZApmd/++uEFqCrJDBS6tF1PvoA0QXguKZhEW1tJq2hC7elDejLWqYrhK+M9Rh+N1gkF/PzPzC2D/9XKjlJ9vEl4juQklcM7NIvYeCcHdx58a9OMasdyI4nGh1ktzb6RPbEgkQXmgG5NWHQq0siFUslenCzmfSQsZzqUtZxOwWodcL1pD7a5+4Ss+Qwnj9ZVwZMmXzVMPAzEPDNxsQ9uG9GRX7ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 25-07-25 16:25:49, Roman Gushchin wrote:
> Roman Gushchin <roman.gushchin@linux.dev> writes:
> > Jan Kara <jack@suse.cz> writes:
> >> On Thu 10-07-25 12:52:32, Roman Gushchin wrote:
> >>> We've noticed in production that under a very heavy memory pressure
> >>> the readahead behavior becomes unstable causing spikes in memory
> >>> pressure and CPU contention on zone locks.
> >>> 
> >>> The current mmap_miss heuristics considers minor pagefaults as a
> >>> good reason to decrease mmap_miss and conditionally start async
> >>> readahead. This creates a vicious cycle: asynchronous readahead
> >>> loads more pages, which in turn causes more minor pagefaults.
> >>> This problem is especially pronounced when multiple threads of
> >>> an application fault on consecutive pages of an evicted executable,
> >>> aggressively lowering the mmap_miss counter and preventing readahead
> >>> from being disabled.
> >>
> >> I think you're talking about filemap_map_pages() logic of handling
> >> mmap_miss. It would be nice to mention it in the changelog. There's one
> >> thing that doesn't quite make sense to me: When there's memory pressure,
> >> I'd expect the pages to be reclaimed from memory and not just unmapped. 
> >> Also given your solution uses !uptodate folios suggests the pages were
> >> actually fully reclaimed and the problem really is that filemap_map_pages()
> >> treats as minor page fault (i.e., cache hit) what is in fact a major page
> >> fault (i.e., cache miss)?
> >>
> >> Actually, now that I digged deeper I've remembered that based on Liu
> >> Shixin's report
> >> (https://lore.kernel.org/all/20240201100835.1626685-1-liushixin2@huawei.com/)
> >> which sounds a lot like what you're reporting, we have eventually merged his
> >> fixes (ended up as commits 0fd44ab213bc ("mm/readahead: break read-ahead
> >> loop if filemap_add_folio return -ENOMEM"), 5c46d5319bde ("mm/filemap:
> >> don't decrease mmap_miss when folio has workingset flag")). Did you test a
> >> kernel with these fixes (6.10 or later)? In particular after these fixes
> >> the !folio_test_workingset() check in filemap_map_folio_range() and
> >> filemap_map_order0_folio() should make sure we don't decrease mmap_miss
> >> when faulting fresh pages. Or was in your case page evicted so long ago
> >> that workingset bit is already clear?
> >>
> >> Once we better understand the situation, let me also mention that I have
> >> two patches which I originally proposed to fix Liu's problems. They didn't
> >> quite fix them so his patches got merged in the end but the problems
> >> described there are still somewhat valid:
> >
> > Ok, I got a better understanding of the situation now. Basically we have
> > a multi-threaded application which is under very heavy memory pressure.
> > I multiple threads are faulting simultaneously into the same page,
> > do_sync_mmap_readahead() can be called multiple times for the same page.
> > This creates a negative pressure on the mmap_miss counter, which can't be
> > matched by do_sync_mmap_readahead(), which is be called only once
> > for every page. This basically keeps the readahead on, despite the heavy
> > memory pressure.
> >
> > The following patch solves the problem, at least in my test scenario.
> > Wdyt?
> 
> Actually, a better version is below. We don't have to avoid the actual
> readahead, just not decrease mmap_miss if the page is locked.
> 
> --
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0d0369fb5fa1..1756690dd275 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3323,9 +3323,15 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>         if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>                 return fpin;
>  
> -       mmap_miss = READ_ONCE(ra->mmap_miss);
> -       if (mmap_miss)
> -               WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +       /* If folio is locked, we're likely racing against another fault,
> +        * don't decrease the mmap_miss counter to avoid decreasing it
> +        * multiple times for the same page and break the balance.
> +        */
> +       if (likely(!folio_test_locked(folio))) {

I like this, although even more understandable to me would be to have

	  if (likely(folio_test_uptodate(folio)))

which should be more or less equivalent for your situation but would better
express, whether this is indeed a cache hit or not. But I can live with
either variant.

								Honza

> +               mmap_miss = READ_ONCE(ra->mmap_miss);
> +               if (mmap_miss)
> +                       WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +       }
>  
>         if (folio_test_readahead(folio)) {
>                 fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

