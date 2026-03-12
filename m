Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E81105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654426B00A0; Thu, 12 Mar 2026 08:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601746B00A2; Thu, 12 Mar 2026 08:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501166B00A3; Thu, 12 Mar 2026 08:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC786B00A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:53:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E75A4139AFF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:53:47 +0000 (UTC)
X-FDA: 84537402894.21.B68607C
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02C45C0015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:53:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=i33AeX3r;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773320026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ky7U0hmCeNi6OyUrf2MxogfDAlaxZWXxIQIvc2Y9k8Y=;
	b=JwlslnaqouAdBG/Mu91QquUdIn4SxZXZc8XpgT7VLPrbJiJu7M2oProAAgraharMNzUhQz
	iscnmAgtJIIE5JYRfh3J1gfagRMkkr/blBsHzgIsVA/6VlRtsQAt004gkwWBUYYZ3rrZSH
	+Sx/7Ksgs5J+vY/D7uZBSThSSQzKqDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773320026; a=rsa-sha256;
	cv=none;
	b=AQB26S4Wh1axAdzbtDplh0JrAJH7w3nD7OcAZtJakyI/SGU1qns4Kwyu0vfNuRaS4fHA23
	NLgqeJXoJQIuRTstnKeo7MDGwrw68dwUg+bycGCy3gYQ4vMKvHtq3U+JmbpLNph+7hme5E
	usQo7Txazdl5Iju8tTPFqBNddtDlH4Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=i33AeX3r;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-41576c5c01cso639090fac.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1773320025; x=1773924825; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ky7U0hmCeNi6OyUrf2MxogfDAlaxZWXxIQIvc2Y9k8Y=;
        b=i33AeX3rv4qbRnyYROfGYELIRm+um26EGnZCp4I9zdx93rLx1TaDZkLhW4TsyxMZrB
         3IvtNI2ukkXwUTya1m4cFfmi+o1vEM++3Y750A0prvVkvDzFezmMV099NaEaYDXxYZWJ
         t+LTtcPS+CjfXEOxIBKwbEA2AkrUqDy/U6dVnezFPj23kBnEJujeEQEwuRN21B8huzU1
         KTxuFMcwXL31hx/vwDVCyBbhrC3vaOuJw3su7dVX/NIx/9MyT+j9YKe76Cday5h4XpJY
         zBYaRmZxC1Fi/iGXdKI7aQf0ZNHodwzUubrT5kXi/PLh1McmSbSZNY+dzknb1hZKc4v0
         hmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773320025; x=1773924825;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ky7U0hmCeNi6OyUrf2MxogfDAlaxZWXxIQIvc2Y9k8Y=;
        b=GRLllgg3kDT+UvP3YhszHCQFrfBBqCq+cwhnfSs06W0AE3M/gaAnaxzpY6QBqMPsWt
         MRF/e/XlZb7I7iFFT8CmoRyxDycsgob456Kvic6sRh0w8j6mDozF79Lxo+Xe9PZF8zga
         ViAtB/lWcHuv3UzBse7a1z2UYBSxhTDFOj6wEQugkdVLIu5iR5wuPUV0i4Jrlf/BDshz
         Ph7WKWPKynAfh5+GOfi3g5Agib6QIratdOo99fyU/zEcWpGpfwj4nU9J/mfxoSbeDhOR
         RoUO8ZmmnA/Q1WSvhumSJTErnFIg5SWYQSHop17moD3HvOtgtR6yLtnyTOzax3h6x+Vw
         7xbQ==
X-Gm-Message-State: AOJu0YwHNljl9G4Z2YK3fVbc/tRhzeU3m4C9YsDsmFQcQrHF+89I3Mam
	2lUw6Wi+Ibjk7wuTUnkUU51qw9lgYfw3NBfVZkM+KkyTy4CaY5TCGfpfSmmT5mz7L24=
X-Gm-Gg: ATEYQzyocX3pWL+Iapco4zkehVxgUbNMIYjUYDkhNzHpOs5shVszBofR6IZSs/WQf+m
	eS3h/bBBjoe/S7ehkTcJxn7ATKN7i1L61aFB8Tr6EOu2HjbycDZBcYPXpyOrprLLNykJdHMsI2P
	7ZjWYARSrpLfvMHazqZcIdb7PLeAlaORvSH9PGXdw0Pi0iGsZJBDzv7w2haS+PxyPloIfcw3bxH
	tMi+OBSX52CwN7uMNVCEpKAuTWbFJDvRYgeg1a94PEvf3o33MB+ksBjMrQ4NYRnnMpsHBujN5H1
	1pG248ve5wbF1YJPPkql6V2eL9RiklsO0dkaxoN/uMbRMIvTUvjbzIqcBOZGadwZzo1u2nEUDdK
	4ucsPlWRCjFuInCylKsawfYVbCWHPHonbIowq1VyY4v6HgvCLUmGZh1y5dPJkQ7o5qhHPmYuOji
	AyyUx5xqSqd44Zx1r9WckkPMu95dmkPZw+2XgWmH0=
X-Received: by 2002:a05:6870:649f:b0:409:74c7:1cbb with SMTP id 586e51a60fabf-4177c6f1d08mr3392540fac.7.1773320024820;
        Thu, 12 Mar 2026 05:53:44 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.103.0])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41791432d87sm3765785fac.1.2026.03.12.05.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 05:53:44 -0700 (PDT)
