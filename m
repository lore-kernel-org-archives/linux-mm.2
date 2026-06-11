Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0305CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F2D6B0088; Thu, 11 Jun 2026 07:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28506B008C; Thu, 11 Jun 2026 07:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16F46B0092; Thu, 11 Jun 2026 07:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22AC6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:29:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8583D140562
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:29:11 +0000 (UTC)
X-FDA: 84867410502.24.7008839
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95D7A80006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:29:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2zvRFMP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iXM+Lu7Us3RNKuTfxaVjOprYbkGH/NiJNcNKN4u9gM=;
	b=O68ei0rE/y6AQ6xGo/6qVYXeVXF9q7DWalhxisPXA0N6x4D8GsCDEG5kufa+VYn2Y0CGvk
	jnCbgj9gFvamBqMMn5wTMft8DsNkd5JMCTKpyV8+5F4pMv56utUNTbWmVGkD6+4o/ZGO+u
	Om4rHcbN92Ln9T7mfE8IgpO6I58kuU4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2zvRFMP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177349;
	b=AHXNCkcuHvCbhxU+vWsfdepvKd5UAHX1WDq28Xrm6K16QJNb3zCxkLWaSUHZGNoSmPC8uQ
	F7Bk4FT8HCfBZx4gaXFUrq+sHS1Lr6Wi/Kwdg708SkkN4WI3xIE/GBA3d8FN9FbJD65/+1
	Zi3OZLSELSFnOfZvMcZ2rXlvwTpJVKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A28274066A;
	Thu, 11 Jun 2026 11:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B262A1F00893;
	Thu, 11 Jun 2026 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177348;
	bh=1iXM+Lu7Us3RNKuTfxaVjOprYbkGH/NiJNcNKN4u9gM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y2zvRFMPXCvDIcnpv5C3TWA0r9mNn5coUfJtmV6ljqcuK7N5nJKKmxsBN+OE0jD7W
	 a5HIlP+JikfA6mdizyZuh8fhKRMf6pywf60Iv2BIh9uENPDEEW8SLQWlp7VlDKLWeC
	 EHPA10EYcoOoHwVLpeiXhNJ0mh+0S0ClwOCGOPnXR4OsWBW9PI2uMhr0u4Vn41Lzjs
	 9rDWHWcZrZd9ykx0uG3vwMvX8FfcYTHiooLJLDBQYAwXH8Y/KnvwyyMC7XGKKkvXGj
	 5bV2xIwLaVyWwJhHSBa5DltR9Tfm37gOpA52dsMGrUTXhZIiILbJlu4w+UzJfyGPRY
	 mYJCjahLyRG0g==
Message-ID: <8c36a91d-288f-4ffb-b2ec-41e3ef789d72@kernel.org>
Date: Thu, 11 Jun 2026 13:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: xueyuan.chen21@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, yang@os.amperecomputing.com, jannh@google.com,
 dave.hansen@intel.com
References: <20260609124549.aff7e774603c4af188009408@linux-foundation.org>
 <20260610021508.46000-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260610021508.46000-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95D7A80006
