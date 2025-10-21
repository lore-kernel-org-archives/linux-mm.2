Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99D5CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA34D8E0008; Tue, 21 Oct 2025 16:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B008E0002; Tue, 21 Oct 2025 16:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D908F8E0008; Tue, 21 Oct 2025 16:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C81E98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:57:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 565785A0D6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:41 +0000 (UTC)
X-FDA: 84023332722.23.786A3CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id DEEA91C0011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QsRRpi7z;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761080259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bAJqRa8uA5UrlbIgGaXWwm0Ps33WDl0PlkuKaJzgdU=;
	b=H88Yr9bKrBkvR8HbZVEPH708sd8qXOBrO5MJPFDHT7ziHMFU57XTRmLt1B4JLk9BREH8ka
	yOYAtdHBK/NJvPEgRdsdVv96V6oXrplo+Ra+jbKpS3c4not4cOZ7NAMtNNTIhfz/m9mluA
	m+rQ1vBZE+CkwBgOEMbX6vDymCjxoE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QsRRpi7z;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761080259; a=rsa-sha256;
	cv=none;
	b=tYfY7l9JV56KRAofqBapYP/qaYxH/zQkkL91NIwPE3plp8m8nXhYRhU2zmws2+G+kp789s
	x0DW30+7H78ravWj/qrJ6LXf45mNV90RC7m8VXzcdqWzBF69+PhKnxzDBk6RmlydVTyR3i
	vnzQ3sWVq1p66XdeChkw4gmeb87qyVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761080258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9bAJqRa8uA5UrlbIgGaXWwm0Ps33WDl0PlkuKaJzgdU=;
	b=QsRRpi7zPGdwEv+PDNTXHMSWklKabZAG5PipGNRpMRGgAbTM17/lhuAhDvMD3XXyCMlJnJ
	/tld72mMyCL2Wd0gcSAgvmNgVqqT26njOg+7I/FnuWMeheCz5rtJiDwla5hZj3sA/gtwGe
	hOUPEfREa7/cHvckrrli5FpXbPxt1kk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-bzrEx3S5NCSLhLmMwcHoiQ-1; Tue, 21 Oct 2025 16:57:37 -0400
X-MC-Unique: bzrEx3S5NCSLhLmMwcHoiQ-1
X-Mimecast-MFC-AGG-ID: bzrEx3S5NCSLhLmMwcHoiQ_1761080256
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4278c82dce6so2411905f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761080256; x=1761685056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9bAJqRa8uA5UrlbIgGaXWwm0Ps33WDl0PlkuKaJzgdU=;
        b=ZcBker8xRKv8RbhToik8MQOHxopr9c7Bi55aI+qSlN7PN8M2i7q5sW9+HacFwV0kiI
         1tNyhk5Wn8p9/IoEvEa3BCm+C0fsVubH6aehYFvc7v4XztSrioGEZFaI68fEVS7LZAQ2
         JV9Likd4sP7v746Comg2OMhsAg/nTfG6Pf+hxAKTJWVFxCiAFiVdOvJ+lJUCMH58653n
         jxGgr4yY5ErSy1RKR/SoWSaMerhShX3Lo56h9BaqFpC6rjS6bIvFtsVLzFkxy9/aEY2C
         EKpYrW+7EtxFLrrUnpzm4q5wlEUHk7dbxQRs+IbRMEAmPD5L0XT4oVcOq39Q2bi2DyHW
         JAxA==
X-Forwarded-Encrypted: i=1; AJvYcCUWc4pV/o9C162mHlRkc9cmXP/+u3ieDkA31amAKeMZPLBICXqhEF9WlYSP22plsm6NauOSxN4EGA==@kvack.org
X-Gm-Message-State: AOJu0YxutZ8q5rAXWu57FTCVRDzjfC+lSkpiQItkolxEbtP8MWZXaJnC
	jADeH+T2vC+MqxFekKqp3cc52a8Q5uynf2L3oLsywQGFJRZGhx3sRfVYnGy8T2byWRbCVl70Cpn
	X9tHXtGRGBp2NxRWgDs8/VGpVI1k3n0Li9fOqW0Cgl/ccn1m7WyCU
