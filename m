Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5304DD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EE36B0005; Mon,  8 Dec 2025 03:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F616B0007; Mon,  8 Dec 2025 03:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D586B0008; Mon,  8 Dec 2025 03:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45FF46B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:37:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC0B51341B5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:37:20 +0000 (UTC)
X-FDA: 84195649440.19.6E5116B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id A7EA21A0011
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:37:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o5PuPIffQrmByj7yM3LQZXY3TfyPXUAVXJTIfa8VQ2E=;
	b=dd0zLvLbYmAFuOrchzfeCN2THQCL3I4FcN9N1K8diDQv3jOqLT7jMSusvcfW+li7LEnXDh
	QxNzsTtldMsdSXLrOHPfnpDr91C7Mgkd7M0OjMsWRIQC+BILbO20mhFoq8WKdQ5FjXgqP4
	NOZ+vz+DtqbZ6EtupuUMty80Ecdpzsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183039; a=rsa-sha256;
	cv=none;
	b=OApSzEXy/aWPg2eMc1hIyq9i7Fszh0tX5H7fPtyf6tjOh9VCPECdXapizZSR5M32wcOIFd
	BvEVNVApqauDkeLhPDgWDKGz+tDPUFS8xYtHgcAG4wyWDTp8qOdIKvd210Yvl/zS1NIdbP
	BflqvCvH9OEoQ9alL5rzDZ77mzN9zho=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 407A11691;
	Mon,  8 Dec 2025 00:37:10 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5D823F740;
	Mon,  8 Dec 2025 00:37:14 -0800 (PST)
Message-ID: <3813db02-118d-472f-a889-d58c9d01e736@arm.com>
Date: Mon, 8 Dec 2025 14:07:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 david@kernel.org, shardulsb08@gmail.com, janak@mpiricsoftware.com
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7EA21A0011
X-Stat-Signature: 45c6wjpmzdedi79me37y1nusit4ffr58
X-Rspam-User: 
X-HE-Tag: 1765183038-693283
X-HE-Meta: U2FsdGVkX18LTdd11ckGrWEy+9XJnxPlvQ2sqgRJVILtFENRXuime8plov8WUeIVYLbXnJXpEOYQxnSkmEIaKlCvtef7zpQEeER4JH6L5ctlOY8F4NnY+8YLhb7fsj9sQG8ylpCZFj27HI83/5EaUY+JiTWU+PNgGB9U/xafXU9ctKjcVG4Utf+6OHYHlxSdat7pCmtma294MrFQTRjSGKl4aQ/tk8Bp1gbNnf8xciEWIvTWwBmZzbuVYNN/qrpXUBg++dd2KwbHGrLY9AO2eo69hcEkcEnWsbeBOjlPar4jWjXgbOY8dQJpUugtqH5TH24C4mqbcvDjDq57L9WHKmczMNKtRqrGd6v1QdOzj7lLjfDgF/pfLa/pPJmfYGvrMvyKoRQPj55zcWITiGCM5ZwLciif56qLpizsh/gZg9MwkRmD5a+3nLxldjxWj69yvIfZ76daTFO2+yI4tYIZKcIT4H/daFgY7PJ6z2VtOft1vRZTvR5R0a6szkn3VbGY5hFxvW/GcVh8vfk8LIqFqO8cBxWNKMc1OTuzDcy0kJv03sT1lEaj+JnPom+j8DWgOH+lxbeODprGMaY6hC8xM+dCRfP8qK/oAiv+G+OLs0h209RdYC5FRVnL+6ytdZMsHh1ymbHiReC0vS0iNG9gr+YpD5S66hxHXuK5oVnkaQM5PKY2l10++VM6upC4C1H6OuD648nSTC2/a6AKkx4AKgJVs7g1n5aV2lx4O1mErl1SU9vCAAvRCIOI3iYGlw0aiBufAQnGFTO38iUXhsixCwP+AUm0QVe3FEyO+7nyIyfxNG2YQOrUZEoaLKF87YP4g4u9uWhbbYSqBXVYol03UV2jEZXNyiydqr9jgGKHNxptMe+04VUqF5czT8qpJceqIe1pmq80+o9ep8GoKGQIvt16pIUuqkTBSCu9EpG759T4xYA6MsnwwXBGOANGF+3T9OLSO0Pza5BxuB45lNY
 WThgBvy7
 dDC6KOYqO3ea0fer6KUNo3de1cFfoKqUdfJjokUYlVJN4zM41MVdJrjJpFFtNlF3IdJEPJrtAze8BtwVP4WSEMGwz48vmcJuVAXArbm9Q8GhG322ZUoxvKE5YLB5Iw2ir2f2OaGGE5lIG5B5KA+B9dCfxu44/1Zcw4YahxmQIHVE21aPbTt4iwYJSPBTDKOv56aKrOuyoILDTRZ+1Y2bXJ/Bpl8s/cbF6ijymr0GaqbCaV1yjpqdjHjD6oNL5/dIA+b/R8HL8kDLPHy2CCCLc979N0Q7YayCJ9uIu/naI987LnLXW9UTDqeOO1rG4pr0QFaXRlxDxA2OBgrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/12/25 7:56 pm, Shardul Bankar wrote:
> xas_create_range() is typically called in a retry loop that uses
> xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
> xa_node and store it in xas->xa_alloc for use in the retry.
>
> If the lock is dropped after xas_nomem(), another thread can expand the

Nit: "When the lock is dropped after xas_create_range()".

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
> Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> ---
>   v4:
>   - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
>     already checks xa_alloc internally.
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
>
>   lib/xarray.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540c..f49ccfa5f57d 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
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
> +	xas_destroy(xas);
>   }
>   EXPORT_SYMBOL_GPL(xas_create_range);

Since there are other code paths doing this fashion of xas_create/xas_store followed by
calling xas_nomem till the former succeeds, I believe we should handle this in the caller -
for example, I believe we need to fix xa_store_range() as well? It does xas_create, then
drops the lock in the same fashion, and I believe we have no choice here but to handle it
in the caller - we should not put xas_destroy inside xas_create.

Although for this particular case, we have only one caller of xas_create_range, so this
is fine really.


>   

