Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAADC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743BD6B0088; Tue, 11 Aug 2026 16:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDAA6B008A; Tue, 11 Aug 2026 16:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595426B0092; Tue, 11 Aug 2026 16:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2722B6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:17:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3A5C1C0071
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:17:43 +0000 (UTC)
X-FDA: 85090099206.19.2F5F542
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id DB04A20004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:17:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ItEGM7z1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786479461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKM2tGwtzp4e6RueqUAs7VBHsTzEw1WbCk0gGA1/KvM=;
	b=OS8FcC02TqqMjJAVUycHEzgXkLYzUq4O/qluteeprtGyRDxzG0UWwZgy92pnQzvCqxau28
	JryHN3zMtjSnsU56Nmd+jqEt2NWuRTV2g9WiBYToSdObyqPN4+drgtBQUlBxQleWokHLz5
	m2hVpA1kri6J8A2bR/XMaiXLgtGoKT0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ItEGM7z1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786479461;
	b=8O7MVTqo6S1tWjgiJTSRXpIDr+YF/wqiW1hbya7BOrLqSbvWPVC1/2gBd06Sh4FjlG3Fls
	7zbk22yC4rzhe86wBSmPI1oMq6PFQtpakYPe9I/rY857Atopevd1fJTYeOCeLy3zUBkQFN
	DpvglFTjBQnzBvo0sHoT+2k/7NrCHsg=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so193362a91.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786479461; x=1787084261; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BKM2tGwtzp4e6RueqUAs7VBHsTzEw1WbCk0gGA1/KvM=;
        b=ItEGM7z1w2Ehs4ERNJPnYfiyqyQnVmEcgGopDCTijB+wzSbx7hmSDY4Ex0KVc5EPwd
         bTTX9oYEK06gTiraXLZOd8861LWRoJ6Rxm4jUN4+yPlMmDa4O4DWcDyr6tNOu2O4Zvjl
         AzOcNHGlIRH4q/s+9/1hXIa0623rBkOIs6zp3cm+t/i41zSNzl3G4WAA1rp5btdFhbzR
         St4fJYH6bLrVg0rGgpZ73Kc94sY3QDIKerQnKwdmt6YwMeUXgBisyhkt9QnRFsTz5WXF
         rkaOU/FWKgdAbaztrUAGUaa5f5JPOUg1RB5T92fmibC5LInd6nSPWcx+HTTIRXTzaUyH
         BrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786479461; x=1787084261;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BKM2tGwtzp4e6RueqUAs7VBHsTzEw1WbCk0gGA1/KvM=;
        b=OloYt15k3eIvb/4T3SGdrYwf9n8H38PYYb0P8rOgozRKQS2DvUjZEj53E8IZxXFbPM
         9Wp0dHx0tXPZU28584Dhg5jLrauZjml+3eorFNmEWOBWYLzyWOHjBj8xuyxXI8u5LRpX
         dyd8gBJKeyPgE2Qz8WPiiEyJdsOo3JCWU6JEWvW4DTXdMOiiLYwgowfULPHwUpaVZ36O
         31f1lOG2bmxywKDbyBfsoJWRu0CSZsJ/2Yg8jGsf1HtKOQkMgZ6z+H0lB72GlJ3vqDwz
         d+PQCIPkEKs38M9NzuuEnxcAGPHjQPEAC1pN2H0jqxkkFCjUi2bt71G7fDaCwphwRuhW
         J6zQ==
X-Forwarded-Encrypted: i=1; AHgh+RodUJnYZVbCd/90uNmO9GHYpbgcBpP9Eh3vfMcSzt8Nkzqj7MNHdcmGFsSqEcNV63THWm8D69o5gA==@kvack.org
X-Gm-Message-State: AOJu0YzwuMc/ao43bsayELbAd5JtyMxJ0EO07yeg5FTvaZg5+bY5dJCU
	7HIrFbJPqAnJexIf8xa4xWGRZ8QW4vyMGRguxFdpfwYiyG0dHsvnrH7A
