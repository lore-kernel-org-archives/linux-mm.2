Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2314F1093176
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BB16B0088; Tue, 24 Mar 2026 22:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC526B0089; Tue, 24 Mar 2026 22:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2316B008A; Tue, 24 Mar 2026 22:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFA46B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:01:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBE8D59CCB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:01:48 +0000 (UTC)
X-FDA: 84582934296.23.3DE8AB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4F5D1C0003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:01:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a6BTMAKi;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774404107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QlJpKzAONlfb1yiCsRHSx4sFm672l9HVeG8rYpupV0=;
	b=Wbzu3I11fFAHdqrhNQoYdpMimHNshkdQnm+lOlA1PXU+RgZPiK2WXjEY9U4KUrkVgWMbDX
	ReqRN/mI7RgCeV60qI44L+emmxdPTGUkJTdfM7D/zVXnyZraUzwq4lTL++vD7+wR6R/urK
	3EaaqBGkPO6qb2kZbPXsDOM0H0jWgjU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a6BTMAKi;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774404107; a=rsa-sha256;
	cv=none;
	b=clAUUx8Ne2XLrbT6wkePdvgtrvy1vpArzajuUo26lEq0mccFIdQyaUzYSVVgeoOJ04apRu
	XiDGO9RfKX/5zLOlxXYhhUInYl0sx6UHo9kn8hmvFYcyV+TAndtIk0k+/PwnbbPQhTWrDp
	/QgzJlQGtrpCReDK8Bs5pAGE0F9Z/sg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D11FC401CA;
	Wed, 25 Mar 2026 02:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B8C2BC87;
	Wed, 25 Mar 2026 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774404105;
	bh=OJA4rPTEMHQasW/R9/vNywmTL1ETH5CuFi0kF4oFxZQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a6BTMAKi0Zvluy9YkudqFncXj1t7yhSodNyCgCdFita/m+Awwk35d1/DZ9Dqh8IN7
	 YNY013qddU1u114CwKroDBf5kRGgl9dKfrxcUI4SGOudgRaCKM7PQvYhDW+9iX91XI
	 emaKqUViQj4KsID9DAFD2GK6puM8qm/lytzRQzjg=
Date: Tue, 24 Mar 2026 19:01:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>,
 David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: Fix possible deadlock
Message-Id: <20260324190144.019600ff50d0734233e07bf9@linux-foundation.org>
In-Reply-To: <20260325004653.150734-1-ethantidmore06@gmail.com>
References: <20260325004653.150734-1-ethantidmore06@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4F5D1C0003
X-Stat-Signature: c4gng1k69abnqar6mpwdn3s3txea7shy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774404106-610148
X-HE-Meta: U2FsdGVkX19eofSTEJ5S/vQsVP/RcN6v/64m8YruNo2vWZ3S+ah7mdNsW5VMvOphxWsmzUTqa8ZMljKrwAsSTafp1IB9xCbvfkk1itUfn0acWPQhQngfu/pKXEZo+3klYF7EDOIqwESOM+Y4YaZvt4VAJkwLhmW6qC+j6H0hntzpfKbfR26VQXtIUwuRC8dxtMwfX65G16jffDAJYaxhnhT4OBUOgplpc0iHfUvzwtfl9u+gz6L0GRUfj0s88XAOXSuQvxsdDvk0foeXmwEnZ8+AJdCF4sb1wFPrKheQEVLP1HQZqHjMjqAyP3AHiy4l+D8A7aehq8wznbnxz0IzdlUZNXEdKjPsIvchYLumZoUbztUcuDlgPqfhRCed79bDXV4RDjdwSo50GPzXQsBpLCTGuAzBcGrPBcrs1qk5ybfo4sFAJzDZkVFHhMqPo+4uLhTtoWAeZIzpXYLDzCMKXl6qNIHWh0CQ67aWsTHwW2MzqRrLi199+sG2c1drlIbaF0p21tLV466vs1IT1d5+EISccrWzzOFlH8BX0bfRT7UXKKz0wqn1Bz05lCZYx6BSKn/KlYBBnGKajxJw2psustYp1cPWHRL4N9uFXdr4goBuHy6ZhDXgmcl5sN7FSWkrIL9LFC0nbDxS6QQNmOamzrW9/BD7C35ia4/QtgRHmdHt8dLGXs3amqpLuKNTpiJBb4TekdOdEOVBpcLSbF6p2tOF9Y+yj8e1Hw3xn2nqNT+zJQhYZKzKoZ/H/0pHDBu4Y15usFyScGGGPM41KOgYR8VNjha79LnjXLFHOvfOEYxeSTJixwoP+HkGGCJKjdk3zL26To0qjhYSBRyYc8k6+mxOC+ekhlXe1JTBLIffxLY4ipy8+6I1Zfv38RfS5+VDBHR5739KQ0GeftzZ2wfHQl7dOlVWZ7z1WnifUZxGPcjsekaR9BdSCChrUbzILFHUUUAFhZ/bWy5ulLKtCLT
 /9Ho3Koc
 0/qi/APzalx46OXU6K2rzFwM4Wd7rCkl6p7i+03MC7Eysk78StROxpli+rd2L15p8Np+PtPX46h28B/PQuPz48bhoNRS3x3MhWH67Ya5noMAmD1m8QlqNO86O6S0GbeKUGGMLeUoJAjOOsAH7Yt6tUihkcqKBRNg/ev9dfE/JsUewHvDa2CXM2v05C7f+ywD/Lob65GY0DantwJCYo9qHA1IkIv0l0TgB8rq7EOW4nkUvutMkurOo9X8cdlinEfb3ZuVh7WtRhws9c4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 19:46:53 -0500 Ethan Tidmore <ethantidmore06@gmail.com> wrote:

> In allocate_file_region_entries() error path the function region_chg()
> returns but does not release the lock 'resv->lock'.
> 
> Release lock 'resv->lock' before returning.
> 
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -807,8 +807,10 @@ static long region_chg(struct resv_map *resv, long f, long t,
>  	if (*out_regions_needed == 0)
>  		*out_regions_needed = 1;
>  
> -	if (allocate_file_region_entries(resv, *out_regions_needed))
> +	if (allocate_file_region_entries(resv, *out_regions_needed)) {
> +		spin_unlock(&resv->lock);
>  		return -ENOMEM;
> +	}
>  
>  	resv->adds_in_progress += *out_regions_needed;

Thanks, but please see how allocate_file_region_entries() leaves the
lock unheld if it's going to return -ENOMEM.


