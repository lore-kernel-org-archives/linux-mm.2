Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6937CC47BF2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6236B0098; Tue,  6 Jan 2026 08:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B905A6B0099; Tue,  6 Jan 2026 08:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F976B009B; Tue,  6 Jan 2026 08:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 975426B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:56:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14E6F55D59
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:56:30 +0000 (UTC)
X-FDA: 84301688940.29.E04C6E2
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 086A940002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:56:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HtKvNH8+;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767707788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9U1EgROnTPgLiCYOpEnaofbmAnZpWUDuK849oJPJ2s=;
	b=b6jP7l/zYEpV13gVc0WcrB96bffZwEeDiwWhebIoEHq0iEPCQCursL2+h9Z6KNemJyh67s
	BcIK7VQa9nkyt4ozFJaD2u4BPxqkyJ7LFJ8xHkQ9z1rFYbdUWq2zxPH633zoEJ3CZ6TU7m
	VJtOVpQVOxPmUG1CsvacPRUuYMZasaY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HtKvNH8+;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767707788; a=rsa-sha256;
	cv=none;
	b=nMYLBwGTLnraFQ9IKAbU+e00CwNQ+37PY0wZyAoYIOsRLbOJNFi9s6Tq7yqsLjL9r8hSjA
	zz3Q+WBoC/rbZUqLU3Xn6Rx5hDE4rJt4/YbMYnf0wlt6JJUudTM9z+GIr6f6shFGTbZMsY
	qicu86gouJdL29KNWpgeAAhXT9dZy5Q=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so8209435e9.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 05:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767707786; x=1768312586; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9U1EgROnTPgLiCYOpEnaofbmAnZpWUDuK849oJPJ2s=;
        b=HtKvNH8+ipg8FQ8UR1dpfTjeHPnSyASHSW6m2fBVGToWiWHK6OCgDTXRMhN5PBdcXf
         if+at9K2XWiXHE1vQ1f+4dxUNtQQC4S1XwzUJgFuXPR6AvkCmxSmD2IQPfG4Fpyd/fwA
         H2hAIbIGCHP60/TcEowZD0fF/0bQZfxOEGUOmLD76Z1k8UfDZq+rpuKlufW4I49zznm/
         mIZ5jnxEylbMk+tGDIrTf1f/gqBSl6CvUd3Vs+tOVnRLvK4RYeTWn/3Sc8/ZWn2Lu8h+
         ul/fT7tSk0ABIYTDb2pyJ4I2tV6Lcdh7AfGao0+Y4xBvgnRdLft7wUxfwnQTgtd+d6cN
         dpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767707786; x=1768312586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P9U1EgROnTPgLiCYOpEnaofbmAnZpWUDuK849oJPJ2s=;
        b=dYi9x8UmsDwRCsconoDzLaBEew4ajQPi609H6ZS3kof1MZH5NctCpnlgz43LnVo0UZ
         sbqHbiXc/0HIbfRY70sb6Gid02LfqPmZOePbqe6BrHlXIEP3ZgzzfVXUaS30rv9oDTOX
         Z8TlCFIrC3F/Ud9HB2Abn5tJEUAmDQoDpL91cbHidLcdAPpYEx4QCHUli51gGQoG8jy2
         65ItqYNgy7Cy7XiAmlTW0pw2RsCXUWMcN5i3Jg5EEfaX+vH2qi6lMGuMTfky3PerzoQI
         lEhPeX0A6AWm7rpAu8X8Yy9VACSL6gJDzUROG8oUhR8jMt90OLNCU2qdDcBKjkhCnRBp
         KCFg==
X-Forwarded-Encrypted: i=1; AJvYcCVza1SSMNh+T/bYPUbMX3MtshqYIvkS6eg92Da4toTfhkn3sKmgQikbaZ1S+Tgiv+z/HLIHdbROTw==@kvack.org
X-Gm-Message-State: AOJu0YyCiaaRILS59v8Yl4yNP1G7hUU6VCTb0zdlYe8or5ahWKkaFTum
	gvmzNZoM6tEgHOoQmnRhMUZc9mfboDxjKNvcK07SWfBgqKguJvqOANDuQoE2biiEUzto6Jpj5tD
	HQwcd
