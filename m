Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741C2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 21:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF126B0005; Fri, 26 Jun 2026 17:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170386B0088; Fri, 26 Jun 2026 17:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F0D6B008A; Fri, 26 Jun 2026 17:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCCD86B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:26:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 493CF1C3516
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:26:15 +0000 (UTC)
X-FDA: 84923347110.27.40D5CAD
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8131FA000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:26:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eZKk8+cZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782509173;
	b=rn9ehAX9vGo7Jb4iE0E3kJVcOIzORmjOsaCROJT5OVg+mClNhfnwf2fL1naIzfIRjmCB/j
	TbNQbPVnyQ/pK2FeA5A5Ho4DEnh99hlKFm3IMHirZUVfTqfISeOHUyhTExssepwvdgurx6
	SIkNhk4Tv7KLuiKw0gSX0L9Z/i1D6Lk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782509173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OnwdaukFZGHXEjH/UlhCaXFzrTOBU2ErYEjAMkT0NPc=;
	b=izwntAhhuc78IeHAZ3LXZ4Mg4+Ugv2NJo2mmKEk0kcRcbbbNlmuzvsx2rCNH7hNp4h6m+B
	qM9SVdyIP5amhvxuzWl/6xvHuGnj31UOYoxDXibDIIT8n1ovoiCOEk9Ja393lZT9NvNlq4
	hdbqJWxWIdbm8ytsCImY/8/v1kjHw6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eZKk8+cZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-96721790a03so32067241.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509172; x=1783113972; darn=kvack.org;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnwdaukFZGHXEjH/UlhCaXFzrTOBU2ErYEjAMkT0NPc=;
        b=eZKk8+cZTiHZppqD1aAdtQ2Hr/5HXkhjBRAl4lwIicnayPwoUsBRzFrZFiLlw2BitF
         eNY9f4IAfARkKiJKCEmWg+xnmf/1/e1vmqzQtrg3fU+V26RpXwfuW45w/Rzw/gLHOGi0
         3gz5GZAtwuHxaSrjs/cwb22KrnA77MR5nUtJWpr5zAIFEwQt2OEWA0IkY6ypTTlR33cl
         V9swOQ+G7/eEMv5W/Pzmbxm84+OjbqMfARIPDPaXpEoa9+V1dgM6osL39uDaCtXh/RjP
         zS1tr6PcD4AKsHTDE3Oy78vfNjpIaMaS+3Xr7dVZMfeidKTQrbWPltBleLhGyChwrmk2
         8y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509172; x=1783113972;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OnwdaukFZGHXEjH/UlhCaXFzrTOBU2ErYEjAMkT0NPc=;
        b=aQPapfvv4xPdRm+GsdzDAFcN3lDgj00rKE30VCiMVgxtg9Z56fRNosFpGxINxMR4KF
         KkI/PldaiERG1tpEw0wDTzQVXReJP+W1aIKo49qi266aO+0XXWjeBe03mofnEQOhW2G6
         hyfW1bJ8CbT8jeky05W0b27DqdptqMK+fHcGjT6gXA1pd6d8PqwWAnUH0osdlb0CL8MB
         aJdNJQChlLS1gD0b6Ey5F8e+TvGlJexlFucNl8bvynP3Plmf7tA52RDYYjoxSZLk+BX6
         L4UvOXAZrej6SQ6EfScl9F45NYI8WD7N5kGkM5gb2qXirfpsDx1roskclrMVdOm3YP1q
         STsg==
X-Forwarded-Encrypted: i=1; AHgh+Rri0NNUzDj5G94Q7cPrfV3aTRxW1rp2B6IE6OtQ4mdKeUkWx9+QessZv/PGhy4wIJzykRXbXEsL+g==@kvack.org
X-Gm-Message-State: AOJu0YzOFcTj3uP81WCgd+p+8xeINUsRVSSK3E9HxoHa5azMe+fXbNDB
	Ot8y+cH9i44EvhQ+BFPk9vpasDT0kn1EyxCFQiRPoAqWp3XFKRJGuMf/
X-Gm-Gg: AfdE7clKNcMBRZkueDZBXxsM6av8PH1eaR42at33RuKZUVkwqr6Veq4rDVvj5BHqhr5
	wsGOBkVjFzUBqGhZBdUBVpD3g+7VKFYP6t3kYaB9z99iQqidjg5byYcVPlRESigqCLUuadgQFgu
	s9gLLvQnUAwIbV6dOCoHHIKBGYzGSERm4IzdSjCKo0TDARsTJ5YPwyFBV2I+ysKsAPGZgOIH9Mo
	0ebw8bZyaEXQSlTqcDVm1RjL+kjOBP2i+7D7nJ9xmCy3ojqSxQ0xF2CbmODe3xaCq/rrKCzBfZL
	9qSGwxkr88reJGWAb10D+L7P1/fTUv3/DAMehU86022JJlYrydMLK4w7ut61ttZc5hVB4/MyiR3
	fkqIKvicAaBuJFC7x4Iac09xO9iBT0XL/jtyFldyiyva1SSHxbIgdPyu5ov2WM1o6nq+N23S1MV
	1sHLBFeTNPotleuysSz18gD3879LTdEu4i92Iwfcli6xpZSPJ7y55+WqffaDD97tWqqXyrdX2QR
	sTEmnxjog+X
