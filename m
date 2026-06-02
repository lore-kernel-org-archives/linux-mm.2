Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B0ECD6E69
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC3E6B0005; Tue,  2 Jun 2026 12:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DB66B0088; Tue,  2 Jun 2026 12:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C496B008C; Tue,  2 Jun 2026 12:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 865976B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:25:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CF7493345
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:25:46 +0000 (UTC)
X-FDA: 84835498692.04.04783EE
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C237A0017
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:25:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fk8n6ZrM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780417544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOCKFyLUJPCw0aUkfqnBjDq2OcY/GX3HSt8a5H5Uci0=;
	b=wpE4/6nnLcsMdySHmsa0sxayRnEWFjN1h/rknNyXZmz7LkWJA6ql7MxpQozxwnVm+4lgUE
	NOrRRgEJUlemuA1UrXGi+PPyEL9xfeyqVDtA4JqWoUiPRLHHpt1StFoRPMX6Ux1HOqnKhu
	dqjTpcomi8WVOIY5Q3+dyra91ppXJPM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fk8n6ZrM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780417544;
	b=7Z9b2u9kFc/A3r3Fn5h0ZwR+Nj8jqKpq2tiIxExD+Hh0USrt+wdA2xYcjAl2lm+oW2NfOZ
	yRLmBi+EQlaHcBaJssEJ638Bc6iXNuGqDDIQcgmW/iQWKWZ42187W2UD19NUSSGCUBBedp
	XulwEZhHn6s88zOJeJk80PgGB6ksFCU=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842264dde84so1587613b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780417543; x=1781022343; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOCKFyLUJPCw0aUkfqnBjDq2OcY/GX3HSt8a5H5Uci0=;
        b=Fk8n6ZrML1Mg0NtfJO65Zh9qQxut+AbSg/EWa0+WMsiuRpwgfFhEK1wljVzDUhF8/W
         GVmGD4dYZG12qwh2pq3NgctVxS6ca3sRAR3uauovPwAsGljnSq204fKuPwV3XNItDkUM
         ExbF9P2Moy30DveS9yYbTD5+qh1oqi6gnyMsW1NhX+vvL/DZtzgoHyqNTTIO6RcmMx/E
         GIN+fw/oiyGOmGcf/qslo5So5Z/yL9fkVrHQT6FVbYzu90/U5GATtVG8Q/NGU8BSqBN1
         zNZBEUovAUoqp5gFw2ZpcCOa183rmXt2JsjQrmbwdA02RTKmes5vVu/YDc6Lx5fx6ieP
         KW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780417543; x=1781022343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOCKFyLUJPCw0aUkfqnBjDq2OcY/GX3HSt8a5H5Uci0=;
        b=F36Eu4Vic/W3rxiMikz7rjyGfkNzjdSFQH7bhCBvrp7o0wf80D1+QRNvZU2LKVd2qw
         o8rANP6H6Zphk3wYQkYGyv6Y/vw8VmtO8L8IFyawW1quRehTWkqyRYguJ/LIHHtuZwLb
         xdZplhjXc+59bfEaICYheBczO9E9MT8O98h1BAoOzOkdmEVec9YXSjg2nNtHlT+Gb84f
         1mijOP7TQ2MTDDcHAkDBl4h6h0w6Y+oYdHCAxPNtnxkMb+OR6J1r58tTz9XLrs5IXUGD
         gFq7+Ae2WpsvwmPoJjzS2v9xg1jlYMMQVDWDHj6ZBkxE4q9ozm9K4CF26n05LvVbZz8g
         7H2w==
X-Forwarded-Encrypted: i=1; AFNElJ+dVHstrbxUFvP2fGD1ZQZJ8B1q3skjzWKMFBOPvQheXaRGavmV+UJMRFT8ABDxW2OytXMBUzcoBA==@kvack.org
X-Gm-Message-State: AOJu0YxZ7JVMPllvFDgZjWDWM2g7mzKWabbapMss+U9WJPBPPxpUE8lE
	+R8sHpx5tB+kCYdZXVmn6lMAzP+kJmVedYUMNloSXC6NopUwj2ojXjO7
