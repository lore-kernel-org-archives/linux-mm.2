Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD9CD0D14B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0AE6B0092; Wed,  7 Jan 2026 12:31:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E066B0093; Wed,  7 Jan 2026 12:31:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A596B0095; Wed,  7 Jan 2026 12:31:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E69AC6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:31:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7133AC1DA4
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:31:36 +0000 (UTC)
X-FDA: 84305859792.21.EFA0DA2
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 529E4A0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:31:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=tuxon.dev header.s=google header.b=AVis+xHv;
	spf=pass (imf25.hostedemail.com: domain of claudiu.beznea@tuxon.dev designates 209.85.218.52 as permitted sender) smtp.mailfrom=claudiu.beznea@tuxon.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767807094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tJMiCWsBTgaBtX6YcmAD7SxE1pfFss1iT/w15mQpFA=;
	b=6u40QI+deT+JADrNYjVCF7xh/XQLtuDo+fUKz6wPvDEQwdfmdMu14HaQW1qJcnYlyfef6S
	WJeMp1VGdPGsyyVqJ8s/r2XQWrr/U3q7cWzY0JQyLox7yapOCi1TQ1GOzu68j6zTPJJkID
	PxiuC+WDfbr4TRIaNcSuLBEqY1nzP9w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=tuxon.dev header.s=google header.b=AVis+xHv;
	spf=pass (imf25.hostedemail.com: domain of claudiu.beznea@tuxon.dev designates 209.85.218.52 as permitted sender) smtp.mailfrom=claudiu.beznea@tuxon.dev;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767807094; a=rsa-sha256;
	cv=none;
	b=b15cBoWDSq2iSFeisX8z3VFARRKq3RHQYS5cRCbFyO1Yn7buvlMPU9krRJEODu+l+th29D
	htk+cgF/58kKBxe7mcw1WRaHG2IOthPnNIXADsAkqfViTzEK3hA/3l4ZOrYfOs1xn9WJas
	motDb0LAoU/BdNRbwLsZ9xeVaPTb2tQ=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7cee045187so197496366b.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 09:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1767807093; x=1768411893; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0tJMiCWsBTgaBtX6YcmAD7SxE1pfFss1iT/w15mQpFA=;
        b=AVis+xHvjBzovDd9Zrrx4K55GkO4snst6qTWUFWp1aoWhcLKsx4XTnOC7ijrn5eAFH
         vhmCKn/rTZ5NQFfeUmqnJ/Gvbg+PhUpozEZA2EIQTBhUoma9q/yxzDWx1HRIM9Azt/go
         GotjwlhGOKK87PJjI6vk1cDrJUahRrjPd4Nn6p0GeUv51ZbkbB3RAQCjGb6GcQU9pjLD
         xvF1cSabDqBPJmfBjAVViPa5rpA4EGJk3SWboYzRhhcQH3dLn3QOeLrPOxkwqaFEkEtz
         63fEe9xJeHezsSYsqw9sEFR7vNWhbxfe7yEjKsYox+EF9GD0Yix5w5WI/F3EMKbgwkbk
         17Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767807093; x=1768411893;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0tJMiCWsBTgaBtX6YcmAD7SxE1pfFss1iT/w15mQpFA=;
        b=Ijec2NnkIjSa6C/bYmKlnEv1gHs5UH/rQjPVI8fJDJxqVoFU8b0fehLvketFFkkDTH
         hHEANmlC42WHmkSy+Y/gLv1jLwIwAmjQr/CKpcP//86nnWgo7J4XeNcxVi4/9qFk4q12
         u2Ir7BMrRMKS1tHSNxmhJCLBYPHFnfP113/V4/F6efHXMF1dBrOc+GrJYxMAIAABCR3x
         fwevIrF6OzTpf4FKtoLf9vQLZ2kjNgd5fz14Pw3tXG4XFDlTa9P4EcntTWAMiL7qUtZX
         tHnn4WOqBnrtAHFRI64w1Zlkjzj5q8HUake2m/RvrBuhQuSp607TartXi88u9l2KHYpD
         zF7w==
X-Forwarded-Encrypted: i=1; AJvYcCV8ilJTXW1yroSmrPQuscThftVHp+5JyBAt49fbmDPcegi41jp60yTfJUTTlnFg6HUp2rUoICA1EQ==@kvack.org
X-Gm-Message-State: AOJu0YxaN5cWqYLFcG3+yxpVAODu2wby3JJtOeQi9byNyiXS/Lme1eU8
	JclOEPw5s9fGfhQsFe9MeKnA6LI31WhySuSQgsHSpeJS3/anbR4orR7uBzhdJ/1wFjY=
