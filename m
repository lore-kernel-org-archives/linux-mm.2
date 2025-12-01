Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9806D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339B46B002A; Mon,  1 Dec 2025 03:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310A36B002B; Mon,  1 Dec 2025 03:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E2A6B002C; Mon,  1 Dec 2025 03:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 140D96B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:39:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A046F16081E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:39:46 +0000 (UTC)
X-FDA: 84170253972.18.93119C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 270F2C0009
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:39:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uQ/EUarb";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzY9VjIqiaGKFMwGbffGkrOJwS22taAdWEFHbUPL4wA=;
	b=qaq6pQo9fGQv1iJWDtJElA+L+ySOMuewGa++HSnr5GXCmX0YpX3mFozxS6RVo48b7iFbCE
	3H/pcnugTZbjuZHxhoO0+DuQv1q2o7K2zsPnIIBWRNuWyM/qpYBxcvWK+nc259YWNTZEmV
	qgT48k1MZU0MRDnWYNpFyyoz5N3X780=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578385; a=rsa-sha256;
	cv=none;
	b=aN01cmIzvVn4Y7lJ0aP+RdwGFCQ5vrhjXP+bq8X12wOnAANYcgkkiDHj5Oca3cxihB5HZa
	hy8dinkHeXdoVDpYpeuQSvIoF7lbaRxbwNhCh/Fa23KbIMhmGmC3e6O8f/Zd8ukvLuF0H3
	F4eoBoMOLOywzp91+EOy8KhYB8k8RnE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uQ/EUarb";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40B1C60163;
	Mon,  1 Dec 2025 08:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C698CC4CEF1;
	Mon,  1 Dec 2025 08:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764578384;
	bh=XYenxbNtRDcljVH7RQaYzSMIHfmS/eO9eGSsWEIrEb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uQ/EUarbzUDm53fskUfuzSV7ydeutc4npZNqkjfZ7euWoVS1JbWShBeqv8bgcnexj
	 cCgULmAPJUzV2hyS4hSB7h4FoLRpkD2wsIKVwSn7SG9EfLCKmomCs4HLJ6l0ydkZ/C
	 OWJqHlghNne4mQq6cebNQe4TzWRpWJzWshpPcjCTNvCro1SKh4t/XAXVLAjoEhL3OP
	 5/rROsyMiFoBoNYQmi/OfZVxaiJYQQL8iElP2rlF/+tafkfkZM76SrYY1kh0QxS7yK
	 tFwgaM+CejsPS+/Z9P/ctPHrO2ww8Jk4bUVS29TPu+IySaIkl++y0tVaNfIjTYzSB+
	 TAw9YpFgFGt7g==
Message-ID: <57d5793d-2343-49b3-a30c-cd12dc40460d@kernel.org>
Date: Mon, 1 Dec 2025 09:39:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, willy@infradead.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: dev.jain@arm.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, shardulsb08@gmail.com, janak@mpiricsoftware.com
References: <7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
 <20251201074540.3576327-1-shardul.b@mpiricsoftware.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201074540.3576327-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nunni469ce1wckon7rtxjtxqntxo3nbq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 270F2C0009
