Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AE6CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 23:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6947E6B008C; Tue, 13 Oct 2026 19:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F6E6B0092; Tue, 13 Oct 2026 19:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6A66B0095; Tue, 13 Oct 2026 19:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 212316B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:20:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9366014037F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:20:48 +0000 (UTC)
X-FDA: 85319174976.29.AF3F653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E178E4000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:20:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHpEDoQy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=2+Ad=ID=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=2+Ad=ID=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791933646;
	b=3EOnx3ZFwto6VSk/ZEkHC50swrNdc1au62Rr+x5mPdD/ocZ9JqqoKS/VWZPtcFF9o2wHB/
	duXpZT8ozM3frMm6lHJz8HFHA58jeV9QFAp6iJeYhPT2VxjP6vwbFLu9rICTHwrP8JtPGs
	5czxZzVCGikn6AgVbony6XyhF/V9JMw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHpEDoQy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of "SRS0=2+Ad=ID=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=2+Ad=ID=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791933646;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiC8CjfdKGg/9xRJ2M1zfp1fJXqanJWTtOmmSFQ5vK0=;
	b=Ug1JxRabKwft2BStz3PrBQGn0VPADu63S8YtnNa6pMWQ/jcvrRjjdvGt+IYAUsuImdzQx0
	DC5MmY9UvnqKmFHyaiEht0Q1qvPXlOJu0EBcFhbpmuxMED645o1IApzoQu1iBdb4NBaKyh
	GK3Ym3yJDo35zWVW5+oPnlnx+DrzpOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C5086022A;
	Tue, 13 Oct 2026 23:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6D11F000FF;
	Tue, 13 Oct 2026 23:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791933646;
	bh=jiC8CjfdKGg/9xRJ2M1zfp1fJXqanJWTtOmmSFQ5vK0=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=mHpEDoQymjOAnmVmeI69vDMEXcrS8IhmWgL9lz+Jv+BBfkLiVYKN0vI1w2iz2EgRx
	 FOLejqiP1QGy42Yu+4ORZNclzJsH4nIwifkpqMQiF/EHtuy2YRUoNmJ7K7gtsqYR+O
	 r+Oy8DQX35Mm3hcOsEXRtUJgaArjSOKVpCuyorLJL0HsEC66uHloYeCa3KQr9/y9Ov
	 FWy0hVUDBgOo1WVA4FEazwGa3pWRzMjSX6RvQ6WP9uwS2EWWVegdZOrJVCEyl/YCXD
	 mFsQA6Ag6WN6MbcVkxnyJaI5OiWg/nMgC2S/ONRoJs4wnMejGaz7vhEIyOeLDnhuiO
	 1pkNysghFajpQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id CA006CE0459; Tue, 13 Oct 2026 16:20:45 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:20:45 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>
Subject: Re: Improve page refcount scalability
Message-ID: <3bb52262-b183-437a-a7ba-9e5f3c32f355@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6ckC9NJVB8JBuV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as6ckC9NJVB8JBuV@casper.infradead.org>
X-Stat-Signature: 8j81f6q7mebxg6j6hw8191ktcyscgstr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E178E4000C
X-HE-Tag: 1791933646-129854
X-HE-Meta: U2FsdGVkX18xr5CahwKaui5sOd2a3gP/NMM7/WtWgOsAG1bwPwRlsk2nb1oBawaS+0N6kzgOwd9jETsTSdetCOc2Z7jODAAPdYDegWttPlCJG06tTtonGG/2DfMldXZ0L2cbQyssV39U+Z6HUiyeOraFBrM7zFDF187Aw3C2CvODfemozitms7+KHpS7eCVIWfQtciSTY57ZVoSThHfmN+s9297vuor/YJHeHzLQGD7hKHMFk5uf8iK0+hnJgIReDLRjQCEIZf0pF5ogCFAIXvf40mtBIJ1hrcPfSmblJslXX9+QxdIdsHCijnFtmhCwXqF6HW6/T/1kCW5/9d/4sK6SiC4x7MPqEAKtp2r6PeHGmu3fgLD6hs7fXeBx8kESjvDPW86uZFqXL9JRRdtt2vS+J7iqbX+0NmdNp90mwndvoymtgGRme5tYB6V0xLZaPnxL5DPKPELIhliFH6ZuClh9QjfXkpvfDnOKfNcc16F6p83YIr+UGFsRymifLgz3ea9Oljw0gtZu4rREPSTFK20KxLqlNBibALvBLz2X/oQWATElY+0k58ztX5uaZT5BB35F3pbev2Yh0lHT+EgZh4tmozwAUDa7OuCOnyvCn9Yk7wLw7XNn2x9DDz4f6Y9RqmR9f2vipDl3FXkKN2Q2QAWN+4lfkBRwegxq8AFEXvCXFBy2d3kDyPYNf/VBvWblazK8Y4rQtBgWHg36FT4O5hbqAU5+JFYfBLLoh3oY9d9ooVaJ6UlHbInBwLLtLR1zX7/rmf0KUmFVcXEKkqNyW0E7YBrW1h2XKDu8K3aLlFaRoNjtu0MU6fb0ECwfaOUdJr22EHmVEOD5tAwqNAY7JynhWPBl51P3a9RNnS7OdK2KVwHjwrFned8z2hLloztsnE5mD+rnfnBIIgMBJ36+NWyBnr/w+BKWf6/7Of/H1mI1hxkw6sounFSXPbmsc8RgzObeoD87pyjdyGeQi8t
 wg2h9l22
 uhV87kHNZ5eBXYa2Epz639i+JG6ujbpAaoPfQBhPgdDzLCRqQXzcRfBOEslviMCq2+rzU/oS67t0KpdK6sGJUCnRJKe1Q/sUthy/0m5TkWZv2c6ist/mWQQFTvfpnCgbEiTM+3dPtAnBN8KetAujjwy9W9l3x7AKQtY6CE7ba/e5inTmMB43V1I/S58/CyVVhDSUV8XlWLuGFoFtZrHhHAfJdMj2H4UqJk4s3WtyPSN+JSseMfZyJO7lRh63GlFhtQUDWXQohEmKj0Aupja7UrFrK4rwcH2Bb3NVLseVGmbRbkSfKuAq4smzj2jmiIKt+EhGO0YaRNoTK355H+HjFFftqph6DeSdtt67JS5mHWjVrJmUZ1rOfR7Hdcw6Z6OF6Z98EAUnXP1EaivFn2cG3lattMbTrJyjXop1aagyaBPmkKVGiuUP7FdCHgcgWzhQFw7mwhyZ/AZc2weTmvcirYEyGzaGVAUza9yurINTQDTDjqjbUyAeVfdlygCNolim1vBWsZHd/0g4WXx6YJIthxBAydeqtFzeHfyK2fJh1Tt9t2RlviLfTdrEwk4oF/hxGvc8aw3tDUawgA9TARlVkVfzDXwCZkAwSdfEOkX39WIRsgyhcFXpMtwq8XKvFh4TEBPKK68aSR/LtqJGB3b1yoW2aHlOgMQivjXuyCdhiV6P+JYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:03:12PM +0100, Matthew Wilcox wrote:
