Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E82E7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDB06B0099; Tue,  3 Feb 2026 06:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268316B009B; Tue,  3 Feb 2026 06:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1946B6B009D; Tue,  3 Feb 2026 06:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09D286B0099
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:56:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DB9D1A0416
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:56:42 +0000 (UTC)
X-FDA: 84402993444.21.7FB9C19
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9AF0A4000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:56:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kyUMnPpo;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770119801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWqw/j1gRTlIe46UH5f53YEvOj7+R72qSnwR1l4Nv9Q=;
	b=YHrOakufFQIts7zp9QHyeKAPGVL9khChB4MexosPJJqW+oNPoGmXH7YkWhQdKTSZSVcQ2e
	5e7Z5zv+rJ7Z1+3waWuO08RIX5FkzjJYD3lbLnh7MhG547JISat9u0lyyDwoOiAzu4CKRb
	A5xwbnTsu3W+wlxNFtfIaPGsynVFm6o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kyUMnPpo;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770119801; a=rsa-sha256;
	cv=none;
	b=GfOcOxlHNIjbstMEiDvHDk1eUDVAa0jsPUDycjjjmcNPHyNMV20lzXMJjyKGWXVGkPrH4D
	XGyb8aK7IKMpv2yXibpkRtg23X1dkPO22VYqfF0lJG4JkKbOHf+ioAGOze0mCl3ROfwifu
	SOyJOZ7REdMN1gV8QMacwhOmyruvV4A=
Date: Tue, 3 Feb 2026 19:56:16 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770119798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UWqw/j1gRTlIe46UH5f53YEvOj7+R72qSnwR1l4Nv9Q=;
	b=kyUMnPpomGjQmzJOIgQLWlsekzj4p31uxBZOyqU8+Iq0vrj008awc/B5WBV1Lso6S7agcq
	7KIv3mdfGzjH1GOFpzDaXNQg6aJazfjCljPDGTBhNgI1GYh47DA8sD7OSXjURoU7LOej13
	lp3ydX+XcWyF8o+p3nmm4bmKEBpKylQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for
 unmergeable caches
Message-ID: <by6wakewxlbsdypouzrxzns7ejkg2dsx7zgmbfcl772gpsrk4y@das2q2wrztbq>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127103151.21883-3-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uwubze6yzbqxpo6nsa17omn667ufbset
X-Rspamd-Queue-Id: 9AF0A4000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770119800-914934
X-HE-Meta: U2FsdGVkX1974RGPkbUrspKtGf6wqV2V9yEQE71ZoDXsN0PJjznbpwAa7dXgDcELFubN5O8inBmGyiOd1TvLv/2UMMRqUHNJXYJ4Zx3X0cRIASHHZQxgmmtBW+bXilIoECGMpawMMWlyUspEQxRzCQ+htAnu1Alz9QCvensdL/Etm0JkQtCMx+tznXBBaWrZtOQUGqgq2Q/LHtaVybEQj4IJOt+pkgYZX1rb9YQkuheAsZyoSY0TJfTwnXUV1DGDXcBs+7DxnEv4l40W0mSIRvO9WVDMUiMIGDojZxrpzmc/K8uKfiOgKu53121Tv54ge1KISlgnNyW1tOBudlelA/yEp1NqKygQVvw03bXmT8SXVYlRdGqVafBFZiq/I+NxagCOay3FSKU2jHnTycgPMX3skqWMFRXwddJF3wxkMGAUVDWl71Pvri1fDGPK1JKbdKjTjW/xuT3i/yId1oZ/rPLqEjx5Bawbz8Rqg6q4UcWXCzCtMC/OD0XjX9dJOT4JZCMUXCipU8efsr+lzyii8SyFkn8WQwNdniUGGyuGzYPEHUK/9La7EgOs2d+RLI3JFywiS0AQCl5DW4ZJs4YpgFSLUpQf7fx1Na7nHgOc8jt3QGsRg4GMlOJAVLlFAEIb6T3rffky8UOB47d4G1+bx++wU+kfV0sLdca5MnG5Zyqg3AxIuWaSy0lfM7yM6VMS0tEhjEjMnZeLmKQ5mZpYMmFewUPHqaiIKXcRCBPEBoUtizdYfVtUXCTsBHCihQh8XVbAMpqPzcQW+pYfW0u5u7CH8+dAb762Gv76NtIQnTUEWTp7v01NM/umHG76Ru3Tdjrw0vS8XCJ8eIl0l46z49tyll50br85lZZWIpisicpOTBTkzskIZeKFgcKUtWJ4fxGoTCbFaPaREiKUOp4mM1fyHYXV31r62dzG0bM0x0d+YkcfB45pYryigcYS16FlVfa3MDzlPpIwV6gu2EJ
 UlRLbAX7
 F+i+rjfMfpncByhfaW4PGTKN4gadZNTlEgVGyGUfPI95oJgE7aoYh5qOEq5WXIF+X0CBJFb0p8KdnIc5w2y29KIQc1IymaQxkZGmCz6w6VTYvvv4S9M53n3imYG49x4UH1pBnv/PvQ00agISvVuBLNKFo7n6yF2NlptetOUMg3A2U12z+beG832Hjs8pvctv8W4/crn00Ww4E01FXzjSglNA+ErEHwQ0Ms6c48zEHWm2FXTGDTASYnYJ7IAmj0l4KBlOPhlsTTDAX2oqg5HQqj/ljhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 07:31:51PM +0900, Harry Yoo wrote:
> While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> slab objects, it prevents slab merging because merging can change
> the metadata layout.
> 
> As pointed out Vlastimil Babka, disabling merging solely for this memory
> optimization may not be a net win, because disabling slab merging tends
> to increase overall memory usage.
> 
> Restrict SLAB_OBJ_EXT_IN_OBJ to caches that are already unmergeable for
> other reasons (e.g., those with constructors or SLAB_TYPESAFE_BY_RCU).
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slab.h        | 1 +
>  mm/slab_common.c | 3 +--
>  mm/slub.c        | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 8593c506cbf1..a5c4f981ee8b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -388,6 +388,7 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
>  			unsigned int useroffset, unsigned int usersize);
>  
>  int slab_unmergeable(struct kmem_cache *s);
> +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags);
>  
>  slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
>  
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 904414c3ebb8..d5a70a831a2a 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -174,8 +174,7 @@ int slab_unmergeable(struct kmem_cache *s)
>  	return 0;
>  }
>  
> -static bool slab_args_unmergeable(struct kmem_cache_args *args,
> -				  slab_flags_t flags)
> +bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
>  {
>  	if (slab_nomerge)
>  		return true;
> diff --git a/mm/slub.c b/mm/slub.c
> index ae9af184a18b..0581847e7dac 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7676,7 +7676,8 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	 */
>  	aligned_size = ALIGN(size, s->align);
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> -	if (aligned_size - size >= sizeof(struct slabobj_ext))
> +	if (slab_args_unmergeable(args, s->flags) &&
> +			(aligned_size - size >= sizeof(struct slabobj_ext)))
>  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;

Hi Harry,

This patch looks reasonable to me. I just noticed a minor point that I
wanted to bring up:

It seems a bit self-referential that SLAB_NEVER_MERGE already includes
SLAB_OBJ_EXT_IN_OBJ, but we're using SLAB_NEVER_MERGE to decide whether to set
SLAB_OBJ_EXT_IN_OBJ.

Do you think it might be helpful to add a comment here for better clarity?

-- 
Thanks,
Hao

>  #endif
>  	size = aligned_size;
> -- 
> 2.43.0
> 

