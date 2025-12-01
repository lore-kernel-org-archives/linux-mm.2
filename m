Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54460D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 15:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785156B0029; Mon,  1 Dec 2025 10:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C756B002A; Mon,  1 Dec 2025 10:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699AC6B002D; Mon,  1 Dec 2025 10:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 563EE6B0029
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:55:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F1D088B3B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:55:05 +0000 (UTC)
X-FDA: 84171350970.14.C8791B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DEAC1C000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:55:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smsBE6HJ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764604503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1BiCZ/+jA/kupi4t/n5o+t2cF9mUBcXSaSQvzcbjuE=;
	b=pplTonGBwUZh0PvPi4U/Ddq3G1oQpM4d0VdXMCcEB+qZBgTfjGo/aKzDos33mvCUFTjZie
	IAMBgWVEbn3j0fOlz8rk+lAiNvfnXNORTYYdrRlgsQV32VOwSCW98KxLe7LRWJhyH9OTQo
	AQtIvH8MNxqf4vV66TtsRef59/Tf4ZU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smsBE6HJ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764604503; a=rsa-sha256;
	cv=none;
	b=WKXQmhWY5eH08PnK6uzlBRkByXsLD0mlRGmLCqf6/tU0MOlZPpWfAsAzGclIZjAvX/MOFf
	X83qlYM//l4xcr6oLUDgwzuJve2csRJ9jECO/HxLRbgAhSpODIraQ7U63DuF6bpiDtGBcp
	9jeCsI895kzSFm+Rww4shlyd6icVJxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C76B60097;
	Mon,  1 Dec 2025 15:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C437C16AAE;
	Mon,  1 Dec 2025 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764604502;
	bh=A2bhAHCrw29Gn04uGgzYEmynbjTQgb8sVC7Kb2YAar8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=smsBE6HJo57XGVHY+R3/NXxGlT70EutobA9ZHAG37qQxBteEMSs8iiALqNACEX/lB
	 XM7cw6uALYdyYimZ8qeDw0ti+SXt6eAnuEjN6SvfvTYp3ESDQgupwedvasAnNiQUl4
	 +Npr5UTXMcsXdRIUwu3ai2+NT8nzskfHozuTM0ppbeKZ1pFUqJxCYy7Ny1dprih60S
	 N/62Te0hf+IYLcy0r57iuQ2JF83dZ7VSvxhxhz7sWll4bZQoCfnRn+mAgDtRUM77o7
	 CvoBXRLv6TUmA2VLchO0nOpDYR6aE0/lzDhe/x8N/SAcWa44PbwXiUQY67ZYhBrZNn
	 EMxobJQMv5d9w==