> On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> > The fairly short series of ten patches basically enhances folio lookup
> > by noticing when folios are hot, and setting a "delay relasing this
> > folio until after a RCU period", and then using that RCU delay it does
> > not just the folio lookup itself under RCU (which we've done forever),
> > but also the actual folio data accesses themselves under RCU. No
> > refcount taking needed for the fastpath where we can just read the
> > data from the folio entirely in an RCU-protected region when the user
> > copy doesn't cause page faults.
> > 
> > Unlike my original approach - because it now actually delays the
> > freeing of the underlying folio data - there's no need for any double
> > buffering, and a lot of the original limitations of my original patch
> > go away too. That improves performance quite a lot. And by "quite a
> > lot"  I mean "I see a 23x performance increase on my Ryzen
> > threadripper". Admittedly that is a very artificial case of reading
> > the same small part of a page over and over in a threaded loop on all
> > CPUs, so any real life impact will be much much less.
> > 
> > Anyway, I wasn't planning on posting the individual patches, I think
> > we all use git by now and probably find it easier than fetching
> > patches from the list. So it's all at
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux rcu-free-v3
> > 
> > and the commit messages are a bit more verbose than I would have done
> > it myself without tool use, but maybe it's better that way.
> 
> Obviously the numbers are compelling.  And thanks to Kiryl for figuring
> out a workload that confirmed my fears, then remedying the problem.
> 
> I don't like the PG_rcu_free flag.  I hope we're guaranteed that folios
> in the process of being freed by RCU will not be mapped into userspace.
> That means we can use PGTY_rcu instead, where there is no shortage of
> available types.
> 
> The workload that Kiryl identified (truncating/holepunching folios
> from files) is not the normal way we free folios from the page cache,
> so while we need to accommodate it, it's not what we shuld optimise for.
> Most page cache folios get freed through reclaim.  I started sketching
> out a new state (I was going to call them "ghost folios") when I realised
> I was basically reinventing the inactive list.  So maybe we should make
> folios on the inactive list immediately freeable as long as one RCU
> generation has passed?
> 
> This may be where I run into trouble.  I don't know how RCU works
> internally.  Is it possible to record some kind of generation number in
> the folio such that we can see if it's only recently been added to the
> inactive list?  Or do we need three lists --active, purgatory, inactive
> where the folio is moved from active to purgatory as it ages, then
> from purgatory to inactive after an RCU perid?

The polled grace-period APIs handle the last sentence for you, but you
knew that already.  I am not sure what "recently added" means in this
context, but I cannot resist suggesting using the jiffies counter.

But tell me more about the meaning of "recently added" and I will try
to be more helpful.  ;-)

							Thanx, Paul

> This will somewhat complicate filemap_get_entry().  It'll have to be
> able to cope with finding folios in all three states, and moving
> them from the inactive or purgatory lists back to the active list.
> I think it's doable with the right cmpxchg() magic.
> 
> What do you think?

