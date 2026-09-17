Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2374C982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB336B0092; Thu, 17 Sep 2026 02:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3956B0093; Thu, 17 Sep 2026 02:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BAB56B0095; Thu, 17 Sep 2026 02:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A736B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:03:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC9C880256
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:03:33 +0000 (UTC)
X-FDA: 85222212306.24.11F0C9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2371C1A0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:03:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wd9u84st;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625012;
	b=3FRrSnlBPm1Qsc8osJkkfsOJDULU5Nu6G3ZouA32uclv3GgnZJ/qwCrYbuCMYVPTmjh5I3
	xSr6WZUwuuO6dgetP+d7BkSNlGDDGRdyxPOD9BgR3efuA33VrDJx3y3SIUUoWpZrJMGHWe
	JRjWoTzCocaa0mtXNTaoG4g/9UmQmLk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wd9u84st;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSrhie3ypuW83vFReYxjzy5OGcpm75lW5CqYyN+TEsk=;
	b=OGL9LdT12UheBtToFE/PNRRmGcRDrTJgYaAacV+SobilmXq65f1hTcbNt5q4nWNNepnvqV
	ZFZuVQIqmCuGDYcVH3PLfKvpI7nXVu+TYZQi/57uHrDlLsAFn/FEcPNCo/S7M2O5ct22Vs
	Q0L0NTn6iQU6SI4alNrOKt2sjvZAHKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4222440254;
	Thu, 17 Sep 2026 06:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C4D1F000FF;
	Thu, 17 Sep 2026 06:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789625011;
	bh=HSrhie3ypuW83vFReYxjzy5OGcpm75lW5CqYyN+TEsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Wd9u84st6s+3ZhZdO82k19nVHM8EAnqO3+U/8oQITZkdGudQybJigXBMhtM6CAyGW
	 baMfzhKJwf9EVmkJ87qdiD1rcmBHgV4FNMaU0FXOgWAzme9oBLXFcOFwQ5Ef7yKHyy
	 /XvF2GFD9UzKCTU0nX38fqf2qtJk3AijlOthZw6k=
Date: Wed, 16 Sep 2026 23:03:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Ridong Chen" <chenridong@xiaomi.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized
 warning, again
Message-Id: <20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
In-Reply-To: <75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
References: <20260916083456.4136132-1-arnd@kernel.org>
	<20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
	<20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
	<75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2371C1A0006
X-Stat-Signature: 8hkx56gkjm61p846x7zc1us8bf7qpnxx
X-HE-Tag: 1789625011-479195
X-HE-Meta: U2FsdGVkX18sqGrNLfRx/kFNm+trOzWDPUCYYrBRc4NzIDo3zBcHvakLd2mhyCCXhzINoZiTcKC8oGUYiA1le5yuE3btB1FUzAHnEb+OBwtnPHOr4mQSU0K37qdHZv8RUP4fcoo/NMFUWp3AAaS83qCoDh6pHeo9HMFM2U6XDp0PMaGkLeHmGEIM25uUBL6Gj5DF4VOpJ529T1p1X2C7hDE30S6c5Ds9+2o66I9MVd/PwOX529PzYSetSApXhN/eFTlOV730Hj82MKJdptuqI80IJIs/3+xV1hoyhRa8TKQHaiCgiO24dbcE7lZKxpvBTpaiBuJwShHoOhRZLfa8QmRNJerwJWJUDg7vZ5kaZKstjj+2kV0heBmxCqs8Ii9/g8NL+yHzBB1+LDkkyn7csAkD1T3+F3kiz5vD/ETRl1WzQI3HKQekpbR7UaiNQSKIFOvANvhOlRvIWxmhDM+DLCtdV8Sx6dMN4tCPwbHVX7V30KEz5NUo804EFcWoZ26zf3inytT4ZQJLlUxtdcjoz1poYSkVImYDdbMK+RrJadc77AHQ+51ohylXaussClg+n60bqBEt+05dmksRMijHtGbNfawO4f+VMmIHEVcF7zammc5VtGhjdE3AWNSSPnzWMAZg0xmpos7JkJ8GTBqDsEC7ImAnggI6IdLcX/NVq9ERn6aI1W/Y/2CKxZNELck+e59m2peSADTJOZJ5udCW05plzh1BRAdWCRRSats5/UAyvoR0T8vvNMkDzl9x1TnqyAUvBi6KmsfS0aICSq8FXBxB01dqn9/G5BNGndDp8Bf0gtI664QPibSuH+MVef36g0tdPcqnDI5TehupJaBO0GqtEspSNPOjpg7VOtsr1lARfTBGsC5dvWPHZNy6eC9lfTWRHGqf5j0qni7P7/CzNDkxJDOtke6m7KuB3S1pn3jou3gukhBCIt9SDmnb27hbnAvpPNP0xARsluk8Bey
 4Fs/hBC/
 1RBFkKx6O2lRaiFWv99+MagjSKQ4/ZcFxBFvCxQBAAMQiYSHbKwb1WtVCR1EwAJKZmioGxWmUDHVX+83+6Z2aQTagIL5aBygCECNyYxuLgH05uubWTyz2ifEmkiACxTUwgzjVd7/l0k5SkTZ7k7bbHBONRPWFauqo6rKDnpolV71coESiNSaJMyKIUK5Fz6JHRpHUmPN/X6hxH8VC2BrBBkSVUzox28zAQe3vr2PsIqaJ9qOpJ51Dl9lKMQMlEWy2l0K8bN4e4BNI9+XQhsdL3k0Ia6DxdoiO4SB534ic/dgwlDkAlHUv9wiD3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 07:50:43 +0200 "Arnd Bergmann" <arnd@arndb.de> wrote:

> On Thu, Sep 17, 2026, at 01:30, Andrew Morton wrote:
> > On Wed, 16 Sep 2026 16:28:16 -0700 Andrew Morton  <akpm@linux-foundation.org> wrote:
> >> >
> >> > --- a/mm/vmscan.c
> >> > +++ b/mm/vmscan.c
> >> > @@ -3274,8 +3274,10 @@ struct ctrl_pos {
> >> >  	int gain;
> >> >  };
> >> >  
> >> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> >> > -			  int tier_max, int gain, struct ctrl_pos *pos)
> >> > +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
> >> > +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
> >> > +				  int tier_min, int tier_max, int gain,
> >> > +				  struct ctrl_pos *pos)
> >> >  {
> >> >  	int i;
> >> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> >> 
> >> Current code has changed here somewhat, but I expect the error is still
> >> there.  I fixed that "uninitizled" while in there.  Altered patch is
> >> below.
> >
> >
> > Then the build blew up in unexpected ways.  gcc-15.2.0.
> >
> > The failure looks like a legit min() signedness thing which has been
> > there quite a while.  I'm thinking that __noipa surfaced this for some
> > reason?
> 
> Right, I now saw the same thing here on the current linux-next.
> 
> What I found now is that the __noipa is only needed on top of 
> "mm/mglru: use explicit tier range in read_ctrl_pos()", which was
> in next-20260915 but disappeared in next-20260916. This patch
> also removed the min().

So we don't need cc:stable?

> I think the reason why __noipa causes the warning about min() is
> that it prevents the constant propagation into read_ctrl_pos() and
> in turn the hack that suppresses warning about mixed types in
> minmax.h when both sides are constant.
> 
> Is the mglru series currently expected to make it into 7.4?

Yes, "mm/mglru: use explicit tier range in read_ctrl_pos()" is in
mm-unstable at present.

> If not, I would withdraw my __noipa and hope that the next
> round of changes to read_ctrl_pos() does not run into this
> problem again.

OK, I'll drop "mm/vmscan.c: fix min() signedness mismatch" and shall
rely on "mm/mglru: use explicit tier range in read_ctrl_pos()" to fix
the min() thing.

And I'll stage "mm/vmscan: avoid false-positive -Wuninitialized
warning, again".  ahead of "mm/mglru: use explicit tier range in
read_ctrl_pos()" to fix the build glitch wihout a bisection hole.

Does that sound sane?

