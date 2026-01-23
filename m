Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A70D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D256B03CA; Fri, 23 Jan 2026 01:21:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73016B03CC; Fri, 23 Jan 2026 01:21:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F456B03CB; Fri, 23 Jan 2026 01:21:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C47896B03C9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:21:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80A91586CF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:21:05 +0000 (UTC)
X-FDA: 84362230890.03.3415D26
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E65C160004;
	Fri, 23 Jan 2026 06:21:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ED57aQPb;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1870OwY7Yt3wtHMS4Kw5+Uzzq7JdVz48VXgwCaXXTJw=;
	b=jspoQgg7MTpyEmNWSSh+bvvmHA65rUWChfLiAY1oZhH2FbI99DDKOqKC0M6nP+jMipNWHh
	TLrW4a3Ai/mtLYdT10AVBS2P3P7PHJEbjUhXpP1yNskcakWFEDzMNdYy9YG58SoVToIXQ4
	89kCN+hYV341xV40IPVvloSP41efS0o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ED57aQPb;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769149263; a=rsa-sha256;
	cv=none;
	b=kMZAgNEBbxNOaYvP/5970BZbHvJ7ScRxRJfgPCpP5NgTCVcpaPlT34N24MWT1cxWpw3tdU
	6RmbI25xqfFETg1ZZhPvAMyxXFIUQEt2TSbLOQdx97GwZ28/N/1qTvCaFipA87noa6/p8b
	PCJsv1ETtFOh7fsb4S+WFayNszG8d1k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769149257; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1870OwY7Yt3wtHMS4Kw5+Uzzq7JdVz48VXgwCaXXTJw=;
	b=ED57aQPb3NP6UeThPAkqaiTJl0IxDMAfCESU+LlSF+BB7cK4Crmx6DeDwhuGg+Jixk4O9AqWKkc2/T+uMMydFC2AY5p6j87aLZjVw71UrXCGEPT3586VpMnQoE0EOUnzuJ8iyF745z1G9WmMjM0O1SWUgKyf0dDhJwTbJvfFfZI=
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxemimV_1769149254 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 14:20:54 +0800
Message-ID: <7ccc3447-3a39-4206-95c5-a6cd00e2bda6@linux.alibaba.com>
Date: Fri, 23 Jan 2026 14:20:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] mm: update shmem_[kernel]_file_*() functions to
 use vma_flags_t
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
 linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E65C160004
X-Stat-Signature: ja5xzrqf1ebw9odyku5mq3mbkh9xji5d
X-Rspam-User: 
X-HE-Tag: 1769149261-157575
X-HE-Meta: U2FsdGVkX18Z+rbvxI6pyuNR3O6pgTyV/KPUDDpiwDlul4zHh+PKk/ISAHCf7W2e/uDiHG/NMWFJrHrAUJ4M4o0KpB+Y5OVHUt96szCH/2oBaBASjwTlvAXSluTCP9fJpei5rUFAo7OC8yKNTemaIVf3jBgve0qufdkeWZB5DSfP3A25wHcrL6fMLuvwF4UjBh8uh6abuS3fr3Hnf00EF9EPqiT/eg5qu7Y6CceAbrmIsBEAfFc/BhSusEV1jEum3+UdWFwF5dfaPRORk6FxorfOUqdvxrJdkNQ6xrZHIiEjN+6rBTlg2npwDlC4t1D5aaInsRc4YHYNWYxnUXv+3p1Upz8AemVmSw7gUyiv7Wo54nXVwYh8/BdZx+GTGKm6VDATkuftQlsGEQ5vLlkdvDv31v3T2os30Vr+8MOW6H/iD2j5QZZkAF32W6i9cSZ+4PR7Er3sXlza6EPX3/n0nnmCF+93AP4ljc34u6jj63vZxuDw8AM/E3s187oXLztk+ww643BKZZr7rs5Mil1MmItNIu7KwBztC8iTU26GAhLxyYT/2DU8B7YbFx1V076w5bLtn+D0t+aqzO2e7tZpxzW3yqhxhS39q1EKs7J1NwdSGELfXukR9cSYHvWE+daAicS9vhbxH3rAjrZGdYFjzBXyNibbd3iS3nO3QaGMp51W00+rvQEdyiJS9/ZbkrKs7ZG6fuUyCqpqNv8mAvGNLgZisRIdHyRa+076mJdaDGCwWbLm3LkmnaXi62BCxjmfnrcoYMt9lZfJ+avY8S8XJMYzLXxZWRPRndw+81EE64kWJfWO7P6dFBw5YtiwQ8nn/QaJiQHvmDxMgX9ZWiHXFjCjGUlYVqMNf+/mKp2lC32hzq1jrvtd/ewFDb7PI2uinKzkRQJsF05idDL/5gg5EUdZxXsy7Ye+JCnX7zrufh9MwNtd/7RxiYIOmFiqdf0cod436VmArN1mhlh/CfK
 jOYDBlhz
 gvoeLQww4toG6mecU2oa0F7u7xJ4FP/eiI7iqHz/2KyVAqZK5+Vk/DlpQexArwvxnnoKxqX7n95MIiCLX+ZTh36NdLxYwjFVwvusB5zPCEQIJ0a3m01SzPacv+RjnSrDhTwqX1cHSI+lzj3nq1fkyo3mIOOqTn3x1UB+HBspPvfKFgLfGxLg+HVcEDww1N2nEIVxoaR/6xg3jiOYVyaBR11LCVkYuZTq6KExLqbDmZsM8dFvxvcFizjVl9IzqHOUHE8jpFwPQVcC+5kjUP/bweMvckjkv8xFcBxXIVcd39gGiZggDE9iMSpez5CJ1Uq7RliL+bKjUcMsf1ZsNdvpJIMqPuZ+vwFAbE04JUXs1MtMqMaO//iaJ0viJ/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/23/26 12:06 AM, Lorenzo Stoakes wrote:
> In order to be able to use only vma_flags_t in vm_area_desc we must adjust
> shmem file setup functions to operate in terms of vma_flags_t rather than
> vm_flags_t.
> 
> This patch makes this change and updates all callers to use the new
> functions.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

(reduced distribution list too)

Thanks. The shmem part looks good to me with some nits below.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
>   arch/x86/kernel/cpu/sgx/ioctl.c           |  2 +-
>   drivers/gpu/drm/drm_gem.c                 |  5 +-
>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  2 +-
>   drivers/gpu/drm/i915/gem/i915_gem_ttm.c   |  3 +-
>   drivers/gpu/drm/i915/gt/shmem_utils.c     |  3 +-
>   drivers/gpu/drm/ttm/tests/ttm_tt_test.c   |  2 +-
>   drivers/gpu/drm/ttm/ttm_backup.c          |  3 +-
>   drivers/gpu/drm/ttm/ttm_tt.c              |  2 +-
>   fs/xfs/scrub/xfile.c                      |  3 +-
>   fs/xfs/xfs_buf_mem.c                      |  2 +-
>   include/linux/shmem_fs.h                  |  8 ++-
>   ipc/shm.c                                 |  6 +--
>   mm/memfd.c                                |  2 +-
>   mm/memfd_luo.c                            |  2 +-
>   mm/shmem.c                                | 59 +++++++++++++----------
>   security/keys/big_key.c                   |  2 +-
>   16 files changed, 57 insertions(+), 49 deletions(-)

[snip]

>   	inode->i_flags |= i_flags;
> @@ -5864,9 +5869,10 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
>    *	checks are provided at the key or shm level rather than the inode.
>    * @name: name for dentry (to be seen in /proc/<pid>/maps)
>    * @size: size to be set for the file
> - * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
> + * @vma_flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size

nit: s/vma_flags/flags

>    */
> -struct file *shmem_kernel_file_setup(const char *name, loff_t size, unsigned long flags)
> +struct file *shmem_kernel_file_setup(const char *name, loff_t size,
> +				     vma_flags_t flags)
>   {
>   	return __shmem_file_setup(shm_mnt, name, size, flags, S_PRIVATE);
>   }
> @@ -5878,7 +5884,7 @@ EXPORT_SYMBOL_GPL(shmem_kernel_file_setup);
>    * @size: size to be set for the file
>    * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size

nit: s/VM_NORESERVE/VMA_NORESERVE_BIT

>    */
> -struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
> +struct file *shmem_file_setup(const char *name, loff_t size, vma_flags_t flags)
>   {
>   	return __shmem_file_setup(shm_mnt, name, size, flags, 0);
>   }
> @@ -5889,16 +5895,17 @@ EXPORT_SYMBOL_GPL(shmem_file_setup);
>    * @mnt: the tmpfs mount where the file will be created
>    * @name: name for dentry (to be seen in /proc/<pid>/maps)
>    * @size: size to be set for the file
> - * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
> + * @flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
>    */
>   struct file *shmem_file_setup_with_mnt(struct vfsmount *mnt, const char *name,
> -				       loff_t size, unsigned long flags)
> +				       loff_t size, vma_flags_t flags)
>   {
>   	return __shmem_file_setup(mnt, name, size, flags, 0);
>   }
>   EXPORT_SYMBOL_GPL(shmem_file_setup_with_mnt);
>   
> -static struct file *__shmem_zero_setup(unsigned long start, unsigned long end, vm_flags_t vm_flags)
> +static struct file *__shmem_zero_setup(unsigned long start, unsigned long end,
> +		vma_flags_t flags)
>   {
>   	loff_t size = end - start;
>   
> @@ -5908,7 +5915,7 @@ static struct file *__shmem_zero_setup(unsigned long start, unsigned long end, v
>   	 * accessible to the user through its mapping, use S_PRIVATE flag to
>   	 * bypass file security, in the same way as shmem_kernel_file_setup().
>   	 */
> -	return shmem_kernel_file_setup("dev/zero", size, vm_flags);
> +	return shmem_kernel_file_setup("dev/zero", size, flags);
>   }
>   
>   /**
> @@ -5918,7 +5925,7 @@ static struct file *__shmem_zero_setup(unsigned long start, unsigned long end, v
>    */
>   int shmem_zero_setup(struct vm_area_struct *vma)
>   {
> -	struct file *file = __shmem_zero_setup(vma->vm_start, vma->vm_end, vma->vm_flags);
> +	struct file *file = __shmem_zero_setup(vma->vm_start, vma->vm_end, vma->flags);
>   
>   	if (IS_ERR(file))
>   		return PTR_ERR(file);
> @@ -5939,7 +5946,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
>    */
>   int shmem_zero_setup_desc(struct vm_area_desc *desc)
>   {
> -	struct file *file = __shmem_zero_setup(desc->start, desc->end, desc->vm_flags);
> +	struct file *file = __shmem_zero_setup(desc->start, desc->end, desc->vma_flags);
>   
>   	if (IS_ERR(file))
>   		return PTR_ERR(file);
> diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> index d46862ab90d6..268f702df380 100644
> --- a/security/keys/big_key.c
> +++ b/security/keys/big_key.c
> @@ -103,7 +103,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>   					 0, enckey);
>   
>   		/* save aligned data to file */
> -		file = shmem_kernel_file_setup("", enclen, 0);
> +		file = shmem_kernel_file_setup("", enclen, EMPTY_VMA_FLAGS);
>   		if (IS_ERR(file)) {
>   			ret = PTR_ERR(file);
>   			goto err_enckey;


