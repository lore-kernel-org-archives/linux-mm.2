Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF19ED2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 06:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E7C6B036F; Tue, 20 Jan 2026 01:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126A06B0370; Tue, 20 Jan 2026 01:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028506B0371; Tue, 20 Jan 2026 01:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E37BD6B036F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:43:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9022D8B8CF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:43:26 +0000 (UTC)
X-FDA: 84351400812.26.FD1A761
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D219D140002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:43:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk4HkZgj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768891404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6if+LcGjNYtJ4hNc0emoNvyfA7JdNu83+Hmj3PNywc=;
	b=wQjHKRVc0Ij5pxz+NA+SDVjYk7u7dWlK3b//BK8GnoF6LZ2Rz5Gtk1uPOaYJUsC4MDbrG0
	B/c8PKBqU0J1iV3EdIXUEP0byoK7vQWU0YKlp+5X4PXv62ZnD2WkfH8VCzpTOSokq8RFIG
	25h6nQuLKUKiirfsjFEtyA4qLRrRAUI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk4HkZgj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768891404; a=rsa-sha256;
	cv=none;
	b=lMlnlWc916biAqaRGqwdg02k1RX0xJoaxfglVpTvc/qJmdUCyj5dNEpRRue7Pb4f1Nh673
	jy8uYM8d60pBhcAHMQnvqkLdZEGwi4fw/6ftXCtboBjqeeAoqSciyuV/J2QWp0MReNRKDs
	rFssUCIeJzjH5G8dmWyH209A07S7y2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00D1C60008;
	Tue, 20 Jan 2026 06:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB0C19424;
	Tue, 20 Jan 2026 06:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768891403;
	bh=Q6DZgPGZjNX1B9EVQMzmA20g4dsscqih90PlrSVuaYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nk4HkZgjrYVS+vhm53rXMdVIPfF/97GazOLwF6yiaxf1o4KqZQTLLVJF7anBpTgW8
	 IX0EjbkwPDONkljjeuUrH9DeRlecTWkuglPX0u1Ksldi8dlywyFAqrWEOJAgw8A94X
	 kK/W1bCa86MHEZezshHbLp3czwvGHHJqlgh52Xk3zzFP7kbzfgV2iUMd27UjsI/g14
	 5tO71nd1Kj4c7PJV1rc1n/+2BoaBm+PLjAsgpfqS5J5UhhoaXoZ70Bxi55xoleKVLd
	 YIOPFXksCOdxkz0/lg9MkziwkVfBoxdaLQ71BWcCKWCekvgvd+N/fTwo9KM5nbV2Le
	 VQ/XM0a6NfcFw==
Message-ID: <27f0adf1-54c1-4d99-8b7f-fd45574e7f41@kernel.org>
Date: Tue, 20 Jan 2026 07:43:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/24] mm/balloon_compaction: move internal helpers to
 balloon_compaction.c
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260119230133.3551867-1-david@kernel.org>
 <20260119230133.3551867-16-david@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260119230133.3551867-16-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 78esg9w6kw5kjqfbzp4rsscyjncbp917
