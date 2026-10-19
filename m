Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338FA606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xz2PyeQW
Received: by kanga.kvack.org (Postfix)
	id 3F0AB6B010A; Mon, 19 Oct 2026 19:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0686B010C; Mon, 19 Oct 2026 19:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5E56B010D; Mon, 19 Oct 2026 19:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C186B010A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:46:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86D2614056A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:46:42 +0000 (UTC)
X-FDA: 85341013044.25.2D16581
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B286818000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:46:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xz2PyeQW;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792453600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnbJ/fWoD11/g9szFmuzDGasP/1e2AgpJzFnEjFUq1Y=;
	b=OWT5tXn5Y9b7JdEDUTWbzksohzzpq79mYzlU4P9hnZjb1njeyUWrdtb7BUNLnq9LmB7Vwc
	YFz5l2FfjMITZR9tCMVj5VPjClSMEwHiIliTWnJXdAycB1Uft9BWK7JP3wPC4OWj8Z76DG
	/uZntiHZRCKCsy8gxc6oTxvgDiW4VLA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xz2PyeQW;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792453600;
	b=JcUdp7Cz+Y3X4IaBJY0coNZJRWcxIHkah+G7n8VCqWKnMy/YuRrmAhBuuHpTPr1lJJLGN9
	TW4cMYYVefWi20rAoRYePHiqrNw93mD9cE592HZN6Bcayft/jaZhL0gn1uaUXTQWYFdjfV
	kXp6It0SGyZNpMSex26x02AY7njnHOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF615600AA;
	Mon, 19 Oct 2026 23:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED61F000C4;
	Mon, 19 Oct 2026 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792453599;
	bh=lnbJ/fWoD11/g9szFmuzDGasP/1e2AgpJzFnEjFUq1Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xz2PyeQWC71Jdv+LVHPfpQH3SZFM38V7OqQRR6Rn+L0Or9GHlKTA9epcwDawRBhIW
	 o6Xjx+ug/q8y2FztLjpwhbc6LgdWxI5Xjwh7kTUZxVKLQRo3/YAl9XTCM+8srtVkkj
	 lzuNM0WK2JrER1UjAq1N6orohUxovMraATbR+YcY=
Date: Mon, 19 Oct 2026 16:46:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>
Cc: david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, linux-ext4@vger.kernel.org, Vlastimil Babka
 <vbabka@suse.cz>, Barry Song <baohua@kernel.org>, Theodore Ts'o
 <tytso@mit.edu>
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
Message-Id: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
In-Reply-To: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B286818000B
X-Rspam-User: 
X-Stat-Signature: ndpe4a8ijscydsiu39ohcgzyimj1bd57
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792453600-225176
X-HE-Meta: U2FsdGVkX194C6ZnCi21AgCqxLu9fE+Ech1vH4JFtYRCyI/cR5eTGHwDTRIlve+suyOn2jiyl0tkLVbIpOXskeLNAI6tZVqTTNJeRMivYFyJuyWrs0gZSTYQ0p6BI5jVX1RU9HRrObGOoRoDbgCrvj61PRXejWKNhMHTzs2e2FfUlbthbFT9PO5yCILvw4jA9fou6KPlZC5PazWVcP+A3fOXigGqaV4MdgKglBkmYHELbHANHfGZJofhsuww16Z/zkipSmXtDiu1Fm3kZR20zDOUghpsII5XzBrScfqgFsNwRKL+0FfwfXl4PWAH8MZxxblJyDikxGWBupDE8PcZ4z+TxD37VYT4/FODWh5i2m4rB+K9RDTivet/VlYUQYBdI+e78eL7frzM51WUIanvAqF1YISC2zd/DJm9MG+SeAppVuh+PZlTUM125sDB8xWNzcKnfTafUjmp/3N8rSVRb0L5J6jcNwVWQwKNFzrBYdIQw2JB5KzMhLFBN0zghD8GSztM2qXVRcKYZeI3M5bg+8/DAwSbBCzLbhtOBJhxdePaF+tZElm+4bFa7x6P1ZnJxTiM4YI9TePr+0xZgXmiIK1smBuFPijDO6BSl1jz2oq1dCFl+S5ecep1zi1psNNATE++Z4+8P22GSllvyoC0wI6U6GZKcTns2yvYHJDPzNT0rr8VR3/JoM9PJUTnHlykuY/g6hCCXpipu2JIS9eyR4sKnFFanLTJWNYpjOsVHHuUmBFokdaWT8b3AXnAB91Q9IABkuYqE2cp9CkKDgkPWUs/oKPa8x1r+WK2i+JxCULwbPIEEwTMDjpcpeqnBW9v+80JQd2R4CLCiVSsny9+Xy32P6CZpTRHg0ON5iuu9TsjTDiiTfxXE3Teqxw3VV8ySJJ/1+NXq2ERLmgX2TuY8sxYzoooIicdIxOQwxvRUpGl3BfednyPJ37mlw6Zy6hRdMdYN+ZAofM2QK9yG1a
 wy0E5RVy
 nIw2DJK+SusqqBKQI+crlJEZ0nQ3DSXA6MvAktwwbIFUJNQuwASlW2c6GRKoPVaxTFsUOqEL57azZT+i6UH2Sf/YG/Xb8WU/CjS/EO/lAScqMl4uaXyY5GjrRymTNN4OUE5YsGowHztutFw+jCLWLb0BkvVf2OYJhay1L5bGEOYJHI2ku1zHpF4JSBLasYgAJN7D4EHbMBbJMQZej9PUtFitO3fgPh1p8yFe6hXcTPr4Hrtz86PW7Fwf/RqO+CHIRUQyzwV36D0C5eXAexTz8b3BYoKi5zTpVqAnU/4SNSJt0guF6M4t1zDdnU+3e2dsg29zJO3v8lQwdW1o28xCGH70Ea4gislrbWC+JJltCvBMa6kN4ydDHThOhDCygk2ByYQPOtJ4FfKtIFbyi+NITX3wGgCKwBfOP0Vy/ZkANzMoVMvA9iJr/4XJR61IpuszcIKshnHuElBi9/pHnjg0YczpMl4INsA7aSOk8vv6+XChHgo4HoEyEUcTdEjTCl9qPxx5l25uO5VraKJd2URr/QC9cOnr3NES1G35koewqf6FwccBU3nTNo/8FvTY+FTMNVvznYaYLFC/JG1TDHHQAr8Dlsgwydl/MdQbBvBF9rFxO5ni9BiVer9gsAAzURr01T7UsYXJh/zYNpgd3LD14HtC2SLYe3Mb7xvOdqAOe0VVVuWFH3YVBbU/LWU1qk+v4VtijBQgtkpdPgXoqjDG5qlWklTgM5ccbjp4EA5fKFBOzAw5zGG3nBIgcYghuyX09plz1KbEUwTipKPKNsX3O54P6gQiIF1GkR40xhlUUV/iB5bMp+vOkrru4TZoGhe7X3io74f+2baZ+ce0znXC6fS3Xw0gjBzJvmXdtHH5jZXw9fgG7U5HOZUDx2zb66nTJ04hGAG5WQ/qJxAvfXXz9s8NmV4iZYY+kb3u0T3K1f6UwekGmhuufvjp5RMDyh7CXVy+HxiCjWjlN6JFiJjFRanQePkk0
 oh+qjLOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12cdb20d580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
