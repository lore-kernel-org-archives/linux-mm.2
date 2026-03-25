Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35E9103A99F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361346B0089; Tue, 24 Mar 2026 23:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3119F6B008A; Tue, 24 Mar 2026 23:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2292B6B008C; Tue, 24 Mar 2026 23:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C91F6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:00:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D21A6E09A2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:00:54 +0000 (UTC)
X-FDA: 84583083228.25.3D17610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 37DAA80003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:00:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCVnXnZa;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774407653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PM5gH/LzJrbGLKzyyyf4aZcIbN9o+XtSC/3v2AdURLI=;
	b=Dq7y6Ouzx+R+ATKzmBC6Txlnsh1inj5wcPZenCAmbPfz70+LvidbBnCZaRgbJHL72b3iVk
	6AGtwEfV2CHCYhfW6HVIIjgWmGzX6xm6/n+dxWZj106PN10pl4tx7UGXp5E8QZ7JskOaRP
	zmOImKyZY6pGNAGRPv0GkuWVHrWY5Fo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCVnXnZa;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774407653; a=rsa-sha256;
	cv=none;
	b=DIpRdwIwqIHqNTkiRxsgmqyZ9Y+o/xYeWyRHUYo5FzKYeqSLW25gI6tie23oOSFuXO6Wfw
	3TtPeFEN1qsMEVbYviN7bqTx8AzCQ4ntV/1PObxLpmONSk3rwNvt6i5cd7lRZAFPum3EaR
	t1xaK6gWe+uUvDbIVyj+ue8jXuZN5Ik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7972A600AC;
	Wed, 25 Mar 2026 03:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D71C19424;
	Wed, 25 Mar 2026 03:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774407652;
	bh=CztaiS5T9Q+yyRl7KzG9kGIQBhdxneoXFQM3HOBtAYY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XCVnXnZavwdON8NRKJfAiFXpB5TStIYEHPdUlg+y8LdWa47dj9YZ+8VWCRCIIpahG
	 BGGIXix0gfwZs7BicIJQSESLJ9v1NWmhD+hSWmTF1DfEr5KAiu448/aM8ZC1P1tLVY
	 BAUfZ+JJLeaX32H1tyfB+Lk6B9LBLpcgWv2TnCcA=
Date: Tue, 24 Mar 2026 20:00:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Herring <robh@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, Krzysztof Kozlowski
 <krzk@kernel.org>, Oreoluwa Babatunde
 <oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
 <saravanak@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 0/7] Refactor reserved memory regions handling code
Message-Id: <20260324200051.65f45cbb445c6ec3f8f6399b@linux-foundation.org>
In-Reply-To: <CAL_JsqKbfFfWOzDL_KJLg7Gu-wCqE1Ch+yZ6-g-cNJD-rMzxXQ@mail.gmail.com>
References: <CGME20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6@eucas1p2.samsung.com>
	<20260323100901.4079171-1-m.szyprowski@samsung.com>
	<20260323131822.abae01e95817011f24bb8237@linux-foundation.org>
	<CAL_JsqKbfFfWOzDL_KJLg7Gu-wCqE1Ch+yZ6-g-cNJD-rMzxXQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 37DAA80003
