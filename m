Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56325606A338
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSS+QgSD
Received: by kanga.kvack.org (Postfix)
	id 7DBB66B05B6; Tue, 17 Nov 2026 04:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C756B05B7; Tue, 17 Nov 2026 04:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B4F6B05B8; Tue, 17 Nov 2026 04:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 431D06B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:55:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C701A1203A2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:55:20 +0000 (UTC)
X-FDA: 85444153200.21.237100E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16F5180002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:55:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSS+QgSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMyC1okRsySQAgoBesJDfyI8sBJ6WUZdUoOx84UiPvI=;
	b=C6bWEXuhlDwlAvKlKzlX12Tx6DCK5G3AMLkfw+Djf69SGWg6cUsd0+25HgvsRRmkXEcQpl
	ELlr+5Kp4PpC3quTaczq1kdctah+xc613hnDqmXz9wj/8o82WtynSqrG7S8NcCnLr5QKV/
	sBRd0GzQsQ+rX7P1Q9zMPfmy/UxdreM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909319;
	b=JwZpnH6XIKA83SNrpxNszrVP5MXE2tku8b3y5S6NKGja6zUPp0ZgV6ZXn47SlFlHxxrDBK
	wGk7IDHK9wq0dnHW80rGHFPJUq2X06ItGXm+dgAzp+aJp1WDhhYIebmFU68KQtsPYFJDF4
	uIHSrPXEyrW4JtOmZqNM3bSAKb6xQMg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSS+QgSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9703E60D37;
	Tue, 17 Nov 2026 09:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363781F000C4;
	Tue, 17 Nov 2026 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909318;
	bh=DMyC1okRsySQAgoBesJDfyI8sBJ6WUZdUoOx84UiPvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kSS+QgSDcTUl16LXaAccAGAtSJWS8GLOIOkgE2Y0+d6R9641Soo6Xl21m9f/jCW1k
	 3LYpbiG0JVOPzz4VL3kFi12qz0OwAzqZSmiycveqnqcJaMVafYVzaTeaC/B6nIIenm
	 yE9lS9dgTHpwbWMBXNQHYFBh/c9LLc9DOU+dzjHqZb8pN9wFJkTQg6/AMNFzfqZ8k1
	 k2M+f93TRRuhjI1IeVSqi0f6Sd3sGHcWUhCkK06wXQ2J5/vFLDlNihYvvcEedrKyJC
	 3ZK1uBspRA1nP76uzjEdkH0gZbch/6zJkQC6PaqtirJqnWjiMQ9pyZtJ4l9DKLJuvl
	 ygHXpMG83BV3Q==
Message-ID: <91aadb5b-53a7-41eb-a0fa-4fce804a35e6@kernel.org>
Date: Tue, 17 Nov 2026 10:55:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-1-4397a0196479@columbia.edu>
 <cc865bc8-b96f-4385-97b1-976de4465ca1@kernel.org>
 <eba4fb71-6baa-455f-8899-87567af898aa@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <eba4fb71-6baa-455f-8899-87567af898aa@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16F5180002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: gh5p1bpdaw5qpffq1u11n9gwb9uud7uh
X-Rspam-User: 
X-HE-Tag: 1794909318-879537
X-HE-Meta: U2FsdGVkX1/WHceKVUNXHYDKQES9wPHp9dB1uwQY4nB0AyJDDCzD+M443gC5Oo8cIQXP+XCKGOAuAyJWWpPziyIOjl24kWIVo1yg8jIzr3ZF2/2NVjd9+9BbkzkFmh5js5w3B0SkWTOfEUJeQvezQONgl6snbxw7E7GAsEsisOH8py2f+U09z6+gZt3fwHMifKTcHmyPrcB+sS1KPKZNVYjT9yLhAzaaVMn6JOwapsWb5eN78DjRd5S5vDCAKQqdJmKkXA7OmpluNGt7/wQ6WzyRvQNFvBOEn8uVRpv8tuAw54MnnghiRCjRFxrjRwKYxcfFQnpaHAbshpt5EYkK6pOyfLfowqFDO71xuwgqRQW50+9AL7eptxs7kthdo6LwK8B6aJ5wWghVk3HFLedaMFIhMd4DPSnn3IUNdtSYsOx0GLNgbmQXhgVIQXtTYQ7NlAStmnvh2hRBUN/OYE+a1ZKFuj1vuKvQVN9PQNsPey8yrPkmZJ3MI+Ep54ql/pHJWMgfe47qidajqhRHHI6GC/Q0fLyKuIo9pAKf4ppc0qKAa81v6Kl2DHWnI5Z2lUETCZaGaooxrBZngC1F5XgH3wJfdzb1vzG3xYCqlpi2k+3DaFi64AY1fum04phEzua8iz7V3ROGdKUctlh5lxsGvix1cu6B0IV/MVlnGCmivYcf1nL/3cntvrNp6dPa0wu3kr6vrw39JEIYLdzMpwuIB22KUU/5pH6hgdvptUmHXdyl/4MHGY+quwpCDB4IjcBiBo7yToqdezeDcfzneHhNitJQWP9GqLc9VVUMExPBNg0jjThAFFD8zfSPDVJYkD6K/ExX15/reAyw+RRToWIEcAPOc/9A5vIER0ii0seT1kKl0pYZyBHPNwwlb/ZRgjRF8d09mlJ2e+RF8vkiwZUC7k2z0NWUpeVkqhRAFahDb4k6PBztE4H7QBevwle6hNyBX7G/7/VQ2jbFulQvSHF
 XOdLqpcg
 fWOpzE3aXijm8RQOApbcwI9yKQGtIHSkZ5N9Ej+afvvmoaAMZBERdUB5ru1pMvGIFeZWBImqYsgfXezdGJogUNh5nxnUkKXYmh1ypF4Qqu1C2Sc7UDdUNUDJ3CaMpxyje8TdhrtWniefopBZ5o11CnlV5Qyo8lbHvD+vgW2CfXSD804TQXSI4C7IQCf8RaBhQeKzMnLpFWnkLQqObJIPFOqSszrNPWfWxjD4jRc0Wi3DLlPl4W9HgkVSN3Lu9zumn1gQ8TnDRfQJ1+bxTdtooZYktlz+EI/zg9UxsY40om/DRpCg3d72EgC8WWrwN64O2Md2sIE0jYV+37+zQ5mma3Lbkd4pqnOvUKzVamoYOfeU2FK563JEprUFPj1+bEk96NxmoBuwnvbh6o8a4tZ/cHh4t6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 23:27, Tal Zussman wrote:
> On 11/16/26 3:16 PM, David Hildenbrand (Arm) wrote:
>> On 11/16/26 21:02, Tal Zussman wrote:
>>> If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
>>> mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
>>> installs it through vma_uffd_ops(), no matter what kind of mapping it
>>> is. An s390 KVM guest with storage keys or protected virtualization is
>>> such an mm.
>>>
>>> For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
>>> cache of the file. That is wrong: a private mapping must never modify
>>> the file it maps, and the file might even be mapped from a read-only fd.
>>>
>>> The ioctl can also fail where it should succeed. A missing fault is only
>>> delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
>>> an address that did not fault, or can race with a write to the file. If
>>> the file has a page at that offset by then, inserting the zeroed folio
>>> fails and the ioctl returns -EEXIST although nothing is mapped at the
>>> destination address.
>>>
>>> What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
>>> shared zero page can be used, and what UFFDIO_COPY does: only check that
>>> nothing is mapped at the destination address, map zeroed memory there,
>>> and leave the page cache alone. The zeroed folio path did that before it
>>> was moved to vm_uffd_ops.
>>>
>>> To fix it, pick the ops in the common folio path, as
>>> mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
>>> mapping, the ops of the VMA otherwise. That makes
>>> mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
>>> so remove them and rename __mfill_atomic_pte() to
>>> mfill_atomic_pte_folio().
>>>
>>> UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
>>> if something is already mapped at the destination address.
>>>
>>> Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
>>> Cc: stable@vger.kernel.org
>>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>  mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
>>>  1 file changed, 16 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>>> index d65184d9a480..61a712e1f9f5 100644
>>> --- a/mm/userfaultfd.c
>>> +++ b/mm/userfaultfd.c
>>> @@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
>>>  	return 0;
>>>  }
>>>  
>>> -static int __mfill_atomic_pte(struct mfill_state *state,
>>> -			      const struct vm_uffd_ops *ops)
>>> +static int mfill_atomic_pte_folio(struct mfill_state *state)
>>>  {
>>> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>>>  	unsigned long dst_addr = state->dst_addr;
>>>  	unsigned long src_addr = state->src_addr;
>>>  	uffd_flags_t flags = state->flags;
>>>  	struct folio *folio;
>>>  	int ret;
>>>  
>>> +	/*
>>> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
>>> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
>>> +	 * COW it right away. The result generates plain anonymous memory.
>>> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
>>> +	 * generate anonymous memory directly without actually filling the
>>> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
>>> +	 * the pagetable (to verify it's still none) and not in the page cache.
>>> +	 */
>>> +	if (!(state->vma->vm_flags & VM_SHARED))
>>> +		ops = &anon_uffd_ops;
>>
>> Oh, but one comment: why not check for actual cow mappings?
>>
>> 	vma_is_cow_mapping()
>>
>> is your friend :)
>>
> 
> Probably because I didn't know about it :)
> 
> This is already equivalent since uffd registration rejects VMAs without
> VM_MAYWRITE, but I can switch it over for consistency.

Yes please. We need to convert all of that code to not check fiddly VMA flags.

Cow mapping in uffd -> anon folios only.

-- 
Cheers,

David

