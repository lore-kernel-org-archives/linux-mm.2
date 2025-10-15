Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0115ACCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8ED8E0059; Wed, 15 Oct 2025 12:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9528E0005; Wed, 15 Oct 2025 12:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6ED8E0059; Wed, 15 Oct 2025 12:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3218E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:52:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8704B749E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:52:41 +0000 (UTC)
X-FDA: 84000942522.18.DB20DD9
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5AA380003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:52:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VnDk2wJU;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760547160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcbgnDJpv9SnV/N0PbUubV1+/akvdYLhVf/DD1zM4sM=;
	b=OnqxPjWSnP+991FNzxZi0yK7vcf/5HLNHkg8CMMzt5P/3uAGWRSGKctue39rdFF3q9o+KY
	JNBDPZhROtEUKwt47KNG5u5P7bVNgUQc2O2ecsZwqI9BniY2YnlSlQ/Yl1C6bO7D9DuKNm
	OmlukyRF5LcHdIh4yXLP7a0tBP3fbLA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VnDk2wJU;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760547160; a=rsa-sha256;
	cv=none;
	b=ls2rj8P4z92Lt4qhJ5GMYKpzT2mSyq6iBuNQ4rg6UZpgoDitpdl4Y/XTUqCPjv/Ym2lOX6
	Md4jn+wvcfSi7qTO9/PvO7XOrGpTR7mwWS8oIepEb9G9Kk9FyO24SYDmd32BclOeNhYKfY
	ZpZ12lf6cQvkr1gxCNNRQpduQZnFghU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so485a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760547158; x=1761151958; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OcbgnDJpv9SnV/N0PbUubV1+/akvdYLhVf/DD1zM4sM=;
        b=VnDk2wJU6fvBmKgjZKjJXIpvoLtPt6bOcsSe+EOeCA4HU1/syFVuVFaGJbi/TOhxOg
         HvISH4X2QBN4rtrKewI8QHpvL/rGycEx/wDlV6aS9NXsRLGycgofP1y+jaEnyojYEPbj
         jGDyzg203H8zqNGIvQn/sQjtYK/oL0qFUZ3khLhJDp164CaDhG3eyGIKvgElqhwVjHgs
         IaY018Fe6OXd3VJ04CGCaOoALPj4pVkCr4ovHSOfYl/2fctQYhOS6QhOEUm8CIn6btoZ
         UVWNwUwXU9dlU7W0Zf7xUF71JzH9GStVtZp+ZPNF/MeZTc2KEz82MhXZMFyy1VL23QER
         B/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547158; x=1761151958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OcbgnDJpv9SnV/N0PbUubV1+/akvdYLhVf/DD1zM4sM=;
        b=twlbwAPP+MOasEhEUTecGWxrL7rtKKdLkisiJ6m1m7P6dcH36id4lhXdqqkRqcOBtJ
         7VpLRsADG1L3ORj5JWTW0azEKlbnY3PNk11VfYXWTwtWHiBt4pmYWDq/MfV+pP/qN5wP
         FDni/UE3jpKMym1IQO990sr/DlNjMMu/2vp2fiySXxiYdgrkAp63uy85rSLhyzuM7Ka8
         V9oRB/lVvd2mSUSefKz0sx2+ZSbzrQXaZTuvjELS9i1Td1vNhKP8BiHt80N/agCadBbp
         v/NIasejQpMpkD3m+DExNlkWIvYD8gxSU9babONwQla81c5CDEfUJOxxOV2zcGx+/nxJ
         7u8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+AfIIYohSyvUxyIiMpuV0KQsxgxFy2OYRSzWWk4Xgvyz7HEfSS0Y1I379JxIqiEy1P4mb60epMQ==@kvack.org
