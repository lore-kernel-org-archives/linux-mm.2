Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A750FC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972856B008A; Fri, 11 Sep 2026 07:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924316B008C; Fri, 11 Sep 2026 07:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812576B009E; Fri, 11 Sep 2026 07:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7476B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:20:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1EB91C1129
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:20:23 +0000 (UTC)
X-FDA: 85201237926.09.0DDB7AE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FEBD80002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:20:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a4nwf5Aa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71OVCowj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pKY2NinR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aFf3cNsi;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789125621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=1lzYcWGNBuU2NRjkRC1Cv/p6OQsE+nEadCUmO4Q4FZO9viTAaIN+SXDjtrjodNnU2oDiSw
	YJ7NzaQVhZqN2aud60uUiYhqMxrWv3M+GPn+o06w+rWzs38sPL55yEjFXhUTeyNXwH7nzK
	36UPMkoP2TG2Zny6nwthsFGnKItkFPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789125621;
	b=6RMTNNzeKx6DP0TaKq8S3c7fQZWrZHZwAeVeDCz/l3Xvy4GbA5V1ZpJObkZ8fzTAsggKjt
	5FjLkE0Cz7TdT3W1gP1AxrRJK3rd8p7jHPuhMGRGmGDGCgBB/jgF81P9PCvQaiaTziBFJd
	LIPzQ1x1/d5b746tAptyo1lN9sb7mJ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a4nwf5Aa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71OVCowj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pKY2NinR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aFf3cNsi;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD16D21AB4;
	Fri, 11 Sep 2026 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789125616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=a4nwf5AaXnoivV006w6a9h7Fur3fmXGif41Sc+QaSolO3OYu8rWO6MP4W4zs+X5QeW5jLE
	1o2z6G1py8XUq/5xw96ZKarB3cna2DEUJuzw59r+/qQslV0RXK9UGgSDU2Y178yOp/ULGv
	bWxnii0/DTEdGguPPU/VHB+xVYAZv80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789125616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=71OVCowjfvzjEv7JxVBYWE6n9QqdAePvuVH1lt8I6NDVePP2xdJPEzevN3P1D5mnKKbhVD
	HXmpBdGkZu5ydSBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789125611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=pKY2NinR2PoinIesd9mBmfQ4kzKhAD8tC8hNsjq6VXge+uYHLVyRuRDvJneApYUy3jZiSQ
	S4T8Q0REpOmhFMOPPZ1WYKGfeB1pSC0l8vUY95jHdg44R54MFEvJnQ5d70KAUaHWGXEeiO
	huZ05WumTahepvc1aaoT13Ehes30sds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789125611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=aFf3cNsiYVucLkMBqwe9QnC3/fUHRXbUySgfDH301JmskDCpKw3+OfpwgHURmw9XpJlQ4y
	ALffrM7qLihmJCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1BB1132D3;
	Fri, 11 Sep 2026 11:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cIl3J+vjo2qpNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 11:20:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2F5FEA1342; Fri, 11 Sep 2026 13:20:07 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:20:07 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axboe@kernel.dk, tj@kernel.org
