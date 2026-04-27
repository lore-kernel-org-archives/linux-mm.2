Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADD8FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B816B6B0088; Mon, 27 Apr 2026 05:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58906B008A; Mon, 27 Apr 2026 05:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F126B008C; Mon, 27 Apr 2026 05:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910EC6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:44:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 359501A0840
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:44:20 +0000 (UTC)
X-FDA: 84703850280.28.C4A5372
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1AA1140002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:44:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pb5VLFu6;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xUFXEapYlIa4WKGYH72Dshpu3C64x1WXF8BvrZgHhM=;
	b=Tx1TnCNJTOO2KM4O82O/seuWEygHvXbhnYW0qINppkT0St83Xuw7rJRWrULYzGRL0laZf2
	t3jBSKg1h5Ag8ib0XrXnrKRgHAKVrMGiY5tTIWfErC0MYmF083uWGsTZ2cpAs5poUAj9xC
	5d57BFQtWzlYmTNBC8gvn76f3a2d4kE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pb5VLFu6;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283058; a=rsa-sha256;
	cv=none;
	b=TZfOC3nYRZ8ov9yDEJY19rVIcbzKFGaD2dSIVyrA9f2rlJ++4Swr91NybofuVkqk8VrdOE
	NiBoMluTTnpqJHYMLKS2etdv0lgXeyAxEczZJPUhKknoGxRDIDm2GphSTclyLmQu+ajG4y
	jTDjr4aPD0H62+3m2cqfSttkcrvS9c4=
Message-ID: <f0ab0c7a-c597-41a8-92b3-4424b12b1b1e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777283055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7xUFXEapYlIa4WKGYH72Dshpu3C64x1WXF8BvrZgHhM=;
	b=pb5VLFu6enJGqGDZjlK3eW0JOY2rWUJOmhAo1ZwtM86yH/QfW6JjhLEU2K7Ule3skSYMTp
	Mng2efaokXfG/1SWAh4BAzvGCi/IthxSEK3tX8XMFRLscz2QghNprbtuPO+tArFN+InkSk
	kXt1fYV2Vozae7tkx1ikQ1FnmKMJf5k=
Date: Mon, 27 Apr 2026 17:43:38 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, shakeel.butt@linux.dev
Cc: syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
 <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
 <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
 <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
 <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
In-Reply-To: <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1AA1140002
X-Stat-Signature: pweuanguaa9mc4f3d4hc5954hc7qmucx
X-HE-Tag: 1777283057-904757
X-HE-Meta: U2FsdGVkX1/ZDKqKFt+goRIVvtk2PzhfZIFMYUOb3ZEbiLnzSohiCihEOAQGNEwjj7oE4pDdUDCqfmPWl+Ys9IvwfMGUAHoLUOfbkLTaWvQdlO+gPzr//Az7hqWuek9n5hSVZeJQhyUxT1Ag0oF7WUK+qwCqAm/av/O8ek9TwG4fHQeHcYVIFi+L+mFstBfONDNSbZtb7/LfTixZPQ+VlNz9+ydSG8EIQw+V2PmReer6wDXeinQuY/aeEzkm7a1E8nLFF+7DGHCz3PpT4dYc0zZZnZhzyA9oVAxEIOjVTql7zOBW0mtkLFwXmY6xshMWMS3z0Vzmpo1TBzohWSkzm6t5lK/s9E3ByND2ij2bQaMAeqtcEa4qKAf7rERMhUVvNaMYzxrictbEV1nUXRTHXPmWTsWwDLY81w/UdL3MAoX2akaHHsL6/XlQgFFdXPn9EMQmsNrcGRrIcYe1mdUTGADPTeUOTc38cTvS4H9IzLArFFXTeS1NS1/gAFXI6+6Q/KKf+5D4CEVrBwuqh3yqNZkw4H89vFQolc+2/fcTB/9jV4qNuFm6TnofmFP9LsbF+4dfPeGE17HfypfEuTfSi45cBtdRSkcA7FhF4qMzOEEkv5l67AdbNDGzJ7PoI6Ouv1bD7SyzhsBhzHEPSYs5IovNaKkGJahbZzPRf8ri9/mscjv5BAOQ+TotjlqwmhrRKGNKnbJHI5WPMewqR4vNQEn30M0lRuczmZsnk4g9o6QACZRJ7czEal8bMCiEY0Qt2fBFkUN43lA1jIjybeS2pGFr3CWbMwB9Sh/UD79cAfl4ZOrVS4Q6YK5ye+8EtrIHbNBZmE6ZXvDG29HVELsXhcG+qlbBQbPdaywxWl72J7ktlxW8nQcJ6oGtZHywrZ8ywC8sfvy05gP5Kvv0omIPCddGgopj6XbGTU+7WxvD2Gi3506snCAqtrfpCi9PmM4h45KOA59RxVSm2UebJS4
 B7RfWt9z
 QGvJq4bhxuNFfE/GZRCeT/FpqZuSpse7yhdpuM7GMHLsSzFiFtp5wIoyYS3NdxM7up/z/o1jVbWwG4PH44CIsca7bdeHEiW7iBBFwu1M62L+5LaAeWaZwlnOshz0rc6JKqFbo9yMX1D8FUftOOd+stQTsyBN8eBRa5S+fDUMIhek2dUXnnKs5jUKBE7HiDZ30zYsDsH1rBP38uf+RBfl+c/35pwJ5Az65GdmJ2zaFOg6yzL4W2VDrPIkmdZpVtTgT2Z74/iS18yku4Nc71B/dVDNYLH7yh6Y0mGKbRo1GKVmE0SFhSkHWIk3R6RQvoAnYdyzEga6+ubmsoa8gOFSwIoBfptGItN2AakgEZSbEXVdQfKpyan0k85u/tMVEMeMDjipFDtH5CZXfWtBa/RsxzlD8nwQh6CrNKsk/6goWKVOztCk1JUcXOKznk1CDpeAwoCtAkMc12zzILheX36Gy421KBoIHhMVj7HduXRDMkKWTjBBjLnXZ4NX1zwp4TtuT1+p8fJfYNniljbhEwDfthviUfu0H80L75DxN68uHJcHZxG53JtRFRi0ybYv85CuYH0mHGcz9v2lwaJcXX5NXG/pQY8zqJ6D14Yh75bTJToAIlOpWGRu6KevA4UIplghf8i4GLNTQLZjUKLbvMeuBHYTVikfvHN0/u7WA8WoxamTUXOKua90xsT64DaiJ/8Yq1lDg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/27/26 3:24 PM, Qi Zheng wrote:
> 
> 
> On 4/27/26 1:55 AM, Andrew Morton wrote:
>> On Sun, 26 Apr 2026 23:57:42 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>> Hi Andrew,
>>>
>>> On 4/26/26 6:49 PM, Andrew Morton wrote:
>>>> On Sun, 26 Apr 2026 01:17:25 -0700 syzbot 
>>>> <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of 
>>>>> https://gi..
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt? 
>>>>> x=12483702580000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config? 
>>>>> x=24c8da4692f901cb
>>>>> dashboard link: https://syzkaller.appspot.com/bug? 
>>>>> extid=7d60b33a8a546263da7c
>>>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils 
>>>>> for Debian) 2.44
>>>>> userspace arch: i386
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> argh, that dreaded sentence.
>>>>
>>>> Thanks.
>>>>
>>>> Something's definitely amiss.  This is at least the fifth report of
>>>> rcu_read_lock() imbalance post-7.0.  Others:
>>>>
>>>> https://lore.kernel.org/69eab803.a00a0220.17a17.004a.GAE@google.com
>>>> https://lore.kernel.org/69eab803.a00a0220.17a17.004b.GAE@google.com
>>>> https://lore.kernel.org/69eafb0e.a00a0220.9259.0031.GAE@google.com
>>>> https://lore.kernel.org/69ebcbe2.a00a0220.7773.0005.GAE@google.com
>>>
>>> All the kernel configs mentioned above include 'CONFIG_MEMCG_V1=y'.
>>>
>>> Theoretically, a rebind_subsystems() can lead a rcu unbalance, see my
>>> previous discussion with Shakeel for details:
>>>
>>> https://lore.kernel.org/all/358c60e1- 
>>> fa91-40a1-9e00-84c93340c04e@linux.dev/
>>
>> Right, that looks similar.
>>
>> The rcu locking under lruvec_stat_mod_folio() is very simple, and that
>> return in get_non_dying_memcg_end() does look super suspicious.  Why
>> does it omit the unlock?
>>
>> otoh, in
>> https://lore.kernel.org/all/69eafb0e.a00a0220.9259.0031.GAE@google.com/
>> we're trying to release an rcu_read_lock() which isn't presently held.
>> But if cgroup_subsys_on_dfl() were to become false between the
>> get_non_dying_memcg_start/end pair, that's what would happen.
>>
>> So yup, I agree, concurrent rebind_subsystems() activity could cause
>> all of this.  The reports are pretty common - is there some debugging
>> patch we can temporarily add to confirm this theory?  And/or is it
>> possible to cook up a selftest which will trigger this?
> 
> I've been trying to reproduce this locally, but unfortunately I haven't
> succeeded yet.

