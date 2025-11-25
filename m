Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7AED0E6E5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372F86B000E; Tue, 25 Nov 2025 09:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A9D6B008C; Tue, 25 Nov 2025 09:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A0C6B0092; Tue, 25 Nov 2025 09:13:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1796B000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:13:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAFC61DE9BF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:13:56 +0000 (UTC)
X-FDA: 84149323272.17.44B7FB1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C976C0014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:13:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCFs1Enb;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764080034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOE4pVZbQk3NRzTWk4bK9iK9S5Rl6Cg6Yr2VD/4CLLg=;
	b=K0RWaY7+TwtxCQSgxrH8iPFvDDcw1APjqqKviCA/7jQENqEBg8ZBIx4S1KbHjofHXSzOd0
	zbDxqTOJBEQoiDb75/MfWlRG4LnUoKIyk2ylI7qfeLKz/GYp4wOhIbE0626JM4Al/Hlifu
	vajAXzzsBo1E8uGFhZ0g0INbL6eXFjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764080034; a=rsa-sha256;
	cv=none;
	b=CPf6u75z7ptrC0FQPyXe3djbEPwIyEREtMo1LlfsttBLyvmootpO/+mg3wF9sfhA50p569
	xMN9z9ESRjh2QsRP91iv0ePcarAuklw85SEnCjj8ENKf0j3lEDb2Sn0LIB4JIDyDSkoEnx
	MinlYp5Fp7IgBisL/RzlRGsfU+HfjDc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCFs1Enb;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764080033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOE4pVZbQk3NRzTWk4bK9iK9S5Rl6Cg6Yr2VD/4CLLg=;
	b=WCFs1EnbW0dICr2gg1LFHJox4vf8fvNZxl+Nzzhd3p2g21y8nyOWvLPzKRwF80u1AXUPxF
	PoYDGEpi/UyqplM0Qj5XipfP/S2nZ96ws7EuKlzJKxpcA+r2FH/5H40eGBC4R0rvVhoJpI
	yn2WcRZt+0AnKdKe+FU3Hu0x1ous42M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-eEA032gpNGuBg95cTwi2Wg-1; Tue, 25 Nov 2025 09:13:52 -0500
X-MC-Unique: eEA032gpNGuBg95cTwi2Wg-1
X-Mimecast-MFC-AGG-ID: eEA032gpNGuBg95cTwi2Wg_1764080031
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779981523fso56399625e9.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:13:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764080031; x=1764684831;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOE4pVZbQk3NRzTWk4bK9iK9S5Rl6Cg6Yr2VD/4CLLg=;
        b=Xj+Ixj6qCwQLUt/0caYe+x7EFAtACYIHR4Uny4Q+SWJmyBNzLAo+28jszKiEwFkt+B
         HFKt53LcQhZSgl+g6DHZz1jWFuDBb2SUc9o+rjYRCJvue5M18mL4qasd8+nFGvY7+M2Q
         aX4E3zluNCHsVhO90FDnhaa9FxEHDZgAGkgARbsORbz46vd576LB8226HTJvdKFocFCB
         ymIBZRjGS5E8JryKtDc40POi1EVD2caUGI84wP6xJqyMOA1M7IGaT3TLWxaPODxCHz6u
         JEQSBaK/tZT6Lp79yaszrviujbh+HOMeecxuoCOnORUv9hGh+sMK/3rzBTQjuvpNMMNp
         88LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlfHXYlyIkDkFFo+3otOEGSwOtn0Qm2ruvrNkqkcRT3X6lInNYdSGoEpf60b/GC1JGoEifrJmdFg==@kvack.org
X-Gm-Message-State: AOJu0YzjDl/dD5PJ15zpmKn3d9VhHXdtWX25Ign25jm9to5a64z6e7NJ
	G7b9apdlkxXGQltHIjPfv5pDjMuIgLOqIM2CaBpI/PK68IafueMUyw3o9WzgtD7XQJrBUUE0Gcq
	c1VRneZ1rXwJt7f0PFn9zIjHac+bruHCuZyeAp1pNPG4yY39+9c24
