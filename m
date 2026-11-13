Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1387360A2621
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z8JlYKSU
Received: by kanga.kvack.org (Postfix)
	id 380046B00EF; Fri, 13 Nov 2026 08:42:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331326B05B1; Fri, 13 Nov 2026 08:42:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FDB6B05B2; Fri, 13 Nov 2026 08:42:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF1386B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:42:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D1FEC02A7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:42:07 +0000 (UTC)
X-FDA: 85430209494.07.B33BB8D
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8BB60A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:42:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z8JlYKSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alitariq45892@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alitariq45892@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794577325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oyo60OYFmXZXL90Hj9PED7vL+lEsAHp4eJo0r71AKr0=;
	b=a87XG+XgOO/c8vMWuOtVtTqAm3FvTobmnEf/+KCKj9JeFb+xmX67lms+BLom3l6K+tPP/e
	ajk8f/W6wvlwYmNUEPnqC55cKdkS8zGHU0nG/ghliPSANe/FKgQDEBp2k16QnCfUSnYK1a
	uhWfU3xtvjDgt0tdYSOVOngr//w7wtE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z8JlYKSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alitariq45892@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alitariq45892@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794577325;
	b=4MLZWLYMqPZg/q88UpjY8L8tPCadN0FIGfVDIX3li3+kOFIYPVvHgYkGTOZ0sUIUKYwPB/
	vBVDvd76NOzusjnUFbYVK2fxT9dtP8Iv8kxt7g7Yx58F5tKHfgjwufMuMryhDA6cUEbBKV
	m6sBra0bZBMlsTKB/+bUoQKB5V4rg2c=
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b76ade741cso3203675e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794577324; x=1795182124; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oyo60OYFmXZXL90Hj9PED7vL+lEsAHp4eJo0r71AKr0=;
        b=z8JlYKSU+mXPd9FpLoRWTNsrmt1OkeaBayUZGJWbxUk96eQ0H/oyYWOYDa8qy4a8bd
         DAxtUFo7PNtgsjyMKJY9mXrIVKDfHmouFDI/otqgN9l/ea/XV3Mdryz5JZOzZSQLdAA8
         suYNd7JGSe7Vh74bRfDjYdCw6Xe6cL1yeOYwIaKjVO0rQv6tbt5Nxp/pPtXi64Z/h8k6
         Ht9k31tUc8T6WaNMSUj6jEIbTcVBj59fl56PPf4DFn9S5Wkm/xEwLfnyPxS40aoA+Wa7
         xB+7T9tYtvqAttWJDX1bFAjH8L6QQXOz0ebMe9dgQ5GPR+1sYnvRe+/RtwxxMlqDsCFA
         Wu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794577324; x=1795182124;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oyo60OYFmXZXL90Hj9PED7vL+lEsAHp4eJo0r71AKr0=;
        b=DnaE2lZpkYMMjg06CPe4LFGVFYuqJBCBKgiXbkdBRSufS0ZRg9k5WvoQmXsYCinjlE
         FZQs+OsYZTy9pn5eQoxaeYKhP7neexSxMAfqFTlyMdYQ3WQZnCiRanw6uEVI1Ds9Iuw0
         LSmZQe6InNpPGRA/tXrK2fWNLws6T3Kmn1dON2o1P/15wTfHjaA8DNqhAHBjWZiGrVzj
         Q6Y12ojm8TwtYkycRbOGI/AKggu00I0/flBJDOLDw2+LtAitAYfBdIxadLipE8xiGFXT
         4Ke9O7hVd90IBk13sA4HpA7MhCW/8xMW+E9kSiFTSprQSu/6J4E4Dsvq0vfZhJzj7wza
         E7Zg==
X-Forwarded-Encrypted: i=1; AL+hErEULl56spSGLqOUt4jE41ycUHairxtqPHs7vDkf3B4CrzuVUtAmDgjPbmf/K2AnM7aekOUX9FKK6A==@kvack.org
X-Gm-Message-State: APuU4Z/+xKMUc4Ju3YkOz1f/cWW8BB5YVHyI36T4BAD4NtOSv1RypChv
	V07wEZTQMDD06RCaWpvezIrC9VMQEfjWPTzSvgQr0jIa9Pv20MoxDHiV
