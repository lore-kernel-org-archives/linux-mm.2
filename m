Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16AFC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 20:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5375F6B0357; Sun, 16 Aug 2026 16:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8006B0840; Sun, 16 Aug 2026 16:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE206B0841; Sun, 16 Aug 2026 16:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1255B6B0357
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:52:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86738C05BF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:52:06 +0000 (UTC)
X-FDA: 85108329852.07.57A9F79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AA75A20005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:52:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rCRTxcPi;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786913524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i48aE4Uvnr3uPhEqoogP6eiRnIdhnmoP8F6HN4onxrM=;
	b=K8FFoNov0720MVFmEWNcMBSQ0YewnvD2FBdxDKcR/8se0hZ0LG+SsLY1vDdwCj/JKNz4wU
	17U3dRDDOSBDsUaEcmMT9Yo341cVNl2AJ35GCnmdueXaTHUW7Er+VvkTqzYFcQCIOmxhWC
	Fshl0r995f8PyYd/ShnO4ZTvhcgwVGI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rCRTxcPi;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786913524;
	b=dexdpGQcV2AR63LKmfAaWAAKWTI3pEzUHq1fi3Z/3jPU/ELENmNFBQmD3KDK5KvWXeMVx4
	bz8XXjN88RUMzuAoazpQCKc0NZaqaDCmCEId75PcRHMfN/mYNyVS6HttmCBSVYfZ2k3dnV
	0HtUoYpaXoaV0UIGr6oNxWvVCag5ILE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F22E240AAB;
	Sun, 16 Aug 2026 20:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636621F000E9;
	Sun, 16 Aug 2026 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786913522;
	bh=i48aE4Uvnr3uPhEqoogP6eiRnIdhnmoP8F6HN4onxrM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rCRTxcPiTLmV5+++k9RQBwTNllVru5d4JrirhyxKohl0jrFNIpwYmWVZdIVSofkCg
	 wolLGHMByhAw+zhL+2YJTeslbimvKcK58vufmJijyM71rPf2jvvdnQ7PyjwYgPiJNY
	 CR21TPDCYS99/4vbCEFCw3ydOqGZ5XGb1h5h3Ngc=
