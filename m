Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED7BCFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488EC6B0023; Mon, 24 Nov 2025 04:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439476B0024; Mon, 24 Nov 2025 04:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA296B0026; Mon, 24 Nov 2025 04:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11B956B0023
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:54:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDEC4888C9
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:54:27 +0000 (UTC)
X-FDA: 84145040574.25.63C2957
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9E8F380018
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:54:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=P87gnIuA;
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763978066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B05uJapQfRMGohKkgF1xNVyERBHmagh8Bd3xg1q2NeI=;
	b=XAMKO/vED7f3MKi1jSYiM2p6XtS1mBJ8a1et+ew31jFYKpTQlWmb0j/uZffSbbAxaugYTc
	1v/KIXcrYKdE+wL5IHyz08UNefXjXz0XMdNYTMbwc2KTImRobPJ+f1CuAmcD0woPpEWbLi
	rD7aKsyYZTEkRXZRFpN+gAsumwuBGCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763978066; a=rsa-sha256;
	cv=none;
	b=ztaPGgJh9ixd02xHfVm1ElSJ9JpkNMbdgmJAx5kvKX751xeekxLEqGFHydP4OtAJB1A9qN
	EIOTNYiHNBXPhnijGVo8STwUj1tX0yguToeTKB5VbUp2nsfdB6nScuBRjigs77gM9gv5Si
	3lTKNq6bVPREwSAQ1atQa1cJCwkApMs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=P87gnIuA;
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=B05uJapQfRMGohKkgF1xNVyERBHmagh8Bd3xg1q2NeI=; 
	b=P87gnIuANW/TJp73uiT1mmsGlTWnBuH0H7vh23lNqSWq4OBDSGmsQEtkmAFMHotC7U4wL6z8BsM
	xZhrA2DnJ6Byz1eNq9hCgsl0YlQqjChTspvActJHQABJusXSSyN3NViM7BAWMow9uYLi6/azgr/1S
	bPNPkqeI4K++8lXngyxVPKygWdoefLDaHUV8R9vP4h+Voyby/LgDfyG/U2ZiZD9XFH7HpGmBTtoYh
	gxxkqEEHWY1my7y2fTHFr9TydDJrVMgiVb3KBgJmEGPf57jfBn092eZeVh0rkWj5FfVDm/r5gwJdx
	bl004005PGTqWH4a9OI+Nq6nG2BqQ4oMU7WA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vNTCh-005XNj-0w;
	Mon, 24 Nov 2025 17:49:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Nov 2025 17:49:51 +0800
Date: Mon, 24 Nov 2025 17:49:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexei Starovoitov <ast@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	Christian Brauner <brauner@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>, David Ahern <dsahern@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dennis Zhou <dennis@kernel.org>, Eric Dumazet <edumazet@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Allen <john.allen@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Juergen Gross <jgross@suse.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mika Westerberg <westeri@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Neal Cardwell <ncardwell@google.com>, nic_swsd@realtek.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Olivia Mackall <olivia@selenic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, x86@kernel.org,
	Yury Norov <yury.norov@gmail.com>, amd-gfx@lists.freedesktop.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, mptcp@lists.linux.dev,
	netdev@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 00/44] Change a lot of min_t() that might mask high bits
