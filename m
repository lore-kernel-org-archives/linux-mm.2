Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6461061B2E
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2256B0095; Tue, 31 Mar 2026 07:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9A76B0096; Tue, 31 Mar 2026 07:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7086B0099; Tue, 31 Mar 2026 07:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D11726B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:54:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84E48E01E2
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:54:49 +0000 (UTC)
X-FDA: 84606201498.27.CB02E7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BCD261C0007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:54:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/UV/KFI";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774958087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HMFBr9VSi1SakTiaztS8jSwW547tB2fKxdOV5nOgnU=;
	b=z1tnwvsqTou1jx+Nwu09OA1mPJdkNPzAEtaXnsfdHc6Z45lUx1cG2LByvMx2OmrqCYeMuB
	EwLGn3KiBLxy0N7NxGF/44o4NTEOQYcN8DEkZ2iGioszUwnxyzjgGDF6kqvFXkGJqKUGkr
	SX63SxwBMcFPzLwLb2NBwwM6chMmsB4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/UV/KFI";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774958087; a=rsa-sha256;
	cv=none;
	b=TAMiQpeNhUG/UyuVpKYoFNob75hFr0p55eShe94cAhvrvRvOs/JgpoIPLUXvVTN/D0SArK
	Fqo1PPO34chzcSs+mWP/ieSHOEUcapsdsrimgAstfJEQi/ljRkKGvxqiYAnbKNgWEiGk44
	SExCF/dcOyPYxWzhPz2Xh/RnL3N4nxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C517643967;
	Tue, 31 Mar 2026 11:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEFFC19423;
	Tue, 31 Mar 2026 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774958086;
	bh=FzISalReozoKQskTO3BDtGFo/1VITHJsufTvE9+sOiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E/UV/KFIwhLTtS83HrDWmyggFL9XDJYa6o3F0Kq+BU4ZrFehRRxvawW2ZX6K9Wdan
	 8F4IZv3vy2GK3G1rS5XbPgE/rY6FO8RQ+LeAlrSMEmDnDz2neUT/rw+7u1OBZKh/ll
	 KhtusUIVOy7ckpowwHEysOUjYSDvpHWhy3rPwLCQHOmG02DQTWRrwoizsk7sYSK+zY
	 SDVw534N8x6wRWjUbm3HNW2nT77y3j+F2DUv2fruigM+iv9/ILsEbEUvl5BwfZD/Gi
	 Avp4Ra0mkzDUCproxWP5GbsZO8ibBnBSd++jL8wGpiai26oquyXgSWQiz92Qvwofae
	 uZqmn62p/A+Lg==
Date: Tue, 31 Mar 2026 12:54:43 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: syzbot <syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 madvise_walk_vmas
Message-ID: <64b4e45a-bfd6-4bbe-8774-5fc80d0d2cf1@lucifer.local>
References: <69cb8ed0.050a0220.183828.0027.GAE@google.com>
 <e1cb33b8-c1f7-4972-8628-3a2169077d6e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1cb33b8-c1f7-4972-8628-3a2169077d6e@lucifer.local>
