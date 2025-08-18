Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1AECA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747D96B007B; Sun, 17 Aug 2025 22:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F9B6B0088; Sun, 17 Aug 2025 22:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604E66B009B; Sun, 17 Aug 2025 22:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D05E6B0093
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:11:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFC188215F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:11:43 +0000 (UTC)
X-FDA: 83788252086.20.87EBD52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0896A0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:11:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FdTTV7V5;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755483102; a=rsa-sha256;
	cv=none;
	b=HYJXNfKKipkk508tsKIIzb517RMMlINUhaiWH9rB4L/Rl680WsEy9kJabgcLcGkhpxXHR2
	W6Zx1K4siPcJlR6gZcpra1m0XmDUKIcWqdrDYqo/7XQCTkSZx6xnJi8K6tjcSJQJG0t4qp
	qONUuesPh4UQki0qO9A2+aMdJwq6/5g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FdTTV7V5;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PvPEiL4l8R+WkwNrKmIb0X3D3X7fpJqzrNANmrqZWI=;
	b=oOJnu4IFolIrn9GgcWEzIt/keAYi1sIeiFf8rdN3tdRkxSM6cFIWWFzG9kq1sPz0hve3FC
	C0L44nDWtlw7H8nxiWn+nur284EnZ8GRfYLMETh6O9pWDOSO9OzPRyyZ7iRzztaVYvlaTh
	NMvO3kOn9oq5Xf7hfRWqSQ5hZvPWqxM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755483101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6PvPEiL4l8R+WkwNrKmIb0X3D3X7fpJqzrNANmrqZWI=;
	b=FdTTV7V5HeVqubz7FO2WGyrHqGdQhHrPcJXMpJP3KERDjGQVoLN1lH5l35SrrfVVIZLOId
	HTqXPsOFDPXf49Q3Cv0y1Ew0QBsTQpN/3V8PrmSqkG2ZVpfVL5OO42unKfAGC+asdAQvuj
	Sh9xUa0T8V/0HqLMA0w2vt0QZ2Or+hc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-217-eOV7kcwiMBi0eXrB3VzXhg-1; Sun,
 17 Aug 2025 22:11:39 -0400
X-MC-Unique: eOV7kcwiMBi0eXrB3VzXhg-1
X-Mimecast-MFC-AGG-ID: eOV7kcwiMBi0eXrB3VzXhg_1755483098
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 383BE195608E;
	Mon, 18 Aug 2025 02:11:38 +0000 (UTC)
Received: from localhost (unknown [10.72.112.210])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE9D719560AD;
	Mon, 18 Aug 2025 02:11:36 +0000 (UTC)
Date: Mon, 18 Aug 2025 10:11:32 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] mm/vmalloc: Support non-blocking GFP flags in
 alloc_vmap_area()
