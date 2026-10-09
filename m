Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF87CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2046B008A; Fri,  9 Oct 2026 03:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34B26B0092; Fri,  9 Oct 2026 03:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC636B009D; Fri,  9 Oct 2026 03:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8A266B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:30:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0841C026B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:30:29 +0000 (UTC)
X-FDA: 85302264978.26.4608454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98F89140010
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:30:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwIUDr3s;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791531027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYDZY2uGKu33vKOyYd6NW2GKWHjdqDv69Ge3kjWDmHg=;
	b=7K7F6rn1BveRFt9gIj5p7XwYHKji1pBdrJKCTQTLZNAhMaoEO+U60lYADy4CkmBGtSZssF
	s0eWAk+/Si+FQLuq2WvGTkLA9ktFxVjlXOQrfec/WmmYLjhGmebVpuVOEASTdiRwxV/zpq
	GQaXmgMo33GwO9qNfMY4BHsAaKZBe+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791531027;
	b=eRaO8uzPHIg58DU55QdgJIwh0kHW/PFredwhF8WVhOAe6QeyhkqhkJut93dYnwpdYnRbSd
	Ujbk14N22ZxSRVu89mgl/uxeRUyFdwG0aVFmAiZx7tVJx7ThMdfn8/KEz+w4s+iWDcCdE8
	HD/JaucRAlmguYv5YdlZOY63UlgISWI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwIUDr3s;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC39D43ADE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E71F00898
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791531026;
	bh=VYDZY2uGKu33vKOyYd6NW2GKWHjdqDv69Ge3kjWDmHg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JwIUDr3s/MfSM7kcKnUID52hZC5kSpTTuEkc+3ww3rh3REqeBLTEOlZBf7UExohXk
	 +ijBF1puacoxRVPWtk0LaU/94rCUSoT5K3cvAilB+Zz0MHDfI/Yo28jkhr2a6cRlDp
	 V42CMcttMu55r75vyi06asWkSVicuIkNE5b+hm6t2i+9L+HUK3/9o28y1FwlHhl+dg
	 u2FOqySJdm4iM+LdE+eyTYYNTnfmMi2tYlsNDVfxeYuj+uBbxR7Q+kNVfkGmOGYRw3
	 +plZLYhbBRrMmbUfgBO2bGQohQRCbUuHjMNyoS/p8rlHGES0lkj/bs9zM8LUcLizOr
	 7/kwdUfQ5x4MA==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e5f819884so413045785a.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:30:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxcyH6nGa/KJy5pEUVnemDw8euVQuod7UqRIQzEIHM6vCbfmp8luetqLthTrp/cDt/TlGeXzHMZDw==@kvack.org
X-Gm-Message-State: AFuF++npmnadZ5laJ7eDP3M0yFfkb4LVHOcfCqm+21SljfebF4TCHKDR
	QHX4B8oKIe0Ae8aPN8g6uPbXyD0AbuXum2DgdrtoL72qL64M0Izd1YnpUVa4rw+esoUmSw9opEe
	sN8jqYo67ajUofc4SRQhS0pKfBcwlmwg=
X-Received: by 2002:a05:620a:a416:20b0:93e:c12c:9b76 with SMTP id
 af79cd13be357-93ec12c9f3cmr30877285a.81.1791531025574; Fri, 09 Oct 2026
 00:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20261009062637.176005-1-hui.zhu@linux.dev>
