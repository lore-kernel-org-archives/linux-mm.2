Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A435BC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827226B008C; Mon, 24 Aug 2026 04:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0C16B0092; Mon, 24 Aug 2026 04:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CAD6B0095; Mon, 24 Aug 2026 04:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33E496B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:28:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CA11C0450
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:28:07 +0000 (UTC)
X-FDA: 85135485414.16.0C24BCF
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5BC2FC0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:28:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LjJ6LwxO;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787560085;
	b=VSr2f0CsoT3UMbZgIBPUXmWT3bGDQT4S/97E2+ILZRB/JgPnnPRyAhZKlGcXK8/A93Uw3r
	UK58hv3PH7kjOeL3jxc4ox0OLbgtKmJnU29sUQ0xBG0ERAIdrH3tbv5DmaPJvghR5Cs25N
	3xWUJnB2WOmxyIyXQ8ieRnR7B3VURmY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LjJ6LwxO;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787560085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlBZQlIinQ5KKnZrbICashz/fC68Fz7GnIJhwKZISAc=;
	b=ZYZBPV+Hng7YX/vEzcQGmgXMxl+BC8tbkNBlRCuwEhTM5RG3kESflinnLBQzaA4rqbW3nC
	Q0hpOPIBPKjVOPRR0j+fc3k3t1jlN0qPKT+SuTTCwFohL1ppLP+dh2nVN8CTmwCCAvS0s3
	UCkYsrsaEisvL/xhNGKC7LvGhxuCx5I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8Pl7rmcIvwX+tzegpkwJKg5akKbpn9WU8gbrZ1f0X8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787560081; v=1; x=1788164881;
 b=LjJ6LwxO2XPMd9oUysjq8G0CYOWF4VzDt09U8RGs0WH8lFAhfhCHNMnUTeQ9JE83869mX1TK
 EWbZLkG1UPpibY/1ZklwKooBXY18Nt44P586BiTfw2lnPLEfxfMBS2E71xXXxoPUwK4t3VHGXSd
 huWKoKD2Z72W8xJ1K0wdXGvU=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.244.244.3] (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 8e0a79e38506ea9a;
	Mon, 24 Aug 2026 08:28:00 +0000
X-Mizu-Trace-ID: 8e0a79e38506ea9a
X-Migadu-Flow: FLOW_OUT
Message-ID: <cff17006-b534-440a-8be7-651fb0a940cd@linux.dev>
Date: Mon, 24 Aug 2026 16:27:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com,
 corbet@lwn.net, liam@infradead.org, ljs@kernel.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, mhocko@suse.com, muchun.song@linux.dev,
 nico.pache@linux.dev, osalvador@suse.de, pfalcato@suse.de,
 peterx@redhat.com, ryan.roberts@arm.com, shakeel.butt@linux.dev,
 skhan@linuxfoundation.org, rostedt@goodmis.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <20260824071126.41979-1-lance.yang@linux.dev> <aov9_DIHLHynm7tN@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aov9_DIHLHynm7tN@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5BC2FC0007
X-Rspam-User: 
X-Stat-Signature: f9ij396fq48miipo9uqyn59q9mhnw7tk
X-Rspamd-Server: rspam06
X-HE-Tag: 1787560082-613130
X-HE-Meta: U2FsdGVkX18YAbXHKJPlYDP0lbg26za0UMWkODygppklJtUl8mjBnjdJsB/dflj61F2klsM4pach1bjzV1SigQkhFRbMKVBKdo/kdu2TXZgITAdYmUPbWNHpexHijZXZ4lpPbpeVQiDoY37cdmSYgWLjWQ0hOfCR646q5jPBEuzG7z35vZR42z8Ja0CWoY/cWjiHoW9Gf1CxygLdNB6gIPE2A+mC27dVhEOg6YxsNOlStH/tEy1TNSmHpjrA0jYKUNWGwSjnHm0rmvCatDQ+WgHOnezC7CgThsdCQ9Xe8XYDTds06lLDWSyB346uPEqrVOZQzkfPxhOpL157drrOaq5Lgkb0n9ihKFyGkWD+fnl24vo7+7w6T1bTQj8WTISSu4w1WidEWWL3yHTDf+ZCREp2wWunSw4zGa7A3vCSU/K6lJCTqx7DTS1gzHS6RmHJw93SNpx7NqO0tYGTzJoeTctEcHPJT72bdOutlMkg4xEzORv4+KkY6xG/XSGryVgI71NjinP3sF8mUNVesgrytS/s/epNUoGE7dAu+kS1oc+c5898QENxx3kCHD9EPHgTkTxaikyPDRAPi6xujHrW8t1iir4AMMv73jnAJbwwGe4pSmCY/+U7UuFu1Q0ZDp+RfCfp+v33zpJA1CLtwWcV4FKBZwtH+3RSy/iQdLIGycrMZKKOksCFHUf/iYC1ZhFXBUmhL9Wu26JaZ5xGUdWRDoM/swzaAyTWX1NbzrWHQ84q7pDjN+Gqruhb1HvkAh6ombMjME6id9/eFeUT3jJNyjurp5STjnMqHvOVR46ltJq/WemzOXGrDn04XS/rgo0QWxh31ILTRnpRtUQygyASI/wTD6nyBhbDFsIxL318HNxSZDTNykMjKspWcY0cNCswE9G28nzJUF3vjqizqKObZLFL4TG9lmAY5NHcNjkVmFaNEcTUs0aLjWmFy/6VYOupv2mAhY6bkfvnj8Hduxh
 rqUA+oZK
 kd4UWnD7nZSi6tYbnTM9vIx1QE3322Swhy8aWquUzLCOMDGMhTCG89wmJsVxDRbeG1BSdaICWCFTHU/1JKbw2cwgI/OjtcZCYo/DUGHwFoO1nCeFWo93KOltWbxzru9wB4S2BrB2/C7PxH1aWllUhcsvWE5KmsiUfkvzx/w2ln+ppLb17DcJxx/TiyNLk7jUa3immgplrhVL9aw8YB3gQ4SLtciT9x/Rnc/lBunaaPAP541nXLvJrHaiqYwsiH66uKAPYT6kEf0LpyQxmFgqLu9cXvceB4PmZP428Ecibhm9hk8W+ac9VOfcowCXJObAYDTPE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/24 16:17, Mike Rapoport wrote:
> Hi Lance,
> 
> On Mon, Aug 24, 2026 at 03:11:26PM +0800, Lance Yang wrote:
>>
>> On Sun, Aug 23, 2026 at 03:17:43PM +0300, Mike Rapoport (Microsoft) wrote:
>> [...]
>>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>>> index 83587d34b189..193f6e65d875 100644
>>> --- a/mm/userfaultfd.c
>>> +++ b/mm/userfaultfd.c
>>> @@ -50,10 +50,10 @@ struct mfill_state {
>>> 	pmd_t *pmd;
>>> };
>>>
>>> -static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>>> +static bool anon_can_userfault(struct vm_area_struct *vma, unsigned int mode)
>>> {
>>> 	/* anonymous memory does not support MINOR mode */
>>> -	if (vm_flags & VM_UFFD_MINOR)
>>> +	if (mode & UFFD_MODE_MINOR)
>>> 		return false;
>>> 	return true;
>>> }
>>> @@ -462,7 +462,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>>> }
>>>
>>> #define MFILL_RETRY_STATE_VMA_FLAGS \
>>> -	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
>>> +	append_vma_flags(VMA_UFFD, VMA_SHARED_BIT)
>>
>> Looks like this drops registration mode from the retry snapshot. Assume a
>> shared shmem VMA is registered for MISSING and COPY reaches
>> mfill_copy_folio_retry(). While locks are dropped, the same userfaultfd|
>> can re-register the range for MINOR. VMA_UFFD, VM_SHARED, ops, file and
>> pgoff all stay unchanged, so the old COPY can continue instead of
>> returning -EAGAIN ... no?
> 
> Good catch, thanks!

