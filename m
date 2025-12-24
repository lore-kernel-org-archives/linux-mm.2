Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E46E6B279
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E256B0005; Tue, 23 Dec 2025 22:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1426B0088; Tue, 23 Dec 2025 22:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0836B008A; Tue, 23 Dec 2025 22:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC9116B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:01:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 802651A05C7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:01:58 +0000 (UTC)
X-FDA: 84252865116.20.6D471A0
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3DEC100007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:01:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YXALmkUw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766545316; a=rsa-sha256;
	cv=none;
	b=wjQUxdmCkQDgCD1i32AKAIijN5XCg2AwWdr+DWWEIC+vVNQtLXnRxQ6qDe+EUgTxEljEUH
	8vUR8yvbSByhJ/gg1O9QpGYBjKju/WK97HIDj4D6xflJ7rw6dqRBj9jF1NN9/vewGwEDhe
	g8AMx+3a4SgaWV94v/QC9rOq3uZWqk0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YXALmkUw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766545316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCfEpD5so7+LP1vUfgHognLhOxYtZgdClO2gE1jIbZY=;
	b=1me4QVeR2l3iRPysgHPBt1D5ICCRkWVrdQAIBJ6LhzHJIt2Akzri31+wYZzE5bvj6ss5C+
	Yb2MqSrxZeHSpWmbEfWpEBqbKrqKc1aDHOMBhX/vtEx/aY8lIFMvMVn6KDq36gr/ZQgp+Q
	8NUvtXsqLSjLCAKH1g2IynI9pJQmXOs=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-642fcb38f35so4522657d50.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766545316; x=1767150116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCfEpD5so7+LP1vUfgHognLhOxYtZgdClO2gE1jIbZY=;
        b=YXALmkUw+tC0iKupSfgb5HGD7/jb/5P0EHN6bqDyFWECQMy7ropfY8fC01Y2NichDv
         mXO9Lt7MQP9cUT1H0qy5lgVTFAUAPrdwjMzO/xFhi+F8nh4SLQyDdVFQYqTdybRBaodQ
         WkS+xINz18mBM3XwFmDdMqwiCpBHyV9qrY0SO7bB2oooLm7DC0v5L7ORp8AHad9ibE5+
         Dw2y8lCtPDu6Z4pCuXA/I3DGyUcIpc8dMOfEt1zrgRQJFRJOOmBqlh5Ya+OXcOufRKTx
         AofI4tPrnnBLleNCvg0/5Ogkkg5VUhHh2MMUDEsSjO/sWSx6vW2/fWQDdYUMUp18D+EG
         /vEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766545316; x=1767150116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vCfEpD5so7+LP1vUfgHognLhOxYtZgdClO2gE1jIbZY=;
        b=C9T+PVJJVaU0RQP4UYswcVCNHyxtPmayjX95k2xlz3B+Gqmzk2teREvTvSyjmzqXLv
         t5pcx1C1P49ujZZq+GQIWrrExZeJKY8eovUwDMuxsIvtW+44xv1JVAFdUJqijjZX2Sfh
         gwCnX4nLLhkFUMMx3D5sovTlB8hGPBt8KFlpvqxzCsFQjZAMOmguLFYu0Mglt/p9ymtS
         siYTKZbJDkYzVKZ7NqHTtz7c7bqjmX/TKzdAkjZEEOyOAvHYG1aaYQR+l7EfRg4zA2ak
         9Ye/sJgJ7/yQ/ABmA00ROz65ayEVg3A0S9ZO2Bkxj7YaLS3engvnzZ1Uj7cXL/yIYGTI
         XWwg==
X-Forwarded-Encrypted: i=1; AJvYcCWqnHl94fhuH4DjnLpNO5loePMBR7q7GzBhBCmlvzKky06AALEDfZ9OZf5pH5mfB2hyr8BeTkobhA==@kvack.org
X-Gm-Message-State: AOJu0YxT8XSazX2+AgaohNyQ4nApvVSic4FrDVw2dStpeprGsN7NMXXL
	q7UdgYk120MGPc3aN02gPJoueyYHSQQPuiPD5+lTm4HYV8dc0BKyWLuwFFrtfKGlc0On+N8AwiF
	TCYm/qW+InbmF0Km3hiSezgQ51phDiUU=
X-Gm-Gg: AY/fxX6X63V4fYptzqaeTrC0GRoTkwDRAAEj8SUXh3/ASdl5DLYQ9mpG1ezoxC5FClt
	JKzFeQhDMGhwhhndOYdWSAxLQz+kUV1ZzsYYFNGjbzIT1H3Gn5WoW4C4+iPSH2+kaADboIGXa4w
	/EmCsPdCGat9kQyrUE7mlY7y36YtO/nO8ehKvBfrs8+Ydgt2mM6Vb/EQ72Y9kS7qwv7m3wNNtsp
	zfnoAeqzqdYxpQK/INq6T0DM9PCJVNSKfWEjw+juKVpPm9M5cVmE8FTdvLTviv3n4vou1r0
X-Google-Smtp-Source: AGHT+IFbwWNUxSaChd2OuHftBW+AAdLfRyTXjDRPDHTwTeLXfg251DqBzw5mdGlkv0MXjfSaYz7092MOEjJvUXs4sSA=
X-Received: by 2002:a05:690e:206:b0:63d:bfad:6c7 with SMTP id
 956f58d0204a3-6466a8aba70mr9964995d50.58.1766545315638; Tue, 23 Dec 2025
 19:01:55 -0800 (PST)
