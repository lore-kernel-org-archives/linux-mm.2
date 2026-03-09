Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D82DEF3718
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52AB96B0088; Mon,  9 Mar 2026 04:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE6D6B0089; Mon,  9 Mar 2026 04:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FCC6B008A; Mon,  9 Mar 2026 04:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2491F6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:59:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 944DCBA5C1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:59:45 +0000 (UTC)
X-FDA: 84525926730.09.00CDCDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DB1EC0007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:59:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vPt6R1/H";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773046783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xDpWle4a6bNwYZ75DXNK0ekC0CHy0E4fGiSSWuMFOY=;
	b=UQQMsUHCd8bfvqze8CNMajcpmGdyEHbIqPD5XXS3vqDPW+dh+GuJ0x1OiuvULEHnAp46ec
	KYThHHcOVF7ww2kqr4yH46mQV8mPCPZPOEE+xk2murVWm0/Kc88pmZR+uAg9WP1glvKNXE
	J4Wh2eipOpnJ4MvfdtyIBryExOA75Bo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vPt6R1/H";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773046783; a=rsa-sha256;
	cv=none;
	b=bjb82yjZTpgArk6iUBiPZtsexi9ACD6XIQPqu4Bqmbid9PGqJjT9qKq7H13K12BAJZYN9F
	rIIEmvJst9Vs19UkS8PBkvfUI1Ej/aRhosW/AjdC8yUsgoV2oiJ7B2hsbC5EKiAGZMSu02
	INozQYwZeQLdS22/ZOIfs5ckO2kWxps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E4C841B12;
	Mon,  9 Mar 2026 08:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193E7C4CEF7;
	Mon,  9 Mar 2026 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773046782;
	bh=bX4xlQ29q52Zuy39lIHfXpnK++YzZXX3b9xKFu0LXp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vPt6R1/HoyVIkg+NIib8EF3iauR8+9F1GyELDtfyyFpbWCgJ+erG1B0hbFgOoZYb6
	 gkykNCgbHGfAN9b8NRl8xj6p1PZyynSsilCgMX6uEmzMvDD4tPhZkUQmsjsmjuPhjJ
	 jsCUsKmHbMiD6u8YCO9l0PQBBDVWly/PoCq388lbINMulXpfPUgkUfTltj7J+fZ/ik
	 2WF+MhDkFjE+WKMhlNJ51FEQSTf2kRRiWb2apmfxfOpTOM6mUaBhBSRJA89G482K8y
	 XTm37GOSOj7so6Jq6y8iwyEx5eKf0d1aweFCHX1I/Z6mrGLqiMReo8AyHGUCBL9TX6
	 +dR9R+6k5PYNA==
Message-ID: <440a5424-45b8-439e-b4f9-9e80e26029fa@kernel.org>
Date: Mon, 9 Mar 2026 09:59:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: implement page refcount locking via dedicated bit
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Gorbunov Ivan <gorbunov.ivan@h-partners.com>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Linus Torvalds <torvalds@linuxfoundation.org>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
 <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
 <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
 <902d821b-e903-4bf5-89db-070851c95a1a@h-partners.com>
 <54cc6e6d-bda7-4c5b-a998-df854ead1985@kernel.org>
 <75aa8f34-4d91-4758-847d-248a5be3db62@h-partners.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <75aa8f34-4d91-4758-847d-248a5be3db62@h-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9DB1EC0007
