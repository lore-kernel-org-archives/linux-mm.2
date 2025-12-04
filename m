Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD83D29FB9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25ED6B0012; Thu,  4 Dec 2025 14:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDEF6B00A4; Thu,  4 Dec 2025 14:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13BC6B00A5; Thu,  4 Dec 2025 14:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC20B6B0012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:27:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CA7B89362
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:27:36 +0000 (UTC)
X-FDA: 84182772912.18.9E58EF6
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 772F3120012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:27:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT6gkS6Y;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZyl8snVqn5fbIv/iSI7+O5vLuMCaEEyOp0Rl9YwHhg=;
	b=jNlvy1as2JeIowxyh91ZRGn0KD5nlTLh8dgd8kuWQ20outQFDR84+VNWJ+Sz8ArjAU4W8k
	AVAk27yoa2/Gn3tSCpvDHCmr8rcfRb4XgPA3BR1l6cX9UYjgr99xae6xak2loPfYRxa0bg
	3OP4kzKqNCgmkGTzHgppyBicKBzBjxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876454; a=rsa-sha256;
	cv=none;
	b=l/2/j3k5BB7Ue6YbauYOfaahLfyWTHgOV1uLOmdnOa1x0c8ysgUDtsk9epHJ24WGgjMS8m
	3SkDPqs4J1BL9Wv6rwTWf8VKrkcQHc80PHwrZmYGQQ/u5b0uKY/l2YiyA66YJWo9Na2xyF
	7uG15ZI6mTfVrdArV+2XgPlWF6seG0c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT6gkS6Y;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477b1cc8fb4so9348175e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876453; x=1765481253; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aZyl8snVqn5fbIv/iSI7+O5vLuMCaEEyOp0Rl9YwHhg=;
        b=mT6gkS6YlnBYYpEcuxFcliolEiqqPBzp/160upvdaf0VGWRsF9aWAFZVqTspXg13HQ
         g+YQkuDZYptOF9ha5F0dIVtucvTrpTA52sxOd489io1PE3xJSkl6wcIo2QWB3cNA4w+e
         DYYsM06c/YiBHqwF0fq2QLBAztqh5OFlXvdtSN5YS0s6ZGsxUpbbOFMGp+MHTA2iNl3x
         ttIE9y7NWvNNGkJ+7C3fWkCM0+SL2Ktnjip3ZSx8vj4yXQkhau8Ll2OGSYd62jYiFHDI
         EbJWk9wuNwG5yn1j1L2tJ+XbO50HAYHO8oT5xfd+YeSMhKvmOrm7FeG25yZ+23LdsCti
         U+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876453; x=1765481253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZyl8snVqn5fbIv/iSI7+O5vLuMCaEEyOp0Rl9YwHhg=;
        b=BWDx+13gf+aTgGbWEMTfnZDhXEoD1ipGNahje+pHJQSPbFaGStukR09NpHZKCi2BUk
         m50U8OBa66f/gXby/pAu0ZvNBtTO2+II2wJ5NX1SK8F75QhCMKHiPGaCL1wNzombaMBE
         6EtdZeKtQ0KVPhLrEgOK9hJaJ14l8Q8V4KiDInFFqd8EYWUx/W+S/iYeXn6AQNazi0fi
         04O5yXsVn7nBGjQpvm0Q5HqzfGxLzTdTy/eh7+axhXkl0Rkpj/NW5W+uerGX7gQNJCoN
         w7qWFEi70LGtqshqlOIo94PkUZRKyvwCHjokE7IHq0rxf5hzDkAtTbVqGVvR45HMTQ+X
         WIiw==
X-Forwarded-Encrypted: i=1; AJvYcCWaVzcpDToHr5dVw8FX1Bhhif+Cjy0fiIhU2eW1enhredA4PEK5E9BpNADrykm3pF/PdkkTlGP7FA==@kvack.org
X-Gm-Message-State: AOJu0Yxo7ktZd2hVGuVKAAfogIzP/v79vifPYGgl+JNRUi4L1Vy/Y67W
	Zw3wHMekdU8RmmSt1BQ5w0NFLA1/ezFo8LxHv29L6KhAmAgGuX9X6Wb1
