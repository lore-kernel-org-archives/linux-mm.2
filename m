Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85C8CF34B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDAD6B00C7; Wed, 19 Nov 2025 09:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E606B00CA; Wed, 19 Nov 2025 09:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D466B00CB; Wed, 19 Nov 2025 09:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 269FE6B00C7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:13:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68CDD12F6FC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:13:25 +0000 (UTC)
X-FDA: 84127549170.13.6B303E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B6CF40015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:13:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4IUf4A6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763561603; a=rsa-sha256;
	cv=none;
	b=YUBTpXa7AvaSKl/PrAiypq6/tWPeQ85NwCcIwblodRIQOACgcw7PmwqmDcu2bspkpQy9AX
	HQEk3z4qr+E9ydS+xoIamXyX52olKWXuVVkL3+pZs3gnHjGeqiDlVOHwzwChZsaDmF53/g
	Tc6CLqDkbDZmASDm0QpJ+XLfY95Y9Eo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R4IUf4A6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763561603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF2vPC7UwOlsd3NiYt0a3BIvBQNaR8Rw4v8k7PTj7Q4=;
	b=4Fry/ZZANVxeyLaSxYC2ETmgibVxpjrFa/YjU5Hy7gXrNm3xk7NUzDIPHnCAsH8cWazpYA
	Vnb8lRSv9LtP/E0REdkAnzVQd8lVz1mxX7D4HW4OnIo80Uj7k8Db7y9Htf8nvZHHa0UHcZ
	8HgCe478qoCe0wA5/jpPMX7RmgnMh9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E65F436AF;
	Wed, 19 Nov 2025 14:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF76C116B1;
	Wed, 19 Nov 2025 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763561602;
	bh=rqjqNRbRszjQKubEqVaUkt2FhKH4pijMfhuEdiOhbZ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R4IUf4A6uAWakKXxbOj1j8lpcMRpRa2rxLkvIsOG3ALqxvAyy9QdxfzlX/Hz/Rl6x
	 PsDI8UfD6YfYkjGRINHuRSELcX39I2mbYNrJ1zQMwAo6kiSCUmah77Tiqeya4uinCF
	 bwfPG3GGF0mI2BRK/sAYfo8ckgxPT84njcyL848wxhbBjJHrkwfCQ49wpfAfTy049y
	 8nO08anlebl7fJVrg6FICllu2vl6YoxMGg4PHQbvFcN4BnjsuzD+zKTtwuwWYF8ApK
	 USUQjBKrnVNA97C+uYnrFPUFaD+qkIkllIkaATGXlMkhaLoKkYgf64PXNJa3ntVlYZ
	 3P0rID4Qb4+FQ==
Message-ID: <dfb089d4-0be9-4dfa-a45c-0888cd2c7bc4@kernel.org>
Date: Wed, 19 Nov 2025 15:13:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119124229.e4cpozqapmfeqykr@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119124229.e4cpozqapmfeqykr@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B6CF40015
X-Rspamd-Server: rspam07
X-Stat-Signature: mhqrtgkidghfzh7xbdccku4hayh1ybtm
X-Rspam-User: 
X-HE-Tag: 1763561603-884019
X-HE-Meta: U2FsdGVkX1+kjjFTfVWeKShyZ23nEZIxy0+mV1idxpHCN8fappLchAlvpCWsk8fM1uVj2KnZsdY3+B2leMAIjK3yrN4H1ZGJqrgfB2/9xOPbvNx+wT3+9uIUg3o+GIDRfrwh8EI7irZhUgO4XWqSktXeQ4dCFaJ074B68ocJlkuu9+D5+/IxQuh3/1mKSw1lFhTWAs9w1L6sJjHVEmnjaPMPF0/MGWjt6liiwlKbgdEVN0dvMBE1U7pNQu99IV4lpewNOSwRc9ECZj0JtPXjIFidQr8XvZGB+aYPcWUQKMd1xwWcodXb/lJvP5Nr0B3vgKIiVXXGANOm6JzrLlroWmrNFChEBsQH6ugssECKD7WQR41P6RJ3GWzPc5Va0a//yHWu3MRjQW7nFq1LqIv2J4prOX+2POYxl63kne1g3j6yhOegud+IjZOAmGEFygDVsg/dtPVACfMihiwTg/LeLEdB08oweytm7HX4yNkQjgfpicw06lqT6+4EZYcrI6/8j1BvWQ6utiZPG2pRqx2wYA9DquE0D/qqCNEDDsdQ4NsXHXIgPNONCqtOy0oaN97VKJv0PfcPc4JxTs8egy/kWUTVLoFiAu1vZpJt/wjdYMzNILZo8gv7mQHX6oCKXdGLgcfWMlrPrVRFOx0Yc1GnBijf3Ubq4osQvcerx9xWBPWFBVuU84xS9a595tnKdDrpFiqbeQMLlmAoS2zOLxCm3mbFgV5hb9835XEVA+O3zCzTPwzmK5qfLKB2VJqMCmBFStHbGoUUzk++PB8cgurGvfCddeL1GyYiUEFvbzAHTC9yq6Ofwrj5AvBOd7G5btv0e/lWlNPN0AtAWDAVNqCLHUpX0QN2EcNePZ3x1rppKTNK+n7dJw9ORpODh1Sn1SlW16yvs6tDg8X3U+dcEiJero9pw/QNV/iaf2BrxD55GFSWlb3/JLsz2WrOf4GuuzNmEmCYYizmQMbEA6ymx4F
 fZ2Qs2xM
 9tlYUmhZu7DFtLuA87+LRNr0ja40IPYocTQfAKMYJjHQncNb5iuXKtEipBw8BOz2YhhPODXn19oq39zQ4aomi270oyY5SR30CmlMHevvmdq4zj1fN+gQMBuDidjtygrYcdjBheGvIbJtmHj4St1K53p9WvAUDLgGU0DTp/0bFtPwQ2pO7i4Y+hfAxQoOhwTip3wvLo3LKkL75qCaO3QRvAFBRM895fB0N+pD4fyk4/DrWiN81YHoUkx0l5rriSVvRwIi6H34+48CQarveYblmwAZxvJIdkPrmNm1OzzydHnFhcBbTGcXP7oHFGAbEE/WHnMUveL5U8dEbc2wVp2GduUVnG+OPGM7xp4AS/cdZDZkdUXo8Z3vg1NSNqJD7JCpjauV/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 13:42, Wei Yang wrote:
> On Wed, Nov 19, 2025 at 09:57:58AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 19.11.25 02:26, Wei Yang wrote:
>>> Commit c010d47f107f ("mm: thp: split huge page to any lower order
>>> pages") introduced an early check on the folio's order via
>>> mapping->flags before proceeding with the split work.
>>>
>>> This check introduced a bug: for shmem folios in the swap cache, the
>>> mapping pointer can be NULL. Accessing mapping->flags in this state
>>> leads directly to a NULL pointer dereference.
>>
>> Under which circumstances would that be the case? Only for large shmem folios
>> in the swapcache or also for truncated folios? So I'd assume this
>> would also affect truncated folios and we should spell that out here?
>>
>>>
>>> This commit fixes the issue by moving the check for mapping != NULL
>>> before any attempt to access mapping->flags.
>>>
>>> This fix necessarily changes the return value from -EBUSY to -EINVAL
>>> when mapping is NULL. After reviewing current callers, they do not
>>> differentiate between these two error codes, making this change safe.
>>
>> The doc of __split_huge_page_to_list_to_order() would now be outdated and has
>> to be updated.
>>
>> Also, take a look at s390_wiggle_split_folio(): returning -EINVAL instead of
>> -EBUSY will make a difference on concurrent truncation. -EINVAL will be
>> propagated and make the operation fail, while -EBUSY will be translated to
>> -EAGAIN and the caller will simply lookup the folio again and retry.
>>
>> So I think we should try to keep truncation return -EBUSY. For the shmem
>> case, I think it's ok to return -EINVAL. I guess we can identify such folios
>> by checking for folio_test_swapcache().
>>
> 
> I come up a draft:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7c69572b6c3f..3e140fa1ca13 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3696,6 +3696,18 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>                                  "Cannot split to order-1 folio");
>                  if (new_order == 1)
>                          return -EINVAL;
> +       } else if (!folio->mapping) {
> +               /*
> +                * If there is no mapping that the folio was truncated and we
> +                * cannot split.
> +                *
> +                * TODO: large shmem folio in the swap cache also don't
> +                * currently have a mapping but folio_test_swapcache() is true
> +                * for them.
> +                */
> +               if (folio_test_swapcache(folio))

As per discussions, that would likely have to be

	folio_test_swapbacked() && folio_test_swapcache()


> +                       return -EINVAL;
> +               return -EBUSY;
>          } else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>                  if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>                      !mapping_large_folio_support(folio->mapping)) {
> @@ -3931,8 +3943,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>          if (new_order >= old_order)
>                  return -EINVAL;
>   
> -       if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
> -               return -EINVAL;
> +       ret = folio_split_supported((folio, new_order, split_type, /* warn = */ true));
> +       if (ret)

I'd prefer if folio_split_supported() would keep returning a boolen, 
such that we detect the truncation case earlier and just return -EBUSY.

But no strong opinion. Important part is that truncation handling is not 
changed without taking a lot of care.

-- 
Cheers

David

