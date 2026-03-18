Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF760FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544986B0113; Wed, 18 Mar 2026 03:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5906B0115; Wed, 18 Mar 2026 03:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432B46B0116; Wed, 18 Mar 2026 03:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 316516B0113
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:56:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5019C222C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:56:35 +0000 (UTC)
X-FDA: 84558426750.30.FC900B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 796B320004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:56:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMGLEx+p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr3NjmjATjnguwMjedlk+3eX2mHVpbLgyXXoyVYFVsc=;
	b=VGN1h1A5R/ADe/+8nb6O2CS6KC3KTUgQqnW1ln6P3je/CtGlLq7ZH3CeOvT2/9e6rYhUUN
	0DNXJ/TG6Tz3d4zhTDLQq36oDXglbtrxST9xQ6/cHRPX5jVSIg649ZRJt+PtMILBlmgY7g
	MFbhBi35D1o0OxETL/XNKdMds32ZmzA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMGLEx+p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820594; a=rsa-sha256;
	cv=none;
	b=PRs39eU2mXeslURYK/tOC7RJ9fpuv4LNIYA5HuhzgWmYFpB4rzLU//gdAfeEi9bABTM1dz
	CwN3rbkRr+c6lEiwFdBz3xep9zZPpw7p1HHVk9GlxBH9IcgwGDzCH26YWBgEdcVqY96F1r
	S/6uy5Fkoh9aTPRHSmRg6UgltORpbms=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D09F8600AE;
	Wed, 18 Mar 2026 07:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66C1C19421;
	Wed, 18 Mar 2026 07:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773820592;
	bh=9jejaz+AfFnqq6JpVMn1TYNKOJRTQE4855NDxxP8lrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DMGLEx+pXhoSwtF/2neEVc/1IRuLQwGViRE8LWPQ7WHfJwf2r+WRvNK8lXRPaYLGa
	 c+11alu1GD28Ktc5XEGPAvKDn7Yhea5jKTEsRmPES+QgPzhBxTBjSpPC4Jk89+fxoH
	 z2XsncGWZCILxRpUi5aNBYAUkwbRJs9+hR6x71XsLXODmYJblugtlhECQt9rwBayRX
	 tu6+cw2GQabrXON/sNcq1ydFRKiZg11GlyVfSE+TXxipx92j1Bi6ac82zQ0c4EtUFE
	 eunNwJogJK9jyJyJcALqh1MokMAnAClYG4HFB9PuAhJgAk5M4Ell/1Xd0tlk0E1qkR
	 BEmo3L5SUKHTw==
Date: Wed, 18 Mar 2026 09:56:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 04/14] mm/memory_hotplug: simplify check_pfn_span()
Message-ID: <abpaqInBszasyflO@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-5-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-5-david@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 796B320004
X-Stat-Signature: 53wujfgk6s7p5wetj847frwgb3jheqs9
X-Rspam-User: 
X-HE-Tag: 1773820593-203095
X-HE-Meta: U2FsdGVkX1/R0oSOJqvKkKOVS4/4AmrjCOzbiGNLBADmgVSNyflTnX6VleZTiPDSMPm/EYamlW2GKqJQI55Tm5A3ofKRisFAZ0CrFLQZ7jY3qeZlhU9VywCiE9xTljd/d+Pf2ixIMooUaw77j6G7RuF5Qj09sy8DjnRFSGRuuJOOjnxQL/E/7+RpvVwr1FcEJsFpQEWnn/dDhwhVDaljpr8V8Cc3v1n1DHX4W1ubt8XmzTF5ha9Pp2ILZR4dXdACXk1sD+jQiCabXG/lqkMAh5ODG4E8auOYBY6Jes6rOeguyUTKb7AiuCLhoTAUxYGP9GWR39T8iSf/xImjC2XwB2aP2OQhmkJ6/7bwCZqibGw6ovwry+HqZ6keH6R4dtoiEYU0YUsG5m1OU0beZ8G0O7jkHydWCbApWsYo9vKeEL+PFW3xCr/pcBQiFJqphCIOfLS4JIfhVBG7LcSv+5CTJu8+lCmojJ9gO6Jt6L+qr4maaBimidOlBLF+AdMyu++Cnz/q02f+B4+TYhiKdp2GFONXgp724EbGWFNRdLEMCV1MRRqPfnbyZXbEViKv1qZGNDGk6bOppZtdZU6HzzpVAJMbZVrXstOQlCiyJQXcKg2JX3Z1pNE3kHavh/LCFupt27QmoXzlD/Nnxy0TEnf5Y1bIICmY7Y47+0HHnY4duio2FqrbznKuOgp0i303YPIYb2Cn0MBNr7ayK7kF1Z1DJhaeFHEnt9La3OFzp4vPr/vlnhECYPvx0tyhKIelWFLUBzn4ULRZ0vhWYJ+S2fYyTc+Of0g0x3A7Qe8tBctnQ+onUDq0MUr6CyjlkxvoUWPOKxl7LVbMTBNJ9JqvufPYzN/PBCMKhRIYtusHP3u+54NOBRIg4jT7a0hN0aR6IAJQDj+4eAKX0iLgPxb8uuLn3fa9jLbyXz3R5AnMrm+ZFy+LCNvkvyUTENOby7Q0IiBthUBMhRWIgiGTDBYsfb1
 HO7uFk8J
 ZxKXQHf88vZ0E9atk1XLmebOyvWls8o1UM+n+/t1pRz4ir88D3C6vyEd3/DTWLmNRNucO1d5AVHh7y4XhI4z0GVvbLLcJRy9ABMFo2n6VAxr3gmDheKRtyt7KW+mVyAbvBkBl3+HxbgZ8IK+YOxPI+IapA5AOHsImrU1YLnW66pxZWK+/ixFqKAb0DMHCQvx6aVqKMboauZEvXdY7nBODDlVE4sTuNIzMSveSgJr1D5HJU2ano41hPCSURiDFxjGc9SZqlBU1Dg7XcU1JzDwtvCvT3bGGdXuLcZkwmdqt0jR7Zu6wmCdjF1kAIbG77huulM+b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:42PM +0100, David Hildenbrand (Arm) wrote:
> We now always have CONFIG_SPARSEMEM_VMEMMAP, so remove the dead code.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memory_hotplug.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3495d94587e7..70e620496cec 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -320,21 +320,13 @@ static void release_memory_resource(struct resource *res)
>  static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
>  {
>  	/*
> -	 * Disallow all operations smaller than a sub-section and only
> -	 * allow operations smaller than a section for
> -	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
> -	 * enforces a larger memory_block_size_bytes() granularity for
> -	 * memory that will be marked online, so this check should only
> -	 * fire for direct arch_{add,remove}_memory() users outside of
> -	 * add_memory_resource().
> +	 * Disallow all operations smaller than a sub-section.
> +	 * Note that check_hotplug_memory_range() enforces a larger
> +	 * memory_block_size_bytes() granularity for memory that will be marked
> +	 * online, so this check should only fire for direct
> +	 * arch_{add,remove}_memory() users outside of add_memory_resource().
>  	 */
> -	unsigned long min_align;
> -
> -	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
> -		min_align = PAGES_PER_SUBSECTION;
> -	else
> -		min_align = PAGES_PER_SECTION;
> -	if (!IS_ALIGNED(pfn | nr_pages, min_align))
> +	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION))
>  		return -EINVAL;
>  	return 0;
>  }
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

