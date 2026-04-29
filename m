Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF17FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A6D6B00A4; Tue, 28 Apr 2026 22:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB5C6B00A5; Tue, 28 Apr 2026 22:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB046B00A6; Tue, 28 Apr 2026 22:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD96E6B00A4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:44:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61D9012056E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:44:09 +0000 (UTC)
X-FDA: 84710049018.07.D635E1D
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 701144000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:44:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpHFoB0E;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777430647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+KoLGDSrHSIZG6+XblKTC21gPEBzNKAEyUWN1fUvUg=;
	b=RSpEX9sz3j5I7cyVxpMrZUYY57nag/UoVZ8lSwPZfTBiD6/8KSN1nze3fBNVIlNLGwS0qV
	aEtkJbY8gI0NmUW9cJxe9ySeyE7pvKurnkSIFwcBeX9GE2UlXZxMBTORgulDWIjNMoQ9GX
	0OPN9AUWfM61krH4Gdldw7hM/uNvviE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpHFoB0E;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777430647; a=rsa-sha256;
	cv=pass;
	b=c1IeDj0ZxD/hdhm1OwaTzzRzhWcTxY3AJ/QhBD5qIyihwRn0XfZ3hLoC80GL88QB0mPVSc
	qjjwVEGSw7nmP4ImAPE8tsXqr/WOoWmu/1IeVWDdGkxgiigADnfWISEL47EKRxwS/2wi2m
	WNrSiRj6FuG07CdIXgR+UpXLH/9yjTM=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7986e0553bdso119038797b3.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777430646; cv=none;
        d=google.com; s=arc-20240605;
        b=TlZLBuuJXd24sFa8yEJyK2UhbMWqjWfxPXUMbfo4zY1ne4zPs8pd8GDM8JXVJ+n5Ym
         5xrmoOO3q20F3+Fiwfm4bZb2b5llcHXHrpomuZwgdnMj2emTPzl8FrfsROi3Wx70Alfg
         Hk8pPXaKrB9knELS3bWysf8sIY2xc/EueOiLq1zTTV42h4dV9awQYZFYn/a9NtScG5P/
         hvDUvPnNdSFgj2X4h7wEDjAh58PXhzQ5d7b26NwCSo7kyTqUP1vpA2Rm7iSGmfzFAfCR
         ASuPsGXfAsQiOR1Q/OxZMsVsCIMLhWx3uHjZ5FkfHuqsQ+0UDTsNx5/X6FmhIqSiB4IN
         MF0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q+KoLGDSrHSIZG6+XblKTC21gPEBzNKAEyUWN1fUvUg=;
        fh=vIPOUXYUdAmhZXvAvbZn0LQRS4FIJTCEGEvqYzwm6Hk=;
        b=cSU2KN+4APZs1xLM1CRqExSkyWo7gA5cCCiHSUlP2LZlpov139lX/vvK7BmXy0CXkt
         a98NdE1vADf7YAav/bF6op0XGxDcaDqAxViaPHMylUrcIuwKy6LCim9iYgkxCQ1ooa8p
         QnoBuoFyh9OxluXnyJdPgtMEVi1hIi7IvE5/ZUQfLK0whqZdbOe6g/kFTVVY//5937Ty
         s8Gyj1D+6IRAAPyhEsfUcd6a6YNI+oCHaRz6a675CEK/oZE1eHADt9LIjnrdZtbX08bO
         HD9B8HrXq8wf/StO5EEE2UFoSeevqs11Nhbzpt/I9x0/h/DpxAeDf3bPBZDe46mNU096
         U/ZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777430646; x=1778035446; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+KoLGDSrHSIZG6+XblKTC21gPEBzNKAEyUWN1fUvUg=;
        b=jpHFoB0Ej6yIxMBysSMRA5UfQazX1oePsFwy3nY2t+iwUBF7CvOYY/0Ijb3ymyNQhH
         +QeRiBGMmPYfqJgVTpWZ3jv+ACZ9vMkFMogS8KDsTQOaYMnNEgKfRYdVyLMyWAwQSoRp
         TEFsiQiHgnvj9f2HttnWI9LYUXqDQp4YIfqDs9bcTx9f0kNzHmobd3/odT/SKCXUhDMf
         Y5gYJzlH8WcQtjtw/2Y8jTVJ0XpiqEK4fPwGga3ouJnXaXYy7iLBmC1cUirP0wbkBSm9
         5BfUHFK+h/PuKtRWIbw6nN++KLY+PDcrRpinVhKdYTFGTSc5Tt6RZMyO82vT+lU7P4bm
         qhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777430646; x=1778035446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q+KoLGDSrHSIZG6+XblKTC21gPEBzNKAEyUWN1fUvUg=;
        b=JpkBvLVYszs5OttBRKxlfNuv3dgswpDoedRDctzAWOKtXsP1ezhGVlzjU/lWuljp0N
         vNyRJSh5O9/443jC2YfLVnE2GpNRrALgAdtxtm08dGAnEbgxVd9vDpPq9fHyHyneSSel
         Li2f9WXooNPJZP0L0ydS7YQsN4pxZ39ftPZV/lfEws3JW31zu+rr68VHHdv7crl+OINx
         gRz/RCx/geUfMpCbSZIl9CsAfhblsDN7iDnX5mttCtnhMX8PfDZJ7wCeYGoz7/5MsbIo
         TaksZuPNL92wmN8XIKryshDsw1Zxj7FDn7RF/tMfRHCn1nk8f8iDWyhDsM/+xyazoWAy
         svMQ==
