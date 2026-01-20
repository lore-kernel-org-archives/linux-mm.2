Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FF5CA5FB9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30956B046C; Tue, 20 Jan 2026 12:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF086B046E; Tue, 20 Jan 2026 12:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ABB6B046F; Tue, 20 Jan 2026 12:25:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD4606B046C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:25:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 485898C15D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:25:13 +0000 (UTC)
X-FDA: 84353018106.26.04D951F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B055C000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:25:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YuhQzc8V;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768929911; a=rsa-sha256;
	cv=none;
	b=st5JPUBaHdsuLjyQtF4h7FR+j1caWI+n4s8nTsAJxuH4WombWElgI9MIBN9my3cDKxgDt3
	3156rAzOf0eoIGATDeYHMmR9Cx0pB06LwsbNorxgGnz4JYaDBK9lbuDK3cqKlhiZ1gXJ8u
	VSqSGXolXacnnFhqVuuS3L6Ydap5jXM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YuhQzc8V;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768929911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/SyHKIfT52m21jYTqMJn0kce5uLNXDcSuIH1lAA/Hw=;
	b=Cwciintk2yQiqPc6cdBwoxZiP4VGWLeP2fMZRlDenhfBhkX58sOAqLxz9tivVKC/bB1oDS
	GBNaICyCTOUT8pEDbx0HlUlupsCoNVKz2nYkhQ92KtKf9SXIo80KsxFSo3x9RYAUQveKCt
	P3Y52cUfBjIKfqEE7jaI4l9yWhHjR2Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36EB0419A1;
	Tue, 20 Jan 2026 17:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1CBC16AAE;
	Tue, 20 Jan 2026 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768929910;
	bh=uwcLAOQjUO7lgxgkzAkEQvTOODBzpF5UAYJY///qzRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YuhQzc8Vo5QgOoQr9WpCPpsmsss0Ld5GnV1/9/q1mqcvMKHE+oa93rfwoKENXXr/a
	 ewFcnaoV4m1ruoMthZ8RU1USM8Yrby4s3UMWbtBVZHhO53uATdVtLk9WJ0zZ+NXPb9
	 5wJ3QTmYYbuSpGNXGL4z6pg3KFAg9U5s7aW4dc5utdJHzcX2bqWafG7oh4+JBs8nOX
	 0PZvInefyHxobeICJIRrwnX7ql0dYyws+eIerB/K3pJva2Wsm/KYak7HDCAVcGQYeb
	 2+0rMWBXq8l4uerPAhKBVjhko1zlrLKcA7N9sITfLuGwrGDuZI5YCLoEF6BKDwMBpt
	 ZfZxqeLfxecNw==
Date: Tue, 20 Jan 2026 19:25:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 2/2] kho: Remove finalize state and clients
Message-ID: <aW-6bdsOScsBodwe@kernel.org>
References: <20260116034432.1520731-1-jasonmiu@google.com>
 <20260116034432.1520731-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116034432.1520731-3-jasonmiu@google.com>
