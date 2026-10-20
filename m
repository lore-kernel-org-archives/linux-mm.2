Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F932606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ny7xibCq
Received: by kanga.kvack.org (Postfix)
	id 9C4C36B04B8; Tue, 20 Oct 2026 08:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975C56B04B9; Tue, 20 Oct 2026 08:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864FE6B04BA; Tue, 20 Oct 2026 08:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE446B04B8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:59:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEA9CA0155
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:59:36 +0000 (UTC)
X-FDA: 85343011152.04.46E9A67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27AE740006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:59:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny7xibCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9RUmLmMu1KGYjGG2ltedL/onlV4Qx016VCDjCFQv/g=;
	b=4gwFNo77KYDhbBySxzm9puKad4ANOIVKztPQaV4kNC8T2fMQU5KBiPJG3PBnctOkqs/Bco
	JmhmLU6ByOVA0AKVSsdekTaqvlDHAVBISS2U0+/HaQhoZwcvRVH8oq5+tD7qoBr4udIB6D
	fOiinI/9lmQO0zUKmRqyrZWNwhKvvQw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny7xibCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501175;
	b=ACZ23dK6VzsEKtRc/j5hmE5RC+XQ5XRVK81wl/zN8dSjIZK7qwpoI+Ako4b5BANSXpFF7J
	XCFzNjQl2uwOhjkbW/Duv8tqSRUNuaLlpIMCdrUqO8ALu3K+B1hbQzJxMf4CBGBOPF+cS+
	OvviZekNeAN2sZpoY96DEwPSwvUSzq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27EEE43253;
	Tue, 20 Oct 2026 12:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0F91F000C4;
	Tue, 20 Oct 2026 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792501174;
	bh=T9RUmLmMu1KGYjGG2ltedL/onlV4Qx016VCDjCFQv/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ny7xibCqSRC4KpUWk4NQfqIwK0iffFjwPWWzmNxQ1hrSEQRHhJTeBRNDhlOl9uoE2
	 /tThHfSCbz8U8niQDTCTdRaRCZPMRIkgNShXWTbS8ltb4u2W1RGIiRV9bd6Fr7NOI0
	 hZIU2F8u9khb7dIeu95F8gravV0Qbu8W4GFfSrh01mXDhXob5kCsHfDkJERkK2hJ+w
	 c/IX6vHYuGShkCcnbUiE+ku5Ss0O+68FgbzxTTHuQ3CPHbsVylpxGoWaarHg34++7A
	 dXpr6wj1L2jJ23hxEXgwj/M3RZUnCI9uVXBory1bQDQHsM2sALggSorc6I/ifM8Ntl
	 FhPK/gnhGiiew==
