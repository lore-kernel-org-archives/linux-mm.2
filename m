Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5194C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F9D6B00A2; Wed,  8 Jul 2026 04:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667176B00AC; Wed,  8 Jul 2026 04:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5567B6B00AD; Wed,  8 Jul 2026 04:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17C596B00A2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:07:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DFF190CD8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:07:22 +0000 (UTC)
X-FDA: 84964879524.12.1E18D5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9052C000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:07:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flVw3qAh;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783498040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eey33vCwR2TDg/L/7ImDVaFgtxdBYVYOOW3e0Hzed1c=;
	b=yeYvRF/PLfTK5219fpzKYteu/NM6sPX6QuVtBp6oX81veL94d25n3MdjKXVS3zh2/Jg2i9
	0Svh1Ux4qKGre1bOM/l0vSk8pWtxELpGLrX513b97NwNSShR38EEjYwC++GZmdHFT1C2XQ
	jXj5X1K62TpIA1B2rBlLXxDURzqhpNY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flVw3qAh;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783498040;
	b=nl3NMrBLo6tZaCjaCi3TTz3//2rwl34ywEVf/jhirAl08I4K+7/jRnGWAdm0c9+aByooER
	w4Po+bb6fFhlYJvAWQhKpPl5dBEMq+PDUmX+ipGb/R79f/GY9pJLUcnOp2OLUcAzVSJsmI
	NZXg0MRx9V9bsDXV77Zpg9lg6xln0Lo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A62660008;
	Wed,  8 Jul 2026 08:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B7C1F000E9;
	Wed,  8 Jul 2026 08:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783498039;
	bh=eey33vCwR2TDg/L/7ImDVaFgtxdBYVYOOW3e0Hzed1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=flVw3qAh6hNuSMs/jQ8WX9sgUiBwvxP3Ah3MtOh+v89sSULzfJkDqVDC424Q0Y5jh
	 P3kK3AKqV6dUJvPIGHbGPjmZjI0mR4s0cuOFp63O9iNuB7pNgxb8/NvkAP/qeyXH6l
	 0nmHlEgYdvyDtwSKmbDMsA9JAkFppmUGrLvd5SnrAa2d4aaiXGWhWH+y1RZ16LRQlO
	 mCgx8xerhgXKUC6O6KR1rj3CrfX2UTR0bHeBtFPC9TMI3v6cN64oP3iau+gOLlIg+j
	 VcoPp+Cqei0kj2IbhK3HLvMiczZxO2AaGvEjL094Q9kcLHOeU4Ib0hbRjAk1sR5Kxz
	 wLNu+X43UaeHw==
Date: Wed, 8 Jul 2026 09:06:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, anna-maria@linutronix.de, arnd@arndb.de, 
	andersson@kernel.org, chrisl@kernel.org, cl@gentwo.org, conor+dt@kernel.org, 
	david@kernel.org, dennis@kernel.org, devicetree@vger.kernel.org, 
	ehristev@kernel.org, frederic@kernel.org, mingo@redhat.com, jstultz@google.com, 
	corbet@lwn.net, juri.lelli@redhat.com, kasong@tencent.com, kees@kernel.org, 
	konradybcio@kernel.org, krzk+dt@kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-remoteproc@vger.kernel.org, mathieu.poirier@linaro.org, 
	peterz@infradead.org, pmladek@suse.com, robh@kernel.org, saravanak@kernel.org, 
	tj@kernel.org, tglx@kernel.org, vincent.guittot@linaro.org, 
	workflows@vger.kernel.org, atomlin@atomlin.com, ast@kernel.org, aliceryhl@google.com, 
	linux.amoon@gmail.com, ardb@kernel.org, baoquan.he@linux.dev, baohua@kernel.org, 
	bsegall@google.com, jackmanb@google.com, leitao@debian.org, brauner@kernel.org, 
	coxu@redhat.com, dietmar.eggemann@arm.com, dianders@chromium.org, 
	ebiggers@kernel.org, feng.tang@linux.alibaba.com, yangfeng@kylinos.cn, 
	gary@garyguo.net, guohanjun@huawei.com, jack@suse.cz, wangjinchao600@gmail.com, 
	joel.granados@kernel.org, hannes@cmpxchg.org, john.ogness@linutronix.de, 
	jpoimboe@kernel.org, shikemeng@huaweicloud.com, kas@kernel.org, 
	kprateek.nayak@amd.com, liam@infradead.org, elver@google.com, mgorman@suse.de, 
	mhocko@suse.com, ojeda@kernel.org, rppt@kernel.org, namcao@linutronix.de, 
	nathan@kernel.org, nphamcs@gmail.com, n.schier@fritz.com, pasha.tatashin@soleen.com, 
	petr.pavlu@suse.com, pnina.feder@mobileye.com, rdunlap@infradead.org, 
	rioo.tsukatsukii@gmail.com, senozhatsky@chromium.org, skhan@linuxfoundation.org, 
	sboyd@kernel.org, rostedt@goodmis.org, surenb@google.com, 
	thomas.weissschuh@linutronix.de, vschneid@redhat.com, vbabka@kernel.org, youngjun.park@lge.com, 
	zhengyejian@huaweicloud.com, ziy@nvidia.com, Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH v3 26/26] meminspect: Add debug kinfo compatible driver
