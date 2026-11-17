Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3816606A881
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=djNmh7oW
Received: by kanga.kvack.org (Postfix)
	id E05D06B00EF; Tue, 17 Nov 2026 06:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6796B05B0; Tue, 17 Nov 2026 06:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5746B05B1; Tue, 17 Nov 2026 06:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A08506B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:46:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36704403EA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:46:26 +0000 (UTC)
X-FDA: 85444433172.29.921273D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73BA3A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:46:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djNmh7oW;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794915984;
	b=r7eMTxPWHkajddBH5OhdrpBUHQX99z2ydCqD8Y9uKgibvJgZ0JL7BDApcn8sCRWsmEBxVD
	WGybSy/c5bp++gE7a7bjxrN4KSMQU6vCeP1CCFZBFaRTGoTajMvNW6Rwly6wD9MlOiP7gD
	c6gg9aKX7gi4HJuLK81RfCvy4fqESJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794915984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQTopMIqCY4zPfhDGuHy1seuNrCTYX4bZ5zOK/2bo2Y=;
	b=dZ5vv91yaIQrlKy+fzPGN4spwFR/PlpJDKrx/j2+EIn2ycdhZDpOUY7m3dJWEkJPRi8xWU
	geI5sn9MM65L/1kfg2Mvy789jLC6hRUQ++4kcmAr2uOeRfg2LOpXbnKYMTOwky1Y36E3jQ
	7+fQKtvomb8nHVj3ePMImElvO7Ivga4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djNmh7oW;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0140863404;
	Tue, 17 Nov 2026 11:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABE41F000C6;
	Tue, 17 Nov 2026 11:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794915983;
	bh=HQTopMIqCY4zPfhDGuHy1seuNrCTYX4bZ5zOK/2bo2Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=djNmh7oWaxGzZVHGeZYxIIyMfqlhZ3PZOdsThjCapg1qskB1qmc5uvQ2xEAjnlLg1
	 I2QTTqW+hwgA5XTeWC0AqZqJ8tunSQGT/vtV/WfyS95SXYaaM65PgoBCqJnF5vMAgb
	 5fObF3SBP1YiM8fZ+WvHvCM8m/9QWkjUviX+7vsERtiHWHqWfF0YHVCCN4g0pS3nmU
	 g/Liy39LTsDkcfQkzzzjhoiqAxTn7pFeiPQp0SLg5TX6ZOxA6AIFn9AB8oHfmG+TYQ
	 n3+Y6Ot5QlHCbGJZw9h6BpkG7v/GWpJBwDe1q6XhLwLQSuS+wEjgoRyjNlgC4BxARd
	 2kQph7krvKCag==
Message-ID: <366e3a1e-91c1-41c1-8a1f-f94124cd29e1@kernel.org>
Date: Tue, 17 Nov 2026 12:10:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: limit compat bitmap reads to the source
 nodemask
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, ziy@nvidia.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 akpm@linux-foundation.org, arnd@arndb.de, larips <larips950@gmail.com>,
 stable@vger.kernel.org
