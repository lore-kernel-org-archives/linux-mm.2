Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7351EEED612
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 14:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8286B0005; Thu,  1 Jan 2026 09:31:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476446B0089; Thu,  1 Jan 2026 09:31:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AEE6B008A; Thu,  1 Jan 2026 09:31:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD956B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 09:31:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B119E1A9872
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 14:31:07 +0000 (UTC)
X-FDA: 84283632174.17.E0A9B09
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id B529414000B
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 14:31:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CUT96Tdo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767277865; a=rsa-sha256;
	cv=none;
	b=tB+OTO2lVtziPqQpFUoAeLQYM6fpNFM0aQfauaMfxRDdL/plzadw+lSIG10fdBthlXlNlJ
	GxNqELeAJ+/dDuCEzyl1j8PPTGSCgmunMTI4U+9w86ZlCqIHq7eYujYET0oup62ceqjHlD
	snzzjNAqjypfSWPgliZqmb4CLuA9GSY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CUT96Tdo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aha310510@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767277865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dc+DWPLxMPA/qNB+thp6zR81K/frN8d3zUhtTXxDS0=;
	b=iSoQpaa65noiVpwbuoUl87shIueEHl6mIXSiFBHVHguLZe6bTNAuigSKvwDWTZJR9krB3i
	vQcCA2Bb1WuCPMrN7RuXI11xuC76sDVTS1ccJOu4f6MdDgsajoXRn2hmNmnQDwYFwq8VXe
	z/rfxNZjescdc1mpjr6GOS1JBQyC3GM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c868b197eso12683475a91.2
        for <linux-mm@kvack.org>; Thu, 01 Jan 2026 06:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767277864; x=1767882664; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8dc+DWPLxMPA/qNB+thp6zR81K/frN8d3zUhtTXxDS0=;
        b=CUT96Tdo7seFbU67VmwiVIwvWx2seOuPKZtBpCyRIuDyhU38aC51sNQ5aOKJ/TkXCv
         I3dHKPSiDTZs4xLBELWka5IPY+tgcSJ741mhEdXObMF7+MHlSj+BK+znADw87imtMvHL
         DNTGjnrc0TGnMHorH0xW+EA9N/p0GidTdLRBykbdCBn3BRia2zlMy0iQ2yKVmo/28s5/
         1hFBkFYvSyJxC50CXlH5DZqzU/xeKobWRWKW2adkHETDOw+uDYjpN8t19vlUAQ3yH9JO
         bj7Ix3f0nK5bFQW7pao8yLSbalRFx+BiAnTbbCJSdf3gjXBFK04TyxjEA4fBdksCU2ud
         FUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767277864; x=1767882664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dc+DWPLxMPA/qNB+thp6zR81K/frN8d3zUhtTXxDS0=;
        b=JIC9AWbkgTf01rxm7MqA4U6dAjn9gxg3PacftEOkhlMHAOpBcR7cd0p+JKjfWqOHVW
         Om5YO49qkboE40kG+oytwkKf2ZjLs5wGbFOEwZ02+XZP7HYCGmlfSlzrnGfIGzcUQtXH
         LcVV3SvsN8CWfkg4vrBfM7UouQZzyZwZ/ZOM5FZUWg1V1LjflHQzBuo+oQP68GxXRO3K
         D+FdXEY4lWIGTDYI7FIV4ZNJzkppvnltDyxPcubniIeBCBTBBM5+EEFtU2DXa4D6CKje
         J8IMGlJoVYCJyQHqiirF3aLkeyHTa8F6Auh8ez/Wg4HsCubkxBmXckRKyZOZoRsHhpHm
         033Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqX59N445CiRMHrbd+/briradOpwwNWB4/wMEJYN3WceS92MRFLPdYovYqSFanc0MeLpn0CieoLg==@kvack.org
X-Gm-Message-State: AOJu0YyR4De8c3PBg4hMVhchB343joA2sRLo4eFNR9PLJqbu98/Y7bwZ
	lwRLhkK5SLwNxK0A7F1m++c2N1hMZf7i4NMvja3dRUmSL/tBAFawcmfGsTEk9+Z8fkbUaFuZ5lm
	c0uNm7AGoY7Nq9PtBaTVVFNSNpVohS6M=
X-Gm-Gg: AY/fxX6rbKrDNOZOiE2Dx5lYEwz8NCasN6d4R3xWasvuDtcEXACQes4kIsw65cvdhW+
	J50PRjvmkHorcJBvZwJjAjalZ+r0whsUtAldanc3CaZTEWVlFP5RsnZoJc9Hxt1avQhHkv1nB9K
	+3B5/Wiozxsvn4Y91HXFF6Z9/J9SrwhiTPiSpzim7XK24+Duy07NZCuP8O5SyQAneD6iu45nfN1
	nwNn3Sj8y/BzravHLMPRInazR8SUAatkf3SgIk5bRY2NcZ7+LrM1noLqgyt8i+pKAMgyqdG1h2b
	jCcrFvim
