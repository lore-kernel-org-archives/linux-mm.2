Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C373FD277EE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 16:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8326B0088; Sat, 10 Jan 2026 11:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFA86B0089; Sat, 10 Jan 2026 11:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903466B008A; Sat, 10 Jan 2026 11:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF3F6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 11:30:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0292F1AC31A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 16:30:34 +0000 (UTC)
X-FDA: 84316592430.10.E24FE9D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD2411C000D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 16:30:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YiED6Shy;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768062633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKdNQinLdfkQ5ZjIhnHbKnawUimweEFVSRdn+zzu4Ck=;
	b=3C16GFIWuD5f0fCmOtuw6uyZ0T83Jgmq99vn+tZFOV+ZhBExiUkShimiUJ9jaRUhMxDgGT
	ITdU3M4Ayzz4sSgV5qmiXkoIoZ7UaGF+uA3kFRikn1xnYoKHp+s9g7hJB0cNxdGzeoWf6z
	7lqKsTEVUCBYOzZoocATXNHx9luh2Qk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YiED6Shy;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768062633; a=rsa-sha256;
	cv=none;
	b=Bc4BOa51Kl3sGGISCXZ5IrsBvfU4VeUI59W50WX8YI9RlvYyUyxoxbUrFzOiYHLdDDGCPF
	FMfhP9p8mXG2b3xJZsMiVwTPtdCKCn2l3epZpn1KrFjGCmtBAYZiMloqnCBwxE/KgYE7es
	REPmLPeTBtCzh/l95vgDGGiPI5a7DQM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UKdNQinLdfkQ5ZjIhnHbKnawUimweEFVSRdn+zzu4Ck=; b=YiED6ShyrW/Jomgy26B8DzLXHP
	E7TYHMotPXdP8MCQ32/eMItOuyzLZhWnTnn/PxvUsiVVjr7Fnzi4tmKNcJ3lfSRuAeY0IosQShC2g
	+tYAncMiSoMUGVg2Shm+JRv4YOdYKQDcMLx/CBmrOyD3G4Bl7TJLdSabaa07LXYYPVWku2RmfDac7
	+nERb8LxtuajjysfONvYqXcnwPaN/+BB9MNrBKsbUVBpH4vil0kaejDgJai5PJRMo7QfpTYDYDZZk
	BwhKhknhJrntXyvk0gUBdKFZ/poaHj+Z73UAbndNVaeUZmr0YV+scrOFAKsqoSyYo4xBZqyIkrE1V
	vRFK8jQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vebrA-00000000pLa-1too;
	Sat, 10 Jan 2026 16:30:28 +0000
Date: Sat, 10 Jan 2026 16:30:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bernd Schubert <bernd@bsbernd.com>, Jan Kara <jack@suse.cz>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: __folio_end_writeback() lockdep issue
Message-ID: <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
X-Rspamd-Queue-Id: DD2411C000D
X-Stat-Signature: fwphm7zi73u3jfdfkrwfyrjdx9ogr89j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768062632-697358
X-HE-Meta: U2FsdGVkX180N46CD2QC8lPafBSN6NXUCmWxwHuca7VRKVvjn2+0eJ1dJzLvGdcbrYlFhwcGNWZSHEOEt/bgLkeMC6+a72oWqhUys4raSL0+Fy+O753ediTMfmJ/FI49TQ6hf2fhu84eJg6tPLPH7bkag+7omQkiELT64IBNpQCmnO4MjLzybNyJeZ08CDNkM9TwqA/N4pxsJZl6xIRmxJGY+n3chl6qXkxz23RibdQUHSNp/DmWJLBacGYtZ0iJgGGhI5AIPIhN+oDKL1wyoP1stfz2l3TKu9giG7t/NZ65ZNiS8H4sFlYbDcdjBQ6z1gc/U5lyZcZsqSOa7E99NTuurfXNzoZYl2M5Rg8hI62qFUADyOWy58K7AvHk2MnOyCstK6WBAba9hpKoyKCXSEItwW+Ug8EiVNItsZSF+lwxeo0TgKKjNsVAagdARJQW5OlLRmz3ObEKvU3rDDIpgMNNANiH5C1TG4s9w5YwYjVVSmoWJ8X48BkvsolsCnUgA7n07okWtn+bUpUyrMTnrbnKige4G5L14dwe0QtzblXldpaMWwYvWpOrXfkGAo+2Q9Ptgv1YwKarr69wxZzk4rXIRnxgk4FNh8F7f7YStr/NLqXiRsKvU9jFrJSO7eU45GeUVqY0zMT+RLGbMFICtxBkAFoLgCd81KxTLW2y89Sj6iyoDoXHM90XhwMfvf2UPj3R0xXiak4VEUAW1MXAhp7lZQ8Xibg1VO1V6GLn/VLxxUMjDe+WXrWD81PcHb0yU0R/BcdSWf2jPvs3rpS3j1va+iHKdaUi9kDaXmghWPynjPikp/CzkmAYbGlTY/1AQYL8k3Jr696t+eAZXLHcxtUVaXOM/Fe4S2R61+r36VI+lQLSb0LT2UlkBwx2dDDG3pnNhgcOyOjMR0bMtTcAC0CzamPSHwv55gFp72xpjo5sLsepf69800klszZIVObY+55C4gP7bRV591cz3lj
 nXU5OZTG
 CQqYnjR50QE0Kil6O31FvE1zD1OyEQ8lQbhNOn0ZflEpcaU3mVdPKPzbtVgXCSBezSSVRSGEsWsk0JU0gEyX/TNr4ltnHg+vFcazbMAEqmzhgg0yO5pPUZNb54xmxaLQx88CdQSBlZoiiW9RyhOEc3nTa//pOlzKmft0kFcXvnNx598+1gCaLFWWaaV1yppHUz8u6rRKbcOFkiDExbg75O0j1Rc6E7UCP3P0BIGJdGW2ss7RIySMkIymyx9R8wCUxNmaMAlqojPekJfYZSjcs1b9lD/uN2NjcIJYMOxjx5IsBiWsaINTZIe2QH7KMWtHYd+0KQH6eH0eukiN4p7NC9Tv0X/GiD7AHtbC8l8vmUU161jbS0RrGKUTY/Znl8XL+fOTNBcFzz3A8/y0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