Message-ID: <f7054184-dca2-4c7c-9e2e-4a5e3e1c81da@sifive.com>
Date: Thu, 12 Mar 2026 07:53:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/15] mm/kasan: add document into
 kernel-parameters.txt
To: Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org, andreyknvl@gmail.com, ryabinin.a.a@gmail.com,
 glider@google.com, dvyukov@google.com, linux-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, chris@zankel.net,
 jcmvbkbc@gmail.com, linux-s390@vger.kernel.org, hca@linux.ibm.com
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-15-bhe@redhat.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20260225081412.76502-15-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02C45C0015
X-Stat-Signature: wsm66gow87tjrp5gx11uiwifki8j5uyj
X-Rspam-User: 
X-HE-Tag: 1773320025-944322
X-HE-Meta: U2FsdGVkX1/FkoH8PbaP2EAn5IcmagKdoCrhJzhVfggivaM2+LtR31p5emDGDJKwre1wYlkPnbUFIpREmNrK56TdJcq3O63GUtP/RZutDqx84ZnYw2SbuddMbIYBomzP2gQmE0pmbJuhip3ysiTF3tVTWJJsb6K71gSyK1q0b1sZa0jlJjCOA94xn3vvJuRrHXXkh56vmw0Kra760LuafVGbL0OKtEV2X+MJS+LB6l2I0sN3rUVs2ys/JB9krj55Y/4MBDBlPNXmep6yiCOLBSO7PesXNWqOfJpOove/Y/rgNKwe43cYLTskMQCO2anUIVkr2SQWmKTDNPqkNtCrQBfBuPe3hLLwlIZmpxxOnWbY6jY85PKwORm9/l8MJ6ZhaY1tmB4AFKvkNP9MeCQry8hg7aUlFe0hRMi0hevWBDJVaNFDgAJ/kERY5sBlG2i8932s46k6TUFg0ZbkH1X1giBuPMmrSSqMF0y99lrenVMhOcc7D0s/hF0Txi9+KqjRipV3i0S0ie7u+eIMA4ubq50SiMLu/GfRT/p+Yg+puhDmrqUrMQYztScMAYuMGq9XJG5IrCAaeB4vTSBrJQex9u1LUdwfOmjnW2jWWcFwQyiKGKg5ZYVdJroJWqRsDBC/2i/PtNxe2N1KKJNrbhc4OYPEypOdk/BaMPXfQEEsNXCoQxwy6Wzqg7rco0x1mSfZyMygNtAVGNOPxYqpcfPfR9fG3rhttBAHLhniBl7ENWGRhccjgmBYjbHRlyq1ejALOqzZwg8V2o3z1ecI1AZw+LT8AJw3CCKigz/W8WapOHtiTaupiaqaupq8XQUYZpJMgS6uRtPWz4nz+h9gsR1nUJOpUwoJWjWHgUtf/gygBdiepxG/ep9zIuJ+KZ9+zXV/gZbDfYvn8W8ZQv8sowx8lCHiQAcK7v0u7Y5zbLFJGBl27554LmPzkGzn3RNxpwLtRK/J8V1NCvu2vnrrQ3x
 WIpZv31o
 pOdL2ot+jLGTDk7mkQzbxnzNhkhXrd0AdnYoCh6dzqur92l88lM23OGpBoQLVEcMPqvUifG9LJrHKdgFCyc2UnPT08HRJ8Bl51ZrOTEHHl145GMKengBgAe+PomWxqyY590LvxQ8rhD0JJgL/cxEMQIeV4oBjA6/fi68vAWnu27KAauK1Wd5f7qUflS1SC2ijdp2x4uDgF7r43MCuH1WQWn+RTI8ipHpnmi84Jfi2wMcCEx7q3xN2MC0EarYa81q4cHdh3klAvZ21a0azhWVVeHd/YKacOcPiQXdCWntr56hutXv0iHmMtt2thdgJM+/JDHGUBhJMTYyUWGlKuUjPDUATsxOFC+9UcwqrMQp02RkvMKenMEDVyJ2xCMCB2rVnedrxCWYGnwrzzQZEWLO9iDdlU51NtY4ulU9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

On 2026-02-25 2:14 AM, Baoquan He wrote:
> And also remove the relevant description in dev-tools/kasan.rst
> which is hw_tags specificially.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
>  Documentation/dev-tools/kasan.rst               | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index cb850e5290c2..e0115fad9e60 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2899,6 +2899,10 @@ Kernel parameters
>  	js=		[HW,JOY] Analog joystick
>  			See Documentation/input/joydev/joystick.rst.
>  
> +	kasan=		[KNL] controls whether KASAN is enabled.
> +			Format: off | on
> +			default: on
> +
>  	kasan_multi_shot
>  			[KNL] Enforce KASAN (Kernel Address Sanitizer) to print
>  			report on every invalid memory access. Without this
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> index a034700da7c4..eaae83fcb5e4 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -129,8 +129,6 @@ Hardware Tag-Based KASAN mode is intended for use in production as a security
>  mitigation. Therefore, it supports additional boot parameters that allow
>  disabling KASAN altogether or controlling its features:

The sentence above is now incorrect as well. I would recommend documenting the
parameter earlier in the "Boot parameters" section instead of removing it from
this document entirely.

Regards,
Samuel

>  
> -- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
> -
>  - ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
>    is configured in synchronous, asynchronous or asymmetric mode of
>    execution (default: ``sync``).


