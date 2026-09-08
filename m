Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42D0C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D2B6B008C; Tue,  8 Sep 2026 04:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812CA6B0092; Tue,  8 Sep 2026 04:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC3B6B0093; Tue,  8 Sep 2026 04:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF646B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:57:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE51E1A0485
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:57:18 +0000 (UTC)
X-FDA: 85189990956.02.8779391
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39C7A1C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:57:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMlWBWtH;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788857837;
	b=ydXQ/cVdS0X3a5VuCY1O8XRXOYR66D5SZTKA0g/Q+uqukl22rjkD1BUkmD3bLxxgkVvbQi
	UlJ14/wgMlCHiDKIjq5UvJTS286L49mo3527coq6IJtaIsbPpDSqg8bOuF7Bou57gGu7oK
	HUnDgUmRGbvEHvrbu4GvhKTPjzU+nw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788857837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOR2t3VtcjszZ4q3H4RF8INxqX7I/2OnFWmBk3yYh2U=;
	b=NXWowpSvUGVzvS3PY++fV+sPValGilC6Ufhh8I4V8arHKBCNUDUGXcrKv/kvHurvPK0nek
	0BoKoAnnPHN2ivmsI4QLdJmGZmmyBgNzkuJmCwNzImNbRB2HlXszrR+QaXJjY8T77/9Rcb
	FZsBrq8SiVnjJLzdo59Zy6DhjmDBHCQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMlWBWtH;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E869D60A93;
	Tue,  8 Sep 2026 08:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D6F1F00A3A;
	Tue,  8 Sep 2026 08:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788857835;
	bh=BOR2t3VtcjszZ4q3H4RF8INxqX7I/2OnFWmBk3yYh2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RMlWBWtHsUr314SSes2RbgrXEdhowxsDExyywV6MWPiyRlQ2MiRcnzJrKxwP2Uq5y
	 FxFi3d8oyrDb4Ns+a5YQol0nE9UlpMARb5Srs2FLa3c8UgJq9bIRFnwje3hSYKfvsy
	 4lejU8BQqLNJPlkLkj5fUKy1asSopqBNr8Z/GdXh3YL25ZL/xotJOBdRT8X+1frbzz
	 5wc8MC7jxG0TFbXkBqhY75SKcdrJ0GvpwyMgIKA6vQKX0ndFDZCBRqE2+uKYcWsIZK
	 O423o/0XnOMDsJENmzRb5yAhovNWoPRl28a6i0Ifx5k/RVsnRdBM2JH4gLApjYzNXL
	 e95ar8gZlvOGw==
Message-ID: <06996199-5255-41d0-ba6a-ebeca57f61da@kernel.org>
Date: Tue, 8 Sep 2026 10:56:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/24] tools headers UAPI: Sync ELF headers with the
 kernel sources
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
 <20260908-vdso-absolute-reloc-v5-11-3a93791af1cf@linutronix.de>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908-vdso-absolute-reloc-v5-11-3a93791af1cf@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 39C7A1C0002
