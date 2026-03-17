Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9CCFEDA0D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC196B0088; Tue, 17 Mar 2026 15:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4726B008A; Tue, 17 Mar 2026 15:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9C46B008C; Tue, 17 Mar 2026 15:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB0DC6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:48:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E381B70BF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:48:16 +0000 (UTC)
X-FDA: 84556591392.03.F606014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 732E9C000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:48:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OifmBLky;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773776894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYB0Tp+CwcbudAgZjPeHQOyW5LW+SzjR8buls9MErGw=;
	b=C0fzm8s3z+aPlczWs+H895XAGMIxQZw8Mgm9x8D6nn5e9geC1YL9gjEKz/00AroNdcOC4T
	buqdi9GgBDWmQjAhBrO8G5GKQbkr7FMK13cU6Q3janyM5wvCrTM4/3NVGOsato2dmGMZqu
	w8G9/Ux3x1SmjHYa7b+MC6zbXY4ez/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773776894; a=rsa-sha256;
	cv=none;
	b=s4MiLgkKYrYiNe7MZdJ6J+tzgDPkRmrmI5p4Frx+8MBdmoJkgHOjAhHYTONUBHkpmgYqBc
	B+Z7rcIq6o/Wjl13DsFsJ2BdshDHLG8ij3ZL/UgPTd+Ym/NkjCjsUS2x85T7RtCegeIzBJ
	mgI7DCyxHwGJM+FfSJGMA6bQcV695zw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OifmBLky;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C580442A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C0CC2BC9E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776893;
	bh=itX3MS/F8SC8j77BgmzEZaLi/d/RTiyp4OrJD1Jyz7Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OifmBLkysJSuGI9CRJ3gr93HxJVXQwOhRPBzXX/OgaC8DyydV3Q3hrGDZ9PUjK9xw
	 7dtz7qf7yI2WqIdoaO/qHJ6rq+1DiHwFxn2n+OhSj2xYGnANyIykDfYJ42e/Lq54Ju
	 rNTOcjZzkFth4DRYkirnSg9fpfLpJyzo/TbVJG/ZasMTxIZCtsp+azEK/3UBzxRm7K
	 r2IBdssAu6oJMSoSl0lCaHjOt/HQ6yoUviPHYJSGiJLFzAS7znNYbcOIr9JDB9BJ4J
	 cjD/KgHz/N6wIEG6LIXXlrcLoieH6I/Vn/unvRNO9SBoLq28UFYwJ4p9CivefyTHXu
	 0LzWuQ0+FP/Mg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6616cb8c80cso9449724a12.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:48:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXcQoICLa50vyPfKwQ10fUlbnX6UJrzdh6bEwDvsaGobIIcyphh6ymbyQzP32yMOGoR4CGhsKAYzQ==@kvack.org
X-Gm-Message-State: AOJu0YzSusv6gAfoa5u2sV4RGmy64c48ZK6/BP/Hj3HG5ZQz95ZWf3sf
	0EVEnnuMVSBy3+g9adjY3VJYDLaISUq/a0TXjyQO5mXtFN+H3k+1ABsGtqpCyLcP9YpTrb7E+OO
	yX4RveaZHcCjNgX2+YOsfqI+P+JoAIAg=
X-Received: by 2002:a17:906:d0c4:b0:b96:996c:8605 with SMTP id
 a640c23a62f3a-b97f4948171mr26656566b.23.1773776892162; Tue, 17 Mar 2026
 12:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com> <20260317124528.961ebeaac03f69e65cb767e8@linux-foundation.org>
