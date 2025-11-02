Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10CFCCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 17:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BFB8E0008; Sun,  2 Nov 2025 12:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463ED8E0002; Sun,  2 Nov 2025 12:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379DB8E0008; Sun,  2 Nov 2025 12:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 243CA8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 12:52:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3AF5B8F13
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:52:26 +0000 (UTC)
X-FDA: 84066411492.09.C5582B4
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A755180009
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 17:52:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhaJ+0xP;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762105944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2Ec2zQurK8STOuaWu3d/5bNQMcmfortr8Sd7cdcPYw=;
	b=2QhIw3Lh5XQ0WDFR0GQqbX18FIXsZMIDfC3Lo5GWfyrHzcTXAeVEsALXkvCCuMYPhfxNWF
	oMgKJn72Toid8KQLZVVKl0nXi+IzaoNjBv1MW0TqERdmRWeGpEfh8h7jYn4NG856Dmo8vy
	KjyNOKNDoVtZJobWbFdfmqCPie4U4B8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762105944; a=rsa-sha256;
	cv=none;
	b=eLHTxURwLMoG90Wbo40nIxHLfP94GNtJtb5xGkFYCsoxKUwVf+NNdhiJoTr9LB65tZq8jD
	DuVUGZ+amh1lc5gasSgCRU29bUu7f3n0t3L7RWZmmlGFOLWo0EldFk/jyS6It88fqt8wdD
	RYwFwZyL3ZoMsi9IAjZaTpYBKuOib08=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhaJ+0xP;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of groeck7@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=groeck7@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2955805b7acso7373215ad.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 09:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762105943; x=1762710743; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=H2Ec2zQurK8STOuaWu3d/5bNQMcmfortr8Sd7cdcPYw=;
        b=jhaJ+0xPxbyCwXORKU8GZwzlStKMgn50uC1izYCw4BGTa0iBnB8ry93f+jmb5CxXjJ
         DY125hCjT2yt+TQio4ld7NSr6484//tdNa4apWGAGLEOG8n0nOBorw2adfa7daGJiWC8
         3qU9v1vS2B/crgvgsX6oHKP2S/ppLW5tYxdGApxRlQAeckt1wpsmUL/HAIMMkrAi9tx4
         kU0m+Ic75J01Sxmxb6X3Xk2kj8SUl/n/S0OJGxjHRSIuxo1z2nqDJzbCAraHltlbfBrX
         fAdB3xw0nzlj5hDvdy7EnuJTwWpn4Xm2uV9Noa27jNBkhIo2sQtegfC4tC4TdFRi3OeO
         I9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762105943; x=1762710743;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2Ec2zQurK8STOuaWu3d/5bNQMcmfortr8Sd7cdcPYw=;
        b=udPb8dDcpgHojvlq6/VW1jr3IqIU7UcVorQ4cruQXsq3zP90QmWoAZBhN0vt5G2lub
         s9u+qRuulLA0YybbjYDPCGrsJ/y2c1v7JCkbkUZEOamgCnKCf3zzVHb5czhJwkpJRM5E
         XUnJ3uSRKneKRC13taFXlP1XT9//76OGECof7yai3iaO6i/gKqw0Zto1/WU9vUR0uOM4
         mKDEZ7+rey5NlVDOXuimvK5OKMw6tpok37R3VTf7wxBQHSarA74/KnnvG+PksdwaH0t4
         F+1s5HAJitSfrCSpqXlxcjlzps8UTQs42EPXoJwbM23aykF2/SKWEApHcBAgQLYXyQzc
         GYkw==
X-Forwarded-Encrypted: i=1; AJvYcCXoNmLJ9q/t3VAiMFEQHXz9uxZQROlTe/mqt9WqR2ZX31+Nokt10IGaDomiKx4TvTXlWxu4ozUraw==@kvack.org
X-Gm-Message-State: AOJu0YziVTxsAhwHqaevCGG/qnjKOK29S00/1+tzGK6fkky+7Jg1/P96
	0vwvsL3ubPDaQ8Vu7UJfaTkxNqTynHyo0Qx2ILM1xjUizh6/ei+JWEwr