Alright, it seems I have successfully reproduced it:
(The reproducer is attached at the bottom of this email.)

[   43.883623][  T270] mod_memcg_lruvec_state: key_on_dfl=0 rcu_locked=0 
depth_before=2 depth_now=2
[   43.884267][  T270] ------------[ cut here ]------------
[   43.884663][  T270] WARNING: mm/memcontrol.c:850 at 
mod_memcg_lruvec_state+0x94/0x130, CPU#0: memcg-repro/270
[   43.885375][  T270] Modules linked in:
[   43.885704][  T270] CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: 
G        W           7.0.0-next-20260420+ #
[   43.886554][  T270] Tainted: [W]=WARN
[   43.886833][  T270] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.12.0-1 04/01/2014
[   43.887490][  T270] RIP: 0010:mod_memcg_lruvec_state+0x94/0x130
[   43.887932][  T270] Code: 5c 41 5d 41 5e 41 5f e9 4a 52 a3 00 48 8d 
b3 58 09 00 00 b9 0c 00 00 00 48 c7 c7 72 de f
[   43.889319][  T270] RSP: 0000:ffffc900041bfc38 EFLAGS: 00010246
[   43.889763][  T270] RAX: 0000000000000000 RBX: ffff888104619bc0 RCX: 
0000000000000000
[   43.890332][  T270] RDX: 0000000000000619 RSI: ffff88810461a524 RDI: 
ffffffff827bde7e
[   43.890908][  T270] RBP: 0000000000000001 R08: ffffffff83549028 R09: 
0000000000000001
[   43.891481][  T270] R10: ffffffffffffdfff R11: ffffc900041bfa78 R12: 
0000000000000011
[   43.892051][  T270] R13: ffff8882bfffa1c0 R14: 0000000000000002 R15: 
ffff88810203a7c0
[   43.892629][  T270] FS:  00007f73c4641740(0000) 
GS:ffff8883324cb000(0000) knlGS:0000000000000000
[   43.893262][  T270] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.893737][  T270] CR2: 00005590e4eb8000 CR3: 00000001040d2000 CR4: 
00000000000006f0
[   43.894300][  T270] Call Trace:
[   43.894548][  T270]  <TASK>
[   43.894767][  T270]  lruvec_stat_mod_folio+0xc2/0x1a0
[   43.895138][  T270]  __folio_mod_stat+0x25/0x80
[   43.895483][  T270]  folio_add_new_anon_rmap+0xb1/0x2b0
[   43.895880][  T270]  map_anon_folio_pte_nopf+0xa3/0x120
[   43.896267][  T270]  do_pte_missing+0xad5/0xb40
[   43.896620][  T270]  __handle_mm_fault+0x80e/0xcd0
[   43.896983][  T270]  handle_mm_fault+0x146/0x310
[   43.897332][  T270]  do_user_addr_fault+0x303/0x880
[   43.897708][  T270]  exc_page_fault+0x9b/0x270
[   43.898042][  T270]  asm_exc_page_fault+0x26/0x30
[   43.898387][  T270] RIP: 0033:0x5590e4eb41ea
[   43.898722][  T270] Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 
66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
[   43.900107][  T270] RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
[   43.900546][  T270] RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 
00007f73c474d44d
[   43.901114][  T270] RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 
000000000000000f
[   43.901691][  T270] RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 
00007f73c483a680
[   43.902257][  T270] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[   43.902831][  T270] R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 
00007f73c4869020
[   43.903407][  T270]  </TASK>
[   43.903637][  T270] irq event stamp: 2919
[   43.903933][  T270] hardirqs last  enabled at (2927): 
[<ffffffff8137acfe>] __up_console_sem+0x5e/0x70
[   43.904605][  T270] hardirqs last disabled at (2936): 
[<ffffffff8137ace3>] __up_console_sem+0x43/0x70
[   43.905264][  T270] softirqs last  enabled at (2048): 
[<ffffffff812c7f1e>] handle_softirqs+0x38e/0x460
[   43.905952][  T270] softirqs last disabled at (2031): 
[<ffffffff812c84c9>] irq_exit_rcu+0xe9/0x160
[   43.906606][  T270] ---[ end trace 0000000000000000 ]---
[   43.907004][  T270]
[   43.907174][  T270] =====================================
[   43.907565][  T270] WARNING: bad unlock balance detected!
[   43.907954][  T270] 7.0.0-next-20260420+ #83 Tainted: G        W
[   43.908450][  T270] -------------------------------------
[   43.908845][  T270] memcg-repro/270 is trying to release lock 
(rcu_read_lock) at:
[   43.909382][  T270] [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
[   43.909830][  T270] but there are no more locks to release!
[   43.910234][  T270]
[   43.910234][  T270] other info that might help us debug this:
[   43.910807][  T270] 1 lock held by memcg-repro/270:
[   43.911163][  T270]  #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: 
do_user_addr_fault+0x285/0x880
[   43.911820][  T270]
[   43.911820][  T270] stack backtrace:
[   43.912237][  T270] CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: 
G        W           7.0.0-next-20260420+ #
[   43.912239][  T270] Tainted: [W]=WARN
[   43.912240][  T270] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.12.0-1 04/01/2014
[   43.912240][  T270] Call Trace:
[   43.912241][  T270]  <TASK>
[   43.912242][  T270]  ? rcu_read_unlock+0x17/0x60
[   43.912244][  T270]  dump_stack_lvl+0x77/0xb0
[   43.912248][  T270]  print_unlock_imbalance_bug+0xe0/0xf0
[   43.912251][  T270]  ? rcu_read_unlock+0x17/0x60
[   43.912253][  T270]  lock_release+0x21d/0x2a0
[   43.912256][  T270]  rcu_read_unlock+0x1c/0x60
[   43.912258][  T270]  do_pte_missing+0x233/0xb40
[   43.912260][  T270]  __handle_mm_fault+0x80e/0xcd0
[   43.912265][  T270]  handle_mm_fault+0x146/0x310
[   43.912268][  T270]  do_user_addr_fault+0x303/0x880
[   43.912271][  T270]  exc_page_fault+0x9b/0x270
[   43.912273][  T270]  asm_exc_page_fault+0x26/0x30
[   43.912274][  T270] RIP: 0033:0x5590e4eb41ea
[   43.912276][  T270] Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 
66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
[   43.912277][  T270] RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
[   43.912278][  T270] RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 
00007f73c474d44d
[   43.912278][  T270] RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 
000000000000000f
[   43.912279][  T270] RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 
00007f73c483a680
[   43.912280][  T270] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[   43.912280][  T270] R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 
00007f73c4869020
[   43.912284][  T270]  </TASK>
[   43.923741][  T270] ------------[ cut here ]------------
[   43.924127][  T270] WARNING: kernel/rcu/tree_plugin.h:443 at 
__rcu_read_unlock+0x117/0x210, CPU#0: memcg-repro/270
[   43.924968][  T270] Modules linked in:
[   43.925251][  T270] CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: 
G        W           7.0.0-next-20260420+ #
[   43.926102][  T270] Tainted: [W]=WARN
[   43.926376][  T270] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.12.0-1 04/01/2014
[   43.927038][  T270] RIP: 0010:__rcu_read_unlock+0x117/0x210
[   43.927469][  T270] Code: 68 56 83 01 00 00 00 bf 09 00 00 00 e8 62 
da f1 ff 4d 85 ed 0f 84 27 ff ff ff e8 24 f7 5
[   43.928861][  T270] RSP: 0000:ffffc900041bfcf8 EFLAGS: 00010286
[   43.929292][  T270] RAX: 00000000ffffffff RBX: ffff888104619bc0 RCX: 
0000000000000027
[   43.929876][  T270] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8882b5a19780
[   43.930431][  T270] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000001
[   43.931012][  T270] R10: ffffffffffffdfff R11: ffffc900041bf920 R12: 
ffff8881000f3ac0
[   43.931611][  T270] R13: 00005590e4eb8000 R14: 0000000000000001 R15: 
ffff888102fa2000
[   43.932188][  T270] FS:  00007f73c4641740(0000) 
GS:ffff8883324cb000(0000) knlGS:0000000000000000
[   43.932838][  T270] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.933301][  T270] CR2: 00005590e4eb8000 CR3: 00000001040d2000 CR4: 
00000000000006f0
[   43.933882][  T270] Call Trace:
[   43.934124][  T270]  <TASK>
[   43.934472][  T270]  do_pte_missing+0x233/0xb40
[   43.935004][  T270]  __handle_mm_fault+0x80e/0xcd0
[   43.935953][  T270]  handle_mm_fault+0x146/0x310
[   43.936462][  T270]  do_user_addr_fault+0x303/0x880
[   43.937078][  T270]  exc_page_fault+0x9b/0x270
[   43.937552][  T270]  asm_exc_page_fault+0x26/0x30
[   43.937918][  T270] RIP: 0033:0x5590e4eb41ea
[   43.938246][  T270] Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 
66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
[   43.939645][  T270] RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
[   43.940075][  T270] RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 
00007f73c474d44d
[   43.940644][  T270] RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 
000000000000000f
[   43.941210][  T270] RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 
00007f73c483a680
[   43.941786][  T270] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[   43.942351][  T270] R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 
00007f73c4869020
[   43.943383][  T270]  </TASK>
[   43.943620][  T270] irq event stamp: 2975
[   43.943912][  T270] hardirqs last  enabled at (2975): 
[<ffffffff81312500>] raw_spin_rq_unlock_irq+0x10/0x30
[   43.944626][  T270] hardirqs last disabled at (2974): 
[<ffffffff820e83e5>] __schedule+0xd35/0x1df0
[   43.945270][  T270] softirqs last  enabled at (2048): 
[<ffffffff812c7f1e>] handle_softirqs+0x38e/0x460
[   43.945956][  T270] softirqs last disabled at (2031): 
[<ffffffff812c84c9>] irq_exit_rcu+0xe9/0x160
[   43.946625][  T270] ---[ end trace 0000000000000000 ]---