X-Gm-Gg: ASbGnctMzM6iQJ+kRUmijqe9Snd1GEhqnkF8TYG7ghjEIpcDgF2roKjRp5OgdQQMN5T
	gI0vQlBtxizWJ0jzJNxbxSE2+jxrbpjFtg5dxeoH+PNTRL24kNAaTuIjTQIQmd0KCdXvV4C1imR
	z1PQNQOmYM5dFzxZfUK2BywZem6WNE0MCnO3Z4OOmzd40ZTF6L0IDUDkd2U0iOpTQ8nqGbInrLY
	8qhO1aBTCvDOfuK+2VOIVj/5QdWK7CRy5G3/Pkmc0rY0vTY9YIFmQTjISFlQpFRBJ1sZEk/iMq1
	os2FgZpD8aq/JgxdjcJVNwB/RxnPleENvZD+jHp4Oqw6e426Bfs8GDIoQULhtHaBSTKb
X-Received: by 2002:a05:600c:8b8c:b0:46e:4287:a85e with SMTP id 5b1f17b1804b1-471178a4af1mr109338275e9.13.1761080255571;
        Tue, 21 Oct 2025 13:57:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnSG23+FoLb+GmLuXvkTK9R1YegvexPcW+2uOk5jzx98hZ61iH9ju7jBpY4P6BKlTjZs87DA==
X-Received: by 2002:a05:600c:8b8c:b0:46e:4287:a85e with SMTP id 5b1f17b1804b1-471178a4af1mr109337965e9.13.1761080255096;
        Tue, 21 Oct 2025 13:57:35 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428e9b2sm9981535e9.5.2025.10.21.13.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:57:34 -0700 (PDT)
Date: Tue, 21 Oct 2025 16:57:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 06/23] vmw_balloon: stop using the balloon_dev_info
 lock
Message-ID: <20251021165626-mutt-send-email-mst@kernel.org>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-7-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251021125929.377194-7-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MBpoPiEPnZd7d75KXT-tIEOh-XS8yhxf6Ko7asaGNUM_1761080256
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEEA91C0011
X-Stat-Signature: wz7ugke697iq6ey8be99xen64zktezid
X-Rspam-User: 
X-HE-Tag: 1761080258-444111
X-HE-Meta: U2FsdGVkX1+sY1sP1sYQc8Kot47Ww2740PCrOyXJQ/qiy9VGgz9kkdFyE8iXhKtYAwIXmRVtvSwiVELhtTBTBOmGGHinEFLMswOcJBI1/clVhom1TSguNLBUlclS3n6PjAKcJ8qW0yEjp8fJ3bcN7+S1Xh5PLXROc4niGL5x2a6Rvo+mJYSAzMkWEJEAF1VvoPvRE1TKG21jK5zdHEIbztqf8CmQ+5IXJ9Gti7Y7KpZAMnMH4sTqeaKRqs7ighSwE/Z2k1o/1tiP4vbzB/9Ui9fL03tyr34dk78t704fCLuJR5B9XE2jXKOaULq6l8+8b+tIhZLp+gjlvsWRXOMFZUUx2t4LdWIMrHLQViY7TfvndsLPGYPL3Yu6tJjjrySFyuJaF25KVV4VDsfjqbwgj9GUIrVC0JWr/2M5a8rn5/ZYjOMO5UjisArmTNgYzHwfTAQCEzUqnMyQGKz4qGLC494QaEqGWxi8MvyOanYOI8U2aLIlz4H5idKQhUvupEvfQR7RRQRV89RAlipBxZVxyZhTCkvNR1Ii4KZmBYMTiek9AXtg6zEztvW/9BOrSzlozmTvJbgAZZqgCxaJpolDvF7BPF3JYsfLQmxq+tG2wGIh268AsYiBWf5N2WHx2B3AfLajacaNWviREFKI9yLP32X4fHD+XL9ulE6iqRvyn3HIeFvbT1cx/rCOu2nkAduyTv9vfBZSYefljIZbPzjWR0MZXyqkR1dmdJ9btjaPdjld3vKEyM3+Kcyvrf+JP1GFCyMpYDC4903tBI7RFOBiVONopOaHR1jfiVVp769Ljaheu88KWpmJRCz3sTvVKddF7NcxkHqM+CIeo1Tbf13H8hbn9MB9WmFraTQd1b99N8Ur43cUpSilkvK3s8aHFQTNe3DmxZvHABpRuRanXWNR19Clx4gcjHGG1lh0Qyni4fh82z7GeQgcNB95pkwX/xY5k1hNg4nbB4zP5QRpJMW
 T5Hgc8RC
 j6sdF6hSOrQtN+rONGXEKcjjaok/q2PXr6rSG5Dk7/FSWrF7t2Zv1TedZnsnHLm7hll/3bs/4HM/oljlMAPM8cD/GGSz1Z334cvDu3jB5TjZ+IHUDVsK4og7H2r0hFmaAEpWWzgEbCTtPQOdyRNfn/3HsgTCfIM7/unMuozAC0g3sjulhKD4BW1kDH45T+Q06dczk71Ctc4UhsADu1SwBD+qAEHaObUIRlFC/Tqxl57pW7aIoEM12JB0QUpsRxVYoobvh2SxLf2hQntC5LgQ4h+sP2cLk1wN7KcxwI6UgoSn1RKT6TSIJSVOK+3hgOc1gc/J1otbXCdcdIR5lEgiPciQURDRiAUxCfrY0rgvgSyxU1QPxz3h8yv9sryqHs+mZGKKPIJwpy7AaAosvNLYFLWAd6YSJ1C8chY/1J2bsu3tS9U+WK8/WvCoYQDn10bL5gQqGqQDFv4lfAW+SUvaYNduMAQqqed5ZcUKpbSy9xyOGhUQf8+6TsTrIKgLHiEyAbEbWiNHyyRuOcVjvlP/RR/aGRf+9Z51kSNDeve+0cG8qKZYYEBzKtDThVCcnZaqz3zXzoot1vcisVnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:59:11PM +0200, David Hildenbrand wrote:
> Let's not piggy-back on the existing lock and use a separate lock for the
> huge page list.

which is fine but it is worth documenting that we are also
no longer disabling interrupts while taking this lock.


> This is a preparation for changing the locking used to protect
> balloon_dev_info.
> 
> While at it, talk about "page migration" instead of "page compaction".
> We'll change that in core code soon as well.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/misc/vmw_balloon.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 52b8c0f1eead7..53e9335b6718c 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -354,10 +354,15 @@ struct vmballoon {
>  	/**
>  	 * @huge_pages - list of the inflated 2MB pages.
>  	 *
> -	 * Protected by @b_dev_info.pages_lock .
> +	 * Protected by @huge_pages_lock.
>  	 */
>  	struct list_head huge_pages;
>  
> +	/**
> +	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
> +	 */
> +	spinlock_t huge_pages_lock;
> +
>  	/**
>  	 * @vmci_doorbell.
>  	 *
> @@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  					unsigned int *n_pages,
>  					enum vmballoon_page_size_type page_size)
>  {
> -	unsigned long flags;
>  	struct page *page;
>  
>  	if (page_size == VMW_BALLOON_4K_PAGE) {
> @@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  	} else {
>  		/*
>  		 * Keep the huge pages in a local list which is not available
> -		 * for the balloon compaction mechanism.
> +		 * for the balloon page migration.
>  		 */
> -		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> +		spin_lock(&b->huge_pages_lock);
>  
>  		list_for_each_entry(page, pages, lru) {
>  			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
> @@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  		list_splice_init(pages, &b->huge_pages);
>  		__count_vm_events(BALLOON_INFLATE, *n_pages *
>  				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
> -		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> +		spin_unlock(&b->huge_pages_lock);
>  	}
>  
>  	*n_pages = 0;
> @@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  {
>  	struct page *page, *tmp;
>  	unsigned int i = 0;
> -	unsigned long flags;
>  
>  	/* In the case of 4k pages, use the compaction infrastructure */
>  	if (page_size == VMW_BALLOON_4K_PAGE) {
> @@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  	}
>  
>  	/* 2MB pages */
> -	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> +	spin_lock(&b->huge_pages_lock);
>  	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
>  		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
>  
> @@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  
>  	__count_vm_events(BALLOON_DEFLATE,
>  			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
> -	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> +	spin_unlock(&b->huge_pages_lock);
>  	*n_pages = i;
>  }
>  
> @@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
>  		balloon.b_dev_info.migratepage = vmballoon_migratepage;
>  
>  	INIT_LIST_HEAD(&balloon.huge_pages);
> +	spin_lock_init(&balloon.huge_pages_lock);
>  	spin_lock_init(&balloon.comm_lock);
>  	init_rwsem(&balloon.conf_sem);
>  	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
> -- 
> 2.51.0


