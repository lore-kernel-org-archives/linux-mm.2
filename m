Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFE9D6D237
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931C86B009E; Thu, 18 Dec 2025 10:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF236B009F; Thu, 18 Dec 2025 10:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B45E6B00A0; Thu, 18 Dec 2025 10:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 687186B009E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:39:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBF631A0266
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:39:09 +0000 (UTC)
X-FDA: 84233000418.22.0807631
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88968180013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:39:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SbO4U1RA;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766072347; a=rsa-sha256;
	cv=none;
	b=X6ZOoRdX7nnD0T+mtZ6Rz7ICpNH8TgldPuWb8bpEHX46h/KCfFULip8281Q4bUkSRAQ9LC
	nviwvQtyg0DTlRfGlYn3M0i5l+dxHZdybUK65mKfAtqUTPdwbvKOerEOcjgrKnt/m40MSs
	rTmcZfYCqGFcspYFIo4zE8+9IcymvCA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SbO4U1RA;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766072347;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3+iFcm1O5KtApMe2VjVRzuyLblT2dx6soo5ROTKP70=;
	b=JmZ7eEWh2bpDnqt/tnpDa5uFyVExUI3Vr6dNocNh01bKxQPrqTpN88e1vG6Cd/JzO1T3Ru
	b/4hS3Nq6PTg0wuvBLTb324YEiBY/Nv0dKVhDVu+CEa3sCW9oi56iRrPRC0QxGaFB/3dIE
	LYXlzy3g5fYN4KODXNNvU6xEaKWZ/v8=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09757004cso8946875ad.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766072346; x=1766677146; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=O3+iFcm1O5KtApMe2VjVRzuyLblT2dx6soo5ROTKP70=;
        b=SbO4U1RAgp7W6f6QtdsplqjFOkOWxYiPMtqzLdvi5cysQJQNL4cJ+Jo6C9XIMQNK3L
         KSC7XIK0cRGDUbQPKlddIRhSRsNXcBdJJy/TgInJUGxd1oFu11QXdu+kHtE1kt3T2R6r
         kwB9w2SIHZRiuFNIFsEB3XAW6urlsfZCG29X8oMLzD0DltvI5MfEG/nEl0H5HX99/9vq
         sH5DB16Z+XNol7vvsgt0blbMWTD3WGP8Pp4NEK44ckKi8JQvZ5ysWHBjCWZgafOOfLRy
         I+2L0iJ3oOLxGs4QIxv1/0GepIZNeEgywbLNAz3sJX4XWQ8/EPnSoiQb//vLwyznFTDb
         wrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766072346; x=1766677146;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O3+iFcm1O5KtApMe2VjVRzuyLblT2dx6soo5ROTKP70=;
        b=lVLCZzAUOh2BuBZTIhmcy3BR7lOt0MP8x2x+vkdsADhKtX7SdVpAlUlwslrvfHaXLP
         hyInVWQDr8ViU8pZ3j4z+fAKHRE+f61Y2cf2GPq9v3T87+QMz+yGSdQlshk8Rer/fTQk
         T8ni//1goKuXiYYzMtNLKgNXrlWqRppH0/9LQ2zfqLWMvISxKIP0q3pf7e8zOthrA34+
         nbsy5+7BJCpqbiR4b3MCIYY+jM+Eo11mT3utWh+Rw+ffV9eDuCdQvTBvurBoifApVTMQ
         MY+AaiOw1JhGN9q2SA0s/GULoDoG0ZunDaanie/zarwn+6eOIHSh6+3CtBXvwnEHaFL3
         cIgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyoAO0/pwwbhkMZPky8VTd9AsER9/RG8qy+UtAERhbeV2nWBjlqfC7KrNDGTXu50aCbGrPKyYSTQ==@kvack.org
X-Gm-Message-State: AOJu0YwWhd8CrhtZjK5CByVJMedKJEpeHTWKA56V0l8cuoYTil/1xBGi
	L2cnhI+YyNLK7pnIRvoBDb88EaxjgAJVBdDGssAjjLR3DdSwa9teJgEm
X-Gm-Gg: AY/fxX62ojnTLHrso1tbuIH5/Ihne1KSAFyyjge57FGpD4QGPdWwvXVJRsLocGF6olH
	EzGcegUMsJmdvafVx7/Z+hWH8GeqgyFKsKLJITxvW8FWV7bVCuR3VAlPn+OSFo/kddxAQC3weMp
	CQMwtJPJB7mV06/pP3ZYSvHWbV0iyxkfmnBJCrvVKpMYfR7zAvdfeCmtEpPOwWkKEML3Pl6zhJ0
	h+E6yIhl/uRI/1Uhv6/caTbUJBZJltaUZRQ3DobCXvnRHbmkObrFTHqtk3kpsAnyJyahXaICPrm
	f12vSa9LGzWtnN/n+qLR31WRGo8HiG9T/gTnIOv3LLAKIbUDU3bpu46zdTTSD5nZldENXCtTiWz
	WdrJ3Gq4o/2A5tue63ApHFCtaI+g/MEuwS2n0gMcJ5raZbh3+LE8flwMiy3IBT/G9suIZQ8Xv08
	NvJ6HXWDXTWVHxMVFTqIqbRDvdjdbm2usuAS/b/er2BLzL4oHjgJnjdYPTuvBw
X-Google-Smtp-Source: AGHT+IGmxtmhpTIw96vEcqdJYRmgmL+V4YpucvYno3XXiqSb5eQwr35wT1A6FVud8nIqqh+FgSelIA==
X-Received: by 2002:a17:902:cf03:b0:2a0:bb05:df4f with SMTP id d9443c01a7336-2a0bb05e314mr155335085ad.44.1766072346150;
        Thu, 18 Dec 2025 07:39:06 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1612735sm29562065ad.58.2025.12.18.07.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 07:39:05 -0800 (PST)
Message-ID: <51271dc7-080e-4af6-ba00-9d5b2cd0871f@roeck-us.net>
Date: Thu, 18 Dec 2025 07:39:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for
 !CONFIG_MMU
To: Daniel Palmer <daniel@0x0f.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
References: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
 <CAFr9PXnK+WCOGYs_e5HiCiwxN1SdjGhmR3DOi8w0BYRqooQONA@mail.gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <CAFr9PXnK+WCOGYs_e5HiCiwxN1SdjGhmR3DOi8w0BYRqooQONA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88968180013
