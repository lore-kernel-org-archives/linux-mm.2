Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9586CD58CC5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EAF6B0005; Sun, 22 Mar 2026 23:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F6C6B0088; Sun, 22 Mar 2026 23:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835EB6B0089; Sun, 22 Mar 2026 23:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5C76B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:57:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE7BB1B8D2F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:57:56 +0000 (UTC)
X-FDA: 84575969352.21.592A8E0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A16F18000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:57:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZVJzS6yq;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774238275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyAW0tfdZa2oCYf8MeOfukS6HaEwPDs9Yzvpc6J1bRE=;
	b=c9VcB6sx9mvJBejTJVAODhqiQWv//ZsWjSF4g9y6qYyUepS8SYIYsoDtbKnY/IZyv8YKL8
	TKqIusrJA25am77lxRC1x4dd2QfMYU6MX+uyDfdzjAcC77LtZzOL3AcW812KNEjJi/Hs04
	wUn8kSE03j4dFNsdyA0wNcavNK5Pwqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774238275; a=rsa-sha256;
	cv=none;
	b=4VzFdHoue5PBVKN/GzIAzCypPJvqm98xTKqRxPgarO8fWvQ3rzQ+uvwCkQzgiUUFJWMoSD
	OhviTvf4SnX5nUgPHoYSQDXtromgOzHZmxKWYZOYwRj6HUCyK4vMZ4pnHXzKoO83MpTDoE
	ouij0b2hQDTSzDySv2d96b/4XDi1XZ0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZVJzS6yq;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MyAW0tfdZa2oCYf8MeOfukS6HaEwPDs9Yzvpc6J1bRE=; b=ZVJzS6yqXttNMT8su3VS9i4N6v
	O/gH7tDNEDT7sKZjaq+LIG7oEhJtu833YyLrelCqld+G/pLjKC2ExueDmkBQ+jScgdfN5O3mcYV9T
	qBfrc7IvTvnK5CJZVVjQVTp5+gUGvB9ioMonawZwCPJuAHtdv9IFuPXKKHQaBuIHRDiH5o6IreEVA
	i6zi32mVoS6Snd26lX6t/gLD4mtjr8P5GvPnamWRd0LifBaImqsMXewwVImgwz1f25CLIlIWeHEEu
	BsAWRnJCBe+7Rd0WYyJ18ahvze9ZW37D64cEPhbMe8fTX6BvtOnSfMX2j1uObnQcr3xTk2PXXBMn5
	0A6XNDSg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4WQJ-0000000BaLK-1rfD;
	Mon, 23 Mar 2026 03:57:51 +0000
Date: Mon, 23 Mar 2026 03:57:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Abhishek Kumar <abhishek_sts8@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH] mm: fix data race in __filemap_remove_folio /
 folio_mapping
Message-ID: <acC6P6ULWgxKXFiK@casper.infradead.org>
References: <20260322190319.85301-1-abhishek_sts8.ref@yahoo.com>
 <20260322190319.85301-1-abhishek_sts8@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322190319.85301-1-abhishek_sts8@yahoo.com>
