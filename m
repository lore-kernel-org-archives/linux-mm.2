Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14061D3514F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6B86B0088; Wed,  1 Apr 2026 03:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F1C6B0089; Wed,  1 Apr 2026 03:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4F76B008A; Wed,  1 Apr 2026 03:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57D076B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:36:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3327BA618
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:36:42 +0000 (UTC)
X-FDA: 84609179844.17.516234D
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0592A120004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:36:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmQaQ3+K;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775029001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/AwEztMDqtsMbeOwVN0BqnjQN3kvTb70v7HbmHYZ8I=;
	b=IueiwH/t/zDibEXvnMnv3LXAlXF2neUSF26hBJom1dyX63J4k5UN3EHgki2wTzNsRc719a
	TYuxYjszgMaq1GDA9a1NEC4tuNTKWxmxEH0zyn0YzGby5LHamNUyp8+zOjcKRIj86B7aRG
	Zts2N06ll2TqsuSvGs3SZ0vHyRfq6pE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmQaQ3+K;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775029001; a=rsa-sha256;
	cv=none;
	b=GAPfEIiPjUuqhzWIhfM6WXy82+Dji3jej9zwi4Jw9nv3AM/Zu/E9u3a+kKE/Pas4nZdrCl
	3lC/QYBGXheZDoiwIb/VtttBiKbwrz8CJQwGJ7R/psJEx6IFxo9IvjPeB/7CWXFS6fAv8K
	0OOYOrdzrTCMlTEzvYYLW8GOsOILEqA=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35d9749c26dso3052391a91.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 00:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775029000; x=1775633800; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m/AwEztMDqtsMbeOwVN0BqnjQN3kvTb70v7HbmHYZ8I=;
        b=JmQaQ3+KtScLONEWK8HuX96kkzNQjvrzpDe7cTSGFH4HG366Iw0Ahde3Bndn5WB8v4
         xbMrnN60c4aPEw2grAFnxy2k1Rpyke3HnahG37/4HMVFa76NpPZ7wFWKB4NVtPIq7jKy
         Kxr2ENcR5156n2/tLQMjEvLnsMIldHH22zq67zh8ksU4j3dBKX7OeoT72hAqSBBA+2r+
         /AOqnqpUKOQDdAhrZkJ059NEyI7TYPACtifuJcsNJxq4z0Y2trmIAoEHxaFVQA6zMCj6
         RAQ3hBscdHid32iaP5v5MedJOSMrqsOnxiWxSMN827WF6+MvWIeF0d5jaNSazGLyctjh
         LLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775029000; x=1775633800;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/AwEztMDqtsMbeOwVN0BqnjQN3kvTb70v7HbmHYZ8I=;
        b=ePWtUg0iyDduNsbNuDzJRJH8xV0/0HJLzsGDrYolDXnQJaoFy9AOVdG4uiUkkfQxqy
         IHrF2YlSxovmFFzkQ4zGMpi47vttUEhGCi/qnpvdZtAeaWE8n3tuPzpHfMOD5wFTEg+8
         rl3qioWednONuTBNQX0KfvDo41ypsb5e/fcqOp50pGQfoSVe5p0V+ykpAx2siun+hexd
         tzUiqPPmoD6SsL7h2XVgZV+MXGOhrsVkVDW3udNQo+fi4Q7VccZFP5XNVQavmPJkvkI9
         9lJg3LjkXW8Pt0j87S7ElLWM+8yzXEyyptH5wQS36lXxjcYcwsnfUMv3r4UJWZkMEUED
         oUNA==
X-Forwarded-Encrypted: i=1; AJvYcCWWFXIqCZh1nIsyUtvx4BxNO97cggiAJ7PHXgCTy5kgiSPFj7umh80BRB0cOXOnJzJdTVJUAS37dw==@kvack.org
X-Gm-Message-State: AOJu0YwiDheh0C9qZWeB1qFrfB2x9GkwLVWOy8OZU7gNNOLjyPr3KVAq
	PWHUaig4E8jCCBjOZRZMEZ/XlafG90jN+TzgVAQK5ZvIlO0Cj5yDNcWs
