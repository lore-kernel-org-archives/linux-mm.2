Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD96D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=QFNfM0y8
Received: by kanga.kvack.org (Postfix)
	id 020746B05B0; Mon, 26 Oct 2026 13:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC926B05B1; Mon, 26 Oct 2026 13:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0A06B05B2; Mon, 26 Oct 2026 13:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52836B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:35:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A37C1C4167
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:35:42 +0000 (UTC)
X-FDA: 85365479724.29.282A885
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1FEEA2000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:35:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QFNfM0y8;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p57Tmn7TFfUdAr/vqk6pOopFQQ8MDZrPz0wvkpVt3BE=;
	b=AMm0hrgj0JtncgLCO5Xkt2n1gLIFgcl17OcgG85krFgPTVvu18VLDnKwb+A8pS0udbO8Rr
	vapycBo1LHojq9v8xi7pMtbIdywZvfqjUjO9MXxU2HDx8iw/rLspbn/Cs9kbQ8OdyDlID/
	R0eL2JyHDKDs6KTvT5WyvmYLJkV5i9s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QFNfM0y8;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036140;
	b=Hxm9SyVPa2sIHPi2rCKiUhEmCHBKX4UbYWByoKDYTDqHonp1xSqY0GG1AWUVIiJN3GDPAT
	tTytuk5QCAzKIH3YZQnxY0MWaVtwfOAxSo8YXDwXY7G0kw0XaK0V+V3ePr4DAARLH2zoKm
	UshLTgKefnlgvi39LlaVToEz9auI39I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p57Tmn7TFfUdAr/vqk6pOopFQQ8MDZrPz0wvkpVt3BE=; b=QFNfM0y84n8HNmyTQBiC/PmI1a
	S9aK0qFwTYUrJzLuIURYWYZoM9OZHdram0kZ9RIATbTiQq+NO+wxfzmVhwcwlLXUB74lCyEfxK3fg
	Z/teZZKQNTooIbZ3IyAZERvssM7L0OA9NzY7SrNhTVrekPvnhTCvxSN+XRr6Sevo7MqoNXAnIivv7
	F/fUDEG/WmMTN9nxa4AcmbKMKWItPsCt8loGE8z3fl9X7WpudfYp0z7Bx7eYTJBIXT+Jvwwx9J1V9
	HC37tZ6HAXi+4nYonTcw5eLDYd04a29oDYPz58e7km6rqFF7Dk794Uja/InO+UOUDZLY064M9JziD
	7rWSFt7w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xLObe-000qPO-1i;
	Mon, 26 Oct 2026 17:35:34 +0000
Date: Mon, 26 Oct 2026 10:35:30 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: scan modified objects as soon as they are
 grayed
Message-ID: <at9-71-c98SYDgLY@gmail.com>
References: <20261016-kmemleak-gray-drain-v1-1-3270256fdc8e@debian.org>
 <atY9xT4MfPL7R8fo@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atY9xT4MfPL7R8fo@arm.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 1FEEA2000D
