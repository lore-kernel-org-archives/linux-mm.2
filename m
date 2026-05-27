Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23C6CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA606B00A2; Wed, 27 May 2026 07:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A556B00A5; Wed, 27 May 2026 07:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019206B00A7; Wed, 27 May 2026 07:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5A5E6B00A2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:12:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80DF3C2034
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:12:29 +0000 (UTC)
X-FDA: 84812936418.23.4BF60CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D754340013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:12:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACC0jpyF;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880348; a=rsa-sha256;
	cv=none;
	b=EV68U+0Bj5e67zlHA3NzWxBYduy+qhwl7rXqsRkUdPWwJG0jeaZT+UlLN8nCaefW1FtvBE
	d/AegJpXc9WBvezvRvXJ+4MLuTjBSJes5tqujZqmuIuAQ4bVcYgNOf6AFHRG+k51U4GN2g
	KFEbCapM/zaEOcK9UnhKzL6WvEhadrA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACC0jpyF;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOPWFf5iskkWPh+w/MW97eAXySaXHhiPn9n33M/hFWU=;
	b=s5lkUWTJiP8i33QyPYXqfGulYgeETEknncoCCNWr5iL/Sd4iInJV93N7hQy7qbAVulypRL
	5aw59g9wcCCrzphbqMJ3YNekxTsuE3MgwjA6JVU/Qs2TgYlY4ifR5ys3JfP98mhKyIVqvx
	cMdxCXx+XsfoNwpMTv595HzJlthU/n0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7C82444D4;
	Wed, 27 May 2026 11:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6E41F000E9;
	Wed, 27 May 2026 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779880346;
	bh=FOPWFf5iskkWPh+w/MW97eAXySaXHhiPn9n33M/hFWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ACC0jpyFzYuGPzHT0IpPesOKu6k+b1ZeJtN0/42mOJWfTwNecuSpl5c6cZfhh/WHX
	 H6TqQ4mwS0dVvD6E65TunVe5sYJ+Eovn9YjvNgN4PPhgT2fhgLwE1p6gWPQZMKnrz1
	 xhmCKZe8eUgGmBjCNgA95sCZBfyugTErfeJCYIcqD66VF1a7NljSrJODWLX/gzjdrf
	 Gdt00RsZ7cedKPCfGnbjetIsxu2Mk9b8RxDtJl1HmcMANffJ3sU0qXlVJKckNljB3f
	 Cqic25AcXbv6NUCQNy4zO08xyH3GHBV1e62E22Wn7gr7JDSf4qWdZDXd2lpCjgvw4S
	 f8SCy70xyuNHQ==
Date: Wed, 27 May 2026 14:12:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahbRlHKXTRUR7a-C@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
 <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
 <20260520140657.2b5b5f3b@pumpkin>
 <ahWwYIOycuWZnETn@kernel.org>
 <20260527093720.1261e697@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527093720.1261e697@pumpkin>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D754340013
