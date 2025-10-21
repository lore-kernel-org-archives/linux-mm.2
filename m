Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD45CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062AB8E0009; Tue, 21 Oct 2025 16:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A6F8E0002; Tue, 21 Oct 2025 16:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E926D8E0009; Tue, 21 Oct 2025 16:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D833B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:50:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AE5F487C6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:50:42 +0000 (UTC)
X-FDA: 84023315124.16.AFE67D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC34F4000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:50:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JgWZ5Lhs;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761079840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RobzOFu/jAbh3b+O43Kdqr0UVxO/89X1DeZoncRJBNk=;
	b=xa4SVpPMLFY/ZhEE4MoTrr9j9LG3nuspxr1W2Zqsnmwtez8gXzN8O2vNuoft+EeI4RtwEN
	WfR9BDVYiqmMyR7wa2UWoqqf9DLNIDdavb08hPakkiIh16BKyJmM61CpXUPevPxFHA96fz
	KALSVmw+kPwVdO/h+YVwdizo0mCyGwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JgWZ5Lhs;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761079840; a=rsa-sha256;
	cv=none;
	b=5a+RnwBKMG/hj4rmf1IUcjTCH3fLzVjZoKD09eVhiFSYAEn2CiRk8D6avr5R1wEdo7Puhe
	ZwxqrfDUdsB/tljLZk/fRpQwhOzKdxpi985bbm6YpuSMKy/uLdYeV18rQef7hoFKipbJ8K
	hcWgGlqqsCo7VKwqYG5BrxXvzF+yPPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761079839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RobzOFu/jAbh3b+O43Kdqr0UVxO/89X1DeZoncRJBNk=;
	b=JgWZ5Lhsy4JBiN71kZW1JucImCDffOK7HUdXXQLPQWAYKANnBtpl+YU0mgK9SYZZj+i0s7
	tn+zzIfl7lKm73NKOpHFW8ALhBtlJM3wc9zYbD5v5wmXG4anPnTFwNiwmMnQNBIPVeHFeU
	7Sp1uwC4PVRvPlYl3atx/hER7qzr+6s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-bl27EXFlM3WQzF-iISpzgg-1; Tue, 21 Oct 2025 16:50:37 -0400
X-MC-Unique: bl27EXFlM3WQzF-iISpzgg-1
X-Mimecast-MFC-AGG-ID: bl27EXFlM3WQzF-iISpzgg_1761079837
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so6413626f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761079837; x=1761684637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RobzOFu/jAbh3b+O43Kdqr0UVxO/89X1DeZoncRJBNk=;
        b=k/QV8eii6Cd5cbWMaGXzy4CFYrri7TUB9IqsCkIrPGDdh/I4AmrRBnzxriURGqdo45
         rDzvWgwQ5jFz6KIxVNlaSF74wc41MFNmCggyr8t2XJxCAnCiqndPFk37h8jT32voSgit
         6/NX2ZWvgpW4LXWR+wp4CKmvv4O/wlD7QfGMEsD4eA83LcIjNFl85kXgwdeFzu9bc5pN
         4dvarbBldvqYIrLEJ/fRA1j30xCRG9iRKol1KPNN2L7tnmH8Dlz+w8T6hQ4UKVwNv+8e
         4/RCQ4CNUCDBNpDPPwQC3GVKj2/XShfw4qMyRMEzPXCduJlaCKWdYCwh5HuAWkAFf/4w
         CVFg==
X-Forwarded-Encrypted: i=1; AJvYcCXN1k1ydf0ZSbyXx9WHWqR0Rof7nAyVSOzIeWPxGJK09U0orMpY/4mXwhTXtcLSvUEnPdxOhAZKYw==@kvack.org
X-Gm-Message-State: AOJu0YwoJjUwmUqcn0A1DhkMDlFJnchpt1UZSY6JgSM/oaHWVE1Acoly
	gTTEWgHafV/apT7Ibu0JsS2NOqiWyL0KPL6Yxc0tgY+vLSStlkWjy15nEzB8LbxmesU/0RIcQ5c
	xWKhdltmiCP7Xf+sDRmr+VgI7/81QOz74rZ8v8+MSzf798GshfKpq
