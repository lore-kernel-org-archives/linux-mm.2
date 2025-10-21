Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B75CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CFE8E000C; Tue, 21 Oct 2025 16:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDE58E0002; Tue, 21 Oct 2025 16:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC6B8E000C; Tue, 21 Oct 2025 16:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9F7F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:52:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 649931A05C1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:52:45 +0000 (UTC)
X-FDA: 84023320290.11.9BE9541
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2FEF21C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:52:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fbOumFyp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761079963; a=rsa-sha256;
	cv=none;
	b=i9M6ArazCO3URIV02+SGVrRXE6SuAZjxAC6cNsXXY/hFIRopCpflADQE5BTsMMFrJjRE4G
	QYLsx3mb559wnolnC92wcGK1UGlevzkE467RkdxxOrkaeTKYC4U4TO2rN2acX3bnNdABAs
	OhiBePcNsYHPicXHil/scrOjwI7NEg4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fbOumFyp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761079963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70t8xOtesG4UTGBU4t4Siqy1bvWmQnoR0HwnhGPw72o=;
	b=38MmnWxfWZVSVGffEYxatOA1b401sdCzUqciRtGelSUZQiZj5Iyl4XXMHP6k2ZWN7vReMl
	cFgzQXzJwqBZh2jPBY/fIS3uKQby4yHDgjXyi6gMGSqpIQid90IikzDm/hXDhiEkfrRqvU
	Oac6jtBmqN6xW7XbZPsELuYarixlqxU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761079962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=70t8xOtesG4UTGBU4t4Siqy1bvWmQnoR0HwnhGPw72o=;
	b=fbOumFyplyNGsYR67Z1hfdM9MU0Ejd2PVCmfd056C+OzGYF2tY6xpasG5aqKuCw+FJ0NXY
	oDysBiJ0xh+Dsp5+sAsRzhMO+K3jwmSA4VSkJTioh8kT2eOxfWAPxr++FjVCJ3WgyuPjWS
	C64pMuyu1XKpNSfxQQOZ9FK3yCwT5jo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-1K3cyyXtPUO1v6QFvVNILg-1; Tue, 21 Oct 2025 16:52:41 -0400
X-MC-Unique: 1K3cyyXtPUO1v6QFvVNILg-1
X-Mimecast-MFC-AGG-ID: 1K3cyyXtPUO1v6QFvVNILg_1761079960
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47114d373d5so56931785e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761079960; x=1761684760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70t8xOtesG4UTGBU4t4Siqy1bvWmQnoR0HwnhGPw72o=;
        b=ZZAsjtkfR82T9foIKmB8hlSFeJvY846SRCsOAWktStWXftUmPZION/sq5aLXH08YXn
         FcnBy+DEEkx33JlJcFucdW+HCOgNzo7KUQoeaFJUITRlgue+dtUzrjbQsyJRGB+t1JYC
         KsrcKbcCmRcU7mZddZumB9fjncxZFSiCPVqDTIVhTRYz2CfEpJ0Sc2k4AjH9TXhTGZBH
         py507xcXmNLIW6IvqMQQRZuuPBwzJXHhTjR+xbO4VYisBT/pVkX3yuRbp7UVK4OtZXiB
         4CXeDqI/eXsiNxRaLUMV82pbi9nUySDaOtz/NVX3qMxIiRs4i5FUsxNbatYCZItEY/PK
         glMg==
X-Forwarded-Encrypted: i=1; AJvYcCV618AnHyhTP/8V48h2oiJXOWuomGfJLVYZX9ac7rtXPhDVTkmar49wtdPGfksSXscaKvXqQEdO9w==@kvack.org
X-Gm-Message-State: AOJu0Yyti3YsAFIjwyN5zzDukYcGbditmD1CcZv1Q6aqU8JY68gNZCgA
	61mA/a+C4BPOtuxJOUGcq3g9RBAtt1xuW7peIuuzEoefX35H+dpiKkA35UrH5HV9Ro8Ir3cc+se
	uRSuGIjrQFqCSSZVlIUDgxspTkJ/q0K4J1OmTB7wwbCpNfGrAMOTK
X-Gm-Gg: ASbGncvDK0m7KyCNdA6gJSOWDop1Ss11OYFPRuxsxgZJV7C68CofD963nTyXHFNPX69
	CYxYMAklbwjZXGFvotRwGDGFFRVRp3ciuNkdzs74io/AuEGIGcc1pP0VJvE0szIzZxc6Jf7IsI9
	T5iwvulaM/bcHznENJU9RB3ww2W/MAsZ8THtkjnmX2q2xt0VbHLtUv/bFYRApbl2nT3AAA+IViv
	c1xYWNyYaEL5dVAf11RxpVybrlyQBQqz3prt9F77jNvXOKnuC2MgkRzyI8fr2245KzpFrzocuks
	5NNZNJ5Q+/1Tajgl4zgq4Ge/V3b+wy5ShF/XVRIMobSgk8XWqulOgx12RzcKShf1b5BR
