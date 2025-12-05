Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41358D2F7D1
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 10:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68EA66B014B; Fri,  5 Dec 2025 05:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665C46B014C; Fri,  5 Dec 2025 05:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57BD56B014D; Fri,  5 Dec 2025 05:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 446586B014B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 05:11:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3AF2140489
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:11:02 +0000 (UTC)
X-FDA: 84184999164.18.1ED36CF
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id C504014000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:10:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764929461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6I4Fr/V23Z5r95XeaWQVdti93QXflCesYswNc+gmL38=;
	b=slYZjIm8ggVWmA65UECE9llkdm2SoCNYLmWh+RHCoHfS4VDYle/7LE9tw84FCPsn88BBqa
	GMKQSXiR7AVSPhCfOUq/bvGo3hmVFX+MCoCbD5pP8XH+q+FFq6UFnbIpxE6Hgp102lNrLK
	8bBAK7/T/y8TTKgt7sihOBBDsL0csHA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764929461; a=rsa-sha256;
	cv=none;
	b=8Id6VSAu+QP5YLaItoGozQqBQKZzrkizFriOpk6FNr+fpl2rBeHR1Wx4pgjRkUzA5iCKud
	mw4IoQFuSSq5V8cA7lcYM+/0iGunkOIe/QP1h9KGN+YQzor9Am0SfWfiL5n/xkrKoffpo+
	oErGo4pqzybCMw0Pi2CzvdcOGZJL54c=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dN6Z30t4vzKHMPY
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:10:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 654221A07BB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:10:55 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCXwZ6vrzJpCVG3Ag--.58028S2;
	Fri, 05 Dec 2025 18:10:55 +0800 (CST)
Message-ID: <25cac682-e6a5-4ab2-bae2-fb4df2d33626@huaweicloud.com>
Date: Fri, 5 Dec 2025 18:10:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] cgroup, binfmt_elf: Add hwcap masks to the misc
 controller
To: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
References: <20251205005841.3942668-1-avagin@google.com>
 <20251205005841.3942668-2-avagin@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251205005841.3942668-2-avagin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXwZ6vrzJpCVG3Ag--.58028S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr45Ww4xZFWDZFyxuw45Jrb_yoWfXw45pF
	WDCF98G395trW7JrWSy3Wqvryruw1kXr4Du3yUWw10vFZIgr15XF4UCw4UCF1YkFWv9ry3
	tw15CF4Y9340qa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUb
	mii3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: yptuqfqstth413hnqc6ja5ggtptferi1
