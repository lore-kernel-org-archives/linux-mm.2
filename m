Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1194606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14776B0512; Tue, 20 Oct 2026 11:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC55E6B0514; Tue, 20 Oct 2026 11:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4606B0515; Tue, 20 Oct 2026 11:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB876B0512
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AF6E12027B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:58:01 +0000 (UTC)
X-FDA: 85343460762.17.60C5780
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67D674000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:57:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2o93XxMYB/n87rEXmmkyQV39aYB1EujyaYhqwJ1Wo0w=;
	b=kfC87W69HJLyxy6RS7GW/N4k4DNggYpStUpDKA+M8w1+4xS4HiogqwEC79Cx8FimZoqj1o
	jvIjTD35amdclLZmVDSV74xj+MsO2qWlgGT3htAfSOaIS1qRuaaZyF/4JctTnv822kVYBs
	2PCuHCcLCWtxW1YF6E3w5soYkUh+eis=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511879;
	b=6ZJkRxIPmbdPJQmALSgF16fev1DsFblZz0+JUQZ7C6CIQhMBiuq9iIAGtfpINgS9Q3FPoy
	riOHrIpGJCCVnWwR8UMs3F10/kB+e63OGQhgB9bFyte4boWc0laEdWT+x+/sYTwrffc4RL
	YT1bkLkveCacNqZPeZ53fb+KhzHYFyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B79843EC3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E391F000C6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:57:58 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4550d8ab15so217386166b.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:57:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByJ6q48uh67Aj2i8NFoxyZ9npfl/2zhBligDuxoFfbXp58RXtfqa+0yldb4a9ke5xqKInicT5Yjgg==@kvack.org
X-Gm-Message-State: AFq9FYI9LYYufn+HbTcRhh7fCe0JPt63W01xAjpROyGu9KRaa7mOZ0ER
	RVIQ5pnCc3gbe4u58jiWFbo4VdNIcGt7ojf8RgakGwCLHnj1dMEPnKPyGtt5fNGTHZ72ntPY9JI
	lxKBarJQqHYXs75h+r/vbevkmnJQzjFM=
X-Received: by 2002:a17:907:930e:b0:c40:f296:4d43 with SMTP id
 a640c23a62f3a-c4199970845mr803586666b.3.1792511847509; Tue, 20 Oct 2026
 08:57:27 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020122942.3477541-1-hwenwur@gmail.com>
In-Reply-To: <20261020122942.3477541-1-hwenwur@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 20 Oct 2026 08:57:15 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNgnt=9UXN_FJ3zByVtC18MNe94-tXssAS-eAQfutNXRQ@mail.gmail.com>
X-Gm-Features: AclHuK_EDOXSgUtKkVYdbD02JtxAHuI_On9M20AyiaPbLRXhfIG1wXrQNdG4FME
Message-ID: <CAO9r8zNgnt=9UXN_FJ3zByVtC18MNe94-tXssAS-eAQfutNXRQ@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: set zswap_ever_enabled when enabling zswap at runtime
To: Wenwu Hou <hwenwur@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67D674000A
X-Rspam-User: 
X-Stat-Signature: wdphnop77myi6dwt1cr5hatgatyzj74k
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792511879-69234
X-HE-Meta: U2FsdGVkX18IiVUwTYwh11l5mYKYZ92efJgS+fd+49t8Zgez+ggu0aJigoMIBXy4xUEtlrBcss/y/N6YqNVq+9CpovWfXJK1f2wxc7hm8jXnUNpeak5dL61BKegFat++IBPLRN/zUh9GvNIgxCqHO7cTQ6QN1rD1DAZHV+Q2s+jBGgiZDfRwQC++N0pM49yRhQ/Cbw2ndFHWb04G1PTuqMRN+jy443Mb3etKThFFo5Apj3eiIlPXdLSwnJYBjdYs8JzxZrMvEAuFUgsSW6NBcGC217Q92c0oKaI067IbdaWQcRoflOWK7dM6I+Hed7FPWeQejvbPK9l8xh22EIEQNCTDqbG6zC5SUMzDnOqc5sqbQNNvYnKx+c+ThUf6srN68DhQTVlt2OlyS/CweMmYLpjzvfEsWrGKtgPeMeUv6QVN36XeV8fcOVaGrfMo/NHb+efNorNpZ9bacnCfJVhkaBVqCIgeudmFbwWQJj+DPJERY5IpSOcaHbKVURXf+5cgRoJiWAahGsPPG2+OtYxNu0VOoxkE/3n/6tpjx2qHPD9QOm4tcl+3h0mmFMQqytFqPl1JLPhBEkIFdLWuXvNeesvgL82aJS2Hc7j+8J9+COq/EILzDlSHtblemeYCBy1etPRwVrjqY4qSt+nKVwPsj2U9xa4E5uK6wc1kHhPCsFyBL5/gMwP7KQvMaauQAjlcSZ9C4IyZmdn0Y2ny6kU5sPkYMe9SRjwNN5D/PgTI8sM+7zZ194+K4IsUx7LKbYk6oRXPH2Sd4Ah7ltYtAWxUvIMAYu7f1MSrpe4pw/KHqvzyvk96qYMooro8TgZUtNe2tT+T2V8qBkjVBLcdOUffBMOkCTu1VjlyLAPA+NMxkgWHqKj+Dc2UaA0xTJ8Fc/6tHuY/E5w7DwzRpvZoawFxi+Zb7m5MgYEP+oDjKiT0uWwRSnnAyxheetd/68kPQqEKnJCKdNRH0QhVnfgLQwC
 pdJbQVPe
 FomYa3EE3F2wb67hrzq6sDJmx/DHmzN0q0ziV87bq8OvJ1LD2PiKnaqpqR2FXYWKkj4EhWaMXZyccQoxytL/n66fyk0ABWA6CNzoy0Q5+2jSUBaGMp9ZhMab2s8wBHvxIQVof1KR9bcJY40WGT3j+tPcwLf8hmRL3fSwpvNNVU2PUpCVfuu1vxIWvnmZ7IAjxEs8F4S5CRGJiA2lTfK4EgbY0ph7484fV9dlMooUAXhHzdK/TYcYbtvrVC0GvRcRcjU46ylhZzwo+POYdQbjVpT0T/C7R+y0nh8MY+aHjG2bFR30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 5:30=E2=80=AFAM Wenwu Hou <hwenwur@gmail.com> wrote=