X-Gm-Gg: AY/fxX6sUDu0IF9KNHa/1myVccCJ/NqqH/XrBO13wTiLIDAjREhWghMdhxp4QcRkweW
	dBDSnMmU+8fqKHn8AIK7V7hSRJVMfTFIBS48TcniWAAzURTkr3Lf0LVskACuCd+PRrxXE61/d25
	Bdfl3nPxdEUhYISjIpv8zWEpmR8q5JQU7YQQKhZzEizzn9yJFObV+SUEGEZogj6a17TIwhyV9Ts
	LZjpl/e1r0z5XNoHqWWds8MDNYGn7M4SXOvga3mvjXf215o179evouSBgBbrF9HHxvzA9ZTFWE1
	Snz1SnSe2Bajf84b5g3sUq9HH6dIbP7oZN0HBTssCdSTilSp7x88DanQgWGDT1kN55mjVvKtMhg
	YyjnMMxZGmq/t8riRU5b87vjlp0ZyrE2wUQctqtiFpRkjfZA88FihVbITDry+hDdr8Btm1ZHCXj
	y6V+utxYXQEhbSamWnoQ==
X-Google-Smtp-Source: AGHT+IEhKkW8HOYrig9DF3rTYl2qVie0SQ/p46EYCR9oSO7QhIdVsTeyvxAUdOoRH2Di4x3rN4ymmg==
X-Received: by 2002:a17:907:9627:b0:b82:f808:3eb9 with SMTP id a640c23a62f3a-b8444c8f087mr341978766b.9.1767807092472;
        Wed, 07 Jan 2026 09:31:32 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.17])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2338cbsm557322566b.14.2026.01.07.09.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 09:31:32 -0800 (PST)
Message-ID: <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
Date: Wed, 7 Jan 2026 19:31:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 529E4A0002
X-Stat-Signature: dguj5ckghki4e8z71wi637hctnatfpdf
X-Rspam-User: 
X-HE-Tag: 1767807094-972110
X-HE-Meta: U2FsdGVkX1/92QiDatseTm91X/NkP5199cMlYMJPRrk+d8hsFQhkNjlQDuqH6cC0FYvKnSd6vo5F21JIW0l5KpALvaq/CJSZaSjqofo/VtEqvjmdagevo1wYkqrfmJe39Gsu19f8KH7TlHLLLynRFLGp2RkZk6C7dra5IeX7Jdlue/+Juq7uknIwhZovlstyZOzc1F0Mla/gCULJubqMakHCtl0mC+lgfOg4DxxDazAsG830uSUonrKBYlG4DeWNK/CuHJlvqTyqMAeMK86d0x7Z8ejTPVNoX1yPnZvq2lLeYgre4YZcibDJz70ZAy3u7cq+Bu0h8bSmkxItl/MwRkOaph3/4J9LI7GdV+lTyNah91KZDrTiGP9j1B8E97ULfx7KGn8vcHl7Gbk7Gioo8vNRmQbP+T0dz16hmgwHNK7fXtbtrJiPt3vPRFAVfCAzET+UF0r93+VgqMzYk8MoP5H+eSqtuaDqMV+9sy6igQMVDmCpeANIjYa6NQaXu2FnGfHOp0/9GvQk+ARe6S0FnD/1uzdMiodD8XhTq3EcnI0kt3qQG95A/Kik2QxAx1oUB0ZvjqmH2fzN/Pv5aw8H7bpxM3YUHYzhxLMr0yXva4nphXzSqgGE5KQmKdbz/fVZFFNNQN9d4HVTOWZVMeaY7u3WOmGuO3RQZVwu/Uc9R3o6lYMO49BiOfGmabJGX98lAtCtwJ6HV/jI8P4ZLCt+WckqI1jq2GGsz7S6EY+C0SxK7ARu0zsHYCX5o1pYXygRS4BIl7HhNavW8o8x6pYf35IgoVlF7g96r7zDGlNogDEaaV0SlL+ORtE3+lwUPd8UxEX9YSjKjblS/oOi3Tw9F/DYcqd0Qi3/kapSlhMNuJIrqYaRe33xIravCuyEQYsegX5E26v+IXyNkggKw+RYYC2L+XisGHiXX1Ti5+pu14dOzot4DNCbnFiZMLIv0E+++qUOH1jb0nxxVUjOmKr
 VRv6Lr9e
 jzosI8bMUryw29jRLBbxI5ALTK6PizLEKD8lIuIdTny8HG4uc1zyCU+n6a06uFJE3fMOnw8yRUWdiUBqRLaU8ZlcOW6aa2bQOXK0gW5D3uDD2Qcw9D6tDQFJ6JmZZ3QTy2TsiXmI7nueScgFqTq5yztNhXO8qHBcaeoVxPWgFwTT+TmeNW21y0Tl7kl6wHzAUuzGbw2hCiHwHLla2xc1PYhczyFelKJvCEs00Ru8RQGGiPWjERYSV56ubytOL7OgF2V6HJgmU7zi1HKE3vz9wepjQ9ljQbEZV9qMSDe6FHX9B8RKkJ2uekHICqYi1d1fygliAwnG0XdK7hglyHB4Sof89D6+Xxmpq9Xl1REC9rEaPye1lQSHtO2z1kPUZT1xE5kx8ByBKgjDhhns/H5Bi7fx+Tm6c+YtsZ1lW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 12/30/25 09:24, Kefeng Wang wrote:
> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> which avoid atomic operation about page refcount, and then convert to
> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> the alloc_gigantic_folio().

I'm seeing the following issues on the Renesas RZ/G3S SoC when doing 
suspend to idle:

[  129.539064] Freezing user space processes
[  129.545037] Freezing user space processes completed (elapsed 0.005 
seconds)
[  129.552078] OOM killer disabled.
[  129.555335] Freezing remaining freezable tasks
[  129.561405] Freezing remaining freezable tasks completed (elapsed 
0.001 seconds)
[  129.636729] Unable to handle kernel paging request at virtual address 
dead000000000108
[  129.644674] Mem abort info:
[  129.647456]   ESR = 0x0000000096000044
[  129.651190]   EC = 0x25: DABT (current EL), IL = 32 bits
[  129.656482]   SET = 0, FnV = 0
[  129.659523]   EA = 0, S1PTW = 0
[  129.662650]   FSC = 0x04: level 0 translation fault
[  129.667507] Data abort info:
[  129.670374]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[  129.675837]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[  129.680867]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  129.686158] [dead000000000108] address between user and kernel 
address ranges
[  129.693267] Internal error: Oops: 0000000096000044 [#1]  SMP
[  129.698905] Modules linked in: nvme nvme_core snd_soc_simple_card 
snd_soc_simple_card_utils snd_soc_rz_ssi snd_soc_da7213 renesas_usbhs 
snd_soc_core snd_compress snd_pcm_dmaengine snd_pcm snd_timer snd 
soundcore rzg3s_thermal clk_vbattb rzg2l_adc rtc_renesas_rtca3 
industrialio_adc sha256 cfg80211 bluetooth ecdh_generic ecc rfkill fuse 
drm backlight ipv6
[  129.730189] CPU: 0 UID: 0 PID: 282 Comm: python3 Not tainted 
6.19.0-rc4-next-20260107-00002-g608ca48d0994 #1 PREEMPT
[  129.740765] Hardware name: Renesas SMARC EVK version 2 based on 
r9a08g045s33 (DT)
[  129.748223] pstate: a04000c5 (NzCv daIF +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[  129.755160] pc : free_pcppages_bulk+0x12c/0x204
[  129.759701] lr : free_pcppages_bulk+0x168/0x204
[  129.764219] sp : ffff80008392b7e0
[  129.767520] x29: ffff80008392b7e0 x28: ffff00003cff96b0 x27: 
ffff00003fe25700
[  129.774638] x26: ffff800081e66bd8 x25: 0000000000000001 x24: 
0000000000000025
[  129.781755] x23: ffff00003cff9680 x22: ffff00003cff9690 x21: 
dead000000000100
[  129.788872] x20: 0000000000000001 x19: 0000000000000000 x18: 
0000000000000020
[  129.795989] x17: ffff00000f3d0a00 x16: 0000000000000006 x15: 
000000e7ebec93d2
[  129.803106] x14: 0000000000000005 x13: dead000000000100 x12: 
0000000000000038
[  129.810223] x11: 0000000000000000 x10: 0000000000000001 x9 : 
0000000000000000
[  129.817339] x8 : 0000000000000000 x7 : ffff00003fe258a8 x6 : 
dead000000000122
[  129.824456] x5 : dead000000000122 x4 : ffff00003fe14628 x3 : 
fffffdffc0f799c8
[  129.831573] x2 : 0401010101010101 x1 : 000000000007de67 x0 : 
fffffdffc0f799c0
[  129.838691] Call trace:
[  129.841129]  free_pcppages_bulk+0x12c/0x204 (P)
[  129.845653]  free_frozen_page_commit.constprop.0+0x27c/0x478
[  129.851300]  __free_frozen_pages+0x1a0/0x63c
[  129.855562]  free_contig_frozen_range+0xd0/0x118
[  129.860165]  cma_release+0x7c/0xd8
[  129.863568]  dma_free_contiguous+0x2c/0x74
[  129.867657]  dma_direct_free+0xd8/0x1b0
[  129.871482]  dma_free_attrs+0x84/0xf8
[  129.875140]  ravb_ring_free+0x5c/0x1b4
[  129.878888]  ravb_close+0x12c/0x1d4
[  129.882368]  ravb_suspend+0x60/0x16c
[  129.885935]  device_suspend+0x148/0x3f4
[  129.889766]  dpm_suspend+0x1b0/0x2ac
[  129.893332]  dpm_suspend_start+0x54/0x70
[  129.897245]  suspend_devices_and_enter+0x124/0x4b8
[  129.902026]  pm_suspend+0x1a4/0x1f0
[  129.905506]  state_store+0x8c/0x110
[  129.908985]  kobj_attr_store+0x18/0x2c
[  129.912727]  sysfs_kf_write+0x7c/0x94
[  129.916384]  kernfs_fop_write_iter+0x128/0x1b8
[  129.920815]  vfs_write+0x2ac/0x350
[  129.924210]  ksys_write+0x68/0xfc
[  129.927517]  __arm64_sys_write+0x1c/0x28
[  129.931431]  invoke_syscall+0x48/0x10c
[  129.935177]  el0_svc_common.constprop.0+0xc0/0xe0
[  129.939871]  do_el0_svc+0x1c/0x28
[  129.943180]  el0_svc+0x34/0x10c
[  129.946319]  el0t_64_sync_handler+0xa0/0xe4
[  129.950492]  el0t_64_sync+0x198/0x19c

Using ./scripts/decode_stacktrace.sh on this leads to the following output:

./scripts/decode_stacktrace.sh build-arm64/vmlinux < out
[  490.453272] Call trace:
[  490.455711]  free_pcppages_bulk (include/linux/list.h:203 
include/linux/list.h:226 include/linux/list.h:237 mm/page_alloc.c:1525) (P)
[  490.460234]  free_frozen_page_commit.constprop.0 
(include/linux/spinlock.h:392 mm/page_alloc.c:2919)
[  490.465881]  __free_frozen_pages (mm/page_alloc.c:3003)
[  490.470143]  free_contig_frozen_range (mm/page_alloc.c:6977 
mm/page_alloc.c:7379)
[  490.474747]  cma_release (mm/cma.c:996 mm/cma.c:1025)
[  490.478149]  dma_free_contiguous (kernel/dma/contiguous.c:430)
[  490.482240]  dma_direct_free (kernel/dma/direct.c:351)
[  490.486064]  dma_free_attrs (kernel/dma/mapping.c:688)
[  490.489723]  ravb_ring_free 
(drivers/net/ethernet/renesas/ravb_main.c:249 
drivers/net/ethernet/renesas/ravb_main.c:260)
[  490.493469]  ravb_close (drivers/net/ethernet/renesas/ravb_main.c:2406)
[  490.496950]  ravb_suspend (drivers/net/ethernet/renesas/ravb_main.c:3225)
[  490.500516]  device_suspend (drivers/base/power/main.c:504 
drivers/base/power/main.c:1965)
[  490.504347]  dpm_suspend (drivers/base/power/main.c:2049)
[  490.507916]  dpm_suspend_start (drivers/base/power/main.c:2282)
[  490.511829]  suspend_devices_and_enter (kernel/power/suspend.c:523)
[  490.516609]  pm_suspend (kernel/power/suspend.c:621 
kernel/power/suspend.c:644)
[  490.520088]  state_store (kernel/power/main.c:819)
[  490.523568]  kobj_attr_store (lib/kobject.c:842)
[  490.527310]  sysfs_kf_write (fs/sysfs/file.c:143)
[  490.530967]  kernfs_fop_write_iter (fs/kernfs/file.c:352)
[  490.535398]  vfs_write (fs/read_write.c:593 fs/read_write.c:686)
[  490.538793]  ksys_write (fs/read_write.c:738)
[  490.542101]  __arm64_sys_write (fs/read_write.c:746)
[  490.546014]  invoke_syscall (arch/arm64/include/asm/current.h:19 
arch/arm64/kernel/syscall.c:54)
[  490.549762]  el0_svc_common.constprop.0 (arch/arm64/kernel/syscall.c:70)
[  490.554454]  do_el0_svc (arch/arm64/kernel/syscall.c:152)
[  490.557763]  el0_svc (arch/arm64/include/asm/irqflags.h:55 
arch/arm64/include/asm/irqflags.h:76 arch/arm64/kernel/entry-common.c:80 
arch/arm64/kernel/entry-common.c:725)
[  490.560901]  el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:744)
[  490.565074]  el0t_64_sync (arch/arm64/kernel/entry.S:596)

Reverting this series leads to no more failures. Should things be 
handled differently now in the drivers? Do you consider there is 
something buggy in the ravb driver?

Thank you,
Claudiu

