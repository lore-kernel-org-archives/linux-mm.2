Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38F0606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZKBCgFKr
Received: by kanga.kvack.org (Postfix)
	id D1FD66B065C; Tue, 27 Oct 2026 05:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF75F6B065D; Tue, 27 Oct 2026 05:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE61D6B065E; Tue, 27 Oct 2026 05:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 952766B065C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:37:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25D58A8662
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:06 +0000 (UTC)
X-FDA: 85367902452.05.17D1760
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8124100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZKBCgFKr;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ6xG709ht579SVeXaHvhn7gbaGSx41yuwP8KO/9DQI=;
	b=UG90lJhjlfNe5S1aZUwnyOqxVklqmoPDqs0DPlPyN1Kh1iw4nzW42bSRRCpddpn/TENHLX
	cwpaoTeiwAIYhNJYZ+jDtwJFuNck1UKnzUxvAlslMGd/zSbjenw4Kolcw6eRu+VQJ02M8x
	IxpbFRfqO152OoXtULw29t+xwpU+c70=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZKBCgFKr;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793093824;
	b=3jT0hNLKYKjc7bkpholYfjOlDNodKlw1cy1uq7tfn8PjR9rHmyuoIiXfXtW7E0IGtM6G8x
	eNGHzMdfGKaUkY91dguxjl3h/bBvYW9QtPk/sETL/NZHWEBUrHgfgN5qTHtWQGIsYKSUHp
	9n2PezeHQfFoyX6fIbMtfcf1x/sGXso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793093823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yZ6xG709ht579SVeXaHvhn7gbaGSx41yuwP8KO/9DQI=;
	b=ZKBCgFKr+sjmS5UW3lZi1NiSg8Dhtvy4taZj4qeSbDjYoDEIiiMVRCbErV2WtMtjHofhf8
	LmG+Lc6pgO5QozXSyiRHdgmOyIaXS8GOJhVgjpd+dcmmkP5MLb08RyVECb5gebQ0ax2btp
	RsLy18s+0H175z1+Ep174ueNvwOe834=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-B0ox38g1MAisTWSXVsO-qQ-1; Tue, 27 Oct 2026 05:36:59 -0400
X-MC-Unique: B0ox38g1MAisTWSXVsO-qQ-1
X-Mimecast-MFC-AGG-ID: B0ox38g1MAisTWSXVsO-qQ_1793093818
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so26380705e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793093818; x=1793698618;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZ6xG709ht579SVeXaHvhn7gbaGSx41yuwP8KO/9DQI=;
        b=ILDTJyTREhOFQcLtTgSED9WlqXtykHW5Gzx/QR6Wh/G/DqJqcjDG0WVyEZxDJHZlI2
         nu1dfTdW2V/qThC5+7cDwq9JFHtKCbhaOu8n9vgTCq8Q6cQFgqPY6mgN6OwkMkbZw9Vf
         xp2zkJxRU84emq67BGv214mQ1Vo+tjkJ/9k8c+yH9AVQnw+53Z+eg8KAnmzx4Q4z20Jw
         AN/Yn1UyjibAG/m460m3/5TkMRHS+kOSbSpLu+RhKBj0WcIeA0VfO6Wp9hcV5giIjSNg
         QxrDljFfsVCGYgYVxi8vVWT3+dAyeZd6aa9JUZ6j27mNVQhgG21hCU2TfJIcWrio5/f1
         wRYA==
X-Forwarded-Encrypted: i=1; AKwUvBwpl096CkhQ5SlPU3x3v3ye2zNKXAS73iPWSKlh8wSyDKDhSN6K8sl/VZAhDjBFmzUqJTg2C+LG1A==@kvack.org
X-Gm-Message-State: AFq9FYJY+8/dpsTRmhETILwnj8hYJMzCgfHIgYD+Ak8sr2FJO/is7HzL
	CSPO6Qs/B4VqA7IOI/49aKeYbqWLxwIOZ5kXNPHJLBwi7mFCalbYn/i+lIzgLSFTtGHQAXh523Q
	p2rsLUlEU1g4d8EL90IColDqvkLKzEdNFRCptbihwdrI3JvrE91Uz