X-Stat-Signature: eotjh19t8aajbkhbbzs8g74u4dikht7x
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793036140-699481
X-HE-Meta: U2FsdGVkX18xThcGz0XYUWmR+gYBWB5v1QftVb01p/kX+crygm/fqJUQ8jqggTpHld3EWofsp1D39DyuzhOOiqBuc+1bWFVVfqfERymcRXJJXlQVbwCPaeV79kukFlij2r6LcBTueUpEEIFiasQTgqLrCloT6G3kx4NqV016HUmXip47pNHWSUgAny5WFWcV6t/6bzMnJW34uus5rvCAFcvnGJiOvAo09lB5qx64oW3J/ADgmNIhz4acOK9/5WMlpRxVPnVctjSm3xBQ72BCXVOHB5YT40/E7zAPL8lwFOqdpARCyt+ByCo+Ns6ByVc8XoWbZSrjFEvzPWXZWt5SikbdKv09IJAkUC1g2Lzb5KP0y6FQ5v/2bo0N8j9LImw94EVJ/RkT8czr3H8pzzPMSNPCMIY2RkwOeJltsLargVuKe49NRv6i9ztGo/K3mn/i0a+V03VFhbp+9iKtDzhqeqW0yD4WUm8YjmsTMliaqIjlQwgmNinD3equlpZtmErQIfzyCUd+JQGUqyJRRQtfgRR+B7cZ3SU096nDgg4B5l2QbmoAp/YxuPKj6sxEuIr10vjS5ZsYXbbs/OTnTwdkOcAibGv9dnD+3ffWJa1/TL1QJu7gVNAQV6Wxi9lA+wFn72Kaj0up/8xTUb+xI2xoOpeAMSxVmRmVcNejqVgPfnS8U4QgMZ49x9Lrar6FHJO+ZRDJ5zdXQnEbDAUBBfzgLBiV1j9U9OYDI/wVbNKJEUKcUxYcwzNvYkGTIReFCKRZ87Y7ar5dcqgDoDGunXI3buLZDCWgM58Da84m4AxmwcJ/sVL6xauLtcZs+GTLdEpQ8fkaJDR23MiUQIFa4Ao5henWTY+bBx61i0Wwd7jqJ2N/cvETx+h/QZyJhEnG+EXLFmB+fxM4+fHIV/IjboKOjDm/OkFdpOKtGmEuInuebhZaaG3HrKh12CDzAaXl8CwSj5fcWzIVJ0E0KBmNEvA
 0uHorMRj
 /01JPcJPns3Vsrv//h7a9Y0uXdKPNuK8nA53ozkoRWwbQnjBIspT/BU+0JL7tuWNs/seosPHQgvNyFANwKqNlEY8YQ6hIfjCPRBFsKXCdxe5zowaCQEdHIIxo5IcNWTgRJGYc2arfUL0Tv2sJMCFlNmi0/+UffcTsA4ZpdxyQ62hgPrnIkzFjpDsFb7KLd8zAKiO2SBOFNsgiqyDjOI6E7XDcNdSrKO48/lpWS4Oi69iuACgW1w3pf34fipZ8KF7LULsBK/9AG0+r/ir1WWL0081GaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Catalin,

On Mon, Oct 19, 2026 at 04:56:53PM +0100, Catalin Marinas wrote:
> > @@ -1981,8 +1985,13 @@ static int __kmemleak_scan(bool full)
> >  	 */
> >  	rcu_read_lock();
> >  	list_for_each_entry_rcu(object, &object_list, object_list) {
> > -		if (need_resched())
> > -			kmemleak_cond_resched(object);
> > +		/*
> > +		 * Scan newly grayed objects now, not after the walk: one may
> > +		 * hold the only reference to another and be freed by then,
> > +		 * like a maple tree node that keeps being replaced.
> > +		 */
> > +		if (need_resched() || !list_empty(&gray_list))
> > +			kmemleak_cond_resched(object, true);
> 
> I think that's a good way to reduce the false positives for such maple
> tree scenario.

I've created a reproducer [1] for these common false positives I've been
seeing, and this fix removes the false positives.

Link: https://github.com/leitao/linux/commit/1291579c487303c5ffbea2cf532649d26329c8a9 [1]

> Do you have any numbers on how much this extends the scan
> time by?

It doens't seem to extend much, from my quick test, and I am more than
happy to test more:

    workload                     base     patch
    idle                         526ms    527ms
    tmpfs file storm + 1M VMAs   10.78s   11.04s
    mmap/munmap churn + 1M VMAs  4.61s    4.67s
    guard page reproducer        13.46s   13.69s
    100k unrelated objects       672ms    738ms


> If it's too expensive, we could rate-limit it, say every jiffy.

Yea, we can rate-limit it. Do you want to see it now as part of v2 ?

> > @@ -2082,7 +2091,7 @@ static void kmemleak_scan(void)
> >  		bool dedup_print;
> >  
> >  		if (need_resched())
> > -			kmemleak_cond_resched(object);
> > +			kmemleak_cond_resched(object, false);
> 
> Nitpick: instead of passing 'false' in a few places, rename
> kmemleak_cond_resched() to kmemleak_resched_drain() (well, some better
> name) call get kmemleak_cond_resched() to call that with 'false'. We
> could also move need_resched() in such function, being a small wrapper
> the compiler should inline it.

Very good idea, let me respin this patch with your suggestion!

Thanks for the review,
--breno

