Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DF4CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3766B0010; Tue, 25 Nov 2025 03:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D0A6B0011; Tue, 25 Nov 2025 03:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D607C6B0012; Tue, 25 Nov 2025 03:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCEF26B0010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:44:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 667E08A3D0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:44:26 +0000 (UTC)
X-FDA: 84148492932.21.92EA75A
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72CBD14000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:44:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YpXFKsKP;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764060264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpZDRvAPn9u/AtsSK5qeLHqpt9GSFf5AtPp3g42dBA0=;
	b=z9c/ibZeXGaN9/BgSQ8t49nvBaxmtO424MV71vxR/Fi7gnN9o9nRGMde7crwTq3YjcXpQK
	fY1jz32FUfS8+8kcKJ2DrtSwS/qhvEkHgzvtUOwbB6h3g9t809S/2dyZ2Iic2Nj1vuKUdY
	cK1DnMys0/ISvwo5hZizQhTgOCYaYCI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YpXFKsKP;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764060264; a=rsa-sha256;
	cv=none;
	b=WqXb1gLiXVM1KEs0dy2uaXCNG7IpEnvqvAal/Wds6/3PKM50aEGK7fJBcAvWyEd8xtUchR
	Nf2uc+P8pfByspUU/8FgArUlyjaOljRwPqhvxv/DBWcGnR+5mFXWNH76BA7KmCgJYAAMhH
	lf11yN7h4gePW5xhuiKD4QYRjiMyLWg=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so3225849f8f.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764060263; x=1764665063; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CpZDRvAPn9u/AtsSK5qeLHqpt9GSFf5AtPp3g42dBA0=;
        b=YpXFKsKP5LYOkm0V7IO9uSGRKV49GEJLTSEZZbZdg4LQq8TXCDWH0Sjk9vUe9nVfKB
         YFvTxovLPKJsa8rxnEUEt+47urf6tPgZB/FejpS1BV+8si3CwPDWMMKWpz0MlsDXj2y4
         UJHgFFbJ/zOOcDDgpS3+TMAmt6vIzb4e+jHCAE0LbKIpYQmSAUDj+HGUkbqJLYWlC6nC
         ur0iVRz2TAN4iQJw3BKtIirKZImez37HvYmepZwHADud19THsSNl9C5FDln2B/uptnYO
         06ipdfZG5BDtkUs+dCXBsiek3V/B5Gqt4kklUsGyLdEzIKMrtlUhQElpi7U2z4MJFkWJ
         fbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764060263; x=1764665063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CpZDRvAPn9u/AtsSK5qeLHqpt9GSFf5AtPp3g42dBA0=;
        b=g/OODTeupO+9CqCAp0lptOTQHnivs8Ez/L1EgziCubZzz6QdnqYP+aFnW9T9/clbo5
         qtLSVEGFLYWFo4IMf4j0xAiZ4wGgNn6QObTsXpyDVWBe41gTwzBXGVnxrt7v6llM8YTT
         t5hU8hSbdsMG2UmOTKjYfisqqv+vxr5dQCbFBlMQc3Mxmi13vP7974uqyRJKqxCEvhco
         DHrwGhr7L/8SftXOSPv7WdbkwRFm/0nStLtJ+zdRj0kaCMB6q7KSPXtvHpxH7TNHsMV8
         RqYQSLu0TzWnKzrx9ZWAf25k6dD2HnoHHTG9qqwG7sYjxUGe23sG7ErI321n1+B6hv5w
         xGjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyoUxOxF0FpY8qTRRFv1lNLhqBgZequKEFMQEVDQ58tDkZfKuJTbbY2gC7Zm9O84m2LgpwMQd9YQ==@kvack.org
X-Gm-Message-State: AOJu0YxXgx6HogSEvgrOmG+xwAEnvfuuF8+VhMhG9TDzcf26YnqW6AtW
	TODNKdUcj9l+mGQUwNYZycc1PnvO/+j+lfGrOHn8GR3IXAZsZWUrSsWaM9wtP8741NE=
X-Gm-Gg: ASbGncuFao+aP95LrhEXqSYnLodWg9pd4nEmsGI9P0Tp/q66LqGCAT8FgV1ph2IUavQ
	mYb5Rk7gJDH/zW25GXVDUV6ocLYKPOw/g0MwFeFMhVFB0zh3TYXd4ylUsubKWcYd1FKSHiy8E4n
	XabmJIP1sdRE0WOndYvIPwI+LJ3PqjOmULdjrgCWZfpPzypjoV9K4mZlgqecRMLRbWwXm5/qgmV
	XIRYznzQd197ZLvRThO2R/I6x4P0rga6ymmt0WH6M7RBN/BW2DqK16LwKONutsXNrCqvf2bnn/6
	Twn0lUA7pJHtVkoOjyU7AqXmuyybfe8BLKyfig81d6l+afjr3OiIx2KMh9CCNfoV4ZhxHkuupW3
	hrJC40sRcnUwP0j+w/fboYj1L5qWx4L7tjydYYim1wm0bmiHHCfZVM6vz6OPDkwEUC9Fu9Oe7A1
	iLgbpCXmIcixo7+9yk0fH5epSx97KCQWk1we0=
X-Google-Smtp-Source: AGHT+IGrfzbQdwa3uuXjiaNeFV9Dw3QhirPceLI13Twim5XwJ+yUCFDBMt+GpCy2FfrTz80TdBlq2g==
X-Received: by 2002:a05:6000:2507:b0:429:c711:229a with SMTP id ffacd0b85a97d-42e0f3626f0mr1935196f8f.56.1764060262771;
        Tue, 25 Nov 2025 00:44:22 -0800 (PST)
