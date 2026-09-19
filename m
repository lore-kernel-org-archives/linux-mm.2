Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA633C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 16:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863D86B0088; Sat, 19 Sep 2026 12:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814AB6B008A; Sat, 19 Sep 2026 12:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706516B008C; Sat, 19 Sep 2026 12:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46B1F6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:55:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB3D0A51D4
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:55:19 +0000 (UTC)
X-FDA: 85231112358.08.C3CCF58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5748FA0004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:55:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MX2TRb5V;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789836918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTL+OmPRLFphC0ptL3M6yHVhta+LC8O4dSAbgUBWAxc=;
	b=Z304E6yL8tG6qbR+C2k64Z8CrG45QV7lkOnuh4xnyKVjeC/cKz7JjLvizvE0WCplGbI29P
	ltkxEOps7XihDIOukEcf7zo/fpD60IAxAJZiuqP7LvMKZ/vkKDPFbhPgg0o99mxIph4ZTX
	YL3IsWqniy/uwutil4zhH7bPQRSMpC4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MX2TRb5V;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789836918;
	b=IZ/eQrJUK7hmFIEWoRKRt9GmzoJOhSiq226zgufIyThW1cEWGMtaLz2FhGsYSaB/SCmsCu
	KbIUIBpLaNL3FmRny5elYdQbXUeel1VxoXY4DrszvsPpUMIdto/FDdVWPHt5jPqtplCx84
	5jP/RHb/ne6sByTSmw77+Ugc1SpiRUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 029C9601FB;
	Sat, 19 Sep 2026 16:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7799E1F000FF;
	Sat, 19 Sep 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789836916;
	bh=XTL+OmPRLFphC0ptL3M6yHVhta+LC8O4dSAbgUBWAxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MX2TRb5V8MCuV0MdsY0f55GswqhuxVjZrY5ZCRsgUwYSrKjqkxWgiD5qbky7Jgxhi
	 l3MAzNdb2gHtJGYdZQF5YKUvL/HH79uhGg7cGPfcD43nr1T48CLSrqlrFjZMGHcExI
	 OI5X4PUc0+4OjGrmzK64ITPH/eWDvALyQIZjWmAvMghY1Wte3VIiHqS1SVX/eLdMyI
	 hgo/wkxudwZC4KhYUcd4d+yekTHSYoZOIXGu+GexePxKEHWN2Hpcnc+ux8mYfigLL1
	 NFGCREMqU/83Acmn4qKjMpRpMhEOTEASAYDLiaUgoVgPrg0wQBnntAZlnMrkIxa/ch
	 Bt++zhanM8jeg==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sat, 19 Sep 2026 09:55:08 -0700
Message-ID: <20260919165509.86678-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919071324.1583280-2-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5748FA0004
X-Stat-Signature: zng5oc4qq56p7w1m9xm93ktrczy546hw
X-Rspam-User: 
X-HE-Tag: 1789836918-110883
X-HE-Meta: U2FsdGVkX1+zcQpUBoksUsuDBnp6Gr3/YlpSqq5xVRkdlGfpDMLPpnppIft9cxCdlpmbh1lGxpgAgp18S2/DUF/o5fHwMSTpRC0ZuzcyDL+AUAGJiHcvh8JnXcJYideGN0W405QeaTml5qffDcXGq5xUGo8igK/XXCJ2ONrA+cGtJ+V6cOEBZ1/CTEWlT7vJRjfRSkTe6yX7i0zogbimeNIjIbvyzhqyjnhpEwl9IQQizxwv3EESLcsCUbXQjqBnFnx9lzatNFYFu3G4U6bO93pXc6zFL3MRmeUv5C+bPEWD98c2OU0ztN0029HkOp4wbTFpuDiTIcuP+RjAAsEt6aUFNJm5zBlML6PYSXzpy75dly7ABZrNkdVToSmCMzzA3xeYeKlCwXt6vOkuBugcWjRRI/AukjF5YwWAJ1DCuEALLkoS3vw7WdZ8t+Y9ytfJ60iGZClem9dD9nWJKPGnT0vQjG4avMiNWbcwzBnP3ZJ7J0n+wjT1VJTRH68h8ytt/SkpgO4lohSGtPuP/+cSvb6PmfFnnsYX3R5z2SEaD8ZcNWa9DSDOM4rsI3nfT3GsZrH+UL1S77jiA2i4ZHqZ7SPIySPS4XMUvYTmdLNeMUDy2Q8AiIflwXoP4/UjNTveGa3pHTmSUHapHReeghaYer8NOqImMQOEYXlspDHMd+Ln9aeV/kdiH5HsyS8hIBr0l76Fuoh3bRyWt5Tzi2Q9rQruAoTArbDB8TEhW19yfFdWkImvRKtS1W4h0xD4UEchLaxqhPsRxRZNvC+G1wJFw8sFP6p4X1AW4XhdaK1U9qgklfF+yrl4seLK1kGtuWLktfA32h8BpwCeSrgzx17Ftbh/TcGg57RfRwqRJf1iwvkJb+lqm5A4bDJAmuPW3b0CltiRXnF1d7Wb/I6UtxY+AJJYS3aZVAkZQnb/DrTMt0FBr4/cI+zLaYcLhF1xKv/SQrMQEYqiVsbGqQDBKTZ
 T9GcXmqt
 vLgmejMD7BCsFnLX9YySTWuonZfB1v0PbWEl5N2pMPSPzK3Kd34seuy7U7kN0W1RATiU2P9rCp5ZdU/qmNqC7j2BzA25Dl5haTlv2glR56FD+AhmGjajiY4JsAh9Zeqx4B5vVt1y+1pZwjRVItQC5IOnZI3J6RhyMHrVXP7yqSQdQZEQ105MSV1bArhi1SwJSx1KLYGMtJCQzvcXok9UbuRHuH73pcQVQ77n5jyrXuH0JWp9dU/y6k2DAmOQnDCfpYiHOOBOe6RnoC2zS8NzRGoq6k+WuztPh8QGobtCKfI28gTolmOborFIFYyg8sGOyzJDfNH7OeaJt4pQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Donggeun,


