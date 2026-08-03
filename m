Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BDFC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 23:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FA86B007B; Mon,  3 Aug 2026 19:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0EE6B0088; Mon,  3 Aug 2026 19:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11F36B008A; Mon,  3 Aug 2026 19:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35BC6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:55:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46514140891
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:55:23 +0000 (UTC)
X-FDA: 85061617326.29.C21A66D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B70180008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:55:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtGEZUNf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785801321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvcmvXr4acqUWBRh7hziDDp8JEZdMtVWzfIqcampLcw=;
	b=BeHWBJQiGyqpll5/cyNmdwp/PZiu7RyYBpAgpUxiXMfHvsUnQ0lKMLXeYU8wae+9aQWUE1
	TUFe0KpP/11C1Vcr2etOeRu7S0BcmTctNsasWY45/4VL95P/DwneCjwVVVQZpKHUD3jOYK
	oBDeM2ez2Lz0u+F0s8wSeL1g+c5h94w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtGEZUNf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785801321;
	b=Oc8DafMtLhLGeLJ03758K3UqRa6lVCDpXTCvp9KlqKP7/eYi4eWkT76cc30+yTHbyXiQH9
	Hb9uNTkchS1GVwThrhH7TSaDu0LAU267g1hMZ+SzjYJzOt5MAQJlBNDOyMoh5zNb6QG5Fk
	tujwLwFAcIKO9Jgjwze8SDZRGb1UfYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0A1B60A60;
	Mon,  3 Aug 2026 23:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A071F000E9;
	Mon,  3 Aug 2026 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801320;
	bh=QvcmvXr4acqUWBRh7hziDDp8JEZdMtVWzfIqcampLcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RtGEZUNfVk1jOgNOJwApSJ93O6cVC45ktiN2j42C43XLae4gT7K0HxtErE329zu6Y
	 4q1mEBzTDnzUbmn1OURLkSbBTmQJewI+Y6tf5wHTwUYU05Z3Meug4Fm+oc4/qqZqXE
	 xSaSxhssLrPHFanyR2w62mPUk2uHFQDsY+APGSl/m/zgFlQfzvQqSXOELjBmVyK5Z2
	 ZH2j1I/wSxiSXllvvgkwdz24/JoVF76jb877bCjAEig9Bko1o5oI3KFWoKE4hg+/Cl
	 /ZTzrxndYjiGyPujGg8KW0p1CK5WBj4Vxu8QsyZXgGXwSUpyd7LTOBAIHjESgRcrXJ
	 skL+Bc38weOCA==
