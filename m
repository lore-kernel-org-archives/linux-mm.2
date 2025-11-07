Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8163FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE308E000D; Fri,  7 Nov 2025 10:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5818E0002; Fri,  7 Nov 2025 10:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBB78E000D; Fri,  7 Nov 2025 10:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9DF88E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:54:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 773C616050F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:54:36 +0000 (UTC)
X-FDA: 84084258552.03.B8631E8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA0AA4000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:54:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NafYPapz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3OBYOaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OBYOaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762530874; a=rsa-sha256;
	cv=none;
	b=ZT2amJiU8l94B839x4tRKzGUD234m8rv18GacVrhRvCbPdGHNvKtJlt0X7z3SLcObmXB5Q
	/lmmlOSHZqzSeIBq7GSF1tGG2AcT/W+y+RIWHOlV3PfdjZ2Meiqgspj0FvP7ocfcgFWUZI
	EBcYf+EUMFKzyKxEnxD116AFvvwAgpY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NafYPapz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3OBYOaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OBYOaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762530874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6QqLCiZ3bKYilApTrBVoLgHK6pPaQj/ENLeWCSsRM0=;
	b=KLMXR1x8JHw4uX5euk8E1JSHxsEgwlQDy2By//yvUdWRa2BYWMJ/0unN9wFms9sFg1lyrt
	7479wKxiSIfrxQa6K99U8bKS6cVFpDr9IZJUnvoCMP3YBv3VZYgmIzMODIM8kyzNgakZF2
	jsvnRGO3RkAWGSHF2AF7XEKtz7hIgbo=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477171bbf51so7270335e9.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 07:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762530873; x=1763135673; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k6QqLCiZ3bKYilApTrBVoLgHK6pPaQj/ENLeWCSsRM0=;
        b=NafYPapzCxrNu+YJzNQhY87Q5jpUIaMJBeQMq7w5b7cVWVpaTtZ9tqYN+kWigGDeBa
         unpsezGPC94dHyL5YYqkp/+PMAsUJYCcm92QRhH32ket73JvqgrJgfSCKZNZBfW0NRXe
         fvDvqW1+mG/iiypClHI4NxP5GaMQu88V0cPxbYsiTpF07gqwhh6DI4vvV22b8XPO+HVG
         9vbofS03ibdSv74WEDD4IGd3c+4a540PTWcXNonEbFyY664E/9u9ytUzd6q1V7IhX+Gv
         r+JKOxOhRHNwX7i64mxgZLm5K1p/aJKMD0Of/OcIJUCepAv7ajKfNOTJ0unWOHNkPcal
         RBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530873; x=1763135673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6QqLCiZ3bKYilApTrBVoLgHK6pPaQj/ENLeWCSsRM0=;
        b=hpY1SLQj0ntkkY4ohHFzziKrpg/F7tQxhymIERkTiRyYYM7PkSmM5P2/orn/DXW3DZ
         xXLMnj6HwIox+rRBzn44WGYSmDn/kgXYn7a90VsPebU7UWdwB2ot3Zk2DExu+tegPs3Z
         HlFW5cFdPOxysvJXPW8L0SGIBkafGBuktCZjt2Alh9RBQ6dk8n0jOj/f4LHFqwasbcax
         4zyTZgR8sxDubxdWLbtSgDXM4KQI5KoKFsKxhJtFcoslM1BgFtVD66KFqxV6TJp3/b0R
         1k6kHRzArFb07kOvkazXtZJ/mYNawTpF6UHK24/AG3R/COkEuWlp9wIK04VQ80/SP7eU
         Q5pA==
X-Forwarded-Encrypted: i=1; AJvYcCXGSGHG5lIDtw/zSiZ9eC275o9yIpNsgA7q8vyHpj/WBRHyQ/gduUvAWNJSsfyE47IPMoWx9RZWBg==@kvack.org
X-Gm-Message-State: AOJu0YxE522Npq6DAqVIe3auqRzO+oJQZrNiGK72hOpsDH2sxncoA+Go
	WpPTegUVAfiDLSSZts0+fycDPOoCKLsi5c3C4zmv0Yjmlx2kf8sAGhTUES0dtCeKngDANmK7KDj
	RehPqs6RwXw4mpA==
