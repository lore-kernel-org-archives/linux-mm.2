Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F20C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6206F6B009F; Mon,  6 Jul 2026 04:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7886B00CE; Mon,  6 Jul 2026 04:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8F76B00F8; Mon,  6 Jul 2026 04:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3516B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:46:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEE82C1A24
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:46:32 +0000 (UTC)
X-FDA: 84957720624.06.7A6CBF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F22BD20010
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:46:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlPUd2mz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327591;
	b=0LQ4FiI48EOrk1ZY0wVLTl3QHVVzTDp6pHRWrTv3uH25uFRa9LdPkRNX1biz2AejGJ/r5C
	7Iqiv2Y8dODylKX0dGMNP1sY3kIWOhsgNUJ6NFFlWp2/DJJgpc5cIxzC7SkUtN1G8ZCaW4
	rXJ8huDPWNWzac2VaAehbF2GDR5eTVY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlPUd2mz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUt7AOxRukVfPJ2p/55WSVBMngsUv1Y3ji3BCuv1HZU=;
	b=4DeU2UMlaSJ4rHwFrIrPR0U+8YQnMTW+9EWQoBUqSd0oFNthQUosAlPmJA0CPvRUKgOdpX
	RzByjpl8x50ZEm5y8G5wbFPCwji5QN8JvHWL0zy8TvJs6ZWG/Z0p44v7KC0FZQFvDe2QBu
	sLTCfqgk19bIIE0jryWOTFY1DzNA7rs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E6C461832;
	Mon,  6 Jul 2026 08:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97E11F00A3D;
	Mon,  6 Jul 2026 08:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327590;
	bh=dUt7AOxRukVfPJ2p/55WSVBMngsUv1Y3ji3BCuv1HZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HlPUd2mzwaFf4msXPmbw624UQ2RQeaoEX4P/n1HCZMANG1h4a39HQaAwKLtbpzLTe
	 6b9dm+Jyv5X5zCuA9sRQGboJyABYDxhOXTz7wRAjN49iJnrefHnFPVhRwAb5td0dbF
	 2bhhCW6aNGevq8T6wFXUX8pErBYCLmC570vZFa801ex0KxxJjNjowVeqjTL4WDqV4Z
	 GNoPXWJjmL5tpz8qXdNfG0//Ibc2CPy2zB7Pvh0+pblfDFqBk2hv2fCi3ggIPY9NbL
	 rmkawtIYxjkkd1DKfwzeg7ww+m7Q2KTrkyDBMKe9HJnovHcqQ1ZboDykCbAxNXGDLs
	 mIbCywI6rteMQ==
Message-ID: <44bc953d-d0ab-49d1-a299-ce1fab68d134@kernel.org>
Date: Mon, 6 Jul 2026 10:46:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703114202.365553-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F22BD20010
X-Rspam-User: 
X-Stat-Signature: yzu4qtzhtpphdq6ji55bk7hoa4eehud5
X-Rspamd-Server: rspam03
X-HE-Tag: 1783327590-36072
X-HE-Meta: U2FsdGVkX19cvBkpUiVAoxMlqlGwMNqB+7oZarG7haMk8IVMQKEji+4MyTPi0YdcCCQEROG/guNTwVW4CE0Q5jR3D9FdEC8K5x770XQHl7Ma0DCKx4r5RX7CgkXuBrzi2sTmFzOIHYuBMtr3SL6oRRAyNgR+Y4Hi8vs6jcJHuojO4FCDaLu179FlY/Qzd9bqYENjo0QZG1q1pmpt1SVXa+/ihQgOyWdsdZtpX2WDSrVQDq055XxIjXnl7bE9/wyDTSmyLGKx3clMh3B+mT+l/SQk7dRURPUXh2yRcGDK9/vJhQVXA6RfCxxMY2sVjmERi5ZcHugxG8K1kGcw1U5idPWJNDgfkb/3ws9ipzuYeD/zRE6ObfA9hMpegf3+K2p6DjjjcAX94fha0ppwIAdyG3XvT64i7y2+g/6uuQ4Bk+C2VIg0v0ScPkvdue3c9nQhTIy6GXSwCTgas6MT0e5DbRD2hKsVBNB+fSv63G2YIveLKE103sOUQZu5844N9KV1AnMYt665gtoZIvoiC59k2H/+nhD1UoAQlPVGqvFgcbI2BrTkAzwhwyW9Rt8Ra9mZTTcABBTCOSakVGDscHJ3HoY4ajYxn7OpiNCHADJAFpW25vpyUTTkClGu9EI9jVu75pWk5iH6I7tm1X3TvmRb/h7NvYRgCZLwXjQ5P1EPFd3SSlZCHjN6KjDXk4/0FKoUYR+zJ1yWeO0V4nBgfDE9E+t023Du8wmt+ms8BUp9UnYJqGauPnSXCp3MeN71X201dWMklJ+5E5CRbhn+6u4m96XCh2f1sZiZa4WCMj0pHH7BgrsGAhUJdOjVYhvFaUHmn4nGnGyv/FC1H3krhuaSQYbQjTxwKmiL1g94j9KQRNp3d6w9YJDTdLtPPj/mFRowbu3zlAs617P/7F/5mID+AeBXM8NFMPDhdoWi9g8Q6GfMVIdOdYAHb6we/22yLc3RPKMm7RRVwFG8E6GnEm6
 f5b1MErx
 VvyZM461JqgR0nbuMvHZSOf+wjsnfeHHetQp+kPtY8YBrrQD5UwvFwclNlEFQKaDGlsUwb7fpcX/8gLqIgqZCjP9CedF5Kql/QO4+gR+leJORkf8P60lCBFsntb9fA3qhGx4xJ/185oHYxtH9kHPRGmkMC8XkHrIfRv45pliTuXfvop1ariwkoXUkz4VXT73ZWaNUaJahFY5CCOnzxJkxDrmibfFHdHQCBj7PR8K9yuEL7RAslMOeHX15itlxDCLsG9lrECIG3dPE08MJSJ1fb3Rm/gcCf1pItCGu0WCJqhXQC4ciohsfk66GWKCDqMkCScFC1aFMblBdR1Sh8SbZZq+YubQ7r2k5WbO4JDSPgUIqLGIL8MoIlIN1/Jd08jjLNcOxt+kTWbjMjwRNJF1SKkt+VxLFLHuYW9qx19k4QP3gj+x8+Xq3FgG9CtTYaJuAyOowycgn2SWfaFgBNj09qbNNbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 13:41, Dev Jain wrote:
> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the pte pointer to the hugetlb folio
> in pvmw.pte, but the code reads it with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Just use huge_ptep_get() for dereferencing a huge pte pointer.
> 
> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

