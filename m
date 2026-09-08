Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCE7C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9611A6B008A; Tue,  8 Sep 2026 06:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939A06B008C; Tue,  8 Sep 2026 06:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875446B0092; Tue,  8 Sep 2026 06:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 681526B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:12:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E77F01A04EE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:12:15 +0000 (UTC)
X-FDA: 85190179830.28.EB9D069
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0223180003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:12:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bq3wzFSn;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862334;
	b=6BM5nxDkT/NH35DldTVXhYPA567E6x5ktiWnmVryxoqxazzntizMj4e/KjwSLQ6v+VG3jM
	VoH5ks4WqPg8+bPiqZP7aQMo3h2k/WPgkMXJ4aUhdODvxzDmCgBs9k1APJOL813u3OYnQ5
	0ydzeEmBChIwsMcI50ruSw7DMNHBsR4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bq3wzFSn;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ayOQBPJP38Is6vE11/duZwA3mrGAIUY0/EIe7FHOUQ=;
	b=qjdn2VQZvQ0vFuHhRsENRYcGjppKsgeHvcz8pcHGoHVpnTbIT0Z9/Ebj0ZO+ds3M/ZgzYH
	ELmEnnAWvB+v7Gt2eh9qV7otenh8/hcedpNMFvO/eAlyuroIxTMvanN7dypCtK9hGtjtwf
	KPwx2drxdVmhU6WxaU+bzrZMTDme50c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37FA41476;
	Tue,  8 Sep 2026 03:12:09 -0700 (PDT)