X-Gm-Gg: ASbGnct+qwO8/NbJMXxTxohRZe6TnKiptAiGXvL8Dtqv4Li3vW3CP3Q/t1JrwnSe9ZC
	4+ZdagswPf/TJKT/1lDfCPw4VJpT7AnDDcKHq5FR3OaBq6n1nRuZlzX/zorxN/Itl2tJN30M4Cw
	YlTqjSHZqzg15BEOcDCRo30VymvKVS+OaWOMUgIxY+DUuKiTrKhR3BJHpSu6MgEp1331V4C0rRr
	TNto9zHiZkGd4D4at7e4U94cEB/j+7TfDvjHxwt9aQ7k2D1VUKep//2o8ROTk4Ki37x1zqZDvBl
	KIyd4Wz7ApPpUkNyo0eluV7LgqJo3mDg3bqnqLBwqhtJ1NtSStY3DlgwHfpYmmdVMsUrik9OZaQ
	ddrryOQEoJM5MlNrR3DHQpJflvIUCbDqt6Leo2zYn+oXs+s/OjQdFWElUr6jdyySc7sJEefk94H
	NstJRKkQuMmzHQc7T11vTq3GBdHdZOF6dK6Mth8qnQTDMStSZmCz6lVSnrTYpu3jGNUfkKaSCR7
	NdSXKHmR/U/
X-Google-Smtp-Source: AGHT+IHHzcwYCXpxBTLZCxV0+gMRCwOUA5CFUE4MCEJLsZG0cFPrpKzyxrRbeYE9Ey2KBL1ibLoOXA==
X-Received: by 2002:a05:600c:4e90:b0:479:2a0b:180d with SMTP id 5b1f17b1804b1-4792f259c46mr42195745e9.11.1764876452519;
        Thu, 04 Dec 2025 11:27:32 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b04e03bsm43362195e9.7.2025.12.04.11.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 11:27:31 -0800 (PST)
Message-ID: <657d2356-126d-452b-ba7f-5c0761f4f832@gmail.com>
Date: Thu, 4 Dec 2025 19:27:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Content-Language: en-GB
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
 changyuanl@google.com, graf@amazon.com, leitao@debian.org, thevlad@meta.com,
 pratyush@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com>
 <aSwFwMVyFcPlOR10@kernel.org>
 <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
 <f1ee34be-44fd-4286-8b02-f69d3a2dbd26@gmail.com>
 <aTHKaaeY7_HCswbg@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aTHKaaeY7_HCswbg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 772F3120012
X-Stat-Signature: mc9rmbsetnywmtrwsonfwfxptcumo5x1
X-HE-Tag: 1764876454-968182
X-HE-Meta: U2FsdGVkX19T3tIWkZGh8lioVmpQY2UNCI0nNpLbRZ/e4xzb2l2yGGrNs8jrepFKA3nIdoplJgJ8SuDpS8jtVevmPXGBwRppAE0bMnrS2jwXkN9F886hv5nfLsV33wgRhfL5eeLQPDR30J1G6T5Pf+WUNGcSkUCmT6NVVDYg1OcdVAeaiIXCjVPK4+dsu4Dj0Yua5P98WMTbHwET6IpbpOo/IvqprUwOznuy3OqgjmNpEub8A5R4JpmMPOWcelhTbmc7+iYtP6Ae6DbjfoMR6VxgoybZGEDV7Ac5mdXQKgZ5KCBNvnr4sTH0ltlg959QGWgqlW1CN1tYUKXpd5uaT+7ZrHvY9N7eIva//3uTlwUVJ027FlH0OxWgIc7dPLpGl3RmN7mOafKevfnT051+EbTEg5ggw/fsRs9ER8pjIAOJNr4TC0HIlJ3Fg7UCs1aFr9fQoJJKKhj0vQ6a3PpQklDUlxD+sX6jfEj0kpKtatnk49+iVVNq9nLpgh0DnoFhLR3IwaFldQZJ2Wg5v9fRpaKny/RqqFQ1qQpErtZYnQ0rKuOPlz5Bhof94vWLYyL0inkmwKIIlOpZHIQV3MiXbGNZNK47Ix2D5xeGejU0nha63NIMBmjTOVK/1eU4shdjp+PUv2dDI1nh3sGomoEnnlnvaCYWj+QIlvGcPoiMNttnxwzjQeicHDyT/IH8wMzqTXMAQAP1Ax1U+dy1YnAsQcjZuuVOuK/K80p6dpzo/UA9obN66VU8DRX7cht45Oss/LuokOS49Yrx8PMYv+YLWpmMfhf5ITOG9pTtvUy3nZSvb5D6BZVhZtP9fYdFjdOulH6YzwMVd5vjUQPLb2LfgITCb5n765VbZ8kCHEq69nqxUK1GkKifrayVFfCSFphecdKnQPkiTmCUcS5IinpNGaRgBCwclpXUHr76Qt6YzUtftXsFLdZtfJBrMKyDDUj4fGnAxYRBOOEUiGvq7uN
 UwWgPLIF
 sjXW0FuKPJmdk8gQe6gEnhmY8Gatv7DzdQ1XSHDGwYboNCuKezlgGnbFqHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/12/2025 17:52, Mike Rapoport wrote:
