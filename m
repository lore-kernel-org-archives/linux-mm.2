Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88061FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 00:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943586B00CF; Tue, 28 Apr 2026 20:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4606B00D0; Tue, 28 Apr 2026 20:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A8C6B00D2; Tue, 28 Apr 2026 20:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 720BA6B00CF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:57:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E158BA050F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:57:50 +0000 (UTC)
X-FDA: 84709781100.21.9691C2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55053160008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:57:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D64EpzZi;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777424269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZg1+0c4lVkyx52jPOh0L/vR22JzykiEvWMyk4/9Id4=;
	b=HM5YZDGP7NAzrU+TB7gMwL6FXHaLOT+WHFTLTqe8wphbPUJUQazE2E0tv6SPatoKm0nZtw
	D1Ojr9qUmRv5xPKSHVP0h8rf0LdKIHKwfzuv9kxMgYIGMaHHe+TkQ99PKuTuwciNKuXs8R
	I1HZVBGoX8Zbb9lVtJhYjiSyRCm6bZ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D64EpzZi;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777424269; a=rsa-sha256;
	cv=none;
	b=X/ur/d5JCbsV+5d3FVMgUZMpahDsPxGG/L/QQPcJ4pzcsFrOTkvQS/RdQNWL4DFJJkha1R
	JufEWoXp8M4EuWO5eZfRS0oirg776Z2pDe0Wo+FcqIs5vPITHWnj0axDV3wn5qScYmxhc7
	ZG97zyM6CojMC8jUUEhp0kqCUxYc6tM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A342260180;
	Wed, 29 Apr 2026 00:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5695C2BCAF;
	Wed, 29 Apr 2026 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777424268;
	bh=dR3dNMwJfMpAWCWRKlY+edR9MACregw8U7mpdn1y6B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D64EpzZi5Bhi6P6rHpHmpixMeLLgFKmHe1aQgRErW5NJz9wyrZEAfeR+I9jWSVpMU
	 M3cQnc77z38xrPy0p9g8VeCwGbnjQ57phC62IonusCds9oD6Pb1dOBCLcoi6hESGpt
	 cmfWHxcc31fn27x57R5WxtZz9a7lURqj0gMIwunFl3rXD1f8bs0oUqSs6wTVjl46UL
	 NHJirKBdPvHfykiStSxTusv0GrwFXglOi+OPoLama1+GDlIPV18TamYpMiXwm5KaJh
	 7ncpyMxD9EvhkQETuyUMo4/TmLL7kLoc7tAcj+FKMeB2NwilO6dN+JFPoNYAxJfRPL
	 3RWBnYX3FrD0Q==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm/page_owner: add print_mode filter
