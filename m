Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BD4606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1JDXHfK
Received: by kanga.kvack.org (Postfix)
	id 210E06B05B9; Mon, 26 Oct 2026 09:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8116B05BC; Mon, 26 Oct 2026 09:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127D26B05BD; Mon, 26 Oct 2026 09:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA2A26B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:37:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F475140730
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:37:07 +0000 (UTC)
X-FDA: 85364878494.25.D165969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CC258C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:37:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1JDXHfK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yabj1QHzxuPl05POwsxt8pGUgDVyDjWk14HZZE69wyE=;
	b=vLQEYLBATLVeKOVMSOaEgDSMEmLzYVbjoBE6gQPCr1DqdXHXVQYKRTLrUvVQtOoir7TJcN
	d+gInfHLweUXojC2Max/O40DUEZnZVVVrAVOISc9K/Pk+VFjCjjZD2Harfl2+yq46811YS
	NeGFZN/sFpynnyQm+LgPu0bw26elKMs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1JDXHfK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021825;
	b=7cW8c/zdwqFq/t9DN74kTt0HNihtlKC9GGBfjS+mziBNGmJ2s+rB0YdmBALShHcu6VkzQ8
	zavZjQYTPnI12w3IHYaVoCR8kRURrKDmj7Gx4dVNEFtaIKlyDabNRW9Wo3Xb8rIxICyy9V
	ndvJV+p4fhDSLChNSYvw5wHr3zX7cGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F88F401D3;
	Mon, 26 Oct 2026 13:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8512D1F01825;
	Mon, 26 Oct 2026 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793021825;
	bh=yabj1QHzxuPl05POwsxt8pGUgDVyDjWk14HZZE69wyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X1JDXHfKBCQHRpmIOeJKdV2OiXBauhmvwQ6KRaKHeIOWf/dJWYPAU2RzbumxF+Eam
	 XkHep8YA4WkK7dur8FFn4TOh6ZDR2OHNLhLADSTb01Er11rdhgsj0R1lTFO4s0XIIT
	 U9strcR4euCGy9aJpzdM+uJmsyF0TsIt/f1A8pe9Ofc8JIplQyJNgRxTRJa14XeAh6
	 3tr1Udq2aFTwD/lDFS+2mK4h9A2mWEeZRfEU7gNIG9YDdz/21LBGy6RiXJwaKGhLUA
	 TfW1pQKHd+kHTvVXu25rE9utOsVaHuQqxieHc1Vxqf1nv3jIRPTIAirVTiQigY5s83
	 r/JOz9OuviUKA==
Date: Mon, 26 Oct 2026 13:37:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Message-ID: <at9XPebgW02oF5er@gremlin>
References: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
 <44a9f234-aeed-4986-8660-608b8a23ecdc@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44a9f234-aeed-4986-8660-608b8a23ecdc@redhat.com>
X-Rspamd-Queue-Id: CC258C0006
X-Stat-Signature: z7asuojg6dzotdugh9a58barhz9aakqi
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021825-704985
X-HE-Meta: U2FsdGVkX1+SDsSmMKrnfoZis3/DGrFZT0i3fDeJ39EUP+wGk961yq36I4G7MAVL7NnZVVG5SFz37QfSHdSgWVYdXnXgQuwzfJ24WgvHK5eM7pKTzqNZFepmvR1AV6nWi9CXWRXCXtem/Xg8g1f+V21nikaXtVL8zm/XYQHFP0V4b8Nzl/HwRSysFJ5BLI6eyydmw2mHrt5uAVbnzJXFy3+ZCKPObrWUAAX8XLUok+vxARsM53PR2Uw348SVLMkA1MIVmdDhqDpR0wYXEKdc9nGnoDcXqf5g/pDJl5CU+19KayJjeASOimmahJ5KK2vdQATXHYpwQdHZyHmWdUerHbbQuRqlXNG+5dVK5VX8WsOCkEe1MMelmt1OUwcjm/NR1I6VDztKLJpc3ErC2QjS9rHOsPlmUzISC3y57K0GoGgJQAfv5nDZe95Y8efIkUcnEg2aOIUq7EMUEc1dbprBqDPLCd2AzgLS10HVHj8BCgZgTlwgU4sX6QQ50Sl22cSvnm+DPmNmXkthnTAz0+jqx5EVzPVXKlHVegNy4/Jx0LStUVICT0tZQpQalvmVnSymiTihTvaFZRGpCJQWtYUKlXROQNFYysGn3SrJjuuf94ZX0uQGqERLNWObns10Vr1ohZGD5ApqVd8IAjw93ZY9EbAXeV5GRloT71TmYE/S9x89kBJVEQVZMDAvWz2rDI4xg+XVhfGhNccuSkvOlMZW6HfwBAPXz2/rT34O1X+kSih7p5JIIujCK1HPhFNSkKygQlgb93dqfu8SGN4wq7l50SQq898PTDKohBgtPCaPu+8W61c79ImpJOhlvCEfrR3UYJAc8Ub7Por+QWCFWeUeB4CTGwV6eLZjVTX6LRiYtdLHcaxkiucpeSG7qFW07SovRQI+/mhc/vDNX4jqFyZ9IBND0Em9xzUIzyLpf9IUaFy4yor79eod4AioVn1Az3G2wlkCQOkPGy1BekoLLe3
 BXVigBTr
 RHbUnOgQbzBRc+3yHGpRwG+YRWX3jJR9JvOKD7RSDmZinbTOUoentDw6ZTbGyEuP+xgcRbGmQCUnyAmhVZVCoap1f0cu9CeV6z8GeJakr2weXeeGhh6m3OBQsizMV4uCFfoxvSHmr+oBxO4+SVtCYUgCy2JX8VxZH4dGZ+1AS+TYwnuN7am8rFF+benKpeMDGhcxyJogp6V5mSLeFLKz8dn2U62NOE6AxUBq1f9a3ZOrut1+akuey28KJtcI7cl5hjLlN/e8pYxX4xaDRdPKv9ioqOvVZQXUkuUsRUuV50XT5hEz2cl2cd/UIztk4glSUQl3so4ZpVnF1Q91K2p0fH7EuiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:11:39PM -0400, Luiz Capitulino wrote:
> > Reported-by: Luiz Capitulino <luizcap@redhat.com>
> > Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
> > Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > Confirmed that this fixes the repro and passes mm selftests and the VMA
> > userland tests.
>
> Thanks a lot for the ultra fast fix and for the attention you gave to
> this issue.

No worries! In VMA, we aim to please ;)

>
> I tested it the same you did and (of course) it worked. I'll work on

Great glad to hear!

> testing it on the environment that reproduced the issue originally, but
> this may take a bit. I'll report back if there's anything unexpected.

Thanks, appreciated! If it's all OK be good to get a Tested-by also.

>
> Another detail is that I see that you CC'ed stable (which is of course
> correct, since this reproduces since v6.1) but I guess this fix won't
> apply since the VMA code has been changing a lot.

Yeah, I'll deal with that when the backports happen :>))

--
Cheers, Lorenzo

