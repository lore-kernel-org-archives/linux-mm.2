Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0973E93808
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C126B0089; Sun, 12 Apr 2026 20:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDFA6B008A; Sun, 12 Apr 2026 20:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FAF6B0092; Sun, 12 Apr 2026 20:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0C3B6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:42:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92120160BD0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:42:17 +0000 (UTC)
X-FDA: 84651681114.25.5F71E56
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 85DB940002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:42:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IvK75gKt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776040935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxGNfAurSL/sSsMEGWs0KQ6peS7hOj4Kb/lUt834dAg=;
	b=eizYg4D6mgDsqRutSaUAawJPl93kSlXSrPknU3QUfbcV7/C84OF/mN3WVzKpYodm02Scu6
	2rh/y5XxjFlQ6o+gx/kD3mBlLy6X6FnM6AfJZlBHemHOm4sF8F9+dbT8ufPa8BKQsL8bnw
	3S/XEhhj99UA0KidQz1UGSZVswZFaE4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776040935; a=rsa-sha256;
	cv=pass;
	b=rSetntjZ+ljc/2BB6di6rUouNoV4MJwmZ8Dsot/nZlKQUo7QhIZUQRMc9ExRXz5HlXcJZS
	6lvuLFiti85NLu1ZzrdZMrzN0PVxIGPLdYfN0zIQiaG7t5DXdkirCsD7yTUy45EYwhV/g7
	BYONuP98MEnSP255iUcyvXwPzadNmWU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IvK75gKt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48374014a77so54083685e9.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:42:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776040934; cv=none;
        d=google.com; s=arc-20240605;
        b=Hztr23KZXsIOony/+tlROVE7HfN15uH8ocAz3Fw5Pw1pLAO5HZ6z4T1lBU+X0THwvV
         gCe8ArgdIRdgq/j9n8T07LA0YqrzOaOmpqvsniQTRL6F7Ku3FCzoHHYZfQW0xzivdN9C
         C8+7zuvJSVQdh60ajM3pQc+I7hs4Z+A+a5KNOMrpo0+xrXQ+tA4e7kdAVL9rovrIC900
         YgUlVCaTyhpAGuZ0B7HdGLxz7DXrBh9nyRRdGWuXuakPEGwrFSU20vAbKCOr1BS92Gb/
         xl16H/Fk+Vxm8/62XWTuMPxeAwVnqRUB0UWGnvVRmSqvLhR3ZV2/vRSbRRyoaeOnM0yC
         5aRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kxGNfAurSL/sSsMEGWs0KQ6peS7hOj4Kb/lUt834dAg=;
        fh=iurRgqC+jGbVeyeFqaEvMq3apnghkxQFyU3DxMaVfNU=;
        b=fO9cvm26C4xynoyisT3vnGxjzprwtPLdVkgqk4i7cUhjgwPqohXvmGnAs3AbQ2pfDB
         OWMUzP4NEAJ6XIPjt/Z4LbsfcNnVe0fW91Kwi2F3YOVrHoYtt2PHKJiLYvlgeQzMef5/
         CbRGuzpC1EA7CZqc7z1rKFJdPOeuQJ0tlh1g5aQOdtbbtmt0jFgcrjNhynEN/4kdFhK6
         ekq58qb8na9gFgwoe+LZ88TwwXv4VgmponJcro7z312cfL68iqAN+AcBE0BizvGzxIas
         hZSMERKrm2pLxdKZmG1X7IWuU8o7E9wh3/lss6MUa/ZMrcNbQ9/gyroti+NHGGj1pBuc
         WDCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776040934; x=1776645734; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kxGNfAurSL/sSsMEGWs0KQ6peS7hOj4Kb/lUt834dAg=;
        b=IvK75gKtyL6dF0lK8x8lksnqWfQxl90mFXsguHAK2+tX12VjeoGVq023/K4Dnk6Tpi
         7Q6yhMti0nGs7NYrTEO/DOdVxT0YBD2lELBJLgcq6rixxUFwu7dJ9bTd6gtujNjaTAYz
         u7y+Qz5fAavaS4y3LWaDz0XhbZS/ThggCPXG29b9jcdw1I77VgFBIdoV1hee17o77v0+
         T0+n1VvYFvM+NS6NwWlXeNVrrgbpMRGgf1nhrLwiGtsS4pkWaV+oPJxf2N5yvIk9ye1f
         2qk8F4/XVzKv7Ewy34jluikOfo7CAVPTeD2sEhZu5u+IQXG68Cy05RsblOqZ4QDGYiLj
         bPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776040934; x=1776645734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kxGNfAurSL/sSsMEGWs0KQ6peS7hOj4Kb/lUt834dAg=;
        b=WsKdNqlLl7vowWkt6au+SrbLkXaS1MTsG9YkO5ZhLM91c/3pN7Oee40rPWvuzw5Tfr
         D3Ucx97bhah2UtYBfu4jNmghhAbozBFmFPw1Rjzo7zOBRu98lQcv9dTL8WL7WmSA8vBh
         /mstv/7quWF9/WZ78oX7Omcx6T6zv702x8QG6UbidWJtqeGMyNA8NWeOKGvE5Y6IIL9Q
         qN4fU+aYTzrJDH0seWZKU6MmIlHO2dD5n/sU10uxqLJTJdA7q6ustt1WTW81BkEtWt7u
         WY7bs5gAyL/EjwGJvbola160rNY2fWP3HTvcxa6+jMzHWKLiEuRNAbKomXRFgOQU0yaZ
         ZJqA==
