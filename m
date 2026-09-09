Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CB6C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406B76B0092; Wed,  9 Sep 2026 15:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF306B0093; Wed,  9 Sep 2026 15:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E156B0095; Wed,  9 Sep 2026 15:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014456B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:33:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B10B1402F4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:33:10 +0000 (UTC)
X-FDA: 85195222140.12.718E065
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F424180002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:33:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026082801 header.b=gofX7hrQ;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788982388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dGDqKIiorLm4PMRWZf+lcjSymk+duftPVKL8h3BRa8=;
	b=37M39J3+HzSrqhMFBqs245HVfPTBYKao73VmYPl6wF/kzaVQbsKKxbArqywVbcrVvhckdt
	YXQ/N9Tfq/WoTeSPXGGl1tlxkHFd+XhVsFtMqsrVQ/shXmT4KRhSi6QUWqDrjShSoF+rq4
	Kmia1LWpSN3Oor2riZVUoFNufmPesl8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026082801 header.b=gofX7hrQ;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788982388;
	b=GzR+Yh7xWzckpvMOPqn2EdRalT+1FH+XxjsKi7yOnliQ+2HL6WgZX5VRhbPxmtD1EWuMto
	vjfd14TpNMSl3pd7HDNV3f8Btn6XkKDZm4FhSUVkf2mkmYaaUA25auLboOLVIE9DoF+WLm
	CEOkhmT8PkzsZcTy7MeFKZqeXE/hOew=
Received: from ehlo.thunderbird.net ([172.59.163.39])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 689JW0Ri241996
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 9 Sep 2026 12:32:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 689JW0Ri241996
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026082801; t=1788982324;
	bh=+dGDqKIiorLm4PMRWZf+lcjSymk+duftPVKL8h3BRa8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=gofX7hrQMbsXkfAGKbIB5EEVBWalAWuw926LqzLEOVYYNLyZUfbWEzWPGDLj9bbmQ
	 WFie+ve7lUQ9pYuRVmVYjV+EqzzAArpgHRWshxY1qKfnMcxxPUBe/xs1MmeSmnGIOJ
	 dPgyxNew5qsHsjhQOA41SlBB/MQHD0m+r1YFZE3wLCs3umtpLH2oSsE4iYDyt3+j/i
	 rnjM7tEna8nBlg7YqDxC5Ptjf5+Rcrbt1/0XzPeibvb/+oRmhKO1xpHus1ynWSXLJ8
	 MI9bdFysgi5uqG5wVEpJJTL/7pSn2oMlC1a/K6We8WFSaRVoteYLUt+37PBgC/p1jC
	 eVbxDJsilqYjA==
Date: Wed, 09 Sep 2026 12:31:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
CC: Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?ISO-8859-1?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
        Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>,
        Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
        linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
        rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 12/24] vdso: Add the vdsocheck tool
