Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680ACCCD187
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 00:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10818E0032; Fri, 10 Oct 2025 20:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8A98E001F; Fri, 10 Oct 2025 20:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925AB8E0032; Fri, 10 Oct 2025 20:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80FCB8E001F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:51:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17BDE8789C
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:51:42 +0000 (UTC)
X-FDA: 83984005644.13.6FA6AE6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 00EAF4000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:51:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFicWbmx;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760143900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIam4ujNL/Ie85vosujHwjjM/d/jgUrGDFalDqtFhCU=;
	b=26j7pFR8OeM19MwhotSXYUgZ0gffcIwBJ94JCw7BaLBtkET25zIrAS54LNidAJ7mIAIr5+
	VZ33smwTnUOuCG+TIFR2M1B2A/kBUD35pNgTnNotmJKDhoDV2dikpd8azt0wUpBUhIm8Fx
	GPE0fp9WY8Ecs829KJnPJzWoxtOVSeU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFicWbmx;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760143900; a=rsa-sha256;
	cv=none;
	b=yAgUNzf5ow2QrZKvVwllTHrHrq86dviKE79oWAPZvq4jm1s+q/Mk1nsrIT3McWjw3ktl0P
	cK9xnG1X/o1Y6nylfIbPvzmdffgP0xstw+VE/FROd9gOKwMyTZboYB6anyMoqjAKXmaG0r
	Y+vatwVOXOGfbs8YmxJURUEeAOGIs+c=
Message-ID: <4a134193-ee55-434c-98a9-ca3052bab11b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760143897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIam4ujNL/Ie85vosujHwjjM/d/jgUrGDFalDqtFhCU=;
	b=JFicWbmx54XTw/3fjNm3twhl80Llah6xCiNTVQWu57Zfig07BK7KIF1sA5K+kWewZWoWcQ
	627kNzvNqbtU7YIE8uduiQAaIo241BI2XIQ6bkOhkvV0FD1Ka5I3VAkvkctMG2brKhnYGL
	q7tp57h1/xyuEBS0FsiiITxLfQFoCV4=
Date: Sat, 11 Oct 2025 08:51:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/4] reparent the THP split queue
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <925E0247-2976-4D85-A8AA-E8C92C64CED4@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <925E0247-2976-4D85-A8AA-E8C92C64CED4@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 00EAF4000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8eqcmgnyojxgienq7z15df6m5g3id75d
X-HE-Tag: 1760143899-995598
X-HE-Meta: U2FsdGVkX181e7xvcsE1K87s5iUjFK37TIv8/koDrHhrp0sEkbf/ZA3gQQNXL6q87Lbr5vER6ZqBOS7HI/RFiETZdrAJd+a/355gZqFqSRt5e1/eXfrUGQGRK1dgrqWAdXjF90sEzNEmNG364LUMiyjoxaRXm19CxOhilh3LC4suVLUEF4EJcTATeAzDyAt8ztBkksTj59SXANkL6IW4rJd2MeNL/5YMObuwl64TOWI0uPzOy82qGGV6lfoZKLbaGvZq363ggr1DOmAPtAnLcxfEwDQ7itjV81PDLgr0S63Ep0ymTKx35KD+KPzNwcutxfoSEFFfZ5Q8Zlryu14BkAqDyt0g69wnXFygjnUlp4pFJBiu+eGa6Xr25HQyP6MGWT6vvg5y4DisOKlORq4871lmqh3E57Vc3b74iqMsekabYJtT6d9ko/52iXPzUVx84pJx9jjkT1CxTgtWbIYMyrZFTfcc6oXYk/esTYWnFerW2G69s1iEOXXAG23hfOEJS8WcvpoYz5tlfOv9clvWBuPlkvev08UWNQOssWyhkCn360HTth3ew7v1n933c0rPOH58TzUzOjPfAQVnjkvLZ8M5OpZTcLDxnPvrHPWQsQMmo6fyxskWSfVI5yTxCN/6fjH3EbMnOaCwHVcp7qWpWcHpkADgKVqMota3S7UXdSmY9G6TDBpQGSP5KJu0LtZc0QrarDHaHKjbqmvqlFW2AiRAUGCc3sAf8WjRFWKPDELJ1LVFRTCiwtNenGfHDTgTyACbhuNm2X/5pDUeX4OvXfFjrxMO4iwyh/JJPh2hcXcKqjk1V/J7TMY5ohYdl7VrBh9vGrtVYKV8KMlqxl6+lHWlRLzP55SItx57Yn0h2194xJs3fRHE8MklWklrlUYtMuxPWAZX3JXyUTIlBgMvQIx9IHJAIkrEJjyGhc5Nwag6zW290UrkSAhnwBqR1GN31Q1m7FH7G3E+tEWzbjK
 TR/14BWU
 8f06Nuk9ZAZTYqfJJl++JP7r7/zEHBK9/6XcXUXCu06yjffWWTTaA0Q3PP/LpzhwacQwTBG4s6JS0/lLVyCJDfp9MBzDRaXPiH/I14wNEaX0/amO+Yt4gkyZyH1xVBwLQvHVEWWtIpQpf6wI1tSW5NZiooQ8uiU/J9jxdSKAYhNYesbD4a/Rjk9E0YfePOY45rL0NYFLo7sAFLT++Es53SjaZrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On 10/11/25 12:25 AM, Zi Yan wrote:
> On 3 Oct 2025, at 12:53, Qi Zheng wrote:
> 

[snip]

>>
> 
> Hi Qi,
> 
> I got CPU soft locks when run "echo 3 | sudo tee /proc/sys/vm/drop_caches"
> with today's mm-new on a freshly booted system. Reverting Patch 3 (and Patch 4)
> of your patchset solves the issue.
> 
> My config file is attached. My kernel relevant kernel parameters are:
> "cgroup_no_v1=all transparent_hugepage=always thp_shmem=2M:always".
> The machine is a 8GB 8-core x86_64 VM.

Thanks for your report. I'm on vacation and will be back in two days,
I'll try to reproduce it locally and fix it.

And hi Andrew, please help drop this patch set from mm-new first.

Thanks,
Qi

> 
> The kernel log:
> 
> [   36.441539] watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [tee:810]
> [   36.441549] Modules linked in:
> [   36.441566] CPU: 0 UID: 0 PID: 810 Comm: tee Not tainted 6.17.0-mm-everything-2024-01-29-07-19-no-mglru+ #526 PREEMPT(voluntary)
> [   36.441570] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> [   36.441574] RIP: 0010:_raw_spin_unlock_irqrestore+0x19/0x40
> [   36.441592] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 48 89 f3 e8 92 68 fd fe 80 e7 02 74 06 fb 0f 1f 44 00 00 <65> ff 0d d0 5f 7e 01 74 06 5b c3 cc cc cc cc 0f 1f 44 00 00 5b c3
> [   36.441594] RSP: 0018:ffffc900029afb60 EFLAGS: 00000202
> [   36.441598] RAX: 0000000000000001 RBX: 0000000000000286 RCX: ffff888101168670
> [   36.441601] RDX: 0000000000000001 RSI: 0000000000000286 RDI: ffff888101168658
> [   36.441602] RBP: 0000000000000001 R08: ffff88813ba44ec0 R09: 0000000000000000
> [   36.441603] R10: 00000000000001a8 R11: 0000000000000000 R12: ffff8881011685e0
> [   36.441604] R13: 0000000000000000 R14: ffff888101168000 R15: ffffc900029afd60
> [   36.441606] FS:  00007f7fe3655740(0000) GS:ffff8881b7e5d000(0000) knlGS:0000000000000000
> [   36.441607] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   36.441608] CR2: 0000563d4d439bf0 CR3: 000000010873c006 CR4: 0000000000370ef0
> [   36.441614] Call Trace:
> [   36.441616]  <TASK>
> [   36.441619]  deferred_split_scan+0x1e0/0x480
> [   36.441627]  ? _raw_spin_unlock_irqrestore+0xe/0x40
> [   36.441630]  ? kvfree_rcu_queue_batch+0x96/0x1c0
> [   36.441634]  ? do_raw_spin_unlock+0x46/0xd0
> [   36.441639]  ? kfree_rcu_monitor+0x1da/0x2c0
> [   36.441641]  ? list_lru_count_one+0x47/0x90
> [   36.441644]  do_shrink_slab+0x153/0x360
> [   36.441649]  shrink_slab+0xd3/0x390
> [   36.441652]  drop_slab+0x7d/0x130
> [   36.441655]  drop_caches_sysctl_handler+0x98/0xb0
> [   36.441660]  proc_sys_call_handler+0x1c7/0x2c0
> [   36.441664]  vfs_write+0x221/0x450
> [   36.441669]  ksys_write+0x6c/0xe0
> [   36.441672]  do_syscall_64+0x50/0x200
> [   36.441675]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   36.441678] RIP: 0033:0x7f7fe36e7687
> [   36.441685] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> [   36.441686] RSP: 002b:00007ffdffcbba10 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   36.441688] RAX: ffffffffffffffda RBX: 00007f7fe3655740 RCX: 00007f7fe36e7687
> [   36.441689] RDX: 0000000000000002 RSI: 00007ffdffcbbbb0 RDI: 0000000000000003
> [   36.441690] RBP: 00007ffdffcbbbb0 R08: 0000000000000000 R09: 0000000000000000
> [   36.441691] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   36.441692] R13: 0000558d40be64c0 R14: 00007f7fe383de80 R15: 0000000000000002
> [   36.441694]  </TASK>
> [   64.441531] watchdog: BUG: soft lockup - CPU#0 stuck for 53s! [tee:810]
> [   64.441537] Modules linked in:
> [   64.441545] CPU: 0 UID: 0 PID: 810 Comm: tee Tainted: G             L      6.17.0-mm-everything-2024-01-29-07-19-no-mglru+ #526 PREEMPT(voluntary)
> [   64.441548] Tainted: [L]=SOFTLOCKUP
> [   64.441552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> [   64.441555] RIP: 0010:_raw_spin_unlock_irqrestore+0x19/0x40
> [   64.441565] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 53 48 89 f3 e8 92 68 fd fe 80 e7 02 74 06 fb 0f 1f 44 00 00 <65> ff 0d d0 5f 7e 01 74 06 5b c3 cc cc cc cc 0f 1f 44 00 00 5b c3
> [   64.441566] RSP: 0018:ffffc900029afb60 EFLAGS: 00000202
> [   64.441568] RAX: 0000000000000001 RBX: 0000000000000286 RCX: ffff888101168670
> [   64.441570] RDX: 0000000000000001 RSI: 0000000000000286 RDI: ffff888101168658
> [   64.441571] RBP: 0000000000000001 R08: ffff88813ba44ec0 R09: 0000000000000000
> [   64.441572] R10: 00000000000001a8 R11: 0000000000000000 R12: ffff8881011685e0
> [   64.441573] R13: 0000000000000000 R14: ffff888101168000 R15: ffffc900029afd60
> [   64.441574] FS:  00007f7fe3655740(0000) GS:ffff8881b7e5d000(0000) knlGS:0000000000000000
> [   64.441576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   64.441577] CR2: 0000563d4d439bf0 CR3: 000000010873c006 CR4: 0000000000370ef0
> [   64.441581] Call Trace:
> [   64.441583]  <TASK>
> [   64.441591]  deferred_split_scan+0x1e0/0x480
> [   64.441598]  ? _raw_spin_unlock_irqrestore+0xe/0x40
> [   64.441599]  ? kvfree_rcu_queue_batch+0x96/0x1c0
> [   64.441603]  ? do_raw_spin_unlock+0x46/0xd0
> [   64.441607]  ? kfree_rcu_monitor+0x1da/0x2c0
> [   64.441610]  ? list_lru_count_one+0x47/0x90
> [   64.441613]  do_shrink_slab+0x153/0x360
> [   64.441618]  shrink_slab+0xd3/0x390
> [   64.441621]  drop_slab+0x7d/0x130
> [   64.441624]  drop_caches_sysctl_handler+0x98/0xb0
> [   64.441629]  proc_sys_call_handler+0x1c7/0x2c0
> [   64.441632]  vfs_write+0x221/0x450
> [   64.441638]  ksys_write+0x6c/0xe0
> [   64.441641]  do_syscall_64+0x50/0x200
> [   64.441645]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   64.441648] RIP: 0033:0x7f7fe36e7687
> [   64.441654] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> [   64.441656] RSP: 002b:00007ffdffcbba10 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> [   64.441658] RAX: ffffffffffffffda RBX: 00007f7fe3655740 RCX: 00007f7fe36e7687
> [   64.441659] RDX: 0000000000000002 RSI: 00007ffdffcbbbb0 RDI: 0000000000000003
> [   64.441660] RBP: 00007ffdffcbbbb0 R08: 0000000000000000 R09: 0000000000000000
> [   64.441661] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> [   64.441662] R13: 0000558d40be64c0 R14: 00007f7fe383de80 R15: 0000000000000002
> [   64.441663]  </TASK>
> 
> 
> 
> --
> Best Regards,
> Yan, Zi


