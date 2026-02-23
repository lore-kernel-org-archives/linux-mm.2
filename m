Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865E0EC1118
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7926B0005; Mon, 23 Feb 2026 13:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985296B0089; Mon, 23 Feb 2026 13:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867016B008A; Mon, 23 Feb 2026 13:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F06B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:09:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C2278ACB4
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:09:52 +0000 (UTC)
X-FDA: 84476509824.10.1560FB8
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25786100013
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:09:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cirph6sZ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771870190; a=rsa-sha256;
	cv=none;
	b=WnUiAiZ1HIXl6zDxChfRg51yUpr5qIZ9wugGXx//OJr+zfBmOEW5xvVn2YVYEJOmX+cIYx
	lpLvnftDUg7heclpRqskBuCfwYYUSiGCX618SZuC4BtczO1AsM8k4d1DjiiWD0e820XdPP
	PvkyXgQKgnbMJgoD5ZFfF5EYwoEmjqU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cirph6sZ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771870190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8G05LLid+B1Y6OxsFG39BFRld+8LCwvvG4/myaZjVXo=;
	b=tOTLop6TDozqXp7aKJnRxsI0srGomjEHoriQkzEtFkxnMP4XbcThGaIhMfAGb33hZJ0kJ8
	BsXMPi0zFZ84ei0xL1b0fTel2dQb4cznZHWDU3aDQxs5aHXPWzmfBP7oMPNzVhbaXYRVbI
	YaenfgaVo9u1UbZktI1EM4qVHXeUvMA=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4806b8fca44so6011905e9.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771870188; x=1772474988; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8G05LLid+B1Y6OxsFG39BFRld+8LCwvvG4/myaZjVXo=;
        b=cirph6sZ9qJVQOLQ+5Elbr9gwa9cTXlWhTUCAnnTKF1ULFlWslUcBTM3TCGqgR2LRJ
         fxOmDVCeGU1hF5FdeB0ublVRpYowaF3NHo1PoEY6jjzh/ZItb7EqMDudPJy0UE6ktmSb
         KyezS8hpC3ekU8dgIsCeJbu6H/SR42aYOUCsAbJrzEtNlDJqyXlZ7zfYhGAbnjPU4d6H
         8DPOoJq3CjzBDu/KhENFvYQL0QPcI2KBOJgjL3ORvtoV8HaZBsUP6f33wJlN86A/pUJE
         6ypX5yx0Tv/yH7uvH5hITIKZ2CHpUlnkVIYcydDriJ/djs2V9C0GUdLzcR98Orx/LhTv
         oJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771870188; x=1772474988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8G05LLid+B1Y6OxsFG39BFRld+8LCwvvG4/myaZjVXo=;
        b=e/5q94dz034JccY/BtmegdHA2nfogn1e2q0pdPEOMo+IYd2T1DspcTE884UID2YeqO
         HTUxZrCxMRbJngc0BxIPLnwHS8BYr/tg4S9JkWrTD2jb2flyPXgAe8crVZ55V4VUuZZc
         N0EDr69HHq0MpizFfkS6siKs+ipa0STW/bRDrYIuw6lxGCruUEmQVdEY2foCE7e3bMtN
         7QzajxP4ykZCUX4XnIbYy6QKhceayiLQ2wh4JqzWLiRPoTwkkzN9R0LHhLdp8A+pEo6c
         Im3r58cnJQgyIy8mxFxHi6o+PXX4eYmGsYsUGHRrRThjHqX5iQaEkqQrsaR/6zE/+y5H
         uUXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVM+PZPrJzRhzcxrSLYzXqidX8DNL0Ig/JMyB5PTbYiZrRougV6mYOnwlNBV3lO9+WDLeF2ZxO7lg==@kvack.org
X-Gm-Message-State: AOJu0YwpSIzKTI6gKDhh2ztWrEe96cUHjfmFMnwQjMta1tkkdZ652PhF
	0/BOHGj6BEAycPTTqtolADoIMC4TsKs0s1jEnzPnsCZuDdmWzODNP9utq+pG+3SLyBE=
X-Gm-Gg: AZuq6aJIewuYPq3buYisIUeJTqvUt6GHvjtwogu95P7tOhKhhLnRZ6PVJpcS82z6kbp
	sFXc/3DBRB+4KDhEBTNHdr+a5ustxTObSEIzyzk9hF3eWXk8k9rQchMV0D4sGkP0GidrphE6rMS
	WRaRin1RyefmSoNHLj42QPXa1GzFNVRU/Ao3POm5xe8VXacmiGJQHZ/I7hFUSCAIRaJWDMT/c/F
	RIXOI0Ja2VTT5hji4FKdtbr6gN0kbWA88xpbLexwhxzIsV7ppKoPGAt7n9S66ObVxc3t2K70PP3
	XX6GHSqjYwXGvvr7BVEmSOpuCG8L67QwJCizgqWzFu5Hww6TkQFFLylWA+UsKAa7fh59k0Nc/sZ
	0BOEQHyJVKrSIizM6hxONlUYRufe6WUYSgyra6Q6OYbthi3dSTMKFyLTFAYM+mfZDiJKsssqe8N
	TS28ZdupMVcghX8Yz88Q==
X-Received: by 2002:a05:600c:4e48:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-483a95eb348mr98005385e9.1.1771870188427;
        Mon, 23 Feb 2026 10:09:48 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bfa015sm20581839f8f.8.2026.02.23.10.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 10:09:48 -0800 (PST)
