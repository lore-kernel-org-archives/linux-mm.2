Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DB9CCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF656B0088; Fri, 16 Oct 2026 15:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1076B008A; Fri, 16 Oct 2026 15:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E226B008C; Fri, 16 Oct 2026 15:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17A956B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:01:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CF2E40609
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:01:31 +0000 (UTC)
X-FDA: 85329407982.22.610F477
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2DC2B180015
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:01:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOt892dB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of olinesn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=olinesn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792177289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JjOTQkDWeoigokXojRyORks8HjSsuNnZ/Gan75r6U7c=;
	b=bCoIQtS68uxkqPXz5qLUE5G4W0V+RKMnBYaRfSbarLN1w0j5g7Jyy/yPeHSjKinln76hMI
	Ci5q7Myo3zTXOC0wqp0jWH6r9+doWTnpxHAZvLcuu9PCqs8OwLQztwZP1OdobTfjW/CRnT
	UU6jIwHhyy7RXhvaprA57tM8RNhEoRc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792177289;
	b=5YxrRePQbci4cI/f96WButFHjKuBSWBxX+b04IFoNGIKc7Rq0zgyUpcaC/9SZfwLLjDDCy
	c/Q/dK+H/V0nLsLjgKAxpHaMTQWb/uHrdCzkP/TBorrz5xZTmN+JY3J7yXHh5P46FIkaRm
	CGcTh59ubugBCFiApfA92N9/hIVWwKU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOt892dB;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of olinesn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=olinesn@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e8246b13cbso1304845ad.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792177288; cv=none;
        d=google.com; s=arc-20260327;
        b=rwZJNZaf/ovoEi+4WztfOsdQO+QBcMcvC76Ck/KPWvyqj28BV5w9+LMMXSAvH0abWp
         5bS/8QQ+IG+1CFkY82TEofsUGhVrb2heTzWdSjMjov4Z3gMAWSkIINultFzwJKJom/Sn
         REh+ah7PAHWK7bpPLYwcLFQbQoqqw0AE9+AsM2lxZMiE77DptmPIPArJFRCcmrmRqbQs
         6zit2c9vq0G+smvYiyvdEtbZJzZ/e+uy/eFu+dRX/3ITwivba9OZiFCKkKxS8nTLXdev
         EoLrF1+dH/tiUWn/qauIi+29VIcyp7Ej+JVXp5WPyyf7hbxTdDwQtcxD/M2+YB4C20FT
         Pbcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JjOTQkDWeoigokXojRyORks8HjSsuNnZ/Gan75r6U7c=;
        fh=DQvMczd7jjsQgm+rOwffdjzUyoSG4Sw2R6kSW4vByi4=;
        b=ZjrVpCXVq9b/zbZhgazi4q9dWUxd8wq4Zx9YYI71+Z19OrBl/IjQ7WxmAdmycheRfI
         1wECkBLksZRx71YuRgGrDkqIQrgJ1GTmQSzS3VTOeQHSYIzOBBJaAWCuJwrnUHQlyTv9
         wVMk5faOwXqnkOikN72EA3O5fUgb21vIcfCCgrCBzvuFhVfiihU01WjiwvfgdMLsgZX1
         wNHtSlr+SlGKePK4ew7qUobnlj+4cRp+tNjFSLUD1EQgoyEPffuiFWSRqLIN34uNSFoT
         l+yXPmmAhDWBFhvBV5IX0I/tI9Ib7TKXYFI3UmIlBTe9xr/kuHU01jZ3K8tkY9BcvQqc
         pRgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792177288; x=1792782088; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JjOTQkDWeoigokXojRyORks8HjSsuNnZ/Gan75r6U7c=;
        b=lOt892dB85VGL1h50NOQImG6QAY41fnEOPoupO3NMeZWfhO3msq6liUKteVqaBRnwK
         yS05VM2c7FXasxqfAW5Pn3CzJL6ZbwB3BOAZKmTEBnSSEBCQ7PbkLg9XFmw0gfPvTPHi
         M/pyQlLNU/+fW2L954dsw6QilC2I5qEwjU8ATQprXiPIlYR23PMmkmnW0SciF6GeRzOn
         hB7B1o4hctTtIdD0brp6yDf4e4PYJ/v6CeE5RJnGtWrTzy1OmFcKErnJhIUk/x4v6VhD
         RdOy+KfNrqxM6AjSSkzvb16k1TqvhQoYVNp+iznlFRVMOfygv6RVmd70+EJdyiWiZSeA
         XXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792177288; x=1792782088;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JjOTQkDWeoigokXojRyORks8HjSsuNnZ/Gan75r6U7c=;
        b=PfT0PJDKrD0FXXnj1J8dfWdDCaVCHINEYTCWTbxqfKRXcFAzFz3EFInKo3h6h86bhC
         jnnx+/M2FlTH2wzrMNJjKvYoHW6qEiWRrF9x9WxvmlFkuzqNqUylhdzjvN97JiBQsv+y
         WLjwes02lA1qs0Jm5WJNNgZwTbLqtE71MNuzU16IzjZ4lgHjCAMFYh8nmcd6pWqsICwb
         81PAcd4x4B/HYnh2zDFOv0RON19Kkor8lrhJml3DqDr0662Rcx7lJurBN6evHKh2i0XP
         8SKYaeZQWKtN6xuSrW9wvgtJzl3c4JitWJ27AfGPU7B6/X5Lv0N0bB7FO7hQyH3HJi+2
         Gflw==
