Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8631DCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6E28E000A; Mon, 15 Sep 2025 14:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957718E0001; Mon, 15 Sep 2025 14:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894E78E000A; Mon, 15 Sep 2025 14:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 785A38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:26:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07DDAC0722
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:26:58 +0000 (UTC)
X-FDA: 83892316116.02.18BD6F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72D1C1A0013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:26:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a0R/xPtq";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757960816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIxbcTD5nYLMJpUhdAZcHPRLYbJ4sAToaaMaZ0lPCQ8=;
	b=TwyxBZb/Z1hzUVoAEOjg/vAW6zctUECAo3NDkFKnPsxcc8ATAv6bnZFl8Am6wDvXLG/cM2
	zrmPDZSPXD/Su4MUyxXscvdS7SkNJfk35c/AF2rSnVz0HZYqgj0k7cuFMjZB+WEqyZ7qRC
	f2xjxEIWiEma4ZS+FEiK3wpzmBZvTXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757960816; a=rsa-sha256;
	cv=none;
	b=glvjDqS+FxZgQQaY7K2qiKbCikVTbIBkVd/HSnhkoP3DJ9JkQfLP22GpDxtQlDpoDxicFs
	sNw8O4K3fXE/yzc5FSKTCHW6IJyogXLwfoCdsgKnOjqv2bz3ypRgkF4wynZ7PA8A49Uw7u
	rO+q68xugAeNic8bP8QkDneoT6U4qoU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a0R/xPtq";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBE1D60233;
	Mon, 15 Sep 2025 18:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BE0C4CEFA;
	Mon, 15 Sep 2025 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757960815;
	bh=ZlwLFFbUZ7SUw1fTcU2d+newTqMg71wB985Uf0+wEDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0R/xPtqF4vOpA4RsS+6m6W4efIbgihjPzTJWDO46T7vsYoTolCa/wg0cQQZWjwLn
	 V2JX80luxNk04KPKMTnH+CAwOfnQxhwHnFZx1PKfnVymKNDkYFdpYVDpBY6dteG5MB
	 wjzEDW/UGZ3Yhp4cYIN6O7GSF5Q2lRCcB5JFUFr3+bK0j1M39jIq77VGseOnszyrY1
	 a4mAfVrEPGTli/BV6+K+v5bLMAba/0PZyRvrswH49qnpGiBpR2lMe3G/RZOfWQBk24
	 286/JS2abr8+pOLycaIxHjnPvD1mt1rKG5s7sYjze3aWO5+tKOs9Rgo6WQo/rRZKEP
	 Zdk05PZeVrtSg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/6] mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Mon, 15 Sep 2025 11:26:51 -0700
