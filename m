Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35709C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0D56B0092; Mon,  4 Aug 2025 05:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1A66B0093; Mon,  4 Aug 2025 05:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCBE6B0095; Mon,  4 Aug 2025 05:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78F136B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:35:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A5291A1078
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:35:43 +0000 (UTC)
X-FDA: 83738567766.04.F4679FF
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2852F14000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:35:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jWNhuy/R";
	spf=pass (imf23.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754300141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcjWij1zfH9zgejgmouHVbcKEsPohZbovhnBUfRRKYA=;
	b=whp+uyMQLMshcLJzs4HNG9QofEScvdTgPZwucl9rlW5/XBG9SE4vyEKPagDSuSFANxyW1K
	DDf/+cIK0t8+Ruhr4ckGbNw3exUEF5RbjY5AR2OEAYKI9uzNq12q8cuoH6iCfTaiYTWBsl
	cJFiSlnn0HhCXc5ryPfFSXfIFSVo9gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754300141; a=rsa-sha256;
	cv=none;
	b=YbwgTsPJvmF2EfzPL5PC4mikSwMnv9zR+b9n8w1yyAZtHXAW2iwwKO6pGyu2j5A2bXCeoL
	2HTUdHgsQR0s6VuqnQaPr5BJOSlR1XE9JtG9J0tAZ9tWyiJUhgNh5dkRNTljq1qhrG4oO4
	oqnJ7W6a+pFp76QiIsy08xS8Fx8CN68=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="jWNhuy/R";
	spf=pass (imf23.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-707453b0306so31422146d6.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754300139; x=1754904939; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcjWij1zfH9zgejgmouHVbcKEsPohZbovhnBUfRRKYA=;
        b=jWNhuy/RPcXEsDgBL8twRHiNy/gixvacyYpNpsp4tw7DBKpItZDOuVCJ01vfgg8U//
         DCviTWhysSwDl2v6HD09dpPQb+agyW3dnvClIhXJbwBa5ioaSv9x++PSBsxZ6g6zgCjM
         kGpxDTNoTl+QpSFBrpP0JrIiwvBr3GMUkYQm1+ADWWqEW5yWRry+EDoCR1faRPlSJUJ6
         WnhNBb3WifHQWkiFV8BZ3MdyM5cP5e0ryUX/TTmUDYb1Vj0C7dgYen8pKtlesYcONznG
         +DfcCGxghsJJO0ROK5wGtmj5oBuveCwPbx13XpRUHmXJGVEb9xC3nllgI7AZr+AKX3oI
         QFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754300139; x=1754904939;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RcjWij1zfH9zgejgmouHVbcKEsPohZbovhnBUfRRKYA=;
        b=IACR677+oJ3FbMpBIXSSJaAGEd1DF3B5gwcZ9sP6WUgb5LEXBeaQYIzucngpeWhtPF
         TV3bW6LLX5v4zqVIuho2dOnk5z/HoTmbWwpKtR2HSAdUwFuC5jGOnWtU9NlWB/bo7Qg2
         jaSd7OGE8nCl1g/d2lcl5cx7p2RINKPXXd5t8ScydxifznNmZRp8ADzAt37SM+QZzMEM
         Ax0dP8CLGk8aPZzaK5eu0XLYcKSlwozgqhkr5gFISjNVvAdemg8YDgR4i9uuFG1qxsP8
         wWqjy24J9VYPGBnWd8qGG9BVTkVPVgRgwb3Cll3Qd6u5vmUMv54AJJr+jg9XPULVNEuJ
         qOfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF7WbV/OBSIlbF5/PrnaI3jnS+fyWfqqc2yWJiSCM9dcNM5FF4bQQ64CWiUQ0UiOU1hZRbwQJQqQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0JTZeejiBwPBNNDvsbjj3BY7X54vdUboFaowgSTabNNxLiPO5
	q/iWqBrtL7Iu9KxaAmQb3IsIJ+YgNhWGyfnd8I2vFfgK3NLrj/Kz6XvvUVEFmeQMSe0=
X-Gm-Gg: ASbGncvSrhizOkR7Us8cHSEg0l4KPjNPp2g2OOcEA0ig80doJbVh+gpRQH8luqDMXBO
	uxoI6ZGW0Ct8ZidJuluUcXZqbI7ME8U+Yl599PK2Z76THeva3beYJgXx1DD871CbxEENPkra7Mb
	GzPLMxjBdyQPnvWINwKC6pO+lw4dJNa/E/o2JGmeKIxJ9uVQqditohN94pAToGy22hkbWhOhkQL
	veCQJxkWc3rRyOOfQaH4Im4nauuW6MImcEeHuW2a40pg6BwTGKnfAO+JwgmleoaQN+kNWF0lYJL
	pvM5CsPDDZtE7KALMpa7+c8/V5C1Z1DqqDQLqzVI+9mnoX+h4e1JDDPb5RVoLv9xHHC4Lyln3ty
	G5RyF7++jsuT1TNkVVY8yQDlHMzKcoqWohvZ0ssqFwB+htRsjTQeA3fF0
X-Google-Smtp-Source: AGHT+IGJYeDoMlkbxXOekoon1joz4ipz4FPO6Mj7+15rgXMlIFwmDrM6pyUnxD9IxFCApfdn/Qj1VA==
X-Received: by 2002:a05:6214:2626:b0:707:159e:d1c9 with SMTP id 6a1803df08f44-7093637cd44mr112044766d6.51.1754300138944;
        Mon, 04 Aug 2025 02:35:38 -0700 (PDT)
Received: from [10.68.122.90] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde8d56sm56261826d6.73.2025.08.04.02.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 02:35:38 -0700 (PDT)
Message-ID: <7d92ec18-ff8e-4929-8b9a-f0bf5c6d249f@bytedance.com>
Date: Mon, 4 Aug 2025 17:35:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Barry Song <21cnbao@gmail.com>, "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <v-songbaohua@oppo.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 yi1.lai@intel.com
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
 <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
 <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com>
 <aJB0Kdc6cx1lGkdb@ly-workstation>
 <CAGsJ_4yw4Qn7OWmUJeJZYuOHLjJ7L8kov3Th3vFPa3h4y0ur_A@mail.gmail.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <CAGsJ_4yw4Qn7OWmUJeJZYuOHLjJ7L8kov3Th3vFPa3h4y0ur_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2852F14000B
X-Stat-Signature: xnppg9hybky95rhoq11n9n51zrp6x34m
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754300139-82263
X-HE-Meta: U2FsdGVkX1+CGXd2jQh8TpSubZq1oU5+W3JAhAQT7k8LllKfZLzMNBrt1iyRul3ZwLbF2AGh318hTzcuE3en5V3vgY5TWjNM34J4Gy6iklkXV9hnDHndTNVzeXSwbyPNfflHjYF4Yjz3cKKNqE7votm/jP2BOjVbMP9eAk70O0qSy40QhTxJdxor8BSUtAe2jjDqZQIOPd844mjJfI8Hq+b7NbMtNAWCmmlrljMeX6blrTQrX4KnZuvVkflH/CncFk5+vDdVmxRsT3JjGy10f5rjEDVLrjsESX8l/YNiSxtZhF3bjzoc5m1m2u/iYIbUKpzd8RWULuLyDNJ+6m6XF9CtH4drvhfMbvKOKkdNiZY0gPArnOuwte+96IBaUHr7aE7ea3863NWlpuMH7nk/M4JTURlrH7Rrq3TrWxeM4l2q0FoWDb+8qMph5H07RTgYksRtW1xmWSxTRCRm1WLzs+A472w5KwlQQDji5h8ThEbtt6FNA2hpqddQehR9s/Zg3Bgpsy/qNuwDUY+gPMNbds2RNZzjAaYDlP7H91R0PagorN+5AztYpjAsCDoOHiSoUc1dceByYzN/zSiJsX/gOhgPhZ3XVECfoULgwTIhn3YcBHTNe8hhlIrcbiJvvxgdO1uzxHGOLLqJb8DESkYL6zf58UH7phE1uJIQOvSiHHHwh20Ix5Jn4erDCQKZmzROFmdpMV3IrSJJW9rZx0kTg45Tq3phgnViN04AU8SebE6gvIkPBwYsEfkkT6HX9AdSeGH/ownjwx811ji2m+7sirgaDIGygbRBuivnURRCljCiIkkDZ1Fwz6GuwOYj1r09hK9mnyCQ9z7cz/7SDDiN+XNwndwF197Xg5WaQgs1C1GxN59XaYS3lKB1cttt9UsbHMOa3GjPgQpE9hcgY5LXOlG28g8Nmi5ovXnW1OOQuTXDuWxnIw4QE7584Gb/Qv/+DHCHovHff8tAnr+3xHM
 QqtVbruF
 m2YbZakqmpEdqfAYmuLClBGcNiP/LUbqhFGSIZmdkM7d0y1RxGf3hke4nxMBm/GSRut8QZ7kq8EYs9j5Kv2KTaUnA1yyjVBrDwtXKBC3SRtOyj4OOuARMsJbIv5VUzAX2vi35eZ3eDWwPgcGNs/fEB8B9AQcnGm38oMWfLbu9pT6kQoAAcqwYwEtwlLxIxRm0Co9ePD35Zvf3MhUXCt0wmgvNQ8OGPhruTjgRRnBzN0XVkOF7UJivKVbvx21WFUP4qfzHao4XXiXYhgCNvGbfby2QwGHRtVZF6A63ELjVwTPl91ykGWGygq4HcrE1cwEi61TJkoT6I1Pkeldegtntx/IRn4S48BqDq+41DswKKbJKJZyUAFdFRebyRN9IybbTd+GQFmACqO2TsgJMwMn3AtdG7mkYLp0JzTBJxZewJVJUEHdRIiD1gtrONX4obxnPzRsTf5j+Dz4t5IGTClUdf3jyQBfpvXJd53rl1G285FPnZVSvhTr05IrdNb+8YZ7gj1qVywUGMXEmQNvS6c7GMKItBloNIsZv5yXmGnSXPSzFE/bCQgQd9GAqU8pAASEco3MGn0hlVOvpQ356JIhdV05DnG3CLrg2UTGbNqrjMHg8Z1QZkQ8hB69mOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 5:15 PM, Barry Song wrote:
> On Mon, Aug 4, 2025 at 8:49 PM Lai, Yi <yi1.lai@linux.intel.com> wrote:
>>
>> On Mon, Aug 04, 2025 at 10:30:45AM +0200, David Hildenbrand wrote:
>>> On 04.08.25 10:26, Qi Zheng wrote:
>>>>
>>>>
>>>> On 8/4/25 3:57 PM, David Hildenbrand wrote:
>>>>> On 04.08.25 02:58, Lai, Yi wrote:
>>>>>> Hi Barry Song,
>>>>>>
>>>>>> Greetings!
>>>>>>
>>>>>> I used Syzkaller and found that there is general protection fault in
>>>>>> __pte_offset_map_lock in linux-next next-20250801.
>>>>>>
>>>>>> After bisection and the first bad commit is:
>>>>>> "
>>>>>> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
>>>>>> "
>>>>>>
>>>>>> All detailed into can be found at:
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock
>>>>>> Syzkaller repro code:
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock/repro.c
>>>>>> Syzkaller repro syscall steps:
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock/repro.prog
>>>>>> Syzkaller report:
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock/repro.report
>>>>>> Kconfig(make olddefconfig):
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock/kconfig_origin
>>>>>> Bisect info:
>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>> main/250803_193026___pte_offset_map_lock/bisect_info.log
>>>>>> bzImage:
>>>>>> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/
>>>>>> main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
>>>>>> Issue dmesg:
>>>>>> https://github.com/laifryiee/syzkaller_logs/blob/
>>>>>> main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
>>>>>
>>>>> Skimming over the reproducer, we seem to have racing MADV_DONTNEED and
>>>>> MADV_COLLAPSE on the same anon area, but the problem only shows up once
>>>>> we tear down that MM.
>>>>>
>>>>> If I would have to guess, I'd assume it's related to PT_RECLAIM
>>>>> reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
>>>>> does not indicate that CONFIG_PT_RECLAIM was set.
>>>>
>>>> On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM should
>>>> be enabled
>>>
>>> That's what I thought: but I was not able to spot it in the provided config
>>> [1].
>>>
>>> Or is that config *before* "make olfconfig"? confusing. I would want to see
>>> the actually used config.
>>>
>>>
>>>
>> My kernel compiling steps:
>> 1. copy kconfig_origin to kernel_source_folder/.config
>> 2. make olddefconfig
>> 3. make bzImage -jx
>>
>> I have also uploaded the actual .config during compiling.
>> [2] https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026___pte_offset_map_lock/.config
>> CONFIG_ARCH_SUPPORTS_PT_RECLAIM=y
>> CONFIG_PT_RECLAIM=y
> 
> Thanks! I can reproduce the issue within one second.

I also reproduced it locally.

BUG: Bad page map in process repro  pte:f000e987f000fea5 pmd:00000067
[22099.667758][T22301] addr:0000000020004000 vm_flags:00100077 
anon_vma:ffff8882c5b5fc98 mapping:0000000000000000 index:20004
[22099.671248][T22301] file:(null) fault:0x0 mmap:0x0 mmap_prepare: 0x0 
read_folio:0x0
[22099.673833][T22301] CPU: 15 UID: 0 PID: 22301 Comm: repro Tainted: G 
   B   W           6.16.0-rc4-next-20250704+ #200 PREEMPT(voluntary)
[22099.673838][T22301] Tainted: [B]=BAD_PAGE, [W]=WARN
[22099.673838][T22301] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.12.0-1 04/01/2014
[22099.673840][T22301] Call Trace:
[22099.673841][T22301]  <TASK>
[22099.673842][T22301]  dump_stack_lvl+0x53/0x70
[22099.673845][T22301]  print_bad_pte+0x178/0x220
[22099.673849][T22301]  vm_normal_page+0x8a/0xa0
[22099.673852][T22301]  unmap_page_range+0x5cb/0x1d40
[22099.673855][T22301]  ? flush_tlb_mm_range+0x21a/0x780
[22099.673859][T22301]  ? tlb_flush_mmu+0x30/0x1c0
[22099.673861][T22301]  unmap_vmas+0xab/0x160
[22099.673863][T22301]  exit_mmap+0xda/0x3c0
[22099.673868][T22301]  mmput+0x6e/0x130
[22099.673869][T22301]  do_exit+0x242/0xb40
[22099.673871][T22301]  do_group_exit+0x30/0x80
[22099.673873][T22301]  get_signal+0x951/0x980
[22099.673876][T22301]  ? futex_wake+0x84/0x170
[22099.673880][T22301]  arch_do_signal_or_restart+0x2d/0x1f0
[22099.673883][T22301]  ? do_futex+0x11a/0x1d0
[22099.673885][T22301]  ? __x64_sys_futex+0x67/0x1c0
[22099.673888][T22301]  exit_to_user_mode_loop+0x86/0x110
[22099.673890][T22301]  do_syscall_64+0x184/0x2b0
[22099.673892][T22301]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[22099.673895][T22301] RIP: 0033:0x7fafb0048af9
[22099.673896][T22301] Code: Unable to access opcode bytes at 
0x7fafb0048acf.
[22099.673898][T22301] RSP: 002b:00007fafaff50ea8 EFLAGS: 00000246 
ORIG_RAX: 00000000000000ca
[22099.673900][T22301] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 
00007fafb0048af9
[22099.673901][T22301] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000559d33cab1a8
[22099.673903][T22301] RBP: 00007fafaff50ec0 R08: 0000000000000000 R09: 
0000000000000000
[22099.673904][T22301] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007ffe78dbcd2e
[22099.673905][T22301] R13: 00007ffe78dbcd2f R14: 00007fafaff51700 R15: 
0000000000000000
[22099.673907][T22301]  </TASK>
[22099.673913][T22301] BUG: unable to handle page fault for address: 
ffffea7be1ffe548
[22099.674789][T22301] #PF: supervisor read access in kernel mode
[22099.674789][T22301] #PF: error_code(0x0000) - not-present page
[22099.674789][T22301] PGD 2bfff7067 P4D 2bfff7067 PUD 0
[22099.674789][T22301] Oops: Oops: 0000 [#1] SMP PTI
[22099.674789][T22301] CPU: 15 UID: 0 PID: 22301 Comm: repro Tainted: G 
   B   W           6.16.0-rc4-next-20250704+ #200 PREEMPT(voluntary)
[22099.674789][T22301] Tainted: [B]=BAD_PAGE, [W]=WARN
[22099.674789][T22301] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.12.0-1 04/01/2014
[22099.674789][T22301] RIP: 0010:unmap_page_range+0x1101/0x1d40
[22099.674789][T22301] Code: eb 03 cc cc cc f3 0f 1e fa f3 0f 1e fa e9 
ea 01 00 00 48 b8 ff ff ff ff ff 00 00 00 49 21 c2 49 c1 e2 06 4c 03 15 
ef a6 fd 00 <49> 8b 52 08 4c 89 d0 f6 c2 01 0f 8
[22099.674789][T22301] RSP: 0018:ffffc9000557baa0 EFLAGS: 00010282
[22099.674789][T22301] RAX: 00000003ffffffff RBX: 0000000020005000 RCX: 
f000000000000420
[22099.674789][T22301] RDX: 000000000000001e RSI: 0000000000000000 RDI: 
7803ff95ef87ff95
[22099.674789][T22301] RBP: f000d420f000d420 R08: ffff888000000028 R09: 
c000000100000864
[22099.674789][T22301] R10: ffffea7be1ffe540 R11: ffffc9000557b6b0 R12: 
0000000000000000
[22099.674789][T22301] R13: 00000000000001fb R14: ffffc9000557bcc0 R15: 
ffff888000000028
[22099.674789][T22301] FS:  00007fafaff51700(0000) 
GS:ffff8885b2b29000(0000) knlGS:0000000000000000
[22099.674789][T22301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22099.674789][T22301] CR2: ffffea7be1ffe548 CR3: 0000000103d8c000 CR4: 
00000000000006f0
[22099.674789][T22301] Call Trace:
[22099.674789][T22301]  <TASK>
[22099.674789][T22301]  ? flush_tlb_mm_range+0x21a/0x780
[22099.674789][T22301]  ? tlb_flush_mmu+0x30/0x1c0
[22099.674789][T22301]  unmap_vmas+0xab/0x160
[22099.674789][T22301]  exit_mmap+0xda/0x3c0
[22099.674789][T22301]  mmput+0x6e/0x130
[22099.674789][T22301]  do_exit+0x242/0xb40
[22099.674789][T22301]  do_group_exit+0x30/0x80
[22099.674789][T22301]  get_signal+0x951/0x980
[22099.674789][T22301]  ? futex_wake+0x84/0x170
[22099.674789][T22301]  arch_do_signal_or_restart+0x2d/0x1f0
[22099.674789][T22301]  ? do_futex+0x11a/0x1d0
[22099.674789][T22301]  ? __x64_sys_futex+0x67/0x1c0
[22099.674789][T22301]  exit_to_user_mode_loop+0x86/0x110
[22099.674789][T22301]  do_syscall_64+0x184/0x2b0
[22099.674789][T22301]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[22099.674789][T22301] RIP: 0033:0x7fafb0048af9
[22099.674789][T22301] Code: Unable to access opcode bytes at 
0x7fafb0048acf.
[22099.674789][T22301] RSP: 002b:00007fafaff50ea8 EFLAGS: 00000246 
ORIG_RAX: 00000000000000ca
[22099.674789][T22301] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 
00007fafb0048af9
[22099.674789][T22301] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000559d33cab1a8
[22099.674789][T22301] RBP: 00007fafaff50ec0 R08: 0000000000000000 R09: 
0000000000000000
[22099.674789][T22301] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007ffe78dbcd2e
[22099.674789][T22301] R13: 00007ffe78dbcd2f R14: 00007fafaff51700 R15: 
0000000000000000
[22099.674789][T22301]  </TASK>

> After disabling PT_RECLAIM in .config, the issue disappears.

Thanks for the test, I'll take a closer look.

> The reason it doesn't occur on arm64 is that x86 is the only platform
> that supports ARCH_SUPPORTS_PT_RECLAIM.
> 
>>
>>> [1] https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/kconfig_origin
>>>
>>> --
>>> Cheers,
>>>
>>> David / dhildenb
>>>
> 
> Thanks
> Barry


