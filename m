Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD449D37E32
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9016B0098; Wed, 14 Jan 2026 08:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6A96B0099; Wed, 14 Jan 2026 08:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5A66B009B; Wed, 14 Jan 2026 08:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA0F46B0098
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:28:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 664151AD79C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:28:14 +0000 (UTC)
X-FDA: 84330648108.07.D7AB6B0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC634C0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:28:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aG2aW26I;
	spf=pass (imf28.hostedemail.com: domain of yi1.lai@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yi1.lai@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768397292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWA6VtVB3sILZbHUpDofBgcZ2BxBWJxrF5lpnyozntA=;
	b=uN5DcTKJSWC64U8ZQh58/ONh7I0ASLtRRM0qtAHDwZjBOhzbcEq+cOaaQ4WDqw9PTeNjjE
	ETYWSNbAcynPAhw6DT3keHKKP48sv5WR0agjZs5ZWntwjmOYjglJAOFNdjKzv9dMXH6DkA
	PI2/wwX3bNPXxN4fjKTWV3FYUNqtb8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768397292; a=rsa-sha256;
	cv=none;
	b=p2rFVbinjpiZufNiyTX6XyM7DhthoYl64KtGae+cUD0pq36sEPpBOsZhtWlHbeEwEE71Bb
	J2o+9H5NyWBOaYPhxUjgVQMfFnmM7U/OcUg6/RiACt80OgfmKf6klCYhA0EbQGgEOhFTv0
	ZSZOIX5anbf5FcJLb0UnE1jg2urI5rM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aG2aW26I;
	spf=pass (imf28.hostedemail.com: domain of yi1.lai@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=yi1.lai@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768397292; x=1799933292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=drFNgjA8qXHpljbntcl8BlBSYuo3kCvxKvrLsGSOAXM=;
  b=aG2aW26IvqTwhi1Wkmf8YveFPx3QhwPNUX2qV4tRqc/PJAnwz1w7+Izh
   n4JoORW2AxrkmWPuqg2KHqodY25N8bYHy+ljTuizjJatMwGICq7lwksLC
   m2YlZvgGvZgf2QK7ajSfp0eJyp67QMLZ3wqdkiuwDnv/agVuJEG633zca
   oaiB6MXrEmsg07e9OQjOgTym0aFd3B9BLDN2ALFv9ZZQ6jmrdUTZaE0b3
   xXxeXK6a02bUqtM9YR2gzEIXPW+8WIjSeJQvGImuwBJoO2jVQ8HyGGeN9
   bBDGir1KEKaYs0nVRniMbCgB+yWoVI2Dz9vPk3nRfyOAObU2wPSZ13IYl
   A==;
X-CSE-ConnectionGUID: 7ilelJrAR9SFy8PI7zIZBw==
X-CSE-MsgGUID: Tpq4IDkyQJWw/VDyo6u6iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="81140995"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="81140995"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 05:28:08 -0800
X-CSE-ConnectionGUID: 6Sx48oIiQyOVKT8FQiMakA==
X-CSE-MsgGUID: nqkvukhNTwSAHSvJbLRSVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="209525497"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 05:28:04 -0800
Date: Wed, 14 Jan 2026 21:28:00 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
	linux-pm@vger.kernel.org,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
Message-ID: <aWeZ4LmfwiS9iwYF@ly-workstation>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC634C0003
X-Rspam-User: 
X-Stat-Signature: dbekkytwg5zj5zjbo3hhbdsn89mj4zz8
X-HE-Tag: 1768397291-752224
X-HE-Meta: U2FsdGVkX1/7oNj8CXjVBcZHkeexmzdFl87qXhieR+zckt88EVO4Je+ci8OE2+NlR9CPn+j0BQzkGRvT3JwTvts2HjKCD10KbxfkhKG1q9ND1DujmsHDOc/B6ieCip8XgQlkqv+RvGBfIJsJrst5RFYOZ7hmwGAhmb6fZVVCLfC68PY/xO8yYDZ00HuhhA2jnsCtHll+IPuAV8xcKvmfneNcbc0A6usndlGAeAFrAfTSDThys+YFxjYcMv0ggIqFsAWNv6dTJ2zch04YFuJr06K0vFkTxYKC3n3fTkY09S70Occkm++adoy0n8V6fosBb/1UJ7pf4yM8VNDUUYbPWkoMruXbxecz+dCoGZcMQ8S50nNb23pa9kDYGZWSANMdIT6+QO2tAS6ODnSUXR+RrodD6M2IkavAHLSurRMckTb5HyiLO4tmMDnxaGsSyuUXLztav+owTSw8ri9R8AnROfcC+NnLMbeUkXP5ywbEj1Quq7MQilJyDrP55VvXq7BWaPP36cl3D14LUQi7LOY9JGIkAuZz3suWGN9cpKJSbcmzPQ5tjr3SvbEuMeUqGuflfkSzAmRcl3R7b5uEI2Cg8tEn6E1yXMOXFniLd4ceUCHbpOb9EeofOLWJcF3y91oyFnGhFP4290bqeKND4VruhQau18Nr1v3TkpzpTtJInDVOYfBC0ZYu5QtBYaUS4IEoPOFmiwcCkaOqZfMJ5xXgJ3TgYRu5LwxFSbtcTDkmW4fssJj6mRgN3ArPughoS7Ec6qmeeI9ZeDbVGoBSZZI3s8B92/bHMIn+xsUXMXCT3ptr/9OVqu9jS4PMAVwnf7ci6gexcdUPNMjcMBGBp29KOBadPE3UZ7bPP/p8+0XVwwGR5ootPiflDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui Song,

Greetings!

I used Syzkaller and found that there is possible deadlock in swap_free_hibernation_slot in linux-next next-20260113.

After bisection and the first bad commit is:
"
33be6f68989d mm. swap: cleanup swap entry management workflow
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_free_hibernation_slot/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/260114_102849_swap_free_hibernation_slot/bzImage_0f853ca2a798ead9d24d39cad99b0966815c582a
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/260114_102849_swap_free_hibernation_slot/0f853ca2a798ead9d24d39cad99b0966815c582a_dmesg.log

"
[   62.477554] ============================================
[   62.477802] WARNING: possible recursive locking detected
[   62.478059] 6.19.0-rc5-next-20260113-0f853ca2a798 #1 Not tainted
[   62.478324] --------------------------------------------
[   62.478549] repro/668 is trying to acquire lock:
[   62.478759] ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_free_hibernation_slot+0x13e/0x2a0
[   62.479271]
[   62.479271] but task is already holding lock:
[   62.479519] ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_free_hibernation_slot+0xfa/0x2a0
[   62.479984]
[   62.479984] other info that might help us debug this:
[   62.480293]  Possible unsafe locking scenario:
[   62.480293]
[   62.480565]        CPU0
[   62.480686]        ----
[   62.480809]   lock(&cluster_info[i].lock);
[   62.481010]   lock(&cluster_info[i].lock);
[   62.481205]
[   62.481205]  *** DEADLOCK ***
[   62.481205]
[   62.481481]  May be due to missing lock nesting notation
[   62.481481]
[   62.481802] 2 locks held by repro/668:
[   62.481981]  #0: ffffffff87542e28 (system_transition_mutex){+.+.}-{4:4}, at: lock_system_sleep+0x92/0xb0
[   62.482439]  #1: ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3}, at: swap_free_hibernation_slot+0xfa/0x0
[   62.482936]
[   62.482936] stack backtrace:
[   62.483131] CPU: 0 UID: 0 PID: 668 Comm: repro Not tainted 6.19.0-rc5-next-20260113-0f853ca2a798 #1 PREEMPT(l
[   62.483143] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.q4
[   62.483151] Call Trace:
[   62.483156]  <TASK>
[   62.483160]  dump_stack_lvl+0xea/0x150
[   62.483195]  dump_stack+0x19/0x20
[   62.483206]  print_deadlock_bug+0x22e/0x300
[   62.483215]  __lock_acquire+0x1325/0x2210
[   62.483226]  lock_acquire+0x170/0x2f0
[   62.483234]  ? swap_free_hibernation_slot+0x13e/0x2a0
[   62.483249]  _raw_spin_lock+0x38/0x50
[   62.483267]  ? swap_free_hibernation_slot+0x13e/0x2a0
[   62.483279]  swap_free_hibernation_slot+0x13e/0x2a0
[   62.483291]  ? __pfx_swap_free_hibernation_slot+0x10/0x10
[   62.483303]  ? locks_remove_file+0xe2/0x7f0
[   62.483322]  ? __pfx_snapshot_release+0x10/0x10
[   62.483331]  free_all_swap_pages+0xdd/0x160
[   62.483339]  ? __pfx_snapshot_release+0x10/0x10
[   62.483346]  snapshot_release+0xac/0x200
[   62.483353]  __fput+0x41f/0xb70
[   62.483369]  ____fput+0x22/0x30
[   62.483376]  task_work_run+0x19e/0x2b0
[   62.483391]  ? __pfx_task_work_run+0x10/0x10
[   62.483398]  ? nsproxy_free+0x2da/0x5b0
[   62.483410]  ? switch_task_namespaces+0x118/0x130
[   62.483421]  do_exit+0x869/0x2810
[   62.483435]  ? do_group_exit+0x1d8/0x2c0
[   62.483445]  ? __pfx_do_exit+0x10/0x10
[   62.483451]  ? __this_cpu_preempt_check+0x21/0x30
[   62.483463]  ? _raw_spin_unlock_irq+0x2c/0x60
[   62.483474]  ? lockdep_hardirqs_on+0x85/0x110
[   62.483486]  ? _raw_spin_unlock_irq+0x2c/0x60
[   62.483498]  ? trace_hardirqs_on+0x26/0x130
[   62.483516]  do_group_exit+0xe4/0x2c0
[   62.483524]  __x64_sys_exit_group+0x4d/0x60
[   62.483531]  x64_sys_call+0x21a2/0x21b0
[   62.483544]  do_syscall_64+0x6d/0x1180
[   62.483560]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   62.483584] RIP: 0033:0x7fe84fb18a4d
[   62.483595] Code: Unable to access opcode bytes at 0x7fe84fb18a23.
[   62.483602] RSP: 002b:00007fff3e35c928 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   62.483610] RAX: ffffffffffffffda RBX: 00007fe84fbf69e0 RCX: 00007fe84fb18a4d
[   62.483615] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 0000000000000001
[   62.483620] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000020
[   62.483624] R10: 00007fff3e35c7d0 R11: 0000000000000246 R12: 00007fe84fbf69e0
[   62.483629] R13: 00007fe84fbfbf00 R14: 0000000000000001 R15: 00007fe84fbfbee8
[   62.483640]  </TASK>
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