X-Gm-Gg: ATEYQzza+YJoTn3amJa8Xe5ourfscHmdmcmiv5WkVav6/ImxjJk9lTouNWl8xzd3fJw
	gv0TyAGnoDOREIFgrwKtV3UJIXaVu7/Xfidx0EBI5kRBMPXMnkj9q4UbeEkRSDkTdWjQX6A+Bk/
	e2r47rNtiRqTnW+bnasW2NNlKxQylJGdC4gxNHd38VbEf/fshUq74Ckn1R7gDHogEdXkdlrMY6b
	n/DXXD4I58SXg21O71NHnL4EmpbD3he2paLmYHmuAGDmcPQlxIHiV/GkJBfM49P0eRzgrSJ/WAv
	OElHK+6sM/gHEcYCkIC35GILChLUv/L+vM8ysv68pqjXOBxXM/azzt6BufhvzoozqruLYY6JmZb
	ecAgQj3EinYfRKRXTPRgRQqHyy95hiVJ08Mi9tyoj0ddM0rN6tOz2nP1fvWhROQ6L0qx6OPa6WI
	Is4BuZ/h0RuqlNuFu6+wa9f1eBOCIvMB+beqXRNjGVBdNBS7c96z312tgAwfHw1KDqAAIIa3+t7
	8xfvX4=
X-Received: by 2002:a17:90b:390a:b0:35c:1f29:712f with SMTP id 98e67ed59e1d1-35dc6fb1b30mr2238299a91.24.1775028999549;
        Wed, 01 Apr 2026 00:36:39 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe606dd2sm5371992a91.3.2026.04.01.00.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 00:36:38 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:36:31 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Leno Hou <lenohou@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 00/12] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <acy05cNH3klMH5Wn@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <856f3172-96aa-4cd6-9d40-857bc59b0c35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <856f3172-96aa-4cd6-9d40-857bc59b0c35@gmail.com>
X-Rspam-User: 
X-Stat-Signature: ewu4w95jzhd6n5jggkdofk7tc9susrgm
X-Rspamd-Queue-Id: 0592A120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775029000-25491
X-HE-Meta: U2FsdGVkX18hlm2rYG8kQSDCau75alstQoa29cwt/WEk3YLYO/uHzGaz9dB6W91eItyJ2JtGtB+C/DUAoUEqVHFpmD5Og6Gwr6yJxhg+AGxuxg+ztUrwceF4l2eNUQWwBNHOIc+CHn8C2ABTf148iYYN9Ui68FWkg4rDKiqmQS1WINHwHAQM641S4Wregh4LAzmLuuww05q6Xr4eSx6uxPCld4whFTDpz9PC4yqbSIXByYcMpr/qhy9r1MsCdXel17zitW2/XmuQAep9/xSZvfNiwOW5rcz/lcmEFVP4DKhF2iIhbeCiOLzSj2rOhMK5NlgKcLKHmuGHm+dy5SUoDQIUkaDqlUncTsVcfGmjtjFYghbj4s75rF7LToHluawgzkYVhaNsIa18jAKMEgb3kafhMkApmP49dYXC0ZXbFSowdVZfbtJsJM7iXmTZWsSvX9rPNGErbJakJa2afsC6ov8sSmIezQplC74Vt6g5etnRcCyU76Z0k9W6ATWXv5lEewMuaMjbgv7da6fjbTW74/4VWP5NvsdRkNUtgEGFSLpIsKTrUJj01uX1cYxWQqj9s49SsBqRqBKjBfBxSMoZVyCXbvjhNQcbv2KoJrYe4wVpHYQ8Bvb3ArXskvkULXZZBGsZhvjDCAr/mIVKHPNcEuYZEAjQWKvn7eGHplobrZb68Nx9ByYkhHfs5lO4jNzI22pmyl1x7AJhsdFJknhwFO/s+Fd7gKZrMGudV46j8M8xVHy/8H907wVIaXmowktcLu20Ewe1qCu/wdhaWBq6NGxFZdmA+acrU/WaxUHC/5Mo/PTVu7Xd6a8HrnGUPVrqbKaOKqGsYzXwQIFf8b9OjBZmdIEW8UEqUAdBDjhHvsYQnNVmOwAsQ+1hJHq3l43YwtHHutLxv0NZ/ugCQAH1rWeDcT0QFu7f54lzp2Bo8c31klobdqHht88Ocn8UqBwr54OkMUec4k3P+UwJ0n7
 PxEicbnB
 c5JbqHNSiZ5S7Y23+/ri9a1tKVUuEtT4h28yQCScIRTqPKgIvF3Siv9egamfi32kmxa0SFp1qDmxGLV/XTf5qtWi932AWNhATVUzrN6mtF0xzLfNDrbTaHscFj2RDPF2VDbTrQzewQBqAZFVl/fvlekpTIwQqN4O0hCyOrSlwIY43GViX93Q2KX9LpHfsyPvvY7TCyYPR6glma4NfcJDf2jE50IWj5mE530S3HKsxaZ19+8bsVSt8q1aTNqaNB9rlLVie30dfe/H1zOJY3B7uTIJ+DNUimFkRanahBrVnxGdehCutSmfkLv7kVREWMUnreqJmnvl8/EWf91Tq2UqF4JOiaTfIvbwqBn8B+fCUDR7qHdCZGFt63Jimyvny/iDRmq+qztJp27stRMOlOz/515G1uscbfrGotMctqd9V+QGexNa5GDPbqaOJekWiJSJJmXUdlVXEKCknTureJ644zaipl4nVzltWX6Vr2tjSi1mXTAQGMa9vqC21VGZF1mx70cPi2/9wlcsY5NvaXK3UNd7dv/VhkuP9VZxR2LhyTxzrLBd0FsIk7NwYZN/ldk85MGp+uQOWRDl1SoJd6vEjV1UcWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:18:16PM +0800, Leno Hou wrote:
> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > The aging OOM is a bit tricky, a specific reproducer can be used to
> > simulate what we encountered in production environment [4]: Spawns
> > multiple workers that keep reading the given file using mmap, and pauses
> > for 120ms after one file read batch. It also spawns another set of
> > workers that keep allocating and freeing a given size of anonymous memory.
> > The total memory size exceeds the memory limit (eg. 44G anon + 8G file,
> > which is 52G vs 48G memcg limit).
> > 
> > - MGLRU disabled:
> >    Finished 128 iterations.
> > 
> > - MGLRU enabled:
> >    OOM with following info after about ~10-20 iterations:
> >      [  154.365634] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
> >      [  154.366456] memory: usage 50331648kB, limit 50331648kB, failcnt 354207
> >      [  154.378941] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
> >      [  154.379408] Memory cgroup stats for /demo:
> >      [  154.379544] anon 44352327680
> >      [  154.380079] file 7187271680
> > 
> >    OOM occurs despite there being still evictable file folios.
> > 
> > - MGLRU enabled after this series:
> >    Finished 128 iterations.
> 
> Hi Kairui,

Hi Leno,

> 
> I've tested on v6.1.163 and unable to reproduce the OOM issue by your test
> script [4], Could you point the kernel version in your environment or more
> information?
> 

Thanks for testing!

Right, this one is very tricky to trigger, I struggled a lot with that
and took many attempts to construct a reproducer. I later changed the
setup to 16G memcg for easier reproduce, idea is still the same:

- Mount a ramdisk (/dev/pmem0) at /mnt/ramdisk:
  mkfs.xfs -f /dev/pmem0; mount /dev/pmem0 /mnt/ramdisk/
- Setup a 16g memcg
  mkdir -p /sys/fs/cgroup/demo
  echo 16G > /sys/fs/cgroup/demo/memory.max
  echo $$ > /sys/fs/cgroup/demo/cgroup.procs
  echo $PPID > /sys/fs/cgroup/demo/cgroup.procs
  echo $BASHPID > /sys/fs/cgroup/demo/cgroup.procs
- Then run the reproducer:
  file_anon_mix_pressure /mnt/ramdisk/test.img 14g 8g 96 96 120000

The parameters is depend on your system config. My system is a
48c96t machine:

$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              96
On-line CPU(s) list: 0-95
Thread(s) per core:  2
Core(s) per socket:  24
Socket(s):           2
NUMA node(s):        2
Vendor ID:           GenuineIntel
BIOS Vendor ID:      Intel(R) Corporation
CPU family:          6
Model:               85
Model name:          Intel(R) Xeon(R) Platinum 8255C CPU @ 2.50GHz
BIOS Model name:     Intel(R) Xeon(R) Platinum 8255C CPU @ 2.50GHz
Stepping:            7
CPU MHz:             3100.021
CPU max MHz:         2501.0000
CPU min MHz:         1000.0000
BogoMIPS:            5000.00
Virtualization:      VT-x
L1d cache:           32K
L1i cache:           32K
L2 cache:            1024K
L3 cache:            36608K
NUMA node0 CPU(s):   0-23,48-71
NUMA node1 CPU(s):   24-47,72-95
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 intel_ppin ssbd mba ibrs ibpb stibp ibrs_enhanced tpr_shadow flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm ida arat pln pts vnmi pku ospke avx512_vnni md_clear flush_l1d arch_capabilities

