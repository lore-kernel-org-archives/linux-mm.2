Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F4DCDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DE96B0093; Mon, 22 Jun 2026 04:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735036B0095; Mon, 22 Jun 2026 04:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B656B0096; Mon, 22 Jun 2026 04:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5D96B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:15:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5217A05CC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:15:11 +0000 (UTC)
X-FDA: 84906838422.03.3E2A9AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DB7C92000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:15:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaV52Ft+;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116109;
	b=0WWboUQNXqm2f7I0qjxUjEto8Mhyqfffw43u4TzjnmxJH3Rb/aUKo9YfU7Jc91FZgLGVtX
	ogn3XAhJLtMl1JpgD5c99TZBVx/wjrVgTSuIPRtcHxUxP6quF1WdNo/fYgbMYyXg4m2nAt
	zND/+hFFnCf7XW69T1hNpLI4O8x2JYY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaV52Ft+;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7CiEqdgfo1EMG6k6a44m/PMxSYQ3XbZcJ/q6HRDPVY=;
	b=bucJQKemnYRDOFhgvSpQTJteZQ0vv9tOsJRp5fUuJy1+7yQTgP1cZs8hgHriBWeHJuin9J
	FMFWIsoL5q4oo3QDrUt34BCJwfmQb9Vm1uyBpQHEF+y3Rr9hG+NQy/5LPlobX6hMCkGvAU
	+09xzDpqoq+DdWUMHNiaoh1woZGTBAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75E446001A;
	Mon, 22 Jun 2026 08:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B381F000E9;
	Mon, 22 Jun 2026 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782116109;
	bh=I7CiEqdgfo1EMG6k6a44m/PMxSYQ3XbZcJ/q6HRDPVY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MaV52Ft+ZtcIY4Zuk+MIRru0fDYXiE5R1ETQs63VzVzqC/868iLnr54jcWhhbHiiA
	 quoRqbjsVr//YKLPI/WhBotOpkjMcrdm9yqthzb7vTVTUmIhtwt3WcXFgdc1MLn8gb
	 8KN3YkDiMgGPDBBvMVzsWN8eigVYSyJ5amadlyaLDudFWOVs7J8L41nAdDi0XgbUEh
	 iQW0/+nsPcwpMVBJuoS6SfaRIFvTyDh+Axq3mU6SRBVnEI3/uGhjDv06aaLy0Ubu9V
	 KzBI+5Vq3hKWaQGR1Lwg1mKpMn0Y7Na2V542ESOsvsjOnM1pD1YBojI/Dz1YIAAgl2
	 t6sA3VDUcAm5Q==
Message-ID: <086b119c-b777-46ae-b087-798ca3e44ecd@kernel.org>
Date: Mon, 22 Jun 2026 10:15:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: Linus Torvalds <torvalds@linuxfoundation.org>, ilya.gladyshev@linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com,
 Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8ime39hiye3rcsbwc53zs8pohj1o9syw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB7C92000D
