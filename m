Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91F2F3C24E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2F06B0089; Mon,  9 Mar 2026 09:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196E66B008A; Mon,  9 Mar 2026 09:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4766B008C; Mon,  9 Mar 2026 09:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F10CE6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:33:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD20BC01BB
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:33:06 +0000 (UTC)
X-FDA: 84526615572.03.3969832
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4ABA20015
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:33:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAYU7+mK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdLEkrOqH4JZC/ZsghgXRnGoatIq9erMDMBXBdvGaSI=;
	b=rV4myrJr0GCC36Jd+M49UZGnEN7qZEP9vIAfe37IacILBABfgTYfmb6OMOPUBADLSj9v25
	sAA5P1swPEswKnuR6GCdHnk8y599aw/iBECCJEjYes9tJTC+69kBjEE55ihgP851a+6O7Q
	Zk8fFDLzgiaJVX4NZ0OxqNxsAiAhjfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063185; a=rsa-sha256;
	cv=none;
	b=d5ThEjOluyppYUgczn9EzK2nJDaVISVVX+vLWQeb0NfWDmjRstUyOuj2aS3F278nDcraZD
	wpgnq5qRMhwoz0kTHGCFP21ZiMc8xSxJ2RbODW8bb7eLZdo6CgosbHywuNIL0h30zsHVNH
	//ukMvm4Su2zBZJ9wGnKm/U3Ok5YmQ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAYU7+mK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7964443D4F;
	Mon,  9 Mar 2026 13:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB065C4CEF7;
	Mon,  9 Mar 2026 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063183;
	bh=yhlUUqp7GAXI5ZyQFttmUdbt0W8IKo1t9jzgxe5K584=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cAYU7+mKpl1Bsl1LY1GvQN7el0dIJRlv7INnVOEMHGdBZ1cfqAJ9K4HVxDzjSfBI1
	 31x17t5Sfo7r0sxTq1/jPq+L0akRrv9d8x0YuHJEMaFWCN/ru0jbo3+Y48Y3zpX7dy
	 bjUqdxBUDLfra6v/bCwxel1DflVLspaaDYlAl50AK3w5QVQZBBnt7Ly08o/xSdyf82
	 +yI1FMgyxP5hYES9MyaaaELEYfMky3aWi7v9lW7kUtGAZLfCu5SmG4a8FzSnNBTeK7
	 3oRVJe7qrm+ysvGvb1FQ5P5hh81MevAnierES3yWbhlPEFk6zntvHSulgvpkhcGg3E
	 FJKu8lgxWcgvg==
Date: Mon, 9 Mar 2026 13:33:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 4/4] mm: ratelimit min_free_kbytes adjustment messages
Message-ID: <10c63265-dda8-4272-bd5e-a9744390ceac@lucifer.local>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-4-926b9840083e@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-thp_logs-v4-4-926b9840083e@debian.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4ABA20015
X-Stat-Signature: xitxqw667atzmtnifxw5bo7qe9nu1x6b
X-Rspam-User: 
X-HE-Tag: 1773063184-164579
X-HE-Meta: U2FsdGVkX19q0AKH8fqJIx2zYCwkW1JU9QCNXFKOnqQr5t2dLNhwu6QchP+uctuiuQEO1t3gvFF74ydwsW5u94RvQFulaquFpIk2stjm4X2RVHEgCU6UsYnoTjqaL71t34IPTh28oH2OLZOY03UV7oksA4cfqNk4mlqf8SgSt0UFJHw58ugLNPsHIbrcaVOSwTbLHpYpx0xpppALAHvU/aG8S20sqbamY/H0FI8DBGCeRWwb9pr52PPO4ZzHIw6xIhCw0BSjtQ66UJJOekK02ifv9XoN27VbuE2hmwyB6QSKm+nuwttorRpFxnVrWuBPOjwr27jG1oxHjB+Xc2n6DLFfJcC4UivlRcoXwvWxl1e84YJbBsPH1C1Q5TKn6GH/YGncdbVgCfCueWBuI5q8EUP5zWnu3iubGVMklL5c6zJDZgJoQv+33fE1FDajTmsnNRhX22+pkUCaNlcdyCW3W2uvj/pJ7HmbtuyMWZ8WB6Ec8c6WHBn0VLzrmktwr6BcbaLhbV03yC+1qwgHDPuuhyeH9MNyyw0NyjPqeuJXMn5JY2rwDX1C3fze05nRtOZdkEafzLC4hLCSQfyjGrrBv9F01o+BSxvJizTI/rG83RsDP8XtR67lPKgXhYIGV3kNNGwXWJLAqqEe4HoOilsrqQv+9BxKvPB3v3vQAD131wICJ3AGt7By71MA9IdJPjr8BizgCU0c4XBstygEBhwjckLw5/c2mDRqwJWjTjff45O45UGFyY9K2UMkvanl+3ml5MAzBXn3u8/aacVeMF/BTdmKdOTskscBd9VP8hwpBIWoWRbOsRsC60H581Yv/LSGrMYjL0gO6ljhVxwXHpc1Y2LsPlI7oim3CdIw6zNvbmep+QVENlR6rv93E4Vbj639zWniwQ2eFtvZxKGb67PmKbtR5gzI2LLrZAjzdAjcHlKOuu1ae6osn17D7OlylMPkr7U2zAXRpwUmdtIFw37
 R5sVoZGn
 eIU4Wqpcdr6kDvpEGfnygaNxTvF7oq/YdUBXpkVbyepSNrCyRa9rxusOGmX4qvH+OXSZ84rjil9Z6Z/2gBIpsSbSjLGDRuKjBEkSzx4zZwlMcts19A4yVOKweDyhMRK9qK7gNwmcrau93i3Tc2kTlQa5jWYcdh3KtUBKArU1uXwdWia7c7l0/X2dNDCrtgBp43o1gFzrd5viuRlfsmlvLt2EeX6I7RJbHjNEPZBhmCnbe/lJjtTCdVBHm/Aw5Cjj3iq61PqZC1CKJ1MsWwW81mdh4HRSrbD3TgY3iLabodIO6yfxi7w3a/w8P4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old mail +cc new one :) [it'll take a while for this to propagate I know]

On Mon, Mar 09, 2026 at 04:07:33AM -0700, Breno Leitao wrote:
> The "raising min_free_kbytes" pr_info message in
> set_recommended_min_free_kbytes() and the "min_free_kbytes is not
> updated to" pr_warn in calculate_min_free_kbytes() can spam the
> kernel log when called repeatedly.
>
> Switch the pr_info in set_recommended_min_free_kbytes() and the
> pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
> to prevent the log spam for this message.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 4 ++--
>  mm/page_alloc.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 56a41c21b44c9..d44d463ccfd3e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2671,8 +2671,8 @@ void set_recommended_min_free_kbytes(void)
>
>  	if (recommended_min > min_free_kbytes) {
>  		if (user_min_free_kbytes >= 0)
> -			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
> -				min_free_kbytes, recommended_min);
> +			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
> +					    min_free_kbytes, recommended_min);
>
>  		min_free_kbytes = recommended_min;
>  	}
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554ed..c840c886807bf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6553,8 +6553,8 @@ void calculate_min_free_kbytes(void)
>  	if (new_min_free_kbytes > user_min_free_kbytes)
>  		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
>  	else
> -		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
> -				new_min_free_kbytes, user_min_free_kbytes);
> +		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
> +				    new_min_free_kbytes, user_min_free_kbytes);
>
>  }
>
>
> --
> 2.47.3
>