X-Gm-Gg: AY/fxX6KtxgGCqfg4X6gGy4Luq9wDYW+d0yZYIBJ/bCLT84wvyms1W5P2xQSJuB3MpQ
	DP4YdGmWfMQu0TlyokZ3+3RodCBOcifx7ufqUEClACeAuRot1xiM62QSKJ2IMYLeiUcfpSv4FG5
	XX/wWPcr67iWA6HXT7Snxe/IQttILQ4f7j8GZYnaNBaDS4nPQyrCJUUqLYxVqt/FXsMThT4m5KJ
	iMbVrWBYYULdQct9OffDlahfPc9w//iSYVcz7P6ArNx7td6R+xsG0GfRCxtnDGTigX6eGTOIzfP
	GLuGfD42noQIpwQuAPC9wVWe+Hm5Bdkluu4VE69djprhdhKqQY2CrZ4PScx3kWrPSr9eGdEXxEH
	XpaJ2UcqOM+Ti5tym+bcePSs5vDhzNJESqenqMVCrpOGvV6yMGLz1TCIAkwMEVpjqCbI7QneUU7
	iHu1H/psfi9ml1qOmPDd1hEQ/k
X-Google-Smtp-Source: AGHT+IE4XW8UA8O6FTFvSLSZT78RW9Frwzig8Nc3GGs5Vr2i319n/ah+9CnKoWL5u7mLcYdyy95I7g==
X-Received: by 2002:a05:600c:5306:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-47d7f067283mr32135105e9.4.1767707786371;
        Tue, 06 Jan 2026 05:56:26 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e6784sm4449493f8f.19.2026.01.06.05.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:56:26 -0800 (PST)
Date: Tue, 6 Jan 2026 14:56:24 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable v3 2/3] mm/page_alloc: refactor the initial
 compaction handling
Message-ID: <aV0UiNM1BXo17meQ@tiehlicka>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
 <20260106-thp-thisnode-tweak-v3-2-f5d67c21a193@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106-thp-thisnode-tweak-v3-2-f5d67c21a193@suse.cz>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 086A940002
