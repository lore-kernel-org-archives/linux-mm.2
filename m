Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9E9CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F238E0005; Fri, 12 Sep 2025 12:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE978E0002; Fri, 12 Sep 2025 12:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04A28E0005; Fri, 12 Sep 2025 12:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB2728E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:13:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E25611AF20
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:13:15 +0000 (UTC)
X-FDA: 83881092750.21.93B2572
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51A661C0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:13:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=epZf1NZ6;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757693593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8EycLHCQ1ab18SBt2ew+m+Nf9Rse51xt4sZeCcpwKU=;
	b=Hg7ek8kDTeU0oLS04fgZ/4JK79k1dgGtjP1t6MW7J+S6jkFUmZ8TeVM8ubMLvaXZgE/hL5
	YBycyddYYdBFcXTj+b6x9dar1K6yegDoHtuCeUDpTWIKcMzJcZN8noiTnJEk8sB8JQsR2n
	kJsTLBN9+oPNlWorLAUbbra1+DiERso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757693593; a=rsa-sha256;
	cv=none;
	b=KOKOMTjOAtG8k3p41mUavDHGp/rEJyQHvU7JZg3OJEGeVP6SQjq9ZbQUznJcFO+NLJPcyr
	CPTmcJhttgmeyVY3Bf5bpNpRGkfeiCLI9/n6si0Vc8jILSTa+J9sq13ag8XNOZBfk3uG3f
	OV+KhvpAFhvf2m+dnn3OrGGxh8Eunbc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=epZf1NZ6;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Sep 2025 09:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757693590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L8EycLHCQ1ab18SBt2ew+m+Nf9Rse51xt4sZeCcpwKU=;
	b=epZf1NZ6MtODr26KHOCJ6w57aBjFtc8qnGUh/M8xLbRAVFGsAQYr9wPTqrQE3aOknly5pD
	77fmvTRZSQ6pLHiBa/WcLzC7ELXFsbWSBYfL/56Cbv1CPJOm1GZKSkbAGOJ3HB5atJFG5a
	+rlNMSY1+2LO3q4yoEhtJSa16Fzi0uw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
	hughd@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
Message-ID: <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p74o7kas39njj1tntwwggyk7h8i8wjfz
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A661C0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1757693593-419022
X-HE-Meta: U2FsdGVkX19w0pInOYAfFXAzoOZ7XNama9m0DeXEXHDBOCfMBFmP7mU2UHPqIX/oYqwWfW7TnzO/7AM0VcNP/4tzEA0DaLUDMu9TU7wNvl7WkTd5XIkRYxBFYGBoJWzvCR6F/kI7HFxTH2vIvQBY1slX1jiSE0oX8vjTsCIMEAiurI9YPNIBIasMXnGFR22pxj9Pkr+AZvlsCY6ETfZYKrx6woT2pZKJielGYPZyQsM6FNBEW77op92t5NMMEch/B1RzebRzR7cy5fGiW0zZeCkYAJ8BdbBGdMtJ7VEZ4H203e4W4fE9hxOgcWndH/1KSD2h2qPN2/4y81CYNKC9Idou+U0dFpJ386XpV3pu2cWeKibZ9oK0jKa+NpTFJDbL5addZWhEpEih1huuL1HPmkO9kEZPblqxVOdbK44TiBd3m1Nu2Y13jevpOnTVH4K5cKlMN3BupDOCyElQCOToYz5f125dMhUCXn7VadgXBIKotZVw3CfiODWdNJabn1m911b0nP35LpkZPzrhXipN/tOisjrcoRrcAWW+X50qwyvoMiAte5VxoGRGhOPyNLRCNZjGo7eBIY4IB/Q+us6eORWa5KhxBOpSba3nFq347TOilOn6PuDvpNDqpdr8ip157N1WmjJyQkKSUI/j0Lj+UV26pf+0SBX7khRryB7ovO7kL8dHEJQeYPgrPL0bCPT4VU6VHbdzQ9cU4ATIcIOV39jpfT/52uoYLGEne0tIvnPjhAxFYyx/5TL7JLXKGrlTtWmCkwq3pD+kJwNhjGgEaihA9SJiBXBHHCOkSzBN8yIQ6bEV9aNi85rLT2I89HzhGeVHePXIGoeRqHZom4f2uZCWC9E9YqvbrnMmpawPqNKqXEhVTm22FquvrRgeOwyzeupxd1NuZ56uZfHrO2xfyn3tJPEpoUMStujnxq7PdsO10pwPs3bSx9sxkvcqlZKvPCoy0BsQZ2afGxeyMEd
 XdleNFSi
 4J1J7x/9dclaVp4K4QmFRllyEO6BeHT+X88PCC9IwDjOqRjUWEBuYH1h4IRaajw0vutFfTUxRT6CsHg3ps0y7i/NV5bqgEhNhcFyH0Cb3qtqXeRXRymdQGXEMcsZMf8zPI8uPDDrGlES4duyktd7HOTdL3kGWx+XfNwWdeKJt2Fb5Z/Js3WsJYph/0TmuS30oiafb5BTv7uz0f3LZAotKFxtNLDMq+8wC4py3+hizSJPMt/rQX1B2+bxb/3lzWojJlP1u1cnfZNJbr6/FNOYRhf+sUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
> Currently, we no longer attempt to write back filesystem folios in pageout(),
> and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
> which means no fs-private private data is used. Therefore, we can remove the
> redundant folio_test_private() checks and related buffer_head release logic.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/vmscan.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f1fc36729ddd..8056fccb9cc4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  	 * swap_backing_dev_info is bust: it doesn't reflect the
>  	 * congestion state of the swapdevs.  Easy to fix, if needed.
>  	 */
> -	if (!is_page_cache_freeable(folio))
> +	if (!is_page_cache_freeable(folio) || !mapping)
>  		return PAGE_KEEP;
> -	if (!mapping) {
> -		/*
> -		 * Some data journaling orphaned folios can have
> -		 * folio->mapping == NULL while being dirty with clean buffers.
> -		 */

Can this case not happen anymore and try_to_free_buffers is not needed?

> -		if (folio_test_private(folio)) {
> -			if (try_to_free_buffers(folio)) {
> -				folio_clear_dirty(folio);
> -				pr_info("%s: orphaned folio\n", __func__);
> -				return PAGE_CLEAN;
> -			}
> -		}
> -		return PAGE_KEEP;
> -	}
>  
>  	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
>  		return PAGE_ACTIVATE;
> -- 
> 2.43.7
> 

