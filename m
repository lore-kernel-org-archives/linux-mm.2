Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B42BFD88DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1256B0005; Wed, 11 Mar 2026 05:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982646B0089; Wed, 11 Mar 2026 05:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859D96B008A; Wed, 11 Mar 2026 05:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7E46B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:09:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F06DF13B7D1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:09:24 +0000 (UTC)
X-FDA: 84533208648.08.91802AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46BB420008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:09:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hiav0/5S";
	spf=pass (imf03.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773220163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VuTdylyjgcE4ZoIj19R0wwxjD2D00fSIOSrvgvBWuo=;
	b=3rTd7Qdxg72mahTQze16mx03h4pB4uIf7bxreAbnjmQCm0bJS3Xy6j3m4RJk5iXuPBWfIq
	Gl2a8BCiNuMV7xrSe2M9CO1WSUJuQlMPoyC7nrRK0uC9Dcabo9G0tq3s8XL6bDUgWBssbR
	UNy7MrnDm7g7iha0AFmmPigandskWNM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hiav0/5S";
	spf=pass (imf03.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773220163; a=rsa-sha256;
	cv=none;
	b=qxKGbXWNlhKzcd4O3qlZ/QYTmFcCM/kJfntezBf414Hq11/6xpUe9A+KK54XiwolpvYVhu
	LP2sjYVMySb19NaPOMNHh+Ap/Du7w1aSeic4xJvJVhfszEUP6ejFAtmBehFnNHtiD7uKNc
	7SiMaLiLNoSGah9UU7gQjpEUNibbHcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 472FC4190B;
	Wed, 11 Mar 2026 09:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97481C4CEF7;
	Wed, 11 Mar 2026 09:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773220162;
	bh=82aUC4VRpBGw7JMuttBYhm6dWXOcxLKrXkiWiKokSkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hiav0/5SDxMf9zR8suSIZHhKHiHBJdBn25HKmiP6Nvb/vZamKVkRaC+bkUU+MMoo3
	 Ni0yaCeLrupAUaWRFNEnAuXIqphbhDlWgHLpNADqlynBDF7c35TM9zxQLOe8P0jKnC
	 d1QXefq7ueIltcKqNd6w6N5kWro0EIIaImFy76V51md/QPFfq9cNwZLAKiY4+Iu9zH
	 OAoeKfTgXg0iSyPWwQKKoQ/v1L08Sm6Dj3xv/KywOB97OeG83b4hfoG2GwyCSdg1IB
	 zu45S0H/TgnahEqJdikaJQTJWaM9V9+zgqHuKySEF2INd3fBkw7cRzVCzwi155hFHW
	 TDLU+bfophjrQ==
Date: Wed, 11 Mar 2026 10:09:19 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <eugen.hristev@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 25/25] meminspect: Add debug kinfo compatible driver
Message-ID: <20260311-poetic-transparent-barracuda-b7a3ab@quoll>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-25-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-25-f91cedc6f99e@oss.qualcomm.com>
X-Rspamd-Queue-Id: 46BB420008
X-Rspamd-Server: rspam07
X-Stat-Signature: g8pna6ussf74ht6ybiogrgzysxopcnwo
X-Rspam-User: 
X-HE-Tag: 1773220163-54772
X-HE-Meta: U2FsdGVkX1+IXLofiL3b0vhkMIcriwcEcIaqdMiEat77W87oNj473Zuw1kbg7rOPRSrC2J3ov+poRK5n97df/f9zoikmLt/B3YyvuX40wE7VB/A3fN5scHmzsOytCnmPJJurghM1eEiODcPuousl8628YbOXFYfGKJix5ynoz/6Ao7D0gOjc1dFOmZ8/wcmWrx+2PXNsYhaZZJd+jC5+PgcZJo5jFP6Eff12Ls+3f1NztQnPVtP7mQH3GGjMdYSCte4e9Gjt9qh9SxjeeyYnoxsz1z5/k/zrZObU2/kKfTyYyIkKkpi5BBpaWDyUJYhXx26ammQsmWI1nxNXor6OHFWkAlyuLLliz3mRM8BCDT8i4Dk5YqoMsTkV+DCLo0kGBLDxHFrEIwoanLLFLbXXg5fX6NSHJxWlBJ7xSle4PvjBr9Ch+57ikTFcxFOj8dBbqehM1pytF2c8gZXZtXw/jpiqt60zVNwCeRh8OhRDKmWyLlKzLCPLf3NO2PnUfrY04ZZbXFMeWIy3ARAogGfo/wfhrknf9HitngMHutKHjgeJvGo/H8k0FFzB/1XLiJCTm7oWB6JNVc5zhLnPC/gqC7tdVzLKZCt/xhpRlR26pM1v3E7fWd4QuH4vRp1yzo4xv6HoGD1mqRnMQl+4f0JgGCPebWCWMjATzVgzLtOZw8XkMnerNVqK4jlJwd3R+0a0wYaFfHLmn1Fgy4fnO0VPteXBlaSJQ/ZGvjg79h64wlJTymFgEZ9OCuAj4TeTvCxYNw2M4xzS7GGEUF1JKiH75IwSsf5evcX+h+u7veWg+gBw8jTFgwMvmLE7G3kncoZ6yjklvJtiC/8LEE2bdvOsgTsw4nlMLZFnBeP3FETwyQHN98yBmvbvqJTqclZW9jaI2ToSTl28OpBIMipRYo/0nAsju/5UUFb2ZMtbu90Q1zUg+VH3boVcT+GVDSwPBGznMfj2VRZGzH3ilIE4tfH
 0hLCpGEj
 9ZB51yg2ZeSlXde5SddUgNWNy3cnIkKHfM9Hr0fmfCY2vGK5Rssled5HMFqn9sWZm/P+InBWHHfnHyWbg6vjuerp85RXjD4Zo8zXB3N5Kikk/12dB/QkE95uXwCQ80BltxFnGzaUCrVlkpFsMZdJXS2GZ55txoV2pE7dmR3mGK59yDweZLrtbaSZ60NnUyWDyJSx5lM9UyBMPpd+eJHTHcsUCCRntV+0s9mtSkzmUmqLwo6om2mpf9mfaRrEoBlNxv7+BnnwrkNsQPKHO0ph2bhysyjZHjb8QGRF5QthwHvPx1P1IR0lOdW8DLtF/a2XMohXW9E7XWv8mwGURXL9oYKjTgx9XehmcdDA76AMagiZi0AXkdbyHgMNOxSTs1NO+ujwgswn0rlY0Qo5OwmQdKa8kgrwQRHGSDMz3uNpU8lQpmLqgH7NWEyuKzyB3VG2r2/Q7+gB6BodnY8by4GmxzvXYS4Ne860ZLjuICzJPdpfFuixtUMK+mcpQ6HNv+XiLk3oX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:46:09AM +0530, Mukesh Ojha wrote:
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
> ---
>  MAINTAINERS                |   1 +
>  drivers/of/platform.c      |   1 +
>  kernel/meminspect/Kconfig  |  11 ++
>  kernel/meminspect/Makefile |   1 +
>  kernel/meminspect/kinfo.c  | 284 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 298 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2504b7df0e7d..48b5457fae98 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16597,6 +16597,7 @@ M:	Eugen Hristev <eugen.hristev@linaro.org>
>  M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> +F:	kernel/meminspect/kinfo.c
>  
>  MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
>  M:	Mike Rapoport <rppt@kernel.org>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 2a7111e8354d..09047e021de4 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -495,6 +495,7 @@ static const struct of_device_id reserved_mem_matches[] = {
>  	{ .compatible = "ramoops" },
>  	{ .compatible = "nvmem-rmem" },
>  	{ .compatible = "google,open-dice" },
> +	{ .compatible = "google,debug-kinfo" },

place it before open-dice

>  	{}
>  };
>  
> diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
> index fa2b5a84b251..396510908e47 100644
> --- a/kernel/meminspect/Kconfig
> +++ b/kernel/meminspect/Kconfig
> @@ -17,3 +17,14 @@ config MEMINSPECT
>  
>  	  Note that modules using this feature must be rebuilt if option
>  	  changes.
> +
> +config MEMINSPECT_KINFO
> +	tristate "Shared memory KInfo compatible driver"
> +	depends on MEMINSPECT
> +	help
> +	  Say y here to enable the Shared memory KInfo compatible driver
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
> index 000000000000..79918908968d
> --- /dev/null
> +++ b/kernel/meminspect/kinfo.c
> @@ -0,0 +1,284 @@
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
> +	/* Info of running build */
> +	u8 build_info[BUILD_INFO_LEN];
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
> +static u8 global_build_info[BUILD_INFO_LEN];

Don't create singletons. That's a driver so you can have multiple
instances of it.

> +
> +static int build_info_set(const char *str, const struct kernel_param *kp)
> +{
> +	size_t build_info_size = sizeof(global_build_info);
> +
> +	if (strlen(str) > build_info_size)
> +		return -ENOMEM;
> +	memcpy(global_build_info, str, min(build_info_size - 1, strlen(str)));
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops build_info_op = {
> +	.set = build_info_set,
> +};
> +
> +module_param_cb(build_info, &build_info_op, NULL, 0200);
> +MODULE_PARM_DESC(build_info, "Write build info to field 'build_info' of debug kinfo.");

Drop. Build info is a static, fixed information, there is no need to write it
from user-space.


...

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
> +	memcpy(info->build_info, global_build_info, strlen(global_build_info));
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
> +		.of_match_table = of_match_ptr(debug_kinfo_of_match),

Drop of_match_ptr, you have warning here.

> +	},
> +};
> +module_platform_driver(debug_kinfo_driver);
> +
> +MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
> +MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
> +MODULE_DESCRIPTION("meminspect Kinfo Driver");
> +MODULE_LICENSE("GPL");
> 
> -- 
> 2.50.1
> 

