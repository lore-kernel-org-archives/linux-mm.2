Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE27C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E1C6B009D; Tue,  7 Jul 2026 19:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545CF6B009F; Tue,  7 Jul 2026 19:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B996B00A0; Tue,  7 Jul 2026 19:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE47F6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:51:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E0981205FB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:31 +0000 (UTC)
X-FDA: 84963629982.17.A255A6A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA891160006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcmGShM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of michael.s.hicklen@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=michael.s.hicklen@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783468289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
	b=ff9EIiSPMezJ9cUFX6LF9UmQ1xdl0yO0lvTL2LEpaE6YERx5GuP1Lg6olXb4y3qwZq6oTb
	vzN8RDUmqrQM96oQ+fUW9XnAbqoBZCJYHUj4x4Zd8DL2w/bSinVs9LJNR1LHKjeGDLRAVC
	ggqKPboGkz36Gx3hcdsGyQkldiwftus=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcmGShM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of michael.s.hicklen@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=michael.s.hicklen@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783468289;
	b=h7mHtknV0B9Bp8JYv0eSJyxuwVsT32IqveiDytDSIHwFKC06XY144aQNwelQZXHXZXOQKr
	MpvUCAK3DniNLvaQV6vEFmzgRPw76SRNJVjwhr220UHanmLBSrqak5ys1RFeA1f7KsLWVs
	dI8HvjWoJIFVQeQxODSIABEMUAdXmiU=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1297f37073so5165766b.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783468288; cv=none;
        d=google.com; s=arc-20260327;
        b=Vcp6s6Kzzr1HaCCooEl8oif0MwYqfI214ldPGkc8lpEihDaxyTZ16t20ydGzOj5PpA
         yCFUA2pjsYrYF53IqONpF3HpIHvpacK+i7NWlH8YGjJUlMB8pDd+nHIhoRmXsfQelRmw
         JVPJV2T0BDQmo61N27d4Iu7ohJYoRSgkRb+Kz/iqrQPggmzsGHbCM915eIuPogsdjebo
         7arQONFrKCEx/3DdZBMgKBJ/jxHC4n2pObcnjobWUTY1THnHPjgbHjmegL8eQMEpi7y+
         zuQvOE5emVFBKYm+JKBPaZ9D6aaNoomUJoIno/7yhZ27VudHSA/R8MvbBbuD+z2LabSS
         FMFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        fh=zPBkZXFjdg7Y+OCEIfUCUmOWAoFqvVyHi3wyjAIfELI=;
        b=ffxan5JTADD+fBiv+L81us7m94Y4cNkNbYNFrFtDQ0tSv/HCRLWg0B5fH5lPhUCt00
         wSll6bUKXm32RzFgIOROC+yuB/v7gY6pN0aXg1aRdr3rRC7czjNAZ1Eko47gge39XlGk
         t6WoIf8jEO0B4GKgQymuYl0EHzliBCljxmy/RJsEaweo9MOURGZrWy2XB5wgOpxXJLxj
         SyDUa7VmnH9uEV3GsqdbsVaw1t/r4Cy7ZCb16L+3w8/9pxGioxe0ellYs287IaxuvVwn
         kqbIM9e1kb7U8ZhcmSTXOUhns+BMUH0jGp27ta8uUjjTc7xGRf5kfQCTyhGPH4YTgW59
         aA+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783468288; x=1784073088; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        b=mcmGShM1qwO234qCSkbJHsDag4I+Ou7bNN4PrxoABfOXKZ3lTfnwm98X9pGfRn3Hw/
         1AOCKj4JvzZx7pai+JyRY5YsMTwxvYXWX84y+1YmWYWNuloEfMsfCfSQwNCjxMNz5oli
         gPXuNn7dnkhly+sTlg0FFgZCWiMpCul0wHjcoqpxLUHZwyM+JGSEn0H8Dtj5vQLV0Dfj
         7UAG+E+TRXbJmPndWTPaDaEfITUxvubXdzxSHKP68T5efAklFXzvNIftnlbgCH25gUDc
         LKAdRcYRWJS/Vsn2hYiCoTUBZqkwEKooJyx7WfB8MvutXL9EUSlCsXEOmJJfn1KBWveo
         DTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783468288; x=1784073088;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        b=dPkYwwjl1qTYPnnyzBEtmo6BY7+t7S/iueRC/lQpeB/Riz8uLa2+/8QkU938dR8YoX
         JiLaRcV+k62eShjTkg43AgN23oJDHiNiuvr8s/Rt3WiOKMEd5SrL+5x8vg1OCgZSi1Wh
         DtKReJVeVF1BsT8KaonGRBgU6DcFXwHyDHwenqrKh46ochD1zqH/AqZMp7ysgD1xWoXu
         sDHXpF3DzhXrq2nqGbR6a6LUlJ3k/+8bZOm668+rB7LFebDTAdlzBOiCPMKb+CyX0Qed
         Uss6dhhp5Z6K3CB0RFU9yXiBoSSKBVPlg9GplRJFvJ6Eq0KSRWmc6hrYsYakU6cHtZA2
         nH+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrVHEuTF6pKE2sZWL2C4vt4mlpirGT3GHIwayIHY3ys9BPxQQdrW2RxrKEuSJEUfG2Rp62c5EzJLw==@kvack.org
