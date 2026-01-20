Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63A0D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D62A6B0258; Tue, 20 Jan 2026 10:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E256B0438; Tue, 20 Jan 2026 10:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D796B043A; Tue, 20 Jan 2026 10:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B64C6B0434
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:13:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7399D2270
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:13:54 +0000 (UTC)
X-FDA: 84352687188.21.4383A09
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89F0280014
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:13:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=P5nAV1E7;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768922032; a=rsa-sha256;
	cv=none;
	b=BJsi+uzIniffb5ymDCl/OX+H3+s3+nxSo2MAKoqzwPavzsN03YeUMskq4NpKy1gdPFf1HZ
	kSA0RkX2T/3N87Rc2+70BDqAc2EmXOa6DCsAvkTrzqlR9wHVxnuQE3vpef/M1msKVhuqpx
	Gv7Mg15cwXpUcCukPoET30ywCC80Jkk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=P5nAV1E7;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768922032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfHF8XX2sLoiWwn6mh6WL+QXvB0XHx4J/lS+4r+T224=;
	b=25101CLCXOFThX1GedeaQn2Gw/zR5N9HLWtrCCdhfvD1B3sP1jlKI/mU6EEwZX1G/jxRX2
	OiRiW4e40rpBtvyqZ/kUBTCXFz+R/4RKj1SQ7XQEdz4m1+lHI2Do2aWoFZjPVu6EX75kwp
	WBEb2hq7TNYtpN6LgQ+i1AOHo+SPZ2k=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso37993435e9.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768922031; x=1769526831; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KfHF8XX2sLoiWwn6mh6WL+QXvB0XHx4J/lS+4r+T224=;
        b=P5nAV1E7qhRwNJBxSKujaaQf6XwXtyCcB2bwPD1k4Uv3rFVB/Vs1Tq6x78QD3C1XWi
         v5/qf/a/naLzY62oGRdOkJzbGAD6/Cn7Nud2WfB/9Tc2BSiyfn9VNSVqzUNjlXqoSXQ3
         csWY70xMAcg4roRiUn9uCKHdIzpz7hRQAweJFlofsGjyxT5Hyr0YYfAbODQmEGd895pm
         CEPeTOHQWeRkdhCiulUCgRDIb+lXnXT7JfCM0npO/QYTzPpA2EbuyGUgWqG4bI/1ivWW
         xVgnmNzEShZ0ngD0KjIioKAiq3eKsbp5iguOjaCbsQmgI5pKt0PH5DHAgW3kVJi7qZpq
         r8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768922031; x=1769526831;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KfHF8XX2sLoiWwn6mh6WL+QXvB0XHx4J/lS+4r+T224=;
        b=jhbKq5vPuEkgznAXgGvUjVj9hhERliFJobs4BKWS5EkR0AGeJZCWQVJqa/6SId3Jy4
         2nas329js4nt6BtohC4XJlbUQ+KK648Fiy4aHaN+yhm0nBKXqland4TOD+Z/M6ysnEyP
         f9X8Ktbx7cAA0pAW4480X0yletqiW+w6vyRJ67Zp6gu0aRvftteaHxHC96LU47I3NNaE
         qgsZC3oJbfVFqZN1djIO3l1zGeJOLOjVjo/N6238ha1UmnJ1zvPBGLvmwp/rIbeulPRs
         7Dj/qpoahOUlg3ROirLiB7/22HyWxXXjs2aC3eEIt4Gd+KVSjAnpxBTCixvZT7xDjU8r
         1eWg==
X-Forwarded-Encrypted: i=1; AJvYcCUZtqhTIANhMXh02e/SlPapy1awl7xH/bV6pyln4bUoHNGhRGYd2pe3O3tEjVs7AIy+OnEAPA2n4A==@kvack.org
X-Gm-Message-State: AOJu0YzZo+L6cJzSdQXR/aoixe+T1WWx2ZoLodnxISZS7H95URKerEcc
	xnhSpy/jAn+IkoD18PlqWLDcGWiXzaSRLg5t+izsNR5A6GyXc0MwPo3gURF345kGXTM=
