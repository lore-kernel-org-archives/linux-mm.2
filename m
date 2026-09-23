Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FDBC982FE
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517EF6B008A; Tue, 22 Sep 2026 20:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1876B008C; Tue, 22 Sep 2026 20:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B80D6B0092; Tue, 22 Sep 2026 20:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1706B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:26:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E35E160693
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:11 +0000 (UTC)
X-FDA: 85243134942.20.FA04964
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9398280008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=niFaWNTj;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790123169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuB5HZ83DEiTy12L1l/fqfuPkHFmU6lDMt8lQEtLu4c=;
	b=XPZWUg2jBJACYX+siMeb7llt1rmh95DPWO0qWaUAODAwclJLXw/fy3zZu6MiDONoXU+x+B
	thFW6OCijoZoEtl4UEGIiHNzbfNsYrtTNDUuzeJ/D8r6X5MFgWEMUwAjioE9JHf48lkKQG
	jqR/a3xG94yT4qDdDETtNQLiMg6nVM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790123169;
	b=gX+g4pBy6rW8x2DsCAVmA4lyHtsUY3rIVNhN3uR7W7MrvU5vCIxLNHdBiIY4j2eczRPQBH
	WZf9Z2Ut+BXxGZbqAblNu7/CDs6BXsqypBVtRnh2peJesHR0h1M7fOoosQBfflDpoLYWak
	66MiVf0B1s6hu1VuGbC9CwQcL4MwsBM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=niFaWNTj;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd58e1e2c7so2044055ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790123168; x=1790727968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EuB5HZ83DEiTy12L1l/fqfuPkHFmU6lDMt8lQEtLu4c=;
        b=niFaWNTjhS8TyEO8SAJPa59BA+26OmXU5VlHi05pOuzK5dVRiiC56wdDmnZ+g7NTnY
         qkxynx0arEk8UyY+InTpkpduZUqVyJ/Gyk6RRtfHp3ajLZyhSDrXNdujReeCrRr9Jf1z
         nSvHmWJsfRXnNXKQI/lfZZbsvloYIw29SKKuApc6Os8rOJwsqIZ4rkUE7PTwDdZ96vSK
         l3UwlBOTxQaWMkwz8VWTMauPFUGVOj5/lbeczTcikXzQl7/YzJICZE+Te8tUkIAEmt7+
         ULYSdCkhXX8c79QOZVx2paHHm/ikZsqanhzvPKShxLps5KpS1Ts25OUEf7BiO5QRs7vN
         8Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790123168; x=1790727968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EuB5HZ83DEiTy12L1l/fqfuPkHFmU6lDMt8lQEtLu4c=;
        b=ljhsfeRcGzlepVeQpimetI+BzZSRwBt4JUcZnLZMKKhxffiOvwPLawtXHEX/SjM3zf
         mxiwwJyxhiFfIdw7y6rhBq935zdz79qym3JSfOwcx451XlWu/Zrw9Mj+j1cdlIbEZN1n
         g2CCLIXH+b4Jg5wQlfLnRv8W2XZHS1S0qnxDLolzpa4AV5k56K/DJ3NCwAxU5blWkaJd
         K91PPPssi+Zf9HI4/2NeOwu37GvElXAvnxkq7/U4Ei8QMJVKVhxu7x8asNCIbmdfV6qA
         29qg9Xpovg/3OGaaCu5AABWVllAayjlcHzgM0DCH1uZMIs7v5RbEArJG8OgL06fVFWiX
         fqpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzR9/eI057p25CpVsUSkHkVfSYWPL1/V6ZEXdQ2MjpuOs2qQiNMtXCKp0Zz9cqYdl+o96cZRo7+QA==@kvack.org
X-Gm-Message-State: AFuF++k4eaOCIZF1PPBonu9PsbQNNteNlI3fvzvsG6GKGUksYd/YUhz/
	azja1x0Lj61IYJdTjs2cijPY2DtTtNG6xNTgwxPYslMfF9vesm41reU=
X-Gm-Gg: AYBFou2G0fHoEqKCgQcEuLlqgXaJTkTlwwwMOA6UU+Z96X1LKbCcB7TKVp3KIy4x3jr
	TXtYMmdvUiIXjypd1kl0ch45K4qoeWwSVPuYKLidDl00wdh2F+I5dAtlFyhSWDUBqp390R76cju
	lcVw73bTjmD4p6OXFcNmg5FVMNl9o6DQxGYWPx0D06oB6z9dlBHfGwgl7ve2qF/yxtv9TVrSJa/
	PWAFmJuCAQaqD6WvhhRR53J3LdvXrWGIvRbCII792KT62eXfRfSqOyBO/uTzzpfknZk4qN6dHPe
	d7HIOr0n0m8PtPp/kV/SA729OFT7fqI9RzCI/+EOwvVnt05l16jRGez7vPvFiuEjEOUN9lYrvlH
	gPuw7rrCcokWGAfN1vp1crY6Jz4I+mpysoEoZ3WcoMZHQnwvzabq/NbVmaQTGOmdUiJJBqhM1tO
	F8rgrX3uqjmWPjlIvIuQBMiukTXwn/ucMJPYamaysO0FmFc1ALbfSpWxjscZqoCp3pb8PzCUUJi
	Cv4EILwpJAhiRzVRYEVlty8FD0=
X-Received: by 2002:a17:903:950:b0:2dd:c053:c20d with SMTP id d9443c01a7336-2df69e00ec3mr7931245ad.41.1790123168457;
        Tue, 22 Sep 2026 17:26:08 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:2466:805a:e198:cde8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a7b76sm2176595ad.20.2026.09.22.17.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 17:26:08 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Wed, 23 Sep 2026 09:25:58 +0900
