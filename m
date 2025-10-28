Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF5BCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7CB800D5; Mon, 27 Oct 2025 20:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F23800C9; Mon, 27 Oct 2025 20:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCA4800D5; Mon, 27 Oct 2025 20:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA19800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:41:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45632B7CC1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:41:04 +0000 (UTC)
X-FDA: 84045668448.05.3232D33
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 621E010000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:41:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=auJ1dV7k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612062; a=rsa-sha256;
	cv=none;
	b=ViGXCCeMc3EMxiPpbRfVcSTQ9qMJyyzkwosb5woK8JdTFFfGLyhpNExwEhLR6RME4jFepq
	2QKyPVQi0gmeTceSvn8KuG/6kPtrZ+g5I1ejkszCul3ltdn+OA9Zb2ngeMVpjyh0LXwpCZ
	cTLq8hdemWU3ywo+S1lIGi3vpISwg9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=auJ1dV7k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTZKuu154COSpnPLl48ObswEBLGYmmXP2lWfLIZHQnI=;
	b=pVJJa1FQwzQYHh77ACwOfM5RwpARCHe46HGNv2mWZmI9uFs8TDsR7GWaYtUfdf3j6/Kms2
	PL/bnfJHHOygkxBpcr1EtMMfLOPlbtUMxLMeHXMy52HOeDpM5RGE378hK7lvoVwDRQ6tVA
	2akxPUdiaUyz6E9QlHlnpBfqXpxhTrw=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a27c67cdc4so4067996b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761612061; x=1762216861; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oTZKuu154COSpnPLl48ObswEBLGYmmXP2lWfLIZHQnI=;
        b=auJ1dV7kkY1tnTYkf8Dtn8kj0f1G2tSn9zXpY+i6piinTaVpppnwwekr0nkEB7eveE
         iWlRg+sCe/KsBTA9gcqBBABgCIUh/r2NuAP6ZIrGh9MPJiYaw2h9hM+umGaxFVEBZ5it
         ig4sb48f997wO3dil7oZWOa2N9vqRLzxbOPa0v9abueaEtJ8PSlsCsNIJnbypsMrOoBh
         5PpdD1ACZ46/vSxkICc5TOnI0GgtcM+R+6o96JPlw9TBjgvDMJRGxNiBq4hlF+q/xBbP
         ATtFiG5ukKdmMNZ6GhuWONMw6jCFatZcost+tjNvYnCbqPlR6xgbZ2iSkQgjMyXFRCtC
         O+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761612061; x=1762216861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTZKuu154COSpnPLl48ObswEBLGYmmXP2lWfLIZHQnI=;
        b=ZHYVggHV7FFnygjahAzzk57Qs8f8dudkPStxVAQ40I5gbztmsEDqbKleLomwYcucZv
         InpZVV2E3maVchxfaNBGwO6/Tbow3dCIVem1R99J+novzy+BfqcZu2FRVzFDLSvP/XNw
         2XGDzqjKsaY5aAjTNymTNh29X0N2AHJQ1rEX8g0muO2JXZTES3LhxS09mbdFeAn7qcRn
         bjXMKMjPbujeFDsIGYOU8u5ntiO7pLMTXr/5A+cmcPfIlcg88H+wn7b4j1vF4jNon+R9
         R9OoveYC4nho9oPMA3aEu2cEuNV1mpDMNTM6UdeQWwoKMuSxroGnT8oGQKOXca2khRDg
         eWFA==
X-Forwarded-Encrypted: i=1; AJvYcCVNsBcNHTUPLoSG10S3DwT86E4SgIAzNJqxfC61p7csfQxycz5az3qD3DYofoMo4MZze/Z7vpCBgA==@kvack.org
X-Gm-Message-State: AOJu0YzU9Xa21EQefXZqVlM2FfuJSja5XVifa1K86Q2VtxwjIgEJOjk+
	CKFjmUkWGNPfoT0XDHIkYsFAORqQdLs0FnxTeofNudmUtJjsd7FOul90
X-Gm-Gg: ASbGncuhH3iGx78QJcq3BxNDoN08XqdiqKA/gRbX6hTQ4Hk8HFvuP8fFvseOXfiKVVS
	v/M8A3N5v6uT1OW+Rfz00sSc24Amy/SY2Wx55pI7skLzkYv3vFx+JCoYmJi9mscAT57dI667Ra+
	3Qa40+AvJZeKY64+oLkTqfwVUmUMuKmSmyUmfH2kuj+sqQ6QOt3S010RM1svyTqCSTAN36CEakh
	GKKe1BMUfYIq34auMJloYDmLKmsGGt3DGpxDgfBKsAkpavoMLF6LWZjEpObc+e9ZegkjKBzzyFx
	liE2dnCOAyFchSErVSF9IAsf+s5WNE5I4E12dLEC6MhE47MnUcWltIe8nL6U5fx6NlRzghXgm+w
	ae4NTmZdUWsN2IOW79TNWkJmulAD8CigFaEdmLO1AUMRz8tLQO9jm1JjVTILAQJkukYnCgp5pyP
	97eiQ=
