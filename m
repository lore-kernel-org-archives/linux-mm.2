Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD48EFB7EF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF976B0088; Mon, 23 Feb 2026 23:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DBF6B0089; Mon, 23 Feb 2026 23:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E906B008A; Mon, 23 Feb 2026 23:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 306396B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:48:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF7D4160427
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:48:35 +0000 (UTC)
X-FDA: 84478119390.12.F71E910
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0FBF080004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:48:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3oS2daQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3oS2daQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771908514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=oWtSLJc4nIIjVEnAWb0GJjQ5OC/U2fFyyXC24rRSQ+U=;
	b=HxQ5U6bOqmvxrgum9A2vtWJb6F7SJlEA+YmVqvJ/e5yOuaEuflU2s1OC/TkNHGsOUrtZ/r
	8E667FEOiKKboSwZPnlvFItb5NdUl4+T04zvjEvpWaDRmmDoipNeEhFbimNayEXrbfI4JO
	/karlMUZSmnZZSn9xK9TDvE3289iwA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771908514; a=rsa-sha256;
	cv=none;
	b=jM+uKwuO6eR7hktOXU6YICv+QHNyl+T2L9J7XCP0RMTTbxVYcNaksYQEOCU9LEguZy8XpJ
	106Uvlj95Rg5pItDVpxLTkYwe3CY0dcexRl1heGJ3pL9dJzHr12HAx3uPTb9DdvJdxtpDL
	3W44tLusjsIsxNSN0OVyba+KIkmKU0Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3oS2daQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3oS2daQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4cdc32cdeso70022352a34.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:48:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771908513; x=1772513313;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oWtSLJc4nIIjVEnAWb0GJjQ5OC/U2fFyyXC24rRSQ+U=;
        b=UTlU6QEFoSuKz16DpeKbW5KIEP7m+bUr3u4Z6BYA4drIMDXJifAWXDth8RElIFu9p4
         kC5LOUJK//bcoSmVand7qWnox83JqMAI8WdrIAXNKQaZ7hiRLd7AlkvrdomzgcIs/Zfn
         oXdgXjKv+HceMbCRpKL2dwjhXtWIEpwi57Yn1r2F0Hc3YoFEJV4mRFH86fcVcOe+TLT1
         KzAFF7otP5uEF7obIFGKveXbqsmpf6EiytR54T9fQpL3DX1WyMBwThAczKcvZfd/NHHW
         4uAzsmOMbwlKwFyi7leVpFQJ6Vz0zQptZGmJnYpnljQ5Q1OspHmsp9aIugFPRfeoGryx
         TLZg==
X-Forwarded-Encrypted: i=1; AJvYcCWSBAdCNr9bq+o4f7ThrxBkL861y2KjoeOlnCwh5EHRr7xgued4+yQdZQ3UVkaxdqyGK4vLEecclw==@kvack.org
X-Gm-Message-State: AOJu0Yx5CimlW+WiBXxNQE+63IIbi+dP3/WfbpA9ZEPglnUBovUnQgSG
	mRqetucApDlzwQzo2rmUdUULsgflHJSv/g/L5b/lgGYQXgLF7Dg+BsCdA6XNkB7ILQxO9nA88Rl
	8Uq1B1l9hF0f+nwVAHa7V5DyC4GaA9i2fBLV8WJWcWHKSSxFY9qsvpRGb7rE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c8d:b0:679:9252:6607 with SMTP id
 006d021491bc7-679b123dc2bmr8849685eaf.41.1771908513053; Mon, 23 Feb 2026
 20:48:33 -0800 (PST)
Date: Mon, 23 Feb 2026 20:48:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699d2da1.a00a0220.121a60.00f4.GAE@google.com>
Subject: [syzbot] [kasan?] [mm?] WARNING in __kfence_free (4)
From: syzbot <syzbot+ac1ff64591d23db965f7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dvyukov@google.com, elver@google.com, 
	glider@google.com, kasan-dev@googlegroups.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: a8jdtyuia4zkbmq8mff9murgqjyssac1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FBF080004
