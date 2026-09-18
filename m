Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC54C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB336B008A; Fri, 18 Sep 2026 10:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B2D6B008C; Fri, 18 Sep 2026 10:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1F06B0092; Fri, 18 Sep 2026 10:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2CB36B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:53:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48C3A406FC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:53:41 +0000 (UTC)
X-FDA: 85227177042.07.60AD4D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4F79A0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:53:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTgwKLoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789743219;
	b=zWyiqPhpQAgSfE7PcQaEo4uawTIJydGGhaUx6ahfNFvlh4wp0NmyjKox3lFRH3JwzxXMj7
	ZbSZxtn+8Ihr71cDRBnmVysOzQSaiGPAk4iAGTxbbQxPROlaFWJdd3zimCKKJDVfoGRBpL
	ekhUhLzR1MBi5QZOjkTZmxH/c5XlKwY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTgwKLoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789743219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgbGaUePnEqf82RNr6SO3vFiP2VNQ0/em4gUyh5iB3k=;
	b=5loAEeSO4GnT+FEMJ3quVDbzZELb3D6WSHasYxqJoCQLvQm2gRIlEQIOGkXXrAo+iwx17U
	zhwjGA4+lOlnR27mWIl+OuaWdjQkvxQh9X0MfgopUgIZZtFK8Qxp+VfbKTJDJLDWZk2g5e
	tsJieu7ABWEurU6ZeqmX8Q12s8Gl3No=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ABCE6022B;
	Fri, 18 Sep 2026 14:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ABD1F000FF;
	Fri, 18 Sep 2026 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789743218;
	bh=fgbGaUePnEqf82RNr6SO3vFiP2VNQ0/em4gUyh5iB3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cTgwKLoHvXGkhKsMUhuH0kcmWUEXCIIPE9q3O75YeYv7/Lm/8J28MAn7HqJGPleu9
	 h/EgVVt8xOVskDixhpKOvvOfhCZOFDmUQzj8R8O9Bpc+GggiWliivkcn9o1/cyu10b
	 UOeHpJE6BI3efiBk7zdzDYj000uoubLDlCAedwvTVLfsXnPBQwXSqGOHW78VTBZM8X
	 ZdNHS8Nsq7Vu3khohSRuk/S5mDWrl0sDjeAeL1/rkj9EfPCLG4/hE2zDIPeeO9MAqo
	 Ixm6um5RT0hZ9fsddgg9BmBZ5UNVoh7Kn+x6FN4V1zGUUSlZ8gf0ZubF/uhtVMjau2
	 8Y+TKUuSWrU1A==
Date: Fri, 18 Sep 2026 15:53:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <aq1FDhy00epXXtgd@gremlin>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
 <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
 <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4F79A0005