X-Gm-Gg: ASbGncuGY8FglH/HueTpxyuGxx9GcJsKQzD0tGBcdH9r7LLOYyS8mvYXZIEpbFuQlQ2
	TYrM8S27W+U9XUhuPUXWzilrYqlWKF57lfreu/FZTq6ButkvtSzde9mfXG5O7WR8Ck9Q+GEjwTL
	sdlsJm+aO3OudZ/8hSceSSefSGd7AG7QBMLD46nONJE7NU6OuIbwBaVjURaDyx2hXMuL+ztFirN
	s9u4PTxhc14oSE+SxgxC1XH70yzzDQFyjo5iuH09TQolReYJmp9TSyhm3hLRR4980Qb+KvJl70y
	rClC9s3jNLl8HVcmIJMOjmku+gxOSmE9cdK6ODTVr/LETNhMtnK1PzvmK1uIH11U19JTriCM4a2
	rXVJYyKtJBY99R7OX8u9P0UJrgpry5SGeCzw7MihNAzJioChsDzjfe669O2/o2jlT54MvPojunC
	m4fZVr21BXTChANOgYBSxsk05oHvywSqpkj6mfHO8LcbmSOBPo
X-Google-Smtp-Source: AGHT+IGtoTdzpUb2T1EbfjQRkDOZfadeV+MUvBKwgGICeRZwRx4ujvdTe6AhPX5UfUKG81LSmwLfZQ==
X-Received: by 2002:a17:903:228c:b0:273:ef4c:60f3 with SMTP id d9443c01a7336-294ed070898mr190085585ad.4.1762105943418;
        Sun, 02 Nov 2025 09:52:23 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696ea51sm90821675ad.57.2025.11.02.09.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Nov 2025 09:52:22 -0800 (PST)