X-Forwarded-Encrypted: i=1; AFNElJ9dbpKHncQ/VUhtiIQ5PZy58/fOePojrOfrHTutcVqSgVcKsASqOwtG6/oYpQd4/9PepFd8mYSzuw==@kvack.org
X-Gm-Message-State: AOJu0YwZFa6UlznvWl8b4hlNPOx6UJbzy3bjWrk0JVLHAtCwmTPsheyw
	OqthL71klgg77LKlraV4LrxDSMNXpfgXBEc8PJtC1WFJM698tnlNJRtZapDIOQFqUFRyjQHbcZh
	6PgwceAIWz6eIOt9G1KMTLvG4EceipVE=
X-Gm-Gg: AeBDiesk86HIxafff2eLI7EeD4pwY1tMTwUPxJ6kYzNfRuxkh5FXfxLuUYrOEhAJjgF
	ozLfrNzyK5oUMeAH82iINMdKTQqpZLYvuJOSuxnVzgSm5bfwAL2UOcIi8KJtzkSeOgZG8971qcG
	ZBpEPxf3JA708/eKRm0vat8Fznek/74bC7P4bDwVAr9UMauBzhlANGWKN3AjMhOpO3wtKMnUG/G
	vwxyiEk6wbOD1g/n3j0iT8/KU3MqI1d9G7k3IhxoIlHxUZDmXmm9MYAIWo4gQLaVwxuoAKMKVzR
	VsvGfeGJKYgI77sGO7uoMn4R9mOnz11mS+YSYOkMgsepVEaGyK8=
X-Received: by 2002:a05:690c:e3c4:b0:7b2:9347:7bdf with SMTP id
 00721157ae682-7bd1dab7ebbmr21814177b3.37.1777430646358; Tue, 28 Apr 2026
 19:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
In-Reply-To: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 29 Apr 2026 10:43:29 +0800
X-Gm-Features: AVHnY4LELreyRpJUwIYExN_byZ7hf2FVYTBc2vbJPsf4Yl0K-6feZLhlmOKYcHc
Message-ID: <CALOAHbDFvNLQi4xOBj2vvTng-vT+X42NtsCiuqHMt1PTpnxAyw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Using BPF in MM
To: Roman Gushchin <roman.gushchin@linux.dev>, Song Liu <song@kernel.org>, 
	Petr Mladek <pmladek@suse.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	lsf-pc <lsf-pc@lists.linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 701144000A
