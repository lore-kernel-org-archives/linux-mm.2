Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C781D609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9251C6B0005; Tue, 16 Dec 2025 11:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2A66B0088; Tue, 16 Dec 2025 11:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2386B008A; Tue, 16 Dec 2025 11:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6926B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:26:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17C6A1364E4
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:58 +0000 (UTC)
X-FDA: 84225863316.17.1461A17
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED6774000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LakawfCU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765902416; a=rsa-sha256;
	cv=none;
	b=44WJ50g++mCMUzX88ouiS0/svhT3IqmZsyzdz2kDid/s+7PpDzljgXkOUgUPkYsZNCz9ZL
	/bSjB+YCi41QhwmhaQDdQWGybwF8xQAxi3852rHyj5OeiujHVqkZefkb1xb8sgqkNJi3Mh
	4rEFuHMeMT6lAsr9xtrsaP2Ycf+7Gjg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LakawfCU;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765902416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5R9n7vu6tW/OHWiM/k90ITG3OaA72GmenJa52OTLyE=;
	b=MO5e/2gU+YPeAjrDpfqJY8InXD/2UMsO4SXvcPL399TpTF/Q45Ft7sILujDVIj6LHDlPzO
	TJPW9n7br4Xr4RiBZ7V4z+ULNJRzb6vSaPJR17stCJ9fkps67rUD/SMAFKyuz/gXtt0hPl
	yzDn9vFCWIc5eiOWiaYbT0FVSeUNjDI=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47774d3536dso48057595e9.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765902414; x=1766507214; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E5R9n7vu6tW/OHWiM/k90ITG3OaA72GmenJa52OTLyE=;
        b=LakawfCUu8RMnfWUqjHstBxDfeb1P3eRxwWjo2ixsxVj43Pw3RyWU6JZTdLmomQ0Nj
         XspT2OYaHPfEn4YHeORDPTre8jUv6ORMHwwwplSeY6TSAZGGOyyN21LszY4jC5b6WQOl
         jThPTWAsH0DPwOqOOGxbeA2DA4i+5K8CJbBiKMuqfQnwtYgGp1Xr7v1CSlEt4tLYIsZu
         xOvM2tc2ZRGVBZGCetolcjmQfFFqBCFl3BnvAmz8O9Br83CYSLnsx9xqBzoIwkEBVdPp
         ++YoIm1loUp/IZG26nIClqWB8GaGr5ktxxIiGEixNyO0g69UW0PZ54jvvvcJSpstGgyH
         Okpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765902414; x=1766507214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5R9n7vu6tW/OHWiM/k90ITG3OaA72GmenJa52OTLyE=;
        b=XZC279t/ZEfVouavbRwrtyNf4bm5FATWeVvvoc270Fo+tz2/9ZvGhCYJth4Z0lj985
         ymCHqZcT+PZEXISHzXgeR/WwwXmvwOE2CxboiHf33Ea26bPd6GrPJjjU4W9I/O6hqH6j
         Npv+XcwRQ0+nbef29/t2zgpw1LVd3Id60dxeeB4om8LgIpqS5B+QXVCBTyL/ujWzoJFU
         Kko4ayPcUub8oBZSG3tY3dUoqLTmYD0dWVz7vU6bD/9pKcYgxZfmGb3C46tgs/A60uZ0
         8cUa9NYVHxYZWDuHSlPObbfwq3xSf9OPAEHGzk/c/hssMfvl8Qgy/gZmiN8lNpQSkYos
         Wx/w==
X-Forwarded-Encrypted: i=1; AJvYcCVY6MY4qNS8raa71tKauDXYCOtkwVntKQiOMj8dh6lg4QmwS281x+SphjDGOtgBLDb9w1kMEEzsAw==@kvack.org
X-Gm-Message-State: AOJu0YyiM6UNuE7cjcG02mnJ6y3RKeVdIzP22rb3WU85dtyOqP497u8P
	UcvruYJNWbcHdYZUP9tKMEoPxW0oMD2ffO7sFJpBukY+qeMN+m3ibe61dCJwKz/2Sw8=
