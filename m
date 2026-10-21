Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594F9606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=qy05oNmy
Received: by kanga.kvack.org (Postfix)
	id 7AFAF6B0689; Wed, 21 Oct 2026 05:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760896B068A; Wed, 21 Oct 2026 05:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6774E6B068B; Wed, 21 Oct 2026 05:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCA96B0689
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:13:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9CA4404E7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:13:17 +0000 (UTC)
X-FDA: 85346069634.18.5432B27
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FACD100007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:13:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qy05oNmy;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792573995;
	b=V0zmHhd0UzItVXMfpvvZNkwObYQG059tWHPRYrqTJj3rf9fQnLNvF1wdZkgIueprk43KSK
	DhlB0TvhfuvztCNzidrg5gVmppNfS7pd1GDqdxcLLHK0mK1T0bYkAQbssscW+k6LgO8GeY
	2zo0cCXxdUr2UIqIZOts3bZaEYUoMKw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qy05oNmy;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792573995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzADmYKv4GpvdMxYyHHtqrTYHk3osWUIWqWnEfBwJ1o=;
	b=XAmgqg7jGuCLewFN7fud4ncBLK1WYLz+8033QwsRyg0Re1Uc6ckeY6K+WYSfhRqeqALtK0
	Xsky3/k9al8ey7ggU7uMhk99MufzD/aFlooSwbfI47kcjs4KvOQx5KmB96Zu5FT21eqldB
	VUKDaTyLWzZm0EfqlVVuMgLiU/0zQ9o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nzADmYKv4GpvdMxYyHHtqrTYHk3osWUIWqWnEfBwJ1o=;
	b=qy05oNmy3wvcAipAQKL4DCStOriRWTyczBtLbfPzPytLSmCWdRpIYENADIsJu88KlAJj0hmjc
	e1p5428X8KTeWUYB9Vrw2GOPKCj13drNhfpLlgpoC2Z/ybSXrCDzqgJdySA25ihc7Us9rMXLO2x
	ua/h/PISSyjS5+zO8Dkln2g=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j8jvf2rLvz1cySH;
	Wed, 21 Oct 2026 17:01:50 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B4A840563;
	Wed, 21 Oct 2026 17:13:10 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 21 Oct
 2026 17:13:08 +0800
Message-ID: <12e4e687-1ff0-41b2-bdf8-7f48b29e1f2f@huawei.com>
Date: Wed, 21 Oct 2026 17:13:07 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/8] crash_core: serialize crash header preparation
 against hotplug
To: Wandun Chen <chenwandun1@gmail.com>, <robh@kernel.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <m.szyprowski@samsung.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<pasha.tatashin@soleen.com>, <pratyush@kernel.org>, <ruirui.yang@linux.dev>,
	<robin.murphy@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-riscv@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>, <iommu@lists.linux.dev>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-4-chenwandun1@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261021083011.2170525-4-chenwandun1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: ga6q6y4cqobkezpzejm4seqxnfkmenhf
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1FACD100007
X-Rspam-User: 
X-HE-Tag: 1792573994-891661
X-HE-Meta: U2FsdGVkX1+ytSYF4+NWqB4rFMQtfG38EGOxyD4gqvQ4J6EY+bE2J/knnpRdMGjX+2zpZqAdAWUd6HLz1ZTfVqpOuxFk7EpLUI1c+bT6yoLB2HYr153k+SzvXMP3QHVXSgoVi1ug2zL9Nuxbifz+tAFiOc9uZS0DPJpkHmW3yGBeIwMQihda0z9cOowWEr+r/y8BcZF8U7p4eig7boapXZ9k1m9LCnG/7UVnkD1bpHxZjXS6A8mDxjh0NS6QeUj7yZtCd6Y/N3FJR830GeEYRLVbbaBJ2mUDDgaP5s+pz+q5CmBX1QQ1Qtj2mrOVoBFTcE9aYzI2vv9SJsOGMUMT5oHWbd79lAJIbKIn4WvpNtU0aA8g38gdOPD6OXKEdIWMNxLnrqm5gEbPx+BOqJJZqJDTUCqbgmD+i+4FwJjUB8AR57GSVkSXSL/iUn74Wsl9A1Zkq6vmKp02721wdqbF+Uk4FTdNwRUQWv1/jYQQB6Q7v7EMkweOyI2t2+dacQL33/khZiz8HRrJqHeCoK6qmLKNc/ZGQC+YkQCA9nLjoKG84qRgyLHeKnzgVmD9UomlLjK7EYdFued1Kno0+TGMF9iQtg26Jm1xsn79FinCOM1O1RaoACsGKleMptdzhMBhaI4fdIGYs4MUaBaB14EkMa2rAN/rRZoZo0rn9mKIVhP2Fm8Z13mobGosWA09s4PR8WzhjhuvHJBZPAkorGIR1NZ1VBolxATOTirGPBUThi6fuN62jbBDFVvUA7D46S9CXGuPxpcX6wjqSqPBNpFeBu54IouRjohsiKnUwB/qVcpYb2HLtK0NzPPDyct9Sus5OXScBlWBt536+iV2dAPM8rnYdk5WPT2iMCgNqKBf0Rsm5hHn0X6HhJ+N5dbN7DI6g6I9mfdNAfhFhw+3HNojDjDMg7Lui64eBV3AOiueY0U49WYHhtt+M5yaTn0HyDT+DmdyL4hpIh8u6Z1Hz10
 v10+n71f
 wxOFHcGZvnn0LCz4Li6wfDhYsV8wQI7B+qADJtL9oIX36NGIGFlZ77IjXyAtMvXXGlNPkylNLkUovEnuUEG6T6yoONaEkl52i6QlKMc00Kzw+hdtL7zelp60+vxsO2iiNr4tIFwblymNGIolXyJk6L6ifm4Yvmfwl1cIDcB+rBDgRdCMxPkRYdv3qBXguS+cv2X6wgb55t4L/2axEJzxsfjWI0MVO4Xm1V4WUI4XDKFNTmzv1yPu1o16vCrQLggb1cvNj93MfUOG8z/qhZKxf38mFQH8ES0Nfjr1s/+09N5sGLC00+PNrIWbq4XDP33Alp7Mwq469jJv9D8O6IpKqXf8iy+WY6M0N2UorDd4VsvaM8qDfD+PKxxHjoBSHIv0X4cWWpB+WOYTkbXVjXPC4eQ6OYbnQJJexjcvlatia+qGLm1n1wyEzCuLvrpIFnFWCmpP+53atDgKAbRkLLW18+Q+z20o8Np+b9oznfPKUgxQz+psuaYw/Prp/DWGs4EcLVmpdwFtrrw1JKPCR8iUDUQypie02GUZBa8iz+wWcD3tt254=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/21 16:30, Wandun Chen 写道:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> crash_prepare_headers() counts memory ranges before populating the
