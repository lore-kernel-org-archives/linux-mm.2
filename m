Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1F5EA4FC2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC276B0088; Mon, 23 Feb 2026 08:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A576B0089; Mon, 23 Feb 2026 08:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D963B6B008A; Mon, 23 Feb 2026 08:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C387E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:52:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61AA888415
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:52:50 +0000 (UTC)
X-FDA: 84475862100.29.426AC70
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id 994B9A0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:52:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=dnVQezFK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Tk9zqDZo;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771854768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYN2ElQvz1bXGLb236MoycuOriEzIAg8a9PdtF1XU6M=;
	b=OvW60R2ZuExLzO8W6r1C5jfXBLRxdch+acxPHk5MNauBHc6kF8+wo793mwHu88ChReGywY
	LgGPF4S0ytZMZZ4AkMT5rJgZfHXGHfczqqfNtMn0urpkzfq3rzjTjEWNG7AelfF7ntvR/t
	x7qCiB4G4IjAEQwJSI/ecPa/KiPel/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771854768; a=rsa-sha256;
	cv=none;
	b=7gVf1fWZ5jEhPsiMzVpoC6FbTm66HKEKKk8WaJUxx6TN4N3YjMWb0joxZcX+nrJh6nIEDv
	/DPpHUGZkk1+f0MpmsIgyK/HtoeTGlAMEwA6kWU4iB/lUyfp/GV02POi3SeZGSDG+BxUO/
	wVvWSGAhtP82LI7eWSnXwmvGfkXigVw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=dnVQezFK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Tk9zqDZo;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 23 Feb 2026 14:52:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1771854765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN2ElQvz1bXGLb236MoycuOriEzIAg8a9PdtF1XU6M=;
	b=dnVQezFKSeL4QlKI1KpAXqUZs5gfTKhrpyvYBrCxSx7N3Y1Gc3BT9Yp/FK+6UZkPyUwZxf
	+yveBjQMn8jEK+BeoaY8Vk2G8cRZWQ7lIYdUky8JgEUOYqctFsPXaVFiAvy5i/+OdtEglC
	bcnndOvuPuukWw6T0HE45JTvs/sQ7TYEPK6TxFLD/CwZh4pfg+exZGlzQsaUET/zWBk7CS
	H9x3+Cmtk+dbKl8J3go/kjbh+WZzT57d6kvpH1x7iyCwLdwqFUM9oizXmOL/ySDdXJiv3V
	TXNokG9tyt6pOIwkyleL2IEsooBViQqUU8HfUfCJDTPnB3OFqUyeItP/E3aFaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1771854765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN2ElQvz1bXGLb236MoycuOriEzIAg8a9PdtF1XU6M=;
	b=Tk9zqDZoD56XAidgdo95hukb9YEaVDmXoZTjWWnY/9zTalzZjQJDPv5EHISHX0j/mEQA/j
	LtlKIXw/crURzGAA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Mike Rapoport <rppt@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3 24/29] arch, mm: consolidate initialization of SPARSE
 memory model