X-Forwarded-Encrypted: i=1; AFNElJ/4cVE/w6dKDWKOUPYL67/XsusHKcqBJnvDICj+ym87xnR96CqNgSOXa5lfDlgiBhp3tCskvrrqhw==@kvack.org
X-Gm-Message-State: AOJu0YxLyQNhl+fQ8Rxp9tulzg+2N58jLQZnSPbnH2dRHbsCbLG4Q91G
	eKcE1B0V5WKLgHX343A4ipiZCSHqgFXstk3bj4AcGDtJ1ZRIiIJB/9SxWdjXhYedBfQ1AUMnyAW
	4+OOHwYAjs88ITPavs8Lx3L6RDBIlQqY=
X-Gm-Gg: AeBDieuPrhSZ9FUl4h7beMmSQHb44Ck9f7Oh4HZRuDAFeeTlgLZkLgkGzYBBYhFRHoj
	lKKha2N9riwQFIa2lc3KMmy5MA8zCjhqWsgp75ncjj6vsdDgHi2xiZrflCTZCtTfgX9bqL6otKI
	GvLVvhzHQqY98jjGQeMyfI5OdpgyIaJCKCwzHi2yI147xvlOU8Xu3cUdtWj8yWaFqGUuB7PGw/l
	C7t56yprcaTED+Sylb2yFZS3ETNRo6AwLusPUuD4Ghv1h25V9n4veY0MHnlyiBpfYFGutB6dBjx
	GWOTQANh5L8vOkoRls5k09m38xFtC0W8Thg/OQ==
X-Received: by 2002:a05:6000:24c3:b0:43d:77a8:3bb6 with SMTP id
 ffacd0b85a97d-43d77a83df5mr2970666f8f.47.1776040933910; Sun, 12 Apr 2026
 17:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com> <20260331183351.29844-3-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20260331183351.29844-3-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Apr 2026 17:42:02 -0700
