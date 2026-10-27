Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D83606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JIaf5rZ6
Received: by kanga.kvack.org (Postfix)
	id 3F5B36B0659; Tue, 27 Oct 2026 05:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDC86B065A; Tue, 27 Oct 2026 05:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBD26B065B; Tue, 27 Oct 2026 05:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9E86B0659
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:35:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33E9CC0746
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:35:25 +0000 (UTC)
X-FDA: 85367898210.09.CC15057
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id D353CC0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:35:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JIaf5rZ6;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793093723;
	b=X9OuI7cPba3Ude7HcWEUTPD6nBO5kHmd7W76Y3fll4npqvD6ylEcuw8YIidVFMf6Q8G32o
	YhgSnlcxxA1LHXsBScRc4moxwKRLpFXlJAtbdr3J1fKX3Sukpsx1HfnHjjMMwOrXLWlpBu
	WV8QTx+KGyJD8FUAP6see5qfec2oBpM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JIaf5rZ6;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWF1Lm9IEVGMMtM+ZXrfgWJyZeU0J8NTR2mjYrY1U18=;
	b=g9v6RV0pTEA8/LlvfiO8LzaDRKHdreZkUASm39gqEf/lU4ULmAXh28Zdd0JDivn7Zp5caD
	c+BATs6xkip8ikFZeEHxo8Awki0xjo5eyNNCEVqEIWStCXyA7bp5iT5anHjzjrNIfKgzDB
	F3Jk2t14MzWdupDjwfPlRXAMFX+azy8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793093722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWF1Lm9IEVGMMtM+ZXrfgWJyZeU0J8NTR2mjYrY1U18=;
	b=JIaf5rZ6nDyiAtQTWmc5jnanGHHUyodaSGI9v5BHpS1mLut5lCq9IFxreiJm2NGJ8CUE7m
	bai5k5VBCBTd805y1KSr1Fuwd9iHP8Vz6yDQmjvY2v+OIY8tWOyRWdyZZIR4ZvRfqOnx3g
	MoLJZu5OXm489BwTrulTW+Qy6cVeQZI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-7wkirFLRPZGGmPzPyAsSJg-1; Tue, 27 Oct 2026 05:35:20 -0400
X-MC-Unique: 7wkirFLRPZGGmPzPyAsSJg-1
X-Mimecast-MFC-AGG-ID: 7wkirFLRPZGGmPzPyAsSJg_1793093719
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1fdde384cso25754145e9.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793093719; x=1793698519;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HWF1Lm9IEVGMMtM+ZXrfgWJyZeU0J8NTR2mjYrY1U18=;
        b=tnX/t3dcN5CxQwJ9a5lm8O6oHPVrTyEWyhGvXyMbwwKCpvHWUbM+4N1IID3f2ylWc6
         Qok04Jzhf2u35/pWxvIWCeDBGTq7sp7HyTPCIDhDERGSPN2SJTuR4mJld4ze2c8oBbf2
         Ee1xBpm0kNaROUyEH5nrkA1OjVXUa9tHMfqYne++Wgjnt9/d8Hu+c0h/kor05D6o+/dg
         wv0nIQSo4429mEtXItiyTF5Woynt3ZUpHpDcAgcpKcBpzLu511jt04DQSVJ/SDSvNtBq
         elz0VBeAMtHJqFAaM9fgKoeFUd1cZcI4ZacNu4IXkWyPY3s9NTwvnbkvi+opkgIVv2oY
         jJLg==
X-Forwarded-Encrypted: i=1; AKwUvBzOV3eGlAEJMsPEu4dnfnU01Cchy0oimMj79Fk54Jhg9L++dcC/iGhg9Cth5+nixfvC1OEwgkWxww==@kvack.org
X-Gm-Message-State: AFq9FYI/JoNBc4ZknHPa8HoGQZiRHo0H9qnmiQ/ul+jOc9KXA5lJgfXr
	PhTxkY2M9TZOSPNMKyWw4rypwvnCh0c8IwH+zv2+Aoy3Lqp2PXYVGP6KDqvuUePN4htKBSgY2p7
	f+b+uSwqbh2b2MccV7yozSHZQslgeBdrKZML3KmkyZSZW8dIZPVK5
X-Gm-Gg: AYBFou2Z6+AgvTctuw9Oe2wEc5BzO85c2Ft+IC3xaQKUT9eQMGmAitnAKckQdrbrO8q
	2ySWSEWWJM3N5OXnxaP/NjRoarL6n+67MZqCafTN/tuzw7QGKPJir1L5Ac7a0msWRPN35MucLD/
	qQl0aUEMpVtgCmnCbsBTKj6UeHwENC/nLOgePHiz8uWsFcv1WT/iDUUUDPLtyX3t+uj2bKQ/Z81
	FNRCKphzX51wyvNovsAwrIYdkZoEksfsjJPAztMbVfsTtrTjspBojgQWVhA7VTtkWSUnuU0xbzW
	80P47LBVTyuTToQ4GQyrPQF0yJtWJvtkirDGEoQNNVzoi9F//krnlUeJNXV3bFPC+XQ=