> 
>>
>>> However, in a production environment, this is practically impossible.
>>
>> Can you expand on this?
>>
>> sysbot isn't a production environment ;)
> 
> Rebinding only works when the hierarchy is completely empty. This is
> generally not the case in a production environment (e.g. when systemd
> is used).
> 
> BTW, it seems rebinding is about to be deprecated:
> 
> cgroup1_reconfigure
> --> pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
>              task_tgid_nr(current), current->comm);
> 
> Also, it appears the current memcg subsystem assumes that
> cgroup_subsys_on_dfl(memory_cgrp_subsys) cannot be changed at runtime.
> (Please correct me if I missed anything.)
> 
> If we can get a reproducer, we can try the following fix, or simply drop
> rebinding altogether?
> 
>  From 6ae41b91339625dd7bf0f819f775f26e78171a73 Mon Sep 17 00:00:00 2001
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> Date: Mon, 27 Apr 2026 11:20:21 +0800
> Subject: [PATCH] mm: memcontrol: fix rcu unbalance in
>   get_non_dying_memcg_end()
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   mm/memcontrol.c | 30 ++++++++++++++++++++----------
>   1 file changed, 20 insertions(+), 10 deletions(-)

With the above patch applied, the warnings are gone.

If no one objects, I'll submit the formal fix. Or should we actually
just remove rebinding instead?