X-Forwarded-Encrypted: i=1; AKwUvBwcWvV4faN9cnpoUGBK5+kiG14YFTk1p79QG0UgBeRknJl2uVSrqgmuGlJEa944j9tUagH1mYGT8g==@kvack.org
X-Gm-Message-State: AFq9FYKYMAUVTW+qFNCgwKiUxLq7jYQ93njatlYM4vJXp7RDOmoMTMUY
	2XEZKHwTtkGMpuh3/A2sMj+8bXrH7h2w3ZoSRZcrL8di57KGzdegVZDecKDPUNV2X/trYxJ1YRt
	NzJldHHXKqhe5DTYdBWvQHnxKJkb6nz8=
X-Gm-Gg: AYBFou3kh2IirZh1QlimPTOk7C6Ij0yjzhSiyqu7fbNLCBMGYpv8H2Fm5Kg/x/VPHyp
	OdZyXgvJZV1JaJJSh5C3R0f8uNCrX9cAhTyjfsERZI2a7QnNK15rDXqp01YSGk1Sn0RglCq6L/H
	rhvyuAMsMXa4MFZZ5D43lDGLHkh6gUjAI0NEEaH92GfEAsXoDYVrRO/ptgfduNGtJtHyerjJQzN
	npaEOGDzw3/jCJgxZaRlM8bYiQ6FiiLqjSKNsEiiTYjW5jIwt2v27A+2xKAQOZaK72pPVw9z0SA
	FoAN2JuBCIxPa6dImSvh398ImZdj2zH0hssf7WLR2CtQuJL74xwaxQdkqQk5Ccae7nDgnV2BCPE
	D2TunfAB1sFadVvx0Rj4Oa5fs/gkI8gWxmT2lVxQm73pGH5bEL6/E9c3TB0b6f1ionNpicYQz6B
	pYV5eHrJUW2cY=
X-Received: by 2002:a17:902:dac8:b0:2e9:5829:9b41 with SMTP id
 d9443c01a7336-2e9a6c02ce4mr9004735ad.37.1792177287656; Fri, 16 Oct 2026
 12:01:27 -0700 (PDT)
MIME-Version: 1.0
From: Stefan <olinesn@gmail.com>
Date: Fri, 16 Oct 2026 15:01:16 -0400
X-Gm-Features: AclHuK-4cFFWJgvZxXTLe5Uv4KNC8ytWLiIhHNFtyeIWhaDuOCX_uc3UI0RRIAw
Message-ID: <CAPykwV_fQq9spwEQBRRPMOznhHW+TYuABux2=_BGCeY1bivqOw@mail.gmail.com>
Subject: [BUG] x86/kaslr: vmemmap can end 1 GiB inside the CPU entry area
 (amdgpu oops in memmap_init_zone_device)
To: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kees Cook <kees@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, Dan Williams <djbw@kernel.org>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Felix Kuehling <felix.kuehling@amd.com>, linux-mm@kvack.org, amd-gfx@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DC2B180015
X-Stat-Signature: ehsxm1efwzur8udwyrqbioruygyca5ft
X-Rspam-User: 
X-HE-Tag: 1792177289-468654
X-HE-Meta: U2FsdGVkX19geoTP5TMPbh0uaoPpNpMc+7Llk2/aZYqz0DjPquUm75SDlIfQnP5ehwU4e36WaDDYG+mNBm4CD3UjM9OSEmEzwaFSjTSAVZXXjr/9MrzM9++rSTWGiqaXgQHKW1XX0UE3+NPkKJvK+fMxviaUjLnJTsjh+s47Jc8JcaJSqwFPPJ6XtA3N6v7F1LlTtSM/T1AvS61HpXXzSdNjE1k0ViqCWGJ10pvuZQqqpIJVrMBUV4uRcspr2746bOsNkD1NKv+W3/jMQRAF5TXhlqgZ3LRER5Ppl1XZ9RfxEh2kV3zgi1NB1rxvmiVvtClQYJA575to7h+dFs0Ip8oSXAleyT3CokVdDQNO2nzDfRfiVeg95gpAKGPZPG5gPqs/6/F5PefBYVSMv7hKo/RqJlPTFQyl3fCoP0QH+O90KtPsWpz77JdryhKq42WBTn1NXTBvV+BzSMplQbi3Dw07PMDoB/xLcZxrZRq91101mJ3Mu47aaBQikVzoVUWz5VDdMT/FJF2Vi9iMcQM18CO8QDIeAaWfpJepgkUbDKT3r8fUIdNvNJcjiRbVUcOVXwGnF9Os6wiHB6L+xoIyG7RyjE3YETK2dN1jzJRHNvL3L1STy6rFIJ8IT644XKHuVxp8SeKIOWj7Omj7vohsynz7vrXgCJ7LB8otdv/Z7ISX/e7o5hIFWIT3N7vkimd0GjcEzQaXIf6Bu/l7HIVabURpJc0ERTgWZlk2n0QwRyZTpdCjX0cqCcL6UUX1rOnQzEAffdQKYIAU08l31m7vg0Yi8kaPvyMhcBAat5555HfDEJ9sQFD+IKjpQeBVsnwTPyH0slEfzdzB4D2klTt0JCMhdaU9+gfn0mgIH46/EAOiEgDFhY74+X1rK6bvUYMpm86/Ar483P9eMBBJoY4A1iXyLH2WoMJJSi07D6R4JtYsH8M/IqnFGpvXBYD/WnY2XEfsqTfY6ck8J0wy+Tm
 DLilM4kq
 Yd362kg2/tL+fyCnVD9J0vp7uVMHwmLjvJc/xDK1Ltw/zmNcnUnGi4KYbWiJv0qnBfZiozkWSxTltpYBhfTiOZLptCtbNWJ5rzbvIHbiPUbmy8pmcu6liynHyzx1gNwObG9RqxjzQaHAU05zQHTBpVZ7ZV6b5ElqYxAyF9YQpNjekXE9T3SI05g9xPN9NyFh6llYzhkz5cUPRWywo4S1m577qy/8i9l23R89ddflMzXqCGDk/Ds8CkxJUGMqdPkqdkD8bTUG1kDifnvMvEMOwZJb2FmvPdQpJT80geSLEzRg9Px6Nd2c+mMnYEiIYD/jRacPfGLjp8ToH/RUwDK/1pY2pdU7hcah2/5ie67ikNA+4ZzR0dBT0gGVcl71Crs8MPtcBhaSg223nw4Jncbdlsh8Q5DZ5/rsih1QTnhyD8bzRafZmJzDMr8QFp5aHxyDLqzAk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(draft below was generated from Claude)


Hi,

On a 4-level x86-64 machine, one boot oopsed while amdgpu (amdkfd) was
setting up its DEVICE_PRIVATE memory: memmap_init_zone_device() wrote a
struct page at 0xfffffe0000000000, which is CPU_ENTRY_AREA_BASE (the
read-only IDT alias). The registers show that KASLR had placed vmemmap
so that it ended 1 GiB past vaddr_end.

I think there are two causes. First, kernel_randomize_memory() never
takes the PUD_SIZE gaps it puts between regions out of remain_entropy.
Second, since 7ffb791423c7 and 269031b15c14 the top of vmemmap is
actually used. Details, a model of the loop and a one-line fix follow.

