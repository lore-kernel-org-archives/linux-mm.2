Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFB9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FF16B008C; Thu,  9 Jul 2026 09:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258436B0092; Thu,  9 Jul 2026 09:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E736B0093; Thu,  9 Jul 2026 09:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7C3D6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:43:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FA4514017B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:43:58 +0000 (UTC)
X-FDA: 84969356556.09.0B375B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A0FE940007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:43:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opk4Zayp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783604636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOhwLdFtYZrbNxPNuQ1ybZBGzEAMmXkIAYF778B+TdM=;
	b=yJAABCcZRJ0IvDvVZyRD/246udLw8jTNQ4fT9w8JRxamt5+gpdHNEB9VyZdGNkOD+NH23r
	xmqro8KyCHGaEY+h3W2u7XslEUtqHqIY+W4zy2X6zbN/TWlAbDx1AkGO12q6YtW1aOA2F4
	YL5STUOazq6TYXjORM2D8jA5oa5XQpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783604636;
	b=q+edIR4hcaxEJ9YlhkRWOgX5ltsV6n/qr7TAsohICAibKh4o7P2hHeAmcbqE391Q/zb69R
	JEX1V9g/qtokBxJrbMlRfjcCDiYnySUlWQxlXdExf6CfEo+52mf15Huw7Api3wyF9THMnF
	iEYm6jPvrxrb/JexNFtkBuR1iRsRq9A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opk4Zayp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2376412E8;
	Thu,  9 Jul 2026 13:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4C61F000E9;
	Thu,  9 Jul 2026 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783604635;
	bh=XOhwLdFtYZrbNxPNuQ1ybZBGzEAMmXkIAYF778B+TdM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=opk4ZaypYNn9jx52A8N60MT57hnfGw1hnMsgqYVIxo1XlOTLoHdMx5fcV9lUue9qC
	 HdocdJgxmzULWj+0Uw7XO2vy2aUZWsYZfum38cUa3IqMvxnJqO994JxLeLsIk8NuWw
	 d5FeERIIjC35baqIcyWRyEeiSK0xa+4Uq+58SI3PYt/2e9JFsNBCTZdvzJw3fljnqy
	 StlMEuC0DJlX0Hvj/gdmflHpR6htmgduIwSyZc3/FiFGpRMITW17KLAvBIYG+esxfd
	 HfLXocmEUvk7edI3KedeCSkISrf+7FDEH9BOLWmaTm0VwHZP+PKF9IfvffAzaXWWjY
	 20TDkN4pCdccw==
Message-ID: <1d6732f3-af7f-4487-b704-626d5bc52843@kernel.org>
Date: Thu, 9 Jul 2026 15:43:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/rmap: refactor some code around lazyfree folio
 unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-4-dev.jain@arm.com>
 <22fb2f54-da23-40b2-91f5-aeaf54037bcd@kernel.org>
 <61fb2165-bc58-4c54-84b2-4ada10b19bcf@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <61fb2165-bc58-4c54-84b2-4ada10b19bcf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A0FE940007
