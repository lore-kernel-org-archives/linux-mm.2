Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A968EA4E20
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A4C6B0092; Mon,  2 Mar 2026 10:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7F96B0093; Mon,  2 Mar 2026 10:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF13E6B0095; Mon,  2 Mar 2026 10:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC5816B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:14:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86AE91A0173
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:14:00 +0000 (UTC)
X-FDA: 84501468240.09.91734F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB0E3A0009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:13:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHCLrJMt;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3V4BahR7IXzqVuDDXZOzgcPmItK9Mg1ehBV/s23e24=;
	b=lg+lNsHzt/YGmKZ5Uhxt109tQoX36waUwcHX+ZqcXsWCXFO0u9n/uU3SPK0E64pF/Qh7nC
	nxCN2Ia6wa4rsrugFaVceQc0wmzJMFBAuc6rOg+iooy8GVCFKmLtWnuWuc9ENcMfixd+T2
	I6nsgU+Zv0eybOyUUEEOhs8GjS4S4AA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHCLrJMt;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464438; a=rsa-sha256;
	cv=none;
	b=W1P1oRgS/s1vPLOuClJe693NJ62rQotKwoFcgtk0e62I7LziMrHt35fE/EEEav377DWo1N
	5qNjfmGvrxcfhVEhtNpDuFhLS4g1FnPzDDGzrdyp4S022RG1PjxqRw5nuOr8sez7mnXo+4
	Ax1/MC8EeRc1jOyDn/qDuh9f8SZ1OeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 324B060126;
	Mon,  2 Mar 2026 15:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B513C2BCB1;
	Mon,  2 Mar 2026 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772464437;
	bh=ZT8Rkh38N7Xs6QE7w/qwKyFa7Or8QcWXgoC+H2FSYno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KHCLrJMtDlAuGbl+p9NZXrjPBzr9DU93OV5tKLUwLKX1GhQRgFht2Myh7tGEoXijm
	 3DmuG0VjGCj3WTyGOKhHj8Mj0eEnJMA8RSc8cnDq+NHTaknL9rqXA5kFObpZuxST8R
	 7v6Z60RMtQEh5tDV0XE8VqLpAMKK38Kmki8zwQgtv+XZVMmxvnLrWa3c3+ksP6x3tb
	 HVo9q3rV74RKGMa65eexLpHF3v/Ce4ZtuWfNaF53mNDhsO/9uIvZd4z+5tjTZN6bIF
	 1KJwhXRHHkQWtVjijbVMSD7Sz5uPjnIwFL3pVn1ciQGSWEa5NhMQDVkOSJRKeZxhnt
	 gfe06uGc1kIMw==
Date: Mon, 2 Mar 2026 10:13:56 -0500
From: Sasha Levin <sashal@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: Re: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover
 full VMA range
Message-ID: <aaWpNEeZgWRE8k7T@laps>
References: <aZ78kFBEA2SjgT93@laps>
 <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
 <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: DB0E3A0009
X-Rspamd-Server: rspam08
X-Stat-Signature: xzmp18deqnh7mp48mghfhk7bh67e87q4
X-HE-Tag: 1772464438-14179
X-HE-Meta: U2FsdGVkX1+xELO3tLIOzbKsYdE+41IpPjch1Job3vOgNNyCBhu5eNNlX5JeDyTi58gYRG8orXeg2NnV15TI/iSLTbyaBgsHVs4bE5HTCNT/sIgZ35vOgEl1t/4nu50xRXHD23jxY3Qwlnr7PMGlyd7p8yzBF+IyFaTfMG/x1iFosfn1ao8qDYcZRkNxco4jN+6UyHf7a5vyf0asf5VyhNSIzhSRLoOr/k0QkR4fYXnKrnxrurd19Pw0RX0iI7Id2HMsyn4vwbCvM3clzBf13tMlEvaEnL9OFp7nVnSwJO4DQhGgSQL6SxWb42RNK3qLDQ/M9g8KgrsOWGIyk63iXxNgM8KIErvkCzGBXZDFfFzyODWTVhJRRBrYhhkRgz1VYzK61YudT6wZTn9NuO5SGMacCs4cr+GKs2NIVVPCLb9HK2Zbkb8qr7pwwjCY6dDKIVqcmuyrS0gGKrrX+7gQNory+k6gwW9tYuKutGaVgZYkn04fyhsu51DcihbK7UD1rxsGHAwcoLaNO8P561QN6v0mUndVk4GooYon+k4QQUkQVU2RW8e9mTUe8MfSTyranurU7VRA4brgongjM+ErFUrFrwE7tAjHTBDAHcHhuy5hTAYWg6u/O9IT0EFMzjccYYR6Ab189mUPs43uQjFIBi7y+9oftb17D3QBNuR0cPlw0nJdqj37FHaBIWet34rtp9xr6gRzf1GPTKceHfMRyOvKT2SyxeUWhWRHOZhrDwYed9IiXhZRQp5mtvHt2HV+wAqSn6gMvTGXKZ48rYR9lencPXkWUO5QeCFh8TJzeg31CaCmxazxtvVlVNLbhm/59Yg0Nf/OG/vCHKLX6skMGo1PdBtXyjYB5JDseXbCGJTPu+qLp3clKi+/sZMGo9JB5lFazpKKirNgfLCFyHjfhnorVX1Esl2G68B5k6h/0YLSF5Y5kZedBf7WusRH2aBGVj00nlyd9PHelbjQuUq
 mCTW7i12
 7uKq9pVXty3Uw5KfKH5mXphBu+G0XeGz+lfwN476w4Aa05EUaWFesdWjFqvzQEvbYvG78hqjdhicSQjnfzK3Lxj+0hAtT/ZQ7vwxVn0OO8QgQiqP+vpMVR9xrzi9xJJUxHJ09lz624LBaYKreynp1YOt6vi7Uj5BAQJTq52lBczVFDyqa/ggHfaXD2g2RTSB6F0+s8VcqC1bHbPv4hyvCaHmWlpBpwN5vcrmeoIxarNNStnxH+/pK/UlD1un0KPtN1rE03luB2kwgDyvgMrh/OVxWNdk8qp4RoE3MylYdqIk/28cL9ou86H0XEiK3NEn6po0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:57:47AM +0000, Lorenzo Stoakes wrote:
>On Wed, Feb 25, 2026 at 02:50:16PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/25/26 14:43, Sasha Levin wrote:
>> > Hi,
>> >
>> > I've been playing around with improvements to syzkaller locally, and hit
>> > the
>> > following crash on v7.0-rc1:
>> >
>> >   vma ffff888109f988c0 start 0000555580cc0000 end 0000555580ce2000 mm
>> > ffff8881048e1780
>> >   prot 8000000000000025 anon_vma ffff88810b20f100 vm_ops 0000000000000000
>> >   pgoff 555580cc0 file 0000000000000000 private_data 0000000000000000
>> >   refcnt 1
>> >   flags: 0x100073(read|write|mayread|maywrite|mayexec|account)
>> >   ------------[ cut here ]------------
>> >   kernel BUG at mm/huge_memory.c:2999!
>> >   Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
>> >   CPU: 3 UID: 0 PID: 15162 Comm: syz.7.3120 Tainted: G
>> > N  7.0.0-rc1-00001-gc5447a46efed #51 PREEMPT(full)
>> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-
>> > debian-1.17.0-1 04/01/2014
>> >   RIP: 0010:split_huge_pmd_locked+0x11a0/0x2f80
>> >   RSP: 0018:ffff888053cc7338 EFLAGS: 00010282
>> >   RAX: 0000000000000126 RBX: ffff888109f988d0 RCX: 0000000000000000
>> >   RDX: 0000000000000126 RSI: 0000000000000000 RDI: ffffed100a798e43
>> >   RBP: 0000555580cc0000 R08: ffffffffa3e62775 R09: 0000000000000001
>> >   R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000080
>> >   R13: 0000000000000000 R14: 0000555580c00000 R15: ffff888109f988c0
>> >   FS:  0000000000000000(0000) GS:ffff88816f701000(0000)
>> > knlGS:0000000000000000
>> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >   CR2: 00007fe2ac1907a0 CR3: 0000000021c91000 CR4: 0000000000750ef0
>> >   PKRU: 80000000
>> >   Call Trace:
>> >    <TASK>
>> >    __split_huge_pmd+0x201/0x350
>> >    unmap_page_range+0xa6a/0x3db0
>> >    unmap_single_vma+0x14b/0x230
>> >    unmap_vmas+0x28f/0x580
>> >    exit_mmap+0x203/0xa80
>> >    __mmput+0x11b/0x540
>> >    mmput+0x81/0xa0
>> >    do_exit+0x7b9/0x2c60
>> >    do_group_exit+0xd5/0x2a0
>> >    get_signal+0x1fdc/0x2340
>> >    arch_do_signal_or_restart+0x93/0x790
>> >    exit_to_user_mode_loop+0x84/0x480
>> >    do_syscall_64+0x4df/0x700
>> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> >    </TASK>
>> >   Kernel panic - not syncing: Fatal exception
>> >
>> > The assertion VM_BUG_ON_VMA(vma->vm_start > haddr, vma) fires at
>> > mm/huge_memory.c:2999 because a huge PMD exists at PMD-aligned address
>> > 0x555580c00000 but the VMA only covers [0x555580cc0000, 0x555580ce2000):
>> > a 136KB region starting 816KB past the PMD base.
>>
>> Do you have a reproducer and would this trigger before v7.0-rc1?
>>
>> Lorenzo did some changes around anon_vma locking recently, maybe related
>> to that.
>
>A quick glance doesn't suggest any changes I made should have had an impact
>here.
>
>_Should have_ :)
>
>I think without a reproducer this is going to be hard to pinpoint. Hopefully
>syzbot proper should figure one out eventually?

So no luck just yet.

I did hit a different issue, which the LLM was able to triage, and I'm running
with the patch right now to make sure that the issue doesn't reproduce.

I'm not sure if it's related or not, but I'll send the WIP patch as a reply.

-- 
Thanks,
Sasha