X-Stat-Signature: xmn8z1acjhd6ijt1oa9xinkw3cups6mu
X-HE-Tag: 1789743219-219776
X-HE-Meta: U2FsdGVkX18YmcR/jJTWjtF+MuZX+kLXOODtBY7bT18yJPg6npIeTXT5KJlH2yRi97VkWw929iH9z7fv7MRDZBJyvetuq/00Pg5SL/hVo9VXfc9I3p1b+ZdrA0S+Q2p60Mpi0+B7+gWbkSPHVk/pKu3BFNhsbd5/fBKMvzUhg9kaUxzCUAyUQawHhawomc9AU2pdxDxTHU2OC1N+DO9jjfaTkcxsFsvxNaoOxsyaj26XWOD2qDgOGK/Wc7m3pscn9JmBkN7VDm/cEWUvUvpujUoJXSwF2MwLVPoMeuRBHAa+l97n2WbCongzubdf6iQkiBF/kPDOvHabYoikCIADr1RNnFt74sv8jGffRkbfjLs8NhvYj9unS9oBW6R80KSZMAciL4RMuC4D5OVzybIT3p/piju9OFZtlspLgGLZgiSfCFgZ6J44EK9IeI011dLeZrCyCyVUfl6LA5bKvJlRkrxKvNKnfxe5e1Mj6YUzvAsfybZ5myOkkSUYOZES3boNTYdaMJcprpsaJ088tU0kRZO5ks1V25B59w2sS9/HEfhx/JvpiW8g06Ndg0PxDrtpG42xFshDC2slbh8lQshWYryRoGqfCBLBFeikFpOc3oMbc5Rqq+veWHSyU/sixepREMK70O4WRHRX9XlTTL5sDQxHrvZGksuO3b9JmIu62DHlrvUDXcVGAPoWf5phXUpCANbH936YsN7Zb6F5t8wjRhjdTbR+yzWWr1IiTHAnQ15I6vy1PXJGI02K0cpO9cV84EywVTig9owZqDjJrnSTFKVYEtmZvZNNu60ucuMgjvgPkr4kl4KlfXNlS1S/qdwNUuY5Qg/8pluja5g+ZZCH17LPLjWysBOrEqHQP1X+m95kcpa006IwDHkLDhZOy/Akhzc2aOHtST0SLixDw6MAvLksT2NaoAhHd8LOBCmV/lTsFDWtDeDAmvA8ztcHMb7hhDw29N9QYSeJPiLrTzs
 I9ZePVtX
 NzqtE7HLU/tkJ7jR4C9NmpZHOKYsgnzsOR4wRbq/bqxMMlET1KUTRlpsUiBH3fm4FDHEc1MHw317VQG5MkFtZ+afE9pSmDDqDW5Tq0UxG7f4gxYdDCLfsBx98Qprz3QiDlvL33HvapAhtr4N/Q4Z7GMYkziSBVprH2l7hiVUFbdjwGxgM3tCpsvNZR2CYPZUahWgdVpcuqg/+5dL8r5shNmxbczAwU2N4GeY2dwBd5tKwkVRMUWayatv+qOd5lNhH7l1b/NUQW57hlyGyeo7E9ilB+pE+iSwCtrP8O1z1K6myjHRbDoCjiIdj7ROAP7t0pcnpkzG1lRyzZLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:59:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/18/26 15:57, Gregory Price wrote:
> > On Fri, Sep 18, 2026 at 02:58:36PM +0200, David Hildenbrand (Arm) wrote:
> >>> +/*
> >>> + * Read-only file-backed mappings are expected to be cache replicated between
> >>> + * accessor nodes, so they are not worth sampling for placement.  They can
> >>> + * still strand on the slow tier like anything else.
> >>> + */

This is the most specific description ever for such a general condition :)

> >>> +static bool vma_is_ro_file(struct vm_area_struct *vma)
> >>> +{
> >>> +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;

Firstly you should use the new VMA flags API :)

But also it seems odd to check VMA_READ_BIT. You can have it cleared but
mmap()'ing without PROT_READ but has no material impact on mapping since
write implies read for everything afaik (that can have an impact on GUP
though).

Also note that (well my series changes it hopefully landing for next cycle :)
MAP_PRIVATE-/dev/zero which is anon would satisfy this. But anyway :)

Anyway in general then I wonder if this shouldn't be vma->vm_file &&
!vma_test(vma, VMA_WRITE_BIT), but then it makes me wonder about whether
you care if somebody can mprotect() this writable?

In which case it'd be vma->vm_file && !vma_test(vma, VMA_MAYWRITE_BIT).

Even then things can be weird, as some drivers will clear VMA_MAYWRITE_BIT
for definitely-not-normal-files, though with the intent of disabling
writeability altogether.

For read-only files, as David notes, we do something _weird_:

unsigned long do_mmap(struct file *file, unsigned long addr,
			unsigned long len, unsigned long prot,
			unsigned long flags, vma_flags_t vma_flags,
			unsigned long pgoff, unsigned long *populate,
			struct list_head *uf)
{
	...
	if (file) {
		...
		switch (flags & MAP_TYPE) {
			...
		case MAP_SHARED_VALIDATE:
			...
			if (!(file->f_mode & FMODE_WRITE))
				vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT,
						VMA_SHARED_BIT);
			...
		}
		...
	}
	...
}

So they become !VMA_SHARED_BIT, !VMA_MAYWRITE_BIT. So it's good you don't
check VMA_SHARED_BIT :)

If you map a read-only file MAP_PRIVATE as readable/writeable they will
actually have VMA_WRITE_BIT, VMA_MAYWRITE_BIT set because the writes CoW
instead.

Anyway, I'm guessing what you want here is:

- Exclude MAP_PRIVATE mappings
- Cannot in any universe write to the damn thing

Which seems like you'd want to test:

In which case the test should be something like:

	return vma_test(vma, VMA_MAYSHARE_BIT) &&
		!vma_test(vma, VMA_MAYWRITE_BIT);

BUT that isn't enough.

Because in actual fact (sigh) some drivers clear VMA_MAYWRITE_BIT (but they
keep VMA_SHARED_BIT) and write-sealing a memfd gives you VMA_SHARED &&
!VMA_MAYWRITE_BIT (which is what vma_is_shared_maywrite() is for for
instance).

So if you _truly_ want to know if something has a _shared_ mapping of a
read-only file It has to be like this:

/**
 * vma_maps_shared_readonly_file() - Is @vma a shared mapping of a read-only
 * file?
 * @vma: The VMA to check.
 *
 * Upon mapping a read-only file with MAP_SHARED[_VALIDATE] mmap() will clear
 * VMA_SHARED_BIT and VMA_MAYWRITE_BIT.
 *
 * The VMA_MAYSHARE_BIT is retained to differentiate against mappings mapped
 * with MAP_PRIVATE.
 *
 * Some drivers clear VMA_MAYWRITE_BIT but by convention retain VMA_SHARED_BIT.
 * This is also true for write-sealed memfd's.
 *
 * Returns: true if the VMA is a shared mapping of a read-only file or false,
 * otherwise.
 */
static inline bool vma_maps_shared_readonly_file(const struct vm_area_struct *vma)
{
	/* Shared mappings of read-only files clear VMA_SHARED_BIT. */
	if (vma_test(vma, VMA_SHARED_BIT))
		return false;

	/* But MAP_SHARED mappings retain VMA_MAYSHARE_BIT. */
	if (!vma_test(vma, VMA_MAYSHARE_BIT))
		return false;

	/* Shared mappings of read-only files also clear VMA_MAYWRITE_BIT. */
	VM_WARN_ON_ONCE(vma_test(vma, VMA_MAYWRITE_BIT));

	return true;
}

The assert here is because nothing else clears VMA_SHARED_BIT like this, but to
protect from future changes that might somehow allow this could be:

	return !vma_test(vma, VMA_MAYWRITE_BIT);

Note that my 40 patch behemoth establishes some actual invariants on this kind
of stuff and introduces some 'VMA checks via semantics' stuff (and eliminates
VM_SPECIAL!) so if adding something like this I'd maybe base it on that.

Obviously if what you need semantically differs from this then do that
instead.

> >>
> >>
> >> MAP_PRIVATE can easily map a read-only file with write permissions. So the
> >> function name is a bit misleading.
> >>
> >> This smells like a helper that should go next to other vma helpers and have
> >> clear semantics.
> >>
> >
> > No argument here.  Would like to balance improvement vs backportable
> > bugfix though.  I broke out the name to try to make it at least a bit
> > more readable.
>
> I understand, but I am not asking about much.

It turns out I made it probably too much, or at least too many words :P
Sorry.

>
> Maybe Lorenzo can help us out.
>
> /me summons Lorenzo

Reminds me that I must schlo... write a script to find call-outs in my mail
:P

^^^ see above.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