X-Gm-Gg: AR+sD13XAIc79CQbh4TBga+nOXLCagNlF8ce1AvTI4NUZY60i2vNmqwyBltjrokB9CK
	Fk4uA2Ctt7DOtiauC4A41kHEH6e62QGvR6UvczLP4kKzntC4+K+vdVfWGMFo4E6iX1OxBLG+1Fh
	LT6neP8z3lGbMXSsdE3v4hbzdCkkUZugBWF9b8iZsonMavP0SeqRcuAYjsd/gaMKJD1zoIxWZ4H
	BbbKtzUqbTfW/Y7IvOk2Im2YnpIA1gKjuOvX/srbxbMKuFcCXWuPYT13XPzVo6fXPHJhM9QrYYG
	Jw3BBplQ8PaAnhIwQ5t8tfC+jK6xUZAsRDum48WCwR41LmX39JMYyxB3aEHC1qVjIW4D1sTUxKk
	obiE+LeMRGDSL4ISdcK3MTWi6wn3FwulEwS4tTRb2Ggz2pUO3hNgdjlu8Lki1TeE5VcdT12Z6zp
	84koGP9CjtZoO1wVJqI9vLs/GQRONqDHUC1xJ90RocDphLhB/vJFVGr2MB4RuPzBkGz9RN5ayUj
	dqdv95u
X-Received: by 2002:a17:90b:2541:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-392ec2fc235mr7508953a91.4.1786479460554;
        Tue, 11 Aug 2026 13:17:40 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f94d5cb7sm789672a91.15.2026.08.11.13.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 13:17:40 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:17:36 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Max Boone <mboone@akamai.com>,
	imv4bel@gmail.com
Subject: Re: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-ID: <anuDYOPa0kTD9bul@v4bel>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-2-imv4bel@gmail.com>
 <20260811123702.f3c60a3573e148c53ad35b97@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811123702.f3c60a3573e148c53ad35b97@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: DB04A20004
X-Rspamd-Server: rspam07
X-Stat-Signature: 7og8wacd9x58jp4jb7oprrffkfqzm73w
X-HE-Tag: 1786479461-893236
X-HE-Meta: U2FsdGVkX18oGi5DU24xyDKMOhdkOF4gJSwRnLbk4iXYQauINottxBuDJ7Ztm8LqGdGHIriZN4JXIXpmbLj0wW1+XKS07VMz0570DSifRobauEx+zWdYzgUA7+AVnBmZRXq6IvRvih46saUyjQSptAHtMTAhaLEhXsq6JXHyArC3Qurcl68nF1GVJbnODXLsnnQ8NXQT3J3iASrDlF4DZCXdL41OtUc0DThEuiQBDTNsrP849bipOqpNEaWMHhdP4gtzSsUCZvJGgAvzzHmFHsBKQCYML40CD+Y4GCdlfNnV2rMOcoga+FIpZO+/wg4KiS7c6vIeZbKgLeay0K9F0p9QD9IRV4CmPD4maBReZQ6hNoapoOu8hpg+VrLn4K/P1r4PI3+XP6fKP4DfAboCsSR3H9KKa2ioDFmoPrujy1k5wycLHdyc1rJVpMBkpfCoKjS+cn7Ciq4vnNE5fpcSR5rK9OAimmGOdcOkahEiTzMNqXkJlSV6LRDSBV1IcM0SzduBrqILw5/Lw0d4O3LpIKlo4pW9zDOZNt3TsliKuu0X24u/IiB9whwynelLNMuh0uQYDPj/9lG+ko3o3B71bG8Jkewo5SYffc7bYdIOsv2H+XnRlbdG6O6+3fSuVIQGOteVb/QR/eWvc+D555Z6OfDY3w2CVsmW0I7ytDq5fmyk8oF6zxwifa3XjQGpYE1ES6+WAx4kx8yZresRYjGZRBaBT0aqWqb3/ZzwrTzDmXg4aXIDXLmeww2kgldoOWE1x1vwJAEr3bn8qnCpkeUpcXiMlfdqOrH1kf1MMFrDnXSuVGRQt2rJHRp+ZdF++XRIrSqXktOiAeNPwcSEurGjUFXuyUgNWgFzbARLaDVyzEX6YS+Bb1S1ql3LdIvGZKG/ELdyumoZXwoQ5fuisqTTu0OGrq9E8TaRWfKk+jJJKmZzXglS4OwYWq9lrP22OIvE1uq0Tj36jQ1UExWAmk3
 m2lXJVOT
 lwwYGPgys5eVuLdNp4xJ8gcIida/c6RpRTg/oBoxc+lJhXj7Cic7G3rpqJ/NnvkEv8EhkRRcCdDJhcsEeMTYlrh6ei8MFV3XnYBiHW1nfA3eGmVOrFIbxEOlahWtM9S8wIg7FjC5/cqTT5lhYtTQdC2DHVX4zmDdB3XCQDD+RK0AahbzziwKwF5lKC4E8Jq6pxcSg87WdjbGDl9aAOQMz7oR5C4zo6iT0p6eZnbZFekcoJNtzvuah1N048t/TSz+gF67CV1zmdBLkfEtprAvBuuYMvOW48D0cPsQSiNElOS/R6gtKKhd9Tj9rhjrMuE7rOjTek04paRsYOBImwL8mTVw5hWJcESiFszEadDgBf6GGpeTW9DOkENCAnRhb/n3p6DzOoK6uwZcvuhqX08cltZXmNRxDOLhhRGjPPr49p43Y7gUDcZ46YwHqmNWzpBwu8kc8wbvcfCRG1fa4NN23ES7zn+T50HnasuuFObc0f2adAl9K4ZgDFV0tl/tjmVqNA8nieF8kA7UC0FVhELk6A//lRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 12:37:02PM -0700, Andrew Morton wrote:
> On Wed, 12 Aug 2026 01:18:57 +0900 Hyunwoo Kim <imv4bel@gmail.com> wrote:
> 
> > If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> > check is retried. The PMD entry may be cleared at the point of retry.
> > 
> > In this case, if walk->ops->install_pte is not specified, the code
> > continues to the next PMD entry in the range without resetting
> > walk->action to ACTION_SUBTREE.
> > 
> > This leaves walk->action erroneously set to ACTION_AGAIN, which is
> > incorrect.
> > 
> > This was incorrect but not problematic up until commit 3b89863c3fa4
> > ("mm/pagewalk: fix race between concurrent split and refault")
> > which updated walk_pud_range() to check for walk->action ==
> > ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> > to be retried.
> > 
> > In this case this results in duplicate walk callbacks being
> > invoked, which is erroneous and will break any caller that is not
> > idempotent with respect to this (and waste time for those which
> > are).
> 
> "break".  Please describe the breakage completely.  It's really the
> most important information in the whole effort.
> 
> IOW, when fixing a bug please describe the userspace-visible runtime
> effects of that bug.
> 
> eg, what were the results of the fuzzer?  

To be precise, this is an out-of-bounds write.

> Is there a Link:?  

This came from a local fuzzer, so there is no Link:

> A stack trace?

