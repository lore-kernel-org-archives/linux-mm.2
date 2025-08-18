Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBACCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BEB96B00A3; Sun, 17 Aug 2025 22:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996346B00A4; Sun, 17 Aug 2025 22:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC476B00A5; Sun, 17 Aug 2025 22:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 788986B00A3
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:14:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F02D5A897
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:14:28 +0000 (UTC)
X-FDA: 83788259016.17.81C347E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D90B40002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:14:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlxE5Ony;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIWBQ1PDibIT9To10rXi6vD/QpbzoLVnyobWk+6cFEk=;
	b=XPH0/cp/Y8uqmig2aiQwnMbdjl0TVz3kx4+2cmF4ApONa5IARFHF0rRfUtjfeS5Eci6Qsp
	NBm+w1r6CtGKUvVu2LYNyP9JgmWdmBFH4mUGkw3GvQNFRUIrr1zT+ISrWie8A8g+PADbPL
	mOz70VxO6xTcZxhyAUVcO/+aIWk+Btc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755483266; a=rsa-sha256;
	cv=none;
	b=gZ3cZdqMkvNnwpSRzaUfUvpuH+87jnMO2ahiDeTZ/FjMGH32znDJ/3d7p9bntn2inY4gct
	kLtxm1oztIQSobGaDxO1dewl2CvG4PQNbM1eqOZTO9oUlsguCQEpJ7mb56WQK0zRWxTsHm
	jIBrHv5nJbRxZ6ONKsV06le/gNzMCkE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlxE5Ony;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755483265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TIWBQ1PDibIT9To10rXi6vD/QpbzoLVnyobWk+6cFEk=;
	b=VlxE5OnyWpK+s9HP3DrbOKB5u90jK3uY0i7cc+zAoBv0EZXREHD7gcjNvYU9pHgwO37m0h
	GFcNV6SFAtrd3MGF27/m/Wnx4lFh93iRO6WSEAPWS9fduhbU7y7+ZKgfj3IGuY627OQV6L
	7VkO9OjaYF5mfzSI2JmAoIflP5Qrwhg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-6PSUH_DAPLOJOOlSyHh6Rg-1; Sun,
 17 Aug 2025 22:14:24 -0400
X-MC-Unique: 6PSUH_DAPLOJOOlSyHh6Rg-1
X-Mimecast-MFC-AGG-ID: 6PSUH_DAPLOJOOlSyHh6Rg_1755483263
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C537C1800345;
	Mon, 18 Aug 2025 02:14:22 +0000 (UTC)
Received: from localhost (unknown [10.72.112.210])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95339180028D;
	Mon, 18 Aug 2025 02:14:21 +0000 (UTC)
Date: Mon, 18 Aug 2025 10:14:17 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] mm/vmalloc: Remove cond_resched() in
 vm_area_alloc_pages()
