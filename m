Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD550D116F3
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 18:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D376B000A; Sun, 30 Nov 2025 13:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE52A6B000D; Sun, 30 Nov 2025 13:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21E16B000E; Sun, 30 Nov 2025 13:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 915AB6B000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 13:14:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2651C160DC8
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:14:25 +0000 (UTC)
X-FDA: 84168073290.16.27AF193
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id CDF1B18000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:14:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=htDtYcD5;
	spf=pass (imf24.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764526462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBLsT1Kt5fCGBYy/tImoC4leU/BBbgTB0sTZXBRw36o=;
	b=X/KL8hlY+7ZDeib/+cANuX6iUoHyOJJztsQieFJGl6IbZqdWXMSvzIrqtz4Yc+AerD+ajG
	KkVAmlkoIW4em0ROqTSqRxh1RBv1F2ajxRRxXD3Q9EB+oM4ZBto1kLv2bqkuNTHch3G9R4
	krPuoh/BrTiosaRHWyNHsZk6rtaHuh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764526462; a=rsa-sha256;
	cv=none;
	b=WYOOZXeg65eEj3R1Lza9eFOVKZYfPltNS3OxTR4GIZgZWExsQXJewbw1swtfICGuPpREjH
	Bhls01ErCyFBFj0Dmi7OkkfkkSVC+jTZmzBe+Yq40VD+aAjprPT7jVi4iomK8LOeQop/Sr
	RUo6SyC4ywqXHiexwQ4dnBDf0oX2714=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=htDtYcD5;
	spf=pass (imf24.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so6455397a12.1
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 10:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764526461; x=1765131261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBLsT1Kt5fCGBYy/tImoC4leU/BBbgTB0sTZXBRw36o=;
        b=htDtYcD5wU4RILCN5OccuifSRt0rEp4UZGKxitS9PQiX7N5J4RHW3LqF8RGKXLdTIA
         sG2HjFOq5oIR4isBryNKwnyO4oy3iUWBqm9wWOByO7JlIB1JVkEajBvrZb3qEKGwP9u2
         g5dU7ziF3olnEgXRz68k0GamihVawZnW9rOFzhVJvBktuRbK9nUnKYC/dyO5B8ZqJyvA
         QhghJGL3T7fcXZecLUgFJcfRF7M0iFtRQLl8CS+3h/zac+4Ehc4ll0PVxb4yUMLgPNEn
         /E+32pdhYGoXnUW00D2NHeWW0pZADUhNyHwJAvgLHvk2HmggdQdjeiiBqfU0l/OQbDIH
         rjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764526461; x=1765131261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KBLsT1Kt5fCGBYy/tImoC4leU/BBbgTB0sTZXBRw36o=;
        b=aguyTZl3dU60FFFcgnsU+E+2QD3RG1aRmPjexFtl0EIrRL9gGmretYAjJSuHdylf0E
         YwV6mcgkcrE8YM5UrkNVYHT17rXnNG4+uclODLazvQ3w8LR9jT4X88LHTkHefN7rv4Zi
         k9s+DJBHljyJbAAaiAPV7JjWRRXlOTC1H/T6DvA3CgSvtx7GJuz0debXAwZn09WgQNW4
         5D5I1FuMTvVba7rlXs1kXxyopx1vklLGdss8E1WLql4Am10il15kEoPsdv0Xa3qCnRGk
         IWL0FOGpXFDtWMP2rHkza9W7zL+3or440uG423OARi6QuE67PofKtpFIqkpUWrH3HY2t
         8SyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBPffi6nvzHrmW5DXbA6YA/cg/bGUXod0H0mLQ0CEGaPifWGspmfqVQPoIdy8cHyGZr5hyT7ZavA==@kvack.org
X-Gm-Message-State: AOJu0YwLqpzGh3csqFIDsIn692qnNsOz//zd/+8rqaCNagirOtCetz+j
	9k4vlEC4zl4NPhQba2pYyXruL+SBIOmEv2gUUM6+MKyglaB737Nf8lWqPC5F5i7tqvJmsyAT5hA
	fzD0V0R4i3d3ORlP6KgNLLOxrCFyQ+3Q=
X-Gm-Gg: ASbGnctID7/lB9xMheVzDGDXjAwWCjM4g5O1EbdN3VUu6nSiIul4ihWKtanyI8E7Io3
	qZBZaYD5z1CFJQAZJ7ZnSf2IBSy3yqjr+kJzlnvR0cD5oJh1JOG4KYT/4KHJwBMQKjRaGOKtx+V
	4+nbRzJT96gPkVaY6lHjqyFAOk9i9cnoihPHWWS97tWhFJzbCfAVLniw5EZEQZvHaItB/y559Jz
	Hk2dmttBnYBUz/3BHci4YtTa+tlVD9NxLiCL3tuPLwI6rIhE+NGhVoclxkGtRYDuH0QA0Ie
X-Google-Smtp-Source: AGHT+IGupBFdrEOmRl5k7yY5aSkJW5q5+XQv+nRU93u5Qo5WO8nScYPZTMUsiFSkhWy9i9ITX10ojEFa3wagCBqPerA=
X-Received: by 2002:a05:6402:358c:b0:640:be87:a862 with SMTP id
 4fb4d7f45d1cf-645eb2b54b5mr19121191a12.24.1764526460968; Sun, 30 Nov 2025
 10:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV> <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV> <20251130030146.GN3538@ZenIV>
 <20251130113213.40c8e7a0@pumpkin> <20251130164348.GV3538@ZenIV>
In-Reply-To: <20251130164348.GV3538@ZenIV>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 30 Nov 2025 19:14:09 +0100
X-Gm-Features: AWmQ_bm-wMIuBmzcPhNWr-LzkAv5-980q0q5uk1rnCb2E9BDvqCfeZa_S_apEGA
Message-ID: <CA+=Fv5QNL6q5vioEd8D9UqN10yM=EP1sMtYKYda5PoRqXngaQQ@mail.gmail.com>
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: david laight <david.laight@runbox.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-alpha@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CDF1B18000C
X-Stat-Signature: yaa9q7htqnqurrstzjg11stnma3oxgak
X-HE-Tag: 1764526462-33053
X-HE-Meta: U2FsdGVkX1/wHez+WCAFqJA8P0DKaPUD/NeaEoDhrRlH5SUaOhIEIgfmrLYG7Ejvl6INQMhUsbsHDOQ/0Xskx2jdRQOYQ861FlQRELcK3qiK4CSLuQrxppDUzBxcNrRsOzTw958cePkpKMcUnOdNjgRsCjVv6P1CeuHfSZhdZ+dtc/8ksl3jIHAplZP347PXVr5gFxGzC/6g/msV0eXUo0fPfrUk5Bf9fzRUBDh8mj6rlwebhaopXY+jVhxTBIe+hi087ZSKD4sXdFC31YSbPTDXboKwga3m6DmG1Oqs5kUNzesU9G+hMrnrNrBKgnmWsioNNagRvq5Dh6zNh3wqQ5iXvLxL/pj+/15xEcOVzuBsxC/TnwH+IrdNiHYTMdFZPtpu5SxWEu+YHxRaZw60vUUcnLp11DD5tAGEdJM5L64kvXD6e7uW/jXvJf+YY9RIOcrsEs2/CsrKfMcc7R70Erplo47fx2XvcLdIQahdDAKopxOmn5A6MobiwdnyVCdYU3tswj/vH/X4N42a2TWnIs834uaSdiJEPlYDoqkX6/BLVLPikWMiR0SNFnFBVBNGJ5+wQ+TNNyPp281yP+gyzcxx7P36w41XTWYxQXuELn9pzAy9L1Rtg5RGBjnlyOCC+9rMFcM3yDAdM7rv110h37/BkqZXaQJdTKFS3o3E0eqZz/FRT9qwq0slEdi+CyMTg8jScV+cBKLCwXCjGOE/MafTQa34C7EmOt2TPE9Dt5DY4/Jpy7AIqRkSKusbiL1F0wsbv3ZrdwzZQZASyrItUOAlZbGUlFGFxsBl7WV2AALE2YNWJRCepir2qDnjqmdXDZLghlMZrYXif947QjWVP+6PWDnpJ4AswUCmfhXhfmJaVH0s3QhDYcVsyNR2MKePehNUHMmfxmPHPa++fvxxA7ToSExqkT8Hp6o2301cNVant0FoTfU/QKPu3l7GG52U7VZnWWIt4K8x0whYKxX
 N/7K4fAS
 8XtiUflld7LQoxFRCZyhb1bVuKqMl+HTYWWoabfy+vVD5zj8UtprlV18yF/KChtw4MOAGq49RIqV5lvO/jFAUu0liwocgYTBc2FkxMWrfJjOt3beE4H967V/X9Q9D3kNAsplaa48BqnavHLqbn9V6TcxnauPdYV6OKc0yF6ZSesulzt8ns/OU+Vj8NCi0yuV3kLPvBJiWAaduN0bUuRkHkOtRskB5Be7C3Js0JF7daENm8sm0xJDHEh3JkyJYeVWZ1AP9RetkiJQaqKOYtzoD318nv8JQMU+XN0cMlGhD0WqABxkYiuZM6nEo7wSAbv+S4DyutCAaQwE9KEqS8YsP3fNrCP5aixmAHRPMyidbjd/Y3fmyf8BIsXhcosaW5OdXsvJgEf78e1syE0YyPRZI4llXE+A0XEckB4xSCcMw9bROEgh3+lVfKmESQcDjgxQMBuoUonLKXONsVBI2Q+7Mlw/vPrnu4+elzgbW5X9o54oltD/EYUzf7jVG+EODZkJ7dMGjsTrkbDJJQVOytlDUHpbmjm9f1GTjML0s7qs1xtP0w0xc3C1yC6m/28KmefGssUc59ZGGwpH2ens=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 5:43=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Sun, Nov 30, 2025 at 11:32:13AM +0000, david laight wrote:
>
> > How difficult would it be to allocate the pte for the next 8GB on deman=
d
> > inside vmalloc(), and then propagate it to the per-task page tables.
> > That is a path than can sleep, so being slow if it needs to synchronise
> > with other cpu shouldn't matter - especially since it won't happen ofte=
n.
> >
> > That should be moderately generic code and would let the vmalloc limit
> > be 'soft'; perhaps based on physical memory size, and even be raisable
> > from a sysctl.
>
> Considerable headache and pretty pointless, at that.  Note that >8G vmall=
oc
> space on alpha had been racy all along (and known to be that); it was
> basically "could we squeeze more out of khttpd" kind of fun.
>
> Do we have realistic vmalloc-crazy loads with high fragmentation of vmall=
oc
> space and total footprint worth bothering with that?

Hi everyone,

In my opinion, for Alpha I=E2=80=99d prefer the static preallocation model,=
 as
it fixes the LARGE_VMALLOC race cleanly and keeps the fault path
straightforward. I don=E2=80=99t see many realistic Alpha workloads that wo=
uld
benefit from a more complex or dynamic vmalloc setup, and compile-time
adjustment seems sufficient. Al=E2=80=99s version solves the issues without
adding new moving parts, which feels like the right tradeoff. Removing
code that has never worked properly should not cause any harm.

FWIW, I applied Al's patch and I'm running it now on my XP1000.
Seems to work as-is.

Regards

Magnus

