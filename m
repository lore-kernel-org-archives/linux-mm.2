Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8EEC606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DBXHHs+L
Received: by kanga.kvack.org (Postfix)
	id BCB5E6B05B2; Wed,  4 Nov 2026 07:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C546B05B3; Wed,  4 Nov 2026 07:29:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A471B6B05B4; Wed,  4 Nov 2026 07:29:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718A66B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:29:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1425A8317
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:29:52 +0000 (UTC)
X-FDA: 85397368224.18.A5CB343
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id F08A91C0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:29:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DBXHHs+L;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793795390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3sjZ1/zDmNq7aGULg41fVtfLI807ZzIhfXxdB/64Uc=;
	b=RjTZnuoE4CEJh9RfhRuvUl4HEHIALL+kXFgpHWtNJIeW4JGLsNpSuKWbVuG7OLP+7CRZsE
	G+AS9f+K+XMB5J1I60xfbSvCwrDXkNoRsN+byw+hfr+T/hTV5TbugXLwHdykQOs4HLxBDW
	VI03iAl9XjU96BLWTYakJJQbTe9T+ys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793795391;
	b=lrb5H2Qzazlucrt+0Pm3crcuoRiS7zA7QLNGBTZ5Qi0jhsbhRTZB5OXA7fkdtH73Hbztn+
	sGWLtMPymF33GA/HaHFqsjNTQmpOxzdAn4UazpUhOpOr5SR0oiQB3RF21zmpNL1R8JFXby
	7d3DcPI+qm3xF/2BMZ7ad+ZrzEWGqYY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DBXHHs+L;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so4903045e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 04:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793795389; x=1794400189; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y3sjZ1/zDmNq7aGULg41fVtfLI807ZzIhfXxdB/64Uc=;
        b=DBXHHs+LMCD4Rc2wTKwhO/BouPSV/myu/0B4Mx1y8pD3SPFPqLEHjdaRV5M7ddDo5a
         yOFxcnn0wf6Aii9pvwXcszcv0kLDJo1xh4LtzvOm3Jcpc060o2BtOELoaWAdlT5xytU4
         jln5WoMp01Pf9ck8FvlmQB0rUmYydwLZuSFAHhSbwLeUoE+ZDhqcnEYay6PtN3HFT6kt
         m3OAR+Vgc/DYyuMQYa858FOEtJa51Ff1akYAvnqWdT4TxIj448op2isjtYL/wGYBZIL+
         hSTmvTZ0FOtoz4LS/gD2k2BxLMwYrV9wJM4AG275/BWEy8gVrL2JIfFViSm2/GfRyJUf
         8O2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793795389; x=1794400189;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y3sjZ1/zDmNq7aGULg41fVtfLI807ZzIhfXxdB/64Uc=;
        b=jII6A7sFKJEQcKLL7jzbgxsThDygX6t2Yx3FDxEXYy9tyzJRfLiu5nEFFDLU38cIQy
         w2cMwn8MckR/uKxpNZUvlpEZmZPjwuvWVsCJP33JtOc1MEvYdWv9EqObPv/T4XrWikb9
         qn4Zgpkx0j8odnX2b+1ZJiWlUhCqF6jMr+3Ulp7uejeQSdYc+/9C1FWbQLXclq/E5zzi
         qtGw3+VsVzunQ+k6w9tQ6WeBYswrOYODgYubAopBZe7oC51tVHhAklvfwQGiDQF1ENZR
         pH8xJ/JnScbz4sLlaEkZ6xm3vqfHqMyB9KbMt4wkIN004zFml3OJ15yML0Qscj5Ovmjm
         rtcA==
X-Forwarded-Encrypted: i=1; AKwUvBwm4I/G81kKv+ulpa1GrJ2UJqmOG9cTZO+wNFnLUrc4YpVZ/i+JYgD5Zc3Ax6cY5fkVDIuBPTPyEQ==@kvack.org
X-Gm-Message-State: APuU4Z9PrDoXRMcH5yHCJR3rqF4MJrtn6knlSQjm6QLiVQQgHdH0tvw4
	D3hOpjhxm+qBFc0FxyZ53Il2ZK800QaxSQTlT+vSTyG5aCSUMJ/qfndI
