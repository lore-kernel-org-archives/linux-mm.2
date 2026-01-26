Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AF5C88E40
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 01:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3056B0005; Sun, 25 Jan 2026 20:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956A56B0088; Sun, 25 Jan 2026 20:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838916B0089; Sun, 25 Jan 2026 20:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 704396B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 20:52:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 093D7140620
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:52:18 +0000 (UTC)
X-FDA: 84372439956.26.633F54D
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F9D710000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:52:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IXE6+RkP;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769392336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEuwFDX8sEOyQ+L13hC6tPbYMALYNZgElkJ1Rv7U2Yo=;
	b=M3+ntMWeZyhWLgkp2ej3ogb1pUxLRrIZX0LvgMOK8M1V0EG0F8/VAxd0NDMN97HtEmImwV
	HBHZntX7FmacQ6NbRwVlhpQL6yTXs0Uuql8rf23Coy03aWRcTJo+E4etSYDeVwcEqD5cMd
	wJFZ7242MyUGdPCUWilLL/Z/lB6g8GY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IXE6+RkP;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769392336; a=rsa-sha256;
	cv=pass;
	b=DUIhK2spvb6rlUq4/6QmrIk+BYSCVlheHLS0QVzctWXMguAclrWJJJJRnV9uvXHVlvG8vB
	siahJEocWf/GKZMcqFaC+SW19LZGBErhXgWcF6MbKunEy75G9A/MNPxes7ldpJaWI2nXKB
	6ksDtGybgJYbgSBPOGMoK3dWE+H67fU=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-888bd3bd639so57114456d6.1
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:52:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769392335; cv=none;
        d=google.com; s=arc-20240605;
        b=lqNZGHE/+LVrlYsyuzBE2NaM01lItTL48jiFs2Q3I9CNlWHBzUqver8/MtlSAoqilW
         z5S2yYLlhinCx/9Zj1X2Y/r5F3zuI+R7MsSYR64ClUO8GSBqbLOptpW61u7nAWnx4vvg
         msNUUw0Q5pp+vch9gNuec8/nPTjT3PUPqiLKQT8mx3lSoHiHYN1NdMUgrLzbzTkC0h9N
         NYdhty8uf+CsjhXAV93dN3g8KlEJkvNvm3hwf7fWgc7NkBBWiX66oaHMa230kDi2PKNe
         5KQjPIFk4YTH2acxGohNXl8K2GriavZknNwbXqoh9aY6doUn//h1+R/2MJYxSZwxNA49
         uyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YEuwFDX8sEOyQ+L13hC6tPbYMALYNZgElkJ1Rv7U2Yo=;
        fh=nrT59npFV3RN7Bd/bRiRmF3HMNbUVgnSbX5vcwymPfY=;
        b=HyP2Wxfp2TAH8sinm705Tx4VU9P+O77nEJ3xd+GMQ8kE+2fXRXQAJu6tmM4lg3RE/h
         oiKMImmOeGgD3LoGF4b/EYKw+VZWmoM4XtfTuoQrZal71LfQlVeF/QUeJmTlMGFzEX4+
         5Cz/WneJxHaFue9+XBYaUFSqyfsi+j5t5UMvkq1qlrSf9jW4X1l2NLfe/zea+bIg1sY2
         iUI29h+81ayav70GVqBvsOrCZfeHpiPqTX4963GXPDfUrnJW9FdF6/cvfb4D+fNcjtMr
         nrKejfLTy6n3/QRPK2xLKqxkejh6w5nnbfTyWS4pkRz8+G0yWk1cPpzT1p2h/Q1M+WaS
         J/4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769392335; x=1769997135; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEuwFDX8sEOyQ+L13hC6tPbYMALYNZgElkJ1Rv7U2Yo=;
        b=IXE6+RkPsUWbRQK1cSp86wiqTHhknZVK+heLezuzYqah0y9LRQykKNgaHelEyW95sa
         a8uWiIrUNtg2910rdTbZ5uGYL57UKXrI8zF18XcP57Ku4UXv0pMqfU/l229YVmLzYrGo
         Ay62CZ0P/7c3Mi/xQjdIAFTfNCVQ8QXWc/HDrVARrZk/oZK32eqhVodUpDz7wuX66Muu
         R/lgdLvWlMAaRIT+z/KOdg1MeoMt7uODlP9KGWmR2M/IaChu7dZ/R7Q9C/vKD1C/cU3Z
         7cS8AtyPF7a1qZUNbofQuBOJKm8vdQNDUD5l7RCoJo94F4FKgB/ivtmeFMktFNDe5TZx
         +fHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769392335; x=1769997135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YEuwFDX8sEOyQ+L13hC6tPbYMALYNZgElkJ1Rv7U2Yo=;
        b=CF0bECs3/5usL7IKAqj0a55IgWF9qZ1SuJDrcxDEVqSmIY1kNGKk9uYd0vKgVx59wA
         cUtslTDwYtHGs9sX252JeHirliXwLI0ckkWRKSKvP7EkWgusfs9hirhNeLOy/MwsFfYu
         I2FEJjoE5AXjm2RCRw6HR/049Ccia/BoN/K/MX2MyDfTZHuf59JcifZ3ha7cJWFdA+i9
         lrd+4QGS0nIkymYM0xh++m8emuav0XY5aQjD5UR8vKmf1jjDSF7dFCU7LHZ+YKcmCNFg
         LbcLpfGF+3X97nuGfPOjlruDP023I6fFxsWeShjceDUtsnCs4ga1t4w+usVs37SFpgBa
         /RlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW2e6L9WIWET2U5bJhMqUokWspjFBPrfx4y3dKfpFRT5rznBzD9gBiVWye6phKJ3H4vvMbyXVpMw==@kvack.org