MIME-Version: 1.0
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Dec 2025 11:01:18 +0800
X-Gm-Features: AQt7F2pR7dGxQ6UGyYEhLIEnnYYQxm2KwapPQ3bSkmjzaZNl2u4VYPoOrRhcJS0
Message-ID: <CALOAHbAQQ59mSmh8aO47jnDjOu9S+FESxKw+YUp9g2Q2qvqedA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A3DEC100007
X-Rspamd-Server: rspam10
X-Stat-Signature: 14tzsfc44josmqm76r9rp1zorzh1hi94
X-HE-Tag: 1766545316-991099
X-HE-Meta: U2FsdGVkX19dZZHDe9u8OO4NrimNbjxeFbytch8SlcAFNwE0Loz2rbEdhYNxElIhkoMV9Tmyq1dlzrBE5XXlvIMFkt1Y9AJvmmf0RolbDj7KNXdTk2go9yLd2AIB33DHiGxLt8dwavL25925eGyDIKcAZQKhp2/Hz23Rlo61QkvMdOC5QgA4bKoUCRzPnVNzkuZNuScfgQCnUscnnpjNdIVliN8mcVTaqGCGxhsXpbWoWOUyfIBcAHjjL33yJHcmr9YU48m8otrm7M3Y2mR1E1PdpvrDFWLhkFJKqAtu/to9Luf+YM5i9TAfVUQDEN6qppa96KOswJzIuZl3EEZVYXAU2bZKTsi77DOYkPWw/F4vaZSWRGZMc5ClnNN+/j9FGe46P4Fidavg/o6OpFa91BSjMXGAPzBb2ZgjP6QvXcjPRTpE/45PwPG61KEjK+YKaomfDQPD7JIvT+Ivymgo3+qANaD7B43cz03ElLilsTrgVkdNYc9FTECbqKCB3sEBwFRb1GT6eTGfgxay3n11us1RJ2JhxQ+cpDC0d1pkNywNJMEtVnSTjrSzIB75eQ7Mft3kR6V1Z81Zc1tOsLE1hu6TstaxU5x6uiQT9Bzoz0IalRiFTNlygs4T35KvV1izHuV2yL0W8WRdqVcFqEVKtI20dGMgGrb9V1l9XjrinluCZZVMGCdM4YcJWkniZ5S8NO89Om1o+JxmX7Z7EUBXjXcTgoo9xRxoiNj54sR0NK/B/f/8gxGt33Z728lntUF/iZvEo1WXXBPII77K7PrbNax4pLkObHBSa0UsBAxOfSjI0yotOqkfgi6SnCcfZFu/tZW4ZDE55PZHWrz/y/H91e+WfezcTqjnKzG/g65qqFWw5JLhg01fs6BOmUesaqTSE3OmDiWp0ap/yMJ/bvsU4YP8S162A5m67rh6dn8r6AAWP1fiCWVWYvZuxVdTwndReo/tzdDYjJqIORsSA4v
 t53zOcL8
 +N/8vSeyKKfbvxvEBHuWGLEeoRj70Xf16BvEp1QUfYNaa4P/bAUbLIMQr9zz3nb7q5WitI/qXzrXdY0WXQQplSvZ66ormzZNEawPDyyACii7gaQGYY+ljsLVVn4Zkst5AJugXgPM6JvJaAe6x9tTbN6FHlb5DvDyXVl10Reo1PJeH5wiczOXqFqi7cZZw6i6FOlOtqXkQvxBC+xyCJcqbZ6nykMuNK8NiOeIrd9fySpj4Vt3347TBVh1YdnygUeOL2ibgoNZzgTYjQfV1xVG+E1MzI5ST4MYKlAT2bf2iHlEPbJfMqyDkLDu68UlazEuyTc3zsKqWCVIp9b2VyEW6Mvjg9zGyZgGsx5OA1/0dTShHNgM36gNCEHOT4hzb4om8IuOr/RnRJ5GiKY8F6ET27VG6jgnd3l4GxNxBYxjTZOufLbDNVYa56PonlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 12:43=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Introduce kfuncs to simplify the access to the memcg data.
> These kfuncs can be used to accelerate monitoring use cases and
> for implementing custom OOM policies once BPF OOM is landed.
>
> This patchset was separated out from the BPF OOM patchset to simplify
> the logistics and accelerate the landing of the part which is useful
> by itself. No functional changes since BPF OOM v2.

Hello Roman,

Thanks for driving the BPF-MM upstreaming work=E2=80=94this is great progre=
ss.

Would it be possible to upstream the bpf_st_ops and cgroups patch as a
standalone series as well? [0]

While the upstreaming of BPF-THP is currently stalled, we are actively
experimenting with more BPF-MM related features=E2=80=94like BPF-based NUMA
balancing=E2=80=94on our production servers. This work is a great fit for
per-cgroup tuning via BPF, and having your bpf_st_ops and cgroups
changes upstream would be very helpful for these efforts.

[0] https://lore.kernel.org/bpf/CAADnVQJGiH_yF=3DAoFSRy4zh20uneJgBfqGshubLM=
6aVq069Fhg@mail.gmail.com/

--=20
Regards
Yafang

