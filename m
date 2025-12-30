Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95007E92FC0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B106B0005; Tue, 30 Dec 2025 10:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AC46B0089; Tue, 30 Dec 2025 10:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47546B008A; Tue, 30 Dec 2025 10:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D28936B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:11:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CAEF56ABC
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:11:30 +0000 (UTC)
X-FDA: 84276476340.14.0020044
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 992DB160002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:11:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ugBg6T3I
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767107488; a=rsa-sha256;
	cv=none;
	b=pF7C8K8zmKKkcxw0OrHQWxwdInuPaJEy0Yz5YwobSiMw+NU/IT3zOxu+SMp9aLwxr9+52t
	5xoIT0qCT1XM2+WNHfyfrnffI/X06bVq/I/HdlEdB2rD7Hy4aD/8EhUpKI1oeoHZ+a6jdc
	zO5QZeBe0jZDxxo7AgfH5Nev3ssyZgM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ugBg6T3I;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767107488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GR1QVe+wka/wbm96OjOQm9NYaPe6PscdIySk4u41LOE=;
	b=ifnLvaw4eDSB2DNl43oulASj6LM7hfHaUKPgbuJsP8y+xaK5iWIRlPU8QJ7ZpsTsMdOp5X
	bSX+rWAKhJCtZn3dTS46nfYFUiMGPpYYTF+B32AGcRIAGaJEdmEWwM7n33RTNbktr5fas8
	SSad6M1S352NTGKnLN0QR6k4GFf7za8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=GR1QVe+wka/wbm96OjOQm9NYaPe6PscdIySk4u41LOE=; b=ugBg6T3I+BJ3MKYUEKnspUJTSy
	rbxtMwx/LPQ5E1SqEBZPlflmiwgZshPbBc7lJHejMx2jG3mLrN0fEIZmnvOOR7nPzSG/K4pH0wGyi
	/ZfB4v8wclmZ9mr6xcnPzQjhOh4Oww3BeOUKkr/VFWumIGbaL5/OByBRWnRSW4khQ9+5w3JLprLdz
	C+e2d4D471R28NNE6Ctm2S2eKZYDskKAg8IctqCmgg8WUVuBVcfRMi1/fC6tEPAirfmof/ki3gJPE
	DntY+B8OVrLNJ/01m4lvrOEapGeFSGWP8+8cHu3x5dZVJOf79/E/KEwZDpK41u1cmUherlzNU9S5e
	GKcfyS/Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vabNU-00C85X-AV; Tue, 30 Dec 2025 15:11:16 +0000
Date: Tue, 30 Dec 2025 07:11:10 -0800
From: Breno Leitao <leitao@debian.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH RFC] kexec: add option to print previous kernel release
 after kexec
Message-ID: <ljo3xdbpwa2kzx5thlki6fc74mpswuwtfqzdl4qyatqi3qjbwm@4prhagytf2ja>
References: <20251230-kho-v1-1-4d795a24da9e@debian.org>
 <CA+CK2bDCKQrK3+6832Lxw8fZx_yt+8z0fFPdugC59p1zdSeSZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDCKQrK3+6832Lxw8fZx_yt+8z0fFPdugC59p1zdSeSZQ@mail.gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 992DB160002
