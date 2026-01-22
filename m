Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E8CC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBF26B00C2; Wed, 21 Jan 2026 22:39:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB746B00C3; Wed, 21 Jan 2026 22:39:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21826B00C4; Wed, 21 Jan 2026 22:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E291D6B00C2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:39:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C4D5161841
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:39:41 +0000 (UTC)
X-FDA: 84358195362.24.1B6D83C
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70357100002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:39:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wU2bhTUD;
	spf=pass (imf05.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769053179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLgL6/UkwNIue8x100aXgsh2f6QIU8y7kOu4/E4/3g0=;
	b=0AiMVxBlxm6Sqwgqb8IaUrC/M+F9q4gn7eG3VvR4XEXZnr2EKMPxw5dp7pt4wQJzmUtUmc
	u5RnzYtsFRXhYwdxcuM13rh+McdKbBVwnpF5DSCJtLgFfHcSout+Q/F9xU0L6ktQcrg/gS
	71hEKdtQ2jUbMYfYOoWnc5HYV+G9ucw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wU2bhTUD;
	spf=pass (imf05.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769053179; a=rsa-sha256;
	cv=none;
	b=gr7M0lSd0eiiGS5NPtKik9J57nskHvDNhRM/h1G2aAsoyuSDITpLcjE/NlIDvEVGA+PXiH
	IR30QrQq5awX2OOyCzw1n2n0VSElhPqqs8YRGVpa1GLJDhQ8TNoScLVuv5KidtqpT11Vqt
	4EEuFRadaVLt3iriBRxU3ollsAWw2z0=
Date: Thu, 22 Jan 2026 03:39:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769053177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLgL6/UkwNIue8x100aXgsh2f6QIU8y7kOu4/E4/3g0=;
	b=wU2bhTUD6kYSPbs7wHCTLDCDV/4QvU2+fDkiJCICT+JHmSktS4RoxQr0a6OqX0N/XII9If
	3QMJl7UZowRKhX61aYeD5klyq4uthEOQMQ1Yokpt5jglZRCuPRKEVxxQyJ+uTcOugn6Q3n
	0IvcM/LgZyXYlhV5lZlU2fOEjjW2HuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <fjb3hzhbmnlgqquahaevekydn5enb45rhgzhixqrtykxaxjk5f@xlcyzanq6qxp>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
 <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
 <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
 <cevxzukpt4363kdlb5ofre5tquuvm6jyphstp6nlxjxqibj4wx@2yg4xwlcxwg5>
 <uodv6dukliy7bnfprh4yoxjkrn77uqljarlg5pmlippxsxygzv@gthjss7yyrlf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uodv6dukliy7bnfprh4yoxjkrn77uqljarlg5pmlippxsxygzv@gthjss7yyrlf>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: a6w5tn4eu6zc8o95sw7wgc3snid56rt8
X-Rspamd-Queue-Id: 70357100002
X-Rspam-User: 
X-HE-Tag: 1769053179-65309
X-HE-Meta: U2FsdGVkX1+dUb38Q6FHzBF/igH2s4HN9e9RlAgQAEdFim/q1j6cO6tCFfGTTcTNeDGTUgjc2CazZ09IxX4KGXl4r45JLAuGDCQNVRfT38Y4+ZDYmw3s7ZWXgRXxRXS3BiWdO0+ErU1DlaXZgwFnLdRJRDmJpoiM+c3kggYOPoeNOWRO9RXmy9VxDNBjSNBF3OYbAGem4hWA7hVFcG++fvaAtZZ6unsLAg/ldIFzK+jk38UkF2RQa+b+r3DzFU84B6WS9nHwzEDNfhpLBQbWY0oYZ1o2E2/Ak+rHDCh2UGA3rdQadvPMfAzEKYzo6vjePnUTn7dtwbGwk0vnlTq+D1eDmane20lGFx2fO2X7AJB73AoDXyWeFZdwMUxHxadu6OJd/Ond7fIl6r5w/2JA4tgZdtgua0TAhDyunwjHFm5VX4w6+pbf1rZJOJW+Jq4KMQpSLQCNuitUHoEC5PM0i381lozVzw3rlFRx0PriG9kMba2xdn2Ho67CYnMFUQkU2Acfu0BdTDGTCz7Hta00GWmh2SPMjbdRtF0442FRS6R3xorMupAJWnOwbdAeBAEgDPTi0CBEkfCtlCecJy6Qr+ncyVXPPiUWkbxnAGUEdYMiry73GWcBhfuN/AAsPwUCiDoP6ZlT8mweSCRNbreJ3qbOmkEA04fgOaILd3+s93IHAoXRZAdXKBAV2+nDQt3pq/Q0McIj3NnpkA/jaqirIkxj8+sytuT0RdFSKPV/BlHz9yYkrqu8kfQm6cfyna0sR4PbjdI1QaJPkMYNSlNljfuO5sMAuh7KAUiOlUTM31FHYu59LdyQAfMF3+otkLcZW0nTUFX9HwW0m6FN6s5pFFTiRP7tq7NsmKBmsqQt0NIRWsT2FZJGsbZYeQpANgGvyXZZkhSInD+aGmN4HxuhND1+K/xYFSaFgoeTfKDZCtE4+Xt92TJ2HdD+1iqMaFgKPtF//15ueyK07Um7/NI
 mGPUXLhQ
 09TL0IcbWhyNdP8eSsvkmLSIlpzQkitymvjN1R/cUTSIWAdU04yLL/0dIQOtT9NmukG+twhvDvL+gOCTjrrSdjYPWuiGniZKPA4FPzA1Hpwm2cGrbBYXzip0EhlhOh9aNvhBLfmu4enPepz4Eb1y2Er9WUZCGJmjKeNFRwO68LiGX00Tjj1ryuQSMGf7IcyQaxxfq5xZsUJ2XNf2cRFJBZTnruHR/Fv4ERXOBmD0ENyAVwKXUNlFKho9X2a0lpS4C8QnoWoHJCMQsuqLHPldbHEcYleWCUFQvtlYa7vdbVo+m8r8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:28:56PM +0900, Sergey Senozhatsky wrote:
> On (26/01/21 23:58), Yosry Ahmed wrote:
> > On Wed, Jan 21, 2026 at 12:41:39PM +0900, Sergey Senozhatsky wrote:
> > > On (26/01/19 13:44), Nhat Pham wrote:
> > > > On Thu, Jan 15, 2026 at 9:53 PM Sergey Senozhatsky
> > > > <senozhatsky@chromium.org> wrote:
> > > > >
> > > > > On (26/01/16 13:48), Sergey Senozhatsky wrote:
> > > > > > Currently, zsmalloc creates kmem_cache of handles and zspages
> > > > > > for each pool, which may be suboptimal from the memory usage
> > > > > > point of view (extra internal fragmentation per pool).  Systems
> > > > > > that create multiple zsmalloc pools may benefit from shared
> > > > > > common zsmalloc caches.
> > > > >
> > > > > This is step 1.
> > > > >
> > > > > Step 2 is to look into possibility of sharing zsmalloc pools.
> > > > > E.g. if there are N zram devices in the system, do we really need
> > > > > N zsmalloc pools?  Can we just share a single pool between them?
> > > > 
> > > > Ditto for zswap (although here, we almost always only have a single zswap pool).
> > > 
> > > COMPLETELY UNTESTED (current linux-next doesn't boot for me, hitting
> > > an "Oops: stack guard page: 0000" early during boot).
> > > 
> > > So I'm thinking of something like below.  Basically have a Kconfig
> > > option to turn zsmalloc into a singleton pool mode, transparently
> > > for zsmalloc users.
> > 
> > Why do we need a config option? Is the main concern with a single pool
> > lock contention? If yes, we can probably measure it by spawning many
> > zram devices and stressing them at the same time.
> 
> That's a good question.  I haven't thought about just converting
> zsmalloc to a singleton pool by default.  I don't think I'm
> concerned with lock contention, the thing is we should have the
> same upper boundary contention wise (there are only num_online_cpus()
> tasks that can concurrently access any zsmalloc pool, be it a singleton
> or not).  I certainly will try to measure once I have linux-next booting
> again.
> 
> What was the reason why you allocated many zsmalloc pool in zswap?

IIRC it was actually lock contention, specifically the pool spinlock.
When the change was made to per-class spinlocks, we dropped the multiple
pools:
http://lore.kernel.org/linux-mm/20240617-zsmalloc-lock-mm-everything-v1-0-5e5081ea11b3@linux.dev/.

So having multiple pools does mitigate lock contention in some cases.
Even though the upper boundary might be the same, the actual number of
CPUs contending on the same lock would go down in practice.

While looking for this, I actually found something more interesting. I
did propose more-or-less the same exact patch back when zswap used
multiple pools:
https://lore.kernel.org/all/20240604175340.218175-1-yosryahmed@google.com/.

Seems like Minchan had some concerns back then. I wonder if those still
apply.