References: <20261117101910.1820066-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117101910.1820066-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73BA3A0004
X-Rspam-User:
X-Stat-Signature: ej9hoyjebcr6njc3bn1rffhhouhy5wtr
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794915984-171792
X-HE-Meta: U2FsdGVkX1+GArvjPiJJPrOO2NwuEielHZAWaiuKVL7qvc7ujVWmfp2/xIAer9RS2orZdjwiheQVKhf9RQ/8d4SsOA7CsJNMWUrxYGbbIW5baC5pYbri4wu3MPgwsDL4VUiHygI7wOkpLudykBSRJL3817531Cajy+nV6mbP21/LPc7mR6Qjs+RN1zXzazo/fXixCYjnAWxpqC1oGmjE+NLMSj8v1oK/vUuH6RFOSaxQj3v0Ot1hmWfEdoj5XXxLrDsV/zhjoyeJ4pTdU/rGAw64TkQlSV4eNUzYbP4RZpTf94unj5sbSeMZthJ4oEFE4ZwU4q+D/d4sANM7HWtFPev/VDTQ+GVbJiGfqErxWhJ7t4kzqfy9EDvv/6rYCXbjsPrNEXHxvDObNUE8N0aPTnHknsEahowUKJjk7r+bYdJx92+ZUOfmjARedEtW4Ruv/BQUbAYuSvk9i4TQCY4zqlzcgFUE77yZf9SWA2iMafLrV2AUA2Cq7DfPAyhSP3sygxw+cqYv6WvK8zTar2xCrD0+EOpKLAmXZdULLtUdJGlmmdesba7+MTTkh79dj/BV916fJU6t++sQK6C2VcPaakiJbD/j/IE+7fuGJV9W+1ru8DRpRXNcIbXtOyyc3ri9my6mXtNyrMHJN3UWoYNFCkvevh44c+oUg5nq2oyiczbnKBLuT7SblzVxCbpu+sXJLacIhKgdtRpETJrKVzjH7BOil22QS9KkVvPVyNfPyVLZQT+k0eOZhBEw71jXjcTh+X2GT/inzDLwwsPr9juOpru+iDAwFw08zUDJGl2onM6nW5zq00jmD5D1Z3REAjn2bEHv5x7Z+7vLNIccTiovUnDTYNDBfD0hIl05j0XrP4IYFJIKGhIHV/FQWbvRj5pHHhf8gPvl/Rkpew6URlXSPtTpJAjBdAyZ21JPjda3FnI3c60x+2J27pFZg28cNWtWIsXo9rw/MIistkdh7xn
 SVmKPRgF
 tV6FhSexqwRY/22hXUOdHPT4LDYOU0s1EZ1TPlj1kNn9s6O1SGC9y9D1sCjEPxYWfHCzWmAp5BlXfEs06zV25Iz1dx/iz1p3prAfQ1UJMmzFPl52NcE58T/E+zmsaR5L2LD4DvKMbrZgV7xwwVXcjR4CEa30i2RMAEv7R4T/j4UdYduQzqtNhh8mjxV4yfKDJ7a/OqwPxAY2uBqgbHRzsf40OxY4aTOR9lcox2R1LM8P3aek0LmnZv3QwknbhQyNsgaBhncYN1dBP2cdBMb39CJAu/rKW+rDv9N9sgRXHXOjPbaWW0ZFHXZRwROohvE0bm/9bPfb3MkVK7xJe0M9sM3wqbnroKRPyQBjyLOScrhxcUjbWpP1JcOsksxJKQszaP3aOd/E+k9PAgMgCck87Z1a2Ouoms01lQz2is+wV5EaDJRzr3n4+4ODq+XjWmgdkGUGm03jcxC7Kb3TYmcrXNbEkGRh7+TiAhwOSj92TFBuwqCqAxt5Ew0SqTFMExgI91z33td7d6MS8BMhzrPUf+FLuSXZJ741oqUkukK/O3hG4oac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 11:19, Gregory Price (Meta) wrote:
> A 32-bit get_mempolicy() call can read past the kernel's stack nodemask.
> With 64 possible nodes and maxnode=65, copy_nodes_to_user() computes an
> eight-byte copy, but compat_put_bitmap() reads two native words.
> 
> A kernel built with CONFIG_NODES_SHIFT=6 reports:
> 
>     BUG: KASAN: stack-out-of-bounds in compat_put_bitmap+0x113/0x120
>     Read of size 8 at addr ff110000099afeb0 by task mpol32/246
>     Call Trace:
>      compat_put_bitmap+0x113/0x120
>      copy_nodes_to_user+0x137/0x200
>      __ia32_sys_get_mempolicy+0x1a6/0x280
> 
> Bound the compat bitmap read by MAX_NUMNODES.
> 
> Clamping every call to nr_node_ids would remove the extra userspace
> word when the kernel nodemask is large enough to contain it, but this
> keep that existing compat behavior while preventing reads beyond the
> source allocation.
> 
> Reported-by: larips <larips950@gmail.com>
> Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 79053ece02cd4..d9177c5504879 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1715,7 +1715,8 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>  
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), maxnode);
> +					 nodes_addr(*nodes),
> +					 min(maxnode, MAX_NUMNODES));
>  
>  	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
>  }

LGTM

Staring at this once more, I think it's all confusing how we handle
compat_put_bitmap() vs. copy_to_user(). with "copy" and "nbytes".


Likely we really should be working on bits, to then only align it up for the
copy_to_user() case.

I'll wait a bit for more review before picking this,


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

