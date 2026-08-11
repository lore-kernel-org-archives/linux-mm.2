Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41FA7C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BB36B008C; Tue, 11 Aug 2026 00:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363956B0092; Tue, 11 Aug 2026 00:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279A96B0093; Tue, 11 Aug 2026 00:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 094B86B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:59:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 819F1140323
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:59:06 +0000 (UTC)
X-FDA: 85087784292.21.347EC90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3006100007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:59:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx25TPM0;
	spf=pass (imf14.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786424344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpmP0/V/f3nYUUeEX4OZFCdq3p8rw9FlptRhR3LAYSI=;
	b=zYcuOhYpQzsn+cRbCIbtM1Ed/F4fChiqaT1NkzujdBjt0r+gMd8+zlsb/3ttvbyEhYfrLd
	GLeGA5bCts/BtbwYNEg0hnDUFXy3qxxpGqBVrHpKjjwpzao/PkwNsm9BbSyzYj7bpf/4oR
	jgP2vGuBz/NruIFNxKZgKCwPg9WcaAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786424344;
	b=i2Vhy5FPmAYYBOpm/MtSqXLuHHpttuAuCaAx/NpQiXervVXs73UHjwRyAiVs6Sl6CPo9A1
	eWpcsZcJS5ojEZWfxiOvClmCnYvc7im+OWgAyMlDV1HTnq0iPWtmhTKLfkgeFTQUIHo5XM
	D2rMUkB6NI3MYBVHim0PnXmGSui1G9U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx25TPM0;
	spf=pass (imf14.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2CFD4185F;
	Tue, 11 Aug 2026 04:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56CC1F000E9;
	Tue, 11 Aug 2026 04:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786424343;
	bh=VpmP0/V/f3nYUUeEX4OZFCdq3p8rw9FlptRhR3LAYSI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Gx25TPM0IQQuJ6Jt9Y43E/IQ6dVfolSgn1TdiB0fleynDN7oPw4YRKYboFKtHg0NQ
	 EEX2jrLsp9v7+TlvUug+fBMqZzhfA83Cq+U5WQmeChknJ8ifPDPeSHFC2vPHKut2UZ
	 Oi5FQmgTR3oHER0N/FVFX/uzLCzJWNlEVEBk5HWg04NUwj8iVsiv0pPd/GKgED8J+J
	 fAzQaSFMzQfJRQGSIjIIR5aKOVyEbltgSQ0S6UrTEvqyMalGkxVwPmGllSBpk3iu5u
	 WHMes8RO1gPlhZ941IvwOV5zoYeCQFQZyhmvNwqornTBtjS24uPtHpDWfPaJ93zjRF
	 bXnBuiQdQYHNA==
Message-ID: <eff5c192-ed33-44e8-8834-fa5b4803f39b@kernel.org>
Date: Tue, 11 Aug 2026 06:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] powerpc: userspace processes crash in ld64.so.2 when
 running recent linux-next kernels
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Ritesh Harjani <riteshh@linux.ibm.com>,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, ajd@linux.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <75419f88-eab9-444b-bf97-28a9765819ad@linux.ibm.com>
 <627c5c2f-a0b3-4fba-811f-7b4ed4c74dbb@linux.ibm.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <627c5c2f-a0b3-4fba-811f-7b4ed4c74dbb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bhdx58rpi5g9izmtiqfqxz51f7cfzo99
X-Rspamd-Queue-Id: C3006100007
X-HE-Tag: 1786424344-136918
X-HE-Meta: U2FsdGVkX1/F/0ylahzoIJ3yOgwPBc8b0NhbShSjWtmzUP8GFpOm4+J/5LD5eomsxZ3JY2rzdOJz0re1YvZvS75Xm8jLHEijgNmDjlbGpUBmKoeZO2b6+Qcq6O8e4GhpdzKW23PPLiUP12HXBqw804PeIydggcPu0ePRj2k9j3hjsIOp5XouoLjTjN1vHHwKYX5QlMSnym1cEgK2XZwVSZAZ/dcFtJ5QJXOvKgLlD/w577tfowtGFVJk9Ee06usEQD4TS6ml/7w76UMjTRiWbU1DCxPANFcxPrz+YsQEujt3fLb7EfoBWtmESGw18n7rG6Ffq0l354jYcdF9E5rdA1xwfD5ER87T5uOYLSgLXGFzOQeZw/cr0QPfeh3N4rHjgZTFy04fgjVJH2au6Zr88k9ze+dU2k7zmb90u2mt01bnF6swRdP1sPlMKUw5tB+BWKVoW9aX6SX4N9W4LxONdK3gnxAY46c6j3v5MwluNw8lPiAKaLn4/ZUTGB0gfFY2xVZTz9mXqbOk2b8RD3459YCcqe5IVeRcPWytXOZHyqrCtjlYpGVb4Guf0DbelU5WyI3HUN6uWNLURiQ6jaxESuVUODC/rT1HKZ/6XmyH8boqk4F7kAwAsBs2EKa01ji6HP9lowS7vIT+8UPJqyONxNlT3BV01unvmykewWSLTih2IFQ7UCIw0rSuT+lWSAhSlghHmRLe6SGid4YIGSUF8VsNsYV5Y1WDxtZOZ7gXQE637RMdKTKigei7kUmrFIACnqnZ780a1ejsT0OY+oaBvdhSLspZAQAXu/8hBVqOzEgyq/q/VYEFYrLlzmF9u8cIK42DiFBZmSO+qqhfUZirKkQLZ/yNKJC8TOu1QY+fiZAZMHjlaNagUzA1P6+C/+X1qDD2d7+9sEMb267UCUhPi2xD7BPg/WGO8szWRj4AWVYz9ef5lvUc6DjE6Elbtj6VS6B2/SK5PzxKHXmiQfh
 hvIcNIuu
 8+QCsqTPcApLFvH430G9RLtW0wjLA31XT5/u9Yq+3rqIXI+BYwc50LwuUHvhXagsKuxr1USshldxTFhvPDO0f75OVc7ZYLq4jE+Jxozi6feIVTWHuqBg4fYBsojYxm8/vmOzJAxIMqh4F8y258oMndrXKpswzh4z2W0YvCDmHHBFdHzpf4WWx55f7cEvmmyiRwifM+7DdhCbd5g30Mnf2fS3ywmjXVyHjJXsCyb6uJ+LjBd2Nmr+zfqF7eCrlLP4tQr0Di6Osyzg6KwsM2dqA4yzQUcObRDtYlH4tuxljM+/WZfd0IYRiL4hY5bmK3x9xiQRt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 11/08/2026 à 06:23, Venkat Rao Bagalkote a écrit :
> 
> As part of debugging and suggested by Maddy, I reverted the following 
> commit:
> 
>    263e5159e00a ("powerpc: Fix exit_flags field placement in pt_regs for 
> ptrace")
> 
> and rebuilt/booted linux-next with only that change reverted.
> 
> After booting the reverted kernel, I rebuilt the latest upstream kernel
> using the same userspace and toolchain. The build completed
> successfully and I did not observe any of the ld64.so.2 userspace
> segfaults that were previously seen during kernel compilation.
> 
> Kernel used for testing:
> 
>    7.2.0-rc5-next-20260731-00001-g79d9c1ce90a9
> 
> Top of tree:
> 
>    commit 79d9c1ce90a9873422ca4d6d0124a1d1c10a098c
>    Revert "powerpc: Fix exit_flags field placement in pt_regs for ptrace"
> 
> The upstream kernel build completed successfully:
> 
>    INSTALL /lib/modules/7.2.0-rc7/kernel/net/openvswitch/vport-gre.ko
>    DEPMOD  /lib/modules/7.2.0-rc7
>    INSTALL /boot
> 
> Based on this testing, reverting commit 263e5159e00a appears to
> eliminate the random userspace crashes observed during kernel builds,
> suggesting that the issue may be related to that change.

But commit 263e5159e00a fixes commit d7a6797e0bc1 ("powerpc: add 
exit_flags field in pt_regs"), by reverting commit 263e5159e00a you 
re-introduce other bugs.

It's a bit difficult to see what commit 263e5159e00a is doing exactly, 
most of it is a revert of commit d7a6797e0bc1 but it does something 
instead. Need to see what remains with both commits applied.

Christophe

