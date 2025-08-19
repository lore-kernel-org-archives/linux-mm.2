Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45A1CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564A96B00A2; Tue, 19 Aug 2025 19:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BD06B00A3; Tue, 19 Aug 2025 19:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451A66B00A4; Tue, 19 Aug 2025 19:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 342176B00A2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:30:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCBC057CFA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:30:10 +0000 (UTC)
X-FDA: 83795102580.19.CCB4168
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73658140009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:30:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N0zVq2yM;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755646208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6l7bsSQ0BliIQaMwP9pOHR40vDGVY0S/bR0OOrmxBGQ=;
	b=cFBX89KWSmkky8YUsRn5852GyZ5yXrK+tRcaJWT7wUUeRq4HMuihcRx7Is38ULpMa/eBkP
	MbnSquvfPguX/ZgJ1oXg6Q6BMoJkz08YV4BCRvXM3q8SLpUIlWcCR7OMin1w+XlpVjYb1k
	oKRxsB2jSK7K+3HnNG/T8Kany3oOGkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755646208; a=rsa-sha256;
	cv=none;
	b=S8PlU/mvuX0xkmDHdRdDQR3h6YZZbARCNOm+3D4dnqJA7y53cg22Rm63E751LyCjsJmvNJ
	8yrg6JTsd8qYQcBvEfAdQSG37Qdfuqm77mFAJCNtTm245eo8iZ/U8WcPZ5uo/T3I2TiWFW
	0V7JiJdsY4uwonfZ4dumGWIimbO3HPI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N0zVq2yM;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755646207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6l7bsSQ0BliIQaMwP9pOHR40vDGVY0S/bR0OOrmxBGQ=;
	b=N0zVq2yM6+cA8cgbS4QqWR/g1nDiWQkJO1ZpWwbUG5w5WI/IgfrTL7gKBFlch0m8nHgz2f
	DZB3TjYN5xvXFYEYV8fjapJda9jKhP5KQR2bP2gjoupvJBPhhiKL1aQYU5zoyjLdOP41Pd
	ZXz8Nl5JIrVsLOQyt3eEN6ykUc9rzF8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-TA4KDY91N0yYOoixtd1dHw-1; Tue, 19 Aug 2025 19:30:06 -0400
X-MC-Unique: TA4KDY91N0yYOoixtd1dHw-1
X-Mimecast-MFC-AGG-ID: TA4KDY91N0yYOoixtd1dHw_1755646206
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-71d60528732so83371887b3.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755646206; x=1756251006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6l7bsSQ0BliIQaMwP9pOHR40vDGVY0S/bR0OOrmxBGQ=;
        b=O/ozjZgVEJ849zwWH8gfpxJwcWc8arVoRZU4L4iXAxZg9Cz5JR5pn382n+zHoezRxp
         POVLuyVB7ftwmUw++eOaXqh2J/NCksQBExT/kJ8mz1MdLLgDUGLoUKEdlkRaIX9wscT5
         9wsdyNA86GnVXFi9d6JvC4EsoQbS82zoVLQy/MjWR7fH3wUhj5QFu/kMywLGQ1NLvTUl
         NEck2W5USK3GIvGIZPRmbxf6qk8QiAJ76UJIJ/mtIzrk00n9aDfZTOEO8XS5oHH/2oup
         49FMZSbrQa7mpnhJFf1XIvX4/PCRBCnFDFRp1pTaehdZLkIlNqFyPBddrbkzqcsqSS6d
         GS1Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0ckLxDdogKvH1eJ5W7G/0pRShJ5TMRP/YjLbBohXRMANXW8nRD0+wph2ERw0/WHnXqEv/vTTTRw==@kvack.org
X-Gm-Message-State: AOJu0Ywg4w3WHLeL8YVARqEqkD+bPi3TcoeMO517ANQkoubIi9TfrgJD
	HuQR8dJxnsk7ZNZ+9bacwyaD3zk3/KBssBqQkon+HIIOMxVvdyfSk+ykNZW51Ho/84DlyNumaI/
	P/h4ThtaE9CRzzwgfWQTMgWDS7CFN9JQk0XZY5Pm/jzqKDqywupCX
X-Gm-Gg: ASbGncvt53kwTQGeYfuKXOilXsIHdKEQMFBrvHMRitco6tFNxWatraxppWloy7LuFct
	YYDwPLPUF0I0yRvhynYyHDUn5AGAxwYMDhVaf3IOqwvXtnvItEuhfbxDOv6TM4qr0buHdaMabyA
	/nakkYKzLaUzRf4M9vh+9ZxH2Co2BEZRUmB4hkqCmzVjTNCQkEQrJG8kjj0v+Rib9Fzs4z28Rbd
	rhza4v2QCEgWiaK4QtZol2aJh6U2uuGkk1dPf/w3lLcLWQJ/hPadED5StdSVPsgOqJ9I7brisg9
	Kcelj3A2IPTe2yxvjWOqlMrLEImQmnAn
X-Received: by 2002:a05:690c:530b:20b0:71f:b6d2:f8f4 with SMTP id 00721157ae682-71fb6d3329amr2485557b3.14.1755646205883;
        Tue, 19 Aug 2025 16:30:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl9293d+FISc1yxakNti5mv3ASEASIx7qEYClFMjnZRgjukMGzSQBzWwKmNvCobMsxsSrvGQ==
X-Received: by 2002:a05:690c:530b:20b0:71f:b6d2:f8f4 with SMTP id 00721157ae682-71fb6d3329amr2485287b3.14.1755646205410;
        Tue, 19 Aug 2025 16:30:05 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e88c3867esm17654797b3.62.2025.08.19.16.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 16:30:04 -0700 (PDT)
