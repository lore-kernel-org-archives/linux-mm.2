Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59EFCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C356B0088; Mon, 22 Jun 2026 20:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D6F6B008A; Mon, 22 Jun 2026 20:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8337E6B008C; Mon, 22 Jun 2026 20:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC186B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:57:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D89151A0362
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:57:07 +0000 (UTC)
X-FDA: 84909363294.06.213DB22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 009F740003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:57:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZpy3ljd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782176226;
	b=LG372q+VE5SyomKofuGqjproGNhDc/0J0LsWtlJAxT0glKJeUSmU9CRDAcOKkGXtcPf70g
	4UcC29/EDzYr6JqSK3nIpnmFgnwyJlndZOu8OnQNSqCuTAEEHN3R7FVQ7IYzxItZ6widcc
	uy+WaApEe5kFKKlEtJiY3eZEV8NXI18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782176226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy1/UXd45ah16e9yAAop1Bnae6FN/RS/dISw6vg9F8Y=;
	b=iNXiuS/fdci6Eev3DYzV3CmSRdc4uS7GniAHksxsp72oDNpF9G0gYTp+Fq49g9mgZAbiwg
	P8kTbaUyQ5Ddvpq8nJzXPyPlrQvieXbwjbOxG/v55nDF3XHR6Tk55P6S3KvCDwKDUExLGa
	oICmpViyTkrnncMJfEe46M55P48VOZc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZpy3ljd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A39A43E0C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E84B1F00A3A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782176225;
	bh=zy1/UXd45ah16e9yAAop1Bnae6FN/RS/dISw6vg9F8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HZpy3ljd5DZYr/jWM/mjsP5vAG0TDoCpjrvp4HMWez6sLqvi2ZUmRyY6cyppxUj9S
	 PvKZ91/2ZuogKj6IDTmyaqz+AMXyCeJfvtSWFSKu6E8WR+Hsl7w6Q2Jujcz79WknYO
	 XTc3Gt28ZY4vyfZZp9d6yMLiCt/6Mg+jlF2e5NnQIa8X+Tx9VSpN0cVVoGV0BTGkOC
	 FjRvFpA3OGdhPH891Y3Vwj/1gRxhkqPRxjqkqyYSYouTrAMNGAwv56ImE4aLoNbxsY
	 v0zSs3hogAlzRdvq8MovCBIP8JfR2bEaxrRU5clnRA/tXtk1fA5/fybXdZKNvKe4QN
	 Bu/seAzNpC9cw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-922ade88d0aso274361185a.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:57:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8urE/p3CJb/TL1T6hMuAc9IajZqr3f443ZEbLkSflHqx3iO7leA65F1suPVr7xTP/1hBm7AkUquA==@kvack.org
X-Gm-Message-State: AOJu0YwzJ9COkjvTVmrW+UyiYpvcb5sxa5dMFEakZ+rIr8yBQkIN9LR1
	7xVNY68+YuzmViCwLNsofgiXHUnwAqFO+SoN104Ku8u63EvHD0XlK5WrZKL96e/3f49aFh17+Ji
	PJWnXGKRCX/r85Gn2pttUGMVsZfctYoc=
X-Received: by 2002:a05:620a:319b:b0:911:449d:98c0 with SMTP id
 af79cd13be357-926666837bbmr83590985a.7.1782176224599; Mon, 22 Jun 2026
 17:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com> <20260616031309.3036234-5-haowenchao22@gmail.com>