X-Stat-Signature: gh7ut3rxbibzzuktxaat1s89wyyxyt6t
X-Rspamd-Server: rspam06
X-HE-Tag: 1774407653-367922
X-HE-Meta: U2FsdGVkX1/krHNdjQeO3JZj/KqG9cJA5QR1i3ylDVn60Hj2WOYKx9+UC4vg3bKwnSedKiqDKkAHpz85rMvwVX3k2hlAbXOUUen40RC0mnqUr9RpXl55Ci/7bNuX9Vjpt5SMg3uv09JD+da9V9wtlLB245SHE/Xbp3uCANwm59o7Ll83+OqezIvDJcZG2afl7u1hYrfky7SBYqmeAkU6V+hyZwKxWMZg0XjzVRIcIkMQhVB4vPnkBySEPSP4Ib0cdj7f+NLuZgLZ08BtEn9hpQg9meqShkF5RMSHilGFsjEg5J/qP12Mr6dLRanFDn9XG/Wp+EB9aDStKL9FsK8x0epuRy04P4B7sKdS8FKwDNrtsLxyTMFjDoHkJpbCPVHN3L3TOK8F3WWjBCGk9e/wWagF+MH2AMF48A3qtYujNrXQOZOoWKIzCF8J1JF3S1oZPuYSzOV7379RmvSiuV9DMK8MPcq/kIslDyUgD9ZksA4mD18NamTg3J/TUdUl7R1Zk67HoZnlzMRb7vI+FpDiU8e4trZYyGs51gRSpgvczHkKwO6Y7W61XpxHuwmdi8MTkTqeoh2aCiEyuJBr34qoeZhqK3fD+GK5gHyrLxHsIFEYNADHDbj9wQEPepqHLkVTQN2VEaybJFxcfr38+Z81Mc+HVcU8HEGW0AbRnlBu/N7iBYT6GVjP1qo07e/nzDHXJcTa10x9Nd343niuY17gimKpeKs2BQvfB+XPhW67AXxAlX4Vub5cMRS8rd8mhc7Ud8STcL5v+L6ZbGZ2o7iP1O8avtEC+hyRreJDbRtXvhX1YUjsWIYWB+BhCvby06cM4jqwsFKObxr6eobe21p4+knAWDOaXGPN/tjQRTp8xdewpGEPojj8kyZH6uswyA+HlFQAVoDr0mKJt4Wvym1Uywv6TDE7jU9T0h/7h9gRbexSrbffwqu1wM0l+XTkkfsCI/i437ZC00jv/ubX+58
 vmcd7ejo
 rfTg81HUZfSreRM0cLXwuUfP2sy7ya8VIUvaImG0rk+p518p2AMfBUxw8T8J9RXjWpRCEJxEf/bgetQEq20PAZ9n9KmfzW4BKhPP0H7EkAyEsQ1IY1oFBjKEkScSHTTUGcdb8Pfg1n9quCPF0Mbh8q0nykrbSHR+8vpWx0MQF3BVk3SWdeB9Ie3ZFhfyQ9pQZBSwnbsuoumA+mnQl5CbIvR0ohDBV/B3xUsIdeU+F2lqiBArB+ey16zy2mSS4/HmqBQc7B2XE3K++Jrkz2RdhVMAkPf5tbBvJSZBs94kOZuYYqSH58D+ez/XysUc41czEb9bgV5knKMQwHaqZ0CkDPOrarvpdqT1l16lIpa1mbQJOfdcbSKbFq4gwtCx5nAWTGc2zvIsWMNZ5pRk/lZdjcfrshxgK608xJCrFqJb7dDU5gpvGdryKlIz7Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 20:49:14 -0500 Rob Herring <robh@kernel.org> wrote:

> On Mon, Mar 23, 2026 at 3:18 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 23 Mar 2026 11:08:54 +0100 Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > > The reserved memory regions handling code was reworked to handle
> > > unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
> > > reserved_mem: Add code to dynamically allocate reserved_mem array").
> > >
> > > The side effect of this rework was a set of bugs fixed later by commits
> > > 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
> > > "cma=" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructure
> > > call site for dma_contiguous_early_fixup()"). As a result, the code in
> > > drivers/of/of_reserved_mem.c became a mix of generic code and CMA
> > > specific fixups.
> > >
> > > In this patchset I try to untangle this spaghetti and perform some code
> > > cleanup. I hope nothing breaks this time.
> >
> > AI review wasn't able to get all the patches to apply, but it asked a
> > few questions:
> >
> >         https://sashiko.dev/#/patchset/20260323100901.4079171-1-m.szyprowski@samsung.com
> 
> Now I get these in several reviews. Just posting links here really
> doesn't flow with the review process. How are we supposed to answer
> when AI is wrong? Manually quote everything? No thanks.

yeah, I know, it's quite dorkward at present.

> To answer this one, I think 1 comment is wrong, 1 is right, and 1 I'm
> not sure about.

Well that's good.  Really good.

I view Sashiko as a tool mainly for authors - view it as checkpatch on
steroids.  Reviewers will probably choose to take a pass if it appears
that the AI activity will result in a new version.

> Don't get me wrong, I think this all looks promising. I know email
> support is planned, but please get that in place before sending
> reports. Really, I'd rather just get the emails or mbox to review
> first and then decide what to send for things I maintain. At least
> initially.

"at least initially" is what we've got!  Be chill, it'll happen.

