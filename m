Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06BFC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 07:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4196B0088; Sat, 26 Jul 2025 03:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194A36B0089; Sat, 26 Jul 2025 03:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083CD6B008A; Sat, 26 Jul 2025 03:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECA496B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:42:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95C281343BE
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 07:42:21 +0000 (UTC)
X-FDA: 83705622882.08.D87917E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E64940005
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 07:42:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gswPVrHk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753515740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvTWYWbJnd3Twi29+QTbfJLW1y0MCnmekCUUg3hBGB8=;
	b=0VtPJLNwlUeLSPtMSulCoXa6MN99taXhEewFLMXN4tEg95qsHsHW/Ttv3XsKKYWUmEqIAw
	+1Kt6VEf4aaSN2wtrDCGQo/VoIBf88wl/eJMRT9cmsS1u+XRhwV4Y/0pM90IkWUbcT2Peq
	UUyueV9zd1lLhGCsS1RUlP4zHEYSRt8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gswPVrHk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753515740; a=rsa-sha256;
	cv=none;
	b=TjD/r7EKScwBrwz/etBOTVGYMFAvUPl2G/r2rnJXpdn7g38VcN+usxM3v6tPUH7TUzUwJV
	/Vq6g85BYdhkE+Ozls1eATPH/pL766WyIdupUJreBcQzGmPkYvZsYjW7B7gL3bsGc/iFak
	qxTIB+KmUVsk0RkNn9iWHtZRO8WMPRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 3759EA522AC;
	Sat, 26 Jul 2025 07:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1BAC4CEED;
	Sat, 26 Jul 2025 07:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753515738;
	bh=JH80ui6HzMZrysAZcLLCGsZmU6VvUIi+CTfUhFaghYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gswPVrHk05CTmMSr0rmQsIvvtZGLK84sbkhG7vujS1AtdBJA3iUrxjWoNK98NMpda
	 ONzMzbP/rH/UKNn5AGjuowNFtCTTKJdWOGXj7+cXUBv4SjmXHMqXaZJ89BtyrLgtao
	 sSgrF+ZyPF68pEsFAuSeuuJQHuOzMAPxqSA19FKpb4XI3RynqKvZ9IPmNqv5FW9t1t
	 Itp5hGadOCbL7KVHwUT5/b25VhAxaXhNZif1/oxZZKHKJPwkfA8HoTwEF5HY7nWkCV
	 GGzrb4UeOALjgC2TLEYJIW4g8y91Wkoc30JITbnWHVGq3pXn4NFuyACkQGvB1r09oS
	 4LB9QaOFiYRwQ==
Date: Sat, 26 Jul 2025 10:42:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, heinrich.schuchardt@canonical.com,
	andrew@sifive.com, ved@rivosinc.com
Subject: Re: [PATCH 06/11] mm: Introduce ARCH_HAS_KERNEL_SHADOW_STACK
Message-ID: <aISGypOAaDGaUZgd@kernel.org>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-6-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-riscv_kcfi-v1-6-04b8fa44c98c@rivosinc.com>
X-Stat-Signature: htope3xoh6egj9kjzuspqhyna4xpizkk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E64940005
X-Rspam-User: 
X-HE-Tag: 1753515740-366255
X-HE-Meta: U2FsdGVkX18zktPkwyDvMTNN2yb8/PcbZdT0jneHLKrIp9iZkj2VTjQbqwSFVargKgMBh79uYNNYLWcd0Xe1AYDj9b9/iu4i2dK168O0GMZ7PMzIqmA42+l9SLygWhITYFjluuvGioWbarax6sOAopER2R9wQWFgY3t0xzVCZ346HtPnURCmLFfR6t7GMsjGHqnIcZgXM4+wpUh2GI/4XrzMEPxrHJRELnIB+wk1ZIeKDwizVT45hqRn/zE6ww6pQ2sCrUT/9Sl/Zj7sNixjS16wKxAgkwQq2qMiVuN3VWzbCFxDY+O6yCfIxnbO9CC+dYnAS6sp3oJbIh8nM33uwYSz7vC9AhwFS1OZbCORR6x4eekfCt/n7yjQX7kMFWE/JSeHZfTuyLnGmc5xtnz7piTrkqzAcwb/4mSYWOt3pUur7XheBdtJaK2h+a9wv6o1Ebk9DFoI6KomUMQwLxxb8kxMelZrZj9MvcLnChzNKq/6owe7gHbuS+buhk+UGTFUd4l3ctxNrtOFyNfM+1Y+5XIdLyhNCgV6zPFQdNc2hk6xb4Peu5QUOCh74uSqiKjQPbIPcIeyZbid4HqjQDxSu5IueR+VBBS8hp8ZAzyHT6AdSDfMttsLLMppxfslq2HPIFRU0t2dt2mTPuIGSc7H/sqOLwSgDcXBuMJeEwIcdSFFshAOXODyOv93hOXu7riBj05E++8+ptARl9vFwUE7Mgrozhn78XyML84ea30jIE9B1KrWWHxsVw8JwL7Xdc12gI718CyLev6Hb5F06Fl0LU3En03pk9RqVOKegC62SjLXtTDT9qgrCLWxMjkMq3NzEKknupgLMhc6MumRee8zHQ9ZrnJcSi3mhpI/tNVTOkJWxWkIhUh2s6ykxiDrKZ/7sFDnhIDzraulE7v+fpAiO8bS9bwTG9ZpV2AkCwTz9bO+BWEXkf66MNJxXJTIW2DwfjUYXgLnpJx389n208Q
 CHf/LeB9
 Vpp3uxvKnqpc69FnMHcKo4YZW6o0Py1fvQV9BmLHkDN3ggeVANdUnXkfIK7GbGHRwjfm0ZvxwrYRFJWY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:36:59PM -0700, Deepak Gupta wrote:
> commit bcc9d04e74 ("mm: Introduce ARCH_HAS_USER_SHADOW_STACK") introduced
> `ARCH_HAS_USER_SHADOW_STACK`. Introducing `ARCH_HAS_KERNEL_SHADOW_STACK`
> so that arches can enable hardware assistance for kernel shadow stack.
> 
> If `CONFIG_DYNAMIC_SCS` or `CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK` are
> selected, skip compiler flag `-fsanitizer=shadow-call-stack`.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  Makefile   | 2 +-
>  mm/Kconfig | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 35e6e5240c61..7e3ecca9353d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -987,7 +987,7 @@ LDFLAGS_vmlinux += --gc-sections
>  endif
>  
>  ifdef CONFIG_SHADOW_CALL_STACK
> -ifndef CONFIG_DYNAMIC_SCS
> +ifeq ($(or $(CONFIG_DYNAMIC_SCS),$(CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK)),false)
>  CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
>  KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
>  KBUILD_RUSTFLAGS += -Zsanitizer=shadow-call-stack
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 781be3240e21..f295ea611cdb 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1367,6 +1367,12 @@ config ARCH_HAS_USER_SHADOW_STACK
>  	  The architecture has hardware support for userspace shadow call
>            stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>  
> +config ARCH_HAS_KERNEL_SHADOW_STACK
> +	bool
> +	help
> +	  The architecture has hardware support for kernel shadow call
> +          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).

nit: tab and two space for indentation of the help text

> +

I think both ARCH_HAS_USER_SHADOW_STACK and ARCH_HAS_KERNEL_SHADOW_STACK
belong to arch/Kconfig rather than mm/Kconfig

>  config ARCH_SUPPORTS_PT_RECLAIM
>  	def_bool n
>  
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

