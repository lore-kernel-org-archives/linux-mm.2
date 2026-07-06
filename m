Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B04C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB55B6B00B8; Mon,  6 Jul 2026 09:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D4C6B00B9; Mon,  6 Jul 2026 09:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB096B00BA; Mon,  6 Jul 2026 09:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD6F06B00B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:34:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A36D1C5E2F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:34:20 +0000 (UTC)
X-FDA: 84958445880.28.026FEDE
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8988C0006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:34:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dO/Fr9E0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vo7wFz5VSU0y8XZ0qkTfFRkiT8Oyp/XHu8Zv4m4Ra9Y=;
	b=7gbkTB48erwUpxVqHV9ur1sqj/QEE+D2zQWMzZOPmVMG7WKCSDcBMpIf/FqA5SDx9kdaMj
	lZ47m4ldW60dHzXdhSbcifsK6WHrmI0/bG3O8oW0SVoaFk00nftpJweNXmMz9w9O7MVE10
	KFRlJNicpJC7JY1Z7bEa8rw83e90Q/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dO/Fr9E0";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344858;
	b=v47W+AwFHVVBksN792k+8OiIv45lqMY5iBU2KfTl0CNalSCifbI/aFAcnD5n3qO130Yo3g
	9p8Cf6ifXBJ//2Z4r4QU1Nfzv9geDw2ZhEHkZZmgDzG27st2CEHRPAkQIQunK8snLRk3T5
	BBicb5oL9AVX/8z5tmeGUIcFjhYFpyo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vo7wFz5VSU0y8XZ0qkTfFRkiT8Oyp/XHu8Zv4m4Ra9Y=;
	b=dO/Fr9E0YKPJtLDFpAOHpi1tZX/ID7ZeNcZrfs2DwtQBLUOoYUiirofd1H5efHVq4ZgwoENGh
	BfHmK3w+eduvHlRpuhFrOITMkIGbd8v47j5qHKdFWt1YICJ0XHbHeF6MtDy7Pl7dopbgCdN2G9L
	QWc7wTnbh8GBAoJ9F83MgXg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gv4pW494fzLlSL;
	Mon,  6 Jul 2026 21:24:51 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 77A684055B;
	Mon,  6 Jul 2026 21:34:04 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 6 Jul 2026 21:34:03 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <xiqi2@huawei.com>, <akpm@linux-foundation.org>, <linux@armlinux.org.uk>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linusw@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <xieyuanbin1@huawei.com>, <linux-mm@kvack.org>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Mon, 6 Jul 2026 21:32:47 +0800
