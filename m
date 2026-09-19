Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70605C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 23:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393D96B0088; Sat, 19 Sep 2026 19:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E576B008A; Sat, 19 Sep 2026 19:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E90E6B008C; Sat, 19 Sep 2026 19:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAC986B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:21:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D874A5945
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:21:59 +0000 (UTC)
X-FDA: 85232086758.08.95B9E89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8EFA3100003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:21:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoQpOaeQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789860117;
	b=cYMuuqhsmYK+mIu20ot5VfeSoQiz5jqSv/RAcGksCxVxCZ9k9TqIrZA3bDcco3fXpW8PFH
	IHGN16bF2+2BAj13Qsaq0MCJ0VEs0pY89T04/cxlHIh+nkkZSEgVMEQ6i9ZXlQ3TuaUzOU
	7qbukO3jNapxiAk9QF2/NbZCLcdaJOo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoQpOaeQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789860117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2emGDt6ZD/PlD99DnGeYO2tV70JoaEZig2v2GPbr3o=;
	b=nLWCKW4b9O/aAiu4zFTAT5IUt3zd1l3u9DSRALGmTAVkG3yU+9DuvkTkjmiw9zuvN4e9g/
	ZrQZ1PXr3E2g718gFSSXgCgxYXK17nixWtFbVWW3EZdb46uLcbk6Pw5K2gd602GjKdO7Tl
	M6qtzK846S/gAf4JPrO/3vxa4Gsbd1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDE0A4451D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D171F0089A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789860116;
	bh=M2emGDt6ZD/PlD99DnGeYO2tV70JoaEZig2v2GPbr3o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NoQpOaeQ8eRPAsoWhljliNHLMkQ3/VkCPq6Mf60ggXZAQjaDGR6EPOhCbZRKkA6zP
	 8JBQFtSBywHZeSqZfLnBOH5Zx/p5FjaAKlGGTY1dvS0QJqFV0QxptDo0/2tkHVhsp6
	 C89emFqbNAmUG8VoLQ1KAD1/IJfvIgrDMhgX9EPcwrrJj8CBMkZDJGL/d8kv/1XWij
	 Loos/gXqaRuxQl84fpy6qp6QCz2U0IHfuQmZMaZOQpZHAlcd5HWlvCPlcShakGYqut
	 cwl4F1iAQgnFHslRlVMhk+RJaYI9PkSU3wF6CxecEhBKkk3x+3DUvGsJ9WX0A3N8V1
	 JcOYmO4jYetTg==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910c3d02aso83680885a.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:21:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSaENxvDmJ0u4zDtknQ/hUt4HecUbHBBOd3x2ixfQ+1oYxZHkgeuTxU5tT+uROnFCBdErrkk+P8A==@kvack.org
X-Gm-Message-State: AFuF++kTPv3309c+RJGKzzViinH2PBRr/XpsuvbFfE29UEg9UaAafkzq
	Srx3G7NJ6joBhdWYI2PAAu6ZGkh4Up7RlrsIHb6MivNV93LXfBgpJKGyer/O3MrtCqNRpxc6xcm
	F0LSebb+t3NKjIF1/juHlN3lVOdsuqBs=
X-Received: by 2002:a05:620a:4416:b0:93b:d7a4:9d4d with SMTP id
 af79cd13be357-93bf5770d59mr363723285a.32.1789860115649; Sat, 19 Sep 2026
 16:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789714023.git.zhuhui@kylinos.cn> <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
 <b115ece2-33a1-412e-ac25-38f339a13599@gmail.com> <aq2bo5Q-YUj7lkxn@linux.dev> <CAGsJ_4wauwY1-xRdM4aVb7FkSttKYzsKsWH4pF4i=Sspri0-jw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wauwY1-xRdM4aVb7FkSttKYzsKsWH4pF4i=Sspri0-jw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 20 Sep 2026 07:21:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yXMcPASKtOBZWnyN1ztoGFoGjChT3N25UrFL9QovAdGw@mail.gmail.com>
