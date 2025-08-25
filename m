Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11488CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 08:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2328E0005; Mon, 25 Aug 2025 04:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9D98E0001; Mon, 25 Aug 2025 04:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF63C8E0005; Mon, 25 Aug 2025 04:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B473A8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 04:28:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516BD118428
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:28:38 +0000 (UTC)
X-FDA: 83814603516.30.D77491A
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4155114000E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:28:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TopzY0WU;
	spf=pass (imf09.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756110516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuTeQU4Njb/2ZMYYaooMFVFoD4AT11+hDbQbFo5ygGE=;
	b=Azj3uH1x4uT7Mu/CqVR5KXCBzvcoxMjsoIYpd1HvYdd1GN18MUWatG2T/Z5ebcYf2+usEi
	Szljmv5dSqiMALRTa5XxifbJCN7DBX13oCr7fUqovObXZEu3lyuKp2qr23xbA3kMzlwqO+
	1hsva36X9UPXi29nTmLaP4q1O6U9Syk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TopzY0WU;
	spf=pass (imf09.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756110516; a=rsa-sha256;
	cv=none;
	b=edK+zZuHnhD1zh1bVkGyXR1wyAEcbO1q2FjrS5Sy5fv8cJ4+TA0btTVZsCjCsOKIoVU54c
	7E0WljAppKyetB1VXhc90QzTMYpkuvhBds8fRX36Z6lr+ecKvQMAU+aC/eEarUY9qaH//q
	xHihjTG6G0c15uYFARwpOJCP6qTubyY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b09990aso1085605e9.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756110515; x=1756715315; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TuTeQU4Njb/2ZMYYaooMFVFoD4AT11+hDbQbFo5ygGE=;
        b=TopzY0WUBxq9tPyzUbE/lJKE5UpOi0OjrGkLUJeFG86iAaujlx1mRAsA90hy7olcmQ
         STin0DNVTn3tIzsc3QtofofDu3arEp1JCI1jgVM8PVAIVjXa1u2vjG+nRNolOEQKPLfr
         4/cdepu9AiJ5HS3cnzWEkneQYY6b0JlDLmy523P2djezEBMNHCqfboqWBolFN1xT1nvp
         tNB2Z2fcFe1q+94M5hZDXqwRv7HEiHZYMqpA9Ijm5erESzMYqzUE3fawDetVMVZwu2NZ
         xpSPmZ2V0iChakptfZZUQI+benMmUIoC/VkZoQcYTFQq2nUmFbCmi8Uqbny0T6cCWHFU
         3Zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756110515; x=1756715315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TuTeQU4Njb/2ZMYYaooMFVFoD4AT11+hDbQbFo5ygGE=;
        b=PFUq7+tSI9LcnHZFZJ7fYQvofZKuZqXdpF+DKnTVwIBvJsczqRzzHUjgQY1kyPdr76
         bHxSl8pHkh75C7SBYVJ1k6aKJLRvpKLjvxtoAJja5uMq2tNMJ8AOdrY/CtFahO3p6A8V
         ZtH/+F9gq47NSJagYUarhf6SD9p8F1HmQixeYD8BcVW3kXURIJqTBCGebcAZlPHKvONu
         RKGVm6lCerahRvhkaDOOvR9oIJiRQo0tziRo/fePnVC6KZoOR9ZBbo65o6FQmSGRb46t
         JaDTS1+RZeX3QkuEYH4yp7D2WVyF/cySbbqeWrjNqEoYUf2kZCysHorepo/VxFaGgx5j
         U7jA==
X-Forwarded-Encrypted: i=1; AJvYcCVIB0O75xRLDlCFjjs/M+3QMC3kFzuvJxzHIRG96MqWsGdUeGCZQIYv1m61ipv6RzsFtAWdCjX2rg==@kvack.org
X-Gm-Message-State: AOJu0YxnHA0ucC+CrBQpqLbUDhGUkHjARiy3RPDpl4JOGXWmzrtJAlCI
	5qA/tLbSWKYMI9f2iV5v5OMps3SgwZwNNE3/iS74mxEpCNrqS3ea6b4G
X-Gm-Gg: ASbGnctWDlNP/9WoHYxU5c/2p3LB/kmK3tFt8FOH53/uCAK8V6F9Vb29u4kTite9/7K
	pK84fciaOrd/1W40kPYy66Mg4gjSADi4PbY6in4oakizQLPptBAV8iche+kjuhtoY1cEggXaHSi
	J9BFFNh3Exr0Dc69jYshYWldSH8znwm6MDZQBn0y1HXwKoUrXQZLHSPuW/WOyOgusCt8ln3a+FD
	xlH4389j2CCx0x2Mi5nNBpgysUScAnHLBRk2CLJw3gXRraymOLOz+3z2XqGHluDd9XsAA6Zn0P1
	S62mZc4FrdIu1ddDEeFQdJiZwgEUsu3zsdG+/fw3LMIJaeDOeIyhTCjuUwX3fCtfzqBrrx/yrrl
	SjowX1B3kV8I9kobS4kB4+W4+xIeDCagYeYk45i2ASq3NiAuuU0oU
X-Google-Smtp-Source: AGHT+IHPqLQ+oRqyvjisbJ8+67UMxUp+cFZGaQxEbT3zSRUP9vA/CB8qpHqjka6+1r8W+L8S9uq/iw==
X-Received: by 2002:a05:600c:3223:b0:45b:6269:d24a with SMTP id 5b1f17b1804b1-45b6269d622mr3184445e9.5.1756110514399;
        Mon, 25 Aug 2025 01:28:34 -0700 (PDT)
Received: from [192.168.100.2] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57535439sm106215545e9.4.2025.08.25.01.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 01:28:34 -0700 (PDT)
Message-ID: <39e80575-f024-43e4-8760-0a535f84b4ca@gmail.com>
Date: Mon, 25 Aug 2025 12:28:29 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] exec: Fix incorrect type for ret
To: Xichao Zhao <zhao.xichao@vivo.com>, kees@kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org
Cc: jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250825073609.219855-1-zhao.xichao@vivo.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <20250825073609.219855-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4155114000E
X-Rspam-User: 
X-Stat-Signature: w53mp4rxbdxyex1sfartp9zqsd8ir77t
X-Rspamd-Server: rspam09
X-HE-Tag: 1756110516-370315
X-HE-Meta: U2FsdGVkX18CTV1SC/fC+Gp36h/x6FAfwDcsT/EhkFziS04foGLL0t4308oXhwA0y3wWWdH/Z7tLg0EmBQELNOsDazREe11+MbRiE6NlT9QUk2Ee2r5oVrNL0IJmhBq1hYK8jrGhOZOarFZas4hn0CVXGFSFtJy581NJdO9YDHQHFCN8Sq/cHh+a+6vbGJXUEfuS0QonGxca7lj+pRs/QqFlss30be7p/inJGtpmRRKUkYSu9mSoc29Li9huJhORHayDGpePLy1QrraIg3LkXDmuLqZpN6Qz6RoRkD+yAh70YbgIleDEKfSi2khJNQ1KyLLXW9OXSGCX1qJ+w2KQPiP1K4XuqYciT+FHI7qDE5fW5DI0ELpdyNG6UJVHLyx6mEj6h+U7HszY/OgY9cQ8aOjUPs3rOUdY9DJeDJqM8/WDc4oZ1jJzVDJGizlQOQursUK4+x/V/y5Odqcd75k9mUVfsJ8xSRSr5Tn6oVXyGmOrXLBR4FSJD8tTPouJlOn0QlYi2SLBWPWRvuaX+cUYx2aWnR0BjapTFAN0SQdAIPT3dU3exzolbSIQyw3G3chRWf5jhSvYYK7qPj7PEUxv5TBQ3nAn1iLQKTxR6FWPPO0IJAp/ne4PjsjkOeqJLyOCtWW/SAS0daTox3B27ZrmIv8MR7Bh9W+RKy32h9MYvA1sskmLqwoX70bCAMVvutjxLbVA8dCPB77xNvsgpujXR3wxa3GUUTWuPaZ1fyHMOHLOZe2d0CSlWqbx9sVjWIunXi5sx38Bj/WB8nA5QNB8qK+BslSjke1r3sB8QR6qXj6yIBtlKP98qlCatpcME9ycTQ2WkoOMbj/qxJU/5i6CqelhZaX/qEFkFFZlPOXE5WSSLbJLAJOCvbCEM7MSOqsMCQERvR4QQo+tq0nPmOntTteBq6lSG3Mi2yEpsPG4FcxLFZpVYfCviu4eiunYn5ErIS84ENHhjjMP/vvLcVT
 GvaCqKu7
 oaQCBbpV6ZMCIU2/d6PpxcDHSNV9sUxvA/2gN/r4cygmsOg1CNBHI9s8LT8a+f3ZhPlFJ0/XEpuPPsOSP/pIo5/wfm4hMQ3AZxtQ7FzYDBJw8GoaldW89V7LON5yTM4FHLWPwHno9nrO4kwseuo7BGrzgGNj33Itlgml4/D/+FoK8PwkeQXFVTFqKuBpNwjp3JQ1mmxwX7z4D2U+KT/Xy4IEgTM3UwEk1RJqWEIfKshc32klzSDqHOhah4wtYGLFTafvrPhaS8OROrlER/233vceOre894/cNGU6AO8WKPqX4pk1vbtes/c63AIiGJxu3C3ZmapI8iR10jbyYzUoVvnNHg9DzncaKRpJ3d5n3kbpvMAjuOHxtTsbjMu1u1rwsA9mSEJr4/ugNteXJ/xCdpipIkjDywftooHPWln1MrgCsqQ1O7nwp7CJjsA6wP1QXTlPLS4Hmf/DAeBXR1tpWzo2OF+nYVP4pK5kU2XeMx5+q1uj+0dMcdrSVOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LGTM

On 8/25/2025 11:36 AM, Xichao Zhao wrote:
> In the setup_arg_pages(), ret is declared as an unsigned long.
> The ret might take a negative value. Therefore, its type should
> be changed to int.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>   fs/exec.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 2a1e5e4042a1..5d236bb87df5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -599,7 +599,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
>   		    unsigned long stack_top,
>   		    int executable_stack)
>   {
> -	unsigned long ret;
> +	int ret;
>   	unsigned long stack_shift;
>   	struct mm_struct *mm = current->mm;
>   	struct vm_area_struct *vma = bprm->vma;


