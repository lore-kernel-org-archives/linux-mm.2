Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A1FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A686B00AF; Wed,  3 Jun 2026 17:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011D76B00B0; Wed,  3 Jun 2026 17:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69C26B00B1; Wed,  3 Jun 2026 17:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D12F06B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:56:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FC628FB57
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:56:28 +0000 (UTC)
X-FDA: 84839960856.22.670FB4E
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf27.hostedemail.com (Postfix) with ESMTP id B90C24000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:56:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3CaMgagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3CaMgagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780523786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=y1YKQ72F+SqhcZBrev9pMOW1rdhh9BcLNctDSJfFhRw=;
	b=38vqAFOjsOjvWHXkcV6eM0Z+i7Nh2HhKDDR+m72KR5fFR2s2721hved/h2a8mdWiBrPw0c
	cp7tlvF+rR2A901ZE5LAzttPBR1YqBY0vpM9bBRUIctFj6wbIAVclZN9TDswZ1dnqVRNk+
	sfRghLjoGwEhXHuGv+as+013is6a3+Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3CaMgagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3CaMgagkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780523786;
	b=AlOcnBgtl1GtvbTt3sh5eSqKXKPbrXtm2gySbQpmKqNbGmJuCon59C3ojFdjer9yj8YnRD
	ikP+VJFUjlnDq1pxfDpAstO5DJnd8FrgqOJdc5jnblAdok15Iec/dO367CdzsVUrz5L8EN
	4ZvkEteG1i61KEyhFxgAjDiDwnlmnT0=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-69d92a86e3bso56664eaf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780523786; x=1781128586;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1YKQ72F+SqhcZBrev9pMOW1rdhh9BcLNctDSJfFhRw=;
        b=E83U/Qk4t1CKmkypCBhvrM89TOd+0fYLj9ot2AsoxOjgkPHrN9igJN6OkQHWvf2tXA
         3hdoGsdjlwDA5nMeCLYhOR97GEBqNlzp/DeNJAYZpImc7YDsqvIGrMJUe2beadkXt9yI
         04S/ZWP9/knOLPXpfDQ4d2o5fC7dcBUSxh7EgHTzaMo2glmEaFS853W0xSbhQQYUqanO
         CJ5m+dEcc6Pc12tw4yFKijnsxpv4+HCk6lP+iHPTv+10Za3WWYbfAC5MIjimCVL0ghub
         Ari3HFlKFLhWp7EAQSCd5KOrWOPgZNCYQPJhIDRapmiTKIxNehFDmdXCJ+rA4KG75f2f
         I2FQ==
X-Forwarded-Encrypted: i=1; AFNElJ82BLqHttf+Id4NeUOIwHzkAqhIHCHjVx7A4Dz4e9BsWWB5lT9IgU6udaPGYZmTxnfwL1B11TF/UA==@kvack.org
X-Gm-Message-State: AOJu0YzdVc3alXABuRabNYf9XExSNOmuE4yjJ3cRo9NcyD6VF3Gibc69
	VEiWtecL3dZTZRpVuI7rTSmU6bN1K8mXKG9BvYb+PBLH3B5fizii5U8ZXN3txH5MoR49ZYo1IZa
	YqZlWLrgBIcLjnd86RuOSfM3bap2spxiM2AYI5EdXOFL/ONsRUYlNeN0TrnI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:569a:b0:699:b198:c278 with SMTP id
 006d021491bc7-69e47ea0885mr2419090eaf.13.1780523785708; Wed, 03 Jun 2026
 14:56:25 -0700 (PDT)
