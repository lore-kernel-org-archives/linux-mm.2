Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84215CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9218E0001; Tue,  9 Sep 2025 21:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33876B0022; Tue,  9 Sep 2025 21:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C218F8E0001; Tue,  9 Sep 2025 21:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB5386B0012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:06:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 534B9BB341
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:06:08 +0000 (UTC)
X-FDA: 83871549216.17.68980A3
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5123AA0016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iK9cil/e";
	spf=pass (imf15.hostedemail.com: domain of rene.herman@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=rene.herman@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757466366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDZwAXLouP084B9hVHdN4iMIIVS5iU06EyLqPH/Ivgo=;
	b=LSN0qtWLkDUtWvyK+h9BWkQhaBCrt//JEjtOKRtD5kCfgQ0HU3+sEd4qFMwk88JeT6/gu4
	rDrfgNA716D2cma786cNr5Ysj+eCjzNe5IIOo7iVyIMRA1Xu26SlsFDT6N0YI7z0FDKfgT
	RTYEo7i4XVfvkPkMmD2apxx0S+odfCY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iK9cil/e";
	spf=pass (imf15.hostedemail.com: domain of rene.herman@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=rene.herman@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757466366; a=rsa-sha256;
	cv=none;
	b=LTp6Y9w5BRcFcL/bIkUifn6Ls4Dj1iPmAIXe2Q/rgtxy7z77cbLzDm+P4fdmBhaFqjGDX+
	qAgURey5nlA92vjzMtYNZs25mI7cbgmYjMnkgldgP/M7V6GN1g7t0/Anm03n6MBVge2v47
	wp47RIi5Q2HXvzPysOSQsgbmhUqIy5E=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0787fdb137so32166466b.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 18:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757466365; x=1758071165; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDZwAXLouP084B9hVHdN4iMIIVS5iU06EyLqPH/Ivgo=;
        b=iK9cil/eOObh2TmUeu/hRoU05zXQZDjiW9eG3Ipx34Jf8TgfPwk/GjcW/veOo4gf2v
         K7YfY4/4cb4u4PH92xWRIHLldsvwQCPc+x8y421AL+bAGD796v5m16yOyCpv26tIreGD
         8Z1OrezJMDmKZtlniuitItNAdmPjq63FZpZANGBY+oP45tywG+LQcN7sk8jZEVr4UFfv
         rlZXJzS5aDukTqYKgTwjOfr+py1Rm2oA0dVtV49bj8vAVTzvNHiT4/a65moq3dLxAM9k
         Xs8rNVBG3SHQqKB3tkGuvo+4BlCOUjgPwqMpTaV5jf0U6Xcd/KC/qWh+EZW5cZrLOJqA
         Ynkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757466365; x=1758071165;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDZwAXLouP084B9hVHdN4iMIIVS5iU06EyLqPH/Ivgo=;
        b=pHMuGi4f1e0QfBNQbCTjMgX/JQkM6uru8/WqpSyZRGHZNCtldYng+We/ceKs2JiAtU
         BxGATLzaiHmV0QXbzLMpXaQnJKUZebxcqscNwdnGo4rBMaHNktnsgwLO+3y75M+eWz/N
         JGM7PhAGIrhB8ztCmx4Z4M/QEcxQ+rf4w0Cp1jOWzKHkKCnXkfNW0T/J7lY4P4CdBFiN
         ZMXefGpdBzdxR3iGkQ3gk/G1TDvYw9YJIEn9RAnMQ5/+4h/fuIvVkvY53jITTbeHosB6
         1DObmWfPQ8h8elaHiwjsLVFOBlGZbu0a3qWttvqw/QpP8IP47PGTOjzTkOH8K2Hz/c2W
         Jx+g==
X-Forwarded-Encrypted: i=1; AJvYcCU3X1e2l6OtYLZCJ5HXzMM/KCtUK2J6arqEp33/mHH6NvT9y6ObfSi742obd+J8vRtTSRqSNmdr/w==@kvack.org
X-Gm-Message-State: AOJu0YyqKcU8h8swz9xBz82VlKuXfAT4ijKcD2PU/AJSip6cwN2hU5m9
	LEG0RFkBTLOBpSS4R++JU6q2Y3/2qO0URCuSTieWCRPKLrk5r2ntI8lk
X-Gm-Gg: ASbGnct415o8zc0CmpAoBYxHJ2ryIT6Kbi8jPm8MH7tocQWl90piJLnovyb2KA//noQ
	RSIPb7KCyBI9RCklS/ENET6jLBxdHTBgnwNf1S3DPAZpGhVECUlsFlJBATxEoJVx63koCtEGImo
	3ZqVM0PBjhFvDBk2R7+cGLwtkPktW5ryabdRKOI1eiigxxDZQN0VgwhVKXc5HFgqHg0KOWa+m89
	LLro/mmxEo882m26bqVfUV7AWnmeVHfF0Kibj9RmtyUlY9bBTqWnpfE6n/pRCV7W4Nt+yjltuzF
	ovcrHLXXJczjgdkWz5o+e9RatdHl9iTgK3H3J0qxIMgff6sGVnEhu8nnX6Wl6n45XEow2URkzJ+
	epGfccpQ31ornoQdMcLEPLnvTplRHx9GTCBaUDXWj2ovb4hthttG5qsKqhRvQK/BtaJXvgGDr
X-Google-Smtp-Source: AGHT+IFjBmxeo0iihWNvQGW9XaPHPBKL/NIGGGOL86gq7iDWLkzDSZTSGw6FlnjUE/qdjGTpbeIhew==
X-Received: by 2002:a17:907:72c9:b0:b04:4ba7:4e0d with SMTP id a640c23a62f3a-b04b148a54emr1331824166b.26.1757466364453;
        Tue, 09 Sep 2025 18:06:04 -0700 (PDT)
Received: from [192.168.0.51] (217-62-96-139.cable.dynamic.v4.ziggo.nl. [217.62.96.139])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07830464f9sm78316966b.9.2025.09.09.18.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 18:06:03 -0700 (PDT)
Message-ID: <bf46e8f6-221a-40c7-9da5-8003397ff113@gmail.com>
Date: Wed, 10 Sep 2025 03:06:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: torvalds@linux-foundation.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 alexander.sverdlin@gmail.com, andreas@gaisler.com, ankur.a.arora@oracle.com,
 arnd@arndb.de, chester.a.unal@arinc9.com, christophe.leroy@csgroup.eu,
 david@redhat.com, geert+renesas@glider.be, heiko@sntech.de, hpa@zytor.com,
 imx@lists.linux.dev, ira.weiny@intel.com, ksummit@lists.linux.dev,
 l.stach@pengutronix.de, linus.walleij@linaro.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, lorenzo.stoakes@oracle.com, nm@ti.com,
 richard@nod.at, rppt@kernel.org, sergio.paracuellos@gmail.com,
 surenb@google.com, vbabka@suse.cz, willy@infradead.org
References: <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Language: en-US
From: =?UTF-8?Q?Ren=C3=A9_Herman?= <rene.herman@gmail.com>
In-Reply-To: <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dungfyx116oaswmurtgbpgtn4osbsakr
X-Rspam-User: 
X-Rspamd-Queue-Id: 5123AA0016
X-Rspamd-Server: rspam04
X-HE-Tag: 1757466366-558996
X-HE-Meta: U2FsdGVkX1+BzHXAqD+6F5tgW4eCzIBgRriz80Cnwuw7jthNAailUgzJlyf6IXjiWzRyFqvKMDfzUAi16UrO8B9a5gfdAb+EnjaPjPFX71xkge0qxunlKOP9+OLsPin67ltO7aYYVDLPX/0Dhv+EGHNlzEdAfVP7vXH4YqqwHahrg0BnvQHtV/bozfmRAeJUCiFeRAXFB+VD6kO+2Yyz1n/nPXKus4OwpDU9GjeNvdSMtGofQbxlyy790dgFd1QN7ZTNoylzgg2AEIjoisrgGU3IPpYK9f1WHswWEGvH6SJ0hAIE3uzZGxmAqsFKYHhYsOEsUtVflrsGdnCn71F1ZJrSqvuytO4WDUcWQvtknFgzIKTjhIH8Dirhj1T/6tmxbCmU6wdvvzvZurHXTpzPS+kYDVz17dbb3UHwES5ic+DW8++9dkz8Elx0b+r9CcO54Du9qF9WJxh82j5owRPvlm51A6sZlav4gIfNLOpG1ljRiXWXImQBbw0UIc7AMa/94cb6c+INCjuBYI+npXQyYjijcc5oo1fXeUYWcpijYdKrBtrLz27wJlh6PsDaz/TjpP9yBuX7IinX+nHhRAWkanQYbfdqBiYu7YZW5lOdHyAwQ5N2jK/V8cBCC+Nn3HtFF3f5cHvjegJjYlAwql5beEiJlphuCpOwYgytgbtLQJCamTN5RphrW2FtSMvWeDlwxat4FdBRRvSSKBoAWuHcJT9xFQZCAycrnNQhywDONowob2NnBMLs1v72HFbbM9TjCLHO1YJvgR0M8/TkQjkKE4kELiaM5rUyAPl3jvSz1lvBQzxormcCDlGyXvqkT1BfHz+2Ypy7awIEQB2nP7etLCmpXW7P+bo8tdqLkVkroar0VAFyO1F66ZwqIQIlNFrCtQb7C0GTs544dXoAIf6dPhzlcIgyph6zjYA2nrHHM8LTwBb24910QpxR8VZeC1Ml/mBRt3Q9W3GGXrxmZxD
 4sHpQYB1
 r7ScstacoKzP0ALMSmP3zuSaA1MCWwSbiuSEVSH8B4a0Ra/RCULNqG+nr03UJDd7P20PqRI3v3z3hvzEjH1ZWMOAXQV2eMLZHWGNVIa0Ehl5C5Q5xH9DQ9hfjy+HP5JumHYo5woEucGP+uObB/qTb1z3RxnYLFrokR2oDsOuDHG+X36NFbjeIchE7/8SGUmaevjM3t6YtJQT3+yBqqJkmwQ0O7I9LjuPE5WVpZllCpEI92tD80qqmnuBcQ5dOn0SqmPEFFUiBWmNjvYLvPJoIajtyK+tddFuZEWXbcmsNXFDR/T/bx3+mooH30DIBjy0a5oPx/KQrX40sRRYOFjdY+rnVx8fNRWUl3st9SrHxkD184o2GQ8K7NJ80TpiktWOw64EQMDjGvezYUZaI8stPPsdgEwEFBz6eRWav3fwkc8o6CAou9pnuePKti3lnsojHge2Mwme/pUBy8+e76fP9UB+pvS5t9hxZXTu4+42Yaio4U7kQ07t6KjS9z8PyQhMhl8iGzHj8SjbjqKGhiTFlVBPjINNtQAsi7H9tN+Y/1U73+ghb3NOCcb3xEPrE5sG8QOOkGsk7ycmE35s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Well, while on x86 1GB systems did use highmem, they'd typically not 
> use very much of it.
> 
> IOW, they'd have about 900MB as lowmem (ok, I think it was 896MB to
> be exact), with something like 120MB highmem.
> 
> So they'd either lose a bit of memory, or they'd use the 2G:2G
> split.
Right, 1G-128M of VMALLOC_RESERVE, but they didn't generally use 2G/2G 
but ever since it was introduced late in the 32-bit era VMSPLIT_3G_OPT, 
i.e., PAGE_OFFSET = 0xb0000000, i.e., 3G-256M/1G+256M.

Although at the time the patches died an unceremonious death, 4G/4G 
patches for x86 were also around; I used to be a (conceptual) fan of 
them: it takes quite a number of TLB-flushes to suck more than highmem.

Not one hint of clue if spectre/meltdown is applicable to these systems 
and if so, if they in fact do or should already be suffering through 
those same flushes anyway but maybe it'd be an option to dig those 
patches out of some archive somewhere.

I promise I'll test them on an AMD Duron with 768MB RAM :)

Rene.