X-HE-Tag: 1764578384-296520
X-HE-Meta: U2FsdGVkX195yVSCW1xn+aG1q2E2hOJ9IZnGvNL5LbnIldpB0wTZUoxa93Pqd0OlYT48leR9BFknTVYnERw3dS0Z2YNDUxYRQpwYt+cwVHEmdlMweFez1ITQnrJ8R5cCjEUoWTCKBr5oA8jEqu45d+uc66rlybOH7flOsjLH+hRYxeP1s+GQUjmd9H8ilTZLJUEL7614p/GU4/TVJwqmp2dUtZNB9o2miZGbqTwPt77SHIfVMqz0uzhsK8hA/Jz45eQ4BGyRGGQ2YaXZce056QQx/iRqIL4q91cHlERl8x5abkAVDHImFDcjs+Hu4SwyRY1TQtxBOvx/fJjA6b8lQempMle4c5nkYPlCtyAx4vobPLrM6LvfLz8RpsAqRkWhBo/v5soJciu0k2VVwshwGLVXg0PdiTqHU9aSZuXdVJczAz4OB2eieWRvVCg6xOFXgH1T+v3sd0qtVgBmA/l+UZBx5kK8/ZwMNcUoLo7DnaF/Gf4B4ddmXe/3Q46g1+j6hbmkhWvWmlL6I62MO6G8IgCJ9X/fIWSWzYNfcJ0UyB1sjY9bGnONBzkOPMn+SAgoCLd2ETm5pw0YsHBpUBGW12yn+kFNkpb2yfbOg4v5WBfFbfq7VImNfJjmEp+RarXp7aOiVGBkrsYOHeblMcTB1LrtbLksIC+q58ubW0YmPopHPg6HqADfndvbqaXUDrsqtnOQN5gD96cjv+PjQTGaOYTGRhYnTQmR5H7ztnba84nZNbkKTl3kusTA867HSTQ+MqbV+zNz9tEyxqqpD+tepmlt/UmY6qlDzzXTodJtT4Uru030BqSPDp+p690aeqVG5YCOYxZcxuwsf7ZxaKtmsmsX3D/oQx5VyZOjt9ZWF+SYIhAcFQuTH107xhJKbmMk85o2217xsvIowMnM+tXSD2ORLpITXlupQbzefJKVFncG7WhemSxxcxGcd1VILnx+mLpemvF4eNqKqoSqVw2
 fUggjVyJ
 OOW20
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 08:45, Shardul Bankar wrote:

Please don't post new versions as reply to old versions.

> xas_create_range() is typically called in a retry loop that uses
> xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
> xa_node and store it in xas->xa_alloc for use in the retry.
> 
> If the lock is dropped after xas_nomem(), another thread can expand the
> xarray tree in the meantime. On the next retry, xas_create_range() can
> then succeed without consuming the spare node stored in xas->xa_alloc.
> If the function returns without freeing this spare node, it leaks.
> 
> xas_create_range() calls xas_create() multiple times in a loop for
> different index ranges. A spare node that isn't needed for one range
> iteration might be needed for the next, so we cannot free it after each
> xas_create() call. We can only safely free it after xas_create_range()
> completes.
> 
> Fix this by calling xas_destroy() at the end of xas_create_range() to
> free any unused spare node. This makes the API safer by default and
> prevents callers from needing to remember cleanup.
> 
> This fixes a memory leak in mm/khugepaged.c and potentially other
> callers that use xas_nomem() with xas_create_range().
> 
> Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> ---
>   v3:
>   - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
>   - Fix in library function makes API safer by default, preventing callers from needing
>     to remember cleanup
>   - Use shared cleanup label that both restore: and success: paths jump to
>   - Clean up unused spare node on both success and error exit paths
>   v2:
>   - Call xas_destroy() on both success and failure
>   - Explained retry semantics and xa_alloc / concurrency risk
>   - Dropped cleanup_empty_nodes from previous proposal
>   lib/xarray.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540c..a924421c0c4c 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -744,11 +744,17 @@ void xas_create_range(struct xa_state *xas)
>   	xas->xa_shift = shift;
>   	xas->xa_sibs = sibs;
>   	xas->xa_index = index;
> -	return;
> +	goto cleanup;
> +
>   success:
>   	xas->xa_index = index;
>   	if (xas->xa_node)
>   		xas_set_offset(xas);
> +
> +cleanup:
> +	/* Free any unused spare node from xas_nomem() */
> +	if (xas->xa_alloc)
> +		xas_destroy(xas);

The first thing xas_destroy() does is check whether xa_alloc is set.

I'd assume that the compiler is smart enough to inline xas_destroy() 
completely here, so likely the xa_alloc check here can just be dropped.


Staring at xas_destroy() callers, we only have a single one outside of 
lib: mm/huge_memory.c:__folio_split()

Is that one still required?

-- 
Cheers

David