X-Gm-Gg: AY/fxX6Lejc3kChZQqSR0W2rXOkETz3mnMRNRS4WEjV2UpNj1fcv030P9Df0qgZ8Htt
	xulYwKLMewzvm6RfXnymyh/qk3LCTGoJq4zJ7pNOuDkk6mGiGUk3uK5rYiuNEQjpxh/G7tQ+F2M
	y/O/oyuwRHL659SRXBPArBn47GQHRu2s/OEP1ZBn2kHl+Bg9eT//rQpW1JFQ6tsY6MsWm/OHlJV
	7WPmZxrEHQI+5m2baBwYwwdrKLC3oK7jkuaalctR0dy4DRzyTkgmlOJfD5LVqAe2WKJNh5GY1rB
	vWryIy1mR2qCCaUVZuihWQEjo8hhtOvaqqzDWmsu40CEwbmYzstoOL4/vUU/+cNFi65soa2XVfA
	a7OoXeIQfETWsJpn5yNH5sgf0L2kbqf9R6TJU8PSOOqGQapBOL5wjcoB+Ap+pOCAog6463N869I
	ZrCM1Nfn5AdfpJCljbt6kSxKB3
X-Google-Smtp-Source: AGHT+IFvLlR00lt2kRJuMaZoAIYLTGi3fW5Ga4GI8C6RIk+IfB2krj/L5y1GM9Ql+05OAjjWTfxFQA==
X-Received: by 2002:a05:600c:4e91:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-47a8f2c2f62mr156327895e9.13.1765902414286;
        Tue, 16 Dec 2025 08:26:54 -0800 (PST)
