Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6907E606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=spicebrains-com.20260707.gappssmtp.com header.i=@spicebrains-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=azIbH2zJ
Received: by kanga.kvack.org (Postfix)
	id 78CD56B05B1; Mon,  9 Nov 2026 03:45:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764B26B05B2; Mon,  9 Nov 2026 03:45:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654D06B05B3; Mon,  9 Nov 2026 03:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7A36B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:45:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99F02C05AB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:45:54 +0000 (UTC)
X-FDA: 85414947828.28.27E379B
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9FDDE1A0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:45:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=spicebrains-com.20260707.gappssmtp.com header.s=20260707 header.b=azIbH2zJ;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794213952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C/umt9X7ORdASGrmB2+2iI7/93OEYSlXyO9e9iBJi7k=;
	b=Iksr+l+QL/uovtkO4+yhqbuNC2CCtEmURxHWgPmBlqIBWuCt/8yQsbO9jn2IQBqGRat+AM
	2UHuri73bMRIKWOfb6Mmbsy8La0l0MM2SI6Aj77CIcpaXUiDvZO/Lv7duzMbRUktQ4/W4u
	tGfztxjLhsuDjNriN2LZM3MSqFrk2V4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=spicebrains-com.20260707.gappssmtp.com header.s=20260707 header.b=azIbH2zJ;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=none (imf19.hostedemail.com: domain of master@spicebrains.com has no SPF policy when checking 209.85.160.47) smtp.mailfrom=master@spicebrains.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794213952;
	b=FRwRylw4cnVvxuIkFu/HycuRAcfo3/4h+v9jbfPn0ANK+oANOKj7rdNLhL1pV/Xf5nvOO+
	TbyGUw3klDyykDmK2RnM1vY2gKVuGJq4vintB0RYipP+Tg6uG/z5Z98gM1y5kfETxAFge/
	8hWOS+T9STF5qfC/xoGjfnKUFnjZxuc=
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4adae187d94so352486fac.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 00:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794213951; cv=none;
        d=google.com; s=arc-20260327;
        b=mS2E8wMZUbgXqI6pH100NiAqhuH/4FhRNaPMe/J6RF7vp7KR+W9XzLyQldlK/ORbBc
         Vqau9XjWk0abAM9g23Jas84xp5Vv882v3k+CE+4HzUHUTvigIiyGw6fqMOiDu3+oXzi4
         Q+t0u5uBbpMxX9dTbGc9ByyoVQpywIneZTcjAOSFBPEs3Fc7xPoZvJ2jozDA60m32bkV
         s7L00k7gzId2PP5FiyyEw8uEI9b9mJjBaDGIB5cMNlvllAYwKBfGT9hJOgoOxRkUq2kc
         /R3KSy5gFkZw9P/k1p/4nB8+xWq+vB/at33oyy9jI+kYFvil5xBreMbyRwvr8Aevzpqk
         rcew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=C/umt9X7ORdASGrmB2+2iI7/93OEYSlXyO9e9iBJi7k=;
        fh=5R0ekKaEQK+iyeDQoXGfzPMltuaNkPRR8d1SpQbXtWk=;
        b=ds2IVPrNByEnmBKtOBeKnG61yXoaA4QBXgVhA6dSYqM+I3qIYllUyygEje5d5P7dJh
         2ishxq+q9DBzH/qZw+WG/f7H5uc7ui6+tv4BK+MQCtvt6Bzqv64C5zeddl7eruksBUxh
         Mu9wO/Tw4hvr3dkHorprTp69QT7RAz/Ez9zSEc/w//JeyB1/kPUfzLlZfx2nCWxyiBh+
         tdnX30IMzUvirpkAhAsqbQoZ5M6OqXWe0Sx2heVKQ84K5SY6gXWMIqT5sNjN77P9IIyj
         +RNWBbi/9o5ymMx4w0jjtgvilrupGrS/ZkGDyiknA3RoYmn8Uxh7GpnILubgnQJO8g6K
         kGow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=spicebrains-com.20260707.gappssmtp.com; s=20260707; t=1794213951; x=1794818751; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/umt9X7ORdASGrmB2+2iI7/93OEYSlXyO9e9iBJi7k=;
        b=azIbH2zJN9wQ05WEmShxD2QeiP5ZSHnM+P+yOYY8LE+RVemGUuiojONsTzbgKgihJh
         bkxZ6/0xr+MM4TaCR39UUV9GlswAE1rgiAuMrivfVhhFEB+DKO3lMYHk1FCF78hiYNbg
         IPSs3RV72xuWjuM/JwgdTappkdbwCooEugD8bq/3ZiTHtQb3JdzIVv1Z7OxGhx6CmX5A
         DmKWb6Ej8qDSg7t8Vg14PxK8dDpP5CeUVov97Kn7U5AU7W7rYRdAgQt/9IRHdClSNSdJ
         tr1NWP1cg1TwgS9W8lcg6L6Ktv9LvpIAR4NGnjagb6/vVqy8lUv2KFhM0Z2PRMsRhTPG
         je7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794213951; x=1794818751;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=C/umt9X7ORdASGrmB2+2iI7/93OEYSlXyO9e9iBJi7k=;
        b=eem/1295AFyy8pb+9DneYBmGBNDyocrq3PtEuJdTF2HEptGSbwrt32aE6sBppL/H2k
         ChvHqabf1YTTq4gPxqQgmSkCvmI4BffEl2naa2jE6EG/bns0nM3jjR1laLNg9NNnw222
         9MTsdg2jXZOICBLZGMh8YmhEv9ChJJP/aBsKQKJP/x87a7iv6UgqTfB31tj9vT9e7+ci
         VU/nBccaUyRdlEXpFt3/e8u5AW06nvdn0ImanSraC6zx051IZ+OCFRM8TS+lWXOGMW2m
         md+ys8xOb6YdmEJMcMLGAhYEt0p0wNKRejnqKk2ek35sSzkoav7L0DDr5fGe/Fkl1yXu
         K8Yg==
