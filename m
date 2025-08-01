Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F811C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D776B008A; Fri,  1 Aug 2025 06:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115046B008C; Fri,  1 Aug 2025 06:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052016B0092; Fri,  1 Aug 2025 06:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2A456B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:08:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8629F5B610
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:08:38 +0000 (UTC)
X-FDA: 83727764316.12.BE99D5D
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf09.hostedemail.com (Postfix) with ESMTP id CAB0C140003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:08:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3I5KMaAkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3I5KMaAkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754042916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=7w7rtn71IA3v6fWvnpRTNyOOQWiNby/MER9Gaoys718=;
	b=I3Q4MP6xVAGQYiK0I+9PskgZvbreG4Agiiw3VCGq11rGZWjbSJmnTqWg0PiGy9YR7RIT6J
	D/7f/4H9J5l/47VES+jxftZ18qNXqfDhKFgzr+8rLxtE1Dgfi5gYKeTimyA2/82UP0pRqx
	QoWhlx3n/X/yAfGrMwVJxcU/afEbjuA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3I5KMaAkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3I5KMaAkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754042916; a=rsa-sha256;
	cv=none;
	b=ncDwcpMveHJwep5XtfSNiqFd7zzhrLL6RNS3jjz3gdlf0SGh/eIvPIwxv4ykzfg18JG4OM
	9PkDizutb3uXdh0krxA/MCx2bIBZUruyNZLu1mXyFdAOwzREKaxH0OPQl5txXH9LUEN6xA
	BhL81o+nEFjS5Ab3OvCTCsdgPPqEOgQ=
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-87c7aacf746so107335039f.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 03:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754042916; x=1754647716;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7w7rtn71IA3v6fWvnpRTNyOOQWiNby/MER9Gaoys718=;
        b=n606SgewOLEK/q26Z7c5aBrZwN9AuiW1TJnnP2ABEDdJMtiIVTfF7Ad1Z0p4g//Yta
         wl0Dvki81Jvt0NgmNNGZpsb0NHExwTAa2lVO34leba3/vPx0ZtXkGEmDEQTeGhPMw255
         Vk3fKLGAEFob35/nQSgpcB6i2z78OrzyYFh02WA53HWECas7snsT3mMMWhMh8Vxhy8fe
         +OcUgat51gaUviSZdXmJTvV2mPxE2C7wQStqt63PEuY8uW5FsZc9rZSlylqNdGwNzLWj
         o5se8wToXnSgP0CDcKbijy5g3frkxcD5U988PVVM3eISi03gNd3SZibdSy22Ydjk2634
         YEVw==
X-Forwarded-Encrypted: i=1; AJvYcCUodDuQaIUa6CU+IYYGW8TTP0C8QTY0ehpxlWT2iVB+G8yTnnHAyv3S0ZqeDifqMsQynmnQt4e3pg==@kvack.org
X-Gm-Message-State: AOJu0Yx64wAPIIQ8uwSWw2TxxdocIU2NWcSgR08K6ciTJuhaDDcYvUJ6
	Nexwr8sFKXfMBe7/uy9HVh9qatymvQoiCxxKMnz13uY6mDlXJ56d/HqlSoS5s//Hb6KP+WP7iaj
	i4dQFxr5StBXo2hgl10El8KEfZatPsN2XLy7T1HQCu/cBLs0O+adx+rRdhvk=
X-Google-Smtp-Source: AGHT+IEcCOZ1M5lbEw3vt0apHj5RxEq0/i9/RDLxOMwkyUCYyuVOVJgI+Nmoj/lU+criLegiKyakG8fk/nWWAYPgvsN+vbwhBNEW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178d:b0:3e3:fd04:5768 with SMTP id
 e9e14a558f8ab-3e40d65443cmr40280935ab.5.1754042915829; Fri, 01 Aug 2025
 03:08:35 -0700 (PDT)
Date: Fri, 01 Aug 2025 03:08:35 -0700
In-Reply-To: <688b8332.a00a0220.26d0e1.0044.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688c9223.a00a0220.26d0e1.0068.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in trace_suspend_resume
From: syzbot <syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andrii@kernel.org, 
	ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CAB0C140003