X-Stat-Signature: iypdpgwxndq9kuu9p7d8kimo9jnjxaeg
X-HE-Tag: 1779880347-378654
X-HE-Meta: U2FsdGVkX1+IYa76r5xmswI303z4ewSTK2jK9+00ENREjB6ypjLFpxcZtB/qpy7IT+6qhdp89h0gfIlG/FMtbSpmoD5XNWABcJswqWrtq0W+p98lfsl+JqMvQYiZB+wwJKX5VZl8limje5GLrs9hma3DoRAVowPjfprS3I0UWeRIZxWEGwCKNH0W/NE+Bjol9AXcYVKSSmenEqDKHOhdvhq6QySYeOrc8eL9qV9KcDnw4JoLvdhdfaTuSFgVJfxi6imrS+y79lduBtyljau2GEuZjchYUw1ULssBcCapp2aO7A2h/LC6M2WSq1Aq1oJEQpfXb18jQ886MJiFK1REjdkZcgDmbfQiVPodzE1JLM6lM+Rod1El8jNM8ANhGfsg0PXhVhJl6o2KBtLnOX0R7msDjvTib/+7sHpTD32CL6OkBW9y+3Teo3uFTznhd7/LI47+OCAg69mIOMRuOzAvTLWncl+jgT5aZFrdrMZv+oZAYkc/thVuPjDrjYNfX/BegliVA6RBF7G2q5Y1F94u3ItMRVEuDq51M2aDiBWOsosuZwT+reDoUNkJFfj8nEBPSyczR7Cv3SMRGctXnvnisrUrxm9BK1qLnh8REQ6hGnnoM3nQ7zHcuv8wnZXlsIrDL+fZ+gWl8l279c826GBXKgED8tZ6Mp9lcVzG8HyTd1HGnwF+pjOCnHBbrwK9Y4HXolZm9/w0qwjWpluts2CwhcAqU/LgzM//Sgq6Zm3lOK7b8iqxoZevh1HFP8ii4YihOja29v3FhHQeINw7XDRoLmn+3kxC99TS6pfUMAaWi+QicfrkfzOrksMWMgX09SDHPB5WCcnkCQfIIV3zfIUfyjqjsfaD5lnqJcryxu8Q4GXa1C/9CZbKPe4VKDe4tfrsyVCBVdWpBsQ98FMPmvtghnB9KnZev0dJ4oq6Y8ymsiDwH5caaNTpiH1wq//3hbjwY5S9f0cqYGydJuhCb2s
 Yd/cStad
 u4SqO3U7LdgTPFZYjNRmc1ZExuJrAaa+yAm1WLZOYvtmPezcXoChRLGRxoyc2sQJhtcNWYD50DRu0SFJJjJYkdamkPI+yDSKz044OQzWbxHQG6UhOqf25hkC5Foa+sRdWVUSSadXkPtd8voO8NxrNZdveka8yJQbnsp6jfYJqR251FtTHZynqIXjwEIsxBU6jbVC4ZYcTtRQ8JlyUBW4S75bNX9nEwmk5Ud4nhQ/C/E6+pjSjKI9TaqFYuxrCDSRuUaDoCkIhSdI7e/1HMJ+CCIDg8Y2Ph68OjgfhiaJlzLSOHm+wxZObGvOFEvIX0dSmgey+fCeuoSmiQG/X/lDayeHtaklJbs1j75pdfvhx6hVdV17e8USWQ3sDePcFaGZPpRsXMVrGB6Mutoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:37:20AM +0100, David Laight wrote:
> On Tue, 26 May 2026 17:38:24 +0300
> Mike Rapoport <rppt@kernel.org> wrote:
> 
> > On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> > > On Wed, 20 May 2026 11:17:52 +0300
> > > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> > >   
> > > > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > > > as a scratch area for selection of the best algorithm.  
> > > 
> > > Should this code really be using a 4k buffer rather than a PAGE_SIZE one?  
> > 
> > Why?
> 
> Why a PAGE_SIZE buffer at all?
> The real data will either be file-system block/fragment or raid stripe sized.
> Neither is directly related to the memory system page size.
> 
> This actually a valid question for pretty much all of these changes.
> 
> Most architectures use 4k pages (probably because 3-level page tables
> fit nicely into a 32bit word and it gave a reasonable number of pages
> for 1980s systems) but some use much larger pages; I think 64k and 256k
> both get used.
> (IIRC m68k hardware uses 2k pages, but Linux uses them in pairs.)
> Larger pages reduce allocation costs, TLB pressure and memory overhead.
> But can waste memory especially for mmap() of small files.
> 
> Most of these functions just want 'a reasonable sized buffer'.
> Possibly requesting whole pages was originally cheaper.
> But I also suspect people have written PAGE_SIZE as a name for 4096.
> (Much the same as they forget that some systems have 256 byte cache lines.)
> 
> For these changes I think I'd at least add a note in the commit message
> when nothing external relies in the size of the buffer and that it could
> be changed to 4k.

The changes from gfp to kmalloc are intentionally mechanical and
intentionally keep the same allocation size. 

The point of these changes is to stop using ancient and ugly gfp and change
users that need a buffer to use kmalloc().
It will also make it easier to differentiate uses that actually need the
*page* for the folio project.

What is the actual buffer size required is a completely different audit and
it's not related to API usage change.
 
> -- David

-- 
Sincerely yours,
Mike.