X-Stat-Signature: wu8xc9wjr5kcm81if9otbjcp95mmjbby
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B055C000C
X-Rspam-User: 
X-HE-Tag: 1768929911-516330
X-HE-Meta: U2FsdGVkX1/KkxvFzvMOdnx6H/KuLd26WFQNgeg4qMssjnavK+fGLf+M8kLww47R08eKoby25XJjxzzGGayoaiuaZj3hxfv8c8sLfCH+j0EMnMjp6z31RCC8VAIt7C7Ii29pn/q24VhckMTiEMllk16RY5BeY6WU6qpqStsdEL2cY0baxzlZ0EuyS46ROgOKaPhsUypl40PNcqBSQmNSHhm6WpY+D/HHUGKmkLP9SEmL61/tn15PLpLQOTHBmjwzdC4A/AzFAXZybwfNIPhsqywMzeturzqjTAoYAx9U2IJsKtSlyL5oM+xm2ZM1YgV/HozbScvXVz3cZQ3awHJ3Y14Ljm5DNQ1hX8C8vlacOPcNSyYNxSnjY09n2KaC6KVqgnA2T8vWXWk9fKSrv941o8m1+CaZ+OISiz+Cn9LRZDSZH1Wpp5N0MBZJsfjt+gEzJzpI2jL4YlZ+wVl2x80bz5Mb+GRWYanZf4rXVf73/bGsTZKQHqoF31/tNmkJVDxuOWJdtjpHN+Wn5n/VH6J5sNoG0cQwo5WX0er9nCU8eY4L5//eAE8VSRWRd62BgJ32muggFIz4Eg3hxqZ76K7FhvPEuKF+lINAfihO+7hjJo4VHmHU7/4ZGRpMaIHyob1yUJ3lAzKnMdB9k72WYyu5gPLUsFpjtMoUUlNg1UTTXz/1MY3lqcuVEY2KUhzKrcg1cTISa2UAIc61J9N5Rd0hJz9Ciw8BcS+uL0DQFZsyvfqyAsXljxfP82q7rfwY1IdOXHdQdOc5idJDVlnqhFdfL3zUePhpkxe54FcwQx120yKtlpnxO7ip+L2jJVz1CtwdQ5EbSO6RsoeD5D++BerVs7itpX3Ik45b4jFanJn/+yBAD2CPr4tF1WoMzwbuN26B8f42Yc5ecM3kw8x9bnMz/2XQo84dQpIbOTJxN8SzVQAfeANomS9ngxcYYSMlmNLsyR1X/Ui9SCx7raAimev
 4oOB4rzs
 sKVL4FiAHxVwUF4sTcgauXEXqDX3/yGrR8iP8Vw1XeGfeM8kDZHS1NYtzJ8D2lPOGnJzqQ4nFvciW94kYa3p4sXNEQjrGqxbrZlMzbSwIV+05e9sGe0f1rADC1Yx9S+jrcQz2G9qBCVu9uvyUHhmny88nJLFGgLT2A0a2aAY+2Ac3Ys9bV/qI2z2e0K2XsoEUr+gFKcCQ/sl39JPkgEVuEvdKHdbTmd7kcK2NkT35aajAVHhmOIXYDwUKuHNgN1JXJUWYoilX24B6sHny2PnI8XVo9Blh2TeWH3mvuYF44pSFwP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 07:44:32PM -0800, Jason Miu wrote:
> Eliminate the `kho_finalize()` function and its associated state from
> the KHO subsystem. The transition to a radix tree for memory tracking
> makes the explicit "finalize" state and its serialization step
> obsolete.
> 
> Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
> implementations. Update KHO client code and the debugfs interface to
> no longer call or depend on the `kho_finalize()` mechanism.
> 
> Complete the move towards a stateless KHO, simplifying the overall
> design by removing unnecessary state management.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/admin-guide/mm/kho.rst        | 53 +++++----------------
>  Documentation/core-api/kho/index.rst        | 12 -----
>  kernel/liveupdate/kexec_handover.c          | 21 +-------
>  kernel/liveupdate/kexec_handover_debugfs.c  | 23 ---------
>  kernel/liveupdate/kexec_handover_internal.h |  3 --
>  kernel/liveupdate/luo_core.c                | 12 +----
>  kernel/liveupdate/luo_flb.c                 |  2 +-
>  tools/testing/selftests/kho/init.c          | 20 --------
>  8 files changed, 14 insertions(+), 132 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
> index 6dc18ed4b886..454b378cf239 100644
> --- a/Documentation/admin-guide/mm/kho.rst
> +++ b/Documentation/admin-guide/mm/kho.rst
> @@ -28,20 +28,10 @@ per NUMA node scratch regions on boot.
>  Perform a KHO kexec
>  ===================
>  
> -First, before you perform a KHO kexec, you need to move the system into
> -the :ref:`KHO finalization phase <kho-finalization-phase>` ::
> -
> -  $ echo 1 > /sys/kernel/debug/kho/out/finalize
> -
> -After this command, the KHO FDT is available in
> -``/sys/kernel/debug/kho/out/fdt``. Other subsystems may also register
> -their own preserved sub FDTs under
> -``/sys/kernel/debug/kho/out/sub_fdts/``.
> -
> -Next, load the target payload and kexec into it. It is important that you
> -use the ``-s`` parameter to use the in-kernel kexec file loader, as user
> -space kexec tooling currently has no support for KHO with the user space
> -based file loader ::
> +To perform a KHO kexec, load the target payload and kexec into it. It
> +is important that you use the ``-s`` parameter to use the in-kernel
> +kexec file loader, as user space kexec tooling currently has no
> +support for KHO with the user space based file loader ::
>  
>    # kexec -l /path/to/bzImage --initrd /path/to/initrd -s
>    # kexec -e
> @@ -52,40 +42,19 @@ For example, if you used ``reserve_mem`` command line parameter to create
>  an early memory reservation, the new kernel will have that memory at the
>  same physical address as the old kernel.
>  
> -Abort a KHO exec
> -================
> -
> -You can move the system out of KHO finalization phase again by calling ::
> -
> -  $ echo 0 > /sys/kernel/debug/kho/out/active
> -
> -After this command, the KHO FDT is no longer available in
> -``/sys/kernel/debug/kho/out/fdt``.
> -
>  debugfs Interfaces
>  ==================
>  
> +These debugfs interfaces are available when the kernel is compiled with
> +``CONFIG_KEXEC_HANDOVER_DEBUGFS`` enabled.
> +
>  Currently KHO creates the following debugfs interfaces. Notice that these
>  interfaces may change in the future. They will be moved to sysfs once KHO is
>  stabilized.
>  
> -``/sys/kernel/debug/kho/out/finalize``
> -    Kexec HandOver (KHO) allows Linux to transition the state of
> -    compatible drivers into the next kexec'ed kernel. To do so,
> -    device drivers will instruct KHO to preserve memory regions,
> -    which could contain serialized kernel state.
> -    While the state is serialized, they are unable to perform
> -    any modifications to state that was serialized, such as
> -    handed over memory allocations.
> -
> -    When this file contains "1", the system is in the transition
> -    state. When contains "0", it is not. To switch between the
> -    two states, echo the respective number into this file.
> -
>  ``/sys/kernel/debug/kho/out/fdt``
> -    When KHO state tree is finalized, the kernel exposes the
> -    flattened device tree blob that carries its current KHO
> -    state in this file. Kexec user space tooling can use this
> +    The kernel exposes the flattened device tree blob that carries its
> +    current KHO state in this file. Kexec user space tooling can use this
>      as input file for the KHO payload image.
>  
>  ``/sys/kernel/debug/kho/out/scratch_len``
> @@ -100,8 +69,8 @@ stabilized.
>      it should place its payload images.
>  
>  ``/sys/kernel/debug/kho/out/sub_fdts/``
> -    In the KHO finalization phase, KHO producers register their own
> -    FDT blob under this directory.
> +    KHO producers can register their own FDT blob another binary blob under

