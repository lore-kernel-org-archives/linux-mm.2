Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367B8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FB26B00BC; Mon, 13 Jul 2026 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511946B0142; Mon, 13 Jul 2026 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402426B0145; Mon, 13 Jul 2026 12:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194466B0142
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:51:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F4448BA32
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:21:41 +0000 (UTC)
X-FDA: 84983966802.15.7ED34F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CDF6812000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:21:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+PA3qvN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T13fF6DuKXjoRWGoSA1rsBfe5/M0+RntPAmfNLiYYjE=;
	b=Jt49QpgkkHgjbUDZpAKdIxc2SFkZ8dfjpgLe+Xlktnq3wkoV4kX5XRnzZqvbbtC/BeVJdM
	hSIgvBWnsY6sQc+M1hmmLNaoaj3QY6rs7aQqa28DnmF/qd3rTlfWBFpYxVeDuXZaI6aWjB
	oAih3GVSggRv61KB5slf83VdV9O2PaU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+PA3qvN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952499;
	b=F5iq3zUyAI0zGdyzxk5kIK8a94uXzObyErEUYm5o+KW9n5ZkpY1LvMxp6II6jxcojX5gx6
	8+fAVdtqEtl5h2/QGRHONOFpQpGUJsKI6fOQgZPq/5YDmTAlaOkiU8HAWt+WmC4YPWWtYk
	D83B1DusAtbo4ADrflXd68qepVBAJYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4790F4024A;
	Mon, 13 Jul 2026 14:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD49C1F000E9;
	Mon, 13 Jul 2026 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783952498;
	bh=T13fF6DuKXjoRWGoSA1rsBfe5/M0+RntPAmfNLiYYjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+PA3qvNHakXfHOABuJr4wlRpP0q8Ad+tOu5kGf1se+V8EQdOP5DbAj9iqp/A4P7L
	 glX4aGZTfqC5fbuI4Vv68b7sEZU6iJvKc0GaL+SqJbyzttOab6sQaD/ueWsu0NxAjA
	 gZ+RT5CXpBCNSBDuXRIhgxnr1BNKpA6QtkAAeEF+9SjMCZIbNQOUbhLD8zTAfnraAI
	 rKQ/+y7xGXULbf7xm2asQpHLGl8KxQvziUUT16Ut2+V0NXqkEbtnWS5YB+FDJtG+DM
	 wP498bFgGxFoameYkK0Wb3tD/JycHD+VD9nyq8L57NUN4Oq6vpv6wiGtqr1dCeDBs5
	 BdDMk7LNBQa1A==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
Date: Mon, 13 Jul 2026 07:21:30 -0700
Message-ID: <20260713142131.38616-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713094648.897239-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CDF6812000A
X-Stat-Signature: dc6myi6pe6cmmkr3bxwa6fyze94jz5y8
X-HE-Tag: 1783952499-464601
X-HE-Meta: U2FsdGVkX1+F9OdXm/kpPUGBmEumLkxy7QLLQwzJfo/QRqWzfHYTf5AbaglE1ptRUXN7kZptjrAvMW4E3//K4NUg+dFF276ZqwQ5qmHW0VNTvuqq1/XNLoAo4ve+H0JJuqhcBIFNiRhSPKAaSl6TRm+2UN8183cW8ZtufOKeJfnkobQ2f3Lk1G1/o1Pa7TDMsO532c6ZAeEXNZrvcz5dm9fGlrzPtId1cAHpm+g+HMRdipbwwPzD0bDsW80Dx77k6oC4le+INXhJVj2Z/rX8lsBQI1aq7nXl8j4799XKlvzo3vLmPfTklvKKewjZ+o5g+6rz9m+WYgTfMVrAkz4G2J4akXsOBrWlRYPs5lnH3JM6Qsa2UQ/k7iwArc/dqZadcoWuEHTwZ8FcFgjznw4nqJpd1+I6xe0NbSoAVyZuhhJ087b33qrppRdfmTTAAaHEycQ7+CdTfJSgIG3KslymROgt1ERUB5CVo3ioqx4hjL+s3//pCBdlbb7b0qw7rJpBvTrDENM43iLN9dgiqImWuyFrwx/lWFvSetOo7HKFAEdEJvvw9VwEyMRo3uYbHGFI5owUicRGuqf1szibGG+yPIrt6hT1aK69MQ0Sm1jazsmzR1ggGewIiH3k112rOZJ/S8LT/jho6uvY0XyxWXukaxI5eOGu/4w2Y8Ymgrp+EhyXANffDiaa31QHAj8tCJVQ+NDAHrZ7emd0sjsYCuOoqhtCzk/qwKSQAoC/Np7xJ9sDsc0sF2Sop/XQTGvsaIKzr6HHfkm4fK+xjP5Bkq5joJtDNKYE7NC3wN/0oD8u49kpwVSpT5ml6wlmWsOULeOkjs1inpJtBi7io0T3EfDokO36OOSWTdK2TD8NA9ALuLqEywq1x8QURGrqX92TXp8pYlS3f8f8OhiA1Ltfk/mb+vyXrSkREw6ffSnkxtBhMG6az78cdOABL7u/DJh9C1Bo9ssRYykt9eFgirs0eIz
 1ZopVsTA
 3zrb9HvBEYGMyQ4WqqUZm4wChxZZIuk+NRneVuvcy7j0LRl0MI1lTlb9DbrVsicZjHfE7L/ww2ZHH7kVT8uOdtXj5+NcApdWFXsvu4puKrR1MAarxk5hbwo0d70jWA8uvsj69nGMw3I66fECWldxR65qsxlDoqy3lzVI76WThBeO84W+zGXQ46+tt2cAsk6FSJ9LyxVsVjsdYPlSoIduBzqI8ykv3cKd3HsY8B+lgh3AMX/TJiCUhnNXcsb99d6Rrsavk6uB9r6f+R+dE9/2vAYkT9UoeAJkkmjqLxOaCSVoHj/laX2P2DKSqY63cfLaMiwrYvCLdn2RMdyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 17:46:48 +0800 Song Hu <husong@kylinos.cn> wrote:

> damon_nr_accesses_mvsum() wraps damon_mvsum() with the monitoring
> intervals of the context to compute the pseudo moving sum of a region's
> access frequency, with a special case for when the whole aggregation
> window remains. damon_mvsum() itself is already covered by
> damon_test_mvsum(), but the wrapper is not.
> 
> Add a table-driven KUnit test that exercises the full-window-remaining
> boundary (with both reset and not-yet-reset nr_accesses), partially
> elapsed windows, and the no-window-remaining case.

Thank you for this patch!

> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> Changes in v2:
> - Drop the confusing 'bp=...:' annotation from each test-case comment.
> - Wrap the function documentation comment to the 80-column limit.

And the v1 is available [1] at mailing list.

Thank you for adding this changelog.  Please add links [2] to the previous
revisions too, from next time.  For other readers, v1 

This patch is applied to damon/next [3] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://lore.kernel.org/20260710041530.557455-1-husong@kylinos.cn
[2] https://docs.kernel.org/process/submitting-patches.html#commentary
[3] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

