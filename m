Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5621DCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 02:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC5D8E0008; Wed, 22 Oct 2025 22:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD438E0006; Wed, 22 Oct 2025 22:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3C58E0008; Wed, 22 Oct 2025 22:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE628E0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 22:45:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D40191409AD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 02:45:45 +0000 (UTC)
X-FDA: 84027838650.19.5A28B70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2A99BC0006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 02:45:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DELixs+3;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761187544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPB+BwnbvlUAkup11+g5rax/mv9ihtBFrurGPBJlpok=;
	b=xRffMCva1aIZx4odyIvq00OiW3SGIqHU5NbVBdXp7VuQesfytP1VUIoB+sinUtiPp9BPJm
	WXOqUEu8+LtU9XqM3Po8pf/GuLEmVoJisylJHEzWGUNijQciA4BAJi1MnVBGezUGxeEwyG
	IfMq4I+OexqOgTngMgCidvOMtBBm/34=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DELixs+3;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761187544; a=rsa-sha256;
	cv=none;
	b=P3IFlDyj1QhjM2hHDrs6JoU/6ApyN7yN1N6eeh06bPSRI2BzGClJFCp1gQhNX8kxOkMZNT
	1JRHbOHNWxX69OnRgK4T6Up5CSqHMLrq3pHtzSdsc8A7OgZIxP1iVniDRroWRNejC+1ICG
	VTA6SflJCt120dnucrM0p7zqiKWNYRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 533056013F;
	Thu, 23 Oct 2025 02:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DA6C4CEE7;
	Thu, 23 Oct 2025 02:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761187543;
	bh=o8VZqgreM/+4inCjv3Ryf7+yviInpAaMHdtb3IX6YvU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DELixs+3JW+JqnfawdV6brsJEThbe9/wzBqUgy/CUKJ33mQbr/BNONavmP8E0HGmP
	 LaK5jWZXYUAPerhqLMGTxgezcGLObtdiHj1XYVZ5yZ+jM2NMPeGFLfnM+QoPrdasYj
	 YpIKZaPl6NCWE/BnE5KbZxY4FUD4zn8v2SG8wtxs=
Date: Wed, 22 Oct 2025 19:45:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, brauner@kernel.org, corbet@lwn.net,
 graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org,
 ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org,
 tj@kernel.org, jasonmiu@google.com, dmatlack@google.com,
 skhawaja@google.com
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Message-Id: <20251022194541.68c26d16b615ded15c5d3014@linux-foundation.org>
In-Reply-To: <CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<aPchmxfh4ACM0vY2@kernel.org>
	<CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
	<20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
	<CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A99BC0006
X-Stat-Signature: em8jf5d9ewrofbuf8i1keknxwyfeugpt
X-Rspam-User: 
X-HE-Tag: 1761187544-350538
X-HE-Meta: U2FsdGVkX1/UIEnfav5IXJuwgxNbk4MIED6TYmZ98jj7LC9Q+L/89QSS6FlywVoYv7v7Fx9b6GaHeU31+2/igpqLoEk+0kYJxjwA/Q0qs7YIKn+cLEtaKgtP6pTTm+yoT3PSP2/rQAqytQqMJaK3b7PKXJY/X3L936TEb5zR9msz03X8ahZxrxGRYwhMQ6iT4efTJKcMAtHIXa0P0eJv5eicSJfSY4Zj8NKid4TbEPYhWo0SndKnSjFLQssqa8I+dIk6cUs7krRXYpaPLUJD0FS7VmZPy+EmoYh8qPg7/PUD0a0dekRmtpTmnJRZy/gS3IeHgTyKCc6jcv4dcpJQW5mPBCxigg7S8CLCa1yRf9XiVDYT5QFaLCCuUrWv2t7d48OxkAT+CWNlCMsZmRQyemWslAE9twdQQ30GY32lMZMcz+Tr6kteZ16l5Oe5Ahl1RZ+p4QCXct7LagxztQbpKWcRM5AgYCQ1lnkfxfQ4xjYxvof/fDaHy/FACW9fV4ygcYhK5dgzuS5PoWwj11BbJODhNuJBVg+wGQq/mgheTkBxfR5MomFzTidM25mKFfoaA6yIwEHwVtqnp+sEf/xt7KsIxtuZ9U14ixEAKsQINAg09/h8+PC4vLtL0IdNtgCNvjWjdPDuJC9j/hWEpdyLQzi7nbVfuQ9q8eZNh+tfnt9cz9UvKoSuZf/NpaVvzSlgWUBviiQyjpRBNH1k4hsRV5TkyxpXt/ti3QmVc8atZ6Jd9/nIRIiqWg41YzpnRVTsckuZodZj2C4Mhmissknof5MHUd6ZanCaU8GI/Q7bJ1eraj0DMMFWdwlJ60u6AwnURwewHWKEPkSOX/jA8/GeAJUuacSUjwlJeVhWQCRqHfGyStY0ocGtXeyP57WwqUNJ3vRt6J/PXpTF8oLi7ijJK5eTLP184eDPHOsSl7EW5dA+nfNVuuYTkQ95gC1xzflPuld9uIoZcTV6SZknnO7
 DobgqOo1
 KUKCDafgj3R6GgBGs5dIa7LVBkfVsOnk0WnOoaGU2/6yHu4gMKa56OjR3UvVehZH/JA6LOH0X0w1YbMnkBc196+pr4mXXWQOVhDm43EwyUhSqB+Ti0Ihci8D+l/AjwHm6SPy6JnWd8kClmI45Bp+zQ3bmdsPqnvM7H3UW4Ttd+PDBMkztHTcWCHOE4tu9VegZ4gJm2j84ot/JnfTOhn7WUdZgsBYnFpwE7coNhEx8poNUdaGhvzN0pOTw0y6mLgT0VGLu170+iUQRm5nxkfvMtlsGFi9BCjWRU1Y57L53+trYVs/ohe+YFMEFXeOlVYlf9mnmQgOZSsVrL5kUT6ea7tOkchUQ1wfeZ7203h+Rfz9ZfuOVNSLUS0QeiYHBv7bxb+J4BfKdXtqOoryKs/F4jqNDXYgwit03UGSy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 20:15:04 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> On Tue, Oct 21, 2025 at 4:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 21 Oct 2025 12:04:47 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> >
> > > > With liveupdate: dropped from the subjects
> > >
> > > I noticed "liveupdate: " subject prefix left over only after sending
> > > these patches. Andrew, would you like me to resend them, or could you
> > > remove the prefix from these patches?
> >
> > No problem.
> >
> > What should we do about -stable kernels?
> >
> > It doesn't seem worthwhile to backport a 3-patch series for a pretty
> > obscure bug.  Perhaps we could merge a patch which disables this
> 
> We are using KHO and have had obscure crashes due to this memory
> corruption, with stacks all over the place. I would prefer this fix to
> be properly backported to stable so we can also automatically consume
> it once we switch to the upstream KHO.

Oh.

I added this important info to the [0/N] changelog, added

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Cc: <stable@vger.kernel.org>

to all three and moved this into mm.git's mm-hotfixes branch.


