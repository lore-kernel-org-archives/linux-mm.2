Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59555CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642A86B0005; Wed, 10 Jun 2026 10:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3386B0093; Wed, 10 Jun 2026 10:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509C06B0095; Wed, 10 Jun 2026 10:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41CDD6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:44:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7666A0121
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:44:50 +0000 (UTC)
X-FDA: 84864274740.05.A03FFE4
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F26180018
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:44:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VDBTDO3B;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781102689;
	b=Gn8FNJzpQW2KvHckAaXt+e3M9NeuDTQU6LGVHz9PhpMFL6uhacKydNaz7iDJFKE5TxKViP
	zXb6y5KM6NUJrh78nX6ltUm76qJotMoP9/3ICRDifAZDgBabZCPy3AceLh8QotL6DpviN/
	zoEmlMTWBamw0ANiJ/IXUng63aP4NG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VDBTDO3B;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781102689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzCn6b6UmGM6MN4FH8vAmI52xJGSimW6RiYOs0ytMMM=;
	b=gekD36RlUiBa1IrM/dbqjtv0m/GbGBGt2Nq4z/ok5Pc8M25zp0H/P5ZgJC4MGigMnbKV/p
	YiSzAgJqI20pW+4d4I4S1DGO8ccnEHTT37VjzK6AA9s/4dnF318EVLeZx/II2fgfvkqZPb
	e9YX6tq8lDId4StANfyPDGWfIMiJ0S0=
Message-ID: <680441bf-c878-4a00-8787-63ad8b201bc9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781102686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BzCn6b6UmGM6MN4FH8vAmI52xJGSimW6RiYOs0ytMMM=;
	b=VDBTDO3BAO6hLxi6iOc37vvpCK8wGKr7CNjsD8rkNY93C1/iuMZNJuNRr0td9oEtwgmeIg
	MglagS7vWDJ8altcBd213gMQRPhdBhAPyhLMxhOQs+gTPzB3B3lUlj5/iMCMZFjR8cvqzF
	GJYMGtp/5o1EArf4Tl4AZzavsTiezLM=
Date: Wed, 10 Jun 2026 15:44:32 +0100
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, ljs@kernel.org, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 chrisl@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, kasong@tencent.com, ziy@nvidia.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <52cb5ce7-ece2-4e52-9e4e-5e476c34f8be@kernel.org>
 <1acea238-0495-4e2a-8026-22d5cbdbab21@linux.dev>
 <14846f4d-3d23-4f87-9d87-05bce67f6f99@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <14846f4d-3d23-4f87-9d87-05bce67f6f99@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F26180018
X-Rspam-User: 
X-Stat-Signature: umypcuekwbmozeo58xfy8msate79mxfj
X-HE-Tag: 1781102688-9441
X-HE-Meta: U2FsdGVkX1/iTo+f5d5s6WvyKn9r/VHmmdDIOUCxnAxmzC+KBGqG7bCosSDXnhdlLnFHX4ayUDAVoRbTPzm1tHTi+11nl34hlpkQW1t95a2j4ubw1gy+faF0nXzwB5GAcSt/wKnLpbTgQ40P74F/Wnl+IkhULfME/YtG/spk8XwYw4FMNhztHFJiFG1sxvusqHg3snwYB2bvg7fx1GBJLXs17p6cTcEAPbzj/m0GmF8oj7FVYgydUlAvd+iMZ/lccgfqhVdzj1mS5RLUcRo76AGC0LJ4hwsv2lz7MzZEcbDCftcKExL+TR94mBwOQqhGGpMDWsOpxtqU2dsersu3xw2d8J9Wv2sNpT+Pcih6KUevOmvh7FPF1c8iBXNW9GnEyvcOWe6LJZZ+9gFBlMf9q3PO6kSyKUiZ6ziB3V/PeWyFKQ/rI02MyPHvnG8c6z/iWtFQlwYkolnuNKNrFvc5QE1/gsC8DSXC4y3Cbi9vLIhuJyLebaV0FcKNETqpbNSZoFgZWZ0H5ZFLm5Sv2womjcvRKQqAZVe5dSW4TeoVvd2eBu3VtdchR13sCHpHh4+EPjWJFVgxU/c5gVn6dJnqJDpN+FFNKPXd9tIddMLWyb8VlHah+h3zQ6kexN9DLoVNkoMcjzVr4ueUJimOqLcjmo5fJVH8icwGUfjmg9Hg+6q6nqk5/Ea3I4n7XCS4fMm4SBD0p9bqzNVaEZQ5krIkrxe3044P6njfMCgWQc1GePd2ds9pCiT/uLimop2h+wMmsWLd2yjYiIRpDAdbBC0z6Daks80nEN46OQ/NkwHyDBKQ1F4jm/EVcw4sB0yvd269mlNM20AmR530sFNhkjySe8NpTBITJH8iVNkiQHhOt5bngGj3L91Tnq+bdSSa2iJxlDN40qFvaDbYxpvyWPDhJH4jnxkEMU1YPwJMGMS0XYgfS/9fbXWfMu/sU3YlLdLjtHauSS7J/1d9Wb40614
 4fbmAgPI
 mUW+dzH9XLPQAAAeXXaWl9lY/Y7sSal/C5X+asANU3yoMqN09xO5UXumK3zEB97BMbp3o3PpM1wVzofCr56QnQLTJcQhizd1iJREXwigHwuE1lvUY/a0qVo4j21nVy1pzfY4EWBHX27DdLwK7O+trNSxhM68hwST0slWH/2FnYcvg/9tn7sJ9WQAK8uuIKtM6aH9i606Vor8cBV5oSZSAAr4OcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/06/2026 14:48, David Hildenbrand (Arm) wrote:
> On 6/10/26 15:01, Lance Yang wrote:
>>
>>
>> On 2026/6/10 20:24, David Hildenbrand (Arm) wrote:
>>> On 6/9/26 16:29, Usama Arif wrote:
>>>>
>>>>
>>>>
>>>> Hello!
>>>>
>>>> Just following up if there were any reviews/comments on this series!
>>>>
>>>> I know its a large series but was just checking if there was any
>>>> feedback?
>>>
>>> It shall be reviewed. We just finished the mTHP khugepaged review to get it into
>>> 7.2, so we've all been rather busy.
>>
>> Right, mTHP khugepaged was a rough one. Glad we got it over the line,
>> but yeah, there's just been a lot of THP work lately. pretty nonstop ...
>>

Yeah its definitely a lot. I have set a target of leaving review comments on
atleast 2 patches from mm per day myself, but even that can sometimes be
difficult! I will try and help out more in reviews.

>>> (I mean, just take a look at the THP-related flood of patches we are fighting
>>> with on a daily basis, it's not funny anymore)
>>>
>>> This is clearly going to be 7.3 material, so there is plenty of time given that
>>> the merge window is about to open soon.
>>
>> Usama, I'll try to make this one a priority too. Looks interesting :P

Thanks Lance!

> 
> I have two other bigger series to review, but I should soon get to this as well.
> 

No worries at all! Thanks for the reviews! and yeah definitely 7.3.

I will send this out again when 7.3-rc1 opens (rebased), so that the reviews wont be on
outdated code which could cause some confusion.


