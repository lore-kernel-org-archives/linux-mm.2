Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43655CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FF36B002F; Mon, 24 Nov 2025 06:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06DA6B0031; Mon, 24 Nov 2025 06:05:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944516B00A0; Mon, 24 Nov 2025 06:05:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 835946B002F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:05:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE4988AEF
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:05:29 +0000 (UTC)
X-FDA: 84145219578.29.651198B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A74020005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:05:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NdHaKGWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763982327; a=rsa-sha256;
	cv=none;
	b=QAcBt9vcUMhapEaALs70F4YGxOVplK95xXYS6rKUUQhXTJqoaK7e1L9+tcoV8fJGMgTkdF
	zuCBlnpV7jiJAr7xDe3v3tuC2BZBV63Eiosyb99JlFWnEMIxW2GArzLOgF1OQMyBxLqd9u
	Q295R4aJolnA1oRj2GVTJcNPRDzIrU8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NdHaKGWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763982327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WD8HJtXbDu9aC7CM7yKOIyd0NkM2fsi6WhnQ6ahSYc=;
	b=Z9i1Dz/txmnK7PDkKmHDtdWPozK7HJt1YVPhIH8WfZW19P8ZLCfYSS6xgjof12Wnz9hiRd
	Dx5Yw1Ord/NIVZ+rEtcgZIDva+701whlICsbSyXRmlINGc00q0dx/exTxOxKX24g72qO4r
	rIl98COTcvm9CrKK/W4gdhFPgxVNi94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5904640360;
	Mon, 24 Nov 2025 11:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38170C4CEF1;
	Mon, 24 Nov 2025 11:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763982326;
	bh=xAo9jDsdZnz6/lhNhkcTyH2Vv9bCshFd2rXVbo51big=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NdHaKGWS1O+C+KbtPyPToMXSoUWgmsYqnLDc2FhNyH96nyxbQtDe7ZubKu/lLjdyC
	 X8ObCLyrQMQeU6tEylmtcRhWaISmSavumTsxfODA1Ru0XfV5JKiZ/cWHOJVJCtQ2Qn
	 yxnSveJJgYC/h67AQ94ObFQ2vSxyQvGr9n/+Xhjy8txtI5PsMxzLEZnNAsSAWl53hB
	 ojehVEENSrvjdmIw3jzSxpHDTX7Q+YzWt9pp8X+mZ4Pz//V3guYCyY8h1bxIEjayso
	 LNYh72Ti4ciAh1xh2f1z4kcJCDXd8y6VKCB4scGUKFphVaz8NWAhND6uGKkjYepnzw
	 ozLNRwume7YGA==
Message-ID: <ef739802-1b53-4baa-81e4-dcc674d7c1c6@kernel.org>
Date: Mon, 24 Nov 2025 12:05:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
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
References: <20251123102707.559422-1-rppt@kernel.org>
 <20251123102707.559422-4-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251123102707.559422-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A74020005
