Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F02CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103DB6B0099; Wed, 27 May 2026 09:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5316B009F; Wed, 27 May 2026 09:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C346B00A1; Wed, 27 May 2026 09:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E10366B0099
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:44:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92D68161A9C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:44:09 +0000 (UTC)
X-FDA: 84813318618.10.5DACCC4
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf27.hostedemail.com (Postfix) with ESMTP id 995B34000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:44:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o6qE1ATa;
	spf=pass (imf27.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779889446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qzhck0gw9pgwJJr+ZjjO323vwaaYqicFxNlPj8CzbAU=;
	b=DSFV5IkKKHCZ6Eu20UVBz67JKBc14J8hu5klh1uJUCG7z8e4SECZvC9201O7/THgD6KHP+
	dOrpI8KAE7Si9nq+GMSLoLckPG73V5VWSpR92+M0MVym+Z4Ho0FxyL+xS7IzEDIHEhfsNl
	llbRpNzOzrUWhhMiSDgoRz0fV7MfxLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o6qE1ATa;
	spf=pass (imf27.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779889446; a=rsa-sha256;
	cv=none;
	b=L13cvwfz0XBvyCyv0dfKjYFXPeqEMFGg7ZNmdy/b5uhe+TrY9vkcZ5pTScKpatuKVyPHg5
	VcdfOQ79cSJLk2GAlajp8vPER183LFMwMUNraHLnOPYTH2qHYI/zA2zi45d1Eh8z5dVu5u
	Ku+cXKk9HqHxnZXXHaIq/8J8pPuap5g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779889441; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Qzhck0gw9pgwJJr+ZjjO323vwaaYqicFxNlPj8CzbAU=;
	b=o6qE1ATaR6SDwJkRat+/eB7mcxLELAMlRyRBSnJ4FcVb26871RJzRwfvZSDSNuiC7Pkv8RHUuUWXqpWY+w5dZ6QgnCeauyGkGTfEkDnsNMeoqnk0kegWN+uWqpwO+ziYTV6hHEQF3ZfNGFS9bEzh/du3qK93FRLL2bC3RyNKA2Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3jnw6a_1779889436;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jnw6a_1779889436 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 21:43:58 +0800
Message-ID: <f75d7ff8-d965-4f17-8548-2525512a400a@linux.alibaba.com>
Date: Wed, 27 May 2026 21:43:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 6/8] lib/test: memcpy_kunit: add copy_page() and
 copy_mc_page() tests
To: Ruidong Tian <tianruidong@linux.alibaba.com>, catalin.marinas@arm.com,
 will@kernel.org, rafael@kernel.org, tony.luck@intel.com,
 guohanjun@huawei.com, mchehab@kernel.org, tongtiangen@huawei.com,
 james.morse@arm.com, robin.murphy@arm.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
 <20260518084956.2538442-7-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-7-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xkt3dqr54ttujgdpo38f3zn6bn6rn95d
X-Rspamd-Queue-Id: 995B34000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779889445-765825
X-HE-Meta: U2FsdGVkX18O4Ts3NhwuewDF5808JWuCkDOAvLCCwc1Es+KyeviLPNYaIuV/KgSmZ5vC+p7L9eJjxNyU118NHy2sdiXaF4mWCPpAz2MfHexRJ5EIe/376mf1BziyposRCFl0qfrukRnWpM6iXPKn2pDnYKLPNT7hRBQ1FIh2YVMP37t891a5o7O1jrCZKPG6D4tTXBXG1Xr+j8Rz/yFuXKLzkktzm+7Ol9z5AcxvmOi8OoDQ7xDkwRYVanhGEJnr7HYADj0KEdwTkTrRRHhGqklmukWzMUZAVmT1w4jDoRm6gvqiAYQOlnskS+TUhAci3gAcR2YnMEISe6D5pCqapP6upZrgj0fi94fpOAIhsQxufXEIYSIX4FOphfKDR8QojZG2CsrqZOSy690JKz6J1pLRo0kGoxSkqlh6Fpzuw73ao9K6Ld7KxMw1CL6ek4Sw1Z9NRAkK3dWggzf9nTjl6uZ6zrDGS8xqdjValbXSOz5r89Y01hZn5HYXt8yQuugDiDs3gVQWBzX7quH9LmGe/RBxt607VdhuWEVi9nX4FzgPzU8uwX4nscvWpTtoBgmFosSuep+TtEgA1HbT1bFkofLB8JBRtMJU5nE/pkid97i1qHbkZ9nb/QnJv2dOk4zvltL0MAkyJRl6PwwT4/9bXwLOEcrfKKU/P/rmTxwbEU8tRmI9UXLaJmifasiiXCqT/LTPIMblfSI5sDnic14XsCVoFB9nf4JO5dsovsGuf/M+UqIpRtqMh4PjQcoDKRT1E48ETpOYPBhVwVl5CGIhnMhj7qDj7/ioUYE8kkYjYSwYBw8jf/pfPADEWjmyqi7rbzGpf5hSM60fQj5UhrwDiXfNsZuiUlXaiFymBBWINS7Z8jcuXJHFdiZbn20YtvgyVZMpxiNTfvQWt00L2jftMMn1OYzwQsavlZoitX3e6YJiHqWNISpaA5ylaUpuZn99Dody0Bgnftke2Z2jYdS
 j/5MJR5h
 6j/DN94C0h7ZpgRAL14gov14VXx4ABS+rJpz7atYOFxflZHcYC6eNGT1J8NasYkS8ngqYw0kEFtlnEefCdubLQE6goy6FzsX6+53vnGRGq4r5woi8QQDaRLY8f6mdmFURicOdD0i/lLUYOPBQD9moVpXIu8iwPKG9ZHgZofMoYqPwidfOWrF6SPViojrlVKbz3/m2OsJLJm+VZs9Z8lkN32PWV0lY6EZYUFdVOtSPjBom2OhvMHZqv4CGYl01MXwV2UeI4zzqDvDHKoYx3NpVwJMZFZeauHysXALysM5arPDRho47SG1Q1Ea+wKNhFRJ5s9ZCW8oj9D0N4S7tuZIelllw+wvATnyZ/JzHpwAACr+OrgRycVp4Q8oSH7NqqsI9Rn3lk0zUclvsLKKY1DvKFFOpJhEy4TEEhHCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> Add KUnit tests for copy_page() and copy_mc_page(), modeled after
> the existing memcpy_test() style: a static page-aligned src and a
> two-page dst, filled with random bytes plus non-zero edges, then
> verify byte-for-byte equality and that the adjacent page is
> untouched. The copy_mc_page() case additionally checks the return
> value is 0 on clean memory and is gated on CONFIG_ARCH_HAS_COPY_MC.
> 
> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
> ---
>   lib/tests/memcpy_kunit.c | 67 +++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
> index d36933554e46..85df53ccfb0c 100644
> --- a/lib/tests/memcpy_kunit.c
> +++ b/lib/tests/memcpy_kunit.c
> @@ -493,6 +493,67 @@ static void memmove_overlap_test(struct kunit *test)
>   	}
>   }
>   
> +/* --- Page-sized copy tests --- */
> +
> +static u8 page_src[PAGE_SIZE] __aligned(PAGE_SIZE);
> +static u8 page_dst[PAGE_SIZE * 2] __aligned(PAGE_SIZE);
> +static const u8 page_zero[PAGE_SIZE] __aligned(PAGE_SIZE);
> +
> +static void init_page(struct kunit *test)
> +{
> +	/* Get many bit patterns. */
> +	get_random_bytes(page_src, PAGE_SIZE);
> +
> +	/* Make sure we have non-zero edges. */
> +	set_random_nonzero(test, &page_src[0]);
> +	set_random_nonzero(test, &page_src[PAGE_SIZE - 1]);
> +
> +	/* Explicitly zero the entire destination. */
> +	memset(page_dst, 0, ARRAY_SIZE(page_dst));

    init_page() memsets the entire two-page page_dst to zero, and the
    test then asserts the second page is still zero. A buggy copy_page()
    that overwrites the second page with bytes that happen to include a
    zero byte would still pass.

    Please fill page_dst with a non-zero sentinel (e.g. 0xA5) instead
    of zero, and check the second half against that sentinel using
    memchr_inv():

        memset(page_dst, 0xA5, ARRAY_SIZE(page_dst));
        ...
        KUNIT_ASSERT_TRUE_MSG(test,
            !memchr_inv(page_dst + PAGE_SIZE, 0xA5, PAGE_SIZE),
            "copy_page overflow into adjacent page");

    This also lets you delete page_zero[] entirely, which on
    PAGE_SIZE=64K configs (arm64) saves a non-trivial amount of BSS.


> +}
> +
> +static void copy_page_test(struct kunit *test)
> +{
> +	init_page(test);
> +
> +	/* Copy. */
> +	copy_page(page_dst, page_src);
> +
> +	/* Verify byte-for-byte exact. */
> +	KUNIT_ASSERT_EQ_MSG(test,
> +		memcmp(page_dst, page_src, PAGE_SIZE), 0,
> +		"copy_page content mismatch with random data");
> +
> +	/* Verify no overflow into second page. */
> +	KUNIT_ASSERT_EQ_MSG(test,
> +		memcmp(page_dst + PAGE_SIZE, page_zero, PAGE_SIZE), 0,
> +		"copy_page overflow into adjacent page");
> +}
> +
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +static void copy_mc_page_test(struct kunit *test)
> +{
> +	int ret;
> +
> +	init_page(test);
> +
> +	/* Copy and check return value. */
> +	ret = copy_mc_page(page_dst, page_src);

 From sashiko:

Does this introduce a build regression on architectures like x86_64 or
powerpc?
The CONFIG_ARCH_HAS_COPY_MC flag is selected by multiple architectures,
but copy_mc_page() is an arm64-specific API. Other architectures use the
generic copy_mc_to_kernel() API instead.
If the kernel is built with KUnit enabled on non-arm64 architectures, it
appears copy_mc_page() would be an undeclared identifier.


Thanks.
Shuai