X-Gm-Features: AQROBzBMynnakVy6f45iNnE7WboHbK8mODIpfoiGsrP8gSEo51s15FVEx_L1z9A
Message-ID: <CAKEwX=PMbbuMeo9Ppk=cW_hAthZ-cf0rMjALsETpDZzDj6oYJQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85DB940002
X-Stat-Signature: y5m1pgnootf3od73ytaseecfmknrh8im
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776040935-279480
X-HE-Meta: U2FsdGVkX18u+Kx5+71o/8gobDM258jrWT1Jil2L80w0WgKMU4Wgl5gMeiLtULZUbC7gcv2ZZ17cKD7maSGKtpdxorNyAMF5tmDO07B3Hz71h5FixJOs36V6JTYHzHQroWUTYggYT2h3MpYIbeOffmWPxCuZxAAZGCrfHBm7as5qzungP+lAyNhjSP7hhDTT8DY7ood5AUUZWh9nvlKWrDEMV6v8B5lCUd67hDf8gDhzNyRJWRElJrQHaqikAH7/O7Gf8VGpaTrDu7Hnt09/0R5/CvT20I8jz298Lg075owTTpg4zeoaFABEpuHKjpQRglCG2TlQEBQ0E31eCDq4qVwEpERtd6a0bbmKaVwUuSHhARf5erOJzpzipbDhZEjFKk8pnsj/G9o9cFeO7Q4hPCquDK0p9bsy6kDK8zSPDieQCR67x/hiIW/UIlWgXRCKyUdQGy/ddianv4hGdmxYMcNElvBsewGxrwnPztEhn7D5MKkJk8Xh7CW8WgExiozwbPJwSvfvqaYX5qwg4NPYi5v9RZSVt565itQgNhzOEjE+6kpteK3wUD44i7yry4ZtkMAEHf9WqaBBDH9xYFVk/Hk2CaTZONzlBAdprpLRlN4i3YevG83qi8JwpwnS2z8JYtKXA6PHjgn8PnwvT/7BUkgzkfolBGrbRWtMO2fb0QtvurG12Qy3DkMWdN+9wuq+CNrIpBV5V2694pBzkyPDsoW22/Zgnp1CsA0A4OsEzpQgvbAkq51heerPkZeTu6ftSx02lck7eJeGMGFORW74nC0ytxgKOqwJywIcKJiEPI7qOn4KR7V2Ssytw4sg0JTRDa1tGUj5j9BcJbIM5PjSiNfDdmCjAXVFAvq703Wy21h8aJKvK0QpvAH2GCsiBGI0omF4hANvLNr/QK1XtzUKBkO+K8Y6//S8ygWdE5+t2fet8aMmPb61yxiz7DtIReXz78FKLhYUro2ttLUXuAg
 YxioZubD
 9FzISdeX4zWMPqEop9LY6jkFEKssLsd6mMMherWgjM0CKkYgZp6xdNVMOBX8SdQ6Y8Cr1RlhmwmVU0L+bOBc8Y/IILbqCGa29gouxBdjp2zwffa70PLXUr/bNvkqQQCAhbSIe0NuQSzEzgiem5IM9uBXtXZMVTNi/tIPM1S0cIb5uqIshV3dh4mawQJ2Mbigy4i/DuyRwrhNjnzNbeeYJvSknUeaozjCmtv2KWVEMhuedbw8gd3BZ5RcdSPIZiXIdKTp6orzrF6CqC+C86mypCtqoTIQgA8FH+nM4GVjppWR6xb3wfB6uW2msNgmD1okmWl/Ru5B0keloodfy7ea32sEtD72C+yZkvfexYDNjsuLVc+UrqIyxaSlp134n1PZMBeDlMhagL2S3ks4Olha5pbk+H/C32+tQYpUjI8E9wmpE7F/+gzwLHp8CX5kQ2ia3PHSuslSiAwRNkq1jg1HKo4wZjVglrU2twOSOKysFUZw7o3UTnPjMC1cTJvFAFYs9bF6PUx3kuQkiqv/oX3XiiQsMpk6ZrvGMz2UNd6Fn5LhPpRFuIkGhQHzKlJz6uvybjduH1WMcFMKivTVX3dsZzVKJ8WuHDnzhd5VY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:34=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> hotplug, and destroyed on pool destruction or CPU hotunplug. This