Cheers!

>   
>> Maybe something like this?
> 
> I prefer to add mode to the retry_state:
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 193f6e65d875..a0377f7ecc69 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -471,6 +471,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>    */
>   struct mfill_retry_state {
>   	const struct vm_uffd_ops *ops;
> +	unsigned long mode;
>   	struct file *file;
>   	vma_flags_t flags;
>   	pgoff_t pgoff;
> @@ -482,6 +483,7 @@ static void mfill_retry_state_save(struct mfill_retry_state *s,
>   	s->flags = vma_flags_and_mask(&vma->flags, MFILL_RETRY_STATE_VMA_FLAGS);
>   	s->ops = vma_uffd_ops(vma);
>   	s->pgoff = vma_start_pgoff(vma);
> +	s->mode = uffd_mode(vma);
>   
>   	if (vma->vm_file)
>   		s->file = get_file(vma->vm_file);
> @@ -493,8 +495,9 @@ static bool mfill_retry_state_changed(struct mfill_retry_state *state,
>   	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
>   					       MFILL_RETRY_STATE_VMA_FLAGS);
>   
> -	/* Have any UFFD flags (missing, WP, minor) changed? */
> -	if (!vma_flags_same_pair(&state->flags, &flags))
> +	/* UFFD registration mode or VMA sharing changed */
> +	if (!vma_flags_same_pair(&state->flags, &flags) ||
> +	    s->mode != uffd_mode(vma))

I assume you meant

s/s->mode/state->mode/

With that, LGTM :)

>   		return true;
>   
>   	/* VMA type or effective uffd_ops changed while the lock was dropped */
>   
>> Cheers, Lance
>

Cheers, Lance