X-Gm-Gg: AYBFou12ZjDvjWFbTHRjQmOoY8FcjN3kRs2VxGtZVOSc+YYqUgjhNwPfAigTw9A2bD0
	eJAv0qfO2WuUgzanXzmqh4/UV6tayXY8MFPRJXCVeIpETVjkspxDUr0cPOOcqZECybkL5wFDi8P
	I7sM9n3xRHzjAqZOhQ7l6z6VG+F71n2QcS/5XoGLqjZGsdMA/ImL+CZCizD+d8C3xXIPQHpsX8r
	sckFdW59vVa8eCzp/q6hRSz3yxE0+BwrurTWcG/EnN2ukxztrYcJwkN51K4JPWOrysmwV6wdHmJ
	xqo9YK7uV9VErN+PZzesrYelk0OCNhyqlOQB1xM3AW+28aKma5QV3zKCp5P/L0JScpyWOp/VSjq
	Rk0Kq2lqdaZmSUAvMZEAo5ffRl5+bK/I+tw3qa5kXnvdG30/59ImNaPGBAr95B/qC3HZJ6qcxcn
	mLkwc/ilqfPL8kx7TnD1YY7HcwZInzHHDBkyD+5HBVWK6P8YM8LbgFm71shWqgyO4jTRdCa0BKX
	p9/Q3yCgc/8f5GedN3ksb+U1Nj8F0/R8UAVEf5edM8n19+/xgr9jlO/DWA0Hz0n0PvtKNxT36cn
	SNGKjqryO2o/PLPvIAvYVtg=
X-Received: by 2002:a05:600c:1d02:b0:4a0:1c94:7042 with SMTP id 5b1f17b1804b1-4ac16bc4731mr395490185e9.8.1793795384605;
        Wed, 04 Nov 2026 04:29:44 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2aae24b32sm129017035e9.12.2026.11.04.04.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 04:29:44 -0800 (PST)
Message-ID: <bb3a8a16-daef-43e5-8ede-d9a6b7a7bf38@gmail.com>
Date: Wed, 4 Nov 2026 13:29:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO
 bootmem
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
 Tony Luck <tony.luck@intel.com>, "Guilherme G. Piccoli"
 <gpiccoli@igalia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