X-Gm-Message-State: AOJu0YwwlTl9xT/dpdaLFHoCFk58pGP90nIdat9O4Acd7AQlfH/LBecB
	WmdoZrtS3Qd5AfLouXqKcpkwz0wyLzmltjQ/x7+olwkOyr0xC1Rr++Wu0FaYxbKu5R4WjDqz2AY
	SnZM7QfNLAG3GDnWG1Rqkg87uZCHugWg=
X-Gm-Gg: AfdE7cnruVxkkczB42K5x6crADe6kJdw8x0sj2ayHMhkAdFEme/UopcHhsi78+/Vm3B
	CTQjrZfqSWkyRGtS/FcenIdhJx2coPLPYL9UIfV8HqLFFCoSch9S5AwzBlX7XbT5y7FYEn6NEoE
	Az2wFdcVuvXR8ytOvm3eTEZnqWFoWEBu0MMnxYec2w85sOS2nNzEIjwDddRF8hvfJXoQJFdoEwt
	g5Qt5tRRleBVDuUllA0dVFEDZsQw1TA+S2ATjzM2+l8DN+xGHudjfNK0VGCBIvaFfdX+vH5bcB2
	grQyYqzIevIGkivjXJaWFucCWPuOPA==
X-Received: by 2002:a17:907:2684:b0:c12:cacc:92c6 with SMTP id
 a640c23a62f3a-c15ce229e98mr8955866b.59.1783468287980; Tue, 07 Jul 2026
 16:51:27 -0700 (PDT)