Message-ID: <aSQqP6nlqGYOGqcJ@gondor.apana.org.au>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
X-Stat-Signature: 8htc7cafcon3ktbm1135ufiq9nofchbu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E8F380018
X-Rspamd-Server: rspam01
X-HE-Tag: 1763978065-447876
X-HE-Meta: U2FsdGVkX19CdAjwDXZvzjIwI4Y3GILsF/zmLxCWswDjkL+cECM6XjIKgk2m7OHVfxcaVefLCtNjJ1ZzlALqkZa1yS0Iy9U22tNMmpuYPwLTA1A6yGRhWs52TQUGorfTeBWd0FkjBTv4ZSJw0I3a7XLJXgCrQRfgMbIJ6JqGlL73QarqKvjJ7BJlH4VTSm75oei3Oznwkc/qZOKzxjRfJiPjuNu5qFtUdaOAuLpDOKLmUz0Lho2h9uFP6z/v0Xb+DafCQQ/nhGNbQhcJCMqe2d5Zz+uyevxTjswEJFM+TZuN9wx+iAjE8AxBPZAEHLp1ZV0TABx/CzOZEBNZAa9eKv5t4Vx+biJZQTAGwQ/J/VJL1ZC+SbIcewuLGokHPPBYDFe7uzxYqZ8Ct3Ku1sa6aLFnqgMgUtsWUf1wNLvtTs7Ubla/nV1u+YetN+4KgRS2Lm/ubsIffC9BSQGCkAL9H57fRCYNxT55X+TuDmn5PKxz65CTME69wu7ArvyaYFKolqh2At8Ijq/WQInBj3JStK/jHaDoFMzWV2AVh6dzgW6kMNdZNWrinwUNTSsJYnJeAAeeNOsRCBeoZh89cxXL316WLMlTn236NmNP1hNgvfj6InG5PU7bsF4x0V6SGT4ZSFYA2q1w8u/KEaahsR/alOHTw5l7hyLx5OtO9x0Xb0g0MQojo4buExwjP8B+7VL0xFF6wMnDxr4h0h8zAXa2S4zbf+EZR7V4752ncggXSIoCrrPv1y3+bggQ46M5S1yH/7j6CSvnqeW/Us7Vz/xo06PCLXjgqnE4zMvXxdKHMxQkUqEnT/XMycw1kWo31uxh9Fmua1s7yCk2KKEaUG0+a/rSQvxeyht9k2LhFqtcSaQ6S1+r8ldo0gSEqS0QV59EzgnAubVqv0sOsn6BgMAOkplFDE4pXD74vt/mgHM7FaGlDdg+eU6NprHKZSxfGWNLruOxoTdNXng6w8JWpqZ
 yPcj2jzC
 A1zzkfAW0aHVdIwUKi8GG9SFX1KsMAHrHFfdR4t8hU8/mwzwZ0qAV4s9BnQEKByyJZfgWDQB5ZijVkjjuDb2cGUB70rbBiTa9hmoYOvk0X2HO7LUV050Ornj4iDKVE+k1MlAfesTV9QIZ8922l1aZraLo4q1scKxhQc2aAh1eESai2cHkp9w9iP+fu/C0S8sGD0YBT1SBGBDknxstNvFGv2Aq92w8fnqarg/gonTJJPzqPrce5tsf0c2iTMsWtFk0zIL23rf3MXvE3Pf3y8I9XcKyIKRA0ElIR9kYTgNpU+uLUl0Uf9cywYpj393uG500yBFCUt/yaq15Gh4kprmGCiKV4qPFfc0hACzmKmVCuVWGiORRr3dwYbFBEZbpUqXZzdT9olYqZX8NXM3GpoXGhUamVqqMmyNph1Ieku/Kqt5GeLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 10:40:56PM +0000, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> It in not uncommon for code to use min_t(uint, a, b) when one of a or b
