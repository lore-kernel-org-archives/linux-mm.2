Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20879CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 08:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D662D6B0088; Thu,  7 May 2026 04:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFB56B008A; Thu,  7 May 2026 04:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7666B008C; Thu,  7 May 2026 04:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75966B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:10:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7466DA0433
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:10:09 +0000 (UTC)
X-FDA: 84739900938.25.55C40BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAD2F8000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:10:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S48tYFtb;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778141407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvV4tIAtJckInZuxgTEMJPI33JEzO7iXVCzuk4atetk=;
	b=iB2DWDNXecrNtaPNjzjCatxXVfZUqRASkuKSWorXwF6fzaAs3jdQUxslqk7gQ9STyYSG/f
	wEZEvZJ/l1pyoGLUzFu76tgJahYm7fZxZAyB0TboBtHe2grM24h45Z3OBy7YwmRHGpWWS2
	fgTnM9FS8U8r6hCQ8OzZCUZJGjdOj6c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S48tYFtb;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778141407; a=rsa-sha256;
	cv=none;
	b=HH1Bd3RnZ9pmvH+VMOvEgeblFlh99H/G98FpAfk18KnXUscSJVhkn4wmDTRmxvIy29JfE9
	lYn7pzLX1kSrZoz4QV8PFWqT9YYFwBLK7ILkZp39UFKgxOwwWwkzzwWxVUvOfraW3RZ/UV
	cyjTLRF+mXrfe6vPLrtrYu/5FrrVz1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 296806015B;
	Thu,  7 May 2026 08:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678EEC2BCB8;
	Thu,  7 May 2026 08:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778141406;
	bh=wznC1/DjH80ACv9BktGFOg6DgVpw8UaggCBEOgh/FWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S48tYFtbp9N0Alm9+cBQpFN2IPDOnrNOHfarS8PKslYCpwMwkObBP9RCgAWjJBcm0
	 QvPY/EySe6t/Af031bef8Gx9zq3ujaZ34n6JHMfwp4Vrp86QGgV+ua6g6XL4UME32X
	 GmSarj+TcOrfD1GhStz9aaBpE08g+a07yJPEKI8Mc/prwAB8lznA8qVs2IX5ZQZGLI
	 2HzQOCAif1DXZ+9yFyIKDJzQYzMremz1G6ozKtixP76lSgExyZBuN5wEK+y/hgCoik
	 eM42lpG9GqOTsqEupPM7WgqdGHKCSRWMx7SYXzlr0jeC6SE67qob9JOVDKVjOO2C39
	 x9326DbwwVY9w==
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
Date: Thu,  7 May 2026 01:10:00 -0700
Message-ID: <20260507081001.11427-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d053e344-7643-4504-b766-a04f2b4a6569@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BAD2F8000A
X-Stat-Signature: bzt8fgseu5uby5gcyorxpkx8q6n4ukr9
X-HE-Tag: 1778141407-796041
X-HE-Meta: U2FsdGVkX18PfK5HDdUNzQOE2vfoUwhpzqvzo/EqnzCpliMLXKRu0pV9n6JEo/9/2oDmkkFLNQOXkWnR9XvPRBqE2VOw6wgUF93KuzOEAjNuIapzS5NlxS8YrTK/+/5Uokv2+zW2Y3JxzfWeKWhiwaDe3Nklxw2KhSwGnDVvrzGcdyqoKZBdChd2kIwFSIiqX9wmA+W8wGlhJUZNBtW/2Z1gZwkVLZtogEoGDyvc7DOLIV9muIlYtTvcHFpamQKimV3LVSuveegyUv/Kfohlkk+Q22u5nYDLOIbTdURBVeg3dUO4S4g8C5LOKkIg0NzuSYNfD0kJcuY0vCwXdlmiif2s+9E2DX7OfR+183KcoRIQT5dW3wkFc607iC4/6ikMW71+WKHcU6glhyw4pN8qG+Ag3lXVOJQEhJPzYfCIh1ka+WBnVUb0EyPyJoyH+L3VDDadb7HV1k428/2iu/Fp33Tb9kFS4UpyZf0a0GgwzND+Wr5F0H0XtaK8TSO/i0UlwcF291x6ELHfB2OvmI6OzN9m//OldtuOb3/qzifYkGpu9C2r7JN9U5W9IiTjAAu2j2DsV9VduRc91kX/pm1DFs1CkJVhYK+82mdatPXYxCG4jdIFiPZtWFqE53Lme21KaT09JekK0WnQgj89e3o8B3TX5b2+O5YVycPXEHsiifHf9VnMYC5TcHquhelfBogFzp1Ugo+frb4JGu1ym/Z4jWdvvpoOxxDoptZExL7QH5hXj1figpimvOf38KUhIyxmhswpKuChB57RKTOBHf2xr/lAvg8+yqIH5j4pwJ0QvJZ/A78vzPCaEo5pH9luEJwVigJnrejv6lw5tWUz/jFfLNGxgAaQwwVoRs5BPAzSHUgAA71H+b5yYJP6Q8NeI0gSBCs+LzINfaXQe7Kuekq8UA9RqPTkjCYSd40oLrjC6OOTGjz82wVJCNET3vj2g8z71ATbjCBKO81qIZCCnqB
 8yVAW9Nf
 YDwb3QipAWUc6CT5+0p8s79l2jo8+STAOoi938bKq1xt3hkKkybZpj8Jf6xiAx4/TM6OUPOtMdwiFsXCjkOB13tq5DLD+Wrh531DCYooc7JVM3myBsrKTz0KtZxEaS1huggf5xruDtgbFhHk6iagBqBwDW/KXwpVrRFURFqwNVOk5L6bR2vkC8ZqcK+Bvt2CSN245ra07fbgiFqiZILmUL5P0pyjXS0Wa0H5FY0/7MHUoH2sjkaO20xxv/DqqVgz9R2Lm7ICkE/1s3JUbjh/1nWvwycm5BXMK2Sw2WOR+AMInZIcYWV2RsGoEN/OgQQ725CCTzqs6mDAO0ZQPYtcAR2mZ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 07:41:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Hello SJ,
