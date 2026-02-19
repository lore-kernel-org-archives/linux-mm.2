Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CC8C531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA6D6B0088; Thu, 19 Feb 2026 17:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68356B0089; Thu, 19 Feb 2026 17:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C956D6B008A; Thu, 19 Feb 2026 17:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74D96B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:33:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60BF2BBEE8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:33:31 +0000 (UTC)
X-FDA: 84462659022.13.3A1CCA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C3ABF4000B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:33:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NBFnaQyi;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771540409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFc8ym6gZuICbQU21rVdF1W9JGroD4kIIacLNFrrQyg=;
	b=dqOcjnUvCnzFWXK0m5yAJDiFSf4eym6dsS/GM2z+YSCo0riFYjlroDG89t+B80lgscWtE4
	w9B0Rs9R4bvkdJdT/WEwzPdjSKFdYTF3w3OvEzmgv49LJlrvhHhMDscwhLKrUX3MG5soYW
	oflPttWO5j68V0/MXb5qtnQ3LEUqWg0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NBFnaQyi;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771540409; a=rsa-sha256;
	cv=none;
	b=kYFcr6Bnn6+PufeCz3rmMXQ3pWTFgLYplY4kln+0W3WspYJSTVJc85M/vlvSZfT608+kBx
	PpxDfR6/wHJ3np/QlL1gz7l/xtK+ZXQBplCuBLdQDua+qJGLnUfTSIIewceQsXx9yB67J4
	hcc3FrcFmsFnKjcTs9Bs3LV0zCRm2rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 253BA60131;
	Thu, 19 Feb 2026 22:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E872C4CEF7;
	Thu, 19 Feb 2026 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771540408;
	bh=W9HLRQM9kqFpJqXVvPFl/ReXTVVBlA9Iv4Py9xp2Vgk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NBFnaQyioKKw1bIV5AcFUa9w94kDnQ2v7fOfXUvRvawLkMTHvWO9edHXl7gFEvbsf
	 OZMlvWsTY7IKgqoKwAMv+VszsCdHhpQ/VsNVKf2IesBtXt7hHTKBSV62mkuQU57wpt
	 smtqjGhkuSuYv+2zbDWUv1GfNLqSZ5CjArIdGI5Q=
Date: Thu, 19 Feb 2026 14:33:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] khugepaged: convert redundant check to WARN_ON
Message-Id: <20260219143327.7693e4b1474a337821e4c637@linux-foundation.org>
In-Reply-To: <20260219054827.4111334-1-dev.jain@arm.com>
References: <20260219054827.4111334-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3ABF4000B
X-Rspamd-Server: rspam02
X-Stat-Signature: utd6jbjd1ndaot9xd9ep5emd6bfnxu9k
X-HE-Tag: 1771540409-270085
X-HE-Meta: U2FsdGVkX18j4wk4d3eBvboXnKFdFeCuqLHVzsZEviPYxhWCuwuvVvr1SiKar+rzpABw8WxqEjMxiGLcgncTxgzYoHBUoAfbRVKbUq/HWT3x6xbqdrEWvh4Nb3YL/lwEWuCNH4plOJS4agrimee4/HufI4p1af4OLAHKkijD2lP5aX59FEcMU1J7m3fuTTfSmQizzWGZ8yRXN3s+3he68qwC170ZbyeEq7n114t5tGMPKW/yV3LgJrXd4MQOweeZO5xTrteYKNpZT6KWkwR/7taABx+p4LRtiUFamJ7bhhxg5/qEeJOWnqalZTWn1EjM733ohDYGR8Wt6FR2tgyANosMl8TXNZX1zoowkgH45/4Dd2WP2ldBwYDOR/lwORQCtU2GeQ3T6abJHYoaM3MPW8F6MAQ5Oz+Xuip921626elhA1pR/yHfzxO+2iVhr2uYWxas8Zh24i89v5jjRX7/0X/ikQl7Fam2LPqlhuwrpJYiZ4X8gtYKsLcUdnhFVPHYOnb3am2TNIEaxxvmVXJdM07ser/wtVxo+EdOiUhdNLKaloLyYiUCoEtRKDZM54U18Q89J6dUhUKak4U2r8yfcuBicpBLc+8cOR+As4BdtuJnYrxAClh42XQDbK/0ouqTzWAe7QiV1E9HiaxxOBbbROMIRwCgDirI4zLugMteQjjRe4K596VURq0GvVKopg/QaHZxBfoq5XKq0fp7P6uDmlDl9LOoI3St+P/uOisMlmmX0fu6OzkM0LuSYMbrZmUAWK8GExkIuaKYD3S29pMIzLmkXIfVdQpcFWCeX+6j0HVCBuoi9ndF+vt0IQuyzoTQZ7nP5irs+3MuZbrAMsYcIajQYZ0MiBVkIeYEG/ZNiUGrQfhH/4wNKxHdY2qhOqtqQEn+ng5Wtb91Y3ytYkUasLmwwELILGXQ7HOCCNnIGBkQyXgOT7TzrP4l145sKq70pZvag8XfMdd8Nh1wSnD
 dNHTPEWv
 C5fvXxpBzh/3WOKpZwudw/biNT/4BNtHL8PISmXoEzAsfUnBTu0300NJws+cc5L5P+TiXOm6CleNKLG/V9lIIzwdKql6elx7Zm5wBGXgfOeJAYVSFSE0vpBLEtx6G1zu11GhU581j2DgTJLJaVzaH0dryIKk1hEj7CbwxXh71OrOGvWL0e8VTsoQ+gCniXTqa44dKTfYd5hMA+SzZFbjFjnCpf5tbmRcfCdRgahiBnzrICbd3cr43HFLDvw1k2z1xIibkdRPREqtlOI3yEMH3miWQgX7f+jJ4i3EZhbAYqVgVbSp1UqFrkWwak1Ii8Thtp7a7vAewGjQnJwqUUUGWd2XZgsb7t2LUBbn6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Feb 2026 11:18:27 +0530 Dev Jain <dev.jain@arm.com> wrote:

> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, convert this to a VM_WARN_ON.
> 
> ...
>
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2000,8 +2000,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
> +			VM_WARN_ON(folio->index != start);

It's a bad sad to remove unneeded code by retaining that code and
adding even more code.

Perhaps add a comment reminding us to remove this altogether at a later
date?


