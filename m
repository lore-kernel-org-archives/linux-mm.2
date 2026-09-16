Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE066C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC556B0088; Wed, 16 Sep 2026 13:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767476B008C; Wed, 16 Sep 2026 13:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DC96B0092; Wed, 16 Sep 2026 13:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B8A6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:19:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7097AA449E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:19:53 +0000 (UTC)
X-FDA: 85220287866.08.5AE9330
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 218951C0008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:19:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WHK95Rd+;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789579191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AL3TG6cS7IpvKn1WNOFBoSo//upiT7UQc8tclKdc+JQ=;
	b=YOJJCSPS2nbUs/sLpbwi8+DcWs8MDiEUexbeH5UvNvW1l8OhEM49ch5/xK65HEQdIcevPl
	wHRj3d6H2PlZhyFBzQWSOPUuiEr2JwkxBntOyE35IeHunEF17UiEL6i5IBs8okJHmtYD/V
	QFfKI0a+QV46g0QfFug9JO2/IuUDN5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789579191;
	b=qGwI3QRvR6AWmD4KDOmXBloMqI0eMpB3O4GT7wPS65U8/Rc0T/l+dBpo1LXhSen/ypDMfw
	zcCPl466K37hX/gKBg8VXQDQTMJ6Dhmu9cCGcvXiVKFTRi1XG3z6+FDB2j1vAWFz3jpH+J
	Q90QzAlTTmazuUPwmvFDWRlbwQuVgsM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WHK95Rd+;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AL3TG6cS7IpvKn1WNOFBoSo//upiT7UQc8tclKdc+JQ=; b=WHK95Rd+UiwK0u/++Dx3yH/V+A
	N34k2YOl3NcQR7joTpd4WJSPvDhnxzG9lUCXns2MVuGjeIUTNaH7EdxxyXAqPRvljUq2WUveE1pDy
	Y3+OD7dIwBhRbHg92YSG2QkRDLhPcx2UnGbqfbMEb5sBPgpTqEpyAGYpUNkDcvOkB+WRmcUkN9hEq
	lIO0l9I0Wig/kXsK56MME+Ssh24Az8G9xv4vyibKTMqEf5iARfbc3b7IUnHg6LU/AqDKcFhXMyggM
	GXMv0YoHdkBb3smiaK3urFnEiUWCTPT650xmZdrdXkg9vnzT9YGUs8KF9hE6kxN/JtrjNj82fXMgl
	RbOiRwew==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6tI9-00000005XGQ-3v4u;
	Wed, 16 Sep 2026 17:19:30 +0000
Date: Wed, 16 Sep 2026 18:19:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
	Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqrPobWbuOdsCnMc@casper.infradead.org>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
 <aqrJAX6nMTIo6Vnn@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrJAX6nMTIo6Vnn@thinkstation>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 13td6cjtfs6nrqnptemn3cts1kjrzrdb
X-Rspamd-Queue-Id: 218951C0008
X-HE-Tag: 1789579190-566005
X-HE-Meta: U2FsdGVkX1/DhKq3Wfc7m2+mKOX3HttT5WSImRgothNJDR0A1y6bL1Npfj06WP/ixIXLwCa+4ZbhTOvxQTtYSIZZ7Ze7XsGsQwv8jsfk1NkOoOdj/k4e8GJYxlh7Z9Utx1edpdjatrE1/mnZ7lqaAa7Pm69MyGi93QmY4+ddCz9oqSrv/wg6QSHTpn6jhC8pcXV8gJiqI0r9EjvazsS+Bkp+nvZqPXd9602SYV4v3OeQK7nrUYxgznx8qPvAWbKnYXYB+OO4eAoKNh/aUB57qhAIdaOFc0khIU4+d9HTdpcYIp6r/wVwMNCv7xIq3+3WWt36LolPRu8CuNjQ3U4232gQEnc3VsgWlj6g146bN29D+zqgnKrfy1pugJtB1hOI02ARC2/TeDoueOagA+WA94qI+Pd7BEQguP+FE8n82MrAEnekALz6K82ju1mniYC0GBmQN81e1BtrDHI2VB/VkN9s2hFCosxWxNH0yLG2/DRnNmyRDwCANjQ/fuOzV4etH+A81+IZioFwldkfC3rs7e3ONw+TaRdGelYXkm3KoP4Ji4cSxtq2F3iL5a09NT+8JTKh8D9NjUPM5TdRDU/BpZMGvhfXYuo53SsMTyWx+GUKfZLsgkVmg1iknwhUUWdh2jO6m4gICUbsSHsxBzdf0SPUiDCE92lRPYk8eAgrKldhuPLT2nPd/X/95Ybfq3Ts/Tf0gU2Go5BtFzImQctpXoZ8m1ESZcaHxueAz9QkBIQCXLwihH2FnCFEemDvN4Vy/P0H2iltVLCRoglt17YFUyPuyBx6F894p5Lg011TYXy1I4VRcM5dVNA2GAz4oU35GILuJAuLZpKZjOmsdwIrtAwpCdRoiubUQbX3nwI/gUBtPgimGFFwAju1b2IEqEV8neytELxI7bpDCCiUcOOfcFcZV10y1876sB0GzjlmQNB7VSxL5O84Gm38UQD2ID5Rt8rUAufVmYLjbLTKKHg
 cgkWvwRe
 Gkc66ddufYUvp/i9LDvj6zxAnigvwGuxVNjfPcHuZ5iXUAxatHAj28JET8Nvhxlxkvgu5L52NW8iWgGFVHO3GdmJdzZjyTAiMEeXwPepRF9IvZ6gmRbsTNjUtKO1UqmgIM56SmtYos4AkfkyHmhmXouUO3doIPfqnWN/iTfY1NORLZru3HgUvbD8embHYZqzZhGQ1qWID2NjtkvLYxpxAiMNvWcq7kOsG870pKu8cjuCSDeu4OjblLSE0tEFrQXiPya9ZzXURAT+br3xCfG9yrrhA46AZu79Pcr75
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 06:09:17PM +0100, Kiryl Shutsemau wrote:
> On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> > On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > > My proposal makes the distinction between making the folio writable and
> > > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > > on the filesystem side to track dirty state and drive writeback for the
> > > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> > 
> > Why do you think that's a meaningful distinction?  We create a writable
> > PTE because we've taken a page fault for write.  There's probably a few
> > naoseconds where the PTE is writable+clean before it becomes
> > writable+dirty, but even then sometimes we do both pte_mkwrite() and
> > pte_mkdirty() as an optimisation in the write fault path.
> 
> This is true for the PTE that the fault was for. But we don't necessarily
> want to dirty the other 511 pages at the same time.
> 
> The basic idea is to make the whole folio writable at fault and shift
> dirtying to be per-PTE on write to it.

Hmm.  Is that something that filesystem people want?  I suspect not.
I think they'd prefer to be told when we write-fault on each page.
But let's see if we can gather feedback from FS people.

> > It's very odd to be optimising for shared-writable-mmap.  This is a
> > horrid model for I/O.  https://cs.brown.edu/people/acrotty/pubs/p13-crotty.pdf
> 
> Sure.
> 
> But not everybody got the memo[1] :P
> 
> I think it worth considering if we want to make large folio adoption
> smoother.
> 
> [1] https://www.reddit.com/r/bcachefs/comments/1vepk4a/comment/p1sn4v1/

Since I'm an idiot, I'm not inclined to be helpful.  But I think my
proposal does fix this; we call page_mkwrite() for each page fault and
then the filesystem knows which pages are actually dirty without having
to be told under the PTL when they can't reserve space.

