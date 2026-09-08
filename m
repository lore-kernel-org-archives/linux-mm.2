Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B6DC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51116B008A; Tue,  8 Sep 2026 10:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01ED6B008C; Tue,  8 Sep 2026 10:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A187B6B0093; Tue,  8 Sep 2026 10:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79D916B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:41:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9CDDA06BE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:41:33 +0000 (UTC)
X-FDA: 85190858466.11.5AAF3F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 435BEA0011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:41:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788878492;
	b=wRA/KJDzbWzyRvZZYnd6u3fK28gXdzHKuqR6Ji55isKqTqLYBg2rEpqse5kKgwMiU1rtKb
	dyCakcAVa7HAGFwttUVJNd8vfRZoLO8Q2osUn1czZzyIPFX5uAljk04wiNnNjoGqcNbCff
	GiRF5iac5u3qU2UZKuu3Is/ZP1j7VwY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788878492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UDv2ulwj8noxjdMQEqKxpUauXEITpLasbQE7qAV2OQU=;
	b=8pcQkPQ1yxzIaW3Nh1fts2vEFMq0aiqHzsAAuJ8OsdjimLo2HuNDGany6g8JnoqxN9Gaoj
	C7LXxO+Ey7riuDZUtlzh9MV2TgBPBHBMhANqFHoZ1Jx+ElmOCoMjV/SrzvZ8ZOK4q19ulm
	azf78yve+OKeo1TmcJ5+59xfnsYgS08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A81C4360A;
	Tue,  8 Sep 2026 14:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83611F00A3A;
	Tue,  8 Sep 2026 14:41:14 +0000 (UTC)
Message-ID: <7c9f6ec3-5886-41ea-8803-d81019321d29@kernel.org>
Date: Tue, 8 Sep 2026 16:41:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/24] powerpc/vdso: Enable the vdsocheck tool
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Nicolas Schier <nsc@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-17-3a93791af1cf@linutronix.de>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-17-3a93791af1cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 435BEA0011
X-Stat-Signature: 6iug89ufx97e51k1ra93bh99p4o9tpcn
X-HE-Tag: 1788878492-169258
X-HE-Meta: U2FsdGVkX1/d1odQHn66k3VfG1pPSvGDmQ/A5eCC0MYn7tIhQ61fmKUzA0DMHhFo9QKgWDLsQD0qZMqpM9BTG+vI4/PoAT39bZEiXv8TUH3+9/jd5UxZGsvhLlMHyvA7dGsx42GK7Z1UC01ELd2hBmKhM/vLAqc9KoPbQ6Ib5L2NVYEgwACfcactCyeRVDcjxJuR4Y6M3n4UYVhdw/HhH0BqeejvZdfW16xSMI0dvOMyBDdq8x9qH6D4QtVQJVWH0sgIFJi0lTL1lGQ9bU2xn/ieI8nXj0WxTr1GhzLeaFuUFwLrpayfvhdGj6cnsHSOdwlt/ktwYKdVnUO8OEoSKMiuGplq3K1sjKZCc7xmlyPiol6w8AD5NGRDpsi7CE2CoG9x8A5fQfoW4rczAuwbqX9X8tSBx0QDN1XzdFIaaaU0qmYH1Z6IXs7G09Kjxea43Xc+dJ+WWWPSLoUqREYeh2hea5SxY9f4iI64xvQSULOdZfkXd+em1TzzdOfc25VoYHPYFDaVCxiOcJfW8AH3afE3oOLM+Gs10eQLm0FlZEZrOKUiUYPCATM7AuEDtQtQfQESbNvAXCNYvKEUB8RW/Ktx6ktizIkj7MSFEqCB+Yf2ufOifO595TQJfmjDtDBxDk4E+q/ZOzUSPrGBKjJqQX1wkhS6OnOUFZSRdBtEUyWZvURdQ3xmbt9Su16+OZcLXizToET8JGVL6o+5Az/UAvIrYe3m8cUMDwZ8NnbzVI5zr+7Xqw5fIUi5Ivaz4PCMR9sc8z6ZTnSEURweh1kWiqNf45ZLnSJiR8N8xzE4F1PZ68CBiUUazGcl8pRBHr3z/sZvyLhPljT1KwBMmVmP/F905TqaEgv3nJp6IhuDRDbSGaukk7UZQnWtkysArFDZgD7Xcch6BfRJ4HejY4glOBuYwI4F5vrmeAqL6Dt1PvNagWQUNd07yWR3riIsR4bfexz81quks7buaS1GVCx
 fR+k/t4E
 RfEt09FbhoeouIx6G5E0iGPxEMb4hDw+QCuO9DiBgMnl1vMGv6PmZ0bzn+aTEojbWBCgDm1Ba4+AjcCEPumW9OCjdPiKBopZkfyNt3DtT1ctpl0MIhTCOWDnEWd8f4K7Nl0K29eDmARL8EhtpIqqG+K2QARNqYeMUxjCAYUatvhH1dqyGg5l9mQg8clz6Ii3VOEFO5P5wEW4gC8iMsm2dL9jg70JuiPG1pjgLzzrKk3lxx52Iyh5SZS5RGa2khbZ/auFhyfkOSAyELB99GRhjntfdPg9JTamiC23/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 08:33, Thomas Weißschuh a écrit :
