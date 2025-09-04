Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383CACA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B04A8E000B; Thu,  4 Sep 2025 02:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760E08E0002; Thu,  4 Sep 2025 02:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650328E000B; Thu,  4 Sep 2025 02:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 516408E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:44:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 108F6140A52
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:44:14 +0000 (UTC)
X-FDA: 83850628428.14.0A3CAA2
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A3E840003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:44:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fN13jIZk;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHqCMfo2LMLyGJcWsRGUvqsDIGVMcCFXVZ3lBJ2U6h0=;
	b=HCUf2/odBZ7k++BOrlHlKA4sfCZc64Varq6fhzNKvTbn4C+09EFQ8osZAu0/MuK1iMf+2Y
	FpYAbuIUedFNxUQiDRnEEnDkwV8vPRSrHGpyhUkTyca1VzZEnjt08H9PUR7TEAKYVky0XY
	+lFynfBulvS/ympqy2sa2+HgS7dYRJ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fN13jIZk;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968252; a=rsa-sha256;
	cv=none;
	b=PfIgX1CNXCUcxJc7zS/pL79TrSZ06fTEsqR9PVnlsPqUkP2bNc3oVaX2zf9CDBu9yoD2nL
	XQyFo7r3nZDPP8fDEVVDqej3zVUlvT90PxCLe/kAiRu88e3VQqXtIWhWRJSZaBE5uPwOtw
	G63Zx174NA++C/27Za4navL1I3mTwMA=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77246079bc9so817761b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756968251; x=1757573051; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHqCMfo2LMLyGJcWsRGUvqsDIGVMcCFXVZ3lBJ2U6h0=;
        b=fN13jIZkl5jQfuMHcRo4QzMkypeZRCGAhXCzb3qbPUyAM+L/Q+lR11aVkK1S5Ua80t
         RJSyWcQlBBljs78aPwlk2k9ydfWFeU0qJ1F0hjx/oqpOn0vghAUfIwwmZbIioOZXh8FE
         jj6RHqLw/zTm4xizB8E96WHhSeHkz6fVX2NPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968251; x=1757573051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHqCMfo2LMLyGJcWsRGUvqsDIGVMcCFXVZ3lBJ2U6h0=;
        b=ajWDibb7ymrYPpTgSXSGje1YEKd6isJSsVw1qB+qID0cBymbdneIVkEq9Bo+Kcm2Xn
         /GgbqrQvfhqOoWAEPqf0zUWX61p8Sl33QKJf2WVTOCEOVBqryFw0C+sOYYbKRR1USapa
         ezJdMovhp+e68Ji8hQm0w/PJ5LECK9TNeaASRcTNlmCtoeyhdy9de0SyeddfplPu4U4b
         OUWa3kaQPRjKWT+0RUi4FVozC7tn8qQq6+rXfkENMUWy9oP5zld/WGRgM6zU+UvMGkna
         0SRPXP/h5WtmxH99zDWBVorptlr8u7P41XGOXaRAueiE4Kdf5r1HGpD/+0V/Hp4ZODg8
         04nw==
X-Forwarded-Encrypted: i=1; AJvYcCV5xs5OsA2lCIiGaQxkWWP+8xxIuf4DCEdchcjMN9dTLVzqE8HwwOKjk1jItlr412a9TzrTnYYhxg==@kvack.org
X-Gm-Message-State: AOJu0YxocFZZJLWnzaL0ooQv3CbcQjTZCwzHt1NthZXWHvocAVtlOBcp
	ihKZfL4bU5TobVsADe0XHqMHvMv7aTSvsG6YkvN0jm7pMbiQHWLLJtAbvhVHFhQDgg==
X-Gm-Gg: ASbGnctpAm0a2gIhBEJXbNQTFLfqOe4OqoIgOYVoyNq0MbwNRMMOB+NrOYsCTfr/8qZ
	qelShYstWbwfUtuLtTvJbz20Js2oojpdSzeetc/pj69KsE9E6KN3QMaevdN+To/pdM95RvBzSJB
	VgNFrjF2E3UeOnovvNIEa9mavzc09GtjVPPaaAv/rogUfKWAqazkfIZ0OWLzJSgMmE2BkeWWkK+
	hfrvVNJ8bilGmluvqKhUlXrwZ6c75lPtivCCINbXoLe3XquNkWr1GfXAsS+ffktNF18c14vTXge
	BYLtxdLhJ5M/MoNg4uysCRr5gjUANOpOHluDSvUdqM35O+u1ZOeCuwZkiV7zjvQu7tEPEYmopPg
	J69rPpuIGGqKzW99Yac1eKFWQq8vnECSXfNLf