Date: Tue, 28 Apr 2026 17:57:38 -0700
Message-ID: <20260429005739.88517-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428071112.1420380-3-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5xhaj8jygx9g78b3oy898yrddn3ahqew
X-Rspamd-Queue-Id: 55053160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777424269-111401
X-HE-Meta: U2FsdGVkX18/ctQJ5HDoixv3IYgS7VR6mZe5vJa+R36jWjZlgOGGPYh/xg84enJ505A/0GRAKFtza3dKKKeUQKWhchqzuJWWiKh15VVKwv+HZhHrD3GPVvcU/oWS2BPrVwkCxTOvx/ojcS3bsqRO776Q+IvWre0ACTtPeus1oEIiwr9Pgci8KmVfcLX2cVUt4fn2mmTrmcM90rL08ft78u+K8Sb5zjbYyGfljbOEoFp6aJA9qKzK8GZHWGpAcuZz0IdYLVzwWeylj1rwCLgnwNDCZXVD+vi2UmUOJR0BmDp0jTiIHvyH4kghsKY5lMoyenfkymVlhQ1GmXrRmCRxE/ahqtOD8x0xIcDFwlSbrxJMc2evdYkPaCSQLs7JHlMOftTdyK+lZjOSqLdUZ3l6iov6T535QW3f9xkfLXpZg4EHFpV+wAuKCmHV0z48pn3LpKDMZLWFnJ5o017ZFsvbd5Z55YwSBuc3B41Nm8D1z9xAgLfPzd64++EUCN89FVC0ORNBHVYIf4i0rkojB5kXV84ZoLrFb7ku1W1awr0xU45lMkWMAd2Vmr0uGkNRY2YGwhBflBshZRxTIpFGlYZZHEYKqQXhlwO3rYtMBLhJPiPjIbz6AbT84g19XctcGTRUmxAehRO5nH8kL+KEwcvdFhPJejge0IeL1tT/pPSk5pW1TK4yFqDsochLYNp90dUZPADIqfjC10vQTIX+ipdZkWaNS627s2ggR6sVRO+9SLfN4MWu2MhaSdQ+zLV11S1mUPjUFmF5vvuVLYyl2UH6hKI67EAc3oESfztoB4HMzL4tea02nQO12TXF9nSsCBDzqrFcnXj1DGw8ad6JkQcoOK+bAKvMN2pE743j0+b3i+lZOcOdxnnjpwPTKmN19LvhoX6EOrHMSSmDQu78gYx2WIBkFVx/aDSEH8IBjraUVbj7EnfsXzHlEJnthG8UgABK7+lOS+XYcVIt+R1f6Po
 pwkXQ/vo
 F0tnZq9IlEwbTnBNLxHUKJQmSEFpAihRrtAalF9ugnRHRaj35DefJLkDDy6vjOHcqXs6YFq0lwWy1WPzLGFeHQ/wIQKCY/A3fs15XWjgJAfpRbw45NHrGePwnFnZUTetM78ol1Tc2UC7FEzWq/rH9o/xOeyyA7tNX1Nlxvo1kDGS7Zva1OVThGe+zcVlOwTU47+pzXDmja85lMfbRrpS5/EFjSc2vwws3qLqhSLpjN76bwrHLp22Uo0j6I4gqzRF/0XSfcnx/0Qdz1CdWk9knEMbVihCx65/uArGfsq6/7yOhlbDCYlbmkqa6e9LdwNloOGZcIGUBwE9Vyft+P919qe3ZXpj/N2huWAL6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 15:11:10 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add print_mode functionality to reduce page_owner output size by
> printing only the stack handle instead of the full stack trace.
> 
> Example output with print_mode enabled:
>   Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>   pid 1, tgid 1 (systemd), ts 349667370 ns
>   PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>   Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
> lastcpupid=0x1ffff)
>   handle: 17432583
>   Charged to memcg /

Looks nice to me.  I have just trivial cosmetic comments below.

> 
> Print mode significantly reduces output size while preserving all
> other page allocation information. The correspondence between handles
> and stack traces can be obtained through the show_stacks_handles interface.

I understand the mode was introduced for the stack handle mode, but it exists
for both full stack and stack handle mode?  The wording makes me assume the
mode is only enabled vs disabled (boolean).  It is true that there are only two
modes, but I feel like this commit message might better written.

> 
> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/

Seems this is a link to v1 of this patch.  I think adding the context or moving
this to the changelog [1] with the brief context explanation would be nice.

> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> 
> Changes in v2:
> - Renamed from 'compact mode' to 'print_mode' for better clarity
> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
> - Update debugfs filename from 'compact' to 'print_mode'
> 
> Changes in v3:
> - No code changes
> ---
>  mm/page_owner.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 5884d883837e..6d87b6948cfa 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>  
> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	/* Print mode: full stack or stack handle */

I think this comment should be useful if it was compact_mode.  But because now
it is called print_mode and values have good names that self explaining what
the mode is, I'm not sure if this comment is really needed.

> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
> +		ret += scnprintf(kbuf + ret, count - ret,
> +				"handle: %d\n", handle);
> +	} else {
> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	}

Braces are not needed [2] here?

>  	if (ret >= count)
>  		goto err;
>  
> @@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 val)
>  DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
>  			&page_owner_threshold_set, "%llu");
>  
> +static int page_owner_print_mode_get(void *data, u64 *val)
> +{
> +	*val = READ_ONCE(owner_filter.print_mode);
> +	return 0;
> +}
> +
> +static int page_owner_print_mode_set(void *data, u64 val)
> +{
> +	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
> +		return -EINVAL;
> +	WRITE_ONCE(owner_filter.print_mode, val);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
> +			&page_owner_print_mode_get,
> +			&page_owner_print_mode_set, "%lld");
> +
>  
>  static int __init pageowner_init(void)
>  {
> @@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
>  	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
>  
>  	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
> +	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
> +			    &page_owner_print_mode_fops);
>  
>  	dir = debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
> -- 
> 2.20.1

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces


Thanks,
SJ

