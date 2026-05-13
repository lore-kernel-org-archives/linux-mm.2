Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF87CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297976B0005; Wed, 13 May 2026 05:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F156B008A; Wed, 13 May 2026 05:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185286B0093; Wed, 13 May 2026 05:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079CA6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:38:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99D8240781
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:38:28 +0000 (UTC)
X-FDA: 84761896296.28.40B537B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AD0A1120003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:38:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3QM8k1L;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWVcwXJr9mwCn1kYWymlZzvuZCXeDyPLw4X5mm7oeoI=;
	b=0QvXT7SeoMPTzoQzSKZYlMycc7vgPle6J1/dI0i0u1E1sZdUnQQj6mUf5T8XiITxERxor3
	EY33mnkXxdmNBbmHxIBXSEJ8xBx2nhvI/yVKQTp/Bb1xw7iTdNXLx2c/iHuw76Y3H/Ofq9
	fMxo/GzP3XT2hnEjjT5M/TEjxMOH65A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3QM8k1L;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665106; a=rsa-sha256;
	cv=none;
	b=E7cDMbPRDfsv7jmK4OIbofdtZPABNXeiGTwJ0oxMBCl+dDW8F6WAn817RWsGsA2oXvh4pW
	eOpi7R2qbIGqVUF6XjPsCDJcB8uH6gsVJARtL85tUmPSnbeua1VK+7ynIyfNztcSJHVsar
	gcr8V7+8jJz+kKlaYxFcJPGunUfL6/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DE7640567;
	Wed, 13 May 2026 09:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777D1C2BCB7;
	Wed, 13 May 2026 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778665105;
	bh=E+Mtd0uz3rg/fume38L2CFf7/lcRk4msvmv6P/5122I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c3QM8k1Lj0qEAsr1qUr/FLJho/LP/9jUVdpnsC5fTbKhCZD7nMsSzclgSpVOyA26t
	 aYwAft4ksRainZEKWaeb5krrGqOjWhuisWxH0wxrWzgdpLSrFQO42Ib31iUmZ2xFYj
	 R1NMKerXCASg1/aHRXoA5cwsbJmS0Fny+R1nnZmH/SIK3qfasGWe/eLm2BVEZiUHXJ
	 E9N3IliDKPOu+dDH1lG+L7v6qg92umVl/z+VAj6grXwCv0g0dtJ4PEVD6C0uY/+XOq
	 bHZ5AQ3LiGp9fGVYHnyZjWV61WeaBQkny5gbxQqLxlUwbZMZ8IGjSyeR/2PAyPqoCO
	 X5eKPxD+OXFUw==
Message-ID: <e80c7f34-40c1-4854-8f3a-2461022f86cc@kernel.org>
Date: Wed, 13 May 2026 11:38:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
To: Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn,
 "leitao@debian.org >> Breno Leitao" <leitao@debian.org>
References: <20260512120557.49995-1-ranxiaokai627@163.com>
 <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
 <agQ9FXDr_5ybD7AR@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agQ9FXDr_5ybD7AR@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD0A1120003
X-Stat-Signature: 1xbd7o5e8nm31azkxcpyeu57nxwpggse
X-HE-Tag: 1778665106-815863
X-HE-Meta: U2FsdGVkX1/RyjfqvI3MWH+c9h2frALEDaFZn7yTgon1DPaQvwdslmL7Qt4xKcfR6NT/feFM62yjUVutwWerrPHRVHgHH2teHwHdKWvmFiRn4zVq5ub6ngdJ6mn/qjsogdCyUj32i1RYMv7ONDS7tB8AOj46mlt1B7gn/SDAVPVY3hdjk9ZxatgSbFM81Gcfl6y7L1zgviw/jD7sYraFk7ZneTtWypMCStLtHWTFe2hawH/G/IUq8i2ZW9/PttePQB6zUtuj0wX0z0f5svDqa4NCAAMw5vgoL+TjH8dAWLTEdNT/IH4Nc1xZER7VA4vxjOHn+v9Rj0aL2n2CSR33sgtsgRmrWReDJ/hcCF6vgE0zE6bVvVIYRVQup3wGVEUmAYXre60VZJ7d0oAuKKRT6TWPbfQx91u2MVt6pPeFlBhzgY3LyAfjlAyvL2cG6nk+SWFyZv1Wk05G6cYHtQHSUXQXJg8xj+nTxhD6gT5tQAj3OxWE2NUUSeMJrA86CfWCv2ld2DyT139Db5cxfz94/90rWThEXPylg2NJVB8CSgSKQgZEB3YlJAkbnXzXB+XjHaUAHUeWNtAteAWDaWQV8avwFL845ZzgrkmlDfMwzHY/wv18MKFU/78/YH0+y8bWe2QOSAVW+4LMqZr7jCsk+subD6YljNiBxNZDqEgevTL9JIFp6nycU3RPVF71k3V6ejG67q8YvRMGBqzu/G14pLc59r5ISf2KO8UstqwLPvtGvSSb7bh7gk3dT2ttO2cZuQAQJKbW6wIIomRNOeNH5AxDRA7mG7B2xym4OsUpU0/lT2R7dDOihLi4+gmBlKTsbTq0k/gEFZ7LixZap1D+mC21oQJ29l5EStM1t/oN/kHDp4UXObT56oj8ZdxPiNbFgO39KErJV5OXmli1zySadAjPtWpKS9c/+pWtIJsNRMoPO0Kff7nb58iHgkDwsj6TLrCXU6RGq7JLA2a10y8
 CkmAfNUQ
 YyzBDoUoSGUJ/+iztPQ7d65Sa66rLBlMxjyqIoaxAz7vYghxS189LJqnejp0Cw9877uznAc6R17sotJGs6XCG7QhJmWdQeFvTa+TNjOU3qdQREAOquyxgkguA1j5Dxk0pBK4cJAgWmvSALVQPlUMqCEv6rJb3FDsoclF+TVjyEp8qcu0dXtwwCcQlgPcQ3qcdi3EF9zCbRDZfd7eSqrx0A0QwxMttPHC5oSH925Xnzma9XivqQxEbQt2LtSzpcFjPK19vJ/ndMdLAcBnODFoHZ1FLWbUjrPaHUCqDD1cHz3Ah8mtMn64FPHDTfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 11:03, Lorenzo Stoakes wrote:
> +cc David also!
> 
> Unfortunately we put some hugetlb logic in mm/shmem.c too which makes
> get_maintainers.pl not do the right thing.
> 
> I wonder if we should add mm/shmem.c to the THP section _also_ just to cover
> this off?

I'd rather not. Too much noise :)

-- 
Cheers,

David