Message-ID: <aKKL1HFsJivaUSFE@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-4-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-4-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0896A0006
X-Stat-Signature: popx8phb7bjh44497qa3ouz516sgq4jd
X-Rspam-User: 
X-HE-Tag: 1755483101-526007
X-HE-Meta: U2FsdGVkX1/6eJh8D7ZUO+SvoMKv62Dynl0eeKW7vYwBXv+hbXSDNM3n2Dk+LBBENZ3hmF7C44dkTIjAKQmBAjR/KspE3CR9/ep2fWFZbJtb4Lb/Iu3hvDDDEqbqTYDW1mCKPip8IWANPyWVyBcXXWtn5Rfamlr+t+nMuBIt48WXq/7wxwaknnAaFBZvMKeYgLk2qLME4YNR1R1+NmRsQiQD7e9CAH+z+oi9PFax+L3oYpbXM0W6H5waamNgpSOkjw+CQ1VA8E/8cC6CQZVrWLMf6wYHyz6hEcLE7tUjHerxJBxKZNGYhyLXxJ5y7Xq7WJ8u05Ubj9hAkSyAYmXagGJfYtTgrOIYCRhmFwTH/sdvt16uSiuieG11rKutcrqvi1ocav8YmZsQZeFxx3tv7it3uJwDpyCRcnTjdnrniMa9DnUPlE6RdNwS4LukGCoGwPRO37oquIxCHBn/T/Z1AQ6mGg+1uWbjaI82Nn/Co8ix/3aqgb5AoO7NlEKsMxTTsjIDCce58PIFhHgpaQ1i/ZdoXyUAYBT/f00zDA8A3m2w8BeTHoEE9lAPzpo9isppKDteKPexWtO4cQ2xRC3TFhLPCraMrXA3Hk81alQzSBhJXPIlFCv9vhEPLUZiQh2yRkBaOlqsrcDNDIbmSs56vMKSZ+bhx2EzL6kWyXa71Xr6DZVHQvz5f08thXWVF8MRWJTg4TY9a4QwFx9gh0IzeVO9bfMw04zfXpyLErOXEBNCD//liB9G2uhj3c3vX6Q75h7Q2AvpuAZyzKBEJyNx03z+h8H6tExZBohTJZ52QCAR3dVu/KW0HxpXDQjlga6rEHcctJBXpdNLkC25hrrG6ooJB9YYiRNFBC3oqdn7iuKX5PUfOb53RTxTt6omEr9JbW/fpuRYancp0rkGIxfyfwc2pYO5Q9JUKQjB0EqbNthnu9EVJdFYes1eaatm8fwYCzwl4oCfgr5iuOGaSg1
 H9nAADlQ
 8RnUdo0e9TYiv8d4Wnej355H5jv1kqHZHtbj0JqDcggv+bYu+KPAX+/FTlAF7bIU68Ymr+k0qU674Si7VmzWI4w3Xz87LVP+B1F/F+ZBK7DAecAly20yrwYl/n2aUeA4JuGgIJhVmuV4EvP/Hynb6cc4ki8V1pj10jBm/0304b+Usresk1198uaz3zdQ2Zpu9ppJ7+tyifzVV8JVsRKTVgRPVvoPTDDCVvrG9QlvCyIoxndFAME7jV1eauhuJRp4virOMELzq4c0pDLXMnhjbiaxrnZ/AjOwoLI6NHF2B869PCnZ79dImxxP754i8tisbLZ00MAzXSOx5pn5QkicU8zbISUDXeiwMI1oXdm7RdZCkQvqZ4ttoENVLit9a/4U3B3h3i6Of8Xze8O3lbGIw2TAEGkINjlDGMvv12x3IYw9K/0NE81NrCP5Vw83jxkzwg9H0X75g0UWJRvT30iVLNHEu/19MBJ/tZv0+Br4OEMcxbWJ8i2veZL+vWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> alloc_vmap_area() currently assumes that sleeping is allowed during
> allocation. This is not true for callers which pass non-blocking
> GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.
> 
> This patch adds logic to detect whether the given gfp_mask permits
> blocking. It avoids invoking might_sleep() or falling back to reclaim
> path if blocking is not allowed.
> 
> This makes alloc_vmap_area() safer for use in non-sleeping contexts,
> where previously it could hit unexpected sleeps, trigger warnings.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..81b6d3bde719 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	unsigned long freed;
>  	unsigned long addr;
>  	unsigned int vn_id;
> +	bool allow_block;
>  	int purged = 0;
>  	int ret;
>  
> @@ -2026,7 +2027,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	if (unlikely(!vmap_initialized))
>  		return ERR_PTR(-EBUSY);
>  
> -	might_sleep();
> +	allow_block = gfpflags_allow_blocking(gfp_mask);
> +	might_sleep_if(allow_block);
>  
>  	/*
>  	 * If a VA is obtained from a global heap(if it fails here)
> @@ -2065,8 +2067,16 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	 * If an allocation fails, the error value is
>  	 * returned. Therefore trigger the overflow path.
>  	 */
> -	if (IS_ERR_VALUE(addr))
> -		goto overflow;
> +	if (IS_ERR_VALUE(addr)) {
> +		if (allow_block)
> +			goto overflow;
> +
> +		/*
> +		 * We can not trigger any reclaim logic because
> +		 * sleeping is not allowed, thus fail an allocation.
> +		 */
> +		goto error;
> +	}
>  
>  	va->va_start = addr;
>  	va->va_end = addr + size;
> @@ -2116,6 +2126,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
>  				size, vstart, vend);
>  
> +error:
>  	kmem_cache_free(vmap_area_cachep, va);
>  	return ERR_PTR(-EBUSY);
>  }
> -- 
> 2.39.5
> 


