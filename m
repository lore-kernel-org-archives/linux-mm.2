Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3933ED2592A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E5A6B0088; Wed, 28 Jan 2026 06:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCAB6B0089; Wed, 28 Jan 2026 06:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BDB16B008A; Wed, 28 Jan 2026 06:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08E356B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:06:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 895B78C00E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:06:06 +0000 (UTC)
X-FDA: 84381093132.29.A1AFEE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA9A01C000E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:06:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BOs/QAXu";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769598364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zf8bphARvjwyCJNgDhtc3R8OR9R9on3FHl91+1FUh4=;
	b=AIBuZmOlftEITXkXGOcopkqkqMCEt6dwHtpvtoBjkC7PWYXHwP0fOxcHh2eSPFFZX4F6G8
	7C9s/GGOnhB/8wxuAXYeinUliwp3I6Gs4nsZCV0sX0XgrgXdF6ECE3QzuPEn9u1RecryHZ
	3p5g/nyXDLhXJyAMeOvzepNDpN1+7do=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769598364; a=rsa-sha256;
	cv=none;
	b=k71FgQ5MQcxCQwmbMcx918dpkWg0TwrC7lNYBz7JVNUs6yWnXib22p2rMNjwDNNpcay33H
	Umqt9UE5pAvmVATaUleC1qZedeG1C0jEBSm1nxOfnUuvoHHuUw003wNIXLaloaVj0RNt5b
	SdOHcwl2VV/CQkwuSR6/zqa8HmxGIiU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BOs/QAXu";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10ADB600AA;
	Wed, 28 Jan 2026 11:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1529FC4CEF1;
	Wed, 28 Jan 2026 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598363;
	bh=Gjt8lgXuT2Q+uH4BNSaY0b9kHBmCuFAfAJJFfv/GRq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BOs/QAXubVbxE6z5l2UJT9fdSsiXgh5Zczv5zLmE2brGRBvTQo77nrIkRh2o0BykU
	 Bl1IpceD1N/hniO8XpiOAmH8DEmHkiZesvWLMZHMAL2U3tmLrofrfDR/oRepurFJ61
	 huZgDYZJY85FPtZQoUF0PBnDAH6NDKvYi2zo84QCcis8qBd4Vqpo9iqD0v1YExJk+T
	 IViEkRyUVXdxe3P4JlWjYffMUjrPDc85/q5KerGlXE9+8OrMdVloQSNMua+I8OqYqp
	 9OkWUMmhYDMFoOYSB+PNSpb3MsMQO5DuDuQb1IbYJyUr60fQPOSQrNJ43BKTJMfipq
	 R40cg4IpRJbHQ==
Message-ID: <f1cd2fcc-e3b1-445a-b845-a338ef1f54bc@kernel.org>
Date: Wed, 28 Jan 2026 12:05:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260126183212.2366596-1-ankur.a.arora@oracle.com>
 <b7549e2a-e5e3-4052-92d9-1e7361b52b78@kernel.org> <87pl6uei6l.fsf@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <87pl6uei6l.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CA9A01C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: otocrtabqjonmgd8j3uc4rt7b5nfaoyp