X-Stat-Signature: qruq3qgsghdeqwaysufk6cdj5zobfpwt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A16F18000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1774238274-54046
X-HE-Meta: U2FsdGVkX1/JZPDnqvVKPw2kTlhh6TzuE8t2NgtsvbA2IEbOGCDnXdNouoYgyND9ZcIxv/ijFKiujJLaQCsLuGBdQPuA5+gEoetjg2WlPNXvUXrUFP5SrS9zBTIiFpjHPrZE6Q/rA0tiB9ZGIaJ+qAazCPCkpfLz6x6BK5VM1Oq5HiWEDjeCoHA8IfSsE+ROEFqUgeZWyaXluFwESlZKzIwZ2ZJukyzxPoPOqt3uHrfnX6X3Rab2keNkvpgO03egDIw7b9kiNBLID5mzEjEu8T2yHzxzfW+Zdo+KFeb5rO7xvAbBCGVVkfrdM5l4X11bWRYOZT1x6kUhkcaBiQgsRCBIb75Qh7levaa/XO75ETkZJoO1864O66FOQ9FsZ/mBFHBOa64vU5kvtQP7xh4wjNLAyGhvqKSqwvdkKxnKIQBPAtoqPnYiWq5b4ZdQY7vGBit7mFjEDLoAUiiA6fc2d7iTpAJpInyDXLmjTzrzPcjZ6JJbr5g6fCeMiqJ4TunU75pbfirrcu+pSh5sTdoBN4bMae18SlDQxtvBY/zkJ5wvhCUaOkhYHBaHBrxmFiN2QTTzqRBm2I/vrVP6i2rAZFoKEzYoG73D2I6ZJY2p151KN0Qd55RDWiJOZENJgR/Mgi0dqlFu1l1UsbGQVujOfJ0Qzz0isqPu+8aeZpSMz2Kst6BJWU6859H4YBPV0ThByELd3R1Ohug2pJ8bs+WCh0sVbwC5HKmKbdQB5iFHVrE7gBZlc62mL1XxBhWufrsU6nCxb2Cj4YNqzyY4xlXGvF7PPV9dDETds4jlViqGO1Blm6h6WdWyL72B0cgzc40mu4Juqxxx2pxZKVSNAh/zXiHxpqnJ0Otkk4poelsOjaD0UA20GiYq1EQ0+FdC7pQEB3MPgPDPmOY8BblOhKDhPtYsueKr3A/san0BCB00zAepNS0Q3HuJkMEcMubM1QOlmcGGO42ChylZhWhxs5V
 htKBq6sX
 +cXF/bpViiq054s2GnpsJL9KxsS9hRZH6hOAjsfzPN6hqjX+sL5cfPx+xIM3gH2WMTDFXJsMuP1BoMYXWnPubMqo33Cfe7KPQ5Phd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 12:33:19AM +0530, Abhishek Kumar wrote:
> KCSAN reports a data race between page_cache_delete() and
> folio_mapping():
> 
>   page_cache_delete() performs a plain store to folio->mapping:
>     folio->mapping = NULL;
> 
>   folio_mapping() performs a plain load from folio->mapping:
>     mapping = folio->mapping;
> 
> page_cache_delete() is called from the truncation path under the i_pages
> xarray lock,

That's not relevant.  The important lock for maintaining folio->mapping
is the folio lock (see the VM_BUG_ON_FOLIO line in page_cache_delete()).
At a minimum, this changelog needs to be fixed because there's already
too much confusion around the locking rules.

> while folio_mapping() is called from the reclaim path
> (evict_folios -> folio_evictable -> folio_mapping) under only
> rcu_read_lock() without the xarray lock.

Umm.  First up, this is MGLRU-only code, right?  Adding the so-called
maintainers.

Second ... I'm really unsure how we want to handle this generally.
This could be quite the game of whack-a-mole; we have many, many places
in the kernel which dereference folio->mapping without holding a lock.

Perhaps they are all fine; but 12 of the 455 references to
folio->mapping currently have READ_ONCE attached.  That's a lot of code
to audit.

> The race is benign since the reclaim path tolerates stale values --
> reading a stale non-NULL mapping simply results in a suboptimal eviction
> decision.  However, the plain accesses risk store/load tearing and allow
> the compiler to perform harmful optimizations (merging, elision, or
> fission of the accesses).

I think the bigger problem is reloading.  As I understand it, this code:

	struct address_space *m = folio->mapping;

	if (m && m->flags)

could end up loading 'm' twice, once before the setting to NULL and once
after.  That's more plausible than deciding to load byte-by-byte, or
whatever else these "merging, elision, or fission" words mean.

> Fix this by using WRITE_ONCE() in page_cache_delete() and READ_ONCE()
> in folio_mapping() to prevent compiler misbehavior and silence the KCSAN
> report.

Just to be clear, I don't object to the patch itself, I'm just scared
of the consequences.  And the locking comment above needs to be fixed.
But please wait a few days for discussion to play out.

