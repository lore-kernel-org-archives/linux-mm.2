Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5505FA1FE1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17C76B0088; Wed, 22 Apr 2026 14:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8D66B008A; Wed, 22 Apr 2026 14:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7126B008C; Wed, 22 Apr 2026 14:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 890D36B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:14:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40A3C1B7075
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:14:31 +0000 (UTC)
X-FDA: 84686991942.21.D43CF9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 84A9F4000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:14:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIQWQrIY;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776881669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nluioVjBnPpi3V4ntlzyBb8qLqZAE9QsrJztNkk+29s=;
	b=wZ41bZlEXLNKc5v2L9QB5yjKZWFLj7NxLvS6s/sPGzz1QABuG5tV/YvaUZu61wie9grd0+
	i3jV3fXqe9JeI/UUiwcaKJcI45Wg/zc/t42UOMz3m+exSgAXfWqJf5Ja3D0yQnV8OQVPzo
	Sc8IYkkIU8I8opiOu1JVn58BjlpBUSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776881669; a=rsa-sha256;
	cv=none;
	b=wRt9YzoT20AYfSVjgRHlxroTwk7Kr2JA7OZgLeIaYwkfkSxChwwySzYyb643eaozvq0Jqp
	dQyWdURDUXSaKQsD9uoEe776FdHpJJhDFYbibeOHY6ySl4rgwKWGanGEP7csiafIn3ldUh
	GAV8qLDb5HNEaovmWIq/cvoNCnhZbkc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIQWQrIY;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5F8061340;
	Wed, 22 Apr 2026 18:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9A6C19425;
	Wed, 22 Apr 2026 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776881668;
	bh=JQVpfx37nESej/CYg2Jr9FlOJ9VwGeutbHe3G/GQHcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uIQWQrIYBiwKihiJZXPtqlBzbZQLVjVujHKpiGZBQgZ9gjW8NpKcr+lO0lUN2yf32
	 bEFoErqevMIPXfZhb1VesZyoNpPyKlzs/qihUucF1PvzWJASTiQ6QY9Uj/kQaLx7sg
	 gUghyLyfbq7i0bfUVMKpLIonOcSPetnuz4S2SRzi3zFlks6oYkwyArouQ87jRLZDBx
	 831hNc/wi4b6QcU7yxM3q/sW1VoKyVL2eDBxsibm/PSoFHSgVMesStIvqJDvmk9CRp
	 sxkHT79vPsg7Q5Sg43iVWE8mVWWFvhKblSvamkWXgm4XoGG5q9P/ho/KpCKPfafA8K
	 8qugC8DY6Cjeg==
Message-ID: <b47ba580-2443-482f-8a92-558af82d13f2@kernel.org>
Date: Wed, 22 Apr 2026 20:14:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
To: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <286425bc-e2a2-4e29-abdf-666e798e6cf4@kernel.org>
 <aejiV8rQIOgrlCkh@skinsburskii.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aejiV8rQIOgrlCkh@skinsburskii.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84A9F4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: qzkxgb4zjdtpsrgriwkcnzud5hb45hig
X-Rspam-User: 
X-HE-Tag: 1776881669-112300
X-HE-Meta: U2FsdGVkX1+gnettHs+nKLRNf5cL2dvhOrI9cOMfdukHiKye9MR3Y6CUNF1L4JnqhsBVBzBjx19MNVi8jpL1tuyfMw9SnatZ/sok86a3UIvEKzHUW6w+bsAfGql4SW4KQdm9bGhY13BH3fxrGrrTZt+o6CVaKjBDMcuvqBaGNripfPK41vkMbYcQ7o/72ZPif7IbL55qK3AI3hejaMiMRvDAXxbv1eb24iRc6a9E2moWrat8MOGv5MtS9T4LL1/aFZdmCURiPko+0DgQbj/TGEOJMuVG/WrN0O2eQu0o8fAEsV462Uly584rEsoi8gBBesc0hLHm0F6LbqDnfQpKBvqwhH9OsBW1Ff3gMl8eMsxcHrai4hJKUy7IlHjgLOyazLUjCkY+SBNnvzC/y3SXId8ptbsVQy3ARc1psQywA5I2Icj0nsWYGyB2o8sIx7fIEzShlWDXbE+5P9K3F9UJk2dfkGXBBcfaeGGUKQ/VG3dHQC/k/uGvJq2iymIGrcEyrx5jkXol61t6pG/0tYp4D2MEDg+oQ+FjyoRi4hUqrEnRB4xWMXDDb7R7P7SVHfsoeJXGd948tnYnkFAfwxdQTmAAXw8znf4h8+z8OZtzHyl9Ls52qchuUPQg5ObcJYl2X1t+Vh+RAopF0QOEtXMjAzHh9R7trOT44JYc8tJtv3dFF043KAgJuUnU7q7pf14ewzA3zAsIr/hOPhz04Z6FsHmXMLupbClmSgzC2a+fpFuAvH7UCC/UfQUqCHOFcnem6Y3dTSD100RsvGHyQrNBrr02WZuCtN3hAi1VzCjucAsrfK/RhBlQbnvIggqxkQ7tnl2Fvx+bwzXMMfl1ppBRWLfX0gmV4EMXqBXkAytsUHEwFtZqRXvEd/mFYYtVqxsyuprrCgAPNNQYuMCnTr0Zm9iarlWA1kdTLucku7UNhIP5KjvqNYUK9e2pfkbefUd9KznhYSYttBsFGS5HpuT
 IMYHm3PA
 SG2jnDuk4lrrWRkDWBruXzrktbmQRljp2Vu/EA6Hsp4H3joA3vvZ+g9hyzwBGexuaJaEq/csFiXQNPbyBzRLH9Fa1LjAPzzvohvSj4Hh1GnINjQcxSLVW9h1dTm8nAVbxaWSqvUjCSRNax99Dk0eHZayTZ/5hIMjsVwovfKEoWVJvhIoNOipKaOE2pHMZEpqjvQQ53A/E7h+EpZvGgbHAp/RKA1FOZV9uKJdvGoFN6Ncs+HOY8+ngz1jLB8hkKPmbErlbU7nz67bAk10o9KKKuQ+JR6Jtt+5i14nmCyIR0+6Yo9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 16:59, Stanislav Kinsburskii wrote:
> On Wed, Apr 22, 2026 at 09:27:44AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/1/26 00:24, Stanislav Kinsburskii wrote:
>>> Add support for userfaultfd-enabled VMAs to the HMM framework.
>>>
>>> Extract fault handling logic into hmm_handle_mm_fault() to handle both
>>> regular and userfaultfd-backed mappings. The implementation follows
>>> fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
>>> a key difference: instead of retrying or moving forward respectively,
>>> return -EBUSY after reacquiring mmap_read_lock. Since the lock was
>>> released, the VMA could have changed, so defer retry logic to the caller.
>>>
>>> This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
>>> populate one page at a time, but keeps the framework simple by avoiding
>>> complex retry logic within HMM itself.
>>>
>>> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
>>> ---
>>>  mm/hmm.c |   40 ++++++++++++++++++++++++++++++++++++----
>>>  1 file changed, 36 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/hmm.c b/mm/hmm.c
>>> index f6c4ddff4bd6..d04d68e21473 100644
>>> --- a/mm/hmm.c
>>> +++ b/mm/hmm.c
>>> @@ -59,6 +59,35 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>>>  	return 0;
>>>  }
>>>  
>>> +static int hmm_handle_mm_fault(struct vm_area_struct *vma,
>>> +			       unsigned long addr,
>>> +			       unsigned int fault_flags)
>>> +{
>>> +	int ret;
>>> +
>>> +	if (userfaultfd_missing(vma)) {
>>> +		struct mm_struct *mm = vma->vm_mm;
>>> +
>>> +		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
>>> +			       FAULT_FLAG_USER;
>>> +
>>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>>> +
>>> +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
>>> +			mmap_read_lock(mm);
>>> +			return -EBUSY;
>>> +		}
>>> +
>>> +		if (ret & VM_FAULT_ERROR)
>>> +			return vm_fault_to_errno(ret, 0);
>>> +	} else {
>>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>>> +		if (ret & VM_FAULT_ERROR)
>>> +			return vm_fault_to_errno(ret, 0);
>>> +	}
>>
>> I'm surprised that there is userfaultfd_missing() logic required here at
>> all.
>>
>> What prevents us from always calling handle_mm_fault() in a way +
>> handling return values, such that we will just do the right thing
>> independent of userfaultfd_missing()?
>>
> 
> Essentially, the main issue with the current HMM framework is that
> handle_mm_fault() with FAULT_FLAG_ALLOW_RETRY (needed for userfaultfd)
> can drop the mm lock. The framework does not expect or support that yet.
> That is why I had to add the branching.
> 
> The worst part is that handle_mm_fault() can unlock via
> mm_read_unlock(), while svm_range_restore_work() takes the mm write
> lock and this RFC patch doesn't address this problem.
> 
> The main question where I’d like feedback is: should userfaultfd be
> supported in the HMM framework at all, given the complexity around
> unlocking and retry handling (similar to other gup helpers) or should
> this complexity be offloaded to the caller side?
> 
> If it should be suported, then I see two ways to implement this:
> 
> 1. Introduce a new HMM_NEED_USER_FAULT flag to tell the framework that
>    the caller needs userfaultfd support, and extend the framework
>    accordingly. This is not intrusive to existing code. But if we want lazy
>    migration for GPU state in the future (and we likely do), GPU drivers
>    will have to be updated to set this flag later. The only real user of
>    this feature right now is the MSHV driver and I'd extend it to set
>    this flag right away and leave GPU HMM users for later.
> 
> 2. Add retry logic to hmm_handle_mm_fault() to handle VM_FAULT_RETRY and
>    VM_FAULT_COMPLETED, as required for userfaultfd support. This would be
>    transparent to users. But it would require significant changes: mm
>    relocking, VMA lookup, and other parts. Also, before doing that, the
>    kfd_svm driver would need to be changed to downgrade the mm lock to
>    read.

Exactly this. If we want this, it should be done the proper way, by teaching
calling code that the lock was dropped etc.

There should not be userfaultfd special-casing anywhere, it's just a matter of
teaching the code that we might get the mmap lock dropped.

Now, that might be a bit of work :)

What we do in mm/gup.c, is letting callers opt-in whether they can handle
getting the mmap lock dropped -- not opting in to userfaultfd.

See FOLL_UNLOCKABLE. Such an approach enables a step-wise implementation.
But note that FOLL_UNLOCKABLE is an internal flag. We set it automatically when
someone passes us a "locked" variable, indicating that they can deal with it.


See populate_vma_page_range() as one example.

-- 
Cheers,

David

