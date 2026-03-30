Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB5BFB3D00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE816B0096; Mon, 30 Mar 2026 06:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5C16B00A5; Mon, 30 Mar 2026 06:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBA36B00B4; Mon, 30 Mar 2026 06:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6F06B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:25:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4A8F16064C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:25:28 +0000 (UTC)
X-FDA: 84602347536.25.3DB2B07
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id AF1AE12000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:25:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AfkKqhTz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of jbeulich@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jbeulich@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774866326; a=rsa-sha256;
	cv=none;
	b=Bw34fwKz4ihXQpmPZnduJeegwOqEH/MYkIVAsMSQ1wVYRE/vEOsVwBuEiMXMKjPg9wScLV
	4es5DZKjQdgAWvAJJaIJRaQhjpqWyfGAxsgX9GeEFLLjjKKEaWpVveGPQUp01/sM4ZEzJA
	CaGk4q8AoVeoJc4RVPlzFAb0eKEReeI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AfkKqhTz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of jbeulich@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jbeulich@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774866326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bk9iPA4aEAPWdzSPecO+wqcTKPBLIZIOOXlz3adrPoA=;
	b=0xlkhlFzoII2P5FXCFENP8MjH7xtTQ27RmGX/KWoiQXBPkbpXrHAuqauIrNsQeV1/RIX/p
	Wpw5b7QFbgwGVfjzdIfZIhP9EN72i8nrtx+dfFvpqRZTblkOEfydIuMur6G6BI5haphzaV
	hyAZufbT3waa4HPVovc3CVadD8D14Ag=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-487035181a7so28293015e9.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774866325; x=1775471125; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:cc
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Bk9iPA4aEAPWdzSPecO+wqcTKPBLIZIOOXlz3adrPoA=;
        b=AfkKqhTzvF21S7ss2LWHDS1euom/b3p6Do+j+e9qlAfIOKvutBytPqNDpQUo5KQu15
         rVpXAZStCzF/UUt/NOeRgS+VopipjqSwRq2iPvMF5aGZtt0cv5ryqhHDsNuo5gsqvBAQ
         oBkPaEz4PaSYxROf+pGI0msYqIxWg82zyvB6H2U5T461P7ISlO/FBRCvPE+WWFflnTu0
         l212uCEtvTG8tgR9hHuiPIgNqjjRUY/rbSQYmb1U4L84AaGz/9UoLEBn9YcYL7HxVrum
         4v+KL/rT43awAsYeUfZKjDz1wHhsOrenkBNOkDW9a3zIF0kMCo85GfHjzaw4UQ0EUZdp
         3MRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774866325; x=1775471125;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:cc
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bk9iPA4aEAPWdzSPecO+wqcTKPBLIZIOOXlz3adrPoA=;
        b=l0Qx4vvJ8duyiqit+SJdTbsAUvlXrj3LzodL8Hje9p6ZYOWyHnM2gOgeWQqWLaK4MN
         OZ7y70G3TgF7kfELAxqagF0YhE8VJzhonqGN4QZUQZe3NbsKcrxch2GLJuAgbP2+yrEi
         0nV8meD8MCR7q2VFvf2Bo3ZjDC1ToE/NHagAVj+qNTBeLj3AVs+CZj9zthRxilwj6+AC
         csvsbzD4usReGkPrWNqKmPP9gef7xnLGko+LIrGbyntUXsZPYSUQ4/AKloMt9xINqMNJ
         tg5W/MleYE/+MMMlQ3FpD3o5M40Pvovv+gYrjdwEsQAQtQCoE75P+sAo7A/HJSjMb0G3
         8Zrw==
