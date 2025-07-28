Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE8CC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BA46B0088; Mon, 28 Jul 2025 17:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05DA6B0089; Mon, 28 Jul 2025 17:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD506B008A; Mon, 28 Jul 2025 17:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85DFC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:08:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14DAF12BCD4
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:08:27 +0000 (UTC)
X-FDA: 83714911854.05.1E92806
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3AD514000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:08:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DeHnmMVR;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753736904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcBiW6OrDuRkE61U2oZHQtibrdiKqEiJ1zyfrij+HuE=;
	b=aj1YcsVMRvwmcOTnsUNWF4xZ3Po1aY4/s53JXHuIoDih3oUm1c1nMpGn10CFbUwH6nlUr8
	tX0zUFPltHxQ9ULEbWBA25znk2QV9367BDAWGBRqWwvJwKEVssLknpnYLQ9BYuiIBRYMrG
	cxs6EXJBCRlvZoqWRSv4z+WjYWImisM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DeHnmMVR;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753736904; a=rsa-sha256;
	cv=none;
	b=2NxkNISg7Za7HYFlhVj7L6uiOOn1PirYkxWKwV6il55iNNaCOgOYhfUnZ+9CAZBFkkv+Af
	3uczlUzWzfOBMzK5ivCdTPkacACgLpKHLtj/B1z6vB8Px+3sV1vPZylqexpEACfUzmyMv6
	u1cAtmm2JfwPqCR436j8Yv95HY4I5H0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753736904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tcBiW6OrDuRkE61U2oZHQtibrdiKqEiJ1zyfrij+HuE=;
	b=DeHnmMVRP/iocd8Qx7ArxF0YaB9TBpzjPiFCP+Ynaw8yIQks5uN3V/xs1XbY7WYdj4JjLZ
	Vf+moJK/p+mVvZxen2dxNXLOVO2HBnaGCRAyQIhCNQlKdXQStS8n5f3PL17HZxgQxgjl4C
	U/VwLPyF/KCEMcdNnZ7TkUFGsbsuoQ0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-bje3N-WJPA2NtEX34tI-nQ-1; Mon, 28 Jul 2025 17:08:22 -0400
X-MC-Unique: bje3N-WJPA2NtEX34tI-nQ-1
X-Mimecast-MFC-AGG-ID: bje3N-WJPA2NtEX34tI-nQ_1753736902
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ab87fec9e2so106139301cf.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753736902; x=1754341702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcBiW6OrDuRkE61U2oZHQtibrdiKqEiJ1zyfrij+HuE=;
        b=xBE7JFGEh9/fzs0RmjVJbGrCBEKl2h0FwYJjIkAeZcBzoBymukMc3k4mgDvrjJHPfg
         On1mDzjfgd6pS7quCnmwhULxpoxM3C/E7vfqg540kdDaHImzeTVwVnwwRNVGAXAqKtAI
         WWuQ3vFI/bify55J2CKOMjMPyf9ZNcOLVppjgNd7wFJyDlZoetIEvBENHJO+TLMmyNmT
         Qgas6cRCv//+xicIYPxA9QPzm23FHyfYzVJdYW34NZa//n6wnrHfH1bRBAjmt5gHqghe
         DjVwWYaXdi49JgbnnGSYDhNZzMSKPTe0lPiyEYYkk1ZOSwGhoAIDu8hq2v8miPT/6UzE
         FAqA==
X-Forwarded-Encrypted: i=1; AJvYcCUjM7SUjGTIAQ4j/wgH1zDwEgoHytXBDMGifQzYsq/t4NaAoAykuzVv7tt2k4+i28mFvxyf6BkilQ==@kvack.org
X-Gm-Message-State: AOJu0Yxqugf3X5ZnnoTWyAwoz6c5iS/+Qx3kaBGqHFtH+J5VYi6FdDR7
	/rch0v7IAsWvPh2p46rI2rbHzli8FcZv4AXUlYIt3NvMgVJcC623CLGDjf+ZBaPX45VGoijeH9E
	5DAG4MOCb2qGNTUOPaneED2BeEhT1Mk27fUPjZFLFtSBdSkVNikCQ
X-Gm-Gg: ASbGncsp91rSNHWMghTOAGA3kSOgHW02nHT+ReqW4nT4r3lZJSiUjF3Gd7Ai1LvimBd
	9OH+GzhIgyYATOk64h64hhEPdGsL4iKmvUXH48Ptry9aGJen8aS9zVOe8rb1IQthEM5CSupyo0Q
	M9mbV2YxBu2vLFEzYdD1QZntHfM4tl2hKz3ZXMks16t6MO2TJE5br18QDc1Em1X8pxgpWEUO/ri
	TB68PtyX5BfpAmAsUHX0w8mBxC8kFpqsGipEbpf3ua0SI6aiYP9Reolekgv016tmdflRUPj5Z+h
	+lVzKe1MHV+NMiZWPGPkgtu9S/63hxE=