X-Gm-Gg: AYBFou0M74703Z9JrF6rtv8pFoAk/ICnegczzcVBnX4/T27V7pPKBTJJYHVqzUx3YNB
	+Z2oi7orRN/qEscXzSag5GVH7w2VcF2REW+1NmuWDA1ZfGMRy+dFE6itgGNKc38tF+NvW4wnJ8p
	bVXocaWoljPDMlroKMkKhNCzAs3+qbEl9bcFmmLL/ZHh64iVtJzxxtDNQdwob0JUJus8e6Aj9cI
	tALH55RdHzvF+XBxPuJCKuYWIfT0EgCmXL3WNC642LqOm+NYwZzYbrTerqEZ/E2SbVfcJd6Kh9x
	/RUdyIqM2/eMOA8Kt5G31kf9UQtNhzwinIvKghxRYuoNC+rJodi8zD7nNpArQiJck5k=
X-Received: by 2002:a05:600c:4f89:b0:4a2:150f:160f with SMTP id 5b1f17b1804b1-4a35aca4e43mr174240315e9.25.1793093817461;
        Tue, 27 Oct 2026 02:36:57 -0700 (PDT)
X-Received: by 2002:a05:600c:4f89:b0:4a2:150f:160f with SMTP id 5b1f17b1804b1-4a35aca4e43mr174239545e9.25.1793093816842;
        Tue, 27 Oct 2026 02:36:56 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359fbb725sm253517165e9.0.2026.10.27.02.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:36:55 -0700 (PDT)
Date: Tue, 27 Oct 2026 05:36:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
Message-ID: <20261027051822-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-11-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027025616.1632690-11-kevinloughlin@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pWNGIxBHMYQ1mtebs-0A324R61vg0OoCg0SBejRj6FA_1793093818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8124100006
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fp1ygmctscpa7smakmjbwtgco4exuobf
X-HE-Tag: 1793093823-736250
X-HE-Meta: U2FsdGVkX19ZNeCENImPt/5FC4SOSlzOpI4jE9kywnWsJ5EA2bceBlswh4bYdFKPrRfDqZjRgfi550pPexmWasbITfghDUjO0gMbqyBxrHtO5/mYXKwtr8TQ3kU2VhQXl5wMsSQc15el2HN+GWeA0Wo9wgtxIejXEyA5IpjiXfN+1nz0QpqY+UO3SaSRjqsPyQEUXzpQbzvMcZr7hwGtceJF+gSGBWwU+Msm+wVkg32oEkqhu3Dvk2YqE4horTYge9pPJml5lFK0n4RYE6QelmEZDhx2tEZe8WqKeio13UBx71PTfmzCJX04QshCISx6f+lTxQdP9+gqwrtnrTNbpIGwCVTaNZgHRnumrzSxkOFp1oLmNdNSHnk+TheyyybyWBIunIAX3yM8SWpOYZXO9pmxUz3aIzZ1WUL6usyI7M6sb3I7y3AzLkCEdFhttUkU71NdJlip2WDox2r7Q6pE9QW7i9SilWKKLqCftiLOcmGIthbzAdHBQgFktjWIUA3rSO0EDe/yt32tgwr47qWK8vdzLiPLMUY7sB7n8Hel3GDn6eavy4kkzVPs21aMBnYX1zrUjd3Zw2rzN0P93IbT6cr0yyxXk9YoighO5ZRrpkkWGVzE8BuXcB+J0vnmrj1Nu7ziPi2lu4vIOONpawCiydhuWkzKVIxkn0P/0YKVsRA+uC3gXHERw+ZOid9rLVgJR7PmaMgUEI6HV6I4rXaMr6DP4M93d7jXkX791t3mo4eixlaSc2QGvxQPYUoKrptBnzjjLSf3+rkVwh6+D2lxcNEYy5ULxKNvDPbBYu8PM/awS35uFkc4IkAMF9nqk6XYWHukDQnYsXV5Ol2CC2obrU+mCjCPouy1p7zxdi+oiPMXxT6AV7eKPcbf15jxAwO4HHXIOFJ9IOVLFWoPZx65SSdOlqqNaJkweHSGX9ss1iHt+0D7yBOGIIrrzpVt3NFssrzXsGF+Rnd8Esh9jN1
 QgzKoI0t
 kjxivw1eLRmATsZlODSNr1yn73x6+5oUnAdOcrDImjnXigk8U1U4+WVKrce6eK7Y1ASuAdFGGiWAZLIIWwqPQ8jy/pRUHQKuvjj0NH3cwTlPWSjENpEbVm7mPMlGYpgA4pKYSu3LRCWAm/a5ZoQmlLdnMpyU0+cgny/KR5hDZtaCtwoa3WKaVSIS7PUaZezDhviNAtl+FQ1n2NGvFAuWTrzz4QOaSUYAN5aT3xoQj+CYY9sD4J4lW9boL8qOpj9TCF3sY7rmdKt39z2SokOYgf6mDBV2aYmPB8WgoZ2E6AxPp1HqOVopTD4PpnTYNXC0Ax37mf6GZBdDi/yKTsy7u/K24Y/awxewAuaKJcMNhiumo+SyXXYjiHDu0RJCyDlJxVI5EX5Uvu+ELTtD7VtNwro15LWRoIm/4R3CrTeJHxmrKgxjO9E8WMiL1/3Y3CgHTwJ40
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 02:56:13AM +0000, Kevin Loughlin wrote:
> In confidential computing guests requiring page state transitions,
> unaccepted memory tracking operates at the EFI unaccepted memory unit
> granularity (typically 2MB / order 9 on x86). Inflating the balloon
> with 4KB pages would prevent unaccepting the backing 2MB unit.
> 
> Inflate balloon pages at unaccepted_memory_order() when
> virtballoon_cc_needs_state_transition() is true, while retaining
> order-0 allocations for non-CoCo guests and CoCo guests that do not
> use unaccepted memory transitions. When a higher-order balloon page
> spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
> transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>