Subject: Re: [External] Re: [PATCH v3] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FEBD80002
X-Stat-Signature: uqgaqmn9hhjrdp7y6mz8gxp55n6efaax
X-Rspam-User: 
X-HE-Tag: 1789125621-476162
X-HE-Meta: U2FsdGVkX19TfV3rXmcDduu61vwGfAILpOvkcEY/6nUgAz8Urszk1hdwz1xAVrqtXmMI0dUE8GMFP1fLqIiRp81QHY37Ug5ENkzgUv6p7Ess876S0e7RczhkUo1xUIwZIQ+JOGd+UucBs4CgJj+7p9wxEkpgor0Ru7n6eTz5tRO8ikOFFXTS+P24flEii5yHYSrinEKY3JZQKXs59GiPNtTwtcef6lvb6B37LwaBpfLNZ3t5CRvmGkkLbVx1D8L3P3JPZxH6Te5u+0qRYKuoBa5OKvIJkkAxZFlva8oG6l9zCJNzrEyXT8ai27Bereh3uIYdVlJcJ9J2mjaeqYiZJJeliIFP+RqfuuLq9HgnWqAw4ltn6UfB9k6sGw+rbnxeaN2rx4qKgpsTDRFPxWmPCu/HMrUqvWaaYMOERLak652ExuHZOh4QQphtersH8FxAJK6VurylY5OpNRmrbgbhZHvHB338amx7DqHzODxBaNFdZmbO8ZqWzwz5RnZ2Xijq5bZlA/8XE52OutyFL+B9UuOGR205R3C1nKR0tNENdYY/sJM18ub55aKzqM6S0gKPVXg/AhJQjYmYKQuTUISvDL7tYZzG088dgkzeWq8ZGQ9fmXod7leY+0JalwdXZA7kgYw8BHIFSAHH9u4GoNVSS2rRLC2WvbKUt+AqcHuaeQF9UWe/AFoaX2GdK/r2V6tFeaXrd5hs8T2bagFCvArMWhmMXgDL5+HN1hYZK2GguM5aiEhaVKesn3Ue9hLfUCQqzs+pAEeh6/Y3kxOkwz7PNSuKdO0W/xTGDKmrM0wTfZ1f39mIVGZO6XXlp2Q3PhVJhR4XfKgrvLoO+bxKuBMiGfckm8ncT84Vx8+Ldm7AOMyBRRTh5UUeq6eQtTayBxvYTxHLP/Q7EEtxzOoeTGvvE86k235jBwtwXL/RvH4LxXKKvoJxGEJbvgnzvrSo51SXPmBumpHNr8DtNnBWeGY
 stDyYfVR
 AGI+rrCWef+RqGRptDMns/iFgPQsDA47djy+tyYolVTQcQWy4h4gSokUB/CEBnJ62aJjgbpR5clON2fOnAe9B3UQx9PQmWH6JPopDWr5uScg0IGl1T+RSGAzl+UjgI4grk9l/OhEZXaSdpO8R6KK9ed0E+33idCfzLrLgJb8ByOeGN1LwUM8LGfXcPwrZdHM0pakuA0ZgEMxqlTYQT/HTM2Twi1RHKqFTN8H6Z/UmfvSrZOm0s6GVf3U1ECcjB4SfoSKp8u8J0b7V/KDxzcKBnBsxcGvSVf9LqrTwi2y41y1UKAEmZ9sBI4UNdxDVf0Xnn5HS3kkBG3kG7oipGn6qxo0Swb7mEzpLyIQnIhcP5hgFdQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 09-09-26 21:18:11, Julian Sun wrote:
> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > > These flushes can also write ordinary file data, reducing overwrite
> > > coalescing under continuous buffered overwrites. The resulting extra I/O
> > > leaves less device bandwidth for other workloads.
> >
> > Hum. Are you aware of [1]? The guy is from the same company so I was
> > assuming you two are working together on the problem :).
> 
> Yes, Xin and I are on the same team, and we are looking at different
> ways to mitigate this issue.

OK :).

> We will continue trying to gather more evidence from production to
> better understand its actual impact. The number of calls to
> `balance_dirty_pages()` and the time spent in it might be useful
> metrics for this purpose.
> 
> Jan, if we can show that this patch provides a measurable improvement
> in production, would you consider accepting it? Or do you think we
> should still look for a better approach? If you think there is a
> better way to address this, we'd be very interested in your
> suggestion.

I definitely acknowledge that there's a problem with foreign flushing due
to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
break the fundamental assumptions of foreign flushes. But so far I haven't
seen a solution which I'd definitely support.

Having data from production to understand what exactly is the practical
problem will hopefully help us understand how the solution should look
like. Is it just that we trigger too many flushes and that slows down
things? Or is even one foreign flush of the whole wb due to bdev inode
making performance bad? Is it that we have many foreign pages and foreign
flushes fail to properly write them?  These are questions we need to answer
to decide how the solution should look like. And the solution could be
anything from just limiting number of foreign flushes for a wb to 1
(because there really isn't big point in more of them being queued) to more
involved foreign page tracking for bdev inodes so that flushes can be more
targetted.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