X-HE-Tag: 1771908513-496467
X-HE-Meta: U2FsdGVkX18n0GIcbs8irMd5gor0keSQODqVUrqzS94yVzJynTlmVgoKTSAFluPouFuvLObAzyp00a6p3ZbVwkgWZaizuZbx2kxRMj/aJSmEriQxbu9lzm2kc7+87YY/3k9+PM38qHRH1WpM/RHn69LapYAlEekE5RO8txB2SE5EYH9urd7vpnWYhVZWCF9W0r050UAGS4NbQv3VQb8QD2qCzD2RW/Z+gvI6FUtPL/l2kPHGIGZNToR0KMuu7HCBMmostTC9qr/l23h9WkxpuOBRR+p0CSGsqh/xzrpqzWO2NU1StehDi4pCEJWsW6BgSZysE9XPXj3DfKa2Weo+x+0JJBgRWnwyoSVbFFVKGDgdR7HMga8T874ByhgvpwJwOySQ9Sh0ceRKBN6e1GUMdEqyzvA4Q0b3H8N4Ektblk2IMSaHdDFHhNwfKHOclevzHqFBdSlABI8K7jg2eT1Jxr/BtfYOwtY02VpS5Ve1aiYLNpUTrgVFUXNbUFusuUk4WViGzqt8p1dG9QQG5gJTWgvjN91yQTq0f8hZRpp6h0piRMn75bNNPw/rZx4mT9qzDeIe+4orR6+At3mCiywTHiGN6SLt2Kc/8sElEsS5eiRoCewRoIxolkxcajLC9xMXSNqQDt8pOapw0+D9HGEBd7OOAlTKFYledUny3c1iCeB/A2vodLzafbjZV/euDgZOTI7KD9jV5aclueEkOAG1KtPJAzUlW8W0Hxta+mt9fbG9dLpdugVi5uG8J2Ewi5wTv6uUT0WX8XfE5f8GVvdKjddrlQ+aM11Ce29t47BiU+iWmfGONW8PgjFi2CAWQDLNZ7B5bJTmRPo7PvN6abqwaYAMef9GAgAL7HPxfZQX2tKxb2SHKTMXXR6zFaT+jv0w8PWR2a5hWaSG22yMrvIvN7ljdmJfXoxKipGYB1PqIM804ILTT4BaU7ILn5mVucgVLtsR6edMcQCK3INCNOt
 aQdZLY+V
 d7FAvk+Xz9+gm6iofd9d4d5TGzrR/tOFBeVtYT3FoBkOkmDq2IoBe2p9nijiy4CDihIClaiZSeC03UXQWChGcOu2/HTyWdUMEuTlXaIhs48WpdO/S7A+zeuLm1OWABc0JzZqZFVnP0Kt/VVDc54I5aun3lONmIf2jcs3AyyXiK2kXYqP7fUsydNmOXLoVh0JAphuxMU2hRYxKJkRYf2/CSno29+BLQkP7EkTWUKp3945auBRAiBBW0G4p6xo6lPL+6WstN5aytUmMwIAv2Rfd8qolgmbhkmUEyBrpak3mQNw5FPpf0Dc8lhiBpb3MvmiQrkw9EDL+Fk6NJ04aypnpS6GDitxb1DxokAhM3EwVvqffD7LugCDX1JY7A1Kixb/FY2fD11jusqYZy8NvZsrRD4oGIn37Q3WINfTAOB8WguR142fJKw8nD7Im8V9AzW2QThxtYi6Ojol1IECZFz3BrfPm5DuqMfLbGG8jXPnT0SgAivKV9cAz7tz6s4Mr8CYNXK5PKJ72SwX8LNe5sNsTQQnqHjx99NCPsmUXl36jiQFljSGKXj/q9OC5AjP05n5tjxlfs3G13s7Eta0U9TlJGynTkIVpjy4jhzZm+SijDnf49AkB0+Y0znzrByJHywIfLRw3NxspVWFAePEQ0EXICFt3R0KaXGpJhleWHXmUWdzPpNw+SoZfDb9KJEzPJIhTQifopYRNjYPwbgj8Di1XMnLoh6SgU8smocDfyvHuu/8/DzoFgkED4xbDoiq4vg1FFHwygEd+nbJNjldYPb/CviSb73Nbl0u9oz/vqd203lEy7JWeZS1LXDUmAPij14kAN5FXWPh2G5V/19Ja58SkWXJY5kkx3nRGXWa/b1zPf/ghfV4OuGkddi5JTCE4TuPCpX3fEe3uYo61oTHYNKxh4O5edQ8r6P+gIgXwaCKLYrHezjDHBEbEbQAFB5zFv1vSRVfyNjjH2K5lebAUkV1LYa2PMIyC
 Pfly+vPa
 6/465byVcoXlrmucL+sk6cih0OIPwIC73fYD+P0FWUAOkMUJcLFGdbcpSDFXrroC6HihrQ+OWPi0EoHFiJPP3tQ+i1Hg3VDP+mFnAc1M69oBUg+6Op+U5WfkFIycyBbAsCeQrjHEffuvv3ZoKMBDWnyl5DHDQsFvBXwKKsE/w0U0iCSq28DMXaJ0IBgxfgkaPSBc0pnvTJOEIApIy97bkSRng1PMspueQ7IxmD1wbeGPNCLg8rU7kwuXBb41UntlIApHwLC/BZRU8bXlysHUG4aEyuyenakVpSEEE2vqcFb6iePaoTBuFJHwIkJVq9RfMWuefhzZw1Ey9sHgXsCLsbyjJBYURIz0VQrrq+cJarWHW3ShKJ28vYblbJKduUSnsU624rrZ2Rjcd4SzrUcTMvcb+oiWXyDFa84a6YZvQ8sxCga5yM3N3uGQCJmlvDT8AIkTqlDXLr8y/mRdbBpCYV6tdvDzdnK5CCF9fXOINsY8zypBrVhEoG+iN/dwQ8Sedm10/fJQ8DvXk4TkTpFz1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8bf22c33e7a1 Merge tag 'net-7.0-rc1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1220195a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1bd834155be39cb
