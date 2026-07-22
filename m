Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFE0C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D10D6B0088; Wed, 22 Jul 2026 03:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782A36B008A; Wed, 22 Jul 2026 03:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6707B6B008C; Wed, 22 Jul 2026 03:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33D5A6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:14:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DE16403B8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:14:48 +0000 (UTC)
X-FDA: 85015550256.20.0CB35C8
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id BFB681A0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:14:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OHCmft/k";
	spf=pass (imf19.hostedemail.com: domain of nivchenko.dev@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=nivchenko.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784704486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6x2HH5cDLmqxla1ueBrVL4yEKp2Gf+nJs7XENhnhYZQ=;
	b=60nnQRVd2KfdG8/KcayAs9qipCdcWrJGqkWZUiB+FlIroSugj2Ta1b74PK4q253T11Ylr+
	27P/erkgFdTV9CbyCs/431Ke0lDbAUiZfw4Pzf1d5F/qkn1IYyIsrthQSy48ooK2PH/Sd/
	1sBjd7GkrarLa8lHfyvR36bmIqjuIbA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OHCmft/k";
	spf=pass (imf19.hostedemail.com: domain of nivchenko.dev@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=nivchenko.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784704486;
	b=cRuE1eKTudp6P50uFnKP02aM7guPXNdQx9wz2kIcngLnE7/UqbKcX0a7bGzGLQCy4e7dfI
	UCrY/SGbl23ZTXvtV0bmt/NyBIRDWUQiOaf3jDT4r23s1PA2WXTCUHdxe/QTb9srn1WAtd
	iJlTURqh6Qv25RHfHA0Any3cmmDeGW0=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb72b0af1so1344021e87.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704485; x=1785309285; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6x2HH5cDLmqxla1ueBrVL4yEKp2Gf+nJs7XENhnhYZQ=;
        b=OHCmft/k+MW3qwnIEkOb0AiV9f3Y9jqyCz8ggmnMtWDx1Sd601o9Hb9kneQXamlNqC
         aLfC8zoFQNuhspIFm+xUjuEOHLZh8rLfHkGenA6MhqDDuiXGvEW5olQLCI9f9Es/h2h+
         pkK2muJxRMK0rn/Ia9ZK8Rkaxmc4zll0eSsY5gnvmIo7P1RXPkRxcrk+X/vXfA1WeE5M
         sFT/UDwoXqnmfXGN+efEt7jJbrQ4+ftWiwcRqUlwTwhhIocWlsMso5JVrU4d/fMJ4KTJ
         2mmQ/lGuqGXmBV9kLOEeQWmzPQFl0Yq0T2XRGpMmkU1PSWJihnH8GoJhEATOOiTUW3Pg
         XWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704485; x=1785309285;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6x2HH5cDLmqxla1ueBrVL4yEKp2Gf+nJs7XENhnhYZQ=;
        b=r3ZE0+UGhGngdtYGCZaiwM3rxl6Ni3pLN4YOuYQsC9weuC1JDt7/Y7Q1dil8iSawGK
         fwFg/TygIj/yXGo65m58zQcCcVoPM0F5yOA55MhK8N4Tty59iqIuUnsga/Cs1YXi8sbu
         ag9uljayv1oS0wT62FNTVeUAIwkuGSWpJTluCST+L5TQ67UhgMqxUcGXlJqIiHi5Lyqi
         uE5Cwx5Gd0PPp9yT3fz3If/2fPMuq2Y75TxvtiNW9nmVRPwhekgAXPwklRMWnwYGPNEN
         ObItEQfkE54memCTn7SlClmDBUs69T4m6SdKKnp1XUyHnE6UfsxBY3vNzen6Of+QdA2T
         Fl2w==
X-Forwarded-Encrypted: i=1; AHgh+Rrt56GMZ27pf0Ozxak6sEODlSnYqjdmMkcHEYHdZrFPjNE5v9vLs43c0IJYtM6Mj0Py+cCuGF/c0Q==@kvack.org
X-Gm-Message-State: AOJu0YygASoXvTM1PFVFXwKM1oMIUIKACs2Hr5YUHLVJkoQjj4uTOcrI
	AbjC2Uyvz22fa+EkcRJoXQ/lKmniPMKCIXQOcXRvrkHAtCJYH+BLgaKE
X-Gm-Gg: AR+sD13D0VKZamfNZeCCbkCG7nxNBR980X7ta5jE7cCUfT5cPUj+v85kOv7y/27bpkM
	DSDmPoSzBziz9p7MFDil+6BhXlPcArW0mV2CPEhr65wTI1l9eVJB9WQwAafbTfk27IxhZ2U737C
	O6VqjVeIJql8WdViuRCklssTWkDzp1B50vAiEAoLc7dyk1Uu8cdWDf0WM0pCrgAOYhh/1TV3XrZ
	FngNJF8/t+rxWFMKXq5eikLOaZ/Q2kdm2MOSyprpzCeMs6KNgkWIyJ8C9ThX74RDoAGezHMzVai
	rjAD6LGtQyrEVnwl/iR/C90rkOHtekbcvu/rO2AmwNXLVm8YCgp+2wvmKcIp9Xf/XqzBuplZtLb
	tuDSFWtc3qflMZw/ue2NxynxD02O0Hvbx6otOsYDRql9uXpZEVCQv/IIvHzubTg9TKUy3yS4j0Z
	I+u+8MEnGGdYyPGMoLD4SdyQ==
X-Received: by 2002:a05:6512:1327:b0:5ae:cf48:bd37 with SMTP id 2adb3069b0e04-5b2a49ef6c0mr729643e87.1.1784704484709;
        Wed, 22 Jul 2026 00:14:44 -0700 (PDT)
Received: from sheldie-RC14UD.. ([109.69.61.57])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2a9f49b70sm309117e87.74.2026.07.22.00.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:14:44 -0700 (PDT)
From: Nikolay Ivchenko <nivchenko.dev@gmail.com>
To: syzbot+2ad5ec205a38c46522b3@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	jannh@google.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	netdev@vger.kernel.org,
	pfalcato@suse.de,
	syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org,
	vinicius.gomes@intel.com,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in unmap_region
Date: Wed, 22 Jul 2026 10:14:16 +0300
Message-ID: <20260722071417.229890-1-nivchenko.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a475ec3.6912059f.e0473.000a.GAE@google.com>
References: <6a475ec3.6912059f.e0473.000a.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BFB681A0002
X-Stat-Signature: nb36m8xh5nnyhbh837jos7crx5578hps
X-HE-Tag: 1784704486-794967
X-HE-Meta: U2FsdGVkX1+XT+lC16nfhryyybt/UVsioJRDmhoyrdZ1aGKA57DP0Ar+qDFTYc2uooxxO3KfXN5SLq8RTPWmz3AWC3JoO0b/S2XT9XI/IQdOrA/sbXANn7s2UU0pEgw5BZIeIO/DYAzt51iQZjTsjgHzoeGXQMuCwWcV04Z2H5RNHIu30e3v4OZdSlA7Y5Z1ZVnKhjMeDK+ZAH2sa23OOuv41muTLcilEupk1YfX0O9qHuuylGvcw68CH5v4eZCqXyv/xMiKcYpxEWKlgPbjlA6N9gg7bbfoz2KF0oFW/OGbfvE3pGLvMfv4tPHofoMR/rvsjGAq9BCtvEoiv6MphLsVS7/3JXBvBcclF9DSh3g2LsRn+sjVobVaTvgpljDHRYEAwFsQLRW81SqP1WOy4LDvVr4znheVHmJRMBAEVtiJJNex1m9uGdrz16NUaYZIctnaZ9yodp4sf+C8RiL591uyXd/auQBKRO231OgLpPjWkYteDRRNkRiHFDoZuynESQ2qsqc7A0/sPPBTBhwSJiA3QH7Gu9rsgy8uuEvIdSC5+sZZ6sDZLUcxlCFjDxgTEjQx7GUwP4Y/E6orzm/mzZvTWQnh24w0t2D7+6DkJ5OuIKukCSsBsRspdho9gbganLlrulCg7DrU+UyyXDzbWg4thcqe/HDsbfPs2ZRtl0P7eCkXKTnyAUOGM4Du8QcZN8eX0TRrj1Pr4IHTGAxS+ycmKCA2i0smHdYiT/Z54/7SYBSJLZTXXHM0Gv0nWuIUZWfN5zTBcxWCvIe1supgnCwxGxlAGvgpPauVBjuUjyiNZHy3BQVLIXrb+P/28zOMHm3MXWGxxY1gNyxcjefOYjA6sppMSsqDG7J1nZSe+tSN57njZCCXKvfgkmo5y4JReYU6tcm04Q4ks/Szp8GHX47VLsXKkZaXUVPPMoLax03eW/DTMwPCxqkGyEClcg+4zXO5L6xkmsu2QZD5bV8
 nRLpfG3M
 KVZs/DrfeYGx4X8Q1n3GLuqRhwyG7A3JNkpdDpyP5zsGlnUNASalzA4y4DBu2AXp36c1s+bDnYjxVpt1h+eAktVIKzwnil6QdFRPOTxdzDLel+/h32IMlLICSEET9I/QWv4f12iohdeaTZ3ljYvXr/DRy2/tk1zdZI92tq4LdBZcCNVIBj/sZoCCWfRkvBzwRzt+FUmGMmUijnqQLMbWN2Lyc/U/5OEA5agspxvINLpB4fzUTnoKkLzcfDkR8jTWbFmLnTDi8Xai3YcYC2H2in1PsTUd4XfodsR6AyI690jOZ5EeP+xjV3/Zec6+wLz39j9u3VYe6vPYjGCjTFoS+zOo/99Fhiawy/cyJXELxpzR3f60OXA2DZIl985yP3kWExJn6UJXh8LWsb2+1QnPaYlKsPhECz/UvF1TCWluvvZHI8ISQ0OzrrRgxoCcGs5KV+AIg28nW0+h3FhcgfxbuQUHOEM6QkYd55LSROl7DPjvBO/2cPIvU0JozGkYWmVTdfhYLNEJOSjtHMoZkLR2LBLfZzRdt/XmIVLNx/RFURragDPs3bluOKh5MJ2ZnK6JgP2eVqsiXES6OUILgKquBqNrfx5xQqn6tJq1nHw8zT6tvI0IknpELq3axoB2WhwC0yxi51lRh67yR8wrKGVh53LPphcMabxjF7jiU257q3dYCjWVAG+7w0IPxI2nGB5viJo1O+Lne/SQSXEjsKJuW7Ov56EPRoqt4UDlAcq/i90G53rw1h5DMSAsjBL39Xjx5251tH7jZzZt3eH1cYFttVI9X5PxnFa8MhhXL/BMvyU7Fu4MgcFo8HEmXAciQFqVZqnLALEFW30LtWSkXfj8pgPIk0DWI8pm7U1o/0clv9opGj3tRBUT4XtXD4+QLR/6pDSbXjELEDn1LwpqYYo35nX1+AgdeSpiJcMG419mZQibyg4kofhjduV8kuX8PqpCADZmzQ7QcDQ7sTl/7s6g36sF4oHB8
 4ZcaGkFa
 9DIRhMqTL6uBuS2JFhVrhZdZvnNEkWosh/QlXI4cNbPEfwUATOD7Mu0THyHrDmYOFr5WFZ/G8wGvfee8XO58TLL0Fl8mpbAlcOd04zV1gcYw/00XztJFFJ0063pha3owaszPbcGVlEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On syzbot report, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    32f1c2bbb26a net: airoha: dma map xmit frags with skb_frag..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=116c2c0a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=86ba763b42fa66a
> dashboard link: https://syzkaller.appspot.com/bug?extid=2ad5ec205a38c46522b3
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132f5861580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7b7c3a22a8ed/disk-32f1c2bb.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/168b43c87305/vmlinux-32f1c2bb.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/70704720d284/bzImage-32f1c2bb.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2ad5ec205a38c46522b3@syzkaller.appspotmail.com
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	0-...!: (1 GPs behind) idle=6664/1/0x4000000000000000 softirq=17730/17732 fqs=2
> rcu: 	(detected by 1, t=10502 jiffies, g=17101, q=1895 ncpus=2)
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 6010 Comm: modprobe Not tainted syzkaller #0 PREEMPT(full)
> ...
> Call Trace:
> <IRQ>
> __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:176 [inline]
> _raw_spin_unlock_irqrestore+0x1b/0x80 kernel/locking/spinlock.c:198
> debug_hrtimer_deactivate kernel/time/hrtimer.c:490 [inline]
> __run_hrtimer kernel/time/hrtimer.c:2000 [inline]
> __hrtimer_run_queues+0x239/0xa10 kernel/time/hrtimer.c:2096
> hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
> local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
> __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
> instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
> sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
> </IRQ>

I have analyzed this issue in sch_taprio, and configuring extremely short
schedule entry intervals (e.g., 700 ns) in software mode
(!FULL_OFFLOAD_IS_ENABLED) seems to be the root cause, leading to an hrtimer
interrupt storm that locks up the CPU and results in RCU stalls and softlockups.
When testing with larger intervals, the lockup completely disappeared.
Furthermore, no matter how many times I captured this stall, NMI backtraces
consistently showed the CPU trapped inside the timer handler
(advance_sched / hrtimer_interrupt).

Please note that this bug can show up in different execution contexts and with
various crash titles depending on what the CPU was doing when the interrupt
storm hit. As such, despite what the subject line of this report suggests, this
is not a memory management issue — the root cause is entirely in sch_taprio
(networking).

=== Cause Analysis ===

Currently, fill_sched_entry() validates schedule intervals against a minimum
duration using length_to_duration(q, ETH_ZLEN):

    int min_duration = length_to_duration(q, ETH_ZLEN);

    [...]

    if (interval < min_duration) {
        NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
        return -EINVAL;
    }

On high-speed interfaces (e.g., veth, which defaults to 10 Gbps),
transmitting 60 bytes (ETH_ZLEN) takes only ~48 ns. Consequently, an interval
such as 700 ns passes validation because 700 ns > 48 ns.

However, in software scheduling mode (!FULL_OFFLOAD_IS_ENABLED), the hrtimer
handling overhead easily exceeds 700 ns, particularly in virtualized
environments or on slower CPUs, leading to CPU lockups and RCU stalls.

=== Minimal Reproducer ===

Based on the reproducer provided by syzbot, I have created a minimal shell
script reproducer:

#!/bin/bash
ip link del dev veth0 2>/dev/null
ip link add dev veth0 numtxqueues 4 type veth peer name veth1
ip link set dev veth0 up

# 700 ns interval passes validation on 10Gbps veth, causing softlockup:
tc qdisc add dev veth0 parent root handle 1: taprio \
    num_tc 2 \
    map 0 1 \
    queues 1@0 1@1 \
    sched-entry S 01 700 \
    clockid CLOCK_TAI

Note that after running this script, you may need to wait about 20-30 seconds
before the RCU stall or softlockup warning appears in dmesg.

=== Discussion ===

I would like to ask for opinions on how this problem should be addressed.
One approach is to enforce a minimum software interval threshold at
configuration time in fill_sched_entry() when
!FULL_OFFLOAD_IS_ENABLED(q->flags):

    if (!FULL_OFFLOAD_IS_ENABLED(q->flags) && interval < NSEC_PER_USEC) {
        NL_SET_ERR_MSG_MOD(extack, "Interval too small for software mode");
        return -EINVAL;
    }

However, I am doubtful whether this is the correct way to fix the issue.
Hardcoding a fixed lower bound (such as 1 us or NSEC_PER_USEC) is a heuristic.
An interval that works safely on high-performance hardware might still cause
softlockups on slower hardware or inside heavily loaded virtual machines, while
a conservative threshold might unnecessarily reject valid configurations.

Where should this problem ideally be solved? If it belongs at the input
validation level, how can we properly validate input data when we cannot know
in advance whether a given CPU will handle the processing load?
Conversely, if we should try to detect this issue at runtime, how exactly
should that be implemented?

Best regards,
Nikolay Ivchenko

#syz set subsystems: net

