Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DB9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C532B6B0092; Mon, 24 Aug 2026 12:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AED6B0099; Mon, 24 Aug 2026 12:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B806B00AD; Mon, 24 Aug 2026 12:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8116F6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:14:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 130771C02DA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:14:49 +0000 (UTC)
X-FDA: 85136661498.14.2A8E6AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59AFD180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:14:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fleR4EN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787588087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCYdRcoHBE/Gq3BI5P9+1NzCBeCMi37CaPje/hdS8Gw=;
	b=rhqfeOvDlppofAlCDy3qTPus3tZqB5Clw5wKH5X2U+Uw/r9XJA4bJVNyH4/JWEl1RTrHPg
	9/k+sYcHLUT4uDOt3v0Hh1Rchweg5rA2jXS628BQnDYTskbsAl4pAuHSYihsK8REUAMExg
	tIkimU5ueZzDH8xlynxhJ7htZcjibu4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fleR4EN4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787588087;
	b=6VRTMMLCA98A1THk/pxS/NYmfHVqepkccRWyacKVJsnafhLdpBzFI5JX4M/R5+/EXuytg7
	72xhRWfQxCUKgRyD1bVpSpjf74G4HO1OcAPlZ2AqOPfLM0k8drzvlAlLKoJV256jqXb4lK
	P+tdTzLKbSjWC4Rn3uMRMgQ2OqZUXqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8181943C6A;
	Mon, 24 Aug 2026 16:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1B21F000E9;
	Mon, 24 Aug 2026 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787588086;
	bh=uCYdRcoHBE/Gq3BI5P9+1NzCBeCMi37CaPje/hdS8Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fleR4EN4mU6mWRvkRfzkfZ9t/Gjht4+f+Yt+bKju+aYXc6UVFPtPpv5H5SERZar3o
	 BAOehAI5Hdr7UX6TkEyAogLM/PdOHAd7UaGpnkmsWpdmlXPLirrVNNlV/jHGW4NJAF
	 qXPJXjd9iDyVeMlhMQmiwfBAydKP2Kgf8hnX1w99G04gk620bjSfUvXi9d+C+SWOsV
	 +QwqpbJ80EImiNfQxrw079GYjHEArcsF/HP3F9bOhhvfSxi0zseCrQzT3GosluivpZ
	 d9YTYtjKF3+AAMcb1r3A5P2YqLkIU3CI2XoGbKm/Jbx0f92oUKU63O2jAr2asYMpKw
	 1q2eAfbt7iXDQ==
