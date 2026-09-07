Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55F6C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08C56B009B; Mon,  7 Sep 2026 10:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8A06B009D; Mon,  7 Sep 2026 10:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAE76B009E; Mon,  7 Sep 2026 10:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 624426B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:57:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC76E160182
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:57:46 +0000 (UTC)
X-FDA: 85187270532.04.9099064
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F98C100007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:57:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n2LaIJ9x;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788793065;
	b=1IpqpVRn52qejCwsLvuJNpoRIMhrl1ThaxQcmo9RaHLDpz1cPL1iR+jM7E591r2sUTykQl
	Y4WQylbPfd3I7Mx29ALUV6+JKu7ndZ7UpRrkY+MVy6oS+OuXaNHdtij0Lf70lf08GDi2ya
	wrIY/w117ixL6ScMwA0EiIA0uEXOikY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n2LaIJ9x;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788793065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKmfltuahHibleolgFqoLkoM/YklChy1LcLNAOhU3Vo=;
	b=Ml0skQNSoqu6szgHBBIn3HoyVjXnVXSrPmI7kl16DE2+Fp5tkfFvYXQBlKbJOihcMq4pQO
	3aG56X5Kgah853oACKFsFQETXRJA4gF0VERknXuMNP8Eg1CfI/E4LuWg6w27n5yggN8kji
	U+BApg95M8ned8HAil4hnCT2yKgI4kk=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9399a1c21c1so146488285a.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 07:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788793064; x=1789397864; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fKmfltuahHibleolgFqoLkoM/YklChy1LcLNAOhU3Vo=;
        b=n2LaIJ9xs/1VipDErMUgz7dDZMPCeSnS5FDpZKc7X9yOurbJmNhCCnPFGJxvhu3/qf
         hBUsrumMCt2xhb3HvFD4SNnoOyWZLOy+4svyJUQOnVCydBe6qodB26x2/PIRfXwp/5Gz
         ILtOVDslNBUhQrIpKVgeoFGQPqEgKkX6FhQk/KqO3x9vtd3Rtefca6j4EvGEAVq0kSBt
         5b0k/F+3Nar32WzvoDwuez6g+QkVIBpuX92r1ga0XPCk18GaVlzHLIlthGMTH7+iC7CW
         VB1q8jfCCOFTqmykFssj1mRzGMjxjcWgVkeQ6GcDifDyYpED+oUZWeZtovwqHO3LVV3b
         ezCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788793064; x=1789397864;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fKmfltuahHibleolgFqoLkoM/YklChy1LcLNAOhU3Vo=;
        b=qkKfjnjoKN2M4l67sBjTgPHl5HcUecUFx2uT6BqNwpwPZ7E6eA0IP2WUcRcAGXbG8h
         BQN5iJ1NyqeTcA0lusjjvhQBrL0UYfi/AR6qdDV4QY12llzxmBVKR4YoRV5Wm9oqlRn5
         ahRS2VKP8EObyogcxgL1J7azKRHN1M+Qn7Q+K/3Kh67GS7wB8l34x5qjbD0ABHx5w/VP
         BAqT5sd83UIY7i9R3whzAdgtGH/zC08mpVKaYDxGvnILNJGHSE9Eiqe8khrJejgbwabr
         iwJAHrWri5SkgRi6KVWWeZOYm6n3G1oe9h70fdXOQMf2m7uTxT7wBd1+ORXjoa9yLx9p
         axqw==
X-Gm-Message-State: AFuF++k5Y3w5+kkIWOPObiDrL7CCxSsPwlIGmD93K8nQX1NsjQ6Rtgkx
	kXok8kZMaRBMxV6+g5tDPu24sUfq2TRGBZNOdC1EE9j+A3sSMxWDsfAp9Jz2KlX/WDU=
X-Gm-Gg: AYBFou11moISOEl15Uqan4H0+XP5lBawiF5sSoGDHYr0EHYKUT/EQEkZRoIJD6cBmMm
	AyO5RxaegZWqObBwSYFLUPft6E5OEUP3S+HXBkT80dTvHm9giW0El0SHbH2j0YoUtCi1RnYbGiq
	jMNvFDgl229eGvjRLC593f/Z2Ads+lezwBnVw2iSt0ng2YD0znRcM4bRomakKDExHZcx+JWmxj5
	adWplpeCOmvX82btw78/+EpSFCT+vOYgYaZsyigLnL7RzctxevRmkqO6A7hB89M7Bud05dxZELQ
	yDUZOGHX7q40iOVA27oAEfTrhQ+uBITzk3eUB9w8b0ltw0GAtnqq4ug3HlCUx3v4Dj1CyDl6YuB
	8BAoHFvZcGYIaZpn9dREDKV4X1YMTVtdyzpIT+KtEVIZ2r1KtGmFdIeezcH/nwI7FMUdE5sXUAK
	UIvRtjB1ZX5tKjGA32ZBQpP00S9X78znUADqTY8u0YDF1Ete5UBtSG8LBVVvn85Ij0h6xLqWzd+
	6TytikyvXAcyQNBcukQRF7I5z1w9O7RGbTCDDOHBvYojOc/OX1ygKs=
X-Received: by 2002:a05:620a:468f:b0:939:6db3:6cad with SMTP id af79cd13be357-9398035a913mr2267757785a.12.1788793064205;
        Mon, 07 Sep 2026 07:57:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb380f8sm905137785a.23.2026.09.07.07.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:57:43 -0700 (PDT)
