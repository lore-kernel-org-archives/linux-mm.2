Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7757C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849366B0088; Wed, 16 Sep 2026 17:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA326B008C; Wed, 16 Sep 2026 17:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E86B6B0092; Wed, 16 Sep 2026 17:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503CF6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:47:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4078514018E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:47:19 +0000 (UTC)
X-FDA: 85220961798.26.881BECD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5601A40009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:47:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7K1cXJA;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789595237;
	b=PkmuONkXJww82rRZn+WgY0kEwBbUdILr+tiO3eaE0T8Cj40fuqQsPz+4rVWS85dD6N9hg4
	WW6mDRXRxdv3tLD2/amub8trtnbwtTuDd/t91CRSmGTaQzEBoS6Gf6VqNBNJW6CS25ZBLp
	O648TOBqfC6Xy3I4i21Bmtudz1NX0Ak=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7K1cXJA;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789595237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKgCCFGN6jBwDhfi6TCpAdpQqIHyfoSi+GJbRxa4SOw=;
	b=WKMRl4rz8GCXhFCFHYBUvPM13Scm6IRVwOEh8AzjLifwx1dM2u66NHd/0glhuzfKrA9DBU
	TBdujYffStIFjR3Zw8Aathia7U8mgTLd5PW20SIxek56t3CAtbjGMXe4dWdEIsGYk1+V17
	MtIgCokt0S1GAESd/V2Yr9V45Qr9sdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EFAF602CC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5776C1F0089F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789595236;
	bh=BKgCCFGN6jBwDhfi6TCpAdpQqIHyfoSi+GJbRxa4SOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i7K1cXJAiZ42c3Y67CoPxg3ZTvOcNb1Ho/Q0n9wc76vc42OnAbKKl0BYyoOFkQIub
	 tB9wfV5LOiJ/WCbQSDLU36bUjw1Fq7cK3sVbsi+mkCCl/B24e+XoqQYtVlHlcAPLfm
	 /0JVJ2HgO5ZjtBpDPTKS06H27OhOTmyjaQZ0IcKb7YDwZCWr27DsAHT1oreBUYxeWK
	 Ym27jQwg3P2+dGSTb/3hsVVTWhZfQjv9xXVtnLiFRPXdlGP69RHp5Dn1wWHOOD541X
	 QkLARJrJ5roWoLwUv5E94qQsZNI+Ej5efe9XjMJ0+IK5LBzk9Z+khff+kBHfg+LxHv
	 G5dbOO4YBiXhg==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109f067fso14308585a.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:47:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwCxiiiBrUxnaPzOvRZCiGaDj+kDVyBfQvvM/ytkWgAOkUrNOzzIcCrCed8qYCfNo+vSjJVjf7zcw==@kvack.org
X-Gm-Message-State: AFuF++koK1RPRAXE2yem5sh/erBx3y9ZsmWukK5kI4mjxxZXs4NKv2zC
	O8Vf1L/QyPuIn/gPtUYlVb42UmZ5bDY7P45ZDlxT1W9DL5/xUO7BYh1S2tMMRnO1QJFG4VuTH8O
	Etwzp5cOtKrIo24oA1DjttdfJ0if1Uoc=
X-Received: by 2002:a05:620a:2312:10b0:93b:c07d:a6bb with SMTP id
 af79cd13be357-93bc07db157mr388003585a.16.1789595235708; Wed, 16 Sep 2026
 14:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789475073.git.zhuhui@kylinos.cn> <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