Date: Wed, 03 Jun 2026 14:56:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a20a309.85ccb786.283107.0005.GAE@google.com>
Subject: [syzbot] [mm?] linux-next test error: kernel BUG in post_alloc_hook
From: syzbot <syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-next@vger.kernel.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, sfr@canb.auug.org.au, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B90C24000C
X-Rspam-User: 
X-Stat-Signature: yfis5nkyimmdams19nkaqteuxztwhqkz
X-Rspamd-Server: rspam09
X-HE-Tag: 1780523786-988377
X-HE-Meta: U2FsdGVkX1+M2FJwVpoxeFmxbWx+D6I/k0UnPkxLCvDCb1gOKDhvnQtonnwg2ftaZbmFeNLV7WHSdbhBwJ2sVCMsCdIabJ9jKjJnnn7LbdGLdgdplC0DRnH74waVxoP5irou0vbc9dDYLtwHJOQUzlM3lzU3A5jsfExeTHZDmOIzezPFojIYzFb+pPAaZQljKVQJ4KtMzDTxVLtMOKy2mweNa/M/tL64AIEyad8UQahGExSPq2so6sCHeDVvZx63AzU8qRS6+P6HxSxwXxDo+1g0cACjfHeenrV2DjP6V/bCOeUF/fh6Iu5ZvZZtOBbpVEzbqztFP77+/oz5OtObhLiSIY7AgCY32ta+AZHMLMrqp9A3ARC7+AZJYwV+Vj4RhcPK6rA87gJne0yVvsn3kE6H6U3afgdfh1dShPhsv48MMB5MoU6xYFOy0pob2ZY2kmz7vU1bb7jl32LBHhZzxm7fpRRu6hCB1dkxP6ed4LrerOul4eKyPQAktkp6css0yYJQS56DxVA5g66z02UuhFVC9lGBdUEc5sT1lZdSaMSpD/rOY1lm+odqGHXIrb6rUfFjCPJn5Gkv+wFaNl2C2wkCDcW7+8pz3b4WU9NT0pHrmq2B9BGH5wQFb5hVM/4rOk3Tq+VCMPjpw7xdWHI15v2qKa6avOMmqiTfhQhFlTTNEUwchDwhtTuMac0ZKtQ3R7xrFV1v9RPCLTIKIAWukjnJNuKo9QvV58GedDmaMOys9p4ArT+WbsJw+Wob85Zy1jVUinYTkSOOy/0KWOMM3i/86d535vY7jKLZbLRVXXdiFWvmjvb3bVMoXFYyDSTnSx25Rt5JmT1lrusBN3/3EZ7wNrxSL3Szsgw1BhIGVcKTk8FQceKOIX7sXcmDmmpiSihSxHK2ETsuyUoukK6wJYRYUChv6aZFEMef/lt6Dq0PEZm5VQ41llv8i6X3eeAcTS2zyTfVgjTYBsEJ1mi
 hWJyJWkI
 1F8HgoDeq6UfZQfJYUTynmvetKaymc8SU0JfaVWczcXRKZ7JdFqIkdmJT0CC7Np5qbjLCWyGtth66DYVnxnnNtEJVM++l5aBmt3O3SYse2R13C1pW2a4/rnseBN1Ziuuyz/nXkpg1BvKHiDN+Q3SN0LWgwBRZHIIhKu7KR+mrp48pL/pzzCMK/01xsVlH1LzP6/MgFBy01TTymPtaQVK60jaAYXmD+DBV69dlt6DQeH5E5A8HPadqFSzngQUHOHQ9BMDuNV0FUz2B7Eq0slQ3tnxqh+sISvHBwzXGdmrLNbY17e/fNNzSh+eZk64NvEbNyZRxgscQTsD4hGufK59L27/ev62Zh8kLZw3JiJtJig9zMUA5vyICnHNrpEPtFUQ6Jk/WkjwPVgSHpOs0D5sgnuOba28d9104yP57TFDy2J/wzXm5/qCP9O+iOqFu/BsgoyXX/6UlE4+WEttCSTAbrcgIO9sD23Qmw9cO1YzMb9raikTTGYfjroBusbxKEBQV/vxI1iFVi8uzGt/eE+D6t6qZchvUEUASVUz6rJAOhNc4sf/pjXWtfUZEif6CPoZYAurb40XDI/ZnymmhtZ0RBTXSwc71oGKXTKY3Yc1CVW+90B3ZBRFcam2L1yn3PJxiG03X91rBuwYQtmlGEYU0PcAAbMtaNT3C//0Ue0BNpCCMxZiucgyxILpxH0h8jrJvi+uf8t7e4JBekZ4/TW+6LzHsLcoqQsjwhh0qig+EPFRThiqpLNf5bx2juWVbYI7yF8JgTVYzzQlpnl04exV9a797gNEcdp2+KRZ7wmRy8YiG98YbciEw43M4u0xjT/oY4qZtc0VUfxf2bsV0wVVsyMWrUUstB994skvz94LV6dnV1/4vW2quX5EOTlOBQJ50QDal54XOSKr9BphYI3yJGS5ETsan3mG5BgDab6T2iOyDl4EUgLu362WiQL0wsjRGeTrp+8aFY7xhUDVUFrw0RAsKH2pf
 DqS4VBJo
 P8MtvUyCThopZlwdeao1PMw0GoQmjtXuk970KDh3og/wedIbOdEuEGxFBVoPspIbQ3sKYgcB++TdkeOrUBjmPwqoznNjCbVaElhBf17EQNxNXZHRZU1wyBKjBOJuf2/fditfHRiCF/3NCsKLFM8D8If64aDLBw5JJwhdu8EWUVpSGf/jfahCEkX/hEE0f77KfFBnxBkqM9ERnKdrmnDlySEyZQknXydx93yKK/Jufhy/wHsJqEgCJYdAl6JyjNguwl48wjJL+4gK0GtCSDb1Xtqm0LXIOIIbdR2/YgfFBuLyjeygY0wzVCmpO69y4mtbe591t/Y5BKjfg26Hb/AjR/J7FVUTWcKYCLjcRGC1QQSwZHN5jXZ6pQATs/FqDarpSiWdalgyMa8dzOaDodBvUJ51jfYfvcasjcIm3VIB+oqn7wl0Pv6qEHQGMcvn76M78/OBYlnpQ9tQIAGDdYUGsAkCXaQOfN09tRJAV3FabE09wG6Rz5lvbXPo/Sb/X2eYdfLIeKT9rxv80jVNAumeK1CHHaMCzQidsvy+cbkxkpy84NN8Txi8kresZR67bk4kBW1HjqO8PPSzDqqWakBM20Ci89v4f9ZCUPzQ+dmqJ4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    a225caacc365 Add linux-next specific files for 20260603
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=3D13b0de66580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D717edf2a5f9fc39=
0
dashboard link: https://syzkaller.appspot.com/bug?extid=3D8ffca916f3fa5455f=
9b4
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f799d07ea17d/disk-=
a225caac.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72d0f0ff94e6/vmlinux-=
a225caac.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99d4279e6fec/bzI=
mage-a225caac.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+8ffca916f3fa5455f9b4@syzkaller.appspotmail.com