X-Received: by 2002:a05:6102:1489:b0:637:30f8:5cd5 with SMTP id ada2fe7eead31-734368cc7f7mr1403865137.8.1782509172572;
        Fri, 26 Jun 2026 14:26:12 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7356a630fc4sm1898104137.12.2026.06.26.14.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:26:12 -0700 (PDT)
Message-ID: <6a3eee74.68f6b9bd.2e7afb.801d@mx.google.com>
Date: Fri, 26 Jun 2026 14:26:12 -0700 (PDT)
Subject: invalid opcode in __get_vm_area_node
To: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: sanan.hasanou@gmail.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8131FA000A
X-Rspam-User: 
X-Stat-Signature: aukp48shbxp96bxk57uoz8y8se7j9xb1
X-HE-Tag: 1782509173-657526
X-HE-Meta: U2FsdGVkX1/W7mqLJzvspq73aEGh4zg47QcVrEAMPFj4uebxgiwQDD3tbo+gqlry8kKOqNHf2ujyxTmYyLH+vAexnJBRZtDH7E9ifUXV+GqrJMkcJzqiSvMMVdU5cP+18RUWWUx1WMEknHiUHyNOrvEdwtMYjEZSYmj5TIXj9hnnhs/VxIcNE7J2wfAEYZvuaUjQz3B/q4OIrfbE8nIYQp5UP557JAvlh9NAkHhVzTYqvi6xKgA0cYbkEidi1/zqPihyj1pYcQW1h4GFx/qNa5gGakrNY2qxIWcmWUNB3gNFI+jphaDlZOD7ZmeWp2N6Mweyr6dzqJAvo2spC+62ACd8k27infRT71OyEf1Hg3QVhftLGkyhLMvB9Q5AVqTq2KQoDLbZPuliF8YaYPnJcTFVLS/On6+QoLtGCbwSssLoWDokjt1sc5FG1D8N7DNA5hXdgvQgbtrSBAZ6dVJtVgck8TnYDmnD9IjsgxS2ciH2wfIMn/feyEacaXFauEXtQmcK1tquZVklJKLXEj7CJoXVlCpUnkCpNlpfJqanE6x/mADaquswZ5inNQN/RZ1vrNCXXJYLWE33WBOB2MhrWEqKttguU+seKE0brf8LDSRdk6APOiDSa+0Pv9a4pgMvJysSvvIjRnIUZXPjsY2j8HWfH3oFFMs/7qbMejXYRC6xct7lgkb129Xf7wDXXMoR45byQM9BKmpNz/vg8O0MHyDvhSZBBUJL4KmmSA3PAp7tXSbzvy4FShv3BASg2r++tWGJoyZUjVQA3pLap2wVP7PFebEIP6oFLw8gvwljeH/n/DFIrHGMLiIATP6ik5VbDMY4IU5HRcFCz0tV4akTHpfy2aYErugUiDI+kgk4lIAbCFTMTi43nGTtLgST4dlKurIk0gZPyh9ye2NOVGyOZGXpHx//NsYoTRGA5MjFJvYYz/rYAFI/6UmueucpJLFKv1KPh8HuuE6yru1K8yW
 M1FBo8wB
 08inkix7amVCaUNgH85FvpdP81ZUdz3/n37eMX4Ead5szZIyiY5KcdxmzepWNKBkzaVZtAmh2ioX/dUDsTRq23uRDp6laRKwowyp2JoStmxlJXmx7nIoYrsrpzaBb+xnT0vd8gW6/QEi7xNQH49mZ52N5tXDyKz+b+PtFgjvNz9lcwsd9IK3V8dsUNgZWezheVLgHPwKcaa8CVLo/1awvur70czbg/yqVMrVKRgWn/L0mTfiMs2y7QP5KSXH9YT6MvBQTOBXKoPFy8Eoent/WPUeFLDGjYPVa/k1FWyGhPXOgj/dMgEn3mltmERhkm+OT2F825uoHUVaRczcI3M8ukV3G/tThYjcmR7NNoFlj1ghxAk9U6QYXaabYvx5AKLBCHeaOqfXPDhYlW5FxfS8mBcv6EPSnFUjioF0GT0HssuQUVlcIZE9iiRXeCW9HfqPev4/fCc/cbLZbhxuDKW2+d4/tVhCQvPz0CxKZ15cPRKh4BzDmcSlRqtvZgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1SkS9U2y8MGrnaXhjJJI5n5SymSSMyYnS>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

