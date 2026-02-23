Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FEC3EEC2A7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EFB6B0088; Mon, 23 Feb 2026 17:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2BA6B0089; Mon, 23 Feb 2026 17:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D23E6B008A; Mon, 23 Feb 2026 17:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 548336B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:37:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA3A8C182D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:37:06 +0000 (UTC)
X-FDA: 84477183252.10.D75CDDB
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE322C000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:37:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=pAHMxp2s;
	spf=pass (imf10.hostedemail.com: domain of greearb@candelatech.com designates 67.231.154.164 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886225; a=rsa-sha256;
	cv=none;
	b=pAxtoOhMIaErs1JJqAjBWdCh/Wwcq8mCDRsM0yOtwMTw83TPeeqXgbjSzQc5o1kfhgPDil
	ubhvkf38qYujSUaItAk72zVs6ZMG+01Zbjw/0oYIb4wbXNVSNebGVxGp0lIY7w5RTuXaH6
	TB0dw1XwewvT0dKu8w0mKVQQEZKTVrk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=pAHMxp2s;
	spf=pass (imf10.hostedemail.com: domain of greearb@candelatech.com designates 67.231.154.164 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OF9p2agWahBRk7VOzNcwsqytaNVpfBKZA5Zh/yM81FE=;
	b=2TCFhR1GRVFWfaX9PBs26wwCOrW8OvTKDX9gUy00nnuyoQTzuKXNFiHqrh8r2deuNUTK6U
	hQgUzweaN+l3FUnhUvJvhJ/U+rbKtqeI5iYKhm9NyCJZCnILpZzE3Y+Tm5W6T9RJjRrW3v
	VRcnvp+02KwfHMW85QzQzkyRO6O38G4=
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 833B68009F;
	Mon, 23 Feb 2026 22:37:02 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id BAE8B13C2B0;
	Mon, 23 Feb 2026 14:36:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com BAE8B13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1771886219;
	bh=+dzfRX+/7KZQ7kExwjLInaDSQKSXZQgfryBFtUpv0Lg=;
	h=Date:From:Subject:To:Cc:From;
	b=pAHMxp2s7joRoXtlo7Ff+sOREmu6g6DFiPxDI6pMe1NpWxOP/71ZSFUFZAA4WMydz
	 kO3CbRIyKukzXpj/YGoafkziKStM6XujPUXFnMIleqfusNAhs+vfjaypcMzXxUL0xk
	 nuQHg0+mh5O6ePEq/xpw6O6w6xNHomUGjEmnOHug=
Message-ID: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
Date: Mon, 23 Feb 2026 14:36:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Ben Greear <greearb@candelatech.com>
Subject: 6.18.13 iwlwifi deadlock allocating cma while work-item is active.
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Language: en-US
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org
Organization: Candela Technologies
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1771886223-o1PH0_X3mhbN
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1771886223;o1PH0_X3mhbN;<greearb@candelatech.com>;658153cfc100a5dd9cb264d465e97528
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspamd-Queue-Id: CE322C000A
X-Stat-Signature: m48ar8suesaxx8jjntdadtnstkf47c1d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771886224-993839
X-HE-Meta: U2FsdGVkX1+uwBgOYBRqnvlIvcC0Pe0fanKEOt2T8LcnlNUyFJ3lYJXJlnlDQ7SPmD+O8iabf8KL4zCAJpDGh8AwXmcZ9iew9GHvZpJHPENe11VxXk9QuH+MG1Rcc8ieSO7a+SyLfSbsWenAVDIf6LhPTYSyzpdaXGkWcyZFUZuEfm9IKCVIUaQr5TXNZ/jPUsdvjVy9DEyiy2KH+J2mz7R31xaCA47w0VA95jw5EjMSDrHpwa0gmiZged+YoGOWEFtfNTwwilWlqIRr97IXYYfvteWstJ4nS54J0RA65pponfJ8kk4yhTu1vduqPHEbugnez3qVHoMBGhL01msj6ajU1UeJy1EWZVn4YwR/zK0pSAxwm5eh+p3AtinE+nZMhFY0UvXNpCBNDj5c/U96U0aBRtHx2RrwOrNVi1q8hu421QjrI/m5MzNFy/XlDikfjNuTuTIseLIZIzzl4ZYlO885/S6feRfCfxyiujnfB4A3VUhHyr3yV6/quwym6LdoZgVjOVPGVaXD5o82cIiPbVAtzByNqgbmezwA1PHg9/J/PocXQVeHuJdT8XzDM7jglq+7PYwVHItSVkDLHN8iLr1XoeSgKEJTFWdK1eiUW5M0zyZ5cMpqiRcoHbCzXg+7LJTUN64H2Z1xBo5VKgPrPTu8cVkJMbAaEQB4U9GY+V4UYOTp7d3OBSU4C3xzOftlXejkwqqmb4OaF5N5SKk0pwRL1BJ3fneHZDkDScaSYqnIiNrRT2IrsCzRdmzP6q3zqCz+K4E86ub7Hyks5kdoE4aVx3TeAGC+bmRGGXeNRRWFo9fwt8sb1Ze3eD+PWmt5UR8DJKn3Tcy37+YaXx7pK2nujMlScsFKe+9zJ1I8LjsSs016ubCqXOlnp/nCM7GVmtatToRhAZXylyFn7iOUKwk7b78wCmz1ab0Tn2IyhpbP2YDCmERlsg9UKMGefmYiKQONGOtVtRQOwiGhwb6
 PqtV9HSU
 5SfAdD2BMGDnv+BwchUC9ol80zV5/QFF6++lvpu8xwt4B4/y15U3CFs9ZT2bCedX7uUB7PhtonhTC+CG2xxt268bx2tPke4ep5I6MJctvR7B0PbEV14M7iYcI+NuC04cCYLTVmAQNkk08mzFTV7StMCl40i7jZ9XizKK2drhMgABL++jaU/xB2AXvY40Vv0hUrYRAice+4XFAquUQ2UpNNCKrgYEnvuy9mup2bXjdYFgRftRqeeS99Acz5lVkT+pFJ9SAaFlpvBJnXopY/qnCWIS6eNC4ZgLLmCCL3HcOBiJdsSg7r/weWEUZ+d3GZkMb9cz8ldM8E16o54I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I hit a deadlock related to CMA mem allocation attempting to flush all work
while holding some wifi related mutex, and with a work-queue attempting to process a wifi regdomain
work item.  I really don't see any good way to fix this,
it would seem that any code that was holding a mutex that could block a work-queue
cannot safely allocate CMA memory?  Hopefully someone else has a better idea.

For whatever reason, my hacked up kernel will print out the sysrq process stack traces I need
to understand this, and my stable 6.18.13 will not.  But, the locks-held matches in both cases, so almost
certainly this is same problem.  I can reproduce the same problem on both un-modified stable
and my own.  The details below are from my modified 6.18.9+ kernel.

I only hit this (reliably?) with a KASAN enabled kernel, likely because it makes things slow enough to
hit the problem and/or causes CMA allocations in a different manner.

General way to reproduce is to have large amounts of intel be200 radios in a system, and bring them
admin up and down.


## From 6.18.13 (un-modified)

40479 Feb 23 14:13:31 ct523c-de7c kernel: 5 locks held by kworker/u32:11/34989:
40480 Feb 23 14:13:31 ct523c-de7c kernel:  #0: ffff888120161148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0xf7a/0x17b0
40481 Feb 23 14:13:31 ct523c-de7c kernel:  #1: ffff8881a561fd20 ((work_completion)(&rdev->wiphy_work)){+.+.}-{0:0}, at: process_one_work+0x7ca/0x17b0
40482 Feb 23 14:13:31 ct523c-de7c kernel:  #2: ffff88815e618788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_wiphy_work+0x5c/0x570 [cfg80211]
40483 Feb 23 14:13:31 ct523c-de7c kernel:  #3: ffffffff87232e60 (&cma->alloc_mutex){+.+.}-{4:4}, at: __cma_alloc+0x3c5/0xd20
40484 Feb 23 14:13:31 ct523c-de7c kernel:  #4: ffffffff8534f668 (lock#5){+.+.}-{4:4}, at: __lru_add_drain_all+0x5f/0x530

40488 Feb 23 14:13:31 ct523c-de7c kernel: 4 locks held by kworker/1:0/39480:
40489 Feb 23 14:13:31 ct523c-de7c kernel:  #0: ffff88812006b148 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0xf7a/0x17b0
40490 Feb 23 14:13:31 ct523c-de7c kernel:  #1: ffff88814087fd20 (reg_work){+.+.}-{0:0}, at: process_one_work+0x7ca/0x17b0
40491 Feb 23 14:13:31 ct523c-de7c kernel:  #2: ffffffff85970028 (rtnl_mutex){+.+.}-{4:4}, at: reg_todo+0x18/0x770 [cfg80211]
40492 Feb 23 14:13:31 ct523c-de7c kernel:  #3: ffff88815e618788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: reg_process_self_managed_hints+0x70/0x190 [cfg80211]


## Rest of this is from my 6.18.9+ hacks kernel.

### thread trying to allocate cma is blocked here, trying to flush work.

Type "apropos word" to search for commands related to "word"...
Reading symbols from vmlinux...
(gdb) l *(alloc_contig_range_noprof+0x1de)
0xffffffff8162453e is in alloc_contig_range_noprof (/home2/greearb/git/linux-6.18.dev.y/mm/page_alloc.c:6798).
6793			.reason = MR_CONTIG_RANGE,
6794		};
6795	
6796		lru_cache_disable();
6797	
6798		while (pfn < end || !list_empty(&cc->migratepages)) {
6799			if (fatal_signal_pending(current)) {
6800				ret = -EINTR;
6801				break;
6802			}
(gdb) l *(__lru_add_drain_all+0x19b)
0xffffffff815ae44b is in __lru_add_drain_all (/home2/greearb/git/linux-6.18.dev.y/mm/swap.c:884).
879				queue_work_on(cpu, mm_percpu_wq, work);
880				__cpumask_set_cpu(cpu, &has_work);
881			}
882		}
883	
884		for_each_cpu(cpu, &has_work)
885			flush_work(&per_cpu(lru_add_drain_work, cpu));
886	
887	done:
888		mutex_unlock(&lock);
(gdb)


