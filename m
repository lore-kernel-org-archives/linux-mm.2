Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 623E8D10F28
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A249F6B0089; Wed, 26 Nov 2025 11:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBF56B008C; Wed, 26 Nov 2025 11:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9111D6B0092; Wed, 26 Nov 2025 11:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB736B0089
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:49:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3115013029C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:49:34 +0000 (UTC)
X-FDA: 84153344268.06.8A114F3
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABF01C0014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:49:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=bcN+P2KM;
	spf=pass (imf10.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764175772;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7VXVCGx/0PdLhk+nsghb8qTMaImKePvh7JEix7jeY4=;
	b=adC02eGNnKcJ/vsNQS7PyIeX0dZyh98SDa+RNsVNaKbdDPbfkk+2tF4KKoXS4mPjULlQqX
	Nwm5Jx5b9UDmKb0u37FsevHICKNXf4RJD6e8nywAkaIdM5cV1MiPfcyVHHJSiHNPtGHU7r
	B8H2s1DGPkzWpKntoSenoTvBQFAZcOg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=bcN+P2KM;
	spf=pass (imf10.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764175772; a=rsa-sha256;
	cv=none;
	b=PTrs0R8gSqpHjlas8qcdO0tmHFIKLJXvt1FlKr6p12N1/9ylPR3rm0uUjVHU/Xcw6d2hd9
	VQEBOeSeVSGZ7iWCC5B6azYBLCpLPdJiJ+8MrhpG5qXFzJubXgxwxaa2xfh/NlNhbM/vI0
	7TK+KVKzpQpC8+bFGJhQM2VA/TYVo/A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764175771; x=1795711771;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=x7VXVCGx/0PdLhk+nsghb8qTMaImKePvh7JEix7jeY4=;
  b=bcN+P2KMarvjlC8CksSPkJ6I4Z21FP1HH67NdvyMH/F1Y/8m8lN2lSYc
   p21Wwnm5ojJ9yoQtLSFz7NYKXPEmU21+hTGIBAwG5qq7SKrR4Rggk60v7
   iUDDfeuNDYisXhQjN1pqTdzC6zNbiEbcOvI/Q4vEQWnEB3EWwJ71KUuWg
   914cD/jfC1YpSc/s5Crr3XBeeC1BQmF02URO2IRmYA9KpPRr9XWzKruuv
   JK93fT11/Vr/8MWzhtQuUcHKvd4XcTjvm5kLmRprLhJSD/tDXES+tB2w3
   287NkZZ/+TJ8cf6+KKZE45cvxlGwCewbQIF9Er7OxpO28yds6wVqvQR9g
   Q==;
X-CSE-ConnectionGUID: PSbtWkjGQpyyl29xoV29RQ==
X-CSE-MsgGUID: m+DW7VpVTBeEayJbqQJGbg==
X-IronPort-AV: E=Sophos;i="6.20,228,1758585600"; 
   d="scan'208";a="5850247"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 16:49:13 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:14001]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.44.247:2525] with esmtp (Farcaster)
 id 7187bdac-8cef-490c-8568-2d44c5bc3585; Wed, 26 Nov 2025 16:49:13 +0000 (UTC)
X-Farcaster-Flow-ID: 7187bdac-8cef-490c-8568-2d44c5bc3585
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 26 Nov 2025 16:49:12 +0000
Received: from [192.168.8.204] (10.106.83.30) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Wed, 26 Nov 2025
 16:49:11 +0000
Message-ID: <6e93a9b7-f731-4609-a034-2b78423e22e5@amazon.com>
Date: Wed, 26 Nov 2025 16:49:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
	<david@redhat.com>, Hugh Dickins <hughd@google.com>, James Houghton
	<jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Michal Hocko
	<mhocko@suse.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20251125183840.2368510-4-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.30]
