Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712F8CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB5E6B007B; Mon, 24 Nov 2025 05:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2856B0088; Mon, 24 Nov 2025 05:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F526B0089; Mon, 24 Nov 2025 05:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B03FC6B007B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:54:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 746FD885C1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:54:36 +0000 (UTC)
X-FDA: 84145192152.08.DD1D04E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AEFC5A0013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:54:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKl69RAu;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smgP0I1hTA/xB67DP0jYJGpYxfyi8M2RrvNqcVmvLGY=;
	b=OddCx/bdoQHjnAvxIiCjHYLeOFa0LakKQvS5fVN5XZ9y+XKY4RSBSwX5vX+2qFC6QpAhOM
	BcawvcZyMYxS2L5cZSzsN0nnebCQbsAXHzDJ+zHrUyLPuM1RgmRtu6nfG+3yatoSMTL5r4
	KZuso9PhGuof1DZ2g6wInZtBDn6Xsy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKl69RAu;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981674; a=rsa-sha256;
	cv=none;
	b=3vsr6spgV7juzibMCVEaXaifS5O9iWw5DL18+rcGvjS3EX8zgc/exAtp7eRX610mqx8v9w
	aNx0sqboiAu+wG5192DzPplgXKKDz/MenXu0UKg6D37i8PiJKfCcvo1RKC4nS1bfOc4nmx
	oDH7gM30thosHY4wOrg/HnWIv+ZyvKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFC9243903;
	Mon, 24 Nov 2025 10:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC0EC4CEF1;
	Mon, 24 Nov 2025 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981673;
	bh=Q2AlUqMmtaFmsrEl8Mydjn9iwwM/y0o3SQhYROObFLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BKl69RAuBWVlLV3CJ9tJ3pNKDBPoZoEugUvau53tVEG01mAU32G2s9gBBua1zGDlW
	 UQZJ4dRW0itWZc7lvLp8tmZf8Qxi9F7TqpXa23BGH9eLwD0UNGokTWHPFU89BypBru
	 caEBfavZr24MJMZtXXGFzw1f7q7hOcl2m8GiPDC9CxpY0wuQHMGnuFWAnKLsnZHQDO
	 rzarQSP+R7Dx1GoS/XT+Hr0EGOKwAvS4APKhYzXeRHBONPccuO1Q6pGkk60WJd4MzU
	 lYC1v/ISyPxepGx7OPKmGlxzsMMjODDeu7y03d49H73luNpOqwE7hjcZsXPtTQzwr7
	 FNEp4d/rhpONQ==
Message-ID: <73831525-2ec5-4bc3-9315-1f44d0cc77ec@kernel.org>
Date: Mon, 24 Nov 2025 11:54:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/vmscan: use %pe to print error pointers
To: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
 weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: SeongJae Park <sj@kernel.org>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
 <64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AEFC5A0013
X-Stat-Signature: h7wq53yf3dct6mq1tqr1t7y43i7qizzf
X-Rspam-User: 
X-HE-Tag: 1763981674-367224
X-HE-Meta: U2FsdGVkX1+1WF5Rq1ArbD1pUlIvzUFOvacH8iowNHaobMtxMt7Ocq+KMu+FbsQuJ3yNZDZh0PAe7XWNvx5cQlSqxnEB2HXiknq1QKnA4yr8ByK4z5hDlzRiFKEs1+un+vKyhDfNGdjseqKgAXgpmDdLqP22dJPbtl8gE0xqJKSiprvV4YHMZPI6JKLKmizwyULCVlkEHcBWYSyclpeBlKwP92FwBIFzQK9bBPqiEShuTI3sGBCmra8lFHgaFpyXg9AZndlK2UnoL/2WIK49s91ywuWHS01RCjXUINNLcDt1Xew/fLbtI4aeI8MhV0WZlwuZTTqJiSceqYYVHdmiYVgdOOlCwPlsB4XVUMAfupCopqQnYfPNEnejVcpGkWTdab8+D7ayzH7FNBvuMHY3Dr2N83oGcpRW6Ns6qkFIVu+ttqrAQgj6l1t9hGGSj9lsQgn17ldNh4b/TAsld0qR58OzH/8X0Z97uimJyQmlO0Khvs1qiuRRdooZuzku0x/AIIHk4VAugVr6eCps6OpRMgVuxnQYnYgdFVGkBxYYyMjGlTOiR2zDEqGnEBD2KhAcY76k8o3irmCRfjLvrQlotkYuCCwViZd65E27jd7FcWSNjN4BRwjAUDV6jqutY4cLffyYSNA4BOHDZbTV3tWk5JbCzQpU8+6rjIQL8/KghiOsmeextVRNfVxkSqcHlsXFqJMDB4wp/URdjC18yqMs3ph1tpS7sGrZ1UDJ/jhk2AhSxFsNPr/qEm3Lto0sLjd6QkKZJkN6hSuF1fSRWuOJ5bQSsemer/XEZ0i+zrMLs260Jwk1Cje4mtSvcfZK0WLPY7zmyMZPzdiScPuyz7BwGyVVvIS+xRcl7/sObUzLOnn7fLvhEmVPfUpXKrDpMiFaH4vySAT6bPq++PJRtGr3zijmbTOUudDEx025kvRRYX1W2HkDz4M/3jCuO+foB2EQ4rjIm71JYiAaUxqvGOW
 pVYbR2xy
 9m8eoZC0CHQzeN6ESRgFGtl32u21XYty1sHnWmm5JD/PH5TWsUj1zukI+6gpz9XrSHgGIuuXJqXT54nalYO6WXV4Y43NiHoQr/9QoYfhHrvgxX19lWkDjHxmMQYycYbrfZawx08aPDujysdpdFvi007AxhNnSYRCIZ+PlmZDOrXINlaNLnegnTJlpdAd9cDZoM44j5rYHKebx6K84R9l/UElK3+3G5QwD1/aOYQF8bst7px6lJDIAj7fSim/WlYKY9z+rRdcDp96v4nZ3msa3rjFOaAOu+4NE2yk2MmpMbSG87rKutQ8KRqatdLuVjeLIV3TtwfmwIo5uFE9egsmSObzoQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 04:04, Sahil Chandna wrote:
> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
> 
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

