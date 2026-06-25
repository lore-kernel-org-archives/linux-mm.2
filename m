Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B624CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275356B0092; Thu, 25 Jun 2026 09:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C126B0093; Thu, 25 Jun 2026 09:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B896B0095; Thu, 25 Jun 2026 09:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9EF16B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:51:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 756BE40130
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:51:58 +0000 (UTC)
X-FDA: 84918573516.27.E1F40C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB5042000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:51:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hLAC/xFF";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782395516;
	b=Z6s96DDRzinxOV/obIAXCjNgOkXpEXYJvQkMk1xJyXDlH9nKZUcQ4aEpgOYcmjH+S6mD9B
	SrS8QW2dO9PPbb13kJ9G1H8rVpcJ0cOoT4fChIJM5t+44keUPaEFSb1fGYithtRlC9QEKA
	xRd27jPUeNGoj9QZo9IlqEHPT/cZ0fM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua5RN1s2i/OqK90Ydax/XI8pp/DaZSEnF259m5rP1ok=;
	b=KzE42Yh28OtOJcHgMkmrbwATTPxcB/N8vLAJzfDvqJCI529f3axWtXB+T+iCExta4Di1pq
	SWayY9oAvKTrH4YqBTW8Z8fHjtxDJRfh3+DDGdZLrQIjNCoiGqLrJGpYiegiYdgk1KFCLa
	TkXxL3v+2mqrWCOiwVTzCESZ5+5GUA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hLAC/xFF";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D360B404DA;
	Thu, 25 Jun 2026 13:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0381F000E9;
	Thu, 25 Jun 2026 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782395515;
	bh=Ua5RN1s2i/OqK90Ydax/XI8pp/DaZSEnF259m5rP1ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hLAC/xFFt77m/QH4NX/S+W/YIkDM7I31jYy4HEpODyQ7eKNB4pM+vSlAQGv5gP51l
	 0Uf5hYOwsydgCtvUmTXcZmg4Oc6wVJbXews0b4QDQL+5oBRgIjTVaBPk5cKjr7Y6HB
	 hlheiHQACCufWXeBzVxxCZZpeHclT8DHTjj/xn8SFgKwTf0NPmVZP943rctl2KID6C
	 qr8QXMafCyZYG8JoQtjEJHkY+TC1uhJ2gJBpV6DFxL30KaW9FkhgggntHgFRgdKF83
	 C//pawojA1lu7mn1d6Ycvr/82jN/UIivBk0x+L9Yyf3WAEwfQ2+uVPpbqSKGyn+DOf
	 6I4ZFh8uVKgcA==
Date: Thu, 25 Jun 2026 14:51:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, lance.yang@linux.dev, balbirs@nvidia.com, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <aj0xd4kOfY6wxGmY@lucifer>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
 <20260625034629.nmgdwl2c4luwod77@master>
 <20260624215943.332f1bdcc99a3b85b7df0822@linux-foundation.org>
 <20260625064102.tcmvrctcqibl54yr@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625064102.tcmvrctcqibl54yr@master>
