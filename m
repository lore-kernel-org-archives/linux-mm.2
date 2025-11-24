Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2D6CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EAC6B0026; Mon, 24 Nov 2025 05:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846496B0029; Mon, 24 Nov 2025 05:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783456B002A; Mon, 24 Nov 2025 05:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66D806B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:02:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8627712FD7E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:02:46 +0000 (UTC)
X-FDA: 84145061532.17.A243C6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C08CF40002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:02:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8Lh0j1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763978564; a=rsa-sha256;
	cv=none;
	b=ilpl38IXpD6PnFLMBubSq8H8G4kCr65rhI0H0u/uqAxUCMuGPiknHHg04iFPdmK5GAEqDD
	lkM8uKuzLm1y6DGAp1unhYgAnNdEmvlrygz5SUD+8C+54VW/JfUh9fLhQW626YoMBk006T
	VZEgA+/YVhuDtmHGq1sVro4jucLDCjQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8Lh0j1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763978564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcmXvP5HrnaR3QapLRJsmFARb858hh4Obp42SBnp+Qk=;
	b=4YitUzQpqq9HFQW5Lley87Nmq2O6fjgCXd+kA/E6EfKlEVzsluuVDRYpKFwQNduVyKkCj8
	3fho9w+lZ82UFRAxRIOoajBvKtaahfIIQHGf01j2VBblI3C/fYk5TWAno2RZgnAbeoBqJA
	CxpM4TWr7xd8vWPCXq3+Z+VHDThbPs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A4AC4036B;
	Mon, 24 Nov 2025 10:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59648C4CEF1;
	Mon, 24 Nov 2025 10:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763978563;
	bh=GmXLa82LS7RGCY+Z69mDu9cWNzbwvBxD8DwN1Cgk/BE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K8Lh0j1o8/uaMTI3xC9j01+yv3/Y9danSGOfUKkvgqM9aMx2W2sfy1WbDrFkaGGYK
	 DSZk9q11mVlDbQwIrztwisgnRpdK+6N9SHsbUuNdk1Msgwh7HBtwTNYSetQsGfmfrl
	 pMq1buXF7UDvN0GXvfe7kwEitIvpCaoLGrOALRcoLl/Bv9O9rWTLbJGcc5OWynOntj
	 vWOtNFt3EjdiEjr2nwG7/KrNcbUvh8FZGEyiL0/+p8bGaSTydEc+AcQsGzrdCVyDp9
	 FCP95ZTPCDK6Gqo6pyP9JaaRGO+KJNAHfT0OfVtpW/c6a7813tNMs4XfVM6n9fW937
	 4SsIVbHr/3VHw==
