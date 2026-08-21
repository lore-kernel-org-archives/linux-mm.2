Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35954C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FE36B009B; Fri, 21 Aug 2026 12:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7D46B009D; Fri, 21 Aug 2026 12:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE276B009F; Fri, 21 Aug 2026 12:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEDDE6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:57:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8425114018F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:57:37 +0000 (UTC)
X-FDA: 85125882954.30.9EC7BBF
Received: from mail-oi2-f2.google.com (mail-oi2-f2.google.com [74.125.231.194])
	by imf28.hostedemail.com (Postfix) with ESMTP id C46A0C0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:57:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3foOIagkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.194 as permitted sender) smtp.mailfrom=3foOIagkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787331455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Lk+KPE4O52Ld5IPp84hUSFU1LFd3FsfSNj5Q6uVv6A0=;
	b=6FbbiPghQDmbfFRy7i++dwVRlaKPUO75jwLM3wkcsyGEqp4GuaxXuTqpBKsgyW2tb85lNC
	IZ/7gaeVPac9UmbDtEBXljhgXLWrPdAg+Qr1wAwvmASc31uNalmKnuvTB45qBPUfsN2G95
	fUrVH+JNHZIHx9wEM/jThhJ7YN/cTXc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3foOIagkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.194 as permitted sender) smtp.mailfrom=3foOIagkbAAMv12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787331455;
	b=FUBgIrZI1LZpA5G2jqkocW80rZwb+2LoIt+/Rf69kxaugl/VIYXD/wdSmZzsX6auYXOzqW
	i/Y2t/wQfyszuwjo1P4rZgraXn8HzzwBWXIYtCwWha+nMiEIH86JFehqImP7xWVNVoe7b3
	mu80k5jp45JQ2snGLNBPUX4+WMKqH70=
Received: by mail-oi2-f2.google.com with SMTP id 5614622812f47-495d5d27acfso551913b6e.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787331455; x=1787936255;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lk+KPE4O52Ld5IPp84hUSFU1LFd3FsfSNj5Q6uVv6A0=;
        b=MpeayV9ovFd6U45ngvSfkEtTXeJDx4IeiH5Ey5EELK3K061BWYiOhif7Cde9i5AT22
         EfoXMm/hly+wtrNH+cY8msFrGy2JxYS0XzT9ssiRTRAe2DjHoQrhxmD93yxzvLQ+TyZR
         KBs3x5WDt7tOC+ZpJdluSQC1JTO6cd+iC7Yxm3jKRKw2r0ukXrvWPHHQLGYlw/8+zV5N
         Kvh/Y10gzhp+I8Qy1cpYVpj+QToGndvd9V318nPIOBxCf9iOB39umm0BKvciTOEy0F/g
         EmPZWqbfrhln2r59s9z+T5l6PTcfAuVs/h/BGGOrCHIE16B/cq6iM7+9QNcV3w5IIQo1
         OuPg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6Hz1sDMyWWUYwhfX25ykkXuv5euP2A7sFLlNumhxnZFeUKIMRuAnFNH0Eai3F26Qn5So0sK5+3w==@kvack.org
X-Gm-Message-State: AOJu0Yyody06K1jVjXBkhVrlsJCLuCBa+mZj0M7S0QlmByZ1b+8WSfPL
	6lMUl7tfoX7owzhQZZAkJA0YbPDmsg9akfgiDyJC57xcPRDWIW9r/zDVib+VUVw7cf3Yj0sk/iB
	jDgV34SlamLkz7jbe09j2ntjTKE26t7HfbYTcevsbjDDBWInzPqa5GWKIx98=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:138c:b0:4b2:8d9e:de11 with SMTP id
 5614622812f47-4b2ef439a80mr7776113b6e.19.1787331454770; Fri, 21 Aug 2026
 09:57:34 -0700 (PDT)