Message-ID: <1fd2efef-888b-4d3c-9c72-bdb2d594336f@suse.com>
Date: Mon, 23 Feb 2026 19:09:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
 Frederic Weisbecker <fweisbecker@suse.de>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
 <aZiRAa6uf4KhscJC@tpad> <aZiSHT5DwIZwc/cH@tpad>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <aZiSHT5DwIZwc/cH@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 25786100013
X-Stat-Signature: bto9eot97yi6abs16ow5qtcu85pay6k1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771870189-495566
X-HE-Meta: U2FsdGVkX19d8YVxx+zPUePGoyL5gm16PKTd2k4jkoSufeMr8HtpXJVGf/1DICZKt1C6ozpf3ZoNz6qDwDuIn2fPEKWQz11Hjnxm7nw8coMj2wUGDz2LGFMekBzEu4p+jh5J/9hXmT2JstyvLbuqLoFZ68TqDcjokGjN0gtcHSzGsYmBtBFGtIfu3i6FkHl1yPY8U7Vr9P5AKn5wVKAexZoC2/PuGMPA3HBtItqeHfDb2ScZIfoPJd50cjopKOekmIsl+ApEDpgRDXELs5S5TgwVMrxfp+VrtY9AEHTX0ce9j3SEUu71StII3MKYV9cCjEytsEpAfDM+AP5UG1VHKEzH6aCVpgZFNTXOJqQvjl82xtxL//hpSso5z6TQe4G4HBE79D513HMxYUUVA1OwatiCyV2mGccn2EBheetAJpcldFlY12XdFPyCbwBpcoLipQUodCiL5YYXnWheHhrQ77GixFD2BjmTvO9Ze3hcwloTjLhG3focSBk2ikmHOh8i6Siw4hX4phWp74BUpd1NGSZ6tAvhO0gv9E2QJrDoek6+4pYs07qk63e7ItG4Dq2t/oE5z14gQig305/nTTnZNlAuqbeFQyMOf61PmJDsUJzcptoAm6CHUBTCPJaFoef8cCUBUhFCdTz2c0h232CuZTNBpYUXF4SqColiBIOI4MKlOR8rJKsTW9uZqk+nBkWYUa+CzdQO8AibVEjsVWyEsJbNmE8Wj1DHvWPPsd3XVin4yAjhrgNGF98gTfR9VNc+cu84QGkK9TaI2qxG2kYRAysJp08kHcvx+x0za/iko7Gzzim2Sjuy592Eqtoht/0GWdEVCwOW+s2QiTsVwUxgqFUevBgwmZAWj3bWz6LWaD+NiwZHRzubDNmw7VsPf8nan+9oT7+2sntX4bzgsu9BO7ypI5b1UNf6mFB9WAHrc1H989Y8Be1GORJnJYDdxUGtj78WxcMpc1kYmE1qIzv
 +TTVFWK1
 awiofVSCkGswcn5NGkafEcOYyuMn9FYCv06BUR1EcMojAWddvhnQRhT1yGU1Epq+FV7diHJBJCJVz3Ht6QMsazn1t73Hg12ERM7M78Wv7KKf1D2rLfB/scOYVkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 17:55, Marcelo Tosatti wrote:
> 
> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/slab.h>
> #include <linux/timex.h>
> #include <linux/preempt.h>
> #include <linux/irqflags.h>
> #include <linux/vmalloc.h>
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Gemini AI");
> MODULE_DESCRIPTION("A simple kmalloc performance benchmark");
> 
> static int size = 64; // Default allocation size in bytes
> module_param(size, int, 0644);
> 
> static int iterations = 1000000; // Default number of iterations
> module_param(iterations, int, 0644);
> 
> static int __init kmalloc_bench_init(void) {
>     void **ptrs;
>     cycles_t start, end;
>     uint64_t total_cycles;
>     int i;
>     pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);
> 
>     // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
>     ptrs = vmalloc(sizeof(void *) * iterations);
>     if (!ptrs) {
>         pr_err("kmalloc_bench: Failed to allocate pointer array\n");
>         return -ENOMEM;
>     }
> 
>     preempt_disable();
>     start = get_cycles();
> 
>     for (i = 0; i < iterations; i++) {
>         ptrs[i] = kmalloc(size, GFP_ATOMIC);
>     }
> 
>     end = get_cycles();
> 
>     total_cycles = end - start;
>     preempt_enable();

While preempt_disable() simplifies things, it can misrepresent the cost of
preempt_disable() that's part of the locking - that will become nested and
then the nested preempt_disable() is typically cheaper, etc.

Also the way it kmallocs all iterations and then kfree all iterations may
skew the probabilities of fastpaths, cache hotness etc.

When introducing sheaves I had a similar microbenchmark, but there was
different amounts of inner-loop iteraions, no outer preempt_disable(), and
linear vs randomized array. See:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/commit/?h=slub-percpu-sheaves-v6-benchmarking&id=04028eeffba18a4f821a7194bc9d14f7488bd7d9

(at this point the SLUB_HAS_SHEAVES parts should be removed and the
kmem_cache_print_stats() stuff also shouldn't be interesting for QPW
evaluation).

> 
>     pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
>     pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);
> 
>     // Cleanup
>     for (i = 0; i < iterations; i++) {
>         kfree(ptrs[i]);
>     }
>     vfree(ptrs);
> 
>     return 0;
> }
> 
> static void __exit kmalloc_bench_exit(void) {
>     pr_info("kmalloc_bench: Module unloaded\n");
> }
> 
> 


