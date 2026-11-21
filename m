Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4073B606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XETjTlsV
Received: by kanga.kvack.org (Postfix)
	id 535046B05B3; Sat, 21 Nov 2026 07:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF3C6B05B4; Sat, 21 Nov 2026 07:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF2D6B05B5; Sat, 21 Nov 2026 07:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6516B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:41:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D7AB1C3C5F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:41:21 +0000 (UTC)
X-FDA: 85459086762.18.9F6EC81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BFB6A0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:41:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XETjTlsV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795264879;
	b=K7wqgFjhp3h6bzBwh+xQOBpbBH3rS0IXnJX6mGvFtWjVflSOQ707woj0/ZJ84u4wHHegJU
	hYuD59j4lgBFjOjfXnBr9EN28VT60vE15OpJwEOcHo5tdyx2YqIhb4CNnwZfPIZwy/M6oJ
	LnKYVwDltIGQ64LW+3m9xZju/x7cS68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795264879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c164Hmbr735n5mNaKtM6iTMF9AUxTNwADbTKvfj5lqY=;
	b=41drkpEUbU3uZhPnwx+3f2DlqFC/Mmy+FUX82rTtkvfa9swLZedNTARavrRbRhD2BSUwFW
	YHG6b6x12wQXypxQKleyrsTJ3Z+xCCiLst5e1zJJNtXLW7S+BUoITjmLbyFhgV9zDU3TWZ
	rd12EpF4X9YlokEKeZmiOpK9E2Cqg3o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XETjTlsV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A079601F6;
	Sat, 21 Nov 2026 12:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1C21F000C0;
	Sat, 21 Nov 2026 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795264878;
	bh=c164Hmbr735n5mNaKtM6iTMF9AUxTNwADbTKvfj5lqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XETjTlsVsLXlnYtr4HaCo3KD/0wwyfOgv9/6YcSrTwzLDDddus/bgbajmCX2JaDTc
	 yyzwzt6t1vd4pUsuCakjuppiVrAPh0L/91M5cV6jj+4L3XQ9BLNsW2smLRT696/tlq
	 Rqeymmat/niMyLDypJmXzFf4CBxe0bxWC3rC4Mzeagn6jB/lVhClGvgrp3G1Pb/J8e
	 1zmrUqtYwotOZgRPpZVrbPai9DeUdnooCp67T7s3OJ/ydEApHZZuyyV/cHLOuqvNgL
	 7Igd1A0tTnUEwfKF+biRNjqKrt/uDpBe0x6FzKq2mnb+JxQIVsjIliVKOI+NsGXakD
	 r0RtAbS8uPvzQ==
Message-ID: <bc42fbba-1c35-4d81-b28f-6b1324b34ebd@kernel.org>
Date: Sat, 21 Nov 2026 13:41:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] [v3] mm/mempolicy: replace copy_nodes_to_user()
 interface with put_nodes()
To: Arnd Bergmann <arnd@kernel.org>, Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, larips <larips950@gmail.com>,
 stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20261120185248.823415-1-arnd@kernel.org>
 <20261120185248.823415-2-arnd@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120185248.823415-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7BFB6A0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jge5xfq818oiio3mh49fp6yy89joydk9
X-HE-Tag: 1795264879-106932
X-HE-Meta: U2FsdGVkX19kh4yWbUoMXXON9ujjVVnSmTxFiGHzFdC/ZH7F3kozGxiv5V019ryyFy13I+3ZImJqwfTbmJer/2t1aNAMHr6UEKMlevkb8+fCxqiOU6tSkYPBm8u08qjBwV2vCpTWIyHl+PwYXW/NIWexlgHLKKZERCAHCJkGVLlnvT1rH6BbueU+FWHxXy2h37Z7u8tlRk+6mvXS+kilGxiyFr0Np44mEaSqpqoDWt4PAvJQH7U8AsAdKD1SJE52sil+yMKjEt6/ulC5buSPtpUjddBemtxVWWpRKym3OF6h8U8Mpa+B9ndORkwL36PzicZpMLz0/FvKxnOhKeaR9XP1aLkrp6h+ISYX1zRM8nW7dp5QDU1lFNHMGcGxc93Zh+UrwkBbDad9Q0vW0X91pMRt6PpLpXp9oks54oOgAmICzbQyTYVUaLUYlyz7FrV6tUbqmYW1QYpC3Wmcqo5p7rAUseEdrD4wNvLdLjwTEgdnQloVmNe/pKIPyGspoYybvTakqe+vMy7/N4u4ZwovrA/ZHsq6YEDAahcq5v92hqLGZQQj5UDA243tatZTmD8pSVSS4BiV743fmlKvZsb3ICumkQ2BENadvucNy/NoQ5nI1MjPV844X3B39MrJ5bLBOExoxf6R198SBbuRcdUPc7J8HmFzFhoCtLPVXTr74FmAbRZcKx8sMQ/jiGgmwAs+X8k13DZ+tvVAjzCTLR00VBrBZyPdAjqfpRIRnMGjRRg7NfxqD0ZPGoR/kuzv03sYIjufuteaZfviuHkqkN6RIzxp+ZlV257B9yNt0L6Ow6C6jEhxh1cTX0Vv9ZMyE/S11klWB1xGjaH1utRnQdzAxYvF9Dxgmnp5qMtyw1pPNkzzuxrUzrsatl7RhC/YX1xOOTGgRPT4B3OQ80ES2WvoaTQT3iMIA3qsH4Gx7W3UxvTu1lJGkg2EiYrwdIJ0LXPFviGJe9eOykGZEL8q5lj
 NcdZzDQz
 UhMncKX4WmGzejGervSDXOyBK9bbkdAnnF3jyhCoCWPLWHwMIt2sDoeJeC6+z6iOjQLV7rt3IgP2Z6gfiXGYA5PQ0tPdA+fPkxQRMEFYF1jgvy6zKmccJgcijxH/n5URSur6clTWm4tVyh7TMrto2OWpoCm14dTmUPYfj9u9UPHBEQF99C3WGsC4gkFMwCV0myOf6OTpLxnjza7Xx+S+sjXdpEkhH8euAUBoM8k/9mNnkI0x/Qb7qghVZdS55e5j1zQE+GnHlcJso97Fr9OXPEfQvS0uaSszu1s3ydKMWv54igKypSDiZzC8xeRfVApRsV0nIBIkWTVRqWeW6u8Wwrozr+qmDYIszRH73G8nZ66Zy6o7WzYEDoE+eNZpT5r9aDlu6kWaOZgUFHKUbAfbMbA+fuHujFPBnk7I6Zs0VJYIWLCxrYBYxsSWhVzQs2PM5o2NStk+G7cSQCkLte1yhc1N+iGEis9rOETjzU04DfsosuuQIHaQZVqxf2ZPbJgJmBDfek0bESs51WxYEoMfnCx3kHXiX5vDVWftrQKGJ7fgpZrH6uLtYdkfL1MaYCfO/h+ZzwDpNNIB6OEP/V2pjNiUbuBpPnYajcv26dFVyJuLXwwg6jAAZRU/W9+u/5uWpPP0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 19:52, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The get_nodes() function handles copying node masks from userspace,
