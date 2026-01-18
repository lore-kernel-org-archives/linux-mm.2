Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D9FC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 17:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD9E6B0098; Sun, 18 Jan 2026 12:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7DA26B0099; Sun, 18 Jan 2026 12:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA01A6B009B; Sun, 18 Jan 2026 12:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 937F66B0098
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:54:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5904C210D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 17:54:52 +0000 (UTC)
X-FDA: 84345835224.21.7998AA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1515C180002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 17:54:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RiCA9bOu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768758890; a=rsa-sha256;
	cv=none;
	b=n19B+ISY46uOs4r3ykUzlMi+0wzTq23vMu8GsoUxAgOE7KM1veqgaCNMVBY9OK67p3DzKZ
	LkAh76Dw+yk33p6GolPeRGvqIofhf5QcGYNHcpd5xNge9WO+GD0NTciEelNBq7eNVw67C1
	3LXPLIH0dJOgiI0b92dtl9YxgqQ7yh0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RiCA9bOu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768758890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV/XObCJQW+KRxixfCvJyEDHiGXfLdVuEz3fhlq1yGU=;
	b=1S78EBRjYc9jCxvcbOp9x+VpY5ngFnGnDdqySkRGXT//OdTlm57LvPkviZDAJuA4fDTdv7
	29mUiFg66K5NPjA6+azq49XJTxRcg2UGbPL0qCBriUOlCDmnEbeAK+uKxgn8jDGod09+4p
	m3vIvqa6NY31P8hjzLUyyY5k0d/c0kE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768758888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gV/XObCJQW+KRxixfCvJyEDHiGXfLdVuEz3fhlq1yGU=;
	b=RiCA9bOuvMkGsHwYtj9mGbdM2E/9MaFsuZ4TvEyLOcDaBohcK0WvR1Z141Z35kj57Qx7ry
	ou5nvr/scJRq89O+2g3pc6s9UO81SMBYkuSIH1jWkJNwzN+skhYdZY68OlvVck9P6pNSDf
	WVFnrlf2zirL+2lfxhU9phehKaxX2Gc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-hslg6clRPkqeKBhQXYO8oQ-1; Sun, 18 Jan 2026 12:54:47 -0500
X-MC-Unique: hslg6clRPkqeKBhQXYO8oQ-1
X-Mimecast-MFC-AGG-ID: hslg6clRPkqeKBhQXYO8oQ_1768758886
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59b6c0abec0so3768920e87.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768758885; x=1769363685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gV/XObCJQW+KRxixfCvJyEDHiGXfLdVuEz3fhlq1yGU=;
        b=tsl6AXNbgA0mzi70jcAHB+T3b7Zip88dfu8ZyGAFfxNTGR8dQjft0evD2ZE6G1AFs/
         NmeA5PmhN/7lH/REKDzInnwIw7UgCCgu0ddrhgQeiFOVOaoOuyCWshSRvhVDAzP1XCAp
         8+HevMEJWMMIxUKVqxor2i44uRuLLeoWjsnV5pl+ulHS/ZPvVX0pOGSlBgkRzgR02S1r
         E8oINLsV1t0zrof2+XmqGrDxi27HYKIBiWm29pPFBloH2bph3L/mU9Bf0uWpY/iZk75O
         2KSaNu+jY4wqMaxsqY/Umi477p3+wm3QEiDAvdQUf2FhIv25h7tjbAYYhMkdVZkpIqnL
         lIbA==
X-Gm-Message-State: AOJu0YzfymrJiA7iob3qAGXbgM8hDYgXFmS2XCCtd1QK/3OZtJ+wvLme
	iNuOX0KGua6uhgPKjAhCKESv/xV+cKoXGBRi5nzH8fUskDFLBAHdUZsA82bBCwchIxAT16pBfD4
	VDvPw1Bz1a01cvptoTgwdkG563rhMXa2acQ+bY5MbBzKeio2/rZM=
