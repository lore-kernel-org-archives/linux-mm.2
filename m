Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE152C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5466B0098; Tue,  5 Aug 2025 02:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D1D6B0099; Tue,  5 Aug 2025 02:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA496B009B; Tue,  5 Aug 2025 02:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3D66B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:41:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6C061A0DB7
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:41:35 +0000 (UTC)
X-FDA: 83741757750.14.4810E2F
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8A96C0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:41:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sIE1xJZ9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754376093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKwb3jyiyyLlRq/hzHJCa8IJJVZNalYmdaLHaPwmwrU=;
	b=DwwmOl88/I3FDHWzNuZhIOIjcAxk9R03StUHpP/wuxryH2d/YaEGUKmwz+hdEiayyCIfl3
	DLXxNTDvnnaR8Ni5/q3HIUoTbCIZLrCfgB5mrG3/46Xa3S0VvANAnxaKkzKRJIwkodzqAd
	Uc9FENp+HFV5Um45Ty0UMyta2tqbKX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754376093; a=rsa-sha256;
	cv=none;
	b=dUVpR1o5p7wmC9XfVF8CpGYCKUnVQFANYWXdHxSzjUjVYx1iqpWREsMF0s4sm7o7dJLo9J
	hDEvpcwyfpsW1FvhHBEQB0TaMPQeS/X9fYq5bJBpNDNWOlQiFYxSYWyxOAyu0wTvC9hoXy
	88k04EXox0UUtGIIUMjIoF5CHBjboF8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sIE1xJZ9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754376085; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iKwb3jyiyyLlRq/hzHJCa8IJJVZNalYmdaLHaPwmwrU=;
	b=sIE1xJZ9CIWW6fXKGycIeABlUbx7mE540ro2p3S8r9ZNkXEbOJ7vaE9vGrxwqYayyNYOW7tYlUt6T9l6Ud9msqBEJLjW55pBc/S925BTqSP3cDTUqiTRrRrv6vflZdz0NI7Y5TUa/CM2ULcoLQ1U60rc9sBaOPqWkEY3mjA8q/k=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wl440vN_1754376082 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 14:41:23 +0800
Message-ID: <721c093c-a54a-4ccc-b784-e3634a8c2278@linux.alibaba.com>
Date: Tue, 5 Aug 2025 14:41:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>,
 Tangquan Zheng <zhengtangquan@oppo.com>, Lance Yang <ioworker0@gmail.com>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250805035447.7958-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8A96C0005
X-Stat-Signature: qkfy6nk8hh5ibd81p86jb58ruoxsw1xn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754376090-688191
X-HE-Meta: U2FsdGVkX18oHlf8LzTvNpPiCYvt1ObcnCeqH2D37BRnz9i1o4PHTSsZho4I/xwJDtyfYhNP518N6aVew7cffxBDsDYRKxFGFzh6FVJcI964lbzpYh2F9/0UQnKdjY763LiudhK1gurtt18Zv6JEDWj0ncMWrJ4j+NU/i8Vc+GZRTtuWaXC2/6D3Oy9c9qzOueC85/qqwQpePqomzOZ8QmK9vUYYb3D8XHoRB4fcLkphXCO0tfOeKPmeP66E6Qd4jlkMzfKfX54S2vlVja4S9GHrH8JalgjhF3q3v2BKtCxyK5VrFhXOyPTke88EjE9thpTa2mhzJoFLRCwFU8/qzLyCFc5rKT1787fHeUUccyzxaoMwbRkieXolIi+FDVH5LdmsyhKGjWcYZ/w7t7flnYLnbTBruOQ7vB6sNX+vpXH5FIqLGRGuClZvc7zAJYruQrbF1M2u53lJ2FECnlIYyHPidIw33kLKfR7/kvti5KPCUSoy6yzzhu7cEnrHv7p2hTaMjUc32V1LSs8Kf3gtbcwoA8Wn+WMK6q2XNbpe1Ble10ajAo4qegagQwe4fwCchEzV8g2gHkU8K2xOTU2d7Jlp33wzt87uDiWfKyAMBF+VkxynHSUE73zKOr9h/gSrniGR/AMpYN3c0JSLt6w/Rb0/FThI83R2mGeAzYyFR3EZ8VESvov7GVTCf6mUzGhdyh6HfjpICGS0LVQQPbosMtxyn+wGTnA5+VcFwqERjhgsKyW7ZCz1y9Xj2GWQ644UM5MezHuFRsZV4Vo4qZIgfUBGgKU81wYiJJgu6Mi3ObWC2kdakwsKD6eK3nvk0PYiUAWL95jwDDhbIolcDf4MYn0ZT8Dmt5I++/iqqHFzw/ky2+jBNvVya3XTsKfKKEJqFghoclFsU0kY4bZz0MDbMHRm/0PebFOXYkOHdlumeOG9EFxadHr33kF+V/ZyOd6SARcbOJhMVfFlT8oxbod
 1dI9x2Rw
 v/RjmZVesS+k7o/Kk7EkggjcHHFTn1gPpVDN/Aw+7dAi6Jab24gkgG/EAIL7Lso7poxqqu7lY8x0Le/298wixrOWsf3N+twM0niMoAX/tvrkeYojaApBW291jr5mxsPz69tW31RU9WYgTsYTNsHmOsx3JAuIdoU74FL/lOBupMVRBkKpHZgNyYiWmpkPodnjII7TenaBMxKlefw1fwWew0AU5SASNzC1d6/E5773zQw7jS8gBiG12K19/HjqDR8jA95CMgbRbK72MtBlTEpFlDkSRV606w48TfwdOBCP0cqaStzAQdjo/dh49xofCMQINyIPqSn7QLR+X5e2B3NywYCh325u8D7kg01ZEhZVatBHixN/DBkmYzLg2FxLkHMLbBPYa7WM5qWHGUhe0gih67KcdXvsd91HJjpYTe1fx0HdDVZRjRF4lPNtpjLVvlmSYgXk0HwoLBV3XPOYG8ulRH66FiMpQku+mJhU53IMFIklxLcy1znfAf+aJtMTsCI+/ImjQ2I8iig+khdhEY2Q8XHMvxHDdz4aoKLotCEdJm22Ky1W4Pe19qxL07/ozTXIC2oXOxmdetfm21BwICQt7PPgAKPk9TjP6KtT+x2jVsOFujuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 11:54, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> The check_pmd_still_valid() call during collapse is currently only
