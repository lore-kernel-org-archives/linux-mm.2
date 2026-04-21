Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DA7F94CB1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 20:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F060A6B0005; Tue, 21 Apr 2026 16:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD4B6B0088; Tue, 21 Apr 2026 16:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3666B0089; Tue, 21 Apr 2026 16:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE14C6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:56:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 302611B9539
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:56:22 +0000 (UTC)
X-FDA: 84683771004.19.DFFCB55
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id E6AAB80002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:56:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pRF2zYGo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of jedix@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=jedix@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776804980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45RkmloTt/jmTgrYst9yeeiYaN5TrH0czFnskYQuBGY=;
	b=c/u7/tiYpLyLS1QcMS/9FOwNp5RHzFACXg6gWQpmZct2Ntrk9M11oYVwWE6YOT1QvoxBRL
	OOO5vMDuEoBtDrepFMrfP3wwgQq0iWBdnSHCwGosgnbbubSjhimzrphVDGPxx9uzGPa+iP
	fprFYNDTcxXCi1mheiIKAU2o97O6tPo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pRF2zYGo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of jedix@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=jedix@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776804980; a=rsa-sha256;
	cv=none;
	b=rVOo9h5hi4qClaG9NhMTqLGxY4HXi/MlNcJYKGHvTmmKIiVba1WWAsxg8gku7MvRjACph2
	njpjkxR3+xHV9QC37IcH9+gww7TagxrOhNYyUooD2Mb0Oo35UdrYZXmGdwP8uwRaODxVqd
	lg4K2fGp+y3zs7KFi2cvysnt1u3Vy9U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=45RkmloTt/jmTgrYst9yeeiYaN5TrH0czFnskYQuBGY=; b=pRF2zYGowjq8CHQeh8dCF1WM0l
	dFhB3TQ0gjQj7HOjtLZxLCej7Ku9ay4tR7OqK1CC45ZxxcTHYRxDoFcqXrTgL21PwZ83T/3pZ9LbU
	ao6Q/vjjVPrkYBDryVLj8dMNRtEa3jjg5dP3CoZ+rg4RbH9MxEUA1f52l+rXx7Eq6RKDhS8hjQRRu
	KjmQiSAeISr6KEKTvVc9YdIT7uU9MTtHGc/+HQxRtVKA5NrOEb3YJCgp6H3NYsUA3NBT4fRO9FBPv
	N0ma1L3fKUdb2oZ78T+CX8NCPvcLsF2m72/AyNeQjWjpG8uhrz3+gc7iJDChytjINjP5QMv3k0Jwi
	ug/kHUKQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFI8l-000000099dW-42al;
	Tue, 21 Apr 2026 20:56:16 +0000
Date: Tue, 21 Apr 2026 16:56:14 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: syzbot <syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid
 context in __zap_vma_range
Message-ID: <ypupur6petxbauqwnlfaa7owfiexnv6fzxysavwgu3yr6qt74i@j3vyiyojtkfg>
References: <69e69c55.050a0220.24bfd3.002a.GAE@google.com>
 <tq37r4njepyw3gmrihclvqzus5cvpmepvyrjhggb3wpv7cnsmy@naeba6ofwutx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tq37r4njepyw3gmrihclvqzus5cvpmepvyrjhggb3wpv7cnsmy@naeba6ofwutx>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6AAB80002
