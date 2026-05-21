Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFB6CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 00:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C536B0092; Wed, 20 May 2026 20:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174886B0095; Wed, 20 May 2026 20:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1896B0096; Wed, 20 May 2026 20:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB9386B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:36:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4B8D1A046A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:36:34 +0000 (UTC)
X-FDA: 84789561108.27.B5ABFD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A9E1140008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:36:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ga2OTG2r;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779323793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtVPml42S6/vWtnPxk8KNVWBhpuWSECUt44EvPJpKtA=;
	b=Y0vw4KPnuszIDqJxehZuLuf+wYpaOOCAT1AKKc4bLMBzCt2wokTElS1Kas2WVoY/bw/j3C
	C/zv3RO3IVhGj2AbAZKSv1vhmh8gC9LCCmqRTq26Vddsxz7lsXcFb8AKCMuG7vTwKY3/NE
	Xz2y1IS6ICpu4hhSVUP9Begt0pz6PGw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ga2OTG2r;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779323793; a=rsa-sha256;
	cv=none;
	b=oHhDFQCnc3AzEBknxtQ9Omg7LchRyq0FZoRrAXOVvcGxgz2DKkh8Mi3VGXUxcHyqFNKDYf
	eufHIBZg79gm2eTl/6Izs2TaVt3ygCea/jBA5PPVIYCbQ5wC6xH8KzLMmBzAqcGGioevee
	EcYj/gMMfODOIE0MpRjqjvAZieiUjhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81DC460098;
	Thu, 21 May 2026 00:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95F91F000E9;
	Thu, 21 May 2026 00:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779323792;
	bh=FtVPml42S6/vWtnPxk8KNVWBhpuWSECUt44EvPJpKtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ga2OTG2r4BlEhHPm9VSy9erfp6P7UHoEFYKvlUwXpBSAu6g7jcVwFlHlvn7FCujRo
	 rjPDV6t19Vpa8Q5qXljpD92PB8tLHQwrX2rUDtjslsxB1MND9UuFpDVTq7yDHHpq9J
	 xKGGYS0aawEjFOBfyX+dIDktOB3yZQiFTPoHQqZhMck+qo0HeLJY8vaMy0NOtqS/Xs
	 MbFZklaXmH7ilEN4NJ/wq18TZzCKaXCS+jCV8GBobGSCe3HE+it+w1/NPvgsAJymUW
	 Ah1D9tZgW0wwMZgz7N5738SaSuJGJJFKG7ThWbLjddNBf+pAgnCP3Xqk+HUBUWLkIC
	 0bixCEiezzLZg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 3/5] mm/damon/core: floor effective quota size at minimum region size
Date: Wed, 20 May 2026 17:36:23 -0700
Message-ID: <20260521003624.84471-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y14AKLXSP8HhOMQomXczok-BS7aderfj_tYG9qdS9bKgvg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A9E1140008
X-Stat-Signature: ty1fzh3i7bux6yoiedkkammiiirht1xs
X-HE-Tag: 1779323792-564047
X-HE-Meta: U2FsdGVkX19REGPphXyRDJ/NFRUEonWdzbMBGYgkfB19GyzJJP/jDYXq6P1KhArjQUQsqOZvQMrtPc4fXY0z4NurQvqwfwaOzUscgnR+xAXJ0yhBOC7WyO4ZdFbFEUdlySwurLlOPmt1f3snRZDze627/lWK9+YdTkvYLSLncZtzd9F/r6la4iUL6EqSpVzmt4Ea7DN54DyiRej6cMa4LEGts08DO3sssv4/CLQSSW3d2xgKjsOl5ivlE4qJ9/ujmkxgENlZdPqhW44oxeuyZuGWfJalX5tbunULLG76YFxuAtT52qweOebXMt8FVLIo/Z2nhyPNqlXlRTFiqD0OYsq6yhImTPPq6DnWe5OBxaVfvOrrQzLB+6R7ZpOR68p0X8UhL5ZXVLwZlxbwFBZpwHsJaDsjJw0yXzdAaGHmWo47Kw73sGPhRVBQ897t63Kq097n5Fuo49vtKSd+RRmBHvtuQ0V2x0vmjy+IzOm6rc4e7k1UU/WAABhzf96/QImhbQeN3Zc2lxS0JRGhTfufgVFi6Kwi2iHjlf+Byx0ivT7JGxoUF44x8Wn3sl9s+1szUjRRsJxvkMpz7yOsPOlmpgojYt/urPQedtpDQ7bNUj7cxcJXkTMr/bYRohBmKW7pSR7Kk/Uemt70VLtM5wWTnwaS2yYjdsp5tB3jd3KKNjaITVk5LwficEg5rCWjrkTCxvVURjLpcF9DHjvSQ+mZQ8rcyTbFoxypa8XUFg/LGm+3Qju1Rw//73VbCJwywqtimNptPoPH025eLjT8IYSfv+3v+1uZoiQ/FXTrTmTVcp5sX0Hhu6V/xTP2LKbYAwzY3Pmoo9B/5u0MTGBDEhPjsvhWKjywTPinCEZ/w+zShIed5+V2kosfP/nn2vuANkjffd4FhsNtEz3CiqGLFg2jDV9H9HkpvLniApe+xb9q1VrBhOYL1BIKVc09+ATdOfMrdftsqBI4qK4JOsQjDiX
 FeyK3TLj
 hGMDchp8UKAASSEvjXL1PIy3su4S/GPUxL2gIk3VW58P4Y8fXHVEaOB8d99x3WlSfRaBw5qpiyFUMQyFnpJTxaY6xFeGrqgUKbcwp3aFc+QUiJ8z5wEadOMxGGXq8+xcnMthlsRNdWXh74zdTuXUto7bG9q0oE0sMyF6wtb2SYOPx3SwCmPu8se41BHCOZX1Twbb4+LkepVp5WEEwPTqTgvMuejN73xvgFWtIXgWpwOjaCFmY7G3DXJuc5pQb6sQWaLO07HnGUIB0S51srFKgVx0AirflJg7s3+9vqRuhzh4eikGXBoXWI8tu4LNPjqO/R2Acb73p7mqxor7cKd2J5C4ws2/Cim3ndLymw5AEHuInP2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:37:50 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sun, May 17, 2026 at 11:47 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 16 May 2026 14:03:55 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
[...]
> Dropping patches 1 and 3.

No worry, thank you for clarifying the all details!

> 
> Patches 2, 4, and 5 are independent of this scaffolding; I'll
> reply on each thread separately with the relevant context.

Sure, let's keep the discussion go on :)

> 
> Thanks again for the careful review.

Thank you for sharing patches!


Thanks,
SJ

[...[

