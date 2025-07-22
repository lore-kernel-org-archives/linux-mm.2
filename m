Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF779C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6CF6B0098; Mon, 21 Jul 2025 21:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469096B009A; Mon, 21 Jul 2025 21:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327906B009B; Mon, 21 Jul 2025 21:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2076D6B0098
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:04:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3829110940
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:04:16 +0000 (UTC)
X-FDA: 83690104512.10.0C8F345
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA78514000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:04:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753146255; a=rsa-sha256;
	cv=none;
	b=Bj5J6QH+StWFVCOAh3HpWQM/VhhtKAyI8+OY72kp4VyoTi7VWizh5CR0/B/Yps1fkPijS5
	ndsshUxm/9Um7Kdv9KkSQtJ5xfA3DjsHwIvxITdzLX81PBfiC5c+QJ24j/DcUbaKWQTQgA
	zeZZhn5P9VIUGwspXEeMoXFyxEwZBOQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753146255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T1yz9xqs68G6eRPUd201HakaFNF/kbWrBGCr8PpyAXI=;
	b=qFB/uIT4aumZi9Xunk75/J6VbWeycuvA9yAQbwQwifDLpWEjCugJHUQCbH1XlNJHfv7MW1
	AtnrjDQCpMlyBpHA5Q5GDx27xmQbOSSM9EdFStt39x9/qfeq4QNqHdxVDSlBxcqUjiBrGH
	j9fHmqkE7mhQLQJShSUpf3rRBWTqvEo=
X-AuditID: a67dfc5b-669ff7000002311f-0e-687ee38a93ef
Date: Tue, 22 Jul 2025 10:04:05 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool
 in page type
Message-ID: <20250722010405.GB45337@system.software.com>
References: <20250721054903.39833-1-byungchul@sk.com>
 <e897e784-4403-467c-b3e4-4ac4dc7b2e25@redhat.com>
 <20250721081910.GA21207@system.software.com>
 <8b6e6547-cb39-4e64-8dff-6e16e27e7055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b6e6547-cb39-4e64-8dff-6e16e27e7055@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvTPTmaGxOtTtKi9Y97qhYjzGJRgSc43RaEw04oM2MrGNbJbF
	YiKpiihiK6IYLUXrBggoWBUKAmETQTEQ3OpWENFEUUCgVZaALWr07Tv/f/Kd+3B5Wm6TTOE1
	YVGiNkwVomCljPTb6Mvzkz7Eqf0yUiVgzstlIeenDjJbbO4puwBBb98bDoZLaxD0VD9kob2q
	G8HVyy4azA3xDDjz+mn4WNPKQY51AzRnfGKg5FghDa2nalkwxA/QUNrXwcFhWxYF5jt6DhoL
	jBI423+dhkJ9CwdPi80sOHKHJfCp0sBAnekGA12p1TQ0GwOgxjIRXI+/IqjOK6TAdTKdhecX
	iik402Rh4UN8M4KmqlYGUgePs5B2yIhg4Kfb1pHcK4G0Bw4uQEmqvnbS5O6NVxSxlz2iSJHp
	HUcs1mhyJ0tJTtibaGLNTmSJtTuFI29flLCk9vwAQ4reLydFth6KGI50sOT7x9cM6Sx7zm4a
	FyRdGSyGaGJE7cLVu6TqJ99/UBH1El1tm4nSIwtzAnnxWPDHL8suUn8594hzJGeEGbjH8BR5
	mBVmYbu9j/bweGE2tibku1nK04KZw03GdM5TjBOCcKO+dEQkEwA7nQ2MZ0ku1CNsuZ32p/DG
	dRfaRi7QghLbhz67c97NPjhziPfEXsJqXHL698oEYRouL3hIeTxYeMbj3vx76PdLJ+OKLDuT
	jATTf1rTf1rTP60F0dlIrgmLCVVpQvwXqGPDNLoFu8NDrcj9nzIODu6woe7GLZVI4JFitMxX
	H6eWS1QxkbGhlQjztGK8zHXfHcmCVbEHRG34Tm10iBhZiXx4RjFJtti1P1gu7FFFiXtFMULU
	/m0p3muKHsXMidrApeiT7bqlN5XtQcE5V+ZSFRfXXLr97dpMR2ZC+xrvlPrp85TLi6f6dlQk
	NZrRtnDfwLVPNuY6/WfGk66tbeKX7V/GrF93fnCX78l37Y4614q2VedulS9JajlqGJtY4bPP
	6LcusFoXWL5Z+fosROdELAuo2wKOc3ER9/Z7JYxSMJFq1SIlrY1U/QLTl+eMSwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+Z+7w8HJ1I76JReiWGlFxWuJCn3wUBhRRFFEjjy51aaxmWmR
	rJQuQ01LIeeMRaWpE2uWbnmh1LyUlWwU6+olMyzxNl3esjYr8tuP5/K+Xx4G99KR/ow8KUVQ
	JUkVEkpEiHZuzVyr/ZwhW3fDtgb01UYKKqfToKzXTIK+ohbB5Mx7Gn41tiFwtLZT8L1lAsGt
	m04c9K+yCJiqnsXhS1s/DZWmOOgpHSSg4WIdDv1XOijIyZrDoXFmhIbz5rsY6Gs0NLSUdJLQ
	XZtLQsHsHRzqNL002B7pKfhk/EXCYHMOAZ26cgLGCltx6MmNgTaDLzifDyNora7DwJldQsHr
	okcYXLMaKPic1YPA2tJPQOH8JQqKz+UimJt2XRvJmySh+OknOmY13zI8ivMPyt9ivL3pGcZb
	dB9p3mA6ydfcDeW1divOmyouU7xp4irNf3jTQPEd1+cI3tIXwVvMDozPyRyh+PEv7wh+tOk1
	tcv7gCgyQVDIUwVVeFS8SPZi/Ad2ootM6xjQYRpkILTIg+HYjZwxc2qRCTaIc+TYkJspNpiz
	22dwN3uzIZzpwj0Xixic1dOcNbeEdhvL2QNct6YRc7OYBW5q6hXhDnmxXYgz3C/+ayzjOosG
	Fj/gbChnXxhy6YyLA7iyBcYte7BRXEP+n4gPu4p7XNuO5SGxbklbt6St+982ILwCecuTUpVS
	uWJTmPq4LD1JnhZ2JFlpQq7FlJ6dzzejSVtsM2IZJPEUr9RkyLxIaao6XdmMOAaXeIud9S5J
	nCBNPy2okg+rTioEdTMKYAjJCvH2fUK8F5soTRGOC8IJQfXPxRgPfw26T9PbAirH2/26J09b
	sw+lJXzz9RkILI3dy41EntoR3vewN7nsp7A7YpNH0wu/opcbDu6vibso998yfDvy65Aj2r+q
	3lNxW3O5S/tkvnKLOJgQPQshdYGOM3HGDnPYTmPKx6Bjg/GtnkMFw9aSU2EGpWV6ma9Sm7i5
	yrZHH310zCQh1DLp+lBcpZb+BmVWSeItAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA78514000C
