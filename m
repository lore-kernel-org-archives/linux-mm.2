Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDFFCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 21:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315466B0093; Tue, 19 Aug 2025 17:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED336B0095; Tue, 19 Aug 2025 17:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203436B0096; Tue, 19 Aug 2025 17:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA446B0093
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:44:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2D09137C07
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:44:25 +0000 (UTC)
X-FDA: 83794836090.05.2881307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF379A0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:44:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nzq4eupN;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755639864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3tmkDlrICWWPhi/9f8l+WQQLxDQ2eOp2YTEXLnh+14=;
	b=tHyyRdF6cLc+KX8flc0VUXIQ2D2+KMeVPketyBREkCbljeZE5uVA2oq3RpF3G6OQKEZfsm
	gB2sSN/of7EQZnj6Xu+7v3VLEbxfo8veJh4q7AdN6bhT4og8mWOe1jKqIKy/IGha+8Hte6
	IlUwW6jj0i7PflPe51MXCLkv8V/Idg0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Nzq4eupN;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755639864; a=rsa-sha256;
	cv=none;
	b=hkFp6dwD+18RJrKFN0Kpq631vzxbeFwA0U0z9m/z8T4Z75a3/JplKgYumjhSRD2+Dj9c50
	HicV4AkZK+IbKNKFaYG6cEfCCWC1973NeONdxtNxvWStGU5dVt3R2GfA6oeUICi9OLAiEP
	+l3JaskBRmgP+QBQ1wkaX66MykQUSgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DE341A5E;
	Tue, 19 Aug 2025 21:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1373AC113CF;
	Tue, 19 Aug 2025 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755639862;
	bh=YoRn5U1VviMeI3wYCjAuBp0BdntdvHwrqbroxon/FX0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Nzq4eupNgvz92fewkLIpqxc5BwUVOOhFj0A0MVATwtTXWA5HqVFL1X/JzYc3af3rV
	 ivAeFhClNP+bIy43i6zyq84+b4v10g8FXKYE7Bqm4/ZiRO0ZGpFDfj+EhSSg+DuzIo
	 ZgcEGh5X5zsM3y96jwX0YFH3MJ/iTDU15bCj/XY4=
Date: Tue, 19 Aug 2025 14:44:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@gogle.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi
 Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-Id: <20250819144421.7a52f8df3f0fe5c315f90aa2@linux-foundation.org>
In-Reply-To: <20250819151846.2000539-1-joshua.hahnjy@gmail.com>
References: <20250818171340.2f4ce3356f1cda59acecab57@linux-foundation.org>
	<20250819151846.2000539-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF379A0009
X-Stat-Signature: 9orfnefkh6mkrb4ou3j1quwidi95nfz5
X-Rspam-User: 
X-HE-Tag: 1755639863-678255
X-HE-Meta: U2FsdGVkX182q7KmVF/z6yTf8y0RcrPuHpBcjaOgLiXIirRbLBCDv9p0WDT2vPQ9ko0mzKKsXktcfw2BHeNCYUj6DgrNMDfF3S0ZQ3BwWHXESRC/G9EmxSnL/QvxdS9KkcqYI905gXAtGZFKUdMUq8YUIwCz9Efgm8mrWbFFdPeR4FMw6hknFn6hzstO6ua+L1RsXIWl2tJx2CmoKaGnTp/ab+s9IijfJCVCkaSuZZ9P6+vLWyftGxA57NGUgXt1hi41EpqxA1fL+z9tYx9Z76Y8P9ONY72/DHVqJWhtpFA3FX6ShwvkZQiNmVR9qb81btOQ3OmcQzmjBmhiZqkKajF7VkDK7uBqo6NpznEKoI/TZNUJx5stpvWFuGje6Qf+UBP0LEyrgTzdiVeXkLJMRer15BkrJFiYxFVa+I+vlAmzpaJMraJCiOc1SgR3P4xK5XnUd29TJ1ENhQyVoVusH14EXDjoh1QUW+ZSzhUz6ezVYBnxWi3y4BCXcyUoXcnofLDP7q8GTfi/QPzZRr6ei1bkTE4G5HlSf96K7Qoko2Yybbm2FTbUQcT5EXB3dN8xHZpOYGc7clV25W+DAmV3tO+m3IYjSO8kFKlik7//gUkxbVI/4Jo4my8ZQv7mR9eu59oOL9oe+UySvS81KegLkJl3wBD559MCt0DVh4FmOHLIM11i5zjpIOudMfGnidWLaBdZ7rV7PcCuoVSp6SZKPj/iu/zdG2voUW/0SFwEiY3U+63H+SyNzm1i9CTIpnZTQAsJhX9IvgdMZQkE6wRSp011F1I4y/UhX0l82e/ms3qoHoa9blnncdddOiWvEApr1EruRwR9o6/b2Y4acOIp77xW44vp6FY7S9eekOh9jOCPPD5E5CD7RXEVAMXPLjXuRG2oibgOuFbrQfE4w9WESvzxH0W9ozyqWTwQgsM09M2WmrUVtpinxsud3Pj1JkEdXsKmS4/qb/XtVbfNSJ4
 +SYGK8uv
 HmZQivf0HDg+iRhOnIr1HhIND1opRA24Cp8Uy+UZx5ShbOoZYCNVBkJECmSNJRSTJEA63
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 08:18:45 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> > Pretty this isn't.
> > 
> > Sigh, we do so much stuff here and in __free_one_page().
> > 
> > What sort of guarantee do we have that the contending task will be able
> > to get in and grab the spinlock in that tiny time window?
> 
> Thank you for pointing this out -- I don't think there is any guarantee.
> Kiryl suggested that I put a cond_resched() here, in order to guarantee that
> the contending tasks will be able to grab the spinlock. I think that's a great
> idea -- I'll make this change in v2.

cond_resched() might help because it takes more CPU cycles and expands
the window. A udelay() would of course do this more nicely.

But the contending task is already in state TASK_RUNNING so a
cond_resched() won't have any effect on it?

Also, callers hold pcp->lock, so cond_resched() cannot be called.

Sigh, I dunno, it's all very nasty.  I have vague memories of there
being a way of relinquishing a lock to some other task which is
spinning on that lock.  Or at least, a proposal.  Or I dreamed it. 
peterz would be a good person to ask.

