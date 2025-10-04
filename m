Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FF2CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 04:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB5B8E0008; Sat,  4 Oct 2025 00:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4931F8E0002; Sat,  4 Oct 2025 00:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0268E0008; Sat,  4 Oct 2025 00:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4BD8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 00:12:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F8851A0A19
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:12:08 +0000 (UTC)
X-FDA: 83959109136.08.19856B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id A54AD180006
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:12:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DqfQHeXt;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759551126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1FMci1EMwWYl4LzKrGkXp3JLbCopyApeUNyqyTFkQU=;
	b=3IiNmJIfKUdZfarjyAJPfoVMUmtN+93JLDLULsVBLW+ouZaZLv2BBIWdlrxm2KaRQWx1GF
	crU9ovhoUuHLGBSFydB4YOyRD5gEDDaH/GYvB03iPtkr7J+YXKLpnjF/6YCbA4VzhKuecM
	UYfeUN9icShWV5xrfEAk74B+BA4yO/4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DqfQHeXt;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759551126; a=rsa-sha256;
	cv=none;
	b=b9BTnDQZBAgGkcNMfja71c9WHienhXUcBBkOJwZ7J5rADhCl7unCLwncTbbC6RxHDiRlev
	fEVCWcSzCpNaz/RlhKUtmIVygLlb1bYIvqU/enZyLTS36wAJK0Du8RguygIeEHpigWeeBh
	ZC0HBhWB7LCFgaxXTfJ4dIP0OnZext0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759551126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G1FMci1EMwWYl4LzKrGkXp3JLbCopyApeUNyqyTFkQU=;
	b=DqfQHeXtbUWkoJQYnQ+cDWcTG2n7oGGdM75ps2s8lb3gfiiAYIZgfkuE8CBJObP2oM8LdO
	aAKdxdX6aq1K2iFNvn4p0b5d3mpI2vodrY7TrCCGpLrltfXB+JiXanBaOIq1RdbUedpB02
	tdd+wVU+BySM3bzon2gcgQiT9zuhREM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-sb34xGJwPW-Pi7P9XxP_Qg-1; Sat,
 04 Oct 2025 00:12:04 -0400
X-MC-Unique: sb34xGJwPW-Pi7P9XxP_Qg-1
X-Mimecast-MFC-AGG-ID: sb34xGJwPW-Pi7P9XxP_Qg_1759551123
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D70E51800452;
	Sat,  4 Oct 2025 04:12:02 +0000 (UTC)
Received: from localhost (unknown [10.72.112.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A818B300018D;
	Sat,  4 Oct 2025 04:12:01 +0000 (UTC)
Date: Sat, 4 Oct 2025 12:11:57 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001192647.195204-10-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: A54AD180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: awceap1h4ij5gcy917igbicgg1i485uk
X-HE-Tag: 1759551126-508876
X-HE-Meta: U2FsdGVkX18xZU5uhrPpWBCXaCZOzWvyOpBmto3yJXJXrzomzjX8vDEfgQLSlTv0dVm+fvF5Yuwy/ouy14udf/tpOQQ7tFj2d9+v49SzXC//1Hj6hqmCW0velw/KFxr0N4TNReS0Q/3wzJV3iW6aEnj+SkWwc/HRZa6uZ+r6MfX8iISUs2w2sq21lplC7iplp+mahMhrbOPVUImdFYOWxpVVGYd0PQupnheKSZx6MW3lu2lpId8I0jd+EniWhgjfw9ejGaOmRQKWVTULIPKZQGOqzeNOvTBAmhkyxE3pGJswJ60v/ovdnWb/XdCkMrHQ4KYmwoarVpn38ZDd5PjxHpwEJ7CrahnkuYs/Hv96IL3fMw1ktYFrzvUBdOdkH+oQ2dNCEIvPHFjZzyjBhDtzCV9p/LUfO0pkqOdLddZqkN+68an+qHUoiZN2rnc1aZZZEDtONAzB8FsMULtQW8uNug7Z/+VOdz3aCaCCFc5st00WtfRhnR1WkEkE5rZqhWJlOEzgt+dblpTWwVhMCBgO8bHP8qlOFML/EgW7T/qk8ubjMKJC7DZnhAhpjTGBRD4cYKco9C+FlzO94RnDDsLPozWkCYr4vDKhCGredKsy3o8af9eaQeTD67PKXm2BmwSbbUFaOeGWBWIKeGUAjrn3cSVpD3NTswYQOw6cUwbfMylItKXX9F3tKwo7DDmUlLzzhxQ083zMbJkoXdPg+ebiTa2IQbNKvIW0aXRMDvlLxfefza3OFvxuC4jks3Ew2eDLTZdfSdYjIxzAuHf7smN5YjFg+iriVqUGHwtUQFX8JhI/ip+uUZa8dSpvMKEgbhfdRzRGuvWGgncVQhv3BPtxPXToGTGDZ7hZH9Abzcy6R+cU8jGpuSeyHXOp1Q8W38TLyea5O5EZgNQF+SP9LnZR+Qp6RGyPUL+kAVVN1NUxfVJ5ug28P6lYibupJCMSaAQl6pQ22hh9QJQ9NZ21k66
 NKdEI9wE
 zz8gueoBjzA1Hyp7uZlPj8bnTvl1aZTPz4u5roIujE4RD5tEIq4uYduqhKwjA+Y9Onf7yTSF1qXuKHdGBgwb15Au6M2RnrDlVX9P3GKmnJliz2bCwfEH8hs6SYoHA/pdix4lvAiJE071aTej+ukB2Q59CAXTogbqU3en9QW26EjZ5KKZDDUz0WEvDprlsUbhMqvhLgY7dv5lD13YWoUKoYgaRFAmxic7tA28eYiVjiCyDRFMwRi64wpcBsirKfmk/EjhOPijv00NzxwAIigN9T96No4rOthxEUOlpp0qukeAL+DNjMHnR2JhqBYhVEN+PnS8RHhy2XCQMOs7rtP53gD9Vbyj3FJw3m0YrzWwkNe43+gICvJWlfvcszG0niBmAGaj0KA7BJ9JG8tSt2Sz7Rrr8EbjFTs3wGEBhOBACl44qX75LcGoFe4RZ4s/mzGwDsHPXcyR2EBdJqEtuBNZ85edIJ62DsYvey6UoBkeOOOGwhT9mELWxl+cP2n/XYcDTlJec3kbNcfP1yPSd0ME7vPq/1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> __vmalloc() function now supports non-blocking flags such as
> GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d7e7049e01f8..2b45cd4ce119 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>   * @caller:		  caller's return address
>   *
>   * Allocate enough pages to cover @size from the page level
> - * allocator with @gfp_mask flags. Please note that the full set of gfp
> - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> - * supported.
> - * Zone modifiers are not supported. From the reclaim modifiers
> - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> - * __GFP_RETRY_MAYFAIL are not supported).
> + * allocator with @gfp_mask flags and map them into contiguous
> + * virtual range with protection @prot.
>   *
> - * __GFP_NOWARN can be used to suppress failures messages.
> + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> + * by __vmalloc().
> +
> + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> + * and %__GFP_RETRY_MAYFAIL are not supported.

Do we need to update the documentation of __vmalloc_node_noprof()
accordingly? I see it has below description about "Retry modifiers"
where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
but have different description. Not sure if I missed anything.

===
 * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
 * and %__GFP_RETRY_MAYFAIL are not supported.
===

>   *
> - * Map them into contiguous kernel virtual space, using a pagetable
> - * protection of @prot.
> + * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
>  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> -- 
> 2.47.3
> 


