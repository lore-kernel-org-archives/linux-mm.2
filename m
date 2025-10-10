Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3899CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 20:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B58D8E0040; Fri, 10 Oct 2025 16:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466198E000A; Fri, 10 Oct 2025 16:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354928E0040; Fri, 10 Oct 2025 16:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCAA8E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:07:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F8BFB98F5
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:07:13 +0000 (UTC)
X-FDA: 83983288746.11.7F34070
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A3CD100007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:07:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=dki5f6iw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.41 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760126831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C9TGYFUXxVemAwR89Ulh9sGzSp7qA+8XlrADAfHgVc=;
	b=sKURQLKyIqul00oJwuLGxB+eF/bnWPAbDLxoMXRa8ekdYvp5Y3NMyK0sIA9ZvpfRc7GXS+
	FKGOsgifRAJK5QhiPqa/lV88RQzpz5JLaQYhBwmf/9/v31/+1uWserB4RVdZIacrpTLpW3
	QJAVljljYplz9fc33WMgPLlaCFC4BvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760126831; a=rsa-sha256;
	cv=none;
	b=Mu5cYcJ7EWJEcvaO0+40ykTGHvx34i+InZrdRQfqoWUfNCSQa2tK/j0CJ/mbyNwJTDdnJ9
	4YiIa91Sjd4Q9Kzx4hLbwf8XqohTNKHaEdNaGX6g58DzVTlNazyyM73jP3j0ab+Tz77rRO
	afdQnAQ48by038k+frmsUGB5q/AuXwQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=dki5f6iw;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.166.41 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-93b9022d037so101780339f.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760126830; x=1760731630; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1C9TGYFUXxVemAwR89Ulh9sGzSp7qA+8XlrADAfHgVc=;
        b=dki5f6iwfJcQfOWHVK8cihPsCXXrUH7X4D5dwU4gN9xA4vJeiweZiLyqCS3N/d0V2t
         t4j1Gie3wlfPT3JT2WpknFXGyLOzoDCg675AXUEDTn0evscOkhR8sWSg6DEQ2oWL/lxA
         rGCRCcQmazUcs3T50uLFd05b5XkRXjUnEhNKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760126830; x=1760731630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1C9TGYFUXxVemAwR89Ulh9sGzSp7qA+8XlrADAfHgVc=;
        b=cD/fRDJvHpDPNz64KgBVsu9+MQAqUNR7qiKmv8yZTyiEneT/n2q4s4S6suNwZEq/Uu
         kZFBZkw6AUNLphtIvhUbhyGRydu0DeJVCDr3CgIxJteUSpwEXXpJYz83wfXA+jIwpaRK
         D3qfO0pdBU4UojRHguumAGlp/8cJ4QhFpG1XOFMLjS7H62iBidj4QhC3gB95WKvFLOap
         zsN/rRythElO68jDjARsRlFojtupyG9TaW9Y8ZUzXx064X2dvP8t3sRfydwEbRUc0bAt
         px55Lw1NHOLyl6qDL2T7DFyYdvWO7A7fmrsVF2DclBnwIrOhImvIp1g4Fhv58DXyx5Lp
         VfHg==
X-Forwarded-Encrypted: i=1; AJvYcCVKk5s9Ph380myarZZvTWzEjqboOLJNBO7H+fXTSINOMW+WS6jifzi8ipFsyAz+PMqbwQrtU2Ny8Q==@kvack.org
X-Gm-Message-State: AOJu0YwpTmj0mXTQiroXqqW2gob/wmN7QYWk2uI8nuHg7cU6r1Zl/Lmv
	qImbK6YN9WBQ0R/I3iQCIbpatF+mEgcr94oAZIaBJJZ9axqyFN8NekmHUO8DISDFyDo=
X-Gm-Gg: ASbGncsMqhqyVuUQacZUYfLOdmHI/K6l/Fya9zcrYDqtRP0HYwjyjSxaJnPdAGRFRAG
	rA14y2kZfB9EoToyiHzSJzp6RMMj3quOku+xdzTYkylE17NHv1GUoEC/sij5OIEJHjwKW2T9RYk
	5XKSzBRZGVtxDcqrCRTN9CPmLVIPDOKdlap/q3vwYp7+EEU2LegpxXdhg3HDbD+pTFAiFwCa2Kh
	e+5+PAJd3qhAv8K6i0Qut8gaLqMRXMtSPt19C7p8ibYKTyXLyyBvLMLvs3UJuiq7hHC8KXYfwxs
	k4PUZvz6+AhMnVtS+Ke8l12evNFIFir7vQjC8hhQ8Fi6YJDjH3RQa+fREXHBr4Ag7K+vZpvgqYb
	xlfBqyzKM1ddTy+TN+nzUVPd3z19Hk+NaE7b9DMG0guCbL40LpbrqVQ==
X-Google-Smtp-Source: AGHT+IF47OBorJnDZLxogs92bg9DbP41Re55bcWPxH2LtcWYwZh2W54OFZb8SOadJVjAyPp0dDz4Zg==
X-Received: by 2002:a05:6e02:2186:b0:42e:6e45:e0a3 with SMTP id e9e14a558f8ab-42f873544bfmr138691105ab.2.1760126829993;
        Fri, 10 Oct 2025 13:07:09 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f9036cee5sm23494755ab.32.2025.10.10.13.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 13:07:09 -0700 (PDT)
