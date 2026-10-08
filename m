Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A36CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABB76B0092; Thu,  8 Oct 2026 07:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85C286B0093; Thu,  8 Oct 2026 07:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7997F6B0095; Thu,  8 Oct 2026 07:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7A96B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:19:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E94EDA75C3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:19:14 +0000 (UTC)
X-FDA: 85299212628.12.3AA36EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 213BF120006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:19:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nC4yXMux;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791458353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZcC7/xg5SS/eaNUvNNF7JTQ0EBiXnoG/PlgqRlweyg=;
	b=QN00wkh02TENWWXp0++cnuZEOrKBWJGPMM8MSI2fYYeJKqofF62pUkMvATL+e3rdPvj/go
	LpqbsKNXK9llxuHS6HeOGnR38awTaH488lOefbPBEG9RwmPMCxQAh11Vw9bDweCflfmBoU
	o1Q2LAhr+FwKH0IRn0LMiY6a+YELxyc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nC4yXMux;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791458353;
	b=nnVGtpFZ4fd2Vn1g6ZDaX+9DsvGbIfYiP3AUzUH83qJFoUWY1degfK0r0Xj6bQhM7vXkNR
	+ybinlsb4YLjCYqqQW1YYHB/CQCX64R6LyGNvmhkvsOHi/P1BSZJMjLyzfbcoBeIGpMBwd
	rcGWCji4I9nfv3hzMb10JDa54gGMG2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 939B96025A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7E51F00899
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458352;
	bh=NZcC7/xg5SS/eaNUvNNF7JTQ0EBiXnoG/PlgqRlweyg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nC4yXMuxmMjU60Le+2fG+FqvSiQ7rKPZNcghMiB9i2JnmXYHvWr8CHGKo+cUg3eyC
	 tyz9yAp6jv7crdC0S35QVoCksEC9JaXnDlY8BJ92Nf36FysG12iKwvFwx8xsakSXKy
	 hHhua4yCU8H6sT3Xu229n9WyhY6PlU5iQcUSNzEwcKrCe/nMCecXfR8WB5n6dvNo6f
	 h8epILmsasVrPcPpm7tSqZOm0INZWaRL80oyengNFl01gcPbbCiOhUsXqei+Xm4juT
	 P43mQ9wQ4SqKMvX/hVwh7JPj7Cu8DxPF4NEFqi6yryVN3JWVxwD8OLfJSS7Q5cMgL0
	 ipSoSLdzkMJ/g==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e441e14a1so400835585a.2
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 04:19:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxTNzwunLbz0CYr6OabyOhAMi3UjyjNlfLFy+7AaXB8y4voc0aI1rlurfuGg4KYXFP4lwcRO9cPxg==@kvack.org
X-Gm-Message-State: AFuF++lOWcsxJcDj8e2xumUZv8Zu2bQKAU2okASlIt+mDIW9y+YXxCSJ
	r5aFLTs1wK1PtcpW3ynzAwzri6rwRbKuM7x0J9DQ4qKF38E9o2/5zsK9FXO9+c0Wzluxq6aVV2y
	BESqjG5BTJy8cjW6wpluYBplnczo2R0A=
X-Received: by 2002:a05:620a:4709:b0:939:761c:4f59 with SMTP id
 af79cd13be357-93e9b76c78amr924707585a.16.1791458351308; Thu, 08 Oct 2026
 04:19:11 -0700 (PDT)
