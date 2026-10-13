Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0449CCC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E1E6B0088; Tue, 13 Oct 2026 17:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F506B008A; Tue, 13 Oct 2026 17:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45B36B0096; Tue, 13 Oct 2026 17:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4CA86B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:03:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CF101A0223
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:03:22 +0000 (UTC)
X-FDA: 85318828644.04.A637225
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 694B640011
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:03:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Le/OWGnU";
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791925400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUa7NgEfoTcw3P3DlukQ4SYNZTtD4CNNK8X1IUo2784=;
	b=BELE9//4Z1enTzHNIHZ/Nw1wtk2EeW9AUB8oLDGIHW86Od1ESjoYc5sCwJc6sGhRrxn2R4
	dEd4gXxskuiMDSXtaMgWAcNht83h6B41ljLgzXjgiIoDvMfLD1qAudpWKAUpzPXUHdpupL
	Xl5DsdMZ9+LsNbNRksoV6PSw16v/M3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791925400;
	b=ND5YbliQWe9iqa3UiLBw5Cj2Ya+GYaHAZG9+VHV+Uo8KkVlLkRcfRUS6gGosMoyWIO9Eq1
	RUPhIZ1ALl9EtKzx2+xp70ntIYXWuT+ZCv1CBMQAQeDcQ1QjQ3pCNL8eWey+pitM2C8OKa
	u5IWt5dp0G00HxFHLmiNf1COh+rgfRQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Le/OWGnU";
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SUa7NgEfoTcw3P3DlukQ4SYNZTtD4CNNK8X1IUo2784=; b=Le/OWGnUMrk7JyDUzirJbH6tzr
	3ISoX686d78tGc1tpKfDC/rsN1Pplj6pMi2Xl5fqzLG6m1GVFciIMwTeKyDA6KwpdhVAifhFz31Vw
	/INHKQeVNzfLRSsOjsCKTSm+7i1ck6snENGK/GrSqZBguDId/U0TieIHbPoX5mSfhPUHWAaKv4SfY
	DoZd9vVWzqcwCMGkjUj7z1RAObBmPfQk/3jSHkgWmgBjZx5R+/6Iqiegrd6cfJkbA2VgR0SS2Wn1+
	g+lximLmK0nV+AtDHDhFQLhu49JId70kgBDlu2h3aqerqiWkDYlvT/Xux79uappfLf5tfmfEnF2ag
	dqyck3OA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGjeS-0000000FrDz-48vC;
	Tue, 13 Oct 2026 21:03:13 +0000
