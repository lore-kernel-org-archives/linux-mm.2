Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275DFCF31B0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730616B0098; Wed, 19 Nov 2025 07:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7089A6B00B5; Wed, 19 Nov 2025 07:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645A26B00B6; Wed, 19 Nov 2025 07:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 557EF6B0098
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:28:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E98C04E15B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:28:15 +0000 (UTC)
X-FDA: 84127284150.18.9C738F8
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FE021A0002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:28:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bcCmkuHu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763555294; a=rsa-sha256;
	cv=none;
	b=NSpQHy83owvgXSZPCRRBwIuJ4FoxLlHfUImlojPVdgshdFPhAgx71KJoTa4Hf7sWptSdvN
	Xn4ZX36RC8ho5fXh2QiUlKJGjA1Ho21ZjabCQs5PixqL2B2yqna+1OPJbxx5hKn29VW4ye
	Uy1HoQ9QR7zvdbv9JITe+7vPl5riXTQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bcCmkuHu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763555294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CKhj841T0e6qZvubDhvAJxg1sC8gp96pehxxFiAmCs=;
	b=ROzhr61xtVjZpc4EeQB448ehuD3cy4tiVSeyt/V48LMKyAvy/trFaythlCNM16XsV+vRZ6
	qhm4faIo6o2qtentxSVfJyKCOVE24C3ZKQraOTJLR9ZQU7ObCfvJe7135sG4YUEAjkYMov
	IKyWTLLt/JDuwAl8LQUzKDwlx185wKI=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so5652546b3a.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763555293; x=1764160093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CKhj841T0e6qZvubDhvAJxg1sC8gp96pehxxFiAmCs=;
        b=bcCmkuHuZJXyf4VvhLlu2oPAEjaD+5JZVuWHPm4OMfFpktsILlUcUXem2Jdrtfqnuq
         KDhvu5tA2MnhcqSYaXo8ObnYCGriYCWZuq/aEnvCyLAVqM9JdujOqkKPsRJR4QeAXdKE
         pKyOJS4QE7frfZF7R0GmiSMhdHnkbkOpHbjR6uFRiQhY1jlidx3g5YlFhb17NuhOZGbE
         9QhEkSj1RgthWbriXI5RLHbAK7ucRDCKv2zzFTTsNzO3GC9j+cehbuRUsP0Cjdn/PIlc
         z80ylGO2bHKww0sZxi2sAEVs4C1APT1vQZFMV+1fb9ftirwP4V8NUu6UiRfqZOU+6OQx
         jZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763555293; x=1764160093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+CKhj841T0e6qZvubDhvAJxg1sC8gp96pehxxFiAmCs=;
        b=iZ2RVuzroY/Fuib8r8Yih8FGeBTQn72uBUXmUk/n5WBiCm01TTE8UtZFTnBUc2ago+
         JPVZ7ysdaKV76qfRe36hYK2Ba1bmIbj4hm0ej4Od0/GyskL6R1fkJzhPW6r2aubJiUGB
         oIYwSH2VfN5YkSyIKAK6qASCNu0v+p/LZOQocIP5F1DxG8aKcKWiae7x5t9zRVBa2qUn
         HA5iLmNmHaE1IVcW7hjJ6Ya/MuOEocxw6JLEg4Mh+VrpTEGhIaSKwLDWWX0rpEyg1g+b
         jKFQ4Xt+6HRwHATkOrhPm91iwRj+BKWD8ywJ0E+e9JqBUhc4GFGj+bvnaqoBD0zNyF/A
         xsxg==
X-Forwarded-Encrypted: i=1; AJvYcCVVBZZWZWEdZ3VvgVDZfNd5pcs8FUAkvqAgXpzt9/pzxq4HMD7T/ciTW44Xx0D7T/iuCQYskB3R5w==@kvack.org
X-Gm-Message-State: AOJu0Yx64F81RxH1BnOnOSPj9BiK6RGzcIKeVa95HZuj5LsvHbrCEhoc
	eU12fcHpMxlUemOyh64UpMv/wnjKo2RBp9WAiHc7t0EYC5YjHGdZKhM7