Message-ID: <20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-25-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111082105.290734-25-rppt@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: 56eq3teuirjpmysgypw47da7keazt8o3
X-Rspamd-Queue-Id: 994B9A0005
X-Rspam-User: 
X-HE-Tag: 1771854768-895175
X-HE-Meta: U2FsdGVkX1+2hqS6B4UO7fVzTtJtWEcQ1ciJst11SWEoF+MSJmNaTDvW4Uf1Jqkw9xwFcml7cjmsTOWD8M1GpjY3fdvVhxa0r9hilaO4Ui207YStO3ljKPAJkvtBeJUZdmPBiqM98PJvh5R51hgSRJcCwvaOtczHnxUaDLsJ8FxSutqWxrZb/UB8H7cJp8dS785keKcuMpWeqmPTap6d6jc+fXY3ZS7RxuZMav8ZVXaTL0YZ8WwDOMpRUUbe4K9kQtOOxzTsQKhIGQwdu8PRImuwRBeYNLqxC7KQ/wAHPWdTXXY7dcGvUJzJ61vHltBwayfTVYVrBgp9yhnG1MulQZT33RzijKkLH4RI8GadIAkrEYEFjftd01QseRIvj/1X7xIiLjZ2AZA1ruPhycY3XRsjaW+lP9F8W4GBExCw2Ff0SgLsKlx9n9thDzoz86ZvXodqff4G+VtaUrGblJ4BaNuZeclzwo9vI4EQDtBM4x4LE5l1VCo/Dl8KHStt8DRE+4BMlLu48Jxh0hP7noH/aVbPsCIetfTw4vxyecfw+vlDdtryPhecF4PGwzVtS784DlQ2kp5pbenr0n7ZkQlgG+c8He+ltgJ4xFs5rSRHFIhD4ZI8gRJbIbxWj+rxgAT7OggQk/OHyrpXloG1dFZKC4Vmo/8D13eJHSr+1Kf1QmI2QipKrLJE8Ny8DC3EVdou4rklOTTud/KO/6GYhJe+g0BVWnX08KSGbc7yVD6TlpwZmnoLldqrG7s9ykJlz1AtWeQgEwkzpm/IlsW7TkUQR43O7c4gxX3VGO25v5bkQ78XfPI/I4uSXE2i6iRnicNvK5z2hQVfMaiSmRDBvk74fK4K0T8cXauhlte70e8PZqPgwZmCpTtmK9eui/O+jPAA8plgP+P/d0ygwJQjHHwwahv5hcfRr/UzqeG/TAXE82dugpOnUvYgsO0YBUUcZ0v8YybtjjBCuAmi1EdN3mu
 Lpdbtiao
 RK531jLX+3Q7Hf4kxONx3bd3i1/CVATYeMz1HpdQ3UfhZmTmQOKDNPfPYV5pbBeT6H5WIJXqdBlYEL/xdQJSkRmAC5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

On Sun, Jan 11, 2026 at 10:20:58AM +0200, Mike Rapoport wrote:
> Every architecture calls sparse_init() during setup_arch() although the
> data structures created by sparse_init() are not used until the
> initialization of the core MM.
> 
> Beside the code duplication, calling sparse_init() from architecture
> specific code causes ordering differences of vmemmap and HVO initialization
> on different architectures.
> 
> Move the call to sparse_init() from architecture specific code to
> free_area_init() to ensure that vmemmap and HVO initialization order is
> always the same.

This broke the boot on RISC-V 32-bit (rv32_defconfig) for me.

Specifically if sparse_init() is *not* called before the following callchain,
the kernel dies at that point.

start_kernel()
  setup_arch()
    apply_boot_alternatives()
      _apply_alternatives()
        riscv_cpufeature_patch_func()
          patch_text_nosync()
          riscv_alternative_fix_offsets()


Simple reproducer, using kunit:

./tools/testing/kunit/kunit.py run --raw_output=all --make_options LLVM=1 --arch riscv32 --kconfig_add CONFIG_SPARSEMEM_MANUAL=y --kconfig_add CONFIG_SPARSEMEM=y

> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  Documentation/mm/memory-model.rst                    |  3 ---
>  Documentation/translations/zh_CN/mm/memory-model.rst |  2 --
>  arch/alpha/kernel/setup.c                            |  1 -
>  arch/arm/mm/init.c                                   |  6 ------
>  arch/arm64/mm/init.c                                 |  6 ------
>  arch/csky/kernel/setup.c                             |  2 --
>  arch/loongarch/kernel/setup.c                        |  8 --------
>  arch/mips/kernel/setup.c                             | 11 -----------
>  arch/parisc/mm/init.c                                |  2 --
>  arch/powerpc/include/asm/setup.h                     |  4 ++++
>  arch/powerpc/mm/mem.c                                |  5 -----
>  arch/powerpc/mm/numa.c                               |  2 --
>  arch/riscv/mm/init.c                                 |  1 -
>  arch/s390/mm/init.c                                  |  1 -
>  arch/sh/mm/init.c                                    |  2 --
>  arch/sparc/mm/init_64.c                              |  2 --
>  arch/x86/mm/init_32.c                                |  1 -
>  arch/x86/mm/init_64.c                                |  2 --
>  include/linux/mmzone.h                               |  2 --
>  mm/internal.h                                        |  6 ++++++
>  mm/mm_init.c                                         |  1 +
>  21 files changed, 11 insertions(+), 59 deletions(-)

(...)

