Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD033CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1336B008C; Tue, 23 Jun 2026 05:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982256B0092; Tue, 23 Jun 2026 05:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897846B0093; Tue, 23 Jun 2026 05:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED486B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:22:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEB27A0417
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:22:23 +0000 (UTC)
X-FDA: 84910636566.29.1BA6EB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62D4AC0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:22:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8hpzy7z;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206542;
	b=QIxAbyYU9VqG/k0A3kKvKQy08Z3nknofMQA+qv+ETOfS5eMsGt1dR3F7dphMuz59B03ugS
	QnCbLfYAPh+LcLOKJru2z2FudNmqhqVAU7cbXVCrh4CaIAWrV8X05MAzsD1yB4LOYIbmed
	LAvBDKzSBLahpxUGsQvgrN7rDCPR4W8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBpcs0qajk/9M9VthqinPp4H1eBZvLCPutJiaV40plY=;
	b=qQ9gpmG+GSS+Uh9+A8OSpBhVI8CNhS7P5lVFYA0Kcec3WRT1uLw3iZuRs+uXEvQOZ/9YYX
	IgzEunR0Bn9eDws0iZi0PDLJkkeEmOX5FSkYHpVTtyCnrmiZ1Xynwx7sdvjsdh4Iutphx3
	7oe3KGTuk37sORQyj9VMI562Pqe3Wcw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8hpzy7z;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C963960052;
	Tue, 23 Jun 2026 09:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0931F000E9;
	Tue, 23 Jun 2026 09:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782206541;
	bh=sBpcs0qajk/9M9VthqinPp4H1eBZvLCPutJiaV40plY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J8hpzy7zgrPLyOKzNzPWGy7XczPxu/Gi4VDBZC8FiWI9gEMMw9SmHNWcI7C9FdGbd
	 rweBuP241zwWT7zzsKO3whG1bkCJLVOrhzZotfuBzdU6njomBeeNnK+ThKDyhAj4Wh
	 fRnAasUlPcHvZzZd7ETJz9OmRuFyeSEVfW3mFaBEan4SSm7/JTbo2eYV1amahG1t/5
	 bVfq6mMoag0m9fs6zXHoFoNPKilqU5Lwi4bfWfaC5gB0aFQ1PjHeBWJ9UfmgIJ10B8
	 LHN16FCdNUO3W3w5wyYEWa32lATC3vR7YajF8RNHOvgSIv1hCXBynpHoztVcv2Wm00
	 b/+sNF+6fAvbg==
Date: Tue, 23 Jun 2026 12:22:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com,
	linux-mm@kvack.org, Yuan Liu <yuan1.liu@intel.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <ajpQR0hX681OryCB@kernel.org>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
 <ajk_l8cT0mIyhs4r@kernel.org>
 <20260623083507.kg7jmd7ofz3awqmq@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623083507.kg7jmd7ofz3awqmq@master>
