Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9E5CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C465B8E0119; Tue, 14 Oct 2025 09:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF758E0112; Tue, 14 Oct 2025 09:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97CA8E0119; Tue, 14 Oct 2025 09:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 918ED8E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:10:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52275160923
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:10:59 +0000 (UTC)
X-FDA: 83996755038.03.48F8017
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 852661C0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:10:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 34EvuaAkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=34EvuaAkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=YTvCLh80L5RCIEYpK48k3nL1zjTVSsw4OaSTIePcCmg=;
	b=4HssOamS9ltg04avwSDj37vJuwTAqxU5SP0/V1pfXgOhlRKoKCaD5Jv4VTAjTZkjxOFKBj
	8zsqMXP6uMjQg7UNBlMrMWacni5XsaUxHyAG6jFhk0aJushjjoMuye/ngZQl1s//YdMidi
	6zbsjw3baRF9ZoemrEIjmgl9ejqpvQs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 34EvuaAkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=34EvuaAkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447457; a=rsa-sha256;
	cv=none;
	b=iwiGm5EV5KOxwlwdFeBprPmADNoF3DFZpIl0EUjrEEbHk/uD4n2OuICcX2E3Ha3PigdLI9
	xUdEpve36xC1Ufvn0vTqM+rwSOmUG80krzVv0m2urSgrlqeiJlk9AEr5FSRNjNEux40kVz
	XGgeChi86x9el1sb0qhMXPjW7EDJIdc=
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9048fe74483so1392394739f.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760447456; x=1761052256;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YTvCLh80L5RCIEYpK48k3nL1zjTVSsw4OaSTIePcCmg=;
        b=neBGcvwV7gesunNJE8b2KeKjCE6gtgKJyXRy1CzPcNu5n4gh0YGZG2aQw9CyUa8uYW
         3m6fQyUe47TMEm5mTOKnKdtCJTEvCOxp9M3C36KrGw0mccblaeCVpOm5e7XGVRZJ+O3Y
         XQQtnBAIsk1jqm1EFp10036K21y1g8oXmgS61PdXgj5zHGy2artSviXWDUUp1nYgsrSZ
         uQrVbI+ORZl0THLyMM0FGnItahzzQ2Iv6VK21EZownvQ1sp2bxB8mULx2Gtl8FYZdaYh
         FFwaW0myoWGSG0L71wklGKYHKkQFW5lY/OX6fbZ7TrKWrokD00nPvESR+M+hoO62bguM
         f6Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWgd5UHiGzJC7x1JZ7fzDjvOJ0bcIltMzPrwLAsPBEZBkPM8iKtN78aAmQwHtSBT3kf0aQQt7i7Dw==@kvack.org
X-Gm-Message-State: AOJu0YxdVYKHbiiy8e4KgAcD1Bjtb+6ajhBEAEdK2ZV0y8RypK1O9hzk
	JpprUmsdwktO8pfyIJYKiEMHHZIS7Ymlj2V5hFu7V9YCP87qDrPfq7vz6UfE6l/+O6kuhnrHICw
	YKv/bEI6CXDhQA8/MwD5x9ONkheKmUxzZ2IxzR5m4txSRLJ1YDNEzfHnjOUs=
X-Google-Smtp-Source: AGHT+IEPH9IF89ITwygTX0sulnxlR817dJPiW7sqU1Z8BIDZ/6e+3f2GvHQhEGN5ckeXiKxOq+fc0U8MPZ/A5YbCtFxHLytXbbXL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c5:b0:426:39a:90f1 with SMTP id
 e9e14a558f8ab-42f873d62c7mr267953315ab.18.1760447456621; Tue, 14 Oct 2025
 06:10:56 -0700 (PDT)
Date: Tue, 14 Oct 2025 06:10:56 -0700
In-Reply-To: <20251014093124.300012-1-hao.ge@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee4be0.050a0220.ac43.0104.GAE@google.com>
Subject: [syzbot ci] Re: slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
From: syzbot ci <syzbot+cid6b2cf8227adc21a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, ast@kernel.org, cgroups@vger.kernel.org, 
	gehao@kylinos.cn, hannes@cmpxchg.org, hao.ge@linux.dev, harry.yoo@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	surenb@google.com, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 852661C0002
