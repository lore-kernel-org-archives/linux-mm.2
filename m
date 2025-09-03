Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64ABCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2B68E0007; Wed,  3 Sep 2025 11:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A2D8E0001; Wed,  3 Sep 2025 11:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0698E0007; Wed,  3 Sep 2025 11:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 271C18E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:48:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D82FF1607A2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:48:55 +0000 (UTC)
X-FDA: 83848372230.23.89205B2
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE82620013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:48:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aggF2bPz;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756914533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4NFWtXgAaJ6iNMsd+UQ5O9Z+xVd57WsOenpYzlV6Kk=;
	b=4kwNLac8sqIcQg3RbeyC5pekpVnqLUislNuR7mWtX8MvSi8zNdzablp+znqEuWpXvze6/P
	e+ftiuyK/6sbwGNXjq39TSJuPQmmRzu1IJzAtSMe3TU+nH4c7HM5DxIJY2/6SKI3wg6H4H
	Uvj1Mglpt/NyZJqmLIN9rhDkQEAQOeo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aggF2bPz;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756914533; a=rsa-sha256;
	cv=none;
	b=6cK6QVATskWVTX8GuHuu2aeKIakEt5UX7UJMDgdoi5rucO1pK3SFf+wOnWHcHbjS1eC+Qy
	pAtbXU3JoLQA1gkOOCmkz7KH/o51i7p5nJwsTlDntZpuviy9iis5dcud0xD0jUQ+J8y3uq
	mv1XLiMrZvT/oU/KaSEqSuvjrjiTfDI=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ce4ed7a73fso59298f8f.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 08:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756914532; x=1757519332; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4NFWtXgAaJ6iNMsd+UQ5O9Z+xVd57WsOenpYzlV6Kk=;
        b=aggF2bPzij3eWI3+CL3MUjG9+GpycZCqSZa/Ac4MtIx/pIWfXLgGn2wRRi/kAHbgYZ
         L8/jd23M6jA9NDqZM6yFToJ3Ek+nLqlvuoJ/LwG+HQtWGsU22mS+PVJrBFW2X0tXCdV4
         y70h2N8Ssy1AReQ4h7cEzqIO7e4bfUri2Rw92RYk7zMCcwa9X6VXeXdhgNxCxpyalbw5
         ukZE8WSwM8AudXGdenqo9OzWP1Z9mPL9U2Mn02/lnSeDADChSv5gYFFN8cw2gWHnO4gm
         hIL64VT6ThulGppdiUn+nLJDn5JWHzkeQqU9y/g8eY/6U4zNtAJkeMgduwq/e/GrBDJ4
         ymoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756914532; x=1757519332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4NFWtXgAaJ6iNMsd+UQ5O9Z+xVd57WsOenpYzlV6Kk=;
        b=tWCWHYgDkSyCCfODgunZv8ayTSu1ABvefZtD58V/DZYMrsJeH0lT/F+xFDorGI8oPH
         WHY5rxEp282nCjCK7B0Z0XPDVahHOA1iqzQ4/oVYFkRVDxi2uktfIWysBYX82hFW+A+4
         kX+eTLd8Ftivzi0A/mqmkkFsGzu6WE9KWLKBGSiuClO4Unze/avB30aaqXP9Mysjy9Jd
         r6LGg5CKrysI1A4qXyLo5Ky0mFYpgxZHRcwdOeH+rMdZ5TJ5tMm65sfMpuHlN94jq/jy
         LSqX3iIwGnaOXmhD7eZZGIHDU0lFbZwoPMRJogm22Jekujs94JsQgCeJkBnaB5QudzRb
         MQBQ==
X-Gm-Message-State: AOJu0Yx/AyqRNhduu+jdS9RRoK069wjZbygqeHFgh01s1a3HokZufKDR
	k6RJlWIHIBL0Zmlff7qd57Plt3vCNa4KIhCd8CY3KG6xh+8a2TuC11T4
X-Gm-Gg: ASbGnctsGZ5GPxxW0v2rwEvyvd+y3R3x1DA2vmD1bL6QsDcAN9ewo/mYVpdSQOGNZUP
	EvvXuEZgHvadET8m3CsAGn9k0W7CpvV0a9DCvyf7zTjU8l88fY+dXxj+cQipEU8TRmAMczo8wlp
	fR3kFcBW69jNbNjcNYHo/GybHpV7ezqHzy7BDXNl+bNXYPGUNg5TiXx8TCjeRSYXrbIs8tsFze2
	j2j47Ie11tHfFsLq1hxzjL9RLBB2V1sh85a/kOMlklx6Z1pHdPx97nWxRJbf3U1crq9MP+ghsxE
	EPldNgF9iPjZ7han9JVSQ1EpcEMvAawlS4YRPsgKZft1ZBGJhYQE35+9fLflTN6h+6+WMaowS5h
	CKEuKK/eJbFbhQq/JuzzDo69th8x7R238CUh70lsTcMx06hGG6xr8aJ1eTxsypwvOjpQxk0baOv
	8wOmT9Xi78SOXQEevTYhnXOA==
X-Google-Smtp-Source: AGHT+IG2IWHGwxoWmo8S5cPd/A3dfYVVUoCh7nIq7BEowuCtzecaRZAq7kW6j5HJmaHkGmaET7f2fw==
X-Received: by 2002:a05:6000:1786:b0:3de:c4dd:9e58 with SMTP id ffacd0b85a97d-3dec4dda120mr1788739f8f.50.1756914532073;
        Wed, 03 Sep 2025 08:48:52 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::5:3267])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fbd01sm24556962f8f.13.2025.09.03.08.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 08:48:51 -0700 (PDT)
