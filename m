Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A3A606EE98
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P8eSBm/K
Received: by kanga.kvack.org (Postfix)
	id C3D246B05B5; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A436B05B9; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3186B05BA; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7599E6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4A4F140438
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:18 +0000 (UTC)
X-FDA: 85394367996.12.DEEFF19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 277F6120007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P8eSBm/K";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOeAF7zrez0dA+PfpQRsoWo1e2/ne6IcmzZghMH3uaI=;
	b=76SVOqgAwKEisS4AV20wTAB7lRLujkGyeHrE8I8V5SDok9uOxIqXirSp8nnpxg7d2viTR/
	WfXaNJLxiZLq13iYV7hEqPYOGMjaS0QrVThpPOX/0sv8ncFhOxkYuArVXgOK90y+qIg3OI
	GQdPjkamWLtq8p7A+vPzwuletynaaZA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P8eSBm/K";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723957;
	b=8GLqgtGisrJIDNmbUhk+9w8jxf9iDhPraEhW0VSE5eZ7BfXqu/bfXI2QltA1CItNUne/gb
	S0VK2blx1t7+Wb37e45hGloS4cSVQDd3lanWd4lb/ddqkPYW5A/4GXOkCdEniHm/eFZe8O
	iSB9RARhLxCc8WXvzLUhWpsoaY/n7po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC0F36061B;
	Tue,  3 Nov 2026 16:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC0A1F0180B;
	Tue,  3 Nov 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723956;
	bh=oOeAF7zrez0dA+PfpQRsoWo1e2/ne6IcmzZghMH3uaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P8eSBm/KAlvILUpoZoVOd0CoXftAwZ9fk4ko28hs3TdZrK8dtWe5uXMtXJjhF/VpK
	 +/xC76T7FowId6/+T5kDukq1LLB9sQfAQm7pNnr3otaZ9WCk/FycgLI18ntOhmYPvu
	 3WdyEufphqmlreAYm3r2gejvYZwuMG9VeUP9ifrHxmE/YNmfoRc3yRrRPcHV5O74aC
	 IbmTRiWESWGN/CAlu7LBwffNk3wr5aaYl7o+zEamN3AkhuARLulpM3/GipgeBunxqe
	 twQQaqr9OIQI2Zyn5TBHTYiP6X2crPp6cX0nuksxRdtMYu7noZm2Dp5PNIvQnmuxHB
	 0a95Py6oc+1Ww==
