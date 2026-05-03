Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92807CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40BE6B0005; Sun,  3 May 2026 12:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA276B008A; Sun,  3 May 2026 12:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92076B008C; Sun,  3 May 2026 12:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94D2D6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:45:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A0D31C0476
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:45:25 +0000 (UTC)
X-FDA: 84726684210.04.60085AE
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F9AF180009
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:45:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PmI7bhqu;
	spf=pass (imf24.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777826723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D36tRh9iemqArT+eFH9+J44Q/mAst45Ik8m+uTUNgpY=;
	b=mS5idYE01ANu1QAMtU9zL7zE3VglHggA4K+R7I0e1X33D5Oo7An5vqYlmIg/9Hm1tOhTN7
	mDY8mOHPYGJr19+zWUGl/S3kIYtey2P0+C0YfVRXAhZ5+GxFZFdRzfaPOn61R0/fJgVmJ4
	6kmu1xnac7WkCmXxyQRd2P1UQUL55aA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=PmI7bhqu;
	spf=pass (imf24.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777826723; a=rsa-sha256;
	cv=none;
	b=WVJb3lTHlPGuDcNtk7wKlHBROQEHF/BwM5IWyPhPMe7nZHY72/IwSGzjDaFpv/E52fZvS/
	OG0wxnoN+C3xxwoJVKLgLMqcBeTMk8ZOTroTIw1WisNo8T6ppdmpT0fkjHkBbVVdXPIBR/
	byGUanfgsmEYIqjNzDIZeuJDPDXJU+Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777826719; bh=D36tRh9iemqArT+eFH9+J44Q/mAst45Ik8m+uTUNgpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PmI7bhquCei5a69Ol0qbYMEDCtnkXNm2zzbqV1KFZqXiOa2StjYS2dXnjaAxtZHDI
	 TfKIy09u1aaaELXuGn/iV254hLwhrkRFR+zaOQohbGA7BYkmN4Sc+6dLa/JKAYyeq4
	 0dbOHyuaEwU5NZJEB40uUkR4ox38YVrVnhDm1siQ=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id B50A3E1A; Mon, 04 May 2026 00:45:16 +0800
X-QQ-mid: xmsmtpt1777826716txynkf6ek
Message-ID: <tencent_C18B14AEB4E720C5E2F9500FB9118E1B5607@qq.com>
X-QQ-XMAILINFO: MB5+LsFw85NofsRQVejUiRbn8kCTvGwuknrYSo2ltbn/JZWF+vrNmYAu51soMa
	 am82aY6y+I3APCGVZGPKqhJkQ16c8yWT4tGeFIqq8UHtorfGVvbYsfTuB2SaVnwF+FZIJ6NIiR0h
	 5ylfZyMaPY5a2FwA6ZlbsG+PIgzMOcZ9baRGMoAPcaT6jDdFQGQ2xMw2+WL4A6mMM9n6PKOVQ4X5
	 GfGnWPKoxjQWdlMP4KWjM+PHq+EMf0YsfuniDUROuMmb8t+bxSual7XYapCqPlS3tir3MXS9vVj6
	 qlMAth5lifWOqFB9eUbrpf251OeNUaLH5dvm8Vb/aBr34pQ6UqO2P9G10efV8yM+P8IOwj7vqFJP
	 ZHou/RCa6U0MZv6N1ZHUq8RHSXoyBVz0+ftPOimyjaV9d0GW6P19VdQsPEyPNVQLzmrOjRUsckeE
	 jw1w1KR9duTB4C4zyzX7vna2Rv7URcvBKTvJ9SmFiRr3QxefzRY0qnbAGTnrelqdKxC1vTXRdEb4
	 R62KPhHKHbA9kZ7Rhf3fTH1x2OHQlBU7toFX9DV1BRNjIuFrdqfpwR44/fUYLtweieq0BaMIyy3D
	 FC4X2BBUT6sxWKubTjGKHqnv3M99EDbAF6V0RXX8VKqV66dzW0O3W7Bqq/WQGt0aFlK7OEsf0Lyc
	 98dvmlaiPTmhKa+s70aDHKk3LY3ymAvhWWReQDEl3+U7jL5qTpyYb9YCaqnUVLCJ8jyrda+Jtk7R
	 F83+dt6KpeMhxFNMLTQzLqAK7dc4F1U6DNmEJw3jstO1uvWlQZwKCszhd9SRvccLES4fqNnUW/03
	 LfKcl9B2ZiLSwfz0hLhIz+qUf8xJuEqBwEKMXioMsZmmB837oPpDqDWqjcs6qEUXUbxZzlNE7R3v
	 rc9HqJ4IFGI4bZL7nxJPFwjQeg6x2zOd+LYz7YISg6K6xUcQ4LNMLA8437+qAcesorGQ2F1AXUqT
	 3dYtIvLn+pqvU68ou9YTFT5NVGlYu9PRvisd2vrMc9e/Mfpv7LI/ZG3rsDoddLmB5rtZiNfW4I0Q
	 3ma8uYgwQTG44qqhkPDysTHYs6kqH2RP1uoWBxICJmy5sxjsly3Oc9K6/DZj4JPkqsTtnmxN42jd
	 oB+A7ZU8VbD03rKmCJMhLzy9KKbA==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <4fa0e3d9-56e1-4043-a073-74571f461e51@qq.com>
Date: Mon, 4 May 2026 00:45:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: reject invalid process_madvise() advice
 for zero-length vectors
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, sj@kernel.org
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
 <tencent_BB588C2CDED859A873093DAF28B2CC1F7B0A@qq.com>
 <afBNyNJiWEAUSf1i@lucifer>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <afBNyNJiWEAUSf1i@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F9AF180009
X-Stat-Signature: duatmjgguufq6y9rebfpkrtba13d33wd
X-HE-Tag: 1777826721-649416
X-HE-Meta: U2FsdGVkX195IbedYGz80t7gfaRZXc8jHjsebZDinu6W3zKO37k0WBQXsdcI1t5RUtH7FAMMLoi6+4jntqkJNT6fFtGeTWXdqNgyM7IyNUIm6NGqh03xHoQkKct35sqIlnGSPgx/Sb77jxOBaGuxVn1Jdc+fdXPraJAthL4ZGN9JDqtdFA9fqc4KNMSwqPElOd8+v2ZXvBKI9AZcXIrYIjRBwq3HlGsNqFq8NvHV56sDPmdCc9tEkiDKufsqtQyQnG95g7+bNTLK4j68iM6MO1hFSy3mxLu5IwfusIA+psgo5/VfUNwMBL/ZLEpVh8HVFExPq3bHHK4qdJ3+V3nXSwYODtPxXpHDeHbZtCr+yNATsrwsmaN+3ZzxMvRJK7YSRv9v3BfisX7mSeD7Nu21CtL8vqGQs3Ldu4d96fsp/uj9/uP4Qi4Wtbdm5h5PEalsHSLvgz2dUFJOvYvi8+B+cs2Zu+WCmMB9ycLDWfAs9QodDFmPQeSm6eaUyPs5OF8iKUKzbQxtgeg7opkRd1epYF2exzaotO3nEToDmrPtHn3IK02e3ofwTccT9oY3aLl8sAWIix8x50cD6kv6Czzk4w1Wnuxwogr3W1sATxiGwsUCVO+KKCW82FpEmoxl8n2At1kFp6Rpmv0jOE4wKKOMIOWjoSUGMuGEJ7AKnuZnBkrRPzc8MKRNLb1TNYgg7duMtIHj7YkUppNTmwSXwT5dtX1MwOZSPDrDDdIfu+VUIfLq1wgHaJTOG9XCcvsGfyDDUbQwHjfJK2H80TyhhVFkj5lKXL1uzF+onoT1saYdpNdE5MHvOqI4rUvuSYCtnyu3GmbYt59N5l47p3xfSxaZnQBlF+DPAfLfpD3CLOg299XKGQXh2ZSD6KJYUaXRTFm7IFBoqjZPLXFOwb75W9t/FOsSaIUBmZj5mEITmL2zeW8+faBPVsgbZnZThn68zRNl/uzVDPuoYpaEumjRPsS
 K94B+KQq
 Q29G6egipdPw97ml29RIngocKD8ofNKmRvie9HUz0CckLKhPTYYKmRI0UOAAtAD34nttBXjCHvJaknNtvLDSfunmwJxMDI09zffAbLkwQkqhwZKtvo/9z4RHtssAw4rHy3+5rdsRvCFkwRi2Abf2ZRESyu+8FfOItOL4tiDn1XHcDfBX8DdNuTnLDjIazc7CpUnamZZV0VIrvNAKEblBYVWzxQU5ipngwa2k3sSvvm2Kkqq6RLHu7eNsjNfIWXyI3QKBTJDl/XOQusb0jSeRZYkNS9kXK1lZNXf6aaHAiAmF2J9QYmn3DzRHxV8N6UI/HDhZDmvhQJezzjVPo/4w4Q4fEazPqU7tmo2s7+/NRdTzDPJs8HnnOSlWo5J0UxrJzv+Aeo/ecMRYbZDp1FjBf+y3qPHChwa2aNQfldFNWD/uGS/vMhuu/OE+eOZwYox0epvBMZE5pBGG0yHBm5sIl+urWJVkDcO7IYOs+4U8vb6pjPitl2Uf4M9RMUZ6wMTge8GS3E1n6oQVxGFAEyHBnZZqFOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/2026 3:02 PM, Lorenzo Stoakes wrote:
> On Mon, Apr 27, 2026 at 09:43:30AM +0000, fujunjie wrote:
>> process_madvise() used to validate the advice while walking each
>> imported iovec. If the vector has zero total length, vector_madvise()
>> does not enter the loop and can return success without checking whether
>> the advice value is valid.
>>
>> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
>> process_madvise_remote_valid() check is skipped. As a result, an invalid
>> advice can be reported as success when the vector has zero total length.
>> This differs from madvise(), which rejects an invalid advice before
>> returning success for a zero-length range.
> 
> Oops! :) Thanks for taking a look at this.
> 
>>
>> Validate the generic madvise behavior at the syscall-facing entry points
>> before any vector walk. In process_madvise(), do this before the
>> remote-only advice restriction so unsupported advice is rejected with the
>> same priority for local and remote mm. Then keep the per-range helper
>> focused on address/length validation, avoiding repeated behavior checks
>> for every iovec.
> 
> The whole thing is a little bit of a mess to be honest I think we could clean
> this up a bit more, see below (+ attached patch).
> 
>>
>> Valid zero-length requests remain no-ops and continue to return 0. Add a
> 
> NIT: 'no-ops' -> 'a noop'. What is a valid zero-length request? Surely it's
> never valid?
> 
>> selftest that covers invalid advice with a zero-length iovec and an empty
>> vector, while also checking that a valid zero-length request still
>> succeeds.
> 
> Thanks appreciate you adding a self-test!
> 
>>
>> Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>> v2:
>> - Validate behavior at the syscall-facing entry points and leave the range
>>   helper for address/length checks, avoiding repeated behavior checks in the
>>   iovec loop.
>> - Put the generic process_madvise() behavior check before
>>   process_madvise_remote_valid(), as suggested by David.
>> - Keep the zero-length selftest coverage from v1.
>>
>> Testing:
>> Built bzImage and tools/testing/selftests/mm/process_madv. In QEMU, the
>> process_madv selftest reports 7/7 passed.
>>
>>  mm/madvise.c                              | 29 ++++++++++++++++-------------
>>  tools/testing/selftests/mm/process_madv.c | 29 +++++++++++++++++++++++++++++
>>  2 files changed, 45 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 69708e953cf56..ce238dd96f158 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1834,13 +1834,10 @@ static void madvise_finish_tlb(struct madvise_behavior *madv_behavior)
>>  		tlb_finish_mmu(madv_behavior->tlb);
>>  }
>>
>> -static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
>> +static bool is_valid_madvise_range(unsigned long start, size_t len_in)
>>  {
>>  	size_t len;
>>
>> -	if (!madvise_behavior_valid(behavior))
>> -		return false;
>> -
> 
> So taking this out makes sense, but I think we're now in a bit of a confused
> state where is_valid_madvise_range() checks:
> 
> * Whether start is page-aligned.
> * Whether len_in was (size_t)(small neg) aligned up -> 0
> * Whether start + len overflows
> 
> Returning a boolean
> 
> And madvise_should_skip():
> 
> * Calls is_valid_madvise_range()
> * Checks if range is empty
> 
> Returning a boolean, setting output variable *err to error if the former
> failed.
> 
> We also hamfistedly check "start + PAGE_ALIGN(len_in) == start" which, unless
> I'm much mistaken, is equivalent to !len_in, except for the small negative
> aligning to zero case which we already checked.
> 
> And to make it all more fun, both functions return opposite booleans :))
> 
> So I think we should put this all into one function while we're here, get rid of
> the confusing output variable, return an error code, and have the callers
> manually check for !len_in also (compilers will optimise this into something
> sensible).
> 
> This makes it clear at the call sites we skip empty ranges, cleans stuff up and
> makes clear what we check the input range for.
> 
> I've attached a patch that you can apply on top of yours to make it clear what I
> mean here (no need for attribution!)
> 
> I checked and your test passes! :)
> 
> Cheers, Lorenzo
> 
>>  	if (!PAGE_ALIGNED(start))
>>  		return false;
>>  	len = PAGE_ALIGN(len_in);
>> @@ -1859,17 +1856,15 @@ static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
>>   * madvise_should_skip() - Return if the request is invalid or nothing.
>>   * @start:	Start address of madvise-requested address range.
>>   * @len_in:	Length of madvise-requested address range.
>> - * @behavior:	Requested madvise behavior.
>>   * @err:	Pointer to store an error code from the check.
>>   *
>> - * If the specified behaviour is invalid or nothing would occur, we skip the
>> - * operation.  This function returns true in the cases, otherwise false.  In
>> - * the former case we store an error on @err.
>> + * If the specified range is invalid or nothing would occur, we skip the
>> + * operation.  This function returns true in these cases, otherwise false.  In
>> + * the former case we store an error in @err.
> 
> OK looks good, thanks for fixing the typo :)
> 
>>   */
>> -static bool madvise_should_skip(unsigned long start, size_t len_in,
>> -		int behavior, int *err)
>> +static bool madvise_should_skip(unsigned long start, size_t len_in, int *err)
>>  {
>> -	if (!is_valid_madvise(start, len_in, behavior)) {
>> +	if (!is_valid_madvise_range(start, len_in)) {
>>  		*err = -EINVAL;
>>  		return true;
>>  	}
>> @@ -2013,7 +2008,10 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
>>  		.tlb = &tlb,
>>  	};
>>
>> -	if (madvise_should_skip(start, len_in, behavior, &error))
>> +	if (!madvise_behavior_valid(behavior))
>> +		return -EINVAL;
>> +
>> +	if (madvise_should_skip(start, len_in, &error))
>>  		return error;
>>  	error = madvise_lock(&madv_behavior);
>>  	if (error)
>> @@ -2056,7 +2054,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>>  		size_t len_in = iter_iov_len(iter);
>>  		int error;
>>
>> -		if (madvise_should_skip(start, len_in, behavior, &error))
>> +		if (madvise_should_skip(start, len_in, &error))
>>  			ret = error;
>>  		else
>>  			ret = madvise_do_behavior(start, len_in, &madv_behavior);
>> @@ -2131,6 +2129,11 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>>  		goto release_task;
>>  	}
>>
>> +	if (!madvise_behavior_valid(behavior)) {
>> +		ret = -EINVAL;
>> +		goto release_mm;
>> +	}
>> +
>>  	/*
>>  	 * We need only perform this check if we are attempting to manipulate a
>>  	 * remote process's address space.
>> diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
>> index cd4610baf5d7d..9a7e2788fcc50 100644
>> --- a/tools/testing/selftests/mm/process_madv.c
>> +++ b/tools/testing/selftests/mm/process_madv.c
>> @@ -309,6 +309,35 @@ TEST_F(process_madvise, invalid_vlen)
>>  	ASSERT_EQ(munmap(map, pagesize), 0);
>>  }
>>
>> +/*
>> + * Test that invalid advice is rejected even when the iovec has zero total
>> + * length. A zero-length advice is a no-op for valid advice, but invalid
>> + * advice should still fail with EINVAL.
>> + */
>> +TEST_F(process_madvise, invalid_advice_zero_length)
>> +{
>> +	struct iovec vec = {
>> +		.iov_base = NULL,
>> +		.iov_len = 0,
>> +	};
>> +	int pidfd = self->pidfd;
>> +	ssize_t ret;
>> +
>> +	errno = 0;
>> +	ret = sys_process_madvise(pidfd, &vec, 1, -1, 0);
>> +	ASSERT_EQ(ret, -1);
>> +	ASSERT_EQ(errno, EINVAL);
>> +
>> +	errno = 0;
>> +	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
>> +	ASSERT_EQ(ret, 0);
>> +
>> +	errno = 0;
>> +	ret = sys_process_madvise(pidfd, NULL, 0, -1, 0);
>> +	ASSERT_EQ(ret, -1);
>> +	ASSERT_EQ(errno, EINVAL);
>> +}
>> +
>>  /*
>>   * Test process_madvise() with an invalid flag value. Currently, only a flag
>>   * value of 0 is supported. This test is reserved for the future, e.g., if
>> base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
>> --
>> 2.34.1
>>
> 
> ----8<----
> From 55ea8f619b9772d8c517e2dd15d7bb7558ce5da2 Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <ljs@kernel.org>
> Date: Tue, 28 Apr 2026 07:48:30 +0100
> Subject: [PATCH] fixups
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/madvise.c | 55 +++++++++++++++++++++-------------------------------
>  1 file changed, 22 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index ce238dd96f15..865fe7fb3d81 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1834,45 +1834,31 @@ static void madvise_finish_tlb(struct madvise_behavior *madv_behavior)
>  		tlb_finish_mmu(madv_behavior->tlb);
>  }
> 
> -static bool is_valid_madvise_range(unsigned long start, size_t len_in)
> +/**
> + * check_input_range() - Check if the requested range is valid.
> + * @start:	Start address of madvise-requested address range.
> + * @len_in:	Length of madvise-requested address range.
> + *
> + * Returns: 0 if the input range is valid, otherwise an error code.
> + */
> +static int check_input_range(unsigned long start, size_t len_in)
>  {
>  	size_t len;
> 
>  	if (!PAGE_ALIGNED(start))
> -		return false;
> +		return -EINVAL;
> +
>  	len = PAGE_ALIGN(len_in);
> 
>  	/* Check to see whether len was rounded up from small -ve to zero */
>  	if (len_in && !len)
> -		return false;
> +		return -EINVAL;
> 
> +	/* Overflow? */
>  	if (start + len < start)
> -		return false;
> -
> -	return true;
> -}
> +		return -EINVAL;
> 
> -/*
> - * madvise_should_skip() - Return if the request is invalid or nothing.
> - * @start:	Start address of madvise-requested address range.
> - * @len_in:	Length of madvise-requested address range.
> - * @err:	Pointer to store an error code from the check.
> - *
> - * If the specified range is invalid or nothing would occur, we skip the
> - * operation.  This function returns true in these cases, otherwise false.  In
> - * the former case we store an error in @err.
> - */
> -static bool madvise_should_skip(unsigned long start, size_t len_in, int *err)
> -{
> -	if (!is_valid_madvise_range(start, len_in)) {
> -		*err = -EINVAL;
> -		return true;
> -	}
> -	if (start + PAGE_ALIGN(len_in) == start) {
> -		*err = 0;
> -		return true;
> -	}
> -	return false;
> +	return 0;
>  }
> 
>  static bool is_madvise_populate(struct madvise_behavior *madv_behavior)
> @@ -2010,12 +1996,13 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
> 
>  	if (!madvise_behavior_valid(behavior))
>  		return -EINVAL;
> -
> -	if (madvise_should_skip(start, len_in, &error))
> +	error = check_input_range(start, len_in);
> +	if (error || !len_in)
>  		return error;
>  	error = madvise_lock(&madv_behavior);
>  	if (error)
>  		return error;
> +
>  	madvise_init_tlb(&madv_behavior);
>  	error = madvise_do_behavior(start, len_in, &madv_behavior);
>  	madvise_finish_tlb(&madv_behavior);
> @@ -2054,10 +2041,12 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>  		size_t len_in = iter_iov_len(iter);
>  		int error;
> 
> -		if (madvise_should_skip(start, len_in, &error))
> -			ret = error;
> -		else
> +		error = check_input_range(start, len_in);
> +		if (len_in && !error)
>  			ret = madvise_do_behavior(start, len_in, &madv_behavior);
> +		else
> +			ret = error;
> +
>  		/*
>  		 * An madvise operation is attempting to restart the syscall,
>  		 * but we cannot proceed as it would not be correct to repeat
> --
> 2.54.0

Thanks, Lorenzo. That looks clearer to me too.

Since this is already in mm-unstable, I'll wait for Andrew's preference.
If a respin is needed, I'll fold this in together with SJ's comments.

Best regards,
fujunjie


