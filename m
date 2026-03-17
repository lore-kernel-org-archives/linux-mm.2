Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E61FD875A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AACF6B0005; Tue, 17 Mar 2026 08:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B9F6B0088; Tue, 17 Mar 2026 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3A26B0089; Tue, 17 Mar 2026 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB1376B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:21:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5303856389
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:21:06 +0000 (UTC)
X-FDA: 84555464532.18.C722808
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B24C78000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:21:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZPtMbOXG;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773750064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8OOX6RhC4U/akJg/vB9O9PHT2uayrjzmiBmIYoZOAE=;
	b=pHFV32ZUKVlTcCWzXICth3/kOa9W0eo5avw/ekoykJ4RsPLcB5qAwTPy3Q8e5M0dA9JgoI
	Omp05NPbl8Y+Uni4wsHiLxXlpN9icCHRmkGWYUcl1YrpT4rkX5AVyTIr83DzZfLaYzrOVo
	AqbVSB8WI8JV+t8t4KepG8ddDavBexA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773750064; a=rsa-sha256;
	cv=none;
	b=MRoUz9zA30FBY1R0gTQLDLDBTtERdVKIcv0WqvYfHQ1MkpQ+wOco1cRjSrfW930Y6ZKx6d
	gNI5FlxCuF6a1aoMP7eSUXkQk/Sjd51m3UxcP6rw/j/3UDtxuCktvdmSA+DEquIFRCxsvE
	pgqFNzmaM6+sOdng1U4+IZAyuxLaVEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZPtMbOXG;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8FF244006;
	Tue, 17 Mar 2026 12:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2D9C19425;
	Tue, 17 Mar 2026 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773750063;
	bh=154xV5yNFk1bqEw8USIf/c8Aeng2VxH0YrueSTDmyGU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZPtMbOXGmfvaEcFvRkzB8juhKjd+GhIoz+r42OP8PQfopHCoX3sKr/PuJikRFs1FZ
	 2TB+U47QkhCXiwIhSLPACQ4kNpq1BRPD1fG8w1/R1hDmviQV/RI3HSCvttPxx88lc7
	 eSbM8xPZBzX8soHHaAkRieE/4BP4utmF6LU3wpC+pe6xmvg3Xus+S2KOTlv8NEGK9M
	 aoCKy3wfhSgOBbz1d97SgGAM8RM8I6FbwYONsLaK3tN16knXwIqSbcrR229C9FqbV6
	 Fk4pH7xhgiR4ww4LGGcdp6A+VDH7nJxUDj5Mimemqne5jpidxNGSw/McK3ATRmem2z
	 xc0gWgauSWBiw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Shuah Khan <shuah@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 2/6] selftests/liveupdate: add helper functions for
 memfd tests
