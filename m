Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F97D5B87A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 23:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B6A6B0088; Mon, 15 Dec 2025 18:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48A56B0089; Mon, 15 Dec 2025 18:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72026B008A; Mon, 15 Dec 2025 18:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A34646B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:16:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56AA91602D8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:16:46 +0000 (UTC)
X-FDA: 84223267212.27.2B16D36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5AE7100003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:16:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oyzyNvcb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765840604; a=rsa-sha256;
	cv=none;
	b=EgOGDqxpPX4skKQFJdTRIZ39pyO2u/KO4dUFapLrJBBpnwkttgno3CVGh0LQmLTlhpKxYr
	iU+Hzmc0D8YBps5G1bEYpyhuLBmAyo+ghPgxGQlcFEBfSluC8Krz5WdA61Ldni3F6rrErK
	UQqZmBDmUfbwa4xwcuIHBGiq2gY04UU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oyzyNvcb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765840604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bw2Wr2n/OPKCaGd8Z7/UJ4IfK+ln2wk2oJAiMQEvf0Q=;
	b=CHJwAOSCTUH9FkjBgmWVS7PiMni2aTsHjX7HliJsmueumTIC11YLFSXtia3JlTZNDY270r
	h+u3V7KaPdXpU3s3NYypIQsm4hTJLMaFoCjE35AEO5Wd7F+cMzh/Sr1UBbr1l5OlZL4MyS
	eR5cQL+cQ/ScptTAqJnlzY6751bT90k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62476403DA;
	Mon, 15 Dec 2025 23:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4769FC4CEF5;
	Mon, 15 Dec 2025 23:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765840603;
	bh=PZ35LkCzpVRKzVKeLttzifl9x7vaCDcVkiyt89U3mCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyzyNvcbBEa5qXzKfUVDKZKRmJwP+PH9EmJ1xonOu2pAgkDZHuZgDDGlGNsDf6mB2
	 0KWP0pQ7YU3IabC6xCSZqMM/lIU9joxRb7xTDF2haoMSffKXb5ysad01DpPriwXAsg
	 TE3jsIh6FNit1U22giRHgmkuGVsEViExdy/r3Qj0MdU8I+wVWpN/cLhJ314K9kJO3V
	 HnC93YrQxcydJXiPuQ6aiGppYg0lsjcHEJ4+88ktZ3EfPZ2b3B9oSm//De/68YatqY
	 pgkmz5E4BhglxdaY6gVfn1AITsjdwM0vpU59LA2LjNn5F+b+1XMYIl4h3H7r36yW4m
	 xmcV9B75a/V1A==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Mon, 15 Dec 2025 15:16:38 -0800
Message-ID: <20251215231639.56448-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215142057.588500-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A5AE7100003
X-Stat-Signature: 8r43wib36tiqoqfhoxnya7rmw4t144dk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765840604-183457
X-HE-Meta: U2FsdGVkX1+bgjuc6AaL+NUps/c1YfqDXdckZNMdzbM24yumVJDJoEW+BFPluHr1Sz74bscGsn4z7ty6PQ4zCF5uoys90MOaKwNI8lzIyrK0er2TwHXjEt2gae54gQcoozgwwYRqO0ALBIgDFR0nB5f3Zuij3dVYqhD51IjRHRKSRrgtpHXm6VYCd31bRAuK1K+8K6p68OsLO2+sqLhq8hjdXbiorBlImDvoVVKSwssZIyJoVaN97lszDaFmEYAooWAbJHBKI+IYqR88IaqkCglsrc+1/3fVLc3JUtRwXQgvw79sxZqWqRsGvpGH6MtLBh1GadiepjuklqnRvfhjkS7dYMzvMBHzK3dpOIq2snTj0deKjep1cjMmCtw1DNKhyDmfTrtq+88U8IJ7PeN/QRv+ORCuWeVZm7e34pMujSLGL25WQJVWNeukY5m7NcHL1FHLlaplRobBRYY3xSH+uMwmNaUQ7idCDPw+j0mnPm5y5KKAjxQZwMSqA8LWwW6+x/3rLePDe5MwDFC9l0GtP/ov48agmGJiuakzjA5gzdBXbSnaSbxfvZ/YV/mz2wC92ei/vBohk+/JMZgyUOeQrnWWjGPUjqSNRHDRHYs/0Cbfte8YZdN0Fiy0ddLSAPBvqG9el/kGNlqAqWR7UbSEcW5qIHk+VZlBM8yy8ZoSrI+oBW52p3ozYDCtaVsZdvJ0uYtCSb0UcegfH3Ly/NRpWit7j5IxZ3gFdh+C44rW6SN4Wm9bp6Ww+TM8hSfeeh2zW1lwakmpNvmTlDICQqmMG4X4NaOU+TlvGzR59IrO7W2y3T+fUVnYCFRy26eYfg5iUdH2EjdMNKpgTehoVaDJjWk1xpxB8jc8uNTHLwDlMe0hHz5ebG+kWrST4OqGbtCmIlIPXsjxBUx3HEKxUA+Rd3QjFAPvsn1TSVYChaEEHx3Z6XAM2zA66gl/K0LzHTAk+msHTR2Or3jmJYKq7PW
 4DO97Mhs
 /SiJUCFshtrREFfASXrbCvBHwgZiuMqwfbUTmVa4PHwdG/OoA3LmdIETHKz0x6aSaOB/8P/JkWpFJdIuXEZfaha1h1L/PUgIxgU1/2HyjLVrPsJTgde91LczGPX/lh8YhatPV6C7WaV9OIa6v7cYwkAM9zoHy6Umyy67XVUEaLziYFz/FmAggCMmVO8YBVenraVThIL4FkH32A/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,

On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:

> This patchset makes DAMON's advanced memory management accessible to a
> broader range of users through two complementary enhancements.  First,
> it exports the necessary DAMON core symbols to enable building loadable
> kernel modules.  Building on this foundation, it then introduces the
> 'prdm' module, which extends the concept from the DAMON sample code
> (prcl.c) into a production-ready, user-friendly tool.
> 
> The key strength of this module is its out-of-the-box simplicity: by
> simply specifying the PIDs of target processes and enabling the module,
> users can concurrently monitor memory access patterns across multiple
> processes and trigger proactive reclamation automatically.  This
> significantly lowers the barrier to using DAMON, allowing system
> administrators and regular users without deep kernel expertise to easily
> apply sophisticated memory optimization.

I agree your points about the problems and the direction for improving the
situation.  However, we have a module for such use case, namely DAMON_RECLAIM.
It was designed for a reason that very same to what you described above.  One
key difference between DAMON_RECLAIM and prdm is, to my understanding,
DAMON_RECLAIM works for the physical address space, while prdm works for
virtual address spaces.  Is the virtual address spaces proactive reclamation is
what you really need?  If so, could you please further describe your expected
or planned usage of it?

If the virtual address spaces proactive reclamation is really what you need, I
think extending DAMON_RECLAIM for the purpose might be doable and even simpler
than introducing a new module.  How about doing so?

And, even more importantly, why it should be a loadable module rather than a
static module?  Do you have a specific use case that requires it to be a
loadable module?


Thanks,
SJ

[...]

