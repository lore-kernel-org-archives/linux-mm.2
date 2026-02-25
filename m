Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE0CFD377B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4416B0088; Wed, 25 Feb 2026 13:12:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7580A6B0089; Wed, 25 Feb 2026 13:12:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664156B008A; Wed, 25 Feb 2026 13:12:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 549906B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:12:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 170E11C8ED
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:12:33 +0000 (UTC)
X-FDA: 84483774186.12.CAB0D67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D54C180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:12:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCVhFnWb;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772043151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhX+35GPIOeAxoKO62khBkWu+rr0L+P14BheYXFnUXc=;
	b=1OFwdxMtCMLavkAQbfY+U50TcxJyKZSOcmqXnP8p5OINUJQSQgfj4iAZGaSdnN5NEXFesZ
	DQnUMFvd7V7ZTLM5/n72YLAISGVNW6u6LiUU1ihVdvWwNSLxPG/w6C+h8CD4MFlejte5SQ
	lxwV+jaOwZ11hXFMv/BkeuVf7SiIf0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772043151; a=rsa-sha256;
	cv=none;
	b=CEhQH5fyBPJ2UDfCrUi+TIsaHeBO0/txD1O//C75/9McCWEiJPBjBgd0Ss3ocovbtOWFoG
	jN0JwjVE+eAB7efGbDckuiWURgvs7OJ3ugmFhh9wTsIZ8JvTVFmPK+yWzcU6+TV7MRuSRV
	ZdkRtTUKifXbLD4pp6SzIG0UzKkgmoI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCVhFnWb;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D357600AA;
	Wed, 25 Feb 2026 18:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D280C116D0;
	Wed, 25 Feb 2026 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772043150;
	bh=49QvQ4TbddAGvgoT5UB+apP76VxdQZq65SDCKT6nENw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCVhFnWbSg9j91soLEar5wX/m2n/Q1lo0wOe/qgSz5Z6WsDlWrXd1H2TZCly9lcGb
	 vPxbpIgmTzaB/o624PMvf/J0g2b9KPHlMZIZTdXA4Oxzx2y6PYbbcdmYX7O7MPVR0t
	 KwO9rNKtOCebHu0GpSa6U1Xs76eZjV9jerksdkrp5qm7niBX3tOWu2tym8T1diabDi
	 IDSYjLlOpwfo5Hz4G5qlbgu+7VEMu57elKgfjLBkY1hN1nwmHrh7WizLG6hl5XnY/i
	 kLk7mKPI/zozmsvb6c15wkWL9SOgYOYfhAblCZQGLNgiIfANEiQbzQQzBQOhbof/AJ
	 glOGwReXiBKMg==
Date: Wed, 25 Feb 2026 13:12:28 -0500
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: Re: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover
 full VMA range
Message-ID: <aZ87jIN0mWfBbcEv@laps>
References: <aZ78kFBEA2SjgT93@laps>
 <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
X-Rspamd-Queue-Id: 5D54C180004
X-Stat-Signature: 37jg1msp1tp15rn7jiebhtkps8eif4ps
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772043151-536001
X-HE-Meta: U2FsdGVkX19SvxkAlt53ilaEoXRzm7Iy47AvWhGXbNlG8xD9BrqKDlsOtwbYSR12hSpAghPNA/60UqDVbgb5YodDZFvAaCfx4qRz0yxKsD2qOvfSF/pHqyUWG2UJ6WO7myE8UjDh8KEU6ijhsk/4apZAGnnpZvfjvdLw40Ng6sQ+qkTjXLw4KaaZj+fWdRI+XF4cZmxPdi5QoK46TP0Qeq9o2YIBLXqP2lbWBt6ZsoU7u7KcoTfMi2zKUNdZSlIrLt0SxfiiGXvbM77U9E2wpiYkcMTmwSIT9qvXk4Q4lHFLXv6+vBQWEECnn1vdFl2uUbqMaMkADcOQp75vgl1k2XVxH395wI+rKe5Lv4R5eG56ikyKznXv9UAn4/h0cCMTh/eqhj1DbXBsGC2wAvYCwmfrKdkdPQXbFTUtWRW5Xk+j4L1WOexGCK5XQEiJJ1XQnnX56HC3OA66izVd7kbeyekha5JQxYvRhzZsq7b5bkhrKjdrIcXjabYIxu2es3HI7U1GEIimOGo8D/BZOKvvLYsX2ecgm9VCnecRKt0TBquNNFfSfss3LGS8z2kAuWQhYu5q5jNZ/VxlFfONSoDhtGxZ8+ADlidNTgNexumiT5F+kXhcp69MLhk8uWA+5AQHYcOiGFdYpjdbA4ryWa81IFTiMpQS3ajSz/h9RShxg/CG1Jr9ZU8lo4zIAo0zJ2WF2sXgvvWR8NX6u+8DWwwxu4KUcir0ntj3yLR9ykpkz8NSos0wMwojZFzIlBatzkQGW2i9o6RIdkmx6wwmr0PaEYT2Ozx9Ddfxgas+q5UW5eONkMZbYWLOQucQM1kqPyL4zljWparehDWcAcjy0ffhqldA2SBMSWmtKh0a+EMUJ+EBtGbi6Jp3VxTGsEJAIfcNSQfddFGItLdCLw6bng9nRM5q8zLDaOVjHkSl7WlBKQ7aofiJohaoXMijjkxJiw8qJso6mFAE5ChIOUTH4RK
 7gm4W5Hr
 ODTeB4RhVrJ6xfQlAp9ttlEBDvDR7LpTs+5VYURQpbA+0GHczBhrYOhGN2CgpNNps1HSL4Nn4+Q5p3bmiruyJuXC4qtSYelRJRdMSPvlKAy1/mB18LRplABv+3sQvAatEXxs1DypSXjNR2P+DLw5kGEEQjN7RYUYrpWgPbBsj5kzkKRa03FgHFbLDh0YMoVc6rGWii66Rpa9FCwkKpjKVYCXwtAHIz4IjLH6Ch6aQvwQq1GUhfndMnQ4oTJ6JxLPjzVRWrUq2ni/a51wzB9vermSaRBCdWQrBSJG9dMaDS4jxa+yI6799EahUTV9pBIkyeF+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 02:50:16PM +0100, David Hildenbrand (Arm) wrote:
>On 2/25/26 14:43, Sasha Levin wrote:
>> Hi,
>>
>> I've been playing around with improvements to syzkaller locally, and hit
>> the
>> following crash on v7.0-rc1:
>>
>>   vma ffff888109f988c0 start 0000555580cc0000 end 0000555580ce2000 mm
>> ffff8881048e1780
>>   prot 8000000000000025 anon_vma ffff88810b20f100 vm_ops 0000000000000000
>>   pgoff 555580cc0 file 0000000000000000 private_data 0000000000000000
>>   refcnt 1
>>   flags: 0x100073(read|write|mayread|maywrite|mayexec|account)
>>   ------------[ cut here ]------------
>>   kernel BUG at mm/huge_memory.c:2999!
>>   Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
>>   CPU: 3 UID: 0 PID: 15162 Comm: syz.7.3120 Tainted: G                
>> N  7.0.0-rc1-00001-gc5447a46efed #51 PREEMPT(full)
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-
>> debian-1.17.0-1 04/01/2014
>>   RIP: 0010:split_huge_pmd_locked+0x11a0/0x2f80
>>   RSP: 0018:ffff888053cc7338 EFLAGS: 00010282
>>   RAX: 0000000000000126 RBX: ffff888109f988d0 RCX: 0000000000000000
>>   RDX: 0000000000000126 RSI: 0000000000000000 RDI: ffffed100a798e43
>>   RBP: 0000555580cc0000 R08: ffffffffa3e62775 R09: 0000000000000001
>>   R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000080
>>   R13: 0000000000000000 R14: 0000555580c00000 R15: ffff888109f988c0
>>   FS:  0000000000000000(0000) GS:ffff88816f701000(0000)
>> knlGS:0000000000000000
>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   CR2: 00007fe2ac1907a0 CR3: 0000000021c91000 CR4: 0000000000750ef0
>>   PKRU: 80000000
>>   Call Trace:
>>    <TASK>
>>    __split_huge_pmd+0x201/0x350
>>    unmap_page_range+0xa6a/0x3db0
>>    unmap_single_vma+0x14b/0x230
>>    unmap_vmas+0x28f/0x580
>>    exit_mmap+0x203/0xa80
>>    __mmput+0x11b/0x540
>>    mmput+0x81/0xa0
>>    do_exit+0x7b9/0x2c60
>>    do_group_exit+0xd5/0x2a0
>>    get_signal+0x1fdc/0x2340
>>    arch_do_signal_or_restart+0x93/0x790
>>    exit_to_user_mode_loop+0x84/0x480
>>    do_syscall_64+0x4df/0x700
>>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>    </TASK>
>>   Kernel panic - not syncing: Fatal exception
>>
>> The assertion VM_BUG_ON_VMA(vma->vm_start > haddr, vma) fires at
>> mm/huge_memory.c:2999 because a huge PMD exists at PMD-aligned address
>> 0x555580c00000 but the VMA only covers [0x555580cc0000, 0x555580ce2000):
>> a 136KB region starting 816KB past the PMD base.
>
>Do you have a reproducer and would this trigger before v7.0-rc1?

No reproducer. I saw it exactly once yesterday, syzkaller wasn't able to come
up with a reproducer and pointing the LLM at that task hasn't produced anything
useful either :(

-- 
Thanks,
Sasha

