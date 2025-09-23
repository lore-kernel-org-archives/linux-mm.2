Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E014CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 22:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0998E0005; Tue, 23 Sep 2025 18:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8268E0001; Tue, 23 Sep 2025 18:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5098E0005; Tue, 23 Sep 2025 18:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3E18E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:17:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2434FBA39A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:17:31 +0000 (UTC)
X-FDA: 83921927502.28.67C8E7F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 38FCB120007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:17:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gf1vwckI;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758665849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVWMft2XsyeXV72Qq8qzboJ+JH8LewX1fWXjUwcqn00=;
	b=bvlTAGkKVFfqzuLc3r31OVkGrpCso+lEQWPGWa3t5+e6UiKMaYZoG8IjBrL02HhFdxNEOW
	v6oIVSM5XN48fpxIWoWx9IBNeRZW78uawW1XNGAP4WMA1ZPQ/xCC0jj5LuU68SXjcnrQfh
	Ba6kgs+M7RSe8YhBNjHd0ibmclWyVs0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gf1vwckI;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758665849; a=rsa-sha256;
	cv=none;
	b=PNXa5JoUqdplRWMVKCl4at5JCnZgKPDoiQUSEiddKlsvOBDTLN4tqCae3ri5ncf60zUQrN
	aQxyXPNbW98TweQhTVvzGypyoGrFlmSGE6i5+Wy2L/yrSQVXqzZBnOKHTxHRJf1ys+nDop
	guNsBrY1HlXJBZW5ItKJVUoQB3KdjI0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46cd0103f58so10635e9.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758665847; x=1759270647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVWMft2XsyeXV72Qq8qzboJ+JH8LewX1fWXjUwcqn00=;
        b=gf1vwckITtHgfZ1VwHZWgor6FUycLRroBEyLyueQr64OZRpshuceq9PVveRAk/FdXX
         PqgTfRSpHR3fLsQMtTQ+dyDmG0O6/1VnN8o818qQ4pl/i09pa7yzed9jkyteBz+J30fP
         P8Bk1JJ+QPEkFUyg7Wri5Yut85g/xMFFAMkpvzLxQEF23PwXZ9UjHT6vkH35s/A/tEG5
         tBO8f12MOf7xaEoyXxNk6uW+p1F22PTlyH5ZNIhE7ye/XvyGxNY+dLZ1aM4qwD0i/Xie
         Dhu+1HUREDzKPrmFITxbJrPctfDZJvI2+57SlQQmUS9cSew+z6KD86o7DmAsVeQ3SbYz
         smcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758665847; x=1759270647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVWMft2XsyeXV72Qq8qzboJ+JH8LewX1fWXjUwcqn00=;
        b=RxwMSdfnFhPoSU0wzsDfquWDJCI6H5VrHBa9iCqqK5VLD4DK9ohf+UusYMv/jTiG8V
         nFJUlpV8wLHEe2WNxBT/vEoF8Ox4GArBrB8mt0FqZM6hXH0NwER5nIV5nzuGB/+Tmbbi
         cCI26HK64Bo1PQbi4/lbTiIeZA4TlIOph2meT+O2HtCLlixo8oFaof3dUQXdZrm+VmzR
         EkumNN8+ToI4PIFJ6YCcT/n45HJJLLdtakTat6GR/0BEuQZcpHUr9XLSrInaBN6IjGUl
         nOoLuXfkKBLAtCtT6fApmQTXFf53qpMVz5W5AjoUBrY8PHhOrTKNK7kBF/BgI/i9DYNc
         SVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW994kfk2PCjia3ziZCTiAg0pj8acTJ4/kynUkCyhaPGGDOV5+z9sYlf6Oyi3C3MxGFgZnhrZnVgA==@kvack.org
X-Gm-Message-State: AOJu0YxnRcz/RtZwaaDTikWq7Wa7yxeWh26fWIZfhhN4YCVwEbK3S2Q5
	1tuRovcmQULzVdlbqwmNWDGUGZHYb8U40XZClh8nT3VghjOGgZEWJ/C48Qnvto2nlc3QPL29aBM
	hxjDWO8o+v0FpEYqkSZ4gXIk3zSQXWsk2RVzpouGP
