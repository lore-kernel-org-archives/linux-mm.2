Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D25ED103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230676B016D; Wed, 18 Mar 2026 06:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1626B016E; Wed, 18 Mar 2026 06:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D07B6B016F; Wed, 18 Mar 2026 06:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEEE06B016D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:57:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C3CBC23B3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:57:32 +0000 (UTC)
X-FDA: 84558882744.28.6719A82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2795C180006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:57:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4Lo8oTE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryorv6pc8hXgfbGkNlV4bUxgtGbgRvqf2OaIvbSrhnM=;
	b=4LTx84tJigG2XA8MDTv+bpyB/UpGMCvBYUfIu6TKoh8pWorMsi3WrxFXcb5Su3hrIXKe4k
	OVZ0jVq22QKYKwjgJrAMjcCu9YHkNkXMs+kVwUkfWSv2FjDd7fqF9DPJi3j/ysi4BIPNL7
	/aaoF/vl1yEgtC4JA6u5HFUs/fglIuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831451; a=rsa-sha256;
	cv=none;
	b=sNXpA74hrDgN+T+75Ume5hX6CAfDQ0Q7btNFjGaFDF8vPbSths3Dk7+LBShybyNAQyKhkG
	UUVBj1J5UjphfAyKDDr5CqkbpaHp+R7fygl99aJSuAxgxQw3isqPfHmJijx1Ht9VW6n3xK
	TAJ0A8fppaJyFzHnIZ8MQ0fREtxqjGo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4Lo8oTE;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D85F443DE4;
	Wed, 18 Mar 2026 10:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57974C2BC87;
	Wed, 18 Mar 2026 10:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831448;
	bh=q46ZSdUV6lxuB+hSXhPi3Ktiumom5RYsKeG4TlXhPbA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r4Lo8oTEbgWeJsYAt1GfYDbY1fHRB6yuwVGdkZkptWgGED3irgtI/D9Lvv1CfcKNA
	 woOHhlaPFeQhEKnVtJ5SAy33mMhQjb5z27KSkfiKvB98JQO1/5vSVzitvdD32jwLQz
	 3+fsNZb0ibFUAUeJkrMO1qSa0EoKkkp3FEt2BbN11Uru68j6AX1EAGTkUqya0QEOB8
	 Jrh3UKvZmFaq8LXFzpieHtPC6luV1d2dFRiNZb7jwEbpwYZV/1JFI6midrr8AeUu9M
	 CFSMYTG8mcESkoqi/ENhkMJRNmuXEFJ/cjZnYVpkS4ZE/7Zd/QKg7i3YdOHAvfjJRq
	 dUjS6inBtqQtg==
