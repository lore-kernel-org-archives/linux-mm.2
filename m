Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00910CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21356B0088; Tue, 23 Jun 2026 10:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1736B0092; Tue, 23 Jun 2026 10:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1146B0096; Tue, 23 Jun 2026 10:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82E3C6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:02:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2FBF1A0157
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:02:40 +0000 (UTC)
X-FDA: 84911342880.29.BF0418F
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id D7C2C140026
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:02:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U2gA1oJW;
	spf=pass (imf09.hostedemail.com: domain of 3_JE6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3_JE6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782223359;
	b=SzV7a9BCWVF1MNrwKPa7XjZMqTiHaZpX1ffwHKVKdVCKncRNPJ+IJiLhfrJJLWDpd1fDzu
	gXW1kHNOTRdpA6c2pNoWfYh7/IgAjHrL2MaovEohOpLK/5HF00ksCLezR1ijh0CeX1Hfou
	dfftnGJq7xg5vDUuaotHO+yv8MKNR/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782223359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8d+9heMc41zxWGzXNGvGuprR44PnpkmTW2E3tdN2iM=;
	b=GFjh0dcu1+tHASlVbnSjFVOXh7el5VMWjUuHCsloF1etfgjpvy5ilUefa10U2kfARI6BaP
	AAsAJQbLdKHk82D4Z1+j14C+zL4Wr0WbeOieRHbNtbN4WyGwD1yUruvfxfB3cKNwT5roXY
	cebYyleOY+tL+99kNMo4HBfhPQxdv8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U2gA1oJW;
	spf=pass (imf09.hostedemail.com: domain of 3_JE6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3_JE6agkKCGMUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695c0775f8aso7050315a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782223357; x=1782828157; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8d+9heMc41zxWGzXNGvGuprR44PnpkmTW2E3tdN2iM=;
        b=U2gA1oJWE9tNnPtdQxNeIxwGP1UvJc1pdt4OjFj+R52NV4kLIp/EcbPsg+reLFsR9o
         IyvDe7B11hJrAdj9sNHqtmAYbM2bM0PX9TQM8+6dwiHSf4TeCvEv4NJCT7VVLOGNbwhD
         j6+kY7D48XM4FYm2YLWKEXW3QFrwfpqUDHUF9R7Z5SzvurYjMGSWdmPZKFREFVCGBXDn
         tMOGtQhRBm9ovj+UCLdsib6x1aPkxEwCtDWqcsb2dKiwS87dj1VZOGOT2tYpPmpIwuCB
         NjQ1EibYhrodBbLhJq4KFZjg8bAA5QUw+X/fJstEA9DgCSKDYWMGmmhQzPZD2bUxjpsu
         PhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782223357; x=1782828157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8d+9heMc41zxWGzXNGvGuprR44PnpkmTW2E3tdN2iM=;
        b=ewUiM58uJ7C1nmPglM5d9oIFi8uwA03JbyhU6kH2pxmy1hV064pRnHCG/gxyxzch4G
         78hluKaOlpjzXrQX4E4IJxLxkhqcbpfdECIC1CIj5o6UXOtqsjCOBTa1o4+HN8N3rYsX
         sTMCnLC0oe7fg5aRzlMaG9bOTBkeuUBaTqtAGPSZ+6cEVH30Umz4F/JaBK9MpRiHcWLY
         kHWL5gVbC8Cf5MycBbI+0kb5c59pDkbOizjv1m5DRpE8+BTunyNTgaprWEToQ6OPN+q2
         LfOj1p9grzQbvnx5zcFud/VZJjHwn8vUvCVny06LiftilgomNgvUcSva5uDj78tTqkO0
         JyEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+1fFOWrbrDLRGYQ9WlTrKfH6aUA1+V3qiNXMPK36mkxL4hXYqUnjGEWnNiEoxgRROBH1bBjvVhiA==@kvack.org
X-Gm-Message-State: AOJu0YwSB5wBSCt9TFFuBpo3MGV8VzrNDncZnzIKlFqbfq09LXtiKPnd
	3STRFxjN2qEmEZKDcEDIRGQRihoQnGr+NI66Yca1ISV19zIrNlHxBtKjYjCh5fc1LeTLdP1EX+Q
	rCiJRzHDg4pG29x7pnw==
X-Received: from educ24.prod.google.com ([2002:a05:6402:1018:b0:688:baf2:39d7])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3487:b0:693:2a2:9e41 with SMTP id 4fb4d7f45d1cf-69711df46a6mr10466827a12.19.1782223356390;
 Tue, 23 Jun 2026 07:02:36 -0700 (PDT)
Date: Tue, 23 Jun 2026 14:02:35 +0000
In-Reply-To: <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
 <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Message-ID: <9huzzf0lmk1w.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D7C2C140026
X-Stat-Signature: gxw9f85hetg7mjiagzzbwsr1w43oma6q
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782223358-207670
X-HE-Meta: U2FsdGVkX1/VpTOj4KPp8cBFsH+qwm73XYs9RJg5NP6uUm+JHRf9frQStSnXoye5PCwLUxFh6Iv2lBC+ud0v7WOWd4j6bGe9LWKrOKXgw56BxA0THxS9wz5ZsEK/JskxYJiqNFaVQ2lPIRNlnSGyO+0/RUzg632dSZx46gIvOynmIFCIVJCBUWJNgkotNPtKqrROaRhN6rUyYEU8NzS9iDy9y6I5l4zuaTaVyqeS40yECNVCdrSiYEkSEKEa+7/iAmss3fqI6HEV7V6vFjnFWHfYEdLVhwJBWm17/W3hK5LsZnLcBoXDynSOUcjG36XToiiifcxehDJREkiJINtaqOwt4RHDHpr3abB0dOBpt4Z5NtEl6V1VQstwPM7SOz6r4J1/VpDKaPZaIyLMFPVL6cpsQbHZdAfE8PpUrMGgI/wNt517bz6PfzUl71UhsPLxkMXzpC2nM+4Fcj/6ZEZ4Gd/hdqkWlfUKJm10GRtjVBOciPNIqXn+VTffpxFVqh8+QDLN7rEex2tXNHSR3LMCVcx19uUmoWiT4kzntVzxMuL/Q9ttlmbrDWiLBqSMZJ04sm8a+JoKKQ56xeZjmvlVFxvpFeXO71ckgxekyRY3xAwHwDTCiS6E+2wVWvC3e1wEA35mMTQnp+I7uL8FZKjcZIr3kWdl/XZCwSDE3De+Or4LF5og1DRH2r6tpORR7m60LX99zuq8OAofilyhWdGIrXM3QYJkq4eI61TmtTFQnPCsZdes6WhjgcAsjzoxAnnviZTmr8QOTi8duRB0k+4tQI1tVEyxwKNx8MJj/OYUuYrM3QIVZnO6/FhjwXe09RRlOvqsdxUyxdyyZ1qp4JhqpcX1ln4N0IKey8S+G75gaUwLR53wECaHF11W17ioUfocdvlBIeKerH64eqPf7HhW6JvdUssX+YBMeHlFLGN/Vz5OsWxD5hOoUrq8ucnTN8cYyYN73vYvF00wrQ3OiYt
 WAUKO6/c
 MQsyIKJLtTziWE8NdYmVSYjquK91t5C8eOg5SM2wohr5v72DQpcFmuEKw+GAw3INJ7SzzknHxpRiykzEPCpXcAn7GyBEwS0xWBLXpFXu5KFUgDKVFyAwm/U2j+ZAS63Ibmv27qaIv4wZxljrMm+XQQM7UbjDZfYoz+T7fw7Hay2mSQptsusOwDT5hBXWWULzIGJcQ7sFd3rqj1pLKvtUjUNBy4TYuu9xMwRVxyZWV4z3vy7GdEdQklJ6GB6RVt4tVcxGBDgvMJjgLfyCADvSJX9It834KrpHW+fLWmHlqp4ri1gHdLuZQFJ2HgajFVk0vs5mGY27JDdL65+x7U6FRMG1rS/+AcEWnaEX+N44HWfCoEz8wr3p3BZZiof3vpZo6839OB+G33jtr8ABO1CqAIp6Yjydsx8qtWaM9PaTXiiDT9hJV+Lr6cMx7bub5wJxbnTk2ynM0KuQFNYh1HEx2woBAYs6uInDhTmmGngjbTKlQytehmM1gAf25PbUmD+MZVgQ/uJKqugQ0l3oKsBxpKKjm7Rrl8CbwKU5R5fruZZ+3Yo6S018YPSuq1TYwDs3qDun0oCGmc/iamQqkJ4nASn4L+5scN4br9ozePdppOl0ijWu3gt1sbOCoLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Thanks for reviewing!

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> This patch introduces the freeze on gmem_inode which prevents
>
> Can't find the reference now, but commit messages should take the
> imperative mood and avoid "this patch" [*]
>
> [*] https://lore.kernel.org/all/YKRWNaqzo4GVDxHP@google.com/
>

ACK. Will take care of it.

>> the fallocate call and any new page fault allocation. This will avoid
>> gmem file modification when it is being preserved
>>
>> Used srcu lock to synchronise the freeze call, where write blocks
>> until all the reads are free. And reads are re-entrant.
>>
>> Incase fault fails, It return -EPERM and VM_EXIT to userspace. userspace
>> must handle this properly as every new fault will fail.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> [...snip...]
>>
>> @@ -105,12 +108,20 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>>  	if (!IS_ERR(folio))
>>  		return folio;
>>
>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>> +	if (kvm_gmem_is_frozen(inode)) {
>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +		return ERR_PTR(-EPERM);
>> +	}
>> +
>>  	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
>>  	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
>>  					 FGP_LOCK | FGP_CREAT,
>>  					 mapping_gfp_mask(inode->i_mapping), policy);
>>  	mpol_cond_put(policy);
>>
>> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +
>>  	/*
>>  	 * External interfaces like kvm_gmem_get_pfn() support dealing
>>  	 * with hugepages to a degree, but internally, guest_memfd currently
>> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>  			       loff_t len)
>>  {
>> +	struct inode *inode = file_inode(file);
>>  	int ret;
>> +	int idx;
>>
>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>> -		return -EOPNOTSUPP;
>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>> +	if (kvm_gmem_is_frozen(inode)) {
>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +		return -EPERM;
>> +	}
>
> fallocate may eventually go to kvm_gmem_get_folio(), so that would check
> kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?
>

Right. To catch punch hole case. And read lock being re-entrant, so I
blocked the fallocate call completely.

>>
>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> -		return -EOPNOTSUPP;
>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>
>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>> -		return -EINVAL;
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>
> There's some reordering here. Why not let the validation happen like
> before, then check kvm_gmem_is_frozen()?
>
>>
>>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
>>
>> [...snip...]
>>
>> +
>> +/**
>> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
>> + * @inode: The guest_memfd inode.
>> + * @freeze: True to freeze, false to unfreeze.
>> + *
>> + * This API is used strictly during the live update / preservation transition
>> + * window to prevent host userspace and guest-side faults from making any
>> + * mapping modifications (such as fallocate or page fault allocation)
>> + * to the guest_memfd page cache.
>> + *
>> + * Synchronization Strategy (Sleepable RCU):
>> + * To avoid high-contention VFS locks (like inode_lock or
>> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
>> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
>> + * (`kvm_gmem_freeze_srcu`):
>> + *
>> + * Global vs. Per-Inode SRCU
>> + * ======================
>> + * A single system-wide global static `srcu_struct` is used instead of a
>> + * per-inode SRCU structure to completely prevent unprivileged users from
>> + * exhausting the host's per-CPU memory allocator. Because
>> + * `init_srcu_struct()` allocates per-CPU memory via `alloc_percpu()`, which
>> + * is not accounted by memory cgroups (memcg),
>> + * a per-inode SRCU structure would allow a tenant to bypass cgroup limits and
>> + * trigger a system-wide Out-of-Memory (OOM) crash simply by spawning a large
>> + * number of guest_memfd file descriptors (bounded only by RLIMIT_NOFILE).
>> + *
>> + * Flag Modification Note:
>> + * Since `GUEST_MEMFD_F_MAPPING_FROZEN` is the ONLY flag in
>> + * `GMEM_I(inode)->flags` that is mutated dynamically at runtime (all other
>> + * flags are creation-time flags which remain strictly read-only), there is
>> + * no possibility of concurrent bit-modification races. Therefore, a standard
>> + * `WRITE_ONCE` is fully safe and does not require complex `cmpxchg`
>> + * synchronization loops.
>> + */
>> +void kvm_gmem_freeze(struct inode *inode, bool freeze)
>> +{
>> +	u64 flags = READ_ONCE(GMEM_I(inode)->flags);
>> +
>> +	if (freeze)
>> +		flags |= GUEST_MEMFD_F_MAPPING_FROZEN;
>> +	else
>> +		flags &= ~GUEST_MEMFD_F_MAPPING_FROZEN;
>> +
>> +	WRITE_ONCE(GMEM_I(inode)->flags, flags);
>> +
>> +	if (freeze)
>> +		synchronize_srcu(&kvm_gmem_freeze_srcu);
>
> Why only synchronize on freeze but not unfreeze?

It was not needed because

Freeze => True
When an user setting freeze to true.

"Preservation will be stalled till all the current ongoing allocation
finished, and future allocations are already stopped."

Freeze => False
When an user unfreezing, current allocation/fallocate will
return -EPERM, and future one will be succeeded as freeze is set
to false. Synchronization will only stall the user, behviour does
not change.

Unless, user expects that it should be waiting for all the ongoing
drains.

>
>> +}
>> +
>>
>> [...snip...]
>>

