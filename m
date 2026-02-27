Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D35DFD7F90
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CB56B0005; Fri, 27 Feb 2026 05:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219E76B0088; Fri, 27 Feb 2026 05:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF1D6B0089; Fri, 27 Feb 2026 05:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBCCE6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:55:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A221596E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:55:24 +0000 (UTC)
X-FDA: 84489930168.13.9372225
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5E15F180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:55:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziswiler.com header.s=s1-ionos header.b=kvaOnlAQ;
	dmarc=pass (policy=none) header.from=ziswiler.com;
	spf=pass (imf06.hostedemail.com: domain of marcel@ziswiler.com designates 74.208.4.194 as permitted sender) smtp.mailfrom=marcel@ziswiler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772189722; a=rsa-sha256;
	cv=none;
	b=wuRgkVCSTHZAuPy5Z109OTmOu+jl/dMCVkQVb0X08rK5+wW4gUwrZo5ZqjIfSdOY4IxBZu
	0MnoZrd4qG1+d5SGkU0B5I/5dfdhguBOBXoRRburQD2o0dS/mspGbpC9Eif1YVBPWb4efH
	VsOicv4/aLVHlZmgeRC9lcJYyvouyPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziswiler.com header.s=s1-ionos header.b=kvaOnlAQ;
	dmarc=pass (policy=none) header.from=ziswiler.com;
	spf=pass (imf06.hostedemail.com: domain of marcel@ziswiler.com designates 74.208.4.194 as permitted sender) smtp.mailfrom=marcel@ziswiler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772189722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyFGZnhkCDmplKwplIYatSCSWGTAEQ+3aRFjhHnYafc=;
	b=5vigiHfChESRkXlwtnLutQ069iTnXtiasIvdteXkQXyM7HptCNkGADpbvg5jk/cFIoWMqK
	aPUYilKE1lb6yL9V045kHu1LyJVG4Zx+4H/1K5VKGmdf3ZfwopdS44y0FcBYYF///rzBuc
	pIZEfUvdvPMLg1NZJLAUv0muR9L+mwU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ziswiler.com;
	s=s1-ionos; t=1772189713; x=1772794513; i=marcel@ziswiler.com;
	bh=JyFGZnhkCDmplKwplIYatSCSWGTAEQ+3aRFjhHnYafc=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kvaOnlAQi+lwkujcaUXQnO6rygGM08xpCHqocpHdxZAq+EUe54z6NtSg4kN8OAcu
	 O7Rclntg1NwDbiWloFpfvnQLASw8vkGN79sZZI+LiIO1uzjHG+q48X/GAL98xcUeO
	 Ne4p6js+PxJ15UHUkpoeUqiZ6OPQ11KsWA8YhUiALyItOrNvSPfW0E9n4yKyQh4gr
	 iPYdQMN3BkE+s4rk8xSlDB45MpNhTk3aEeZ7of2CT6WTkuZBcudMvJjcz3sKOrsGd
	 /ErBldEDbPwKKGBoEi98UU5jpWe88JFzHvzw4rcidh3Lluka4iaeY4CiNkKcbzGzz
	 An4df2cAcC2VnvnZ3Q==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from client.hidden.invalid by mrelay.perfora.net (mreueus002
 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MfFYy-1wKaBm3H4s-00XVO9; Fri, 27 Feb
 2026 11:55:13 +0100
Message-ID: <d4e44b3659859e8967a1cee7cbbeeeeb399a4536.camel@ziswiler.com>
Subject: Re: [PATCH v3 00/22] riscv: Memory type control for platforms with
 physical memory aliases
From: Marcel Ziswiler <marcel@ziswiler.com>
To: patchwork-bot+linux-riscv@kernel.org, Samuel Holland
	 <samuel.holland@sifive.com>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com, pjw@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, 
	devicetree@vger.kernel.org, surenb@google.com,
 linux-kernel@vger.kernel.org, 	rppt@kernel.org, mhocko@suse.com,
 conor@kernel.org, lorenzo.stoakes@oracle.com, 	krzk+dt@kernel.org,
 alex@ghiti.fr, kernel@esmil.dk, robh+dt@kernel.org, 	vbabka@suse.cz,
 Liam.Howlett@oracle.com, apw@canonical.com, 	dwaipayanray1@gmail.com,
 joe@perches.com, Julia.Lawall@inria.fr, 	lukas.bulwahn@gmail.com,
 nicolas.palix@imag.fr
Date: Fri, 27 Feb 2026 11:54:54 +0100
In-Reply-To: <176613180179.3684357.1299267450443574866.git-patchwork-notify@kernel.org>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
	 <176613180179.3684357.1299267450443574866.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:UUplK9QahItW7favaUm4Q5d915hat+h5jRewnwaVbhTw3M+iOKz
 NivRKam2ukd6XrGztVMAx7ufnqFaS0o0H8sAT8En/yEU0449jeV6Yxky+IHFvxmzpiIHgqc
 e+oTWRBAZrV/b9JQcTj37R2Sw37SqeYcqEsP05M7zjZyx42P7HmWzbZLugPhPEWO73Nwlya
 she/PX5fYi+oGB3VOdNGg==
UI-OutboundReport: notjunk:1;M01:P0:+OThauVM/dQ=;T3PrC/aB3MTcKDZ+nVQmVOqdEzy
 N2dU66/j0l3knCkOxj2rAa+UJg/YnO5J1PIzW6lESBJD6kbcdblu29UNdIdexnMyMo5TD7mLi
 xESeyHnrqswHRBgoTrLyF4z8EkmVVcf159QIUGcYwNsoHmlt2GqMJpl3Jlfq6X6vUoeCvW4Qw
 EpGJ8jHXrd/cdgRe0UTOeoG8ItQxw58irA8JBh3osLS3KQoaJ7jVaFGN3ClT65DPL+e4q+iwU
 G7h6mnG1tsz6MXmFgemKc/9RFQ8XiJYXoQLHLr5+8cStFq2o+hNptRm5XB1XIeN8d/5CLPapC
 PHUyXxQAsqvWlNydi2rKGqFDL3qXSV2RQLmWH6PgEtDKnOE7BwEsmFyeY4U3GBeBc+7ND5voB
 EymOExcGAtoMaudGa3ODaRMiXG+zwzfDm15svkSNXeQU+vo8H+8lgzRtJNVLJdeQTiR3mTCOF
 7CscIhpLNsE/hHOd2Rch2OboqBLstKm8IbvCsKvXSIIuzM6LwAbOVAryP7H5z8hu9ACpF/w+d
 TzQJXjoTKtExhIns58/uDKt/FtqAr0HjPbmyOslIxYKWckkY9qq3aviEEOXzas6z7eFy6HHaQ
 hDnWevq1H9cXkwhc2iH0/U6TRNP48auqCeXyX+oaDv5P5pFU0AcFkmfKydm5UzBS3hGDGrZI2
 nZx6pwYAv5X04i6sc+vZb7J+WJg9S8xKErLFlnBxYU8g+lrl2I8cc3X/TUPz5rLO+EMBMpGWM
 KY4yMDBgChMOWfyFl4ju+copjhjJM+91bO+Y4SytOJ9sLq3JwWxuoQwJNFkQ8tt9ybvhItoMH
 DPmzdUlYciRUuQHVZAzNO6mXRKtov+xLyhVWnookBjNUUEBBI33VkoXKKphBhsJsVetJtkwhM
 byWhnSmGkTn7ok6pc9PC35OyJBiBOQN40yOfRj2AlKc7vfgaGqdwOtjMCGEjF/WDu6DZkrBt1
 zYcj4+M1OWxoy4+FZChdsX1auRtC7hXIKpzIKZcVyzlbbj9EOW/wifIbXzXy1f1+1eWsji9FG
 EjnDC2UfmcxsrQOueVdfMDddtKauvjq0kRl3OeDfUZMyhbAibXgCIjPagD1uXX3W7JDUIcl4b
 a1pPFbRPXgzxeVSb2iwy47sxyDrIOfNXsadHHiqKOl8x3p/CzRMo6ljG4tKtE/mG9/WdUvpLW
 9uPnvImuZ80X20rqPEqha2mMSy97lkrQsh0Oc8u4bx2IH/WltVVox1mXfcLPrJrj9uBBL1iR/
 jLtm7wyoOjakrucwgWhn0xsbBetL1xFlMPWS2dFvE+fnfgnti8e43NLDobz35JtA/X/RqZjgg
 P5mEyZdvdy6du3mbJuh1awV8wkGjXjFWoWV7IkcP4vrdzMPJYoBBLF8kuRItqQXJu8KbrTWOm
 to/3YCUwAlnXrM/JUQNMsKK9VOem1Q+iQXIiSwB7vxcn+CPwM+jteLn4LJ2YwtKTrw54BTd2h
 NBFxAFjRtRO48jN7+Rx5qGPd6tGGztTEEeFX6AC+yOxzNNFh0afUEOBaynVGMftjHK8Tp+0Ds
 GIRShmHNQoCBlDUCU11nTd13FkikovWXCQCqLBiBe/h3/XV58rGjtuuv6HezhlDQNA0oT7e+p
 Sq3KKjkzU9RuE4lFbHHkHFdg3q0CNE61wXE6QKU+Ue108FZt8pSZZsWIui2pg9mGA5j6rMzfi
 Z4GI4rJ8F/3zTi3qyYNxmEREKnbcSah2nJ9OGhkbAF0PzwAm9DdaRx7ZEqMwoF4qRxOc2lz2C
 1vAvmQX1rVRN0HtJM1f92+Oy90sRnGKBMTqQBU9MH/GYOGZ/rUL+Z9Q0=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E15F180002
X-Stat-Signature: qkkg8y7ikxog7hwniyjidp7chdzo1omx
X-Rspam-User: 
X-HE-Tag: 1772189722-928343
X-HE-Meta: U2FsdGVkX18zRQD+uOiUR/NB7n5qlk5zTD0LYnDlYBd/9psdYKBjmDadqh9rsQCV73se3uktxkV+F//DDXH83+O7GDqICfQbVLdzEXCv8NOXbi4lmPfz2DD5peaPLmKgows33oHfPRzaiqyxdhBxbTA+/YUtisyhhmmrzcRlBVbYgS2JRb9NlAC0LlyCoZsiuuOzmtqZqjnnajBs6dI/jH7T6KmwWOUsg5nuupK/llmcIndg6cVP2YAhtWNoslrpvfuNoFsTENDo4uq9xluCmyu431psi4xw5ABZhlA/gKecF6cvetNt9reDwD8WSudptp/EyMJkR6s4+B6HwwlSVHM1EQc90oUCCsOK392dyx1Vn/vcBaiDAaIHXdutsiGCvTtByiZxMV5fn11INQHJMKUuKDUoAzZIFexeZLAGhAr9J8iVxPymnFrnydWuCNGMUfrbUTLkrcU0wSx1U2kl6J6CLqPl/IUR08cwRjl2kbW8N+2xWEGhu6cM3tfuFe+XFiKp+KE7Srtr5J6k8E5xLHxZt68og4kybPIymphnWnr5qWRxgskylEB+WLTd5ccV07RH6/Yf0wkOftILTWAMT3K0J5jbd5YpxE2aEiDow0quQe5hrUESLza/P7OLsZBxzxzHlLqwvgvpPka+pc3aP377lpVhmeNa7UfAUqVD1Xqd53TAlWI+I2xjZh0ZDXyuiNsliZtdQQAiND2k7mQ6t/1um7bdBoqaYEOXr6qYuQ0ANyiYi3pTY6dCH38nLEnzsKBHtSSfqR2f9mChy/cpOVN6trPfuzvmT8xpc+TZPgn0+SgF/YEQwyQ2tuK+w7cm6LE5NDpJLEVT3Eoi34F0q1jeYwTfRRiOjXXiKLs4SmlB6hsdUan09VIm5+iedN+3a2ApXAJqmBem2dCrLrZsKRxnADDGn+LDzfq8uXEmBcCC2ST2Sh8Lmv51U0J24bvkWWzlwEpr0uBoCIlFfi7
 EDfb4lle
 Bd6HrIu+UDit8/ohKdNlifzpYZtvQrwGgkQhoIWKEx3mfLARTLmBauEZ6wtzQpZOaklcq5P35gNKx3jE/yh3hFq8oV0fANBxNoaAxwCTgtnHrCdATv6uxWTYG5xz/WHSQn5dOWjXfidD4SifkD/vJtBClY44mAVX9xlGUE2qo0oOrEieQVTx+vkfJxTLL8ozFgJHmYxw2D0aLtqXtYPey/ceYGBlAQ67ikvOo8ZrZM+iSwWZHzLDK8ySIp+qVQP4wsGt9/6u5nua7JJUIp6RXUQCQ8vvkEc/S2zu2H0inGg009BEjupUcoCIUkvPqvix5c2WNen70q1JCrKuFjn+JyTkB9roWhJAmoRik13i2HCPOUTda8ksglM9LMk9FhX4tEsNm5N1g8Fg0T9UtbtFmQHrSbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel

On Fri, 2025-12-19 at 08:10 +0000, patchwork-bot+linux-riscv@kernel.org wro=
te:
> Hello:
>=20
> This series was applied to riscv/linux.git (fixes)
> by Andrew Morton <akpm@linux-foundation.org>:

Any idea what happened to patches 04-22 as I don't think anything other tha=
n patches 01-03 ever got applied
anywhere. Or am I missing anything?

For what it's worth I carried an updated patch set through up to v6.19.4 [1=
] and latest -next, which at least
on EBC77 seems to work fine.

