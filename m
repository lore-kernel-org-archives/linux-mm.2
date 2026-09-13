Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871E8C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 00:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0396B00D8; Sat, 12 Sep 2026 20:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3615D6B00DA; Sat, 12 Sep 2026 20:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276B46B00DB; Sat, 12 Sep 2026 20:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C996B00D8
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:52:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0C79140560
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 00:52:50 +0000 (UTC)
X-FDA: 85206914100.28.EAC87D1
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf10.hostedemail.com (Postfix) with ESMTP id A529EC0003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 00:52:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTebRpj8;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789260769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GweSOghhzjWnfuYCFBbbhvI4fM/pRZ5riibqzev0/FE=;
	b=7mmVGStVyffd9F3fkaohiRyGR+xsj28wh/Ft6lYBHSMPw40eWLcQmFWJkeLFxtHqsjPUjj
	aIZu4Ujs9xeahmoyh1N5qe98SvKefxYmSLJRDPghYL07NmqJA/G0l75ZfNgmpxCBePfjKv
	7o0U240mhyCwelvUIBqpAIw12myyvic=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTebRpj8;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789260769;
	b=MW+zj/tjbSijKDUtBljBJ9Hu5H7A7ejP7V9w830jxeyif77KQFmIfsF53X2+Cdejsv5TAS
	Vj7EWJFZxwwFlzgaoIm4d2PwzgfEC4hWOt9EQW8Syj9ZTRunDGamZAJk5+UAckYeoRxipn
	7GXeucbuABFPTxPTaBF3HmeRyJ7OwD4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dEqQfU3lTD/bd5QrEcI5VNiNtdR+MT8JPrBJyfy09V4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789260766; v=1; x=1789865566;
 b=bTebRpj8Qgs3LIT+POhy2MZGMmTbTReSxuqKKHeSpY59Jw7czyna8LieX1p/QKFaSMwpWSVY
 mjOA3lUg4MORMplEm9UY7ZO7GyKlR/0mzZWFljLwHC2m/mMENvSV27/krFC0ddtR+Pv6Z9Cv7Zf
 7fH2X/aHV61EkQ35Llf8vBkw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 52314063f20a0e10;
	Sun, 13 Sep 2026 00:52:36 +0000
X-Mizu-Trace-ID: 52314063f20a0e10
X-Migadu-Flow: FLOW_OUT
Message-ID: <be7989d3-648b-44e5-b90e-f4ab8b2066d9@linux.dev>
Date: Sun, 13 Sep 2026 08:52:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kselftest: mm: remove exclusion of building soft-dirty
 test in arm64
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
References: <20260911210611.4001419-1-yeoreum.yun@arm.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260911210611.4001419-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A529EC0003
X-Stat-Signature: fzayp1xd4z8pu6y7t4mrgdf1o6whxni6
X-Rspam-User: 
X-HE-Tag: 1789260768-155603
X-HE-Meta: U2FsdGVkX19ToG4pRZ78kND3iZ4X74YysdVvhImsy2e/7WUofCMtYOwVw1h/tdFzPEk+eY8DkA8zV1Rv964rH1uaeEKujTrVU72mmflcjJSpBPOquBqUSFvQP0pr/ezwHtIeH54VkVkEXUoagd080GnTv6mWLQiwc2Ipmdk5UOp8qIecxSzO7OhF8aUvGfwsq4lCmKOrGuiajZ0I2Z943ycvHQF2vSCxiH0j3YDVzYt4CF1QXOd4dMem+jsLsBh6BYkobDVWnil8zcTH0JOHKx0cvKf3FtjRyqpjoJ9K2of2mKAWTxEOR3ueoywSIcoi7SaOv0cyhpEObHz561tiOi4vcGIz9TiI0J4hIpY6+FIWBvvfFUr3aKK0XgxdNRJMP7xU9mrHRsrbuhLwXdKAqDakFyq670IRxVBg6F5QUUNfgDI0tDm6//eA9o90+3sJHlTsIytMSiwBZRwlUQasUUjXswKYEqB5ZITQqyxHUKqRjsxE0E08+S9EMAFoVrJRbzbVjnbtqSJEDSERC3ByemzViJGQ8MJcGNZWzT2cZIyw/NuNF0TgQIHNpxLpTaVveKQalhHZ7luyAHgOx9XbEQgNkL2i36vsLwG7S1g0cDSuTQkb9xS4fNFhDHt8WcuQgcnggmttzP4sYhdvTuIJfeEouMiT5Cj67mlhTQRM/QYJqbABuRj9lTciG1SZ/h0qmY0tJPgq8SBD41Rxt1wdmIFy9a2J5tYZr5UiNiercSQVOvd7yBqIlhjhoEbvpS+HmwtOKaZqrw66RmsO2l/TJtAwj0tEpeDyZntLeja3mXl8IQR64HQ8qF1LXdDkdsI4WTZMTsMCz+R4o2uRGO28/PMpEcloFyHTTHc61Es8ZImIxQXILHxPqSj84iYJDaXzZYXUgQj3sVHZGKQghMWh2gUcGeafFuqX4BsOD8dlcVaN9H5oaH/GtdHgfVBiiXtMiKX5x0o3Iq2YknybWen
 uPikOPWI
 XUfRu/xx5hQuD8x+MIU7/E6IDpDdcONB6DFWd/OC9VWduM26aoinK9MgHq6D7j/Jekiu7cR8jL6xCRIM7Kv5JvjtLP1hesD8pDFn76IqRct+fSM7I1RymmTjSoPX6laYfjQ88wVgBxCHP9CrJh+dm7p6YPzEkSAKaL+IzqOa29nDLqvI3eCzU6LAM/t/i9Tsprm6LjHMsIyz5/hJ1V0wYskk/s5lOldsqReXmTX7LK70uIyLLjxTs7AThlH1tkHfAikp9/ItcpWgxHiu3Xw61k24/1kNEar+6Hdyv9SOoHu0TqAUq/rA3m3RVbHpEoqUDjwtNGmM4SLFCPOObtwCx9x3AvTHwlGAIrvc1p7oZKpI2ErDvmhgXCbMO+ny32fteqbGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 5:06 AM, Yeoreum Yun wrote:
> Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
> the soft-dirty test is skipped when soft-dirty is not supported.
> 
> There is therefore no reason to exclude the test from being built on
> arm64. Remove the arm64-specific exclusion.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
> Changes in v2:
>   - remove redundant condition in run_vmtests.sh
>   - add r-b and a-b tag.
>   - Link to v1: https://lore.kernel.org/all/20260911125028.1268274-1-yeoreum.yun@arm.com/
> ---
>  tools/testing/selftests/mm/Makefile       | 3 ---
>  tools/testing/selftests/mm/run_vmtests.sh | 5 +----
>  2 files changed, 1 insertion(+), 7 deletions(-)

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

