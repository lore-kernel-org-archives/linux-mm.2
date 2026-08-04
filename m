Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CCAC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FA46B00E5; Tue,  4 Aug 2026 16:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50BB6B00EE; Tue,  4 Aug 2026 16:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66D46B00F0; Tue,  4 Aug 2026 16:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 775DD6B00E5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:09:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E474DC02D8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:09:03 +0000 (UTC)
X-FDA: 85064675766.06.0C0C530
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id E76E5A0012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:09:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMHXyfJ2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785874142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLpRO5dH+fN1LCShnLYbtBYMbkUOmAnIe7RU35Aq/BY=;
	b=RxCgkE089pkxykg7vo9J6sK6qMgsMkoHFtzwf3Xno+zLFP2EZNk8OV+KAwz1B6DHNwienM
	J3oYA6S1m8TqCTe9OBajh8qJHu8b/2nF/D/K4W5B2sRmo1qvZTK0+gfQR/aO3VChP3o6tk
	0FJMm9dasdJjaZEOaWyYRxqgFQsqhk8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BMHXyfJ2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785874142;
	b=IvyjXBwjb3imVWghgrz2UZNfoNj3xrLZuEXmlV5J1+h+iglwYS2xcdsURDeLHULZ/MSvUl
	pfXYIC3wC2hQtO/aInBYiQBkLnu13sWItf6d7fGxsml44Du4xmj5fk2POsfVtPU94MAYk1
	sFUoUmun8kb8ki49xmqPYbZ/A8/Txho=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15a5b265so70081cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785874141; cv=none;
        d=google.com; s=arc-20260327;
        b=cL3oKNtMySul6amnC+t2LVoA9t0PpJLin0imBOYl42rhJ961duNl1hwH2QQaKFOZrW
         DMrWfUed3SyUxWMaL9d9CjXlNAlNZlbK2cy24TZbZnnAe23bp0RxsqF6rJpj0sjS5Aob
         grzk74bXe7y+Nv/iVrlGG0B/oGLPIOQDOmfF8KP09DpGNWmRPKO/Lb8vEx3ibkUgB0xr
         q4KdeTDjBjKdSmLn+MF+WQ+YxbVc3rq9eE9McQpVrBUnV9OlgMC8a/jmuMMgKOBHHuCt
         GzYodNWx5uRPvBDIalCRVj8/BQMDrdYS7m0RnhCdwrbuWTOpIZQ0cXqTddnYcTz8svZv
         jpsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gLpRO5dH+fN1LCShnLYbtBYMbkUOmAnIe7RU35Aq/BY=;
        fh=V2S0UZ1kwbFdBhlI6NjZJ1CVrxYu3RRBdDJ/fgiJc68=;
        b=GDM/qfvjac66zoUjEJZMLm5/Infigd4NmwwA+4iA+02ypXWuwWOzKgmsVdb89wJ3HC
         HmqHxu60Vkcne6ziojc5eE2t7vuknC6rMGbKJO/aEJZSKdbROmOMLMfiiaZa8c0izSXI
         24hcHtjA0fOI5hsdWR+hRF6LFt2SDS31A8LlaXMRvoHeSb6jT/0lLfITFnL69V5LWeXt
         ooAfZ6VV1IrEuOjfGkAe+4Ka85cTXKsegS5QairhEafujqEIQZrRl/Se4xgtiysYuAw2
         d689feyxkenYDq3WjH9mv4WWwIK0TmzZ/ZVpF7+HXjA/SGDPmU5n6HRi+QwHmprKlBh9
         lokw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785874141; x=1786478941; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gLpRO5dH+fN1LCShnLYbtBYMbkUOmAnIe7RU35Aq/BY=;
        b=BMHXyfJ2LewYxCIjUdl4u5rXKUuahK0nTeDixiiqP+24IB9GXOXFEPP5AcPi1sMDk/
         fqQe6omG3HkXotSiNze1r4cqkdWviLCs4PnAVXlvHOmkUpPyCpR3HfzbqTp41K4NreoK
         dd0cAFSFyg4m5ud/v3l0QhaEfhpbmadfGYl52Z3yfDqeahtkf6vu0pmNvr02/RMNaw6n
         YG1BhhNCIGbSK0k0PE2FfWmhVpfXqljAwWod47OwIvZuWW7pGcIYHvuyMjnOual+qLyl
         En+FbEtQz2ResdN8l8BoeIkNCI4PqS0+8BH2c90Fk+5JVsWrt0AuxhnmiE5vEjCvtkp3
         fSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785874141; x=1786478941;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gLpRO5dH+fN1LCShnLYbtBYMbkUOmAnIe7RU35Aq/BY=;
        b=brkK0ySdIhy4NckgWC5VtlG9RGCuSDltyz7iRfxwnpPYGb9qK8gcwS+QyDfYEPrVMz
         +HHIDf7FyQZ3/zug503uHRCstEqtO44k6zSWUuRK8Ewx7j1L2HCXBNVvzlqdWsZBMEYa
         BTIkHzzckcdAYTiZYF/YtCgrdd5EbxhJPFjeWRj7xT2CsB/8sJR7grj7GFXv5LMHE691
         W9dRKRpeZvsGplRnoTQoyvMmFNWA4LYAJ2HDuG66XubGZ/MNl0FZoy+F68FHDcigf35G
         wZK4m1xZazx8KUfHInZvy5goRj3uw5MlKYO7rXZttrvzK2ekg4RKfgVrtyHR87RjMLgP
         V5ig==
