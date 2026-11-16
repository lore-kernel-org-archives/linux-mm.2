Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411A9606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KasOAPd2
Received: by kanga.kvack.org (Postfix)
	id 591A36B00EF; Mon, 16 Nov 2026 09:09:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542936B05B0; Mon, 16 Nov 2026 09:09:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432066B05B1; Mon, 16 Nov 2026 09:09:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB4B6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:09:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ACC6C0994
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:09:35 +0000 (UTC)
X-FDA: 85441165110.20.170F45C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9903100006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:09:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KasOAPd2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODbtba7atbgNQaND0HX62oaqs2H7COUCt0tBvCUahf0=;
	b=4qiSzNVIkr5RRimShLFBI95Gsirm72xnFxMMxDGg8QmjcADuEe93l2hVMA9WL+cY00jsIz
	VPjvDvxwaijx7U2gSBhQcbuCczEDWxJsR9q7YpRz+BkAJwSakFMRVcEKzVlV6Wz8hurw7W
	UJyK0M9ZphcwRqr1pKUEAonx7qzPoJ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KasOAPd2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794838173;
	b=TRa2J9ye4tjl6ewKqSg0rmgdG1Mj7V4Tam7Bab5WW1dbhP8/Wy2yjR1tN2E1d1MnFkizcC
	zuyXUnxZko6NrJt3OpZMO3qL61++6z/B0LZe8uhLHcsEYqk3EIT0ILu41Ngtl10vtlHoVQ
	vbVBkZfYkMod/Q1T5jAgE817f3nlWrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF81542291;
	Mon, 16 Nov 2026 14:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD421F000C4;
	Mon, 16 Nov 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838172;
	bh=ODbtba7atbgNQaND0HX62oaqs2H7COUCt0tBvCUahf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KasOAPd2ZqBfMic3LAWzDkFoKWI99md4EQAz/7/NccCH7tQ7rZexyi03BqiAR1M8g
	 fGA0Cd7JBSlImKIqJ9cBJ7Vnv/H86m8IrLdSPs6KlMX2b6yiIaUzfBnfXtPA/E0125
	 QcnGxpksEHKM7lVbX/PEod3wPmIm6CZtbY80lPd8/lbbaN6vzhY/tfAQYgfXoAw466
	 WMr7lJY9v4KN5aNYlF1cUcqFfKuELMgH7t5QVG77s6ysrIDl63TOBgEo9JXp4mnOTm
	 0a5lbgLOpY8CbatxJ7SwPUxD/H3rEkLeUXS5p4W23n6PBJgXXVg5wexwwG5BBoyGjW
	 YtG2Byy1jZclw==
Message-ID: <41f77b04-432f-40c8-96da-6a8be69a730f@kernel.org>
Date: Mon, 16 Nov 2026 15:09:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <16bb1a14-04f4-4524-9882-20d452175a3d@kernel.org>
 <d1856861-62d7-4bc0-a8b7-39ccfc064f34@linux.alibaba.com>
 <9e66d5f7-ee81-4204-8d62-b06d26a00623@kernel.org>
 <01d59bbc-46d4-4da2-805c-bf540d50eb37@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <01d59bbc-46d4-4da2-805c-bf540d50eb37@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9903100006
X-Stat-Signature: mbdxza7qj83xfuh7en1sc568eoe3fmc6
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794838173-598072
X-HE-Meta: U2FsdGVkX1+JYsmWqLrbCMjabrU6vOhQIHBbtE2JL6PPt39CXZpdrfeF6hY6Q3KJaufOVRHXElCvX8UwnHN9L+7nEADksvgqf7VruSEBon7jxMypf8v1n8MX1tmiYAbi++M2QlUwe/HPlKVUa87UZCdY2AV4ukk0tRSZ1U46xhMF9JKHBwD0CrEtx+x4j79TmqKWd1nPqVhhCEnFSUvvlDsKot+NixxdZ+JvSVB2uCxzMNDB4969WBdjktcy3FYIEHUbVlftHYiMLuDVNDEnjbj0cMO6ZVPU9D/bbrLsaD9AGfXig5fDVvge7ylr1o9nSwqs/2IGuQgtrwaEoMtah/ksiC1JIUMnvUzpaqRTky5HV9C0Gnp2sRPF95Y4AREpGlkoI/fmp5v8TnrcODnptergpsC341YBmRs3G+/SA8YME/Dynur0pd4vmkxIYnS1WkSK3trldR4MATeCr7ecs8VdvqDv9lSRUqZKB/G7fOlfrKaaQJ89ARJwYOF3Z3lWrlRmbzFYbMhLU7HObjoMRqAIEbr8jzmKutMjLeJxBo2WqJVQUct2qI3UlJMtD4ROrNGEj1PjiQI+YjwjrHU1m2Insa9KMZgTEtO3kPrFfnIIG4BYC8Xd4qJYRQDdvFAfInGe1v1GQr8qo9dabW7xh6zgPnk7qrhEfcqCmQZyfGPX3K9HjIIEYsRCtIyn7pJkjRYL1lNAoNsOfD57+NmMS4s6hDFfUVnXbbtkgORGNCg686J+x7SKRAbfq9xn8v0wF6Aj1F4k/xX+M7Q8H9omLpZtwUZwXiIAw9ORFarJ9PgHoKt4JguePjvAmgK6rKEm4NmupcvR+gX0700i0hHvYgfTIaICNEs0UhNOKNKX4hrEp/InLIFEh611h2jMzoXz0CKZ02/i4QMzLLJiX1uqBX/2VuE0cOYzpX2ZwO6KJZmE0zPFi4B0h7M8pA7BVAk68s/hjMs3fLvo3heN7UQ
 ZWDG0cF4
 rUo2JcZAFT7mxRQPmFbftgMG9lw3DVrNZ8ndkR+AWQJVTii1zLfMEwMslIbwfVKWLUVkFHl5b7CJUKZAKK4U/CaYAA/RDgEzClsXDm9xwr3Bd4mnIY6jnKCljkd9Ypq49NobdPj97Oz6dSpVw+ErcMFWB2AztG425XRF7htodakUpuCX6gpsnhMqZVqALB8djD74pOZEZqtnm0abRMh/FtjANJsIFWhmdv8Lln7HZ4Igp7g0Fwg5Ip6RqjcjHV3ndDnq+b08RJCDpj2csx+/8ucg7KVwRtXXaCmZOpxCti0KeENy8vdter1hNVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 14:34, Baolin Wang wrote:
> 
> 
> On 11/16/26 8:03 PM, David Hildenbrand (Arm) wrote:
>> On 11/16/26 04:44, Baolin Wang wrote:
>>>
>>>
>>>
>>> I hope we can merge this fix first if no other objections. As I replied
>>> to Barry, whether to set TTU_SYNC for small folios should be done in a
>>> separate patch (this is a pre-existing issue) with proper measurement
>>> (though it may be hard to measure the actual impact). What do you think?
>>
>> Can you update the patch description to include some of the performance aspects
>> and planned next steps?
> 
> Sure.
> 
> However, regarding performance aspects, I'm not sure what kind of 
> testing you expect. Since this fixes a uncommon concurrent race, do you 
> want performance data under that race condition, or impact on common 
> paths like try_to_unmap/try_to_migrate()?

Right, I think you had some numbers here that would be worthwhile to include:

https://lore.kernel.org/r/453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com

-- 
Cheers,

David

