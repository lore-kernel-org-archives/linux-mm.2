Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451EE606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2plYUDt
Received: by kanga.kvack.org (Postfix)
	id 40EAA6B05C5; Mon, 16 Nov 2026 15:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF646B05C6; Mon, 16 Nov 2026 15:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE146B05C7; Mon, 16 Nov 2026 15:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09B4F6B05C5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DA9D140196
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:06:33 +0000 (UTC)
X-FDA: 85442064666.08.77A53EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C04FDC0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:06:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2plYUDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8UnW/+ryATRWv2jbp1Jmeefb/aGbvl2dgmvZUGeG9w=;
	b=IrTYNZ2Cr7J+8kAX1sEy4WzVfFg7WP2d/2pbXcWjQD53rXFyor3XS0P0KOeLC8btIpRbco
	5KJZeuXmArClLEi+gSCr++TzAeI5FiJXNuOI4+9AQhYJpZCDQiCaGWcCWdEfOHs9rUJPfG
	ME9KqfJmDGlXD7yLuHRJDFgtbvRPSc0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2plYUDt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859591;
	b=e6A9wfbQPmWwK0sgfwWYl6LdNn3HMk1ENFc5UKu1sJnxDU6QoEy3TGR44ldKY4R5MjBQjP
	j7QEn1iTCgMVldQ7yTv/5A+6TVc6LGFvn+bjQ10X4RqUr8D52Nzq4FFp7dwmmnGlluf3j4
	ySNgtu66nPr9KIVTB2dnw0+BNQKXFM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA86B4332A;
	Mon, 16 Nov 2026 20:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C6C1F000C4;
	Mon, 16 Nov 2026 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859590;
	bh=X8UnW/+ryATRWv2jbp1Jmeefb/aGbvl2dgmvZUGeG9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T2plYUDtEMo5l8QnCju2iEMh29uWpUA4vTKV28s7z9pQZZILdhvhTjBmwGioCvaAa
	 c0AbD7dQwL5IDeHcoqLBdQqh/q617GeLKxvTf0rybyfhZ4hHppJryslcR1HwZ6bGOc
	 od2dXVEgk/IRiORWDup8I/9VbyUkFdCUFLbPvoWr3uwsJnbw9jIr3ZpffzgNLeCzhj
	 OpX14fkND2iscwB3DNdBecYGJerEVPi9xqltzZX8aMzc2B3AUib9qtm5liUsaMpllR
	 MQ8kvHrofTXmed6J3Fd0M0BlJyGiZuGjZgV/jPteRmO/pXfa8GFTjsewgmzMRA5Eh4
	 D/5zA8/omXfig==
Message-ID: <61d4f3ee-7a0b-4a8b-b5a2-35380dd46b4c@kernel.org>
Date: Mon, 16 Nov 2026 21:06:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
 stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
 <dccf94b3-b901-4311-a233-488c87195dc5@kernel.org> <avs1rOJQ1gV33z8w@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avs1rOJQ1gV33z8w@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C04FDC0008
