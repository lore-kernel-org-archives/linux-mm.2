Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7F5CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B5F8E000B; Wed,  5 Nov 2025 05:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732398E0003; Wed,  5 Nov 2025 05:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6483B8E000B; Wed,  5 Nov 2025 05:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5501B8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:18:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E08312B80C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:18:19 +0000 (UTC)
X-FDA: 84076153518.05.DA90B5A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A52780009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:18:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762337897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+nitTwb5WJ+EUmnDTJjRK0YITVPRlucFpEPdRpx4NY=;
	b=A9DYebgXdZ6o0w1MCbddRKCtvHo2vhDnTRzX0upBlKSQqd/9MBdwLjJ8C6XsC7rChq80Hi
	mPlqFRkDUTSZ6wftVeyuVciyI2VnvIBtC5hFdDgsPfQAQ/PyScvjGSJOUe1jpKzTIRfImh
	Ndy4ojY19xmBPy4U/0of8SaPfJsP+YM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762337897; a=rsa-sha256;
	cv=none;
	b=d0kgfqrnUfHb2QhI0Sr235BOB7qpUHZDLwOmSIuKxB/OWGdron+4xgxF9jeU0lLzuzWgaX
	dWQlSjT4UtEON6febH3LUhGDamtyYrWs0D6CpKok2nyaTBxeZAEkoO0CPkiXhZVCbzOAGt
	+aCS7l/YLtLFUJlKGd8/EmH/WBjjjBw=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so5848036a12.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 02:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762337896; x=1762942696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+nitTwb5WJ+EUmnDTJjRK0YITVPRlucFpEPdRpx4NY=;
        b=mlnbuyi5TrgD3mgNSLBKUot5DfzHZR1Co1yoLxvdrYhFU94vltr4u+y6qSJQiBRyGB
         lf3s7FEwlasjQ/akB+VTEA0REEzXN7we2FlslKCn1uKG0dgeZrp74kCOD9FvEM8cv5Ib
         annZkCz07aJB/j/B0WFIEdH5Goa8b0zTaY8MQzYgq0t4R0Bz+JhfMs+dccjbW52eXpSH
         c/6Y9prM8AcPp+TUtVZom9UeGjv9moHWDpVWIZg8JBxRqv+rhxU9HZ2KGXFNuaw6T5XM
         KmxHHilf2Mu2k30NAG6KDvaDBjPIVBTKtUCBNpwWzcBU/+jvS8OK0fDWCkUdrLruOeok
         g2GQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEHiIzIzKbKEWuQ7xzgA0EZ7UzWusqpQYXMaECBiFPSOe8gp0gyk9RV7gbI99I+DQ8qslxlg9fxg==@kvack.org
X-Gm-Message-State: AOJu0YzwWbgiAbGm5C80PUzV5O67O7wQN2pOKrCTQMesPPTQXm7BjBvR
	PBUHGNg+peQazgVyEWxn21m8LyEWZOt3KBWuI+CCU9I5jrujsRiVT4Ef
X-Gm-Gg: ASbGncvX3TDvkLPfZyeDtcYCnOMRfgGUo/t+lSh+1MpuVbX7nUvD3AmZeldsv2Z5vex
	Cde104jpF1jZFoTF2+H5uHMf+iLdber5AQ6GyI7dNnnFENwxjv3YXwMQ2/NIKcRBtnBI2LqS5iC
	djSMrV4I2TTQV6ELqAjUtFKVzF5daruV1AlSpD0u69VCYOAtt3tVCoeJNdNJ0MkGpX0db7lMtxt
	3nZGqxMe0fVZKmnc5e7LOMpuF8PjQLqmkeYAqKNWARCloz4dIEivE6USFRUvJCkbjwL36qYMqtW
	kQ5Etlp0cIdoD2o/96XwiRpdOk6Lk7c6UDp41tHfEh4Jqls0h8ejt3idkExT4EJ2SFNe1yftrwn
	BEfCddU/pAb/ZFoV/jf0a1qHZEc9EtByR4viUumGLyu0mmjKebeRYSqRIp9EhDf6Y4Ig=