X-Gm-Message-State: APuU4Z93Svsmzp6aI3qQ0NUqywk8EJiPMo7JgPjjNSo+zw71aCdfHvHW
	CVPfZq3Jz4sH7I5l6uvKNAVdWxG5R47lvXDO1kVgghUCtRRAErJQEO3xczFTMPROUdRzQxk9qdX
	HVo60/qXjrSTNUCxxgZVNdwX3n4yq13/88S7FjlGvAg==
X-Gm-Gg: AYBFou0irCeQdAW08GiB8FC+BIm3xmKoEOhZwx+XAw7VzRSRr7JHTTD4l001xBC4V2T
	2gcBpnwg5Kq6gT4N2u6H+5R/s/JSDrDixWA4JVXRqYQuKBzCEV6B5Fa6IhKsaNd2FBh9cDyc5Mn
	5IEJUS16Fz3ZqA6f79tGJ0y22/fXVtka4aFgO37XqyTtiQu1AYGTekInz/egHeSR93LByKcHNbm
	+/nfDaNSyM+WtQBx3yBJRqbCRpKnyIv368SskAfW2ekKp0j8PmB/bx4oz5YEP+Z66iiiEHdgtc3
	ZSvKmNzTNUHtr7D1/b3mqwFEOgyUIphrVY8QvTxNSmmGHm/4j9g1YaRbWe1/dUtNUkoCfhSEZul
	HE965w4yPZttnwZbh/pXeBOdqjdAqgoyjxN/uOSk=
X-Received: by 2002:a05:6808:3208:b0:4f4:e649:b99d with SMTP id
 5614622812f47-568143f69a9mr1869305b6e.52.1794213951498; Mon, 09 Nov 2026
 00:45:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Konstantin Yagola <master@spicebrains.com>