X-Gm-Gg: Acq92OHoBolpSlXHScX71U1bs3+jvRGiMADqugkOcBgCzywvSvM6j2PPX7XKN4MMTna
	5/7z0ZWI+Cq4FhryZmM9QX/TRd1Ezy/7sBV5pRWULn8WjPhZZDkanX6JSlUR0XCXWBkeOoFGpme
	SbP6tDpa3K1LAbzrwE+UZis+ePXAfWZvMzfEXyPjtin+Cw/NWHSthsNhv1mczfL0ICZ1yCZbA6U
	fd3MS81nFf33bL37cBSrnXiE0adKBtRtO7IuLlZrxDOLDP0BTR7o/Y/XLMN6anztJ1KN+zDYNuU
	k1yN56Qq5uKD3BQGBt/hO7ihOLnf5Lq20KhZs5uwo/aI6Or/yLp1tbK0tNXHawTUvY7uyptmQy3
	h1iizqrnYkawha6yPSH7Eix4lVlB/A43Ud0ZY2YprmFMos26rk/A/1xq8jRBE/4g100K3f186ug
	8uCsNzuSkPWTMwH8XfaywsZWw7ZWdajVthUVXbFMkOpytUis1WjCiXy5bynGLAMMFwTHOJg8D19
	tXK2Ajr
X-Received: by 2002:a05:6a00:b89:b0:842:5ea5:5fe0 with SMTP id d2e1a72fcca58-8426a5a39e2mr4028123b3a.6.1780417542948;
        Tue, 02 Jun 2026 09:25:42 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428221cc3dsm294619b3a.1.2026.06.02.09.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 09:25:42 -0700 (PDT)
