Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E145BCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 04:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3607F6B00BC; Mon, 18 Aug 2025 00:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310C96B00BD; Mon, 18 Aug 2025 00:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200116B00BE; Mon, 18 Aug 2025 00:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5876B00BC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:21:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C03EC0790
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:21:30 +0000 (UTC)
X-FDA: 83788579140.11.0B985BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C2A040002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:21:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cj2ckJ6p;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755490888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgY9urGSsFiJ6C12Uuom1iR66x4tQT4kD42czaPA10c=;
	b=iElQz5NTTMMItvBcECPnexYHoXl0rPE7RF2i/ijKEWb6Rj8ZEZSf1Mivnm6k3OYuv+LFVM
	C6ONsemI7AMITcWLGJnsChRtqCRu4Sc8KRiDq7U9PIsTCZNaP+cD92XWgkKcBed/86P92b
	KFNB9n2ZSRAePF/GTAKJUuX4SBQ/ws0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cj2ckJ6p;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755490888; a=rsa-sha256;
	cv=none;
	b=VpoT8B+W+Bxi0/N/W4pecyX7hU9yPL3hYvV+4wXefK+CwKGhorZx4O9QcgmpzAt/KRhsCL
	340Oln3SJvnX8JhMDI9Sg3yosnQVlumj9KiEwQiyhEtZpaq7CLY8w8CXT5bLU6lHfgznfs
	OMCzoaDxA3hupwiuqr+kh+Z/ZP2r96o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755490887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sgY9urGSsFiJ6C12Uuom1iR66x4tQT4kD42czaPA10c=;
	b=Cj2ckJ6pIF2jnrxsUYqeWx0d0yZZ+tuW9E8MI/gd/ORmbIzwCebLSqSOxhmoGdecpBmX4A
	riCIwEJpkzGpOaTIC6X2ok1balLHJ01WizL/stWvckgP1oNLhUkbPaOJVbCPThYlQV2AyD
	l9QAxqMeR409XFA1rs2SMAAS9FwN9Z0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-1A2YyQ2IP7Cg-M5bzkNbbA-1; Mon,
 18 Aug 2025 00:21:23 -0400
X-MC-Unique: 1A2YyQ2IP7Cg-M5bzkNbbA-1
X-Mimecast-MFC-AGG-ID: 1A2YyQ2IP7Cg-M5bzkNbbA_1755490882
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E768D180034D;
	Mon, 18 Aug 2025 04:21:21 +0000 (UTC)
Received: from localhost (unknown [10.72.112.210])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F75F1955F24;
	Mon, 18 Aug 2025 04:21:20 +0000 (UTC)
Date: Mon, 18 Aug 2025 12:21:15 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aKKqOzepmIkOJi3i@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-7-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C2A040002
X-Stat-Signature: roenhztbscju89g955p5rajockxum7ik
X-Rspam-User: 
X-HE-Tag: 1755490888-457532
X-HE-Meta: U2FsdGVkX1/k3T+Yt7N+xftlIdkVSTbwXnNM+WujbjjlwSjW5YD+wispB9JcQ8iLdeyAbXQIkVAiVZVgEf5NUB/enifHjbvEhQiuU0FurLCOhA9CwX5Ecq1+PXgCvsuunpYOREvGlzzg7OfVo6NS79EYl9etBSaGKXaLa65JEPq1d4btSbNMdAHfsdqDlMOEXjfcwnxJ96SmcsvAeE5ZF4wFfKdn5tMiqau+WEeFD4ovLcvGNVY75YCs351z36ka5Q0uF8glvjDniUSOgfcqpOFbOyiVUSDvLwsm2QDOjSdtRctOt+xIV+a1GI7vN3FI45zRtwfycVOP8C1Qb4QL9UbISEo5zQ7dAK2eMWpjYPwh2FsWJsGd+CR6uKcpkfT8DB+dTDikc4uRGNE67vfamQM9XR6aisZ0lC1yYFupEWy+3NFpArKWvgdlKmJ6NZEA9UKhih4PsTzMKoIPy6l0SE7CyWRWagtGUCWrVZWyEpKshCQtEvzvPBFm51p29P3HWMRj0NbqpCNYtwypU9NiTYm0SUUbUZMD1vD3/qVlFhN4v9Cp3peXpgraoSykMXBBylfdIHghU6OMqg6YCFUAwzNLb7FSQOfr8Igd5R35WCXwIUMyH5Cq7+kHQSH0mmgt10Ih3tIQqOK46T3chlj2uiL2qVLlyPWpRm72SUxt4TN/cywAPY2Eh4M2GeR8I16msmMbfi+rJ6UcRgLiHGl8SUqYC+EQmga469xbXItTHDpV/KQAb3QHgDep7dHRp7Jp2U3PgVRUepubvyJmjucIvIz4p+0Ezv2wNEfmZStmXwrV/HL2pUmIVvgwt8t5BmiRCjuB4Lof+hCzTnD46UTFUMY1qu2OLfwuF41no8reZqCH/uoZUl1mpxTaHPHzWSyMgzTFym1f/uQ1x3IWvbnRuGPZcvT4b8gkkgUV7Ppv6+Xy66chLuEL/L5PwCBJVeAPZm6i1jPBANeYxo09tHV
 RkaK/d0+
 1gWrUih64Zk0e5OUmrI+3XKdrQn2NEl0tRt+9foTu3jQ8T/zk5uS92yWG8J1O9fB/luBTgtAVtUosz6vkE7uh6xBLjEIXJ3R1TJW4/68eSkW3fD1JUhf4hO2STY22WBFbUq9rykvDxsJ4LZ8av/2Bs38ZDObtiW4x/YGcNIvn5nwCSrbMn/Ur/bfFpk2IY+bXUlvJA+gEZs5bym8rs52jMpA5nzefTo5sZGtVrR+oAlYDVGLcBJF4gSMbYlTu98e7NJa77Z+PqwmcLP1x7xcH8JxyBKt3djAvkYhUZT0kO1YbFqO0fHkRo2WH8UxpMYXSlh2F7aL1NPHekr7w7gMzLr2Txfl6SLwm+fcEuIw0Xj/TCpLIeI0o9wrdiI0EgVbgeP0kz+cxMzwIP6SI6tyVEXveNZYtdTlCYgJHSWcVNBq45QrIEWfyHvwrMKpVR8roVLWJ5XIgvraddb9HvGrD+3/pxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> __vmalloc_area_node() may call free_vmap_area() or vfree() on
