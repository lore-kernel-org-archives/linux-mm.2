Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF58C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304716B0095; Wed,  2 Sep 2026 21:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266BE6B0099; Wed,  2 Sep 2026 21:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F0E6B009B; Wed,  2 Sep 2026 21:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D385C6B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:54:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63F3816038A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:54:55 +0000 (UTC)
X-FDA: 85170782550.22.A4D6AF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8B1C2160006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:54:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yeawN7Gy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788400493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHmtDEPfgNa8T8L87oSiVhjCoLBlb5om5vFe4YPpkQE=;
	b=OXK9zEJupLif5mq0+aajgD1syPTV31+riwguXyE0KbrYmoxmR3qZxwN5Wz/fc3qVW1RJJR
	YqpQJWtQ0QxOrJ6YAOl0nHjHmLRK58b2Bpro5tbsbUFvf1Tivf0YGetlN7loDhpYVTpvMl
	zy+mWCvUYJ72mKf2n8j+Ccz2tzd3Tdg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yeawN7Gy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788400493;
	b=a2hvn0qfE3nh0q1bgUnINPDbgGkcxLVc4QadQHERv4x/VOl37ztfJdnvFlk5qho1NVotC8
	k1Pf3gF9OMLNsMsPRKvlATZMHG1dHJg6F5QMjseWC30H6K3CkLO4T97vwp7vKAJCmgABPJ
	4Ioc1HnfNgeYGS9WVYZzgLqipYSWkHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73551406BF;
	Thu,  3 Sep 2026 01:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02EF1F000E9;
	Thu,  3 Sep 2026 01:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788400492;
	bh=gHmtDEPfgNa8T8L87oSiVhjCoLBlb5om5vFe4YPpkQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yeawN7GyCWIsCaemmopXXvBAdCqRnHWmFWKvAp5QnCCQl6S6aD4DGWTYn2s0jrkl/
	 ZCt/+Et3K2+sLkhjDH2EOIVDnvL/ITKYlNtpy/RhUPPtcdv/2I7iHcxADslp9KZbSn
	 +ZRykQwCtAxPRZAwGvwwo7P8CEv3g83mPlN2SDoA=
Date: Wed, 2 Sep 2026 18:54:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
Cc: jannh@google.com, kunwu.chan@gmail.com, kunwu.chan@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lixinhai.lxh@gmail.com, ljs@kernel.org, pfalcato@suse.de,
 stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_set_pgoff