> 
> 
> On 5/7/26 12:37 AM, SeongJae Park wrote:
> > Hello Jiayuan,
> >
> >
> > Thank you for posting this second version!
> >
> > On Tue,  5 May 2026 22:52:06 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
[...]
> >> is required.  Range mapping uses Lemire's (u64)rnd * span >> 32 on the
> >> fast path;
> > Could we add some links to the algorithm?  I found a blog [1] from Google and
> > guessing that is what you're saying, but I'm not really sure since I failed at
> > finding time to thoroughtly read it.
> 
> 
> 
> The link covers a related family of techniques, but I don't
> think we need an external reference.  The pattern is just the
> multiply-shift fast path that the kernel already uses in
> __get_random_u32_below() (drivers/char/random.c) -- (u64)rnd *
> span >> 32 -- which the existing comment there calls "traditional
> reciprocal multiplication". Of course I can add simple comment like
> 
> "traditional reciprocal multiplication, similar as get_random_u32_below()"

Makes sense, thank you for enlightening me!  And yes, your suggestion looks
very good to me!

[...]
> >> Link: https://lore.kernel.org/damon/20260426173346.86238-1-sj@kernel.org/T/#m4f1fd74112728f83a41511e394e8c3fef703039c
> > Why are you adding the above link?  It would be good to add description of the
> > link on the commit message.
> >
> > Other than that, commit message looks good to me.
> 
> Will move it to the patch changelog (after ---) instead of the
> commit message

Oh, so the intention was the patch changelog.  Yes, let's add a formal
changelog on the commentary area [1] from the next time.

[...]
> >> +#include <linux/math64.h>
> >>   #include <linux/memcontrol.h>
> >>   #include <linux/mutex.h>
> >> +#include <linux/prandom.h>
> >>   #include <linux/time64.h>
> >>   #include <linux/types.h>
> >>   #include <linux/random.h>
> > Maybe we can remove random.h?
> 
> Right !

Thank you for confirming!

