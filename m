Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8D7CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4FD6B0005; Wed, 10 Jun 2026 11:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BF16B0088; Wed, 10 Jun 2026 11:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2026B008C; Wed, 10 Jun 2026 11:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289E46B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:31:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5CBF1C0CFB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:31:00 +0000 (UTC)
X-FDA: 84864391080.25.72813A8
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 085E7A001F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:30:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QMvwanYg;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781105459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bboFVFfkG0GIFTD2ahnJgVC8EVO2PxrJueSwSbO4OM=;
	b=eLMXTZUjCpSSnYtod9N6rhRAGTD82vb44fHEp7UIKdETTLP3JkwDs37/FPMadIGlp2OkGJ
	dXrjG0wRGx97jswV0u0z8rAy6adv+rvpazfFigL/EF0bmRNNQtnpJ4qPNKCJhksX27DbQW
	GS2TA9GcIDKjxVpGPkOno7dqYlzVxzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781105459;
	b=EoQI/hoKIaedTXe+VkLzFf6nmISEuYmxtfozrfRNli0F+lIyUNJm3UtduoG37Dbdo6eLq1
	uVa8fBZg+xijOP0ksB9bblgCWfXdeU19sIXE/pNqNTj9sADda57wcn5Ji71/Yqhaa/t5UL
	sEhtutvDstukPnmHm0XhsoKDBX+zV4g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QMvwanYg;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ce9de10985so81001926d6.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781105458; x=1781710258; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3bboFVFfkG0GIFTD2ahnJgVC8EVO2PxrJueSwSbO4OM=;
        b=QMvwanYg6BDrUIlwNmaNudBk93OVPlz1FsJteYyHt+4gvXOSMYQJe2HW9abYEPnJoa
         6zQZJzgNDQ96IFXOQgNpR3DWlDg/MtW9+VMaDwT3MnmhOT5/9RMpC3eYKHHvOKvEyo/z
         le8bjPfkHlbdENSl/MatZVyR6k4f4FfctToxdBJ5eK9Ev6i7amW9bP45YQFdtOvxJuvw
         noeGzvMDbHUjg3WeJl41cIzwzDdTCTpSRY9AR+/L8dj1O+V7PQFL0hs4pgBHYGOJksT+
         ibiYBC+LH6vZpUXQAN342v6bwH72e60CHTGDDrTaUL15znV8pTMbbVE6yKP0mXXX3Ili
         WDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105458; x=1781710258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bboFVFfkG0GIFTD2ahnJgVC8EVO2PxrJueSwSbO4OM=;
        b=isQBF9Rz4nckSu+HZYQBfHuYtI0uMuguj7siugARUGG8AdwYYily9NhngZknOwmr3m
         g0mTJgOXHDW+jO2MZ+SCRqhCzptNAQ8CpIHSI7iyS/hWnY5yKgE0sLFgSFuuJLZXyLJQ
         04rTqPNokg3EG4xfRZGXlnfXnJ1D76g3aZZQcUFo5xtqBI2SPdllDpD/VPfNqqp3epVR
         QW6ZONEWFSW0+e/dSuzjwjks8ygtGEzxMkuuxiJgfCIs405JCmuK1/hS74bTC6DK6f9g
         /7WY6yZI5Q1twroLay/Vk91ak1j+/db/2/ZWmlHMVg4RrQtllQATpCkPCPnxPiNNQy2r
         KiqA==
X-Forwarded-Encrypted: i=1; AFNElJ8lvUpssUek5t9Thx7Ey2oX1QdYWOZSKFAhJKVOQazp6bmgx480T5pDJahYdbHQzAIinHoJ+xmaMg==@kvack.org
X-Gm-Message-State: AOJu0Yz/jePBDjzmkE44QMAKf/Blh0IRgp7xqJ0jtajAbJ42zF5QY3fn
	qtajRUrs+M1xQ35ft0VujAzJgacc0dKeU//esb2OHwSWMuLYsHGVDLvcuBtYZe1QRhw=
