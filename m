Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBA0CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EDA8E0006; Wed,  3 Sep 2025 05:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9328E0001; Wed,  3 Sep 2025 05:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7278E0006; Wed,  3 Sep 2025 05:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4C38E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:31:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4ADA1405BA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:31:20 +0000 (UTC)
X-FDA: 83847420720.17.9C4460B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id C8DF740008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:31:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTdqAQ+w;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JERqtIgcAWYxTcLUucE5Blenbg8zXWgwZ0D8YaVejQ=;
	b=vYycW2VFWzHBAk8s/UQxaFRwycDOOiCCVHq26qAike+YBb1HrKQaB9Mc6saXuAmO/MIh+l
	NrPoEKvJ1wSiV2Eyiid5j8nS0wEbIMXUv0l6MrMnOl6oEVfcYYDoHLOH7/BpKKyAokoeyf
	bzEIP0IEBEA/XREw7SNSDDr64BpPEKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891878; a=rsa-sha256;
	cv=none;
	b=6bQ7iE0dgHZBWud7zFmPCO/8rhp3XXPs964Otnzm1Vgunuyfo9uio1UQ8wg59+jqS9KxIO
	d76GvkZ1XNIkPFIx0db6IGxCt8PO+Q8P9HXQZmpCqSpRh+Y7+1t6Sny46PaYZ9UWD97rVx
	agWXUyXQbZY54bJbYZzCW65VKi3gx/o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTdqAQ+w;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3df15fdf0caso204755f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756891877; x=1757496677; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3JERqtIgcAWYxTcLUucE5Blenbg8zXWgwZ0D8YaVejQ=;
        b=YTdqAQ+w5lDU5J8owVb4ouBkJP8pC5D9WDAcJl3k9c70fZfN3gXreTXOaSg9NPFYUZ
         +vi/BQ4kcBeXdhHPRaH6rO1KqEm+fG6yayUdopI5T5pM/hh8fbRGsXECHvKJ14fWo7ot
         M41frQ8uViPelXuqV7eaV75U6SlF8yHrf6yuVH6tdsE3pFbo1zhEj7K3Z4B1KC1A3tdt
         1+BaK1FNXrgjiqktuJnF1Bqv8A9QPt+bchAdbMtrHucwSkyAVj3miteQYwlO3gBkgnWT
         I06bIC+mumm/8rQCvm/aD6TIyZK3y9ar+tbdjPNSEJal8eOe0WiTCwh8RaAuk/qyQucS
         L+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756891877; x=1757496677;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JERqtIgcAWYxTcLUucE5Blenbg8zXWgwZ0D8YaVejQ=;
        b=UrTTZw2S06aHW63SiwCXKUKJ1PDf/aIBWPR/ZyqB1TVorqHpEaJ9Z6IHQW1Et/mGVA
         ir/aoY/yHKMK/UyoF30hvlqUe1StGwvhcWXHw7H7w4gTPAbPIsSEYZvgXBHlyK+TQB4U
         s81yKjf2h5Hc9M468bidyicR0fRO8284dRgSStvzUls1XziS/i0ESAXPY3+y7y8jnYNx
         uz1VgtksnUyJ1ZTKdGIPRBq7L5MSRCzNmWryVJE/tlm92JFTwZBAeEG1/kDuAKx9bsaD
         i2+An2gbFIbY6XJ3qddPgdrzeJl60pEuVvYxUiy5xRJIJVSxK3F04QkcoWD+oe4Opmsx
         HVrw==
X-Gm-Message-State: AOJu0YyFqOydBTx6qiBZGNa5ebDwAK8nMbm87inlFpn4SFNJnVYSbKVP
	o0v3aE03XHt5CL5gfE0PlIZe2AWNmpdjmg+JlbGidh0sgGHWfX5KMfSz
X-Gm-Gg: ASbGncsoPIUpjeGyBmgv3it7N25vK+ozYePOFlPg5S3z5M2JjbEo5YZhK//LK46JA0u
	eFGwxT5XrZbGuhcBd9JeS6A1KkwdfhftBSGW4Xuj8bVQOW0vLHOdxrqF8Oe+J4Mc0KMr8zCF5yW
	o5rogvSQ2rt7XAv7YlUqOrWffmIYSVT4DMidRHQbwl5/G5hkLslx8yxNdHPMdbsBmZ4vhnnjqco
	QA3gxHn6ZoM2vONXtrHbkFMmIgZCdwwNTi1EuA6Gidln97IoqRsjoCh3lTngzaS1U9lzmSsXVCB
	Sj9POKqrbwoAmn1J9PS+/GYKTMqfLpStG3tX//u3nflpuXG4SsrXJeEwS3HZCG6DiGD6MTGIntI
	ORFarna3pZ63j2WHgHLGVd+8wAhDKVZUoR1qUZKggFGXbsFJgdAJXZNNtYJvwC2rVrKAxyijT8Q
	obaUr7nIjR8dysOHg7Gw==