System
------
GMKtec EVO-X2 (BIOS 1.09), AMD Ryzen AI Max+ 395 (Strix Halo APU),
48-bit physical and virtual addresses, so 4-level paging and
MAX_PHYSMEM_BITS = 46. About 64 GiB of system RAM plus a 64 GiB BIOS VRAM
carve-out. Ubuntu 24.04, kernel 6.17.0-1033-oem (based on 6.17.13),
with CONFIG_RANDOMIZE_MEMORY=y, CONFIG_ZONE_DEVICE=y,
CONFIG_PCI_P2PDMA=y, CONFIG_DEVICE_PRIVATE=y and CONFIG_HSA_AMD_SVM=y.
The code involved is the same in current mainline (checked at
70dd4ee72eb2).

It happened once in about 30 boots on 6.17 kernels. It cannot be
reproduced on demand, because it depends on the KASLR draw.

Oops
----
BUG: unable to handle page fault for address: fffffe0000000034
#PF: supervisor write access in kernel mode
#PF: error_code(0x0003) - permissions violation
PGD 107e07c067 P4D 107e07c067 PUD 107e059067 PMD 10031f067 PTE 8000000b4efe4121
Oops: Oops: 0003 [#1] SMP NOPTI
CPU: 6 UID: 0 PID: 561 Comm: systemd-modules Not tainted
6.17.0-1033-oem #33-Ubuntu PREEMPT(voluntary)
Hardware name: GMKtec NucBox_EVO-X2/GMKtec, BIOS EVO-X2 1.09 09/13/2025
RIP: 0010:__init_zone_device_page.constprop.0+0x27/0x110
Code: 90 90 90 0f 1f 44 00 00 48 b8 00 00 00 c0 ff ff 27 00 55 48 c1
e2 36 48 09 c2 48 8d 47 08 48 89 e5 41 54 49 89 cc 53 48 89 fb <c7> 47
34 01 00 00 00 48 c7 47 38 00 00 00 00 c7 47 30 ff ff ff ff
RSP: 0018:ffffcd4cc2f8b570 EFLAGS: 00010206
RAX: fffffe0000000008 RBX: fffffe0000000000 RCX: ffff8d1d08ad8a10
RDX: 0027ffffc0000000 RSI: 00000003ff000000 RDI: fffffe0000000000
RBP: ffffcd4cc2f8b580 R08: 0000000000000000 R09: 000000ffc0000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8d1d08ad8a10
R13: 0000000000000000 R14: ffff8d1d08ad8a10 R15: 0000000400000000
FS:  00007bb2617a1440(0000) GS:ffff8d2ca5f64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffe0000000034 CR3: 000000010604c000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 memmap_init_zone_device+0xcd/0x290
 pagemap_range+0x2a6/0x400
 memremap_pages+0x103/0x280
 ? get_free_mem_region+0x2e6/0x370
 devm_memremap_pages+0x22/0x70
 kgd2kfd_init_zone_device+0x11c/0x220 [amdgpu]
 amdgpu_device_ip_init+0x65f/0xac0 [amdgpu]
 amdgpu_device_init+0xd12/0x1250 [amdgpu]
 amdgpu_driver_load_kms+0x14/0xd0 [amdgpu]
 amdgpu_pci_probe+0x20b/0x740 [amdgpu]
 local_pci_probe+0x44/0xb0
 pci_call_probe+0x5e/0x190
 pci_device_probe+0xae/0x110
 really_probe+0xee/0x3c0
 __driver_probe_device+0x8c/0x180
 driver_probe_device+0x24/0xd0
 __driver_attach+0x10b/0x210
 ? __pfx___driver_attach+0x10/0x10
 bus_for_each_dev+0x89/0xf0
 driver_attach+0x1e/0x30
 bus_add_driver+0x14e/0x290
 driver_register+0x5e/0x130
 ? __pfx_amdgpu_init+0x10/0x10 [amdgpu]
 __pci_register_driver+0x5e/0x70
 amdgpu_init+0x69/0xff0 [amdgpu]
 do_one_initcall+0x5a/0x340
 do_init_module+0x97/0x2c0
 load_module+0x99c/0xac0
 init_module_from_file+0x95/0x100
 idempotent_init_module+0x10f/0x300
 __x64_sys_finit_module+0x73/0xe0
 x64_sys_call+0x1784/0x2680
 do_syscall_64+0x80/0x8b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
[ '?' frames from the syscall path and the user-mode registers trimmed;
  full log on request ]

Analysis
--------
__init_zone_device_page() faulted on its first store to the struct page
(RDI) for the pfn in RSI:

  pfn          = RSI = 0x3ff000000, so phys 0x3ff000000000
  page         = RDI = 0xfffffe0000000000 = CPU_ENTRY_AREA_BASE = vaddr_end
  vmemmap_base = RDI - RSI * 64 = 0xfffffd0040000000
  vmemmap end  = vmemmap_base + 1 TiB = 0xfffffe0040000000
               = vaddr_end + 1 GiB

amdkfd's region is [64 TiB - 64 GiB, 64 TiB). get_free_mem_region()
with GFR_DESCENDING starts at min(iomem_resource.end,
DIRECT_MAP_PHYSMEM_END) = 2^46 - 1 and works down. So these 64 GiB of
pfns have their struct pages in exactly the last GiB of the 1 TiB
vmemmap.

The PTE in the oops (...121: present, global, read-only) belongs to the
CPU entry area. vmemmap_pte_populate() only allocates when the PTE is
none, so it reused that mapping, and the struct page writes went to
CPU_ENTRY_AREA_RO_IDT.

kernel_randomize_memory():

remain_entropy = vaddr_end - vaddr_start;
for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
remain_entropy -= get_padding(&kaslr_regions[i]);
...
for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++) {
entropy = remain_entropy / (ARRAY_SIZE(kaslr_regions) - i);
...
entropy = (rand % (entropy + 1)) & PUD_MASK;
vaddr += entropy;
*kaslr_regions[i].base = vaddr;
vaddr += get_padding(&kaslr_regions[i]);
...
/* Add a minimum padding based on randomization alignment. */
vaddr = round_up(vaddr + 1, PUD_SIZE);
remain_entropy -= entropy;
}

