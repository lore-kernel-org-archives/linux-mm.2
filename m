Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A17C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 17:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737876B0099; Sat, 27 Jun 2026 13:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F316B009B; Sat, 27 Jun 2026 13:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588E56B009D; Sat, 27 Jun 2026 13:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5256B0099
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:26:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8029D120166
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:26:41 +0000 (UTC)
X-FDA: 84926372202.06.E4F6514
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E22D88000B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:26:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qmc6DOAw;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782581199;
	b=NbLVbubkbTX+xrws4ZxehB8TXTsRpjCjOj3N5mvwqco4m/rocBZAmY23YQ9nuD0LM2zrM9
	oHaqiLOAdHWP57lVKmWnCd03b1vPYXf41+Kkk17CFXA9KZY7icQDOSb/KZ0Eaq90nknPt/
	W8B/xFS8/6l4Oo7kJK//ZezSxyPGiR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782581199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQEZdzMR4S9EJURSnXOi0A7QXVE9gI14e3OGLriAsys=;
	b=d3JB7NeB2HVCQquKh11if/3ClNV2DIQX8l/y3Exj6qPED5DmeNr1yN1k89PLUCuRT58UoZ
	QucdXr9HTn6JzTWVE0LoD/hFTn09lrEf3VJHyN+M3qR7ewUlC25cjkmCPh7xVo+8BBwhm/
	VClvB/7gTQ7GJcYCYyHL6V9iP4OHzNU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qmc6DOAw;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E6866001A;
	Sat, 27 Jun 2026 17:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E7D1F000E9;
	Sat, 27 Jun 2026 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782581198;
	bh=FQEZdzMR4S9EJURSnXOi0A7QXVE9gI14e3OGLriAsys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qmc6DOAwKXcAP+pOtkC6rejUGyAHxjO/U5tybrHEyTyFKTp/3VjGhisml9GONUBhi
	 emVNvUHwnVMSMfFdCRgYE8hWnnt8EYcJvfjfll5iFqw97elZpbMJIvcFvmoUF+T6Nu
	 jNBi3Xpqv6fgwcTryQZ47RXt6hbbVWEAYReckGFTfyhOzFmy8/NrWM/yoqsJw1rqYU
	 YeadqQfyZnrcsrlRp6Y9Yejto0hw9Y4nGfoimiAVXW+PQj+LAoA4yYOmy5lwwynmJD
	 HSKqqg0MWiEYBeOAvxHpAomZGuvRX7AB5XqMMkwH7pPdij3KwDvM7M/fGH5jiVCdqN
	 acnSntl1VPKug==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon/core: validate ranges in damon_set_regions()
Date: Sat, 27 Jun 2026 10:26:31 -0700
Message-ID: <20260627172631.3923-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260627170057.1867-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E22D88000B
X-Rspam-User: 
X-Stat-Signature: o4tu116d9nkbbdbcttfxrojicb9iwdbr
X-HE-Tag: 1782581199-879376
X-HE-Meta: U2FsdGVkX1/CjIIpDrxdaEb5srAqfbModp+Z7HAC9ovumDw4U7xvlWuZCFlswLVvKMFEXpxfMlyyGD/0TkJkkSbpYABx762tzosW726krByMFVBmXPtHS1n8D7t3236PfLXSvmG6ziBm1FB4GS/L4Kj9+sb3q0IBb7F5wIYiS803qBj6fdEDQMQfrueRv33loZjFEI2iIF0b4+yfZTVy9sy1YzneSaD6k5lH/jxQbY6nlaoBJdmTREtUG+OtDbA8lnyg4KocqExton/NdtN9C0ydAM9xImFevVe4XoK1TKM1rl23YEIWUO8Wb2Z940D5QmRENgXtt1xPwhVWsBjHxGjN90Bvhz/OU9vps94TUqu1SjIXHxyzvIGSFfCNaZXnvQfz1BtZwvP/cHj/0Wk97MsmQzEbZe2y9uJYiC+Nmf8nKBkD7H/Due0uriOOCl9gyeAgNWcELz63Fu5cSQRch+5zi2zkO3f+8P54PgHhaRFFmU303Y7LaSO7logN3S/xw3RU7rA9/6xv2xux9XSU5nnGSQV1WSn7cCgSvLYBlhXw4e2M0um3q4myyFcR3n8d7j4V/wEUxIud1GNqg4U0twK0qjac3n7GKvq9lrMSGkHPEd/DQXO21ZEzN7arY2+4HmYeWjVEVjoONrr/HBogfNlffVyauu/OjxvBt9uyYsmR8bzoUYZVF+1BWV306xLekICfnUrBjBjFOv7QOsS1L/jwe9dk7aGefhlH9TnoNw1Jn/8etAPJTiKOU4Hg3HFcjd5gVGRy/k3HZ5frTOYEyfYIWPTDqJGUSg+CEJXxAGqJ8pokjouLsBS3l0lIjEAlCFR4kVeBc2B+yr2x+zC13Ak08rZCHn6imGjo9QvNwxRoMamcxoys2mtvOZotp0QAlFbURPGIAzgDPJVRv1plcvCw5nC7UTIZkFLv/Qr3rK+EpM66BJvYmYMqon1JBr3OrVCwHhgarDaE5ou93Pd
 HM+rfxkg
 Zd85ZGyUvw1W6kX2RStb4ATB1yetkM/ogIsTiEG8BdhAqyR8EZwZjtrl+14xcjlmWOZMowIFwN13bJxe/iFtTzvF937W0EvLFLXFJHhJ1APlhoUV4CZbMoy0o9Qr+je/006lP++L4ltONWy01USLMbFy+/uMWVtu17eE/Vzr1WDGVj92tnHWgU/5mpdkIYZ5wAtw3iMMqAPPTJNUMYAXShNNEl6dtDuzlUvU786IOyaGrW6PWzB5decM6lXAVEgdmB9VzGMIup09/4fMk4xGVI0FHEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 10:00:56 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON core logic assumes zero length regions don't exist.  However, a
> few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
> DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
> could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
> and divide-by-zero from damon_merge_two_regions().
> 
> For example, the WANR_ONCE() can be triggered like below.
> 
>     # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
>     # CONFIG_DAMON_DEBUG_SANITY=y
>     # damo start
>     # cd /sys/kernel/mm/damon/admin/kdamonds/0
>     # echo 0 > contexts/0/targets/0/regions/0/start
>     # echo 0 > contexts/0/targets/0/regions/0/end
>     # echo commit > state
>     # dmesg
>     [....]
>     [   73.705780] ------------[ cut here ]------------
>     [   73.707552] start 0 >= end 0
>     [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
>     [...]
> 
> Disallow empty region user inputs by updating the validation logic.

The above description is wrong, since this is not updating an existing
validation but adding a new validation.

> 
> Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
> Cc: <stable@vger.kernel.org> # 5.16.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 7e4b9affc5b06..b3100d7fa5596 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -358,6 +358,11 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
>  	unsigned int i;
>  	int err;
>  
> +	for (i = 0; i < nr_ranges; i++) {
> +		if (ranges[i].start >= ranges[i].end)
> +			return -EINVAL;
> +	}
> +

Sashiko found [1] this is not complete, since eventually this function uses
aligned addresses.  I will address that in the next revision by doing the
validation with the aligned addresses.

[1] https://lore.kernel.org/20260627172406.3794-1-sj@kernel.org


Thanks,
SJ

[...]

