Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93569CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000AE8E000F; Tue, 21 Oct 2025 16:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AAF8E0002; Tue, 21 Oct 2025 16:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E309E8E000F; Tue, 21 Oct 2025 16:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D513D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:59:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B173711AA83
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:59:20 +0000 (UTC)
X-FDA: 84023336880.30.5F865FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C4491C000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:59:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ak2MiQod;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761080358; a=rsa-sha256;
	cv=none;
	b=7Mz/Ni+nhP98jVRc4XTOJGQOdmsAxAXxggG8PRn6NRHPr5hUQUtm5WT35pAoPjJ+YexTtw
	+iW/KJIpJX/q0PSYAptEFqg6XF03yvgJU47CJqpausf0OclF3rR2PpSngE1+CjLHU/QBHA
	cqvcp4ciMAh7nxx7iRmDa19c4ViNmlc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ak2MiQod;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761080358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKaU+TdmcHMrV3dqR9kS3A74O+yRTxyeV7YGtEGdpzU=;
	b=cWIBSQP4uhZMdYuTg3iByF9bHef2+kpCr+OvK4YCjUZs7Hfp5TDqA2FSHgqTJgiIXkOMvv
	MsUcTqrtFrMKSsqJep73TgzgOJId76XxGR4iwmkCt5QlvTpREht2Z0gPL3j2gjNc4QLKnV
	WFJPWx64uObA4m7iN83HBm+tJqViH28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761080357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JKaU+TdmcHMrV3dqR9kS3A74O+yRTxyeV7YGtEGdpzU=;
	b=ak2MiQodYy8PrtoUF/ePZHXkPB0d+5eMBbTCj72J5WDRY4auwyLmXitX0JFIwKG6dcAXyN
	nFJVpNOnQARhHTZl1tjUNyLNmUNZyqFXKGybcNAiibogmkGMG/jB1k4RmgpfSjnSl1iE55
	rvJ6LeMNpIRwP5tZz8AabrR+ZYXzxWI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-Tta_1LWYMa6qOpelxe1LYA-1; Tue, 21 Oct 2025 16:59:16 -0400
X-MC-Unique: Tta_1LWYMa6qOpelxe1LYA-1
X-Mimecast-MFC-AGG-ID: Tta_1LWYMa6qOpelxe1LYA_1761080355
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-426ff59a320so7527864f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761080355; x=1761685155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKaU+TdmcHMrV3dqR9kS3A74O+yRTxyeV7YGtEGdpzU=;
        b=hDAPWxPcSEPTOx3yTkl/36JGFPENS1ImWkxfNomW3XJRlH6CjSJgAnor2sojHRcKz6
         ilvn6lDj5OwQQnQa2NebkSpVyK06Lf9Juqv+60r7aMmnsPZlIbYWkd+0bBstfskDRrKB
         YXQMGSL+vEF+VFmUO6BPVRCx0/ZhKmtjRMCFEGWgCJyK6o6spZBTTUY4m+Kr0sJ7/jzT
         dj83ItT9NXhlKnEIPwqL7dHZpRLws8muLaEvHfe/fbUZSejDiJUIpRrGLCdn48XWyj1u
         t5JAaVkZJaBFyYNhxtvV4Fwkv6ZDz69Lw4ISvUpLsg/mH8MPXnVOGecPDsS/9zBIN08a
         Bmow==
X-Forwarded-Encrypted: i=1; AJvYcCWR+WxZ0bmno2PqCI/+OuEXHEsTrddCIWjZ7fSBBqOi/NQVecJYtZvRvfLp5nxLT23caznTkJNxEQ==@kvack.org
X-Gm-Message-State: AOJu0YzX+RlE8ACu3x+VTSa4SAr3elJ8sTMNDYTqUlhByyFXxfyMh68B
	Hy3lnqL/2zMXGhGPHq54NyIrt/LN0qS27DM1MSgr5ZofgKBGlBN7WXx4MqfVK0ZhOydBAumM2m5
	bcNCzwx9Z51IwwZEiUtIKWyakTgeK+jBT5ndFctXjwgPgYsv0gEyU