X-Google-Smtp-Source: AGHT+IHg2hod8nukF0mnZNlawMmT+p3dWVTvWH+uV9p/eaiLcHW/vzr9TtixHzkgeaarvDlS1nLNjQ==
X-Received: by 2002:a05:6000:2601:b0:3dc:29f8:979 with SMTP id ffacd0b85a97d-3dc29f8097fmr2085044f8f.39.1756891876890;
        Wed, 03 Sep 2025 02:31:16 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm54806295e9.6.2025.09.03.02.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:31:16 -0700 (PDT)
Message-ID: <7f13fcb1-82d7-4464-8be8-770fc1a665cf@gmail.com>
Date: Wed, 3 Sep 2025 10:31:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
Content-Language: en-GB
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Vishal Moola <vishal.moola@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756827906.git.pyyjason@gmail.com>
 <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8DF740008
X-Stat-Signature: ficgoudy7gw7s4q6th1xugfh9f7tdwn4
X-Rspam-User: 
X-HE-Tag: 1756891878-782652
X-HE-Meta: U2FsdGVkX18f1aho6xeRcF6siC+WMPeaMnx0euSMVYeg5vmlfLbWio2AyXrS72+HdI0uqQiN6Kk8j4vput3hJoR4LtnJyhOUBsLerJwywuPFsuBZ2fOi8IpZMb/0eTEhI1ukTo2udHigWrd34hOgfET5nkcGkuJucxqqrvaUZ9+Do4m81zOBKUJLggNi9oIx85niSZlIwsKzS0gY/Rh4iE1xYjRBnf8zGiiUar2ls7Tyy7xcBmrlzRmE7762K3zUQSAfQycC2sZXVN/jROxAUzZ+G64csqKj/VVl9DJCf5SOBqWIL5CpQpd4rdrsS6SCflGFSfcQ45c8ddeHwaoEJWmmoK4fUBMFklAIP3YmAkJfgrDeuHiXXofgzi1Tst2cfoLvYEfypJ4xydVm666ICKU2hYh4MAR3uOLpSpHtBDYYIl1QdfsKibZ8BBx14Yr8dQgxKapq3pg+gwyjizfGPo27kPghhHglE5890qXMn6I574MGlvFxixh+14YLlaziWVnjFtcePOXd0D6Uz/ER7Ghfi5ZGH2akoF6nOPpMazh+g5Mtz+igC4+otXjL0R3BYj4AWRL6Ehge3GIIBDYuzZ2yuRQ/Rgc8kiqjURYexCo7JxpPXuKnQHTQJOtw7REGG0gmpaeTA033229DK4DSJg4Ee5I8zyrUpz6JnRBymuksAaRNArXYVpzAGSejWTXSZTCvtGcvwoTSASqY1Qf/Oou8hYcLIntBlk5EwJdLyWlFdbNzCa4shJ5Qv0eSfhtMW+10aKBqrWexTKYKuivSHRkBT72xYCooXfDof/rw+tfnXXEZ/0kykM2javvNm0Qv6/vMkbI6VOogPI9fcqEWDQHanzt0qXOBpI295A9HgOvKqpZEQiQZTa2X0eZVfLJU91KCHjEvhE+93Swted4aymNVOCsVsMQfwL0euUv5o7WTCIpoC5FFk9OPMb5u4q4fkGBvqdq7f3rHRfuK5t2
 Mxp1D7vR
 m6bSaKcEHX5OVTymizKV0XgEg+eDs5O26WXRsJrZM7wHCwdGLEVjbKLcl8YAESyc9nYCSQY/fjxBy0B2jfMagoY3EMQKJqf0YR/n26dnUyCver3WMABSPYPvloKCxbSFDUACiofdc3/bKn09OPD7IG7w/xdFsTQhEP2IolR0+CrTYIc1wR2HBG9Vt2QtLIklCIrE9EmcssOAYD8r/s6XhiQ5SJcFyMCZlLatRsS+kWSRoP74H+aTl1S3dUyYwvRNcpC5XplkDf9NPBckza34sSi0grPS1iNGWjHkEmqU45vR6zuW6BVsHhItGZXvvEARJGTBzcUItbBBO/soyzQ5BcD7b1xwzk7iC3McUNKnKWHM8xq6nsrqCK6gKtL4poY9C0ig26TWxU5AU9jUfRWwrFEjJmhsQu5CCSOIYsq7Q5fUSfnDs4j41cqJHZgUklnRnY2dYGrKOGEwqmU6y6iV6NsNw5Wbht54yl1fBxbeqng6ecZNI4huFtl8WmTIRFV9++tDRE0kRPFeebiML5Yt65EtazdWVu6geKUOEJA3uNddEEnufnvqyzFcVhHhbJA5aPhqq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/09/2025 16:57, Yueyang Pan wrote:
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
>  mm/show_mem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 51892ce2efc4..4c876ea2b66f 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -396,6 +396,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  
>  void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  {
> +	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
>  	unsigned long total = 0, reserved = 0, highmem = 0;
>  	struct zone *zone;
>  
> @@ -421,7 +422,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	{
> +	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
>  		struct codetag_bytes tags[10];
>  		size_t i, nr;
>  
> @@ -449,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  						  ct->lineno, ct->function);
>  			}
>  		}
> +		spin_unlock(&mem_alloc_profiling_spinlock);
>  	}
>  #endif
>  }


