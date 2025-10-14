Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07CFDCCD18C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456BD8E00AC; Tue, 14 Oct 2025 02:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407288E0005; Tue, 14 Oct 2025 02:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D1F8E00AC; Tue, 14 Oct 2025 02:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCAE8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:49:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6D7811AC3E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:44 +0000 (UTC)
X-FDA: 83995794288.19.5C82F14
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id A884F10000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5WafnkN;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760424583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqw4wlUUpqHY1zTsNaI6KPl3Fd0ZPpUoNdegpj+F+GI=;
	b=KnhpBXwGnCOSQhqu90N7xzvIcqo5OB8f2aO81w1VHy5yuV9rHlD46IGCskzZnRNmUh2x8b
	d/7LigaRJfX2yzI+b8VnDBNE0+52VTjpYXU3dk35hVbPoqu/yUf52TKo67gqlgE/3cLzU9
	T1oGoPZuao7OywVQrdBmWPCYkOOc4Nk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5WafnkN;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760424583; a=rsa-sha256;
	cv=none;
	b=MvWJDoVk7yMK8cIMZH7s6QHEWX/cJrbHfS5hjUO9+0JvGyN0mzfhiR7RW53lPaFwWU/7vJ
	u0u/e0aVxtZYwgaOiIypg6aUxd9YZ2vAKSNxRWgwZGLo4Bb4EtEowqc+1QaYzjtDZJsgN3
	CdoLZ0xUWDIMzLdsSr4lkDKEFAac9Yk=
Message-ID: <0c833afd-64d5-4128-a03a-c47ff834b7ab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760424580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bqw4wlUUpqHY1zTsNaI6KPl3Fd0ZPpUoNdegpj+F+GI=;
	b=w5WafnkN4Pd2sN5sguTO6JcMstbnbaCkYxq3XgFIaIrllCvPiKOHODjcdp9y30yM/FexFh
	0pcwSDLv37z03FGyQCA5tU7vNXsY0ws+RtvH5bmZqDj7hWbTrmm58CuHQwJ1DACW62YOUc
	CQPua4UYMtenb+k2wGn7Mg7mB3yKIDY=
Date: Tue, 14 Oct 2025 14:49:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/4] reparent the THP split queue
To: Zi Yan <ziy@nvidia.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <925E0247-2976-4D85-A8AA-E8C92C64CED4@nvidia.com>
 <df9a3e22-caca-4298-b7d8-5334ce5446a0@linux.dev>
 <C3134C16-584F-41D2-88E4-4B94B58C16F2@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <C3134C16-584F-41D2-88E4-4B94B58C16F2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A884F10000C
X-Stat-Signature: dffishmg3tocmk4uujc4174kmwxajh78
X-Rspam-User: 
X-HE-Tag: 1760424582-206666
X-HE-Meta: U2FsdGVkX19w9pN6O+XUj49HHjJBCVZafGqCJWZ6ayUe9RzNW0bSdjzjB65WOjjLlQv0HLB9Ll6DSUeny4cqLcEuDAIbSzyNDod8IzseYKeQcp4AU9FwphPe1nGYMKHVIV+fMZkKcQIFVEjBbK14vJk130+FG6p+A97Bm+X2TCFZacoPx4y9tK/vwDmKfrH3OvG93m9zwG4YzKyBy92kLVM5bp76aZI+ZhDq3+JfNlqzVrxNdCB+eQUhjzbP/jwbuyLsT/48thQK53MmMHw8tHdv4H8IeDb2985zLlVFg0CEnK73FiXmC9hn7SCzleXT/9/lsi9a9txOZjEp4XOEnaDF4xUIjDLG1HzzwxTqBqmb5o3IJpFcVWcODEVjW3QU7M4qmsqRaINaoHFa53ZEifHLYtQSGNGwBeSMC/W4/ggyaTmIZ3tty0PWUvpJ4KI8DsTQfOeTOczU55zJe8xaJxpmAy9CPUAzavuJ99WVNcDR07W1fVLhp/9DcqimLKYiFam+PCSL1DD/SRDBsEFv3N41q5YbtAqZqDLjsFXSctjPGBRcwWEqtmIHccNIXCFQPDK8c5wnKexOFIDYf4+g52A8XOPBtqmyAg9+mIHdg9wiI9jEnbELH6OWE+IdaR3M19ZpCNWr/pxN06f+xoAoKKmBJFKj7q5HC0zf1nJtBKrmL16zFgJpa/KH1Wm4bMgtihG8i3kkuVCrRwJ17EN3LtM4+y5X0tCgoRnbQExDDlmbwMYimCZp/JGQqAOCLm47TaqTq8vi9eV7aHCg9OwE54m/Q2VkkFetnuKV7nn6QRE309iXUlMrgatY5ZowjOSlZX88VFv1/CDvzkblhlI+OyYVqPIBcfbVr96z81UJMF58426OPjSY6VBdmQP1l/2IxUWq5Gf2V4aFeTKyawFCFyYLESBwOOe8Vc+ULthmksHPi/QPwEJr/0cAbzIYj705T7kJp/itWYojIuZefth
 GutSw7qq
 kR8RUHEp3DOeuckdxbmrAmxl+BCObhVmmDQjBVTjd5FKC4//xFpcaIwcEPU7Ah1F/TfbckSAhz5RydWWdqsU/wXVEfuub96Aqj+9uoL/sP/yNA6QJJ3ReIR4bt0ejks5iVRBOuCJ4YWg6IQFHlPXuu640/7f1WvV/DqlG5OG/Zhj51z9Fn9i3jxxTQ1hIJajt7MufgCHSzf78YzTGorPnu0HqDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On 10/14/25 12:37 AM, Zi Yan wrote:
> On 13 Oct 2025, at 3:23, Qi Zheng wrote:
> 

[snip]

>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b5eea2091cdf6..5353c7bd2c9af 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4286,8 +4286,10 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>          }
>>          folios_put(&fbatch);
>>
>> -       if (sc->nr_to_scan)
>> +       if (sc->nr_to_scan) {
>> +               cond_resched();
>>                  goto retry;
>> +       }
>>
>>          /*
>>           * Stop shrinker if we didn't split any page, but the queue is empty.
>>
> 
> It does not fix the issue, but only gets rid of the soft lockup warning.
> "echo 3 | sudo tee /proc/sys/vm/drop_caches" just runs forever.

Oh, my bad, I didn't notice that.

> 
> Looking at the original code, sc->nr_to_scan was one of the two conditions
> on breaking out of split_queue scanning and was never checked again
> afterwards. When split_queue size is smaller than nr_to_scan, your code
> will retry forever but not the original one. After I added pr_info() to
> print sc->nr_to_scan at
> 1) before retry:,
> 2) before for (... folio_batch_count();...),
> 3) before "if (sc->nr_to_scan)",
> 
> I see that 1) printed 2, 2) and 3) kept printing 1. It matches my
> above guess.

Got it.

> 
> The below patch fixes the issue:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 43a3c499aec0..d38816a0c117 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4415,7 +4415,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   	}
>   	folios_put(&fbatch);
> 
> -	if (sc->nr_to_scan)
> +	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue))
>   		goto retry;
> 
>   	/*
> 

Thanks! After applying this locally, I no longer see softlockup and
no longer see deferred_split_scan() in perf hotspots.

Will do this in the next version.

Thanks,
Qi

> 
> 
>>
>>> [   36.441592] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 48 89 f3 e8 92 68 fd fe 80 e7 02 74 06 fb 0f 1f 44 00 00 <65> ff 0d d0 5f 7e 01 74 06 5b c3 cc cc cc cc 0f 1f 44 00 00 5b c3
>>> [   36.441594] RSP: 0018:ffffc900029afb60 EFLAGS: 00000202
>>> [   36.441598] RAX: 0000000000000001 RBX: 0000000000000286 RCX: ffff888101168670
>>> [   36.441601] RDX: 0000000000000001 RSI: 0000000000000286 RDI: ffff888101168658
>>> [   36.441602] RBP: 0000000000000001 R08: ffff88813ba44ec0 R09: 0000000000000000
>>> [   36.441603] R10: 00000000000001a8 R11: 0000000000000000 R12: ffff8881011685e0
>>> [   36.441604] R13: 0000000000000000 R14: ffff888101168000 R15: ffffc900029afd60
>>> [   36.441606] FS:  00007f7fe3655740(0000) GS:ffff8881b7e5d000(0000) knlGS:0000000000000000
>>> [   36.441607] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   36.441608] CR2: 0000563d4d439bf0 CR3: 000000010873c006 CR4: 0000000000370ef0
>>> [   36.441614] Call Trace:
>>> [   36.441616]  <TASK>
>>> [   36.441619]  deferred_split_scan+0x1e0/0x480
>>> [   36.441627]  ? _raw_spin_unlock_irqrestore+0xe/0x40
>>> [   36.441630]  ? kvfree_rcu_queue_batch+0x96/0x1c0
>>> [   36.441634]  ? do_raw_spin_unlock+0x46/0xd0
>>> [   36.441639]  ? kfree_rcu_monitor+0x1da/0x2c0
>>> [   36.441641]  ? list_lru_count_one+0x47/0x90
>>> [   36.441644]  do_shrink_slab+0x153/0x360
>>> [   36.441649]  shrink_slab+0xd3/0x390
>>> [   36.441652]  drop_slab+0x7d/0x130
>>> [   36.441655]  drop_caches_sysctl_handler+0x98/0xb0
>>> [   36.441660]  proc_sys_call_handler+0x1c7/0x2c0
>>> [   36.441664]  vfs_write+0x221/0x450
>>> [   36.441669]  ksys_write+0x6c/0xe0
>>> [   36.441672]  do_syscall_64+0x50/0x200
>>> [   36.441675]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [   36.441678] RIP: 0033:0x7f7fe36e7687
>>> [   36.441685] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
>>> [   36.441686] RSP: 002b:00007ffdffcbba10 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
>>> [   36.441688] RAX: ffffffffffffffda RBX: 00007f7fe3655740 RCX: 00007f7fe36e7687
>>> [   36.441689] RDX: 0000000000000002 RSI: 00007ffdffcbbbb0 RDI: 0000000000000003
>>> [   36.441690] RBP: 00007ffdffcbbbb0 R08: 0000000000000000 R09: 0000000000000000
>>> [   36.441691] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
>>> [   36.441692] R13: 0000558d40be64c0 R14: 00007f7fe383de80 R15: 0000000000000002
>>> [   36.441694]  </TASK>
>>> [   64.441531] watchdog: BUG: soft lockup - CPU#0 stuck for 53s! [tee:810]
>>> [   64.441537] Modules linked in:
>>> [   64.441545] CPU: 0 UID: 0 PID: 810 Comm: tee Tainted: G             L      6.17.0-mm-everything-2024-01-29-07-19-no-mglru+ #526 PREEMPT(voluntary)
>>> [   64.441548] Tainted: [L]=SOFTLOCKUP
>>> [   64.441552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
>>> [   64.441555] RIP: 0010:_raw_spin_unlock_irqrestore+0x19/0x40
>>> [   64.441565] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 48 89 f3 e8 92 68 fd fe 80 e7 02 74 06 fb 0f 1f 44 00 00 <65> ff 0d d0 5f 7e 01 74 06 5b c3 cc cc cc cc 0f 1f 44 00 00 5b c3
>>> [   64.441566] RSP: 0018:ffffc900029afb60 EFLAGS: 00000202
>>> [   64.441568] RAX: 0000000000000001 RBX: 0000000000000286 RCX: ffff888101168670
>>> [   64.441570] RDX: 0000000000000001 RSI: 0000000000000286 RDI: ffff888101168658
>>> [   64.441571] RBP: 0000000000000001 R08: ffff88813ba44ec0 R09: 0000000000000000
>>> [   64.441572] R10: 00000000000001a8 R11: 0000000000000000 R12: ffff8881011685e0
>>> [   64.441573] R13: 0000000000000000 R14: ffff888101168000 R15: ffffc900029afd60
>>> [   64.441574] FS:  00007f7fe3655740(0000) GS:ffff8881b7e5d000(0000) knlGS:0000000000000000
>>> [   64.441576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   64.441577] CR2: 0000563d4d439bf0 CR3: 000000010873c006 CR4: 0000000000370ef0
>>> [   64.441581] Call Trace:
>>> [   64.441583]  <TASK>
>>> [   64.441591]  deferred_split_scan+0x1e0/0x480
>>> [   64.441598]  ? _raw_spin_unlock_irqrestore+0xe/0x40
>>> [   64.441599]  ? kvfree_rcu_queue_batch+0x96/0x1c0
>>> [   64.441603]  ? do_raw_spin_unlock+0x46/0xd0
>>> [   64.441607]  ? kfree_rcu_monitor+0x1da/0x2c0
>>> [   64.441610]  ? list_lru_count_one+0x47/0x90
>>> [   64.441613]  do_shrink_slab+0x153/0x360
>>> [   64.441618]  shrink_slab+0xd3/0x390
>>> [   64.441621]  drop_slab+0x7d/0x130
>>> [   64.441624]  drop_caches_sysctl_handler+0x98/0xb0
>>> [   64.441629]  proc_sys_call_handler+0x1c7/0x2c0
>>> [   64.441632]  vfs_write+0x221/0x450
>>> [   64.441638]  ksys_write+0x6c/0xe0
>>> [   64.441641]  do_syscall_64+0x50/0x200
>>> [   64.441645]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>> [   64.441648] RIP: 0033:0x7f7fe36e7687
>>> [   64.441654] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
>>> [   64.441656] RSP: 002b:00007ffdffcbba10 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
>>> [   64.441658] RAX: ffffffffffffffda RBX: 00007f7fe3655740 RCX: 00007f7fe36e7687
>>> [   64.441659] RDX: 0000000000000002 RSI: 00007ffdffcbbbb0 RDI: 0000000000000003
>>> [   64.441660] RBP: 00007ffdffcbbbb0 R08: 0000000000000000 R09: 0000000000000000
>>> [   64.441661] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
>>> [   64.441662] R13: 0000558d40be64c0 R14: 00007f7fe383de80 R15: 0000000000000002
>>> [   64.441663]  </TASK>
>>>
>>>
>>>
>>> --
>>> Best Regards,
>>> Yan, Zi
> 
> 
> --
> Best Regards,
> Yan, Zi


