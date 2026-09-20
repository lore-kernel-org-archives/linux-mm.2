Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9325C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F8C6B0088; Sun, 20 Sep 2026 06:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B99F6B008A; Sun, 20 Sep 2026 06:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880A36B008C; Sun, 20 Sep 2026 06:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55B286B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:37:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C8911403E6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:37:20 +0000 (UTC)
X-FDA: 85233788640.21.69FF58C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 884F1140004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:37:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+DdoqQX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789900638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAz5WKlIIeHF85M4yCOIdRqGXhQBHryX3PT3331YGnQ=;
	b=yURcFsBphMCRQShMvjMK525+KL03qWJfZ5BtQxjfjn6qtzpq6FpO6PeDeHRioUrwuSj8fh
	7s353Ndv7Vwf4ZHrezJnEvlwno4XlrC9MiSD38VvFHJ3r3GyscNZ13lzkLaJOSyBkZfl/x
	SxcdH4jhTFsgpvO7D9TkIiIor7uOZUs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+DdoqQX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789900638;
	b=k0tU5NlH39doyfQhsi5zuduleeWUJaLn+MM5eBhdu8IeXQ3Wkoh2WX5yMsgUqSsb9Fcqvx
	IvSqLEJHBbHGY/xVEF4Qv+gbdbYvPeqM21vxYSNeoCIHvMLThl29Iwpr01ZkTIrJ0SVkNy
	2jrgNc+F8Qm0h6gS/Xg7827gic/0vwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B932541A99;
	Sun, 20 Sep 2026 10:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4677A1F000FF;
	Sun, 20 Sep 2026 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789900637;
	bh=zAz5WKlIIeHF85M4yCOIdRqGXhQBHryX3PT3331YGnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+DdoqQXb+RkHW7uVK3ucMN/7hM+BKrQVKVxnstWLQ2HXJePnbBGEs+EAjzCWTdxU
	 q9z+ewWNXHNPWVA1KtM2R08TQUYpgla0EClPvikTlRTHEUUgqSWABQ0wLW8ACFgQvO
	 PkU9U71ZrbELjogVXAPjLtqZuFBwn1lWlJot00UU/MlRQL7/pyWv2Z1XeW5QSF2Owf
	 7Q4Dkt/9f+nsFJ6OAG1XlfMkRLDNcP2gvmTR8Lyp9uEOElvmCoxOfYMhzj2xnBeoVa
	 o6D9XHXgvu3dRDMLoOthG9Rh+0neM+GnTzZf64+5tA1Zbfj7zNKh/Mqpfq2x6oyk74
	 UVbKB5igqIU/A==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 03:37:13 -0700
Message-ID: <20260920103714.47722-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920023111.2466265-2-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1hb9ai4uxdh7biiumoga8xfog8ky57ts
X-Rspamd-Queue-Id: 884F1140004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789900638-217025
X-HE-Meta: U2FsdGVkX1/f6grNJkMD/YdgqGJSLYH3/DSjYfK+zEMnP1C+ct7dqinmNlcofpGx4pdZOLIaGOHDTpgP0Df1fDUEHgQZuYyDmGjBlQT0R3liJGxgm3pOKU3M/A5BMhl1z1RgdLQpXdqno7scuWWaA5bRiiObrpadQ+Ef8YbLMYqZAI98lXUF5WKiAapydegcpdQuNiOD46G7WQaDyzI2W3A3XWRNze5cT3DAiQZ53nUjK8nQ0Q6Cak8cPZAsPJi6CAbGFvo1MtJLm9w6QlZbyojouVI3g6QkyHIE7RQEB+swCtDPQCwVCDO0HVgmMX+uLryQB6N+1RrLYWcTC0SMXMF3UVDALBQIJCTps4QmT3mDDYZ5oPLIXknGtAXQR0JcgXv31eC6VH6+cY9euuQ0B0T1gp6aumCMWibrcWkws/oL848sWzq8xK3lW9Zo/zfD5nfTPYOc8mFXC2LL6gjpTIVc6/TD8BZ9mHcbeTc+w6t5lSHlCAcZOUm13otxcGNgytzAXrgKJ5MIFqBY0zU1DRVEdoV1ickvIqHhGrosuQY54IF+fDHGr6t8I5FO+Q0iCo4ZRm5tUSYOrQ8bxHaZQmud6fXeEh3QgrC2c4k3rPiVLvBIJoOh88bZ5bVk3R5SdSgtiS7UY/sL1SaX9exoKKN79gY9WXbU4lhMfPchCdi6eJ9feQK5sO2tymQfmv9mn4yypy1bPmRWybfd7lyIku7hqSUaihGheDtXhvdEagaqFQcQ1vQwURCtUYngN/hXC3bRLGaulE3ZJPEv8jW+RvI4nIIyEyE8xmoItHK5VBwUuvH9uslzs6LfLnd5jyykhf9p0S72Wb1IJXcCOYIKIvkHQEGJjtJUzYZs9i1F/rfqgTOImGKrHo1N6TOzDcAwzmvkdR/dfaiMvjPYS7fBxAl3GPLUPuiHISifiL2EeyTePnlIsOFm78DKbWjrez/FLgv45HA+WyKFT3FpYn8
 S4ccMP+p
 lj3QMf7JNNfc7VhhMaMJQTNZMD2550SzrRTn7Omxqz9KtR4XMUdU8v44p3C6uHKjMdS+cdzvfpLOnHEJpfnZggtr4BJkkEzCCTBIls07XqRDeI8gGA8sosi9GMYH7NyQFAdh2RWIbcrAQ4NRvz54OWSDtVQ6RhnDmgErSDYQjqWC5f7Hk8IZixpAeX+TBLW4nL6B26EOP9B5g2dpgOAZD0I5nY3ZeCvXbISPIJNSfYiFJOJ9WJyzNSOGPCxka9VvC3s1p0QrwoaAE+3kKJbdAF9LbFQaZd2pypN/KB4A270QnlpX3ewJMn77h7hX8Qclo9Qa7K5IFlFw3F7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 11:31:09 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
> basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,

Let's break commit message lines with 72 columns limit.

> and damos_set_effective_quota() divides the result back by 10000.
> quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.
> 
> On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
> that is 429496 bytes.  Documentation/admin-guide/mm/damon/usage.rst
> instructs "echo $((1024*1024*1024)) > quotas/bytes", and 1 GiB * 10000 is
> 2500 * 2^32, so that documented value wraps to exactly zero; 256 MiB and
> every multiple of it do the same.

Why 256 MiB, not 429,496 bytes?

> quota->esz then becomes zero while the
> goal is not achieved, the trailing "if (quota->sz && quota->sz < esz)" can
> only lower esz further, and damos_quota_is_full() is true on the first test
> of every charge window, so the scheme applies nothing and the goal is never
> approached.

So, the way to work around is updating the size quota to smaller value,
correct?

> Other sizes are wrong without being zero: 500000 yields 70503.
> 
> While the addr_unit parameter effectively mitigates the overflow risk by
> scaling down the values written to quotas/bytes, it does not fundamentally
> solve the issue.  Theoretically, an overflow can still occur if the scaled
> value is exceptionally large.  Furthermore, because addr_unit is exclusive
> to the paddr operations set, vaddr and fvaddr contexts remain fully
> exposed to this overflow since they take unscaled raw byte values.
> 
> The 64-bit boundary is reachable without any scaling: bytes_store() takes
> whatever kstrtoul() parses, so a quotas/bytes above 1844674407370955 wraps
> the multiply there too.

But why a sane user would set such huge number?

Because this patch Cc stable@, let's make super clear about the user impact so
that people don't unnecessarily be scared.  Please mention when the issue can
happen.  It can happen only in certain user setups that probably untested.
Since the consequence is easy to detect (scheme makes no progress always), the
setup is likely untested.  Please also mention it does not cause critical
problems like crashes or leaks, and can be easily worked around by updating the
size quota.

> 
> Bound the conversion, so a size quota it cannot represent falls to the
> ULONG_MAX the function already writes for a scheme with no size quota.

I don't understand the above sentence.  Is the grammar correct?

> Widening esz_bp instead would reach the consist tuner, which runs the same
> field through damon_feed_loop_next_input(), unsigned long in and out.  On
> 32-bit a large size quota then behaves like no size quota rather than like
> a dead scheme.

I don't quite understand above.  could you please elaborate?

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
>   # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1970
>   Expected s->quota.esz == (~0UL) / 10000, but
>       s->quota.esz == 0 (0x0)
>   # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1974
>   Expected s->quota.esz == (~0UL) / 10000, but
>       s->quota.esz == 1844674407370954 (0x68db8bac710ca)
> 
>  mm/damon/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 2258b72da7a78..16d4145379a2b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3274,7 +3274,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
>  
>  	if (score >= 10000)
>  		quota->esz_bp = 0;
> -	else if (quota->sz)
> +	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
>  		quota->esz_bp = quota->sz * 10000;
>  	else
>  		quota->esz_bp = ULONG_MAX;

Code change looks good to me.


Thanks,
SJ

[...]

