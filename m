Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C4410ED669
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9C96B0092; Fri, 27 Mar 2026 08:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ACF6B0095; Fri, 27 Mar 2026 08:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA77D6B0096; Fri, 27 Mar 2026 08:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB4736B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:50:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48FAC13C5E8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:50:38 +0000 (UTC)
X-FDA: 84591826956.24.C9045C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B49AAA0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:50:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dbrt/V4U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774615836; a=rsa-sha256;
	cv=none;
	b=LvXGrzi5nTDLKO+05y+MP8axxtTczkiADppLXu8UKOJxg46q6wSl7SJFMiFBVL/wayD3LK
	jsOXSeBRO/JZVlHUiPlx1fXmbOcVyBX+4I1woGbSMvIoEpWlYN1HI7k+piKyBIDTaIHD7/
	WTw2L2GEy8mcYy67eek6DKGXxm6qbBQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dbrt/V4U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774615836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG7lJ8SC5y2bD5PdrMyCiBGSGmh2FdhrE9qDzzdMagg=;
	b=BJ2hM2E0LFHYerPxH8b25lNMdu9QcyXofYe98pGU2YPi5ZLcw4yRORi4fyFo65Ris33K/S
	6dLcmnip6ajLTa54714Jj3NFEx2oocesmeQbXAPeosE5BjDdFqb91PBBa0RgQ6b3cFhzN+
	CWEDhp/W0Oa2hYwOswxLfC50nZaWZA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1708860133;
	Fri, 27 Mar 2026 12:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774DC19423;
	Fri, 27 Mar 2026 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774615835;
	bh=7TtvxfvBKonF+oVtDcunkjFuZJVVhgHI8FyFmO9gAyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbrt/V4U3RhDsEEVQice4TAK4sJiHyb4Calj2k3bm3O2B2llHOuxX9IC0SP/Ooufj
	 JKx+gTxPfFON6p/vKpJsGfUm7cJLFZFJf5/wmGK4M5PmC+rL0K2N5sSwFvcU/9lYRe
	 nfsyXZ91doAm0vVLg3oO3pP0FG6a21YhfdVKVCh5Iy9pYCpPb8QbfeD40nECYwrfuZ
	 EGmtmUxAUOUPOOdjKLVDzABtHSkbofi91uoQUVuMOarXnIoyaZ6g1qxjdzE8d6/APx
	 t3jBYudMko9aT53uZlcaIA+tqoETqvMZsu/56Nwx56rIg6ijstSfa6CPmDX0mnlhHP
	 tQouBAQ0ri3rQ==
Date: Fri, 27 Mar 2026 12:50:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 06/10] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
Message-ID: <e5eed307-c0da-4de8-8be8-eb52e2af413e@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-7-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-7-ziy@nvidia.com>
X-Stat-Signature: emoxh19ggysn3aemyp6f9eqb9t1mder3
X-Rspamd-Queue-Id: B49AAA0010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774615836-470601
X-HE-Meta: U2FsdGVkX1+KR2Q/7SCm62OGV0yr5WEcFaG9yseC1IO04pVHb+of4buf5DnjtDKofPkAeihrzSxgy+HkBGbPEsobgenHinfk9rXAVYPNI4ss81LMrPDU5bKx1VNSekMLFoKwPc/ymHn+y0RCURjlAXOlIAOGX+7PbiYce41VLticNW+MGxue6OCDC0KYgCe40733MPP9izvtAGgl53iIaUi13lNf7bQohLI30acSvn7kpc0LHc+/rEfVg6tHwCIqk4bu3G9xK942QHGpqIUIINaWzthfCPuvjeX2yMLomue6HpuET9z6VAg7Z5k+ZDmjl+LSJVt/ATicaGBaYiI4l6zC4NT/9UEEhC33sa6x2EwsqeNM5umfZ/WyBPAfHU7xf5Hy8zEXLDObJJ0jRaVHdqKKSyASWaN9qQ2om5RDKHVm0z2tNAz/CB85HiFrDCdDeORF5cq+bz1d/m4eN7wCK4MgnvVTLLrJ/V/SZvZzEBf1GA9HY+2i5nWDFfSQkCqotTZ6SEMrpSW1XzNuXiJM36oKQjIUFtgeMsvAVJPBspRWzujelv4+XkJxrpnHEVqy6XYygoB93ffaUNjTO+Ije9sgS4BogVmSgnjGJEYnPeZ77H9XmCw1sQFkcScQikeldLPwv0GZqgWoPsdEYL/bVjo30zrI8FWBpDXK0L0Klll4zw9G3s1yeC369lb1oOzgItMUAYNfDCIatBp+aJFqYCxwf527C55FiB+VwUxoqU097WmEomj8b/b17lz5o4ZjUuY0lNXQhHI5MZx7FimJSU1Riy2+Q1Ygi2Tmp2mIqxksAaiLYJt0ntYhYA4h0fOOdr0ZssBLDXlRgDIN0UVYg5sojHT3qR4R5JiCfpxEtv48IR+YtZF07XWWqntVx6GL2rj7sqa/W064dTe6al2gXNzPkSACToGSuYJ0/dcbZVJVGHnhCT9B0wAW7bEnPkkCtwHaRS3Jw7hw54PffQz
 wMgdXPwG
 3E6F1B8vAcXgWKvueYtNsqfrrzQoEhNQh/6VI0D3rQLaiPbU1bPNoytUGBEmeWP1HajP/47U3nFFKocHOcaO32quWFPj/ffcaBZ8p7SgyRBbQcsuyNoir769EUuX4BvQlVG+4GbaK4798Y1tL6xhvYK8CNpCXSFxpQcwd6/d9My52adFEXto/U+CL0J4M/qUOc6RPiGsjj1BVZoBq62HzQRndCBD84EXxtTYkLevXzOZlrl37l3TEtBMr9QU08zpC17ZEB1gVyVqFLj2iS8IL9hKKKnX1T6zpMW4HWfqnb+St/ubL7OLpTh68PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:51PM -0400, Zi Yan wrote:
> Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
> a FS without large folio support. The check is no longer needed.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Seems legitimate, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 22 ----------------------
>  1 file changed, 22 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1da1467328a3..30eddcbf86f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3732,28 +3732,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  		/* order-1 is not supported for anonymous THP. */
>  		if (new_order == 1)
>  			return -EINVAL;
> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -		    !mapping_large_folio_support(folio->mapping)) {
> -			/*
> -			 * We can always split a folio down to a single page
> -			 * (new_order == 0) uniformly.
> -			 *
> -			 * For any other scenario
> -			 *   a) uniform split targeting a large folio
> -			 *      (new_order > 0)
> -			 *   b) any non-uniform split
> -			 * we must confirm that the file system supports large
> -			 * folios.
> -			 *
> -			 * Note that we might still have THPs in such
> -			 * mappings, which is created from khugepaged when
> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> -			 * case, the mapping does not actually support large
> -			 * folios properly.
> -			 */
> -			return -EINVAL;
> -		}
>  	}
>
>  	/*
> --
> 2.43.0
>