X-Gm-Gg: ASbGnctWH8Hp/VrlxEtZzZNv+dELzTlbm4n7zlfMW5n5uyNxD74u+XGY8eb2nRM/n+y
	NyBAbDhml3BMHP2s9zkXFrsWMswd7KIuRu2p2nc5Q8q6q5eCN9pCSdqbdagpVlI953whz+eDhkw
	TjxDwFHSUhSO3wmrj/8odPOmFAGnaS/QdaBVzmX0FNq7i9z72R1eZtvkl7I98OGDdtu+G8Ouocc
	MyXjqDTv+/bKeGgTWAfm20PVPI3yJIMzCWvxLCuz6gEaU8r0+NOUFWBgEsKM+eoYrJBHSDgvyX4
	ZvNgfFl8kTDiPLKBtBVdrvtY7tiW1mgvo3PkQ9gWQyUm9f2owwrVVB+3qHV23Vzx3PVX
X-Received: by 2002:a05:6000:491d:b0:427:55b:cf6 with SMTP id ffacd0b85a97d-427055b0cf8mr13376229f8f.7.1761079836347;
        Tue, 21 Oct 2025 13:50:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkPVkTYV9/EGaYL3AjJzNlCZb2bqURn+LcfpURQ5SbHxLnhrS59J1HFohnHIpwTzwj6nrQ5w==
X-Received: by 2002:a05:6000:491d:b0:427:55b:cf6 with SMTP id ffacd0b85a97d-427055b0cf8mr13376200f8f.7.1761079835780;
        Tue, 21 Oct 2025 13:50:35 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c427c3bfsm11772045e9.3.2025.10.21.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:50:35 -0700 (PDT)
Date: Tue, 21 Oct 2025 16:50:31 -0400
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
Subject: Re: [PATCH v1 04/23] mm/balloon_compaction: centralize basic page
 migration handling
Message-ID: <20251021164916-mutt-send-email-mst@kernel.org>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-5-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251021125929.377194-5-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pJyxracrOlWualNXx2PGADUWUm6aj8GXLlzmHUjm240_1761079837
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC34F4000B
X-Stat-Signature: 1noahi4f9e76eukth5yy35gwzqtyaqa4
X-Rspam-User: 
X-HE-Tag: 1761079839-23695
X-HE-Meta: U2FsdGVkX1+pIVnKzqtp/eExyPFcbgFeqNY7H1Tzzh4Nj8SQrhCy9Y0Q9b8JUgLbERe0jcwRIpHjyVU5zdrcBjSifeD7e0bdVhVTl/TyA1IoiwVwYbqnpXx6rFuxvmpk4KmuW8+nf7anmAwnsXWhPo3BZK6CPZ9v/AQBbmJerokmhg7djuyvnldSxNnXXPmWR9LYTO2tX/znSMdaU8WFATkm54aLbB8xr8IwtxsEaasEWaKbj1IlBwxmwKeTQw1ZzkJpLJbpLyECYFG2HWCQ8YBpTrc4gT6YmgoHqMxCD6wlN7D23/x+u+ZXpwQlnOgPpRPmrrfrWYPMkS7FnHTvMZytduyj40EdiBj1dhcnNd+iGA5nG23dgWKjO65emW9v2308MsR7FrQwfDJ9u64CifoTqCQnOqH9ysGcnEoUJ3ox3r/iB4D27IXNCxhV8Dgg3qSLoSgjFhPC/P+3q9KIVEgjKlM+4CEgkrLAn26/t+HaMXe/x/I5pZFHAFcQyfas8PqqUKh1Y/+teyXVRHw+dZDRuhzhwr6qBI+y0pyyGszFgpn1SiAP1qhlKIlL5v62l5DJBO3hPqsEdhdt8IwvWSM0t03qH17iE9Xk+c1Zp1xzEP083yCUzilv9B0qPygCTOQ9EwRaZNoinZDwTw9n43Z1Z2jOLZONLY1Pua3DgcpcS3NrnIwH5jLbyQ2y1hxffB4T7rIZPHHFY847AY78yCrttzMOQ5vjMvLc1G+TMBeS+qur5evhK3oKxgIWW7Mb/PC2E6y4lsmivx0jN6FNWSbybS7x+IIQU5n1fOO5SQxhhSB2qn/oN314xSKjo9bztEbn4Y/J7Zul8p5r107lBERjG2h8i8QT2GVUv5vbJkJR/s9X7Vc5rzcvGMQy8oTAeZJG0tlbQYm6qUgamjbJftmf5uGzr1F9yTsXMeSzJYMQJeDuCtwYv38I3xwszsfrqvJkMfZgjSUmi1mQXnk
 dArvhAJq
 SPlc9kjTeC1pouoLqDNUVN0ep4j76RE6TAmapDSupQzMpMDMlhqS3wPlq19t8nxcA84Gy05XUJo+jZJ9FINpUrrFFQrFoD4uaUeUre69vrnVLKXfpTBG+d/atreQZr5Ql80R2eQnleBdFyxqJmt1Irl46vTnEwdrhqxIVa5Wv9mUF/5ce8JJQpQSl2QvVq3/Iq3lRsE7D2M/jEves8qwQZOoWkJvfSrTDw9owCFtSbvJAiXq364GTrvCGwEFuj+fIZIlt6LravXN3vkma1TTmrJRr+Z8FW/EhKwc7JfCw3aoLp+Gxtq8AA8ARzRD9Hqcqivcm+w4462KodB3VTgy5x3zCxpKFVXJT+ZWiR41geZSEXVuwV7NMSv+B3HqlKPdMrm+EAevDq1ZCnI5eicogeRudv9Ra4UYcN2XFt0S2cZNJ0QvCUjEwqAxjeY2zQpfZC6CNot7sa9fQCbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:59:09PM +0200, David Hildenbrand wrote:
> Let's update the balloon page references, the balloon page list, the
> BALLOON_MIGRATE counter and the isolated-pages counter in
> balloon_page_migrate(), after letting the balloon->migratepage()
> callback deal with the actual inflation+deflation.
> 
> Note that we now perform the balloon list modifications outside of any
> implementation-specific locks: which is fine, there is nothing special
> about these page actions that the lock would be protecting.
> 
> The old page is already no longer in the list (isolated) and the new page
> is not yet in the list.
> 
> Let's use -ENOENT to communicate the special "inflation of new page
> failed after already deflating the old page" to balloon_page_migrate() so
> it can handle it accordingly.
> 
> While at it, rename balloon->b_dev_info to make it mach the other

match

> functions. Also, drop the comment above balloon_page_migrate(), which
> seems unnecessary.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/cmm.c | 16 ---------
>  drivers/misc/vmw_balloon.c           | 49 +++++-----------------------
>  drivers/virtio/virtio_balloon.c      | 12 -------
>  mm/balloon_compaction.c              | 37 ++++++++++++++++++---
>  4 files changed, 41 insertions(+), 73 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 67c7309c36147..07b21d2bc8a78 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -501,8 +501,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  			   struct page *newpage, struct page *page,
>  			   enum migrate_mode mode)
>  {
> -	unsigned long flags;
> -
>  	/*
>  	 * loan/"inflate" the newpage first.
>  	 *
> @@ -517,9 +515,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  		return -EBUSY;
>  	}
>  
> -	/* balloon page list reference */
> -	get_page(newpage);
> -
>  	/*
>  	 * When we migrate a page to a different zone, we have to fixup the
>  	 * count of both involved zones as we adjusted the managed page count
> @@ -530,22 +525,11 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  		adjust_managed_page_count(newpage, -1);
>  	}
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> -	balloon_page_insert(b_dev_info, newpage);
> -	__count_vm_event(BALLOON_MIGRATE);
> -	b_dev_info->isolated_pages--;
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> -
>  	/*
>  	 * activate/"deflate" the old page. We ignore any errors just like the
>  	 * other callers.
>  	 */
>  	plpar_page_set_active(page);
> -
> -	balloon_page_finalize(page);
> -	/* balloon page list reference */
> -	put_page(page);
> -
>  	return 0;
>  }
>  #else /* CONFIG_BALLOON_COMPACTION */
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 07e60a4b846aa..52b8c0f1eead7 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -1724,18 +1724,17 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
>   * @page: a ballooned page that should be migrated.
>   * @mode: migration mode, ignored.
>   *
> - * This function is really open-coded, but that is according to the interface
> - * that balloon_compaction provides.
> - *
>   * Return: zero on success, -EAGAIN when migration cannot be performed
> - *	   momentarily, and -EBUSY if migration failed and should be retried
> - *	   with that specific page.
> + *	   momentarily, -EBUSY if migration failed and should be retried
> + *	   with that specific page, and -ENOENT when deflating @page
> + *	   succeeded but inflating @newpage failed, effectively deflating
> + *	   the balloon.
>   */
>  static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  				 struct page *newpage, struct page *page,
>  				 enum migrate_mode mode)
>  {
> -	unsigned long status, flags;
> +	unsigned long status;
>  	struct vmballoon *b;
>  	int ret = 0;
>  
> @@ -1773,14 +1772,6 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  		goto out_unlock;
>  	}
>  
> -	/*
> -	 * The page is isolated, so it is safe to delete it without holding
> -	 * @pages_lock . We keep holding @comm_lock since we will need it in a
> -	 * second.
> -	 */
> -	balloon_page_finalize(page);
> -	put_page(page);
> -
>  	/* Inflate */
>  	vmballoon_add_page(b, 0, newpage);
>  	status = vmballoon_lock_op(b, 1, VMW_BALLOON_4K_PAGE,
> @@ -1799,36 +1790,12 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  		 * change.
>  		 */
>  		atomic64_dec(&b->size);
> -	} else {
>  		/*
> -		 * Success. Take a reference for the page, and we will add it to
> -		 * the list after acquiring the lock.
> +		 * Tell the core that we're deflating the old page and don't
> +		 * need the new page.
>  		 */
> -		get_page(newpage);
> -	}
> -
> -	/* Update the balloon list under the @pages_lock */
> -	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> -
> -	/*
> -	 * On inflation success, we already took a reference for the @newpage.
> -	 * If we succeed just insert it to the list and update the statistics
> -	 * under the lock.
> -	 */
> -	if (status == VMW_BALLOON_SUCCESS) {
> -		balloon_page_insert(&b->b_dev_info, newpage);
> -		__count_vm_event(BALLOON_MIGRATE);
> -	} else {
> -		__count_vm_event(BALLOON_DEFLATE);
> +		ret = -ENOENT;
>  	}
> -
> -	/*
> -	 * We deflated successfully, so regardless to the inflation success, we
> -	 * need to reduce the number of isolated_pages.
> -	 */
> -	b->b_dev_info.isolated_pages--;
> -	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> -
>  out_unlock:
>  	up_read(&b->conf_sem);
>  	return ret;
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1b93d8c643612..8969271581bca 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -827,7 +827,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  {
>  	struct virtio_balloon *vb = container_of(vb_dev_info,
>  			struct virtio_balloon, vb_dev_info);
> -	unsigned long flags;
>  
>  	/*
>  	 * In order to avoid lock contention while migrating pages concurrently
> @@ -840,8 +839,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	if (!mutex_trylock(&vb->balloon_lock))
>  		return -EAGAIN;
>  
> -	get_page(newpage); /* balloon reference */
> -
>  	/*
>  	  * When we migrate a page to a different zone and adjusted the
>  	  * managed page count when inflating, we have to fixup the count of
> @@ -854,11 +851,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	}
>  
>  	/* balloon's page migration 1st step  -- inflate "newpage" */
> -	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
> -	balloon_page_insert(vb_dev_info, newpage);
> -	vb_dev_info->isolated_pages--;
> -	__count_vm_event(BALLOON_MIGRATE);
> -	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
>  	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
>  	set_page_pfns(vb, vb->pfns, newpage);
>  	tell_host(vb, vb->inflate_vq);
> @@ -869,10 +861,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	tell_host(vb, vb->deflate_vq);
>  
>  	mutex_unlock(&vb->balloon_lock);
> -
> -	balloon_page_finalize(page);
> -	put_page(page); /* balloon reference */
> -
>  	return 0;
>  }
>  #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 03c5dbabb1565..5444c61bb9e76 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -232,20 +232,49 @@ static void balloon_page_putback(struct page *page)
>  	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
>  }
>  
> -/* move_to_new_page() counterpart for a ballooned page */
>  static int balloon_page_migrate(struct page *newpage, struct page *page,
>  		enum migrate_mode mode)
>  {
> -	struct balloon_dev_info *balloon = balloon_page_device(page);
> +	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
> +	unsigned long flags;
> +	int rc;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
>  
>  	/* Isolated balloon pages cannot get deflated. */
> -	if (WARN_ON_ONCE(!balloon))
> +	if (WARN_ON_ONCE(!b_dev_info))
>  		return -EAGAIN;
>  
> -	return balloon->migratepage(balloon, newpage, page, mode);
> +	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
> +	switch (rc) {
> +	case 0:
> +		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +
> +		/* Insert the new page into the balloon list. */
> +		get_page(newpage);
> +
> +		balloon_page_insert(b_dev_info, newpage);
> +		__count_vm_event(BALLOON_MIGRATE);
> +		break;
> +	case -ENOENT:
> +		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +
> +		/* Old page was deflated but new page not inflated. */
> +		__count_vm_event(BALLOON_DEFLATE);
> +		break;
> +	default:
> +		return rc;
> +	}
> +
> +	b_dev_info->isolated_pages--;
> +	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +
> +	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
> +	balloon_page_finalize(page);
> +	put_page(page);
> +
> +	return 0;
>  }
>  
>  const struct movable_operations balloon_mops = {
> -- 
> 2.51.0


