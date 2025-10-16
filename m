Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0603CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FBC8E0006; Thu, 16 Oct 2025 12:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0574A8E0002; Thu, 16 Oct 2025 12:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6B68E0006; Thu, 16 Oct 2025 12:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD1708E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:56:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB7FC8710C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:56:45 +0000 (UTC)
X-FDA: 84004581570.09.E5D3C56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA4FDC0011
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:56:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/CFt/Yq";
	spf=pass (imf22.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760633804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WSdRaFyp8jG6KepBvP1OhawTxkUvJdGmPcrsVy0lLo=;
	b=8QlWucbRtCtBwb+UAxL17cfx9Y39M+SiLnr0Z3gtGVU23dZ+VUa2Vi45VVFZ8nqzxP1s7F
	RkPZWstXHgZIaKgsURHsFZEvnpw/bOwacETlrev9EPkE7uhD/x7B2kxEE1b1gIKowiNqUl
	rv2FjQR1KbGzhOn+Ipl0ldRMo7WR8W8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760633804; a=rsa-sha256;
	cv=none;
	b=SB6BNVLajijhRmtzgTz4XtfTMZ9lLPPO0CzuamrKUy1qH/lpIpAU2/oaPKDknKUsJVbjE3
	HuQplyAsHzBRcDjfCWHreZ2WJ9NilyizguoZuKKllnBctvmJ2/FhWJcfGgN9nJ7Q4rOWPL
	pi3JyhT1HBgs9+Q0Mbwf3MBlkklkfUM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/CFt/Yq";
	spf=pass (imf22.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A785348F1B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D2DC19423
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760633802;
	bh=lT3/WN793E3hmsKlV3Mjpvn8YcwRjpj6HiHw/Gsv94c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E/CFt/YqGcgPjjKLVElriNlbNS30ISd0zQ46ZSNGeyYGh1Qj1y/F3nkgTRWfKMBGS
	 tdO/VgEc6lO6EjPBHCgxIod76f2CACJ4Oj2Xt3i+vRoXcOA9Jdw2os7SsZKH99vQqq
	 0m5R/F7tT5lKw/BLk+sQoaW13df5y0WceNZKpA8aJ/JgUgxro0DSfToGMJiY/PxhPY
	 2I0gTMbqajz+60s6Z8v2m3LfSMEVZvJlXcg2Px54n2AVyJKMfij7xSr/6o1J5z43Ls
	 qAv9SvjDPm8kGHYAipU99jPyScJiMfkp4RgwiM+atpArgZ9frRMSURpjk/j0fidUNd
	 mTil/66G6uNTw==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-87c148fb575so15470346d6.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:56:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKci3Zz4nWbPAl6CqVEsOM6d1G0tZUpBskPP2DVFRKK4DBACv2tPkK/R/xEIrWaYdNpsGF1VV+WA==@kvack.org
X-Gm-Message-State: AOJu0YxnS9RoeFHI4sLXnVw6sE041HwY60ERoLv+OFc3knBkTRRPEr7A
	iv+Hv2aqyTbFOu55l0elxhNebyfHOVeizA4xNlWBATTaPQOwOerskVZyv0p3C8MSjUxDnh/NfIB
	OeladR1tSMLbgLJotBZ+XRENrkvr8Jus=
X-Google-Smtp-Source: AGHT+IF+HoQA4ciDMMviejFII3nUssbgT5ZSnVzYGzdwehWfE8yAF5630JTnehlsTNz8VnnPiDfnlb85h6DaamzoR1Q=
X-Received: by 2002:a05:6214:2407:b0:7fd:2bc6:6cb0 with SMTP id
 6a1803df08f44-87c206322b0mr13294636d6.55.1760633801627; Thu, 16 Oct 2025
 09:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251016063929.13830-1-laoar.shao@gmail.com>
In-Reply-To: <20251016063929.13830-1-laoar.shao@gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 16 Oct 2025 09:56:30 -0700
X-Gmail-Original-Message-ID: <CAHzjS_tewz0H5G__hQdM2WgzOiq8t5ZyL=9YuicPF2ttU5mQYQ@mail.gmail.com>
X-Gm-Features: AS18NWC8TpcdquMnfHO00o6pVWtFSIROc7Gq2f3MZQyIZcDqnLvt-ixjbGTQi0w
Message-ID: <CAHzjS_tewz0H5G__hQdM2WgzOiq8t5ZyL=9YuicPF2ttU5mQYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] bpf: MM related minor changes
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org, 
	yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, root <root@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: fog75e7z1j75cno68daiu8cm7tw54n6n
X-Rspam-User: 
X-Rspamd-Queue-Id: CA4FDC0011
X-HE-Tag: 1760633803-177082
X-HE-Meta: U2FsdGVkX19uKnr/+Pwi3S5HPyAzkMqIJzE02OUFAzj2lRdLPlcPCWMa2trXYarGSYPgXTlOT5vgIpRYFfxhmnXV6oCtbBFnvdDe1RQX+X3eAVeh8APFkSTkxPujzdhjFR66mvJ1pL2hFM2/CAqtIqUo++QKemkvUYwyfz1oNJAEkiM7NAzPemjQCair4kXe5XccJWTLNRG0PPStDfYgUq3zXd/A7AXJv0iPX9p0ot8jhVvKcKKgNEwLCWxrm2kIAvfxjUZe74G0LA2dnDuZ8wK6USYhcDDroe2CfvyU6NEezpPQq64nmEtoPCeLj1MPZG3i6e6fcSS1qnE+KjvsmEvpWvh+JgHdF/jwudnBY88wJa6BXRk52lAE0L3GyctkgrDDG9qruNrZhLmvfns+QbwCULr2NqTpkpdAspA/nDZkoqaKdbshMSFzh9OsHEcQ73jVd7Yq1vJHq+9C7ba1KG1XmMksPIicjDoYvgNKC3J5XkY5R16MojRAAjPTJcP1QCDbl7M4Gc2YAH8gblpB9qfWmGCUFPsNSvIL0sgRBck4zfEDsx+WK/wKB1QmMQlMsq7ZfItHZz6pMOF4XgX6wmqfUgdaY76w1NVI6dn3lD7qBG53tfL4jupR+zK0r9uGKgByKoaXVaEmlyUiugIV4pwdjpIBB6dOLGBUG202G04LI8vYFghXt9PPk6wFtHfgQqxc5MQKXyGaS8B9ZCjSEfRwtC7ZZumZhz5g8QNn+s3QxoJn3G+bYEw2FtcnZPFdoQFSUUkPXkpwlRf5Tlx6Lfg23h/QlJgsc1Dq6QKedt+1pJyj7iQvfA9+EwkpFMqxWtuf7/rIQIbuzOCvs/rAFX2N8m9DNpmlQKoCDdjkMKeNQxQW5GOt6mapB7pIw/Fxmibh4afp4hrXiSH1LVc4WKEzxsB55dQ9/gWhOmr/RafxyFhvFF0l0eL/E3PpLt2oPF4g0rE+H4wb+nxMcDJ
 cQwkqbNw
 Et13RNZEpBSPyD8d0RNFgbaYLNGyQwkCUI9Bl9d/dXWQc6W0dfOVC23+1mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:39=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> From: root <root@localhost.localdomain>
>
> These two minor patches were developed during the implementation of
> BPF-THP:
>
>   https://lwn.net/Articles/1042138/
>
> As suggested by Andrii, they are being submitted separately for review.
>
> Yafang Shao (2):
>   bpf: mark mm->owner as __safe_rcu_or_null
>   bpf: mark vma->{vm_mm,vm_file} as __safe_trusted_or_null
>
>  kernel/bpf/verifier.c                   | 9 +++++++++
>  tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)

For the set:

Acked-by: Song Liu <song@kernel.org>

