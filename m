Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1062D25948
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F136B0089; Tue, 27 Jan 2026 01:07:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6546B008A; Tue, 27 Jan 2026 01:07:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5233F6B008C; Tue, 27 Jan 2026 01:07:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 414186B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:07:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6ABCD4031
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:06:59 +0000 (UTC)
X-FDA: 84376710558.01.386E9FB
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7708120004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:06:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYTcC3ep;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769494018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJWAZY6LKfo7RbXkh5+gjEfMAbkq0ijn5lP4/KwobQ8=;
	b=hyzx8HtEN/bjoD5Ms1lkTh12mQsWnq220ALHhB5q7wPL/J9y+5h1jYTBq0LfXBW2u4MZcl
	j2zavYUO33wSVWBe9AbCRUC2PcJsEAutcTZgENgQi7Lv0AfKQB5p/Fgea6MdtaqMFuqiYh
	86fScHNGzTxW/hLa/JxSTQf4s17RW9s=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HYTcC3ep;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769494018; a=rsa-sha256;
	cv=pass;
	b=Yzl3BgxRAhloKgoCk5m8w695kVv5bVCoGkNTQalSBsSiViEYBBUV2KDpBGoxECh02+751D
	1+9cik918GogVL0lD+GcyUkD0q0XT2Uae5mr4CWJ75LTRNMrGgd4VdXD6j+mrL14N3AhSe
	slMyYl4DDvHic5sSBhJzpTNEakmHRig=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-649488dc7bdso4981584d50.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:06:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769494017; cv=none;
        d=google.com; s=arc-20240605;
        b=awpIQJri4JEWnEP426YWK/yKpbkTuIsVDYTgpYf7XWtTXO29IaKRRqLju2nMWLmQ2D
         qAvX/ngrBZfGZwHssRQfNeuDryfBITR0NdJOkS/HhUMT92lS2M3/vge6KSUp9qDum8cu
         hSW6c1Iuu25dQXkCyhcYm4E90fzejEADKVE/IgzU3MWM5LDFFS8xsFhG3jP3nHkU8HWi
         v1K7hKA5VzV4iczYruDm77vhQMfNMKvF7vKGKscnro6n97oLLGuUvFm1mkvyxCGTjDPk
         x4leAB8fwTRh/DxaGwq1tWSxrJL01Nt7UHOBR1x9v4wA51X4trFKdrRf8CfH6oQDRgxC
         NVpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bJWAZY6LKfo7RbXkh5+gjEfMAbkq0ijn5lP4/KwobQ8=;
        fh=1DVZUTVf0xhIwmn3QrH3mHUFydA43HicHUOaFixtKPo=;
        b=Yt8Q4sOlNJoMpTcW+++tx77Zv+Wf82iajDuk1yV/0kYe72lN/MmxWGETZeXoTKWJPJ
         WG4UhNqQDNddJiS8feBYaLUpFfXaMCE8jJ2En/KmBk0pmNMPEhxTqWBR9zkOOo6N63/v
         Zb0ShUsB73+k9W01AjF/WdBpVQbaJnJxVE0rLhKrXVZJlW3/dc5n1TQz8XG7bipW5z/f
         raTNAcIQ5xI6rbmqhKsYSrZq4a9HjFtY7pNjMQxhdWZjb3EE24MdovEVZ/tER/lT4+ZB
         v83NicnWowWkR/SOx7MMYbCJQ/w1nkWmHf62LZeZhAJggO+qHU7+m9Jov+3+ilbXPy8f
         orzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769494017; x=1770098817; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJWAZY6LKfo7RbXkh5+gjEfMAbkq0ijn5lP4/KwobQ8=;
        b=HYTcC3epsu1bSu1go6caveUZDzWKNuJt+Z1257o6fXPl99A0bSN2p/eo7o+FkneTR+
         UX3ZV0i7XTRQvfQiLj0UcTVEYkUlb7PT2p/3O+F/xnHqJJC567SngdewZ1VtxCkEt3tn
         t1A7GAJhIzw7s9xtnETiaa6WW7r6uzLCddaBas+KyWl7Oc9J93gl36tq5sDTPqIw8J0r
         X/jKNR8j6HTVi2e5zHeBqlOJvf7NDI8MsusoREnaeCELvI3ZiVeexLEMAvNPYAVkUnP5
         G2YpFz01UZRKO/UyaTrgvjTwpRJUDSvN2R6Yi3N59V4xzqqpB81kcjCmbmKZRRhIqvuk
         GYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769494017; x=1770098817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bJWAZY6LKfo7RbXkh5+gjEfMAbkq0ijn5lP4/KwobQ8=;
        b=G+8GE17pYXF48PFO+IgnHy+O9n5ZRMvpDf5J9RbdiC6i9CDZ3O+D46o22AGiBQwRk+
         LRT0jN/ljjJ6Bfn2sUZhw5pUhfYMOt7nhYeM+MIL57ZOFE9omSOwRuCmdUc+Jnt23qgG
         a1Bi3uvyUD1Dmp2ixQjrwn7TCH4y09nh46BVIzBuUdpAU50Tk+nFp6lfFYBzLqKS74iq
         LMYGSny0YKaFIYBTXsNZqJaQw8128GC6i9J0pzltHg36aqwOprI5gfGcfeVnsWmRfjVb
         yM4Kt/W+KJ4n3wejeGp0fWPP0ReqkJtn4AR11RgAvlqyEBdektyhSYbDgg+hlslxv/Us
         zR3A==
