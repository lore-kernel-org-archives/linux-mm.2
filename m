Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB93D216B2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4CE6B000E; Thu,  4 Dec 2025 11:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C3B6B00B0; Thu,  4 Dec 2025 11:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C99A6B00BE; Thu,  4 Dec 2025 11:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6F56B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:40:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32EDE1602A9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:40:46 +0000 (UTC)
X-FDA: 84182352492.01.F86532F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BD4F1A0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:40:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0Qw1qxZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764866444; a=rsa-sha256;
	cv=none;
	b=NRwZKuqHcTOGgS3M8BCaHVzhY44DDy/gM7kmlSZY/SNrrMiD/2Zz1i/OInY2Z+nP0VUbIe
	aoEKlU7pW4qiR34A6gPSK7YjQ92Az+GMN3TmGQPhV8GVJqKqOHHzLjaOnQkWZz3qEVOqlM
	HtAj2OZ2trVr9y1+3dGwKwF2XGFn5kM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D0Qw1qxZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764866444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wb9ZdPQgurLaP8ZtzTPbdlyBs0CGGHqRQ+aYAuE+t9k=;
	b=01fAZz1htrlGsS22Eg2aGSK+OdtBHPgEhblDNC/Sd/lYrlbUtbP0IwqciLJN4aDo3c4frR
	dnlxeHCW9KShMzZah85xtuuiCR6rbElgjtpMjlCMaMIyOLP5GsCX06U4G/z2gi63TZqF12
	UkgVEclYzxFUTz4HXeI4zr6JvBrMPSA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso12595955e9.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764866443; x=1765471243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wb9ZdPQgurLaP8ZtzTPbdlyBs0CGGHqRQ+aYAuE+t9k=;
        b=D0Qw1qxZXGryA0aHP9FzTx5p/FoF/8ew8Y5YPnP1PvzbTWewndPC1klANsFvfJHxjG
         NN0ggbzbB3YrMNZRtIclhM/t2UuZdITL5PLNBTv6rmSlwUvM1rv+0QemZEK0drzzDdFa
         usI2urmCGRUv2M3M7SHftsICFirfznSBf7WJu9p1+5LwGORvr/SV0Gzw3LaC1ftugw4M
         TqIy5oV8ZYz3fzupBD4nKuRFtxMGQ2gSiWyIQyQ/79Ar7XKehw6EZQIlvDgDS1Eu08/3
         4LHC5F3T+STfxw11anq1KgquhfegS0MSBNFE43od/a3JoU+/hZCDefruY8NdXtZBlFf9
         5uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866443; x=1765471243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wb9ZdPQgurLaP8ZtzTPbdlyBs0CGGHqRQ+aYAuE+t9k=;
        b=VIna5h32CfRmiPQCi5JCTLjl3pfPXuzDAPJVAAa4dTs2Ov+iJ5uR9Q/5We7/ehOvyM
         R7AeE8QK7y+0uaTBp1HXtPDu/bzvsulN1to4pdnCfqkIB2GpbYsGUVM7Gg5j0yTk1NKq
         7uJrlTnHkEpgiej3TTepAiRRITQKnvvYlCvzgjAjAc6ngfYkII3JSPBBmYwsuBuPM0xC
         SkxXPesopwLUSf6MUkJKmhIKW9NofqbcynK1JcQ+pqCAuk+iT/eLpw+GNGlxj61fGdbP
         5y2f8IjTM0YVNdhEaX3hw+iOcTLEfCgsqiNm1BPXWMmLsLg3YXpbD6rw08NWd8701Yz8
         MuMg==
X-Gm-Message-State: AOJu0YzHJwGGMFFhKcAtcFpMaBVETI4f+o+9Vo33qqid2SoFrzUROEr8
	rI67KoBvjORqTROY16TLIoOZ1wLa3RsXG4vqiRS5a5KZ8ATSymghMy2DCrG8VnnblSBgAtcwFp3
	eAP8PUKM+dZ6NyNPQZv9NqYvGSznk4Bg=
X-Gm-Gg: ASbGnctgSlAR7wTnSm0EUC8GiVdtg+TW2AG7kBp+3/mq40vns8DoHfo3U8fiDJ0N+l4
	kGjG8yreG91ALtdcvTHyTI5IqsQmEwGua46RBOoRJ+HeHkfBafLty2BqoVlRyuv0Ccff+4NefoJ
	nzppMth92OtpEZCTXr7wVubo6rWljr6yhhMOglgi0WR3fK7sBDTsBwTMLO9xu29gobVhCws7+vu
	L60gfUSymtb68Wb02MSheT0NSwFvUzOtUK58rT3AXQbWURTxhZMTGuL9i6K7eI/tFyDxo6Ku3gS
	w3iC06ao3UWiOQrwsUTPZOsddCL6
X-Google-Smtp-Source: AGHT+IFBRVSuUZ34af9rjSbMuf6IaH9HO13HkHrc7coRDjjoLj9cIdf9EynSSP33VRIl9frOkufLTItP6mOGaTfz2hg=
X-Received: by 2002:a05:6000:1a87:b0:42b:483f:da8b with SMTP id
 ffacd0b85a97d-42f73187378mr7778677f8f.25.1764866442731; Thu, 04 Dec 2025
 08:40:42 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-4-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-4-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 17:40:29 +0100
