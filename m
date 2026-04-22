Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF96DFA1FE3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436A56B008A; Wed, 22 Apr 2026 15:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7436B008C; Wed, 22 Apr 2026 15:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7046B0092; Wed, 22 Apr 2026 15:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C64C6B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:03:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7F0F8B372
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:03:38 +0000 (UTC)
X-FDA: 84687115716.25.3D0A94D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 59670C0009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:03:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lp5AABAR;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776884617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dxPd7BbIQyR0jEglabsUuR39DxhJxmJZ1fFyP13ngI=;
	b=sHoTQLjFzZDYgu92+eWnGaNbvVS5RNHjXXsUui+8SLV45mMOOCFruTh3nX22/aFL37mLvx
	SI4NKpS6SWlVn8yHdqG/mHl18PWD4FZV6FrKue847l2EPCvusjAY2hM+QsKxbrmnv4jEDl
	Vr0ypHzp6a+CP+Zp8Iv1x8gUZtvXHsk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lp5AABAR;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776884617; a=rsa-sha256;
	cv=none;
	b=IqoFLQJyM57pxgzIPSX6Jb3HZc1FimrWlEvF7hIGHbbIMwgKKJsNKi9Isd1Qn0Y+Gm1aPR
	s2xL+jAYqvf5MKve0m+6uF+vlcHZRmPSh5BkPqn5ZLaA2Churr1TzjNGI81oakJN6ljgSw
	zH7let7D9MElYNplYUjk++YR5780AAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0dxPd7BbIQyR0jEglabsUuR39DxhJxmJZ1fFyP13ngI=; b=lp5AABARlbVgC6fqsBeDJBaXZs
	/tYssrailN0jnBnjMlJIxZmbQZ+xQdT2B5Mk0HyK9fTT5rIMnQSwKq0JbsG3Xt2cchFy3h2jkFyb3
	yUss2uwccLrqkvERj1ga1d2EivUu38sIIzpamdIWVfz4cRFrADrkZxfCoOq0iiRLFfYULdTGSXd1i
	+AqNdET9/+5ZkBQZl6LhRpbFyv9NoAJcdjrnjU8rkqqhUo1P1VYD5GNVIX6IfX5EYfKnAi//9y8ri
	P1mGahwLR6XuUQewB/a+i5Gw/GeVymP4/m4XoGx9AqXILrhslP4BNst+f/ZDXViOjbAhTESNlAtrU
	9Vg9CN/g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFcrF-0000000CBnE-1Y6z;
	Wed, 22 Apr 2026 19:03:33 +0000
Date: Wed, 22 Apr 2026 20:03:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Josh Law <joshlaw48@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
Message-ID: <aekbhQN9afqMBs4_@casper.infradead.org>
References: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org>
 <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59670C0009
X-Stat-Signature: iqhhb8zqnbtmmbcnusq1cz34nfto3g3o
X-Rspam-User: 
X-HE-Tag: 1776884616-429864
X-HE-Meta: U2FsdGVkX18WQ20GMH27j/ZUponBKJeuYXyAh1ZSk/lya3elgDbwa44aQRl4wOri13hrT08m/h6AWlv66HNedwT2L5yJ9No0sxjZqClRAjK++5MZsNoQQjnZsFPl6VnwXi0Ox+hjzxw4XBxUqhKHAMLv1EVPLrHfdfyAUfvm1uct73hxx0yud8qg0yi3puN7+tyv+p+LJFLE0fWF9nr5wnza2iYz7+H118a+I5amJbFwP/oSp9NmG0mrSM+LQLyzbpnJ1sF/l/uORifah8pYryOc3zXX6Hn3LYQXHfNGuy1Dzn51c7iEBN38vIflwKNoDxdCqP4O1PJ4jL2p2X+e2jKKWJ1nk1a4Xkvq91H5qWPypwPHLWYsrdVeDTEWiqzE3nUUGoXvCqo3FFsGyOLFxYXOJAB0+tBH1P/7h6s5gbERJcCPCjaOurDDKlg0ShsnF8gEFc8sLWg17uAWhcNpcKSeIHttza+unE/tmvSDDqC4IMHxMwzjI1AyYOqC1czZffNiL5F0da6jz/lFZ5sYLxIcj+S6yjSoM9ZST8dBHZC0Zf2X/hgecDE+UUjE9Fixj5CCG0zoKIdURbR76/Vwfn2qoFhLkl+o4Zc9rm+IGS8+qKNKxufxKQR02GEh7rNR+2vKK2rxOm7ODutcMUsWs/oOMd23LSMtybUN+5j7hZBKJzFJxUz8pjfNWYSRTUYXy6V3UwXUFHF9c3v1ZMmKElip+nuQlctg4z9DosonaBXHRoYHrxw3dbmzB+/v4hLNUra9D4lfMvC6bx5Do/XhLbV2mlOhnwcMwiqMx7VDcqze66nL4TG/6iKBY/j3kTjtLivsCRg7hEViES+uesJFBwzntHy9rzuaemnTabtgxgx8EDdAK4Ga1YaoJSxh1hjExxR9dKQfaxX0lVVdEIAua9sW//7/1X2RpRmWco83SAGO58T+dNhZKt2Z2ZGnQ8XTxUtpwCMapxqMy446/ow
 QBUdZ7HI
 2HSSsP2g38+wiFEy5BnSQTbqrdOcgrbc3KR4T0IH8/onR9dea4jGsOpBZ/0aODfCR1lqzcXwvvHdeDtIkgKweHqtE/03xS/DoLXIHB2r3BEl9UZBrPv7jsprYhoTft7RSovkDP8KtsgYjz4x5dEuvNVG5t1B0CM2LdVtkDvg/wRn/JXUZKHIVdJ3G2BUrkYLyJXmWqQ5EKDZ0rQLk/yt5TFho7pjnKm1Bg8rHY6e27h7GmmGHqNAyUAs0LbjbqkE7YhFRQl0R8r8Vj4zFseAMM9TOfXcqV2lUCe96KsYsg7A0NNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 08:25:24PM +0100, Josh Law wrote:
> Hello, since I'm not coming to LSF/BPF because of my age (aw)

What is this nonsense?  You aren't coming to LSFMM because you haven't
requested an invitation.  If you had requested an invitation, you would
have been rejected (because we have limited seats and there are people
who are far more qualified than you who did not get an invitation).

You already have a reputation as a liar [1].  Don't compound it.  At this
point I've tentatively assigned to you some other nasty character traits.

[1] https://lore.kernel.org/linux-mm/cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local/

> (And I'm more than aware this post is more mm focused, but I'm
> representing lib :))

No.  You're not.  You sent a presumptive patch adding yourself as lib
reviewer, and that was also rejected.  You don't have what we're looking
for in a maintainer, and you're starting from rather further behind than
somebody with no record.