Message-ID: <ak4DqBta0boElPak@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708070809.2660886-1-mukesh.ojha@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708070809.2660886-1-mukesh.ojha@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9052C000C
X-Stat-Signature: ojzjshcwky7uk1ufhyr6d3noq55m1we5
X-HE-Tag: 1783498040-676441
X-HE-Meta: U2FsdGVkX18p9vBigYQnDNYGbOHeBvliybhdhdf6ch3c/ozf/wiFprxSMnAnfpPYvD9FEx8fljusI+fxkaramET5fVevaIbuSZd36+hdWF+1Gi03A6vGwMbbGL3bRQgPOm0LuNmymOG0rjGcMPwMOQKXqMTMHK+u72v/CCS7MRAZD1o1BMNZQdhxvZQvEIb0n9BJNVosEUIvjzSQAwQHO9dydiuuKvQRZ1lZF8VbIur31Z2qLed2vFnovZNUSQbbQ+HJ7SQytpGZkzAI6czy8SrU44vJJZNbnHuLvize6aMDdvAXPc5IvfbVtdy5wPy84rccy298oRSCn8YhGmgwZrZBjwefkSOzSon8QH65n+K0bHbY/tgOM3YRRW3R50xwHyHYM5MWVpDS0Zi4w4RnhT1WjPVdEVZ12cv4/OArUjB/olI11+CKvhR6ZBIjfQLmMSwGZ32KfAzKhDfBrG9vSlBImtWxEMhnOsmvZ5wUlrbZN2k7NNOv5V2Dh5nUmPqiqr0iWSTrkkTvh4P7C5a3jZb+H5jpJyxCGdsNs9SOhVE7+Q8zfiCzcZkScPAFTdBCA66+MEM5EvC0lM4ifbvSSG6UCuzQKQoCaaOTzscWWn2yUTXAE+zPhNL59q8gEUJHi5SC00FvOQt9V/jp0YuxaG0Lb4Gtlmyqb5uKJd24ZPJkFJ32G21IAMYZzWNijw030kw/GNXsAb+xKCRsyllNtxfioM9ww2MFbQgz+MTmMrJGLGL3xd62EJwC7YoCMulXaHnOKXfD3Wes+7xPDGCfIyYdQdDV8OPMz2/4tjpyP/5Vn4BcSb2AhKTPY/4pbZv+UiCcW7cMpWHue/2Ib/Yf8tfpOt25adIe0S2Lz5Mvk8ff8MGksQ3TR84UIUJnXLStxTw1RnaLLxgjfFzgn7bvVP5MhrbHvsrrc6A+RJaT+uBSp17rhb+wWLPcN01YVZ7ggXn3Aje/Y6tFiW6q4+b
 fLcF2Nbq
 FWClf3YJS5lLEBiRBRKUC9AJQWic8KKCDPZRBXfI+fLcGgpuW3J8nnCyRF2boQEYIQT3LeD36yB3NL72TpMU60seN/sTqycV6ux+zwFUWqjQgFmVaPKvf5Co0aB6gN+iIGzQqsS9curcVmz7lUkWSPp+ElqqferaejJcfTw/kdM+EbquPIbR+aUv1kDeFJd8Dldo6LJlneMssIb7B75CUx4ejTeKhQ/h1V92P0ccmTc3C9j75Te/pA/VVrO95+D8vBfPfj557sYnvzler9WX1fqWwkMYM7o4m5oEfj/FgKkuvB7k/Tn/7+xFStiYdfIeroeN1xfQh/S39jqbWnnzmDFDxeMa6TNAZnAE1bw7aAO7ob4o8XbhZ5QBBWlQwc8+NKheucVo77Ll+a3nOYBvK32zuLbFj1SAi2W+OapXs467JMiDTRYOHEJ04wP8kUxmFQ6YALd1gntxP1QskJqgN1TFdeJOS7X+oU2iXccrvgh7MG3uHpAD0DaQnaJzUQvUyISstcWOZs1MAWuTYDPm7mgOKfUlDkiAa0565gRy9R9VI44M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:38:09PM +0530, Mukesh Ojha wrote:
> From: Eugen Hristev <eugen.hristev@linaro.org>
>
> With this driver, the registered regions are copied to a shared memory
> zone at register time. The shared memory zone is supplied via OF. This
> driver will select only regions that are of interest, and keep only
> addresses. The format of the list is Kinfo compatible, with devices like
> Google Pixel phone. The firmware is only interested in some symbols'
> addresses.
>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

Hang on, this is a driver that exposes internal kernel symbol information in a
shared memory region for anybody who wants to access it?

This doesn't really seem sane?

Looking through the code it seems you are only exposing things that are already
otherwise exposed, so maybe it's not so bad, but it seems as if a registered
meminfo driver could in any case get access to things they shouldn't?

> ---
>  MAINTAINERS                |   1 +
>  drivers/of/platform.c      |   1 +
>  kernel/meminspect/Kconfig  |  11 ++
>  kernel/meminspect/Makefile |   1 +
>  kernel/meminspect/kinfo.c  | 257 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 271 insertions(+)
>  create mode 100644 kernel/meminspect/kinfo.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2d816d783024..d805ff9fedac 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16906,6 +16906,7 @@ M:	Eugen Hristev <eugen.hristev@linaro.org>
>  M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/reserved-memory/google,debug-kinfo.yaml
> +F:	kernel/meminspect/kinfo.c
>
>  MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
>  M:	Mike Rapoport <rppt@kernel.org>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 53bca8c6f781..f80bd25fc481 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -494,6 +494,7 @@ static const struct of_device_id reserved_mem_matches[] = {
>  	{ .compatible = "qcom,smem" },
>  	{ .compatible = "ramoops" },
>  	{ .compatible = "nvmem-rmem" },
> +	{ .compatible = "google,debug-kinfo" },
>  	{ .compatible = "google,open-dice" },
>  	{}
>  };
> diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
> index 18ff511ad4cf..7f6436c3344b 100644
> --- a/kernel/meminspect/Kconfig
> +++ b/kernel/meminspect/Kconfig
> @@ -16,3 +16,14 @@ config MEMINSPECT
>
>  	  Note that modules using this feature must be rebuilt if this
>  	  option changes.
> +
> +config MEMINSPECT_KINFO
> +	tristate "Shared memory KInfo compatible driver"
> +	depends on MEMINSPECT
> +	help
> +	  Say y here to enable the Shared memory KInfo compatible driver.
> +	  With this driver, the registered regions are copied to a shared
> +	  memory zone at register time.
> +	  The shared memory zone is supplied via OF.
> +	  This driver will select only regions that are of interest,
> +	  and keep only addresses. The format of the list is Kinfo compatible.
> diff --git a/kernel/meminspect/Makefile b/kernel/meminspect/Makefile
> index 09fd55e6d9cf..283604d892e5 100644
> --- a/kernel/meminspect/Makefile
> +++ b/kernel/meminspect/Makefile
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
>
>  obj-$(CONFIG_MEMINSPECT) += meminspect.o
> +obj-$(CONFIG_MEMINSPECT_KINFO) += kinfo.o
> diff --git a/kernel/meminspect/kinfo.c b/kernel/meminspect/kinfo.c
> new file mode 100644
> index 000000000000..7451c13bc316
> --- /dev/null
> +++ b/kernel/meminspect/kinfo.c
> @@ -0,0 +1,257 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *
> + * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
> + * Copyright 2021 Google LLC
> + * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
> + */
> +#include <linux/container_of.h>
> +#include <linux/kallsyms.h>
> +#include <linux/meminspect.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/platform_device.h>
> +#include <linux/utsname.h>
> +
> +#define BUILD_INFO_LEN		256
> +#define DEBUG_KINFO_MAGIC	0xcceeddff
> +
> +/*
> + * Header structure must be byte-packed, since the table is provided to
> + * bootloader.
> + */
> +struct kernel_info {
> +	/* For kallsyms */
> +	u8 enabled_all;
> +	u8 enabled_base_relative;
> +	u8 enabled_absolute_percpu;
> +	u8 enabled_cfi_clang;
> +	u32 num_syms;
> +	u16 name_len;
> +	u16 bit_per_long;
> +	u16 module_name_len;
> +	u16 symbol_len;
> +	u64 _relative_pa;
> +	u64 _text_pa;
> +	u64 _stext_pa;
> +	u64 _etext_pa;
> +	u64 _sinittext_pa;
> +	u64 _einittext_pa;
> +	u64 _end_pa;
> +	u64 _offsets_pa;
> +	u64 _names_pa;
> +	u64 _token_table_pa;
> +	u64 _token_index_pa;
> +	u64 _markers_pa;
> +	u64 _seqs_of_names_pa;
> +
> +	/* For frame pointer */
> +	u32 thread_size;
> +
> +	/* For virt_to_phys */
> +	u64 swapper_pg_dir_pa;
> +
> +	/* For linux banner */
> +	u8 last_uts_release[__NEW_UTS_LEN];
> +
> +	/* For module kallsyms */
> +	u32 enabled_modules_tree_lookup;
> +	u32 mod_mem_offset;
> +	u32 mod_kallsyms_offset;
> +} __packed;
> +
> +struct kernel_all_info {
> +	u32 magic_number;
> +	u32 combined_checksum;
> +	struct kernel_info info;
> +} __packed;
> +
> +struct debug_kinfo {
> +	struct device *dev;
> +	void *all_info_addr;
> +	size_t all_info_size;
> +	struct notifier_block nb;
> +};
> +
> +static void update_kernel_all_info(struct kernel_all_info *all_info)
> +{
> +	struct kernel_info *info;
> +	u32 *checksum_info;
> +	int index;
> +
> +	all_info->magic_number = DEBUG_KINFO_MAGIC;
> +	all_info->combined_checksum = 0;
> +
> +	info = &all_info->info;
> +	checksum_info = (u32 *)info;
> +	for (index = 0; index < sizeof(*info) / sizeof(u32); index++)
> +		all_info->combined_checksum ^= checksum_info[index];
> +}
> +
> +static void __maybe_unused register_kinfo_region(void *priv,
> +						 const struct inspect_entry *e)
> +{
> +	struct debug_kinfo *kinfo = priv;
> +	struct kernel_all_info *all_info = kinfo->all_info_addr;
> +	struct kernel_info *info = &all_info->info;
> +	struct uts_namespace *uts;
> +	u64 paddr;
> +
> +	if (e->pa)
> +		paddr = e->pa;
> +	else
> +		paddr = __pa(e->va);
> +
> +	switch (e->id) {
> +	case MEMINSPECT_ID__sinittext:
> +		info->_sinittext_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID__einittext:
> +		info->_einittext_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID__end:
> +		info->_end_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID__text:
> +		info->_text_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID__stext:
> +		info->_stext_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID__etext:
> +		info->_etext_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_num_syms:
> +		info->num_syms = *(__u32 *)e->va;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_offsets:
> +		info->_offsets_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_names:
> +		info->_names_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_token_table:
> +		info->_token_table_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_token_index:
> +		info->_token_index_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_markers:
> +		info->_markers_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_kallsyms_seqs_of_names:
> +		info->_seqs_of_names_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_swapper_pg_dir:
> +		info->swapper_pg_dir_pa = paddr;
> +		break;
> +	case MEMINSPECT_ID_init_uts_ns:
> +		if (!e->va)
> +			return;
> +		uts = e->va;
> +		strscpy(info->last_uts_release, uts->name.release, __NEW_UTS_LEN);
> +		break;
> +	default:
> +		break;
> +	};
> +
> +	update_kernel_all_info(all_info);
> +}
> +
> +static int kinfo_notifier_cb(struct notifier_block *nb,
> +			     unsigned long code, void *entry)
> +{
> +	struct debug_kinfo *kinfo = container_of(nb, struct debug_kinfo, nb);
> +
> +	if (code == MEMINSPECT_NOTIFIER_ADD)
> +		register_kinfo_region(kinfo, entry);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int debug_kinfo_probe(struct platform_device *pdev)
> +{
> +	struct kernel_all_info *all_info;
> +	struct device *dev = &pdev->dev;
> +	struct reserved_mem *rmem;
> +	struct debug_kinfo *kinfo;
> +	struct kernel_info *info;
> +
> +	rmem = of_reserved_mem_lookup(dev->of_node);
> +	if (!rmem)
> +		return dev_err_probe(dev, -ENODEV, "no such reserved mem of node name %s\n",
> +			      dev->of_node->name);
> +
> +	/* Need to wait for reserved memory to be mapped */
> +	if (!rmem->priv)
> +		return -EPROBE_DEFER;
> +
> +	if (!rmem->base || !rmem->size)
> +		dev_err_probe(dev, -EINVAL, "unexpected reserved memory\n");
> +
> +	if (rmem->size < sizeof(struct kernel_all_info))
> +		dev_err_probe(dev, -EINVAL, "reserved memory size too small\n");
> +
> +	kinfo = devm_kzalloc(dev, sizeof(*kinfo), GFP_KERNEL);
> +	if (!kinfo)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, kinfo);
> +
> +	kinfo->dev = dev;
> +	kinfo->all_info_addr = rmem->priv;
> +	kinfo->all_info_size = rmem->size;
> +
> +	all_info = kinfo->all_info_addr;
> +
> +	memset(all_info, 0, sizeof(struct kernel_all_info));
> +	info = &all_info->info;
> +	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
> +	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
> +	info->enabled_base_relative = IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE);
> +	info->enabled_cfi_clang = IS_ENABLED(CONFIG_CFI_CLANG);
> +	info->name_len = KSYM_NAME_LEN;
> +	info->bit_per_long = BITS_PER_LONG;
> +	info->module_name_len = MODULE_NAME_LEN;
> +	info->symbol_len = KSYM_SYMBOL_LEN;
> +	info->thread_size = THREAD_SIZE;
> +	info->enabled_modules_tree_lookup = IS_ENABLED(CONFIG_MODULES_TREE_LOOKUP);
> +	info->mod_mem_offset = offsetof(struct module, mem);
> +	info->mod_kallsyms_offset = offsetof(struct module, kallsyms);
> +
> +	kinfo->nb.notifier_call = kinfo_notifier_cb;
> +
> +	meminspect_notifier_register(&kinfo->nb);
> +	meminspect_lock_traverse(kinfo, register_kinfo_region);
> +
> +	return 0;
> +}
> +
> +static void debug_kinfo_remove(struct platform_device *pdev)
> +{
> +	struct debug_kinfo *kinfo = platform_get_drvdata(pdev);
> +
> +	meminspect_notifier_unregister(&kinfo->nb);
> +}
> +
> +static const struct of_device_id debug_kinfo_of_match[] = {
> +	{ .compatible	= "google,debug-kinfo" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, debug_kinfo_of_match);
> +
> +static struct platform_driver debug_kinfo_driver = {
> +	.probe = debug_kinfo_probe,
> +	.remove = debug_kinfo_remove,
> +	.driver = {
> +		.name = "debug-kinfo",
> +		.of_match_table = debug_kinfo_of_match,
> +	},
> +};
> +module_platform_driver(debug_kinfo_driver);
> +
> +MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
> +MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
> +MODULE_DESCRIPTION("meminspect Kinfo Driver");
> +MODULE_LICENSE("GPL");
> --
> 2.53.0
>