Date: Tue, 4 Aug 2026 07:55:09 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <anEqXXa69OpwJ7ej@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
X-Stat-Signature: 1zi6uarrdiey19af1uupa6wakp1oh161
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B70180008
X-Rspam-User: 
X-HE-Tag: 1785801321-461711
X-HE-Meta: U2FsdGVkX1/RTKIfXw7RVg7M/wGJriAMU2Zb6M2PV3e7x5OuxIjb0SzQuj/dxm0TI0jkysi4NhYQv+cIM3flLLFt1HPjnH4Z42DXaMwdalhctcyRDVW9AktyE6wfPaBoEPOjzB8wYjY9wZkcJNl+9n2TyXO7Ofki8GFh4iS2ZhPenXRxa65QH8MGzT6XMa8T6FpAMjYq6zrJEG55BQdNQU0l9rgZvLoi9GAX91cfdQ+U6gEBlhNVNPND8p3pinFNHmups1tGndQUzGhW6/YzbUHRRDwjrD2u+4xDOxoZrEnZO1RjKzl1Xebies3plGVu/jFPPneQRR182Tsqy/MFqJbLjr6k4eFIcH+vvz2XIPGTCPRGtPoVrHtN5Fso6CppIiUQ1GqG4Elg8fDA3rz+1S+wwbPa069wJ0Z164E6q7WYneVYHMCrv+CuSv86NjHxhrp3G456ip+kIhJSKMR8YCWQPEnD0qDB2dNi7p/G3kf5KildyGsXT6U6VFREXjv+HfJK3G2YQNbusLAxLSqczXmmOSezqCL8AB64xl3NnBe/XOla66EzL4efW51Y6m7TEivpxHqJo8lXRT2v6SsgjavSejwpFIQoY+dEEX3kDVonC7flRL5YDneA1DibI8KaTtVp91ViSRPa1UQigzqduJ4mdPP4yKbIWV3Cr+CmxAt8CFPswlJKJoczli93bzw+RZz2Ej97eTwFwOwfhHnA4IqszYRdYROcccsUrZp+Yot4KDnsBMLA+OPkuUb9jO16h1GtIDbKSOHlMul8J88xVG9/ycw39C89YwCmr3JzTWqBHkLhepsFtIAsbvElcqCy62jKxuQSMgBh4HAD4P/ntJiDkuzTbI2b4yxbN0/qVTORAvk4eP4+Y9LD9Cv7izg9SkkDG7jWKFrtkO8FB2YiByz/5g9sGDOhwxMaDs/AtdOSD2x8v3LPDBeKEnDWbqUAY7PESPBEMa4Mi6zHCE5
 0+L6hlvK
 t30WR0/N7xeBk1xi9CM9hqsqYLEhliUO/kFbd655+ahlnvcFedpNsTpDbwbA8936IbPj0H9rO9SW3YWqLfAx03178pTBfptxtZCE8BN58ObqYpx/OQq8hHMOzprbNC8r8F77UcAxFMJz/jMx3Ch4T1zPwLLCfb3RltQovTHrgsN4jYmdPYSSfBNgZrk0qTE5RJuSzrE3QHfcH08r6MaTmA5VhPR2Ysvz2nKvg/qKuhHFgczD7Kc3+ZJkkm11DmBZI8h28jBj2uq6NbyiS9cRyd/enthsaPPudV/hZyNM9LoLRkxaoQCLs0VfPCGJeGAaNNadghxq6TqAl5GpIF/uviFyOcO6WXIavFAE+ZSjNVc+2nseepuWx5sjPNHWcMm3tGRDVysXTeuVnAxKC+P/OfSsXIpYfrEYPDyb2XLOUnTLEr9rdyUEhPktSUZU88U8//onrmKz+/1ExBh+EBg81uZlRrhXnxKSie+TnocnKmIFOUK0HBwDfB/EFYa4oCM8TCVvPiSFEh5OzFenbr1oVfgfcjzOIVqbN8QbQAYybZ0i9a0KDwXbzQU76SPtfDdoLJ/Ym4iTVb224zxNHtDcyufVz7JVVGA64pxLIYoZfvF3sYMYlV5XNxRvovvhbu1aRLz6xvbfaMlPOGDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:13:30PM -0400, Zi Yan wrote:
> erofs needs to traverse readahead folios in reverse order to achieve
> maximum performance by
> 1. reading all folios from readahead_folio();
> 2. storing the prior folio pointer in folio->private;
> 3. traverse from the last folio to the first one.
> 
> Add readahead_folio_reverse() to achieve the same function without using
> folio->private.
> 
> It prepares for a future commit that replaces PG_private checks with
> !folio->private checks. After switching the checks, erofs's use of
> folio->private without bumping folio refcount can cause unexpected
> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> reachable.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  fs/erofs/zdata.c        | 11 ++---------
>  include/linux/pagemap.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 74520e9102596..b59f2745a8e72 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1902,21 +1902,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
>  	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
>  	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
>  	unsigned int nrpages = readahead_count(rac);
> -	struct folio *head = NULL, *folio;
> +	struct folio *folio;
>  	int err;
>  
>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
>  	z_erofs_pcluster_readmore(&f, rac, true);
> -	while ((folio = readahead_folio(rac))) {
> -		folio->private = head;
> -		head = folio;
> -	}
>  
>  	/* traverse in reverse order for best metadata I/O performance */
> -	while (head) {
> -		folio = head;
> -		head = folio_get_private(folio);
> -
> +	while ((folio = readahead_folio_reverse(rac))) {

Yes, it's needed due to EROFS compression metadata design and on-demand
partial decompression, the last extent in the readahead request can be
parsed as a partial extent (means from the starting logical offset of
extents to the necessary offset.).   Since there may be many extents
in a single readahead request, so it needs to iterate backwards here;
but the actual compressed data I/Os will be issued forwards.

Previously I tend to avoid touching core-mm so it uses folio->private
but if MM folks can provide a new helper, that would be very helpful
(one more words: all folios are locked in the forward order previously,
so it won't have any deadlock risk).

Thanks,
Gao Xiang