> protected by the mmap_lock in write mode, which was sufficient when
> pt_reclaim always ran under mmap_lock in read mode. However, since
> madvise_dontneed can now execute under a per-VMA lock, this assumption
> is no longer valid. As a result, a race condition can occur between
> collapse and PT_RECLAIM, potentially leading to a kernel panic.
> 
>   [   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
>   [   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>   [   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
>   [   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
>   [   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
>   [   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
>   [   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
>   [   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
>   [   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
>   [   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
>   [   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
>   [   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
>   [   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
>   [   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
>   [   38.168812] PKRU: 55555554
>   [   38.169275] Call Trace:
>   [   38.169647]  <TASK>
>   [   38.169975]  ? __kasan_check_byte+0x19/0x50
>   [   38.170581]  lock_acquire+0xea/0x310
>   [   38.171083]  ? rcu_is_watching+0x19/0xc0
>   [   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>   [   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
>   [   38.173130]  _raw_spin_lock+0x38/0x50
>   [   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
>   [   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
>   [   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
>   [   38.175724]  ? __pfx_pud_val+0x10/0x10
>   [   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
>   [   38.177183]  unmap_page_range+0xb60/0x43e0
>   [   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
>   [   38.178485]  ? mas_next_slot+0x133a/0x1a50
>   [   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
>   [   38.179830]  unmap_vmas+0x1fa/0x460
>   [   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
>   [   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>   [   38.181877]  exit_mmap+0x1a2/0xb40
>   [   38.182396]  ? lock_release+0x14f/0x2c0
>   [   38.182929]  ? __pfx_exit_mmap+0x10/0x10
>   [   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
>   [   38.184188]  ? mutex_unlock+0x16/0x20
>   [   38.184704]  mmput+0x132/0x370
>   [   38.185208]  do_exit+0x7e7/0x28c0
>   [   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
>   [   38.186328]  ? do_group_exit+0x1d8/0x2c0
>   [   38.186873]  ? __pfx_do_exit+0x10/0x10
>   [   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
>   [   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
>   [   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
>   [   38.189313]  do_group_exit+0xe4/0x2c0
>   [   38.189831]  __x64_sys_exit_group+0x4d/0x60
>   [   38.190413]  x64_sys_call+0x2174/0x2180
>   [   38.190935]  do_syscall_64+0x6d/0x2e0
>   [   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> This patch moves the vma_start_write() call to precede
> check_pmd_still_valid(), ensuring that the check is also properly
> protected by the per-VMA lock.
> 
> Fixes: a6fde7add78d ("mm: use per_vma lock for MADV_DONTNEED")
> Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Closes: https://lore.kernel.org/all/aJAFrYfyzGpbm+0m@ly-workstation/
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