X-Gm-Gg: AYBFou1fhJV4sKcVQsrhQhFnDt920kYvGISNlmvG6PuppoM8ac5051uoTi1OWDEPWMx
	6E0/UEucKsNouzdzoXPM36Ig7096gsr+ZwfVK4utPFgcO1rGuwSeLPBAvGfnFBIrPd02cBpR9L4
	e9oc5wmYuxl/BpbOGWh7dqVjegEq/vpkiU9jj0ZEKpYF0ecQMClEqRPJVr1zoGb+wQCNHuL6pmT
	VhAk5AXWfHiM4bkG9uKAgrLu4ZpDCfuv0GPe8BAajvW2rfaqoGOc0aho0fgEskhwA9oJ2kk/IkR
	A2zKDzxFFNCBsPGE0xaPif6MD+UD5uccwioDGwivhad/1kIldR4jieL2IK8oZoHZdOugfy+O+MA
	COuE+S6W77UACCh84qaMaU5nNHVvr6MCcvazMwrvGmVkM5qGV2sKbuVXlShDlljP14RhoQrK9oN
	utD+nzOgsebIwQbo0siOQ5wbgYF4edQ1K7sF9ad3DzoAHZ1qxfwUne/N6OtVrMGybwWiuefOLOi
	USRSOjeMEqDu2SPkg7eYEnPzZSQIdfgB2vHoJaLTrG/N2U8XAUZVoIByz8dMlelF4t5jiZMWIuE
	oecpmGeCz47+ODNdhr7m2FzjxRjcEJuQTOwCp85vZkb5BebBlGa3Qm7Z3so=
X-Received: by 2002:a05:600c:4e56:b0:4ac:aae6:6400 with SMTP id 5b1f17b1804b1-4bb55a48042mr52996795e9.13.1794577323783;
        Fri, 13 Nov 2026 05:42:03 -0800 (PST)