X-Gm-Gg: AY/fxX77Tg6x1oPjAtuu/dpRpU/Q4CfbF7Dk8L2nTsR1XnIH8s7U9Jqk4G13RZJC+jS
	39E8EUC9TlAr267vI82xS7KReCsoV7MtCasHhumRabHPp8vS7GCTSEj26Rn3Iq4ZhY7gSd/Y+HD
	z0MGZIcUumhxsr4m/ErqWz2z4wJKPruGNhTSAgT8lN/mqYi4TWpN/qDPgaiEyJluIzBlMirVCl3
	PshFluvzE/JmcDkHzg5QfKBNaFEG7Q8jf9nRyCEyiGAqTX6U2WjVCDCmz1TQQWAE2nBYqPzTLj9
	DKpvJfs54WHxHaoIzdfwuhFNgaKGhZjxEeHKuXZxMVfPAoLp+VL30cFhhkZdkgWMHjfKLlziRmA
	HoY0SDyA+BkFazi9yRP8FlQJioLs5VROBS5M=
X-Received: by 2002:a05:6512:3a8e:b0:598:ef90:3e9b with SMTP id 2adb3069b0e04-59baeedb8b8mr3074618e87.34.1768758885314;
        Sun, 18 Jan 2026 09:54:45 -0800 (PST)
X-Received: by 2002:a05:6512:3a8e:b0:598:ef90:3e9b with SMTP id 2adb3069b0e04-59baeedb8b8mr3074608e87.34.1768758884756;
        Sun, 18 Jan 2026 09:54:44 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf9d442dsm2655940e87.94.2026.01.18.09.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 09:54:44 -0800 (PST)
Message-ID: <5b396f1e-b25c-494c-8286-4791eb542510@redhat.com>
Date: Sun, 18 Jan 2026 19:54:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
 <20260114091923.3950465-2-mpenttil@redhat.com>
 <aWmdOMOYomnJrJWQ@lstrano-desk.jf.intel.com>
 <151ee03d-423b-4ac2-9dd4-11b1ceaadbaf@redhat.com>
 <aWqaBe+JVL3sz9bS@lstrano-desk.jf.intel.com>
 <d6324f13-7e03-4c95-bc4c-4fa0c1dd6334@redhat.com>
 <aWxbcmeIOTtGP2lo@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aWxbcmeIOTtGP2lo@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TJa1rpRK8ewlQSd1e6xoq7H1FjpiA27X3Z2YGFy1rT8_1768758886
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1515C180002
X-Rspamd-Server: rspam06
X-Stat-Signature: wdtrhujzaouk5z9ef6yn597u6uxn951k
X-Rspam-User: 
X-HE-Tag: 1768758888-692655
X-HE-Meta: U2FsdGVkX1/vnMEV1zS82KdbS31JensLgB0lhXzEu7ACESQyRG1Ni++ZrvvngwvydtvotSUJcUFRJrS18/ETpD+JeFmt8jWoHwGsL+kdNxyL0mBxi0TLhmeR0xjbJBbMLSle305CLBz6VSHAJE1Jhhz7KQbywrB+deSr5FBuOUql02uIiGcO8RGedYBR6If/CyuHk9loTnJIf6Z1Q5SHZOUM3PSwU763inhiYk7jA4NKv82hzggq+JU/fXWdhhRf4SUAY+mVSe+dSYqXBS6dFWSiSruSJnR4NfNz13yweulYe+KXlYBZtOsXz/idhSPkvVoT4N00RHvwcxF2fgctnq864IYZayKumJtKuWzTDFKizc9U1/6/9d7j4tiz8tf4xOxNpYJihd0jJaPz8yt/rtXNVdr370utX+HcN+xly9zxHN5GhRs+OFS0ZqDAWtUclWAkwEjyGOkl7ksz/aIFm7/zqz9azEgs27K7hLewfzkEJoAdbFSlgykrorPw7SeDqNZJph4diCdTr7zQlW1PILuhZS+xC1nlxKkeRwBdxPLdpfj9DUr6F8YTSJbJ/VLkoJNlno0wnqZwmQlnx3U7xd/pJagtVOJlybpCCvpGQyXtarl1n09xZMPSH9VJhMQuVMGmO6X1n5ys1BVHNKFliKu92z5yEym5UQKgburxaFuhj3dB8sESSPRTwqRvlysLWf47eB4yYyI6qrCJM9Lsp7qvhhB2/udcjLoREwXE6PZLtkLyRz2vOyFu4HY4kGnbwhlMkgg/A/c3HBxMSHRVMp517DNt9E5gYSsu9pm08O2DPi74D6AM6oV+PemllwuWCz2aDR9BjEeQZ0qmWtCw9aBrXOQHXBcwicvae+lfysoy8WwkZYpaRYJiXTEghR5Xazo4UUJWvSIm8gr1Gd7qNhgM3EQ5GPOm2Ay8yd1T/V08dovGwArO1tvWmBb/Mj3jokrmtFxSTL1Z2Wg0HlQ
 zxY3svAl
 AwnyjHhUeugktiquB9BFRJywgfo1Or0puipt90Vi16LmF4bfzekGwBUZ7aZpTWzRaepIKaaAc7InxpTJ/jDJjGJTua0Vj8gLRD+WpKmFHiljaSgekSYDJFOyuwFrbPIKXZ5IoL3oP2LgYtesfqxdBoj4kYwKOhKFVE4Rh0h1uaCi/D8lb0F+3l4OSwyYzU6qnvnC/OAY0+5pXny9A6yrs6zvizg3LE+qFGERsQLsIJJaSzKp0ubNdtQ+0VLFWdpLyJ+tOco/Ca//Fcv4Q7WOfDbp3QxY1kqL9ivYHlWZqguWvvfve3FAAgiVPbNs3aVCC+p1vGntQ3u4ufdfR9xE5aNJvFca30bwqPcvSY4AsUQKGGe4XxspYil5QhERrsvV00coNjn/iuIV6E4MOrmnC7IXDIgbE34Vw9GgOEMnDk3qWKqyLYh40gcJAl6SacsD0oZ32w2hjPKAR84pfeYeRLvAG7LbmwsIuiKDYNHI9YHPW7iECajr32AugAL+X7svnsLqAm7BWG7FDNak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/18/26 06:02, Matthew Brost wrote:

> On Sat, Jan 17, 2026 at 09:07:36AM +0200, Mika Penttilä wrote:
>> On 1/16/26 22:05, Matthew Brost wrote:
>>
>>> On Fri, Jan 16, 2026 at 12:39:30PM +0200, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>> On 1/16/26 04:06, Matthew Brost wrote:
>>>>
>>>>> On Wed, Jan 14, 2026 at 11:19:21AM +0200, mpenttil@redhat.com wrote:
>>>>>> From: Mika Penttilä <mpenttil@redhat.com>
>>>>>>
>>>>>> Currently, the way device page faulting and migration works
>>>>>> is not optimal, if you want to do both fault handling and
>>>>>> migration at once.
>>>>>>
>>>>>> Being able to migrate not present pages (or pages mapped with incorrect
>>>>>> permissions, eg. COW) to the GPU requires doing either of the
>>>>>> following sequences:
>>>>>>
>>>>>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>>>>>> 2. migrate_vma_*() - migrate the pages
>>>>>>
>>>>>> Or:
>>>>>>
>>>>>> 1. migrate_vma_*() - migrate present pages
>>>>>> 2. If non-present pages detected by migrate_vma_*():
>>>>>>    a) call hmm_range_fault() to fault pages in
>>>>>>    b) call migrate_vma_*() again to migrate now present pages
>>>>>>
>>>>>> The problem with the first sequence is that you always have to do two
>>>>>> page walks even when most of the time the pages are present or zero page
>>>>>> mappings so the common case takes a performance hit.
>>>>>>
>>>>>> The second sequence is better for the common case, but far worse if
>>>>>> pages aren't present because now you have to walk the page tables three
>>>>>> times (once to find the page is not present, once so hmm_range_fault()
>>>>>> can find a non-present page to fault in and once again to setup the
>>>>>> migration). It is also tricky to code correctly.
>>>>>>
>>>>>> We should be able to walk the page table once, faulting
>>>>>> pages in as required and replacing them with migration entries if
>>>>>> requested.
>>>>>>
>>>>>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>>>>>> which tells to prepare for migration also during fault handling.
>>>>>> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
>>>>>> is added to tell to add fault handling to migrate.
>>>>>>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>>>>> Cc: Leon Romanovsky <leonro@nvidia.com>
>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> I'll try to test this when I can but horribly behind at the moment.
>>>>>
>>>>> You can use Intel's CI system to test SVM too. I can get you authorized
>>>>> to use this. The list to trigger is intel-xe@lists.freedesktop.org and
>>>>> patches must apply to drm-tip. I'll let you know when you are
>>>>> authorized.
>>>> Thanks, appreciate, will do that also!
>>>>
>>> Working on enabling this for you in CI.
>>>
>>> I did a quick test by running our complete test suite and got a kernel
>>> hang in this section:
>>>
>>> xe_exec_system_allocator.threads-shared-vm-many-stride-malloc-prefetch
>>>
>>> Stack trace:
>>>
>>> [  182.915763] INFO: task xe_exec_system_:5357 blocked for more than 30 seconds.
>>> [  182.922866]       Tainted: G     U  W           6.19.0-rc4-xe+ #2549
>>> [  182.929183] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [  182.936912] task:xe_exec_system_ state:D stack:0     pid:5357  tgid:1862  ppid:1853   task_flags:0x400040 flags:0x00080000
>>> [  182.936916] Call Trace:
>>> [  182.936918]  <TASK>
>>> [  182.936919]  __schedule+0x4df/0xc20
>>> [  182.936924]  schedule+0x22/0xd0
>>> [  182.936925]  io_schedule+0x41/0x60
>>> [  182.936926]  migration_entry_wait_on_locked+0x21c/0x2a0
>>> [  182.936929]  ? __pfx_wake_page_function+0x10/0x10
>>> [  182.936931]  migration_entry_wait+0xad/0xf0
>>> [  182.936933]  hmm_vma_walk_pmd+0xd5f/0x19b0
>>> [  182.936935]  walk_pgd_range+0x51d/0xa60
>>> [  182.936938]  __walk_page_range+0x75/0x1e0
>>> [  182.936940]  walk_page_range_mm_unsafe+0x138/0x1f0
>>> [  182.936941]  hmm_range_fault+0x8f/0x160
>>> [  182.936945]  drm_gpusvm_get_pages+0x1ae/0x8a0 [drm_gpusvm_helper]
>>> [  182.936949]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
>>> [  182.936951]  xe_svm_range_get_pages+0x1b/0x50 [xe]
>>> [  182.936979]  xe_vm_bind_ioctl+0x15c3/0x17e0 [xe]
>>> [  182.937001]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
>>> [  182.937021]  ? drm_ioctl_kernel+0xa3/0x100
>>> [  182.937024]  drm_ioctl_kernel+0xa3/0x100
>>> [  182.937026]  drm_ioctl+0x213/0x440
>>> [  182.937028]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
>>> [  182.937061]  xe_drm_ioctl+0x5a/0xa0 [xe]
>>> [  182.937083]  __x64_sys_ioctl+0x7f/0xd0
>>> [  182.937085]  do_syscall_64+0x50/0x290
>>> [  182.937088]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [  182.937091] RIP: 0033:0x7ff00f724ded
>>> [  182.937092] RSP: 002b:00007ff00b9fa640 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>> [  182.937094] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ff00f724ded
>>> [  182.937095] RDX: 00007ff00b9fa6d0 RSI: 0000000040886445 RDI: 0000000000000003
>>> [  182.937096] RBP: 00007ff00b9fa690 R08: 0000000000000000 R09: 0000000000000000
>>> [  182.937097] R10: 0000000000000001 R11: 0000000000000246 R12: 00007ff00b9fa6d0
>>> [  182.937098] R13: 0000000040886445 R14: 0000000000000003 R15: 00007ff00f8a9000
>>> [  182.937099]  </TASK>
>>>
>>> This section is a racy test with parallel CPU and device access that is
>>> likely causing the migration process to abort and retry. From the stack
>>> trace, it looks like a migration PMD didn’t get properly removed, and a
>>> subsequent call to hmm_range_fault hangs on a migration entry that was
>>> not removed during the migration abort.
>>>
>>> IIRC, some of the last bits in Balbir’s large device pages series had a
>>> similar bug, which I sent to Andrew with fixup patches. I suspect you
>>> have a similar bug. If I can find the time, I’ll see if I can track it
>>> down.
>> Thanks for your efforts Matthew!
>>
> Happy to help.
>
>> I remember those discussions, and looks similar. If recall correctly, it was
>> about failed splits and continuation after that. The code bails out the
>> pmd loop in this case but maybe this part is missing and is equivalent to
>> collect skip:
>>
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 39a07d895043..c7a7bb923a37 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -988,8 +988,12 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>                 }
>>  
>>                 r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
>> -               if (r)
>> +               if (r) {
>> +                       /*  Split has failed, skip to end. */
>> +                       for (i = 0; addr < end; addr += PAGE_SIZE, i++)
>> +                               hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>                         break;
>> +               }
>>         }
>>         pte_unmap(ptep - 1);
>>
>> With that is should be quite similar to current flow (for effects).
>>
> I think the above code is conceptually correct and needed, but I don’t
> think it is the actual problem.
>
> I traced the issue to the handle and prepare functions racing with other
> migrations. The handle function doesn’t find a valid PTE/PMD and
> populates the HMM PFN with zero. The prepare function then finds a valid
> PTE/PMD and installs a migration entry. My code aborts the migration
> because we only migrate if all pages in the requested range are found.
> migrate_vma_pages/migrate_vma_finalize are called, but since some PFNs
> are zero, the migration entries installed during the prepare step are
> not removed.
>
> This is actually very easy to reproduce on my end if I disable compound
> page collection in my migrations and then run a test that migrates 2M
> pages with racing CPU/GPU access. I suspect we could write a selftest to
> replicate this.
>
> I have a hacky patch that fixes this — among other things I spotted
> while looking at this — but I don’t think that’s the right approach. I
> believe the right approach is to unify the handle and prepare functions
> into a single one. If you look at what these two functions do, they are
> actually quite similar; e.g., both inspect PTE/PMD state to make
> decisions. Of course, if you want a migration you need the PTE/PMD
> locks, and those would need to be dropped if you want to do something
> like fault in a page. This still seems doable. I’ll let you and the HMM
> maintainers duke this out regarding whether this is an acceptable
> approach :).
>
> FWIW, here are the changes I had to make to get my code stable. Tested
> with compound page collection both on and off.