X-Stat-Signature: nn4g7cd85qtgmoqbrwmo99k9ybr1o445
X-HE-Tag: 1776804979-110510
X-HE-Meta: U2FsdGVkX1/gfOMJ8nMgBepZ5bz4NMhmg0dH+J8umPKoLQr3JgwSc+ZN3k6bPJf7Sx0Kt+cqsT7ymXd41K+pMvWBvNqxrtMFHG+xjtdQGeU16z12Ozz4LriGiQCASq+Y136Li93E4QzqTpKy/RwyKq1vUFIHqvvCVkxjOUGyViIfjuP/iRVbWO+u1HyLEbs/dfAzhUgJQ0+Sno4lO14ncSNi8uVr8PAqfVNiLXcMl83mxZdxVUBRq8zC7Jni/20F1S1/Am4TxWH5t+1+PJDjGsIBs5Q/OekHnPp2+W468LeZ1K6brEIzvXBXc5kRbSYWOyl3x1gBThIrxFm0mAEXTvsK9IRWxi6u82JmbjQ+WKxlWGtiOnrehyozuHVeb3kd7z8xR1c55iD9Y+t5K/O0A07UUZxx+uh9bNbUhGMvRTIiyq5vh/C4X3/imemV+ql3r9qFfaLTyIuyTTXOiGtgCcm4J9Ek0DC1GlSn+ZY6erGwXjVWPsrX1hQmO1MbPIR8USwcokjLqak51N2URxBeoOY9y9NX6Cvbjsp2ZH3wq7BFsK/rnDDtJoQMnMfmD/RhySc/kEEj1fsuJQSUwuXBzrlHR97Y3EgO+/mefW2kuJQFmiBIro6LWYDgo4cGJ15Fhh6R23DnTcy86sooyO/Sw4KoAvgKZbV34KVp7/ugIs/z42tJCBgxibaH14/V01e1r8mQazFFmj0Yf4wqOYZSO+w6JaaGccAjO/Sshi4rolSil1ZnG0PV5662q85AJz7qByBUpriwxI+g1nrhDLogct5pFgTdVQ9YwMqO52cHabmRNG0M8dC12NymeJsohknMD34Q5zinAgdjtkdy2ZptPV5d8Ivjt5MPwAE+KIwCzBuZaS8mQhT/ucGYrQap2ToVt6bvNVygCO9MJDMgNVMgeRhd5XsIH967Fy+0Yn/tcycliuFaUFc+8K0wG3aXek6GCEPtzTBarzzfey/7A5e
 iFmkXJ51
 l11TkDXHIYHkuSddmht8tlA6Vae2n3ZDsJkHR2QDiqD7OmE9xHS4uKq9TtQUeJ63zb/JOIR1EzVUy8HEJTMKAWhI13yuYNJ8p7BrGGGbTEjYpU+xH8clO3sV6oUQZpykfZWtjEoeOINBytnh6fOwSSuSMILS5/qE2hhALdy+e6bnZITsWyvlOnHkd55hXSbhzKtUHK7lswqOX9S3by747fTFl4r3qRAWDwpe37M/48TznD44Q+zxT5DzVPQ69NuhZr0+gsQzgr/4fOg52Uxhb/2GL91L7WM7kCzjpizS0NupA/oTIKRFW0wPPpf5gDhR31n6ZTEfLDYpk0n2IT0sZTl2qfRMk9mt1EMadLX//MjGQvhWMv/8zZg4x6hIr0B3GJLV1kJS3fLu6lK76wxZHGfaq5wOQ6uFPmzwC/9b76pgxvk06+1jeCGXZhM3mSdi+3BpimHcOrmRsT3ui1eUEt137C46N/4k2bLgHglmfEhVw4SyFZq1AAgfUbMi4jdJ/R4A3KTKC/s8YTgLhHkMn4tgtYtcmAY/MybKRsoHEUhDwIUUA8D4AKQSYKcuAeAiESHPE59IBF5Ep/EBIiTDu7KBR4nVAyITkgBCBbObuHLo4QCIzyfWV9weDYT6n5UMW5a0s5pN8IxXIOOYv/FzDdSkO9KGvOT2QyGzUhdwEWwQCJC37kNnVHY34lKmUzBl10wysgj13MfyaGwz6WJ/TeAiu2HUPwjICyUNtLeVskx9r/Z/XfRqq3jDx5hZFAHzb1pPB90F5CvBSDJl45LkAKjr+RV5mScnZ2N4gCxowl/kPiBXBYDcNMVOZYP5zlw6yegg2Utg0WUQWztAiT1RUUjAvUWcXH/b60deJ5URZd6rbtM5zG+UVJF6cfugGlZh3v6OBFDqJOEdzL7/TVUwB1J6qL6Pbq2mZEO44X43SST01mtLN6JPqrKeFzpB5A72fmOeRHqJvSIGUAVLptXko90334IPt
 aLRUm5Cg
 veECKq1gIqerdwUlbdEHrRppIQs9xj0HJsU6UyZ3MkWY72NWng5EDH3YADj1v0xeNmH19/vpiX5w5Mv5jzYrNEz8Krv9G16+NNeOWeQCptW8SyNiJD4JRu20aLXdtxTMhJUq4x4uptN/yDLM83mjCp7K+9IzYkru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/21 02:30PM, Pedro Falcato wrote:
> On Mon, Apr 20, 2026 at 02:36:21PM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c1f49dea2b8f Merge tag 'mm-hotfixes-stable-2026-04-19-00-1..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=142514ce580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6a29a582d8ced859
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4cc5bc01fb4a179c4ffa
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c1f49dea.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/402c79548d6e/vmlinux-c1f49dea.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/1bc39526d7f4/bzImage-c1f49dea.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com
> > 
> > BUG: sleeping function called from invalid context at mm/memory.c:2007
> > in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5913, name: cmp
> > preempt_count: 0, expected: 0
> > RCU nest depth: 1, expected: 0
> > 2 locks held by cmp/5913:
> >  #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
> >  #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x124/0xa10 mm/mmap.c:1284
> >  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
> >  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
> >  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
> 
> This first looked to me like some spot where we forgot to unmap the PTE, but a
> closer look suggests that, since we no longer hold the pte lock, something
> forgot to unlock the rcu lock and we're just seeing the lock nesting in action.
> 
> Possibly related to the swap rework or so? I dunno. Hard to guess without
> more clues. I tried looking at the mm changes for the cycle but nothing
> seemed to pop out to me.

Yes.  This is almost certainly a locking issue.

Probably this one [1].

I have code to try and detect silly locking errors that I'm planning to
send out soon.

[1]. https://lore.kernel.org/all/0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk/#t