MIME-Version: 1.0
References: <20261008070928.113530-1-hui.zhu@linux.dev>
In-Reply-To: <20261008070928.113530-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 8 Oct 2026 19:19:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wW=XXe6=1GucvA1pUSkhLCosJh+bc0-97cYGGWW=MtPw@mail.gmail.com>
X-Gm-Features: AclHuK9Y4gxfKhBzGtl0K9V-EYLUU5MKewRW9HUXdq9571fi07WGLf_34qgAkY8
Message-ID: <CAGsJ_4wW=XXe6=1GucvA1pUSkhLCosJh+bc0-97cYGGWW=MtPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: Add bpf_proactive_reclaim test
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 213BF120006
X-Rspam-User: 
X-Stat-Signature: mukrrkfdjq6muc4q6u3xatko7teaxea7
X-HE-Tag: 1791458352-956333
X-HE-Meta: U2FsdGVkX1/KPjaK3egWMEubUyJJfKfzyWrYrOZU8P6TU9mAmSwy4Tn3Qs9tV25IVc97wOjwLr/y6HSIZMi5vx54i4IOUKwYfD5mhqUU7ngBj++njCopaTq10S/YWsbLVbFc3PrjlSq6usEHaGkHHQXV6lOTEugyv1uLrZwlCtkJQKe/0SN8VE4wc0opSK83QlrTGTn5NgnpREn9ShVmM5O5CRU3SKc4R1+Gbd8ThwhrUjD2LmA0PflYM+GH1tkd0BF56WsyoqwcArm14Much0U+X8/HTGLds1kaa1/VFZnisHpkesqIT3yFhS0TW9cGv4Z3BQfCMTOzjGHjhRGO5HilmpK8QVMTx8C2odggAelKDEZKhHwhRYWSL+XLaAQLcVjyVbN28w7dq9bL1ovEk5juoS4Oy/PDIR3CsutXtrMEpgxrGqh2wl5dO8VDNt2GXBy4aRk8dpbyr375D3dA+jQdYUQ5nfr04CBlbTeWecDtSAsEJeASvlRpuzas0Z/Mr1mB7sIMjpy2Av4Nj0ZcEU47677fTd+aeljpIfvKdklYcneX+m4/7ZpUSlPHTj2VsFdrhzXXdve9LCkKOPWWx+N9x65/Copj1JZxEd31viym3Oqc9KfY2GR5EBYo0rcZd72VdO96ZhihAZciRhNc5cWc4wzSnk9O5DT8Vn/zRkeie/JSf7VNAQb8Sz63vQ/hLTYW22Ek96NpaeJyTFa9LiwO5mp66y7sqsqDdCGKN30N6Dl+BKjmjtXD83dmZjF9tWUOF+S8ZI3lOVCBbxsXsPccpp6OCc1f9ILCHFzBsyLthMT+yJC9pbSiNeavysM2G5XeVrCx8YSf4Zsyp1b+fiMoO0zZFxwFXRHpbqCEE9NHTjWTFUM/+wK1hAZ204wyG5ML7dPi/1RO1ElV+ahaaKt29IwYxvJl27SANqk0mFQrDoS0vVSJZ4GjCEZbgE/HoeX8QxhP0vIFTJbiy5h
 p7WSP5yX
 F2R8+N/KKcuAQR/BN3F8X7S2rZGeVIf6LwCamm/eokZB+pF+zzRqGkBeV4HJ5+JVF4qByMd1b6lDryxNpBCLdr6AzmtAVPpXOj/mw5YFom2gxGxDYjQ9Ac0I5T1LwnIPFrJyFXP+GbBryuqBzqFhz1RMl4WGdUdrz7H3ab0mw/G1B7IDJfGG+OSs2oBtd41sT/v7oI3AFQJrRJQVNxds8op7Vulp+fmV+Z248gFLxBKBDvKZtPaevACAy/XNCKvpQR0TPLiniNOBa+vzLegHRfnxguGgfk0d2HehGu+Se0lV3KLSL67ZqunB+DK6C6ZnEv71TNvRmNTCC4VJxNqHG7FMj7s9tsmi0k0WEXSzZPtu3NMgi3sBVkE3nZvUMRM6JKwUyrnaCYMVvZ/5HqFgn+6CmqtC2c7sgOSUxQWZ9eAtW5+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 3:10=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> bpf_proactive_reclaim() performs one bounded reclaim pass per call and,
> unlike a write to memory.reclaim, does not retry until the goal is
> reached.
>
> Charge 32 MiB of page cache to a cgroup, ask for all of it in one call,
> and check that the result is positive but well below the request: one
> pass is capped at MEMCG_CHARGE_BATCH pages, far short of 32 MiB on both
> 4K and 64K page kernels.
>
> The test deliberately covers only the kfunc itself. A full example of
> the intended asynchronous use, where a BPF program watches one cgroup's
> workingset refaults and reclaims another one from bpf_wq callbacks, is
> maintained out of tree at [1], released under GPLv2.
>
> Add CONFIG_MEMCG to the config fragment, without which mm/bpf_memcontrol.=
c
> is not built at all.
>
> [1] https://github.com/teawater/memcg-async-reclaim
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
[...]

> +
> +       /*
> +        * Both candidate directories can be tmpfs (initramfs-based CI, f=
or
> +        * instance). That is an environment limitation, not a test failu=
re.
> +        */
> +       dir =3D workload_dir();
> +       if (!dir) {
> +               test__skip();
> +               return;
> +       }
> +
> +       snprintf(data_file, sizeof(data_file),
> +                "%s/memcg_proactive_reclaim_XXXXXX", dir);
> +       data_fd =3D mkstemp(data_file);

If we can't write to the directory, will `mkstemp()` fail?
Should we check `access(dir, W_OK)` first?

> +       if (!ASSERT_GE(data_fd, 0, "mkstemp"))
> +               return;
> +

Best Regards
Barry