X-Received: by 2002:a05:600c:c107:b0:4a5:e6fd:65e5 with SMTP id 5b1f17b1804b1-4a5e70ca839mr85162895e9.31.1793093718669;
        Tue, 27 Oct 2026 02:35:18 -0700 (PDT)
X-Received: by 2002:a05:600c:c107:b0:4a5:e6fd:65e5 with SMTP id 5b1f17b1804b1-4a5e70ca839mr85162045e9.31.1793093717941;
        Tue, 27 Oct 2026 02:35:17 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3932sm23007023f8f.18.2026.10.27.02.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:35:16 -0700 (PDT)
Date: Tue, 27 Oct 2026 05:35:11 -0400
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
Message-ID: <20261027052057-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-11-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027025616.1632690-11-kevinloughlin@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -NC4ZMPEYixmU1zaweBtiXNoDjZQwEPJ4f2VHBnEbKA_1793093719
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: d7ez6g7gu7ixkaqgkaj5d5n6jfgmjar9
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D353CC0006
X-Rspam-User: 
X-HE-Tag: 1793093722-970648
X-HE-Meta: U2FsdGVkX1/FuzOBIeXIdcuQTe5o3HCd5CxhhJHGX+4xrf7sJFjxEXwHP/7C2E1v9S+IYqxZmupuZC8DXwgJBe01Rb96uxpe3TTEL2Wls58UAMxNvvyZu0z7sdNaDXdxCPzyMDCAPATg4w1Wbw7OJAyJ03tl6xa2wYfBPLEcx0s5J5Kl4l5zdxcfXmhbO+lJEYfQMFBhMM9IJaH+2pPuJiTcgxrmhUUbEcHGSyuiFfI1mQl66cfD7gXx/X0XNBdMs1qvXF6eoqeTdtxRk0pGwD3pnhiHdOMp5sc85SZUOeEc8XfMjRhwlao/sM1aWnkCaPSbmzJxsRUhLk8fdJxPI/36vANdkUuIhM+o2DlPQ3gCqNk+gpdKzCNRIA+Dvc2QtY5wlvBjFtEKiomEODB3zku8P/hvGmhH9AqqoKmuObhSqIHhzpuqRC4Iivt7XdyHS7RaizG2lwnE+kcsjmPLTgRD40wCQzBpLnQqSOEOJQiARboAFnc2DzzcFuxbyWAkxqJPebnxkklW7leY0P6KtzpkOtMIY9cHZjScyqlSHpV+Qz34nsz8cBCSLBtEC5sVGfExq6uAO6DCUHqKTP4KAiq3hKrvtFXdSn+7E7v+ra/FtEze6kOQQoS0UMSoU2zLxCTm/sqVdzIQVSB/2ppyR0M6RXuy2AQobziKOPN4kHSNfVEypY2bvQIkCbfiiw/5G63ZKHTdNZ1KGevXJ5IxoGxvY0KSCVsxQjqW9Z9fpps/xiGzSnfSCZci+pivNDb6W7iMOAwLs6WpsAyjftdyabP+jCKfqrFgCAeUIMaej3yDkG1NC6f/olbiCfb05ER9yKRHH2ryLXqmvbCa9uF0MMeuvZjrfJ6BH2AzeGNfmqkzzo74wtaukwFZZWPdpaEva2yuTfetiDUx8NBjPoDm61g8DNVG32I1eIQBXV0secluVxJDRR7GbkoxmzkUdd6CueaJsfFlgvZChQ4Zrfz
 Sx4Q+DxB
 9dLLKIhwOE1rJDhOI3GHaawl/HdUqNwNETsBxjd04c/lkvTdeNrvu8S8UxZqnLNm5I75UBYsVu1g2zzNflKNATSqumhfg3KdOfYNH4Rq4ylpI9WxMxaMgNr1n04NG+476D/iU66MMeCkcikExAG+pAMkFTwLLfp+maWVdt7GhJryJBkhUjLh6AZoTptvhIkxwX7SBlyb4KQaL4KVXTdnn+VqcOUAVnXt9qiGloR64t1P/FdRry+BKSy3+rOWYNMNz21RtIuhg+PRxZ3L8YgGxol2SjWhye8lU8gL0LbUtJR5m1kXDcNk/tR3ngWFEKQdYzxMjOIiibRSYt7TsydVZR9MH0gVoLbKRf8sOUxdYwFQt4IELQLMkTCJIdPuKON1WMvr20tVASLXorFxTBhTBiWEOIqlRj/IKHDvb77cK5GhvQ9EC2IEyYSu/bWYgPZCGKLjj
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

I'm not too happy that this rides on the legacy PFN thing
which is after all limited to 44 bit addresses.

And given it is passing around 2MB chunks, then one 16 byte descriptor
covering all of 2MB would actually be more efficient than 512 4-byte
PFNs.


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


Put all this, and preferred order, etc etc in kernel core somewhere,
and expose some sensible APIs that devices can use.



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


