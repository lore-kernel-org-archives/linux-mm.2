Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB98CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 07:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FFB8E0018; Thu, 21 Aug 2025 03:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7CD8E0002; Thu, 21 Aug 2025 03:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824F48E0018; Thu, 21 Aug 2025 03:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72D948E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 03:23:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 165F71162D2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:23:55 +0000 (UTC)
X-FDA: 83799925230.04.20A93D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0F0231C0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:23:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755761033; a=rsa-sha256;
	cv=none;
	b=CHor2zmyHRKiw+jOPhsBmoU/kUWVR9N/5vtKSomBpI7jk0txCJjYU1O9YXfKpTx1PONgya
	VvGztcqLnx48fd+GFTBH+9Hzdd/CI18aKGITIVc86zJO6ZwgfDBI0qqkRWzjyeqFMTMh3p
	CMoz0+bcToJA6+8Uv0Lqfrtoe9iCu9k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755761033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X64IdBmjHXhS6gvtudLgoG6tBJL+bVjtjgEiJHPyTrg=;
	b=FU4CC+J7l8Ghk95hyfdIgsDtqMK32+jZrtl7xD2gisbK3IZeSnZILFHlEtPQYUEQ6oBoi1
	fjBLvHiTbM58TItHp6OZlkASSg+9geUJkftvbw8LCrUx4HHiKIxv4MFADSOyXYJpL8BbP9
	s+764PCPyomvEU0gnmFPJklF9Jwja24=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A871168F;
	Thu, 21 Aug 2025 00:23:43 -0700 (PDT)
Received: from [10.57.91.165] (unknown [10.57.91.165])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C45A3F58B;
	Thu, 21 Aug 2025 00:23:45 -0700 (PDT)
Message-ID: <09873338-574e-43e4-a6ff-590a3c9a9e87@arm.com>
Date: Thu, 21 Aug 2025 09:23:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Cc: "maz@kernel.org" <maz@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "mbland@motorola.com" <mbland@motorola.com>,
 "david@redhat.com" <david@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "joey.gouly@arm.com"
 <joey.gouly@arm.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "pierre.langlois@arm.com" <pierre.langlois@arm.com>,
 "jeffxu@chromium.org" <jeffxu@chromium.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "kees@kernel.org" <kees@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "jannh@google.com" <jannh@google.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "qperret@google.com" <qperret@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "broonie@kernel.org" <broonie@kernel.org>, "x86@kernel.org" <x86@kernel.org>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <4a828975-d412-4a4b-975e-4702572315da@arm.com>
 <5b5455eb-e649-4b20-8aad-6d7f5576a84a@arm.com>
 <3c18d1f1e94d3491410168e37cdf67e9e471649e.camel@intel.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <3c18d1f1e94d3491410168e37cdf67e9e471649e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F0231C0003
X-Stat-Signature: yx1tn8q58b8rfbmy7b43u6d5amfxy4yu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755761032-148766
X-HE-Meta: U2FsdGVkX191rClPCWauQ8L5wytoJhP8ePcv88iwPDB5QfYw4D9cWstVOcKb14e61KRpzNH0IL9WhDDpwpHviJzqNorTu1z8ihL1F9EcgkZfJsROeAYT41LjiAw9pHLZCjjAwOA4JNAsmzX2XBMGVlviOk/9t9jSZXN+GNac1sAx+WCGXAB3y/waWLQsPQO8rMZphxmcC8fQSG12qr+8M3G8LJjB9tWC89YS3YY5ZC5pokJZXMiGsj8WfBYtZUcZq6VJqhxHPuZYA+WVoUJg0LKO4Nt2wSHh/E6Qy3sC0ppAn4+PTsHZbfEaK9exgse+shuPRucZslqkVQ/ScY5X/N4ZeCAILJ2vYVwDHZ/9zkrZLZ3S5jOIJi2bm2028zURQVnxq0bhu8wjlr6ZxHNe6Y4gP9p/KJVWJ+PhUGV/azvQEZBtWcPY+JtcfVyXbRq6ukgmTemIIjbE8ImYRcKDCLZ+HXnDQ8wdl4OORfSfktgSJ2fEYrDfewthr1BU06HFabtOLmDZoBMIqqHhnBZQ8hA+RCaJoAlcRqvZn56mR98FI6YxOrXGhgScdAdvYRz5uB+JPYWp4QNUrjzkU34iqbLW/f/HbW6xYeDpq7y10qB5NNvWqzN+ti1X6erkUp37EfqsRNF0qPEHFeKykEPALRVIIiQdXBYPZlCtLqaVQBoeH/loEfvDS56HPYgBytdlbxmNSZ1CDbiTIl4DJ2YX6AIIx6JbTtWEgVFenyTFcocE2gp5wwXvvrc7UwIEJ7NttMo26TVBZeBTTWB133IBlEmWsELc4/F/dVQ+fnfd8c3S27aAvPqE8u9FpoZo8OQZrj/1yC8DYtmWKpNZrlG1W03tPEjlpI3qJe3ly+9qRwFnkvxVizVzhNHyrozfxRmSo7WOyGAvi1OUnFcyY6O2qDgEvlgNEs77CYJBL3q2KOObPmBF2VtfLQSGz8qTpWXsq0Y4SWzAEkz3Epss5mi
 VrYwylE4
 KljRYJfmJ2ILsUSaaUJglhQi5P6iy9EcKNiMQ4TE2XRfIHLCuTF0wBrUl6NwkG6w9AFrCAZEZ6l0BYNnx1ap9VsrO34sngVGgrW5C22G8LjU/b5NtjYL7JvGVrEi59r5LSK8lfxt/53gtpXVHjnnTHBCgpEBzboPS8f480ujOrkEQnYA8a3BJoyfFrgsazwAnL3pnlLVZ2vsfDkkNR99r+Y5YGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/08/2025 18:18, Edgecombe, Rick P wrote:
> On Wed, 2025-08-20 at 18:01 +0200, Kevin Brodsky wrote:
>> Apologies, Thunderbird helpfully decided to wrap around that table...
>> Here's the unmangled table:
>>
>> +-------------------+----------------------------------+------------------+---------------+
>>> Benchmark         | Result Class                     | Without batching | With batching |
>> +===================+==================================+==================+===============+
>>> mmtests/kernbench | real time                        |            0.32% |         0.35% |
>>>                    | system time                      |        (R) 4.18% |     (R) 3.18% |
>>>                    | user time                        |            0.08% |         0.20% |
>> +-------------------+----------------------------------+------------------+---------------+
>>> micromm/fork      | fork: h:0                        |      (R) 221.39% |     (R) 3.35% |
>>>                    | fork: h:1                        |      (R) 282.89% |     (R) 6.99% |
>> +-------------------+----------------------------------+------------------+---------------+
>>> micromm/munmap    | munmap: h:0                      |       (R) 17.37% |        -0.28% |
>>>                    | munmap: h:1                      |      (R) 172.61% |     (R) 8.08% |
>> +-------------------+----------------------------------+------------------+---------------+
>>> micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |       (R) 15.54% |    (R) 12.57% |
> Both this and the previous one have the 95% confidence interval. So it saw a 16%
> speed up with direct map modification. Possible?

Positive numbers mean performance degradation ("(R)" actually stands for
regression), so in that case the protection is adding a 16%/13%
overhead. Here this is mainly due to the added pkey register switching
(+ barrier) happening on every call to vmalloc() and vfree(), which has
a large relative impact since only one page is being allocated/freed.

>>>                    | fix_size_alloc_test: p:4, h:0    |       (R) 39.18% |     (R) 9.13% |
>>>                    | fix_size_alloc_test: p:16, h:0   |       (R) 65.81% |         2.97% |
>>>                    | fix_size_alloc_test: p:64, h:0   |       (R) 83.39% |        -0.49% |
>>>                    | fix_size_alloc_test: p:256, h:0  |       (R) 87.85% |    (I) -2.04% |
>>>                    | fix_size_alloc_test: p:16, h:1   |       (R) 51.21% |         3.77% |
>>>                    | fix_size_alloc_test: p:64, h:1   |       (R) 60.02% |         0.99% |
>>>                    | fix_size_alloc_test: p:256, h:1  |       (R) 63.82% |         1.16% |
>>>                    | random_size_alloc_test: p:1, h:0 |       (R) 77.79% |        -0.51% |
>>>                    | vm_map_ram_test: p:1, h:0        |       (R) 30.67% |    (R) 27.09% |
>> +-------------------+----------------------------------+------------------+---------------+
> Hmm, still surprisingly low to me, but ok. It would be good have x86 and arm
> work the same, but I don't think we have line of sight to x86 currently. And I
> actually never did real benchmarks.

It would certainly be good to get numbers on x86 as well - I'm hoping
that someone with a better understanding of x86 than myself could
implement kpkeys on x86 at some point, so that we can run the same
benchmarks there.

- Kevin