> dashboard link: https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmlinux-a0ff06b3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54/bzImage-a0ff06b3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> current->flags & PF_MEMALLOC
> WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c:4816 [inline], CPU#3: syz-executor/5706
> WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706

Thanks.  The stack trace is missing important bits for some reason, but
it appears to be ext4 disagreeing with page reclaim.

__alloc_pages_slowpath():
	if (unlikely(nofail)) {
		/*
		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
		 * otherwise, we may result in lockup.
		 */
		WARN_ON_ONCE(!can_direct_reclaim);
		/*
		 * PF_MEMALLOC request from this context is rather bizarre
		 * because we cannot reclaim anything and only can loop waiting
		 * for somebody to do a work for us.
		 */
-->>		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
	}

The electrical think machine said:


filemap_fault()
  -> direct reclaim
     -> shrink_slab()
        -> super_cache_scan()
           -> prune_icache_sb()
              -> evict()
                 -> ext4_evict_inode()
                    -> ext4_clear_inode()
                       -> ext4_discard_preallocations()
                          -> ext4_mb_load_buddy_gfp(
                               GFP_NOFS | __GFP_NOFAIL)
                             -> __filemap_get_folio()
                                -> page allocator
                                   -> WARN_ON(PF_MEMALLOC)


The task enters direct reclaim after a filemap allocation failure. 
Reclaim calls shrink_slab(), which evicts an ext4 inode via
super_cache_scan() and prune_icache_sb().  The eviction path eventually
calls ext4_discard_preallocations(), which explicitly does:

    err = ext4_mb_load_buddy_gfp(sb, group, &e4b,
                                 GFP_NOFS | __GFP_NOFAIL);

If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
allocates one through __filemap_get_folio().  This reaches
__alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
triggering the warning.

Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
have already been detached from the inode's tree, and failure to load
the buddy information can prevent their space from being released
correctly.

It seems that ext4 needs a way to complete this mandatory cleanup
without performing a NOFAIL allocation from the slab-shrinker context. 
Perhaps the preallocation cleanup could be restructured so that it
doesn't require allocating buddy-cache folios during reclaim?

The syzbot report is at:
https://syzkaller.appspot.com/bug?extid=54f6a8926b40a171f2c8