X-Stat-Signature: xbo71kf7zj86xfpo55o4d38fzy4hju5d
X-Rspam-User: 
X-HE-Tag: 1760447457-54582
X-HE-Meta: U2FsdGVkX18lcERt8J8H9nG/zJy6agWtfBrCdvDEj5pLJazGdiP8hrEhxnUNM8jQVq7SOvB/K/jBFA60LqtowNZ2cGzHY1Di83aoyT18qaTmcpBt7ljjaw9Qjzxj1Ia1LMs4NhoRfE8cmKigD6TGZWMHdLOiFdmR4OYN4Vy6kk1mIBLLIiybf3SHOi/g/CwyH3ume6tfKROJs8GAFtxSPxo7tkvc5AGW6cWcFHgt1oU+7tvVFaqCDMrQUd3t4kT/4PfvcH3XtcvpLNdZEIOlyc1EuqfSOnWOeiPAVST4wDM2neVFymEVdgL4L6hEcadnZ572wMoBN2utqDjkr9qFiEGjuajWnXOFXLvsHh3BSDMztB4j+F99j0Fqvzk8H646nLLGwliTQY14ADaEGwWeIh3wGgxycmydGI1w/Zp5Z847TSDWAn2yzUoI3qiw94YvATGDIzZlLczE3OBgdVkInvzBlh4ugbwWYjnJicax/B+1NV8/Xx2j3x+3kkt7L1xs0OLFGk5xkc2BAxuiuceeRUr0mxLbTACdVnECF+kbbJj+1zcj/F/dKwjtdUDCBDapCpHaHCbKaryJSpwHyoiyKDbXhaTdQ0hu3P+XoZcvvcyw+yPebIcHJm8bBV20WT8zLgE1eu2qgZO4WzSbYPd7RtzQGmdBUgRHC74CIZs6lXzs+Dq1AKDcC9IogxpSA6CKUTh5J/kBJueYnGmkpGgRYAHiFcnG79Ee+cXo0EhRTDNlj1fskT3SfRnBpmgDq4AEx2c45XKjyikiMA+Ky1+SX0u3169vukpWIUdL1KgdmUfqTyog2wAjrvo57s6Bb6T5Ehm/8w1F8ZU97jg0BRZjp4LkImmUTEPX/fsN3Toi5K1qHRj6YTo0WW0DWcQIuJk2Vn/3DQT5smF5q28u4FbYz1LdD4wXg6ZGfANxjhu5SDWj1FHdCrjzzah42DMMnwjmWgJU7qAf+k0Eew9w4yg
 ZqOojEFY
 4CKg21KlojlSqpF0EMa+8b7SRjqc3XI0vh2apJDS+2dm56edk8anmDCPpDbvRm4Qn7twa06mc1Mgf7toVQZ0D4ZpXrEGSNjWR65Z3/YHXphHaoEHkKJreOl5k8bJk0Iz7jK1ATlB1fJwx9mhD98lr5sOKNeETBWGJDNHKCmt990Bn01KmgJAtSgp9OPhHTKrGxoEY4MB37A5KvO3e95wp0KG1RfVOvCbLqXz/gFRyVWpFRyF6vZ/WOtvf2YdEEvhwEMsqSt3Md65mBFZmTeuD4qK42kqaoBzENH67A19Rdpq3l21HJBavCLYOFjEaRC64P0j0F4Yd7l/5RKOy/N9QU+K4HxQs8QUHARk3/O/hnABsCUwI3kv7KIssstGn35LaCJSkTrnzsMhZpoKpYj4omkxqlhx+tPqgQGd1fWIFh4lL7TDN6WEzhEtmqjmEB6vKwdWmgYPE9B5pJcfmg/zLWdLtcmQc5atBPGwEUAzVoAamiZ8KkSyDnJ5URoJwVbb9xlqLNvIhWFxlBW0jhWYCMgANQv1vwKt7N8otNPV9LpQnbkWgRyWhcP9wevT9WF+14NIQ0h68vp3zgULMouJH6TyPiCFq7X7YKiNkhXWD41z8Ml71J1x/IMiA/L5vGSFOeoSftppLblCi/6E1VmqgBDy3dorBn8JF3QyZ+JlhPy96VJfSkj6ehEmcNFNkr15E7C6YTVtZ3jQqe+svzib9iQXke2mIyGl0dgIW9vUjrPZ+oO07VUXYXqj2eURMemaes1XbJ3IBoDeH2vjIWt4D6X3lzl0VlG6fots16xB290x/7Ev1vHnjiJROvzB6eDFOTP0W5pydnDsIt2iICl6fjXfowt8O9E/7wS0eiy52FP8kpIL3SfqxtNaC20FWcnjw5pBsUkqZiv4y7/f6gtPC8ofdkYCoCOdORuG3+WPJA38XyZR5m8fBhLfQ7vYq+coUag5VRyVTRd58X+TYowTcvza8PLa4
 DKJhkFPn
 Tvh1qhLyt3/0XMbEwjn5fm3utSE+POTxSWeY8qTXdyH+KiwkQ6ttn35SANdRybDqT8wZZ4+PBr2ui0LScIvDEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
https://lore.kernel.org/all/20251014093124.300012-1-hao.ge@linux.dev
* [PATCH] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags

and found the following issue:
general protection fault in percpu_ref_get_many

Full report is available here:
https://ci.syzbot.org/series/6fd66120-211f-479f-b6a1-35f990da2dc2

***

general protection fault in percpu_ref_get_many

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/74de5bb7-695b-4115-9a4b-ee7d7fd0cca2/config

Oops: general protection fault, probably for non-canonical address 0xdffffc00177780ff: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x00000000bbbc07f8-0x00000000bbbc07ff]
CPU: 1 UID: 0 PID: 6155 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:percpu_ref_get_many+0x8d/0x140
Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2b 6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 refill_obj_stock+0x254/0x850
 __memcg_slab_free_hook+0x123/0x3b0
 kfree+0x3f7/0x6d0
 kobject_uevent_env+0x361/0x8c0
 netdev_queue_update_kobjects+0x346/0x6c0
 netdev_register_kobject+0x258/0x310
 register_netdevice+0x126c/0x1ae0
 __ip_tunnel_create+0x3e7/0x560
 ip_tunnel_init_net+0x2ba/0x800
 ops_init+0x35c/0x5c0
 setup_net+0xfe/0x320
 copy_net_ns+0x34e/0x4e0
 create_new_namespaces+0x3f3/0x720
 unshare_nsproxy_namespaces+0x11c/0x170
 ksys_unshare+0x4c8/0x8c0
 __x64_sys_unshare+0x38/0x50
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f85c81906c7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe57c0ca58 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f85c81906c7
RDX: 00007f85c818eec9 RSI: 00007ffe57c0ca20 RDI: 0000000040000000
RBP: 00007ffe57c0cac0 R08: 00007f85c83a69d0 R09: 00007f85c83a69d0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe57c0cac0
R13: 00007ffe57c0cac8 R14: 0000000000000009 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:percpu_ref_get_many+0x8d/0x140
Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2b 6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

