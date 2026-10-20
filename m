Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF64606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kJgC9DX8
Received: by kanga.kvack.org (Postfix)
	id 6D0046B03D7; Mon, 19 Oct 2026 21:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A82E6B03D8; Mon, 19 Oct 2026 21:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCB06B03D9; Mon, 19 Oct 2026 21:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FE66B03D7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:26:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73D3F1C3521
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:26:00 +0000 (UTC)
X-FDA: 85341263280.28.57E1E13
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B875140006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:25:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kJgC9DX8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792459558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSX0ou4En0Loje0VMQSvyBs2WArXvoHO0E4dlLLOqxo=;
	b=5ps/VXNv1MET5CTLo9ntInJONjcdHzBGlzHgO3GOPciLZ/hh5bk/Yq1r7t/vW+0+Te7P7E
	n+9QUav9WxBQoB9rK5lvRJ6n6VLkIdfDBp1uXtx0UibTDmWFJyD91QL6BMT6cmLpZizFMZ
	3H7oE/qSl0p5fJ6mGl10SGn7FfMOJrI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kJgC9DX8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792459558;
	b=KlJzmsbsSpm3/DjktfCDCL7ZqtCizpwpuVE+Fsk9OwTmq+yZz1dbPhOaT4wX4uqVCH8RQt
	0t8fZwYIis+MoiYRfib3N02A3jvugdjXGDf7CMcYPzUJDy72ZfcfpTa6N+GXLlWwgqDbtq
	pi3FZ1mjJxeS8vWGWzV06X8O8S4Qf44=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6cxA+5Cap6YuVVh878URw7RVJb0ynDru1vwbXqf/Zcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792459556; v=1; x=1793064356;
 b=kJgC9DX84QK9wuR5Pel/YZV605dqtEWagrLtqqcNdNDFdv+SQb6r0hEc7VETykvPRQs6Tgm1
 NP41AwvhRdbJfDiwfhiOLco3eTbp2gSrNFZtHvPVReRWBngGlagCUJ74Ohrya4EX1V73CrEslYt
 VbA6sx2pY3pF+cCxIUUfjQXk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 83bbbd00093168ec;
	Tue, 20 Oct 2026 01:25:56 +0000
X-Mizu-Trace-ID: 83bbbd00093168ec
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 18:25:51 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	linux-ext4@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Barry Song <baohua@kernel.org>, 
	Theodore Ts'o <tytso@mit.edu>, jack@suse.com
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
Message-ID: <atbC0ml_mctTyEP0@linux.dev>
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
 <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B875140006
X-Stat-Signature: rzfyqga341sbbhbr9z4ukf9zddu8f9is
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792459557-890929
X-HE-Meta: U2FsdGVkX1/SsK90V7jeeiomZluYOd/6Jc5eOma2DcoS0KTnFHfOJx30Hpf/yKb/mze9B/PhR3oV4USadr9WZJxF57DV3GAO8mCZWty/oolhURzVcozZkL90JIoofn0Rx+Rgj61ps2jOsKGA235del95bp1M3HS2Gotnw2XYiv8dbdLmmOBkD8Vv6TMwPTbRWLrBckLBlhhRVatg0kJdZQPRae6Y5BO1jHws/iT+aIjaF7n/tAz0qBiQEPUwB5vSvELVTNDvUuHTvAgGuQO2AHY/yCaREUWdAi+nArG14YqWSvJHQYeplJHb47hpRNogEI6eY27hvAsKGEBRvGVtbNSlYYQvEs0sqprK+Sh/QqIFAs3sWAB3llN3N3GbSvRMXpDMV2wSAFePY/WJVKbZcQOQZEp2qx+8utYyZrFt4qdXOc/y5Dx4F0EJPJUcb9OfskxEwpsef/rnuv+NfD/fXgAzGmIF/PyRlwQqg3Lc1k1xFUnPF5R9LbVZFsoMhJfAhWjUZTSdiGP2khroHeWjUT4xeLGMv8YJbmsqXQL3flRYpwfwndRfoQXwk1/UYCo49wasvb3HvXF46xH7dwZXuT0ZqZyjqgqf3prT8c3zX6+iDdCcfe80Abyzu+OkjVhu4/8cssd77GqMd9ET4G44wpiycOyRWJG9+M9PS0vof3c8A42Q+UnliY2onFY0lELedj+8V8+77/tyAlre+JVdi89l43Q09Iot5RWVHQTj4b2x2bgl95cyZiVFZEFWzfARRWRS/WgNTOteHJe1hAShfONgDtjoMhmMbB35cdlZgJeNN22/dgQqVJmKZXRPiucy3huNYeY30AKdGdqltI7OK8GRKR26x5XkRCkFhx+ABKlqg2hpQrqszOCl8pYDjUxf/C0VLg9L+5H+SlOyk60aJqpdhJagYoE/UbKuqicq252DzybNdlLkFxG92BTsh3+hrTRSIOu6LjJGpFiseNx
 bm02IS1U
 9h1SIsg6K3wMZsx8Ra91tn+nQypGHpOfYPoWVFPkOw+czEyb2aQvZEo08U3jQCrZTAE8WCUxR5NU0lrZHrJoq6RHo7einJbqK9lCAllP6UPvda7Dt8g/Oa84mU0KHEDZ7ecPrPK9fDJjJ4fLG7l7HTokloH6i8QooWyNcfGqzFdv1JYe/FTNFMQqidTPqBJKc3cgIb07diLdmQlvf66LxJbv4d03JDqUB9E+fEIM6H4YTzoKMUlnfKACYRPkjhynYVe8xlsFeW7hyAAumlwrh7sffvUkGgrQTLuTfYk0w4m82UIkLC4EwtmqeEEN8ut0GsF/k2TW85bGfO9+2lViqlQK8xoBEni4Ds6DG/gF4BeE4WFtefZbuhyMf4hfErbiGIxwN/HEmVbuGpyP97QPmQpDP1jsaF5eeXumtmVVVHBITVUwZTOpxerYqgLLbYoVe9MTCZtEGWjSi6YNEX0vgC4ow0Ie65aBwRbjOqbb8jUQZnLf+Q+gwX+CrV8mDt6lARkBf23nvzfzVbc5kI+uHm6DNlCDBy5VrLLrOWTGYN6nb+q4pdxK0oKDEcjX3CU6WMjb3D3y8cHsSyO4ul07TdqmV4UUOL4Sw5NbdrkMuBrF6MECKYe9fgbICd9kFg7TktwnLw1GtJThlKpEwEYMbbimkQsvxBU60OgqCZR7KYBdl7sJeVf4K2JKwzc3+yPu7GW/CZTY2zBBD3JoKJgn5YTM9Fdj/UO0M0GueZaf/IPt3EgdT0kQEcxJ4+QR94SlLIR3fcyLpwus+JIpQScGCtC7KaZN1RHBHvPqjatbyZOHPDT2UaK5bTjlNI6s+0Jvy/pBnBjQNsMFGDXQOC2q1v7x99vm3az6uDCURo2ACL4KXJrfMcphjlekQWOLXhXUKYc5yfZAvT/a09rtRuQrd62i7Kr09f/e5e6kS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+Jan Kara