X-Gm-Gg: Acq92OERaaJl+l7nYGt+/j1WCggDGriPvy+54v+E+Kc/HX2K4xvqm/CKwc74mVmRwj4
	Xbeh4Cs3Qan8B45rzaW6c7wyC73/OvHG1Q6BT15GkBbBPlxYwXcxyraLAMKKBYEl7RE3tbZ5+ye
	9G0zBbtzWSGy8QsGScgC6uqf2M4BkgP0u00aKstzTgwyl2jJmjPPgHmJiUuXQETpb/uBv26RGkY
	uN/v3O6yFK1SymAA0taTPQJZvPlSezlUypZjx+MtBwwTKSsFBHyAo4yBlLIaql7H/if+jgUweSt
	4bcAGgSWTznbsJs6n66GE4l/Qc26w81GznZ2I2Uv5444jM2Tj1vNrF79zdHJNkaC0i+940JD13Q
	rq11qRSmUr1q2JcTnP3LOlzwKXT5gYHUbwvHqXnDQTPPLDd7OlOZYm/j+/i3VvPry4jgVNxG13c
	j+/y9y+U5VBs2SXSI/eQdy7ayGyNjXTZZLdadFWiDgPH+ZfOLD+gmupvPAXyK1pdecQ+9Amgzp2
	0EOp3sHnyFudseCWA==
X-Received: by 2002:ad4:5d61:0:b0:8ce:afa5:7603 with SMTP id 6a1803df08f44-8cee8bcbffdmr300230056d6.14.1781105455435;
        Wed, 10 Jun 2026 08:30:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd053210sm233198056d6.26.2026.06.10.08.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:30:54 -0700 (PDT)