X-Rspamd-Queue-Id: BCD261C0007
X-Stat-Signature: 7xymsiyxogob8uidpmjxdzwofpcqdny9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774958087-83715
X-HE-Meta: U2FsdGVkX1+9Z3wVtUu9+vVw84KTRBz9wWUXxmhpiGGTeQ2NjPD/yO6aBFMlc1jjYs99F2K2hxEv3QJM0QwH8H+ScaXe5Myq0eDPlKmLSTWF36XMi5UKhJ/s2/dUetu5VfCLk0fkCOhWYvSJbxNNmWGTB1CvPWqMZ7YAdzR3qRcOMZpgTf+WoZBJzSE6b9s9nCzd64GA8NbBrdoR0p8oc6N7k+Ie0fdgq0+Z+zauQhwVDhlbvtP05D+I5ciW7jAWt6Gwzj1GlIzsEudQS61axFPDloM5YF/N2gGwfV3cUBiCN8f/ljKIaWMODWk33+nImLPhVcnYMMT6V1khkMfyD1SGcQi/GSNE5Ff4TB9Ab/9JQkezqZc4eDhjyJ8MCJsOl/eVmEt5C23A403EzMZ4CdeC6Fib64MhMJL6f2QnG9mAKw1k8dLyGuOOZzD3reCuZiE7Pg/aEHKvYp3ioAZdFQFgKwPXnXzdCY68GItOyczklJsTe3GPdYZX8DaPkfmTk6OixSzE+YoPw/lgDnh/srOlk5LALlDfXsUoPk87Grqqacc8Xy+u+6K7vA0MMQOOYeTplkE7TqOF08Krpa1muwl2iCqyAq7V266PNpIrulMcGDdkuMpwn7/JBBCV4f/igALXTghEX085WpOlMqvGTo+k18yG+NXg+L2tPc53y0Qt5wUmj1XzCx5GUJueW5dyYfnXILrFjs4dJiVzoOvpJ2RpzVcg2vSk3PlqgdUn2RRIeX1xZJ8s5srvhUcEDtALvYf1vMjhzRMvRaPJlWf/IGufxeHFRtgwpJpxxE86vcx0U6Cp3BDha0JIH7hj7Fwz4jzpRnNRorqYrMCz7GUwGCMU8UZnC+kkMuLJA6blZpxpuQ5SnzbeffCQRM8CTwF/o3A05cL/0MFUvFMRreQirgTbrpXQhvux8VAW3j30PrCkjRL9eqW9g9MXzcdlDYRLnnt8BlOe8MKGZWrauAx
 2q9YcWlU
 ERn4zVl5L8OH/f/MJ23BP1Yrp5s0EUYl2kC4z7qqxuJzKYWspl07keUNlmcX+z+q4WNT8zYrfoLmn8SB+V2FXKbPNwaBVCZFmwvHEcuKtqebMEWEe4gQ6wF0Z55qiWJmfQgti8vRkPK0pxvRp17kUGIeLUuv/+0CRUEkNUU29S8m57kpfRzxELk7bZV+O9FyyZvBO3Xr7EbTDfG4GlA57bUV52mDksRqRBR9QJf2y9WYcdIGDeF48XgcJXEnyQYzgnrRzzaKW3ox2WQj/qI/yxXkjyHNi92O3j2SyAwOox6ePlGUDk6Eu2DJePQlpRXsVjk4rZiJ+IMVxZo9Syso+7g7wtxsywYdmoP+/PZWA956651FIo6k+ZZZkjgokaEyrd2LHVJdNgeUiar3LLuewroO5snMJK5P6bRC3jcn4zKeE/2P83yy5sBy7k/EFAxeBTG5MhbVHJWU/X18TdLzy6BAjZPaPvE6NsOsnGFp+Y9RfXjqPYZKrLD8HNsYk4ClsDAcz3GWWsNbX58nQiEqnLACw5X9B7AZNlaZVl2taO1mCV17rMqAvTdpLja1VJUCIen37tM+piCTAIcRi1zb0ZCvWvqxtIdD28FCXrt4eN4qM0QLBjDjsb/Kzkke5hkR0rxvSNEgxv0r7rSSPUW53Cn8wAW2vfD9ozQwwTQzE+hAnl6jiFKVyHFPUA9GxkL+K8N7KZV3F7Tb43t9Ja/sTXi42XIleZX2vj8HEyfNtiWeLmTVsgifQ9n7ov5Y9c4dWVGF2584kg1tKI1Vb0vqbHkFIRpzEOBLA+H6YD2oPetJTNUQ2oCmJy7wDpN/j34ZVzCjyZL1KFtDX626JWPfwl7v+CVH0mjV8og26bZ40zft0pCJMSUnnkJa+g8c+QjgJk5VW99xDgIaBnii6nS5vm4ddzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 12:43:32PM +0100, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 31, 2026 at 02:07:28AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    e77a5a5cfe43 Add linux-next specific files for 20260326
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13640f52580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=51ca7cbda5f81780
> > dashboard link: https://syzkaller.appspot.com/bug?extid=001b9efd14d3e8fac896
> > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/63883a48e879/disk-e77a5a5c.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/cfdff9b548ab/vmlinux-e77a5a5c.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/f2e4eca37d44/bzImage-e77a5a5c.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: slab-use-after-free in madvise_walk_vmas+0x661/0xae0 mm/madvise.c:1726
>
> This is:
>
> 		if (vma && range->end < vma->vm_end) <-- 1726
> 			range->end = vma->vm_end;
>
> > Read of size 8 at addr ffff88803322aa08 by task syz.0.3603/14995
>
> It'd make no sense for a UAF on stack variable range, so it's vma->vm_end
> (offset lines up).
>
> So it means we have a stale vma pointer here in madvise_walk_vmas():
>
> 		error = madvise_vma_behavior(madv_behavior);
> 		if (error)
> 			return error;
> 		if (madv_behavior->lock_dropped) { <--- this is a big clue
> 			/* We dropped the mmap lock, we can't ref the VMA. */
> 			prev = NULL;
> 			vma = NULL;
> 			madv_behavior->lock_dropped = false;
> 		} else {
> 			vma = madv_behavior->vma;
> 			prev = vma;
> 		}
>
> 		if (vma && range->end < vma->vm_end)
> 			range->end = vma->vm_end;
>
> So _after_ the madvise_vma_behavior() call, we won't look at a vma if the lock
> was dropped.
>
> So perhaps we're not correctly propagating this + then getting a stale VMA pointer...
>
> (See below for analysis from registers as to why this is MADV_COLLAPSE)
>
> In madvise_colapse(), we pass the lock_dropped parameter to
> collapse_single_pmd(), which can then set the pointed-to boolean to true.
>
> But then it refreshes the vma via hugepage_vma_revalidate on the next iteration:
>
> 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> 		enum scan_result result = SCAN_FAIL;
>
> 		if (*lock_dropped) {
> 			...
> 			mmap_read_lock(mm);
> 			*lock_dropped = false;
> 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> 							 cc);
> 			...
> 		}
>
> 		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
>
> 		...
> 	}
>
> And something might have raced to change what that VMA is.
>
> However... coming back to madvise_walk_vmas():
>
> 		if (madv_behavior->lock_dropped) {
> 			...
> 		} else {
> 			vma = madv_behavior->vma; <-- we are reading a stale VMA...
> 			prev = vma;		  <-- ...and even assigning it to prev!
> 		}
>
> This whole 'lock dropped' notion is somewhat horrible... I guess it's really
> about detecting a gap in VMAs, which is not exactly crucial since we tolerate
> there being gaps (but return -ENOMEM for some reason to signify it).
>
> Anyway, the proximate fix here is for *lock_dropped in madvise_collapse() to
> actually be relative to whether the lock _was every dropped_ not whether it
> currently is... which is of course what the meaning always was, it's just that
> commit e24d552a17e9 ("mm/madvise: eliminate very confusing manipulation of prev
> VMA") messed this up.
>
> I'll send a fix.

Actually looks to be Nico's series - mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd() - that has the bug. Replying there.

Cheers, Lorenzo