> allocated crash_mem array. The weak implementation used by ARM64,
> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
> two-pass operation over system RAM resources. Concurrent memory hotplug
> can change range source between the two walks and make the populate
> pass overflow cmem->ranges.
> 
> Take device_hotplug_lock when preparing crash headers during
> kexec_file_load(). The x86/riscv memory hotplug path already takes
> device_hotplug_lock, so call __crash_prepare_headers() directly
> to avoid recursive locking.
> 
> Sashiko reported this issue in [1].
> 
> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  arch/riscv/kernel/crash.c  |  2 +-
>  arch/x86/kernel/crash.c    |  2 +-
>  include/linux/crash_core.h |  2 ++
>  kernel/crash_core.c        | 17 +++++++++++++++--
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
> index fe5a4b306aae..ac8df2edf2a7 100644
> --- a/arch/riscv/kernel/crash.c
> +++ b/arch/riscv/kernel/crash.c
> @@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>  	 * memory resources.
>  	 */
> -	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
> +	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
>  		pr_err("unable to create new elfcorehdr");
>  		goto out;
>  	}
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index e6f23933a6df..bef008a0cb22 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>  	 * Create the new elfcorehdr reflecting the changes to CPU and/or
>  	 * memory resources.
>  	 */
> -	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
> +	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
>  		pr_err("unable to create new elfcorehdr");
>  		goto out;
>  	}
> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
> index bc087124cd78..28e7a81cf263 100644
> --- a/include/linux/crash_core.h
> +++ b/include/linux/crash_core.h
> @@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
>  				       void **addr, unsigned long *sz);
>  extern int crash_prepare_headers(int need_kernel_map, void **addr,
>  				 unsigned long *sz, unsigned long *nr_mem_ranges);
> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			    unsigned long *nr_mem_ranges);
>  extern int crash_exclude_core_ranges(struct crash_mem **cmem);
>  
>  struct kimage;
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index faa0f22dbb41..8a861a946e26 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -16,6 +16,7 @@
>  #include <linux/mm.h>
>  #include <linux/cpuhotplug.h>
>  #include <linux/memblock.h>
> +#include <linux/device.h>
>  #include <linux/kmemleak.h>
>  #include <linux/crash_core.h>
>  #include <linux/reboot.h>
> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>  	return 0;
>  }
>  
> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> -			  unsigned long *nr_mem_ranges)
> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			    unsigned long *nr_mem_ranges)
>  {
>  	unsigned int max_nr_ranges;
>  	struct crash_mem *cmem;
> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
>  	return ret;
>  }
>  
> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
> +			  unsigned long *nr_mem_ranges)
> +{
> +	int ret;
> +
> +	lock_device_hotplug();
> +	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
> +	unlock_device_hotplug();

I think this patch conflicts with my changes and would also conflict
with the implementation of arm64 crash hotplug.

https://lore.kernel.org/all/20260921090450.807575-15-ruanjinjie@huawei.com/

arm64 crash hotplug:
https://lore.kernel.org/all/20260918100442.3841135-18-ruanjinjie@huawei.com/

> +
> +	return ret;
> +}
> +
>  /**
>   * crash_exclude_mem_range - exclude a mem range for existing ranges
>   * @mem: mem->range contains an array of ranges sorted in ascending order

-- 
Best regards,
Jinjie


