Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52203C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93D66B008A; Fri, 25 Jul 2025 10:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D896B0092; Fri, 25 Jul 2025 10:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE48B6B0095; Fri, 25 Jul 2025 10:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7C8E6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:23:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0400114076F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:23:45 +0000 (UTC)
X-FDA: 83703005652.04.891D3AD
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 19EAA40013
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:23:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=SRbdKN5J;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753453424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gskfuFSjcZ1f9NqzVyfbU+2SXj6gH6Vy4UjfTOJinxk=;
	b=68EgJ5TpMWH+jTYW6ehnF3aYcfNFPqvx4x3UiI/pT9XlQq8iCpBTIHhE1yvoUyToQ7usp8
	CDIMDTUWhFI5PeV56d+5tF+CwBIUknNlDAfqW7ezLyh7ORZ/Jqnr6ZRYeVubzgenkRS2ah
	wzXtvHa/335DSHyWYF72D1QeNRGdlBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753453424; a=rsa-sha256;
	cv=none;
	b=8reutsQSL13RcGKManOccdNdsuL502d2dD8lEL1z+vwhOTqazfQTJP5qdfFjJTFc8bCET6
	RG8t3fGxHanLUSr8BmCIJ5dw8Phti1Iq3AyLqacT01H9HMyZPIKDJC0iG0yDZ0KlcUSgWh
	Loxj7gf6PBxF56vnWWGbLk/MKn0oGhI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=SRbdKN5J;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235f9ea8d08so20280505ad.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753453423; x=1754058223; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gskfuFSjcZ1f9NqzVyfbU+2SXj6gH6Vy4UjfTOJinxk=;
        b=SRbdKN5JLg/PSxjMURm9oI3SoO1niey0rBj1C4PtubyQBNAQ+U6BD6iCkgO+nBEX9m
         VjV/f/Mhn0NDPSuiROC3O0cgrEZzigyv+8bXwOG4Y0FLmzIMVW6dLkXpdm6W2VztWmT9
         b3SKSZou81GfNpgb/jPW3gEkIO/EbsM64z8T7FVmPqLX7qPdZOe9r1OEixK3rTHzOkiF
         dsoGNUclzMVN2Z015B4FC1rj/E1kVnkf7SDj3buIsN1asoMdx9j05DFYyoO3x/OW7yOC
         ETjYd02To3WQqWQZv/g4PfFxg91sznEGANEnD2Pe2ir2+McYG8M3DBxzaZlZ9qUogS4A
         /kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753453423; x=1754058223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gskfuFSjcZ1f9NqzVyfbU+2SXj6gH6Vy4UjfTOJinxk=;
        b=usie1B/xR9PIatnSGhZLw6z661MXAa0aNwaN0BziykQLzKhTeG1iV4YqTNuZcgvrI3
         zUirI0NRnqqmRYHyJ44tj6Quo6MeqmnPtAkZH8chV6aXCSApWuUDE1nq2W4nNF4gUlMC
         MVD41S8JulcEgyMsLUQ0e3g2htAtwifLW+4WgynLQNT88AeCNEMNNwul+LaGzfjMTW3u
         BqqeyCBEPE3dlrxS9IvivT5f/JCLtznxat9GJuEkkD4II1d0AY0jAeggyiSIGHm7mTLa
         Glz46T/pySvhLWNxHbWT32mVhfRa9Vi6MFXoTIf9lqVrDd3R4M6q6YPCyv6+FvxQ0wK5
         EniA==
X-Forwarded-Encrypted: i=1; AJvYcCUbZGONx4nVN3Xl+ueSCnDfVU7Ci4aaj3z6562PEkUW1iTu5xGdREXX49rntxBz8Onarydt011EiQ==@kvack.org
X-Gm-Message-State: AOJu0Yzn0KKlMM1naiW1lbzbmQroMbqvIrVBaqL5oTiFHHWBGahmo4Ot
	VxiU3dEAI1/8n3pkfCGdKpx6iWuYpBirn4lgRPmZPcR9Auf93JDgjqDZv2wKy26I3BkkQuZy0cb
	8kWI7
