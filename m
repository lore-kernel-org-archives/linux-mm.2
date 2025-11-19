Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91D8CF259E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 08:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2526B002C; Wed, 19 Nov 2025 03:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99FC6B009D; Wed, 19 Nov 2025 03:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6806B00A2; Wed, 19 Nov 2025 03:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEA9B6B002C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:58:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5353FC015D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:58:07 +0000 (UTC)
X-FDA: 84126754614.02.1910262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D57C720008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:58:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3SKLotS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763542685; a=rsa-sha256;
	cv=none;
	b=XAKY7XgwGS9haBSc/ktQDPb66FhEnMvAolfjUzWx7XTx1GoWH2xVa3ZGbssexzcL8VjNWi
	9Fp7U41dOgrMIgx3HrPeD90ISc1QTpptjukeF3I6F6RjzgKOpdIT0jg/ALd72tFQaDvJJt
	oUN3nlcaUzf6+VLzsma1dOy/2BkJu0s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3SKLotS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763542685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vB7y19qFv1FPZh7hVNJXERZbT1mfwdh1Es/NnsyVrM=;
	b=oGJbWXj3TgG6Ba+YMDvO7lEOy8fpDadpCs1H3iCOCSfxRMwGV5tyeTgr/BMFUgeczslDLw
	PQ5x7zCDT9hPDlSp6v2pevAxzq9xC76O65BNfmyMqEX2btqdnNt0HZWRn13WZvuvaYR6by
	otDeySifooBlRG/F3qfzeIZjVGX3Noc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08FEB60138;
	Wed, 19 Nov 2025 08:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F14C19421;
	Wed, 19 Nov 2025 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763542684;
	bh=SEyrQRN6vxWoOkBDR/9CmO79XgbuxRdUsBZ9vRIt9XQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P3SKLotSQD/ek/OairstDSQ9az94gG0MpogyOM85oXkDwzdCT9p7R5Ytq6xzjlsPB
	 WYUHTFBPWFMIxosKwStrZl8m++04ArWKDevNP0/fFWu+uZEcPbYZwQRsilaPmZsxqM
	 WzL1iO9XjczlkSXxW+Q9iwqUXrxBCzlKoCDqstz1IcqV2J353BGLKM+XwBmVLHDQ9u
	 AYK9IjbHcqx1q0cB7AhB/6ZMOUeaCp0kR4EyBO9DdCcLMC2uk/AP8x9gcuq8HzNqbd
	 uCMw1yyUp+cmjztWQBpcT8OJn07t4DVJRxTmYk5JjGB53GaIGeOTgIrhvQs7S73jhS
	 ojEZbG5T29FNg==
Message-ID: <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
Date: Wed, 19 Nov 2025 09:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119012630.14701-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D57C720008
X-Stat-Signature: j8gen9mx8n7dx9joei7j6xn9pwgo1zwj
X-Rspam-User: 
X-HE-Tag: 1763542685-850690
X-HE-Meta: U2FsdGVkX1+qB3cJTgtz2DHnU1Uam9rQDFGTiAyL0DdhabLekD1UXJaB4AZAMPNIEReEbU2K1VPw8a47qFgbJ+CUcaX0BfKlbJqnnzKik41dfDIbe08HMeUCfNyIZWgGFtLsoU9A9tQF5kLRpl4YowQGfEgJbMbFRElxp01kidaRwg5nbyTjetdkRAsWEL6GFq7U5e0H2n7In4py+D2HqAS2/MlVBist+NlNxfvz9yQkfWRHsx+V/BzZQYQeGixkkFs8RaAKC/d/lzuFebqrc3qiy9wj3j/vSBh1NTY1OrBXbawDzK0uh3aWyFdOTBV2IyBsBxA7eQaFbAs01XjnxWv9EjsC6ZznbFxK8r8isTc+S2MMsBjk3hbLgd1JawPLmk1FjpG3UIKvtvFpZvmW/By2nkO6JGEDXrH7ULvF2RXg80sqOdoPhudEKc+Eu5ZRzOpjLUxyqUvUiXEgGstJXlLHlqqRzbww3TM0O/ZaZJYCBEiskttA+wnOf9g737f6aJ3hViQMxeMdFVfp+KqP6BUw51tGGQXRpADUeDREQSD/W4jbGyv1/vKAWgHR+cWwTl8GzlVCZZ6KUphJhgdkybEbVNEaMPm6W93NlpfiwsFSGfbwfBZr7mmuLNzD5UlnYGQcxuH30VKAfYhxVDWrSonyLVF+A5o6Ea49fNq3tOEzP5E0XOqq6KlQM9+BYqZy+jHt/a1T8mVsOqYyxVVnSajVURuE8qbMQS3W/VJbq60cw4Rz0iX0ekW2f3gIq7hHTPDcww+6lD66LWgkbMU1xAH4KIB0nhykUhgHYLPRKeCeXMC7oyhFhOs3irDg53mkhTD2dGa6aPFrVEUkXqdKJk/RM39DQlb0b9QTD4EMTx2SS/dkD+ve0vfpXRngpwwj3pAVLA04B/SvtEJXL0bRyY+hJptX/PVedMy5M1dJNPbPBRMpWpcHnaLmrquqbShv0QScuVK+WyHhPcDP7di
 U/tZ/zcJ
 SOv+CH+oEb8aooN/HrEP1f3Wx+5A1hdC7CLqrDOb6r4LLx02h6/YUnmWz2UJVMxtJU44x244o4JwzL9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 02:26, Wei Yang wrote:
> Commit c010d47f107f ("mm: thp: split huge page to any lower order
> pages") introduced an early check on the folio's order via
> mapping->flags before proceeding with the split work.
> 
> This check introduced a bug: for shmem folios in the swap cache, the
> mapping pointer can be NULL. Accessing mapping->flags in this state
> leads directly to a NULL pointer dereference.

Under which circumstances would that be the case? Only for large shmem 
folios in the swapcache or also for truncated folios? So I'd assume this
would also affect truncated folios and we should spell that out here?

> 
> This commit fixes the issue by moving the check for mapping != NULL
> before any attempt to access mapping->flags.
> 
> This fix necessarily changes the return value from -EBUSY to -EINVAL
> when mapping is NULL. After reviewing current callers, they do not
> differentiate between these two error codes, making this change safe.

The doc of __split_huge_page_to_list_to_order() would now be outdated 
and has to be updated.

Also, take a look at s390_wiggle_split_folio(): returning -EINVAL 
instead of -EBUSY will make a difference on concurrent truncation. 
-EINVAL will be propagated and make the operation fail, while -EBUSY 
will be translated to -EAGAIN and the caller will simply lookup the 
folio again and retry.

So I think we should try to keep truncation return -EBUSY. For the shmem 
case, I think it's ok to return -EINVAL. I guess we can identify such 
folios by checking for folio_test_swapcache().


Probably worth mentioning that this was identified by code inspection?

> 
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org>

Hmm, what would this patch look like when based on current upstream? 
We'd likely want to get that upstream asap.

> 
> ---
> 
> This patch is based on current mm-new, latest commit:
> 
>      056b93566a35 mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
> 
> Backport note:
> 
> Current code evolved from original commit with following four changes.
> We should do proper adjustment respectively on backporting.
> 
> commit c010d47f107f609b9f4d6a103b6dfc53889049e9
> Author: Zi Yan <ziy@nvidia.com>
> Date:   Mon Feb 26 15:55:33 2024 -0500
> 
>      mm: thp: split huge page to any lower order pages
> 
> commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a
> Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Date:   Fri Jun 7 17:40:48 2024 +0800
> 
>      mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
> 
> commit 9b2f764933eb5e3ac9ebba26e3341529219c4401
> Author: Zi Yan <ziy@nvidia.com>
> Date:   Wed Jan 22 11:19:27 2025 -0500
> 
>      mm/huge_memory: allow split shmem large folio to any lower order
> 
> commit 58729c04cf1092b87aeef0bf0998c9e2e4771133
> Author: Zi Yan <ziy@nvidia.com>
> Date:   Fri Mar 7 12:39:57 2025 -0500
> 
>      mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
> ---
>   mm/huge_memory.c | 68 +++++++++++++++++++++++++-----------------------
>   1 file changed, 35 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7c69572b6c3f..8701c3eef05f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3696,29 +3696,42 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>   				"Cannot split to order-1 folio");
>   		if (new_order == 1)
>   			return false;
> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -		    !mapping_large_folio_support(folio->mapping)) {
> -			/*
> -			 * We can always split a folio down to a single page
> -			 * (new_order == 0) uniformly.
> -			 *
> -			 * For any other scenario
> -			 *   a) uniform split targeting a large folio
> -			 *      (new_order > 0)
> -			 *   b) any non-uniform split
> -			 * we must confirm that the file system supports large
> -			 * folios.
> -			 *
> -			 * Note that we might still have THPs in such
> -			 * mappings, which is created from khugepaged when
> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> -			 * case, the mapping does not actually support large
> -			 * folios properly.
> -			 */
> -			VM_WARN_ONCE(warns,
> -				"Cannot split file folio to non-0 order");
> +	} else {


Why not simply

} else if (!folio->mapping) {
	/*
	 * Truncated?
	...
	return false;
} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
...

> +		const struct address_space *mapping = folio->mapping;
> +
> +		/* Truncated ? */
> +		/*
> +		 * TODO: add support for large shmem folio in swap cache.
> +		 * When shmem is in swap cache, mapping is NULL and
> +		 * folio_test_swapcache() is true.
> +		 */

While at it, can we merge the two comments into something, like:

/*
  * If there is no mapping that the folio was truncated and we cannot
  * split.
  *
  * TODO: large shmem folio in the swap cache also don't currently have a
  * mapping but folio_test_swapcache() is true for them.
  */

-- 
Cheers

David