> [  872.499480]  Possible interrupt unsafe locking scenario:
> [  872.499480] 
> [  872.500326]        CPU0                    CPU1
> [  872.500906]        ----                    ----
> [  872.501464]   lock(&p->sequence);
> [  872.501923]                                local_irq_disable();
> [  872.502615]                                lock(&xa->xa_lock#4);
> [  872.503327]                                lock(&p->sequence);
> [  872.504116]   <Interrupt>
> [  872.504513]     lock(&xa->xa_lock#4);
> 
> 
> Which is introduced by commit 2841808f35ee for all file systems. 
> The should be rather generic - I shouldn't be the only one seeing
> it?

Oh wow, 2841808f35ee has a very confusing commit message.  It implies
that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
all filesystems do use this code path and therefore the flag can be
removed.  And that matches the code change.

So you should be able to reproduce this problem with commit 494d2f508883
as well?

That tells me that this is something fuse-specific.  Other filesystems
aren't seeing this.  Wonder why ...

__wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
that spot since 2015 or earlier.  

The sequence lock itself is taken inside fprop_new_period() called from
writeout_period() which has been there since 2012, so that's not it.

Looking at fprop_new_period() is more interesting.  Commit a91befde3503
removed an earlier call to local_irq_save().  It was then replaced with
preempt_disable() in 9458e0a78c45 but maybe removing it was just
erroneous?

Anyway, that was 2022, so it doesn't answer "why is this only showing up
now and only for fuse?"  But maybe replacing the preempt-disable with
irq-disable in fprop_new_period() is the right solution, regardless.

> So this?
> 
> mm: fix HARDIRQ-safe -> HARDIRQ-unsafe lock order in __folio_end_writeback()
> 
> __wb_writeout_add() is called while holding xa_lock (HARDIRQ-safe),
> but it eventually calls fprop_fraction_percpu() which acquires
> p->sequence (HARDIRQ-unsafe via seqcount), creating a lock ordering
> violation.
> 
> Call trace:
>   __folio_end_writeback()
>     xa_lock_irqsave(&mapping->i_pages)     <- HARDIRQ-safe
>       __wb_writeout_add()
>         wb_domain_writeout_add()
>           __fprop_add_percpu_max()
>             fprop_fraction_percpu()
>               read_seqcount_begin(&p->sequence)  <- HARDIRQ-unsafe
> 
> Possible deadlock scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(p->sequence)
>                                local_irq_disable()
>                                lock(xa_lock)
>                                lock(p->sequence)
>   <hardirq>
>     lock(xa_lock)
> 
>                    *** DEADLOCK ***
> 
> Fix by moving __wb_writeout_add() outside the xa_lock critical section.
> It only accesses percpu counters and global writeback domain structures,
> none of which require xa_lock protection.
> 
> Fixes: 2841808f35ee ("mm: remove BDI_CAP_WRITEBACK_ACCT")
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index ccdeb0e84d39..ab83e3cbbf94 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2994,7 +2994,6 @@ bool __folio_end_writeback(struct folio *folio)
>  
>                 wb = inode_to_wb(inode);
>                 wb_stat_mod(wb, WB_WRITEBACK, -nr);
> -               __wb_writeout_add(wb, nr);
>                 if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
>                         wb_inode_writeback_end(wb);
>                         if (mapping->host)
> @@ -3002,6 +3001,7 @@ bool __folio_end_writeback(struct folio *folio)
>                 }
>  
>                 xa_unlock_irqrestore(&mapping->i_pages, flags);
> +               __wb_writeout_add(wb, nr);
>         } else {
>                 ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
>         }
> 
> 
> 
> Thanks,
> Bernd
> 
> 
> 

