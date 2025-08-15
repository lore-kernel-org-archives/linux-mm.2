Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE2BCA0EE9
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 16:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864136B04C3; Fri, 15 Aug 2025 12:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8145B6B04C4; Fri, 15 Aug 2025 12:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703876B04C5; Fri, 15 Aug 2025 12:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0486B04C3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:59:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1081B7014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:59:08 +0000 (UTC)
X-FDA: 83779601976.16.36D1C99
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62545100006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:59:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQnc5YgI;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755277147; a=rsa-sha256;
	cv=none;
	b=nkyCSKrJWtM9XeyMF2RL6vpIQMKcHOLMl9nfDzn1Th9CHeJEBzKyag24LR3vGc7YqwIf93
	cSAY40wTsGG6qgGchpl/D8dB4HTw8IHAZBilNzMguQsACfL1yNDFtuH+/IYTfzfadzxEoP
	osDooS6gz+woeqV1nVrkK3/fBJClB/Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQnc5YgI;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755277147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQTq3g8w5S0NSnAK98E2MBp+fo2HrZ39mmo7PadxJzs=;
	b=uDnXK4bXO01Yy6pF0WFO5KZf3Y9nQdYyvTD/sNI3VejmpOg1N831p5xjMvrtYaakTIctaV
	QJrU8X8DVB4P4DkzdBt3hniXJeU+r2rrC0s0uO8DlQZLVEUYvLJlBMDXtp9ynT5HfvEsv7
	EYz6xFjfgzphRk90vsS38f4mcPM9Cb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8DEC1A58309;
	Fri, 15 Aug 2025 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A8AC4CEEB;
	Fri, 15 Aug 2025 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755277146;
	bh=NGegCFhiyZ1h1w697ypgzowDLyLqjIrtnSAlxH3t/VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQnc5YgIDUcyweR2XFx0UO+yui+YXy9sSk48egUARHzbaANC89iGrBATo3uJTIs/E
	 8uDUT0hyQhAEWl5muQbXKSrEeslENfalxgoYETmW76TE6yXE9avBHqKbFctM4l8MOX
	 qN6f6vitvi1SFuUSTeajhiMBUyKqF4rZXquF8y736xB3V5jvnn1awhHlJJBtjtrylr
	 e2szxAvm1nf1Li/hgCtb1/IqTrh+JRRc6gyNG3npfUCQzh1/ntBk857Ljot6XKch3B
	 Pr94HwaYnlZLGCtLSkVfoRqUyaYMXnk6n0cR8TLqfOnkRQ0GMQz8fWZn5UeXLE73xM
	 4cLIAYTgHaIQA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH v2] mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT
Date: Fri, 15 Aug 2025 09:59:03 -0700
Message-Id: <20250815165903.13330-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250815092110.811757-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62545100006
X-Stat-Signature: n8aj7ea868dieixmtraiyt1jyb6umqd7
X-Rspam-User: 
X-HE-Tag: 1755277147-784629
X-HE-Meta: U2FsdGVkX1+K2LvZuQkvIxYNYfURE5c2AepVQ7D/8Z8CuTo2xqbsoLHnopQQAxSX+bVAGNho+5oAIRYCdtdHIB54ZdMKdXAmgz8jNSpCAMXT7ZhuvZtrGHdx+kZU6LbDn2vmSBCukgBHCe0Kgbq1GxbUhmExLbd0PcMVb5KfoBNDxX2xF/9DAN/TuPn5sEfpxA+d24YO8+lXINV9ahkliUX3g7unjKwlTbCst5tcdKfp7PLHYv1ITt+joo22SSy4hmVzVqHFZf3TTXW2HK9eQcCaVMeQvdnPK0SBlrvnnBvfYsX6wipPkm3zGL839pmm3GYLedhJZSY1gwTU0h/ZY0z44ypCNjfKHG7cJ/Ix/1SIpG+zui2PEON5RSVN3Bwr/UGQLh/ToGPomGvvcvhYws5JDirAJHn9o7b05mIohBTkoqJl0VLaC1WQxG8OU8lIkAmM7a4MDxK3PsxlcMgluCUujBDo6iEuj1vwgkYMF0NiZtEU6E3b7TQY3Zn+sYGj3diKG0D4O+zikgZQZFacK+KHdmYJ1MeGXv/b/EZbUPXIhyd3AAFX5R+63se0RCyJvGfwlFOTsdV+oMa5N9HM5jKi3Q5TlToF09CjYSI4sjMUe7wdyGxc7Mf8iF/ucn5Mayt224u/r8tmhp3AymSSYSwkAn0Rmfw9IgnKuqrbTslilPHds9GTEy5BMj1kHDzlK/BNDTyMdxVgkc/pEau0jWRlgXSJx+L5HGEHYww95ll16KOC6W6Mn4d/fD8wxUslkGmaevRLqIhsQGdoqE1ZO04FuSdPGcoSzqwyGju16DLODw/mv93pp/viFY6FMhMYbznzYtibTwPncBK5Dm7q5U8A0ije0WdPuOVxOf5kwygvC4CwXlhkN3WLsP3ZU6QYjycTNp1fFtE9mpfDErovvKXWao3KphEDLXlBegHKtSvT+dMeButFeLea+vXW0ZtkQSZucBnm3DMC54No5uo
 eMiMb5qL
 K2+RTyyjRSDGnZ8PnysAfWbvTp/d+g7tPXpKXDQz3V9iTWaT/STf0ygodxNP5mqe9WNxoQbmurv8CRD4vSvAoHBhBiTxDvGdhHmGMO2ymU3/QdwVsAh+GaNuciwUtxAbmAqL4Ulws0F6tKvkNFCaYFhQ1qVsvajR59rVD81VwijHZmlLXrzfGZjZhv/E6NwmKVMkWmrQ+Do23JeKuNivtHKhVP4Hp4/5RMBuKmlhoBYtZohcjL00wIA+mkGyK8LR9IwypOvCRnY1mdjdOQ1E3kXDKaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 17:21:10 +0800 Enze Li <lienze@kylinos.cn> wrote:

> The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to DAMON_STAT
> option -- enabling it alone is meaningless.  This patch makes
> DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT, ensuring functional

s/depend/depends/ ?

> consistency.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> v2:
>   - Change the subject as suggested by SJ.
>   - Keep 'default DAMON_STAT' as before.

Thank you for addressing my comments!


Thanks,
SJ

[...]