X-Gm-Gg: ASbGncs2lUG2hugafMfzgBSqvJMCOEzhRWB1eBRTudKeSEx8T0hwKyxunTxz+acqzM3
	3D/bEv5QS4KlLHHnWrqGTT5oX4UszSezKb0ldOR8ELcVUpakqMKZ3+MQC8rPM13gFzNZk74DdqW
	nIrDW8zkmyPukM/UIar66bU7mZ++cZduwTrKEtO/+SPJ1KlsxbmdNPYBRS1hp7h6stRe6a3QyXA
	irigvcyp10v2lkXYgr/sZiHKFXSjoGz3ItFaEQ32RlHKvIsMRZSsg1yQv2lqrqR7OZgCgJqbMpJ
	DtfjjqmuQzkvLeJpLm9p9TRq+Mze/ZpuHCPvFWBcH/PSwL0DwQJfed8Oqpecw8WZAB76dUd1sbN
	P64qNhc1j5yq8zkf/ax8QQtF2jxG9NtUq
X-Google-Smtp-Source: AGHT+IHRz5CbRE8i2UjdGDZpkxqOW3JD/QQJLFQFs49c4cRaClHO120ReCkQeIjI0YUgC/xMTK32oQ==
X-Received: by 2002:a17:902:f252:b0:234:ed31:fc94 with SMTP id d9443c01a7336-23fb30bb5edmr15941955ad.26.1753453422841;
        Fri, 25 Jul 2025 07:23:42 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fb3f2a5a8sm13203045ad.94.2025.07.25.07.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:23:42 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:23:38 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, andrew@sifive.com, ved@rivosinc.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH 11/11] riscv: Kconfig & Makefile for riscv kernel control
 flow integrity
Message-ID: <aIOTauktSYmw2LUV@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-11-04b8fa44c98c@rivosinc.com>
 <b50da4ef-53ca-4edf-bd74-f5e037a14f99@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b50da4ef-53ca-4edf-bd74-f5e037a14f99@canonical.com>
X-Rspamd-Queue-Id: 19EAA40013
X-Stat-Signature: mo335p33obbns3qpte6pz8jdbxx5quso
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753453423-131535
X-HE-Meta: U2FsdGVkX1/w3srlHGi/hyTrYlFoyEwYFA7PcRWxlzXMneCUER10Z7FbaNFCw0hD/lFLmYUZvqIRp+n29/YPDuvF50laBXHC2OtWd5igo5pT/3bfZkOXe4RVzRXk+5mqk2rIwVGH8jbnOYk1p9XCv/B9WkEm7RCVGXSfJbKfaRF5vhkO4Y7DlKgljbS9I8avHk/Gopk8JDmuj8IpYEKZX6nt0ZJSjQi8GEcMSHPFRSNjR+Dt4AUyT4652S3YDDjvY+i1/1Qpzr7v/4KG8uEpV1fnYnQHOm8Qie+ALFHgDKfGCedl52eCL8vGmUenyu/Ox0n9g/nncEL+M/x4PFRoXVm7HXn/ErWdmLiPbE585UbTmoQTrl4lSggVNsYuGy3fWHZfYlX1HjAPUbanVhVWRp0pZdg3tSLI5cLU7zHKTg8k6EweR+vIutac3jQCcz/4QedkujNliVFkDYFr2cmBFTy9ed5875jiN0CmS4ZhJ2PgA8Ops3hJU7oEGgZUqiz3GOpGfDOiSoUS5aosFDVAQwcWHmPngd7Z8Pht0f6kXQXiEHWt/oHbRG0xVxiqlrBIrM+0JBYZeFDOqYQyYUjWqKiNZLL30+8jM8m63fQFNzUp/M+cgnzQR3nVxvf9TvuVoTGcliutsF5o6+yPR0g0N9fCXqfZPhdcV8b9dFzqyoqP4z5KSJT79KzUzyWDZ1GNKDkQdvRxlNqifFsUlyKALPul4JiYGag1FPEKLLs44C5wwX1+ZNO5v4UldARVlDCaYI9K+4o+LeihcjKmwlkwasH0J6ibtjKd6lUc8tAbcGGhT1JDLdugbiQfmAIHHumUEvopfgrzSnOqdIzxMYWp7zMx3nAdj73iJCDmafE65aAq6x74QhlvBD3lYY9DAw+6tVajcHrQklmEXWZBa+XyNgWampvE6AYQWVUI/aNmqS6UWoCTPueJ683dd/4eA6S6SM59JxpMP3Gi//zFM0v
 9Yoo6XmI
 x4p3vD1+Puz21LIf2TuDjOJbvkD8qWVWYQruwdOQPp46b9XBU95fgbIxZLvLFKCSJSsaXjs2ukbu90+Tsj9Aq24v3NKveJiHQS8iSAY5mVRoHpMzMgl3RS/ElMhfJN8eG2AMWOzETcDApi09DBMB9y5nExy/hMP7KrbmXJ0lwXoTxT0U6+EbUwry+F0/CZ0lSWrnv0NjQLijElxr+523afS7Xw+rY7k4hHI86UrwuxF/kdpWNvf+Njhw9wGGAoi5K8XGBzV6x3FgOu3RUW6VTMT8a7eJmDGUkCJcg/iG1Ml2pP4CI6yOy9cL+PAiNsE6tBDaJVFwZoTnldJBrdcDmGehHsrei9MgPdb4hzC0ic73STtuURq+wQOk8HKC8UcJ75C5SjfGGYskFBl5WU7U2VFLVKFxrUHtCbdxQ5v3+drBVDlWFHLRNHQttLqJ41aQ54Wg2Lfz3bd9O2BkO9lTJxbFGPmmJTDgB7gVhDfr0gu1Nt75b/9ZRm8fh3bS3Q4QHtGcMEBZHbgPVaZWiO3Hbcm4LGVXofSpa3gmALVH61LJL1AOKZbe7VtyzTlFczx0sPcOUbi2DyM+N9qtSsdP9nbp1rYBHU36P9hY7Fout/tR1pr3XILxpkwm0Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 01:26:44PM +0200, Heinrich Schuchardt wrote:
>On 25.07.25 01:37, Deepak Gupta wrote:
>>Defines `CONFIG_RISCV_KERNEL_CFI` and selects SHADOW_CALL_STACK
>>and ARCH_HAS_KERNEL_SHADOW_STACK both so that zicfiss can be wired up.
>>
>>Makefile checks if CONFIG_RISCV_KERNEL_CFI is enabled, then light
>>up zicfiss and zicfilp compiler flags. CONFIG_RISCV_KERNEL_CFI is
>>dependent on CONFIG_RISCV_USER_CFI. There is no reason for user to
>>not select support for user cfi while enabling for kernel.
>>
>>compat vdso don't need fcf-protection (toolchain lacks support).
>>
>>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>---
>>  arch/riscv/Kconfig                     | 37 +++++++++++++++++++++++++++++++++-
>>  arch/riscv/Makefile                    |  8 ++++++++
>>  arch/riscv/kernel/compat_vdso/Makefile |  2 +-
>>  arch/riscv/kernel/vdso/Makefile        |  2 +-
>>  4 files changed, 46 insertions(+), 3 deletions(-)
>>
>>diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>>index 385c3d93e378..305ba5787f74 100644
>>--- a/arch/riscv/Kconfig
>>+++ b/arch/riscv/Kconfig
>>@@ -245,7 +245,7 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE
>>  	depends on CC_HAS_MIN_FUNCTION_ALIGNMENT || !RISCV_ISA_C
>>  config HAVE_SHADOW_CALL_STACK
>>-	def_bool $(cc-option,-fsanitize=shadow-call-stack)
>>+	def_bool $(cc-option,-fsanitize=shadow-call-stack) || $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
>>  	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
>>  	depends on $(ld-option,--no-relax-gp)
>>@@ -864,6 +864,16 @@ config RISCV_ISA_ZICBOP
>>  	  If you don't know what to do here, say Y.
>>+config TOOLCHAIN_HAS_ZICFILP
>>+	bool
>>+	default y
>>+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp)
>>+
>>+config TOOLCHAIN_HAS_ZICFISS
>>+	bool
>>+	default y
>>+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
>>+
>>  config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
>>  	def_bool y
>>  	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
>>@@ -1182,6 +1192,31 @@ config RISCV_USER_CFI
>>  	  space does not get protection "for free".
>>  	  default n.
>>+config RISCV_KERNEL_CFI
>>+	def_bool n
>>+	bool "hw assisted riscv kernel control flow integrity (kcfi)"
>>+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
>>+	depends on RISCV_USER_CFI
>>+	select ARCH_SUPPORTS_SHADOW_CALL_STACK
>>+	select SHADOW_CALL_STACK
>>+	select ARCH_HAS_KERNEL_SHADOW_STACK
>>+	help
>>+	  Provides CPU assisted control flow integrity to for riscv kernel.
>>+	  Control flow integrity is provided by implementing shadow stack for
>>+	  backward edge and indirect branch tracking for forward edge. Shadow
>>+	  stack protection is a hardware feature that detects function return
>>+	  address corruption. This helps mitigate ROP attacks. RISCV_KERNEL_CFI
>>+	  selects CONFIG_SHADOW_CALL_STACK which uses software based shadow
>>+	  stack but is unprotected against stray writes. Selecting RISCV_KERNEL_CFI
>>+	  will select CONFIG_DYNAMIC_SCS and will enable hardware assisted shadow
>>+	  stack protection against stray writes.
>
>Please, consider adding a blank line for better readability.

