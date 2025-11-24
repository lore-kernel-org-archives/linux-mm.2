Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CE4CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0399C6B002E; Mon, 24 Nov 2025 05:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011126B002F; Mon, 24 Nov 2025 05:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90236B0030; Mon, 24 Nov 2025 05:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59796B002E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:45:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BDFC8873B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:45:27 +0000 (UTC)
X-FDA: 84145169094.21.48EC70D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA160120003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:45:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3C5EoZG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMcpFgpONOChoFupj/3wD9JOhkPwknvwBoqPAxWBJvA=;
	b=PbKwbOrk0fvNfAr7a2r1yJOXtbZ0gY1UW93aJ8QNnTsEUOXMrQTI5RlHobyy7rG4F/cB1Z
	Zq8syKalsIZbBloTeokORG7+iJS60tJyx0lVXsm6KDwGMWHKTgn7i5iKgyWYNFxGMMeloQ
	Enaq2Vbpz1bixWMEZrD/JjSdeim+Mwo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3C5EoZG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981125; a=rsa-sha256;
	cv=none;
	b=vqRHo3YURvk4hrg+s8oznQoMggM1kXBqF9iDVswPCWoszUdPIhfCV2iZo2D1a/5OfadajE
	VIAG4oahK8+ZqWH/aalFMDj756rjpGnKMNA/Kx4qxGWrVViUtDVFsl6EyMNNdxkWaA8nzt
	yg705iAzwcFDLQVN/UGA+4YcmjB3d0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB9EB40AFE;
	Mon, 24 Nov 2025 10:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681E8C4CEF1;
	Mon, 24 Nov 2025 10:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981124;
	bh=DhjBPsIsvi+3hdOiUeGVXZGrJN55FvoQUeL4YX0ligw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E3C5EoZG0jUHNt9lAaE/wc7g783VYAB7WbbNygGrLvS7BDAsv0A1GpIiVGv8QcvOF
	 vqAK1plyG6xwxTZMEPvZFomI+EenIFkNOScr8o50mTlCHSDlZ1QTLDyk07dFa9Wrgo
	 +aplFYXFXSdPf17wlX6VKcHWX3n/m1nqkHjzNb1RLTaWkprzOROFVJcsvvfSdIT8my
	 m2t0XGl2O62I3Zje92HQfDzggNothUzPYppyW8BYLqd3zin0XJc7CoLgkZOjedVe5K
	 BysexX0b/3zbM8CCF+VG2Ig41TjDxkiqmtQ6aXkV7xmMldWXK3HO1rjSBQU669T4LE
	 hbstHYA0WJ5cg==
Message-ID: <a4bdd286-ebbf-49a2-9b98-fa5197e1a6f3@kernel.org>
Date: Mon, 24 Nov 2025 11:45:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-5-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122025529.1562592-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA160120003
X-Stat-Signature: 9d8so6j7hcn4owwnq4wnnw8z5uospf4y
X-Rspam-User: 
X-HE-Tag: 1763981125-777721
X-HE-Meta: U2FsdGVkX18Cg/5m0pfn+3iKi2O+R75cPYvSbfg7rGr26wUKUkLV43gk40ieMdpyjliDEam6JP0+JEJ4avjm2kLuQjEBgogmoK7CmAFd2Oks+2j3GhsEKvFQuv41rprR9EreyPBSk1sjN+V8OScrHXh3+gUerm6BNNuOiF91wcym6Ghw1Q94RwQP+FtrTRBkL9KsKPO8wqC/o02K5dTEH6VI1B3yaUjXFgw5pKaw1egn5/skakniY6jjYvUJK7r7L0mX+Slf7bPo5XL14gkLGMlNbHyllBNmx5VU73hVkRA0lZz1pmXTU1kMDXO26ZamN1szW9PKbF735sN6nWNsFZ2Rq3mvxn0h5K8Ziai5q8Jqd9n25ZQBLnR8g/tmttJnlLx1rh61MxpAtk+7jAm0DIt8INbW4H2vdid47LSPpjv7kAaAqfLn0Hbnkb+j45lwbURDKx9PmVLq4lOSYK75LV1ouZyG+fj5zJG24ExQ0sEEy4KTgccPGQfRz87HVh16h4JZb2Wh0/P0ow6RO5Sd1pv9P+VUZmWTXfNtRPSKM0aqPXRwHF2dDrLp1zrtuE0dGvBj88sZvfko8BGd7o9z8gZTvI/9jtuOuATRbujFEhuheFMq2pPI+5+VjTf4Ds09AXvUzEqbvAlINr87Orc4zHpDsxAFFqGjYd+G2NG3/xOZeIV8EhXjCabeFTZS1J2HOA9MXCEc+WLZO/N2N25GqpMwRlst9f+0piNQrlCb/PaeLgkE/6mSrP6m8hubuiAOy5X136E+42jxqjcgxcuNo4o88VWkNH0IgKWkvMFVvyomod2WN1jpn3Jpo6dmrCY2BimW8ve4I+QlGkeNP0WLBZg3XOfu3BHdWKeizedU1NBZvw6atxXq9+2vWaPmZXGPnthKOLijp+w6EdWfVL1sWDe2FgyUPUWDlChQnmdie493tocNTRsTuHOQy0ISDIwnBUDXYqLUDQFFIVB93Sz
 pJaampfF
 JOGmOMrBmrGyR89azWtSkzLCeu++fmxHt6NowQJWNbb+T284z63Cbmu5qW17eI4NgHIRl5eMveXcj3kcZEwzMJ2gxOT0YCUiG/SFGu1a4qChK1g9MTiMwu5Lq8+vN9i0uE/w9stiUFW9euPYQB8JFOh1y1bKcPxYo72tCUlddpmSKHmBp+55yKv0BxWJ7oMV0693mnJflQFOk0KeWJ5+aju8YBTHUK3hemwaxZNu4+UrVRr6DdhgrLhMcrZPrM8Ij0kZTqRK/1Nr+tU3643CCdazDM+sfMw2okAPiNRDDOWscHNgNE0fuY+eNO7hEFQmsfUC/vf1uezpECxkpoIjxS73zEuFrOt6kOPDFa0LIJSFYXix96hUhKBo3vxh8mcg5DXqi+RURuMcXwSI6R1iXstVaV2yCRe2Mc7aMT6PtQq1vdu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 03:55, Zi Yan wrote:
> The "return <error code>" statements for error checks at the beginning of
> __folio_split() skip necessary count_vm_event() and count_mthp_stat() at
> the end of the function. Fix these by replacing them with
> "ret = <error code>; goto out;".
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ebc3ba0907fd..a42c4f29ce4f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>   	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>   
> -	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
> -		return -EINVAL;
> +	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>   
> -	if (new_order >= old_order)
> -		return -EINVAL;
> +	if (new_order >= old_order) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>   
>   	ret = folio_check_splittable(folio, new_order, split_type,
>   				     /* warn = */ true);
>   	if (ret)
> -		return ret;
> +		goto out;
>   
>   	if (is_anon) {
>   		/*

I guess this is not Fixes:/stable material. Wonder if such early (mostly 
-EINVAL etc) checks were at some point not intended to be counted.

In any case

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