Thanks!

Cheers

Marcel

[1] https://github.com/riscv/meta-riscv/pull/602

> On Wed, 12 Nov 2025 17:45:13 -0800 you wrote:
> > On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
> > DRAM is mapped to multiple physical address ranges, with each alias
> > having a different set of statically-determined Physical Memory
> > Attributes (PMAs), such as cacheability. Software can alter the PMAs fo=
r
> > a page by selecting a PFN from the corresponding physical address range=
.
> > On these platforms, this is the only way to allocate noncached memory
> > for use with noncoherent DMA.
> >=20
> > [...]
>=20
> Here is the summary with links:
> =C2=A0 - [v3,01/22] mm/ptdump: replace READ_ONCE() with standard page tab=
le accessors
> =C2=A0=C2=A0=C2=A0 https://git.kernel.org/riscv/c/11119b19f62d
> =C2=A0 - [v3,02/22] mm: replace READ_ONCE() with standard page table acce=
ssors
> =C2=A0=C2=A0=C2=A0 https://git.kernel.org/riscv/c/c0efdb373c3a
> =C2=A0 - [v3,03/22] mm/dirty: replace READ_ONCE() with pudp_get()
> =C2=A0=C2=A0=C2=A0 https://git.kernel.org/riscv/c/b4e53984f240
> =C2=A0 - [v3,04/22] perf/events: replace READ_ONCE() with standard page t=
able accessors
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,05/22] mm: Move the fallback definitions of pXXp_get()
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,06/22] mm: Always use page table accessor functions
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,07/22] checkpatch: Warn on page table access without accesso=
rs
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,08/22] mm: Allow page table accessors to be non-idempotent
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,09/22] riscv: hibernate: Replace open-coded pXXp_get()
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,10/22] riscv: mm: Always use page table accessor functions
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,11/22] riscv: mm: Simplify set_p4d() and set_pgd()
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,12/22] riscv: mm: Deduplicate _PAGE_CHG_MASK definition
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,13/22] riscv: ptdump: Only show N and MT bits when enabled i=
n the kernel
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,14/22] riscv: mm: Fix up memory types when writing page tabl=
es
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,15/22] riscv: mm: Expose all page table bits to assembly cod=
e
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,16/22] riscv: alternative: Add an ALTERNATIVE_3 macro
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,17/22] riscv: alternative: Allow calls with alternate link r=
egisters
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,18/22] riscv: Fix logic for selecting DMA_DIRECT_REMAP
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,19/22] dt-bindings: riscv: Describe physical memory regions
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,20/22] riscv: mm: Use physical memory aliases to apply PMAs
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,21/22] riscv: dts: starfive: jh7100: Use physical memory ran=
ges for DMA
> =C2=A0=C2=A0=C2=A0 (no matching commit)
> =C2=A0 - [v3,22/22] riscv: dts: eswin: eic7700: Use physical memory range=
s for DMA
> =C2=A0=C2=A0=C2=A0 (no matching commit)
>=20
> You are awesome, thank you!

