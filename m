Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6323CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4566B007B; Fri, 24 Jul 2026 12:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6957F6B0092; Fri, 24 Jul 2026 12:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AABC6B0096; Fri, 24 Jul 2026 12:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 391546B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:29:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5BD81602FF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:29:47 +0000 (UTC)
X-FDA: 85024206414.02.AA9F8E7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C63D120007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:29:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hZVt3P9Q;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784910586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOZZlCJxNPr51QtdtbTR7W+DtVn2iPlfQzvwzGkEI3E=;
	b=krKAHHjPvy4nV237Wn8eeEo59FqW68V490D1g76lp5l9J6SnUUDxiZ8jmIrwDxQzBG236G
	8rlwQCfEjeDgPuDd3f3U0+tcp7Qxhug9+j/vwIMxdZkc/lUmXWq7Sopfe6M+SCJKIgWgXV
	yrfFRshw1LLATq90nlEG7V0oJNZ1xfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784910586;
	b=fIs13R6y1rFKYfEkt6B2tZm3IF3fp756vJh9M39U+E/qA4MHMErlMx7gwdZpzjdbP+qYgO
	fOurRtsIy1K3nPGQwNAsYq9vP98/aH76XA+NnZPNhcwNRf087zxhGMoC8utIK9l3RvgqCK
	8372omciK4E+aJL6KJbcALllDWWqMQ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hZVt3P9Q;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sOZZlCJxNPr51QtdtbTR7W+DtVn2iPlfQzvwzGkEI3E=; b=hZVt3P9QAnETqCWd8fAxY8nSli
	ropuX5BBnaiGoppwSfjNW8v2sVuCaYVW1UmNoII4fsAU4vP4TW8wy8lV8uRSn+fryoFN1KH7T56VH
	tplAO4DN98c1V06e9ZGoXKmIKerzz4OjvkXGUugIqd24z0VfMkIHuHcvRHIFI3tlNenHTJbyor474
	493Nra6c1gtx+cRqzqdtS/+eO1MQwdWNVFLdxWSPyf549lVtmrCxdJNJ2z//ieZHE1MV/qvxXl+dV
	Y6j4lQl6H3Qaor4gm1dywZV1ydxrLBv+Mbh4HpfAcQnWmfbDD6oNZJ/7p8NLCB0n0O48z7feGlroh
	KBpap71w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnImM-00000003ul9-3uU4;
	Fri, 24 Jul 2026 16:29:42 +0000
Date: Fri, 24 Jul 2026 17:29:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 13/14] filemap: Add support for authoritative mappings
Message-ID: <amOS9nXAJDIM5KCA@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-14-willy@infradead.org>
 <amOPh_oXhrIE44nE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOPh_oXhrIE44nE@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C63D120007