Nit:                                      ^ FDT or another binary blob

> +    this directory.
>  
>  ``/sys/kernel/debug/kho/in/fdt``
>      When the kernel was booted with Kexec HandOver (KHO),
> diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
> index 002bdf0beb2e..0a2dee4f8e7d 100644
> --- a/Documentation/core-api/kho/index.rst
> +++ b/Documentation/core-api/kho/index.rst
> @@ -71,18 +71,6 @@ for boot memory allocations and as target memory for kexec blobs, some parts
>  of that memory region may be reserved. These reservations are irrelevant for
>  the next KHO, because kexec can overwrite even the original kernel.
>  
> -.. _kho-finalization-phase:
> -
> -KHO finalization phase
> -======================
> -
> -To enable user space based kexec file loader, the kernel needs to be able to
> -provide the FDT that describes the current kernel's state before
> -performing the actual kexec. The process of generating that FDT is
> -called serialization. When the FDT is generated, some properties
> -of the system may become immutable because they are already written down
> -in the FDT. That state is called the KHO finalization phase.
> -
>  Kexec Handover Radix Tree
>  =========================
>  
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 06adaf56cd69..14d2c66491a6 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -68,8 +68,7 @@ early_param("kho", kho_parse_enable);
>  
>  struct kho_out {
>  	void *fdt;
> -	bool finalized;
> -	struct mutex lock; /* protects KHO FDT finalization */
> +	struct mutex lock; /* protects KHO FDT */
>  
>  	struct kho_radix_tree radix_tree;
>  	struct kho_debugfs dbg;
> @@ -80,7 +79,6 @@ static struct kho_out kho_out = {
>  	.radix_tree = {
>  		.lock = __MUTEX_INITIALIZER(kho_out.radix_tree.lock),
>  	},
> -	.finalized = false,
>  };
>  
>  /**
> @@ -1209,23 +1207,6 @@ void kho_restore_free(void *mem)
>  }
>  EXPORT_SYMBOL_GPL(kho_restore_free);
>  
> -int kho_finalize(void)
> -{
> -	if (!kho_enable)
> -		return -EOPNOTSUPP;
> -
> -	guard(mutex)(&kho_out.lock);
> -	kho_out.finalized = true;
> -
> -	return 0;
> -}
> -
> -bool kho_finalized(void)
> -{
> -	guard(mutex)(&kho_out.lock);
> -	return kho_out.finalized;
> -}
> -
>  struct kho_in {
>  	phys_addr_t fdt_phys;
>  	phys_addr_t scratch_phys;
> diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
> index 2abbf62ba942..430c9521d59c 100644
> --- a/kernel/liveupdate/kexec_handover_debugfs.c
> +++ b/kernel/liveupdate/kexec_handover_debugfs.c
> @@ -75,24 +75,6 @@ void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
>  	}
>  }
>  
> -static int kho_out_finalize_get(void *data, u64 *val)
> -{
> -	*val = kho_finalized();
> -
> -	return 0;
> -}
> -
> -static int kho_out_finalize_set(void *data, u64 val)
> -{
> -	if (val)
> -		return kho_finalize();
> -	else
> -		return -EINVAL;
> -}
> -
> -DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
> -			 kho_out_finalize_set, "%llu\n");
> -
>  static int scratch_phys_show(struct seq_file *m, void *v)
>  {
>  	for (int i = 0; i < kho_scratch_cnt; i++)
> @@ -198,11 +180,6 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
>  	if (IS_ERR(f))
>  		goto err_rmdir;
>  
> -	f = debugfs_create_file("finalize", 0600, dir, NULL,
> -				&kho_out_finalize_fops);
> -	if (IS_ERR(f))
> -		goto err_rmdir;
> -
>  	dbg->dir = dir;
>  	dbg->sub_fdt_dir = sub_fdt_dir;
>  	return 0;
> diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
> index 0202c85ad14f..9a832a35254c 100644
> --- a/kernel/liveupdate/kexec_handover_internal.h
> +++ b/kernel/liveupdate/kexec_handover_internal.h
> @@ -22,9 +22,6 @@ struct kho_debugfs {};
>  extern struct kho_scratch *kho_scratch;
>  extern unsigned int kho_scratch_cnt;
>  
> -bool kho_finalized(void);
> -int kho_finalize(void);
> -
>  #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
>  int kho_debugfs_init(void);
>  void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index dda7bb57d421..84ac728d63ba 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -230,17 +230,7 @@ int liveupdate_reboot(void)
>  
>  	luo_flb_serialize();
>  
> -	err = kho_finalize();
> -	if (err) {
> -		pr_err("kho_finalize failed %d\n", err);
> -		/*
> -		 * kho_finalize() may return libfdt errors, to aboid passing to
> -		 * userspace unknown errors, change this to EAGAIN.
> -		 */
> -		err = -EAGAIN;
> -	}
> -
> -	return err;
> +	return 0;
>  }
>  
>  /**
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index 4c437de5c0b0..22f6409875c9 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -630,7 +630,7 @@ int __init luo_flb_setup_incoming(void *fdt_in)
>   * data handle, and the final reference count. This allows the new kernel to
>   * find the appropriate handler and reconstruct the FLB's state.
>   *
> - * Context: Called from liveupdate_reboot() just before kho_finalize().
> + * Context: Called from liveupdate_reboot().
>   */
>  void luo_flb_serialize(void)
>  {
> diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
> index 6d9e91d55d68..88a41b6eba95 100644
> --- a/tools/testing/selftests/kho/init.c
> +++ b/tools/testing/selftests/kho/init.c
> @@ -11,7 +11,6 @@
>  /* from arch/x86/include/asm/setup.h */
>  #define COMMAND_LINE_SIZE	2048
>  
> -#define KHO_FINALIZE "/debugfs/kho/out/finalize"
>  #define KERNEL_IMAGE "/kernel"
>  
>  static int mount_filesystems(void)
> @@ -22,22 +21,6 @@ static int mount_filesystems(void)
>  	return mount("proc", "/proc", "proc", 0, NULL);
>  }
>  
> -static int kho_enable(void)
> -{
> -	const char enable[] = "1";
> -	int fd;
> -
> -	fd = open(KHO_FINALIZE, O_RDWR);
> -	if (fd < 0)
> -		return -1;
> -
> -	if (write(fd, enable, sizeof(enable)) != sizeof(enable))
> -		return 1;
> -
> -	close(fd);
> -	return 0;
> -}
> -
>  static long kexec_file_load(int kernel_fd, int initrd_fd,
>  			    unsigned long cmdline_len, const char *cmdline,
>  			    unsigned long flags)
> @@ -78,9 +61,6 @@ int main(int argc, char *argv[])
>  	if (mount_filesystems())
>  		goto err_reboot;
>  
> -	if (kho_enable())
> -		goto err_reboot;
> -
>  	if (kexec_load())
>  		goto err_reboot;
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

