Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6689CC982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD3D6B0092; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785036B0093; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A5A6B009D; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3A26B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:59:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D3E61603A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:59:58 +0000 (UTC)
X-FDA: 85215852876.22.7C048B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EEA3A0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:59:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuDfDBIp;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473597;
	b=DUoJicc6QHmg6q+opCl6HxR+qOjffMjfhBM86wD11MbXfV6126EN8ybkjUxBFLi/+FhmFc
	oSezE8+7tg+gD+pS2sax5+NfhxgwlqN72QvWCR7uLBrNQ2atq/uLlLDSbBd7YRlRjqa74E
	/SaHFwaRTHxA8oNpVFIVnRBXQBjx6YI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuDfDBIp;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XROzleDAWNHKip4xHBVteIb0cCuN7FAQoMQU9zewp/g=;
	b=IS8jwwUqve9E5kU5C144q6vRDC9chVaLsCwriJ8GEKrBbitNCNh3suYIGfgBfP3IKoz8rt
	LcowjI/HFhzjpn4bTJY2/OLcUzM2y92FqSqj8ngsAgmOVaucUVYtxDmjxlKsw8j5vfW0iz
	x0ctXVm6cZZGhOQhfkY+W3ZelB7CwK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A98B602BE;
	Tue, 15 Sep 2026 11:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B93C1F00893;
	Tue, 15 Sep 2026 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473596;
	bh=XROzleDAWNHKip4xHBVteIb0cCuN7FAQoMQU9zewp/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LuDfDBIpgc+rUudqugD7YWLMIYTyPSh1djqeFTSZvIqwl+MCFr2F9Jod5sQ3BdeBH
	 Fs4P2kaC4Rq/e2WctPCUaANEEugIP/+ZEAefkQjg3r930Bx3+wPmgnd43osNu5U8C9
	 EyuNiUbu78gNfTdrTeVFFD2nhC1r5SHLm94AIfGff4/9p19OhtUCSOkAUYL8ijEd9H
	 l9DN/Fa9wQdaggqiklG21wysLrbu7J9tNRHYcAgnuhIFYUQdGWbvPhv23a8BBnteix
	 dj3Dz8036WkGhtwkv8ziLkCVxCa1RZBk5Y1nQhcVea1ZYeF0cF/u11/S008mj3HeiR
	 /EId/I6+w1CIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 05/50] ARM: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-um@lists.infradead.org, linux-openrisc@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, bpf@vger.kernel.org, linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-gpio@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, virtualization@lists.linux.dev, "Jan Kara" <jack@suse.cz>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-hyperv@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-alpha@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org, io-uring@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, kvm@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, "David
 Airlie" <airlied@redhat.com>, linuxppc-dev@lists.ozlabs.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jann Horn" <jannh@google.com>, linux-sh@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org, linux-mips@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, kexec@lists.infradead.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-5-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-5-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:59:54 +0000