Noted. Will do.

>
>>+	  Indirect branch tracking enforces that all indirect branches must land
>>+	  on a landing pad instruction else CPU will fault. This enables forward
>>+	  control flow (call/jmp) protection in kernel and restricts all indirect
>>+	  call or jump in kernel to a landing pad instruction which mostly likely
>>+	  will be start of the function.
>>+	  default n
>
>For Linux distributions it is important that the same kernel can run 
>both on hardware both with and without CFI support. The description 
>provided does not help to understand if RISCV_KERNEL_CFI=y will result 
>in such a kernel. Please, enumerate the minimum set of extensions 
>needed for supporting a kernel built with RISCV_KERNEL_CFI=y. I guess 
>this will at least include Zimop.

Yes, it is expected anyone selecting this config is going to take this kernel to
a RVA23 hardware. RVA23 mandates zimop and thus shouldn't be an issue on such a
hardware. Anyone selecting this config and trying to run this kernel on hardware
prior to RVA23 will run into issues. I can add a comment here to highlight that.

I assume you wanted that awareness and goal is not maintain compat of same
kernel between RVA20 and RVA23 hardware, right?

>
>Best regards
>
>Heinrich
>
>>+
>>  endmenu # "Kernel features"
>>  menu "Boot options"
>>diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>>index 7128df832b28..6ef30a3d2bc4 100644
>>--- a/arch/riscv/Makefile
>>+++ b/arch/riscv/Makefile
>>@@ -61,8 +61,10 @@ else ifeq ($(CONFIG_LTO_CLANG),y)
>>  endif
>>  ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
>>+ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>  	KBUILD_LDFLAGS += --no-relax-gp
>>  endif
>>+endif
>>  # ISA string setting
>>  riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
>>@@ -91,6 +93,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
>>  KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
>>  export KBUILD_BASE_ISA
>>+ifeq ($(CONFIG_RISCV_KERNEL_CFI),y)
>>+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFILP) := $(riscv-march-y)_zicfilp
>>+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFISS) := $(riscv-march-y)_zicfiss
>>+KBUILD_CFLAGS += -fcf-protection=full
>>+KBUILD_AFLAGS += -fcf-protection=full
>>+endif
>>  # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
>>  # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
>>  KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
>>diff --git a/arch/riscv/kernel/compat_vdso/Makefile b/arch/riscv/kernel/compat_vdso/Makefile
>>index 24e37d1ef7ec..552131bc34d7 100644
>>--- a/arch/riscv/kernel/compat_vdso/Makefile
>>+++ b/arch/riscv/kernel/compat_vdso/Makefile
>>@@ -69,4 +69,4 @@ quiet_cmd_compat_vdsold = VDSOLD  $@
>>  # actual build commands
>>  quiet_cmd_compat_vdsoas = VDSOAS  $@
>>-      cmd_compat_vdsoas = $(COMPAT_CC) $(a_flags) $(COMPAT_CC_FLAGS) -c -o $@ $<
>>+      cmd_compat_vdsoas = $(COMPAT_CC) $(filter-out -fcf-protection=full, $(a_flags)) $(COMPAT_CC_FLAGS) -c -o $@ $<
>>diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>>index 2b528d82fa7d..7b1446b63ebc 100644
>>--- a/arch/riscv/kernel/vdso/Makefile
>>+++ b/arch/riscv/kernel/vdso/Makefile
>>@@ -17,7 +17,7 @@ ifdef CONFIG_VDSO_GETRANDOM
>>  vdso-syms += getrandom
>>  endif
>>-ifdef CONFIG_RISCV_USER_CFI
>>+ifneq ($(CONFIG_RISCV_USER_CFI), $(CONFIG_RISCV_KERNEL_CFI))
>>  CFI_MARCH = _zicfilp_zicfiss
>>  CFI_FULL = -fcf-protection=full
>>  endif
>>
>