X-Rspam-User: 
X-Stat-Signature: nu7wbn5utmzrp85qecubkkaxex1mys1u
X-Rspamd-Server: rspam09
X-HE-Tag: 1781177349-47551
X-HE-Meta: U2FsdGVkX1+rMUlMdAz9TOvXhcvRBAUBuL/vLPwlJvVCjSR0TdtIP2qhXHVgCmcvbMqmRFSQj61kd8t3otJNP6gVUPjBWmI236q/1/T9Cu8pvar3Yj43jr0LVPJ4EoVdI+aaF4oAFHNlWsBy8oeLZGtq9N1P8+W17CihkwnVjJhDncU7yA6ZB3DAdTseXfTko9IIjVgEWt12Q/lWAV8BAhiCLjJuUED+JIlZ7waUl2Yo8fUGMZhs/ibkaAljA1eKqMay8IV8rjwjjOOEGRD20nDt/SLLAJV3S74LNXPS3SYqRmdwTGVx94PDl+5AknzS/pKFb7TDLBT+4FI8gHxUi9yFAhvpcPJtW1TMOnpdNBDaWFgD6XMki89Q7ipqglmb05BPSJHB5PqNvMZaWR16o/CcotVivyHTgil1P+oScHUUuDTmTQuoBSqhVaMRrLFTZtaXylByFHeeIqOuH7DLqXOfH3LHkhg16iXsFCSciHusk0opNnkee3uCVcQgFRs9tf2KjMPdvKILTVLFuaEFzQcJsPZDCNX3NrB0IFCF1cbP3da2MStCIeV871wgwNbLV6CdbIEKotht5lI2QHsIjwoqobXXwTY9YCUbyvh/+xOWTNPzw4wkBc/PPEPWqHR1NoRwDaalVvH83qp7MN6BmD3N47zL+bM9X7QA+Kg7mZVbkBOw5hCLn1RYbeYsII1xzivmS2ZnbGqylRI+oTr9mVYq97ij6UOOSYjLghzfbrSQMmihE1qRajGMeUkpoCp4Imvsp03merWos8nW3KfZdcdZLmhY7Qotn37rmnCH2OI4+yYjr6TPrQPjGlNqkyeWcwF/0HF0QQtqLrDiilPhvdCptqRKIwWm+XxLKygPF+t+uGF+XFYPZNFe1TSXLu5TAz7YXDS6olMHo+eBlnV/HLB+1kV+z7qggdZTHLhdJ3396bYM7nod7W/bFxzEixwxBrXMS38UTvWEMHFncBK
 CFes1Sea
 vFKvXv4doJnre9p8HNok3aqNUaDrvDSXZJNsDWTjD5YlxL49Jpk5aG9pNDPvvB9kV/ZuL+LrlcKvkUiYUJuEjsESpRPoZZ2P1PSPGRdluhdsQH31V5rZM9OjkQkqLUT/qsx+Dtqv8U+cVD/MyxjOZWpDiLAMji6wiQFNwrqGsdHxv8+l/xytK9EsV+r++wpmdp7Kly222tLWQ1WocflCfk14+ej9D2q5n//o8RDhUIhOWhFKP+LdReRjGqsspdOYAsjBA/Rl2t01ss5584b8dlDQBuTPqTNISRpYKyasd5cyeU2NYW+0nLKIRvWCZsrKiYyCVGWri1NtffO2eJkRlJFqMTK73Mxgt+ync8HgorXlQVULZ6TUSOnoJioUVyAOm/M9iENmu4adCQ6z+bhXWeOEFLzRKEWXr6IyUlj8oRreqHeshT5G+0QzTSAv6hQd3lH27SEji2f6liO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 04:15, Lance Yang wrote:
> 
> On Tue, Jun 09, 2026 at 12:45:49PM -0700, Andrew Morton wrote:
>> On Tue,  9 Jun 2026 22:37:59 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>>
>>> The huge zero folio is shared globally, and its contents should never
>>> change after initialization. As Jann Horn pointed out[1], the kernel has
>>> had bugs, including security bugs, where read-only pages were later written
>>> to. If the persistent huge zero folio is read-only in the direct map, such
>>> writes fault instead of silently corrupting the shared zero contents.
>>>
>>> Add arch_make_pages_readonly() so mm code can request read-only direct-map
>>> protection for a page range. Direct-map protection is
>>> architecture-specific, so the generic weak implementation does nothing.
>>>
>>> This was inspired by Jann Horn's read-only zero page work[1] and follow-up
>>> discussion[2] with Yang Shi.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
>>> [2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
>>>
>>> ...
>>>
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -308,6 +308,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>>>  	return 0;
>>>  }
>>>  
>>> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>>> +{
>>> +	return false;
>>> +}
>>> +
>>>  static struct shrinker *huge_zero_folio_shrinker;
>>>  
>>>  #ifdef CONFIG_SYSFS
>>> @@ -982,8 +987,14 @@ static int __init thp_shrinker_init(void)
>>>  		 * that get_huge_zero_folio() will most likely not fail as
>>>  		 * thp_shrinker_init() is invoked early on during boot.
>>>  		 */
>>> -		if (!get_huge_zero_folio())
>>> +		if (!get_huge_zero_folio()) {
>>>  			pr_warn("Allocating persistent huge zero folio failed\n");
>>> +			return 0;
>>> +		}
>>> +
>>> +		arch_make_pages_readonly(folio_page(huge_zero_folio, 0),
>>> +					HPAGE_PMD_NR);
>>
>> Can it simply pass the folio?
> 
> Right, this came from the RFC v1 discussion[1]. David preferred a page-
> range helper for possible future non-folio callers, not something folio-
> only.
> 
> Of course, we could also add a folio wrapper on top of that if needed :)

Best to document that as part of the patch description: we don't really expect
to have a lot of read-only folios in the near future (zero page is rather
special; maybe it won't even be a folio in the future).

-- 
Cheers,

David

