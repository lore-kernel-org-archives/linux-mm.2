Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D93CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245A68E0010; Fri,  3 Oct 2025 10:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F68F8E0006; Fri,  3 Oct 2025 10:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097B58E0010; Fri,  3 Oct 2025 10:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9AAA8E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:36:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FDD187D6F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:36:14 +0000 (UTC)
X-FDA: 83957053068.05.E42E63E
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9734040005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:36:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VqhxA6Rq;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759502172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3bsilfe4P9JMaLp7V6K7RsRiPhrCocOZhdOz70gDbg=;
	b=x341fUxutn7dOYZtV2fOtE+ldFdlDouGd2eOz/ZrqexXlIw1podsczXxO5ror7cm6PXrtn
	34v/WEAfw4EJ0038dhXkHRsQmELkJle7oivBrR8hZnL/icQbmusujMx29AN5XHhW/y0jPp
	bj7Zfyd3tf7cLKA5zly6HiaBcmsc75M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759502172; a=rsa-sha256;
	cv=none;
	b=GjcEmbK9JXNviXf2H0Vo1JdiWBHeva8UcAwcSagy3xvNteNfr9lV15eLO3C34sKvvy0wDr
	S5yGTE8sVpW0UphawBikINH7x+nP8P8rbjaSj3mLhMQPa5xGISUPpdokGAKQP0gYnuhYCe
	fSA1AdQUCJghtO10pd77eiQ2hk2Mriw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VqhxA6Rq;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-41174604d88so1245200f8f.2
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759502171; x=1760106971; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y3bsilfe4P9JMaLp7V6K7RsRiPhrCocOZhdOz70gDbg=;
        b=VqhxA6Rqsb147utMmsc24uw1jus55DCCOsIR74dedWtBSC5d+JENn0WaB56cziaTvh
         rWLwlVn1wMvTciEyRjeDmqn5w6+pubtCIoP9+w1xNHN8CjPS+Uc1e4f+FJSAMMUr3xCB
         1u2RAGmbnZx1wMgT3payJKn2BnX3ElBKlJmjH1AHlfe+WsWDxkUdM0jprUXc4rLYvBoR
         UZ2MhxE9Jb+hWKOM19f4Od6kYhQkz5lzWIHrj/+4ZN9EBIkZZa8R1IFq4u5p4jUYH/b2
         pRos7HQbVKtvXfxx+A0IDItPpkg31PowUuHx/FdblJ+5fXXczLhQCSMlQ2ElA/SgPMnc
         f8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759502171; x=1760106971;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3bsilfe4P9JMaLp7V6K7RsRiPhrCocOZhdOz70gDbg=;
        b=VT+PW7JKxWGrSUT81G65tq/tgmV+H5krrSV/8aaQfazt0T5LMtZQwRqq2qu8bPVnrg
         jFg9l/En1K5vOOJOOialnu+QAK8uaH607ruNcamNlfSk3Dd3XwwaSPp+zu9+PSw+JPhk
         XdUjTrqPeb1uv/MjZySbi2P623NyGkaWm4wbbRg+MpRvKd52Q1Gqxvf/B0CJqbP8m+sZ
         WCrf8b3su7WAC1I1o2pkLubthNT9g1ImFgm4ZzcVYbvVL/mtIYL051Ee4ZPsJgi4at8Y
         fcQrakQ03Dp2RpRvfyqLSqDi0Hy8Tzw/sNvbdYEJstgbkIwhHLGVlfujcfiNvCjuqfWv
         Tpnw==
X-Forwarded-Encrypted: i=1; AJvYcCXcR8P4XrxkTCiXMEmxaoheaRfLK+04IgmFAcjMcvTf/TXi3aBO9WeYaIqcO5GAa1HsNUMmi+Vpnw==@kvack.org
X-Gm-Message-State: AOJu0YznoiDyqdeKNeULGN4esVm+5s3vW/35/8wbCUYbZVt2v9VzCKoT
	uxXKNZa8hJVDp6DVBn1LNeeGdhcRjVJo4NitCsmR5wOX1Dldp40+VuTu
