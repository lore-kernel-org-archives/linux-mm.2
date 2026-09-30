Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52858CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541DE6B008C; Wed, 30 Sep 2026 07:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3AD6B0092; Wed, 30 Sep 2026 07:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DAD6B0093; Wed, 30 Sep 2026 07:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 050D56B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:51:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86EA380784
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:51:30 +0000 (UTC)
X-FDA: 85270263540.07.E75B1F3
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id D977A1A0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:51:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3v_e8agkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3v_e8agkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790769088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ALSU5E4U7fg/eXilG2fEf5fAMQDTtLIfrMfFlIKzAps=;
	b=gfnQrRAYjcd3Y9DUUzfrkmJ/GcYPZ5Xje0Vi+FU3/a7O7Kw88+OqksPhllGmWB0Vexqxsv
	IhFMdn3QpbAzN8T/7RsqCkIwDdzjXJureNpntBFbh8AsuGkrYQSnPefdgEHLlOB1RJuLez
	FHmVpox6jCiMYmwS0Sp597sO8f4PLHo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3v_e8agkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3v_e8agkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790769088;
	b=4PSb9H5LOgj9ux0sFryFojuf+xJpmNf+MtTHw6cViaN9FThVwM5I0gCc5v/8y71TmBXWQB
	slY/h/dvZL2pxblcfIk85tvJPl0plj1UNg0zAZ7ap7G4R80KQuV7OHSmxPEZBRPyUfsp+4
	b/r+1tHumrhUWGGzgiZrrof49/DcopU=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28dbf4197so9300478b6e.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790769088; x=1791373888;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ALSU5E4U7fg/eXilG2fEf5fAMQDTtLIfrMfFlIKzAps=;
        b=WEp6olqqifsqGxfsci45q2XjvyghtZBYzs3sHijNu1982ii57mAKptwXw9ubxeGF7u
         ijrlSGUSBCtlLBZl3uC8z15yZzjSCTCUIpL/6x7fDB+KckBsheObJKZDOC0IsbJzNsSK
         QezzLn16Pn4u7XDdPamUaWI+JXiY9ztTIrcp7vHrUo9ECZKdAXRspyHwKLxg6Yx6hl/h
         Qz2VxH/eAvt9LRCysDqjBy2wUixSnMaqUzDZr23zL/KuwTvvg6sABaNNmLLSngsYS+Nr
         O/sJ8/Lpb+ixCHzq9gxElYIWSoWAZGEBZTSpTKPsray2yZniBqnu+a4uEJRECG8tStR5
         pHxA==
X-Forwarded-Encrypted: i=1; AKwUvBwAbtwMZ4FazWYuzgKiyN2WdoMXrVO2jhto0UuKCbG1W7o30vp9pGV0iBjGrcZGT7fTBjUJuGW+WQ==@kvack.org
X-Gm-Message-State: AFuF++mEi2T8Sj6G6717ymIIRhcM+IQuN+cdXyqBrXFXrnR8FK2O3B6S
	EmuRM+Cgu+JNOlyQOYhoD6UIs8NOD9Soz7fuBXRkJRQmJ4VanqwHCRaEuaskLzIZUqhw0Ni67RJ
	SOAKnDrpTV6/L3E9KzR8mBQYyQJ/41wRBBxKU7SlP/wWtmx2kyEa9c50XquQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:11c9:b0:4d6:90d3:e183 with SMTP id
 5614622812f47-4f1b9a42d14mr936012b6e.44.1790769087935; Wed, 30 Sep 2026
 04:51:27 -0700 (PDT)
Date: Wed, 30 Sep 2026 04:51:27 -0700
In-Reply-To: <69e1f975.050a0220.1de265.0009.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abcf7bf.fac9d4e5.17396.0000.GAE@google.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
From: syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, elver@google.com, jannh@google.com, 
	jkrshnmenon@gmail.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 48dmw33g7io4qh6nxaytqr3ipbp43dw6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D977A1A0004