X-Gm-Gg: ASbGncsN1vQjfG8EXUq3LrOHPpxUy1QWvbBXZCnvDhudlIsHMRhUxmj263hotffLhdK
	KnSCd3TuFfXrjVr/UW/2LlRPLT6Bvb3ooVoTncpAqwCTTTcSvchHhHw69SaX29d3GOe6cp/TzuR
	LQDpDy1dmP/uh/vgE9CCqmrNRn1PDZ9Uf/qfpseT2ov7vAzS25Avb2BDUBzJy3E3MEeIlMyjYAB
	M9khNezo7exLNjvI2lr/T/EhDEBklTvQq+TRLnfffsdGVLh+mVuAIGDUYdV2Dx2Yy5/1sp25umc
	PDX6PqlFqV8EocbGtJZMQKcxKiOV9OKQYx2m2/WADTJVFGSqM2ocN/gJkSCyl+fVzH+moS/c54i
	ms9Fv4sam+9Ug8F3XKA4VokJaXKPkhybVO6PjpqNcaVRtd11glM0w4vrY9urvMfh/C+/RNN5tgR
	LAKqDIe3bnbXszi1ZHdmo=
X-Google-Smtp-Source: AGHT+IEJJjWz+MJzpUl7ns76a+Og9nUY/w0T8Ert+O7huCBITXi39FiE1X0vmFKSLM4XAxMf1Yzn/A==
X-Received: by 2002:a05:6a00:22c5:b0:7ab:8d8a:1024 with SMTP id d2e1a72fcca58-7ba39bbdfcdmr21856893b3a.7.1763555292868;
        Wed, 19 Nov 2025 04:28:12 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([45.8.220.113])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92782d39bsm19596383b3a.63.2025.11.19.04.28.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Nov 2025 04:28:12 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: zhangguopeng@kylinos.cn
Cc: hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	shuah@kernel.org,
	tj@kernel.org,
	leon.huangfu@shopee.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] selftests: cgroup: make test_memcg_sock robust against delayed sock stats
Date: Wed, 19 Nov 2025 20:27:58 +0800
Message-ID: <20251119122758.85610-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251119105216.1675608-1-zhangguopeng@kylinos.cn>
References: <20251119105216.1675608-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FE021A0002
X-Stat-Signature: 7b1pxtd77s844isw6675f19yjpsazzge
X-Rspam-User: 
X-HE-Tag: 1763555293-964792
X-HE-Meta: U2FsdGVkX19ZSrq1SrHn8gjBzPDEVrEbt3QGsvka2J2OzCoLDu9HVTAkraKeTnzUrhnOb6KEXCtYvLRseB+AdSEBWZZ9o3i2SdnMfPMaotiy8ShezepDZSwQzz4CGszjKX3eRsyJ2mb8SYu8VkF3vQB5C680zMafecRzxhp8Q/1+vqiLpsIkDSTBtaL1OVbOAOYUw07nrL8eVSIPfuerlkBa1UUPNxj/cITbWDAsg/2tIwXR98GYqmehHzj5jbdXMsPerujkFsRgGz8pFrQcGwGYWjIgsFqrsv08tKSkKevwdUaW0KdByzDnamn9XoW7S26rD0e9C41dJwgcul0yxnHApaZi9yNmh6nySb++R1PkJeCKgRwMmRUIB6HrPZ96AgZFOxPBFFyAHONIzWqvfh7LxY/ahPGBvpFCFvuDP7ZBdWYKEEAagMsH8fAWONDmYaewxlFMaocLzoAADBf2JrZ2gBMCC/M8hQLvuvgDiyb9NGqYaqikCkq3bu/3q4Z5/dEQ41eTTBrVEXE0gTku4MzZ7ayXco68lIo6uFKKaK3PsV4AIvzWsf86CvUK6b0NcIlvUmC5bMTMKPmaqpNLipIeiu+yblM17ONUgk0S07k6S51gByIY425JXPwYibHm9bLCZ9YcFfnvE19HYyC2quMXQu/zu7XDqP7yQUBM+ptgMR5mdHO83R8URTn1ZEd8l85u8RC++P5+I/YvPaWE0FgahATpsy8mrWFSNWKrS4zV50HwbeiaAVY0VKrEAOyj5UNA+M7t0eTA81BflIApUrvs5emCCHh8yGhc0ZSlQDNVbVZTvZFegmdBK3TQeDj+uFCQhgDjCJsQUJ6OteOG+aqChmVSLl55c+BfL9Q2HdocX1jg6+wsfXswY2inM6LwauUOCPVQgnn2LdMvS7JdBdN6yfwqWGKbxS6NWDW1n/KZjPmJn9cjzZ2HhftzwuUovnZixolHCNFXwZjMCfJ
 RVWmR1Rn
 FnpV0TzP0Wtx5mao4gT0kJO4ILfXIOeQPdeqsjMEYqsTc1zG1o8Gx5CGOgc+3LhNANE6cxV/yZ1dmbZmh3c/jQBdH6lKEjzF/YCZelHb65DpJsrA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Wed, 19 Nov 2025 18:52:16 +0800, Guopeng Zhang wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
