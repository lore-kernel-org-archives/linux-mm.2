Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7DC87FCA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 00:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AA16B0088; Sun,  3 Aug 2025 20:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBBE6B0089; Sun,  3 Aug 2025 20:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAF36B008A; Sun,  3 Aug 2025 20:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB7AE6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 20:58:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A6FE816C2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 00:58:34 +0000 (UTC)
X-FDA: 83737264548.27.C19FF9F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DB3A1C000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 00:58:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bbvQ6Mgu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf18.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.12) smtp.mailfrom=yi1.lai@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754269111; a=rsa-sha256;
	cv=none;
	b=ytU4Z+GJXaAvUYn9Q0rZnhwytcWCR70+bYNboQkVZIFlH1nNU7DnoGszAeiB4o9a7myR4V
	jqykCGyHu+1RLtw2vSmjrfMKew2rixZ1AohhBbCSeI5vmfmx+cpRXV29U/81s2eG365vvI
	bAQsK8Yy3mVI6yld88AL4tEEUBD4PrI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bbvQ6Mgu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf18.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.12) smtp.mailfrom=yi1.lai@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754269111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UYjnqAk7SDz5PvUehVHpwEivmskliE/GU/rqz99vw8=;
	b=LW/KtC9+SIluGCtBmAi1FkfKTNXHG/V85PGSh5g7Ygzh6GUTjI3epbO1FeOCxCp8SLH4TT
	EUSVc8J2Jz5650OFjFLW8iq1MVl4c9mq4u/09zFhRARsyPu5etI0Yizs0rX0nVFwUkQrKk
	KVaJHPUVqgudgMQO/CJLSsrFa5qdmwo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754269110; x=1785805110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=SQYN2R4YXfj7xQVwvVAISUDTHapzmBiANMNJEXaT95E=;
  b=bbvQ6Mgu9fmRMOahFDJ4X5CP2tg61uloOxPGBSsdlQyA8BVS1AD7knec
   4HQ1ecPrP0zDQzDwtxwJTYg2S4HdWIOhq19kmPVS8+ZdmWLvH2rQ/MhV6
   FrPfFIIDDJRKqF5Dl7YmgqdXbi8MaZ879i4+zommFK7jj8pkT5Igm9S/M
   DhQPI2NkcyIM2HOx45jrRFnFBve8WTKjOGU/gaQjgE6C1RcKesyW/i4mB
   iqqVCz2zFmax7actvYI2U0DEJEJ3omAmpBM0CWuwWpYnUhg4tNLK2xPHM
   IQtWA5Xvt+o+03hUcke07HO9Q7418155TM1RB8tcp49uT4NP4cHuL+CC0
   g==;
