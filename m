Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5279CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 19:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9B36B002A; Wed, 27 Aug 2025 15:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9AF06B002B; Wed, 27 Aug 2025 15:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB05B6B002C; Wed, 27 Aug 2025 15:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA9D56B002A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:51:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66C0D84FC5
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:51:24 +0000 (UTC)
X-FDA: 83823581688.26.7CDF496
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 884E440009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:51:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LKlKbAAP;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756324282; a=rsa-sha256;
	cv=none;
	b=MVFKNkOy71PWoqAMxKKnrTcyjD+j4fG8pIBNSd5DdhP1EeOhS0WgD4zksm8dPFUdkGdNlS
	1D/eAefER9N7vTac9Dq4zKwjUbprQJJ6JbdDreaTFOG80kT5tL0Xh34Ohz02uyyfBMEQte
	5gocrTv0S9+LSZOho2Y139vxzOObNjk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LKlKbAAP;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756324282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG7+A/Oo1bd3pV8ZAkMIxPp9o09kNI7G+rW6VPIkmEo=;
	b=HFzU4SP9WYA9uqwAGnpE/3ic96GO4NhJTPoTtgCZUkJCs8JYJsOzqnMXcTevL+xzWPQ0Cg
	1RPjbm2TASIwYQGEKIFjsJJCsL906Dgrn2gN3sdnCSsm/0t7DHidhB34ugAuVexhsxsMHN
	9KCLGvT+02iQixhUImrM69gTTJQBck8=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so268380b3a.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756324281; x=1756929081; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VG7+A/Oo1bd3pV8ZAkMIxPp9o09kNI7G+rW6VPIkmEo=;
        b=LKlKbAAPHWmaYU+6EWbfrkFCBUK5jhvlLNu6T6QHG0XK9UnIazudOzH93Dhxu+6YJG
         QpU+hCX68z4lHjomVXbXooa/SroX/tcAgMKC/it1FGeF/1+ofQZVScbvyDi6f3p3IMr6
         5PWWYk14Wh+UO96O4gPurxAJaZaLUJL6xFOIwQ89Tpq0tbu6GoSzXpVgTYZyl1K4xwBH
         OxicMTMNYqzfAbJ6cIfF3BSl4XM5jNV3inFdWa4woY38Sfz6qfKXrd2FJFx+K8C9LVL4
         1ygk5LSvfzEE+yw+kYbmoyIM4MeT4yOSkrVNfMO5Cuo60ZTUtnOeaTyfQRxEezAYrngv
         o1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756324281; x=1756929081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VG7+A/Oo1bd3pV8ZAkMIxPp9o09kNI7G+rW6VPIkmEo=;
        b=CXwSHn9h6ZS9a+RtpG2ZJW82NHWE5LU/WGGB6NZdRg6cGmwF9ehJ4UQLcH5amAR+Mm
         hhhAYsm5x91Qtj2EyD3x/deCzWvKfx7iIxC4kRhAkBXm55xAiXrE67rGEztFkxk6A64A
         ULzquwsXCzE4SghZMseMGGtAWR5YRYGY0a1qSiJhmXHWkvieAlW+z+5CR7Phyli+MJjJ
         LahsNIi9lJKLPGW2VyErs+MWF4siyw+tGAzlrmpgRGDhSojtfGw4ilyz3Izltg51tY8e
         reCZKcOkTd0mai6SuedyjrzvcI/UzxJkyJInmLqEsfRaP+4eA7q3Jx5XZwlMIX3Cchya
         o0gw==
X-Forwarded-Encrypted: i=1; AJvYcCUJcvupqw7h86tecY0rD5LgaSrqUTlfTU/JHO3lNUZFfOXCokdOneRDTXs0tXwt0t6cMvgjSv4xkQ==@kvack.org
X-Gm-Message-State: AOJu0YyL3TL4v9Ema3Kx3Vaxry6YjMkGIKQIFyX89W9N6coD0UwTlEgl
	SJO+d4J75v3pd1phH8xl0KsT5RsWYDAZZuX037HJv8X4KmN8Ic0d01+t
X-Gm-Gg: ASbGnctrlJCl1zzpsB1zpZVmJXDkgsCf/aEkV/1NAsS9dKpVPhF7Qmc7fRyd7PVuQxq
	NA1YhuB0zhfV7en0SLVTkMoRDdq8FfyaCZxLbW0HwsNTiWsH2gEDS5DC2pzbdRWou5Fg+mk+N+A
	8q/D9dv4DYeRhf0ToX8U8qKAdJbk9JWL3FXsDRWRHj5N81jPAiI4OZp4XBzlcUZq2qkVS2FNUla
	rRKM2OMGDBZpitz80AgvtyunWRI7FzQRZCwC7H+Zj0pGm3ZhdMrHg/bAmBOdFMu9G96w9jlGpB5
	GRg7V8suSpfKOzx4/7Lx7eh+jNFbcfUz3MWTCHdMfPZFGFEfWcY4qfLbuG0Gz5EvBHu4yURsqW1
	QbNHGD0EjZOPkzp1zXRnwZqDUgIrFE0ldyH6aRL12cUXnilpVtsJ1AQ==
X-Google-Smtp-Source: AGHT+IHTTKWM8hzK/JmcECalaHK1fC1BJBj3FvHBboVAHWIiFpuxF2r5PhP3FhfJfd5S2iVPhh7lXg==
X-Received: by 2002:a05:6a20:a121:b0:235:4a12:6adb with SMTP id adf61e73a8af0-24340d11da9mr31837355637.33.1756324281068;
        Wed, 27 Aug 2025 12:51:21 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7bf2dsm12224892a12.31.2025.08.27.12.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 12:51:20 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:51:17 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/show_mem: Bug fix for print mem alloc info