X-Rspamd-Server: rspam06
X-Stat-Signature: 9b5ifupti8hfgbs9bq33ab59qdsy9nct
X-HE-Tag: 1754042916-888800
X-HE-Meta: U2FsdGVkX19/1BN7qqiNboWMLMsJR1rvDHTMrvBAE0AyQzJvcFsNMtnFRmfmm3OD9rCHrU3LJ9l3tWtKgraZcXUd7WUetiDGBcNmHnNMEofLwZHv71NvS2QMt22jSeaScEuwcUlR/xB6uSrwoIX/aBPnsaxcarG1SgfdSS0UnTDrD89njezCaPxzeHaQXI3xkEkBRnrAp6QbhtTszyv4D2yBOtrxY2tB7I+gx4Q1hls3rkDowo1QQIBJSQaYBmLMZ1WsKPsIqDtcNylDtT+WLSOS1QUadjcmyYXogVTn2XiYNy7Jleoz6VkfI67E61INR9mz1Ovf8CDqL0Ca0UlWC461wpbWHY+IjOjG+eOCMjzitlvK1eFruw2GePrLvjVH6cIfYT/fbC2Lq13fVhaB+TFcu/r+1dwFUJk4+gHEXcaHp3UeQli8oPwqA75pMAUj+PbJKfwdRHvQfPvuN94Fd43O7F4VRGt38ryC/41r8y2ate0UfLyvxUSndz9PdBQSHVCA4KDbYeXb1vdyTjxCQCxIMYHCG/qbq4A2+OvVv7lY7d+VPbb0PRAZtE1R39EKP+Xnjf4sth50NorL1vJmIuwEMxQ3kMSdLQSue6zEx5L8l5lnZ38tZUmT6+90kBQNtZuXnsHvG2AmwXFwoRQtBvUtO2V+SERUSkzMiI/znruWoTXRgwEyzoEeqdL6SdjQ4VJTZWYpHRxyC2hyHdJWeEMKuVPJAyG+qVa5Rxm86Mys01G2ikocsmHe9OSYvb1NSuxPIgvuv9dr1fuIuCvzj7lERgcWuOAle7I5ysBtzuplp0F8X02Ji6DrWL1wsbLzWeywbAMUgBB3QrQv3ACyWR8yPtZEK9R/UNUYAG0HBYRrpl3RDbZZNR9P5D8/EkojonDLDDVb+62Uijs/yVyZzY2NM7Ova0lL9LALU///ONWXhgR2InULfmgB0xQJWAARLvfPMu8xPoNM3Fyw/fP
 r4qx59xg
 fLEDpwk+bTR8HPpMUHQbECmoZEv2ZovY8UtXu7l8NuvNm7G5Hv6HRUUXSK6YhW4/Pw9IC+jS43XyH3pbLUJ+novu1qFiGhRK2tWdjxWDJP8PdTJI+vu2Qx4d6AI5A7bl+ULpPvJM4WaMUPZ6f/m45iNSAcXrQoXFdDpADrKz6E01c9jXLBXwcRfGpf58i3v3xqgaWwTx4h70SR/rjqoXpGWsz3XNw9LQUDuBX+0ripeBqrJViP5/qWRHvptfOft8YLPbIX++oIDG8RAkuRV0hDg4/VCdaEc5jrMPsvg5vt3ZMb7CGotcxdP9yPjAVqbraMlp8ntWRf6YPPK5NaGRACB99poLquAjQ/ieoZCEdfoieouFDkiflqorTXzlSE0Iav+w7bFJ8m0rlfvxtLBG3kAJuhvyXKXIW2Og418kMeBLiOo9ah6uWCoKPzhw9HxbgwqA5GxBlwEyLuCqMYXvkIW2G8sNgsweYS1+GblitLCghrsWTUSEBpnvUwSNzBoLDmhLqp+3b8P+yLnQMJNL6soZdmx4MWQiB5uVA+RWNh1iDAIrvGfxQPmX2OgYSjXPjikKIfUX2d4/XQAOQI5Sfs7nwO3SV7+sil4FjFsA6rVSJc0vDvKUpFjhWg5+1ztFjkjNWgzflwBS4X6IHMADrKMtIhs+ZobjK0L6G/AbMWnP9sT044cNP2/oCFx9pyoepXg7w78erDWrFTaT6ITHk+/oCM03i35uZsu6BKGqGx33f7OkoSEh+pPLdwLuuxkyG57Sq+LuUSPXwhwaRUsrf5JUJCKFEg3VMtxttfw+QrSouKUKhtu2M6OMxC/mMN39CiQoynr72QHn50QAJA/ghPiPPfo67IIMQWiKomMJpdn5Qh3plUOFvlbzXv5kMhRPP8zKw0h/J/bC7HjlrPA/Zcal8UO1vqYFh8Vgqr6Gv8Ms1Y1LBjKebNOAJpztwLSBJHbkmRV6lRx2n4kCAFxrzp4Ernqtk
 3rZ2HIj+
 1FxJDGipQQITNMjZscaFWD1v9tdXnT6T2wVZlj97LgQuc54AqFzD67B5lULpQuC7FjVk0/RkkWRvC7ZeRGu7dz06ucVylUttz5bU2mR5F0KFuJysXw5NtatV4/bjUR0jRcHDCEcBP03/gWJkMyrsW47hrCvqzWV40kZZYxeFc4tuBsko918ympcQ+D6hfW29GcudHg9enb8OHWMlsoUMRuCD9hQNp923lyLmkhwXO3JoptZqHhlfl1x9VzFS1tZ56bsjs+dpkyGJUA4UVNI/rG3Nw5ru4UT1+g5twIFT399jy2coOMVQQx4maVPFx62E/OO1nmYfQhfCsD9avAetnJb6tQ2VGXabNAiXX/XPbuloKD2AdWcjv1M+Yx974zzh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    f2d282e1dfb3 Merge tag 'bitmap-for-6.17' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11709cf0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c686e0c98d241433