X-Gm-Gg: ASbGncsI9zN5aBMOcG0OPIunX2Zh2jn17zuHgrfCIYz0R7neA5XeL79R2pkpwUiE0Y4
	UkS7TZCzSjfntOxl/jqsLTL7NT5XsFTbyWq2Vh/Bn+IVt+iJmDVFOaN5nf1CJ03ccNfW60Y4LC4
	2tUACrlZCzw34+Qh+HsN2+0nsJ2WDqQzgjg/B1aT7TyWyMz/dTS6ErQ5iwDbAcomCzsF5khnihr
	s673ubU4iNkRTDTMtyfdd+Q8ZWinoftT9LtnFxkUf8PZf9A8pPO9c7KyGd/G/ILt0XSldbfhDuJ
	pV4oHAFyo1SGq0Ma+69l7Y7PLKIebnBJdmWgzb69DWLrqQ/jGmQfmGp4Y6BrWUO+uU6qk4Yh1P3
	WER2kY0KSysffMX8y4/V/qDUM3pAP62S+pGFavmd/ZXILYxB01Q0xujHeTSTy7wSQId8DUlwNw/
	lRvLfvhgHVYvZnHyaPB4b03WFYW0p2ReVnh1lZeyJ+0QHqawbUoOof
X-Google-Smtp-Source: AGHT+IEHT3U1d/GKQ/eYSM50OfGWitdYsfgfJV0bECxpi6CkX6MrtzWeGs8zaVLwyNg6i+5+M/ZOoQ==
X-Received: by 2002:a5d:588f:0:b0:3ee:14db:701c with SMTP id ffacd0b85a97d-425671c0f54mr1955781f8f.41.1759502170809;
        Fri, 03 Oct 2025 07:36:10 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8b005dsm8102931f8f.25.2025.10.03.07.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 07:36:10 -0700 (PDT)
Message-ID: <550dd78f-bf85-41d6-9c3b-472784b2d94e@gmail.com>
Date: Fri, 3 Oct 2025 15:36:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: skip folio_activate() for mlocked folios
Content-Language: en-GB
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bbbhc1fpxz6pftddedss9h8i87zru38d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9734040005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759502172-255410
X-HE-Meta: U2FsdGVkX192/Aj0tE2nn2GfT124NUU+3BHzNsXjTbkE45orGvYkgBhJ0cs9Z6s9ozlQVVeojN78h4gUssnG+d9kWBkWgBNZ0+r1wnnmx5DpLTbNXRhF2f5E8sx523eH1UzTDy7hHL+6P51HND7LvfS03lBA68qDQ2PCdFJcT244Qs98AbYtN6iLUEJuF+RDka07XRxhIU0djw4yokTkXvGBP0uVQ2Zvsx3bLzOwuTklFDRIGZWhV30KrTjljVC7e6+VW3T9nL7UOhoNAQnrS7R6JivULzoZlxvHi3KULOhWAsdNv1oHxjujlFGD5tKRZVieH6z3pF8yZlDhhWMK6Z7zg9SNOHHPkVhH7hbD2E7OA5e8IxzFGHuiQfAKQ7xpOlW9lyWxGrX13BCGo7F13n1hQ8aHykG0saj0kwV/jBUXI+iMv8SlDXU0iGfuhXPZDbvS3Yr1FdSVuLGPx0d2mRABQUdlV91QJk8SNNgj7SRDrOry2W20OUVgLl7o+meluoxBhFhczn+i24jeMIxzE2BURptW9HPZpEDABeiNfzPsjYyUooWxQAMAkudJLbzTo5id+4Fr17KIWGnb/MjSJ01qwZPZ0cT2rgMW6EQ88c2STUzh7lRwEnQmInzAtO+CPz/TFp7wBSurXLcClauMx4ZLFgVi0XZHHTOYGbZG13sF1OVcKzgy46b1nFGhsy8wzuML0cM2pm2GLmmzxjIkJP2RE/0ZF5HZBJuUwvFzQOZ3lS40xs5syy2KQHIvmEnTzAd81cYV1GCMFtj6Ik3/1iWj6rHaSUFwf9qZ1eNFVDDv2wNteXzr1CFlJ5ZWaXNUEubkwq8p0hJDFO26j14SV7SxyDzhHMi+5IbOIF8w8mw6XMMq37YbFtE5IkeVTPqd8H4llZLkk2lYY5i1SzkueiQm6+kFdcuIwvzn43/Bi0f0epXDzVmrtxLGZ0b5AcTMk7FLsINqdR5I3pNH+N1
 fzKsR/iw
 7dGq0eolhQRxnFtP0WzIS5+1ZyF9HPLkyqr16LqCpqHr+RiRgslcJZa5KBwGLggKsisa/n0xE4G8ucM88AlpNBJtA7azWnmIeYL1Q0Yp/YdVG2HSNPuoZsx/omp4baqpFgQHA5iiPgQExTcaM02RKsRB8EItZ4VMUdfzrrqkODUoRGyZt7cjgAFKCS1YVHGY4pxIBIeyMLi1iweonlLv1+gdrnCOUbLMwJiyWqoB8dTmfSVRaV0doESoXbT/4a7tZIb2PN5GVimKrNiGLygFGuWooqFqv9AcI4zlo3GbVt9x+Wxfp7DMJBnkB0WwP0PdlOa92CE2G1GlFC4u8XRR4wQgf/jRfZPwXJpSN4r7j6DGMrCcdRQ+do7rk5pYSZdr8JqZpttOUlicxCFGMcNZuRzcctl/5QeIR4JM2UNWct7H+efp1IYpmwmbqxwIlTA5ddSFa4pyhO7v2yC4OOR5pk4s2ASBoARg7raI+SX6iuD5wDRY12R3MJ88blBwdZ3THYVtQNMqzVOO8nHxMamVHxeHjQ7E17q9Iut3pArdg1Rv3ltxxpQOAaKK7Ovxus+g24gbLF5TUwvFuqdgG1SjbBwwsfxIsPvqFH/g1aQHUoUJgCUCTTQkE4WRb9/fLQNcg+lhXz/gmKmL2OqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/10/2025 15:19, Dmitry Ilvokhin wrote:
> __mlock_folio() should update stats, when lruvec_add_folio() is called,
> but if folio_test_clear_lru() check failed, then __mlock_folio() gives

nit: s/failed/fails/
> up early. From the other hand, folio_mark_accessed() calls

nit: s/From/On/
> folio_activate() which also calls folio_test_clear_lru() down the line.
> When folio_activate() successfully removed folio from LRU,
> __mlock_folio() will not update any stats, which will lead to inaccurate
> values in /proc/meminfo as well as cgroup memory.stat.
> 
> To prevent this case from happening also check for folio_test_mlocked()
> in folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates.

Would it make sense to write over here that its safe to skip activating
an mlocked folio?
> 
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
> 
> See below for more detailed reproduction steps. Source code of stat.c
> is available at [1].
> 
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
> 
>   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
> 
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
> 
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB
> 
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> 
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---


Thanks for the patch!

Personally I would just use the comment you have written below to create the commit message.
You probably dont really need to write all the function calls paths?

Also, I don't think you need () for all the functions in the commit message, although
thats my personal preference.

Apart from changes in the commit message, lgtm.

Feel free to add after commit message fixups.

Acked-by: Usama Arif <usamaarif642@gmail.com>


>  mm/swap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2260dcd2775e..f682f070160b 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
>  		 * this list is never rotated or maintained, so marking an
>  		 * unevictable page accessed has no effect.
>  		 */
> +	} else if (folio_test_mlocked(folio)) {
> +		/*
> +		 * Pages that are mlocked, but not yet on unevictable LRU.
> +		 * They might be still in mlock_fbatch waiting to be processed
> +		 * and activating it here might interfere with
> +		 * mlock_folio_batch(). __mlock_folio() will fail
> +		 * folio_test_clear_lru() check and give up. It happens because
> +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> +		 * folio to activate batch.
> +		 */
>  	} else if (!folio_test_active(folio)) {
>  		/*
>  		 * If the folio is on the LRU, queue it for activation via


