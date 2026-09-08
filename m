Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098DCC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495C66B0096; Tue,  8 Sep 2026 06:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4460F6B009D; Tue,  8 Sep 2026 06:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6076B009E; Tue,  8 Sep 2026 06:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E87276B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:24:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79147C04E3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:10 +0000 (UTC)
X-FDA: 85190209860.21.4D813CD
Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id A958D12000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BykvWfUN;
	spf=pass (imf29.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GN5oe+Yb7QbWSaMIabzdcqrqYrF+b3TvzNzha4X/Tls=;
	b=Ewb48D4hSSF1sp8j7VMPRvDSMe8nkHrfmyskhTXtp/mLquA8HQmfibszTVXTJ09ttTEWC4
	ZmPZx3N9nvktbqnnGd7lBqvQyyCe7pd6YXzzkXCfyAmFTaaQcBW6Io/KT0MvXifDtjOACs
	FTRS4FeEW8PuQRWKUfH7CrQl8BC91Uc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BykvWfUN;
	spf=pass (imf29.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863048;
	b=AOUKWgQ9yVevi43j5Qlb2jQAXT093M70HAVSg4rQ7YWmUmGQi5wljU5zevql7ly0BXGT5W
	ikVveYaCW2J05YZ5BftTy69414Kf3Td5xo/j8KKOz6MJAMRW1HR/e9lV36s7IhxppxR2qu
	Iykui0HuTsdga1d1solBXGGIcWzBCv8=
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-48433107499so1932761f8f.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 03:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788863047; x=1789467847; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GN5oe+Yb7QbWSaMIabzdcqrqYrF+b3TvzNzha4X/Tls=;
        b=BykvWfUNoJ0m6NrdJDTjoX2ZP/AJcrXT+cYZKG0enoARHO17QGpR2JrcuiXBDRODH8
         S78XMDCD+bdA3PgkwQt3NR0TEgnyx0UO7xtJizcVMargwv/ezXLP9wLC9ZdMuGfWndfo
         /1CbBKV2LJIDPn3ltgaDtIJJ3LxmZapD0FmOZYsU3WjjJ/8cEompPOEyhh6CCBZYm2JB
         vYWZFVVEyyJZGncpcfk4Phu0RmSmpvHKJwpWVu8A5yh4rXFptHOczwlzK8F6eFq2LR4Z
         V8IwsCl/aCmmRkoHCq3d4/eym4sA1xvZY30Egm+JdUkWpbuC1hBvrieHXqWtT8eLD6Q5
         X1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788863047; x=1789467847;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GN5oe+Yb7QbWSaMIabzdcqrqYrF+b3TvzNzha4X/Tls=;
        b=pk/3140TqYzYDQNKa+NVLILh2BTBW/tltBWAwoUNU9ESh+GMKTiROgZyzNgic/0pDC
         kh/s3p8+z6ITpaw/iXCiUI89uXgatrxyWWDacOVIC1/RJ5+zHl4haQ6nVpF+etdOsobo
         i95BsgDdYMWjU2fve1ju86hUcHT0L/yCzycGFHs5UIp3XVCbuLj2gyd29YwgWsD8xlmP
         Y94NRwldwefJEmePwMPViRZaEa80MtnwkBgOE9tOuUA/b7f+dXpxvcKKs8cpy9r6pagy
         8r2Q4of+eA/ysj2kZ1IIHpgOk2VLPMtIL6bnpkXy1vKvSBVyK0g6bGRxiNLoGL+K0eho
         66ag==
X-Forwarded-Encrypted: i=1; AKwUvBz2L2I11llI99QmDrqigHkX/jZS1obvDk4tFXQwBDqii4izPXH0tWERaHdXi7eVoXJ676+KbB53XA==@kvack.org
X-Gm-Message-State: AFuF++kdmZXap16Diap+s/Wjlk3XDtDIjqwRfIqSU7ulYG9+kRLAx8g1
	9UEC03DHmyaZrIg2iiLb92OsT0fUL/umUPTvsjgEiDgV+/00STYv6o3U
X-Gm-Gg: AYBFou28p1wj+4Qwa3D39KmhbyAkGQEVmaeFtqNTY8en5gWoaX6UTwnly/NNm8LRqz7
	TOX7OJs/al6gIlhTvp9zMe9CXuGzqp0Ye846W+t8FeKoSdmXyh1AbCrGLiMGfvoBxBk8NGKpEw5
	MplkoRrM5dbF8jWdTTBOcGRiv4Nz/Pj7iNojlNcFM5/2UDFcMb8HNVZY0AAsfWT5iS/evhRNwte
	9FUzdV1ZCHHGlAw3ngoINupVuVQCg94nG05eIZPA1ojj345BzqKNu3e6tIPr205ylYrXpg4UvzF
	i+Wt73qBAOEYayPFQVZwutXyLriPFOLBy5fax0YoLSN/NChPwBAfLHwLNoLM9WX0ZxXEkxhHwyp
	uPoAjpWaodv/wdVaZzd5HphnA4JaznWQJ90VBp14AJhzVn66cZH1+yaDpLPtE59leRimSaHTQgy
	vXErplgZqIaTO5ISDXCUvn58tE91tQtXbxTmnyUZbabCPFFGXkXVeSCCcN+LDIY8TGXNBmqZ491
	OdsT2IUUnkK7sWnNsvvWQkmkgMBEwvjjEQZNH8NyZtg8+ddPvafHYCAYZ/nIjaLu76PRhJGr+hJ
	0MlKro5yLjW0nlXnjvUEzUsPMtA=
X-Received: by 2002:a5d:5f51:0:b0:485:8a46:704b with SMTP id ffacd0b85a97d-4858a467215mr25183611f8f.29.1788863046836;
        Tue, 08 Sep 2026 03:24:06 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4859207c28fsm29714859f8f.5.2026.09.08.03.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 03:24:06 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 12:24:05 +0200
Message-Id: <DL9V0Y6BPZSY.3J1EXVDXSHRFO@gmail.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <david@kernel.org>, <akpm@linux-foundation.org>,
 <andrii@kernel.org>, <ast@kernel.org>, <brauner@kernel.org>,
 <daniel@iogearbox.net>, <eddyz87@gmail.com>, <kpsingh@kernel.org>,
 <ljs@kernel.org>, <matt@bobrowski.net>, <song@kernel.org>,
 <sun.jian.kdev@gmail.com>, <utilityemal77@gmail.com>,
 <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH bpf-next v5 4/7] bpf: Allow reads through
 trusted-or-null BTF pointers
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Anastasios Papagiannis" <tasos.papagiannnis@gmail.com>,
 <bpf@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
 <20260907165220.52431-5-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260907165220.52431-5-tasos.papagiannnis@gmail.com>
X-Stat-Signature: 6axu1g4gspm9k61dq5ku1i6u5to83n9d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A958D12000D
X-Rspam-User: 
X-HE-Tag: 1788863048-319923
X-HE-Meta: U2FsdGVkX1/PA0QndoHMq6kThdyKIq86c6pkRiQ/HvuncjuDm63BfRr4Q3hOV2ITbDzjeC3Vr1ylGBdgnLjygBcS10NgMYfp9eZZ83VcfHc1w11EEeT1c8GPHJyiO/vkjIiXBNVE2U/POoAUoGl3lZlx+gA1t+f0uWxooEyN5AdXR/NS2uGfOqmLY+QMoZjyEbxCjpOvdfinFQiljbrxcNOq/q2cgoYBODGJ6IRxZDnS+km/gDdqcqX4mtKdL8wnK6g6gmfo2bYh+2mSIX71PSEhpzO7vO9CzeZ/9BBge4ImElzhGGbnZJxtXU7Ne3/Es/VhkcJfzz1cARk1P47ulc3cB2YIndWT0luk0p3umnHh+21smesKvQHATx5hBrcl2x9e77PzahG5kbH4C+i97ZXCSG1RF69mlax5UmAolyNFckcTRw2afJ8smP9cBizu0FkXxa2FtbKE9k+9SUzuZarDVYQTMVS/a5iXa7qNlXkVzOrQIyVsl2OV2JphRTHOPthWdAnecbTDIb5koxgmyV3xZlZ/tYOT9qwrEh2otvCA4U+ZmXPO8+cZs43spggDbHG/7fXK3pLnmI3uAj35AhC1XJdta/keMnKIWY3AbzVOVhyt/JVogCRJaV8Ek0VVtTQolk6SpMX3KjQb/5pYKEDMZq0D3K70dhq9eGDq/Duya5ayrIoquuQkKI1mwwBf9SaUSWHxP+G4q4CIVJPBPYBy0zVyL009wO7pKU7yCfWoFfYkbq65G0MYkD+JgZqEZKd8ZnUQGcaHESV0bIGR1y2J91SpnC5XbK1yuMZ04Xa3KOtNhA+jNvoxrVsIuzMzbb0PdHXvezRPVgQASBmypeE9353egrousyflsqmqdCn1fPFCzsZOu7PKbJmxS7nxTp7VH4Hpq1PLn/I5j96qZSEoH1ptWna9PIH/csH6JeIXvs9EJ74d7tiKWkbpc4kecoPAYu8tUj53/pSZsh9
 zq6Qjkcs
 nopeJojNYndU0l+cyqIaQT1qVAsWJOhcswO1jcNd3XBk2RhzJGkNae6VC8AMZlcCf5zOLIWpG8xKXwm8TsiByK/WrtpUrJ+GKDvvT7Q6WP7s1rKcGkFh8hgYJ7V4Z+IrYnuvZwTjeQRWAl0ry2c4BqwKP3j4Ij1t8KbrxchR4L+/63Z7UfHNYJkfVtVTG3SM563gF3gAdNvpV7JMjdP/nckSmYdgODHRzww/AJuEhqD9aE5k24J4fLIerDfOv1j1nxW3d/ryOqODqC7aO8jwsWgYiQdj9pi5TsuZ10rX4U3YOpDgLb1qKteLjQrl9MOuf5gvh6Tes7MhJoG40HI4E7syxrYn0DQ8ZHVx0cSxIz7RUHsPcsBMp7bAX4JAsQUCeEySnVthWaZPYdCoDi3V+xZHOdzQntX243KBr3YrC9y+CPtAg6tzyrv3Mvtuu4uqSGQ6r2pEv8G8AA80bH+nmgVtxfzzlTcZ8mhMLIsef2ek4u+0TIMax3k3K3BGh+scuALAm4pcplTNprIdM1HmiD9NVNH5h38O+URuE1rGgkE7D4YSCTsCwqBysnwvrLlxrlII6LQS3JPmE3meEEXEcsGUQVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 6:52 PM CEST, Anastasios Papagiannis wrote:
> Currently, a trusted-or-null pointer
> (i.e. PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL) has to be checked
> for NULL before it can be dereferenced. Marking a field from
> PTR_TO_BTF_ID typing to trusted-or-null can reject programs that
> previously dereferenced the pointer directly. This is useful as we
> need to mark new fields as trusted in order to pass those as arguments
> to kfuncs.
>
> Allow reads through pointers marked as
> PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without an explicit NULL
> check. Treat these pointers as potentially faulting so the reads happen
> through BPF_PROBE_MEM. If a read produces another BTF pointer, clear its
> trusted flags and mark it as PTR_UNTRUSTED.
>
> This applies only to reads. Other cases still require an explicit NULL
> check. After such a check, the pointer retains PTR_TRUSTED and can be
> used normally.
>
> The unchecked read path has two consequences:
>
> 1. It uses BPF_PROBE_MEM, which is slower than a normal load. An
>    explicit NULL check refines the pointer to PTR_TRUSTED and allows a
>    normal load.
>
> 2. A faulting read returns zero, which is indistinguishable from a
>    legitimately zero-valued field. Programs that need to distinguish
>    those cases must check the pointer before reading the field.
>
> The next patch updates current tests and also introduces more checks to
> ensure this change does not break anything.

We tried doing this before in
https://lore.kernel.org/bpf/20241104171959.2938862-2-memxor@gmail.com and i=
t
got reverted, it broke all sorts of things and made everything more complex=
.

I would drop this hack and just fix the program. Given your earlier change =
to
annotate the field correctly, I am puzzled why you added this, and there is=
n't
any description anywhere explaining why.

Anyway, regardless of the reason, it's a bad idea and shouldn't be done. At=
 some
point we will also tighten conditions around normal PTR_TO_BTF_ID and only =
allow
trusted pointers everywhere.

pw-bot: cr

>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  include/linux/bpf_verifier.h |  9 ++++++++-
>  kernel/bpf/verifier.c        | 12 +++++++++++-
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 9727df5af83a..4f032ad83c67 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -1339,6 +1339,11 @@ static inline bool bpf_is_ptr_to_mem_or_btf_id(enu=
m bpf_reg_type type)
>  	}
>  }
>
> +static inline bool bpf_is_trusted_or_null_btf_ptr(enum bpf_reg_type type=
)
> +{
> +	return type =3D=3D (PTR_TO_BTF_ID | PTR_TRUSTED | PTR_MAYBE_NULL);
> +}
> +
>  static inline bool bpf_may_fault_on_deref(enum bpf_reg_type type)
>  {
>  	/*
> @@ -1346,7 +1351,9 @@ static inline bool bpf_may_fault_on_deref(enum bpf_=
reg_type type)
>  	 * protection, that is, the ones bpf_convert_ctx_accesses() has to
>  	 * turn a BPF_LDX into a BPF_PROBE_MEM one for.
>  	 */
> -	return type =3D=3D PTR_TO_BTF_ID || (type_flag(type) & PTR_UNTRUSTED);
> +	return type =3D=3D PTR_TO_BTF_ID ||
> +	       (type_flag(type) & PTR_UNTRUSTED) ||
> +	       bpf_is_trusted_or_null_btf_ptr(type);
>  }
>
>  static inline bool bpf_prog_has_arena_ctx_arg(const struct bpf_prog *pro=
g)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 9e79750e2480..b5186e664aea 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6168,6 +6168,15 @@ static int check_ptr_to_btf_access(struct bpf_veri=
fier_env *env,
>  	if (ret !=3D PTR_TO_BTF_ID) {
>  		/* just mark; */
>
> +	} else if (bpf_is_trusted_or_null_btf_ptr(reg->type)) {
> +		/*
> +		 * An unchecked load through a trusted-or-NULL pointer is
> +		 * fault-protected. Any pointer derived from that load must be
> +		 * untrusted, as a fault produces a NULL value.
> +		 */
> +		clear_trusted_flags(&flag);
> +		flag |=3D PTR_UNTRUSTED;
> +
>  	} else if (type_flag(reg->type) & PTR_UNTRUSTED) {
>  		/* If this is an untrusted pointer, all pointers formed by walking it
>  		 * also inherit the untrusted flag.
> @@ -6644,7 +6653,8 @@ static int check_mem_access(struct bpf_verifier_env=
 *env, int insn_idx, struct b
>  		if (!err && t =3D=3D BPF_READ && value_regno >=3D 0)
>  			mark_reg_unknown(env, regs, value_regno);
>  	} else if (base_type(reg->type) =3D=3D PTR_TO_BTF_ID &&
> -		   !type_may_be_null(reg->type)) {
> +		   (!type_may_be_null(reg->type) ||
> +		    (t =3D=3D BPF_READ && bpf_is_trusted_or_null_btf_ptr(reg->type))))=
 {
>  		err =3D check_ptr_to_btf_access(env, regs, reg, argno, off, size, t,
>  					      value_regno);
>  	} else if (reg->type =3D=3D CONST_PTR_TO_MAP) {


