Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2381FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6706B0088; Thu, 26 Feb 2026 05:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193886B0089; Thu, 26 Feb 2026 05:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0761E6B008A; Thu, 26 Feb 2026 05:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E79986B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:09:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E0511B77A0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:09:23 +0000 (UTC)
X-FDA: 84486185406.19.5D048FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0BC8180009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:09:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/woZa4w";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTMgF5m5bn69UmxfjvycxTluCeUcfMgesqNdotu3ruI=;
	b=Qucj8FDKU8ay+tccqj7qFEOGlQQCmNxxMmkL0J73zfieJFo3AN+oRxtFlhJmdvPA9A1vqH
	52PP9W8ZrnKQMk/xWH+ETAL3oDIqeZJHdI2XJQ+igaCRzZF5Y9R/QlCwLpDns1Pxo19gpg
	FO9pTxygVgs7J5oqH3+hdJDP2qHPoko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100560; a=rsa-sha256;
	cv=none;
	b=aqyJ++bFf4014FxWRSi6qu667ZV+e6CkMz20Y8UW/Iuuj75GiD/yKdE4ovJlZTi3ZMuvv5
	6rLOKQg4C7zbQNUXWW8UpJzZ9KU9vhh0BpjfuaZFO52qhZzXaWWWbPa+a/8UvlNBrVZHoL
	dGt+6Kkfxk1XTU8D7c9Lu2ZFD0W0RYM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/woZa4w";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9153A442C4;
	Thu, 26 Feb 2026 10:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC05C19422;
	Thu, 26 Feb 2026 10:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100559;
	bh=Ohklxrq6BfF65O3H8MumF+61Rjesa11XDdamvS6DZdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z/woZa4wdBSpqFRbqu9TvLv6vs/y8SvC+qv//kQNrfywux4zru1j4usu2I1zwtY17
	 ZBS8AGlVwWa+knQ1p+GR2FIk0qa2dh4iicKIYVU83rYHMrt4JgkHPWwL7eTsdh//ue
	 NWebQH2yE34dcbk4xolmp8Cc8M8VNvfdiCMQG619V4hNvAtQVbFiKqfbiMNJNfXalw
	 RKuks4PMk2pgcripeyxm++DzAHk5Vj2sJyFNscF/brJSZK7iulRLwegmgEMotpA3B9
	 ksN3zZrRjb/x0hZz15MKiTT2W1WDQ9E+hmt3/RLcMAmJj90RFvrBjcRISbKUdkl/qd
	 QybimCrJ1KI1g==
Message-ID: <bdfae0dc-b7f3-4c1e-b8ad-8a0cdf50c1e6@kernel.org>
Date: Thu, 26 Feb 2026 11:09:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Barry Song <21cnbao@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, akpm@linux-foundation.org, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, harry.yoo@oracle.com,
 jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable <stable@kernel.org>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
 <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <CAGsJ_4x=n9BPHN9Eg9KYY40T68wWuNJUN1x8dokJqFXSKu3KyQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4x=n9BPHN9Eg9KYY40T68wWuNJUN1x8dokJqFXSKu3KyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: uf5yootmqwm3wa8mi4kewapd47r4bc8e