Message-Id: <20250915182652.110173-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915145158.1425390-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wi3i1np5ym66auqmowrgtnprwyys9qu
X-Rspamd-Queue-Id: 72D1C1A0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757960816-31799
X-HE-Meta: U2FsdGVkX188kha7dACbwS/Qf6IP2Q71ywj81TKHpiSGgpsBpl2a02M7s5vn/0AcO77wj/kwwOL3PhE31oC7m2sFKXFSlp3LFvmZCQaBmDrwyxt82A3Ftf8ZzWwPWDM+N03TsVLwnwAkR0q4zp9fGMHSEXuYjSoTaGrrv2w1iaVp8V0k+/lLjhE8D2qjR1asqhSVm58q02ZUzakwnzssCJMaiEE2dYrnqFPDerUOTvIyLPEkFiAu1gT/JzUu064C5iQfxnYW8v4/g2jEtXkCUP/W98F5+uacSu/QCrfflGGGQtMpfvx0IEuhs9A84uIIFzqUQ6xn3iLPjVgluiNHLfwlQO5mBuBZ27i/KsA3fd3itq7BG4PANz3UrNot96yUfqsuHZ7upLbjUX7AGcIa91oxshNZZbTFh9bttTOSReEDuT2cbcQIFxTjuZJCynuYuKpx04JDtPMEUZLFCL2AM/pOEeArBlGZqB2M8aM2MsN3TrjeHDZpJASobUnsc91bWBN0/sJ5IBDor4l08gtv/t4kToPEHeTtnYZXCIkSncEvG0I+Z2rZYHFLa3d5IjXcD/A9RSq107r9miYHrmHJbZXkkJwbOrRF6wHGopwS1UWHjeDdR0mgdiVMJGn4X798GeegycEE3bzG4T++aNvv2qABGTFkOhBpZq8hfVE7jI9/AEjSwnIeifTqH5vu+KD24AVTMUSrp3yzDRVJyQpAOWg/WQkjh7qxzOBA4hnLn2cgf0ShT6cSzDmD+4CYTarkH5jbCltGCV1JJ/zl9MpVoHYNScDUbqbXrCi1fFtKgRu8Qaf+gHON/pvjdTcp0d2MFOCw+xY5xg+fGKISthHhtVepXmom2w0CxOxlOYDJx77iG/HIqjY7byuMYgkLQqRQwUWG+zOk5KK1MPvJMlaA+ZFCb8Sxnog9Zywe404fs9ed/MrrMAd9b4MmzzGtHgAZ8vZpdoqYY3W/fa7NcfW
 KKhjQMlx
 y9+3FoI0Lx3Wg23xI3UsgM7lO4pEgd36jg/xJt5Mou9fTS4X5c0KPjzn+05UTQXLfjWkU04eSl0cwltc29KPhbNRqU9YdJRIc+/qlcjhRFZZGz1ACGBIVQdisIr7aCsQh9far2I1XUQjQteB/+dk/VmKEPekWrc0e5RC7yQs+vGcjUlL+9cCHc+QYYncTYhiaUx3QSWThqEC7K3a9zKBJtW5ITGbveJy/eMovhri4e0libJerHicA2tZVYRictpPTb5PDfVabzjMF23FW3rzstPWCC4InhA//ZKijRgmCWwOw7fe7HidMprboYv/FV1zY5655mTX9aBincbZMGK35lbPL/sNVbRRfNwWotvUNE6lGqWh7W9bNEgTCGjdAxFZGp6n4Qr9D8Pb8jQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 07:51:57 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Sun, 14 Sep 2025 18:58:02 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON resets the age of a region if its nr_accesses value has
> > significantly changed. Specifically, the threshold is calculated as 20%
> > of largest nr_accesses of the current snapshot.  This means that regions
> > changing the nr_accesses from zero to small non-zero value or from a
> > small non-zero value to zero will keep the age.  Since many users treat
> > zero nr_accesses regions special, this can be confusing.  Kernel code
> > including DAMOS' regions priority calculation and DAMON_STAT's idle time
> > calculation also treat zero nr_accesses regions special.  Make it
> > unconfusing by resetting the age when the nr_accesses changes between
> > zero and a non-zero value.
> 
> Hi SJ,
> 
> Thank you for the patch, I think the goal of the patch makes sesne to me.
> I have a small nit / idea which I think makes the code a bit clearer, at least
> for me. It seems that we basically want to XOR the two values's zero-ness, so
> maybe something like 
> 
> (!!r->nr_accesses) ^ (!!r->last_nr_access) or
> (r->nr_accesses == 0) ^ (r->last_nr_access == 0)
> 
> Can achieve the goal?

Thank you for the idea, this makes sense!

> I know bitwise operations are sometimes harder to
> understand, so I am just throwing the idea out there : -) 

To be honest I'm one of people who are not familiar with XOR.  I had to spend a
minute to understand the above.  Maybe we can replace '^' with '!=', and it is
easier to read for me.  If you don't mind, I will use below in the next
version:

   else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))

Please let me know if I'm missing something or you have other opinions.

> 
> 
> Anyways, the rest of it looks good to me, please feel free to add my review!
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thank you!

> 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index be5942435d78..996647caca02 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2261,6 +2261,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
> >  	damon_for_each_region_safe(r, next, t) {
> >  		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
> >  			r->age = 0;
> > +		else if ((!r->nr_accesses && r->last_nr_accesses) ||
> > +				(r->nr_accesses && !r->last_nr_accesses))
> > +			r->age = 0;
> >  		else
> >  			r->age++;
> >  
> > -- 
> > 2.39.5
> 
> Sent using hkml (https://github.com/sjp38/hackermail)


Thanks,
SJ

[...]