X-Gm-Message-State: AOJu0Yxs65mUB7NAuqM11KM+lEeYNfIvmGvSS2Q+z0bDe9yHSH8x/uTd
	9tkDFTaU/Sf7RZOVJfEugcR4JLZwsGVLXz8P3uoLHxCyKL2gWk8AkYTLfrvWSh2QvCK8LGAM+CB
	xGS96gI0DHQe75wB2RO6YyvwuqFBs7p0=
X-Gm-Gg: AZuq6aJVXztr2w4YP5o7uqPO9HJpoafp30I0IQU296ZhFaplwt6c6Nek32KgJGvwE5k
	KpvKQCKflAw58otFllVnrbojgs7AVBZ2L0rtkVuPdHc8d5dxZ+ckVgXPkjEuH2gG+Rxh+miAr4M
	ju1DAZHMbgTzUZE9I67/5GLVJpjclHVG3EG68aDCz1QBulNVmlN8L/n3/j0JhvmFbPOAop4N1BD
	2+2er65j8OWUyssyHJrgp9OMS4UQyF+X2HDTNeDzBHJmAO92/y0b/wpV+qEkhw/waG69o/rwQ==
X-Received: by 2002:ad4:4ee8:0:b0:88a:2ed6:252 with SMTP id
 6a1803df08f44-894b02fa802mr41091466d6.5.1769392334857; Sun, 25 Jan 2026
 17:52:14 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-4-vernon2gm@gmail.com>
