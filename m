Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9147C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646496B0088; Tue, 29 Jul 2025 21:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7436B0089; Tue, 29 Jul 2025 21:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CB36B008A; Tue, 29 Jul 2025 21:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41CF86B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:33:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2005801EA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:33:13 +0000 (UTC)
X-FDA: 83719207866.28.9B5FD3B
Received: from smtp233.sjtu.edu.cn (smtp233.sjtu.edu.cn [202.120.2.233])
	by imf12.hostedemail.com (Postfix) with ESMTP id E00AA40006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:33:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.233 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753839191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6OFjto7PTscQZT0miszu9LQbwXIwKhs66DYveRMFiI=;
	b=sp/YPzT5LkciPCji9Nto3gWWtydHYydxy47IVsLeZDboW6HsgzGiaYwJcf7LKmGRvxYg7U
	DU6wHIgLkRxdh7ytIM8QP8WxF/Gg7Iva2Bjtm2/e9KvSmmlOjNBbHyy3PC4wdWVuk12SR7
	iJxdcrcCghpPSJGbNh5bTPU17MXemgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753839191; a=rsa-sha256;
	cv=none;
	b=RqW6lfWX8moztYVjnUWggIJrrMVlSd1Z/U4CNlth+9oC2BA4vpRIof50Nyw2FarSaHInk6
	LZ3Di1LbJEHZggawppGn3qpZW9Rsmi2P7vStbAd3kCnxIpZyOq/CCJ0Z5usBeoPJ6my74I
	HIB6+5T/OSyE9ZMNGVr7Ynphmcw/EXU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.233 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
	by smtp233.sjtu.edu.cn (Postfix) with ESMTPS id 0405011BD613A;
	Wed, 30 Jul 2025 09:33:06 +0800 (CST)
Received: from mstore139.sjtu.edu.cn (unknown [10.118.0.139])
	by mta91.sjtu.edu.cn (Postfix) with ESMTP id D706E37EFFF;
	Wed, 30 Jul 2025 09:33:05 +0800 (CST)
Date: Wed, 30 Jul 2025 09:33:05 +0800 (CST)
From: =?gb2312?B?yre8zrPJ?= <billsjc@sjtu.edu.cn>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Message-ID: <347115630.2886123.1753839185240.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <87cy9izcxj.fsf@DESKTOP-5N7EMDA>
References: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn> <87ldo7z5a7.fsf@DESKTOP-5N7EMDA> <93574E04-0528-4282-B1C3-4A16D9768EA5@sjtu.edu.cn> <87cy9izcxj.fsf@DESKTOP-5N7EMDA>
Subject: Re: [Question] About the PCP free_high heuristic
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [202.120.40.84]
X-Mailer: Zimbra 10.0.14_GA_4767 (ZimbraWebClient - SAF16.4 (Mac)/10.0.15_GA_4781)
Thread-Topic: About the PCP free_high heuristic
Thread-Index: bp6vOpbllXief0WSEV170JcAaY8XYg==
X-Rspamd-Queue-Id: E00AA40006
X-Stat-Signature: rqj818zr6dwbh6e4d1bgnqazdhnkdj8f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753839190-994584
X-HE-Meta: U2FsdGVkX1+Mum5iZTo9rc0YGuDtOMjCs9+yFDgxmgvvfnBpyg/8/BkW/BYlDLqvRbdSnqAwvCuoSI1EGjDDN4v6Z22Xl7kgeEtwEydD+rZGuFTlwFWQym9KpeLo0kQad7Scw1LjMMNiGyclwechubYD/MucJG778oktLM0JYmo++3feWlAb6dUiUNO3RLrmNlEylRffbxnhgnr14CcYiX3/SC1XgBiCMyS3+ZbAHqvotZ3qw9Wgk95NeQgBhjNsZc01iiLiCrU4wXV+WbbZ5y32GlomVqH/C5Fa3IOoJ4F5Q+nNgwMx7Q56jYdH/DZaCIoM0ZxfgY2xEzurbWplnPnzml3FST1S3mPXbnSjS80lGFfBuLln2ePLy6xhjANYkBe5svxgFDnPOOAA6W6smXWAQXFLczqWwMiv7HM/eyUgESivSS0WYo+dMtMciTcaTHZALA24HLqivuykFx7RFmRy8IhYqsiQNawiJhic0NZYNFEjankIH3GiDmM1N+iqKKnq9vYfZe73fr+SKD22FT13QjFznku6B/hoNzY5wzZUSw5fB+L47zx22pYv1u5tkP5EqKyhVE/O7SaxMFcRcklrHXG/AxP8r2KeF2T/oOGxg0TzTGKzhQi5g07/GsRZno+9+5MGXHiPDri3ppaih+lhCFYSc9o4+K+HnISphww6P0tMgdTBgd4JP5Imc9hVhQek+Y/6d4NZiRUdUDD721gcYgzR2jQduTROX62U338APzlYQ/O0sAAzY4o/3LZTGlk1oKcN1e6JILJ6VVpgRmVyS2WsnVDJ7h7Y7b/vR0ju8UinQW+k8ks3gCDlK9S81JiJl8vLAFFTAmfN/SpOii1pTq2SOIJFDa2rxeiRkUsVnXSvUozGAhd8ycsuNR9HPt9j9TipGAxuMJhs4jt+EE7O3XklxW6lfg10MEGD441YyJbRUtlTWYp2kDar/NzJf7P8DZ+ke3AG1aWeJqb
 F5LO7V9W
 RFCdXszOzmS6TuzWZmeA7lh6GWKBN9zm5icDqzkdStOQWexcbZ+59QlD6y2fVg/FILNTkwdxEbtK+rx6kX50a+WWrjnBCInDjPMlLs2tmi2Mls7WEtWDlax+zPXEE1jxU6Sy6f2umsOPEmlx/WOV2NTpbsOTDtR1FtG9XFE2kLhzbEZBqy6860TJZD1CFvjz+c/HUK67lB9l9i3rwNsLliox8WNKqGF+GMzX7YECei5I18Y67BU6YYYRm6tFYTdcruWq1FwYQTUFh1hHIGujeY4m3ZJ9f33PEey7yHM0xGpG4LdmespfpaluPO3tzxyCZnhOav/CQfLk0/9NOVJX271WjaPaRGXE42TV+FImnU3v1XdV1baEM+Kl1LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000126, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Got it. It's commit f26b3fa. I have read it.

