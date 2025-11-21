Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EEDCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209FB6B0026; Fri, 21 Nov 2025 01:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAAE6B0027; Fri, 21 Nov 2025 01:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D08A6B0029; Fri, 21 Nov 2025 01:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA6CA6B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:50:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F1F987A42
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:50:33 +0000 (UTC)
X-FDA: 84133690746.06.43856AB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCD4F1A0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:50:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R2BU6Nop;
	spf=none (imf19.hostedemail.com: domain of BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763707831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vo2CYkxvIT2Wjjh88hsMNfehDmvCrW9LP6F7KKNOnOM=;
	b=5EDTzukfSD44WQuCr2TIeJjoq3bkyHkhYMbKrhNmC04FPbPF5rRJd+Dz4bRRKdaNGuS/05
	2JYAaw8sDPgDeBAXXz3ALr6B2eTYNMQnX4N1Z2EW7Su4hYijMbSAsVPuc8RqsFIZFdH1ez
	A9vzJLa7WZSidyUW1UVvHGZ4fsN7/js=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R2BU6Nop;
	spf=none (imf19.hostedemail.com: domain of BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763707831; a=rsa-sha256;
	cv=none;
	b=UBTIDQjqcgVEceP/DQWxQLk3rslD/wVLCRAqHodzYxFWyDR8a7bKmrhcj9Vzn78JViqlD9
	JUw4qC/Ajodt5Nm1QbD3mUQmg3foY8R/SaHe/n8PG71qZqjiZUzXH/U/avFCs4niYSpabZ
	VVuo09dd2SoAUWHjzHylXChyY22el7Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vo2CYkxvIT2Wjjh88hsMNfehDmvCrW9LP6F7KKNOnOM=; b=R2BU6NopA+aJdjWX0pOQHAp99x
	KFL2tyCvJUebfU3KFAdDCgw/dfuwctywKfhlJhBccOKQ9/uuy28mzO8NUtzMR0H4sPH5HEV9SbnDY
	izyjpuxwmNYj2JnifkM2+Wh0I6wwXW9HQ8wXH2S8Nsbz2n8xO42lP5CAhvDnysJo+DCYAbsHr5+9D
	xqDgKZNV3+q2CjDickAQX/gbqJ2aGEImWMWVbXt/gSR45a9N2KzL3DKCs+T8CK69IOZHFWcqppOHc
	uwIMA/n5ubuPXy+p1ZD0uWLXqM6TuvjGKiU1z/cuBofNEhprXz2o5yYpBVbeZb5kuw+JmKJNP3mp7
	lKZEXKEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMKyS-00000007wM0-0d5O;
	Fri, 21 Nov 2025 06:50:28 +0000
Date: Thu, 20 Nov 2025 22:50:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] f2fs: add a way to change the desired readahead folio
 order
Message-ID: <aSALtF5Cty38G2UV@infradead.org>
References: <20251121014846.1971924-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121014846.1971924-1-jaegeuk@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: BCD4F1A0005
X-Stat-Signature: 1dghbu958dja8ceirkpgqaqqdend9byd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763707831-714256
X-HE-Meta: U2FsdGVkX1/2xkEEiRyA0AtyYuDDg5RA24NJ8UiTu2t1QT2oDvsOe4KxlicPCqqKqRA3ORJIXmWvbOfsZrykAxDf/f4q+N8KtgM5Vp4tvG9HYlkSd2+B1rJAnA4bOzGa5yAednMR4KJlT5f+kstSTtQoVziF+ntsOJKiBM+wWhSE+x+mJD5u4t9pro4wV4I7CVBfDftJXABsj/Bw1sdGi2sqXK2ilYbiM9K5fhzAJAFm8w7FtiIfktq0ybaCUskUuUiXPKM/PTxRVkH6SkNS9lT5QR3kEYIbdcXOoj4gEdslhU/HdJnVtWryv/EuJ98t6RVpfgE8fCJnlkd6A2Nc7+TvQmGycMjwRlJKQEAuyB/XTRG8zKq4pj1UC8R0CxXP19ZDE/qdH4M4pSxDJOT8JDjbN5c2f4g0F7E9VS/cwRwHABHqfBYCbv5seKDocco6As9XSFQAm/U4duE8BQ88hVS9I9rdNtcfd46beej6oGN9HuXNQIltyHqi7c7brHziQOQoQ/thTIPoakBWrkR/A/gDZwT29P2BrDX+hE/YGaQcwe4282Az48tl/SJdnL8o4JnVSuWMmiCR/1x77H/x5M3B2H9W51omlI/WyKcC3kqOnUFixa2keRQct8NJtXVRKpFOkghmdOBjzQAH8F/PubmJK1D8Ns6JPGLXhegK1uwPIdVFUhjmG3P9wb16r3j/MLP0tc5nO4Fh79Dc7AomdFjovDhTO7P9FRxBUcTnnEFsS21WEwmNw4r1QaJpHnLsnQihE+tIhTA+abZBs7AOadzeZL0RIfOKafnVjcyrAh6L677XWiuc/boZ4TSP7tsoPtOyuche5AyYTeJm7DC5YT2zDm31gD4h3Gux3iv2cx2FShLqXLBRvDpFTAThIc+MgR8Bhs4nCEhCJVQ1/B8DD2fURl7p1qfGIIeX/c0EyANZAnnLMBaBIdto8lr9fi0jLpGg3yhXwXpVJIY7VzX
 p4NfaK8g
 jtvgWWbOWnC51w78sYtZulAkp26qS9jR1TuGFL2WYuV6zSJklWZJ0rFiF+w4dZq7T4uOmhfI+xEe/Rm9oTm4dDVxpuv7F3tU+DtpyWgGwh+7juCrth83aCZ2PGkPjpb/XI30uVPXtzrybKHYFRX33TqkJ5MEIITTNn3iMICeQd3YgC0i0QepB4bKvrs5UZ0yxXEhEe1KnWlHA3Od/KVqEcnXHGHCSWkzGopMJrFomVEMG+dVFemFlzYKeS5wnen/i05gVtHdgX3dy7nLiXnammWu375kmrFprj2UT5/LxYpFSnakzeTO7QChYLuicGmN+KpwiPBcxzSz0hhNR057WIKjT5Fg1ApJL6uIRWfRHPkCYUPmpRaDFh7O0WkJOJjeACEndDhvO0RUpc9fpn5d6MjPSLiK+o8igEQiHRT9I59tsKRFrlgpdN2wRx8vnEpxtNIE0+VbmPryABmY1Pg3SpQrsd5iSWLKB4cE1NC3do+2X1aCPQ9WP/b76evU++81AWkOU69XOhWFvfxDc7ODRb51jAFWcSpN2hQlpsL7zV4G6D3xPgzPnSVeiEShAzOB0eiVGmOW/NKTalSw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:48:46AM +0000, Jaegeuk Kim wrote:
> This patch adds a sysfs entry to change the folio order for readahead.

You'll need to explain why this is useful.  And why this is f2fs
specific instead of generic.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/data.c  | 1 +
>  fs/f2fs/f2fs.h  | 3 +++
>  fs/f2fs/super.c | 1 +
>  fs/f2fs/sysfs.c | 9 +++++++++
>  4 files changed, 14 insertions(+)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index c80d7960b652..faf1faa27c41 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2764,6 +2764,7 @@ int f2fs_readahead_pages(struct file *file, loff_t offset, loff_t len)
>  	while (nrpages) {
>  		unsigned long this_chunk = min(nrpages, ra_pages);
>  
> +		ractl.ra->desired_order = F2FS_I_SB(inode)->ra_folio_order;
>  		ractl.ra->ra_pages = this_chunk;
>  
>  		page_cache_sync_ra(&ractl, this_chunk << 1);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 934287cc5624..0e61e253d861 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1921,6 +1921,9 @@ struct f2fs_sb_info {
>  	/* carve out reserved_blocks from total blocks */
>  	bool carve_out;
>  
> +	/* enable large folio. */
> +	unsigned int ra_folio_order;
> +
>  #ifdef CONFIG_F2FS_FS_COMPRESSION
>  	struct kmem_cache *page_array_slab;	/* page array entry */
>  	unsigned int page_array_slab_size;	/* default page array slab size */
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index d47ec718f3be..dabac6f288f0 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -4287,6 +4287,7 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
>  			NAT_ENTRY_PER_BLOCK));
>  	sbi->allocate_section_hint = le32_to_cpu(raw_super->section_count);
>  	sbi->allocate_section_policy = ALLOCATE_FORWARD_NOHINT;
> +	sbi->ra_folio_order = 0;
>  	F2FS_ROOT_INO(sbi) = le32_to_cpu(raw_super->root_ino);
>  	F2FS_NODE_INO(sbi) = le32_to_cpu(raw_super->node_ino);
>  	F2FS_META_INO(sbi) = le32_to_cpu(raw_super->meta_ino);
> diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
> index c42f4f979d13..2537a25986a6 100644
> --- a/fs/f2fs/sysfs.c
> +++ b/fs/f2fs/sysfs.c
> @@ -906,6 +906,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
>  		return count;
>  	}
>  
> +	if (!strcmp(a->attr.name, "ra_folio_order")) {
> +		if (t < 0 || t > MAX_PAGECACHE_ORDER)
> +			return -EINVAL;
> +		sbi->ra_folio_order = t;
> +		return count;
> +	}
> +
>  	*ui = (unsigned int)t;
>  
>  	return count;
> @@ -1180,6 +1187,7 @@ F2FS_SBI_GENERAL_RW_ATTR(migration_window_granularity);
>  F2FS_SBI_GENERAL_RW_ATTR(dir_level);
>  F2FS_SBI_GENERAL_RW_ATTR(allocate_section_hint);
>  F2FS_SBI_GENERAL_RW_ATTR(allocate_section_policy);
> +F2FS_SBI_GENERAL_RW_ATTR(ra_folio_order);
>  #ifdef CONFIG_F2FS_IOSTAT
>  F2FS_SBI_GENERAL_RW_ATTR(iostat_enable);
>  F2FS_SBI_GENERAL_RW_ATTR(iostat_period_ms);
> @@ -1422,6 +1430,7 @@ static struct attribute *f2fs_attrs[] = {
>  	ATTR_LIST(reserved_pin_section),
>  	ATTR_LIST(allocate_section_hint),
>  	ATTR_LIST(allocate_section_policy),
> +	ATTR_LIST(ra_folio_order),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(f2fs);
> -- 
> 2.52.0.487.g5c8c507ade-goog
> 
> 
---end quoted text---

