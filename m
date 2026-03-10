Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19CDFD4F03
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC17C6B0005; Tue, 10 Mar 2026 12:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99EC6B0089; Tue, 10 Mar 2026 12:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5276B008A; Tue, 10 Mar 2026 12:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 957B86B0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:11:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40EC216011D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:11:14 +0000 (UTC)
X-FDA: 84530642868.28.9390B92
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9FBE1140006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:11:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b="e7MW2/gF";
	spf=pass (imf09.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.48 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7gMNiH9BdelWvusGd7OrNLFfglJLbH4s0k+LIP9tqQ=;
	b=wlEukhQIn/hWOfOgoVCmKtrMEY++Ied/PBM+g478Kq3zF9uuGYU8LxicEKydAtLObAwZ6M
	r+45Vnldp3SwV2lMYUllz5LtOcQB+IATy6JdyQJsGGbrebDvIsNIYZXVyoStPHqvJR2AVm
	tdrixaRcq1/wl6hJ3VZKVLFO85JVCk8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b="e7MW2/gF";
	spf=pass (imf09.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.48 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159072; a=rsa-sha256;
	cv=none;
	b=edIdgXMTUK9Q+lzJRtyKSm/DEgmZ/jCqB0NfkZejmIsRsWpnLV6KFXWD7iZeMZIWN08mFS
	h3Xlfk56VMuMDzJIAFyggXUu3yq9ue3L9ohIn1sZitzxj5RT8tCy7jfL1UPdL8+Cx29mKB
	N/Kj31bAghQByMAvPErhol0rL2usqdo=
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id ED66A340090;
	Tue, 10 Mar 2026 16:11:07 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 9B00513C2B0;
	Tue, 10 Mar 2026 09:10:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9B00513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773159056;
	bh=5zKbXLO3yRW74LlTEHd2bGno6r91jmuahTP/SPinZUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e7MW2/gFMTBDhQHSAYbjSNqGfEBsd/R5nEC+4Tl+binFtZXIqca+TG/mEIJdyXf70
	 Hoctr3CpTzqAc476951tkL0uNsb3Mjh8Hbr9/bhbxWxfOdsA3v8hUPFgvLpgvf/19o
	 8Kn6WmoP6W3cNsNkn99PuCbEFmlWDlWK22+TGnqU=
Message-ID: <bba74cab-7305-a052-7e1c-7a7736ba4531@candelatech.com>
Date: Tue, 10 Mar 2026 09:10:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>,
 Miriam Rachel <miriam.rachel.korenblit@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
 <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
 <68c1ca1381d1871fff72b211890a64eb@kernel.org>
Content-Language: en-US
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <68c1ca1381d1871fff72b211890a64eb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1773159069-t8kQowwyWApu
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773159069;t8kQowwyWApu;<greearb@candelatech.com>;e39a4ef213bcaa75c219f509376588df
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspamd-Queue-Id: 9FBE1140006
X-Stat-Signature: 7dqmh6j3um9t9dxce1cfpofama5w9kay
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773159071-402331
X-HE-Meta: U2FsdGVkX18BJGCFmS8VwzmDfZhqzCXbIlRZALAptRYF0wyk0xibXtunPtsPWvHeXGUNmKYD9p3gmqojp83f7FGaXtG0AlvqX6Kwdr5mDHg6KPPcBkYbTTQwuQIMLmEogUtU+xkOWxxvX7CV1O6E23TnT9bWug1ZZGO2kPYWCQV6RSZtG1JjHOaWFJpEaCNM5LEVcupGCg/PCubrJIDrxYZ9pnEJpHyncfF8Qe2TRDufTT68e/2HDFbp83ToicLt4AokcVAeD9f6HNM2Hj1GvCS5joL9MjV0QlGiYJv4fWiIegJcjEymWcSdJO1FMhsJd+EbflXK+q8f81V7/TSLL39rBrMpueEUcVZkldLG8d0qpZyK8ZReUyrxHIkx4hbr8wKpbUjHZN9K031lynNTm5DUblRt8teOJlmb/DGKd/mE1CWzmtIOYQQ81gTrVuPO3Rr5XVEPTt6DtGBd7UtaNFWlqNEg/lYsHysPGPFUOIdkiHU9byctziGh1TYcGZHQg/y8mUQaO1k9ApeF1ralPFBG95Hzf++r8vyh05sj7NWJT368KIdFcI4P79obtG+m3CEHjVIo3gG8zqh/vXHUqvjVleVE4Dr41L3NdGFebl4iNu1zxVJNqImlIHlLkIBrMfFTGNVAncI6Xy85ah/Fam0e5y8UW7bkyvBtqQlsxPm/GBGwOTTf7maoZuatxprHGU4Ql7hUr8n/cAbVzclcd4rcZfrQFJiysWYLkkymEFYsWg8gJqhAtIr+89ErhjU2Ffpgj8BRGii4XaLlVORnPhKD1vqpLo6jsoWdOd6XeJ+w9W0LqNdzJf/fQQRt3T4BBFscBmQLvftBnpSCaMs5q2YyFvjaeZhSHcsgo6Tm66rZFt9Ldx+/KubzoEyZU1tETWpsvvKewGxKHiuWG2RInzZv3vjHdogBerEIqhddrgwPwRsS5FNLW5CStEzIPlakeaWTFNGzl6T83dnpY4R
 H8D+wPkM
 9FrvlJVBxyLDPyzO7fLfE6eEkd4SsTDW/kYB+ntyPqtN0Kst0IcfyG3AmVd6SJ8P6C1QwHoHf3Qd+F70sLDBIPX3BbGjAZNLX7BJeLgl9UPelCTjQe7LlShCUAWViyQUwTu4mnyENnaazjGp6UqyIxxiMUmyBFse5Fu8g4dr5x7k8gDyspF89Qbv3qfQbV/mbTxs7Fa1N+/d3YkurzEd1eMKx98lf7pH3NMr17xjewyL9kk6Tm2QKO6O9hBwHU7w14yUO/bxjS4UfAheTN4TCue2T2dwSFBvLYAUoR3usvUnO0MBuZd7jrahqMzJxsgc+LbD+AeO4Mt/KhfaQzjKH+enusnRhXiuiUprje1fC/NrlibVdbuU1KSVK2+fHSMYpQXyS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 09:14, Tejun Heo wrote:
> Hello,
> 
> (Partially drafted with the help of Claude)
> 
> On Tue, Mar 03, 2026 at 04:02:14PM -0800, Ben Greear wrote:
>> Could the logic that detects blocked work-queues instead be instrumented
>> to print out more useful information so that just reproducing the problem
>> and providing dmesg output will be sufficient?  Or does dmesg already provide
>> enough that would give you a clue as to what is going on?
> 
> It may not be exactly the same issue, but Breno just posted a patch that
> might help. The current watchdog only prints backtraces for workers that
> are actively running on CPU, so sleeping culprits are invisible. His
> patch removes that filter so all in-flight workers get printed:
> 
>    http://lkml.kernel.org/r/aag4tTyeiZyw0jID@gmail.com
> 
> Might be worth trying.

Hello Tejun,

I applied the first 4 patches of the v2 of that series to my 6.18.14 kernel, with
my use-kthread-for-regdom patches reverted.

Stock 6.18.16 kernel crashes too often in the wifi driver to reliably reproduce the deadlock
there.

Both the reg_todo and lru_drain are on CPU 5, but I'm not sure if that really
matters.

Does this info below show anything useful to you?

Mar 10 08:59:15 ct523c-2103 kernel: BUG: workqueue lockup - pool cpus=5 node=0 flags=0x0 nice=0 stuck for 57507s!
Mar 10 08:59:15 ct523c-2103 kernel: Showing busy workqueues and worker pools:
Mar 10 08:59:15 ct523c-2103 kernel: workqueue events: flags=0x100
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=2 refcnt=3
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 264128:disconnect_work [cfg80211] for 57502s disconnect_work [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=9 refcnt=10
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 271323:reg_todo [cfg80211] for 57507s
Mar 10 08:59:15 ct523c-2103 kernel:     pending: reg_todo [cfg80211], igb_watchdog_task [igb], output_poll_execute [drm_kms_helper], kernfs_notify_workfn, 
key_garbage_collector, 2*update_super_work, netstamp_clear
Mar 10 08:59:15 ct523c-2103 kernel: workqueue events_unbound: flags=0x2
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=2 refcnt=3
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 236337:cfg80211_wiphy_work [cfg80211] for 57507s cfg80211_wiphy_work [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel: workqueue events_unbound: flags=0x2
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=1 refcnt=2
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 142096:linkwatch_event for 57502s linkwatch_event
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=3 refcnt=4
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 218388:fsnotify_mark_destroy_workfn for 55995s fsnotify_mark_destroy_workfn BAR(1309) 
,267638:fsnotify_connector_destroy_workfn for 55995s fsnotify_connector_destroy_workfn
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=2 refcnt=4
Mar 10 08:59:15 ct523c-2103 kernel: workqueue events_freezable: flags=0x104
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=2
Mar 10 08:59:15 ct523c-2103 kernel:     pending: pci_pme_list_scan
Mar 10 08:59:15 ct523c-2103 kernel: workqueue events_power_efficient: flags=0x180
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 14: cpus=3 node=0 flags=0x0 nice=0 active=2 refcnt=3
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 268226:reg_check_chans_work [cfg80211] for 57441s reg_check_chans_work [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=218 refcnt=219
Mar 10 08:59:15 ct523c-2103 kernel:     pending: gc_worker [nf_conntrack], hub_post_resume, 216*ioc_release_fn
Mar 10 08:59:15 ct523c-2103 kernel: workqueue rcu_gp: flags=0x108
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=2
Mar 10 08:59:15 ct523c-2103 kernel:     pending: process_srcu
Mar 10 08:59:15 ct523c-2103 kernel: workqueue mm_percpu_wq: flags=0x8
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=2 refcnt=4
Mar 10 08:59:15 ct523c-2103 kernel:     pending: lru_add_drain_per_cpu BAR(236337), vmstat_update
Mar 10 08:59:15 ct523c-2103 kernel: workqueue cgroup_offline: flags=0x100
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=107
Mar 10 08:59:15 ct523c-2103 kernel:     pending: css_killed_work_fn
Mar 10 08:59:15 ct523c-2103 kernel:     inactive: 105*css_killed_work_fn
Mar 10 08:59:15 ct523c-2103 kernel: workqueue cgroup_release: flags=0x100
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=15
Mar 10 08:59:15 ct523c-2103 kernel:     pending: css_release_work_fn
Mar 10 08:59:15 ct523c-2103 kernel:     inactive: 13*css_release_work_fn
Mar 10 08:59:15 ct523c-2103 kernel: workqueue cgroup_bpf_destroy: flags=0x100
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=54
Mar 10 08:59:15 ct523c-2103 kernel:     pending: cgroup_bpf_release
Mar 10 08:59:15 ct523c-2103 kernel:     inactive: 52*cgroup_bpf_release
Mar 10 08:59:15 ct523c-2103 kernel: workqueue ipv6_addrconf: flags=0x6000a
Mar 10 08:59:15 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=1 refcnt=14
Mar 10 08:59:15 ct523c-2103 kernel:     in-flight: 202972:addrconf_dad_work for 57505s
Mar 10 08:59:15 ct523c-2103 kernel:     inactive: 4*addrconf_verify_work
Mar 10 08:59:15 ct523c-2103 kernel: pool 2: cpus=0 node=0 flags=0x0 nice=0 hung=0s workers=3 idle: 203067 243191
Mar 10 08:59:15 ct523c-2103 kernel: pool 14: cpus=3 node=0 flags=0x0 nice=0 hung=0s workers=3 idle: 709498 699449
Mar 10 08:59:15 ct523c-2103 kernel: pool 22: cpus=5 node=0 flags=0x0 nice=0 hung=57507s workers=3 idle: 166929 260518
Mar 10 08:59:15 ct523c-2103 kernel: pool 32: cpus=0-7 flags=0x4 nice=0 hung=0s workers=9 idle: 631693 712021 717023 671858
Mar 10 08:59:15 ct523c-2103 kernel: Showing backtraces of busy workers in stalled CPU-bound worker pools:
Mar 10 08:59:15 ct523c-2103 kernel: pool 22:
Mar 10 08:59:15 ct523c-2103 kernel: task:kworker/5:2     state:D stack:0     pid:271323 tgid:271323 ppid:2      task_flags:0x4208060 flags:0x00080000
Mar 10 08:59:15 ct523c-2103 kernel: Workqueue: events reg_todo [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel: Call Trace:
Mar 10 08:59:15 ct523c-2103 kernel:  <TASK>
Mar 10 08:59:15 ct523c-2103 kernel:  __schedule+0x106f/0x4340
Mar 10 08:59:15 ct523c-2103 kernel:  ? lock_acquire+0x155/0x2e0
Mar 10 08:59:15 ct523c-2103 kernel:  ? io_schedule_timeout+0x150/0x150
Mar 10 08:59:15 ct523c-2103 kernel:  ? __schedule+0x1865/0x4340
Mar 10 08:59:15 ct523c-2103 kernel:  preempt_schedule_notrace+0x4c/0x70
Mar 10 08:59:15 ct523c-2103 kernel:  preempt_schedule_notrace_thunk+0x16/0x30
Mar 10 08:59:15 ct523c-2103 kernel:  rcu_is_watching+0x59/0x70
Mar 10 08:59:15 ct523c-2103 kernel:  lock_acquire+0x291/0x2e0
Mar 10 08:59:15 ct523c-2103 kernel:  schedule+0x211/0x3a0
Mar 10 08:59:15 ct523c-2103 kernel:  ? schedule+0x1f2/0x3a0
Mar 10 08:59:15 ct523c-2103 kernel:  schedule_preempt_disabled+0x11/0x20
Mar 10 08:59:15 ct523c-2103 kernel:  __mutex_lock+0xd02/0x1d60
Mar 10 08:59:15 ct523c-2103 kernel:  ? reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:  ? ww_mutex_lock+0x160/0x160
Mar 10 08:59:15 ct523c-2103 kernel:  ? __mutex_unlock_slowpath+0x15d/0x770
Mar 10 08:59:15 ct523c-2103 kernel:  ? wait_for_completion_io_timeout+0x20/0x20
Mar 10 08:59:15 ct523c-2103 kernel:  ? reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:  reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:  reg_todo+0x52e/0x7c0 [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:  ? lock_release+0xce/0x290
Mar 10 08:59:15 ct523c-2103 kernel:  process_one_work+0x88b/0x1820
Mar 10 08:59:15 ct523c-2103 kernel:  ? pwq_dec_nr_in_flight+0xe00/0xe00
Mar 10 08:59:15 ct523c-2103 kernel:  ? reg_process_hint+0x1480/0x1480 [cfg80211]
Mar 10 08:59:15 ct523c-2103 kernel:  worker_thread+0x5a1/0xfd0
Mar 10 08:59:15 ct523c-2103 kernel:  ? __kthread_parkme+0xc6/0x1f0
Mar 10 08:59:15 ct523c-2103 kernel:  ? rescuer_thread+0x1350/0x1350
Mar 10 08:59:15 ct523c-2103 kernel:  kthread+0x3b7/0x770
Mar 10 08:59:15 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:15 ct523c-2103 kernel:  ? ret_from_fork+0x17/0x3a0
Mar 10 08:59:15 ct523c-2103 kernel:  ? lock_release+0xce/0x290
Mar 10 08:59:15 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:15 ct523c-2103 kernel:  ret_from_fork+0x28b/0x3a0
Mar 10 08:59:15 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:15 ct523c-2103 kernel:  ret_from_fork_asm+0x11/0x20
Mar 10 08:59:15 ct523c-2103 kernel:  </TASK>
Mar 10 08:59:46 ct523c-2103 kernel: BUG: workqueue lockup - pool cpus=5 node=0 flags=0x0 nice=0 stuck for 57537s!
Mar 10 08:59:46 ct523c-2103 kernel: Showing busy workqueues and worker pools:
Mar 10 08:59:46 ct523c-2103 kernel: workqueue events: flags=0x100
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=2 refcnt=3
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 264128:disconnect_work [cfg80211] for 57533s disconnect_work [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=9 refcnt=10
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 271323:reg_todo [cfg80211] for 57537s
Mar 10 08:59:46 ct523c-2103 kernel:     pending: reg_todo [cfg80211], igb_watchdog_task [igb], output_poll_execute [drm_kms_helper], kernfs_notify_workfn, 
key_garbage_collector, 2*update_super_work, netstamp_clear
Mar 10 08:59:46 ct523c-2103 kernel: workqueue events_unbound: flags=0x2
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=2 refcnt=3
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 236337:cfg80211_wiphy_work [cfg80211] for 57537s cfg80211_wiphy_work [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel: workqueue events_unbound: flags=0x2
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=1 refcnt=2
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 142096:linkwatch_event for 57533s linkwatch_event
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=3 refcnt=4
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 218388:fsnotify_mark_destroy_workfn for 56026s fsnotify_mark_destroy_workfn BAR(1309) 
,267638:fsnotify_connector_destroy_workfn for 56026s fsnotify_connector_destroy_workfn
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=2 refcnt=4
Mar 10 08:59:46 ct523c-2103 kernel: workqueue events_freezable: flags=0x104
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=2
Mar 10 08:59:46 ct523c-2103 kernel:     pending: pci_pme_list_scan
Mar 10 08:59:46 ct523c-2103 kernel: workqueue events_power_efficient: flags=0x180
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 14: cpus=3 node=0 flags=0x0 nice=0 active=2 refcnt=3
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 268226:reg_check_chans_work [cfg80211] for 57472s reg_check_chans_work [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=218 refcnt=219
Mar 10 08:59:46 ct523c-2103 kernel:     pending: gc_worker [nf_conntrack], hub_post_resume, 216*ioc_release_fn
Mar 10 08:59:46 ct523c-2103 kernel: workqueue rcu_gp: flags=0x108
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=2
Mar 10 08:59:46 ct523c-2103 kernel:     pending: process_srcu
Mar 10 08:59:46 ct523c-2103 kernel: workqueue mm_percpu_wq: flags=0x8
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=2 refcnt=4
Mar 10 08:59:46 ct523c-2103 kernel:     pending: lru_add_drain_per_cpu BAR(236337), vmstat_update
Mar 10 08:59:46 ct523c-2103 kernel: workqueue cgroup_offline: flags=0x100
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=107
Mar 10 08:59:46 ct523c-2103 kernel:     pending: css_killed_work_fn
Mar 10 08:59:46 ct523c-2103 kernel:     inactive: 105*css_killed_work_fn
Mar 10 08:59:46 ct523c-2103 kernel: workqueue cgroup_release: flags=0x100
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=15
Mar 10 08:59:46 ct523c-2103 kernel:     pending: css_release_work_fn
Mar 10 08:59:46 ct523c-2103 kernel:     inactive: 13*css_release_work_fn
Mar 10 08:59:46 ct523c-2103 kernel: workqueue cgroup_bpf_destroy: flags=0x100
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 22: cpus=5 node=0 flags=0x0 nice=0 active=1 refcnt=54
Mar 10 08:59:46 ct523c-2103 kernel:     pending: cgroup_bpf_release
Mar 10 08:59:46 ct523c-2103 kernel:     inactive: 52*cgroup_bpf_release
Mar 10 08:59:46 ct523c-2103 kernel: workqueue ipv6_addrconf: flags=0x6000a
Mar 10 08:59:46 ct523c-2103 kernel:   pwq 32: cpus=0-7 flags=0x4 nice=0 active=1 refcnt=14
Mar 10 08:59:46 ct523c-2103 kernel:     in-flight: 202972:addrconf_dad_work for 57536s
Mar 10 08:59:46 ct523c-2103 kernel:     inactive: 4*addrconf_verify_work
Mar 10 08:59:46 ct523c-2103 kernel: pool 2: cpus=0 node=0 flags=0x0 nice=0 hung=0s workers=3 idle: 203067 243191
Mar 10 08:59:46 ct523c-2103 kernel: pool 14: cpus=3 node=0 flags=0x0 nice=0 hung=0s workers=3 idle: 709498 699449
Mar 10 08:59:46 ct523c-2103 kernel: pool 22: cpus=5 node=0 flags=0x0 nice=0 hung=57537s workers=3 idle: 166929 260518
Mar 10 08:59:46 ct523c-2103 kernel: pool 32: cpus=0-7 flags=0x4 nice=0 hung=0s workers=9 idle: 631693 712021 717023 671858
Mar 10 08:59:46 ct523c-2103 kernel: Showing backtraces of busy workers in stalled CPU-bound worker pools:
Mar 10 08:59:46 ct523c-2103 kernel: pool 22:
Mar 10 08:59:46 ct523c-2103 kernel: task:kworker/5:2     state:D stack:0     pid:271323 tgid:271323 ppid:2      task_flags:0x4208060 flags:0x00080000
Mar 10 08:59:46 ct523c-2103 kernel: Workqueue: events reg_todo [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel: Call Trace:
Mar 10 08:59:46 ct523c-2103 kernel:  <TASK>
Mar 10 08:59:46 ct523c-2103 kernel:  __schedule+0x106f/0x4340
Mar 10 08:59:46 ct523c-2103 kernel:  ? lock_acquire+0x155/0x2e0
Mar 10 08:59:46 ct523c-2103 kernel:  ? io_schedule_timeout+0x150/0x150
Mar 10 08:59:46 ct523c-2103 kernel:  ? __schedule+0x1865/0x4340
Mar 10 08:59:46 ct523c-2103 kernel:  preempt_schedule_notrace+0x4c/0x70
Mar 10 08:59:46 ct523c-2103 kernel:  preempt_schedule_notrace_thunk+0x16/0x30
Mar 10 08:59:46 ct523c-2103 kernel:  rcu_is_watching+0x59/0x70
Mar 10 08:59:46 ct523c-2103 kernel:  lock_acquire+0x291/0x2e0
Mar 10 08:59:46 ct523c-2103 kernel:  schedule+0x211/0x3a0
Mar 10 08:59:46 ct523c-2103 kernel:  ? schedule+0x1f2/0x3a0
Mar 10 08:59:46 ct523c-2103 kernel:  schedule_preempt_disabled+0x11/0x20
Mar 10 08:59:46 ct523c-2103 kernel:  __mutex_lock+0xd02/0x1d60
Mar 10 08:59:46 ct523c-2103 kernel:  ? reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:  ? ww_mutex_lock+0x160/0x160
Mar 10 08:59:46 ct523c-2103 kernel:  ? __mutex_unlock_slowpath+0x15d/0x770
Mar 10 08:59:46 ct523c-2103 kernel:  ? wait_for_completion_io_timeout+0x20/0x20
Mar 10 08:59:46 ct523c-2103 kernel:  ? reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:  reg_process_self_managed_hints+0x70/0x190 [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:  reg_todo+0x52e/0x7c0 [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:  ? lock_release+0xce/0x290
Mar 10 08:59:46 ct523c-2103 kernel:  process_one_work+0x88b/0x1820
Mar 10 08:59:46 ct523c-2103 kernel:  ? pwq_dec_nr_in_flight+0xe00/0xe00
Mar 10 08:59:46 ct523c-2103 kernel:  ? reg_process_hint+0x1480/0x1480 [cfg80211]
Mar 10 08:59:46 ct523c-2103 kernel:  worker_thread+0x5a1/0xfd0
Mar 10 08:59:46 ct523c-2103 kernel:  ? __kthread_parkme+0xc6/0x1f0
Mar 10 08:59:46 ct523c-2103 kernel:  ? rescuer_thread+0x1350/0x1350
Mar 10 08:59:46 ct523c-2103 kernel:  kthread+0x3b7/0x770
Mar 10 08:59:46 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:46 ct523c-2103 kernel:  ? ret_from_fork+0x17/0x3a0
Mar 10 08:59:46 ct523c-2103 kernel:  ? lock_release+0xce/0x290
Mar 10 08:59:46 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:46 ct523c-2103 kernel:  ret_from_fork+0x28b/0x3a0
Mar 10 08:59:46 ct523c-2103 kernel:  ? kthread_is_per_cpu+0xb0/0xb0
Mar 10 08:59:46 ct523c-2103 kernel:  ret_from_fork_asm+0x11/0x20
Mar 10 08:59:46 ct523c-2103 kernel:  </TASK>


>> If I were to attempt to use AI on the coredump, would echoing 'c' to
>> /proc/sysrq-trigger with kdump enabled (when deadlock is happening) be
>> the appropriate action to grab the core file?
> 
> Yes, that's right, but you need to set up kdump first. The quickest way
> depends on your distro:
> 
>   - Fedora/RHEL: dnf install kexec-tools, then kdumpctl reset-crashkernel,
>     systemctl enable --now kdump
>   - Ubuntu/Debian: apt install kdump-tools (say Yes to enable), reboot
>   - Arch: Install kexec-tools, add crashkernel=512M to your kernel
>     cmdline, create a kdump.service that runs
>     kexec -p /boot/vmlinuz-linux --initrd=/boot/initramfs-linux.img \
>       --append="root=<your-root> irqpoll nr_cpus=1 reset_devices"
> 
> After reboot, verify with: cat /sys/kernel/kexec_crash_size (should be
> non-zero). Then when the deadlock happens:
> 
>    echo c > /proc/sysrq-trigger

I have kdump enabled already, and I could create a vmcore like this.
I have never used drgn, nor claude.  Based on the logs above, do
you still think it would be helpful to try drgn?  If so, can you please
suggest some commands or approaches specific to this particular bug?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