Date: Mon, 24 Aug 2026 17:14:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot <syzbot+f12658786a4153df5113@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] WARNING in vma_set_pgoff
Message-ID: <aoxU4IKe9fC0fw_a@gremlin>
References: <6a87853b.ae6ddae5.3da009.0023.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a87853b.ae6ddae5.3da009.0023.GAE@google.com>
X-Stat-Signature: rq5mdpc4pxj5hqxm3thkd8u8nhedtbfh
X-Rspamd-Queue-Id: 59AFD180009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787588087-853546
X-HE-Meta: U2FsdGVkX19qjtUv2zb7/n1dmb/FCJ/UcV16N4h5JsapoqvlFIecgSKose0tfPSZixVEsWzsC/1RAuJQdDmewx/7oieAIZOiVhCok2tHMXDv76kIXhhfCK/dkGaQPas59/3Oh0yvBPlz800djt8RjjOV/9n9n5U16cAMAZESGdomAUSzg9T0D8D//nrShI5iMAr+kNuUbGx2a9zJ3rhwsht9UYh6OqCcz9SCHl4UcC3S37RrbyvKvkktJ9AZHWsriggh0O2b3jmV5C5Pum7XUiS2Nl781s28n71DhcebeTvcTyXUcOD++QvaMQHb9xBUo4IdL/R6F6Y5imJsgR4bDRsCHHODHAXShv+GMS/qk3amnon0Pqf1tMJPRotwZVEMUTV1iNm1WLCPtp8Jmppu0QXoQUpnAs0dcjvQrHUWbt7rIrP/ofxdt2ygiePH+PhDF4Ss8iUkHGNkb+lVG8APKHn7C4e1h5uL0HIk08SqWFgPTGOYIRgJokjL+GSPsx4pCbQtL2W8T1ACOtHep6H/EDFJT5iQgT7SzYC6mCTrOZaihNJzvymrkBJwnChi4XbiwlncIu9PKRjVNtUr/C2QH5fAFsaCEkzrfaEJ+bWh9lH31WUUszD3+oJXh/uKPF8RbL7ukaSbLTKn8LZScQBNaHQSDEPBuuMiHjcAFdcJJp/U+DcuqMn8xjvrpW1TO+wQVPUquRT/4gZY7mEh9fE3qnQ8QF4Ste+zn+MKwdDkth9r/bvMVXmJje5A/iTMWFFzKD6ZZE8AVQmgYnlQiOHTPZGtbI5ubsETn1o3SlL0raXCrHYTAM+j5lnMsziE9XFYigtTc9uDiheZRzWRT+xOh3YVlVtpmPJEQYqimAwZKfaoYKIJCpi4g4GMZNALzDWrby81xHcq+sJVycZ1NZEGB1aBfak1dSaa/JAU0BXkuzPh8XY1nuCvj3qP0PnrULUEDvwOTnxKyqLuUTnh8dB
 mkaEQ7uV
 E6QpGEv3zb6hMeN0foHfE3FMUM8kUHOgv8A3e17WtmCAaFdJcUnFShqCoy4zGWlbDb4QYKIy/eLAiHUuxH1HlCaalmAIXfOq/jtVr1C6mrug6USdedJHUhM3FA0q7moSf7jn7tw66mueR7YVRAtDS9mgxQSiXUrOGmiQjiPWj7dS42yLWzgkVZrLvDmvSUPNQVs+gjDcf6XG9VEV4GbFkj3Jgd6GyjAouueSVjNAIlrSR21VGFEZLIXT1HdRxCUuqUqZA7E7JJMTm0eiXJBGQEYXfonFwOPsVeAMzTJImGSmDQOeCsv+DIMctCkl8BWFLO2KVsVf7359l9blQODiAHaxD/eAW9Rrd4/BfyOAjT1lmJDNv/LBpsZ65sC2CDUelvJqlhfUnpxDpd6WMsBgIIV2zWC2Rjt7LGxAa8wjR8Qnd6tnqI1+gaPRwYVK+YaKdBak5LuiiPi8zgDeSEWDiAYklGQnpeF3s+W2W2Nom7CLKYJRQBj8QNzsZC/dUrWx7dPcL+F/H7nPijFWUGqDGWd2A755UKSSlcRiJW9HvxMEKO4mQxUrPx/B5U4b0l4uyL368d25JRMMjnA/8SHGNLGyRdHR49eObHhumqUvGSTSugpaLGGjRm8ipxO4wuMIxkh5+X43M9AJKVRbmHvtpio0EctSAPc++SWR51++eW9NZPlCicZ9oWwB+Gk21GoeW5G/baIB/0ZXM3v3sPTBvrPYL6UcntIcnYA9IBkeQdRN6q721jKQq6Q7rREetYoDi5I4merUcGV07XIAYjkXtK4BeYeV0oQSmG5xIzIKUTQmlME68kn7aVDZomAf936JsJuHflTfwbHdlejXFzwdkM7PV23PT+lCyF2r/3ItwEEW9qEpPHnnERY7DyheaEPp4wvT1XHQPipiebpcREGMSw6cgLE8PFdK1iL1LFILv2rfLuVQMlsZgJVW/S3FXJYL+eU372uN4nGvZwpMVnvCcmKdag6Xe
 4OdCf1Oq
 NpwVvZZl9XJnlkycmLxeYXe4ICxXkFkwpV3XJEjynLxIML89fCC+S+TYvC10BcqnmZUqsYUFjo78gBiz8mX4rH2yBGJqZvtAxLtx9BlfvbOpyQd3yOwGLLD6zgSeN1fdJ+low81dN8Z9dPnnov1XUyIaEFD5IsjheQu1tV+8hWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The assert that's firing is the one I added to check that an anon VMA has
correct page offset:

static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
{
	...
	/* OK this is really an anon VMA - expect virtual page offset. */
	VM_WARN_ON_ONCE(pgoff != vma->vm_start >> PAGE_SHIFT);
}

Called from:

static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
{
	vma_assert_can_modify(vma);
	assert_sane_pgoff(vma, pgoff);
	vma->vm_pgoff = pgoff;
}

So figuring out where this came from:

No C reproducer but a syzbot reproducer:

https://syzkaller.appspot.com/text?tag=ReproSyz&x=176d5949580000

Decoding the flags and abstracting things a bit:

->

	mremap(old_address=ptr, old_size=0x1000, new_size=0x400000,
	       flags=MREMAP_MAYMOVE | MREMAP_FIXED, new_address=ptr2);
	mremap(old_address=ptr2, old_size=0x600002, new_size=0x600002,
	       flags=MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_DONTUNMAP,
	       new_address=ptr2 + 0xa00000);
	munmap(<0x2000 offset into ptr2>, 0x4000);

