Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60188CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 06:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F318E0006; Fri,  7 Nov 2025 01:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDCC8E0002; Fri,  7 Nov 2025 01:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896698E0006; Fri,  7 Nov 2025 01:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72DC78E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:03:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E244B86F5
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:03:30 +0000 (UTC)
X-FDA: 84082768980.05.7AD561D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F7C880010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:03:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Wz3D6ld/";
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762495408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHL5iT1QdkZOzR5lFRbLTS/tU92PAfOx/ehPtEH9Kkk=;
	b=dtDQSwJnGN3+VjEyfjWPMQL96ke/RnL92UmEXwKalRAV6rsWNmtbgxva7cZXLicjqJVtaE
	WTj/2S+2Hl4FCjaeMblSFcBy4LDm8hnWnuBxP+JSLri1kdiDiXCNImmr2JpqKSeLq3APll
	ejephpPCRyLizG6DfJjb9GVABhW4otw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762495408; a=rsa-sha256;
	cv=none;
	b=lbNAIW6ekVE6A9isyShKaU5ATNE6DRzMHq/pHeIdanrkMDe2R129tl4nufO9lsTt878OS9
	RkE5A02bxrrHiZRvmDSyXK/XHL3/ZUkSGg34Rpbld2PwTBVeSPVAMm58sc0X8Ir4aXerPV
	7FlqBCIk/l+xovYL0mdFItxNI+AtYnk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Wz3D6ld/";
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762495405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHL5iT1QdkZOzR5lFRbLTS/tU92PAfOx/ehPtEH9Kkk=;
	b=Wz3D6ld/bB6o92QrcJBp6+XGoLyljDnWjcN2UZVMa43LSbDWO46L7Zzb0uFyvwhXcqri0N
	uamfmCgWuWGD9KUWg8FCHWJsZOV2jrox33AYcwhg8r4n1A7tC2BOxN9IPEYqVc8m8E5DEy
	oVx0kqlXDtrwqEGOJT7clkZxTS02eKM=
Date: Thu, 6 Nov 2025 22:03:20 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20251101142325.1326536-2-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8ou5byzxo8i44571dbr86bpy1tzhwp8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F7C880010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762495407-593091
X-HE-Meta: U2FsdGVkX18ERy/m0Kb+pXA2BM5+6TKYRD6kxsuLkSnpeJ/8Iuikgf1MT07zLoQG8R+wSV79TYUCWSbXkQ+pF3eYLhkfy5YbC7X69/xnKMt4Xn16e5ivbyYviZjxN+l6cVTVuBFE6rm+309lDOEzuwTwbgRLnGUqnSpf/PZfFughdGA4MZbZs2C4L9MxT/Z3O0HyMrWNT2PyMuh+blr+qqV3zIWsT1CqIkB1/h8ce8UuSdRRef9Wa/K2vdUaQ1FrzE0pB40dlEVFaxU4ryedn0tB5/LEi/oez7p5BKebRaC6kXRKb5RsdAl40poN0EZVPbSvF2thdjdVy3mVbp74FIXfFd630/EYsN18GbFfrkASwT0zVr35hUevvU0dGUVhrE7d+UXB58HY40pqr47Lag49jS0K98b8Nm8ZbkIxJ9lHwGyof4NvrqeRgbSkl5YoqZpjl5f1vHTVK6VU+vMo7WhmFFTzWE9xgCLXEboiWdqEJje4vRyxzeblhucyicgmXzYk/tv1DXxcpRlUdgBV8gZsD0R1OGmamBXR/AFdYiHZdU88LylCWqagmNhrIz59TzWRPtmWtUA7K0F6+JfsOhLADv+tJ6bQOjmxNrerNCZ0RFTh7j2ZlNlNgFW55SY9oM2PM9eT3FmLpUQ6AyIFTIdt5sTVQjvWnSroy9X1mnmny7bDtqRnV853KpBqui5RyLWEQ505YpJ4SUZ74AeskkwEAIKmCSYt49QNLnZaQlLg9SsPch+8U2QvVBgPBYpGSaTHvd6TriBVaio7inPXHHEaHMbNAU0ukjXez4Qr/kELSHS0KJAra2j1IHn79yELxaoPgnXGBMYUAoYoZA4oryzZkX4re6c07Bxy5OiVtOfH5rMSJck7zOqGcHrsba2KpWakCH3tD3BPfE9PhBT9TaBij0UJN1n28bI66W52Zc7VjST2CaZ54IyopjVZKoqBZHFvDCuMSRlxJ8SXiH+
 ODqCDnMx
 gcUxY75RBM0bN+eOda3OmUjF0VxD/Eo8tw1L9tTFxUX6v8ncMeCsBAVXd+mkJZPrG5BIFre2olfIFuIpWkTVV3HU0WdrUQWnheTVWbDGoBkB+38ul75hcynR04Tkm63J2d6fx4FYTsC/hwX+3HD7lKX99kBDtl52rFs0sM1ttsCgPU3h08nGU7amsobsTZXjQmtHSZucVYVtmPfgP0CkkNQ3hU0EL4E7kZ2QjM2ScnG15LEsNX9nlNocM9Xd7FFmb6m1qZeu7I5mgOuK+WFjmzbX+ouW184vVBINiwWL5KL8e9XRAwEOcsL6MYojpNAjPduMkWLnUtiOa2Z6Tbaz2gnQUi83yjfV51m5HLwAogCb88uxf9PoEmOemwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2025/11/1 7:23, Pasha Tatashin 写道:
> Currently, KHO is controlled via debugfs interface, but once LUO is
> introduced, it can control KHO, and the debug interface becomes
> optional.
> 
> Add a separate config CONFIG_KEXEC_HANDOVER_DEBUGFS that enables
> the debugfs interface, and allows to inspect the tree.
> 
> Move all debugfs related code to a new file to keep the .c files
> clear of ifdefs.
> 
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>   MAINTAINERS                           |   2 +-
>   kernel/Kconfig.kexec                  |  12 +-
>   kernel/Makefile                       |   1 +
>   kernel/kexec_handover.c               | 273 +++++---------------------
>   kernel/kexec_handover_debugfs.c       | 216 ++++++++++++++++++++
>   kernel/kexec_handover_internal.h      |  39 ++++
>   tools/testing/selftests/kho/vmtest.sh |   1 +
>   7 files changed, 320 insertions(+), 224 deletions(-)
>   create mode 100644 kernel/kexec_handover_debugfs.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2628431dcdfe..bdd0a1260421 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13795,7 +13795,7 @@ S:	Maintained
>   F:	Documentation/admin-guide/mm/kho.rst
>   F:	Documentation/core-api/kho/*
>   F:	include/linux/kexec_handover.h
> -F:	kernel/kexec_handover.c
> +F:	kernel/kexec_handover*
>   F:	tools/testing/selftests/kho/
>   
>   KEYS-ENCRYPTED
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 54e581072617..cc6743137946 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -100,7 +100,6 @@ config KEXEC_HANDOVER
>   	depends on !DEFERRED_STRUCT_PAGE_INIT
>   	select MEMBLOCK_KHO_SCRATCH
>   	select KEXEC_FILE
> -	select DEBUG_FS
>   	select LIBFDT
>   	select CMA
>   	help
> @@ -118,6 +117,17 @@ config KEXEC_HANDOVER_DEBUG
>   	  scenarios and the extra code might be adding overhead it is
>   	  only optionally enabled.
>   
> +config KEXEC_HANDOVER_DEBUGFS
> +	bool "kexec handover debugfs interface"
> +	default KEXEC_HANDOVER
> +	depends on KEXEC_HANDOVER
> +	select DEBUG_FS
> +	help
> +	  Allow to control kexec handover device tree via debugfs
> +	  interface, i.e. finalize the state or aborting the finalization.
> +	  Also, enables inspecting the KHO fdt trees with the debugfs binary
> +	  blobs.

Hi, Pasha

In our previous discussion, we talked about counting the number of times 
the kernel is rebooted via kexec. At that time, you suggested adding a 
variable in debugfs to keep track of this count.
However, since debugfs is now optional, where would be an appropriate 
place to store this variable?

BR,
Yanjun.Zhu

> +
>   config CRASH_DUMP
>   	bool "kernel crash dumps"
>   	default ARCH_DEFAULT_CRASH_DUMP
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 9fe722305c9b..2cf7909a74e5 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -84,6 +84,7 @@ obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
>   obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
>   obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
>   obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
> +obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
>   obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
>   obj-$(CONFIG_COMPAT) += compat.o
>   obj-$(CONFIG_CGROUPS) += cgroup/
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index de4466b47455..da071277d85e 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -11,7 +11,6 @@
>   #include <linux/cleanup.h>
>   #include <linux/cma.h>
>   #include <linux/count_zeros.h>
> -#include <linux/debugfs.h>
>   #include <linux/kexec.h>
>   #include <linux/kexec_handover.h>
>   #include <linux/libfdt.h>
> @@ -30,6 +29,7 @@
>    */
>   #include "../mm/internal.h"
>   #include "kexec_internal.h"
> +#include "kexec_handover_internal.h"
>   
>   #define KHO_FDT_COMPATIBLE "kho-v1"
>   #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
> @@ -105,8 +105,6 @@ struct khoser_mem_chunk;
>   
>   struct kho_serialization {
>   	struct page *fdt;
> -	struct list_head fdt_list;
> -	struct dentry *sub_fdt_dir;
>   	struct kho_mem_track track;
>   	/* First chunk of serialized preserved memory map */
>   	struct khoser_mem_chunk *preserved_mem_map;
> @@ -114,20 +112,16 @@ struct kho_serialization {
>   
>   struct kho_out {
>   	struct blocking_notifier_head chain_head;
> -
> -	struct dentry *dir;
> -
>   	struct mutex lock; /* protects KHO FDT finalization */
> -
>   	struct kho_serialization ser;
>   	bool finalized;
> +	struct kho_debugfs dbg;
>   };
>   
>   static struct kho_out kho_out = {
>   	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
>   	.lock = __MUTEX_INITIALIZER(kho_out.lock),
>   	.ser = {
> -		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
>   		.track = {
>   			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
>   		},
> @@ -477,8 +471,8 @@ static void __init kho_mem_deserialize(const void *fdt)
>    * area for early allocations that happen before page allocator is
>    * initialized.
>    */
> -static struct kho_scratch *kho_scratch;
> -static unsigned int kho_scratch_cnt;
> +struct kho_scratch *kho_scratch;
> +unsigned int kho_scratch_cnt;
>   
>   /*
>    * The scratch areas are scaled by default as percent of memory allocated from
> @@ -674,37 +668,6 @@ static void __init kho_reserve_scratch(void)
>   	kho_enable = false;
>   }
>   
> -struct fdt_debugfs {
> -	struct list_head list;
> -	struct debugfs_blob_wrapper wrapper;
> -	struct dentry *file;
> -};
> -
> -static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
> -			       const char *name, const void *fdt)
> -{
> -	struct fdt_debugfs *f;
> -	struct dentry *file;
> -
> -	f = kmalloc(sizeof(*f), GFP_KERNEL);
> -	if (!f)
> -		return -ENOMEM;
> -
> -	f->wrapper.data = (void *)fdt;
> -	f->wrapper.size = fdt_totalsize(fdt);
> -
> -	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
> -	if (IS_ERR(file)) {
> -		kfree(f);
> -		return PTR_ERR(file);
> -	}
> -
> -	f->file = file;
> -	list_add(&f->list, list);
> -
> -	return 0;
> -}
> -
>   /**
>    * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
>    * @ser: serialization control object passed by KHO notifiers.
> @@ -716,7 +679,8 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
>    * by KHO for the new kernel to retrieve it after kexec.
>    *
>    * A debugfs blob entry is also created at
> - * ``/sys/kernel/debug/kho/out/sub_fdts/@name``.
> + * ``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with
> + * CONFIG_KEXEC_HANDOVER_DEBUGFS
>    *
>    * Return: 0 on success, error code on failure
>    */
> @@ -733,7 +697,7 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
>   	if (err)
>   		return err;
>   
> -	return kho_debugfs_fdt_add(&ser->fdt_list, ser->sub_fdt_dir, name, fdt);
> +	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>   }
>   EXPORT_SYMBOL_GPL(kho_add_subtree);
>   
> @@ -1064,30 +1028,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>   }
>   EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
>   
> -/* Handling for debug/kho/out */
> -
> -static struct dentry *debugfs_root;
> -
> -static int kho_out_update_debugfs_fdt(void)
> -{
> -	int err = 0;
> -	struct fdt_debugfs *ff, *tmp;
> -
> -	if (kho_out.finalized) {
> -		err = kho_debugfs_fdt_add(&kho_out.ser.fdt_list, kho_out.dir,
> -					  "fdt", page_to_virt(kho_out.ser.fdt));
> -	} else {
> -		list_for_each_entry_safe(ff, tmp, &kho_out.ser.fdt_list, list) {
> -			debugfs_remove(ff->file);
> -			list_del(&ff->list);
> -			kfree(ff);
> -		}
> -	}
> -
> -	return err;
> -}
> -
> -static int kho_abort(void)
> +static int __kho_abort(void)
>   {
>   	int err;
>   	unsigned long order;
> @@ -1120,7 +1061,28 @@ static int kho_abort(void)
>   	return err;
>   }
>   
> -static int kho_finalize(void)
> +int kho_abort(void)
> +{
> +	int ret = 0;
> +
> +	if (!kho_enable)
> +		return -EOPNOTSUPP;
> +
> +	guard(mutex)(&kho_out.lock);
> +	if (!kho_out.finalized)
> +		return -ENOENT;
> +
> +	ret = __kho_abort();
> +	if (ret)
> +		return ret;
> +
> +	kho_out.finalized = false;
> +	kho_debugfs_cleanup(&kho_out.dbg);
> +
> +	return 0;
> +}
> +
> +static int __kho_finalize(void)
>   {
>   	int err = 0;
>   	u64 *preserved_mem_map;
> @@ -1163,118 +1125,46 @@ static int kho_finalize(void)
>   abort:
>   	if (err) {
>   		pr_err("Failed to convert KHO state tree: %d\n", err);
> -		kho_abort();
> +		__kho_abort();
>   	}
>   
>   	return err;
>   }
>   
> -static int kho_out_finalize_get(void *data, u64 *val)
> +int kho_finalize(void)
>   {
> -	mutex_lock(&kho_out.lock);
> -	*val = kho_out.finalized;
> -	mutex_unlock(&kho_out.lock);
> -
> -	return 0;
> -}
> -
> -static int kho_out_finalize_set(void *data, u64 _val)
> -{
> -	int ret = 0;
> -	bool val = !!_val;
> -
> -	mutex_lock(&kho_out.lock);
> +	int ret;
>   
> -	if (val == kho_out.finalized) {
> -		if (kho_out.finalized)
> -			ret = -EEXIST;
> -		else
> -			ret = -ENOENT;
> -		goto unlock;
> -	}
> +	if (!kho_enable)
> +		return -EOPNOTSUPP;
>   
> -	if (val)
> -		ret = kho_finalize();
> -	else
> -		ret = kho_abort();
> +	guard(mutex)(&kho_out.lock);
> +	if (kho_out.finalized)
> +		return -EEXIST;
>   
> +	ret = __kho_finalize();
>   	if (ret)
> -		goto unlock;
> -
> -	kho_out.finalized = val;
> -	ret = kho_out_update_debugfs_fdt();
> -
> -unlock:
> -	mutex_unlock(&kho_out.lock);
> -	return ret;
> -}
> -
> -DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
> -			 kho_out_finalize_set, "%llu\n");
> -
> -static int scratch_phys_show(struct seq_file *m, void *v)
> -{
> -	for (int i = 0; i < kho_scratch_cnt; i++)
> -		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
> -
> -	return 0;
> -}
> -DEFINE_SHOW_ATTRIBUTE(scratch_phys);
> +		return ret;
>   
> -static int scratch_len_show(struct seq_file *m, void *v)
> -{
> -	for (int i = 0; i < kho_scratch_cnt; i++)
> -		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
> +	kho_out.finalized = true;
>   
> -	return 0;
> +	return kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
> +				   page_to_virt(kho_out.ser.fdt), true);
>   }
> -DEFINE_SHOW_ATTRIBUTE(scratch_len);
>   
> -static __init int kho_out_debugfs_init(void)
> +bool kho_finalized(void)
>   {
> -	struct dentry *dir, *f, *sub_fdt_dir;
> -
> -	dir = debugfs_create_dir("out", debugfs_root);
> -	if (IS_ERR(dir))
> -		return -ENOMEM;
> -
> -	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
> -	if (IS_ERR(sub_fdt_dir))
> -		goto err_rmdir;
> -
> -	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
> -				&scratch_phys_fops);
> -	if (IS_ERR(f))
> -		goto err_rmdir;
> -
> -	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
> -				&scratch_len_fops);
> -	if (IS_ERR(f))
> -		goto err_rmdir;
> -
> -	f = debugfs_create_file("finalize", 0600, dir, NULL,
> -				&fops_kho_out_finalize);
> -	if (IS_ERR(f))
> -		goto err_rmdir;
> -
> -	kho_out.dir = dir;
> -	kho_out.ser.sub_fdt_dir = sub_fdt_dir;
> -	return 0;
> -
> -err_rmdir:
> -	debugfs_remove_recursive(dir);
> -	return -ENOENT;
> +	guard(mutex)(&kho_out.lock);
> +	return kho_out.finalized;
>   }
>   
>   struct kho_in {
> -	struct dentry *dir;
>   	phys_addr_t fdt_phys;
>   	phys_addr_t scratch_phys;
> -	struct list_head fdt_list;
> +	struct kho_debugfs dbg;
>   };
>   
>   static struct kho_in kho_in = {
> -	.fdt_list = LIST_HEAD_INIT(kho_in.fdt_list),
>   };
>   
>   static const void *kho_get_fdt(void)
> @@ -1338,56 +1228,6 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>   }
>   EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>   
> -/* Handling for debugfs/kho/in */
> -
> -static __init int kho_in_debugfs_init(const void *fdt)
> -{
> -	struct dentry *sub_fdt_dir;
> -	int err, child;
> -
> -	kho_in.dir = debugfs_create_dir("in", debugfs_root);
> -	if (IS_ERR(kho_in.dir))
> -		return PTR_ERR(kho_in.dir);
> -
> -	sub_fdt_dir = debugfs_create_dir("sub_fdts", kho_in.dir);
> -	if (IS_ERR(sub_fdt_dir)) {
> -		err = PTR_ERR(sub_fdt_dir);
> -		goto err_rmdir;
> -	}
> -
> -	err = kho_debugfs_fdt_add(&kho_in.fdt_list, kho_in.dir, "fdt", fdt);
> -	if (err)
> -		goto err_rmdir;
> -
> -	fdt_for_each_subnode(child, fdt, 0) {
> -		int len = 0;
> -		const char *name = fdt_get_name(fdt, child, NULL);
> -		const u64 *fdt_phys;
> -
> -		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
> -		if (!fdt_phys)
> -			continue;
> -		if (len != sizeof(*fdt_phys)) {
> -			pr_warn("node `%s`'s prop `fdt` has invalid length: %d\n",
> -				name, len);
> -			continue;
> -		}
> -		err = kho_debugfs_fdt_add(&kho_in.fdt_list, sub_fdt_dir, name,
> -					  phys_to_virt(*fdt_phys));
> -		if (err) {
> -			pr_warn("failed to add fdt `%s` to debugfs: %d\n", name,
> -				err);
> -			continue;
> -		}
> -	}
> -
> -	return 0;
> -
> -err_rmdir:
> -	debugfs_remove_recursive(kho_in.dir);
> -	return err;
> -}
> -
>   static __init int kho_init(void)
>   {
>   	int err = 0;
> @@ -1402,27 +1242,16 @@ static __init int kho_init(void)
>   		goto err_free_scratch;
>   	}
>   
> -	debugfs_root = debugfs_create_dir("kho", NULL);
> -	if (IS_ERR(debugfs_root)) {
> -		err = -ENOENT;
> +	err = kho_debugfs_init();
> +	if (err)
>   		goto err_free_fdt;
> -	}
>   
> -	err = kho_out_debugfs_init();
> +	err = kho_out_debugfs_init(&kho_out.dbg);
>   	if (err)
>   		goto err_free_fdt;
>   
>   	if (fdt) {
> -		err = kho_in_debugfs_init(fdt);
> -		/*
> -		 * Failure to create /sys/kernel/debug/kho/in does not prevent
> -		 * reviving state from KHO and setting up KHO for the next
> -		 * kexec.
> -		 */
> -		if (err)
> -			pr_err("failed exposing handover FDT in debugfs: %d\n",
> -			       err);
> -
> +		kho_in_debugfs_init(&kho_in.dbg, fdt);
>   		return 0;
>   	}
>   
> diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
> new file mode 100644
> index 000000000000..a91b279f1b23
> --- /dev/null
> +++ b/kernel/kexec_handover_debugfs.c
> @@ -0,0 +1,216 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * kexec_handover_debugfs.c - kexec handover debugfs interfaces
> + * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
> + * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
> + * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
> + * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +#define pr_fmt(fmt) "KHO: " fmt
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/libfdt.h>
> +#include <linux/mm.h>
> +#include "kexec_handover_internal.h"
> +
> +static struct dentry *debugfs_root;
> +
> +struct fdt_debugfs {
> +	struct list_head list;
> +	struct debugfs_blob_wrapper wrapper;
> +	struct dentry *file;
> +};
> +
> +static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
> +				 const char *name, const void *fdt)
> +{
> +	struct fdt_debugfs *f;
> +	struct dentry *file;
> +
> +	f = kmalloc(sizeof(*f), GFP_KERNEL);
> +	if (!f)
> +		return -ENOMEM;
> +
> +	f->wrapper.data = (void *)fdt;
> +	f->wrapper.size = fdt_totalsize(fdt);
> +
> +	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
> +	if (IS_ERR(file)) {
> +		kfree(f);
> +		return PTR_ERR(file);
> +	}
> +
> +	f->file = file;
> +	list_add(&f->list, list);
> +
> +	return 0;
> +}
> +
> +int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
> +			const void *fdt, bool root)
> +{
> +	struct dentry *dir;
> +
> +	if (root)
> +		dir = dbg->dir;
> +	else
> +		dir = dbg->sub_fdt_dir;
> +
> +	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
> +}
> +
> +void kho_debugfs_cleanup(struct kho_debugfs *dbg)
> +{
> +	struct fdt_debugfs *ff, *tmp;
> +
> +	list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
> +		debugfs_remove(ff->file);
> +		list_del(&ff->list);
> +		kfree(ff);
> +	}
> +}
> +
> +static int kho_out_finalize_get(void *data, u64 *val)
> +{
> +	*val = kho_finalized();
> +
> +	return 0;
> +}
> +
> +static int kho_out_finalize_set(void *data, u64 val)
> +{
> +	if (val)
> +		return kho_finalize();
> +	else
> +		return kho_abort();
> +}
> +
> +DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
> +			 kho_out_finalize_set, "%llu\n");
> +
> +static int scratch_phys_show(struct seq_file *m, void *v)
> +{
> +	for (int i = 0; i < kho_scratch_cnt; i++)
> +		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
> +
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(scratch_phys);
> +
> +static int scratch_len_show(struct seq_file *m, void *v)
> +{
> +	for (int i = 0; i < kho_scratch_cnt; i++)
> +		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
> +
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(scratch_len);
> +
> +__init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
> +{
> +	struct dentry *dir, *sub_fdt_dir;
> +	int err, child;
> +
> +	INIT_LIST_HEAD(&dbg->fdt_list);
> +
> +	dir = debugfs_create_dir("in", debugfs_root);
> +	if (IS_ERR(dir)) {
> +		err = PTR_ERR(dir);
> +		goto err_out;
> +	}
> +
> +	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
> +	if (IS_ERR(sub_fdt_dir)) {
> +		err = PTR_ERR(sub_fdt_dir);
> +		goto err_rmdir;
> +	}
> +
> +	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
> +	if (err)
> +		goto err_rmdir;
> +
> +	fdt_for_each_subnode(child, fdt, 0) {
> +		int len = 0;
> +		const char *name = fdt_get_name(fdt, child, NULL);
> +		const u64 *fdt_phys;
> +
> +		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
> +		if (!fdt_phys)
> +			continue;
> +		if (len != sizeof(*fdt_phys)) {
> +			pr_warn("node %s prop fdt has invalid length: %d\n",
> +				name, len);
> +			continue;
> +		}
> +		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
> +					    phys_to_virt(*fdt_phys));
> +		if (err) {
> +			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
> +				err);
> +			continue;
> +		}
> +	}
> +
> +	dbg->dir = dir;
> +	dbg->sub_fdt_dir = sub_fdt_dir;
> +
> +	return;
> +err_rmdir:
> +	debugfs_remove_recursive(dir);
> +err_out:
> +	/*
> +	 * Failure to create /sys/kernel/debug/kho/in does not prevent
> +	 * reviving state from KHO and setting up KHO for the next
> +	 * kexec.
> +	 */
> +	if (err)
> +		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
> +}
> +
> +__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
> +{
> +	struct dentry *dir, *f, *sub_fdt_dir;
> +
> +	INIT_LIST_HEAD(&dbg->fdt_list);
> +
> +	dir = debugfs_create_dir("out", debugfs_root);
> +	if (IS_ERR(dir))
> +		return -ENOMEM;
> +
> +	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
> +	if (IS_ERR(sub_fdt_dir))
> +		goto err_rmdir;
> +
> +	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
> +				&scratch_phys_fops);
> +	if (IS_ERR(f))
> +		goto err_rmdir;
> +
> +	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
> +				&scratch_len_fops);
> +	if (IS_ERR(f))
> +		goto err_rmdir;
> +
> +	f = debugfs_create_file("finalize", 0600, dir, NULL,
> +				&kho_out_finalize_fops);
> +	if (IS_ERR(f))
> +		goto err_rmdir;
> +
> +	dbg->dir = dir;
> +	dbg->sub_fdt_dir = sub_fdt_dir;
> +	return 0;
> +
> +err_rmdir:
> +	debugfs_remove_recursive(dir);
> +	return -ENOENT;
> +}
> +
> +__init int kho_debugfs_init(void)
> +{
> +	debugfs_root = debugfs_create_dir("kho", NULL);
> +	if (IS_ERR(debugfs_root))
> +		return -ENOENT;
> +	return 0;
> +}
> diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
> index 05e9720ba7b9..217b8b25a542 100644
> --- a/kernel/kexec_handover_internal.h
> +++ b/kernel/kexec_handover_internal.h
> @@ -2,8 +2,47 @@
>   #ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
>   #define LINUX_KEXEC_HANDOVER_INTERNAL_H
>   
> +#include <linux/kexec_handover.h>
> +#include <linux/list.h>
>   #include <linux/types.h>
>   
> +#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
> +#include <linux/debugfs.h>
> +
> +struct kho_debugfs {
> +	struct dentry *dir;
> +	struct dentry *sub_fdt_dir;
> +	struct list_head fdt_list;
> +};
> +
> +#else
> +struct kho_debugfs {};
> +#endif
> +
> +extern struct kho_scratch *kho_scratch;
> +extern unsigned int kho_scratch_cnt;
> +
> +bool kho_finalized(void);
> +int kho_finalize(void);
> +int kho_abort(void);
> +
> +#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
> +int kho_debugfs_init(void);
> +void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
> +int kho_out_debugfs_init(struct kho_debugfs *dbg);
> +int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
> +			const void *fdt, bool root);
> +void kho_debugfs_cleanup(struct kho_debugfs *dbg);
> +#else
> +static inline int kho_debugfs_init(void) { return 0; }
> +static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
> +				       const void *fdt) { }
> +static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
> +static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
> +				      const void *fdt, bool root) { return 0; }
> +static inline void kho_debugfs_cleanup(struct kho_debugfs *dbg) {}
> +#endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
> +
>   #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
>   bool kho_scratch_overlap(phys_addr_t phys, size_t size);
>   #else
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
> index 3f6c17166846..49fdac8e8b15 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -59,6 +59,7 @@ function build_kernel() {
>   	tee "$kconfig" > "$kho_config" <<EOF
>   CONFIG_BLK_DEV_INITRD=y
>   CONFIG_KEXEC_HANDOVER=y
> +CONFIG_KEXEC_HANDOVER_DEBUGFS=y
>   CONFIG_TEST_KEXEC_HANDOVER=y
>   CONFIG_DEBUG_KERNEL=y
>   CONFIG_DEBUG_VM=y


