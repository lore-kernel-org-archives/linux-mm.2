Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52982CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 16:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B952C6B0088; Wed,  6 May 2026 12:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D746B008C; Wed,  6 May 2026 12:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9E36B0092; Wed,  6 May 2026 12:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7606B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:37:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AF66A0172
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:37:09 +0000 (UTC)
X-FDA: 84737549778.23.5BAEC51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69953A0003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:37:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHTrrfeT;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778085427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3yGWy/0yrJcGrBuLeNd6K2W41yF3Jblr6VvjWeHFjk=;
	b=FfdvlJP/Xaq63OOPBwFmB0d4SwsQ/W4d/TBtxFLlihJpirYxQJhJzzbuWs7ACOA0S758Xg
	vxTHbVERspVYZavj7KqQWW9PleUYkW+KYmd3M+FeeG91k76Q3StbbqeXcqqHjoq/sYOPi9
	c7FR8z4BaoVBjlJrQe08gZ6o9nsacgQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHTrrfeT;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778085427; a=rsa-sha256;
	cv=none;
	b=iloG0VZT7wYvZLZhJabo6zSXnatdURe0vsprsBxfJewr/EAXF9LydOmQhV+ndQj8NeN6uG
	RNGB0rTTT4jNEZAKL109cHbjCVAInWAy0BO34Iy4uK//ml/PDA+rkG5b+VI087UGepPP9V
	mnwLm16vXjWcZHU6/ggsYtYWf3mmnbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A6F444268;
	Wed,  6 May 2026 16:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC35C2BCC7;
	Wed,  6 May 2026 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085426;
	bh=VwuzcDo/M8l3F+D0/joF1sxuSTpVoiJuVAJ5yOeJ4b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHTrrfeT4OL3IQ8X06TgzDQcRFY0o9S3WHVBH8jNnazDoRUbJxNYXmck8XiAZMLBF
	 TwwxAY23Z2ralePvItMXUIGRGwIhJkYOqloSzQqIWdS/M2fkUxPWSgNLT7SFQtko2g
	 3EdiYfsyZD2+HVEcBbp290jWKoHWWtpHTyoOnkweThjPhXINXsiObVPu62vgtXLw2I
	 O9RpunDiNdM7eRncL9W5RtOhLCq394Ci2x9wtnZ/oie/6srXrCMEK0XVgoNfqyGehn
	 qI8tTEHhgyklddRfCXV7USaMQsUd6jnTCpiviwdiGkOceisj7OowmcKkpJkq1iQLF1
	 U5jfy4DjWdtcQ==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
Date: Wed,  6 May 2026 09:37:00 -0700
Message-ID: <20260506163701.6288-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260505145212.108644-1-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dh848apyesiwekxfag9o39hq3t7dsz9w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69953A0003
X-Rspam-User: 
X-HE-Tag: 1778085427-866516
X-HE-Meta: U2FsdGVkX1+fD6d8rMPCjaiKnETgyrTw9/y7klhZqHyXGg1YXgdA12qpIm6DHnw6643k37221bNpjJCUOQ7shNK0dtzA+9RW7bqoj0QQYGPPh57poexJB4hOc9i2CYm3YH7e37TyRosaKfx7gYPS/VS8YX3v48HDqZa/mOI4E/sMe5SuLx625a+RoX1mE4Yp+/2zm9sHEwzkoKH/JgLehZkYzALOsilXQ034bSKK20Ruvqw/fBo+2qCYTYoa0DJQmE7Kf98IvVKjtZGn3iuY4Wv7pFPN1/IxWWqnH3ZsQkkvWRmBQA60ibN4eKLwjj28eP9PKZ31v9S1BiI4kU2fDSG7Hkv+EiaRgxqIZjpY3m6iQN8mEcYnOSjc9InlKYhIcifUv9cK14S6WjNIX+NYGefnVSL2WsxlTJr1DKoJKYPtWH8qvz6GcQ2yq/YWYs2G9sR1uskZwJv5cFBD3two0ui0UFXPmlaBF9dHZ55CQybMwBbMgFUfUmtGlBA3fvoM+cLroBp+OIFZz62gzbZtWTLdIzuUO3mnZbGhIVBQF0vcjTgoCZkwy8axsGfm4fR/pidx45Ur/zTA3XqY/6gLalVxYuEZA4Um5fV9LzKtqVwlANbFp2kzu6zZLFjV/h/ItFVW9N//vOY6vOPzsInyXhOb27rYcWOfHa5DJDG2EzkxY0lT+Y9VEm4dzC3iFi83BlWBrD7Ofas/H3ldj3MmIMD6ecakIlO0zKn+sRElhrmX7CBqE9a9TS1XjVo5k+0v/aSMvWl+DcLvlsTcFNdG1JSx5R1GktfrmiTfVfr2Zk7iAl55Om6/X2rJLiWXJpP4OOpJigV1KepQDHLsZPBFWWzG7LGvjfiffDMYUUyGQN9Pj74rx8pNmKGY/ylKIKJG1EvNpwSP70nHG0tQ2OD7V6vOHr0k0y5I1pL0SaS3AOsfZbeU+CNqqidCMx6Ii26w6hHfOHUgPKjS3LvhVkj
 JWotNaP1
 wQUSgweBFVoZKMmArMyL80LAo6ljyiqKPFIN0S8vjMeK1jm7fCGqMclFkhSd0APZvFyADx6Mm68m8ukUHWSMN38+QMuwgv7IO3jb3ljGzhj/gzTbFeu/QLrBmyXlktctPsnM+lFUWibWJ05FkEt5BWCbkE4hWcO5xr7IjU8k2LLFnPkf8omtVgGwz63Pb0AEp5MZFkGBN05wRQUHK16ZibV9DgXmI15QEUWeNiah9ZtNhvGpts8ssuPQvSFsRpr6D6X8e7K7iSd6uOH+7oumjkYbInlQ5iqV+5yiBwr0UaDL6+IUSfMS30xBKPM6s0BmHybpsf7hSxaxGszSQqyGVVm/fbj3+p2xB2+G2EFHqppYdLV1CkxZJJRwimhRkjnNnySVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jiayuan,


