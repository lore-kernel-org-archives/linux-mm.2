Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60791106B53D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3446B0095; Wed, 25 Mar 2026 10:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D8B6B0096; Wed, 25 Mar 2026 10:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF52D6B0098; Wed, 25 Mar 2026 10:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97EDA6B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:06:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D3948BA12
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:06:28 +0000 (UTC)
X-FDA: 84584760456.22.030002B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 32CAA40007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:06:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OE+25jXK;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bq9ZNTq/uyUu7Wr/pg4WndimsdTiR56/R9l8h8MCefw=;
	b=TbD+x3Ugn7PscC8oGT/SgZnjgE/3bIzvmPzhkgppc1xbZqpDyHmSYb62+09LB0qxTwaxJ5
	9uiQwNoolR04NOBkBh8Y63VQY+CpXE1l1sF4SjCAcF4i7HH6M3kqyemuyRBo/yCD9U8C8R
	PziGlrYgJlRmhi6aQA7qN5NZe93fkAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447586; a=rsa-sha256;
	cv=none;
	b=nh314PqNDtQNXgSspK+vWdhIM3qQmVXmXZ2eYzS2bcq+L1dgBPQtEsv+eblSRuHntlqeTX
	xrOTgCSRtmbpdtWRKMZowMSsXhypbj4AAPnqtCZMyJpAX24gIj5xYfADHcrcWI6RFn/Imo
	EP6/6m8xnQob1jDc+QwRx4LnK6wPivI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OE+25jXK;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2B9E43C7E;
	Wed, 25 Mar 2026 14:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DECC4CEF7;
	Wed, 25 Mar 2026 14:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774447584;
	bh=2zFYnK3If3R/+VikmY1WNt//lwRC21G0j8XDz06ZRpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OE+25jXKUV/hrSVrmqaOgdXoJFIFbgnP2O8EbYvWeib7aNojSCZo3diNdGytffiaQ
	 /WoxXzK2pth0a9wxkH8vzR1FJoPIgV9/pMcjom5cUO5EQlIAVZR30odM6TvtyzQLBs
	 vrpn0C6clpUG2E62g24wFre40JibMSz9eQTtk0ejODF7yMt61xo53JXSyWAddO8xCy
	 GGgTbMSTXuLcHLZs7JhnCNetGdNznFuf3oU3d0t8/HVoGPnpl2ApkLgFlePsBKEG9R
	 mOMsxKBNxK8vbhlwNHWL3bhZ0/I5//Arn9DjVQfrizfK9JXxQmrV+po7kLPkZ98Dur
	 6Qx60Krmg131A==
Date: Wed, 25 Mar 2026 14:06:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 1/4] mm: khugepaged: add
 trace_mm_khugepaged_scan event
Message-ID: <37b02aa8-164a-43cb-a45e-96162b9da38e@lucifer.local>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-2-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221093918.1456187-2-vernon2gm@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: mten6rh8bs5zp9cmin5uccmx8ub71bs1
X-Rspamd-Queue-Id: 32CAA40007
X-Rspam-User: 
X-HE-Tag: 1774447585-631378
X-HE-Meta: U2FsdGVkX19AvkOfvBvwPrliwRPNA40EKTf9FayFW/0B5+y9bK6Nk1ZCKD2aDowL9YSr607VTj4XCuZ5VJ8QldC5p1szR5lsYNJVeBqrRjKArOWNHNjvg96AoXj0dvlSThO5WWEbt+YU9rUGqwgf/LK0zRK0YjVP+5uJBrJmAzl5B5BPg55Hfr7dLWAUwChJmtEER8a4FRxJbHBA6MMD77KxZ3T8urPr8OPJbujOXnEPVTggf/6M7qb5hgaax2T8S+ayk39wF0DQ2Ja5T7GKcaOoRk3KnrV0Ju/L42OcbxKHHaV2ZewFZnLm40jsCUL4s/V3NBRbNtAf9SzCq13tLrcUeKYImKRMUUgb6xkFThV2JjNpF07xWueGmrwauRvc6MXyYXlMtuuHYmBnPajEQWiuyrj0QmX98XV1RXDhhYmF12qq4kTQK8Rz3TKbm4QC0xzNUC6ZdhbvzINa6NCpr4Pp/IOUoyfaqwP2AiWQcBn2tq9bOwkEbdR2UAJaehozMygOVA/PKxvJg6/PmYoVebXLJvl3Vb3sN9y6JJed2muEnQKDN6R/QfX5mAY4DK+LgWaSYEQKyhhrx7wIeMePdjgAp2GMfY1LLJOEZdRk1sjWvgveOtyalJP+lG1tHMNsFMoYnc2WHjcwVj4XHfDWw9aA2xs1iTOctp7KWY9b9t1MFxapUsHaLA5zazOcLKdDEtz3KlwNZFNNxu0xXGPWhGH1FPUJWiGwKwg9r4ME4TP0rk+Omhj2SLtw48mocItYqqyFsEywwoTHDTuY80EmTcz7tJLqEj06sRUfXMYATdWur927m2vPpttIcOMGDNIArpw3sO1AMPNENGNyXBAhxYhcf9phpvBSNO4xC4kI82K6dj3L8khR75J8ZOCzv094UxbqLy3GzbNWpsQ1WP8tV/MYFwgj5+3ktx2uVTbqAGJUvHM33KKM0lKmbiyXRI8NkY4vE7n9o8XBYw0Xd7w
 VOqsXlr9
 W4vyRmsXBN9po+9bUpXZkUwcjhuK0eotNowMrtoe+WlOLh7GUCxE/J/Jw3sfFQFemmo5DakyRuoISsYfTgNBiU8icc5mp/+r6JrItBP6Ft+wgh8WTq/MlSOgL+J0FIy8z24c2+QOstYOn9Ax08h/1r8sViayDVpPvAg8m7l/5Y+1jACuO5XtrXRMcUo6317HhKO0J/QibhIOdLHIj8BP4g1lS9Yglfmb9wfEXP71oZvU0eyT3W/zpsDtMmd2xCkem8iU7yG+jWKdccLVjxPa00LfEO9EcXFTynq7L3eKA9LJ8RDpat/kWxvUSfawBJjO9Tyb002i67+jputL+cuA8knwxeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 05:39:15PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Add mm_khugepaged_scan event to track the total time for full scan
> and the total number of pages scanned of khugepaged.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/trace/events/huge_memory.h | 25 +++++++++++++++++++++++++
>  mm/khugepaged.c                    |  2 ++
>  2 files changed, 27 insertions(+)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 4e41bff31888..384e29f6bef0 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
>  		__print_symbolic(__entry->result, SCAN_STATUS))
>  );
>
> +TRACE_EVENT(mm_khugepaged_scan,
> +
> +	TP_PROTO(struct mm_struct *mm, unsigned int progress,
> +		 bool full_scan_finished),
> +
> +	TP_ARGS(mm, progress, full_scan_finished),
> +
> +	TP_STRUCT__entry(
> +		__field(struct mm_struct *, mm)
> +		__field(unsigned int, progress)
> +		__field(bool, full_scan_finished)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +		__entry->progress = progress;
> +		__entry->full_scan_finished = full_scan_finished;
> +	),
> +
> +	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
> +		__entry->mm,
> +		__entry->progress,
> +		__entry->full_scan_finished)
> +);
> +
>  #endif /* __HUGE_MEMORY_H */
>  #include <trace/define_trace.h>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c0f893bebcff..e2f6b68a0011 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2527,6 +2527,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  		collect_mm_slot(slot);
>  	}
>
> +	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> +
>  	return progress;
>  }
>
> --
> 2.51.0
>