dashboard link: https://syzkaller.appspot.com/bug?extid=ac1ff64591d23db965f7
compiler:       aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-8bf22c33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/80710eccc853/vmlinux-8bf22c33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a174aad260d/Image-8bf22c33.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac1ff64591d23db965f7@syzkaller.appspotmail.com

soft_limit_in_bytes is deprecated and will be removed. Please report your usecase to linux-mm@kvack.org if you depend on this functionality.
------------[ cut here ]------------
WARNING: mm/kfence/core.c:1224 at __kfence_free+0x60/0x100 mm/kfence/core.c:1244, CPU#1: syz-executor/3322
Modules linked in:
CPU: 1 UID: 0 PID: 3322 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 81402009 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __kfence_free+0x60/0x100 mm/kfence/core.c:1224
lr : kfence_free include/linux/kfence.h:187 [inline]
lr : slab_free_hook mm/slub.c:2625 [inline]
lr : slab_free mm/slub.c:6124 [inline]
lr : kfree+0x3bc/0x3f4 mm/slub.c:6442
sp : ffff800089acbab0
x29: ffff800089acbab0 x28: fbf0000005fa0000 x27: 0000000000000000
x26: 0000000000084008 x25: ffff800082a81000 x24: 0000000000000000
x23: f6f0000003412e00 x22: ffff80008033b784 x21: ffffc1ffc1ffc000
x20: 5eaf80008033b784 x19: fff000007d89df78 x18: 0000000000000002
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 000000000006f7ec x12: 0000000000000001
x11: 0000000000000400 x10: 0000000000006400 x9 : 00000000000000b0
x8 : f3f000000622c45c x7 : 0000000000000024 x6 : 0000000000000024
x5 : 000000000000003c x4 : fff000007d87a000 x3 : ffff800082a81000
x2 : ffff800082a815e0 x1 : f4f0000005ff0c80 x0 : fff000007ff00000
Call trace:
 __kfence_free+0x60/0x100 mm/kfence/core.c:1244 (P)
 kfence_free include/linux/kfence.h:187 [inline]
 slab_free_hook mm/slub.c:2625 [inline]
 slab_free mm/slub.c:6124 [inline]
 kfree+0x3bc/0x3f4 mm/slub.c:6442
 kvfree+0x3c/0x58 mm/slub.c:6760
 xt_free_table_info+0x80/0x90 net/netfilter/x_tables.c:1213
 __do_replace+0x250/0x310 net/ipv4/netfilter/ip_tables.c:1084
 do_replace net/ipv6/netfilter/ip6_tables.c:1158 [inline]
 do_ip6t_set_ctl+0x374/0x418 net/ipv6/netfilter/ip6_tables.c:1644
 nf_setsockopt+0x68/0xb0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x90/0xe4 net/ipv6/ipv6_sockglue.c:978
 tcp_setsockopt+0x20/0x3c net/ipv4/tcp.c:4217
 sock_common_setsockopt+0x1c/0x28 net/core/sock.c:3973
 do_sock_setsockopt+0xa4/0x198 net/socket.c:2322
 __sys_setsockopt+0x7c/0x100 net/socket.c:2347
 __do_sys_setsockopt net/socket.c:2353 [inline]
 __se_sys_setsockopt net/socket.c:2350 [inline]
 __arm64_sys_setsockopt+0x28/0x40 net/socket.c:2350
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x48/0x104 arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x1c/0x28 arch/arm64/kernel/syscall.c:151
 el0_svc+0x34/0x124 arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0xa0/0xf0 arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:596
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

