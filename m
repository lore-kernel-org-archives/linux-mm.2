Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A581ECD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAFD8E0009; Wed, 12 Nov 2025 19:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2DA8E0003; Wed, 12 Nov 2025 19:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0428E0009; Wed, 12 Nov 2025 19:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B957D8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:04:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4960D4D0BA
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:04:26 +0000 (UTC)
X-FDA: 84103636932.15.F90F61D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id EA3F84000C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:04:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sIg+oKfv;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4Bx1zhXwYb2SedwhCcMZJN0pYhmwiDpj/soRVcSq8c=;
	b=72ncXh3YR9S+uZhh4JZ5Q1NS2s6R38FPkJP6/e1ytczSC5mz5jnE2g/2zSyroqjCzpMpt8
	DBq+DU7dLuBVnjWFiIVzMYow7Cu0P3PGAC32mfaI0jPfA7W3O6PXEOhglkbOCZLRQKluKT
	IMNR48S3vG2rpkaJuYnFm4ksAGcg808=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992264; a=rsa-sha256;
	cv=none;
	b=xeumoDhFdh6cNF7I7xbPLh5V+ZZ7vru8Owx0f5NXuw2xL2PUwIIkic72LtbUv1vn6sIEPu
	rI0PWGXiSFhiT8SoaxBeC/eLk/ZSoRdRnD0HviTs5J8LPYYmoBqK7YSr0GEIe8P5kTB3YI
	Mo159jHdlHrcjFr+CDtywWH++iVqna8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sIg+oKfv;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F4Bx1zhXwYb2SedwhCcMZJN0pYhmwiDpj/soRVcSq8c=; b=sIg+oKfvDmXebc4Lw6XgpP8sfb
	LxVwm0OsjGvejrPHAwp/c3/nFwBTRLXeqekKQAo8QS0o3Yn9gNs8ZaawuUwEwpz1Ah7OdwJVfChPo
	s88tAPabJrLsXYskvot5YHhM/9LCLI94W2K2lmcwYzZdV11Zqg35s9PPXdJyrXH8eLyhObn+srGIr
	KhLKmeMWGBLJjBIag7veDwErVy9n2q447NwdhhAT+dqA7Jlk6cF6zo6rO2QmIpHbdZMWH7QFMrtdz
	zKi4XbbB9bDuBbGiAtmMMtkjX49SAKHJSgpoAR+MxyGLSsuzOPbiWujePmP8tIB3wA2t4z2IFl4ne
	TUYG3+iQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKp1-00000006f8w-0xdi;
	Thu, 13 Nov 2025 00:04:19 +0000
Date: Thu, 13 Nov 2025 00:04:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	stable@vger.kernel.org,
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com,
	"Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <aRUggwAQJsnQV_07@casper.infradead.org>
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA3F84000C
X-Stat-Signature: jq7tbggqa4ycsjsd9kfujx3pqr4qaqyb
X-Rspam-User: 
X-HE-Tag: 1762992263-739399
X-HE-Meta: U2FsdGVkX1+iPAnK6f9wvLGdjfnpYdJJIqbrqJvJTC+7Ask9wJ0DMcBdqhGzTIAdsxw9m1Tq5XZhxBU5SO0SQgmJBewkRoIYK+UONUxjGHHSRH+LVFgVFptwUig3KPxU3pbNzUh81NkGf9sfSHdEYHNX0/JINZd5PkpWd16ITZHddffECHQHpI6oUJOZziasViQZ4bTXzifx36DSglQdNXfL8ezKw8z8CgaeHBOoTGBmlqdMU+SCNU/QItfd+A/3MazR+wYSNjfiKfGZgzHg9Lsvo+Engq7OgoWlVz/MuNOAljIIptbd2Skd3Z8yGhP48pZb2YSYxYUXiqVgPxt6qKWWBDuKglXKOr7/aLnIdOEBU+KUZoLfF8nKVv9m61yo8l8XFR3vDxcCsTOgC6NzFiKzyCY39D24UbmVC271ueySDwSXe+M6rbmgXNMJWtyh3BOPok2OPI6EbkK30SwJdOoSfI71wSBaUTwx5speIthEb/TqlSLLD2Wzv+iZUKrpMnCxw76ilugPMjSNB4aM1MF/iibev0ysHCo/XZ/P7A7/dXavUEZh2ImfWuL+0uUk0cVr21mWhnDwqdwCScG0oq//5NmZHrNRwlYhOSw3dVnUis5n+7km5jXXL63Teif3vQO508UPYrBSvG+BHymvNDJ+pWPg54bEcQDdrTopxHKlppDKZmGJ+rmHZKg0HAs4N2k6MvKGCovH5jAtbHqsFROT8wx1cSfnTg0hGZMGX1mdhr9+j8qzgz2Dvk/FRhUz/khzwoSVZVlSWYIdyXn+/bQUj9kFEHoNBtOZ2b54a0d1M8PbH3syY8KIkhjGBR6muyHjLjn/08+oUwPVVX5RM3K/XzxnEPGDchn8BdfIstgZJZVc0D57TlLfpeUcdQKn0GNQSFS5yqmRHELSQDVW94RIO3aGirrel6xmQhewptCGygP+7iOg72NoALPXq97Dp/O0gnJxOADE3o1DOg9
 41ZBkyhG
 HyyUKczDPl05MVtxgKUgQKjJngWonMSOsD2HrvkftQsZTC+OKbSp/K7XJVZUGuqRyhhnU6lkTCDaVdDtLZTu75qhUCR5Yhl1DUij9al5ApW0eM0Y8ez7NlEcxXsR5nHWoUQA44yDXsAoS06IViriVfJnuwItUkuOo0Hf39dU3GBoOv+cjpYESgW3iI4PRCLi8BFsNDnTpZkJi+eGaGvtZg3JDBsBzCisIV7O+G/O9DGxg//wqwPvodDlpTYRrrkDsRGESPYYxvxqGMvJelOW94FCWf6EEsmVQEUMrylW+AKy4qKKp8CdOD0dapVBBJs/BaM/IYYRkgbM5qnWkjv525bdDLm9iFsFAaLzmZ3pttxWJwmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 03:06:38PM +0000, Lorenzo Stoakes wrote:
> > Any time the rcu read lock is dropped, the maple state must be
> > invalidated.  Resetting the address and state to MA_START is the safest
> > course of action, which will result in the next operation starting from
> > the top of the tree.
> 
> Since we all missed it I do wonder if we need some super clear comment
> saying 'hey if you drop + re-acquire RCU lock you MUST revalidate mas state
> by doing 'blah'.

I mean, this really isn't an RCU thing.  This is also bad:

	spin_lock(a);
	p = *q;
	spin_unlock(a);
	spin_lock(a);
	b = *p;

p could have been freed while you didn't hold lock a.  Detecting this
kind of thing needs compiler assistence (ie Rust) to let you know that
you don't have the right to do that any more.

> I think one source of confusion for me with maple tree operations is - what
> to do if we are in a position where some kind of reset is needed?
> 
> So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
> to me that we ought to set to the address.

I think that's a separate problem.

> > +++ b/mm/mmap_lock.c
> > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >  		if (PTR_ERR(vma) == -EAGAIN) {
> >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
> >  			/* The area was replaced with another one */
> > +			mas_set(&mas, address);
> 
> I wonder if we could detect that the RCU lock was released (+ reacquired) in
> mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?

Dropping and reacquiring the RCU read lock should have been a big red
flag.  I didn't have time to review the patches, but if I had, I would
have suggested passing the mas down to the routine that drops the rcu
read lock so it can be invalidated before dropping the readlock.