> error paths, both of which can sleep. This becomes problematic
> if the function is invoked from an atomic context, such as when
> GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> 
> To fix this, unify error paths and defer the cleanup of partly
> initialized vm_struct objects to a workqueue. This ensures that
> freeing happens in a process context and avoids invalid sleeps
> in atomic regions.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  include/linux/vmalloc.h |  6 +++++-
>  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index fdc9aeb74a44..b1425fae8cbf 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
>  #endif
>  
>  struct vm_struct {
> -	struct vm_struct	*next;
> +	union {
> +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> +	};
> +
>  	void			*addr;
>  	unsigned long		size;
>  	unsigned long		flags;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7f48a54ec108..2424f80d524a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	return nr_allocated;
>  }
>  
> +static LLIST_HEAD(pending_vm_area_cleanup);
> +static void cleanup_vm_area_work(struct work_struct *work)
> +{
> +	struct vm_struct *area, *tmp;
> +	struct llist_node *head;
> +
> +	head = llist_del_all(&pending_vm_area_cleanup);
> +	if (!head)
> +		return;
> +
> +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> +		if (!area->pages)
> +			free_vm_area(area);
> +		else
> +			vfree(area->addr);
> +	}
> +}
> +
> +/*
> + * Helper for __vmalloc_area_node() to defer cleanup
> + * of partially initialized vm_struct in error paths.
> + */
> +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> +static void defer_vm_area_cleanup(struct vm_struct *area)
> +{
> +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> +		schedule_work(&cleanup_vm_area);
> +}

Wondering why here we need call schudule_work() when
pending_vm_area_cleanup was empty before adding new entry. Shouldn't
it be as below to schedule the job? Not sure if I miss anything.

	if (!llist_add(&area->llnode, &pending_vm_area_cleanup))
		schedule_work(&cleanup_vm_area);

=====
/**
 * llist_add - add a new entry
 * @new:        new entry to be added
 * @head:       the head for your lock-less list
 *
 * Returns true if the list was empty prior to adding this entry.
 */
static inline bool llist_add(struct llist_node *new, struct llist_head *head)
{
        return llist_add_batch(new, new, head);
}
=====

> +
>  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				 pgprot_t prot, unsigned int page_shift,
>  				 int node)
> @@ -3711,8 +3740,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		warn_alloc(gfp_mask, NULL,
>  			"vmalloc error: size %lu, failed to allocated page array size %lu",
>  			nr_small_pages * PAGE_SIZE, array_size);
> -		free_vm_area(area);
> -		return NULL;
> +		goto fail;
>  	}
>  
>  	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> @@ -3789,7 +3817,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return area->addr;
>  
>  fail:
> -	vfree(area->addr);
> +	defer_vm_area_cleanup(area);
>  	return NULL;
>  }
>  
> -- 
> 2.39.5
> 