X-Gm-Features: AWmQ_bnAHBHdMEtZR2H-axXWT-9zuGdxSA8XYx7l16HmfMLSXrkVqTo9q2sNGCg
Message-ID: <CA+fCnZfVPGYkFrEaU0-AzxUDLQcwoT08XuTrXf9oifHWEbhA=g@mail.gmail.com>
Subject: Re: [PATCH v4 03/12] mm/kasan/sw_tags: don't initialize kasan if it's disabled
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BD4F1A0011
X-Stat-Signature: wpsw1huu3ct6anrkcq4fjfkuak8za5ms
X-Rspam-User: 
X-HE-Tag: 1764866444-169487
X-HE-Meta: U2FsdGVkX19KZWq+UwsSkg4Omytb3gRz2cuSG0yzX6YIZf/rKN/UxTy/P5wUKYgR5nED28SWHIDsaVEPXqyeqTPO1P7ynmA83CVIgLnRAi1lnHsbXHXqsa9nxGGQRXrb7sm0HO1QHf1KT3TZ4LHjN06tVNQ6V6rUufgTiDL2wsSGPfKbNMH6OIGC77Ctopeg4lx/A2dFRWrb1FWmgj/6j7IDRQxSZrl0rYSuw4JWe66GARDMBtbsbrlBHo6+1HaDDV8rw3eBcVG0u7FKNGyKiS8c4CTxzMCZeTlUEdBmH9mWBE7rOkfa48HM+D3n5zlhfUbLtw+eMjn3gixsdB+LiNXZWywnAMDKhtAQyHKQ+pkHZPxWiLKKXgydQhRBL1ci7rYP63YRlXSAwm7UG/ugqHW3Vn6PIqlAjWq1KP8syl87LqtO873OqZDFVOwMCJ7CeQdunEvsJ+ZoD8gIeeGiSYr1F4LggHLcK5WTDe4iKSNAVU+0vh4FgZcTHtttUaHIFG6PLrU1Sk7Tcyx/+rF+bymplW1KXR92+aJoub+fHkkmx+636u+ImSLiJ8GCcxI4qMN1x5zQO7CHDM2H28drubN23rPJW8q9wIYGlzcaCr2Y6Ti3NdTNqb/KcRIlqnmHbnTrQga1KXxuL50mr6Clbpeft1Q4jRU7x0okb1E6tuwTgTWlzOug0DDvAPWdCxTVBWekL/8OAa2TFVyOXaILUijkLy/H5lx3uPpJcghE8xUJFKppr27ru1bXI/v5LOKHucfqfzjrdD3eFKiA+4vm8inFUtF3qmXqS+swbukldjj/1cfunjJpwmQ0651O/+WBPRV32DHUDfktfsEo5NfvDn7Y4U4m/6Ft6k7K+hOHju6cPfXGajdLYjCWWdzn1DDNisUq76Ej9aPB6kuI9/Jz5ETI51xjOpIcx5b506Qw+a42UXQDvpQoBGGAosg8KWPsg9SBlT234mqMDWdwBeL
 WQGkutkO
 LAxzE9zTyMQbr2+hHnFkuzn4Pl3xrqA106EyTIdZivL+IdvzvQHsHhFLQD2F6Rl/I+gsmWTpFp8TsF9AIBA39iFAB2fdRF39h4l9DJAJk7+LUVSz1T+aV+pjNhH6q91DEoCL55MIcz5tPlBHXB0dhHQImSmn8odwc0G18jaJ9FWOXHRGKICNh1C0lOfy7x09wc95R7+mNtw3IbwrTp84rMmMkn/zWOeSMPP+7jZUf2CZwrQ8fuz1x5RRBcxRpZ56Ia9VG5C38mEgjqHzWbMk+V1xUyLrKxI/iv2lYqd+Z+nMhx8nLB1Ndu/vKZBHH2ntC2WdyUJ1lFGpyiYMf84w7qfGBvb7IPuzTi8LNHwZs8b70f3aHbiJBziZjZ544Ij7jEmseaN98+iJvrzjUFUcDftlqLMgpcnLyu6k+XhpSm//vt8ib5U1ZDHNn2wzDOolhkzLd0Q6QdJey+6vTPEVZySgM+4bZbUUzdT+7d+TzZ562iA5dyeRngU8p2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:34=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>

This commit message is too empty :)

> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  mm/kasan/sw_tags.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
> index 6c1caec4261a..58edb68efc09 100644
> --- a/mm/kasan/sw_tags.c
> +++ b/mm/kasan/sw_tags.c
> @@ -40,6 +40,9 @@ void __init kasan_init_sw_tags(void)
>  {
>         int cpu;
>

Here and in other places where you check this flag, add a comment: "If
KASAN is disabled via command line, don't initialize it.".



> +       if (kasan_arg_disabled)
> +               return;
> +
>         for_each_possible_cpu(cpu)
>                 per_cpu(prng_state, cpu) =3D (u32)get_cycles();
>
> --
> 2.41.0
>

