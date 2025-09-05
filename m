Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DEC1CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D816E8E0010; Fri,  5 Sep 2025 15:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AE98E000E; Fri,  5 Sep 2025 15:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A018E0010; Fri,  5 Sep 2025 15:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACB4A8E000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:44:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F71AB817E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:26 +0000 (UTC)
X-FDA: 83856223332.05.5402637
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55A6D16000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LY4JSzHx;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gihNiL/JMk6H0925BlY7NHCybaKcuYV/h29UWRuqZU=;
	b=5jre3dckQUmsK/XJQ4dkMDubiFtnGvzrrA4mKP8t2CBqsAPW/aDSQh7YLBgJe7ro6e0evY
	T0IRi4ur5MdvG9ZXi8Z5+o1q0/eFcoZk0VOdzI5Q/eNgzjciyz4zxjIOEvIrlKoVEjZbul
	XggIXBpXzr+Lorcw42AtmwlrYNJwdDQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LY4JSzHx;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101464; a=rsa-sha256;
	cv=none;
	b=7jW2ujf1c6KZmSfzqfOudY1pPV2dZBUliOgGdEt6FE7bRUpBSVY+QgCC8z7GPI8uXgHvpL
	rI9hB8LYp2kpg/YvdvHFn4Fzpr15DYpksqZgV2XLXQw/KzvXHZZvyY9xPcBfdVL755kuth
	VPIsyMkQ1Vxudqn6qMcLaDToSA4e+wg=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3dad6252eacso1119872f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757101463; x=1757706263; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6gihNiL/JMk6H0925BlY7NHCybaKcuYV/h29UWRuqZU=;
        b=LY4JSzHxgh/ZMuZDZIiAVgF73pK8XkFOGMJHqDT4Bw/Vy/K4OOv4sJVj7ZvGE4fn6r
         Ma/8BvJ2K1kGZ70mLQOkxFQS9jrFgGDHpepfEoHx4n8zgTzQsYuKDkiRD1HS5jUoSkkU
         GA7FIDxu63mr7vCdiF7KUd/fv6g4ZNbMed28Ph7L2A5PiLsWCnilEBjkT5AAbZHQU7TN
         9NtJrRpBXXLpg0q2pNYKBaRogp9vPOEDSM4Eb51GWJEHdwnvJM9c2mjWsav7lGUyqd2E
         zglJcwpBrC7/yfzo8RrQrmsNvlmsVc4fyloJpZBdNRzx35cR+g9l5CeH/DRrCiLJFXp9
         KNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757101463; x=1757706263;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gihNiL/JMk6H0925BlY7NHCybaKcuYV/h29UWRuqZU=;
        b=AjA+9xMGBxRD6A5oZ7K79Rwjga2LYan3XgL9G4ZSgoy1JcvksbH0h68UmUX54liCtE
         kg+xtY6mlfRXzLAm4jd/JrRKe9sLoDxyjUMcMLGgbUt5B1PvFkaMoHuDL94+5PTUuTKi
         4UxDGYpxNQ+Eaa7nWodZ5qJGDXOvWZ8hOgBBawPnHt2IAYKuKW7iUGAsmWkpDVtLJrgN
         UaWcJgntZCenmK8UnghLYNhKgObc0aneOmr0R5G7mNtYrBvW2U5UrzE2T64GI3ZY6s6s
         iLh7efheB7vILNTPFFJDH52CXQzu4z+hVG8uLCfRrn2Ea1r7lzlv+iQFR6DpOEgWQtad
         Ve7g==
X-Forwarded-Encrypted: i=1; AJvYcCWjVCf5W1nOIx+UTpZrSEfFwPowYG5mfsh2qmZU4rVCLG8Z0Cb3KIXYK/A76UW1trG2vq8/6U0m7g==@kvack.org
X-Gm-Message-State: AOJu0Yz0z0CLWNfPIzt0qNhejJ+peZ68jWPSXtIFeS6QHRCTVtbL1+Tr
	YDEcEP1cm5HoO+MEbNeKFCv7hsePSHbmxRaLjZv/mEghoQjp0PuhLokU