X-Received: by 2002:a05:600c:4ec9:b0:46e:2562:e7b8 with SMTP id 5b1f17b1804b1-471179123admr133168835e9.21.1761079960029;
        Tue, 21 Oct 2025 13:52:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzW0J+zMAHmrBKy98NPR2F9AVZqblG/q03JHaUVQ2fhOgcretSouuM7HYbCnzUNTNzgIF2SQ==
X-Received: by 2002:a05:600c:4ec9:b0:46e:2562:e7b8 with SMTP id 5b1f17b1804b1-471179123admr133168635e9.21.1761079959412;
        Tue, 21 Oct 2025 13:52:39 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce678sm22293933f8f.51.2025.10.21.13.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 13:52:38 -0700 (PDT)
Date: Tue, 21 Oct 2025 16:52:33 -0400
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
Subject: Re: [PATCH v1 07/23] mm/balloon_compaction: use a device-independent
 balloon (list) lock
Message-ID: <20251021165040-mutt-send-email-mst@kernel.org>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-8-david@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251021125929.377194-8-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hlTuKVw86nTFIUNCJT92D6IUxDJYuDdCIFCNj-b3__I_1761079960
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 8699psfb66ota85iq3oe31ppi14cxuai
X-Rspamd-Queue-Id: 2FEF21C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761079963-605751
X-HE-Meta: U2FsdGVkX1+cwSUUo+wGBJdrG+d3MYiZlBOM716U6dcZPa0teus1viFCpI/CcHUuqEQzv1RiPn5/BrxStFMg4Vi+oKhZnetRQiZEVnE8tUfbdDzFsnJFSmcGJzBhL1BT8WPEms3M7CGAArrFXnZE78xVVriK7JuAs/9uJcZgjVnnKr78TY9agjEbbs5PCPHDjgetCd9yGjzggGn0uiFtMLWbrTDBsFk7L28TmDYuJ/bSsozf6TNYT7ARm1ciJb7iYgIQLuMJQxK17URjZfdj5T77Yag1vY1xfmyhG3JyDw5WI/A3uHCS42PE/LEB2FQUN/D6Py7kvF0wGTgwisTr4dKppv6vGueXTmRDi1qWSCTftZuEYM4PrmhefbvJHPZMDY7ZuCSinrqU05bbk6zQLDsN89cDmJP1kYZ8ZjfU+FW7VYrfWt4YeMNZHBSjBAwl+r9QQ1edz9jQFdhlQqYd0/usCUlI9OePAaXPOVjpWiLkISLtt+yxBPeIUIJX0u3Ap5Mff7ocebllhyAZsXbthR6fuNxr1QH+7Qw0MqIXpJhGyKJtcC/ed8bbw8gpzU45Dbv75XALkz2MpAip77vbLGaujjdxqXsyCpmO4GLWyGGUF1d0OioXznSz1BtmaurZtmA5h+fMkXUlPXhaM4suF7vtYPRfa2tPLUFMLhuYfxT7preIxRFqraCnkvNVOnvDuzoX2RnFMtNm+F6rL3wKA9SkD+CVbqUxwD2DD1qoxzCCGvsbtyGclJELH10aRtz30gi9U4kzfQebWjGRb10ecC1oXkl8psKi/+NXN6fmI7AGQ9aMzhNDKwPMwX19U2VYDYok4EvDh4A6q+U897Cy5NRRqKGmujxBQfTrKl4CkPZ2k8XmkSCJCYRT3H/M7ruJaXdAGaDWatCUVAq1JEtEs2FIwT0mUPR4iM5Xeq7gja6mdu03wuZbZEFBJ8NTgGt2T65a7pGdAgMkFO9jkVG
 wFRQdQr3
 dy6HuBAVctZ+LoP0wFuiHAay7sDLEN1zF9us1W/3EYpRhpWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:59:12PM +0200, David Hildenbrand wrote:
> In order to remove the dependency on the page lock for balloon
> pages, we need a lock that is independent of the page.
> 
> It's crucial that we can handle the scenario where balloon deflation
> (clearing page->private) can race with page isolation (using
> page->private to obtain the balloon_dev_info where the lock currently
> resides).
> 
> The current lock in balloon_dev_info is therefore not suitable.
> 
> Fortunately, we never really have more than a single balloon device
> per VM, so we can just keep it simple and use a static lock to protect
> all balloon devices.
> 
> Based on this change we will remove the dependency on the page lock
> next.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/balloon_compaction.h |  6 ++---
>  mm/balloon_compaction.c            | 36 +++++++++++++++++-------------
>  2 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 3109d3c43d306..e2d9eb40e1fbb 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -21,10 +21,10 @@
>   *   i. Setting the PG_movable_ops flag and page->private with the following
>   *	lock order
>   *	    +-page_lock(page);
> - *	      +--spin_lock_irq(&b_dev_info->pages_lock);
> + *	      +--spin_lock_irq(&balloon_pages_lock);
>   *
>   *  ii. isolation or dequeueing procedure must remove the page from balloon
> - *      device page list under b_dev_info->pages_lock.
> + *      device page list under &balloon_pages_lock

