Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E5E1CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC788E0013; Wed, 22 Oct 2025 11:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84C28E0003; Wed, 22 Oct 2025 11:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A998E0013; Wed, 22 Oct 2025 11:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9C998E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:28:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8640011AFD1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:28:08 +0000 (UTC)
X-FDA: 84026131056.11.8AC062D
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8CE4F100010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:28:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=euiIJvjH;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.182 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761146886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCyGNn9DqYHAJPTYEfOdDyskGHQO9IZaMQjWReSYYrU=;
	b=1Z984dzxRTW5x0bGm8LB2Quh1ubOkOsr+3tAJVWp/eUfta6ueUU4a7iZH+j+7o16wWESiG
	ynWNWP9cTQY5drE9GqZv5y6fkNbJc1t7Qtfwi4+XAWD9Rq4MOtEqVY4oSossJtbS3TqTYS
	EMCOT9PoPzeka+JGSRlN8qH04kbreJg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=euiIJvjH;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.182 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761146886; a=rsa-sha256;
	cv=none;
	b=7IXb0vXqhwtG19iUut6+z4vlvZXyvp+efGyEH+clKx8bF6PXJS1UpyXmSh2G0+MN71zSQx
	pPnEpI77g9nfjmM+SHkStVLEpL/3I+r6w4+48wihqCpZ7AKaI3WqmY3SLBqA+G5fc13B+a
	4Tw2mTq6VE9D1blnalNMSh9BU5R6lI0=
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-431d2ca8323so7336185ab.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761146885; x=1761751685; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCyGNn9DqYHAJPTYEfOdDyskGHQO9IZaMQjWReSYYrU=;
        b=euiIJvjHpcoipyI/cVQF5wbzNwi5ss5cmOv/WF7Qd0JCMSJuVUQTrfhIJt0LPABu+j
         m5ealz5shTJVn+UQbl2D99KcEcZlnVBxEv9pa694xAEQpw8YBvth3N6+shP8tR+ibsNt
         sYxg+6y9kmsjH2tDbjaD6EmeRLMlUPJtlq1Vw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761146885; x=1761751685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCyGNn9DqYHAJPTYEfOdDyskGHQO9IZaMQjWReSYYrU=;
        b=hGMXMMfmCvoOtNiaannESoElgQkBLA3Mr2ZNJd78Y9uhCBmiezWgOVtg5eJ1ytMNaA
         4Ve+LrKS+rrt1PWRtdgnYF4lX0pcAiGGgYXciOylDJgXhQI3BhVT+w0t0l78BJayMwJy
         9RbqCSXHEzot3oC+5z/9Be3jWBnIP9OONbHhjC3Ead6q3uIe4dYmFFBU0/cKjdcxEA0G
         xyk3w9wIQmGdbtY668NIZwUXcxFtNMg7kV9jmst/3IVFhSL/c6hcgGMsXdXwhLRyKEmi
         xx2sqkeWMiWBLL3LvIDNHb8LZXN8HcUvnrCcvaLp4/wRFQ/ywnWAU1/1613bC2hBu0kU
         J87w==
X-Forwarded-Encrypted: i=1; AJvYcCW5AsVMA4fLYOBwRc9l3fr+Idgoi7ByIFLrLDbUFtiUqeVuwEZp/n3+v0cARFlTnOgJspT4JQ/ICw==@kvack.org
X-Gm-Message-State: AOJu0YwndQ+Zc/BEjzEgXal8sVQyQ6Vym8becK2ZcydlrftplHclrc5D
	EzMoSCeEDh990yNempUsB0+N80kDODDyGmY53TdSD9KbEajuADE+CrvdGnLis/UFrS0=
X-Gm-Gg: ASbGncszOQBs/pSCfe8rdy6dFXdMVMpKpMnEhD5gDWJLaSEEDrrJooh7134UGpprqbV
	5U+nJRpGo78hjCw+TniUjp3dQg3fiMWGBVLVTDcQrmf04/yjEjCCtf35ZhH192l8RDMKAHOvmiS
	2ixY6dmjk4EcdaAfmhpVsDQWLQz2IiQXDSy5Fj0eq2XCKBXdZBuDfysh8ZhMw4vbqSITyXvcXXY
	N8RAht9iY2Oasza36mj+akKekPkjYjRqw54mpclETIblWVxp3YrV+W2An9/rn3L87JEzCimKXTz
	C6p12qUJkzBgs6vHV8XVd5VeW/qGXgketYGTD+c97hK78NUie1dLOODL/O6L0gxO6Vj8chK9Jh1
	z/LsBq8NYCQDsqJV3RAwYXXarB4wpZA0wOw6Zd+2zXNzv0+5X7tE9RgnBAHwNfh6QjbJ7GPYGLg
	X4fSaAQaNgMwQH93Rc0eEqLQ8=