X-HE-Tag: 1782116109-474876
X-HE-Meta: U2FsdGVkX19ZXPX/2zAl3X3JN8PAYy6px3//Rjb1YFPdwkTu22pvwPwFPiGOIegN1N7WV69baDYAoNXj19fpkGv8ZZeu1lEddO1zbo8ITCorycvIkgCLPF/va/mZijv96ffTlPnavp/ZMYUNvvbT/TqRQHt00eZ5xn0dHqiK5OlDzwpqBKPQCEcvEiVaTvD3/2Ts/fJOgiYyxLrdGPEG2sGjgI5jCe3z1FSb4hfxvVgiPIFVCDEjmmwPp71XyNQ/42a/ibKuOQH6FEXFtRnhXDh0s3V8Z7Q+JgQLVHk6XjALwRs7QVsU5Lj7SGWIMZkw4YczR83Idmig9/pfaBlxuiJTWZWYgmMofg4e7ijqnccA+Zqzl5Jp4pxu0ow7EszFN+hwYdHFfiWLqStqnCXywe6DUQY5ercsiK5n4UoXcJGO1fDHDPFPlSsHZUwlCUVo238NtxsPvBaI0jmpEk8jkssaEyAM9eXLS7W5vyKpsduEGiLkyZrpD5zIadW96ke4WrQeNKR4AulmPbAKAi/ScpGphTQC7sG0djnQjzNM+RA3DOtQ8X8rcIqFkDwNfJcLrV0x1F/UzBqbQJnqF+Lc9NfVh9xfIjrbb8AgTkUHRvLRJRWA/us3PEV+9tiWPt3tfbzUSLUV2N8jJWqrvyk0M9dJX92GqxJTG/DKnfy5Oase0gr0giikWgsPvwJ6JYyFFMr4oG1RBxE6vdDi714lgg9oNK0jAHmDaQSno7EKnTuT84xKlzPG5WqboVvRBJyxYQ9ACldSl2xhWjXb03TC81eGtYXUZhdAB4SpSjVdLvILoTHUItnWPnm1/+zb8jhBfdNh+So1o1KZzTlhp+YFmSdeRbupG2rE6fv2LMgZpR5jh9GJNH/7C/vnDv31UPpsy5p5o4B7/RpQ3ryVIFxnc5A9IvNimclJFgTn2fnC6gWHNxcQ48iHzi6rwuwRt0F1xg2B0XKfyZXtobr68SH
 yk2jgXJX
 JpswaRGM1d6QCTZ5tSPTGwhU5fI3dzmRFikWCelv/UUQiD2dlQ3aIQW4N9Ni7+u5FI1uAvAnwwfn7qsEtF/edaRiADsW0oMZOE/RVLf8Ua8IGGDqZOuq5qawYc2vx34xHPRj0+e7Acf/Ga79Pv4ky8t6zKB6TME7sVOKvkdyvxDPdjYKQ5iUxGpu1nsPiddj1fGHXAa2+hvi68tHSTr/37dZngK+f2zKRFQvZkvOfJpiDFrcGB0jKIJqI1/1RSMh989/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/21/26 06:46, Linus Torvalds wrote:
> On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
>>
>> T2: optimistic get() [0 -> 1]
>> T2: put page back [1 -> 0]
>> T2: calls dtor for type X, returns into the allocator
> 
> Which optimistic getter does this?
> 
> I didn't go back and look at the series, but isn't the rule that the code does:
> 
>  - optimistic get
> 
>  - then check that the folio is still valid (*not* using the page
> count, but by re-looking it up elsewhere, typically the address space
> mapping)
> 
>  - put the page if it wasn't valid
> 
>  - if it goes to zero, there's no destructor inherent in that

I'm also confused about the destructor aspect. Usually we have

	folio_try_get(folio)

	... some checks

	folio_put(folio);

folio_put() is just:

	if (folio_put_testzero(folio))
		__folio_put(folio);


If the thing was a folio at the start, but stopped being a folio halfway through
folio_put(), I don't see the big difference to the thing not being a folio right
from the start. (folio_try_get() would succeed on some random page either way
right now)

Which destructors are we concerned about?

(1) hugetlb destructor

If we grabbed a non-hugetlb folio but suddenly have a hugetlb folio after
folio_put_testzero(), __folio_put() will just do the right thing and call
free_huge_folio().


(2) pagetable_dtor()

These destructors are called when we unmap the page table, before actually
freeing it. So it wouldn't apply here.


Maybe it's about something like

void page_frag_free(void *addr)
{
	struct page *page = virt_to_head_page(addr);

	if (unlikely(put_page_testzero(page)))
		free_frozen_pages(page, compound_order(page));
}

Whereby, if it's a folio, we wouldn't do the right thing as we are
not going through __folio_put()?

-- 
Cheers,

David