Thanks a lot, you spotted the root cause! Seems the issue is,
if migrating, you have to set the HMM_PFN_VALID and HMM_PFN_MIGRATE both
while holding the pmd/ptl lock (without releasing in between).
My original idea with the separate handle and prepare steps was
that handle does the faulting and pfn population step, the 
the HMM_PFN_VALID establishing step. 
Prepare then decides about migration, by possibly adding HMM_PFN_MIGRATE.
Currently this isn't race free. One way to fix is like you do, but admit
that brings some redundancy between the paths.
I think having those two functions separate is good for manageability,
instead of scattering migrate related fragments to many places.
The migration part brings quite a lot complexity with the splitting
and stuff, and likely would end up adding encapsulating some of it 
in own functions anyway.
I am experimenting with modified locking, so while migrating
we lock the pte/pmd for the walk (and unlock when handling faults) so the
handle and migrate happen logically under same locking region.
Let's see how that looks like. I think that should solve 
the seen issues as well..

Will send v2 with this and other fixes so far..

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 39a07d895043..5e24cd82b393 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -509,8 +509,10 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>         }
>
>         if (pmd_trans_huge(*pmdp)) {
> -               if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
> +               if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +                       hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>                         goto out;
> +               }
>
>                 folio = pmd_folio(*pmdp);
>                 if (is_huge_zero_folio(folio)) {
> @@ -523,16 +525,22 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>
>                 folio = softleaf_to_folio(entry);
>
> -               if (!softleaf_is_device_private(entry))
> -                       goto out;
> -
> -               if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +               if (!softleaf_is_device_private(entry)) {
> +                       hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>                         goto out;
> -               if (folio->pgmap->owner != migrate->pgmap_owner)
> +               }
> +               if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
> +                       hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>                         goto out;
> +               }
>
> +               if (folio->pgmap->owner != migrate->pgmap_owner) {
> +                       hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +                       goto out;
> +               }
>         } else {
>                 spin_unlock(ptl);
> +               hmm_vma_walk->last = start;
>                 return -EBUSY;
>         }
>
> @@ -541,6 +549,7 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>         if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>                 spin_unlock(ptl);
>                 folio_put(folio);
> +               hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>                 return 0;
>         }
>
> @@ -555,8 +564,10 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>                         .pmd = pmdp,
>                         .vma = walk->vma,
>                 };
> +               unsigned long pfn = page_to_pfn(folio_page(folio, 0));
>
> -               hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
> +               hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND |
> +                       HMM_PFN_VALID;
>
>                 r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>                 if (r) {
> @@ -564,6 +575,8 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>                         r = -ENOENT;  // fallback
>                         goto unlock_out;
>                 }
> +               hmm_pfn[0] &= HMM_PFN_FLAGS;
> +               hmm_pfn[0] |= pfn;
>                 for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
>                         hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
>
> @@ -604,7 +617,7 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>         struct dev_pagemap *pgmap;
>         bool anon_exclusive;
>         struct folio *folio;
> -       unsigned long pfn;
> +       unsigned long pfn = 0;
>         struct page *page;
>         softleaf_t entry;
>         pte_t pte, swp_pte;
> @@ -688,8 +701,8 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>                                 goto out;
>                 }
>
> -               folio = page_folio(page);
> -               if (folio_test_large(folio)) {
> +               folio = page ? page_folio(page) : NULL;
> +               if (folio && folio_test_large(folio)) {
>                         int ret;
>
>                         pte_unmap_unlock(ptep, ptl);
> @@ -745,12 +758,15 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>                                 set_pte_at(mm, addr, ptep, pte);
>                                 folio_unlock(folio);
>                                 folio_put(folio);
> +                               *hmm_pfn &= HMM_PFN_INOUT_FLAGS;
>                                 goto out;
>                         }
>                 } else {
>                         pte = ptep_get_and_clear(mm, addr, ptep);
>                 }
>
> +               /* XXX: Migrate layer calls folio_mark_dirty if pte_dirty */
> +
>                 /* Setup special migration page table entry */
>                 if (writable)
>                         entry = make_writable_migration_entry(pfn);
> @@ -759,6 +775,8 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>                 else
>                         entry = make_readable_migration_entry(pfn);
>
> +               /* XXX: Migrate layer makes entry young / dirty based on PTE */
> +
>                 swp_pte = swp_entry_to_pte(entry);
>                 if (pte_present(pte)) {
>                         if (pte_soft_dirty(pte))
> @@ -775,8 +793,18 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>                 set_pte_at(mm, addr, ptep, swp_pte);
>                 folio_remove_rmap_pte(folio, page, walk->vma);
>                 folio_put(folio);
> -               *hmm_pfn |= HMM_PFN_MIGRATE;
> +               /*
> +                * XXX: It is possible the PTE wasn't present in the first part
> +                * of the HHM walk, repopulate it...
> +                */
> +               *hmm_pfn &= HMM_PFN_FLAGS;
> +               *hmm_pfn |= HMM_PFN_MIGRATE | pfn | HMM_PFN_VALID |
> +                       (writable ? HMM_PFN_WRITE : 0);
>
> +               /*
> +                * XXX: Is there a perf impact of calling flush_tlb_range on
> +                * each PTE vs. range like migrate_vma layer?
> +                */
>                 if (pte_present(pte))
>                         flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
>         } else
> @@ -988,8 +1016,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>                 }
>
>                 r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
> -               if (r)
> +               if (r) {
> +                       hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>                         break;
> +               }
>         }
>         pte_unmap(ptep - 1);
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index c8f5a0615a5e..58d42d3ab673 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -268,6 +268,12 @@ int migrate_vma_setup(struct migrate_vma *args)
>
>         migrate_hmm_range_setup(&range);
>
> +       /* Remove migration PTEs */
> +       if (ret) {
> +               migrate_vma_pages(args);
> +               migrate_vma_finalize(args);
> +       }
> +
>         /*
>          * At this point pages are locked and unmapped, and thus they have
>          * stable content and can safely be copied to destination memory that
>
> Matt

--Mika