> The vdsocheck tool validates the object files and final .so library.
> It can detect if the compiler created relocations which are incompatible
> with the vDSO which need to be worked around.
> 
> Wire it up for the architecture.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> ---
>   arch/powerpc/Kconfig              |  1 +
>   arch/powerpc/kernel/vdso/Makefile |  4 ++--
>   lib/vdso/check/vdsocheck.rs       | 27 +++++++++++++++++++++++++++
>   3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 2580e27e4328..f19e225cfc5c 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -330,6 +330,7 @@ config PPC
>   	select SYSCTL_EXCEPTION_TRACE
>   	select THREAD_INFO_IN_TASK
>   	select TRACE_IRQFLAGS_SUPPORT
> +	select VDSO_CHECK
>   	select VDSO_DATASTORE
>   	select VDSO_GETRANDOM
>   	#
> diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
> index 368759f81708..ca20b91b4373 100644
> --- a/arch/powerpc/kernel/vdso/Makefile
> +++ b/arch/powerpc/kernel/vdso/Makefile
> @@ -81,9 +81,9 @@ targets += vdso64.lds
>   CPPFLAGS_vdso64.lds += -P -C
>   
>   # link rule for the .so file, .lds has to be first
> -$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o FORCE
> +$(obj)/vdso32.so.dbg: $(obj)/vdso32.lds $(obj-vdso32) $(obj)/vgettimeofday-32.o $(obj)/vgetrandom-32.o $(obj)/crtsavres-32.o $(vdsocheck) FORCE
>   	$(call if_changed,vdso32ld_and_check)
> -$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o FORCE
> +$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) $(obj)/vgettimeofday-64.o $(obj)/vgetrandom-64.o $(vdsocheck) FORCE
>   	$(call if_changed,vdso64ld_and_check)
>   
>   # assembly rules for the .S files
> diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
> index e45a1fbc6829..429bdcd65818 100644
> --- a/lib/vdso/check/vdsocheck.rs
> +++ b/lib/vdso/check/vdsocheck.rs
> @@ -69,6 +69,33 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
>               ..Default::default()
>           }
>           .into(),
> +        bindings::EM_PPC => AllowedRelocations {
> +            in_object_file: &[
> +                bindings::R_PPC_REL24,

Not sure this is correct, see commit 42ed6d56ade2 ("powerpc/vdso: Block 
R_PPC_REL24 relocations")

> +                bindings::R_PPC_REL14,
> +                bindings::R_PPC_REL32,
> +                bindings::R_PPC_REL16,
> +                bindings::R_PPC_REL16_LO,
> +                bindings::R_PPC_REL16_HI,
> +                bindings::R_PPC_REL16_HA,
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
> +        bindings::EM_PPC64 => AllowedRelocations {
> +            in_object_file: &[
> +                bindings::R_PPC64_REL24,

Not sure this is correct, see commit 42ed6d56ade2 ("powerpc/vdso: Block 
R_PPC_REL24 relocations")

> +                bindings::R_PPC64_REL14,
> +                bindings::R_PPC64_REL32,
> +                bindings::R_PPC64_REL64,
> +                bindings::R_PPC64_REL16,
> +                bindings::R_PPC64_REL16_LO,
> +                bindings::R_PPC64_REL16_HI,
> +                bindings::R_PPC64_REL16_HA,
> +            ],
> +            ..Default::default()
> +        }
> +        .into(),
>           _ => None,
>       }
>   }
> 