In-Reply-To: <20260123082232.16413-4-vernon2gm@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 26 Jan 2026 09:52:04 +0800
X-Gm-Features: AZwV_Qh5bgP0Jx6crHpdoAw6kuaMsRIT_RsAgKYV6FioMbn9angxUXx75lO9Wzs
Message-ID: <CAGsJ_4xMvjS3Ya+pdCX7giQGtvvNyPYd5pexeaT8vZZEwuKiqQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 3/5] mm: add folio_test_lazyfree helper
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F9D710000B
X-Stat-Signature: s8w49p4wg8pbcfbd96zbm8ueextfffdd
X-Rspam-User: 
X-HE-Tag: 1769392335-297594
X-HE-Meta: U2FsdGVkX19ueHCMvvPypZ7wlCDUiWYi9wmilNpOmeqIvS7+VVXMQNNzwn/xKLqdszQTjYRM0Wirgy8tJ4mBoM+B2OtgpUXyKUK1p1FKbxk4sPAN6b0qpElxNEjhUtlq4A4Rb8PZURXTnvxkTipf4XRVlyFo62L+/fQo3e5eGNGhKSiwu7Wtztj8qTblrJGpQav51gd+eYCsOEPO9QadmxsK39J6AvhM9lX7ZKbIjIO0dFddfM83kv+/gZqzYIKYeRPC3uAOb6BDFUUoXHhaCPF8yZ9hFyvYP7/dUkoD0gl1OyasCUtrjAGZPgH0xfss2oI0n7sIKHoUQqDq0LeIohFEox0jPgcPc4AtwvidlWzlDJPwLMbCKFvbL9aNX/b06GwUOLbyN8Ez5CJ/XpJqQq3YOcen390IHKngaxv2GxtCCsHYToNGhoXJ3kjqp+HEbu63trU/wd9InmfZMgnWTYdK7wLU9Ax6wsw7XR5CV3fFu7zP5ceqwspsUt9DrAJcHXBQWwDiVglIHkCm4R4H4aMqZBslVv0VJykh4P6f3XBl1cAt05azv5J8jGwY86Oo5O+2A5c41+FtxBFa+m5gLEI8QILinLYQjM9IQ+ozlkZ0rksdGYFMp2hjoxjK4Zybd/qUeeZGvNQOBt3gqoadQVCF0m3GR+J0Zs4RVge+knWtNEpsGELZ7h8x7wWrXHwugRGYYdxc6BjhtUA6WWjQJTnze4hjAJJAXX9lGioqG7QRwBsSFY9QMX3hfKv+SqrMGEqXdaHAsi9pASom3O4aN7UVTU4QwHRqZArDbV3IFlQFFTBxA3/zbS94GoGieruyZIWgCbeUciziJjKXIAqaOavDeSy+tDbDJAW0bfMlXB+j9MAImyj5J7BOcSWjKEdZgP9QOHVzUlzlNZBECLBiJh0P42MWTDRsPxMM97bNSZQB1kY9G17Ey49fgeJnDLcYZnL9JThfSgUlHhT3rG5
 BD7Bn3Sj
 hP8Se7gyH58TRUBp7CZKuG9PqopbYGL5VvvAmqpHWeZ9l4YOERGccgHsiRKeSQZhlJglRQT6cje7SmBIX3tCdUAsmX2t6x3cDwBn4ZjWJ+Hyzj+r6gTYQxq2RuMin1F3/PDEIPcNYgmbch8Dc7t4w3V+GYywxNeWJiZomv5ikIsftNd6E+KPQBZkvht/Z7xrKN+EU3IctCe9GSiUxSN5JC1tbDfu89wwlw0vyZ6GbprVtOlgmt5GbZMtu4bqaMTmXHqeCA+dDCpFuBD3cYMoxOScmo0HoVsr/4LkhkHamGoi5yoo9U12Yn1OrYdELcY15VSAFG5frfJQzkJ4LCNyrgzTjHqoWM9ISRHLhmKYnAlBddyxy4Nu4SlRovf+WUsuotof8H6IBnrcZhqoPM0ChE3C/4LYZutalaOHIRPVzCnNak1iZzSSKaNpRVCJOm2fWGM4jHTS49p0Txhn2VO5otpsmsD0+hKc+s3z7glJ8ngfnfqCiatXsPCauCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 4:23=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Add folio_test_lazyfree() function to identify lazy-free folios to improv=
e
> code readability.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