Date: Wed, 10 Jun 2026 11:30:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio Perez <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v2] mm: page_reporting: allow driver to set batch capacity
Message-ID: <aimDLHoETsdWppAi@gourry-fedora-PF4VCD3F>
References: <cb43adc61d2ed3069b2fe428f3e051dbdc4cc28d.1781097156.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb43adc61d2ed3069b2fe428f3e051dbdc4cc28d.1781097156.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 085E7A001F
X-Stat-Signature: yehs895oy9ep81sg8oqjsxk5hhtzcfsa
X-HE-Tag: 1781105458-211973
X-HE-Meta: U2FsdGVkX19mAoabdUopOy+KhEr0NeNTIyaaClD+mCNSMaiv6ASlC64J7KV9BtjJhbWuIgM6QCvjKRWuNw3Sza1YrfZ2BSnVfDiOe0Wi2YzGnPB5TNoBcsOE2eWKHp5lxANmyj8k3FfMpPwhu0dmrVHlNvAjBLLmC6GIxBeJT07Qa0gVreuf5KOFFR3OOuxCFvt03FVR0095IdzHlBFrvM0E395pyi5xCvKLmMNEfYOTQlAPtYHvGnHW+hsJLpEuldbnNAaLKGhbKo3jKY+vZQoFt9kaDA06U+fz5Mf7kW5B5ox5Yfg2l2/a+o2VGaGRj/7rXnhH/N5/0xAktcK26hKRgAkbe9XLtQJNMHmUh3gDAhmuEVvuuAuysHJOe6Ob3MWHlL2BwZDYkEiu0JvNUypHeOp+Tq/6EZb3Ilj4GfCY9k4Z95b7fCCrviqSwoLIcw23AWcNXHcxSa8MWNqesuuHrnoYZiOyvnCGBJxXN8quDZf0PJ+umt8paTgjqwvVAZoHyqHYAlp9DoyQydPL0HOh167KQXsBMH0F8Old98yQR2gk0UGUxS12pQZuCJW9unsBg7Gjt82L6m6nJ4lTgIVBYEArAwrPTdV8YlUg+eStOU1+LV8eMvLjMTTZuf+YAy7SwugE7yJWhO1yvH1PSSlSZ/cgD685k0D4A7fvHvOibJoUsGwWfxOBIg4gJXTu+fSulFfOwIPapMK3j3a1unJSlCVFFQW2ERcVHqN/5N5eLcjMRbQqqmkRfTuXKPehXdAcEyJj1jNLgq16N7K0tF39YU+oBHVs/UVnsohdvxuVzsbi8iQbhSRfGkeZHZasSCNxIbUsxTW539KSkQqBXbNKG1ZO9QJ+FwLN2x0cP9l04VsW4E46k6DF2IO2uoOgwR5kJVKysUvDwOGzU1jsQyA2Zj0U+Jc3VKWIohXVeHng8/Esm5dB6YShgdNtMUMMGJoeLPE5ylZE/Umw5JG
 XAS6vjaO
 G0BykE8jioblhBJhTZSoT4x9u8nQ0+b+Jlds/w7f+eBMMl9yuBGtpB/LzWMS+cTGOuoNXUsj1stl3iKPjOgcLEedHO5P+ndCWXkIPAfhTVAJi78EBq5HXlYfcV5oWGW3Y2kU9+aYqC8WAGQMl74/99ZqUK1mIDtNWFuZO9DyIj0AjTvsNSvfFzmv5SR9WoxNJA2IkDr//Uulm/PWl53twfvrdfCOYa/IO2ItTa38tNFr5mOLR0f4rvksPv40v8QHSYAzIpyjl9+sAD2rVxVndE2RX52ZlSDS6y8M0X/1ziZH9VyPoOfZ5r9Fz3O3j4A8r9xh20Aw5aaQwbmZfBqhjw6I8msQuVRALhAPaaAlv6Z6Nl9AvxIFSwaKJ7zXTgQ8to3zSSHfe9GC8z4SIZeWJtU7pwnfpKpPXuICxwtw8mEO7wtxarLqCJdaaUxrgofgSeDW3ZCIaEPqCxADkkGucjz/QLop88lvsDEW8QxhI6j30ejLlJs6yYF/oj/S1N3rzb0u7KoDToKhZSpBzM3YCk1QbJoVIwB9/824K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 09:17:08AM -0400, Michael S. Tsirkin wrote:
> At the moment, if a virtio balloon device has a page reporting vq but
> its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
> probe.
> 
> But, there's no way for host to know this value, so it can easily
> create a smaller vq and suddenly adding the reporting capability
> to the device makes all of the driver fail. Not pretty.
> 
> Add a capacity field to page_reporting_dev_info so drivers can
> control the maximum number of pages per report batch.
> 
> In virtio-balloon, set the capacity to the reporting virtqueue size,
> letting page_reporting adapt to whatever the device provides.
> 
> Capacity need not be a power of two.  Code previously called out
> division by PAGE_REPORTING_CAPACITY as cheap since it was a power
> of 2, but no performance difference was observed with non-power-of-2
> values.
> 
> If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> page_reporting_register(), before the reporting work is scheduled,
> so we never get division by 0.
> 
> Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