X-Gm-Gg: AY/fxX4teWHUJLenRRJ3GcQTVdjqAGGq2k+gRhR8s9vVq9yuTqwqkWvGux40Frj8qAY
	ksJ3QVxyLLyenXp0d5yGH3eiTqzqPUc/R36OJXjNMcW7w3Ut6sQap7y9jmA0RDdwUg/QccwsD0n
	DuTu27wpdfV71PGjTe541PuE6qc8Q1UstMDIySR7q6IEiZnODvCXMl8JQ7H59wqwsYjz2Hfrsgu
	tLzIZ31xHT9dExGaxAXjxEAUSjH9jdXAHd5VFKLaTL1/mVC1rYzUS9xCFf167onyTEsgFH4WWWO
	PpuElFGuo1+WcxCKWJNs0XwjqyTDiVn44hmMxKcz8pfXqR6zr59il3ZShIa8yKpWABsh/CKnM+7
	jSHDUrzQ3d7kqilHepcx6jcc6yk8DWv7zQPac2y6lP4cZvWo17YFEwvNBG0Sf6VftoFO6LHKyPO
	BIoxMh/PzXKeH6C0tbAOF6Gyu+/vP3gDM=
X-Received: by 2002:a05:600c:458d:b0:47d:264e:b435 with SMTP id 5b1f17b1804b1-4801e34209cmr173700875e9.22.1768922030743;
        Tue, 20 Jan 2026 07:13:50 -0800 (PST)
Received: from [192.168.1.221] ([94.202.56.172])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e9ee5c3sm113053335e9.2.2026.01.20.07.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 07:13:50 -0800 (PST)
Message-ID: <ae85df64-b6b7-43d7-ba50-9c0525481299@linaro.org>
Date: Tue, 20 Jan 2026 17:13:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
To: Mike Rapoport <rppt@kernel.org>, david@redhat.com
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com,
 tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-19-eugen.hristev@linaro.org>
 <aVImIneFgOngYdSn@kernel.org>
 <4b8953ac-567b-4d68-9c25-72a69afdf1b3@linaro.org>
 <aVlsqdgXSBLIE9Xi@kernel.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aVlsqdgXSBLIE9Xi@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s9x18fz5q75hdatabbypd6ox3i4frq3u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 89F0280014