[...]
> >> +/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
> >> +static inline unsigned long damon_rand(struct damon_ctx *ctx,
> >> +				       unsigned long l, unsigned long r)
> >> +{
> >> +	unsigned long span = r - l;
> >> +	u64 rnd;
> >> +
> >> +	if (span <= U32_MAX) {
> >> +		rnd = prandom_u32_state(&ctx->rnd_state);
> >> +		return l + (unsigned long)((rnd * span) >> 32);
> >> +	}
> >> +	rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
> >> +	      prandom_u32_state(&ctx->rnd_state);
> >> +	return l + mul_u64_u64_shr(rnd, span, 64);
> >> +}
> >> +
> > I was unable to find time to thoroughly read the link I found, or understand
> > the algorithm with only the code, so tested by myself like below.
> >
> > '''
> > $ cat ./foo.c
> > #include <stdio.h>
> > #include <stdbool.h>
> > #include <stdlib.h>
> > #include <stdint.h>
> >
> > int main(int argc, char *argv[])
> > {
> >          unsigned long span;
> >          int i;
> >
> >          if (argc != 2) {
> >                  printf("Usge: %s <span>\n", argv[0]);
> >                  return -1;
> >          }
> >          span = atoi(argv[1]);
> >
> >          for (i = 0; i < 1000; i++) {
> >                  uint64_t rnd = rand();
> >
> >                  printf("%lu\n", (uint64_t)((rnd * span) >> 32));
> >          }
> >          return 0;
> > }
> > $ gcc ./foo.c
> > $ ./a.out 10 | sort -n | uniq --count
> >      195 0
> >      194 1
> >      188 2
> >      223 3
> >      200 4
> > '''
> >
> > So I expected the program to generate number 0-9 randomly with similar
> > proportions.  But it is generating only numbers 0-4.  I confirmed doubling
> > 'span' value makes it work in my expected way.  Should we do that here, too?
> 
> 
> 
> I wrote a kmod to verify.  The helper is a verbatim copy of
> damon_rand() from the patch:
> 
>    static inline unsigned long damon_rand_test(struct rnd_state *state,
>                                                unsigned long l, unsigned 
> long r)
>    {
>            unsigned long span = r - l;
>            u64 rnd;
> 
>            if (span <= U32_MAX) {
>                    rnd = prandom_u32_state(state);
>                    return l + (unsigned long)((rnd * span) >> 32);
>            }
>            rnd = ((u64)prandom_u32_state(state) << 32) |
>                  prandom_u32_state(state);
>            return l + mul_u64_u64_shr(rnd, span, 64);
>    }
> 
>    static int __init damon_rand_test_init(void)
>    {
>            struct rnd_state state;
>            unsigned long counts[SPAN] = {0};
>            unsigned long i, v;
>            int j;
> 
>            prandom_seed_state(&state, get_random_u64());
> 
>            for (i = 0; i < ITERATIONS; i++) {
>                    v = damon_rand_test(&state, 0, SPAN);
>                    if (v >= SPAN) {
>                            pr_err("out of range: %lu\n", v);
>                            return -EINVAL;
>                    }
>                    counts[v]++;
>            }
> 
>            pr_info("damon_rand_test: span=%lu iterations=%lu\n",
>                    SPAN, ITERATIONS);
>            for (j = 0; j < SPAN; j++)
>                    pr_info("damon_rand_test:   %d -> %lu\n", j, counts[j]);
> 
>            return 0;
>    }
> 
> dmesg output (span=10, 1000 iterations):
> 
>    damon_rand_test: span=10 iterations=1000
>    damon_rand_test:   0 -> 99
>    damon_rand_test:   1 -> 107
>    damon_rand_test:   2 -> 79
>    damon_rand_test:   3 -> 94
>    damon_rand_test:   4 -> 97
>    damon_rand_test:   5 -> 97
>    damon_rand_test:   6 -> 94
>    damon_rand_test:   7 -> 100
>    damon_rand_test:   8 -> 114
>    damon_rand_test:   9 -> 119
> 
> All 10 buckets get hits, roughly uniform.
> 
> Looking into the usrspace test program, the issue is that libc rand()
> returns a value in [0, RAND_MAX].  On glibc RAND_MAX is
> 2^31 - 1 (not 2^32 - 1), so the upper bit is missing and
> the multiply-shift only fills the lower half of the output
> range.  prandom_u32_state() returns a full u32 in [0, 2^32),
> so the in-kernel formula behaves correctly without doubling.

Thank you for kindly checking all these details and sharing with me.  All make
sense to me.

Reviewed-by: SeongJae Park <sj@kernel.org>

I added this patch to my damon/next tree with small modifications including
removal of random.h include, simple range mapping description update, and
adding my Reviewed-by: tag.

I will repost my version for mm.git inclusion soon (maybe within 1-2 days)
unless Andrew picks this into mm.git or you send a new version before.  My
reposting plan is only for a case involved people dropping a ball, so please
feel free to make action before my reposting if you want and don't mind.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://git.kernel.org/pub/scm/linux/kernel/git/sj/damon-hack.git/tree/patches/next/mm-damon-replace-damon_rand-with-a-per-ctx-lockless-.patch


Thanks,
SJ