X-Stat-Signature: q5rbxpnnuimmyoqmcqk5ynrrckhsf5f1
X-Rspam-User: 
X-HE-Tag: 1753146254-607196
X-HE-Meta: U2FsdGVkX1+ejTWkJ10YFsyRn9vgH0cH26CEuAX7EkxKIyqIVZuKSqfqy8PXVNGBkqeJsuGAZzsDCuKblDFUYTrM9jevei/jgt6EhYD0QQ4KkzklEnlEFsd5NdLryHyJVLMSmvop6A9tTktDBQadhZgSkUnokJAMUoU/XPotrcQ2AsO5uuyXadm6klj1GN3P/2WMLWyYLM1+FIOBFWzqjHbRdr+K0OP2zEoDkVLN/Q44MTM/joExvBnGxGy+rTuS1klLnBereygNR7kp0GuJ/uv6py3k+Ku50U2VyBwm5lko1hmNMkn//2b8VOxbwREzG6CnwpqCSeWFBMg0OI5h2NUlt31lAw/0W4Eqo+7dHRSxOF2TePUqdC+lLh8uUiQQ9s7TxlV5KVlnFjqguEJi+p3YgdwYuKcj0CYQNkUy/upJcfYEvAG0bLLopZYqx9/flITW2V6jSa4PXGkY9w2kSxX/2wfnKD+A3VucReCcIlmsMsUtCtdJ1uLobAUajnzYQC64qvnOPfKyLBgbTbX887SF1+71ldEAt9pyN/zpx+agvHn0sbRF/Iy6ohKHMFB/FAoqlEpNFUBjEZZljg0Lu9QlxA5XqfQByAXr0mjuPvbQakJP/rLT8FacTq8zRZ2xzZFjwtN/dDGhJhwklY/IrBGPLkHb4PQsMlhkkla4QoBTE3tyQonwl3Av3tf/mhhoWrS1FYswchUlAfGH/s51zaVBonT4+A8UKxR4kn4MuHWurYLXhcUvtI/GTCKs+98MBd8o64nxCnCvgJf8/iRokmjTQQn0a8PCLFoNNfTzr2Tjrs1Au9mVQbuHpgW2S/pev2W7vQo8+3VAhVRoyELwzio3JfJ51M8N5GYT97a/pkBORkw1cxa5hOOxPI1OrglaBpt6BGoeRNs34aTILhMcSPqHzm4i+4ARePALZ5JtMHGKobP0NlrFXezYAFX308RdMThxAtDFH7X7zV/DCGw
 /AHz6cUR
 p33DuTKFGjga/a4jBAqIfGszpbprJlQx+Lf2+JfkBm6Bt3lYuqA3AtUEjhJBxv8yod4oYAANNmKMFHRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 10:49:37AM +0200, David Hildenbrand wrote:
> > > This will not work they way you want it once you rebase on top of
> > > linux-next, where we have (from mm/mm-stable)
> > > 
> > > commit 2dfcd1608f3a96364f10de7fcfe28727c0292e5d
> > 
> > I just checked this.
> > 
> > So is it sufficient that I rebase on mm/mm-stable?  Or should I wait for
> > something else?  Or should I achieve this in other ways?
> 
> Probably best to rebase (+test) to linux-next, where that commit should
> be in.

I will.

	Byungchul

> Whatever is in mm-stable is expected to go upstream in the next merge
> window (iow, soon), with stable commit ids.
> 
> --
> Cheers,
> 
> David / dhildenb

