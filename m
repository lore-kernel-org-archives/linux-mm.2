Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBE4C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878636B00A6; Mon, 21 Sep 2026 12:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8501E6B00C2; Mon, 21 Sep 2026 12:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765B96B00C3; Mon, 21 Sep 2026 12:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4AA6B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:47:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4634C0260
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:47:57 +0000 (UTC)
X-FDA: 85238351394.13.F887B1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3FF9480004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:47:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5O5pxmd;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790009276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFFR7nvnl5AUCpE0qKICPm8j7Nfxgqq2d2iNzuqP46k=;
	b=Mr32kWdCaEAfTfqcotRI/1oHepasEeB8JVKynjhr9i4ofgirTahupiJyEWUOQuspfvJxJW
	M0GbGekBfk5OSrp0fcjErOMa3OQMvGj9zm/b8na2yrCjWjAd9tqeNvs/vyf95/pBs7j4VT
	O6O/AhcVUDcOlqBkbO2W1ACrJc4cPHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5O5pxmd;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790009276;
	b=veUTTp0pB43zunCCm9/AbMETiKie5oiIN88i7gjFymdt3FHbOblLUr8x1g3qqjomtZ5MLs
	cW0QiIHsBcbKg8i53VxFMTEBwi2dgF3T2f4VE+mncRDUObW2NB2luCjPBZ2f/ONLOTQZO7
	JKuQfldrlx2VBIhEO+zF2atoLx8TOvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C14DC60008;
	Mon, 21 Sep 2026 16:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B8C1F000FF;
	Mon, 21 Sep 2026 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009275;
	bh=IFFR7nvnl5AUCpE0qKICPm8j7Nfxgqq2d2iNzuqP46k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5O5pxmd3FyuLyzHSecvZ835/YaBrb8no5OlfGEsu0n/ePKDTd70M601LXWZoNO8H
	 5zSwA/7Q76KJkm9DARpVems3R0xUBQffe4Z8HZeRN8Zx7kvLh3LCndFSF/R3fs9tF7
	 os+IPpKAHjB4R7coXd7+wcImv6YLNuR4CWYfKvz8msRw6FfQuOhvCgIh1ExuFt3yTT
	 w1MkoZSlQ4LiJ5ZZYPHuYXunn1I/u3y8+EeP4SzPf0dlrmPLfhGHu866yydhW/8aRE
	 Jl28rFcjJetcZCC8KmheMUVrELyzQdy+3Pg2LuYu0t4z4Gl4lWddIPNG14KQPA5m/v
	 mBeHm/pYCy0lQ==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon: preserve temporal quota state for unmeasured PSI goals
