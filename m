Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC45C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584CB6B00AB; Wed, 16 Sep 2026 02:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50ECE6B00AC; Wed, 16 Sep 2026 02:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404006B00AD; Wed, 16 Sep 2026 02:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5A46B00AB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:45:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F049EA0637
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:45:09 +0000 (UTC)
X-FDA: 85218688338.09.CD78B14
Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76C03A0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:45:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mXtBqUic;
	spf=temperror (imf25.hostedemail.com: error in processing during lookup of lance.yang@linux.dev: DNS error) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541108;
	b=CtI9Cz4fLQRj12/kY4s0eCZoSKmFB8YCs+hzyjEZkphsk1R9iMCU02+SbzIsaxGh8BiUJ0
	X4DaOXsl0LdaEKs+zzgNTPP5IeBOa/c85iUzpLCL7g2UB2oS7zDHa1UuSxQ7x5MS9I/1M0
	gS+X6E4JMFk4uqEwLpnw1yb6mf8AfE0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mXtBqUic;
	spf=temperror (imf25.hostedemail.com: error in processing during lookup of lance.yang@linux.dev: DNS error) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6vF3Y+UcS+hzqT4N/K9fq7jY5e59AyRxJT3b1M4q9U=;
	b=lfPXlpy5T1qR+HFe1PJt5dliHB6eYmCpTyZKrIy8BJcEJM7dT2NBOrFmqEBxko347MhxYL
	NW0yFWkOsxgvpABUn5pOZvGdq6aOg1iYQtlJ8pOSZNwx5TWRUJyLnr1Ny2AFBUvr7XS6Ni
	j8yxyrEwp9reMbWRenuLwjD6RWm9MyI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CemCmch04q5mUKawMy0vidBfLn08c8QpxpUgzyNdQbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789541101; v=1; x=1790145901;
 b=mXtBqUicZVuyi6kRAjPefsuJTqASG+Jfri2piloLrH/3hj9T6NVpUR3Dnh46JJTSnCZ898y9
 k3thCelzmNSsoxhG8dBjrc0j25MlHAaBH2CYyzB6A0QPqwa/D3aRWZp1dPJeeeZiRl6pE40sr8k
 B+XWHubvH1r+fr4GIda6ux60=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0ef214d3c88bf2cc;
	Wed, 16 Sep 2026 06:45:01 +0000
X-Mizu-Trace-ID: 0ef214d3c88bf2cc
X-Migadu-Flow: FLOW_OUT
Message-ID: <0efbf471-b74e-4dfa-9335-f1720854d880@linux.dev>
Date: Wed, 16 Sep 2026 14:44:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 ljs@kernel.org, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <83a1287b-8589-4408-96f4-4f78dfca1bc9@kernel.org>
 <20260916044142.95044-1-lance.yang@linux.dev>
 <f784fec5-7261-4ebe-803e-eb26141a0fdc@kernel.org>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f784fec5-7261-4ebe-803e-eb26141a0fdc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 76C03A0004