X-Forwarded-Encrypted: i=1; AJvYcCUN83Ob0MBKG9JD+0oU+fXs6pevH4U8dkMdjd1BxEtqgldCul1IIIBBQQnnPg8q1oLXLeC5ivpkow==@kvack.org
X-Gm-Message-State: AOJu0YzQ5LL7BVx339Zy4dI9gu0bjcpY15Oo0iWkGDV5VsyHbgVBVGWY
	nYO1oY52JIfWje8K577Tp24fHKZRv8zKaGWN0rQOJ0mIxBmwULCA4hhjhSZ7SKHRquZCf3APPkn
	/vqrch/d4ilZs8RynuIJK1ulsn4jdulc=
X-Gm-Gg: AZuq6aKXDZHYiPtlztpxd07/+fbfhanN/hei+266lRz18XNee8x+ZdhubjRhtoXFIad
	hyKeeuimE1/5qLkGItcYCMO2mxtk1YnRUGx/kv3GdNWY/6NmVPaAbudsoVm+jafrKqqb7gQqWRD
	9rgt2/VuPNevvybfyEQiMozLcnvRcsBE6x9Auc+L1bBdGSkomfM53B3FBA28/u2Xd9AjQDah2S7
	xLnOOW4k7+fQDUXbkSSKpKXIb6bZyopdX6hHHY6xJ+w+cHUzVv27LuqQJlsoopd29F9Q4ce
X-Received: by 2002:a05:690c:6b03:b0:794:baf:3fab with SMTP id
 00721157ae682-7947acac299mr3946817b3.68.1769494016915; Mon, 26 Jan 2026
 22:06:56 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-6-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-6-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 27 Jan 2026 14:06:20 +0800