X-Rspam-User: 
X-Rspamd-Queue-Id: C504014000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764929458-51087
X-HE-Meta: U2FsdGVkX18Fm7ibXf4mmgu58gJHsTiwY6LD7DeAaWEgogkb60AuSMfMnCCXo/zZtZxz+a5EdV4lVthI8a0G/0dX901dwUMB+RN0AhKYz10DHeX6aBrkE1qvjR7AZDC37UwNqfUja7gfWsmaIm1+w5SIxzzy4GEVL3o04VIk9oAnMkEv11pd6gV/+V/Bq0hRrsv9vLd3+ITi5BMrds7oxd3LVmygOAX42SxvBNJxewQYycg3fltWsWfOEs6d9Erqz6hA3PKjwaLKVfJO4vb7KDDFNuhuPuggeSdou4khLw96pO031iBcbpbuFIEyH2ASFVsjILeOI08BLUCymCy2otc05VlypSHCW2aEmDMBV1gzoVktg/saEpoFom18xkBGWnFZAL2V5pb3XvpIykNQk/gqdm0lMXDmizBIz8oPb0mBl4Liq5nKwQqXlqLyf6+HV0KdPGzw1b0pL98VvKnd+ih9HJPdJRvxnE3jmOE5wBkgIghDo1xrYH+z6FJ8PiRK6jEeUNn3B5SdNNzBrrx2k30X7KuIPvhHiVUxDi5YKj1RSMe4pk1zVOSqCiffwFOT+XHAXrHymheeVQnI4FxeZWaRcx4PtQUV7M55JBdg6iRZbGsAdyfsou7Hod03wwwQlhlaadXY5gzYocSvCeUWE5gw7tJkN20iMkZhLm1l/E7EZdqYb0MRQDhhHLsJkAj71ueb7uXLbcg3Xk4c4cevsGKYzxlEixAOn2L8giTHWUBkdYf16zEIib222ot7OIMGts97AADSiW7kjoJ2iu4KRD6yezCEoFkl5gTFwwX/6R2XW+VrWtEiRzk1BALPL6Iqe4X9slojQlXXBIUN49jImqBqKrdD/oSDVnhYXdlGr0HgalzxpwosuQdTRqxdeG2LCmIFE5jlmh0XJwrUJsr/wFrTzocEEza4ex81T5v54vJsYkFOVL4Box27NpyCt8HZ7jAQ29S9qOK/wfeeWYj
 Y6T4/ZLQ
 xQyIFIwjxEaPfMeNaeUBryMZXiUlLsmTzhMeqs0/RiIQsOiAm9jKapYaikgP8HU+Aq5xw6OoCTHpytUwBjoel4nFHkLI2O5pnykR9X4vRjI8bnSc/7eljZR0JDCswJeS0EBMnM6XJzKhBtPDpM5RDhDJhXjYmITRG+6IerTt+S8dK0bhsXQiqjthFSnwdZ20eLWA/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 8:58, Andrei Vagin wrote:
> Add an interface to the misc cgroup controller that allows masking out
> hardware capabilities (AT_HWCAP) reported to user-space processes. This
> provides a mechanism to restrict the features a containerized
> application can see.
> 
> The new "misc.mask" cgroup file allows users to specify masks for
> AT_HWCAP, AT_HWCAP2, AT_HWCAP3, and AT_HWCAP4.
> 
> The output of "misc.mask" is extended to display the effective mask,
> which is a combination of the masks from the current cgroup and all its
> ancestors.
> 
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf.c             |  24 +++++--
>  include/linux/misc_cgroup.h |  25 +++++++
>  kernel/cgroup/misc.c        | 126 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 171 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3eb734c192e9..59137784e81d 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -47,6 +47,7 @@
>  #include <linux/dax.h>
>  #include <linux/uaccess.h>
>  #include <uapi/linux/rseq.h>
> +#include <linux/misc_cgroup.h>
>  #include <asm/param.h>
>  #include <asm/page.h>
>  
> @@ -182,6 +183,21 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	int ei_index;
>  	const struct cred *cred = current_cred();
>  	struct vm_area_struct *vma;
> +	struct misc_cg *misc_cg;
> +	u64 hwcap_mask[4] = {0, 0, 0, 0};
> +
> +	misc_cg = get_current_misc_cg();
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP, misc_cg, &hwcap_mask[0]);
> +#ifdef ELF_HWCAP2
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP2, misc_cg, &hwcap_mask[1]);
> +#endif
> +#ifdef ELF_HWCAP3
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP3, misc_cg, &hwcap_mask[2]);
> +#endif
> +#ifdef ELF_HWCAP4
> +	misc_cg_get_mask(MISC_CG_MASK_HWCAP4, misc_cg, &hwcap_mask[3]);
> +#endif
> +	put_misc_cg(misc_cg);
>  
>  	/*
>  	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
> @@ -246,7 +262,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	 */
>  	ARCH_DLINFO;
>  #endif
> -	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP & ~hwcap_mask[0]);
>  	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>  	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
>  	NEW_AUX_ENT(AT_PHDR, phdr_addr);
> @@ -264,13 +280,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
>  	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
>  #ifdef ELF_HWCAP2
> -	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> +	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2 & ~hwcap_mask[1]);
>  #endif
>  #ifdef ELF_HWCAP3
> -	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
> +	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3 & ~hwcap_mask[2]);
>  #endif
>  #ifdef ELF_HWCAP4
> -	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
> +	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4 & ~hwcap_mask[3]);
>  #endif
>  	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
>  	if (k_platform) {
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index 0cb36a3ffc47..cff830c238fb 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -8,6 +8,8 @@
>  #ifndef _MISC_CGROUP_H_
>  #define _MISC_CGROUP_H_
>  
> +#include <linux/elf.h>
> +
>  /**
>   * enum misc_res_type - Types of misc cgroup entries supported by the host.
>   */
> @@ -26,6 +28,20 @@ enum misc_res_type {
>  	MISC_CG_RES_TYPES
>  };
>  
> +enum misc_mask_type {
> +	MISC_CG_MASK_HWCAP,
> +#ifdef ELF_HWCAP2
> +	MISC_CG_MASK_HWCAP2,
> +#endif
> +#ifdef ELF_HWCAP3
> +	MISC_CG_MASK_HWCAP3,
> +#endif
> +#ifdef ELF_HWCAP4
> +	MISC_CG_MASK_HWCAP4,
> +#endif
> +	MISC_CG_MASK_TYPES
> +};
> +
>  struct misc_cg;
>  
>  #ifdef CONFIG_CGROUP_MISC
> @@ -62,12 +78,15 @@ struct misc_cg {
>  	struct cgroup_file events_local_file;
>  
>  	struct misc_res res[MISC_CG_RES_TYPES];
> +	u64 mask[MISC_CG_MASK_TYPES];
>  };
>  
>  int misc_cg_set_capacity(enum misc_res_type type, u64 capacity);
>  int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg, u64 amount);
>  void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg, u64 amount);
>  
> +int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask);
> +
>  /**
>   * css_misc() - Get misc cgroup from the css.
>   * @css: cgroup subsys state object.
> @@ -134,5 +153,11 @@ static inline void put_misc_cg(struct misc_cg *cg)
>  {
>  }
>  
> +static inline int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask)
> +{
> +	*pmask = 0;
> +	return 0;
> +}
> +
>  #endif /* CONFIG_CGROUP_MISC */
>  #endif /* _MISC_CGROUP_H_ */
> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> index 6a01d91ea4cb..d1386d86060f 100644
> --- a/kernel/cgroup/misc.c
> +++ b/kernel/cgroup/misc.c
> @@ -30,6 +30,19 @@ static const char *const misc_res_name[] = {
>  #endif
>  };
>  
> +static const char *const misc_mask_name[] = {
> +	"AT_HWCAP",
> +#ifdef ELF_HWCAP2
> +	"AT_HWCAP2",
> +#endif
> +#ifdef ELF_HWCAP3
> +	"AT_HWCAP3",
> +#endif
> +#ifdef ELF_HWCAP4
> +	"AT_HWCAP4",
> +#endif
> +};
> +
>  /* Root misc cgroup */
>  static struct misc_cg root_cg;
>  
> @@ -71,6 +84,11 @@ static inline bool valid_type(enum misc_res_type type)
>  	return type >= 0 && type < MISC_CG_RES_TYPES;
>  }
>  
> +static inline bool valid_mask_type(enum misc_mask_type type)
> +{
> +	return type >= 0 && type < MISC_CG_MASK_TYPES;
> +}
> +
>  /**
>   * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
>   * @type: Type of the misc res.
> @@ -391,6 +409,109 @@ static int misc_events_local_show(struct seq_file *sf, void *v)
>  	return __misc_events_show(sf, true);
>  }
>  
> +/**
> + * misc_cg_get_mask() - Get the mask of the specified type.
> + * @type: The misc mask type.
> + * @cg: The misc cgroup.
> + * @pmask: Pointer to the resulting mask.
> + *
> + * This function calculates the effective mask for a given cgroup by walking up
> + * the hierarchy and ORing the masks from all parent cgroupfs. The final result
> + * is stored in the location pointed to by @pmask.
> + *
> + * Context: Any context.
> + * Return: 0 on success, -EINVAL if @type is invalid.
> + */
> +int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask)
> +{
> +	struct misc_cg *i;
> +	u64 mask = 0;
> +
> +	if (!(valid_mask_type(type)))
> +		return -EINVAL;
> +
> +	for (i = cg; i; i = parent_misc(i))
> +		mask |= READ_ONCE(i->mask[type]);
> +
> +	*pmask = mask;
> +	return 0;
> +}
> +
> +/**
> + * misc_cg_mask_show() - Show the misc cgroup masks.
> + * @sf: Interface file
> + * @v: Arguments passed
> + *
> + * Context: Any context.
> + * Return: 0 to denote successful print.
> + */
> +static int misc_cg_mask_show(struct seq_file *sf, void *v)
> +{
> +	struct misc_cg *cg = css_misc(seq_css(sf));
> +	int i;
> +
> +	for (i = 0; i < MISC_CG_MASK_TYPES; i++) {
> +		u64 rval, val = READ_ONCE(cg->mask[i]);
> +
> +		misc_cg_get_mask(i, cg, &rval);
> +		seq_printf(sf, "%s\t%#016llx\t%#016llx\n", misc_mask_name[i], val, rval);
> +	}
> +
> +	return 0;
> +}
> +