Message-ID: <20260923002600.1825448-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
References: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yjx4587cp39z4n4oujowb3c9k3f83ji5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9398280008
X-HE-Tag: 1790123169-34772
X-HE-Meta: U2FsdGVkX1/EUQjZgG45hKBpIbNdlTiKdU7Nd6pbYI6fjcioa5OnyuD5Orsz4gvePAnYyJVaakciIDZULaX3q1WOM+lpS583MX9HKWq12hXQ2qFxenUQb9r4XDWk4snt5oKy18R0w6pqOsP0k7yWC6Alco8xAJxUJ5PpVVepsvBg8/ruts+3INIscTwj9YdgCUZLs8HpjF105xTdj65nEGgxjZj6mHhS+YoadXaHKp0GBZFNnm/mdoos9rnxPVHZB2olWhH2Jw6hSQFwv2OxaLkaTpwS4VzY9dIws/ZRD3APIDZo/uKH9ufNNeoyQtrMKGAeWSEn+ERfPy4NxzB22hVxbhr9rli9eWUUXHFBxPcruLutGJLQD/MAIlhlndIcx6SVg1zJMZ6iALkr/aqGo010caMypXlfRt+tzRy5coYDExDQjnFckm98XQT7PI6YAgA2KSzlxJkiaw01DZzmMPkGIi361H+6kk6WhCEeT/UdeVwHtstO/NN9IZcyliycR8FAe2j9J0vf5ew5WwcyGVUdwTQbXbfmE1d2gT5vUKdvWoNiT7X0xW1cly86iUq/fCFmi5jkE459sSYlqbBpQb4pLTNLei7avYQ2lKNkdo469QmptbDpvGeSZY4byPo9dfXAB3YrbINAq1sUkWxihNBAhV6SVkPRMsD/MY01UiO++oCLSJVMt6uCxVxpp4L/3oONhf6qDigq1UCP+e3A/S/VdRY7ZE5x19eAXs9xkA0huuBK8lkadN26fQnwJdx5OJWX2inc/Q74wF6yiDzzBYXc3nmmbgc36HPi+2p7zHZLB/3nVVMqC5QG2NF7lUjpQG6UPgCGmy/9BNW8XqWqyeJVFx/IFWTohkEK3D1ktRyeaxk5lZ0117HZ+TIxGMytV6ey/iUp43SIRXJdo1HdubPT7/+CsOp5mZRsfjhTihD27iCKNtu8AgjLuF35XVehjrfBNfKQgpQ4x8w4/8i
 mk+5KPpU
 6sNWu2AbUHZsBhZ+3Tvv9p2yL5k3eT9V22J/F+bpgvtTRqeN3k0xX+EnkAI2jqhfDwTiUluZqNRD6Z0AT3/oE9Y56upGYKr9REshiKjwyjVwiNyfHm7t/8ovjw14+0iYnDkhf/eYLpJF7ltW9nUpgVwk4rSMmltPYPAmzb8Onz7snk9774qQlR619+zyO+9r9sFp3JO1fFB24oYYHSA3HzypdbaHw9CG1StyZovc5b5fe/s1863vqvNX4QFfHWh7fskG3YUE1St14ZJz6RL6kNrF2+5hpsZIjVLklfyNDYbNiH93+JqBj2k6OoRNj1M2L1q09xJbf23XHDeHupXbvp2Z5Ag//ptnEXxdJviOxg8dhUWXpGGys9V4MoTxirvqkBUY6yucj9rmtKJX0WDE7ORtW5Kzuz+AshATYXbCCvrT3voPU29HJLAsH+Kuks3biSslfuDCzE7jTGiPdB0aLoBUaebSadsW3OJtQTLR2INCvH4bdM3XDf+tmxHf7ifNWup8gI/XfcbV6QWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota
into basis points with "quota->esz_bp = quota->sz * 10000", both
unsigned long, and damos_set_effective_quota() divides the result
back by 10000.  quotas/bytes is unbounded; bytes_store() hands it to
kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX /
10000, that is 429496 bytes.  A wrapped product below 10000 divides
to a zero effective quota: 429497 gives 0.  damos_quota_is_full() is
then true on the first test of every charge window.  Other wrapped
values are wrong without being zero: 500000 gives 70503.

Triggering this needs a scheme with a quota goal, the temporal goal
tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
32-bit, 1844674407370955 on 64-bit.  The scheme then makes no
progress for as long as the goal is unachieved, which is easy to
notice, and writing a smaller size quota restores it.  Nothing is
corrupted and nothing leaks.  This is unlikely to be hit on a tested
setup.

addr_unit does not cover this.  It only scales the numbers a paddr
context writes to quotas/bytes, so a large enough scaled value wraps
just the same, and vaddr and fvaddr contexts take raw byte values.

Bound the multiply.

Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
Measured on i386 under QEMU: one paddr context with a stat scheme, the
temporal goal tuner, and one unachieved user_input goal.  Each size is
written to quotas/bytes and quotas/effective_bytes is read back after
update_schemes_effective_quotas.

  quotas/bytes    effective_bytes    effective_bytes
                  before             after
  4096            4096               4096
  429496          429496             429496
  429497          0                  429496
  268435456       0                  429496
  1073741824      0                  429496
  500000          70503              429496
  4294967295      429495             429496
  0               429496             429496

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4687b909d42c9..4716693ec0dc5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3275,7 +3275,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
-- 
2.53.0