X-Google-Smtp-Source: AGHT+IF10pfYz/aX86VOtk1/4ToFDHxeKDSFR7QzVJHGBwU7n9WXznaipUt0c+mOTXVDyymnjKnmVDeDshscaw==
X-Received: from wmbjd18.prod.google.com ([2002:a05:600c:68d2:b0:477:554c:6842])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e88:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4776bc9f963mr29299435e9.3.1762530872213;
 Fri, 07 Nov 2025 07:54:32 -0800 (PST)
Date: Fri, 07 Nov 2025 15:54:31 +0000
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
X-Mailer: aerc 0.21.0
Message-ID: <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: Patrick Roy <patrick.roy@campus.lmu.de>
Cc: Patrick Roy <roypat@amazon.co.uk>, <pbonzini@redhat.com>, <corbet@lwn.net>, 
	<maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>, 
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>, 
	<luto@kernel.org>, <peterz@infradead.org>, <willy@infradead.org>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <song@kernel.org>, <jolsa@kernel.org>, 
	<ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>, 
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jgg@ziepe.ca>, <jhubbard@nvidia.com>, 
	<peterx@redhat.com>, <jannh@google.com>, <pfalcato@suse.de>, 
	<shuah@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <xmarcalx@amazon.co.uk>, 
	<kalyazin@amazon.co.uk>, <jackabt@amazon.co.uk>, <derekmn@amazon.co.uk>, 
	<tabba@google.com>, <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA0AA4000A
X-Stat-Signature: 19ocf1a1oxdek73uicrtnzngcd9kzqwp
X-HE-Tag: 1762530874-63759
X-HE-Meta: U2FsdGVkX19y6FPRm4W5L5imGxzhb/h+u71/6+2ENiwlQB+UHrPaDwSl88EF52RnA5jaQBpSzDLk3QaoCi2wC0QBOuwa4xSqRxxE4p3gHxqPhBEBqX5wFRvR5pGbwCGkpstdxL9CSHDV4pd3qrFLwE4P8Aar2qUBf0Dlxs6Xk+faLHaIDRj7zN+bixLkNVz45e8Qw7TQ3GMlq5hrqwRpNWjBlFHozRTjsr9TC9mC1jFbOeckk2vRC4ZfjWBdlBacIS/8+qHM444dzHPEv9sF4Qr3JZYYU3daBV7Y6ZYamDDAK1klNnzZLlhbJXmyZ/eVBv6pFgyMUuxjmcKGQv+22M8RSyL/4sOsNOf5P/F2rtKjZDWJrOKswh0DxINbuVelnrUgy9RD+/M9yDSsNhgJ3kLRPVE8Is2wcv1kmuke/g3iKe4j7q1p9TbW1ohPQspKjrCTCjzvisZyVuMO+UQstjdn5giVoxizAqKtgFaZ95XFfoCwEtoMcnRUnmF+m+ogogv+pUJPNB3XBrZ0STciBUmHFbmBuT/zlFEL4MYy8k5/kfbYGTEZp6o7Be1igIp3mpljBQb/tfNc0zmYvOAu8S1y+O0xzW375d8kI7B2qutYFATo3yU3xFBloJ9etOgVwMYuqhYPhvcvFiUhF6jm4bJDTAeLfqimCTJzijSIaWkXz9zadBbe4BarSQ4hcTnnkKnmnebdfztLj5BAsZdw2vmn8vIlMg+Bn9YjDtiJvSzRug4CUjDxXtEYlZ2YePA+ZJ/ao9ZYbZLwcQK3yPDKDwwPz54a2dxJ6J85bmq+QDor9w/CaaBPlQkiN0gWNYzz21zMAm+JeUmLBSFbJEtVCiOllmh1l5OOWHR9urWIYS3VtA0HrEtMFdh7EHSNGeXlo3pCSbH8S+mQakvEiYH7veIeNoHt+Jv+57NqJ7fUCal3MXYA0BN/GfVs2NnTaFAObJYqL2mUG2bYA2i4FAM
 UN7Ao9sp
 TELvN6Q/Iu7+82tJoonZbdr9V255lK83SbCP0iQS6v4DKbpPV4EHCSDhmGxDmPbqeGvPH+ZI4LAAfEJQ+h7Rri6z6n0Z4MJDlbWL4IEIUXu7HNAInXc0bnQsiwa2p8/t8Z9AwxVLkneoHJhZvFx9C7LvbMq/wu5FT+wDRWtIeM+MKqkQ5cxCmKX+pRqvMh6m84d2csyXsIPf0NyHdb2exrPxtJP2KqZ7Gvq38XmHaj0EGZWjDvKINcsULq2TPNHcwFc65CBDu67jgUkgceEJsk+GmRmmijY8iMOFom5XGh2vM2IpTuuR1xrbiz2bOaUOkxd314hUl3N5zAkJIUczWqkuA4EaBwfOKfbTQ6xmDat5NR4tpZJR6Yqztyr7rlssPPJGgvrZTwlMTXPNboOor/8txNNXADNiDECD5tVxZzkxzb0as9abomkNaOUVt2uocizE/aW8NEs9PNuGav5ien7ydGOknSFMh6dp22LNRwIT9czvb8kcGWZvNUrNVkCjoKMxb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
