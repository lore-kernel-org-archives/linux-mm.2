Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39ECECDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988F86B0088; Wed, 24 Jun 2026 18:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939DD6B008A; Wed, 24 Jun 2026 18:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802E86B008C; Wed, 24 Jun 2026 18:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7126B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:15:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A49C71C327D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:15:36 +0000 (UTC)
X-FDA: 84916213872.14.5F63F69
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60FDB140018
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:15:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pgkxISqk;
	spf=pass (imf09.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782339334;
	b=H2Xp0A3nPYf0jV9HhtWnJyQLuHLSU89glwv0caD/8hr6mMNvFbpoWk5c2AfTa2Oq8xVbuh
	9CH6b+yEKtt497249WkT7YQOjynE106KDaG/EW463SAM305HuC5DRU7jvjhU7++FwXSUIM
	reS9dLdQvT6k7gvYHmHEffMZmJEqmj8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782339334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTved+2n5OUgjpOg4aL+yVrwBIU3TvLKdoqzJjN5hf0=;
	b=JqgL5CGH55eduAsTtjJ1QlRu1NvLD3C7Z86ice9ZdVLpm88ZSfplTNvuuzbEhHAS2L9JV7
	rTJzBkoC9IoEbrfaY5S5pPtR0lM6tqmQM5rwIXqHvYK2m8Y2VWHVgmZ72Awi6xPcuN0q+c
	Sag9ZcHryHj2YD8eBUdUOIOu/QUUO3Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pgkxISqk;
	spf=pass (imf09.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BCE81713;
	Wed, 24 Jun 2026 15:15:28 -0700 (PDT)
Received: from [10.57.27.206] (unknown [10.57.27.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FCE13F836;
	Wed, 24 Jun 2026 15:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782339333; bh=Zy6wS1CmTg71IZaipoH1Pua6+GxzQf18bdCRG9CVKh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pgkxISqk+UnvbctXNJ7fahDtPBCViPNfu0FOGoLRACNCDY+2+edt1Ym7Q6jZaU5eF
	 xZ6UIQ/RZcCBaoh+OHuhGqoeenQ+VSPHAeXKNHOVzovazo/PC8I28EO/mXIuBNRPkX
	 mZUMOdYfgk0kHLRkc5ilHe6ukNb/Ts7PF+8JQzT0=
Message-ID: <1ec93c21-5831-4b18-b6a1-3e429f58c1fd@arm.com>
Date: Wed, 24 Jun 2026 23:15:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on
 conversion
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com>
 <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com>
 <ajneQVLriUshjFIO@google.com>
 <CAEvNRgGX3GkazCWM=6y9YLgn=YemXuG==Oo+L58cac1Fd86_TQ@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgGX3GkazCWM=6y9YLgn=YemXuG==Oo+L58cac1Fd86_TQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kbmndesyp5x6bxm8dmneq8f8d653icwk
X-Rspamd-Queue-Id: 60FDB140018
X-Rspamd-Server: rspam06
X-HE-Tag: 1782339334-979203
X-HE-Meta: U2FsdGVkX1/4t3/xOv4twAHvP/qT4jptdYX7GG+ZmoeD+RNvOD/dIz41fgJRznEHFUeifOji4ZsNsQKTO/OPnuKrb71gdLzeQnhVTLhI5pQMkr+EBH/l9e58BWT164CFFso5s87Bpz3XncB5Niz9km68AlP+hIePtxQynALpRUltmH3yfxYGPMCrn8Qj9CIG2dZv0IGvvALoWOjEk6fq7516wDBFucXe6xrAZLaqlIDS9gQVBqocd76pt5KAmDkPY/jAIU/wdnFpiuhrsObrdTWKQpMAXNo29vuxi8PhESdlkPryDnzqiYj3pODhSK1ggXU4w9WEMJBEOkWZbbo1S+r2AJXJw+XscIyn39kFIoAOogu757+i9NuxAwu6qLHK0ZtUIf4qD9diocT1dKYjb0mh/n6QkV+HKB+49cs6PyhAopr2XjP6RjuBXcziWkAo3ZHpESGW4x0/Z6sgpSwNGy8zm4InmP0XKEsVB8ykePsRRpC5ZnwXRnsXA9tXMHLTNtvZ1s+06ltlbuvFD1NGPLdae2kLfyf24kHc68inUTgdAlKo4IpkyuDvUCUWAerzZXF4yEFVsIi8wai1gzAh8SRKkIVOIS4qjalSHzdz6x2WiHFX8S9hQWJb1dy31LQMt9pR5PEkt1+71cNPMzlN/FjDXh+uco/HlxmADzgUHtYqjy/ZU8CYOlQMswn7wvH7hNUPTldzO9DB8VMAYpcAj+cVf48gu7LRpTsBAGdZFvnoDeV8m40wPIcqSm1GtsTp1E7+tNeDvWJlJQt6MvCoRRXceCyajr6zLwA1hoHkRcbIrjfVWIDwKGpkakFYDAgQ2eZgBJ/ybYD6LEVxAWHBnB+XlEaqWRxMnYr1zYOoOLRwJgLUJuza/UAgPKcTADDQPS7LfjiPMyTt6RqXpwO0xY4/ESaOi6ADPvzJQ2vbQP5/MduDcGD9o+31KZzpsKzbBFrU9nwgNuUcedAYnWB
 gpg+4L9A
 gNZ8jX0OVS9UcUIk9XfceUe3rp+VZ5zrxwtTk4q+TAUoLQEp9UWEAHVTRFZKte7eBTly0vuSJoMYVHNJy4rVX5iSxBRsSVUnLfXN9G7cUXc43gTMw811iQbK70SCB/vDF3dLkpsa1Lhg1XPYsY60uxi8Jv7oUJgjbiXCSD8iZhtZo6X9soj3oskbUAG8r7BEASkCnx3abF43sMOfeSnfK/dfJEv/kyLw3jnNRaRw92uu+031mTNtJQr9EirrJQw7E3iXbeAXPSgPbXNEmkfy+wHmi2hc9sBTrkdEzEPiHFUEhDX6t9LFiY0peU6U+ZIGXMUzYmfbbx7yyWjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/06/2026 18:46, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Fri, Jun 19, 2026, Fuad Tabba wrote:
>>> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
>>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>>>>
>>>> From: Ackerley Tng <ackerleytng@google.com>
>>>>
>>>> When memory in guest_memfd is converted from private to shared, the
>>>> platform-specific state associated with the guest-private pages must be
>>>> invalidated or cleaned up.
>>>>
>>>> Iterate over the folios in the affected range and call the
>>>> kvm_arch_gmem_invalidate() hook for each PFN range. This allows
>>>> architectures to perform necessary teardown, such as updating hardware
>>>> metadata or encryption states, before the pages are transitioned to the
>>>> shared state.
>>>>
>>>> Invoke this helper after indicating to KVM's mmu code that an invalidation
>>>> is in progress to stop in-flight page faults from succeeding.
>>>>
>>>> Reviewed-by: Fuad Tabba <tabba@google.com>
>>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>>
>>> Coming back to this after working through the arm64/pKVM side. My
>>> Reviewed-by here is from the previous round and the patch hasn't
>>> changed, but I missed an implication for arm64.
>>>
>>> kvm_arch_gmem_invalidate() is now called from two paths with the same
>>> (start, end) signature: folio teardown (kvm_gmem_free_folio) and
>>> private->shared conversion (here). For SNP/TDX that's fine, conversion is
>>> destructive anyway. For pKVM the two need opposite content semantics:
>>> conversion must preserve the page in place (same physical page, the point
>>> of in-place conversion without encryption), while teardown must scrub it
>>> before returning it to the host.
>>>
>>> The hook gets only a pfn range with no indication of which caller it's
>>> serving, so arm64 can't give the two paths the behaviour they need. It
>>> would help to signal intent on the conversion path: a reason/flag, a
>>> separate hook, or not routing non-destructive conversion through the
>>> teardown hook.
>>>
>>> arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
>>> second caller now, and it's cheaper to leave room for the distinction
>>> than to change a generic contract other arches depend on later.
>>
>> Crud.  It may not be urgent for arm64, but it's urgent for other reasons that
>> I "can't" describe in detail at the moment, and even if that weren't the case, I
>> think we should clean things up now.  More below.
>>
>>>>   virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 41 insertions(+)
>>>>
>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>> index 433f79047b9d1..3c94442bc8131 100644
>>>> --- a/virt/kvm/guest_memfd.c
>>>> +++ b/virt/kvm/guest_memfd.c
>>>> @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>>>>          return safe;
>>>>   }
>>>>
>>>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>>>> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>>
>> Not your fault, but kvm_arch_gmem_invalidate() is badly misnamed.  It's not
>> "invalidating" anything, it's much more of a "free" callback, as SNP uses it to
>> put physical pages back into a shared state when a maybe-private folio is freed.
>>
>> As Fuad points out, (ab)using that hook for the private=>shared conversion case
>> "works", but not broadly.  And it makes the bad name worse, because it's called
>> from code that _is_ doing true invalidations.  For pKVM, it may not even need to
>> do anything invalidation-like.
>>
> 
> Thanks, I also didn't like the naming of kvm_gmem_invalidate(),
> especially when conversions also calls
> kvm_gmem_invalidate_{start,end}() and those do different things.
> 
>> To avoid a conflict with patches that are going to have priority over this series,
>> to set the stage for arm64 support, and to avoid avoid bleeding vendor details
>> into guest_memfd, as if they are core guest_memfd behavior (only SNP needs the
>> "invalidation" on this specific transition), I think we should add an arch hook
>> to do conversions straightaway.
>>
>> Unless there's a clever option I'm missing, it'll mean adding yet another
>> HAVE_KVM_ARCH_GMEM_XXX flag?  Hmm, especially because IIUC, arm64/pKVM doesn't
>> need a callback for this case, only the free_folio case.
>>
>>>> +{
>>>> +       struct folio_batch fbatch;
>>>> +       pgoff_t next = start;
>>>> +       int i;
>>>> +
>>>> +       folio_batch_init(&fbatch);
>>>> +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
>>>> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>>>> +                       struct folio *folio = fbatch.folios[i];
>>>> +                       pgoff_t start_index, end_index;
>>>> +                       kvm_pfn_t start_pfn, end_pfn;
>>>> +
>>>> +                       start_index = max(start, folio->index);
>>>> +                       end_index = min(end, folio_next_index(folio));
>>>> +                       /*
>>>> +                        * end_index is either in folio or points to
>>>> +                        * the first page of the next folio. Hence,
>>>> +                        * all pages in range [start_index, end_index)
>>>> +                        * are contiguous.
>>>> +                        */
>>>> +                       start_pfn = folio_file_pfn(folio, start_index);
>>>> +                       end_pfn = start_pfn + end_index - start_index;
>>>> +
>>>> +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
>>>> +               }
>>>> +
>>>> +               folio_batch_release(&fbatch);
>>>> +               cond_resched();
>>>> +       }
>>>> +}
>>>> +#else
>>>> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
>>>> +#endif
>>>> +
>>>>   static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>>>                                       size_t nr_pages, uint64_t attrs,
>>>>                                       pgoff_t *err_index)
>>>> @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>>>           */
>>>>
>>>>          kvm_gmem_invalidate_start(inode, start, end);
>>>> +
>>>> +       if (!to_private)
>>>> +               kvm_gmem_invalidate(inode, start, end);
>>
>> E.g. instead make this something like this?
>>
>> 	kvm_gmem_set_pfn_attributes(...)
>>
>> Hrm, though that wastes folio lookups in the to_private case.  So maybe just this,
>> assuming pKVM doesn't need to take additional action on conversions?
>>
>> 	if (!to_private)
>> 		kvm_gmem_make_shared(...)
>>
>> Actually, if we do that, then we don't need a separate arch hook, just a separate
>> config.  It'll still bleed SNP details into guest_memfd, but it'll at least be
>> done in a way that's more explicitly arch specific (and it's no different than
>> what we already do for PREPARE...).
>>
> 
> pKVM needs some arch guest_memfd lifecycle functions that
> 
> + for conversion, doesn't do anything,
> + for teardown, resets page state (IIUC it'll be reset to
>    PKVM_PAGE_OWNED (by the host))
> 
> So I think we need different functions for those two stages in the
> lifecycle of a page with guest_memfd? What if we have
> 
> CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES, which gates
> 
> + kvm_gmem_should_set_pfn_attributes(attributes) and
>    .gmem_should_set_pfn_attributes
> + kvm_gmem_set_pfn_attributes(start_pfn, end_pfn, attributes) and
>    .gmem_set_pfn_attributes
> 
> CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN, which gates
> 
> + kvm_gmem_teardown() and .gmem_teardown
> 
> SNP:
> 
> + .gmem_should_set_pfn_attributes = sev_gmem_should_set_pfn_attributes,
>    and sev_gmem_should_set_pfn_attributes returns !is_private
> + Rename .gmem_invalidate and sev_gmem_invalidate to *set_pfn_attributes
> + .gmem_teardown = sev_gmem_set_pfn_attributes
> 
> TDX:
> 
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN
> 
> pKVM:
> 
> + Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
> + .gmem_teardown = pkvm_gmem_set_pfn_attributes
> 
> Suzuki, does this work for ARM CCA?

