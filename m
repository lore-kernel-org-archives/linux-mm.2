Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA601CFA47A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FAF6B0030; Fri, 21 Nov 2025 02:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE01A6B0031; Fri, 21 Nov 2025 02:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF386B0032; Fri, 21 Nov 2025 02:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB6AF6B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:26:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71BF0C04B0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:26:33 +0000 (UTC)
X-FDA: 84133781466.08.E2B5964
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E3E6A40006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:26:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF2yKBiv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763709991; a=rsa-sha256;
	cv=none;
	b=k4bNFB/oQcUZYDSqxxIwuTgA8yoHR5ffX3uKqRnQPcwWRwT77+3qgYrMHCCQudWZudcOcQ
	xkk3mXaGdTbuPZvtXnWxRDgO3SuBLKE1h7A66IoAibR6Da/ruKlLDibiNrcxXaPc/n4rDM
	FxZLQ69+wT8kmtBl+RrFtp8OajdiCXo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF2yKBiv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763709991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gBACFNqAjGOwqT0rHhPx4vOrC0UpPtZGoTsO/E2Z9o=;
	b=5X9TTNz/Io7vMCCT+rO094qXl74V5pb/HVi7/DcXv5EpWqzHfzy/khclx0DDQzf+Ic4Hak
	b0MUABi9L4UftHmPTx/O+Z2MZEAPokXL3mPe4XrZ6DrE5jUY78n46nB0jgfN2yK82xT/ts
	YGk/zj3erMdUYBP/lUXLRXSQ8T4SDW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49A97601D5;
	Fri, 21 Nov 2025 07:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD69AC4CEF1;
	Fri, 21 Nov 2025 07:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763709991;
	bh=oqlxKrYCUDo4BexNk4ldK4CDggjRPKz6C63gmt/SUQ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uF2yKBivgZJ7CX020H1zbqb9ngZIlCl1gZQSqjqfTqKjVVUmxSpY/eb3U/43sho6/
	 Vz0QIAJ6rpfrzkRPsK5k5pnygwr/LDjnLtQHyLeaGOMP9kB+VsRgMFlVnJi7XKIkAP
	 3HchUY9fGqzRVdolI+Utm4JEPKXltYjDhx3BVmkUpwXPjnWLvSXZiPA7KXaZj997FE
	 fZi4r7MhmnhJqGjFZFKw7gAgCX1K73uLQgdIshpST30nSEB7Pzt6QeZgqTqxJTkfXv
	 SX9bIPFjl9m6TAcdJQ/tsyK13RrhPWAu6p7GoeCKiMX49C455qU9MGLAPafPnlehmu
	 FWvIFk8CCCxqQ==
Message-ID: <ba9ec539-b0de-4f5b-888c-bf0aeb08e274@kernel.org>
Date: Fri, 21 Nov 2025 08:26:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
 <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3E6A40006
