Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB14C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452386B009D; Tue, 15 Sep 2026 08:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A3C6B009E; Tue, 15 Sep 2026 08:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366EE6B009F; Tue, 15 Sep 2026 08:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12FEA6B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:00:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62EC11203FE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:00:16 +0000 (UTC)
X-FDA: 85215853632.23.5F3F30F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8DE82000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:00:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdJ8EfCA;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473614;
	b=jQJXqwP2Hq0QUpbZR5cCNZDPxGDlyY/i/9dzn33Rp4rWCsyRkpyzHckaKIxS1tiU9KZgUu
	BFaATwFCVZUbQrpmRjIwODXnzAQheV8EV+3oAN8QXm37YzKL0jrJCS+SnCLJKEfD407jsA
	V6hnQidNv8DBCjyj53YuYs+sFOm5GFQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdJ8EfCA;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473614;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkRrGN3tHH0vPXJQpfXyuI1f/hj84726OJ+wXiSAjkY=;
	b=WMszHrdzb++4WyQWBLQzyho2OQ8cEMVmGrGuFzmjmGPJud2hobqnTY75/ZWBUqyoVQBSF6
	p8/UdrfR/nqFL7pDHeFDHMKOk5aUSJ5gU6LTzRlLvJ1FmOTcpECcce8ekD8Xkeuhz+EVVU
	5Eq+rzkSCUfDX1ttflDVDekBFHkZBs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C51DE41B2F;
	Tue, 15 Sep 2026 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59F81F000FF;
	Tue, 15 Sep 2026 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473613;
	bh=lkRrGN3tHH0vPXJQpfXyuI1f/hj84726OJ+wXiSAjkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bdJ8EfCAcKRLCnZZLr9KUFRKwzOp9HwWHqD8dKOgs2QECDixoCiY7OitpfSWybTgc
	 GrKy8T3cB5cVyun9gMM4tiazPAmkuvnRoSJn20gDY30Pi6NZ2BlWie/yV3J02KVzmP
	 +FdO4hMG7v/dI5BZjC8kuRbGxnY1BMC++7JlKDVKVVz2TBx0SWNpwMbRNY+KWbqJrn
	 ewEE2svDPg32d5ej4oQppZf8rSJTrU4fXT0CFb4RwzIPHo6I6kwXfOXCr0tMaXJRUv
	 nQKJqvUmQYSXF6bRUemMO3EjVCVESrcELW0g+JEeeCOWgYbp17E7wf+3S6taJJ6xjy
	 asi0ByODbGixg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 18/50] xtensa: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, linux-openrisc@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-hyperv@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, virtualization@lists.linux.dev, "Oleg
 Nesterov" <oleg@redhat.com>, linux-alpha@vger.kernel.org, kexec@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, dri-devel@lists.freedesktop.org, linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Jan
 Kara" <jack@suse.cz>, linux-um@lists.infradead.org, "Eugenio Perez" <eperezma@redhat.com>, "Jann
 Horn" <jannh@google.com>, bpf@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-snps-arc@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, sparclinux@vger.kernel.org, linux-mips@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-18-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-18-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:00:11 +0000