Date: Mon, 9 Nov 2026 10:45:40 +0200
X-Gm-Features: AclHuK9-Jdm55-GfmJKQN5riYtXI9Vg1FpJBsI7Elqw6eLyWaXKmcJAwS5bmTSM
Message-ID: <CAPy+2=yCzFKxPgzgKw7uCfwpd0BqWk_Mf+DSBY=ydTr_pdHr9g@mail.gmail.com>
Subject: [BUG] alloc_tag: GPF in __pgalloc_tag_sub() during hibernation
 snapshot, page tag ref points into .orc_unwind_ip
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org, "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FDDE1A0005
X-Stat-Signature: ftancpdnnwiwds663qe3esg9u3xitt8f
X-Rspam-User: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794213952-557738
X-HE-Meta: U2FsdGVkX19nZYuayuBGcfi9jl+9U0QE1aOGCo+pRxeCOFlyL/vg6uBpeRH6uh3xTHjzkGdgvymxokSyO2nlez1vaX/vFivo+rIMTJ/AT/4qyGM3F8quOAMufW3ya+plmh8zRp8AjGfk0POlCsBrh5eGU8qzCDyEt75HgBWOugEP6mPlv91NHEtJy/Gl2SuE3M9GOezSDqN1CWgvPSoLkShbjg1+a6ipLY6aIxdTEi4o5qU0XTcxhiYap5hE9hz9nQtNEGlOLFkUf8WQXT4L7K10LE31LfOqXEOtoTrULGVMoQkeAQ2P52MvBit9NRc64ta1QHwkw/g7yQjqGTe+hVk9Y3Lx9dZD8ZnAYg63pu4I4Gd5nSR9oqELjIIXh0eVUDT5WZ2zOkW+rD1beqTG/Mdm7itARV0/CaVOcLz46JoceVIecKevoTVR29EJsk2B4kgwmAPalXWU0XAYZsplO4oH5KfPoPQNwzwWABFh6qcKcxpiD9EhGpHOKVWf3szjFK5EiZVdsfB4O2XVIPl80k14bkzfhIAkXDk7UjdiV8spB1bDd5GxNxPhzXLNQrlm3FgSGPkr5H4rw5HooNlr0QycAbTgRY71H87FJmby9nve/FbOgoCaKuL0IMD7hLz+T6W7f6+Z6veBhOcQLa2eVEuPOelFAT1GXXWq6iUtZF8OnN6CCUw09BwkaG6gRfqAjPYrxCs9+aR3rxbbhzJNxPx34GPjUiPjKcSdnMv7bxc+rYKDS3USJZ4uIil7QH3PC4Ipv37WZjfCAJcVPT5ezW3zikQjEUCCFl9LRAwUr3CfE5Orr33Q1W/nTBzxaZQB1szigjtTDw725X7N8i9GA0Ex7tHJbYrZi1RufmxfBDP/sSuUJEKn3jdX0zGBT315MN+5KXFKATwcslDKvfjQIgeJg0HoGjo7/ggY3Zh5dajoAf4lCD3EY3dicy+u3aMIvIy1FAy7ZQ1NL9qPhik
 q2TyJJhT
 O6TUB0u8N0ZVLY3LlxIUmJjbDhr0TgDsZoTOi/QfVqzihiRrJcBXRXGzqdCFd8BfxLEc2zJWXllJWbDlYWvDBjzcwMkOJLvSLF6banbzQeXG+Ix7gdEUIRCjIx6eiK6ELuA/L/wY1Q9rlthL3JTpIvYxrA8VsTDmDTsHuxDhv4+boH3lR6G1xXYFvdU+6QV+MxsGveC65g8TAg/RgOWCj3/kExf+R/8O46xFXQeaXfyzXdeFFr782nFiLaemo1R91zIe0PZx46uFs9b/k245ZLjuEv6VogcbVOe597kBKV8MV5SabNCbATC68nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

my laptop sometimes fails to hibernate: the screen goes dark, the fans
keep spinning and only a forced power-off helps. It happened twice this
week on 7.3. Both times pstore caught the same crash: a GPF in
__pgalloc_tag_sub() while hibernate_preallocate_memory() reclaims
memory for the image. Both times it was the second or third hibernation
of the same boot, after successful S4 resumes. It is not every time:
one boot went through six hibernate/resume cycles without a problem.

Taint first, honestly: P (nvidia), O (openrazer) and S (CPU undervolt
via MSR). I know S makes any report suspicious, so here is why I think
this is a software bug and not random corruption:

  - RCX is fe20d545fe20d545 in BOTH crashes, byte for byte, across two
    different boots with different KASLR offsets;
  - RDX (the codetag pointer taken from the page) minus the KASLR
    offset is the same in both crashes: 0xffffffff835ac1f0;
  - in vmlinux of this build that address is inside .orc_unwind_ip,
    not an alloc_tag. The faulting code is

        mov  rcx, [rdx+0x20]    ; tag->counters
        add  gs:[rcx], rax      ; <-- GPF

    so "counters" is just ORC table bytes read as a percpu pointer.

