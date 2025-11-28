Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D13CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 01:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E9A6B0022; Thu, 27 Nov 2025 20:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045816B0023; Thu, 27 Nov 2025 20:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4AB6B0029; Thu, 27 Nov 2025 20:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBEBB6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:17:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A52788BBB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:17:26 +0000 (UTC)
X-FDA: 84158252892.16.49CF5B5
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CE15100008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:17:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764292644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+3KZoa4eB0lXlCRXWilBy94mb50xgSMYtNVrzXSsD8=;
	b=sGqwo46Y+qHySbsFuvtg6hIIjb2WKDRfzNVDbn2A0MAzoH/KxdzbwRw68nxkIH70xBxOaL
	/SFQ+B18tpQjuR0a+UU/b9COfobSOvb3Ss68D2TMNH5dbW7QiwsffEUFDSVBtKIFzpMYoL
	EJPWwNDrtoTVJaS2U5S96wCasi7PnS4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764292644; a=rsa-sha256;
	cv=none;
	b=DanEqkJclapdmQYAgnpBV9I3Q+lEgIK7PH1tIWvCiJMnzn8TACNCPq4PLXREbJ6n7M5T+W
	Rkzwb525Jva9LNAdw8LZXhrD3sNtneigVvPB7BXhEGROkmaSpVzfDyZn0JtXYsWwPcC2T4
	/OWAJC+0Rk4raJDdnz9TdOP14A9UXVE=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dHb3j33NHzKHMPw
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:16:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 78F8D1A0ABE
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:17:14 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgBHpXsY+ChphOEICQ--.36213S3;
	Fri, 28 Nov 2025 09:17:14 +0800 (CST)
Message-ID: <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
Date: Fri, 28 Nov 2025 09:17:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Will Deacon <will@kernel.org>, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <aShLKpTBr9akSuUG@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHpXsY+ChphOEICQ--.36213S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WryrWw45uw1fKw17tw4rAFb_yoW7Zr18pr
	Wjk3W2krZIgrWak3yIqanxWFyrJa4Iqr4UGr9rGr1kuw47Xryjga1kK39Yk347Xw1kW3yF
	vr4Fvr1Uuw1DC3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 9CE15100008
X-Rspamd-Server: rspam02
X-Stat-Signature: 6xyrenhos78wxzezhzfme1aiezip1ync
X-Rspam-User: 
X-HE-Tag: 1764292639-403155
X-HE-Meta: U2FsdGVkX1/iNEynwYaCa3F6iWo6rwr/njld6ZK1zDjdWSysP33YywWebqi0BlNcgGr3xgV80b+e5Ycw+w0A32Lbx76wlAsKvVx4OOrtuFkLjmwU9ja9+7qResnskza1gDKx63ZlcHsVNb0TIVs3rB5COA/5odudMbCoVDIxLQ0JNVw3GsC2Cv8o9GETQX/Jro1ipev5w1hu8dUFt7g0NAxR61FMh1Xg5VMm8Bsr0Y2EVwSz8BuKQyJFoUyjC1b1pHyEIz36fNJ7jxHKGiw0zllU059llGctiAG4xuKUFiElTYzqBZr4vzCgNvWIl9k9AubpYa4/W0GZCacNSzn8pKO+cPgn3Hx8IuoqSY4YlWTMXnyPkKGg5mFIfT7/Qn8q7SmCOMWUAM1vqyoXyoe+bCgxWXO92jj2o+Wa0aWi20JUDuZU8K7gwmQlG4s7CRV9MTGAXb0/QbjI2x1AaDfjtSA7O8LM3rVMC4PW4O9LkkBALiBFOqkSaLlMz+3P/Lh4c93ED3oj7RXopnDnBF3YcHM6rc+TptaUgtJQ4HFE2xWULA4l+KhIMw5jWTaSHdsHM7IkSn21SzCuhT0uy67yC+Et9H1gVPT5kv2rJ7p4T3NrcBA16gM8+KWngdeb00VWk+14sYQYVtt4qDt4l31Y5pCXG+M3EnyYW9vIHmPPOxkX5wJQPo/gyMlMfztB1KcdJp0zDb7kkXXl+85370xnY0RCAtVeivGnveeKudhPCXBTFhhLiqux/t1ab2rELNTm8Y/+AdCyTyKpYGGrYaBoJFACiZDFnKNyKl4vEfSASloN9DsgVE4j98AgfBwYvxhnDgU0JOYfu/cV98hkD8c3m9GC5WkA14tOagDqfXVt5dAc6YGZS2nS9WoO1eTnJ8K6dzBh9camei79MXxM1+ZEWtE0RBufpFt8M3y8qjq+CtlekQsUqQOAjERgvdTN7Qya9dq6sCGDJ0jgH4qjsT7
 7Z3Z0BsE
 mRSKtbuvf7OEOvw9gsTziD+llSG047qgjhEehI3Lr9rsCUa5NBhb5S+l3ahaFg6wKQK371TIs8P6WORdq4OfgCOOyr/j1DVvYwBnFWj6zHyLnnJIU3b1d3f77PRNWHuHl8hY+iNYRRq1lQ1pV+jgVt+DMAhRW4SqQ4CGsOx3R8AysPXvdrXnwO38iXmjMPA9hhHpD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/27 20:59, Will Deacon 写道:
> On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
>> We're running into the following issue on an ARM32 platform with the linux
>> 5.10 kernel:
>>
>> [<c0300b78>] (__dabt_svc) from [<c0529cb8>] (link_path_walk.part.7+0x108/0x45c)
>> [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>] (path_openat+0xc4/0x10ec)
>> [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
>> [<c052cf90>] (do_filp_open) from [<c0511e4c>] (do_sys_openat2+0x418/0x528)
>> [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
>> [<c0513d98>] (do_sys_open) from [<c03000c0>] (ret_fast_syscall+0x0/0x58)
>> ...
>> [<c0315e34>] (unwind_backtrace) from [<c030f2b0>] (show_stack+0x20/0x24)
>> [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
>> [<c14239f4>] (dump_stack) from [<c038d188>] (___might_sleep+0x19c/0x1e4)
>> [<c038d188>] (___might_sleep) from [<c031b6fc>] (do_page_fault+0x2f8/0x51c)
>> [<c031b6fc>] (do_page_fault) from [<c031bb44>] (do_DataAbort+0x90/0x118)
>> [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
>> ...
>>
>> During the execution of hash_name()->load_unaligned_zeropad(), a potential
>> memory access beyond the PAGE boundary may occur. For example, when the
>> filename length is near the PAGE_SIZE boundary. This triggers a page fault,
>> which leads to a call to do_page_fault()->mmap_read_trylock(). If we can't
>> acquire the lock, we have to fall back to the mmap_read_lock() path, which
>> calls might_sleep(). This breaks RCU semantics because path lookup occurs
>> under an RCU read-side critical section. In linux-mainline, arm/arm64
>> do_page_fault() still has this problem:
>>
>> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
>>
>> And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
>> dcache name comparison and hashing"), hash_name accessed the name byte by
>> byte.
>>
>> To prevent load_unaligned_zeropad() from accessing beyond the valid memory
>> region, we would need to intercept such cases beforehand? But doing so
>> would require replicating the internal logic of load_unaligned_zeropad(),
>> including handling endianness and constructing the correct value manually.
>> Given that load_unaligned_zeropad() is used in many places across the
>> kernel, we currently haven't found a good solution to address this cleanly.
>>
>> What would be the recommended way to handle this situation? Would
>> appreciate any feedback and guidance from the community. Thanks!
> 
> Does it help if you bodge the translation fault handler along the lines
> of the untested diff below?

Thank you for the solution you provided. However, I seem to have
encountered a bit of a problem.

> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index bf1577216ffa..b3c81e448798 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -407,7 +407,7 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>          if (addr < TASK_SIZE)
>                  return do_page_fault(addr, fsr, regs);
>   
> -       if (user_mode(regs))
> +       if (user_mode(regs) || fsr_fs(fsr) == FSR_FS_INVALID_PAGE)
>                  goto bad_area;



I'm getting an "FSR_FS_INVALID_PAGE undeclared" error during
compilation...

In which kernel or FSR version was this macro or constant defined?

>   
>          index = pgd_index(addr);
> diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
> index 9ecc2097a87a..8fb26f85e361 100644
> --- a/arch/arm/mm/fault.h
> +++ b/arch/arm/mm/fault.h
> @@ -12,6 +12,8 @@
>   #define FSR_FS3_0              (15)
>   #define FSR_FS5_0              (0x3f)
>   
> +#define FSR_FS_INVALID_PAGE    7
> +
>   #ifdef CONFIG_ARM_LPAE
>   #define FSR_FS_AEA             17
>   
> diff --git a/arch/arm/mm/fsr-2level.c b/arch/arm/mm/fsr-2level.c
> index f2be95197265..c7060da345df 100644
> --- a/arch/arm/mm/fsr-2level.c
> +++ b/arch/arm/mm/fsr-2level.c
> @@ -11,7 +11,7 @@ static struct fsr_info fsr_info[] = {
>          { do_bad,               SIGBUS,  0,             "external abort on linefetch"      },
>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "section translation fault"        },
>          { do_bad,               SIGBUS,  0,             "external abort on linefetch"      },
> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page translation fault"           },
> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page translation fault"           },
>          { do_bad,               SIGBUS,  0,             "external abort on non-linefetch"  },
>          { do_bad,               SIGSEGV, SEGV_ACCERR,   "section domain fault"             },
>          { do_bad,               SIGBUS,  0,             "external abort on non-linefetch"  },
> diff --git a/arch/arm/mm/fsr-3level.c b/arch/arm/mm/fsr-3level.c
> index d0ae2963656a..19df4af828bd 100644
> --- a/arch/arm/mm/fsr-3level.c
> +++ b/arch/arm/mm/fsr-3level.c
> @@ -7,7 +7,7 @@ static struct fsr_info fsr_info[] = {
>          { do_bad,               SIGBUS,  0,             "reserved translation fault"    },
>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 1 translation fault"     },
>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 2 translation fault"     },
> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "level 3 translation fault"     },
> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 3 translation fault"     },
>          { do_bad,               SIGBUS,  0,             "reserved access flag fault"    },
>          { do_bad,               SIGSEGV, SEGV_ACCERR,   "level 1 access flag fault"     },
>          { do_page_fault,        SIGSEGV, SEGV_ACCERR,   "level 2 access flag fault"     },
> 
> 

By the way, I tried Al's solution, and this problem didn't reproduce.

Thanks,
Zizhi Wo