Date: Tue, 19 Aug 2025 19:29:52 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com,
	stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH v1] mm/mremap: fix WARN with uffd that has remap events
 disabled
Message-ID: <aKUI8H2g7SXBX1PR@x1.local>
References: <20250818175358.1184757-1-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250818175358.1184757-1-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B0ldQoI2kqxS9D22AejNluhqSJUsV6x3fluODzFbkn0_1755646206
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73658140009
X-Stat-Signature: mhbt6cnwnecwquc8f46auy4jimkzsobf
X-Rspam-User: 
X-HE-Tag: 1755646208-820875
X-HE-Meta: U2FsdGVkX19+g7ZFJ06ZWLR01iiAnpgqjPjmlQ+ujiLnj7xadoetew7zg9KE6qr8f03n407rvqRUYQ28UZjs2Wm1XB3fGHx2JM4E38F8p1h+GttKNSoBOKoZcfpdpif0CbPjZPbLDvJ9pcd1PFlGDG6q7VFUd6id9d5Gx0PpKX9v44bBkGxWJepLO1HoBcWn+tvwoSKFF/AO5sNszQt/SK7DUW/3HumDgLV4tckOlTgaAmwjqcXkxB+gYzD52K7psL1zLAUFun1hFq15yhX+s6bb3/O2jbsWg+hm93Yjp5UJSjARBfsDgh1zEhEvcMxtY0FPzsUdvRGOk+2Wj0YujWg7LvEYoMdZHIGhwhzOSnWB/LEtjexTH8KQeNMj1vmaTOJZq+dBBbjNwjOJCpBDcphx2o3BhKxNGL0GNab045zlnWm5i9vhnFR41WpYmEL7SMg3I/NWli7m9NV6n1Bt9avi6iQHySi7jBFJNalVbHN4aRHH51dKty6hO56lmQLp46XeuEfQo4Ixes+U/8byr/LmytkqJ+qc40dwTX3oZFVUZd8DPNT2mlKH4e1A4d7OtmH3hvGgA+0rAXhPacJPE5BkWO6nrpV+ggemV7IFM7OsZOc/uaKxA2Y5F8nSp+v+HPjxDDzFJKRrk40ADsQ+nvyNW/rZbxpVug1GXu2fDy1kI8picLgcmTlje8jFT/dPbTafMMcaaIp9ByMKNFDrO4FJr0fCDlRry7AgaH4a29fmX9vo99sy0VCSbLhwA3DnXwE3qLknew3nQ5J4JrxNh2VdfR0Hm4ve/oSMezIYN3ND1F5SLJ4Fgce5v22j85ld6fpRi2D952YqgaXhcyl0mREkkkhR0gbfdT+twyYlgUAJgSWuVLrrfbvk7yT6xVBOjVGgiE+hp13yUVd2GdPQ4rcapbNeZlvByR6spwkJOFY5uL1RJdBO/y6WaXLH9bMlmGPhJ9soXZKGBUvxnzF
 IU/Q8U1u
 U8o9dm+2MKmsVILlpp6ybPITWO3mdSdcG8lO3kMt6FNviwuY2f7dVYa+Fu633V6yzSidrff3h/bnr98P+3YB9gNaQbtJWmm/W1traY2YezEORal4Do1FepDv9x5xBTG+kYZ17NnL79ORKqD4hBefRWDG3OYeK0WO2hFlUW1hrx12t6TGQxn2QzShBFLSVnhrBwRHO/vjzGqDndf4llPJ/MH7THHgYD4nMMAeH3iEfuoZDuHBQTouk86aVM1cdbCS7PRtFdAcwVPFTdlROKwnoKA2nrwaQHxpDyQNljnFpbhsdGqbVyoICswQjA26T24ViIm3kM4N3Oi1RuSzpVxi8cjB7c2CZS6GGtvHaOYFAxU15CycrFtTAf5l0SR9L4+30B7aX6ojpjMBbHO72TfhwndI4+16qplhmWOo5/9xujes7FU4myhZZdIxh0DgSEFKeAPqJf7Zp30+awhMX9bWVR58Fez5U4Kx6pPbjkZKub9m26u+JuEm0xZwW6KWeJWAqJqwqkl4lb85bcjQYNasdaSY0kxdbHPOoshzjqzQ2T8K5L5o8+p2tedmm5FUqMabBw0++S3ixog7aSg3xo/pMq7uvGOHsnVEf7cim4V5YVnTaSfPefHgwR4kao4pnNHd+4YGdeBmEB+Rz2G4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 07:53:58PM +0200, David Hildenbrand wrote:
> Registering userfaultd on a VMA that spans at least one PMD and then
> mremap()'ing that VMA can trigger a WARN when recovering from a failed
> page table move due to a page table allocation error.
> 
> The code ends up doing the right thing (recurse, avoiding moving actual
> page tables), but triggering that WARN is unpleasant:
> 
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Modules linked in:
> CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
> RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
> RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Code: ...
> RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
> RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
> RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
> FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
>  move_vma+0x548/0x1780 mm/mremap.c:1282
>  mremap_to+0x1b7/0x450 mm/mremap.c:1406
>  do_mremap+0xfad/0x1f80 mm/mremap.c:1921
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00d0b8ebe9
> Code: ...
> RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
> RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
>  </TASK>
> 
> The underlying issue is that we recurse during the original page table
> move, but not during the recovery move.
> 
> Fix it by checking for both VMAs and performing the check before the
> pmd_none() sanity check.
> 
> Add a new helper where we perform+document that check for the PMD and
> PUD level.
> 
> Thanks to Harry for bisecting.
> 
> Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
> Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com
> Fixes: 0cef0bb836e ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Cc: <stable@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


