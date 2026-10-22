Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96FD606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PZtLEb6n
Received: by kanga.kvack.org (Postfix)
	id F0FEA6B02CB; Thu, 22 Oct 2026 06:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7336B08FC; Thu, 22 Oct 2026 06:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC836B02CF; Thu, 22 Oct 2026 06:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 651E06B02CB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:01:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0E2012080A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:01:44 +0000 (UTC)
X-FDA: 85349820528.27.E0CE89C
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 244991A0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:01:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZtLEb6n;
	spf=pass (imf19.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663303;
	b=19Vg/RBnSLZWqL8KsjMBa+MVn+ln2vgDYVzX/3wXaPO3oNfRqbbkqJWmQLmThTQtq0sxPb
	6MrqLG5iAIiElfGtd8gfjIcld+xcIAEVbBFn/64P+s4GtJLHPHBjk5OrFQf3/sWPxIMT7K
	IX0RkOnwNRsB/nYZ3rdNqBCKB+Z9pJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZtLEb6n;
	spf=pass (imf19.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdFl+c9HTfOJHnKVulHF/KABJga7rr2KkdaAezk90/U=;
	b=IJ6Mo7DKy7D4PlctEvZR93kQPxpUG+pALU8LKAjxz3508kWTZXokBNJ0QDrsDHnZPKnvE+
	I3KsDjo6cvyqNHDyDKhMYecjbVuKAIikzyiMFLWcJBzNh0ihNuimnlPOX/5D1kZwcaPaEE
	NPe8+ET8jgTkCTi/5Vjy09wpSRYk+dw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3fd91337baso237681666b.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792663301; x=1793268101; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AdFl+c9HTfOJHnKVulHF/KABJga7rr2KkdaAezk90/U=;
        b=PZtLEb6n9L/Hdv/WeK3cHQ6aK+YpfvWQxOfzjo+YqQvItrFXkSNLlAcEEXQw7yq5NQ
         lyedydJFrJOJFF3Ty7Fg1KSplmAZ+7AZghhFRi9wETKKFZHIDHOVx9Ugbfd9bMOe9nui
         TNgt+g21rnTkLWW8jOmnv6JPl4z/5TdgtnYrP/sVR1vgtjmMnVZYvBNjp2KKN7MSXqIT
         fwGrEqi65bFyiDmuq5963SzqhwMgMVe8i1/18YE7drXfVkaAtEdMbHYsfHFh95JzelrC
         sgNTNbl4XH+q4s15T/75nmyvS0ab8mkFkcLCRVEPTMBDdJjaVVQKupq6BlDw8mNbaOIe
         XSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792663301; x=1793268101;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AdFl+c9HTfOJHnKVulHF/KABJga7rr2KkdaAezk90/U=;
        b=evyOYk8QiAgrHCo+vVCh3YtcmI+HOkWmiFw4gxtY0yhzJ6ivpXsh4x0YfiIHJ/Hxrm
         /YpZYroJZ6+qtnY4LU9QkMHTT96hs4DV6d2olMpO34pPI14fu5Uh1tHRxiFz87D3ZHkK
         NXih/bAls5RME6pLdBtztRHJznfqFCdNwbnV2INUnqkts3A27ui4IQxtTP7G9hx5F2xK
         XvqI88SadVlWkC8Vwu1E+T5vKsGdGpnmvrirYO/JXcJ9w2+xZhhVhC/WlUMfx5kk+sog
         y1rrhMPALW+CUY4lqOIcP/cJQ25tEJq43Xm7hMHGis8NPoMTO8k/PUNoTe7vRAGOlpKk
         9Ajw==
X-Forwarded-Encrypted: i=1; AKwUvByMDAsR8JtDtBVcDTROobBUY8hze/J2/5r3+A2gNRNBxtuQSD9xwVM8i6lkyfQwtJgY0ZqYhoAGbQ==@kvack.org
X-Gm-Message-State: AFq9FYK3x4v//61HaYQj659m2KGPpdB2PFnt0Sf3F52XNL6ypeO3ttfj
	IURYgyb8xQ4RRrN9wZ8bZ0plcU0B+FRGOfNXF+52mnI/TU/XZr3DLyu6
X-Gm-Gg: AYBFou2Cz5m6A3J7o2pn1Ck6E3ohXZPzEar725OvMrz6S5WjApJ2ZteOWo2kO3leNiR
	WNLhAzl4qA7wuj5pZA1N4RdpvqLlfBJodGcSB/XNAoiCL9EQjYA4z1sfh4nIdYI1IwT0WS4tlTb
	9ekJ5vgB9E3/8wIRdA/CqyfehRhV2THE7Yv5s0L2bp/mpMXBG/gY1PVVsPjS3iqA0z1pAqMzNV7
	dY88JmCaw/rjVwL3E6/0kWkBK32Ym1UKGautdt1o0IAAhG/B1UZUY0MKL2dXVGzpHD4GQuoXfOr
	/MQdj1x9Sn46QNmE49K7CQDsoAs7RjWEz67KhfZgj/M6pRHLkqM37Vud9dLxdBaulyz5RWplI9Y
	cOo1xKO7/748zBH1sR4e6gSqtzl5T7uyRn/IsYLNRdaPaRb7PYC1fI6Sy1TjZja2zeemcXwJJK2
	OccIT1Vme1T92bPQHhaVUn/TsVKyIQnRr0Q/cxMJJo/1MIuq3C9pmH0LoVHsVT4BuUIr8iqlHjs
	bLzKeuoUj8aEXtdFvwUgDXmVtdvHJfRzIWDnkh52qQ=
X-Received: by 2002:a17:906:dc89:b0:c40:f9ea:7387 with SMTP id a640c23a62f3a-c46791a979emr451363266b.6.1792663301007;
        Thu, 22 Oct 2026 03:01:41 -0700 (PDT)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2a034fc2sm7287470f8f.5.2026.10.22.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 03:01:40 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 22 Oct 2026 12:01:37 +0200
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 0/9] bpf: Add support to allocate user page
Message-ID: <atnfAUWzdsoWQKe8@krava>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <DMAUMG9WL4X6.12UEJJMJSW54Z@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMAUMG9WL4X6.12UEJJMJSW54Z@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 244991A0006
X-Stat-Signature: d65s35nmsm51wzcdqpwyxymbqb3h9hdt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792663302-293951
X-HE-Meta: U2FsdGVkX1/FTMfplQJeqLuT2hsszeN1CfiUDOMWlz2XSmkNJh1sWVlNyOVTe/0dJltLOolt4Sd5cYdinKFq8cifD5zyj1MSOkWSfpulWWERm0TRIXdcRdNmrDfkzcsabZH+8KjNnq7fENDCCf/NBYbBPeQ2FIxdZu+MsAjiEHCw3VLu9HQOdQcEUm6TS9dG0ygaRybRndRgpxqUFvComxj1RVe+Z8ykjjA1idlCdmbhwTFxRxWfKqdpFj5IAFkWq6+1G28oUpLbf23mQwtMoosi7vblWyJsVpwWDpRd6Hxtvop3pMjPgKCwbXH6vAgYEzIRnQgpNEltj+plF5+FoYpfCJHdPeYaQwP5i87Y8tkc31ubVCytTGdyptzTbsv86C2n5Ks8Mna0pq7xWvLas/5PAIDNAJrr0DfN8oLvtqunxjtnsbid04Nz+nfz6BYZoJ7YSVlLstiq7Tac00LvpUaCniK4ylcljbPnKJvAjMkYZy0OxLrobtudq53QXkIgAA25Gu18MvptDDQAV9DAxHH8iKeYAvIlRD/NT64ukgPqyZXjuYJ/HOTzaO0LV3VRIV/9U8xsjTxt13sDyyh66nGCbQZrjaKvUF5Jdufuhx8Chxs/2mHhh4ttkbnXKBLO65fO9TREYVe0XVzUTJWwzdQrbI/mAjNjOEDpn5IckORoGJSdpiPI58kJemj3oSLU6vDViwxmQU6OsTHJWA0bde+68sA9qAA4R7lJmIjdvawosEAKWNmbGxRz94qfXoj/EOmvjgfp6d/LNXNcr00r1/TCvQ0mS7ZbazuXSplkXEAHLjjPTE5CO3jZWYWDZYWH2aYP1k8sFp80fjhluKzqYjCSoLBaNDxRL+j3soYysy0BCwO45UxNrkkrUyotMYL8LqIFLOZuPLRJBNyKSTJ7k2cbmbYKbQSqtOzgoBXNeCkH/Cqj78FMMK3RWELdsu9n/zl/EmaWP2odbxuv+mZ
 s9JNy7bk
 tOJwKKDXOK4bjDmZDA2VB5WPJVB5JDlB7K3eBtGBka6bFpY+ZYn0NDY+4ZXjAgK6y1dYgPZcLmnGlWvoYy4ctZ1msguLoG50USV5Y8zTYoEiYyI2otx8MDvqkzNSxNOYAYOstiriF73WisiJOkXEzq/yQmdIyiCEzog779EfZu+pqccmp6xa0yw2mEp+RGT6qQ+bnadpBsL/2w+YORMCqG4X3za6m9GsjarELO7vmpAtsWblmlrQhcfVmmV0jVl5hA0yCoEafyCK6YaHdOozaEmWjb1YS8i0d4QpnEi2xW4frFomcvw8TqJ/X/QnUM4Pfi05Hp/l+TLZJ6sAnpnD13bxaERi1kr3Px7ncHHETj2/r4jsDsxlql4ZkXMcXGd9kmyj5Pjfbian0U/190FyxYTIB9dwCPAQt2aZQzB77u7tOWKe9frtHna3tyex12/XTWTKO8RH89swS2PwWqxgL3Bg+cdlaPw09KQG3rI3GEt+v5/me2/u1Wo6zl7FR1Q9fhd3gU3nMS57k1U3F/omhJpMq9QbEGHZg2Tug7gsn8wPBFQL3o6rrIx9AVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 09:53:47PM +0000, Alexei Starovoitov wrote:
> On Wed, Oct 21, 2026 at 12:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > hi,
> > we have few use cases where having the ability to allocate normal
> > or executable user space memory would help (like to replace function
> > in live process or change environment variables)
> 
> I think it's better to do what debuggers do:
> vm_mmap() with the final prot and
> access_process_vm(FOLL_FORCE | FOLL_WRITE), like PTRACE_POKETEXT,
> to fill it. It faults the pages in, writes into r-x private mapping
> and copy_to_user_page() takes care of icache.
> Then no need for bpf_user_page_exec(), do_mprotect_pkey_locked(),
> the marker, READ_IMPLIES_EXEC special case, get_user_pages(), etc.
> No mm changes.

great, much better, will use it in next version, thanks

> 
> Like:
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 648abe1..ca1d88d 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -29,6 +29,7 @@
>  #include <linux/task_work.h>
>  #include <linux/irq_work.h>
>  #include <linux/buildid.h>
> +#include <linux/mman.h>
> 
>  #include "../../lib/kstrtox.h"
> 
> @@ -3834,6 +3835,60 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
>  	return ret;
>  }
> 
> +/**
> + * bpf_copy_to_user_task() - Copy data to a task's address space
> + * @unsafe_ptr__ign: Destination address in the task's address space
> + * @src:             Source address, in kernel space
> + * @src__sz:         Number of bytes to copy
> + * @tsk:             The task whose address space will be used
> + * @flags:           Reserved for future use; must be zero
> + *
> + * Faults in the destination and writes the way ptrace(PTRACE_POKETEXT) does:
> + * a private mapping doesn't have to be writable.
> + *
> + * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
> + * fails or is partial.
> + */
> +__bpf_kfunc int bpf_copy_to_user_task(void __user *unsafe_ptr__ign, const void *src,
> +				      u32 src__sz, struct task_struct *tsk, u64 flags)
> +{
> +	int ret;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	if (unlikely(!src__sz))
> +		return 0;
> +
> +	ret = access_process_vm(tsk, (unsigned long)unsafe_ptr__ign, (void *)src,
> +				src__sz, FOLL_FORCE | FOLL_WRITE);
> +	return ret == src__sz ? 0 : -EFAULT;
> +}
> +
> +/**
> + * bpf_user_mmap() - Map private anonymous memory into the current process
> + * @len:  Length of the mapping
> + * @prot: PROT_* flags of mmap(2)
> + *
> + * Return: The address of the mapping on success, or a negative error code.
> + */
> +__bpf_kfunc long bpf_user_mmap(unsigned long len, unsigned long prot)
> +{
> +	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> +}
> +
> +/**
> + * bpf_user_munmap() - Unmap a range of addresses of the current process
> + * @addr: Start of the range
> + * @len:  Length of the range
> + *
> + * Return: 0 on success, or a negative error code.
> + */
> +__bpf_kfunc int bpf_user_munmap(unsigned long addr, unsigned long len)
> +{
> +	return vm_munmap(addr, len);
> +}
> +
>  /* Keep unsigned long in prototype so that kfunc is usable when emitted to
>   * vmlinux.h in BPF programs directly, but note that while in BPF prog, the
>   * unsigned long always points to 8-byte region on stack, the kernel may only
> @@ -5139,6 +5194,25 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
>  	.set   = &generic_btf_ids,
>  };
> 
> +BTF_KFUNCS_START(user_mem_btf_ids)
> +BTF_ID_FLAGS(func, bpf_copy_to_user_task, KF_SLEEPABLE | KF_PERFMON)
> +BTF_ID_FLAGS(func, bpf_user_mmap, KF_SLEEPABLE | KF_PERFMON)
> +BTF_ID_FLAGS(func, bpf_user_munmap, KF_SLEEPABLE | KF_PERFMON)
> +BTF_KFUNCS_END(user_mem_btf_ids)
> +
> +static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
> +{
> +	if (!btf_id_set8_contains(&user_mem_btf_ids, kfunc_id))
> +		return 0;
> +	return security_locked_down(LOCKDOWN_BPF_WRITE_USER);

ah right.. all of those kfuncs should be behing write_user lockdown

> +}
> +
> +static const struct btf_kfunc_id_set user_mem_kfunc_set = {
> +	.owner  = THIS_MODULE,
> +	.set    = &user_mem_btf_ids,
> +	.filter = user_mem_kfunc_filter,
> +};
> +
>  BTF_ID_LIST(generic_dtor_ids)
>  BTF_ID(struct, task_struct)
>  BTF_ID(func, bpf_task_release_dtor)
> @@ -5266,6 +5340,8 @@ static int __init kfunc_init(void)
>  	};
> 
>  	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc_set);
> +	/* Sleepable kprobe prog can only be attached to uprobe */
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_KPROBE, &user_mem_kfunc_set);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &generic_kfunc_set);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &generic_kfunc_set);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);
> 
> But I'm not at all sure that it's a good idea
> to inject code into a process.

well FWIW it's still guarded with the LOCKDOWN_BPF_WRITE_USER same as
bpf_probe_write_user helper

at the moment we have fragile way of live patching a userspace process,
this would give us a more direct and reliable way for that

thanks,
jirka