lgtm asside from David's comment request

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
> Changes v1->v2:
> - Document capacity=0 as default in commit log
> - Document that capacity need not be a power of two
> - Drop unnecessary comment about integer division cost
> - Update comment on capacity field: "0 (default) means PAGE_REPORTING_CAPACITY"
> 
>  drivers/virtio/virtio_balloon.c |  5 +----
>  include/linux/page_reporting.h  |  3 +++
>  mm/page_reporting.c             | 24 ++++++++++++------------
>  3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index f6c2dff33f8a..6a1a610c2cb1 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1017,10 +1017,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  		unsigned int capacity;
>  
>  		capacity = virtqueue_get_vring_size(vb->reporting_vq);
> -		if (capacity < PAGE_REPORTING_CAPACITY) {
> -			err = -ENOSPC;
> -			goto out_unregister_oom;
> -		}
>  
>  		vb->pr_dev_info.order = PAGE_REPORTING_ORDER_UNSPECIFIED;
>  
> @@ -1041,6 +1037,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  		vb->pr_dev_info.order = 5;
>  #endif
>  
> +		vb->pr_dev_info.capacity = capacity;
>  		err = page_reporting_register(&vb->pr_dev_info);
>  		if (err)
>  			goto out_unregister_oom;
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index 9d4ca5c218a0..048578118a4b 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -22,6 +22,9 @@ struct page_reporting_dev_info {
>  
>  	/* Minimal order of page reporting */
>  	unsigned int order;
> +
> +	/* Max pages per report batch; 0 (default) means PAGE_REPORTING_CAPACITY */
> +	unsigned int capacity;
>  };
>  
>  /* Tear-down and bring-up for page reporting devices */
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 7418f2e500bb..942e84b6908a 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -173,11 +173,8 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>  	 * any pages that may have already been present from the previous
>  	 * list processed. This should result in us reporting all pages on
>  	 * an idle system in about 30 seconds.
> -	 *
> -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> -	 * should always be a power of 2.
>  	 */
> -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
>  
>  	/* loop through free list adding unreported pages to sg list */
>  	list_for_each_entry_safe(page, next, list, lru) {
> @@ -222,10 +219,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>  		spin_unlock_irq(&zone->lock);
>  
>  		/* begin processing pages in local list */
> -		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
> +		err = prdev->report(prdev, sgl, prdev->capacity);
>  
>  		/* reset offset since the full list was reported */
> -		*offset = PAGE_REPORTING_CAPACITY;
> +		*offset = prdev->capacity;
>  
>  		/* update budget to reflect call to report function */
>  		budget--;
> @@ -234,7 +231,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>  		spin_lock_irq(&zone->lock);
>  
>  		/* flush reported pages from the sg list */
> -		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
> +		page_reporting_drain(prdev, sgl, prdev->capacity, !err);
>  
>  		/*
>  		 * Reset next to first entry, the old next isn't valid
> @@ -260,13 +257,13 @@ static int
>  page_reporting_process_zone(struct page_reporting_dev_info *prdev,
>  			    struct scatterlist *sgl, struct zone *zone)
>  {
> -	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
> +	unsigned int order, mt, leftover, offset = prdev->capacity;
>  	unsigned long watermark;
>  	int err = 0;
>  
>  	/* Generate minimum watermark to be able to guarantee progress */
>  	watermark = low_wmark_pages(zone) +
> -		    (PAGE_REPORTING_CAPACITY << page_reporting_order);
> +		    (prdev->capacity << page_reporting_order);
>  
>  	/*
>  	 * Cancel request if insufficient free memory or if we failed
> @@ -290,7 +287,7 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
>  	}
>  
>  	/* report the leftover pages before going idle */
> -	leftover = PAGE_REPORTING_CAPACITY - offset;
> +	leftover = prdev->capacity - offset;
>  	if (leftover) {
>  		sgl = &sgl[offset];
>  		err = prdev->report(prdev, sgl, leftover);
> @@ -322,11 +319,11 @@ static void page_reporting_process(struct work_struct *work)
>  	atomic_set(&prdev->state, state);
>  
>  	/* allocate scatterlist to store pages being reported on */
> -	sgl = kmalloc_objs(*sgl, PAGE_REPORTING_CAPACITY);
> +	sgl = kmalloc_objs(*sgl, prdev->capacity);
>  	if (!sgl)
>  		goto err_out;
>  
> -	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
> +	sg_init_table(sgl, prdev->capacity);
>  
>  	for_each_zone(zone) {
>  		err = page_reporting_process_zone(prdev, sgl, zone);
> @@ -377,6 +374,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
>  			page_reporting_order = pageblock_order;
>  	}
>  
> +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> +
>  	/* initialize state and work structures */
>  	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
>  	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
> -- 
> MST
> 

