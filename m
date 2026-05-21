Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A50CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3985B6B00B3; Thu, 21 May 2026 00:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F326B00B4; Thu, 21 May 2026 00:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2851A6B00B8; Thu, 21 May 2026 00:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 193BB6B00B3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:07:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBA06160439
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:07:48 +0000 (UTC)
X-FDA: 84790093416.12.5EDBB97
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id E11422000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:07:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=Czp3AN9h;
	spf=pass (imf03.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2hkMG41D7UumAODedFGWVazHZhYrfBwUFGTzkSTLig=;
	b=LeaMOifXLfG5WzfpxMmU9sn2JKpUE3WdsjlehLktxnPLIbRKIhOMCAQMB4mutp6hQhzCHG
	1+3+0WknnEKn3ArrQZwrxGBlDbnPQSc3GRtBL7hvZODVwHBqK+SNzb75Fjc2ZMpi+PqDEZ
	Y6YghgNDZ5J1b64ldCmTY/ss90C8W5o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=Czp3AN9h;
	spf=pass (imf03.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336467; a=rsa-sha256;
	cv=none;
	b=C5YA97vUFQBDISlrYH4u7ZzdAFgc497kM0cl5AOmhixVCpKq9mYKIxqxZ6CP4TFQ/DuS3c
	U2CKYr8I4f3J521WkugkgGq1kdzfgxVxMEeiq8h6h8h67K456ogcbFsGVvBHbjgJsFlAfA
	Zl+vnw4ezqHWwtF47LE9sarU7uDtGew=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82faf871346so4392090b3a.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 21:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1779336466; x=1779941266; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2hkMG41D7UumAODedFGWVazHZhYrfBwUFGTzkSTLig=;
        b=Czp3AN9houhupXi3NTH/v8wz8nVaY1rUkRu0w5O/BW/RR/VXUntj7DCeH96GgdD6ts
         ZJO70INlDqyvFIYNt+yxXzS94wDUsqDjXprmOHFApmTp6RblxPJ3Yj1sJU7OoIboyRNg
         bDtBLixumFlrF7XcRG3l87NeSefiYuCQzHAdD4+8A4hzrUWi+Jc9DsMu27JMWce53MuA
         DAC05D/qgQaW1+3R1povAFqbpsNDTkB+b889hxNQPphDog6CfFJYgcDncgg/7VgxVelA
         uCcIXaKKB9AuUIrLrwYoShrMS4RwPThLRL96/jHgB6dEYKZMNHwwyPD52y8u6o31UAuW
         YVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779336466; x=1779941266;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C2hkMG41D7UumAODedFGWVazHZhYrfBwUFGTzkSTLig=;
        b=IYaQYIcONz+hoqLg38tRcFiaaYDDDXLLINDIZCR044o8PeHrzx3B3egaU0SvxD+tLc
         LmofLmZ+caBUya74vaETdjvMGIjteorWvByffKmgdFJeRXfB+UIamSkC7OQMjlL+qvvl
         3pjtgM/6dHcTnOmXsrk87or46gHIzR9GSlFqPnZumMkN60w5B+6kKl4roKI0MHumbtge
         XSpr58ViYoWRiAGJ5NtwuxCNhp++/fe5VEyhE+X0tZutGSWadmETV6TytflBggaeIg8M
         2/cv0vfJGKaSH6xeip3WYWeuQwT9if3yA+0RhE6Ktwlxhwq5NIxfv4sTVo7h3jHcvy6E
         3riQ==
X-Forwarded-Encrypted: i=1; AFNElJ917R6t6YEHdptaBiBETbTgg3e3ahLJcw0pX0NdXUAtmh2QSeh8WfXFoEczGy9+oRkoEBfXEwMVWA==@kvack.org
X-Gm-Message-State: AOJu0YxQVjSoqxsGCAoTWhjy1yWv8JygnmslBq4thzQQi6GdxcQkSpx+
	eSKb7aj2AyOJyKsuv+djNTIiVKlDnR23n4Ep5XUOtTBfZKV7/qp6joH1FvJu14SpmW8=
X-Gm-Gg: Acq92OF4imzw6yYcFqMXosnJuef6Q9P5kqL2qnERkRyex3jcYtsX++5fyqQiy8MNQM5
	riDD/mWAXqh/NzGoTwxzgO+11I1BBI3LwXrddnRSJtobCziWDDJYztmUEqmIPbydnv6fn7ftRrK
	gm6ZsZmB1+jUv3U07u5YGvutHy8/faC7Gfm1JKkdphHmEpHnWVildE7amAiUhirFPLQF1l6Edqh
	43QDiDrLfxCTTFNrH3szQGjMWXXhvKABBWFUGVLeBvlW4fgvWt2muNWA9wqw/1H9NFy+pZ6xU83
	XmmfS+bO2RjC9JWjsFFWFF7D8F4LAi12Wpo/gc5BGFN2kWj/f3EQQbtRV6cBjoQdIk9XZ22z2Z/
	m7FPIfwbu8WPHz1Ew9/fFEOOyACtmF7CMqP8VfoLxcFRcCfWaz75h4v9vgeDs++9M9+wqmvGgLP
	ikTgPfD/4MckXxXoeScyo6fEiQU7ocHdbwTCM=
X-Received: by 2002:a05:6a00:4c8c:b0:83f:250d:59c with SMTP id d2e1a72fcca58-8414ae6e912mr1347583b3a.39.1779336465527;
        Wed, 20 May 2026 21:07:45 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19f7cd19sm22757564b3a.54.2026.05.20.21.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 21:07:45 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 00:07:44 -0400
Message-Id: <DIO24V5XSTSW.2PW1QDEHN0T3M@etsalapatis.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] bpf: Add bpf_struct_ops_for_each_prog()
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Tejun Heo" <tj@kernel.org>, "David Vernet" <void@manifault.com>,
 "Andrea Righi" <arighi@nvidia.com>, "Changwoo Min" <changwoo@igalia.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-5-tj@kernel.org>
In-Reply-To: <20260520235052.4180316-5-tj@kernel.org>
X-Rspamd-Queue-Id: E11422000C
X-Stat-Signature: 6mxda8bniawe6w3f3xtuqnw9y1ktgwqm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779336466-296222
X-HE-Meta: U2FsdGVkX1+yBjhofOgVxmNBjw+RaudlHPxPqjOU8NhJlyLBoN0KKuI25gIrc5jzmLvG21kzmg9d8Av6bVZvnr8UYuYXTwtxZ0n3YwCFDq485V8u+z5YmMF+LogWsjLIUFFV5WQa+E2icGP8tHcxBTZUepAZrYgcWVBZ/yiVUUIfosMvARtfJCrp0nWBLF4ZCfzWrPg+ryM/xHi9CjglUT+Y8sYpIWqQisz6hAJ/il2IgDZR3FqQUnPj/k4CokWufZ8jnp/3ZefLwUrBdJ25sNptCLdUyOeY+gN/0QhcpKVXkymP/1t2gMpfo0LJbac9797LgRKH4G3Jq5CBdaMwIEqvGO2bZpD4KDrhn1vmbzQTEJ6uoqPltQ/mHMDNX81sM3grx1h2d2JXs4wH6QrhaLTASTdrxO6S1rxj/XjuFKmGa0exFPYEQr62VsEeuGvF9RtrBBA8GBl57WBAdCiYo2PptrsSxXGQEa+9993LpSvXpaor6VnvlpnvkJ0xlE/C6cwapYyUO1nk+4t7Y+hV5SXwsdQARdEXgXGfKnpbdN6BjLA2gRt1i6GaywXDuzbxXN/YYFB+SfWEMhfe0hKilcfgJSkOJe5iCOeesAGR7one+q8EZcnTgJV0CKDPWZZCLK73HhdRndrTOE9D2DGUsgNASs7gK7EgfbaVfwG8/MS4vMJ79nO+FGbW9MUMWk6qXq6yBIkMMKFQXQTeDguo2jgXzcixuLOqvsr/UbBOzQ7yJzwPv/Jz3D+8ExI59pLGa9VqTd+7NDb9t3nEVlwDtmhXvNM3fRZa03cxKx1yySgBVHmBysEIarZEHPbVrW6lSOcU3HQ8Q5uQPOx0X6GRuAWfd6ownn1n1y1+c6utBn5A3isoCi7NgDiMmpe2SOaCUvKldvBIbKiWZP/wTkyNaA9jcuj2Gj+NOoSHhd5zazzRKzn7BkeN9kcMpy3E880U+aQyvHu/uusnpZTqKce
 Zq64YUzY
 /Hvv2jlTA5AcvTrt+P0W+olmt9qKnklCr2vVFC/TNGq1uJeI0jkQalN81ur76F+fcSUq28b56E/97DroCzZwiBF2IEZNm/zW64pGWKg0/E6WmJ9uHZmwtiTm3zzWRGizKxZP8FvA5e4xrOIBGkzoQKIiL35+rVuOvgkwBhiGAFgSUv1volrj5goFfObtT3+qSR8K8CJT2g8AtCAozUgMkZX17aPsNYCB9OTsWP59vYmAiHAf5vocp+SbHy+ILG+tCrQ0/a/XPvC3+7mCglJ7kmB6vMF2sY0WyZzeiR1wFG5ierAHErYZIOnBR5H/vJDxkJ/WMoFZoUbL6yFTA993gmUofCn62oyeUmmw7b/MFrllpyeSoIXYn5Dze0/6K9efUKF122fEw1PBztDc0Nauvj0dXM2tHjG0AMGTbbx1XIHFlzduTMh/MHQENUjch7B/9kdZOtXKgoqi2iKlSi8WxX1MWoQH/ODOKYEIAU3dJbfwFtgZbWJ54ppZu8v9i8r8MzS3hVOJX4pDxv5JhD0y561co/I1ebsjmmN+9Xky53FTrvEDurX79XopSOX7dCZT/SWn2FXpyfppBGgTByTloUeMJzeAlD+k+x+HlATL2vUGRlglMDZXi4ZADvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 7:50 PM EDT, Tejun Heo wrote:
> Add a helper that walks the member progs of the struct_ops map
> containing a given @kdata vmtable. struct_ops ->reg() callbacks (and
> similar) sometimes need to inspect the loaded BPF programs, e.g. to
> discover maps they reference via prog->aux->used_maps.
>
> The implementation mirrors bpf_struct_ops_id(): container_of @kdata
> to recover the bpf_struct_ops_map, then iterate st_map->links[i]->prog
> for i in [0, funcs_cnt). Same access pattern, no new locking - by the
> time ->reg() fires st_map is fully populated and stable.
>
> A sched_ext follow-up walks the member progs of a cid-form scheduler's
> struct_ops map, reads prog->aux->arena directly, and requires all member
> progs to reference exactly one arena, without requiring the BPF program
> to call a registration kfunc.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  include/linux/bpf.h         |  3 +++
>  kernel/bpf/bpf_struct_ops.c | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 64968ca6db51..5b99d786e98c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2129,6 +2129,9 @@ int bpf_prog_assoc_struct_ops(struct bpf_prog *prog=
, struct bpf_map *map);
>  void bpf_prog_disassoc_struct_ops(struct bpf_prog *prog);
>  void *bpf_prog_get_assoc_struct_ops(const struct bpf_prog_aux *aux);
>  u32 bpf_struct_ops_id(const void *kdata);
> +int bpf_struct_ops_for_each_prog(const void *kdata,
> +				 int (*cb)(struct bpf_prog *prog, void *data),
> +				 void *data);
> =20
>  #ifdef CONFIG_NET
>  /* Define it here to avoid the use of forward declaration */
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 05b366b821c3..16aec18ed31b 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -1203,6 +1203,42 @@ u32 bpf_struct_ops_id(const void *kdata)
>  }
>  EXPORT_SYMBOL_GPL(bpf_struct_ops_id);
> =20
> +/**
> + * bpf_struct_ops_for_each_prog - Invoke @cb for each member prog
> + * @kdata: kernel-side struct_ops vmtable (the @kdata arg to ->reg/->upd=
ate/->unreg)
> + * @cb: callback invoked once per member prog; non-zero return stops ite=
ration
> + * @data: opaque argument passed to @cb
> + *
> + * Walks the struct_ops member progs registered on the map containing @k=
data.
> + * Intended for use from struct_ops ->reg() callbacks (and similar) that=
 need to
> + * inspect the loaded BPF programs (for example to discover maps they re=
ference
> + * via @prog->aux->used_maps).
> + *
> + * Return 0 if iteration completed, otherwise the first non-zero @cb ret=
urn.
> + */
> +int bpf_struct_ops_for_each_prog(const void *kdata,
> +				 int (*cb)(struct bpf_prog *prog, void *data),
> +				 void *data)
> +{
> +	struct bpf_struct_ops_value *kvalue;
> +	struct bpf_struct_ops_map *st_map;
> +	u32 i;
> +	int ret;
> +
> +	kvalue =3D container_of(kdata, struct bpf_struct_ops_value, data);
> +	st_map =3D container_of(kvalue, struct bpf_struct_ops_map, kvalue);
> +
> +	for (i =3D 0; i < st_map->funcs_cnt; i++) {
> +		if (!st_map->links[i])
> +			continue;
> +		ret =3D cb(st_map->links[i]->prog, data);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(bpf_struct_ops_for_each_prog);
> +
>  static bool bpf_struct_ops_valid_to_reg(struct bpf_map *map)
>  {
>  	struct bpf_struct_ops_map *st_map =3D (struct bpf_struct_ops_map *)map;


