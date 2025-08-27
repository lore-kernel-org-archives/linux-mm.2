Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 483ABCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C796B014E; Tue, 26 Aug 2025 23:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD388E0105; Tue, 26 Aug 2025 23:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB7F6B0150; Tue, 26 Aug 2025 23:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6594A6B014E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:47:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8CBD1A0415
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:47:50 +0000 (UTC)
X-FDA: 83821153500.30.EF86AB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C761B80005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:47:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MKOL/kSC";
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756266469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85DwLbI+KR6uSTruQj/cMscoyRTlGN0VbkyP4eDNcbU=;
	b=B2KAatiZ3qTfp/npure/1qh5dw2f8hVFVqv6Ek9Ij7bd/4OlO90UgBtsPuO/rg36zAYv4k
	ngzvkNmMz9nFmzug3F1CZSBvhDXtDCKtz4Y97MkxYPzQW2y4bmJ2RAwl0PQ2bhFcKnAxo4
	sB23QLH5e4xS7BImTE9MP7ZocbILxLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756266469; a=rsa-sha256;
	cv=none;
	b=SuKTHRrUEbL8U9PgllZZ4m9Dkvu4sif6gJcqZv1VuDThYbUouQzF5N/uHe/vonWANeP2+t
	Wu4Kjun+OE4gNIFxYerQgoDwTx0TyhrhL41gbAF/R+WaVDAm3SIJeg1u7QsXUA7Cz42JiY
	tDPkZvVZOm9CeB8j4LBa6iB7RzN+wHo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MKOL/kSC";
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756266468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=85DwLbI+KR6uSTruQj/cMscoyRTlGN0VbkyP4eDNcbU=;
	b=MKOL/kSC8cLNRYQG0NV112vk9qVRZ8bmRWbTtowS4MPaikWOV9I5haTOpt1wvYhoWKJaJ1
	Qq8oGUf2EUjVgw4uWZ+faLqLODVbPa7DNw9scRDWve6aLVsLuSA5774FJ6SDi0MeSH+oe2
	dDbztjF41b7SeUpy9hwZBc/O3HYLO3E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-210-0IbwmORUNnmdlMb_tLuFXg-1; Tue,
 26 Aug 2025 23:47:44 -0400
X-MC-Unique: 0IbwmORUNnmdlMb_tLuFXg-1
X-Mimecast-MFC-AGG-ID: 0IbwmORUNnmdlMb_tLuFXg_1756266462
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6A331956095;
	Wed, 27 Aug 2025 03:47:41 +0000 (UTC)
Received: from localhost (unknown [10.72.112.154])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FED31955F24;
	Wed, 27 Aug 2025 03:47:38 +0000 (UTC)
Date: Wed, 27 Aug 2025 11:47:34 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info
 helpers