dashboard link: https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e0e2a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a439bc580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-f2d282e1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/25cab46afcee/vmlinux-f2d282e1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/77cd04442f1b/zImage-f2d282e1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 4155 at mm/highmem.c:622 kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 UID: 0 PID: 4155 Comm: syz.1.17 Not tainted 6.16.0-syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
Call trace: 
[<80201a24>] (dump_backtrace) from [<80201b20>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:257)
 r7:00000000 r6:8281f77c r5:00000000 r4:8224bc00
[<80201b08>] (show_stack) from [<8021fb00>] (__dump_stack lib/dump_stack.c:94 [inline])
[<80201b08>] (show_stack) from [<8021fb00>] (dump_stack_lvl+0x54/0x7c lib/dump_stack.c:120)
[<8021faac>] (dump_stack_lvl) from [<8021fb40>] (dump_stack+0x18/0x1c lib/dump_stack.c:129)
 r5:00000000 r4:82a76d18
[<8021fb28>] (dump_stack) from [<80202624>] (vpanic+0x10c/0x360 kernel/panic.c:440)
[<80202518>] (vpanic) from [<802028ac>] (trace_suspend_resume+0x0/0xd8 kernel/panic.c:574)
 r7:804be014
[<80202878>] (panic) from [<802548c4>] (check_panic_on_warn kernel/panic.c:333 [inline])
[<80202878>] (panic) from [<802548c4>] (get_taint+0x0/0x1c kernel/panic.c:328)
 r3:8280c684 r2:00000001 r1:822326d8 r0:8223a0a0
[<80254850>] (check_panic_on_warn) from [<80254a28>] (__warn+0x80/0x188 kernel/panic.c:845)
[<802549a8>] (__warn) from [<80254ca8>] (warn_slowpath_fmt+0x178/0x1f4 kernel/panic.c:872)
 r8:00000009 r7:82266338 r6:df985d14 r5:840d5400 r4:00000000
[<80254b34>] (warn_slowpath_fmt) from [<804be014>] (kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622)
 r10:00000000 r9:ded86c30 r8:deb6caa4 r7:00a00000 r6:00000003 r5:840d5400
 r4:ffefd000
[<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (__kunmap_local include/linux/highmem-internal.h:102 [inline])
[<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (move_pages_pte mm/userfaultfd.c:1457 [inline])
[<804bde08>] (kunmap_local_indexed) from [<8053ace8>] (move_pages+0xb1c/0x1a00 mm/userfaultfd.c:1860)
 r7:00a00000 r6:00000000 r5:8490d6ac r4:ffefb000
[<8053a1cc>] (move_pages) from [<805c401c>] (userfaultfd_move fs/userfaultfd.c:1923 [inline])
[<8053a1cc>] (move_pages) from [<805c401c>] (userfaultfd_ioctl+0x1254/0x2408 fs/userfaultfd.c:2046)
 r10:8425d6c0 r9:df985e98 r8:00000001 r7:21000000 r6:00000000 r5:20000040
 r4:8486d000
[<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (vfs_ioctl fs/ioctl.c:51 [inline])
[<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (do_vfs_ioctl fs/ioctl.c:552 [inline])
[<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (__do_sys_ioctl fs/ioctl.c:596 [inline])
[<805c2dc8>] (userfaultfd_ioctl) from [<8056c4d4>] (sys_ioctl+0x130/0xba0 fs/ioctl.c:584)
 r10:840d5400 r9:00000003 r8:8572d780 r7:20000040 r6:8572d780 r5:00000000
 r4:c028aa05
[<8056c3a4>] (sys_ioctl) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xdf985fa8 to 0xdf985ff0)
5fa0:                   00000000 00000000 00000003 c028aa05 20000040 00000000
5fc0: 00000000 00000000 002f6300 00000036 00000000 002f62d4 00000938 00000000
5fe0: 7eb28780 7eb28770 000193dc 001321f0
 r10:00000036 r9:840d5400 r8:8020029c r7:00000036 r6:002f6300 r5:00000000
 r4:00000000
Rebooting in 86400 seconds..


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