X-Rspam-User: 
X-HE-Tag: 1768922032-422149
X-HE-Meta: U2FsdGVkX18BpMFCxpl9Tsn0zrzfYdYqo4lBF6bmg84cLVVyJR3wEAyhsWLOjqILkkOLYS3N3xQ92TAJltNC6qGFCpLrnGmM+DDUXJENW0qvbbMuAoFHF8CILxTl40Voy8o+Ne3MgcIIkBXxRRvjkV0/oa05S+dX3WgH6HhGlYVkmOmvyXoRb2ac8jhW9E57Zb5EeWoo4A9JIHGkg6Nf5phcvFdrLDpMUcw9N+tR1R/nbGcZTcXaaqdDq6l0TOhS19JATH63CcwfdSeo1ywv4JlKZljIk0kE0cOwPZoBvWCRC4pyifNT/9g6f+/G2Pcwtf6CLfFb+vnYH/Rz2hMN4lAl1PHagZ4rgq/vhuSxSmrYnfQKKWqFHwpwRYC1zUeKxUes9QtC3AemjJzmMcQ77ezzTxX8giGBfU7jQKffheUA1kfNceGmxdlmRdBgWx+QIBuX88OmwRhnjE+QAqP2GWFZ8bI2rSGvQKXZsxU53SQrKtBaLcoaEOLojWtXKcpVuk1yZA2CdF7rYi4NB3c/+vPKMfNJgdu8dQv0vJKJy3QicDLsfpMUl+KU7+k6T51Um1L+BLHiWcbd8BIQ+RMKlI8kxw6a5ACoylu8ZnIR+yBOf+beDcYba97ymdGf0LrV6hEOl0MJGnjVTGXTM6uDYTq6hDuioJsWu/Dx5UsHgNkpGSjjJyulFiJi6YckFcyPw9e2D8Nv5uYWRR5Kv77ZWMTIe3Y3b+38VurHfi/1pL8GkoL4ZBvsoKsWp7T0xL9gmsCuiyTXZQzHsote/SMK7iZbdvyOQVfjKiE5U3JwvI6UwbbcJq9V+FJf/Yad9R1lLtbUhijxJaHBmNqdY4ctpqi8kQvnvIwwwxtWa2EhDRfx4Kn0yjAREs/zzpbEeXAR5U0go67epfYDHS1QQwF/QJ9oc9HsxaoexHDdvN2fldWG5YVHFf6JMpK2yUH3Zshe3ftSi/5NzBHpZsF3TkU
 KLl7bLfk
 Lwk+Z565uC4Fq9W1hGfuRgdOBn8Chk+cbUl2/Y/YBR6jVfLB8qWuDPkH2XMq/6JALMet6fVRIWBIfOpCULQdGYK4SfH6xnjWJEMCn/Vr5pTOirScT5r1tD5fNT3ohBqY37l3yBgUypvIYVtdhd04/35WB4c5GytBr+Jhpn5o9HgDTlD952vqKAHMMLULXecc79jtG6FcAzBLOoOxzq1LnZ+PYs4nHktaz14D3j9OXciGW9TjAI0IlApX6EGeTOHn5uRh+IzymaxKMZ2NDR9FIGWxvzkLNnLldg4uwKiArteqbuqQ3WhDO8JwucA5pWZY+RwyinUmgpKw6cn0O8+SO3UORETiICl6J8VQZQ8HGA9xmqyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/3/26 21:23, Mike Rapoport wrote:
> On Sat, Jan 03, 2026 at 08:36:40AM +0200, Eugen Hristev wrote:
>>
>>
>> On 12/29/25 08:56, Mike Rapoport wrote:
>>> Hi Eugen,
>>>
>>> On Wed, Nov 19, 2025 at 05:44:19PM +0200, Eugen Hristev wrote:
>>>> This memblock flag indicates that a specific block is registered
>>>> into an inspection table.
>>>> The block can be marked for inspection using memblock_mark_inspect()
>>>> and cleared with memblock_clear_inspect()
>>>
>>> Can you explain why memblock should treat memory registered for inspection
>>> differently?
>>
>> It should not, at a first glance.
>>
>> The purpose of the flag is to let memblock be aware of it.
>> The flag is there to have a "memblock way" of registering the memory,
>> which inside memblock , it can translate to a meminspect way of
>> registering the memory. It's just an extra layer on top of meminspect.
>> With this, it would be avoided to call meminspect all over the places it
>> would be required, but rather use the memblock API.
> 
> memblock APIs are not available after boot on many architectures, most
> notable being x86.
> 
> But regardless, I can't say I understand why using memblock APIs for
> meminspect is better than using meminspect directly.
> I'd imagine that using meminspect register APIs would actually make it more
> consistent and it would be easier to identify what memory is registered
> with meminspect.
> 
> In the end, memblock_alloc*() returns dynamically allocated memory, just
> like kmalloc(), the difference is that memblock is active very early at
> boot and disappears after core MM initialization.

Hi Mike,

Thanks for sharing your opinion.

David, what do you think, does it make sense to have this flag or we can
ditch it and use meminspect directly ?

Also, for some memory blocks, they do not disappear ever, e.g. the
printk log buffer, it's allocated early and never freed, so it's
required to have some memblocks marked for inspection.

Eugen

> 
>> And further, inside memblock, it would be a single point where
>> meminspect can be disabled (while preserving a no-op memblock flag), or
>> easily changed to another API if needed.
>> Ofcourse, one can call here directly the meminspect API if this is desired.
>> Do you think it would be better to have it this way ?
>>
>> Thanks for looking into it,
>> Eugen
> 