X-Gm-Features: AcwNN1U1j2QcyV3XRNhP_V-Q0Z2asX8-vPO3_K_IxjKnLVixdgROQw93LqTOeL0
Message-ID: <CAGsJ_4yXMcPASKtOBZWnyN1ztoGFoGjChT3N25UrFL9QovAdGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: JP Kobryn <inwardvessel@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EFA3100003
X-Stat-Signature: fmfczxpc7asoyhyez3ygwxoadih3h84o
X-HE-Tag: 1789860117-972721
X-HE-Meta: U2FsdGVkX1/5Hp9az/PTcurSRe/YP5UMCkuLZHGwplZwjeKpBU7Sbxr4PuftL4IK92ZE0kUVvDh8oweqcJO5PeNBOZuO6J5fZz32PEnGw9jcMRUxYrWVEHO7ZzEgKC/k+XjFQYeQ7FMT7HdJ2pfgaGO3YngFYyhma93za9yZjE4pXzJhZZYijfhpqCxGmRbJI0srYg70nIWMX1jNLiXOXHkfOsT4xHsQL1k7o9pGqPJonHDxvxst1WwLrb81U/hMwH9JGu9IEvIl4JfGDPykdDPoF5BT42JogcqMWVK+pPZqFt9M8jSjIzIYEYFOWKeU8ofMrAvpLKIZQ84qTcqJJ8gOnU30rDLSmyfVk9vDT4S9nvIWWm+OCbzKHoc0krvgOHkznl9Eq9DWZrBd3dQWx4BG2GemragN5i7qCbt0odlpoHsu0tHf/Q+3w8B6WVtvTznmmuVCTtlXyeUSgnUy51ghb5JvgjpSay1YMC7viXRmuI4lvf3hTeDvL1LQSRhcIY4yuFq/xlv5/eoEsYnd90/ydaZ1/bBekO2DMuZ23l6YUlcur4NPAZ3DmP1yat/2N9iCq9X8Z2l/o9HLnvtcYcScFr80HuEB87A1CkAW0JkHKYn+8yHvENydMtstgL/99r+zyHNBLuv6K7xRafh7ZhCmIq/7Cd70vFE9ff3UlsjtbUoM5dr04BeAzybbtitMqeSGZhoFZUG+Ncu/PoHrAsUNhxhgvQN7+C97UMGzpWxV1A+uuKhTBxvnETt1Ly1/62AfgN6f610aUd6ndnYjbKsUbmXBaEZQUaGvpIGMm4RrMOZMfpBRmzYs3p5mhB4S3bbTifrCK3Fvaa02GsCdPPKaNnKyrr3H71IkvmqvZg2/CzGKUYhAHv33HfeU2nFqV5r6xmiknjOWHdszkALaK2t1fV/vEvEM085b8EqYQq2NlSYDSL1yUtfyaqjCNE+7eRgWhO8xHtAKMWlR4Rb
 AxuZtVcq
 Mp3Mq/j7OvPT2Ly4JH7GL/Dh5nDf9AO3gDpWe6UWPn7P3wukwIuZ3r+pFyGBBClqUwJ6uGCYlV3H3ZXA/sBf2kkgTotTKVuANo/84Vj4ixyQW9nfn7zuB69Wy6LJjI3yIar12s9rG8jrYQK8F8Sl21NHo9iCQunw7vj5gsc2nGMWu7U8TuTkUMjpxIE40ICC6V64ju7R6OffTVO5wzcXKpTHtj3cBp6sMdAN6hd8x7AHRYkNJBRRTVCX/EvNld24piph0cL5Oxs95qcjZdfxjRx306+DiHeIAlqWWsYA8IMW7wGuBCY8DlG93CV5JVxJ+A9lAeC9UKC1Fo0L5Gf56RzPJqbbnHZDpocHpF2dVuv0MkT24wRf0RbCVUOfEA7VF1LnRXe4RRS1oUNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 6:36=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
[...]
> > > Related to the previous comment, you treat the special values as part=
 of
> > > the range. It works currently, but creates a layout dependency on the
> > > enum. I think it would be more future-proof if you did:
> > >
> > > if (swappiness !=3D -1 && swappiness !=3D SWAPPINESS_ANON_ONLY) {
> > >       if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
> > >               return -EINVAL;
> > > }
> > >
> > > The previous comments I brought up are now resolved, so assuming you'=
ll
> > > make the changes above you can include:
> > >
> > > Reviewed-by: JP Kobryn <jp.kobryn@linux.dev>
> >
> > Hui, please make these changes and just send this patch in next version=
.
>
> Hi JP and Shakeel,
>
> This feels a bit weird to me, since 0=E2=80=93201 are all valid
> swappiness values.
>
> 201 (`SWAPPINESS_ANON_ONLY`) is just as valid a swappiness value
> as 200. In contrast, -1 is a different story, as it indicates
> completely different semantics.
>
> If 201 is treated as a special value, then 0 (`MIN_SWAPPINESS`)
> should be treated the same way for MGLRU, since 0 means file-only
> reclaim there. This isn't the case for CLRU, where swappiness 0
> can still reclaim anon folios.
>
> If possible, I'd vote for keeping Hui's current code :-)

On second thought, you might be right, as there could theoretically be a
case where `SWAPPINESS_ANON_ONLY` is not defined as
`MAX_SWAPPINESS + 1`, but as, for example, 400 or some other value.

That said, I find `MAX_SWAPPINESS` and `SWAPPINESS_ANON_ONLY` really
weird. Somehow, I feel `MAX_SWAPPINESS` should be
`SWAPPINESS_ANON_ONLY`, since 201 is actually the maximum valid
swappiness value, rather than 200.

For the change suggested by JP, I think it is right if we don't clean up
`MAX_SWAPPINESS` and `SWAPPINESS_ANON_ONLY` properly.

With the change suggested by JP,

Reviewed-by: Barry Song <baohua@kernel.org>