Date: Wed, 3 Jun 2026 00:25:37 +0800
From: Kairui Song <ryncsn@gmail.com>
To: syzbot <syzbot+deedf22929084640666f@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, youngjun.park@lge.com
Subject: Re: [syzbot] [mm?] WARNING in swap_cluster_assert_empty
Message-ID: <ah8C8DHdvmtKhXsB@KASONG-MC4>
References: <6a1eac8e.fbc46276.3c3783.0008.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a1eac8e.fbc46276.3c3783.0008.GAE@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8ycd59m85u4wnfyzmbb4wnjaznfammc4
X-Rspamd-Queue-Id: 3C237A0017
X-HE-Tag: 1780417543-422906
X-HE-Meta: U2FsdGVkX18RcbQzFTva75/9zteny9Ozw2bFKDb4J9Zvp9IZVGTDH25dUIUBlLKBctfnX1WTkORdYuGkNiHyfXb80iwuOOMPn0NzSYc0U01yFumC8mPZ8vT+lBwiKZ2urZggbnFBby5HrLy8UBEV3ojbXWsdqCzpjLrDklhKZkqyWne+CdRuxX1CiZQ698ahb2DoI5LfK91ddgXZxRH9DOLfMzgQAt4HwrBA2KOPAEbBoBgw3bl7NwR2o2WUsPI4YFOdf/SS/ONK+VIORFIx4m3I7qE8L3Hfqxjhet08H1Y6434zNiIR7YSpPPvqo+LOXbmpqNtUJ8R8p2YXRfv0mFfLPUUzP3E5+46UicIDR6owLGMZDN/aRd2tzEZbMygvZk7I5J4eRJtWZ2cUn5Acavi7WdJnPCGzzSsbH3D/LGBQ+J2O9Sr9zmLx9TXVlmatf8OwAoXY8RF68IIAQbFV5f5v6Z2cFCuexxcC5OH8B6nASf4x05E6WnoJTEXcH+eQEXPnsObBNG8G1EMDrFV4+1F3MVCJaeXH89fA2QJ9j8iUa5xDAY1D4qIq5QtcUwKsw3Brhp1qqL7uCmp5sXWhhoTGZZoikyIcJLiPykhMztvk+kzstgqSEp8N99GTi6OQfK3BIK5CBSUumP51fz1WBFTAagvhNBH41Nhg4vuO7XVhKi33uGhMuzXbcGcJDxcVOXPp5o+4/WwFH1Vs3MRdkS3arCk+Ix0HAF7vBXM3oZEXZSnQiu4tld461sxTjDZeSJhRbuthHMDzsQnic8K2UoeUfJXKLjc8mMFS7HW0J1n26pHr2CAi3JB4CRwlSKnOPEjfHWFRrhAZ6wiLvNfbDGvJp1gb7gZIrIxYqZ0YDEwYxYL5nbQoTU1wsL/2Bi9ZbJKxlLt/gC16oLJGdyabeSyh1O6xXFNjDSnbN0hVAFfGpxIJ4Qo/9/vML+98uP73rY5V+KzN7iB0Tl7SKwD
 F17aAJup
 x/h7UAN0Rzexsw7ki3Nk1wNBn2fKO1jsg+wDkQwLTBOL5ctG8Qa1yj+OBWcw/T44JfOzG/5Pd98V63D+bFEr1Y7L3QNAn1xjUvGgzSCoCOMgcNykBDFpvxeffJ1Jrgk7iluma4zxi3Ee+jb25eyJfXiEQEgTCUqsYZb0zi2OVsu9Rqcr0VGLNpQW1aR2WHPb0yd9lJUXpO7322vaka+7OsFz+2gfwi54yyb1mD7T97nZqxQlH8Z2fX1f4K8N/EACq7Ap30q5sPX/3r63kSfhXCVjeHi3lx3CUseUlJU55Vw9IhJ8j11lB0+gqiLIuiorDF8CHgtNLkOCebpgkifqc0bwGhdNbXkxs090T8n2zHY2kj9srrPL+wOaPTQa4uuuQTQ7ziFwLcQzn4IDRegq4rT2zi5daCdxPTKJQRjJ5+Mdm8Q+9tb7SaTV+KxEW321xT+I/yGf+eEwTPoZ/id9yFFLZrni8fl0snNHmjwdQvQXnlqgyXi9RqZj1L8BaNdqGFNhmefS3aUN6AQI6uLe8ATXkfd6MbTePncdoRousdQlZKS3ACrUKOj9/eEgBlThqwQimEQnAcQJU6bHpH0IDBeutcXi6QtryC/1bDxVSfW5yuHe/5ecVBQ9voyQvlvzzWufthTv8SnvrLmkgUpzzKaW7mLn1YR826n/LclAziNOwRaSnHDZm5xE5FLtc2A8LaNzelbSWQTpGwTYG1ej/oosUK+VwMvYFlcBiQhyxssYKFmvTG+3JClcY9pbr8rjL6GyArOe/TVcbMLLdYzY2x7MHjpGFWE9aUgx9HABdQsIf2Yh0q0Cp6u/Xc0jFBqdpV/NSHoe2a5KjYxIJBRdA6smbBVedlrxgR0BFz2wANiNgblSelkcm08/UED+COWMln3SVknlKzXs8REwZIDRE57wD4jl7VSkvWBd9bwqmno/b5ddGZx9ot0KwEe4joVqp9Fnl5Mg4f9BgsaAccsjKOm8EPJoK
 TxxiQx8t
 HVzgVkqd+ro1g1pbyavBOY7bgWyKHm2F0PVH5MVMhF0/1c95lsx9NNUKtrVwBWLgRpiH+IHz4kJRKR2NDW1lLmG8nTxoiEUpBCqpoMQbN8kSr1xH6L2cSWwOMGqcsLNnya5n90Pi8ovY72mRGvngkaD5PLM1X6QVVrJY6zxrTIR8OI+zpMIwXfvYwlC8qxaZI1fvEAr9AZc9m7tY0Qv81pf1rm34FelLOKoY+9x7K6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 03:12:30AM +0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8fde5d1d47f6 Merge tag 'acpi-7.1-rc6' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=118c327a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8118209836970b54
