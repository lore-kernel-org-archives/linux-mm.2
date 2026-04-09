Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6BDEA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279B26B0005; Thu,  9 Apr 2026 08:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A546B0088; Thu,  9 Apr 2026 08:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1407B6B008C; Thu,  9 Apr 2026 08:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05C276B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:48:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3425160765
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:48:30 +0000 (UTC)
X-FDA: 84638995980.21.8F2D8C4
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAB791C0010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:48:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N58DRV0l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775738909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsDQYaBb80vPizdMN7gGIHoZqJFZXjCQHHQTYzLrH8c=;
	b=w7s3Tp3C+p03jfI2hIyMXQYFYrGcPzk6SX+F7ipvt6kUkjPm7cqXmqK7gb0wnICB00dazy
	Bee0JoOakqY5eqqbkosoG4z53t8+BsM5UfdekzntZVvRkuv7N0iK6j8fGjBe2UEHfJUI1r
	uLu1afLk7U8FOj6LmiXjBKMUfcBtql4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775738909; a=rsa-sha256;
	cv=none;
	b=7uLfqhciUKMbiIBcXsJl7J5M5wQMS0zze5XuT1J+jNu4eeTu+D2+N+A9++wS2D4siXRrLE
	ey1nkJjjptIQf28nz+TAKTmwBEce4Inqcg8FCvoO0E0Deg3nC2qZI/V5PIZFHqFxaPqxkn
	65fWqS1fuGKqDYTGlQZHrZIb3MxxJVM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N58DRV0l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <9fb076b5-ed33-458d-b39b-a2de3433a0da@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775738906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wsDQYaBb80vPizdMN7gGIHoZqJFZXjCQHHQTYzLrH8c=;
	b=N58DRV0lqQMRB98jfQIHyX0PR1r8vfmdZbvQlX7bIk4RgD5Wfb1wM8xheil7ZLjaVplT/E
	s2RSV+kXmM2OV94QFp4bMptKc2N8nO7u3rlLIWbDicI7WEDlkv0GkdF4rWovVtYeXLB5UM
	OH8hilcKSz/LsY3bIUt2nX38zb3DXFc=
Date: Thu, 9 Apr 2026 13:48:14 +0100
MIME-Version: 1.0
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, david@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, fvdl@google.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org,
 Nhat Pham <nphamcs@gmail.com>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com>
 <3f9e8e12-2d51-4f2a-ada1-994ed24df284@linux.dev>
 <adaxWs8BjCJB1aan@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <adaxWs8BjCJB1aan@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BAB791C0010
X-Stat-Signature: dy3nbhggmcq9bit5tj7sspyg3uzh9azd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775738908-475524
X-HE-Meta: U2FsdGVkX1/I/gTiUuFG67aUmbqBYSXZSDiQSxQE6mm+YBi9XxO22SW1x1JpxnRhXoINOY27E36KCRncDQ68UbDTZSVMdi08W7k0bOUS/jH3TIu/Irec5i1fv9UCjGvWIm7E/fW/9NIDbQBpGXuJV0+34sXbg3/oRs0q5+J0puN8ydB0BDCjSDLxja+1g8b1X5E4P/9PhlUdLgWYkdhkk4L1gIjd1XnA3jIlA7mLhABnLAaOCSoWBgIUQE1X56BTstZPRx51qgVVu6Pn+3aBWwr8sjLL9Qj0znSpXBlMdVsV0x/3FmwW6smps3Xohi3uIoyTLmxTnIZ722MlxMcCKiJliT/TFE9EXMcXjBrJfY4Rlx+lFK74d5AFhiowmq61PbqsAA9dbUvJvnnKcMuPdOGYXJq5xkYcahwDV4cLhE4T/15myqCfF7kY5tPgEo8Mx7Cc4JaEiANsXvxljvhN1+Qz20fp9Z3XYK7JD5EWUOKJpK2ZnwEyRtE3smmQCuFkjbEybWeyLD+u1sbUa2OgLk2cbm3Yjs+uqy9UPbwYIOsKpCUpVMEJo/uvlpw3s1xmd4eR4opbiK5w06HyZxh++yoUHhUqcPwSqHbJU9eTSh7UjTKLKf+QwLRnMYU4j2+KTZcjTfiwQ3oomisilnru4WEQzpdwAdWUcjlNNC539JlmLxTf6o74pW5rPSsDqhl7AHjVw9QQM+GmBNF9p+RApZoh5rOOQyQZLNheRIGcugtI92NiTkGezXhCI7Dde5xCuFc4ty4HQKR+TBRTFWeib6aOhUgzt90t6WIQ3oLm6YC1pHhgDRNz0O9M8r347yPPdVkvpROjPz7KkGkNN9Oe8CPSTo4o2wdotflAULIXJQk7IMLjwUNbSGzpUdL1M1EdRppYHGe0IoIH+8qfkA9EvzFslidTG83l3q2IaAMSRYjj25eUN6iUHy5YXCYg3pwHPfW6w6rWhHCsKQ7Hztf
 2m+KbUjy
 //bI8/Cv/8jwRGNbIikBPEDI12G/kUp/ZqtfNDKmj5Yi0z01FYBRFrPtUNmTx/+T+pb869J7/zSkXnt8m43VewwT9Hq4FjanmSaVEwLXIuiqy/YK6X93C83Bo6WrwzTPEperisgVBC3E4HkB4+gSj2ZhJGbuiMMRc9n+DmtWy/FYXww+0CLJXwkzW4Xg+evsy/hTS3AyLBh8onM/H/L2FzrU/YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/2026 20:49, Matthew Wilcox wrote:
> On Wed, Apr 08, 2026 at 04:06:29PM +0100, Usama Arif wrote:
>> On 06/04/2026 00:34, Hugh Dickins wrote:
>>> What would help a lot would be the implementation of swap entries
>>> at the PMD level.  Whether that would help enough, I'm sceptical:
>>> I do think it's foolish to depend upon the availability of huge
>>> contiguous swap extents, whatever the recent improvements there;
>>> but it would at least be an arguable justification.
>>>
>> Thanks for pointing this out. I should have thought of this as I
>> have been thinking about fork a lot for 1G THP and for this series.
>>
>> I am working on trying to make PMD level swap entires work. I hope
>> to have a RFC soon.
> 
> I think you may have missed Hugh's point a little bit.  If we do
> support PMD-level swap entries, that means we have to be able to find
> contiguous space in the swap space for 512 entries.  I don't know how
> hard that will be, but I can imagine it's not that easy.

Ah so my understanding is that with CONFIG_THP_SWAP enabled, the swap
allocator already tries to allocate 512 contiguous swap slots for a THP.
With CONFIG_THP_SWAP, each swap cluster is exactly SWAPFILE_CLUSTER (512)
entries in size, meaning 2M will fit perfectly. Clusters track their
allocation order (ci->order), and the swap allocator maintains per-order
free lists (nonfull_clusters[order]), so THP-order allocations are
directed to clusters already dedicated to that order rather than
competing with base-page allocations.
The per-CPU caching (percpu_swap_cluster.si[order] / offset[order])
should further ensure that consecutive THP swap-outs from the same CPU
reuse the same cluster efficiently.

With PMD swap entry we will change how the page table records it
(1 PMD entry vs 512 PTE entries). Hence we wont need to allocate
page tables and would help to address Hugh's valid concern
of have to allocate pagetables if there is no pagetable depost.



