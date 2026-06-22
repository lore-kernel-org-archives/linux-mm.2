Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809ABCDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9446B0093; Mon, 22 Jun 2026 19:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A296B0095; Mon, 22 Jun 2026 19:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353F66B0096; Mon, 22 Jun 2026 19:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED8EF6B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:46:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57F514019A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:46:36 +0000 (UTC)
X-FDA: 84909185592.26.9BBC5DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C651380007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:46:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKui55gg;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171994;
	b=LP0YjbwZoucBsdx8Twok+hNffgJ1MO0twsc4kh90FsNYNkISPEM8/l487AkS5GljzYD28R
	6sOQZo6P6hR5IU0feF5nE8ew84XLkbFSUt6v5/3FGFJtJ21hc/4tUscazHxKuTKqPBUYWO
	/cRXrc0uQEfz6VpCorTrVsx6iIr3trU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSHJBLoJ+dWJVwc5iapW1lVBZzDPVPjrz4FsQ/5Y1tk=;
	b=lbhLHoGHBDTV72s+BGEwQM7GK1ejQdC0pWxSQZgWdoYktOJnuOxV2GguXxDkdH8Yn4E4WQ
	3IiMwSQRtVOcxehvDoB13GA1xY00ON1MTH0wpDu6LzbPQ0lNZjeoKj3UAnScVv0oMPFDka
	x9akMNedJsYYbPJ7Ai9EFVqUVJLWv/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKui55gg;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BADA6001D;
	Mon, 22 Jun 2026 23:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238551F000E9;
	Mon, 22 Jun 2026 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171994;
	bh=ZSHJBLoJ+dWJVwc5iapW1lVBZzDPVPjrz4FsQ/5Y1tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKui55ggl68KS9bfibjffBO4ATEI/oVW9g/Pk10ECXU+bxP6g2lkFTMq8djcKoU90
	 VDG5MKH2LnbbMyouefWJ9gQUjJHX8x34FnrAoT23uTQLur2JLKUDEPV3q0s/sLDIbX
	 RiNeGidw/W6BATanNE+zDxALUa0711gHkM6ugW1VpZ9VrHtDJVvFj6jpnEAdIOXfJa
	 rEAbm4LwbPbTPeyXzpgSsNTIXrD/bKxPWtS/Qy73vFd5iMFMmXzFNACWfk54Gg/TtN
	 7TsitNVIHlwCMDldQcFSxmuivvqJpjdo30zwWlJtOV1xMU+SHUY2i3Vq2iBhCr5SO/
	 Oce8IZRL+oROw==
Date: Mon, 22 Jun 2026 23:46:31 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	youngjun.park@lge.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com, 
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajnIasdb6j6yDUdy@google.com>
References: <CAO9r8zP6zDshSGU4chaHiPocahQZpiK5Z-eP9VKH+2_xjNM+4g@mail.gmail.com>
 <20260622231948.1002174-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622231948.1002174-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Stat-Signature: ufw6n5xqtr9fkorg6jie7rox671nyebi