In-Reply-To: <20260616031309.3036234-5-haowenchao22@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 08:56:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x4KgeLh8uNbx_s4wtr2w3kr47QroqxTNJEfxOJ4QnrDw@mail.gmail.com>
X-Gm-Features: AVVi8CfVwRd3L5FqNTKGQuIHOmM8-HJSWjGRoBCxZH_g6I_TV-rvqM4istVpe0U
Message-ID: <CAGsJ_4x4KgeLh8uNbx_s4wtr2w3kr47QroqxTNJEfxOJ4QnrDw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] mm/zsmalloc: document free_zspage helper variants
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 009F740003
X-Rspam-User: 
X-Stat-Signature: 39sb1eon36zuoqsih6wxqwqjknttkcha
X-HE-Tag: 1782176225-334220
X-HE-Meta: U2FsdGVkX197zFPsKeGKe35vsdItMzYbNnXtk3am6PJFBv+zsOes1l0O+sxltabnBVsnLC3tNU+lkj+3GuS4eQ1usBwFCsArZgGP10DalX+9am11wGMen78VW4k1dGywn9wuM1UmtcyRMBcStpk/hyOcaMaKQGTDg0E/nt+JTQ8RIierzDeDN1H5T0hZsViNEmlbwOMgjgpXjmGB7GPcPz1eDj+/AByM8QsUaoY4OarSmUYF814hqXl/8SQRhJUfSgFMoWM/XkB7sJn9fgYiPMprzh5hhSEn4kWKBd/pmzlDloWms+ZmE5rwZSKn4lyDk0fmfEbC2Wr5e3qFwVbHQ9wu9k1b63gz3OAvhA89iRmQj2l034U3gvNu1kY1L7fITuB3yWmwbCWYthRYTzc+qoOH0RQPwBWQPAdSiL6MlpDw6fjbYAWLiH9ND+SvSSHpWHc61xZ3FpDsTd4JAZH186H6CE6BDZQIFmAPmsP94KJgeRJEyi3M8RjlDp7L/iXNtEhVdmVJ/lUlU7sl32l2KF2LMrXiX2V4rnByqMzn4XEpzgZpXFa0wo8gxdi/7g3Li485XRh1FasyCQNGxec0W/i0HJBMd+VkWIFYwrUGmp4C+ukz3Bz6ud9H2wX9qx9eUR4FG4cpXq6JGvRPxwA1lYzDRLJyMlIFkHK4VBwmZ116DLQYxZB0IT8R8tVWIaQFgyWrNmsN2+SU/y9/kP237gM0/wpj659X510W5ZGgfoionSaPLSacJRLP4Na/GoEqo+rCX4ud1GiZ5ow/Sx+LWoNiroFJ9sNXbbBnSYNyzzrIN863nst5nY0l2WWQTZjphJwon25RwZo5JhDLF9BPStDkb0oRjThj+bDi9xz31Ky9CVgfUP5pB62CmHrZXpfJOlBq2rl/PKEqgJ/vFw6z55kpM/LLN4OG1MDG0Aare/JqW0rRa0OJ6WCSDmKor43CmrrArRUzRkzxsfrd9PT
 K+m11G3n
 xxUcU9sDl0haiuIInCkzR0exGASmF6vmm7LtNHTG/UdZBhsvGAcpkh9Lj9FMwKFqsDCt6iUzf5F7+7jnahg1gS2HTOUhTMHahOLLS+3+WW6zfyIa9khuMLDnj5fjzMsAEjSxqWFlXF2ZRu972npOFolsFZmsSNVDXCyUA8CihDHBKENHDntO4LvyaqTeKggJVC5Ho5/WceGFR1cVIzkphlIYYmzxxGw51bu+EjA851TitkYV8QievfivdN2qroEr0wBvJKxtb1QAf3YOR2FN273dKFeEX0czfbuZCH7v7Djyu0H+A+32kRjqmBfVBjVcR+OfB3A3ZzoTGRpYjsBf/rpekbOtmzjcfjRlUFKehv1MGjdp+UYBSP9/Thlly5grmCinb8TBvwXOefNX4RQbOkqTbsbLIZGvSd2ln/1AfvNXio7TXTre4INHuiIFWAEqG8c75PZctMz7jvyd/ar1+gtfMwHp4zalkyLWm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:13=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
>
> From: Wenchao Hao <haowenchao@xiaomi.com>
>
> After splitting __free_zspage() into a lockless core and a wrapper that
> does the class-stat bookkeeping, three similarly-named helpers coexist:
> free_zspage / __free_zspage / __free_zspage_lockless.
>
> Add a comment block above them describing what each does and where it
> is used, so the names are not easy to confuse.
>
> No functional change.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