X-Gm-Gg: ASbGncuupiEy5ZwD1Sug8zpo0sKUJ+FhVhdjHKRuQ1L0qPhRUOP5LOuvSo32xXTwuSv
	F1D5EzZNml1iJo2+5HF5Xq0FeramNPPMwZ7wRO5HRuK2BPEzo4Xgkm6VBvLqXc11YJOsyrkc/Ej
	qMAWn0B6GOKMf2Zna/xKAExiO8jxCjnlKmweGAdAMMuSKZBPQcye8Bo5worQ76d5gdNWQnjVZe+
	82gAhj88uFtGp844IcsTJ5OnMDJE7QwPhPc
X-Google-Smtp-Source: AGHT+IEcWiF0I1sfjsMhTzcRIe6acYaaF8Uh4z43AOsLW3wqZYxhAc2RQhV5H/9pUBMdrKDluVnTHZhLVH08WVy5FmQ=
X-Received: by 2002:a05:600c:35c5:b0:45d:f51c:193 with SMTP id
 5b1f17b1804b1-46e293a8efcmr594375e9.7.1758665847317; Tue, 23 Sep 2025
 15:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_EDEED996FC685E61AADA14A23BCE9CCDAF09@qq.com>
In-Reply-To: <tencent_EDEED996FC685E61AADA14A23BCE9CCDAF09@qq.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 23 Sep 2025 15:17:14 -0700
X-Gm-Features: AS18NWD2t_E_ndAQdiIl2UwvXOMU-niLJp8pfQOT6CiBzVYXfdzAb76xBWhr7As
Message-ID: <CACw3F53PUGZ-gWKHiBHzcGfM9r8h-vTp7HnGDOZruucMQC5yDg@mail.gmail.com>
Subject: Re: [PATCH V2] mm/memory-failure: Ensure collect_procs is retried
 when unmap fails
To: shengminghu512 <shengminghu512@qq.com>
Cc: linmiaohe <linmiaohe@huawei.com>, "nao.horiguchi" <nao.horiguchi@gmail.com>, 
	akpm <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, "hu.shengming" <hu.shengming@zte.com.cn>, 
	"zhang.run" <zhang.run@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 38FCB120007