X-Gm-Gg: ASbGncvZCuM1dL0ts02Tdy2Xhcbuw2/Eix/4O/ngo5Xlxw2FN92SDIZpgWWXPAz/an+
	Bg+3lcKh1mben33i1G66yjVod3BzQgpZ9EeEZ7xlC1txKiUThMInQKL+dmeHRuovSneWbXEclBI
	EBfcLMzbyNgmuOx3u74+mQK6tJNi3LBeWPTSqJjAIhN2SH+j/m/5Arno99vfIAO1ZiMpdAJD8OP
	k2dDPNwHBOJ5iKT+HAUhZHLCuHf1Q+y4Cuk3/xjxzM4z5yFbrvG3Xpb7Ubvd6WMCWuyknYW6FQW
	hAUvxP3ldadt2q41wivnyqEvMwyMA8RiiXSBdKHzxh7KcBIqIfSVhRydUFel9K3gCz8RD6sfgON
	iksmvH2UHygzzQTUrLT9ee3Aj8+A01eZn3c3Ludd1fOpVg7/gj/8CC5Foy2eFfBrlr6aiQjj5t0
	l5Vz1AahEYX7QQAtrKqHSNWCkstIVf
X-Google-Smtp-Source: AGHT+IHOGLoAlL1EKX3BuosEZEEa4UCTSyf5rfL5O6Lh/HionQYcDs1GP2npYPB94Jdvfm24zXfnfQ==
X-Received: by 2002:a05:6000:25ca:b0:3cd:93c5:eabc with SMTP id ffacd0b85a97d-3d1dcb7627emr16306265f8f.18.1757101462595;
        Fri, 05 Sep 2025 12:44:22 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm427283745e9.14.2025.09.05.12.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:44:22 -0700 (PDT)
Message-ID: <5a3fd8fd-d215-464c-9e84-b8051c16f07f@gmail.com>
Date: Fri, 5 Sep 2025 20:44:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
To: Mark Brown <broonie@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com, Aishwarya.TCV@arm.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
 <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
 <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
 <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
