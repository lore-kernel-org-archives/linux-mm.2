Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8749CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8A88E0059; Wed, 17 Sep 2025 12:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169928E0002; Wed, 17 Sep 2025 12:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A69A8E0059; Wed, 17 Sep 2025 12:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED5168E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:28:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB4981DF6F9
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:28:08 +0000 (UTC)
X-FDA: 83899274256.11.751F8B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id A4C6540010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:28:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpLXic0MdizHtZPh/KE8ePuqoIhMDWzWKS+7gIsSu2w=;
	b=t2luSEmbZBklwZocF1KJduE8geve+2nWhVvAuLYpz2AIPNAqdUllvx5ldfWai8bE21r6n1
	8ewtIa/mlnAPv00yPzIxSwk1/3b9OaNZ+NyUlsVDwJzIMnaXNOfbOZaAXlyTPQ5R9I40It
	YFHUIvHJb3e0h57HV6/dBxd6/i5es08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758126487; a=rsa-sha256;
	cv=none;
	b=kx/B75weAFYQG0ZotkKfRwmHbL/zZVmpyXqNJY3n08y6w5oiTMuxnj/mq4/n9o5F2Hngxm
	0aS96k0noJLabI7p2Cz1xZoVDxzjX0NIr1srzT5xZwLU+faNH9JVdq4HBvtKEEb2OVLn1W
	cSCVv392p1yoE0va6muWh8nosui/fGQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 351AF267F;
	Wed, 17 Sep 2025 09:27:57 -0700 (PDT)
Received: from [10.57.80.26] (unknown [10.57.80.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B07303F673;
	Wed, 17 Sep 2025 09:28:03 -0700 (PDT)
Message-ID: <e86e2aa5-c66c-41a9-a56d-74451df0d105@arm.com>
Date: Wed, 17 Sep 2025 17:28:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
 <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
 <55a79826-48e3-41c0-8dbd-b6398e7e49a6@os.amperecomputing.com>
 <92719b15-daf8-484f-b0db-72e23ae696ad@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <92719b15-daf8-484f-b0db-72e23ae696ad@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nbf6eaywxxba3j9pgunkyabfc6ts9gxc
X-Rspamd-Queue-Id: A4C6540010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758126486-913112
X-HE-Meta: U2FsdGVkX1+XXUC8JjfJnGhx3UPYmgT1T9RQq4J6LE3ComaqZX+/CZIU7KDK/L8iU5etkm+a0ynEHc8imhI0FyV8YczbVQuOWLf2wxw04h5jaH5TIksgDuXjK7Bi6Gxg4BNW9IC4nIx/n+qhJEty0JGn84DsBIuGLKOq8CAlGX+NvkBzCGG8jntvXjznEDrLuiQWjIZ7qfL5i2cFvAsRMOALZA276nmvlvVYP/VgfGswAfAY+/rUyQN6a7cZxO5D1FsHNge3qYoRAPX8GvEheyXstl737qLKj3XVZQhbZpnWtl8x1wNE6aPy8SZZi97bOSVGKzBtY0axT5Y33dYTsdgUXI5M2ETFwh2Eb0XZJOxwh3JnBmCWEk9kZ3mQS/SBwEqxocsgefZsJK6689/Dv1TJEv9CerT5t3GuKuSyjjAuqJG1T32X3kkjLEY20PTBCbkUoCjme7MA6yfAaNhFR4rf0xGCIhxLEuSwqFY2w0LGcReoz2/AmQWivTjwV3mYi6gb+XlSTKpr1qG+WFknTwTEmOxYEec/kegpqD1RD0q2Vm0qR57hDAGeMxkKbuuRItFrX9hP1gd8uGQmvsqbuNqt/f3Op9lIYdn/NYzeJzO7PuSBRJyPEY8xOqND03CnyDhiPta5bLrp6OTXVqPkYfyg4/oStFS4Ad79Val8UQsfWp3a3Cm6K57fjXPUSOhMq8OWebxyP2ICHItAmiCsTw8Nswi9OuSlDUjgCkyv/kOAIUXeZoIthXgymTT9+OhQx6wuaieGx2l+9DVEjCeHQmRmJtpaqrAXgujYSEgdBXY1JQZQT+UxOOefRZ2aCKLUKGZQPpx5gmKIoPGlTSjwmVoFhMdBCB1k4mOJJiMwlaKZAeNY4ngvaY7mrSjYDofmJyORBce7NHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yang,

Sorry for the slow reply; I'm just getting back to this...

On 11/09/2025 23:03, Yang Shi wrote:
> Hi Ryan & Catalin,
> 
> Any more concerns about this? 

I've been trying to convince myself that your assertion that all users that set
the VM_FLUSH_RESET_PERMS also call set_memory_*() for the entire range that was
returned my vmalloc. I agree that if that is the contract and everyone is
following it, then there is no problem here.

But I haven't been able to convince myself...

Some examples (these might intersect with examples you previously raised):

1. bpf_dispatcher_change_prog() -> bpf_jit_alloc_exec() -> execmem_alloc() ->
sets VM_FLUSH_RESET_PERMS. But I don't see it calling set_memory_*() for rw_image.

2. module_memory_alloc() -> execmem_alloc_rw() -> execmem_alloc() -> sets
VM_FLUSH_RESET_PERMS (note that execmem_force_rw() is nop for arm64).
set_memory_*() is not called until much later on in module_set_memory(). Another
error in the meantime could cause the memory to be vfreed before that point.

3. When set_vm_flush_reset_perms() is set for the range, it is called before
set_memory_*() which might then fail to split prior to vfree.

But I guess as long as set_memory_*() is never successfully called for a
*sub-range* of the vmalloc'ed region, then for all of the above issues, the
memory must still be RW at vfree-time, so this issue should be benign... I think?

In summary this all looks horribly fragile. But I *think* it works. It would be
good to clean it all up and have some clearly documented rules regardless. But I
think that could be a follow up series.

> Shall we move forward with v8? 

Yes; Do you wnat me to post that or would you prefer to do it? I'm happy to do
it; there are a few other tidy ups in pageattr.c I want to make which I spotted.

> We can include the
> fix to kprobes in v8 or I can send it separately, either is fine to me.

Post it on list, and I'll also incorporate into the series.

> Hopefully we can make v6.18.

It's probably getting a bit late now. Anyway, I'll aim to get v8 out tomorrow or
Friday and we will see what Will thinks.

Thanks,
Ryan

> 
> Thanks,
> Yang
> 