In-Reply-To: <20261009062637.176005-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 9 Oct 2026 15:30:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xYGDXMKjbcnkvZAVf3GEd_bnjdJY=84dfyak=rmQVA1Q@mail.gmail.com>
X-Gm-Features: AclHuK-MFYBp2Fx57JVqeSVV6ggA-SIdiDol7zrPg6odH2nr65hN0ZFPuJg2TWo
Message-ID: <CAGsJ_4xYGDXMKjbcnkvZAVf3GEd_bnjdJY=84dfyak=rmQVA1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] selftests/bpf: Add bpf_proactive_reclaim test
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98F89140010
X-Stat-Signature: yosassapkb9bo8dnhhj69zwhb1yohg87
X-HE-Tag: 1791531027-3732
X-HE-Meta: U2FsdGVkX1/vqg5k6Rk0JjBo81N645P3KiSFuOc+u9829VVFk/cFNdfv2Dg1LwaR7GQgZ6kxEuoI2ZMMbtbARptj/LxSP0ulTnIkD861CIGy5Cg8cHNkPH7zYMNZa1WdBBrnInTWjtQTGP7y9heQFlyLvwWdlGM9Ksl89NNhDux7YdWFsXzIWl64bf1rYFL67NxXNFCnhfCIuqoFC43yJK+B32X7b7dnpBJwDzxas5rdsiX6SXlfZ7dTxyyB7MGT19I/ARHAHnNkPwSgfh4uPCTzWJVt5UKcRVVdarAzDs4ZzINk09YSzVyYzgLTfNQM5nIzxJWz3fUhqIYZQK2Q0zj8l0dowdGYlxZzS1DtA8XYHbJBPXdtm7cS9CIO/M5xGgR9meDZK58sXIkqpkcpAvwv0ej0bKTiGw1CZQ7AEXVPHe3bm7tdKX+2wM4n2x04lUOFjkdSAtnJN5OdIBl3+fUQiRfdKuLIVJUfKflLQOg+5nHi7ho/Ga0PiAXQQrU5XDNGdiAGv4epH+q0F0nXv1yeLXqlw09rjfdXqjfkqMGkZeK8GGEVa3WbeDvfFwcIj3eJn5ofON9vbR9YvLc6H4UELFP49bwB12e+xf1wliiZopJxb7+cwwl7g7+4n4GBKEVmfrc6wNtblr5wcn/PhdIofaoopS1yGKbFKfioNJx9wUhZTPRhCr0lrhULFdKEEpwzcidfMWMCxdbNpf8JTfIuC9F4VfySMClWi6Cbu/8BfOUP5bXMCct9FF0QxjzSkO+epX8QixRgM+cRJVj0AoT3kPKH7qutY8kw7kflwQ8X6DfOh84XnI/3jfJzoSqL55O94SwQ5RuC5KN32igwdFwfQuKMoAiJ68EilpeOZ9qnZg5lHW0kv0LwPo2Cd/K5hG/w+VIGSvK0gU2d2mug1BJg/MFO9T0XBsu5AF/U4yQ5UtFEK/1FowqzhiA2fUJTOcK3yBYekeOWUzRgzz+
 8ZO+5Huk
 XaxtNkH63ItXEZLhz4fL9Y3suIs6gYiU5n2viU26BZyEgwyt5yNKujjl2H4TaiJUbW1bn5kckkbrByNrdgvBrNFnq/JF/kqKBajDY+qA7svJJso4viAELiE1nz44veKUJqd5B3cgqoxrtJYNZLmAYPoCD+CPtdxmbZSR4cBEmcOfnzdncF3/h9PEgET8jsX/PonqxB4qGIei8VkDIyjF438LHj7LERFWrvmG35/+sM/emexA0NUS6wedTOjSgk5oUrS0eG6byJk+XHJoDhon07gGvadX6Cs/HApEx1ryjO7mneN2OXsrX58G3VeJ91iSMttE35kxJccnyLL6p3ONFY5qmagd4ss8PmCvB5tHxiScNXGNyBLMBRjFx2CjGoeEEmNBR+l7jHfLK8jGfiZQ+xU9rB2qkFti4H9lY12fO6fjbpjkIRxrD5w9MvLVYi+VaCTkbjOf9lFr2dEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 2:27=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
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

Thanks very much!

Reviewed-by: Barry Song <baohua@kernel.org>