Message-ID: <58126141-6915-4abd-8e93-93c4aac474a8@kernel.org>
Date: Tue, 20 Oct 2026 14:59:30 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/ksm: KSM merge drops userfaultfd RWP markers
To: shaos <shawnq1@163.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261020110757.960025-1-shawnq1@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020110757.960025-1-shawnq1@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27AE740006
X-Rspam-User: 
X-Stat-Signature: t1e49x7rqtx3kswbjjpxh8y5j4zac8n3
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792501175-224162
X-HE-Meta: U2FsdGVkX19PaMlCTfCyfeGpwbucmhIDT9vOXkwOWyy/dTkiuD5fAQXbV89tkzOMcoNV+abXC+qCcwMVJKCTVMqa+3uUQT9LBN2NIAeTZ8gqOQK7fASdFDvT2v0WUzFBpwsa5NVkW9+NX1Exbweuh14F3gXxaGMZhainsdf5KmZCc5McOcOoBoNNxN/qprZZ5b0Dl4N9xXKtH8yKSMmZTucbxz4hsnT+L43FK5nvSCyxyVUpdmIcJ1v5S4eJbo4Yx3hF5hpJnx8t7ddaXSv1t4Y6IgRoJQ+l95AEGrapd22IlWdHsFcFGsJlz6jZqmqXd7DEirR/BH6hOPSmk31pfl8iZpwlM4O70CJxnwBeIstfqjHU7IvvmNLXmFvJbIrkxxLcSeWVURT5hVNbgYhLeq9t42m1Sui6xvb6LvtOc0vDH046mUM60EZksUNL/TZkGxgTcorbGevWqfIJQOAMNeoVOK3QohSYCcnDkqe6gJrnFrQau+sXEfWpX/WIJDmc3zNJ9T2w7mBtNogxsWV4Ex1gsphFkkMemcgBJRGIb9uhKKUdSt9qutrW/FNRktXLdkt4xGntluuXztAqmzzNFlqjG5hC8c9eQ99inWyvsCOP2XjBDXaH7P6qzgB/FsV8XXS5JVoFMgbsVIlt+XxYwTM7ul3XwSW8GHrqvNruAsIYZFx3YZ+Ozqo2ISng81pzT45M4Y2zItamyOroB1Mg4/0lV4tEwVji6e5rm4BXiPVjvyWgLtYbBzMJ74YNp0OROZd23zr79alYqUf092Ar5BJYKD2fo0VNeQR0B75MWkuhtAqoO/qF+5HK3qPGVzuucMgIBdjjIXrSNbMA0yrL1njtR2vkN/DaEKORoN6ye4/NgoMBgLrK14HF2XWDB8yh/+wkmNuLfKdhABTFRcN57W4HPNyvS63ZlupeG9VcZg3C1PFTnpcAEsd7zmYiWGfT2Y2KrSPHcY8fYCum3CW
 sWUZfjQN
 QHklxERSaFhV+go2YG623NYS1/Zjdiv4rwrNF3EdvG3gQ0pavqaLiLm8WubH7aZ3K5811cr0A2NACVOgJ9IKrog8ouRjNqPvH5G0Aj2Naqfh6ir/oT5p7tcPOdypmBmvDb+BmYVf25WfH/8xEg++TMP7FopjUb+nB2OsLE3+cRh1HVYDHIWCMmbPCC7RFdANzDDkuGlH6r1Z4yER+SxQISOOJAsAsSY0XmmCP2t/aShxr0MTZ57Gea0pDAGrYseKPzxdZXwAS/GrQo8a9x6kFKX04Xeir53iKKDd1YDjMXGLBSA8iHIPIv29XAh23ST2py3W+3dtip/ghfnqVtEoGSc9VmZ9lJdXR9g5CAhCV7nwO1ieWb1BCaQmfSg5VMal5cwHd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 13:07, shaos wrote:
> Hello,
> 
> KSM can merge anonymous pages in a VMA registered for userfaultfd write-protect (RWP), then replace an armed PTE with an ordinary accessible PTE. The VMA remains registered, but a read of the replaced page completes without the expected UFFD_PAGEFAULT_FLAG_RWP event.
> 
> The RWP PTE is represented by PAGE_NONE plus the architecture's _PAGE_UFFD marker. In replace_page(), KSM creates the replacement with mk_pte(kpage, vma->vm_page_prot) and does not preserve that state from orig_pte. The PoC observes pages_sharing increase, reads the replaced page without an event, then re-arms it and receives the RWP event again. A non-merging control keeps the marker and continues to fault.
> 
> The same replacement path also loses soft-dirty state; that separate observable is documented at https://gist.github.com/shaos26/9db36768f01eb83c6aa14ee9fc057388. This report focuses on userfaultfd RWP tracking.
> 
> HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> source version: Linux 7.3.0-rc7
> architecture:   x86-64
> compiler:       gcc 11.4.0, GNU ld 2.38
> QEMU:           6.2.0
> 
> console output: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/e3e39212903e5bd5ba12f55a94ba7ae5b25bb238/console-output.txt
> kernel config: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/3cd943ba8c6026b43ef016a37d07efd2533a317a/kernel-config.txt
> reproducer: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/7fc8685bb0cc01fca488fc096d4859b8b70af3fc/poc.c
> 
> Build the kernel from the revision above with the attached config. Build the static PoC with:
> 
>     gcc -static -O2 -pthread -Wall -Wextra -o poc poc.c
> 
> The program is intended to run as /init in a disposable initramfs and mounts procfs and sysfs itself. Boot it with:
> 
>     qemu-system-x86_64 -m 1G -smp 2 -machine q35 -nographic -no-reboot \
>         -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
>         -append "console=ttyS0 rdinit=/init panic=-1 oops=panic loglevel=6"
> 
> Two fresh positive boots reported RESULT=KSM_RWP_MARKER_LOSS_CONFIRMED; the close non-merging control reported RESULT=KSM_CONTROL_TRAPS_PRESERVED. No privilege escalation, memory corruption, or cross-process access is claimed; the defect is loss of the caller's RWP access tracking. I checked the affected code against upstream master f47d223627f8; this source path appears unchanged there, but I have only reproduced the behavior on v7.3-rc7.
> 
> Thanks,
> 
> shaos
> 

Always a good idea to look at the list before posting stuff.

https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/

-- 
Cheers,

David