X-Stat-Signature: j4iythz5fazw4e3w3mdeoma4iexwstkc
X-HE-Tag: 1788857837-797983
X-HE-Meta: U2FsdGVkX18WN1pFfOWeS6gQUZRUisJdf8NHViv0UXd+5QejyWppCfRvpSm3mBVxsH8ko6vzvMgTJsDA5nGK2c2g9DTGBhl9efqyUg0nNsthQOUJOTBdliL64dKT7vPk75YlzjFEUwLLGzq2ICRS5Jc3DO85m2LSJmAQryGvvd+S68f11WMS6wZ9+4YqDc1pV8Mf86ZiWx30JCAUKRQbGNgS1HwPAMEruWWb3RAsKG5LCR1HzZ1U0nUIANUTb7v9RvGF4jZYXQ2jdXnL+6ZmKq4xs/ewXPXYFnKwYi6MlEr7W+E4fomZgFMHdXd8oudLJ8+kjvOFmKJ+NGzpjH4TxEkxVMLQk+6MJYEtl97ODnuyAgNC+pVHSB2y6Ku7h4S25siuxuwHw5RGdFgaV15ci/1jmNwtxfgmHi8voblG9TwaUfDhSBCFZjjkQ3htAAqs3o2HCXGk0RykwFxoSvpgNuJAtSWD0XdwxsePVago3N2upnNbUxP3K2bFlBgfJZfqBQoyzFlDdxJF0s6DUBKobIrgOk030x3I7jh2x3GHTCyeXD5UO3VfOTHHzeDQhkeBasTmaPJINmBHJ8eA+Le0MR8UjpFxUhyx4rhPy+BofLh09jgzH4MChM1f5YbIZC0bVPnDP6ME6d86F7fDjZVrAyrEg3YfUJEMPBVhHSvl7u6DkLfkD8SBaRUK18zgDtdWlCBuwQ2joJsQbxcu61fRysVPNoIO7I13xnetD64RZyrhmduggM/uQuBhEe4fvZMcHxmvtxjLig16zKM24GL3MosjtrpVFp6/WrZMSd4xm9kuPTUvCFduUsJEFuseSMF58uukslTbIFm+FezG8ZUZNXbbMKvx+PJQH2CFWkoD1z6d5iQUXwFqqzdRLu0xKo8/z9srTSYP23tDermeM7SN1YvF3WHU6u+BjPShRmmwmbeOOelRNkrHIlCkQWya88fCMQ6j2qeWZN9je0T5Vf4
 Cz/o5HyI
 ARJr9aEfKsk28BPDHYrR+VZfCp0drW18ixBh8V7EoZtXgFvvbq0wSAE+MIYjOl8qA5LaXn0HpZAHlcHHf/8NH2p0cjco9CLx4OB1IIqVMXFQycYf+On0VM9onUmRCATMpYdLbwPirKbk9eB/YpbEJRnk/xWY/E/BdCyx6CdAAFknT7G+87Xasbt0ozA3vZYG44tJTOttjouFVAxZpyknUKYDjnv4zwgRkWyzfYYNfq4r4bAgz6q3vA+pAmRqAkcrqXIVO+bBoAfXNTSxjDzTmWtvh5SC+62OGcx7U5ByQAk+DU3b1w1sCh7Cjib0mTtJhnjN7VhtABlbsOdjUMYJe4g9xuhlMw3wOACj378gJg0MrcfUaSVIR2wRoLP6IyjpOD441cIObaB38yGBbG2QtxXPxtMWlYJbQPe/t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 08:33, Thomas Weißschuh a écrit :
> Pick up changes from the UAPI ELF header files.
> This picks up general changes to elf.h, elf-em.h which was forgotten
> previously and the new elf-r.h.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> 
> ---
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>   tools/include/uapi/linux/elf-em.h |  71 ++++
>   tools/include/uapi/linux/elf-r.h  | 696 ++++++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/elf.h    | 112 +++++-
>   3 files changed, 868 insertions(+), 11 deletions(-)
> 

> diff --git a/tools/include/uapi/linux/elf.h b/tools/include/uapi/linux/elf.h
> index 5834b83d7f9a..88bdcbb526c1 100644
> --- a/tools/include/uapi/linux/elf.h
> +++ b/tools/include/uapi/linux/elf.h

> @@ -312,7 +323,7 @@ typedef struct elf64_phdr {
>   #define SHN_ABS		0xfff1
>   #define SHN_COMMON	0xfff2
>   #define SHN_HIRESERVE	0xffff
> -
> +

Getting the following warning when applying this series with 'b4 shazam'.

/home/chleroy/linux-powerpc/.git/rebase-apply/patch:846: trailing 
whitespace.

Seems to come from here.

>   typedef struct elf32_shdr {
>     Elf32_Word	sh_name;
>     Elf32_Word	sh_type;