Received: from localhost (109-81-29-251.rct.o2.cz. [109.81.29.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e454sm32839188f8f.2.2025.11.25.00.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 00:44:22 -0800 (PST)
Date: Tue, 25 Nov 2025 09:44:18 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/mm_init: Introduce a boot parameter for
 check_pages
Message-ID: <aSVsYvQUm_xnoRxC@tiehlicka>
References: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72CBD14000A
X-Stat-Signature: 4f5um9gn5gn5k8b3uu5moajbehodjso8
X-Rspam-User: 
X-HE-Tag: 1764060264-324641
X-HE-Meta: U2FsdGVkX19FRykJxyZm9bdKv3Z9qceUm5MZ1p9J+GG3LnLQCFpCH5RbEL4rYqskm0qPunKrqYKH55s1HBcsxWKlKfGm2k9GqOKdWfqmTKcwek8lCkSZ0jpb7pfNDFNF60k9kaFV/x/+FkCKRQmsmBzPj1ryGV9HocQIqyt/DW1xvbgXfTpCaP0w17Q+ttPTmYql6srMapxKyJb/IfxanbCPhkxfcRM8/mF0t2xO6CWh2QvEfywGC1LjfjdheNQj8C0GUc9PxBHOp0ogjaAoABsanFjO2lcoB6s5RJnZIBtCveGruopqHIyZlHApzAgj9NJa1WdwCTpnPxK2pSEQ2Y6LQj0W7ezUdCGW1ifayd38Y+/1Yir6bbQBwsiT0h+ok37wcU0yVCp6vonupt38wSD3wLwL1fqtcnEtcT3zKzHS3mtBgo2dSpwp98VRD64tgGKMtsrP6cLIzkhhm9ut37WjrFxEkzC1gHdwAe2cGtLgH2I5Kl2pw4Gx0CPiNlqfjrzjFGiY7pTikxypxrIFManNb9upF7ZWmGVe/d5Ar9ENSgm2QRxn1oTns95ZJxZ+2eoVrcMAFa3WYMai9rV1uXJC6b13jmJ4+fQTpwaEQLunwTuKdTqAbC99TctDrK97BoHws8za2LoWydEUydaeqtlAnLhRYyZvdvYM3WsP8D1HHMOeJx6D3mKkHQtfJwQOJIqet3YfKYflPQ/mPyb/sFAscjpO18YeyRtRTu6IrA5ZWbGHUVTCo8QRlBIwpOepAH7Ppvk+c48C4U193ZkWkIztJJ4ONKE/yYg/TMbUA0jDj2bH9pZvjE1gb0/rQ2DFdKbb+zV4ASwYZa2grj+uPgq6B+5guo/AEzk8FQFT/o/ephG6vDV7KoaXG4TQbeonIHqFZBisiqoMkoygerWX+ePfqpct8XPdRvE35WkH/6CeruobfIW41NCSVBMQXVVZAC+XCuEpe92DctPOb78
 j6oBTI59
 pjBH3Z6bdV6XfNcA8Szgz0wdLxkPzncVEciRU+kHcH5W5ZBa/qa0xgPWueOyGKlaxc299thIse4zjlkg4tErurEJIiId+o+XJd+czzSvLUZW88nS5T62x0lBS7INnDDMX2LDGs1O37kMh80TO5Uio17ycx4OwHvFfvaOJ/zgB6QW0Dlk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 24-11-25 14:54:06, Joshua Hahn wrote:
> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitive production environments.
> 
> Introduce a new boot parameter "check_pages", which enables page checking
> with no other side effects. It takes kstrbool-able inputs as an argument
> (i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
> setting CONFIG_DEBUG_VM still enables page checking.

Arguing with performance without any performance numbers is not really
convincing but the change makes some sense to me even without that.
DEBUG_VM is just everything-in-one-bag thing which is not suitable for
production use and bad_page checks might still be valuable for such a
use.

> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> v1 --> v2:
> - Changed check_pages from a build config into a boot config, as suggested
>   by Vlastimil.
> - Introduced the second patch, which decouples page checking from 
>   init_on_page_alloc and init_on_page_free.
> ---
> 
>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
>  mm/mm_init.c                                    | 11 ++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..0ba9561440a7 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -669,6 +669,14 @@
>  			nokmem -- Disable kernel memory accounting.
>  			nobpf -- Disable BPF memory accounting.
>  
> +	check_pages=	[MM,EARLY] Enable sanity checking of pages after
> +			allocations / before freeing. This adds checks to catch
> +			double-frees, use-after-frees, and other sources of
> +			page corruption by inspecting page internals (flags,
> +			mapcount/refcount, memcg_data, etc.).
> +			Format: { "0" | "1" }
> +			Default: 0 (1 if CONFIG_DEBUG_VM is set)
> +
>  	checkreqprot=	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
>  			See security/selinux/Kconfig help text.
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index c6812b4dbb2e..01d46efc42b4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
>  
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  
> +static bool _check_pages_enabled_early __initdata;
> +
> +static int __init early_check_pages(char *buf)
> +{
> +	return kstrtobool(buf, &_check_pages_enabled_early);
> +}
> +early_param("check_pages", early_check_pages);
> +
>  /*
>   * Enable static keys related to various memory debugging and hardening options.
>   * Some override others, and depend on early params that are evaluated in the
> @@ -2591,7 +2599,8 @@ static void __init mem_debugging_and_hardening_init(void)
>  	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
>  	 * enabled already.
>  	 */
> -	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM) && (_check_pages_enabled_early ||
> +					     want_check_pages))
>  		static_branch_enable(&check_pages_enabled);
>  }
>  
> -- 
> 2.47.3

-- 
Michal Hocko
SUSE Labs