Message-Id: <20260915120011.D59F81F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8DE82000B
X-Stat-Signature: es1nwtx5k6wgms6imrqxzaxb3sxghtjh
X-Rspam-User: 
X-HE-Tag: 1789473614-487464
X-HE-Meta: U2FsdGVkX1/dV0xQeKz3+t9EnwdWjzXbieXA/B26OSdcMzmbcA8TN6Wr4hOIcTt77HSlm32/OMUZEdPjdJtmB4+8yELDH/7YQ8KDKRepIJtKqez3SLIJ3QRyRM2euAc1Hb7qzHChbeSJBeyBQ18HE85qN3J3mx5aQt54BhuLesjeI7To0/tnL81t3aa9laHAR8wDswj0C6Lg+c3OQ9st5ahZDSSaJvcdX2+uQTEUXbIm3zkXY41Sy9HlFsiniX77Xa9psQ2ETd7T3T5sb+BWbSaFhJoPDvTPidkFzbR/7dFBNmLlJruJ4VjKpCC4RE75XWErkXIUmXjAid/IqR+rnaozALixKf03hBWSEzDV1OGqpSaRkYVPnmGgQcBVm3Y2MjE1xVlWNGn5OCXmIqXC8kYpl085OP1ret57JMsA5WhGlCB0OEBb23ipb9gftG6JBYkd9q00okFcYa9DncQOuZavCD2NmNcUZ8yBvHiXW6ifd2OlHaav+X7G1kvE7i859rCUDggWMy+1rf3fh+zHvdPNHi9kAJK47UTGqQ9lisWz42f8Qywz3PZM9RNTZwTM64KsIhjlEFEu1NDkP6DCGWJZZOP0CBRaEd5Q4A5YHc83daQur4YvSgagCikwa0TlJKC9fUlEBsvK5VXKD4WyugU1dFUCpD5/jJIs43a92IE2wRxyntwV2L5K2r8g9/v8E9sGThQoRqKwpjU6ZfJ6qxk1US4nsbpRu1R8XHyeDqk+1scCiXHohm0Ui1FHzrN9PFcN3vl8AKVa1vUg+t4MM93/+xvpFxtopRXIwkAlKbrIJUPLuD7FctANRsWX9tqahagk3hkUMS/9c6ShXdaubktb/v7N2zleHbIGMqh0K8CyL5ip7XZmXpfXRd0opcmQfODhaIyQ+MYc/hmpy6JrCkZtiNlpEFzfLS6GxgxNn+/6lO0fKl1XNk/Tb/FoDIC3MB4KYwmLVoswb3VwaBr
 ezVyWT3s
 d+333dRji1KJFdIkaqX5rRJ+v1tuWhXOREgbDtu8JbxvDdm5Z6tEVPIsR1QHyqeTeZIvu283gRb/+u5FR+Kaa01pW0QphCqyQFuBIA5eQtP0EuyD7m1SI9Paqdx8oQIk6jx6cecLNzM4EC8FqesYvNFRJJbGyEJeFNep3abw8odvccIPpCNP3Rtk9vMYNhWIlcWeOGYBQ4lh0IYqj5vfnErIJ/2FrysHKm258Ni0T7TiE1j3bhvt5PYFk6CyBzQRap1sC5QaGF1Bh846fTVtPntwcMRFipsrchMok1MJQnIXE+hJlkcRqHy14ygVGVLaDsFyRQ1G7Sa1sJo9sveZKtx6fRO1lXuPw9XzwQFrwF+5jwJXkgY7hIK4tpcVm7FG2Ks1qSVzrilJCohjI28+G77GDhFwpNTwnwkyGUmYdxuK30YS+flyBZsAA/VOIW2o/KqKmhCjH3UsWHvtKyInIxo2Tkb8yr4aLE8bG5j0uP94S4PhSNbLtBwCCJY2ASUQbHicEvcjbXygAwgscCexBK8Lf5V022JMA1Yn779fosQsFjhiXEORMh4agEmrtpezeaderxI/c2mWMuNLfY0vbP4aYbpPzOidcH6wZ+x7lQXp7/a0q5QoJUgp/tTfgBAtokU7QkoF/xPHg2L4URBXPy/LlJPrMz/GVM3Z6YSp0Nvi58fM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] xtensa: inconsistent mid-syscall ptrace exit tracing due to stal=
e flags
--

commit f64c69fbd6ff1a2ee8dd26645f9d56d2d371647e
Author: Christian Brauner <brauner@kernel.org>

xtensa: commit fds on syscall exit

Add TIF_FD_SLOTS and test it once the system call has stored its
return value. A task that reserved descriptors uses the traced path.

[ ... ]

> diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
> index 272fff587907f..4b95f48736e6b 100644
> --- a/arch/xtensa/kernel/entry.S
> +++ b/arch/xtensa/kernel/entry.S
> @@ -1976,6 +1976,11 @@ ENTRY(system_call)
>  1:	/* regs->areg[2] =3D return_value */
> =20
>  	s32i	abi_rv, abi_saved0, PT_AREG2
> +
> +	/* descriptors reserved by the syscall are committed in do_syscall_trac=
e_leave */
> +	GET_THREAD_INFO(a4, a1)
> +	l32i	a4, a4, TI_FLAGS
> +	bbsi.l	a4, TIF_FD_SLOTS, 1f
>  	bnez	abi_saved1, 1f

[Severity: Medium]
Does this introduce a regression leading to inconsistent ptrace
observability?

The exit path in system_call() dynamically checks TIF_FD_SLOTS from fresh
thread flags (loaded into a4), but falls back to abi_saved1 for trace work.

Earlier in system_call(), abi_saved1 is cached before executing the syscall:

    GET_THREAD_INFO(a4, a1)
    l32i    abi_saved1, a4, TI_FLAGS
    movi    a4, _TIF_WORK_MASK
    and     abi_saved1, abi_saved1, a4

If a tracer attaches mid-syscall (e.g. using PTRACE_ATTACH on an Xtensa
process currently blocked inside a system call), wouldn't the exit trace
events be missed for most syscalls because abi_saved1 lacks the new flags,
yet mysteriously be caught if the syscall happens to allocate a file
descriptor (because TIF_FD_SLOTS is checked against the fresh TI_FLAGS)?

Could we reload the fresh _TIF_WORK_MASK from thread_info here instead of
relying on the stale abi_saved1 cache?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D18