X-Google-Smtp-Source: AGHT+IFmsoh3DyzGhCitu8owq5rBNWE8sw68jDqRcZrbgvaDViF9SipBAufhFBd1b7TwfZB4Yh4BiA==
X-Received: by 2002:a05:6a20:4321:b0:342:a7cd:9221 with SMTP id adf61e73a8af0-344d228acadmr1888008637.20.1761612060915;
        Mon, 27 Oct 2025 17:41:00 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b71268bdb2dsm8846839a12.5.2025.10.27.17.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 17:41:00 -0700 (PDT)
Date: Tue, 28 Oct 2025 06:10:57 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_alloc_io_data
Message-ID: <szusm242ai65p5eox3sblk225p6njf4kfahcgn4hkocwwvzh7l@3pfzgljcwzll>
References: <68ffe1a8.050a0220.3344a1.03a0.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68ffe1a8.050a0220.3344a1.03a0.GAE@google.com>
X-Stat-Signature: 76qkyx8hfq86qtzuoeh4irzh4ye1c5xd
X-Rspamd-Queue-Id: 621E010000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761612062-406265
X-HE-Meta: U2FsdGVkX19i3mx/L14TgWN9INIn6pxd6MIXCQAqkTD6MYEazcKcrX5S02lanklkdI5yXEohYzBCVQhU/y9IBi64g5Y6oHuU9Cgv2UDGKL/mS9821gaY5cmSuocAwnaw1x7xJ6d35Vrsocw5fFwwH69kWpSmVLhx04wI4Tj/Q7GVZVHfUrvcdsYIoW2PzqHqR5n+vgRj4GUYnrtDgYOR8Te1H+1qurloFtfq347LV/zFLr5oM3IZSc2BEYDM8pIdEdDQ7dRZuSsYhIpzIgkkwOEO0C5AJvp91D4CGWd4iOsjchsqTkMAU5/jRUFJD+WYmL7cqzCt+pyvLfXuLIJeOVr+ai+aBW23YRU5BNPibsbRWEkovIjs632chHggSvj5fnVqwFoPxYh2f1OR2LZBAHoWOHsig5t7wZ/6f50f081oaGxItErNisjjQ87gmBMYGpNY9y0xiqhYl8Mav/ZttaRRBhXIIiTa3UD7wEeBocqMfr9tNG48FkjueBab1ik8VsKpjHzl7+zSbuMPoe5H1GdBoBYjsoxKambOYB4cpj5A1ckITcUX6YzcdakdakZEmLkB2U3IMunizuMyyTt45YtkuXhvLmRfo9Y9JkVlwJIxiWOlRvj3t03w5UjH5PnMZ6Iv8tNiGKQME7GXsUn06J3ZxGQHq8H1aCA+owihk+DD1lxkKJ1glVx6S4+lpCCOmhHyQCJtGdUbQqA0JTI1qWDGeHV12EYtxUBJSVsjOxtUlWYOKfCTPGDblTGpFCtb6veuQ0W275ThtnIDW+pSC5hX/7bcGZYbOwvCPvFZOmDNAOLsvqdWsKOO+5xNn4v5XBR7ktjLKp5Sywp1vmu/aZa8EvHKpR0IkiDFv+prOmjwUjEHiqbpUcgNWmPkll5068Zs+10kpA5SYGpegwpjzHFu1XRt//dY9+Rv++ksMdbwf4mLljU5ovFabqM8wxA8mppmRXWbMuWcQQn/5Mg
 H/MPHEl+
 CL07FEylVOaN68/kOhSXUCKvSIL0/dHVAdncF75EDOq6RYYoOb4cYqBnBBtVYyQ8/8Rh6ClnJit6LY0Q3od/mUJ8JsuvRim5+GW9oK+6QkLY25USKCZpem/3KA7xwuOPyyjIrnBvbO/fZ8MTr63c3sujOAWY9nRyI6oZEhvXi3M5OlJITKbMFDc+zV/8GFK5jkI0lf/NYOcKXCOqzfsoK+KmeoqqrTeBDlAdr/v9bSwQ5tT/3URFc8/42cE1XAKK99MkdlC6AwAlcdGMYz/SFfqkkbVeGlOkeLJ5axDKMzVwcvI/JZY0mNcaKy/RI4ln7tI+0E147wxdNinggWQcD8TNIbYatmtryhh30bbSHKTjWMJE3t4e0U8owTWSlUsspeMIVuQkfmL1R3RjZrDJmLLUVoXqxpDGewAqQSmv/vYE9WoUiJJOsffonmZKkSCMIlb5xpP9IxvdM2eaMLwiN9PZknHvuDgjJnyj54RBRscHiG1WRP9M37EZIF/izpPhz7dENKW+1dl2fVvkq5udxjTFBQdZ7vthqMCbFe0/mxU+npPHdfhqj+qxFTMo7h+cddtYJvwzS6x5UN4Kq5qXUVF3BewccgIQeLUA3DutXt3gtq9q7gmKfh81Kr4l9diihh9icn9SkxsRh7oBe6Ks1A/wUWzk6tXXiPWntAOfmMr2tjH5Y/ZL8NG8RleM7ZXlBiC8weRKH5UElqP6ZEQWTh0lXROqfedvbouLAG9/BRX9aLsfoc/HTtfeEpkIt9ebPtqNLM+zM0B5C03X1bLX+dyKIZ8ATvfZpz8RHGT2ilKlGf4/qanx11ltNWpXzh4wtL2lmJKErT2wfE4mbP+NF+jJCZdjdXe7te5MDctpvaGDpgaY7EfP+PbWQkQCthrTBBE5qt1kqHouqR3HRKOx49uLwSYDzkzRVszZWn/3JI2DjowO0eNjfg7+WoGGRzV6uO1AkkWlxIO04ieFlwBfkiu7WYWEc
 TpPfmQ7/
 9HWMY75vawF5YKjpMsAWRR0zj4BddoA4aCLnLMtLwhHAkcdUNrHz5it7WU2SPVQmpqE1zd4sl+IS2gT41dFOd/Mdd6VWiLMMFeCmqwZJ/iz6N7d9wgDRCLMmWrkmrvg977p3CtNzs9zzqH2SvplUqgD7+em3AvjvP9xeT5f0bjQ3yIdkxeedw3zp8tTvKFxWHvZYZiLgKUq+gdCBl4JoTTOC/pfopHRRa8XZr6/wltoXOpekpCpBA/b+UCd1UK803rbqtpihIZm7tvD4z4I9ILtxEVsx8AgrkCVvV4mCsql+aVgXp8X6KXm1VavibxIfdzhOLJ7MIEC0MiEAhLJRWok/Ib9Mas0o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 02:18:32PM -0700, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dcb6fa37fd7b Linux 6.18-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=160597e2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=609c87dcb0628493