> From: Patrick Roy <roypat@amazon.co.uk>
>
> [ based on kvm/next ]
>
> Unmapping virtual machine guest memory from the host kernel's direct map is a
> successful mitigation against Spectre-style transient execution issues: If the
> kernel page tables do not contain entries pointing to guest memory, then any
> attempted speculative read through the direct map will necessarily be blocked
> by the MMU before any observable microarchitectural side-effects happen. This
> means that Spectre-gadgets and similar cannot be used to target virtual machine
> memory. Roughly 60% of speculative execution issues fall into this category [1,
> Table 1].
>
> This patch series extends guest_memfd with the ability to remove its memory
> from the host kernel's direct map, to be able to attain the above protection
> for KVM guests running inside guest_memfd.
>
> Additionally, a Firecracker branch with support for these VMs can be found on
> GitHub [2].
>
> For more details, please refer to the v5 cover letter [v5]. No
> substantial changes in design have taken place since.
>
> === Changes Since v6 ===
>
> - Drop patch for passing struct address_space to ->free_folio(), due to
>   possible races with freeing of the address_space. (Hugh)
> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>   direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
> - Do direct map removal when establishing mapping of gmem folio instead
>   of at allocation time, due to impossibility of handling direct map
>   removal errors in kvm_gmem_populate(). (Patrick)
> - Do TLB flushes after direct map removal, and provide a module
>   parameter to opt out from them, and a new patch to export
>   flush_tlb_kernel_range() to KVM. (Will)
>
> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding

I just got around to trying this out, I checked out this patchset using
its base-commit and grabbed the Firecracker branch. Things seem OK until
I set the secrets_free flag in the Firecracker config which IIUC makes
it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.

If I set it, I find the guest doesn't show anything on the console.
Running it in a VM and attaching GDB suggests that it's entering the
guest repeatedly, it doesn't seem like the vCPU thread is stuck or
anything. I'm a bit clueless about how to debug that (so far, whenever
I've broken KVM, things always exploded very dramatically).
 
Anyway, if I then kill the firecracker process, the host sometimes
crashes, I think this is the most suggestive splat I've seen:

[   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
[   99.676216][    T2] #PF: supervisor write access in kernel mode
[   99.678381][    T2] #PF: error_code(0x0002) - not-present page
[   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
[   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
[   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE 
[   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
[   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
[   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
[   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
[   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
[   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
[   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
[   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
[   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
[   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
[   99.724421][    T2] Call Trace:
[   99.725608][    T2]  <TASK>
[   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
[   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
[   99.730325][    T2]  ? find_held_lock+0x2b/0x80
[   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
[   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
[   99.735766][    T2]  copy_process+0x1b1/0x1b30
[   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
[   99.739157][    T2]  ? kthreadd+0x25/0x190
[   99.740664][    T2]  kernel_clone+0x59/0x390
[   99.742213][    T2]  ? kthreadd+0x25/0x190
[   99.743728][    T2]  kernel_thread+0x55/0x70
[   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
[   99.747265][    T2]  kthreadd+0x117/0x190
[   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
[   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
[   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
[   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
[   99.755717][    T2]  </TASK>
[   99.756861][    T2] CR2: ffff888012804000
[   99.758353][    T2] ---[ end trace 0000000000000000 ]---
[   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
[   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
[   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
[   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
[   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
[   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
[   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
[   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
[   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
[   99.793863][    T2] Kernel panic - not syncing: Fatal exception
[   99.796760][    T2] Kernel Offset: disabled
[   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---

This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
working or isn't getting called.

If anyone wants help trying to reproduce this let me know.

