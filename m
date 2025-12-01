Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F82D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFA36B0006; Mon,  1 Dec 2025 04:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FCE6B0092; Mon,  1 Dec 2025 04:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C826B0093; Mon,  1 Dec 2025 04:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBA426B0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:12:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0BF151731
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:12:49 +0000 (UTC)
X-FDA: 84170337258.26.B918BF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BB794000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:12:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8zdSJ62;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764580368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYuwXzXCSNoZY/RhYfUUB9WrkA3ENFTb7WvxlwFcDD0=;
	b=SIiWGR51pgIxJDIkCba+6HHHoEQNHzl8bvbqBj4fFiM0Urgngtqyjm9pD+z51XBAJ8WnqI
	Mq8EPZG0n6rogwvIhcivLNhGu8ZOUDxYh1FOwkelMW6ISVrblUSzC+zGcb9leBtlZADFLY
	2wJREyYWCMAJeBsD9WVyYG4f33Q8Qy8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8zdSJ62;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764580368; a=rsa-sha256;
	cv=none;
	b=I/2wQP0+4dC+wZ2/gkz5FBuyV4x6aiR6qH3UbsDK4uQ5ghWJGA9gN52mJMwLj3dJViKVv7
	wjLcHiV5m2L6O3J8jnhJpkJzm33xVDVoEEuK07n3BTlsos1aDZUWHuyLFvMZ6nxREgMZnD
	biTlkH0XQ/pTKlMAwRxnbYcN0Ortwe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C76144479;
	Mon,  1 Dec 2025 09:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C80C4CEF1;
	Mon,  1 Dec 2025 09:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764580366;
	bh=InzzoRi4sMwF5UAjcjxn8h6bfGO56WHUkwSr4ysFVAs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O8zdSJ62lsZX1UqcRK56slWK1In8AZrXMfXAd2VdEbVk2Xgn+zXW6pigE42wp/BLx
	 JOgSmGg2QpEtSdamdFLOsSOfx81Oh6q5uN4Wae0Mjs6thxYpfTIeR1AVP3hycf2kCk
	 HhTGTeO+roQo6HTCW4AqTK+xOJtDMo+4GtudAnmSze9y0se0WAFD8eNAf/tW1lAxDT
	 JEjoGXoJDZuHIKqwfVbjHImB2pJTw+MCNlFms74PVN1SX5QUUl0DXX53ZSg8d8nXJ1
	 6YPGx/UbSwjz1j4BmMeZJI59h4wO09tf7mo0KjfzD/30bvjTjfmavRhdSfcsb7aUqz
	 R01CkzAKLSo9g==