Message-ID: <aK9htWRehfJDLFJD@fedora>
References: <cover.1756318426.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1756318426.git.pyyjason@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 884E440009
X-Stat-Signature: x476fprq37s11y1948gkg9ein6nmxd8c
X-Rspam-User: 
X-HE-Tag: 1756324282-175195
X-HE-Meta: U2FsdGVkX1/nwMNt9Glni97SeAxH63TUpwSgO4yurwnNqTEalXsM5PLPpecedI3RSBIMLtZcicD+32kOLIm6uyedY4GwUaCUIcVG7jX0p15ZoAHrVdIMAvqH8mt/ijVhmDO7uuChdkk8FHfIyeiKP3A8yN+Ux8sZPNAQMxw3jFRjrE5MAgyUnY29kSdhUG0sjsvsx5eE3F36JQ9WZFSPCX6Z2keGo8ZekDUeZhL81N2+ItOzQPpKBgWRBA4RUK7+ttLxs5NDFmpmXzr6PXVAdO2DFxL43tdh4ZXbalNinkuRU+NZGNtc58ONQ/q24NgFtxhuighz9hCd3hOWjju513AYVW4RlX1Zz0awai1t0Z3kyukACb3o0H3VVIchgGGbf8VnnFIFtxMu9Z3wh+XrO/BkshsJ2CUuCviThcBmLl73lr4Wl4pK0o/6k1GWiLULKu6Ba1raxATW6GZ3nEJjx0fROU81zrR5akTWrfbNKaWkI5V44wE+PtVGKdKRO6hFVzsnuIavoUbFzASy/E5DYuh6d+Qo1m9RAuJCz9KdqwDK2ZJAYVLnT6wkVZtlhQ8xpJwNLcqf2PvBDv0J5b7jBD81dLBw37zbu+G7Hn35rQ2yyzHu37hPG7cVZwmGvO3mD6/nHpwfq3MTG8jPGkevF3oXzNxO+v0Z+iI1pvftTT6OGnKlpkFTX1zkpZLzecNAW5/Smz7XHrqNe+rrgqN0v+Vb1NZ7md1GUplvGiZ4fe8IeG7tyLKsjnmW3EPt0EZZH6isxyZYa5eSuTADXYgQ/P35me8DIe318d8OgqAgqiEGZh1jRlfBcm0Oh41TMacNjZrPaWEaJW7jx5yQsyLFZna/65j7Wkah6FgIB5MYxPOxMKmR8W7jUp8cmaPjWyw13KIW3SiilOPbTivaZMJoBrztUGDOXjXKIZObMmhJSZLzSjSyeHu4MK1Ar/xQ8o7XWj7kSrVly6LjEFYLymq
 ePvMRaez
 wR/PEG2fXr471NZjxNJQwM5H7EmFL3jgiruBvxT2/O4yjEG+QXesT+RPUhYOm9cpQVmGPYkYaxfeb5v75vznNrIE2DA7DoCydR27TwTEhUtC7i+RcWwPc7STDF0XaT+ZXn1VbB5JaiXa7PF57MtAL/XcKARjzQjl5qcD/puYEXGJYiCzfJsAN6niCfcJ3sLFkItKsojzJREDUFwhLxX2BJ6HAwJqLpdYDnHYWT6Pbr2iM6rt3lq06SsLpUcYtGxTRYOvSBhq7j0XL3fUm70LS7Y/31U5I+5O5fR26qXeYLPBRCNd/tEAjKAOBYI3COWaVANUEU/auj24jyv5csITP4VVmsM3vBXm3TYLfccXjcHzyj4UwI604WF2tnnZZGg+aDmsCqaGkYyy7vxd6v6kAHiuIWi0N5QFLub/Ol34aVNsh2t0If9Zleko/7n3jMXEVqvwnYCGWj8qmnCw7TbzmSnT0m/ai1HTkIqQOCGJyVjea0n8Mr4FHIR+W7RvXl3Z7zflbJfDKPVzZ/1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:34:21AM -0700, Yueyang Pan wrote:
> This patch set fixes two issues we saw in production rollout. 
> 
> The first issue is that we saw all zero output of memory allocation 
> profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
> is set and sysctl.vm.mem_profiling=0. In this case, the behaviour 
> should be the same as when CONFIG_MEM_ALLOC_PROFILING is unset, 

Did you mean to say when sysctl.vm.mem_profiling=never?

My understanding is that setting the sysctl=0 Pauses memory allocation
profiling, while 1 Resumes it. When the sysctl=never should be the same
as when the config is unset, but I suspect we might still want the info
when set to 0.

> where show_mem prints nothing about the information. This will make 
> further parse easier as we don't have to differentiate what a all 
> zero line actually means (Does it mean  0 bytes are allocated 
> or simply memory allocation profiling is disabled).
> 
> The second issue is that multiple entities can call show_mem() 
> which messed up the allocation info in dmesg. We saw outputs like this:  
> ```
>     327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
>    48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
>    7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
>     298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
>     250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
>     1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
>     1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
>      651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
>      419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
>      404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
> ```
> The above example is because one kthread invokes show_mem() 
> from __alloc_pages_slowpath while kernel itself calls 
> oom_kill_process()

I'm not familiar with show_mem(). Could you spell out what's wrong with
the output above?

> Yueyang Pan (2):
>   mm/show_mem: No print when not mem_alloc_profiling_enabled()
>   mm/show_mem: Add trylock while printing alloc info
> 
>  mm/show_mem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> -- 
> 2.47.3
> 