X-Gm-Gg: ASbGncvJ3//aUtCKM40tLZqWATs1a9Gld/bDU0q8Mpvzac5J42EkPqWRhT3xtPrppNT
	mLckumXQon9ZAVKqKhvys952pvjbBYQitHp/2tZyVXCYKe044D4bttVDLyZGnWruMuDVVhUtOap
	WAL5nv4efaEe9Fowj6PtHgwKbJE9xod3dAzvB3h8HDl+ljSPn/Dl/qMR+ZR8zCpKQ9DZOuPbeqr
	Ja//N9MAXlxN+SuU8clNYfeUiou/W68zVAZGBFI4A8pNQoKUR+SsDtoutaax3FvXF0KJEkbfEDN
	KuJ6sF6ISsE+Iyy6G6fHtelU6ZoZ6siNyW+ksphdK27fUVn52gjnAe+NBXoi+XOJc7D7
X-Received: by 2002:a05:6000:25c7:b0:427:854:787 with SMTP id ffacd0b85a97d-4270854085bmr11773166f8f.51.1761080354933;
        Tue, 21 Oct 2025 13:59:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFm6nUHK4Q2KcRAx2gRXyZZ7eczPX8h4ab+8B0PRAUXehLh5qUDHKRiFzbQIJWCndKqsBf56w==
X-Received: by 2002:a05:6000:25c7:b0:427:854:787 with SMTP id ffacd0b85a97d-4270854085bmr11773131f8f.51.1761080354419;
        Tue, 21 Oct 2025 13:59:14 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4369b33sm9493345e9.14.2025.10.21.13.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:59:13 -0700 (PDT)
Date: Tue, 21 Oct 2025 16:59:10 -0400
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
Subject: Re: [PATCH v1 11/23] drivers/virtio/virtio_balloon: stop using
 balloon_page_push/pop()
Message-ID: <20251021165854-mutt-send-email-mst@kernel.org>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-12-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251021125929.377194-12-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wgQ78cIL3Q-1yyoe7wUhD6WqhOtfioYrmvaADzkfsnk_1761080355
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C4491C000B
X-Stat-Signature: hoamkngbfmngann3j9zy69r1az7wh1te
X-HE-Tag: 1761080358-736049
X-HE-Meta: U2FsdGVkX1/3LnrV6DVhASUvf3Rf59UM0OhjTml5RNYgZe7nb1TvZoSJEhL4dez5fR7ruuiE3EiYcT7FR1qAifkfJSMQ5pNyxDesSTSK+MqYgsIBkifG0fyzcskQWGChtQRC31XgnXgvpT+39go/XI31kQ8jTDKdlDqpMTIRWkrjWbDPe1Zv7srAXsGfjatiUZoMCMWWt7N4p+QwdMTA3f5Fo0uKNxnftEezhiw0j1qr5rT51dk3t2OHlMrk6iKEjL7d2kg0mI4vEAdX+HIsR4XOhUk6luat++bH4FOM5MLfHRWwLCC7ZKIUVr3GlSql1BsRHrmSGXrDNnOA5PF/2+kDPHOqg+zCbiaTmGsCKQzpuAzUnwycPhwr3lb7r9Hs/hRQUTQox1YtwcEtIiLFd61z3sYRNZFiEEPh6m9Z/BELCEqL3wCEoogQvSuuYKwM4mH+C3tiEb9C3sYMeydPA8uxkYyt+3lj/8FQoauONKHLwuLH4OexDK/GA3/DMKJhcYMVQq8P5bAi1Y1EfuDQn///mhheqplAq85BiC4DD5Xk5rXzL/7BynBcq/Qq+U1p9YSd4xP/FVRD68TygOQAaIXwmSqZYlCKhmd95sIUMVStdr8/CQbapdv2dCd61tokVpVzTDsLm9geE19RAA+vPiBweVZTyQUd87lg4PhHwMorfJ1zzq/pXy3kjLv1zLGZfishKLY0ZOOe74d3BpGskwvRxszNFPnQG0L0snvebadGkJ/CJiGVF4J0uFsQyduN1jlp3AlsIUOvy98jKbsiZmvsTqxpZrSlh3CKWy5YRD+iDnMRNpSMMOsgYf5rHJagTc31vuWg2YbTsiVNBOEMawP9N52i6yNRizhwVy1AyeWOgReWxSe2MzlIuNZQSSwhNnuHB7hWc/tp3CoLJ7OkA7VF4qGNLKp02p4K9X6B27NvNrlkzRA2brl+nZtYU0sPm5yPIj1oKEyUc4di6JV
 0/lqwtVv
 w4vQprzkhCSJi3fXyU3zctyU02h/MVwA0RMRg7O8i0m92UhiTz0xXVDo8nIu6YlWX+uO23WOBbglfRrl8UFJtoFAzFUnWgIW3n2uGchxAd1poVsS0lpSi8Tny8KFgidnz6VubP6rOMjvir0Mg1gtA08yDvwBa/9QRjEV9Sy3rVXv7vtccOiaBSkMy5y962Mdt0Y4xNRsE1mlST7gVHWaBNMwnX+sLaB21N8b81JsgYBBPyeGXlEYD6xYzdPdepnphe26rH1tjKn3MeGPL9eOxF+HqHJLE9n1R2FPkjSZgjMNy4Xd8M6tY1gE8lZj2pKV+u3hAP6hrzK/MRi47UC/QpVwSZImiMQBNMe7sG5Rc8rjRBET7plupmgGDj+Iq85dcRWiWVdC9rQ4iSVI97LPYzcvXYis9bGiuRTh9W4E9qBAkwf816ISt95IvAE0VJ7hG/Mz17ByBR1YFi4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:59:16PM +0200, David Hildenbrand wrote:
> Let's stop using these function

these functions

> so we can remove them. They look like
> belonging to the balloon API for managing the device balloon list when
> really they are just simple helpers only used by virtio-balloon.
> 
> Let's just inline them and switch to a proper
> list_for_each_entry_safe().
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index f7d6a4a6e54f5..4b22de6a5f845 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -242,8 +242,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
>  static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
>  {
>  	unsigned int num_allocated_pages;
> +	struct page *page, *next;
>  	unsigned int num_pfns;
> -	struct page *page;
>  	LIST_HEAD(pages);
>  
>  	/* We can only do one array worth at a time. */
> @@ -262,14 +262,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
>  			break;
>  		}
>  
> -		balloon_page_push(&pages, page);
> +		list_add(&page->lru, &pages);
>  	}
>  
>  	mutex_lock(&vb->balloon_lock);
>  
>  	vb->num_pfns = 0;
>  
> -	while ((page = balloon_page_pop(&pages))) {
> +	list_for_each_entry_safe(page, next, &pages, lru) {
> +		list_del(&page->lru);
>  		balloon_page_enqueue(&vb->vb_dev_info, page);
>  
>  		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
> @@ -474,15 +475,19 @@ static inline s64 towards_target(struct virtio_balloon *vb)
>  static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
>  					     unsigned long num_to_return)
>  {
> -	struct page *page;
> -	unsigned long num_returned;
> +	unsigned long num_returned = 0;
> +	struct page *page, *next;
> +
> +	if (unlikely(!num_to_return))
> +		return 0;
>  
>  	spin_lock_irq(&vb->free_page_list_lock);
> -	for (num_returned = 0; num_returned < num_to_return; num_returned++) {
> -		page = balloon_page_pop(&vb->free_page_list);
> -		if (!page)
> -			break;
> +
> +	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
> +		list_del(&page->lru);
>  		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +		if (++num_returned == num_to_return)
> +			break;
>  	}
>  	vb->num_free_page_blocks -= num_returned;
>  	spin_unlock_irq(&vb->free_page_list_lock);
> @@ -717,7 +722,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
>  		}
>  		virtqueue_kick(vq);
>  		spin_lock_irq(&vb->free_page_list_lock);
> -		balloon_page_push(&vb->free_page_list, page);
> +		list_add(&page->lru, &vb->free_page_list);
>  		vb->num_free_page_blocks++;
>  		spin_unlock_irq(&vb->free_page_list_lock);
>  	} else {
> -- 
> 2.51.0


