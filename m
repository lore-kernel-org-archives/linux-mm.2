Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49CDCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149736B0005; Thu, 11 Jun 2026 09:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAB76B0092; Thu, 11 Jun 2026 09:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010536B0093; Thu, 11 Jun 2026 09:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2B046B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:56:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79EB5120603
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:56:19 +0000 (UTC)
X-FDA: 84867781278.02.A380B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CE2C314000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:56:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmGsUd95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUOuPf9VgztfwpD31VQB2QF3LLKSgcQvoPRCqkRWmAA=;
	b=h8zFRiSpA68/N5JdQX2TgQ/u11gnR6LXN4jvXWgfHOLNpfcD5D9QkFJb3q/pkyOg+woGHC
	tFCUI3yOVOJ7Xv7slAEJVncZifMr2jAg0QW0JeNC4g0pcjsXOclhudCyMzETFd/PkOE8RB
	ke0rGhKdD0HA1wUcjXrBQFWtl2bS78A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmGsUd95;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186177;
	b=stkitoU9AIMxkxvcgv3iIirGRruYgnCX9e7cgulLMvn6aanpZbdrGjnJthnvvzWEmo6o2u
	ebQU6khFHSD0Vplsum04IUg/bslrvuqyFsi4hCO+501ls8aSgxZtLXZS3O6dBvKUOOZSaq
	BAgxq1yH4B6UJqbRtpW+3dsVZf1QsfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C480600AA;
	Thu, 11 Jun 2026 13:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956071F00893;
	Thu, 11 Jun 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186177;
	bh=SUOuPf9VgztfwpD31VQB2QF3LLKSgcQvoPRCqkRWmAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmGsUd958piwIRs1z4CkCvr45U9dM9GKsRx053NCzGhO87m2uum70Tmti9TDd2C/u
	 UWU5s6LmQDCq5SW9RA3KwSgGilAcFn79urvlf9Qj1qH2HvmB8KP5/3Iswa0HC6/J0Q
	 Ymk/VYZeknMXO58bZER6SO03OxTvegn56iBnBtjxb0+3X2L6ngmV3xzAkjjt3eK7or
	 xn9QPsEaGnkqx10xvocBuGsFz3tVtEDohDu9Ap1GTQGDyUBHCj2dtpygmuyNqf3+/T
	 9GepEGD0Ra0mbtkAne1Otn8CslsfgypJrmFP2eci7hyNiw8Hfv+hHdHIjxlMKqoLQ6
	 gnG46iMDsp5Rw==
From: SeongJae Park <sj@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Date: Thu, 11 Jun 2026 06:56:07 -0700
Message-ID: <20260611135608.66888-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611125704.3386176-1-arnd@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nmufeg7mfms3j5nf6sk6n1aq3a7diyn6
X-Rspamd-Queue-Id: CE2C314000F
X-HE-Tag: 1781186177-366492
X-HE-Meta: U2FsdGVkX1/ltU1U07ZO6MXeUQSKSS24iTEdD2yO0oWHU9doVsCGvZhS/Yezg7gwGc5tYtS46CYDpIr4/R1ZEnpdoFkfTRVprwajV64dDgLAvqkSmMOd8A0HEhvXOd1TEjY2P6Ok1nxrtWWx6Wc1K1ek0uD7OlIqr+3uINxUQQZ3heqTNjXEVqCdJ9czqpTeKDgP8tIDDfG3YDETLr0noK5Z73jL+WFpUwnWG1cM/45zyTHXgXQcqYQlhpniOp/y3E7BJse/vjRhB0UCOdXVWd4cwPZY18k+A/+Mu6wwTC+uIKOTJetEuXY61peVoXCidYHE84S0nEh8sBhiJw2MuBTtbJXHgMYeIJzVyk0pC0k1Vzp4YRsm/1SR1xCtUmzVDBMwF3Des0Ugif8SNVirQNoLZmcvS5189bEKZ4nVyoQuAhe+nKsE+cWLu4Tq8HfwQp/tmEHgZJ00IyIggW/9/Zh+6ckJCJ/0T3ZEQYaJk820QrdtwJ/Hnpm6SqH6Ojf9TzFQcDlhu72xpZ5RSONUuqDDs2UGvwdayQVmOArJRJnJFOL20pfvpphA97Oc6WL5UKCJ2bMGKl9ZoxvU/BDJiMETYj6Ag7vbbGjNrMMNjVro9NiYIpBWF0/DTbpYg3UBpxpuchVpufl6rl7uE0GCTG6vSd/V9d8IGUMd9PweyOc+wCycB2YILbg0Rin640E2qVgQbxOqqN1TnwlnQdAt1cOdjY4GzTO/7RhBcH5Nbhe5wHr/Bc+n8If5XZ24tSjvGOLsy1JbVdeYBcFTEgVDJbY/+JdsxFhL3+2rXOFPLGueYUMqQc4buKwrSHXlo+mUegBE3ekEM+FQY+o52w0Enf1Qy/t+xzJxvYN1IBsdnN9CAiG2gJ/8/g7j/dYowSuiXn/DrIfllgCoYbMyCuAaDIngr5f6CwqjF1BdfY/QY9of3Nd4LCHoKId3J1VTRbRcPRfKIVDLhjV76mB+leh
 qSx0ntPK
 Gg8kpIYjuz7XnXtrXgMThv1tT65gVQyhN8/xRVx+A8n7vU2cF6GROVWVrlkB5Z78TzrjCin3J2y5vMunDeXTdpNIte09rck6SW2d6qM+FTcgrXoCFF/w464PycbHzbxdEeafXkxLQcPMZ6INDYqDev3TmgnuUIazD1DHPHy2gJtHY8CB1TAqVhcoWrKjM0lBYSm8uQr3Z1Q3PrqC/NcfjOr+jDHiPZZOK35VOwiD4BJ1Jak9/ozcdhRSv+/xYESMes3OTYDCQlyxq6udoiO8MOQSIvgcHrsOgU0FYqbikIjjmBSQUyEDwBScMG3uMLZjPwKo2CPSKqTiE5pCiSmONtY0im87EmTlxw/qO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 14:56:57 +0200 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The main thread function has recently grown to the point of
> exceeding stack frame size warning limits in some configurations.
> This is what I hit on s390 with clang and CONFIG_KASAN:
> 
> mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
>  3440 | static int kdamond_fn(struct damon_ctx *ctx)
> 
> The largest stack usage here is inside of the kdamond_tune_intervals(),
> so by marking that one as noinline_for_stack, the functions individually
> stay below the warning limit, though kdamond_fn() itself still uses
> hundreds of kilobytes for some reason.

Thank you for this fix, Arnd!  I will also take a look in kdamond_fn() to see
if there are more things to reduce.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: SeongJae Park <sj@kernel.org>

Should we add Fixes: and Cc: stable@ too?  This function was introduced by
commit f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning") which
was merged into 6.15.


Thanks,
SJ

[...]