> is 64bit and can have a value that is larger than 2^32;
> This is particularly prevelant with:
> 	uint_var = min_t(uint, uint_var, uint64_expression);
> 
> Casts to u8 and u16 are very likely to discard significant bits.
> 
> These can be detected at compile time by changing min_t(), for example:
> #define CHECK_SIZE(fn, type, val) \
> 	BUILD_BUG_ON_MSG(sizeof (val) > sizeof (type) && \
> 		!statically_true(((val) >> 8 * (sizeof (type) - 1)) < 256), \
> 		fn "() significant bits of '" #val "' may be discarded")
> 
> #define min_t(type, x, y) ({ \
> 	CHECK_SIZE("min_t", type, x); \
> 	CHECK_SIZE("min_t", type, y); \
> 	__cmp_once(min, type, x, y); })
> 
> (and similar changes to max_t() and clamp_t().)
> 
> This shows up some real bugs, some unlikely bugs and some false positives.
> In most cases both arguments are unsigned type (just different ones)
> and min_t() can just be replaced by min().
> 
> The patches are all independant and are most of the ones needed to
> get the x86-64 kernel I build to compile.
> I've not tried building an allyesconfig or allmodconfig kernel.
> I've also not included the patch to minmax.h itself.
> 
> I've tried to put the patches that actually fix things first.
> The last one is 0009.
> 
> I gave up on fixing sched/fair.c - it is too broken for a single patch!
> The patch for net/ipv4/tcp.c is also absent because do_tcp_getsockopt()
> needs multiple/larger changes to make it 'sane'.
> 
> I've had to trim the 124 maintainers/lists that get_maintainer.pl finds
> from 124 to under 100 to be able to send the cover letter.
> The individual patches only go to the addresses found for the associated files.
> That reduces the number of emails to a less unsane number.
> 
> David Laight (44):
>   x86/asm/bitops: Change the return type of variable__ffs() to unsigned
>     int
>   ext4: Fix saturation of 64bit inode times for old filesystems
>   perf: Fix branch stack callchain limit
>   io_uring/net: Change some dubious min_t()
>   ipc/msg: Fix saturation of percpu counts in msgctl_info()
>   bpf: Verifier, remove some unusual uses of min_t() and max_t()
>   net/core/flow_dissector: Fix cap of __skb_flow_dissect() return value.
>   net: ethtool: Use min3() instead of nested min_t(u16,...)
>   ipv6: __ip6_append_data() don't abuse max_t() casts
>   x86/crypto: ctr_crypt() use min() instead of min_t()
>   arch/x96/kvm: use min() instead of min_t()
>   block: use min() instead of min_t()
>   drivers/acpi: use min() instead of min_t()
>   drivers/char/hw_random: use min3() instead of nested min_t()
>   drivers/char/tpm: use min() instead of min_t()
>   drivers/crypto/ccp: use min() instead of min_t()
>   drivers/cxl: use min() instead of min_t()
>   drivers/gpio: use min() instead of min_t()
>   drivers/gpu/drm/amd: use min() instead of min_t()
>   drivers/i2c/busses: use min() instead of min_t()
>   drivers/net/ethernet/realtek: use min() instead of min_t()
>   drivers/nvme: use min() instead of min_t()
>   arch/x86/mm: use min() instead of min_t()
>   drivers/nvmem: use min() instead of min_t()
>   drivers/pci: use min() instead of min_t()
>   drivers/scsi: use min() instead of min_t()
>   drivers/tty/vt: use umin() instead of min_t(u16, ...) for row/col
>     limits
>   drivers/usb/storage: use min() instead of min_t()
>   drivers/xen: use min() instead of min_t()
>   fs: use min() or umin() instead of min_t()
>   block: bvec.h: use min() instead of min_t()
>   nodemask: use min() instead of min_t()
>   ipc: use min() instead of min_t()
>   bpf: use min() instead of min_t()
>   bpf_trace: use min() instead of min_t()
>   lib/bucket_locks: use min() instead of min_t()
>   lib/crypto/mpi: use min() instead of min_t()
>   lib/dynamic_queue_limits: use max() instead of max_t()
>   mm: use min() instead of min_t()
>   net: Don't pass bitfields to max_t()
>   net/core: Change loop conditions so min() can be used
>   net: use min() instead of min_t()
>   net/netlink: Use umin() to avoid min_t(int, ...) discarding high bits
>   net/mptcp: Change some dubious min_t(int, ...) to min()
> 
>  arch/x86/crypto/aesni-intel_glue.c            |  3 +-
>  arch/x86/include/asm/bitops.h                 | 18 +++++-------
>  arch/x86/kvm/emulate.c                        |  3 +-
>  arch/x86/kvm/lapic.c                          |  2 +-
>  arch/x86/kvm/mmu/mmu.c                        |  2 +-
>  arch/x86/mm/pat/set_memory.c                  | 12 ++++----
>  block/blk-iocost.c                            |  6 ++--
>  block/blk-settings.c                          |  2 +-
>  block/partitions/efi.c                        |  3 +-
>  drivers/acpi/property.c                       |  2 +-
>  drivers/char/hw_random/core.c                 |  2 +-
>  drivers/char/tpm/tpm1-cmd.c                   |  2 +-
>  drivers/char/tpm/tpm_tis_core.c               |  4 +--
>  drivers/crypto/ccp/ccp-dev.c                  |  2 +-
>  drivers/cxl/core/mbox.c                       |  2 +-
>  drivers/gpio/gpiolib-acpi-core.c              |  2 +-
>  .../gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c  |  4 +--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c        |  2 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
>  drivers/i2c/busses/i2c-designware-master.c    |  2 +-
>  drivers/net/ethernet/realtek/r8169_main.c     |  3 +-
>  drivers/nvme/host/pci.c                       |  3 +-
>  drivers/nvme/host/zns.c                       |  3 +-
>  drivers/nvmem/core.c                          |  2 +-
>  drivers/pci/probe.c                           |  3 +-
>  drivers/scsi/hosts.c                          |  2 +-
>  drivers/tty/vt/selection.c                    |  9 +++---
>  drivers/usb/storage/protocol.c                |  3 +-
>  drivers/xen/grant-table.c                     |  2 +-
>  fs/buffer.c                                   |  2 +-
>  fs/exec.c                                     |  2 +-
>  fs/ext4/ext4.h                                |  2 +-
>  fs/ext4/mballoc.c                             |  3 +-
>  fs/ext4/resize.c                              |  2 +-
>  fs/ext4/super.c                               |  2 +-
>  fs/fat/dir.c                                  |  4 +--
>  fs/fat/file.c                                 |  3 +-
>  fs/fuse/dev.c                                 |  2 +-
>  fs/fuse/file.c                                |  8 ++---
>  fs/splice.c                                   |  2 +-
>  include/linux/bvec.h                          |  3 +-
>  include/linux/nodemask.h                      |  9 +++---
>  include/linux/perf_event.h                    |  2 +-
>  include/net/tcp_ecn.h                         |  5 ++--
>  io_uring/net.c                                |  6 ++--
>  ipc/mqueue.c                                  |  4 +--
>  ipc/msg.c                                     |  6 ++--
>  kernel/bpf/core.c                             |  4 +--
>  kernel/bpf/log.c                              |  2 +-
>  kernel/bpf/verifier.c                         | 29 +++++++------------
>  kernel/trace/bpf_trace.c                      |  2 +-
>  lib/bucket_locks.c                            |  2 +-
>  lib/crypto/mpi/mpicoder.c                     |  2 +-
>  lib/dynamic_queue_limits.c                    |  2 +-
>  mm/gup.c                                      |  4 +--
>  mm/memblock.c                                 |  2 +-
>  mm/memory.c                                   |  2 +-
>  mm/percpu.c                                   |  2 +-
>  mm/truncate.c                                 |  3 +-
>  mm/vmscan.c                                   |  2 +-
>  net/core/datagram.c                           |  6 ++--
>  net/core/flow_dissector.c                     |  7 ++---
>  net/core/net-sysfs.c                          |  3 +-
>  net/core/skmsg.c                              |  4 +--
>  net/ethtool/cmis_cdb.c                        |  7 ++---
>  net/ipv4/fib_trie.c                           |  2 +-
>  net/ipv4/tcp_input.c                          |  4 +--
>  net/ipv4/tcp_output.c                         |  5 ++--
>  net/ipv4/tcp_timer.c                          |  4 +--
>  net/ipv6/addrconf.c                           |  8 ++---
>  net/ipv6/ip6_output.c                         |  7 +++--
>  net/ipv6/ndisc.c                              |  5 ++--
>  net/mptcp/protocol.c                          |  8 ++---
>  net/netlink/genetlink.c                       |  9 +++---
>  net/packet/af_packet.c                        |  2 +-
>  net/unix/af_unix.c                            |  4 +--
>  76 files changed, 141 insertions(+), 176 deletions(-)

Patches 10,14,16,37 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

