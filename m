Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D35D5C0C9
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0D06B0005; Tue, 16 Dec 2025 22:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E8A6B0089; Tue, 16 Dec 2025 22:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB1F6B008A; Tue, 16 Dec 2025 22:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC6C06B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:54:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 863B18B607
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:54:41 +0000 (UTC)
X-FDA: 84227596362.16.CEA2277
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D597A000F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:54:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VQr/6Te7";
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765943679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iu41GupITfJHs+uamnM8CoHi7wHfnhmUZdXDqfpIqYY=;
	b=DMrBs/r29DFtTZz+62BMxNBJw/5keSgY1rNH0Yph/bRqyou4+jb0XhSaF/InN1YxXA3OSZ
	hILG/TFemhnm6P1rydBF/cPWUFi8GjaTXcUjIqaQfRYqyQ9j9IhJgbGZkscgV9ew42zpF0
	Kd20BEJnrYTo8W4GZzmUqWSYSmZDGnE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VQr/6Te7";
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765943679; a=rsa-sha256;
	cv=none;
	b=aMU90WxwTEJBO5JNwamLrRr3ILSUIbDTt7AOONs5VZ1yUVJMt9B/GOEpPo+jVpnbXBHsnF
	qeLhaclw7GI9RsCqbUEAuPUESKyHvei0paI/dFLEWObj/lGapJv0C6TUeG1PinM+g8onuW
	MvzGy8BAL9Wir/DlDKA4d3Sr25A0unI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765943678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iu41GupITfJHs+uamnM8CoHi7wHfnhmUZdXDqfpIqYY=;
	b=VQr/6Te7EtlJCBxf7CAdkTQ0NwzHBvw/4+92j5gKACyeExQdMwTh1WZ9ACE8dhiwLjzOjo
	GPKH+uMKb1wU7LPYEIt5BXEHwuTa47wOWOJsLK9l/hwmVLezIZZRdk/Mn7BIJSM4mjGkBS
	Xz2wyE5LO+tbdQB2LhV2hoW4Ob1zX4w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-tFxPahEsOROXhHm-9IDUJw-1; Tue,
 16 Dec 2025 22:54:35 -0500
X-MC-Unique: tFxPahEsOROXhHm-9IDUJw-1
X-Mimecast-MFC-AGG-ID: tFxPahEsOROXhHm-9IDUJw_1765943674
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C0E41800620;
	Wed, 17 Dec 2025 03:54:33 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27179180044F;
	Wed, 17 Dec 2025 03:54:31 +0000 (UTC)