Message-ID: <36896775-5083-4b3e-9023-949de7722194@kernel.org>
Date: Mon, 24 Nov 2025 11:02:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: fix memory leak in collapse_file rollback
 path
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, shardulsb08@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, janak@mpiricsoftware.com
References: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C08CF40002
X-Stat-Signature: 4nci3jam1t8gmofri9sst4xb4w7oqssb
X-HE-Tag: 1763978564-458198
X-HE-Meta: U2FsdGVkX1+OyOIUjvO4WeL8SxZC4Rs4xOpdYwNOVnMxU9sxtRJC0VzUj7/S8A3JjzHXfuGyJg7g+yF8s5DhtxEYmRWY4BVTZkbGlxG5xJK9PbCz7AeVNL+BTb+hIdPAxm5JZjynur5kv2tFvXTFrIIvTi8TPEsgSpW02k6bRcZbbr1uJVsxuP0q1SWnl3d0oACMkO92La0iPRqZCNvCAJWkjBart8mr9XQmDRbR/0uwSs3C5NPBibeEqkXhZlSXwnnh9nWJvolAnPe25ZKXvhVtKuWhtjbRdS6gA/Ip09wbsjrzXlESKeavhFZmXlEC5tR2Dva+cScj2c2s4PVjWul2fq13/cJkuJQ40++DdVvvCsEIPbcMJnQeXt3GMcFqb2ZQc++tI7bT3Zr23Mc886u1G2IabrdB+v66XwElPRTxSHWG9/7eBp7Caf76RjJG7Z78eMjwnM619LxRY3bqyeGzInSTAnkfgZXasF40XCThlmb+/NJsp0C34jQyOnjAvoeDH3QGjAW2/gh/C1wwpm550oip48Jv/aw9482ftvI89r21ePknTU4VJ3Tc+hp8Mz/sUppF3dqvXRwGJ+mSRr1ZhBCveeVDeNqjDYXK43ZaKq2cyZPFUn/hbk7EbBDT8Hyu6qL5yo9+DvQTPJd6GcT/n+9YRSMGPAVk8siX5qajizFmeUxQxvMy1Sp54Mr8ap3ogWZJwikgrZgj6kJGGTdyJ7ixtAEFiooqEAMFn2/y7lPzTAxGteeYPYbiQASJopOJy6BkEes0yTnRXaFBik9W/+6vZqtuwXCXwnS6dU6Ds7N5AFDk+8wF5p0RsgDq9dzdz9MAHkNTb5o0p/yDZC7ImRqHjqQixR+g6GW+6euEwFYdkSUXDHmU9XpMBXlDjXJglHSC1wsPHEmubur/SG+odIK8c0x3KC9B/oyoAK6Ji6xXx9eQyl32TT5ygzf1iXAVjDUJJhM3t+++OLK
 lbz/X8fV
 o+4qkmtK30uawvFwvUspr7+w9ThTBPoh0OGY+KLv5SeuYVZ2cMa3601ds5KtB+aH9z35nlo5XGQXHxhLVG05oOZm0s6CBz9lEMfdD8ElhTpa8HHITO2WM+l+y2DVd6GS4eg+d5xrOVBBwsivbldIcibn7ZeGITNkIadVa23hpojjKWDfvOVACo7JvdnnQHnvZu2mxKr4GNGDBU9IIppQ7yapgYeiNOei3ZeWwZbC/EWq6sCbe0AyXwx+WHF02DwcvZ4SW9r7S+2eYtgeJ1xvH933U0kZIWd5vzBiLFC0of8LUwljXAxLJbvlSBQSWdYJ4TzKVF2BTz7oYW5VpiZuOl5HfUKK5b1LPVhwRTkbymU0iY08XS6dKZob28iJU+Ud+uV+sE5zh/Jtu2fNnkkywbPROcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 14:27, Shardul Bankar wrote:
> When collapse_file() fails after xas_create_range() succeeds, the
> rollback path does not clean up pre-allocated XArray nodes stored in
> xas->xa_alloc. These nodes are allocated by xas_nomem() when
> xas_create() fails with GFP_NOWAIT and need to be freed.
> 
> The leak occurs because:
> 1. xas_create_range() may call xas_nomem() which allocates a node
>     and stores it in xas->xa_alloc

Do you mean that, if xas_create_range() failed, collapse_file() will 
call xas_nomem() to preallocate memory?

I don't immediately see how xas_create_range() would call xas_nomem().

> 2. If the collapse operation fails later, the rollback path jumps
>     to the 'rollback:' label
> 3. The rollback path cleans up folios but does not call xas_destroy()
>     to free the pre-allocated nodes in xas->xa_alloc

Note that after we call xas_nomem(), we retry xas_create_range() -- that 
previously failed to to -ENOMEM.

So the assumption is that the xas_create_range() call would consume that 
memory.

I'm sure there is some corner case where it is not the case (some 
concurrent action? not sure)

> 
> Fix this by calling xas_destroy(&xas) at the beginning of the rollback
> path to free any pre-allocated nodes. This is safe because xas_destroy()
> only frees nodes in xas->xa_alloc that were never inserted into the
> XArray tree.

Shouldn't we just call xas_destroy() in any case, also when everything 
succeeded?

-- 
Cheers

David