X-Rspamd-Queue-Id: A0BC8180009
X-Rspam-User: 
X-HE-Tag: 1772100560-33223
X-HE-Meta: U2FsdGVkX18HTXZXv7dJEkPef319E6kgaFpBIqFLeivpn5AaTrGh2d0obFRM0FR9FSVrunoz42PAZyoDgZNtBWob1qy0U9FOqk4bOwZIbHJOKVM6dP2bF4JkCxt+fyJmpqadHgkFSAUKk7ikT1IMJwV1KccAmWcnQy16DaGC0iA5amaYaGgjQjBIFnjrl7UttvIxkz3Cheub+zu1VhPeMnMr3ZIou6X5d0Wh7+jTRoQaNtHpRpTSYbB/mpY7C2ACouBeHcg6o3zUzH+t1vMmbssuifH78nQJT0ADm1saQLs5+5Fv5h1y7OUvsGRzRTfx6l+f7OTCXkWMCvHpaJTxgxaHYhIbU+zxSuctV7iCcSkW0en0Gp3oYfs0urOiJG65mE4wqSD2mPxEI+kMYCcQSY2CfIMFjlwRANEkk5rMQQCRe78zczxGafo4z6HhxN0Fjlx+yqU+OpsFRDuPi0PUKb1/HS08UbRsvOuRsOEfAdIYFFWgSL4K/+Fu2Od4jwRCP0KBB/zB81UpdUiWjCz2lYSm6y6UT+tsJnE7wL+ZNXa7HCvqnQ1j7b0p0o8AdPspcWKX/t3uYlrvIXIYG/31DWPjGLNsvoxBuFrl4Tny2veVju+cv5qnFBOgbLol8WBHjOXVgrE8OEVlJaAdZFpwgR/2mj227Ig+Ojvf1KCJYEB+m4VBAfyRQnCbaEtchL1YgdAqypVthOCTuXsjpMcCgy5NDrVgDYBIeueYYVXVkA8Guv83eEiQUgzrjFg0kBiOqdth3Xx7R1yV5Ts6WbNpQaMeKP7lJwJ0uJgWcvLCuvdqdDIY4LRK7Lz26cmpz9mkppOllHk1qyYAipSi50HkhjQr3G9sg5RoIi86yEugvoHUGPodM4CKGpNXr9jppZGUdfMdTcRPbZgFs1LIXkO6tEVjGbUpYmGTeBMy8GmnCebwSr7iRPu+qMxfjE6Y0uWgQE17in3pn1mHAspKGPh
 K03xu14W
 JZhTVXK9Gjs2g7dMKCNJL0V0JIlaJvV0P+TDx9K9wA3p3nWdQxopPN0sabrEkiUABAWlXo87eNVrbs7xS1ZbdjOQuAVdhfVFZt6BGGaWBLNWIaxZN1vwELm/gvIiFU8i5hhoKtBXQZAC6aRGgxWvYUBUs0V+DjKKHFPVUG9J/647cbu6p8JKx56DMOKFwDu7M2EmkfR3jJxlXTqIoCmQziQvru5bH90GFPziMks2PyT3WGZ/AEEeGmfSo42aBUgMASpYI8oU3nU6/flBK0FM51ksj1KFoRj1qFgL8PIhG5Fgz86htrVO59kzDsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 08:01, Barry Song wrote:
> On Wed, Feb 25, 2026 at 12:01 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>>>
>>> Sorry I misread the original mail rushing through this is old... so this is less
>>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>>> but it's a good example of how stuff can go unnoticed for a while.
>>>
>>> In that case maybe a revert is a bit much and we just want the simplest possible
>>> fix for backporting.
> 
> Apologies for the mess I caused, and thanks to Dev for catching this bug.
> 
>>
>> Dev volunteered to un-messify some of the stuff here. In particular, to
>> extend batching to all cases, not just some hand-selected ones.
>>
>> Support for file folios is on the way.
>>
>>>
>>> But is the proposed 'just assume wrprotect' sensible? David?
>>
>> In general, I think so. If PTEs were writable, they certainly have
>> PAE set. The write-fault handler can fully recover from that (as PAE is
>> set). If it's ever a performance problem (doubt), we can revisit.
>>
>> I'm wondering whether we should just perform the wrprotect earlier:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0f00570d1b9e..19b875ee3fad 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>
>>                         /* Nuke the page table entry. */
>>                         pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>> +
>> +                       /*
>> +                        * Our batch might include writable and read-only
>> +                        * PTEs. When we have to restore the mapping, just
>> +                        * assume read-only to not accidentally upgrade
>> +                        * write permissions for PTEs that must not be
>> +                        * writable.
>> +                        */
>> +                       pteval = pte_wrprotect(pteval);
>> +
>>                         /*
>>                          * We clear the PTE but do not flush so potentially
>>                          * a remote CPU could still be writing to the folio
>>
>>
>> Given that nobody asks for writability (pte_write()) later.
>>
>> Or does someone care?
>>
>> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>> architecture (write-only)? I don't think so.
>>
>>
>> We have the following options:
>>
>> 1) pte_wrprotect(): fake that all was read-only.
>>
>> Either we do it like Dev suggests, or we do it as above early.
>>
>> The downside is that any code that might later want to know "was
>> this possibly writable" would get that information. Well, it wouldn't
>> get that information reliably *today* already (and that sounds a bit shaky).
>>
>> 2) Tell batching logic to honor pte_write()
>>
>> Sounds suboptimal for some cases that really don't care in the future.
> 
> I'm still curious what the downside would be to applying the
> simple fix instead of introducing more "hacks". As I assume,
> cases where a folio has both writable and non-writable PTEs
> are not common?

With "in the future" I thought about file folios, where I'd assume ti
could happen more often.

For lazyfree, I agree.

In the end, batching as much as possible is nice, but obviously, once it
gets too shaky in corner cases we might not care that much.

> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e..48ad3435593a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1955,7 +1955,7 @@ static inline unsigned int
> folio_unmap_pte_batch(struct folio *folio,
>         if (userfaultfd_wp(vma))
>                 return 1;
> 
> -       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> +       return folio_pte_batch_flags(folio, NULL, pvmw->pte, &pte,
> max_nr, FPB_RESPECT_WRITE);
>  }

If we already go for this approach assume we should then just set
FPB_RESPECT_SOFT_DIRTY as well and have it all handled properly.

-- 
Cheers,

David

