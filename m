Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44CACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397378E0007; Mon, 22 Sep 2025 06:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F708E0001; Mon, 22 Sep 2025 06:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284948E0007; Mon, 22 Sep 2025 06:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12B768E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:01:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B997C1605A1
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:01:58 +0000 (UTC)
X-FDA: 83916445116.21.C993521
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8F1B40012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:01:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OSedMNEF;
	spf=pass (imf04.hostedemail.com: domain of tudor.ambarus@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=tudor.ambarus@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758535316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y811XUkUAcjUYq9kF2IbC9o9QTenp6PpvmUvV5JyxCo=;
	b=rkGZmdZXbICQF1nr3tYgu2+WIoqpBaJdsKobi7l0jUwMRtEp4AZOHgtvU24rzNBINO3pyr
	bAnIZT9rd2TXPjSbz4ipQYKwVqrcDhfJQ++4wECvv6E6p7DJ+P3Qo0ldvZBprzwivxedqb
	xKI93ao7Dl7DH8WDkItR18oJ7TlwVGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758535316; a=rsa-sha256;
	cv=none;
	b=FrjbFh1C9oIdSHPYm5mPWLARKWX9ydN7OZ1v0TObfI2bpLgc4eHGY2Mc3XbJyKwjFV6eYd
	anJ09XeI7EOwwgsxseHHkRB7/tucN1FbAqs0MizjZUArn2haQ/Mt+mMPHOo6EH53vAtys0
	tk3OgUzS6E1cXZs+IB8zH0PBLaaWMPM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OSedMNEF;
	spf=pass (imf04.hostedemail.com: domain of tudor.ambarus@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=tudor.ambarus@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ee155e0c08so2570958f8f.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758535315; x=1759140115; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y811XUkUAcjUYq9kF2IbC9o9QTenp6PpvmUvV5JyxCo=;
        b=OSedMNEFGUVKf6cgZG3oaWWy4alEkquzMGCvJ3YwzlF5Mc86OjjLLqfkAanBNA2312
         WQ78mp+5VGoKW0sWt30ebH5bXFgGs1Lm9Sza5eWWznPYyJH4RkrUCJex7pASBk+/Deyo
         N0rRpSHgRmUDCfj5PgZwg4F3JLG61Vz4LQuxShdmkInueOpz0r8CmmhFt0dEXBuRdaL5
         B9luvU0BpVm3gvTdBGi0iHEbHQKa3nUy7zhLBHeBYapX6w1d/TGfm+C832gOU2ItomcN
         zpKlv5/0R8NRPuSSJCe8/Askq0L9vqoQqVkv8i/5x3npVkZnC+vhSgRBI3HilIltonTt
         xYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535315; x=1759140115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y811XUkUAcjUYq9kF2IbC9o9QTenp6PpvmUvV5JyxCo=;
        b=TRvLHrXvYFezK30Ms4Wh92sgcDloKUfyutxv70RoXabYhOi+bVroPvxGV7566QbN6z
         bZ7QTds4ohS0b7nYvZcMfhZFpgWoDWs1OM8esG1k4x7Ab5iK2Gz5tpnOdAey+zefjaFE
         J8AW725BVfUnIf8n6xVGvJsoGYgtpKAEV+eJ1Ojd7Bz68+7upn1kl2asR9VAhwQJ8/qe
         W2T5aoDv/4YzyY6SDBLCd4H77mU9jAqwPEgYLoaCkEINW0t0Mhr78w14h59AifpFosYJ
         /tA/9+eBs3Vjn6+XreCIml7ZzvtHYkMf9e+EYAzpwTWKVEb+nYDJQbi+pkkKdv8EuMLI
         C4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjBfuN9M7GlQTxl3mkSuhqGwsDqat56E6rD27fLfpHR3duRnge2ksq9wR4GQIFyTftj3y0nvk7ag==@kvack.org
X-Gm-Message-State: AOJu0Yz2hV8NWuwTOxOyPki3o+AwhfP36MKFNuxq+ELLvtAljzOGVjxu
	h6tpW1X/0EcHZuratpXG1gqMXis0D4mX6zFkf7vuOELcZHP/KuPis8r23B/dZcLr6dg=
X-Gm-Gg: ASbGncvY6kQeTXHVniUINDrNr+gd1FtaV6WirT4n0aItHJCavzAsYeMJ8hacTrnlCme
	SnTmQSe1D/hIFe4Avq6VfEJj3E2EYwl00B8dkb3c1mQv5UndXxnt5p8gO1pmOEbfD/K0tJJGBr9
	3+0s77OcPdF7m8R+2Op2qLFDaS0ZOuqofxrdxJ4PZRfvTnW9BSIYXMMA4FmWchYMW2B4TCnEKhI
	OMjV0GqCGubnR2lKNGBc6nPE7BMz1y3VBJcxo/HKemjgUv3vF1y4WABpQFPDmDwLe8i79C3KJdP
	ajM5361urqBTyrpnc6FioWjoo18V2+d9Htm0uQvnU7gZ8V27All0ZWxelWoNkVbK5jA5CzYol43
	cDX5bjPQ0IYWKZKy2AFt/LjesPAlFmYXR
X-Google-Smtp-Source: AGHT+IHyiSZQlLreoJ3W3Ph8Q291wVJ5XeiMCjmBz4nM2qvfV1a5GmC8lVHC1BmJs2M+jyBWopho2A==
X-Received: by 2002:a05:6000:144f:b0:3ea:e0fd:290a with SMTP id ffacd0b85a97d-3ee7ca198bcmr9624896f8f.12.1758535315118;
        Mon, 22 Sep 2025 03:01:55 -0700 (PDT)
Received: from [10.11.12.107] ([79.118.185.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee1095489asm18419549f8f.24.2025.09.22.03.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 03:01:54 -0700 (PDT)
Message-ID: <c0a0daf4-e9e3-4152-8e5e-c7b52a30dae9@linaro.org>
Date: Mon, 22 Sep 2025 11:01:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 15/16] kmemdump: Add Kinfo backend driver
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, david@redhat.com, mhocko@suse.com
Cc: mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
 linux-hardening@vger.kernel.org, jonechou@google.com, rostedt@goodmis.org,
 linux-doc@vger.kernel.org, devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-16-eugen.hristev@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20250912150855.2901211-16-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8F1B40012
X-Stat-Signature: k841g7fngpaszmu578j7dfq38mrja83q
X-Rspam-User: 
X-HE-Tag: 1758535316-827175
X-HE-Meta: U2FsdGVkX1/OsHdxvnrqOtz6rL0PeQXX41PZj2FrwfeVzNrydSmDbzfoxMXQzCRznys0PtTyvrT9J49BwaneVWpPlIob1FXZjMbeXyYe9gR7IXCBt2VivOiPonHt5uz69Yb8pcucVaFb0U9IiixGaQiLac2NpgTWJ1zlYz6hYHj0fzpHeWCbAo5UEnj2xD2UScsKoVH6zHW9+eEAMUvmt9SjZ0SPTpq0lyd6DhpwzwDaGHVnuCW+v0Pmj1pXIRBQicEm6BHwN/sYuma/2H2xmNBF+SvhZkR0ZoSYBtZVL9Oh5i3BWPus9mgzlLRcjkBuMjHSYqWngEPE70OMvuY/sy4L9PSbYiaN+D+iYlO1gqNFZpPCwADuvho4ws/4Ya55ixwEitKqsUhhHbCHcMOHCZW0CqJWQqknDYLUfOMXVkUzmg4KR076OMdJ6n1ZUIguV5Q3OzZHPjx06yCeDUZ3mduiQUqbts+hALjstmD25fh+J8CsmbAOWys9EUHkwtZ6/Y71QPox4VrH4OVdhrDPIJPJSbZiQYjCIvbN5AmQYyv40fQhsY/4klKV0PtLRLTPCwTsR7oQzEdeqsTw5lsgm/bOgxLTo9ujrWGyVLt5W7qs3f4mQncjFqePQA6R2URdi3UmRTMOxpqzdTLBU+NGmotP7gQtD74bbm4pGI5nin2MUn75qpVQRQUhgmMRJCPohRPN5IhR0xIg689Ziyzj/rekCubmprbqo6M0BKfxiXYyoHjMUhvNNLMLcOCypbRk2uF0EewwILyc3uHGPJgh4DI4Zq4xmtoPb+AG6Obcz5o5yOMjRTkAj9QFHZJQZt2S5+T0oFtz4qPGfxXwXXiqwTsr7GdT9Gi7TztmgPkzFZb4bYedgGuPE+CMxcj/s/bqfSGYZfXN6hNxt55/oebx/mbzHygkV+8KvcyVU4Kr/B1d293cwGVFElB07IZHHr9HYaYJJbakrqhE8Tv5ei1
 T2EhwXdj
 t7HSjonH+UzvUPKtnNA+v6n2syBuQtWXdIW7ezOZpse4pg92D0H7cvnE1+IyyY0TTVs2CHSicQq4Chan6z/Bp//XiT8P+uMFHQdbnDZmnczzYoDQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/12/25 4:08 PM, Eugen Hristev wrote:
> Add Kinfo backend driver.
> This backend driver will select only regions of interest for the firmware,
> and it copy those into a shared memory area that is supplied via OF.
> The firmware is only interested in addresses for some symbols.
> The list format is kinfo-compatible, with devices like Google Pixel phone.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  MAINTAINERS               |   5 +
>  mm/kmemdump/Kconfig.debug |  13 ++
>  mm/kmemdump/Makefile      |   1 +
>  mm/kmemdump/kinfo.c       | 293 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 312 insertions(+)
>  create mode 100644 mm/kmemdump/kinfo.c

I tested the series on pixel 6 and I could see the backtraces correctly
decoded by the bootloader:

Tested-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Thanks!

