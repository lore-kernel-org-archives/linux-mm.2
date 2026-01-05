Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B662CC79F9F
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112D16B016B; Mon,  5 Jan 2026 10:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAC46B016C; Mon,  5 Jan 2026 10:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0167E6B016D; Mon,  5 Jan 2026 10:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFA736B016B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:44:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94FCF138DBE
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:44:37 +0000 (UTC)
X-FDA: 84298332594.18.131B120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA34A40008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:44:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="innY/Tl2";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767627875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzVIOQTll5paiGldSWSu9xwP26wDYXWg3+51U8R+ay8=;
	b=ktgz/qh/kPOlfHXDPp40UerWEq1Mddp3mB3CLK9vFG/vInJ8Me1z93tYFaCw6kBUKZcLwK
	wD3REV//A/uleP8oKeWLCRY9M1CTOkUxzz3etnGqgSXyLCPg8eIYvtjew3pgv2DfomOcHG
	4mPB8b4PIpZd920iLZkd758HlpqvkTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767627875; a=rsa-sha256;
	cv=none;
	b=muP0R6fRU+FmO0BYuS9MBwYBA1VPf7oG7PV1FfikWqx2jUB22+4gLe+z3I0/sVxbJqV9/5
	fs3vmfqSxYsVaoKRjHaEuzqJq2IVo/oWBYCatKF0Eiicxd086fvXs/Vzjp+c9re5KfYmhB
	FTnXgBEpudqv/fLKcsdMKCu78NVvVKM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="innY/Tl2";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92D6C41942;
	Mon,  5 Jan 2026 15:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9FFC116D0;
	Mon,  5 Jan 2026 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767627874;
	bh=zyB+RXeNVXUVeBgnUv45RpvYtGKzZKPTAq3FhztMpug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=innY/Tl2BGOxvQUBT9NyZo+k32OQBsSsf9fPILKhnS8ddQUe/HrpmtTPnpXOdVqI9
	 hDgWNOu/sOsd9+7IxRlYBEckWSlOODdbi3u8AQAfEGgprAiKlYigf+BxG94P47E/oj
	 i5pCiefjcDrii3Mz0udMRYnqmlfVa3SsXfQIs0RlrZXbDgdY8+VFRo/q5GufE7kb48
	 sJmTdnKQE0D4BshA+CiJZDsW5cdZQNeu9UrlTYutQNjYDxCalkOToo156WImQ1zVej
	 0i8G/jx0DTFKPiXvEW4AZO41O7p6v2y7YuniFRb9YbpqHz3bsGlbP8GNauOzaoUDGF
	 zTlR+TILO1BPg==
Message-ID: <51e72690-8a0a-4532-b6a2-79a851edc44e@kernel.org>
Date: Mon, 5 Jan 2026 16:44:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mmu_gather: remove @delay_remap of
 __tlb_remove_page_size()
To: Wei Yang <richard.weiyang@gmail.com>, will@kernel.org,
 aneesh.kumar@kernel.org, akpm@linux-foundation.org, npiggin@gmail.com,
 peterz@infradead.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 arnd@arndb.de
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
References: <20251231030026.15938-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251231030026.15938-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jbnx4khqwnfd3qayruo6a486hr884mki
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA34A40008
X-Rspam-User: 
X-HE-Tag: 1767627875-967608
X-HE-Meta: U2FsdGVkX19OA12k4g/FfULhppAIc9JztJVEiK+DMFftCgg7UluhoFfASppUgEqtYnPa150gE+egwdicDzCF/zuR5ZXnOw/JADFBskKwIgVWcev7SbVU2t5VfRbxux+hVzErfhm3xb1KjU6g0eDA8XHS+GccqbmlejWCxCB3/UxLSnYwqlQUoQmkZL9vnPRdUBwXwXzo2DI2Wjk+E+anro0v0HEjpjRcCvJnBKDeCO/Pa6j6K8wMLQBxgFmV4PLN1J0sxkLwofx5qV6lJ7IfPMYyzlGL75y/u02mn/Hl3u+bDqNCdEF+r49ujKti9xiGjMnjE8xQPHilW7hPCjxQiLCNxXhp1DfI8yHdYEOljrAtdTJ8QHgoS7eGxv1oNNlaCgwC9yICd8zSzq3XyXgcT7wbUzwMdtf1a+cj9ggWmLn1nASOfYyoijA51L1gSAxL6ZvO44wCbuVwVdu06rKgZzWiY2Lh+3gdUA8WGLcjdRuIU8eREn1nUDKSioNqtd7d6zbcxi8ZKnNHk5/muhxjGVKNiq1xFPfrQjKcmSzI6E4e6f4m0wjLd3A34jJ60Lh1d90KzjCOI+53lcn9o8y0hP0oXwZkFCZ3s6IC/YdbEyj9R11LT0W594oj7XuIGF6gK0cJ/VFe83b5ThLSke667N4lV3bNNfTzT48XqQw8zhuxW2gKwb1rH02dR/wh/Iqt2baPmU5j2vjkSTQjWzLiOKVqygs/+GaCvAPw9XTGAtdtfmr7jCdQYmus2LZqSysJP/GLTcOX1kRsLx4Z+Cg8mYk4T+PYuRBzFemE+dMzMY2day3RgBNRX0jgE8OV/cFePvNZlkyueITFf0lZunTbMa2iasuB+cZtmojiwQvyBO2IPi+julr6009oMHhQozKcfVWhPSAy91BKFyRUT2b1NVL1Ve49H+u1av6DXK9tfAFDJjWKZmcvEr4QO2CjXmhp2/eBsCj2+juHL6p0Hx4
 as7WVRpf
 ZV0elVbJYIDNw2pspBGQColwAudh5Ccp2/9xSmrE7eBz2rq2LOEf8/ewaKvDSJcxApHhFwt0Yth7365XUgwGFR7YPOfa3jx4g6tzDDUucWAc2Qw6ZwnStaED0Ne3KxPTWcIDbCYkzO0AvRWXdbqcYrrS+O2+YTtFoNEv9WoOz8741ClsO0SEwS+ZK4hZjUksC4jGwVZTWc7mS0d9FXdKQnCxM+DGZuThErZSAIn4cpJCxiKBy1I0xdQMEswIH/zkSVvZ/soiFhPUBYBaFRMP9KFTL/rWqLP/8p2aPZxuU6yPxjqZSpzJ5OvQirLnNxOdIqGsKXGFNubBcsGq4G02j9j3llsW1NuNy9bYIHr4+lnW3+mGc+NafTuod0KF65hSbza1pYkOhvc3TqlAV4MEGePIclT5BfeoaUICL0PYmp8x9UGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 04:00, Wei Yang wrote:
> Functioin __tlb_remove_page_size() is only used in

s/Functioin/Function/

> tlb_remove_page_size() with @delay_remap set to false and it is passed
> directly to __tlb_remove_folio_pages_size().
> 
> Remove @delay_remap of __tlb_remove_page_size() and call
> __tlb_remove_folio_pages_size() with false @delay_remap.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>

Right, the only code that sets delay_rmap=true is 
zap_present_folio_ptes() where we now only call 
__tlb_remove_folio_pages() directly.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