Date: Mon, 7 Sep 2026 10:57:42 -0400
From: Gregory Price <gourry@gourry.net>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH] selftests/mm: fix size truncation in pagemap_ioctl test
Message-ID: <ap7Qza32A-MzxBU3@gourry-fedora-PF4VCD3F>
References: <20260907135613.68692-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907135613.68692-1-zenghui.yu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: wcz81jskx64oxzu8mc1cxmcjntn3nss6
X-Rspamd-Queue-Id: 2F98C100007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788793065-710435
X-HE-Meta: U2FsdGVkX1+6GyzKs74DorzRqqFuEwxH2zhYPUrjWSxQpBAoY9Y9Vs8bmZG5VhYymQ1QSwfcgFjwEqgZur4TAW8U631WaQ09UJ/x3iBQc9mrvNyGhhaV1xDSqH+ZLCq4iS98mFT7qvaJQBGUiBbL1zbxxUHPxohezSahYenBVVuN0N1VAGi2Uy5Uuo1NcLvg6S09xK57hieeigA4cyELszbHsrcyC+dhtfgBW9CfdhU6YShT95+jIG3lrMreLopE293j0Qs6HSP2ZcRlmQ4JOdD8HQy5guEfHy+80zw6iP4wQ2JS/Qc0ZIzwK8fAXhzEZiahuTRIq3VT0i7c/wsXz3Q9x9oVChBduIeCTGS+A4U5kpFS2iNIZo6nRmx39qLMV7HWUqLzgMZ771I6ugl/pilqQNNy+drfc7lcaK3gUI5qN2gogSO9p+MXu+3qwQp/y6xu+6p1pLz+yt9SrtweIreo/KiKap1ReKJjkma/QCO4OjlUfyM2411m85/ZjVPjaC4PwKFUQV3qc2kaybUko4n/QYjMJJWaIe7GQrulw1uaqMKs7zI37hFfq8tFRODBHQ9x8a+8kJujerfcNPgC4Tz1zHAgUxUPkvUn6lkWId8Dm5K/WpzhRQGsCh5wk2wOZjNsAeHxxEDHTJhdKF5P48r835x1ThvxRBFF5CYQxybxvHaEYeMIhGV5PUTBdMAE36tegsJSs/7q8TYMp+bBMlyiMM11L8Qjr/Akdthn8acE1SMgcLigNgtsyerv6ic+hUZGCmSN6sBoEKTI7Se+5pW451XQCbO4MYNw3QIhO29ibEdk7aG6MgsiPAHl/wCt4x73VH+o8yyldDdMGRgTAwzanvkUuy1QmDFEHE1gU4c6ivUFVnqJD1NLtYhYERWfAOwwGHOyaYkgNulbfgmhmQytk7cQrSkYL5+vgQEteimlkA2RBcFeQQRPYxGhVkXRPNUADeLuaVQcQ4tbROe
 /+FHnQle
 u/JkPbInCsG2MTvLQiPR1HmSiprnXOm3fGSXft9Z0vRI8YEjqKpZ0qT9saA8r04AwriJ75HKky+jXgyjvOL3KdzGUWdYhjt+yiZt9/vqpKO5j+X4UHgkoLOF0OBZQHh+UeZjJW0fLZFCKt1bKJaeE90ws1VJzYfYAAAl2pYQYm92Ly1dg4SoZ/clIhsIscJ8E3cxZAdYoYJfTeXKKmGhzKBBei9IZTc/rCnr56Rl0QuaRzWZwRBB5srle580GyNok+2j8VINepJqm9hIHy2YF8CumVNLZ/YQnRYSx4cx5VtjQ+9sxUwBK2R3CKRApYyQKgBUG6fEw6zkYua9IS24+A/q/97PgTrRSANSAqEWs7y8wyPIri7MkZMU0Yjb7qKUVvfuJ87a3cTFTv9RwLJIz5dOlMvv4P46CGQ1SOW2svtsbIVTQDkrAvggyVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 09:56:13PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> On arm64 with 64K base pages, the huge page size is 512 MiB, and
> hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
> exceeds the range of the int size parameters of gethugepage(),
> wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
> makes gethugepage() allocate a too small buffer, while the callers keep
> operating on the original 5 GiB range, resulting in spurious failures or
> SIGSEGV.
> 
> Change those size parameters to size_t.
> 
> Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
> Assisted-by: GLM-5.3 OpenCode
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index eadc7159ca5b..48cbea3a33c9 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -44,7 +44,7 @@ const char *progname;
>  
>  #define LEN(region)	((region.end - region.start)/page_size)
>  
> -static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag,
> +static long pagemap_ioctl(void *start, size_t len, void *vec, int vec_len, int flag,
>  			  int max_pages, long required_mask, long anyof_mask, long excluded_mask,
>  			  long return_mask)
>  {
> @@ -152,7 +152,7 @@ int wp_free(void *addr, long size)
>  	return 0;
>  }
>  
> -int wp_addr_range(void *addr, int size)
> +int wp_addr_range(void *addr, size_t size)
>  {
>  	if (pagemap_ioctl(addr, size, NULL, 0,
>  			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
> @@ -787,7 +787,7 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
>  	return 0;
>  }
>  
> -void *gethugepage(int map_size)
> +void *gethugepage(size_t map_size)
>  {
>  	int ret;
>  	char *map;
> -- 
> 2.53.0
> 