Thank you for this patch.

On Sat, 19 Sep 2026 16:13:23 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
> basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
> and damos_set_effective_quota() divides the result back by 10000.
> quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.
> 
> On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
> that is 429496 bytes.  Documentation/admin-guide/mm/damon/usage.rst
> instructs "echo $((1024*1024*1024)) > quotas/bytes", and 1 GiB * 10000 is
> 2500 * 2^32, so that documented value wraps to exactly zero; 256 MiB and
> every multiple of it do the same.  quota->esz then becomes zero while the
> goal is not achieved, the trailing "if (quota->sz && quota->sz < esz)" can
> only lower esz further, and damos_quota_is_full() is true on the first test
> of every charge window, so the scheme applies nothing and the goal is never
> approached.  Other sizes are wrong without being zero: 500000 yields 70503.

For 32-bit machines, we have addr_unit parameter.  I believe use of it could
effectively solve this kind of issues.  Correct me if I'm wrong.

There could be cases that addr_unit cannot help, though.  Particularly, if I
remember correctly, 'addr_unit' works for only paddr.  Also it doesn't fix all
theoretical corner cases.  Even on 64 bit machines, same problem exists in
theory.  So I think this change is worthy to have.  But I think it is better to
mention existence of addr_unit and why it is not the perfect solution in the
commit message.

Maybe it is worthy to add the comment on the user documents, too.

> 
> Saturate to ULONG_MAX, which is what the same function already writes for a
> scheme with no size quota.  Widening esz_bp instead would reach the consist
> tuner, which runs the same field through damon_feed_loop_next_input(),
> unsigned long in and out; bounding the multiply keeps the change to this
> branch.  On 32-bit a large size quota then behaves like no size quota
> rather than like a dead scheme.
> 
> Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
> Cc: <stable@vger.kernel.org> # 7.1.x
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
> Measured on i386 under QEMU: one paddr context with a stat scheme, the
> temporal goal tuner, and one unachieved user_input goal.  Each size is
> written to quotas/bytes, the kdamond is started, and
> quotas/effective_bytes is read back after
> update_schemes_effective_quotas.
> 
>   quotas/bytes    effective_bytes    effective_bytes
>                   before             after
>   4096            4096               4096
>   429496          429496             429496
>   429497          0                  429496
>   268435456       0                  429496
>   1073741824      0                  429496
>   500000          70503              429496
>   4294967295      429495             429496
>   0               429496             429496
> 
> Everything the conversion can hold is unchanged, and 429496 is what the
> no-size-quota row already produced before the patch.
> 
> Patch 2 pins the same boundary at ULONG_MAX / 10000 and so runs on any
> word size.  Without this patch it fails on x86_64:
> 
>   # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1959
>   Expected s.quota.esz == max_sz, but
>       s.quota.esz == 0 (0x0)
>       max_sz == 1844674407370955 (0x68db8bac710cb)
> 
>  mm/damon/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 2258b72da7a7..5ec476cef4db 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3274,10 +3274,10 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
>  
>  	if (score >= 10000)
>  		quota->esz_bp = 0;
> -	else if (quota->sz)
> -		quota->esz_bp = quota->sz * 10000;
> -	else
> +	else if (!quota->sz || quota->sz > ULONG_MAX / 10000)
>  		quota->esz_bp = ULONG_MAX;
> +	else
> +		quota->esz_bp = quota->sz * 10000;
>  }

In my humble opinion, this could be easier to read in below way:

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3524,7 +3524,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,

        if (score >= 10000)
                quota->esz_bp = 0;
-       else if (quota->sz)
+       else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
                quota->esz_bp = quota->sz * 10000;
        else
                quota->esz_bp = ULONG_MAX;
'''

What do you think?


Thanks,
SJ

[...]