X-Stat-Signature: yej4h8cc99t1d5h6jo317t41mwyha8oh
X-HE-Tag: 1763982327-192492
X-HE-Meta: U2FsdGVkX19D5bscHKnyffE08SZ5Ama8oAxElARwYDu7CzqjtRL6qF3iQRdxZCAqz2loARsmkIe5O1vBIMLI2QkCZRVTMZz8zSjfouoD2usfoxvfOR2dLXujTJThdMJoQJ4kMH0t/5f6cJiqd6JB4Iiu+prFX94zZ3FxdzVDGRze07NTchDt6K+SN1VxMrOvkynoRkicdgNEgvXZnJE4cDPymE54niw8xs5pT+2zEX5xZfq5/kdcX0AqBjH/kF9PsG07pA773ZEDOCuTWZBGnJux+25NvNIvaxj2j63MQ9ZPwdN10fTwuTIP505Jfl5OFwaTXCP78k43eG9Bu78rsnKnnvQ73bRD7ofLTFKLuL7oUtAsbpHsHetazGaSaqJ67q8FM2yHT5mYc8rdLyWZvnUNzK2r4wljLhbF/cGoK7YgSh60E6zP6YvhAzmRlQl+TKKdDlLjfFldV+MYkJvareU6ui9DOUZphbJAA6WsveGrk9biAthGRRKqV6Yu3iEQDmukcsS0a+ZcFrenwn/q7zXjTYZnGfMQsxG2mzpqy4izw4iAEXlEbtEml//2dzCB2d6rIzWLSl7WzUme/1Bs3B7WkNUv+U717VrTYeRwkBVzU39JCZzO5MJSMSHSCLO3E1uQ3L5gPTZc2GIwo3FDwKUlVFEcQFZwMwNR3T5LfCCIUIgiTXIPMibDDSk51UAI0NRLDiU671NdfVCHqI6CBQxkkse04DYW292jSbMMRt+aRAv0vFIXgEHeWVyQK17LodZRLlFtlMx72/Q7oSkB06a5jY+O/xESDSYihsEYaAuKYRKOKHyCemplxHTOtEFgnzgAo5pVWcI+l8A7ymzSh9ao6Z7itxjBYKBXEr2yCAAshvtlyV4D9g9Eqt3nTBxqoDPte9k7LuAQh8PQlKwvbjVlSW7Ftd6lHc3W8XYSKefSpEAWCokFfm7tG+c4ApEP/3XfGBR77IqyzQ/fzqn
 PGoUVNct
 FZvapHlLREmwOMayOs1bSlOa9/5FAwpRcJmAs905ouHL7kPb6SvqkhZ+xug9exwG5cPBj5E4msRXp1zCXsi5IlsEb8yFiu3S3NUJPOtIzsVBmL5QXNteHcbn6SC1mGp40ejPkK739mOXfqjUqCS/pKQfDt7XBsEKgCnkZFWcXSMl3Ota+apOyZZZBeIMFZrF1IrwjAtW409chZP9gg+yrnIYr+3RnM1kM4lLYCBvumakN5IhTUC9eh2y7TCxt6ZhpZZJEesgzX76JYGUZC6hR9Bxm0dzcJjM7jUGHmZ+Oacc861qJDvq4TzZLpB7w/UHtDcBo8rtpeKUVbnasE3W/DSnDzpOiKbEkXgV5vEk8bk38Ifk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 11:27, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When a VMA is registered with userfaulfd in minor mode, its ->fault()
> method should check if a folio exists in the page cache and if yes
> ->fault() should call handle_userfault(VM_UFFD_MISSING).
> 
> Instead of calling handle_userfault() directly from a specific ->fault()
> implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
> notify the core page fault handler that it should call
> handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.
> 
> Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
> new VM_FAULT_UFFD_MINOR there instead.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   include/linux/mm_types.h | 3 +++
>   mm/memory.c              | 2 ++
>   mm/shmem.c               | 2 +-
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 90e5790c318f..eb135369940f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1523,6 +1523,8 @@ typedef __bitwise unsigned int vm_fault_t;
>    *				fsync() to complete (for synchronous page faults
>    *				in DAX)
>    * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
> + * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
> + *				handle_userfault(VM_UFFD_MINOR) to complete
>    * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
>    *
>    */
> @@ -1540,6 +1542,7 @@ enum vm_fault_reason {
>   	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
>   	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
>   	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
>   	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>   };
>   
> diff --git a/mm/memory.c b/mm/memory.c
> index b59ae7ce42eb..94acbac8cefb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>   	}
>   
>   	ret = vma->vm_ops->fault(vmf);
> +	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
> +		return handle_userfault(vmf, VM_UFFD_MINOR);

If we could define VM_FAULT_UFFD_MINOR to be 0 without USERFAULTFD, we 
could optimize that check out completely on such configs.


-- 
Cheers

David