Message-Id: <20260915115954.7B93C1F00893@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0EEA3A0004
X-Stat-Signature: dxwr5dn934n6y6h3cag9s89qgiawwsmp
X-Rspam-User: 
X-HE-Tag: 1789473596-900819
X-HE-Meta: U2FsdGVkX1+pOXGYJxAsQbfCl8SxvyTxnclyaJxMRhuEQWxbXyltoXjh9Q+5+Roa0AQG1BGLanoohCoZvRuMJGOis+K+7F5bRMQB1vu5LkBgCVz1eA8lFf09tzJ1N4Yij9cmsu0VPWIvnJtLI8khxo/yIV50cYoRKq2cAjKM4wSzYhynvOczezpwJLJbZQy7hXslh1kaS4+jWLHhUs8Ra1lfYKZYFabS50MZPBbbGE+akDoEqT+oGqhE52kcG/Eu5RJIvZCFyyXrIeQWBq4NLA8Tisx/wa941axijl7uuBFruLGsL1f7ERWqdDrMY0kxzwCAPubRMvb51ZfbZuiLv7U99V/RWsaavCZukcRRv3QMqq9oTa0Zlww3TElNbwwiiurS+5enj5nDOKXFGATEaAE0RMFsuBC8uZpfajuHHm9vFNCRMVV4RJlYUuhRZpFMjJbDzxQE0HFzT2shKR/ZpGB0yvgcbVeuSggJAlbkUjE5QdACvXIX8hajdCsXVilHdYiPGMnBIniZ5VZruUM+ODrhKxjkQFkEG6FOxeB7xTiLd5zoJcZ40mBf24hyuQAJnFYD55tVDFexU1dCMZ12BNzu4kSC33Jp2TV/4FJwVAFrZtcEVVlOnzwvN2H05clS08eVKR4sgjEw+FUadIFZnPlX5XF3/BxnoQgebJYYAH0ZWWsE2FdnjMm2IIkWk+JcG9DwG+ZzGx9wPE+pi+B1ShQACRUncFj6bc7Zgzhs/2Deu/1rXjV6Fd0zsFAoyAbUT/eOPJL42HnQjNzpKWlW7jylrpGVUSFylju2Zf0iwMEVYjKFwxQNOZdaS/s7M0pCOrVvl8gV7aWgOFEe6jFoBh+G/OyAXqXBdri8NA2gQgfzTmFl1REG0D9DlNkIgUsdaE+AtvUGHWf1PVZxfiVeisDNcQM7mcTWhzFQel6h99zpOggwJVq2dcoVD5y2ugsLWZq4nZT3elTYJCY3/H7
 sK1gr359
 ZqbRHTaDgsnOEkpxLYUqSHe9VYDNIwHivUxKwqMT+klhe5dOXTs3EA7S6OGa1KWV0zD/vguYGQSv32niCUVWYcmbvPHyVZDYp679OT6NTvxUYj/Ib66UwZF+nbCqWDsV0IU3Cfhi3bsWlSsgoRKO/sH8kA6l+jEGqVbn208iaRqDO6EHhvHCM4uplu6j0im+yhmz7WSev9Me1ELMA7wBA1+QRlpKh9jej7NiZcYiptSUV7SENtgG3H2OY4kemLW7GrEGmW2JSO+2pMqN7mGYNn+GuLPxvwIKXTtjcJo1bVUzJ0mJdP9vI6+ifD18b2g41934y+lg0nVjPnW2GE2r7/yAGE2oQvg+N+F4KHAif/OJi6ZQKrPqxki4CDJDA4nD5ynvakp3NPPeT41CXQOvtth8p17nklwgtaPdHCQ1FmoeoMCqwSnKfEAHXabppDgaMwNGjTluSjdHKatzZlh5JWXljOcNjeOYRRYmcl4eCNXHKBTh+21GmeTenKMQXhHKwnO33K/+EBt6uZ3etkQa28lYNpsSzDa7xitCKVGrhrXLNvL0ysNdvd9IB0UFCJ68Hbg/5dbVqFRo/+sYTT+mbNWyOmDXpvR23/kBH60rQqK+sb8lyNoYreGzmj6mlzpHPJAQJUaCKOvmDpYi3ZUzODSTC4jC+4GGvsYLNFc5ODNg6ub8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] arm: redundant TIF_FD_SLOTS check due to bit-shift overlap
--

commit bdf52635177f575c1b58cdb7e902386551a36647
Author: Christian Brauner <brauner@kernel.org>

ARM: commit fds on syscall exit

Add TIF_FD_SLOTS and test it where the syscall return path decides
between the syscall work and the plain work pending slow path. A task
that reserved descriptors goes through __sys_trace_return_nosave
where syscall_trace_exit() commits them before audit and the ptrace
exit stop.

> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-commo=
n.S
> index 88336a1292bb7..59a70d90b0b61 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S

[ ... ]

> @@ -83,6 +83,8 @@ ENDPROC(ret_fast_syscall)
> =20
>  	tst	r1, #_TIF_SYSCALL_WORK
>  	bne	__sys_trace_return_nosave
> +	tst	r1, #(_TIF_FD_SLOTS << 16)	@ r1 holds TI_FLAGS << 16
> +	bne	__sys_trace_return_nosave

[Severity: Low]
Is this newly added check reachable?

The preceding tst r1, #_TIF_SYSCALL_WORK instruction appears to intercept
the branch because it inadvertently catches this condition.

In ret_fast_syscall, r1 is loaded with TI_FLAGS << 16. TIF_FD_SLOTS is
bit 5, so shifting it by 16 places it at bit 21 in r1.

_TIF_SYSCALL_WORK naturally includes bit 21 (_TIF_SYSCALL_AUDIT). Because of
this bit-shift overlap, the first test against _TIF_SYSCALL_WORK will
evaluate to non-zero whenever TIF_FD_SLOTS is set. This means the branch to
__sys_trace_return_nosave is taken early, making the new tst instruction
unreachable dead code.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D5

