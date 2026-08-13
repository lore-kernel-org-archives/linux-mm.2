Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 341EAC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465F96B0269; Thu, 13 Aug 2026 06:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43ED66B0276; Thu, 13 Aug 2026 06:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354B66B028A; Thu, 13 Aug 2026 06:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 078EE6B0269
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:55:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91C87140582
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:55:59 +0000 (UTC)
X-FDA: 85095941238.25.56C5991
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 38DB7160006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:55:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZoiC5Odd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bb5BgboJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wRcuQgd1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8sRnAnOq;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618557;
	b=DeDJGJ0DSPAfu8NJSh1S8bM7GObmBmChZgeQyzZi0Vdagoe8aPkNK9U+0DbLsPw8AZof3A
	F33O+WeYy5P7+XTlSAV7BtNVhz9KnKMXkep1eve9ZuNbCLZoBJnGVTxAt4p0pF1anpOUvb
	nZEs8ShmuKkNlfpg17nV6pONPO/K95E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZoiC5Odd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bb5BgboJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wRcuQgd1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8sRnAnOq;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hbLhs+/j3Cz0sDWAJRAQZic3afitzbliqORlRQmHF4=;
	b=Nuo2gESIpDtMDRqqhG5nqMgbOoMTL0RPCc/TOo7mDG3Ck5VgaHt+3tFjDKLSSjPCi4+6zH
	xArAKmBaDsGCxlW+/5EqzhQffrNB6ANp9e/DzdFonVufis3SW9Zux+CEZw+xfj1mQgvZVz
	WGIxkFPTSV9qDBqqOIT9YJuSBjneHoQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A0F282825;
	Thu, 13 Aug 2026 10:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786618551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hbLhs+/j3Cz0sDWAJRAQZic3afitzbliqORlRQmHF4=;
	b=ZoiC5Odd6uCHh37vb9iQfJIMmkOoSfljVMyUPJ+JMoJcxIeJG8/upf+XNBXOsnO0zDNDBw
	am++F6RTK91PqaiYVT2R+R3zCV3YuOtCGl4jcq0SiUhamJSAgnk3wOh5ehj9wLt1PDNKa4
	+ux3+ytacGPc3v2TtBrgcNPRrVa3vQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786618551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hbLhs+/j3Cz0sDWAJRAQZic3afitzbliqORlRQmHF4=;
	b=bb5BgboJTcGchzO50OJCkEMW/uNbHO1/t/Vp0I6iT/FdE8mMsM0xEe38gB1aHa9fRJA9bU
	QZ/B0eZMOmRGmYCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786618547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hbLhs+/j3Cz0sDWAJRAQZic3afitzbliqORlRQmHF4=;
	b=wRcuQgd1JhDxD0pV4DVCzCVf0xL7o/LQr6qsWamUVfNKLrxtAuTDtuM40ENCE2DTeKFKAW
	MZdtXyJZ/H7MXfCgKOQpZR+j/9gWmYDsRYH1RA9SfZdhYVYXzDgOiuDGQ7r2B/CJ9hnZWA
	jxs3MwzXHoGjeHAHhRxAgRlfLv0yefY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786618547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hbLhs+/j3Cz0sDWAJRAQZic3afitzbliqORlRQmHF4=;
	b=8sRnAnOqPXfT26gjWEZjhzAg7Wb5bD8Hrk2tGG5CdkFWGFKIvtuhI0kxrd6u9hyYaRCaki
	iQNpKeBrR+FTrgBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70EED77DA3;
	Thu, 13 Aug 2026 10:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AMFIGLKifWoNeAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 10:55:46 +0000