Received: from [192.168.100.182] ([45.249.9.114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm5085715f8f.21.2026.11.13.05.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 05:42:02 -0800 (PST)
Message-ID: <5ccd1e39-94f0-4e02-87d2-aae8985d1b12@gmail.com>
Date: Fri, 13 Nov 2026 18:41:58 +0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] riscv: mm: Add KASAN shadow mapping to flush_cache_vmap()
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Vivian Wang <wangruikang@iscas.ac.cn>,
 Yunhui Cui <cuiyunhui@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261102134422.610837-1-alitariq45892@gmail.com>
Content-Language: en-US
From: Ali Tariq <alitariq45892@gmail.com>
In-Reply-To: <20261102134422.610837-1-alitariq45892@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8BB60A0002
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 63ifmhimgb6ap995behz4st9xdkfpkqp
X-HE-Tag: 1794577325-463933
X-HE-Meta: U2FsdGVkX19zCbzSEZ7tbA61a+eA7KwEHDZsRFOnx58/UEnYiJMa/6T1cLr3lraOlHN8GfsUCVwpDKmWH+//o7ytnOuPDaA/GCIjBwpn4ATXxG6mDEjgFcGS4Boj4z698ZU0sTLUnyCZBVjuC0+R9KW8AmSfHHTjRtIrTPkkIdEVwWk2hX4+PbY2+JxUjs2CeFpEqqI3e593ACJJanyu0GoqF/q3b7eb49dmS89PIJC8cfLBRy4oARPcgoqAfzRuACpSX0RavnMZ6Pq+RY+qsbGzcHE0qsLLgByjRONO+cXZ8Ikfa1ZdfqdFkHDi7U1Rm13uKp0cMYdaANeycIxyXJckrmMwA8JC4R9T3h8oSCr/XDiF9a3HahX65lU/fPQm/roIR55JzC3F/m4uva5Hfw1kD8NH92UdmT564zH71RcX8PSaixXBliyMUWqlQa+kI2isf+o38AgtvzN+pKKvt7eJgZz7lMeDl4qaqFwBq2AYFC7LiH1CAkSMcQGcRKD4dQdTg/+Gpi2aucB1JquZRFRaUq72u8vwuQYDjdTkOw3ppOR0iKJdKrX+okrS7C5Q1zduXJiAEMcSKGYKr/SSXuUrnAeW+zM7C1fkACaC1I4AaoUNgrhzu3RPTbqk2zKwCL86cK+qAzhslk2SUr10dCDZ+O3B92GHvRPt7U40zRqJ2B3tdXgn6xpY0SpqNIufmrHlczJLqIqCoyQHZIvFs5CX6FfGw7gYhs7lfnmvwR95KKRKQx0DfrkNEv6nMsYQcSji6OYRQ7LFh2ooxAIjxxMqlCIMp70S4Hx/t2T06Q7BzDGtp9rXG9aBgeeWPh/rc0hs8Qo7kQ3NeS7FwIa3f7p7zTKKcn5vSUD7hwsGxVtucM2WQm3Cw2ifW6/lGd9M7ATGU0FJ7mvOmt9qWokUsY+lW2RaJvUrdzgxg+HNAGjG5Mgb+kcXjIcFTCA+UOvhJNUpVB00hT7InjaD7di
 8QkUSw9y
 7WKS84wJ+Rgw/qktNHN1uwYB1aV5whGOhWBtfSsqvNI55Y8fsz3zoCSeRu6OPfg+NIVbIeHH6JjT4bSL+KcxorF+vOsnfw9fDiBvxXLFPau1F46AC3ymHE1BCTi8r8vE+pMFi6bDsne+XWySWjyiQtp2cavKw3V1yv5RXF/N48gkzj65AmXBwjl7LlZ0bW/FcEUw/Pdf8DBUJwnuuwNsTI4Q5I9Hm4klUOuGnmhDiFKso8yPVMnR/YEl2sH6AVnhQG1Hh15IigKq51DEJEdvKfzMBq4ny4IMB62Vg0y9Ap717fSjX+DUVtlhHrsebb+zb94ZykqNjKSjS11O2+VxkbFgMooMWW33/Fpg98fy6SKNKN6/d7DInMNfyg9iR28GZXqa7luASfiqUDLQ4RVklcM55f/ZvFrSQteCQx8fWrfdzPaL7NyrYS+j5A0Eu2c05Zl/LBzNadFK7QlfZshyoStYtZ4gqYwsWQO7HXOE5giC/DwpgaPa9YeEM2tZVFzrF++uorZuQo1LTTX3DHl9/oaQaGEw6RJ9upGXvMu9UqjuMf7Eavj99kWUBWMKupqZmz0fVPwN2uhf03FFxG0OONRavELmP/phVThm30z9Oy4YJTlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Gentle ping on this fix. Muchun has acked it. It fixes a boot crash on
riscv KASAN kernels (2 of 30 boots on Orange Pi RV2). Could it go in 
through the riscv fixes branch?

Thanks,
Ali Tariq

On 11/2/26 6:44 PM, Ali Tariq wrote:
> flush_cache_vmap() sets a per-CPU flag, and a kernel page fault
> that finds the flag set gets an sfence.vma and a retry.
> flush_cache_vmap() only sets the flag for vmalloc, module and vmemmap
> ranges. kasan_populate_vmalloc() maps new shadow pages and calls
> flush_cache_vmap() on the shadow range, so no flag gets set.
> For vmap()-style areas, kasan_unpoison_vmalloc() writes
> the new shadow right away. If the CPU hasn’t seen the new entry yet,
> the store faults, and since there is no flag set, the kernel crashes.
> 
> [    0.675216] Unable to handle kernel paging request at virtual address fffffff7c009a000
> Current swapper/0 pgtable: 4K pagesize, 39-bit VAs, pgdp=0x0000000004504000
> [fffffff7c009a000] pgd=000000009ff6e001, p4d=000000009ff6e001, pud=000000009ff6e001, pmd=00000000400e7401, pte=00000000403cb0e7
> status: 0000000200000120 badaddr: fffffff7c009a000 cause: 000000000000000f
> __memset+0x60/0xfe
> kasan_unpoison+0x26/0x4e
> __kasan_unpoison_vmalloc+0x20/0x2e
> __get_vm_area_node+0x1c6/0x276
> get_vm_area_caller+0x52/0x84
> vmap+0xf0/0x264
> dma_common_contiguous_remap+0xa0/0xd0
> atomic_pool_expand+0xb6/0x310
> __dma_atomic_pool_init.isra.0+0xf6/0x1c0
> dma_atomic_pool_init+0xf6/0x1aa
> do_one_initcall+0x134/0x928
> kernel_init_freeable+0x532/0x60a
> kernel_init+0x28/0x162
> ret_from_fork_kernel+0x82/0x94c
> ret_from_fork_kernel_asm+0x16/0x18
> 
> The PTE is valid, so the mapping was in place when the CPU faulted.
> 
> Tested on Orange Pi RV2: without this patch 2 of 30 boots crashed,
> with it 50 of 50 booted.
> 
> Add the KASAN shadow region to the ranges for which flush_cache_vmap()
> calls mark_new_valid_map(), as commit 4edd70ee6a7d ("mm/sparse-vmemmap:
> flush_cache_vmap() after hotplugging vmemmap") did for vmemmap.
> 
> Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
> Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
> ---
> Crash Log: https://kernelci.cloud-v.co/scheduler/job/541
> ---
>   arch/riscv/include/asm/cacheflush.h | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
> index c2b0a2928f06..c95b2f6007fd 100644
> --- a/arch/riscv/include/asm/cacheflush.h
> +++ b/arch/riscv/include/asm/cacheflush.h
> @@ -8,6 +8,8 @@
>   
>   #include <linux/mm.h>
>   
> +#include <asm/kasan.h>
> +
>   static inline void local_flush_icache_all(void)
>   {
>   	asm volatile ("fence.i" ::: "memory");
> @@ -57,7 +59,9 @@ static inline void mark_new_valid_map(void)
>   static inline void flush_cache_vmap(unsigned long start, unsigned long end)
>   {
>   	if (is_vmalloc_or_module_addr((void *)start) ||
> -	    (start >= VMEMMAP_START && end <= VMEMMAP_END))
> +	    (start >= VMEMMAP_START && end <= VMEMMAP_END) ||
> +	    (IS_ENABLED(CONFIG_KASAN) &&
> +	     start >= KASAN_SHADOW_START && end <= KASAN_SHADOW_END))
>   		mark_new_valid_map();
>   }
>   #define flush_cache_vmap_early(start, end)	local_flush_tlb_kernel_range(start, end)