> dashboard link: https://syzkaller.appspot.com/bug?extid=a894fe5447d0543e89c9
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11af27e2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c2d614580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dcb6fa37.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/61176fd888a1/vmlinux-dcb6fa37.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/84e7e9924c22/bzImage-dcb6fa37.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 6091 at mm/page_alloc.c:5159 __alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
> Modules linked in:
> CPU: 3 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
> Code: f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 83 fe 0a 0f 86 0c fe ff ff 80 3d d4 63 52 0e 00 75 0b c6 05 cb 63 52 0e 01 90 <0f> 0b 90 45 31 f6 eb 81 4d 85 f6 74 22 44 89 fa 89 ee 4c 89 f7 e8
> RSP: 0018:ffffc9000371f9f8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000040cc0
> RBP: 0000000000000014 R08: 0000000000000005 R09: 0000000000000009
> R10: 0000000000000014 R11: 0000000000000001 R12: 0000000000040cc0
> R13: 1ffff920006e3f55 R14: ffffffff9ab2c464 R15: 0000000000000014
> FS:  000055557bf92500(0000) GS:ffff8880d6d0a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f84d9710300 CR3: 0000000032452000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
>  ___kmalloc_large_node+0xed/0x160 mm/slub.c:5583
>  __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5614
>  __do_kmalloc_node mm/slub.c:5630 [inline]
>  __kmalloc_noprof.cold+0xc/0x62 mm/slub.c:5654
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
>  raw_alloc_io_data+0x12c/0x1a0 drivers/usb/gadget/legacy/raw_gadget.c:659
>  raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:776 [inline]
>  raw_ioctl+0x1397/0x2c30 drivers/usb/gadget/legacy/raw_gadget.c:1313
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f84d938efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe768729f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f84d95e5fa0 RCX: 00007f84d938efc9
> RDX: 0000200000000080 RSI: 00000000c0085504 RDI: 0000000000000006
> RBP: 00007f84d9411f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f84d95e5fa0 R14: 00007f84d95e5fa0 R15: 0000000000000003
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

#syz dup: [syzbot] [mm?] WARNING in raw_ioctl 