Message-Id: <20260902185451.5ba1a829a15bb2799d121bd1@linux-foundation.org>
In-Reply-To: <6a9896aa.e163c37b.143a1.000d.GAE@google.com>
References: <6a87853b.ae6ddae5.3da009.0023.GAE@google.com>
	<6a9896aa.e163c37b.143a1.000d.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ro7xe7j1kgju1iu7od1r57kst15pwmgr
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B1C2160006
X-Rspam-User: 
X-HE-Tag: 1788400493-378252
X-HE-Meta: U2FsdGVkX1/N6mQMtvjmpTzFr72EmrRtoG8qoOawkyv3/PU/nxOprgPf+LqQnz59tSa2loyCTSGG0FdZGIlx1zSm/MElMkImMNww/ioROFCs8LveedwGSUqBFAL6b7t5sjjhfuPSaA9yUtroVG13ohF9AgaaRfAE6Ing9UcDa0NQ/SQVhVw58InMbnmvcSjv/meBxrcH8uD08fjhNov+adZkSLPsZ8j3YuiDUKiBAAe3rz7ZVNQC1E3t91u5uPW74PJZwwmwDJohc+t89/hYQnH4EFOV6NbOzkeOR7KjxaEJg2WGEyUrTSFQvhVQKpN/aO7s/9HXYCMtP/uZKGSfdtVYYMTya0ojwJDIFRqCfrByDSlde4aXotS+WtO+JpEOkSkC+aIRAkKLhE4n69e3AnCYMdYc81AgspXDtRFefkCi3p8BxG1qP6JBssxWkBau3rA2nUH7tha3kTTunOPLXUBKEYXE9858+TyYoWQDWSvvZffZPOkmei0LAot3G3ZtvGJPWMW9Rkzxw9VUxNgKM5NTZ4PUBtffWY+TqBpfvtMOpBQLfZE5z9Xwt5I6hNQquIqImapa3g7SgiTFY4ejfsyO5SL9/WZl2crZ2I02v0hGaJb3AbPqifJOs2ZOADZIuUpJ/tQa9ZFNs8xRGSPPQB4qRThBh+XX93KSzmeLTqIPG42O+cDOPqFsRyaAahTpiE3BWq8USzfAXATUW0UjUOqfs1eXezd6GYWFBJp+IjYSUTXCSTtT4h0ZG0KmMHEH3mVVuiWXn4lMQxqHqzPxi3uIYKW5SzV0dFyGAwSlknIVKsyIRnrOT/ROEafd1sERBN3S94T9CT4D+h6kpYA1JMwXU+FLGbAv8CT+RRUKlTok63qq1jUdvkTGOVY8rUybsvlEM2l9B/MGFTIQsJwt/YzogfenuaBap5DfZ2e2gmN+ngyHvZ+aTRspsRM2A3NkDLLxoq0pkLpxzXqYStD
 RTyxtszw
 YlqcadRS1fwaHHQV0vrJaKPh/OIA0rhxFAgaMrobhVqcYGjTKIRtkwR+d9HQNnWjQp8PDIm7g9bcJ/uQP9RFQ4oisI9O+kVugvslNbjNbIUldkogB13Epu1nISW98GVMn5F4Twi26ErxWhayHmelALvfdhFVpxWGftbe36ZiVAFCkMSgrqHCvaagP6DGTBFTUQd+rJOapH8b4oAJILYWuMxxUmKgZqPq8mLDRU4gycR8ddemflCy1wnPwdBZVwa4HRW+bQ0fhrCeguzpgx8wXEIQTOR0Ua6CHABM8JVx4ySWTfaAx8VEQImfM1n1ifhXow25Ilsp9za47PbwJ+LC1SPmc+haW1GTkwNYkStFSlPYzNVbrZ5SeVoeLly6pSIEspLKwv8Q6DX+l4GwZhR7M1JnJFza7mxjWcKEljmuEeYKMUupCOkL/TU9apv7fGzYy2onXfutkipriTklmCB6K3aaghtDnpUmoDYzdTxzdo2cLrL2KaNOIa+m77ohhhJ/m3D69mtgXeMtT0ravwasbJoOgEjUyz0eAJHG9YGIn0xSuNGEOTTjthj38JnvVi2K23PZkgRcLz2vlJ+FWt5YOGcTo5jXFrhgePr7Aj62yqmvxBAZwBVXiAllAiYIIrWIh+7KYYCewsNjhnAPHzHYWK4H+YCFs3CN4dTkEnqaTt+NwPL3Fi8y4kHDVLhAVXL5om1RwnTV6zMQU/TrSE+CBMzc2HOohSMMpIDrXFShwUwldkJKSmr+r5NtEH+wp7568PCx5YiH4omWos6g8SyoeftU61ZPFcR2heEDfyRGKEcrfd443szeAV76xM6495AHzxflCNkGGre6SjLmPXKpUVUCzwl5e0ZMb//+LOC5frZlUjte277CvXgUYAJl8dC3lSzHqvT2utBmQZX+C/vezZuomSVUCg3sDqxnGAan1KTbARJtbjSXg9JAQiBe+HD039qNVbJYoNNZp63/C7c2JMB77XZIn
 3XgFgtPM
 krtdmImPBTLlqGtyWgTPad7iQ1fG+FjBtpvyZDlmZlDpYhBQD1a+BqFKeAVrGmpQ5UgYyTS6attq5YynO2RRLdseqAl0IBUdYhEnDfVAww1kGKcN6gf1ko7k4xXm0EwqitfhOfPPjfNYntNppBKSjceEWYOa6wGNWr/75jfbcHxxZT5ZOIEP2vvNEAa0rGc7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 14:35:38 -0700 syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    89a312991dc6 Merge tag 'cifs-fixes-7.3-rc2' of https://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=101ab0f9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
> dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151ec39e580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1761ef79580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/9e57f69218a4/disk-89a31299.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c6ae7c71d018/vmlinux-89a31299.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/82fb8eee8abf/bzImage-89a31299.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com

Thanks.

> ------------[ cut here ]------------
> pgoff != vma->vm_start >> 12
> WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/5876
> WARNING: mm/vma.h:277 at vma_set_pgoff+0x246/0x2d0 mm/vma.h:283, CPU#1: syz.0.17/5876

AI tells me Lorenzo already fixed this with "mm/mremap: reset unfaulted
VMA page offset for MREMAP_DONTUNMAP".  This is presently in
mm-hotfixes-unstable so I'll send it in to Linus next week.

Err, make that this week.


#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Tue, 25 Aug 2026 08:55:26 +0100

Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
a faulted VMA into an unfaulted one.

It does so after the page tables have been moved to the copied VMA with
MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
as the page tables it had are no longer present.

However, in doing so, it violates the invariant that the anonymous page
offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.

This is because a VMA may have been faulted in, mremap()'d (causing a
delta between its page offset and vma->vm_start >> PAGE_SHIFT), and then
mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.

This condition is a violation of a fundamental assumption in mm, but now
also triggers an assert in assert_sane_pgoff() which explicitly checks for
this condition.

Correct it by resetting the VMA's page offset at the point of completing
the MREMAP_DONTUNMAP operation.

Link: https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vm
 {
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
-	unsigned long old_start = vrm->vma->vm_start;
-	unsigned long old_end = vrm->vma->vm_end;
+	struct vm_area_struct *vma = vrm->vma;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
 
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
-	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vrm->vma && start == old_start && end == old_end)
-		unlink_anon_vmas(vrm->vma);
+	if (new_vma != vma && start == old_start && end == old_end) {
+		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
+		unlink_anon_vmas(vma);
+		/*
+		 * The VMA is now unfaulted and it is an invariant that
+		 * unfaulted anonymous VMAs have page offset equal to
+		 * vma->vm_start >> PAGE_SHIFT.
+		 */
+		vma_set_anon_pgoff(vma, pgoff_unfaulted);
+		if (vma_is_anonymous(vma) && !vma->vm_file)
+			vma_set_pgoff(vma, pgoff_unfaulted);
+	}
 
 	/* Because we won't unmap we don't need to touch locked_vm. */
 }
_