X-Stat-Signature: t8n5ygasf1f9nqfrmap1q4s8xbxkfnus
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773046783-359315
X-HE-Meta: U2FsdGVkX1+JQDSZE3CyFzvQaJd89kRZwPWcqG2g3+XRCQ8qA/v4h07ibIDHv11kX+6dPntU9XFv3TnXF+DP2FVP4SVejUIGQMu+E6tendzKmZ7PxH0r2g6ITfvdMIuURQYfk6cgvJF0NbFfZj1JGn8rPPdKX10RUG47Zp7qau0pjTWVZw6bFdq5jKk6hVC4/5OHgWiRi6X1CylbycXcDpZMR2Q2FUec0ZRd2ypI4AbMsQB/uHkEI6s1s+gz6c2l5muQc2qd92SSMH3Kca7yaueXZhbWl7aRubOl6Q24nY3a6jT9112t1Mi30/Xh8VZqbj8/aqxbOehmCV+3EVANHJJdrQGUbtnqxW0TBxVeIJZ11dEdooLGnNjtiouS6lBh96n09BiPSCNbgAW9BJ5OJFMrQ2Yff3oi/C2xscpp+yLKQfr1j1p+wagb3+0LYZ8IDw9ceJStf+kqe6VRwle7evFRj3PuZFLwPpSxVzq3I9PiYJoDXKHLODcIY2FeQbXEONrru381prI16RX8IAWrI7fd5jiBgJ4bkLuEvDTk2y2XsX2fCt+0qqWSZpmqZBBfEKKJ1sWHl2nM6Q74rZnkVJVZfsVT3Ks/AsNgYcQyRfFyFQLzV1sF1FA8ItSc/n+OXXNITA/LHz2Fh07KIlEwdYn5xldBTeRzElCxnkHK75CpOZ9ksLhkBRAddv+3nxokNQCRDwP85NXVbHF/I4fuEaLg4Vg48eCd7Z93akZG7ruke+CeRGSntsF0ZO8vagJquJ6N4FtP3OtAIABlx+otLlriL/JA49c7NdVuXNK4ZVARvfSsXmGzLps7QlVe6ajrMf0RNaonRg3BkcKa7z/GWDPjevDz51JF+pOJiwMHZ1l/YLDH7qxd7nh4VO781gIDGvs1ViZ4COe9EkUukcYbZ0YEmHn/va53D66f/yKO474d/yO4KTRhyLro5EVy70qrx/EWQ1zFdoDU6fMe4i1
 7KlX2GhF
 eZFj4k7UtkXAFk7L8KyJ2UVEkDIMrNxBRNoE//PnohbR1IuR7YcuASBhMJLm9rk5O1XlH//AOCpL+3N7G9HntaYCUXZ3ydQp1DvCcRpPr/YdaSnHHTYpnUoc1wibgIU3oKy1Jdw86nRRRGZkNmd11XoQHauSDb1J4xdsuRphAZ5ewstBiPVYhAKD+pnxXzW5bur/n3wz3nTRYC2qlfJb2RCG6iT3OeG4FMG3QUEnHrlAkfnwX4H7RdyjOKySKJBACcRp9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 15:29, Gladyshev Ilya wrote:
>>>
>>> You are right that refcount = 0 is tricky. However, for a bad outcome
>>> you will need:
>>> 1. Some external reference to this page, through which you try to
>>> increment the refcount;
>>> 2. set_page_count(0) somewhere between freeing and "it is safe to alloc"
>>> state.
>>
>> That is way, way, way too dodgy.
>>
>> What you should likely do is
>>
>> (a) Make set_page_count(0) set it to PAGEREF_LOCKED_BIT
>> (b) Make any places that might skip set_page_count(0) to use it
>> (c) Document this all extremely thoroughly.
> Okay, I agree. My reasoning was more about "it's not _that_ bad if we
> miss something outside the allocator" than "everything is fine as it
> is", but maybe it is really that bad...
> 
>> Alternatively, disallow set_page_count(0) ccompletely and add something
>> like "initialize_page_as_frozen()" or sth. like that.
> 
> (Below are my thoughts, not active proposal)
> 
> Actually, we can keep "zero is locked" property if we change scheme a
> little:
> 
> If we invert locked bit so that 0 means locked, then we don't care about
> memset() / GFP_ZERO / set_page(0). But then there is extra bit on each
> active refcount, and (un)masking will be required on each refcount read/
> set/etc operation.
> 
> We can place locked bit in the highest bit like now, or move it to the
> lowest. This doesn't make any difference except for how masking is
> performed (and or shift). I can't really tell which approach is faster
> (and more optimizable after inline).
> 
> This approach doesn't look appealing to me, mostly because of redundant
> masking. So for now I will try to add proper initialization /
> documentation in all risky places.

I agree.

refcount == 0 will only be allowed temporarily while transitioning to
the frozen state.

In fact, you should then rename PAGEREF_LOCKED_BIT to PAGEREF_FROZEN_BIT
and page_ref_add_unless_zero() to page_ref_add_unless_frozen.

That then matches the terminology we use for inactive refcounts
(page_ref_freeze(), alloc_frozen_pages()).

And it will be a lot easier to comprehend compared to using a different
"locking" terminology when traditionally the "page lock" is something
completely different.

-- 
Cheers,

David