Date: Fri, 21 Aug 2026 09:57:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a88837e.ae6ddae5.3da009.0040.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in bucket_table_alloc
From: syzbot <syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: jk33j15mb9cudh7xyf6rk8g95zyx5org
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C46A0C0006
X-HE-Tag: 1787331455-556035
X-HE-Meta: U2FsdGVkX1+kqwxLHt69oh3m4O1DhzVkDz52oqAC8Y4SotfX3FSZIlAqFcS9Eso87fn0PmvaBzMjqf5uFebBn9QTxfBOzrKTqvfI6jhdtwlf5idnpQxLndkKMkpL1FTUFz7HG4bAWW0WlCr5a1lNSp301r4V3GTXcLriKPIiZkj/hpBd3DlV1umTcqAZnR04Gcczi0cw0nw7BcIdhua4Kw9oH/Kd6/evdNKxbrZ94KxfIlncExgQdj+R9sjayb7dGoqAlQvBCL3z4xzOrfIR9+AXKGkNatlBks9iReI3pkaUNo2ouQNERPD3I3GzT2FmG5cR8mS934zpIvn0V08Ua8TvgrCLDtKCn2O+UnA4vAmoO14BtG7TBPILC0cOQUuL+mORzfCxVcO1zZVPkH8sOkMqZO6kdklmTZPr3tPSodo/ANiU0MIKthEgM/ykHN1BLfoM1U8u87YaqpBMWLOyPpzQC/BOcG7Cu6scOlmnUhmMWiLUyt9nJ+SdHkmg7NTqBw5lgO3Op9Ci1sISBss+ab8dK8jAzAqbPrXY4Todvxow3166bHQl4bwSWfNwqmN3RU0kO9bxpgnrGN6oqQNqe2RC/UdAZQwAf1++KDd1RAmH/rmhrFUNilaM9dufi1CivyQGRiPjpogcBKDTj+CkvP98XjLBDNO5vuQc+9UmYaF7IG07ue5LkiDNzgdF/Y/xc6aCnmBWIOMA4UJUeBoIBNL9o/w3608Ruc0K0G2FPgfUp910jXVxJM3YBn2nrmyFw6HQMhYHCUY+TOULCgnR0bmtu7/2LWfCJaejOjEvZY+pbgRb/4uZ83S7DFcmZcfIgckrcVx+s2QGUNZi4FljB86zh0kErq1ZU2rxoFoLIJxBcLOKZ1bhtDPW095CDr1UPe/xtMFdY6r/lBaGUDlNP5Iq3EF0CZFBLfS2ubHawA39x0tvA0nFGaylPCfy+ijXGwX66i9TytiGM4h0dYn
 g98PIf38
 j5JTSLla/wS71imGXdLD4TbUwt/hagAmtOVLkqbAoe+NK0bAEL4kz9gFOVLPbBE4uvucnEV5behXd7SLrdsFt6qkmRCQ/6bHGNvf9nOMgezzLgl4LZMW/5XqEoXofOSz65BrgQ6Ynx7w6ZVLVWYrimlYQ/tIKHxsJVfEmv8kHKgEagQsMa1BdE9FgEajHCCqUULBctcEQMMq/4N8baajKjuLln6ZhtnMe2BPT5lX8XYSEht9get0t1NnFdpSK9o4whUtIyj+KyoZfT8bJZIis2kRT6tFQo+DpGP1T8W1CnhISuuR4ndHtQVQhOA4bAHPNKcbdrY3uI+jlXWC4n8xvQhEJ8/6ETYGJyrrmuOb1oSNMbuekVXfgQFBLBGC2KBVSXLreeGUVKRiHCV9DYRs31JsBfdeeNIBXbAhw2pSvMslpRNidpe4bVVx2ASChgzWZ1RuhSup65Y7+zvHf9KgQIEE8YtWsWaE46iSIwKIKMwQz3Xs7uhejoNOG/6nEu/SBwADGnL7c9sRMdbFTGab6ESuKDXn2V3+6F/O1M+WU3kevkcTmdFF+jQxpY81vNb0H0cRq92G80laEH3dnzyAJMUGOfo0rpFGXhHB/T43NyQHHyXHe1yq0AyWx6AigcbP2f6NTi1THQJnV7mx3nnU1P/l/+JOprb18+6xlzf7ofo7Fn2q0TamncA2/Bn1bI/1TjZ5/3ShVRWh3C/6umMbHXFONQMgsMbwkVbif4JeCKm46dAxwo5MNHR/Bh9SeA8ZvdqZvGoftR+pKuv6JI5gMajDuvByNWyMtGLrbQHvAQCsBQHgZTeSdwPa0EGiSpnt1bXjZUILGmOI09aR8QM7EzuPafXanGNVL+jKjg0EJkrILpnffMZp8ZpW0Q1F3wMnozbSTt/zAyOOdTBuxbB/ormExCWMmh2PDLQwXKWRa3cxM+nGnIrY31GkEo8UXVzXZA8aPLLW7YrQbNU7wwRdh2fpYDbbF
 6+V1cFPH
 kSq96pVIpd4hffuBtiXQhxBU0CLKUCILSdC+mxPHyMx/6Vk+1vm275q7M/EeZyXjQrqDE26FnY8TaY9j1QfjCTCrtJRAaXLEgLRiWCuu535uxwyMgMRKCbq0+Div1kntHHQqQJX57VBhHi+cObgfMWuh9r19qBskO39y5D54bnr/syt+H3h+VQhKc/SoSzQZr2lMnZDzYRMeA6AFrqL11LZpxgkU4Jqqb0k4+I/Im46A04QoZDH+YbGInarbcgIlbQIziB9akD83VgBE5qCq4kYni50tzNqcCp4OVcN+P4uHOI82ye7qLpGFwMwzQ+Cn5NtR0e8HYoZ22Qfqckakpyb4C3s79MOAbeYyuLDRHt7c6mnTs2uMGok1R5gXL9ejwK9g/hS+0YeMV7C29g4KuIkHuY1ooZP3bsElC/K/uyN22YVh3aXyHxtvhRESPCJiOp6Z1dTKSZoj7ZM2J6QDLT95gI+G/g0GC9PJVCyMRRR4dhrRz+oLfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7079a12d7506 Add linux-next specific files for 20260820
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=119afa25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aa9dec010c9e69a7
dashboard link: https://syzkaller.appspot.com/bug?extid=0dbf6d295b3350944f0b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9682e92d9ec7/disk-7079a12d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/829f3c29b6e1/vmlinux-7079a12d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2e0cdd08b0f5/bzImage-7079a12d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:322
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 15133, name: syz.6.1501
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by syz.6.1501/15133: 2, last CPU#1:
 #0: ffffffff90250500 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff90250500 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x767/0xc00 net/core/rtnetlink.c:7138
 #1: ffffffff8ed5ca60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffffff8ed5ca60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffffff8ed5ca60 (rcu_read_lock){....}-{1:3}, at: rhashtable_insert_slow+0x1cf/0x2000 lib/rhashtable.c:683