X-HE-Tag: 1790769088-913563
X-HE-Meta: U2FsdGVkX18GN9fq+Vm6Pcn/MlP0U4KlIGPAd/K+zYx3nMpQ+PwTcBC+SQ8y3Ybt3KawgI3b/QG/6fYTNNgXzKWSafmSxAfAVH0Ytt1KCG9Pd3fotRhyak6AWmOgUHzkhkuoT/y1ko552hGzEj65md8Qmbv0bfOp6M5UOuBmJtxmR1lL/jKu3Ruv5mua9YC1qzHF3qSTRSzkohwynN07Q/uJiqBOwdMOl/Yrt6mZ3CydBtY87Ffez3DYPpuLwZqD9d0sNJObwJMY0N3nz6eomr3iKLfWQBEp8uJgNQTOj5ttcTJ05WeyoYB40BsXlNWtm+M3EdO3hXBc9H0FhVeY3I8oZVHuPs0WBBhNg1PKD+XSZ0YcVXrtDyc2kP4r5nZM9EaKSu3RfAN5pi/Ulhg75t/W0dk+LJhZ1FfucuRXGw/rDZACGGCHBB7JQxgNkgDPcAIYEuIkufPW/fRJ0y4Lqm277TdDXrNpLpbdKAJL1kUOYZswzkMqnZpX88mP0kUMYBlutVP0DDM5bEcsyqJ4KhzfdhF8/ykTIuw5pn0nv8a4AmUt21cR/YwCug4NMPUY0chlkNyFFZg8glXJZ5upZVEzydpJMQte7CyCnowJYFYiXBEaSEnCVQwPcvAXewo0LzaxhW6JqeyY5FewDNw65MgG3pVOc9/5t6SENFi4vANsL6Zd+8CuCyX2mkWmC45ulg4qzxjM7m1Vyd9UBpx87ImcSGp9HDYuUKfCQCqQ4Fb/YSW9qJMIwbrs1k0ZTFHOLZbydf3ksPmJV6Xa34PlBw3u1EqAm+p246iIMQv3XWNMiyj+vZTYLKlt9TGuh5UNgjhVouGA48VaMDr9GBlhD15JK8N8yX3e5PzujpVh+vizvg+dXxE9Upd7cYSVEl77YRWwM0BwU98VFsszKdkViSLLMNb5TjAqkK66rOADQ4wEyW0gKDjJ+hX3XblEWgvVntnl4eoL16+/LW+fggo
 c2Zlpxqi
 Zx1/N0uy8JfROd8fjgoFGOBHTXK1j5/PFmyrz4OoOuAVnnd/MKeeXE7m/x9AtWidCPs6N4gpwhcF8wAt1n2z8RoR8MG8rOKFUG5WZyNQpUJ3bb4np+jqT+fwS3Zmtm3ZWfPkgOxurXFfLV0Z03WIQQNdhB+TI9/+XAtofe3dkV2E5YeYTNLJQCjDG2Pd+frgpFpxGg2rkT8DqO+7zVe9cbfY10OLdqufFh8Iuy7TqBy+CPcmUI3E/bwM4Thc1k7KfXs7qlScqNGvYUR/vfUCnDFCNvqU5kbPowXsWpfOdX0ZqPZ8nbfpZb9O2vBcX344DMvKbbj0pJEnTj2nE2RCkfY6xyMaoEr8lA5Q7HO1cEi479JoroObWTVt4OjrNU7e7I1+pgWNOVti2hOj29frcqyeZ4F33w+mHGNSLYXUYdLGHDKFWMJegBzrpx2xLZITJKNnV1KJNl8LTwfiOrqS/j+JkpbMCc+juJqqLH2SvM7MkPR6k8g2aYS2OUgrNmjAed5v50QZ6SqQ1Gq9dh0ELnjcPxzKqg/v30Bi8B8SuzHAne6Wbe7O8swefoELQr4zFx/aMQk0kWV3MnLoAeshz6jFYLJ9+de41QJQ18jazKlWRV6UX6BcJmSPBvZpV0RwRH/PhpU8V/hvdyczZDpC0Nm7qmRQyeOWx2vyRJmAoRoCf21Y126ioMWGnVCQqygIbwJLJegud7Qiyem4EMWu+zY6cFZRoDP2GmUnFlkxTXtGqZU97uG57hZg2FhnQ3ZpP0CQflXEbmPG5iWV5foPhW2ZZJugOjjE2odhmrRU0606Bq09iL470DYXPWnXW10BcnW9N3dPvZy9yliPIzRscBWErAp1iRNIfT/Kl4YAD3U8D4Wb3H4LebPAyi5vU1Z8ABTNRhgzD/BZZM5LkELGvQwPDBxhDl8JbIyT7dObESRSqKogDxKcGeURj2W8ZZVko9YFrijlI0NmkZbmNCyNw9OlHf9ZA
 zB7tXTgx
 D3iC5O3M70LzAOGWljS0ZzjOjDV3JyNSwnG3erViJRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    551c722f4080 Merge tag 'rtc-7.3-fixes' of git://git.kernel..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1426a3f5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea1e6d8de13bab08
dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179a2b15580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in mas_wr_store_entry / mtree_range_walk

write to 0xffff8881105bc000 of 8 bytes by task 3634 on cpu 1:
 mte_set_node_dead lib/maple_tree.c:305 [inline]
 mas_put_in_tree lib/maple_tree.c:1652 [inline]
 mas_replace_node lib/maple_tree.c:1667 [inline]
 mas_wr_node_store lib/maple_tree.c:3276 [inline]
 mas_wr_store_entry+0x3c1f/0x5ac0 lib/maple_tree.c:3606
 mas_store_prealloc+0x421/0x670 lib/maple_tree.c:5031
 vma_iter_store_overwrite mm/vma.h:704 [inline]
 commit_merge+0x7b4/0x840 mm/vma.c:847
 vma_merge_existing_range mm/vma.c:1070 [inline]
 vma_modify+0x9eb/0xd50 mm/vma.c:1756
 vma_modify_flags+0x1be/0x250 mm/vma.c:1799
 mprotect_fixup+0x382/0x660 mm/mprotect.c:824
 do_mprotect_pkey+0x69f/0x950 mm/mprotect.c:1002
 __do_sys_mprotect mm/mprotect.c:1023 [inline]
 __se_sys_mprotect mm/mprotect.c:1020 [inline]
 __x64_sys_mprotect+0x48/0x60 mm/mprotect.c:1020
 x64_sys_call+0xd54/0x2550 arch/x86/include/generated/asm/syscalls_64.h:11
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881105bc000 of 8 bytes by task 3640 on cpu 0:
 ma_dead_node lib/maple_tree.c:505 [inline]
 mtree_range_walk+0x35a/0x480 lib/maple_tree.c:2119
 mas_state_walk lib/maple_tree.c:3013 [inline]
 mas_walk+0x1ac/0x340 lib/maple_tree.c:4458
 lock_vma_under_rcu+0xc9/0x210 mm/mmap_lock.c:304
 do_user_addr_fault+0x239/0x1060 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595

value changed: 0xffff8881058c0526 -> 0xffff8881105bc000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 3640 Comm: syz-executor108 Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