X-CSE-ConnectionGUID: WAnl2158TN+/Z0RJ8iFODQ==
X-CSE-MsgGUID: 2yJgkJjhS76O74hNBfC1gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="60336670"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="60336670"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 17:58:28 -0700
X-CSE-ConnectionGUID: rXIaq9wTSZiHVswaFhFznw==
X-CSE-MsgGUID: vh6wataPQ3OyVOCG30xPWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164360906"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.53])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2025 17:58:25 -0700
Date: Mon, 4 Aug 2025 08:58:21 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
Message-ID: <aJAFrYfyzGpbm+0m@ly-workstation>
References: <20250607220150.2980-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250607220150.2980-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DB3A1C000B
X-Stat-Signature: azg7jcrn9yigbgz8pymhuzq4jmtow4hu
X-Rspam-User: 
X-HE-Tag: 1754269110-269684
X-HE-Meta: U2FsdGVkX18v96T0rD1F8a4YAsl1+EQMeupanf7TQK5N8Ut24T6Y7/eyHvs+ZZreNEampMNn9W494jWho0vLHeJiQy9tIGkNxReLyiH9knr7Ai4j4vfxXKH5fqyPggbfzG8svZUCShVrgvSSymwEeGPtplSH3BDpYRNZGlJNfXczRNxjz2+TsYVVP7PEmdaNDpXH8Z7hUzNn/3fAkowTncQsdz+14CljMTtRbykZ93CbyWEcKEaXXCh1X814XGajblWOu2awrOo94eXSwO1+UVBWC2tWU25YE291z8VAiocD7CBT6253/I7ZCG5WQ4c7ZZnev1G5MqQ3+To1tvp7oZ3ghdzMEHiPZkWpZjhZmrWgUotV7Iq18sLDK2WPdb+HUVsdrzN6FwSGB9KzK9KrDJ5ZnvYBHVM7s2vIVvV6udV7qPFz2Jy3I3Z1iVI4dL4bREYOsRSHf4AwMJTNU7e8Z5PbXSKnA8TUGzHbHM1X4JeVNrckfC+QNDguLy+lZIA6ogCEqxdJIXazULlPbe8r/iKvr8lJf4+6l3pUOWwMrRnvFbnxJyb68TocXfNHw7H4A43UDRXb6ItL3JCGbBWF3l+5/Le0jLNIQYgsoQXpIyeA98AZ/I7Tf1eLlCxZJ6WnJy0huDloEYwNeNERu3okq83QN9LBm63IlCe86A//FGokpQT8+8hCsLDgZWYaH4IJ8ZNran0FX+1A625T9XnJt8UrBt162DnqR1ubc7vlBELbsx4uub1RYR87KAZzqxHGF7a6zhUplunCtGBbHAUdiMVYs6yH0XiYX0fNcUEOacLTsku4gdS9GFLbyB7Di6wPhxCFoZ+aecdn8utPHAozrkXXpNoZ+P0hyQ9fPJMZYxuzdmKeP/xvyItglpZFOeGoxsYv/BFFDuSSu4cUTf+4Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry Song,

Greetings!

I used Syzkaller and found that there is general protection fault in __pte_offset_map_lock in linux-next next-20250801.

After bisection and the first bad commit is:
"
a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log