X-Stat-Signature: u9ac6egsq1tyhbtejyiyhd1a3eexrd5s
X-Rspam-User: 
X-HE-Tag: 1767707787-282934
X-HE-Meta: U2FsdGVkX19wRRV8mAP5Xv3BC+XyHDsXBLN/E7NxFz1ed59I/yZI4m69jv7Nwr7CEj7axJt6gz7iQo9T+BR+wXxzjeQhDe/XMHjImgLG53pCy//I4yZ0Ay15uEGqvmEpcIjyzgpW+0MNGWCerhK1J3rZbKE8EWQzyhH6PNIfotW/JaZjsO7OLLi+CSUAXWht/8TzZhGfsXqZBm+QnUrueV52YvwJ2QnooWR9gP/m8xlJlJRORpkAlSUdB38afjSRN2CBvddvHqTsiOolTFhU6Ga5tRhr6aGW1et9Xyi00EtOsnQR80FTnKSB1sylMvp23XgeqW2nfauVGeaAKt4dzUnYOIfnJJzUPfmeSGxPaYeW/xDF51VAxfeZupmJM6FhIAaRjRiR3IUGyMnA9FX9yeth+r71qXbGnQ63iDZUQsnGa1VUSbBdICh5YyriNOU0sAaSWD5CKc+45LEM+BO60aK118qdCvEcfoddmK9rma3NhJM7xadPNrQRTjLhs/fW118NWQbBS7exZwCdKk78qB54Q7PMxQsjHbwxBWfV52ihs01iJJ9jDDhIxS9wze2+uVi3dnyAS2a6TYGRC8BtHFQzsw5eBYlNT4v7H1Kty8AT9spjFvGUFOQuhAzxRp3CJGE2p8G/7ComjOV0bKL6Yd+caI1+C5MRa4FG3JFoHsLimhUg0omPXOB9Ab5X2jht1vV2LeBISEd3DJ0Lg5lclLz6YImggn7552fHcehHfe43pmrNZ4ASihVlVCfWz5uNpsrqH3Wa9izkZBjBGXGD1ikamAGL7jrpepPa5jkKPGGzKZ5NCKPnz5YsWTbcb67FiQxJ6ZJB/vRcCV2/CggXlKQmYhRamJni41by/j9aTAdrg714EjSuY0EGDeQHsI+oRmhDmtNa692w22MThO+TkOcndaJdwNQXHOXYddCQTagjF8ppRaiYSjcCECYsgNwiT0zRXjbn2Mz+mlPyQxs
 sx3S4cyZ
 doBfYKRTE0v637CtBBdHQ+qPpgdc+cHULQhkh1NRiNMvOTgnSXgIA0YgukWm3tEsHd2vVjVYN2vaeIcPYtE0WqIDj4rq0MrqNjAU11M1LHVkawHdPW12ySmXT8bO5y3CdkfwNncpN8hJLelhh/C6SpqU4cDn1WqrpMWbNuP4+RrzrSmTzGH2cO8AhaVV0n7bIVKK6DPzXXWv4oVl7iUKOjR1Ao64uWjBgxQrlXOW+WoEMCX0u4YLzjHLz9lSvJuzY77G7YoEBg00Zpa0CDP/LNbyrjOgCT1fFaoDf9FTwZQB+eCepE0OmyV52sRtH1flda8KEMQ74VMcJb4DXwh3PqUL3OmxQccCkD4aqJ49cuOIKMZV/t3yWn3sQpcfULm/gPNbcAKXnWmtyPUbCtEjloRAvyf7OK7c0YPMjOVPVHjgMEM6WkWgVNg208PQc4PD+W7aDPgiQXhu9l3F7NDvVxqek41vhc0v9k7Waf3HtmFBjZU/wPWiq/aWvdFdFUDaYnQxA7QdaS9XaC+oTzEjAE1vmZIAGMvcrkKLfAaMDo7PXFKVedDB+CCFEWIZryEgAUFM/nzsdczA2GNETWhl5XnTqhkQKcNcZp3YniQuxhF8qbUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 12:52:37, Vlastimil Babka wrote:
> The initial direct compaction done in some cases in
> __alloc_pages_slowpath() stands out from the main retry loop of
> reclaim + compaction.
> 
> We can simplify this by instead skipping the initial reclaim attempt via
> a new local variable compact_first, and handle the compact_prority as
> necessary to match the original behavior. No functional change intended.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

