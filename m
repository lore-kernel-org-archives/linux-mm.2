Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B07AD25B45
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847A76B0088; Wed, 28 Jan 2026 06:28:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1F36B0089; Wed, 28 Jan 2026 06:28:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F4F6B008A; Wed, 28 Jan 2026 06:28:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60FCB6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:28:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B78DD2BE0
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:28:56 +0000 (UTC)
X-FDA: 84381150672.16.DA67942
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B21510000A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:28:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tvKn3PAJ;
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsg0G1qQnJMZmcTOUlSvTX8oIURapE56eMOFO0KQLsg=;
	b=4xmfMYBIiICYFzMiIFPw47YrHOfhuhuN9HwJYuaN17zpiJ02HBQaxZRzBwkB+N+fqpQPQm
	C43bHNk71aR2MhbPHGlZL2FGwkbb7WHs9zeepJjC/yJg6PVH7rRBO66MWDfGRiLvArViPf
	B14xr/fWHAkpvtZZqNcY6Je0zpwqWoM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tvKn3PAJ;
	spf=pass (imf14.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599734; a=rsa-sha256;
	cv=none;
	b=bX/f5v34uR+UXfcFn5ay+srJdyiDkSIj3eRIuOj5kvZaeH5AnRm6PbmAsN26RPKaET3ivR
	maCDSKTvfBxALCdewKoNYNZ+slSu0LmIVsoqckeBTBD1mwBiH7dP9Omt91qkZu93zcT0WH
	LfhdKue4fEr9zRUXBYPJX2nRMrDk/Bc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so12497849a12.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769599733; x=1770204533; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsg0G1qQnJMZmcTOUlSvTX8oIURapE56eMOFO0KQLsg=;
        b=tvKn3PAJaKyBf++e10fKd10dSWJ8U/94oP+l3yvNsqRS+vYBXEw5h2Lkwd5h4fjE0C
         5Jf9aVDvuBybDhgN7kwkTLA+bZtT9XW7k0XL22hfXBMN7sPKxz0vEd4MWh0SyCGnm/Pk
         4hRnNgl+1Pa5XnDWaZqAKBVJnRsS/wWI8vTvRqg7r+uo8rVsUIM5Hl0ogbXqQDf5CIE0
         CiYXSwdzUrdfLv5yk3J8514r4khuE/Q2jmfo3aQOiKAjm6UEy1tpR9IstvSGNdTYQ7kH
         VDJ9Kj4USOjll1hFeMPrSfIKo9aCeNGDM2U+Kf6KOwhs0Ob1UOa9kmxyJRD/M9rC5k/9
         ql4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769599733; x=1770204533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsg0G1qQnJMZmcTOUlSvTX8oIURapE56eMOFO0KQLsg=;
        b=SyYY1mVCghDCOh/ZmQwayIEB1wEbiA4u6kEKFSAxL1NlbOpa9l5Ni+jcvWdSNERBKq
         Q/CXyT9bbcWWQ320d61FsHzZRvpr3rQrbOGx8m12M1f3NdICMcs83PXsvzt91KgVq1hi
         YBzBfwns0vQdsK/f/bNAiqLzt6t/TLicVOlHJRFW9B1cMrQ1/KbYi14qiPK/178DSrfe
         8NvC8nGEvgxY8UJSA24MloCxA/9jF0aO9WyZynokxxSkumkiBBIYQ6fL7nZj3QfBk6dT
         7G28lErLFZJf4Vi3gBCRWexrec6Jz1lP3lnPRuuz1B2Vz2SQcV+c6+FFlxb/B7CRMV88
         DMow==
X-Forwarded-Encrypted: i=1; AJvYcCXojA0Dh59c0mKPqz3yPvl/k7UI+nsVBvq3uo5ULuGBojaduYR5kq0//aJtAvZpbF4HhbfbeuQXNw==@kvack.org
X-Gm-Message-State: AOJu0Ywj8e2ZHVNfEmVp5KHB80b51tv5X/QXZx+UOfI2pKuFi8yy+lEN
	inlr6zVjWBVKyrMJ/qAVV30jNfAQEDFUY6eBo/d5WySOvPyvEZeXwDWwUQfBmvxl2Q==
X-Gm-Gg: AZuq6aKd1EfgLXb98Cj1gLGmhd6GhIj6TLrL9Foyz3TFsyatz8kPvwt3u7IrqIHDY3+
	aLn/gCP4f1kZ8FFhFJDZhxAuyx9DJ0dOyNHe063fUO2JC6WOod29CtjKa4mbAn2TQDv/ohBRv3L
	RtZhiXyoDhO34RTjmYHN1aLRJYkUhFdfmWTdSzIx3pmAgZ8hBNnPpIXBngc0yjEWzVWE+csg0SB
	WcGWOOO0sx2KMtnvPqHVU9lycbEb5qXYghOMk65j2cch17NivKa38M/zmwqjMAzZqk6pPBRbHQY
	dCh27YuJRq/Yag6Cu3b0uQL1E2WqeYlEnLnboFt8ZiZyIA2bZO7gNtqGvQPgbPIdVSyJjsWUur1
	rKrUX0gaPhxkRx83ICIinAl0zkdFILGRk7ePXoS3dPkwJbFIWNxYGFUtSNveVNoRvVu0PTUB/Re
	Hse8uQIrMua2UEsb2zM6tBMENeTsbng0dBPsKnc8C2iHvCFqbP6ic=
X-Received: by 2002:a17:907:da16:b0:b88:646b:ae3f with SMTP id a640c23a62f3a-b8dab1a5c0dmr331559966b.15.1769599732400;
        Wed, 28 Jan 2026 03:28:52 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbeff5629sm116615766b.27.2026.01.28.03.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 03:28:51 -0800 (PST)
Date: Wed, 28 Jan 2026 11:28:48 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 01/17] bpf: move bpf_struct_ops_link into
 bpf.h