X-Rspamd-Server: rspam03
X-Stat-Signature: 3h7d3xesmgwdy7dattcxe7qdbzp4hhud
X-Rspam-User: 
X-HE-Tag: 1766072347-470177
X-HE-Meta: U2FsdGVkX182iAJ6DfMtMbTitDBCG17d/F6pjDMTvA3b2YqLI/SBCem61cyGIvFpcQj44+tCBxVcX0WHcQ5rO1PQjLRFSCAo/wd2vX1bVpnbwwUd7X0RctHhC1hO6CwVkVM3KKwEwveaMiBaJsFjGqgOtga/79G4zn48R0OK6jJaBBwdC4H+Bqt1MjolpW/MvBFpLc8qrz6BXt8hmvxh4Wp27YczbkinmmsVQbiUKkbl05+CENUNbdjf0VLWU/FzBRU0phpSFiUs4DuCZweshyvX6T67pOWT+FOPjE20REh9v90gsNVJKVE3/GtiNq7RYUHzZAZTpquBZm9Q9ysnWjQW8Q9B8gCRLzA+9Juk9mu3JlHs2M4ZQlMMGv7MpgKkVrgyltDCEeil73bKox/t9J0Udhsx2yp8jNP7kbGZ1CfZxcu4Hzc65IvPTnVradMhLtsi7UTSACRaIGLzG8sxzWPMHKK4dNBrmICs2BqXw82kM8RELHOQE1D5JdLdqjkdMcJ1xDhE1sjAGe5o6xiiFIB3xTkMpmraTQPAjabp7Jpwjwzz6h1lJrm3Op0Nu9nEfQvVUPHNsnx172CBT44AAbj5SREo9EPjTn5Rx5xlP9J8tOyWIT1MKrmUftM7X7MON7LWqarZwuT8qqAMNyL4k+vrSkaPXCBRNN1sDnuVrQm32kI544vO0nFO3ffzxgorm0Cm2y3k0ImzT25ACldx3Mq1AHUgAT4qBvWO83dHl08xRhv6dE8XuBQ/6d3WpHeFyyXgs9BpEqaGxDptY5qnPeQ23hW6LvqdfzHfPsK49VYv8RSW1TubDvP/zcHIdMNLG117fd7qMPmUsqcpd4FrTChsHWH58fsgtq0mgW+Z9PBvmbjHRm6XJTBEAzmDE7U84Q5yMbyO5B2SUZ6FrXRotc7918abUAfbtcLZctEvQA4pPJmKRfVkd7ixi1zB3VVYwMhbp1+WzrktSdfrvTy
 ukGs1At8
 oLMRdZsmWax2va//UBt+QIWT6nzNl2pxIbRNee8EwmIEpiN/y0xeSRFmvp/VJ54r7tqHaamWR/VJnhd75pfEe3WicuAaH/yrC6RWgZrVARiKcbbCuuSIF4bUYiWSljHtxwC246CVZACWzWJte92YMlw5efYuAqjTpqaTrxa7Jii56u78aB4HmRHXpvxEqXQYmANCowWFdIZZznhABuj/aa94A//8jAO/+yBfqdULVJrsdgWP+K1NLC8WbxHxXaoNwO1aTDSllZ9G4iH1C0zw6ROsQxjefRz9FnNqOGV8IoWjdppKycJ4Vq3GLju51OoeIN5Es6UxKdvng9gobkBmVJIXFtaUwxstLyyc8rn92Mi2wnG3YB4HoStOOYVraa+mirqYIb/k/BrARDjsrXPKZkHiRFlbPkFzNNrUV+VQ6FBfcPFi2M5RUNYPh9JqdM6v9btIqWVS68wxgHO5Sy74zqMSlq9ZNCkGs1HYZZPTgch6JlwCbs899LXzWydItc3jJ5+iLjYPCCj/IweolvP2PHgx34cvzu+uyAaYiY5xg1lGVwYkwaLNPfUnzy1uN2QUZ2g6D/axvqSupCFZIb8ruPWmZ7bDUdHxQuH0t3KXMFDf6FjyOQBSQdy6ESd6fyoLDMdV3tZfCPonaKYTAZ6x94Tg7OnYnJdd9NbI1v+eeitO2/wiefrJVZeby/tw8AMjBNDY1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 04:30, Daniel Palmer wrote:
> Hi Joshua,
> 
> On Thu, 18 Dec 2025 at 17:32, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
>>
>> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
>> moved the error handling (0-handling) of zone_batchsize from its
>> callers to inside the function. However, the commit left out the error
>> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
>>
>> For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
>> the previous deadlock-free behavior.
> 
> Tested this on my 68000 setup, filled the memory to cause an OOM and I
> got OOM instead of deadlock as expected.
> 
> Tested-by: Daniel Palmer <daniel@thingy.jp>
> 
> FWIW There was a BoF about NOMMU at LPC last week and I did mention to
> the people presenting that seem to be using NOMMU in real world
> applications that NOMMU was broken in mainline. I hoped they would
> have chimed in on this..
> 

Unrelated to this problem, but I gave up testing NOMMU for arm and xtensa
because it was too difficult to maintain the toolchains for it.

Guenter