Message-ID: <45477803-dc64-48be-b460-e2c66cf4b9e7@gmail.com>
Date: Wed, 3 Sep 2025 16:48:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-GB
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Vishal Moola <vishal.moola@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756897825.git.pyyjason@gmail.com>
 <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE82620013
X-Rspam-User: 
X-Stat-Signature: h133bs8e6sq3q1nj4t96on19o9mrmwdf
X-Rspamd-Server: rspam09
X-HE-Tag: 1756914533-837518
X-HE-Meta: U2FsdGVkX1/CyN+wvdKxT52lzwBAD5dK99bVKOsDE8U+N8yIKviT6yL9mSl9KCL4UzloJv4NLna0CZnAk8m0ASGeVTB9rUVt01R8EQGdM4FyQFZFeqzKYF9ISlWZwrAKMKppANlJHLLHgD3k++ui8/DEZaGZB93B6ykbhRxTAYx2TSzlinkZIf82iFWZMFFeHPwnGGJA4JAtlulJZh1LC9gUh0Zp2tvJITMw8vQcOQFSQp1DH1qa7Gex1u9VzdHCzpTrq44zY3l5q/ruOAYMl/ApNAhfcY83nfM/UsZiQJ8U6lY4sloGZJkdnikK4SDDmJMrWaXbdeKlz7j5tkc4Ctpa8LzLgHy/SyC9UdktCGQDan8Hcrrz2nbsUxITqZ3GknPxCeVhJSruc9cC0M8jn3ZYXIQHKEArhLOyGRc+68NBqkTjh2Gd+Y+gsNObRaViKKDZvcjvUa+apz1eFtmlQ78ZfxbRi7PAcFhzx9TPHCCD8NK4ahm8i+e43imVdIdf9lbm8o83sieiajy+rfnV3c05E4g8i1SijnLqzy/p3mZCS5dwUzwoA67MQOvPdKvfJK8cWjb9MJC4IxkU3rG0TcZ7BS2IVqxe+o9tagE59loAF8omWrKMVvH8KXHzzV9r1CmauxXZBpBF8mIyxRLlbu4cozesKdpd5J5SyTDsA214Rs7ao9jgHJfM9P9sb8rrjx//m8em52jOedGG3B4lUrVefHSS2Y4vLhYbqbWmLZtTXXvNz1wURAAbEJG66dhvFH0RxXRBT/cyuPPN64uqdaJQx9Gilp1h89MYNPye/6HraF94os7XERnAziNXJ0Dhb+5P1tQ6z4P8qd4kBymNoDo5y2TL+MLL5D3JPxOEqQYn1dt34vxxPnpCelH5TcOPcdqbGblNAILTDQMiztkzzsXsEQN0LaXHFghGTh6qLbNVZCYs5SMZSO8EioHE5P+M8vRjJYKuvdhQljJcVXy
 RO96b0k6
 6GJqf01vJ76aEuoD1HEaRG4KbIxuUCgXxyK6ite/EzN+ejbn/l2atTVvAYzqNCOv8n4IFQzBXRmcEdeRfN9QHKlDbZ0PuClyY8ywdDd2uFQKI1Tjz+WyLCRw0hH7Ps2iLnxha3ZYim8CsfuqftF+Mi/8wSGhH1fA2TB60gG2G9764m5brpfJMhp87vhhnNbx5pbjPnEPOU3eheYMao2Dh5WLfBsygkVx9lUbCgVqOkDHA7zu9uac0aAnyp2bCRH7OpKxMQLwBnf1JXWJTPQz14yvgxaDydB2hr6GF2QNJI+PgST2yVpR1mqig+2Tx1eB8lIERIs1wpmScFEuWHqVJaEKc508W5me/huY70CPt4FoiAOGW36IiLKABvg0JbLnPxLrF1COAVH+eqp3NEs64GG2mVWK1CLKa6DBiR7JSpC5GsDIEbftz/w/9QNWfTc5u7OSAUIpRizP/Z37iJTZ1zd4RBonqoGf0sMAun7JuPkOYFxxR2SuKPKiLYo7Kc7jX3T0dPM8qz5LUfYaJ6ciozRvyc6kCyVP0NRquqcM7c25ApmA3tDNqACfVYsN7FTiZOTadmfIh6G5RwLRRej+QUAsar2EWnrAVUGHqHJnBRENFG6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/2025 12:16, Yueyang Pan wrote:
> In production, show_mem() can be called concurrently from two
> different entities, for example one from oom_kill_process()
> another from __alloc_pages_slowpath from another kthread. This
> patch adds a spinlock and invokes trylock before printing out the
> kernel alloc info in show_mem(). This way two alloc info won't
> interleave with each other, which then makes parsing easier.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Usama Arif <usamaarif642@gmail.com>

> ---
>  mm/show_mem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index fd85a028a926..e9701d07549b 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -421,7 +421,9 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	{
> +	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
> +
> +	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
>  		struct codetag_bytes tags[10];
>  		size_t i, nr;
>  
> @@ -448,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  						  ct->lineno, ct->function);
>  			}
>  		}
> +		spin_unlock(&mem_alloc_profiling_spinlock);
>  	}
>  #endif
>  }