Message-ID: <71da525e-fea1-44a1-9d47-9280654690ef@roeck-us.net>
Date: Sun, 2 Nov 2025 09:52:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
 scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
 <CABXOdTeOU0qeSicdDU6DjNHWpzCEhK-66kTdwWjb3M+=Xr3aMQ@mail.gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <CABXOdTeOU0qeSicdDU6DjNHWpzCEhK-66kTdwWjb3M+=Xr3aMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: e7g8adz9gm1o6zudam3pjhtrhuwz41se
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A755180009
X-HE-Tag: 1762105944-249167
X-HE-Meta: U2FsdGVkX19Sr0uq6r4AkNk1LItfEXhSOzlvMC3NBji9nkjiwbNFCMAOu87hJHDG9QS2a406r9pbT/3Vx22at6rmeH9VG5fa2DQ17hx7w5k00oZNSnL8/DM/WxOQ075U8kOv0a+XPEa8zUXwT8LMjhCulqiGz9UtmQ3WU7TnwLiRKa37Ho30AU4L3wXh/TI59ISbPMYaF6cwLv7AG2zj66yJfx7lbdiqYBIpb5qj2e7k7CNCzqGRTtUfZegoCwfFGI8i05wM9clKfHIKQxw1Q5SK6GFMKaumWs3UaETyIm4Yc6QWeEL+23mzgOsmGUpURLT9Y6CQaiGd4gPz+aL6wW5Zwa6nIrQDGQ8OOxSiN8EWzS4m+tc1jS3nZ6VhxOlQD76vtM0KxFt781AKOgv1yKR6s0IhTgwtJpJ/tsAz9qEYzoLFY7+ys//VIljssgr4jQHyzAt7YxQEff80sUP/zoSs2yDfMQP3b4wa2ljMm7ZMldPbeMlsFnJFkUS+ZilCN/moKiy7HIUCTxs1IyN+DzqQ85tS0ncvcEKSyneVLYVbBPw4Cy5I4YNsCsuQf0xbW9rTE6zcTXKPJf/MO6RDFsb5S2Soxc2/t3EPPUvK6JISWMTLOv4zZY9a0+lC3XsKcErihCjan8PbahsGhmm8P/mFTAEQBA3W6GKZsXhpu8mbHSsUsgEGm0bIDQeTMKDJuqSIekXX8XOdEACuRSGu3lr1bxL3q7ZKRxbZtaGm9fqN3pHnWyQ72CD1cRAStHGPdFKzvYAL7XamVF3Z3QOavJF34LCAoUJww3t4vGMapW0ac7L7m8Uf6X/r8bDbdZLYpkR0QGWBZhkp7k8f4sqGhhbzljczulHURyufww4EGq4P05xJudYS/CboBJSesB10W8eKfHFNiT8Wd2BKj/vwNIX2qlMUQ/ibQBytbEN9vYbTV9dH6j3LDI57rErMNRQR55c72csrrgp7ue0z/Iq
 FEajS1qd
 2cSmNOq9REU+gBUZ4hLvzjX3FNTJCkTN4HwhiFIhjUNOp15pi0bdZZ5ei3e3ka8oYIvjYgBuAZ8UtAr+zpEnDb+lzTxCfEHshDs7mGMomJszwNCiO6ECtx6SSpnG7Fj/5EsaAoaGLz0ylmjpJh6CpM7GnuAN8OSzt57/HAC9PRveiFa9qEZqU2VKwDTCuRj9R40GOvv6mi0GcV/63BD+Ux5VwVKIe2SdGb/mxlUZbexLnWgoQnHlrszk8FhDLkFiu/WOAQFoqntM/m5dDKve/9n/5aja83c/qXZccsg/AAmYE0toLn9puTDQegtnK6OpibEJTZSlEMhK6pE4RNZFBpYXK8HtLuzfKWSfrm1n/CDgisuRArBDmuRZxUeiNG+OHlmZsK5vUhic6J9jCg4s6G876M+sa+edrnWMKrPrfR2thS3vK9/z5PjIY/rU7zgXim8OigOoC5ul7xwh5J5BxUU8R/Y2zrdZM9w5gkx9nqwBS0nIsI83Wk/Uy/U5vppW0RKA4w+3u/Eef8G6l/w4dit069ixBu+Pt+AZZy3N1N2PdASuGVohaLPSwjCb9z65vwyCNrxIgdh1TuHVj33TIM94UwtdSLaUZ5wjKVvbpHBe8CuGJjIy2OsULOd630R6GcDYYZUrrCjudG+UgapLWQgr9Vl+kxZ8hZzbK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/2/25 09:49, Guenter Roeck wrote:
> On Sun, Nov 2, 2025 at 7:09 AM Ryan Roberts <linux@roeck-us.net> wrote:

Oops. That was sent from my Google address and got messed up.
Copying Ryan this time. Sorry for the noise.

Guenter

> ...
>> commit 602ec2db74e5abfb058bd03934475ead8558eb72
>> Author: Ryan Roberts <ryan.roberts@arm.com>
>> Date:   Sun Nov 2 11:45:18 2025 +0000
>>
>>      arm64: mm: Don't attempt to split known pte-mapped regions
>>
>>      It has been reported that split_kernel_leaf_mapping() is trying to sleep
>>      in non-sleepable context. It does this when acquiring the
>>      pgtable_split_lock mutex, when either CONFIG_DEBUG_ALLOC or
>>      CONFIG_KFENCE are enabled, which change linear map permissions within
>>      softirq context during memory allocation and/or freeing.
>>
>>      But it turns out that the memory for which these features may attempt to
>>      modify the permissions is always mapped by pte, so there is no need to
>>      attempt to split the mapping. So let's exit early in these cases and
>>      avoid attempting to take the mutex.
>>
>>      Closes: https://lore.kernel.org/all/f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net/
>>      Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
>>      Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> Tested-by: Guenter Roeck <groeck@google.com>
> 
> Thanks a lot for the quick turnaround!
> 
> Guenter