X-Stat-Signature: 7x5s9xdwgcnfxseyy9qhu9zkp7jd8sjd
X-HE-Tag: 1777430647-952685
X-HE-Meta: U2FsdGVkX195aZ90jN7rQiD/Wn8jD+9YW7K+57oSizoLjlrqGU710CEXjegs3igyWPC1c++2rJ0o5YY9hE+fc2fpBQd66/uvbPQyvqaScgsjN0qH4xOe1/gLjClMONLV1T9AUIiLncjGfkbPCpvqVbpdm11Y1dav/XteacMixt2UbCT0QS0545S6VvYaDpP6AkzSkT83sGFkIlcC7W+bqCHa1XUFTJ7jrGogYa/eTHL747kYN6jEC5GWNe74DprHIHD66v0wXg6gp1mwPw6HwKxFn61dOZgnBeXC4tP3GGiEXlybuEoaEHdcB7KeJD9mGv4wyf/rvciQq/VByvb7CrAiEvxfY90sazLaszh1Hx29/lGcfsJv4oahurX/cT8FklvtKqeclU3JVkbFTNn9RSoRh2rIMLvQ65kNJjnsbqjuZHodFMMV3pXpDlIgOGXl3+KqClUHsZczBLBVypnrrf1MDz+OV2rHh/rIQdMuATwFiLxC5U3jU+ltdRMkpdLwaOroSyZ6S/Wnmpc7H46vs1/ZEgS73t0HrKmVl893B5yRt7QifVOykmGlFUDJ2vv45bBbLlZhuEMau4UsofWPBZHeCDXWBZbggfDgmGh6gojJ1RxXvmwH297JYEQRWX79ipy/1Nq4Js1PWWwbHBTD1W+zgp1qqemLQdeocv+19HhOGbdaoT+kMtlhD3ZT1143ROO6GywwFiwc7sjhBzR19IPM2u7fCkqwGGdJV2+K7xDYABKEHHCTDdtzbR+4OoXrI6fZcBgXNqX5vmPxTvgeA5jJ49louT2JNrAlf00kbIWljZEUQFi6Dy+erMu7DL2BhhMps/NjpZty7PexpG9In5WQWqP3EaGFwxmsuAnb8m4CPNQiREvDFXT7it1bj0o7ZCd2VUPQUaTm8PgSiRP6vg/fMzltYXq06v/lrUCNX5ZMVjxn5ooyfiD7GslS+BKYgZfKEG+NpxiUhKSBra/
 pZg1x9xX
 NF2NHnwI+dUCH6Wct5R3o2ilko0njINf16qvK2oz/sFZQrFWqNUJ/ZYfQypexIIFV/9FDgtPBZMQ9SXyj1ZSRw8Gbu44j7/a3aqb5SiwKRUWawZVwk/iIWpiYl81hn5NtsezlvCTPgC6WAiP3mpEFt1GoQTGeYzYbRcVf2gG/WGl+BVRRMsUN5hzmBVzNfKfPX7lc9zrTKraS3Q82bOGuQpgQ42rPRObi3Spj1UX96PFUCqwgLYWXDk6mFTiCCT7gxiUWG6PobQHVSF2V+iyt0ZFYYgmoYCq2dJZXyEPQ0JFtMEFoM4LcffweeL4NtPWkdshYKL49Tp5CSUsmmga9Is51v+9TW1ucd6+TkF1Tjog+KF3OytW/KprItVZyJsYSwD3ClHSSQNg4MD0x0ysWarMEvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 7:58=E2=80=AFAM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> [LSF/MM/BPF TOPIC] Using BPF in MM
> ----------------------------------
>
> Over the last decade, BPF successfully penetrated into multiple kernel
> subsystems: started as a feature to filter (out) networking packets,
> it captured its place in networking, tracing, security, HID drivers,
> and scheduling. Memory management is a logical next step, and recently
> we saw a growing number of proposals in this area.
>
> In (approximately) historical order:
>   - BPF OOM
>   - BPF-based memcg stats access (landed)
>   - BPF-based NUMA balancing
>   - eBPF-mm
>   - cache_ext (BPF Page Cache)
>   - memcg_ext
>
> There are some obvious target which haven't been covered yet:
>   - BPF-driven readahead control
>   - BPF-driven KSM
>   - BPF-driven guest memory control
>
> Despite a large number of suggestions only a relatively small feature
> (query memcg statistics from BPF) made it to upstream.

We are exploring an alternative approach that leverages livepatch
combined with BPF to modularize struct_ops-based kernel hooks. This
allows us to deploy these hooks as out-of-tree modules without direct
kernel modification or the immediate need for upstreaming.

  https://lore.kernel.org/live-patching/20260402092607.96430-1-laoar.shao@g=
mail.com/
  https://lore.kernel.org/live-patching/20260416001628.2062468-1-song@kerne=
l.org/
  https://lore.kernel.org/bpf/CAPhsuW53pymgmFsHSkSwDvEAJ=3D+Rp2T102JYe4i9kg=
dePpR=3D6Q@mail.gmail.com/

In practice, we first introduce the BPF hooks via a livepatch and
subsequently attach BPF programs to them. Below is a recent use case
from our production environment (though not MM related) for reference:

   https://lore.kernel.org/live-patching/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh=
1gy5hy9Yqgeo4C0iA@mail.gmail.com/

In one of our clusters, we needed to route BGP traffic through
specific NICs based on destination IP addresses. To achieve this
without service interruption, we applied a livepatch to
bond_xmit_3ad_xor_slave_get() to introduce a new hook,
bond_get_slave_hook(). We then attached a BPF program to this hook to
select the outgoing NIC by parsing the SKB. Because the destination
IPs must be adjusted on demand, a static livepatch alone was
insufficient; the BPF integration provided the necessary dynamic
flexibility.

To fully support this architecture, several work-in-progress
enhancements are being developed for both the livepatch and BPF
subsystems.

+Song, Petr (CC'd for their expertise in BPF and livepatch).

--=20
Regards
Yafang