X-Rspam-User: 
X-Stat-Signature: iy3d1ueay1w7xp75r149cxk5ep7fns9d
X-HE-Tag: 1789541104-741964
X-HE-Meta: U2FsdGVkX186iSdW0CQOg5Dxpot3rHLThj1pCWHv8Mc9GrF8eK7TyQVCfIxLYRHpN1RJ7dwo8y0NzTL1olnSot+92ZQ2fuIlq27ihKvnyEur/KtOWqx3aSOV3IN4mIqnk+4NCZvuuUDex5sRq+X7hAJZNnQv3GLLO1VVLprLXSJC7+5XHiRgnNTrNdjMoGguUWUrIUx56BOXQnqUajbHCHHDwqJwv5CQw9gu+edsT5f1ohoEknsGCIZOE/DvIAFsghWrT3tEIdjCuyPkI/O//fVHrtD7kftfm7uBsNF984dQ42eTA23EOBMsHbCdRo4m2LzAT0NUE+eSZCHQ9mjRAL4ASGBtBYiURcUqJbP393/UIG4Ok23Hry0jppr0iKb5DXABfol5iSW7Ejs64x0vJWWSnPcTSsQl1RxlDMaqHZ+4AevcV9JIWl1lImRjr3EvRsrKNmHN0XO+MV4VMdCY42ByVlgB9HPSDe6M8tRKxlFw3DdUK8vJvbcjv7QAPH+ZgoHLSkdI7wRJwDqmG/mu8hPACjf7Srejiv1tVs4+y+uRgb7IRjyCknwCs0oTsn4e63O+Qs6tL17CUGLWXsbqNZqv6yfbm3vntiXhIm5PW8eg0g/tKhQ4fIAfYWyMkWsTbjih/U+zOo8eo9Qp2bma4h4LRYQYbIh2+1CekOdnlNcXgD22Pc/jCXXsmegDp1+rtqS8hS4NvyLPTITA86eeHR1vLwFlSiu8Ix5KflBXQVtb7bnPj01jLphhiDDEKFJWK4iPTCNWDHGl5edCuEC/fRPczXNXtEHd57KpAdslwC4gSjmUrfRT3+iRchwGHS+8A6B9f6ts4q88/XZeVsfLnBB1qa4AGFGs0L2s7RaroGdV9LZAUHT8CAd6TgfIxlHggQq6lE1HCcHOlqo8k8qS5AVXgZY+l1nfEYSa02p/6+3SYdMo5o+gcOIuTLmhsyMrVYlUuMuy7tlvpO2ow8a
 CLRSD291
 kCqyEAJC4ISpxdE0L0ibco6uqVmhWgUT6nagvNR+Xdu0Oe714WnjAHTXN5BIRks/+fLLfTBW5gHEaaELFR/gvgGjyMnylOAdXK2ZrmsCwIe4mZIdeKtbxY34AEEJR4OdiH6JCtIsiSsmlJ5K4pdTkjdlU6F+eOVAjkimIit2bWFFRj8fY5Qm3OhbF5kAw7BZUSdhM6Xd/3qxXb9lUCDse46Jaz4pDKNsS4C0lxZB8TwsucynMOtUM5AWg1AHKmVb4o2wiS5pS4kz3h4Fba7A1wKfsl7CgT4n/uxi+dB3nw7ktJSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/16 14:11, David Hildenbrand (Arm) wrote:
> On 9/16/26 06:41, Lance Yang wrote:
>>
>> On Tue, Sep 15, 2026 at 05:13:17PM +0200, David Hildenbrand (Arm) wrote:
>> [...]
>>>
>>> Ok, it's really only DAX and anonymous VMAs that use the huge zero folio. Other
>>> (module) code would have a hard time using it, as mm_get_huge_zero_folio() is
>>> not exported to modules.
>>>
>>> DAX uses dax_pmd_load_hole()->vmf_insert_folio_pmd()->insert_pmd() where we
>>> deposit a page table only if arch_needs_pgtable_deposit().
>>>
>>>
>>> So I think the rule is simply:
>>>
>>> arch_needs_pgtable_deposit() -> always deposited
>>> vma_is_anonymous() -> always deposited
>>>
>>> ?
>>
>> YES!
>>
>>>
>>> The trick is that we don't have anon THPs in non-anon VMAs.
>>>
>>> So could this be simplified further or am I missing something?
>>
>> Ah, cool! I hadn't thought of that :) You're right, anon THPs cannot live
>> in non-anon VMAs, so pmdval and folio aren't needed here. Will simplify
>> it as suggested :) and add a comment explaining the rule.
>>
>> static bool has_deposited_pgtable(struct vm_area_struct *vma)
>> {
>> 	return arch_needs_pgtable_deposit() || vma_is_anonymous(vma);
>> }
> 
> Yes, that's what I had in mind. (while at it, maybe call it "vma_has_*)

Good point, will do. Thanks!