Thanks,
Qi

=====
Repro
=====


kernel diff
-----------
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..419883a483e32 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -36,6 +36,7 @@
  #include <linux/pagemap.h>
  #include <linux/folio_batch.h>
  #include <linux/vm_event_item.h>
+#include <linux/delay.h>
  #include <linux/smp.h>
  #include <linux/page-flags.h>
  #include <linux/backing-dev.h>
@@ -805,6 +806,28 @@ static long memcg_state_val_in_pages(int idx, long val)
   * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid 
race with
   * reparenting of non-hierarchical state_locals.
   */
+static __always_inline bool memcg_rcu_repro_task(void)
+{
+       return !strncmp(current->comm, "memcg-repro", TASK_COMM_LEN);
+}
+
+static noinline void memcg_rcu_repro_pause(void)
+{
+       if (memcg_rcu_repro_task())
+               mdelay(200);
+}
+
+static noinline void memcg_rcu_repro_check(const char *site, int 
depth_before)
+{
+       bool key_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
+       bool rcu_locked = rcu_preempt_depth() != depth_before;
+
+       WARN_ON_ONCE(memcg_rcu_repro_task() && key_on_dfl == rcu_locked);
+       if (memcg_rcu_repro_task() && key_on_dfl == rcu_locked)
+               pr_warn("%s: key_on_dfl=%d rcu_locked=%d depth_before=%d 
depth_now=%d\n",
+                       site, key_on_dfl, rcu_locked, depth_before, 
rcu_preempt_depth());
+}
+
  static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