Message-ID: <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
Date: Mon, 1 Dec 2025 16:54:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: kalyazin@amazon.com, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DEAC1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: w1x7o9ded3t9ay1gdrpdk8yqrjugw3kq
X-HE-Tag: 1764604503-423207
X-HE-Meta: U2FsdGVkX1+xqXx681YsdCCEHd1nZpGYdVcx5oYfVhrEfj05BclGNxdy1pDTo2P3Q/gRTIGWQqwmremsYN1w5+fLO+ujjYjKSPWQT3LAiUK9ngnLP8q3Z7EMi6WUfEqDEEYQIZxRcBx+SRGTTcfwVTIsIY4Bhm0WL5iyKqQUOEOK37xyi7DKTrsz+b5Sqwbwaqt6X/K5Zlc2qheRicVypnKMMPotkY5f7JH6L9eRlQv7OrXgBFnw+X/lj2T9sCq8XNu74tKy4sx3RSDTrJGtTZbXiDr3lLui8aj6T+ZaFLOJWqhI9hZ1JLn4nT3wwl1UMSO8xwokxdE+ucmK0Q0H7mUNg0sfJK7JgDzPpLyT00cNH/NxGFWsjcDdZBHhIu+diMFX5Hwdgo5NTpa8fDwT1QngCTVxnWBtdSxqkNHx0yIHUdkv6R5z8tJg4C43eanzA+UVQPg/04rElHB89dA1QTLvONKHTO2pF6tx9rqGh+I2+ql30BwIdWRF6W5eR+zVqIVZsGomUPa4K9fljc+/KbzTjxssMtTIRxkApK7npF4hF76kwpd6y7wpyUb7XjmcceXUJ1S/BGfptu9UJ6qlNPbgCDVbyaNutMG4pif1ZWNEyepECy7dDIGRkArKbYlGGEJkZjy/7uTV2S0DCo1vCg9G1v0xj7qE7UNSuRO+G0Z8qxLZZn0ZUEQspbbnepOD+Ywx4XIB4GqwRZo2KWgJk0Zf0CVSVvM62Xpf2smErHg3OMJwz+eeB+AOoq6usrQ4iB12GczJS2SU0xMunjusmzoSKsDmee1EdEg3DzwmI7juHWnfxW2qFxxbPWCtGBO6NU+m9ocb4vXUmdajHgy/fRsaXcvL4jBoGGlzaIDZiCb0FMwWwhZhrw5zrFHOvDsJnhzQEO61CJRLNLaFZABDYYbliCLQ5zO8M0e8W+E+DtFtJgm6r6NSQDfFAxqMKTpE15UYHIHRYe0Oe5ziC5x
 XFjfVSeM
 SK6WtF4AAsmfoVyu84a3ly3/DrdhUVJQH+qE3hi+Z4hzCgrT8U//6RKgXs3FCxgoIJCt2t5ReaD2EdwTI/8UE72JhWL7yFRtWiKRrm4iGoFAojHAPXnKl51fX6oaKX8ZLU648MYpVnF6HsVbgd9YD2h6V1hV6VeBTdOOjUHxUwYzoxM+bkaq6u1S5FXAotUPxovWoCN8APG574nxTWZtJdmaRXZVxOZOJqzxBqHfTutOGU7YBCy7A3AfvYEKR6fLT97B7lUsl9DIbSBPpsxZgJodAYUH7ZCYvhjj2VrBlQ3zjnHpYC6HVvu3ySek/YC0Dm/cKx8wgHrrtgoQstayJie7CVpgo8cc6DVg9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 14:39, Nikita Kalyazin wrote:
> 
> 
> On 30/11/2025 11:18, Mike Rapoport wrote:
>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>
>> userfaultfd notifications about minor page faults used for live migration
>> and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
>> mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
>> minor fault registration mode").
>>
>> To use the same mechanism for VMs that use guest_memfd to map their memory,
>> guest_memfd should support userfaultfd minor mode.
>>
>> Extend ->fault() method of guest_memfd with ability to notify core page
>> fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR) to
>> complete and add implementation of ->get_folio_noalloc() to guest_memfd
>> vm_ops.
>>
>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>    virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++++++++++-
>>    1 file changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index ffadc5ee8e04..dca6e373937b 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -4,6 +4,7 @@
>>    #include <linux/kvm_host.h>
>>    #include <linux/pagemap.h>
>>    #include <linux/anon_inodes.h>
>> +#include <linux/userfaultfd_k.h>
>>
>>    #include "kvm_mm.h"
>>
>> @@ -359,7 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>           if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
>>                   return VM_FAULT_SIGBUS;
>>
>> -       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> +       folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
>> +       if (!IS_ERR_OR_NULL(folio) && userfaultfd_minor(vmf->vma)) {
>> +               ret = VM_FAULT_UFFD_MINOR;
>> +               goto out_folio;
>> +       }
> 
> I realised that I might have been wrong in [1] saying that the noalloc
> get folio was ok for our use case.  Unfortunately we rely on a minor
> fault to get generated even when the page is being allocated.  Peter and
> I discussed it originally in [2].  Since we want to populate guest
> memory with the content supplied by userspace on demand, we have to be
> able to intercept the very first access, meaning we either need a minor
> or major UFFD event for that.  We decided to make use of the minor at
> the time.  If we have to preserve the shmem semantics, it forces us to
> implement support for major/UFFDIO_COPY.

If we want missing semantics then likely we should be adding ... missing 
support? :)

-- 
Cheers

David