> 
>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>   - memcg statistics are updated asynchronously via the rstat flushing
>     worker, so the "sock " value in memory.stat can stay non-zero for a
>     short period of time even after all socket memory has been uncharged.
> 
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
> 
> Make the test more robust by polling memory.stat for the "sock " counter
> and allowing it some time to drop to zero instead of checking it only
> once. If the counter does not become zero within the timeout, the test
> still fails as before.
> 
> On my test system, running test_memcontrol 50 times produced:
> 
>   - Before this patch:  6/50 runs passed.
>   - After this patch:  50/50 runs passed.

Good catch! Thanks!

With more CPU cores, updates may be distributed across cores, making it
slower to reach the per-CPU flush threshold, IIUC :)

> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 24 ++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 4e1647568c5b..86d9981cddd8 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1384,6 +1384,8 @@ static int test_memcg_sock(const char *root)
>  	int bind_retries = 5, ret = KSFT_FAIL, pid, err;
>  	unsigned short port;
>  	char *memcg;
> +	long sock_post = -1;
> +	int i, retries = 30;
>  
>  	memcg = cg_name(root, "memcg_test");
>  	if (!memcg)
> @@ -1432,7 +1434,27 @@ static int test_memcg_sock(const char *root)
>  	if (cg_read_long(memcg, "memory.current") < 0)
>  		goto cleanup;
>  
> -	if (cg_read_key_long(memcg, "memory.stat", "sock "))
> +	/*
> +	 * memory.stat is updated asynchronously via the memcg rstat
> +	 * flushing worker, so the "sock " counter may stay non-zero
> +	 * for a short period of time after the TCP connection is
> +	 * closed and all socket memory has been uncharged.
> +	 *
> +	 * Poll memory.stat for up to 3 seconds and require that the
> +	 * "sock " counter eventually drops to zero.

It might be worth mentioning that the current periodic rstat flush happens
every 2 seconds (#define FLUSH_TIME (2UL*HZ)). Adding this context to the
comment would explain why the 3-second timeout was chosen ;)

> +	 */
> +	for (i = 0; i < retries; i++) {
> +		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
> +		if (sock_post < 0)
> +			goto cleanup;
> +
> +		if (!sock_post)
> +			break;
> +
> +		usleep(100 * 1000); /* 100ms */

Nit: It would be better to define the retry count and interval as macros
(e.g., MAX_RETRIES, WAIT_INTERVAL) to avoid magic numbers and make the 3s
timeout calculation explicit.

> +	}
> +
> +	if (sock_post)
>  		goto cleanup;
>  
>  	ret = KSFT_PASS;

Thanks,
Lance