X-Rspamd-Queue-Id: D219D140002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768891404-212988
X-HE-Meta: U2FsdGVkX1/yChlN25YO6tWjuR+hJThaFRD8e/f10LSqFYPQGC4U2Iv08aim/508FVW6EEqiNWIUAYEU8VGAaz3Cyltt8buwTJUuYZ60SuadbIq+mTElDvRijeU7KDG5A68OjzweNV2lv0aegjb5TwZvgizkNY2aaqk19WlcszoMthrkqt1fgyIlBDeHFi+Qk2lO7fFylYqDkS5uEC+n7GAs9Xqh5m23U0q6Z0HuS4Cw3jPv7tWBzi8b/+ohucKXuYDoxwYN3/FAeIO0rqaxzCSjsghMGa8UpUokFi2WASZmwelL2xFOmcqpQTCf0vNj11psfcI3cAxWNMcesq8YJ4q9MB73TsNu7qC4onIHm1IXH0c/2VRog1oRcrn7eR6O8U3cMbDTmUN9qqWO9EvvG4Xgt+Bizd6tcfTxiyjg0UY/hRibf2mUrj9dOToisP5K5iF/jkt0Obib5rEwyx3wPSyQh6cfFey4IBakmcVZZx7ipkSyq5LMSzIq/f4vhGLWOtILN0yEe13LcwaAGyGd1naSa9yzUnH6Rr1olaedUXe0Lge8tfpj+qu9DOCfvs6bU8WMtEFtd7wVl6XGkNYgow3xjh/NQZQNbvW7Nv1f9tZdyIGg5OI3ytVh7+nQuDm3991t9+bKiaEbuqRiDzcbrLsd5ipp/QB84Vr8GeJSC6PmryouTvZWWSsZWpIuDThuwesKgNvdyxnsuMQ8CalpNJd9c2aO0RAicv8UjO5fajTdEYeNY2fKw5nj20ZCf9gcyAkD8fi101x1SHUp0VLweCSBAxgh1mRdNOjt1p13Y+T2pQT1upEK2MpBPlX4FhQCLU1ktnNjSX/4Nlw+6rfu8Hc6Bh8r3Y7ODdipn4Lmd/J4fNahmmAQO8QN8jsiRXOXxYp7mW+Zl99qLpqMkOQpQyq4sqqDf1WAj2Ndv+h/XFo4vEXU4OOYd5usdBFSkj2n7laiKKe70Qh5Qyj8zos
 GLXSkMZ6
 Ppt8P1rwEBwXeLq5MuZC/5oVyVVGT48GBRWprrb1wewiz6QB9JK1VadW22yescYj9Cl+w760zQsn8y44dF0Nl2xePx1Ev5ARseu9pxyCAncCjGfovRz1Fr4s44+lFgzRE6hGVupYHIgtY8weKpfoNwuDwFFEmHMM0DFIIk+NefZQkLwOn6goDngp9TZ39H0YTDrPkkhcuEXb6inIs9ikY0pSLVOV6ToD9yXmBr78MHT5yRkX82j8qnN5TvfcSVHNSG4mwsfG5sf4NhpyCqpswrF31bkrwq0TRrNTmzsybQWRYQajDAENsRQ63pwh0ysSBe0BPeZefsJ5TxIpi9bcseT5J3MdzxV4R2ovEPNJXZ2Ofw96bJq5Sys2dqR21SmO0VhTa/KOSb16jK45neGGgugXP4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 00:01, David Hildenbrand (Red Hat) wrote:
> Let's move the helpers that are not required by drivers anymore.
> 
> While at it, drop the doc of balloon_page_device() as it is trivial.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   include/linux/balloon_compaction.h | 44 ------------------------------
>   mm/balloon_compaction.c            | 38 ++++++++++++++++++++++++++
>   2 files changed, 38 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index d1d4739398978..eec8994056a44 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -75,48 +75,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>   	balloon->migratepage = NULL;
>   	balloon->adjust_managed_page_count = false;
>   }
> -
> -#ifdef CONFIG_BALLOON_COMPACTION
> -/*
> - * balloon_page_device - get the b_dev_info descriptor for the balloon device
> - *			 that enqueues the given page.
> - */
> -static inline struct balloon_dev_info *balloon_page_device(struct page *page)
> -{
> -	return (struct balloon_dev_info *)page_private(page);
> -}
> -#endif /* CONFIG_BALLOON_COMPACTION */
> -
> -/*
> - * balloon_page_insert - insert a page into the balloon's page list and make
> - *			 the page->private assignment accordingly.
> - * @balloon : pointer to balloon device
> - * @page    : page to be assigned as a 'balloon page'
> - *
> - * Caller must ensure the balloon_pages_lock is held.
> - */
> -static inline void balloon_page_insert(struct balloon_dev_info *balloon,
> -				       struct page *page)
> -{
> -	__SetPageOffline(page);
> -	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
> -		SetPageMovableOps(page);
> -		set_page_private(page, (unsigned long)balloon);
> -	}
> -	list_add(&page->lru, &balloon->pages);
> -}
> -
> -/*
> - * balloon_page_finalize - prepare a balloon page that was removed from the
> - *			   balloon list for release to the page allocator
> - * @page: page to be released to the page allocator
> - *
> - * Caller must ensure the balloon_pages_lock is held.
> - */
> -static inline void balloon_page_finalize(struct page *page)
> -{
> -	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
> -		set_page_private(page, 0);
> -	/* PageOffline is sticky until the page is freed to the buddy. */
> -}
>   #endif /* _LINUX_BALLOON_COMPACTION_H */
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 1843e168db3ca..e0a4b481c3eda 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -17,6 +17,44 @@
>    */
>   static DEFINE_SPINLOCK(balloon_pages_lock);
>   
> +static struct balloon_dev_info *balloon_page_device(struct page *page)
> +{
> +	return (struct balloon_dev_info *)page_private(page);
> +}
> +
> +/*
> + * balloon_page_insert - insert a page into the balloon's page list and make
> + *			 the page->private assignment accordingly.
> + * @balloon : pointer to balloon device
> + * @page    : page to be assigned as a 'balloon page'
> + *
> + * Caller must ensure the balloon_pages_lock is held.
> + */
> +static void balloon_page_insert(struct balloon_dev_info *balloon,
> +				       struct page *page)
> +{
> +	__SetPageOffline(page);
> +	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
> +		SetPageMovableOps(page);
> +		set_page_private(page, (unsigned long)balloon);
> +	}
> +	list_add(&page->lru, &balloon->pages);
> +}
> +
> +/*
> + * balloon_page_finalize - prepare a balloon page that was removed from the
> + *			   balloon list for release to the page allocator
> + * @page: page to be released to the page allocator
> + *
> + * Caller must ensure the balloon_pages_lock is held.
> + */
> +static void balloon_page_finalize(struct page *page)
> +{
> +	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
> +		set_page_private(page, 0);
> +	/* PageOffline is sticky until the page is freed to the buddy. */
> +}
> +
>   static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
>   				     struct page *page)
>   {

The following on top to silence [1]. Results in two contextual conflicts
in later patches which is easy to resolve. As an alternative, we could throw in a
__maybe_unused but this is cleaner.

[1] https://lkml.kernel.org/r/202601201338.4muFmFHV-lkp@intel.com


 From a02a0de0670a6be9a34d06eea3ba41297ce547dc Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Tue, 20 Jan 2026 07:37:39 +0100
Subject: [PATCH] fixup: mm/balloon_compaction: move internal helpers to
  balloon_compaction.c

Move balloon_page_device() under CONFIG_BALLOON_COMPACTION.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601201338.4muFmFHV-lkp@intel.com/
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
  mm/balloon_compaction.c | 9 ++++-----
  1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index e0a4b481c3eda..30fa7ee8e1f3a 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -17,11 +17,6 @@
   */
  static DEFINE_SPINLOCK(balloon_pages_lock);
  
-static struct balloon_dev_info *balloon_page_device(struct page *page)
-{
-	return (struct balloon_dev_info *)page_private(page);
-}
-
  /*
   * balloon_page_insert - insert a page into the balloon's page list and make
   *			 the page->private assignment accordingly.
@@ -232,6 +227,10 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
  EXPORT_SYMBOL_GPL(balloon_page_dequeue);
  
  #ifdef CONFIG_BALLOON_COMPACTION
+static struct balloon_dev_info *balloon_page_device(struct page *page)
+{
+	return (struct balloon_dev_info *)page_private(page);
+}
  
  static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
  
-- 
2.52.0


-- 
Cheers

David