Message-ID: <aK5/1so7a0i80+dz@MiWiFi-R3L-srv>
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-5-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822192023.13477-5-ryncsn@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C761B80005
X-Stat-Signature: uu8ofzetjwc1smkyd6iqp4h1w3xca3mr
X-HE-Tag: 1756266468-197846
X-HE-Meta: U2FsdGVkX19i8h/BSDl4JVJ5NB8ejxvXmzKCPdiei2KNxT0nbI//stR7mIABY+5YBJIZgXkaxDTc79QM4msAJXL9rt57gBy4oWAZoaQ6fN2paoJGRv7FzX7+LqnD524O6yOprl9c/Wn8msJ1P2g23nDMled9rPfIuhFQ4J/Cle1FNyFnHaD8J2S74PKjwINy2dtVzzX4aqTYK2lVSd9kpmOZCL9uXGyeH1yPkMJobNVnpiqtFB8z7beK02wvvYUVgtuTwG6jIk3ddx7hJrDnCpO3bp7NZv0WnKiisJkgCy1gP8sCWXNs8hnp7t8iGCaB2TYrlncK2NPcK0FfEc7n3eDWw14C+BRFl/k9dt1XWDxXXMDkS/tEoUKgIN7rcBKg7zMlSfrGATDQUHRNWoeTdxlg0Tw6QyJoLjRr83Dj+OLVljiL45RfCGkJqX3kQMbdiU9gcx+912gVRkBxR0nhPjdFpwPARfOP6OEqv70YO4sGJbGHhQ1DSNDSd07obLvYMZBcSuUiOy0UX3dgZFKAI3IW86sfeqgEGTSbnGi6zHx8SxhaRRTyai6rofEqDeDLfUxD4jVq7eCD1pbwR/7uw44dwuNvpOeUAu/RJ1MIzXqM014vgUuvRaJe6xkZXJCbMzZXyv1slYIm7c2uzi7kDEa464YpHZLpb2fNlL84Kd0GsWJKoDm4NDSxrJHSeU0TcWkzfCAy3nONZ/9Qe7a/hoxS7I1KKEzZtp6cMmHjJ6g4NASnt5VyuK77Y71O/djOkv9C1SrVNc6JLQeDoImoJfK4Oew4uldS3XehEIkRAa82tr5GrWSNZWXBuKc2I3+gvZAg0yopBjXH0MmCTAnmIFuMBBI5Jqz315GokK8rqMgRcjQ00OLEJo56MDQs0mp4rArhvfsEvraP6yf07neEcpCk+MV94f1sj5an2ry5/23JZG3IJDH2Z6DYxS+Zc0DYrJ2FmxMOC0t1nGNBM/l
 zQxPAyow
 ddyUxGA++2Dis+Cssnnke0zSnbiJpFjbi+Cf4OalwSluuXszHYb1EPfCyjLjTJKhPE1Px5wc0eAdJ+bqBolAk+lo+3Pe+WnlhxQPkWbkUaimOuu50Rt7ENXy2Sqn+P27qwrJrAywUYPqQ4mJp/np9BmfWHCHX220fkOiNOQh5FYpYjhNOQ6p0zenbYVvk92xEEW6APOJZjQ7ARcM8AvsckiXIokXUAD+6AxHCV/XC/1UPEqbEPebYVCE6xDQ5KMT9D9kIjRqetgmbB/T1GFtAal7zSNaM5P80808jBZsjLOJg4RoWxvhnwQKY25hVD2VMCmxiZJF/rpFA5Mqa8JJDFx+JW9NvA+ZT2H8snYG/Bdni7YOInp4AoicGlfEAwdfa0IAp1E81dWc7RBsOZUk9GqL9Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/23/25 at 03:20am, Kairui Song wrote:
......
> diff --git a/mm/swap.h b/mm/swap.h
> index 223b40f2d37e..7b3efaa51624 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -15,6 +15,8 @@ extern int page_cluster;
>  #define swap_entry_order(order)	0
>  #endif
>  
> +extern struct swap_info_struct *swap_info[];
> +
>  /*
>   * We use this to track usage of a cluster. A cluster is a block of swap disk
>   * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
> @@ -53,9 +55,28 @@ enum swap_cluster_flags {
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>  
> +/*
> + * Callers of all swp_* helpers here must ensure the entry is valid, and
> + * pin the swap device by reference or in other ways.
> + */
> +static inline struct swap_info_struct *swp_type_info(int type)
> +{
> +	struct swap_info_struct *si;
> +
> +	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
> +	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
> +	return si;
> +}
> +
> +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> +{
> +	return swp_type_info(swp_type(entry));
> +}

swp_type_info() is only used by swp_info() in the whole series, can we
open code it in swp_info()?

If you plan to use it in later phase of swap table patchset, then please
ignore this.

> +
>  static inline struct swap_cluster_info *swp_offset_cluster(
>  		struct swap_info_struct *si, pgoff_t offset)
>  {
> +	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
>  	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>  }
>  
> @@ -65,6 +86,7 @@ static inline struct swap_cluster_info *swap_cluster_lock(
>  {
>  	struct swap_cluster_info *ci = swp_offset_cluster(si, offset);
>  
> +	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
>  	spin_lock(&ci->lock);
>  	return ci;
>  }
> @@ -164,7 +186,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>  
>  static inline unsigned int folio_swap_flags(struct folio *folio)
>  {
> -	return swp_swap_info(folio->swap)->flags;
> +	return swp_info(folio->swap)->flags;
>  }
>  
>  /*
> @@ -175,7 +197,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>  static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
>  		bool *is_zeromap)
>  {
> -	struct swap_info_struct *sis = swp_swap_info(entry);
> +	struct swap_info_struct *sis = swp_info(entry);
>  	unsigned long start = swp_offset(entry);
>  	unsigned long end = start + max_nr;
>  	bool first_bit;
> @@ -194,7 +216,7 @@ static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
>  
>  static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  {
> -	struct swap_info_struct *si = swp_swap_info(entry);
> +	struct swap_info_struct *si = swp_info(entry);
>  	pgoff_t offset = swp_offset(entry);
>  	int i;
>  
> @@ -213,6 +235,11 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> +{
> +	return NULL;
> +}
> +
>  static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>  }
......