BTW I'd say *everyone* prefers large pages. The fact that balloon
currently breaks them up isn't nice to anyone. The only setup
where they might be helpful is severe fragmentation, but even then,
it is not clear we aren't contributing to the problem
by making the fragmentation worse.


> ---
>  drivers/virtio/virtio_balloon.c | 87 ++++++++++++++++++++++++++-------
>  include/linux/balloon.h         |  1 +
>  mm/balloon.c                    | 67 +++++++++++++++++++------
>  3 files changed, 121 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 11f74848fdc4..d162c162b496 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -182,6 +182,13 @@ static void balloon_ack(struct virtqueue *vq)
>  	wake_up(&vb->acked);
>  }
>  
> +static inline bool virtballoon_cc_needs_state_transition(void)
> +{
> +	return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) &&
> +	       cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
> +	       has_unaccepted_memory();
> +}
> +
>  static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
>  {
>  	struct scatterlist sg;
> @@ -243,24 +250,49 @@ static void set_page_pfns(struct virtio_balloon *vb,
>  					  page_to_balloon_pfn(page) + i);
>  }
>  
> +static void queue_page_pfns(struct virtio_balloon *vb, struct virtqueue *vq,
> +			    struct page *page, unsigned int order)
> +{
> +	unsigned int nr_pages = 1 << order;
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		set_page_pfns(vb, vb->pfns + vb->num_pfns, page + i);
> +		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
> +		if (vb->num_pfns == ARRAY_SIZE(vb->pfns)) {
> +			tell_host(vb, vq);
> +			vb->num_pfns = 0;
> +		}
> +	}
> +}
> +
> +static inline unsigned int virtballoon_preferred_order(void)
> +{
> +	if (virtballoon_cc_needs_state_transition())
> +		return unaccepted_memory_order();
> +	return 0;
> +}
> +
>  static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
>  {
> -	unsigned int num_allocated_pages;
> +	unsigned int order = virtballoon_preferred_order();
> +	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
> +	unsigned int num_allocated_pages = 0;
>  	struct page *page, *next;
>  	unsigned int num_pfns;
>  	LIST_HEAD(pages);
>  
> -	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	/* We can only do one array or preferred-order page worth at a time. */
> +	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
>  
>  	for (num_pfns = 0; num_pfns < num;
> -	     num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
> -		page = balloon_page_alloc();
> +	     num_pfns += page_pfns) {
> +		page = balloon_pages_alloc(order);
>  
>  		if (!page) {
>  			dev_info_ratelimited(&vb->vdev->dev,
>  					     "Out of puff! Can't get %u pages\n",
> -					     VIRTIO_BALLOON_PAGES_PER_PAGE);
> +					     page_pfns);
>  			/* Sleep for at least 1/5 of a second before retry. */
>  			msleep(200);
>  			break;
> @@ -274,15 +306,17 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
>  	vb->num_pfns = 0;
>  
>  	list_for_each_entry_safe(page, next, &pages, lru) {
> +		unsigned int page_order = compound_order(page);
> +		unsigned int pfns = (1 << page_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
> +
>  		list_del(&page->lru);
>  		balloon_page_enqueue(&vb->vb_dev_info, page);
>  
> -		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
> -		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
> -		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
> +		vb->num_pages += pfns;
> +		num_allocated_pages += pfns;
> +		queue_page_pfns(vb, vb->inflate_vq, page, page_order);
>  	}
>  
> -	num_allocated_pages = vb->num_pfns;
>  	/* Did we get any? */
>  	if (vb->num_pfns != 0)
>  		tell_host(vb, vb->inflate_vq);
> @@ -304,28 +338,42 @@ static void release_pages_balloon(struct virtio_balloon *vb,
>  
>  static unsigned int leak_balloon(struct virtio_balloon *vb, size_t num)
>  {
> -	unsigned int num_freed_pages;
> +	unsigned int order = virtballoon_preferred_order();
> +	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
> +	unsigned int num_freed_pages = 0;
>  	struct page *page;
>  	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
>  	LIST_HEAD(pages);
>  
> -	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	/* We can only do one array or preferred-order page worth at a time. */
> +	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
>  
>  	mutex_lock(&vb->balloon_lock);
>  	/* We can't release more pages than taken */
>  	num = min(num, (size_t)vb->num_pages);
> -	for (vb->num_pfns = 0; vb->num_pfns < num;
> -	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
> +	vb->num_pfns = 0;
> +	while (num_freed_pages < num) {
> +		unsigned int dequeued_order;
> +		unsigned int dequeued_pfns;
> +
>  		page = balloon_page_dequeue(vb_dev_info);
>  		if (!page)
>  			break;
> -		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
> +		dequeued_order = compound_order(page);
> +		dequeued_pfns = (1 << dequeued_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
> +
> +		if (num_freed_pages + dequeued_pfns > num &&
> +		    num_freed_pages > 0) {
> +			balloon_page_enqueue(vb_dev_info, page);
> +			break;
> +		}
> +
> +		queue_page_pfns(vb, vb->deflate_vq, page, dequeued_order);
>  		list_add(&page->lru, &pages);
> -		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
> +		vb->num_pages -= dequeued_pfns;
> +		num_freed_pages += dequeued_pfns;
>  	}
>  
> -	num_freed_pages = vb->num_pfns;
>  	/*
>  	 * Note that if
>  	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
> @@ -474,7 +522,8 @@ static inline s64 towards_target(struct virtio_balloon *vb)
>  	 * Aligned up to guest page size to avoid inflating and deflating
>  	 * balloon endlessly.
>  	 */
> -	target = ALIGN(num_pages, VIRTIO_BALLOON_PAGES_PER_PAGE);
> +	target = ALIGN((s64)num_pages,
> +		       VIRTIO_BALLOON_PAGES_PER_PAGE << virtballoon_preferred_order());
>  	return target - vb->num_pages;
>  }
>  
> diff --git a/include/linux/balloon.h b/include/linux/balloon.h
> index ca5b15150f42..bc46e36b997f 100644
> --- a/include/linux/balloon.h
> +++ b/include/linux/balloon.h
> @@ -58,6 +58,7 @@ struct balloon_dev_info {
>  	bool adjust_managed_page_count;
>  };
>  
> +struct page *balloon_pages_alloc(unsigned int order);
>  struct page *balloon_page_alloc(void);
>  void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
>  		struct page *page);
> diff --git a/mm/balloon.c b/mm/balloon.c
> index 96a8f1e20bc6..e9941d08d8e9 100644
> --- a/mm/balloon.c
> +++ b/mm/balloon.c
> @@ -27,9 +27,12 @@ static DEFINE_SPINLOCK(balloon_pages_lock);
>  static void balloon_page_insert(struct balloon_dev_info *balloon,
>  				       struct page *page)
>  {
> +	unsigned int i, nr_pages = 1U << compound_order(page);
> +
>  	lockdep_assert_held(&balloon_pages_lock);
> -	__SetPageOffline(page);
> -	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION)) {
> +	for (i = 0; i < nr_pages; i++)
> +		__SetPageOffline(page + i);
> +	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page)) {
>  		SetPageMovableOps(page);
>  		set_page_private(page, (unsigned long)balloon);
>  	}
> @@ -45,20 +48,31 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
>   */
>  static void balloon_page_finalize(struct page *page)
>  {
> +	unsigned int i, nr_pages = 1U << compound_order(page);
> +
>  	lockdep_assert_held(&balloon_pages_lock);
> -	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
> +	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page))
>  		set_page_private(page, 0);
> -	/* PageOffline is sticky until the page is freed to the buddy. */
> +	/*
> +	 * PageOffline is sticky on the head page until freed to the buddy,
> +	 * which resets the head page's page_type in __free_pages_prepare().
> +	 * Clear PageOffline on tail pages here as __free_pages_prepare()
> +	 * expects tail pages to have a default page_type.
> +	 */
> +	for (i = 1; i < nr_pages; i++)
> +		__ClearPageOffline(page + i);
>  }
>  
>  static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
>  				     struct page *page)
>  {
> +	unsigned int order = compound_order(page);
> +
>  	balloon_page_insert(b_dev_info, page);
>  	if (b_dev_info->adjust_managed_page_count)
> -		adjust_managed_page_count(page, -1);
> -	__count_vm_event(BALLOON_INFLATE);
> -	inc_node_page_state(page, NR_BALLOON_PAGES);
> +		adjust_managed_page_count(page, -(1L << order));
> +	__count_vm_events(BALLOON_INFLATE, 1UL << order);
> +	mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES, 1L << order);
>  }
>  
>  /**
> @@ -117,15 +131,18 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
>  
>  	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
> +		unsigned int order = compound_order(page);
> +
>  		if (n_pages == n_req_pages)
>  			break;
>  		list_del(&page->lru);
>  		if (b_dev_info->adjust_managed_page_count)
> -			adjust_managed_page_count(page, 1);
> +			adjust_managed_page_count(page, 1L << order);
>  		balloon_page_finalize(page);
> -		__count_vm_event(BALLOON_DEFLATE);
> +		__count_vm_events(BALLOON_DEFLATE, 1UL << order);
>  		list_add(&page->lru, pages);
> -		dec_node_page_state(page, NR_BALLOON_PAGES);
> +		mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
> +				    -(1L << order));
>  		n_pages++;
>  	}
>  	spin_unlock_irqrestore(&balloon_pages_lock, flags);
> @@ -135,8 +152,9 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
>  EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
>  
>  /**
> - * balloon_page_alloc - allocates a new page for insertion into the balloon
> - *			page list.
> + * balloon_pages_alloc - allocates a new page of given order for insertion
> + *			 into the balloon page list.
> + * @order: allocation order
>   *
>   * Driver must call this function to properly allocate a new balloon page.
>   * Driver must call balloon_page_enqueue before definitively removing the page
> @@ -144,16 +162,35 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
>   *
>   * Return: struct page for the allocated page or NULL on allocation failure.
>   */
> -struct page *balloon_page_alloc(void)
> +struct page *balloon_pages_alloc(unsigned int order)
>  {
>  	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
>  
> -	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
> +	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !order)
>  		gfp_flags |= GFP_HIGHUSER_MOVABLE;
>  	else
>  		gfp_flags |= GFP_HIGHUSER;
>  
> -	return alloc_page(gfp_flags);
> +	if (order > 0)
> +		gfp_flags |= __GFP_COMP;
> +
> +	return alloc_pages(gfp_flags, order);
> +}
> +EXPORT_SYMBOL_GPL(balloon_pages_alloc);
> +
> +/**
> + * balloon_page_alloc - allocates a new page for insertion into the balloon
> + *			page list.
> + *
> + * Driver must call this function to properly allocate a new balloon page.
> + * Driver must call balloon_page_enqueue before definitively removing the page
> + * from the guest system.
> + *
> + * Return: struct page for the allocated page or NULL on allocation failure.
> + */
> +struct page *balloon_page_alloc(void)
> +{
> +	return balloon_pages_alloc(0);
>  }
>  EXPORT_SYMBOL_GPL(balloon_page_alloc);
>  
> -- 
> 2.56.0.307.g5fe7bd680c-goog


