Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F73B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UjXfD7pu
Received: by kanga.kvack.org (Postfix)
	id 32A256B05B0; Tue, 17 Nov 2026 04:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3AD6B05B2; Tue, 17 Nov 2026 04:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BCA6B05B3; Tue, 17 Nov 2026 04:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E556B6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:40:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72429C0378
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:40:44 +0000 (UTC)
X-FDA: 85444116408.11.258FFC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81C2D40007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:40:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjXfD7pu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8umLBLKAHg6QG2ihVkSrV333T4WbYEUzC3ulFYXPO0I=;
	b=JMpWC3BmnVmI+9GgJ66UrnlRXjCk2n2h0TDyOQSdrnTF10hwJhd1/nlqPEJ7uvwuhB8WPS
	wLpeZZA9lE3lSNItf9U9GBdRHMftcGyxOzU7s4FqGzv/I+Vl8J3wHmEFFTHzjwkXAob7aM
	6eBh2SVFgB1nJaRJB9+Vw3DNq9v04T8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjXfD7pu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908442;
	b=mtNswGbfMXBiKn/jTulcE8vJDhj2H8jJW2lw5sUUh7p+912x870KAhChcVxAn2hxUJ7HLm
	VtljxgqeJC9o3aklT/Mt1D6q325WduOU2FAlmg17xMmS3MSqi8I0wJHf0q23waK92M51jI
	FIXa3+oAMoYbTZD5jOEUefF3pw7LTjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24A5261382;
	Tue, 17 Nov 2026 09:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1822B1F000C4;
	Tue, 17 Nov 2026 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794908440;
	bh=8umLBLKAHg6QG2ihVkSrV333T4WbYEUzC3ulFYXPO0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UjXfD7pulFeLrf4zmQTgj+1Mchb+C+9SCZT7V8AcOtnyMnYceyEgDOmz/bcbjDk5U
	 FilGiubgdxWBKUxXWRlI7Q8yzbsb/v8SH107M3LnwSbhMV3xHGsFTQnGXnbwrpRKCN
	 X3kpk49DrC0hYiXFHQX8kciQuwkZ0UDOEHsXsqUE/lQU6ozKAnBsQ02yDSHpDss8os
	 nrYkVuDajV5sx/5aPXovJkMxYXbhKaWq2fNQLlFKfMuvBZwHqpVUq/M/hQWujL6vzX
	 xe+P9A8ldADfbysCJGspWrM3+yvg7K8bUR+HvfK4gf4AAdnJGp9M5H90obiJ+444lq
	 KL8gCOe5d3cug==
Message-ID: <e849c774-875b-494d-bf11-6810800fdcb1@kernel.org>
Date: Tue, 17 Nov 2026 10:40:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: mark a collapsed mTHP dirty
To: Daniel Wade <danjwade95@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <dfbf361e-8125-4f8e-9567-65e80996e2d4@kernel.org>
 <20261117091018.63639-1-danjwade95@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117091018.63639-1-danjwade95@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 81C2D40007
X-Stat-Signature: odehez6pgnmthhzrkxswbz1fjn14im97
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908442-510104
X-HE-Meta: U2FsdGVkX1+TEA5+NI4dRNdeSt6mlquRFyQPlYCsMRS39DOgypZKuqMaOAhIJYcgQ62qoE804NF1ITYx/hsKmYHN6SXC7KhrWsj1heSPhjuEUdpJwRk9lvImN05oN9B/P9EcAXoIIyqnMdd822QzwBSzBjTFCADDNHDrmALNowcDSXqNWAhppNqRD8iG/6W+7zoWaSI2iDRR2TQN+E70ykMoVUNQmfCOC9Z87zdfuJWoJegIdiYIY0CJFzh7x2w2XKU33vwwq/MGkKDle28wubXbC6hYjccr20LF8ZVq8XJPfJfImin5RCLs5gVEulZ13+uMEE4aNMD7OzwVvxPtOQ0Ou0FAzfhau8z+2q9Pr7stJreM8GhpKpxe7c0foamxaZou0Q4W5UPg5IElIHtx6Q09x4M9g43Sru7LbloV5NoYNqF28p/fs5XQ+3RGHJDsp6eC1qiRvC8oEQ6Q1Y2zeD+oE/PSuOOR0asLJsvlcBWEU5s410DqiOKSvcztVZEgXEJleLssriTxbQTi2Sbn3U+zjkOA7QybaS3Vs0V1i0+hA0fwMNpCT7xp3Gim5867icwL1+j4e02psau3Y5QGS6s2aAz3uWhkePa5YKQ9V71UseX1LyO7lTLp2Pgt7QXOtePLLBYoGXTN2d47QS99kcLVOjoZ+0gHFZKVphbVslLI93xC0MsL8UCpx4m8U5WYfzx2VVlktS9zmBJzRDcqoeFsxT4ylPvAIUhxJWeLUQaoaDjsdNl5P5n8JVGBIM3JtMZ61Ko+qCQXZSp68VieJIiuKySNwjDcSUvWGd/GlOLE57FshSzsWlHWwPyaQtwNaY/T3KQj3BJq4v9skiHrqfCQsuVGZEzo1WG1BSoIPGMngZWcUgKMqMAz6iqbVD1P2nVtPb2dHZz946c6cgrhLU4jNSCJ3fnKOfBJ5aV3PkM9hKRgOGWy4lfmsMnvF+NZQXBnvUDo9nmXzfcPP83
 ImW1B9Qb
 MTJERQz6hlTHd7+335L8GHguCAWLYyupshs9q15UFHBkVuoUdeGkb+wltHMkgkWanv84CON4uJS7C0FvTi4UT+Nw9I5oPxQj00ZNSTrsMnFDkZHIyoGhTZ7gaQ9BcHbLwVckZsBomMuFRAMMdHeR0ey7QyvSEc9LzB7fZkfmb1w3fY0SQaWsame6/rblSo+H40tK/rAjqBSa6CB7oAUn5cP6nNFTg2j/b0a9QhchIWgNF7ZBMybUSgZ0fxvsF7Eivt/a/TOt/AhKjM/sniEAG9cVdhuuZEjHDenYym0CRHrw54aTqdnQL8LbU6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 10:10, Daniel Wade wrote:
> On Tue, 17 Nov 2026 09:13:09 +0100
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> I have a different patch on my queue here that fixes this as well I think. Please review.
> 
> Yep had a look and yours does fix it.
> 
> It's more than soft-dirty though. If the folio gets dropped while
> another process still maps it that process reads zeroes, I had 64K of a
> child's memory come back wrong. So might need a stable backport.

Yes, I'll add you reported-by and clarify in the patch description.

I expected nobody really runs into this I practice (odd combination of things),
but CC stable makes sense.

> 
> Dropping mine, yours obsoletes it.
> 
> Reviewed-by: Daniel Wade <danjwade95@gmail.com>

Thanks, I just sent out a proper patch.

-- 
Cheers,

David

