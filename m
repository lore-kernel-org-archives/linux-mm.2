Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79A9C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D416B01F2; Tue, 18 Aug 2026 03:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5466B03DE; Tue, 18 Aug 2026 03:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4F26B06B5; Tue, 18 Aug 2026 03:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE436B01F2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:30:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33C12C0B23
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:30:50 +0000 (UTC)
X-FDA: 85113568260.09.8213B7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7239B1A0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:30:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCApkB98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787038248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3+9yofyMB4DtAL+J7TlokgqleL68Gal+la2A8GH2EA=;
	b=cdJZ4MbJmSMDKjIOanf/18uiva6mxB1tEj7ryqUq0gio8sCSWLtxXDZWVkj6pcYENlz1qc
	wASW6Mt9skdn0bqiG6HqsaSVj1e+UE7IMDebE58ommR6Epf3qUKzrh3orACo2hPddlKLDj
	ux+jUKr0vJIVxZSLPYfkW7J2LSxUbZc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCApkB98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787038248;
	b=leT3BPhc2uaHQpoOdiSc2CvHnOFtEYPXgS25RsbJED76Bm0IjYOxn2iJXpk6CA/v4t3vCq
	cyp6pl0dvzEcLiEF/DDwZ2g84FcL96OCLIqYU7Kqlpzbtk9CJn4m2KC/toX2azgCD2yidm
	lWeDy+JweBCMpkt80Hq7setNwNAwD4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A679041AC7;
	Tue, 18 Aug 2026 07:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432DD1F00A3A;
	Tue, 18 Aug 2026 07:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038247;
	bh=F3+9yofyMB4DtAL+J7TlokgqleL68Gal+la2A8GH2EA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YCApkB98bjF2ENMhASp4r3DdYbm3aea8c+dCZWnQdvq0xs/ZmvhNepadolKrRhcZ0
	 NIUtKoAfeTZs1fe+1qoortKcNpBKzu8gXjnNCnS7LXgkcg8fxYWPgs32AVHEFrzi+1
	 Zz0Q6kuoYVmvrETQQa4KDh78vSxYOTu77KCUI6HRbaatuNztRwtRUGCsbKc8iBryNm
	 Ih1jTPpgwnjc0tWpuQwcwdI+6k4HnoZj5vXqb7zXP6SmIhG936m2w65Eulg6WVjBOY
	 eHSipTtxkECUllX0VWdVf7w2NXMxwsQESm7LCqgc3hn+Qo8t9yhljWzw4D3LhSmfXb
	 9XRAsN8cPq/NA==
Message-ID: <f27cc496-d9c8-4642-9d33-15c629623d1f@kernel.org>
Date: Tue, 18 Aug 2026 09:30:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, liam@infradead.org, lihongfu@kylinos.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
References: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
 <20260818021326.5910-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818021326.5910-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7239B1A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: qot74fibbc8ahuifehpw6qdqjxirndwq
X-HE-Tag: 1787038248-996752
X-HE-Meta: U2FsdGVkX185unJqTpX1Aeo5SH/Z/8KJ0+Cy8PU9NKFYYDWSCCcYaruBo0RhkyQtvUNvmY+4dU4KRVsb32GjVJlP8qP9g4KTC09QBhU6ofjLQ2TgBz2Ph612mAoppJN0oKYbYFULBncYNF+QerdEO/aEyJZEF3+E01Pn4DzGDYBdacMurL7m+QqSjRndZpJ5NEYJ2dw2K6MBBB+o4qvXe/u0905AuT46/Q+9IUcdsoYa1hrTDJzXydhHA2+llc88O39wySCFIPDZ+UPJmZMqglWL5SnDuFEODByhx8H6HOHhEAALmqZy36ug2hfbFQeAHO1U4hKIJwLH7KmPMPm44dpf8mCxePzVylXrsR9gOOmDrVGmg/DIa0qe3fg5eROHfBVTW9gJFWkrfSkuD73eOzIFiXvjawPvDkJ+LhOzUx57GOFeoRjz41LZ/vAprnunGFShDKhLMqCSFIZNrk2O03U2TkDM4oQI2/eBjplEabctQ4CK5FP0pWcjvkICTMXnKEXDDbjyPNY4DjpvCgaRG83gI/+jXSX3YnjM9JygiJxDYIGkHEAtWTsG1p21Wpi5b0GbixHpeekMgdoEqcJ8wBCJAzcRziu8bmOFF+a0nNZ78AbN4BszZCoyeZKl6SBO1rzKr70R36sVdsofisqsDwuErc7/GmS+lvshx27v+hbKCh2BKhEAt9FMaWPXv/nfo5JRiI1bGsHnzur13AXiqOPKIseN/mlEHebYnhDWeXO2PrL9y3bkWV89NZ6nBpB2vMiUEyCoHps92duY7aritC3gNWXe8jR4YC6EGOk/dH8iebgKI9S+85LdSUvLMDyRSoN/z/8GPEdA4iTM8FNOhfpLh3lojiLkt0gUUeN0HznSr1uMWP7VLbBIZUyDEc+SC35maFNjbOVMmwOP1VQH3MUXEyH6UhbVEUSp0ctZHUsCRuVxcflKrlU8H74erRbiuWBDoguUFUSjfQN3OyD
 ENnxqCA9
 +DvEJ0vnrg4WDbI6Gg9FMKsjEIDlOYE962odX7GAhtLoG979onlE77Yha+VA4UAIfkQovViYyqnvfaBAHA8tZpkoNc0pulD6M55v0TzlxdobOH0bP0Lcn9srT9nww0bQU3Ue8m9UE1JH+cGSK9BSNDyQD49jpzCuq3t5l8N+q5MW06N+lmcT2FGKOeSQ6G95osQzPVvFw+I9XZHHlin/pM9J9WAxW9NzXjwJQLQe5lhbIv/Zfshi4WHqjEF1cfMBWw9vx7CwXbSwtkcMH0hwHzi5Wi5rV3e+fn4ZQOboMRH4MeMtDGtwqCFuAeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 04:13, Hongfu Li wrote:
>>> So after migrate_to_ram() the folio might have been split or otherwise somehow
>>> the page doesn't belong to the same locked, refcount-incremented folio it did
>>> before?
>>
>> I suspect a split.
>>
>>>
>>> That's kinda a footgun... but this documents it at least.
>>>
>>> I think a comment explaining how this can happen would be helpful though as this
>>> doesn't seem intuitive.
>>
>> I think, conceptually, calling into something that consumes a page (vmf->page)
>> always needs care when operating on folios.
>>
>> Passing the vmf to some callback might be the odd thing here, because the
>> vmf->page contract is not really clear.
> 
> I'm very sorry for introducing this regression.
> Thank you for identifying and testing this issue.
> 
> I will double-check this code path and apply your fix to run further
> tests locally.
> 
> Would it make sense to add a comment here like the below, to make this
> subtle behavior clearer for future readers?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4134ac607ee0..2b6d6c863ecb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4937,6 +4937,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>                                 pgmap = page_pgmap(vmf->page);
>                                 ret = pgmap->ops->migrate_to_ram(vmf);
> +                               /*
> +                                * migrate_to_ram() can split a large folio, updating
> +                                * vmf->page to a different folio. Re-fetch folio for
> +                                * correct unlock/put.
> +                                */

"migrate_to_ram() might have split the folio."

Should be sufficient I guess.

-- 
Cheers,

David