#### and other thread is trying to process a regdom request, and trying to use
# rcu and rtnl???

Type "apropos word" to search for commands related to "word"...
Reading symbols from net/wireless/cfg80211.ko...
(gdb) l *(reg_todo+0x18)
0xe238 is in reg_todo (/home2/greearb/git/linux-6.18.dev.y/net/wireless/reg.c:3107).
3102	 */
3103	static void reg_process_pending_hints(void)
3104	{
3105		struct regulatory_request *reg_request, *lr;
3106	
3107		lr = get_last_request();
3108	
3109		/* When last_request->processed becomes true this will be rescheduled */
3110		if (lr && !lr->processed) {
3111			pr_debug("Pending regulatory request, waiting for it to be processed...\n");
(gdb)

static struct regulatory_request *get_last_request(void)
{
	return rcu_dereference_rtnl(last_request);
}


task:kworker/6:0     state:D stack:0     pid:56    tgid:56    ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events reg_todo [cfg80211]
Call Trace:
  <TASK>
  __schedule+0x526/0x1290
  preempt_schedule_notrace+0x35/0x50
  preempt_schedule_notrace_thunk+0x16/0x30
  rcu_is_watching+0x2a/0x30
  lock_acquire+0x26d/0x2c0
  schedule+0xac/0x120
  ? schedule+0x8d/0x120
  schedule_preempt_disabled+0x11/0x20
  __mutex_lock+0x726/0x1070
  ? reg_todo+0x18/0x2b0 [cfg80211]
  ? reg_todo+0x18/0x2b0 [cfg80211]
  reg_todo+0x18/0x2b0 [cfg80211]
  process_one_work+0x221/0x6d0
  worker_thread+0x1e5/0x3b0
  ? rescuer_thread+0x450/0x450
  kthread+0x108/0x220
  ? kthreads_online_cpu+0x110/0x110
  ret_from_fork+0x1c6/0x220
  ? kthreads_online_cpu+0x110/0x110
  ret_from_fork_asm+0x11/0x20
  </TASK>

task:ip              state:D stack:0     pid:72857 tgid:72857 ppid:72843  task_flags:0x400100 flags:0x00080001
Call Trace:
  <TASK>
  __schedule+0x526/0x1290
  ? schedule+0x8d/0x120
  ? schedule+0xe2/0x120
  schedule+0x36/0x120
  schedule_timeout+0xf9/0x110
  ? mark_held_locks+0x40/0x70
  __wait_for_common+0xbe/0x1e0
  ? hrtimer_nanosleep_restart+0x120/0x120
  ? __flush_work+0x20b/0x530
  __flush_work+0x34e/0x530
  ? flush_workqueue_prep_pwqs+0x160/0x160
  ? bpf_prog_test_run_tracing+0x160/0x2d0
  __lru_add_drain_all+0x19b/0x220
  alloc_contig_range_noprof+0x1de/0x8a0
  __cma_alloc+0x1f1/0x6a0
  __dma_direct_alloc_pages.isra.0+0xcb/0x2f0
  dma_direct_alloc+0x7b/0x250
  dma_alloc_attrs+0xa1/0x2a0
  _iwl_pcie_ctxt_info_dma_alloc_coherent+0x31/0xb0 [iwlwifi]
  iwl_pcie_ctxt_info_alloc_dma+0x20/0x50 [iwlwifi]
  iwl_pcie_init_fw_sec+0x2fc/0x380 [iwlwifi]
  iwl_pcie_ctxt_info_v2_alloc+0x19e/0x530 [iwlwifi]
  iwl_trans_pcie_gen2_start_fw+0x2e2/0x820 [iwlwifi]
  ? lock_is_held_type+0x92/0x100
  iwl_trans_start_fw+0x77/0x90 [iwlwifi]
  iwl_mld_load_fw_wait_alive+0x97/0x2c0 [iwlmld]
  ? iwl_mld_mac80211_sta_state+0x780/0x780 [iwlmld]
  ? lock_is_held_type+0x92/0x100
  iwl_mld_load_fw+0x91/0x240 [iwlmld]
  ? ieee80211_open+0x3d/0xe0 [mac80211]
  ? lock_is_held_type+0x92/0x100
  iwl_mld_start_fw+0x44/0x470 [iwlmld]
  iwl_mld_mac80211_start+0x3d/0x1b0 [iwlmld]
  drv_start+0x6f/0x1d0 [mac80211]
  ieee80211_do_open+0x2d6/0x960 [mac80211]
  ieee80211_open+0x62/0xe0 [mac80211]
  __dev_open+0x11a/0x2e0
  __dev_change_flags+0x1f8/0x280
  netif_change_flags+0x22/0x60
  do_setlink.isra.0+0xe57/0x11a0
  ? __mutex_lock+0xb0/0x1070
  ? __mutex_lock+0x99e/0x1070
  ? __nla_validate_parse+0x5e/0xcd0
  ? rtnl_newlink+0x355/0xb50
  ? cap_capable+0x90/0x100
  ? security_capable+0x72/0x80
  rtnl_newlink+0x7e8/0xb50
  ? __lock_acquire+0x436/0x2190
  ? lock_acquire+0xc2/0x2c0
  ? rtnetlink_rcv_msg+0x97/0x660
  ? find_held_lock+0x2b/0x80
  ? do_setlink.isra.0+0x11a0/0x11a0
  ? rtnetlink_rcv_msg+0x3ea/0x660
  ? lock_release+0xcc/0x290
  ? do_setlink.isra.0+0x11a0/0x11a0
  rtnetlink_rcv_msg+0x409/0x660
  ? rtnl_fdb_dump+0x240/0x240
  netlink_rcv_skb+0x56/0x100
  netlink_unicast+0x1e1/0x2d0
  netlink_sendmsg+0x219/0x460
  __sock_sendmsg+0x38/0x70
  ____sys_sendmsg+0x214/0x280
  ? import_iovec+0x2c/0x30
  ? copy_msghdr_from_user+0x6c/0xa0
  ___sys_sendmsg+0x85/0xd0
  ? __lock_acquire+0x436/0x2190
  ? find_held_lock+0x2b/0x80
  ? lock_acquire+0xc2/0x2c0
  ? mntput_no_expire+0x43/0x460
  ? find_held_lock+0x2b/0x80
  ? mntput_no_expire+0x8c/0x460
  __sys_sendmsg+0x6b/0xc0
  do_syscall_64+0x6b/0x11b0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