X-Stat-Signature: iwik5xg6u3ycgkcjr1hutpnto615nhw7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794859591-183277
X-HE-Meta: U2FsdGVkX1+CjhgCpGoXG8KX8nzAtVQyREBnByChM5gHL6MyjuToELED/cfYkrQVRy4o0k994KlqaZeYM9wgFJXN5U2lfKFuPMnE/YakVmJRzHnUuI+u0xYViOg6JNwIFYYnzp8Plkm9KFmLdVKcvQURWmU5LCRW4oSdM4vk08arp1YSvccRJgETYPCVocW4IryxT6BsMChoHp2nKqFj/tKDbNv3kx+ClQ9Qu8A+TCXrTtW0IEJdBJ4f43yJulwvR1LRKXbbaQiNa57Ul+P1Tg1yDQWje/PkMxbkLvtfptFnZUgo7U6Zi23eEFMJTUMTV7JTGUtz9FnDk01DkNaJ2lyqeGmkv4Wm5EEIQyLH2aqEMGGVbxe2JPS8yNLNWz1Rjr9C5GD8S4gVrsn6SvngAqcwKeSK8GIhllDbvJD16KuxgCqcw63tAfG8PpTeLH9sUjzzoDdzkxZLD1sUjfRQbfOcJ9P1bM79nNA68YgD6b8XRuUoE+NLC3x/0L3Ke29Zlo5qvkH65a4OaaLOVg4oYck4ZY9pJkQmmfBCH/Mm+qPXzczCs63KEXfE1vvNlFyGuWbk1TiQVEebIGP3lmCAx5WZhDZIrPA4zU5BxlUBgbBLPuuEtZYBXGq/13bJY6ATbboVAbVKry1Ek7d21PYKCjL8kfyHXU91ho8+bgN7lUxvP2uVxtFnK1Dd6b5ILgMXi107h5+KE1GOaujjSIac1al0AKTXRO5xUULo+T4mgKMCDGikUUbyFmE/a4HXrEKmTVw1jzn4mCk2B+3y548PDRcCq1P2ItmlWfX0l7H489YVbXkaBERFRUUWXxxfD0AkaD3RXnDzVjXaI9aHYW3nQL2r6KLpLzb8oAG0P54n/WFZWQh33kGM1U01zv0bz+u5618zv3YcCzPfN885uEnDSIdh1LEEGzO8+h8DNTZncfxNaMHngSXEyC1vw0aVFlp+BpmUZdTulWEbFZYEb+h
 5KwRmrsW
 tmA6EKiOjmQvBH6OBxZ6yA3KZpzMH0vK0R/U/yYFwmqF3F74LSx9X/BQ+OxJKdlNL6cS1XKK7+Mre+4gdko+fKxb5rZ6r2RiXtZK9UuybdYUP+Sa4rGKV7qzcCzKoifufTPnkyde5m2TyzPcT4R4+dZlc4BaAuFulp7M7Ky56IYP231c0VVS/zUK0ERNNokIINk+mTphLboN1Sc+dCBSmfw+ftI7u3kXBnNcJp0Db9Fv1z28vbFxx3NsCR1uKTDokViO6PFxH8zpGsVoxFARg0YXzJztTj7v6VeUBvd7AwIs2UPbOA+JzOEkhq9G6w8jr6UhxiMUeWXAJEwNdAuuMKQfWi3ihSeCjbUF7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 18:10, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 16, 2026 at 04:56:25PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
>>> From: Eliav Farber <farbere@amazon.com>
>>>
>>> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
>>> so without holding the PMD lock, so the assertion is only valid if nothing
>>> can concurrently install a huge PMD entry in the range.
>>>
>>> This is not the case for a VMA whose driver implements both ->fault and
>>> ->huge_fault and which invokes vmf_insert_pfn() from the former.
>>>
>>> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
>>> takes the mmap write lock and faults taken under the VMA lock are
>>> unaffected by this.
>>>
>>> This can result in two concurrent threads faulting the same thing
>>> disagreeing as to whether to attempt a huge fault and thus ->fault and
>>> ->huge_fault running at the same time and triggering this assertion.
>>>
>>> So just remove the assert.
>>>
>>> Target the commit which introduced the first driver able to do this for the
>>> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
>>> them using its own mapping entry lock.
>>>
>>> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
>>> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Eliav Farber <farbere@amazon.com>
>>> [ ljs: rewrote commit message ]
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  mm/memory.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 3a20d64fd276..e03110906aa8 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
>>>  	if (!pmd)
>>>  		return NULL;
>>>
>>> -	VM_BUG_ON(pmd_trans_huge(*pmd));
>>>  	return pmd;
>>>  }
>>>
>>>
>>
>> Could this also stumble over a huge PUD somehow? Should we just prepare it for
>> any leaves and bail out if we find some?
> 
> No, walk_to_pmd() can only come from the order-0 path right now and
> __handle_mm_fault() makes sure that can't happen in the fault path:

That implies that get_locked_pte() and all insert_pages interfaces can only be
called from that path in __handle_mm_fault().

x86 an s390x use get_locked_pte() for some other paths, so I wouldn't want to
trust on that :)

(did I say that I hate walk_to_pmd and get_locked_pte? But you likely guessed it
at this point lol)

> 
> 	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
> 	if (!vmf.pmd)
> 		return VM_FAULT_OOM;
> 
> 	/* Huge pud page fault raced with pmd_alloc? */
> 	if (pud_trans_unstable(vmf.pud))
> 		goto retry_pud;
> 
> So by the time any ->fault path runs, the PUD is stable.
> 
> We don't have to worry about the mmap paths as at that point nothing has
> faulted in and it's all fresh.
> 
> So it's all safe as things stand.
> 
> But could update for future-proofing like:
> 
> 	/* PUD leaf might have been installed. */
> 	if (pud_trans_unstable(pud))
> 		return NULL;

Yeah, that makes sense. I was just wondering whether we'd actually want to
return a proper error then instead, because this would not be an -ENOMEM case.

-- 
Cheers,

David