X-Google-Smtp-Source: AGHT+IEL7FYMr/Q8jttj7hMa6AsIaqfsGXRT+y0V34lMaWMs6kVfVoIXykyZqdN//VrZfClRqlOMtXCtjG/CE3rl+Xg=
X-Received: by 2002:a17:90b:2251:b0:340:ad5e:cb with SMTP id
 98e67ed59e1d1-34e9212f362mr33410425a91.8.1767277863947; Thu, 01 Jan 2026
 06:31:03 -0800 (PST)
MIME-Version: 1.0
References: <aVTJt9M-A1BL8w5O@hyeyoo> <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
In-Reply-To: <aVZ6b2ri1iRpM-7y@hyeyoo>
From: Jeongjun Park <aha310510@gmail.com>
Date: Thu, 1 Jan 2026 23:30:52 +0900
X-Gm-Features: AQt7F2pRxKkwTyKi2ELD4fP99Mi0oJIWh8jBAfFW50Tq8oQwolAaEVaK-jdLrtY
Message-ID: <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B529414000B
X-Stat-Signature: 3z17ba3ygniqcnmsadupx1cnph59b9fn
X-Rspam-User: 
X-HE-Tag: 1767277865-678645
X-HE-Meta: U2FsdGVkX193vMEtqnx0Wl3OrFuS2TCZjypyTC7c6tnfmi+/absDvUx19R5ZaLiV3Hz/uaP0WG5ZK2vrstHQVy+BzNcu+y0HYsjRL7Kin7WeaCSlQ0r1i94Z5+eby0z3lG5vbo+UJssSDUStbTue2Uukg6U7kGc6q1bxvzK+dYreANmi4jT5/zJmmKc1Cv5rZXS2/hfUIiOHTyPtnrbJrT6n+a6VrcDwANrpc2/ejyr8dertR6Pr7FY83VLN5/Y55yFofjeI7TGkp/LT6zR5HX1KCj5qdWsr3Tvaxqctgy0M8qknuTEv5UIoMYV3AhE6h6WDsIdZkTDDnnU8QigBK9b6Y3VWJHaH7gwmKnLZWWg+wluDDyqHDZfgdCaJkyvoHLuJ48rbt3VoZBxj9Cw7hHslyrqk9F+wUHSFrwzHoXQ+qI7lzlUbBBmIigKZJZ2RpspkgaQ6CJWhk8fQDMMzNZqPe5U5v1DTyApok2hIfp+7ykhqUPmnwkHzv1vgR4+TUCCioaWZH1w9CmkfSH7g/vk5LqUIQ3IjjQYcNujLFngp2EXNTYVZfVC9G/f8D5hHQ5g9LcqOR6RDMwqPZcJ1KI77B8Lek3pKJCxZUA4juRqCloN5d2ejLexa8whMt87xxbMommkwiBIGdxvnZYVfZcD9VOdzSNiNxUGmW11cxssCzkcKpHqKancBnxYSrv+5hWEbKU49b0xVr6i3QwnscjbmN8MAZHZ+b1OipeyZoixpPfZubx4ec8NhK5BTWiX0b3ucDmx3T0a2b0OG1ZgUTV1Q2aqoWaKc9H2TCwtczxBY5lqxDxh55FbMAlZROsMCWRiAX75DS+z0fuaeYNbXzWDVDAdeVNlq5iIGBBdOaKT//nc6wRnN12rvMhHPv7k6dCMHs8JoEg3hQE6/BJzoGOHXpOF4aKuOb4nG/9g5ewpkIRFKGc7y8xJf3o1xQ9qzE9VKqaMf4brmnCukVzT
 /Tf7KHQm
 0/EnHdy9i2mqLqxzHC9B3d8rTmMfAZO2jNe0Jyz81B8K3oYCSdsFiR6PTi6wG0YfsG2XRZVYQQMtyayd7wHlwCvTQXUzz5CLu2mWTHj5jDeZqX1P8BsslszUYNFgu5Rg/5RwCanjtuK7g1wZz2zUf9XjG/dJLcyqSXHZ/Ux3zI81ghy0RhaKi9qZvLIqFtL4HpKd2bQm2hErkLgSswQVXKesrScKQSB6X23/3PwyLvXyJSjHi8FOsdKOOxauhLRV/DST1MY0I1BOIaMu2CN9/78UckiX5nmfDLhOCAsxIor14HO4Pf8eWKHRofjOnY1NW1cSAGwsBtyG7yoU9cGnrXLkL7jb7GKBfytc9SelCv86PHvDbSCtsP2G/8XEYOzNqGa/wFBC/lUb8+/trXr6X3sjXcucdXCzoyx+T1dgUHMCe3VcRWIJfP+4QxezMVYGpv7tRqMvU4B194lc8pU3GugcA/z1Ea5x+UJ8c00cA1hbthPLFyT8kYQ53w62aZ8wsacyR35HeOo9KyT8fYSY/tsJCqFaAdOwfQY4P14JH9WHtpZSpPKIsHJmdovbRnbfRe55gI9ggHhlwvFP98rxQdnYnQesaS050Zanx7o0bL02uqZktFLCAtuZf8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