> while copy_nodes_to_user() copies the same masks to userspace, but
> with a different argument order and slightly different meaning of the
> same variables.
> 
> To make that less confusing, change copy_nodes_to_user() to look more
> like get_nodes(), using similar name and arguments as well as adjusting
> the maxnode value once, and restructure it for readability.

Could briefly mention here the change in get_nodes() for consistency.

> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  mm/mempolicy.c | 48 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index afe614efb77c..b240acaa8cf1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1736,7 +1736,9 @@ static int get_bitmap(unsigned long *mask, const unsigned long __user *nmask,
>  static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>  		     unsigned long maxnode)
>  {
> -	--maxnode;
> +        /* User space passes the number of bits plus 1. Fix that up. */
> +	maxnode -= 1;
> +
>  	nodes_clear(*nodes);
>  	if (maxnode == 0 || !nmask)
>  		return 0;
> @@ -1769,31 +1771,39 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>  }
>  
>  /* Copy a kernel node mask to user space */
> -static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
> -			      nodemask_t *nodes)
> +static int put_nodes(unsigned long __user *mask, nodemask_t *nodes,
> +		     unsigned long maxnode)

Two tabs here here is the preferred way in MM. Can fix that up when applying.

>  {
> -	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
> -	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
> -	bool compat = in_compat_syscall();
> +	const bool compat = in_compat_syscall();
> +	const unsigned int word_bits = compat ? BITS_PER_COMPAT_LONG : BITS_PER_LONG;
> +	unsigned long bits, node_bits;
>  
> -	if (compat) {
> -		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
> -		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
> -	}
> +	/* User space passes the number of bits plus 1. Fix that up. */
> +	maxnode -= 1;
>  
> -	if (copy > nbytes) {
> -		if (copy > PAGE_SIZE)
> -			return -EINVAL;
> -		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
> +	/* Don't exceed what would fit into a single page. */
> +	if (maxnode > PAGE_SIZE * BITS_PER_BYTE)
> +		return -EINVAL;
> +
> +	/* Process full words, which depend on the user space ABI. */
> +	bits = ALIGN(maxnode, word_bits);
> +	node_bits = ALIGN(nr_node_ids, word_bits);
> +
> +	/* Clear anything we won't copy below. */
> +	if (bits > node_bits) {
> +		if (clear_user((char __user *)mask + node_bits / BITS_PER_BYTE,
> +			       (bits - node_bits) / BITS_PER_BYTE))
>  			return -EFAULT;
> -		copy = nbytes;
> +		bits = node_bits;
>  	}
>  
> +	/* Finally, copy the bitmap. */
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), copy * 8);
> -
> -	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
> +					 nodes_addr(*nodes), bits);
> +	if (copy_to_user(mask, nodes_addr(*nodes), bits / BITS_PER_BYTE))
> +		return -EFAULT;
> +	return 0;
>  }
>  
>  /* Basic parameter sanity check used by both mbind() and set_mempolicy() */
> @@ -2054,7 +2064,7 @@ static int kernel_get_mempolicy(int __user *policy,
>  		return -EFAULT;
>  
>  	if (nmask)
> -		err = copy_nodes_to_user(nmask, maxnode, &nodes);
> +		err = put_nodes(nmask, &nodes, maxnode);
>  
>  	return err;
>  }

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