In-Reply-To: <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Thu, 17 Sep 2026 05:47:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wggMLKcxwtDhzPS-P2sF_NyqL8tsKKnP1jdk04aCECAg@mail.gmail.com>
X-Gm-Features: AcwNN1X8tj6qrT264I7u0puPG663sCANci7__uZPqHwmsLy7UyUcS1gzMfRwgL0
Message-ID: <CAGsJ_4wggMLKcxwtDhzPS-P2sF_NyqL8tsKKnP1jdk04aCECAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5601A40009
X-Stat-Signature: zdx7pp563txd4gwq7ahcgjprr7ohn9mg
X-Rspam-User: 
X-HE-Tag: 1789595237-917603
X-HE-Meta: U2FsdGVkX19KNnTy3mB7yCYfalc4TdquBc0Gu4ttGnUQ+Pn+o/+Zxd/MRoQ6X0pEOUVSCy6j60kPIIcNrJ8j/Rn9uBAltIvl4fmuCK/wQtIL9UKHlqYMxdd5Fz85uxM5PqXlqgL28k6ypZgA/s4Vb3WwyvrWAcTqSD4dMhWn10oSYBG104qECKcn7nn44HXZHGFcMkv55A9+HeocRvcwUTDyp53uXUc3jAxhI9ZwAo5eKse1ua9HYhMTanRUbCmHo5Azjdh5LqhfkOcK0pEqlzPN+I/jANPtE/s2ENsyBUEHabWIXk7QT5YrwT/gVPaQc83RTu8u4Tn/il09qssx5FuA0HrD5jicUUiOUcXETbeu8/RTJwjtvxGXrRjS0clP/vatiZRYCP9PRzWxW7HG0nfuAhB1N82XU+VLqI/T4Ran8Ns1tkWXTllPUh3hjUtVW2C/2UlMFQBL4zLXtop3oOXpCH9MJ3GKJp3s3TxWVUcIxbnsL50VeHJNqPPsOXne9r4Y+sSWhsl0sIvPx+DSXO+1wlneobzmIt3c7/0oOLxqtdwtJur8Y9DWjoi+mGQDiVq22QHkeuXPw4EjtdeLpycfDaGLVawLqvYmEvCdomM5qhGJ5gHY/EXOx5/1sIqoi6oXlQwCg4o5TphC103MCjUX7Qs1bOJ/wX6jRqnJbrHBpE4h9Mu+IliMHJMDe3bGX/UxSzpIZ1RPLzw/om7EGmgE1D+nWiUFvHSavxUMwEjC/hbMLYEVf8DOmWNflRHF2jvn2QHWUTVIJdDUD1n3DATfFSvxmv/ACukoVXe/cLlbX1HzQPdi6GmCjM1vT3TIp8MkszKZf+TpdeQ+UEDk6B+OikX3oQarwR098fEhfwQXN5xAl6xQ1r3o3sLv9L3Ye8vlGvD06AddTSkL90VghxQb1CSMHWUV0ibyN4DpGrYTm+eukucps7DfgFBKGwS01eD3ZJLc06qy1EikT27
 SHzyR9Vu
 tm58pcWgVx2Q1t6WGyCZ1RJRU5ZrPRKYzNpqC+BpHyVxsxQapSfuxaTaDBaT0WVpCSODBC04XRwA/LXrbjhmioE5D0aVfzkjPg5jpkevCkDpZDJTaJOQ4H0mNbBwx4gzP5TJFbszoeuX1j44NY0L3BoGpMcCJM6N4EUSljHp5Zt8x+WuEbqcMCX4xjDcUS8+nCBdSJVnBzuvkwLvy/nYrSVTbxYVeJ7/dIbzKDRZp8jKYzOUJSatGlAULrDS0HHmfp6JGuzDa+n7RvuaXZiO96w3c6luup9CsO9L2HmxJR8M/FOQTiaKAjHYZOCIvYl8UgoVcN9lVU2ISTK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 8:30=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
[...]
>  /**
> @@ -159,6 +161,47 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct m=
em_cgroup *memcg)
>         mem_cgroup_flush_stats(memcg);
>  }
>
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory cgro=
up
> + * @memcg: the target memory cgroup to reclaim from
> + * @size: the amount of memory to reclaim, in bytes, clamped to
> + *        MEMCG_CHARGE_BATCH
> + * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS,
> + *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own

I assume you missed the word "swappiness" here: "use the memcg's own
swappiness".

Best Regards
Barry

