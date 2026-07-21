Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68B9C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93DA6B00B2; Tue, 21 Jul 2026 04:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F046B00B6; Tue, 21 Jul 2026 04:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83B76B00B8; Tue, 21 Jul 2026 04:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4636B00B2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:55:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3ED74039B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:55:18 +0000 (UTC)
X-FDA: 85012174758.24.A047F00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 294484000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:55:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iisKK8sg;
	spf=pass (imf01.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+udoP9bpLuD/FuhqJDkgPC7XrvFSE/5o+cm7TZnYZm0=;
	b=UG4/EQFtQk/2bvZ9EhReHZJ9BddwEyRRGKZ+spnrFTWEN1d7cq1iKq/gnRKqsnXGrMBvBE
	i65hiqxU7BEaOVMxYA8K9Pa5BcheW9Dhh5D+PnilxXIR45gC9cw4YtdPKDqSUthFHWFzC+
	yPmYokiDAHW+IviVLElrMGiz5B3HwP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624117;
	b=yFutLB8WiK9DlrWi67vFIWl5jUBwQURCApH80jaKc+BAKEkGjA1lodqN1Pz+gm/giDDo7s
	xJg+Ymlg8SehgToJVIvOADNFDNX5G+8bs3f1MoyfW+HjtTJt04PggMPdCv6KyxuoGaDzUD
	Z0f/kjk0kXyZL+FeADRuEvBASK1lBpQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iisKK8sg;
	spf=pass (imf01.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E9B660AA2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474511F00ADB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784624116;
	bh=+udoP9bpLuD/FuhqJDkgPC7XrvFSE/5o+cm7TZnYZm0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iisKK8sgq0MTBZx1da6Nfg41IiKRkWZCAiUOSPwGEm+wlYS2rqO7wwO5/HLCFiBBo
	 CspqHpcL/uVDH3P7vAe4fgtPhceAyBTgadzGCLJ8uqmorXPGBg4wEdLCUOAI4NszEs
	 dUK3jcdUHV+oFNjBOAQxn5G/1jvPznsNxtNgX/PQ/uW10QxFHseaePD+BVZqjrfy9C
	 NkByULDo3F6mVgZ1qD9CEFEbXnp0jLt4rf23/2AKt32jcvobVHQfmVpY8V1nL5u501
	 vDIxdUTOTZ+sjUgAP9LXiJQO5LJK96y0uVZhAiTSVwobT8Hat/e1eEmdU1ohpKqpHU
	 t4+P1OAS9kpNA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so1413392e87.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:55:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnHLjijRMSNT07e+YSDnxP15nEbtHUzBIrcgt9zeLQ1aeOjhlSz55FrtGLoFsNS3aemhAzQ8r6UQ==@kvack.org
X-Gm-Message-State: AOJu0YwtIyvWv1bTabJBASDN98V42sPd9YwMHh5ctdGVeG6+f9kSoWdH
	Q8fuzX9XBQ+2Ipj3skjPn5/fgWzInYIpeQrfqXePLw7vqO64jS80Qgf9Ubk6DHv8xTXvPLJh35z
	a6fx9AugJtm3/3+0CZyQOhJXDlch9a5w=
X-Received: by 2002:a05:6512:6d2:b0:5ae:b792:7f1e with SMTP id
 2adb3069b0e04-5b28f9ac8bbmr4154050e87.30.1784624115027; Tue, 21 Jul 2026
 01:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-16-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-16-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:55:03 +0200
X-Gmail-Original-Message-ID: <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
X-Gm-Features: AUfX_mzzb3lQ09c4zH2YPpivf-4j4IDejfx1qyUuGSOUbGFbX3JjubmvWtjOIvU
Message-ID: <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, oleg@redhat.com, 
	luto@amacapital.net, wad@chromium.org, thuth@redhat.com, peterz@infradead.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, anshuman.khandual@arm.com, james.morse@arm.com, 
	tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 294484000E
X-Stat-Signature: 9r11tb1bo4wh3cca15a11khooieowpu8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784624116-468287
X-HE-Meta: U2FsdGVkX1/zKLP787tWnDWE8dBFAOQ6SeYkKlM7yI1iK9rsxD36B0KCaQ0GSO6FZCfTiA1sXKmKMHxndF+0HxBs3I608kj4knccllET7MI5eP7fak5jguq/4ls+vLykOU6tfaOsI7Imm119JJ22re8aHn85Ba6kIRlol3wS9nmGI9crF+Fs+3AjLOhaF5Yy7xScs2qAtfjbodjJjjUE58mG/Gz++mPQaqou74Koygej4I24FpCQneuyGXS5h1vnegkWH5pd27gxwCtg9p73//bmJgiJKbTmdIW4HvxcJ5ifqOC6RK1c0pKEkV0h4XyK7+/kUoDpO4ekztceW9bbggdkdLpwhTC26eE8IdwAaXO2RFnNenI7v7gMkqruUpTtHSafEPwoBt0Z2deoUOQGw6JURfwhKTXCIU9itvn5Ea21MLVgQqqVg9CygB6Hau5TGHGWKPKL9BVUk81KkvUIeGALanjDKLl3w7cnsGaz9shHZUVeWiGI5OmnUI5FseKXK5EomReCASzldYDy+i8DqtyicPI9DHpD+mpiXtwVvyuHlBvA6TnBtgmu3y1ZCqpn6o4ZR1wTh4bLo/CrLqNRSJ3pJ/a05Vtpn6i60kw+NcSXeIKiFToq+1xfFoyb8FSVd88yxqBmpbGnum1MCPTpr/0FW0h7sJ2qrS4C8q2m425hxtfhY17PPWI3bxViCMoq3DRIyfFhbSPTMSoC5xj/2LhoDk+qtUamGS+uK2tzchNiknHX6lZgYduLtZdt7gRiqiQ3XapDpglJKjwoAfQbE2TGJTadThJkJhUPlZWd9y/1OaW8RlgSmrcgV4/Ti/gZ3eHSLn/A4Y/ddvfblJrn8cYpPRisfPF3LiM+ENj1kZIdnqrOX3nKDL50RiiIzGRBJl7CCsWEluEQjEpPVNQ5MhqjYb525Z3jLkwb6BmIgEFZjXDYiUdio3r+jMCs2M6gFiyP/y+1yuDN0mlMyF4
 lJohZJGs
 g95VZVq0oel3koUd2E6vQHuw1IpAtMrY8G/Ngw0gjOwnNQLc7nREOGZNtbIZzvbM3BYVM9ZdNaNbaZWlmVH/IAkbv7w2ZZWaZJeCJBcktSFHnVcdcv8A6a+EZedFjw5eS4vYguk+tcXBatAbNzXeGa4ucUnE64sFnu8NCAowPT1ezhc9r7qj90p9kjswBY2+aN3mQOMU9qkFLxtiGBF+IfAuXQevozje68xN3bKUk1g8DCrrSLbaCiLDD9SoFanGJVDwccaCxqQ4jbsYAzAHe/CxuYQLZsE/GS/1X5IwVBeQP9qhNAVYMMeaWIstH7j2zv0poojkQmSNyvoAfL3g6I36QCZNnXqctn5SW3ALHn39/cwMZuopfV6J/NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> Syscall User Dispatch (SUD) must not intercept the signal trampoline
> code, otherwise returning from a signal with a locked selector may
> cause infinite recursion into the signal handler.
>
> Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
> to exclude these sigreturn syscalls from dispatch.
>
> For native 64-bit tasks, check whether the current PC matches the 'svc #0=
'
> instruction inside the vDSO sigreturn trampoline (defined in
> arch/arm64/kernel/vdso/sigreturn.S as below).
>
>         SYM_CODE_START(__kernel_rt_sigreturn)
>                 mov     x8, #__NR_rt_sigreturn
>                 svc     #0
>         SYM_CODE_END(__kernel_rt_sigreturn)
>
> For COMPAT tasks, verify that the instruction falls within the dedicated
> 'sigpage' range, since compat signal handlers use this architecture-
> specific page (not the vDSO) for their return trampoline. This prevents
> SUD from incorrectly dispatching syscalls issued during signal return.
>
> Suggested-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: kemal <kmal@cock.li>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

I'm a bit scared about SUD.

Certainly we can merge patches 1-14 first and iron out
any trouble related to that and split this off so a separate
series to be applied lated?

Yours,
Linus Walleij

