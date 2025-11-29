Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B7FD116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 01:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A666B0007; Fri, 28 Nov 2025 20:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8121A6B0027; Fri, 28 Nov 2025 20:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728D66B002A; Fri, 28 Nov 2025 20:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6167F6B0007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:02:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 079BB50CEF
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:02:35 +0000 (UTC)
X-FDA: 84161844270.26.9C0084A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3C204001E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:02:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764378153; a=rsa-sha256;
	cv=none;
	b=IetN8EzzKfkqjY6griHCKtrMRhvUnk6TO0y3ht1yj7GZgWTm1tfmUhXFhZXQzHHYY4UQNB
	X/Z+d3BGxy4uLSS9XI9ScJz2S4y0cdMiPrftczveR8ITZNKEPZ/0TBE4LiEd3jgN46yw1N
	P2Q/lX+Zt6ZDxOFuoTumI7u2+6VkO3g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764378153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSiBOLVfqVQgGiP36Mkyly6sFLzSygYYuIYJA3xwBSw=;
	b=uFMxOb3NsHHCEV3+BWqv95lyVK7n4n5qkffrih0dinJazPvd3fEicCSEzzTUBJ3N/jfUze
	dKoGU5VkxpiraHJK54glvTvxgTi3LOfqwOMwBsVqizcnmpb/LytPVzY3UBFvAXmQUe+cnm
	BKtx5V48apxrIsbzYGkbK24AMYwHwlo=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dJBgw251SzYQtjb
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:01:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6592D1A13C5
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:02:28 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgBnDnUjRipp2zF8CQ--.32723S3;
	Sat, 29 Nov 2025 09:02:28 +0800 (CST)
Message-ID: <b6e23094-f53f-4242-acb5-881bd304d707@huaweicloud.com>
Date: Sat, 29 Nov 2025 09:02:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Will Deacon <will@kernel.org>, Zizhi Wo <wozizhi@huaweicloud.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux@armlinux.org.uk, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com,
 Al Viro <viro@zeniv.linux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <aShLKpTBr9akSuUG@willie-the-truck>
 <9ff0d134-2c64-4204-bbac-9fdf0867ac46@huaweicloud.com>
 <39d99c56-3c2f-46bd-933f-2aef69d169f3@huaweicloud.com>
 <61757d05-ffce-476d-9b07-88332e5db1b9@huaweicloud.com>
 <aSmUnZZATTn3JD7m@willie-the-truck>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <aSmUnZZATTn3JD7m@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnDnUjRipp2zF8CQ--.32723S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF13JrWruw43Jr17Xw1UWrg_yoW7JFyDpr
	W5GFyYkrsxXry3Aw1vgw1YgFyFyw1UJr45Xrnxtr18uw1qgF13XF4UtrWDCryDur1kWw4U
	WrWYq3srZa4DtFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjTRRBT5DUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3C204001E
X-Stat-Signature: z63a9xfi86pgrpwydfep5ftinpag8aij
X-Rspam-User: 
X-HE-Tag: 1764378151-877334
X-HE-Meta: U2FsdGVkX1/MvFnd7pUl7EHKSk4G2jSm71KlRqoc5hqYD4MATQKK6Y0NWYoLL6ARIHkiSZSioRsU34uPcfY4DmG7m0XtB5d1yg26XjKUSUNKltVH1AFxKPhba+RtOEpAYsqSkBPYGsDN9eF4xKhevBikS570yyvDY4Q6xyNfpRswxUhQNAizq/UxPW1mYKgEIfAt+3HOT7nAkRhXQfqCLdZsDNdfJ3SGrsR6Y5WsuMoWu760SmAhug6GgZDjUYgEv9vjHQN29uiazJTCM66QyG/rGOPr7zs5IxiGPhNxV04g5Cnd9/jIHpwypwfs53sCB8uNK95jfs/1KGBEr1DsbhnpfD4Rmr0973ufkXZjpVurRb5FXuMJ09+d/4RnTFGIPxe+Ye0Sk03tl+jRItwjZaeeLZtJPwKweL6hZYghaqhGBRj5s3UUesHOff7kuswT9RBTO22v09rRdGa9qW7/64VS54Ptsu8aIcM6dS9a9ETTi46iFyqXTbcyPM+8IfCYYM7DJ/velcZJyF3Pef2fDU/zciEEgVC3mlxWxyFjUozYKj4CpFFLu9DdYFyjCO/dj1oohm2XzHlRCyQB/qXv7zsfLFI8chzutcOwNLVTlXYYYmXiF0WeJXrUHz/EiuOGdw556nDxP8IsWCdTVS5OfjXXIR31oEyX85Y9hE81HH1adlZMFOi/kyWNTnjviBW9mwKaEw6t+G65y6MsBoPSSUwkj7fgcVrh8kEBnNOyncw+kLJHLNrxmfvORp0l72gMVjIMvs5yZG4+WevXGjCiJT9E30gsgpQH2wGysaC8MYO3T0jfptZsavbHdtuH+H+J/MbF1/gfXSIcrKJEEvqPcamsecsF0HqcUXDbSib4d9JtthRAuBZJ01OJM0PHD3vru+yJMfcelzE+9ojgePzJCMch/yJ8NpNPMdIsngZMK5tu/OjyiMOC1reLTUkZ5Z3Cs4rRmQAwiemREmWxJaO
 XHG2+E0F
 BaoGRuNjsyYGRMWErBa0f5MOIbjoc026nQmnqKwkQNhrvXy+n2Y93H/kODB9dhsgQR8GIbGBmJpmGDolDbQUFYAYkUO7ZSctsWFI97wZgnh5VUd6CmkQW9VefOSeebjWVvL7yYlc6GDvFdQ6iM6CxwwmxpfMxaGHhZ9uy8hZAtKgRepwqchwDplZ8Wx3x+VTmP/TQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/28 20:25, Will Deacon 写道:
> On Fri, Nov 28, 2025 at 09:39:45AM +0800, Zizhi Wo wrote:
>> 在 2025/11/28 9:18, Zizhi Wo 写道:
>>> 在 2025/11/28 9:17, Zizhi Wo 写道:
>>>> 在 2025/11/27 20:59, Will Deacon 写道:
>>>>> On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:
>>>>>> We're running into the following issue on an ARM32 platform
>>>>>> with the linux
>>>>>> 5.10 kernel:
>>>>>>
>>>>>> [<c0300b78>] (__dabt_svc) from [<c0529cb8>]
>>>>>> (link_path_walk.part.7+0x108/0x45c)
>>>>>> [<c0529cb8>] (link_path_walk.part.7) from [<c052a948>]
>>>>>> (path_openat+0xc4/0x10ec)
>>>>>> [<c052a948>] (path_openat) from [<c052cf90>] (do_filp_open+0x9c/0x114)
>>>>>> [<c052cf90>] (do_filp_open) from [<c0511e4c>]
>>>>>> (do_sys_openat2+0x418/0x528)
>>>>>> [<c0511e4c>] (do_sys_openat2) from [<c0513d98>] (do_sys_open+0x88/0xe4)
>>>>>> [<c0513d98>] (do_sys_open) from [<c03000c0>]
>>>>>> (ret_fast_syscall+0x0/0x58)
>>>>>> ...
>>>>>> [<c0315e34>] (unwind_backtrace) from [<c030f2b0>]
>>>>>> (show_stack+0x20/0x24)
>>>>>> [<c030f2b0>] (show_stack) from [<c14239f4>] (dump_stack+0xd8/0xf8)
>>>>>> [<c14239f4>] (dump_stack) from [<c038d188>]
>>>>>> (___might_sleep+0x19c/0x1e4)
>>>>>> [<c038d188>] (___might_sleep) from [<c031b6fc>]
>>>>>> (do_page_fault+0x2f8/0x51c)
>>>>>> [<c031b6fc>] (do_page_fault) from [<c031bb44>]
>>>>>> (do_DataAbort+0x90/0x118)
>>>>>> [<c031bb44>] (do_DataAbort) from [<c0300b78>] (__dabt_svc+0x58/0x80)
>>>>>> ...
>>>>>>
>>>>>> During the execution of
>>>>>> hash_name()->load_unaligned_zeropad(), a potential
>>>>>> memory access beyond the PAGE boundary may occur. For example, when the
>>>>>> filename length is near the PAGE_SIZE boundary. This
>>>>>> triggers a page fault,
>>>>>> which leads to a call to
>>>>>> do_page_fault()->mmap_read_trylock(). If we can't
>>>>>> acquire the lock, we have to fall back to the
>>>>>> mmap_read_lock() path, which
>>>>>> calls might_sleep(). This breaks RCU semantics because path
>>>>>> lookup occurs
>>>>>> under an RCU read-side critical section. In linux-mainline, arm/arm64
>>>>>> do_page_fault() still has this problem:
>>>>>>
>>>>>> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.
>>>>>>
>>>>>> And before commit bfcfaa77bdf0 ("vfs: use 'unsigned long' accesses for
>>>>>> dcache name comparison and hashing"), hash_name accessed the
>>>>>> name byte by
>>>>>> byte.
>>>>>>
>>>>>> To prevent load_unaligned_zeropad() from accessing beyond
>>>>>> the valid memory
>>>>>> region, we would need to intercept such cases beforehand? But doing so
>>>>>> would require replicating the internal logic of
>>>>>> load_unaligned_zeropad(),
>>>>>> including handling endianness and constructing the correct
>>>>>> value manually.
>>>>>> Given that load_unaligned_zeropad() is used in many places across the
>>>>>> kernel, we currently haven't found a good solution to
>>>>>> address this cleanly.
>>>>>>
>>>>>> What would be the recommended way to handle this situation? Would
>>>>>> appreciate any feedback and guidance from the community. Thanks!
>>>>>
>>>>> Does it help if you bodge the translation fault handler along the lines
>>>>> of the untested diff below?
>>
>> I tried it out and it works — thank you for the solution you provided.
> 
> Thanks for giving it a spin.
> 
>> At the same time, since I’m a beginner in this area, I’d like to ask a
>> question.
>>
>> The comment above do_translation_fault() says:
>> “We enter here because the first level page table doesn't contain a
>> valid entry for the address.”
>>
>> However, after modifying the code, it seems that when encountering
>> FSR_FS_INVALID_PAGE, the kernel no longer creates a page table entry,
>> but instead directly jumps to bad_area.
> 
> FSR_FS_INVALID_PAGE indicates a last level translation fault (that's the
> "page" part) so it's only applicable in the case where the other levels
> of page-table have been populated already.
> 
> I wondered about checking !is_vmalloc_addr() too, but I couldn't
> convince myself that load_unaligned_zeropad() is only ever used with the
> linear map.
> 

Thank you very much for the answer. For the vmalloc area, I checked the
call points on the vfs side, such as dentry_string_cmp() or hash_name().
Their "names addr" are all assigned by kmalloc(), so there should be no
corresponding issues. But I'm not familiar with the other calling
points...


>> I'd like to ask — could this change potentially cause any other side
>> effects?
> 
> There's always the possibility but I personally think it's more
> self-contained than the other patches doing the rounds. For example, I
> don't make any changes to the permission fault handling path.
> 
> Will
> 

Ok. Thank you for your explanation.

Thanks,
Zizhi Wo


