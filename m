Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE7110F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7C16B0089; Wed,  8 Apr 2026 15:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EEE6B008A; Wed,  8 Apr 2026 15:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBF56B008C; Wed,  8 Apr 2026 15:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 509876B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:49:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC2088AAE4
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:49:56 +0000 (UTC)
X-FDA: 84636429192.05.C97ACA4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3061F12000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:49:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TyDAes4r;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqfHIKMJG4o9KpbmGAbUtbTRjKCgElpRQKpWc5hqOfc=;
	b=ysaQQQu4wYRUAfIiFv2byL2VsIzizsIbxY4sBF6JjuoIu2pJUdY0diiMtuYdgp2ETOWHy2
	DaVvlla63W3gj6gj1IkkhLLMLyeqtBmRkEv1mk7JqZK2Zj/GU0jZhjmK+QvC3kl+azJKAL
	rlS6w5JmL+BG4xI3/ql6KWQ+ygoGla8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TyDAes4r;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677795; a=rsa-sha256;
	cv=none;
	b=E+LQqDMsJslWCm5X1Zj82/cDG6Zp6Qb6cU70Y28eIH3Bgnj5+cPnCpOtFgrC7io4CMgCxK
	SUWkepvBFZIhHo2H6GQ+goiulW2C0wNZrv032I+1smQOjswji+uMjt0k12QA9tIgL8fUpT
	hKJhXrca2TecV444c9ZZDuoosufuj4I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rqfHIKMJG4o9KpbmGAbUtbTRjKCgElpRQKpWc5hqOfc=; b=TyDAes4r/JzVJCWef5mCqmoY0R
	9qb6eoM3SlzyPGbIuuNBr5yUDWjEkyEOgm+2iOJqjGRgkerfCrKjk3c2xo/Qv00YGiF6njKOW1atd
	ox6BnpO+4pTok5Xu0ihl/cEqhnvHHqvNYqiiML7gEOpJQPoRUESqNKDcvIcVYyQ/27Q5Vk7PZORpr
	aFalAmaqDaRMiucCoJYeVW1ovOGwuTQh+VgI0zVR+m07i1DTGDyrW1WtxODqHlagqJazZGJSj0jyL
	zk5b+Dl7/FROMKCAcpR+KvY7i4vz9YtDmonyYsP1abVRJDfQ5ilN3xLxJDih89BQ3g/xucUAb2gTR
	Q08EqEaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAYuI-00000005rWi-2gai;
	Wed, 08 Apr 2026 19:49:46 +0000
Date: Wed, 8 Apr 2026 20:49:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
	shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org,
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	maddy@linux.ibm.com, mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
Message-ID: <adaxWs8BjCJB1aan@casper.infradead.org>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com>
 <3f9e8e12-2d51-4f2a-ada1-994ed24df284@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9e8e12-2d51-4f2a-ada1-994ed24df284@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 6zybk54j1wqux8x6tr775igiudzpc1cm
X-Rspamd-Queue-Id: 3061F12000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1775677793-671626
X-HE-Meta: U2FsdGVkX18Iq7D2N0d2r6xCzmdXIOXmTwCBSWEII5cGqlvgx2myz68tbVI7juTcFhGWGMs9auqSinQrcWWeSvady4iD/P2SQupdfItsAGH8EmTQcUz0CXjstUq/nqshP6FeGBOnQg7rP5H7pxvav3uJC6wN3+kfJ772w/SAOTcNhO/vY04qeXYhziAUp8Eu1KspqKK0GnFutP5hwgE23EF5KYBOq9pckqb6p64++/0M4pXzDqHZ4MmmXsPrKSbsQP9TBnpVuAp4ijSxFUkYjUm1Jznc9DPcUinYIvBUcTYj40rRw4qYAtN65eefNDWHh2Lcz0bCRA84BaKT3xnPAef2pc5snbafwdqaNHX79mxW6BZqfcs1z95T9oAR5wuPuY9F7T86DnFqsejWTgmcXp9kxtByPlHKKm0ykAl4V2DvFKSsMuvcBi/BnzMaz1CtVMkM35/QukK9YrGrUvSL++9TUiM01kPVzdBh4mg6vz4vXUwPkqcWGurbKpTy+F4tsqffQ6Ml34WQuXxqEzz7WdyhYfi11aZMluToYPdUPbqiW5n087CIbdTAGkzWdJnIBu2gLU9Xu147Em/ouY8GxrTZh7jF4Nr/2+UNzeXCbNfG0CJ2qVAwwx06o2M5+iZUS62X6AElHtjtqA+uUj4+BhgAwq44uujjp65QT0z+AoGknTgFRHs3wDasUmXurjxQ7HTBDz2LRtJC/oCqLxj2e9jqkn1ZfHcbqbEQXBT8+/lH0w0lAyx/hUV8K/UmEOPlapGCaJxUq0/2LIuPDyD88TtKKxIKT24dvUBA1k2ie2r/r++/mBaMCSnFd9cPGuykCMaQ4QNkwtxTGx/w0rxJZmyQ5GLe2Vj9A7AHez8cdCuzMw7y42QqQhs0A9L8QneCPOJdYj2M/TiUWQo3REYZilp6vGdaYxNmO5lZfbHoI7FojFiRDcIAnPA0LNvqemST3tkplcEyAWxsY2w6Vkn
 ucEGZx+U
 7Uaz5ObZFkDG1lVgKa8CpR0vnGsdVcqpYXJT3KsYKjPSIkURLFmf8AONVni+Dm8A07u5sdCItnBX/ijY3pBYunWATXPM3mpfxH8KQnRmhtmZdoYQXEbZGXMlXBp1ZZKX0xI0tQ54UJBoiybeQWxerAaMByQIIDgDGT5VqVBBwl6bmwoOxkJvZzAH80YLEWr3UNnwdUB2Rmf9gq0suu+/Tj7TJUGbOHTjEQXdeY02SZhbt36NbCykiZ8WV/nd/uMdBQucO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 04:06:29PM +0100, Usama Arif wrote:
> On 06/04/2026 00:34, Hugh Dickins wrote:
> > What would help a lot would be the implementation of swap entries
> > at the PMD level.  Whether that would help enough, I'm sceptical:
> > I do think it's foolish to depend upon the availability of huge
> > contiguous swap extents, whatever the recent improvements there;
> > but it would at least be an arguable justification.
> > 
> Thanks for pointing this out. I should have thought of this as I
> have been thinking about fork a lot for 1G THP and for this series.
> 
> I am working on trying to make PMD level swap entires work. I hope
> to have a RFC soon.

I think you may have missed Hugh's point a little bit.  If we do
support PMD-level swap entries, that means we have to be able to find
contiguous space in the swap space for 512 entries.  I don't know how
hard that will be, but I can imagine it's not that easy.

