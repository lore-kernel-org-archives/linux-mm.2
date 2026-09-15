Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C737C982C5
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FBC6B0093; Tue, 15 Sep 2026 08:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032826B009D; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88DF6B009E; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0A0D6B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1473B1203DD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:59:57 +0000 (UTC)
X-FDA: 85215852834.01.FD27682
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B357C000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:59:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNkc1SOO;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473595;
	b=517L2IyP7/WRTeeyMRCuIbRKHU8ATHEi8iIVpK4obEqLujTjJDqTGesw/WiCbPHT4uvKbZ
	2dgwp8gyAZpnttsQZhAqZtHnZVRjRPOhddrtEvQfuLMwJ5kPesqA588otWQLfQddpLlAOd
	zh0pWyDUfoDJldko75YssfSBFW29oqM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNkc1SOO;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473595;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQgIYhua5CTViS1X9ZXXGfaSPT/5dqgeOOlUNrKnxWw=;
	b=6NsOVVcdv9yhq8XsI5/H47/i6Do4PWlkXEwbl1tHhEyE/CcaGWCtH76hoed1Fwel0X1VDM
	JoGzpTTEvkiAWMftJnnU6QK0ILhoj8OUPCN8ASzXEHb5w10zrd/cVdlXYtvcnsrrvD4snD
	67vR1IT/9t/GQ/wfsChj6opYA7SgufM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30ED7600D1;
	Tue, 15 Sep 2026 11:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1604F1F000FF;
	Tue, 15 Sep 2026 11:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473593;
	bh=DQgIYhua5CTViS1X9ZXXGfaSPT/5dqgeOOlUNrKnxWw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PNkc1SOOx+a0MtActP/scxfu+EOEc0okpYmMq9u2IvQ6wdxXtOCmaRwTaDfxAYQfu
	 KNpmxdQzkwQyaCWqsjPY6fMZbe5ub33vKaPoYJ07B7Q1LWFwdlgiCUvB0QQ8c2qsi1
	 FMsSTqEgiIP1sEOamGDSgZSCZ6TfAMEjISixK2R8eaJA2XnzylLgQ4fdlCaNZFxShP
	 J8hVTu3MQPl0lwmGSaxF9w8s3KltrNP5jpWzkNN2BlxuRXTG4UWjQZqj2E6RzHxSaN
	 2Rs03FwwuFJXXN68mTYzdZ8pV7LyInc7Ptt8ORor8BsaOlsL4d3xo27nPcBZv3oI95
	 0hW/vFstsi8gw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 14/50] parisc: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-sh@vger.kernel.org, virtualization@lists.linux.dev, "Eugenio
 Perez" <eperezma@redhat.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org, dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, kexec@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-um@lists.infradead.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-alpha@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jens Axboe" <axboe@kernel.dk>, linux-arm-msm@vger.kernel.org, linux-parisc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-openrisc@vger.kernel.org, linux-mm@kvack.org, sparclinux@vger.kernel.org, "Jann
 Horn" <jannh@google.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-14-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-14-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:59:51 +0000