Message-ID: <7eb61bf4-5483-43e5-a1b0-87a36cd67b9c@kernel.org>
Date: Wed, 18 Mar 2026 11:57:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
To: Jiakai Xu <jiakaipeanut@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, harry.yoo@oracle.com,
 jannh@google.com, lorenzo.stoakes@oracle.com, riel@surriel.com,
 vbabka@kernel.org
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bmeq4y4w9da533mduoprsr4ygf1j8e9m
X-Rspam-User: 
X-Rspamd-Queue-Id: 2795C180006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773831449-285712
X-HE-Meta: U2FsdGVkX1/Euil3eWZjQDKqPGbFaE6YOgD2fL8kXZHGefl6pPuKN3lJsK+CKYi1IpIKBUGEJKjXrrJ2QYS/XjOrFidnrW6Nm/+ClSiPTuQTQ8YkeIGQzXdQvADOqjQACUEjAO098VH+fh+UfTjP8DMHvx3CqG5FbT7myzaGeVtNbC7Ok3M1HWxVNGthWD8oaFYzjQ0w+ubKNkgDY2YS13QzQ2GnVWwJrvgLaXm6fXzFb6NVsBOlTWZUQ3tUdWHIl12K+eveLERIW0vkNNyEQTBREmUKrdqsGIvDQhRI4CXkSIws9t/w2Vimr5Sufwr+Aj0yn9dqX2V77uQZVF+q+JvS+ItTBvirBjSPCtS0Rjnh46apBX3kQzgCQS4GyRb+VBSy7MqB9Elh8cb+1qWfewXeYzdN5/yOvJXLa1il2fugMdV7RTidNec6L31AUnZ7OWSE63gi5vWOFOYpUuubLt0buvzI09C7EDHQ6qx2/dNGexqRsQjTRIbXlg5zfsENW7oVlI0YX8m1D0KbqXxPTLIHq+aUqNwAjZUk+dJJYqYFWuEbHJXG12vGJ2899RO4h+AM3HQ/LmrzwEKfseBL1TcFFVvfqHwM1askfdlYJNXM7pfP0wK10ogP9ZG9GkbnvAxaKJ6LItZSNefbtJT1AOp613HnWcWcxD1TDYWYAfdnCaJfyMLaZltnXUjnEMMbMhq5dM/ADPvby8Yq7JkmMo3j9bBkUqoQWgjActzRHf/Vrrd8JE9Kg84Jj4RCKpZ87zU6qgBLh2mBx3EIFpvKKe7pKtz4QLuQM7DXvB/DpCgFwxZMMk6AJdftBfAM0ueJL0+qQ7kgnao8Qr1Gl8G1nHOjKQ/+dUqb2+ozjghL2lbPy5DokeNYcVIFOHO34E9WIg0bBGr7YTRcfRHnVycXdkHEHKEzrNs/1fYZECYnL4XWLJ2WFhkl7eKTE1+gx5fpiFz9+UoX/v+KnSck1L3
 shsLDbdI
 uribxcEF6imWDms+kAKqsoeXUnbZyWLQFCqTNT5z+7O/WrfJGownUjsNexH+WFNyaw2xctlFqBqf9fMIajAHL/yVULJ6wAt85AvNiMXF63x8f5EjiPqcyUBbfkJoHMK3Z3+LxcUD/ZeXE8tLObwGaXVbZTV4efoqopEqYSLG244o1TxTilaf2/QJthqceSA44KFJpzBqvNLkhZM++q6P6lNZscJDxHth1yU5zDzYpSI6x+uAJ4YEGse8UZ+w0EiCSKV2vmdct0Cd1q061erlHhjfN0CoAj5bZLHDKL1MXpv9hCPnDhys5Mq7VgBiPlgTM5APghifPye1PWJqWrnQ4skXGqSgjxHgkifFF4LwvGEBpEvKCWAp4PoBksARiui9hTYq9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:42, Jiakai Xu wrote:
> Hi all,

Hi,

> 
> While fuzzing the KVM subsystem on RISC-V, I stumbled upon a kernel WARNING
> that triggers in unlink_anon_vmas().
> 

Looking at the log, this is against 7.0.0-rc2-00014-gc61ec3e8cc5d

>  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
>  unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
>  free_pgtables+0x2a0/0x860 mm/memory.c:427
>  exit_mmap+0x406/0xd14 mm/mmap.c:1314
>  __mmput+0x114/0x3d4 kernel/fork.c:1174
>  mmput+0x74/0x88 kernel/fork.c:1197
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x7de/0x2adc kernel/exit.c:959
>  do_group_exit+0xd4/0x26c kernel/exit.c:1112
>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>  __riscv_sys_exit_group+0x4a/0x54 kernel/exit.c:1121
>  syscall_handler+0x94/0x118 arch/riscv/include/asm/syscall.h:112
>  do_trap_ecall_u+0x39e/0x62e arch/riscv/kernel/traps.c:344
>  handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232
> 
> I am not an expert in this area and have not done a deep manual analysis.
> 
> The full crash log, a reproducer, the kernel .config, and the relevant
> source/commit info are available in my GitHub repository:
>     https://github.com/j1akai/temp/tree/main/20260318
> 
> If this turns out to be a real bug and there is anything I can do to help
> with fixing or testing, I am happy to do so. I hope this report is useful
> and sorry for any noise if it has already been addressed.


We trigger a VM_WARN_ON, so that's certainly something to resolve.

Seems to be:

	VM_WARN_ON(anon_vma->num_active_vmas);

Which was added by

commit 2555283eb40df89945557273121e9393ef9b542b
Author: Jann Horn <jannh@google.com>
Date:   Wed Aug 31 19:06:00 2022 +0200

    mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse
    
    anon_vma->degree tracks the combined number of child anon_vmas and VMAs
    that use the anon_vma as their ->anon_vma.



-- 
Cheers,

David

