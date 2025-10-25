Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F97CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 13:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980C18E0147; Sat, 25 Oct 2025 09:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9313B8E0135; Sat, 25 Oct 2025 09:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847D08E0147; Sat, 25 Oct 2025 09:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC6A8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:02:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 252BB138529
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:02:51 +0000 (UTC)
X-FDA: 84036651342.01.759EDE0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40C441C0007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 13:02:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cfxub1HJ;
	spf=pass (imf20.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761397369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CKZNQp9/AFlG2ndNsqHWv/U11cgG2YxLmul+O+mnOk=;
	b=HLrND2trC2Gd+72JFekKj0zwhsrL68QYHIgVCovzs8DSWX8bsuvtpMFhaIh81ETahRdtex
	w6YN/XkUYzfFY/5M97Vmw+j5kS84VQywsLDJyeOCnp4QhMu1wWiAQXj3I1bNFGsNOM4qvj
	WqeIBIs58W+zz1R/UH6aD6jKWiWZuws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cfxub1HJ;
	spf=pass (imf20.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761397369; a=rsa-sha256;
	cv=none;
	b=MYVrz/EdS29hgGBIkZFYjgIgQRw50qL7SXYE65LmOD7LFM27e2+V4rp+S89HBKFA5mwYdR
	LdILFMogpw2mkzEpDGu3dhtzzfUm8JQezQkVPaAb1KGGEJ0KZzkCZyqFQSe6pAzMnnIBuJ
	pIBb55cEYfu26nBrun+K5Rkvb7XHxwI=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2943620b3a.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761397368; x=1762002168; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3CKZNQp9/AFlG2ndNsqHWv/U11cgG2YxLmul+O+mnOk=;
        b=cfxub1HJv9s0F3Iumjhjhd9p/3Xjd/BG8oft+qFtvB+p69T0w992OEwXFI80/Q+ULu
         HRyflbi+S0RoT55YFUIXftMk9ocQeoxOAA8/U30PgiTv6KgEfRC7JuEX91OTKfY6dCYk
         exfpvF31Tl4VyxVhnWd1goMi/bNjdWNNBHkdvBVbJ6F7HJoBGuQy6G/T/pWoXTSOjO06
         9x4l284e8DiP4QOWSU9lie3TknvkfEs6IOE8jvaYU9H7uZIUGryZ2Vsq/bToupf2UBAS
         yEjxLdz8whk3seULxUOTwAjcVFJEh9AJYj5FCWwZZ1JusjZkxLYQgatshut/3asu2bM6
         VTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761397368; x=1762002168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3CKZNQp9/AFlG2ndNsqHWv/U11cgG2YxLmul+O+mnOk=;
        b=tkBWSD4nz14uJWpuw11+mH7fuQua9kYjsOKZl9cXwUJ6FtRKAOMKjPOWrIp6OCzDDS
         3QN+CUJ3Boshey5mHkNweJE43PNidoz7xiDFLFajL27pJErmzJSA/PWagS52ATafA29S
         Y4wW/jZwH0WRqWa3iaB7tAnrPFN3K0QV3ew/ExuQOw5fqQu6fkIu8TbFJNcfHGATiHN/
         MusxgUzkSDySqG8ev96GJvj9Lrk8Gyaelb9vsxBLbVrg/hqYYPnEXc9JEsj7Au5xOyci
         u08oDnAGXPVn+1NKgJ1MgioJdpBH+sfskXLHZy87TrUTYDjZVmok+EZzowRhqrmDOjP0
         iIgA==
X-Forwarded-Encrypted: i=1; AJvYcCXnImXKS7FoXBaL8TYGmG3HRXTXz7bUqBze/7VH4FZSvazwMWKpMj0hC4zZ/x5OzXEs0NlxFo5aOA==@kvack.org
X-Gm-Message-State: AOJu0Yz5O/HSvwh4UP2YC4pfCJzIHw95chrbU06GJ9nMXAJqXHQpyqpZ
	nqrHw82+nsXnL6X87tgsYPZZADdnENCDI2iUFSuZjFmHPSGOt4YbLtsV
X-Gm-Gg: ASbGnctlntJfl157zmUlDtApprHuYToJ2duRx+YB8qNEtg/Oc6sYNfO/YMpUP3mpCQY
	BiakBxBCQyQXp9dAbmrI2K8UgDWb7moIgy5sqRrTimb6sKEwzi5Yw03AywaQoXaVLdOnQIjdQx/
	k+QrpyWXb9xOxSW2XTZbU4csd4ioNXnZ9IFwExWa0fZN4ptbQtjMn1mcLTwXhhkvTquo9EFvm2S
	w/Mt7Co4J/vFRU2JZQTHABsuQFj1xk+Azv4Pt/zX8pih8C9l1B1b65dnRf6VCGn0xatEhdtCv6N
	JA9zV8DNeqP9aXnBK7N3WKICW+YyS1gCPQPNS2aClLXasACt9PYPKL2Wul7++tSbbKNV/yfH3u4
	UJn7KuZJVa1kkuo9hZSqmn2MvcD9HEY4V0MTDnvm+hghCSMcLMNbm6Bedw72b73UsqItIpX1S1E
	0/fuyj24U0Vu8MOw==
X-Google-Smtp-Source: AGHT+IGrjCtFhlJZQYIN6C1HxS/F0J1boXf9oDupU1D32zQfkdEGvNbHnMM7vxsu/dT1o0c/QFX/tg==
X-Received: by 2002:a17:903:28cf:b0:290:b53b:745b with SMTP id d9443c01a7336-2948ba0d27fmr54085795ad.39.1761397367772;
        Sat, 25 Oct 2025 06:02:47 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d40ac9sm23385205ad.71.2025.10.25.06.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 06:02:47 -0700 (PDT)
Date: Sat, 25 Oct 2025 18:32:44 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <y6cshcj5anakdq2l3yq43febnftvttwjvoeounl6pincoayhfc@fjiiuk6ah4tt>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40C441C0007
X-Stat-Signature: zry3qquwqpuf9sfkwusch1fcearf9hcw
X-Rspam-User: 
X-HE-Tag: 1761397369-242591
X-HE-Meta: U2FsdGVkX184yUjYiB/PXWHvxrU7lurjpzhWrDIkNp6uk7iDDo2WF8ox6d7SnWCH1OpK+zkvHkgLwkfYArFys2EMbYNbeHySuPHmgv00SSF+1/sWGPVGf3JQcYkzrqnnLOglJjiiTAd0IPMxOkgYe66qJ7M3DPmU1KkG8bksg5qw8PGf9oZ2qurB+1WjxKDtm1Q+9+tpnJw/9Zr8HcSOw8NtnYnqD1aFNM3vzBraw7zjWU5iX2jUfCTaeQ2DoldPDGlgc+v+N9dWMqdwCVIOttMx4Eps5/SVA3c90GvigOMsHRQVY5GG5BfwLQhhK1SfWSWCfjc8+Y20wxTwYliOyuO/8jxkJF7MsQOPPYgkqCfVOceblCWSPS7Ok4KJjEgXCI7L3Jq3pY3HYzpq6P19If0WU8aysv/9fSGFIWPZzBIk+3kPgNR3rSXQ3L8QieaDXwcPbkIuj1h7oH7UrPZegIv+CDWAkCcriVjGrwmPJiu9Ldntkp3Q8QkRGShfY05orht6NweuTgHlYWqtYiGQ36cyhZIxO6X/1s1WuWdKo0WphdYQLD0G7N3WoSq8KOrpFxYyWYLryZYmFmIhQL2iQ1agslS9gzhNnEtIExv7t0PQTaRF2BqQSpR5WdkRyLI+zT1Mnnu4d6Tj6wafJEmwFMsAt8Aec4nv2lOpMY9gONZ22iTiayQkvJ351y2DrvzaAWNbRj5SA0dGyBTThKRXwJEMI5InYmR8YcnHmXE1a2BL5m0HM6QURIL98OYElSLY2Jzq54tY8ocEUc6GYy9+l/KD+BGvYG3Xq2xoi3UrtQ/CMN57J9WLEp3bDDpKugxqMGXdP7xqRmLvWcbBDiE8zJpLTZ3SgSwJb10C1aCQe/voNRmfmuOZ1pme6NBtjW+OTNkkPi0ibt8VPH6AFQm0zzjuF9RkfkYghX1Z+EB+tcyAME0WhVhP9G23gLPEg2rb9zH2gfX7aLPTTtLeeJ5
 r6lA6J99
 ucgtWiZHpRBvYnu5xX6KAfWYUZQbadfko+/3iFW1m8y52BBmQzv5etsqa16LqhMWsGafW2o9og4gTkR+KMCZ9j5xYXCWaj1r/sulWLNBHuxUK15cWCfX+XcTVWvBqbvVqGa9xJ8H1oSE3LvpzoG8WG6FOsw+fXoE2+a1FPB6MwqA4EAtf3tblF8uuMkpJMi8OMYyWVn5jmI+uSLl8o0e7CnYh9mC6DkrtyqnE6PeYG7e2PY1+bN+tqtgXXmPkXZkE7fqrulZl6CPpHWwsKRpWCTRVe7jWSW+iqfsSEUGinFgTh+cbuA+QdrqdkfWDg3ZGFwYRANB5rKn/YSqaFbIxTsZNcduC9G9oI8EmadEZEHZSdQogdxIe4SjqHpzMB4Xu8rKFpfYJ+hXSR1OBzimbGBsw3NtRMqf+pX/Oi8dDdxa0rCdyerUt+iPlmRDCcCus7QfW6QgHssMsGMnbRUDkvl9RwCQvfRfSQ519R7VPBsVD0jHOYYmRdOBYfxiL1+Ba/Qs36zmlvu54XFyxxo6pq5rvi3nV+BgsHAGeb1VyRsB3u/baXmY9sMu9VdzI4Yu3kB5GNqG2nZhpAkT2Ti7IOK41BpM5shMlR6rjjcyEedemq8apfHzBdSZA+3fmg95qG/UrKeX5sEHCbCjhIAt0jYNK1/n3CqPvCA/gM7bJ4nLyROxklxEevxDpuKHwsLA9PB8MvihyB1pdsHb7oP549VQgeWD3jmzv1iPC5xNZPJuw/5UuxAjQOjunvHaN6UCdIN7PskWe3gfyW2ZaGxtzk8pTnEtDJDryvhgPTJ6Q9EG6xbgqwj3bE4Abk13o5zrRgulwXXE6o25dhxPwtXeftHzAc9Pjd/6GhHixea/Eyl26T7Th4SomZ55CJ37mfYCIO/jgRaUgAaWmaMz8f8FJ1PzjdIYw/6WW3BrfqX7Xgn3A5jK0Fso6cX7vIGNRWhJC+hodAN/kuryCiokVCREf/TSUTbWt
 6K2L41JV
 Se7LhtpyrRhbTkOB1ApM5gseey/aU9a8IZzbYDrJob/fvCu6/2RZzmji7WDI+S8Bw8YyK0CkNt+jbvtIh2uu+jI44jwmReN9bWzQa8e5rN/27tH0iuIpxpwYKeGVcGcHc4MkdRQJ61ML5P44PUw5etp0wXt286cY0QY3Rpmj8K8vn+QX4W3PtlhtntzR/enwWscPptNefLTv9d7xnqVHYDnNSD8yvxLD1oWQ/CKfbQw4UXSUYP/9XI2DzePKhbHmgdRhNTDFy6bg4LR9/Dm/aN24VYrn/OsJzs+KTgGx1fHwEc1WE3YMCFQ3lktq8Te9t7qlzrqP7Y3QhW17Znu5d+bGcblWwD3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 04:11:28PM -0700, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10fd0be2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119eae7c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140693e2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/be1fa3d1f761/disk-72fb0170.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/57302bf7af40/vmlinux-72fb0170.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/91c806bb2a2b/bzImage-72fb0170.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/page_alloc.c:5190 at __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190, CPU#1: syz.0.17/6001
> Modules linked in:
> CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190
> Code: 74 10 4c 89 e7 89 54 24 0c e8 64 b9 0d 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 b1 7d 70 0d 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc90003017920 EFLAGS: 00010246
> RAX: ffffc90003017900 RBX: 0000000000000013 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003017988
> RBP: ffffc90003017a18 R08: ffffc90003017987 R09: 0000000000000000
> R10: ffffc90003017960 R11: fffff52000602f31 R12: 0000000000000000
> R13: 1ffff92000602f28 R14: 0000000000040cc0 R15: dffffc0000000000
> FS:  000055558dedb500(0000) GS:ffff888125ddc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffef4504a80 CR3: 0000000072ffa000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2418
>  ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:5583
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5614
>  __do_kmalloc_node mm/slub.c:5630 [inline]
>  __kmalloc_noprof+0x4c9/0x800 mm/slub.c:5654
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
>  raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:1162 [inline]
>  raw_ioctl+0x18fb/0x3be0 drivers/usb/gadget/legacy/raw_gadget.c:1325
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fccefd8efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef4505ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fcceffe5fa0 RCX: 00007fccefd8efc9
> RDX: 00002000000000c0 RSI: 00000000c0085508 RDI: 0000000000000004
> RBP: 00007fccefe11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcceffe5fa0 R14: 00007fcceffe5fa0 R15: 0000000000000003
>  </TASK>
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

Since the maximum packet size of the endpoint descriptor is a 16 bit
field, we can make sure that the io->length is never greater than 65535
bytes.

#syz test

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..00f5e697d321 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -667,6 +667,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
                return ERR_PTR(-EINVAL);
        if (!usb_raw_io_flags_valid(io->flags))
                return ERR_PTR(-EINVAL);
+       if (io->length > USB_RAW_IO_MAX_LENGTH)
+               return ERR_PTR(-EINVAL);
        if (get_from_user)
                data = memdup_user(ptr + sizeof(*io), io->length);
        else {
diff --git a/include/uapi/linux/usb/raw_gadget.h b/include/uapi/linux/usb/raw_gadget.h
index f0224a8dc858..effe8a543c75 100644
--- a/include/uapi/linux/usb/raw_gadget.h
+++ b/include/uapi/linux/usb/raw_gadget.h
@@ -106,6 +106,9 @@ struct usb_raw_ep_io {
 /* Maximum number of non-control endpoints in struct usb_raw_eps_info. */
 #define USB_RAW_EPS_NUM_MAX    30

+/* Maximum length for raw endpoint IO */
+#define USB_RAW_IO_MAX_LENGTH 65535
+
 /* Maximum length of UDC endpoint name in struct usb_raw_ep_info. */
 #define USB_RAW_EP_NAME_MAX    16