X-HE-Tag: 1769598364-713139
X-HE-Meta: U2FsdGVkX19+L2Sfmcayz9nr8E2OEXA9Q1U7OZjhMyrQL2544iQCKOImhuPSVsH5a6UC4vpMprxZKIuFFLiUF0BpDI+wg7vbtdJXe60fgWDFQleC1knBpZLmTDOriHdfT2Ry5zWzkPyotPCddU3fZk8RCAOoJ3ge4p3vmOQSPo54anXRVMZvEvfeU0hPttvS2+g16rkVzXhzAUeKdo2Kb4dgJrVgEv/RvX55J31mK5Uc4Zlmv5fCXdiZocKD/lqj5Aqqx8BKRfYF/TGJRr3bc+W/RN91PWVzvoM4I4LQBgqSPAsMjGS9Lcw6ADPAEhGwxjqQ/UJFyOXJjc6Hjo0aKGxGtGEDMoOrfwH3jLZuuUB0VigIT0Zs8idGAvMnzYtL5YtOOHuqQQPcFPZDmMv3fgAevqdgZUr13MqrT8K7UEWbvWOmSg4nIyvOcxB7WdQhTTkAf/8EGMnlKdHpP+sG9Ku6zTtQL+UZ8wi4T+r87ghpV8Ru3POWsI+p3ZqQ8WoTq9Oihuc2NFk0hIWPlsiHKXZsXd5ogEIwn4AfFLUnzRHv/rdhQzXf74tzhj7zyeRLxEJMtkng/5JIi1n6oTR+KtrhKbdPkkmisLcCLfnLreY8a7ygakypcq3QOFNAEqYbNztUqPNIjXKc0S8gMZKbqxU2+M3O7E1E5GgyYoUcXzzHTDd2W9io8qCVDY2z1qbRcQF0k4N0vY857y85QO3f4yoz9S5naT32HJoO7nEv1kzuvttzcGwivkTBo9/WdaX71sPNHXPV5TwHJWFPrI/P/aTuXQw5ZPQMWjUiVMz3GuWZJVJufK2o2om2c7h7FsRsqPxdySjt1jzdPk2AFLFXwIYbcv3CCnoHrUGs0tjGg6ibRV2gBF+RpdPGd1JtheD9JH9OzIntVJetqEJ625hxkKT5qrfRsndev7cjyq8U1m6xgs2h0NlV1Hdz2Q6fPhrDBS2oeKbG0jhby+9qKzy
 N/8HWIW4
 LsbTca3T+Gi1Lih4WT0OMfWtdEs6mZAtnNQ2eWwcUBQVOq/DMUvNCsczpQvYD83/NjshMVoyl6PHUQH1rYomppnfPZ4Avn5TQseYKqMZwzFWD0drs+Eie6Sto4Z7GSS++1GHQUrUpb0qTZLs8+xSQHE/EHwktiz+OADNMgcLYJvYDivE7UIxAxESwY+iO6dVcNsUX6jtmGtohhpuWZVA4cxCpzaWz9usMSfUjqEjN411Yb6Bku59BFvAg5FqN7FyoOcjTLCumE6vXqP17B2MNnfNM5spGH1aA9qCJstungp0IGBS2/aJ3iDhJ7X//cC9kG8hLMLUdN5iCtoP+k1xfY8otuKBAajCdVYpTe3E1ZJJX7RbRMNQKRbPrLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 00:42, Ankur Arora wrote:
> 
> David Hildenbrand (Red Hat) <david@kernel.org> writes:
> 
>> On 1/26/26 19:32, Ankur Arora wrote:
>>> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
>>>      r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>>>    		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>>> where it decides that pg.start > pg.end in:
>>>     clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>>> where pg comes from:
>>>     const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>>> That does not seem like it could be true. Even for pg.start == pg.end,
>>> we would need folio_test_large() to evaluate to false at compile time:
>>>     static inline unsigned long folio_nr_pages(const struct folio *folio)
>>>     {
>>> 	if (!folio_test_large(folio))
>>> 		return 1;
>>> 	return folio_large_nr_pages(folio);
>>>     }
>>> Workaround by open coding the range computation. Also, simplify the type
>>> declarations for the relevant variables.
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ---
>>> Hi Andrew
>>> I'm not certain about linux-next rebasing protocol, but I'm guessing
>>> this patch will be squashed in patch-8 ("mm: folio_zero_user: cache
>>> neighbouring pages").
>>> The commit message doesn't contain anything needing preserving if it is.
>>> Thanks
>>> Ankur
>>>    mm/memory.c | 23 +++++++++++------------
>>>    1 file changed, 11 insertions(+), 12 deletions(-)
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ce933ee4a3dd..e49340f51fa9 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -7282,30 +7282,29 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>>>    void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>>    {
>>>    	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>>> -	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>>>    	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>>> -	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
>>> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>>> +	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
>>>    	struct range r[3];
>>>    	int i;
>>>      	/*
>>> -	 * Faulting page and its immediate neighbourhood. Will be cleared at the
>>> -	 * end to keep its cachelines hot.
>>> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
>>> +	 * keep its cachelines hot.
>>>    	 */
>>
>> Why are there rather unrelated changes in this patch? Like this comment change,
>> or the movement of "fualt_idx" declaration above?
> 
> Yeah, that was a mistake.

Given that we cannot squash and it will be an independent fix, best to 
resend a minimal fix, thanks.

-- 
Cheers

David