Message-ID: <856ed0da-d806-4f2e-95e7-f276f2408e8d@kernel.org>
Date: Tue, 3 Nov 2026 17:39:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/gup: break out gup_fill_pages() helper
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-2-riel@surriel.com>
 <df9c504e-e62a-40c0-a513-e8b8c758dd57@kernel.org>
 <3a7d12b52a5de61277842f2cca0dd90d42728135.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3a7d12b52a5de61277842f2cca0dd90d42728135.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g1go4gq8b4744xx7cmcdm7ytbuan5g4u
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 277F6120007
X-HE-Tag: 1793723957-131631
X-HE-Meta: U2FsdGVkX18G84m6zK1pMhSnGEuB6IEcCscTnNXKQqixmrCV4nTeThbZ8rmyebEDceUYWX0xP7FGsDOI3eet5xidIH1oVUhzs3jLj/3it76vhXUsvl4Yr17rCsE0LNAiACNh91/eQKF8U/l3yyWIr3SYxuC1CRfvvmXW+Mfuhik3rNmkekhJhJJ7LR6rr/ru9wmbP3MMZNtBicp9dgJT1b9UNJVIxoLfisvOD0bFm214wUda64hxYiluM1bjO2zdVkwtz+ldnns06uFxEOfu1z9adTDjH7R00cdB5+kB6/2Ah/H1IVxTul6GjmAy1aKsu31SkvV5Z1Zk58n6dezxGmbX4PVeJGM1zD5vd2EgIz/M8CCcxj3UredS4FOJTqGqzJpbmL5z7Uq+bJO72PygYPYgR6Cnsqqo+9Ien5lgjBm7iqfgRijAv7scP+GLZSUtxcCBigG/NXRQ6l5xc4sA4sxoozBGRXySwxIrwIt4o0oNiV/RdsG9FwdXy1eOJVXaJsVtKW/X5APn0i532XoNldTeAjqUFaiNRn9PmsCfZWruAKzfP/gT+Vl6bxjMM8oB2ibQTBWFlid+eC/DUfi291RWFa0agcv7Z/OQmJfxNJbttikDTqEw5bR6wgjk6qqxRUy6Wot9vzLJY2BBvjgKptga6fgaHF/FJahj7SnIblq1K5m8ZE6FvqfDzCIxRf+ycWxiUGMHN9FICZmxAIBw/tr9RTpIWXUfHJOH/nMFAehV+V638jifm1eMXYAct+yTJR1SL8MTMnSq0QxkkqkRBHJNXHEbC+dqqFxa8/Go89ydQjPviH/GvbNCBqaMbaoyUdzMeKfhZR2+nvZmBfiZIGwXiLQWiFodsl1e3bHHhPdGZOvnTRFuZNSkm0NNn/DcAofHEeq2UN0Sk6npFMzkWOX00iFZa741t33WNED3fyQxKlGm+DPZp9FnngbT7lEBXR7D5Xp9DHruehEz1Iz
 Kr6iahMC
 jfjbjOsqzgJKgy1RfZXf39KwwnRwsPShi3A9aitbQ6lU6lcs3DqccAWhERBtn3JgPQyio1PIUwwLa7R4SZfZjEbQHUUqpwU7RCyVQ3w52QYPQlle0/ULdjuKUdTE1ZEGzhUjBjRLq5Q+IGbbYpgd+XNCEMp37lWKgSzhD+eN8YBn0zpw6xgCdDHToETR+l/k3UmHsdxveCaWMQhrsC1IvwmuRqiH9zLUJBKkh785ST9xGl9iUh8fFdke1lilCvE8nrfKHk0ab/CL79c5l7FjgnOPvXkhbyZiJNxA2RVrVh5nPdvy++7P5vwxbXI0Hx5wNsLQwnokloB6MQqIZrBulfQBT4Ycfc223y5afXMsq/tls7r6cP3xfResyRnUgltR9oxoxFBpCUP+jYcW5viBoKMDVusQ7iXho6Mt3kSPG3UORHVZgKKIMMrr3rwn8pp/kdYCTl9oAhvhfmzKVYD0UexPRFKfcpRoKoL9EO/IdJ/xdwvDeCeYDN25ZGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 17:29, Rik van Riel wrote:
> On Tue, 2026-11-03 at 09:43 +0100, David Hildenbrand (Arm) wrote:
>> On 11/2/26 20:30, Rik van Riel wrote:
>>> __get_user_pages() fills pages[] and flushes each page's caches in
>>> an
>>> open-coded loop.
>>>
>>> Move it into a gup_fill_pages() helper, which the
>>> follow_page_mask()
>>> call chain can then use to fill its own pages[] slots.
>>>
>>> No functional changes intended.
>>>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Rik van Riel <riel@surriel.com>
>>> ---
>>>  mm/gup.c | 27 ++++++++++++++++++---------
>>>  1 file changed, 18 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 7d43ce717b246..cdbe2ed3e6442 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -633,6 +633,23 @@ static struct page *no_page_table(struct
>>> vm_area_struct *vma,
>>>  	return NULL;
>>>  }
>>>  
>>> +static void gup_fill_pages(struct vm_area_struct *vma, unsigned
>>> long address,
>>> +		struct page *page, unsigned long nr, struct page
>>> **pages)
>>
>> unsigned long nr_pages ?
> 
> Will do. Thank you.
>>
>>
>>> +{
>>> +	unsigned long i;
>>> +
>>> +	if (!pages)
>>> +		return;
>>
>> Why is that check needed? Why should someone try filling something
>> that doesn't
>> exist?
> 
> faultin_page_range() and populate_vma_page_range
> both call the GUP code with a NULL pages pointer.

That's not what I meant. I know that we have GUP users without
pages array.

In the code change you are performing the check is not required.

That's why there wasn't one in the first place.

> 
>>
>>> +
>>> +	for (i = 0; i < nr; i++) {
>>> +		struct page *subpage = page + i;
>>
>> There is no such thing as a subpage as Willy keeps saying :)
>>
>> Why not reuse "page" ?
>>
>> 	for (i = 0; i < nr; i++, page++) {
> 
> Will do.
> 
>>
>>> +
>>> +		pages[i] = subpage;
>>> +		flush_anon_page(vma, subpage, address + i *
>>> PAGE_SIZE);
>>> +		flush_dcache_page(subpage);
>>
>> Now I wonder why GUP-fast doesn't need any of that. Likely because
>> architectures
>> that support GUP-fast don't need any such magic.
> 
> These cache flushes seem to be common on architectures
> with virtually indexed caches, where the cache needs 
> to be flushed if the memory is accessed through a 
> different virtual address than where userspace might
> have written data.
> 
> On 32 bit ARM, MIPS, and sh, the kernel seems to
> implement an actual cache flush here, but also
> claims to support GUP-fast.
> 
> I don't understand how that would possibly be safe,
> since the pages returned by GUP-fast could be
> accessed under a different cache alias than where
> userspace accesses the memory.

Right. What a mess. Once again :)

> 
> I think one reason GUP-fast can get away without
> a dcache flush is that most of the callers take
> care of that, for example by using raw_copy_to_user()
> to copy data using the user's virtual address, which
> takes care of VIVT cache aliasing.
> 
> Likewise, drivers that do zero-copy DMA into user
> memory will get the cache flushed on VIVT architectures
> inside dma_unmap().
> 
> The dcache flush inside GUP covers rarer cases, where
> the kernel accesses memory at a different address than
> where userspace wrote to that memory.
> 
>  cat /proc/<pid>/cmdline              KERNEL
>  ----                                 -------------------
>  read(buf=U)
>    -------------------------------->
>                                       get_mm_cmdline(mm, U):
>                                         access_remote_vm(mm, arg_start,
>                                           kbuf, len, FOLL_ANON):
>                                           get_user_page_vma_remote()
>                                           (slow GUP + its flushes)
>                                           kmap_local_folio(P)
>                                           memcpy(kbuf <- K)   // read
>                                           kunmap_local(K)
>                                         copy_to_user(U, kbuf) // write
>                                           through U itself
>  read buf at U
>    ------>
>             clean: the final write to U went
>             through U. Same line. No hazard.
> 
> In this case, the dcache flush in slow GUP ensures
> that data written before the GUP is visible to the
> reader.
> 
> In the write path, e.g. for PTRACE_POKE, __access_remote_vm
> flushes after the write has been done, so the other
> process will see the data on the next read.
> 
> It looks like process_vm_writev() might be missing that
> cache flush after a write, though.

:(

> 
> However, now we have a situation where:
> 1) Only a few oddball callers of GUP need the dcache flush, and
> 2) Those need to do their OWN flush after a write, and
> 3) The dcache flush is not needed for most other GUP callers.
> 
> We could do two different things here to solve the
> asymmetry.
> 
> Either we could add dcache flushing to 
> unpin_user_pages_dirty_lock(), and make sure all
> the callers that need to call that function, or
> we could move the cache flushing to the GUP callers.
> 
> Then we have KSM, which uses GUP, and which would like
> to see the latest page contents...

It's all very inconsistent. And undocumented. And error prone.

Could we have GUP-fast also flush the dcache for consistency or
must that only be called with the PT lock held?


> 
>>
>> Maybe we should in fact base this on the gup-fast batching series and
>> also use
>> the helper in there (passing vma=NULL)?
> 
> I just moved this code out of __get_user_pages(),
> but if we can get rid of it completely by using
> a different helper, all the better.
> 
> Which GUP-fast batching series are you talking
> about, here?
> 
> In Yeoreum Yun's series, the batch filling seems 
> to be done inline in gup_fast_pte_range(), and not
> in a helper:
> 
> https://lore.kernel.org/all/20261102-refactor_gup_fast-v2-4-bc1ac018c834@arm.com/
> 
> Should both paths be using the same gup_fill_pages()
> helper?

We also have gup_fast_pmd_leaf that fills an array. I think all of these should
just use a helper (instead of manually looping).

For now we can distinguish gup vs. gup-fast using the VMA argument.

-- 
Cheers,

David

