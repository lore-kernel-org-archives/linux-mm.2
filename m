Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B40D111A8
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 01:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134A86B000D; Thu, 27 Nov 2025 20:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CB36B000E; Thu, 27 Nov 2025 20:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048876B0023; Thu, 27 Nov 2025 20:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E71E96B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:19:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 798E258677
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:19:07 +0000 (UTC)
X-FDA: 84158257134.19.FA4BB9B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DC6220007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:19:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764292745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHerJEJRO41BGzc3CYRRZvFGZiEOgzzA0n01wZ6r51Y=;
	b=KlizcAPc5U1n4k70+/qfmTslAto/IiDOToFG9niooD4FRvs5sE6sEqIIQtWiYWBGTlkJHu
	K192DRkbcHzgOwxCW4Cs7yTr2sWzZ6K2zTUth7pGzUW+LqMuEaADsgcOg/HOaP26i1o8if
	walqR7Lcbky0hn1iTySx2tuad8HX7Rs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764292745; a=rsa-sha256;
	cv=none;
	b=vn2zG5mjnXLuLLIz9z4qdZUzlE0wjiDEiSABy1WVcftvmXb/RxUOxndO6tuCdQgY/aakds
	+8i15Y9XMFbtsE2dRloPXFR/5YRDTvxgCTcF7qSTanpPCbDJ9PfyGwaRwYYdziAk+A4LkK
	v9Owb2zPZuBp5UUJa9Y3MheF8Pm8UP0=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dHb5k5LfbzKHMPm
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:18:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id CB66F1A018D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:18:59 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgCHMXiC+ChptwYJCQ--.54954S3;
	Fri, 28 Nov 2025 09:18:59 +0800 (CST)
Message-ID: <39d99c56-3c2f-46bd-933f-2aef69d169f3@huaweicloud.com>
Date: Fri, 28 Nov 2025 09:18:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Will Deacon <will@kernel.org>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
 <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHMXiC+ChptwYJCQ--.54954S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWkXryxArykAFWDKF1xXwb_yoW3Jr18pr
	18Ca4UJFW5Wr1rA3yjqw1DJFy8J3WUJw4UWr1UtF1UZr47Xr1jqr40q3yF934UXr48Xw4U
	Xr15Jr17Zr1UJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 8DC6220007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1g8i5f4r98g4ia4x8ez5h5nc3z1ey4ka
