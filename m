Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B79C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 16:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D416B0096; Fri, 31 Jul 2026 12:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D645F6B009B; Fri, 31 Jul 2026 12:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79F16B009D; Fri, 31 Jul 2026 12:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5436B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:07:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 255E916046A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:07:31 +0000 (UTC)
X-FDA: 85049551902.14.4E16B39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 41C6AC0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:07:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOCI1flx;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785514049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYefLO9Ts6Muw+5ON5ixE0yWQxfz5EGL7n7UPE84iiM=;
	b=U4NYD6wmrbvyG9nciTEFbuMlPftsV5SKtcu3DOil/vjGTJJ8hBefhF4UNGgGEPz3ONWHZT
	HGF3SP1lde5Ffa7wU6VxBIQBzftUiKelVUJy3WmotQGrWph1YkOkjZUfiMX+d5SuTTkBXw
	lHb4iWiigSnTYkAbogBESxgh2H76HLo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785514049;
	b=JlhwPutlNZ1MV0fM5PrCaJtksSH1tFWhX4IEG4oZvYKKxmBVTti10HIpYl2BFmoAzc2K8i
	0MpV98RIsZPO7tKaPZGSEYE6D0yWEOqP4RYAU2JEn7IAyEphEnT9n5BHHQNMXzxAAyOoTy
	BNN2rw8jyHHp2d4YqgeBmK5JeXLPEOQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOCI1flx;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2978240627;
	Fri, 31 Jul 2026 16:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A9A1F00AC4;
	Fri, 31 Jul 2026 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785514048;
	bh=WYefLO9Ts6Muw+5ON5ixE0yWQxfz5EGL7n7UPE84iiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QOCI1flx/yhiDcNB+AZ7CVXNt+dea6b/SPzicEWBd3ke459a4P0p+nvZgcTfyR7l4
	 Z7eDSlCJW+T9suLuNzCiW2U4dfQSoL83XFE8ty9xGsBFfPf3mb0hPHPx2zMRgWKU1R
	 mxzeeN1wNUJJ/wHlABxIJDLx/z3HFbOC+atwfY0iPU6gHwSgwQpGPLEyI7mfM3q5i+
	 jET5L6ISuvEOMx56dRysjbtIcvdlHQk+a1ADsGq4+pvmn7HOfS8GIzDorSAvFBesEE
	 f5btpZ0HtRYtzlzvs7xJSOS6RzlM8Wc+UBWsHeNajvjkOEY0zG8kbp9K6ELIhzsw5T
	 bq6t7wVWVd28A==