$ free -m
               total        used        free      shared  buff/cache   available
Mem:           62132        9553       49022          18        4172       52579
Swap:              0           0           0

And gets the OOM without this series:
[   17.537545] XFS (pmem0): Ending clean mount
[   49.329042] hrtimer: interrupt took 13930 ns
[   49.823993] file_anon_mix_p (3832): drop_caches: 3
[   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
[   62.624892] CPU: 95 UID: 0 PID: 4875 Comm: file_anon_mix_p Kdump: loaded Not tainted 7.0.0-rc5.orig-gb822cd37c749 #292 PREEMPT(full)·
[   62.624897] Hardware name: Red Hat KVM/RHEL-AV, BIOS 0.0.0 02/06/2015
[   62.624899] Call Trace:
[   62.624902]  <TASK>
[   62.624905]  dump_stack_lvl+0x4a/0x70
[   62.624912]  dump_header+0x43/0x1b3
[   62.624918]  oom_kill_process.cold+0x8/0x85
[   62.624922]  out_of_memory+0xee/0x280
[   62.624927]  mem_cgroup_out_of_memory+0xbc/0xd0
[   62.624933]  try_charge_memcg+0x3c1/0x5d0
[   62.624936]  charge_memcg+0x4a/0xb0
[   62.624939]  __mem_cgroup_charge+0x28/0x80
[   62.624942]  alloc_anon_folio+0x1d1/0x3d0
[   62.624947]  do_anonymous_page+0x19d/0x550
[   62.624950]  ? pte_offset_map_rw_nolock+0x1b/0x80
[   62.624954]  __handle_mm_fault+0x346/0x6d0
[   62.624956]  ? __schedule+0x29c/0x5b0
[   62.624968]  handle_mm_fault+0xe8/0x2d0
[   62.624971]  do_user_addr_fault+0x204/0x660
[   62.624977]  exc_page_fault+0x67/0x170
[   62.624979]  asm_exc_page_fault+0x22/0x30
[   62.624982] RIP: 0033:0x401451
[   62.624985] Code: 00 00 00 c3 0f 1f 44 00 00 48 83 7f 10 00 74 23 31 c0 0f 1f 80 00 00 00 00 48 8b 57 18 48 01 c2 48 03 57 08 48 05 00 10 00 00 <c6> 02 00 48 3b 47 10 72 e6 c7 47 20 01 00 00 00 31 c0 c3 90 66 66
[   62.624987] RSP: 002b:00007f3ec53a5e68 EFLAGS: 00010206
[   62.624989] RAX: 000000000731d000 RBX: 00007f3ec53a66c0 RCX: 00007f4271ca02d6
[   62.624991] RDX: 00007f425cefd000 RSI: 00007f3ec53a6fb0 RDI: 000000000a2f1c28
[   62.624992] RBP: 00007f3ec53a5f30 R08: 0000000000000000 R09: 0000000000000021
[   62.624993] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f3ec53a66c0
[   62.624995] R13: 00007ffe83436d80 R14: 00007f3ec53a6ce4 R15: 00007ffe83436e87
[   62.624998]  </TASK>
[   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24460
[   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
[   62.640823] Memory cgroup stats for /demo:
[   62.641017] anon 10604879872
[   62.641941] file 6574858240
[   62.642259] kernel 0
[   62.642443] kernel_stack 0
[   62.642674] pagetables 0
[   62.642889] sec_pagetables 0
[   62.643318] percpu 0
[   62.643545] sock 0
[   62.643782] vmalloc 0
[   62.643987] shmem 0
[   62.644244] zswap 0
[   62.644425] zswapped 0
[   62.644666] zswap_incomp 0
[   62.644917] file_mapped 6574698496
[   62.645344] file_dirty 0
[   62.645835] file_writeback 0
[   62.646707] swapcached 0
[   62.647430] anon_thp 0
[   62.648204] file_thp 0
[   62.648895] shmem_thp 0
[   62.649737] inactive_anon 10597609472
[   62.650675] active_anon 7270400
[   62.651549] inactive_file 6367440896
[   62.652430] active_file 179376128
[   62.653318] unevictable 0
[   62.653976] slab_reclaimable 0
[   62.654664] slab_unreclaimable 0
[   62.655625] slab 0
[   62.656418] workingset_refault_anon 0
[   62.656816] workingset_refault_file 1120215
[   62.657293] workingset_activate_anon 0
[   62.657667] workingset_activate_file 45850
[   62.658167] workingset_restore_anon 0
[   62.658562] workingset_restore_file 45850
[   62.658981] workingset_nodereclaim 0
[   62.659417] pgdemote_kswapd 0
[   62.659715] pgdemote_direct 0
[   62.660102] pgdemote_khugepaged 0
[   62.660434] pgdemote_proactive 0
[   62.660730] pgsteal_kswapd 0
[   62.661015] pgsteal_direct 1612151
[   62.662669] pgscan_khugepaged 0
[   62.662990] pgscan_proactive 0
[   62.663393] pgrefill 4536757
[   62.663706] pgpromote_success 0
[   62.664115] pgscan 3867681
[   62.664397] pgsteal 1612151
[   62.664691] pswpin 0
[   62.664925] pswpout 0
[   62.665266] pgfault 35906959
[   62.665564] pgmajfault 95947
[   62.665867] pgactivate 3693439
[   62.666261] pgdeactivate 0
[   62.666492] pglazyfree 34
[   62.666728] pglazyfreed 0
[   62.666990] swpin_zero 0
[   62.667365] swpout_zero 0
[   62.667664] zswpin 0
[   62.667910] zswpout 0
[   62.668235] zswpwb 0
[   62.668472] thp_fault_alloc 0
[   62.668790] thp_collapse_alloc 0
[   62.669211] thp_swpout 0
[   62.669469] thp_swpout_fallback 0
[   62.669762] numa_pages_migrated 0
[   62.670177] numa_pte_updates 0
[   62.670470] numa_hint_faults 0
[   62.670774] Memory cgroup min protection 0kB -- low protection 0kB
[   62.670776] Tasks state (memory values in pages):
[   62.672213] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
[   62.673379] [   3364]     0  3364     1794      900       73      827         0    57344        0             0 spawn-cgroup.sh
[   62.674519] [   3266]     0  3266    72782     2891      576     2315         0   110592        0             0 fish
[   62.675663] [   3591]     0  3591    55883     2979      625     2354         0   110592        0             0 fish
[   62.676546] [   3832]     0  3832  3867588  2588259  2587769      490         0 21630976        0             0 file_anon_mix_p
[   62.677691] [   3962]     0  3962  2098020  1237009      281  1236728         0 16855040        0             0 file_anon_mix_p
[   62.678950] [   3963]     0  3963  2098020  1236990      281  1236709         0 16855040        0             0 file_anon_mix_p
[   62.680233] [   3964]     0  3964  2098020  1236985      281  1236704         0 16855040        0             0 file_anon_mix_p
[   62.681374] [   3965]     0  3965  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.682501] [   3966]     0  3966  2098020  1237015      281  1236734         0 16855040        0             0 file_anon_mix_p
[   62.683637] [   3967]     0  3967  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.684812] [   3968]     0  3968  2098020  1237015      281  1236734         0 16855040        0             0 file_anon_mix_p
[   62.685883] [   3969]     0  3969  2098020  1236967      281  1236686         0 16855040        0             0 file_anon_mix_p
[   62.686988] [   3970]     0  3970  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.688168] [   3971]     0  3971  2098020  1236993      281  1236712         0 16855040        0             0 file_anon_mix_p
[   62.689402] [   3972]     0  3972  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.690621] [   3973]     0  3973  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.691839] [   3974]     0  3974  2098020  1237011      281  1236730         0 16855040        0             0 file_anon_mix_p
[   62.693550] [   3975]     0  3975  2098020  1237016      281  1236735         0 16855040        0             0 file_anon_mix_p
[   62.695292] [   3976]     0  3976  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.696997] [   3977]     0  3977  2098020  1237014      281  1236733         0 16855040        0             0 file_anon_mix_p
[   62.698734] [   3978]     0  3978  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.700415] [   3979]     0  3979  2098020  1236992      281  1236711         0 16855040        0             0 file_anon_mix_p
[   62.702153] [   3980]     0  3980  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.703859] [   3981]     0  3981  2098020  1236919      281  1236638         0 16855040        0             0 file_anon_mix_p
[   62.705597] [   3982]     0  3982  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.707329] [   3983]     0  3983  2098020  1236277      281  1235996         0 16855040        0             0 file_anon_mix_p
[   62.709056] [   3984]     0  3984  2098020  1236952      281  1236671         0 16855040        0             0 file_anon_mix_p
[   62.710732] [   3985]     0  3985  2098020  1236948      281  1236667         0 16855040        0             0 file_anon_mix_p
[   62.712482] [   3986]     0  3986  2098020  1237014      281  1236733         0 16855040        0             0 file_anon_mix_p
[   62.714184] [   3987]     0  3987  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.715930] [   3988]     0  3988  2098020  1237015      281  1236734         0 16855040        0             0 file_anon_mix_p
[   62.717543] [   3989]     0  3989  2098020  1237015      281  1236734         0 16855040        0             0 file_anon_mix_p
[   62.719129] [   3990]     0  3990  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.720723] [   3991]     0  3991  2098020  1237011      281  1236730         0 16855040        0             0 file_anon_mix_p
[   62.722356] [   3992]     0  3992  2098020  1236945      281  1236664         0 16855040        0             0 file_anon_mix_p
[   62.723893] [   3993]     0  3993  2098020  1237017      281  1236736         0 16855040        0             0 file_anon_mix_p
[   62.725413] [   3994]     0  3994  2098020  1236982      281  1236701         0 16855040        0             0 file_anon_mix_p
[   62.727108] [   3995]     0  3995  2098020  1237012      281  1236731         0 16855040        0             0 file_anon_mix_p
[   62.728701] [   3996]     0  3996  2098020  1236990      281  1236709         0 16855040        0             0 file_anon_mix_p

