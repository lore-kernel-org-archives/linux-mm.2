Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE404EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636756B0005; Mon,  2 Mar 2026 12:41:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDB86B0093; Mon,  2 Mar 2026 12:41:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D6B6B0005; Mon,  2 Mar 2026 12:41:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 401846B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:41:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C3F41C1F5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:41:39 +0000 (UTC)
X-FDA: 84501840318.12.FE3B716
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0172C0004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:41:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Lg7ySvj/";
	spf=pass (imf10.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfLRwYk4oBRwu9+5TUeOLiLw3MOcjHWn/WHPZdFC1ec=;
	b=eKh/EkpPCCMER3JuDAu0TTgGbTsPRtiePUAKyAsNgcMB1jZFwaKH8QnT4FzLl++h86yFvG
	ff02Du+XZR9GV5o3sxbVK0XApeLlATI1Hp2W+bAQ4eXfZJM17uaM6Tjw2N5ZqqvQuNdF+C
	idOZMKq5dJSEXk+OKzOftjgaxWt9aOY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Lg7ySvj/";
	spf=pass (imf10.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473297; a=rsa-sha256;
	cv=none;
	b=FIHz1sFUxM8ypa8qzDD/U7TIUp/UEYW14uTYgewmEy8XlgJIzLfAXAkIH5GpeicNDXWFnf
	Z5r2ZOCrSPtBZRt3u+K9VduSxy4QfMrhUhzlAVZzsFAGLLCit2bIQvslMnD9I3yxvuQ4Cu
	UTUq2xPHT1csWRz0p7MbA/DMJc4AMGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772473296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IfLRwYk4oBRwu9+5TUeOLiLw3MOcjHWn/WHPZdFC1ec=;
	b=Lg7ySvj/K24EHDKvlRdIqo9KdhX8tCHmlNDybAOO21EgjFlR+FB3ReCuRLwEQpo1UsSkaP
	CD8HEPsFg48YUTBLBLxJ5k6tZJUmMtEua6FDQkeErskjZZAQ1U8FuFDP2GiX2U6TS48jL6
	HKcQnXJB7HG+/sWJ5yVXcJbU3Ogj47E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-9v5o2HTGNQeJAb_86j7xLg-1; Mon,
 02 Mar 2026 12:41:35 -0500
X-MC-Unique: 9v5o2HTGNQeJAb_86j7xLg-1
X-Mimecast-MFC-AGG-ID: 9v5o2HTGNQeJAb_86j7xLg_1772473294
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C60301956067;
	Mon,  2 Mar 2026 17:41:33 +0000 (UTC)
Received: from [10.45.224.173] (unknown [10.45.224.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDD0219560A3;
	Mon,  2 Mar 2026 17:41:30 +0000 (UTC)
Date: Mon, 2 Mar 2026 18:41:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
    Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
    Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Fix incorrect size reporting on allocation
 failure
In-Reply-To: <20260302114740.2668450-1-urezki@gmail.com>
Message-ID: <d227e804-5a75-ec3b-01db-93c144407c15@redhat.com>
References: <20260302114740.2668450-1-urezki@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: FnvoDJV3VTgPqRzWc07Jn0-9HDqnKgzlO3bx1P7iYOI_1772473294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: E0172C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: ym5u59w16gn4nnnq4f598sb9m47ibmgq
X-HE-Tag: 1772473296-728996
X-HE-Meta: U2FsdGVkX1+OGfONFgEUeko+vKGJzhfdaUlLyh5/LvhKIu0FB0DRsy05gSN4TqjWN4BXvcLF2ZBkxkKNWTtIhGWfJZ31FK8Bbr8Zo3n+TBnRTRWFs6lwmVVVKFvnNXKWKBdDQhg+4RmYz/vvpLicthqOmZlNhcWSYrTqGSr8RDSN2enjTfj6IQy2DVhfP64TKHDgdFzVEY/t5mgNEEs2Xp8XjegUXBGk6ya5qEb08Qwj4yWkFgk37hsD+332e1VSLVxhBtcFBx2TG1qXGeNBump8ELhGysuXz7/mcormlHIL+UplZTpc+0Vm5wO1SsQ0GZDVhq6ibmBbWM8WiPXIWgUHsx1iLhhoPy7HWnu3OjHe0+vome1WZNRqWc6TehT7g6cwGTX/M3NDK3z+DpiE+6Ys2Sjncdh+kPgG5N5MbgtS9UY0Jkzzh0Vy825qQKRL31ojTTa5QyIZgsLfs9fIg40rCVsV545bPtT1CY+4nH4SRbK/stdWB9qmAPgEGvMmhPTC5L9/gumKqfECABTy+Lk1AXR7CHaKNDi+VETa0x/qb14l9FJ0x1jWHsMm2noy2ltdEKsyuuDABWeEBJPGUqLF4lzLqCJaz2gDcKhfjUjg81atRqklOpT1c4lhwTOrrwmIOklbF8Bi4DeQvXITeb0J/JqQhYAv8/JLTCb24iHGrNJC/6l123rekK2A091NWPVWkhShf/XDsRJD2ekuabcdETvUdmFMN60AHIkXx8dJOaArB6x56vIjTAg+Pt9ngbe1LBiAPW+jnF+T9sOEzVuEwPy0w9yoX+tmHXpO1TPAJa22FtLZWUGau9uom6H9a/R9v7Lojjoe6jy+ecgA4YiMkJhfuhpOACWiQ2awuxuurpySba/rQO6M55B6RiNrxl6VNWKvcTjyV6bldcI4Usr285TwZRdC5HAEdSrJ160B2i1DbWFJZgKCfzziC2S7+fG5NKfN46+SoXQ9IO4
 dL1qVdTG
 J+cCbpf7aJ9TDoDMxqgT0p+d31XyEF1DU+W2PTgPo6Fohyqcx4z39tsmS17wsYorsA37tF0Px86ibua5vjfb5nmCsFTxwskMAyW0j1yol0QAWxDNOivHmbiYJDCRICtq+l1VH/FSsdaQQhpi+VkCe83g6S9BllWRcrsp81jkXkO+Y5OO6jVFz8iadJ3UOhpiMzPKSdyQ3dG8qsTOLHK0uxNs+lTAIfLQNduhlmhoRBmxCTsJhK79j0nqZ/30Mpltar679sLMwjVC4PLtpL0jTA9z3Pi4rn4pMlAbe/b49h9rPygIVFFYoeRH8zOjPOogkkeERjExqxTOJRf3zp5fX/b9RKLHHseEVnKwtPiyfE/MpWoysow1jQY/9pawAT8QdBzjIZ9ZYkeGDjwzPp2CmMGqnqar2A8dEWd9QxhbCK/pFFnrAedI2VxSEPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 2 Mar 2026, Uladzislau Rezki (Sony) wrote:

> When __vmalloc_area_node() fails to allocate pages, the failure
> message may report an incorrect allocation size, for example:
> 
>   vmalloc error: size 0, failed to allocate pages, ...
> 
> This happens because the warning prints area->nr_pages * PAGE_SIZE.
> At this point, area->nr_pages may be zero or partly populated thus
> it is not valid.
> 
> Report the originally requested allocation size instead by using
> nr_small_pages * PAGE_SIZE, which reflects the actual number of
> pages being requested by user.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..a06f4b3ea367 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3901,7 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		if (!fatal_signal_pending(current) && page_order == 0)
>  			warn_alloc(gfp_mask, NULL,
>  				"vmalloc error: size %lu, failed to allocate pages",
> -				area->nr_pages * PAGE_SIZE);
> +				nr_small_pages * PAGE_SIZE);
>  		goto fail;
>  	}
>  
> -- 
> 2.47.3

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas


