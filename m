Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D785CF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7105C6B0023; Thu, 20 Nov 2025 04:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1286B0024; Thu, 20 Nov 2025 04:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEA76B0026; Thu, 20 Nov 2025 04:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F55D6B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:27:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 531BFB9334
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:27:28 +0000 (UTC)
X-FDA: 84130457376.27.2C80D69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9AF5440012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:27:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHEGkPPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjAfZUSXgNo8P3d4cu/XfsI9n4zfkpZv6QVo64KmUAQ=;
	b=HnLZacFfec5aPwGoAZOImzAsPC1gRKVdUq0X2LrHoCn7n+qfHMbSKoJ5XXTy2TseI05w/I
	/xvJE2A9ksNUhobi5vzt1puRfqutThL3oJv6kyljnoihICd/N8R4FolZ2vos7oI2vblHEO
	+Sys2QzAzz8C1pQOBUWzAZWAbhk/4h4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630846; a=rsa-sha256;
	cv=none;
	b=8UVfzvw2jH/tF/QQv1HX0KgK2J4tJke/+RKfRH4pryqSMx7WDidVLbWq7K4HkZu5/5p/sb
	PDGEHo2cQ6+8JsVWa8wgw7lrky4NImJ7ZvspKvt+8pn4y+eJDHWbNIMRPE8F+M2FYEYHci
	LwMs56yQx/h9+SrqbLTVNacqm09VsaY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHEGkPPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD00E41566;
	Thu, 20 Nov 2025 09:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BACBC116C6;
	Thu, 20 Nov 2025 09:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630845;
	bh=QdloOt8cu34ANIA6zb8ozqP/R30pLrtG2CYpcwlNMT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fHEGkPPQu0ebI3D6LHZEQujaFH8VCYB4yPZR+rA+Drp09TVIcgDPn9DcClu9Igd/c
	 EgOEwWGTFPNyGKr397R19g+6P84WxXoFpGoWANv5nbwOvzbkMaMvOO7h2+XFaYZvDz
	 C0sRlfhWPBcE87N5zw4gM5jBePSf2I+h0M+KCYJ0QXJ7RP3Cgp6KuEK5NrnV+8a2GK
	 sAlJHIPMt3GGo6uBJrgRRwybVOPFhH/b2vhX7o9aPSgcwrHZf/srs/1k784BPw0NUc
	 oi02jujRz/qMBL8TWq6LPmJWJgwDxi+R4RmOTPI6eJ/K662GbCtsFuTdK14X4iOiqJ
	 GUZtCkKz0QaEQ==
Message-ID: <b051bc10-cf68-4e1b-847d-a1323552b963@kernel.org>
Date: Thu, 20 Nov 2025 10:27:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for
 folio_split_supported()
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-3-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120035953.1115736-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ym1eydnc99bfkrhp48bg5z7ap7qgm8yu
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AF5440012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763630846-162241
X-HE-Meta: U2FsdGVkX18zVERdVkz25zT5APZ0Cp3dEeBN/VD3hY8m28a46Ettf5/0aaMF2cEqq+K5Vbp6R66cDGE8PwSjDkduLKx1WWGS7W4c3I1U/00v/6G+KJZzi6L2Vsac38IJGE3ioYvafjeplOVdDRxG6VmB7MTDA6pYw0cqQc2bEPwvNv6MD8EZzVh01G15kXwTe/m3iZvVm7tGlJ0Ks0W5UpjG271L02x2NE5VP61PNKjzMD1foQoQAw/s7ELaJSpYSSlqHXiJ4wHxZO9uFqf7RQKfiQfY6dLWhglg/fbIe2iAigwY/mUhl4Vq4wtoPOpu2mWJwzE2G91qWo4XwW8yG/4vBnRW+QzZnfQEbFBF2Vbm03nml16TndA2bkNh/OtKIGabMALRU5hEwtvgs26/OiPgqxOIYmAjb6YWzsFk+7dWpMNsXVaoncgR0GRG9BSIbmTaksyq5jzt05ApzVBca42EO2tZMPPR6eLMlLahw7qQcpy9/2f040F8Sj7j82NLIWifmDTXkxf3HN+n5NdESVWvr6PnpTD3pDnKT1O4qWiDEGkJ5+yBOozMtpFAYYFmUuVAh6xvdH40JdiIKcZaH7o0Su7GAD+nS7Maw58lbGB68p31QWTS+KfM2ok0ePTcWK5lP7yIgCGxCZoRxFgZM981LbHNa9Y8K2nhe9dDem/YfkfWsG5FyK+RCj9Ra49MWVCAIYPozW55tG6DWU8hCgB3fGK3h1nEMTZ+OFcYihbsvaGVYpsQf43agbXKMlTXq57HNDb5iiWy68bwo3F1kSxc943f7SvuKYTVu+evA6UPVdx0WEe4yeTydFvYX9x6JB2yO0kHcOEHHaoB6+Yxgpu6WZnpLUu0TPzWbfJySXxo2Wb7/qtOfCM7yRWUa2Tbpo9C3lYTJY1sGHJo0vpCCqifdTbcbvbQzdbtWpa/XxcEhXJqjOBypIrA3p3XfiPRwE8yXndrx6d+rp/S2UZ
 r1UMs9rq
 nBk//l/amH3ZI8lmVcOSfCetMdQM2k8r39/oE6MSH2tq2XJqkx5i1Clw4qygfAcKW9BxTV0KOZ3kfnuhD82gwKh1r09Q+ajKYiCCm3ygn6QB74SKIBSKAAiNS6QGBhuoMRUErqnamTRx97yJnQiXJ7Copm7+AYGq+RO4SULVQYc61yvnOzH84N3hbE54xDL/TMqUfqCZQGDfMUcrMYDCj27zpLxFd7pCP5KOrd0itcsKa8RFug7yWjGUjo8sd0hs9MghweVPOGjNFeKMBA5Y2JP6v/ONuwR3SwH+TjRHfOWq516p0SIz369P9/2gPBXdMOUlHlIu436U98CZeDgUK66zghG9XKGXa7tx0OE+NRkJoMKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 04:59, Zi Yan wrote:
> It clarifies that folio_split_supported() does not check folio->mapping and
> can dereference it.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index efea42d68157..15e555f1b85d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3688,6 +3688,23 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>   	return 0;
>   }
>   
> +/**
> + * folio_split_supported() - check if a folio can be split to a given order
> + * @folio: folio to be split
> + * @new_order: the smallest order of the after split folios (since buddy
> + *             allocator like split generates folios with orders from @folio's
> + *             order - 1 to new_order).
> + * @split_type: uniform or non-uniform split
> + * @warns: whether gives warnings or not for the checks in the function
> + *
> + * folio_split_supported() checks if @folio can be split to @new_order using
> + * @split_type method.
> + *
> + * Context: Caller must make sure folio->mapping is not NULL, since the
> + *          function does not check it and can dereference folio->mapping

Only for anon folios. Also, I would drop the detail about dereference.

I guess we really need the folio lock to prevent concurrent truncation.

Maybe something like:

"The folio must be locked. For non-anon folios, the caller must make 
sure that folio->mapping is not NULL (e.g., not truncated)."

-- 
Cheers

David