X-Rspamd-Queue-Id: 62D4AC0009
X-Stat-Signature: xnt7futtk44y768igja46zdofau664kz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782206542-965910
X-HE-Meta: U2FsdGVkX1+LuKspErSi1UY/P+RuavEDJAgyZ2/m6gHm22JO2Ewb+xO8sStHncmKdxD+Kg0wEopANlFqUF9kv7rYSXad9fyPIwldVQOWsZ+VSL9HvUUUSaKjhdiHl9aBx78nnT1css/LoZF63qy0B/XHBn305QVdUoU/TPqk2i4HR2qBimj5jBUQayAvwa1Knc+VX2/WUteL6NaestO3yufNZO/+5gUj40+P3acPb7uyC0Q5kGfbs3bY/pN+YN5wbeEtNQWOT3FEZ9eL1AcF3pPg5+qPUVTsxIlVXoiDhhXYhJNtXYZDyR+XpJHbTajA6pbf2N3JZibsjpq7G3cq4gXlqDatMdd3RKfV1DoFMVjiBj+KTLUJuDBFCX1eq418vXpvcIHgAPbXVYqOK3lcHkqEC2qsGn5MhtW3X3ZKSzSs3N2cPwPkiSeHVP+mVN4Z6YBnQgqg9ZNTvHNdn+3A2Sebe4koIDmxy22le1zTTHAcNHCtQiTjfYkiC3AFO/4O7rbSaerqSAN4hCOW9EuPVDm/jaryhiqmeDV2M0l4shdUf/WRQEqXX7b0+KK5mqBtzgT6hzQzrGSkTWSUBZMp7dT825JosgJWozYLnWiAeiv7oNJDEb3TAWAoEOF399sIvvbLuFOk1eaXPxnb7dRpmjXBw2nizEdUxWNpMs11pCuupq44y8cBqUrDqNZ+6zAiD0S6iu0MVI1YEuiRDwa7GQAwoOH/X9vaJlGbBQ1NNrYCwUS4L6gaopOYXgXXqAo3I7bCvreVB1M4uuMz4iKWANG27MGrySSjqBSbfMwnYrAGletfJVtfjfjjw1JTcPYq8lVrKG3E2F6NqdJWcxyyl/5aY4Ed4XvIyJ6QnZQLjX9F5iDq+ePT0TFNSMw+rEglxzC1BfQIrE5c+5ZLRvbvvkfORjjWQf3gucBy9MjCULflghKHWQcZJ4GpFi/rxCuI+JXpXMwElRIZbeaxbbH
 c6959NGT
 J+9xNfFfQcPa8jciEy/poimnuk0GlLYWMSeOXWwBd6LZ/7FimgtS+FSwmaYckXMBXmIh+yRSm/G98kT2d3TN2bRHb0OERZUNMm0Z5dMUKniSNQWuJJFX0zfG+GvkwwdZv4HtJKGP0EMVn46N2UJXwToGxmSrD9zZ11w4xEAqPkJqWt8fUIcrvr0CW8nqvfCqPN7YSvL0Q+lWt2aUoQTBa99CpwZKPrEBRzk+k718ZYN+866qcUDyoN8IGi0r+Fgepa5XzLEI1xFtnLKa9lpipwkGthk1SUMw/JdD+OaSZoi5J/AAn13+yd51w1i4WOZc+iLLZnDVj7oSidddYj2QPH1bqaf1Gt3JjV8yNBhB3kVUmF7SE/9Or8qKqKZVwKYi9eJiqBcm6mj5rGM+vQDgTmH+RA0COxvYV1qsO/jewhQxVN8lamV1yhU8dzkm/UNUHkp+L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

On Tue, Jun 23, 2026 at 08:35:07AM +0000, Wei Yang wrote:
> On Mon, Jun 22, 2026 at 04:58:47PM +0300, Mike Rapoport wrote:
> >On Mon, Jun 22, 2026 at 02:24:03AM +0000, Wei Yang wrote:
> >> Current node_spanned_pages is got as a summation of all zone's spanned page
> >> in calculate_node_totalpages(). Generally this is good, but if we use
> >> kernelcore=mirror, it is would be wrong.
> >>
> >> As we already passed in node_start_pfn and node_end_pfn, fix this by get it
> >> from (node_start_pfn - node_end_pfn) directly.
> >> 
> >> Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >> Cc: Yuan Liu <yuan1.liu@intel.com>
> >
> >I queued it for now, will push to one of memblock branches after merge
> >window closes.
> >
> 
> After some investigation, I found current mirrored_kernelcore may still affect
> memmap_init() in some aspects.
> 
> But how to fix is not sure, will prepare an RFC for discussion.

After I applied your patch, I did some checks to see why
mirrored_kernelcore causes us troubles. I found that unlike other variants
of kernelcore/movablecore settings, mirrored_kernelcore creates zone
overlap for no apparent reason. I did some git archaeology and I didn't
find a justification for making overlapping pages absent in ZONE_NORMAL.

So I came up with this cleanup:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kernelcore-mirror

I'm waiting for the bots to chew on it before positing the patches.
 
> -- 
> Wei Yang
> Help you, Help me

-- 
Sincerely yours,
Mike.

