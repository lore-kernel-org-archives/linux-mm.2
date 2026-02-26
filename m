Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC664FD9E0E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C766B0152; Thu, 26 Feb 2026 15:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A1A6B024A; Thu, 26 Feb 2026 15:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136E46B024E; Thu, 26 Feb 2026 15:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00F906B0152
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:22:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 895281BF30
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:22:47 +0000 (UTC)
X-FDA: 84487731174.16.A2405F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C950F4000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:22:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQrL6ITS;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772137365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWZNpYzf4Dqw3i94iV7fiiH7gq94n6HGTsUtIH3AsWA=;
	b=tjUZsOreM2RMag66K9bqgs0kvnTyDCh2gt5AsxZLAkosRL4uHkCXweydBjsx6Hz6z6BdCm
	kqCUCEeHgf6t5DGOhXzQby8LA7VRZPj9ROsxP8p1Em/J2bdg+m0Tol3QqU0wiwsGXt0HHq
	d85biGkQGwlyWYhlCbKzOwUznFpkm0Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQrL6ITS;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772137365; a=rsa-sha256;
	cv=none;
	b=hvf2TD9zNVBiMXXUK21MIh6o/8R4En+2EIBSfQoftz7++WGQ047DWYv2nLxbuXKdDmxNoj
	wKHwVOawoQUe7rGHgv9TOfuRyUgJcJtedZvGP7lDGcGcKMQgcnzRADJsJf7Ka6se2NKXuo
	wfnbfKm/xaFOBhqP21CqOFiVE8eTzm0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772137365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yWZNpYzf4Dqw3i94iV7fiiH7gq94n6HGTsUtIH3AsWA=;
	b=UQrL6ITSY0feq6fQVCgBdMT6y2tRwg88mtZCdMVQYJiu+sQreuW9bZmFgdFPyN7MQBgWYP
	XtV1JUYsZtP+Iw4pPWJ06lSdXNhIu8k7Lp3PXYOz6QbfT59mKTWKrSKEhCdifaFweWzRdm
	/Te0yaQF+uLEkN8reeX1ENV6qtLJqeU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-XAF75V7rOmW6OA1s9pG8XQ-1; Thu,
 26 Feb 2026 15:22:41 -0500
X-MC-Unique: XAF75V7rOmW6OA1s9pG8XQ-1
X-Mimecast-MFC-AGG-ID: XAF75V7rOmW6OA1s9pG8XQ_1772137360
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 339CB1956064;
	Thu, 26 Feb 2026 20:22:39 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.229])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E41019560B5;
	Thu, 26 Feb 2026 20:22:36 +0000 (UTC)
Date: Thu, 26 Feb 2026 15:22:32 -0500
From: Brian Foster <bfoster@redhat.com>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH] mm: fix pagecache_isize_extended() early-return bypass
 for large folio mappings
Message-ID: <aaCriOt-CDs4sciP@bfoster>
References: <20240919160741.208162-3-bfoster@redhat.com>
 <3F3A46783F8E9D52+20260226133149.79586-1-zhangdandan@uniontech.com>
MIME-Version: 1.0
In-Reply-To: <3F3A46783F8E9D52+20260226133149.79586-1-zhangdandan@uniontech.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 4NN9MaoS-qDwCnvscshsqxtOIt7YKi566tbYHZtRtmY_1772137360
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C950F4000B
X-Stat-Signature: xqjim9ydca4u31si5zjtkw6y5o5hm1zi
X-Rspam-User: 
X-HE-Tag: 1772137365-361308
X-HE-Meta: U2FsdGVkX1+bMN097OTUBIk6pgdGN3WaGLnVs99IcE62EoDxI7Kdc92BcxrOGj18FP0ig4/Za7ErJ7sHtTpQsyT2jkX7iOzGThxhYZZmFHNjvnfxdLMnIfXRi4KBJEBAxkCutaCGmigdIKD22tsvWvPbtw3QRdKpRWH2L7REtqtMXf8QszvNbBjFIpbX767W1iCB5UubdLwIBEXPrvW4JRGWC/98EsBoNaooWfafZNVGSYo454IzZ5IHo6SeO88KThNUuziPbrickJoC2idLmRqPUrY7/xP2O5MYWoa0nPBAVCTq76+C+mF4HfdJULcE0wUv+BeENaLZQvOE0AfiVBtuSiS6XMznTrLy02btRRIeYSEsGLsR24B9tUwrIMacDIzfOs/vR+oG4lY9fFKPdzhv4k5veu89qiYd3+Ig8G/NdVthGKZIJUyoQVTT04jSRa9UpZ00cwBTig0f01LEQb+Lw0NZIfYj/HD25HpDrOTloqdm9ICI0YhiBt7298Nrm26DWaB4VXmkWb0Hfyp1mYJAvYEySqlG3DsP9zpjOG+zhT19A5rwTrA9ha8nFurSIZ76oxdf1R18otu4jHwIcxQ1mqFB/UA/KHO4OKtqae7vLJLOc3mIF7iThCGKe9y6dRAiqX5S/CK6FhYAdkHZH4tUObmnZw4AbdpEyQkIwBeRUcIbRmTGNOrTYy4yPbNwz6UsUqegQTpJp91dsXurWGQRgxrUGWYUyx2M+TMLQMOdJ3EEcy+t4lRgSEpRl5Xh3BHD+ODnEIbTxJHaB98Lva7a2xjdgvfmzk5XaR2E3nLNk/CCtHWrJAWFdX9jTuuftXlt1g1XiiEXrw9KXm3EV9XeVaV7pnpR0JHqaMCjWM/qNuq943olNkrf2XXnbVY8qW5IPT+5tlsXCYUdIjgAS9ZHp/iHZYt8p4xhDEb9zlGnYgs4AKg1ly1HPg2BdNYnBHN/9R/kW2/IbJ4QmH3
 hazsu/uY
 yciE+lF+o3nPo34KDQZGxTaM4qhlAAWwJFzl8CRas54d9ccpsLa1uanODjeq3YAny7OrEnPzf73I8IoakfBUWNwmqSW2eOAIFdYMjFhLXt3MRFGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 09:31:49PM +0800, Morduan Zang wrote:
> pagecache_isize_extended() has two early-return guards that were designed
> for the traditional sub-page block-size case:
> 
>   Guard 1:  if (from >= to || bsize >= PAGE_SIZE)
>                 return;
> 
>   Guard 2:  rounded_from = round_up(from, bsize);
>             if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
>                 return;
> 
> Guard 1 was originally "bsize == PAGE_SIZE" and was widened to
> "bsize >= PAGE_SIZE" by commit 2ebe90dab980 ("mm: convert
> pagecache_isize_extended to use a folio").  The rationale is correct
> for the traditional buffer_head path: when the block size equals the page
> size, every folio covers exactly one block, so writeback's EOF handling
> (e.g. iomap_writepage_handle_eof()) zeros the post-EOF tail of the folio
> before writing it out, and no action is needed here.
> 
> Guard 2 covers the case where @from rounded up to the next block boundary
> is already PAGE_SIZE-aligned, meaning no hole block straddles a page
> boundary.
> 
> Both guards are correct for the traditional case.  However, commit
> 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
> added post-EOF zeroing inside pagecache_isize_extended() to
> handle dirty folios that will not go through writeback before the new
> i_size becomes visible.  That zeroing code is placed after both guards,
> so it is unreachable whenever either guard fires.
> 
> The same stale-data window is also covered by xfstests generic/363
> which uses fsx with "-e 1" (EOF pollution mode) and exercises a broad
> range of size-changing operations.
> 

Hi Morduan,

So looking back at the original cover letter for this, this bit was for
the case where we had a dirty folio in pagecache that might be partially
hole backed due to eof, therefore fs zeroing might not occur.  Hence we
do the page zeroing here before exposing this range to the file (i.e.
that writeback would have done if the folio were clean).

I thought at the time this plus the ext4 patch covered the bases for
generic/363 on ext4. You refer to this test above but don't mention if
it fails. Do you reproduce a failure with that test, or is this
something discovered by inspection?

> Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
> Fixes: 2ebe90dab980 ("mm: convert pagecache_isize_extended to use a folio")
> Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
> ---
>  mm/truncate.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 12467c1bd711..d3e473a206b3 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -847,13 +847,32 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
>  
>  	WARN_ON(to > inode->i_size);
>  
> -	if (from >= to || bsize >= PAGE_SIZE)
> +	if (from >= to)
>  		return;
> +
> +	/*
> +	 * For filesystems with bsize >= PAGE_SIZE, the traditional buffer_head
> +	 * path handles post-EOF zeroing correctly at writeback time. However,
> +	 * with large folios enabled, a single folio can span multiple PAGE_SIZE
> +	 * blocks, so mmap writes beyond EOF within the same folio are not zeroed
> +	 * at writeback time before i_size is extended. We must handle this here.
> +	 */
> +	if (bsize >= PAGE_SIZE) {
> +		/*
> +		 * Only needed if the mapping supports large folios, since otherwise
> +		 * each folio is exactly one page and writeback handles EOF zeroing.
> +		 */
> +		if (!mapping_large_folio_support(inode->i_mapping))
> +			return;

Is there currently a case for bsize >= PAGE_SIZE &&
!mapping_large_folio_support()? I thought there was a WIP for
multi-block folios, but I wasn't sure if that actually worked anywhere.

> +		goto find_folio;
> +	}
> +
>  	/* Page straddling @from will not have any hole block created? */
>  	rounded_from = round_up(from, bsize);
>  	if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
>  		return;
>  

If I understood this code correctly (and I very well may not), the
purpose of this is to basically filter out cases where a dirty eof folio
doesn't require a refault after the size update for the fs to fully
populate it with blocks. If that is the case, this makes me wonder if
perhaps this check should remain, but instead use folio_size() of the
eof folio (if one exists)..?

My understanding at one point was that we wouldn't have large eof folios
that included a page aligned offset beyond eof, but I also feel like
I've run into that once or twice when dealing with some other oddball fs
related issues, so I'm not really clear on what the expected behavior is
supposed to be there. Maybe it's a corner case (i.e. related to split
failure or some such)..? That is probably a question for Willy..

Brian

> +find_folio:
>  	folio = filemap_lock_folio(inode->i_mapping, from / PAGE_SIZE);
>  	/* Folio not cached? Nothing to do */
>  	if (IS_ERR(folio))
> -- 
> 2.50.1
> 
> 