MIME-Version: 1.0
From: Michael Hicklen <michael.s.hicklen@gmail.com>
Date: Tue, 7 Jul 2026 18:51:14 -0500
X-Gm-Features: AVVi8Cc5vz3H8zTEQzKttdRKWMwXk_BxE5Jc1EkFsEUUga8KWImXFXYEqUovpuw
Message-ID: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>
Subject: kernel NULL pointer dereference in drain_obj_stock during ext4 e4defrag
To: linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, hannes@cmpxchg.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AA891160006
X-Stat-Signature: kehqcapfockkppfc1bjayo4c8cho3qk9
X-Rspam-User: 
X-HE-Tag: 1783468289-911105
X-HE-Meta: U2FsdGVkX19XILopn7CBgOwREXNwh3FtRx+bQ1ju5JiP2ep4q4KaC7ilaON9CKK6OwbxsA8euL9VH3qBV84j5eiVTTbXXwjJnQJuOm/3Bdk755Th9xhfhfzMPenfPgK5zKzgNL5WPkIZBeBDAvuD1wyhg+4dV420MokIS+/ZQ6nfP+mwPeCR3eJfk/bNqfYituJi5V0GvxZ4LO4gYu2TU+TnFGkh8AV93uN05R34LmaBBdzVrtN3k/eZZw84YHUipftJGFnTMI6Li7ktHZzlhUxZicwczo5PLDLwGbVoI+JiJxlIJoljECeiPpMiwBGl9lYFChO2FqDaYH93qVJtjA2LaDIKBwk92Ad7nyNhOu6cRSGr9XyRgGEB6zcP2pBMWG/1nEqWDjZu49gvlm4beodWlRfVTguO29a+b4z/Z9OCxBDJSAcYq8xpz8rkCl/7T1/jZydyVWxTGrdHOgQPxWMqO94rhjPTNktLzOZedZssD7HfWDfF4DYaDvsZ9ETHoexPB1Pi8zY1EFdzyjtw5g+acbKMact/wPSRCB5v9SaRnxQAIur0e8PyoNcg7Z9H9z8KEPKWcSj3VBzE8uwHYP2b/COa4BC5E+uEUnFRrFe9rzGJvw0krXT6MlIbnEp7tKLNSjZxKz6HhB7YZasoQXilukVz+BEVf7W0wEPoiLdcQPrs/jPSmWZAzNC/9xXXuIc0EXjkP6atteolugxwBp+yOnvV4pcflAOGZgNKeB1pHIz0fEjlxA8uZmzqIHycmCDXjivyBo+KdvGXecqjNKRoQTR2Zconkj6K429fu5jcOmfb0M19gyymOdjl5ZejOGBORFzvCFz+XH/93BypvvpgBIhnJUS10Qd2emATz89D4HIca2DFdtHfaNgiawpEjCJq4b6OIqgggv7QlauJm1z5Pbe1cmUctjBhhvezXijBSlANN4xWwq2IF/uZ/3KSkMLCZojL37j2iruzxKu
 FwZEezeO
 ZTbwsayDTaSZj0HhKzVHQhcz+8hNAClioHbydfkPYMddaXXh3n/t852xemowVA7VVeBHlnLp/L19wurJ9pZSnuGWwUkNkS9NO3DJvokL1d2fynEVC0y8SFfC/DFA9LAEGAKGYJB0qkJndlK++f5o3TD+FaZUk8oqwHUl5xkLm3SttN4fAF/tvYwcAB1MSl7lx+WVyL9Su9XQMjdPv+aOC/1nc8n7MHvFfICu3rwTxMJIh6cJzFE+VR9P446kP+UinwLfZ2kXwcmDW2T092IdvJGVsjN9+WFUzgw4dVwHoCCwWxDObtz3BVAcG61CGTQRepnRIPSyzpxVZkDoKPLs6/1UOL2kmq1ZB0/n8VfeXdeDLE+rOrMb46/pcptK8wRsyRB5eDtdBtLu1wMGr3tO9PyS8iC+tnpqIg6Q9sT0NxSP9C5pp2oj884708WKzPsTQgn4tTzNR/x1mMBxE9aIOGlzL97fC52sKm9w/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel: 7.1.2-arch3-1
Arch: x86_64
Hardware: MSI MS-7C95 / PRO B550M-VC WIFI
CPU: AMD (kvm_amd loaded)

Workload:

4 concurrent e4defrag processes operating on 4 separate ext4
filesystems on 4 separate HDDs.

The crash happens during memory reclaim while ext4_move_extents() is running.

First oops:

BUG: kernel NULL pointer dereference, address: 0000000000000676
#PF: supervisor read access in kernel mode

RIP: drain_obj_stock+0x175/0x310

Call trace:

__refill_obj_stock
__memcg_slab_free_hook
kmem_cache_free
free_buffer_head
try_to_free_buffers
shrink_folio_list
evict_folios
try_to_shrink_lruvec
shrink_node
do_try_to_free_pages
try_to_free_pages
__alloc_pages_slowpath
folio_alloc_noprof
__filemap_get_folio_mpol
mext_move_extent
ext4_move_extents
__ext4_ioctl
__x64_sys_ioctl
do_syscall_64

After the initial oops, the kernel also reports:

exited with irqs disabled
exited with preempt_count 1

followed by recursive faults and an eventual hard reboot requirement.

I have not yet reproduced this on a vanilla kernel.

dmesg:

BUG: kernel NULL pointer dereference, address: 0000000000000676
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
SMP NOPTI
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:drain_obj_stock+0x175/0x310
Code: 02 48 8b 84 f0 70 06 00 00 48 83 c0 40 48 3b 88 20 06 00 00 0f
85 29 01 00 00 48 8b 40 c0 48 63 89 80 a4 02 00 be 05 00 00 00 <48> 8b
bc c8 70 06 00 00 e8 ee e4 ff ff e8 d9 22 ce ff 8b 53 1c c7
RSP: 0018:ffffd02f86007168 EFLAGS: 00010292
RAX: 0000000000000006 RBX: ffff8ade5ddf4880 RCX: 0000000000000000
RDX: ffffffffffffff90 RSI: 0000000000000005 RDI: ffff8ade5ddf4880
RBP: ffff8ad31b54f5c0 R08: ffff8ad4ff0b1c00 R09: ffffffff97424af2
R10: fffff33ed3692f00 R11: ffff8acf8030f800 R12: ffff8ad31b54e5c0
R13: fffff33ed3692f00 R14: ffff8acf8030f800 R15: ffffd02f86007230
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? srso_alias_return_thunk+0x5/0xfbef5
 __refill_obj_stock+0x36/0x100
 __memcg_slab_free_hook+0xea/0x1b0
 kmem_cache_free+0x284/0x470
 ? free_buffer_head+0x22/0x70
 ? srso_alias_return_thunk+0x5/0xfbef5
 free_buffer_head+0x22/0x70
 try_to_free_buffers+0x9e/0x110
 shrink_folio_list+0xa99/0xfd0
 evict_folios+0x30c/0x7d0
 try_to_shrink_lruvec+0x16c/0x270
 shrink_one+0xcf/0x210
 shrink_node+0xa90/0xcc0
 do_try_to_free_pages+0xac/0x490
 try_to_free_pages+0xfb/0x240
 ? srso_alias_return_thunk+0x5/0xfbef5
 __alloc_pages_slowpath.constprop.0+0x837/0x1170
 __alloc_frozen_pages_noprof+0x31e/0x380
 alloc_pages_mpol+0xb2/0x160
 folio_alloc_noprof+0x54/0xa0
 __filemap_get_folio_mpol+0x17c/0x320
 mext_move_extent+0x1e0/0xcf0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __check_block_validity.constprop.0+0x3d/0x90
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ext4_map_blocks+0x2a3/0x3a0
 ext4_move_extents+0x3b2/0x4e0
 __ext4_ioctl+0x1633/0x1c40
 ? __memcg_slab_free_hook+0x153/0x1b0
 ? kmem_cache_free+0x284/0x470
 ? vms_complete_munmap_vmas+0x179/0x230
 ? vm_area_free+0x24/0xd0
 ? srso_alias_return_thunk+0x5/0xfbef5
 __x64_sys_ioctl+0xb9/0x100
 do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __vm_munmap+0x133/0x200
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ksys_mmap_pgoff+0x168/0x200
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? ksys_write+0x7b/0x110
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0x5f/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f6aaad17b9d
Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00
00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2
3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CR2: 0000000000000676
---[ end trace 0000000000000000 ]---
RIP: 0010:__refill_obj_stock+0xdd/0x100
Code: f0 01 47 18 c1 eb 0c 89 de 75 b8 48 8b 1c 24 4c 8b 64 24 10 48
83 c4 18 e9 1b 94 98 ff e8 4b 87 cd ff 49 8b 04 24 a8 03 75 0e <65> 48
ff 00 e8 9a 12 ce ff e9 57 ff ff ff 49 8b 44 24 08 f0 48 83
RSP: 0018:ffffd02f85a77a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000070 RCX: fffff02f7f841e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8acf8ad35340
RBP: ffff8ade5de74880 R08: ffffffffffffffff R09: 0000000000000000
R10: fffff33ef5e616c0 R11: ffff8acf8030f800 R12: ffff8acfa2586e00
R13: fffff33ef5e616c0 R14: ffff8acf8030f800 R15: ffffd02f85a77a98
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
exited with irqs disabled
exited with preempt_count 1
------------[ cut here ]------------
tsk->plug
WARNING: kernel/exit.c:903 at do_exit+0x8ee/0xba0, CPU#7: e4defrag/3310
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:do_exit+0x8ee/0xba0
Code: 83 b0 0d 00 00 e9 5a fd ff ff 48 8b bb 70 0b 00 00 31 f6 e8 14
e0 ff ff e9 0d fd ff ff 48 89 df e8 07 6b 17 00 e9 d8 f8 ff ff <0f> 0b
e9 66 f7 ff ff 48 8d 54 24 08 b9 04 00 00 00 31 c0 48 89 d7
RSP: 0018:ffffd02f86007ee0 EFLAGS: 00010286
RAX: 0000000000000282 RBX: ffff8acf81281bc0 RCX: 000000000000270f
RDX: 0000000080000000 RSI: 0000000000002710 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000009 R09: ffff8acf81281bc0
R10: ffffd02f86007de8 R11: ffffd02f86007de0 R12: 0000000000000009
R13: 0000000000000000 R14: ffff8acf81281bc0 R15: 0000000000000000
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? srso_alias_return_thunk+0x5/0xfbef5
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f6aaad17b9d
Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00
00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2
3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
---[ end trace 0000000000000000 ]---
BUG: unable to handle page fault for address: ffffffffffff0a00
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aea25067 P4D aea25067 PUD aea27067 PMD 0
SMP NOPTI
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:blk_mq_submit_bio+0x80/0x9f0
Code: e6 00 08 06 00 83 fe 01 45 19 f6 41 83 c6 01 89 4c 24 0c 4d 85
e4 0f 84 30 07 00 00 49 8b 6c 24 10 48 85 ed 0f 84 9e 03 00 00 <4c> 3b
6d 00 0f 85 94 03 00 00 48 8b 4d 10 0f b7 b1 fc 00 00 00 39
RSP: 0018:ffffd02f860078a0 EFLAGS: 00010286
RAX: 0000000000000001 RBX: ffff8ad4fb23e600 RCX: 0000000000000000
RDX: 0000000000003000 RSI: ffff8acf81281bc0 RDI: ffff8ad4fb23e600
RBP: ffffffffffff0a00 R08: 00000003a3812000 R09: 0000000000000008
R10: 0000000000001000 R11: ffff8acf8a8e43c0 R12: ffffd02f86007630
R13: ffff8acf893a2f88 R14: 0000000000000001 R15: 0000000000000540
FS:  0000000000000000(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffff0a00 CR3: 00000000aea22000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? xas_load+0xd/0xb0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? filemap_get_entry+0xd5/0x130
 __submit_bio+0xbd/0x260
 ? find_get_block_common+0x369/0x450
 submit_bio_noacct_nocheck+0x2b2/0x390
 ? submit_bh_wbc+0x15b/0x1d0
 ext4_read_block_bitmap_nowait+0x43d/0x6d0
 ext4_mb_init_cache+0x130/0x6f0
 ? __filemap_get_folio_mpol+0x1b4/0x320
 ext4_mb_init_group+0x173/0x390
 ext4_mb_load_buddy_gfp+0x3aa/0x450
 ? srso_alias_return_thunk+0x5/0xfbef5
 ext4_free_blocks+0x3e0/0xaf0
 ? jbd2_write_access_granted+0x67/0x90
 ext4_ext_remove_space+0xabf/0x1480
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ext4_es_remove_extent+0xed/0x1e0
 ext4_ext_truncate+0xa4/0xd0
 ext4_truncate+0x33f/0x4a0
 ? __ext4_journal_start_sb+0x42/0x1b0
 ext4_evict_inode+0x297/0x7a0
 evict+0x13e/0x2b0
 __dentry_kill+0x79/0x1e0
 ? srso_alias_return_thunk+0x5/0xfbef5
 finish_dput+0x23/0xc0
 __fput+0x146/0x2d0
 task_work_run+0x66/0xa0
 ? srso_alias_return_thunk+0x5/0xfbef5
 do_exit+0x304/0xba0
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f6aaad17b9d
Code: Unable to access opcode bytes at 0x7f6aaad17b73.
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CR2: ffffffffffff0a00
---[ end trace 0000000000000000 ]---
RIP: 0010:__refill_obj_stock+0xdd/0x100
Code: f0 01 47 18 c1 eb 0c 89 de 75 b8 48 8b 1c 24 4c 8b 64 24 10 48
83 c4 18 e9 1b 94 98 ff e8 4b 87 cd ff 49 8b 04 24 a8 03 75 0e <65> 48
ff 00 e8 9a 12 ce ff e9 57 ff ff ff 49 8b 44 24 08 f0 48 83
RSP: 0018:ffffd02f85a77a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000070 RCX: fffff02f7f841e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8acf8ad35340
RBP: ffff8ade5de74880 R08: ffffffffffffffff R09: 0000000000000000
R10: fffff33ef5e616c0 R11: ffff8acf8030f800 R12: ffff8acfa2586e00
R13: fffff33ef5e616c0 R14: ffff8acf8030f800 R15: ffffd02f85a77a98
FS:  0000000000000000(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffff0a00 CR3: 00000000aea22000 CR4: 0000000000f50ef0
PKRU: 55555554
exited with irqs disabled
Fixing recursive fault but reboot is needed!
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:         Tasks blocked on level-0 rcu_node (CPUs 0-15): P2709/1:b..l
rcu:         (detected by 2, t=600017 jiffies, g=884049, q=129532 ncpus=16)
task:e4defrag        state:D stack:0     pid:2709  tgid:2709
ppid:2614   task_flags:0x44010c flags:0x00080801
Call Trace:
 <TASK>
 __schedule+0x457/0x1870
 ? free_pcppages_bulk+0x1b6/0x2f0
 schedule+0x27/0xd0
 io_schedule+0x46/0x70
 folio_wait_bit_common+0x15d/0x350
 ? __pfx_wake_page_function+0x10/0x10
 truncate_inode_pages_range+0x43b/0x4a0
 ext4_evict_inode+0x156/0x7a0
 evict+0x13e/0x2b0
 __dentry_kill+0x79/0x1e0
 ? srso_alias_return_thunk+0x5/0xfbef5
 finish_dput+0x23/0xc0
 __fput+0x146/0x2d0
 task_work_run+0x66/0xa0
 ? srso_alias_return_thunk+0x5/0xfbef5
 do_exit+0x304/0xba0
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f8d52d17b9d
RSP: 002b:00007ffd9e2287d0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f8d52d17b9d
RDX: 00007ffd9e2288c0 RSI: 00000000c028660f RDI: 0000000000000006
RBP: 00007ffd9e228820 R08: 0000000000078000 R09: 00007f8d52e12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000078000000
R13: 0000559d58184890 R14: 0000000000001000 R15: 00007f8cdac00000
 </TASK>