I'm concerned about the performance impact of the bottom-up traversal in deeply nested cgroup
hierarchies. Could this approach introduce noticeable latency in such scenarios?

> +/**
> + * misc_cg_mask_write() - Update the mask of the specified type.
> + * @of: Handler for the file.
> + * @buf: The buffer containing the user's input.
> + * @nbytes: The number of bytes in @buf.
> + * @off: The offset in the file.
> + *
> + * This function parses a user-provided string to update a mask.
> + * The expected format is "<mask_name> <value>", for example:
> + *
> + * echo "AT_HWCAP 0xf00" > misc.mask
> + *
> + * Context: Process context.
> + * Return: The number of bytes processed on success, or a negative error code
> + * on failure.
> + */
> +static ssize_t misc_cg_mask_write(struct kernfs_open_file *of, char *buf,
> +				 size_t nbytes, loff_t off)
> +{
> +	struct misc_cg *cg;
> +	u64 max;
> +	int ret = 0, i;
> +	enum misc_mask_type type = MISC_CG_MASK_TYPES;
> +	char *token;
> +
> +	buf = strstrip(buf);
> +	token = strsep(&buf, " ");
> +
> +	if (!token || !buf)
> +		return -EINVAL;
> +
> +	for (i = 0; i < MISC_CG_MASK_TYPES; i++) {
> +		if (!strcmp(misc_mask_name[i], token)) {
> +			type = i;
> +			break;
> +		}
> +	}
> +
> +	if (type == MISC_CG_MASK_TYPES)
> +		return -EINVAL;
> +
> +	ret = kstrtou64(buf, 0, &max);
> +	if (ret)
> +		return ret;
> +
> +	cg = css_misc(of_css(of));
> +
> +	WRITE_ONCE(cg->mask[type], max);
> +
> +	return nbytes;
> +}
> +
>  /* Misc cgroup interface files */
>  static struct cftype misc_cg_files[] = {
>  	{
> @@ -424,6 +545,11 @@ static struct cftype misc_cg_files[] = {
>  		.file_offset = offsetof(struct misc_cg, events_local_file),
>  		.seq_show = misc_events_local_show,
>  	},
> +	{
> +		.name = "mask",
> +		.write = misc_cg_mask_write,
> +		.seq_show = misc_cg_mask_show,
> +	},
>  	{}
>  };
>  

-- 
Best regards,
Ridong