X-Google-Smtp-Source: AGHT+IH+YV2qOYaN4nAmRg/9LL/OyAH/fMjV4M0D/ewSy12gz6JAK3OGJf1jiWaSOYJGAgUKWxuE0A==
X-Received: by 2002:a05:6a00:b4e:b0:772:6f95:f326 with SMTP id d2e1a72fcca58-7726f95f5d9mr10062470b3a.10.1756968250799;
        Wed, 03 Sep 2025 23:44:10 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:d677:a82d:7e38:6189])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-772818bd5e1sm3767728b3a.86.2025.09.03.23.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:44:10 -0700 (PDT)
Date: Thu, 4 Sep 2025 15:44:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SeongJae Park <sj@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in
 show_free_areas
Message-ID: <paef7bzotb4runl4sjlcfesano36cc2bflb7uqe5mil3chnpgn@axng3yfe33w6>
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1A3E840003
X-Stat-Signature: ts3haihe9i6z9m8wi9reuspgwwamp17r
X-Rspam-User: 
X-HE-Tag: 1756968251-502741
X-HE-Meta: U2FsdGVkX1+QqXe4RXWW/KQwJ11IHyJ3/JIswoqQ0yZnCJqOjfZXUp/tcfWVqy/ouFVKF7x+sUiisAVUQGpn8dLNA8N68ocIi5t/WtAnmugeVHWfoG9L6hanWjDGd4jcp924zr0j4kg+28LOG8YTgR9sLDxzjnBNka7N2ZYenNomyrgppv9bmROcs5k9xDDZp6Tdl7zh79PJkoHvjoc5BVsOwWz+CIPDFh1YOBBsQKwzqDfN3/G5Kf4EqMs6HWQVhs3Mws+eXjENZpuS/j1BR1LDpfvmzS3f+bHJVr3Tt7AK2rgk31WjR6ock6ztQWTCYLCLkOJo54BjvcNq2GDp/1zw3o27fRh2+Gec9oWyyYUheMP0EHH2ESSqbn4JYI2KKd5Yh4iIisbSOpw+UbPhlkF/EFkjQmh6heiqlQDGsm9gH9Jy8/8/Q8hTDNoO0JdRJxMsSkWG8IjYEiGVjCN3BBeZb86QNxHcLSoc4zQmu5qzzQN9QLMGNFqlv+jHeKZhOLKv6QZl84sEks7/oKzCS1+Wwewxvfo4swbv6vBUjSWG1wrr7Rbzui9G4FmXg0KmTY4Rb8Rz6UeOeHle3GrALDdcAIQTruH/UbAQ6m1VoHGiw/bB8ppZALFhVXWCwZjAPtZenGNDmdMVPbMnKji7of0XqGmh7khwoloXsEm5mGvXDTrT2paRnqXtuOk8mmE+p/JS/508PpibNIZCtDL52pnFQQhHUJs/7y+6OdOQfyMRo9LkKv3bsc/CFADqj6FJ73txJn3mhdccsoipFmvqWNPv2Q5qj1J8rgJRc/Mx615vea2tphy09hM07KllR+UnRbd+le7dnr5piFMofodXtMleHxfOHnBOG7+mdgubhtWYp3XPL2AtttTjMAQz0YR5z8MFEPT8PhJi5ykhRWsPgTQ1c1sUVt0/xinaKe9ieFx1ynBBOq31mM0WQn/bz8Z8nQa6W+UHeriIvX473iy
 54M3z/Y/
 rJIEcI5Yl/wdLew8DzPXYUdCqxjCQYOvten70ErLOhWIfRuRDKDDXKBOxljNeFMgs90TD1aLkCHHiptX/jQICaoyLLTZW0/WpDCNGfPzM/J4DLO77OVQzhZOill0KJprNM2DD63jpw+iwwTEPIFvV9eud3PZjxu3x55lwQ5jnV8m8Kb0Ph9IGMtiHVaR5IYWb2fZ2wRMMz/+dZMoEnX89Oo8jVlEZmncsTWx8RZ7sDohzO2DEeAuNj25tDHTLtOgaPa2YwghgOAHqTbn/WB4xYzPcHBAlGVYVmiEs4dS1Ms3XwuUiaqmGLdm8Fn6nHwHy9DsMkvYNbOLsQePjLdAMu6nWgfWi5NLSj0T6vVhhxNYn6j009hqV9tfNFueedojGOGIjiKnbtzNKCBbsuI6f6hk0NKbn6Xhn/w/RrmNjdkIY9MJL8M9YNYQCsdM6CAY6ug5+vTaH+mlH2VaLUJiUtKkrUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/09/02 09:49), Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
> v2:
> - fix build when CONFIG_ZSMALLOC is not enabled
> ---
>  mm/show_mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1f68d824b03eaea8 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" writepending:%lukB"
> +			" zspages:%lukB"
>  			" present:%lukB"
>  			" managed:%lukB"
>  			" mlocked:%lukB"

A little "preliminary optimization" idea: do we want to specifically
refer to it as "zspages" or do we want a more generic term, just in
case if zsmalloc goes away, or if there is (are) another allocator(s)
for compressed swaps?