Date: Sun, 16 Aug 2026 13:52:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-Id: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
In-Reply-To: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA75A20005
X-Stat-Signature: tqnc9h6937k558zqemecbsc4b39by4gi
X-Rspam-User: 
X-HE-Tag: 1786913524-531246
X-HE-Meta: U2FsdGVkX1/YwHsEzRlf1k8JWmbgq+tM8515J4OpRnoQrRKp5Rd0VE18TFKMpxPwWJwUWJQQV5Nbth6glH9pt6rZj1Pl6J/RyknHMO81ywrTExvOWoilGdxbMYU2QiFv3Sc8Ozs8jBtxRadOH5rLRtA/7IeuVZGMY1/95+kcu4m+qM5epXrFoQbgE3255xSyQM//ocU4i8O4W29RJRjL66kBgA6ZX/2XwTu18TmmA5Vrmfd8F/XQMKKM1bLLutIWxNCl/kPTX+gKTilIi0XDZFhgHtHlyic758ocw/aGjkk2bMNblOcSMKvN8vFAv+Qz5t7Qh5zz3qz44WDN5i22+iTqJrMNeMeg7zSuKsW9ia6O4FyAg7+7c9Ocu870Dm5TQld4Mw5r4YEHJV+Hj8Vf7UsRXLqxitqky44+7GmqW6w46N68ta3+Vh9uxeGKZzMyv3xp7yWiP2n59pMqmMzn4h7nWNrYZsvxsrOJNiYQ4eJ7tUcO+BteioNE+svBTlADSZEDdfgzBFw5eRiG+kT9y4jZiCCy6AbF1SScChpp7KBelJrhZ5YE4tR72gJ8b/Kv7iPauBsNedLbGhvZJbRKXEHrD67rzVvU4kal0MElcn++POM/OHoWqLCg0SqptjE3cepZkivhc81HeLtacUx1rSjuYTrgG4d4LT5jlvPflfbjFyschMLHHZHHKqiRYzbuOSQiM10QhkN4a2pUkrwUKHtBnRIUzDzF1Y5QiABgJ/OBYGUjw81YnjT3mL61M5PN79R5WtT11EPWxCwGLQ+oDjD8NAq8rgoa6LZ5OHKxKvA3KP6TT62YDEWBTqtq2+pbjjzr025QUd5lWUtPt6yFp+3xoVCx5soG5jcoSkoCnUlOmcAs4h6LhsCZtM+1ZWenvy4dYK8NtfS4OYh81jMbuxSR/aXRsVbtT7L54MWEoj31sQhNaIp46RTDIboNGdaVwkfmC7/wRPCxPRCabgE
 OxWb5b16
 bgNdpfJPh22sGB+CKhgO9T3fyTsEw6oo13ufIF94/NC6jH7+eRrqWx8a3v3he9jR74jQ04JZGCRcTFOGtBKbJ8jbACmok8TxBM1O+NZ0SSVku+nd5tp1nFNPahXXgcYVn83VgdKhLlB9DldXB4Swa5UCguygK7VEUv+iFusvSWAHXlSBrQvmsfijmHkWP4sG66XdrB8Yna1J8EujF5q0pUgYhuvw/+WOFfu4DCiUgbOOZKYv27wD2/W6D8jxIFO5JmWartdFagQgpXbJUF0tHQNm5KqgpFAB97VdAzXIdLDTjNyGGWSkmZo4lXU+Iobvsw2Z0X6Z+4T681HkvwG6OZXYCUFtzXQqRd1EofeVo3fChgNjs2nx2nCTCsEsUU76vq3cdDieW0AuFA2QTx0PLpsLF12iHSEDzMEVD/ZMLfjLUlsHRsHld30EBwHrZFUob4wb7Q2PSRIe+mTZyVhRyXpdHsoU2I118Jc62uFRX8CKhRskK+EEyEdeFGOe0qQhuckYBAEmzD9+wl/fkIca5sqXGWvBd9yeogl9J+akUhXeaHi3FRrgfW4g/CfKrBCHyV3jLeODtAWBXbsUObldvh4ctm0gL/E6/MSzcKEF9hxwlQlAnhPvmHPfn7XbDu+GJIe3E9S3tvNeLQorQVW7s6EVMVaBWjzMAWPY01qfkxj0kHlCJlTpjHeWYN+NV+hAlguGLCdJ+/6kFMd2OkFnyWGrpxc6rzXpuRzh9FeGkQY0Gu0o2PnJCAZIUJpwqjCnv1QPemhlRezURc9SckjB0p1XPp4/SZD5Hu55DBTClSiTI5+L1Jd3qco8+FH5Qvi8+fa4S/QVFH7qq4Msd0BN9i2cMingLdPoGCKFfro4O2agnPXlTxYsp64Lyl7ND3YGDIdnZfiPc7tgv++Fw9/O1UK1JuQUpGujS5RK3Ygy4umhGDJRZVu4JPwSpwfK7H+wchU2C3YyD1wl/xFqzA+Nr9fB9vWPN
 PTCVsbla
 xlPLrD7QRuq4DnuSfBdOFUDy6oEyWWILl/siq6hYLTBBRq2RlDWwyPFwbUlhH/Y/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> 
> gadgetfs: bound to dummy_udc driver
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319

Thanks.  drivers/usb/gadget is the offender.

Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
memory allocation".  https://share.gemini.google/5NzjyttO0ULc

I expect an easy fix would be

--- a/drivers/usb/gadget/legacy/inode.c~a
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL|__GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;

or do what Gemini said.  Me, I'll add some cc's and run away.


> Modules linked in:
> CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> Code: 74 10 4c 89 e7 89 54 24 0c e8 0e 2c 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 95 d2 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc9000e13fa20 EFLAGS: 00010246
> RAX: ffffc9000e13fa00 RBX: 0000000000000013 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000e13fa88
> RBP: ffffc9000e13fb08 R08: ffffc9000e13fa87 R09: 0000000000000000
> R10: ffffc9000e13fa60 R11: fffff52001c27f51 R12: 0000000000000000
> R13: 1ffff92001c27f48 R14: 0000000000040cc0 R15: dffffc0000000000
> FS:  00007f6f4a58c6c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000010a0 CR3: 000000004323d000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
>  __do_kmalloc_node mm/slub.c:5322 [inline]
>  __kmalloc_noprof+0x405/0x720 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  ep_write_iter+0x1bc/0x500 drivers/usb/gadget/legacy/inode.c:669
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6f4979e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f6f4a58bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f6f49a25fa0 RCX: 00007f6f4979e0d9
> RDX: 00000000ffffffb9 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f6f49835024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6f49a26038 R14: 00007f6f49a25fa0 R15: 00007ffc6cf49328
>  </TASK>
> 


