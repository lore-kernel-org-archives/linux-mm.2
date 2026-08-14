Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BF5C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3CE6B02F3; Fri, 14 Aug 2026 03:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85856B02F4; Fri, 14 Aug 2026 03:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974D06B02F5; Fri, 14 Aug 2026 03:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66E986B02F3
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:25:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D39DC403D5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:25:07 +0000 (UTC)
X-FDA: 85099038654.30.AEFCA6D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB722C000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:25:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YbJ8UEqS;
	spf=none (imf22.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786692305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yOs9kYzeSlKq0S9/5dhyVg+xcTBXyHYEJKRhv8XhK0=;
	b=xW37xlMYkfd0V41EXZdoEYn09Gbs2SqbNivgrCjGa3DTpO7IY7d1H+plEC/2BM6DR076It
	GKijohY8grby45PyoF9hvBJAdVbn8VZaB7sVO04vEHCRt58Hb9FkIYSeBVhChWteE5Qbvc
	JEdOMHEuTBEdlEsCrFW9bofBDzut4ZM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YbJ8UEqS;
	spf=none (imf22.hostedemail.com: domain of BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b45d4071d3315f6a5e0d+8391+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786692305;
	b=MMse44nTfDz5PYsAlTAOxs1CAnqKVodFvNZbveyalkuhBDsC4RN81t/9aLBOhSXn6pvbtH
	cflOWaPNVJxA+uEkhVywwRnMh2jQgl6eUp+YW8EpDMgefIeqTR/+/zLp/hF2zvu2ouWgxF
	WpgzD7AlJDftr1ZXMjOG/kt5r8Zn1xQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9yOs9kYzeSlKq0S9/5dhyVg+xcTBXyHYEJKRhv8XhK0=; b=YbJ8UEqS+yyXP/qJROa85BALOS
	dJsKfcChl5wxE++iuWb2tsBLpb8GNzexLBSpEO3g1cktaZQfYOh2OZiQ6InjKt4siWcm+34ZHfFbX
	4lgxAvpRWU0MBssKmXwrq7IqNToWeakan1NG4zgzUYkHIYQNA7IJXdV9AuC+unIl+dF1c5bA7K+H1
	/WHpGBbLUZsAC/HXDGsesUxUhzR+l6GJVg3Wz5tpHf0ZTkB+T+G+5mhP4IsZ+WEF5fctpLcObq+8N
	/HpOu0DdhpsfMeM/5xKrQRU6b4ou3WfGmZskeLsq1mniNxsvu9qFRyNRYUFZ3fLRXYo5WCF76FYyj
	InUyqAUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wumHo-000000028rg-2oTL;
	Fri, 14 Aug 2026 07:25:04 +0000
Date: Fri, 14 Aug 2026 00:25:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in
 NR_KERNEL_MISC_RECLAIMABLE
Message-ID: <an7C0L2PT-Ous0hn@infradead.org>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-3-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-3-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: wihznu5sxbu53a8p9subkam4zynu7pqy
X-Rspamd-Queue-Id: EB722C000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786692305-481685
X-HE-Meta: U2FsdGVkX19cNnHiIgSfrFAz9Po8f/WhuT8e11IbspUV5m+qBogAm3224zlF5bbMgR2hG2JO9z+IWudpLJIYh9fQKeXjC6kMGnkfYkz75KZ2o7ehCb9vFayj5GJrvDKi3vOIeOJGj0W7fKdbuBeHmWBO8k7teU9KOpHh06csIp9jm7KSblF04xBbcxjKJp7hCDHppPLWVka675bXT170ZJZ6auAc7TJ+BHejlvx9JEF1u9m2zq4yhUBQl+t4zXCXVSoHh+pJWGXLgHaP79foiEgElRuIeAzyW5oDf7XF9zl+Y72Wf49g4sCyuHNnx2LC9hGPIQc9d5DR+YjxmBWA3WWUeImFmNnUiwzSWVStmTbGGvGHT/LK7oEQ+uLpbKM5IatLWKxp32g8MeNfXjHOjGJgeaDY872gzGuZkCaJstCRGYbq6XKVTIHMMSsBmzbkT0eh2w6WFN+C9sngr4VamllTJ5VgxZPeRzHCF6gAEBVG7voEzQ348wFNkX6KHVo4S98GFqaEcxWplkgj/cAzR0LVa1RUVyrZyVRg+WOPdTLwTOqiV31tAXTQUKLWeqN8BZA42by0tVwA7T0KkRAIqzshxrB3i10Bew/Z2YNum1yoqCPZ0WhYObwRy5bR1ZBQRyxt/eAjWrOVvc+RW/IvxCvxnd7OX0GhePL0YSvdVUiZpQhK4YUBy0KNVvube0hKPnWUrMc7IluBMchRNKKqkpTaoxRwTfzEIsaV/aPX+Eo+9OWw7KF0cQQD2kWtDE78kpOdeooRf5MhX9eBvQkM/qVsPANlwFPk38/G1Q+4ece6Nf/myQexz7YSzsmE+pw71dG1JudcfioGPQazQuxhlLuntor1hUMU/2AgFO3B0iqG+50SdFuq4QdIh7amSAQ9UANkf5YmfPGb3GDCqjL4WfR8EmZ/9uY8CVdLdbvE9cBiFpOec582wrJYBR9fDJxMhkl0wGDqnN4WyMlxsqH
 I23YqLQB
 XN4JLITXlAEaxvAvmh01zOJpCUCL6yPlI99moC71W8YWBMoTS3w05Zu5A/pyO0a5AsQoU/1ydDlUPmZWJx6pLtscz8YZ0DbVZoJkCO4+gpCquXFCRmYy8YOqgpDuBJryiSmB716+eKljRgYUg+qbpPrUoFq+ZhPAjiOBR21MD5xT90PpwVVtkP3AyBQDajhfoUVOPD5HQXGYPtehbwpmbbY3h7gT+R0Q5hT5R/JCE2I1Y8gYTXgqI7CDdAql9OjlHOpm3izl+qBnusg6LgsTWR4IHtsLVSKjuC0z8a3tyW0CYytJiFyPYRuvH9fDwUSNTeZ4F1GxTLU85F6LcUObwwWIYaNNblftDllraOCe1TRlZmag0aC2xaao2z7PIwIF+6bUqhFaWspYiCcRRppyi9pXDTGGLTo769P0I46ventrbEmRriripQOskpPDIQk71CNrZi/wB3T+JiFa6NgIOfYycbpuQn0CHNFB8Lm94zRdYr+qnz9XDG+XnVO4gmfDVjP3F40bz+b60hkZhDCHtdy29ArUzh1E9etCnwYUZdYgzZleEfOW7Vsk5CcqjsTCs/rSKS5pnLn4H9DmElPcCc1dixZg3At4F7mFP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:40:53PM -0500, Eric Sandeen wrote:
> xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
> but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
> made for this purpose, although AFAICT there are no users today.
> 
> To achieve this, add a new flag _XBF_PAGES to track what we have
> allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
> count when we do, and then do the reverse when they are freed.

I don't see why we'd need the flag.  All buffers are either allocated
using vmalloc, kmalloc or as folios.  So it should always be set for
folio allocations (and is misnamed since it now covers folios as well).

> 
> These allocations now show up under nr_kernel_misc_reclaimable in
> /proc/vmstat when allocations are active, which in turn makes
> MemAvailable more accurate in /proc/meminfo.

Adding linux-mm and a few people that touched this counter for
opinions.  I guess the counter is only for full folios, and we
should not set it for the small than page kmalloc allocations?
But even with that, why not set it for the vmalloc allocations?

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 16 +++++++++++++---
>  fs/xfs/xfs_buf.h |  2 ++
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2e00a33ebb62..0a853ec361d0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -114,8 +114,15 @@ xfs_buf_free(
>  		vfree(bp->b_addr);
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kfree(bp->b_addr);
> -	else if (bp->b_addr)
> -		folio_put(virt_to_folio(bp->b_addr));
> +	else if (bp->b_addr) {
> +		struct folio *folio = virt_to_folio(bp->b_addr);
> +
> +		if (bp->b_flags & _XBF_PAGES)
> +			mod_node_page_state(folio_pgdat(folio),
> +					NR_KERNEL_MISC_RECLAIMABLE,
> +					-folio_nr_pages(folio));
> +		folio_put(folio);
> +	}
>  
>  	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
> @@ -132,6 +139,9 @@ xfs_buf_alloc_folio(
>  	if (!folio)
>  		return -ENOMEM;
>  	bp->b_addr = folio_address(folio);
> +	bp->b_flags |= _XBF_PAGES;
> +	mod_node_page_state(folio_pgdat(folio), NR_KERNEL_MISC_RECLAIMABLE,
> +			folio_nr_pages(folio));
>  	trace_xfs_buf_backing_folio(bp, _RET_IP_);
>  	return 0;
>  }
> @@ -427,7 +437,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM;
> +		bp->b_flags &= (_XBF_PAGES | _XBF_KMEM);
>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 79cc9c3f0254..ba7bfafe67b6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -38,6 +38,7 @@ struct xfs_buf;
>  #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> +#define _XBF_PAGES	 (1u << 20)/* backed by folio/page allocator */
>  #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
> @@ -62,6 +63,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
> +	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> -- 
> 2.55.0
> 
> 
---end quoted text---

