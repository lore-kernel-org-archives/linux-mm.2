Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50E9CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4B46B00AF; Mon, 11 May 2026 14:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E846B00B0; Mon, 11 May 2026 14:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CE16B00B2; Mon, 11 May 2026 14:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 943026B00AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:02:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B871140256
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:02:03 +0000 (UTC)
X-FDA: 84755907726.22.F88FFDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F60C40019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:02:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQvIVbRx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778522521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axn1BaPAkEgmSj4f/1LLTNtP0k+OC3INpWd8iPOjGOM=;
	b=FU5lQYhxWiC7K+2FEAQB9pd1lzqiRIn7hVIpZ84TYF9C5I0PQ74HUUWkD/l687iFxfiey7
	23Vgp4aemGUQ35cbAQeLA3lDQsj/N5xRmyywTEH1IFxOc7+LoUU+H2k+FQLeDOvT9wygU4
	z+pPyICVJLtrZSFNeoborEWUjdR8a7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778522521; a=rsa-sha256;
	cv=none;
	b=F7YxdMaT0rMhqDE2weHhO/9tZKJof710UUg3T9Wb9Qm4buWEOhAz+Kr6j1HQM2/HWTYy8e
	SVyprvO3AxEcG9Z7iqOFN5x9J+CyVSxk3NSja9UxDoIZ1N0YgbK7nHiGKllb/OProOdric
	C/KFoSXPRPUTMdGxuHDTWtEKv3PuTmc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQvIVbRx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11EEF436EC;
	Mon, 11 May 2026 18:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB9BC2BCB0;
	Mon, 11 May 2026 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778522519;
	bh=T/YZyuolzIqH4cmCWQ24sR5GevwICNeNnPOgTZpXM0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VQvIVbRxmF2YDwIDqPeXTx24ipPzfJIMeB0O5hBUJ8mvTxPTdODBPk/0Eitv91Ttk
	 /KCDosScXsifvMGEzcKCM36lu8iDmK1e1v4TcTnkVXUMJIW+rOByA7cfnrw9PrkN2B
	 zNYA2+lU2qztTWKvhVx5iZabjFRof+la4PJEOwXhazDiiZSUAWK08iMZNX81RTyo5n
	 itietPph40OPqjRmMOCvHOoLTsLlJ+d7Q4i7yBGPBvS/Cng2RYVyNENgK4O7RBPP4m
	 2iQ+G9+Oozq0ISVVKnQ8cxnf6JTrdTr62WA7U8TM/qtpA4dwdbv++0nEQrx1UAcZwt
	 SCtXzNq2Qq83A==
Message-ID: <2efea0a2-0c3a-40b5-9f76-dc0613725b0b@kernel.org>
Date: Mon, 11 May 2026 20:01:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/22] mm: add definitions for allocating unmapped
 pages
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-12-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-12-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F60C40019
X-Stat-Signature: uy7ymu3hfxagydpmya5q5z46ut5w55jg
X-Rspam-User: 
X-HE-Tag: 1778522521-774780
X-HE-Meta: U2FsdGVkX1+VJtNA83LTq+aKIjUjaVqGLKe/yCjnZRqY+b7NneFp10e4lYKYzGSfrIL6INc/rPpBv4FGLVXZ1n52S9yU94XW9LjoirnYfrazH0B3wSfkOLFUIAekq+tgY8qDxY4zbx7iahgYhIX49N5hkg+r/Lr5f8xiQduUJEd3lVbcmlVYKeyyt7rHVXsFrSaZFFnvIHxpwTCMFyxfAlUXjJS+/25lJs2ZGCEvYW1EoaVUSJ/x68WuXN5jgL/fTVHkM1gOR4UWIgga6huoIquUl0Jq4/xsFlQpGj9SM643rzhM9R8l3YrE9H04CHJCu7BlPqORNFWb0Ap8Myc701kwMojXorUzR3/n+Nzgh51yDQSBKgQpqw5GpSk0DuGMLfZRyXlplRTYw9okYfH0s9Z2O/Udvrj9mFstfDcsDL8+6YSTLMRkw2T4TqFFGGEQXfCdF1b06O+QqAlpbzd/Bs9OobPjz70rXKWJM1f01O1pNFqOpn/L2H8k/SynDFzk2yVbc9ruU5Mjq38+zIXVDKuUZgBfJsVW+wMGkm5oeeTG3YFkoDrwbc4u9e8bStBX4qg7o68Mi8G5XuAp2AmXdaL6LyQRZZmw4PuHu0hzPFNH0rqQAOGavxwvLM0XX8elacLcqh6irSTRf5vAWvNBMDvKI2qIrOcvHz6AR0sekXWA9gm32euU2WRJITMv0FcI/P96eHQKPdpp6qouVZ8aPg1NiwVXsO9IV649po3bNXQ9vg4lWJa660Tr0CA9g7WMa3vBVFlbLVh72GmCVJh46/m9k11gJAXGzfTVaTqHdy9bOJZVeNm+B/snF91/Pgm0Qgfqxz2oWv0g6hRH+5xLpk6qp/DsT83VVzGKRiUtO8d3/TPHhvgQJQ6b2vC8RRcMCwW7lBjVdtRGDjDgcaWpNvunrPfSxqAtmpxKFk/GhYLaL7+vIVhYX+UdJc4Xro8yaVQZ+S0eUwe7bpIW4dW
 x0N78Vx3
 fKtBzGh9SI93Fd122ijh8EeUjnEoVccyaOwXFXaUqNrFNffcNc+RWBgoKmJ3RM8cD2pEppo6yblRac3/+H9mPs+lYgl493npYq1nwEwjqcTEzdEA+ULnu14SV4JJihEwQXvWOatR1Wrf5e4HClMU0o5nIT8xBHh3DtpXuavcqiXK/B5R31l1GXWJ8ZmPBcXgE5FOG5D2yxm+EQWXNJ50uQU16R8gQ5KvwMX6FvE7r3MR8xDFlnxQyAZ7j6HKizz9y0o5GjYouPl+qxU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> Create __GFP_UNMAPPED, which requests pages that are not present in the
> direct map. Since this feature has a cost (e.g. more freelists), it's
> behind a kconfig. Unlike other conditionally-defined GFP flags, it
> doesn't fall back to being 0. This prevents building code that uses
> __GFP_UNMAPPED but doesn't depend on the necessary kconfig, since that
> would lead to invisible security issues.
> 
> Create a freetype flag to record that pages on the freelists with this
> flag are unmapped. This is currently only needed for MIGRATE_UNMOVABLE
> pages, so the freetype encoding remains trivial.
> 
> Also create the corresponding pageblock flag to record the same thing.
> 
> To keep patches from being too overwhelming, the actual implementation
> is added separately, this is just types, Kconfig boilerplate, etc.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Aside from the gfp vs internal flag decision, seems fine.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