Using &balloon_pages_lock with an & is kinda weird here.


>   *
>   * The functions provided by this interface are placed to help on coping with
>   * the aforementioned balloon page corner case, as well as to ensure the simple
> @@ -52,7 +52,6 @@
>   */
>  struct balloon_dev_info {
>  	unsigned long isolated_pages;	/* # of isolated pages for migration */
> -	spinlock_t pages_lock;		/* Protection to pages list */
>  	struct list_head pages;		/* Pages enqueued & handled to Host */
>  	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
>  			struct page *page, enum migrate_mode mode);
> @@ -71,7 +70,6 @@ extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
>  static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>  {
>  	balloon->isolated_pages = 0;
> -	spin_lock_init(&balloon->pages_lock);
>  	INIT_LIST_HEAD(&balloon->pages);
>  	balloon->migratepage = NULL;
>  	balloon->adjust_managed_page_count = false;
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index fd9ec47cf4670..97e838795354d 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -11,6 +11,12 @@
>  #include <linux/export.h>
>  #include <linux/balloon_compaction.h>
>  
> +/*
> + * Lock protecting the balloon_dev_info of all devices. We don't really
> + * expect more than one device.
> + */
> +static DEFINE_SPINLOCK(balloon_pages_lock);
> +
>  static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
>  				     struct page *page)
>  {
> @@ -47,13 +53,13 @@ size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
>  	unsigned long flags;
>  	size_t n_pages = 0;
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	list_for_each_entry_safe(page, tmp, pages, lru) {
>  		list_del(&page->lru);
>  		balloon_page_enqueue_one(b_dev_info, page);
>  		n_pages++;
>  	}
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  	return n_pages;
>  }
>  EXPORT_SYMBOL_GPL(balloon_page_list_enqueue);
> @@ -83,7 +89,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
>  	unsigned long flags;
>  	size_t n_pages = 0;
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
>  		if (n_pages == n_req_pages)
>  			break;
> @@ -106,7 +112,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
>  		dec_node_page_state(page, NR_BALLOON_PAGES);
>  		n_pages++;
>  	}
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  
>  	return n_pages;
>  }
> @@ -149,9 +155,9 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	balloon_page_enqueue_one(b_dev_info, page);
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(balloon_page_enqueue);
>  
> @@ -191,11 +197,11 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
>  		 * BUG() here, otherwise the balloon driver may get stuck in
>  		 * an infinite loop while attempting to release all its pages.
>  		 */
> -		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +		spin_lock_irqsave(&balloon_pages_lock, flags);
>  		if (unlikely(list_empty(&b_dev_info->pages) &&
>  			     !b_dev_info->isolated_pages))
>  			BUG();
> -		spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +		spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  		return NULL;
>  	}
>  	return list_first_entry(&pages, struct page, lru);
> @@ -213,10 +219,10 @@ static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
>  	if (!b_dev_info)
>  		return false;
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	list_del(&page->lru);
>  	b_dev_info->isolated_pages++;
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  
>  	return true;
>  }
> @@ -230,10 +236,10 @@ static void balloon_page_putback(struct page *page)
>  	if (WARN_ON_ONCE(!b_dev_info))
>  		return;
>  
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +	spin_lock_irqsave(&balloon_pages_lock, flags);
>  	list_add(&page->lru, &b_dev_info->pages);
>  	b_dev_info->isolated_pages--;
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  }
>  
>  static int balloon_page_migrate(struct page *newpage, struct page *page,
> @@ -253,7 +259,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>  	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
>  	switch (rc) {
>  	case 0:
> -		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +		spin_lock_irqsave(&balloon_pages_lock, flags);
>  
>  		/* Insert the new page into the balloon list. */
>  		get_page(newpage);
> @@ -272,7 +278,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>  		}
>  		break;
>  	case -ENOENT:
> -		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +		spin_lock_irqsave(&balloon_pages_lock, flags);
>  
>  		/* Old page was deflated but new page not inflated. */
>  		__count_vm_event(BALLOON_DEFLATE);
> @@ -285,7 +291,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>  	}
>  
>  	b_dev_info->isolated_pages--;
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  
>  	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
>  	balloon_page_finalize(page);
> -- 
> 2.51.0


