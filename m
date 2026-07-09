Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29CBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0876B0096; Thu,  9 Jul 2026 08:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7866B0098; Thu,  9 Jul 2026 08:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE506B0099; Thu,  9 Jul 2026 08:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 972B56B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:17:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AB36A015A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:17:09 +0000 (UTC)
X-FDA: 84969137778.11.EE9D67A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 30C0380002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:17:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jMU2o2Tk;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783599427;
	b=5l7yN34yH+zo4LKljT4BR0oa3Ea2nhHm2THEJqw7stz6iU6Ot7ohUupBRkk6sYxIhqHRfF
	s4+XHwRp96eis940rSCpjiPKb7eoOoslkDoH+y+fLzYg0nqB6WWqshDhi2TlrvmIveo+Is
	FmOEfh379AGjhp0uP+d4NbKJEhScr4U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jMU2o2Tk;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783599427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl36smgrMnETxwghBi0JtmrVT9P5WrbroFAqzv2+3EM=;
	b=42BE8Uy/TQ0LEqkNYESNpKSQJwJeAKJK+a6tw4BW86ipVIw0mjSzAIC9XGGKFPlB5qQLfn
	L391WOR8OWEHuEgOhXClp9KjS9GJghPNSX+GAwbwB6Nmfc2raeKx0mDN2YWdLuBxLSSPl6
	awrweAmRmY7UnGZh1hzEfu4MmXHYdnY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2ACF339;
	Thu,  9 Jul 2026 05:17:01 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A8143F66F;
	Thu,  9 Jul 2026 05:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783599426; bh=fLJdtvh+XSoFGSp9Q5uKyghD0EL7bK3axeyouwSfots=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jMU2o2Tk7QjHBCX7BIc0yhcZRB9HdkcINy+//dBmeDvcqYIDBGUJsg3Uw/6krqaF6
	 j7vaKkcekKKmzWCKIIXjj9A5/yNYJr17MI6ynWYPdC+elAAIFsXa4la6LVZA783olX
	 9mZyKQbpt6kqwaVx5U1iOp6eAMZx8/JyDtEGstfc=
Message-ID: <61fb2165-bc58-4c54-84b2-4ada10b19bcf@arm.com>
Date: Thu, 9 Jul 2026 17:46:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/rmap: refactor some code around lazyfree folio
 unmapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-4-dev.jain@arm.com>
 <22fb2f54-da23-40b2-91f5-aeaf54037bcd@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <22fb2f54-da23-40b2-91f5-aeaf54037bcd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30C0380002
X-Stat-Signature: w95wic9ekauqu83icjsejmxn96tho7oq
X-HE-Tag: 1783599426-272526
X-HE-Meta: U2FsdGVkX18FDn1VyQ7tG6Gz4990gFsx51u3evyBJU+QHj1rbublIQ9NgyRhgcbyDwPxLwecIDK2sNX34JYNGY/rEnkyTl5JNYnIRFbbxybcfc3zRKbwO/JF8/IWxq94LSQkk/1Rm8nNWglBjR+c8EbVYVSw72ZrZrIsnG1LYHcL69BZXuv0ngIzraVWA+Bmg1baexQkG0nhqlYjO0a23b0xi/9sr6Oc+uggEuD7MRTI+2cPaUj98xK5c+IkLCEBZIGFwOcbSQzyxdWGI8eOvKh8CLTaYEIhQP9ihu2H6Slqn9fFoCiyqEVyIoiiJ8u2v1dje7DpeGFrZ/mxbYdDgpMsXlBy/wBvQQlBmHdPP3RKdJnVLrpYAZRptNXLtTSxJv8eH6GveymUSl26QyLrjzkx//mMOaC/qhR5/uBQrNXTBI1fY9pOW6057IPAYAMXfJEuJonADCdqeICCJsbLG+bi4YV6VIuKDylB75r3LfgqwQRCbZdLCjL0slo/vy80M4bqApvVmR3XbNdlGbzSTwWELw3TOE30IaZo7YYWE9bCab2PRLdAZsQjZHs3db0Stihuaqevu0OkiiHmrthMqgK/jB0CCxcTnsduRgq3EJMFR+//m+h1UT5FlWk/DhjxtshZ4SWqeOqO/JAp03hntNTUbgB12thjjafeMICZybix0Pe/RkcQz+OcuMYoMvHAGcmTK0L/weCeCGkzGB2aQ/YuQy2sZl92413Y4e/kupnmdnSQIQvzV+M2SKKatsoX5A3zUIv8W7J5qkY24R/3Vlg1WMrkO6XvfWfG62Z5R/UcMSaxmYxeDqh9ZKmALy2CP2r+JNJ2TIaiOvYqhjcCTumrn71zV4QZUtG1+Vrf0WXqlYjE4gn49aNy/etNi01f1dY2A8GKeUp/+WiPQ5bcyYpEAGLXbbIz+RpGVkfKCOsr+64h7q4myO/DsWUHlxXzBdsWi4hfF2Skq4Z6bSX
 hGQqTzXj
 /Tfm5JLHYgH9RbNPuDCHmgB1Z77UnfG/uld1HERDko4QFwyeMxoe+ZKZU6kRF79D1dtJwiE1HhzcK3oKgmgldMGzZaPHXCBGxjXJan49lBhaPPunHKdtUZXCdihkwsTo/HLaI2GVKPZjdClAambbF6hqLVACD7XyHKbg8Q+Ev7RiWTZoFFGnmu5sVDWFLwBJUP5bYe/abyCtoJYHpcFH5vBlNAToIVf7uchByvHGnSzsKLzBvEGf4JGRJ2EOY6M65c4t21ubQEVjIPALMz6BSR5S77WnlOx8tPQD7JzNlJiidhNcN6S1jhd93d45JDdjgjDm3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 7:48 pm, David Hildenbrand (Arm) wrote:
> On 7/7/26 14:11, Dev Jain wrote:
>> For lazyfree folio unmapping, after clearing the ptes we must abort the
>> operation if the folio got dirtied or it has unexpected references.
>>
>> Refactor this logic into a function which will return whether we need
>> to abort or not.
>>
>> If we abort, we restore the ptes and bail out of try_to_unmap_one.
>> Otherwise adjust the rss stats of the mm and jump to a label.
>>
>> Also rename that label from "discard" to "finish_unmap"; the former
>> is appropriate in the lazyfree context, but the code following the label
>> is executed for other successful unmap code paths too, so 'discard' does
>> not sound correct for them.
>>
>> No functional change intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 87 +++++++++++++++++++++++++++++++------------------------
>>  1 file changed, 49 insertions(+), 38 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 934773dfa2f2a..00b571c2a1bab 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2067,6 +2067,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>>  	return ret;
>>  }
>>  
>> +static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
>> +		struct folio *folio)
>> +{
>> +	int ref_count, map_count;
>> +
>> +	/*
>> +	 * Synchronize with gup_pte_range():
>> +	 * - clear PTE; barrier; read refcount
>> +	 * - inc refcount; barrier; read PTE
>> +	 */
>> +	smp_mb();
>> +
>> +	ref_count = folio_ref_count(folio);
>> +	map_count = folio_mapcount(folio);
>> +
>> +	/*
>> +	 * Order reads for page refcount and dirty flag
>> +	 * (see comments in __remove_mapping()).
>> +	 */
>> +	smp_rmb();
>> +
>> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
>> +		/*
>> +		 * redirtied either using the page table or a previously
>> +		 * obtained GUP reference.
>> +		 */
>> +		folio_set_swapbacked(folio);
>> +		return false;
>> +	}
>> +
>> +	if (ref_count != 1 + map_count) {
>> +		/*
>> +		 * Additional reference. Could be a GUP reference or any
>> +		 * speculative reference. GUP users must mark the folio
>> +		 * dirty if there was a modification. This folio cannot be
>> +		 * reclaimed right now either way, so act just like nothing
>> +		 * happened.
>> +		 * We'll come back here later and detect if the folio was
>> +		 * dirtied when the additional reference is gone.
>> +		 */
>> +		return false;
>> +	}
>> +
>> +	return true;
> 
> You could simply do
> 
> 
> /*
>  * Additional references could be due to GUP or from a speculative
>  * lookup. ...

Are you also suggesting to shorten the comment?


>  */
> return ref_count == 1 + map_count;

Yes much better.


> 
> 
> Nothing else jumped at me
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