X-Stat-Signature: 1hg5eo9qcunbfbgsdj5owhfm3x7gw5y6
X-Rspamd-Queue-Id: CB5042000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782395516-151741
X-HE-Meta: U2FsdGVkX19EHv5UQdSpYdopWmHGV2OdL8lwyrJouj6YhRHt2r2+9d0GihM9NfBlWvRZBelb0UexcMAbdBV+I/yPiYW+/pTAQf4qxmFqcDT4IuifS680tBhohdMfj5Kv3IVLshFc17dDI7Y01Kl/8x73xfF4ZGYrHuNOzYEzBpPdychkR1QaH3kkDGWylZJlz0f3m2cCuZ6+XlMxNmxye80KxZxnCMWVvswrZVo8LE/th0Ts8uZ3ysj+QkC2eljR3MwhmYT6FEEXoX7P/gH9+LORFGyWvWRPf8FCabv45rgHFilaUIagZ5/3FY0Sfb6w6Z6X4BEpR0Lt0ZBvcw/6c3t25cPDTelyQzWgGOeJrDPSsp178NAazlquKYxMFb9Juvn2ch395HHGcdZBN1Tp+9Jl1LmLcCyg+/fnGXCTuibJ5Zo2SLtwUS/4z2ewWS5nMlbuOMPN0kLltbVfIkj6FoHujkRiTlo2Jl/ZCU/Co81FAikKtT+q1L4c6vCKWK0/zkgotf3nqSvDQiu+WUQkek34uZhD+qOUoyAHahZF5a/63fgByhAIOSXK2WygizO3b08qffego+VWEyiGm42yBFX95We1vAGQNlMUrxDJ4qEtnHoa5k6FSfkRThcd0SmT77SVG6jjdWotkhxIGfIht6FGk25mJdXayEVrW04BFHE6eqSpoRIoOKhQ73SnalA95OKgYIX1HkirbqkkU3TtfXLlVdh9qlAHbGX1xAxymL9dpWv+YrFoFQtp1gCYcKSlLYuJSgb27am1hxJq3xKJ05V+UivxMzcf8+vl/KL5bcuRkPlRfnFtnoGEF7hV3duPZekF/ZNJVhxhBnF1cV0MTdCuBLLPrdWwnBjpg6tyJZ3DCZkfMgrikIQzPDGcAW46nvwjjqTUSoqnrPxQjWpei4VXzJMoJPV73g8KCDbzLcXwjS4veZ5j4Mnev3c8LObf6lLZDTfR4+fSc0S7Y+X
 OczhSfuu
 Pk0OG+2iD/rc08Cc8rkCTy1yUHntlWdTMbNH42EOsK7r6nzAYmy5rDaehFqYWY4hiU4v9w9fhFsI7n3er7VmksKOYznNFGv+99RoiGhAHfee0959YdqduW7dVV0GmBBY4qxgACaty4F38/IU0WAspbAP/EQGS/UVPt/wHcAP4SzuUcTeXORomUDHuehbHEuDFFNBrtpoV04cSlp+OZFpHGh+rrPUdKmBs+tWoBr+RTap9i2zyq7aXU+EnsUiBF3c9EbP8yBEJtbdqGGjxsgfppipkYTuQpDm5UPCmC4nD5wsm7YULaS+fvIOqIjOa3wdG1R2KxT+Opk3AIGTVypo6Vut3fnLDBZ+aHhAby4TX/Isvv4C8GfPk+relM8YPeGigqWV7UONwz3aYtz+bQ5Vl5QuXQIFbS3Xx1QNxOBt4luMRTN/UmBPh+WhXTVSuvPetXGiobnKou0BtUh63Thv+OZLWAuCBIjIexvjrvXTKs5W8yh9OhY6qWWAng5YBYIVKenRu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Roman for Sashiko discussion

On Thu, Jun 25, 2026 at 06:41:02AM +0000, Wei Yang wrote:
> +cc Balbir
>
> On Wed, Jun 24, 2026 at 09:59:43PM -0700, Andrew Morton wrote:
> >On Thu, 25 Jun 2026 03:46:29 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> >
> >> >Sashiko had an off-topic complaint about the surrounding code:
> >> >	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
> >>
> >> I see this robot reply, but not see the Sashiko comment.
> >>
> >> How can I view Sashiko's commnet?
> >
> >oop sorry.
> >
> >You can go to https://sashiko.dev/ and search for the email subject.
> >
> >Or append your Message-ID to "https://sashiko.dev/#/patchset":
> >
> >	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com
> >
>
> Got it, thansk
>
> This one mentioned two things:
>
>   a. page_vma_mapped_walk() return without check
>   b. whether __split_huge_pmd_locked() would split device-private pmd
>
> For a., it is being fixing at [1].
>
> For b., to be honest I am not 100% for sure. If a device-private pmd could be
> file backed, then this looks like a bug.
>
> Balbir,
>
> Would you mind taking a look at the second comment raised by Sashiko?
>
> [1]: https://lore.kernel.org/linux-mm/20260624065353.1622-1-richard.weiyang@gmail.com/

I continue to dislike that sashiko does this.

Series with... interesting use of AI :).. are already taking up more of the time
we reviewers don't have... but interrupting existing review to mention random
stuff is unhelpful I feel :)

I think the better use of time here would be for Balbir to perhaps ask AI to
examine all cases where a PMD device private entry might crop up and to check to
see if there's any other bugs similar to the ones we've encountered before?

Given Sashiko is very token-constrained, I also wonder whether this feature
wouldn't be better disabled (or maybe have the ability to turn off
per-subsystem?)

In a couple other cases the 'also consider' stuff actually took a bunch of time
unnecessarily and I felt they interferred with the series landing.

Given the time constraints we all work under, it'd be better not to add to
workload this way (having to figure out if the points are valid are a time drain
in themselves).

Thanks, Lorenzo