The three draws can add up to all of remain_entropy. But the loop also
puts a 1 GiB gap after the direct map and another after vmalloc, and
remain_entropy never paid for them. So vmemmap can end up to 2 GiB past
vaddr_end.

In practice the overrun is exactly 1 GiB. The top bucket of the final
draw (e2 == remain_entropy) is a single value of rand, so the reachable
case is e2 = remain_entropy - 1 GiB. That case always gives
vmemmap_base = vaddr_end - 1 TiB + 1 GiB = 0xfffffd0040000000, whatever
the first two draws were, and that is the value in the oops.

The gap accounting goes back to 0483e1fa6e09 ("x86/mm: Implement ASLR
for kernel memory regions"). It did no harm while the direct map was
sized to RAM + CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING, because the
last GiB of vmemmap then describes physical addresses far above
anything that is ever added. Two commits changed that:
7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems",
for PCI_P2PDMA=y) and 269031b15c14 ("x86/kaslr: Recognize all
ZONE_DEVICE users as physaddr consumers"). Both keep the direct map at
the full 64 TiB, and DEVICE_PRIVATE ranges are taken from its top down.
So now the last GiB of vmemmap is the first part to be used.

As far as I can tell, a system can hit this when all of these hold:
4-level paging, ZONE_DEVICE=y (PCI_P2PDMA=y on 6.15 to 6.18),
x86_phys_bits >= 46, and a devm_request_free_mem_region() or
request_free_mem_region() user (amdkfd SVM, nouveau dmem, xe SVM,
test_hmm).

I don't expect it with 5-level paging. The randomization range is far
larger there, and the device range sits at the top of x86_phys_bits
rather than at the top of vmemmap.

A region smaller than 64 GiB lands at
[vaddr_end + 1 GiB - size / 64, vaddr_end + 1 GiB) instead. Whether
that faults presumably depends on where the randomized per-CPU entry
areas are, so it could also go unnoticed.

Model
-----
I ran the loop above in userspace with 4-level paging, a 64 TiB direct
map, 32 TiB of vmalloc and a 1 TiB vmemmap. It uses exact enumeration
of the first two draws, plus a Monte Carlo over 2e8 simulated boots
with a 64-bit PRNG in place of prandom. The source is at the end of
this mail.

                    P(vmemmap end > vaddr_end)   worst-case end
  current code      8.03e-05 (1 in 12,450)       vaddr_end + 2 GiB
                    Monte Carlo: 16,004 of 2e8, every one with
                    vmemmap_base = 0xfffffd0040000000
  with the fix      0 (Monte Carlo: 0 of 2e8)    vaddr_end - 1 GiB

So hitting it once in about 30 boots was either bad luck (about 0.24%
under this model) or caused by something the model leaves out.

With the direct map trimmed to RAM + 10 TiB (how this machine behaved
before 6.15), the overrun also happens (1 in 44,634). Then it only
covers struct pages for addresses that are never added.

Suggested fix
-------------
Take one PUD_SIZE gap per region out of remain_entropy along with the
region sizes. This costs 3 GiB of the 20.5 TiB 4-level range, and it
also leaves a gap between vmemmap and the CPU entry area:

--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -131,10 +131,14 @@ void __init kernel_randomize_memory(void)
  sizeof(struct page);
  kaslr_regions[2].size_tb = DIV_ROUND_UP(vmemmap_size, 1UL << TB_SHIFT);

- /* Calculate entropy available between regions */
+ /*
+ * Calculate entropy available between regions. The loop below also
+ * leaves a PUD_SIZE gap after each region, so take those out too, or
+ * the last region can extend past vaddr_end.
+ */
  remain_entropy = vaddr_end - vaddr_start;
  for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
- remain_entropy -= get_padding(&kaslr_regions[i]);
+ remain_entropy -= get_padding(&kaslr_regions[i]) + PUD_SIZE;

  prandom_seed_state(&rand_state, kaslr_get_random_long("Memory"));

I can send this as a proper patch if this is the right direction. It
builds cleanly (make W=1 arch/x86/mm/kaslr.o, x86_64_defconfig, gcc
13.3, on 70dd4ee72eb2) but has not been boot-tested: since the bad
layout comes up about once in 12,000 boots, the model above is the only
check that it closes the overrun.

Aftermath (probably expected after an oops in module init)
----------------------------------------------------------
systemd-modules-load died inside finit_module() with IRQs disabled.
Three minutes later a udev worker oopsed in idempotent_init_module() on
a stale list entry that pointed into the dead task's stack (RDX
ffffcd4cc2f8bc30; the first oops's RSP was ffffcd4cc2f8b570). It exited
with IRQs disabled and preempt_count 1, and a later modprobe spun in
idempotent_init_module() -> _raw_spin_lock until the machine was reset
(soft lockup, 300+ s). I mention it only in case the stale entry is of
interest.

Workaround on this machine: nokaslr.

The analysis and the model were done with help from an LLM (Claude
Code). The fix is compile-tested only, and there is no reproducer
beyond the model, since the layout is random per boot.

Thanks,
Stefan

---- kaslr_overrun_sim.c ----
// SPDX-License-Identifier: GPL-2.0
/*
 * Userspace model of arch/x86/mm/kaslr.c:kernel_randomize_memory()
 * (torvalds/linux master, 2026-10-16), to show that the vmemmap region can
 * end past vaddr_end (CPU_ENTRY_AREA_BASE), and that subtracting one
 * PUD_SIZE guard per region from remain_entropy closes it.
 *
 * Build:  cc -O2 -Wall -o kaslr_overrun_sim kaslr_overrun_sim.c
 * Run:    ./kaslr_overrun_sim [monte_carlo_trials]
 *
 * Three checks per layout, for the current code ("before") and the patch
 * ("after"):
 *   1. worst case: every draw takes its maximum value;
 *   2. exact probability of an overrun, by enumerating the first two draws
 *      and summing the closed-form probability of the third (rand % (E+1) is
 *      treated as uniform on [0, E]; the 64-bit modulo bias is < 2^-19
 *      relative and is ignored);
 *   3. Monte Carlo through the loop below, with a 64-bit PRNG standing in
 *      for prandom_bytes_state(), recording every vmemmap_base that overruns.
 */
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#define TB_SHIFT 40
#define PAGE_SHIFT 12
#define PUD_SIZE (1ULL << 30)
#define PUD_MASK (~(PUD_SIZE - 1))
#define STRUCT_PAGE 64ULL
#define NREGIONS 3

/* 4-level paging (the EVO-X2 has 48 virtual address bits, so no LA57). */
#define PAGE_OFFSET_BASE_L4 0xffff888000000000ULL
#define CPU_ENTRY_AREA_BASE 0xfffffe0000000000ULL
#define MAX_PHYSMEM_BITS_L4 46
#define VMALLOC_SIZE_TB_L4 32ULL

static const uint64_t vaddr_start = PAGE_OFFSET_BASE_L4;
static const uint64_t vaddr_end = CPU_ENTRY_AREA_BASE;

struct layout {
const char *name;
uint64_t size_tb[NREGIONS]; /* direct map, vmalloc, vmemmap */
};

static uint64_t round_up(uint64_t x, uint64_t a) { return (x + a - 1)
& ~(a - 1); }

static uint64_t initial_entropy(const struct layout *l, int fixed)
{
uint64_t remain = vaddr_end - vaddr_start;

for (int i = 0; i < NREGIONS; i++)
remain -= l->size_tb[i] << TB_SHIFT;
if (fixed) /* the proposed patch: one guard per region */
remain -= NREGIONS * PUD_SIZE;
return remain;
}

/*
 * The loop from kernel_randomize_memory(), verbatim apart from the rand
 * source. Returns the end (exclusive) of the last region, vmemmap.
 */
static uint64_t randomize(const struct layout *l, int fixed,
  uint64_t (*next_rand)(void *), void *ctx,
  uint64_t base[NREGIONS])
{
uint64_t remain_entropy = initial_entropy(l, fixed);
uint64_t vaddr = vaddr_start, end = 0;

for (int i = 0; i < NREGIONS; i++) {
uint64_t entropy = remain_entropy / (NREGIONS - i);
/* NULL: take the largest value the draw allows */
uint64_t rand = next_rand ? next_rand(ctx) : entropy;

entropy = (rand % (entropy + 1)) & PUD_MASK;
vaddr += entropy;
base[i] = vaddr;

vaddr += l->size_tb[i] << TB_SHIFT;
end = vaddr;
vaddr = round_up(vaddr + 1, PUD_SIZE);
remain_entropy -= entropy;
}
return end;
}

/* splitmix64 */
static uint64_t rand_sm64(void *ctx)
{
uint64_t *s = ctx, z = (*s += 0x9e3779b97f4a7c15ULL);

z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
return z ^ (z >> 31);
}

/*
 * P(masked draw == k GiB) for rand % (E + 1) & PUD_MASK, rand uniform:
 * bucket k holds the byte values [k*G, min((k+1)*G, E+1)).
 */
static double bucket_p(uint64_t E, uint64_t k)
{
uint64_t lo = k * PUD_SIZE, hi = lo + PUD_SIZE;

if (hi > E + 1)
hi = E + 1;
return (double)(hi - lo) / ((double)E + 1.0);
}

/* Exact P(vmemmap end > vaddr_end), summed over the first two draws. */
static double exact_overrun_p(const struct layout *l, int fixed)
{
uint64_t R = initial_entropy(l, fixed);
uint64_t E0 = R / 3;
double p = 0;

for (uint64_t k0 = 0; k0 * PUD_SIZE <= E0; k0++) {
uint64_t e0 = k0 * PUD_SIZE;
uint64_t R1 = R - e0, E1 = R1 / 2;
double p0 = bucket_p(E0, k0), s = 0;

for (uint64_t k1 = 0; k1 * PUD_SIZE <= E1; k1++) {
uint64_t E2 = R1 - k1 * PUD_SIZE;
/*
* end = vaddr_start + sizes + e0 + e1 + e2 + 2 guards;
* end > vaddr_end  <=>  e2 + 2G > E2 + (R - R_used),
* where R_used is what the patch subtracted (0 or 3G).
*/
uint64_t slack = fixed ? NREGIONS * PUD_SIZE : 0;
double q = 0;

for (uint64_t k2 = (E2 / PUD_SIZE >= 2 ? E2 / PUD_SIZE - 2 : 0);
     k2 * PUD_SIZE <= E2; k2++)
if (k2 * PUD_SIZE + 2 * PUD_SIZE > E2 + slack)
q += bucket_p(E2, k2);
s += bucket_p(E1, k1) * q;
}
p += p0 * s;
}
return p;
}

static void run(const struct layout *l, long trials)
{
uint64_t base[NREGIONS];

printf("== %s: direct map %" PRIu64 " TiB, vmalloc %" PRIu64
       " TiB, vmemmap %" PRIu64 " TiB\n",
       l->name, l->size_tb[0], l->size_tb[1], l->size_tb[2]);
printf("   vaddr_start %#" PRIx64 "  vaddr_end %#" PRIx64 "\n",
       vaddr_start, vaddr_end);

for (int fixed = 0; fixed <= 1; fixed++) {
const char *tag = fixed ? "after " : "before";
uint64_t end = randomize(l, fixed, NULL, NULL, base);
int64_t over = (int64_t)(end - vaddr_end);
double p = exact_overrun_p(l, fixed);

printf("   %s: remain_entropy %" PRIu64 " GiB\n", tag,
       initial_entropy(l, fixed) / PUD_SIZE);
printf("   %s: worst case vmemmap [%#" PRIx64 ", %#" PRIx64
       "), end - vaddr_end = %+" PRId64 " GiB\n",
       tag, base[2], end, over / (int64_t)PUD_SIZE);
if (p > 0)
printf("   %s: exact P(vmemmap end > vaddr_end) = %.3g per"
       " boot (1 in %.0f)\n", tag, p, 1 / p);
else
printf("   %s: exact P(vmemmap end > vaddr_end) = 0\n", tag);

if (trials > 0) {
uint64_t seed = 0x5eed0000ULL + fixed, first_base = 0;
long hits = 0, other_base = 0;
int64_t max_over = INT64_MIN;

for (long t = 0; t < trials; t++) {
end = randomize(l, fixed, rand_sm64, &seed, base);
over = (int64_t)(end - vaddr_end);
if (over > max_over)
max_over = over;
if (over > 0) {
if (!hits++)
first_base = base[2];
else if (base[2] != first_base)
other_base++;
}
}
printf("   %s: Monte Carlo %ld boots: %ld overruns", tag,
       trials, hits);
if (hits)
printf(", vmemmap_base %#" PRIx64 " in %ld of them",
       first_base, hits - other_base);
printf("; largest end - vaddr_end %+.3f GiB\n",
       (double)max_over / PUD_SIZE);
}
}
printf("\n");
}

int main(int argc, char **argv)
{
long trials = argc > 1 ? atol(argv[1]) : 100000000L;
uint64_t full_tb = 1ULL << (MAX_PHYSMEM_BITS_L4 - TB_SHIFT);
uint64_t vmemmap_tb = ((full_tb << (TB_SHIFT - PAGE_SHIFT)) * STRUCT_PAGE
       + (1ULL << TB_SHIFT) - 1) >> TB_SHIFT;

/* EVO-X2 (max_pfn 0x107e0c0, ~66 GiB) with padding 10 TiB -> 11 TiB. */
uint64_t trimmed_tb = 1 + 10;
uint64_t trimmed_vmemmap_tb = ((trimmed_tb << (TB_SHIFT - PAGE_SHIFT)) *
       STRUCT_PAGE + (1ULL << TB_SHIFT) - 1) >> TB_SHIFT;

struct layout zone_device = {
"4-level, CONFIG_ZONE_DEVICE=y (master; PCI_P2PDMA=y in 6.15-6.18)",
{ full_tb, VMALLOC_SIZE_TB_L4, vmemmap_tb } };
struct layout trimmed = {
"4-level, direct map trimmed to RAM + padding (pre-6.15 / ZONE_DEVICE=n)",
{ trimmed_tb, VMALLOC_SIZE_TB_L4, trimmed_vmemmap_tb } };

run(&zone_device, trials);
run(&trimmed, trials);

/* What the oops registers say. */
uint64_t rdi = 0xfffffe0000000000ULL, rsi = 0x3ff000000ULL;
uint64_t vb = rdi - rsi * STRUCT_PAGE;

printf("== oops: RDI (struct page) %#" PRIx64 ", RSI (pfn) %#" PRIx64 "\n",
       rdi, rsi);
printf("   vmemmap_base = RDI - RSI*64 = %#" PRIx64 "; vmemmap end %#"
       PRIx64 " = vaddr_end + %" PRIu64 " GiB\n",
       vb, vb + (vmemmap_tb << TB_SHIFT),
       (vb + (vmemmap_tb << TB_SHIFT) - vaddr_end) / PUD_SIZE);
printf("   the 1 GiB overrun always yields vmemmap_base = vaddr_end - "
       "vmemmap size + 1 GiB = %#" PRIx64 "\n",
       vaddr_end - (vmemmap_tb << TB_SHIFT) + PUD_SIZE);
return 0;
}

