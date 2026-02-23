Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC7BEC111A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4716F6B0005; Mon, 23 Feb 2026 14:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BA16B0089; Mon, 23 Feb 2026 14:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300D06B008A; Mon, 23 Feb 2026 14:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18BB66B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:17:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B9821B5BF1
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:17:02 +0000 (UTC)
X-FDA: 84476679084.12.E5CDE45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D3C4C8000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:17:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VKH56jk/";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771874220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW9/rztysEsKQP4BwEVSRhDgWZqG1r5zaI+0B7PY8bc=;
	b=OTRlC7xj4h/jIes6wr0OKq5/+e+Y1KDrySJ8zWPpDonTtGg4IELCI8EjNj1PjsWjMJO80Q
	sxbTdkC14B6id7pu8lGCv7u8HBAdSiIKyhnFn/O2FLhJE3JZho089fobuF7HJlWKDZJtYB
	ZF6EkAXp/gT51O/kY2doxkjfXrlFmsQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VKH56jk/";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771874220; a=rsa-sha256;
	cv=none;
	b=z7pflKfDKfGcHOQdptN0J0eDLCPi3VqRPZNEyUXufNOidiRzPUcYiLnvbt5ix4/9WaMg/n
	gBrFRohESj6qEZ8eGx8EtZUSIVL4aglsOMe2/1aeZnGYO1VYKMypsWi675bkBFZDr//lW4
	yzs6s4jGNpEk/8/MLRjPMyIUi7aRpEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDF1460141;
	Mon, 23 Feb 2026 19:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52399C116C6;
	Mon, 23 Feb 2026 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771874219;
	bh=QoLi5Ji30jg6+9EIkK83WuAw9m8Ump5BIlaU2i6pUmM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VKH56jk/9sGgHun+FC5oPBfjXO+gF2v1895vNaw2i5skZ+VXV82v2KHOh6B8wUVWq
	 wT1SFhGyC4SDVnFsSFOcTCCjg+uzfw0qzYs3Nx/tkTy5RpRx0sd3DC+uBMGyroG9Uz
	 M/0ITMM7q6lm/eF6y434ojIJ2d4fuAOXuIaNHdKWuHR0t6efZMBfuQVeyXIag35ZDS
	 ovgVd37o931o+qzt1N2PwrJXMFrCOBpBD/sQHf15fhaPN/T/cO5kHg7DP/fZ3fw5pO
	 oW+6viPFd+2/wMkU/+4eiK83yMDY8UHVKp1FdnigKgAvbTYPLOlBGvLWm/Wx1qc3r/
	 yXZH7M2dWVajg==
Message-ID: <45b78153-262c-43b4-acf6-7e3f153fbcc0@kernel.org>
Date: Mon, 23 Feb 2026 20:16:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: centralize+fix comments about compound_mapcount()
 in new sync_with_folio_pmd_zap()
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>
References: <20260223163920.287720-1-david@kernel.org>
 <aZyVVl5qcJsfhKuE@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZyVVl5qcJsfhKuE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o8tdphgh8n93mb6dz98hkiux8ga8yg5i