X-Forwarded-Encrypted: i=1; AHgh+RpZ1eJ23BrVsTGNbEc3lhHnXQLU7QwcTntdEv+y3VDM+tyaEydpnRdhCqmixs+A7TGC1fdYvciC7g==@kvack.org
X-Gm-Message-State: AOJu0YxDejvxO2u3M7fWP+LzZr3Wdf50pNfeDnL/gUlHPN48eDnrZIMI
	pUcFf0sgPa7DF72lfWMjKaQJ39PB9fl7qCJkgNWlA10/IC6yVAUkxI8eJ3wWUfsfJmnj2njt+b0
	u94p7/QtsqMI5hzhS3A/jcQeWAnp9oQ9KDiX1UbrU
X-Gm-Gg: AR+sD12K3uNKXga5KUW603Du9H7vDd5qXxfvTubzBZjRSzjbobHuahitnKOXJlyGDs0
	dNp893F7dbTk9Gi+ZvoXZWnIndyoGUP/UiR6hVqyMOExNK12gxUHLzxMzElrflHnFUzuBDocohX
	M5pAKavFbBAzzQNEfOkbGUTtegkatAG1Ne/xwWNS3pG+uMi5J+f26+eootVe+dGaJHvFK2vzdR2
	VhhHXlb4a0niwRAqXhsk4J5xdWahZ8LYjdYCmT8AWM0nQf9OL6zS9yhThkAJDhgsJvTzFPlv8nV
	VeIaF+qbBvZxgoJT1JMSLe/Xk+JLTIumJrj6TLb348Q1JbiUe8e13/Bto9ccUgOV+fFkDQPoAQA
	=
X-Received: by 2002:a05:622a:a6c3:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-52ce6c8ef40mr4163801cf.11.1785874140324; Tue, 04 Aug 2026
 13:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260804122038.190270-1-hao.ge@linux.dev>
