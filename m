Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900EC109316C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A4A6B036E; Fri, 20 Mar 2026 04:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AE56B036F; Fri, 20 Mar 2026 04:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719E76B0371; Fri, 20 Mar 2026 04:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEE66B036E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:10:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0105FBB4DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:10:12 +0000 (UTC)
X-FDA: 84565718706.09.906C104
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1656CA000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:10:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=loQMtHqh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773994211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fd69m89eNPZtCDUEVo1zHRy+sxoLID1HyWPfIiZBvn8=;
	b=uzaNw3LzaWPKriZO5HCsQ052dfZNYFIzs4ZDw8skgZfbInjrXA1PiQ3BNMSwPIPHciA1gT
	gx142BQsxVK7L+J27ik7k333IAo7L80aHbB/HmAkKZPElKuZFixc4Uz36dGSGkF80UqAhF
	jCgQgV78zRCX2Ov9T4ASi3xk1gZVTyE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=loQMtHqh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773994211; a=rsa-sha256;
	cv=none;
	b=mLbri7h5COH8qarmA9iJ0cOiNRlSVV4TwmOlLCDpWIBf/HiaKD13G/HhmRt8NfrxzVWFe7
	dcKu+1GQQHKiGGGbw30fbO1623YBbFViDH9f9ahiA40E++qTZIX/3C+j6yskWr6zmjfpq3
	cpWSOQN6Qb0GCPiRfGJsT+lfmNaSvLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3C5242E00;
	Fri, 20 Mar 2026 08:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0812C4CEF7;
	Fri, 20 Mar 2026 08:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773994209;
	bh=CYcLgudX4Cu8ZT+KE5/8nc0iHQPVKP3e9IXo95nqUK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=loQMtHqhalWO4rrYjIyRPKyEqjWxTZb6BlwdL5msNmZ8vSyAYVwkoIlITK/EK6whQ
	 ZB+Jv8FruDmizIGOrPFJrvnlhcfGT7tekhMTGIdaJUaeMXK8p3ngk/bK7NSokD/72A
	 EPXGc9PrDcuHucNhjspOyshkHtW+v4llb8UqktVOZ/HAsfRGXJqRAU6FxB93cTB8Z3
	 x0MJEAXYRmT21ynaXaRjgAsl1ndks8kOc+vXwkIRWoUfXg/I0rria48CtbBn8KGvwH
	 LHNEE6u+SkLTWR4oMnNkLnHKCUWu4FIhu72ADkGKSv/yU+dZwf4ls+R4gn62e/OzTk
	 I1q22ctgf2IYw==
Message-ID: <37a204f2-796d-4d15-b21b-09fd4a9e77c2@kernel.org>
Date: Fri, 20 Mar 2026 09:10:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, baohua@kernel.org,
 ryan.roberts@arm.com, linux-mm@kvack.org, wangkefeng.wang@huawei.com,
 sunnanyong@huawei.com
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
 <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1656CA000B
X-Stat-Signature: bw1sgdj4rsdy5tez5j85dbt9ncpwfkbj
X-Rspam-User: 
X-HE-Tag: 1773994210-952268
X-HE-Meta: U2FsdGVkX1/HqEmREP3nDrQ7n3Fp08FOP0bJj5hraCOTmrOhp6l7xXM6JiEDRIyvhKKDQpCG69XJlMrnHGLR81rOhBb26eUkTUksiqUIwpacDzHLKBK9VGDRzdUqrFkbUWOEEmjq3cHSHuo0nxaysbWon2LMfAXm+5W4GiUBSTFNETLbmPX97ew/gBiGWJkWGXJGmlB6ceiJXjiv+PsK9cZmo6a42vMdLkMsgCgH9mu0XVC0231v8thd07aNeF0fduJZbf5bpsa89xU73QRRQkHZTjNEL9yPbfrbdu3+0nVmBhU5OJM6zeesPKOMZ5bX7bYxc0L3AKwxVXnXb4p2Ocl+ncVZeeKKJ/f/9dTjnFVYkvrT75lDRrT1MnbmE6VaTu+Ah83TIWptPkcSO7UcrnLo+zGtpPJlV50oMINE6hemDXbbKOHQieHmK+xyZqnrjhOKUG794fuqXnJ4hCeDTDURelAEBBBvY0kyg/EuxTTPxIEz5BVKMR7ciJDhb3ZH0NvjYWcBfVl6KE81MKI+irlf0RFH321nlgIq0ItSrZ3N4aZQR17n2No0ssxy/iR1xCJpoLu2zpbiq9i12cwovgfANrVVft7plXvUlYnGf1Nb/0a96yKhz0Aja+RZk5oA4lLYyfuX/4sE0dJ/IW5NN9kq5MRFlyhe5zxOpx5kYTLC3rSYYrODgN684+XBre8IIJGylhXMdtIJLSfOOOy8uniiew2LoX38CjaA6Z9NVVUc0Ny+C17QR/OI8q4Dzf4UcNUL3FHPFPRdYSE6JyHGRVkKTn/Wox/wyVjVAxuv2v5dFpJAmjbvtrNvkxEJ8am6/Ofkng9w1Z4QcY++x967Pm8CEBcFvYoMey3qv9w01IqlMOdHb6tLZI5RpAD3l0AMTG0ROmV0aXpo8hj1wTe5vwn1QKuxstFQ8svknUNt2esU0zCip3g1zC4EXyMSxtuSrHWAR8nQw5E/xTEYH6S
 l0d8/SO3
 +KPlPNXJNmmJ2T1NrT2iWylRvaeU+aJHDca4O6/XL3esl/TKCrPzWaDlDptm5k/+9XuaPKs4DIwPy0RASfTjpTIMjqMAuT5gzkLfVT5RvMdoLnEqCuieylKwPX4170eyq410q08yooMDegU0SR0KW0adiWNwItnhkDZh6qugK4sh8YtUOPaVXNQRMVSbuRv3PatABfut+gZrg3HZ7YF0K6AmyVtJH2H8xy3iIrCHFpn6S+rJD6MC3bOxZRrdGhhHtNVBJUVlY2Y0C468vT0tcgj3qrtnQII10k8rO4FGuu080BVLdr955JJs9CUqYetwoVBowaHDcraYCy3hraJFAqKUM5tuK9Y6EEf7/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 02:52, Jinjiang Tu wrote:
> 
> 在 2026/3/20 6:51, Andrew Morton 写道:
>> On Thu, 19 Mar 2026 09:25:41 +0800 Jinjiang Tu <tujinjiang@huawei.com>
>> wrote:
>>
>>> On arm64 server, we found folio that get from migration entry isn't
>>> locked
>>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>>> zap_nonpresent_ptes() races, and the root cause is lack of memory
>>> barrier
>>> in softleaf_to_folio(). The race is as follows:
>>>
>>>     CPU0                                             CPU1
>>>
>>> deferred_split_scan()                              zap_nonpresent_ptes()
>>>    lock folio
>>>    split_folio()
>>>      unmap_folio()
>>>        change ptes to migration entries
>>>      __split_folio_to_order()                        
>>> softleaf_to_folio()
>>>        set flags(including PG_locked) for tail pages    folio =
>>> pfn_folio(softleaf_to_pfn(entry))
>>>        smp_wmb()                                       
>>> VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>>        prep_compound_page() for tail pages
>>>
>>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail
>>> pages
>>> are visible before the tail page becomes non-compound. smp_wmb() should
>>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>>> page before page->flags.
>> Please describe the userspace-visible runtime effects of this bug.
> 
> This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio().

But the impact is bigger, right, when callers rely on folio_test_anon() etc?

-- 
Cheers,

David