Message-ID: <c3ae6036-df95-4874-ad7a-6077a30ae726@kernel.org>
Date: Mon, 1 Dec 2025 10:12:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251130111812.699259-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: risg8frw7omqusuwu6xqsoojez1k5ccb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BB794000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1764580367-901521
X-HE-Meta: U2FsdGVkX18IAc4Lo1pshXzHNSznbmzWTdwW9FPagD0XTAO/1YZFkEr3hnBnApvQdQ09OWocWnQBhOvjnMvYKdwtAbe3Tt87TaBZh0KSZJXpMSk98wjmuoSbpiH+RO/RmvlISzQrHVFH9qa5NmkFFov+rXsmhue/T4PVVNNvaZ1DzIpKZ/gJEXIG2gDyDlnYncV1ZhYdGvVPnEZ2hXUmH1tsmHLp6byAZ92zcgm9bDt7kyKJaX9t5naYmW2aD2X7e5G2XQnagqHHI/TYJqZZ0Z8Cu4xRc7pG6gA+vX82j2CLTFO0z/Ti5MsnK07oFh1TOayc31TtBJ6uHmFY89afMfLJLtzq6BCCOUAZRzSQPA/lGSGoOfdcDZesvu4BzcQdGKO8lhTRvdNLAQomL8WAAeYKm+9l+ZTCBDUV9u99GFb8VaQ8/BNTSXPwDUBUPxKvWMHoaJgCpSJqw9/R4IAXp3vg+msqjqo1c8j1JgvY0YKQZcDP+zrF/nmkDdbJ00ie/7aeQYvGrYE8AWpIVN3soqA0py6600BWYTTsn2F3C8W0DzSHe3DhBXH3WUiG4yhTqZoVZArT2CMs3mUuJ3VqkgR2nmtXG5QxCAefPxaIK0/WQb/2W/rMMYauKxu52ATwEwagEKg2r1/C+w0lb7LTzk78bM78EWtm0q/seMOBwHV/qjWDmiQhbBe76+KPIXGjhSJgMbply9Jc5kqlB67Z+DQinEWi5rcrNbh6/zHuMOKLjb9Frv+NCjgsjsMYxnL83djZC3Q5UQ15joj7RfXIXg9rVYxsysqilt2KJAguubAjOTXE9zLXNqhbrs/T7VzhEyHFMU6eDCnTFOtBJ1m+UzzlSMYesiOIl5Mtr2FJPjaTjFr3S4vKUdUG3oytaTrHaXr4iO1WdeXLLMa0ixm86lTmVyhFujtiA1y8QLrB8nObeb69Af2/nUzy9NftIUUvX/ipKtJO+snxh0mTy0e
 B75gULez
 Kj4y/3sTH7MirTqtyFr5W7+5CGdMfdj84X2zK6vK79lN1h36YPA6NBTbUjDFE2PcaMxIkBV8UQyAK+4yEolbvwcacaCu1cmtBGUCT2sClGOCWCUl022JLwFO4npwbNGc3yPYTCRn6V2WF3Iq4U0lDFig6pQEtlhiEVLxizpZtL4BTpNx5xiJyM4J7V2T8yqn1uQFedRmg37lzcan3AdMOK+W4IiTKSabYQvL3sbIdt3/HIKRaksjqE643lX18Y4Gbbk4fogM+yb0+pdmKZ4hb/22KyC+P0ZbDflRf1xj57G9f6oiTL/KhWoBKfIFPREp/TmqWhvqRDfb0Dgh8rUO7MXmZVB4FYny4HOx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/30/25 12:18, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> userfaultfd notifications about minor page faults used for live migration
> and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
> mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
> minor fault registration mode").
> 
> To use the same mechanism for VMs that use guest_memfd to map their memory,
> guest_memfd should support userfaultfd minor mode.
> 
> Extend ->fault() method of guest_memfd with ability to notify core page
> fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR) to
> complete and add implementation of ->get_folio_noalloc() to guest_memfd
> vm_ops.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++++++++++-
>   1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ffadc5ee8e04..dca6e373937b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pagemap.h>
>   #include <linux/anon_inodes.h>
> +#include <linux/userfaultfd_k.h>
>   
>   #include "kvm_mm.h"
>   
> @@ -359,7 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
>   		return VM_FAULT_SIGBUS;
>   
> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
> +	if (!IS_ERR_OR_NULL(folio) && userfaultfd_minor(vmf->vma)) {

Can we ever get NULL here?

> +		ret = VM_FAULT_UFFD_MINOR;
> +		goto out_folio;
> +	}
> +
> +	if (PTR_ERR(folio) == -ENOENT)
> +		folio = kvm_gmem_get_folio(inode, vmf->pgoff);

Was briefly wondering what the performance impact of that two-step 
approach is (two lookups in case we have to create it IIUC)

Wouldn't it be better to limit it to the userfaultfd_minor(vmf->vma) case?


if (userfaultfd_minor(vmf->vma)) {
	folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
	if (!IS_ERR(folio)) {
		ret = VM_FAULT_UFFD_MINOR;
		goto out_folio;
	}
} else {
	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
}

if (IS_ERR(folio)) {
...

-- 
Cheers

David

