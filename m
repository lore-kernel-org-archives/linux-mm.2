Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9821CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69C96B0088; Wed, 17 Jun 2026 11:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B0D6B0092; Wed, 17 Jun 2026 11:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08E76B009D; Wed, 17 Jun 2026 11:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C6B6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:01:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7C10140456
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:01:37 +0000 (UTC)
X-FDA: 84889718634.11.5E67AAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0785AC0016
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:01:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hgBgnl7j;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zQg85PSs5JvNsMYxPqaIW/o9irYPQQUQ8HOK3gV9gw=;
	b=t9BiByDHN4Qd9dIDYIZ3Pq4Dabp8mmlXCgQlX1XOnaLd1rqqrzxMbRiV/N9RAEA11k++IR
	XKpEQHg/caA5oqEl/nl7vmgyegXtBJKXZobF3MSLRhJTQVTcswiDQs7kZczG+Nl9bomcA7
	pEoQrk6pOAVVRz3a9V6LNYh6CEyia/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781708496;
	b=psbsIIzQ+BhgO9w49Mf1vFC8JkfVvRyFXXy+ATq31NWgjzSzRgHeDvXLF1ycQwf8H/LtRV
	KU9lLok9luvcm13f/9gzE676iq49wpNtfSrFCN/3TIpAGMP81NK5bNkrCz+sF5Y200EtNU
	sml7nhEzhje+5nnD/WUusvKINzfG64A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hgBgnl7j;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 804E06001D;
	Wed, 17 Jun 2026 15:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84B71F000E9;
	Wed, 17 Jun 2026 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781708495;
	bh=1zQg85PSs5JvNsMYxPqaIW/o9irYPQQUQ8HOK3gV9gw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hgBgnl7j2epbfs33gn3HCvJ6k2MS8x5tTLCc+X46ig3QCqYqQOiFRjIKXn28ne+io
	 So0NFdSi1FwZudLFKS6ThHLjTEKpRfoeMWFx1Hy+4028Wtx+bP1YOo9ZGfVXHwed88
	 n7ZF58dqNHrINgXCAs0Gl8zEO5OBdOlzjd8K3qtC61lHB6HBDnDvyi8FD/rRVPy/pY
	 riaAq0ckLoHRmp0COq/B10ilFcwWp9mRcq2s/z5+hzwyYTFeH0Iv4plB73VyzmsnT6
	 9I42Bxi4Ce/ssoxtywhxgXevuZFw+9Aag6y0wvMnwqYFkjqn7+7aXMJLl4tGhyeSr9
	 gVoHmNSriWLrg==
Message-ID: <6f323e68-94be-45e8-aff2-b64f5ef7bb36@kernel.org>
Date: Wed, 17 Jun 2026 17:01:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0785AC0016
X-Rspam-User: 
X-Stat-Signature: x7j9b4jbq85q87by7g46ttd6n8usjqjd
X-Rspamd-Server: rspam08
X-HE-Tag: 1781708495-94009
X-HE-Meta: U2FsdGVkX19rR54bI80dx4JeMo0bn5SU5AnSpDBDfADRDA9IGEMgYpcTWPQPl7UDgDNHicBDYVwmjlxT4W2kY+y6m2pisVj90lgFxtWk0Cj9zjyQTiWVzom53Gww0EJWFar4gLt1o34nGdIEkXjhQGL4ydTIJ+ozNttCremqUXNCSZOOmVDyi4axYNAWFXORg1XRNLuS1YibJUFyz3NsIWDThybiSqluc3h3Z0/Sv2scvJGTrHDV/zTdnHbLuY+pYqPJ4CtkRJYjLgYpiCdzP53UnYUij99cza+U6e6p8Y58Yo5m3deftrDsUfqdbZnPBjq8f60QYkbjjZC56rmlLKjQ51CupxX5jkSay/Mx83LzGP0pLSu8gXDUn9sWwbvB7iNNInQ95n1+20pvVA2CoUz9ht35Pi7xJw8IMMFThibLMX8/Y83ieC0lVQ80DWILBKJPBDV05YkaSG3XRi9h9Vpb/h3/zVuiz3fmjQrPYg6i4hHTC3qvYMTetBLVC78EFcO3Zi1gjAqjML2ydCkLWOuJcdxNsEMCG2AsDgZePSTWVC9pgdHxctinIAJUyV8+iEdj+SLJ23utJwYpAILTLJIVM27ZjZm6ot6tj0fF+st8lpNlvWmBw80ZnCqDyrxL7Z7b588PFRdW6e6s/TnVAdAIL6h4Y21trhtak2r7MqlL2mt8kqnxNxxFXrFR4/tHqRTdl5AWtPlyFDa8Xzv+eRAnDsrqoxXvQjdJnAm2Bi2J/WAl5c9T/CHpBAzfs4m5jtkeWFKsqAFVXb/zWgv4ulnpFTXMUfhCPlV3dfbMHkxabfUqxZEDebDsekH300JN4EnGRBEaSRVduP65wThFw0rRfu+ZWIQ0GtE1Mc/emFHrZ6IcnPxUAgnz2sV8HqRyfWh0lenmkI3bkdPR6SJl0jgOoXptg4wPJoN8kLafYMAHXBcQm8FrMJcTOq7J0cy5va9LDK2X6clgKO4ABES
 /7negOem
 yh1J40IwbuSZvaOzaBqOwN4+vMJiPuiMhrwNqQyYn5zqDd3rWmRvVxE4SMYJ3AwPpVV6u+xQzACDFMhy9vDdDR7BK/VF2rkveJ/5/dbsp7MNos+l1QYIpwT108uR9nV+FJHBWdT/C1UgM4KagA7j11eFs2vZeqgom5fXMjiP1NdHWc/5EyicceXjfpkXM1cphB98IeCFEIgh8gYW9Kj3EXYlBFMAznLLijfR9mSGUNPnvR7um0Pz4+Buk5iU8IpMyji5kPLCWMI1FX6Mem5igZxjmGF/2O27utaLUynmMPgxqtqQSAdXfirtxDM81eu38jKthNp7/jceMq18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 10:26, Kefeng Wang wrote:
> The mincore syscall currently takes mmap lock for the entire
> duration of the VMA lookup and page table walk. This creates
> a global contention point with page faults and other mmap_lock
> holders in multi-threaded applications.
> 
> The mincore is a read-only operation that only queries page
> residency from a single VMA, making it an ideal candidate for
> per-VMA locking, so try per-vma lock firstly and use the
> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
> find_vma() lookup.
> 
> Unlike walk_page_range(), walk_page_range_vma() does not call
> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> to skip the page table walk. Without this check, PFNMAP PTEs
> would be treated as present by mincore_pte_range(), changing
> the returned residency status. Handle VM_PFNMAP explicitly in
> do_mincore() to preserve the original behavior.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

I think you should first add a patch that converts do_mincore() to just use
walk_page_range_vma() -- which is what your patch series "mm: convert to
walk_page_range_vma() to eliminate find_vma()" wants to achieve.

Which would already be an improvement :)

Regarding the per-VMA lock, given that we already drop the mmap lock after each
VMA, concurrent mremap() would already be able to return funky results.

So that should be just fine.

-- 
Cheers,

David