X-Gm-Features: AZwV_Qj0tcw7ghLMqT45W5nW3bVQqI4tEqlqFj0ly-h4dN4f18uzS8wj7Qlnsj0
Message-ID: <CALOAHbBLEqqs3iP=QFCs7BMX-YZXu6p+D-vmQg12S2Kyq12Frw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/17] bpf: mark struct oom_control's memcg
 field as TRUSTED_OR_NULL
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uzrpz5kouioek4bmxtakxb74miokpwfo
X-Rspamd-Queue-Id: E7708120004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769494017-933468
X-HE-Meta: U2FsdGVkX1+OyUYJEb3UawCbVDsdXr8QXBIMQal19qQl8Mq2rYRutMxnKT1wFdZwVD9/JbnfS4JEW2N5lre9IsYnMXxR6znGHclmrhLp5mtb7yAIPZIX9hDty0F9KN+YpgnLVWLM+y/TsGYG2yEuhh/NuwQp+7VcJeOtnK3duW6XiaISyjuEFEqwesMKmcvscXcYzGGWyt5OX2TY+NQS2qLFvc4cegRoP0Fdj33a1RlmehXLOB1ofAwMOmnaoVw0WumH07DEITrgAi43RYdCYA1PaBou8waUUwX7W2irvRUT9/9XOE/aUv0xns/gbP+X41aEfOIyHNpcpvJgWAj0i70ZtOG0nawR4eaVfrHX7MyJXnp8IUiw0/QNVp29/74RFf18Z1v60zPfpzHROaN/zt2f+HNCvmGY5HDAOU1WqhiIsEV6J/mPCJBjpqpKK4X1soOxjzFIHnSusY7TlqLq92lns9etvKfI+fjd6j1fkNJSONlGfkwI0PlTeN1lq2KdttlOMIcL0lWFVkfA6uGCfw1u7CuAYj4CaqcnxkrydRNhGv1kXYZkE+VR6fbAzdbAy1lLbw5Nrsu7xd2fWTv5RtgzruW9iudl0eKKj7bDDnAMkWhFLlMm76JhotFUT9njFrjouKQS5EQWS4GUeWfCqxf7gKeUdyDidyAWFoT+wMP7z6UPN6cxDiiqTnwZGQesmCk/Js59+l13zzW1G3qUTIUmtfvuHxW074moCqF394vXRQuIl3k/cdSrIcvTeuldQ+69+lfjqvK+oXY/lurudJydFApvQkZlNqUZW2E2GKE/wbPmtbYnxb7zrYAPGlfKNxydXUUspCQxYFaGWj73i046KzXd8LAOe7rsUueL8HxOGa3y1uR0W0/gvtQ8ZZvdJPA0rCI8+g3qh4WR9I9Gfk3j1QEHOyqAdRPP05AjkH1mHF1oeaUnPoF7oLR0QtPo1J+Z0TZ5J+ZpQSe4yHJ
 5e7wxpjg
 zYrLUQXpJFhWTS+UBHvz+jHByMBWYrwv8ijwp/twhtC3DHWEImi3vuWUclnpdUqO/dt49qjNpkxUK6VNCLNIUMdDNPP79LQGhaNXZ56YQtqz9Jonnl0kkzYDcyAXeTcIwZL1zXvf5KDLFMeQTnR/m9M6/OOUdZ8LXSe9LQFWVLZGiXYeI88hHhG62j23lfAXoO6YsfnM6GhJA3yHf8ImwinroEGdFlQhWe/soqTfQD24maRcw278nzMrtLIzjkjP3fcUpgMkaaftJDzdPW/bdhusCEDlLaN7weCclcVOFZg2X0NQoiD7FOYaAngHk+ysBSAzHCHQ6qp2klpz6KZTn5/S8z46eEaKPejcfkUQGfgTq2wteHaBkYZyKM+rc56qQmvE1dK1CH1vGA333eAzrlooHKN/9B4EjryghtaWuud61UM9vE+ekkL6Fdf7EO4HFoRHUUBaCLPsUb9RDT+U5TH/cUUqCTSkQxpRX6lPCT/5poNUcXf/ESX5+yDxOn+6rfCPv8N6ULVMH7YdZ4XCEYg7SoBuT35QsyGiH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:49=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Struct oom_control is used to describe the OOM context.
> It's memcg field defines the scope of OOM: it's NULL for global
> OOMs and a valid memcg pointer for memcg-scoped OOMs.
> Teach bpf verifier to recognize it as trusted or NULL pointer.
> It will provide the bpf OOM handler a trusted memcg pointer,
> which for example is required for iterating the memcg's subtree.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c2f2650db9fd..cca36edb460d 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7242,6 +7242,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struc=
t) {
>         struct file *vm_file;
>  };
>
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
> +       struct mem_cgroup *memcg;
> +};
> +
>  static bool type_is_rcu(struct bpf_verifier_env *env,
>                         struct bpf_reg_state *reg,
>                         const char *field_name, u32 btf_id)
> @@ -7284,6 +7288,7 @@ static bool type_is_trusted_or_null(struct bpf_veri=
fier_env *env,
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct=
));
> +       BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
>
>         return btf_nested_type_is_trusted(&env->log, reg, field_name, btf=
_id,
>                                           "__safe_trusted_or_null");
> --
> 2.52.0
>
>


--=20
Regards
Yafang