X-Received: by 2002:a05:622a:13d3:b0:4ab:c00c:250b with SMTP id d75a77b69052e-4ae8f0ddb39mr185285201cf.40.1753736902124;
        Mon, 28 Jul 2025 14:08:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUd/cHhjwzB9/l8otidGgToOpAIoiGahsj8p23nz+4w2+2F/XUHPOFR0hUr0kib0c+Eh6EjA==
X-Received: by 2002:a05:622a:13d3:b0:4ab:c00c:250b with SMTP id d75a77b69052e-4ae8f0ddb39mr185284811cf.40.1753736901647;
        Mon, 28 Jul 2025 14:08:21 -0700 (PDT)
Received: from x1.local ([142.189.11.29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae99516482sm39780351cf.7.2025.07.28.14.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 14:08:18 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:08:15 -0400
From: Peter Xu <peterx@redhat.com>
To: syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
	Lokesh Gidra <lokeshgidra@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in
 move_pages
Message-ID: <aIfmv-qSxKxWgzur@x1.local>
References: <68794b5c.a70a0220.693ce.0050.GAE@google.com>
MIME-Version: 1.0
In-Reply-To: <68794b5c.a70a0220.693ce.0050.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: 8vElI5g5UzEEUnTJjmIpVPZ7dPt9DIFxZ3VHP5QzkcQ_1753736902
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: dbzzysb1c61p3dymzbiy7rdc6ri3kt77
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3AD514000A
X-Rspam-User: 
X-HE-Tag: 1753736904-5769
X-HE-Meta: U2FsdGVkX1/ojFaJq+D8Oft4HmjgnXDsKA7HZDN7Fnl8NHZEFapShRqoDEk+ovoiKX97XD0bgwfYFC39TPsk05HgVKIOmgTggLbQkpxaiFMyx0wb7xCPCfhL/lXkbeG2syMpsegVtafjMzUp6Bez3K9m3LZrgEBxqnGjvefH8uBYtzd/jy6146a4mmreNEXkdSbhU+8d1thvp2AkjAeT2lX4k0PGmdekaneHVA/tpPonFoKtabX43aIqomDVnCpq7a1Z5aiM4TnchxxifNXBfwqLQrdoG7+2qUu+1ZX0Fif1tAUgzbgi3Ywv16l4qVsF3yiJ3cW/idWGyBzMwZsf8TdbX4LrFuBplK0pBZAMjtB83U67QLe03vdWY9dZruZJhGo+rbApKEhS04rEVlKG1/+HxxkiXQhTknGVTkCtU5JleOveWZOgEbLm1qVLjhXS9VU6foRF79OG41G3EeTnYtd0RMj5/wf4jJpZFCWmbD6N/mFtLb04Z84k+3gwI11acEsn9Gzp6V4BKSfptk/NSc75ABAj/wBymRlatrqkxq4K3L4bD6xdeVYtAl2s5xAgo7SwASNmbVS6fDTiSwmPVUOMoorE3bnnK/eq9qz25Fk8lj8mbTTtBOagdn+35aefYsyv5ZPsUMal5A6MlVLMcVIfekcyK8qEJmT9Ev4ni6AxHOC/HdCqFcfHK+c5dLzmrRP4megPi6u+pYfy/TLA1kUz2prO81M5HiUI552hQqKl82me84NeOh9Ld1MNuJNrKV7qqe2Hc38pieet4Mk6z0gCkyQ4IP6Qa2lm51KPONIBELo1DJP3f4MX7o0Nrpa7K2GLfneaOLb9ByoE3lIrjeDxR3i2qjoYQCxAKd9+jKrekwgTTEwruBAWI+okxAvC5ESULrEr8Wp1qbgBSViwBKARjAv+11gaVmDd/OE1L7BbplRjDQ/P8ca4OoCnLGHZf9uOqVhFY80tm88QxCp
 mVPl2+cq
 ZhrhXYV2SqITYhXZ1K/8FtPlwNVyBOumFC5H2/GlJ8za1l4W0s9bbHjFE+4kKnJYqGX5kVzhq6NWbIbbtO3GWtOk4TccJmmepYeX/+RHs+AKdjsgtgJ7/iAuUdlTLik15PFKpeXcqZDx0Rie5Pz2w9vqTFIgUsxDV1O13E6ln57TKL+seSEJskP73/iOI2X4MPNWxYVLaZykEjVuBRA7qG+x4TJ+XZMqWZsJAZTFISn+k+x0eEz8jKKWccHui7ekOmLLPaVm8ZztRRsFz8B1p3kKELZLPvtdUVUgWLjTtYLZgxrCLLqJKWG1BmizY+PXYoiYRENx9I2XrxDlpYzbh4eN+xzH9w4zSEKjVKPH0bVle/0MIfgvWGHVUlsmG7tl6n4dcf23b2u7PXpVlbGvHn+q1qYBQsFkb/GRDQrTvUVGBDyyma+7sdvUvF72puh0hDSSkHtG8U9ELc1VS7SkX1KN9aBsf2H7+qK7E5bcFbqt1B1fo9rSR7Ns/mdpsm71/PP6wImNRWeDrxjtGvlOZpzqAtWFxg1wjU3/Tn4Uovs5tFDDPJJ0wSv04IgmlVtGA69+yS4XZ0iNGOC3fu54QbNR5fXu4rpd5xHKP4qcIeFVSi4ycqk59Cfq/18LaPJcFQJ9IK9x4vUW54JCfLXF0t4WoFiLMuiK6nmkDwnGmMVVyW1TwYrIw301T+sbvkl+T9QzWMWhT3H/M6z/TzLZs0Vir2HAsmeDhAjXPjyLPnrgPSHpGJ9TZVLGc0bmTds/8579tXyYZhQ7rNsp+Sz8JF08PcADhY6HY3x3qt9A//Y57m20jSxiZQPh8yEbouMJaTZB0vamOJS2rc6Cd/CPDtSyh1gL/4wF1r9u6HPOttJ0VUhZtzGS8TXsPMXFJ8rae6T4cU6OoXJaBq2eUL0vdyf5FtAPFjo04pOVq837yCyVRhx9i8qR+JRfOTtlAcHQnfAptBHzcQsZVNzFQal6/xkEDJKP9
 Wbz4ozHf
 ZYH+gNfPVwGI6VahAc6DE1mHyO2xMOCHJ3dCXlbFKFhTTmdxmObOA6eBkvTAvAIqGdl4PN8mzlWqQs0E8uiExYXflwI5bPRJJhDg5i5y3ScC3Oj9lZ0CvJfRJrNCn7nDGA6v23skvulBmHyXyz0kpjsX0IQLbyYGz3ReHcLyu0g8BAeOKsSgd73IW7FDkmyI6Lwy+gh4BnghXNEuYwFN5iclkURBvuxujbhJUWKoW8juQVZHTJedS0roT2LNRJ1Wvk6Ib9YrL51ZYnp9ajJJvIor2Fw4ecVoMFATiUSCDwWJS9UVCvqBiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Copy Lokesh and Suren.

On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e8352908bdcd Add linux-next specific files for 20250716
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=17f81382580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b0e60e17dc5717
> dashboard link: https://syzkaller.appspot.com/bug?extid=b446dbe27035ef6bd6c2
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10041382580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eb158c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ae8cc81c1781/disk-e8352908.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/57aaea991896/vmlinux-e8352908.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/feb871619bd4/bzImage-e8352908.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> 
> BUG: unable to handle page fault for address: ffffea6000391008
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 13fff8067 P4D 13fff8067 PUD 0 
> Oops: Oops: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5860 Comm: syz-executor832 Not tainted 6.16.0-rc6-next-20250716-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  userfaultfd_move fs/userfaultfd.c:1923 [inline]
>  userfaultfd_ioctl+0x2e8b/0x4c80 fs/userfaultfd.c:2046
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:598 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff3570d6519
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff35708f218 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ff357160308 RCX: 00007ff3570d6519
> RDX: 0000200000000180 RSI: 00000000c028aa05 RDI: 0000000000000003
> RBP: 00007ff357160300 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff35712d074
> R13: 0000200000000180 R14: 0000200000000188 R15: 00002000002b9000
>  </TASK>
> Modules linked in:
> CR2: ffffea6000391008
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>    0:	c1 ec 06             	shr    $0x6,%esp
>    3:	4b 8d 1c 2c          	lea    (%r12,%r13,1),%rbx
>    7:	48 83 c3 08          	add    $0x8,%rbx
>    b:	48 89 d8             	mov    %rbx,%rax
>    e:	48 c1 e8 03          	shr    $0x3,%rax
>   12:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
>   19:	fc ff df
>   1c:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1)
>   20:	74 08                	je     0x2a
>   22:	48 89 df             	mov    %rbx,%rdi
>   25:	e8 9a 30 f4 ff       	call   0xfff430c4
> * 2a:	48 8b 1b             	mov    (%rbx),%rbx <-- trapping instruction
>   2d:	48 89 de             	mov    %rbx,%rsi
>   30:	48 83 e6 01          	and    $0x1,%rsi
>   34:	31 ff                	xor    %edi,%edi
>   36:	e8 59 70 8f ff       	call   0xff8f7094
>   3b:	48 89 d8             	mov    %rbx,%rax
>   3e:	48                   	rex.W
>   3f:	83                   	.byte 0x83
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

-- 
Peter Xu