Harry Yoo <harry.yoo@oracle.com> wrote:
>
> On Thu, Jan 01, 2026 at 10:09:06PM +0900, Jeongjun Park wrote:
> > Harry Yoo wrote:
> > > On Tue, Dec 30, 2025 at 11:02:18PM +0100, David Hildenbrand (Red Hat) wrote:
> > > > On 12/24/25 06:35, Harry Yoo wrote:
> > > > > On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> > > > > Perhaps we want yet another DEBUG_VM feature to record when it's been
> > > > > dropped to zero and report it in the sanity check, or... imagine harder
> > > > > how a file VMA that has anon_vma involving CoW / GUP / migration /
> > > > > reclamation could somehow drop the refcount to zero?
> > > > >
> > > > > Sounds fun ;)
> > > > >
> > > >
> > > > Can we bisect the issue given that we have a reproducer?
> > >
> > > Unfortunately I could not reproduce the issue with the C reproducer,
> > > even with the provided kernel config. Maybe it's a race condition and
> > > I didn't wait long enough...
> > >
> > > > This only popped up just now, so I would assume it's actually something that
> > > > went into this release that makes it trigger.
> > >
> > > I was assuming the bug has been there even before the addition of
> > > VM_WARN_ON_ONCE(), as the commit a222439e1e27 ("mm/rmap: add anon_vma
> > > lifetime debug check") says:
> > > > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > > > walks that seems to indicate that there can be pages with elevated
> > > > mapcount whose anon_vma has already been freed, but I think we never
> > > > figured out what the cause is; and syzkaller only hit these UAFs when
> > > > memory pressure randomly caused reclaim to rmap-walk the affected pages,
> > > > so it of course didn't manage to create a reproducer.
> > > >
> > > > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
> > > > to hopefully catch such issues more reliably.
> > >
>
> Hi Jeongjun,
>
> > I tested this myself and found that the bug is caused by commit
> > d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs").
>
> Oh, great. Thanks!
>
> Could you please elaborate how you confirmed the bad commit?
>
> - Did you perform git bisection on it?
> - How did you reproduce the bug and how long did it take to reproduce?
>

I tested the mremap-related commits in my local environment, building them
one by one and using syzbot repro.

[1] : https://syzkaller.appspot.com/text?tag=ReproC&x=128cdb1a580000

And for debugging purposes, I added the code from commit a222439e1e27
("mm/rmap: add anon_vma lifetime debug check") and ran the test.

Based on my testing, I found that the WARNING starts from commit
d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
populate behavior") in Lorenzo's mremap-related patch series.

```
[  105.610134][ T9699] page: refcount:2 mapcount:1
mapping:0000000000000000 index:0x0 pfn:0x5abd6
[  105.611881][ T9699] memcg:ffff888051abc100
[  105.612642][ T9699] anon flags:
0x4fff0800002090c(referenced|uptodate|active|owner_2|swapbacked|node=1|zone=1|lastcpupid=0x7ff)
[  105.614724][ T9699] raw: 04fff0800002090c 0000000000000000
dead000000000122 ffff888047525bb1
[  105.616213][ T9699] raw: 0000000000000000 0000000000000000
0000000200000000 ffff888051abc100
[  105.617791][ T9699] page dumped because:
VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0)
[  105.619364][ T9699] page_owner tracks the page as allocated
[  105.620554][ T9699] page last allocated via order 0, migratetype
Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 9700,
tgid 9698 (test), ts 105608898986, free_ts 104692063083
[  105.623518][ T9699]  post_alloc_hook+0x1be/0x230
[  105.624454][ T9699]  get_page_from_freelist+0x10c0/0x2f80
[  105.625446][ T9699]  __alloc_frozen_pages_noprof+0x256/0x2130
[  105.626504][ T9699]  alloc_pages_mpol+0x1f1/0x550
[  105.627383][ T9699]  folio_alloc_mpol_noprof+0x38/0x2f0
[...]
[  105.651729][ T9699] ------------[ cut here ]------------
[  105.652694][ T9699] WARNING: CPU: 0 PID: 9699 at
./include/linux/rmap.h:472 __folio_rmap_sanity_checks+0x6c3/0x770
[  105.654551][ T9699] Modules linked in:
[  105.655268][ T9699] CPU: 0 UID: 0 PID: 9699 Comm: test Not tainted
6.16.0-rc5-00304-gd23cb648e365-dirty #37 PREEMPT(full)
[  105.657209][ T9699] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  105.658803][ T9699] RIP: 0010:__folio_rmap_sanity_checks+0x6c3/0x770
[  105.659959][ T9699] Code: 9a 13 00 e9 9f f9 ff ff 4c 89 e7 e8 77 9a
13 00 e9 87 fc ff ff e8 3d d9 af ff 48 c7 c6 00 b1 3b 8b 48 89 ef e8
7e 78 f6 ff 90 <0f> 0b 90 e9 82 fc ff ff e8 80 9a 13 00 e9 32 fa ff ff
e8 76 9a 13
[  105.663311][ T9699] RSP: 0018:ffffc9000baf7268 EFLAGS: 00010293
[  105.664412][ T9699] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffc9000baf714c
[  105.665796][ T9699] RDX: ffff888020668000 RSI: ffffffff82089412
RDI: ffff888020668444
[  105.667181][ T9699] RBP: ffffea00016af580 R08: 0000000000000001
R09: ffffed1005704841
[  105.668591][ T9699] R10: 0000000000000001 R11: 0000000000000001
R12: ffff888047525c50
[  105.669977][ T9699] R13: ffff888047525bb0 R14: 0000000000000000
R15: 0000000000000000
[  105.671389][ T9699] FS:  00007f781689e700(0000)
GS:ffff888098559000(0000) knlGS:0000000000000000
[  105.672968][ T9699] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  105.674147][ T9699] CR2: 00007f781687cfb8 CR3: 00000000467b8000
CR4: 0000000000752ef0
[  105.675535][ T9699] PKRU: 55555554
[  105.676175][ T9699] Call Trace:
[  105.676786][ T9699]  <TASK>
[  105.677329][ T9699]  folio_remove_rmap_ptes+0x31/0x980
[  105.678287][ T9699]  unmap_page_range+0x1b97/0x41a0
[  105.679205][ T9699]  ? __pfx_unmap_page_range+0x10/0x10
[  105.680164][ T9699]  ? uprobe_munmap+0x448/0x5d0
[  105.681045][ T9699]  ? uprobe_munmap+0x479/0x5d0
[  105.681916][ T9699]  unmap_single_vma.constprop.0+0x153/0x230
[  105.682973][ T9699]  unmap_vmas+0x1d6/0x430
[  105.683757][ T9699]  ? __pfx_unmap_vmas+0x10/0x10
[  105.684681][ T9699]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  105.685740][ T9699]  ? mas_update_gap+0x30a/0x4f0
[  105.686616][ T9699]  vms_clear_ptes.part.0+0x368/0x690
[  105.687573][ T9699]  ? __pfx_vms_clear_ptes.part.0+0x10/0x10
[  105.688641][ T9699]  ? __pfx_mas_store_gfp+0x10/0x10
[  105.689553][ T9699]  ? unlink_anon_vmas+0x457/0x890
[  105.690463][ T9699]  vms_complete_munmap_vmas+0x6cf/0xa20
[  105.691488][ T9699]  do_vmi_align_munmap+0x426/0x800
[  105.692429][ T9699]  ? __pfx_do_vmi_align_munmap+0x10/0x10
[  105.693456][ T9699]  ? mas_walk+0x6b7/0x8c0
[  105.694290][ T9699]  do_vmi_munmap+0x1f0/0x3d0
[  105.695128][ T9699]  do_munmap+0xbd/0x100
[  105.695883][ T9699]  ? __pfx_do_munmap+0x10/0x10
[  105.696749][ T9699]  ? mas_walk+0x6b7/0x8c0
[  105.697542][ T9699]  mremap_to+0x242/0x450
[  105.698317][ T9699]  do_mremap+0xff4/0x1fe0
[  105.699114][ T9699]  ? __pfx_do_mremap+0x10/0x10
[  105.699992][ T9699]  __do_sys_mremap+0x119/0x170
[  105.700868][ T9699]  ? __pfx___do_sys_mremap+0x10/0x10
[  105.701821][ T9699]  ? __x64_sys_futex+0x1c5/0x4c0
[  105.702712][ T9699]  ? __x64_sys_futex+0x1ce/0x4c0
[  105.703629][ T9699]  do_syscall_64+0xcb/0xfa0
[  105.704463][ T9699]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  105.705510][ T9699] RIP: 0033:0x7f7816996fc9
[  105.706311][ T9699] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 97 8e 0d 00 f7 d8
64 89 01 48
[  105.709665][ T9699] RSP: 002b:00007f781689de98 EFLAGS: 00000297
ORIG_RAX: 0000000000000019
[  105.711123][ T9699] RAX: ffffffffffffffda RBX: 0000000000000000
RCX: 00007f7816996fc9
[  105.712507][ T9699] RDX: 0000000000004000 RSI: 0000000000004000
RDI: 0000200000ffc000
[  105.713894][ T9699] RBP: 00007f781689dec0 R08: 0000200000002000
R09: 0000000000000000
[  105.715319][ T9699] R10: 0000000000000007 R11: 0000000000000297
R12: 00007ffddaf7c6fe
[  105.716718][ T9699] R13: 00007ffddaf7c6ff R14: 00007f781689dfc0
R15: 0000000000022000
[  105.718113][ T9699]  </TASK>
[  105.718674][ T9699] Kernel panic - not syncing: kernel: panic_on_warn set ...
[  105.719943][ T9699] CPU: 0 UID: 0 PID: 9699 Comm: test Not tainted
6.16.0-rc5-00304-gd23cb648e365-dirty #37 PREEMPT(full)
[  105.721866][ T9699] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  105.723469][ T9699] Call Trace:
[  105.724047][ T9699]  <TASK>
[  105.724592][ T9699]  dump_stack_lvl+0x3d/0x1b0
[  105.725432][ T9699]  panic+0x6fc/0x7b0
[  105.726145][ T9699]  ? __pfx_panic+0x10/0x10
[  105.726955][ T9699]  ? show_trace_log_lvl+0x278/0x380
[  105.727897][ T9699]  ? check_panic_on_warn+0x1f/0xc0
[  105.728819][ T9699]  ? __folio_rmap_sanity_checks+0x6c3/0x770
[  105.729867][ T9699]  check_panic_on_warn+0xb1/0xc0
[  105.730759][ T9699]  __warn+0xf6/0x3d0
[  105.731473][ T9699]  ? __folio_rmap_sanity_checks+0x6c3/0x770
[  105.732522][ T9699]  report_bug+0x2e1/0x500
[  105.733305][ T9699]  ? __folio_rmap_sanity_checks+0x6c3/0x770
[  105.734354][ T9699]  handle_bug+0x2dd/0x410
[  105.735132][ T9699]  exc_invalid_op+0x35/0x80
[  105.735947][ T9699]  asm_exc_invalid_op+0x1a/0x20
[  105.736819][ T9699] RIP: 0010:__folio_rmap_sanity_checks+0x6c3/0x770
[  105.737962][ T9699] Code: 9a 13 00 e9 9f f9 ff ff 4c 89 e7 e8 77 9a
13 00 e9 87 fc ff ff e8 3d d9 af ff 48 c7 c6 00 b1 3b 8b 48 89 ef e8
7e 78 f6 ff 90 <0f> 0b 90 e9 82 fc ff ff e8 80 9a 13 00 e9 32 fa ff ff
e8 76 9a 13
[  105.741281][ T9699] RSP: 0018:ffffc9000baf7268 EFLAGS: 00010293
[  105.742352][ T9699] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffc9000baf714c
[  105.743729][ T9699] RDX: ffff888020668000 RSI: ffffffff82089412
RDI: ffff888020668444
[...]
[  105.790634][ T9699] R13: 00007ffddaf7c6ff R14: 00007f781689dfc0
R15: 0000000000022000
[  105.792031][ T9699]  </TASK>
```

And while I haven't been able to reproduce it again, I did have one
instance where a KASAN UAF was detected quite by accident during testing.
So, I suspect UAF might be a low probability occurrence under certain
race conditions.

```
[  142.257627][ T9758]
==================================================================
[  142.259362][ T9758] BUG: KASAN: slab-use-after-free in
folio_remove_rmap_ptes+0x260/0xfc0
[  142.261082][ T9758] Read of size 4 at addr ffff88802856d920 by task test/9758
[  142.262570][ T9758]
[  142.263096][ T9758] CPU: 1 UID: 0 PID: 9758 Comm: test Not tainted
6.19.0-rc2-00098-gc53f467229a7 #20 PREEMPT(full)
[  142.263119][ T9758] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  142.263134][ T9758] Call Trace:
[  142.263141][ T9758]  <TASK>
[  142.263148][ T9758]  dump_stack_lvl+0x116/0x1b0
[  142.263187][ T9758]  print_report+0xca/0x5f0
[  142.263219][ T9758]  ? __phys_addr+0xeb/0x180
[  142.263239][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.263257][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.263275][ T9758]  kasan_report+0xca/0x100
[  142.263301][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.263322][ T9758]  kasan_check_range+0x39/0x1c0
[  142.263340][ T9758]  folio_remove_rmap_ptes+0x260/0xfc0
[  142.263360][ T9758]  unmap_page_range+0x1c70/0x4300
[  142.263403][ T9758]  ? __pfx_unmap_page_range+0x10/0x10
[  142.263428][ T9758]  ? uprobe_munmap+0x440/0x600
[  142.263452][ T9758]  ? uprobe_munmap+0x470/0x600
[  142.263472][ T9758]  unmap_single_vma+0x153/0x230
[  142.263499][ T9758]  unmap_vmas+0x1d6/0x430
[  142.263525][ T9758]  ? __pfx_unmap_vmas+0x10/0x10
[  142.263551][ T9758]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  142.263580][ T9758]  ? mas_update_gap+0x30a/0x4f0
[  142.263620][ T9758]  vms_clear_ptes.part.0+0x362/0x6b0
[  142.263642][ T9758]  ? __pfx_vms_clear_ptes.part.0+0x10/0x10
[  142.263666][ T9758]  ? __pfx_mas_store_gfp+0x10/0x10
[  142.263684][ T9758]  ? unlink_anon_vmas+0x457/0x890
[  142.263705][ T9758]  vms_complete_munmap_vmas+0x6cf/0xa20
[  142.263728][ T9758]  do_vmi_align_munmap+0x430/0x800
[  142.263750][ T9758]  ? __pfx_do_vmi_align_munmap+0x10/0x10
[  142.263783][ T9758]  ? mas_walk+0x6b7/0x8c0
[  142.263812][ T9758]  do_vmi_munmap+0x1f0/0x3d0
[  142.263833][ T9758]  do_munmap+0xb6/0xf0
[  142.263860][ T9758]  ? __pfx_do_munmap+0x10/0x10
[  142.263889][ T9758]  ? mas_walk+0x6b7/0x8c0
[  142.263916][ T9758]  mremap_to+0x242/0x450
[  142.263936][ T9758]  do_mremap+0x12b3/0x2090
[  142.263961][ T9758]  ? __pfx_do_mremap+0x10/0x10
[  142.263987][ T9758]  __do_sys_mremap+0x119/0x170
[  142.264007][ T9758]  ? __pfx___do_sys_mremap+0x10/0x10
[  142.264030][ T9758]  ? __x64_sys_futex+0x1c5/0x4d0
[  142.264060][ T9758]  ? __x64_sys_futex+0x1ce/0x4d0
[  142.264095][ T9758]  do_syscall_64+0xcb/0xf80
[  142.264125][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.264145][ T9758] RIP: 0033:0x7f5736fa5fc9
[  142.264162][ T9758] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 97 8e 0d 00 f7 d8
64 89 01 48
[  142.264180][ T9758] RSP: 002b:00007f5736eace98 EFLAGS: 00000297
ORIG_RAX: 0000000000000019
[  142.264201][ T9758] RAX: ffffffffffffffda RBX: 0000000000000000
RCX: 00007f5736fa5fc9
[  142.264213][ T9758] RDX: 0000000000004000 RSI: 0000000000004000
RDI: 0000200000ffc000
[  142.264236][ T9758] RBP: 00007f5736eacec0 R08: 0000200000002000
R09: 0000000000000000
[  142.264247][ T9758] R10: 0000000000000007 R11: 0000000000000297
R12: 00007fff0d19497e
[  142.264258][ T9758] R13: 00007fff0d19497f R14: 00007f5736eacfc0
R15: 0000000000022000
[  142.264277][ T9758]  </TASK>
[  142.264282][ T9758]
[  142.319909][ T9758] Allocated by task 9759:
[  142.320665][ T9758]  kasan_save_stack+0x24/0x50
[  142.321497][ T9758]  kasan_save_track+0x14/0x30
[  142.322331][ T9758]  __kasan_slab_alloc+0x87/0x90
[  142.323193][ T9758]  kmem_cache_alloc_noprof+0x267/0x790
[  142.324151][ T9758]  __anon_vma_prepare+0x34b/0x610
[  142.325035][ T9758]  __vmf_anon_prepare+0x11f/0x250
[  142.325929][ T9758]  do_fault+0x190/0x1940
[  142.326688][ T9758]  __handle_mm_fault+0x1901/0x2ac0
[  142.327581][ T9758]  handle_mm_fault+0x3f9/0xac0
[  142.328424][ T9758]  __get_user_pages+0x5ac/0x3960
[  142.329301][ T9758]  get_user_pages_remote+0x28a/0xb20
[  142.330236][ T9758]  uprobe_write+0x201/0x21f0
[  142.331052][ T9758]  uprobe_write_opcode+0x99/0x1a0
[  142.331936][ T9758]  set_swbp+0x109/0x210
[  142.332677][ T9758]  install_breakpoint+0x158/0x9c0
[  142.333558][ T9758]  uprobe_mmap+0x5ab/0x1070
[  142.334359][ T9758]  vma_complete+0xa00/0xe70
[  142.335157][ T9758]  __split_vma+0xbbb/0x10f0
[  142.335956][ T9758]  vms_gather_munmap_vmas+0x1c5/0x12e0
[  142.336911][ T9758]  __mmap_region+0x475/0x2a70
[  142.337740][ T9758]  mmap_region+0x1b2/0x3e0
[  142.338525][ T9758]  do_mmap+0xa42/0x11e0
[  142.339270][ T9758]  vm_mmap_pgoff+0x280/0x460
[  142.340090][ T9758]  ksys_mmap_pgoff+0x330/0x5d0
[  142.340938][ T9758]  __x64_sys_mmap+0x127/0x190
[  142.341771][ T9758]  do_syscall_64+0xcb/0xf80
[  142.342578][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.343615][ T9758]
[  142.344035][ T9758] Freed by task 23:
[  142.344708][ T9758]  kasan_save_stack+0x24/0x50
[  142.345537][ T9758]  kasan_save_track+0x14/0x30
[  142.346372][ T9758]  kasan_save_free_info+0x3b/0x60
[  142.347273][ T9758]  __kasan_slab_free+0x61/0x80
[  142.348121][ T9758]  slab_free_after_rcu_debug+0x109/0x300
[  142.349105][ T9758]  rcu_core+0x7a1/0x1600
[  142.349853][ T9758]  handle_softirqs+0x1d4/0x8e0
[  142.350710][ T9758]  run_ksoftirqd+0x3a/0x60
[  142.351503][ T9758]  smpboot_thread_fn+0x3d4/0xaa0
[  142.352377][ T9758]  kthread+0x3d0/0x780
[  142.353103][ T9758]  ret_from_fork+0x966/0xaf0
[  142.353921][ T9758]  ret_from_fork_asm+0x1a/0x30
[  142.354775][ T9758]
[  142.355195][ T9758] Last potentially related work creation:
[  142.356179][ T9758]  kasan_save_stack+0x24/0x50
[  142.357013][ T9758]  kasan_record_aux_stack+0xa7/0xc0
[  142.357924][ T9758]  kmem_cache_free+0x44f/0x760
[  142.358768][ T9758]  __put_anon_vma+0x114/0x390
[  142.359596][ T9758]  unlink_anon_vmas+0x57f/0x890
[  142.360449][ T9758]  move_vma+0x15e1/0x1970
[  142.361214][ T9758]  mremap_to+0x1c3/0x450
[  142.361966][ T9758]  do_mremap+0x12b3/0x2090
[  142.362753][ T9758]  __do_sys_mremap+0x119/0x170
[  142.363596][ T9758]  do_syscall_64+0xcb/0xf80
[  142.364403][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.365435][ T9758]
[  142.365858][ T9758] The buggy address belongs to the object at
ffff88802856d880
[  142.365858][ T9758]  which belongs to the cache anon_vma of size 208
[  142.368200][ T9758] The buggy address is located 160 bytes inside of
[  142.368200][ T9758]  freed 208-byte region [ffff88802856d880,
ffff88802856d950)
[  142.370541][ T9758]
[  142.370967][ T9758] The buggy address belongs to the physical page:
[  142.372076][ T9758] page: refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x2856d
[  142.373580][ T9758] memcg:ffff888000180f01
[  142.374324][ T9758] ksm flags:
0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
[  142.375621][ T9758] page_type: f5(slab)
[  142.376325][ T9758] raw: 00fff00000000000 ffff888040416140
ffffea000082c080 dead000000000003
[  142.377805][ T9758] raw: 0000000000000000 00000000800f000f
00000000f5000000 ffff888000180f01
[  142.379284][ T9758] page dumped because: kasan: bad access detected
[  142.380392][ T9758] page_owner tracks the page as allocated
[  142.381378][ T9758] page last allocated via order 0, migratetype
Unmovable, gfp_mask
0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 7254,
tgid 7254 (systemd-udevd), ts 49831929003, free_ts 49824984874
[  142.384666][ T9758]  post_alloc_hook+0x1ca/0x240
[  142.385505][ T9758]  get_page_from_freelist+0xdb3/0x2a70
[  142.386464][ T9758]  __alloc_frozen_pages_noprof+0x256/0x20f0
[  142.387499][ T9758]  alloc_pages_mpol+0x1f1/0x550
[  142.388365][ T9758]  new_slab+0x2d0/0x440
[  142.389100][ T9758]  ___slab_alloc+0xdd8/0x1bc0
[  142.389927][ T9758]  __slab_alloc.constprop.0+0x66/0x110
[  142.390882][ T9758]  kmem_cache_alloc_noprof+0x4ba/0x790
[  142.391837][ T9758]  anon_vma_fork+0xe6/0x630
[  142.392638][ T9758]  dup_mmap+0x1285/0x2010
[  142.393408][ T9758]  copy_process+0x3747/0x7450
[  142.394236][ T9758]  kernel_clone+0xea/0x880
[  142.395023][ T9758]  __do_sys_clone+0xce/0x120
[  142.395836][ T9758]  do_syscall_64+0xcb/0xf80
[  142.396646][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.397680][ T9758] page last free pid 7224 tgid 7224 stack trace:
[  142.398937][ T9758]  __free_frozen_pages+0x83e/0x1130
[  142.399864][ T9758]  inode_doinit_with_dentry+0xb0d/0x11f0
[  142.400856][ T9758]  selinux_d_instantiate+0x27/0x30
[  142.401759][ T9758]  security_d_instantiate+0x142/0x1a0
[  142.402709][ T9758]  d_splice_alias_ops+0x94/0x830
[  142.403588][ T9758]  kernfs_iop_lookup+0x23d/0x2d0
[  142.404463][ T9758]  __lookup_slow+0x251/0x480
[  142.405280][ T9758]  lookup_slow+0x51/0x80
[  142.406032][ T9758]  path_lookupat+0x5fe/0xb80
[  142.406851][ T9758]  filename_lookup+0x213/0x5e0
[  142.407701][ T9758]  vfs_statx+0xf2/0x3d0
[  142.408433][ T9758]  __do_sys_newstat+0x96/0x120
[  142.409273][ T9758]  do_syscall_64+0xcb/0xf80
[  142.410083][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.411114][ T9758]
[  142.411534][ T9758] Memory state around the buggy address:
[  142.412508][ T9758]  ffff88802856d800: fb fb fb fb fb fb fb fb fc
fc fc fc fc fc fc fc
[  142.413894][ T9758]  ffff88802856d880: fa fb fb fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  142.415277][ T9758] >ffff88802856d900: fb fb fb fb fb fb fb fb fb
fb fc fc fc fc fc fc
[  142.416662][ T9758]                                ^
[  142.417549][ T9758]  ffff88802856d980: fc fc fa fb fb fb fb fb fb
fb fb fb fb fb fb fb
[  142.419228][ T9758]  ffff88802856da00: fb fb fb fb fb fb fb fb fb
fb fb fb fc fc fc fc
[  142.420929][ T9758]
==================================================================
[  142.422724][ T9758] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[  142.424255][ T9758] CPU: 1 UID: 0 PID: 9758 Comm: test Not tainted
6.19.0-rc2-00098-gc53f467229a7 #20 PREEMPT(full)
[  142.426503][ T9758] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  142.428429][ T9758] Call Trace:
[  142.429138][ T9758]  <TASK>
[  142.429774][ T9758]  dump_stack_lvl+0x3d/0x1b0
[  142.430774][ T9758]  vpanic+0x679/0x710
[  142.431639][ T9758]  panic+0xc2/0xd0
[  142.432427][ T9758]  ? __pfx_panic+0x10/0x10
[  142.433345][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.434491][ T9758]  ? check_panic_on_warn+0x1f/0xc0
[  142.435548][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.436738][ T9758]  check_panic_on_warn+0xb1/0xc0
[  142.437805][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.438986][ T9758]  end_report+0x107/0x160
[  142.439925][ T9758]  kasan_report+0xd8/0x100
[  142.440902][ T9758]  ? folio_remove_rmap_ptes+0x260/0xfc0
[  142.442082][ T9758]  kasan_check_range+0x39/0x1c0
[  142.443111][ T9758]  folio_remove_rmap_ptes+0x260/0xfc0
[  142.444269][ T9758]  unmap_page_range+0x1c70/0x4300
[  142.445370][ T9758]  ? __pfx_unmap_page_range+0x10/0x10
[  142.446520][ T9758]  ? uprobe_munmap+0x440/0x600
[  142.447558][ T9758]  ? uprobe_munmap+0x470/0x600
[  142.448596][ T9758]  unmap_single_vma+0x153/0x230
[  142.449650][ T9758]  unmap_vmas+0x1d6/0x430
[  142.450594][ T9758]  ? __pfx_unmap_vmas+0x10/0x10
[  142.451647][ T9758]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  142.452911][ T9758]  ? mas_update_gap+0x30a/0x4f0
[  142.453966][ T9758]  vms_clear_ptes.part.0+0x362/0x6b0
[  142.455107][ T9758]  ? __pfx_vms_clear_ptes.part.0+0x10/0x10
[  142.456351][ T9758]  ? __pfx_mas_store_gfp+0x10/0x10
[  142.457450][ T9758]  ? unlink_anon_vmas+0x457/0x890
[  142.458523][ T9758]  vms_complete_munmap_vmas+0x6cf/0xa20
[  142.459715][ T9758]  do_vmi_align_munmap+0x430/0x800
[  142.460817][ T9758]  ? __pfx_do_vmi_align_munmap+0x10/0x10
[  142.462034][ T9758]  ? mas_walk+0x6b7/0x8c0
[  142.462971][ T9758]  do_vmi_munmap+0x1f0/0x3d0
[  142.463973][ T9758]  do_munmap+0xb6/0xf0
[  142.464861][ T9758]  ? __pfx_do_munmap+0x10/0x10
[  142.465903][ T9758]  ? mas_walk+0x6b7/0x8c0
[  142.466847][ T9758]  mremap_to+0x242/0x450
[  142.467765][ T9758]  do_mremap+0x12b3/0x2090
[  142.468727][ T9758]  ? __pfx_do_mremap+0x10/0x10
[  142.469763][ T9758]  __do_sys_mremap+0x119/0x170
[  142.470789][ T9758]  ? __pfx___do_sys_mremap+0x10/0x10
[  142.471926][ T9758]  ? __x64_sys_futex+0x1c5/0x4d0
[  142.472986][ T9758]  ? __x64_sys_futex+0x1ce/0x4d0
[  142.474063][ T9758]  do_syscall_64+0xcb/0xf80
[  142.475050][ T9758]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  142.476312][ T9758] RIP: 0033:0x7f5736fa5fc9
[  142.477261][ T9758] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 97 8e 0d 00 f7 d8
64 89 01 48
[  142.481362][ T9758] RSP: 002b:00007f5736eace98 EFLAGS: 00000297
ORIG_RAX: 0000000000000019
[  142.483134][ T9758] RAX: ffffffffffffffda RBX: 0000000000000000
RCX: 00007f5736fa5fc9
[  142.484836][ T9758] RDX: 0000000000004000 RSI: 0000000000004000
RDI: 0000200000ffc000
[  142.486536][ T9758] RBP: 00007f5736eacec0 R08: 0000200000002000
R09: 0000000000000000
[  142.488223][ T9758] R10: 0000000000000007 R11: 0000000000000297
R12: 00007fff0d19497e
[  142.489913][ T9758] R13: 00007fff0d19497f R14: 00007f5736eacfc0
R15: 0000000000022000
[  142.491609][ T9758]  </TASK>
```

Since there are no commits in between these two commits, I am certain
that the bug is introduced by this commit.

> > This commit doesn't mention anything about MREMAP_DONTUNMAP. Is it really
> > acceptable for MREMAP_DONTUNMAP, which maintains old_address and aliases
> > new_address, to use move-only fastpath?
> >
> > If MREMAP_DONTUNMAP can also use fastpath, I think a sophisticated
> > refactoring of remap_move is needed to manage anon_vma/rmap lifetimes.
> > Otherwise, adding simple flag check logic to vrm_move_only() is likely
> > necessary.
> >
> > What are your thoughts?
>
> It's late at night, so...
> let me look at at this tomorrow with a clearer mind :)
>
> Happy new year, by the way!

Happy new year to you too! :)

>
> --
> Cheers,
> Harry / Hyeonggon

Regards,
Jeongjun Park