X-Rspamd-Queue-Id: C651380007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782171994-953425
X-HE-Meta: U2FsdGVkX1+yiNyuhE0n1T6MsON+eiuYRYmAgnNm3aPaPjcteF+YEVtOrQQLrV1jP3hBZDFOn5gxdjd8m/H7o0Q9aQ9ZCV0UB634G4+6p6qNFtW7gtgyBae7NBlFk/byTbtBhpQh1aRyd/u+/h1PBH8d0WgB1CmZdJtz9p4xup/wmhXKUQ3/3Hx0lk4rZ9tb74VceL4cXc7ERzaVYXCkYjc50E95XrQGYT652PDIV1n2g9nBIRLEoFwauet2j3pV5pOpmA7o+ArumOQlksj6hIBAqzA4eNNTRSn5vL7YDLpoxPBP+ZaQTZn9gI8YLrhfJ+fQCD82+juB4Qn2ljwcLUscdAMCMqR460bCmxFZ9QRwbJTl8Ct6Ol5xqEdUVHiB90uJ6tgq7fdi3r1NuLRYMnItVaUFMtliDQY/XZ/XA0TCjv47kP8xduvplUB4I8qaK2Jkc8Xgfx7akzJbX0D8VZGa1zJN4/qJqkBenLEC3pRLM5Gwn60aq2+AwUKW4FeBTwp2HN9EcL6Dic5VQ9nEKo5kmfFFytgyijtdwsrq9FQETxvDw1s09LqT/biExxMnkMWlJ+0R7fR4uV2xys5gaxNwBnwywIUHlClG8ASPsN6Kz4PUq43qdcvognm3ZvkR0o/8fc+bUUHhx6OIm2UC1bhnK2/58WNDvB2Qs67neGmjcPUgJlZn9xbGsMm2PvCPNYDBdjZwkOeGAYPC2g3iqyQEoiQS0ezzBW94TQ7s486gaqJSCdNo2q/skUGAXVP1L5xKVjxGjOzYbrqdIv7cAodAtcldIWc63nSeODkv/vzn9bMIPCTfxQE9z02QTsJAkwuSp+T+/tY+zY0LkicD+wjJP67KTIgJH24pzqLHbQear11KUJRalw1Esz/t+DMutBEsqtBKWiGXWz2dcveIrWC9NbnHMIfOK5E7MGzFMyh6Elt5jmPERQeAc7pyHa+pOdVmLLkcFiVV4KZixce
 m4EsJh6Y
 UtLOwtyJFTvs1uZ+So7r7wHzGXszHeXrmr30DNA9Bc6FbU1HwUgfDkyZjRUwAQTYOdtEtCel2hM9UVDzigUxcmniQa+EMFsrqgvSBnnitkwOorFYrVbcz8XKwummVuz7Ipfz/FqGkTu3lbERBoyr30IKrwOC63QIGoPwnDIoiN/RoKrgciCF3TRQyBYlv5OqJd8aR/+s37zp98ZNz4YvtM8Aw38CwHWGGvrWyExVIsSm7LdRyGrZeqB+795txSXdA0aRJaQNKVb5ufrVr3LfQdxuELb8Ymr5zDnQn+WHidt9ibI3WUktNhLmFpc+XYHMgrZojBPaBD150RGKCJtAoUzYf+EsAtTrt6k/eoSTsSspKmGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > If that is the case, I think auto-scaling makes sense but can be a bit
> > > tricky, since there is no universal tiered ratio; each workload will
> > > have different tiers it can swap to, so they will all have to calculate
> > > their own ratios. Tiered memory limits escapes this difficulty since we
> > > assume all memory can be placed on all tiers, so we have a system-wide
> > > ratio : -)
> > 
> > Hmm I don't follow. It's also possible (maybe not initially) that a
> > memcg cannot use specific memory tiers, right? I am not sure what the
> > difference is.
> 
> You're right, I was speaking more to the current state of memory tiers.
> The majority of the feedack I received was that we already have too
> many memcg knobs, so I just opted to make tiered memcg limits a
> cgroup mount, with no ability for individual memcgs to tune their
> limits or opt-in/out.

Right, I think this is similar to the approach taken here. We have a
single interface for per-tier limits. The main difference is that we're
allowing 0/max values to disable/enable different swap tiers per-memcg,
as there's a use case for that.

Seems like for memory tiering there's no use case for that yet.

> What do you think Yosry? Would it make sense for us to be able to 
> tune these values? Personally I think it makes sense but just wanted to
> make the basic features merged before I went to push for making those
> knobs tunable.

Right now we're not proposing to allow tuning swap tier limits either,
just enable or disable a tier. My main question is about the default
values.

IIUC, for memory tiering, if you set memory.max, then the limits for
tiers are auto-scaled. I think it makes sense to do the same for swap
tiers for cosnsitency. Or am I wrong about the memory tiering limits
behavior?

> If we want to make the tuning the same across swap & memory we should
> probably align on the file names and how we interact with them.

Yeah I think we should make the interfaces as consistent as possible,
within reason.