Message-ID: <aKKMeUdnr/0WuQh6@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-5-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-5-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D90B40002
X-Stat-Signature: ek8nwajdtcxxye4as3i56ubpc66pcs6i
X-Rspam-User: 
X-HE-Tag: 1755483266-197302
X-HE-Meta: U2FsdGVkX1/WDFZV9ird6nih/kf72f9eWwwY8aLnhilJ1s3zlnlfaQr6n7EcnPsVsDhv3aqMW93JU9YuEwt9yXVTRjYEWMc94W5MajCD/IjA2tlQbYkojbJP9AC3DukCnTlZn9UxfW0RFBgW6oj/dTl5uV30n06Rp7eJvbKeT9KfW923D/Q8p5ZavBN/f7hcKSo3ZCrIWHSFyxIgfEViToZSoDFe8maJ26SSf70i6T2lFlVCY7ZhF+KLBk0c2zLQTR5dcngMlxTQQ6zXX2unKUhC5mjpk3GC0tO6OHWf9GGgyaCEcQCYo7kKmpuU9eVnKpzGZ0XEKT5Gxqo86b90289gQRgesK+BeIEqqTGIWr4bMmZh26Ir4vZoKEFFayr1Sh8dRctIffa0tw2332/guL/sIb9HtRrsf5Z2KoEZx4vbdrNW650cbsH/+PDEJMd6RcJuUXwV5teiwdqpFwECZYmaqh4eN76qyeeBoyi0h7AkyFqfTqh1Y/D9pNgDwf1cG7SW4pLP3Ohu4p9SHm6QqTyP9oE2xQE+0mTqQ8wUg7C7OB5ouhYts8Xfkgvh6iYinbHhagkbRGuAPf+Jb7+9X5t+ShUrXlgfEXA0897P3sJ4GxQR4AnY+f6voWqWEV1bC9HiQxfYWM7RMId/AimvtEjCa4/5Dq/byyHxKYkCPbodqz4/Q16mIt0TnCYkhKA0nBwFyp5xnwnWiNtZfH3a525UBBB9bBiF5Xhb+7rlQ42f5hBV7QCLd4FxoC3SCred7M1Hd8J+s4oq+KMs69BpccT9JMsNOF4vVN/HoRPWfMppeeZJ+b7LXDqgW3wBZiejj9WpYGQTFDmOO6zBKznQ71W+aHKVWcKwS1biDj4aguAIwMVldTEWfGS/Aao0vXAAXU1q9MF2DqmypUeDvQjlfAJfdtp7hG+usJZfL0Y0nIf1E50oD3hWCMFK2U5YPNsclrze2mBj5KCdkrkGA8R
 Ufh7DB71
 xL1cA2iAsENDGuHq1u9fP1pdUVdmg0aVHALFHYAPdU3RNRRou3igprIscRMRkd+SJ1TwPaRohY9yl4ksLNulFwP8glhn6ZmAmaxM8VkwP2fYoHrLlb0qRdTvtY3na6uqkgnP2GksJB/b1pe72tH1zCujqNiyWqraTwcP0B8A77ttoe+Z86McGcrxv589URRiCnvUfgkb5IfFpKzb5fj1wz8tKWchq8WCkGdFS1M0J5g+jpxo4PLHj4Slm4dUpsWSeBGsx7qQf/7GIWKZnz8vAf9Zk36X5GdFJZaNE2CTHlPpRrXBBH6jm9bV//yAi4RUPylusnRYxt2oH/jqH17u6TqJQiV0fMPIT6FfVhtP1WTpPXC6hp6rmbp7eFHTN8+yh5/eour/+N2lSW7xoqhk9w9sHpigOr1XvaLBnGyFL/XDsVC+J5HubFlXa0a2QdBenEvZ27VDtgnyjY9n1j+eVKcVIrE9hxyXoYkfRdwv8ljRZ2tfHNuniNdeKVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> The vm_area_alloc_pages() function uses cond_resched() to yield the
> CPU during potentially long-running loops. However, these loops are
> not considered long-running under normal conditions. In non-blocking
> contexts, calling cond_resched() is inappropriate also.
> 
> Remove these calls to ensure correctness for blocking/non-blocking
> contexts. This also simplifies the code path. In fact, a slow path
> of page allocator already includes reschedule points to mitigate
> latency.
> 
> This patch was tested for !CONFIG_PREEMPT kernel and with large
> allocation chunks(~1GB), without triggering any "BUG: soft lockup"
> warnings.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 81b6d3bde719..b0255e0c74b3 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3633,7 +3633,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							pages + nr_allocated);
>  
>  			nr_allocated += nr;
> -			cond_resched();
>  
>  			/*
>  			 * If zero or pages were obtained partly,
> @@ -3675,7 +3674,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		for (i = 0; i < (1U << order); i++)
>  			pages[nr_allocated + i] = page + i;
>  
> -		cond_resched();
>  		nr_allocated += 1U << order;
>  	}
>  
> -- 
> 2.39.5
> 