X-Stat-Signature: cgk1375z54m5h4hspedkufnggngu6qed
X-Rspam-User: 
X-HE-Tag: 1767107488-335956
X-HE-Meta: U2FsdGVkX18rrHThMB1eQGlugV4avx+DVCEO4ecnBThCMjwdr53Gb+sbcJt35zOaz6ibKEJOz3lnUVKjzNJ97c5enLCKCuVyjlypDrDIloh3He1zcWi2J32sO4YAdFjHCjrZ7wXF0yNyPYNRO+owhnxOZm0ieMPsgeZWBr8v9TooCVz2d691EuCDZXq3+QbpqhhOMUWMKaLpDDHu5podW9OLlsmfm3QlUjv+g1yM/9VG1WynHVNXQUxtF7AXx+1fPi6Wo/V+ievk0Cp/TepLXNVRbjD+/pqjcDzgwVqfJqeQZNnU/8WBRjuUwmRJzBowCLTKkNFlTg56GOWwan7vOc4cETtgd75soJy2i7fa4MkX0F0bN0uvOD3gQ5bsFlSl5KNncO5Smn81VOnxy5HyDzoZVZcZ4jVgMVxoEE7B4FWNGgSPb/tA+KWA6MDwDdw2JkdIPbjRmHoSMHCB6/MrsIvo90caZn0fgf7ztE1JD/IKHSuQi7KoYWW2dWRpFGh2OKXxcSWVGwEM2EWoCm9g0vLXyB/W979S5vc60X5Efwl5KeUv2WJE70oOejX/5/biv6/nmuN/Lo80P10eYOX73OBSFqq+cNepgmm7NRELr2IxC8+6pqKfOsLXqPfJ2Ew2tp7npeZ9erV6d8bByl+ji+9skTgYEANmzzlIyVyb8/XSc2vXRpOWLB9gtXCZZntRirOKlsykXO1HmHkrscKfCPX9FaoS7/Q8tyisrI7wV5GtqTbgCLwuW/sKLZeLNdxDmuw1aMFYPZwUOeQ1/Volksxt9fEJmm8zQR78HEXsS4oWosTzjLZzHRj0YKf7OWsRQMYNV8CTjUD667sV8myrRfZczxMFk2kVNKqbl/WNYSdRx5nIehYbLE+zkJ/hRG9xa0dPiTIgpVf4tVhh8oYs7wsVis+7/j3Y/sCBIyPkGxNp9mHiIQwXC89sy0nt+xehBwOl5uJ6XO4DvIiXyPT
 +dF9Rd2e
 5149IQGxZ//ggShGSP7Bm9wUtmpgSkAO7C5gYKQiBbiOfY0yt68h9UNrU48sKyqnokr61BM7m38zmwOjpMvPVKMInizwwgN4YyTfqIbls7pYiJBujrk1RQdInXloR8AtwK8AoTA1EAIz8YnkgaAV5lQZGZq6/XEZwwPJfaqLCDpFRWJBcc32GCuJeSxnLeP1AtKUbqE2DZIp4H/EUPOuaf34wUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pasha,


On Tue, Dec 30, 2025 at 10:03:38AM -0500, Pasha Tatashin wrote:
> On Tue, Dec 30, 2025 at 9:13 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > Introduce a new Kconfig option, CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE,
> 
> I don't think we need a config for this. Let's just show the previous
> kernel version unconditionally when KHO is enabled.
> 
> > which enables the storage and display of the previous kernel's release
> > version across kexec boots when using Kexec Handover (KHO).
> >
> > Motivation
> > ==========
> >
> > Kernel bugs that depend on the version of the previously running kernel
> > are not uncommon, especially in scenarios where a buggy kernel kexecs
> > into a new one and the issue only manifests in the subsequent kernel.
> >
> > Recent examples include:
> >
> >  * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
> >  * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
> >  * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
> >
> > As kexec-based reboots become more widespread among Linux users, these
> > issues are becoming increasingly prominent.
> >
> > When such crashes occur, correlating them to the previous kernel version
> > is challenging, especially at scale, where the problem may only appear in
> > specific cases and it is hard to correlate.
> >
> > With the introduction of Kexec Handover (KHO), we now have a reliable
> > mechanism to pass information between kernels. This presents an
> > opportunity to address the problem by carrying the previous kernel's
> > release version to the next kernel and printing it at boot time.
> 
> LUO added the number of times a machine has been live updated to help
> debugging problems that are related to live update, perhaps, in
> addition to the previous kernel version, we should also add a number
> of times the machine has been kexec'd. It is useful when a bug
> manifests only after a number of kexec's which is also sometimes a
> case.

Thanks for bringing this up, I am on the same page as you here.

In fact, this was on my TODO list, but I didn't want to send in this RFC
to avoid too much changes/code.

I will wait a bit more and add the number of kexec'ed kernels in the
next revision.

Thanks for your input,
--breno