X-Forwarded-Encrypted: i=1; AJvYcCV9kZFls67Kr7PKqTmPin22o+wT7BDATZwXUiLbJ+FnHy7APc0ZjmW/wqOXfYKh2ksw9v9tdYUPaA==@kvack.org
X-Gm-Message-State: AOJu0YzSKEBKKDFY7rV9I6sTrF5a8lZlD15qh//7LtxXuwD5SmggF05w
	F2ZsPfdxxa63uVZ9yXwl/KZzK7CWnBsTqJcil6yNfQBY6z9AS7Sh4onX4PgRFAcGKQ==
X-Gm-Gg: ATEYQzxRawoNRKQJSxvTpQNkoEAGUBM53npiOOYxkypGTq/f1G1WD9aStkqXMHtpFl7
	jDUSxRuCuYrgRgUR0QUZwVNrGtnQIGJO3T3DilbDbOPheyA4vuxeCu5EZx4+GWAoHWoJ1vZ0bBF
	gMYKlmt7yBOpqJuM3ch0zRfg50Ws/R37tr4eQOqCZVMJfjzsNWwlNrgsv2JQgoRRYw7/dzMWI1n
	PfwB66VYTE7EReF6hNEWeK9QPLbyC7tUEKXVQyrlNPRPJEXE0RiIYsEOdXnXg3Zq4nVWqnJd6b3
	Jv9KdXzKISqc/eCcWpRHUR86eRvDS7CYZTac3yAcaTFnivltXrPT1zTFgMNjuMtz3gNL+qXbYsJ
	+l8+jfNR9iYbsRtUMo2eP3NepZ+rmYrxU7NcjuQLfUOe/H857tfb62/Gb2QDeJeBV/9Wb6xalMm
	fnI5eki1+3bKipcb+yGBsqkw+1aQz+XsUo2Owd2OBU6+GvVKLu6GWpPbCXexNpeQYF7FDgOe/xq
	8KPhTwTCw9LJp4=
X-Received: by 2002:a05:600c:a408:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-48727d735a7mr152106215e9.8.1774866325041;
        Mon, 30 Mar 2026 03:25:25 -0700 (PDT)