mem_cgroup *memcg)
  {
         if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
@@ -865,10 +888,15 @@ static void __mod_memcg_state(struct mem_cgroup 
*memcg,
  void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
                        int val)
  {
+       int depth_before;
+
         if (mem_cgroup_disabled())
                 return;

+       depth_before = rcu_preempt_depth();
         memcg = get_non_dying_memcg_start(memcg);
+       memcg_rcu_repro_pause();
+       memcg_rcu_repro_check(__func__, depth_before);
         __mod_memcg_state(memcg, idx, val);
         get_non_dying_memcg_end();
  }
@@ -932,10 +960,14 @@ static void mod_memcg_lruvec_state(struct lruvec 
*lruvec,
  {
         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
         struct mem_cgroup_per_node *pn;
+       int depth_before;
         struct mem_cgroup *memcg;

         pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+       depth_before = rcu_preempt_depth();
         memcg = get_non_dying_memcg_start(pn->memcg);
+       memcg_rcu_repro_pause();
+       memcg_rcu_repro_check(__func__, depth_before);
         pn = memcg->nodeinfo[pgdat->node_id];

         __mod_memcg_lruvec_state(pn, idx, val);


/root/memcg-rcu-unbalance-repro.c
---------------------------------
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/prctl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static void die(const char *msg)
{
         perror(msg);
         exit(1);
}

static void ensure_parent_dir(const char *path)
{
         char tmp[PATH_MAX];
         char *slash;

         if (strlen(path) >= sizeof(tmp))
                 die("path too long");

         strcpy(tmp, path);
         slash = strrchr(tmp, '/');
         if (!slash)
                 return;

         while (slash > tmp && *slash == '/')
                 *slash-- = '\0';
         if (slash < tmp)
                 return;
         *++slash = '\0';

         for (slash = tmp + 1; *slash; slash++) {
                 if (*slash != '/')
                         continue;
                 *slash = '\0';
                 if (mkdir(tmp, 0755) < 0 && errno != EEXIST)
                         die("mkdir");
                 *slash = '/';
         }

         if (mkdir(tmp, 0755) < 0 && errno != EEXIST)
                 die("mkdir");
}

static void reset_file(int fd, off_t *off)
{
         if (ftruncate(fd, 0) < 0)
                 die("ftruncate");
         *off = 0;
}

static void socket_roundtrip(int txfd, int rxfd, const void *buf, size_t 
len)
{
         char rxbuf[4096];
         ssize_t n;

         for (;;) {
                 n = send(txfd, buf, len, 0);
                 if (n >= 0)
                         break;
                 if (errno != EINTR)
                         die("send");
         }
         if ((size_t)n != len) {
                 errno = EIO;
                 die("send");
         }

         for (;;) {
                 n = recv(rxfd, rxbuf, sizeof(rxbuf), 0);
                 if (n >= 0)
                         break;
                 if (errno != EINTR)
                         die("recv");
         }
         if ((size_t)n != len) {
                 errno = EIO;
                 die("recv");
         }
}

int main(int argc, char **argv)
{
         const char *path = argc > 1 ? argv[1] : 
"/tmp/memcg-rcu-repro.file";
         static char buf[4096];
         off_t off = 0;
         off_t max = 16LL * 1024 * 1024;
         int fd;
         int sv[2];
         int i;

         if (prctl(PR_SET_NAME, "memcg-repro", 0, 0, 0) < 0)
                 die("prctl(PR_SET_NAME)");

         for (i = 0; i < (int)sizeof(buf); i++)
                 buf[i] = (char)i;

         ensure_parent_dir(path);
         fd = open(path, O_CREAT | O_RDWR | O_TRUNC, 0600);
         if (fd < 0)
                 die("open");
         if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sv) < 0)
                 die("socketpair");

         for (;;) {
                 ssize_t n = pwrite(fd, buf, sizeof(buf), off);

                 if (n != (ssize_t)sizeof(buf)) {
                         if (n < 0 && errno == EINTR)
                                 continue;
                         if (n < 0 && (errno == ENOSPC || errno == 
EDQUOT)) {
                                 reset_file(fd, &off);
                                 continue;
                         }
                         die("pwrite");
                 }

                 off += sizeof(buf);
                 if ((off & ((1 << 20) - 1)) == 0) {
                         if (fsync(fd) < 0) {
                                 if (errno == EINTR)
                                         continue;
                                 if (errno == ENOSPC || errno == EDQUOT) {
                                         reset_file(fd, &off);
                                         continue;
                                 }
                                 die("fsync");
                         }
                 }

                 if (off >= max)
                         reset_file(fd, &off);

                 for (i = 0; i < 16; i++)
                         socket_roundtrip(sv[0], sv[1], buf, sizeof(buf));
         }
}

/root/memcg-rcu-unbalance-repro.sh
----------------------------------

#!/bin/sh
set -eu

WORKER_SRC="/root/memcg-rcu-unbalance-repro.c"
WORKER_BIN="/root/memcg-rcu-unbalance-repro"
WORKER_BIN_FALLBACK="/tmp/memcg-rcu-unbalance-repro"
WORKDIR="/tmp/memcg-rcu-repro"
CGV2_PROBE_MNT="$WORKDIR/cgv2-probe"
DATA_FILE="$WORKDIR/repro.file"
CG_MNT="/sys/fs/cgroup"
REPRO_HIER_NAME="memcg-rcu-repro"
RESTORE_CGROUP2_ON_EXIT=0
WORKER_CPU=""
V1_HOLD_MS="${V1_HOLD_MS:-800}"
V2_HOLD_MS="${V2_HOLD_MS:-50}"

need_root() {
     if [ "$(id -u)" -ne 0 ]; then
         echo "must run as root" >&2
         exit 1
     fi
}

is_mounted() {
     grep -Fqs " $1 " /proc/self/mountinfo
}

mount_fstype() {
     awk -v mountpoint="$1" '
         $5 == mountpoint {
             for (i = 1; i <= NF; i++) {
                 if ($i == "-") {
                     print $(i + 1)
                     exit
                 }
             }
         }
     ' /proc/self/mountinfo
}

setup_early_boot_env() {
     mount -o remount,rw / >/dev/null 2>&1 || true

     [ -d /proc ] || mkdir -p /proc
     [ -d /sys ] || mkdir -p /sys
     [ -d /dev ] || mkdir -p /dev
     [ -d /tmp ] || mkdir -p /tmp

     is_mounted /proc || mount -t proc proc /proc
     is_mounted /sys || mount -t sysfs sysfs /sys

     if ! is_mounted /dev && grep -qw devtmpfs /proc/filesystems 
2>/dev/null; then
         mount -t devtmpfs devtmpfs /dev >/dev/null 2>&1 || true
     fi
}

need_memory_controller() {
     if [ -r /proc/cgroups ] &&
        awk '$1 == "memory" && $4 == 1 { found = 1 } END { exit found ? 
0 : 1 }' /proc/cgroups; then
         return 0
     fi

     echo "memory controller not available; expected an enabled memory 
entry in /proc/cgroups" >&2
     exit 1
}

