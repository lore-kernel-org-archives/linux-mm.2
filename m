Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D381D2CDE7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 23:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1797D6B0008; Thu,  4 Dec 2025 18:20:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB0C6B0062; Thu,  4 Dec 2025 18:20:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BE06B00B1; Thu,  4 Dec 2025 18:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD1B56B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:20:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6284716020D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:20:20 +0000 (UTC)
X-FDA: 84183359400.27.1DA2032
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 47D7D180003
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:20:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="d/SkqT6/";
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.160.46 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764890418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ilabqU0ZPIRb1Uuq8o42HfQ+CvcrcgaYSOj/pymfPA=;
	b=TgjwbV5JjfU8OWQuHVrR/R4clY2/qo78o3fGlsBGCoK6gKznHFThfiQ840zp4pGd9qyapk
	YZ39JH7Jb2eLKb4/zCAUtbiKGCFXF8B/SOiEG+tULlz15V7hA70HeZ1rgu8hPC7iNgJhkO
	qmPzl2Ptlfm2iv5H7LwZ6nlms9a1L54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764890418; a=rsa-sha256;
	cv=none;
	b=5lrgXRtKXVnNgMMt878hIVkDaI1nBg+9xRrS1IfQATQkWqeuCm3yalZj8empAK83pgtR2X
	dSj/KSTN49tV8S6SIKbJW6Mpr5uu1Jn1tZezmNSQA0BwmRHRlb7klLbk25Z0S8DpEfc8WW
	/o18+zI5ISXlFXnlV9gSPdkjNevvdUQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="d/SkqT6/";
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.160.46 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3e80c483a13so1169362fac.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 15:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764890417; x=1765495217; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ilabqU0ZPIRb1Uuq8o42HfQ+CvcrcgaYSOj/pymfPA=;
        b=d/SkqT6/QiotfBuYKze8odDJFN6LE8pp3YByFA068V9HOWAB2jkD1QRSqQX/QjoIzf
         mKLJMOQW9ZctGbpQtPUQ7+b3RxJK5o6msdoJCHsG3J4maXZaRBZMmjfyS6BVCNAcYwgW
         uG9y0S3tdzTZUQTazJbqy0F3wvNzUUiDOCqxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764890417; x=1765495217;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ilabqU0ZPIRb1Uuq8o42HfQ+CvcrcgaYSOj/pymfPA=;
        b=AlZqnYXieL7657vUyhIBZEsOzeSZJGWhEGiTB8qzWp3mltX9SX6yaa32utquoy6ZJu
         FE6EQ8bZn6vZ2/ddxVjHgbkQDvGrj31N1rin5vDe1pyoCcvGatask+xNV/1r2FXaX0l2
         stxTpipImGRoR9XLH+0xojF9dmAaZmuTq8JhWaLgDGOIbOpo9gcc96tNZMQllSAVIckV
         IWxzTRcRtInj8XV50DdZNYsTIMXjYVyHnPKMWHtktcPMPjfcnwhZBbfyphFUIbcYLeiS
         TGkjZDauNTdZodwp/XNyJHSQS0rdIzqd5Xg0LeCpdgOw6A2POnbhYPucvlMuhV3SdeuQ
         n6fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIAFsosMD/oYhNNegmjBM/xEB73XBYbgca18kdRiihI6F8Mv4+uQVEAAss+YhKtUxSzGOvgJ6Z9w==@kvack.org
X-Gm-Message-State: AOJu0YxcvzBO9ze+vCMQKN230ffrWMia0sNuN5BMHjo6CtqBeQ/lHNUS
	1tiGO4gtMzsYv0DZ57mdJaHZnBA16l7p8GYS0bXIiLmn6g98pUECmr5OTSBShV1st5E=
