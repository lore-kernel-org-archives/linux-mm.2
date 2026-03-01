Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC515FD006D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 15:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D1E6B0005; Sun,  1 Mar 2026 10:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B516B0089; Sun,  1 Mar 2026 10:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B174E6B008A; Sun,  1 Mar 2026 10:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0C16B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 10:39:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23AE48C1B0
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 15:39:05 +0000 (UTC)
X-FDA: 84497902650.13.D5C8A13
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD085160011
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 15:39:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=qadnz9rL;
	dmarc=pass (policy=none) header.from=candelatech.com;
	spf=pass (imf08.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.49 as permitted sender) smtp.mailfrom=greearb@candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772379543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BismZSRrBf+z++Qsvkhm1tubZQP2aVKGTiMSsA3iJxE=;
	b=UCl2M8ivY0b0vq8zsAx8H12t618/TZv6IeTgsLjNwgXH1N4XQfSKugwo7kRLPMSTGtVwIS
	UXDmrs9rDvuEBxotCKIHuPoXdYJy1yPz9Qv/fU1a6m3UZ4Y8MsBvNg63Jk8zymS+OoUKZs
	DHCdE5WRKLKiVxlktJT5t7QZ/wVXgvA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=qadnz9rL;
	dmarc=pass (policy=none) header.from=candelatech.com;
	spf=pass (imf08.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.49 as permitted sender) smtp.mailfrom=greearb@candelatech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772379543; a=rsa-sha256;
	cv=none;
	b=Z5aOb8ABYdhmIcD6wSlG4nfUAXNSZeDl2K7vyjmc3I/r2x60l2vUoJ3+qn8Vdj8ES/vp7T
	WvfnAydgrosYlTKcx1BO4ML07Nl7YV+1v5v3HZR15qYOJNBWrmPVH2vmzK4vyQ08C5t/dB
	xKprDXGg11VV3MijLXVW2ShEC83YDM8=
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3CB23240065;
	Sun,  1 Mar 2026 15:38:59 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.32.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 4BAE813C2B0;
	Sun,  1 Mar 2026 07:38:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4BAE813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772379536;
	bh=qEr2l/Te22ZAYWyNXEGL/xG/+OSoihFBTypgRiRG594=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=qadnz9rLgosQuCM8kaNx8pQceAoq2rPcrSZDjNm0XhTwKR6u4wvaNb7GJDlJqvo5u
	 p1ncepMTHTUYOuIglT3B7waopNqF3G+4R1sfiPGvnodul5LRHN9gkGSezBCYo35wzd
	 TuXkES1zQdBnLQn1UUHhveM/8sG7Nnlw2Knz+Olc=
Message-ID: <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
Date: Sun, 1 Mar 2026 07:38:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Ben Greear <greearb@candelatech.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
Content-Language: en-MW
Organization: Candela Technologies
In-Reply-To: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1772379540-FaKU9DVRI0xH
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1772379540;FaKU9DVRI0xH;<greearb@candelatech.com>;658153cfc100a5dd9cb264d465e97528
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD085160011
X-Stat-Signature: 8wb8tn3knkyjw45ndsoweuiy5ug7xxhf
X-Rspam-User: 
X-HE-Tag: 1772379542-330537
X-HE-Meta: U2FsdGVkX1/R3V3hYHmTfedmrPPwZ6onL4XNo1WL/9DbdAT58cFm3v3Ukt9IQzVD4Zblzk1891ZEDRsRiSNURF5gvoaygXqheQr4cuvdwLyhew+M2uczFLukO0Al/1bNlfd3AqNJt/+MWpylMsxlFXqOAMoIER0pRTHQJS/xF222l7SUkbkJ2thcTxT4v30vBJW5P9rfu9HCOz4FizWIAci5u3gRb3y17XxPHpUUn/CBKAUqKSFVpxHZWCuwA0CbyqhHjjsta/8ZP79QLdMDNzKOixntFTCy0XmhLx2UNu4nmlFYw9i0eCQIL26g7eZH+Fy7nZE8HYaiGDu8WiPJXt1pCBMa34rciZ5EMuetDrSdd85eZXWb71mIG96okH7ebC0bvvk+gKIVTNVBmoKq5sLH0/CrOLJAZ4Ef79T/jql5Qa3bbHa7DWJrCfYgk5xSejb1AjU7Kpv3vD/NO/qdwsPo6qRTPc9gfnuQj7OOVPizK+/1dvCgTVFDsaDpeUkxJQvRgBKfRflEaiZ5oZwYuoHsxygddV9CLT9Eu34pmEXOekoqEn1jaZMYB5l1WtnluU4I//SgpQKafpzNVmRZJhHex7x1yn2CI4OM/KPQ31iQ7o2/EAdWc+7LX5zOlsj9YjIx+hIYDsxCGC7OLE/T2BRa/XIibVN+cTQa1ObJ2PaWx35CIwQ6tHglqZ/yQYi4dPfE7OnPWJ/PuyzOLF984gEThnbuv1FwXhgVGkJucmqPgz435OClA5BpZQJT8PYRzqsEGe+/LMh5j8i1y2shN3obBxTXP1uNO4wlCTFq8hEgxsOvOVE6CnP79Ne2ZztivJ+SSUdaXKlwaa5wANce1rlSmkZHrukQpQFXRqt6Cj4Dpmg+w0ixUv1wumkyMqoM4dmIg2/qgjVBopleXgnv73Vku0E85CjuxZV5R5y3ekAeTKDsuHqDgBieK/5QLMoP0SOcp3F/jun45YahHaQ
 WD/VS9P2
 /5tmMCBOPLcVv/SX+hM3n6EVFtTWgGNp9qOBCuw3x4AlYm8M0PllLWE73ymysvbFZHNqqI4axPq4r58+kJL1Bo9JpMx8QXlUDL8Zio8OfhZAuy9QQjKc632k9cnRAKMatWTnGjsrr/V/lukO441u2uKo7e0JTwwGike/V/OOgmI3IaCIkJsaVpIkyBWyVEB3q8zfYzjNutrQIWmT5mRMM1qhkk2V7njaPBTQMxABAX0irzt9YKga5FLsoLy+9tlwh3aSOqdcsVeo85At4E4SHa/ZNjAUOtGOU9M+CwvCYVguruZ4bQGxbub4dU4EMZtb5amVmAzXys5Qj1/zuSvCYreqqApB28eG4nrNakAMyUFaHBLjEIRRtmWbBuOtsSNHHpVrl57WsptmOKBoLCNFRjcjQlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 08:31, Ben Greear wrote:
> On 2/23/26 14:36, Ben Greear wrote:
>> Hello,
>>
>> I hit a deadlock related to CMA mem allocation attempting to flush all work
>> while holding some wifi related mutex, and with a work-queue attempting to process a wifi regdomain
>> work item.  I really don't see any good way to fix this,
>> it would seem that any code that was holding a mutex that could block a work-queue
>> cannot safely allocate CMA memory?  Hopefully someone else has a better idea.
> 
> I tried using a kthread to do the regulatory domain processing instead of worker item,
> and that seems to have solved the problem.  If that seems reasonable approach to
> wifi stack folks, I can post a patch.

The other net/wireless work-item 'disconnect_work' also needs to be moved to the kthread
for the same reason....

Thanks,
Ben

>> For whatever reason, my hacked up kernel will print out the sysrq process stack traces I need
>> to understand this, and my stable 6.18.13 will not.  But, the locks-held matches in both cases, so almost
>> certainly this is same problem.  I can reproduce the same problem on both un-modified stable
>> and my own.  The details below are from my modified 6.18.9+ kernel.
>>
>> I only hit this (reliably?) with a KASAN enabled kernel, likely because it makes things slow enough to
>> hit the problem and/or causes CMA allocations in a different manner.
>>
>> General way to reproduce is to have large amounts of intel be200 radios in a system, and bring them
>> admin up and down.
>>
>>
>> ## From 6.18.13 (un-modified)
>>
>> 40479 Feb 23 14:13:31 ct523c-de7c kernel: 5 locks held by kworker/u32:11/34989:
>> 40480 Feb 23 14:13:31 ct523c-de7c kernel:  #0: ffff888120161148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0xf7a/0x17b0
>> 40481 Feb 23 14:13:31 ct523c-de7c kernel:  #1: ffff8881a561fd20 ((work_completion)(&rdev->wiphy_work)){+.+.}-{0:0}, at: process_one_work+0x7ca/0x17b0
>> 40482 Feb 23 14:13:31 ct523c-de7c kernel:  #2: ffff88815e618788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_wiphy_work+0x5c/0x570 [cfg80211]
>> 40483 Feb 23 14:13:31 ct523c-de7c kernel:  #3: ffffffff87232e60 (&cma->alloc_mutex){+.+.}-{4:4}, at: __cma_alloc+0x3c5/0xd20
>> 40484 Feb 23 14:13:31 ct523c-de7c kernel:  #4: ffffffff8534f668 (lock#5){+.+.}-{4:4}, at: __lru_add_drain_all+0x5f/0x530
>>
>> 40488 Feb 23 14:13:31 ct523c-de7c kernel: 4 locks held by kworker/1:0/39480:
>> 40489 Feb 23 14:13:31 ct523c-de7c kernel:  #0: ffff88812006b148 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0xf7a/0x17b0
>> 40490 Feb 23 14:13:31 ct523c-de7c kernel:  #1: ffff88814087fd20 (reg_work){+.+.}-{0:0}, at: process_one_work+0x7ca/0x17b0
>> 40491 Feb 23 14:13:31 ct523c-de7c kernel:  #2: ffffffff85970028 (rtnl_mutex){+.+.}-{4:4}, at: reg_todo+0x18/0x770 [cfg80211]
>> 40492 Feb 23 14:13:31 ct523c-de7c kernel:  #3: ffff88815e618788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: reg_process_self_managed_hints+0x70/0x190 [cfg80211]
>>
>>
>> ## Rest of this is from my 6.18.9+ hacks kernel.
>>
>> ### thread trying to allocate cma is blocked here, trying to flush work.
>>
>> Type "apropos word" to search for commands related to "word"...
>> Reading symbols from vmlinux...
>> (gdb) l *(alloc_contig_range_noprof+0x1de)
>> 0xffffffff8162453e is in alloc_contig_range_noprof (/home2/greearb/git/linux-6.18.dev.y/mm/page_alloc.c:6798).
>> 6793            .reason = MR_CONTIG_RANGE,
>> 6794        };
>> 6795
>> 6796        lru_cache_disable();
>> 6797
>> 6798        while (pfn < end || !list_empty(&cc->migratepages)) {
>> 6799            if (fatal_signal_pending(current)) {
>> 6800                ret = -EINTR;
>> 6801                break;
>> 6802            }
>> (gdb) l *(__lru_add_drain_all+0x19b)
>> 0xffffffff815ae44b is in __lru_add_drain_all (/home2/greearb/git/linux-6.18.dev.y/mm/swap.c:884).
>> 879                queue_work_on(cpu, mm_percpu_wq, work);
>> 880                __cpumask_set_cpu(cpu, &has_work);
>> 881            }
>> 882        }
>> 883
>> 884        for_each_cpu(cpu, &has_work)
>> 885            flush_work(&per_cpu(lru_add_drain_work, cpu));
>> 886
>> 887    done:
>> 888        mutex_unlock(&lock);
>> (gdb)
>>
>>
>> #### and other thread is trying to process a regdom request, and trying to use
>> # rcu and rtnl???
>>
>> Type "apropos word" to search for commands related to "word"...
>> Reading symbols from net/wireless/cfg80211.ko...
>> (gdb) l *(reg_todo+0x18)
>> 0xe238 is in reg_todo (/home2/greearb/git/linux-6.18.dev.y/net/wireless/reg.c:3107).
>> 3102     */
>> 3103    static void reg_process_pending_hints(void)
>> 3104    {
>> 3105        struct regulatory_request *reg_request, *lr;
>> 3106
>> 3107        lr = get_last_request();
>> 3108
>> 3109        /* When last_request->processed becomes true this will be rescheduled */
>> 3110        if (lr && !lr->processed) {
>> 3111            pr_debug("Pending regulatory request, waiting for it to be processed...\n");
>> (gdb)
>>
>> static struct regulatory_request *get_last_request(void)
>> {
>>      return rcu_dereference_rtnl(last_request);
>> }
>>
>>
>> task:kworker/6:0     state:D stack:0     pid:56    tgid:56    ppid:2      task_flags:0x4208060 flags:0x00080000
>> Workqueue: events reg_todo [cfg80211]
>> Call Trace:
>>   <TASK>
>>   __schedule+0x526/0x1290
>>   preempt_schedule_notrace+0x35/0x50
>>   preempt_schedule_notrace_thunk+0x16/0x30
>>   rcu_is_watching+0x2a/0x30
>>   lock_acquire+0x26d/0x2c0
>>   schedule+0xac/0x120
>>   ? schedule+0x8d/0x120
>>   schedule_preempt_disabled+0x11/0x20
>>   __mutex_lock+0x726/0x1070
>>   ? reg_todo+0x18/0x2b0 [cfg80211]
>>   ? reg_todo+0x18/0x2b0 [cfg80211]
>>   reg_todo+0x18/0x2b0 [cfg80211]
>>   process_one_work+0x221/0x6d0
>>   worker_thread+0x1e5/0x3b0
>>   ? rescuer_thread+0x450/0x450
>>   kthread+0x108/0x220
>>   ? kthreads_online_cpu+0x110/0x110
>>   ret_from_fork+0x1c6/0x220
>>   ? kthreads_online_cpu+0x110/0x110
>>   ret_from_fork_asm+0x11/0x20
>>   </TASK>
>>
>> task:ip              state:D stack:0     pid:72857 tgid:72857 ppid:72843  task_flags:0x400100 flags:0x00080001
>> Call Trace:
>>   <TASK>
>>   __schedule+0x526/0x1290
>>   ? schedule+0x8d/0x120
>>   ? schedule+0xe2/0x120
>>   schedule+0x36/0x120
>>   schedule_timeout+0xf9/0x110
>>   ? mark_held_locks+0x40/0x70
>>   __wait_for_common+0xbe/0x1e0
>>   ? hrtimer_nanosleep_restart+0x120/0x120
>>   ? __flush_work+0x20b/0x530
>>   __flush_work+0x34e/0x530
>>   ? flush_workqueue_prep_pwqs+0x160/0x160
>>   ? bpf_prog_test_run_tracing+0x160/0x2d0
>>   __lru_add_drain_all+0x19b/0x220
>>   alloc_contig_range_noprof+0x1de/0x8a0
>>   __cma_alloc+0x1f1/0x6a0
>>   __dma_direct_alloc_pages.isra.0+0xcb/0x2f0
>>   dma_direct_alloc+0x7b/0x250
>>   dma_alloc_attrs+0xa1/0x2a0
>>   _iwl_pcie_ctxt_info_dma_alloc_coherent+0x31/0xb0 [iwlwifi]
>>   iwl_pcie_ctxt_info_alloc_dma+0x20/0x50 [iwlwifi]
>>   iwl_pcie_init_fw_sec+0x2fc/0x380 [iwlwifi]
>>   iwl_pcie_ctxt_info_v2_alloc+0x19e/0x530 [iwlwifi]
>>   iwl_trans_pcie_gen2_start_fw+0x2e2/0x820 [iwlwifi]
>>   ? lock_is_held_type+0x92/0x100
>>   iwl_trans_start_fw+0x77/0x90 [iwlwifi]
>>   iwl_mld_load_fw_wait_alive+0x97/0x2c0 [iwlmld]
>>   ? iwl_mld_mac80211_sta_state+0x780/0x780 [iwlmld]
>>   ? lock_is_held_type+0x92/0x100
>>   iwl_mld_load_fw+0x91/0x240 [iwlmld]
>>   ? ieee80211_open+0x3d/0xe0 [mac80211]
>>   ? lock_is_held_type+0x92/0x100
>>   iwl_mld_start_fw+0x44/0x470 [iwlmld]
>>   iwl_mld_mac80211_start+0x3d/0x1b0 [iwlmld]
>>   drv_start+0x6f/0x1d0 [mac80211]
>>   ieee80211_do_open+0x2d6/0x960 [mac80211]
>>   ieee80211_open+0x62/0xe0 [mac80211]
>>   __dev_open+0x11a/0x2e0
>>   __dev_change_flags+0x1f8/0x280
>>   netif_change_flags+0x22/0x60
>>   do_setlink.isra.0+0xe57/0x11a0
>>   ? __mutex_lock+0xb0/0x1070
>>   ? __mutex_lock+0x99e/0x1070
>>   ? __nla_validate_parse+0x5e/0xcd0
>>   ? rtnl_newlink+0x355/0xb50
>>   ? cap_capable+0x90/0x100
>>   ? security_capable+0x72/0x80
>>   rtnl_newlink+0x7e8/0xb50
>>   ? __lock_acquire+0x436/0x2190
>>   ? lock_acquire+0xc2/0x2c0
>>   ? rtnetlink_rcv_msg+0x97/0x660
>>   ? find_held_lock+0x2b/0x80
>>   ? do_setlink.isra.0+0x11a0/0x11a0
>>   ? rtnetlink_rcv_msg+0x3ea/0x660
>>   ? lock_release+0xcc/0x290
>>   ? do_setlink.isra.0+0x11a0/0x11a0
>>   rtnetlink_rcv_msg+0x409/0x660
>>   ? rtnl_fdb_dump+0x240/0x240
>>   netlink_rcv_skb+0x56/0x100
>>   netlink_unicast+0x1e1/0x2d0
>>   netlink_sendmsg+0x219/0x460
>>   __sock_sendmsg+0x38/0x70
>>   ____sys_sendmsg+0x214/0x280
>>   ? import_iovec+0x2c/0x30
>>   ? copy_msghdr_from_user+0x6c/0xa0
>>   ___sys_sendmsg+0x85/0xd0
>>   ? __lock_acquire+0x436/0x2190
>>   ? find_held_lock+0x2b/0x80
>>   ? lock_acquire+0xc2/0x2c0
>>   ? mntput_no_expire+0x43/0x460
>>   ? find_held_lock+0x2b/0x80
>>   ? mntput_no_expire+0x8c/0x460
>>   __sys_sendmsg+0x6b/0xc0
>>   do_syscall_64+0x6b/0x11b0
>>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>
>> Thanks,
>> Ben
>>
> 
> 

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