X-Gm-Message-State: AOJu0Yw95bXY1k3NOmy9u4Dsaw8k8vjyQrc4AWtYN8mHQcqiu0mB2N+H
	9X4yjkB0hfPGFdCdFuHWju28v0cm0qywpUg2+jkJWfr6245iDxOKjxtF3/d6YyapjaWJDJZq87y
	z3hD+HjVfC48KsMm9urYByoHfOKpb1/cbdE4YFllZ
X-Gm-Gg: ASbGncugdDwV/MG9xQXeohCVNO8ym2kBpLlF8D4XGubtVrZp6iE8hnSzqFQ0h4QMLaq
	IujQG/VgJ7nXqabVmVfEiCwgkheALcVTTMjWeOs5OEO2FsSwIeH83F13fXma+VkKP5UlEeS6O9N
	lfiQmYI5QHoLcET+Riy11g+Wvr8gPKIFQV+VSAezTZhajckEzVAG8WTmahcBh5uv65SNtpVQii2
	B1n/ykQ2cLH4GrAVAlIwQJgb7h3uKsdg8tLQqiV0mHmmyMk4lSQQQccn9YUSOKpooxhNh37sw==
X-Google-Smtp-Source: AGHT+IH9MUeZtXE8gzB0gzMSpz+7IRf3KC0PSSZ1JGtjGPGf1LK4FBeScwrLue623iT8cPsccGCSKzZw+phr82m9f7o=
X-Received: by 2002:aa7:c559:0:b0:62f:cb1a:5c43 with SMTP id
 4fb4d7f45d1cf-63bee0684f2mr90366a12.1.1760547158252; Wed, 15 Oct 2025
 09:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141642.700170-1-hao.ge@linux.dev> <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
 <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz>
In-Reply-To: <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 09:52:25 -0700
X-Gm-Features: AS18NWBHjjdZh7kEuF-bFGXPMCMj8LpDNRhw1KcOhmc29GGJ-f4cgbeIqiGQRhY
Message-ID: <CAJuCfpGgQnhjzhJw8TkCE2TgspoCz24xk1BC6OYRhNEpUXXR7w@mail.gmail.com>
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z63urptjo8pafyrc91qrgebc5mjw1r3u
X-Rspamd-Queue-Id: E5AA380003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760547159-828535
X-HE-Meta: U2FsdGVkX1/3VmJNmsKkA3L+Gl0id9fAWH7QPg8URoTjk60rKSyUvlQzi/dtXX/3EWA6cEz2WairWF3BPhQrrYln51y/1gmKyBQwLcXlr6fStWbKWaM9xndWlj/wMPksN0o+gZIO8HM4wj52tJcrWl0pUMV2PSPUcSZy2fR9cixWbhVNTI/dFLzBiWbE3pQz81GsEtSykuTPeQaLE3vrgRk3nYjBcet3vmrykBYrv/2NmR145TSRA8xEtVm5iGoH9vVh0fXGYdmS502O/KUbsehYF8WZUDui6xZe5A8BJjc2n9yobNynNwUPPPkZGK7FmrcsL5+kYYeEuBqdpOiSM5hfIT2PdfBMe65ozIoRu3luQ9pdDLGDhxsfwJS4ru1KQ9NZjiPUYHmiCUofrsvkjDNikkhPWm3TOrr5sHVrOzv+c2/VcreqTVnby3wdoE0ISK3VSngsusTMXXlaf/JnOKtH9oW2f3DxAxOKkoHo4yXf2BGO7QlXNqzaWf+t62+mnXoQFzcaSMB/FL2JCvFCUKCCH6VC143lEJ1sudZPSyeVy+T+EZ/mFJGqDBGmsUGpjVVJGejTGQrDwJA+89+uM+Jlc5oFEYwSbhBCIj/s8X3dqGNfRwo574Ts2gnG5+WUdbcawjLnOAXyq20OH+7qTd0xc3aoy/z2J2q6OzH0lcFIPcpBpfKceMFsidAQjtfrSj/WycZCougQQQZqveZcxQyaXNBhiHM8Qyk4Bzo5YVJyQXdYCSPBAMfmk4uZ4O6RDbmX5U7ol3RAcgr5Kv8lKO5II9JsIaq4Zq1fJy5br3yPAnDCdLvqPKXmoKK+bl1C0EotDVh8jkaCLyLXrWUpgPgT/QStt9oVjS0fimkxL6k+ANZUkmbzFdKUjHQqWn66owubLm2x1ZCpGaZ1g4SVfe/KBEhVl70r332+JPXvI/JR2hUw5dwKpJIl0fWnLTQPuesifj+jWT1piwAVxEf
 4pByaKkD
 NwqBDnDzqYOc8PR2KU3/T+MtaXBjg2KIHizVW2nCWlaSXEVerr7u7LZ21fH1qO2yeXPp2OZakWm+wg2+6c4vYNb5usid1Q/Fv6JsGnG48OZm766qTDFdPTtC0rvxjc1TVKKbIOgoQaqayVw4wYSEQ840INzKJoPfjyyeCl6abN16PrVf+HkS3gWwG5s377xyEZ0Z2B82VuWmx6tA9na2+Y/h7Il6fgunAG1H/B3ja4N+zroxT3ny29bc/VbrdytRutz5/nThWE1eAsnQKtTOWVnT4SAEJ0oq1idDo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 9:44=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/15/25 18:29, Suren Baghdasaryan wrote:
> > On Wed, Oct 15, 2025 at 7:17=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >>
> >> From: Hao Ge <gehao@kylinos.cn>
> >>
> >> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_=
FAIL,
> >> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAI=
L and
> >> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> >> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> >> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> >> a valid folio->memcg_data was not cleared before freeing the folio.
> >>
> >> When freeing a slab, we clear slab->obj_exts and reset it to 0
> >> if the obj_ext array has been successfully allocated.
> >> So let's reset slab->obj_exts to 0 when freeing a slab if
> >> the obj_ext array allocated fail to allow them to be returned
> >> to the buddy system more smoothly.
> >>
> >> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >> ---
> >> v5: Adopt the simpler solution proposed by Vlastimil;
> >>     Many thanks to him
>
> I've massaged the commit log and comments a bit and also realized that
> AFAICS we're actually fixing an issue that predates 7612833192d5 ("slab:
> Reuse first bit for OBJEXTS_ALLOC_FAIL"). Am I wrong?
>
> ----8<----
> From 8151384e5baf34db5812ed51e2e463796ab6e973 Mon Sep 17 00:00:00 2001
> From: Hao Ge <gehao@kylinos.cn>
> Date: Wed, 15 Oct 2025 22:16:42 +0800
> Subject: [PATCH] slab: reset slab->obj_ext when freeing and it is
>  OBJEXTS_ALLOC_FAIL
>
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAI=
L,
> But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL an=
d
> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> a valid folio->memcg_data was not cleared before freeing the folio.
>
> Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS bits is that on configurations with
> is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
> trigger a free_page_is_bad() failure "page still charged to cgroup"
>
> When freeing a slab, we clear slab->obj_exts if the obj_ext array has
> been successfully allocated. So let's clear it also when the allocation
> has failed.
>
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mar=
k failed slab_ext allocations")
> Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.de=
v/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 13ae4491136a..a8fcc7e6f25a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2170,8 +2170,15 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>         struct slabobj_ext *obj_exts;
>
>         obj_exts =3D slab_obj_exts(slab);
> -       if (!obj_exts)
> +       if (!obj_exts) {
> +               /*
> +                * If obj_exts allocation failed, slab->obj_exts is set t=
o
> +                * OBJEXTS_ALLOC_FAIL. In this case, we end up here and s=
hould
> +                * clear the flag.
> +                */
> +               slab->obj_exts =3D 0;
>                 return;
> +       }
>
>         /*
>          * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
> --
> 2.51.0
>
>