X-Rspam-User: 
X-Rspamd-Queue-Id: D3C4C8000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1771874220-18138
X-HE-Meta: U2FsdGVkX1965ILxwzYtFDrZJ/OZFySYh3Zwk22TqyYVjxR+hHioYWqCkGphX7C95T/XjSukHV1bkMfeuB0GH8N1FZrlfwIpV/5LKK0FlHW6B+DwNcOyKFL8eW32go+798uvucd+oicfwC1wny5WLF8aaZSvW+DcjDsj4SM9/5r5eZQ8Bg6iV1ZZg+4qFEcWaOJd0rupUKQVVGA1iY8LfinjxiUIAYV8KXaUaZHCNF5gTeSfioqR0FNWofeWp/uWVKJ0td9CDHf64lNQ9Mv7U2g+VPEKJ8UvFsp0apycNLBR+kVSrAIzL/Dv+IK4uboXKPNuhBMxOnw5LDiRbWIt0mQq4q9DeMQMkjOBbMZyv6ubklyfD7LUXAAD3kN92dQwGxkeSIWIYf4Aw1NxwG/B1U7TgnbsACJYBCAH9m/zpjidJQXTqo9dPNVswrldiuEeeuhAOYWvtm9zgOvCnW96dasLkhaRB1I8vwBA/uwGMEWbVNOiRAlH1u3OPkqzJiICnCX4uWz0zFt2jJ+iKWv1DHc0TURDr9LPJnWg8BBjbBTpEbsvNT1w+KfMLSOjpXUwKlvKoRCqzpipaTVUdgvnZrQyulLdhDuCTHyuqqXhQvbWDF64H8LmOSpwStpEbPopie4kDWw45VnLy78w7DBtKjfBfRvFGkKekdSXlbL6LK1ieDPzqvLkZwhxxjxlvqlFPOnHZJtFkjDqIaZVcOS1i7TqbFksrJwgeI7J08+y6spPijSo7c9ckz64QAYtJCqn2uWa2NpOuGfBXNh26H6UMgyHy0N4ToI6aiVemG/naCejg9YWu02kKCysdP29tcIqOfOZT91S8okBgex6j2CmZ7TJ0RHNJgK4T9tynrgKWyXitN3rgHj6AsTG8gv3ggESb6qtAWxifJCgMXVuzz+hIAIMzr+/kzeRwA4otTZug3SXl0yJ2PLc5lP6gcZA4yty2kuz4WOog+lRNsU6Ygk
 Z1T8GIj1
 +2TiETiV9lyrmZzrLs5n26nUsWJAEmiwNdDG0/htYxxb1Nn55zRvteaFk6CyWGpa68ZFMe9scUv9rLcLkjmXSVb+F+BIYPWM1HBzPitBx5RbMF6ev7BMK5H7994F+y11T5y5hp9hMxe4WMEyFCtiq5yIwovei6czpki+rsWASwmpprMIWMItn+ZpcZXbfKgp6GEegVRbkcp61bjgqWJzYmTtNsBlJc0BJd9tuS9guxqmciDKO/YYkLM0kARWqRi8CgIqFNIxSmiGqzuTylJfw5wL96WQJbXiwqqSith6J71BrpWoq6696DTc6bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 18:58, Matthew Wilcox wrote:
> On Mon, Feb 23, 2026 at 05:39:20PM +0100, David Hildenbrand (Arm) wrote:
>>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>  
>> +/**
>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>> + * @mm: The mm_struct.
>> + * @pmdp: Pointer to the pmd that was found to be pmd_none().
>> + *
>> + * When we stumble over a pmd_none() without holding the PTL while unmapping a
>> + * folio that could have been mapped at that PMD, it could be that concurrent
>> + * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
>> + * already, the folio might still appear to be mapped (folio_mapped()).
>> + *
>> + * Wait for concurrent zapping to complete by grabbing the PTL.
>> + */
> 
> I like this.  The one thing we've lost is the name of the function which
> does the zapping, which I think was a helpful detail.  

I dropped it as we seem to have a talent to rename functions but to
forget about updating comments.

This very patch is an example of that :)

But well, I used folio_mapped() ... so ...

> Perhaps not to
> someone who's deep in "how page tables work", but I wouldn't know where
> to look for the counterpart to this.  So how about:
> 
> Option A:
> + * When we stumble over a pmd_none() without holding the PTL while
> + * unmapping a folio that could have been mapped at that PMD, 
> + * zap_huge_pmd() may not be complete yet. While the PMD might be pmd_none()
> + * already, the folio might still appear to be mapped (folio_mapped()).
> 
> Option B:
> + * When we find a pmd_none() while unmapping a folio without holding
> + * the PTL, zap_huge_pmd() may have cleared the PMD but not yet
> + * modified the folio to indicate that it's unmapped.
Let's do a slightly longer B:

* When we find a pmd_none() while unmapping a folio without holding
* the PTL, zap_huge_pmd() may have cleared the PMD but not yet
* modified the folio to indicate that it's unmapped. Skipping the PMD
* without synchronization could make folio unmapping code assume
* that unmapping failed.

Good? If so, Andrew can you squash or should I resend?

Thanks for the review!

-- 
Cheers,

David