X-Gm-Gg: ASbGncsB8JsPbfyNnHTvMDEPO46tvIPovWkKJTrl1CHb/dqWfcLoyMGc5ULuL6KPj7K
	rdXPumGpP1xXHu62g2FdpAdfiv1jBx2A9a7Ah1D3n3olZvJCI7sQDJTXqlAk/EYjgVNZuhqYNMg
	GyyzCzmPfY37kKyKOf9WxTYNmKM/CdewpaBGmtyVr2Apc7MON6KJhRPuDPiM3aCtia0SJSywiO7
	nF0JWhvZ1/jf0SSTFYlJemzrQF4LJ0NvEjoq8AwqgmEFan0rWf8x13yrcWeeqiZxV2Psorqc3jp
	iQQBO4LZ0vrgOvBNJsX/71hHqxm2f1PN0OHJR1YKwXcUYfvfyB0x9ylSuo4NNK7DqUHIuSLaad+
	43WbffuweMPlgQnK21anaHz4QAMLU745pgJ+SwPH4m0jSib0XRLC21SYPUr/wF/FZxK8Y4kA=
X-Received: by 2002:a05:600c:3111:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-477c10deffamr169341905e9.12.1764080030915;
        Tue, 25 Nov 2025 06:13:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtA8JzDWqwpv+zLW5Ygo6VxUlFOBnDYO5W2Qk6szEUT54U+0BafPLKh5CrRqs4rY7IKqQsQw==
X-Received: by 2002:a05:600c:3111:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-477c10deffamr169341405e9.12.1764080030289;
        Tue, 25 Nov 2025 06:13:50 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1e86b3sm306305045e9.6.2025.11.25.06.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 06:13:49 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v7 30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush
 IPIs under CONFIG_COALESCE_TLBI=y
In-Reply-To: <2837ea3e-c0b8-46b0-b8da-bf06906d124d@intel.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-10-vschneid@redhat.com>
 <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
 <xhsmh5xb3thh6.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <2837ea3e-c0b8-46b0-b8da-bf06906d124d@intel.com>
Date: Tue, 25 Nov 2025 15:13:47 +0100
Message-ID: <xhsmh3462td2c.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SjV-dH0Aff6VY2sRTc3rIBrZqa6gWsaJHtrgeG1f7Lo_1764080031
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C976C0014
X-Stat-Signature: 1wcpn7pe81d8xsuy7fryicu4ywi5apzz
X-Rspam-User: 
X-HE-Tag: 1764080034-523635
X-HE-Meta: U2FsdGVkX19S2zKYqNVe7QmZtWjvfy5XtK8j1VgktGPyaL7UVNSZRLkxls2LUEbswrFVmdyR2EPpxXQgzaBaCsRE3fj/242IkXqEQRY78NYJkUUS5ID2pJVMzCS9jcgVYn7mmIT9Bmcc1ghQT1pgzf6YTnNM2Aio772Vv3KTpc4kiPfsLPTSg+6ASvpZncjXO4/AV1raThqVeRYS82qTrdWlsSF16iFUS+3c87fpeigv1FwokmQ0eOVjVXA8muuGbNhYg5FYSFPqDcTB+3xxEfB4ZCfJmv1c7nRVumE34DkrJRQD15ae2dVmdhAJmx5zLO9c/7NJN/Zm0ykfLxROGhTAv2ycbJ1cb4F+xVE/PYTOKgwJvJhhNFg1iTAA944pvAXSHdq9UR6Lk1Eyd43smhcgJ9jvOSwhOphyj6sFaEz0tyes6TapJ64kPrFVVGjxaV7r2asbfoiFHoeAhgkZlAQ53gZKUQVtvh4PgZy9qCAJp0t0z2j7/DetZeR/oNnbBuugwj7H4YCvkYiFlBXL9ywC838hYWYht0gEJhpm9OOQChArQ/pW6PpYH13pMuUsl1a+yhm/OWLF6pyqh1RqkUjznaxN+CbuNz3EvuSs/YgEnbeUdN5bO+nS92sifOqGe6jSosR/HGzqdsP6PVpMOOJOD2EHRM5pY9/C0vAkCjlcK+MXsULkTZz1Z/6q/Wqi5NHY88I36ydqBuMqZLn7x4uDjG2Jm+py27Jgee1fgQ52PMzTuzJzZLXvQedLCDIJWPygHVrile5fpf2Ae/l9Q2Cuo9D2unlsh7wg2k/LfhgFBTriTvK7WasvmRWV69Gua5+4rsnMLdbuz8/cqEe4BKufvg7LELwZpebJr2kj4+INOAhgdP/L+ZANhKcHNGnlNKQzV7/niRa0afi+CZnIeB4hiINg96bLr2e8i3c0OqqDPrZnENqHL5+KvHIqa+M6rExEHT2/iOqZaxQ13vG
 cvjVKPiq
 xWrpOecck+oXrbEa1IrmaJk/CSTdfuawwcHwyotfEJXihhKSVhVudkvV7E9UwCLjW01O3rFiFDOrKZSGl/8asjIhjSEhqYnN/c4g4sFkbx7EeUKbudc0q6w6JK/a/to3M1wlNRGaM0eEq3Cp/obvZDUjUyoW21NTdulLq10eCvGjznJh8MYiUlL3LhwH86gXUrey4i0rlGxbTUoov8+M9JQ6w67xlO5NynMq+55Ys1Kz1SmdtVLAIlWT6iteEaRlmlGk5dwmjCgxn/kB7pYUbJ0Ea3ex1y4ijGeMEABeQoNwCdQjsUPEWTbWwJxP4z0Ef26mt8fZV/chIZYyWoHstD7MpnaMPV+BSINzjyxMkF4eMUTdH7tjk0hN3A/tKT2wOVlf9F46gtzLlRcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/11/25 09:50, Dave Hansen wrote:
> On 11/21/25 09:37, Valentin Schneider wrote:
>> On 19/11/25 10:31, Dave Hansen wrote:
>>> On 11/14/25 07:14, Valentin Schneider wrote:
>>>> +static bool flush_tlb_kernel_cond(int cpu, void *info)
>>>> +{
>>>> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
>>>> +	       per_cpu(kernel_cr3_loaded, cpu);
>>>> +}
>>>
>>> Is it OK that 'kernel_cr3_loaded' can be be stale? Since it's not part
>>> of the instruction that actually sets CR3, there's a window between when
>>> 'kernel_cr3_loaded' is set (or cleared) and CR3 is actually written.
>>>
>>> Is that OK?
>>>
>>> It seems like it could lead to both unnecessary IPIs being sent and for
>>> IPIs to be missed.
>>>
>>
>> So the pattern is
>>
>>   SWITCH_TO_KERNEL_CR3
>>   FLUSH
>>   KERNEL_CR3_LOADED := 1
>>
>>   KERNEL_CR3_LOADED := 0
>>   SWITCH_TO_USER_CR3
>>
>>
>> The 0 -> 1 transition has a window between the unconditional flush and the
>> write to 1 where a remote flush IPI may be omitted. Given that the write is
>> immediately following the unconditional flush, that would really be just
>> two flushes racing with each other,
>
> Let me fix that for you. When you wrote "a remote flush IPI may be
> omitted" you meant to write: "there's a bug." ;)
>

Something like that :-)

> In the end, KERNEL_CR3_LOADED==0 means, "you don't need to send this CPU
> flushing IPIs because it will flush the TLB itself before touching
> memory that needs a flush".
>
>    SWITCH_TO_KERNEL_CR3
>    FLUSH
>    // On kernel CR3, *AND* not getting IPIs
>    KERNEL_CR3_LOADED := 1
>
>> but I could punt the kernel_cr3_loaded
>> write above the unconditional flush.
>
> Yes, that would eliminate the window, as long as the memory ordering is
> right. You not only need to have the KERNEL_CR3_LOADED:=1 CPU set that
> variable, you need to ensure that it has seen the page table update.
>

I assumed the page table update would be a self-synchronizing operation,
but that betrays how little I know about x86; /me goes back to reading

>> The 1 -> 0 transition is less problematic, worst case a remote flush races
>> with the CPU returning to userspace and it'll get interrupted back to
>> kernelspace.
>
> It's also not just "returning to userspace". It could well be *in*
> userspace by the point the IPI shows up. It's not the end of the world,
> and the window isn't infinitely long. But there certainly is still a
> possibility of getting spurious interrupts for the precious NOHZ_FULL
> task while it's in userspace.

IME it's okay if the application is just starting as it needs to do some
initialization anyway (mlockall & friends), i.e. it's not executing actual
useful payload from the get go.

If it's resuming from an interference, well we'd be making things worse.

I'm thinking the worst case is if this becomes a repeating pattern, but
then that means even without those deferral hacks the isolated CPUs would
be bombarded by IPIs in the first place.