Date: Thu, 13 Aug 2026 11:55:44 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 11/15] filemap: Add hwpoison handling to filemap_read()
Message-ID: <an2e1j3C_4DA5KXK@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-12-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-12-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38DB7160006
X-Stat-Signature: bspa5g8a97teapwdsnzzpa8uci5yhura
X-HE-Tag: 1786618557-356472
X-HE-Meta: U2FsdGVkX18ljswZFwG/EzQuKdUKxCjzpyO7me6ydWCbN//9pUyQz9rm01b8bWFdjZZ3+djK3OBoTwbxuS0eLg14ZxgRQyC7wE/zGTj8V9Beo9WFE3H2dp/uQK1KJKu9D2SkQfX2eli6dHfU4q3ZQ/TsiS+ugIQ5HjtvvYp+nXf2jCmbG8qwcSzOlr2lu9qDeCd8qsNHVzXFy0GL3qtYX3D6y/H+B1RDnm3cjvP/kRXfTEF7R/pHONm/8RJ5tFKHZOr9PdtWdEwaqXhXwYtQIMfXqZOvc/ykkXGBHCqSabHSjvdMw3u2/zbEgHcpF+D/lXKlnh5UMGLBC4vTSsNkLj3pgbLrYa18eZ2X5Jmv3Iv1JvreodOkriRw3xkuS3HVFE8+xysLrVCuB+gLzmR3P7+XOvdCM7H6CnYJR5/sBHLFYyeSesP1Mol5ylXkKhxkG+SAtWA+4ggVUqdP7gC1Z939yyjnkJUGVTePCXwpi5U/JQnVPMLqT8N+rDtvx704SDOdCV62fR/GnfrszgxIZLN7l5csQRnszBumm9nIVsgWIhz5wgxuijihUtdXjdFESnnRM4dQ34XyGv2Da/3cEL/Kj8zOwPClJ3TOb6C1Llf6BA4LQB3T9tJEPmERIEAQ/j89JDHYvDLQJEmRchjqkxbFUDre2o3q12yLdDYwLtJ4/Xx1Abm0ibwlppfsu6izNxiZENmaeWkNolLh1IOeFJEclRd3kY7YdR8TwriXii9etc6ufUvHAAuNFtCbUXr78YLMElR/PdV4sZN0ui9FIT72FjW3ua2esXnrfM/t7Y0rzNFntEyWXAocZLN+Ik7LNt6FaNh8yk0J5MKPWtKVsRdBeCw/9/Ragyc2VXgRYI3OB0ZHKS82HRY5Qj2d2ZK8FVJ0rkNnNBcV0LhrattoDvmnXUTeTfWpfeNQ3p4TfM3I6gcPSFzpdVdv8SjHsKYgAmbVKoIo4KEyYkeb917
 L/llkoG+
 ETw/TXloXl0I3cB1E/dsN3FNY/kErzY1dBf/eQRwQ/ArZ0+Px96/g9FzYpdbVN1SSA+/E4wpRwmw0LT2LT+j99oCPdXaTMUA+WdEuzbIO5lNoU6Wq+aNHd4z14H/GDyrN4l5SFD8wec30bXUr4/DgCGwG1bUqtzp1jUfsXL3zTXW5RLvfYGNMmEm7+RfG03gHWwmFsyofHM0/WzWeCjE2SXM14Aj0fv4/pIQ+H7rK2ZxSl4nPPp3eHZQvMB2RBglNvd88mfzJL1h7LtO1dtqw0PPdCcE4IpSDC3rNH0CB9TBcrnDyPJ06Ava5/od758+8Wz2ApYjLUsb3PHETpZpHrZVnZC6bK8MaY8zMcA9L1AYe8lPOI8Ucx2XxhyeFPVQxuUTWuir9bsF09Q27fzrKoBV0oVcFFYXhWYLmvOp5nbdB4g0en2bvdMdOYfvEIdY5HsS2aFqkRKWKzvMVK4LkUTuSkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:51PM +0100, Matthew Wilcox (Oracle) wrote:
> From: Jane Chu <jane.chu@oracle.com>
> 
> Add hwpoison handling to filemap_read() such that .read_iter() could
> make best effort copying data out of clean pages without risking
> MCE in case page cache contains HWpoison.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Co-developed-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> ---
>  include/linux/hugetlb.h    |  2 --
>  include/linux/page-flags.h | 11 +++++++++++
>  mm/filemap.c               | 33 +++++++++++++++++++++++++++++++--
>  3 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index ec604cee8d22..639c0a772856 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1088,8 +1088,6 @@ void hugetlb_register_node(struct node *node);
>  void hugetlb_unregister_node(struct node *node);
>  #endif
>  
> -bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
> -
>  static inline unsigned long huge_page_mask_align(struct file *file)
>  {
>  	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5d01e5b28d0f..f75d66c42509 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1095,6 +1095,7 @@ static inline bool PageHuge(const struct page *page)
>  	return folio_test_hugetlb(page_folio(page));
>  }
>  
> +bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
>  bool hugetlb_unref_page_hwpoison(const struct page *page);
>  
>  /*
> @@ -1116,6 +1117,16 @@ static inline bool is_page_hwpoison(const struct page *page)
>  	return PageHWPoison(page);
>  }
>  
> +static inline bool is_ref_page_hwpoison(const struct folio *folio,
> +		const struct page *page)
> +{
> +	if (PageHWPoison(page))
> +		return true;
> +	if (folio_test_hugetlb(folio))
> +		return hugetlb_page_hwpoison(folio, page);
> +	return false;
> +}
> +
>  static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
>  {
>  	return PageHWPoison(&folio->page) ||
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 58eb9d240643..26a5f18121f9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2483,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  
>  		if (!folio_batch_add(fbatch, folio))
>  			break;
> +		if (folio_has_hwpoisoned_page(folio))
> +			break;
>  		if (!folio_test_uptodate(folio))
>  			break;
>  		if (folio_test_readahead(folio))
> @@ -2749,6 +2751,29 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
>  	return (pos1 >> shift == pos2 >> shift);
>  }
>  
> +static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
> +		size_t bytes)
> +{
> +	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
> +	size_t safe_bytes;
						    offset >> PAGE_SHIFT would probably be more idiomatic
> +
> +	if (!folio_has_hwpoisoned_page(folio))
> +		return bytes;
> +	if (is_ref_page_hwpoison(folio, page))
> +		return 0;
> +
> +	/* Safe to read the remaining bytes in this page. */
> +	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
			similarly, offset_in_page(offset)

(yes, no codegen difference in both cases, but there could be a difference
if the ARM dynamic page size stuff ever moves forward)

> +	page++;
> +
> +	/* Check each remaining page as long as we are not done yet. */
> +	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
> +		if (is_ref_page_hwpoison(folio, page))
> +			break;
> +
> +	return min(safe_bytes, bytes);
> +}

Wouldn't this whole logic fit better in copy_folio_to_iter? shmem for
instance also handrolls its own hwpoison read_iter logic with
per-page-copies, etc; not amazing.

> +
>  static void filemap_end_dropbehind_read(struct folio *folio)
>  {
>  	if (!folio_test_dropbehind(folio))
> @@ -2862,14 +2887,18 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  			if (writably_mapped)
>  				flush_dcache_folio(folio);
>  
> -			copied = copy_folio_to_iter(folio, offset, bytes, iter);
> +			copied = adjust_range_hwpoison(folio, offset, bytes);
> +			if (copied < bytes)
> +				error = -EIO;

I don't love reusing copied here, but I guess there isn't much better
(in order to detect hwpoison-derived truncation)

> +			copied = copy_folio_to_iter(folio, offset, copied, iter);
>  
>  			already_read += copied;
>  			iocb->ki_pos += copied;
>  			last_pos = iocb->ki_pos;
>  
>  			if (copied < bytes) {
> -				error = -EFAULT;
> +				if (!error)
> +					error = -EFAULT;

Logic looks good though.

-- 
Pedro

