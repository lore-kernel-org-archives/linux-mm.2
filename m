Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2B0CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB868E00A3; Wed, 17 Sep 2025 23:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB5B8E006B; Wed, 17 Sep 2025 23:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2388E00A3; Wed, 17 Sep 2025 23:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5748E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:02:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AB9FBB2F9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:02:43 +0000 (UTC)
X-FDA: 83900873406.30.B4EAC6B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 69DDF8000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:02:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RbnY58KU;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ww0rkAHR/bKD96qA8T50xR51LFz53rc6QLvDaZ08jOs=;
	b=e9kyNOsbFsamPYqJQEz2yjrnOjZwkll2WaQPBKoAXzLT7FsuoHRlEI+33eCw8d+KVxC8dw
	bLqk9ZGcfjZ1DThuJ7XxdsJTo6l0JhvtRl2wzy1Go2IM8y4F7oYD/qXFLOhCqutrg8og13
	VNLE5RV5riiRkTg/IykGp0inUKxSjlI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RbnY58KU;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164561; a=rsa-sha256;
	cv=none;
	b=6l/2+PWUb1F9LirTo9DkkzFDeBAWJg86B5L/WDWRk07fFS7ZrurEGMgH45tgKdxG2OhwV4
	HaMQ+tNUrRC7tM42NvEXr5lRzW8SAlbvbwhQMWjXGQZhxeHbS+ejk6UAqYoYnyJ9BSrIF0
	spGeKfm6AC5fFo3OOLSTgoOMIpvKVCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758164560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww0rkAHR/bKD96qA8T50xR51LFz53rc6QLvDaZ08jOs=;
	b=RbnY58KUtW6eFO2/ivzSl2BYVVNpxLdf8kaWgWVunQzv1VKAsO0ok3e+2sTuKU4fvg9795
	qW8nLHCLNmlp5VZ72eitHYKXhWB1SA16kep/GTMzbVVrXkTfYL9e37k+qQZfVaoLxlzIlR
	iWFWcmm3xem6CmG2EsNd0jKaHqtnDHA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-eE1y5t-ePTaXnppfXDorKA-1; Wed,
 17 Sep 2025 23:02:35 -0400
X-MC-Unique: eE1y5t-ePTaXnppfXDorKA-1
X-Mimecast-MFC-AGG-ID: eE1y5t-ePTaXnppfXDorKA_1758164553
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FC3C19560B7;
	Thu, 18 Sep 2025 03:02:33 +0000 (UTC)
Received: from localhost (unknown [10.72.112.180])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73BB719560B1;
	Thu, 18 Sep 2025 03:02:32 +0000 (UTC)
Date: Thu, 18 Sep 2025 11:02:28 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2 07/10] mm/kasan: Support non-blocking GFP in
 kasan_populate_vmalloc()
Message-ID: <aMt2RBzoKB9iodtR@MiWiFi-R3L-srv>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-8-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-8-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 3cg1bjca4okjq57jju9ixoe8sg97u53s
X-Rspam-User: 
X-Rspamd-Queue-Id: 69DDF8000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758164561-116826
X-HE-Meta: U2FsdGVkX19ZqN254+gHiNTk4UZKNNIoG8yCUg+6IQT4swTCKFv9JzNbev6nUh0+BRLKEiXp33CVgN1sZPxZqtX1COAS0gnPOTIPoajOHUUt+Q2P9HSt/BqwOnYNKunsBuEqcm8dwvxu5vwVYTDyYks2eOzKY88Ahjb08tJjt6j5UVF3/69sOWplTT8oevKO3f3DaJqtG0e+iVVFA3xqfKHr4Uzoyp5WYQ5CY48e+ysdYg2qDAvm3VpknGxbRQ0fIzTYa5opB3bcgZBAioLY/dNPMWvas/gCRgA2a0UX5Z9EHyhg8Q9G5tChebhuT+YnODT3TvMmT0ctpLnCVnDh0DVdmgSaw/BNd5GmLlOgE5ag34nB+IRcrmMJp3BPt4I/2dIzrJoYg6GO/DscnPidGlacHoReCnc6w9kPwMBBOsXQgeMcsfLLzInriY8dwkeBsYpkDJRp3paP/ihUua8aSMJ+MeGdXepj26MYe9V0nzIVzgJjyy6aTzQ/YL7u1dQyPQBC2B6BZ6wwcHTf8yGdz+Xmw35biyGd02KHkc570RDTZ0BV58s6XlsK4CEjPzlXdSLKZ3yR8udB2b5tRFJVBpepfYh85huWut0OAK+DrfOBmBDGg9gyJvCZOBmzMLTY/GX2S3ioLzjvGocFTyIFUwMQsxcpErdO0Yu0mFVyHQvD4ktZ6+Q+chqE05HeecX/+YlRsIm7o8ksxPcPfowitMCWgHG8Ea1wMOfGMarkyPooZQ8SGoXe5zaBjnccYPGRwnvZlmpXTgRBQLMBZbmEKTKOWersyu9v7/evPnMl1zltSpQ4Zjtg7whJu1ah5VfXkxjZ7tAc79gfFCAE5huxiZQTxwqIWgqEivJK0dXRyFZn9VMLcjWF2NKlilhM7BJx4h9zlGWO7kXMNdD2HTgdSUbeKTnyHd7qW+GEIdVQw+7EJS0MNsF7zagBYIQ0GTdF/Cge1NQWoidewLqevNT
 cfnGFoso
 IylOXrNZ8aEIJnZ1xOKu9pNRko0+dPF/b+ANPe+Bq437ET7BkDT+X8CJfZnrIsXN2S79IA1J/YNj4spQria99txoAU16mbK5dQerwzNKYTys4fdERbnIhj5/0ZujinyT1PLj4Ge3DxrlKJ5VJlR/fVs9pDp47IkZ/vVhCSVPQgKrGRZ+VvPPgOzAS+yN9TRiXik4zGqS8LBQaLybFxPDf1sO8vXjTGe/iIi3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/25 at 03:40pm, Uladzislau Rezki (Sony) wrote:
> A "gfp_mask" is already passed to kasan_populate_vmalloc() as
> an argument to respect GFPs from callers and KASAN uses it for
> its internal allocations.
> 
> But apply_to_page_range() function ignores GFP flags due to a
> hard-coded mask.
> 
> Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope()
> so that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.
> 
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/kasan/shadow.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 11d472a5c4e8..c6643a72d9f6 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_
>  		 * page tables allocations ignore external gfp mask, enforce it
>  		 * by the scope API
>  		 */
> -		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> -			flags = memalloc_nofs_save();
> -		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> -			flags = memalloc_noio_save();
> -
> +		flags = memalloc_apply_gfp_scope(gfp_mask);
>  		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
>  					  kasan_populate_vmalloc_pte, &data);
> -
> -		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> -			memalloc_nofs_restore(flags);
> -		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
> -			memalloc_noio_restore(flags);
> +		memalloc_restore_scope(flags);
>  
>  		___free_pages_bulk(data.pages, nr_pages);
>  		if (ret)
> -- 
> 2.47.3
> 