On Mon, Oct 19, 2026 at 04:46:38PM -0700, Andrew Morton wrote:
> On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of git:/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12cdb20d580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > userspace arch: i386
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmlinux-a0ff06b3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54/bzImage-a0ff06b3.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > current->flags & PF_MEMALLOC
> > WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c:4816 [inline], CPU#3: syz-executor/5706
> > WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706
> 
> Thanks.  The stack trace is missing important bits for some reason, but
> it appears to be ext4 disagreeing with page reclaim.
> 
> __alloc_pages_slowpath():
> 	if (unlikely(nofail)) {
> 		/*
> 		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 		 * otherwise, we may result in lockup.
> 		 */
> 		WARN_ON_ONCE(!can_direct_reclaim);
> 		/*
> 		 * PF_MEMALLOC request from this context is rather bizarre
> 		 * because we cannot reclaim anything and only can loop waiting
> 		 * for somebody to do a work for us.
> 		 */
> -->>		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
> 	}
> 
> The electrical think machine said:
> 
> 
> filemap_fault()
>   -> direct reclaim
>      -> shrink_slab()
>         -> super_cache_scan()
>            -> prune_icache_sb()
>               -> evict()
>                  -> ext4_evict_inode()
>                     -> ext4_clear_inode()
>                        -> ext4_discard_preallocations()
>                           -> ext4_mb_load_buddy_gfp(
>                                GFP_NOFS | __GFP_NOFAIL)
>                              -> __filemap_get_folio()
>                                 -> page allocator
>                                    -> WARN_ON(PF_MEMALLOC)
> 
> 
> The task enters direct reclaim after a filemap allocation failure. 
> Reclaim calls shrink_slab(), which evicts an ext4 inode via
> super_cache_scan() and prune_icache_sb().  The eviction path eventually
> calls ext4_discard_preallocations(), which explicitly does:
> 
>     err = ext4_mb_load_buddy_gfp(sb, group, &e4b,
>                                  GFP_NOFS | __GFP_NOFAIL);
> 
> If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
> allocates one through __filemap_get_folio().  This reaches
> __alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
> triggering the warning.
> 
> Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
> have already been detached from the inode's tree, and failure to load
> the buddy information can prevent their space from being released
> correctly.
> 
> It seems that ext4 needs a way to complete this mandatory cleanup
> without performing a NOFAIL allocation from the slab-shrinker context. 
> Perhaps the preallocation cleanup could be restructured so that it
> doesn't require allocating buddy-cache folios during reclaim?
> 
> The syzbot report is at:
> https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8

Jan already has a series which will fix these kind of issues:
http://lore.kernel.org/20261009133253.20102-1-jack@suse.cz