X-ClientProxiedBy: EX19D003EUA004.ant.amazon.com (10.252.50.128) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABF01C0014
X-Stat-Signature: ay4t86zjrb3ihrymg5srn7637q3kmddy
X-Rspam-User: 
X-HE-Tag: 1764175771-393388
X-HE-Meta: U2FsdGVkX19IqtXn6S0K5hMyXs6JgMPlvcu+oQ+zaE4WZ95Q8ZFwV1+7mAKYAL8K987fDT6gEAZoP2+bzbybBXVIOM96yleePN9BZALMWkoqdqj7ozAyvelLMAiofBBAvt+tNRvD/ZXIblC30AT/YinAeY95tcGFV8bRlzQ/I0/PIZBYI1yNqZW/PR7+PO9KNrZw6E/OyQOdYhoqSjZ3nz6ua40JqdyWim0NbMkbIFXBMeuY0/c04zpMcg08pPRBmgYHcCnMfbYm0Xum+In7omyIH2Fs3fJ3k0y7Zx78sCoUOeg58SkmHP9bkHo6MtZnoK36WrmIA0+Qgm6CtaNSHObgRzQAeZrPpepbQtgd13ay4SXWCVB95Hy1FLtP/iEdrWQdKdrOVnd1CmuN+6wWxJ2CULlPggk2AG3MJstChKKfScY1rAqRInVJLseSpNSSNGKjPGIq5INwDOYtVZjq/VzpLVGoUsO9WfGUZCr9tu9kzjjI6nLQZo6S7LYxnpO2TA8P8jDxgqvs332H1TQSqartcvUDwcnDYqmekkaSzB16gMJM+jtS43onAnXDsyqbCABjrkwVgTT7okk2W7SgjhwkTPyf/09HqC1ti4KS1IYxy+A3rKn7mscip8uPJqJ8pABq/GabxfLtc2wR6+JC7K2jdTCUwDxRwrjrwOIzhYspwCGA0r50cyNi68P0PD36dl3FGCdQD2C7ed6LXcUDNnujyxWQLuAdtLykQyCsoH08MJWyc/Gfys0Otel+OdP3ODybaQjVjFMXIusfDtZG3qumM6Mrj1gTXEkx+6ZCuj+Ua4fpLYy+MXKDYb6EMM93f+mW5A5+FdVQCRd2xpqTxDFyryPTkSjrr/tMr2vf28sNsIRdQy1TSkMK14BEgflUx/DuuUge+XraFfBRYA9hoYQTcYpkCz+bvCkGR0k5BEuKA3WEOFsqtHMPavRl0cpEvtWS5KQd1rlGSO+T7dY
 RJVWGMHR
 O2pt4TDiheQPXbyZvlHvxtawcCD0PvarortxkRL/lw5wuUvYgqk8eUBL+yAPB0mXzPK1vXuIzgckkVRlnV2Dc2ewgsKHS+sZ0D0JbcDuguDVXFbAu1I1NCqIRN3/fqt/XPnJaPZhf6ePS2r8gJ8BLaeKASp03TbyEj19Qcqx9rnEQZUS5KF5Q3w2iRMsa5ftLT3Xl0ia/BGmRAJ7dqPhJRza+hF0wJinMS2pbjG4zRdx0KIUoqWOMuRdYmWU31PekytIMw21WNI8+TYPKdPKAfc2ygzbfoGtAfyHlHPzHMkU/gFFBu05jY5YVN8fznaoWKU/SJ6Pmx4RlRrtiqCZKPnmt2XoMiz5i+ilBsU7VkesDHP0mhPyPrQimJlbZfux7pG+jAl/3pS4JCRcQbAB8SBUpil80Hme1j6dgCbTdkVHVz/3hvraUbWw51e11W4uKD4U5qF7qcZtwYs5/1RqiIxg12rtOxisNtn2OboGRiGk6LtfyL1/PlR6+o/fLh5KuHTieo11fkiWjtnvFspXiyNRq7NMOappMjrRY5xF0qRLZm8WvT8jW2xlJeVgk3JV5f3k9L9Od+TB2aNsFB+O0247qdCIhUaCayGISP0YU8QAPs94Zjl6j0SgSflsVywFCsECtpb7SBd9RexE+8VHDijIK2WKvtaosznhPRxSa7yv+eNo46v77TYdGvslA35P3uf2voxX149H7DXTQnZUi1Ow8/gl+DaWcWcxFNJOdk0Whp0Ezk0UeIhzAinpWqmkLG7Qn9HoTKQhxFVECx+JE+YysOlkESMt5AiRvQgniMZ7uZ8N2L3LrRUB3UMh08eXIWaAWp55yyWLTzvtQfzgiCySlbAsSVYTUYelKQ3p/0U0tCVgXp+BVn7Mft9ls1utVfujWZ8QjVODeQYk+30S/9aMo0RteJJiLIq0FwnxJBe0iAfw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/2025 18:38, Mike Rapoport wrote:
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
> For configurations that don't enable CONFIG_USERFAULTFD,
> VM_FAULT_UFFD_MINOR is set to 0.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   include/linux/mm_types.h | 10 +++++++++-
>   mm/memory.c              |  2 ++
>   mm/shmem.c               |  2 +-
>   3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 90e5790c318f..df71b057111b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1523,6 +1523,8 @@ typedef __bitwise unsigned int vm_fault_t;
>    *                             fsync() to complete (for synchronous page faults
>    *                             in DAX)
>    * @VM_FAULT_COMPLETED:                ->fault completed, meanwhile mmap lock released
> + * @VM_FAULT_UFFD_MINOR:       ->fault did not modify page tables and needs
> + *                             handle_userfault(VM_UFFD_MINOR) to complete
>    * @VM_FAULT_HINDEX_MASK:      mask HINDEX value
>    *
>    */
> @@ -1540,6 +1542,11 @@ enum vm_fault_reason {
>          VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
>          VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
>          VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +#ifdef CONFIG_USERFAULTFD
> +       VM_FAULT_UFFD_MINOR     = (__force vm_fault_t)0x008000,
> +#else
> +       VM_FAULT_UFFD_MINOR     = (__force vm_fault_t)0x000000,
> +#endif
>          VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>   };
> 
> @@ -1564,7 +1571,8 @@ enum vm_fault_reason {
>          { VM_FAULT_FALLBACK,            "FALLBACK" },   \
>          { VM_FAULT_DONE_COW,            "DONE_COW" },   \
>          { VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },  \
> -       { VM_FAULT_COMPLETED,           "COMPLETED" }
> +       { VM_FAULT_COMPLETED,           "COMPLETED" },  \
> +       { VM_FAULT_UFFD_MINOR,          "UFFD_MINOR" }, \

It looks like we have to keep the last element comma-less, otherwise I'm 
seeing compile errors somewhere in fs/dax.c.

> 
>   struct vm_special_mapping {
>          const char *name;       /* The name, e.g. "[vdso]". */
> diff --git a/mm/memory.c b/mm/memory.c
> index b59ae7ce42eb..94acbac8cefb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>          }
> 
>          ret = vma->vm_ops->fault(vmf);
> +       if (unlikely(ret & VM_FAULT_UFFD_MINOR))
> +               return handle_userfault(vmf, VM_UFFD_MINOR);
>          if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
>                              VM_FAULT_DONE_COW)))
>                  return ret;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e16c7c8c3e1e..a9a31c0b5979 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2461,7 +2461,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>          if (folio && vma && userfaultfd_minor(vma)) {
>                  if (!xa_is_value(folio))
>                          folio_put(folio);
> -               *fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
> +               *fault_type = VM_FAULT_UFFD_MINOR;
>                  return 0;
>          }
> 
> --
> 2.50.1
> 


