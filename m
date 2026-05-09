Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F72CCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 18:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1946B0005; Sat,  9 May 2026 14:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A730E6B0088; Sat,  9 May 2026 14:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988126B008A; Sat,  9 May 2026 14:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 867B36B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 14:11:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25C221601D5
	for <linux-mm@kvack.org>; Sat,  9 May 2026 18:11:41 +0000 (UTC)
X-FDA: 84748674402.03.6E0EAA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DB77120004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 18:11:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5PV0WQp;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778350299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlZgjnmOgOf0S0I+zIy0gSx6WQvJycomwiOMo7NYgT4=;
	b=YFz3v1syV5CawN1IaCeg1Xl2BmcLc6kSv7cA3TbhIkLfLvNdxryP4JdKmb80x/adRdoekg
	55eC/hw2fsXryyYZWNLa87CKq3lE7K2N//QQAxm6HlG4V48taWnOyu+Gt0nwP7BzZ0SSVh
	ZymqMJ6dw4UtLDVSZWgWGbjVp8WqeQc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5PV0WQp;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778350299; a=rsa-sha256;
	cv=none;
	b=3XygvbwiAwJGcJ2uwbb48K7ZzEhXOWl7AdmEbbb7SexLaFTYQhg1hTtpmhxAi9sBCLAgwF
	t3/nlHD/5gf+09cXTMizYENhBalp/xxmyQWsaPDf3/avWTTstJ0+JL6+rk6mV8/aVaMZ0D
	mOQ77eV8GrVDj31X94Xc9arScXaXmGc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC5CA60018;
	Sat,  9 May 2026 18:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD26C2BCB2;
	Sat,  9 May 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778350298;
	bh=IGMq8mi6hHq7SDD0BLIxCadD5846xRlgej0IXkRiUfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5PV0WQplgApZUAP8P3zsx3fG9hdsKeQOVFacyaqZxuzwEUGWqGJ9aSbLK7p4/hdj
	 LZG8/NBLtDhyONdpFRdaTYRxYYdMGzzYAXjUEJyv0i/gQxD1C/+9iY+Inq4Dn7xsh9
	 WQL4Z4pkWWz1lU6dW2rgq+F/wKx1v5wDCNHzaN2pNni+GBeOZG6Y2JSXSPNmh3Vc73
	 vk0Mcz/0gZrWptgEm6tMGqJb7ZptqvjfGZHNlpJX41vFaOvVf6+CXd8FM/YKjdVgoM
	 TLHnvXIeIjpeDcPlyFTGMQNBX0415m5SIA8yuVKppQB9nYw0wIiCHf0K7R51rwbpS+
	 I2PBSBBflzkpw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 03/19] mm/damon/core: introduce damon_filter
Date: Sat,  9 May 2026 11:11:30 -0700
Message-ID: <20260509181130.90203-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DB77120004
X-Rspamd-Server: rspam06
X-Stat-Signature: fr8zrahzpbxpyo44fjwthbjt1k9en59u
X-HE-Tag: 1778350299-956093
X-HE-Meta: U2FsdGVkX18gijRg2f1mXh3I11Ayw30AwPRt+IXkaiT1tFoF68gNA5ryBx801DyUFgmQ2uYjeXv2OUUKhB/4nWT5AVcPqTI9L7k2Y5uVf6NU6bM2fadxeO5BjEkFXxZxAK4sxp+eql7IAiDDecghbt3JA8GUpDdihjod4pQ2ZT6ivxLIWPTfZGDFRDwF7x0Mx62JhlFpUCB4XMCUcgZm636GA7IN8lPVnncjwMKqGP8KUjSOlRQNhWvnqlM+1wxyYrv4rPL/1qovzP6XzOMOSIrLLvcarTnBzq56gUKZn8xdomy+yKd9rCCWl03+7OWV7jrtDr49A7d2BWlOrsf0pGJiNm8AHgON0ySgME+blWx67thq/LEsoRxC3bZntNeQUrvGDIPp5LzYsTgNq3q8GMmxFggLFe3s1rN/ZKpyVNWTG3LHUA/9l+gGNxIODRQ0to74JryAapZLrSZwprCFIZCIkhUYpuXq3bM8ixlp5mv4dfn7JEczkXB4jHC9idtOt773rWzBTBC2etyqA9MCIMNCRg67NK0Ks2Npn0Hg7AkeI+zcRezErZ7JCWBrOcONzuMlD+4JCLlHikyfxbvq2XS88c0qS+D3e4qaOSZaL7+fhEeH72iQMWQ3WbNMRDqwznty0g/5XNynKdhvjmqMLx6oTfnR5UWyKkjqNVWgLUbuE3qJ3Aqn57gx40FlQ6SDFluY4/OP6U5SyGIMkQO3JDiFUnNGLo6qEHrzGCuncEiAIs1ZMg9WEROnneJiMhuPSMW9i0PxClnZghkZGnYn44ThgoZZWHD8LPG9DOYice9Sr02RzILI/bjv0l7d0VZRFi574Ajk2YwWDrQnmFhMvGRjbpKX0maaoPAgjOvySkjKdvRqgehh0j5ziTosL5UVJ3btt23hK8Tc5J2TlfXKvSCaeqGqeNmD2jUfm8/TPRYP67fof6f+aUVBh4WSyjLoiXfXB8+AL57l04WfJZI
 mX+5E2m3
 kCG2FzevaJAIoHnZRWRcu+9TI1keYH4yf5yYb7LRX0Y1qTxi1gpiwLdD/jZeCfRn7+ELsVZIR3uSJkJQgFY4/nio3j70Q2pXiD9H54LZrsIs982mDNzdRBEfGF3zbrRkJJZIfRpliiDGIpbix1h41KM6lABAFHU0NX4oSRTMbXR6u0igv2U/d3hmvYD+itE9cZmlhxvdwOzL1mIK/kvj8hNuQ1NRl5FUAvhs5ZiUWob7yWX4EjfLb50XvLIqyQBwZq6ZNqFIdNYNXeoeOyeo4qWuC2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 13:52:04 -0700 SeongJae Park <sj@kernel.org> wrote:

> Define a data structure for constructing damon_probe's attributes check,
> namely damon_filter.  It is very similar to damos_filter but works only
> for monitoring purposes.  Also embed that into damon_probe, implement
> essential handling of the link, with fundamental helpers.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 36 ++++++++++++++++++++++++++++++++++++
>  mm/damon/core.c       | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 65d7ee0a70ac0..3290792eab547 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -732,12 +732,38 @@ struct damon_intervals_goal {
>  	unsigned long max_sample_us;
>  };
>  
> +/**
> + * enum damon_filter_type - Type of &struct damon_filter
> + *
> + * @DAMON_TEST_TYPE_ANON:	Anonymous pages.
> + */
> +enum damon_filter_type {
> +	DAMON_TEST_TYPE_ANON,

I initially named it damon_filter, renamed to damon_test, and then returned to
damon_filter.  This weird name (DAMON_*TEST*_TYPE_ANON) is showing what I
forgot reverting while the final renaming.  I will rename this to
DAMON_FILTER_TYPE_ANON in the next revision of this patch.


Thanks,
SJ

[...]