.. snip ..

The testing kernel commit is latest mm-new:

$ git log --oneline
b822cd37c749 (HEAD) mm/mglru: improve reclaim loop and dirty folio handling
  # This is a empty commit, to hold my cover letter.
54c9d0359b18 selftests-mm-add-merge-test-for-partial-msealed-range-fix
  # This is mm-new, see below.
fc127b77592e selftests/mm: add merge test for partial msealed range
ff02b14f414c mm/vmalloc: use dedicated unbound workqueue for vmap purge/drain

$ git log 54c9d0359b18
commit 54c9d0359b180b34070aa7ff8d9428fa3db8acbb (akpm/mm-new)
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Mar 30 17:12:35 2026 -0700

    selftests-mm-add-merge-test-for-partial-msealed-range-fix

Note you may see fish in the OOM list, I use that shell, bash and
the memcg spawn is wrapped by spawn-cgroup.sh, irrelevant but just
to avoid confusion.

Reproducer log:
.. snip ..
[phase3] Starting 96 anonymous pressure threads (14336 MB x 128 rounds)...
[pressure] Round 1/128: faulting 14336 MB across 96 threads...
[pressure] Round 1/128 complete.
[pressure] Round 2/128: faulting 14336 MB across 96 threads...
[pressure] Round 2/128 complete.
[pressure] Round 3/128: faulting 14336 MB across 96 threads...
[pressure] Round 3/128 complete.

.. snip ...

[pressure] Round 17/128 complete.
[pressure] Round 18/128: faulting 14336 MB across 96 threads...
[pressure] Round 18/128 complete.
[pressure] Round 19/128: faulting 14336 MB across 96 threads...
fish: Job 1, './file_anon_mix_pressure /mnt/r…' terminated by signal SIGKILL (Forced quit)

OOM doesn't occur with MGLRU disabled or after this series,
128 rounds finishes just fine.

Very unfortunately I haven't find a easy and generic way to
reproduce this as the time window is extremely short: if
another reclaim thread keeps getting rejected due to
should_run_aging return true, and a racing thread is doing
the aging but not finished, MGLRU might OOM when it shouldn't.

This series greatly avoided that, but in very rare cases and
in theory, we may still see OOM due to the force protection
of MIN_NR_GENS. That can be fixed later.

We have see some very rare OOM issue with several services.
It took me a long time to figure out what is actually wrong here
since the racing window is extremely tiny and hard to trigger.
This reproducer is currently the best I can provide to simulate
that. It's not a 100% accurate and stable but close enough.

Maybe you can try to adjust the parameters to reproduce
that, and the storage have to be fast for the reproducer.