User-Agent: K-9 Mail for Android
In-Reply-To: <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de> <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de> <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
Message-ID: <ABBC0C50-847F-406A-B426-55D0C2BE15EA@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F424180002
X-Stat-Signature: 4fr6fccc7jgxsqxhc1mz5xkpmw6twhz8
X-Rspam-User: 
X-HE-Tag: 1788982388-274742
X-HE-Meta: U2FsdGVkX1+q+/PxohMUXZ9qgd4N0vq7Qcbwt95xqDg7N9ToIqb9nIH+mlx99BSbp/ol4enft0iHNhVccVpDz4Zmk5zlzPxupSAUUjNI4spUHzfD2Ayb5ewP4RES88kxsr0MMphM0r9f3MEd7ZdeO1y/Zy3U/VrlroI73JiiXji1lCKtKgbhFOf4EXFr7oc/oRhHVz395wFpd0IRm9jbaJ3eQ7/ck6vrPt23/OckCqDBicZTQMpcqEFng6jprhihutv5XtdGWV1sKBlsFEVcdVSbpaxyRSFDPdZn77LUvEkZ2LD4DSt7rtmxgCoB3m0UC0EsYN22609hbvp8RD+NAXm1A9d8Uk4BoHXK5CZ7vgweTMg/t5pXrhmzAuli24UN+Q6I4w49LiX/fwfwdlMJHJITeP+cFB7ySdBCQ/OmTO4ZhLQIPw52c+Do4vqKM4+EM+tDF6EJJWnxPpvKrK5XJtRSqhLFQPb8+EYtWoIROQfnATfIyiI0km0m2dlqm1QgCZizxmS/5jQhffHy9FYemT/wn50IZmGpG8oXfF4PA9k6aryMdFQ36dSP+fvUZm47P5LY2a1LTuVdIMPScxS8liRmsHQ0ets26yKV7XttuMqyVtu1SSsL2dUeKbUsNJMIh8c9dZ+Pcb4aLuy3odLrKh5iUAIMZfIib5QypflqQyoc1tzHACNyliR584Lw6DK7SPFn+pFd2Q9pfGZfawC2JyXEo5zFFZn1MPnyF1F/LsLZwVNzxiQ7JCLDb9qmvAHlMCCP3Nk/ZFUl+Da1v0izlj2kp8qeiHZs7WtuGN31WU9YugX/ds0DsI4UJWOYbIXI/vzJ99yqe60J0+YbHIIhGaH0Jn9hga/lu/yrlVHJmNzzzJxrCvWOeE6LoTCY/eGHCEyq73ECxJlVjWs58kf7pQqHAuPRuZNNoPPOEh8NwFxe29v8xp/CT/t9zzgy4w2hX0RNkTdRVPFANUphfcj
 1SuGrtXE
 1vrj7lSLjXXsjiZSv7wGtHdlAgtewsgc5Gu9h5fEDxK0uLpUAiaHqtsY8N2QFSczwLJ1QKqnnhX6ruBlpzHXnB0IY10bKO6mpemTBImjxVCte50d5KuWV62a/bBMiOwHPYugrNHZqC3/Jz3JV1y2ikYhp+TRRHwv4CMBDb8kZmvvbUBxeNYdJK+g+Njm+Im7GA20kRu88IS7sFaUpUvAUhAJ9cvWX6+ZPrFsUcgq+YoC/WQ1Gv1KzED9vyO9mnQdb6mjs2yw1DztGmQ7Gom0cORG0TIaWWRG8H5CfXz7A2z7nTNMshK5+cEPq1XESLTZfCvX7esevJb2+kMEiP5zm5oXCXMUYZAPx94PG8FvTk1uEDeZIAuioqO6fZhPO4MNbOJLzHfyTe1RNMYb9xmB9NgJYNAdoo7EAwqXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 8, 2026 12:19:11 AM PDT, Peter Zijlstra <peterz@infradead=2Eor=
g> wrote:
>On Tue, Sep 08, 2026 at 08:33:46AM +0200, Thomas Wei=C3=9Fschuh wrote:
>> All vDSO code needs to be completely position independent=2E Symbol
>> references are marked as hidden so the compiler emits PC-relative
>> relocations=2E However there are cases where the compiler may still
>> emit absolute relocations, as they are valid in regular PIC DSO code=2E
>> These would be resolved by the linker and will break at runtime=2E
>> This has been observed on arm64, see commit 0c314cda9325 ("arm64: vdso:
>> Work around invalid absolute relocations from GCC")
>>=20
>> Introduce a tool to check for absolute relocations during the build,
>> as the current inline-shell logic is not expressive enough=2E
>> The check is done on the object files as the relocations will not exist
>> anymore in the final DSO=2E As there is no extension point for the
>> compilation of each object file, perform the validation in vdso_check=
=2E
>>=20
>> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas=2Eweissschuh@linutronix=2E=
de>
>> ---
>>  Makefile                    |  19 ++
>>  lib/vdso/Kconfig            |   5 +
>>  lib/vdso/Makefile           |   2 +
>>  lib/vdso/Makefile=2Einclude   |  14 ++
>>  lib/vdso/check/=2Egitignore   |   3 +
>>  lib/vdso/check/Makefile     |  34 +++
>>  lib/vdso/check/elf=2Ers       | 498 ++++++++++++++++++++++++++++++++++=
++++++++++
>>  lib/vdso/check/vdsocheck=2Ers | 154 ++++++++++++++
>>  8 files changed, 729 insertions(+)
>
>Urgh, does this mean I have to have rust installed just to build a
>kernel now?

It was going to happen, and now we'll have to suffer the instability of ru=
st=2E=2E=2E