Received: from [10.156.60.236] (ip-037-024-206-209.um08.pools.vodafone-ip.de. [37.24.206.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487270e7248sm123961175e9.6.2026.03.30.03.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 03:25:24 -0700 (PDT)
Message-ID: <cf54e793-63d6-417c-b7c5-3301455fcf33@suse.com>
Date: Mon, 30 Mar 2026 12:25:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Why memory lending is needed for GPU acceleration
To: Teddy Astie <teddy.astie@vates.tech>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
 <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
 <ce114f02-f45e-4638-84ee-a8fd86ce1c5d@vates.tech>
Content-Language: en-US
Cc: Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Val Packett <val@invisiblethingslab.com>,
 Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>
From: Jan Beulich <jbeulich@suse.com>
Autocrypt: addr=jbeulich@suse.com; keydata=
 xsDiBFk3nEQRBADAEaSw6zC/EJkiwGPXbWtPxl2xCdSoeepS07jW8UgcHNurfHvUzogEq5xk
 hu507c3BarVjyWCJOylMNR98Yd8VqD9UfmX0Hb8/BrA+Hl6/DB/eqGptrf4BSRwcZQM32aZK
 7Pj2XbGWIUrZrd70x1eAP9QE3P79Y2oLrsCgbZJfEwCgvz9JjGmQqQkRiTVzlZVCJYcyGGsD
 /0tbFCzD2h20ahe8rC1gbb3K3qk+LpBtvjBu1RY9drYk0NymiGbJWZgab6t1jM7sk2vuf0Py
 O9Hf9XBmK0uE9IgMaiCpc32XV9oASz6UJebwkX+zF2jG5I1BfnO9g7KlotcA/v5ClMjgo6Gl
 MDY4HxoSRu3i1cqqSDtVlt+AOVBJBACrZcnHAUSuCXBPy0jOlBhxPqRWv6ND4c9PH1xjQ3NP
 nxJuMBS8rnNg22uyfAgmBKNLpLgAGVRMZGaGoJObGf72s6TeIqKJo/LtggAS9qAUiuKVnygo
 3wjfkS9A3DRO+SpU7JqWdsveeIQyeyEJ/8PTowmSQLakF+3fote9ybzd880fSmFuIEJldWxp
 Y2ggPGpiZXVsaWNoQHN1c2UuY29tPsJgBBMRAgAgBQJZN5xEAhsDBgsJCAcDAgQVAggDBBYC
 AwECHgECF4AACgkQoDSui/t3IH4J+wCfQ5jHdEjCRHj23O/5ttg9r9OIruwAn3103WUITZee
 e7Sbg12UgcQ5lv7SzsFNBFk3nEQQCACCuTjCjFOUdi5Nm244F+78kLghRcin/awv+IrTcIWF
 hUpSs1Y91iQQ7KItirz5uwCPlwejSJDQJLIS+QtJHaXDXeV6NI0Uef1hP20+y8qydDiVkv6l
 IreXjTb7DvksRgJNvCkWtYnlS3mYvQ9NzS9PhyALWbXnH6sIJd2O9lKS1Mrfq+y0IXCP10eS
 FFGg+Av3IQeFatkJAyju0PPthyTqxSI4lZYuJVPknzgaeuJv/2NccrPvmeDg6Coe7ZIeQ8Yj
 t0ARxu2xytAkkLCel1Lz1WLmwLstV30g80nkgZf/wr+/BXJW/oIvRlonUkxv+IbBM3dX2OV8
 AmRv1ySWPTP7AAMFB/9PQK/VtlNUJvg8GXj9ootzrteGfVZVVT4XBJkfwBcpC/XcPzldjv+3
 HYudvpdNK3lLujXeA5fLOH+Z/G9WBc5pFVSMocI71I8bT8lIAzreg0WvkWg5V2WZsUMlnDL9
 mpwIGFhlbM3gfDMs7MPMu8YQRFVdUvtSpaAs8OFfGQ0ia3LGZcjA6Ik2+xcqscEJzNH+qh8V
 m5jjp28yZgaqTaRbg3M/+MTbMpicpZuqF4rnB0AQD12/3BNWDR6bmh+EkYSMcEIpQmBM51qM
 EKYTQGybRCjpnKHGOxG0rfFY1085mBDZCH5Kx0cl0HVJuQKC+dV2ZY5AqjcKwAxpE75MLFkr
 wkkEGBECAAkFAlk3nEQCGwwACgkQoDSui/t3IH7nnwCfcJWUDUFKdCsBH/E5d+0ZnMQi+G0A
 nAuWpQkjM1ASeQwSHEeAWPgskBQL
In-Reply-To: <ce114f02-f45e-4638-84ee-a8fd86ce1c5d@vates.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF1AE12000A
X-Stat-Signature: uogpz1fup36kcq44nxhwn5jwqrmf3sxw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774866326-567473
X-HE-Meta: U2FsdGVkX1+cRkF5qNEgi5C0R2D1QaB2LfiYT3zAnM9lRTmawka7LAeYw9jpPRpN+7zY1lKBDnkN50I+wivUHuse23tSB/0w47GvEBvcaEBNO8+KV25EAbmhhniXkXIFVgoppIwdxvdeW2GDiSMphf5ycjzLjO9q02femImFZcCUsQBKwvPHBtEyHZuvnb4mLOu44geoLpg2kOEf74k6f6MqHqJ56OE4mWktdQmOoOEuNczNcN0xqgaTLtySqim7/NMWDfEKO0u8xXytVnc7GpqYt4IsnDYHq9Q3mOkR/0MtiVC71cNIYXwqE+3fZbZYlIL/iGs4pXg3bC09ozCVGleJj2g8f1fjIvX0caL01mVgdTpQlMVcL/h0AeqQ5Axe4kfWvws36Ya72wFDAg0Hrl1Ook0MRcDqDEXv0TRhYILUynAEVVGmgxI/FvShJl4zUjkEMUyH/c/EsrtTPCTTv8qp5cvdywARktsZwNJdiouZouF1GloHeC/kis2LD86bobtw8PmCVNnqZu7jakEwKrh/+eyjUTe9G7SHBS7gZF832C7tBYfUMjRcKhe0gbgt1DTKR+DUl1OzPIb6XorNkmZAIy3HftQxYMdf6RuIY7ioBhp0YxHgN5y28dZx8PiUJ9uNu20+SHmlRyaR3o1dt6YKj0FBPWYbDjTSOMOvpcOsLM84HPZVOk6NdgyOksrL+btjJBGrQBaAXohfeR4DzO3DPrI0nkgmsNB9U1OUeJaoLpJCwrzKwU/tfNymbfKCstu8YjHtoJrbbe4AJiyIDm+jbYfkTy+u2z9NU3x1nPZSDmoUbqnU+Egj+KTLRY8DOHtGpejt5gDfY4IhW8Tkka31oRTNcwdcr2LrA9NPMPJuwik3Er6YXOB/0aach78G6o9YdRi+CwG94l9w2zQGT6cSz+TPVCYkiW30EZWLUrQSbOcKFGvzw9dVcQ6mQsURw8ceoJIxxypC74R6moe
 MBEJHapm
 YYNCoXUZTvUFIVd0dUV11AFFMu3f1V1iAug/dp3ws04bJZ8x+Z/6Fzm9/KDbRwJA97nfoiX9P2tBpVOgP3z1U1P0NFmdcHtHN5yH/KN0LKGvnr4DAuqnkpXMxXfJcHxCezzXCtgi0FT/IvH78eK+1HkVOin4xc+m6iq/QE8tUYEu34WbI3IGGenLevGh5vNSqm8sSkqV9anW2Dv/2dI+3bXUYNS+HwVkZqX50V68wHcdxFqEatX5emOmXt5t/L92by/4y9tL9rYud+5eCPOCkSSkxY6ZgGPu33K6tz4yhlsUb80DbWry+6zYv1/5IFhYoTniplF5YdG5yhH2YG0+713NT1D5oTbPZseAttRdIhg84V6zZ6azhvHhsxztYj0xpwh9H8O/EwSV0I+w1QQxhKlhOKHEPzUJPtfsrX//NzaoV4J8K8/m1ap6QiV3RRbQFa+OZmQOG2w2Sn/9yXAZWVVhJLxNVtSYIFkWV88ByoHekpBjDOdKC/5ljQR1nEf4deQFoU7zM4Mud3633SauP2K6ReA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.03.2026 12:15, Teddy Astie wrote:
> Le 29/03/2026 à 19:32, Demi Marie Obenour a écrit :

May I ask that the two of you please properly separate To: vs Cc:?

Thanks, Jan

>> On 3/24/26 10:17, Demi Marie Obenour wrote:
>>> Here is a proposed design document for supporting mapping GPU VRAM
>>> and/or file-backed memory into other domains.  It's not in the form of
>>> a patch because the leading + characters would just make it harder to
>>> read for no particular gain, and because this is still RFC right now.
>>> Once it is ready to merge, I'll send a proper patch.  Nevertheless,
>>> you can consider this to be
>>>
>>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>>
>>> This approach is very different from the "frontend-allocates"
>>> approach used elsewhere in Xen.  It is very much Linux-centric,
>>> rather than Xen-centric.  In fact, MMU notifiers were invented for
>>> KVM, and this approach is exactly the same as the one KVM implements.
>>> However, to the best of my understanding, the design described here is
>>> the only viable one.  Linux MM and GPU drivers require it, and changes
>>> to either to relax this requirement will not be accepted upstream.
>>
>> Teddy Astie (CCd) proposed a couple of alternatives on Matrix:
>>
>> 1. Create dma-bufs for guest pages and import them into the host.
>>
>>     This is a win not only for Xen, but also for KVM.  Right now, shared
>>     (CPU) memory buffers must be copied from the guest to the host,
>>     which is pointless.  So fixing that is a good thing!  That said,
>>     I'm still concerned about triggering GPU driver code-paths that
>>     are not tested on bare metal.
>>     
>> 2. Use PASID and 2-stage translation so that the GPU can operate in
>>     guest physical memory.
>>     
>>     This is also a win.  AMD XDNA absolutely requires PASID support,
>>     and apparently AMD GPUs can also use PASID.  So being able to use
>>     PASID is certainly helpful.
>>
>> However, I don't think either approach is sufficient for two reasons.
>>
>> First, discrete GPUs have dedicated VRAM, which Xen knows nothing about.
>> Only dom0's GPU drivers can manage VRAM, and they will insist on being
>> able to migrate it between the CPU and the GPU.  Furthermore, VRAM
>> can only be allocated using GPU driver ioctls, which will allocate
>> it from dom0-owned memory.
>>
>> Second, Certain Wayland protocols, such as screencapture, require programs
>> to be able to import dmabufs.  Both of the above solutions would
>> require that the pages be pinned.  I don't think this is an option,
>> as IIUC pin_user_pages() fails on mappings of these dmabufs.  It's why
>> direct I/O to dmabufs doesn't work.
>>
> 
> I suppose it fails because of the RAM/VRAM constraint you said 
> previously. If the location of the memory stays the same (i.e guest 
> memory mapping), pin should be almost "no-op".
> 
> (though, having dma-buf buffers coming from GPU drivers failing to pin 
> is probably not a good thing in term of stability; some stuff like 
> cameras probably break as a result; but I'm not a expert on that subject)
> 
>> To the best of my knowledge, these problems mean that lending memory
>> is the only way to get robust GPU acceleration for both graphics and
>> compute workloads under Xen.  Simpler approaches might work for pure
>> compute workloads, for iGPUs, or for drivers that have Xen-specific
>> changes.  None of them, however, support graphics workloads on dGPUs
>> while using the GPU driver the same way bare metal workloads do.
>>
>> Linux's graphics stack is massive, and trying to adapt it to work with
>> Xen isn't going to be sustainable in the long term.  Adapting Xen to
>> fit the graphics stack is probably more work up front, but it has the
>> advantage of working with all GPU drivers, including ones that have not
>> been written yet.  It also means that the testing done on bare metal is
>> still applicable, and that bugs found when using this driver can either
>> be reproduced on bare metal or can be fixed without driver changes.
> 
> One of my main concerns was about whether dma-buf can be used as 
> "general purpose" GPU buffers; what I read in driver code suggest it 
> should be fine, but it's a bit on the edge.
> 
>>
>> Finally, I'm not actually attached to memory lending at all.  It's a
>> lot of complexity, and it's not at all similar to how the rest of
>> Xen works.  If someone else can come up with a better solution that
>> doesn't require GPU driver changes, I'd be all for it.  Unfortunately,
>> I suspect none exists.  One can make almost anything work if one is
>> willing to patch the drivers, but I am virtually certain that this
>> will not be long-term sustainable.
>>
> 
> There's also the virtio-gpu side to consider. Blob mechanism appears to 
> insist that GPU memory to come from the host by allowing buffers that 
> aren't bound to virtio-gpu BAR yet (that also complexifies the KVM 
> situation).
> 
> You can have GPU memory that exists in virtio-gpu, without being 
> guest-visible, then the guest can map it on its own BAR.
> 
>> If Xen had its own GPU drivers, the situation would be totally
>> different.  However, Xen must rely on Linux's GPU drivers, and that
>> means it must play by their rules.
> 
> 
> 
> 
> --
> Teddy Astie | Vates XCP-ng Developer
> 
> XCP-ng & Xen Orchestra - Vates solutions
> 
> web: https://vates.tech
> 
> 