Thank you for posting this second version!

On Tue,  5 May 2026 22:52:06 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> damon_rand() on the sampling_addr hot path called
> get_random_u32_below(), which takes a local_lock_irqsave() around a
> per-CPU batched entropy pool and periodically refills it with
> ChaCha20.  At elevated nr_regions counts (20k+), the lock_acquire /
> local_lock pair plus __get_random_u32_below() dominate kdamond perf
> profiles.
> 
> Replace the helper with a lockless lfsr113 generator (struct rnd_state)
> held per damon_ctx and seeded from get_random_u64() in damon_new_ctx().
> kdamond is the single consumer of a given ctx, so no synchronization
> is required.  Range mapping uses Lemire's (u64)rnd * span >> 32 on the
> fast path;

Could we add some links to the algorithm?  I found a blog [1] from Google and
guessing that is what you're saying, but I'm not really sure since I failed at
finding time to thoroughtly read it.

> for spans larger than U32_MAX (only reachable on 64-bit) the
> slow path combines two u32 outputs and uses mul_u64_u64_shr() at 64-bit
> width.  On 32-bit the slow path is dead code and gets eliminated by
> the compiler.
> 
> The new helper takes a ctx parameter; damon_split_regions_of() and
> the kunit tests that call it directly are updated accordingly.
> 
> lfsr113 is a linear PRNG and MUST NOT be used for anything
> security-sensitive.  DAMON's sampling_addr is not exposed to userspace
> and is only consumed as a probe point for PTE accessed-bit sampling,
> so a non-cryptographic PRNG is appropriate here.
> 
> Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
> usage reduced from ~72% to ~50% of one core.
> 
> Link: https://lore.kernel.org/damon/20260426173346.86238-1-sj@kernel.org/T/#m4f1fd74112728f83a41511e394e8c3fef703039c

Why are you adding the above link?  It would be good to add description of the
link on the commit message.

Other than that, commit message looks good to me.

> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  include/linux/damon.h       | 27 +++++++++++++++++++++------
>  mm/damon/core.c             | 12 ++++++++----
>  mm/damon/paddr.c            |  8 ++++----
>  mm/damon/tests/core-kunit.h | 28 ++++++++++++++++++++++------
>  mm/damon/vaddr.c            |  7 ++++---
>  5 files changed, 59 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f2cdb7c3f5e6..e16012a7f41a 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -8,8 +8,10 @@
>  #ifndef _DAMON_H_
>  #define _DAMON_H_
>  
> +#include <linux/math64.h>
>  #include <linux/memcontrol.h>
>  #include <linux/mutex.h>
> +#include <linux/prandom.h>
>  #include <linux/time64.h>
>  #include <linux/types.h>
>  #include <linux/random.h>

Maybe we can remove random.h?

> @@ -19,12 +21,6 @@
>  /* Max priority score for DAMON-based operation schemes */
>  #define DAMOS_MAX_SCORE		(99)
>  
> -/* Get a random number in [l, r) */
> -static inline unsigned long damon_rand(unsigned long l, unsigned long r)
> -{
> -	return l + get_random_u32_below(r - l);
> -}
> -
>  /**
>   * struct damon_addr_range - Represents an address region of [@start, @end).
>   * @start:	Start address of the region (inclusive).
> @@ -843,8 +839,27 @@ struct damon_ctx {
>  
>  	struct list_head adaptive_targets;
>  	struct list_head schemes;
> +
> +	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
> +	struct rnd_state rnd_state;
>  };
>  
> +/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
> +static inline unsigned long damon_rand(struct damon_ctx *ctx,
> +				       unsigned long l, unsigned long r)
> +{
> +	unsigned long span = r - l;
> +	u64 rnd;
> +
> +	if (span <= U32_MAX) {
> +		rnd = prandom_u32_state(&ctx->rnd_state);
> +		return l + (unsigned long)((rnd * span) >> 32);
> +	}
> +	rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
> +	      prandom_u32_state(&ctx->rnd_state);
> +	return l + mul_u64_u64_shr(rnd, span, 64);
> +}
> +

I was unable to find time to thoroughly read the link I found, or understand
the algorithm with only the code, so tested by myself like below.

'''
$ cat ./foo.c
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
        unsigned long span;
        int i;

        if (argc != 2) {
                printf("Usge: %s <span>\n", argv[0]);
                return -1;
        }
        span = atoi(argv[1]);

        for (i = 0; i < 1000; i++) {
                uint64_t rnd = rand();

                printf("%lu\n", (uint64_t)((rnd * span) >> 32));
        }
        return 0;
}
$ gcc ./foo.c
$ ./a.out 10 | sort -n | uniq --count
    195 0
    194 1
    188 2
    223 3
    200 4
'''

So I expected the program to generate number 0-9 randomly with similar
proportions.  But it is generating only numbers 0-4.  I confirmed doubling
'span' value makes it work in my expected way.  Should we do that here, too?

[...]

Other than above, code changes look good to me.

[1] https://lemire.me/blog/2024/08/17/faster-random-integer-generation-with-batching/


Thanks,
SJ