"
[   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
[   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
[   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
[   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
[   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
[   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
[   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
[   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
[   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
[   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
[   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
[   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
[   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
[   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
[   38.168812] PKRU: 55555554
[   38.169275] Call Trace:
[   38.169647]  <TASK>
[   38.169975]  ? __kasan_check_byte+0x19/0x50
[   38.170581]  lock_acquire+0xea/0x310
[   38.171083]  ? rcu_is_watching+0x19/0xc0
[   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   38.173130]  _raw_spin_lock+0x38/0x50
[   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
[   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
[   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
[   38.175724]  ? __pfx_pud_val+0x10/0x10
[   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[   38.177183]  unmap_page_range+0xb60/0x43e0
[   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
[   38.178485]  ? mas_next_slot+0x133a/0x1a50
[   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
[   38.179830]  unmap_vmas+0x1fa/0x460
[   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
[   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[   38.181877]  exit_mmap+0x1a2/0xb40
[   38.182396]  ? lock_release+0x14f/0x2c0
[   38.182929]  ? __pfx_exit_mmap+0x10/0x10
[   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[   38.184188]  ? mutex_unlock+0x16/0x20
[   38.184704]  mmput+0x132/0x370
[   38.185208]  do_exit+0x7e7/0x28c0
[   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
[   38.186328]  ? do_group_exit+0x1d8/0x2c0
[   38.186873]  ? __pfx_do_exit+0x10/0x10
[   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
[   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
[   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
[   38.189313]  do_group_exit+0xe4/0x2c0
[   38.189831]  __x64_sys_exit_group+0x4d/0x60
[   38.190413]  x64_sys_call+0x2174/0x2180
[   38.190935]  do_syscall_64+0x6d/0x2e0
[   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   38.192118] RIP: 0033:0x7f97fab18a4d
[   38.192614] Code: Unable to access opcode bytes at 0x7f97fab18a23.
[   38.193552] RSP: 002b:00007ffd957e62d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   38.194557] RAX: ffffffffffffffda RBX: 00007f97fabf69e0 RCX: 00007f97fab18a4d
[   38.195472] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 0000000000000000
[   38.196388] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
[   38.197357] R10: 00007ffd957e6180 R11: 0000000000000246 R12: 00007f97fabf69e0
[   38.198273] R13: 00007f97fabfbf00 R14: 0000000000000001 R15: 00007f97fabfbee8
[   38.199205]  </TASK>
[   38.199512] Modules linked in:
[   38.200069] ---[ end trace 0000000000000000 ]---
[   38.200678] RIP: 0010:kasan_byte_accessible+0x15/0x30
[   38.201443] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
[   38.203815] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
[   38.204503] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
[   38.205492] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
[   38.206428] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
[   38.207350] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
[   38.208269] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
[   38.209270] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
[   38.210329] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.211080] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
[   38.211999] PKRU: 55555554
[   38.212374] note: repro[721] exited with preempt_count 1
[   38.213121] Fixing recursive fault but reboot is needed!
[   38.213815] BUG: using smp_processor_id() in preemptible [00000000] code: repro/721
[   38.214856] caller is debug_smp_processor_id+0x20/0x30
[   38.215553] CPU: 0 UID: 0 PID: 721 Comm: repro Tainted: G      D             6.16.0-next-20250801-next-2025080 #1 PR
[   38.215588] Tainted: [D]=DIE
[   38.215595] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
[   38.215611] Call Trace:
[   38.215617]  <TASK>
[   38.215626]  dump_stack_lvl+0x121/0x150
[   38.215657]  dump_stack+0x19/0x20
[   38.215685]  check_preemption_disabled+0x168/0x180
[   38.215722]  ? do_task_dead+0x48/0x120
[   38.215753]  debug_smp_processor_id+0x20/0x30
[   38.215788]  __schedule+0xd9/0x3840
[   38.215827]  ? __pfx___schedule+0x10/0x10
[   38.215860]  ? do_task_dead+0xae/0x120
[   38.215888]  ? do_task_dead+0x48/0x120
[   38.215917]  ? debug_smp_processor_id+0x20/0x30
[   38.215953]  ? rcu_is_watching+0x19/0xc0
[   38.215978]  ? trace_irq_enable+0xd1/0x110
[   38.216017]  ? do_task_dead+0x48/0x120
[   38.216046]  do_task_dead+0xe6/0x120
[   38.216076]  make_task_dead+0x384/0x3c0
[   38.216116]  rewind_stack_and_make_dead+0x16/0x20
[   38.216143] RIP: 0033:0x7f97fab18a4d
[   38.216159] Code: Unable to access opcode bytes at 0x7f97fab18a23.
[   38.216170] RSP: 002b:00007ffd957e62d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   38.216190] RAX: ffffffffffffffda RBX: 00007f97fabf69e0 RCX: 00007f97fab18a4d
[   38.216205] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 0000000000000000
[   38.216220] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
[   38.216234] R10: 00007ffd957e6180 R11: 0000000000000246 R12: 00007f97fabf69e0
[   38.216248] R13: 00007f97fabfbf00 R14: 0000000000000001 R15: 00007f97fabfbee8
[   38.216279]  </TASK>
[   38.216287] BUG: scheduling while atomic: repro/721/0x00000000
[   38.236575] INFO: lockdep is turned off.
[   38.237107] Modules linked in:
[   38.237574] Preemption disabled at:
[   38.237582] [<ffffffff81552c46>] do_task_dead+0x26/0x120
[   38.238779] CPU: 0 UID: 0 PID: 721 Comm: repro Tainted: G      D             6.16.0-next-20250801-next-2025080 #1 PR
[   38.238813] Tainted: [D]=DIE
[   38.238820] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
[   38.238836] Call Trace:
[   38.238842]  <TASK>
[   38.238850]  dump_stack_lvl+0x121/0x150
[   38.238881]  ? do_task_dead+0x26/0x120
[   38.238908]  dump_stack+0x19/0x20
[   38.238936]  __schedule_bug+0x12d/0x180
[   38.238977]  __schedule+0x276e/0x3840
[   38.239017]  ? __pfx___schedule+0x10/0x10
[   38.239050]  ? do_task_dead+0xae/0x120
[   38.239078]  ? do_task_dead+0x48/0x120
[   38.239108]  ? debug_smp_processor_id+0x20/0x30
[   38.239148]  ? rcu_is_watching+0x19/0xc0
[   38.239173]  ? trace_irq_enable+0xd1/0x110
[   38.239211]  ? do_task_dead+0x48/0x120
[   38.239241]  do_task_dead+0xe6/0x120
[   38.239271]  make_task_dead+0x384/0x3c0
[   38.239328]  rewind_stack_and_make_dead+0x16/0x20
[   38.239353] RIP: 0033:0x7f97fab18a4d
[   38.239370] Code: Unable to access opcode bytes at 0x7f97fab18a23.
[   38.239382] RSP: 002b:00007ffd957e62d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   38.239404] RAX: ffffffffffffffda RBX: 00007f97fabf69e0 RCX: 00007f97fab18a4d
[   38.239421] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 0000000000000000
[   38.239437] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
[   38.239452] R10: 00007ffd957e6180 R11: 0000000000000246 R12: 00007f97fabf69e0
[   38.239469] R13: 00007f97fabfbf00 R14: 0000000000000001 R15: 00007f97fabfbee8
[   38.239503]  </TASK>
[   38.239513] ------------[ cut here ]------------
[   38.259566] Voluntary context switch within RCU read-side critical section!
[   38.259699] WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0xc6f/0x1900, CPU#0: repro/721
[   38.262004] Modules linked in:
[   38.262458] CPU: 0 UID: 0 PID: 721 Comm: repro Tainted: G      D W           6.16.0-next-20250801-next-2025080 #1 PR
[   38.263978] Tainted: [D]=DIE, [W]=WARN
[   38.264509] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
[   38.266148] RIP: 0010:rcu_note_context_switch+0xc6f/0x1900
[   38.266891] Code: 8b 45 a0 4c 8b 55 a8 48 c7 c2 44 b4 ef 87 44 8b 4d b0 e9 0f 03 00 00 48 c7 c7 c0 5d ed 85 c6 05 bf0
[   38.269294] RSP: 0018:ffff88800feefd28 EFLAGS: 00010096
[   38.269980] RAX: 0000000000000000 RBX: ffff88806ca450c0 RCX: ffffffff814612c2
[   38.270899] RDX: ffff888016a8ac00 RSI: ffffffff814612cf RDI: 0000000000000001
[   38.271817] RBP: ffff88800feefd98 R08: 0000000000000001 R09: ffffed100d9459b9
[   38.272733] R10: 0000000000000000 R11: 6e69687469772068 R12: ffff888016a8ac00
[   38.273729] R13: 0000000000000000 R14: ffff888016a8ac00 R15: 0000000000000000
[   38.274649] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
[   38.275685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.276435] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
[   38.277410] PKRU: 55555554
[   38.277778] Call Trace:
[   38.278113]  <TASK>
[   38.278416]  ? debug_smp_processor_id+0x20/0x30
[   38.279034]  ? rcu_is_watching+0x19/0xc0
[   38.279570]  ? trace_irq_disable+0xd1/0x110
[   38.280152]  __schedule+0x25c/0x3840
[   38.280660]  ? __pfx___schedule+0x10/0x10
[   38.281273]  ? do_task_dead+0xae/0x120
[   38.281792]  ? do_task_dead+0x48/0x120
[   38.282314]  ? debug_smp_processor_id+0x20/0x30
[   38.282933]  ? rcu_is_watching+0x19/0xc0
[   38.283472]  ? trace_irq_enable+0xd1/0x110
[   38.284039]  ? do_task_dead+0x48/0x120
[   38.284561]  do_task_dead+0xe6/0x120
[   38.285144]  make_task_dead+0x384/0x3c0
[   38.285742]  rewind_stack_and_make_dead+0x16/0x20
[   38.286371] RIP: 0033:0x7f97fab18a4d
[   38.286855] Code: Unable to access opcode bytes at 0x7f97fab18a23.
[   38.287653] RSP: 002b:00007ffd957e62d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   38.288628] RAX: ffffffffffffffda RBX: 00007f97fabf69e0 RCX: 00007f97fab18a4d
[   38.289600] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 0000000000000000
[   38.290519] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
[   38.291436] R10: 00007ffd957e6180 R11: 0000000000000246 R12: 00007f97fabf69e0
[   38.292355] R13: 00007f97fabfbf00 R14: 0000000000000001 R15: 00007f97fabfbee8
[   38.293362]  </TASK>
[   38.293669] irq event stamp: 605
[   38.294103] hardirqs last  enabled at (605): [<ffffffff812f087b>] cond_local_irq_enable.isra.0+0x3b/0x50
[   38.295323] hardirqs last disabled at (604): [<ffffffff85d6dba6>] exc_general_protection+0x36/0x340
[   38.296499] softirqs last  enabled at (516): [<ffffffff8132638c>] fpu_clone+0x10c/0x710
[   38.297603] softirqs last disabled at (514): [<ffffffff8132631f>] fpu_clone+0x9f/0x710
[   38.298639] ---[ end trace 0000000000000000 ]---
"

Hope this cound be insightful to you.

Regards,
Yi Lai

---

If you don't need the following environment to reproduce the problem or if you
already have one reproduced environment, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
  // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
  // You could change the bzImage_xxx as you want
  // Maybe you need to remove line "-drive if=pflash,format=raw,readonly=on,file=./OVMF_CODE.fd \" for different qemu version
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
yum -y install libslirp-devel.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl --enable-usb-redir --enable-slirp
make
make install 

On Sun, Jun 08, 2025 at 10:01:50AM +1200, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> Certain madvise operations, especially MADV_DONTNEED, occur far more
> frequently than other madvise options, particularly in native and Java
> heaps for dynamic memory management.
> 
> Currently, the mmap_lock is always held during these operations, even when
> unnecessary. This causes lock contention and can lead to severe priority
> inversion, where low-priority threads—such as Android's HeapTaskDaemon—
> hold the lock and block higher-priority threads.
> 
> This patch enables the use of per-VMA locks when the advised range lies
> entirely within a single VMA, avoiding the need for full VMA traversal. In
> practice, userspace heaps rarely issue MADV_DONTNEED across multiple VMAs.
> 
> Tangquan’s testing shows that over 99.5% of memory reclaimed by Android
> benefits from this per-VMA lock optimization. After extended runtime,
> 217,735 madvise calls from HeapTaskDaemon used the per-VMA path, while
> only 1,231 fell back to mmap_lock.
> 
> To simplify handling, the implementation falls back to the standard
> mmap_lock if userfaultfd is enabled on the VMA, avoiding the complexity of
> userfaultfd_remove().
> 
> Many thanks to Lorenzo's work[1] on:
> "Refactor the madvise() code to retain state about the locking mode
> utilised for traversing VMAs.
> 
> Then use this mechanism to permit VMA locking to be done later in the
> madvise() logic and also to allow altering of the locking mode to permit
> falling back to an mmap read lock if required."
> 
> One important point, as pointed out by Jann[2], is that
> untagged_addr_remote() requires holding mmap_lock. This is because
> address tagging on x86 and RISC-V is quite complex.
> 
> Until untagged_addr_remote() becomes atomic—which seems unlikely in
> the near future—we cannot support per-VMA locks for remote processes.
> So for now, only local processes are supported.
> 
> Link: https://lore.kernel.org/all/0b96ce61-a52c-4036-b5b6-5c50783db51f@lucifer.local/ [1]
> Link: https://lore.kernel.org/all/CAG48ez11zi-1jicHUZtLhyoNPGGVB+ROeAJCUw48bsjk4bbEkA@mail.gmail.com/ [2]
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  -v4:
>  * collect Lorenzo's RB;
>  * use visit() for per-vma path
> 
>  mm/madvise.c | 195 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 147 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 56d9ca2557b9..8382614b71d1 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -48,38 +48,19 @@ struct madvise_walk_private {
>  	bool pageout;
>  };
>  
> +enum madvise_lock_mode {
> +	MADVISE_NO_LOCK,
> +	MADVISE_MMAP_READ_LOCK,
> +	MADVISE_MMAP_WRITE_LOCK,
> +	MADVISE_VMA_READ_LOCK,
> +};
> +
>  struct madvise_behavior {
>  	int behavior;
>  	struct mmu_gather *tlb;
> +	enum madvise_lock_mode lock_mode;
>  };
>  
> -/*
> - * Any behaviour which results in changes to the vma->vm_flags needs to
> - * take mmap_lock for writing. Others, which simply traverse vmas, need
> - * to only take it for reading.
> - */
> -static int madvise_need_mmap_write(int behavior)
> -{
> -	switch (behavior) {
> -	case MADV_REMOVE:
> -	case MADV_WILLNEED:
> -	case MADV_DONTNEED:
> -	case MADV_DONTNEED_LOCKED:
> -	case MADV_COLD:
> -	case MADV_PAGEOUT:
> -	case MADV_FREE:
> -	case MADV_POPULATE_READ:
> -	case MADV_POPULATE_WRITE:
> -	case MADV_COLLAPSE:
> -	case MADV_GUARD_INSTALL:
> -	case MADV_GUARD_REMOVE:
> -		return 0;
> -	default:
> -		/* be safe, default to 1. list exceptions explicitly */
> -		return 1;
> -	}
> -}
> -
>  #ifdef CONFIG_ANON_VMA_NAME
>  struct anon_vma_name *anon_vma_name_alloc(const char *name)
>  {
> @@ -1486,6 +1467,44 @@ static bool process_madvise_remote_valid(int behavior)
>  	}
>  }
>  
> +/*
> + * Try to acquire a VMA read lock if possible.
> + *
> + * We only support this lock over a single VMA, which the input range must
> + * span either partially or fully.
> + *
> + * This function always returns with an appropriate lock held. If a VMA read
> + * lock could be acquired, we return the locked VMA.
> + *
> + * If a VMA read lock could not be acquired, we return NULL and expect caller to
> + * fallback to mmap lock behaviour.
> + */
> +static struct vm_area_struct *try_vma_read_lock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior,
> +		unsigned long start, unsigned long end)
> +{
> +	struct vm_area_struct *vma;
> +
> +	vma = lock_vma_under_rcu(mm, start);
> +	if (!vma)
> +		goto take_mmap_read_lock;
> +	/*
> +	 * Must span only a single VMA; uffd and remote processes are
> +	 * unsupported.
> +	 */
> +	if (end > vma->vm_end || current->mm != mm ||
> +	    userfaultfd_armed(vma)) {
> +		vma_end_read(vma);
> +		goto take_mmap_read_lock;
> +	}
> +	return vma;
> +
> +take_mmap_read_lock:
> +	mmap_read_lock(mm);
> +	madv_behavior->lock_mode = MADVISE_MMAP_READ_LOCK;
> +	return NULL;
> +}
> +
>  /*
>   * Walk the vmas in range [start,end), and call the visit function on each one.
>   * The visit function will get start and end parameters that cover the overlap
> @@ -1496,7 +1515,8 @@ static bool process_madvise_remote_valid(int behavior)
>   */
>  static
>  int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
> -		      unsigned long end, void *arg,
> +		      unsigned long end, struct madvise_behavior *madv_behavior,
> +		      void *arg,
>  		      int (*visit)(struct vm_area_struct *vma,
>  				   struct vm_area_struct **prev, unsigned long start,
>  				   unsigned long end, void *arg))
> @@ -1505,6 +1525,20 @@ int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
>  	struct vm_area_struct *prev;
>  	unsigned long tmp;
>  	int unmapped_error = 0;
> +	int error;
> +
> +	/*
> +	 * If VMA read lock is supported, apply madvise to a single VMA
> +	 * tentatively, avoiding walking VMAs.
> +	 */
> +	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
> +		vma = try_vma_read_lock(mm, madv_behavior, start, end);
> +		if (vma) {
> +			error = visit(vma, &prev, start, end, arg);
> +			vma_end_read(vma);
> +			return error;
> +		}
> +	}
>  
>  	/*
>  	 * If the interval [start,end) covers some unmapped address
> @@ -1516,8 +1550,6 @@ int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
>  		prev = vma;
>  
>  	for (;;) {
> -		int error;
> -
>  		/* Still start < end. */
>  		if (!vma)
>  			return -ENOMEM;
> @@ -1598,34 +1630,86 @@ int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
>  	if (end == start)
>  		return 0;
>  
> -	return madvise_walk_vmas(mm, start, end, anon_name,
> +	return madvise_walk_vmas(mm, start, end, NULL, anon_name,
>  				 madvise_vma_anon_name);
>  }
>  #endif /* CONFIG_ANON_VMA_NAME */
>  
> -static int madvise_lock(struct mm_struct *mm, int behavior)
> +
> +/*
> + * Any behaviour which results in changes to the vma->vm_flags needs to
> + * take mmap_lock for writing. Others, which simply traverse vmas, need
> + * to only take it for reading.
> + */
> +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
>  {
> +	int behavior = madv_behavior->behavior;
> +
>  	if (is_memory_failure(behavior))
> -		return 0;
> +		return MADVISE_NO_LOCK;
>  
> -	if (madvise_need_mmap_write(behavior)) {
> +	switch (behavior) {
> +	case MADV_REMOVE:
> +	case MADV_WILLNEED:
> +	case MADV_COLD:
> +	case MADV_PAGEOUT:
> +	case MADV_FREE:
> +	case MADV_POPULATE_READ:
> +	case MADV_POPULATE_WRITE:
> +	case MADV_COLLAPSE:
> +	case MADV_GUARD_INSTALL:
> +	case MADV_GUARD_REMOVE:
> +		return MADVISE_MMAP_READ_LOCK;
> +	case MADV_DONTNEED:
> +	case MADV_DONTNEED_LOCKED:
> +		return MADVISE_VMA_READ_LOCK;
> +	default:
> +		return MADVISE_MMAP_WRITE_LOCK;
> +	}
> +}
> +
> +static int madvise_lock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior)
> +{
> +	enum madvise_lock_mode lock_mode = get_lock_mode(madv_behavior);
> +
> +	switch (lock_mode) {
> +	case MADVISE_NO_LOCK:
> +		break;
> +	case MADVISE_MMAP_WRITE_LOCK:
>  		if (mmap_write_lock_killable(mm))
>  			return -EINTR;
> -	} else {
> +		break;
> +	case MADVISE_MMAP_READ_LOCK:
>  		mmap_read_lock(mm);
> +		break;
> +	case MADVISE_VMA_READ_LOCK:
> +		/* We will acquire the lock per-VMA in madvise_walk_vmas(). */
> +		break;
>  	}
> +
> +	madv_behavior->lock_mode = lock_mode;
>  	return 0;
>  }
>  
> -static void madvise_unlock(struct mm_struct *mm, int behavior)
> +static void madvise_unlock(struct mm_struct *mm,
> +		struct madvise_behavior *madv_behavior)
>  {
> -	if (is_memory_failure(behavior))
> +	switch (madv_behavior->lock_mode) {
> +	case  MADVISE_NO_LOCK:
>  		return;
> -
> -	if (madvise_need_mmap_write(behavior))
> +	case MADVISE_MMAP_WRITE_LOCK:
>  		mmap_write_unlock(mm);
> -	else
> +		break;
> +	case MADVISE_MMAP_READ_LOCK:
>  		mmap_read_unlock(mm);
> +		break;
> +	case MADVISE_VMA_READ_LOCK:
> +		/* We will drop the lock per-VMA in madvise_walk_vmas(). */
> +		break;
> +	}
> +
> +	madv_behavior->lock_mode = MADVISE_NO_LOCK;
>  }
>  
>  static bool madvise_batch_tlb_flush(int behavior)
> @@ -1710,6 +1794,21 @@ static bool is_madvise_populate(int behavior)
>  	}
>  }
>  
> +/*
> + * untagged_addr_remote() assumes mmap_lock is already held. On
> + * architectures like x86 and RISC-V, tagging is tricky because each
> + * mm may have a different tagging mask. However, we might only hold
> + * the per-VMA lock (currently only local processes are supported),
> + * so untagged_addr is used to avoid the mmap_lock assertion for
> + * local processes.
> + */
> +static inline unsigned long get_untagged_addr(struct mm_struct *mm,
> +		unsigned long start)
> +{
> +	return current->mm == mm ? untagged_addr(start) :
> +				   untagged_addr_remote(mm, start);
> +}
> +
>  static int madvise_do_behavior(struct mm_struct *mm,
>  		unsigned long start, size_t len_in,
>  		struct madvise_behavior *madv_behavior)
> @@ -1721,7 +1820,7 @@ static int madvise_do_behavior(struct mm_struct *mm,
>  
>  	if (is_memory_failure(behavior))
>  		return madvise_inject_error(behavior, start, start + len_in);
> -	start = untagged_addr_remote(mm, start);
> +	start = get_untagged_addr(mm, start);
>  	end = start + PAGE_ALIGN(len_in);
>  
>  	blk_start_plug(&plug);
> @@ -1729,7 +1828,7 @@ static int madvise_do_behavior(struct mm_struct *mm,
>  		error = madvise_populate(mm, start, end, behavior);
>  	else
>  		error = madvise_walk_vmas(mm, start, end, madv_behavior,
> -					  madvise_vma_behavior);
> +				madv_behavior, madvise_vma_behavior);
>  	blk_finish_plug(&plug);
>  	return error;
>  }
> @@ -1817,13 +1916,13 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
>  
>  	if (madvise_should_skip(start, len_in, behavior, &error))
>  		return error;
> -	error = madvise_lock(mm, behavior);
> +	error = madvise_lock(mm, &madv_behavior);
>  	if (error)
>  		return error;
>  	madvise_init_tlb(&madv_behavior, mm);
>  	error = madvise_do_behavior(mm, start, len_in, &madv_behavior);
>  	madvise_finish_tlb(&madv_behavior);
> -	madvise_unlock(mm, behavior);
> +	madvise_unlock(mm, &madv_behavior);
>  
>  	return error;
>  }
> @@ -1847,7 +1946,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>  
>  	total_len = iov_iter_count(iter);
>  
> -	ret = madvise_lock(mm, behavior);
> +	ret = madvise_lock(mm, &madv_behavior);
>  	if (ret)
>  		return ret;
>  	madvise_init_tlb(&madv_behavior, mm);
> @@ -1880,8 +1979,8 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>  
>  			/* Drop and reacquire lock to unwind race. */
>  			madvise_finish_tlb(&madv_behavior);
> -			madvise_unlock(mm, behavior);
> -			ret = madvise_lock(mm, behavior);
> +			madvise_unlock(mm, &madv_behavior);
> +			ret = madvise_lock(mm, &madv_behavior);
>  			if (ret)
>  				goto out;
>  			madvise_init_tlb(&madv_behavior, mm);
> @@ -1892,7 +1991,7 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
>  		iov_iter_advance(iter, iter_iov_len(iter));
>  	}
>  	madvise_finish_tlb(&madv_behavior);
> -	madvise_unlock(mm, behavior);
> +	madvise_unlock(mm, &madv_behavior);
>  
>  out:
>  	ret = (total_len - iov_iter_count(iter)) ? : ret;
> -- 
> 2.39.3 (Apple Git-146)
> 