Message-ID: <75584276-6d30-4e35-9e59-e084c60d1c5f@linuxfoundation.org>
Date: Fri, 10 Oct 2025 14:07:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under
 label
To: hannes@cmpxchg.org, nphamcs@gmail.com
Cc: nathan@kernel.org, shuah@kernel.org, morbo@google.com,
 justinstitt@google.com, nick.desaulniers+lkml@gmail.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, david.hunter.linux@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sidharth Seela <sidharthseela@gmail.com>, SeongJae Park <sj@kernel.org>
References: <20250929172724.75108-1-sj@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250929172724.75108-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A3CD100007
X-Rspamd-Server: rspam02
X-Stat-Signature: yhqhj1tkzc3pe54jks57g7h8hyehh7xo
X-HE-Tag: 1760126831-184969
X-HE-Meta: U2FsdGVkX1+C62ooWiWjWHeFJ5GvRRRr/tbPG57Imc7+bDIUmuN9yE1G4hDeAAZtJRcplIcIHXd3x5OhUtXxE8Qt1oELhA/+ShIQgjWnj1o36sq+bbx6dVFSALw+GMvbAl0rWyfUT0wjWkULslH1wCCtIxfzXLd1LbXKYFMSlvwhhsy1dTbfzepiAjL0Odul7cVlrx6B3fm72hgFlWQOTt8pnD8mO9A8ErUdIVe2q2U77exEMvyPtWkNLnX8sYzCmQvfCZrpJL+KZNyrcXyg2n2Uzzjf99ZKH68Lx69eUQ1H9EBUrT5FlnbymugtyyIS5LqYCSZ4obvjIz+lrJ8LTEgOlc0yyDeQuTlBc/xwTmxdFdUKkrxQLXMbzEFbQ/6NUx6KGJZ90DwxYm1wAMm4+KRHlSzq3/+BJTj6WLaD5tN15CtBppF7Q0vxzLeUDvdcqSNFJj5cbDfgCldexgozT8OjXb2TIuyLKndmfTgiy1ntil44Ua9X8FVIq7TMrtx66ptmcDsQgUQsA5EBYwPXJv3XtaU0sFGzDmSpdJ86FqfifPdnIAcH7bL1sYi00cuR3DPY5RMj9f7STEmT79M85ZbUH0Q0N3DA9NaYBBjkoUHxkhZN6halusnce/hWhTeJ0Oc5h2hqQZ1jZoHWbaXRUonxNKeM7FConbQ44w2p1mWf8riJP/S6a1UeScRtQMbTXcllRq3fc/1DGW14fTdo/A3s9Y35MMzelcyUlJfSy1rCfE7OrtctlFnLRrk5rJl7yP80APPbrHKJcOWX0XrC2SJ9rJZBkcy7794aREyxTKIu4+O+fxVxrewmFEWxPNDfFEf6Y0gDqn3KumXVNy36H4dbc/lIgUI8p77fqyzpTYezFOopPUfFmxPSNpWlMi37opkIQ6O5YdLvdFzVjScuEoF96fA2foBK4UrOI1NJ04lrKNqGdd7ZVKkAGTlnr0ONsQgzBHsDbGRPDVdHbhf
 JFiooC3h
 qjzkITNFX+hnmyecKRc+evtpZu7OSgmyt5+/1RIFKIjO1BvUarTw2Hl7fFAJkqtpVHqyKg9B5KLHyGZuG/zdjiD6g3LiniXj0WkJtVNaYxuQAcrAMNYqstQQpVNZH5COnLjYGlFr4cMSb2vzV4R8LDR+yJs8ms504wWObNHQwFnH9i3htogFE6fkq7OZjo9VqS6Lyliiv7ireCdUEAvkIqJId0JW0DIEd6iq+jeL6mr5vgvtA0I4pj+wAhPcmc7V9un5Ykee5+amzeF2h2b25GqvMDoQry8Ic8apZJqOvqA1GKAIeCW781jzLRkj8WmXUVJSNITLl4i5+E5xc6KeppLCTEAjcfeV0v3qsMWp5ZKmZq0fq4z6+CTptCJdMeCZaatCcM9HQv5Inu7j16CHKvLXDu11/f7xc444sQsIt25LrdKoe4RuPukrjcIXBLcmZcuM2EfWz2rAka2xWJVIdUYseMUiOkQTSGFjcUhC1s+67sEd5sp4mLPva7kmGbbLwwJTqC9oVNFG3OinJ3sEfoWJ7kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/25 11:27, SeongJae Park wrote:
> On Mon, 29 Sep 2025 17:24:06 +0530 Sidharth Seela <sidharthseela@gmail.com> wrote:
> 
>> Fix warning caused from declaration under a case label. The proper way
>> is to declare variable at the beginning of the function. The warning
>> came from running clang using LLVM=1; and is as follows:
>> --
>> -test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
>>    260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
>>        |
>>
>> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> 

Johannes and Nhat,

Assuming this will go through cachestat tree

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

Let me know if you would like me to take this through my tree.

thanks,
-- Shuah

