Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87FB2E83822
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 18:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EB56B0088; Mon, 16 Feb 2026 13:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC976B0089; Mon, 16 Feb 2026 13:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4626B008A; Mon, 16 Feb 2026 13:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 561956B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:30:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D39F213C3C1
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:30:22 +0000 (UTC)
X-FDA: 84451159884.29.DC953FE
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id CDFAD40015
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:30:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DigLDENK;
	spf=pass (imf12.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771266620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkJWUx4iz20mHMlM7dqbfruMTcGOgRj83PoFq0CJCIQ=;
	b=DtMoxR7h2/AtLz1izPokcOFCHRaiYj81a8ZjApcwmF+xxP81fNSEsznXTaoP2yhXfAjpgD
	GT7cZdkUGcXfA2bvLLZwIrmDUQflj+SBmXWzvXyFcJKy+oYga6bBwfuhaocEwl6kYTP9OM
	CMlSvhDyyGKAFjwDCrmZObxW14OW0w0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DigLDENK;
	spf=pass (imf12.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771266620; a=rsa-sha256;
	cv=none;
	b=AO+LX7/9vsUkgze4Ys/LKYYZ0q3W3SSOnGL3MHzbFp2TyFe9/fq7/DOfcpvw/TNlIR3lc5
	YUcLYvn1Kav9jZfUWSf1MwDBz/PnE1BFguYjQ60HlcJL043GWNEQ51PXlgz2nI1sEGz0Ob
	puOPn4LJjcDllKMZffFBYXeUouh1wEg=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-124a635476fso3846494c88.0
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771266619; x=1771871419; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EkJWUx4iz20mHMlM7dqbfruMTcGOgRj83PoFq0CJCIQ=;
        b=DigLDENK7sWWtK2E70ep1krQKWNN5BnkQ2etRn3ZApWdKkk4cpYgZOLH8HBc1WLJjQ
         5YktQO/aFou6e+KczI21JSkq/TKqW6r9IlYuvTMjAlI9aEM5eyNZpyMcNuhCaL6+mPVS
         KFbCb4Se/FcRI206D4uBLq9hQzKGagdf2iOYLAtRZEnECkpOL1znMgmnFfaDc5KtfiVV
         24Ljwt36qd2bwfoVsSgoI+ZAtM/hMef9d7+9gDIHZsgvs1i0rkL+P/909UNu5ZZXU7Cn
         Hyz7ZWpWiuF8ocCTty3t1hWOJGQU2xnWUggEkNQD5NATrs21Q9OwsL6sIfzM8GJytmxB
         xG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771266619; x=1771871419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EkJWUx4iz20mHMlM7dqbfruMTcGOgRj83PoFq0CJCIQ=;
        b=ugZIoBsKk5kUcGKyKlycw+K1XF69ahgmpRFcYB5Gr83CpbfR3KJFcK+r5x38yuo4wb
         fsZXxuEf2yIHq6JQwO/+GfhlhIUt0KsHJv1ASUc0GR16UR3sKD4cXVjgBUP3p64dimAh
         KxgPVuo44sasQeuJbsC2tuEQHQe6bQ9NrIIcqX219mWY36lIE2/Q4ye6FQZynvxAXXTd
         R4ArH0aVBifGBe3oCHoFIVcfm2fEiP5yGy9kRD0NPM2EzOULpRWNtx2YLljgqAEDwUqJ
         QM8I43QAJgLGb2NqnRr0DQp/Bu7+iv+C/Sz8uv/nQPRJkiJIeyQCLPrPvQglhr1enoSl
         O/vw==
X-Forwarded-Encrypted: i=1; AJvYcCWGFIE0Upk7n1X1ysM6RFGlDylzeT2XbHXRWJvhkFnmuFdpG9cZU8HOXDQ7bA7tS8U9eXtB5sFrsg==@kvack.org
X-Gm-Message-State: AOJu0Yz46WdOpsVjgx/23eUN9PR/db/ikyVVadA6iL7GF2HPICTyXng+
	M8TSBgY7tXiog8Uuiggfnr7IDAAMHiIIaDYHD7UPvvDvBkYiMwf/DbL9
X-Gm-Gg: AZuq6aJdJYydqg4orJ9azWjLeYFsic2b7kS3fkB7FZxcpnbLNHAfs5HPbY+jEOuTWCx
	nWCFdLBsZWfnnJPokWZATBWhOzzRJUlHp9v6hrNiuCeMst1eV78+cecyOdoqIggciK/5wNYdjxJ
	yK/BgL5pK8/hVfn1guTP9S545XaurIjd758BelvMIqxtWRlm/NBHIEYYuTeTz+hyCB9sFGX6sz0
	cyh1Lg94kkIyOZoslLor8oZYXword9cJSHmt0CPFM612DbpdNIJzlqQ8M1vuGveFh8/KmHF2mLy
	lnpnVgp/THV/QcX2l9yqg5AqM8SSa6j8rTM5GT34Epp5JmKo8dTU1tDuEjk9kvOLo4h4pMTPguC
	87Ee8jdCnSEjYnfpeMckt/cNWu/4gVL1WxO8VONWLcNLOD8WYa35UlDsFgGxvkwKiHAR+laRSlr
	CdJVDf6yzYZjDiOzbyuwZHjWaUMu9+Oi+T
X-Received: by 2002:a05:7022:692:b0:11b:a36d:a7f7 with SMTP id a92af1059eb24-1273add4230mr3788461c88.16.1771266619112;
        Mon, 16 Feb 2026 10:30:19 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742cc83e6sm11517513c88.15.2026.02.16.10.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 10:30:18 -0800 (PST)
Message-ID: <ac9ccc1c-acb1-4439-8db2-eafe757c4f9e@gmail.com>
Date: Mon, 16 Feb 2026 10:30:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v2 1/3] bpf: Use bpf_core_enum_value for stats in
 cgroup_iter_memcg
To: Hui Zhu <hui.zhu@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Hui Zhu <zhuhui@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <cover.1770965805.git.zhuhui@kylinos.cn>
 <24ac7bab25d8d2a24a35ab87a5283263eb6a4575.1770965805.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <24ac7bab25d8d2a24a35ab87a5283263eb6a4575.1770965805.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8m5jaf488k9sxfz96g4irn37mchabqax
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDFAD40015
X-HE-Tag: 1771266620-701909
X-HE-Meta: U2FsdGVkX193Fsmckujp/9Chf1/6RO2lY0WqEyLkdYxL8My8Q6iT3Ond77SrgrYGM55+mvRllYgJCbmp7rkKVxqcuXW7a+O+sBpR6VmctJvgU5uwC2MvH48+Udg/x2ltIytTaCeuBcX37hdOsx3CHzNmeRmVmzL7LUgl1qlXIo6c9FD+Ym1u/KIm8a6scGrKPs4Cfb8fpRJ+ggCXdjhbOlbCFG4IQBqlx2J0FXkDHXnhbK7UnFLTxNBkQWivE8YgOcKZ/bkKxtxqjJUMaycrAJe1DTIR/+xrSD2C0RKjZChyccXcMWMCFsCB6nvedxNno1wlPGTp1y52TblMDLP09hRsiXqeFIntdnN2sZuZPaZgBKtNLrtCXTSVoQFJIDUB1Xi2bFAnI86Bbl20HLvAlp3czIDKt6bR2OwTQpv8aik1OZwiDmVcvhnJgXD3Q/25JTjxWbjMyjv8zW192jk970XHLqTdHjQI/EFbhSU8JveXG2avd2CR384juj8KkWoIp/7+Ghi7lSO680CwqLEtdLXtUbJTME9HTjz/DxOIXIEUqFwynBDTfeXpWCA2WJbaOY1aU/8I66p6C4VmG26/kLsWGhEXboZSzlpfOl3j6SlYqtULD2yNKgG0gJwkQ8ZTe4jbe6KjjLSy8r5WDLUmiwQ5Y2qHkAlI9m9On2iIGUQA5uU6EphkCqtphfM6uaiR+C1gcT2zxx2GziBDyj8SqM3k0V7UaeBPQ6by62LMthreHo1c8H3XU79JxrN7B24mSSDRmbF5k4INtBJhvb4z9wQMVycHNY0FJFs/HVIkE2HV/Xk2MivJmFXQgHB3smJtZ0lyOB3n9LZ2Kd2WJJtX4lvcm6HEVNg4UsRucbZiX/2h8AUsqp8R9nOtMY77kXA0DbDjfJTTCNnidYgDC0Hr2NSbtxCKJ/f54+qtN3x/nKRvE312Upp+f71uWK/NjhbgpLx/ijNyim/kQec8XCs
 oUfe4+d+
 h2tMVOu3VY+n4fq9lJpB2jwQKuU6dfVEc8MsU+1WTLrzlQAmxYJdCb0nnwOYWcz17dMpe7ZAHFoYvV96BwoP6ewl/jDWr+pH6+ipAYILx5iQWQ2qJyiXAUaL8zSf+DU02S7auizsftdZmF+RldYjL8gJe3xw9EUfRIeNABwGXrZhxpQMuS2K5WtQwcjeQygI3+wG0sGDy3lDUWhoiJ197MFf5dsm6FhbQLeZoAlR/cvQSTnhhnKzdBZD9l+mpILbdvkbcKvOJtq71XQTHuJnSuVMcdizU2lcAq7DEFf4iMoKpszjfmcJ+kDMb0r8etT7i/dUhhO9KJ/NoPNIZ3hLu3AJUb7Kozye42nFfTB1Dh46DsqTvLZgIIkEk4h96kboxWPqcfCNI/jsVn9jiOliys2FjmMsuEHkdbKFU8mTGD80DhYhkrkRyy2uTjLuDUDDB1qrlqDH3da2WUSVOiVDNIXUlW7DGTZZlpnySpUDq0utJ6Il6xK+VZTOkq1l5GCnx42gZgRGKH6muVz8xZRBa26mn10oBVHZAFmMUEeEV2Bk3CIfsjb+/50s5AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 11:23 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Replace hardcoded enum values with bpf_core_enum_value() calls in
> cgroup_iter_memcg test to improve portability across different
> kernel versions.
> 
> The change adds runtime enum value resolution for:
> - node_stat_item: NR_ANON_MAPPED, NR_SHMEM, NR_FILE_PAGES,
>    NR_FILE_MAPPED
> - memcg_stat_item: MEMCG_KMEM
> - vm_event_item: PGFAULT
> 
> This ensures the BPF program can adapt to enum value changes
> between kernel versions, returning early if any enum value is
> unavailable (returns 0).
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   .../selftests/bpf/progs/cgroup_iter_memcg.c   | 41 +++++++++++++++----
>   1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
> index 59fb70a3cc50..b020951dd7e6 100644
> --- a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
> @@ -15,6 +15,8 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
>   	struct cgroup *cgrp = ctx->cgroup;
>   	struct cgroup_subsys_state *css;
>   	struct mem_cgroup *memcg;
> +	int ret = 1;
> +	int idx;
>   
>   	if (!cgrp)
>   		return 1;
> @@ -26,14 +28,39 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
>   
>   	bpf_mem_cgroup_flush_stats(memcg);
>   
> -	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED);
> -	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
> -	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
> -	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, NR_FILE_MAPPED);
> -	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, MEMCG_KMEM);
> -	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);
> +	idx = bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED);
> +	if (idx == 0)
> +		goto out;
> +	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, idx);
>   
> +	idx = bpf_core_enum_value(enum node_stat_item, NR_SHMEM);
> +	if (idx == 0)
> +		goto out;
> +	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, idx);
> +
> +	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_PAGES);
> +	if (idx == 0)
> +		goto out;
> +	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, idx);
> +
> +	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_MAPPED);
> +	if (idx == 0)
> +		goto out;
> +	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, idx);
> +
> +	idx = bpf_core_enum_value(enum memcg_stat_item, MEMCG_KMEM);
> +	if (idx == 0)
> +		goto out;
> +	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, idx);
> +
> +	idx = bpf_core_enum_value(enum vm_event_item, PGFAULT);
> +	if (idx == 0)
> +		goto out;

This is getting messy. Most of these values should be on any system
regardless of boot-params. I was expecting you would make the call
inline.

Let's simplify this whole series. This selftest only needs to exercise
bpf_mem_cgroup_page_state() and bpf_mem_cgroup_vm_events(). I think we
can remove the kmem subtest altogether and still have the coverage we
need. You could then call bpf_core_enum_value() inline as an argument to
the kfuncs above and not need to check if they exist (just let them give
you the host-specific co-re value).