Thanks a lot for your reply!

Best Regards,
Jiacheng

----- =D4=AD=CA=BC=D3=CA=BC=FE -----
=B7=A2=BC=FE=C8=CB: "Huang, Ying" <ying.huang@linux.alibaba.com>
=CA=D5=BC=FE=C8=CB: "Shi, Jiacheng" <billsjc@sjtu.edu.cn>
=B3=AD=CB=CD: linux-mm@kvack.org
=B7=A2=CB=CD=CA=B1=BC=E4: =D0=C7=C6=DA=C8=FD, 2025=C4=EA 7 =D4=C2 30=C8=D5 =
=C9=CF=CE=E7 9:26:32
=D6=F7=CC=E2: Re: [Question] About the PCP free_high heuristic

"Shi, Jiacheng" <billsjc@sjtu.edu.cn> writes:

> Hi, Huang, Ying,
>
> You are right. Using high_min is better when the workload is located on a=
 single CCX.
>
> By the way, I'm wondering why the free_high heuristic is only applied to
> high-order pages. Would there also be cache misses if cache-hot order-0 p=
ages
> are not reused?

The heuristic is mainly for network workload, which uses high-order
pages.  You can use `git blame` to try to find the commit which
introduce the heuristic.  But it's not a trivial work.

---
Best Regards,
Huang, Ying

>  Huang, Ying <ying.huang@linux.alibaba.com> writes=A3=BA
>
>  Hi, Jiacheng,
>
>  =CA=B7=BC=CE=B3=C9 <billsjc@sjtu.edu.cn> writes:
>
>  Hi,
>
>  I ran the bw_unix benchmark in lmbench on my test machine (EPYC-7T83, 32=
 vCPUs,
>  64 GB of memory):
>     bin/x86_64-linux-gnu/bw_unix -P 16
>  The bandwidth result was 30511.63 MB/s when percpu_pagelist_high_fractio=
n was
>  set to 8; however, the result drops to 21595.98 MB/s when
>  percpu_pagelist_high_fraction is set to 0 (enabling PCP high auto-tuning=
).
>
>  I first inspected the auto-tuning code, but the root cause of the perfor=
mance
>  degradation lies in the triggering threshold of the free_high heuristic:
>     pcp->free_count >=3D (batch + pcp->high_min / 2)
>
>  free_high heuristic is used to increase last level (shared) cache
>  hotness via letting one core allocate cache-hot pages just freed by
>  another core.  The target use case is network workload.
>
>  It appears that free_high heuristic hurts your performance.  One
>  possible reason may be that the last level cache isn't always shared on
>  AMD CPU.  Can you try to bind workload to one CCX and verify whether
>  this is the root cause?
>
>  I noticed that commit c544a95 increases this threshold, but pcp->high_mi=
n is
>  relatively small when auto-tuning is enabled, and the PCP draining leads=
 to
>  the performance degradation.
>
>  The problem was fixed when increasing the threshold to (batch + pcp->hig=
h / 2).
>  Is it intended to use high_min instead of high in the threshold? Would i=
t be
>  more adaptive to introduce some new tunables for the free_high threshold=
?
>
>  In general, new knob isn't welcomed in community, because it's hard for
>  users to tune so many knobs already.
>
>  ---
>  Best Regards,
>  Huang, Ying

