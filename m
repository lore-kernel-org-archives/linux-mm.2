Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1AFD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630376B0006; Mon, 15 Dec 2025 04:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9836B0007; Mon, 15 Dec 2025 04:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481526B0008; Mon, 15 Dec 2025 04:22:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 345946B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:22:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBDC813C4A1
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:26 +0000 (UTC)
X-FDA: 84221164692.19.35E6AF5
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id E436C180013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ABzS0OGv;
	spf=pass (imf24.hostedemail.com: domain of 3T9M_aQgKCEYriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3T9M_aQgKCEYriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765790545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRgk/jKyq3Xc+z294BSrYdB5EGZbteu2gYXGFcGqquw=;
	b=6uO8A3trUcYxHGBORiyKED22HLGYYEoSXakyGXUY3tfLlfmhYVLG/QwBJHVqIPhXOPyjuP
	wpXsb7pgQ3u7KI4Sv8qnlFiyz9Ov3reNVyqmlF++dkJ6j8J4Y8FBAWsMKnYxLAenOCP0tK
	jIO/w2G6+EqwpxrFofb4U99PBLEWzZA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ABzS0OGv;
	spf=pass (imf24.hostedemail.com: domain of 3T9M_aQgKCEYriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3T9M_aQgKCEYriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765790545; a=rsa-sha256;
	cv=none;
	b=Tb/1FgbnsCv7xM7dY/rQHU3zz6jHlyh4w9bcC5efkF2OrO98WwQs6li6OFiy4mIWZMXWiP
	A2WkKvG/1EuXbIxUIv/NSoe6PUIpXBMG08Wmy2pwsLgLTtkJhn4tEE+SjzN/wBD0XeRyLA
	lt4jvwmaLMWi/qslvA1+uNkk/kOM1fs=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6495cc3e622so3896141a12.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765790543; x=1766395343; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rRgk/jKyq3Xc+z294BSrYdB5EGZbteu2gYXGFcGqquw=;
        b=ABzS0OGvD5JvsnB0Efs+UBdH4pN1RqdKrI0odNTHxXZbSsgVs2NvMbM3I9l3sky4Py
         qPX4qlYNWCjZ2xN2jgw+Zdlv6YAmsPGwGO7l8hSUTd230TfQ4futI2g0SQhJuzclsZdl
         ai/4h2PnE/K8iqCKn2C756xaamnAvQvYNsql3AbqtF/8BjgLzPQt1rB5E4xtbwv1xdlI
         bRcD8yoAUxdqBVC0kb2YRTUAfd8HDFS/uQ93aNHPoiS0l2sw4iA+mB3+K2saoWXsE+HT
         4OUkArNq/PueU08ZK1C9bKBBqO22HL37UdnGtgI0Sh/CX7f/AKhy6JuA4VI1Ca4LgyZD
         81Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765790543; x=1766395343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRgk/jKyq3Xc+z294BSrYdB5EGZbteu2gYXGFcGqquw=;
        b=VCLyRq/PNMprLwrnCVAzJqaGw0n9m3InB2KMI6Qi2S/OiHfPhSZzV/OePVwBulAVkX
         RPZRc13B2Tj5M6iBoMhXrl3ZS1V9EBHirchN43xY7W1u6ACjHGimuUkiHuVDynvPMX2E
         pWX8DHBRTFEHG+Kori8LMOPuJaRfdYtxkwiSCkFenbCyZUyHEk0sf9s0O8RHe0SYRKx+
         PyPAoIKG6b9lYNWO6sFXftec5S+1N43V0BDAFGe3M40jNoCCPIErBHuVjyYD9PDX8bYE
         ClpgK0lYUvK9/PGMkispG4UBYeBBD2KT3rVzMda9pktwtg2D++JnWQNGWRd1N722UpwQ
         UKqA==
X-Forwarded-Encrypted: i=1; AJvYcCXrv+gG0Izs7d73VCHm7nujsP1FPVMsx42ngHjy+Q0VzU1g9iJaWWtMn8+XoP9JVvLVnGyK5wK92Q==@kvack.org
X-Gm-Message-State: AOJu0Yzxc1MiWhX7y+Z0Pzfv/ZQXh9xV1NsfJ170QlxVMFwuTxGB+pvj
	PdjRC/O/ItI5bAdKmFygbOKLSuCxDwcg7uGU8oAKuXb+gmhri40m0LbXNTQ3GRsvHs08GvmK7fD
	lqBzaIsw2LxleeA==
X-Google-Smtp-Source: AGHT+IGqA6/7NhdOmRJlayZuRkq/89Snr/0cKuIgnNpYQ1catSJLJfZQNQG1cjXYcwltRqxHcaD6SGiYTjuK7g==
X-Received: from edbdy7.prod.google.com ([2002:a05:6402:31e7:b0:649:8456:d4bf])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4312:b0:649:62e1:10ca with SMTP id 4fb4d7f45d1cf-6499b1d86bfmr9525174a12.27.1765790543128;
 Mon, 15 Dec 2025 01:22:23 -0800 (PST)
Date: Mon, 15 Dec 2025 09:22:22 +0000
In-Reply-To: <aT5/y3cSGIzi2K+m@e129823.arm.com>
Mime-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com> <aT5/y3cSGIzi2K+m@e129823.arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
From: Brendan Jackman <jackmanb@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, Brendan Jackman <jackmanb@google.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <martin.lau@linux.dev>, 
	<eddyz87@gmail.com>, <song@kernel.org>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jolsa@kernel.org>, <hannes@cmpxchg.org>, 
	<ziy@nvidia.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, 
	<rostedt@goodmis.org>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<ryan.roberts@arm.com>, <kevin.brodsky@arm.com>, <dev.jain@arm.com>, 
	<yang@os.amperecomputing.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, 
	<linux-rt-devel@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yenwq8q4pfxwtrp6q1jnzeq168edj945
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E436C180013
X-HE-Tag: 1765790544-713481
X-HE-Meta: U2FsdGVkX19v69fts93wdASjHq7tiimvh43NSCO+1Mef9iwqy/qxqw0otFdU4Bka3nzA7GBwhVyqth4nyEzzXWBrsyf57/rveKc3wx6j9XgYgB1fMKxLKtnNGpmuLgFiWPNucbBtGGcjQCV0GOjCj1FbmmDtYsFOB75Y89RecZyS7jKepCP4tc1fYyPc46SEqCmwtlJy3u03KbTRrv+UaqzBm/6DwvVsYvgO+G+8lLTaEDBOZSDineFK5qvEZfhBYRkwQwZGROrXI8K+jg5duTHs9CNXu9f1V3q/TtFApt+EnnMEHfL44hpU891BZ8ppH0tntviHcig2QnR+6klqLcbgyxixlkN5iCzqo5+CJBFDxH3Yg5xZUmGMfYf546sZBvMtaU5dPt+xy+Q3n5B0+jqrvwchkvwLPyGZuNOTNc5hjHrGOZIcKyizfW3ptv0XhiChYm8IrfCANKfy5JkHeb+b4/yj9X5llQ1V6IbMse9B1zUMNw8jhtQ123NI6vXfEKVNO6Eok5ayUX0h06H4v2l4TgPbidrTspXAiB4fFO+1JeKbAyKnlY3nSEhYDyWYAa/CayWmx3dbWTYXcnT1VigmpCgAx2Bp7BCejVECMvppjN42yxEBuC9onfA9REBty4ZhKWrKolT4M8hRb8u5cwdGPUP/Kmb+Izeo629ulqqbpBZeAN5hIjXO/nZzw1Am/xY92TBMwUZMsOeIwwhFuY04uNUDoG8ZnDdhGQRK/yyIbxON4Yb8ylsHG75YbwZoqQBIwsP9Wk42G6UgXZxboIwi+DRrtErqvt2Ul3upJ4DQN5nxFWwxGxLpN3BJ7E7ZJ4eqq5yIVsrnfh27/mVpiV9ptg+HIAcTuEmhXOi01XiWtW1rRbv3JmDpTwIlc+od5p9ZDUEaLppbrF6tOlZ9693KPLVhp84Vm73J87ZZ2efk4tEFMp3vq3zO3NSFqcWP5CFRON8+eXXTHTLFtUZ
 VxHNUdM5
 jTA0XYGx4NzWDzxtFWjrhKfqKOqT5/xV+3V22M/ljcwkxtQyGPKYQiCkfOZLDtiIwl5KOe9pRVzUPUrYcZen/rmLJYWnp6HXV0i+w1EofhotxSUig0stW7PbHFQZYpQ/uMvPD5X3dC/9lV7GEqUZmKiXGSdvB/uvcEo6tKCQXLgwRldclSJDLTqXkMftpn2e/V703yu/prG+snT5oPlHWvVNmNv5Q2CaI4giDSCKTF+mg5Q72UV1G2+WDRyQ57nnQxub8+Pe9iuv9f3eEYTJ/ZVlwGxu76h0g+ONuK3CxSrlWrAjsZGItAiDk3Jl8zkv0+DbH8R1TXz0ypt5Azs4zoAyX7RwzpvZ28ZHD7lYeVs/38JdhC65TpFOwwMn/xqI725tK8KQtzeGk/64aTuyMChWEp+os0ZVEutKP1qddR4QkD+TnKBPeTBpheMuSiph2LBArkTRTkdwAeOaF3Doacfmg6NP9c6lC731R2fU+POiW8MYOHzwQjEucY4BpKitXfhPaYTB+labyIsdjumc3csyem9/HT47SzjDtMxtEeD3jCVn/gzr9ur5isbYIC0vWBTuXInwjxTDbE0LdNvlezz2C/r7OWEGZLT4bFofD5w6ikjZ7enX+xoXZ3dtxZuylVLTdPm1EGpCWwrb9iTnrhu8JdrZ0VzaOqJJ90i63zQA2WBE8NjKc7VeWHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Dec 14, 2025 at 9:13 AM UTC, Yeoreum Yun wrote:
>> I don't have the context on what this code is doing so take this with
>> a grain of salt, but...
>>
>> The point of the _nolock alloc is to give the allocator an excuse to
>> fail. Panicking on that failure doesn't seem like a great idea to me?
>
> I thought first whether it changes to "static" memory area to handle
> this in PREEMPT_RT.
> But since this function is called while smp_cpus_done().
> So, I think it's fine since there wouldn't be a contention for
> memory allocation in this phase.

Then shouldn't it use _nolock unconditionally?

