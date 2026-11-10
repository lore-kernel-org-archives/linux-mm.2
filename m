Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B763606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRR/ihPC
Received: by kanga.kvack.org (Postfix)
	id ABF686B05B7; Tue, 10 Nov 2026 08:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95E16B05BA; Tue, 10 Nov 2026 08:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE066B05BB; Tue, 10 Nov 2026 08:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 775A16B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:37:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11D9E808EB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:37:37 +0000 (UTC)
X-FDA: 85419311754.01.2AF54FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 66CC940004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:37:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QRR/ihPC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZHrabfWk4S2HUCqdB68Rskp0Af4pRxUMfzSm1U1JdE=;
	b=u1z8ufriXMLTWIhTChK7yhYR7+YOLHJgPgRPbsjn1RwVtmQb/XO5P9ZGJB3diTD/vBI4QA
	Tt0GaniGB8IrLiLr7MbwjQ765tRKVZVgoZkj81s/TbmKfoRBdEodnAeS70leTdzFK2rcKw
	0vnCyc4iHUAkBxMoMBy5n10VHW+PVxM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QRR/ihPC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317855;
	b=dcuIQiKLfRr7gKNWsXMnCa3RvZrXYucIc0SdIKa1r5UwBR14bMhujOTgeZuyuZhWMS6JXp
	qd64k8bHVRAWtHxfU0k9VABrf6YxIQJU9emPXpApPgiGmlqvgcJCLFsMzn1TBm4MVFi7vZ
	IeY39KyjF6XNFjGaHibu8ePBF6KznKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3FD641A0A;
	Tue, 10 Nov 2026 13:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0880C1F0089F;
	Tue, 10 Nov 2026 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317854;
	bh=mZHrabfWk4S2HUCqdB68Rskp0Af4pRxUMfzSm1U1JdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QRR/ihPCYTxS6rbD4+czUP/fyN+1My280e+0RDFv1ILWSPIXy1e6pJYallZfxpona
	 s42yRP8xnZvKzdGEmaJCk2DcEvbHjBAgm8/f8HaKuLgmmYNe+L8dJHUaeBqvWxr/jm
	 xv5n9hPYyaO4TQwWp8bBoY3qYs+VgmlrnhG2vwQVQm07tVfa8ovhpXCb/y7PCt+Gso
	 rbmI7FpZKlcDmugp0tBK/vzVs+RJxcZCFy9BDNNz8NXUeu2tdZM3QEL5KLqN18Ja1t
	 QTIlEJMQWFHCd2kjHbierwai3L+jWV7ydbgQn2hRhaqZxtylTaE3km5aTKDNhQGbeL
	 Y5Cmf+C+N7FVg==
Date: Tue, 10 Nov 2026 14:37:32 +0100
From: Harry Yoo <harry@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/slab: remove outdated comment in
 create_kmalloc_caches()
Message-ID: <avMdQuXxfqMCBbBA@thinkstation>
References: <20261104144753.2266231-1-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104144753.2266231-1-ekffu200098@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 66CC940004
X-Stat-Signature: c869muhcqkwyy41pgwtr8p4xeodix9bf
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794317855-629319
X-HE-Meta: U2FsdGVkX18i/rSy93FPQIYxGwmT977he2stXITBZRivF5tJ4Nx+bj+6o4FyeBAtGqlYcuCJtwhyCQEzNU0uTiKVHrQqYwAp2SZedcT8kMNS/C35+k0H3nC8tz3nNuEwKFYg1Zbzx1S4GaKZqkOBLmcl5HfVItfQ0/eoD3V1jFjgh7JO1MvUX9THTDQPPLCpAckq0DYkiVVsJrUYg/8XtiCNzcuNcUaBxHlnfEvIbp30qjkhlf05ilVHOmKAkwZY/qbrh/FRa9wYy42qnwGzlVZRdmVEjG/S/xLVx6gp/9oSKj10J0o6hyL2BrN45simk5zxek2bIOftDqq0eKshafzJFvtDgbBK7KkZe8mGkmz4rs0VW6dSrnZVnPlCR3D2D0Dz1pX2nl7l3FmF1O5TMXwEmxnRxPkHiN4gGiGO2klRBqkh/aP3kfmS2Je35/9YGEXnwo5fqu6xZEMzZJRYLnoMlqwUsZkYd7XbBoc4BrSGq8ylA7Qde/tcjjoDK6Ss0kYHXow8YLGUzQ2GBkrzVD6OO8YnFp9HXdHwOgoNkvJGWvWcqIjE8ZBqrCydJUr8RCqm//MfGzQ0QLQzS6Pp+xVuWufxS2wMr0K9eAzMAv9OD0N6b50fjzvvK0ACYf/JMovhRwZ+CNaguAg3Xaqf8+NWIOEjte6GOZ7iBrrenriesg4SR3o/a/jYJWV1z1PxjJBvlQVkvewTYybEJf1zqnF07LZebU3+dMr990p7TPzaIw+j7A02in1KeiL47ps1WUGQBSIgR9t906SqKdwpSzjMmHq2wO0DdxetgUQCixhQmxt+7SX/1mwg/eYnsB2oUf3zR6lss30/U457348v6W4jakfspqGcLyAir7ZR6eQASMQzjdVd3xZEI/qpXhxk1+TcI0MCxkx92XnJIrzZlcoHDU5lH5C/Htmy7Uowv0U3bsEs+gtDy95TbiGQNcDe5XYqkKNFAauCgPs89IQ
 cf3XCDRK
 tAlgQVA4uDtQ/PIkimAfDeFYJ3Sx76kD8fkGCwweEHulm+N47UGmbDY09+4mj4P0QUfM8dc+O8sGJbnQFsC0q2uNC7P+5EPnIcPYpN8AaGaLdaPRWVHX2oVf+B6HnxsZaC+SlQ3OzNWNQvYwofu25pdaKPAPOSx/PN+CQwCE+GjAuOXcoez7EIbZlD93lWy7Gt59pO3aCxjQmXeXov5HO2Kk8rssfSSPDqE+uKGPvGMfDtvYY/928BJBL9svcyMUPeE2nL8Klo5CZMBz2x+0dQtg0xqIyJwBkjSkz7577Hnq/iosRmVKL9na6OHP9rpCswuoi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 11:47:51PM +0900, Sang-Heon Jeon wrote:
> Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
> removed SLAB, no kmalloc cache is created before create_kmalloc_caches().
> 
> So remove the outdated comment.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  mm/slab_common.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e66c0778ee98..c4a386f0dd90 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1029,9 +1029,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  }
>  
>  /*
> - * Create the kmalloc array. Some of the regular kmalloc arrays
> - * may already have been created because they were needed to
> - * enable allocations for slab creation.
> + * Create the kmalloc array.
>   */

LGTM, but maybe let's just drop the comment?
The name "create_kmalloc_caches" already covers
"Create the kmalloc array"

>  void __init create_kmalloc_caches(void)
>  {
> 
> base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