Date: Tue, 13 Oct 2026 22:03:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <as6ckC9NJVB8JBuV@casper.infradead.org>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
X-Rspamd-Queue-Id: 694B640011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fxfg6pwc5c6eghdiqnfsswnunrehiqgy
X-HE-Tag: 1791925399-34857
X-HE-Meta: U2FsdGVkX1+i+8214tnmC3JScNSIjdauZf8bdvJFSwz6E2/u+jMnKSVmTV7Bdle09pVQ61DljpMuVaVX//Gc9Nd0tiYunz4gewqrtNPjSz3zyt5YWMe9ytdYOF110YDyw0U2PBHJWToDOPui6qW38u5FI+9QPvuP/GbGgN+izZdC8AW8u7FAd4VGzuaPujOL819j+OevGrgGIDcyjzau/J/Z+9qlO5+pKSZmJas+EkARwY0mCeCkkeJvT+ZSL9Xj5a9C6VvjAk1Bvo4r17nqcuG2Uw5NzVt6BR3Zae5ZpcwnpEfp0xQQjOb/9qhpb5eW9hGg2qjzr95bG8/EW3SDxixZ3drUN3AMwB3UHTbhdXVzzHM3pJMg6kKcHirSWjVw36xABmAtqJbgC4ZRl4ZJuHGcCNfRZrzySOQlu7LGTTmmOhnGi7QtxkGTYWv0cknUPkLIUTh6mhjj7pfpFVBX+is1CYVxd3F+7U7ndO15yULBtCNpLtkYrqtA/llkvXB+NWUd+vyPTB5fb9Wy7AAS0jRczLe1X9u+NYybGziuDUz6MjoQl9W7TjMSGaiLN/KeFKZo90EbnH99WPbbQGKL3rU3xYEsKwwDiu307psUffL0e4PvWakqAqh0QNe5owwTFiyK2UL8OMu+c9lRrulKNCfrZtqfBlWYe/b/TgIozWTSwFrug0moNCUjd+vcqzSi8IJ/eptDkCWOodI87/tn8qCKesdhpYnV+XOMouw/72hlcZTG6jk/hMbKtOJe7WPIA1IkPEd9UWQnJ6t4w8hcb8ASKy0IFI9ET08bbk2Q0JUv/ltK7BpfuDnupXNcljp+ZYz0qbTe3Q2d7RDOPCh6xjFT7zf81vktsb0ogs5ik78SsCeiE4R/JeiDRHgb3/e796iaSxO8uxzYAtULxm/xXvndnhd0T9zKnZVbYX9wbZjPBb+za6Sf5i1pTs9qt5dzxyVcIKvCHi2ENuSxnwP
 8bnwycxA
 MZxSHl1yakc5HugHaACHjJm/0bFi0Q1fwkFcSloZJmQigtOvMz4t58DkQlFJXpURN6p3THCfttrzmu5Fq/10W1oRQkFn1P2ciRzVuXYV0RM60rdcChuUAK5iNC3sV44Ibjz4cYcFeJuwUpkKj9tDnYYP1jgsVQGG58wiI6rLHtEzNdmYUwKr3G+8+Md5c9bUpCVs4tSeVsX9Pv7SfDYagz/g34jk7N+VWlsccpbm4Pkk1UY+Q3Dx5C1cK0/Yz/mzb1nF7VkJKf6pnIoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> The fairly short series of ten patches basically enhances folio lookup
> by noticing when folios are hot, and setting a "delay relasing this
> folio until after a RCU period", and then using that RCU delay it does
> not just the folio lookup itself under RCU (which we've done forever),
> but also the actual folio data accesses themselves under RCU. No
> refcount taking needed for the fastpath where we can just read the
> data from the folio entirely in an RCU-protected region when the user
> copy doesn't cause page faults.
> 
> Unlike my original approach - because it now actually delays the
> freeing of the underlying folio data - there's no need for any double
> buffering, and a lot of the original limitations of my original patch
> go away too. That improves performance quite a lot. And by "quite a
> lot"  I mean "I see a 23x performance increase on my Ryzen
> threadripper". Admittedly that is a very artificial case of reading
> the same small part of a page over and over in a threaded loop on all
> CPUs, so any real life impact will be much much less.
> 
> Anyway, I wasn't planning on posting the individual patches, I think
> we all use git by now and probably find it easier than fetching
> patches from the list. So it's all at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux rcu-free-v3
> 
> and the commit messages are a bit more verbose than I would have done
> it myself without tool use, but maybe it's better that way.

Obviously the numbers are compelling.  And thanks to Kiryl for figuring
out a workload that confirmed my fears, then remedying the problem.

I don't like the PG_rcu_free flag.  I hope we're guaranteed that folios
in the process of being freed by RCU will not be mapped into userspace.
That means we can use PGTY_rcu instead, where there is no shortage of
available types.

The workload that Kiryl identified (truncating/holepunching folios
from files) is not the normal way we free folios from the page cache,
so while we need to accommodate it, it's not what we shuld optimise for.
Most page cache folios get freed through reclaim.  I started sketching
out a new state (I was going to call them "ghost folios") when I realised
I was basically reinventing the inactive list.  So maybe we should make
folios on the inactive list immediately freeable as long as one RCU
generation has passed?

This may be where I run into trouble.  I don't know how RCU works
internally.  Is it possible to record some kind of generation number in
the folio such that we can see if it's only recently been added to the
inactive list?  Or do we need three lists --active, purgatory, inactive
where the folio is moved from active to purgatory as it ages, then
from purgatory to inactive after an RCU perid?

This will somewhat complicate filemap_get_entry().  It'll have to be
able to cope with finding folios in all three states, and moving
them from the inactive or purgatory lists back to the active list.
I think it's doable with the right cmpxchg() magic.

What do you think?