Yep, that works for us. For CCA we would :

+ Disable CONFIG_HAVE_KVM_ARCH_GMEM_SET_PFN_ATTRIBUTES
+ Disable CONFIG_HAVE_KVM_ARCH_GMEM_TEARDOWN

In the future we might utilise the gmem_set_pfn_attributes call back.

Thanks
Suzuki


> 
> This way,
> 
> + The if (is_private) check doesn't leak SNP details into guest_memfd
> + .gmem_make_shared doesn't stick out without a .gmem_make_private
> + .gmem_set_pfn_attributes, .gmem_prepare and .gmem_teardown are aligned
>    conceptually as lifecycle hooks
> 
> + I think the private/shared check for prepare can also be folded into
>    preparation.
>      + Preparation perhaps doesn't need a should_prepare equivalent since
>        there's no iteration and getting the gfn is just doing some math?
>      + In another patch series?
> 
>> E.g. this?  There will still be a looming rename conflict, but that's easy enough
>> to handle.
>>
>> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
>> index 9ce5be7843f2..8aead0abd788 100644
>> --- virt/kvm/guest_memfd.c
>> +++ virt/kvm/guest_memfd.c
>> @@ -648,8 +648,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>>          return safe;
>>   }
>>
>> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>> +#ifdef CONFIG_KVM_ARCH_GMEM_FREE_ON_SHARED_CONVERSION
>> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
>>   {
>>          struct folio_batch fbatch;
>>          pgoff_t next = start;
>> @@ -681,7 +681,7 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>>          }
>>   }
>>   #else
>> -static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
>> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) { }
>>   #endif
>>
>>   static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>> @@ -729,7 +729,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>          kvm_gmem_invalidate_start(inode, start, end);
>>
>>          if (!to_private)
>> -               kvm_gmem_invalidate(inode, start, end);
>> +               kvm_gmem_make_shared(inode, start, end);
>>
>>          mas_store_prealloc(&mas, xa_mk_value(attrs));