LGTM and it makes the code flow easier to follow
Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  include/linux/gfp.h |   8 ++++-
>  mm/page_alloc.c     | 100 +++++++++++++++++++++++++---------------------------
>  2 files changed, 55 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index aa45989f410d..6ecf6dda93e0 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -407,9 +407,15 @@ extern gfp_t gfp_allowed_mask;
>  /* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
>  bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
>  
> +/* A helper for checking if gfp includes all the specified flags */
> +static inline bool gfp_has_flags(gfp_t gfp, gfp_t flags)
> +{
> +	return (gfp & flags) == flags;
> +}
> +
>  static inline bool gfp_has_io_fs(gfp_t gfp)
>  {
> -	return (gfp & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS);
> +	return gfp_has_flags(gfp, __GFP_IO | __GFP_FS);
>  }
>  
>  /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b06b1cb01e0e..3b2579c5716f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4702,7 +4702,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
>  	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> -	bool can_compact = gfp_compaction_allowed(gfp_mask);
> +	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>  	bool nofail = gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>  	struct page *page = NULL;
> @@ -4715,6 +4715,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	unsigned int cpuset_mems_cookie;
>  	unsigned int zonelist_iter_cookie;
>  	int reserve_flags;
> +	bool compact_first = false;
>  
>  	if (unlikely(nofail)) {
>  		/*
> @@ -4738,6 +4739,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	cpuset_mems_cookie = read_mems_allowed_begin();
>  	zonelist_iter_cookie = zonelist_iter_begin();
>  
> +	/*
> +	 * For costly allocations, try direct compaction first, as it's likely
> +	 * that we have enough base pages and don't need to reclaim. For non-
> +	 * movable high-order allocations, do that as well, as compaction will
> +	 * try prevent permanent fragmentation by migrating from blocks of the
> +	 * same migratetype.
> +	 */
> +	if (can_compact && (costly_order || (order > 0 &&
> +					ac->migratetype != MIGRATE_MOVABLE))) {
> +		compact_first = true;
> +		compact_priority = INIT_COMPACT_PRIORITY;
> +	}
> +
>  	/*
>  	 * The fast path uses conservative alloc_flags to succeed only until
>  	 * kswapd needs to be woken up, and to avoid the cost of setting up
> @@ -4780,53 +4794,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> -	/*
> -	 * For costly allocations, try direct compaction first, as it's likely
> -	 * that we have enough base pages and don't need to reclaim. For non-
> -	 * movable high-order allocations, do that as well, as compaction will
> -	 * try prevent permanent fragmentation by migrating from blocks of the
> -	 * same migratetype.
> -	 * Don't try this for allocations that are allowed to ignore
> -	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
> -	 */
> -	if (can_direct_reclaim && can_compact &&
> -			(costly_order ||
> -			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
> -			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
> -		page = __alloc_pages_direct_compact(gfp_mask, order,
> -						alloc_flags, ac,
> -						INIT_COMPACT_PRIORITY,
> -						&compact_result);
> -		if (page)
> -			goto got_pg;
> -
> -		/*
> -		 * Checks for costly allocations with __GFP_NORETRY, which
> -		 * includes some THP page fault allocations
> -		 */
> -		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
> -			/*
> -			 * THP page faults may attempt local node only first,
> -			 * but are then allowed to only compact, not reclaim,
> -			 * see alloc_pages_mpol().
> -			 *
> -			 * Compaction has failed above and we don't want such
> -			 * THP allocations to put reclaim pressure on a single
> -			 * node in a situation where other nodes might have
> -			 * plenty of available memory.
> -			 */
> -			if (gfp_mask & __GFP_THISNODE)
> -				goto nopage;
> -
> -			/*
> -			 * Proceed with single round of reclaim/compaction, but
> -			 * since sync compaction could be very expensive, keep
> -			 * using async compaction.
> -			 */
> -			compact_priority = INIT_COMPACT_PRIORITY;
> -		}
> -	}
> -
>  retry:
>  	/*
>  	 * Deal with possible cpuset update races or zonelist updates to avoid
> @@ -4870,10 +4837,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		goto nopage;
>  
>  	/* Try direct reclaim and then allocating */
> -	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
> -							&did_some_progress);
> -	if (page)
> -		goto got_pg;
> +	if (!compact_first) {
> +		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
> +							ac, &did_some_progress);
> +		if (page)
> +			goto got_pg;
> +	}
>  
>  	/* Try direct compaction and then allocating */
>  	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
> @@ -4881,6 +4850,33 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	if (compact_first) {
> +		/*
> +		 * THP page faults may attempt local node only first, but are
> +		 * then allowed to only compact, not reclaim, see
> +		 * alloc_pages_mpol().
> +		 *
> +		 * Compaction has failed above and we don't want such THP
> +		 * allocations to put reclaim pressure on a single node in a
> +		 * situation where other nodes might have plenty of available
> +		 * memory.
> +		 */
> +		if (gfp_has_flags(gfp_mask, __GFP_NORETRY | __GFP_THISNODE))
> +			goto nopage;
> +
> +		/*
> +		 * For the initial compaction attempt we have lowered its
> +		 * priority. Restore it for further retries, if those are
> +		 * allowed. With __GFP_NORETRY there will be a single round of
> +		 * reclaim and compaction with the lowered priority.
> +		 */
> +		if (!(gfp_mask & __GFP_NORETRY))
> +			compact_priority = DEF_COMPACT_PRIORITY;
> +
> +		compact_first = false;
> +		goto retry;
> +	}
> +
>  	/* Do not loop if specifically requested */
>  	if (gfp_mask & __GFP_NORETRY)
>  		goto nopage;
> 
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