[    2.272695] ==================================================================
[    2.273471] BUG: KASAN: slab-out-of-bounds in __mincore_unmapped_range+0x14f/0x190
[    2.274302] Write of size 1 at addr ffff888008d9b000 by task poc/106
[    2.274966]
[    2.275154] CPU: 0 UID: 1000 PID: 106 Comm: poc Not tainted 7.2.0-rc6-00429-ga7c7074b58d2 #55 PREEMPT(lazy)
[    2.275159] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.275164] Call Trace:
[    2.275170]  <TASK>
[    2.275172]  dump_stack_lvl+0x53/0x70
[    2.275200]  print_report+0xd0/0x630
[    2.275210]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    2.275219]  ? irqentry_exit+0xd2/0x670
[    2.275224]  ? irqentry_exit+0xd2/0x670
[    2.275226]  ? __virt_addr_valid+0xef/0x1a0
[    2.275239]  ? __mincore_unmapped_range+0x14f/0x190
[    2.275242]  kasan_report+0xce/0x100
[    2.275245]  ? __mincore_unmapped_range+0x14f/0x190
[    2.275248]  __mincore_unmapped_range+0x14f/0x190
[    2.275252]  mincore_unmapped_range+0x45/0x70
[    2.275254]  walk_pgd_range+0xafc/0xfc0
[    2.275261]  ? __pfx_walk_pgd_range+0x10/0x10
[    2.275264]  ? __update_load_avg_se+0x3d1/0x670
[    2.275275]  __walk_page_range+0xc0/0x310
[    2.275278]  ? __pfx_find_vma+0x10/0x10
[    2.275281]  ? finish_task_switch.isra.0+0x16d/0x4f0
[    2.275290]  walk_page_range_mm_unsafe+0x26f/0x3a0
[    2.275293]  ? __pfx_mtree_load+0x10/0x10
[    2.275298]  ? __pfx_walk_page_range_mm_unsafe+0x10/0x10
[    2.275302]  ? __free_frozen_pages+0x54d/0x7e0
[    2.275308]  __do_sys_mincore+0x132/0x380
[    2.275311]  do_syscall_64+0xf9/0x540
[    2.275316]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    2.275322] RIP: 0033:0x422ccd
[    2.275326] Code: b3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[    2.275329] RSP: 002b:00007fffffffec18 EFLAGS: 00000287 ORIG_RAX: 000000000000001b
[    2.275337] RAX: ffffffffffffffda RBX: 0000000000000066 RCX: 0000000000422ccd
[    2.275339] RDX: 00000000004d0940 RSI: 0000000001000000 RDI: 00007ffff4000000
[    2.275340] RBP: 00000000004d0940 R08: 0000000000000100 R09: 0000000000000100
[    2.275342] R10: 0000000000000100 R11: 0000000000000287 R12: 20c49ba5e353f7cf
[    2.275343] R13: 00000000004990d3 R14: 0000000000000000 R15: 0000000000000001
[    2.275346]  </TASK>
[    2.275347]
[    2.296904] The buggy address belongs to the object at ffff888008d9b000
[    2.296904]  which belongs to the cache sigqueue of size 80
[    2.298151] The buggy address is located 0 bytes inside of
[    2.298151]  allocated 80-byte region [ffff888008d9b000, ffff888008d9b050)
[    2.299408]
[    2.299601] The buggy address belongs to the physical page:
[    2.300191] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8d9b
[    2.301001] flags: 0x100000000000000(node=0|zone=1)
[    2.301535] page_type: f5(slab)
[    2.301884] raw: 0100000000000000 ffff888107e46780 dead000000000122 0000000000000000
[    2.302687] raw: 0000000000000000 0000000800240024 00000000f5000000 0000000000000000
[    2.303489] page dumped because: kasan: bad access detected
[    2.304092]
[    2.304276] Memory state around the buggy address:
[    2.304801]  ffff888008d9af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.305567]  ffff888008d9af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.306340] >ffff888008d9b000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.307115]                    ^
[    2.307474]  ffff888008d9b080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.308237]  ffff888008d9b100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.308997] ==================================================================

> 
> > A specific example of this breaking things is mincore which walks
> > an internal cursor data structure a byte at a time on assumption
> > that page table entry callbacks are called only once for each
> > entry.
> > 
> > Fix the problem by resetting walk->action to ACTION_SUBTREE prior
> > to the none check.
> > 
> > The pattern also exists in walk_pud_range() so fix it there too.
> > 
> > This issue was found through AI-based fuzzing.
> > 
> > Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> 
> It's good to cc the relevant Author(s).
> 
> > Cc: stable@vger.kernel.org
> 
> We really should tell -stable maintainers (and all other users of
> earlier kernels) all about the above things.
> 
> >  mm/pagewalk.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> This depends on the above info, but I'd prefer to process the bugfix
> promptly and defer consideration of the selftest until the next -rc
> cycle.

Should I send a v3 with the changelog fixed? (in 24 hours, I guess?)


Best regards,
Hyunwoo Kim