In-Reply-To: <abk0ke1wAiHMYnGs@kernel.org> (Mike Rapoport's message of "Tue,
	17 Mar 2026 13:01:37 +0200")
References: <20260309115441.266805-1-pratyush@kernel.org>
	<20260309115441.266805-3-pratyush@kernel.org>
	<abk0ke1wAiHMYnGs@kernel.org>
Date: Tue, 17 Mar 2026 12:21:00 +0000
Message-ID: <2vxzfr5yd4ur.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: iydrmfy9jktpxtjkh3gc8yojwktab76w
X-Rspam-User: 
X-Rspamd-Queue-Id: B24C78000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773750064-184934
X-HE-Meta: U2FsdGVkX1+5W+dKwYjW500U3bv5zKcLJ7gL7WXrMw+IkcgDPSTokptiJSTixL7Cz9HI45MdZhK5gmo9NOTT4F/mR3ADkxUr7uSjn+Uf2tRqNf+VDyKKMFSkxBDCzd3WgWm3wVl5Oe5SzlERTnn7iSCWimgMSGTg7IMzwBGlFhoi5if/DvLkrT3uL673qgd7WL1vY/8MF3UxoZLeWZL3LdA9LXmOGgBAdENbNgzDN/ulUMQw4NsSApIqrh64eYYG4awp4IJW+iXXFvGFAtNe4BXaLpwmUR5nMNnB53vvwRjBPcN+xl1itP2I08T54G9TkQvxSbLEJGKGjPWxVoZejOUf3f18tiGCIx2MdmAxrlxJcKy7jLdB8YhPOHT+yIcstMYxTvSkqOJ81B7qRdnDqufKo7W9NQ1R0mF9TI0fOKEJxuUEdVk8Sm31jz2Whxv/+fP/CGuHEUfXnpITpQkL9dipIYsE74J0sYxkIv70Z4KtE1yBAcNg9dLh+WfQDVlmOwYHX1OklQ+O/9ir4TJ21Uklx7b14yN4bgEqj76O6JVSviSTFuZbRMemY9sXcc4319Esd9TvSIgcNWDJm3pcwrvOKb4gt32eleXFQ6Nx9CmQ4KezLLH+RxV+PNjgx55xfo0KOHpQODutitkY+YdO9Ry0/9DOZE31ptMA+HaaoR8ULlvfEBCECs/XAF/einV/eLYrSOhpaONDsbjb62PjEyLp/7Fu1ltc4M/FZ/mH4E459fQyZmDKIuRvSEe8uVeq01xtdwV1IOXfEt2guFsszF5QOTO9GyVWHe1Huwguj5+dA3sJyfmK6xYukAVafzIbsdFNuGrYDGDkqoTMvlDVw7ooUQ/uWd3Sj9zbKiiQvlIE1sIEO/4GpRHPwak8rlmhkyp73ZWpT/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17 2026, Mike Rapoport wrote:

> On Mon, Mar 09, 2026 at 11:54:35AM +0000, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Add some helper functions that will be used by memfd tests. This moves
>> some of the complexity out of the test itself, which results in better
>> test readability and less code duplication.
>> 
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  .../selftests/liveupdate/luo_test_utils.c     | 175 +++++++++++++++++-
>>  .../selftests/liveupdate/luo_test_utils.h     |   9 +
>>  2 files changed, 183 insertions(+), 1 deletion(-)
>
> Some review comments from an LLM that make sense to me as well :)
>  
>> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
>> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
>> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
>
> [ ... ]
>
>> +/* Read exactly specified size from fd. Any less results in error. */
>> +int read_size(int fd, char *buffer, size_t size)
>> +{
>> +	size_t remain = size;
>> +	ssize_t bytes_read;
>> +
>> +	while (remain) {
>> +		bytes_read = read(fd, buffer, remain);
>> +		if (bytes_read == 0)
>> +			return -ENODATA;
>> +		if (bytes_read < 0)
>> +			return -errno;
>> +
>> +		remain -= bytes_read;
>> +	}
>
> Should the buffer pointer be advanced after each read()?  As written,
> if read() returns a partial result, the next iteration reads into the
> same position, overwriting the data just read.  Something like
> buffer += bytes_read after remain -= bytes_read seems to be missing.
>
> This is exercised by generate_random_data() which reads from
> /dev/urandom, where partial reads are possible for large requests.
>
>> +/* Write exactly specified size from fd. Any less results in error. */
>> +int write_size(int fd, const char *buffer, size_t size)
>> +{
>> +	size_t remain = size;
>> +	ssize_t written;
>> +
>> +	while (remain) {
>> +		written = write(fd, buffer, remain);
>> +		if (written == 0)
>> +			return -EIO;
>> +		if (written < 0)
>> +			return -errno;
>> +
>> +		remain -= written;
>> +	}
>
> Same issue here: buffer is not advanced after each write(), so on a
> partial write the same initial bytes would be re-sent instead of
> continuing from where the previous write left off.

Yeah, good catch on both. Will fix.

-- 
Regards,
Pratyush Yadav