Initmem setup node 1 [mem 0x0000000140001000-0x000000023fffffff]
On node 0, zone DMA: 1 pages in unavailable ranges
On node 0, zone DMA: 97 pages in unavailable ranges
On node 0, zone Normal: 3 pages in unavailable ranges
setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
percpu: Embedded 71 pages/cpu s253896 r8192 d28728 u1048576
pcpu-alloc: s253896 r8192 d28728 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 1=20
kvm-guest: PV spinlocks enabled
PV qspinlock hash table entries: 256 (order: 0, 4096 bytes, linear)
Kernel command line: earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.hun=
g_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D2000=
0 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-conntra=
ck-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D0 =
rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_point=
ers page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_huge=
pages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allow_=
writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsysc=
all=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disable=
=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2,1=
,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,=
1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32 s=
mp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thresh=
=3D140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=
=3D32 max_loop=3D32 nbds_max=3D32 \
Kernel command line: comedi.comedi_num_legacy_minors=3D4 panic_on_warn=3D1 =
BOOT_IMAGE=3D/boot/bzImage root=3D/dev/sda1 console=3DttyS0
Unknown kernel command line parameters "nbds_max=3D32", will be passed to u=
ser space.
random: crng init done
printk: log buffer data + meta data: 262144 + 917504 =3D 1179648 bytes
software IO TLB: area num 2.
Fallback order for Node 0: 0 1=20
Fallback order for Node 1: 1 0=20
Built 2 zonelists, mobility grouping on.  Total pages: 2097051
Policy zone: Normal
mem auto-init: stack:all(zero), heap alloc:on, heap free:off
stackdepot: allocating hash table via alloc_large_system_hash
stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear)
stackdepot: allocating space for 8192 stack pools via memblock
**********************************************************
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**                                                      **
** This system shows unhashed kernel memory addresses   **
** via the console, logs, and other interfaces. This    **
** might reduce the security of your system.            **
**                                                      **
** If you see this message and you are not debugging    **
** the kernel, report this immediately to your system   **
** administrator!                                       **
**                                                      **
** Use hash_pointers=3Dalways to force this mode off      **
**                                                      **
**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
**********************************************************
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13fe38
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x100000000000040(head|node=3D0|zone=3D2)
raw: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
head: 0100000000000040 dead000000000100 dead000000000122 0000000000000000
head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
head: 0100000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
------------[ cut here ]------------
kernel BUG at ./include/linux/page-flags.h:682!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT_{RT,(un=
def)}=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 05/09/2026
RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863
Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 =
fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 4=
4 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0
Call Trace:
 <TASK>
 prep_new_page mm/page_alloc.c:1925 [inline]
 get_page_from_freelist+0x3081/0x3320 mm/page_alloc.c:4015
 __alloc_frozen_pages_noprof+0x194/0x380 mm/page_alloc.c:5376
 __alloc_pages_mpol+0xe0/0x390 mm/mempolicy.c:2495
 alloc_slab_page mm/slub.c:3287 [inline]
 allocate_slab+0x83/0x5e0 mm/slub.c:3404
 new_slab mm/slub.c:3447 [inline]
 ___slab_alloc+0x160/0x930 mm/slub.c:4485
 __slab_alloc_node mm/slub.c:4549 [inline]
 slab_alloc_node mm/slub.c:4925 [inline]
 __do_kmalloc_node mm/slub.c:5331 [inline]
 __kmalloc_noprof+0x140/0x7b0 mm/slub.c:5345
 _kmalloc_noprof include/linux/slab.h:973 [inline]
 _kzalloc_noprof include/linux/slab.h:1286 [inline]
 __alloc_empty_sheaf mm/slub.c:2774 [inline]
 alloc_empty_sheaf mm/slub.c:2794 [inline]
 init_percpu_sheaves mm/slub.c:7555 [inline]
 do_kmem_cache_create+0x8ae/0x9a0 mm/slub.c:8595
 create_boot_cache+0xbf/0x120 mm/slab_common.c:717
 create_kmalloc_cache+0x41/0xb0 mm/slab_common.c:735
 new_kmalloc_cache+0xd4/0x180 mm/slab_common.c:982
 create_kmalloc_caches+0x14/0x50 mm/slab_common.c:1005
 kmem_cache_init+0x14a/0x1e0 mm/slub.c:8496
 mm_core_init+0x7e/0xb0 mm/mm_init.c:2728
 start_kernel+0x162/0x3e0 init/main.c:1034
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x157
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ClearPagePrezeroed include/linux/page-flags.h:682 [inline]
RIP: 0010:post_alloc_hook+0x287/0x310 mm/page_alloc.c:1863
Code: ff ff 89 da be 01 00 00 00 48 c7 c7 40 50 4f 8e e8 ce 4b d4 02 e9 c5 =
fe ff ff 4c 89 ef 48 c7 c6 40 ef 7a 8b e8 2a c6 05 ff 90 <0f> 0b 31 ed f7 4=
4 24 04 00 01 00 00 0f 84 8e fd ff ff e9 86 fd ff
RSP: 0000:ffffffff8e0078e0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8e0fef40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10170c4903 R12: dffffc0000000000
R13: ffffea0004ff8e00 R14: 1ffffd40009ff1c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125a79000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e1b8000 CR4: 00000000000100b0


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

