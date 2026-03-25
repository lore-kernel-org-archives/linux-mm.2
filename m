Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B53D109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B376B0089; Wed, 25 Mar 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E1F6B008A; Wed, 25 Mar 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F326B008C; Wed, 25 Mar 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A249E6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:53:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C0C9140A73
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:53:48 +0000 (UTC)
X-FDA: 84585484536.06.0294A8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD6DF10000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:53:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roafwc03;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464826; a=rsa-sha256;
	cv=none;
	b=m3rrRcmmknyPUBC16kgKbYB07cBTp7YrziZnrkXb0rteinA8aJ1TWnQeNXvvyZ3Vi/neam
	d1IH5CPnHP36pS+e52DMMwW/Op83RiGa1Wn8NtTTIif02q8a4YPl4GYXoJfzxV4IZH1cnt
	BkIvr5TH/CQkGBsOmWVZeBGbgoUvtQw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/j9jKeHKDdRagVoPDUUSpbIneYDctoXzojYADRmX8R0=;
	b=HkA+cfVPTcwyPSTiei/Ptle7k5cQ9Jm+NV/Sfpn0oseoSsPlcP3TrFWaJSCJEc4vCS+DKq
	re8nAu43KFJPRkSMgBtwKMHrCHEoP4+QwnquliW1jl8MJHVWUZ4g6QI/7jm8G4bW7I/nUf
	tjVDU/jFdmRV7urKPyxS4xegDDOgCnc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roafwc03;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B220A43608;
	Wed, 25 Mar 2026 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0B5C4CEF7;
	Wed, 25 Mar 2026 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464825;
	bh=DWPVkjA08pWs9L84PlqyEpGdDMx3hTuqvHKXD6npiTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=roafwc03MEWl11BuAq+xLv1oJM9C9F93dJpwE3bC8keBvTTjO1PSRaXXKY3j1eVEk
	 tixc2n0tiZ0XVc6fSSR6ltE/SZI6p2GnRKO+2A79CdD4IpA/St+Qe9Y1ugvj3F5omH
	 G+U60lPQPaiCPlDa+HiZuM3chuTulPVsoJownl2aMAiHeBCUvxIF17yJjdfbsV6L2a
	 T1HiQApgoFoG4sqTtRyfkGd/hcoGaeinyDgPikEGkkqiWTYkwtJ0GPbsNLZRrSDtLs
	 DzL6BbhZpy8Bjr0i1lsG3iTkdu0+cFunsruBxv9+id4BqSFIC6CHdmoIHwf0dDpBiX
	 6GRarXRN70eoA==
Date: Wed, 25 Mar 2026 18:53:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <bddac979-24d2-441e-9c5e-529ca2f58366@lucifer.local>
References: <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
 <06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
 <20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD6DF10000C