In-Reply-To: <20260317124528.961ebeaac03f69e65cb767e8@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Mar 2026 12:48:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
X-Gm-Features: AaiRm52uY3wlwUHfHf5CqsVlt810mY3NYszYx0_ESdaaYoqQMr6v3_5zomkSOd8
Message-ID: <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 732E9C000B
X-Stat-Signature: a6xm7be54nu35qzd4ihogcmgx554893h
X-Rspam-User: 
X-HE-Tag: 1773776894-21749
X-HE-Meta: U2FsdGVkX1+ZYcI9uR4vnSv7D8+ePvweTDMHa4bmyUAQA5+cBRnv1Vrj2PLlquR+fdm6l+AGctwynpadWbjnwpLDbEN89QHDAzTv2B4Pjj/T+7B7oJu99VNrTS8bO9LuK1sYUpKHPESToKwET9YBGk6569ZGDb9nkyosUX+O9FyY1LBkIbYOB1a6h/Zi9iMu75WpyNogpvH+jqFfuReNVryjFhJFMlJ+N6YHTMEn/h3jWCym5XCoZmpectjUXNdSW9wFBv7r+nI7cAIlBcuKohJIX8ma/dju3LAZubsTMiY73UPWOj/qXWsQ1ZqiCKuNx9OAQqPwtBhjV6ImNSd+mooLGjTeC8m7XtYZxJNW/H6A4pwQCDyxP44ZqbFXvhfwUEDM1zl6ZQvIINeDPWoFbvPgcqX8CxgDI04I9WuoKFTH+5YyJax7KEwJNTdoBvQJqcoN85J/107SvEZM/vkKWmaGFyLXx3QpXh1x42q6yJ/bkcGNNYfdYXOueI5RVb6JdnAfjqtYYrcQrr/306PWDvBAaM9h+1ceAplwbmV7GtRsd1tdlGF4yUqcbMYrRE5gJOeWQ8Ec2EiISHe5QBR4+qDYoReYx2AiqyXNeWR7ZF01S134pIGjYutbxdTvorBtSebRaGjcwYKNtyCzWdnLFljNxep74RvYmRMfgX7Z0MB4BeSYFzTXz8FMkMeCpxMV4nHFv8JjQra67vsMevAVJOCXirWg6Og6CXiblhs76413mbR9ioa778cmHCVgGBtnW3GlRd/WKOZUFT4phy5BaLaeVgf834FpULTZsc1sj7Est6IazXwCeSb/NjB3ot9oVF6h3K5DTAAIQsysx5kiJxcZDIXDgWyL7x1Wy13v4fqwL1g6KjYBLqfVtyxDDkTpDqXNSdOc3YPoNFDETSwMEugr7E5w5rjiaDZ26bbZyYyAIb8RxtQq2Ys7YppYZdajh8s+mUE2IZ2K9Hd2CrD
 7/xSrxDA
 TNUpV4qS67Z6Xwhbk1BNEIWNeIskEWlFV/jI2U01TtrFVswXqtq2dmv6finduJlZbjk+Gsok5PGT+o2ZZW8wFrRO0IkkMA1gfe1REfCY0WG+rtU5S2+3JSMzC748r8RM9mGsylrzwXUb33DTi/pwOz1mvjkzN+KbGvzTQMn3xcxzACVfmcwpLsno+3Gtqxy7dkt8mGabp7cHQdjFHEw7VuFRmUzaaPjg0/vVfCrNRXD2eDeENsNMqqY5p6KyJTd9ZPwcmV3ODeL7t8LTbrERPsgDm1a5AjMJrGo7Aw6osg/A0Zw5RtFn84ySwk3e/E/Kkc7R40A0gb2zTc7GK8hoQ1YM/p5EKczsbvwt6rgxJZNi9XuH29N7wkD1NDME/OoWz+yAO9aD5pbUpM9L/s/XyWfoEAMCpDH9LMyEWsyktJZralwyrST+NGgze7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:45=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 16 Mar 2026 18:48:00 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > This patchset first removes redundant checks on the acomp_ctx and its
> > "req" member in zswap_cpu_comp_dead().
> >
> > Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> > last until the pool is destroyed. It then simplifies the per-CPU
> > acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> >
> > Code comments added after allocation and before checking to deallocate
> > the per-CPU acomp_ctx's members, based on expected crypto API return
> > values and zswap changes this patchset makes.
> >
> > Patch 2 is an independent submission of patch 23 from [1], to
> > facilitate merging.
>
> Thanks.
>
> What happened with "mm: zswap: Consistently use IS_ERR_OR_NULL() to
> check acomp_ctx resources"?  Still relevant?
>
> https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@gma=
il.com

We decided to drop it (and patch 1 here kinda sorta takes its place):
https://lore.kernel.org/all/CACpmpoeo0LhxkoA5Wx6q+9=3D2scn_az0u=3D3bar-JgBv=
TA-ZBkZg@mail.gmail.com/