X-Stat-Signature: 9wpe9pwez9z47x4qimdfan3ocdnosas8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758665849-873753
X-HE-Meta: U2FsdGVkX1+Y5OeWOiOtcU6V3FnV1FXfRcVlyQxZ0oPNQzykg4ZEolCAkDg18FA9VwgVf81sMV53WG+XNdEmnWnwmGoxNuV+A0Xt6wrzfO6VtzpbTM/pded9v7pV91UFGrr9Bxtv87vQvwxCgJ2s9txbPuUHwhyA8g9+rJDFshSbBrkphjcro7uh7x+d04695dmJ7ZQZnRlOlzsDmP6EXAMmQBIlPaEd5ka689QRWnegebd43/OWHG5i/dFxDDvg6zCpmoEqIOcI+qLkMrfapqempkltvHIjRg1DgK0eLyElJ1kUqOUPc2DrEhsHQaYcIpCsueypHvFoLps1v7GGcS57XrJcw9nzD31u6XuF1qBgS2+5/ri6KcyTElupeXil8+1Emb6ldUBZe1Sc57YOjaGzticBwFar03CziM7cULlMU3THD8//3ku6XUgDwEesW4EsD8IVzm4Bp+/GXTcq3StTwPMGHEDWyfLdT+zeWZZclqSAFqcgxFvCCizark7xX9Sy1jgIHuB883Zkzm7p6qodxk0sd/rQEXUHpx3NnZV/DgrMQvrf34CnSG+Et7YnfcR7/+hwO50fFMrne6JXzxDoEaSa9IaGLQxpzlwsVP++X1j6cVaq8LDProAcZdLjrTKtDiuZHast/lLs9VNW9B8a5iWe1TLG2zMoe3y+2sz20SARFuJD2PNCP4wCdh5yTTci/bhTNgJLPOSHnbIE9edS204XsoLqrs+m+Uzkf1Mjqw3UzWNHCapUIU+oGWmvW92CrbWn2Rlx8w7yhFA785wwVXog4/pC1P7aPYNOgIpaduTVzRzPPsGJPhRyRNGZdt9gCZj8XMaK6YFpmipCTFcbsYdKFdmdTATaru+MMeHvwJlkInOPMDiP7z1fQ8HPhqxQHFvpzBvAjpGr2azaYeYo7Si1VvEo3c1iSekBsmgMXzcddfhkbm6UdT91ZgGPc7UUUv25oatw8tSBHdg
 kGHbaAJk
 U52uEpyUEkb4cqTh0vJA/9TmdSwHKdzyJ1Dxgi8NMkdmy5Bom6SwwXtuIj1ssIOwF6UFA95iYtWE3IvCxYqtTya2WZln7+AwnyhOalPhH9sfgKB4jLCXeVQLmXUDeQCTABPWkQl5ECY7Kx1ROgGdHFcH7WayCjUvOOKHYAm8pwEk8gPO1cTBxh6IDGUTNK/Djh4oTOiddgLn7JcaueF4GsZC9SETwXfcCg6h6IsEy7oOL9cJVIYOXwjQBYpPUBfHJteQn0FioKgVPDREjRusrC9Hd+gK9ju578vfU6+qzQsse9pgaNX4MthXvRnOA3uurl1gkaADqua3m931mU8I/PYMgKrBzcPkmIVeIAQfzmnrHSPXf0Gbv5O3+88gG0cvEXc3YYXHoUdKCEpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 7:57=E2=80=AFAM shengminghu512 <shengminghu512@qq.c=
om> wrote:
>
> From: Shengming Hu <shengminghu512@qq.com>
> Date: Tue, 23 Sep 2025 20:56:28 +0800
> Subject: [PATCH V2] mm/memory-failure: Ensure collect_procs is retried wh=
en
>  unmap fails
>
> In the memory_failure process, if collect_procs is not executed with the
> flag set, the to_kill list may be empty. Even if there are pages that fai=
l

Hi Shengming,

I am trying to figure out what your code is for.

If we get into hwpoison_user_mappings with MF_ACTION_REQUIRED *not*
set in flags, force_early should not be set and it is totally valid
that collect_procs add nothing to to kill...

> to be unmapped, SIGKILL or SIGBUS cannot be sent to the process via

unless some process opt-ed in MCE_KILL_EARLY and collect_procs will
find that process if it mapped the poisoned page, regardless if
force_early is 1 or 0.

IOW I don't think there is any reason (no bug to fix and nothing to
improve) for what you are trying to do here.

> collect_procs.
>
> This patch fixes the issue by re-executing collect_procs when the to_kill
> list is empty and unmap fails. This collects processes with unmap failure=
s
> into the to_kill list, allowing SIGBUS or SIGKILL to terminate them in
> subsequent code.
>
> V2:
>   - Resent as plain text (previous version was HTML).
>   - No functional changes.
>
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>  mm/memory-failure.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a24806bb8e82..8157823c7fb7 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1600,9 +1600,12 @@ static bool hwpoison_user_mappings(struct folio *f=
olio, struct page *p,
>         collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
>
>         unmap_success =3D !unmap_poisoned_folio(folio, pfn, flags & MF_MU=
ST_KILL);
> -       if (!unmap_success)
> +       if (!unmap_success) {
>                 pr_err("%#lx: failed to unmap page (folio mapcount=3D%d)\=
n",
>                        pfn, folio_mapcount(folio));
> +               if (list_empty(&tokill))
> +                       collect_procs(folio, p, &tokill, 1);
> +       }
>
>         /*
>          * try_to_unmap() might put mlocked page in lru cache, so call
> --
> 2.25.1