> dashboard link: https://syzkaller.appspot.com/bug?extid=deedf22929084640666f
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8fde5d1d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/529080512bd5/vmlinux-8fde5d1d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/39c09b74f46c/bzImage-8fde5d1d.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> nr == SWAPFILE_CLUSTER && ci->extend_table
> WARNING: mm/swapfile.c:471 at swap_cluster_assert_empty+0x2d5/0x320 mm/swapfile.c:471, CPU#3: syz.1.267/6778
> Modules linked in:
> CPU: 3 UID: 0 PID: 6778 Comm: syz.1.267 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:swap_cluster_assert_empty+0x2d5/0x320 mm/swapfile.c:471
> Code: 9b ff 49 8d 7d 50 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 46 49 83 7d 50 00 74 a5 e8 4c 09 9b ff 90 <0f> 0b 90 eb 9a e8 41 09 9b ff 90 0f 0b 90 e9 6f ff ff ff 48 89 ef
> RSP: 0018:ffffc900039d7098 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000200 RCX: ffffffff826d976c
> RDX: ffff888037a62540 RSI: ffffffff826d97d4 RDI: ffff8880273450f8
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000200
> R10: 0000000000000200 R11: 0000000000000000 R12: 0000000000000200
> R13: ffff8880273450a8 R14: 0000000000000001 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880d6686000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33323ffc CR3: 000000000e596000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  __free_cluster mm/swapfile.c:585 [inline]
>  free_cluster+0x14b/0x360 mm/swapfile.c:714
>  __swap_cluster_free_entries+0x73f/0xa30 mm/swapfile.c:1894
>  swap_put_entries_cluster+0x473/0x5b0 mm/swapfile.c:1584
>  swap_put_entries_direct+0x123/0x1b0 mm/swapfile.c:2072
>  shmem_free_swap+0x1f4/0x200 mm/shmem.c:985
>  shmem_undo_range+0x3fd/0x1570 mm/shmem.c:1139
>  shmem_truncate_range mm/shmem.c:1277 [inline]
>  shmem_evict_inode+0x3f3/0xc40 mm/shmem.c:1407
>  evict+0x3c2/0xad0 fs/inode.c:841
>  iput_final fs/inode.c:1960 [inline]
>  iput.part.0+0x605/0xf50 fs/inode.c:2009
>  iput+0x35/0x40 fs/inode.c:1975
>  dentry_unlink_inode+0x2c0/0x4c0 fs/dcache.c:476
>  __dentry_kill+0x1d0/0x690 fs/dcache.c:718
>  finish_dput+0x76/0x480 fs/dcache.c:927
>  dput.part.0+0x456/0x570 fs/dcache.c:976
>  dput+0x1f/0x30 fs/dcache.c:968
>  __fput+0x519/0xb50 fs/file_table.c:518
>  task_work_run+0x150/0x240 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x951/0x2af0 kernel/exit.c:976
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1119
>  get_signal+0x20ff/0x2210 kernel/signal.c:3037
>  arch_do_signal_or_restart+0x91/0x7e0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:244 [inline]
>  irqentry_exit_to_user_mode include/linux/irq-entry-common.h:315 [inline]
>  irqentry_exit+0x39e/0x970 kernel/entry/common.c:162
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7f3317d9ce61
> Code: Unable to access opcode bytes at 0x7f3317d9ce37.
> RSP: 002b:0000000000000030 EFLAGS: 00010217
> RAX: 0000000000000000 RBX: 00007f3318015fa0 RCX: 00007f3317d9ce59
> RDX: 0000000000000000 RSI: 0000000000000030 RDI: 0000000000000011
> RBP: 00007f3317e32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> R13: 00007f3318016038 R14: 00007f3318015fa0 R15: 00007ffc650798c8
>  </TASK>

I think this is already fixed by:
https://lore.kernel.org/20260515-swap-extend-table-fix-v2-1-833d72ad53e5@tencent.com

I checked syzbot dashboard, the fix isn't included in the commit being tested.