Date: Wed, 17 Dec 2025 11:54:26 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUIpciUKUeclNk2s@MiWiFi-R3L-srv>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216211921.1401147-2-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D597A000F
X-Stat-Signature: jo6ai9qfrnden3itj5uf4m6jwt9q5erc
X-Rspam-User: 
X-HE-Tag: 1765943679-703263
X-HE-Meta: U2FsdGVkX1/8Ml7rN0uzGC2lvcNC0t9sC7SCdKo10rcQERdUosn14Vw3I7ysvwgLiCgPQh4pXsCjVMKiFEwtIan1cFZA57BHtdEtdDVJnHC4RSbsrYjXxH0LTHneFB9jZ5OibLs1AsZ7a7gjg4uSXwOzYcdK+uZTvicDUsxVZ9RtvYKvf2SzFwVIgOSwEfDOwGLHSliQ3+4ILM4XV+f6/LZjP+cEoJYyk/ubt4xz1tjzMwck3cusbUC5L9hqNZN/UDGuofkkxLA7ms5u66FyO2MHjB76oJWoS2qpEYNHlk2bPnnDM9KtaBHvI1ZK7xptKpXh0B6SRg+jA48EFOSTOhnR3jrHPKXYmPhw2B6ko7eSop6HQeBqbbi+lsbFjzFHP+mtq6Wg0zvFNhazh/BI2IWPsZFcyLECnXJy+oQ3xWIVtZiLGuUVNPZJSZqipjRLunDqMxXR8cx2DLI0bU8s45tnHIkDo8ipoQQiNJ4GJJlbFzXI+w/Cbhl23OayL77+m7GMeNx3nO5qszvKw97lGON2DNp19mt88S7A8TAgXxD6q35jo51eWktdPU75mX7KAmNObwwRidRd82djGJfufKar92Epo0gH20n5AwcICcLhWR13xpfJO4HHdgf+b/JuzZXp4JeD1opMHnYsx6+Ex/TiVT7KaS/NEgMwqUYvPQ8RAdTvlmvNdCPIPkE8KoNCL+dT5UIp1xJ5VBuw49wWExwy4UpCStl3i2Ag7XjRs4RJtNPhscnRWpIaDXioqqAfDFJ8Gvp8/ngj13cFvcGoFVSLpfxkYj1HIU739m2sbERkT5dKQPf8i47zLGH0EcEWODTAPdtml86FJ+SyeCSrx7C/v3jb3VjvFGoWYLEsNmbERyRAfASYOn9WMkN5PTnpl3S+7YOevd2MzJb6pnHrhIj5gYjUvrTHsupgBR3Ts66AmJk9zOmYQwTwipSfYQmBXCC22KUtXHzfn5Cu4ku
 BC9nAMqu
 UIgXRp0OdfWT+X8besoeXnf8epOIMNA55kGMz4i9UXnoEkkScyCZfQH6D2QgdwTn85CbVddBolgEY+1x9RMT1FCxMBqFeyozeKdr4jTMPkMw2lj8LltTZ9HcAb6MIicZdc3ZqSxBjfH4IOq8KQVPKGs1vcIfaA4DLJJv/xq7yEOIOXeP7jOXLBMwGtd2CfLrVf72SsbKV5JWs4uAOyYmaOVB4xeKSisp4WikKJXpGwzo2bNBLgTJv6t+w8NJTury7HBJUOoXON4/XggWkbo11AYdG14o9/iDN44oBRBzhL67PHcP1bGq/LycF8ckyiMCOm1qxILGW5p/eJ6ohdvL98xxrXD1cz32eSMupAitFMJia8yZrum60HnkxTHTnFgQTOe2uDcOBYI/XH1EY6QpLEN1N/E8HneYOfKstpPmxOot/RQLJelFO+fMXcwLg66vi7ODGQ9eWWdpNshvaAm+Pv5w/0JrtU2YTgHrOhL+H+7VFoSzhdyz6Ese/wwUav+y8YH4sn7Kg6+Mjw5kRLRX7WmTgaCBa/iFJXHtxaSH1r+mniP6htHxpEM/5/oTQOkKIStvBZJmQKpr1xNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Uladzislau,

On 12/16/25 at 10:19pm, Uladzislau Rezki (Sony) wrote:
> Introduce a module parameter to enable or disable the large-order
> allocation path in vmalloc. High-order allocations are disabled by
> default so far, but users may explicitly enable them at runtime if
> desired.
> 
> High-order pages allocated for vmalloc are immediately split into
> order-0 pages and later freed as order-0, which means they do not
> feed the per-CPU page caches. As a result, high-order attempts tend

I don't get why order-0 do not feed the PCP caches.

> to bypass the PCP fastpath and fall back to the buddy allocator that
> can affect performance.
> 
> However, when the PCP caches are empty, high-order allocations may
> show better performance characteristics especially for larger
> allocation requests.

And when PCP is empty, high-order alloc show better performance. Could
you please help elaborate a little more about them? Thanks.

Thanks
Baoquan

> 
> Since the best strategy is workload-dependent, this patch adds a
> parameter letting users to choose whether vmalloc should try
> high-order allocations or stay strictly on the order-0 fastpath.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d3a4725e15ca..f66543896b16 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -43,6 +43,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/shmparam.h>
>  #include <linux/page_owner.h>
> +#include <linux/moduleparam.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/vmalloc.h>
> @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
>  	return nr_allocated;
>  }
>  
> +static int attempt_larger_order_alloc;
> +module_param(attempt_larger_order_alloc, int, 0644);
> +
>  static inline unsigned int
>  vm_area_alloc_pages(gfp_t gfp, int nid,
>  		unsigned int order, unsigned int nr_pages, struct page **pages)
> @@ -3679,8 +3683,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	struct page *page;
>  	int i;
>  
> -	nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
> -		order, nr_pages, pages);
> +	if (attempt_larger_order_alloc)
> +		nr_allocated = vm_area_alloc_pages_large_order(gfp, nid,
> +			order, nr_pages, pages);
>  
>  	/*
>  	 * For order-0 pages we make use of bulk allocator, if
> -- 
> 2.47.3
> 