In-Reply-To: <20260804122038.190270-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 13:08:49 -0700
X-Gm-Features: AUfX_mwIgnpCsSpVuGaJq123_P9l9T9DSb_2ViQo7h1MG8JSNzWnfW8YjiUletY
Message-ID: <CAJuCfpGit7zcNPGAB9D2A5+718NY-qdksxt7gUaN_eRcB_5+Ug@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E76E5A0012
X-Stat-Signature: jpzuq4e3cj7w6myk3nygpwi1ob83ydru
X-Rspam-User: 
X-HE-Tag: 1785874141-420968
X-HE-Meta: U2FsdGVkX1+ZcN+ROZlzRk1mzJT4q/GYIEr/gkTtBl8+e2DhbE7xg61lCUVLzE4vpP9OsO9XK6B7kDQcGqezDT9eq1YZqbAhFvbw8fGvKLZ4fKuuEL0MWqMeHXjzSmWJimW+Q20Hpu1UAdX0IPn+BPOp/nCU05cFe36MyMnUG2+zl6a9WdjHVymes8CA3jIK38lIzUIJMaOlG2wA685TvV6EWoJN2U6rLQrv0wSFblqjTdE72S3bXaBccrgxj0dCmuyes/VjHawug2PKQ35EQoL1Hl7kBeGY/GnEcIpSbH2Ltewq/7Se9oAgag9klVIHw581cAnwPQ2nmVSMvUqVxx0jx9hiC8Oq7DXrV/BssnkNHULNwXbj6WDzyOWcC1uWBT/gQybPcySnB3eInDh5GneWOM+ewkNZiGG8wodhbiJOS6ToXXKHFUGI3ooP3XkuI5Z/x34REHDon7MY89L4V6PbK3Gw9D8RW2Og4YbOBNJA1NG5fsXgXjMKJKTUFXMLkgPrfjzCJcEGCwp3qWY8EMWYS3sznwXyWzA4rTzXeZ/J6Mnq1P1wN7pu75s403FFxQuTP4M4KJGX83WecRl1s/ZuMOxHcyebG2ZNpolBAaMgk2HgqEev3PtGfoy3UvonhrqwP4kJl6HeBMperk5zfJtcrV0lgi2vLvKaSgerQPb160stnfnbCOG+IHxLDRU55vaCo9+yN27Zd61eiuq689IR2lTtszC0hyEVI2F3wjBgzUCHvAg6LUqNKU0i9X80IKvbItetqoyPpRxFxG6uiY8MKFaj0FdwEOz234ZyF3zcSXphyFzXouhjRf9y+Op35kEAKCTFE9VgdUVziMbo0UKTJMRZxype4X57fKSAmul7zOXSnF5QUdLkCLHjmHCYRHPDps7eLUWlSS2JSnLRO2IQEwPxdl0CnszaKr11VvWR7kiVXiFrcmoAQUNXmRJZ0ifsdYVM3BrkX97lzFL
 tM5y5IEz
 kShCqypEAwtC9qCdLpgDb2nopoiqVXz6/qm5eF0PY181tovO07O1eV8CjAqzu/yIeCjR7LyFWzsRXRM0U+LD2RNRA2Q7JM+YFFTRupOjcvhXl/DdRxPJ97C6xByLHqWRNGsJXBnyt2hrgSDHnIIQWU4fFDCrFNLTHvNEXnJHhA3QlHgy1U/OpCWrMPTnFjngQ41DuBh1Cjsvq6gr/AdOJ1FAGvHjRz9sKOgYrc074ylu2HmbaDuVNNVW9Qm/hk44sNTC9vNq8LY69MY0upC2yzluwBLXU3YWF/jTVXYqNYGyl7GCPrdlb/rA2DhIta5czlFsBvD0NM35gs9aSPb9xxfBV/L9A8lwUsCuemVT8piMK4b2GvUZkvLMkRWxrXwMZqlzKtT+r7cZOfEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 5:21=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
>
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
>
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
>
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
>
> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> the mapped pages would never be reused - shutdown_mem_profiling() sets
> mem_profiling_support to false, so no future module load enters the
> codetag path.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Thanks for the fix, Hao!

> ---
> Changes in v2:
> - Return error after shutdown_mem_profiling() to skip unnecessary
>   vm_module_tags_populate()
>   v1 link: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@lin=
ux.dev/
> ---
>  mm/alloc_tag.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..d8c36430f1c0 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *mod=
, unsigned long size,
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> -               if (mem_alloc_profiling_enabled() && !tags_addressable())=
 {

Makes sense but how about replacing mem_alloc_profiling_enabled() with
mem_profiling_support? Otherwise this warning will be issued multiple
times if we are loading multiple modules.

> +               if (!tags_addressable()) {
>                         shutdown_mem_profiling(true);
>                         pr_warn("With module %s there are too many tags t=
o fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>                                 mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       return ERR_PTR(-ENOSPC);

This ENOSPC error will be propagated all the way up to the init_module
syscall and it's not among the error codes currently expected (see:
https://man7.org/linux/man-pages/man2/init_module.2.html). I suggest
returning ENOMEM instead.

>                 }
>
>                 grow_res =3D vm_module_tags_populate();
> --
> 2.25.1
>