UDPLite: UDP-Lite is deprecated and scheduled to be removed in 2025, please contact the netdev mailing list
Oops: invalid opcode: 0000 [#1] SMP KASAN
CPU: 0 UID: 0 PID: 11561 Comm: syz.4.66 Not tainted 7.0.0-rc1 #1 PREEMPT_{RT,(full)} 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__get_vm_area_node+0x34d/0x350 mm/vmalloc.c:3212
Code: be 01 00 00 00 48 c7 c7 c0 95 66 8d 48 89 da e8 39 7b ad 02 49 c7 c7 ff ff ff ff 48 8b 5d d0 e9 7c fd ff ff e8 a4 ed a7 ff 90 <0f> 0b 90 0f 1f 40 d6 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
RSP: 0018:ffffc90026d56630 EFLAGS: 00010246
RAX: ffffffff821e820c RBX: 000000000000000c RCX: 0000000000080000
RDX: ffffc90011a4b000 RSI: 000000000007ffff RDI: 0000000000080000
RBP: ffffc90026d56678 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1db024d R12: 0000000000000000
R13: 0000000000000022 R14: 0000000000000200 R15: ffff888025c3c4bc
FS:  00007fc6f9c366c0(0000) GS:ffff8880dc0a8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f071644d660 CR3: 0000000069586000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_node_range_noprof+0x373/0x1500 mm/vmalloc.c:4024
 __kvmalloc_node_noprof+0x509/0x7c0 mm/slub.c:6739
 bucket_table_alloc+0x69/0x380 lib/rhashtable.c:186
 rhashtable_insert_rehash lib/rhashtable.c:470 [inline]
 rhashtable_try_insert lib/rhashtable.c:637 [inline]
 rhashtable_insert_slow+0x1b92/0x1f00 lib/rhashtable.c:650
 __rhashtable_insert_fast include/linux/rhashtable.h:794 [inline]
 rhashtable_lookup_insert_fast include/linux/rhashtable.h:970 [inline]
 fdb_create+0xd24/0x13d0 net/bridge/br_fdb.c:411
 fdb_add_local+0x13e/0x410 net/bridge/br_fdb.c:446
 br_fdb_add_local+0x5d/0x90 net/bridge/br_fdb.c:977
 __vlan_add+0x630/0x2a10 net/bridge/br_vlan.c:335
 nbp_vlan_add+0x24f/0xa80 net/bridge/br_vlan.c:1343
 br_vlan_info+0xff/0x460 net/bridge/br_netlink.c:705
 br_process_vlan_info+0x600/0x890 net/bridge/br_netlink.c:768
 br_afspec+0x39a/0x5f0 net/bridge/br_netlink.c:836
 br_setlink+0x271/0x800 net/bridge/br_netlink.c:1135
 rtnl_bridge_setlink+0x5b6/0x7d0 net/core/rtnetlink.c:5534
 rtnetlink_rcv_msg+0x77a/0xb60 net/core/rtnetlink.c:6967
 netlink_rcv_skb+0x206/0x460 net/netlink/af_netlink.c:2550
 rtnetlink_rcv+0x25/0x30 net/core/rtnetlink.c:6985
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x811/0x9c0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x847/0xb50 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x5a5/0x900 net/socket.c:2592
 ___sys_sendmsg+0x224/0x2a0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1a6/0x270 net/socket.c:2681
 x64_sys_call+0x17a2/0x2900 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x11c/0x810 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7fc6fb9e3b6d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc6f9c36018 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc6fbc55fa0 RCX: 00007fc6fb9e3b6d
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007fc6fba87c3e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc6fbc56038 R14: 00007fc6fbc55fa0 R15: 00007fffd78dbe70
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__get_vm_area_node+0x34d/0x350 mm/vmalloc.c:3212
Code: be 01 00 00 00 48 c7 c7 c0 95 66 8d 48 89 da e8 39 7b ad 02 49 c7 c7 ff ff ff ff 48 8b 5d d0 e9 7c fd ff ff e8 a4 ed a7 ff 90 <0f> 0b 90 0f 1f 40 d6 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
RSP: 0018:ffffc90026d56630 EFLAGS: 00010246
RAX: ffffffff821e820c RBX: 000000000000000c RCX: 0000000000080000
RDX: ffffc90011a4b000 RSI: 000000000007ffff RDI: 0000000000080000
RBP: ffffc90026d56678 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1db024d R12: 0000000000000000
R13: 0000000000000022 R14: 0000000000000200 R15: ffff888025c3c4bc
FS:  00007fc6f9c366c0(0000) GS:ffff8880dc0a8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f071644d660 CR3: 0000000069586000 CR4: 00000000000006f0

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