Message-ID: <aXny8JWF3KZiqBZi@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-2-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-2-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B21510000A
X-Rspamd-Server: rspam07
X-Stat-Signature: o4edgfgnkkp3zyxr3ugyc56fcqms3g1a
X-HE-Tag: 1769599733-903783
X-HE-Meta: U2FsdGVkX18kup6gQx4ViuU5doSY9LmTuMjTcrVHKxG+Dy2C/Z4bV014ABoNrNPioOukPtQtVjGOSK7R+AMTVSSbDdJGq8qs/sXFrXrbm8MSJsu7wzmodYQcE8Dobdvx10XrT9CBqYWhPEEQ4zMJPTi18xrEDpiFgwWQUUyM8gf67orv6qgurE8j69Wa5o19eszvnOmLUeJyk/wo0jipjVjQaJbKnGF2mNyQZ2Gjcc10uQywbFgmxL3CWv6nH4xJDLdi1gKsi+je42taJbHus95aiBOA4tQ/koHPYlO76xkoC+jp7AeiJLVVm+A3nqkE9P0n++OtbYtVicigoVd7ZZ8lo2Yj+H4/rLwmhV3/RLSjiswaaUCb0JSHGz08CAucEULWeukBe/3ITpyPKdmeuysK73Ar8T+UVBWIWNLk8adyoO+jEHLe7BPzWuvaRs6bFOm1OA2cnFhLToM8N10jYUY9lh1ZHsvxMq17PhRt8cR0jdUF6d09cUpdlCbvEj0ag4gkGiYfha+G/6F7s69uqWyZNpWhkheUT/m82OXQHuhs1k6QznAlraJVH4L1x/GgPkHc5X5azRZbvDBPmGkagwkuyPDXIboz6bT6c/on8/D+sy77YkjkruBHNRGTwbarH5sRTannqUSZAsWRGOw05Ln5ZF51f/qOg27YyqeSVNRMAOXIscaWGBTRw8xI+nxILdyP1HyKJg2LWOZjkWYSfyaZ97Cm9gBSsvoTulcHS1iCaWZ+2zLM0jpV3b9J0YWurGSf0NRI8UrUfaIdsDoxdnRqpJ5K73zh2UZKX9o69RVSmyGVnyx4dnEZu1TC7VRdL5leYfDhAQaPHju0gi04QlfhtdQsEOXNcqChilgbcMBuaMSsFRnQPAztTw8zvLKPBPjV6LH+QhslZpN12GAHmvlbCmrMif9toMFrbx4I+qhP+1ZacWJp17MdILMcZ0U5QGlsAI6C7fLNTrDA+hL
 Jx4wRVA5
 95Sh8RqoXC750hi+WpMwZNZXNpi9Y+m7JZ7MYtpWixS40/+RJ6a/ICYJ4oAqfT42I5+uGfikeZsBKW3gUJgPeo27lxwmVyfSaOKUvAiQGeLGjcbb19GGEd4q8O+s6ZHnYJI91ABVnLRuYNiWRFLeI27eI3qxneG+zjgZyyl6sG65zsUilZkzeFuw4sgIEm/UtEkbT4M7ktjUnU++eMduEMbhnFXQIP472Yf0mBDLaqCuy6LVT0swpCfv5T+5kcw4Xi11f0BJoctjPRBUH0rCWRM4guP6YYDVyoJDk3BKdDTEa9BPL/30OKIUII4kmrp93UOX2X8gZJNasAlKaL3nrrSBWVXG2tPZOYpu8bORD85SdQjEcr2ddXSHbm4m3Quoh2rdOI5UdGZRSg4VgYm+CYnu0eNzLC9rcD1BqIGcnwoNUPtQ9eG0BYAam6r+tfzH7tM32Fb2wttHKql0Y3maJtFMBz7e4fzN1x+wG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:04PM -0800, Roman Gushchin wrote:
> Move struct bpf_struct_ops_link's definition into bpf.h,
> where other custom bpf links definitions are.
> 
> It's necessary to access its members from outside of generic
> bpf_struct_ops implementation, which will be done by following
> patches in the series.

Looks OK to me:

Acked-by: Matt Bobrowski <mattbobrowski@google.com>

> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/bpf.h         | 6 ++++++
>  kernel/bpf/bpf_struct_ops.c | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4427c6e98331..899dd911dc82 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1891,6 +1891,12 @@ struct bpf_raw_tp_link {
>  	u64 cookie;
>  };
>  
> +struct bpf_struct_ops_link {
> +	struct bpf_link link;
> +	struct bpf_map __rcu *map;
> +	wait_queue_head_t wait_hup;
> +};
> +
>  struct bpf_link_primer {
>  	struct bpf_link *link;
>  	struct file *file;
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index c43346cb3d76..de01cf3025b3 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -55,12 +55,6 @@ struct bpf_struct_ops_map {
>  	struct bpf_struct_ops_value kvalue;
>  };
>  
> -struct bpf_struct_ops_link {
> -	struct bpf_link link;
> -	struct bpf_map __rcu *map;
> -	wait_queue_head_t wait_hup;
> -};
> -
>  static DEFINE_MUTEX(update_mutex);
>  
>  #define VALUE_PREFIX "bpf_struct_ops_"
> -- 
> 2.52.0
> 