So a page's tag reference ends up as a valid, KASLR-adjusted kernel
pointer to the wrong place. My guess is that page tag refs get out of
sync with the tags across a hibernate/resume cycle, but I have not
verified that.

Setup: Razer Blade 16 (RZ09-0483, BIOS 2.03), i9-13950HX, 32 GB RAM,
NixOS, kernel 7.3.0 (nixpkgs build, CONFIG_MEM_ALLOC_PROFILING=y,
..._ENABLED_BY_DEFAULT=y, not compressed, no _DEBUG), hibernation to a
48 GB swapfile on btrfs inside dm-crypt, /sys/power/disk = platform.

Workaround: sysctl.vm.mem_profiling=never on the command line. I cannot
reproduce this on an untainted kernel: it happens about once a week,
and with the workaround I will not see it at all. If there is something
cheaper to collect (a debug option, a printk, a check right after
resume), I am happy to run it.

Crash 1 (2026-11-09), assembled from pstore:

Oops: general protection fault, probably for non-canonical address
0xfe20646ff042c545: 0000 [#1] SMP NOPTI
CPU: 3 UID: 0 PID: 458460 Comm: systemd-sleep Tainted: P S         O
     7.3.0 #1-NixOS PREEMPT(lazy)
Tainted: [P]=PROPRIETARY_MODULE, [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE
Hardware name: Razer Blade 16 - RZ09-0483/SO690, BIOS 2.03 06/04/2024
RIP: 0010:__pgalloc_tag_sub+0xcc/0x170
Code: e8 79 f4 08 00 48 85 c0 74 eb 48 03 05 9d 09 d2 01 48 8b 10 48
89 c3 48 85 d2 74 1b 44 89 f0 48 8b 4a 20 48 c1 e0 0c 48 f7 d8 <65> 48
01 01 48 8b 42 20 65 48 ff 48 08 48 c7 c7 00 19 c3 ac e8 fb
RSP: 0018:ffffcfcdc517b4d8 EFLAGS: 00010287
RAX: fffffffffffff000 RBX: ffff8f220292fbc0 RCX: fe20d545fe20d545
RDX: ffffffffac3ac1f0 RSI: 0000000000000001 RDI: 0000000002bafbc0
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffff8f299ed9d260 R11: 0000000000000000 R12: fffff39ed5d7de00
R13: 0000000000000000 R14: 0000000000000001 R15: ffffcfcdc517b5e8
Call Trace:
 <TASK>
 free_unref_folios+0x18f/0x830
 shrink_folio_list+0x63e/0x1090
 evict_folios+0x154/0x5f0
 try_to_shrink_lruvec+0x132/0x260
 shrink_one+0xc0/0x1a0
 shrink_node+0xb9e/0xdd0
 do_try_to_free_pages+0xbf/0x480
 try_to_free_pages+0xf6/0x1f0
 __alloc_frozen_pages_noprof+0xa00/0x18d0
 alloc_pages_mpol+0xbc/0x180
 alloc_pages_noprof+0x3b/0x90
 alloc_image_page+0x2d/0xb0
 preallocate_image_memory+0x30/0x64
 hibernate_preallocate_memory+0x257/0x391
 hibernation_snapshot+0x9c/0x4c0
 hibernate.cold+0x10d/0x495
 state_store+0xc3/0xd0
 kernfs_fop_write_iter+0x18a/0x230
 vfs_write+0x25d/0x470
 ksys_write+0x73/0xf0
 do_syscall_64+0x114/0x5c0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x28e00000 from 0xffffffff81000000

Earlier in that boot: "ACPI: PM: Waking up from system sleep state S4"
at 28492 s, crash at 83620 s.

Crash 2 (2026-11-07): same RIP, same RCX, RDX ffffffffbc1ac1f0 with
Kernel Offset 0x38c00000 (same address after subtracting it), but this
time in kswapd0, 7 s after "PM: hibernation: hibernation entry". Two
successful S4 resumes earlier in that boot (121257 s, 192472 s).

Full pstore dumps and the vmlinux of this build are available if
useful.

Thanks, KY.

