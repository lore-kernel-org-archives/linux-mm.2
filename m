Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA49C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5511D6B008A; Thu, 10 Sep 2026 02:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503B96B0093; Thu, 10 Sep 2026 02:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1F66B0095; Thu, 10 Sep 2026 02:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16DAA6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:53:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76DAD40436
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:53:01 +0000 (UTC)
X-FDA: 85196935362.25.5DB9B07
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9646E160007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:52:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CIPlZuNK;
	spf=pass (imf08.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789023179;
	b=ZoRX1TREr8BcoQ9EzcYrRptzLuCofnEMuZu4YcI7GvOpN1nSF6ag+LBJBIbB9h9aQJ0Yg/
	nS6rj0SObI8Jw2pE9tjz/26y0r+epSk7tD1+AmYWMGiXyP9jylJZsL/r1OkDzdCSbpcY3C
	P5cIoRALtxRPW/QVAsv80K/vrw52WhE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CIPlZuNK;
	spf=pass (imf08.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789023179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNeh3lUekONIP+bceTcz/qzQUFIH9IGvapVm9Sqamho=;
	b=wORLUZbaW87VZXy6DWeCsjZmlVxm+EsN1QBkGKGNxjbvVxWYCwssGr+kycMA0QcsHbkAJ+
	8Hs0WY66xBOzvTiBxxsqZveUpl8v6YvDevuhu6vtup/MaLwXpF6BrkwKshMz9A62lZJCKT
	NcmDprK0+wK+ZC7Gfhrk0ie5tD6uZ8k=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso5218791a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789023178; x=1789627978; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UNeh3lUekONIP+bceTcz/qzQUFIH9IGvapVm9Sqamho=;
        b=CIPlZuNKiV7PBpE65ThYSnnhGZNP5Yl4MIkC7DDVRWT3TTA9OnuXjWQYE+HPq8Qo9f
         8yfM+QtHA7wpQv/A5B4f2KF6Z82T2cFoh7sg7w+D94lP4rCzPlfOQGxJQNBySLo+H3HR
         j/VbHU/k8ZcbGEcUp+ETGw60o+DamdHwwItUxUAJSG7f67AmWoQpJQ3g5JEKiv0TtTxp
         BQAHo5eah6Sju9oT2gdALO09wRgPzu5HS33xzKiTCuVmobXewb0NL0hLcviEverR6lA+
         p5OsF9x67hyc8HXLJWv1oHYj7IVslBda1aMKe+uYwaAF6G+JGvjG2Dk55cMgS1YG1UqN
         EOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789023178; x=1789627978;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UNeh3lUekONIP+bceTcz/qzQUFIH9IGvapVm9Sqamho=;
        b=dkYPMkLtnL7gZaO7fHOZ4EK1vXmEUcoPfr5tizfrGkCmh4zH/OmnCVq4D1T5RNStEp
         sK8c414LpR0w/e7VIDY+Y/LGPUsbsXW63eklEuaHpZft0lVnbC8pIbGDgX8BHR9nw/Wt
         uhXCp+YIUhVj9cIrg5BxEMoHNJowN+wk42RY3nml3EpWtzp4KFtLwhH5jXMH9NiT5EKi
         8F0vRQR3xcxYPoRHJgT86NU3tKJQp2ha8bO04XH8iTYAU4G+ee5eLzzWc8HcVqksPU1+
         7gnt9wp4hkprd/LqwAsCX9oMEN9YCDK+XdHBvWVbXKJ/2jSTHcNtXhBAKuGFf7Y/a8M2
         P98w==
X-Forwarded-Encrypted: i=1; AKwUvBz32YckP/zbwi3vHdTXapuowj5bgLR5b/lqQkvto2dpmT+ytpkqTr2kF3jVXjlRAurhPOQ9XC2Y4A==@kvack.org
X-Gm-Message-State: AFuF++nGu+FpBm4TpFAgjKSzGMpczfs/AkTaMja6ZyzkZerVi/JWgx2/
	cn8UyfB6VYBjuHQPgyV5ZvomBYgrXHrItYiv1vM5cQEQ/cVJZFJaUBgk
X-Gm-Gg: AYBFou147xNgiP5AtPmlJX+5eO0IofGX98XshKt5yUup11aFZgo80G8KjOWky6Pdb9a
	ZA/dsgX4YRKo+pVEo6PGMUK0ExzsWgByGOl5ze91fMuQTYJeHrplVrwMSdrh+9ysVgCHxlxjLb6
	HcmvjL+ajJ7/COODuvogxeoNgDjfxke0YseF+hWloXjWx+aom3ql5ZM5gYHyC1eSZQrUmLN0KjT
	vM3f2yRfcCiAn4uwVwIeRCgAcwSkUUx3s3ZtmtZliCql1fOxomWu02gs08GfvaOEu6O5NxaYuyj
	48Nt/kxqW1JMSOZCfC2J+Sp66ZlKzDFRqdXFa1X9bEXYTJp2HDxRUG0+xOYOe0XRgTwZQ0MHv44
	NTjWEnDEdZj9M9Ulbt1VBSPVUoqOU09Hd7JuTVBQeegbYuDq6anXfvLO+A/5pXmJKHbMj1KDsSa
	sRvOvJe/djMn1q839dBktzz+WV4OBFxqDa0RZIY1EyChkoOPHwZQ6YgXhdP8m3NmMSpgET+eXSl
	JD22XP1WZYOB8QB+fHjiyD8N/zy1kiNTqILlabnEXI=
X-Received: by 2002:a17:90b:3d92:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-39b2614df9dmr61606265a91.2.1789023178292;
        Wed, 09 Sep 2026 23:52:58 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e77498csm2694423a91.3.2026.09.09.23.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 23:52:57 -0700 (PDT)
Date: Thu, 10 Sep 2026 12:22:33 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 12/24] vdso: Add the vdsocheck tool
Message-ID: <aqJS61DbuUI3xoY3@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9646E160007
X-Stat-Signature: 6x1onmozbfasumyq7hy9yynmyut3qe7m
X-HE-Tag: 1789023179-501950
X-HE-Meta: U2FsdGVkX19WCXqwGJSBcZ+76egY7C5D/wYYIQw9bpWj9ldorJB/2AWZaHcmDdw/47Jcx5iYzfTBJflwOptfO3cY+06WV62Y1D2X+w60M3qC6L2OL+s6Za/4BsfKOtcOGNe9al0tSuvbGy1l+86PVFdj68DHnS9zE4B9Kfztr+nFvQSeGsHRfcfzXfD2VApG8/RI9RnY8wHImZkp4YqyvCU/iYaMhO+nsicfwoqgzjb/jHnUsNhUaCT39qDqBfInuwFj0Kj7U2LnhvmpgJoX2TKH16ONqgicqvmGAzgCl/rYjQRYD32rTblFBvWEkm7hKZkRiPRQRkZB9enbxZ/g+QDF317frVJkc+UVFdGyh64nTHL7EO0f35zP7O3AvVrSKILQjWnOEWwR1ZRXrNDGfmg2sE2QH2SEltfQUofyhiq+t6dEuCjq+C4t0Mjd6zQxgSRFQhHHRsbdlp5ee+1Vu9PY4FVgtbdGJDIGNnSfJZdImRzwX+XVULq5AIv0Fu1OjCkzPBMPdEsCbRnkpSM0j351wE2SXNFO51MA++k5UfIOYJJa6Q3hd6a0QERp1Nxnna7gFyL2jvzMbaHb2sTwoipHYFRDi0lTrdHVOu8lXIvPMh9fi0SKbQwoxm2xj0AqkKljn4EbdyAl3jnkR86QMwSo069aWc2YU3HPrfl7xi6PIO4ZIMU60YSxjvn6t14WFjBoejyFouSDNHAc6l+/iizWgfJziXyxijw0rduHRntJnom99AfXzXHKkHt7nB5PxO2t6SjklM/jbdtjtoVpD6BDoG7F2NliEmo+FGv8FvHUCA9d0+5USk3Gufv71ZLVupYNDOnh0qMPkDFj/WY8snPlXKcGlapYF4QIrkSINYojVlRHc6bic5s7RsC9P+QhHhzTOx/y7j83FzVk2qEEPMaExxP5EJ7PvAAvyI4FFdFUBjkWB3U2nha9XuJ64sYmzXdjO02Vyfu8CXpsDjC
 0KEDeYmo
 TdlND06WmOBjucOYXKrjVmxXOoo8QyB84HG0NYDqEYI4PKw9G74vdh0URp+xI4IQCkzheiazmvS0Mm3tGtzuEI0H9a962IiZ7cBYjiTmM8h+ntzQvX4UiQ+eElxXRyWi6UOGh2+8vEFJZtnL1WNmoe+xLhAwjd2JaO4NntfhMDideZob+d0GhsFAD7YFpyFOpbdvbxyJNfLEuIgXR292uUL5z96I0BjfYlj15pxSw8hX5/E0XcW3d9uLtixyHNIUgUubxMe3h3ssVAAqfzPvXkpesBuSViopBnTzgYKCCTn7XHlBA18uCYe94mgovdQONz5n/XXfQLukIEq11qq9odKT5U0qaTc/fMyZxZEPCDiBS4pDmm/kmJsfsXPFwMyTPWj2VB0g3g6PgiPxHlNd6BSTL0C82q5GAB0EuuHa/07l9jVQ/Of69Ojam1lKvuVquK8q1YQ31oZ5z9fgPJfOFpEmmig49zdfNoCgslLZ97ipyq3gMgSqEQTwp0u5j/r/B9xSopsw9WtXNSxNGWZvW8nb8rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:33:46AM +0200, Thomas Weiﬂschuh wrote:
> All vDSO code needs to be completely position independent. Symbol
> references are marked as hidden so the compiler emits PC-relative
> relocations. However there are cases where the compiler may still
> emit absolute relocations, as they are valid in regular PIC DSO code.
> These would be resolved by the linker and will break at runtime.
> This has been observed on arm64, see commit 0c314cda9325 ("arm64: vdso:
> Work around invalid absolute relocations from GCC")
> 
> Introduce a tool to check for absolute relocations during the build,
> as the current inline-shell logic is not expressive enough.
> The check is done on the object files as the relocations will not exist
> anymore in the final DSO. As there is no extension point for the
> compilation of each object file, perform the validation in vdso_check.
> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
>  Makefile                    |  19 ++
>  lib/vdso/Kconfig            |   5 +
>  lib/vdso/Makefile           |   2 +
>  lib/vdso/Makefile.include   |  14 ++
>  lib/vdso/check/.gitignore   |   3 +
>  lib/vdso/check/Makefile     |  34 +++
>  lib/vdso/check/elf.rs       | 498 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/vdso/check/vdsocheck.rs | 154 ++++++++++++++
>  8 files changed, 729 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 4ad67b737af7..e6e0dd7818ef 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1559,6 +1559,25 @@ vdso_install: export INSTALL_FILES = $(vdso-install-y)
>  vdso_install:
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.vdsoinst
>  
> +# ---------------------------------------------------------------------------
> +# vDSO check
> +
> +ifdef CONFIG_RUST_IS_AVAILABLE
> +ifdef CONFIG_VDSO_CHECK
> +
> +# Build the checker early.
> +prepare: vdsocheck
> +
> +# If the architecture builds the vDSO early, make sure to be earlier.
> +PHONY += vdso_prepare
> +vdso_prepare: vdsocheck
> +
> +PHONY += vdsocheck
> +vdsocheck:
> +	$(Q)$(MAKE) $(build)=lib/vdso/check $@
> +endif
> +endif
> +
>  # ---------------------------------------------------------------------------
>  # Tools
>  
> diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
> index 597f5f0f9681..112b42a5aeb1 100644
> --- a/lib/vdso/Kconfig
> +++ b/lib/vdso/Kconfig
> @@ -23,3 +23,8 @@ config VDSO_GETRANDOM
>  	select VDSO_DATASTORE
>  	help
>  	  Selected by architectures that support vDSO getrandom().
> +
> +config VDSO_CHECK
> +	bool
> +	help
> +	  Selected for architectures that are supported by the 'vdsocheck' progam.
	s/progam/program

Regards,
Mukesh