Date: Mon, 21 Sep 2026 09:47:48 -0700
Message-ID: <20260921164749.82070-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921020013.33105-1-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3FF9480004
X-Stat-Signature: c3oxfzxmgdic1pud1e5xdg3d6r13q3jd
X-Rspam-User: 
X-HE-Tag: 1790009276-527358
X-HE-Meta: U2FsdGVkX19BAcnq8h4sd7rO9RalhqH8j3AsKLUlrPtHPMyoHA+5lZsk/pjYKj1dPlhTj4KaPeyI9T0CQF683mmgbAlGpqD+lc7E2iv0weNspw0qi6vrujeTupd9nUsmTs+YDyMyDeVe0nYTZkajLfLZ8xZPBzZK9iqthkdfkcy9yu2049bqzVLfHVOKlczgAU1CQbRO//3pZ7lBkOuyfPWnjQ1ektaTLTT+NP1okDr7GNdPU6pvdd4T8VjW9z8CtHON1XVETXitii01X/iHnbyLzRmnakkP4gbmu/BwZyDY+VMQ+xxbhDG9Nltt0R7Uj74ulf2pmaIwsy3pakrHPm/85kFfZdjBFgF4+Gl+JIutjve7IDWhLY5bJqINbVlp3TZPoPB3Ru5zZFfrDlELiTsdPxIup7bhYI1hpp158qDEcchI74Ur3gQYNkEPndtMKiaSj+HyZdz+hj/VCeJC3pJE4pxVfP42dlicZmOamLZtrC4vUKL/91yr0w70Hot69xBu8vL+OazcQQ8Amr501pNMT9T9QtsJmoFL66Q0qCw+d7s3iUYHhFD0gmC3wuRiaXqFzxvGDrScqZfQRSGWO9RhlrMJyCFB44lScSQGPcQmfxma5Co84SpYctHO7jWFe2AIe6mM/DZFz2jP2LFFtW1BgrYLF3vObKUkiHNQj9jt+Arxe1Sox+jOhzCXnTkwygZIAV9PJP2GqUZTqwbvvK1SzLBnwTsLiqV7Y1e4MZibxSZ8ZcHZuNuKZ3Kmz8X4evFOBElyWRN8N+7FFL4d7k5787JRZVupt9hANVGLYtZzBbiCfMkIwON9/kHORWMwDbUq9GwMXUKtDHmQqQCHjThtOKkABo6daW4YVzlmBZV6XfRkgQjn5Vj+SBx2rmgMfli8r1CwPhyHUcLwtAW+S+ZoODZZnpvA33+J73pgBlWbyiHSnEpPgVa0cg3G5XGSFYzlP1+brt4SHaQ4vNc
 KEPxQRMv
 cVFD3JHKcYYRrKeiblgkZ1o7xCNsjekEn9t668q2FrGDxkcGyb1iKyuXBEvdJJ7vOBK3372jiWS0G8QHAnYvNbKmZX4yZxPChUAXUNIwycQasbXv4L8AVIYHD7eLGdvzOkVWPySl6v/Dqb4tXWctz6PIkKQ03dtbUityoVO6ggbOUINHJIHWLar1ubSq3+3FdP+AU6g/HZ0BqvdrZGx5FqfqtgHZPn5Lo8beLO2x0WAqxoHRdNEBcg2y/aZWbSDnV1X0qYhB4+vqzdi15bWfxQ4/zU635SfI3lGYbH2GRlvBkwsQ/xL4jZH82Q69t9qnHQiUR1y4aqa6lUJ1sZUvOuqCiprpwOocweOPH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 04:00:11 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> A PSI quota goal without a previous sample is scored as achieved. This
> leaves the consist tuner's input unchanged but sets the temporal quota
> to zero. Preserve the temporal tuner's previous goal-achievement state
> using its effective quota, as SJ suggested [1], and test the helper with
> explicit PSI totals.
> 
> All 42 DAMON KUnit tests pass on x86-64 and i386. With the original
> scoring retained in the extracted helper, the new test fails on both.
> In a live damo test, a goals-only update changes a running 64 KiB quota
> to zero for an unmeasured round without the fix. With the fix, the
> effective quota stays at 64 KiB. A full damo tune also needs the separate
> quota-reset fix [3], so the context update preserves the running quota
> used for this decision.
> 
> DAMON selftests show no new failures (QEMU TCG guest; the wss_estimation
> test misses its accuracy bounds with and without the fix).
> 
> Changes since v1 [2]:
>  - Use the previous effective quota for the temporal decision, including
>    when it is zero. Keep resetting last_psi_total for new and updated
>    goals.
>  - Move the current-value calculation and last_psi_total update into a
>    helper. Test both tuners with explicit samples and check
>    last_psi_total after each call.
> 
> The series is based on mm-new as of September 20.
> 
> [1] https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/
> [2] https://lore.kernel.org/20260915060937.3423-1-kmehltretter@gmail.com/
> [3] https://lore.kernel.org/20260921003047.12041-1-kmehltretter@gmail.com/

The patch 1 has wrong Fixes: tag, as I replied to it with two options to path
forward.  Speculatively assuming your preferrence is option 2 (adding this
series with fixed 'Fixes:' tag), I applied this series to damon/next [1] tree
with the suggested Fixes: tag modification.  Let me know if you want the
options 1 (squash it into the incomplete fix [2] before it is merged into the
mainline).

Unless you want option 1, and if this series is not added to mm.git in short
term (~1 week?) with option 1 update, I will ask mm.git maintainer (Andrew
Morton) to pick this.  So, no action from your side is needed for now unless
you want option 1.  If it seems I forgot doing that or you cannot wait for my
action, please feel free to ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
[2] commit b73198a47ffe ("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total")


Thanks,
SJ

[...]