Message-Id: <20260915115952.1604F1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B357C000C
X-Stat-Signature: 9ouws5hr61iefoxgp5dh416iksqpiji7
X-Rspam-User: 
X-HE-Tag: 1789473595-741438
X-HE-Meta: U2FsdGVkX18hRNwxfmiwCOSexTBg+bF4EiO0YSd0+CU5I2DPqRrW7rGSd7lu08P612KwKKL8UTuIzVVbi+Qq5aLFBvi6Tt3EH1++GqTcxCba/wq4aKOJEnVT5mvtVq5XPTC1PJA0aD1/Xihx+tzOLtoJRze4+usAJc/167qx4823WXPTlN35R8mAPviRu1TJR2JTBs1M9rKAi8zBORph9MYsBFwh86LkPu8M7fcQDtFEn/JNh89uf33CQx/P//TQ/C15c6VXph0R0mHXGwl1sLAo2lAeUgVAMNVnB3+bvLTwXcTyo3hrpG4+GutL86QI/6Xb7kxsZnVQ9dLhwnZDqoI13mN4vPaPm/NsE6va4lsGpWa5QLQBNl/Qz1Kt8xUV28pg66Df3Nj0fe42KtmuKOEUKmzhF4MUzKCu0E3Kr2pi8WCk44Bl6rKWclSgq6xwmYYimPTzpfTJ6ftUNsUfZoJw+CLuKuzWA3QKK86mkjVoyvKCpxwPcyv7D152w4Jz/idSdd0PbAPbXDFZR/nyDijrJMqOLxJH09f2Ax+DSY6d1x/4Lwm+o1RRaSfCje4gFn9YVazgnhZLtganeHo+4cI7VC9syG10hiefLTfX8VPc2vvdyQPZ5c4on1uKUjErDc9x8rZ8h7HW5GGy2wgjeoJboA3E+cGxFUI7BLuOr/D1ESKrrWkq2lCHKUftoPscKE9unfQmfTWl6NRcxFuVhd/Vgqwmp2uh+Ht+5qNEGuYPdMCeAHGg3fnz8eTYaP4D0n/zY5Vus16X0DAlUWcACmrEpNP4rYYbanplq3Ik5rXxG5d9PTq2NjsBL7S1xzagdlOs4UJJ9iwcZdyFv3h1SmcrCWb7SyCi5wmMebUD2/O9aJYQlA0hJO7fNGc3QFQ8ZaBdbA5eZtThbsMnoeTJn5UFwYOcHN1Bd69vC22iNB49FNbMMLU9BILmd7Y8mtj4NcwgB0sq1fXy30Ethj6
 Pw8J3G5G
 T88RXap8RjLbYkXRrNMPbyAjUPl3u/vBNzbT6kSzapqwynwt5zWLjKJ/L6UDXd1nLrRFdE/7JK8uNkuwADKEAQRkBFvhaA37sVM58xWQvDfqDBLrwdvX5pEsp+axQwinulLgOs+goi82XiJpa+3S1bQ66CXbrxFDJyjMloLyskyQim2OKdKlcwR9KvAKvcc+qKfqKWlyF3xXT3DQ9T8pn+hEWb+BUouqbQpcJHMCIkrW8/1FytmX2ksMlV3LIZpcMEe+v4QpF67Ks3q+eOz30zPbVwx+Ld+J7VUvWT8wdCiBlKwgHNWAQff5d36StAXHkYUVW0doJ/aBV/8BbPDflJkJa/Oakr6oBQ1vuFcuH5Y1ec2CtxIdEtDxTZYuMRMciXpNpL/QnsEgJVWQHZIFjoFpswqnGKupEaCTT1djLMGJgvBUKG0yYxCMAtvZcjWkQt21gXJ4l+J5wmX5tpspTxamNjBXD6kBDv1D3qSS9E29UvZUYdJfLHuP9oGJizC0ceIBlmuyTxGUukQEh7VHSbM7DRy/57uZOlyfQnEGMt7ck5bRgUg25aaxK9t1DshBx5vfblYaz1XshMM0dXrocQfm7SFdkOby+fKb1B7UY26y2uoHrmLBaVITiXUJcyWzX5pFeE5fjk03DhKdhFg/ksjcn+mtGi2K3qnEBo9y72R/a7TI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] parisc: syscall fast path exposes uninitialized pt_regs to ptrace
--

commit 38a139df8c7c61e11fc9314b5f43e371c71a8356
Author: Christian Brauner <brauner@kernel.org>

parisc: commit fds on syscall exit

This commit adds TIF_FD_SLOTS and tests it in syscall_exit once the return
value has been saved. A task that reserved descriptors calls
do_syscall_trace_exit() to commit descriptors and then continues with the
usual checks.

> diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
> index e04c5d806c105..c5807cf6fbd8d 100644
> --- a/arch/parisc/kernel/entry.S
> +++ b/arch/parisc/kernel/entry.S

[ ... ]

> @@ -1765,6 +1767,16 @@ syscall_do_signal:
> =20
>  	b,n     syscall_check_sig
> =20
> +syscall_do_fd_slots:
> +	mfctl	%cr30,%r1
> +#ifdef CONFIG_64BIT
> +	ldo	-16(%r30),%r29			/* Reference param save area */
> +#endif
> +	ldo	TASK_REGS(%r1),%r26		/* struct pt_regs *regs */
> +	BL	do_syscall_trace_exit,%r2

[Severity: High]
Does this expose uninitialized kernel stack memory to a tracer?

When a process executes a system call that reserves a file descriptor slot,
it enters via the fast path which only saves a minimal set of registers to
TASK_REGS. If TIF_FD_SLOTS is set, the fast path directly invokes
do_syscall_trace_exit() here before all registers (like %r3-%r18) are saved.

> +	nop
> +	b,n	syscall_check_resched
> +
>  syscall_restore:
>  	mfctl	%cr30,%r1
> =20

[ ... ]

> diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
> index 1d9e210702e1f..f142766792afa 100644
> --- a/arch/parisc/kernel/ptrace.c
> +++ b/arch/parisc/kernel/ptrace.c

[ ... ]

> @@ -381,6 +382,9 @@ void do_syscall_trace_exit(struct pt_regs *regs)
>  	int stepping =3D test_thread_flag(TIF_SINGLESTEP) ||
>  		test_thread_flag(TIF_BLOCKSTEP);
> =20
> +	if (test_thread_flag(TIF_FD_SLOTS))
> +		fd_slots_commit(regs);
> +
>  	audit_syscall_exit(regs);
> =20
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS

[ ... ]

>  	if (stepping || test_thread_flag(TIF_SYSCALL_TRACE))
>  		ptrace_report_syscall_exit(regs, stepping);
>  }

[Severity: High]
If a tracer attaches concurrently while the process is blocked in a file
descriptor allocation syscall, setting TIF_SYSCALL_TRACE, won't this call p=
ass
the incompletely initialized pt_regs from the fast path to the tracing
subsystem?

This could allow an unprivileged user attaching a tracer to their own proce=
ss
to read uninitialized kernel memory via PTRACE_GETREGS. Also, tracer
modifications via PTRACE_SETREGS to these uninitialized registers would be
ignored because the fast path does not properly restore them before returni=
ng
to userspace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D14

