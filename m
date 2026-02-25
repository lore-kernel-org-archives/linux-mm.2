Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839BAFD3760
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73186B0088; Wed, 25 Feb 2026 08:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20D76B0095; Wed, 25 Feb 2026 08:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D076B0099; Wed, 25 Feb 2026 08:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF4E6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:50:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A65F1A05FC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:50:23 +0000 (UTC)
X-FDA: 84483113526.30.9C83C4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7573B80011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:50:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWYj+DK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772027421; a=rsa-sha256;
	cv=none;
	b=nsjygEs7ETQL49RTgqLMi3Kba/bZzfzIhpewW7zSp7NzBGKuf7K7R5V3H+39duPljoUCuR
	tUugjT60WJaxXDuwcg3lPd4/0u4ePJMl8Gn151ohOXwpguB1q79M0GNnFQejzAkd62hPlJ
	nc7otqpPy9U58GHaJ8GB7I/CzREjNJQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oWYj+DK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772027421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lq5ecgA+9mTidS5h/GOx3OFkzcnwMmoNARsZjt0qEkU=;
	b=HET30nNkIB45ADny3N4EmYk3SAxj16m8AOMYf9tkUCBCqAor8Qeu+NtV+QbnBXMJN4uuZI
	oyWBZeEwScXytWKvXwrL5BEdfcAPrQaBsORfzCEV6Kpgk52ZIpeod6r/SjmcyN0O3OiNxj
	eCuJ8q1gJmeX4M4/GGMw0vCSlIEPAdQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D905B60126;
	Wed, 25 Feb 2026 13:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B59C116D0;
	Wed, 25 Feb 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027420;
	bh=mevslpoK0ZYqJd8J/tRXskOYzzQGZU6+tC6Xef3xsDo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oWYj+DK9G7R7SbizbH3STLSaU8Lo6I4REPxazn98tRvg8owFxze7IZD0Fgc8ONMao
	 3iQ/lzXs009ZGq92BwM6afz6LtquWd5BXicLzg6k0Cp0qr1bkgsBG1odk/EyExAqqo
	 ArRnWP7cDxcy0erdcHEX2ZEn+RPjVxLKpxAxGXukSTuMGIzMjCGUwJNDC6Ip8SH50/
	 MYBGLV+9X+w0/g5AMlJDGCSqYKCNzpGzR52mzkVZOCM6k8F+k+DRf/CjRLGDowEsrp
	 q+RNgtkqGfvwwEdSPAwgfjoNhm3LSQraEc/DG8VFjUrBXGE/rAUY3/3SlVOYdwqCaN
	 Y8Hq6uOXTl3dg==
Message-ID: <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
Date: Wed, 25 Feb 2026 14:50:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover
 full VMA range
To: Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Zi Yan <ziy@nvidia.com>, Gavin Guo <gavinguo@igalia.com>
References: <aZ78kFBEA2SjgT93@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZ78kFBEA2SjgT93@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7573B80011
X-Stat-Signature: s73a8m5yu96wjfurbbnhq4jn6j7a4quo
X-HE-Tag: 1772027421-88102
X-HE-Meta: U2FsdGVkX180I6igzQX5oIcykD4J1rrh9yRSKRNCLSF3PokBvWu5LH/IBWcK38qGkyDcZGZj5O/DpE0xL8vQy9ctY8uSb0TuxjEbQC4rCOg/7ufBj5tRxg7bqjabTKqCtmR5AP0SdBdc/bIagESz6i6rPT94AKUYVvZW4IfU0A1BNeiGkjhfo6scK++EEXiDFdLGcM13GPFsEyBGz8sag/0bs/ecWzyPreGFKhSkU8nFEGF2Hr7y5I6rqWyLLb/PYjp0Gl9uudfbflBaZH3l3W5q/RmJECf0ssTJauq1di9efQUKgRWycoZm92J1A67IKLu8TmhovNBukGwxZ5JS42jbi7DzQUgk1lsl57f0MgcsUMNB/NvuHODuRZRwZpKOVPNwdSPDdqp+k236o12rby5lhzV6uY0KKH13Jie3v9htfXMVisp/WUhpjPVOIy+cClJ3stimdcLxOTktTaAF5ohgCoayW0mP7g5L5lm+c15RucYzm7ZJCsS1Dg+yV2OhEnNNEbFcqUTAuoNeFuJBW/IYBvfwnZqCSELopaqJBS5mrcp/ChPSgNAig25uhmpFwq6Znlgzzpyrxg4uqRu2G+H8HSbY3emx/atrCZKisubU35FzVv9SFwcKIHYSg7Gq+vijFYTCYl4OKfnkU2BW5oFAleAGrHx9uJOB0rblgcsS/EPFmSsBFJ4fNe8sA5lx5lWfDy7ZRkVorbbrq4eUJsUlbui7f336tdsCp/vRcm6Peifar/NYHx5tJH4SOZhzZ1T/ZzLIZBKVMmTJ1MtYe4l3vC5uPUGdebn5eIOo0FyBV0VkdJwjB20/hwTXeGJOQlqeDuFQiuQZDDDxEyPLxyju31l8NRUowTkw1g7tAQoMpyHsj8P3oSHY+Yxjy6IA3e+FumoR/mnmnSBjvWQTGMlcdvjPgM24LnS/q11CImDhd/6AkpDT5SIrsnLgi1CiD/rkQmDAO8whbHQRauZ
 5aX9TlWg
 EI2+Dt1uRWaYTKdagl/ysMcCowXd1WFkdYjJUpbKkMnKNepzmgW4/KXFNkXieppm15DZMLno+Z+PuFVnKryV3apKzo6ftUZ0pNyAoYRzNsr8IbS3X21/J1Z/51IvSG1BXZ/r83k3wS6LlAqAw/HL/0UGRMJ691CPkH3SptvKGMvGQeWNQHj9wvnj0ukM8nSBFk6cMu18XMT5e64AaVOxxroGdRrc2K5jyy2fOLWQ3+TSDMn3saKL727mI0fD8MoiQgzaYtB5ciD0JcUOtxpiyLFKpRtPm2yIta7V8F51YXU1Fn1huDz18gmZOr4rQlVdKifC4cYKihxQ/h10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 14:43, Sasha Levin wrote:
> Hi,
> 
> I've been playing around with improvements to syzkaller locally, and hit
> the
> following crash on v7.0-rc1:
> 
>   vma ffff888109f988c0 start 0000555580cc0000 end 0000555580ce2000 mm
> ffff8881048e1780
>   prot 8000000000000025 anon_vma ffff88810b20f100 vm_ops 0000000000000000
>   pgoff 555580cc0 file 0000000000000000 private_data 0000000000000000
>   refcnt 1
>   flags: 0x100073(read|write|mayread|maywrite|mayexec|account)
>   ------------[ cut here ]------------
>   kernel BUG at mm/huge_memory.c:2999!
>   Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
>   CPU: 3 UID: 0 PID: 15162 Comm: syz.7.3120 Tainted: G                
> N  7.0.0-rc1-00001-gc5447a46efed #51 PREEMPT(full)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-
> debian-1.17.0-1 04/01/2014
>   RIP: 0010:split_huge_pmd_locked+0x11a0/0x2f80
>   RSP: 0018:ffff888053cc7338 EFLAGS: 00010282
>   RAX: 0000000000000126 RBX: ffff888109f988d0 RCX: 0000000000000000
>   RDX: 0000000000000126 RSI: 0000000000000000 RDI: ffffed100a798e43
>   RBP: 0000555580cc0000 R08: ffffffffa3e62775 R09: 0000000000000001
>   R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000080
>   R13: 0000000000000000 R14: 0000555580c00000 R15: ffff888109f988c0
>   FS:  0000000000000000(0000) GS:ffff88816f701000(0000)
> knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007fe2ac1907a0 CR3: 0000000021c91000 CR4: 0000000000750ef0
>   PKRU: 80000000
>   Call Trace:
>    <TASK>
>    __split_huge_pmd+0x201/0x350
>    unmap_page_range+0xa6a/0x3db0
>    unmap_single_vma+0x14b/0x230
>    unmap_vmas+0x28f/0x580
>    exit_mmap+0x203/0xa80
>    __mmput+0x11b/0x540
>    mmput+0x81/0xa0
>    do_exit+0x7b9/0x2c60
>    do_group_exit+0xd5/0x2a0
>    get_signal+0x1fdc/0x2340
>    arch_do_signal_or_restart+0x93/0x790
>    exit_to_user_mode_loop+0x84/0x480
>    do_syscall_64+0x4df/0x700
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>   Kernel panic - not syncing: Fatal exception
> 
> The assertion VM_BUG_ON_VMA(vma->vm_start > haddr, vma) fires at
> mm/huge_memory.c:2999 because a huge PMD exists at PMD-aligned address
> 0x555580c00000 but the VMA only covers [0x555580cc0000, 0x555580ce2000):
> a 136KB region starting 816KB past the PMD base.

Do you have a reproducer and would this trigger before v7.0-rc1?

Lorenzo did some changes around anon_vma locking recently, maybe related
to that.

-- 
Cheers,

David