X-Google-Smtp-Source: AGHT+IGMOyHdTrU7e4XzICZCye2rZuaFGN3pfPJ6kDUtI82R9LpfHeUzLCsG0FSLtDRWmVaLyRXkdA==
X-Received: by 2002:a05:6402:5351:20b0:63e:6d38:865 with SMTP id 4fb4d7f45d1cf-64105b7a684mr1701971a12.36.1762337895297;
        Wed, 05 Nov 2025 02:18:15 -0800 (PST)
Received: from gmail.com ([2a03:2880:30ff:74::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640ebbdc7cesm3763441a12.35.2025.11.05.02.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 02:18:14 -0800 (PST)
Date: Wed, 5 Nov 2025 02:18:11 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Changyuan Lyu <changyuanl@google.com>, rppt@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com, 
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org, bp@alien8.de, 
	catalin.marinas@arm.com, corbet@lwn.net, dave.hansen@linux.intel.com, 
	devicetree@vger.kernel.org, dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com, 
	hpa@zytor.com, jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, 
	mark.rutland@arm.com, mingo@redhat.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
	peterz@infradead.org, robh@kernel.org, rostedt@goodmis.org, saravanak@google.com, 
	skinsburskii@linux.microsoft.com, tglx@linutronix.de, thomas.lendacky@amd.com, will@kernel.org, 
	x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
Message-ID: <c2nrxby4atq75o5yhwdpoikyso42tzimwn2bnl7fk54wuwdqax@i6kdssez3kfj>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-2-changyuanl@google.com>
 <ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
 <mafs0wm4yluej.fsf@kernel.org>
 <mafs0h5w2lpqu.fsf@kernel.org>
 <2ege2jfbevtunhxsnutbzde7cqwgu5qbj4bbuw2umw7ke7ogcn@5wtskk4exzsi>
 <mafs0cy6pljci.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0cy6pljci.fsf@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A52780009
X-Stat-Signature: ngn96ebjnh4uhn9co4ngg43nd5wm3cyx
X-Rspam-User: 
X-HE-Tag: 1762337896-681842
X-HE-Meta: U2FsdGVkX19jiICExDDq/RSeKRS1mY5eDmkMLa+YMw8bgYW4WyW+XSYF/DXj4MVJI5nORuA4HZ3bftTQY9hlzfE6WJHhMJyPeu1omeIeRC9l8ur+y31lgkui74HPBcHmOxCOagFA6FS/cjwJY5BO01oCNtD6J5k6Kzxf31MY9u8ga2G/q0vY1mjb/sYXfpm/LpeKM1FM/RF6uJRTC6ztiQnqnTx8cD+5+byOMZ0ppNcg7aDdU/QVHWoHO8kAjsnEs9eg3ZlXRby8fBdp35rzXLRHnxPYFiEhqDtTcb0qmXUa3U2qT0y3MIU3JsqNAVRgg+4xmXROihX/xd1hZY6Hy1TCvJ3AJwd4pPECkAX5MjUiPsjXpoC/+aDgL1MLMnPivQz2DAnqA5K++zMdl73P2MzNEp1mmlGyYcXVFOfvRjM+a5Hvt5lGqiMgR5amHXnVoMFn0k1AcUWoslCi+OUKhr6b6RxLSwysLjlLGi6VK5mykx58bPaZBErWFI6FG3f++S+3wfHaZ4riYRtaKCqgmO94BNolRSUF262vN9vbcUFDVrWvmUMI/hRuphlc7XN6V1+66wuAyWzalt7m1WC6SdrwSzJ6MPknC1LWltKo84YjL9ZIQFsjW+t6aRZQt9+BVYLMhnnv+KF9/I+OD57K5e8fdJ1yWTGyc8uEHHAXWkYiteSS7WKFQCOrL3GpQn73juI48ttQgmRhrRPnOrQK7XMFrf48YN9ZlfyBOQ71bDgez36S6Hh8/mFZCriFr+rOesFpYayR9W3CpbkaYhA04gDvjg1wGUjRk2bcxf1ImcW8x4ngKMb8GWyVdA9ec4wnwPl8DWT1dDSUnDLvMFK9WGpcuH32gYwKtQQEN+O4K3AhePshPjZL0WOFYYAKAo1XcycaLyrOPX1fE2UoxrMboHSBs6GBjXg3FGNeoWBbqkyY+6PTbOdq+E3Dyb5kjaETPv6s5UQz43Itea/hVBU
 ziJZpNtA
 K8srJiIRUlF6XisFv93Wzaj+tOn/xLfeamBPDWTgNSTpU5pDkFdGNvvF67hD4142rfVETY9KThzl/8NspHZFUxM+tg6S3dfP3Cd+uJfm4t0mFEERsIn18BC7hpdAV2xRGUz1aIImTVQwEEX1Vo0HLpvcSqEg2CTh9gZgoPPCeJDvs7YzL0Qnbo1/Pk3Rx5gQztIhBzG1Jlhevrsl1/cPAj1wxwajkcg9YYU3yghConeRI2LW0gVEiBqRDJ24oDOQOdtA5QPz4XdKbYLILGBOJ2an2zMWvy/xydT7A2fxxYCmqtgrGdRxp4ccwZaai58UynDUnZ04SmkJtPny+p2jhLIZP7M88PFZPQzRpkLAS+Ry/cGPv+A1KIiAN/v32w04XQeJKAJ9cLQOFq1wLfvaS16cbIge6qgqMMSvWr9S89ZJ8vk+2zEGG1njEGNQs0GhCWle3CObqWBYtQye2VgKKsWmNu5NF1MgiGjYV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On Tue, Oct 14, 2025 at 03:10:37PM +0200, Pratyush Yadav wrote:
> On Tue, Oct 14 2025, Breno Leitao wrote:
> > On Mon, Oct 13, 2025 at 06:40:09PM +0200, Pratyush Yadav wrote:
> >> On Mon, Oct 13 2025, Pratyush Yadav wrote:
> >> >
> >> > I suppose this would be useful. I think enabling memblock debug prints
> >> > would also be helpful (using the "memblock=debug" commandline parameter)
> >> > if it doesn't impact your production environment too much.
> >> 
> >> Actually, I think "memblock=debug" is going to be the more useful thing
> >> since it would also show what function allocated the overlapping range
> >> and the flags it was allocated with.
> >> 
> >> On my qemu VM with KVM, this results in around 70 prints from memblock.
> >> So it adds a bit of extra prints but nothing that should be too
> >> disrupting I think. Plus, only at boot so the worst thing you get is
> >> slightly slower boot times.
> >
> > Unfortunately this issue is happening on production systems, and I don't
> > have an easy way to reproduce it _yet_.
> >
> > At the same time, "memblock=debug" has two problems:
> >
> >  1) It slows the boot time as you suggested. Boot time at large
> >     environments is SUPER critical and time sensitive. It is a bit
> >     weird, but it is common for machines in production to kexec
> >     _thousands_ of times, and kexecing is considered downtime.
> 
> I don't know if it would make a real enough difference on boot times,
> only that it should theoretically affect it, mainly if you are using
> serial for dmesg logs. Anyway, that's your production environment so you
> know best.
> 
> >
> >     This would be useful if I find some hosts getting this issue, and
> >     then I can easily enable the extra information to collect what
> >     I need, but, this didn't pan out because the hosts I got
> >     `memblock=debug` didn't collaborate.
> >
> >  2) "memblock=debug" is verbose for all cases, which also not necessary
> >     the desired behaviour. I am more interested in only being verbose
> >     when there is a known problem.

