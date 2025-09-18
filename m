Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B774CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80738E009F; Wed, 17 Sep 2025 22:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30728E006B; Wed, 17 Sep 2025 22:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F638E009F; Wed, 17 Sep 2025 22:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD5DE8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:56:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 240235B0FB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:56:49 +0000 (UTC)
X-FDA: 83900858538.24.A3C33E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CA2940006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:56:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FSHPwSDi;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+LtIQpgc290vPRQOhAQlDUbtf58jv7H8SakHmLcEEA=;
	b=TIc3AHIV9O64ctRk5C8bc2h3WN408HGAhhljzerJHK+pyxCiHWvI4PenhGb7izn26IESp2
	Iszlo9UgvLhL3Bk0PxORxVdu35Azfk7glybo9FamaTR9aeoPqhW+4J+DbKWSkCKcnWYfhv
	axFrx/RLFrRUlgnw42Dgj/7zf/0ZKfE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FSHPwSDi;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164207; a=rsa-sha256;
	cv=none;
	b=Z9Q+g8xzm3GjhNicVvPzmAdLb8z4OYEEdWvDFeS+GIf+lUlw427Kmr0QcdzJQqiMF9BZ7z
	/oPgIpb6NzGzESZKelxhF4I2ba69E+tlufZ22/UXWAaQyB2vNfOpAzxqhgQMMtOCtwrEGe
	KWEq0kUBVq/4nI2yteUucR5x2Hu4Dwc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758164206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G+LtIQpgc290vPRQOhAQlDUbtf58jv7H8SakHmLcEEA=;
	b=FSHPwSDihmG5k73mCx5/njRcM25VW03I2aGv96p3fp3Qod3Ip+W39kBDzquT4HAP/qnauH
	b80/uod0xoXAUL9Pc0EioZ+fP0zscch4G2IISaWG4lxnA0XaJIul/HTckT7MHddtm4HsMw
	YtbMP14WgyUtNHlPbpkoMyazYcwWMhI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-ZFTlBNNGPc-z9rkq6G2ROA-1; Wed,
 17 Sep 2025 22:56:42 -0400
X-MC-Unique: ZFTlBNNGPc-z9rkq6G2ROA-1
X-Mimecast-MFC-AGG-ID: ZFTlBNNGPc-z9rkq6G2ROA_1758164200
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 694F2180034C;
	Thu, 18 Sep 2025 02:56:40 +0000 (UTC)
Received: from localhost (unknown [10.72.112.180])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C4E61800446;
	Thu, 18 Sep 2025 02:56:38 +0000 (UTC)
Date: Thu, 18 Sep 2025 10:56:35 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 03/10] mm/vmalloc: Support non-blocking GFP flags in
 alloc_vmap_area()
Message-ID: <aMt045ZaEma6qokF@MiWiFi-R3L-srv>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-4-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-4-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: pi9kjmizcoksm5xu9rb66g8z41kw564d
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CA2940006
X-Rspamd-Server: rspam04
X-HE-Tag: 1758164207-411437
X-HE-Meta: U2FsdGVkX1/DThTkklGMAR8vW0zpiqbC1Kxq4A7xKra4eqkM0SH6i83H/O18iC9HSOkcOWJFPGCH/R+jiCjwrYUxgeXcErCndVk5Bil4KEVfT07gbu8QlHvkx2SOtvwV39GY01deRJbTjCXz1XozqshhTr0VEqqkWdXmB+oTLZVa47uhwFQpJeQE1X7+dDDi8rL/F7v9OCPc373WORekWlUZj3fz1f8LZJCWqzU8ZG9sAO7fpkT30Bq+UBvK41IEOK8ltaHIt9yM1tZCRSboPgI1xxVjGzH3eJuHNtd7ooowswGdMhQMgxCmmS4sA2G1u83M/hO6ZG7oFUYhXaNjaGq2Qc/tDackDjCbq3QN/M7QLIiJGBXU+HJeYulPB+r6lhMDv1Sx3oxp9yKpaz68hT41WzJ3WjR6rLMolcIi78d+MJ6pSzfpM3y35Yc0+hqmOgWn1GHP0W3N8IuEnrPUnD0Wx8ozRzF42StZEudlnjtwupshyPBfpoH2LPohC2tW3luWdh7KqnLeHdTs/90npwJa9B6XcUsr8i1yyccwzvPoL5lJ0P/nETCEN/9Oej7m6jPBypgzTc7o3OUUIs/e848EfbA5WmSwULL0oL2xzMbLBgIrp5bA15wAVNdbMXs04pyCJ2W48a39fZC6N+Cfkt+X2qrP+zt3/RccU3GMxg/NriTNrur9LtzWQLkMbbPDY3tgdlb06B3yDBfWlO509AV/v59spXFynSSzW6wcqnW+g6ygjdntj2NQNFKu9bCihoaePN2k0aG+1mkVC2EywhKKST1NY0a6wCHZMTBxXE0DmQzF1Wtz1fXMoSv/LamCr1fn2wTtyODoaZ12cSCSJ3+vrylfq1dDqULgMb9hEp8FhZjkRH/Syu9rr86NGRInJVztYUc/w1PkIKYcKgyq8nT5lLY5T/nJIg5kJ//2lp7ZmSmTAeA0NEArtdsz4zal63ZQm/p8YjDdxrv06LC
 WChiHMZZ
 9nnkkWf9XaJnc3GdpTQYCNgIAFOsJFlnhGzZLyxrb/zWh656CJ/FIRzJIx883BhKsqLeQCfSK3op3XVL9+GK1fsOLBc7KjzyoevCB3OeX+Y9kjpv8pyIK2xBbsqSl7SLzwhmvuboD1RD/hP39SCVethNA/zfJW5RN8ny3OSp90mIZAQ9B5vQXVW7JaUt0OFbmMmc3XzvCy4iJkwiRtgcppgk787FzCmCbksyGR64ACsgGZHFDWnI1ZZYUypuCeDQSd2Q5YR+8nkSK9sdUQDoJSfGx5zDMq1yUMIvZnYnje2WhtiG69kF4kakLVEjZnQh80PqNQHnSvJAxL4tM2HWdu3GL7Y8VXGNbNYjyrgRueWAMCXvCQfjjH/2kkSDpUnCPykmdJrFCsb4AshWenKoQdU8DA3211CcrmIt0k/8MsegRCjHFybfgYleH6YmZXZpYgyODzv9R5ouPZsZt4G7+YAEr43r7/UWoqKeMDo8oxVAP//PbmV08F64drrmIzOwJm5Z4A0xeDpyjhHnhKE6B9Wtw7ojmighjcnR5R/o4xcFICAo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/25 at 03:40pm, Uladzislau Rezki (Sony) wrote:
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
> It is a preparation and adjustment step to later allow both GFP_ATOMIC
> and GFP_NOWAIT allocations in this series.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5edd536ba9d2..49a0f81930a8 100644
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
> @@ -2028,7 +2029,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  
>  	/* Only reclaim behaviour flags are relevant. */
>  	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
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
> +		goto out_free_va;
> +	}
>  
>  	va->va_start = addr;
>  	va->va_end = addr + size;
> @@ -2116,6 +2126,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
>  				size, vstart, vend);
>  
> +out_free_va:
>  	kmem_cache_free(vmap_area_cachep, va);
>  	return ERR_PTR(-EBUSY);
>  }
> -- 
> 2.47.3
> 