X-Gm-Gg: ASbGncv/2OLg4nWRwcmojDk++22KShAiC1p7x5IIzHvQTLkPrlJdzh8yqx1Wf1L8+MH
	ngH18BVUiDryuCHTKy/vntjYhkwCeeKgCtu0sXbpVUCbnDgkHm1W36sBAX2F8hAwnYEc6REznBl
	E49E2ZQDWyeJQbkmXxAfE/RvLJMrsz8ujQzqPI8QYUNcYFX2zd/DQ6MBJ3z3U4IBzi3HLWOmr5u
	irmU/4Sl98RNdyfW9Kxums+711af7qjFn2If6E6xAuobadW0bAsAX/hINBmuLshS2e/5HdFiSJt
	OETGQR436uA1aEhnVCa0xSXpi+zaQiBtJjN7rAtLBl94QySSSKy10vuupWfPvEKjXq6JGPkVNUj
	e5ONmktjzfMyNecGLI6v0Vy6AL7FLjYddLIcc9yuOPFQ33fEJB38MftKrhWWa4HiFcTtE9QsHdp
	cW+2JVfWxWcPqg8bO4qGJF97s=
X-Google-Smtp-Source: AGHT+IEWl3G9taWVAc0FXunulp0EUlwKR0OqZ4+JiONHzArIhRnKO+2ONevOYyoQ9T+k/jyvf8v9NA==
X-Received: by 2002:a05:6870:ec8b:b0:3ec:4e22:bbb0 with SMTP id 586e51a60fabf-3f1691d07f6mr3791225fac.18.1764890417156;
        Thu, 04 Dec 2025 15:20:17 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f50aa9ed65sm2288970fac.7.2025.12.04.15.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 15:20:16 -0800 (PST)
Message-ID: <3cd2240b-ec2c-45d0-b73b-b66c83e75b9f@linuxfoundation.org>
Date: Thu, 4 Dec 2025 16:20:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, Alexander Deucher <Alexander.Deucher@amd.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 amd-gfx@lists.freedesktop.org, dri-devel <dri-devel@lists.freedesktop.org>,
 Guenter Roeck <linux@roeck-us.net>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net>
 <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net>
 <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net>
 <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
 <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org>
 <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
 <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
 <3b6d6e50-91ac-435e-adad-a67d4198a5b5@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <3b6d6e50-91ac-435e-adad-a67d4198a5b5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47D7D180003
X-Stat-Signature: 1thqm9qtcpkn7ho6em1pxkmb39deubwc
X-HE-Tag: 1764890418-62698
X-HE-Meta: U2FsdGVkX1/xCeyyHM55QD3//2b3LTRfXOjocHyFdI4fPEfn42xdq2CVqTWXeZPPuiktwBbYQuDRb4sk+6rOv4jmslx8mxzzrMTxCvF7seqd+khoyrFJHLFH/dbTvrpSqa52OCBZoe+go5KQMNih4DrTYFFLlMYYf8V3+I4imSWXA881G0PhzJM2AaIdGDVrVzMmwLXZ9fzeGy+DF6h+Wuc3BeETU9D/OUCi0I8sWk5vpVWspjOEmjE4+G8YgK6qE8XfyHrmKm/v2IrFzMrxdo81QwTfpgYQiaDI9c/TU8+vxJJM9b6qSP9vZjL63EfUljBwZ7tfQxLtznNqrb81bYwnA7DFWwj9QBJNRlTwtyFdtbl042KUfni1RRlxS+ZTo2MD63DAZB1kJrK7QMaRq5pTLOqzA28bROWZUwjjhCQVhoRVNIXBwTMvrDg9FvGKRNg7lvPZ688FeOnn82QXGKle5FANPbytjvJvutnFi33HPu3nGRDrCxzDGgnjakXHKyS3iTpbT8W0XZqzUkSVYAPUIXpaf8G2CJxzm6UnCSsF8ssjA/aksgoUrcJcNjWLwdZa18zVhibI9yjUpCZvK/J0p6sWUGs3zxxqpNN2RhUJu08We+M2LndDL9pwA31Tz2f+hqBhehteJWojTfRGzLvIsFvOmd/bmp7/66xXmCyJEFPavQYjMIBXc3fdiBq3sUyXUv8ZvWEkUYY2sY2hcvQMwXSXz7IxhstJFc/J7pUHOb+Kc1vYLhG/K5r3bxEpnPR3ZYtITBe9ooNBJYtve5C+GeIOwfjxipl0R2HghuMPXLscRae88S9hCtes3MX6x7WE2UKxWm3uZUa4tvOJJAEwWIj3OsazfxhhfKtFUIuN9p4kC+MD9WtSyGzbbRwmeM7F0fbP+medpMqr2uaUWvRPcpKFsG+zW7CZLM37Ijo2rdJo/O/H2xqoXQqzFl8h2pyK23ggMoFIaeivK6S
 74n4tQNd
 Zndbbw2tBmgM8Chkc8ZQaRQ3jm0hV+lJ34zZNPpjJxz/kVFez60nPhS3yBZdsYMMcvyV124KANT2/5b3aafoi2pU0lZCSl0eNdEuxGXbatAedNg45mj2Aiqb/onYnBXy41OAWzDDfjR3Vo9sNaDmSaGPEF/haoF5fPqr+X9jsylBRwwLV6NbgO6iuHgCxUGjKR4BLJzlSXx3GPgpKRtr7Vh3wBAWsvqr2r8WqSmqnCSvkqYPPNjussZtf3s9n6V9ZxRvx16QTQa56XthZ2JIaYvxa19n76ybzOMUGzYVMJJZmdlDadT5h+6QISe5SdEpvjPQLThLrnWqTb8Dr8SXu9Wi1MtogH3UoPYUuuBj97HbRrseOkCgY9vzRHD5nQIe6/2bW5jToN4qEAtrf0xb1cSK8J9R84YShKISx2Z/BYIElndQ0sKIb5I+exg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 12:45, David Hildenbrand (Red Hat) wrote:
> On 12/4/25 20:36, Linus Torvalds wrote:
>> On Thu, 4 Dec 2025 at 09:40, Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>
>>> This commit has impact on all architectures, not a narrow scoped
>>> powerpc only thing -  it enables HAVE_GIGANTIC_FOLIOS on x86_64
>>> and changes the common code that determines MAX_FOLIO_ORDER in
>>> include/linux/mm.h
>>
>> So I suspect your bisection might not have worked out, and there might
>> be two different things going on.
>>
>> In particular, hugepages were broken in 6.18-rc6 due to commit
>> adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero
>> folio").
>>
>> That was then fixed for rc7 (and obviously final 6.18) by commit
>> 5bebe8de19264 ("mm/huge_memory: Fix initialization of huge zero
>> folio"), but the breakage up until that time was a bit random.
>>

Both my systems were running rc6 - I was stuck in a state
where I was able to rebase to rc7 and then 6.18, but could
never build either one.

>> End result: if you ever ended up bisecting into that broken range
>> between those two commits, you would get failures on some loads (but
>> not reliably), and your bisection would end up pointing to some random
>> thing.
>>
>> But as mentioned, that particular problem would have been fixed in rc7
>> and in final 6.18, so any issues you saw with the final build would
>> have been due to something else.
>>
>> Can I ask you to try to re-do the bisection, but with that commit
>> 5bebe8de19264 applied by hand - if it wasn't already there - every
>> time you build a kernel that has adfb6609c680?

When I suspected rc6 to be the problem, I booted rc5 and compiled 6.18
after reverting 39231e8d6ba based on config file changes between rc5
and rc6.

> 
> Right, that's what I also proposed in [1].
> 
> I cannot make sense of how 39231e8d6ba could possibly trigger it given that it only affects the value of MAX_FOLIO_ORDER --- which is primarily used for safety checks and snapshot_page(), nothing that could explain changed application behavior, really.
> 
> But while Shuah is retesting, I'll go have a yet another look.

I retested on both systems on 6.18 making sure I have 5bebe8de19264
and 39231e8d6ba in there. I cloned linux_next and built it on both.

I didn't see any problems on 6.18. Having said that, It might make
sense to hold off on including 39231e8d6ba in 6.18 so there is more
time to test beyond 2 rc cycles. That is for you all to decide.

thanks,
-- Shuah