I am still interested in this problem, and I finally found a host that
constantly reproduce the issue and I was able to get `memblock=debug`
cmdline. I am running 6.18-rc4 with some debug options enabled.

	DMA-API: exceeded 7 overlapping mappings of cacheline 0x0000000006d6e400
	WARNING: CPU: 58 PID: 828 at kernel/dma/debug.c:463 add_dma_entry+0x2e4/0x330
	pc : add_dma_entry+0x2e4/0x330
	lr : add_dma_entry+0x2e4/0x330
	sp : ffff8000b036f7f0
	x29: ffff8000b036f800 x28: 0000000000000001 x27: 0000000000000008
	x26: ffff8000835f7fb8 x25: ffff8000835f7000 x24: ffff8000835f7ee0
	x23: 0000000000000000 x22: 0000000006d6e400 x21: 0000000000000000
	x20: 0000000006d6e400 x19: ffff0003f70c1100 x18: 00000000ffffffff
	x17: ffff80008019a2d8 x16: ffff80008019a08c x15: 0000000000000000
	x14: 0000000000000000 x13: 0000000000000820 x12: ffff00011faeaf00
	x11: 0000000000000000 x10: ffff8000834633d8 x9 : ffff8000801979d4
	x8 : 00000000fffeffff x7 : ffff8000834633d8 x6 : 0000000000000000
	x5 : 00000000000bfff4 x4 : 0000000000000000 x3 : ffff0001075eb7c0
	x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0001075eb7c0
	Call trace:
	add_dma_entry+0x2e4/0x330 (P)
	debug_dma_map_phys+0xc4/0xf0
	dma_map_phys (/home/leit/Devel/upstream/./include/linux/dma-direct.h:138 /home/leit/Devel/upstream/kernel/dma/direct.h:102 /home/leit/Devel/upstream/kernel/dma/mapping.c:169)
	dma_map_page_attrs (/home/leit/Devel/upstream/kernel/dma/mapping.c:387)
	blk_dma_map_direct.isra.0 (/home/leit/Devel/upstream/block/blk-mq-dma.c:102)
	blk_dma_map_iter_start (/home/leit/Devel/upstream/block/blk-mq-dma.c:123 /home/leit/Devel/upstream/block/blk-mq-dma.c:196)
	blk_rq_dma_map_iter_start (/home/leit/Devel/upstream/block/blk-mq-dma.c:228)
	nvme_prep_rq+0xb8/0x9b8
	nvme_queue_rq+0x44/0x1b0
	blk_mq_dispatch_rq_list (/home/leit/Devel/upstream/block/blk-mq.c:2129)
	__blk_mq_sched_dispatch_requests (/home/leit/Devel/upstream/block/blk-mq-sched.c:314)
	blk_mq_sched_dispatch_requests (/home/leit/Devel/upstream/block/blk-mq-sched.c:329)
	blk_mq_run_work_fn (/home/leit/Devel/upstream/block/blk-mq.c:219 /home/leit/Devel/upstream/block/blk-mq.c:231)
	process_one_work (/home/leit/Devel/upstream/kernel/workqueue.c:991 /home/leit/Devel/upstream/kernel/workqueue.c:3213)
	worker_thread (/home/leit/Devel/upstream/./include/linux/list.h:163 /home/leit/Devel/upstream/./include/linux/list.h:191 /home/leit/Devel/upstream/./include/linux/list.h:319 /home/leit/Devel/upstream/kernel/workqueue.c:1153 /home/leit/Devel/upstream/kernel/workqueue.c:1205 /home/leit/Devel/upstream/kernel/workqueue.c:3426)
	kthread (/home/leit/Devel/upstream/kernel/kthread.c:386 /home/leit/Devel/upstream/kernel/kthread.c:457)
	ret_from_fork (/home/leit/Devel/upstream/entry.S:861)


Looking at memblock debug logs, I haven't seen anything related to
0x0000000006d6e400.

I got the output of `dmesg | grep memblock` in, in case you are curious:

	https://github.com/leitao/debug/blob/main/pastebin/memblock/dmesg_grep_memblock.txt

Thanks
--breno