> Hi Usama,
> 
> On Thu, Dec 04, 2025 at 02:51:00PM +0000, Usama Arif wrote:
>>> On Sun, Nov 30, 2025 at 3:52 AM Mike Rapoport <rppt@kernel.org> wrote:
>>>>
>>>> On Fri, Nov 28, 2025 at 05:29:34PM +0000, Usama Arif wrote:
>>>>> The scratch memory for kexec handover is used to bootstrap the
>>>>> kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
>>>>> hack to get around limitations with KHO. It is only needed when
>>>>> CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
>>>>> (both checked by is_kho_boot). Add check to prevent marking a KHO
>>>>> scratch region unless needed.
>>>>
>>>> I'm going to rewrite the changelog and queue this for upstream:
>>>>
>>>> The scratch memory for kexec handover is used to bootstrap the kexec'ed
>>>> kernel and it is only needed when it is a KHO boot, i.e. a kexec boot with
>>>> handover data passed from the previous kernel.
>>>>
>>>> Currently x86 marks the first megabyte of memory as KHO scratch even for
>>>> non-KHO boots if CONFIG_KEXEC_HANDOVER is enabled.
>>>>
>>>> Add check to prevent marking a KHO scratch regions unless they are actually
>>>> needed.
>>>>
>>>>> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
>>>>> Reported-by: Vlad Poenaru <thevlad@meta.com>
>>>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>>>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>>>
>>> This patch causes panic with my tests in linux-next.
>>>
>>> [    0.000000] Kernel panic - not syncing: Cannot allocate 17280 bytes
>>> for node 0 data
>>> [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
>>> 6.18.0-next-20251203 #2 PREEMPT(undef)
>>> [    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>> BIOS 0.1 11/11/2019
>>> [    0.000000] Call Trace:
>>> [    0.000000]  <TASK>
>>> [    0.000000]  ? dump_stack_lvl+0x4e/0x70
>>> [    0.000000]  ? vpanic+0xcf/0x2b0
>>> [    0.000000]  ? panic+0x66/0x66
>>> [    0.000000]  ? alloc_node_data+0x32/0x90
>>> [    0.000000]  ? numa_register_nodes+0x82/0x100
>>> [    0.000000]  ? numa_init+0x36/0x120
>>> [    0.000000]  ? setup_arch+0x667/0x7f0
>>> [    0.000000]  ? start_kernel+0x58/0x640
>>> [    0.000000]  ? x86_64_start_reservations+0x24/0x30
>>> [    0.000000]  ? x86_64_start_kernel+0xc5/0xd0
>>> [    0.000000]  ? common_startup_64+0x13e/0x148
>>> [    0.000000]  </TASK>
>>> [    0.000000] ---[ end Kernel panic - not syncing: Cannot allocate
>>> 17280 bytes for node 0 data ]---
>>> PANIC: early exception 0x0d IP 10:ffffffff89007a13 error 763 cr2
>>> 0xffff991090a01000
>>>
>>
>> Thanks for reporting this and sorry for the bug!
>>
>> So the patch was designed to remove the memblock_mark_kho_scratch in e820__memblock_setup if not
>> in KHO boot. But it broke memblock_mark_kho_scratch in kho_populate.
>> Moving kho_in.fdt_phys = fdt_phys to before the memblock_mark_scratch
>> should fix it. I dont have a setup where I can easily test KHO, but I think below
>> should fix it?
> 
> This might, but this is too late for v6.19-rc1.
> For now I'm dropping this series from memblock/for-next.
> We can resume working on this after merge window closes.
>  

Yes makes sense.

How would you like me to proceed with the fix? Should I send just the fix now,
or these 2 patches plus the fix after the merge window closes?

Thanks!


>> TBH using fdt_phys to check if the boot is KHO might be a bit hacky? Is it possible
>> to have a better check for this?
> 
> Presence of KHO FDT is a clear indication that it is a KHO boot.
> The issue is that during early boot ordering is hard and it's not always
> clear in which order features and configuration are detected and used. 
>  

ack

>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 9dc51fab604f1..c331749e6452e 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -1483,6 +1483,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>                 goto out;
>>         }
>>  
>> +       kho_in.fdt_phys = fdt_phys;
>>         /*
>>          * We pass a safe contiguous blocks of memory to use for early boot
>>          * purporses from the previous kernel so that we can resize the
>> @@ -1513,7 +1514,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>          */
>>         memblock_set_kho_scratch_only();
>>  
>> -       kho_in.fdt_phys = fdt_phys;
>>         kho_in.scratch_phys = scratch_phys;
>>         kho_scratch_cnt = scratch_cnt;
>>         pr_info("found kexec handover data.\n");
>> @@ -1524,7 +1524,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>         if (scratch)
>>                 early_memunmap(scratch, scratch_len);
>>         if (err)
>> +       {
>> +               kho_in.fdt_phys = 0;
>>                 pr_warn("disabling KHO revival: %d\n", err);
>> +       }
>>  }
> 