X-Stat-Signature: pwajcits1dtqcy5i3k3jws8kdmfwxkyp
X-HE-Tag: 1783604636-506496
X-HE-Meta: U2FsdGVkX19qZj3p3YokVChJewRloPmxlVyB1QeFJTN4iXglhND9z3vrlhEhv7mNUx1l0IfVMLsMD7bR+8b8/VZZAwkhVqcDmM0CuyoSqpEV/lqRGE4i6TH9Cs9mzZVjcDHNYEDA/tVKxKuQc0YztP8EAgogFRbFhcUgiMtH7CPlbMIDISqKeNPd3GmyF41iJraOQWVUvHaXBUNLN9nn5h52Q5dbiAOriSOl0Ree4F239dm2kp1QbKSZM09cCj9MTP0t4qG4hzMDPPtAJmIM/U/SJQKbRh1RmdpQ7Gsj8yY7RtYB96x/81RiOm502SspSar/JhNIz05evALJTyFdhx4ElS6YOcce/HwVUtgbWyfIo8pRagNopxwk3qVqYK0oLYK/PnHnCTtnifkIs7lzwlzWhD34YOhKCv+EBG6D95cbd61t+rh3TmwCBb+wmAv8YsjSrekicE0uy2el16mcckwJlqHxMrzPzB5ycZ1UDAZP/w9BCDi5mhGYx/pXcUr6Fi0emteviQbhsJu4VtDhQJoubbfMnsaexuQLXThoug15O9U+BXxYpx7Ti0pjcS+n+HHLw9pB+nqabWFbdh4HyoQnUlbViEXVZCD2usu3/EwnDfyb7fJa9Dh4xvKh+M54wNntCP3EImApXkvhPWqB2xAbWFcE1GZCmAp9uFAoNT18s6vsW2tH0Nex8sp1NYwjuYy3Vwn13i6G6CrNR088BYNTNelPVVucuCC2lxW8TdOmgJoXyO9qiRCHMTnVAd3lgnyHcqHOkPs/bv4R2ajjoZU9ncjUSBqVvtbF5hqaRz3CzIo/23VQhQDmyGtR++k6aWLMD7JXDm/1k+KmgS/xtHHVnJ5jQZ7nitbHn99/cTQ8k1v6upixcOkT4JHG4q/99CjgKt61S7tPezb/ymzB53KFJRU98Iayz4OPIdD/jQq0NcmgixztfklUggtW4EobiRCxwOtVNnz4DhSdUY5
 GFwYmWJG
 6AJmheJS+RnGVMzYb6Xp7GSN/qbGEXCaxg6krFhVmrMRZnvfe075+QDNoK7EG94YjPzrAxBr2WWg+ZbWJy8N1vuhiQv2Pd3p2PWpUOWLQUkLN0CP4fKIEcz3dEeY014fo+NHDyUq/U5/LQQPErO4Cubyp3jXc8WJKvgfsSpjfnNg2gPPXWufKQIjzc2P+3gCKwmjcsLskNwD2j9t8e07QDFwRuDPObGm2pUKlEbsnrnxIQdP1n9IUae6N8SAErlmaYUq/tExvso/ZVbKzZX+DpyyoVoiqX/9Cj867boDSLMlaElTju2FKd6z3zv9VkA+yI0A5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 14:16, Dev Jain wrote:
> 
> 
> On 07/07/26 7:48 pm, David Hildenbrand (Arm) wrote:
>> On 7/7/26 14:11, Dev Jain wrote:
>>> For lazyfree folio unmapping, after clearing the ptes we must abort the
>>> operation if the folio got dirtied or it has unexpected references.
>>>
>>> Refactor this logic into a function which will return whether we need
>>> to abort or not.
>>>
>>> If we abort, we restore the ptes and bail out of try_to_unmap_one.
>>> Otherwise adjust the rss stats of the mm and jump to a label.
>>>
>>> Also rename that label from "discard" to "finish_unmap"; the former
>>> is appropriate in the lazyfree context, but the code following the label
>>> is executed for other successful unmap code paths too, so 'discard' does
>>> not sound correct for them.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 87 +++++++++++++++++++++++++++++++------------------------
>>>  1 file changed, 49 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 934773dfa2f2a..00b571c2a1bab 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2067,6 +2067,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>>>  	return ret;
>>>  }
>>>  
>>> +static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
>>> +		struct folio *folio)
>>> +{
>>> +	int ref_count, map_count;
>>> +
>>> +	/*
>>> +	 * Synchronize with gup_pte_range():
>>> +	 * - clear PTE; barrier; read refcount
>>> +	 * - inc refcount; barrier; read PTE
>>> +	 */
>>> +	smp_mb();
>>> +
>>> +	ref_count = folio_ref_count(folio);
>>> +	map_count = folio_mapcount(folio);
>>> +
>>> +	/*
>>> +	 * Order reads for page refcount and dirty flag
>>> +	 * (see comments in __remove_mapping()).
>>> +	 */
>>> +	smp_rmb();
>>> +
>>> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
>>> +		/*
>>> +		 * redirtied either using the page table or a previously
>>> +		 * obtained GUP reference.
>>> +		 */
>>> +		folio_set_swapbacked(folio);
>>> +		return false;
>>> +	}
>>> +
>>> +	if (ref_count != 1 + map_count) {
>>> +		/*
>>> +		 * Additional reference. Could be a GUP reference or any
>>> +		 * speculative reference. GUP users must mark the folio
>>> +		 * dirty if there was a modification. This folio cannot be
>>> +		 * reclaimed right now either way, so act just like nothing
>>> +		 * happened.
>>> +		 * We'll come back here later and detect if the folio was
>>> +		 * dirtied when the additional reference is gone.
>>> +		 */
>>> +		return false;
>>> +	}
>>> +
>>> +	return true;
>>
>> You could simply do
>>
>>
>> /*
>>  * Additional references could be due to GUP or from a speculative
>>  * lookup. ...
> 
> Are you also suggesting to shorten the comment?


To reduce its indentation and then comment on the conditional

"Additional references could be due to GUP or from a speculative .."

Instead of "Additional reference."


-- 
Cheers,

David