Received: from [10.57.7.202] (unknown [10.57.7.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34DD83F528;
	Tue,  8 Sep 2026 03:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788862332; bh=xlZC3OEZMV0/coWQyGMwBENJjfaFGyqN0Zg0ccer2wI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bq3wzFSnLt2zEXdSnnz8U9DC9OXdPlrslLiXfJfZ/k46iOwSa29UVewNF2oShj0Vu
	 /1YVazJsXb5vhqKLpsEUmyltbNMJhQZLlZtXH0OjNqzlNMIy0OoZofVpqolFOC9O0z
	 RpncI49u7gtPHlIbJmwbnR1eaq8VLcUU9Xix7Sik=
Message-ID: <00e97c75-eef1-4587-b299-ab07591a07bc@arm.com>
Date: Tue, 8 Sep 2026 12:11:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 12/25] mm: kpkeys: Protect regular page tables
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
 <178877845406.3691569.12554855722197968629.b4-review@b4>
 <bdba5b54-8733-4d47-952d-e1bd958a1ead@arm.com> <ap-6PZqGZHhPD6u1@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ap-6PZqGZHhPD6u1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0223180003
X-Stat-Signature: ono7b4i9mdkaqyt9bkhpxod6un4mpkob
X-Rspam-User: 
X-HE-Tag: 1788862333-442901
X-HE-Meta: U2FsdGVkX1+p35wiMbNC7+GHIdL8fqfgxBmqcC/rSy/6Bq4aON5L1rLwOlbXxOBp+fvNiWOBL4I1KbE3Kb9EOYDlXx1FzitftxWsPePZPaiJqoLsSBGChhCC6RAtk4XBLDvG099jk/Tf/AGv/NvA2ShQr/7VlE1arK7rAy1P1SvJstV+tbWcIGM66jsuZ26AZ7jHcNEwkAoFgGdwpums9/Zt4FnFrkABHer60gIezHZJ+N3IYmdxP1A7Fh9iT8EHBfibMKexijGijnduvbQBU7+/kE0Trl3fFCyE34OvoJ6TxHrYSZuMqg8r834QPYUuD7s3LZybsAXyTrEynZuDtgdBW2sylJCMYGA9vcezJi5RCA7bwyKfsYzSIdFeXx1fl8zl2ecjNwFWgK41qVlQ4WITpSEUH2FHdG5xTdI6IhKYIO9gwqvkrZmderPQwzytbbz8c1X6SijKDl80+/1ZrJEQvNiccdzd8b3SrowR51IuGRpcDXrMyzVOJaQQU2bnRjRgWLkvnsMobrHlbKWCKVK6Uaooue9QodrOOFVLtLpiYhGNWgc4XEhEGODCwWi/cAvySmPigeF+xJNnsTL/HdIwIHNg/bW+SNr/b2T8q2zlqNfjAyq0bg7kGglPSbGIUR+VS3jawy+Ug78hlpWA5O4bw+FOu5Zk0Rc/ihh7qNmq3Ja7CrSyAfJeclbETS6E0HvnZ3kUugWrz8n+AgF6x+UJfnWfydL66zk7Pe1PxywUGWKKQwOat7bIo2PmArCSnNvyFuHNVFxaQEKmeLZ1+W90vYlaOz18acTMUDgkpn4sJXmjsP0NRE+3fUCzzpcgCkDtaEj4XQBqcDtRBlAWSSnbv6kneAFsLzvpeWKpuhbdV0ELiSoRZMEmzLMVXLNbueMt1zgCy5GMj+cN9CtZXskmEaxCw9vbco9sYHAwyyjtUBgR3pMdDrp7XBGMgr3tzFk9l1D3cx2f7g4GH5Y
 RL9+Sdyo
 do5LK+s2Q15asii0nRDoDvgTB5FNIBVw3FgwaDN2HBL3vYmoEk0X4mOcOirzNIixdLioNv9ydceoB2gXW3TCa1d6h+2ChnoKIEaR2X5XW7EQutQA71XCkI+nJ3wbuAGzfUq+EHdSDKvqqpU0VXP3in0vEpNGdX2IyC+AGLnzO0hn4IANY8fuzCm/RdU9bAT5ffj2zHfyd7r4R4NBM1jtA9Yf8gDxpRWvqG98mGRyvfuEfPj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/09/2026 09:33, Mike Rapoport wrote:
> On Mon, Sep 07, 2026 at 05:52:32PM +0200, Kevin Brodsky wrote:
>> On 07/09/2026 12:54, Mike Rapoport wrote:
>>>> [...]
>>>>
>>>>  static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>>>>  {
>>>> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
>>>> +	struct page *page;
>>>> +
>>>> +	if (kpkeys_hardened_pgtables_enabled())
>>>> +		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
>>>> +	else
>>>> +		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
>>> Can we make it a sequence rahter than a branch?
>>>
>>> kpkeys_pgtable_alloc() does alloc_pages and then sets their pkeys, so I
>>> think something like this should work:
>>>
>>> 	page = alloc_pages_noprof(gfp | __GFP_COMP, order);
>>> 	if (!page)
>>> 		return NULL;
>>> 	err = kpkeys_pgtable_alloc(page);
>>> 	if (err) {
>>> 		__free_pages(page, order);
>>> 		return NULL;
>>>
>>> with if (kpkeys_hardened_pgtables_enabled()) folded into
>>> kpkeys_pgtable_alloc().
>> I agree this would be less ugly. In fact this is pretty much what this
>> series did up to RFC v5 (albeit in the ctor/dtor instead of alloc/free).
>> We could go back to this API, *but* the big issue is that it makes it
>> impossible to use a smarter allocation strategy for protected pages.
>> Patch 14 in RFC v6 [1] will give you an idea of what such an allocator
>> (with support for large blocks and splitting) would look like.
>>
>> As discussed with David H we're first trying to land this feature
>> without large block support (fully PTE-mapped direct map), but we do
>> want to support large blocks eventually [2] and I would prefer the core
>> API to be already compatible with that objective. Very happy to hear
>> about suggestions as to how to avoid the explicit condition in
>> pagetable_alloc() though!
> We could unconditionally replace alloc_pages_noprof() with
> kpkeys_pgtable_alloc() and make the latter choose the right allocator, but
> that's not very nice either :/

Yep I also thought of that but the naming would be really misleading...

Maybe, maybe, introduce __pagetable_alloc() that is a simple static
inline calling alloc_pages_noprof() if !CONFIG_KPKEYS_HARDENED_PGTABLES,
and otherwise checks kpkeys_hardened_pgtables_enabled()? Less ugliness
in pagetable_alloc() but even more further down, not sure this helps.

- Kevin

