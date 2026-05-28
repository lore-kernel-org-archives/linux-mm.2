Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC9ACD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 03:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB3D6B0005; Wed, 27 May 2026 23:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1559D6B0088; Wed, 27 May 2026 23:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DA66B008A; Wed, 27 May 2026 23:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E14116B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:17:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 930F61A0751
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:17:28 +0000 (UTC)
X-FDA: 84815368176.30.D5AE07D
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6704100005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:17:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dxYcDD9V;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779938247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aw74MRuVap+euim+m8O+eFhYn9p3tagNAama2H6na1E=;
	b=51Vma6tz/TfsEqOFt9PyUPNS8IdfieovRS3Y82BWhP5JM+emacaGEBGYX68xjghzg4xDZA
	KGyeLrmx0axjDJGDKKy1Wbfi6DUMae9ZLEAp1k/cEJ9bJ+8110/otyrqNj8vcOLKx0yDJo
	sIXZWHB1+7RItVbKOFd4pO77LeugNIw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dxYcDD9V;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779938247; a=rsa-sha256;
	cv=none;
	b=tqmk32w4+Na1beMM1rRNkNDAvn42l6VRNdqo9Z+o8Jpj33/4Dp4kS52itF4BuxOc/mrJrC
	ElRMU1IG1rw2Wmi1p++Xh9tiWc8DJeRQxEOHw81GlQbBpkQSKsTlS4ulEGGz1mW+kgY1IK
	zJKEPnf3rp3lzlO1Sm0MMD6t+SkqJg4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779938243; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Aw74MRuVap+euim+m8O+eFhYn9p3tagNAama2H6na1E=;
	b=dxYcDD9VGTmcjD/5cnE29dU6lCDOdI9aXzRTJwMKQLvY0a0Qo1Xx+MgpjP1tLDWSoloREo542gLVN4wDognt8jXIu/iA09NQeIvR5k54jWlYTveNg9TzLOsj4wLGJvVwwKt27DO7x9k8m/6dVO7YfI6VtREhfEJlpnu8NlU2TRY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X3lAIi6_1779938240;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3lAIi6_1779938240 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 May 2026 11:17:21 +0800
Message-ID: <2e413153-c9e7-41dc-ad8e-522871381bf7@linux.alibaba.com>
Date: Thu, 28 May 2026 11:17:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 8/8] lib/tests: memcpy_kunit: add memcpy_mc() and
 memcpy_mc_large() test
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
 <20260518084956.2538442-9-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-9-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6704100005
X-Stat-Signature: nx6r8ctqqqtkn86sxwnt81cdc16w8bgj
X-Rspam-User: 
X-HE-Tag: 1779938245-800457
X-HE-Meta: U2FsdGVkX19NMDahE2nYDXPRuIbosYmjt1cD6Siorq6EUTUqr/eZpWsyGCXGYMqNP49BZY9or304QCevgZdbNpfODeKnT+Ka9toswLU++OoRMN+edXwqwiqpcTDLA2Kyn2hUNWeeQ+t3NYlXAANtnr6fdifanb4vPaLyReK3QvEp/KNHYzALyeuBhMbPwsFo7JzYtQwfSI0AOGsOQCsS68J+W4zq4exFayJXgkQV714yHs+YAkGCXRW9B65umXH3oHv6UTU+pXDqMlqbufgIoZlYZRmF05R45O9H7AmoFxWWaWGnrtPOfXP/s+WQz9dZwdQOYpnUoupol8MZNROdEL4p9PSJXk9dK27YmIfhZCir6N955v4PEnGcDOWrAr/fEtqE7yo+/1b16Ksb9v4Ne/KGYGor3ttQCAGIz0ryeQMX+Q8RqiK6mxjERBxsemQ465CFXDPHNbSznpasaDBd609mChfrn/8BbOXYSAaVuiYU5KVvVrVlB+lNYuLSuIHWxlkE4qQfbV3CydJXJ+3qPBedPaG8SgBD8syUqZ2ZWZiMcqXJEnJ0sb5JmHtIntXXHu0eeJogm1XR65dtX9xI35LjI23O1w3YKhH6Keh8c68OlCUDlJeFV9SLaVQgfc6rcmWkIF8sLJH3a2nvZ2QB6e0WevaQyLAxvpn4v4gzHGlk/L1X3RVhHEY1gu2x76MyJhilPOFmTS69AlkDsGRg5QVWID5IdDWBGymBE55DoJ8C6vAj0xM4r4wqbq1QPA+OFNKL907lXdzbUVo7GNuwt6ZmagS37sgraZAS7s0SQgktwzToIm0u1lJXgb3glyXWZ4BjlUhPMSdTlk1+53gsRATsNdZeOwIETdce/kRi2xpJseokp3CdU0A+QSMuApxoD165JcA1h/H8kDvkmsQrWux+Xl6v6D0mvOCecsKmDvqp2rvUrPvm9uxBUW0PhqnMF4rpdfBT/cljJOKAAIL
 /Fzlqj2P
 sGSRlvPQ0hwRmi5StPyIDeoCXaUthLOzpY9otDnFqTWB0V9ltEo/aXxEQf96JQHCcNa/dKhsBKA/AwApTttmL2gL3wmR9QKXpxu+5zfdqPG6UkwmA6k+EP37RtMyP3tdhUHnedtJ+AJmmNsldMmchk7qn7CxHj4F6HRphcZzTg6KAQYy3/ErR6uUs6jJOWd1HhOeZy0w15bSE/8QNR8wNMsJ7jicBCK4N1OIS7T72TSVTJOpFtrEAPKDM28+5eKsgdIc+QpU/0lvD6eFlfhk6R3CPaoIW1IT6CeFFbk2v7wiRYKrNXkNbHaQpPP6GrwmtflnHczE5+rXk0SEOp3rEDHwNSajmKnp69QfPme1bAOb5EsRmkCj+7Uxou2TXGMoqmD0Xgr9Uy7Y/abDQc2fVxD23oq3N3qTpx9ae
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> memcpy_mc() is the Machine-Check safe memcpy variant that returns the
> number of bytes NOT copied on a hardware memory error, or 0 on success.
> 
> Add two test cases modeled after the existing memcpy_test() and
> memcpy_large_test() implementations:

Same build issue as with copy_mc_page_test: memcpy_mc() is an arm64-
only symbol.

1. Cross-architecture build break (BLOCKER, same as patch 6)

    These tests are gated on CONFIG_ARCH_HAS_COPY_MC, which is also
    selected by x86_64 and ppc64. Neither architecture provides a
    memcpy_mc() symbol -- they use copy_mc_to_kernel() directly.

    On x86_64:

        lib/tests/memcpy_kunit.c: error: implicit declaration of
        function 'memcpy_mc' [-Werror=implicit-function-declaration]

    Fix: guard with __HAVE_ARCH_MEMCPY_MC instead:

        #ifdef __HAVE_ARCH_MEMCPY_MC
        static void memcpy_mc_test(...) { ... }
        static void memcpy_mc_large_test(...) { ... }
        #endif


> 
> Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
> ---
>   lib/tests/memcpy_kunit.c | 113 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
> index 85df53ccfb0c..b4b2dafb50f1 100644
> --- a/lib/tests/memcpy_kunit.c
> +++ b/lib/tests/memcpy_kunit.c
> @@ -552,6 +552,115 @@ static void copy_mc_page_test(struct kunit *test)
>   		memcmp(page_dst + PAGE_SIZE, page_zero, PAGE_SIZE), 0,
>   		"copy_mc_page overflow into adjacent page");
>   }
> +/*
> + * memcpy_mc() is a Machine-Check safe memcpy variant.
> + * Signature: int memcpy_mc(void *dst, const void *src, size_t len)
> + * Returns:   0 on success, or number of bytes NOT copied on MC error.
> + *
> + * In the normal (no-poison) path it must behave identically to memcpy()
> + * and always return 0.
> + */
> +static void memcpy_mc_test(struct kunit *test)
> +{
> +#define TEST_OP "memcpy_mc"
> +	struct some_bytes control = {
> +		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +		},
> +	};
> +	struct some_bytes zero = { };
> +	struct some_bytes middle = {
> +		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00,
> +			  0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +		},
> +	};
> +	struct some_bytes three = {
> +		.data = { 0x00, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
> +			},
> +	};
> +	struct some_bytes dest = { };
> +	int ret, count;
> +	u8 *ptr;
> +
> +	/* Verify static initializers. */
> +	check(control, 0x20);
> +	check(zero, 0);
> +	compare("static initializers", dest, zero);
> +
> +	/* Verify assignment. */
> +	dest = control;
> +	compare("direct assignment", dest, control);
> +
> +	/* Verify complete overwrite. */
> +	ret = memcpy_mc(dest.data, control.data, sizeof(dest.data));
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	compare("complete overwrite", dest, control);
> +
> +	/* Verify middle overwrite: 7 bytes at offset 12. */
> +	dest = control;
> +	ret = memcpy_mc(dest.data + 12, zero.data, 7);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	compare("middle overwrite", dest, middle);
> +
> +	/* Verify zero-length copy is a no-op. */
> +	dest = control;
> +	ret = memcpy_mc(dest.data, zero.data, 0);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	compare("zero length", dest, control);
> +
> +	/* Verify argument side-effects aren't repeated. */
> +	dest = control;
> +	ptr = dest.data;
> +	count = 1;
> +	memcpy(ptr++, zero.data, count++);
> +	ptr += 8;
> +	memcpy(ptr++, zero.data, count++);


    This is a verbatim paste from memcpy_test(). The intent is to
    verify that the memcpy_mc macro doesn't double-evaluate arguments,
    but the test doesn't actually call memcpy_mc(). Please change the
    two memcpy() calls to memcpy_mc() and assert their return values.

Thanks
Shuai