X-Rspamd-Server: rspam07
X-Stat-Signature: upjmgrrbcntsnbcgo3ytw4w8hsdcehj9
X-Rspam-User: 
X-HE-Tag: 1763709991-140426
X-HE-Meta: U2FsdGVkX19sWVyo0+hLqH/fPNe0xm7XVVNHbFLi6dEv5G8MjZ4rPbvbtZbnsRKdF1iGTerTG8338v3ApPmDHOlla7gc9aV/uy7NRKVgWfoqEIL4Hw8k4MHxZNG/s1MS7tlQeXjAI4I8q4VRk/LRGVGeDTj+HvHzyHNZsmgklG0eP6zK/tpQx2H1s+WnMCakuJvgRX6XxUkhPxqVMEdHvzWxdAbD6MsQvR6iJXkLhfkfCSPNq23yBl9jt26frEYtF7OvdMYUsM9VNzwfPmdmniNOjfi8pW1mr5ysdNXqsQ6nIcsooFf+U9ccy0M1ddksmRB1n4G1xjwVSX8TN4EZ43toTbrts9n1nmG3cYC9TBOROcaYp8VfocncaZ1SaPoeRnXD3e6ZMt+yjqnqpyXrah0qkWUsZJ+DmYEZzCcxU4jjRstnA89Cf2IZNuZiQKXczAy4hCK0QYlNzDnyIUFWiJhtjbfyhujeZRs4x6ABfSmiiPE4qvxZHVEMOB6lfsbFfOuhgJaodL76K/HvBUmiGJhsc0y2kmq6tJxsmrwnNn4didQKhiMKvICLmBXqTwYZrmyTTVi4mrAGxFezPS8cJf5zSPCuevxmdW+ZfxJpiVddPVuOjFw/K+bjDYQrRRF+RVqKiVu47bWQ07iQFquewrnRvKLTXj3GlnVfRmQOXTFPTJKz8LSEbxpRy9xI1gQjJw2Ub0nzp/Gd86gq+sYmY+u3shq0JCXxlV0AuJsT0nPkPGc7J4lbmp8fT8k+AOtggOYZDwbt599v7qF3hhu3jEd3mUE/QUi2p3yIWAhRdKdwEhSr/3UWAdgIT2C7HFriADAmwBqqYMKI5UKf4Kiq9FLmyzX7FVwXTtPUzjossHWDdf0zh+vRN4a0YDVdFQSIYmQ4059bKNYYrV2fUU/I8iqmcdGZDpa07Tv4wttlCvX/rv5x6l8h4ohWRm09uxMmf9ncprKcz1yOhSGh746
 AJEyP/3d
 GSbNk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 10:58, Lorenzo Stoakes wrote:
> On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/20/25 10:35, Lorenzo Stoakes wrote:
>>> On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 11/20/25 10:04, Lorenzo Stoakes wrote:
>>>>> Hi Vivek, thanks for the patch.
>>>>>
>>>>> In general though, let's please not make a fundamental change to mremap()
>>>>> behaviour in late -rc6. Late in cycle/during merge window we're really only
>>>>> interested in existing series, series that are less involved than this.
>>>>>
>>>>> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>>>>>> When mremap is used to create a new mapping, we should not return
>>>>>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>>>>>> the old VMA would neither be expanded nor shrunk in this case. This
>>>>>
>>>>> I guess you're trying to be succinct here and 'clone' each input VMA using
>>>>> the 0 source size input.
>>>>>
>>>>> However this can't work.
>>>>>
>>>>> This operation is not equivalent to an mmap(). It may seem to be for
>>>>> ordinary mappings but in practice it isn't:
>>>>>
>>>>> (syscall)
>>>>> -> do_mremap()
>>>>> -> mremap_at()
>>>>> -> expand_vma()
>>>>> -> move_vma()
>>>>> -> copy_vma_and_data()
>>>>> -> copy_vma()
>>>>>
>>>>> Essentially copying the properties of the VMA to the new region.
>>>>>
>>>>> But this doesn't work for PFN map.
>>>>>
>>>>> At _no point_ are you invoking the original f_op->mmap or
>>>>> f_op->mmap_prepare handler.
>>>>>
>>>>> And these handles for PFN maps set up page tables, because PFN maps
>>>>> literally do not exist as VMAs which have properties independent of their
>>>>> page tables like this.
>>>>
>>>> vfio-pci is a bit different, though, as it uses
>>>> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
>>>> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>>>>
>>>> (see vfio_pci_mmap_page_fault() )
>>>
>>> It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
>>> bug there:
>>
>> Yeah, I am all confused about expansion. The example code looks like all it
>> wants to do is move a VM_PFNMAP mapping.
>>
>>           if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>>               MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
>>               goto err;
>>           }
>>
>> I guess the expansion is because of iov[i].iov_len is bigger than the
>> original VMA?
>>
>> Is that maybe a bug in QEMU or why are we even expanding here?
> 
> We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
> of this VMA at a new address'.
> 
> There's never any moving, as input size is 0 :)

Ah, so it is indeed cloning. The cloning as part of a "remap" operation 
is really confusing.

> 
> It's a cute corner case way of using mremap().
> 
> We're basically asking for a _copy_. But you can't get a copy of a
> VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
> to get something sensible and you are bypassing that on expansion, even if it's
> a 'clone' style expansion.

Yes, agreed.

As Akihiko writes, what they want to achieve resemble a bit what fork() 
does. But there, the flow is rather different.

-- 
Cheers

David

