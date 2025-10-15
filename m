Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEE9CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 23:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65828E0097; Wed, 15 Oct 2025 19:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CBC8E000C; Wed, 15 Oct 2025 19:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52A28E0097; Wed, 15 Oct 2025 19:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF49B8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:12:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10DC7140111
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:12:24 +0000 (UTC)
X-FDA: 84001899408.21.EE45DC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1296C1C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:12:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M37ZrIlu;
	spf=pass (imf21.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760569942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLeqZjJLHMBm/ynsQf0/d974wt3NoZYn/v22cdH07Co=;
	b=yU6d2YTE1ByBTPt2mLkRNcZJ8DDlMh/lSB8rMxAs709gLkudJbxOG7J7DPBSGMJigoC02M
	EygmLlUbQpfseEZHiFTxoLSeJHVAQ6yV5trSArX63KqupjU2vSj90mXO2pPMzDuS4IplNj
	LkixXaKXUWUn1XpYFQwzAKI1Sswr4uw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M37ZrIlu;
	spf=pass (imf21.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760569942; a=rsa-sha256;
	cv=none;
	b=Cp9HS+LaBEbcjjQf8a5cfHeKbxMH1gMYv0sxuY1EbAw+t0xUgXN3wRHAxVkRp55BmsNZEz
	J+UxW4zhYbTk8p8IBTARFV2z4WaZTE9YEm/nJzG+C9wKXJkTvlJZs3eEIv8rQHfZ5KR9SJ
	y9ZVriH4i0dHbMe8bF/Awl8HdbyofHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEE7A40233
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD29C4CEF8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760569940;
	bh=r44UktmLfbn87icefxwzup3DZAKCpa44gU2sA9H0npw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M37ZrIluwq5EeNwUaKS8VbE2fDg3ZFE1Bt8q8AASK4XuvaEBY9UHPgrR6Vo6hQTvO
	 HwjHoag6GWY3w6vHPNSMU/2soplGUj7M/aZANKW2HEZLqT8xeoo4TJqyupgBGMoUVE
	 NDvWoRBjbJZ9ALVMRE15YaBgrDcdI/Bf0bv4mMbNYj8uU5LCFxPKgFYMDazmdZmWeL
	 h2oBkg2tBO1iQlyVZBtk3uTFGK4OfKV1yhNiV0cJ+5jgVr+MAIDwJbJqkWCBuWJ8yY
	 ZVNOmyFKaGGYjWuBAq/23b3P+Kl4MqNBbwsdIL3XK6p9ghk/HLQ6rHSeEhaKHvKUTi
	 Rb+Nf9Ho011+w==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-81fdd5d7b59so2231766d6.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:12:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUhsi1JniDDBW1nXyB5uPd2wYAGNddPhUa0k5eM+4rZBrVwtKIJcpfPqROuwfLTq/SCzf0hqGSWBg==@kvack.org
X-Gm-Message-State: AOJu0YyZOqa5zBrGaa+7HcXciuj48qWpCkWRVQqnG+PRoI1grje2oVrz
	e5WNssc1PJn8M59dVu8h9wgfsCQEHRYPkFkNc3r8dJWL+Dh/hZMnP/cdDIytk8mXTOpVQpdNyiY
	VU4ng4M/Xma0uqZO1CQ/uWUyKwI7leTI=
X-Google-Smtp-Source: AGHT+IFLrZdMNDEHSuM1l+l7K0Igp2TgGHURmcyfMZduSiR21b8bfTpAX6I0Lw+bgngZoJ0JLG8z/3PI1EZqoF171Qs=
X-Received: by 2002:a05:6214:ac4:b0:802:7214:5bb with SMTP id
 6a1803df08f44-87b21031efemr529272216d6.28.1760569939755; Wed, 15 Oct 2025
 16:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251015190813.80163-1-inwardvessel@gmail.com> <20251015190813.80163-2-inwardvessel@gmail.com>
In-Reply-To: <20251015190813.80163-2-inwardvessel@gmail.com>
From: Song Liu <song@kernel.org>
Date: Wed, 15 Oct 2025 16:12:06 -0700
X-Gmail-Original-Message-ID: <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
X-Gm-Features: AS18NWCRhZ0HbfQIAsuNZF3o7IVIRRvXVmXcToP6BTqFWLZSUci3-Th1d7PMPqA
Message-ID: <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
To: JP Kobryn <inwardvessel@gmail.com>
Cc: shakeel.butt@linux.dev, andrii@kernel.org, ast@kernel.org, 
	mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1296C1C000C
X-Stat-Signature: fj8uoqyqb95tftjrprthrpffa3e6uekp
X-Rspam-User: 
X-HE-Tag: 1760569941-259718
X-HE-Meta: U2FsdGVkX1/HeR2j0e5PQAtICUN2St+rE4wOMtttBOrB5DwThPIjsYinK9FIbwx+Qgh1r560HJ6+XNwlTq4DJjoYlsaBuoCug21wJ4LavhnVORFKAXrTH23BRoVMHgJIJ+cnirxWZfN70mm5bWfrSHkqX5CNWkTIok3WpV9vsGYppmcR+eLwI1FDoDB6IkFyIimwvvLM5WaasINxxKXNYWIlPRJJfoua16W4a0tt5gB8sT0uQ7SDBRvXxAsL6bv4ItK3DIAg7n0RauLOXYyclmdNB24Go8et4C+MZ+twZB1fc7ctlOM/VRBcXlk9IIl6uTqpeshE1m0jxdBxZJKCvbxYBitXzgkRyPyXMTsf7COm0Yy3P0hAZgVagxEHsED+66XoVyB3OqkfcbQLxBAleUH6QVnFe5ByJFzRXGbmhtb98wBFPuG+rGbpz0GDcWFuy5hP7aQOXfQGz1MD8r4bpbVMZB534sP16RymYvwVvTdjbGJBoJO18ODo7qvp/oaR+4LcilZgjS5AJt6m6K9ia2qs1FLcVpl6NHoizqdQhdwLHJoHZUB20dkdnDrfJiuSOg/MnKBdZ2uIKjRV7cy/kvwfgoc7/64Cuus0UwVTRYLxolTS6j7pwf3zlQPsAHAAyYObebsvN13AvBAdZJqOK/B87LXTLWMXBJTbq8mWk/Dg3K81WkxG2T2UOW63TF09sCx52HxlonGDxwk4UYvafdi9haVgf7Cff689NyalQPuz97wfkxcEvbAevFc0E6dAu5Q3MaKKSyz68TK/IbpKrz09jqJIlledXazYeX+g9d0uZSHUA/fMLNXrprRfh2OzYVo8AxK9LAf7z3Mo3FgQaEOGQ668iTC5fIPI2d0mRYNPdhZs+RISDL5ZvfVvPHAXc5cSi/DQtdcYdNjGVFh5BQyBQelVS08Q+M4KQd50G6yHIlhRHk86FFxy5niWABluChU9mrXSJr/2R9NDIsK
 HWetsvCF
 2Rw6mEn+T1G1K6p0gl++EKX1Os3QmazSpouPG2ERQUIblGt0JsDR0CY3Vtcyr67m4m7ux8596BnwEbf2gblfrFpycFTAWDbi2d0SXQSQgE1nvI1TH+bIc3ZkndqNj0Y/7pri7pwa3IIMhJUyDxcCRT93gq4Smo5UHpJJgAzow8NuXgfW9b9uS3tAqh/CTscXoIygcTim9Nv5LsbtjNeIp2wLKNquhZThjsMvF/fqOhXo8AOjlRTPxjdUuB2fNJ3mS5p/ckZfSGcz+iSVtP3Y1GxC8YqkQz6zg3q4/uo9i9wHSHAdzEweM/+Oz0GN7r2NiklTsP0X86Szn0JX61ZDNvTzJcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:08=E2=80=AFPM JP Kobryn <inwardvessel@gmail.com>=
 wrote:
>
[...]
> ---
>  mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4deda33625f4..6547c27d4430 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -871,6 +871,73 @@ unsigned long memcg_events_local(struct mem_cgroup *=
memcg, int event)
>  }
>  #endif
>
> +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
> +{
> +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) :=
 NULL;
> +}
> +

We should add __bpf_kfunc_start_defs() here, and __bpf_kfunc_end_defs()
after all the kfuncs.

> +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)

We mostly do not make kfunc static, but it seems to also work.

> +{
> +       struct mem_cgroup *memcg =3D memcg_from_cgroup(cgrp);
> +
> +       if (!memcg)
> +               return;

Maybe we can let memcg_flush_stats return int, and return -EINVAL
on memcg =3D=3D NULL cases?

> +
> +       mem_cgroup_flush_stats(memcg);
> +}
> +
[...]