> complicates the lifetime management to save memory while a CPU is
> offlined, which is not very common.
>
> Simplify lifetime management by allocating per-CPU acomp_ctx once on
> pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> allocated until the pool is destroyed.
>
> Refactor cleanup code from zswap_cpu_comp_dead() into
> acomp_ctx_free() to be used elsewhere.
>
> The main benefit of using the CPU hotplug multi state instance startup
> callback to allocate the acomp_ctx resources is that it prevents the
> cores from being offlined until the multi state instance addition call
> returns.
>
>   From Documentation/core-api/cpu_hotplug.rst:
>
>     "The node list add/remove operations and the callback invocations are
>      serialized against CPU hotplug operations."
>
> Furthermore, zswap_[de]compress() cannot contend with
> zswap_cpu_comp_prepare() because:
>
>   - During pool creation/deletion, the pool is not in the zswap_pools
>     list.
>
>   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
>     out. zswap_cpu_comp_prepare() will be run on a control CPU,
>     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
>     cpuhp_state".
>
>   In both these cases, any recursions into zswap reclaim from
>   zswap_cpu_comp_prepare() will be handled by the old pool.
>
> The above two observations enable the following simplifications:
>
>  1) zswap_cpu_comp_prepare():
>
>     a) acomp_ctx mutex locking:
>
>        If the process gets migrated while zswap_cpu_comp_prepare() is
>        running, it will complete on the new CPU. In case of failures, we
>        pass the acomp_ctx pointer obtained at the start of
>        zswap_cpu_comp_prepare() to acomp_ctx_free(), which again, can
>        only undergo migration. There appear to be no contention
>        scenarios that might cause inconsistent values of acomp_ctx's
>        members. Hence, it seems there is no need for
>        mutex_lock(&acomp_ctx->mutex) in zswap_cpu_comp_prepare().
>
>     b) acomp_ctx mutex initialization:
>
>        Since the pool is not yet on zswap_pools list, we don't need to
>        initialize the per-CPU acomp_ctx mutex in
>        zswap_pool_create(). This has been restored to occur in
>        zswap_cpu_comp_prepare().
>
>     c) Subsequent CPU offline-online transitions:
>
>        zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
>        valid. If so, it returns success. This should handle any CPU
>        hotplug online-offline transitions after pool creation is done.
>
>  2) CPU offline vis-a-vis zswap ops:
>
>     Let's suppose the process is migrated to another CPU before the
>     current CPU is dysfunctional. If zswap_[de]compress() holds the
>     acomp_ctx->mutex lock of the offlined CPU, that mutex will be
>     released once it completes on the new CPU. Since there is no
>     teardown callback, there is no possibility of UAF.
>
>  3) Pool creation/deletion and process migration to another CPU:
>
>     During pool creation/deletion, the pool is not in the zswap_pools
>     list. Hence it cannot contend with zswap ops on that CPU. However,
>     the process can get migrated.
>
>     a) Pool creation --> zswap_cpu_comp_prepare()
>                                 --> process migrated:
>                                     * Old CPU offline: no-op.
>                                     * zswap_cpu_comp_prepare() continues
>                                       to run on the new CPU to finish
>                                       allocating acomp_ctx resources for
>                                       the offlined CPU.
>
>     b) Pool deletion --> acomp_ctx_free()
>                                 --> process migrated:
>                                     * Old CPU offline: no-op.
>                                     * acomp_ctx_free() continues
>                                       to run on the new CPU to finish
>                                       de-allocating acomp_ctx resources
>                                       for the offlined CPU.
>
>  4) Pool deletion vis-a-vis CPU onlining:
>
>     The call to cpuhp_state_remove_instance() cannot race with
>     zswap_cpu_comp_prepare() because of hotplug synchronization.
>
> The current acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock() are
> deleted. Instead, zswap_[de]compress() directly call
> mutex_[un]lock(&acomp_ctx->mutex).
>
> The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is 8.28 KB
> on x86_64. This cost is only paid when a CPU is offlined, until it is
> onlined again.
>
> Co-developed-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Lol.

> Acked-by: Yosry Ahmed <yosry@kernel.org>

Thanks for simplifying this :) My brain always hurts when I have to
handle CPU offlining for per-cpu structures. I had to deal with this
because I added per-CPU caching for a structure (with reference
counting) in another patch series of mine :)

Acked-by: Nhat Pham <nphamcs@gmail.com>