References: <20261021211058.83483-1-azpijr@gmail.com>
 <2vxzqzhhg8l3.fsf@kernel.org>
 <32dd1f28-db55-4674-99bc-74d9d3ab25db@gmail.com>
 <70686061-787c-4c99-ba5b-ff982c8cc2ad@gmail.com>
 <2vxzfqxglrg6.fsf@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <2vxzfqxglrg6.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F08A91C0007
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: oap1qk3a7jhe894yciggu9ptyurgzyz8
X-Rspam-User: 
X-HE-Tag: 1793795390-298474
X-HE-Meta: U2FsdGVkX1+3mFyEuJjsyV8Q1glQZRDGBd0Q5mpJ2rzeL6QvnzBzZ80N+TL9T3bboJDvI80eaZ53rIVNMm1UZSGQXLDR8qc5PJQ1YYdevrWrq7YR3+uiOgki2sANEbUw5fDD7MCDRadV5F7jCdsBoYWFK6Lok8AwVpUdMzBtlgzg5n2mS40y6fk34KB4JCJ40dkkGyXUpCrgVm0GW7+oexqc5bMZmtsx2ddQ7FvalioaXZFQk9EJlveJmaDBeMW5dEYqKp5/OUdWAnop8DvBAmOokXWbZr+feQAXvVMai8DHBV/ssB7IWb0VBlFSQO+hBgQfy6FL28OPJfziexZXsM2l04I3QMXu7j+6UekYCf4qlgOeLBwt0zEOFtej3LoHWZdZ4YkxMC+VFPOFqmqPd+RbHPOzSYNnZ+4K7NeXxuciS5oo0nvRb+J4ftfzq+Ue6YOnaU4b1m+WeTfZmQcGU+SXdrX9VTZJQhsnqiDNZKOV8H7nXPj4wS+3cWSP9JpIeEZm8UMyA8mV/Mb1ENQL1nvFvhAWwAAx5v0ZspXwPwtNlNz2Ay4m6OFUVoAUVU4/3LlECci+VGqA4Kj6JgmU1YFtlAqN1lkbgvVF2V0cST8CDbTptUFOZQ0jUz9I1w3t0oQAAbPJrpcVb1Oai2+rJqhqjP8S/KSMIWZ1OBQ+WUokfPZVexvO3YrGoNdMVJT78BnUV0/HXiMQhODik8Klio5BVAmzZr58wdfm8EhgUR7yHxLpjU5HduOr/Y7rcSL//YWpCib1I+ZEVKfAuCFN6tgadbjwR+Tc8o2B42w7afguTfzBsMifOuuvHyx4EZZCLx1I0p0G9naCFlhXN1Sy2Ows/sQq/3nZIp3IB2RwGrnKRfXn64SaFZ7Eu0I7+Ipj1wxGDCM8EWtTM3wyY1NhX4NeRam3mhtoirmHrbMBcwu00AS8hC8k2X1KKYQkCufw2mZ+N6xne6knk8GEXx0
 eJRjOp6a
 CegllN9Kl4RADjICdLl/AeYb3VqUdhcKfAMfXe6P37t+jI90QJqY8MVz0wbMSQ5+8bSDsJnIf6aDrZvW4gOIEGOM4Y2wqRx3/LKfFKdmpkRIYDwZO5sBW0pTx55onGRicrnxUeQuzuBNPfUWQ8VkIdTbxUSmzHWDWSjpB2Cx40ShvJFl0IfdVVOJqz8jL9jCRxUEXf+AP62bUI8T7gMCZVpu+prZSDQomlsyVPA4SUe186cIyq9JoLOHljG90qg4VceG/bRaLzk6DvPVuCIg6k6z10u06lgitTcTsX1lHTtKsfeOy2y8GmwNP4p0LIJxi40hh3ag+p3NtmijICGzqmDS3q7tK7i8e/9409Wm99wfUg3wGQYPr9nscj4CxfHLQ+gAgid5hX/KtpJiFxWtTa1Q3RU036ebLeaDrvlSlzoo8Xw4hQ9iWTZ0s7aluiYrsW8mpUHpkhB925qsfmsn2/q1tA+cKTsbszDPSNuh8raLG/7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 1:19 PM, Pratyush Yadav wrote:
> On Wed, Nov 04 2026, Jose A. Perez de Azpillaga wrote:
> 
>> On 10/22/26 10:16 PM, Jose A. Perez de Azpillaga wrote:
>>> On 10/22/26 3:37 PM, Pratyush Yadav wrote:
>>>> On Wed, Oct 21 2026, Jose A. Perez de Azpillaga wrote:
>>>>
>>>>> On a KHO boot, a reserve_mem= region that can't be revived (new name,
>>>>> size or alignment) can be allocated from KHO bootmem, which the next
>>>>> kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
>>>>> fails; without it, the next kernel's memmap ends up on top of it.
>>>> What's your use-case? Why are you adding new reserve_mem regions after
>>>> cold boot? I'd rather avoid making purely theoretical fixes.
>>>
>>> I don't have one, I found it through the TODO. a different reserve_mem=
>>> in the cmdline passed to kexec is enough to hit it.
> 
> If there was a use case, I wouldn't mind fixing it. But I'd rather not
> add code we don't have a use case for.
> 
>>>
>>> if it isn't meant to work across a live update, would you rather have
>>> reserve_mem() fail on KHO boot when it can't revive the region?
> 
> This sounds good I think.
> 

okay, I'll drop 1/2 and send that as v2 :)

-- 
cheers,
jose a. p-a