Message-ID: <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
Date: Fri, 31 Jul 2026 18:07:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Content-Language: en-US
To: "Liam R. Howlett" <liam@infradead.org>,
 syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 pfalcato@suse.de, syzkaller-bugs@googlegroups.com,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w84niqye5ac7irp6rrdc1z77bw4bccox
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41C6AC0007
X-HE-Tag: 1785514049-978719
X-HE-Meta: U2FsdGVkX19P91UrbLORc/CBjcs+8MqoEqDe7wTklrYVAWNPyeeB25WSPH7a52eX61//PNhBKbczD0pts6xmFTqQ9wkTrZ7pzxCxDu5+WJ65meqUd+aS6L1BDFFYumZTG7MpRfRz0d9c6L1CyEqMaO6bEBiaFe5AcZq6gw6WfBFlg+1Qa3a/K34luxady3tIVy2vU3hiJjYyyPVgcndaIOoVXaJvgfTP4OzwEcPQsa3/kYIj+X91qUz9b3PsRxTlVV+xf/hE8d2oAtZGZJGVPDw4Ry8BifMPJGAi5zCVuaGs3P6oURDjHMX9dMqu/Dv11mfZmq7A0gYB1JWeZMU9xcm7n+ClsIAIWk7vbfj+aXnEwnyVK8w2uCdVDYfIwTppb400/sWPLRki6Xx3f3e7BaRyu0JEacFHtU5zIEZPt/Znj28n6Gzmldem8ZgJipAXImc7QTqZMMgIZVzzD9X4ejpZYgVSSoFqHIKwzDkMjtfKsgG+ypX7Qnjcm/zukD5G2qEaYgI/0XfUz1y8+sePPjdJZvgVVglmkn3VQcBD9S8dadDRmSO8S22qeBpFOtgIsS1tAcmthT2WeDCtcl2F6eypkkcB5uAxUCGWYaKx3GYM9K0yHl3B+OvV4MWkDBvNuwk7XpBadBY3GznQAwc0wM73t9j3dGZT4cuGg1wfXhAEdAhO19QEw5JWCwgTrp2hWMzHrlu8DvN6UVWpMwe+TDhVvxTqdIlPVIwM7/T4g4Y5iN+Lb2z+kcW282VVDfn+3zrSSBd/NxfY1dHgPmVYJKJzbzXLW8U26daCrS0kjjUtYBvd2Y5z2SzaYpWzAGVnwqvImEe98YMco9vJ/V5ZyaND6k0z6g+kVGH+/n1VXXtrX3DWZdlZDFDTKhnCjJA4R1eWzl49B8Gi67xU7r7o4b4YA1xd3cD7I7RxmhCByjTTJFMp8rDqOdVwHqv5/q8kXDvexNQ7OaDpb4D6p54
 kYicwRid
 4grfhdD8CZviJfxNpzzUaHRGojnYEmNz5FbX8ZMPv4zw0QQA5yK5C/51PZ/1u5rM38Etl78SATJkntZr0k2iJX5tbPQB2oWI6XlyDm7rnJ2xrY1LhQDiA8KtPwKyry44SdLqjqUxpdpS8mK1b9HSANjPTMPZ6+ztprRJ4MyjmoTjTTJznVXWK6nfIWlvxVn0Mhw/HZUnqRcDra08SegxigGNttRdLzN6JmKYIcNx8sGT+4qviTQY3mNmgTIk8nS0AJMg3q06GgWO8DE9YhYHvUMkyvKcHounxTOKyV7/x7D+a+9HOwsNXq+tPBIfzpcFRkHA6VnnGOAl8sEMULhn8APxCJyH24lBrGGImZcP4jbBRiekTsQF6pkrjnbfxYAtG2BgZDCjzHEtt/ijk3hj/w5zceV0nnPRrDQRztmKhMxNem/RmLKFW9S6zeV1rFNsOjyMndGEd+d7Jed99tJKwGGZWVMEBWmkqRbdm7MWqbGTSx/1e3L83afp5JvSNLDx2EjDwDAPXxaKBUfzouS6O240CmQxDCbOdPURsjYpnu9T3o3C0rb4HSA5cz24Ie5iHdVSd3K54fDDqF+S1koQs3+uoxWsY16NMAsl5cwMIIjqMvurwd1yLSKQiMbyuNXeCiCgZ4n86PIrtjSiqxQWkXKc2PW5UGFb7NhcFg/0A+HH8v/3O2uiyhdkuvSIH8NW5PfDIuYwP+/cGLAh8m7kNW9K6KnFLRll7WiRUO9WgRm/pV18x43h82s2Sh6rjundUpvqDD4GtTFUCEQBC/usbPbgqvMMbsZcFj1N1KKkYAfff0IAWWq+nb8WX7to/QPU4SCWc5pUn9OlWpaXOgx3+jnL459hwOFL1zp2wL00kglhGLNAENVSlJfRjXuDpwlY6jBIV1oyfJOY6hvZdQs/i9S+bl+VyKhRBTGXB0CGTIlIKG6gW7K9wSGpMAX0pVD7lbFJZTZFm9voQJjYoYERWj+xmsEYN
 g376fXrW
 6owjszfEXf3aHrnU+LDhcsQpKNdSH39vx0h6jMjmpFj8AXRSVzhb8+t6hLNGqz3pQ/oVi94p5J203eZB+IYf4M/GSTA6RqU4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 17:59, Liam R. Howlett wrote:
> On 26/07/31 12:30AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    cc2b5f627e8c Add linux-next specific files for 20260714
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15ce5632580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2290ccbf984c524f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=78a7af91b68fc6394771
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179151b9580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/6836f8efb1da/disk-cc2b5f62.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/0109d3477cc7/vmlinux-cc2b5f62.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/c2e49e350bbf/bzImage-cc2b5f62.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com
>> 
>> ------------[ cut here ]------------
>> !mas->sheaf && !mas->alloc
>> WARNING: lib/maple_tree.c:5751 at mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751, CPU#0: udevd/5627
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 5627 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
>> RIP: 0010:mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751
>> Code: 4c 89 ff e8 d6 85 ea f6 49 c7 07 00 00 00 00 b0 01 e9 95 fe ff ff e8 f3 2d 7e f6 90 0f 0b 90 e9 2b ff ff ff e8 e5 2d 7e f6 90 <0f> 0b 90 e9 77 fe ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c ce fe
>> RSP: 0018:ffffc9000562f8f0 EFLAGS: 00010293
>> RAX: ffffffff8b4775cb RBX: 1ffff92000ac5fbf RCX: ffff8880366e3e80
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: 0000000000000cc0 R08: 00000000ffffffff R09: 1ffffffff1ca1a86
>> R10: dffffc0000000000 R11: fffffbfff1ca1a87 R12: dffffc0000000000
>> R13: ffffc9000562fe18 R14: ffffc9000562fde0 R15: ffffc9000562fdf8
>> FS:  00007f9021203880(0000) GS:ffff8881259f2000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000056467bb0d750 CR3: 0000000046416000 CR4: 00000000003526f0
>> Call Trace:
>>  <TASK>
>>  mas_store_gfp+0x37a/0x820 lib/maple_tree.c:4987
>>  vma_iter_clear_gfp include/linux/mm.h:1674 [inline]
>>  do_vmi_align_munmap+0x30c/0x4d0 mm/vma.c:1644
>>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1697
>>  __vm_munmap+0x241/0x3e0 mm/vma.c:3347
>>  __do_sys_munmap mm/mmap.c:1079 [inline]
>>  __se_sys_munmap mm/mmap.c:1076 [inline]
>>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>  do_syscall_64+0x17b/0x530 arch/x86/entry/syscall_64.c:85
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f9021368097
>> Code: 73 01 c3 48 8b 0d 61 2d 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 31 2d 0d 00 f7 d8 64 89 01 48
>> RSP: 002b:00007ffeaf32d0a8 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
>> RAX: ffffffffffffffda RBX: 000056467bad9bf0 RCX: 00007f9021368097
>> RDX: 0000000000000000 RSI: 00000000009480e8 RDI: 00007f90208ba000
>> RBP: 000056467bad9910 R08: 000056467baec140 R09: 0000000000000006
>> R10: 0000000000000000 R11: 0000000000000206 R12: 00005646569e2588
>> R13: 00007ffeaf32d130 R14: 0000000000000000 R15: 0000000000000000
>>  </TASK>
> 
> 
> Okay, so I'm going to change this warn_on again.
> 
> The plan is to:
> 1. Make mas_erase() and mtree_erase() use __NO_FAIL on retry.

__GFP_NOFAIL to be precise.

> 2. Remove the warning so that any failures won't cause the warning.
> 3. Make mas_store() use __NO_FAIL on retry, like mas_erase().
> 4. Add the check for locks that cannot sleep to mas_store().
> 
> Basically any caller that cannot correctly return the failure will avoid
> failing by allocating with __NO_FAIL.  This means the warning is not
> necessary.

Sounds good.

> Thanks to Vlastimil and Pedro for the help on the plan.
> 
> Summary of previous conversation is here:
> https://lore.kernel.org/all/20260618152451.GE231643@ziepe.ca/

Yeah, unfortunately, "too small to fail" is a lie, because in some cases it
can fail (such as the task itself becoming oom killer victim) or any of the
other conditions that can cause __alloc_pages_may_oom() return with
*did_some_progress == 0.

And syzbot knows how to remind us of this, using fault injection.

> 
> Cheers,
> Liam