CPU: 1 UID: 0 PID: 15133 Comm: syz.6.1501 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x36a/0x4c0 kernel/sched/core.c:9236
 might_alloc include/linux/sched/mm.h:322 [inline]
 slab_pre_alloc_hook mm/slub.c:4636 [inline]
 slab_alloc_node mm/slub.c:4974 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0xef/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 alloc_pages_bulk_weighted_interleave mm/mempolicy.c:2682 [inline]
 alloc_pages_bulk_mempolicy_noprof+0xaef/0x1690 mm/mempolicy.c:2785
 vm_area_alloc_pages mm/vmalloc.c:3736 [inline]
 __vmalloc_area_node mm/vmalloc.c:3914 [inline]
 __vmalloc_node_range_noprof+0xa0a/0x1540 mm/vmalloc.c:4104
 __vmalloc_node_noprof mm/vmalloc.c:4165 [inline]
 __vmalloc_area_node mm/vmalloc.c:3890 [inline]
 __vmalloc_node_range_noprof+0x58b/0x1540 mm/vmalloc.c:4104
 __kvmalloc_node_noprof+0x5a1/0x820 mm/slub.c:7033
 bucket_table_alloc+0x75/0x380 lib/rhashtable.c:197
 rhashtable_insert_rehash lib/rhashtable.c:503 [inline]
 rhashtable_try_insert lib/rhashtable.c:671 [inline]
 rhashtable_insert_slow+0x1c66/0x2000 lib/rhashtable.c:684
 __rhashtable_insert_fast include/linux/rhashtable.h:789 [inline]
 rhashtable_lookup_insert_fast include/linux/rhashtable.h:966 [inline]
 vxlan_vni_add drivers/net/vxlan/vxlan_vnifilter.c:744 [inline]
 vxlan_vni_add_del drivers/net/vxlan/vxlan_vnifilter.c:824 [inline]
 vxlan_process_vni_filter drivers/net/vxlan/vxlan_vnifilter.c:891 [inline]
 vxlan_vnifilter_process+0x357a/0x4d40 drivers/net/vxlan/vxlan_vnifilter.c:973
 rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7141
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802


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

