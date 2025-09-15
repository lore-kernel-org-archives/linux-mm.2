Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D22CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 02:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8935B8E0002; Sun, 14 Sep 2025 22:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844268E0001; Sun, 14 Sep 2025 22:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732C48E0002; Sun, 14 Sep 2025 22:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D42C8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 22:50:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A3B13AD97
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:50:10 +0000 (UTC)
X-FDA: 83889955380.03.FF5FBA5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 48A8C40005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:50:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eWaT9aBj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757904608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dhd86kLD9S5jC5U+bAwbiXmLn+7rzSiclYc8cHEfx8U=;
	b=vZ/8cPNzV9O7tflgEdjaEBGXACFpWT+wxDQiBmmEkJnGkv29xgNmZyszmfd6i4/zKo3eFX
	IDdmSDpzNOmNChNYn4zsORUvNsqjIZdHaXqqG3JBnU16jgkWy3QU6a0sCtSpTvkG6bgN5l
	JepF0JKLUzpljywOuPCE+sv/Q5Xwmpg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eWaT9aBj;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757904608; a=rsa-sha256;
	cv=none;
	b=c2Fhw3WZff5JUlFSI+58RUtO1ELbaz56x7ByHPJ1wOArJ3+1uBfIACmFbQ4cT94Rd7RUqW
	dCP81wlP1YbpLQXsCVzyClZXBcJCAXQmQnKZattKcASVSpfMy0AjywrKRHKHVpQi3r/rYM
	1g6jzogx2H8fOfkdQ7qKoqHA1Scz/50=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Dhd86kLD9S5jC5U+bAwbiXmLn+7rzSiclYc8cHEfx8U=; b=eWaT9aBjuB/ZJV1wSybpfNwD13
	It+mYFidUBgqYUog0QtDvbMtTiiysi5FEewF9JvSfh6xUVzb/eDwhSfD/mGEBawd55u4XGEkPn9WZ
	3xxsjVeoc7avYiFW1HCA2357y0FRxtjkPcG4gyoJBFDLEunAZkfeIw6HSmibgn4J4H4yasZQcWVJT
	Z100Dpnv0xCZFmvcdyDLj4ar4bUn13x8AuCqSXTnqO4Ktkrkow1xeCRtDbsWyrf65xcKn/fTJHCou
	tSPYFXLHYxrXz3IWXtFLfxsf4hRBhYpGfBbv93QbY0EyswbDc4uyAtG9t2bT+rnI+2Yk/UpVwmm97
	neBoJk0Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uxzI1-000000067Zg-0pdf;
	Mon, 15 Sep 2025 02:50:01 +0000
Date: Mon, 15 Sep 2025 03:50:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Linux-MM <linux-mm@kvack.org>,
	Kalesh Singh <kaleshsingh@google.com>,
	SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <aMd-2argDQCHww_Q@casper.infradead.org>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
X-Rspamd-Queue-Id: 48A8C40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tw448gtbo4e3um8mok8egcko6igmmpaq
X-HE-Tag: 1757904608-141486
X-HE-Meta: U2FsdGVkX1/qD42puwmYxANAEaJAl8Rx3S7lv+c2oPGO3aU+aqfyIKgu1387W6+pC4AsxjSUxNLAKD4l7OG1EBFQyt+oqvZ/czdGRmt4RkSEdPukW0t1xOkE6RBIk/392Ca/ZZe0kQS04c1+Q6gdsD5IyYWjLQy0tWniEu/1RA/ata/xBPgr2Hn1o0yhF1yRPzis0oVkCsX1dBeHVe9x1Xkmx1y+40Mw6Vu30Z/5UKhLmklC6z23355JdpObh/MyZHLnTkTT2EaXF4zq4J7w7dMWi8r+ciFV0DTKUJ/wpdc9ig5NCLhGEs4xwbg34T6YP67JTeEQzSd2TekP8//6XaaxsMmJN4Zni5C98BJez2kxHn28SbCT3Sw3pIYY224HJ7ImxV/ytgwzFWg/hBGCmV3W/gdNoskXdOA+d0I3bJ/cur2464G7MgMIuSAJ6FFszPauuyYzZzF9lHRsfvLgQeu/uCllWCi1uZvmpt0ZGjurKknmFGNc0j059qNLgrdM9NLf3apJVVOqUnyssZbUaLrcu3t6xBDSZj/J8XATXBsNNYU6wSlyqFj3BH5tmt1vwvU2p+KnQwCu0/EQ8Pz5L3eF80nE4r5d6xeqJoAgMRgRKFWrn41cvoE/MfmJpcZyUD35Ow0YYRwjeMLdHgp/YpRzCZrvYdQKHDpzBgOs1y6UkeFN+cZrQVGs/tzl/kEF7cIH9n2kg3+74ZoIM7UKyrxjRRtztTrHOfIl/0iFNwTkoQ8I7btkb4/GLXLaNrwMKtnz7QC6dX7i6c5CBQyvtt469VeH2kZHPqdOl+TfbTKSoVz/KcQoPzYSYUbi8x/owRRTXaV86Z3jXP8axMiFugNB1garyOOLs+tPed/UnZAp0ZEZEFY4F/P+lFgyAT5FK7kgv8pQ2lr6EIgtR0K4Mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 08:23:38AM +0800, Barry Song wrote:
> > I wonder if we could fix this by adding a new syscall:
> >
> >         mremap(addr, size, size, MREMAP_COW_NOW);
> >
> > That would create a new VMA that contains the COWed pages from the
> > old VMA, but crucially no longer attached to the anon_vma root of
> > the zygote.  You wouldn't want to call this for every VMA, of course.
> > Just the ones which are likely to be fully COWed.
> >
> > Maybe this isn't practical, but I thought it worth suggesting.
> 
> Lorenzo suggested possibly unlinking the child anon_vma from the root once all
> folios have been CoW-ed:
> 
> "Right now, even if you entirely CoW everything in a VMA, we are still
> attached to parents with all the overhead. That's something I can look at.
> "
> 
> My concern is that it’s difficult to determine whether a VMA has been completely
> CoW-ed, and a single shared folio would prevent the unlink.
> So I’m not sure this approach would work.

I'm concerned that tracking how many folios remain shared may be
inefficient.  Also that information needs to be gathered in both parent
and child.

> You seem to be proposing a forced CoW as a way to safely unlink from the root.
> 
> A side effect is the potential for sudden, heavy memory allocation,
> whereas CoW lets asynchronous tasks such as kswap work concurrently.

Perhaps you could help us out with some stats on that -- how much
anonymous memory starts out shared between the zygote and a newly
spawned process?

> Another issue is the extra memory use from folios that could have been
> shared but aren’t—likely minor on Android, since only a small portion
> of memory is actually shared, based on our observations.
> 
> Calling mremap for each VMA might be difficult. Something applied to the
> whole process could be more practical—similar to exec, but only
> performing CoW and unlinking the anon_vma root.

That seems like it would be worse for memory consumption than doing it
on the VMAs in question.

Another possibility would be for the zygote to set a flag on the VMA,
say EAGER_COW which forces a COW of all pages as soon as the first one
is COWed.  But then we're paying at fault time rather than in a syscall
that we can predict.

Another point in favour of COW_NOW or EAGER_COW is that we can choose to
allocate folios of the appropriate size at that time.  Unless something's
changed, I think we always COW individual pages rather than multiple
pages at once.

