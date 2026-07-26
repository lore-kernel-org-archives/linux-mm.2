Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCBEC531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 03:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9426B007B; Sat, 25 Jul 2026 23:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A07F6B0088; Sat, 25 Jul 2026 23:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF4E6B008C; Sat, 25 Jul 2026 23:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2E16B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 23:42:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD252A0441
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:42:55 +0000 (UTC)
X-FDA: 85029531510.11.9E6643E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 559DA40005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:42:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sj6+aXhx;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785037374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qyGbIXb519uDjoX4TpMXmvDySS+tkP5wly055S7W94=;
	b=Wcu1MuiJeMoLcNQJYNWLzzWY/Jw3joRdWApjJ6fvyMlsgoei4QYwGh3VRgxb2D3oOL7SXx
	AaZSPA0N1eGDTtdj2EMd4ixbS+hBRtuOvGtVjAcJrFsA22aiojyjDIx340NeIoNvQZoHGf
	HS+kReevdUeKgrNxA62PAg5ZPmoi4Sg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sj6+aXhx;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785037374;
	b=00mAkujGLkvCDs++omZ57JH3t5DwSIr67R+dYT1dxOD2piPD7lR0UjLlfF/E365EdB9yNN
	JkIwavdFv/noXEanKJUEzUVIKjH72OkkIcdgkOVMxlpCHx8CeovnWEOZJxocfHuePtTS9t
	F0eXysdB7D3HINCca6WGnCWls4EvUMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EEBB40182;
	Sun, 26 Jul 2026 03:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71621F000E9;
	Sun, 26 Jul 2026 03:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785037372;
	bh=3qyGbIXb519uDjoX4TpMXmvDySS+tkP5wly055S7W94=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sj6+aXhxl37uZ5dhwMi0bnZSS4GxR4ATQ1YcldCJnihgPGbcuIsyon0dtoNQDe7Tz
	 aL/CRp1Oo94ZoaKtHHih/7Jy4yRbay8z+cmBwmD516AoJ3DmcqqtYtDXcxOt2WQDPq
	 /VkKXCzkpjwmsI6ZizLF5QTWSPtnwO6kuzPBBEKI=
Date: Sat, 25 Jul 2026 20:42:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is
 superseded
Message-Id: <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 559DA40005
X-Stat-Signature: du6bzqxi9nyddnbdp9yea6utop3ynz8q
X-HE-Tag: 1785037373-81793
X-HE-Meta: U2FsdGVkX19+j3aKIcn/k3ipZquGYC3Q+cteAvt+zAk/Ap13SDn4RPj9S1ou2uw10b8CbMkXTlPpKuuXSvR1J97qMQFq+tWWG6rqzK6RbrA9J7KNAo66/9dpurxIF7etCts98+TtnaqsXe7ZuW5rjB4Q9h7bMH1bzBlhinDSr9Uwx3ifmNSfDSrflj2uG/qLVy3Jyad2pxRBrEqHZV35OItxh7fJ1FKivjTZP8VLSobRQ4IThaeE/n2/mVUtEMkp0Y/v1ihunmBe5sS/XgLR3/SHKwIagaeI6fYJNglGAr39a6rYWGOkMnZQCf2VnpuiIUA9TCxpYh/59gjKsXVCG1/1P2o42Sj97RRbgw6eE1s/gA4xhhxKuVcsuNA5W6Zcnpa5Ty+vtCAiYA24tjxZOYtxroahqHLOeS8WVymg8cAAtFxQiBw4EBPmUHvspH19Nqxj39tuf2/1rWmiksYkk/bEXYt46evXU72dEZtjlaObw6RI9e905iDrQRd2qE/qfGEsxd9veP3VySDG0LxfXJqFwCVZrpcRjr3kf/XUL313XUqiwgS/S8tfBpHZ8+lvkmGdToJ/IPEVVQpn9dpK85Hx/BylyrFgN0bMHZ4ZVlkt8gvBZhY+8J9xNuUn0p9hys0uKjd+kqJAL4ku5pldxFHkY1FaqxohPdQVzPgJRdQbDjf643kWFzwCKHz8RgFQ+nVPaNJmOuSyBn+5dEuYtNa41AQuMs3Tcp2zANRRpA5khn9EaDF16CCRIGDFAEnuLwbmVqEgyPb7kv0V5E89lWQMEJP8tlWSgVSJWQ2lakficOp2infuE5FK+coGLszwQ8UcptqoYGDNYrcncPrHVlGtsh9BNu59T3iMDKcWE1Jw4JTFYxkb8Iwy2wEOLVW+uruawborUOfjTceqxiDZPw1J71VqSt3Nq0mMn9Msnku+TgGXc63PwePIlkd25SOJ5GnX0P91Tt7y6BZPsLx
 mbfusVo5
 AGxyaIbtZPeg7QPmhQpNUxDvxkwnkUA51Eo4yiL+peOiQOFgcaLXpMZoTPvodCjHYBrhooc4rpj7cxq9ipF5Scc6S5hhThA6YJnCSCgAvMwFzJFMRQwXL3btYoPkMMuAehVQ016LiSobkJMM0bsiaHbiuHnxTuOioZNrkPNSI2U3EJkQmJZj6Co6wtYCGyTHnhvoMP4A4BE0HQz9CU3Ln+Fct7B1JoCJ7WBvSh5oM3D6CI7lniRsLP1ZXIx/nQQ9JhG4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 10:18:05 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.
> 
> Check the current limit at the start of each reclaim iteration and stop
> if it no longer matches the writer's target.

Thanks.

> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")

Dec 2019

> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")

Mar 2016

Having two Fixes: targets is confusing.  The Fixes: identifies which
kernel versions should be patched, so how is anyone to figure out
whether their 2018 kernel actually needs the patch?

I assume one of the two hunks is for 2019 and the other is for 2016, so
two separate patches each with a single Fixes: would be more useful.

That being said, both versions are so ancient that it probably doesn't
matter.  In fact the bug seems so obscure that I'm not planning on
adding cc:stable to this anyway.  Maintainers, please advise.

> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping. Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter. With the patch, it returns normally.

This is nice info - I'll promote it into the permanent changelog.


I'll queue the patch for 7.3-rc1 and shall await maintainer input,
please.