Received: from localhost (109-81-92-149.rct.o2.cz. [109.81.92.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f775012sm246018635e9.7.2025.12.16.08.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:26:53 -0800 (PST)
Date: Tue, 16 Dec 2025 17:26:52 +0100
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
Subject: Re: [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for
 __GFP_THISNODE THP allocations
Message-ID: <aUGITMXjCWdCA22R@tiehlicka>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
X-Rspamd-Queue-Id: ED6774000B
X-Stat-Signature: ot66j9zanidqk3axnmhj4dyeaw6tkuey
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765902415-610486
X-HE-Meta: U2FsdGVkX1/2UvVMF0d0Q1CbNBPE5A07YydEiHmOWmHfoYSUrGFd9pSC/AnfNZfsNHDEdcSfY9aeBe5JeYr+cy/wz6GhtVIScMCi/NVQC5B0w008rV4ToKIAY/SN7HtsjYpfHmwGnV3c4XyBZ5UfFV0EE2E2TqJt+D0a7jaRmiJBuFjQ3V0y3u/OdzCfe3XJmaZdWvpMcr61MOPJPFe4DV7eOM8iMAKszq72n0rnIOc2xEeWJ/s6I9Qconm88NDvf4PNcHB7GgNAXRQu3AI85or8UB0n2Ux2XTYflNB0CdCE7dFNDxotOFWX0Bg/nE/NPUtztv7aEaz4z5RP+RLh8xWtUUMRL0oJD8+AZ5vnpNPBkpWnQgi15KNFpTKsVDSqDDuAZEw+PjRR7k6+IK5zNYTpGfHp5671tw2ZUnZg26hS6UuxXwd8s+szoiTGoVu3u3FabkymsvZVqydZoxn/A83+gtzdtjjLVPn4t1VI5fEbK95snEvLAr9fpA0GFoJQ/K8Kw/Xoj/Yk3gLZe1NbTnCmUinXe35n38nfzNYKH5OB0azgem3QRyh/RPh9qw1DcAhKtRukS9wgGQmv2XxKiADqDm8VAicDyGGI4Fl6viVNwlH27mU301cc90LIA8UchYkxqwyeSBvN4WcOOTkaw9ZHxvqBGVD+YTXxZ6mk4kYiLQk8oXHDEhlv2BScByofECxbQ7RtcNICG7Jpz67PBjF+EI6HJ21G3Sk8GtJ7G7lLkU0SL9Y19pyoLAbF+b+pHu+9CbfktmlC5KyuMuc8DJT+RPu9B7mEvyLr15BRia7wBSjFXs1itGe8OKrqjqrdGNbw+PNOMH41U9dqXaT30nWgrb2dXJzXsiQgm6qXUNTqxA0GkVkV9Ode+K87hLu4Oc+V8SwLfRBoJNHt+i1jPaghwov7ExnoTxjcZht4AhuXBcoHuU3ZbPJS2c2GzLHgEuuGqjXylkKPA7SZXD2
 HrGMsKfD
 sSuZSzWpJXjimaQZ/KG1j5wP49U21uTQtjtyFjn0DYLB0MzWx30dT2CgkVIyyl8LI8BT63ZEE3gj9MYJlXXtMIB64k25p0XiSuUsLeKTdzI4W24CiQOB1ljryZz2mg13pDzXatOcFcBryJjznBlj0vM9c9suIBVw0U9IQHrXHxT1tfJ13qOP0Htxf9VbfKaRfQfQl+ZDBM6m8REh0zGWpoKg8n5ZEV+rHXP5XJ7d9w7VkwgbUwFKawI/aRaOUZVxizGqKTw2i5xlbMQ58Rw41YAau0GXZz621dRpW/71ISP2widHVwBwTL7ZAj3hENLkL7jtf3rOdHsK+MliIjMtrprXiZgoWm/mhoVKyUR3rtbrpECt4oJN05+QlmiXDlZokOxOQ+vjMpM1wYhv+VWWgR2cka3UubRXsRiNfUnQKXHjMQbC4SZOIr5cFQ3rAhjesTQYpbDfA+spih8ow4IFBf83IjyOXhIWCibp7juXHkq4hRNy4KzEWKdwmXBFLe7n7mGboim8YTGJp3nRqNJRvxCxWgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 16-12-25 16:54:21, Vlastimil Babka wrote:
> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
> 
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>    allocation from any node with effort determined by global defrag setting
>    and VMA madvise
> 3. fallback to base pages on any node
> 
> Recent customer reports however revealed we have a gap in step 1 above.
> What we have seen is excessive reclaim due to THP page faults on a NUMA
> node that's close to its high watermark, while other nodes have plenty
> of free memory.
> 
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base
> pages), and not e.g. when compaction is actually performed but fails (we
> did see compact_fail vmstat counter increasing).
> 
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
> which is not the intention.
> 
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
> 
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0
> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.
> 
> Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Yes, this makes sense as an intermediate state (to make a fix for stable
and other older kernels that might be interested in the fix). I would be
objecting that we should just simplify this whole thing but you have
done that in patch 2

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
>  mm/page_alloc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..e6fd1213328b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4788,6 +4788,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  			    compact_result == COMPACT_DEFERRED)
>  				goto nopage;
>  
> +			/*
> +			 * THP page faults may attempt local node only first,
> +			 * but are then allowed to only compact, not reclaim,
> +			 * see alloc_pages_mpol()
> +			 *
> +			 * compaction can fail for other reasons than those
> +			 * checked above and we don't want such THP allocations
> +			 * to put reclaim pressure on a single node in a
> +			 * situation where other nodes might have plenty of
> +			 * available memory
> +			 */
> +			if (gfp_mask & __GFP_THISNODE)
> +				goto nopage;
> +
>  			/*
>  			 * Looks like reclaim/compaction is worth trying, but
>  			 * sync compaction could be very expensive, so keep
> 
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