X-Stat-Signature: upphh8jz1714qwx9a8zcm5t16ju8snmy
X-HE-Tag: 1774464826-680277
X-HE-Meta: U2FsdGVkX19d/ujm2OEFhKs466Q2Y+yIXw2Nfb+YLN9OtZ8n3D8QzFl7P0KFWjXCE0gDbuzp0/IQsJ69CO/MXW+KjfatKzLb2UvT7p9KjT+0iEtra0BmoY0zLUSJ/trMA4wRoDVLk3DmnD+FojXsAMoxN5a2MNGcp+w61oaaumkDwMbWaB+kQJhuioOPno4LJYB+hOj/Sh1epdoM+5Iotx7Rg+qgGlREPacecpngeYGr6KUyRBs5B8Cyr/roquFo7e5aqMLQXbNXPh/9JnAmTHyuHsKma4WYvZ74eyU9DSVkpQZStEShyppBa4kuRyq+V3lri/UbFGtW5MvMdlmLNJGrmSwD7NeUYg7EBr2pMniTLeCPXQlSRpb2Z4wCNA1FMUMny49bsqwrg35fs61H+RNpamK20OUNS3aMYM7dSDeLCgdayte8CXyC8Y4uS5VcigLPAYOuUthy6a/OwIruAcza+CjvZyTK9TUZyS8MqEOclGeoCA67fFGB5kNItqFgtbTF3hvGQQQW3wfKrVTGa9g9jlQe8Bc5Zig+8aEwDwE6zx/c0Up113gnwfs+PDR4Tr0VRTwZZsRviKS3+cfYdbB/S5cJbiV8Egh/dLBJEC2CtuNpJYPVGQIawhEFnm8jD3vaHI6F3DtjPuORLw3Jojhc5XuKx8f9EvzEmYE5h2yb4oH4ne/I9T6oUDds92mTlwvKlL2qFKqO7VbMElH/8FuACbdzcBPLieEMEdBgv9wv7gffJD0WOUjnfaJUnGa5De6nqWRVWGsYjQaPXX2fTBS8IoqgNslTm0gRyFs8rIckdH8GsJon5M0jkghZUvi/TwEb2zFAEhOWrctbF7lSTr1DjEvjOQS4PvQgDSgWoazH8dripgfK+o0WEm7NcQu6dsH86tKvmev/7Uob/AnRLPM1hH+4chqnXKDXu6O79lC6wezxlFWhXK/DNb35suKV9kKyMMcakz1RBRQRS49
 O7K4zzD4
 BqcmSnl4Va+dTCsj85dW6Ki/46cYkCsZpePTuwyX/cQ8jnd+wuJOS5sT0uq5uLiOM+9XzSv/Oa/8jGZlmqi4vIDQrxfQ6ISK+EHles1EiegGZHjlmnKkz+LbM8X9M6F4Ikqya38O8vTqaEGVBaszPs70JHSQdDajn18hwHbXCIDUQZcC8M/yCWBgbrVlDcRG6tSAvIbdoIo5eL5MCG1qr/tiv2EkC3uTKxfAP6qHkz2ajf7zBf2tG/rFLXoqw13FpetXngPBrrmFS5Mg5LG3lFefJbIBLYWOhWrjxLxnYTSDz0NGpk8k70Kh353fpn6NGD+Pn9tOQ+lbMUcGxsZXSlz+611a+MJKQ0O7G6PYy966mxusGjg23EvdMYvIUjjPlwnZMiQOgsk2Z97BTK0crwk8z/k9g6oDwV9AXF4elgFw3B5bkbR9OJ+NB9UGJHJMJFiCwBo5vHPoSSgAfTqTw086sWbzkIqQR2mEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:36:50AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 16:26:12 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > > hm OK, so what to do.  We're OK with teeny -fixes but anything more
> > > substantial we ask for a full resend and I do the heres-what-changed
> > > reply?
> > >
> >
> > Yeah that works for me.
> >
> > > I presently don't fold the -fixes until the very last moment.  Could do
> > > that much earlier if it helps anything?  Possibly useful to people who
> > > are looking at the series in the mm.git tree.
> >
> > It'd generally be easier imo to have those changes folded, but with something
> > added to the commit message to indicate this so I can know whether or not that
> > was folded in.
>
> I always add a [footer] when folding -fixes, eg:
>
> [sj@kernel.org: verify found biggest system ram]
>   Link: https://lkml.kernel.org/r/20260317144725.88524-1-sj@kernel.org
> Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Cc: Yang yingliang <yangyingliang@huawei.com>
>
> So one can simply chase the link.
>
>
> An unfortunate exception is when the -fix is from myself - I don't take
> the patch from a mailing list so I have no Link: to include, eg
>
> [akpm@linux-foundation.org: fix spello, add comment]
> Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
> Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
> Cc: Joel Granados <joel.granados@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Wang Jinchao <wangjinchao600@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> But these things are usually quite minor and the precipitating
> discussion can be found by reading the main Link:.
>
> > Maybe just directly squash the commits?
>
> Not understanding this proposal?

I mean instead of having a separate commit for the fix, put that fix into the
patch before it and denote it with a footer as you put above.

I guess that translates to what you do when you rebase and fold the fixes into
commits as you do now anyway.

I don't see any reason not to do that right away, as really it's good to see the
combined change in one go for all practical purposes (if I resend, I'll be
combining work, if I can grab it from the tree and avoid a git rebase -i all the
better).

Thanks, Lorenzo