In-Reply-To: <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55A6D16000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wfuy1tzgt7e8ct7587g3ony9ikyidq3h
X-HE-Tag: 1757101464-900310
X-HE-Meta: U2FsdGVkX194hcV1Zv51H81mEYvm8FvxAsWvU5a362UTOEv+auuGoyE5nKnfm14UH3Ffn2wLyEmd2ocHH8EL9tKWVJcIVIM19pmtOcXusBA6DZ4/uavm2g36UjixJP89yJGl/2FH7fgsptR8bxV6py8EHAEvKUbreuJbaDxUtHn09HQ2IKw8tRcsZTMM0TQGAsYe7+JqPLn78X0fOtSo1mG9ZQETidvo/tUELiO3qPcFYpWjnle/YOYbvIQMwAPsfg+kXamBKL78HAmEGLozfs326yoIHKajGFX9GQZZgECpBMwARVWzBTtpabPgsUe+AmvV4SE0h1XUaJxVZ0D06g4C0LavI+g+6CVg/bk3eMULTxj+lokz89wZE5rnb9XLjHEP6O7KOJ84/3ZNxVOtlR6y74grvjFFguLMok2e8chv6rL5BiGBcfJdfCOwJo7Q1v3ifJLQ2Xf42PyhT4oE0wqr/56tFyNHc/ODvq1FARwf1/bkGjZngEMRVcq6FNi6gCqTsYs30B8w2iXJuOZFvKNli9NCq4j9tfVoVKU7xoZqdofdeA3h865uo+LU99mTlRrr604V+MwTD5kROcKc/YYLUwNZp5jbG+vJwFRJ8oPXCD4uWFVrkm5ySOBgF/vN3D0LpwClssbsAulKRaQTTIuzS/CPJcP6uMLtnLKsv6+BGOENhVt79EDfcTx1QLZm13UAfdgSHapXPbzqMUg8WjWmxPI8mWJ/MiSTF6Kj4AUHHNDZ+1xombJSWk8NxTSo1WJPPxzJmQA8jmWZkHqO0mgdkWN5WTGQRVdhDfJn6XP2e9NreX2d1TbUcQmoijWF7zqQ0QmQ//YlXYFVJwrxvAX1KknKNBhELaXecNEa1gXboIg9V076tMBuuD+pC4H+R8iE3vyxgNvwhY7oxLmMTjVw2V97Gg2IeJ3JUWPyFr1FlT/ALZI/NNOjGGppSCBE3TWHIkvNl/zYln+uGfr
 rFaGc+Fj
 q/nqfR1Ny8+zgfBj3tjDnMYoO28zY9w+tLGLdU60fO3nh+A3dJ0KxtmXaHlOh1wKMpaGB1l2tZaXvZWOfHBeQQ588FnIesgovZFINmzwiJ/rk244FmvCkwqPIrSEEqj1QUjxY2izlXH8oQTyzlNDwYaIkT41TnUBmYq3ih4uW4dOttJ59BC6Oj2UzuoNHwVgZIoGiYM5oJP451sepdwZIIOiSu66oSJKt4hPnw8odNMy6aY9+FqnmRHftw3AW0A/25cGimcj/g5bXybCbEykMAQQjJ3A0qIhUUQGCw3sPO+5zXZIGZKQhxM8zHO/RMyGxLERO9A3iJ1Fgn5yw+c7yJCnfRXjbjS9RTfvPxC1yKobOuitjY1jhEEn0gbCXj4oLjdtFAX3Ir/TbryRyOMUAgA0TMfPN84QMryKdDVU7FH5tlwGJKKPUGosCB2GGkWCa7Ro9PeEbnkI0ZGPxJm4yc2NCCOFiCXgHajliWPJQlzxHZxXQVPOGQYGZ2sBqiCLGRrtrSw/7DaASErG/xorlFKMVsXdamc9lVCQV6xvQjioPzu2hGezCsDqkNTy+uxh9bQHAYDUvn2aAWGhTEHx3sqSdkiQNYVf14b2o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 20:40, Usama Arif wrote:
> 
> 
> On 05/09/2025 19:02, Mark Brown wrote:
>> On Fri, Sep 05, 2025 at 01:55:53PM -0400, Zi Yan wrote:
>>> On 5 Sep 2025, at 13:43, Mark Brown wrote:
>>
>>>> but the header there is getting ignored AFAICT.  Probably the problem is
>>>> fairly obvious and I'm just being slow - I'm not quite 100% at the
>>>> minute.
>>
>>> prctl_thp_disable.c uses “#include <sys/mman.h>” but asm-generic/mman-common.h
>>> is included in asm/mman.h. And sys/mman.h gets MADV_COLLAPSE from
>>> bits/mman-linux.h. Maybe that is why?
>>
>> Ah, of course - if glibc is reproducing the kernel definitions rather
>> than including the kernel headers to get them then that'd do it.
>> Probably the test needs to locally define the new MADV_COLLAPSE for
>> glibc compatibility, IME trying to directly include the kernel headers
>> when glibc doesn't normally use them tends to blow up on you sooner or
>> later.
>>
>> I knew it'd be something simple, thanks.
> 
> Hi Mark,
> 
> Thanks for raising this. I think doing 
> 
> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index 89ed0d7db1c16..0afcdbad94f3d 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
> +#include <linux/mman.h>
>  #include <sys/prctl.h>
>  #include <sys/wait.h>
> 
> 
> should fix this issue?
> 
> Thanks
> Usama


If that fixes it, please feel free to send a patch or let me know and I will send it.

Thanks!
Usama