So MREMAP_DONTUNMAP is a giant red-flag as it introduces unexpected possibly
weird behaviour.

If we look back to the assert it's that an unfaulted, pure anonymous, VMA has
pgoff != vma->vm_start >> PAGE_SHIFT.

Looking at dontunmap_complete():

	static void dontunmap_complete(struct vma_remap_struct *vrm,
				       struct vm_area_struct *new_vma)
	{
		...
		/*
		 * anon_vma links of the old vma is no longer needed after its page
		 * table has been moved.
		 */
		if (new_vma != vrm->vma && start == old_start && end == old_end)
			unlink_anon_vmas(vrm->vma);
		}
	}

Essentially - if the VMA was cleanly copied and not merged with itself or
another VMA, then call unlink_anon_vmas().

And unlink_anon_vmas() sets vma->anon_vma = NULL.

Assuming the VMA was faulted in before the first mremap() call then
vma->vm_pgoff will be equal to ptr >> PAGE_SHIFT not ptr2 >> PAGE_SHIFT.

And now it has vma->anon_vma == NULL (unfaulted) and vma->vm_pgoff is incorrect.

So we have an unfortunate case of a VMA that is anonymous, unfaulted, but has an
entirely incorrect vma->vm_pgoff.

So this is a bug in the kernel and exactly what the assert is for :)

The assert is triggered on the unmap as explored below...

In essence - MREMAP_DONTUNMAP is a unique case where a faulted VMA can become
unfaulted (let's not dwell on that too long :) but it's not properly resetting
its state when it does so.

I'll send a fix.

On Thu, Aug 20, 2026 at 03:52:43PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4477a78374a5 Add linux-next specific files for 20260814
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=137fc679580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9b32a36dd637b06f
> dashboard link: https://syzkaller.appspot.com/bug?extid=f12658786a4153df5113
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176d5949580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/994c1c8c560e/disk-4477a783.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cd54543d69ae/vmlinux-4477a783.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/407cdf8f3fc2/bzImage-4477a783.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> pgoff != vma->vm_start >> 12
> WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/5809
> WARNING: mm/vma.h:277 at vma_set_pgoff+0x246/0x2d0 mm/vma.h:283, CPU#1: syz.0.17/5809

The assert fires due to analysis above.

> Modules linked in:
> CPU: 1 UID: 0 PID: 5809 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> RIP: 0010:assert_sane_pgoff mm/vma.h:277 [inline]
> RIP: 0010:vma_set_pgoff+0x246/0x2d0 mm/vma.h:283
> Code: 0b 90 e9 d5 fe ff ff e8 a8 ed a0 ff 4c 89 f7 e8 50 5b 01 ff c6 05 b6 05 3c 0e 01 90 0f 0b 90 e9 fe fe ff ff e8 8b ed a0 ff 90 <0f> 0b 90 eb 9d 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c eb fd ff ff
> RSP: 0018:ffffc900035ef748 EFLAGS: 00010293
> RAX: ffffffff8226cfa5 RBX: 0000000200000a98 RCX: ffff88802733ddc0
> RDX: 0000000000000000 RSI: 0000000200000002 RDI: 0000000200000a98
> RBP: 0000000000000007 R08: ffff888076188bc3 R09: 1ffff1100ec31178
> R10: dffffc0000000000 R11: ffffed100ec31179 R12: 0000000000000001
> R13: dffffc0000000000 R14: ffff888076188b40 R15: 0000000200000002
> FS:  0000555576422500(0000) GS:ffff888124df8000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9f85a70000 CR3: 000000007cdfc000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  vma_add_pgoff+0x1a8/0x570 mm/vma.h:314

And that invokes vma_add_pgoff() -> vma_set_pgoff()...

>  __split_vma+0x89e/0xa60 mm/vma.c:607

The unmap triggers a split...

>  vms_gather_munmap_vmas+0x322/0x1370 mm/vma.c:1507
>  do_vmi_align_munmap+0x2b4/0x4b0 mm/vma.c:1675
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1732
>  __vm_munmap+0x241/0x3e0 mm/vma.c:3390
>  __do_sys_munmap mm/mmap.c:1094 [inline]
>  __se_sys_munmap mm/mmap.c:1091 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1091
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9f85b9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff50d2f8f8 EFLAGS: 00000246 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 00007f9f85e25fa0 RCX: 00007f9f85b9e0d9
> RDX: 0000000000000000 RSI: 0000000000004000 RDI: 0000200000002000
> RBP: 00007f9f85c35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9f85e25fac R14: 00007f9f85e25fa0 R15: 00007f9f85e25fa0
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

--
Cheers, Lorenzo