Message-ID: <20260706133247.145485-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626073048.3595106-2-xiqi2@huawei.com>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: E8988C0006
X-Stat-Signature: ie7b78rohmncs6g9ajwd4etc3ipo3dkr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783344856-446486
X-HE-Meta: U2FsdGVkX1+YS8H39V35b7hb2fTgmOKlVtLXLaDSa5VaWUlQ6v0blG8vpiC/wS8TlMHn3MOrJSL7ykD3Zm77GkN8b28aYmBA9D6hhCZsAbjE5q5UE/LsLaTYd3Q/SznTOjFUOXsKVLswuhFXQjiLbBwRIazKfuzT7CDByKCH4yxMC3NFnhfu6cDSsRxR3+ep+ZHlLht7YL1nXOh4Lr1c/km3S6YYWOaMTBK3i3B0yxBttgAhTmgkHS4mbhKF/MSPzYoGoUzLS5tadf8acgBXE4l4sG9OMIujVuoU6xt91es4ajXjX5mo76RIFmKo+YMopofIwwWff2wfuIgCL0r8iLukJ4tKtSS5U5T4fk+x2MDITOa8gFyk1FbGxOdDNLN/ADt43Tl8tYHeSQ99Pi9xwB3MFJ3MtOo/0D10fRZ6uXGFJ+UC1Ji7sHFJoHjV99uWHSKq3dScbxKGwKqFyhbL9ML04YjNnwDtMAS6eQtvEFGoeE9aHeH+c79xcjavrJ4trP7KXpL8oSK67lG7t4Vop6Jv7n/LgAslGHyzmDFcD/GT2P2hkVNVY7Xegd71GvVtIVwy91LZ5tWKy1TCf7rdzc0ScgDoz4KzAz5ABcATxe7QI9sifT/tHnKh92+4UcpG1WhZccWGMYorD5vBpCLnv4DpREDBc5C52WWPLdJCLPqeiBp1/Ky7lF1dwoOhnXZtA2u82CEDHrdDEMdsL9KEUih73dox6iTm+EKsYlUlGHW6tf3MQtSSxKZHMvRDeCh1DWJOPeRJzseR3Xujpk3NGR4wX5m4m+R1YeL/SLFzufBWypiuBgZnkpwfX/6Yt3aWe714MVmVS6lkBcA4WwtHQuRz66KWt0tY2TW3XPX0LOCGHirpu+TfKgLtZrlO/2RyqYKIlHW//ALTqzolaFjBLPvE25MhG2QKFeOddqvxRlEp+glqjsGHjHJhAx2SHHMhsNU85dYZusDNeMIe1VR
 l0+gmIlx
 peemJkgj7TFrin128CIf2Yh2I/HFn9I1cqr5I9cuBvQ4Igw7Mcmdxp80OcnuY/34y23tfA5TzuAkLGxfU8H3t/4OvMxiKSzN8VJEjnUw/v7yu25rjCc22xeON3wK3joLivk21D7LDgUOR+EhEvMKi9gVC6Xav6UOIqAKNm8KDaxbic0aFjY4uyn9zY7j3Fe0VP58w9Te4tB69pB0w8bWm6vqGRWsOXKo4raaHFRDRnORB+mQXmjoXtaeRZG6KFfpKcMBuWknTfuqrBrzaO9ed3FqHZJyIL7G6zFUEmsrgQFQhReGB1D9HxOUT6rMjG6mgxc7rEACN5JbFGPM4TQeN/AoOWsF9qc37DJqBIsji2p+L6aRnR616FztiuvWISGCUonLObQlNXx4wCy8WJhLhzJtZ+sZK5S1hQURtVy5pSoZF348zSF8tenb6YsMthOCa7NsAXt2l+OFbMPcizlyjnxvcwt3bxFpNxdEY/ULz3hW3PBxEkg9+1pjSvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 15:30:47 +0800, Qi Xi wrote:
> @@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>  		pr_err("8<--- cut here ---\n");
>  		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
>  		       tsk->comm, sig, addr, fsr);
> +		mmap_read_lock(tsk->mm);
>  		show_pte(KERN_ERR, tsk->mm, addr);
> +		mmap_read_unlock(tsk->mm);
>  		show_regs(regs);
>  	}
>  #endif

I found that this fix does not completely solve the problem. For a user
fault, the addr could also be a kernel address. For arm32/x86, the kernel
address space and user address space share the same pgd page table,
but the kernel address space's page table is not protected by
current->mm->mmap_lock.

I have written a use case to construct and verify this point. When A user
program accesses a kernel address and triggers __do_user_fault(),
show_pte() will directly print the kernel page table.

So, I suggest that:
```c
	if (user_mode(regs)) {
		struct mm_struct *const pt_mm = addr >= TASK_SIZE ?
			&init_mm : current->mm;

		mmap_read_lock(pt_mm);
		show_pte(KERN_ALERT, pt_mm, addr);
		mmap_read_unlock(pt_mm);
	} else {
		// .. keep nothing change
		show_pte(KERN_ALERT, current->mm, addr);
	}
```

I have read this article:
Link: https://docs.kernel.org/mm/process_addrs.html
`mmap_read_lock(&init_mm)` should be able to ensure that the kernel
address's page tables can be traversed. But I'm not quite sure if
`mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
addresses?

Also cc to mm maintainers:
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Walleij <linusw@kernel.org>