X-HE-Tag: 1764292744-852333
X-HE-Meta: U2FsdGVkX1/rr8VPVN3OXmwKYUe0qtPmReu52C0AFszO+TIkOQV2a5wDEWkLlaxaOPOGX/tNLYuU0mxM6nvatrlFZoVPxTAdRMTORfrqHuFBUV7pXumOMKx+dFBVDEw1zP3i3M39R58UOuHiFATUWzgdK2bBxGvEfa1VC4beDO9dYtcKh7HTKh1IhXO+DHN0geGK5a/qTwcu8nHGyeOQ3dbn3N8Txg8RamcC5SWnEXWUt+NZOLT3N9+uDL2fBT5+NTz5W/7xDSZPCzfO7/QWdn6vf77qk/VO1btmK0y4dQd6h7MdaJ+DNxmP9mXkWTY61h5D/AWl0uRhe03OtuctNL14mrzAyD8OR6Dau3TAkKvvOFNqGg08shtC3rvruH+5vKY/5kTWHwKO/SvJfWtOVIlvhEDETwfY8GTrELrvlsmgPB8YOlzFrHWw3UYtnp2NdXKOtq5NwqMkRBMu47aslfKFIDEuSLkjNfUpB2raUZm/nM9lpkjlViIx+n9XoX/eCYXi282fGdPVjzEAOy+30p6juYoRjTzu8wPocCB9grURhj4SQknWdIXG1awUYfpisGqw9dwvokWOj8vOIfBPudt0NRwl1sXjT418OGXlfheWYMotPu4wKifM7+fgT0tAYPHI3E8K4mVTRZJcAd9X82NBzL5ZCn0VeaYAnqnsnXuJbm6HmwReqSTqnYcujDcH2yWMRfvAnrotBGxqx9PfbquWsKbI0T6YyF+A+fiq0unWtwN6F+GNHkbhZfcYcDUrYRULgzQSGksc4qNgam6Iibs2kCKQxZxk5FshjqsydJxmXO1xzUQCpz1PpTebmi5CWRYYFGG+4qLF5Ie4j4rNWph/Gki7VBYC6xsQ+o2q4amXYYxGqoqLOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/28 9:17, Zizhi Wo 写道:
> 
> 
> 在 2025/11/27 20:59, Will Deacon 写道:
>> On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
>>> We're running into the following issue on an ARM32 platform with the 
>>> linux
>>> 5.10 kernel:
>>>
>>> [<c0300b78>] (__dabt_svc) from [<c0529cb8>] 
>>> (link_path_walk.part.7+0x108/0x45c)
>>> [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>] 
>>> (path_openat+0xc4/0x10ec)
>>> [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
>>> [<c052cf90>] (do_filp_open) from [<c0511e4c>] 
>>> (do_sys_openat2+0x418/0x528)
>>> [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
>>> [<c0513d98>] (do_sys_open) from [<c03000c0>] (ret_fast_syscall+0x0/0x58)
>>> ...
>>> [<c0315e34>] (unwind_backtrace) from [<c030f2b0>] (show_stack+0x20/0x24)
>>> [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
>>> [<c14239f4>] (dump_stack) from [<c038d188>] (___might_sleep+0x19c/0x1e4)
>>> [<c038d188>] (___might_sleep) from [<c031b6fc>] 
>>> (do_page_fault+0x2f8/0x51c)
>>> [<c031b6fc>] (do_page_fault) from [<c031bb44>] (do_DataAbort+0x90/0x118)
>>> [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
>>> ...
>>>
>>> During the execution of hash_name()->load_unaligned_zeropad(), a 
>>> potential
>>> memory access beyond the PAGE boundary may occur. For example, when the
>>> filename length is near the PAGE_SIZE boundary. This triggers a page 
>>> fault,
>>> which leads to a call to do_page_fault()->mmap_read_trylock(). If we 
>>> can't
>>> acquire the lock, we have to fall back to the mmap_read_lock() path, 
>>> which
>>> calls might_sleep(). This breaks RCU semantics because path lookup 
>>> occurs
>>> under an RCU read-side critical section. In linux-mainline, arm/arm64
>>> do_page_fault() still has this problem:
>>>
>>> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
>>>
>>> And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
>>> dcache name comparison and hashing"), hash_name accessed the name 
>>> byte by
>>> byte.
>>>
>>> To prevent load_unaligned_zeropad() from accessing beyond the valid 
>>> memory
>>> region, we would need to intercept such cases beforehand? But doing so
>>> would require replicating the internal logic of 
>>> load_unaligned_zeropad(),
>>> including handling endianness and constructing the correct value 
>>> manually.
>>> Given that load_unaligned_zeropad() is used in many places across the
>>> kernel, we currently haven't found a good solution to address this 
>>> cleanly.
>>>
>>> What would be the recommended way to handle this situation? Would
>>> appreciate any feedback and guidance from the community. Thanks!
>>
>> Does it help if you bodge the translation fault handler along the lines
>> of the untested diff below?
> 
> Thank you for the solution you provided. However, I seem to have
> encountered a bit of a problem.
> 
>>
>> Will
>>
>> --->8
>>
>> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
>> index bf1577216ffa..b3c81e448798 100644
>> --- a/arch/arm/mm/fault.c
>> +++ b/arch/arm/mm/fault.c
>> @@ -407,7 +407,7 @@ do_translation_fault(unsigned long addr, unsigned 
>> int fsr,
>>          if (addr < TASK_SIZE)
>>                  return do_page_fault(addr, fsr, regs);
>> -       if (user_mode(regs))
>> +       if (user_mode(regs) || fsr_fs(fsr) == FSR_FS_INVALID_PAGE)
>>                  goto bad_area;
> 
> 
> 
> I'm getting an "FSR_FS_INVALID_PAGE undeclared" error during
> compilation...
> 
> In which kernel or FSR version was this macro or constant defined

Sorry, I didn't see this "#define FSR_FS_INVALID_PAGE". I'll try again
right away.

Please ignore my previous reply.

> 
>>          index = pgd_index(addr);
>> diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
>> index 9ecc2097a87a..8fb26f85e361 100644
>> --- a/arch/arm/mm/fault.h
>> +++ b/arch/arm/mm/fault.h
>> @@ -12,6 +12,8 @@
>>   #define FSR_FS3_0              (15)
>>   #define FSR_FS5_0              (0x3f)
>> +#define FSR_FS_INVALID_PAGE    7
>> +
>>   #ifdef CONFIG_ARM_LPAE
>>   #define FSR_FS_AEA             17
>> diff --git a/arch/arm/mm/fsr-2level.c b/arch/arm/mm/fsr-2level.c
>> index f2be95197265..c7060da345df 100644
>> --- a/arch/arm/mm/fsr-2level.c
>> +++ b/arch/arm/mm/fsr-2level.c
>> @@ -11,7 +11,7 @@ static struct fsr_info fsr_info[] = {
>>          { do_bad,               SIGBUS,  0,             "external 
>> abort on linefetch"      },
>>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "section 
>> translation fault"        },
>>          { do_bad,               SIGBUS,  0,             "external 
>> abort on linefetch"      },
>> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page 
>> translation fault"           },
>> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page 
>> translation fault"           },
>>          { do_bad,               SIGBUS,  0,             "external 
>> abort on non-linefetch"  },
>>          { do_bad,               SIGSEGV, SEGV_ACCERR,   "section 
>> domain fault"             },
>>          { do_bad,               SIGBUS,  0,             "external 
>> abort on non-linefetch"  },
>> diff --git a/arch/arm/mm/fsr-3level.c b/arch/arm/mm/fsr-3level.c
>> index d0ae2963656a..19df4af828bd 100644
>> --- a/arch/arm/mm/fsr-3level.c
>> +++ b/arch/arm/mm/fsr-3level.c
>> @@ -7,7 +7,7 @@ static struct fsr_info fsr_info[] = {
>>          { do_bad,               SIGBUS,  0,             "reserved 
>> translation fault"    },
>>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 1 
>> translation fault"     },
>>          { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 2 
>> translation fault"     },
>> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "level 3 
>> translation fault"     },
>> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "level 3 
>> translation fault"     },
>>          { do_bad,               SIGBUS,  0,             "reserved 
>> access flag fault"    },
>>          { do_bad,               SIGSEGV, SEGV_ACCERR,   "level 1 
>> access flag fault"     },
>>          { do_page_fault,        SIGSEGV, SEGV_ACCERR,   "level 2 
>> access flag fault"     },
>>
>>
> 
> By the way, I tried Al's solution, and this problem didn't reproduce.
> 
> Thanks,
> Zizhi Wo