:
>
> zswap can end up enabled without zswap_ever_enabled being set, which
> leads to data corruption. With CONFIG_ZSWAP_DEFAULT_ON=3Dn:
>
> 1. zswap_setup() fails to create the initial pool. Setup still counts
>    as successful, but zswap_has_pool stays false.
> 2. The user writes a compressor name to
>    /sys/module/zswap/parameters/compressor.
>    zswap_compressor_param_set() creates a pool and sets
>    zswap_has_pool =3D true, but never enables the zswap_ever_enabled
>    static key.
> 3. The user runs "echo Y > /sys/module/zswap/parameters/enabled".
> 4. zswap_store() now stores pages in zswap, and swap_writeout() skips
>    writing them to the swap device.
> 5. On swap-in, zswap_load() first checks zswap_never_enabled(). It
>    returns true, so zswap_load() reports that the page is not in zswap.
>    The page is then read from the swap device, which holds stale data.
>
> Fix this by enabling zswap_ever_enabled in zswap_enabled_param_set()
> before zswap_enabled becomes true.

Wasn't this fixed by
https://lore.kernel.org/linux-mm/20260906133601.3563324-1-xialonglong2025@1=
63.com/?

>
> Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
> ---
>  mm/zswap.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..d2b4c248baa67 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -629,12 +629,29 @@ static int zswap_enabled_param_set(const char *val,
>                 if (zswap_setup())
>                         break;
>                 fallthrough;
> -       case ZSWAP_INIT_SUCCEED:
> -               if (!zswap_has_pool)
> +       case ZSWAP_INIT_SUCCEED: {
> +               bool enable;
> +
> +               if (!zswap_has_pool) {
>                         pr_err("can't enable, no pool configured\n");
> -               else
> -                       ret =3D param_set_bool(val, kp);
> +                       break;
> +               }
> +
> +               /*
> +                * The initial pool may have been created later by the
> +                * compressor param rather than by zswap_setup(), in whic=
h
> +                * case zswap_ever_enabled is still off. Flip it before
> +                * zswap_enabled becomes visible to zswap_store(), otherw=
ise
> +                * zswap_load() would skip stored entries and read stale =
data
> +                * from the backing swap device. param_set_bool() treats =
a
> +                * NULL value as true.
> +                */
> +               if (!val || (!kstrtobool(val, &enable) && enable))
> +                       static_branch_enable(&zswap_ever_enabled);
> +
> +               ret =3D param_set_bool(val, kp);
>                 break;
> +       }
>         case ZSWAP_INIT_FAILED:
>                 pr_err("can't enable, initialization failed\n");
>         }
> --
> 2.43.0
>