X-Stat-Signature: tk1511udmxk14te6ynn5fcz7bn7h37r7
X-Rspam-User: 
X-HE-Tag: 1784910586-133527
X-HE-Meta: U2FsdGVkX1/hBIWnT22niGE7VwHAifeN0DKdmeKjtl8lK3c7yH9FnkuxOHFAw3A/rwW6jGhAwYIfUeEouk6SbttiEuE6Zh7LteWsQsWrSeggjTb1RxVPxtC/ZGshDOpZ8OynFiN4D7mXplivsEA9mTy0YZvI3G0pZx43BSsQpjWK5WZ4pIHuaF6AeZZlMwTud7WgDtqcoPjn5wjudAQkbK+1WsueWGiI9A3YFF074AVU2wAoABGB1FhIJIZvNQH+2eh3mCMAfDAcRVRh1uIkl8mGKNUVZg790wYXy0uqL4M0pox32ml2CCv+VV8f/r+aFW35TkDUR4F5rkINABMyVMiClr9rI/TvlqhVQVvsXUb7E0x1UjJC17Q4xxpcj409W+ELB3o4JIp2khU4XXssUyClj6DanmjwBjvfJg26g+fAXoYnifN6dcjtcqblpIFhzMPThPeIL3Pk99cbmEaVn3bOgqduQUyR1npH0JKWAq1+VirT8A6IIx48shJFAeTqdnBtM4QgEMvsPlXjCSkeMTg2GAAjFO1bJWELdQ6Mq1aUHirhAhpg4dkgSPWdEvYmYD9pYN7o8c69J6lZ+a0x3CeJ9y9EBpQFFLQ7dSnLXDPcxlqFzpEX60SyCwRKIC64bSeppBUKztNz1lbAOd90Y0ESWYsPjC+/opyRyGuaYnGL/LQeLdbT7NX4MCCgPeZDsz45vhKA1//YkcdTMGAAJ7cWeiLK3nF23V7+8HfipL+YQInxAgjlu29WyHXSnLc5Qix51eOxZEft7OFdt6QW9x4YaisTkLb8CXBTD4RxtswYoTH4ExT54UD6cWsNed96FjhKONoyMqhjEVjyfE/0lB8Ha3Bk0V32OZoXxj1LLRG/MicMBe830eneAwnDsNtUKrMo/oC5uKvxN8I8oX/P8N+JLrWYsp5t+27wIU1u93To7zWrgEH2YuDHJghwkREbKXaQp1WWGU9itdz4WZ0
 jjLXclLB
 VrbJT8jRmLtRvNUZCs4DAtr0ZLWKNV2eJ9z+T/LUKf8OkTHCVzDH8Y7xZolmURbOJ3sY+SEus9o76fhR09rneasxMMDf67Xlb2PQMPppC+ljKaBLT3kMPQWF0JiMfLLPqF/6kD57pCwL+YE7LFwba/OSHJuh4I4u2qPBB5qrI4DIPFuFXtEWM/YrOVFJ6wCq+u6D2BDka44XAcINW978Ie4Mdmc+tkahMw+l6Srx3h1DEljE0DnRpu6QlrdjC9yZVw7bqwZKpLNyPbgyb9fQhC7eoz4717knpAQdQXzNPBZ0KnggmDLQf6ery7eXJOWiYQJZWC5Ysw6rNmYL+6HJwAwYA0sZZ/lOhOroH30ismnEBAtclPNXmFg1I8YRVNqO+4u4eI1JRqJo5d2Cj7NiV5rivkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 05:15:03PM +0100, Matthew Wilcox wrote:
> Sashiko review identifies only a problem identified in the previous patch.
Er, this should have been the reply to patch 12, not 13.

Sashiko review:
> --- Patch [13]: [PATCH v4 13/14] filemap: Add support for authoritative mappings ---
> commit f97ea9a8250c2693263cf2f409975e439e79ddd4
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> filemap: Add support for authoritative mappings
> 
> An authoritative mapping knows about all the folios in the mapping.
> If read() finds a missing folio, we know it's a zero region of the file
> and can call iov_iter_zero() instead of allocating and trying to read one.
> 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 26a5f18121f90..5a8cc20e624e4 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
> >  	if (!folio_batch_count(fbatch)) {
> >  		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
> >
> > +		if (mapping_is_authoritative(mapping))
> > +			return 0;
> >  		if (iocb->ki_flags & IOCB_NOIO)
> >  			return -EAGAIN;
> 
> Does this early return cause an infinite loop in filemap_splice_read()
> when reading a hole?
> 
> When an AS_AUTHORITATIVE mapping has a hole, filemap_get_pages() now
> returns 0 and leaves fbatch empty. filemap_read() was updated in this patch
> to handle an empty batch, but filemap_splice_read() appears to assume that
> a return value of 0 means progress was made.
> 
> If filemap_splice_read() receives an empty fbatch:
> 
> mm/filemap.c:filemap_splice_read() {
>         ...
>         error = filemap_get_pages(&iocb, len, &fbatch, true);
>         if (error < 0)
>                 break;
> 
>         ...
>         for (i = 0; i < folio_batch_count(&fbatch); i++) {
>                 struct folio *folio = fbatch.folios[i];
>                 // updates to *ppos and len
>         }
> 
>         folio_batch_release(&fbatch);
>     } while (len);
> 
> Since the for loop is skipped, len and *ppos remain unchanged, which
> could cause the outer do-while loop to spin indefinitely.

This is a latent footgun, I guess.  When we come to it, we can move the
code from shmem_file_splice_read() here.

