Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 851B3D172CD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6D26B0092; Sun,  1 Feb 2026 23:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A843F6B0093; Sun,  1 Feb 2026 23:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9868D6B0095; Sun,  1 Feb 2026 23:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 858896B0092
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:57:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39EB1D51B7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:57:05 +0000 (UTC)
X-FDA: 84398307210.29.6C8BE35
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5268D1A0008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:57:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zt6AZJRt;
	spf=pass (imf19.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770008223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPRgTQwJ4jsKG4M4C4YQuYvDcSDNXuHtRvocKp3Ffdk=;
	b=CdLLAFVugOPEx89CY7raXfcxCBcCs1v3QWIflmVT8Ly6qLxLlMdZf9uliK9OhroKwuKfGE
	r6mq1WH2nDzqNPxCDcNt/wZkmMK265ej/cZDbhPudDDbuVF0S+zcAQPzXv1tN2bFpCuv6r
	RQMqQKskbk1QCtr587eWgaxqfSkNxsc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zt6AZJRt;
	spf=pass (imf19.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770008223; a=rsa-sha256;
	cv=none;
	b=jxbTIQSNdz1kTvel8GEBL04m9ZH1mnBq7o3X/jEufBnO1nRLpPFS5H33Uv26+vMPoIc7Yn
	SV6o7KwuO5a35kbYSxSCwN/eSvy+UelQX0wLZwrvDyrfYUHOLdbumzShjUe/M6gZTS51tr
	oyGkgIR+yHtCTbBi9WdvaezhUVMHQvc=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8845cb5862so630153266b.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 20:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770008222; x=1770613022; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wPRgTQwJ4jsKG4M4C4YQuYvDcSDNXuHtRvocKp3Ffdk=;
        b=Zt6AZJRtRsYX2BJQOMWRjTvld5kSTIj/WVgJqd4UvNxhVl43b3bHOdUSniC5J/FunM
         dQ+VsgR3B3mG/wCdORwSmueB0JzUkIKoJxmG1vLPCocQmudFcVUr9tMxx0vwm4s5uUAJ
         fuHNABbOBvVeSJAkQjQ2w7szgEOgPMYfVaY9yUNpSL+/JiachzrMSiNkPiANTPITDsqy
         16twZwWvQGA2x6gKxMfEZNOAiH5wAAdY6cccM1u+/wvClbDMLW69yiB8YhunjvSH69vq
         QcVQK/GFDc0Ainn6SY+E4UQdMbU9rdaxmoWdZ/KzUr+7J5D83kMwOkwGkafaI2Fe829F
         GT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770008222; x=1770613022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPRgTQwJ4jsKG4M4C4YQuYvDcSDNXuHtRvocKp3Ffdk=;
        b=eVdXqO7MpKQBMEsBFHkSA+/umODLGe50sCeQhtkbIE1mUCE/hVdYCk4aEtexjNwF8t
         YneDgwcwXJR78m2/g8YR4Q+FLot9MuJM+k6MK8T/rCD3bcHEqe64ye8uENZuc9wvHNmP
         wGS60kocPQdOJCubfDAtAIOndh9nex0nt7HxO16t7eYIk059UXWCRLmYJYcyCukIk3Cs
         N8F3SXon9zv36VbdsOO3flOog/PbwgqutU9QJwW3yahZ7vePTO4INlh4h00sTK+vGRhK
         ZPx7n/sSxpJ/c/wK9i24XzVRY1+O2ddMAm/4l2V1aCCFcWIsfYz0e+PraZ2foqLpYEIp
         jCiA==
X-Forwarded-Encrypted: i=1; AJvYcCUF6wJaKWQEgAG2CuuPDqzBKBKE5f6/S52K3RXpT85oAs1QF44fgGoNWE/ZatJ+AT4pbOrPWAOHpg==@kvack.org
X-Gm-Message-State: AOJu0YzaLHEZQh1DcozpjMSaA12n+G+EivhmTAc7BNhvZqgRBNIZqI1I
	HAD5QAc9R8bNRoxOMS9GyjubV5ipPkUN97aVffMc5j1S1wQ+jCpahANo+XXQGI7K1w==
X-Gm-Gg: AZuq6aJqDnLSEdGAoq1rQZjnnO2u0VqmbWBK7xSWB8jE2e51C5AWC5o2gcC+aGltZPJ
	x0OCr9VblJueaMGEAUBsE9rdX8NJj+jUGOWmYtwyVJ7slp1cOKYBA8hqs/LFXjDqS0VhamWxJZW
	eRGRe0jvL6J5LRHIv5Fj1gXVl6b34JinoMQZyncti9Db88JiXiZDpmskEchyaNik3BckRs9OhWG
	ixovR+T8MguqaZGUdcZvl0s1mt0gcue7+b2x5otgKDCkXcJoF25y2RKUKHDCbkIorwD0DS6Oq0i
	0tFlynTx11AsuF15ZaMHpbu9FonwWwzGH5m88TTfEvJ/t31AAeAnimEtAMfqX1jV9oKQesPCcsZ
	ueK9IYpPmc/IHyoI1H2ny50wozouNXgAqy/osmSiOjclOHzsqoPD0NbTwocxsPEitjRiXhQPkWJ
	dW8a479kbzCPGubi/2KhSRxzfTdbDewdhxrOsNPEOFBiBJ59wbedw=
X-Received: by 2002:a17:907:1b20:b0:b86:f558:ecad with SMTP id a640c23a62f3a-b8dff5260f2mr573103666b.7.1770008221605;
        Sun, 01 Feb 2026 20:57:01 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2e0868sm802341666b.58.2026.02.01.20.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 20:57:00 -0800 (PST)
Date: Mon, 2 Feb 2026 04:56:57 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v3 05/17] bpf: mark struct oom_control's memcg
 field as TRUSTED_OR_NULL
Message-ID: <aYAumaqJ_MwJ3Tkk@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-6-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-6-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5268D1A0008
X-Stat-Signature: 1be5gia1k4fpqncfctq6qmcyau7r1bqa
X-Rspam-User: 
X-HE-Tag: 1770008223-27815
X-HE-Meta: U2FsdGVkX1+8alF8UKVxKMb6rYjsWIBeo7jzKOy3+reo7HX7c6OpcNUDni8STRtauQ1tAUjw6Zs5R0baX0d26MatN4Dj9NRAxQebbp1IvFuzGYi1PBvgCAWcr0gHnbhuSvOvI5pXdQtlGEiGmeCIoi8Thfc3EBG3QYeS2JKJQA0JbClFkw781MOe1CTqlwLeHdPQ5fcMGXTbyYDc29kaqgsOHdMXrNhgu32oZifpa3dTv1Vu5qv2yAlsK19rIbHeXuHIHniFp5jrUty6uHrvsgeWMavpvxShIVxGTQsjD3fnA4IDy/gcGUgPk4Pv216EE4qa/Yx0Wbbr3dd9WjqnjQtPLJmJOo78V0yo2+ZYiUsAmN1TDkUzzpACDWKcbGQF7KnClaoIHDUskgEnQ0QkbUVrubzwQIGiqCRvgNRK0TJbCjq1FwSVCOj+sTr5eGwkashUuUvdkOtTnhHvbz4Qd/sUF/cCrlwmeACSKreX2aAFEmDbS9lo3zW7mcB4ZCtBflH8zccLLtaptru4NkUooSSWB5yPNWwYoHOXGH/Ftzb58UiSrhzSFHsPsmSgJoeASBXnCcX7gWy7BQ0BLWWTQo5bRxGaICsfR0dFt1iQKUeOSJXuyiJYbQKGND4FUV8qn+mpBcigYHbrA1zJFrKBP5G5hGZBaunvp/bX1PxAiTG/m5bT5G23/1+N7HISk1kZnQK/x8kWi6GJqdjH2HiAQ16vfeMlwNzB63xSCjmMlaqk9BTqh8Xq4nQqkLZwZy9r48eO5sd1i85dh2Vu202zcpXH7NKUvOBA3VAOA6Jqx37Y45YS2clwjbHFCUkBjBY1KK4veuY2VX5qu1o0UensfLV0tKneGTJYbuS74oRcZZ+JO8YTdZc0JGmgWbRMuqnHgsTv8KgxVzurHixDKc8OEjyoAZ2s2ZVmfdFofrSW6zNuL4+IFPprjjf86o+GNAxK3kvqGiZYwpDW0eQHwML
 spOlRIMQ
 2Otah+rZe3jikDEzU/Q5rmxQh7TgRKItTlkpPnGH6/hfu/o+mNUwunGTwAMuZVLO70xd7vSLJeeqoxaVBU3I3L0Uu299N+q8T3qqnu3z+q57NXVkGyHDUwmvg1GfzelrkaIONj78bZoh6dCXvQt93NAt9MQJO1FLnOpM6Da/BcS6ab1wlYjlaR99efeiLlPehngy5cbR6XPuR4C5vKNYp7QQCcS4oVrfM81SGS9Bhav7FNi4Atd7u9YzvYhOdEUp+4HXNJADcqZxp4PtfKe/Lu2niGi5CMsxTwsYS1TveY/NYBymsFiHUpwiohXwPcs2dpVvibgOqSsxNqRfZ7/uNJhbtbNf4eRlnasiPJhLKdxTNTd6s8SNIgnHtPqmEp1YGuqdjfcd+OfJLA/4EB866IDXNUAQg+/zkOtDaNEuZGVOQ5bA+4ljFxaiBCMaKgkX6xfxhv1ISBq0qNU4PinC0LUm1C5mbMpbTSe3qD1qIVyh86g7pRPCJut6nxBFr9fDMzpAU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:08PM -0800, Roman Gushchin wrote:
> Struct oom_control is used to describe the OOM context.
> It's memcg field defines the scope of OOM: it's NULL for global
> OOMs and a valid memcg pointer for memcg-scoped OOMs.
> Teach bpf verifier to recognize it as trusted or NULL pointer.
> It will provide the bpf OOM handler a trusted memcg pointer,
> which for example is required for iterating the memcg's subtree.

This is fine. Feel free to add:

Acked-by: Matt Bobrowski <mattbobrowski@google.com>

> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c2f2650db9fd..cca36edb460d 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7242,6 +7242,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
>  	struct file *vm_file;
>  };
>  
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
> +	struct mem_cgroup *memcg;
> +};
> +
>  static bool type_is_rcu(struct bpf_verifier_env *env,
>  			struct bpf_reg_state *reg,
>  			const char *field_name, u32 btf_id)
> @@ -7284,6 +7288,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
>  
>  	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
>  					  "__safe_trusted_or_null");
> -- 
> 2.52.0
> 

