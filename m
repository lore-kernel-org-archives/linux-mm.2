Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402B8CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 14:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309D76B00AA; Sun, 23 Nov 2025 09:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA566B00AC; Sun, 23 Nov 2025 09:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFE46B00AF; Sun, 23 Nov 2025 09:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05B2C6B00AA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:49:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B155A4F856
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:49:55 +0000 (UTC)
X-FDA: 84142156350.17.1F26A6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1F3C180008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:49:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763909394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4cvivWmwYGBXRU3wFox0Kq+V8RUc49+msN6IT5nft8=;
	b=Fvs8nPZwsePWhMSBmxFuwTDOlStojWdfjdHpB6D9IZVH93QM6Cp6Oi/4Ro93ejlW4OFuZQ
	f5JpLLG9rfDliPd9r9sTA6HUqYIc+ldjzm//hJMXdSMOxyCc3vgdnnpMWsE/BsTAj+q5bV
	zIqfaoPmZ+6qMB4+gK30pxIfkBm4azY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763909394; a=rsa-sha256;
	cv=none;
	b=Y2MHbuoUQlSvUw6vJC0vKehMAFpGspr8x6gnHYBuEMi2PB1aQlPyOEGpMaa8q3/IZ0AMPe
	v1avPY23xnvhip8c5TeDfGEnqNuMs+EJmQy0srTcBTB2IsvM/TkACaZixZsh/6H0DdI/kd
	AWG35h2if50KGVcJlUfPvj/V7XFHVqo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57CF2339;
	Sun, 23 Nov 2025 06:49:45 -0800 (PST)
Received: from [10.164.10.248] (MacBook-Pro.blr.arm.com [10.164.10.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36FA13F6A8;
	Sun, 23 Nov 2025 06:49:47 -0800 (PST)
Message-ID: <57cbf887-d181-418b-a6c7-9f3eff5d632a@arm.com>
Date: Sun, 23 Nov 2025 20:19:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: fix memory leak in collapse_file rollback
 path
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, shardulsb08@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, janak@mpiricsoftware.com
References: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E1F3C180008
X-Stat-Signature: 9zroi16arib9e9niq9gghytsdqs6bkwa
X-HE-Tag: 1763909393-469374
X-HE-Meta: U2FsdGVkX19/u4xCUcWJNcDPcvBg69L1IN5xVe43lPt7j++W0JELkdBWyBvIRJ/a+JoAoYUa7A6Wm65THp3Jl40c3qg9u5LFq3T+YPKRX/g6MLgBNSrcXzSEY4OU4s1d+ssXCVf5bLKPtd2JsvGL3Q7Gf4RuU0DsxkYlKBbOHMxTI3aFTbFbVunWLGyGGXFMr3c7B7t61lGoHcWvXiZGrMWTgXAMyFW2oGb3/nxqMlVEReXfIe1V0qluY/iNp+G0L2hd28z/nfNxvAGtvLp/15IvzqQEj7pNR4SKgRYo7bYgpb2959Tz+zH7aXMFbc+58BF0a9AnN0e251gtRvFfhRC33SaCc9DV5aVFmDO5OTIhv6YiqzOXQC0deNKbt2vsNZONBFwFgMh787dSP53UgtcYWpQnvbiXIpqySNzo/2cEEpNBqBQfWkCId+jgkbfBb5nvBTAPmdRUuRP8P9W92r+tq5X5lLXoqJkC9KFGqUsrWQPAdJ3HlVpNoreiF1yif7uARBgofhxov/4VdiNSceVseFE2ZVLowLw7ezF0j9ZYAn/X8KhdqqndrxbpCykZOo8sz8ebqNAj0cf/Sis7Y1XsIr8QSiCYIwhKm8EEmAekChExOWYHawG9gEiTduIQrnIlf3WcBS3C76aLCIy0kr8h4bXW9P8/t26Ac98hP1UesitV2WbmtiHJ49AQqIOQ9ByuJrJNKoOArtatQrYobTvBM4rhJxuDplLIp1A3+SjYSZI42ir8p51NdC1/RspFcXU5UW/KLnXy1m69lEvdUam/fy71bs/clOWrsG9m3xPTq9wUA82IoFQiB+fQ9eI6I/ghWQg2dSaf2/SzktON9Ub5l7kZnwFEyWcH8UBLRLJIM6/r2ZheXdi2NSDEv3WcndfSA/QXB6xtd4XTdZSVHM2yUvY/94w3CirBwqsYW6bAFy/kwKI0nvPImqzCD7CGWYh6g3FLQeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/11/25 6:57 pm, Shardul Bankar wrote:
> When collapse_file() fails after xas_create_range() succeeds, the
> rollback path does not clean up pre-allocated XArray nodes stored in
> xas->xa_alloc. These nodes are allocated by xas_nomem() when
> xas_create() fails with GFP_NOWAIT and need to be freed.
>
> The leak occurs because:
> 1. xas_create_range() may call xas_nomem() which allocates a node
>     and stores it in xas->xa_alloc
> 2. If the collapse operation fails later, the rollback path jumps
>     to the 'rollback:' label
> 3. The rollback path cleans up folios but does not call xas_destroy()
>     to free the pre-allocated nodes in xas->xa_alloc
>
> Fix this by calling xas_destroy(&xas) at the beginning of the rollback
> path to free any pre-allocated nodes. This is safe because xas_destroy()
> only frees nodes in xas->xa_alloc that were never inserted into the
> XArray tree.
>
> Note: This fixes the leak of pre-allocated nodes. A separate fix will
> be needed to clean up empty nodes that were inserted into the tree by
> xas_create_range() but never populated.

No "fix" is needed in this case, the empty nodes are there in the tree
and there is no leak.

>
> Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> ---
>   mm/khugepaged.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..f2fe7924afa0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2230,6 +2230,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>   	goto out;
>   
>   rollback:
> +	xas_destroy(&xas);
>   	/* Something went wrong: roll back page cache changes */
>   	if (nr_none) {
>   		xas_lock_irq(&xas);

I believe that the correct explanation of this patch is - after xas_nomem, if someone else
expands the tree and the retry for xas_create_range() trivially succeeds without using the
node allocated from xas_nomem, then we need to free that node. Although now I am worried
about other users of xas_nomem() which do not call xas_destroy() on failure path...

I think this should work,

Reviewed-by: Dev Jain <dev.jain@arm.com>