X-Google-Smtp-Source: AGHT+IH0tUAY1DZnnn4LLpJ2tMQ7048bBL0pCZcMZSbVpsE+cqMSObTeG3mKxAlP47l/VeOFctL1aA==
X-Received: by 2002:a92:cd82:0:b0:426:39a:90f1 with SMTP id e9e14a558f8ab-430c527dc54mr290786465ab.18.1761146884652;
        Wed, 22 Oct 2025 08:28:04 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a961da08sm5303034173.16.2025.10.22.08.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:28:04 -0700 (PDT)
Message-ID: <d18f46d8-9f42-46a0-b5bb-4f1d16c868cb@linuxfoundation.org>
Date: Wed, 22 Oct 2025 09:28:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] selftests/cachestat: add tmpshmcstat file to
 .gitignore
To: Madhur Kumar <madhurkumar004@gmail.com>, nphamcs@gmail.com,
 hannes@cmpxchg.org, shuah@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251013095149.1386628-1-madhurkumar004@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251013095149.1386628-1-madhurkumar004@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CE4F100010
X-Stat-Signature: 4hnxs5ukunjhyqt3yfa1pwu795zgk478
X-Rspam-User: 
X-HE-Tag: 1761146886-618147
X-HE-Meta: U2FsdGVkX18E+YV/9/lBkB2w8xkJaX3zzPvfoOTfkwXq1etagi12OCGVUw8ECez9dV63bf5Fq9Qynf/uTZg3kKag1p+D5uVYOyiKt4kZIyHaGafUEXG8JRMbv2wwQj7f5oHqmFujH1yPnZn02gfGy5sqdZEngap+GokT/CVq3BLHgB7ArsVbxKTaze79PFTIAIgbboummsFFS+yRw44xVRag+qt+6EdukSmWMl96ldqzUboD9CmXZecqi93T9KnsmHBLEOfb7+j0wKW9yyhoKhl7y8S4kO5VevQvyZ6GKYBZGy2nRxYgQN5w4c8dYsaOMM2yXK7iDFiWIrvTo5eSFxxQ0lI4T7R5kL9YVFeiLoH6H3BL0Fzhy+H+sKrcQGAiNmU3woMesYtYLpndirEwT/Ka3MoqQ32I1ygQMPEtxzqYmfdxDvmn222Iq/U6jk/H1b79QzM2f1NMVWQto2ekkIKCFeZKH15FjPfAaZqPhZaeaHwxUl/8YbzprxWwGptUzR5HFqr64bJ6PbmpUiYErBHCpFQlBlfwKbwC4OphBgZNFYMctUl56867PXXcv66kDSuS7sH0W3AjkYwNLZGTCgAO6T37dMo8G0kRSfeKIe6y3S1oOVnowGtku2ToH4oqxXIVFjL8h9LohTlYBv4k4a1VU/qBWj/Z1aaZCxjMRAmeCXdZqREEAGNVkEh/WP0Xqei/BRITbIyIZqyN4/hfUy5mACVkoArLkkxD0zIVpyXppXuIyICpGS3yxjm73Xqwy645BXtANbToMbmaHS6Xdyu+j/+3SY70E4JSXc6qtwls5fWgu//rPykfAs7hbMNxg0DbAJiNE2kQdRhzj6nxw4aKN9xLDqyBzC9tV/DJYNhRPEvRA2LQ3mRc5cWGunKVbzFCfTpsC41SGAONyIWoSbo2D/kXMPO2MgRMxzMDX2S2pyRS67nAniXnkQ+TqPIf/BN7xS2AOyljTxpks90
 ZgM6Htnz
 fOo+Rr+7J+e6mYakDYlkA/mPHR5s3m7i8bXufw4UvW6LEA/TTmH7/GpUtxNwWNVAJLgFvJgfHP1AZRZ/51VtTszACpkdpwlJ0k8IxrIIBKe0k8xn78CVRvYYgyA3fl9NgDaNQXYdEeCRNqgg1I9338LVSHocV+FkXs0A4Vd3OyydafeDl6DFIaZ7yGYjNOsT1zimt1wzGbUoOkRjteFI1FWcuttEA2eWU4Tr+s+hjH/QIOvfxpxjEiLgpU03ZPzKJmqMrOyLG13++NrKFxWXBNLIOX8N411gdh2Qi3qwzM0jgTQMkJ4JRU5+wOESd9si1HFsuFqAziy614BLPmeDurbd90LbYHimxqLDHVHImewdTKBw5iUXhIyS7Hj+banHekQuiLTH9zi8jmQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 03:51, Madhur Kumar wrote:
> Add the tmpshmcstat file to .gitignore to avoid
> accidentally staging the build artifact
> 
> Signed-off-by: Madhur Kumar <madhurkumar004@gmail.com>
> ---
>   tools/testing/selftests/cachestat/.gitignore | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/cachestat/.gitignore b/tools/testing/selftests/cachestat/.gitignore
> index d6c30b43a4bb..abbb13b6e96b 100644
> --- a/tools/testing/selftests/cachestat/.gitignore
> +++ b/tools/testing/selftests/cachestat/.gitignore
> @@ -1,2 +1,3 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   test_cachestat
> +tmpshmcstat

Applied to linux-ksefltest fixes branch for next rc.

thanks,
-- Shuah