count_child_cgroups() {
     mountpoint="$1"
     count=0

     for d in "$mountpoint"/*; do
         [ -d "$d" ] || continue
         count=$((count + 1))
     done

     echo "$count"
}

umount_if_mounted() {
     if is_mounted "$1"; then
         umount "$1"
     fi
}

mount_cgroup2_probe() {
     if [ "$(mount_fstype "$CG_MNT")" = "cgroup2" ]; then
         echo "$CG_MNT"
         return 0
     fi

     umount_if_mounted "$CGV2_PROBE_MNT"
     mount -t cgroup2 none "$CGV2_PROBE_MNT"
     echo "$CGV2_PROBE_MNT"
}

mount_named_cgroup1_root() {
     umount_if_mounted "$CG_MNT"
     mount -t cgroup -o "none,name=$REPRO_HIER_NAME" none "$CG_MNT"
}

remount_memory_to_v1() {
     mount -t cgroup -o "remount,memory,name=$REPRO_HIER_NAME" none 
"$CG_MNT"
}

remount_memory_to_v2() {
     mount -t cgroup -o "remount,none,name=$REPRO_HIER_NAME" none "$CG_MNT"
}

sleep_ms() {
     ms="$1"

     if [ "$ms" -le 0 ]; then
         return 0
     fi

     if command -v usleep >/dev/null 2>&1; then
         usleep $((ms * 1000))
         return 0
     fi

     if command -v busybox >/dev/null 2>&1 && busybox usleep 1000 
 >/dev/null 2>&1; then
         busybox usleep $((ms * 1000))
         return 0
     fi

     if [ $((ms % 1000)) -eq 0 ]; then
         sleep $((ms / 1000))
         return 0
     fi

     sleep "$(printf '%d.%03d' $((ms / 1000)) $((ms % 1000)))"
}

cleanup() {
     set +e
     if [ -n "${WORKER_PID:-}" ]; then
         kill "$WORKER_PID" 2>/dev/null || true
         wait "$WORKER_PID" 2>/dev/null || true
     fi
     umount_if_mounted "$CGV2_PROBE_MNT"
     if [ "$RESTORE_CGROUP2_ON_EXIT" -eq 1 ]; then
         umount_if_mounted "$CG_MNT"
         mount -t cgroup2 none "$CG_MNT" >/dev/null 2>&1 || true
     fi
}

prepare_worker() {
     if [ -x "$WORKER_BIN" ]; then
         return 0
     fi

     if [ -x "$WORKER_BIN_FALLBACK" ]; then
         WORKER_BIN="$WORKER_BIN_FALLBACK"
         return 0
     fi

     if ! command -v cc >/dev/null 2>&1; then
         echo "no usable worker binary and no compiler in current 
environment" >&2
         echo "prebuild it before reboot with:" >&2
         echo "  cc -O2 -Wall -Wextra -o $WORKER_BIN $WORKER_SRC" >&2
         exit 1
     fi

     if cc -O2 -Wall -Wextra -o "$WORKER_BIN" "$WORKER_SRC"; then
         return 0
     fi

     echo "failed to compile worker in early-boot shell" >&2
     echo "prebuild it before reboot with:" >&2
     echo "  cc -O2 -Wall -Wextra -o $WORKER_BIN $WORKER_SRC" >&2
     exit 1
}

wait_for_worker_ready() {
     tries=0

     while [ "$tries" -lt 5 ]; do
         if kill -0 "$WORKER_PID" 2>/dev/null &&
            [ -r "/proc/$WORKER_PID/comm" ] &&
            grep -qx "memcg-repro" "/proc/$WORKER_PID/comm" &&
            [ -s "$DATA_FILE" ]; then
             return 0
         fi
         tries=$((tries + 1))
         sleep 1
     done

     echo "worker failed to become ready before remount loop" >&2
     if [ -r "/proc/$WORKER_PID/comm" ]; then
         echo "worker pid=$WORKER_PID comm=$(cat 
"/proc/$WORKER_PID/comm")" >&2
     else
         echo "worker pid=$WORKER_PID is not alive" >&2
     fi
     exit 1
}

need_root
setup_early_boot_env
mkdir -p "$WORKDIR" "$CGV2_PROBE_MNT"
trap cleanup EXIT INT TERM

if [ ! -d "$CG_MNT" ]; then
     mkdir -p "$CG_MNT"
fi

need_memory_controller
CGV2_CHECK_MNT="$(mount_cgroup2_probe)"
if [ ! -r "$CGV2_CHECK_MNT/cgroup.controllers" ] ||
    ! grep -qw memory "$CGV2_CHECK_MNT/cgroup.controllers"; then
     echo "memory controller is not on the default cgroup v2 hierarchy 
before repro" >&2
     echo "run this in early boot before anything binds memory to a 
legacy v1 hierarchy" >&2
     exit 1
fi

child_count="$(count_child_cgroups "$CGV2_CHECK_MNT")"
if [ "$child_count" -ne 0 ]; then
     echo "cgroup2 root already has child cgroups; memory rebind to v1 
will likely hit -EBUSY" >&2
     echo "run this in a minimal initramfs or early-boot shell with no 
non-root cgroups" >&2
     exit 1
fi

if [ "$CGV2_CHECK_MNT" = "$CGV2_PROBE_MNT" ]; then
     umount_if_mounted "$CGV2_PROBE_MNT"
fi

mount_named_cgroup1_root
RESTORE_CGROUP2_ON_EXIT=1

prepare_worker

if command -v nproc >/dev/null 2>&1 && command -v taskset >/dev/null 
2>&1; then
     if [ "$(nproc)" -ge 2 ]; then
         taskset -pc 1 $$ >/dev/null 2>&1 || true
         WORKER_CPU="0"
     else
         WORKER_CPU=""
     fi
else
     WORKER_CPU=""
fi

echo "apply the kernel patch in /root/memcg-rcu-unbalance-repro.patch 
before running this script"
echo "recommended kernel config: CONFIG_MEMCG=y CONFIG_MEMCG_V1=y 
CONFIG_PREEMPT_RCU=y"
echo "recommended boot param: panic_on_warn=1"
echo "worker binary: $WORKER_BIN"
echo "repro hierarchy: name=$REPRO_HIER_NAME mountpoint=$CG_MNT"
echo "remount cadence: v2=${V2_HOLD_MS}ms v1=${V1_HOLD_MS}ms"

if [ -n "$WORKER_CPU" ]; then
     taskset -c "$WORKER_CPU" "$WORKER_BIN" "$DATA_FILE" &
else
     "$WORKER_BIN" "$DATA_FILE" &
fi
WORKER_PID=$!
wait_for_worker_ready

echo "worker pid=$WORKER_PID comm=$(cat "/proc/$WORKER_PID/comm") 
data_file=$DATA_FILE"
echo "cgroup v1 remount/rebind loop starting; watch dmesg for:"
echo "  option changes via remount are deprecated"
echo "  mod_memcg_state: key_on_dfl=0 rcu_locked=0 depth_before=0 
depth_now=0"
echo "  WARN.*memcg_rcu_repro_check"
echo "  Voluntary context switch within RCU read-side critical section"
echo "  rcu_read_unlock.*underflow / bad unlock"

i=0
while :; do
     i=$((i + 1))
     remount_memory_to_v2
     sleep_ms "$V2_HOLD_MS"
     remount_memory_to_v1
     sleep_ms "$V1_HOLD_MS"
     if [ $((i % 10)) -eq 0 ]; then
         echo "completed $i rebind cycles"
     fi
done

