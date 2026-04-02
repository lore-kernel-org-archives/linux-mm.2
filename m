Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA8ECC6B0E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB296B008C; Thu,  2 Apr 2026 03:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293356B0092; Thu,  2 Apr 2026 03:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9656B0095; Thu,  2 Apr 2026 03:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8EA6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:28:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2B081B7DC3
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:26 +0000 (UTC)
X-FDA: 84612787812.25.0459D0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DF66180002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jSSyx/XU";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG2xexFXUft0fUCH4A+e836SqiSoHZgOaYwGzfd++fI=;
	b=Cwst2VlI0EM727MoEfcd3/2BBtlVx5/ZhlCaF/q4ZNOrO8IBpf23x1fTXgN+nfPkv6aNfS
	KPQZ3HP4z3SiVnSYfLRwMkNGDWVDwMrYT9C2aijQTUytjHlUs8hTuxy9ZR+qihVsRod8Ni
	i7K1G1jym2JNgAzRsvoL0FtyGYGLbTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jSSyx/XU";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114905; a=rsa-sha256;
	cv=none;
	b=mo7hEnQVRJLa4z4ipLmKWGHZwgy6yb9FECyWcl7BKCYFs70B96IPEpwSAGV3eFuEmlDZ5x
	f9UWQvBjxfgErjdnuWX8Hu7Ipu2FLEAfdF4tsq+6YK/wC5Yi/Un7VIUn6t+Gl6mfz+bY02
	xdvxNON/AimbgOD5Up3zganOpU9Ax3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D9F61858;
	Thu,  2 Apr 2026 07:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D20C2BC9E;
	Thu,  2 Apr 2026 07:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775114904;
	bh=s4DktcxYHxIQyKItWyyiTcktdapW1VOpPYdWxcQrfYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jSSyx/XUgzH8me+WQNiUcNtdsh5wE7pEg1D5p26XknqUIoOrz4umY52V9T8+OJeCp
	 wBxHXhPy8IJfp0NTA4PR30iX8xEPBq50qJc3ZsxwvcBFcm3eK98t1w4myGez8zT4FJ
	 mRfZm5qMFTBCuvU0gX72h4+ZnK1KHmFTfs4uRIibTh+5Qrzop4y7CdZD+CPCSwRW5o
	 eUPrV1nH0YqEI0BDVlqvpu8CYpq2fdZWPl3s6l7FUdg4cv5Uj6oH9UW4+PRDTu6V0x
	 5ZeESauDqpj+ms090X7/idd+ykAN1fFvaQoVkAmwkhmCdW510uXxG/sU+iwe5tw1SJ
	 19b3qLLVde9JQ==
Message-ID: <4f6d4ee8-9f2b-4da8-9456-f47cccfe4367@kernel.org>
Date: Thu, 2 Apr 2026 09:28:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-3-anthony.yznaga@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260402003417.438037-3-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DF66180002
X-Stat-Signature: kdrz43cwzzfrfgmh9oezko1kcm13brmy
X-Rspam-User: 
X-HE-Tag: 1775114904-559388
X-HE-Meta: U2FsdGVkX18+RK5PwKo8JGrv6SD2MYWC6psTiBmP9H/jYC+PQxLkHJ2Qspiiee/A9Xf8O28VNjlL4wIxlnVkioO1W+GH6Z3NwEH4WhuASALWv0d3m+fBy/UZ1kwO9XoQLWEOjO8fm+FqwWXLQZk0La/LVW75/q/Ki0l/O+BHsEr5zbQ5Dmlsoj/mcA1PdK/kYPT8XQL3B23fKfKtRShAidrPqDLXL7gi2Fc/pSJahqU+CftnV3KwGx2lmqpQSiOXX6z1MOLUS9SaBV3S55k8rr1hQi+MxXzRrZneYil5kUVU8g1+VSXmGx2eVQQDpUGhdfe9B6AlaXfBcPfDuD8qHaWT9HjtsZRfmIPEylfXkKDLfZe1aOFNyMa2zRwz+IZm5cPOR6LXVIfHAoRtSXTkYLzzU8gha4R3WQQi5FcQhR1K2ip8L7xK8q852+zakcLs5UVvmzGmuujyoAvCVQc8f/L1L3860Lgg0j2ee8c54B2xunLuoqAErVdGtf1HQADvBBbGise/ZxYPKjfl/VDqkyGuPURPqE1zlNt/tf+Hy9gEptIQHFjg1hYCs33oLvVOz4PBRjod4rbBQSFGKn43VrOJt+uP24rk/2+Q2Ofaa5dN/w60ClKdAMOdzTJgkve9ZgQBldKW7QX+Ntei6Wwq7NKqFLNSIMOZOEUp/PxIJcmFwgmjPd0NRNwMZnC1FjDQsHFnSZLIWK7kzxh9LgFWWp62Ws6CJauwLvy1WPmQRHyALYsQ5oaaIMXAQz/246XdcAaPZbDcOxO/tGlDHe4VwLRNsRp+aJyZEqWUi4Tp/o3akuJirHBHUY+b7Y3m1mhxsZ07Ez/GCbEdk1VsBjQQjlZpDkpcu4cCQecHmQM50hL7edN/W3PA4PE4hNMHl6HQ4/pcaoa1HNflUrSAdJI8m2u1oVu6GoW9u1wnSvqxMn+ATfY4T04/zLctFs2nvL9Cu3X0HMr4oJKZh3de/NW
 eq0FsrAQ
 tkQw+5qEtkm9VTnauD1/JBx2I+uFjEjW9rxitNk2i6gqi7/jjdc20OnjvntIaP9AvcHA9Fhv3MBxTL2AjiSeGunIIU8tn8vyF0uaz7v83fQJG3W8QmLrg8gtorNt3aPPDTqLMfBr2K/DSH+SuHZB8wbh1xrJgsbp/FlR5okMFXta3nZ6nrW9ZfGno6VfaWTJKyKvE0KiaaOZug7RcjPrrHf9l2yvWqDLxbJNQTp3bQxuUIZL+B3TUxLaVzpXml/M2yvK3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +
> +/*
> + * Droppable memory should not be lockable.
> + */
> +static void test_mlock_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();
> +
> +	/*
> +	 * Ensure MCL_FUTURE is not set.
> +	 */
> +	if (mlockall(MCL_CURRENT))
> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));

Why do we need the prior mlockall()? If that is really required, the
comment should be clearer why the munlockall() is insufficient.

Also, why can't we fail only the test?

> +	if (munlockall())
> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));

Why can't we fail only the test?

> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +	if (map == MAP_FAILED) {
> +		if (errno == EOPNOTSUPP) {
> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +			return;
> +		}
> +		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));

same.

> +	}
> +
> +	if (mlock2_(map, 2 * page_size, 0)) {
> +		munmap(map, 2 * page_size);

Not required when exiting either way?

> +		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
> +	}
> +
> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
> +			__func__);
> +
> +	munmap(map, 2 * page_size);
> +}
> +
> +static void test_mlockall_future_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();
> +
> +	if (mlockall(MCL_CURRENT | MCL_FUTURE))
> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));

Similar comments as for the other path regarding ksft_exit_fail_msg() etc.

> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +
> +	if (map == MAP_FAILED) {
> +		if (errno == EOPNOTSUPP) {
> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +			return;
> +		}
> +		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
> +	}
> +
> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
> +			__func__);
> +
> +	if (munlockall()) {
> +		munmap(map, 2 * page_size);
> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
> +	}
> +
>  	munmap(map, 2 * page_size);
>  }

-- 
Cheers,

David

